/*
26.03.31
데이터베이스 연습문제 19번

Passenger(pid, pname, pgender, pcity)   //승객정보
Agency(aid, aname, acity)               //여행사 정보
Flight(fid, fdate, time, src, dest)     //항공편 정보
Booking( pid, aid, fid, fdate)          //예약정보
*/

-- 1) 도착지가 제주인 항공편에 대한 정보를 보이시오
select *    --3. 모든 속성 보여주기
from Flight -- 1. 항공편 테이블에서
where dest = '제주';    -- 2. 목적지가 '제주'인것만

-- 2)출발지가 김포(src)이고 도착지가 제주(dest)인 항공편에 대한 정보를 보이시오
select *    -- 3. 모든 속성 보여주기
from Flight -- 1. 항공편 테이블에서
where src = '김포' -- 2. 출발지가 '김포'이면서 목적지가 '제주'인것만
and dest = '제주';

-- 3)고객번호가 100번인 승객이 2025년1월 1일 이후에 탑승한 비행기 번호(fid)를 보이시오
select distinct b.fid   --3. 중복을 제거하고 비행기 번호를 보여준다
from Passenger p    -- 1. 승객 테이블과 예약테이블에서 고객번호가 같은것끼리 합친다
join Booking b on p.pid = b.pid
where p.pid = 100   -- 2. 고객번호가 100번이면서 출발 날짜가 2025-01-01 이후인 행만 찾아서
and b.fdate > TO_DATE('2025-01-01', 'YYYY-MM-DD');

-- 4)예약을 한 적이 있는 고객의 이름(pname)을 보이시오
select p.pname
from Passenger p
where exists(
    select 1
    from Booking b
    where p.pid = b.pid
);

-- 5)예약을 한 적이 없는 고객의 이름(pname)을 보이시오 
select p.pname
from Passenger p
where not exists(
    select 1
    from Booking b
    where p.pid = b.pid
);

-- 6)고객번호가 100번인 승객이 거주하는 도시(pcity)와 같은 도시에 위치한 여행사(aname)의 이름을 보이시오
select a.aname
from Agency a
where a.acity = (
    select p.pcity
    from Passenger p
    where p.pid = 100
);

-- 7)2025년 1월 1일부터 1월 30일 사이에 출발시각이 16:00이후인 항공편 정보를 보이시오
select *
from Flight
where time >= '16:00'
AND fdate between TO_DATE('2025-01-01', 'YYYY-MM-DD') AND TO_DATE('2025-01-30', 'YYYY-MM-DD');

-- 8)고객번호가 100번인 승객이 한 번도 예약하지 않은 여행사의 이름(aname)을 보이시오
select a.aname
from Agency a
where not EXISTS(
    select 1
    from Booking b
    where b.pid = 100
);

-- 9)마당여행사(aname)를 통해 예약한 남자 승객(pgender)의 정보를 보이시오
select *
from Passenger p
where p.pgender = '남'
and EXISTS(
    select 1
    from Booking b
    join Agency a on b.aid = a.aid
    where p.pid = b.pid
    and a.aname = '마당여행사'
);


/*
연습문제 20번

Employee(empno, name, phoneno, address, sex, position, deptno)
Department(deptno, deptname, manager)
Project(projno, projname, deptno)
Works(empno,projno, hours_worked)
*/

-- 1)각 릴레이션의 기본키를 정하시오
/*
Employee    - empno
Department  - deptno
Project     - projno
Works       - empno+projno
*/

-- 2)릴레이션 간의 관계를 고려하여 외래키를 찾아보시오
/*
Employee - deptno 사원은 부서에 속한다
Department - empno 부서엔 부서장들이 있다
Project - deptno 부서가 맡은 프로젝트가 있다
Works   - empno 프로젝트에 참여해 일하는 사원이 있다
Works   - projno 어떤 프로젝트에서 일하는지 알아야 한다
*/

-- 3)모든 직원의 이름을 보이시오
select name
from Employee;

-- 4)성별이 여자인 직원의 이름을 보이시오
select name
from Employee
where sex = '여';

-- 5)부서장(manager)의 이름과 주소를 보이시오
select name, address
from Employee
where empno in (
    select manager
    from Department
);

-- 6)IT부서에서 근무하는 직원의 이름과 주소를 보이시오
select name, address
from Employee e
left join Department d on e.deptno = d.deptno
where d.deptname = 'IT부서';

