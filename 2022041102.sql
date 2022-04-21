2022-0411-02) 데이터 검색문(SELECT 문)
 - SQL명령 중 가장 많이 사용되는 명령
 - 자료 검색을 위한 명령
 (사용형식)
 SELECT *|[DISTINCT]컬럼명 [AS 별칭][,] --별칭에 특수문자를 사용하거나 명령문과 같은 이름을 사용시 ""사용[EX "공 백"]
        컬럼명 [AS 별칭]
             :
        컬럼명 [AS 별칭]
   FROM 테이블명  --FROM절 뒤엔 테이블와 뷰만 올수 있음     
  [WHERE 조건]
   [GROUP BY 컬럼명[,컬럼명,...]]
  [HAVING 조건]              --오름  내림  (기본은 오름차순(ASC))
   [ORDER BY 컬럼인덱스|컬럼명 [ASC|DESC][,컬럼인덱스|컬럼명 [ASC|DESC],...]]];
   
사용예) 회원테이블에서 회원번호,회원명,주소를 조회하시오.
    SELECT MEM_ID AS 회원번호,
           MEM_NAME AS 회원명,
           MEM_ADD1||' '||MEM_ADD2 AS "주  소"
      FROM MEMBER;

사용예) 회원테이블에서 '대전'에 거주하는 회원번호,회원명,주소를 조회하시오. 
 SELECT MEM_ID AS 회원번호,
           MEM_NAME AS 회원명,
           MEM_ADD1||' '||MEM_ADD2 AS "주  소"
      FROM MEMBER
     WHERE MEM_ADD1 LIKE '대전%'; 
     
사용예) 회원테이블에서 '대전'에 거주하는 여성회원의 
회원번호,회원명,주소를 조회하시오. 

SELECT MEM_ID AS 회원번호,
           MEM_NAME AS 회원명,
           MEM_ADD1||' '||MEM_ADD2 AS "주  소"
      FROM MEMBER
     WHERE MEM_ADD1 LIKE '대전%' 
       AND SUBSTR(MEM_REGNO2,1,1) IN('2','4'); --SUBSTR: 부분문자열 추출 (원본,시작값,갯수)
       
사용예) 회원테이블에서 회원들의 거주지역(광역시도)을 조회하시오,
    SELECT DISTINCT SUBSTR(MEM_ADD1,1,2) AS 거주지
        FROM MEMBER;
    