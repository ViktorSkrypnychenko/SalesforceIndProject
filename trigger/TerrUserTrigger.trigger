trigger TerrUserTrigger on TerrUser__c (after insert, after update, after delete) {
    Set<Id> usersId = new Set<Id>();
    for (TerrUser__c ter :trigger.new) {
    	if(ter.Territory__c != Null) {
       		usersId.add(ter.User__c);
        }
	}
    AssignPermisionSetTriggerHandler.assignPermissionSetToUsers(usersId);
    RemovePermissionSetHendler.removePermissionSet(usersId);
}