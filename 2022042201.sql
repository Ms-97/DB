2022-0422-01) TABLE JOIN
- 관계형 DB의 가장 핵심 기능
- 복수개의 테이블 사이에 존재하는 관계를 이용한 연산
- 정규화를 수행하면 테이블이 분활되고 필요한 자료가 복수개의 테이블에
  분산 저장된 경우 사용하는 연산

 - Join의 종류
  . 일반조인 vs ANSI JOIN
  . INNER JOIN vs OUTER JOIN
  . Equi-Join vs Non Equi-Join --조인 조건에 연산자가 사용된 경우 Equi-Join 
  . 기타(Cartesian Product, Self Join ,..ect)
 - 사용형식(일반 조인)
  SELECT 컬럼list
    FROM 테이블명1 [별칭1],테이블명2 [별칭2][,테이블명3 [별칭3],...]
   WHERE 조인조건 
    [AND 일반조건]
   . 테이블 별칭은 복수개의 테이블에 동일한 컬럼명이 존재하고 해당 컬럼을 참조하는
     경우 반드시 사용되어야 함
   . 사용되는 테이블이 n개 일때 조인조건은 적어도 n-1개 이상이여야 함
   . 조인조건은 두 테이블에 사용된 공통의 컬럼을 사용함
   
   
1. Cartesian Product
 - 조인조건이 없거나 조인조건이 잘못된 경우 발생
 - 최악의 경우(조인조건이 없는 경우) A테이블(a행 b열)과 B테이블(c행 d열)이
   Cartesian Product를 수행하면 결과는 a*c행, b+d열을 반한
 - ANSI에서는 CROSS JOIN이라고 하며 반드시 필요한 경우가 아니면 수행하지
   말아야하는 JOIN이다.
   
   (사용형식-일반조인)
   SELECT 컬럼list
     FROM 테이블명1 [별칭1],테이블명2 [별칭2][,테이블명3 [별칭3],...]
      
    (사용형식-ANSI조인)
   SELECT 컬럼list
     FROM 테이블명1 [별칭1]
    CROSS JOIN 테이블명; 
   
   (사용 예) 
   SELECT COUNT(*)
     FROM PROD;
    
    SELECT COUNT(*)
     FROM CART;  
   
      SELECT COUNT(*)
      FROM BUYPROD;
      
   SELECT COUNT(*)
     FROM PROD A, CART B, BUYPROD C;
     
    SELECT COUNT(*)
     FROM PROD A
    CROSS JOIN CART B             
    CROSS JOIN BUYPROD C; 
    
 2. Equi Join
 - 조인 조건에 '='연산자가 사용된 조인으로 대부분의 조인이 이에 포함된다.
 - 복수개의 테이블에 존재하는 공통의 컬럼값의 동등성 평가에 의한 조인
  (일반조인 사용형식)
   SELECT 컬럼list
     FROM 테이블1 별칭1, 테이블2 별칭2[,테이블3 별칭3,...]
    WHERE 조인조건 
   
   (ANSI조인 사용형식)
    SELECT 컬럼list
     FROM 테이블1 별칭1  --테이블 1,2는 공통의 컬럼이 필요 하지만 1,3은 굳이 필요없다.
     INNER JOIN 테이블2 별칭2 ON(조인조건 [AND 일반조건]) 
     [INNER JOIN 테이블3 별칭3 ON(조인조건 [AND 일반조건])
              :
     [WHERE 일반조건] 
     . 'AND 일반조건' : ON 절에 기술된 일반조건은 해당 INNER JOIN 절에 의해
       조인에 참여하는 테이블에 극한된 조건
     . 'WHERE 일반조건' : 모든 테이블에 적용되어야 하는 조건기술
     
    사용예) 2020년 1월 제품별 매입집계를 조회하시오.
           Alias는 제품코드,제품명,매입금액합계
    (일반 JOIN)            
         SELECT A.BUY_PROD AS 제품코드,
                B.PROD_NAME AS 제품명,
                SUM(A.BUY_QTY * B.PROD_COST) AS 매입금액합계
          FROM BUYPROD A, PROD B
         WHERE A.BUY_PROD= B.PROD_ID --조인조건 
           AND A.BUY_DATE BETWEEN TO_DATE('20200101') AND TO_DATE('20200131')
         GROUP BY A.BUY_PROD, B.PROD_NAME
         ORDER BY 1;
         
     (ANSI JOIN)            
         SELECT A.BUY_PROD AS 제품코드,
                B.PROD_NAME AS 제품명,
                SUM(A.BUY_QTY * B.PROD_COST) AS 매입금액합계
          FROM BUYPROD A
          INNER JOIN PROD B ON(A.BUY_PROD = B.PROD_ID 
           AND A.BUY_DATE BETWEEN TO_DATE('20200101') AND TO_DATE('20200131'))
         GROUP BY A.BUY_PROD, B.PROD_NAME
         ORDER BY 1;   