-- 7)‘미래’라는 이름의 프로젝트에서 일하는 직원의이름을 보이시오 
select name
from Employee e
where EXISTS(
    select 1
    from Works w
    join Project p on w.projno = p.projno
    where e.empno = w.empno and p.projname = '미래'
);


/*
3장 연습문제
마당 서점의 초기 자료로 실습하고자 한다. madang 사용자로 로그링 후 모든 자료를 초기화한 후 실습한다. 
    Book: bookid, bookname, publisher, price 
Customer: custid, name, address, phone 
  Orders: orderid, custid, bookid, saleprice, orderdate
*/

-- 문제 01 다음은 마당서점 고객이 알고 싶어하는 내용이다. 각 문항에 맞는 SQL문을 작성하시오

-- (1) 도서번호가 1인 도서의 이름
select bookname
from Book
where bookid = 1;

-- (2) 가격이 20,000원 이상인 도서의 이름
select bookname
from Book
where price > 20000;

-- (3)‘박지성’의 총구매액을 구하시오
select SUM(saleprice)
from Orders o
join Customer c on o.custid = c.custid
where c.name = '박지성';

-- (4)‘박지성’이 구매한 도서의 수를 구하시오
select COUNT(*)
from Orders o
join Customer c on o.custid = c.custid
where c.name = '박지성';

-- (5)‘박지성’이 구매한 도서의 출판사 수를 구하시오
select COUNT(*)
from (
    select distinct b.publisher
    from Customer c
    join Orders o on c.custid = o.custid
    join Book b on o.bookid = b.bookid
    where c.name = '박지성'
);

-- (6)‘박지성’이 구매한 도서의 이름, 가격, 정가와 판매가격의 차이를 구하시오
select b.bookname, b.price, (b.price - o.saleprice) as 차이
from Customer c
join Orders o on c.custid = o.custid
join Book b on o.bookid = b.bookid
where c.name = '박지성';

-- (7)‘박지성’이 구매하지 않은 도서의 이름을 구하시오
select bookname
from Book b
where NOT EXISTS(
    select 1
    from Customer c
    join Orders o on c.custid = o.custid
    where c.name = '박지성' and b.bookid = o.bookid
);

-- 문제 02 다음은 마당서점 운영자와 경영자가 알고 싶어 하는 내용이다. 각 문항에 맞는 SQL문을 작성하시오

-- (1) 마당서점 도서의 총수를 구하시오
select COUNT(*) as "도서의 총수"
from Book;

-- (2)마당서점에 도서를 출고하는 출판사의 총 수를 구하시오
select count(*) as "출판사의 총 수"
from (
    select DISTINCT publisher
    from book
);

-- (3)모든 고객의 이름, 주소를 구하시오
select name, address
from Customer;

-- (4)2025년 7월 4일부터 7월 7일 사이에 주문받은 도서의 주문번호를 구하시오
select orderid
from Orders
where orderdate 
between TO_DATE('2025-07-04', 'YYYY-MM-DD') 
AND TO_DATE('2025-07-07', 'YYYY-MM-DD');

-- (5)2025년 7월 4일부터 7월 7일 사이에 주문받은 도서를 제외한 도서의 주문번호를 구하시오
select orderid
from Orders
where bookid not in(
    select bookid
    from Orders
    where orderdate 
    between TO_DATE('2025-07-04', 'YYYY-MM-DD') 
    AND TO_DATE('2025-07-07', 'YYYY-MM-DD')
);

-- (6)성이 ‘김’씨인 고객의 이름과 주소를 구하시오
select name, address
from Customer
where name like '김%';

-- (7)성이 ‘김’씨이고 이름이 ‘아’로 끝나는 고객의 이름과 주소를 구하시오
select name, address
from Customer
where name like '김%아';

-- (8)주문하지 않은 고객의 이름(부속질의 사용)을 구하시오
select name
from Customer
where custid not in(
    select custid
    from Orders
);

-- (9)주문 금액의 총액과 주문의 평균금액을 구하시오
select SUM(saleprice) as "주문 금액의 총액", 
        AVG(saleprice) as "주문의 평균금액"
from orders;

-- (10)고객의 이름과 고객별 구매액을 구하시오
select name, sum(saleprice) as "고객별 구매액"
from Customer c
join Orders o on c.custid = o.custid
GROUP BY c.name;

-- (11)고객의 이름과 고객이 구매한 도서 목록을 구하시오
select c.name, b.bookname
from Orders o
join Customer c on o.custid = c.custid
join Book b on o.bookid = b.bookid
ORDER BY c.name;

