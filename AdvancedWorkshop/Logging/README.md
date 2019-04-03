### Lab Exercise: Set Environment Variables
Prerequisite: Initialize the environment with your credentials for the registry. Please use the account and user index that was provided to you for this lab exercise.

On you command line terminal go to pks-workshop/AdvancedWorkshop/Setup and edit the setup_env_vars.sh with the correct setting for USER_INDEX and PKS_PW.  Ask you instructor for these if they aren't already set (if using a jumpbox).

If using Linux run the following. **Note if you've already run this, you don't need to run it again as it set the variables for all the exercises.**
<pre>
. ./setup_env_vars.sh
</pre>

If you need to manually set this up or have Windows:
### Lab Exercise: Logging
If you haven't done so already work through the [Cat demo](../PythonHarbor/) as that creates the namespace that the sink will need as well as deploy an application that will generate logs.

Update the sink resource definition under ../Logging/Step_1_create_sink.yml to use the namespace you created earlier.  Then create a log sink.

<pre>
kubectl create -f Step_1_create_sink.yml
</pre>

To view logs go to http://kibana.pks.cfrocket.com and filter on your namespace or other criteria.
