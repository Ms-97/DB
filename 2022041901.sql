2022-0419-01)�����Լ�
 - �ڷḦ �׷�ȭ�ϰ� �׷쳻���� �հ�, �ڷ��, ���, �ִ�, �ּ� ���� ���ϴ� �Լ�
 - SUM, AVG, COUNT, MAX, MIN�� ������
 - SELECT ���� �׷��Լ��� �Ϲ� �÷��� ���� ���Ȱ�� �ݵ�� GROUP BY ����
   ����Ǿ�� ��.
 (�������)
  SELECT [�÷���1,
        [�÷���2,...]]
         �����Լ�
    FROM ���̺��
  [WHERE ����]
  [GROUP BY �÷���1[, �÷���2,...]]
  [HAVING ����]
  [ORDER BY �ε���|�÷��� [ASC|DESC][,...]]
   . GROUP BY���� ���� �÷����� ���ʿ� ����� ������� ��з�, �Һз��� ���� �÷���
   . HAVING ���� : �����Լ��� ������ �ο��� ���
   
1. SUM(co1)
 - �� �׷쳻�� 'co1'�÷��� ����� ���� ��� ���Ͽ� ��ȯ
2. AVG(co1)
 - �� �׷쳻�� 'co1'�÷��� ����� ���� ����� ���Ͽ� ��ȯ
3. COUNT(*|co1)
 - �� �׷쳻�� ���� ���� ��ȯ
 - '*'�� ����ϸ� NULL���� �ϳ��� ������ ���
 - �÷����� ����ϸ� �ش� �÷��� ���� NULL�̾ƴ� ������ ��ȯ
4. MAX(col), MIN(col)
 - �� �׷쳻�� 'co1'�÷��� ����� �� �� �ִ밪�� �ּҰ��� ���Ͽ� ��ȯ
*** �����Լ��� �ٸ� �����Լ��� ������ �� ���� ***
 
��뿹) ������̺��� ��ü����� �޿��հ踦 ���Ͻÿ�.
��뿹) ������̺��� ��ü����� ��ձ޿��� ���Ͻÿ�.
    SELECT SUM(SALARY) AS �޿��հ�,
           ROUND(AVG(SALARY)) AS ��ձ޿�,
           MAX(SALARY) AS �ִ�޿�,
           MIN(SALARY) AS �ּұ޿�,
           COUNT(*) AS �����
      FROM HR.employees
      
    SELECT AVG(TO_NUMBER(SUBSTR(PROD_ID,2,3)))
      FROM PROD;

��뿹) ������̺��� �μ��� �޿��հ踦 ���Ͻÿ�.
��뿹) ������̺��� �μ��� ��ձ޿��� ���Ͻÿ�.
��뿹) ������̺��� �μ��� �ִ�޿����� ��ȸ�Ͻÿ�.
��뿹) ������̺��� �μ��� �ּұ޿����� ��ȸ�Ͻÿ�.
 SELECT DEPARTMENT_ID AS �μ��ڵ�,
        SUM(SALARY) AS �޿��հ�,
        ROUND(AVG(SALARY)) AS ��ձ޿�,
        MAX(SALARY) AS �ִ�޿�,
        MIN(SALARY) AS �ּұ޿�,
        COUNT(EMPLOYEE_ID) AS �����
   FROM HR.employees 
 GROUP BY DEPARTMENT_ID
 ORDER BY 1;

��뿹) ������̺��� �μ��� ��ձ޿��� 6000�̻��� �μ��� ��ȸ�Ͻÿ�.
    
    SELECT DEPARTMENT_ID AS �μ��ڵ�,
           ROUND(AVG(SALARY)) AS ��ձ޿�
      FROM HR.employees
     GROUP BY DEPARTMENT_ID
     HAVING AVG(SALARY)>=6000  -- WHERE�� ���� ����
     ORDER BY 2 DESC;

��뿹) ��ٱ������̺��� 2020�� 5�� ȸ���� ���ż����հ踦 ��ȸ�Ͻÿ�
    SELECT CART_MEMBER AS ȸ����ȣ,
           SUM(CART_QTY) AS ���ż����հ�
      FROM CART
     WHERE CART_NO LIKE '202005%'
  GROUP BY CART_MEMBER
  ORDER BY 2 DESC;
  
