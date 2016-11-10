emp = load 'emp_dept/emp.csv' as (empno:int, ename:
chararray, job:chararray, mgr:int, hiredate:datetime, sal:float,
deptno: int);
dept = load 'emp_dept/dept.csv' as (deptno:int, dname:
chararray, loc: chararray);
salgrade = load 'emp_dept/salgrade.csv' as (grade:int,
losal:int, hisal:int);
/*
Smith’s employment date
*/
tuples_smith = filter emp by ename == 'SMITH';
employment_date = foreach tuples_smith generate hiredate;
dump employment_date;

/*
Ford’s job title
*/
tuples_ford = filter emp by ename == 'FORD';
job_title = foreach tuples_ford generate job;
dump job_title;

/*
The first employee (by the hiredate)
*/
tuples_desc =order emp by hiredate;
first_employ_date = limit tuples_desc 1;
dump first_employ_date;

/*
The number of employees in each department
*/
tuples_dept_group = group emp by deptno;
number_each_deptId = foreach tuples_dept_group generate group,COUNT(emp.empno) as num_dept;
number_each_deptname = join number_each_deptId by group,dept by deptno;
number_each_dept = foreach number_each_deptname generate number_each_deptId::group,dept::dname,number_each_deptId::num_dept;
dump number_each_dept;

/*
The number of employees in each city
*/
emp_dept = join emp by deptno,dept by deptno;
group_city = group emp_dept by loc;
number_each_city = foreach group_city generate group,COUNT(emp_dept.emp::empno);
dump number_each_city;

/*
The average salary in each city
*/
emp_dept = join emp by deptno,dept by deptno;
group_city = group emp_dept by loc;
salary_each_city = foreach group_city generate group,AVG(emp_dept.emp::sal);
dump salary_each_city;

/*
The highest paid employee in each department
*/
dept_group = group emp by deptno;
max_sal_each_dept = foreach dept_group generate group, MAX(emp.sal) as max_sal;
max_sal_each_dept1 = join emp by (deptno,sal), max_sal_each_dept by ($0,$1);
max_sal_emp_each_dept = foreach max_sal_each_dept1 generate max_sal_each_dept::group,emp::ename, emp::sal;
dump max_sal_emp_each_dept;

/*
Managers whose subordinates have at least one subordinate
*/
tuples_mgr = filter emp by job == 'MANAGER';
mgr_sub = join tuples_mgr by empno,emp by mgr;
mgr_sub_sub = join mgr_sub by emp::empno,emp by mgr;
dump mgr_sub_sub;

/*
The number of employees for each hiring year
*/
str_hiredate = foreach emp generate ToString(hiredate, 'yyyy-MM-dd') as hiredate1;
tuples_hiring_year = foreach str_hiredate generate SUBSTRING(hiredate1, 0, 4) as hiring_year;
group_hiring_year = group tuples_hiring_year by hiring_year;
num_emp_each_year = foreach group_hiring_year generate group,COUNT($1);
dump num_emp_each_year;

/*
The pay grade of each employee
*/
crossed = cross emp, salgrade;  
emp_salgrade = filter crossed by losal < sal and sal <=  hisal; emp_salgrade2 = foreach emp_salgrade generate emp::ename, emp::sal as sal, salgrade::grade as grade; 
sal_groups = group emp_salgrade2 by grade;
dump sal_groups;
