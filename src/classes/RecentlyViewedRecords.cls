public class RecentlyViewedRecords {
    private static string FIELDSET_NAME = 'RecentlyViewedHover';
    private static Map<String, Set<String>> private_apiFieldNames = new Map<String, Set<String>>();
    private static Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
    private static Recently_Viewed__c rvi = Recently_Viewed__c.getInstance();

    @auraEnabled
    public static List<RecentlyViewedWrapper> getRecentlyViewed(){
        List<RecentlyViewedWrapper> rvList = new List<RecentlyViewedWrapper>();
        String query = 'Select Id,Name,Type from RecentlyViewed where Type not in (\'ListView\',\'Profile\') limit '+rvi.Records_to_Display__c;
        for(RecentlyViewed rv: Database.query(query)){
            system.debug('name=='+rv.Name);
            Id rvId = rv.Id;
            try{
                RecentlyViewedWrapper rvw = new RecentlyViewedWrapper();
                rvw.iconUrl = getIconURL(rv.Id);
                system.debug('gc=='+rvw.iconUrl);
                rvw.rv = rv;
                rvw.objectName = rvId.getSObjectType().getDescribe().getLabel();
                rvw.objectApi = rvId.getSObjectType().getDescribe().getName(); 
                rvw.viewUrl = '/one/one.app#/sObject/' + rv.id + '/view';
                rvw.hoverCmpId = 'hoverCmp'+rv.Id;
                system.debug('rv=='+rvw.viewUrl);
                rvList.add(rvw);
            }catch(exception e){
                system.debug('Exception=='+e);
            }
        }
        return rvList;
    }
    
    @auraEnabled
    public static List<objectWrapper> queryCompactLayout(Id rvId, String objName){
        Map<String,String> objMap = new Map<String,String>();
        List<objectWrapper> owList = new List<objectWrapper>();
        Map<String, Schema.SObjectType> globalDescribeMap = Schema.getGlobalDescribe();
        Schema.SObjectType SObjectTypeObj = globalDescribeMap.get(objName);
        Schema.DescribeSObjectResult describeSObjectResultObj = SObjectTypeObj.getDescribe();
        system.debug('FIELDSET_NAME=='+FIELDSET_NAME+'=='+describeSObjectResultObj);
        Schema.FieldSet fieldSetObj = describeSObjectResultObj.FieldSets.getMap().get(FIELDSET_NAME);
        system.debug('fieldSetObj=='+fieldSetObj);
        List<String> fieldApis = new List<String>();
        Set<String> refFieldToIgnore = new Set<String>();
        Map<String,String> refMap = new Map<String,String>();
        String query;
        if(fieldSetObj != null){
            for(Schema.FieldSetMember fieldSetMemberObj :fieldSetObj.getFields()){
                String apiName = fieldSetMemberObj.getFieldPath().toLowercase();
                Map<String, Schema.SObjectField> fieldMap1 = findFieldInfo(objName,apiName);
                String fType = String.valueOf(fieldMap1.get(apiName).getDescribe().getType());
                if(fType.equalsIgnoreCase('Reference')){
                    String apiRefName;
                    if(apiName.contains('__c')){
                        apiRefName = apiName.replace('__c','__r.Name');
                    }else{
                        apiRefName = apiName+'.Name';
                    }
                    refFieldToIgnore.add(apiRefName);
                    refMap.put(apiName,apiRefName);
                    fieldApis.add(apiRefName);
                }
                fieldApis.add(apiName);
                
            }
            query = 'Select Id,'+string.join(fieldApis,',')+ ' from '+objName+' where Id = \''+rvId+'\'';
        }else {
            if(!objName.equalsIgnoreCase('case')){
                fieldApis.add('name');
                query = 'Select Id,Name from '+objName+' where Id = \''+rvId+'\'';
            }else{
                fieldApis.add('casenumber');
                query = 'Select Id,casenumber from '+objName+' where Id = \''+rvId+'\'';
            }
        }
        //Http http = new Http();
        //HttpRequest request = buildRequest(objName);
        //HttpResponse response = http.send(request);
        //Map<String,String> fields = processResponse(response.getBody(),objName);
		system.debug('query=='+query);
        sObject so = database.query(query);
        system.debug('so=='+so);
        for(String st: fieldApis){
            if(!refFieldToIgnore.contains(st)){
                Map<String, Schema.SObjectField> fieldMap = findFieldInfo(objName,st);
                objectWrapper ow = new objectWrapper();
                ow.label = fieldMap.get(st).getDescribe().getLabel();
                ow.value = String.valueOf(so.get(st));
                ow.refName = refMap.containsKey(st)?String.valueOf(so.getSobject(st.replace('__c','__r')).get('Name')):null;
                ow.api = st;
                ow.type = String.valueOf(fieldMap.get(st).getDescribe().getType());
                //ow.iconUrl = getIconURL(rvId);
                system.debug('ow=='+ow);
                owList.add(ow);
            }
        }
        return owList;
    }
    
    private static HttpRequest buildRequest(String objName){
        HttpRequest request = new HttpRequest();
		request.setEndpoint(URL.getSalesforceBaseUrl().toExternalForm()+'/services/data/v37.0/compactLayouts?q='+objName);
        request.setMethod('GET');
        system.debug('a=='+UserInfo.getSessionId());
        request.setHeader('Authorization', 'OAuth ' + UserInfo.getSessionId());
        return request;
    }
    
    private static Map<String,String> processResponse(String jsonStr,String objName){
		//Map<String, Object> data = (Map<String, Object>)JSON.deserializeUntyped(jsonStr);
        //Map<String, Object> lwin11 = (Map<String, Object>)data.get(objName);
        system.debug('jsonStr=='+jsonStr+'=='+objName);
		Util_JSONParser parser = Util_JSONParser.createParser(jsonStr);
        String st = parser.get(objName).Value;
        Util_JSONParser sl = Util_JSONParser.createParser(st);
        String sa = sl.get('fieldItems').Value;
        system.debug('sa=='+sa);
        List<Util_JSONParser> arrayParser  = Util_JSONParser.parseArray(sa);
        Map<String,String> fields = new Map<String,String>();
        Integer i=0;
        for(Util_JSONParser p : arrayParser ){
            i++;
            if(i>4){break;}
            String sc = p.get('layoutComponents').value;
            Util_JSONParser sla = Util_JSONParser.createParser(sc);
            fields.put(p.get('label').value,sla.get('value').Value);
        }
        return fields;
    }
    
    private static Map<String, Schema.SObjectField> findFieldInfo(String objName, String fieldApi){
        Schema.SObjectType leadSchema = schemaMap.get(objName);
        return leadSchema.getDescribe().fields.getMap();
        //return String.valueOf(fieldMap.get(fieldApi).getDescribe().getType());    
    }
    
    @auraEnabled
    public static String getIconURL(Id recordId){
        return IconUtils.getIcon16UrlByRecordId(recordId);
    }
    
    public class RecentlyViewedWrapper{
        @auraEnabled
        public Boolean isIconLightning{get{
            	return !iconUrl.startsWith('http');
        	}
        }
        @auraEnabled
        public string iconUrl{get;set;}
        @auraEnabled
        public RecentlyViewed rv{get;set;}
        @auraEnabled
        public String objectName{get;set;}
        @auraEnabled
        public String objectApi{get;set;}
        @auraEnabled
        public String viewUrl{get;set;}
        @auraEnabled
        public String hoverCmpId{get;set;}
    }
    
    public class objectWrapper{
        @auraEnabled
        public String label{get;set;}
        @auraEnabled
        public String value{get;set;}
        @auraEnabled
        public String refName{get;set;}
        @auraEnabled
        public String api{get;set;}
        @auraEnabled
        public String type{get;set;}
        @auraEnabled
        public String iconUrl{get;set;}
    }
}