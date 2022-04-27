2022-0426-01)집합연산자
 - SQL연산의 결과를 데이터 집합(set)이라고도 함
 - 이런 집합들 사이의 연산을 수행하기 위한 연산자를 집합연산자라 함
 - UNION, UNION ALL, INTERSECT, MINUS가 제공
 - 집합연산자로 연결되는 각 SELECT문의 SELECT절의 컬럼의 갯수, 순서, 타입이
   일치해야함
 - ORDER BY절은 맨 마지막 SELECT문에만 사용 가능
 - 출력은 첫 번째 SELECT문의 SELECT절이 기준이됨
 
 (사용형식)
  SELECT 컬럼LIST
    FROM 테이블명
   [WHERE 조건]
  UNION|UNION ALL|INTERSECT|MINUS
   SELECT 컬럼LIST
     FROM 테이블명
   [WHERE 조건]
        :
  UNION|UNION ALL|INTERSECT|MINUS
   SELECT 컬럼LIST
     FROM 테이블명
   [WHERE 조건]
   [ORDER BY 컬럼명|컬럼idex [ASC|DESC],...];
   
1. UNION
 - 중복을 허락하지 않은 합집합의 결과를 반환
 - 각 SELECT문의 결과를 모두 포함
 
 사용예)회원테이블에서 20대 여성회원과 충남거주회원의 회원번호,회원명,직업,
       마일리지를 조회하시오.
    SELECT MEM_ID AS 회원번호,
           MEM_NAME AS 회원명,
           MEM_JOB AS 직업,
           MEM_MILEAGE AS 마일리지
      FROM MEMBER
     WHERE (EXTRACT(YEAR FROM SYSDATE)-EXTRACT(YEAR FROM MEM_BIR)) 
            BETWEEN 20 AND 29
       AND  SUBSTR(MEM_REGNO2,1,1) IN('2','4')  
UNION        
     SELECT MEM_ID AS 회원번호,
           MEM_NAME AS 회원명,
           MEM_JOB AS 직업,
           MEM_MILEAGE AS 마일리지
      FROM MEMBER
     WHERE MEM_ADD1 LIKE '충남%'  
    ORDER BY 1; 

2. INTERSECT
 - 교집합(공통부분)의 결과 반환
 
사용예)회원테이블에서 20대 여성회원과 충남거주회원 중 마일리지가 2000이상인
      회원의 회원번호,회원명,직업,마일리지를 조회하시오.
    
     SELECT MEM_ID AS 회원번호,
           MEM_NAME AS 회원명,
           MEM_JOB AS 직업,
           MEM_MILEAGE AS 마일리지
      FROM MEMBER
     WHERE (EXTRACT(YEAR FROM SYSDATE)-EXTRACT(YEAR FROM MEM_BIR)) 
            BETWEEN 20 AND 29
       AND  SUBSTR(MEM_REGNO2,1,1) IN('2','4')  
UNION        
     SELECT MEM_ID AS 회원번호,
           MEM_NAME AS 회원명,
           MEM_JOB AS 직업,
           MEM_MILEAGE AS 마일리지
      FROM MEMBER
     WHERE MEM_ADD1 LIKE '충남%'  
INTERSECT
     SELECT MEM_ID AS 회원번호,
           MEM_NAME AS 회원명,
           MEM_JOB AS 직업,
           MEM_MILEAGE AS 마일리지
      FROM MEMBER
     WHERE MEM_MILEAGE>=2000  
    ORDER BY 1;   

3. UNION ALL
 - 중복을 허락하여 합집합의 결과를 반환
 - 각 SELECT문의 결과를 모두 포함(중복 포함)
 
사용예)
   1) DEPTS테이블에서 PARENT_ID가 NULL인 자료의 부서코드,부서명,상위부서코드,
      레벨을 조회하시오
      단,상위부서코드 는 0이고 레벨은 1이다
  SELECT DEPARTMENT_ID,
         DEPARTMENT_NAME,
         0 AS PARENT_ID,
         1 AS LEVELS
    FROM HR.DEPTS
   WHERE PARENT_ID IS NULL; 

   2) DEPTS테이블에서 NULL인 상위부서코드의 부서코드와 상워부서코드로 가진
      부서의 부서코드,부서명, 상위부서코드,레벨을 조회하시오.
      단, 레벨은 2이고 부서명은 왼쪽에 4칸의 공백을 삽입 후 부서명 출력
  SELECT B.DEPARTMENT_ID,
         LPAD(' ',4*(2-1))||B.DEPARTMENT_NAME AS DEPARTMENT_NAME,
         B.PARENT_ID AS PARENT_ID,
         2 AS LEVELS
    FROM HR.DEPTS A, HR.DEPTS B
   WHERE A.PARENT_ID IS NULL
     AND B.PARENT_ID= A.DEPARTMENT_ID; 
     
