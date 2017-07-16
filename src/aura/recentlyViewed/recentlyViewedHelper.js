({
    pollApex : function(component,event,helper) {
        helper.callApex(component,helper);
        //window.setInterval($A.getCallback(function() {helper.callApex(component,helper)}),5000);
    },
    callApex : function(component,helper) {
        var action = component.get("c.getRecentlyViewed");
        action.setCallback(this, function(data) {
            component.set("v.records", data.getReturnValue());
        });
        $A.enqueueAction(action);
        
    },
    refresh : function(component) {
        var action = component.get('c.getRecentlyViewed');
        action.setCallback(this,function(action) {
            $A.get('e.force:refreshView').fire();
        });
        $A.enqueueAction(action);
    },
    resetHover: function(component){
        component.set('v.hovering',false);
        this.startTimeOut(component);
    },
    startTimeOut : function(component){
        var timeout = window.setTimeout(
            $A.getCallback(function() {
                if (component.isValid()) {
                    var hovering = component.get('v.hovering');
                    if (!hovering){
                        var panel = component.find('accountName');
                        $A.util.addClass(panel,'hidden');
                    }
                }
            }), 100
        );
        component.set('v.timeout',timeout);
    }
})