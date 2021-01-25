# SQL_LEARNING
resources used to study SQL


## SQL 50 questinos

-- https://zhuanlan.zhihu.com/p/346816567

create database test50;

use test50;

-- 创建表格数据

create table Student(sid varchar(10),sname varchar(10),sage datetime,ssex nvarchar(10));
insert into Student values('01' , '赵雷' , '1990-01-01' , '男');
insert into Student values('02' , '钱电' , '1990-12-21' , '男');
insert into Student values('03' , '孙风' , '1990-05-20' , '男');
insert into Student values('04' , '李云' , '1990-08-06' , '男');
insert into Student values('05' , '周梅' , '1991-12-01' , '女');
insert into Student values('06' , '吴兰' , '1992-03-01' , '女');
insert into Student values('07' , '郑竹' , '1989-07-01' , '女');
insert into Student values('08' , '王菊' , '1990-01-20' , '女');

create table Course(cid varchar(10),cname varchar(10),tid varchar(10));
insert into Course values('01' , '语文' , '02');
insert into Course values('02' , '数学' , '01');
insert into Course values('03' , '英语' , '03');

create table Teacher(tid varchar(10),tname varchar(10));
insert into Teacher values('01' , '张三');
insert into Teacher values('02' , '李四');
insert into Teacher values('03' , '王五');
insert into Teacher values('04' , '李六');

create table SC(sid varchar(10),cid varchar(10),score decimal(18,1));
insert into SC values('01' , '01' , 80);
insert into SC values('01' , '02' , 90);
insert into SC values('01' , '03' , 99);
insert into SC values('02' , '01' , 70);
insert into SC values('02' , '02' , 60);
insert into SC values('02' , '03' , 80);
insert into SC values('03' , '01' , 80);
insert into SC values('03' , '02' , 80);
insert into SC values('03' , '03' , 80);
insert into SC values('04' , '01' , 50);
insert into SC values('04' , '02' , 30);
insert into SC values('04' , '03' , 20);
insert into SC values('05' , '01' , 76);
insert into SC values('05' , '02' , 87);
insert into SC values('06' , '01' , 31);
insert into SC values('06' , '03' , 34);
insert into SC values('07' , '02' , 89);
insert into SC values('07' , '03' , 98);

-- 1、查询“01”课程比“02”课程成绩高的所有学生的学号；

select sid
from (select sc1.sid, sc1.score1-sc2.score2 as score12
from (select sid, score as score1 from sc where cid='01') as sc1 join (select sid, score as score2 from sc where cid='02') as sc2 on sc1.sid=sc2.sid) as temp
where score12>0;


select sc1.sid
from (select * from sc where cid='01') as sc1 join
(select * from sc where cid='02') as sc2 on sc1.sid=sc2.sid
where sc1.score>sc2.score;

-- 2、查询平均成绩大于60分的同学的学号和平均成绩；

select sid, avg(score) as avg_score
from sc
group by sid
having avg_score>60;


-- 3、查询所有同学的学号、姓名、选课数、总成绩
select st.sid, st.sname, count(sc.cid), sum(sc.score)
from student as st join sc on st.sid=sc.sid
group by st.sid;




-- 4、查询姓“李”的老师的个数；
select count(1)
from teacher
where mid(tname,1,1)='李';



-- 5、查询没学过“张三”老师课的同学的学号、姓名；  -- 三个表的联结
-- 先选出选过的， 然后得到选过之外的就是没选过
select student.sid, student.sname
from student
where student.sid not in (select student.sid
from teacher join course on teacher.tid=course.tid 
join sc on course.cid=sc.cid join student on sc.sid=student.sid
where teacher.tname='张三');




select *
from teacher join course on teacher.tid=course.tid 
join sc on course.cid=sc.cid join student on sc.sid=student.sid;


-- 6、查询学过编号“01”并且也学过编号“02”课程的同学的学号、姓名；
select t1.sid, st.sname
from (select sid, cid from sc where cid='01') as t1 join (select sid, cid from sc where cid='02') as t2
on t1.sid=t2.sid join student as st on t1.sid=st.sid;



-- 7、查询学过“张三”老师所教的课的同学的学号、姓名；
select student.sid, student.sname
from teacher join course on teacher.tid=course.tid 
join sc on course.cid=sc.cid join student on sc.sid=student.sid
where teacher.tname='张三';

-- 8、查询课程编号“01”的成绩比课程编号“02”课程低的所有同学的学号、姓名；


select sc1.sid, st.sname
from (select * from sc where cid='01') as sc1 join
(select * from sc where cid='02') as sc2 on sc1.sid=sc2.sid
join student as st on sc1.sid=st.sid
where sc1.score<sc2.score;

-- 9、查询所有课程成绩小于60分的同学的学号、姓名；
select t1.sid, st.sname
from (select sid, max(score) as max_sc from sc group by sid having max_sc<60) as t1 join student as st
on t1.sid=st.sid;


