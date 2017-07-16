public class hoverController {
    @auraEnabled public String rId{get;set;}
    public hoverController(){
        //if(rId != null) getDetails((Id)rId);
    }
    @auraEnabled
	public static List<SObject> getDetails(Id rId){
        String objectName = rId.getSObjectType().getDescribe().getName();
        List<SObject> objList = Database.query('Select Id,Name from '+objectName+' where Id = \''+rId+'\'');
        return objList;
    }
}