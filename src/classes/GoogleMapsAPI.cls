public class GoogleMapsAPI {
    private final static string KEY = 'GoogleAPIKey';
    private final static string URL = 'GoogleAPIUrl';
    //private class Response { final List<Result> results; }
    //private class Result {final List<AddressComponent> address_components;}
    //private class AddressComponent {final String long_name, short_name; List<GoogleAddressEnumType> types;}
    //private static Map<String,System_Settings__c> sysSettings = System_Settings__c.getAll();
    
    @future(callout=true)
    public static void getSuburb(String address){
        HttpRequest req = new HttpRequest(); 
        req.setMethod('POST');
        req.setHeader('Content-length', '10240');
        String urls = 'https://maps.googleapis.com/maps/api/geocode/json?address='+address;
        String payLoad = 'some_data=value+1&some_more_data=value+2&etc_etc';
	
        system.debug('url=='+urls);
        req.setEndPoint('http://demo5720452.mockable.io/TEST');
        req.setBody(payLoad);
        
        Http http = new Http();
        try {
            //Execute web service call here		
            HTTPResponse res = http.send(req);	
            System.debug(res.getStatusCode()+'=='+res.getBody());
            if (res.getStatusCode() == 200) {
                /*Response resp = (Response)JSON.deserialize(res.getBody(), Response.class);
                system.debug('resp=='+resp);
                Result resl = resp.results[0];
                String suburb;
                for(AddressComponent ac: resl.address_components){
                    set<GoogleAddressEnumType> et = new set<GoogleAddressEnumType>();
                    et.addAll(ac.types);
                    if(et.contains(GoogleAddressEnumType.sublocality) || et.contains(GoogleAddressEnumType.sublocality_level_1)){
                        suburb = ac.long_name;
                        break;
                    }
                    if(et.contains(GoogleAddressEnumType.locality)){
                        suburb = ac.long_name;
                        break;
                    }                
                }
                if(String.isBlank(suburb)){return;}
                if(String.isBlank(recId)){return;}
                sobject sObj = Schema.getGlobalDescribe().get(objName).newSObject(recId);
                sObj.put(fieldApi,suburb);
                update sObj;*/
            }
        } catch(System.CalloutException e) {
            //Exception handling goes here....
            system.debug('Error=='+e.getMessage());
            //AccountTriggerHandler.errorLog(e);
        }		
    }
}