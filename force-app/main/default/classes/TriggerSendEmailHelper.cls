/**
* @author      : Vinod Jakore & Lakshmi Anandam 
* @date        : 10 March 2022
* @Class       : TriggerSendEmailHelper 
* @description : This class is to create trigger send in Marketing cloud and to send emails to the selected contacts from sales cloud
*/

public with sharing class TriggerSendEmailHelper 
{   
    /** 
    * @description sendEmailTrigger method will send request to marketing cloud and also create triggersenddefenition
    * @param lvIds is the selected contacts
    * @param selectedET is the selected emailTemplate Id
    * @param emailTemplatewithKey is the selected EmailTemplate Key
    * @return returning status code as integer 
    */  
    @AuraEnabled
    public static integer sendEmailTrigger(List<Id> lvIds,string selectedET,string emailTemplatewithKey) 
    {
        List<sObject> sObjectList = new List<sObject>();
        String  strSubscriberList ='';
        String  strTriggerSendDE ='';
        if(lvIds!=null && lvIds.size()>0)
        {
            sObjectList = getSObjectList(lvIds);
        }
        Map<String, dds__MCConnectExtension__c> mcExt = MCConnectExtension__c.getall();
        if(!mcExt.isEmpty()){

            strSubscriberList =  mcExt.get('MCDataExtension').dds__SubscribersList__c;
            strTriggerSendDE =  mcExt.get('MCDataExtension').dds__TSEmailTemplateDataExtension__c;
        }
        try{ 
            String triggerSendQueryString = '';

            //String authorizationHeader = 'Bearer '+sendAccesstoken;
            
            HttpRequest triggersendEmailRequest = new HttpRequest();
            
            triggersendEmailRequest.setMethod('POST');
            triggersendEmailRequest.setTimeout(30000);
            triggersendEmailRequest.setHeader('Content-Type','application/json'); 
            triggersendEmailRequest.setEndpoint('callout:MC_Connect_Ext_NamedCredential/messaging/v1/email/definitions');
            triggersendEmailRequest.setHeader('Authorization', '{!$Credential.OAuthToken}');
            
            //Prepare query string to create triggersend in Marketing cloud
            if(selectedET!='')
            {
                final String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';
                String guid = '';
                while (guid.length() < 5) {
                Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), chars.length());
                guid += chars.substring(idx, idx+1);
                }
                //string getTime = string.valueOfGmt(system.now());
                triggerSendQueryString += '{'+
                '"definitionKey": '+'"'+selectedET+'key'+'_'+guid+'",'+
                '"description": "Created via REST",'+
                '"status": "Active",'+
                '"name": '+'"'+selectedET+''+'ts'+guid+'",'+
                '"content": {'+
                '"customerKey": "'+emailTemplatewithKey+'"'+
                '},'+
                '"subscriptions": {'+
                '"list": "'+strSubscriberList+'",'+
                '"dataExtension":  "'+strTriggerSendDE+'",'+
                '"autoAddSubscriber": true,'+
                '"updateSubscriber": true'+
                '},'+
                '"options": {'+
                '"trackLinks": true'+
                '}'+
                '}';
                System.debug(LoggingLevel.Debug,'Send Query String : '+triggerSendQueryString);   
                triggersendEmailRequest.setBody(triggerSendQueryString);
                //triggersendEmailRequest.setBody('{!$Credential.OAuthConsumerKey}');
                Http triggersendEmailHttpRequest = new Http();
                HTTPResponse triggersendEmailHttpresponse = triggersendEmailHttpRequest.send(triggersendEmailRequest);
                System.debug(LoggingLevel.Debug,'TSD Response body : '+triggersendEmailHttpresponse.getBody());
                if (triggersendEmailHttpresponse.getStatusCode() == 201) {
                    integer getCode = callSendEmailMethod(triggerSendQueryString,sObjectList);
                    return getCode;
                }else{
                    System.debug(LoggingLevel.Debug,'trigger send is failed to create :'+triggersendEmailHttpresponse);
                }
                return triggersendEmailHttpresponse.getStatusCode(); 
            }  
        }
        catch(Exception e)
        {
            
            System.debug(LoggingLevel.Debug,'Error in processing request:'+e.getMessage());
            
        }
        return 0;
    } 
    /** 
    * @description getSObjectList method to return list of contacts or leads
    * @param lvIds is the selected contactIds or LeadIds
    * @return returning list of sobjects
    */  
    public static list<sObject> getSObjectList(List<Id> lvIds)
    {
        String queryString='';
        List<sObject> sObjectList = new List<sObject>();
        if(lvIds!=null && lvIds.size()>0)
        {
            if (String.valueOf(lvIds[0]).contains(Contact.sobjecttype.getDescribe().getKeyPrefix())) {
                queryString  = 'SELECT Id,Email,FirstName,LastName FROM Contact';
            }
            else if(String.valueOf(lvIds[0]).contains(Lead.sobjecttype.getDescribe().getKeyPrefix())) {
            queryString = 'SELECT Id,Email,FirstName,LastName FROM Lead';
            }
            queryString = queryString + ' WHERE Id IN :lvIds WITH SECURITY_ENFORCED';
            sObjectList = Database.query( queryString );
        }
        return sObjectList;
    }
    
    /** 
    * @description callSendEmailMethod method will send request to marketing cloud and send email to selected contacts
    * @param triggerSendQueryString is the query string for trigger send
    * @param sObjectList is the list of selectd  contacts or Leads for email send
    * @return returning status code as integer
    */
    
    @AuraEnabled
    public static integer callSendEmailMethod(String triggerSendQueryString,List<sObject>sObjectList)
    {
        System.debug(LoggingLevel.Debug,'checking the method :');
        String sendEmailtoContactList = '';
        string getTriggerDefKey = '';
        Map<string,list<sObject>> mapTDKwithContacts = new Map<string,list<sObject>>();
       // String sendAccesstoken = getAccessTokenGenericHandler.generateAccessToken();
        //String authorizationHeaderOne = 'Bearer '+sendAccesstoken;
        
        HttpRequest sendEmailRequesttoContactList = new HttpRequest();
        sendEmailRequesttoContactList.setHeader('Authorization', '{!$Credential.OAuthToken}');
        
        sendEmailRequesttoContactList.setMethod('POST');
        sendEmailRequesttoContactList.setTimeout(30000);
        sendEmailRequesttoContactList.setHeader('Content-Type','application/json'); 
        sendEmailRequesttoContactList.setEndpoint('callout:MC_Connect_Ext_NamedCredential/messaging/v1/email/messages');
        if(triggerSendQueryString.contains('"definitionKey":'))
        {
            getTriggerDefKey = triggerSendQueryString.substring(triggerSendQueryString.indexOf('"definitionKey":'),
            triggerSendQueryString.indexOf(','));
        }
        if(getTriggerDefKey!='' && sObjectList!=null)
        {
            string strTDK = getTriggerDefKey.substringAfter('"definitionKey":');
            mapTDKwithContacts.put(strTDK,sObjectList);
            sendEmailtoContactList += '{ '+ getTriggerDefKey+ ',' +' "recipients": [ ';
            for(sObject record : sObjectList){
                if(record.getSObjectType() == Contact.sObjectType)
                {
                    Contact con = (Contact) record;
                    sendEmailtoContactList += '{ '+
                    '"contactKey": "'+con.Id+'",'+
                    '"to": "'+con.Email+'", '+
                    '"attributes": {'+
                        '"FirstName": "'+con.FirstName+'",'+
                        '"LastName": "'+con.LastName+'" '+
                        
                    '}'+
                '},' ;
                }else if(record.getSObjectType() == Lead.sObjectType){
                    Lead objLead = (Lead) record;
                    sendEmailtoContactList += '{ '+
                    '"contactKey": "'+objLead.Id+'",'+
                    '"to": "'+objLead.Email+'", '+
                    '"attributes": {'+
                        '"FirstName": "'+objLead.FirstName+'",'+
                        '"LastName": "'+objLead.LastName+'" '+
                        
                    '}'+
                '},' ;
                }
                
                
            }
        }  
        sendEmailtoContactList = sendEmailtoContactList.removeEnd(',');
        sendEmailtoContactList += ']' +'}';
        System.debug(LoggingLevel.Debug,'Send Email String : '+sendEmailtoContactList);
        sendEmailRequesttoContactList.setBody(sendEmailtoContactList);
        
        Http sendEmailtoContactsHttpRequest = new Http();
        HTTPResponse sendEmailtoContactsHttpresponse = sendEmailtoContactsHttpRequest.send(sendEmailRequesttoContactList);
        System.debug(LoggingLevel.Debug,'TSD Contacts Response body : '+sendEmailtoContactsHttpresponse.getBody());
        SendEmailToContactsHttpresponseJSON sendEmailResJSON = (SendEmailToContactsHttpresponseJSON) JSON.deserialize(sendEmailtoContactsHttpresponse.getBody(), sendEmailToContactsHttpresponseJSON.class);
        system.debug(LoggingLevel.Debug,'EMail Send Response :'+sendEmailResJSON.Responses);
        if(sendEmailResJSON!=null)
        {
            TriggerSendEmailHelper.scheduleFutureclass(sendEmailResJSON,getTriggerDefKey);
        }
        return sendEmailtoContactsHttpresponse.getStatusCode();
    }
    /** 
    * @description scheduleFutureclass method schedule a future class to get email status from MC
    * @param sendEmailResJSON is the jason response 
    * @param getTriggerDefKey is the triggerdef Key
    */
    public static void scheduleFutureclass(SendEmailToContactsHttpresponseJSON sendEmailResJSON , string getTriggerDefKey)
    {
        system.debug(LoggingLevel.Debug,'EMail Send Response :'+sendEmailResJSON.Responses);
        List<String> messageKeyList = new List<String>();
        Integer length = 0;
        if(sendEmailResJSON.Responses!=null)
        {
        length = sendEmailResJSON.Responses.size(); 
        }
        for (integer i=0;i<length;i ++){
            String[] tempStr;
            String messageKeyStr = (String)JSON.serialize(sendEmailResJSON.Responses[i]);
            tempStr = messageKeyStr.split(':');
            String messageKey = tempStr[1]; 
            String trimmedMessage = messageKey.removeStart('"');
            String trimmedMessageKey = trimmedMessage.removeEnd('"}');
            
            messageKeyList.add(trimmedMessageKey);
        }
        System.debug(LoggingLevel.Debug,'message Key list :'+messageKeyList);
        if(messageKeyList!=null && messageKeyList.size()>0)
        {
            for(integer i=2;i<25;i+=22)
            {
                datetime objDT= system.now() + (0.04167 * i); 
                String hour = String.valueOf(objDT.hour());
                String min = String.valueOf(objDT.minute()); 
                String ss = String.valueOf(objDT.second());
                String day = String.valueOf(objDT.day());
                String month = String.valueOf(objDT.month());
                String year = String.valueOf(objDT.year());
                String nextFireTime = ss + ' ' + min + ' ' + hour + ' ' + day + ' ' + month +' ? '+ year;
                RetrieveEmailStatusHandler objESH = new RetrieveEmailStatusHandler(messageKeyList,getTriggerDefKey);
                System.schedule('Schedule a future class'+nextFireTime, nextFireTime, objESH);
            }
        }
    }
}