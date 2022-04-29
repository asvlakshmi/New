/**
* @author      : Vinod Jakore & Lakshmi Anandam
* @date        : 10 March 2022
* @Class 	   : RetrieveEmailStatusHandlerTest 
* @description :  This is the test class for RetrieveEmailStatusHandler
*/
@isTest
public  class RetrieveEmailStatusHandlerTest {

    @isTest
    static void testSchedule(){

        datetime objTestDT= system.now()+1; 
        String testHour = String.valueOf(objTestDT.hour());
        String testMin = String.valueOf(objTestDT.minute()); 
        String testSs = String.valueOf(objTestDT.second());
        String testDay = String.valueOf(objTestDT.day());
        String testMonth = String.valueOf(objTestDT.month());
        String testYear = String.valueOf(objTestDT.year());
        String fireTime = testSs + ' ' + testMin + ' ' + testHour + ' ' + testDay + ' ' + testMonth +' ? '+ testYear;
    
        String testTSKey = 'eff96282-4ef3-430a-97e2-3ab4b73dc0fd';
        Contact objTestCon = new Contact(LastName = 'TestContact');
        insert  objTestCon;
        System.assert(objTestCon != null,'Object is not null');
        String testContactKey = objTestCon.id;
        List<String> myStrings = new List<String>{'1234567gth', '4567hnb'}; 
        Map<string,RetrieveEmailStatusHandler.MessageStatusWrapper> testMapContactKey = new Map<string,RetrieveEmailStatusHandler.MessageStatusWrapper> ();
        RetrieveEmailStatusHandler.MessageStatusWrapper objTestStatusWrapper= new RetrieveEmailStatusHandler.MessageStatusWrapper();
        objTestStatusWrapper.eventCategoryType ='Email Test Status';
        objTestStatusWrapper.timestamp = string.valueof(system.now()+2);
        testMapContactKey.put(testContactKey,objTestStatusWrapper);
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new TriggerHttpCallOutMock(200));
            
            System.schedule('ScheduledApexTest',fireTime,new RetrieveEmailStatusHandler(myStrings,testTSKey));
            RetrieveEmailStatusHandler.CreateRecordsforTSDandIER(testTSKey,testMapContactKey);
            
        Test.stopTest();
        
    }
}