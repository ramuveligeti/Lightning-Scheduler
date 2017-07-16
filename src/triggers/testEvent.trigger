trigger testEvent on test__e (after insert) {
    for(test__e t: trigger.new){
        system.debug(t);
        if (t.Urgent__c == true){
            GoogleMapsAPI.getSuburb('5+Sheldon+Place+Burswood+Auckland');
        }
    }
}