public class QuickLaunchController {
    @AuraEnabled
    public static Map<String,List<Quick_Launch__c>> getQuickLaunch(Id accountId){
        system.debug('accountId=='+accountId);
        Map<String,List<Quick_Launch__c>> quickMap = new Map<String,List<Quick_Launch__c>>();
        List<Quick_Launch__c> quickList = [Select Id,Name,Page_Type__c,Url__c,Label__c,Group_Name__c,Help_Text__c from Quick_Launch__c];
        for(Quick_Launch__c ql: quickList){
            if(quickMap.containsKey(ql.Group_Name__c)) quickMap.get(ql.Group_Name__c).add(ql);
            else quickMap.put(ql.Group_Name__c,new List<Quick_Launch__c>{ql});
        }
        return quickMap;
    }
}