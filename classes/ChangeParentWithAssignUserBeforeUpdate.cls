public with sharing class ChangeParentWithAssignUserBeforeUpdate {
    public void territoryUpdateError(List<Territory__c> newTerritoryList, Map<Id, Territory__c> oldMapTerritory){
        List<Id> assignTerritoryId = new List<Id>();
        List<TerrUser__c> assignTerritory = [SELECT Id, Territory__c, User__c FROM TerrUser__c WHERE Territory__c != Null];
        for(TerrUser__c itemAssignTerritory : assignTerritory){
            assignTerritoryId.add(itemAssignTerritory.Territory__c);
        }
        for(Territory__c item: newTerritoryList){
            if(oldMapTerritory.get(item.Id).Territory__c == Null && item.Territory__c != Null && oldMapTerritory.get(item.Id).TerrUser__c !=Null){
                item.Territory__c.addError(Label.ChangeParentError);
            }
        }
    }
}