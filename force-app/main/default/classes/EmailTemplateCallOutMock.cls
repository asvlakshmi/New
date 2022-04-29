/**
* @author      : Vinod Jakore & Lakshmi Anandam
* @date        : 10 March 2022
* @Class 	   : EmailTemplateCallOutMock 
* @description :  This test class is the extended HttpCalloutMock
*/
@isTest
global class EmailTemplateCallOutMock implements HttpCalloutMock {
    private Integer statusCode;
    /** 
	* @description TriggerHttpCallOutMock is the constructor
    * @param statusCode is the response status code
	*/
    public EmailTemplateCallOutMock(Integer statusCode){
        this.statusCode = statusCode;
    }
    /** 
	* @description respond  method to set body,header for test class
    * @param request is the http request
    * @return fake response
	*/
    global HTTPResponse respond(HTTPRequest request) {
        //System.assertEquals('https://mc0617nvs36xrn7l6xv-hfh50bbq.auth.marketingcloudapis.com/v2/token', request.getEndpoint());
        //System.assertEquals('GET', request.getBody());
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('{"access_token":"dddsadasxsaxasxasx","instance_url":"https://mc0617nvs36xrn7l6xv-hfh50bbq.auth.marketingcloudapis.comm"}');
        response.setBody('{"items": [{"id":15,"customerKey":"Test1234One","name":"Test1234","legacyId":12},{"id":16,"customerKey":"Test1234One1","name":"Test12345","legacyId":34}]}');
        response.setStatusCode(this.statusCode);
        return response; 
    }
}