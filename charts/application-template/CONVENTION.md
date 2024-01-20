# Convention

## Application Labels

### Common Labels

| Name | Required | Description | Example |
| ---- | ------ | --- | --- |
| app.kubernetes.io/name | true | 차트 내 실행단위(`Deployment`, `StatefulSet`, `Rollout` 등)에 Specific 하도록 사용 | `document-server`, `document-worker`, `document-scheduler` |
| helm.sh/chart | true | 해당 차트를 만든 정보 `{{ .Chart.Name }}-{{ .Chart.Version \| replace "+" "_" }}` | `application-template-1.3.0` |
| app.kubernetes.io/managed-by | true | 항상 `{{ .Release.Service }}` 로 설정해야 한다. 헬름이 관리하는 모든 것을 찾기 위한 것| `Helm` |
| app.kubernetes.io/instance | true | `{{ .Release.Name }}` 이어야 한다. 최상위 애플리케이션의 다른 인스턴스들을 구별하기 위해 사용 | `document`, `user` |
| app.kubernetes.io/version | true | 차트 내 실행단위(`Deployment`, `StatefulSet`, `Rollout` 등)의 Version, 현재 1개의 image로 3개의 component를 실행하기에 모두 같음 | `7.3.1` |
| app.kubernetes.io/component | true | 차트 내 실행 단위와 연관된 HighLevel 컴포넌트를 사용, 현재는 `app.kubernetes.io/name`과 유사 | `server`, `scheduler`, `worker` |
| app.kubernetes.io/part-of | true | 최상위 애플리케이션의 이름 | `document`, `user` |

### Customize Labels

| Name | Required | Description | Example |
| ---- | ------ | --- | --- |
| app.modusign.co.kr/zone | true | [Customize] 애플리케이션 env 하위 환경 실행 Zone | `default`, `dev`, `org3`, etc |
| app.kubernetes.io/env | true | [Customize] 애플리케이션 실행환경 | `prod`, `stage`, `dev` |
| app | true | [Customize] 애플리케이션 Name | `document-server` |
| version | true | [Customize] 애플리케이션 Name | `7.3.1` |
| env | true | [Customize] 애플리케이션 실행환경 | `prod`, `stage`, `dev` |
| tags.datadoghq.com/env | true | [Datadog] 애플리케이션 실행환경 | `prod`, `stage`, `dev` |
| tags.datadoghq.com/service | true | [Datadog] 최상위 애플리케이션의 이름 | `document`, `user` |
| tags.datadoghq.com/version | true | [Datadog] 애플리케이션 버전 정보, 현재 1개의 image로 3개의 component를 실행하기에 모두 같음 | `7.3.1` |
