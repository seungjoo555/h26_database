/*
마당서점 복합 뷰 생성 문제
마당서점의 기본 테이블 구조입니다. sql
-- 고객 테이블
Customer(custid, name, address, phone) 
-- 도서 테이블
Book(bookid, bookname, publisher, price) 
-- 주문 테이블
Orders(orderid, custid, bookid, saleprice, orderdate)
*/

--문제 10개
--문제 1.고객별 총 주문금액과 주문 횟수를 보여주는 뷰 v_cust_order_summary를 작성하시오.
--(출력 컬럼: 고객이름, 총주문금액, 주문횟수)
create view v_cust_order_summary AS
    select c.name, sum(o.saleprice) as "총주문금액", count(o.custid) as "주문횟수"
    from Customer c
    join Orders o on c.custid = o.custid
    group by c.name;
--문제 2.각 도서의 도서명, 출판사, 판매된 총 수량(주문 횟수), 총 판매금액을 보여주는 뷰 v_book_sales를 작성하시오. 
create view v_book_sales AS
    select b.bookname, b.publisher, count(o.orderid) as "판매된 총 수량", sum(o.saleprice) as "총 판매금액"
    from book b
    join orders o on b.bookid = o.bookid
    group by b.bookname, b.publisher;
--문제 3.주문한 적 있는 고객의 이름, 주소, 가장 최근 주문일을 보여주는 뷰 v_cust_last_order를 작성하시오. 
create view v_cust_last_order AS
    select c.name, c.address, MAX(o.orderdate) as "최근 주문일"
    from Customer c
    join Orders o on c.custid = o.custid
    group by c.name, c.address;
--문제 4.도서 정가보다 할인된 금액으로 판매된 주문 내역을 보여주는 뷰 v_discounted_orders를 작성하시오.
--(출력 컬럼: 주문번호, 고객이름, 도서명, 정가, 판매가, 할인금액)
create view v_discounted_orders AS
    select o.orderid, c.name, b.bookname, b.price, o.saleprice, (b.price-o.saleprice) as "할인금액"
    from Orders o
    join Customer c on o.custid = c.custid
    join Book b on o.bookid = b.bookid
    where (b.price-o.saleprice) != 0
    order by o.orderid;
--문제 5.출판사별 평균 판매가격과 최고 판매가격을 보여주는 뷰 v_publisher_stats를 작성하시오.
--(출력 컬럼: 출판사, 평균판매가, 최고판매가)
create view v_publisher_stats AS
    select b.publisher, AVG(o.saleprice) as "평균판매가", MAX(o.saleprice) as "최고판매가"
    from Book b
    join Orders o on b.bookid = o.bookid
    group by b.publisher;
--문제 6.총 주문금액이 30,000원 이상인 우수 고객의 이름과 총 주문금액을 보여주는 뷰 v_vip_customer를 작성하시오. 
create view v_vip_customer as
    select c.name, sum(o.saleprice) as "총 주문금액"
    from Customer c
    join Orders o on c.custid = o.custid
    group by c.name
    having sum(o.saleprice) >= 30000;
--문제 7.2024년에 주문된 내역의 고객이름, 도서명, 판매가격, 주문일자를 보여주는 뷰 v_orders_2024를 작성하시오. 
create view v_orders_2024 as
    select c.name, b.bookname, o.saleprice, o.orderdate
    from Customer c
    join Orders o on c.custid = o.custid
    join Book b on o.bookid = b.bookid
    where o.orderdate between TO_DATE('2024-01-01', 'YYYY-MM-DD') and TO_DATE('2024-12-31', 'YYYY-MM-DD');
--문제 8.한 번도 주문되지 않은 도서의 도서명과 출판사, 정가를 보여주는 뷰 v_unsold_books를 작성하시오. 
create view v_unsold_books as
    select b.bookname, b.publisher, b.price
    from Book b
    where not exists (
        select 1
        from Orders o
        where b.bookid = o.bookid
    );
