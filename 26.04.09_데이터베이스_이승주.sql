/*
문제 23.[사원 데이터베이스]
어느 기업의 사원 데이터베이스가 있다. 다음 질문에 대해 SQL문을 작성하시오. 
Dept는 부서(Department) 테이블로 deptno(부서번호),dname(부서이름), loc(위치,location)으로 구성되어 있다. 

Emp는 사원(Employee)테이블로 empno(사원번호), ename(사원이름), job(업무), mgr(팀장번호, manager), 
hiredate(고용날짜), sal(월급여, salary), comm(커미션금액, commission), deptno(부서번호)로 구성되어 있다. 

밑줄친 속성은 기본키이고 Emp의 deptno는 Dept의 deptno를 참조하는 외래키이며, 
Emp의 mgr은 자신의 상사에 대한 empno를 참조하는 외래키이다.

Dept(deptno, dname, loc)
Emp(empno, ename, job, mgr, hiredate, sal, comm, deptno)
*/

--(1)교재 질의 
--⓵사원의 이름과 업무를 출력하시오. 단 사원의 이름은 ‘사원이름’, ‘업무는 ’사원업무‘, 머리글이 나오도록 출력하시오. 
select ename as "사원이름", job as "사원업무"
from Emp;
--⓶30번 부서에 근무하는 모든 사원의 이름과 급여를 출력하시오
select ename as "이름", sal as "급여"
from Emp
where deptno = 30;
--⓷사원번호와 이름, 현재급여, 증가된 급여분(열 이름은 증가액), 10% 인상된 급여(열 이름은 ’인상된 급여‘)를 사원 번호 순으로 출력하시오. 
select empno, ename, sal as "현재 급여", sal*0.1 as "증가액", sal*1.1 as "인상된 급여"
from Emp
order by empno;
--⓸’S’로 시작하는 모든 사원과 부서번호를 출력하시오. 
select *
from Emp
where ename LIKE 'S%';
--⑤모든 사원의 최대 및 최소 급여, 합계 및 평균 급여를 출력하시오. 열이름은 각각 MAX, MIN, SUM, AVG로 한다. 단 소수점 이하는 반올림하여 정수로 출력한다. 
select MAX(sal) as "MAX", MIN(sal) as "MIN", SUM(sal) as "SUM", ROUND(AVG(sal)) as "AVG"
from Emp;
--⓺업무(job)별로 동일한 업무를 하는 사원의 수를 출력하시오. 열이름은 각각 ‘업무’ 와 ‘업무별 사원수’로 한다. 
select job as "업무", count(empno) as "업무별 사원수"
from Emp
GROUP by job;
--⓻사원의 최대 급여와 최소 급여의 차액을 출력하시오. 
select MAX(sal)-MIN(sal) as "차액"
from Emp;
--⓼30번 부서의 사원 수와 사원들 급여의 합계와 평균을 출력하시오.
select count(empno) as "사원 수", SUM(sal), AVG(sal)
from Emp
where deptno = 30;
--⓽평균 급여가 가장 높은 부서의 번호를 출력하시오. 
select deptno
from Emp
GROUP by deptno
HAVING AVG(sal) =(
    select MAX(AVG(sal))
    from Emp
    GROUP by deptno
);
--⓾세일즈맨(SALESMAN)을 제외하고, 각 업무별 사원의 총급여가 3,000이상인 각각 업무에 대해서, 업무명과 각 업무별 평균 급여를 출력하시오. 
select job, AVG(sal)
from Emp
where job not in 'SALESMAN'
GROUP by job
HAVING SUM(sal) > 3000;
--⑪전체 사원 가운데 직속상관이 있는 사원의 수를 출력하시오. 
select count(empno)
from Emp
where mgr is not null;
--⑫EMP 테이블에서 이름, 급여, 커미션 금액(comm), 총액(sal*12+comm)을 구하여 총액이 많은 순서대로 출력하시오. 
select ename, sal, comm, (sal*12+NVL(comm, 0)) as "총액"
from Emp
order by 총액 desc;
--⑬부서별로 같은 업무를 하는 사람의 인원수를 구하여 부서번호, 업무 이름, 인원수를 출력하시오. 
select deptno, job, count(empno)
from Emp
GROUP by deptno, job
order by deptno;
--⑭사원이 한 명도 없는 부서의 이름을 출력하시오. 
select dname
from Dept
where deptno not in (
    select deptno
    from Emp
    GROUP by deptno
);
--⑮같은 업무를 하는 사람의 수가 4명 이상인 업무와 인원수를 출력하시오. 
select job, count(empno) as "인원수"
from Emp
group by job
having count(empno) >= 4;
--⑯사원번호가 7400 이상 7600 이하인 사원의 이름을 출력하시오. 
select ename
from Emp
where empno between 7400 and 7600;
--⑰사원의 이름과 사원의 부서이름을 출력하시오.
select ename, dname
from Emp e
join Dept d on e.deptno = d.deptno
order by d.deptno;
--⑱사원의 이름과 팀장(mgr)의 이름을 출력하시오. 
select e1.ename as "사원", e2.ename as "팀장"
from Emp e1
join Emp e2 on e1.mgr = e2.empno;
--⑲사원 SCOTT보다 급여를 많이 받는 사람의 이름을 출력하시오. 
select ename
from Emp
where sal > (
    select sal
    from Emp
    where ename = 'SCOTT'
);
--⑳사원 SCOTT이 일하는 부서번호 혹은 DALLAS 에 있는 부서번호를 출력하시오
select DISTINCT d.deptno
from Dept d
join Emp e on e.deptno = d.deptno
where e.ename = 'SCOTT' or loc = 'DALLAS';


