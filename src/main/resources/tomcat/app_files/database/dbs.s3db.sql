BEGIN TRANSACTION;
CREATE TABLE IF NOT EXISTS `STUDENT` (
	`id`	INTEGER PRIMARY KEY AUTOINCREMENT,
	`card_uid`	TEXT,
	`card_id`	TEXT,
	`first_name`	TEXT,
	`last_name`	TEXT,
	`patronymic`	TEXT,
	`phone`	TEXT,
	`email`	TEXT,
	`image`	BLOB
);
CREATE TABLE IF NOT EXISTS `LECTURER` (
	`id`	INTEGER PRIMARY KEY AUTOINCREMENT,
	`card_uid`	TEXT,
	`card_id`	INTEGER,
	`first_name`	TEXT,
	`last_name`	TEXT,
	`patronymic`	TEXT,
	`phone`	TEXT,
	`email`	TEXT,
	`image`	BLOB
);
CREATE TABLE IF NOT EXISTS `LESSON_TYPE` (
	`id`	INTEGER PRIMARY KEY AUTOINCREMENT,
	`name`	TEXT
);
CREATE TABLE IF NOT EXISTS `GROUP_TYPE` (
	`id`	INTEGER,
	`name`	TEXT
);
CREATE TABLE IF NOT EXISTS `DISCIPLINE` (
	`id`	INTEGER PRIMARY KEY AUTOINCREMENT,
	`name`	TEXT,
	`description`	TEXT,
	`create_date`	TEXT DEFAULT (strftime('%Y-%m-%dT%H:%M:%S','now','localtime')),
	`active`	INTEGER,
	`expiration_date`	TEXT
);
CREATE TABLE IF NOT EXISTS `DEPARTMENT` (
	`id`	INTEGER PRIMARY KEY AUTOINCREMENT,
	`name`	TEXT,
	`abbreviation`	TEXT
);
CREATE TABLE IF NOT EXISTS `ALARM` (
	`id`	INTEGER PRIMARY KEY AUTOINCREMENT,
	`active`	INTEGER DEFAULT 0,
	`time`	INTEGER,
	`volume`	DECIMAL ( 1 , 1 ),
	`sound`	TEXT
);
CREATE TABLE IF NOT EXISTS `NOTE` (
	`id`	INTEGER PRIMARY KEY AUTOINCREMENT,
	`lecturer_id`	INTEGER,
	`type`	TEXT,
	`entity_id`	INTEGER,
	`description`	TEXT,
	`create_date`	TEXT DEFAULT (strftime('%Y-%m-%dT%H:%M:%S','now','localtime')),
	FOREIGN KEY(`lecturer_id`) REFERENCES `LECTURER`(`id`) ON DELETE CASCADE
);
CREATE TABLE IF NOT EXISTS `SCHEDULE_VERSION` (
	`id`	INTEGER PRIMARY KEY AUTOINCREMENT,
	`start_date`	TEXT,
	`end_date`	TEXT
);
CREATE TABLE IF NOT EXISTS `SCHEDULE` (
	`id`	INTEGER PRIMARY KEY AUTOINCREMENT,
	`begin`	TEXT,
	`end`	TEXT,
	`number`	INTEGER,
	`version_id`	INTEGER,
	FOREIGN KEY(`version_id`) REFERENCES `SCHEDULE_VERSION`(`id`) ON DELETE CASCADE
);
CREATE TABLE IF NOT EXISTS `NOTIFICATION_SETTING` (
	`id`	INTEGER PRIMARY KEY AUTOINCREMENT,
	`type`	TEXT,
	`active`	INTEGER DEFAULT 0,
	`data`	TEXT,
	`volume`	DECIMAL ( 1 , 1 ) DEFAULT 1,
	`sound`	TEXT
);
CREATE TABLE IF NOT EXISTS `STREAM` (
	`id`	INTEGER PRIMARY KEY AUTOINCREMENT,
	`name`	TEXT,
	`image`	BLOB,
	`description`	TEXT,
	`create_date`	TEXT DEFAULT (strftime('%Y-%m-%dT%H:%M:%S','now','localtime')),
	`lecturer_id`	INTEGER,
	`discipline_id`	INTEGER,
	`department_id`	INTEGER,
	`course`	INTEGER,
	`active`	INTEGER,
	`expiration_date`	TEXT,
	`lecture_count`	INTEGER,
	`practical_count`	INTEGER,
	`lab_count`	INTEGER,
	FOREIGN KEY(`discipline_id`) REFERENCES `DISCIPLINE`(`id`) ON DELETE CASCADE,
	FOREIGN KEY(`lecturer_id`) REFERENCES `LECTURER`(`id`) ON DELETE CASCADE,
	FOREIGN KEY(`department_id`) REFERENCES `DEPARTMENT`(`id`) ON DELETE CASCADE
);
CREATE TABLE IF NOT EXISTS `GROUP` (
	`id`	INTEGER PRIMARY KEY AUTOINCREMENT,
	`name`	TEXT,
	`department_id`	INTEGER,
	`type_id`	INTEGER,
	`image`	BLOB,
	`active`	INTEGER,
	`expiration_date`	TEXT,
	`praepostor_id`	INTEGER,
	FOREIGN KEY(`praepostor_id`) REFERENCES `STUDENT`(`id`) ON DELETE CASCADE,
	FOREIGN KEY(`department_id`) REFERENCES `DEPARTMENT`(`id`) ON DELETE CASCADE,
	FOREIGN KEY(`type_id`) REFERENCES `GROUP_TYPE`(`id`) ON DELETE CASCADE
);
CREATE TABLE IF NOT EXISTS `STUDENT_NOTIFICATION` (
	`id`	INTEGER PRIMARY KEY AUTOINCREMENT,
	`student_id`	INTEGER,
	`active`	INTEGER DEFAULT 0,
	`create_date`	TEXT DEFAULT (strftime('%Y-%m-%dT%H:%M:%S','now','localtime')),
	`description`	TEXT,
	FOREIGN KEY(`student_id`) REFERENCES `STUDENT`(`id`) ON DELETE CASCADE
);
CREATE TABLE IF NOT EXISTS `STREAM_GROUP` (
	`id`	INTEGER PRIMARY KEY AUTOINCREMENT,
	`stream_id`	INTEGER,
	`group_id`	INTEGER,
	FOREIGN KEY(`stream_id`) REFERENCES `STREAM`(`id`) ON DELETE CASCADE,
	FOREIGN KEY(`group_id`) REFERENCES `GROUP`(`id`) ON DELETE CASCADE
);
CREATE TABLE IF NOT EXISTS `LESSON` (
	`id`	INTEGER PRIMARY KEY AUTOINCREMENT,
	`name`	TEXT,
	`description`	TEXT,
	`stream_id`	INTEGER,
	`create_date`	TEXT DEFAULT (strftime('%Y-%m-%dT%H:%M:%S','now','localtime')),
	`type_id`	INTEGER,
	`group_id`	INTEGER,
	`DATE`	TEXT,
	`SCHEDULE_ID`	INTEGER,
	`index_number`	INTEGER,
	FOREIGN KEY(`group_id`) REFERENCES `GROUP`(`id`) ON DELETE CASCADE,
	FOREIGN KEY(`type_id`) REFERENCES `LESSON_TYPE`(`id`) ON DELETE CASCADE,
	FOREIGN KEY(`SCHEDULE_ID`) REFERENCES `SCHEDULE`(`id`) ON DELETE CASCADE,
	FOREIGN KEY(`stream_id`) REFERENCES `STREAM`(`id`) ON DELETE CASCADE
);
CREATE TABLE IF NOT EXISTS `STUDENT_LESSON` (
	`id`	INTEGER PRIMARY KEY AUTOINCREMENT,
	`student_id`	INTEGER,
	`lesson_id`	INTEGER,
	`registered`	INTEGER DEFAULT 0,
	`registration_time`	TEXT,
	`registration_type`	TEXT,
	`mark`	TEXT,
	`mark_time`	TEXT,
	FOREIGN KEY(`lesson_id`) REFERENCES `LESSON`(`id`) ON DELETE CASCADE,
	FOREIGN KEY(`student_id`) REFERENCES `STUDENT`(`id`) ON DELETE CASCADE
);
CREATE TABLE IF NOT EXISTS `STUDENT_GROUP` (
	`id`	INTEGER PRIMARY KEY AUTOINCREMENT,
	`student_id`	INTEGER,
	`group_id`	INTEGER,
	`praepostor`	INTEGER,
	FOREIGN KEY(`student_id`) REFERENCES `STUDENT`(`id`) ON DELETE CASCADE,
	FOREIGN KEY(`group_id`) REFERENCES `GROUP`(`id`) ON DELETE CASCADE
);
COMMIT;
