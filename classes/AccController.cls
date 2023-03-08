public with sharing class AccController {
    @AuraEnabled
    public static List<Account> getAccount() {
    	Map<String, Schema.SObjectField> fieldMap = Account.sObjectType.getDescribe().fields.getMap();
    	Set<String> setFieldNames = fieldMap.keySet();
		List<String> listFieldNames = new List<String>(setFieldNames);
    	List<Account> listAccounts = Database.query('SELECT ' + String.join(listFieldNames, ',') + ' FROM Account');
		return listAccounts;
	}
}
