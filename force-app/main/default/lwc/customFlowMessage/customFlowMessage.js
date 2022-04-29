import { LightningElement,track } from 'lwc';

export default class CustomFlowMessage extends LightningElement {
    @track type;
    @track message;

    connectedCallback() {
        this.displayToast('error','Please select atleast one record to proceed');
    }
   
    displayToast(type, message) {
        this.type = type;
        this.message = message;
        setTimeout(() => {
            window.history.back();
        }, 5000);
    }

    closeModel() {
        this.type = '';
        this.message = '';
        window.history.back();
	}

    get getIconName() {
        return 'utility:' + this.type;
    }

    get innerClass() {
        return 'slds-icon_container slds-icon-utility-' + this.type + ' slds-icon-utility-success slds-m-right_small slds-no-flex slds-align-top';
    }

    get outerClass() {
        return 'slds-notify slds-notify_toast slds-theme_' + this.type;
    }
}