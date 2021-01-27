# sfdx-b2b-apis

Salesforce DX project that has apex actions for calling the Salesforce B2B Commerce REST API. 

As of the Salesforce Winter '21 release, the B2B Commerce doesn't provide an Apex API, but you can write Apex callouts to the REST API. The code in this project makes callouts to a named credential named 'B2B_API' to make a callout to this API for rebuilding a store product catalog search index: 
https://developer.salesforce.com/docs/atlas.en-us.chatterapi.meta/chatterapi/connect_resources_commerce_webstore_search_indexes.htm 

The Apex has these two depenencies:

1. Follow these instructions for setting up a named credential so that Apex callouts can call back into the same org for calling the REST API: https://github.com/forcedotcom/b2b-commerce-on-lightning-quickstart/blob/master/examples/lwc/docs/NamedCredentials.md

2. Your org must have Salesforce B2B Commerce installed and configured. Specifically, it needs access to the the object WebStoreNetwork. 