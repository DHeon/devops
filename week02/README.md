# DevOps 2주차 — 실습 환경 구축과 버전 관리 기초


## 1. 서버와 가상화

### 서버(Server)

서버는 문맥에 따라 **하드웨어**와 **소프트웨어** 모두를 의미

### 서버 운영 방식 비교

| 종류 | 특징 |
|---|---|
| Bare Metal | 한 대의 PC에 OS를 설치하고 여러 소프트웨어를 직접 실행 |
| Hypervisor | 한 대의 물리 장비에서 여러 Virtual Machine 실행 |
| Container | 하나의 Host OS Kernel을 공유하면서 여러 격리된 실행 환경 구성 |

### Bare Metal

**장점**
- 하나의 OS에서 프로그램을 관리하기 쉬움

**단점**
- 하나의 프로그램이 침해되면 다른 프로그램에도 영향을 줄 수 있음
- 특정 프로그램의 리소스 사용량이 급증하면 다른 프로그램의 동작에 영향을 줄 수 있음

### Hypervisor

- Host OS의 자원을 이용해 여러 Guest OS를 실행
- 각 VM은 독립적인 Guest OS와 Kernel을 가짐
- CPU, Memory, Disk, Network 등의 리소스를 VM별로 할당

### Container

- 별도의 Guest OS Kernel 없이 Host OS Kernel을 공유
- 격리된 공간에서 프로세스를 실행
- Host OS와 다른 종류의 OS Kernel을 직접 사용할 수는 없음

리눅스 컨테이너의 핵심 기술:

- **Namespace**: 프로세스, 파일 시스템, 네트워크 등을 격리
- **cgroups**: CPU, Memory 등 리소스 사용량을 제어

---

## 2. WSL2 + Ubuntu 환경 구축

### WSL 특징

- 일반 VM보다 적은 리소스를 사용
- Windows 파일 탐색기와 연동 가능
- `bash` 기반 리눅스 명령어 사용 가능

### WSL + Ubuntu 설치

```powershell
wsl --install
```

특정 Ubuntu 버전 설치:

```powershell
wsl --install -d Ubuntu-24.04
```

현재 설치 상태 확인:

```powershell
wsl -l -v
```

WSL 1로 설치되어 있다면 WSL 2로 변경:

```powershell
wsl --set-version Ubuntu-24.04 2
```

앞으로 설치되는 배포판의 기본 버전을 WSL 2로 설정:

```powershell
wsl --set-default-version 2
```

기본 실행 배포판 설정:

```powershell
wsl --set-default Ubuntu-24.04
```

### Ubuntu 터미널 실행

기본 배포판 실행:

```powershell
wsl
```

특정 배포판 실행:

```powershell
wsl -d Ubuntu-24.04
```

Ubuntu에서 PowerShell로 돌아가기:

```bash
exit
```

### 리눅스 전용 작업 공간 만들기

홈 디렉터리로 이동:

```bash
cd ~
```

DevOps 실습 디렉터리 생성:

```bash
mkdir ~/devops
cd ~/devops
pwd
```

### Ubuntu 패키지 업데이트

```bash
sudo apt update
sudo apt upgrade -y
```

패키지 설치/삭제:

```bash
sudo apt install <패키지 이름>
sudo apt remove <패키지 이름>
```

> `sudo`는 관리자(root) 권한으로 명령어를 실행

### 공용 PC를 사용할 경우

필요하면 개인 계정을 생성해서 작업할 수 있습니다.

```bash
sudo adduser <계정이름>
```

특정 사용자로 WSL 실행:

```powershell
wsl -d Ubuntu-24.04 -u <계정이름>
```

현재 사용자 확인:

```bash
whoami
```

Ubuntu 안에서 사용자 전환:

```bash
su - <계정이름>
```

---

## 3. 기본 리눅스 명령어

### 디렉터리

| 명령어 | 설명 |
|---|---|
| `pwd` | 현재 디렉터리 확인 |
| `ls` | 파일/디렉터리 목록 확인 |
| `ls -l` | 권한, 소유자, 크기, 수정 시간 등 상세 정보 확인 |
| `ls -a` | 숨김 파일까지 확인 |
| `cd <dir>` | 디렉터리 이동 |
| `cd ~` | 홈 디렉터리 이동 |
| `cd ..` | 상위 디렉터리 이동 |
| `cd .` | 현재 디렉터리 |
| `cd -` | 직전에 있던 디렉터리로 이동 |
| `mkdir <dir>` | 디렉터리 생성 |
| `rmdir <dir>` | 비어 있는 디렉터리 삭제 |

### 파일

| 명령어 | 설명 |
|---|---|
| `touch <file>` | 빈 파일 생성 |
| `cat <file>` | 파일 내용 출력 |
| `less <file>` | 긴 파일 내용 확인 |
| `head <file>` | 파일 앞부분 확인 |
| `tail <file>` | 파일 뒷부분 확인 |
| `tail -f <log>` | 로그 파일을 실시간으로 확인 |
| `cp <src> <dst>` | 파일 복사 |
| `mv <src> <dst>` | 파일 이동 또는 이름 변경 |
| `rm <file>` | 파일 삭제 |

