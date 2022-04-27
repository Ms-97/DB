2022-0426-01)���տ�����
 - SQL������ ����� ������ ����(set)�̶�� ��
 - �̷� ���յ� ������ ������ �����ϱ� ���� �����ڸ� ���տ����ڶ� ��
 - UNION, UNION ALL, INTERSECT, MINUS�� ����
 - ���տ����ڷ� ����Ǵ� �� SELECT���� SELECT���� �÷��� ����, ����, Ÿ����
   ��ġ�ؾ���
 - ORDER BY���� �� ������ SELECT������ ��� ����
 - ����� ù ��° SELECT���� SELECT���� �����̵�
 
 (�������)
  SELECT �÷�LIST
    FROM ���̺��
   [WHERE ����]
  UNION|UNION ALL|INTERSECT|MINUS
   SELECT �÷�LIST
     FROM ���̺��
   [WHERE ����]
        :
  UNION|UNION ALL|INTERSECT|MINUS
   SELECT �÷�LIST
     FROM ���̺��
   [WHERE ����]
   [ORDER BY �÷���|�÷�idex [ASC|DESC],...];
   
1. UNION
 - �ߺ��� ������� ���� �������� ����� ��ȯ
 - �� SELECT���� ����� ��� ����
 
 ��뿹)ȸ�����̺��� 20�� ����ȸ���� �泲����ȸ���� ȸ����ȣ,ȸ����,����,
       ���ϸ����� ��ȸ�Ͻÿ�.
    SELECT MEM_ID AS ȸ����ȣ,
           MEM_NAME AS ȸ����,
           MEM_JOB AS ����,
           MEM_MILEAGE AS ���ϸ���
      FROM MEMBER
     WHERE (EXTRACT(YEAR FROM SYSDATE)-EXTRACT(YEAR FROM MEM_BIR)) 
            BETWEEN 20 AND 29
       AND  SUBSTR(MEM_REGNO2,1,1) IN('2','4')  
UNION        
     SELECT MEM_ID AS ȸ����ȣ,
           MEM_NAME AS ȸ����,
           MEM_JOB AS ����,
           MEM_MILEAGE AS ���ϸ���
      FROM MEMBER
     WHERE MEM_ADD1 LIKE '�泲%'  
    ORDER BY 1; 

2. INTERSECT
 - ������(����κ�)�� ��� ��ȯ
 
��뿹)ȸ�����̺��� 20�� ����ȸ���� �泲����ȸ�� �� ���ϸ����� 2000�̻���
      ȸ���� ȸ����ȣ,ȸ����,����,���ϸ����� ��ȸ�Ͻÿ�.
    
     SELECT MEM_ID AS ȸ����ȣ,
           MEM_NAME AS ȸ����,
           MEM_JOB AS ����,
           MEM_MILEAGE AS ���ϸ���
      FROM MEMBER
     WHERE (EXTRACT(YEAR FROM SYSDATE)-EXTRACT(YEAR FROM MEM_BIR)) 
            BETWEEN 20 AND 29
       AND  SUBSTR(MEM_REGNO2,1,1) IN('2','4')  
UNION        
     SELECT MEM_ID AS ȸ����ȣ,
           MEM_NAME AS ȸ����,
           MEM_JOB AS ����,
           MEM_MILEAGE AS ���ϸ���
      FROM MEMBER
     WHERE MEM_ADD1 LIKE '�泲%'  
INTERSECT
     SELECT MEM_ID AS ȸ����ȣ,
           MEM_NAME AS ȸ����,
           MEM_JOB AS ����,
           MEM_MILEAGE AS ���ϸ���
      FROM MEMBER
     WHERE MEM_MILEAGE>=2000  
    ORDER BY 1;   

3. UNION ALL
 - �ߺ��� ����Ͽ� �������� ����� ��ȯ
 - �� SELECT���� ����� ��� ����(�ߺ� ����)
 
��뿹)
   1) DEPTS���̺��� PARENT_ID�� NULL�� �ڷ��� �μ��ڵ�,�μ���,�����μ��ڵ�,
      ������ ��ȸ�Ͻÿ�
      ��,�����μ��ڵ� �� 0�̰� ������ 1�̴�
  SELECT DEPARTMENT_ID,
         DEPARTMENT_NAME,
         0 AS PARENT_ID,
         1 AS LEVELS
    FROM HR.DEPTS
   WHERE PARENT_ID IS NULL; 

   2) DEPTS���̺��� NULL�� �����μ��ڵ��� �μ��ڵ�� ����μ��ڵ�� ����
      �μ��� �μ��ڵ�,�μ���, �����μ��ڵ�,������ ��ȸ�Ͻÿ�.
      ��, ������ 2�̰� �μ����� ���ʿ� 4ĭ�� ������ ���� �� �μ��� ���
  SELECT B.DEPARTMENT_ID,
         LPAD(' ',4*(2-1))||B.DEPARTMENT_NAME AS DEPARTMENT_NAME,
         B.PARENT_ID AS PARENT_ID,
         2 AS LEVELS
    FROM HR.DEPTS A, HR.DEPTS B
   WHERE A.PARENT_ID IS NULL
     AND B.PARENT_ID= A.DEPARTMENT_ID; 
     
