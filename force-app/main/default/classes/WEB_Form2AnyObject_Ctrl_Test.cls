@isTest
private class WEB_Form2AnyObject_Ctrl_Test {

  @isTest
  public static void testWEBForm2AnythingController(){
  	WEB_Form2AnyObject_Ctrl myController = new WEB_Form2AnyObject_Ctrl();
  	
  	List<SelectOption> siteOptions = myController.getSiteURL();
  	List<SelectOption> objectOptions = myController.getObjectList();
  	myController.selectedObject = 'Account';
  	myController.selectedSiteURL = 'https://natsteeldemo-developer-edition.na9.force.com/';
  	List<SelectOption> fldList = myController.getFieldList();
  	myController.selectedFields = new String[]{'name'};
  	String html = myController.getWebFormHTML();
  	
  	PageReference pr = myController.updateObjectFields();
  	pr = myController.createWebForm();  	
  
  }
} 