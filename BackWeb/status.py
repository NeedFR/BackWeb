from flask import Blueprint, flash, g, redirect, render_template, request, session, url_for
from werkzeug.exceptions import abort

from BackWeb.auth import login_required
from BackWeb.db import get_db

bp = Blueprint('status', __name__)


@bp.route('/', methods=['POST','GET'])
def index():
    if request.method == 'POST':
        creator = request.form['creator']
        eventname = request.form['eventname']
        error = None

        if not creator or not eventname:
            error = 'Creator and eventname is required.'

        if error is not None:
            flash(error)
        else:
            db = get_db()
            strsql1 = "SELECT u.id, e.id" \
                     " FROM event e" \
                     " JOIN user_event ue ON ue.event_id = e.id" \
                     " JOIN user u ON ue.user_id = u.id" \
                     " WHERE e.eventname = '{0}' AND u.username='{1}' AND ue.role=0".format(eventname, creator)
            
            a = db.execute(strsql1).fetchone()
            db.commit()
            if a is None:
                error = 'No such events'
                flash(error)
                return render_template('status/index.html')
            strsql = "INSERT INTO user_event(user_id, event_id, role, curflag) VALUES({0},{1},2,1)".format(g.user['id'],a[1])
            print(strsql)
            db.execute(strsql)
            db.commit()
            return render_template('status/index.html')
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
        " WHERE u.id = {0}" \
        " ORDER BY ue.curflag desc, e.created desc".format(id)
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