사용예)상품테이블에서 판매가가 50만원이상인 제품을 조회하시오.
       Alias는 상품코드, 상품명, 분류명, 거래처명, 판매가격이고 판매가격이 큰 상품순
       으로 출력하시오.
      (일반조인)
       SELECT A.PROD_ID AS 상품코드,
              A.PROD_NAME AS 상품명,
              B.LPROD_NM AS 분류명,
              C.BUYER_NAME AS 거래처명, 
              A.PROD_PRICE AS 판매가격
         FROM PROD A, LPROD B, BUYER C
        WHERE A.PROD_LGU = B.LPROD_GU    --조인조건 (분류명 출력)
          AND A.PROD_BUYER = C.BUYER_ID  --조인조건 (거래처명 출력)
          AND A.PROD_PRICE >= 500000  -- 일반조건
         ORDER BY 5 DESC;
         
       (ANSI JOIN)
       SELECT A.PROD_ID AS 상품코드,
              A.PROD_NAME AS 상품명,
              B.LPROD_NM AS 분류명,
              C.BUYER_NAME AS 거래처명, 
              A.PROD_PRICE AS 판매가격
         FROM PROD A
   INNER JOIN LPROD B ON(A.PROD_LGU = B.LPROD_GU)  --조인조건 (분류명 출력)
   INNER JOIN BUYER C ON(A.PROD_BUYER = C.BUYER_ID) --조인조건 (거래처명 출력)
          AND A.PROD_PRICE >= 500000  -- 일반조건
         ORDER BY 5 DESC;
         
  사용예) 2020년 상반기 거래처별 판매액집계를 구하시오.
       Alias는 거래처코드, 거래처명, 판매액합계
      
       (일반조인)
       SELECT A.PROD_BUYER AS 거래처코드,
              C.BUYER_NAME AS 거래처명,
              SUM(A.PROD_PRICE * B.CART_QTY) AS 판매액합계
         FROM PROD A, CART B, BUYER C
        WHERE A.PROD_BUYER = C.BUYER_ID -- 조인조건(거래처추출)
          AND A.PROD_ID = B.CART_PROD -- 조인조건(단가추출)
          AND SUBSTR(B.CART_NO,1,8) BETWEEN '202001' AND '202006'
         -- AND TO_DATE(SUBSTR(B.CART_NO,1,8),'YYMMDD') BETWEEN TO_DATE('20200101') AND TO_DATE('20200630')
          GROUP BY  A.PROD_BUYER,C.BUYER_NAME
          ORDER BY 1;
          
          (ANSI JOIN)
          SELECT A.PROD_BUYER AS 거래처코드,
                 C.BUYER_NAME AS 거래처명,
                 SUM(A.PROD_PRICE * B.CART_QTY) AS 판매액합계
            FROM PROD A
      INNER JOIN CART B ON (A.PROD_ID = B.CART_PROD)
      INNER JOIN BUYER C ON (A.PROD_BUYER = C.BUYER_ID)
             AND TO_DATE(SUBSTR(B.CART_NO,1,8),'YYMMDD') BETWEEN TO_DATE('20200101') AND TO_DATE('20200630')
          GROUP BY  A.PROD_BUYER,C.BUYER_NAME
          ORDER BY 1;
          
