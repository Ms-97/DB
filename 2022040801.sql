2022-0408-01)
��뿹) ������̺�(HR���� EMPLOYEES���̺�)���� ��� ����� �޿���
        15%�λ��Ͽ� �����Ͻÿ�.
        
        
COMMIT;
     
     SELECT FIRST_NAME, SALARY
     FROM HR.employees;
    
    UPDATE HR.employees
        SET SALARY = SALARY+ROUND(SALARY*0.15);
        
   ROLLBACK;
   
   4. DELETE ���
   - ���ʿ��� �ڷḦ ���̺��� ����
   DELETE FROM ���̺��
   [WHERE ����]
   
��뿹)
    DELETE FROM CART
    
    ROLLBACK;
    
5. ����Ŭ ������Ÿ��
    -����Ŭ�� ���� ������ Ÿ���� �������� ����
    -���ڿ�,����,��¥,2�� ������Ÿ�� ����
  1) ���ڿ� �ڷ���
   - ����Ŭ�� ���ڿ� �ڷ�� '  '�� ���
   - ���ڿ� �ڷ����� CHAR, VARCHAR, VARCHAR2, NVARCHAR, NVARCHAR2,
     LONG, CLOB, NCLOB���� ����
    (1) CHAR
     . �������� ���ڿ� �ڷ� ����
     . �ִ� 2000byte ���� ���尡��
     . ������ ������ ������ ������ ������ pedding, �������� ������
       error
     . �⺻Ű�� �������ڷ�(�ֹι�ȣ ��)���忡 �ַ� ���
     (��뿹)
      �÷��� CHAR(ũ��[byte|char])
       .'ũ��[byte|char]' : 'ũ��'�� ����� ���� byte���� char(���ڼ�) 
        ������ ����. �����ϸ� byte�� ����
       .�ѱ� �ѱ��ڴ� 3byte�� ����Ǹ� CHAR(2000CHAR) �� ����Ǿ��� 
        ������ ��ü ������ 2000byte�� �ʰ��� �� ����
        
��뿹)
    CREATE TABLE TEMP01(
        COL1 CHAR(20),
        COL2 CHAR(20 BYTE),
        COL3 CHAR(20 CHAR));
        
        INSERT INTO TEMP01 VALUES('������ �߱�','������ �߱�','������ �߱�');
        INSERT INTO TEMP01 VALUES('������ �߱� ���� 846','������ �߱�','������ �߱�');
        
        SELECT * FROM TEMP01;
        SELECT LENGTHB(COL1),
                LENGTHB(COL2),
                LENGTHB(COL3)
        FROM TEMP01;
        
    (2) VARCHAR2
        .�������� ���ڿ� �ڷḦ ����
        .�ִ� 4000byte���� ���� ����
        .VARCHAR�� ���� ����
        .NVARCHAR �� NVARCHAR2�� ���� ǥ���ڵ��� UTF-8, UTF-16�������
         �����͸� ���ڵ��Ͽ� ����
     (�������)
        �÷��� VARCHAR2 (ũ��[BYTE|CHAR])
        
    (��뿹)
       CREATE TABLE TEMP02(
        COL1 VARCHAR2(100),
        COL2 VARCHAR2(100 BYTE),
        COL3 VARCHAR2(100 CHAR),
        COL4 CHAR(100));
        
        INSERT INTO TEMP02
            VALUES('IL POSTINO','IL POSTINO','IL POSTINO','IL POSTINO');
            
         SELECT * FROM TEMP02;
         
    (3) LONG
        .�������� ������ ����
        .�ִ� 2GB ���� ���� ����
        .�� ���̺� �ϳ��� LONGŸ�� �÷��� ���
        .CLOB(Character Large OBjects)�� ��� ���׷��̵� ��
        .select ���� select��, update���� set��, insert���� values������
         ��� ����
        .�Ϻ� �Լ������� ���� �� ����
     (�������)
      �÷��� long
      
    (��뿹)
        CREATE TABLE TEMP03(
            COL1 LONG,
            COL2 VARCHAR2(4000));
        
        INSERT INTO TEMP03
                VALUES('BANNA APPLE PERSIMMON','BANNA APPLE PERSIMMON')
        
        SELECT * FROM TEMP03;
        
        SELECT SUBSTR(COL1,7,5) --����
          FROM TEMP03;
          
        (4) CLOB
        . �������� ������ ����
        . �ִ� 4GB���� ó�� ����
        . �� ���̺� ���� ���� CLOB�ڷ�Ÿ���� �÷� ��밡��
        . �Ϻ� ����� DBMS_LOB API�� ������ �޾ƾ� ��� ����
    (�������)
     �÷��� CLOB;
     
     (��뿹)
     CREATE TABLE TEMP04(
        COL1 LONG,
        COL2 CLOB,
        COL3 CLOB,
        COL4 VARCHAR2(4000));
        
        INSERT INTO TEMP04
          VALUES('','������ �߱� ���� 846','������ �߱� ���� 846','������ �߱� ���� 846');
        SELECT * FROM TEMP04;
        
        SELECT DBMS_LOB.GETLENGTH(COL2),
               DBMS_LOB.GETLENGTH(COL3),
               LENGTHB(COL4)
          FROM TEMP04;
          
       SELECT SUBSTR(COL2,5,2),
               DBMS_LOB.SUBSTR(COL2,5,2),
               SUBSTR(COL4,5,2)
          FROM TEMP04;