--문제 9.고객별로 가장 비싸게 구매한 도서명과 그 금액을 보여주는 뷰 v_cust_max_order를 작성하시오.
--(출력 컬럼: 고객이름, 도서명, 최고구매금액)
create view v_cust_max_order as 
    select c.name, b.bookname, o.saleprice as "최고구매금액"
    from Customer c
    join Orders o on c.custid = o.custid
    join Book b on o.bookid = b.bookid
    where o.saleprice = (
        select MAX(o2.saleprice)
        from Orders o2
        where c.custid = o2.custid
    );
--문제 10.도서명, 고객이름, 판매가, 해당 도서 평균 판매가, 평균 대비 차이를 보여주는 뷰 v_book_price_compare를 작성하시오.
--(출력 컬럼: 도서명, 고객이름, 판매가, 도서평균판매가, 차이)
create view v_book_price_compare as
    select b.bookname, c.name, b.price, AVG(saleprice) over (partition by b.bookid) as "도서평균판매가", price - AVG(saleprice) over (partition by b.bookid) as "차이"
    from Customer c
    join Orders o on c.custid = o.custid
    join Book b on o.bookid = b.bookid;

--[복합 뷰 문제]
--문제 1.출판사별로 판매된 도서 수와 총 판매금액을 보여주는 뷰 v_publisher_sales를 작성하시오.
--(출력 컬럼: 출판사, 판매도서수, 총판매금액)
create view v_publisher_sales as
    select b.publisher, count(o.orderid) as "판매된 도서 수", SUM(o.saleprice) as "총 판매 금액"
    from Book b
    join Orders o on b.bookid = o.bookid
    group by b.publisher;
--문제 2.고객별 평균 구매금액을 계산하고, 전체 고객 평균보다 높은 고객만 보여주는 뷰 v_above_avg_customer를 작성하시오.
--(출력 컬럼: 고객이름, 평균구매금액)
create view v_above_avg_customer as
    select c.name, AVG(o.saleprice) as "평균구매금액"
    from Customer c
    join Orders o on c.custid = o.custid
    group by c.name
    having AVG(o.saleprice) > (
        select AVG(AVG(saleprice))
        from Orders
        group by custid
    );
--문제 3.주문 내역에서 도서명, 고객이름, 주문일자, 판매가격을 출력하되 판매가격이 높은 순으로 정렬된 뷰 v_orders_detail을 작성하시오. 
create view v_orders_detail as
    select b.bookname, c.name, o.orderdate, o.saleprice
    from Customer c
    join Orders o on c.custid = o.custid
    join Book b on o.bookid = b.bookid
    order by o.saleprice desc;
--문제 4.2권 이상 주문한 고객의 이름과 주문 횟수를 보여주는 뷰 v_frequent_customer를 작성하시오. 
create view v_frequent_customer as
    select c.name, count(*) as "주문 횟수"
    from Customer c
    join Orders o on c.custid = o.custid
    group by c.name;
--문제 5.각 고객이 마지막으로 주문한 도서명과 주문일자를 보여주는 뷰 v_last_ordered_book을 작성하시오.
--(출력 컬럼: 고객이름, 도서명, 주문일자)
create view v_last_ordered_book as
    select c.name, b.bookname, o.orderdate
    from Customer c
    join Orders o on c.custid = o.custid
    join Book b on o.bookid = b.bookid
    where o.orderdate = (
        select MAX(o2.orderdate)
        from Orders o2
        where c.custid = o2.custid
    );
--문제 6.도서 정가 대비 평균 할인율이 가장 높은 출판사 순으로 보여주는 뷰 v_publisher_discount_rate를 작성하시오.
--(출력 컬럼: 출판사, 평균할인율) 
--단, 정가보다 낮게 팔린 경우만 포함한다. 
create view v_publisher_discount_rate as
    select b.publisher, round(AVG((b.price - o.saleprice) / CAST(b.price as float) * 100)) as "평균할인율"
    from book b
    join orders o on b.bookid = o.bookid
    where b.price > o.saleprice
    group by b.publisher
    order by "평균할인율" desc;
