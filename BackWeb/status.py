from flask import Blueprint, flash, g, redirect, render_template, request, session, url_for
from werkzeug.exceptions import abort

from BackWeb.auth import login_required
from BackWeb.db import get_db

bp = Blueprint('status', __name__)


@bp.route('/')
def index():
    db = get_db()
    #最近三天有过更新的所有event数量
    countofevents = db.execute(
    'SELECT count(*) AS days_difference FROM event WHERE JULIANDAY(DATE()) - JULIANDAY(updated) < 3'
    ).fetchone()
    #列出和登录用户相关的所有event
    if g.user is not None:
        events = get_events(g.user['id'])
        
        return render_template('status/index.html', countofevents=countofevents, events=events)
    else:
        return render_template('status/index.html', countofevents=countofevents, events=None)
	


def get_events(id, check_author=True):
    sqlstr = "SELECT e.eventname, e.created, e.updated,e.comments, ue.role, ue.curflag" \
        " FROM event e" \
        " JOIN user_event ue ON e.id=ue.event_id" \
        " JOIN user u ON ue.user_id = u.id" \
        " WHERE u.id = {0}".format(id)
    print(sqlstr)	
    events=get_db().execute(sqlstr).fetchall()
    #if events is None:
    #    abort(404, f"User id {id} doesn't exist.")

    #if check_author and post['author_id'] != g.user['id']:
    #    abort(403)
    return events
    
@bp.route('/create', methods=('GET', 'POST'))
@login_required
def create():
    if request.method == 'POST':
        title = request.form['title']
        body = request.form['body']
        error = None

        if not title:
            error = 'Title is required.'

        if error is not None:
            flash(error)
        else:
            db = get_db()
            db.execute(
                'INSERT INTO post (title, body, author_id)'
                ' VALUES (?, ?, ?)',
                (title, body, g.user['id'])
            )
            db.commit()
            return redirect(url_for('blog.index'))

    return render_template('blog/create.html')


@bp.route('/<int:id>/update', methods=('GET', 'POST'))
@login_required
def update(id):
    post = get_post(id)

    if request.method == 'POST':
        title = request.form['title']
        body = request.form['body']
        error = None

        if not title:
            error = 'Title is required.'

        if error is not None:
            flash(error)
        else:
            db = get_db()
            db.execute(
                'UPDATE post SET title = ?, body = ?'
                ' WHERE id = ?',
                (title, body, id)
            )
            db.commit()
            return redirect(url_for('blog.index'))

    return render_template('blog/update.html', post=post)

@bp.route('/<int:id>/delete', methods=('POST',))
@login_required
def delete(id):
    get_post(id)
    db = get_db()
    db.execute('DELETE FROM post WHERE id = ?', (id,))
    db.commit()
    return redirect(url_for('blog.index'))
