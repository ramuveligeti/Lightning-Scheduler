({
    init : function(component) {
        var placeholder = component.get("v.placeholder");
        if (!$A.util.isEmpty(placeholder)) {
            component.set("v.value", "###None###");
        }
    },
    
    changeOptions : function(component) {
        var options = component.get("v.options");
        if (!$A.util.isArray(options) || options.length == 0) {
            component.set("v.processedOptions", []);
            return;
        }
        var processedOptions = [];
        for (var i = 0; i < options.length; i++) {
            var option = options[i];
            if ($A.util.isArray(option)) {
                processedOptions.push({ label: option[0], value: option[1] });
            }
            else if ($A.util.isObject(option)) {
                processedOptions.push(option);
            }
            else {
                processedOptions.push({ label: option, value: option });
            }
        }
        component.set("v.processedOptions", processedOptions);
    },
    
    changeSelect : function(component, event, helper) {
        component.set("v.value", event.target.value);
	},
    
    changeValue : function(component, event, helper) {
        var value = component.get("v.value");
        if (value == '###None###') {
            var selectComponent = component.find("select");
            if (selectComponent != null) {
                var selectElement = selectComponent.getElement();
                if (selectElement != null) {
                    selectElement.selectedIndex = 0;
                }
            }
            return;
        }
        var options = component.get("v.processedOptions")
        for (var i = 0; i < options.length; i++) {
            if (options[i].value == value) {
                var selectComponent = component.find("select");
                if (selectComponent != null) {
                    var selectElement = selectComponent.getElement();
                    if (selectElement != null) {
                        selectElement.selectedIndex = 0;
                    }
                }
                return;
            }
        }
	}
})