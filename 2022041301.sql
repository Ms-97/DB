2022-0413-01)�Լ�
 - ��� ����ڵ��� ������ �������� ����ϵ��� �̸� ���α׷��ֵǾ�
   �������� �� ���� ������ ���·� ����� ���
 - ���ڿ�, ����, ��¥, ����ȯ, ����(�׷�)�Լ��� ����
 
1. ���ڿ��Լ�
 1)CONCAT(C1,C2) --�ݵ�� �Ű����� 2�� �ʿ� c n:���� d:dateŸ�� con:�÷�
  - �־��� �� ���ڿ� C1�� C2�� �����Ͽ� ���ο� ���ڿ��� ��ȯ
  - ���ڿ� ���� ������ '||'�� ���� ���
��뿹) ȸ�����̺����� 2000�� ���� ����� ȸ�������� ��ȸ�Ͻÿ�
        Alias�� ȸ����ȣ,ȸ����,�ֹι�ȣ,�ּ��̴�.
        �ֹι�ȣ�� XXXXXX-XXXXXXX�������� �ּҴ� �⺻�ּҿ� ���ּҰ� ���� �ϳ��� 
        �߰��Ͽ� �����Ұ�
        
    SELECT MEM_ID AS ȸ����ȣ,
           MEM_NAME AS ȸ����,
           CONCAT(CONCAT(MEM_REGNO1,'-'),MEM_REGNO2) AS �ֹι�ȣ,
           MEM_ADD1 ||' '||MEM_ADD2 AS �ּ�
      FROM MEMBER
     WHERE SUBSTR(MEM_REGNO2,1,1) IN('3','4');

    2)LOWER(c1), UPPER(c1), INITCAP(c1)
    . LOWER(c1) : �־��� ���ڿ� c1�� ���ڸ� ��� �ҹ��ڷ� ��ȯ
    . UPPER(c1) : �־��� ���ڿ� c1�� ���ڸ� ��� �빮�ڷ� ��ȯ
    . INITCAP(c1) : c1 ���� ���� �� �ܾ��� ù ���ڸ� �빮�ڷ� ��ȯ
 
 ��뿹)ȸ�����̺����� ȸ����ȣ 'F001'ȸ�������� ��ȸ�Ͻÿ�
       Alias�� ȸ����ȣ,ȸ����,�ּ�,���ϸ����̴�.
    SELECT MEM_ID AS ȸ����ȣ,
           MEM_NAME AS ȸ����,
           MEM_ADD1||' '||MEM_ADD2 AS �ּ�,
           MEM_MILEAGE AS ���ϸ���
      FROM MEMBER
     WHERE UPPER(MEM_ID) = 'F001';
     
    SELECT employee_id,
           LOWER(FIRST_NAME)|| ' '||UPPER(LAST_NAME),
           LOWER(FIRST_NAME||' '||LAST_NAME),
           INITCAP(LOWER(FIRST_NAME||' '||LAST_NAME)),
           EMP_NAME
      FROM HR.employees;    
      
    3)LPAD(c1,n[,c2]), RPAD(c1,n[,c2])
     . LPAD(c1,n[,c2]): n �ڸ��� �־��� ���ڿ� c1�� ä��� ���� ���ʰ�����
       c2 ���ڿ��� ä��, c2�� �����Ǹ� ������ ä����
     . RPAD(c1,n[,c2]): n �ڸ��� �־��� ���ڿ� c1�� ä��� ���� ���ʰ�����
       c2 ���ڿ��� ä��, c2�� �����Ǹ� ������ ä����

 ��뿹)
    SELECT '1,000,000',
            LPAD('1,000,000',15,'*'),       
            RPAD('1,000,000',15,'*')
      FROM DUAL;
  
  ��뿹) �Ⱓ(��� ��)�� �Է� �޾� ����� ���� ���� 5�� ��ǰ�� �������踦 ���ϴ�
          ���ν����� �ۼ��Ͻÿ�
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
   - LTRIM(c1 [,c2]): c1 ���ڿ����� ���� ������ġ���� c2���ڿ��� ã��
     ���� ���ڿ��� ������ ����, c2�� �����Ǹ� ���� ������ ���� 
    - RTRIM(c1 [,c2]): c1 ���ڿ����� ������ ������ġ���� c2���ڿ��� ã��
     ���� ���ڿ��� ������ ����, c2�� �����Ǹ� ������ ������ ���� 
     
 (��뿹)
 SELECT LTRIM('PERSIMMON BANNA APPLE', 'ER'), -- ������(���۱��ڰ� �ƴϱ⶧����)
        LTRIM('PERSIMMON BANNA APPLE', 'P'),
        LTRIM('     PERSIMMON BANNA APPLE')
   FROM DUAL;
   
    SELECT RTRIM('...ORACLE...','.'),  
           RTRIM('...OR...OR...','OR...'),
           RTRIM('...          ') AS "C"
      FROM DUAL;

 5) TRIM(c1)
   - c1���ڿ� ���ʰ� �����ʿ� �ִ� ��� ������ ����
   - �ٸ� ���ڿ� ������ ������ �������� ����(REPLACE�� ����)
 (��뿹)
   SELECT TRIM('   QWER    '),
          TRIM('  ����ȭ ���� �Ǿ����ϴ�!!  ')
     FROM DUAL;
     
 (��뿹)������ 2020�� 4�� 1���̶�� �Ҷ� ��ٱ������̺��� 
        ��ٱ��Ϲ�ȣ(CART_NO)�� �����Ͻÿ�.
    SELECT TO_CHAR(SYSDATE,'YYYYMMDD')||
          TRIM(TO_CHAR(MAX(TO_NUMBER(SUBSTR(CART_NO,9)))+1,'00000')),
          MAX(CART_NO)+1
      FROM CART
     WHERE CART_NO LIKE TO_CHAR(SYSDATE,'YYYYMMDD')||'%';
     
 6) SUBSTR(c,m[,n])
   - �־��� ���ڿ� c���� m��°���� n���� ���ڿ��� �����Ͽ� ��ȯ
   - n�� �����Ǹ� m��°���� ������ ��� ���ڿ��� �����Ͽ� ��ȯ
   - m�� 1���� ������(0�� ����Ǹ� 1�� ����)
   - m�� �����̸� �����ʺ��� ó����
   - n���� ���� ������ ���� ���� ��� n�� ������ ���� ����
   (��뿹)
   SELECT SUBSTR('�����Ⱑ ���ܿ� ���Ƕ�����', 5,6) AS COL1,
          SUBSTR('�����Ⱑ ���ܿ� ���Ƕ�����', 5) AS COL2,
          SUBSTR('�����Ⱑ ���ܿ� ���Ƕ�����', 0,6) AS COL3,
          SUBSTR('�����Ⱑ ���ܿ� ���Ƕ�����', 5,30) AS COL4,
          SUBSTR('�����Ⱑ ���ܿ� ���Ƕ�����', -5,6) AS COL5
     FROM DUAL;
     
