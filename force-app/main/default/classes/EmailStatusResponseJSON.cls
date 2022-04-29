/**
* @author      : Vinod Jakore 
* @date        : 10 March 2022
* @Class       : JSONTemplate 
* @description :  This class is to to deserialize the json response
*/
public class EmailStatusResponseJSON 
{
    public String requestId;
    public String eventCategoryType;
    public String timestamp;
    public String compositeId;
    public Info info;
    
    public class Info {
        public String messageKey;
        public String contactKey;
        public String to;
    
    }
    /** 
    * @description parse is to parse responses from Marketing cloud
    * @param json is the json response
    * @return returning the deserailize json
    */
    public static EmailStatusResponseJSON parse(String json) 
    {
        return (EmailStatusResponseJSON) System.JSON.deserialize(json, EmailStatusResponseJSON.class);
    }
    
}