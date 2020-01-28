/**
 * Class provide REST Webservice that will be open to Use in Sites
 * to enable Web To Any Record feature
 * This clsss is required to be allowed for use in Sites for not authenticated Web Forms.
 *
 * Service will accept request form a generated Web Form to create a record
 * of any given type. Field mapping will be automatic based on the field name in the form
 * that matches teh fields names in the Object.
 * NOTE: HTML Forms cannot validate user input to be of some type therefore assume it is all Text
 * if user has special data types like Date, Numbers, currency to input as part of web form
 * need to provide custom JavaScript or other type of validation l;ogic to HTML page. It will not be 
 * generated automatically
 * https://natsteeldemo-developer-edition.na9.force.com/
 */

@RestResource(urlMapping='/anyobject')
global class WEB_FormAnyObject_REST {

	@HttpPost
	global static String doAnything(RestRequest req, RestResponse resp) {

		// This is documented in Summer 12 REST API Developer Guide but does not work
		// RestContext fields are allways null		
		// RestRequest req = RestContext.request;
	    // RestContext.response.addHeader('Content-Type', 'text/plain');
	    // RestContext.response.responseBody = Blob.valueOf('Hello '+name+' Type: '+o_type);
		
		if (req != null){
			if (req.params != null){
	    		//String name = req.params.get('name');
	    		String o_type = req.params.get('otype');
	    		
	    		String parm = 'params:';
	    		SObject obj = createObject(o_type);
	    		Set<String> keys = req.params.keySet();
	    		for(String s : keys){
	    			if (!s.equalsIgnoreCase('submit') && !s.equalsIgnoreCase('otype') && !s.equalsIgnoreCase('retURL') && !s.equalsIgnoreCase('encoding')){
	    				String val = req.params.get(s);
	    				if (val != null && val.length() > 0) 
	    					obj.put(s,val); 
	    			}
	    			parm += ' '+s+': '+req.params.get(s);
	    		}
	    		insert obj;
	    		
	    		return 'Success: Created record of Type: '+o_type;
			}else{
				String uri = req.requestURI;
				return 'ERROR: Request Parameters not found. URI: '+uri;
			}
		}else{
			return 'ERROR: Request object not found';
		}
	}

	private static SObject createObject(String typeName) {
        Schema.SObjectType targetType = Schema.getGlobalDescribe().get(typeName);
        if (targetType == null) {
            // throw an exception 
    
        }
		return targetType.newSObject();
	}

  @isTest
  public static void testWEBForm2AnythingController(){
  	
  	// Prep data
  	RestRequest req = new RestRequest(); 
  	RestResponse resp = new RestResponse();
  	//String s = WEB_FormAnyObject_REST.doAnything(req, resp);
  	req.params.put('otype','Account');
  	req.params.put('name','ai_Web2AnyTest');
  	
  	String s = WEB_FormAnyObject_REST.doAnything(req, resp);
  	  	
  }

}