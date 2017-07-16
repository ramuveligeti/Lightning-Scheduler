({
	generateMap : function(component) {
		var action = component.get('c.getQuickLaunch');
        action.setParams({
            "accountId": component.get("v.recordId")
        });

        action.setCallback(this, function(response) {
            //store response state 
            var state = response.getState();
            if (state === "SUCCESS") {
                // create a empty array for store map keys 
                var arrayOfMapKeys = [];
                // store the response of apex controller (return map)     
                var StoreResponse = response.getReturnValue();
                console.log('StoreResponse' + StoreResponse);
                // set the store response[map] to component attribute, which name is map and type is map.   
                component.set('v.QuickMap', StoreResponse);
                
                for (var singlekey in StoreResponse) {
                    arrayOfMapKeys.push(singlekey);
                }
                // Set the all list of keys on component attribute, which name is lstKey and type is list.     
                component.set('v.QuickKeyList', arrayOfMapKeys);
            }
        });
        // enqueue the Action   
        $A.enqueueAction(action);
    }
})