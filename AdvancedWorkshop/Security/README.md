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
- [4. Lab Exercise: LDAP Demo Backend](#4-lab-exercise-ldap-demo)

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
pks login -a api.pks.pcf-apps.com -u USERNAME -p PASSWORD -k
</pre>

Now you can retrive your Kubernetes cluster credentials. Please use the cluster name that was provided to you for this lab exercise.

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

### 3. Lab Exercise: Set Environment Variables

Prerequisite: Initialize the environment with your credentials for the registry. Please use the account and user index that was provided to you for this lab exercise.

On you command line terminal go to pks-workshop/AdvancedWorkshop/Setup and edit the setup_env_vars.sh with the correct setting for USER_INDEX and PKS_PW.  Ask you instructor for these if they aren't already set (if using a jumpbox).

If using Linux run the following. **Note if you've already run this, you don't need to run it again as it set the variables for all the exercises.**
<pre>
. ./setup_env_vars.sh
</pre>

If you need to manually set this up or have Windows:

Unix/Mac
<pre>
export USER_INDEX="1"
export PKS_API=api.pks.pcf-apps.com
export PKS_CLUSTER_NAME=user$USER_INDEX
export PKS_CLUSTER=$PKS_CLUSTER_NAME.pks.pcf-apps.com
</pre>

Windows PowerShell
<pre>
$env:USER_INDEX="1"
$env:PKS_API=api.pks.pcf-apps.com
$env:PKS_CLUSTER_NAME=user$(echo $env:USER_INDEX)
$env:PKS_CLUSTER=$(echo $env:PKS_CLUSTER_NAME).pks.pcf-apps.com
</pre>

### 3. Lab Exercise: LDAP Demo
Log in to PKS

<pre>
pks login -a api.pks.pcf-apps.com -u appdev -p $PKS_PW -k
</pre>

#### PKS UAA Setup [Alana]
**Skip this step, but read for background**
Once PKS is deployed, it is necessary to map the PKS roles to proper LDAP groups. There are two groups defined in the LDAP server currently used.  This mapping has already been done.

Map pks.clusters.admin role to LDAP group
<pre>
$ uaac group map --name pks.clusters.admin cn=admins,ou=Users,o=5c47a06ee9b8fd1a431810a2,dc=jumpcloud,dc=com
</pre>

Map pks.clusters.manage role to LDAP group
<pre>
$ uaac group map --name pks.clusters.manage cn=developers,ou=Users,o=5c47a06ee9b8fd1a431810a2,dc=jumpcloud,dc=com
</pre>

#### Creation of a Kubernetes cluster [Cody]
This was already done in advance.  To see info about your cluster run the following.

<pre>
pks cluster $PKS_CLUSTER_NAME
</pre>

#### Role definition in Kubernetes [Cody]
<pre>
pks get-credentials $PKS_CLUSTER_NAME
</pre>

Create and apply a role definition

<pre>
kubectl apply -f Step_1_pod-role-spec.yml
</pre>

#### Role assignment to Naomi [Cody]
**Ask your instructor for the PKS_PW env variable.**

Once the role is defined, the development team manager (Cody) can assign this role to individuals in his team. Please note that these individuals are not part of the “developers” LDAP group and therefore cannot sign into PKS. You can demonstrate this by typing the command:
<pre>
pks login -a $PKS_API -u appdev02 -p $PKS_PW -k
</pre>

To give access rights to Naomi (appdev02), Cody needs to apply another RBAC configuration file (assign-pod-role.yml) to the Kubernetes cluster.

<pre>
kubectl apply -f Step_2_assign-pod-role.yml
</pre>

#### Kubernetes developer access [Naomi]
In order to access the Kubernetes cluster deployed by Cody, Naomi now needs to retrieve a proper Kubernetes config file with an access token. This config file includes information provided by the cluster manager, and the user itself.

To get this run the following:
<pre>
./get-pks-k8s-config.sh --API=$PKS_API --CLUSTER=$PKS_CLUSTER --USER=appdev02 --NS=default
Password: $PKS_PW
</pre>

This command will create a config file in the ~/.kube folder. This config file will contain the token and refresh token necessary for the user to access the Kubernetes cluster.

You can then demonstrate the Kubernetes RBAC feature by running the following two commands:

<pre>
kubectl get pods
No resource found.
</pre>

<pre>
kubectl get nodes
Error from server (Forbidden): nodes is forbidden: User "appdev02" cannot list nodes at the cluster scope
</pre>

In our current setup, Naomi (appdev02) is only allowed to “watch pods”, as highlighted in the pod-role-spec.yml configuration file. To demonstrate that Kubernetes RBAC is fully in action, you can apply other yml files to allow Naomi to “watch” the nodes.

To do so, you will first need to log into PKS as Cody (appdev) and apply two new yml definitions, this time at the Cluster level.

<pre>
pks login -a api.pks.pcf-apps.com -u appdev -p $PKS_PW -k
pks get-credentials $PKS_CLUSTER_NAME
kubectl apply -f Step_3_cluster-role-spec.yml
kubectl apply -f Step_4_assign-cluster-role.yml
</pre>

Then, retrieve the Kubernetes config file using the get-pks-k8s-config.sh script to impersonate Naomi (appdev02).
You should now be able to run the “kubectl get nodes” command.

<pre>
./get-pks-k8s-config.sh --API=$PKS_API --CLUSTER=$PKS_CLUSTER --USER=appdev02 --NS=default
Password: $PKS_PW

kubectl get nodes
</pre>

You have completed this workshop.  The other Labs will require you to act as Cody so login as him.

<pre>
pks login -a api.pks.pcf-apps.com -u appdev -p $PKS_PW -k
pks get-credentials $PKS_CLUSTER_NAME
</pre>
