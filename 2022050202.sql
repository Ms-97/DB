2022-0502-02)
2. SEQUENCE
 - ���������� ����(�Ǵ� ����)�Ǵ� ���� ��ȯ�ϴ� ��ü
 - Ư�� ���̺� ���ӵ��� ����
 - �⺻Ű�� ������ ���� �׸��� ���� ��� �ַ� ���
 (�������)
  CREATE SEQUENCE ��������
   [START WITH n] -- n���� ����  //������ �ʱⰪ , �ʱⰪ�� �����Ǹ� 1
   [INCREMENT BY n] -- (+)���� (-)���Ұ�(n)
   [MAXVALUE n|NOMAXVALUE] -- ������ ����, �⺻�� NOMAXVALUE�̸� 10^27
   [MINVALUE n|NOMINVALUE] -- �ּҰ� ����, �⺻�� NOMINVALUE�̸� ���� 1 ��
   [CYCLE|NOCYCLE] :-- ����/�ּ� ������ ������ �� �ٽ� �������� ���� �⺻�� NOCYCLE
   [CACHE n|NOCACHE] : -- ������ �������� ĳ�� �޸𸮿� ������ ������ ����
                       -- �⺻�� CACHE 20
   [ORDER |NOORDER] : -- ���ǵȴ�� ������ ���忩�� �⺻�� NOORDER 
   
  ** ������ ����� ���ѵǴ� ��
   . SELECT, UPDATE, DELETE ���� SUBQUERY
   . VIEW�� ��������ϴ� QUERY
   . DISTINCT�� ���� SELECT��
   . GROUP BY, ORDER BY���� ���� SELECT��
   . ���տ����ڿ� ���� SELECT��
   . SELECT���� WHERE ��
   
  ** �������� ���Ǵ� �ǻ��÷�
   ��������.CURRVAL : ��������ü�� ���簪
   ��������.NEXTVAL : ��������ü�� ������
 
 ** �������� �����ǰ� ù ��° �����ؾ��� ����� �ݵ�� NEXTVALUE �� 
      �Ǿ�� ��
      
��뿹)�з����̺� ����� �������� �����Ͻÿ�
      ���۰��� 10�̰� 1�� �����ؾ���
   CREATE SEQUENCE SEQ_LPROD
    START WITH 10;
    
��뿹) �����ڷḦ �з����̺� �����Ͻÿ�
  [�ڷ�]
   LPROD_ID      LPROD_GU       LPROD_NM
--------------------------------------------
   ���������       P501          ��깰
   ���������       P502          ���깰   
   ���������       P503          �ӻ깰   
   
  INSERT INTO LPROD
   VALUES(SEQ_LPROD.NEXTVAL, 'P501','��깰');
   
   INSERT INTO LPROD
   VALUES(SEQ_LPROD.NEXTVAL, 'P502','���깰');
   
   INSERT INTO LPROD
   VALUES(SEQ_LPROD.NEXTVAL, 'P503','�ӻ깰');
    
3.SYNONYM(���Ǿ�)
  - ����Ŭ���� ���Ǵ� ��ü�� �ο��� �� �ٸ� �̸�
  - �� ��ü���̳� ����ϱ� ����� ��ü���� ����ϱ� ���� ����ϱ� ����
    �̸����� ���
    
  (�������)
   CREATE OR REPLACE SYNONYM ��Ī FOR ��ü��;
    .'��ü��'�� '��Ī'���� �� �ٸ� �̸� �ο�
    
   ��뿹)HR������ ������̺�� �μ����̺��� EMP, DEPT�� ��Ī(���Ǿ�)�� �ο��Ͻÿ�
    CREATE OR REPLACE SYNONYM EMP FOR HR.employees;
     CREATE OR REPLACE SYNONYM DEPT FOR HR.DEPTS;
    
    SELECT * FROM EMP;
    
4.INDEX
 - ���̺� ����� �ڷḦ ȿ�������� �˻��ϱ����� ���
 - ����Ŭ������ ����ڷ� ���� �˻������ �ԷµǸ� ��ü�� ������� �˻�(FULL SCAN)
   ���� �Ǵ� �ε��� ��ĵ(INDEX SCAN)�� ���� ������
 - �ε����� �ʿ��� �÷�
  . ���� �˻��ϴ� �÷�
  . WHERE ������ '-'�����ڷ� Ư�� �ڷḦ �˻��ϴ� ���
  . �⺻Ű
  . SORT(ORDER BY)�� JOIN���꿡 ���� ���Ǵ� �÷�

 - �ε����� ����
  . Unique / Non-unique
  . Single / Composite
  . Normal / Bitmap / Function-Based 
  
 (�������)
  CREATE [UNIQUE|BITMAP] INDEX �ε����� -- �⺻ Normal 
    ON ���̺�(�÷���[,�÷���,...] [ASC|DESC]);
  . 'ASC|DESC' : �������� �Ǵ� �������� �ε��� ����
                 �⺻�� ASC
                 
                 
��뿹)
  CREATE INDEX IDX_MEM_NAME
    ON MEMBER(MEM_NAME);
  
  SELECT * FROM MEMBER
   WHERE MEM_NAME='����ȸ';
   
   DROP INDEX IDX_MEM_NAME;
  