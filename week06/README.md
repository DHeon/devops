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
```
```
FROM - 기반 이미지 

WORKDIR - 작업 디렉터리 (없으면 생성)

COPY 원본 대상 - 호스트 파일을 -> 이미지 안으로 

RUN - 빌드할 때 실행

ENV 이름=값 - 환경변수 기본값을 이미지에

EXPOSE - 포트 번호 문서화 (실제로 열리지 않고 어떤 포트를 사용할 것인지 예정)

CMD - 컨테이너 실행할 때 실행 
```

## ENV 환경변수

```
셸
export APP_TITLE="셸 설정"

docker run
-e APP_TITLE="이미지 설정"

Docker file
ENV APP_TITLE="실행 설정"
```

## 레이어, 캐시

```
FROM python:3.12-slim →        [레이어 1] ─┐
WORKDIR /app →                 [레이어 2] │ 변하지 않으면 캐시 재사용 (빠름)
COPY requirements.txt . →      [레이어 3] │
RUN pip install ... →          [레이어 4] ─┘
COPY . . →                     [레이어 5] ← 코드가 바뀌면 여기부터 다시 빌드
CMD ["python","app.py"]
```

```
자주 바뀌는 것을 뒤 순서에 둠으로써 빌드 속도가 빨라짐
```

## 빌드

```
docker build -t guestbook:v1 .
```

멀티 플랫폼 이미지 생성
```
docker buildx build --platform linux/amd64, linux/arm64 -t ghcr.io/[ID]/guestbook:v1 --push .
```


## 혼자 해보기

### 1. 방명록 V2 배포

```
nano Dockerfile을 통해 APP_TITLE과 THEME_COLOR를 수정


FROM python:3.12-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

RUN useradd -m appuser
USER appuser

ENV APP_TITLE="김도헌 방명록" \       <- APP_TITLE 수정
    THEME_COLOR="#B39EB5"             <- THEME_COLOR 수정

EXPOSE 5000

CMD ["python", "app.py"]
```

```
nano templates/index.html을 통해 index.html을 수정

