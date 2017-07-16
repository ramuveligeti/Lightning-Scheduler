({
	init : function(component, event, helper) {
        var action = component.get("c.getDetails");
        action.setParams({"rId":component.get("v.rId")});
        action.setCallback(this, function(data) {
            component.set("v.objectData", data.getReturnValue());
        });
        $A.enqueueAction(action);
	}
})