-- 10、查询没有学全所有课的同学的学号、姓名；
select t1.sid, st.sname
from (select sid, count(cid) as cn_cid from sc group by sid having cn_cid<(select count(distinct cname) from course)) as t1 join student as st on  t1.sid=st.sid;

select count(distinct cname) from course;

-- 11、查询至少有一门课与学号为“01”的同学所学相同的同学的学号和姓名；

select distinct st.sid, st.sname
from student as st join sc on st.sid=sc.sid
where sc.cid in (select cid from sc where sid='01');


-- 12、查询和"01"号的同学学习的课程完全相同的其他同学的学号和姓名

-- 两个集合完全相同？
-- 交集中元素的个数同时等于两个集合

-- 课程相同，才匹配，计算匹配数目，得到相同课程的数目
select t1.sid, sname
from (select sc.sid ,count(distinct sc.cid) from 
            (select cid from sc where sid='01') as t1  -- 选出01的同学所学的课程
        left join sc
            on t1.cid=sc.cid
        group by sc.sid
        having count(distinct sc.cid)= (select count(distinct cid) from sc where sid = '01')
    ) as t1
left join student on t1.sid=student.sid
where t1.sid!='01';



-- 13、把“SC”表中“张三”老师教的课的成绩都更改为此课程的平均成绩；
SET SQL_SAFE_UPDATES = 0;  -- 解除安全模式
update sc set score=(select avg(score) from (select * from sc) as temp1
group by cid
having cid=(select cid from teacher join course on teacher.tid=course.tid where teacher.tname='张三')) 
where cid = (select cid from teacher join course on teacher.tid=course.tid where teacher.tname='张三');

select cid from teacher join course on teacher.tid=course.tid where teacher.tname='张三';

select avg(score) from sc
group by cid
having cid=(select cid from teacher join course on teacher.tid=course.tid where teacher.tname='张三');


select * from sc;

-- 14、查询没学过"张三"老师讲授的任一门课程的学生姓名

-- 学过张三的学生
select st.sname
from student as st join sc on st.sid=sc.sid
where cid in (select cid from teacher join course on teacher.tid=course.tid where teacher.tname='张三');
-- 没学过张三的学生  （1-学过）
select st.sname	
from student as st
where st.sname not in (select st.sname
from student as st join sc on st.sid=sc.sid
where cid in (select cid from teacher join course on teacher.tid=course.tid where teacher.tname='张三'));




-- 15、查询两门及其以上不及格课程的同学的学号，姓名及其平均成绩

-- 使用 case 统计不及格的数目
select t1.sid, st.sname, t1.avg_sc
from (select sid, sum(case when score<60 then 1 else 0 end) as num, avg(score) as avg_sc from sc
group by sid having num>=2) as t1 join student as st on t1.sid=st.sid;




-- 16、检索"01"课程分数小于60，按分数降序排列的学生信息
select * from student as st join sc on st.sid=sc.sid
where st.sid in (select sid from sc where cid='01' and score<60 ) and sc.cid='01'
order by sc.score desc;


-- 17、按平均成绩从高到低显示所有学生的平均成绩
select sid,avg(score) as avg_score
from sc 
group by sid
order by avg_score desc;

-- 18、查询各科成绩最高分、最低分和平均分：以如下形式显示：课程ID，课程name，最高分，最低分，平均分，及格率

select sc.cid as '课程ID', course.cname as '课程name', max(score) as '最高分', min(score) as '最低分', avg(score) as '平均分', sum(case when score>60 then 1 else 0 end)/count(score) as '及格率'
from course join sc on course.cid=sc.cid
group by sc.cid;


select *
from course join sc on course.cid=sc.cid;

-- 19、按各科平均成绩从低到高和及格率的百分数从高到低顺序

select sc.cid, course.cname, avg(score) as avg_sc, sum(case when score>60 then 1 else 0 end)/count(score) as pass_rate
from course join sc on course.cid=sc.cid
group by sc.cid
order by avg_sc asc, pass_rate desc;


-- 20、查询学生的总成绩并进行排名

-- only use group by
select sid, sum(score) as sum_sc
from sc
group by sid
order by sum_sc desc;

-- use rank () over
select sid, sum_sc,
rank () over (order by sum_sc desc) as ranking
from (select sid, sum(score) as sum_sc
from sc
group by sid) as temp1;


-- 21、查询不同老师所教不同课程平均分从高到低显示

select course.tid, sc.cid, avg(sc.score) as avg_score
from course join sc on course.cid = sc.cid
group by course.tid,sc.cid  -- group by 
order by avg_score desc;



-- 22、查询所有课程的成绩第2名到第3名的学生信息及该课程成绩


select * 
from (select sid, cid, score,
rank () over (partition by cid order by score) as ranking
from sc) as t1
where ranking between 2 and 3;

select t2.sid, t2.cid, t2.score, t2.ranking, course.cname
from (select * 
from (select sid, cid, score,
rank () over (partition by cid order by score) as ranking
from sc) as t1
where ranking between 2 and 3) as t2 join course on t2.cid=course.cid;