��뿹) �������̺�(buyprod)���� 2020�� ��ݱ�(1��~6��) ����, ��ǰ�� �������踦
        ��ȸ�Ͻÿ�.
    SELECT  EXTRACT(MONTH FROM BUY_DATE) AS ��,
            BUY_PROD AS ��ǰ�ڵ�,
            SUM(BUY_QTY) AS �����հ�,
            SUM(BUY_QTY*BUY_COST) AS ���Աݾ��հ�
     FROM BUYPROD
    WHERE  BUY_DATE BETWEEN TO_DATE('20200101') AND TO_DATE('20200630')
    GROUP BY  EXTRACT(MONTH FROM BUY_DATE), BUY_PROD
    ORDER BY 1,2; 
    
��뿹) �������̺�(buyprod)���� 2020�� ��ݱ�(1��~6��) ����, �������踦 ��ȸ�ϵ� 
        ���Աݾ��� 10000���� �̻��� ���� ��ȸ�Ͻÿ�.
      
    SELECT  EXTRACT(MONTH FROM BUY_DATE) AS ��,
            BUY_PROD AS ��ǰ�ڵ�,
            SUM(BUY_QTY) AS �����հ�,
            SUM(BUY_QTY*BUY_COST) AS ���Աݾ��հ�
     FROM BUYPROD
    WHERE  BUY_DATE BETWEEN TO_DATE('20200101') AND TO_DATE('20200630')
    GROUP BY  EXTRACT(MONTH FROM BUY_DATE), BUY_PROD
    ORDER BY 1,2;    

��뿹) �������̺�(buyprod)���� 2020�� ��ݱ�(1��~6��) ����, �������踦 ��ȸ�ϵ� 
        �ݾ� ���� ���� 5�� ��ǰ�� ��ȸ�Ͻÿ�.
   SELECT  A.BID AS ��ǰ�ڵ�,
           A.QSUM AS �����հ�,
           A.CSUM AS �ݾ��հ�
     FROM (SELECT BUY_PROD AS BID,
                  SUM(BUY_QTY) AS QSUM,
                  SUM(BUY_QTY * BUY_COST) AS CSUM
             FROM BUYPROD
            WHERE  BUY_DATE BETWEEN TO_DATE('20200101') AND TO_DATE('20200630')
            GROUP BY BUY_PROD
            ORDER BY 3 DESC) A
    WHERE ROWNUM<=5; 
        
��뿹) ȸ�����̺��� ���� ��� ���ϸ����� ��ȸ�Ͻÿ�.
        SELECT CASE WHEN SUBSTR(MEM_REGNO2,1,1)='1' OR SUBSTR(MEM_REGNO2,1,1)='3' THEN '����'
                ELSE '����'END AS ����, 
                ROUND(AVG(MEM_MILEAGE)) AS ��ո��ϸ���    
          FROM MEMBER
       GROUP BY CASE WHEN SUBSTR(MEM_REGNO2,1,1)='1' OR SUBSTR(MEM_REGNO2,1,1)='3' THEN '����'
               ELSE '����' END;

��뿹) ȸ�����̺��� ���ɴ뺰 ��� ���ϸ����� ��ȸ�Ͻÿ�. 
         SELECT TRUNC(EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM MEM_BIR),-1) AS ���ɴ�, 
                ROUND(AVG(MEM_MILEAGE)) AS ��ո��ϸ���    
          FROM MEMBER
       GROUP BY TRUNC(EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM MEM_BIR),-1)
       ORDER BY 1;

��뿹) ȸ�����̺��� �������� ��� ���ϸ����� ��ȸ�Ͻÿ�. 

         SELECT SUBSTR(MEM_ADD1,1,2) AS ������, 
                ROUND(AVG(MEM_MILEAGE)) AS ��ո��ϸ���    
          FROM MEMBER
       GROUP BY SUBSTR(MEM_ADD1,1,2)
       ORDER BY 1;

