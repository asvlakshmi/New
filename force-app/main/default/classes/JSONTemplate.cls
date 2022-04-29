/**
* @author      : Vinod Jakore 
* @date        : 10 March 2022
* @Class       : JSONTemplate 
* @description :  This class is to to deserialize the json response
*/

public class JSONTemplate {

    public Integer count;
    public Integer page;
    public Integer pageSize;
    public Links links;
    public List<Items> items;
    /** 
    * @description Category_Z is to store category from MC
    */
    public class Category_Z {
        public Integer id;
    }
    /** 
    * @description Options is  to store Options from MC
    */
    public class Options {
        public String characterEncoding;
    }
    /** 
    * @description AssetType is to store AssetType from MC
    */
    public class AssetType {
        public Integer id;
        public String name;
        public String displayName;
    }
    /** 
    * @description Category is to store category from MC
    */
    public class Category {
        public Integer id;
        public String name;
        public Integer parentId;
    }
    /** 
    * @description Email is to store email from MC
    */
    public class Email {
        public Options options;
        public Legacy legacy;
    }
    /** 
    * @description Legacy is to store Legacy from MC
    */
    public class Legacy {
        public Integer legacyId;
        public String legacyKey;
        public String legacyType;
        public Integer legacyCategoryId;
    }
    /** 
    * @description Links  
    */
    public class Links {
    }
    /** 
    * @description Data is to store data from MC
    */
    public class Data {
        public Email email;
    }
    /** 
    * @description Items is to store items from MC
    */
    public class Items {
        public Integer id;
        public String customerKey;
        public AssetType assetType;
        public String name;
        public Integer enterpriseId;
        public Integer memberId;
        public Thumbnail thumbnail;
        public Category category;
        public Data data;
        public Legacy legacyData;
        public Integer modelVersion;
    }
    /** 
    * @description Thumbnail is to store Thumbnail from MC
    */
    public class Thumbnail {
        public String thumbnailUrl;
    }

    /** 
    * @description parse is to parse responses from Marketing cloud
    * @param json is the json response
    * @return returning the deserailize json
    */
    public static JSONTemplate parse(String json) {
        return (JSONTemplate) System.JSON.deserialize(json, JSONTemplate.class);
    }


}