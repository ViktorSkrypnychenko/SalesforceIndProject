public with sharing class CheckNameTerritoryTriggerHandler {
    public static void beforeInsert(List<Territory__c> newTerritoryList){
        new CheckName().checkNameCreateUpdate(newTerritoryList);
    }
    public static void beforeUpdate(List<Territory__c> newTerritoryList, Map<Id, Territory__c> oldMapTerritory){
        new ChekNameBeforeUpdate().beforeUpdate(newTerritoryList, oldMapTerritory);
    }
}