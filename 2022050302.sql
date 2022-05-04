2022-0503-02)분기문과 반복문
1. 분기문
 - 개발언어의 분기문과 같은 기능제공
 - IF문, CASE WHEN 문 등이 제공
 1)IF문
  - 조건분기문
  (사용형식1)
  IF 조건문 THEN
     명령문1;
 [ELSE
     명령문2;]
  END IF;
  
  (사용형식2)
  IF 조건문1 THEN
     명령문1;
  ELSIF 조건문2 THEN
     명령문2;
         :
  ELSE
     명령문n;
  END IF;  
  
  (사용형식3)
  IF 조건문1 THEN
     IF 조건문2 THEN
        명령문1;
         :
     END IF;    
  ELSE
     명령문n;
  END IF;    
  
사용예) 다음 사원을 사원테이블에 저장하는 익명블록을 작성하시오
       저장하기전에 해당 사원의 이름으로 직원의 존재 유무를 판단하여 
       같은 이름이 있으면 갱신을 없으면 삽입을 수행하시오.
       사원번호는 가장 큰 사원번호 다음 번호로 지정한다.
       사원명 : 홍길동, 입사일 : 오늘, 직무코드 : IT_PROG
    DECLARE 
     V_EID HR.EMPLOYEES.EMPLOYEE_ID%TYPE;
     V_CNT NUMBER:=0; -- 해당 사원정보의 존재유무 판단
    BEGIN
     SELECT COUNT(*) INTO V_CNT
       FROM HR.EMPLOYEES
      WHERE EMP_NAME='홍길동';
      
     IF V_CNT = 0 THEN
        SELECT MAX(EMPLOYEE_ID)+1 INTO V_EID
          FROM HR.EMPLOYEES;
        INSERT INTO HR.EMPLOYEES(EMPLOYEE_ID,EMP_NAME,JOB_ID,HIRE_DATE)
         VALUES(V_EID,'홍길동','IT_PROG',SYSDATE);
      ELSE 
         UPDATE HR.EMPLOYEES
            SET HIRE_DATE = SYSDATE,
                JOB_ID='IT_PROG'
          WHERE EMP_NAME='홍길동';
      END IF;
      COMMIT;
    END;
    
    SELECT * FROM HR.EMPLOYEES;
    
  2. CASE WHEN문
   - 다중 분기명령(자바의 SWITCH CASE문과 유사)
  (사용형식1)
   CASE WHEN 조건1 THEN
             명령1;
        WHEN 조건2 THEN
             명령2;
              :
        [ELSE
             명령n;]
   END CASE;
 
 (사용형식2)
   CASE 조건1 WHEN 값1 THEN
                 명령1;
             WHEN 값2 THEN
                 명령2;
              :
   [ELSE
                명령n;]
   END CASE;  

사용예)회원테이블에서 마일리지를 조회하여
       0~2000 :'Biginner'
       2001~5000 : 'Normal'
       5000 -    : 'Excellent'를 비고에 출력하시오.
      출력은 회원명, 마일리지,비고이다
   DECLARE
     CURSOR CUR_MEM02 IS     --반복시 커서 사용
      SELECT MEM_NAME,MEM_MILEAGE FROM MEMBER;
    V_RES VARCHAR2(200);
BEGIN
   FOR REC IN CUR_MEM02 LOOP
      CASE WHEN REC.MEM_MILEAGE < 2001 THEN
                V_RES:=RPAD(REC.MEM_NAME,10)||
                       LPAD(REC.MEM_MILEAGE,7)||'  Beginner';
           WHEN REC.MEM_MILEAGE < 5001 THEN
                V_RES:=RPAD(REC.MEM_NAME,10)||
                       LPAD(REC.MEM_MILEAGE,7)||'  Normal';
           ELSE
                V_RES:=RPAD(REC.MEM_NAME,10)||
                       LPAD(REC.MEM_MILEAGE,7)||'  Excellent';            
       END CASE;
       DBMS_OUTPUT.PUT_LINE(V_RES);
        DBMS_OUTPUT.PUT_LINE('----------------------------------');
     END LOOP; 
     END;
   