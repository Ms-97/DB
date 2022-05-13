2022-0513-01) 
 ������ ���̺�(tbl_good, customer)�� �ڷ� ����
 ��ǰ����
 -----------------------------------------------
 ��ǰ��ȣ         �̸�        ����
 -----------------------------------------------
 p101           �����       1200
 p102           �Ŷ��       1500
 p103            �κ�        2500
 p104         ��ġ(200g)     1750        
 ----------------------------------------------- 
 INSERT INTO TBL_GOOD VALUES('p101', '�����', 1200);
 INSERT INTO TBL_GOOD VALUES('p102', '�Ŷ��', 1500);
 INSERT INTO TBL_GOOD VALUES('p103', '�κ�', 2500);
 INSERT INTO TBL_GOOD VALUES('p104', '��ġ(200g)', 1750);
 
 SELECT * FROM TBL_GOOD;
 COMMIT;
 ������
 -----------------------------------------------
 ����ȣ         �̸�        �ּ�
 -----------------------------------------------
 2201           ������       ����� ���ϱ� ������ 100
 2210           ������       ������ ����� ������ 1555
 2005           �յ���       û�ֽ� û���� ���� 102
 ----------------------------------------------- 
 INSERT INTO CUSTOMER VALUES('2201','������','����� ���ϱ� ������ 100');
 INSERT INTO CUSTOMER VALUES('2210','������','������ ����� ������ 1555');
 INSERT INTO CUSTOMER VALUES('2005','�յ���','û�ֽ� û���� ���� 102');
 
 SELECT * FROM CUSTOMER;
 COMMIT;
 
 ��뿹)ȸ���� ��ǰ�� ������ ��� ���Ż�ǰ(ORDER_GOOD)���̺� ����������
        ��ϵǾ�� �Ѵ�. �̶� �������̺��� ����(AMOUNT)�� �ڵ����� ���ŵ� �� 
        �ִ� Ʈ���Ÿ� �ۼ��Ͻÿ�.
  1)�ֹ���ȣ �����Լ�
  /
    CREATE OR REPLACE FUNCTION FN_CREATE_ORDER_NUMBER
      RETURN NUMBER 
     IS 
        V_ONUM tbl_order.ordernum%TYPE;
        V_FLAG NUMBER:=0;
     BEGIN 
        SELECT COUNT(*) INTO V_FLAG
          FROM TBL_ORDER
         WHERE TRUNC(ODATE)=TRUNC(SYSDATE);
         
        IF V_FLAG=0 THEN
           V_ONUM:=TO_NUMBER(TO_CHAR(SYSDATE, 'YYYYMMDD')||TRIM('001'));
    ELSE    
        SELECT MAX(ORDERNUM)+1 INTO V_ONUM
          FROM TBL_ORDER
         WHERE TRUNC(ODATE)=TRUNC(SYSDATE);
      END IF;
      RETURN V_ONUM;
     END;
  /   
     INSERT INTO TBL_ORDER VALUES(20220513003,SYSDATE,20000,'2210');
 /    
      SELECT FN_CREATE_ORDER_NUMBER FROM DUAL;
/        

2)Ʈ���� ���� 
 /
  CREATE OR REPLACE TRIGGER TG_UPDATE_ORDER
   AFTER INSERT ON ORDER_GOOD
   FOR EACH ROW
  DECLARE 
    V_GID tbl_good.good_id%TYPE;
    V_AMT NUMBER:=0;
    V_PRICE NUMBER:=0;
  BEGIN
    V_GID:=(:NEW.GOOD_ID);
    SELECT GOOD_PRICE INTO V_PRICE
      FROM TBL_GOOD
     WHERE GOOD_ID = V_GID;
     V_AMT:= V_PRICE*(:NEW.ORDER_QTY);
     
     UPDATE TBL_ORDER
        SET AMOUNT = AMOUNT+v_AMT
      WHERE ORDERNUM=(:NEW.ORDERNUM); 
  END;
  /
  
  INSERT INTO TBL_ORDER
   VALUES(FN_CREATE_ORDER_NUMBER,SYSDATE,0,'2205');
   /
   
   �Ŷ�� 5�� ��ġ 2�� ����
   /
   CREATE OR REPLACE PROCEDURE PROC_INSERT_ORDER_GOOD(
    P_CID IN CUSTOMER.CID%TYPE,
    P_GID IN tbl_good.good_id%TYPE,
    P_SU IN NUMBER)
   IS
    V_ORDER_NUM TBL_ORDER.ORDERNUM%TYPE;
   BEGIN
     SELECT ORDERNUM INTO V_ORDER_NUM
       FROM TBL_ORDER
      WHERE TRUNC(ODATE) = TRUNC(SYSDATE)
        AND CID=P_CID;
        
      INSERT INTO ORDER_GOOD
       VALUES(P_GID,V_ORDER_NUM,P_SU);
      COMMIT;
   END;
   /
   EXEC PROC_INSERT_ORDER_GOOD('2205','p102',5);
   EXEC PROC_INSERT_ORDER_GOOD('2205','p104',2);
   /