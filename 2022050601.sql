20220506
PL/SQL(�������� ���ν��� ����ȭ�� ���� ���)
Pakage(��Ű��)
User Function(��������� �Լ�)
Stored Procedure(���� ���ν���)
Trigger(Ʈ����)
Anonymous Block(�͸��� ���)

-- DBMS OUTPUT ������� �ֿܼ� ǥ��
SET SERVEROUTPUT ON;

DECLARE
    -- SCALAR(�Ϲ�)����
    V_BUY_PROD VARCHAR2(10);
    V_QTY NUMBER(10);
    -- 2020�⵵ ��ǰ�� ���Լ����� ��
    CURSOR CUR IS
    SELECT BUY_PROD, SUM(BUY_QTY)
    FROM BUYPROD
    WHERE BUY_DATE LIKE '2020%'
    GROUP BY BUY_PROD
    ORDER BY BUY_PROD ASC;
BEGIN
    -- �޸� �Ҵ�(�ö�) = ���ε�
    OPEN CUR;
    -- ����� (FETCH -> ������ -> ���)
    -- ���� ������ �̵�, ���� �����ϴ��� üŷ
    -- ��(FETCH)
    FETCH CUR INTO V_BUY_PROD, V_QTY;
    -- ��(������ FOUND: ����������? /NOTFOUND: �����Ͱ� ������?/ ROWCOUNT: ���Ǽ�)
    WHILE(CUR%FOUND) LOOP
    -- ��(���)
        DBMS_OUTPUT.PUT_LINE(V_BUY_PROD || ', ' || V_QTY);
        FETCH CUR INTO V_BUY_PROD, V_QTY;
   END LOOP; 
    -- ������� �޸𸮸� ��ȯ(�ʼ�)
    CLOSE CUR;
END;

--ȸ�����̺��� ȸ����� ���ϸ����� ����غ���
--��, ������ '�ֺ�'�� ȸ���� ����ϰ� ȸ�������� �������� �����غ���
-- ALIAS : MEM_NAME, MEM_MILEAGE
-- CUR �̸��� CURSOR�� �����ϰ� �͸������� ǥ��
    
DECLARE
    V_NAME MEMBER.MEM_NAME%TYPE; -- VARCHAR2(20); REFERENCE����
    V_MILEAGE NUMBER(10);  -- SCALAR����
    CURSOR CUR(V_JOB VARCHAR2)IS  
        SELECT MEM_NAME,MEM_MILEAGE
          FROM MEMBER
         WHERE MEM_JOB = V_JOB
         ORDER BY MEM_NAME;
 BEGIN
    OPEN CUR('�ֺ�');
    LOOP
        FETCH CUR INTO V_NAME, V_MILEAGE;
        EXIT WHEN CUR%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(CUR%ROWCOUNT || ',' || V_NAME || ', '|| V_MILEAGE);
    END LOOP;    
    CLOSE CUR;
 END;
 
 -- ������ �Է¹޾Ƽ� FOR LOOP�� �̿��ϴ� CURSOR
 
 BEGIN
    --FOR������ �ݺ��ϴ� ���� Ŀ���� �ڵ����� OPEN�ϰ�
    --��� ���� ó���Ǹ� �ڵ����� Ŀ���� CLOSE��
    --RCE : �ڵ�����Ǵ� ������ ����
    FOR REC IN (SELECT MEM_NAME, MEM_MILEAGE
                  FROM MEMBER
                 WHERE MEM_JOB = '�л�'
                ORDER BY MEM_NAME) LOOP
        DBMS_OUTPUT.PUT_LINE(REC.MEM_NAME || ',' || REC.MEM_NAME || ', '|| REC.MEM_MILEAGE);
    END LOOP;    
 END;
 
 --CURSOR����
 --2020�⵵ ȸ���� �Ǹűݾ�(�ǸŰ�(PROD_SALE) * ���ż���(CART_QTY))�� �հ踦
 --CURSOR�� FOR���� ���� ����غ���
 --ALISAS : MEM_ID, MEM_NAME, SUM_AMT
 --��¿��� : a001, ������, 2000
 --          b001, �̻���, 1750
 --          ...

 ����Ŭ           ANSI ǥ��
 -----------------------------------  
  īƼ�����δ�Ʈ     CROSS JOIN 
  (�������� X)
 -------------------------------------
    ��������        Inner Join
 -------------------------------------
    �ܺ�����        Outer Join    
                  Natural Join

 SELECT M.MEM_ID, M.MEM_NAME, SUM(P.PROD_SALE * C.CART_QTY)
   FROM PROD P, CART C, MEMBER M 
  WHERE P.PROD_ID = C.CART_PROD 
    AND C.CART_MEMBER = M.MEM_ID
    AND C.CART_NO LIKE '2020%'
  GROUP BY M.MEM_ID, M.MEM_NAME
  ORDER BY M.MEM_ID;
  
 ANSI ����
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
   
--STORED(����Ŭ ������ ĳ�ð����� �̸� �����) PROCEDURE
--������Ʈ ��(SET)�뿩(WHERE)
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
 DBMS_OUTPUT.PUT_LINE('������Ʈ ����!');
 COMMIT;
END; 
/
--EXECUTE USP_PROD_TOTALSTOCK_UPDATE;
EXEC USP_PROD_TOTALSTOCK_UPDATE
/