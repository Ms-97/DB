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
        WHERE A.PROD_BUYER = C.BUYER_ID
          AND A.PROD_ID = B.CART_PROD
          AND TO_DATE(SUBSTR(B.CART_NO,1,8),'YYMMDD') BETWEEN TO_DATE('20200101') AND TO_DATE('20200630')
          GROUP BY  A.PROD_BUYER,C.BUYER_NAME
          ORDER BY 3 DESC;
          
          (ANSI JOIN)
          SELECT A.PROD_BUYER AS �ŷ�ó�ڵ�,
              C.BUYER_NAME AS �ŷ�ó��,
              SUM(A.PROD_PRICE * B.CART_QTY) AS �Ǹž��հ�
         FROM PROD A
    INNER JOIN CART B ON (A.PROD_ID = B.CART_PROD)
    INNER JOIN BUYER C ON (A.PROD_BUYER = C.BUYER_ID)
          AND TO_DATE(SUBSTR(B.CART_NO,1,8),'YYMMDD') BETWEEN TO_DATE('20200101') AND TO_DATE('20200630')
          GROUP BY  A.PROD_BUYER,C.BUYER_NAME
          ORDER BY 3 DESC;
        
          