--
-- psql -f createdb.sql -v db=$db -v passwd=$passwd -v user=$user
--

CREATE ROLE :user WITH LOGIN PASSWORD ':passwd';
CREATE DATABASE :db OWNER :user;
GRANT ALL PRIVILEGES ON DATABASE :db TO :user;

CREATE TABLE films (
    code        char(5) CONSTRAINT firstkey PRIMARY KEY,
    title       varchar(40) NOT NULL,
    did         integer NOT NULL,
    date_prod   date,
    kind        varchar(10),
    len         interval hour to minute
);

CREATE TABLE distributors (
     did    integer PRIMARY KEY,
     name   varchar(40) NOT NULL CHECK (name <> '')
);

ALTER TABLE distributors ADD COLUMN address varchar(30);
ALTER TABLE distributors ADD COLUMN name varchar(30);
ALTER TABLE distributors ADD COLUMN name2 varchar(30);

ALTER TABLE distributors
    ALTER COLUMN address TYPE varchar(80),
    ALTER COLUMN name TYPE varchar(100);

update distributors set name2 = name;

