public with sharing class AssignPermisionSetTriggerHandler {
    @future
   	public static void assignPermissionSetToUsers (Set<Id> usersId) {
        List<PermissionSetAssignment> permissionSetList = new List<PermissionSetAssignment>();
       	PermissionSet[] permSet = [SELECT Id, Name FROM PermissionSet WHERE Name = 'territoryManagment' LIMIT 1];
        if(permSet.size() == 1){
            for(PermissionSet item : permSet){
           		for (User userToAssign : [Select Id FROM User Where Id IN : usersId]){
               		PermissionSetAssignment psa = new PermissionSetAssignment (PermissionSetId = item.Id, AssigneeId = userToAssign.Id);
					permissionSetList.add(psa);
				} 
        	}
        }
   		insert permissionSetList;
    }
}