--(2)단순질의
--⓵comm(커미션)이 NULL이 아닌 사원의 이름과 커미션을 출력하시오. 
select ename, comm
from Emp
where comm is not null;
--⓶급여가 1500이상 3000 이하인 사원의 이름과 급여를 급여 오름차순으로 출력하시오. 
select ename, sal
from Emp
where sal between 1500 and 3000
order by sal;
--⓷1981년에 입사한 사원의 이름과 입사일을 출력하시오. 
select ename, hiredate
from Emp
where hiredate between TO_DATE('1981-01-01', 'YYYY-MM-DD') and TO_DATE('1981-12-31', 'YYYY-MM-DD');
--⓸이름의 세 번째 글자가 ‘A’인 사원을 출력하시오.
select *
from Emp
where ename LIKE '__A%';
--⑤사원의 이름을 소문자로 출력하시오. 
select LOWER(ename)
from Emp;
--⓺사원 이름, 입사일, 오늘까지의 근무 개월 수를 출력하시오. 
select ename, hiredate, ROUND(MONTHS_BETWEEN(SYSDATE, hiredate)) as "근무 개월 수"
from Emp;
--⓻사원 이름과 이름의 글자 수를 글자 수 내림차순으로 출력하시오. 
select ename, length(ename) as "글자 수"
from Emp
order by "글자 수" desc;
--⓼comm이 NULL이면 0으로 대체하여 총소득(sal+comm)을 출력하시오. 
select ename, sal+NVL(comm, 0) as "총소득"
from Emp;
--⓽ANALYST 또는 PRESIDENT인 사원의 이름, 업무, 급여를 출력하시오. 
select ename, job, sal
from Emp
where job = 'ANALYST' or job = 'PRESIDENT'
order by job;
--⓾이름 길이가 긴 순, 같으면 알파벳 순으로 사원 이름을 출력하시오.
select ename
from Emp
order by length(ename), ename;

