20220506
PL/SQL(절차적인 언어로써의 구조화된 질의 언어)
Pakage(패키지)
User Function(사용자정의 함수)
Stored Procedure(저장 프로시저)
Trigger(트리거)
Anonymous Block(익명의 블록)

-- DBMS OUTPUT 결과값을 콘솔에 표시
SET SERVEROUTPUT ON;

DECLARE
    -- SCALAR(일반)변수
    V_BUY_PROD VARCHAR2(10);
    V_QTY NUMBER(10);
    -- 2020년도 상품별 매입수량의 합
    CURSOR CUR IS
    SELECT BUY_PROD, SUM(BUY_QTY)
    FROM BUYPROD
    WHERE BUY_DATE LIKE '2020%'
    GROUP BY BUY_PROD
    ORDER BY BUY_PROD ASC;
BEGIN
    -- 메모리 할당(올라감) = 바인드
    OPEN CUR;
    -- 페따출 (FETCH -> 따지고 -> 출력)
    -- 다음 행으로 이동, 행이 존재하는지 체킹
    -- 페(FETCH)
    FETCH CUR INTO V_BUY_PROD, V_QTY;
    -- 따(따지고 FOUND: 데이터존재? /NOTFOUND: 데이터가 없는지?/ ROWCOUNT: 행의수)
    WHILE(CUR%FOUND) LOOP
    -- 출(출력)
        DBMS_OUTPUT.PUT_LINE(V_BUY_PROD || ', ' || V_QTY);
        FETCH CUR INTO V_BUY_PROD, V_QTY;
   END LOOP; 
    -- 사용중인 메모리를 반환(필수)
    CLOSE CUR;
END;

--회원테이블에서 회원명과 마일리지를 출력해보자
--단, 직업이 '주부'인 회원만 출력하고 회원명으로 오름차순 정렬해보자
-- ALIAS : MEM_NAME, MEM_MILEAGE
-- CUR 이름의 CURSOR를 정의하고 익명블록으로 표현
    
DECLARE
    V_NAME MEMBER.MEM_NAME%TYPE; -- VARCHAR2(20); REFERENCE변수
    V_MILEAGE NUMBER(10);  -- SCALAR변수
    CURSOR CUR(V_JOB VARCHAR2)IS  
        SELECT MEM_NAME,MEM_MILEAGE
          FROM MEMBER
         WHERE MEM_JOB = V_JOB
         ORDER BY MEM_NAME;
 BEGIN
    OPEN CUR('주부');
    LOOP
        FETCH CUR INTO V_NAME, V_MILEAGE;
        EXIT WHEN CUR%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(CUR%ROWCOUNT || ',' || V_NAME || ', '|| V_MILEAGE);
    END LOOP;    
    CLOSE CUR;
 END;
 
 -- 직업을 입력받아서 FOR LOOP를 이용하는 CURSOR
 
 BEGIN
    --FOR문으로 반복하는 동안 커서를 자동으로 OPEN하고
    --모든 행이 처리되면 자동으로 커서를 CLOSE함
    --RCE : 자동선언되는 묵시적 변수
    FOR REC IN (SELECT MEM_NAME, MEM_MILEAGE
                  FROM MEMBER
                 WHERE MEM_JOB = '학생'
                ORDER BY MEM_NAME) LOOP
        DBMS_OUTPUT.PUT_LINE(REC.MEM_NAME || ',' || REC.MEM_NAME || ', '|| REC.MEM_MILEAGE);
    END LOOP;    
 END;
 
 --CURSOR문제
 --2020년도 회원별 판매금액(판매가(PROD_SALE) * 구매수량(CART_QTY))의 합계를
 --CURSOR와 FOR문을 통해 출력해보자
 --ALISAS : MEM_ID, MEM_NAME, SUM_AMT
 --출력예시 : a001, 김은대, 2000
 --          b001, 이쁜이, 1750
 --          ...

 오라클           ANSI 표준
 -----------------------------------  
  카티전프로덕트     CROSS JOIN 
  (조인조건 X)
 -------------------------------------
    내부조인        Inner Join
 -------------------------------------
    외부조인        Outer Join    
                  Natural Join

 SELECT M.MEM_ID, M.MEM_NAME, SUM(P.PROD_SALE * C.CART_QTY)
   FROM PROD P, CART C, MEMBER M 
  WHERE P.PROD_ID = C.CART_PROD 
    AND C.CART_MEMBER = M.MEM_ID
    AND C.CART_NO LIKE '2020%'
  GROUP BY M.MEM_ID, M.MEM_NAME
  ORDER BY M.MEM_ID;
  
 ANSI 조인
  DECLARE
    CURSOR CUR IS
        SELECT M.MEM_ID, M.MEM_NAME
             , SUM(P.PROD_SALE * C.CART_QTY) OUT_AMT
        FROM   PROD P INNER JOIN CART C   ON(P.PROD_ID = C.CART_PROD)
                      INNER JOIN MEMBER M ON(C.CART_MEMBER = M.MEM_ID)
        WHERE  C.CART_NO LIKE '2020%'
        GROUP BY M.MEM_ID, M.MEM_NAME
        ORDER BY M.MEM_ID;
BEGIN
    FOR REC IN CUR LOOP
    IF MOD(CUR%ROWCOUNT,2) = 1 THEN
         DBMS_OUTPUT.PUT_LINE(CUR%ROWCOUNT || ', ' ||
                                REC.MEM_ID || ', ' ||
                              REC.MEM_NAME || ', ' ||
                              REC.OUT_AMT);
        END IF;
    END LOOP;
END;
   
--STORED(오라클 서버의 캐시공간에 미리 저장된) PROCEDURE
--업데이트 쎄(SET)대여(WHERE)
SELECT PROD_ID, PROD_TOTALSTOCK 
  FROM PROD
 WHERE PROD_ID = 'P101000001';
/
CREATE OR REPLACE PROCEDURE USP_PROD_TOTALSTOCK_UPDATE
IS
BEGIN
UPDATE PROD 
   SET PROD_TOTALSTOCK = PROD_TOTALSTOCK +10    
 WHERE PROD_ID = 'P101000001';
 DBMS_OUTPUT.PUT_LINE('업데이트 성공!');
 COMMIT;
END; 
/
--EXECUTE USP_PROD_TOTALSTOCK_UPDATE;
EXEC USP_PROD_TOTALSTOCK_UPDATE
/