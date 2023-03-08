public class UpdateTerritoryBeforeDeletePerent {
    public void territoryBeforeDelete(List<Territory__c> newTerritoryList){
        Map<Id, Id> idForUpdate = new Map<Id, Id>();
        Set<String> ultimateParent = new Set<String>();
        for(Territory__c terrForDelete : newTerritoryList){
            if(terrForDelete.Territory__c !=Null){
                idForUpdate.put(terrForDelete.Id, terrForDelete.Territory__c);
                ultimateParent.add(terrForDelete.Ultimate_Parent__c);
            }
        }
        List<Territory__c> terrToUpdate = [SELECT Id, Territory__c, Ultimate_Parent__c FROM Territory__c WHERE Ultimate_Parent__c IN: ultimateParent];
        for(Territory__c recordToUpdate : terrToUpdate){
            if(idForUpdate.get(recordToUpdate.Territory__c) !=Null){
                recordToUpdate.Territory__c = idForUpdate.get(recordToUpdate.Territory__c);
            }
        }
        update terrToUpdate;
    }
}