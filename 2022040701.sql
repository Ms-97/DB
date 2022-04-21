2022-0407-01)
1.DML 명령
    1). 테이블 생성명령(CREATE TABLE)
    - 오라클에서 사용될 테이블을 생성
    (사용형식)
    CREATE TABLE 테이블명(
    컬럼명 데이터 타입[(크기)] [NOT NULL] [DEFAULT 값] [,] 
                :
    컬럼명 데이터 타입[(크기)] [NOT NULL] [DEFAULT 값] [,] 
    [CONSTRAINT 기본키 인덱스명 PRIMARY KEY(컬럼명[,컬럼명,....])[,])
    [CONSTRAINT 외래키 인덱스명 PRIMARY KEY(컬럼명[,컬럼명,....])
     REFERENCES 테이블명(컬럼명[,컬럼명,....])[,]]
     [CONSTRAINT 외래키 인덱스명 PRIMARY KEY(컬럼명[,컬럼명,....])
     REFERENCES 테이블명(컬럼명[,컬럼명,....])]);
     . '테이블명',컬럼명, 인덱스명 : 사용자정의단어를 사용
     .'NOT NULL'이 기술된 컬럼은 데이터 삽입시 생략 불가능
     .'DEFAULT 값':사용자가 데이터를 입력하지 않은 경우 자동으로 삽입되는 값
     .'기본키인덱스명','외래키인덱스명','테이블명'은 중복되어서는 안됨
     .'테이블명(컬럼명[,컬럼명,....])])': 부모테이블명 및 부모테이블에서 사용된 컬럼명
    
    사용예) 테이블명세1의 테이블들을 생성하시오.
    
    CREATE TABLE GOODS(
        GOOD_ID CHAR(4) NOT NULL, --기본키
        GOOD_NAME VARCHAR2(50),
        PRICE NUMBER(8),
        CONSTRAINT pk_goods PRIMARY KEY(GOOD_ID));
        
    CREATE TABLE CUSTS(
        CUST_ID CHAR(4) NOT NULL, --기본키
        CUST_NAME VARCHAR2(50),
        ADDRESS VARCHAR2(100),
        CONSTRAINT pk_cust PRIMARY KEY(CUST_ID)); 
        
    CREATE TABLE ORDERS(
        ORDER_ID CHAR(11) NOT NULL, --기본키
        CUSTS_DATE DATE DEFAULT SYSDATE,
        CUST_ID CHAR(4),
        ORDER_AMT NUMBER(10) DEFAULT 0,
        CONSTRAINT pk_order PRIMARY KEY(ORDER_ID),
        CONSTRAINT fk_order_cust FOREIGN KEY(CUST_ID)
            REFERENCES CUSTS(CUST_ID)); 
    
    CREATE TABLE GOOD_ORDERS(
        ORDER_ID CHAR(11),
        GOOD_ID CHAR(4),
        ORDER_QTY NUMBER(3),
        CONSTRAINT pk_gord PRIMARY KEY(ORDER_ID,GOOD_ID),
        CONSTRAINT fk_gord_order FOREIGN KEY(ORDER_ID)
             REFERENCES ORDERS(ORDER_ID),
        CONSTRAINT fk_gord_goods FOREIGN KEY(GOOD_ID)
             REFERENCES GOODS(GOOD_ID)); 
             
2. INSERT 명령
 - 생성된 테이블에 새로운 자료를 입력 
 (사용형식)
    INSERT INTO 테이블명[(컬럼명[,컬럼명,...])]
        VALUES(값1[,값2,...]);
    . '테이블명[(컬럼명[,컬럼명,...])]':'컬럼명'이 생략되고 테이블명만 기술되면
      테이블의 모든 컬럼에 입력될 데이터를 순서에 맞추어 기술해야함(갯수 및 순서 일치)
    . '(컬럼명[,컬럼명,...])':입력할 데이터에 해당하는 컬럼만 기술, 단, NOT NULL
      컬럼은 생략 할 수 없음
 
 사용예) 다음 자료를 GOODS테이블에 저장하시오.
        상품코드    상품명     가격
    -----------------------------------
        p101        볼펜        500
        p102       마우스     15000
        p103        연필        300
        p104       지우개      1000
        p201       A4용지      7000
        
    INSERT INTO GOODS VALUES('P101','볼펜',500);
    INSERT INTO GOODS (good_id,GOOD_NAME)
         VALUES('P102','마우스');
    INSERT INTO GOODS (good_id,GOOD_NAME,PRICE)
         --VALUES('P104','지우개',1000);
         VALUES('P201','A4용지',7000);
         
    SELECT * FROM GOODS;
    
사용예) 고객테이블(CUSTS)에 다음자료를 입력하시오
    고객번호     고객명         주소
    ------------------------------------
    a001        홍길동     대전시 중구 계룡로 846
    a002        이인수     서울시 성북구 장위1동 66

     INSERT INTO CUSTS VALUES('a001','홍길동','대전시 중구 계룡로 846');
     INSERT INTO CUSTS(CUST_ID, ADDRESS)
        VALUES('a002','서울시 성북구 장위1동 66');
      SELECT * FROM CUSTS;
      
사용예) 오늘 홍길동 고객이 로그인 했을 경우 주문테이블에 해당 사항을 입력하시오.
    INSERT INTO ORDERS(ORDER_ID, CUST_ID)
        VALUES('20220407001','a001');
        SELECT * FROM ORDERS;

사용예) 오늘 홍길동 고객이 다음과 같이 구매했을 때 구매상품테이블(GOOD_ORDERS)
        에 자료를 저장하시오
          구매번호      상품번호      수량  
        -------------------------------------------
        20220407001     p101         5        
        20220407001     p102         10  
        20220407001     p103         2 
        
    INSERT INTO GOOD_ORDERS
        VALUES('20220407001','P101',5);
        
    INSERT INTO GOOD_ORDERS
        VALUES('20220407001','P102',10); 
        
     INSERT INTO GOOD_ORDERS
        VALUES('20220407001','P103',2); 
        
    UPDATE GOODS
        SET PRICE=15000
        WHERE GOOD_ID='P102';
        
    UPDATE ORDERS
       SET ORDER_AMT = ORDER_AMT + (SELECT A.ORDER_QTY*B.PRICE
                                    FROM GOOD_ORDERS A, GOODS B
                                    WHERE A.GOOD_ID=B.GOOD_ID
                                    AND ORDER_ID='20220407001'
                                    AND B.GOOD_ID='P103')
    WHERE ORDER_ID='20220407001';
    
    SELECT * FROM ORDERS;
    SELECT * FROM GOOD_ORDERS;
    
 3. UPDATE 명령
 -  이미 테이블에 존재하는 자료를 수정할 때 사용
 (사용형식)
  UPDATE 테이블명
        SET 컬럼명=값[,]
                :
            컬럼명=값
    [WHERE 조건];
   
   SELECT PROD_NAME AS 상품명,
          PROD_COST AS 매입단가
    FROM PROD;

사용예) 상품테이블에서 분류코드가 'P101'에 속한 상품의 매입가격을 10%
       인상하시오.
       
    UPDATE PROD 
        SET PROD_COST=PROD_COST+ROUND(PROD_COST*0.1)
        WHERE PROD_LGU='P101';
   
    ROLLBACK;
        