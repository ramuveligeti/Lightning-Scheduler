({
	myAction : function(component, event, helper) {
        var action = component.get("c.getSessionId");
        action.setCallback(this, function(data) {
            var ret = data.getReturnValue();
            // Connect to the CometD endpoint
            $.cometd.configure({
                url: 'https://rvt-dev-ed.lightning.force.com/cometd/40.0/',
                requestHeaders: { Authorization: 'OAuth '+ret}
            });
            // Subscribe to WorkItemUpdates topic. JSON-encoded update will be returned
            // in the callback
            $.cometd.subscribe('/event/test__e', function(message) {
                
            });
        });
        $A.enqueueAction(action);
    }
})