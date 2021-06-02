## Dependencies

### Install Docker
 * https://docs.docker.com/get-docker/

### Install Minikube and create k8s cluster
 * https://minikube.sigs.k8s.io/docs/start/

### Install Helm
 * https://helm.sh/docs/intro/install/

### Install Kubectl
 * https://kubernetes.io/docs/tasks/tools/

### FluentD Helm Chart Reference
 * https://github.com/bitnami/charts/tree/master/bitnami/fluentd/#installing-the-chart

## Elasticsearch
Create an Aiven Elasticsearch service. Take note of the 
host, port, username and password. These will be added to 
`k8s-logging-demo/chart/values.yaml` or they can be specified via
CLI.


## API
Build the api locally
```bash
cd k8s-logging-demo
docker build -t local/log-demo .
```

## Build and Deploy
Add and Update Helm Dependencies
```bash
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
helm dependency update chart
```

Point your shell to minikube's docker-daemon, run:
```bash
eval $(minikube -p minikube docker-env)
``` 

Install the Helm Chart
```bash
helm install -n logging log-demo chart \
--set elasticsearch.hosts=<ES Host> \
--set elasticsearch.pw=<ES Password>
```

## Viewing Logs
Open Kibana and check discovery. You will see kube system 
logs in the dashboard

Port forward the API
```bash
kubectl port-forward -n logging svc/api-service 8080:8080
```

Make a curl request
```bash
curl -X POST localhost:8080/echo -d'{"key": "HELLO THERE"}'
```

You should be able to see a logged warning message from the
api that has the payload in it.


## Optional Configurations
You can enable Kafka output as well. Add the following to the 
helm command
```
kafka_broker=<host>:<port>
kafka_user=user
kafka_pw=password
kafka_ca_cert='
<Certificate Contents>
'

--set kafka.brokers=$kafka_broker \
--set kafka.user=$kafka_user \
--set kafka.pw=$kafka_pw \
--set kafka.caCert=$kafka_ca_cert \
--set kafka.enabled=true
```

To turn either of kafka or elasticsearch output off
jsut set their enabled flag to `false`
