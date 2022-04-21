2022-0413-01)함수
 - 모든 사용자들이 공통의 목적으로 사용하도록 미리 프로그래밍되어
   컴파일한 후 실행 가능한 형태로 저장된 모듈
 - 문자열, 숫자, 날짜, 형변환, 집계(그룹)함수가 제공
 
1. 문자열함수
 1)CONCAT(C1,C2) --반드시 매개변수 2개 필요 c n:숫자 d:date타입 con:컬럼
  - 주어진 두 문자열 C1과 C2를 결합하여 새로운 문자열을 반환
  - 문자열 결합 연산자 '||'와 같은 기능
사용예) 회원테이블에서 2000년 이후 출생한 회원정보를 조회하시오
        Alias는 회원번호,회원명,주민번호,주소이다.
        주민번호는 XXXXXX-XXXXXXX형식으로 주소는 기본주소와 상세주소가 공백 하나를 
        추가하여 연결할것
        
    SELECT MEM_ID AS 회원번호,
           MEM_NAME AS 회원명,
           CONCAT(CONCAT(MEM_REGNO1,'-'),MEM_REGNO2) AS 주민번호,
           MEM_ADD1 ||' '||MEM_ADD2 AS 주소
      FROM MEMBER
     WHERE SUBSTR(MEM_REGNO2,1,1) IN('3','4');

    2)LOWER(c1), UPPER(c1), INITCAP(c1)
    . LOWER(c1) : 주어진 문자열 c1의 문자를 모두 소문자로 변환
    . UPPER(c1) : 주어진 문자열 c1의 문자를 모두 대문자로 변환
    . INITCAP(c1) : c1 내의 문자 중 단어의 첫 문자만 대문자로 변환
 
 사용예)회원테이블에서 회원번호 'F001'회원정보를 조회하시오
       Alias는 회원번호,회원명,주소,마일리지이다.
    SELECT MEM_ID AS 회원번호,
           MEM_NAME AS 회원명,
           MEM_ADD1||' '||MEM_ADD2 AS 주소,
           MEM_MILEAGE AS 마일리지
      FROM MEMBER
     WHERE UPPER(MEM_ID) = 'F001';
     
    SELECT employee_id,
           LOWER(FIRST_NAME)|| ' '||UPPER(LAST_NAME),
           LOWER(FIRST_NAME||' '||LAST_NAME),
           INITCAP(LOWER(FIRST_NAME||' '||LAST_NAME)),
           EMP_NAME
      FROM HR.employees;    
      
    3)LPAD(c1,n[,c2]), RPAD(c1,n[,c2])
     . LPAD(c1,n[,c2]): n 자리에 주어진 문자열 c1을 채우고 남는 왼쪽공간에
       c2 문자열을 채움, c2가 생략되면 공백이 채워짐
     . RPAD(c1,n[,c2]): n 자리에 주어진 문자열 c1을 채우고 남는 왼쪽공간에
       c2 문자열을 채움, c2가 생략되면 공백이 채워짐

 사용예)
    SELECT '1,000,000',
            LPAD('1,000,000',15,'*'),       
            RPAD('1,000,000',15,'*')
      FROM DUAL;
  
  사용예) 기간(년과 월)을 입력 받아 매출액 기준 상위 5개 제품의 매출집계를 구하는
          프로시져를 작성하시오
    CREATE OR REPLACE PROCEDURE PROC_CALCULATE(
        P_PERIOD VARCHAR2)
    IS 
        CURSOR CUR_TOP5 IS
        SELECT TA.CID AS TID, TA.CSUM AS TSUM
          FROM (SELECT CART_PROD, AS CID,
                        SUM(CART_QTY*PROD_PRICE) AS CSUM
                  FROM CART A, PROD B
                 WHERE A, CART_PROD=B.PROD_ID
                   AND A.CART_NO LIKE P_PERIOD||'%'
                  GROUP BY A.CART_PROD
                  ORDER BY 2 DESC) TA
         WHERE ROWNUM<=5;
      V_PNAME PROD.PROD_NAME%TYPE;
      V_RES VARCHAR2(100);
    BEGIN
       FOR REC IN CUR_TOP5 LOOP
         SELECT PROD_NAME INTO V_PNAME
           FROM PROD
          WHERE PROD_ID=REC.TID;
          V_RES:=REC.TID||' '||RPAD(V_PNAME,30)||TO_CHAR(REC.TSUM,'99,999,999');
          DBMS_OUTPUT.PUT_LINE(V_RES);
        END LOOP;
    END;
    
    EXECUTE PROC_CALCULATE('202007');
    
 4) LTRIM(c1 [,c2]), RTRIM(c1 [,c2])
   - LTRIM(c1 [,c2]): c1 문자열에서 왼쪽 시작위치에서 c2문자열을 찾아
     같은 문자열이 있으면 삭제, c2가 생략되면 왼쪽 공백을 제거 
    - RTRIM(c1 [,c2]): c1 문자열에서 오른쪽 시작위치에서 c2문자열을 찾아
     같은 문자열이 있으면 삭제, c2가 생략되면 오른쪽 공백을 제거 
     
 (사용예)
 SELECT LTRIM('PERSIMMON BANNA APPLE', 'ER'), -- 못지움(시작글자가 아니기때문에)
        LTRIM('PERSIMMON BANNA APPLE', 'P'),
        LTRIM('     PERSIMMON BANNA APPLE')
   FROM DUAL;
   
    SELECT RTRIM('...ORACLE...','.'),  
           RTRIM('...OR...OR...','OR...'),
           RTRIM('...          ') AS "C"
      FROM DUAL;

 5) TRIM(c1)
   - c1문자열 왼쪽과 오른쪽에 있는 모든 공백을 제거
   - 다만 문자열 내부의 공백은 제거하지 못함(REPLACE로 제거)
 (사용예)
   SELECT TRIM('   QWER    '),
          TRIM('  무궁화 꽃이 피었습니다!!  ')
     FROM DUAL;
     
 (사용예)오늘이 2020년 4월 1일이라고 할때 장바구니테이블의 
        장바구니번호(CART_NO)를 생성하시오.
    SELECT TO_CHAR(SYSDATE,'YYYYMMDD')||
          TRIM(TO_CHAR(MAX(TO_NUMBER(SUBSTR(CART_NO,9)))+1,'00000')),
          MAX(CART_NO)+1
      FROM CART
     WHERE CART_NO LIKE TO_CHAR(SYSDATE,'YYYYMMDD')||'%';
     
 6) SUBSTR(c,m[,n])
   - 주어진 문자열 c에서 m번째에서 n개의 문자열을 추출하여 반환
   - n이 생략되면 m번째에서 이후의 모든 문자열을 추출하여 반환
   - m은 1부터 시작함(0이 기술되면 1로 간주)
   - m이 음수이면 오른쪽부터 처리됨
   - n보다 남은 문자의 수가 작은 경우 n이 생략된 경우와 동일
   (사용예)
   SELECT SUBSTR('나보기가 역겨워 가실때에는', 5,6) AS COL1,
          SUBSTR('나보기가 역겨워 가실때에는', 5) AS COL2,
          SUBSTR('나보기가 역겨워 가실때에는', 0,6) AS COL3,
          SUBSTR('나보기가 역겨워 가실때에는', 5,30) AS COL4,
          SUBSTR('나보기가 역겨워 가실때에는', -5,6) AS COL5
     FROM DUAL;
     
