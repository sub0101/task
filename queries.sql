

-- 1.Print the names of professors who work in departments that have fewer than 50 PhD students.
WITH Dep AS (
SELECT * FROM dept WHERE numphds<50
)

SELECT * FROM Prof JOIN Dep USING(dname);


-- 2. Print the names of the students with the lowest GPA.

SELECT * FROM student ORDER BY gpa FETCH FIRST 1 ROWS WITH  TIES;


-- 3. For each Computer Sciences class, print the class number, section number, and the average gpa of the students enrolled in the class section.
WITH Csd AS  (
SELECT dname,cno,sectno,grade FROM enroll 
JOIN
student USING(sid) WHERE dname='Computer Sciences'
)

SELECT course.dname, cname,cno, sectno, AVG(grade) 
FROM course 
JOIN  Csd 
USING(cno) 
GROUP BY cname, cno, course.dname,sectno;

-- 4. Print the names and section numbers of all sections with more than six students enrolled in them.

SELECT sectno,COUNT(sid) FROM enroll GROUP BY sectno HAVING COUNT(sid)>6;



-- 5.  Print the name(s) and sid(s) of the student(s) enrolled in the most sections.


WITH  D_sect_count  AS(

	SELECT sid ,COUNT(DISTINCT sectno)
	AS section_count
	FROM enroll GROUP BY sid
)

 
SELECT sid,sname ,section_count 
FROM student 
JOIN  D_sect_count  
USING(sid)
ORDER BY section_count DESC 
FETCH FIRST 1 ROWS WITH TIES;



-- 6 .Print the names of departments that have one or more majors who are under 18 years old.

SELECT  dname FROM major JOIN student USING(sid ) WHERE age < 18;



--  7  Print the names and majors of students who are taking one of the College Geometry courses.

WITH  Gcourse AS (
SELECT * FROM course 
WHERE cname LIKE 'College Geometry%'
)
, MCourse  AS (
SELECT * FROM major 
JOIN Gcourse USING(dname)
)
, Students AS(
SELECT sname,sid,dname FROM student 
JOIN MCourse USING(sid)
)

SELECT  DISTINCT s.sid,s.sname,s.dname FROM Students s ORDER BY s.sid ;



-- 8. For those departments that have no major taking a College Geometry course print the department name and the number of PhD students in the department


WITH G_Courses AS(
SELECT * FROM course where cname like 'College Geometry%'
)
, Non_Geo_Courses AS(
SELECT * FROM course  except (select * from G_Courses)

)

SELECT dept.dname,dept.numphds  
FROM  
Non_Geo_Courses 
JOIN dept 
USING(dname) GROUP BY dept.dname;



-- 9. Print the names of students who are taking both a Computer Sciences course and a Mathematics course.


WITH Dept_Count AS (
	SELECT  sid, COUNT(DISTINCT dname) AS dept_count FROM enroll
	WHERE  dname IN ('Computer Sciences' ,'Mathematics') GROUP BY sid 
)

SELECT sid,sname,age FROM Student JOIN  DEPT_COUNT USING(sid) WHERE dept_count=2;


-- 10.Print the age difference between the oldest and the youngest Computer Sciences major.
SELECT MAX(s.age) -MIN (s.age) AS Age_Difference
FROM major m 
JOIN  student s
ON s.sid= m.sid 
WHERE m.dname='Computer Sciences';



-- 11.For each department that has one or more majors with a GPA under 1.0, print the name of the department and the average GPA of its majors.


SELECT major.dname, AVG(gpa) FROM major
JOIN dept 
USING (dname) 
JOIN student 
USING(sid)  
GROUP BY dname HAVING MIN(gpa)<1.0;




-- 12.Print the ids, names and GPAs of the students who are currently taking all the Civil Engineering courses.



WITH Civil_Courses AS(
	(SELECT COUNT(cno) FROM course WHERE dname = 'Civil Engineering')
)
SELECT s.sid,s.sname,s.gpa 
FROM student s 
INNER JOIN enroll e
ON s.sid=e.sid WHERE e.dname='Civil Engineering'
GROUP BY s.sid 
HAVING 
COUNT(DISTINCT cno) = (Select * from Civil_Courses);



