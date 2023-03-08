public class CreateReferenceAccountToContact {
    public void referenceAfterInsert(List<Account> newAccountList){
        List<Reference__c> referenceToInsert = new List<Reference__c>();
        List<Contact> contactToDummyAcc = [SELECT Id, Name, AccountId FROM Contact WHERE AccountId = Null];
        for(Account dummy : newAccountList){
            for(Contact contToDummy : contactToDummyAcc){
                if(dummy.Name == (''+contToDummy.id)){
                    Reference__c createReference = new Reference__c(Name = 'Dummy Account to contact '+contToDummy.Name,
                                                                   Contact__c = contToDummy.Id,
                                                                   Account__c = dummy.Id);
                    
                    referenceToInsert.add(createReference);
                    contToDummy.AccountId = dummy.Id;
                }
            }
        }
        update contactToDummyAcc;
        if(!referenceToInsert.isEmpty()){
            insert referenceToInsert;
        }
    }
}