-- (12)도서의 가격(Book테이블)과 판매가격(Orders 테이블)의 차이가 가장 많은 주문을 구하시오
select o.*
from Book b
join Orders o on b.bookid = o.bookid
where (b.price - o.saleprice) = (
    select max(b.price - o.saleprice)
    from Book b
    join Orders o on b.bookid = o.bookid
);

-- (13)도서의 판매액 평균보다 자신의 구매액 평균이 더 높은 고객의 이름을 구하시오
select name
from Customer c
join Orders o on c.custid = o.custid
GROUP BY name
HAVING AVG(o.saleprice) > (
    select avg(saleprice) 
    from orders
    );

-- 문제 03 다음과 같은 심화 질문에 대한 SQL문을 작성하시오.

-- (1)‘박지성’이 구매한 도서의 출판사와 같은 출판사의 도서를 구매한 고객의 이름을 구하시오.
select DISTINCT c.name
from Customer c
join Orders o on c.custid = o.custid
join Book b on o.bookid = b.bookid
where b.publisher in (
    select publisher
    from Customer c
    join Orders o on c.custid = o.custid
    join Book b on o.bookid = b.bookid
    where c.name = '박지성'
);

-- (2)두 개 이상의 서로 다른 출판사의 도서를 구매한 고객의 이름을 구하시오
select name
from Customer c
where EXISTS(
    select 1
    from Orders o
    join Book b on o.bookid = b.bookid
    where c.custid = o.custid
    HAVING 2 <= COUNT(DISTINCT b.publisher)
);

-- (3)전체 고객의 30%이상이 구매한 책 리스트를 구하시오
select bookname
from Book b
where (
    select count(DISTINCT c.custid)
    from Orders o
    join Customer c on o.custid = c.custid
    where b.bookid = o.bookid
) > ((select count(*) from Customer) * 0.3);

/*
문제 04.마당서점 데이터베이스에서 주문에 관한 사항은 Orders테이블에 저장되어 있다.
Orders 테이블을 사용하여 도서번호(bookid)가 1번인 책은 주문하였으나 
2번과 3번 책은 주문하지 않은 고객의 아이디(custid)를 찾는 SQL문을 작성하시오
*/
select custid
from Orders
where bookid = 1
and bookid not in (2, 3)
GROUP BY custid;

-- 문제 5. 다음 질의에 대해 DDL문과 DML문을 작성하시오.

-- (1)새로운 도서(‘스포츠세계’, ‘대한미디어’, 10000원)을 Book테이블에 삽입하시오. 삽입이 안될 경우 필요한 데이터가 더 있는지 찾아보시오
-- PK인 bookid가 필요하여 11 추가
INSERT INTO Book VALUES(11,'스포츠세계', '대한미디어', 10000)

-- (2)출판사 ‘삼성당’에서 출간한 도서를 삭제하시오
DELETE from book where publisher = '삼성당';

-- (3)출판사 ‘이상미디어’에서 출판한 도서를 삭제하시오. 삭제되지 않을 경우 그 원인을 설명하시오.
-- Orders테이블에서 외래키로 참조하고 있어 무결성 제약조건에 위배됨
DELETE FROM book where publisher = '이상미디어';

-- (4)출판사 ‘대한미디어’를 ‘대한출판사’로 이름을 변경하시오
update book
set publisher = '대한출판사'
where publisher = '대한미디어';

-- (5)출판사에 대한 정보를 저장하는 테이블 Bookcompany(name, address, begin)을 생성하시오.
-- name은 기본키(VARCHAR2(20)), address는 VARCHAR2(20), begin은 DATE타입으로 선언하여 생성하시오.
CREATE TABLE	 Bookcompany (
    name	 VARCHAR2(20) PRIMARY KEY,
    address  VARCHAR2(20),
    begin  DATE
    );

-- (6)Bookcompany테이블에 인터넷 주소를 저장하는 webaddress 속성을 VARCHAR2(30)으로 추가하시오
ALTER TABLE Bookcompany ADD webaddress varchar2(30);

-- (7)Bookcompany테이블에 임의의 튜플 name=한빛아카데미, address=서울시 마포구 , begin=1993-01-01, webaddress는 http://hanbit.co.kr을 삽입하시오.
INSERT INTO Bookcompany VALUES ('한빛아카데미', '서울시 마포구', TO_DATE('1993-01-01', 'YYYY-MM-DD'), 'http://hanbit.co.kr');












