# Kubernetes in Depth
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


## Kubernetes Namespaces

`kubectl api-resources`

Not all resources can be namespaced. Cluster administrative type resources typically are not namespaced.

While we have namespaces to logically separate pods and other resources, unless policies are added to restrict access, resources have access to namespaces and their resources.


Deleting namespaces will remove all of its objects, but not the ones that it may be associated with but don't belong to any namespaces (PVs and Nodes)

	k delete ns dev


# TGI Kubernetes

## TGI Kubernetes 002 - Networking and Services

```
# See Calico config file
cat /etc/cni/net.d/10-calico.conf
```

```
# CNI bin dir
/opt/cni
```

Services

* External Name -  use kube for service discovery, but point it at something outside the cluster. Can point at DNS name to access outside resources.

* None - create a name service, with selector there that "points" to the pods. Basis for a named label query. Kubernetes collects this information into a different API object.
  * Service/endpoint allows a decoding of a named service into a set of IP addresses
  * service API with endpoint API is how kubernetes does service discovery
  * `kubectl get endpoints <servicename>`

* ClusterIP - creates a VIP from a separate IP range from pod IPS for the service. IP will not change for the life of the service
  * kube-proxy on every node
    * k get pods -n kube-system will show kube-proxy pods (if using daemon set to run on every node)
    * Can run outside of kubernetes without daemon set
    * Configures IP tables based on service definition on very node, and each node will forward the traffic to an IP that is under the service set based on probability
    * `iptables -L`

* NodePort - anyone hitting a cluster node on a particular port assigned to the service can talk to the service
  * `curl <pod-ip>:8080/env/api` to get pod env information

* LoadBalancer - built on top of nodeport. If configured properly, the loadbalancer will point to the nodes in the cluster, and forward traffic to a the node port. After it hits the port on some node, it will then be forwarded to some pod on the cluster. Later versions of kubernetes has a more direct way to connect external traffic to the pods with less hops

* TODO: review iptables and watch pattern



---

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