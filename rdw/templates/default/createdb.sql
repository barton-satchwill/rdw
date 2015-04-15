--
-- psql -f createdb.sql -v db=$db -v passwd=$passwd -v user=$user
--

CREATE ROLE :user WITH LOGIN PASSWORD ':passwd';
CREATE DATABASE :db OWNER :user;
GRANT ALL PRIVILEGES ON DATABASE :db TO :user;
\connect :db

CREATE TABLE sensor_reading (
    id          char(5) CONSTRAINT firstkey PRIMARY KEY,
    flux        numeric(6, 4),
    sagans      numeric(4, 2),
    fizz        numeric(6, 4),
    sparkle     numeric(4, 2),
    clarity     numeric(3, 1),
    sputz       numeric(7, 5),
    read_date   date
);

CREATE TABLE fibble (
     did    integer PRIMARY KEY,
     name   varchar(40) NOT NULL CHECK (name <> '')
);

ALTER TABLE sensor_reading ADD COLUMN hab varchar(30);
ALTER TABLE sensor_reading ADD COLUMN zapple varchar(30);
ALTER TABLE sensor_reading ADD COLUMN sputz_too numeric(7, 5);

update sensor_reading set sputz_too = 2*sputz;

ALTER TABLE fibble
    ADD COLUMN address varchar(80),
    ALTER COLUMN name TYPE varchar(100);
