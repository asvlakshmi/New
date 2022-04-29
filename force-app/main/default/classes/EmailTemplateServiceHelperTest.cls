/**
* @author      : Vinod Jakore & Lakshmi Anandam
* @date        : 10 March 2022
* @Class 	   : EmailTemplateServiceHelperTest 
* @description :  This is the test class for EmailTemplateServiceHelper
*/
@isTest
public class EmailTemplateServiceHelperTest {
    @isTest
    static void testEmailTemplateCallOut()
    {
       
        Test.startTest();

        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new EmailTemplateCallOutMock(200));
        Map<Integer,dds.EmailTemplateServiceHelper.EmailTemplateWrapper> testWrapper = new Map<Integer,dds.EmailTemplateServiceHelper.EmailTemplateWrapper>();
        // Call method to test.
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock. 
        testWrapper = EmailTemplateServiceHelper.getEmailTemplate();
        System.assert(testWrapper.size()==0,'testWrapper size is 0');
        Test.stopTest();
        
    }

}