public with sharing class TerritoryToConnectTriggerHandler {
	public static void beforeDelete(List<Territory__c> newTerritoryList){
       	new UpdateTerritoryBeforeDeletePerent().territoryBeforeDelete(newTerritoryList);
    }
}