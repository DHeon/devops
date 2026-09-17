#!/bin/bash
cd "$(dirname "$0")" || exit 1
if ! command -v python3 >/dev/null 2>&1; then
    echo "Python3가 설치도어있지 않음" >&2
    exit
fi
exec python3 chat.py
echo "End"
