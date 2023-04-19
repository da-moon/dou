helm repo add gitlab https://charts.gitlab.io

kubectl apply -f token.yaml -n gitlab-runner

helm install --namespace gitlab-runners <YOUR_RUNNER_NAME> -f values.yaml gitlab/gitlab-runner

