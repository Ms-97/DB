2022-0419-01)집계함수
 - 자료를 그룹화하고 그룹내에서 합계, 자료수, 평균, 최대, 최소 값을 구하는 함수
 - SUM, AVG, COUNT, MAX, MIN이 제공됨
 - SELECT 절에 그룹함수가 일반 컬럼과 같이 사용된경우 반드시 GROUP BY 절이
   기술되어야 함.
 (사용형식)
  SELECT [컬럼명1,
        [컬럼명2,...]]
         집계함수
    FROM 테이블명
  [WHERE 조건]
  [GROUP BY 컬럼명1[, 컬럼명2,...]]
  [HAVING 조건]
  [ORDER BY 인덱스|컬럼명 [ASC|DESC][,...]]
   . GROUP BY절에 사용된 컬럼명은 왼쪽에 기술된 순서대로 대분류, 소분류의 기준 컬럼명
   . HAVING 조건 : 집계함수에 조건이 부여된 경우
   
1. SUM(co1)
 - 각 그룹내의 'co1'컬럼에 저장된 값을 모두 합하여 반환
2. AVG(co1)
 - 각 그룹내의 'co1'컬럼에 저장된 값의 평균을 구하여 반환
3. COUNT(*|co1)
 - 각 그룹내의 행의 수를 반환
 - '*'를 사용하면 NULL값도 하나의 행으로 취급
 - 컬럼명을 기술하면 해당 컬럼의 값이 NULL이아닌 갯수를 반환
4. MAX(col), MIN(col)
 - 각 그룹내의 'co1'컬럼에 저장된 값 중 최대값과 최소값을 구하여 반환
*** 집계함수는 다른 집계함수를 포함할 수 없다 ***
 
사용예) 사원테이블에서 전체사원의 급여합계를 구하시오.
사용예) 사원테이블에서 전체사원의 평균급여를 구하시오.
    SELECT SUM(SALARY) AS 급여합계,
           ROUND(AVG(SALARY)) AS 평균급여,
           MAX(SALARY) AS 최대급여,
           MIN(SALARY) AS 최소급여,
           COUNT(*) AS 사원수
      FROM HR.employees
      
    SELECT AVG(TO_NUMBER(SUBSTR(PROD_ID,2,3)))
      FROM PROD;

사용예) 사원테이블에서 부서별 급여합계를 구하시오.
사용예) 사원테이블에서 부서별 평균급여를 구하시오.
사용예) 사원테이블에서 부서별 최대급여액을 조회하시오.
사용예) 사원테이블에서 부서별 최소급여액을 조회하시오.
 SELECT DEPARTMENT_ID AS 부서코드,
        SUM(SALARY) AS 급여합계,
        ROUND(AVG(SALARY)) AS 평균급여,
        MAX(SALARY) AS 최대급여,
        MIN(SALARY) AS 최소급여,
        COUNT(EMPLOYEE_ID) AS 사원수
   FROM HR.employees 
 GROUP BY DEPARTMENT_ID
 ORDER BY 1;

사용예) 사원테이블에서 부서별 평균급여가 6000이상인 부서를 조회하시오.
    
    SELECT DEPARTMENT_ID AS 부서코드,
           ROUND(AVG(SALARY)) AS 평균급여
      FROM HR.employees
     GROUP BY DEPARTMENT_ID
     HAVING AVG(SALARY)>=6000  -- WHERE절 쓰면 오류
     ORDER BY 2 DESC;

사용예) 장바구니테이블에서 2020년 5월 회원별 구매수량합계를 조회하시오
    SELECT CART_MEMBER AS 회원번호,
           SUM(CART_QTY) AS 구매수량합계
      FROM CART
     WHERE CART_NO LIKE '202005%'
  GROUP BY CART_MEMBER
  ORDER BY 2 DESC;
  
사용예) 매입테이블(buyprod)에서 2020년 상반기(1월~6얼) 월별, 제품별 매입집계를
        조회하시오.
    SELECT  EXTRACT(MONTH FROM BUY_DATE) AS 월,
            BUY_PROD AS 제품코드,
            SUM(BUY_QTY) AS 수량합계,
            SUM(BUY_QTY*BUY_COST) AS 매입금액합계
     FROM BUYPROD
    WHERE  BUY_DATE BETWEEN TO_DATE('20200101') AND TO_DATE('20200630')
    GROUP BY  EXTRACT(MONTH FROM BUY_DATE), BUY_PROD
    ORDER BY 1,2; 
    
사용예) 매입테이블(buyprod)에서 2020년 상반기(1월~6얼) 월별, 매입집계를 조회하되 
        매입금액이 10000만원 이상인 월만 조회하시오.
      
    SELECT  EXTRACT(MONTH FROM BUY_DATE) AS 월,
            BUY_PROD AS 제품코드,
            SUM(BUY_QTY) AS 수량합계,
            SUM(BUY_QTY*BUY_COST) AS 매입금액합계
     FROM BUYPROD
    WHERE  BUY_DATE BETWEEN TO_DATE('20200101') AND TO_DATE('20200630')
    GROUP BY  EXTRACT(MONTH FROM BUY_DATE), BUY_PROD
    ORDER BY 1,2;    

사용예) 매입테이블(buyprod)에서 2020년 상반기(1월~6얼) 월별, 매입집계를 조회하되 
        금액 기준 상위 5개 제품만 조회하시오.
   SELECT  A.BID AS 제품코드,
           A.QSUM AS 수량합계,
           A.CSUM AS 금액합계
     FROM (SELECT BUY_PROD AS BID,
                  SUM(BUY_QTY) AS QSUM,
                  SUM(BUY_QTY * BUY_COST) AS CSUM
             FROM BUYPROD
            WHERE  BUY_DATE BETWEEN TO_DATE('20200101') AND TO_DATE('20200630')
            GROUP BY BUY_PROD
            ORDER BY 3 DESC) A
    WHERE ROWNUM<=5; 
        
사용예) 회원테이블에서 성별 평균 마일리지를 조회하시오.
        SELECT CASE WHEN SUBSTR(MEM_REGNO2,1,1)='1' OR SUBSTR(MEM_REGNO2,1,1)='3' THEN '남성'
                ELSE '여성'END AS 성별, 
                ROUND(AVG(MEM_MILEAGE)) AS 평균마일리지    
          FROM MEMBER
       GROUP BY CASE WHEN SUBSTR(MEM_REGNO2,1,1)='1' OR SUBSTR(MEM_REGNO2,1,1)='3' THEN '남성'
               ELSE '여성' END;

사용예) 회원테이블에서 연령대별 평균 마일리지를 조회하시오. 
         SELECT TRUNC(EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM MEM_BIR),-1) AS 연령대, 
                ROUND(AVG(MEM_MILEAGE)) AS 평균마일리지    
          FROM MEMBER
       GROUP BY TRUNC(EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM MEM_BIR),-1)
       ORDER BY 1;

사용예) 회원테이블에서 거주지별 평균 마일리지를 조회하시오. 

         SELECT SUBSTR(MEM_ADD1,1,2) AS 거주지, 
                ROUND(AVG(MEM_MILEAGE)) AS 평균마일리지    
          FROM MEMBER
       GROUP BY SUBSTR(MEM_ADD1,1,2)
       ORDER BY 1;

