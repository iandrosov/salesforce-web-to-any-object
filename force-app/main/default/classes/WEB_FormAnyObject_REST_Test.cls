@isTest
private class WEB_FormAnyObject_REST_Test {
@isTest
  public static void testWEBForm2AnythingController(){
  	
  	// Prep data
  	RestRequest req = new RestRequest(); 
  	RestResponse resp = new RestResponse();
  	//String s = WEB_FormAnyObject_REST.doAnything(req, resp);
  	req.params.put('otype','Account');
  	req.params.put('name','ai_Web2AnyTest');
  	
  	String s = WEB_FormAnyObject_REST.doAnything();
  	  	
  }
}