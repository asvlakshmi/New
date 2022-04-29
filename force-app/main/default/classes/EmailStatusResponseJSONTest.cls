/**
* @author      : Vinod Jakore 
* @date        : 10 March 2022
* @Class 	   : EmailStatusResponseJSONTest 
* @description :  This is the test class for EmailStatusResponseJSON
*/
@IsTest
public class EmailStatusResponseJSONTest {
	@isTest
	static  void testParse() {
		String json = '{\"requestId\":\"0b370393-45d3-4879-a12f-76e26248e433\",\"eventCategoryType\":\"TransactionalSendEvents.EmailSent\",\"timestamp\":\"2022-03-14T04:10:44.82\",\"compositeId\":\"D8018CDE-7EA3-EC11-B852-F40343C97A68.98928.479.1.1172424\",\"info\":{\"messageKey\":\"wySV0ETvD0yp1VmiQygFdA\",\"contactKey\":\"0030900000ESlwbAAD\",\"to\":\"vinod.jakore@diconium.com\"}}';
		EmailStatusResponseJSON obj = EmailStatusResponseJSON.parse(json);
		System.assert(obj != null,'object is not null');
	}
}