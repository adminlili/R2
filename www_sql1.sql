CREATE DATABASE nginx_users;
GRANT all  ON *.* TO 'root'@'localhost' IDENTIFIED BY '123L45p68';
GRANT SELECT ON nginx_users.* TO 'nginx_user'@'localhost' IDENTIFIED BY '123L45p68';

USE nginx_users;
CREATE TABLE `users` (
`id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY ,
`username` VARCHAR( 30 ) NOT NULL ,
`password` VARCHAR( 50 ) NOT NULL ,
UNIQUE (`username`)
) ENGINE = MYISAM ;

INSERT INTO users (username, password)
VALUES('nginxuser1', md5('passwdd1'));

INSERT INTO users (username, password)
VALUES('nginxuser2', md5('passwdd2'));

INSERT INTO users (username, password)
VALUES('nginxuseruser', md5('passwdd3'));

INSERT INTO users (username, password)
VALUES('nginxuser3', md5('passwdd11'));

INSERT INTO users (username, password)
VALUES('nginxuser4', md5('passwdd22'));

INSERT INTO users (username, password)
VALUES('nginxuseruser2', md5('passwdd33'));


CREATE DATABASE nginx_test;

GRANT SELECT ON nginx_test.* TO 'nginx_user'@'localhost' IDENTIFIED BY '123L45p68';

USE nginx_test;
CREATE TABLE `nginx_test`.`todo_list` (
item_id INT AUTO_INCREMENT,
content VARCHAR(255),
PRIMARY KEY(item_id)
);

INSERT INTO nginx_test.todo_list (content)
VALUES('The item #1');

INSERT INTO nginx_test.todo_list (content)
VALUES('The item #2');

INSERT INTO nginx_test.todo_list (content)
VALUES('The item #3');

INSERT INTO nginx_test.todo_list (content)
VALUES('The item #4');

INSERT INTO nginx_test.todo_list (content)
VALUES('The item #5');


exit
