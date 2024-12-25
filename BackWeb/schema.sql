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
--hashcode for 'aaa'
INSERT INTO USER (username, email, password) VALUES ('Clark1', 'Clark1@163.com', 'scrypt:32768:8:1$LfvMsOCRWBPdSEmH$6772b25acbd40840296a4034660cd68cb8ae02c6f3a504dace5b461e58b75e03ee47549f06b8aadb3a1a130a9e9bbead247d354a161b7a379f66830dd2d171f7');
--hashcode for 'aaa'
INSERT INTO USER (username, email, password) VALUES ('Clark2', 'Clark2@163.com', 'scrypt:32768:8:1$LfvMsOCRWBPdSEmH$6772b25acbd40840296a4034660cd68cb8ae02c6f3a504dace5b461e58b75e03ee47549f06b8aadb3a1a130a9e9bbead247d354a161b7a379f66830dd2d171f7');
INSERT INTO USER (username, email, password) VALUES ('Clark3', 'Clark3@163.com', 'scrypt:32768:8:1$LfvMsOCRWBPdSEmH$6772b25acbd40840296a4034660cd68cb8ae02c6f3a504dace5b461e58b75e03ee47549f06b8aadb3a1a130a9e9bbead247d354a161b7a379f66830dd2d171f7');

INSERT INTO event (eventname, created, updated, hornored, comments) VALUES ('Chiristmas', '2024-12-23', '2024-12-23', '','For test');
INSERT INTO event (eventname, created, updated, hornored, comments) VALUES ('ESTERDAY', '2024-12-22', '2024-12-22', '', 'EASTER DAY');
INSERT INTO event (eventname, created, updated, hornored, comments) VALUES ('Halloween', '2024-12-21', '2024-12-21', '', 'HALLOWEEN DAY');

INSERT INTO user_event VALUES(1,1,0,1);
INSERT INTO user_event VALUES(1,2,1,0);
INSERT INTO user_event VALUES(1,3,2,0);
INSERT INTO user_event VALUES(2,1,1,0);
INSERT INTO user_event VALUES(2,2,0,1);
INSERT INTO user_event VALUES(2,3,3,0);
INSERT INTO user_event VALUES(3,1,2,0);
INSERT INTO user_event VALUES(3,2,3,0);
INSERT INTO user_event VALUES(3,3,0,1);