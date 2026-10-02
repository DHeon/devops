# DevOps 4주차 - 자동화와 협업

## 디렉터리

```
/
├── home/ - 사용자 작업 공간 ( ~/ ) 
├── etc/  - 시스템과 프로그램의 설정
├── var/log/ -시스템과 서비스의 로그가 주로 저장되는 위치
├── tmp/  - 임시 파일
└── usr/bin/  - 주요 실행 파일과 명령어 
```

## 절대 경로와 상대 경로

#### 절대 경로
```
/home/abc/123/hello.txt
```
항상 동일한 위치를 가르킴.

### 상대 경로
```
./week03/qwen-web/start.sh
week03/qwen-web/start.sh
```
현재 작업 중인 디렉터리를 기준으로 위치를 가르킴.

```
.  - 현재위치
.. - 상위 위치
~  - 홈
/  - 루트
```


```
cd "$(dirname "$0")"
```
스크립트를 어디서 호출하든 스크립트가 있는 위치를 기준으로 실행

## 파일 찾기

``` 
grep -R "exit 1" week03 2>/dev/null | wc -l

# -R 하위 디렉터리까지 모두 검색
# -n 줄 번호 표시
# wc -l 입력된 텍스트의 줄 수를 계산
```

```
| (파이프)
```
파일을 전달하는 것이 아닌 앞 명령의 표준 출력을 뒤 명령의 표출 입력으로 연결

```
$grep "ERROR" server.log # ERROR가 있는 줄만
$grep -i "error" server.log # -i: 대소문자무시
$grep -c "ERROR" server.log # -c: 개수만
$grep -n "ERROR" server.log # -n: 줄번호와함께
$grep -v "INFO" server.log # -v: INFO가없는줄만(반전)


$find . -name "*.txt"                # txt 파일찾기
$find . -type d                      # 디렉터리만찾기
$find / -name "start.sh" 2>/dev/null  
 # 시스템전체에서찾기

$ find / -name "start.sh" # 2>/dev/null 빼고실행해보기
```

## 변수와 명령치환

```
USERNAME="홍길동"  #공백이 있으면 안됨
echo "이름: $USERNAME"  # $가 없으면 그대로 출력됨
```

## 인자와 종료 코드

```
셸 스크립트는 실행할 때 전달된 값을 인자로 사용할 수 있다.
$0은 실행한 스크립트 이름, $1은 첫 번째 인자, $#은 전달된 인자의 개수이다.
$?는 바로 전에 실행한 명령의 종료 코드를 확인한다.
일반적으로 0은 정상 종료, 0이 아닌 값은 오류나 비정상 종료를 의미한다.
조건식에서 [ 와 ] 주변에는 공백이 필요하다.
```

## 조건문과 파일 검사

셸의 조건문을 이용하면 파일이나 디렉터리의 존재 여부, 문자열의 길이, 정수 비교 등을 검사할 수 있다.

```
#!/bin/bash

FILE="$1"

if [ -z "$FILE" ]; then
    echo "파일명을 입력하세요"
    exit 1
fi

if [ -f "$FILE" ]; then
    echo "파일"
elif [ -d "$FILE" ]; then
    echo "디렉터리"
else
    echo "없음"
    exit 1
fi
```


```
-f 파일      파일이 존재하는지 확인
-d 폴더      디렉터리가 존재하는지 확인
-z 문자열    문자열 길이가 0인지 확인
-n 문자열    문자열 길이가 0이 아닌지 확인

-eq          두 정수가 같은지 확인
-ne          두 정수가 다른지 확인
-gt          왼쪽 정수가 더 큰지 확인
-lt          왼쪽 정수가 더 작은지 확인
-ge          왼쪽 정수가 크거나 같은지 확인
-le          왼쪽 정수가 작거나 같은지 확인
```


## 반복문

for 반복문을 사용하면 여러 파일이나 여러 값을 순서대로 처리할 수 있다.
다음 명령은 현재 디렉터리의 sh 파일을 하나씩 확인하여 이름을 출력한다.

```
for f in *.sh; do
    echo "스크립트: $f"
done
```

## 패키지 관리와 실행 환경

```
sudo apt update
sudo apt install -y tree jq htop
```

## 프로세스

```
$ ps aux | head -5   #프로세스 정보 앞 5줄
$ ps aux | grep bash #bash를 포함하는 프로세스
$ htop               #실행 중인 프로세스, cpu , 메모리 사용량 확인


$ sleep 300 &   # & 백그라운드로 작업
$ jobs          # 현재 셸의 실행 작업
$ kill <PID>    # 종료 요청 (SIGTERM)
$ kill -9 <PID> # 강제 종료 (SIGKILL) 
```

### kill 시그널

```
SIGTERM - 15 : 정상 종료를 요청
SIGKILL - 9 : 즉시 종료
SIGINT - 2 : Ctrl + C
```

## tar, diff

```
tar: 여러 파일을 하나의 아카이브로 묶는 도구

-tzf : 내용 확인

-xzf: 압축 해제

-czf : 압축 생성

-C 작업할 디렉터리 지정

-t : 목록 확인
-z: gzip 압축
-f: 파일명 지정
-x:압축 해제
```

```
diff -rq
-r : recursive
-q : brief 
-u : unified format, 변경 사항을 텍스트로 표현
```

## .gitignore