-- 23、统计各科成绩各分数段人数：课程编号,课程名称,[100-85],[85-70],[70-60],[0-60]及所占百分比


select case when score>=85 then '100-85'
when score<85 and score>=75 then '85-70'
when score<70 and score>=60 then '70-60'
else '60-0' end as levels, sid, cid from sc
;



select t1.cid, course.cname, t1.levels, count(t1.levels) as num, count(t1.levels)/(select count(*) from sc) as rate
from (select case when score>=85 then '100-85'
when score<85 and score>=75 then '85-70'
when score<70 and score>=60 then '70-60'
else '60-0' end as levels, sid, cid from sc) as t1 join course on t1.cid=course.cid
group by levels;





-- 24、查询学生平均成绩及其名次



select sid, avg_score, 
rank () over (order by avg_score desc) as ranking
from (select sid, avg(score) as avg_score
from sc
group by sid) as t1;




-- 25、查询各科成绩前三名的记录

select t2.sid, t2.cid, t2.score, t2.ranking, course.cname
from (select * 
from (select sid, cid, score,
rank () over (partition by cid order by score desc) as ranking
from sc) as t1
where ranking between 1 and 3) as t2 join course on t2.cid=course.cid;



select * from
(select sid, cid, score,
rank () over (partition by cid order by score desc) as ranking
from sc) as t1
where ranking between 1 and 3;


-- 26、查询每门课程被选修的学生数

select cid,count(cid) from sc group by cid;

-- 27、查询出只选修了一门课程的全部学生的学号和姓名

select sid, count(sid)
from sc
group by sid;

-- 28、查询男生、女生人数
select ssex,count(1) as num from student group by ssex;
-- 29、查询名字中含有"风"字的学生信息
select *
from student
where sname like '%风%';


-- 30、查询同名同性学生名单，并统计同名人数
select sname, ssex, count(sid) as cs from student
group by sname, ssex
having cs>=2;



-- 31、查询1990年出生的学生名单(注：Student表中Sage列的类型是datetime)

select *
from student 
where extract(year from sage) = '1990';


-- 32、查询每门课程的平均成绩，结果按平均成绩升序排列，平均成绩相同时，按课程号降序排列

select sid, cid, avg(score) as avg_sc
from sc
group by cid
order by avg_sc asc, cid desc;


-- 37、查询不及格的课程，并按课程号从大到小排列
select distinct cid
from sc
where score < 60
order by cid desc;

-- 38、查询课程编号为"01"且课程成绩在60分以上的学生的学号和姓名；

-- the lowest score> 60
select sc.sid, st.sname, min(sc.score) as min_sc
from sc join student as st on sc.sid=st.sid
where sc.cid='01'
group by sc.sid
having min_sc>60;


select sc.sid, st.sname
from sc join student as st on sc.sid=st.sid
where sc.cid='01' and sc.score>60;


-- 40、查询选修“张三”老师所授课程的学生中，成绩最高的学生姓名及其成绩

select st.sname, sc.score
from teacher join course on teacher.tid=course.tid
join sc on course.cid=sc.cid
join student as st on st.sid=sc.sid
where teacher.tname='张三'
order by score desc
limit 1,1;



-- 42、查询每门功课成绩最好的前两名

select sid, cid, score,
row_number () over (partition by cid order by score desc) as ranking
from sc;

select *
from (select sid, cid, score,
row_number () over (partition by cid order by score desc) as ranking
from sc) as t1
where ranking<=2;


-- 43 、统计每门课程的学生选修人数（超过人的课程才统计）。
-- 要求输出课程号和选修人数，查询结果按人数降序排列，若人数相同，按课程号升序排列
select cid, count(sid) as num 
from sc
group by cid
order by num desc, cid;


-- 44、检索至少选修两门课程的学生学号
select sid, count(cid) as num 
from sc
group by sid
having num>=2;

-- 45、查询选修了全部课程的学生信息
select *, count(sc.cid) as c_c
from student as st join sc on st.sid=sc.sid
group by sc.sid
having c_c = (select count(distinct cid) from course);  -- use select to provide constant




-- 46、查询各学生的年龄

select sid,sname,(extract(year from current_time()) - extract(year from sage)) as st_age
from student;

-- 47、查询本周过生日的学生
select current_date();
select extract(day from sage) from student;


select
    sid,sname,sage
from student
where weekofyear(sage) = weekofyear(current_time());

select curdate();
select current_date();

-- 48、查询下周过生日的学生
-- date_add adn date_sub
select 
    sid,sname,sage
from student
where weekofyear(sage) = weekofyear(date_sub(curdate(),interval 1 week));

-- 49、查询本月过生日的学生
select
    sid,sname,sage
from student
where month(sage) = month(curdate());

-- 50、查询下月过生日的学生
select
    sid,sname,sage
from student
where month(curdate()) =month(date_sub(sage,interval 1 month));



















