CREATE TABLE users (
  id binary(16) NOT NULL,
  email varchar(100) NOT NULL,
  first_name varchar(50) NOT NULL,
  last_name varchar(50) DEFAULT NULL,
  password varchar(50) DEFAULT NULL,
  role varchar(50) DEFAULT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY email (email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;