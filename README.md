# sfdx-b2b-apis

Salesforce DX project that has apex actions for calling the Salesforce B2B Commerce REST API. 

As of the Salesforce Winter '21 release, the B2B Commerce doesn't provide an Apex API, but you can write Apex callouts to the REST API. Follow these instructions first for setting up a named credential so that Apex callouts can call back into the same org for calling the REST API: https://github.com/forcedotcom/b2b-commerce-on-lightning-quickstart/blob/master/examples/lwc/docs/NamedCredentials.md

The code in this project makes callouts to a named credential named 'B2B_API' to make a callout to this API for rebuilding a store product catalog search index: 
https://developer.salesforce.com/docs/atlas.en-us.chatterapi.meta/chatterapi/connect_resources_commerce_webstore_search_indexes.htm 


## Development

To work on this project in a scratch org:

1. [Set up CumulusCI](https://cumulusci.readthedocs.io/en/latest/tutorial.html)
2. Run `cci flow run dev_org --org dev` to deploy this project.
3. Run `cci org browser dev` to open the org in your browser.