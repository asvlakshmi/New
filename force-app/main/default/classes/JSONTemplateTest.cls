/**
* @author      : Vinod Jakore 
* @date        : 10 March 2022
* @Class 	   : JSONTemplateTest
* @description :  This is the test class for JSONTemplate
*/
@IsTest
public class JSONTemplateTest {
    @isTest
    static void testParse() {
        String json = '{\"count\":13,\"page\":1,\"pageSize\":50,\"links\":{},\"items\":'+
        '[{\"id\":4415,\"customerKey\":\"fbee2aa8-66bd-42fc-9f55-041d1498782b\",\"assetType\":'+
        '{\"id\":207,\"name\":\"templatebasedemail\",\"displayName\":\"Template-Based Email\"},'+
        '\"name\":\"Welcome Email\",\"enterpriseId\":510004116,\"memberId\":510004116,\"thumbnail\":{\"thumbnailUrl\":\"/v1/assets/4415/thumbnail\"},\"category\":{\"id\":9809,\"name\":\"Sample Email Template\",\"parentId\":9806},\"data\":{\"email\":{\"options\":{\"characterEncoding\":\"utf-8\"},\"legacy\":{\"legacyId\":750,\"legacyKey\":\"fbee2aa8-66bd-42fc-9f55-041d1498782b\",\"legacyType\":\"email\",\"legacyCategoryId\":9199}}},\"legacyData\":{\"legacyId\":750,\"legacyKey\":\"fbee2aa8-66bd-42fc-9f55-041d1498782b\",\"legacyType\":\"email\",\"legacyCategoryId\":9199},\"modelVersion\":2},'+
        ''+
        '{\"id\":4463,\"customerKey\":\"c3c8ccc3-9b9e-4609-812f-7b2cc5dd31f2\",\"assetType\":{\"id\":207,\"name\":\"templatebasedemail\",\"displayName\":\"Template-Based Email\"},\"name\":\"SecondEmail\",\"enterpriseId\":510004116,\"memberId\":510004116,\"thumbnail\":{\"thumbnailUrl\":\"/v1/assets/4463/thumbnail\"},\"category\":{\"id\":9809},\"data\":{\"email\":{\"options\":{\"characterEncoding\":\"utf-8\"},\"legacy\":{\"legacyId\":758,\"legacyKey\":\"c3c8ccc3-9b9e-4609-812f-7b2cc5dd31f2\",\"legacyType\":\"email\",\"legacyCategoryId\":9199}}},\"legacyData\":{\"legacyId\":758,\"legacyKey\":\"c3c8ccc3-9b9e-4609-812f-7b2cc5dd31f2\",\"legacyType\":\"email\",\"legacyCategoryId\":9199},\"modelVersion\":2},'+
        ''+
        '{\"id\":4631,\"customerKey\":\"83c72f1e-fa1a-40a4-a321-56f9a59f0200\",\"assetType\":{\"id\":207,\"name\":\"templatebasedemail\",\"displayName\":\"Template-Based Email\"},\"name\":\"Test Welcome Language\",\"enterpriseId\":510004116,\"memberId\":510004116,\"thumbnail\":{\"thumbnailUrl\":\"/v1/assets/4631/thumbnail\"},\"category\":{\"id\":9226,\"name\":\"Content Builder\",\"parentId\":0},\"data\":{\"email\":{\"options\":{\"characterEncoding\":\"utf-8\"},\"legacy\":{\"legacyId\":785,\"legacyKey\":\"83c72f1e-fa1a-40a4-a321-56f9a59f0200\",\"legacyType\":\"email\",\"legacyCategoryId\":9199}}},\"legacyData\":{\"legacyId\":785,\"legacyKey\":\"83c72f1e-fa1a-40a4-a321-56f9a59f0200\",\"legacyType\":\"email\",\"legacyCategoryId\":9199},\"modelVersion\":2}]}';
        JSONTemplate obj = JSONTemplate.parse(json);
        System.assert(obj != null,'Object is not null');
    }
}