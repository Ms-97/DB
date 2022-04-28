2022-0427-01)��������
    - SQL�� �ȿ� �����ϴ� �� �ٸ� SQL��
    - SQL���� �ȿ� ������ ���Ǵ� �߰� ����� ��ȯ�ϴ� SQL��
    - �˷����� ���� ���ǿ� �ٰ��� ������ �˻��ϴ� SELECT���� ���
    - ���������� �˻���(SELECT)�Ӿƴ϶� DML(INSERT,UPDATE,DELETE)�������� ����
    - ���������� '( )'�ȿ� ����Ǿ�� ��(��, INSERT���� ����ϴ� SUBQUERY�� ����)
    - ���������� �ݵ�� ������ �����ʿ� ����ؾ���
    - ���� ��� ��ȯ ��������(������ ������:>,<,>=,<=,=,!=)
      VS ���� ��� ��ȯ ��������(������ ������:IN ALL, ANY, SOME, EXISTS)
    - ������ �ִ� �������� VS ������ ���� ��������
    - �Ϲݼ������� VS in-line �������� VS ��ø��������
 
 1. ������ ���� ��������
   - ���������� ���̺�� ���������� ���̺��� �������� ������� ���� ���

��뿹)������̺��� ������� ��ձ޿����� ���� �޿��� �޴� ����� ��ȸ �Ͻÿ�.
     Alias�� �����ȣ, �����, �μ���, �޿�
 (�������� :������� �����ȣ, �����, �μ���, �޿��� ��ȸ )    
    SELECT A.EMPLOYEE_ID AS �����ȣ, 
           A.EMP_NAME AS �����,
           B.DEPARTMENT_ID AS �μ���,
           A.SALARY AS �޿�
      FROM HR.EMPLOYEES A, HR.DEPARTMENTS B
     WHERE A.DEPARTMENT_ID = B.DEPARTMENT_ID
       AND A.SALARY >(��ձ޿�);
       
 (�������� :��ձ޿� )    
    SELECT AVG(SALARY)
      FROM HR.EMPLOYEES
      
 (����) 
  SELECT A.EMPLOYEE_ID AS �����ȣ, 
           A.EMP_NAME AS �����,
           B.DEPARTMENT_ID AS �μ���,
           A.SALARY AS �޿�
      FROM HR.EMPLOYEES A, HR.DEPARTMENTS B
     WHERE A.DEPARTMENT_ID = B.DEPARTMENT_ID
       AND A.SALARY>(SELECT AVG(SALARY)
                       FROM HR.EMPLOYEES);

 (��ձ޿� ���)
   SELECT A.EMPLOYEE_ID AS �����ȣ, 
           A.EMP_NAME AS �����,
           B.DEPARTMENT_ID AS �μ���,
           A.SALARY AS �޿�,
           (SELECT ROUND(AVG(SALARY))
              FROM HR.EMPLOYEES) AS ��ձ޿�
      FROM HR.EMPLOYEES A, HR.DEPARTMENTS B
     WHERE A.DEPARTMENT_ID = B.DEPARTMENT_ID
       AND A.SALARY>(SELECT AVG(SALARY)
                       FROM HR.EMPLOYEES); 
 
 (in-line view ��������)
    SELECT A.EMPLOYEE_ID AS �����ȣ, 
           A.EMP_NAME AS �����,
           B.DEPARTMENT_ID AS �μ���,
           A.SALARY AS �޿�,
           ROUND(C.ASAL) AS ��ձ޿�
      FROM HR.EMPLOYEES A, HR.DEPARTMENTS B,
           (SELECT AVG(SALARY) AS ASAL
                       FROM HR.EMPLOYEES) C
     WHERE A.DEPARTMENT_ID = B.DEPARTMENT_ID
       AND A.SALARY>C.ASAL; 

