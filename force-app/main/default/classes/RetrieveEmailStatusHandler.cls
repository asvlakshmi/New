/**
* @author : Vinod Jakore & Lakshmi Anandam
* @date : 10 March 2022
* @Class : RetrieveEmailStatusHandler
* @description : This class is to bring Email status from Marketing cloud to sales cloud
*/



public class RetrieveEmailStatusHandler implements Schedulable {

    List<String> lstMessageKey = new List<String>();
    String objTSKey = ''
    ;
    /**
    * @description RetrieveEmailStatusHandler method will send request to marketing cloud and also bring status
    * @param messageKeyList are list of MessageKeys generated when we send an Email to selected contacts
    * @param triggerSendDefKey is the triggerDefenitionKey
    */
    
    public RetrieveEmailStatusHandler(List<String> messageKeyList,string triggerSendDefKey) {
        lstMessageKey.addAll(messageKeyList);
        system.debug(LoggingLevel.Debug,'lstMessageKey::::::::'+lstMessageKey);
        objTSKey = triggerSendDefKey;
    }
    /**
    * @description calling the RetrieveContactEmailStatus method from execute
    * @param objSC is the SchedulableContext
    */
    public void execute(SchedulableContext objSC) {
        system.debug(LoggingLevel.Debug,'lstMessageKey::::::::'+lstMessageKey);
        RetrieveEmailStatusHandler.retrieveContactEmailStatus(lstMessageKey,objTSKey);
    
    }
    /**
    * @description retrieving email status from marketing cloud
    * @param messageKeyList are list of MessageKeys generated when we send an Email to selected contacts
    * @param tsdKey is the triggerDefenitionKey
    */
    @Future(callout=true)
    public static void retrieveContactEmailStatus(List<String> messageKeyList,string tsdKey) {
    
        //String sendAccesstoken = getAccessTokenGenericHandler.generateAccessToken();
        // System.debug(LoggingLevel.Debug,'Send Refresh token : '+sendAccesstoken);
        Map<string,MessageStatusWrapper> mapResposeWithContactKey = new Map<string,MessageStatusWrapper>();
        MessageStatusWrapper objMSWrapper = new MessageStatusWrapper();
        system.debug(LoggingLevel.Debug,'messageKeyList::::::::::'+messageKeyList);
        if(messageKeyList.size()>0 && messageKeyList!=null)
        {
            try
            {
                //if(sendAccesstoken!=''){
                // String authorizationHeader = 'Bearer '+sendAccesstoken;
                for ( String messageKey : messageKeyList )
                {
                    HttpRequest getMessageStatusRequest = new HttpRequest();
                    getMessageStatusRequest.setHeader('Authorization', '{!$Credential.OAuthToken}');
                    getMessageStatusRequest.setMethod('GET');
                    getMessageStatusRequest.setTimeout(30000);
                    getMessageStatusRequest.setHeader('Content-Type','application/json');
                    getMessageStatusRequest.setEndpoint('callout:MC_Connect_Ext_NamedCredential/messaging/v1/email/messages/'+messageKey);
                    
                    Http getEmailStatusHttpRequest = new Http();
                    HTTPResponse getEmailStatusHttpresponse = getEmailStatusHttpRequest.send(getMessageStatusRequest);
                    System.debug(LoggingLevel.Debug,'Response body : '+getEmailStatusHttpresponse.getBody());
                    EmailStatusResponseJSON emailStatusResJSON = (EmailStatusResponseJSON) JSON.deserialize(getEmailStatusHttpresponse.getBody(), EmailStatusResponseJSON.class);
                    system.debug(LoggingLevel.Debug,'EMail Send Response :'+emailStatusResJSON.eventCategoryType);
                    objMSWrapper = new MessageStatusWrapper();
                    objMSWrapper.eventCategoryType = emailStatusResJSON.eventCategoryType;
                    objMSWrapper.timestamp = emailStatusResJSON.timestamp;
                    mapResposeWithContactKey.put(emailStatusResJSON.Info.contactKey,objMSWrapper);
                    system.debug(LoggingLevel.Debug,'mapResposeWithContactKey:::::::::::::::'+mapResposeWithContactKey);
                }
            } 
            catch(Exception e){
                System.debug(LoggingLevel.Error,'Error in processing request: '+e.getMessage());
            }
            if( mapResposeWithContactKey!= null && mapResposeWithContactKey.size()>0)
            {
                system.debug(LoggingLevel.Debug,'mapResposeWithContactKey:::::::::::::::'+mapResposeWithContactKey);
                RetrieveEmailStatusHandler.createRecordsforTSDandIER(tsdKey,mapResposeWithContactKey);
            }
        }
    }
    /**
    * @description wrapper class to store send datetime,eventcategorytype
    */
    public class MessageStatusWrapper
    {
        /** * @description eventCategoryType is to store email Status */
        public String eventCategoryType{get;set;}
        /** * @description timestamp is to store timestamp of the email sent */
        public String timestamp{get;set;}
    
    }
    /**
    * @description create IER
    * @param objTriggerDefKey is the triggerdefenitionKey
    * @param mapContactKey map of contactKey with Wrapper
    */
    public static void createRecordsforTSDandIER(String objTriggerDefKey,Map<string,MessageStatusWrapper> mapContactKey)
    {
        et4ae5__Automated_Send__c objAutomatedSend = new et4ae5__Automated_Send__c();
        List<et4ae5__Automated_Send__c> automatedSendList = new List<et4ae5__Automated_Send__c>();
        List<et4ae5__IndividualEmailResult__c> indivEmailResultsList = new List<et4ae5__IndividualEmailResult__c>();
        if(objTriggerDefKey !='')
        {
            automatedSendList =[select Id,et4ae5__etTriggeredSendDefId__c from et4ae5__Automated_Send__c where et4ae5__etTriggeredSendDefId__c =: objTriggerDefKey WITH SECURITY_ENFORCED ];
            if(automatedSendList.isEmpty())
            {
                objAutomatedSend = new et4ae5__Automated_Send__c();
                objAutomatedSend.et4ae5__etTriggeredSendDefId__c = objTriggerDefKey;
                automatedSendList.add(objAutomatedSend);
                SObjectAccessDecision accessDecision = Security.stripInaccessible(AccessType.CREATABLE,automatedSendList);
                try{
                    insert accessDecision.getRecords();
                }
                catch(exception ex)
                {
                    system.debug(LoggingLevel.Error,ex.getMessage());
                }
            }
            else
            {
                objAutomatedSend = new et4ae5__Automated_Send__c();
                objAutomatedSend = automatedSendList[0];
            }
        }
        if(objAutomatedSend != null)
        {
            indivEmailResultsList = [select Id,et4ae5__TriggeredSendDefinition__c,et4ae5__Contact__c,et4ae5__Lead__c,dds__Email_Status__c,dds__Send_User__c from et4ae5__IndividualEmailResult__c where et4ae5__TriggeredSendDefinition__c =: objAutomatedSend.Id WITH SECURITY_ENFORCED];
        }
        system.debug(LoggingLevel.Debug,'list of IERS::::::::::::'+indivEmailResultsList);
        if(mapContactKey!=null && mapContactKey.size()>0){
            RetrieveEmailStatusHandler.getIERstoInsertandUpdate(objAutomatedSend,indivEmailResultsList,mapContactKey);
        }
    
    }
    /**
    * @description getIERstoInsertandUpdate method to get list of IndividualEmailResults records
    * @param objAutomatedSend is the automatedsend record
    * @param indivEmailResultsList list of IERS
    * @param mapContactKey is the map of contactKey with Wrapper
    */
    public static void getIERstoInsertandUpdate(et4ae5__Automated_Send__c objAutomatedSend,List<et4ae5__IndividualEmailResult__c> indivEmailResultsList,Map<string,MessageStatusWrapper> mapContactKey)
    {
        List<et4ae5__IndividualEmailResult__c> lstIER = new List<et4ae5__IndividualEmailResult__c>();
        for (String contactKey : mapContactKey.keySet())
        {
            if(indivEmailResultsList.isEmpty())
            {
                et4ae5__IndividualEmailResult__c objIER = new et4ae5__IndividualEmailResult__c();
                if(contactKey.contains(Contact.sobjecttype.getDescribe().getKeyPrefix()))
                {
                    objIER.et4ae5__Contact__c = contactKey;
                }
                if(contactKey.contains(Lead.sobjecttype.getDescribe().getKeyPrefix()))
                {
                    objIER.et4ae5__Lead__c = contactKey;
                }
                objIER.et4ae5__TriggeredSendDefinition__c = objAutomatedSend.Id;
                objIER.dds__Email_Status__c = (mapContactKey.get(contactKey).eventCategoryType).substringAfter('.');
                objIER.et4ae5__DateSent__c = date.valueOf(mapContactKey.get(contactKey).timestamp);
                objIER.dds__Send_User__c = UserInfo.getUserId();
                lstIER.add(objIER);
            }
            else
            {
                for(et4ae5__IndividualEmailResult__c objIER : indivEmailResultsList)
                {
                    if(objIER.dds__Email_Status__c != mapContactKey.get(contactKey).eventCategoryType)
                    {
                    objIER.dds__Email_Status__c = mapContactKey.get(contactKey).eventCategoryType;
                    }
                }
            }
        }
        if((lstIER!=null &&  lstIER.size()>0)|| (indivEmailResultsList!=null && indivEmailResultsList.size()>0))
        {
            RetrieveEmailStatusHandler.sendIERListtoInsertOrUpdate(lstIER,indivEmailResultsList);
        }
    }
    /**
    * @description sendIERListtoInsertOrUpdate method to Insert or Update IndividualEmailResults records
    * @param lstIERtoInsert list of IERS to insert
    * @param lstIERtoUpdate list of IERS to update
    */
    public static void sendIERListtoInsertOrUpdate(List<et4ae5__IndividualEmailResult__c> lstIERtoInsert,List<et4ae5__IndividualEmailResult__c> lstIERtoUpdate)
    {
        if(lstIERtoInsert!=null && lstIERtoInsert.size()>0)
        {
            SObjectAccessDecision decision = Security.stripInaccessible(AccessType.CREATABLE,lstIERtoInsert);
            try{
                insert decision.getRecords();
            }
            catch(exception ex)
            {
                system.debug(LoggingLevel.Error,ex.getMessage());
            }
            system.debug(LoggingLevel.Debug,'lstIERtoInsert:::::::::::'+lstIERtoInsert);
        }
        if(lstIERtoUpdate!=null && lstIERtoUpdate.size()>0)
        {
            SObjectAccessDecision securityDecision = Security.stripInaccessible(AccessType.UPDATABLE, lstIERtoUpdate);
            try{
                update securityDecision.getRecords();
            }
            catch(exception ex)
            {
                system.debug(LoggingLevel.Error,ex.getMessage());
            }
        }
    }
}