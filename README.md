# modusign-helm
Modusign helm chart repository

## Add helm repository
```
helm repo add modusign-helm https://modusign.github.io/modusign-helm/
helm repo update
helm search repo modusign-helm
```

## Add/Upgrade helm chart
- `/charts` 하위에 차트 추가/수정
- Chart.yaml 에서 version 정보 수정
- main 을 base로 squash merge

## Release helm chart
- release workflow 에 의해 자동화 되어있습니다.
- 이 workflow 는 Chart.yaml에 version 이 수정되었을때 트리거됩니다.
- release 결과는 gh-page가 배포 완료 된 후 사용가능합니다.