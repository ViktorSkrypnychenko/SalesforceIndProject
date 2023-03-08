public class CreateAccountToContactReferenceHendler {
    public static void afterInsert(List<Account> newAccountList){
        new CreateReferenceAccountToContact().referenceAfterInsert(newAccountList);
    }
}