body { font-family: -apple-system, "Segoe UI", "Malgun Gothic", sans-serif;
           background: #e2ff9d; margin: 0; padding: 40px 16px; color: #222; }

background 색상을 #e2ff9d 로 변경
```

```
docker build -t guestbook:v2 .

docker buildx build --platform linux/amd64,linux/arm64 -t ghcr.io/dheon/guestbook:v2 --push .

를 통해 빌드
```

```
$ docker run -d -p 8081:5000 --name gbv2 \
-e THEME_COLOR="#C6A15B" \
ghcr.io/dheon/guestbook:v2

으로 환경변수 THEME_COLOR를 변경후 컨테이너 실행

실행할때 지정해준 THEME_COLOR가 나오는 것이 확인가능
```

## 친구 이미지 내 설정으로 굽기

```
cat > Dockerfile.custom << 'EOF'
> FROM ghcr.io/ownvdz/inhatc-devops-guestbook:v1
> ENV APP_TITLE="방명록" \
> THEME_COLOR="#7C9A82"
> EOF

FROM을 친구 이미지로 하면 그 이미지를 바탕으로 Dockerfile이 생성 가능함.
```

## 정리

```
이미지 주소 : ghcr.io/dheon/guestbook:v2
```

```
Dockerfile 설명

FROM python:3.12-slim         -  python:3.12-slim 이미지를 바탕으로 실행

WORKDIR /app    - 작업 디레터리를 /app으로 설정

COPY requirements.txt .      - 필요한 패키지들이 있는 txt를 작업 디렉터리로 복사
RUN pip install --no-cache-dir -r requirements.txt   - txt를 바탕으로 필요한 패키지를 설치

COPY . .    - 나머지 호스트의 파일들을 작업 디렉토리로 복사

RUN useradd -m appuser
USER appuser    - 컨테이너를 관리자가 아닌 사용자로서 작동하게끔

ENV APP_TITLE="김도헌 방명록" \
    THEME_COLOR="#B39EB5"   - 환경 변수 APP_TITLE과 THEME_COLOR를 변경

EXPOSE 5000     - 도커의 5000 포트를 사용할 것이라고 예정

CMD ["python", "app.py"]    -  컨테이너 실행 시 python app.py를 실행
```

```
빌드 캐시

heon@k:~/devops/guestbook$ docker buildx build --platform linux/amd64,linux/arm64 -t ghcr.io/dheon/guestbook:v2 --push .
[+] Building 38.1s (14/17)                                                                               docker:default
[+] Building 82.4s (19/19) FINISHED                                                                      docker:default
 => [internal] load build definition from Dockerfile                                                               0.0s
 => => transferring dockerfile: 530B                                                                               0.0s
 => [linux/arm64 internal] load metadata for docker.io/library/python:3.12-slim                                    2.2s
 => [linux/amd64 internal] load metadata for docker.io/library/python:3.12-slim                                    0.1s
 => [internal] load .dockerignore                                                                                  0.0s
 => => transferring context: 120B                                                                                  0.0s
 => [linux/amd64 1/6] FROM docker.io/library/python:3.12-slim@sha256:f77ac9e44ae96ef2c90b8053ea08c31f8be030f82419  0.1s
 => => resolve docker.io/library/python:3.12-slim@sha256:f77ac9e44ae96ef2c90b8053ea08c31f8be030f824196b0ae4db6d46  0.1s
 => [internal] load build context                                                                                  0.0s
 => => transferring context: 268B                                                                                  0.0s
 => [linux/arm64 1/6] FROM docker.io/library/python:3.12-slim@sha256:f77ac9e44ae96ef2c90b8053ea08c31f8be030f82419  9.9s
 => => resolve docker.io/library/python:3.12-slim@sha256:f77ac9e44ae96ef2c90b8053ea08c31f8be030f824196b0ae4db6d46  0.1s
 => => sha256:8fab80907cc75b43464f59a38c5548ae9199a01202b80a0474fb5e81c33950b4 249B / 249B                         0.2s
 => => sha256:d122ce05d52358f34d63025713fdaf36bd7f684c4861ef9715450970c8599024 12.05MB / 12.05MB                   3.2s
 => => sha256:c84bebac337e749a4bb38e590f1994648dedbc4a1d04db88b978cb18a5359a7b 1.28MB / 1.28MB                     2.7s
 => => sha256:bd36565c0fdebaf0f3af5c3b4ce610ca085ced32e9e9da850d95912f5f18f47b 30.19MB / 30.19MB                   7.4s
 => => extracting sha256:bd36565c0fdebaf0f3af5c3b4ce610ca085ced32e9e9da850d95912f5f18f47b                          1.5s
 => => extracting sha256:c84bebac337e749a4bb38e590f1994648dedbc4a1d04db88b978cb18a5359a7b                          0.1s
 => => extracting sha256:d122ce05d52358f34d63025713fdaf36bd7f684c4861ef9715450970c8599024                          0.6s
 => => extracting sha256:8fab80907cc75b43464f59a38c5548ae9199a01202b80a0474fb5e81c33950b4                          0.0s
 => CACHED [linux/amd64 2/6] WORKDIR /app                                                                          0.0s
 => CACHED [linux/amd64 3/6] COPY requirements.txt .                                                               0.0s
 => CACHED [linux/amd64 4/6] RUN pip install --no-cache-dir -r requirements.txt                                    0.0s
 => CACHED [linux/amd64 5/6] COPY . .                                                                              0.0s
 => CACHED [linux/amd64 6/6] RUN useradd -m appuser                                                                0.0s
 => [linux/arm64 2/6] WORKDIR /app                                                                                 0.3s
 => [linux/arm64 3/6] COPY requirements.txt .                                                                      0.1s
 => [linux/arm64 4/6] RUN pip install --no-cache-dir -r requirements.txt                                          53.0s
 => [linux/arm64 5/6] COPY . .                                                                                     0.1s
 => [linux/arm64 6/6] RUN useradd -m appuser                                                                       0.6s
 => exporting to image                                                                                            15.9s
 => => exporting layers                                                                                            1.9s
 => => exporting manifest sha256:6d28b743d6493642ffe85e71722446401084e4393cbdb3448c6a175d54be854d                  0.0s
 => => exporting config sha256:7df370b0f113f2468ea2bcbde08a67296a94bb93028469108b356fa44b41564d                    0.0s
 => => exporting attestation manifest sha256:e49d540b2f9ae74f06eeeec6e12e3022ac1c6ebceb48d6a9f7578f85ac735f6a      0.0s
 => => exporting manifest sha256:fb4b082a2a2a9190bcd5d892189d38a48894cbafa0aae051485bd1fc96c0ba8c                  0.0s
 => => exporting config sha256:1afbb123dd01481411cd5f05d95c2ddbda196634722e199da1805a6eaa4ad184                    0.0s
 => => exporting attestation manifest sha256:1a4c592f45478c6cbd4a00601eb9420b64c52dec358d73b433ee61f551cf114f      0.0s
 => => exporting manifest list sha256:401bada05b98a2851d2467893ec226189d2c9df779db8faa5733744cd45a39e1             0.0s
 => => naming to ghcr.io/dheon/guestbook:v2                                                                        0.0s
 => => pushing layers                                                                                             10.2s
 => => pushing manifest for ghcr.io/dheon/guestbook:v2@sha256:401bada05b98a2851d2467893ec226189d2c9df779db8faa573  3.4s
 => [auth] dheon/guestbook:pull,push token for ghcr.io 
```

```
설정을 넣는 세 가지 방법

app.py 파일 기본값 수정
코드를 작성할 때 확정되고 바꾸기 위해서는 코드 수정 후 재 빌드를 해야함.

Dockerfile의 ENV 변경
이미지를 빌드하는 시점에서 확정되고 바꾸기 위해서는 재빌드를 하면됨.

docker run -e
컨테이너를 실행하는 시점에서 확정되고 바꾸기 위해서는 컨테이너만 재 실행하면 됨.
```


