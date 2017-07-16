({
	myAction : function(component, event, helper) {
    	var urlEvent = $A.get("e.force:navigateToSObject");
    	urlEvent.setParams({
            "recordId": component.get("v.Id"),
            "slideDevName": "detail"
    	});
    	urlEvent.fire();
	}
    /*
    refresh : function(component, event, helper) {
    var action = cmp.get('c.myController');
    action.setCallback(cmp,
        function(response) {
            var state = response.getState();
            if (state === 'SUCCESS'){
                $A.get('e.force:refreshView').fire();
            } else {
                 //do something
            }
        }
    );
    $A.enqueueAction(action);
}*/
})