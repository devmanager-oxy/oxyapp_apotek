

package com.project.fms.transaction; 
 
import java.util.Date;

import com.project.main.entity.*;

public class Invoice extends Entity { 

	private Date date = new Date();
	private Date transDate = new Date();
	private String memo = "";
	private String journalNumber = "";
	private String journalPrefix = "";
	private String vendorInvoiceNumber = "";
	private long purchaseId;
	private int journalCounter;
	private long vendorId;
	private long currencyId;
	private String status = "";
	private long operatorId;

        /**
         * Holds value of property dueDate.
         */
        private Date dueDate;
        
        /**
         * Holds value of property vatPercent.
         */
        private double vatPercent;
        
        /**
         * Holds value of property vatAmount.
         */
        private double vatAmount;
        
        /**
         * Holds value of property applyVat.
         */
        private int applyVat;
        
        /**
         * Holds value of property subTotal.
         */
        private double subTotal;
        
        /**
         * Holds value of property grandTotal.
         */
        private double grandTotal;
        
        /**
         * Holds value of property activityStatus.
         */
        private String activityStatus;
        
	public Date getDate(){ 
		return date; 
	} 

	public void setDate(Date date){ 
		this.date = date; 
	} 

	public Date getTransDate(){ 
		return transDate; 
	} 

	public void setTransDate(Date transDate){ 
		this.transDate = transDate; 
	} 

	public String getMemo(){ 
		return memo; 
	} 

	public void setMemo(String memo){ 
		if ( memo == null ) {
			memo = ""; 
		} 
		this.memo = memo; 
	} 

	public String getJournalNumber(){ 
		return journalNumber; 
	} 

	public void setJournalNumber(String journalNumber){ 
		if ( journalNumber == null ) {
			journalNumber = ""; 
		} 
		this.journalNumber = journalNumber; 
	} 

	public String getJournalPrefix(){ 
		return journalPrefix; 
	} 

	public void setJournalPrefix(String journalPrefix){ 
		if ( journalPrefix == null ) {
			journalPrefix = ""; 
		} 
		this.journalPrefix = journalPrefix; 
	} 

	public String getVendorInvoiceNumber(){ 
		return vendorInvoiceNumber; 
	} 

	public void setVendorInvoiceNumber(String vendorInvoiceNumber){ 
		if ( vendorInvoiceNumber == null ) {
			vendorInvoiceNumber = ""; 
		} 
		this.vendorInvoiceNumber = vendorInvoiceNumber; 
	} 

	public long getPurchaseId(){ 
		return purchaseId; 
	} 

	public void setPurchaseId(long purchaseId){ 
		this.purchaseId = purchaseId; 
	} 

	public int getJournalCounter(){ 
		return journalCounter; 
	} 

	public void setJournalCounter(int journalCounter){ 
		this.journalCounter = journalCounter; 
	} 

	public long getVendorId(){ 
		return vendorId; 
	} 

	public void setVendorId(long vendorId){ 
		this.vendorId = vendorId; 
	} 

	public long getCurrencyId(){ 
		return currencyId; 
	} 

	public void setCurrencyId(long currencyId){ 
		this.currencyId = currencyId; 
	} 

	public String getStatus(){ 
		return status; 
	} 

	public void setStatus(String status){ 
		if ( status == null ) {
			status = ""; 
		} 
		this.status = status; 
	} 

	public long getOperatorId(){ 
		return operatorId; 
	} 

	public void setOperatorId(long operatorId){ 
		this.operatorId = operatorId; 
	} 

        /**
         * Getter for property dueDate.
         * @return Value of property dueDate.
         */
        public Date getDueDate() {
            return this.dueDate;
        }
        
        /**
         * Setter for property dueDate.
         * @param dueDate New value of property dueDate.
         */
        public void setDueDate(Date dueDate) {
            this.dueDate = dueDate;
        }
        
        /**
         * Getter for property vatPercent.
         * @return Value of property vatPercent.
         */
        public double getVatPercent() {
            return this.vatPercent;
        }
        
        /**
         * Setter for property vatPercent.
         * @param vatPercent New value of property vatPercent.
         */
        public void setVatPercent(double vatPercent) {
            this.vatPercent = vatPercent;
        }
        
        /**
         * Getter for property vatAmount.
         * @return Value of property vatAmount.
         */
        public double getVatAmount() {
            return this.vatAmount;
        }
        
        /**
         * Setter for property vatAmount.
         * @param vatAmount New value of property vatAmount.
         */
        public void setVatAmount(double vatAmount) {
            this.vatAmount = vatAmount;
        }
        
        /**
         * Getter for property applayVat.
         * @return Value of property applayVat.
         */
        public int getApplyVat() {
            return this.applyVat;
        }
        
        /**
         * Setter for property applayVat.
         * @param applayVat New value of property applayVat.
         */
        public void setApplyVat(int applyVat) {
            this.applyVat = applyVat;
        }
        
        /**
         * Getter for property subTotal.
         * @return Value of property subTotal.
         */
        public double getSubTotal() {
            return this.subTotal;
        }
        
        /**
         * Setter for property subTotal.
         * @param subTotal New value of property subTotal.
         */
        public void setSubTotal(double subTotal) {
            this.subTotal = subTotal;
        }
        
        /**
         * Getter for property grandTotal.
         * @return Value of property grandTotal.
         */
        public double getGrandTotal() {
            return this.grandTotal;
        }
        
        /**
         * Setter for property grandTotal.
         * @param grandTotal New value of property grandTotal.
         */
        public void setGrandTotal(double grandTotal) {
            this.grandTotal = grandTotal;
        }
        
        /**
         * Getter for property activityStatus.
         * @return Value of property activityStatus.
         */
        public String getActivityStatus() {
            return this.activityStatus;
        }
        
        /**
         * Setter for property activityStatus.
         * @param activityStatus New value of property activityStatus.
         */
        public void setActivityStatus(String activityStatus) {
            this.activityStatus = activityStatus;
        }
        
}