--문제 7.한 번이라도 주문한 적 있는 고객과 한 번도 주문하지 않은 고객을 구분하여 보여주는 뷰 v_customer_order_status를 작성하시오.
--(출력 컬럼: 고객이름, 주문여부)
--단, 주문여부는 '주문있음' / '주문없음'으로 표시한다. 
CREATE VIEW v_customer_order_status AS
SELECT 
    DISTINCT c.name AS "고객이름",
    CASE 
        WHEN o.orderid IS NOT NULL THEN '주문있음'
        ELSE '주문없음'
    END AS "주문여부"
FROM Customer c
LEFT JOIN (
    SELECT DISTINCT custid, orderid 
    FROM Orders
) o ON c.custid = o.custid;
--문제 8.월별 총 판매금액과 주문 건수를 보여주는 뷰 v_monthly_sales를 작성하시오.
--(출력 컬럼: 년도, 월, 총판매금액, 주문건수)
create view v_monthly_sales as
    select TO_CHAR(orderdate, 'YYYY') as "년도", TO_CHAR(orderdate, 'MM') as "월", SUM(saleprice) as "총판매금액", count(orderid) as "주문건수"
    from orders
    group by TO_CHAR(orderdate, 'YYYY'), TO_CHAR(orderdate, 'MM');
--문제 9.같은 출판사의 도서를 2종류 이상 구매한 고객의 이름과 출판사, 구매 종류 수를 보여주는 뷰 v_publisher_loyal_customer를 작성하시오.
create view v_publisher_loyal_customer as
    select c.name, b.publisher, count(b.bookname) as "구매 종류 수"
    from Customer c
    join Order o on c.custid = o.custid
    join Book b on o.bookid = b.bookid
    group by b.publisher
    having count(b.bookname) > 2;

--문제 10.도서별로 최고가, 최저가, 평균가로 판매된 가격과 정가 대비 최대 할인금액을 보여주는 뷰 v_book_price_stats를 작성하시오.
--(출력 컬럼: 도서명, 출판사, 최고판매가, 최저판매가, 평균판매가, 최대할인금액)
create view v_book_price_stats as
    select b.bookname, b.publisher, MAX(o.saleprice) as "최고판매가", MIN(o.saleprice) as "최저판매가", AVG(o.saleprice) as "평균판매가", MAX(o.saleprice) - MIN(o.saleprice) as "최대할인금액"
    from Order o
    join Book b on o.bookid = b.bookid
    
--[사원 데이터베이스]
--Employee(empno, name, phoneno, address, sex, position, salary, depno)
--Department(depno, deptname, ,manager)
--Project(projno, projname, deptno)
--Works(empno, projno, hours_worked)
--문제 1.모든 사원의 사원번호, 이름, 부서명, 직급, 급여를 보여주는 뷰 v_emp_basic을 작성하시오. 
create view v_emp_basic as
select e.empno, e.name, d.deptname, e.position, e.salary
from Employee e
join Department d on e.depno = d.depno;
--문제 2.급여가 500만원 이상인 사원의 이름, 직급, 급여, 부서명을 보여주는읽기 전용 뷰 v_high_salary_emp를 작성하시오. 
create view v_high_salary_emp as
    select e.name, e.position, e.salary, d.deptname
    from Employee e
    join Department d on e.depno = d.depno
    where e.salary >= 500
with read only;
--문제 3.현재 진행 중인 프로젝트(오늘 날짜가 시작일과 종료일 사이)의 프로젝트번호, 프로젝트명, 시작일, 종료일을 보여주는 뷰 v_active_projects를 작성하시오. 
create view v_active_projects as
    select projno, projname, start_date, end_date
    from Project
    where TO_DATE(sysdate, 'YYYY-MM-DD') between start_date and end_date;
--문제 4.입사일이 2019년 이전인 사원의 사원번호, 이름, 부서명, 입사일, 근속연수를 보여주는 뷰 v_veteran_employee를 작성하시오.
--(근속연수는 현재 연도 기준으로 계산)
create view v-v_veteran_employee as
    select e.empno, e.name, d.deptname, e.hire_date, (2026 - EXTRACT(YEAR FROM e.hire_date)) as work_years
    from Employee E
    join Department d on e.depno = d.depno
    where e.hire_date < '2019-01-01'
