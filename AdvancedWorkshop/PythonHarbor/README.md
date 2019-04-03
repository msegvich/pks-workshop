## Pivotal Container Service Workshop
This is a sample SpringBoot application that performs Geo Bounded queries against an Elastic Search instance and plots the data on a map interactively. This application can be run on a workstation or in a cloud environment such as Cloud Foundry. In this example, I will show how to deploy the application on a running Cloud Foundry instance.
<!-- TOC depthFrom:3 depthTo:6 withLinks:1 updateOnSave:1 orderedList:0 -->

- [1. Install and Setup CLIs](#1-install-and-setup-clis)
	- [Install PKS CLI](#install-pks-cli)
	- [Install kubectl CLI](#install-kubectl-cli)
- [2. Cluster Access and Validation](#2-cluster-access-and-validation)
	- [Get Cluster Credentials](#get-cluster-credentials)
	- [Validating your Cluster](#validating-your-cluster)
- [3. Lab Exercise: Set Environment Variables](#3-lab-exercise-set-environment-variables)
- [4. Lab Exercise: Deploy A Python application with Harbor Registry Backend](#4-lab-exercise-deploy-a-python-application-with-harbor-registry)

<!-- /TOC -->
### 1. Install and Setup CLIs
#### Install PKS CLI
In order to install the PKS CLI please follow these instructions: https://docs.pivotal.io/runtimes/pks/1-2/installing-pks-cli.html#windows. Note, you will need to register with network.pivotal.io in order to download the CLI.

Download from: https://network.pivotal.io/products/pivotal-container-service/

#### Install kubectl CLI
You can install the kubectl CLI from PivNet as well, https://network.pivotal.io/products/pivotal-container-service

What you download is the executable. After downloading, rename the file to `kubectl`, move it to where you like and make sure it's in your path.

For reference, here are some other ways to install, https://kubernetes.io/docs/tasks/tools/install-kubectl

### 2. Cluster Access and Validation
#### Get Cluster Credentials
You will need to retrieve the cluster credentials from PKS. First login using the the PKS credentials that were provided to you for this lab exercise.

<pre>
pks login -a api.pks.pcf-apps.com -u appdev -p $PKS_PW -k
</pre>

Now you can retrive your Kubernetes cluster credentials. Please use the cluster name that was provided to you for this lab exercise.

<pre>
pks get-credentials $PKS_CLUSTER_NAME
</pre>

#### Validating your Cluster
Ensure that you can access the API Endpoints on the Master
<pre>kubectl cluster-info</pre>

You should see something similar to the following:
<pre>
Kubernetes master is running at https://demo1.pks.pcfdemo.pcfapps.org:8443
Heapster is running at https://demo1.pks.pcfdemo.pcfapps.org:8443/api/v1/namespaces/kube-system/services/heapster/proxy
KubeDNS is running at https://demo1.pks.pcfdemo.pcfapps.org:8443/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy
kubernetes-dashboard is running at https://demo1.pks.pcfdemo.pcfapps.org:8443/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy
monitoring-influxdb is running at https://demo1.pks.pcfdemo.pcfapps.org:8443/api/v1/namespaces/kube-system/services/monitoring-influxdb/proxy
</pre>

### 3. Lab Exercise: Set Environment Variables

Prerequisite: Initialize the environment with your credentials for the registry. Please use the account and user index that was provided to you for this lab exercise.

Unix/Mac
<pre>
export USER_INDEX="1"
export HARBOR_REGISTRY_URL="harbor.pks.pcf-apps.com"
export HARBOR_USERNAME="developer"
export HARBOR_PASSWORD="Pivotal1"
export HARBOR_EMAIL="dev@acme.org"
export PKS_API=api.pks.pcf-apps.com
export PKS_CLUSTER=user$USER_INDEX.pks.pcf-apps.com
</pre>

Windows PowerShell
<pre>
$env:USER_INDEX="1"
$env:HARBOR_REGISTRY_URL="harbor.pks.cfrocket.com"
$env:HARBOR_USERNAME="developer"
$env:HARBOR_PASSWORD="Pivotal1"
$env:HARBOR_EMAIL="dev@acme.org"
</pre>

### 4. Lab Exercise: Deploy A Python application with Harbor Registry
1. **(Skip this step)** Create a user defined Namespace. Note: Update the command below to use the namespace that you are going to be delpoying into.
<ul>Unix/Mac
<pre>kubectl create namespace cats-$(echo $USER_INDEX)
kubectl config set-context $(kubectl config current-context) --namespace=cats-$(echo $USER_INDEX)
</pre></ul>

<ul>Windows PowerShell
<pre>kubectl create namespace cats-$(echo $env:USER_INDEX)
kubectl config set-context $(kubectl config current-context) --namespace=cats-$(echo $env:USER_INDEX)
</pre></ul>


2. Create Harbor Registry Secret. Use the Registry credentials that was provided to you for this step.
<ul>Unix/Mac
<pre>kubectl create secret docker-registry harborsecret --docker-server="$(echo $HARBOR_REGISTRY_URL)" --docker-username="$(echo $HARBOR_USERNAME)" --docker-password="$(echo $HARBOR_PASSWORD)" --docker-email="$(echo $HARBOR_EMAIL)"</pre>
</ul>

<ul>Windows PowerShell
<pre>kubectl create secret docker-registry harborsecret --docker-server="$(echo $env:HARBOR_REGISTRY_URL)" --docker-username="$(echo $env:HARBOR_USERNAME)" --docker-password="$(echo $env:HARBOR_PASSWORD)" --docker-email="$(echo $env:HARBOR_EMAIL)"</pre>
</ul>

3. Deploy the Python app
<ul><pre>kubectl create -f https://raw.githubusercontent.com/msegvich/pks-workshop/master/AdvancedWorkshop/PythonHarbor/Step_0_python-deployment.yml</pre></ul>

4. Expose the Service
<ul>NodePort
<pre>kubectl create -f https://raw.githubusercontent.com/msegvich/pks-workshop/master/AdvancedWorkshop/PythonHarbor/Step_1_python-service_np.yml</pre></ul>

<ul>To get to the app you can use port-forward:
<pre>
kubectl port-forward svc/cats-service 7090:80
</pre></ul>

<ul>Or you can use a LoadBalancer
<pre>
kubectl create -f https://raw.githubusercontent.com/msegvich/pks-workshop/master/AdvancedWorkshop/PythonHarbor/Step_1_python-service_lb.yml
</pre></ul>

5. Auto-Scale the Frontend
<ul><pre>kubectl autoscale deployment cats --cpu-percent=50 --min=3 --max=6</pre></ul>

6. Leave this deployment running as we will use it in the next exercise.
