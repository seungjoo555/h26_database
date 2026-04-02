-- 문제 7.릴레이션 R(A,B,C), S(C,D,E)가 주어졌을 때 다음 관계대수를 같은 의미를 갖는 SQL문으로 변환하시오

-- (1) σA=a2(R)
select * 
from R 
where A = a2;

-- (2)πA,B(R)
select A, B 
from R;

-- (3)R⋈R.c=S.c S
select *
from R r
join S s on r.c = s.c;

-- 문제 8다음 릴레이션 R(A, B, C)와 S(C,D,E)가 주어졌을 때 다음 결과가 도출되도록 sql문을 작성하시오
DROP TABLE R CASCADE CONSTRAINT;
DROP TABLE S CASCADE CONSTRAINT;

create table R(
    A varchar2(3),
    B varchar2(3),
    C varchar2(3)
);

create table S(
    C varchar2(3),
    D varchar2(3),
    E varchar2(3)
);

INSERT INTO R VALUES('a1', 'b1', 'c1');
INSERT INTO R VALUES('a2', 'b1', 'c1');
INSERT INTO R VALUES('a3', 'b1', 'c2');
INSERT INTO R VALUES('a4', 'b2', 'c4');

INSERT INTO S VALUES('c1', 'd2', 'e1');
INSERT INTO S VALUES('c1', 'd1', 'e2');
INSERT INTO S VALUES('c2', 'd3', 'e3');
INSERT INTO S VALUES('c5', 'd3', 'e3');

/*
(1)SELECT * FROM R INNER JOIN S ON (R.c=S.c);
(2)SELECT * FROM R LEFT OUTER JOIN S ON (R.c=S.c);
(3)SELECT * FROM R RIGHT OUTER JOIN S ON (R.c=S.c);
(4)SELECT * FROM R FULL OUTER JOIN S ON (R.c=S.c);
(5)SELECT * FROM R CROSS JOIN S ;
*/

-- 문제 9. UNION 설명(UNION과 UNION ALL)
DROP TABLE R1 CASCADE CONSTRAINT;
DROP TABLE R2 CASCADE CONSTRAINT;
DROP TABLE R3 CASCADE CONSTRAINT;

create table R1(
    A NUMBER(1),
    B VARCHAR2(1)
);
create table R2(
    A NUMBER(1),
    B VARCHAR2(1)
);
create table R3(
    A NUMBER(1),
    B VARCHAR2(1)
);

INSERT INTO R1 VALUES(1, 'a');
INSERT INTO R1 VALUES(2, 'b');
INSERT INTO R1 VALUES(3, 'c');

INSERT INTO R2 VALUES(2, 'b');
INSERT INTO R2 VALUES(4, 'd');

INSERT INTO R3 VALUES(3, 'c');
INSERT INTO R3 VALUES(5, 'e');
INSERT INTO R3 VALUES(1, 'a');

/*
-- UNION: 중복 자동 제거
SELECT A, B FROM R1
UNION
SELECT A, B FROM R2
UNION
SELECT A, B FROM R3; 

-- UNION ALL: 중복 포함 (더 빠름)
SELECT A, B FROM R1
UNION ALL
SELECT A, B FROM R2
UNION ALL
SELECT A, B FROM R3;
*/

-- 문제 10. EXISTS와 NOT EXISTS 예제

-- (1)주문한 적 있는 고객 조회
select *
from Customer c
where EXISTS(
    select 1
    from Orders o
    where c.custid = o.custid
);

