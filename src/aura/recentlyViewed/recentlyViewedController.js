({
    myAction : function(component, event, helper) {
        /*var action = component.get("c.getRecentlyViewed");
        action.setCallback(this, function(data) {
            component.set("v.records", data.getReturnValue());
        });
        $A.enqueueAction(action);*/
        //var panel = component.find('hoverCmp');
        //$A.util.addClass(panel,'hidden');
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
    editRecord : function(component, event, helper) {
        var editRecordEvent = $A.get("e.force:editRecord");
        var idx = event.currentTarget.dataset.record;
        //console.log('idx3=='+idx+'=='+idx1);
        editRecordEvent.setParams({
            "recordId": idx
        });
        editRecordEvent.fire();
    },
    onHoverPanel : function(cmp,event,helper){
        console.log('in hover');
        var hovering = cmp.get('v.hovering');
        if(!hovering){
            cmp.set('v.hovering',true);
            var idx = event.target.getAttribute('data-id');
            var panel = document.getElementById(idx);
            $A.util.removeClass(panel,'hidden');
        }
	},
 	onLeavePanel : function(component,event,helper){
        console.log('leave hover');
        //component.set('v.hovering',false);
        var idx = event.target.getAttribute('data-id');
        var panel = document.getElementById(idx);
        console.log('panel=='+panel);
        $A.util.addClass(panel,'hidden');
    }
    
})