/**
* @author      : Vinod Jakore & Lakshmi Anandam 
* @date        : 10 March 2022
* @Class 	   : EmailTemplateServiceHelper 
* @description :  This class is to bring Email Templates from Marketing cloud and display in LWC
*/

public with sharing class EmailTemplateServiceHelper {
    
    /** 
	* @description getEmailTemplate method will connect to marketing cloud and retrives Email templates
	* @return returning map of emailTemplate Id with wrapper 
	*/
    
    @AuraEnabled(cacheable=true)
    public static Map<Integer,EmailTemplateWrapper> getEmailTemplate(){
        
        Map<Integer,String> emailTemplateMap = new Map<Integer,String>(); 
        EmailTemplateWrapper objETWrapper = new EmailTemplateWrapper();
        Map<Integer,EmailTemplateWrapper> mapEmailTemplates = new Map<Integer,EmailTemplateWrapper>(); 
        
        try{ 
            
            HttpRequest getETRequest = new HttpRequest();
            getETRequest.setHeader('Authorization', '{!$Credential.OAuthToken}');
            getETRequest.setMethod('GET');
            getETRequest.setTimeout(30000);
            getETRequest.setHeader('Content-Type','application/json'); 
            getETRequest.setEndpoint('callout:MC_Connect_Ext_NamedCredential/asset/v1/content/assets/query');
            
            //Prepare query string to retrive asset types from Marketing cloud
            String queryString = '';
            queryString += '{'+
                '  "page":'+
                '        {'+
                '          "page":1,'+
                '          "pageSize":50'+
                '         },'+
                '    "query":'+
                '         {'+
                '        "leftOperand":'+
                '                    {'+
                '                     "property":"assetType.id",'+
                '                     "simpleOperator":"equal",'+
                '                     "value":207'+
                '                     },'+
                '        "logicalOperator":"OR",'+
                '        "rightOperand":'+
                '                     {'+
                '                      "property":"assetType.name",'+
                '                      "simpleOperator":"equal",'+
                '                      "value":"templatebasedemail "'+
                '                      }'+
                '           },'+
                '      "sort":'+
                '          ['+
                '            { "property":"id", "direction":"ASC" }'+
                '          ],'+
                
                '      "fields":'+
                '['+
                '               "enterpriseId",'+
                '               "memberId",'+
                '               "thumbnail",'+
                '               "category",'+
                '               "content",'+
                '               "data"'+
                '              ]'+
                '      }';
            
            getETRequest.setBody(queryString);
            Http getETHttpRequest = new Http();
            HTTPResponse getETHttpresponse = getETHttpRequest.send(getETRequest);
            if (getETHttpresponse.getStatusCode() == 200) {
                System.debug(LoggingLevel.Debug,'assets retrived sucessfully :'+getETHttpresponse);
            }else{
                System.debug(LoggingLevel.Debug,'assets retrived failled :'+getETHttpresponse);
            }
            
            
            System.debug(LoggingLevel.Debug,'json response : '+getETHttpresponse.getBody());
            JSONTemplate emailTemplate = (JSONTemplate) JSON.deserialize(getETHttpresponse.getBody(), JSONTemplate.class);
            system.debug(LoggingLevel.Debug,'EMail template Name :'+emailTemplate.items);
            Integer length = emailTemplate.items.size(); 
            for (integer i=0;i<length;i ++){
                emailTemplateMap.put(emailTemplate.items[i].id,emailTemplate.items[i].name);
                objETWrapper = new EmailTemplateWrapper();
                objETWrapper.emailTemplateId = emailTemplate.items[i].id;
                objETWrapper.emailTemplateName = emailTemplate.items[i].name;
                objETWrapper.etCustomerKey = emailTemplate.items[i].customerKey;
                objETWrapper.emailLegecyId = emailTemplate.items[i].legacyData.legacyId;
                mapEmailTemplates.put(emailTemplate.items[i].id,objETWrapper);
            }
            System.debug(LoggingLevel.Debug,'objETWrapper ::::: :'+objETWrapper);
            System.debug(LoggingLevel.Debug,'mapEmailTemplates :'+mapEmailTemplates);
            
        }catch(Exception e){
            
            System.debug(LoggingLevel.Error,'Error in processing request:  '+e.getMessage());
            
        }
        return mapEmailTemplates;
        
    }
    
    
    /** 
	* @description wrapper class to store id,name,customerkey of email temaplte from assets
	*/ 
    public class EmailTemplateWrapper
    {
        /** * @description emailTemplateId is used to store Email Template Id */
        @AuraEnabled
        public Integer emailTemplateId{get;set;} 
        /** * @description emailTemplateName is used to store Email Template Name */
        @AuraEnabled
        public String  emailTemplateName{get;set;} 
        /** * @description  etCustomerKey is used to store Email Template Customer Key */
        @AuraEnabled
        public String etCustomerKey{get;set;}
        /** * @description emailLegecyId is used to store Email Template emailLegecy Id */
        @AuraEnabled
        public Integer emailLegecyId{get;set;}
    }
    
}