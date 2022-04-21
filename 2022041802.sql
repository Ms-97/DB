2022-0418-02)�� ��ȯ �Լ�
 - �Լ��� ���� ��ġ���� �Ͻ������� ������Ÿ���� ���� ��ȯ ��Ŵ
 - TO_CHAR, TO_DATE, TO_NUMBER, CAST�� ����
 1) CAST(expr AS type��)
  . 'expr'�� ����� ���� ������Ÿ���� 'type'���� ��ȯ
  
��뿹) SELECT  'ȫ�浿',
              CAST('ȫ�浿' AS CHAR(20)),
              CAST('20200418' AS DATE)
         FROM DUAL;
              
              
    SELECT MAX(CAST(CART_NO AS NUMBER))+1
      FROM CART
     WHERE CART_NO LIKE '20200507%'; --���������� ����(����������)
     
 2) TO_CHAR(c), TO_CHAR(d | n [,fmt])
  - �־��� ���ڿ��� ���ڿ��� ��ȯ(��, c�� Ÿ���� CHAR or CLOB�ΰ��
    VARCHAR2�� ��ȯ�ϴ� ��츸 ���
  - �־��� ��¥(d) �Ǵ� ����(n)�� ���ǵ� ����(fmt)���� ��ȯ        
  - ��¥���� ���Ĺ���
--------------------------------------------------------------------------
 FORMAT����             �ǹ�                       ��뿹
--------------------------------------------------------------------------
   AD, BC              ����       SELECT TO_CHAR(SYSDATE, 'AD BC') FROM DUAL;
   CC, YEAR         ����, �⵵     SELECT TO_CHAR(SYSDATE, 'CC YEAR') FROM DUAL;
   YYYY, YYY,YY,Y      �⵵       SELECT TO_CHAR(SYSDATE, 'YYYY YYY YY Y') FROM DUAL;
   Q                   �б�       SELECT TO_CHAR(SYSDATE, 'CC Q') FROM DUAL;
   MM, RM               ��        SELECT TO_CHAR(SYSDATE, 'YY:MM:RM') FROM DUAL; 
   MONTH, MON           ��        SELECT TO_CHAR(SYSDATE, 'MONTH MON') FROM DUAL;
   W, WW, IW           ����       SELECT TO_CHAR(SYSDATE, 'W WW IW') FROM DUAL;
   DD, DDD, J          ����       SELECT TO_CHAR(SYSDATE, 'DD DDD J') FROM DUAL;
   DAY, DY, D          ����       SELECT TO_CHAR(SYSDATE, 'DAY DY D') FROM DUAL;  -- DAY:ȭ���� DY: ȭ D: ������ �ε����� 3
   AM, PM,           ����/����     SELECT TO_CHAR(SYSDATE, 'AM PM') FROM DUAL;    --����ð��� ���� �������� ǥ�� 
   A.M., P.M.        ����/����     SELECT TO_CHAR(SYSDATE, 'A.M. P.M.') FROM DUAL;    --����ð��� ���� �������� ǥ�� 
   HH, HH12, HH24      �ð�        SELECT TO_CHAR(SYSDATE, 'HH HH12 HH24') FROM DUAL;    --HH,HH12 : 12�� �������� ǥ��  HH24: 24�� �������� ǥ��
   MI                   ��        SELECT TO_CHAR(SYSDATE, 'MI') FROM DUAL; -- �� ǥ��   
   SS, SSSSS            ��        SELECT TO_CHAR(SYSDATE, 'SS SSSSS') FROM DUAL;  -- SSSSSS: 0�� 0�� 0�� �������� ���������� ��
   "���ڿ�"          ���������     SELECT TO_CHAR(SYSDATE, 'YYYY"��" MM"��" DD"��"') FROM DUAL;
--------------------------------------------------------------------------      

 - ���ڰ��� ���Ĺ���
--------------------------------------------------------------------------
 FORMAT����             �ǹ�                       
--------------------------------------------------------------------------
     9       ��������� �ڸ�����, ��ȿ������ ��� ���ڸ� ����ϰ� ��ȿ�� 0�� ���
             ����ó��
     0       ��������� �ڸ�����, ��ȿ������ ��� ���ڸ� ����ϰ� ��ȿ�� 0�� ���
             0�� ���
    $, L     ȭ���ȣ ���  
     PR      �����ڷᰡ ������ ��� "-"��ȣ ��� "<>"�ȿ� ���� ���
    ,(Comma) 3�ڸ������� �ڸ��� ���
    .(Dot)   �Ҽ��� ���
--------------------------------------------------------------------------
��뿹)
    SELECT TO_CHAR(12345, '999999'),  -- 9�� ���� 9�� �ǹ� X 	
           TO_CHAR(12345, '999,999.99'),
           TO_CHAR(12345.786, '000,000.0'),
           TO_CHAR(12345, '0,000,000'),
           TO_CHAR(-12345, '99,999PR'),
           TO_CHAR(12345, 'L99,999'),
           TO_CHAR(12345, '$99999')
      FROM DUAL;
 
  3) TO_NUMBER(c[,fmt]) 
  - �־��� ���ڿ� �ڷ� c�� fmt ������ ���ڷ� ��ȯ
  
��뿹)
    SELECT TO_NUMBER('12345'),  
           TO_NUMBER('12,345','99,999'), 
           TO_NUMBER('<1234>','9999PR'),
           TO_NUMBER('$12,234.00','$99,999.99')*1100
      FROM DUAL;    

  4) TO_DATE(c[,fmt]) 
  - �־��� ���ڿ� �ڷ� c�� fmt ������ ��¥�ڷ�� ��ȯ
      
��뿹)
    SELECT TO_DATE('20220405'),
           TO_DATE('220405','YYMMDD')
      FROM DUAL;     