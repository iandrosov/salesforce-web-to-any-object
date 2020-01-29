/**
 * Controller class for UI component to build
 * a web form to submit data for new records via Force.com sites
 * URL and REST service
 *
 * Author: i.Androsov
 */
public class WEB_Form2AnyObject_Ctrl {

	public String selectedSiteURL {get; set;}
	public String selectedObject {get; set;}
	public String[] selectedFields {get; set;}
	public String webForm {get{return getWebFormHTML();} set;}
	public Boolean displayFields {get; set;}
	public Boolean displayWebForm {get; set;}
	private Map<String, String> fieldMap = new Map<String, String>();
	private String[] standardObjects = new String[]{'Account','Contact','Asset','Idea','Opportunity','Campaign', 'Case'};
	 
	public WEB_Form2AnyObject_Ctrl(){
		this.displayFields = false;
		this.displayWebForm = false;
	} 
	
	public List<SelectOption> getSiteURL(){
		List<SelectOption> options = new List<SelectOption>();
		
		List<Site> siteLst = [SELECT Id, Name, MasterLabel, Description, Subdomain, UrlPathPrefix, Status FROM Site where Status = 'Active' LIMIT 100];
		List<ID> siteIdList = new List<ID> ();
		Map<ID, String> siteMap = new Map<ID, String>();
		for (Site s : siteLst){
			siteIdList.add(s.Id);
			siteMap.put(s.Id,s.Name);
		}

		List<SiteDetail> siteDetailList = [SELECT Id, DurableId, SecureUrl FROM SiteDetail WHERE DurableId IN :siteIdList]; 
		for (SiteDetail d : siteDetailList){
			options.add(new SelectOption(d.SecureUrl, (String)siteMap.get(d.DurableId)));
		}
		options.sort();
		return options;
	} 



	public List<SelectOption> getObjectList(){
		List<SelectOption> options = new List<SelectOption>();
        //iterate through the object list and build a list of objects
        List<Schema.SObjectType> oTokens = Schema.getGlobalDescribe().values() ;
        for( Integer i = 0; i < oTokens.size() ; i++ ){  
        	Schema.DescribeSObjectResult t = oTokens.get(i).getDescribe();
            if(isValidWebFormObject(t)){            	
            	 options.add(new SelectOption(t.getName(),t.getName()+'-'+t.getLabel()));
            }
        }
        options.sort();
		return options;	
	}


	public List<SelectOption> getFieldList(){
		List<SelectOption> options = new List<SelectOption>();
		if (this.selectedObject != null && this.selectedObject.length() > 0){
			this.fieldMap = new Map<String, String>();
			Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
			Schema.SObjectType obj = gd.get(this.selectedObject); 
			Schema.DescribeSObjectResult R = obj.getDescribe();
		
	 	   	Map<String, Schema.SObjectField> mp = R.fields.getMap();
	    	List<Schema.SObjectField> field_list = mp.values();
	    
        	for (Schema.SObjectField f : field_list){
            	Schema.DescribeFieldResult df = f.getDescribe();
            	if (df.isCustom() && df.isCreateable()){
            		options.add(new SelectOption(df.getName(),df.getName()));
            	} else {
            		if (df.isNameField() && !df.isAutoNumber()){
            			options.add(new SelectOption(df.getName(),df.getName()));
            		}else if (!df.isIdLookup() && df.isCreateable() && df.isAccessible() && !df.isCalculated() 
            					&& !df.isDeprecatedAndHidden() && !df.isExternalId() && !df.isAutoNumber()){
            			options.add(new SelectOption(df.getName(),df.getName()));
            		}
            	}
            	this.fieldMap.put(df.getName(),df.getLabel());
        	}
		}
		options.sort();
		return options;
	}
	
	public String getWebFormHTML(){
		
		String htm = '<form action="' + this.selectedSiteURL + '/services/apexrest/anyobject" method="POST">\n';
		htm += '<input type="hidden" name="otype" value="' + this.selectedObject + '" />\n';
		htm += '<input type="hidden" name="retURL" value="http://" />\n';
		htm += '<input type="hidden" name="encoding" value="UTF-8" />\n';
		
		// Add fields to web form
		if (this.selectedFields != null){
			for (String s : selectedFields){
				if (this.fieldMap.containsKey(s)){
					String df = this.fieldMap.get(s);
					htm += '<label for="'+s+'">'+df+'</label><input id="'+s+'" name="'+s+'" maxlength="40" size="20" type="text" /><br/>\n';
				}
			}
		}
		
		htm += '<input type="submit" name="submit" />\n';
		htm += '</form>\n';
		
		return htm;	
	}
	
	public PageReference updateObjectFields(){
		this.displayFields = true;
		
		return null;
	}

	public PageReference createWebForm(){
		this.displayWebForm = true;
		this.displayFields = true;
		return null;
	}
	
	/**
	 * Check if object can be really created woth web form
	 */
	private Boolean isValidWebFormObject(Schema.DescribeSObjectResult t){
		Boolean rc = false;
		if (t.isCreateable() && t.isAccessible() && !t.isCustomSetting()){
			if (t.isCustom()){
				rc = true;
			}else if (matchName(t.getName())){
				rc = true;
			}
		}
		return rc;
	}

	private Boolean matchName(String nm){
		for(String s : this.standardObjects){
			if (nm.equals(s)){
				return true;
			}
		//if (nm.equals('Contact') || nm.equals('Account') || nm.equals('Asset') || nm.equals('Idea') || nm.equals('Opportunity'))
		//	rc = true;
		}
		return false;
	}

}