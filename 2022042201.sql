2022-0422-01) TABLE JOIN
- ������ DB�� ���� �ٽ� ���
- �������� ���̺� ���̿� �����ϴ� ���踦 �̿��� ����
- ����ȭ�� �����ϸ� ���̺��� ��Ȱ�ǰ� �ʿ��� �ڷᰡ �������� ���̺�
  �л� ����� ��� ����ϴ� ����

 - Join�� ����
  . �Ϲ����� vs ANSI JOIN
  . INNER JOIN vs OUTER JOIN
  . Equi-Join vs Non Equi-Join --���� ���ǿ� �����ڰ� ���� ��� Equi-Join 
  . ��Ÿ(Cartesian Product, Self Join ,..ect)
 - �������(�Ϲ� ����)
  SELECT �÷�list
    FROM ���̺��1 [��Ī1],���̺��2 [��Ī2][,���̺��3 [��Ī3],...]
   WHERE �������� 
    [AND �Ϲ�����]
   . ���̺� ��Ī�� �������� ���̺� ������ �÷����� �����ϰ� �ش� �÷��� �����ϴ�
     ��� �ݵ�� ���Ǿ�� ��
   . ���Ǵ� ���̺��� n�� �϶� ���������� ��� n-1�� �̻��̿��� ��
   . ���������� �� ���̺� ���� ������ �÷��� �����
   
   
1. Cartesian Product
 - ���������� ���ų� ���������� �߸��� ��� �߻�
 - �־��� ���(���������� ���� ���) A���̺�(a�� b��)�� B���̺�(c�� d��)��
   Cartesian Product�� �����ϸ� ����� a*c��, b+d���� ����
 - ANSI������ CROSS JOIN�̶�� �ϸ� �ݵ�� �ʿ��� ��찡 �ƴϸ� ��������
   ���ƾ��ϴ� JOIN�̴�.
   
   (�������-�Ϲ�����)
   SELECT �÷�list
     FROM ���̺��1 [��Ī1],���̺��2 [��Ī2][,���̺��3 [��Ī3],...]
      
    (�������-ANSI����)
   SELECT �÷�list
     FROM ���̺��1 [��Ī1]
    CROSS JOIN ���̺��; 
   
   (��� ��) 
   SELECT COUNT(*)
     FROM PROD;
    
    SELECT COUNT(*)
     FROM CART;  
   
      SELECT COUNT(*)
      FROM BUYPROD;
      
   SELECT COUNT(*)
     FROM PROD A, CART B, BUYPROD C;
     
    SELECT COUNT(*)
     FROM PROD A
    CROSS JOIN CART B             
    CROSS JOIN BUYPROD C; 
    
 2. Equi Join
 - ���� ���ǿ� '='�����ڰ� ���� �������� ��κ��� ������ �̿� ���Եȴ�.
 - �������� ���̺� �����ϴ� ������ �÷����� ��� �򰡿� ���� ����
  (�Ϲ����� �������)
   SELECT �÷�list
     FROM ���̺�1 ��Ī1, ���̺�2 ��Ī2[,���̺�3 ��Ī3,...]
    WHERE �������� 
   
   (ANSI���� �������)
    SELECT �÷�list
     FROM ���̺�1 ��Ī1  --���̺� 1,2�� ������ �÷��� �ʿ� ������ 1,3�� ���� �ʿ����.
     INNER JOIN ���̺�2 ��Ī2 ON(�������� [AND �Ϲ�����]) 
     [INNER JOIN ���̺�3 ��Ī3 ON(�������� [AND �Ϲ�����])
              :
     [WHERE �Ϲ�����] 
     . 'AND �Ϲ�����' : ON ���� ����� �Ϲ������� �ش� INNER JOIN ���� ����
       ���ο� �����ϴ� ���̺� ���ѵ� ����
     . 'WHERE �Ϲ�����' : ��� ���̺� ����Ǿ�� �ϴ� ���Ǳ��
     
    ��뿹) 2020�� 1�� ��ǰ�� �������踦 ��ȸ�Ͻÿ�.
           Alias�� ��ǰ�ڵ�,��ǰ��,���Աݾ��հ�
    (�Ϲ� JOIN)            
         SELECT A.BUY_PROD AS ��ǰ�ڵ�,
                B.PROD_NAME AS ��ǰ��,
                SUM(A.BUY_QTY * B.PROD_COST) AS ���Աݾ��հ�
          FROM BUYPROD A, PROD B
         WHERE A.BUY_PROD= B.PROD_ID --�������� 
           AND A.BUY_DATE BETWEEN TO_DATE('20200101') AND TO_DATE('20200131')
         GROUP BY A.BUY_PROD, B.PROD_NAME
         ORDER BY 1;
         
     (ANSI JOIN)            
         SELECT A.BUY_PROD AS ��ǰ�ڵ�,
                B.PROD_NAME AS ��ǰ��,
                SUM(A.BUY_QTY * B.PROD_COST) AS ���Աݾ��հ�
          FROM BUYPROD A
          INNER JOIN PROD B ON(A.BUY_PROD = B.PROD_ID 
           AND A.BUY_DATE BETWEEN TO_DATE('20200101') AND TO_DATE('20200131'))
         GROUP BY A.BUY_PROD, B.PROD_NAME
         ORDER BY 1;   

