public without sharing class RemovePermissionSetHendler {
	@future
    public static void removePermissionSet(Set<Id> usersId){
        List<PermissionSetAssignment> permissionSetList = new List<PermissionSetAssignment>();
       	PermissionSet[] permSet = [SELECT Id, Name FROM PermissionSet 
                                   WHERE Name = 'territoryManagment' LIMIT 1];
        If (permSet != null){
            for(PermissionSet item : permSet){
                for (User userToAssign : [Select Id FROM User Where Id IN : usersId]){
					delete [SELECT Id from PermissionSetAssignment 
                        WHERE PermissionSetId = : item.Id AND AssigneeId = : userToAssign.Id];                    
                }
            }
        }
   	}
}