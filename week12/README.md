# Week12 : GitHub Action

## CI / CD

```
CI : Continuous Integration (지속적 통합)
코드를 합칠 떄마다 자동으로 검사 및 빌드
목적 : 작은 변경을 자주 통합하고, 자동 검증으로 문제를 일찍 발견

CD : Continuous Delivery (지속적 제공)
언제든 배포 가능한 상태를 유지

Continuous Deployment (지속적 배포)
검증을 통과한 변경을 운영 환경까지 자동 반영
```

## 깃허브 액션 구조
```
name: 워크플로 이름
on: 언제 실행
jobs: 할일
steps: 순서대로 실행
```

## Lint (검사)

```
print(APP_TITL)  # 문법 자체에 오류는 없지만 APP_TITL이라는 변수가 없음 
```

사용할 도구
```
ruff check . --select=E9,F

E9: 문법 오류
F: 정의 안 된 변수, 안 쓰는 import, 오타 등
```

## 태깅 전략

```
tags: |
  type=sha,prefix=,format=short           #sha: 커밋 해시 사용, short: 7글자로 
  type=raw,value=latest,enable={{is_default_branch}} #기본 브랜치일 때마 latest 태그 생성
```


## 테스트 코드와 워크플로 

```
test_app.py
프로그램이 제대로 동작하는지 확인할 테스트와 어떤 결과가 나와야할지 작성한 파일

build.yml
해당 테스트를 언제 어떤 컴퓨터에서 어떤 순서로 실행할 것인가 자동화 지시서 
```

```
.github/workflows/build.yml에 생성 후 main에 대한 push나 pull request가 열리면 동작함
```


