({
    loadRelatedList : function(cmp,accountId) {
        var action = cmp.get('c.queryCompactLayout');
        action.setParams({
            "rvId": cmp.get('v.id'),
            "objName":cmp.get('v.objectApi')
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            var data = response.getReturnValue();
            console.log('data=='+data);
            if (cmp.isValid() && state ==='SUCCESS'){
                cmp.set('v.FieldsNameMap',data);
            }
        });
        $A.enqueueAction(action);        
    },
    placeDiv: function(cmp){
        var d = document.getElementById(cmp.get('v.id'));
        d.style.position = "absolute";
        d.style.left = '219 px';
        d.style.top = '262 px';
    },
    resetHover: function(cmp){
        cmp.set('v.hovering',false);
        this.startTimeOut(cmp);
    },
    startTimeOut : function(cmp){
        
        var timeout = window.setTimeout(
            $A.getCallback(function() {
                if (cmp.isValid()) {
                    var hovering = cmp.get('v.hovering');
                    if (!hovering){
                        var panel = cmp.find('hoverCmp');
                        $A.util.addClass(panel,'slds-hide');
                    }
                }
            }), 100
        );
        cmp.set('v.timeout',timeout);
    }
})