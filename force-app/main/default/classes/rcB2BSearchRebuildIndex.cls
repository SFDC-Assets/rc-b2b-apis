public with sharing class rcB2BSearchRebuildIndex {

    // cached API version of this apex class.
    private static Decimal apiVersion = [SELECT ApiVersion FROM ApexClass WHERE Name = 'rcB2BSearchRebuildIndex'
        WITH SECURITY_ENFORCED LIMIT 1].ApiVersion;

	@InvocableMethod(label='B2B: Build Store Search Index')
    public static List<String> action_buildStoreSearchIndex(List<String> communityName) {  
        List<String> responseList = new List<String>();

        for (String commName : communityName) {
            System.debug('rcB2BSearchRebuildIndex > action_buildStoreSearchIndex - communityName: ' + commName); 
            String response;
            try {
        		response = buildStoreSearchIndex(commName);
            } catch (System.Exception e) {
                System.debug('rcB2BSearchRebuildIndex > action_buildStoreSearchIndex - error: ' + e);
                response = 'ERROR: ' + e.getMessage();
            }
            responseList.add(response);
        } 
        
        System.debug('rcB2BSearchRebuildIndex > action_buildStoreSearchIndex - responseList: ' + responseList);
        return responseList;
    }        
    
    @AuraEnabled(cacheable=true)    
    public static String getCommunityId(String communityName) {
    	System.debug('rcB2BSearchRebuildIndex > getCommunityId - communityName: ' + communityName);
        
        ConnectApi.CommunityPage communityPageList = ConnectApi.Communities.getCommunities();
        List<ConnectApi.Community> communityList = communityPageList.communities;
        
        String communityId;
        for (ConnectApi.Community community : communityList) {
            //System.debug('community: ' + community);
            if (community.name == communityName) {
                communityId = community.id;
            }
             
        }
        System.debug('rcB2BSearchRebuildIndex > getCommunityId - communityName: ' + communityName + ', communityId: ' + communityId);
        return communityId;
    } 

    @AuraEnabled(cacheable=true)    
	public static String getWebstoreId(String communityId) {
    	System.debug('rcB2BSearchRebuildIndex > getWebstoreId - communityId: ' + communityId);
        String webStoreId = 'comment out this line and replace below';
        //String webStoreId = [SELECT WebStoreId FROM WebStoreNetwork WHERE NetworkId = :communityId WITH SECURITY_ENFORCED LIMIT 1].WebStoreId;
        System.debug('rcB2BSearchRebuildIndex > getWebstoreId - communityId: ' + communityId + ', webStoreId: ' + webStoreId);
      	return webStoreId;
    } 
    
    public static String buildStoreSearchIndex(String communityName) {
 
        System.debug('rcB2BSearchRebuildIndex > buildStoreSearchIndex - communityName: ' + communityName);
        
		String defaultCommunityName = 'B2B Commerce Lightning Experience';
        String namedCredential = 'callout:B2B_API';
        
        // webstoreId
        if (communityName == null) {
            communityName = defaultCommunityName;
            System.debug('rcB2BSearchRebuildIndex > buildStoreSearchIndex - using default communityName: ' + communityName);
        }
		String communityId = rcB2BSearchRebuildIndex.getCommunityId(communityName);
        String webstoreId = getWebstoreId(communityId);

        // endpoint
        // see API: https://developer.salesforce.com/docs/atlas.en-us.chatterapi.meta/chatterapi/connect_resources_commerce_webstore_search_indexes.htm       
        String endpoint = namedCredential + '/services/data/v' + apiVersion 
            + '/commerce/management/webstores/' + webstoreId + '/search/indexes';

        HttpRequest httpRequest = new HttpRequest();
        httpRequest.setMethod('POST');
        httpRequest.setHeader('Content-Type','application/json;  charset=utf-8');
        httpRequest.setEndpoint(endpoint);
        //httpRequest.getBody();
		String response;
        
        try {
            Http http = new Http();
            HttpResponse httpResponse = http.send(httpRequest);
            Integer statusCode = httpResponse.getStatusCode();
            System.debug('rcB2BSearchRebuildIndex > buildStoreSearchIndex - statusCode: ' + statusCode);

            if (statusCode >= 200 && statusCode <= 204) {
                //Object response = JSON.deserializeUntyped(httpResponse.getBody());
                response = httpResponse.getBody();
                System.debug('rcB2BSearchRebuildIndex > buildStoreSearchIndex - statusCode: ' + statusCode + ', response: ' + response);
            } else {
                throw new CalloutException(httpResponse.getBody());
            }
        } catch (System.Exception e) {
            System.debug('rcB2BSearchRebuildIndex > buildStoreSearchIndex - error: ' + e);
            throw e;
        }

        return response;
    } 
    
} // end rcB2BSearchRebuildIndex