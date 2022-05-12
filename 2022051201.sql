2022-0512-01)트리거(TRIGGER)
 - 특정 이벤트가 발생되기 전 혹은 발생된 후 자동적으로 호출되어 실행되는 
   일종의 프로시져
 - 사용형식
 CREATE OR REPLACE TRIGGER 트리거명 --TG_
    BEFORE|AFTER INSERT|UPDATE|DELETE ON 테이블명 
    [FOR EACH ROW]
    [WHEN 조건]
  [DECLARE]
   변수,상수,커서 선언
  BEGIN
   트리거 본문(TRIGGER BODY) --테이블명을 사용X(사이클발생)
  END;
   . 'BEFORE|AFTER' : 트리거의 본문이 실행되는 시점(이벤트 발생을 기준으로)
   . 'INSERT|UPDATE|DELETE':트리거의 발생 원인, 조합사용할 수 있음
   . 'FOR EACH ROW' : 행단위 트리거인 경우 기술 생략되면 문장단위 트리거
   . 'WHEN 조건' : 트리거가 실행되면서 지켜야할 조건(조건에 맞는 테이터만 트리거 실행)
   
 사용예)다음 조건에 맞는 사원테이블(EMPT)을 HR계정의 사원테이블로부터 구조와
       데이터를 가져와 생성하시오
       컬럼:사원번호(EID),사원명(ENAME),급여(SAL),부서코드(DEPTID),영업실적(COM_PCT)
       조건:급여가 6000이하인 사원
   /
   CREATE TABLE EMPT(EID,ENAME,SAL,DEPTID,COM_PCT) AS
     SELECT EMPLOYEE_ID,EMP_NAME,SALARY,DEPARTMENT_ID,COMMISSION_PCT
       FROM HR.EMPLOYEES
      WHERE SALARY<=6000;
    /  
 트리거 사용에) 다음 데이터를 EMPT테이블에 저장하고 저장이 끝난 후
        '새로운 사원정보가 추가 되었습니다'라는 메시지를 출력하는 트리거를 작성하시오.
       [자료]
       사원명    급여    부서코드   영업실적코드
  ------------------------------------------------
       홍길동    5500      80        0.25
/
SET SERVEROUTPUT ON;
/    
   CREATE OR REPLACE TRIGGER TG_EMP_INSERT
     AFTER INSERT ON EMPT
   BEGIN 
    DBMS_OUTPUT.PUT_LINE('새로운 사원정보가 추가 되었습니다');
   END;
 /  
 --EMPT에 자료삽입
 INSERT INTO EMPT
    SELECT MAX(EID)+1,'홍길동',5500,80,0.25  FROM EMPT;
 INSERT INTO EMPT
    SELECT MAX(EID)+1,'강감찬',5800,50,NULL  FROM EMPT;   
 /

사용예)사원테이블에서 115,126,132번 사원을 퇴직 처리하시오
      퇴직하는 사원정보는 (EMPT)사원테이블에서 삭제하시오.
      삭제전에 퇴직하는 사원정보를 퇴직자테이블(EM_RETIRE)에 저장하시오
  /
   CREATE OR REPLACE TRIGGER tg_remove_emp
    BEFORE DELETE ON EMPT
    FOR EACH ROW 
   DECLARE 
    V_EID EMPT.EID%TYPE;
    V_DID EMPT.DEPTID%TYPE;
   BEGIN
     V_EID:=(:OLD.EID);
     V_DID:=(:OLD.DEPTID);
     
     INSERT INTO EM_RETIRE
        VALUES(V_EID,V_DID,SYSDATE);
   END;
   /
퇴직자 자료 삭제
/
    DELETE FROM EMPT 
     WHERE EID IN(115,126,132);
 /  
 
 