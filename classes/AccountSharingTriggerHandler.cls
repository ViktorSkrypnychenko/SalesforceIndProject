public with sharing class AccountSharingTriggerHandler {
   public static void beforeUpdate(List<Account> newAccount, Map<Id, Account> oldMapAccount){
        new AccountSharing().assignAccount(newAccount, oldMapAccount);
    }
}