--문제 5.부서 위치가 '서울'인 부서의 부서번호, 부서명, 예산을 보여주는 뷰 v_seoul_department를 작성하시오. 
CREATE VIEW v_seoul_department AS
SELECT depno, deptname, budget
FROM Department
WHERE location = '서울';
--문제 6.직급이 '부장' 또는 '이사'인 사원의 사원번호, 이름, 직급, 급여를 보여주는읽기 전용 뷰 v_senior_position를 작성하시오. 
CREATE VIEW v_senior_position AS
SELECT empno, name, position, salary
FROM Employee
WHERE position IN ('부장', '이사')
WITH READ ONLY;
--문제 7.프로젝트에서 'PM' 역할을 담당하는 사원의 사원번호, 프로젝트번호, 담당역할, 투입시간을 보여주는 뷰 v_pm_role을 작성하시오. 
CREATE VIEW v_pm_role AS
SELECT empno, projno, role, hours_worked
FROM Works
WHERE role = 'PM';
--문제 8.급여가 300만원 미만인 사원 중 입사일이 2022년 이후인 사원의 이름, 직급, 급여, 입사일을 보여주는 뷰 v_junior_emp를 작성하시오. 
CREATE VIEW v_junior_emp AS
SELECT name, position, salary, hire_date
FROM Employee
WHERE salary < 300 AND hire_date >= '2022-01-01';
--문제 9.예산이 1억원 이상인 프로젝트의 프로젝트명, 시작일, 종료일, 예산을 보여주는읽기 전용 뷰 v_large_budget_project를 작성하시오. 
CREATE VIEW v_large_budget_project AS
SELECT projname, start_date, end_date, budget
FROM Project
WHERE budget >= 10000
WITH READ ONLY;
--문제 10.관리자가 없는 최상위 관리자이면서 급여가 700만원 이상인 사원의사원번호, 이름, 부서명, 직급, 급여를 보여주는 읽기 전용 뷰 v_top_executive를 작성하시오.
CREATE VIEW v_top_executive AS
SELECT E.empno, E.name, D.deptname, E.position, E.salary
FROM Employee E
JOIN Department D ON E.depno = D.depno
WHERE E.manager_id IS NULL AND E.salary >= 700
WITH READ ONLY;

