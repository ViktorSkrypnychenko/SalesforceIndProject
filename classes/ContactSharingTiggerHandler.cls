public with sharing class ContactSharingTiggerHandler {
    public static void beforeInsertBeforeUpdate(List<Contact> newContact, Map<Id, Contact> oldMapContact){
        new ContactSharing().assignContact(newContact, oldMapContact);
    }
}