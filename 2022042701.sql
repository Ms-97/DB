2022-0427-01)서브쿼리
    - SQL문 안에 존재하는 또 다른 SQL문
    - SQL문장 안에 보조로 사용되는 중간 결과를 반환하는 SQL문
    - 알려지지 않은 조건에 근거한 값들을 검색하는 SELECT문에 사용
    - 서브쿼리는 검색문(SELECT)뿐아니라 DML(INSERT,UPDATE,DELETE)문에서도 사용됨
    - 서브쿼리는 '( )'안에 기술되어야 함(단, INSERT문에 사용하는 SUBQUERY는 제외)
    - 서브쿼리는 반드시 연산자 오른쪽에 기술해야함
    - 단일 결과 반환 서브쿼리(단일행 연산자:>,<,>=,<=,=,!=)
      VS 복수 결과 반환 서브쿼리(복수행 연산자:IN ALL, ANY, SOME, EXISTS)
    - 연관성 있는 서브쿼리 VS 연관성 없는 서브쿼리
    - 일반서브쿼리 VS in-line 서브쿼리 VS 중첩서브쿼리
 
 1. 연관성 없는 서브쿼리
   - 메인쿼리의 테이블과 서브쿼리의 테이블이 조인으로 연결되지 않은 경우

사용예)사원테이블에서 사원들이 평균급여보다 많은 급여를 받는 사원을 조회 하시오.
     Alias는 사원번호, 사원명, 부서명, 급여
 (메인쿼리 :사원들이 사원번호, 사원명, 부서명, 급여를 조회 )    
    SELECT A.EMPLOYEE_ID AS 사원번호, 
           A.EMP_NAME AS 사원명,
           B.DEPARTMENT_ID AS 부서명,
           A.SALARY AS 급여
      FROM HR.EMPLOYEES A, HR.DEPARTMENTS B
     WHERE A.DEPARTMENT_ID = B.DEPARTMENT_ID
       AND A.SALARY >(평균급여);
       
 (서브쿼리 :평균급여 )    
    SELECT AVG(SALARY)
      FROM HR.EMPLOYEES
      
 (결합) 
  SELECT A.EMPLOYEE_ID AS 사원번호, 
           A.EMP_NAME AS 사원명,
           B.DEPARTMENT_ID AS 부서명,
           A.SALARY AS 급여
      FROM HR.EMPLOYEES A, HR.DEPARTMENTS B
     WHERE A.DEPARTMENT_ID = B.DEPARTMENT_ID
       AND A.SALARY>(SELECT AVG(SALARY)
                       FROM HR.EMPLOYEES);

 (평균급여 출력)
   SELECT A.EMPLOYEE_ID AS 사원번호, 
           A.EMP_NAME AS 사원명,
           B.DEPARTMENT_ID AS 부서명,
           A.SALARY AS 급여,
           (SELECT ROUND(AVG(SALARY))
              FROM HR.EMPLOYEES) AS 평균급여
      FROM HR.EMPLOYEES A, HR.DEPARTMENTS B
     WHERE A.DEPARTMENT_ID = B.DEPARTMENT_ID
       AND A.SALARY>(SELECT AVG(SALARY)
                       FROM HR.EMPLOYEES); 
 
 (in-line view 서브쿼리)
    SELECT A.EMPLOYEE_ID AS 사원번호, 
           A.EMP_NAME AS 사원명,
           B.DEPARTMENT_ID AS 부서명,
           A.SALARY AS 급여,
           ROUND(C.ASAL) AS 평균급여
      FROM HR.EMPLOYEES A, HR.DEPARTMENTS B,
           (SELECT AVG(SALARY) AS ASAL
                       FROM HR.EMPLOYEES) C
     WHERE A.DEPARTMENT_ID = B.DEPARTMENT_ID
       AND A.SALARY>C.ASAL; 

