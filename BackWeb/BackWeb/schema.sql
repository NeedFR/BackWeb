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
