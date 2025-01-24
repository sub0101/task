CREATE TABLE Student  (
    sid INTEGER ,
    sname VARCHAR(50) NOT NULL ,
    sex VARCHAR(10)  NOT NULL,
    age SMALLINT  NOT NULL,
    year INTEGER NOT NULL,
    gpa double precision NOT NULL,
    PRIMARY KEY(sid)
);

CREATE TABLE Dept(
    dname VARCHAR(50) PRIMARY KEY,
    numphds INTEGER NOT NULL
);
CREATE TABLE Prof (
    pname VARCHAR(50) PRIMARY KEY,  
    dname VARCHAR(50) NOT NULL
);

CREATE TABLE Course (
    cno SMALLINT ,
   
    cname VARCHAR(50) NOT NULL ,
     dname VARCHAR(50) NOT NULL REFERENCES Dept,
    PRIMARY KEY(cno,dname)
);

CREATE TABLE Major (
    dname VARCHAR(50) NOT NULL REFERENCES Dept,
    sid INTEGER NOT NULL REFERENCES Student,
    PRIMARY KEY(dname, sid)
);

CREATE TABLE Section (
    dname VARCHAR(50) NOT NULL    ,
    cno SMALLINT NOT NULL , 
    sectno  SMALLINT  ,
    pname VARCHAR(50) NOT NULL,
    PRIMARY KEY(dname,cno, sectno)  ,
    FOREIGN KEY(cno,dname) REFERENCES Course(cno, dname) on delete cascade
    -- FOREIGN KEY(cno) REFERENCES Course(cno) on delete cascade


);

CREATE TABLE Enroll (
    sid INTEGER NOT NULL ,
    grade double precision NOT NULL ,
    dname VARCHAR(50) NOT NULL ,
    cno SMALLINT NOT NULL,
    sectno SMALLINT NOT NULL,
    PRIMARY KEY(sid,dname,cno,sectno),
    FOREIGN KEY(sid) REFERENCES Student(sid) on delete cascade,
    FOREIGN KEY(dname,cno,sectno) REFERENCES Section(dname,cno,sectno) on delete cascade



);

\COPY Student FROM 'data/student.data' 
\copy dept FROM 'data/dept.data'
\copy Prof  from 'data/prof.data'
\copy Course  from 'data/course.data'
\copy Major  from 'data/major.data'
\copy Section  from 'data/section.data'
\copy Enroll  from 'data/enroll.data'

