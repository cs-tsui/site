## Summary
Notes from the course [Kubernetes in Depth](https://kube.academy/courses/kubernetes-in-depth)

## Architecture

Master node
* API Server
* Controller Manager
* Scheduler

Worker Node
* kubelet - daemon processes that communicates w/ master node
* k-proxy

APIServer
* Serves API
* Validation
* Reads/writes <> etcd
* APIServer is the only thing that talks to etcd

ETCD
* Run on 3 separate nodes typically (or stacked - same nodes as master/controlplane)

Controller Manager
* Control loop daemon processes, watches etcd via API server
* takes action when they see something to do
* Example - deployment controller, sees a new deployment on ectd, it will create new repset and writes back to etcd. Repset controller now sees the new repset, and will do something else with the info
* control lifecycle of K8s resources (pods, deployments, repsets, etc.)

Scheduler
* After controller writes things back to etc, scheduler comes in and does something with it
* talks to apiserver, which is the front-end for etcd, to find pods that haven't been scheduled, to when it finds appropriate node, it will write node name back to etcd. At this point nothing is deployed yet

Kubelet/Runtime
* CRI kubelet talks to API servre, (node A asks api server, what pods needs to be run and compares status to its current state)

Kube-Proxy
* Runs on each worker node and its job mostly is to program the node's iptables, for routing services traffic, based on the state it gets from API server
* NAT, conntrack


## Networking

Networking in Kube relates and not limited to the following
* Cross node pod communication
* Services discovery
* External access

Network Model with Connectivity Rules:
* Any pod must be able to connect to any pod without NAT
* Any node must be able to to connect to any pod without NAT

CNI - Container Network Interface
* Specification to configure network interfaces in Linux containers
* Concerned with connecting (add) and disconnecting (delete) containers to network
* Multiple CNI plugins can be implemented at the same time in a cluster


## Managing Pods with Kubernetes Deployments
* Deployment -> ReplicaSet -> Pod
* Declarative


`k get componentstatus`

`k get all`

`k edit deployments my-deployment`


#### Pods
* Smallest unit of object K8s manages
* Can contain multiple containers

#### YAML Definition

Kube definition yaml has 4 required top level fields
* apiVersion
* kind
* metadata
* spec

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: nba-ui-pod
  labels:
    app: nba-prediction-app
spec:
  containers:
    - name: nginx-server
      image: nginx
```

Get yaml definition from POD

`kubectl get pod <pod-name> -o yaml > pod-def.yaml`