��뿹)��ǰ���̺��� �ǸŰ��� 50�����̻��� ��ǰ�� ��ȸ�Ͻÿ�.
       Alias�� ��ǰ�ڵ�, ��ǰ��, �з���, �ŷ�ó��, �ǸŰ����̰� �ǸŰ����� ū ��ǰ��
       ���� ����Ͻÿ�.
      (�Ϲ�����)
       SELECT A.PROD_ID AS ��ǰ�ڵ�,
              A.PROD_NAME AS ��ǰ��,
              B.LPROD_NM AS �з���,
              C.BUYER_NAME AS �ŷ�ó��, 
              A.PROD_PRICE AS �ǸŰ���
         FROM PROD A, LPROD B, BUYER C
        WHERE A.PROD_LGU = B.LPROD_GU    --�������� (�з��� ���)
          AND A.PROD_BUYER = C.BUYER_ID  --�������� (�ŷ�ó�� ���)
          AND A.PROD_PRICE >= 500000  -- �Ϲ�����
         ORDER BY 5 DESC;
         
       (ANSI JOIN)
       SELECT A.PROD_ID AS ��ǰ�ڵ�,
              A.PROD_NAME AS ��ǰ��,
              B.LPROD_NM AS �з���,
              C.BUYER_NAME AS �ŷ�ó��, 
              A.PROD_PRICE AS �ǸŰ���
         FROM PROD A
   INNER JOIN LPROD B ON(A.PROD_LGU = B.LPROD_GU)  --�������� (�з��� ���)
   INNER JOIN BUYER C ON(A.PROD_BUYER = C.BUYER_ID) --�������� (�ŷ�ó�� ���)
          AND A.PROD_PRICE >= 500000  -- �Ϲ�����
         ORDER BY 5 DESC;
         
  ��뿹) 2020�� ��ݱ� �ŷ�ó�� �Ǹž����踦 ���Ͻÿ�.
       Alias�� �ŷ�ó�ڵ�, �ŷ�ó��, �Ǹž��հ�
      
       (�Ϲ�����)
       SELECT A.PROD_BUYER AS �ŷ�ó�ڵ�,
              C.BUYER_NAME AS �ŷ�ó��,
              SUM(A.PROD_PRICE * B.CART_QTY) AS �Ǹž��հ�
         FROM PROD A, CART B, BUYER C
        WHERE A.PROD_BUYER = C.BUYER_ID -- ��������(�ŷ�ó����)
          AND A.PROD_ID = B.CART_PROD -- ��������(�ܰ�����)
          AND SUBSTR(B.CART_NO,1,8) BETWEEN '202001' AND '202006'
         -- AND TO_DATE(SUBSTR(B.CART_NO,1,8),'YYMMDD') BETWEEN TO_DATE('20200101') AND TO_DATE('20200630')
          GROUP BY  A.PROD_BUYER,C.BUYER_NAME
          ORDER BY 1;
          
          (ANSI JOIN)
          SELECT A.PROD_BUYER AS �ŷ�ó�ڵ�,
                 C.BUYER_NAME AS �ŷ�ó��,
                 SUM(A.PROD_PRICE * B.CART_QTY) AS �Ǹž��հ�
            FROM PROD A
      INNER JOIN CART B ON (A.PROD_ID = B.CART_PROD)
      INNER JOIN BUYER C ON (A.PROD_BUYER = C.BUYER_ID)
             AND TO_DATE(SUBSTR(B.CART_NO,1,8),'YYMMDD') BETWEEN TO_DATE('20200101') AND TO_DATE('20200630')
          GROUP BY  A.PROD_BUYER,C.BUYER_NAME
          ORDER BY 1;
          
