public class CreateDummyAccToContactTriggerHandler {
    public static void afterInsert (List<Contact> newContactList){
        new CreateDummyAcc().dummyAccountAfterInsert(newContactList);
    }
}