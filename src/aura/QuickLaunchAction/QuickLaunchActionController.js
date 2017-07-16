({
    launchAction : function(component,event,helper){
        var type = component.get("v.type");
        var url = component.get("v.Url");
        console.log('type=='+type);
        if(type=='VF' || type == 'HTML'){
            $A.get("e.force:navigateToURL").setParams(
                {"url": url}).fire();        
        }else if(type=='Lightning'){
            var evt = $A.get("e.force:navigateToComponent");
            evt.setParams({
                componentDef : "c:"+url
            });
            evt.fire();
        }
    }
})