2022-0425-02)외부조인(OUTER JOIN)
 - 자료의 종류가 많은 테이블을 기준으로 수행하는 조인
 - 자료가 부족한 테이블에 NULL 행을 추가하여 조인 수행
 - 외부조인 연산자'(+)'는 자료가 적은쪽에 추가
 - 조인조건 중 외부조인이 필요한 모든 조건에 '(+)'를 기술해야함
 - 동시에 한 테이블이 다른 두 기준 테이블과 외부조인될 수 없다. 즉, A,B,C
   테이블이 외부조인에 참여하고 A를 기준으로 B가 확장되어 조인되고, 동시에 
   C를 기준으로 B가 확장되는 외부조인은 허용안됨(A=B(+) AND C=B(+))
 - 일반조건과 외부조인조건이 동시에 존재하는 외부조인은 내부조인결과가
   반환됨=>ANSI외부조인이나 서브쿼리로 해결
   
   (일반외부조인 사용형식)
   SELECT 컬럼list
     FROM 테이블명1 [별칭1], 테이블명2 [별칭2][,...]
    WHERE 조인조건(+);
             :
    
  (ANSI외부조인 사용형식)
   SELECT 컬럼list
     FROM 테이블명1 [별칭1]    
    LEFT|RIGHT|FULL OUTER JOIN 테이블명2[별칭2] ON(조인조건 [AND 일반조건])
           :
    [WHERE 일반조건];
    . LEFT : FROM절에 기술된 테이블의 자료의 종류가 JOIN절의 테이블의 자료보다 많은 경우
    . RIGHT : FROM절에 기술된 테이블의 자료의 종류가 JOIN절의 테이블의 자료보다 적은 경우
    . FULL : FROM절에 기술된 테이블과 JOIN절의 테이블의 자료가 서로 부족한 경우.
    
 사용예) 상품테이블에서 모든 분류별 상품의 수를 조회하시오
  SELECT LPROD_GU AS 분류코드,
         COUNT(PROD_ID) AS "상품의 수" --
    FROM LPROD A, PROD B
   WHERE A.LPROD_GU = B.PROD_LGU(+)
   GROUP BY LPROD_GU
   ORDER BY 1;
    
   SELECT DISTINCT PROD_LGU
   FROM PROD;
   
  사용예)사원테이블에서 모든 부서별 사원수와 평균급여를 조회하시오.
         단, 평균급여는 정수만 출력할것.
  (일반 OUTER)       
  SELECT B.DEPARTMENT_ID AS 부서코드,
         B.DEPARTMENT_NAME AS 부서명,
         COUNT(A.EMPLOYEE_ID) AS 사원수, --대도록 기본키사용
         ROUND(AVG(A.SALARY)) AS 평균급여
    FROM HR.EMPLOYEES A, HR.DEPARTMENTS B
   WHERE A.DEPARTMENT_ID = B.DEPARTMENT_ID(+)
  -- AND WHERE A.DEPARTMENT_ID(+) = B.DEPARTMENT_ID
  GROUP BY B.DEPARTMENT_ID, B.DEPARTMENT_NAME
  ORDER BY 1;
  
  (ANSI JOIN)
  SELECT B.DEPARTMENT_ID AS 부서코드,
         B.DEPARTMENT_NAME AS 부서명,
         COUNT(A.EMPLOYEE_ID) AS 사원수, --대도록 기본키사용
         ROUND(AVG(A.SALARY)) AS 평균급여
    FROM HR.EMPLOYEES A
    FULL OUTER JOIN HR.DEPARTMENTS B ON(A.DEPARTMENT_ID = B.DEPARTMENT_ID)
    GROUP BY B.DEPARTMENT_ID, B.DEPARTMENT_NAME
    ORDER BY 1;
    
   사용예)장바구니테이블에서 2020년 6월 모든 회원별 구매합계를 구하시오.
   (일반 OUTER)
   SELECT C.MEM_ID AS 회원번호,
          C.MEM_NAME AS 회원명,
          SUM(A.CART_QTY * B.PROD_PRICE) AS 구매합계
     FROM CART A, PROD B, MEMBER C
    WHERE A.CART_PROD = B.PROD_ID
      AND C.MEM_ID = A.CART_MEMBER(+) --부족한쪽에 (+)
      AND A.CART_NO LIKE '202006%'
    GROUP BY C.MEM_ID, C.MEM_NAME;
   
    (ANSI JOIN)
   SELECT C.MEM_ID AS 회원번호,
          C.MEM_NAME AS 회원명,
          NVL(SUM(A.CART_QTY * B.PROD_PRICE),0) AS 구매합계
     FROM CART A 
    RIGHT OUTER JOIN MEMBER C ON (A.CART_MEMBER = C.MEM_ID)
    LEFT OUTER JOIN PROD B ON (B.PROD_ID = A.CART_PROD)
    WHERE A.CART_NO LIKE '202006%'
    GROUP BY C.MEM_ID, C.MEM_NAME
    ORDER BY 1;
    
 (서브쿼리)
   서브쿼리 : 2020년 6월 회원별 판매집계 --내부조인
    SELECT A.CART_MEMBER AS AID,
           SUM(A.CART_QTY * B.PROD_PRICE) AS ASUM
      FROM CART A, PROD B
     WHERE A.CART_PROD = B.PROD_ID
       AND A.CART_NO LIKE '202006%'
      GROUP BY A.CART_MEMBER;
     
   메인쿼리 : 서브쿼리결과와 MEMBER 사이에 외부조인
    SELECT TB.MEM_ID AS 회원번호,
           TB.MEM_NAME AS 회원명,
           NVL(TA.ASUM,0) AS 구매합계
      FROM (SELECT A.CART_MEMBER AS AID,
                    SUM(A.CART_QTY * B.PROD_PRICE) AS ASUM
              FROM CART A, PROD B
             WHERE A.CART_PROD = B.PROD_ID
               AND A.CART_NO LIKE '202006%'
             GROUP BY A.CART_MEMBER) TA,
            MEMBER TB
     WHERE TA.AID(+)= TB.MEM_ID
    ORDER BY 1; 
    
    (ANSI 외부JOIN)
    SELECT TB.MEM_ID AS 회원번호,
           TB.MEM_NAME AS 회원명,
           NVL(TA.ASUM,0) AS 구매합계
      FROM (SELECT A.CART_MEMBER AS AID,
                    SUM(A.CART_QTY * B.PROD_PRICE) AS ASUM
              FROM CART A, PROD B
             WHERE A.CART_PROD = B.PROD_ID
               AND A.CART_NO LIKE '202006%'
             GROUP BY A.CART_MEMBER) TA
       RIGHT OUTER JOIN MEMBER TB ON(TA.AID=TB.MEM_ID)      
    ORDER BY 1; 
   