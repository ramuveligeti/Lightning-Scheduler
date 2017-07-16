public class IconUtils {
    
    private static List<Schema.DescribeTabSetResult> tabSetDesc;
    private static List<Schema.DescribeTabSetResult> getTabsSetDesc(){
        if(tabSetDesc==null){
            tabSetDesc = Schema.describeTabs();
        }
        return tabSetDesc;
    }
    
    private static Map<String, String> icons32;
    private static Map<String, String> getIcons32(){
        if(icons32==null){
            icons32 = new Map<String, String>();
            for(Schema.DescribeTabSetResult tsr:getTabsSetDesc()){
                for(Schema.DescribeTabResult tab: tsr.getTabs()){
                    icons32.put(tab.getSobjectName(), tab.getIconUrl());
                }
            }
        }
        return icons32;
    }
    
    private static Map<String, String> icons16;
    private static Map<String, String> getIcons16(){
        if(icons16==null){
            icons16 = new Map<String, String>();
            for(Schema.DescribeTabSetResult tsr:getTabsSetDesc()){
                for(Schema.DescribeTabResult tab: tsr.getTabs()){
                    icons16.put(tab.getSobjectName(), tab.getMiniIconUrl());
                }
            }
        }
        return icons16;
    }
    
    public static void test(){
        for(Schema.DescribeTabSetResult tsr:getTabsSetDesc()){
            for(Schema.DescribeTabResult tab: tsr.getTabs()){
                for(Schema.DescribeIconResult ic:tab.getIcons()){
                    //System.debug(tab.getSobjectName()+', '+ic);
                }
            }
        }
    }
    
    public static String getIcon32Url(String objectName){
        return getIcons32().get(objectName);
    }
    
    public static String getIcon16Url(String objectName){
        return getIcons16().get(objectName);
    }
    
    
    private static Map<String, Schema.SObjectType> objectTypes;
    public static Map<String, Schema.SObjectType> getObjectTypes(){
        if(objectTypes==null){
            objectTypes = Schema.getGlobalDescribe();
        }
        return objectTypes;
    }
    
    public static String getIcon32UrlByRecordId(String recordId){
        if(recordId!=null){
            String objectAPIName = '';
            String keyPrefix = recordId.substring(0,3);
            for( Schema.SObjectType obj : getObjectTypes().Values() ){
                String prefix = obj.getDescribe().getKeyPrefix();
                if(prefix == keyPrefix){
                    objectAPIName = obj.getDescribe().getName();
                    break;
                }
            }
            return getIcon32Url(objectAPIName);
        }
        return null; 
    }
    
    public static String getIcon16UrlByRecordId(Id recordId){
        if(recordId!=null){
            String objectAPIName = '';
            /*String keyPrefix = recordId.substring(0,3);
            for( Schema.SObjectType obj : getObjectTypes().Values() ){
                String prefix = obj.getDescribe().getKeyPrefix();
                if(prefix == keyPrefix){
                    objectAPIName = obj.getDescribe().getName();
                    break;
                }
            }*/
            objectAPIName = recordId.getSObjectType().getDescribe().getName();
            //;
            if(objectAPIName.toLowerCase().endsWith('__c')){
                return getLightningIconUrl(objectAPIName);//getIcon16Url(objectAPIName);
            }
            return 'standard:'+objectAPIName.toLowerCase();
        }
        return null; 
    }
    
    public static String getLightningIconUrl(String objectName){
        
        List<Schema.DescribeTabResult> tabDesc = new List<Schema.DescribeTabResult>();
        List<Schema.DescribeIconResult> iconDesc = new List<Schema.DescribeIconResult>();
        Map<String,String> mapUrl = new Map<String,String>();
        
        for(Schema.DescribeTabSetResult tsr : getTabsSetDesc()) {
            tabDesc.addAll(tsr.getTabs());
        }
        
        for(Schema.DescribeTabResult tr : tabDesc) {
            if (tr.getSobjectName().toLowerCase().endsWith('__c')) {
                system.debug('tr=='+tr.getSobjectName()+'==='+tr.getIcons()[2].getUrl()+'=='+objectName);
                //iconDesc.addAll(tr.getIcons());
                mapUrl.put(tr.getSobjectName(),tr.getIcons()[2].getUrl());
            }
        }
        String iconUrl = mapUrl.get(objectName);
        //return iconUrl;
        system.debug('iconUrl=='+iconUrl);
        Integer s = iconUrl.indexOf('/custom/') + '/custom/'.length();
        Integer e = iconUrl.length() - 4;
        //return '/resource/slds214/assets/icons/custom-sprite/svg/symbols.svg#' + iconUrl.substring(s, e);
        return 'custom:'+iconUrl.substring(s, e);
    }
    
}