2022-0411-02) ������ �˻���(SELECT ��)
 - SQL��� �� ���� ���� ���Ǵ� ���
 - �ڷ� �˻��� ���� ���
 (�������)
 SELECT *|[DISTINCT]�÷��� [AS ��Ī][,] --��Ī�� Ư�����ڸ� ����ϰų� ��ɹ��� ���� �̸��� ���� ""���[EX "�� ��"]
        �÷��� [AS ��Ī]
             :
        �÷��� [AS ��Ī]
   FROM ���̺��  --FROM�� �ڿ� ���̺�� �丸 �ü� ����     
  [WHERE ����]
   [GROUP BY �÷���[,�÷���,...]]
  [HAVING ����]              --����  ����  (�⺻�� ��������(ASC))
   [ORDER BY �÷��ε���|�÷��� [ASC|DESC][,�÷��ε���|�÷��� [ASC|DESC],...]]];
   
��뿹) ȸ�����̺��� ȸ����ȣ,ȸ����,�ּҸ� ��ȸ�Ͻÿ�.
    SELECT MEM_ID AS ȸ����ȣ,
           MEM_NAME AS ȸ����,
           MEM_ADD1||' '||MEM_ADD2 AS "��  ��"
      FROM MEMBER;

��뿹) ȸ�����̺��� '����'�� �����ϴ� ȸ����ȣ,ȸ����,�ּҸ� ��ȸ�Ͻÿ�. 
 SELECT MEM_ID AS ȸ����ȣ,
           MEM_NAME AS ȸ����,
           MEM_ADD1||' '||MEM_ADD2 AS "��  ��"
      FROM MEMBER
     WHERE MEM_ADD1 LIKE '����%'; 
     
��뿹) ȸ�����̺��� '����'�� �����ϴ� ����ȸ���� 
ȸ����ȣ,ȸ����,�ּҸ� ��ȸ�Ͻÿ�. 

SELECT MEM_ID AS ȸ����ȣ,
           MEM_NAME AS ȸ����,
           MEM_ADD1||' '||MEM_ADD2 AS "��  ��"
      FROM MEMBER
     WHERE MEM_ADD1 LIKE '����%' 
       AND SUBSTR(MEM_REGNO2,1,1) IN('2','4'); --SUBSTR: �κй��ڿ� ���� (����,���۰�,����)
       
��뿹) ȸ�����̺��� ȸ������ ��������(�����õ�)�� ��ȸ�Ͻÿ�,
    SELECT DISTINCT SUBSTR(MEM_ADD1,1,2) AS ������
        FROM MEMBER;
    