2022-0415-01)�����Լ�
 1. �������Լ� 
  - ABS, SIGN, POWER, SQRT���� ������
  1)ABS(n), SIGN(n), SQRT(n), POWER(e, n)
  . ABS(n): �־��� �� n�� ���밪
  . SIGN(n): �־��� �� n�� ����̸� 1, �����̸� -1, 0�̸� 0�� ��ȯ
  . SQRT(n): �־��� �� n�� ����(������) ��ȯ 
  . POWER(e, n): e�� n��(e�� n�� �ŵ� ���� ��)
  
 (��뿹)
  SELECT ABS(2000),ABS(0.0009),ABS(0),  -- 2000, 0.0009, 0
         SIGN(-2000),SIGN(0.0001),SIGN(0), -- -1, 1, 0 
         SQRT(16),SQRT(87.99),             -- 4
         POWER(2,10)                       -- 1024
    FROM DUAL;    
 
   2)GREATEST(n1,...nn), LEAST(n1,...nn)
   . GREATEST(n1,...nn) : �־��� �� n1 ~nn �� ���� ū �� ��ȯ 
   . LEAST(n1,...nn) : �־��� �� n1 ~nn �� ���� ���� �� ��ȯ 
   
��뿹)
    SELECT GREATEST('ȫ�浿','�̼���','ȫ���'),
           GREATEST('APPLE','AMOLD',100), -- Ⱦ���� ���õ� �������� ���� ���� ū���� ���Ҷ� ��� ������ MAX 
                     -- �ƽ�Ű�ڵ�� ��ȯ�� �� �׷��� APPLE�� ���� ū��
           LEAST('APPLE','AMOLD',100)  -- Ⱦ���� ���õ� �������� ���� ���� ���� ���� ���Ҷ� ��� ������ MIN 
      FROM DUAL;
      
