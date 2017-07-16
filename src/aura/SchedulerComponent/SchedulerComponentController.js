({
	myAction : function(component, event, helper) {
		//helper.helperMethod(component,event);
        helper.objectMethod(component,event);
        helper.hidePanelOnLoad(component,event);
	},
	dispFilter : function(component, event, helper) {
        var selectedObj = component.get("v.selectedObj");
        //component.set("c.selectedObj",selectedObj);
        console.log('selectedObj=='+selectedObj)
        if(selectedObj != ''){
            var panel = component.find("filterBlock");
            console.log(panel);
            $A.util.removeClass(panel,"toggle");
            helper.fetchFields(component, event);
            helper.fetchList(component, event);
        }else{
            helper.hidePanelOnLoad(component,event);
        }
    },
    addToList : function(component, event, helper) {
		var value = event.getParam("filWrap");
        var op = event.getParam("selectedOperator");
        var vl = event.getParam("selectedValue");
        console.log('v==');
        console.log(value);
        console.log(value.filterOption+'==@@'+op+'@@=='+vl);
        var action = component.get("c.addFilterToWrapper");
        action.setParams({"filterWrap":JSON.stringify(value)});
        action.setCallback(this, function(data) {
            component.set("v.filterWrapper", data.getReturnValue());
        });
        $A.enqueueAction(action);
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
    }
})