사용예) 회원테이블에서 거주지별 회원수를 조회하시오.
        Alias는 거주지, 회원수이다.
    SELECT SUBSTR(MEM_ADD1,1,2)AS 거주지,
           COUNT(*) AS 회원수
      FROM MEMBER
      GROUP BY SUBSTR(MEM_ADD1,1,2);
      
 7) REPLACE(c1,c2[,c3])
   - 문자열 c1에서 c2문자열을 찾아 c3문자열로 치환
   - c3문자열이 생략되면 찾은 c2문자열을 삭제함
   - c3가 생략되고 c2를 공백으로 기술하면 단어 내부의 공백을 제거함
   (사용예)
   SELECT MEM_NAME,
          REPLACE(MEM_NAME,'이','리')
     FROM MEMBER;
     
    SELECT PROD_NAME,
           REPLACE(PROD_NAME,'삼보','SAMBO'),
           REPLACE(PROD_NAME,'삼보'),
           REPLACE(PROD_NAME,' ')
      FROM PROD; 
      
   (사용예)회원테이블에서 '대전'에 거주하는 회원들의 기본주소의 광역시
           명칭을 모두 '대전광역시'로 통일시키시오.
     SELECT MEM_NAME AS 이름,
            MEM_ADD1 AS 기본주소,
       CASE WHEN SUBSTR(MEM_ADD1,1,3)='대전시' THEN
                 REPLACE(MEM_ADD1,SUBSTR(MEM_ADD1,1,3),'대전광역시 ')
            WHEN SUBSTR(MEM_ADD1,1,5)!='대전광역시' THEN 
                 REPLACE(MEM_ADD1,SUBSTR(MEM_ADD1,1,2),'대전광역시 ')
            ELSE
                 MEM_ADD1  
             END AS 바꾼주소
        FROM MEMBER
       WHERE MEM_ADD1 LIKE '대전%'; 
    
  8) INSTR(c1,C2[,m[,n]])
   - 주어진 c1문자열이 처음 나온 위치를 반환
   - m은 시작위치를 나타내며
   - n은 반복나타낸 횟수
 (사용예) 
  SELECT INSTR('APPLEBABABAPERSIMMON','L') AS COL1, -- APPL 4번째 = 4
         INSTR('APPLEBABABAPERSIMMON','A',3) AS COL1, -- 3번째 에서 찾기시작 -> LEBA -> APPLEBA = 7 
         INSTR('APPLEBABABAPERSIMMON','A',3,2) AS COL1, -- 3번째 에서 찾기시작하고 2번째 A에서 리턴 -> APP시작 LEBA(첫번째)BA(2) = APPLEBABA=9
         INSTR('APPLEBABABAPERSIMMON','A',-3) AS COL1 -- 역순으로 3번째에서 시작 
    FROM DUAL;
    
  9) LENGTHB(c1), LENGTH(c1)
   -주어진 문자열의 길이를 BYTE수로(LENGTHB), 글자수로(LENGTH)로 반환
   