--(3)부속질의
--⓵JONES와 같은 부서에 근무하는 사원의 이름을 출력하시오(JONES본인 제외)
select ename
from Emp
where ename != 'JONES' and deptno = (
    select deptno
    from Emp
    where ename = 'JONES'
);
--⓶각 부서에서 가장 높은 급여를 받는 사원의 이름, 급여, 부서번호를 출력하시오. 
select ename, sal, deptno
from Emp
where sal in (
    select MAX(sal)
    from Emp
    GROUP by deptno
);
--⓷30번 부서 평균 급여보다 급여가 높은 사원의 이름과 급여를 출력하시오. 
select ename, sal
from Emp
where deptno = 30 and sal > (
    select AVG(sal)
    from Emp
    where deptno = 30
);
--⓸MANAGER 직급 평균 급여보다 적은 CLERK 사원의 이름과 급여를 출력하시오. 
select ename, sal
from Emp
where job = 'CLERK' and sal < (
    select AVG(sal)
    from Emp
    where job = 'MANAGER'
);
--⑤업무별 최고 급여를 받는 사원의 이름, 업무, 급여를 출력하시오. 
select ename, job, sal
from Emp
where sal in (
    select MAX(sal)
    from Emp
    GROUP BY job
)
order by sal;
--⓺KING에게 직접 보고하는 사원의 이름과 업무를 출력하시오. 
select ename, job
from Emp
where mgr = (
    select empno
    from Emp
    where ename = 'KING'
);
--⓻입사일이 가장 최근인 사원과 가장 오래된 사원을 함께 출력하시오. 
select ename
from Emp
where hiredate = (
    select MAX(hiredate)
    from Emp
) or hiredate = (
    select MIN(hiredate)
    from Emp
);
--⓼전체 평균 급여보다 급여가 높고 직위가 MANAGER인 사원을 출력하시오. 
select *
from Emp
where job = 'MANAGER' and sal > (
    select AVG(sal)
    from Emp
);
--⓽급여가 전체 사원 급여 합계의 10%를 초과하는 사원이 이름과 급여를 출력하시오. 
select ename, sal
from Emp
where sal > (
    select SUM(sal)*0.1
    from Emp
);
--⓾BLAKE와 같은 직위(job)를 가진 사원의 이름과 급여를 출력하시오(BLAKE 본인 제외)
select ename, sal
from Emp
where ename != 'BLAKE' and job = (
    select job
    from Emp
    where ename = 'BLAKE'
);
--⑪30번 부서에 속한 사원과 같은 직위(job)를 가진 모든 사원을 출력하시오. 
select *
from Emp
where job in (
    select job
    from Emp
    where deptno = 30
);
--⑫급여가 모든 CLERK보다 많은 사원의 이름과 급여를 출력하시오(ALL)
select ename, sal
from Emp
where sal > all(
    select sal
    from Emp
    where job = 'CLERK'
);
--⑬SALESMAN 중 누구보다도 급여가 많은 사원의 이름과 급여를 출력하시오.(ANY)
select ename, sal
from Emp
where sal > ANY(
    select sal
    from Emp
    where job = 'SALESMAN'
);
--⑭부하 직원이 존재하는 (관리자인) 사원의 이름과 직위를 출력하시오(EXITS)
select ename, job
from Emp e1
where EXISTS (
    select 1
    from Emp e2
    where e1.empno = e2.mgr
);
--⑮급여 상위 3위 안에 드는 사원의 이름과 급여를 출력하시오.
select ename, sal
from (
    select ename, sal, DENSE_RANK() OVER (ORDER BY sal DESC) as "rank"
    from Emp
    order by sal desc
)
where "rank" <= 3;

