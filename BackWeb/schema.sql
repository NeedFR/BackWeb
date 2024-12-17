DROP TABLE IF EXISTS user_event;
DROP TABLE IF EXISTS user;
DROP TABLE IF EXISTS event;
DROP TABLE IF EXISTS record;

CREATE TABLE user (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  username TEXT UNIQUE NOT NULL,
  email TEXT UNIQUE NOT NULL,
  password TEXT NOT NULL
);

CREATE TABLE event (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  eventname TEXT UNIQUE NOT NULL,
  created TEXT NOT NULL,
  updated TEXT NOT NULL,
  hornored TEXT,
  comments TEXT
);

CREATE TABLE user_event (
  user_id INTEGER,
  event_id INTEGER,
  role INTEGER NOT NULL DEFAULT 2, --0:creator 1:coordinator 2:watcher
  curflag INTEGER NOT NULL DEFAULT 0, --0: Not current 1:Current Event
  PRIMARY KEY (user_id, event_id),
  FOREIGN KEY (user_id) REFERENCES user (id),
  FOREIGN KEY (event_id) REFERENCES event (id)
);

CREATE TABLE record (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  guestseq INTEGER NOT NULL,
  guestname TEXT NOT NULL,
  guestcount INTEGER NOT NULL DEFAULT 1,
  registertime TEXT NOT NULL,
  user_id INTEGER,
  event_id INTEGER,
  FOREIGN KEY (user_id) REFERENCES user (id),
  FOREIGN KEY (event_id) REFERENCES event (id)
);

-- insert
INSERT INTO user(username, email, password) VALUES ('Clark1', 'Sales1', 'aa');
INSERT INTO user(username, email, password) VALUES ('Clark2', 'Sales2', 'aa');
INSERT INTO user(username, email, password) VALUES ('Clark3', 'Sales3', 'aa');
INSERT INTO event(eventname, created, updated, hornored, comments) VALUES ('Oslo Conference1', '2024-10-25 12:00:00', '2024-10-25 12:00:00', '0001,0002', 'This is nice event');
INSERT INTO event(eventname, created, updated, hornored, comments) VALUES ('Oslo Conference2', '2024-10-25 12:00:00', '2024-10-25 12:00:00', '0001,0002', 'This is nice event');
INSERT INTO event(eventname, created, updated, hornored, comments) VALUES ('Oslo Conference3', '2024-10-25 12:00:00', '2024-10-25 12:00:00', '0001,0002', 'This is nice event');

INSERT INTO user_event(user_id, event_id, role) VALUES (1,1,0);
INSERT INTO user_event(user_id, event_id, role) VALUES (1,2,1);
INSERT INTO user_event(user_id, event_id, role) VALUES (1,3,2);

INSERT INTO user_event(user_id, event_id, role) VALUES (2,1,1);
INSERT INTO user_event(user_id, event_id, role) VALUES (2,2,0);
INSERT INTO user_event(user_id, event_id, role) VALUES (2,3,2);

INSERT INTO user_event(user_id, event_id, role) VALUES (3,1,2);
INSERT INTO user_event(user_id, event_id, role) VALUES (3,2,2);
INSERT INTO user_event(user_id, event_id, role) VALUES (3,3,0);


-- Clark1用户创建任务xx个
SELECT user.username, event.eventname, user_event.role
FROM user
JOIN user_event ON user.id = user_event.user_id
JOIN event on user_event.event_id = event.id
WHERE user.id='1' AND user_event.role=0
ORDER by eventname;

SELECT date();

--Clark1用户参与任务xx个
SELECT user.username, event.eventname, user_event.role
FROM user
JOIN user_event ON user.id = user_event.user_id
JOIN event on user_event.event_id = event.id
WHERE user.id='1' AND user_event.role=1
ORDER by eventname;

SELECT date();

--id为1用户查看任务xx个
SELECT user.username, event.eventname, user_event.role
FROM user
JOIN user_event ON user.id = user_event.user_id
JOIN event on user_event.event_id = event.id
WHERE user.id='1' AND user_event.role=2
ORDER by eventname;
--设置id为1的用户把id为1的任务设置为当前任务
update user_event set curflag=1 where user_id=1 and event_id=1;

SELECT date();

--查看id为1用户的当前任务
SELECT user.username, event.eventname, user_event.role, user_event.curflag
FROM user
JOIN user_event ON user.id = user_event.user_id
JOIN event on user_event.event_id = event.id
WHERE user.id='1' AND user_event.curflag=1
ORDER by eventname;