/*
문제 17

마당서점의 테이블 구성은 다음과 같다.
(마당서점 모델)
Book(bookid, bookname, publisher, price)
Customer(custid, name, address, phone)
Orders(orderid, custid, bookid, saleprice, orderdate)
마당서점은 고객 주소 혹은 전화번호 변경을 위해 Cust_addr테이블을 추가하여고객의 주
소변경 사항을 저장하고자 한다. Cust_addt의 기본키는 (custid, addrid)이고, custid 속
성은 Customer의 custid를 참조하는 외래키이다. 새로 변경된 마당서점 데이터베이스 구조를 보고 다음 질의에 대한 SQL문을 작성하시오. 날짜는 YYYY-MM-DD 형식으로 표기하시오
*/
DROP TABLE Orders CASCADE CONSTRAINT;
DROP TABLE Book CASCADE CONSTRAINT;
DROP TABLE Customer CASCADE CONSTRAINT;
DROP TABLE Cust_addt CASCADE CONSTRAINT;


CREATE TABLE Book (
    bookid NUMBER(2) PRIMARY KEY,
    bookname VARCHAR2(40),
    publisher VARCHAR2(40),
    price NUMBER(8)
);

CREATE TABLE Customer (
    custid NUMBER(2) PRIMARY KEY,
    name VARCHAR2(40),
    address VARCHAR2(50),
    phone VARCHAR2(20)
);

CREATE TABLE Orders (
    orderid NUMBER(2) PRIMARY KEY,
    custid NUMBER(2) REFERENCES Customer(custid),
    bookid NUMBER(2) REFERENCES Book(bookid),
    saleprice NUMBER(8),
    orderdate DATE
);

CREATE TABLE Cust_addr(
    addrid NUMBER(2),
    custid NUMBER(2) NOT NULL,
    address VARCHAR2(50),
    phone VARCHAR2(20),
    changedate DATE,
    CONSTRAINT pk_주소 PRIMARY KEY(addrid, custid)
);

commit;

INSERT INTO Book VALUES(1, '데이터베이스 개론', '한빛미디어', 28000);
INSERT INTO Book VALUES(2, '자바의 정석', '길벗', 32000);
INSERT INTO Book VALUES(3, '파이썬 머신러닝', '위키북스', 25000);
INSERT INTO Book VALUES(4, '운영체제 원리', '한빛미디어', 30000);
INSERT INTO Book VALUES(5, '알고리즘 문제 풀기', '길벗', 22000);
INSERT INTO Book VALUES(6, '클린 코드', '인사이트', 33000);
INSERT INTO Book VALUES(7, 'SQL첫걸음', '한빛미디어', 24000);

INSERT INTO Customer VALUES (1, '박지수', '서울 마포구 합정동', '010-1234-5678');
INSERT INTO Customer VALUES (2, '김도윤', '경기 성남시 분당구', '010-2345-6789');
INSERT INTO Customer VALUES (3, '이서연', '서울 강남구 역삼동', '010-3456-7890');
INSERT INTO Customer VALUES (4, '최민준', '인천 부평구 부평동', '010-4567-8901');
INSERT INTO Customer VALUES (5, '정하은', '서울 송파구 잠실동', '010-5678-9012');

INSERT INTO Orders VALUES (1, 1, 1, 28000, TO_DATE('2026-01-05', 'YYYY-MM-DD'));
INSERT INTO Orders VALUES (2, 1, 3, 23000, TO_DATE('2026-01-08', 'YYYY-MM-DD'));
INSERT INTO Orders VALUES (3, 2, 2, 32000, TO_DATE('2026-01-10', 'YYYY-MM-DD'));
INSERT INTO Orders VALUES (4, 2, 5, 20000, TO_DATE('2026-01-12', 'YYYY-MM-DD'));
INSERT INTO Orders VALUES (5, 3, 4, 30000, TO_DATE('2026-01-15', 'YYYY-MM-DD'));
INSERT INTO Orders VALUES (6, 3, 6, 31000, TO_DATE('2026-01-15', 'YYYY-MM-DD'));
INSERT INTO Orders VALUES (7, 4, 7, 22000, TO_DATE('2026-01-18', 'YYYY-MM-DD'));
INSERT INTO Orders VALUES (8, 5, 1, 26000, TO_DATE('2026-01-20', 'YYYY-MM-DD'));
INSERT INTO Orders VALUES (9, 5, 2, 32000, TO_DATE('2026-01-22', 'YYYY-MM-DD'));
INSERT INTO Orders VALUES (10, 1, 6, 33000, TO_DATE('2026-01-25', 'YYYY-MM-DD'));

