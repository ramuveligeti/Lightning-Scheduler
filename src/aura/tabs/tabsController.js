({
    myAction : function(component, event, helper) {
        /*var action = component.get("c.getRecentlyViewed");
        action.setCallback(this, function(data) {
            component.set("v.records", data.getReturnValue());
        });
        $A.enqueueAction(action);*/
        helper.pollApex(component,event,helper);
        
    },
    
    gotoURL : function (component, event, helper) {
    	var urlEvent = $A.get("e.force:navigateToSObject");
        var idx = event.target.getAttribute('data-id');
        //alert(idx+'=='+event);
    	urlEvent.setParams({
            "recordId": idx,
            "slideDevName": "detail"
    	});
    	urlEvent.fire();
	},
    
})