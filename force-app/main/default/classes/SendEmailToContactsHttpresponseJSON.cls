/**
* @author      : Vinod Jakore & Lakshmi Anandam 
* @date        : 10 March 2022
* @Class       : sendEmailtoContactsHttpresponseJSON 
* @description : This class is to deserialize the json response
*/
public class SendEmailToContactsHttpresponseJSON {
    public String requestId;
    public Integer errorcode;
    public List<Responses> responses;
    /** 
    * @description Responses is to get responses from Marketing cloud
    */
    public class Responses {
        public String messageKey;
    }

    /** 
    * @description Responses is to get responses from Marketing cloud
    * @param json is the json response
    * @return returning the deserailize json
    */
    public static SendEmailToContactsHttpresponseJSON  parse(String json) {
        return (SendEmailToContactsHttpresponseJSON) System.JSON.deserialize(json, SendEmailToContactsHttpresponseJSON.class);
    }
}