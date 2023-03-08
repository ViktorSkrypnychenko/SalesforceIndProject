public with sharing class ContactSharing {
    public void assignContact(List<Contact> newContact, Map<Id, Contact> oldMapContact){
        List<ContactShare> shareList = new List<ContactShare>();
        List<Id> userIdToDeleteSharing = new List<Id>();
        Map<Id, Territory__c> terrUltimateParentMap = new Map<Id, Territory__c>([SELECT Id, TerrUser__r.User__c 
                                                                   FROM Territory__c WHERE Ultimate_Parent__c = Null AND TerrUser__c != Null]);
        List<Account> accList = [SELECT Id, Name, Territory__c FROM Account ];
        Map<String, Account> dummyAccMap = new Map<String, Account>();
        for(Account acc : accList){
            dummyAccMap.put(acc.Name, acc);
        }
		for(Contact cont : newContact){
            ContactShare contShare = new ContactShare();
            if(cont.AccountId != Null && dummyAccMap.get(cont.Id).Territory__r.TerrUser__r.User__c != Null){
                contShare.ContactId = cont.Id;
                contShare.UserOrGroupId = dummyAccMap.get(cont.Id).Territory__r.TerrUser__r.User__c;
                contShare.ContactAccessLevel = 'edit';
                contShare.RowCause = Schema.ContactShare.RowCause.Manual;
            } else if(cont.AccountId != Null && dummyAccMap.get(cont.Id).Territory__r.TerrUser__c == Null &&
                      dummyAccMap.get(cont.Id).Territory__r.Ultimate_Parent__c != Null){
                    		contShare.ContactId = cont.Id;
                    		contShare.UserOrGroupId = terrUltimateParentMap.get(dummyAccMap.get(cont.Id).Territory__r.Ultimate_Parent__c).TerrUser__r.User__c;
                    		contShare.ContactAccessLevel = 'edit';
                			contShare.RowCause = Schema.ContactShare.RowCause.Manual;
                	} else if(cont.AccountId == Null){
                    	userIdToDeleteSharing.add(dummyAccMap.get(oldMapContact.get(cont.id).Id).Territory__r.TerrUser__r.User__c);
                }
            shareList.add(contShare);
        }
        List<ContactShare> sharesContactToDelete = [SELECT Id, ContactId, UserOrGroupId, ContactAccessLevel, RowCause 
                                            FROM ContactShare WHERE UserOrGroupId IN : userIdToDeleteSharing];
        if(shareList.size()>0){
            Database.insert(shareList, false);
        }
        if(!sharesContactToDelete.isEmpty()){
            Database.delete(sharesContactToDelete, false);
        }    
    }
}