/**
* @author      : Vinod Jakore & Lakshmi Anandam
* @date        : 10 March 2022
* @Class 	   : SendEmailToContactsHttpresponseJSONTest 
* @description :  This is the test class for SendEmailToContactsHttpresponseJSON
*/
@IsTest
public class SendEmailToContactsHttpresponseJSONTest {
	@isTest
	static void testParse() {
		String json = '{\"requestId\":\"2d36a9ec-aee3-4af3-aaae-20a33d370fd9\",\"errorcode\":0,\"responses\":[{\"messageKey\":\"wySV0ETvD0yp1VmiQygFdA\"},{\"messageKey\":\"VhzJpDANr0mkG2HLaCGXNQ\"},{\"messageKey\":\"cn_DoooqUEiO2dR-_ezwig\"},{\"messageKey\":\"N8bRrdbookGMr05roY0YfQ\"}]}';
		SendEmailToContactsHttpresponseJSON obj = SendEmailToContactsHttpresponseJSON.parse(json);
		System.assert(obj != null,'Object is not null');
	}
}