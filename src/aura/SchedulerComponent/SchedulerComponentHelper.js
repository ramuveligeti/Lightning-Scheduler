({
	helperMethod : function(component,event) {
        var action = component.get("c.initialize");
        /*action.setCallback(this, function(data) {
            component.set("v.objects", data.getReturnValue());
        });*/
        $A.enqueueAction(action);
	},
	objectMethod : function(component,event) {
        var action = component.get("c.getSobjectNames");
        action.setCallback(this, function(data) {
            component.set("v.objects", data.getReturnValue());
        });
        $A.enqueueAction(action);
	},
    hidePanelOnLoad: function(component,event){
        var panel = component.find("filterBlock");
        console.log(panel);
        $A.util.addClass(panel,"toggle");
    },
    fetchFields: function(component,event){
        var action = component.get("c.getObjFields");
        console.log('aa=='+component.get("v.selectedObj"));
        action.setParams({"so":component.get("v.selectedObj")});
        action.setCallback(this, function(data) {
            component.set("v.fields", data.getReturnValue());
        });
        $A.enqueueAction(action);
    },
    fetchList: function(component,event){
        var action = component.get("c.addFilter");
        action.setCallback(this, function(data) {
            console.log('ddd==');
            console.log(data.getReturnValue());
            component.set("v.filterWrapper", data.getReturnValue());
        });
        $A.enqueueAction(action);
    }
})