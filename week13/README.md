# Week 13 : GitOps

## GitOPs 

```
클러스터 내 에이전트가 Git을 지켜보다가 바뀌면 적용
```

## Drift

```
클러스터의 내용을 변경하면 Drift발생
Git과 다르기에 OUtOFSYnc 발생
```

## ArgoCD

```
Arcgo CD 설치 
argocd-application.yaml을 통해 애플리케이션 등록(프로젝트 폴더 바깥)
```

## 관측 수단

```
Metrics : 숫자 - Prometheus
Logs : 텍스트 기록 - Loki, ELK
Traces : 요청의 여정 - Jaeger
```

## 골든 시그널

```
지연 latency : 응답이 얼마나 느린가
트래픽 traffic : 요청이 얼마나 많은가
에러 errors: 실패가 얼마나 나는가
포화 saturation : 자원이 얼마나 꽉 찼는가
```


