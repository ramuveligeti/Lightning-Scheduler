({
    helperMethod : function(component,event) {
        
    },
    fetchOperator: function(component,event){
        console.log(component.get("v.filterWrapper"));
        var action = component.get("c.changeValueDataType");
        action.setParams({"so":component.get("v.selectedObj"), "fOption":component.get("v.selectedField"), "fw":component.get("v.filterWrapper")});
        action.setCallback(this, function(data) {
            console.log('ddd=='+data.getReturnValue());
            component.set("v.filterWrapper", data.getReturnValue());
        });
        $A.enqueueAction(action);
    }
})