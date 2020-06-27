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

## TGI Kubernetes 003 - Istio

* anything with a cluster role has ability to do something cluster wide that's not restricted to a namespace

* Side car - buddy container to the main pod that gives extra capabilities to the main workload

* Zipkin - tracing of a lifecycle of a service call

* kubectl apply creates an update, create does not

* Can run `kubectl delete` to delete deployed objects

TGI Kubernetes 005 - Probes

Liveness Probe
- is the app in a state where it is considered up or down to serve simple requests. Detect if program is in a completely not running state vs running state. More binary of the probes. Used to know when to restart a container


Readiness Probe
- is the app ready to receive traffic? a pod can be alive but not ready. Pod is considered ready when all its containers are ready. When a pod is not ready, it is removed form service load balancers

Startup Probe
- if configured, it disables the other 2 probe checks until it succeeds. Newer type of probe than the other two, and is used specifically for startup
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

---

## RBAC

Roles Definition
  - Resources
  - Verbs

Roles are specific to a namespace, unless a cluster role is created, which applies to the complete cluster.

The role binding is what binds a role to a user or group.

Pods use service accounts to bind to certain roles, so apps can have access to cluster resouces.

Three major parts:
  - subjects (users/groups/serviceaccounts)
  - rules (roles/clusteroles)
  - bindings (clusterrolebindings)

---

### Debugging Tips

`kubectl attach`
  - watch stdout of a container in real time

`kubectl cp`
  - copy files into and out of containers

`kubectl get pods -v 99`

`kubectl explain`
  - get help with structure of a resource
  - `kubectl explaind crd`
  - `kubectl explaind crd.spec`


#### Using curl

```
curl --header "Authorization: Bearer [token]" [API server URL]
```

Building and submitting requests:

  - GET: request is contained in the URL itself (default method) — used to read/list/watch resources
  - POST: submit a data blob to create resources
  - PATCH: submit a data blob to merge-update resources
  - PUT: submit a data blob to replace a resource
  - DELETE: submit options to control deletion of a resource

```
curl --cert client.cert --key client.key --cacert cluster-ca.cert \https://192.168.100.10:6443/api/v1/namespaces/default/pods
```

```
# Add watch=true at the end of the API call

curl --cert client.cert --key client.key --cacert cluster-ca.cert \https://192.168.100.10:6443/api/v1/namespaces/default/pods?watch=true{"type":"ADDED","object":{"kind":"Pod","apiVersion":"v1","metadata":{"name
```

#### openssl
```
openssl verify -CAfile cluster-ca.cert client.cert
```
Some will certify, some don't

```
client.cert: OK

or


O = system:masters, CN = adminerror 20 at 0 depth lookup: unable to get local issuer certificateerror client.cert: verification failed
```


```
# Connect to server manually
openssl s_client -connect URL:6443
```

#### Network Tools
```
dig, tcpdump, netat, ss
```


#### Running Debug Container
