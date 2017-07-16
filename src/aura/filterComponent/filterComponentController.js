({
    myAction : function(component, event, helper) {
        /*var panel = component.find("operatorValues");
		console.log(panel);
        $A.util.addClass(panel,"toggle");*/
        var op = component.find("operatorValues");
        var ops = component.get("v.operators");
        var opts=[];
        for(var i=0;i< ops.length;i++){
            opts.push({"class": "optionClass", label: ops[i].label, value: ops[i].value});
        }
        op.set("v.options", opts);
        component.set("v.selectedField",component.get("v.sf"));
        console.log('sf=='+component.get("v.sf"));
    },
    dispOperator : function(component, event, helper) {
        console.log('dispOp');
        console.log(component.get("v.filterWrapper"));
        //component.set("v.fw.filterOption", component.get("v.selectedField"));
        var act = component.get("c.changeValueDataType");
        act.setParams({"so":component.get("v.selectedObj"), "fOption":component.get("v.selectedField"), "filterWrap":JSON.stringify(component.get("v.filterWrapper"))});
        act.setCallback(this, function(data) {
            console.log('ddd==');
            console.log(data.getReturnValue());
            var op = component.find("operatorValues");
            component.set("v.fw", data.getReturnValue());
            console.log('v==@'+component.get("v.fw.filterOperator"));
            console.log(component.get("v.fw.operators"));
            console.log(component.get("v.fw.operators").length);
            var ops = component.get("v.fw.operators");
            var opts=[];
            for(var i=0;i< ops.length;i++){
                opts.push({"class": "optionClass", label: ops[i].label, value: ops[i].value});
            }
            op.set("v.options", opts);
            
            //component.set("v.operators", component.get("v.fw.operators"));
            component.set("v.dataType", component.get("v.fw.dataType"));
            component.set("v.value", component.get("v.fw.value"));
            component.set("v.sch", component.get("v.fw.sch"));
            component.set("v.picklistOptions", component.get("v.fw.picklistOptions"));
        });
        $A.enqueueAction(act);
		//helper.fetchOperator(component, event);
        var panel = component.find("operatorValues");
        $A.util.removeClass(panel,"toggle");
    },
    fireEvent : function(component,event,helper){
        var cmpEvent = component.getEvent("addFilterWrapperEvent");
        console.log('ff==@'+component.get("v.fw.filterOperator"));
        component.set("v.fw.filterOperator","=");
        //component.set("v.fw.filterOption",component.get("v.selectedField"));
        cmpEvent.setParams({"filWrap":component.get("v.fw")});
        cmpEvent.fire();
    },
    assignOperator : function(component, event, helper){
        var evntsource = event.getSource();
        console.log('e=='+evntsource.get("v.value")); 
    }
})