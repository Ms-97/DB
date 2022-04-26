2022-0425-02)�ܺ�����(OUTER JOIN)
 - �ڷ��� ������ ���� ���̺��� �������� �����ϴ� ����
 - �ڷᰡ ������ ���̺� NULL ���� �߰��Ͽ� ���� ����
 - �ܺ����� ������'(+)'�� �ڷᰡ �����ʿ� �߰�
 - �������� �� �ܺ������� �ʿ��� ��� ���ǿ� '(+)'�� ����ؾ���
 - ���ÿ� �� ���̺��� �ٸ� �� ���� ���̺�� �ܺ����ε� �� ����. ��, A,B,C
   ���̺��� �ܺ����ο� �����ϰ� A�� �������� B�� Ȯ��Ǿ� ���εǰ�, ���ÿ� 
   C�� �������� B�� Ȯ��Ǵ� �ܺ������� ���ȵ�(A=B(+) AND C=B(+))
 - �Ϲ����ǰ� �ܺ����������� ���ÿ� �����ϴ� �ܺ������� �������ΰ����
   ��ȯ��=>ANSI�ܺ������̳� ���������� �ذ�
   
   (�Ϲݿܺ����� �������)
   SELECT �÷�list
     FROM ���̺��1 [��Ī1], ���̺��2 [��Ī2][,...]
    WHERE ��������(+);
             :
    
  (ANSI�ܺ����� �������)
   SELECT �÷�list
     FROM ���̺��1 [��Ī1]    
    LEFT|RIGHT|FULL OUTER JOIN ���̺��2[��Ī2] ON(�������� [AND �Ϲ�����])
           :
    [WHERE �Ϲ�����];
    . LEFT : FROM���� ����� ���̺��� �ڷ��� ������ JOIN���� ���̺��� �ڷẸ�� ���� ���
    . RIGHT : FROM���� ����� ���̺��� �ڷ��� ������ JOIN���� ���̺��� �ڷẸ�� ���� ���
    . FULL : FROM���� ����� ���̺�� JOIN���� ���̺��� �ڷᰡ ���� ������ ���.
    
 ��뿹) ��ǰ���̺��� ��� �з��� ��ǰ�� ���� ��ȸ�Ͻÿ�
  SELECT LPROD_GU AS �з��ڵ�,
         COUNT(PROD_ID) AS "��ǰ�� ��" --
    FROM LPROD A, PROD B
   WHERE A.LPROD_GU = B.PROD_LGU(+)
   GROUP BY LPROD_GU
   ORDER BY 1;
    
   SELECT DISTINCT PROD_LGU
   FROM PROD;
   
  ��뿹)������̺��� ��� �μ��� ������� ��ձ޿��� ��ȸ�Ͻÿ�.
         ��, ��ձ޿��� ������ ����Ұ�.
  (�Ϲ� OUTER)       
  SELECT B.DEPARTMENT_ID AS �μ��ڵ�,
         B.DEPARTMENT_NAME AS �μ���,
         COUNT(A.EMPLOYEE_ID) AS �����, --�뵵�� �⺻Ű���
         ROUND(AVG(A.SALARY)) AS ��ձ޿�
    FROM HR.EMPLOYEES A, HR.DEPARTMENTS B
   WHERE A.DEPARTMENT_ID = B.DEPARTMENT_ID(+)
  -- AND WHERE A.DEPARTMENT_ID(+) = B.DEPARTMENT_ID
  GROUP BY B.DEPARTMENT_ID, B.DEPARTMENT_NAME
  ORDER BY 1;
  
  (ANSI JOIN)
  SELECT B.DEPARTMENT_ID AS �μ��ڵ�,
         B.DEPARTMENT_NAME AS �μ���,
         COUNT(A.EMPLOYEE_ID) AS �����, --�뵵�� �⺻Ű���
         ROUND(AVG(A.SALARY)) AS ��ձ޿�
    FROM HR.EMPLOYEES A
    FULL OUTER JOIN HR.DEPARTMENTS B ON(A.DEPARTMENT_ID = B.DEPARTMENT_ID)
    GROUP BY B.DEPARTMENT_ID, B.DEPARTMENT_NAME
    ORDER BY 1;
    
   ��뿹)��ٱ������̺��� 2020�� 6�� ��� ȸ���� �����հ踦 ���Ͻÿ�.
   (�Ϲ� OUTER)
   SELECT C.MEM_ID AS ȸ����ȣ,
          C.MEM_NAME AS ȸ����,
          SUM(A.CART_QTY * B.PROD_PRICE) AS �����հ�
     FROM CART A, PROD B, MEMBER C
    WHERE A.CART_PROD = B.PROD_ID
      AND C.MEM_ID = A.CART_MEMBER(+) --�������ʿ� (+)
      AND A.CART_NO LIKE '202006%'
    GROUP BY C.MEM_ID, C.MEM_NAME;
   
    (ANSI JOIN)
   SELECT C.MEM_ID AS ȸ����ȣ,
          C.MEM_NAME AS ȸ����,
          NVL(SUM(A.CART_QTY * B.PROD_PRICE),0) AS �����հ�
     FROM CART A 
    RIGHT OUTER JOIN MEMBER C ON (A.CART_MEMBER = C.MEM_ID)
    LEFT OUTER JOIN PROD B ON (B.PROD_ID = A.CART_PROD)
    WHERE A.CART_NO LIKE '202006%'
    GROUP BY C.MEM_ID, C.MEM_NAME
    ORDER BY 1;
    
 (��������)
   �������� : 2020�� 6�� ȸ���� �Ǹ����� --��������
    SELECT A.CART_MEMBER AS AID,
           SUM(A.CART_QTY * B.PROD_PRICE) AS ASUM
      FROM CART A, PROD B
     WHERE A.CART_PROD = B.PROD_ID
       AND A.CART_NO LIKE '202006%'
      GROUP BY A.CART_MEMBER;
     
   �������� : ������������� MEMBER ���̿� �ܺ�����
    SELECT TB.MEM_ID AS ȸ����ȣ,
           TB.MEM_NAME AS ȸ����,
           NVL(TA.ASUM,0) AS �����հ�
      FROM (SELECT A.CART_MEMBER AS AID,
                    SUM(A.CART_QTY * B.PROD_PRICE) AS ASUM
              FROM CART A, PROD B
             WHERE A.CART_PROD = B.PROD_ID
               AND A.CART_NO LIKE '202006%'
             GROUP BY A.CART_MEMBER) TA,
            MEMBER TB
     WHERE TA.AID(+)= TB.MEM_ID
    ORDER BY 1; 
    
    (ANSI �ܺ�JOIN)
    SELECT TB.MEM_ID AS ȸ����ȣ,
           TB.MEM_NAME AS ȸ����,
           NVL(TA.ASUM,0) AS �����հ�
      FROM (SELECT A.CART_MEMBER AS AID,
                    SUM(A.CART_QTY * B.PROD_PRICE) AS ASUM
              FROM CART A, PROD B
             WHERE A.CART_PROD = B.PROD_ID
               AND A.CART_NO LIKE '202006%'
             GROUP BY A.CART_MEMBER) TA
       RIGHT OUTER JOIN MEMBER TB ON(TA.AID=TB.MEM_ID)      
    ORDER BY 1; 
   