--(4)조인질의
--⓵사원의 이름과 소속 부서 이름을 출력하시오. 
select ename, dname
from Emp e
join Dept d on e.deptno = d.deptno;
--⓶사원의 이름과 팀장의 이름을 출력하시오.(셀프 조인)
select e1.ename, e2.ename
from Emp e1
left join Emp e2 on e1.mgr = e2.empno;
--⓷사원이 한 명도 없는 부서의 이름을 출력하시오. 
select d.dname
from Dept d
left join Emp e on d.deptno = e.deptno
GROUP by d.dname
having 1 > count(e.empno);
--⓸NEW YORK에 근무하는 사원의 이름과 업무를 출력하시오. 
select ename, job
from Emp e
join Dept d on e.deptno = d.deptno
where d.loc = 'NEW YORK';
--⑤사원이름, 급여, 급여 등급을 출력하시오.(SALGRADE 활용)
select e.ename, e.sal, s.grade
from Emp e
join salgrade s on e.sal between s.losal and s.hisal;
--⓺사원이름, 급여, 급여 등급, 부서 이름을 한 번에 출력하시오. 
select ename, sal, grade, dname
from Emp e
join Dept d on e.deptno = d.deptno
join Salgrade s on e.sal between s.losal and s.hisal;
--⓻자신의 상관보다 급여가 높은 사원의 이름과 두 사람의 급여를 출력하시오. 
select e1.ename, e1.sal, e2.sal
from Emp e1
join Emp e2 on e1.mgr = e2.empno
where e1.sal > e2.sal;
--⓼사원 이름, 부서이름, 근무 도시를 출력하시오. 
select e.ename, d.dname, d.loc
from Emp e
join Dept d on e.deptno = d.deptno;
--⓽CHICAGO에 근무하는 사원 수를 출력하시오. 
select count(empno)
from Emp e
join Dept d on e.deptno = d.deptno
where d.loc = 'CHICAGO';
--⓾부서별 인원 수가 많은 순으로 부서번호, 부서이름, 인원수를 출력하시오. 
select Dept.deptno, Dept.dname, count(empno) as "인원수"
from Dept
join Emp on Dept.deptno = Emp.deptno
GROUP BY Dept.deptno, Dept.dname
ORDER BY "인원수" desc;
--⑪부서별 평균 급여를 부서이름과 함께 출력하시오. 
select d.dname, ROUND(AVG(sal))
from Dept d
join Emp e on d.deptno = e.deptno
GROUP BY d.dname;
--⑫급여 등급이 3등급인 사원의 이름, 급여, 부서이름을 출력하시오. 
select e.ename, e.sal, d.dname
from Emp e
join Dept d on e.deptno = d.deptno
join Salgrade s on e.sal between s.losal and s.hisal
where s.grade = 3;
--⑬사원의 이음, 입사일, 입사 요일을 부서이름과 함께 출력하시오. 
select e.ename, e.hiredate, TO_CHAR(e.hiredate, 'day') as "입사요일", d.dname
from Emp e
join Dept d on e.deptno = d.deptno;
--⑭같은 부서에서 근무하는 사원끼리 이름을 나란히 출력하시오.(셀프 조인, 중복제거)
select DISTINCT e1.ename, e2.ename
from Emp e1
join Emp e2 on e1.deptno = e2.deptno
where e1.ename != e2.ename;
--⑮사원이름, 상관이름, 상관의 부서이름을 출력하시오(셀프+DEPTt조인)
select e1.ename, e2.ename, d.dname
from Emp e1
join Emp e2 on e1.mgr = e2.empno
join Dept d on e2.deptno = d.deptno;



--(5)집계질의
--⓵업무별 최고, 최소, 평균 급여와 사원 수를 출력하시오. 
select MAX(sal), MIN(sal), AVG(sal), count(empno)
from Emp;
--⓶부서별, 업무별 인원수를 출력하시오.
select deptno, job, count(*) from emp group by grouping sets (deptno, job);
--⓷직원별 총 급여(sal*12+comm)를 내림차순으로 출력하시오. 
select sal*12+NVL(comm, 0) as "총 급여"
from Emp
order by "총 급여" desc;
--⓸평균 급여보다 높은 급여를 받는 부서(번호)와 해당 부서의 평균 급여를 출력하시오
select d.deptno, ROUND(AVG(sal))
from Dept d
join Emp e on d.deptno = e.deptno
GROUP BY d.deptno
HAVING AVG(sal) > (
    select AVG(sal)
    from Emp
);
--⑤입사년도별 사원 수를 출력하시오. 
select TO_CHAR(hiredate, 'YYYY'), count(empno)
from Emp
GROUP BY TO_CHAR(hiredate, 'YYYY');
--⓺급여 등급별 사원 수와 평균 급여를 출력하시오
select s.grade, count(empno), AVG(sal)
from Emp e
join salgrade s on e.sal between s.losal and s.hisal
group by s.grade;
--⓻총급여가 5000 이상인 부서의 번호와 합계를 출력하시오. 
select d.deptno, sum(sal)
from Dept d
join Emp e on d.deptno = e.deptno
group by d.deptno;
--⓼각 사원의 급여가 전체 급여 합계에서 차지하는 비율(%)을 출력하시오. 
select ename, sal/SUM(sal) over()*100 as "비율"
from Emp;
--⓽근속 연수 10년 이상인 사원의 이름, 입사일, 근속 연수를 출력하시오. 
select ename, hiredate, TRUNC(MONTHS_BETWEEN(SYSDATE, hiredate)/12)
from Emp
where TRUNC(MONTHS_BETWEEN(SYSDATE, hiredate)/12) > 10;
--⓾급여 상위 5명의 사원 이름과 급여를 출력하시오
select ename, sal
from (
    select ename, sal, RANK() OVER (ORDER BY sal DESC) as "rank"
    from Emp
    order by sal desc
)
where "rank" <= 5;

