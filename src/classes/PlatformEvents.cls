public class PlatformEvents {
    @auraEnabled
    public static string getSessionId(){
        return ApexUtils.getSessionIdFromVFPage(Page.SessionId);
    }
}