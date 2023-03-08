public with sharing class AsyncJobController {
    @AuraEnabled(cacheable=true)
    public static List<AsyncApexJob> selectAsyncJobs() {
        List<AsyncApexJob> asyncApexJobList = new List<AsyncApexJob>([SELECT Id, Status, CompletedDate, ApexClass.Name,
                                                                     JobType, CronTriggerId FROM AsyncApexJob
                                                                      WHERE JobType != 'ApexToken']);
        return asyncApexJobList;
    }
	@AuraEnabled
    public static String executeAsyncJob(String batchName){
        String  message;
        if (batchName == 'VacancyBatch') {
            Database.executeBatch(new VacancyBatch());
          	message = 'VacancyBatch is running now';
        }
        return message;
    }
	@AuraEnabled
    public static String abortAsyncJob(String asyncJobId) {
        System.abortJob(asyncJobId);
        return 'Job aborted' + asyncJobId;
    }
}