/*
문제 24[인사부서 데이터베이스]
다음은 어느 기업의 인사과 (human resource, hr)데이터베이스이다. 
편의상 이 데이터베이스를 hr이라 하자.hr데이터베이스의 스키마는 다음과 같다.
*/

--(1)교재 질의
--⓵Employees와 Departments테이블에 저장된 튜플의 개수를 출력하시오. 
select count(*)
from employees;
select count(*)
from departments;
--⓶Employees테이블에 대한 employee_id, job_id, hire_date,를 출력하시오. 
select employee_id, job_id, hire_date
from Employees;
--⓷Employees테이블에서 salary가 12,000이상인 last_name과 salary를 출력하시오. 
select last_name, salary
from Employees
where salary >= 12000;
--⓸부서번호(department_id)가 20 혹은 50인 직원의 last_name과 department_id를 last_name에 대하여 오름차순으로 출력하시오. 
select last_name, department_id
from Employees
where department_id = 20 or department_id = 50
order by last_name asc;
--⑤last_name의 세 번째에 a가 들어가는 직원의 last_name을 출력하시오. 
select last_name
from Employees
where last_name like '___a%';
--⓺같은 일(job)을 하는 사람의 수를 세어 출력하시오
select job_id, count(employee_id)
from Employees
GROUP BY job_id;
--⓻급여(salary)의 최대값과 최소값의 차이를 구하시오. 
select MAX(salary)-MIN(salary)
from employees;
--⓼Toronto에서 일하는 직원의 last_name, job,department_id,Department_name을 출력하시오.
select e.last_name, e.job_id, e.department_id, d.Department_name
from employees e
join departments d on e.department_id = d.department_id
join Locations l on d.location_id = l.location_id
where l.city = 'Toronto';

--(2)부속질의
--⓵전체 직원 평균 급여보다 많이 받는 직원의 last_name과 salary를 출력하시오
select last_name, salary
from Employees
where salary > (
    select AVG(salary)
    from employees
);
--⓶dea hann과 같은 job_id를 가진 직원의 last_name과 job_id를 출력하시오. 
select last_name, job_id
from employees
where job_id = (
    select job_id
    from employees
    where last_name = 'De Haan'
);
--⓷부서별 최고 급여를 받는 직원의 last_name, department_id를 출력하시오. 
select last_name, department_id
from employees
where salary = (
    select MAX(salary)
    from employees
);
--⓸IT부서 직원의 평균 급여보다 많이 받는 직원의 last_name과 salary를 출력하시오. 
select last_name, salary
from employees
where salary > (
    select AVG(salary)
    from employees e
    join departments d on e.department_id = d.department_id
    where d. Department_name = 'IT'
);
--⑤직무이력(JOB_HISTORY)이 있는 직원의 last_name과 현재 job_id를 출력하시오. 
select last_name, job_id
from employees e
where EXISTS(
    select 1
    from JOB_HISTORY j
    where e.employee_id = j.employee_id
);
--⓺직무이력이 없는 직원의 last_name과 employee_id를 출력하시오. 
select last_name, job_id
from employees e
where not EXISTS(
    select 1
    from JOB_HISTORY j
    where e.employee_id = j.employee_id
);
--⓻급여가 자신이 속한 부서 평균보다 높은 직원의 이름,급여,부서번호를 출력하시오(상관부속질의)
select last_name, salary, department_id
from employees e1
where salary > (
    select AVG(salary)
    from employees e2
    where e1.department_id = e2.department_id
);
--⓼kochhar(101)를 관리자로 두는 직원의 이름과 급여를 출력하시오. 
select last_name, salary
from Employees
where manager_id = (
    select employee_id
    from Employees
    where employee_id = 101
);
--⓽급여 최상위 3명의 last_name과 salary를 출력하시오. 
select last_name, salary
from (
    select last_name, salary, RANK() OVER (ORDER BY salary DESC) as "rank"
    from Employees
    order by salary desc
)
where "rank" <= 3;
--⓾FI_ACCOUNT 직원 중 급여가 FI_ACCOUNT 평균보다 높은 직원을 출력하시오.
select last_name
from Employees
where job_id = 'FI_ACCOUNT' and salary > (
    select AVG(salary)
    from Employees
    where job_id = 'FI_ACCOUNT'
);





