INSERT INTO Cust_addr VALUES (1, 1, '서울 은평구 불광동', '010-1234-5678', TO_DATE('2024-03-10', 'YYYY-MM-DD'));
INSERT INTO Cust_addr VALUES (2, 1, '서울 마포구 합정동', '010-1234-5678', TO_DATE('2025-07-20', 'YYYY-MM-DD'));
INSERT INTO Cust_addr VALUES (1, 2, '경기 수원시 팔달구', '010-2345-6789', TO_DATE('2023-11-05', 'YYYY-MM-DD'));
INSERT INTO Cust_addr VALUES (2, 2, '경기 성남시 분당구', '010-9999-0000', TO_DATE('2025-02-14', 'YYYY-MM-DD'));
INSERT INTO Cust_addr VALUES (1, 3, '서울 강남구 역삼동', '010-3456-7890', TO_DATE('2025-05-01', 'YYYY-MM-DD'));
INSERT INTO Cust_addr VALUES (1, 4, '부산 해운대구 우동', '010-4567-8901', TO_DATE('2024-08-22', 'YYYY-MM-DD'));

commit;


-- (1)고객번호 1번의 주소 변경 내역을 모두 조회하시오
select *
from Cust_addr
where custid = 1;

-- (2)고객번호 1번의 전화번호 변경 내역을 모두 조회하시오
select phone
from Cust_addr
where custid = 1;

-- (3)고객번호 1번의 가입 당시 전화번호를 조회하시오
select phone
from Cust_addr
where custid = 1 and addrid = 1;

-- (4)고객번호 1번의 “2025년 01월 01” 당시 전화번호를 보이시오. 주소 이력 중 changeday 속성값이 “2025년 01”보다 오래된 첫 번째 값을 찾는다.
select phone
from Cust_addr
where custid = 1
and addrid = (
    select MAX(addrid)
    from Cust_addr
    where custid = 1 
    and changedate < TO_DATE('2025-01-01', 'YYYY-MM-DD')
);

/*
문제 18마당서점의 태이블 구성은 17번과 같다. 마당 서점을 Cart를 추가하여 장바구니
sms 고객이 주문 전에 도서를 미리 담아놓는 역할을 하며 Orders테이블과 비슷한 구조
를 갖는다. Cart테입르의 기본 키는 cartid이고 , custid와 bookid는 각각 Customer. 
custid, 와 Book.bookid를 참조하는 외래키이다. 

Cart(cartid, custid, biikid, cartdate)
새로 변경된 마당서점 데이터베이스 구조를 보고 다음 질의에 대한 SQL문을 작성하시오
*/
CREATE TABLE Cart(
    cartid NUMBER(2) PRIMARY KEY,
    custid NUMBER(2) REFERENCES Customer(custid),
    bookid NUMBER(2) REFERENCES Book(bookid),
    cartdate DATE
);

-- (1)고객번호 1번의 cart에 저장된 도서 중 이미 주문한 도서를 구하시오
select b.bookname
from Book b
join Cart c on b.bookid = c.bookid
where b.bookname in (
    select bookname
    from Book, Orders
    where Book.bookid = Orders.bookid and Orders.custid = 1
);

-- (2)고객번호 1번의 cart에 저장된 도서 중 아직 주문하지 않은 도서를 구사시오
select b.bookname
from Book b
join Cart c on b.bookid = c.bookid
where b.bookname not in (
    select bookname
    from Book, Orders
    where Book.bookid = Orders.bookid and Orders.custid = 1
);

-- (3)고객번호 1번의 cart에 저장된 도서들의 정가 합계를 구하시오.
select SUM(b.price) as "정가 합계"
from Cart c
join Book b on c.bookid = b.bookid
where c.custid = 1;