---------------------------------------------------------------------------------          
2022-0425-01)         
        
    사용예) HR계정에서 미국 이외의 국가에 위치한 부서에 근무하는 사워정보를
           조회하시오.
           Alias는 사원번호,사원명,부서명,직무코드,주소
           미국의 국가코드는'US'이다.
           
             SELECT A.EMPLOYEE_ID AS 사원번호,
                    A.EMP_NAME AS 사원명,
                    B.DEPARTMENT_NAME AS 부서명,
                    A.JOB_ID AS 직무코드,
                     C.STREET_ADDRESS ||' '|| C.CITY ||', '|| C.STATE_PROVINCE AS 주소
             FROM HR.EMPLOYEES A, HR.DEPARTMENTS B, HR.LOCATIONS C
             WHERE A.DEPARTMENT_ID = B.DEPARTMENT_ID --조인조건(부서추출)
                AND  B.LOCATION_ID = C.LOCATION_ID --조인조건(해당 부서의 위치코드 추출)
                AND  C.COUNTRY_ID != 'US';     
    
    사용예) 2020년 4월 거래처별 매입금액을 조회하시오.
            Alias는 거래처코드, 거래처명,매입금액합계
            (일반조인)
            SELECT A.BUYER_ID AS 거래처코드,
                   A.BUYER_NAME AS 거래처명,
                   SUM(C.PROD_COST*B.BUY_QTY) AS 매입금액합계
              FROM BUYER A, BUYPROD B, PROD C
             WHERE A.BUYER_ID = C.PROD_BUYER
               AND B.BUY_PROD = C.PROD_ID
               AND B.BUY_DATE BETWEEN TO_DATE('20200401') AND LAST_DAY('20200401')
              GROUP BY A.BUYER_ID, A.BUYER_NAME
              ORDER BY 1;
              
              (ANSI JOIN)
              SELECT A.BUYER_ID AS 거래처코드,
                   A.BUYER_NAME AS 거래처명,
                   SUM(C.PROD_COST*B.BUY_QTY) AS 매입금액합계
              FROM PROD C
            INNER JOIN BUYPROD B ON (B.BUY_PROD = C.PROD_ID AND 
                                     B.BUY_DATE BETWEEN TO_DATE('20200401') AND LAST_DAY('20200401'))
            INNER JOIN BUYER A ON (A.BUYER_ID = C.PROD_BUYER)
              GROUP BY A.BUYER_ID, A.BUYER_NAME
              ORDER BY 1;
              
    사용예) 2020년 4월 거래처별 매출금액을 조회하시오.
            Alias는 거래처코드, 거래처명,매출금액합계  
          (일반조인)
           SELECT A.BUYER_ID AS 거래처코드,
                   A.BUYER_NAME AS 거래처명,
                   SUM(C.PROD_PRICE*B.CART_QTY) AS 매출금액합계
              FROM BUYER A, CART B, PROD C
             WHERE A.BUYER_ID = C.PROD_BUYER
               AND B.CART_PROD = C.PROD_ID
               AND B.CART_NO LIKE '202004%'
              GROUP BY A.BUYER_ID, A.BUYER_NAME
              ORDER BY 1; 
              
            (ANSI JOIN)
            SELECT A.BUYER_ID AS 거래처코드,
                   A.BUYER_NAME AS 거래처명,
                   SUM(C.PROD_PRICE*B.CART_QTY) AS 매출금액합계
              FROM PROD C
        INNER JOIN BUYER A ON (A.BUYER_ID = C.PROD_BUYER) 
        INNER JOIN CART B ON (B.CART_PROD = C.PROD_ID AND
                   B.CART_NO LIKE '202004%')
              GROUP BY A.BUYER_ID, A.BUYER_NAME
              ORDER BY 1; 
    
    사용예) 2020년 4월 거래처별 매입/매출금액을 조회하시오.
            Alias는 거래처코드, 거래처명,매입금액합계,매출금액합계 
            (일반조인)
            SELECT A.BUYER_ID AS 거래처코드,
                   A.BUYER_NAME AS 거래처명,
                   SUM(D.PROD_COST*B.BUY_QTY) AS 매입금액합계,
                   SUM(D.PROD_PRICE*C.CART_QTY) AS 매출금액합계
              FROM BUYER A, BUYPROD B, CART C, PROD D
             WHERE A.BUYER_ID = D.PROD_BUYER
               AND B.BUY_PROD = D.PROD_ID
               AND C.CART_PROD = D.PROD_ID
               AND B.BUY_DATE BETWEEN TO_DATE('20200401') AND LAST_DAY('20200401')
               AND C.CART_NO LIKE '202004%'
          GROUP BY A.BUYER_ID, A.BUYER_NAME
          ORDER BY 1;                         
           
            (ANSI JOIN)
            SELECT A.BUYER_ID AS 거래처코드,
                   A.BUYER_NAME AS 거래처명,
                   SUM(D.PROD_COST*B.BUY_QTY) AS 매입금액합계,
                   SUM(D.PROD_PRICE*C.CART_QTY) AS 매출금액합계
              FROM BUYER A
        INNER JOIN PROD D ON (A.BUYER_ID = D.PROD_BUYER)
        INNER JOIN BUYPROD B ON (B.BUY_PROD = D.PROD_ID AND
                                 B.BUY_DATE BETWEEN TO_DATE('20200401') AND LAST_DAY('20200401'))
        INNER JOIN CART C ON (C.CART_PROD = D.PROD_ID AND 
                              C.CART_NO LIKE '202004%')
          GROUP BY A.BUYER_ID, A.BUYER_NAME
          ORDER BY 1; 
          
          (해결책 : 서브쿼리 + 외부조인)
         SELECT TB.CID AS 거래처코드,
                TB.CNAME AS 거래처명,
                NVL(TA.BSUM,0) AS 매입금액합계,
                NVL(TB.CSUM,0) AS 매출금액합계    
        FROM (SELECT C.PROD_BUYER AS BID,   --서브쿼리
                   SUM(C.PROD_COST*B.BUY_QTY) AS BSUM
              FROM BUYER A, BUYPROD B, PROD C
             WHERE A.BUYER_ID = C.PROD_BUYER
               AND B.BUY_PROD = C.PROD_ID
               AND B.BUY_DATE BETWEEN TO_DATE('20200401') AND LAST_DAY('20200401')
              GROUP BY C.PROD_BUYER) TA,
            (SELECT A.BUYER_ID AS CID, --서브쿼리
                   A.BUYER_NAME AS CNAME,
                   SUM(C.PROD_PRICE*B.CART_QTY) AS CSUM
              FROM BUYER A, CART B, PROD C
             WHERE A.BUYER_ID = C.PROD_BUYER
               AND B.CART_PROD = C.PROD_ID
               AND B.CART_NO LIKE '202004%'
              GROUP BY A.BUYER_ID, A.BUYER_NAME) TB
       WHERE TA.BID(+) = TB.CID --외부조인조건
    ORDER BY 1;
    
    사용예) 사원테이블에서 전체사원의 평균급여보다 더 많은 급여를 받는 사원을
           조회하시오.
           Alias는 사원번호, 사원명, 부서코드, 급여
    SELECT A.EMPLOYEE_ID AS 사원번호,
           A.EMP_NAME AS 사원명,
           A.DEPARTMENT_ID AS 부서코드,
           A.SALARY AS 급여
      FROM HR.EMPLOYEES A,
           (SELECT AVG(SALARY) AS BSAL
              FROM HR.EMPLOYEES) B
     WHERE A.SALARY > B.BSAL       
    ORDER BY 3;
           
           
              