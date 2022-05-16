2022-0516-02)PACKAGE
  - 논리적 연관성이 있는 PL/SQL타입,변수,함수,커서,예외 등의 항목을
    묶어놓은 객체 
  - 컴파일 과정을 거쳐 DB에 저장되며 다른 프로그램(프로시져, 함수 등)에서
    패키지 항목들을 참조, 고유, 실행할 수 있음
  - 패키지는 선언부와 실행부로 나뉨
 1)선언부
  . 패키지에서 사용할 사용자 정의 타입, 상수, 변수, 서브프로그램의 골격 등을
    선언해 놓은 부분
  . 자바의 인터페이스나 추상 클래스 개념과 유사
   (사용형식)
   CREATE OR REPLACE PACKAGE 패키지명 IS 
     상수, 변수, 커서, 예외 등 선언;
    
     FUNCTION 함수명(
       매개변수 IN|OUT|INOUT 타입명,....)
       RETURN 타입명;
           :
     PROCEDURE 프로시져명(
      매개변수 IN|OUT|INOUT 타입명,....);      
           :
   END 패키지명;        
   
  2)패키지의 본문
  . 선언된 서브프로그램의 구현부분
  . 자바의 인터페이스나 추상 클래스를 상속받아 객체로 생성하는 개념
   (사용형식)
   CREATE OR REPLACE PACKAGE BODY 패키지명 IS 
     상수, 변수, 커서, 예외 등 선언;
    
     FUNCTION 함수명(
       매개변수 IN|OUT|INOUT 타입명,....)
       RETURN 타입명
     IS
     
     BEGIN
     
     END 함수명;
           :
     PROCEDURE 프로시져명(
      매개변수 IN|OUT|INOUT 타입명,....)
     IS
     
     BEGIN
     
     END 프로시져명;
           :
   END 패키지명;  
   
 사용예)신규 사원 등록, 퇴직사원처리, 사원검색을 수행할 수 있는 
      패키지를 구성하시오  
  CREATE OR REPLACE PACKAGE PKG_EMP  IS
    FUNCTION fn_get_empname
      (P_EID IN HR.EMPLOYEES.EMPLOYEE_ID%TYPE)
      RETURN HR.EMPLOYEES.EMP_NAME%TYPE;
      
    PROCEDURE proc_insert_new_emp(
      P_HDATE IN VARCHAR2,
      P_JID IN HR.JOBS.JOB_ID%TYPE,
      P_ENAME IN HR.EMPLOYEES.EMP_NAME%TYPE,
      P_SAL HR.EMPLOYEES.SALARY%TYPE);
      
    PROCEDURE proc_retire(
      P_EID IN HR.EMPLOYEES.EMPLOYEE_ID%TYPE,
      P_HDATE IN VARCHAR2);
  END PKG_EMP;         
      
      
(패키지 본문부)
 CREATE OR REPLACE PACKAGE BODY PKG_EMP  IS
    FUNCTION fn_get_empname(
      P_EID IN HR.EMPLOYEES.EMPLOYEE_ID%TYPE)
      RETURN HR.EMPLOYEES.EMP_NAME%TYPE
    IS
      V_ENAME HR.EMPLOYEES.EMP_NAME%TYPE;
    BEGIN 
      SELECT EMP_NAME INTO V_ENAME
        FROM HR.EMPLOYEES
       WHERE EMPLOYEE_ID=P_EID;
       
      RETURN NVL(V_ENAME,'해당 사원정보 없음'); 
    END fn_get_empname;
      
    PROCEDURE proc_insert_new_emp(
      P_HDATE IN VARCHAR2,
      P_JID IN HR.JOBS.JOB_ID%TYPE,
      P_ENAME IN HR.EMPLOYEES.EMP_NAME%TYPE,
      P_SAL HR.EMPLOYEES.SALARY%TYPE)
    IS
      V_EID  HR.EMPLOYEES.EMPLOYEE_ID%TYPE;
    BEGIN
      SELECT MAX(EMPLOYEE_ID)+1 INTO V_EID
        FROM HR.EMPLOYEES;
        
      INSERT INTO HR.EMPLOYEES(EMPLOYEE_ID,HIRE_DATE,JOB_ID,EMP_NAME,
                               SALARY)
        VALUES(V_EID,TO_DATE(P_HDATE),P_JID,P_ENAME,P_SAL);
      
      COMMIT;  
    END proc_insert_new_emp;
      
    PROCEDURE proc_retire(
      P_EID IN HR.EMPLOYEES.EMPLOYEE_ID%TYPE,
      P_HDATE IN VARCHAR2)
    IS
      V_CNT NUMBER:=0;
      E_NO_DATE EXCEPTION;
    BEGIN
      UPDATE HR.EMPLOYEES
         SET RETIRE_DATE=TO_DATE(P_HDATE)
       WHERE EMPLOYEE_ID=P_EID
         AND RETIRE_DATE IS NULL;
         
      V_CNT:=SQL%ROWCOUNT;
      
      IF V_CNT=0 THEN
         RAISE E_NO_DATE;
      END IF;     
      COMMIT;
      EXCEPTION WHEN E_NO_DATE THEN
           DBMS_OUTPUT.PUT_LINE(P_EID||'번 사원정보 없음');
           ROLLBACK;
        WHEN OTHERS THEN  
           DBMS_OUTPUT.PUT_LINE(SQLERRM);
           ROLLBACK;     
    END proc_retire;
  END PKG_EMP;    
  
(실행-사원명 검색)  
  SELECT EMPLOYEE_ID,
         pkg_emp.fn_get_empname(EMPLOYEE_ID),
         SALARY
    FROM HR.EMPLOYEES;
   
 (실행-신규사원저장)
  EXECUTE pkg_emp.proc_insert_new_emp('20201220','SA_MAN','신길동',13000);
    
 (실행-퇴직자처리) 키보드로 사원번호 입력
  
  ACCEPT P_EID PROMPT '퇴직사원의 사원번호 입력 : '
  DECLARE 
    V_EID HR.EMPLOYEES.EMPLOYEE_ID%TYPE:=TO_NUMBER('&P_EID');
    V_HDATE VARCHAR2(8) := '20210710'; 
  BEGIN
    pkg_emp.proc_retire(V_EID,V_HDATE);
  END;
 