/*
문제 19. Emp, Dept테이블로 구성된 회사사원 데이터베이스를 만들고자 한다. 테이블을 
생성하고 데이터를 입력하는 SQL질의를 작성하시오.
*/

/*
(1)부서(Department)dp 관한 Dept테이블은 deptno(부서번호), dname(부서이름), loc(부서
위치, location)으로 구성되어 있다. Dept테이블을 생성하는 SQL명령어는 다음과 같다. Dept 테이블을 생성하시오.
*/
CREATE TABLE Dept(
    deptno NUMBER(2) NOT NULL PRIMARY KEY,
    dname VARCHAR2(14),
    loc VARCHAR2(13)
);
/*
(2)사원(Employee)에 관한 Emp테이블은 empno(사원번호), ename(사원이름),job(업무), 
mgr(직속상사번호, manager) hiredate(고용날짜), sal(월급여, salary), comm(판매수
당,commission), deptno(부서번호)로 구성되어 있다. Emp의 deptno는 Dept의 deptno
를 참조하는 외래키로 지정한다. desc Emp;명령을 사용하면 테이블의 구조를 볼 수 있다. Emp테이블을 생성하는 SQL문을 작성하시오
*/
CREATE TABLE Emp(
    empno NUMBER(4) NOT NULL PRIMARY KEY,
    ename VARCHAR2(10),
    job VARCHAR2(9),
    mgr NUMBER(4),
    hiredate DATE,
    sal NUMBER(7,2),
    comm NUMBER(7,2),
    deptno NUMBER(2) REFERENCES Dept(deptno)
);

-- (3 )부서에 관한 다음 네 개의 데이터를 삽입하시오.
INSERT INTO Dept VALUES(10, 'ACCOUNTING', 'NEW YORK');
INSERT INTO Dept VALUES(20, 'RESEARCH', 'DALLAS');
INSERT INTO Dept VALUES(30, 'SALES', 'CHICAGO');
INSERT INTO Dept VALUES(40, 'OPERATION', 'BOSTON');

-- (4) 사원에 관한 다음 네 개의 데이터를 삽입하시오
INSERT INTO Emp VALUES(7369, 'SMITH', 'CLERK', 7902, TO_DATE('1980-12-17', 'YYYY-MM-DD'), 800, NULL, 20);
INSERT INTO Emp VALUES(7499, 'ALLEN', 'SALESMAN', 7698, TO_DATE('1981-02-20', 'YYYY-MM-DD'), 1600, 300, 30);
INSERT INTO Emp VALUES(7521, 'WARD', 'SALESMAN', 7698, TO_DATE('1981-02-22', 'YYYY-MM-DD'), 1250, 500, 30);
INSERT INTO Emp VALUES(7566, 'JONES', 'MANAGER', 7839, TO_DATE('1981-04-02', 'YYYY-MM-DD'), 2975, NULL, 20);

-- (5 )사원 테이블에 다음 데이터를 삽입하려고 하니 오류가 발생하였다. 오류 메시지를 확인해 보고 원인을 찾아보시오
/*
INSERT INTO Emp (empno,ename, job,mgr, hiredate,sal,comm,deptno ) values (7654,'MARTIN', 'SALESMAN',7698, TO_DATE('1981-09-28','YYYY-MM-DD'), 1250,1400,50);
SP2-0552: 바인드 변수 "00" 가 정의되지 않았습니다. 
- TO_DATE 사용해야 함
ORA-02291: 무결성 제약조건(C##MADANG.SYS_C008730)이 위배되었습니다- 부모 키가 없습니다
- Dept테이블의 deptno를 참조해야 하는데 50이라는 데이터가 없음
*/

-- (6)각 사원의 사원이름(ename)과 소속 부서이름(dname), 부서위치(loc)를 함께 조회하시오
select ename, dname, loc
from Emp e
join Dept d on e.deptno = d.deptno;

