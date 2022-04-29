import { LightningElement,api,wire } from 'lwc';
import getEmailTemplate from '@salesforce/apex/EmailTemplateServiceHelper.getEmailTemplate';
import sendEmailTrigger from '@salesforce/apex/TriggerSendEmailHelper.sendEmailTrigger';
import SystemModstamp from '@salesforce/schema/Account.SystemModstamp';
export default class ListviewComponent extends LightningElement 
{
    @api listviewIds;
    arrayFields = ['Name'];
    emailTemplateList;
    selectedEmailTemplate;
    selectedCheckBox;
    selectedCustomerKey;
    selectedEmailLegacyId;
    emailTemplatesMap = [];
    statusCode;
    isLoading = false;

    

    @wire(getEmailTemplate)
    retrieveEmailTemplates({error,data})
    {
        let templateArray = [];
        console.log('cheking data::'+data);
        if(data)
        {
            this.emailTemplatesMap = data;
            console.log(this.emailTemplatesMap);
            for(let key in data)
            {
                templateArray.push({label:data[key].emailTemplateName,value:key});
            }
            this.emailTemplateList = templateArray;
        }
        
    }
    handleEmailTemplateChange(event)
    {
        this.selectedEmailTemplate = event.target.value;
        console.log(event.target.value);
        
    }
    handleSendwithSalesUser(event)
    {
        this.selectedCheckBox = event.target.checked;
    }
    sendEmailHandler()
    {
        if(this.selectedEmailTemplate &&  this.selectedCheckBox)
        {
            this.isLoading = true;
            this.selectedCustomerKey = (this.emailTemplatesMap)[this.selectedEmailTemplate].etCustomerKey;
            console.log(this.selectedCustomerKey);
            //SendEmail({lvIds:this.listviewIds,selectedET:this.selectedEmailTemplate,emailTemplatewithKey:this.selectedCustomerKey})
            sendEmailTrigger({lvIds:this.listviewIds,selectedET:this.selectedEmailTemplate,emailTemplatewithKey:this.selectedCustomerKey})
            .then((result) => {
                console.log('checking navigation from send email');
                this.statusCode = result;
                console.log(this.statusCode);
                this.isLoading = false;
               // alert('Email has been sent'); 
               if(this.statusCode == 202){
                this.template.querySelector('c-custom-toast').showToast('success', 'Email has been sent.');
               }
               
               if(this.statusCode == 400){
                this.template.querySelector('c-custom-toast').showToast('error', 'Email has not been sent due to bad request.');
               }
            })
            .catch((error) => {
                console.log('checking exception');
                this.isLoading = false;
                this.error = error;
                this.template.querySelector('c-custom-toast').showToast('error', this.error);
                
            })
            .finally(() => {
                console.log('going to the final method');
                this.isLoading = false;
                setTimeout(() => {
                    window.history.back();
                }, 1000);
            })
            
        }else {
            this.template.querySelector('c-custom-toast').showToast('error', 'Please select both email Template and checkbox to proceed.');
            
        }
    }
    callBackHandler(){
        console.log('checking cancel method');
        window.history.back();
        return false;
    }
    
}