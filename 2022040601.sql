/*2022-0406-01)����� ����*/

- ����Ŭ ����� ����
(�������)
CREATE USER ������ IDENTIFIED BY ��ȣ;
CREATE USER KMS97 IDENTIFIED BY java;

- ���Ѽ���
(�������)
GRANT ���Ѹ�, [,���Ѹ�,..] TO ������;
GRANT CONNECT,RESOURCE,DBA TO KMS97

- HR ���� Ȱ��ȭ
alter user hr account unlock;

alter user hr IDENTIFIED by java;