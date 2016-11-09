/*1*/
select hiredate from emp where ename = 'SMITH'
/*2*/
select job from emp where ename = 'FORD'
/*3*/
select * from emp order by hiredate limit 1
/*4*/
select dept.deptno,dept.dname,COUNT(emp.empno) from emp join dept on emp.deptno = dept.deptno group by deptno
/*5.*/
select e1.loc,COUNT(*) from (select emp.empno,dept.loc from emp join dept on emp.deptno = dept.deptno)as e1 group by e1.loc
/*6.*/
select e1.loc,AVG(e1.sal) from (select emp.sal,dept.loc from emp join dept on emp.deptno = dept.deptno)as e1 group by e1.loc
/*7.*/
select deptno,MAX(sal) from emp group by deptno
/*8.*/
select * from (select  e1.empno as mgrno,e2.empno as subno from emp as e1 join emp as e2 on e1.empno=e2.mgr where e1.job = 'MANAGER') as e3 join emp as e4 on e3.subno=e4.mgr 
/*9.*/
select t.format_hiredate,count(*) from (select  date_format(hiredate, '%Y') as format_hiredate from emp) as t group by t.format_hiredate
/*10.*/
select emp.ename,salgrade.grade as grade from emp cross join salgrade where losal<=sal and sal<= hisal order by grade
