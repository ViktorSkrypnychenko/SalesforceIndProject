trigger AccountTrigger on Account (after insert, before update) {
    if(Trigger.isAfter){
        if(Trigger.isInsert){
            CreateAccountToContactReferenceHendler.afterInsert(Trigger.New);
        }
    }
    if(Trigger.isBefore){
        if(Trigger.isUpdate){
            AccountSharingTriggerHandler.beforeUpdate(Trigger.New, Trigger.OldMap);
        }
    }
}