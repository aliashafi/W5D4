PRAGMA foreign_keys = ON;

DROP TABLE question_follows;
DROP TABLE replies;
DROP TABLE question_likes;
DROP TABLE questions;
DROP TABLE users;

CREATE TABLE users(
  id INTEGER PRIMARY KEY,
  fname VARCHAR(25) NOT NULL,
  lname VARCHAR(25) NOT NULL
);

CREATE TABLE questions(
  id INTEGER PRIMARY KEY,
  title VARCHAR(100) NOT NULL,
  body TEXT NOT NULL,
  user_id VARCHAR(200),
  FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE question_follows(
  id INTEGER PRIMARY KEY,
  question_id INTEGER NOT NULL,
  user_id INTEGER NOT NULL,
  FOREIGN KEY (question_id) REFERENCES questions(id),
  FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE replies(
  id INTEGER PRIMARY KEY,
  question VARCHAR(100) NOT NULL,
  body_reply TEXT NOT NULL,
  user_id INTEGER NOT NULL,
  parent INTEGER,

  FOREIGN KEY (parent) REFERENCES replies(id),
  FOREIGN KEY (user_id) REFERENCES users(id)
  -- FOREIGN KEY (question) REFERENCES questions(title)

);

CREATE TABLE question_likes (
  id INTEGER PRIMARY KEY,
  question_id INTEGER NOT NULL,
  user_id INTEGER NOT NULL,

  FOREIGN KEY (user_id) REFERENCES users(id)
  FOREIGN KEY (question_id) REFERENCES questions(id)
);

INSERT INTO
users(id, fname, lname)
VALUES 
(1, 'Michael', 'Torres'),
(2, 'Alia', 'Shafi'),
(3, 'Stanton', 'TheMan'),
(4, 'Jobin', 'Tinkle'),
(5, 'Kevin', 'EatsToMuch');

INSERT INTO
  questions(id, title, body, user_id)
  VALUES
    (1, 'what''s up?', 'Tell me how you''re feeling', (
      SELECT
        users.id
      FROM
        users
      WHERE
        users.fname = 'Alia'
    )),

    (2, 'Who are you?', 'Tell me what why', (
      SELECT
        users.id
      FROM
        users
      WHERE
        users.fname = 'Jobin'
    )),
  
    (3, 'Who''s Stanton?', 'Tell me who I am?', (
      SELECT
        users.id
      FROM
        users
      WHERE
        users.fname = 'Stanton'
    ));

INSERT INTO
  replies(id, question, body_reply, user_id, parent)
  VALUES
    ( 1,
      (
      SELECT
        questions.title
      FROM
        questions
      WHERE
        questions.title = 'Who are you?'
        ),
      
      'you are weird!',
      (
        SELECT
          users.id
        FROM
          users
        WHERE
          users.fname = 'Stanton'

        ),
      
      NULL
    ),

    (
      2,
      (
      SELECT 
        questions.title
      FROM 
        questions
      WHERE
        questions.title = 'Who are you?'
        ),
      
      'Don''t say that',
      (
        SELECT
          users.id
        FROM
          users
        WHERE
          users.fname = 'Jobin'

        ),
        1
    );

    INSERT INTO question_follows(id, question_id, user_id)
    VALUES (1, 3, 1), (2,2,2), (3,2,1);