--[복합 뷰]
--문제 1.부서별 평균 급여와 최고 급여, 최저 급여를 보여주는 뷰 v_dept_salary_stats를 작성하시오.
--(출력 컬럼: 부서명, 평균급여, 최고급여, 최저급여)
CREATE VIEW v_dept_salary_stats AS
SELECT D.deptname, AVG(E.salary) AS avg_salary, MAX(E.salary) AS max_salary, MIN(E.salary) AS min_salary
FROM Employee E
JOIN Department D ON E.depno = D.depno
GROUP BY D.deptname;
--문제 2.각 사원이 참여한 프로젝트 수와 총 투입시간을 보여주는 뷰 v_emp_project_summary를 작성하시오.
--(출력 컬럼: 사원이름, 참여프로젝트수, 총투입시간)
CREATE VIEW v_emp_project_summary AS
SELECT E.name, COUNT(W.projno) AS project_count, SUM(W.hours_worked) AS total_hours
FROM Employee E
JOIN Works W ON E.empno = W.empno
GROUP BY E.empno, E.name;
--문제 3.부서별 예산 대비 해당 부서 사원들의 평균 급여 비율을 보여주는 뷰 v_dept_budget_ratio를 작성하시오.
--(출력 컬럼: 부서명, 부서예산, 평균급여, 급여예산비율) 단, 급여예산비율은 소수점 2자리까지 표시한다. 
CREATE VIEW v_dept_budget_ratio AS
SELECT D.deptname, D.budget, AVG(E.salary) AS avg_salary, ROUND(AVG(E.salary) / D.budget * 100, 2) AS salary_budget_ratio
FROM Department D
JOIN Employee E ON D.depno = E.depno
GROUP BY D.deptname, D.budget;
--문제 4.현재 진행 중인 프로젝트에 참여하고 있는 사원의 이름, 부서명, 프로젝트명, 담당역할을 보여주는 뷰 v_active_project_emp를 작성하시오. 
CREATE VIEW v_active_project_emp AS
SELECT E.name, D.deptname, P.projname, W.role
FROM Employee E
JOIN Department D ON E.depno = D.depno
JOIN Works W ON E.empno = W.empno
JOIN Project P ON W.projno = P.projno
WHERE P.end_date >= '2026-04-19';
--문제 5.한 번도 프로젝트에 참여하지 않은 사원의 사원번호, 이름, 부서명, 직급을 보여주는 뷰 v_no_project_emp를 작성하시오. 
CREATE VIEW v_no_project_emp AS
SELECT E.empno, E.name, D.deptname, E.position
FROM Employee E
JOIN Department D ON E.depno = D.depno
WHERE E.empno NOT IN (SELECT empno FROM Works);
--문제 6.프로젝트별 참여 사원 수와 총 투입시간, 평균 투입시간을 보여주는 뷰 v_project_stats를 작성하시오.
--(출력 컬럼: 프로젝트명, 참여사원수, 총투입시간, 평균투입시간)
CREATE VIEW v_project_stats AS
SELECT P.projname, COUNT(W.empno) AS worker_count, SUM(W.hours_worked) AS total_hours, AVG(W.hours_worked) AS avg_hours
FROM Project P
JOIN Works W ON P.projno = W.projno
GROUP BY P.projname;
--문제 7.자신이 속한 부서의 평균 급여보다 높은 급여를 받는 사원의 이름, 부서명, 급여, 부서평균급여를 보여주는 뷰 v_above_dept_avg를 작성하시오. 
CREATE VIEW v_above_dept_avg AS
SELECT name, deptname, salary, dept_avg_salary
FROM (
    SELECT E.name, D.deptname, E.salary, AVG(E.salary) OVER(PARTITION BY E.depno) AS dept_avg_salary
    FROM Employee E
    JOIN Department D ON E.depno = D.depno
) AS temp
WHERE salary > dept_avg_salary;
--문제 8.각 부서에서 가장 오래 근무한 사원의 이름, 부서명, 입사일, 근속연수를 보여주는 뷰 v_longest_serving를 작성하시오. 
CREATE VIEW v_longest_serving AS
SELECT E.name, D.deptname, E.hire_date, (2026 - EXTRACT(YEAR FROM E.hire_date)) AS work_years
FROM Employee E
JOIN Department D ON E.depno = D.depno
WHERE E.hire_date = (SELECT MIN(hire_date) FROM Employee WHERE depno = E.depno);
--문제 9.2개 이상의 프로젝트에 참여하면서 총 투입시간이 100시간 이상인 사원의 이름, 참여프로젝트수, 총투입시간을 보여주는 뷰 v_active_emp를 작성하시오. 
CREATE VIEW v_active_emp AS
SELECT E.name, COUNT(W.projno) AS project_count, SUM(W.hours_worked) AS total_hours
FROM Employee E
JOIN Works W ON E.empno = W.empno
GROUP BY E.empno, E.name
HAVING COUNT(W.projno) >= 2 AND SUM(W.hours_worked) >= 100;
--문제 10.부서별로 'PM' 역할을 맡은 사원 수와 해당 부서의 평균 급여를 보여주는 뷰 v_dept_pm_stats를 작성하시오.
--(출력 컬럼: 부서명, PM수, 부서평균급여)
CREATE VIEW v_dept_pm_stats AS
SELECT D.deptname, COUNT(CASE WHEN W.role = 'PM' THEN 1 END) AS pm_count, AVG(E.salary) AS avg_salary
FROM Department D
JOIN Employee E ON D.depno = E.depno
LEFT JOIN Works W ON E.empno = W.empno
GROUP BY D.deptname;



