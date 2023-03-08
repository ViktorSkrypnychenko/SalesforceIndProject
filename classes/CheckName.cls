public with sharing class CheckName {
    public void checkNameCreateUpdate (List<Territory__c> newTerritoryList){
        List<Territory__c> allTerritory = [SELECT Id, Name FROM Territory__c ];
        List<String> territoryName = new List<String>();
        for(Territory__c  item : allTerritory){
            territoryName.add(item.Name);
        }
        for(Territory__c newTerritoryName : newTerritoryList){
            if(territoryName.contains(newTerritoryName.Name)){
                newTerritoryName.Name.addError(Label.SameNameError);
            }
        }
    }
}