-- (7)부서가 배정된 사원의 사원번호(empno), 사원이름(ename), 부서이름(dname)을 조회하시오. 부서가 없는 사원은 제외한다.
select empno, ename, dname
from Emp e
join Dept d on e.deptno = d.deptno
where e.deptno is not null;

-- (8)부서 위치(loc)가 'DALLAS'인 부서에 소속된 모든 사원의 이름(ename), 업무(job), 월급여(sal)를 조회하시오.
select ename, job, sal
from Emp e
join Dept d on e.deptno = d.deptno
where d.loc = 'DALLAS';

-- (9)부서 위치(loc)가 'DALLAS'인 부서에 소속된 사원의 이름(ename), 업무(job)를 조회하시오. 서브쿼리를 사용할 것.
select ename, job
from Emp
where deptno = (
    select deptno
    from Dept
    where loc = 'DALLAS'
);

-- (10)전체 사원의 평균 급여(AVG(sal))보다 급여가 높은 사원의 이름(ename)과 급여(sal)를 조회하시오.
select ename, sal
from Emp
where sal > (
    select AVG(sal)
    from Emp
);

-- (11)각 사원의 이름(ename)과 그 사원의 직속상사 이름을 함께 조회하시오. 상사가 없는 사원도 포함할 것.
select e1.ename as "사원이름", e2.ename as "직속상사"
from Emp e1
LEFT OUTER JOIN Emp e2
on e1.mgr = e2.empno;

-- (12)각 부서에서 급여가 가장 높은 사원의 이름(ename), 급여(sal), 부서이름(dname)을 조회하시오. 조인과 서브쿼리를 함께 사용할 것.
select ename, sal, dname
from Emp e
join Dept d on e.deptno = d.deptno
where sal in (
    select max(sal)
    from Emp
    group by deptno
);

-- (13)부서 테이블의 구조를 변경하여 부서장의 이름을 저장하는 manager속성을 추가하고자 한다. ALTER 문을 사용하여 작성해 보시오. managername 속성이 만들어졌으면 UPDATE문을 이용하여 MANAGER의 이름을 입력하시오.
ALTER TABLE Dept ADD manager VARCHAR2(10);

UPDATE Dept
set manager = 'JONES'
WHERE deptno = 20;

/*
문제 20.[극장데이터베이스]
제약조건
영화가격은 20,000원을 넘지 않아야 한다. 상영관번호는 1~10사이다
같은 사람이 같은 좌석번호를 두 번 예약하지 않아야 한다.
*/

-- (1)단순질의
-- ①모든 극장의 이름과 위치를 보이시오
select 극장이름, 위치
from 극장;

-- ②‘잠실’에 있는 극장을 보이시오
select *
from 극장
where 위치 = '잠실';

-- ③‘잠실’에 사는 고객의 이름을 오름차순으로 보이시오
select 이름
from 고객
order by acs;

-- ④가격이 8,000원 이하인 영화의 극장번호,영화제목을 보이시오
select 극장번호, 영화제목
from 상영관
where 가격 < 8000;

-- ⑤극장 위치와 고객의 주소가 같은 고객을 보이시오
select *
from 극장 a
left outer join 고객 c on a.위치 = c.고객;

-- (2)집계질의
-- ①극장의 수는 몇 개인가?
select count(*) as "극장의 수"
from 극장;

-- ②상영되는 영화의 평균 가격은 얼마인가?
select AVG(가격) as "평균 가격"
from 상영관;

-- ③2025년 9월 1일에 영화를 관람한 고객의 수는 얼마인가?
select count(*) as "관람 고객 수"
from 고객 c
join 예약 e on c.고객번호 = e.고객번호
where 날짜 = TO_DATE('2025/09/01', 'YYYY/MM/DD');

-- (3)부속질의와 조인
-- ①‘대한’극장에서 상영된 영화 제목을 보이시오
select 영화제목
from 상영관 a
join 극장 b on a.극장번호 = b.극장번호
where 극장이름 = '대한';

