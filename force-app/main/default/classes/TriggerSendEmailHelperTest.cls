/**
* @author      : Vinod Jakore & Lakshmi Anandam
* @date        : 10 March 2022
* @Class 	   : TriggerSendEmailHelperTest 
* @description :  This is the test class for TriggerSendEmailHelper
*/
@isTest
public class TriggerSendEmailHelperTest {
    /** 
	* @description data setup for test class
	*/
    @testSetup static void setup()
    {
        List<Contact> testConts = new List<Contact>();
        for(Integer i=0;i<2;i++) {
            testConts.add(new Contact(LastName = 'TestCont'+i));
        }
        testConts[0].Email = 'test@gmail.com';
        testConts[1].Email = 'abc@test.com';
        insert testConts;  
        System.assert(!testConts.isEmpty(),'List should not be empty');
        List<Lead> testLeads = new List<Lead>();
        for(Integer i=0;i<2;i++) {
            testLeads.add(new Lead(LastName = 'TestLead'+i,Company = 'Test'+i));
        }
        testLeads[0].Email = 'test@gmail.com';
        testLeads[1].Email = 'abc@test.com';
        insert testLeads;  
        System.assert(!testLeads.isEmpty(),'List should not be empty');
       
    }
    /** 
	* @description test method to create tigger send
	*/
    @isTest
    static void testTriggerSendCallOut()
    {
		String testTemplateId = '1234';
        String testTemplateKey = 'eff96282-4ef3-430a-97e2-3ab4b73dc0fd';
		List<Contact> contactList = new List<Contact>();
        contactList = [SELECT Id,Email,FirstName,LastName FROM Contact WHERE LastName LIKE 'TestCont%' Limit 2]; 
        List<Lead> leadList = new List<Lead>();
        leadList = [SELECT Id,Email,FirstName,LastName FROM Lead WHERE LastName LIKE 'TestLead%' Limit 2];  
        List<String> lstConIds = new List<String>();
        lstConIds.add(contactList[0].Id);
        lstConIds.add(contactList[1].Id);
        lstConIds.add(leadList[0].Id);
        lstConIds.add(leadList[1].Id);
        System.assert(!lstConIds.isEmpty(),'List should not be empty');
        Test.startTest();

        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new TriggerHttpCallOutMock(200));
        
        // Call method to test.
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock. 
        integer getNumber = TriggerSendEmailHelper.SendEmailTrigger(lstConIds,testTemplateId,testTemplateKey);
        if(getNumber == 200)
        {
            Test.setMock(HttpCalloutMock.class, new TriggerHttpCallOutMock(201));
            
        }
        Test.stopTest();
        
    }
    /** 
	* @description test method to send an email to the contacts
	*/
    @isTest
    static void testTriggerSendCallOutOne()
    {
		String testTSDK='';
        testTSDK += '{'+
        '"definitionKey": '+'"'+'Testkey'+'_'+'1234'+'",'+
        '"description": "Created via REST",'+
        '"status": "Active"'+
        '}';
		List<contact> contactList = new List<contact>();
        contactList = [SELECT Id,Email,FirstName,LastName FROM Contact  WHERE LastName LIKE 'TestCont%' Limit 2]; 
        List<lead> leadList = new  List<lead>();
        leadList = [SELECT Id,Email,FirstName,LastName FROM Lead  WHERE LastName LIKE 'TestLead%' Limit 2];  
        List<sObject> sObjectList = new List<sObject>(); 
        sObjectList.addAll(contactList);
        sObjectList.addAll(leadList);
        
        System.assert(!contactList.isEmpty(),'List should not be empty');
        Test.startTest();

        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new TriggerHttpCallOutMock(200));
        
        // Call method to test.
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock. 
        integer getNumber = TriggerSendEmailHelper.CallSendEmailMethod(testTSDK,sObjectList);
        if(getNumber == 200)
        {
            Test.setMock(HttpCalloutMock.class, new TriggerHttpCallOutMock(201));
            
        }
        Test.stopTest();
        
    }
   
}