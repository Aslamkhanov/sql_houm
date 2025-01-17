create table if not exists faculty 
	(id int primary key,
	name varchar(50),
	price numeric(10, 2)
	);

create table if not exists course 
	(id int primary key, 
	number int,
	faculty_id int,
	constraint fk_faculty foreign key (faculty_id) references faculty (id)
	);

create table if not exists student 
	(id int primary key,
	name varchar(100),
	surname varchar(100),
	patronymic varchar(100),
	state_private varchar (50),
	course_id int,
	constraint fk_course foreign key (course_id) references course (id)
	);

insert into faculty values(1, 'Инженерный', 30000);
insert into faculty values(2, 'Экономический', 49000);
-- id, номер курса, id факультета
insert into course values(1, 1, 1);
insert into course values(2, 1, 2);
insert into course values(3, 4, 2)
--id, имя, фамилия, отчество, бюджетник/частник, id курса
insert into student values
	(1,
	'Петр',
	'Петров',
	'Петрович',
	'бюджетник',
	1);
insert into student values
	(2,
	'Иван',
	'Иванов',
	'Иваныч',
	'частник',
	1);
insert into student values
	(3,
	'Сергей',
	'Михно',
	'Иваныч',
	'бюджетник',
	3);
insert into student values
	(4,
	'Ирина',
	'Стоцкая',
	'Юрьевна',
	'частник',
	3);
insert into student values
	(5,
	'Настасья',
	'Младич',
	null,
	'частник',
	2);

select *
from faculty;

select *
from course;

--Вывести всех студентов, кто платит больше 30_000.
select *
from student 
join course on student.course_id = course.id
join faculty on course.faculty_id = faculty.id
where faculty.price > 30000;

update student set course_id = (
	select id
	from course
	where number = 1
	AND faculty_id = (
        SELECT faculty_id
        FROM course
        WHERE id = student.course_id
    )
)
where surname = 'Петров';

SELECT *
FROM student
WHERE patronymic IS NULL OR surname IS NULL;

SELECT *
FROM student
WHERE name LIKE '%ван%'
   OR surname LIKE '%ван%'
   OR patronymic LIKE '%ван%';

DELETE FROM student;
DELETE FROM course;
DELETE FROM faculty;
