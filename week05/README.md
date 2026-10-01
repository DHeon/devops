# 5주차 - Docker
## docker --version 결과
Docker version 29.8.1, build 4a63305
## docker run hello-world 실행 결과
```
Hello from Docker!
This message shows that your installation appears to be working correctly.

To generate this message, Docker took the following steps:
 1. The Docker client contacted the Docker daemon.
 2. The Docker daemon pulled the "hello-world" image from the Docker Hub.
    (amd64)
 3. The Docker daemon created a new container from that image which runs the
    executable that produces the output you are currently reading.
 4. The Docker daemon streamed that output to the Docker client, which sent it
    to your terminal.

To try something more ambitious, you can run an Ubuntu container with:
 $ docker run -it ubuntu bash

Share images, automate workflows, and more with a free Docker ID:
 https://hub.docker.com/

For more examples and ideas, visit:
 https://docs.docker.com/get-started/
```
***

## nginx 컨테이너 실행
```
docker run -d -p 8080:80 --name web nginx
```
명령어를 통해 8080:80 포트로 nginx 컨테이너 실행

## curl 응답 결과
```
HTTP/1.1 200 OK
Server: nginx/1.31.6
Date: Thu, 01 Oct 2026 03:11:15 GMT
Content-Type: text/html
Content-Length: 896
Last-Modified: Tue, 15 Sep 2026 12:54:15 GMT
Connection: keep-alive
ETag: "6aa93ff7-380"
Accept-Ranges: bytes
```
## docker ps로 실행상태 확인
```
CONTAINER ID   IMAGE     COMMAND                  CREATED         STATUS         PORTS                                     NAMES
49812ff001f3   nginx     "/docker-entrypoint.…"   6 minutes ago   Up 6 minutes   0.0.0.0:8080->80/tcp, [::]:8080->80/tcp   web
```
