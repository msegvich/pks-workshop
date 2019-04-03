### Lab Exercise: Logging
If you haven't done so already work through the [Cat demo](../PythonHarbor/) as that creates the namespace that the sink will need as well as deploy an application that will generate logs.

Update the sink resource definition under ../Logging/Step_1_create_sink.yml to use the namespace you created earlier.  Then create a log sink.

<pre>
kubectl create -f Step_1_create_sink.yml
</pre>

To view logs go to http://kibana.pks.cfrocket.com and filter on your namespace or other criteria.