---------------------------------------------------------------------------------          
2022-0425-01)         
        
    ��뿹) HR�������� �̱� �̿��� ������ ��ġ�� �μ��� �ٹ��ϴ� ���������
           ��ȸ�Ͻÿ�.
           Alias�� �����ȣ,�����,�μ���,�����ڵ�,�ּ�
           �̱��� �����ڵ��'US'�̴�.
           
             SELECT A.EMPLOYEE_ID AS �����ȣ,
                    A.EMP_NAME AS �����,
                    B.DEPARTMENT_NAME AS �μ���,
                    A.JOB_ID AS �����ڵ�,
                     C.STREET_ADDRESS ||' '|| C.CITY ||', '|| C.STATE_PROVINCE AS �ּ�
             FROM HR.EMPLOYEES A, HR.DEPARTMENTS B, HR.LOCATIONS C
             WHERE A.DEPARTMENT_ID = B.DEPARTMENT_ID --��������(�μ�����)
                AND  B.LOCATION_ID = C.LOCATION_ID --��������(�ش� �μ��� ��ġ�ڵ� ����)
                AND  C.COUNTRY_ID != 'US';     
    
    ��뿹) 2020�� 4�� �ŷ�ó�� ���Աݾ��� ��ȸ�Ͻÿ�.
            Alias�� �ŷ�ó�ڵ�, �ŷ�ó��,���Աݾ��հ�
            (�Ϲ�����)
            SELECT A.BUYER_ID AS �ŷ�ó�ڵ�,
                   A.BUYER_NAME AS �ŷ�ó��,
                   SUM(C.PROD_COST*B.BUY_QTY) AS ���Աݾ��հ�
              FROM BUYER A, BUYPROD B, PROD C
             WHERE A.BUYER_ID = C.PROD_BUYER
               AND B.BUY_PROD = C.PROD_ID
               AND B.BUY_DATE BETWEEN TO_DATE('20200401') AND LAST_DAY('20200401')
              GROUP BY A.BUYER_ID, A.BUYER_NAME
              ORDER BY 1;
              
              (ANSI JOIN)
              SELECT A.BUYER_ID AS �ŷ�ó�ڵ�,
                   A.BUYER_NAME AS �ŷ�ó��,
                   SUM(C.PROD_COST*B.BUY_QTY) AS ���Աݾ��հ�
              FROM PROD C
            INNER JOIN BUYPROD B ON (B.BUY_PROD = C.PROD_ID AND 
                                     B.BUY_DATE BETWEEN TO_DATE('20200401') AND LAST_DAY('20200401'))
            INNER JOIN BUYER A ON (A.BUYER_ID = C.PROD_BUYER)
              GROUP BY A.BUYER_ID, A.BUYER_NAME
              ORDER BY 1;
              
    ��뿹) 2020�� 4�� �ŷ�ó�� ����ݾ��� ��ȸ�Ͻÿ�.
            Alias�� �ŷ�ó�ڵ�, �ŷ�ó��,����ݾ��հ�  
          (�Ϲ�����)
           SELECT A.BUYER_ID AS �ŷ�ó�ڵ�,
                   A.BUYER_NAME AS �ŷ�ó��,
                   SUM(C.PROD_PRICE*B.CART_QTY) AS ����ݾ��հ�
              FROM BUYER A, CART B, PROD C
             WHERE A.BUYER_ID = C.PROD_BUYER
               AND B.CART_PROD = C.PROD_ID
               AND B.CART_NO LIKE '202004%'
              GROUP BY A.BUYER_ID, A.BUYER_NAME
              ORDER BY 1; 
              
            (ANSI JOIN)
            SELECT A.BUYER_ID AS �ŷ�ó�ڵ�,
                   A.BUYER_NAME AS �ŷ�ó��,
                   SUM(C.PROD_PRICE*B.CART_QTY) AS ����ݾ��հ�
              FROM PROD C
        INNER JOIN BUYER A ON (A.BUYER_ID = C.PROD_BUYER) 
        INNER JOIN CART B ON (B.CART_PROD = C.PROD_ID AND
                   B.CART_NO LIKE '202004%')
              GROUP BY A.BUYER_ID, A.BUYER_NAME
              ORDER BY 1; 
    
    ��뿹) 2020�� 4�� �ŷ�ó�� ����/����ݾ��� ��ȸ�Ͻÿ�.
            Alias�� �ŷ�ó�ڵ�, �ŷ�ó��,���Աݾ��հ�,����ݾ��հ� 
            (�Ϲ�����)
            SELECT A.BUYER_ID AS �ŷ�ó�ڵ�,
                   A.BUYER_NAME AS �ŷ�ó��,
                   SUM(D.PROD_COST*B.BUY_QTY) AS ���Աݾ��հ�,
                   SUM(D.PROD_PRICE*C.CART_QTY) AS ����ݾ��հ�
              FROM BUYER A, BUYPROD B, CART C, PROD D
             WHERE A.BUYER_ID = D.PROD_BUYER
               AND B.BUY_PROD = D.PROD_ID
               AND C.CART_PROD = D.PROD_ID
               AND B.BUY_DATE BETWEEN TO_DATE('20200401') AND LAST_DAY('20200401')
               AND C.CART_NO LIKE '202004%'
          GROUP BY A.BUYER_ID, A.BUYER_NAME
          ORDER BY 1;                         
           
            (ANSI JOIN)
            SELECT A.BUYER_ID AS �ŷ�ó�ڵ�,
                   A.BUYER_NAME AS �ŷ�ó��,
                   SUM(D.PROD_COST*B.BUY_QTY) AS ���Աݾ��հ�,
                   SUM(D.PROD_PRICE*C.CART_QTY) AS ����ݾ��հ�
              FROM BUYER A
        INNER JOIN PROD D ON (A.BUYER_ID = D.PROD_BUYER)
        INNER JOIN BUYPROD B ON (B.BUY_PROD = D.PROD_ID AND
                                 B.BUY_DATE BETWEEN TO_DATE('20200401') AND LAST_DAY('20200401'))
        INNER JOIN CART C ON (C.CART_PROD = D.PROD_ID AND 
                              C.CART_NO LIKE '202004%')
          GROUP BY A.BUYER_ID, A.BUYER_NAME
          ORDER BY 1; 
          
          (�ذ�å : �������� + �ܺ�����)
         SELECT TB.CID AS �ŷ�ó�ڵ�,
                TB.CNAME AS �ŷ�ó��,
                NVL(TA.BSUM,0) AS ���Աݾ��հ�,
                NVL(TB.CSUM,0) AS ����ݾ��հ�    
        FROM (SELECT C.PROD_BUYER AS BID,   --��������
                   SUM(C.PROD_COST*B.BUY_QTY) AS BSUM
              FROM BUYER A, BUYPROD B, PROD C
             WHERE A.BUYER_ID = C.PROD_BUYER
               AND B.BUY_PROD = C.PROD_ID
               AND B.BUY_DATE BETWEEN TO_DATE('20200401') AND LAST_DAY('20200401')
              GROUP BY C.PROD_BUYER) TA,
            (SELECT A.BUYER_ID AS CID, --��������
                   A.BUYER_NAME AS CNAME,
                   SUM(C.PROD_PRICE*B.CART_QTY) AS CSUM
              FROM BUYER A, CART B, PROD C
             WHERE A.BUYER_ID = C.PROD_BUYER
               AND B.CART_PROD = C.PROD_ID
               AND B.CART_NO LIKE '202004%'
              GROUP BY A.BUYER_ID, A.BUYER_NAME) TB
       WHERE TA.BID(+) = TB.CID --�ܺ���������
    ORDER BY 1;
    
    ��뿹) ������̺��� ��ü����� ��ձ޿����� �� ���� �޿��� �޴� �����
           ��ȸ�Ͻÿ�.
           Alias�� �����ȣ, �����, �μ��ڵ�, �޿�
    SELECT A.EMPLOYEE_ID AS �����ȣ,
           A.EMP_NAME AS �����,
           A.DEPARTMENT_ID AS �μ��ڵ�,
           A.SALARY AS �޿�
      FROM HR.EMPLOYEES A,
           (SELECT AVG(SALARY) AS BSAL
              FROM HR.EMPLOYEES) B
     WHERE A.SALARY > B.BSAL       
    ORDER BY 3;
           
           
              