(����)
    SELECT DEPARTMENT_ID,
         DEPARTMENT_NAME,
         NVL(PARENT_ID,0) AS PARENT_ID,
         1 AS LEVELS,
         PARENT_ID||DEPARTMENT_ID AS TEMP
     FROM HR.DEPTS
    WHERE PARENT_ID IS NULL 
 UNION ALL
   SELECT B.DEPARTMENT_ID,
         LPAD(' ',4*(2-1))||B.DEPARTMENT_NAME AS DEPARTMENT_NAME, --�ѹ���ȹ��(1) ������ (2) �ѹ���ȹ�� 4*(1-1)=0 
         B.PARENT_ID AS PARENT_ID,
         2 AS LEVELS,
          B.PARENT_ID||B.DEPARTMENT_ID AS TEMP
    FROM HR.DEPTS A, HR.DEPTS B --��������
   WHERE A.PARENT_ID IS NULL
     AND B.PARENT_ID= A.DEPARTMENT_ID
 UNION ALL
   SELECT C.DEPARTMENT_ID,
         LPAD(' ',4*(3-1))||C.DEPARTMENT_NAME AS DEPARTMENT_NAME,  
         C.PARENT_ID AS PARENT_ID,
         3 AS LEVELS,
          B.PARENT_ID||C.PARENT_ID ||C.DEPARTMENT_ID AS TEMP
    FROM HR.DEPTS A, HR.DEPTS B, HR.DEPTS C
   WHERE A.PARENT_ID IS NULL
     AND B.PARENT_ID= A.DEPARTMENT_ID
     AND C.PARENT_ID= B.DEPARTMENT_ID
     ORDER BY 5;
   
��뿹) ��ٱ������̺��� 4���� 6���� �Ǹŵ� ��� ��ǰ������ �ߺ����� �ʰ� ��ȸ�Ͻÿ�
       Alias�� ��ǰ��ȣ,��ǰ��,�Ǹż��� �̸� ��ǰ��ȣ ������ ����Ͻÿ�.
       
       SELECT A.PROD_ID AS ��ǰ��ȣ,
              A.PROD_NAME AS ��ǰ��,
              SUM(B.CART_QTY) AS �Ǹż���
         FROM PROD A, CART B
        WHERE B.CART_PROD = A.PROD_ID 
          AND SUBSTR(B.CART_NO,1,8) LIKE '202004%'
        GROUP BY A.PROD_ID, A.PROD_NAME
UNION
        SELECT A.PROD_ID AS ��ǰ��ȣ,
              A.PROD_NAME AS ��ǰ��,
              SUM(B.CART_QTY) AS �Ǹż���
         FROM PROD A, CART B
        WHERE B.CART_PROD = A.PROD_ID 
          AND SUBSTR(B.CART_NO,1,8) LIKE '202006%'
        GROUP BY A.PROD_ID, A.PROD_NAME
        ORDER BY 1;

��뿹) ��ٱ������̺��� 4������ �Ǹŵǰ� 6������ �Ǹŵ� ��ǰ������ ��ȸ�Ͻÿ�
       Alias�� ��ǰ��ȣ,��ǰ���̸� ��ǰ��ȣ ������ ����Ͻÿ�.
        
        SELECT A.PROD_ID AS ��ǰ��ȣ,
              A.PROD_NAME AS ��ǰ��
         FROM PROD A, CART B
        WHERE B.CART_PROD = A.PROD_ID 
          AND SUBSTR(B.CART_NO,1,8) LIKE '202004%'
INTERSECT
        SELECT A.PROD_ID AS ��ǰ��ȣ,
              A.PROD_NAME AS ��ǰ��
         FROM PROD A, CART B
        WHERE B.CART_PROD = A.PROD_ID 
          AND SUBSTR(B.CART_NO,1,8) LIKE '202006%'
        ORDER BY 1;
       
 
��뿹) ��ٱ������̺��� 4���� 6������ �Ǹŵ� ��ǰ �� 6������ �Ǹŵ� ��ǰ������
       ��ȸ�Ͻÿ�
       Alias�� ��ǰ��ȣ,��ǰ��,�Ǹż��� �̸� ��ǰ��ȣ ������ ����Ͻÿ�.
        
        SELECT A.PROD_ID AS ��ǰ��ȣ,
              A.PROD_NAME AS ��ǰ��,
              SUM(B.CART_QTY) AS �Ǹż���
         FROM PROD A, CART B
        WHERE B.CART_PROD = A.PROD_ID 
          AND SUBSTR(B.CART_NO,1,8) LIKE '202004%'
        GROUP BY A.PROD_ID, A.PROD_NAME
UNION
        SELECT A.PROD_ID AS ��ǰ��ȣ,
              A.PROD_NAME AS ��ǰ��,
              SUM(B.CART_QTY) AS �Ǹż���
         FROM PROD A, CART B
        WHERE B.CART_PROD = A.PROD_ID 
          AND SUBSTR(B.CART_NO,1,8) LIKE '202006%'
        GROUP BY A.PROD_ID, A.PROD_NAME
MINUS
        SELECT A.PROD_ID AS ��ǰ��ȣ,
              A.PROD_NAME AS ��ǰ��,
              SUM(B.CART_QTY) AS �Ǹż���
         FROM PROD A, CART B
        WHERE B.CART_PROD = A.PROD_ID 
          AND SUBSTR(B.CART_NO,1,8) LIKE '202004%'
        GROUP BY A.PROD_ID, A.PROD_NAME
        ORDER BY 1;