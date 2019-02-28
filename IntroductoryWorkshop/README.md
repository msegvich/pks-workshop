## Pivotal Container Service Workshop
This is a sample SpringBoot application that performs Geo Bounded queries against an Elastic Search instance and plots the data on a map interactively. This application can be run on a workstation or in a cloud environment such as Cloud Foundry. In this example, I will show how to deploy the application on a running Cloud Foundry instance.
<!-- TOC depthFrom:3 depthTo:6 withLinks:1 updateOnSave:1 orderedList:0 -->

- [1. Install and Setup CLIs](#1-install-and-setup-clis)
	- [Install PKS CLI](#install-pks-cli)
	- [Install kubectl CLI](#install-kubectl-cli)
- [2. Cluster Access and Validation](#2-cluster-access-and-validation)
	- [Get Cluster Credentials](#get-cluster-credentials)
	- [Validating your Cluster](#validating-your-cluster)
	- [Accessing the Dashboard](#accessing-the-dashboard)
- [3. Lab Exercise: Deploy A SpringBoot application with an Elastic Search Backend](#3-lab-exercise-deploy-a-springboot-application-with-an-elastic-search-backend)

<!-- /TOC -->
### 1. Install and Setup CLIs
### NOTE: Proceed to [2. Cluster Access and Validation](#2-cluster-access-and-validation) if you are sshing into the provided jumpbox. You only need to do this if you use your local machine.

#### Install PKS CLI
In order to install the PKS CLI please follow these instructions: https://docs.pivotal.io/runtimes/pks/1-2/installing-pks-cli.html#windows. Note, you will need to register with network.pivotal.io in order to download the CLI.

Download from: https://network.pivotal.io/products/pivotal-container-service/

#### Install kubectl CLI
You can install the kubectl CLI from PivNet as well, https://network.pivotal.io/products/pivotal-container-service

What you download is the executable. After downloading, rename the file to `kubectl`, move it to where you like and make sure it's in your path.

For reference, here are some other ways to install, https://kubernetes.io/docs/tasks/tools/install-kubectl

### 2. Cluster Access and Validation

#### ssh Into the Jumpbox

There are few ways to do this.  If you have ssh locally you can access the jumpbox through that method. Ensure your private key has no file extension and has read-only permissions (400).

<pre> ssh -i path_to_cert user#@jumpbox.aws.pcfapps.org -p 2222 </pre>

Otherwise you can you can use Chrome's [Secure Shell](https://chrome.google.com/webstore/detail/secure-shell-app/pnhechapfaindjhompbnflcldabbghjo?hl=en).

#### Get Cluster Credentials
You will need to retrieve the cluster credentials from PKS. First login using the the PKS credentials that were provided to you for this lab exercise.

<pre>
pks login -a api.pks.pcfdemo.pcfapps.org -u USERNAME -p PASSWORD -k
</pre>

Now you can retrive your Kubernetes cluster credentials. Please use the cluster name that was provided to you for this lab exercise.  If you get prompted for a password, use the password you used for logging into the API.

<pre>
pks get-credentials CLUSTER-NAME
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

### 3. Lab Exercise: Deploy A SpringBoot application with an Elastic Search Backend
1. A StorageClass and volume have already been provisioned for the Cluster. This is provisioned at the Kubernetes cluster level and therefore no need to namespace qualify it.

2. Create a new Service Account and Image pull secret
<ul>Unix/Mac
<pre>
kubectl create serviceaccount userserviceaccount
</pre></ul>

<ul>Windows PowerShell
<pre>
kubectl create serviceaccount userserviceaccount
</pre></ul>

3. Deploy Elastic Search
<ul><pre>kubectl create -f https://raw.githubusercontent.com/msegvich/pks-workshop/master/IntroductoryWorkshop/Step_2_DeployElasticSearch.yaml</pre></ul>

4. Expose the Elastic Search Service
<ul><pre>kubectl create -f https://raw.githubusercontent.com/msegvich/pks-workshop/master/IntroductoryWorkshop/Step_3_ExposeElasticSearch.yaml</pre></ul>

5. Load the Data via a Job
<ul><pre>kubectl create -f https://raw.githubusercontent.com/msegvich/pks-workshop/master/IntroductoryWorkshop/Step_4_LoadData.yaml</pre></ul>

6. Deploy the SpringBoot Geosearch Application
<ul><pre>kubectl create -f https://raw.githubusercontent.com/msegvich/pks-workshop/master/IntroductoryWorkshop/Step_5_DeploySpringBootApp.yaml</pre></ul>

7. Expose the SpringBoot Application. This can be done in a couple of ways. We will look at two ways of doing it in this example.

<ul>Exposing with a Service
	<pre>kubectl create -f https://raw.githubusercontent.com/msegvich/pks-workshop/master/IntroductoryWorkshop/Step_6_ExposeSpringBootAppNodePort.yaml</pre>
</ul>

<ul>Exposing with the Ingress - If you're on the jumpbox, you can use the local file.
	<pre>
		kubectl apply -f Step_6_ExposeSpringBootAppIngressWithJenkins.yaml
	</pre>
</ul>

<ul>
	If you are using kubectl locally from your laptop you will need to edit the yaml to update the URL for the host to match your cluster name, e.g. democluster1.
	<pre>kubectl apply -f Step_6_ExposeSpringBootAppIngressWithJenkins.yaml</pre>
</ul>

8. Auto-Scale the Frontend
<ul><pre>kubectl autoscale deployment geosearch --cpu-percent=70 --min=3 --max=10</pre></ul>

#### Other things to try if you have kubectl locally
#### Accessing the Dashboard

To access Dashboard from your local workstation you must create a secure channel to your Kubernetes cluster and retrieve a token. Run the following commands:

<pre>kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep tiller | awk '{print $1}')</pre>

<pre>kubectl proxy</pre>

Now access Dashboard at:

http://localhost:8001/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/.

When prompted for choosing either the Kubeconfig or Token, choose Kubeconfig.  You will need to browse to HOME-DIR/.kube and select the file named `config`.

On Windows, you may want to use Firefox or Chrome as Explorer has some issues.