��뿹) ȸ�����̺����� �������� ȸ������ ��ȸ�Ͻÿ�.
        Alias�� ������, ȸ�����̴�.
    SELECT SUBSTR(MEM_ADD1,1,2)AS ������,
           COUNT(*) AS ȸ����
      FROM MEMBER
      GROUP BY SUBSTR(MEM_ADD1,1,2);
      
 7) REPLACE(c1,c2[,c3])
   - ���ڿ� c1���� c2���ڿ��� ã�� c3���ڿ��� ġȯ
   - c3���ڿ��� �����Ǹ� ã�� c2���ڿ��� ������
   - c3�� �����ǰ� c2�� �������� ����ϸ� �ܾ� ������ ������ ������
   (��뿹)
   SELECT MEM_NAME,
          REPLACE(MEM_NAME,'��','��')
     FROM MEMBER;
     
    SELECT PROD_NAME,
           REPLACE(PROD_NAME,'�ﺸ','SAMBO'),
           REPLACE(PROD_NAME,'�ﺸ'),
           REPLACE(PROD_NAME,' ')
      FROM PROD; 
      
   (��뿹)ȸ�����̺����� '����'�� �����ϴ� ȸ������ �⺻�ּ��� ������
           ��Ī�� ��� '����������'�� ���Ͻ�Ű�ÿ�.
     SELECT MEM_NAME AS �̸�,
            MEM_ADD1 AS �⺻�ּ�,
       CASE WHEN SUBSTR(MEM_ADD1,1,3)='������' THEN
                 REPLACE(MEM_ADD1,SUBSTR(MEM_ADD1,1,3),'���������� ')
            WHEN SUBSTR(MEM_ADD1,1,5)!='����������' THEN 
                 REPLACE(MEM_ADD1,SUBSTR(MEM_ADD1,1,2),'���������� ')
            ELSE
                 MEM_ADD1  
             END AS �ٲ��ּ�
        FROM MEMBER
       WHERE MEM_ADD1 LIKE '����%'; 
    
  8) INSTR(c1,C2[,m[,n]])
   - �־��� c1���ڿ��� ó�� ���� ��ġ�� ��ȯ
   - m�� ������ġ�� ��Ÿ����
   - n�� �ݺ���Ÿ�� Ƚ��
 (��뿹) 
  SELECT INSTR('APPLEBABABAPERSIMMON','L') AS COL1, -- APPL 4��° = 4
         INSTR('APPLEBABABAPERSIMMON','A',3) AS COL1, -- 3��° ���� ã����� -> LEBA -> APPLEBA = 7 
         INSTR('APPLEBABABAPERSIMMON','A',3,2) AS COL1, -- 3��° ���� ã������ϰ� 2��° A���� ���� -> APP���� LEBA(ù��°)BA(2) = APPLEBABA=9
         INSTR('APPLEBABABAPERSIMMON','A',-3) AS COL1 -- �������� 3��°���� ���� 
    FROM DUAL;
    
  9) LENGTHB(c1), LENGTH(c1)
   -�־��� ���ڿ��� ���̸� BYTE����(LENGTHB), ���ڼ���(LENGTH)�� ��ȯ
   