### Lab Exercise: Logging

Update the sink resource definition under ../Logging/Step_1_create_sink.yml to use the namespace you created earlier.  Then create a log sink.

<pre>
kubectl create -f Step_1_create_sink.yml
</pre>

To view logs go to http://kibana.pks.cfrocket.com and filter on your namespace or other criteria.