2. 연관성 있는 서브쿼리
   - 메인쿼리와 서브쿼리가 조인으로 연결된 경우
   - 대부분의 서브퀴리
   
 사용예)직무변동테이블(JOB_HISTORY)과 부서테이블의 부서번호가 같은 자료를
        조회하시오.
        Alias는 부서번호,부서명 이다
  (IN 연산자 이용)      
        SELECT A.DEPARTMENT_ID AS 부서번호,
               A.DEPARTMENT_NAME AS 부서명
          FROM HR.departments A
         WHERE A.DEPARTMENT_ID IN(SELECT DEPARTMENT_ID
                                  FROM HR.JOB_HISTORY);
                                 
  (EXISTS 연산자 이용)      
        SELECT A.DEPARTMENT_ID AS 부서번호,
               A.DEPARTMENT_NAME AS 부서명
          FROM HR.departments A
         WHERE EXISTS (SELECT 1 
                         FROM HR.JOB_HISTORY B
                        WHERE B.DEPARTMENT_ID=A.DEPARTMENT_ID);
  
 사용예)2020년 5월 판매된 상품별 판매집계 중 금액기준 상위 3개 상품 판매집계정보를 
       조회하시오.
       Alias는 상품코드, 상품명, 거래처명, 판매금액합계
       
 (메인쿼리: 금액기준 상위 3개 상품에 대한 상품코드, 상품명, 거래처명, 판매금액합계)  
     SELECT 상품코드,상품명,거래처명,판매금액합계
       FROM PROD A, BUYER B
      WHERE A.PROD_ID = (상위 3개의 제품코드) 
        AND A.PROD_BUYER = B.BUYER_ID
        
 (서브쿼리: 판매금액기준으로 판매정보 추출)
     SELECT A.CART_PROD AS CID,
            B.PROD_NAME AS CNAME,
            SUM(A.CART_QTY*PROD_PRICE) AS CSUM
       FROM CART A, PROD B
      WHERE A.CART_PROD = B.PROD_ID
        AND A.CART_NO LIKE '202005%'
       GROUP BY A.CART_PROD, B.PROD_NAME
       ORDER BY 3 DESC;
       
  (결합)    
      SELECT C.CID AS 상품코드,
             C.CNAME AS 상품명,
             B.BUYER_NAME AS 거래처명,
             C.CSUM AS 판매금액합계
       FROM PROD A, BUYER B,
            (SELECT A.CART_PROD AS CID,
                    B.PROD_NAME AS CNAME,
                    SUM(A.CART_QTY*PROD_PRICE) AS CSUM
               FROM CART A, PROD B
              WHERE A.CART_PROD = B.PROD_ID
                AND A.CART_NO LIKE '202005%'
            GROUP BY A.CART_PROD, B.PROD_NAME
            ORDER BY 3 DESC) C 
      WHERE A.PROD_ID = C.CID
        AND A.PROD_BUYER = B.BUYER_ID   
        AND ROWNUM <=3;
       
 사용예)2020년 상반기에 구매액기준 1000만원 이상을 구매한 회원정보를 
       조회하시오.
       Alias는 회원번호,회원명,직업, 구매액, 마일리지
       (메인쿼리 : 회원정보(회원번호,회원명,직업, 구매액, 마일리지) 조회)
                  조건: 2020년 상반기에 구매액기준 1000만원 이상(서브쿼리)
       SELECT A.MEM_ID AS 회원번호,
              A.MEM_NAME AS 회원명,
              A.MEM_JOB AS 직업,
              구매액,
              A.MEM_MILEAGE AS 마일리지
         FROM MEMBER A,
              (1000만원 이상을 구매한 회원) B
        WHERE A.MEM_ID = B.회원번호;
     
    (서브쿼리: 2020년 상반기 구매액기준 1000만원 이상) 
     SELECT A.CART_MEMBER AS BID,
                     SUM(A.CART_QTY*B.PROD_PRICE) AS BSUM 
                FROM CART A, PROD B
               WHERE A.CART_PROD = B.PROD_ID
                 AND SUBSTR(A.CART_NO,1,6) BETWEEN '202001' AND '202006'
               GROUP BY A.CART_MEMBER
              HAVING SUM(A.CART_QTY*B.PROD_PRICE) >= 10000000
     
     (결합-INLINE VIEW 사용)
      SELECT A.MEM_ID AS 회원번호,
             A.MEM_NAME AS 회원명,
             A.MEM_JOB AS 직업,
             B.BSUM AS 구매액,
             A.MEM_MILEAGE AS 마일리지
        FROM  MEMBER A,
             (SELECT A.CART_MEMBER AS BID,
                     SUM(A.CART_QTY*B.PROD_PRICE) AS BSUM 
                FROM CART A, PROD B
               WHERE A.CART_PROD = B.PROD_ID
                 AND SUBSTR(A.CART_NO,1,6) BETWEEN '202001' AND '202006'
               GROUP BY A.CART_MEMBER
               HAVING SUM(A.CART_QTY*B.PROD_PRICE) >= 10000000) B
       WHERE A.MEM_ID = B.BID
       ORDER BY 4 DESC;

     (결합-중첩서브쿼리) 
     SELECT A.MEM_ID AS 회원번호,
             A.MEM_NAME AS 회원명,
             A.MEM_JOB AS 직업,
        --     B.BSUM AS 구매액,
             A.MEM_MILEAGE AS 마일리지
        FROM  MEMBER A
       WHERE A.MEM_ID IN (SELECT B.BID
                          FROM(SELECT A.CART_MEMBER AS BID,
                                      SUM(A.CART_QTY*B.PROD_PRICE)
                                 FROM CART A, PROD B
                                WHERE A.CART_PROD = B.PROD_ID
                                  AND SUBSTR(A.CART_NO,1,6) BETWEEN '202001' AND '202006'
                               GROUP BY A.CART_MEMBER
                               HAVING SUM(A.CART_QTY*B.PROD_PRICE) >= 10000000) B)
                             
       
       
      