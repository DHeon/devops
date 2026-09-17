# DevOps 3주차 — 셸 스크립팅

### Qwen

Qwen은 Alibaba Cloud에서 개발한 대형 언어 모델 

사용 모델:

```text
qwen3:0.6b
```

---

## Ollama

Ollama는 로컬 환경에서 LLM을 쉽게 설치하고 실행할 수 있게 해주는 도구

---

## Ollama 설치

```bash
sudo apt update
sudo apt install -y python3 curl zstd
curl -fsSL https://ollama.com/install.sh | sh
```

---

## Ollama 서버 확인

버전 확인:

```bash
ollama --version
python3 --version
```

Ollama 서버 확인:

```bash
curl -fsS http://127.0.0.1:11434/api/tags
```

```json
{"models":[]}
```

서버 연결이 되지 않을 경우:

```bash
ollama serve
```

---

## 7. Qwen 모델 다운로드

```bash
ollama pull qwen3:0.6b
```

다운로드된 모델 확인:

```bash
ollama list
```

### 실행

```bash
python3 chat.py
```

웹 브라우저:

```text
http://localhost:8000
```

종료:

```text
Ctrl + C
```

---
# 셸 스크립트

## `start.sh` 작성

현재 위치 확인:

```bash
pwd
```

파일 생성:

```bash
nano start.sh
```

내용:

```bash
#!/bin/bash
cd "$(dirname "$0")" || exit 1
exec python3 chat.py
```
---

## Shebang

첫 번째 줄:

```bash
#!/bin/bash
```

`#!`를 **shebang**이라고 함.


```text
이 파일을 실행할 때
/bin/bash 프로그램으로 해석하라.
```
---

## 다른 인터프리터를 shebang으로 지정하기

Python으로 shebang

```python
#!/usr/bin/env python3

print("Hello, DevOps!")
```
---

## 스크립트 자신의 위치로 이동하기

핵심 코드:

```bash
cd "$(dirname "$0")" || exit 1
```

이 코드는 **스크립트가 존재하는 디렉터리로 이동**

---

## `$0`

`$0`은 현재 실행한 스크립트의 이름 또는 경로를 의미

예:

```bash
./command.sh qwen3:0.6b 8000
```

각 값:

```text
$0 = ./command.sh
$1 = qwen3:0.6b
$2 = 8000
```

참고 변수:

```text
$# = 전달받은 argument 개수
$@ = 전달받은 모든 argument
$? = 직전 명령의 종료 상태
```

---

## `dirname`

```bash
dirname "$0"
```

파일 경로에서 파일 이름을 제외한 **디렉터리 부분**을 출력
---

## 명령어 치환 `$(...)`

```bash
$(command)
```

괄호 안 명령어를 실행하고, 그 **표준 출력 결과를 해당 위치에 삽입**
---

## 종료 상태와 `||`

```text
0      = 성공
0 이외 = 실패
```

예:

```bash
cd "$(dirname "$0")" || exit 1
```

`||`는 논리 OR

앞 명령이 실패하면 뒤 명령을 실행

직전 명령의 종료 상태 확인:

```bash
echo $?
```

---

## `exec`

```bash
exec python3 chat.py
```

`exec`는 현재 Bash 프로세스를 `python3 chat.py` 프로세스로 대체

즉 Bash 프로세스 위에서 Python을 자식 프로세스로 새로 실행하는 것이 아니라 현재 프로세스 자체를 Python으로 바꿈

비교:

```bash
#!/bin/bash
exec python3 chat.py
echo "End"
```

`exec` 이후 Bash가 Python으로 대체되므로 `echo "End"`가 실행 안됨.

```bash
#!/bin/bash
python3 chat.py
echo "End"
```

Python 프로그램이 끝난 뒤 Bash가 다시 다음 줄을 실행하므로 `End`가 출력됨.

---

## 실행 권한
오류:

```text
Permission denied
```

실행 권한 추가:

```bash
chmod u+x start.sh
```
---

## `start.sh` , `./start.sh`

```bash
start.sh
```
PATH에 등록된 디렉토리에서 실행 파일 찾음.

```bash
./start.sh
```
실팽 파일 실행됨.

일시적으로 PATH 추가:

```bash
export PATH="$PATH:$HOME/devops/week03/qwen-web/"
```

---

# 환경 변수

## 환경 변수로 모델 설정 전달


```bash
cat > start_with_export.sh << 'EOF'
#!/bin/bash
cd "$(dirname "$0")" || exit 1
export MODEL="qwen3:0.6b"
exec ./start.sh
EOF
```
export로 MODEL 환경 변수를 줘서 MODEL 변수가 먼저 전달되서 실행됨

## Heredoc

다음 문법:

```bash
cat > start_with_export.sh << 'EOF'
...
EOF
```

여러 줄의 내용을 파일에 저장할 때 사용

`EOF` 대신 `END`, `FINISH` 등 다른 문자열도 사용 가능

---

## `'EOF'`와 `EOF`의 차이

따옴표를 사용하면 heredoc 안의 변수를 **문자 그대로 저장**


```bash
MODEL="qwen3"

cat > test.sh << 'END'
echo "$MODEL"
END
```


```bash
echo "$MODEL"
```

따옴표 없이 작성했을 때

```bash
MODEL="qwen3"

cat > test.sh << END
echo "$MODEL"
END
```

```bash
echo "qwen3"
```

---

# 조건문

## 실행 전에 프로그램 설치 여부 확인하기

```bash
cd "$(dirname "$0")" || exit 1

if ! command -v python3 >/dev/null 2>&1; then
    echo "Python3를 먼저 설치하세요." >&2
    exit 1
fi

exec python3 chat.py
```

---

## `command -v`

```bash
command -v python3
```

명령어가 실행 가능한 상태라면 경로를 출력

---


## 29. `/dev/null`


`/dev/null`은 출력 내용을 버리는 곳


```bash
command -v python3 >/dev/null
```

---

## 표준 입력 / 출력 / 오류


| 번호 | 이름 |
|---:|---|
| `0` | stdin — 표준 입력 |
| `1` | stdout — 표준 출력 |
| `2` | stderr — 표준 오류 |


```bash
2>&1
```

```text
표준 오류(2)를
현재 표준 출력(1)이 향하는 곳으로 보냄
```


```bash
command -v python3 >/dev/null 2>&1
```

은 표준 출력과 표준 오류를 모두 `/dev/null`로 보내는 형태

리다이렉션은 **왼쪽에서 오른쪽 순서**로 해석됨

---

## 오류 메시지를 stderr로 보내기

```bash
echo "Python3를 먼저 설치하세요." >&2
```

일반 출력이 아니라 표준 오류 메시지 출력

---

## `exit 1`

```bash
exit 1
```

스크립트를 실패 상태로 종료

```text
exit 0 = 성공
exit 1 = 실패
```

---

## OS별 설치 안내까지 추가하기

```bash
if ! command -v python3 >/dev/null 2>&1; then
    echo "Python3가 설치되어 있지 않습니다." >&2

    if [ "$(uname)" = "Darwin" ]; then
        echo "[Mac] 다음 명령으로 설치하세요." >&2
        echo "  brew install python" >&2
    else
        echo "[Windows(WSL)/Ubuntu] 다음 명령으로 설치하세요." >&2
        echo "  sudo apt update" >&2
        echo "  sudo apt install python3 -y" >&2
    fi

    exit 1
fi

exec python3 chat.py
```
