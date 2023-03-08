public with sharing class TerritoryUpdateParentErrorTriggerHandler {
    public static void beforeUpdate (List<Territory__c> newTerritoryList, Map<Id, Territory__c> oldMapTerritory){
        new ChangeParentWithAssignUserBeforeUpdate().territoryUpdateError(newTerritoryList, oldMapTerritory);
    }
}