### 출력 리다이렉션

`>` : 기존 내용을 덮어쓰기

```bash
echo "Hello, DevOps!" > devops.txt
```

`>>` : 기존 내용 뒤에 추가

```bash
echo "Inha tech college" >> devops.txt
```

여러 파일의 내용을 하나로 합치기:

```bash
cat 1.txt 2.txt > result.txt
```

기존 파일 뒤에 이어 붙이기:

```bash
cat 3.txt >> result.txt
```

### 권한

`ls -l`의 권한 표기 예시:

```text
-rwxr-xr--

- rwx r-x r-- 
종류, user, group, other로 묶임
```

권한 의미:

- `r` = read = 4
- `w` = write = 2
- `x` = execute = 1

권한 변경:

```bash
chmod +x s.txt
chmod -x s.txt
chmod u+r s.txt
chmod g-w s.txt
chmod 755 s.txt
chmod 750 *.sh
```

### 시스템 정보 확인

```bash
whoami
who
id
uname -a
cat /etc/os-release
df -h
free -h
```

터미널 화면 정리:

```bash
clear
```

명령어 기록 확인:

```bash
history
```

History 활용:

```bash
!103      # 103번째 명령어 실행
!103:p    # 103번째 명령어 출력
!!        # 직전 명령어 다시 실행
!ls       # 가장 최근 ls로 시작한 명령어 실행
sudo !!   # 직전 명령어를 sudo로 실행
```

---

## 4. Git — 버전 관리

### Git 설치

Ubuntu:

```bash
sudo apt install git -y
```

macOS:

```bash
brew install git
```

버전 확인:

```bash
git --version
```

### Git 기본 설정

```bash
git config --global user.name "이름"
git config --global user.email "이메일"
git config --global init.defaultBranch main
git config --list
```

### 저장소 초기화

```bash
cd ~/devops
git init
```

숨김 디렉터리 확인:

```bash
ls -a
```

Git 저장소에는 `.git` 디렉터리가 생성되며 커밋 기록, 브랜치 정보, 설정 등이 저장됩니다.

현재 상태 확인:

```bash
git status
```

`git add`는 파일을 최종 저장하는 명령이 아니라, **다음 Commit에 포함할 변경사항을 Staging Area에 올리는 작업**

### 첫 번째 Commit

```bash
echo "Hello, DevOps!" > text.txt

git status

git add text.txt
git status

git commit -m "first commit"
git log
```

모든 변경사항을 Stage에 올리려면:

```bash
git add .
```

Commit 기록을 간단히 보기:

```bash
git log --oneline
```

### 이전 Commit으로 이동

Commit hash 확인:

```bash
git log --oneline
```

특정 Commit 상태로 이동:

```bash
git switch -d <커밋해시>
```

예:

```bash
git switch -d 7c5bdda
```

### Commit 비교

```bash
git diff <커밋해시1> <커밋해시2>
```

예:

```bash
git diff 01d4 7c5b
```

`git diff` 결과에서:

- `+` : 비교 대상에 새로 추가된 내용
- `-` : 비교 대상에서 삭제된 내용

---

## 5. Git Branch

### Branch 생성 및 이동

새 Branch 생성과 동시에 이동:

```bash
git switch -c <브랜치이름>
```

기존 Branch로 이동:

```bash
git switch <브랜치이름>
```

Branch 목록 확인:

```bash
git branch
```

전체 Branch와 Commit 흐름을 그래프로 확인:

```bash
git log --oneline --all --graph
```

### Branch 실습

```bash
echo "hello" > hello.txt
git add .
git commit -m "hello"

git switch -c hi

echo "hi" > hello.txt
git add .
git commit -m "hello -> hi"

git switch main
cat hello.txt

git switch hi
cat hello.txt

git diff main hi
```

---

## 6. GitHub

- Git Repository 온라인 저장 및 공유
- 여러 사용자와 공동 개발
- Pull Request
- Issue
- Code Review
- GitHub Actions / CI/CD

### GitHub CLI (`gh`) 설치

Ubuntu:

```bash
sudo apt update
sudo apt install gh -y
```

macOS:

```bash
brew install gh
```

설치 확인:

```bash
gh --version
```

### GitHub 로그인

```bash
gh auth login
```

로그인 상태 확인:

```bash
gh auth status
```

### 현재 Git 저장소를 GitHub에 올리기

먼저 현재 위치를 확인합니다.

```bash
pwd
```

현재 로컬 저장소를 새 GitHub Repository와 연결하면서 Push:

```bash
gh repo create <레포이름> --public --source=. --remote=origin --push
```

예:

```bash
gh repo create devops --public --source=. --remote=origin --push
```


이후 변경사항을 GitHub에 반영:

```bash
git add .
git commit -m "메시지"
git push
```

GitHub Repository를 브라우저에서 열기:

```bash
gh repo view --web
```

URL만 확인:

```bash
gh browse --no-browser
```

### 다른 PC에서 Repository 가져오기

```bash
git clone https://github.com/<아이디>/<레포이름>.git
cd <레포이름>
```

작업 후 Push까지 해야 한다면 GitHub 인증도 진행합니다.

```bash
gh auth login
```