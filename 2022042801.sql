2022-0428-01) SUBQURY와 DML명령
1. INSERT 문에서 서브쿼리 사용
 - INSERT INTO 문에 서브쿼리를 사용하면 VALUES절이 생략됨
 - 사용되는 서브쿼리는 '()'를 생략하고 기술함
 (사용형식)
   INSERT INTO 테이블명[(컬럼명[,컬럼명,...])]
   서브쿼리;
  .'테이블명()'에 기술된 컬럼의 갯수,순서,타입과 서브쿼리 SELECT 문의
    SELECT절의 커럼의 갯수,순서,타입은 반드시 일치해야함
    
 사용예)재교수불테이블의 년도에는 '2020'을 상품코드에는 상품테이블의 
       모든 상품코드를 입력하시오.
    INSERT INTO REMAIN(REMAIN_YEAR,PROD_ID)
       SELECT '2020', PROD_ID
         FROM PROD;
         
     SELECT * FROM REMAIN;   
     
     DELETE FROM REMAIN;
    
2. UPDATE 문에서 서브쿼리 사용
 (사용형식)
  UPDATE 테이블명 [별칭]
     SET (컬럼명[,컬럼명,...])=(서브쿼리)
  [WHERE 조건];
  
 사용예)재고수불테이블(REMAIN)에 기초재고를 설정하시오.
       기초재고는 상품테이블의 적정재과량으로 하며 날짜는 2020년 1월 1일로 설정
       
     UPDATE REMAIN A
        SET (A.REMAIN_J_00,A.REMAIN_J_99,A.REMAIN_DATE)=
            (SELECT A.REMAIN_J_00 + B.PROD_PROPERSTOCK,
                    A.REMAIN_J_99 + B.PROD_PROPERSTOCK,
                    TO_DATE('20200101')
               FROM PROD B
              WHERE A.PROD_ID = B.PROD_ID)
      WHERE A.REMAIN_YEAR='2020';         