2. ������ �ִ� ��������
   - ���������� ���������� �������� ����� ���
   - ��κ��� ��������
   
 ��뿹)�����������̺�(JOB_HISTORY)�� �μ����̺��� �μ���ȣ�� ���� �ڷḦ
        ��ȸ�Ͻÿ�.
        Alias�� �μ���ȣ,�μ��� �̴�
  (IN ������ �̿�)      
        SELECT A.DEPARTMENT_ID AS �μ���ȣ,
               A.DEPARTMENT_NAME AS �μ���
          FROM HR.departments A
         WHERE A.DEPARTMENT_ID IN(SELECT DEPARTMENT_ID
                                  FROM HR.JOB_HISTORY);
                                 
  (EXISTS ������ �̿�)      
        SELECT A.DEPARTMENT_ID AS �μ���ȣ,
               A.DEPARTMENT_NAME AS �μ���
          FROM HR.departments A
         WHERE EXISTS (SELECT 1 
                         FROM HR.JOB_HISTORY B
                        WHERE B.DEPARTMENT_ID=A.DEPARTMENT_ID);
  
 ��뿹)2020�� 5�� �Ǹŵ� ��ǰ�� �Ǹ����� �� �ݾױ��� ���� 3�� ��ǰ �Ǹ����������� 
       ��ȸ�Ͻÿ�.
       Alias�� ��ǰ�ڵ�, ��ǰ��, �ŷ�ó��, �Ǹűݾ��հ�
       
 (��������: �ݾױ��� ���� 3�� ��ǰ�� ���� ��ǰ�ڵ�, ��ǰ��, �ŷ�ó��, �Ǹűݾ��հ�)  
     SELECT ��ǰ�ڵ�,��ǰ��,�ŷ�ó��,�Ǹűݾ��հ�
       FROM PROD A, BUYER B
      WHERE A.PROD_ID = (���� 3���� ��ǰ�ڵ�) 
        AND A.PROD_BUYER = B.BUYER_ID
        
 (��������: �Ǹűݾױ������� �Ǹ����� ����)
     SELECT A.CART_PROD AS CID,
            B.PROD_NAME AS CNAME,
            SUM(A.CART_QTY*PROD_PRICE) AS CSUM
       FROM CART A, PROD B
      WHERE A.CART_PROD = B.PROD_ID
        AND A.CART_NO LIKE '202005%'
       GROUP BY A.CART_PROD, B.PROD_NAME
       ORDER BY 3 DESC;
       
  (����)    
      SELECT C.CID AS ��ǰ�ڵ�,
             C.CNAME AS ��ǰ��,
             B.BUYER_NAME AS �ŷ�ó��,
             C.CSUM AS �Ǹűݾ��հ�
       FROM PROD A, BUYER B,
            (SELECT A.CART_PROD AS CID,
                    B.PROD_NAME AS CNAME,
                    SUM(A.CART_QTY*PROD_PRICE) AS CSUM
               FROM CART A, PROD B
              WHERE A.CART_PROD = B.PROD_ID
                AND A.CART_NO LIKE '202005%'
            GROUP BY A.CART_PROD, B.PROD_NAME
            ORDER BY 3 DESC) C 
      WHERE A.PROD_ID = C.CID
        AND A.PROD_BUYER = B.BUYER_ID   
        AND ROWNUM <=3;
       
 ��뿹)2020�� ��ݱ⿡ ���žױ��� 1000���� �̻��� ������ ȸ�������� 
       ��ȸ�Ͻÿ�.
       Alias�� ȸ����ȣ,ȸ����,����, ���ž�, ���ϸ���
       (�������� : ȸ������(ȸ����ȣ,ȸ����,����, ���ž�, ���ϸ���) ��ȸ)
                  ����: 2020�� ��ݱ⿡ ���žױ��� 1000���� �̻�(��������)
       SELECT A.MEM_ID AS ȸ����ȣ,
              A.MEM_NAME AS ȸ����,
              A.MEM_JOB AS ����,
              ���ž�,
              A.MEM_MILEAGE AS ���ϸ���
         FROM MEMBER A,
              (1000���� �̻��� ������ ȸ��) B
        WHERE A.MEM_ID = B.ȸ����ȣ;
     
    (��������: 2020�� ��ݱ� ���žױ��� 1000���� �̻�) 
     SELECT A.CART_MEMBER AS BID,
                     SUM(A.CART_QTY*B.PROD_PRICE) AS BSUM 
                FROM CART A, PROD B
               WHERE A.CART_PROD = B.PROD_ID
                 AND SUBSTR(A.CART_NO,1,6) BETWEEN '202001' AND '202006'
               GROUP BY A.CART_MEMBER
              HAVING SUM(A.CART_QTY*B.PROD_PRICE) >= 10000000
     
     (����-INLINE VIEW ���)
      SELECT A.MEM_ID AS ȸ����ȣ,
             A.MEM_NAME AS ȸ����,
             A.MEM_JOB AS ����,
             B.BSUM AS ���ž�,
             A.MEM_MILEAGE AS ���ϸ���
        FROM  MEMBER A,
             (SELECT A.CART_MEMBER AS BID,
                     SUM(A.CART_QTY*B.PROD_PRICE) AS BSUM 
                FROM CART A, PROD B
               WHERE A.CART_PROD = B.PROD_ID
                 AND SUBSTR(A.CART_NO,1,6) BETWEEN '202001' AND '202006'
               GROUP BY A.CART_MEMBER
               HAVING SUM(A.CART_QTY*B.PROD_PRICE) >= 10000000) B
       WHERE A.MEM_ID = B.BID
       ORDER BY 4 DESC;

     (����-��ø��������) 
     SELECT A.MEM_ID AS ȸ����ȣ,
             A.MEM_NAME AS ȸ����,
             A.MEM_JOB AS ����,
        --     B.BSUM AS ���ž�,
             A.MEM_MILEAGE AS ���ϸ���
        FROM  MEMBER A
       WHERE A.MEM_ID IN (SELECT B.BID
                          FROM(SELECT A.CART_MEMBER AS BID,
                                      SUM(A.CART_QTY*B.PROD_PRICE)
                                 FROM CART A, PROD B
                                WHERE A.CART_PROD = B.PROD_ID
                                  AND SUBSTR(A.CART_NO,1,6) BETWEEN '202001' AND '202006'
                               GROUP BY A.CART_MEMBER
                               HAVING SUM(A.CART_QTY*B.PROD_PRICE) >= 10000000) B)
                             
       
       
      