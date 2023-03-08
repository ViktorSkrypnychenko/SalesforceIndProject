public with sharing class AccountSharing {
    public void assignAccount(List<Account> newAccount, Map<Id, Account> oldMapAccount){
        List<AccountShare> shareList = new List<AccountShare>();
        List<Id> userIdToDeleteSharing = new List<Id>();
        Map<Id, Territory__c> terrUltimateParentMap = new Map<Id, Territory__c>([SELECT Id, TerrUser__r.User__c 
                                                                   FROM Territory__c WHERE Ultimate_Parent__c = Null AND TerrUser__c != Null]);
        
		for(Account acc : newAccount){
            AccountShare accShare = new AccountShare();
            if(acc.Territory__c != Null && acc.Territory__c != oldMapAccount.get(acc.Id).Territory__c){
                if(acc.Territory__r.TerrUser__r.User__c != Null && acc.Territory__r.TerrUser__c != Null){
                    accShare.AccountId = acc.Id;
                    accShare.UserOrGroupId = acc.Territory__r.TerrUser__r.User__c;
                    accShare.AccountAccessLevel = 'edit';
                    accShare.RowCause = Schema.AccountShare.RowCause.Manual;
                } else if(acc.Territory__r.TerrUser__c == Null && acc.Territory__r.Ultimate_Parent__c != Null){
                    		accShare.AccountId = acc.Id;
                    		accShare.UserOrGroupId = terrUltimateParentMap.get(acc.Territory__r.Ultimate_Parent__c).TerrUser__r.User__c;
                    		accShare.AccountAccessLevel = 'edit';
                    		accShare.RowCause = Schema.AccountShare.RowCause.Manual;
                		} 
            }else if(acc.Territory__c == Null && oldMapAccount.get(acc.Id).Territory__c != Null && acc.Territory__r.TerrUser__r.User__c !=Null){
                    userIdToDeleteSharing.add(acc.Territory__r.TerrUser__r.User__c);
                }
            shareList.add(accShare);
        }
        List<AccountShare> sharesAccountToDelete = [SELECT Id, AccountId, UserOrGroupId, AccountAccessLevel, RowCause 
                                            FROM AccountShare WHERE UserOrGroupId IN : userIdToDeleteSharing];
        if(shareList.size()>0){
            Database.insert(shareList, false);
        }
        if(!sharesAccountToDelete.isEmpty()){
            Database.delete(sharesAccountToDelete, false);
        }
    }
}