-- ②‘대한’극장에서 영화를 본 고객의 이름을 보이시오
select 이름
from 고객 c
where EXISTS(
    select 1
    from 예약 e
    join 극장 d on e.극장번호 = d.극장번호
    where c.고객번호 = e.고객번호 and d.극장이름 = '대한'
);

-- ③‘대한 극장의 전체 수입을 보이시오
select sum(가격) as "전체수입"
from 상영관 s
join 예약 r on s.극장번호 = r.극장번호
join 극장 t on r.극장번호 = t.극장번호
where t.극장이름 = '대한';


-- (4)그룹질의
-- ①극장별 상영관 수를 보이시오
select t.극장이름, count(*) as "상영관 수"
from 상영관 s
join 극장 t on s.극장번호 = t.극장번호
group by t.극장이름;

-- ②‘잠실’에 있는 극장의 상영관을 보이시오
select * 
from 상영관 s
where EXISTS(
    select 1
    from 극장 t
    where s.극장번호 = t.극장번호
    and t.위치 = '잠실'
);

-- ③2025년 9월 1일의 극장별 평균 관람 고객 수를 보이시오
select 극장이름, COUNT(*)
from 예약 r
join 상영관 s on r.상영관번호 = s.상영관번호
join 극장 t on s.극장번호 = t.극장번호
where r.날짜 = TO_DATE('2025/09/01', 'YYYY/MM/DD')
group by 극장이름;

-- ④2025년 9월 1일에 가장 많은 고객이 관람한 영화를 보이시오
select 영화제목
from 상영관 s
join 예약 r on s.상영관번호 = r.상영관번호 and s.극장번호 = r.극장번호
where r.날짜 = TO_DATE('2025/09/01', 'YYYY/MM/DD')
group by 영화제목
having count(*) = (
    select max(count(*))
    FROM 상영관 s2
    JOIN 예약 r2 ON s2.상영관번호 = r2.상영관번호
    WHERE r2.날짜 = TO_DATE('2025/09/01', 'YYYY/MM/DD')
    GROUP BY s2.영화제목
);

-- (5)DML
-- ①각 테이블에 데이터를 삽입하는 INSERTans을 하나씩 실행시켜 보시오.
INSERT INTO 극장 VALUES(6, '롯데', '잠실');
INSERT INTO 상영관 VALUES(6, 1, '어려운영화', 15000, 48);
INSERT INTO 고객 VALUES(9, '홍길동', '강남');
INSERT INTO 예약 VALUES(6, 1, 9, 15, TO_DATE('2025/09/01', 'YYYY/MM/DD'));
-- ②영화의 가격을 10%씩 인상하시오
UPDATE 상영관 SET 가격 = 가격*1.1;

/*
문제 21[판매원 데이터베이스] 
다음 릴레이션을 보고 물음에 답하시오. 
Salesperson은 판매액, Order는 주문, Customer는 고객을 나타낸다. 
밑줄 친 속성은 기본키이고 custname과 salesperson은 각각 Custer.name과 Salesperson.name을 참조하는 외래키이다.
Salesperson(name, age, salary)
Order(number, custname, salesperson, amount)
Customer(name, city, industrytype)
*/