(결합)
    SELECT DEPARTMENT_ID,
         DEPARTMENT_NAME,
         NVL(PARENT_ID,0) AS PARENT_ID,
         1 AS LEVELS,
         PARENT_ID||DEPARTMENT_ID AS TEMP
     FROM HR.DEPTS
    WHERE PARENT_ID IS NULL 
 UNION ALL
   SELECT B.DEPARTMENT_ID,
         LPAD(' ',4*(2-1))||B.DEPARTMENT_NAME AS DEPARTMENT_NAME, --총무기획부(1) 나머지 (2) 총무기획부 4*(1-1)=0 
         B.PARENT_ID AS PARENT_ID,
         2 AS LEVELS,
          B.PARENT_ID||B.DEPARTMENT_ID AS TEMP
    FROM HR.DEPTS A, HR.DEPTS B --셀프조인
   WHERE A.PARENT_ID IS NULL
     AND B.PARENT_ID= A.DEPARTMENT_ID
 UNION ALL
   SELECT C.DEPARTMENT_ID,
         LPAD(' ',4*(3-1))||C.DEPARTMENT_NAME AS DEPARTMENT_NAME,  
         C.PARENT_ID AS PARENT_ID,
         3 AS LEVELS,
          B.PARENT_ID||C.PARENT_ID ||C.DEPARTMENT_ID AS TEMP
    FROM HR.DEPTS A, HR.DEPTS B, HR.DEPTS C
   WHERE A.PARENT_ID IS NULL
     AND B.PARENT_ID= A.DEPARTMENT_ID
     AND C.PARENT_ID= B.DEPARTMENT_ID
     ORDER BY 5;
   
사용예) 장바구니테이블에서 4월과 6월에 판매된 모든 상품정보를 중복되지 않게 조회하시오
       Alias는 상품번호,상품명,판매수량 이며 상품번호 순으로 출력하시오.
       
       SELECT A.PROD_ID AS 상품번호,
              A.PROD_NAME AS 상품명,
              SUM(B.CART_QTY) AS 판매수량
         FROM PROD A, CART B
        WHERE B.CART_PROD = A.PROD_ID 
          AND SUBSTR(B.CART_NO,1,8) LIKE '202004%'
        GROUP BY A.PROD_ID, A.PROD_NAME
UNION
        SELECT A.PROD_ID AS 상품번호,
              A.PROD_NAME AS 상품명,
              SUM(B.CART_QTY) AS 판매수량
         FROM PROD A, CART B
        WHERE B.CART_PROD = A.PROD_ID 
          AND SUBSTR(B.CART_NO,1,8) LIKE '202006%'
        GROUP BY A.PROD_ID, A.PROD_NAME
        ORDER BY 1;

사용예) 장바구니테이블에서 4월에도 판매되고 6월에도 판매된 상품정보를 조회하시오
       Alias는 상품번호,상품명이며 상품번호 순으로 출력하시오.
        
        SELECT A.PROD_ID AS 상품번호,
              A.PROD_NAME AS 상품명
         FROM PROD A, CART B
        WHERE B.CART_PROD = A.PROD_ID 
          AND SUBSTR(B.CART_NO,1,8) LIKE '202004%'
INTERSECT
        SELECT A.PROD_ID AS 상품번호,
              A.PROD_NAME AS 상품명
         FROM PROD A, CART B
        WHERE B.CART_PROD = A.PROD_ID 
          AND SUBSTR(B.CART_NO,1,8) LIKE '202006%'
        ORDER BY 1;
       
 
사용예) 장바구니테이블에서 4월과 6월에도 판매된 상품 중 6월에만 판매된 상품정보를
       조회하시오
       Alias는 상품번호,상품명,판매수량 이며 상품번호 순으로 출력하시오.
        
        SELECT A.PROD_ID AS 상품번호,
              A.PROD_NAME AS 상품명,
              SUM(B.CART_QTY) AS 판매수량
         FROM PROD A, CART B
        WHERE B.CART_PROD = A.PROD_ID 
          AND SUBSTR(B.CART_NO,1,8) LIKE '202004%'
        GROUP BY A.PROD_ID, A.PROD_NAME
UNION
        SELECT A.PROD_ID AS 상품번호,
              A.PROD_NAME AS 상품명,
              SUM(B.CART_QTY) AS 판매수량
         FROM PROD A, CART B
        WHERE B.CART_PROD = A.PROD_ID 
          AND SUBSTR(B.CART_NO,1,8) LIKE '202006%'
        GROUP BY A.PROD_ID, A.PROD_NAME
MINUS
        SELECT A.PROD_ID AS 상품번호,
              A.PROD_NAME AS 상품명,
              SUM(B.CART_QTY) AS 판매수량
         FROM PROD A, CART B
        WHERE B.CART_PROD = A.PROD_ID 
          AND SUBSTR(B.CART_NO,1,8) LIKE '202004%'
        GROUP BY A.PROD_ID, A.PROD_NAME
        ORDER BY 1;