��뿹)ȸ�����̺��� ���ϸ����� ��ȸ�Ͽ� 1000���� ���� ���̸� 1000�� �ο��ϰ�
      1000���� ũ�� ������ ���� ����Ͻÿ�.
      Alias�� ȸ����ȣ, ȸ����, �������ϸ���, ���渶�ϸ��� 
      
      SELECT MEM_ID AS ȸ����ȣ,
             MEM_NAME AS ȸ����,
             MEM_MILEAGE AS �������ϸ���,
             GREATEST(MEM_MILEAGE,1000) AS ���渶�ϸ��� --���� ���ϸ����� 1000�� ���ϸ������� 1000���� ũ�� �������ϸ����� ������ 1000 ��ȯ
        FROM MEMBER;    
      
   3)ROUND(n, l), TRUNC(n, l)
   . ROUND�� �ݿø�, TRUNC�� �ڸ������� ����
   . 1�� ����̸�
     - ROUND(n, l) : �־����� n���� �Ҽ��� ���� l+1�ڸ����� �ݿø��Ͽ� l�ڸ����� ��ȯ  -- ROUND(102.846,2) -> 102.85
                     l�� �����ǰų� 0�̸� �Ҽ� ù��° �ڸ����� �ݿø��Ͽ� ���� ��ȯ
     - TRUNC(n, l) : �־����� n���� �Ҽ��� ���� l+1�ڸ����� �ڸ�����                 --  TRUNC(102.846,2) -> 102.84
    . 1�� �����̸�
      - ROUND(n, l) : �־����� n���� �����ι� l�ڸ����� �ݿø��Ͽ� ��� ��ȯ          
      - TRUNC(n, l) : �־����� n���� �����ι� l�ڸ����� �ڸ�����                     

 ��뿹)ȸ�����̺��� ���ɴ뺰 ���ϸ����հ�� ȸ������ ���Ͻÿ�
       Alias�� ���ɴ�,ȸ����,���ϸ����հ�
 (1)���̰��
    SELECT  CASE WHEN SUBSTR(MEM_REGNO2,1,1) IN ('1','2') THEN -- ���ڸ��� 1Ȥ�� 2�̸�
                      EXTRACT(YEAR FROM SYSDATE)-    -- ��ǻ�� �⵵�� �����ͼ�
                      (1900+TO_NUMBER(SUBSTR(MEM_REGNO1,1,2))) -- MEM_REGNO1�� ���ڸ� 2�ڸ��� ������ 1900 ����
                  ELSE  EXTRACT(YEAR FROM SYSDATE)-   -- ���ڸ��� 1Ȥ�� 2�� �ƴϸ� (3,4)
                      (2000+TO_NUMBER(SUBSTR(MEM_REGNO1,1,2))) -- MEM_REGNO1�� ���ڸ� 2�ڸ��� ������ 2000 ����
             END AS ����       
      FROM MEMBER;
      
      SELECT EXTRACT(YEAR FROM SYSDATE)-EXTRACT(YEAR FROM MEM_BIR) AS ����
        FROM MEMBER;
        
  (2)���ɴ�� ��ȯ
     SELECT EXTRACT(YEAR FROM SYSDATE)-EXTRACT(YEAR FROM MEM_BIR) AS ����, --EXTRACT ��¥ ���� ���� (�ý��۳�¥���� �⵵ ����) - (MEM_BIR���̺� �ִ� �⵵�� ����)
            TRUNC(EXTRACT(YEAR FROM SYSDATE)-EXTRACT(YEAR FROM MEM_BIR),-1) AS ���ɴ� -- ���̿� 1�� �ڸ��� ��� �ڸ����� == ���ɴ�
        FROM MEMBER;
         
    SELECT  TRUNC(EXTRACT(YEAR FROM SYSDATE)-EXTRACT(YEAR FROM MEM_BIR),-1)||'��' AS ���ɴ�,
            COUNT(*) AS ȸ����,
            SUM(MEM_MILEAGE) AS ���ϸ����հ�
      FROM  MEMBER
     GROUP BY TRUNC(EXTRACT(YEAR FROM SYSDATE)-EXTRACT(YEAR FROM MEM_BIR),-1)
     ORDER BY 1;
     
   (4)FLOOR(n), CEIL(n)
    - FLOOR(n): n�� ���ų�(n�� ������ ���) ���� �� �� ���� ū ����
    - CEIL(n): n�� ���ų�(n�� ������ ���) ū �� �� ���� ���� ���� 
 ��뿹)
    SELECT FLOOR(102.6777),FLOOR(102),FLOOR(-102.6777), -- 102 , 102 , -103
            CEIL(102.6777),CEIL(102),CEIL(-102.6777)    -- 103 , 102 , -102
      FROM DUAL; 
    
    (5)REMAINDER(n, m), MOD(n, m)
    - �־��� �� n�� m���� ���� �������� ��ȯ
    - ���������� ���� ����� �ٸ�
    - MOD(n, m):�Ϲ����� �������� ��ȯ
    - REMAINDER(n, m) : �������� m�� ���ݰ�(0.5)�� �ʰ��ϸ� ��ȯ ���� ���� ���̵Ǳ� 
      ���� �ʿ��� ���� �����̸�, �׿ܴ� MOD�� ����
    - �������
      MOD       = n - m * FLOOR(n/m)
      REMAINDER = n - m * ROUND(n/m)
    ex) MOD(12, 5), REMAINDER(12,5)
        MOD(12, 5)      = 12 - 5 * FLOOR(12/5)
                        = 12 - 5 * FLOOR(2.4)
                        = 12 - 5 * 2
                        = 2
        REMAINDER(12,5) = 12 - 5 * ROUND(12/5)
                        = 12 - 5 * ROUND(2.4)
                        = 12 - 5 * 2
                        = 2
         
         MOD(14, 5), REMAINDER(14,5)  
        MOD(14, 5)      = 14 - 5 * FLOOR(14/5)
                        = 14 - 5 * FLOOR(2.8)
                        = 14 - 5 * 2
                        = 4
        REMAINDER(14,5) = 14 - 5 * ROUND(14/5)
                        = 14 - 5 * ROUND(2.8)
                        = 14 - 5 * 3
                        = -1
                        