({
    showRelatedHover : function(component, event, helper) {
        /*console.log('show hover1');
        var to = window.setTimeout(
            $A.getCallback(function() {
                if (component.isValid()) {
                    component.set('v.hovering',true);
                    var timeOut =  component.get('v.timeout');
                    if (timeOut > 0) {
                        clearTimeout(timeOut);
                    }
                    var panel = component.find('hoverCmp');
                    var id = component.get('v.id');
                    //if (component.get('v.account')==null){
                        helper.loadRelatedList(component,id);
                    //}
                    var hrefL = component.find('hrefLink');
                    var name = component.get('v.name');
                    //helper.placeDiv(component);
                    console.log('href=='+name.length);
                    $A.util.removeClass(panel,'slds-hide');

                    var topoffset = jQuery('#'+id).offset().top;
                    var height = jQuery('#'+id).height();
                    var pageHeight = $(window).height();
                    console.log('topoffset=='+topoffset+'=='+height+'=='+pageHeight);
                    //alert('in');
                    var panel = component.find('hoverCmp');
                    var bottom = topoffset+height;
                    var popPercent = (topoffset/pageHeight)*100;
                    if (popPercent > 80) {
                        console.log('in if');
                        //the div is going outside the page
                        jQuery('#'+id).css("top","-117px");
                        jQuery('#'+id).addClass('arrow_left_bottom');
                        //$A.util.addClass(panel,'divTop');
                    }else{
                        console.log('in else');
                        jQuery('#'+id).addClass('arrow_left_top');
                        jQuery('#'+id).css("top","-7px");
                    }        
                }
            }), 500
        );*/
        //var j$ = jQuery.noConflict();
        var id = component.get('v.id');
        var popOverSettings ={ 
            placement: 'bottom',
            container: 'body',
            html : true,
            selector : '[rel="popover"]',
            content: function() {
                return jQuery('#popover_content_wrapper').html();
            }
        }
        console.log('tx1=='+popOverSettings);
        
        jQuery('#'+id).popover(popOverSettings);
        //var timers = component.get('v.timers');
        //timers.push(to);		
    },
    afterScriptsLoaded : function(cmp,event,helper){
        console.log('scripts loaded');
    },
    hideRelatedHover : function(cmp,event,helper){
       var timers = cmp.get('v.timers');
       for (var i=0; i < timers.length; i++){
       	  var item = timers[i];
          clearTimeout(item); 
       }
       helper.resetHover(cmp); 
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
        cmp.set('v.hovering',true);
        //var idx = event.target.getAttribute('data-id');
        var panel = cmp.find('hoverCmp');
        $A.util.removeClass(panel,'hidden');
    },
    onLeavePanel : function(component,event,helper){
        console.log('leave hover');
        //component.set('v.hovering',false);
        //var idx = event.target.getAttribute('data-id');
        var panel = component.find('hoverCmp');
        console.log('panel=='+panel);
        $A.util.addClass(panel,'hidden');
    }
    
})