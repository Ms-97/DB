2022-0418-02)형 변환 함수
 - 함수가 사용된 위치에서 일시적으로 데이터타입의 형을 변환 시킴
 - TO_CHAR, TO_DATE, TO_NUMBER, CAST이 제공
 1) CAST(expr AS type명)
  . 'expr'의 저장된 값의 데이터타입을 'type'으로 변환
  
사용예) SELECT  '홍길동',
              CAST('홍길동' AS CHAR(20)),
              CAST('20200418' AS DATE)
         FROM DUAL;
              
              
    SELECT MAX(CAST(CART_NO AS NUMBER))+1
      FROM CART
     WHERE CART_NO LIKE '20200507%'; --숫자형으로 저장(오른쪽정렬)
     
 2) TO_CHAR(c), TO_CHAR(d | n [,fmt])
  - 주어진 문자열을 문자열로 변환(단, c의 타입이 CHAR or CLOB인경우
    VARCHAR2로 변환하는 경우만 허용
  - 주어진 날짜(d) 또는 숫자(n)을 정의된 형식(fmt)으로 변환        
  - 날짜관련 형식문자
--------------------------------------------------------------------------
 FORMAT문자             의미                       사용예
--------------------------------------------------------------------------
   AD, BC              서기       SELECT TO_CHAR(SYSDATE, 'AD BC') FROM DUAL;
   CC, YEAR         세기, 년도     SELECT TO_CHAR(SYSDATE, 'CC YEAR') FROM DUAL;
   YYYY, YYY,YY,Y      년도       SELECT TO_CHAR(SYSDATE, 'YYYY YYY YY Y') FROM DUAL;
   Q                   분기       SELECT TO_CHAR(SYSDATE, 'CC Q') FROM DUAL;
   MM, RM               월        SELECT TO_CHAR(SYSDATE, 'YY:MM:RM') FROM DUAL; 
   MONTH, MON           월        SELECT TO_CHAR(SYSDATE, 'MONTH MON') FROM DUAL;
   W, WW, IW           주차       SELECT TO_CHAR(SYSDATE, 'W WW IW') FROM DUAL;
   DD, DDD, J          일자       SELECT TO_CHAR(SYSDATE, 'DD DDD J') FROM DUAL;
   DAY, DY, D          요일       SELECT TO_CHAR(SYSDATE, 'DAY DY D') FROM DUAL;  -- DAY:화요일 DY: 화 D: 요일의 인덱스값 3
   AM, PM,           오전/오후     SELECT TO_CHAR(SYSDATE, 'AM PM') FROM DUAL;    --현재시간의 오전 오후인지 표시 
   A.M., P.M.        오전/오후     SELECT TO_CHAR(SYSDATE, 'A.M. P.M.') FROM DUAL;    --현재시간의 오전 오후인지 표시 
   HH, HH12, HH24      시간        SELECT TO_CHAR(SYSDATE, 'HH HH12 HH24') FROM DUAL;    --HH,HH12 : 12시 형식으로 표시  HH24: 24시 형식으로 표시
   MI                   분        SELECT TO_CHAR(SYSDATE, 'MI') FROM DUAL; -- 분 표시   
   SS, SSSSS            초        SELECT TO_CHAR(SYSDATE, 'SS SSSSS') FROM DUAL;  -- SSSSSS: 0시 0분 0초 에서부터 지끔가지의 초
   "문자열"          사용자정의     SELECT TO_CHAR(SYSDATE, 'YYYY"년" MM"월" DD"일"') FROM DUAL;
--------------------------------------------------------------------------      

 - 숫자관련 형식문자
--------------------------------------------------------------------------
 FORMAT문자             의미                       
--------------------------------------------------------------------------
     9       출력형식의 자리설정, 유효숫자인 경우 숫자를 출력하고 무효의 0인 경우
             공백처리
     0       출력형식의 자리설정, 유효숫자인 경우 숫자를 출력하고 무효의 0인 경우
             0을 출력
    $, L     화폐기호 출력  
     PR      원본자료가 음수인 경우 "-"부호 대신 "<>"안에 숫자 출력
    ,(Comma) 3자리마다의 자리점 출력
    .(Dot)   소숫점 출력
--------------------------------------------------------------------------
사용예)
    SELECT TO_CHAR(12345, '999999'),  -- 9가 숫자 9를 의미 X 	
           TO_CHAR(12345, '999,999.99'),
           TO_CHAR(12345.786, '000,000.0'),
           TO_CHAR(12345, '0,000,000'),
           TO_CHAR(-12345, '99,999PR'),
           TO_CHAR(12345, 'L99,999'),
           TO_CHAR(12345, '$99999')
      FROM DUAL;
 
  3) TO_NUMBER(c[,fmt]) 
  - 주어진 문자열 자료 c를 fmt 형식의 숫자로 변환
  
사용예)
    SELECT TO_NUMBER('12345'),  
           TO_NUMBER('12,345','99,999'), 
           TO_NUMBER('<1234>','9999PR'),
           TO_NUMBER('$12,234.00','$99,999.99')*1100
      FROM DUAL;    

  4) TO_DATE(c[,fmt]) 
  - 주어진 문자열 자료 c를 fmt 형식의 날짜자료로 변환
      
사용예)
    SELECT TO_DATE('20220405'),
           TO_DATE('220405','YYMMDD')
      FROM DUAL;     