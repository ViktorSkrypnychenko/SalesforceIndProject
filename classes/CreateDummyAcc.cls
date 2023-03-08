public with sharing class CreateDummyAcc {
    public void dummyAccountAfterInsert(List<Contact> newContactList){
        List<Account> accountsToInsert = new List<Account>();
        for(Contact newContact : newContactList){
            Account createAccount = new Account(Name = ''+newContact.Id);
            accountsToInsert.add(createAccount);
        }
        if(!accountsToInsert.isEmpty()){
            insert accountsToInsert;
        }
    }
}