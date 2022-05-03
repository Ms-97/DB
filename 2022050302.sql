2022-0503-02)분기문과 반복문
1. 분기문
 - 개발언어의 분기문과 같은 기능제공
 - IF문, CASE WHEN 문 등이 제공
 1)IF문
  - 조건분기문
  (사용형식1)
  IF 조건문 THEN
     명령문1;
 [ELSE
     명령문2;]
  END IF;
  
  (사용형식2)
  IF 조건문1 THEN
     명령문1;
  ELSIF 조건문2 THEN
     명령문2;
         :
  ELSE
     명령문n;
  END IF;  
  
  (사용형식3)
  IF 조건문1 THEN
     IF 조건문2 THEN
        명령문1;
         :
     END IF;    
  ELSE
     명령문n;
  END IF;    