```
지정한 파일을 새로 Git 추적 대상에 포함하지 않도록 함

이미 Git 이 추적 중이라면
git rm --cached <파일명> 또는 git rm -r --cached <디렉터리명>
```

## 브랜치

```
git branch # 현재 브랜치 확인

git switch -c <브랜치명> #브랜치 생성
```

## Pull Request & Merge

pr 올리기
```
$ gh pr create --title "백업 로그 기록 기능 추가" \
>   --body "백업이 끝나면 backup.log에 백업 일시와 파일명을 기록합니다." \
>   --base main
>   --head feature/backup-log # 생략 가능
$ gh pr view --web
```

```
$ gh pr merge --squash --delete-branch # main에 합치면서 삭제
$ git switch main      # main 브랜치로 이동
$ git pull --ff-only   # 바뀐 내용 pull 하기 (fast-forward만 허용)
$ git log --oneline -3  # 최근 3개 커밋 보기
```

## Conflict

```
같은 줄을 다른 브랜치에서 서로 다르게 수정되어 Conflict 발생
Git이 임의로 결정하지 않음.

merge시 문제 파일을 확인하면
<<<<<Head

>>>>> origin/main 
식으로 되어있음 요 부분을 수정해서 해결가능
```


# DevOps - 네트워크

## IP 주소

IP 주소
* 네트워크에서 장치를 식별하기 위한 주소

공인 IP
* 인터넷에서 라우팅 가능한 주소

사설 IP
* 해당 사설 네트워크 내부에서 사용하는 주소

127.0.0.1 = localhost 
* 네트워크를 통해 다른 컴퓨터를 찾아가는 주소가 아닌, '내 컴퓨터 자신'을 가르키는 주소

## NAT

```
공유기 또는 게이트웨이가 내부의 사설 IP를 공인 IP와 매핑하여 인터넷과 통신

NAT (Network Address Translation)
```

## IP 와 포트 

```
포트 : 그 컴퓨터에서 제공하는 서비스를 구분하는 번호

192.168.0.13:8080
    IP       Port
```

관례적인 포트 번호

```
22 : SSH(서버 원격 접속)
80: HTTP(웹)
443 : HTTPS(보안웹)
3306: MYSQL
6379 : Redis
5000 : Flask 개발 서버에서 자주 사용
8080 : 개발용 웹 서버에서 자주 사용
```

## DNS

```
DNS (Domain Name System)
도메인 이름에 대응 하는 IP 주소를 찾는 역할

cs.inhatc.ackr -[DNS] -> 221.154.90.200
```

## 내 IP

```
$ ip addr  #Ubuntu / WSL2
$ ip addr show eth0  # 특정 인터페이스
$ hostname -I  #사설 IP 확인

$ curl ifconfig.me  #공인 IP
```

## 연결 확인

```
ping -c 4 cs.inhatc.ac.kr

IMCP를 이용하여 상대 장치의 응답 여부 확인
```

## DNS 조회

```
$ dig cs.inhatc.ac.kr  #ip 주소 출력 (DNS 레코드까지)
$ dig cs.inhatc.ac.kr +short #ip 주소 출력 (ip만 조회)
$ nslookup cs.inhatc.ac.kr  # ip 주소 출력 (간단하게)

$ cat /etc/hosts # 로컬 전화번호부 [로컬 이름 매핑]
```

## HTTP 요청

```
$ curl https://google.com  # HTML 본문 확인
$ curl -I https://google.com # 헤더만 가져오기 (응답 코드 확인)
$ curl -s https://api.github.com/users/torvalds | jq .name # 값 가져오기
$ curl -o test.html https://google.com # 파일로 저장

-I: --head, HEAD 요청을 보내 응답 헤더 확인
-s: --silent, 진행률 또는 불필요한 메시지 숨김
-o: --output, 결과를 화면 대신 파일로 저장
```

### jq

json 데이터를 터미널에서 보기 좋게 출력하거나 원하는 값만 추출 및 가공하는 명령 도구

```
$ echo '{"name":"Kam","age":"21"}' | jq
{
"name": "Kam",
"age": "21"
}
```

```
$ echo '{"name":"Kam","age":"21"}' | jq'.name'
"Kam"
$ echo '{"name":"Kam","age":"21"}' | jq-r '.name'
Kam
$ # -r: raw, 따옴표없이출력
```
```
$ echo '{"users":[{"name":"Neary"},{"name":"Kam"}]}' | jq'.users[0].name'
"Neary"
```

## 응답 코드

```
200 - OK (성공)
400 - Bad Request (잘못된 요청)
404 - Not Found (리소스 없음)
500 - Internal Server Error (서버 에러)
503 - Service Unavailable (서비스 불가)

4xx: 클라이언트 요청 관련 오류
5xx: 서버 측 오류
```

## Listen 중인 TCP 포트 확인

```
$ ss -tlnp    # t=TCP, l=listen, n=숫자, p=프로세스
$ sudo ss -tlnp
```

## 0.0.0.0

```
모든 네트워크 인터페이스에서 연결을 받겠다는 의미
서버가 0.0.0.0에 bind하면 모든 IPv4 네트워크 인터페이스에서 연결을 바음
```

## 포트 여러개로 서버 실행

```
$ python3 -m http.server 8080 &
$ python3 -m http.server 8081 &
$ python3 -m http.server 8082 &

포트 번호가 같으면 충돌이 발생
```

## 방화벽

```
서버가 포트를 열어도 방화벽에서 포트를 차단하면 외부에서 접근 불가
```