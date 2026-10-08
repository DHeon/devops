# DevOps 6주차 - 도커파일

## 이미지 주소

```
ghcr.io / makyraen / inhatc-devops-guestbook : v1
   |          |               |                |
레지스트리   사용자계정    이미지이름         태그
```

### latest 태그

```
태그를 생략하면 도커는 latest 태그를 요청하는 것이지
가장 최근 버전을 자동으로 받는 것이 아님.
```

## Dockerfile

이미지를 만드는 레시피

```
# 1. 재료 선택
FROM python:3.12-slim

# 2. 작업 디렉터리 설정
WORKDIR /app

# 3. 내 파일을 이미지 안으로 복사할 때 사용
COPY requirements.txt .

# 4. 실행할 명령
RUN pip install -r requirements.txt

# 5. 나머지 코드도 이미지 안으로
COPY . .

# 6. 환경 변수 설정
ENV APP_TITLE="InhaTC DevOps 방명록" \
THEME_COLOR="#0054A6"

# 7. 포트 번호 (문서화)
EXPOSE 5000

# 8. 컨테이너 시작 시 실행할 명령
CMD ["python", "app.py"]

FROM - 기반 이미지 

WORKDIR - 작업 디렉터리 (없으면 생성)

COPY 원본 대상 - 호스트 파일을 -> 이미지 안으로 

RUN - 빌드할 때 실행

ENV 이름=값 - 환경변수 기본값을 이미지에

EXPOSE - 포트 번호 문서화 (실제로 열리지 않고 어떤 포트를 사용할 것인지 예정)

CMD - 컨테이너 실행할 때 실행 
```

