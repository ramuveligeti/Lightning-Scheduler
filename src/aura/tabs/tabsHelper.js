({
    pollApex : function(component,event,helper) {
        helper.callApex(component,helper);
        window.setInterval($A.getCallback(function() {helper.callApex(component,helper)}),5000);
    },
    callApex : function(component,helper) {
        var action = component.get("c.getRecentlyViewed");
        action.setCallback(this, function(data) {
            component.set("v.records", data.getReturnValue());
        });
        $A.enqueueAction(action);
        
    },
    refresh : function(component) {
    var action = cmp.get('c.getRecentlyViewed');
    action.setCallback(this,function(action) {
        $A.get('e.force:refreshView').fire();
    });
        $A.enqueueAction(action);
    }
})