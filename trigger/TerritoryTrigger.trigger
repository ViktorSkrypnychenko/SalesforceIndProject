trigger TerritoryTrigger on Territory__c (before update, before insert, before delete) {
    if(Trigger.isBefore){
        if(Trigger.isInsert){
            CheckNameTerritoryTriggerHandler.beforeInsert(Trigger.new);
        }
        if(Trigger.isUpdate){
            TerritoryUpdateParentErrorTriggerHandler.beforeUpdate(Trigger.new, Trigger.oldMap);
            CheckNameTerritoryTriggerHandler.beforeUpdate(Trigger.new, Trigger.oldMap);
        }
        if (Trigger.isDelete){
            TerritoryToConnectTriggerHandler.beforeDelete(Trigger.Old);
        }
    }
}