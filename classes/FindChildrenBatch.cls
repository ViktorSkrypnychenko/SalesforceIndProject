global class FindChildrenBatch implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator([SELECT Id FROM Territory__c WHERE Territory__c = Null]);
  	}
	global void execute(Database.BatchableContext BC, List<sObject> scope) {
    	Map<Id, Territory__c> parentTerritory = new Map<Id, Territory__c>((List<Territory__c>) scope);
		ChildrenSearch childrenSet = new ChildrenSearch(Territory__c.getSObjectType(), Territory__c.Territory__c);
    	Map<Id, Id[]> children = childrenSet.search(parentTerritory.keySet());
    	Territory__c[] childrenToUpdate = new List<Territory__c>{};
    	for (Id parentId : children.keySet()) {
      		for (Id childId : children.get(parentId)) {
        		childrenToUpdate.add(new Territory__c(Id = childId, Ultimate_Parent__c = parentId));
      		}
    	}
    update childrenToUpdate;
  	}
	global void finish(Database.BatchableContext BC) {}
}