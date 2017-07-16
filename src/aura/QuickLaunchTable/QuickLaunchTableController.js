({
    doInit : function(component, event, helper) {
        var key = component.get("v.key");
        var map = component.get("v.map");
        
        // set the values of map to the value attribute	
        // to get map values in lightning component use "map[key]" syntax. 
        component.set("v.valueList" , map[key]);	
        console.log('v=='+component.get("v.valueList"));
    },
    launchVF : function(component,event,helper){
        $A.get("e.force:navigateToURL").setParams(
            {"url": "/apex/Test"}).fire();        
    },
    launchLightning : function(component, event, helper) {
        var evt = $A.get("e.force:navigateToComponent");
        evt.setParams({
            componentDef : "c:quickAdd"
        });
        evt.fire();
    },
    showRelatedHover : function(component, event, helper) {
        var panel = component.find('hoverCmp');
        $A.util.removeClass(panel,'slds-hide');
    },
    hideRelatedHover : function(component, event, helper) {
        var panel = component.find('hoverCmp');
        $A.util.addClass(panel,'slds-hide');
    }
})