/*2022-0406-01)사용자 생성*/

- 오라클 사용자 생성
(사용형식)
CREATE USER 유저명 IDENTIFIED BY 암호;
CREATE USER KMS97 IDENTIFIED BY java;

- 권한설정
(사용형식)
GRANT 권한명, [,권한명,..] TO 유저명;
GRANT CONNECT,RESOURCE,DBA TO KMS97

- HR 계정 활성화
alter user hr account unlock;

alter user hr IDENTIFIED by java;