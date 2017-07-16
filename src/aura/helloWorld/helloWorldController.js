({
 fireevent: function(component, event, helper) {
    var myEvent = $A.get("e.c:myEvent");
    myEvent.setParams({"data":"Test"});
    myEvent.fire();
  }
})