trigger ContactTrigger on Contact (after insert, before update) {
    if(Trigger.isAfter){
        if(Trigger.isInsert){
            CreateDummyAccToContactTriggerHandler.afterInsert(Trigger.New);
            ContactSharingTiggerHandler.beforeInsertBeforeUpdate(Trigger.New, Trigger.oldMap);
        }
    }
    if(Trigger.isBefore){
        if(Trigger.isUpdate){
            ContactSharingTiggerHandler.beforeInsertBeforeUpdate(Trigger.New, Trigger.oldMap);
        }
    }
}