-- (1)테이블을 생성하는 CREATE 문과 데이터를 삽입하는 INSERT문을 작성하시오. 
-- 테이블의 데이터 타입은 임의로 정하고,데이터는 다음 질의의 결과가 나오도록 삽입한다.
-- (2)모든 판매원의 이름과 급여를 보이시오. 단 중복 행은 제거한다.
select DISTINCT name, salary
from Salesperson;
-- (3)나이가 30세 미만인 판매원의 이름을 보이시오.
select name
from Salesperson
where age > 30;
-- (4)‘S’로 끝나는 도시에 사는 고객의 이름을 보이시오.
select name
from Customer
where city like 'S%';
-- (5)주문을 한 고객의 수(서로 다른 고객만)를 구하시오.
select count(DISTINCT (custname))
from Order;
-- (6)판매원 각각에 대하여 주문의 수를 계산하시오.
select salesperson, count(number)
from Order
GROUP BY salesperson;
-- (7)‘LA’에 사는 고객으로부터 주문을 받은 판매원의 이름과 나이를 보이시오.(부속질의 사용)
select name, age
from Salesperson s
where EXISTS(
    select 1
    from Order o
    join Customer c on o.custname = c.name
    where s.name = o.salesperson
)
-- (8)‘LA’에 사는 고객으로부터 주문을 받은 판매원의 이름과 나이를 보이시오.(조인 사용)
select name, age
from Salesperson s
join Order o on s.name = o.salesperson
join Customer c on o.custname = c.name
where c.city = 'LA';
-- (9)두 번 이상 주문을 받은 판매원의 이름을 보이시오.
select name
from Salesperson s
join Order o on s.name = o.salesperson
group by s.name
having count(*) >= 2;
-- (10)판매원 ‘TOM’의 봉급을 45,000원으로 변경하는 sql문을 작성하시오
UPDATE Salesperson set salary = 45000 where name = 'TOM';

/*
문제 22
[기업 프로젝트 데이터베이스]
다음 릴레이션을 보고 물음에 답하시오. 
Employee는 사원, Department는 부서, Project는 프로젝트, Works는 사원이 프로젝트에 참여한 내용을 나타낸다. 
한 사원이 여러 프로젝트에서 일하거나 한 프로젝트에 여러 사원이 일할 수 있다. 
hours_worked속성은 각 사원이 각 프로젝트에서 일한 시간을 나타낸다. 
밑줄 친 속성은 기본키이다. 
Employee(empno, name, phoneno, address, sex, position, depno)
Department(depno, deptname, ,manager)
Project(projno, projname, deptno)
Works(empno, projno, hours_worked)
*/

-- (1)테이블을 생성하는 CREATE문과 데이터를 삽입하는 INSERT문을 작성하시오. 테이블의 데이터 타입은 임의로 정하고,
--     데이터는 다음 질의의 결과가 나오도록 삽입한다.
-- (2)모든 사원의 이름을 보이시오
select name
from Employee;
-- (3)여자 사원의 이름을 보이시오
select name
from Employee
where sex = '여';
-- (4)팀장(manager)의 이름을 보이시오
select e.name
from Department d
left join Employee e on d.manager = e.empno;
-- (5)‘IT’부서에서 일하는 사원의 이름과 주소를 보이시오
select name, address
from Employee e
where EXISTS(
    select 1
    from Department d
    where e.depno = d.depno and d.deptname = 'IT'
);
-- (6)‘홍길동’ 팀장(manager)부서에서 일하는 사원의 수를 보이시오
select count(empno)
from Employee e
join Department d on e.depno = d.depno
where d.manager = (
    select empno
    from Employee
    where name = '홍길동'
);
-- (7)사원들이 일한 시간 수를 부서별, 사원 이름별 오름차순으로 보이시오
select d.deptname, e.name, w.hours_worked
from Works w
join Employee e on w.empno = e.empnoo
join DepartMent d on e.deptno = d.deptno
order by d.deptname, e.name;
-- (8)2명 이상의 사원이 참여한 프로젝트의 번호, 이름, 사원의 수를 보이시오
select p.projno, p.projname, count(w.empno) as "사원의 수"
from Works w
join Project p on w.projno = p.projno
group by w.projno
having count(w.empno) > 2;
-- (9)3명 이상의 사원이 있는 부서의 사원 이름을 보이시오
select name
from Employee e
left join Department d on e.depno = d.depno
where depno = (
    select depno
    from Employee e
    left join Department d on e.depno = d.depno
    group by depno
    having count(depno) > 3
);



