
/* Created on 	:  [date] [time] AM/PM 
 * 
 * @author	 :
 * @version	 :
 */

/*******************************************************************
 * Class Description 	: [project description ... ] 
 * Imput Parameters 	: [input parameter ...] 
 * Output 		: [output ...] 
 *******************************************************************/

package com.project.fms.transaction; 
 
/* package java */ 
import java.util.Date;

/* package qdep */
import com.project.main.entity.*;

public class Purchase extends Entity { 

	private long vendorId;
	private long currencyId;
	private String vendorInvoiceNumber = "";
	private long termOfPaymentId;
	private Date date = new Date();
	private Date transDate = new Date();
	private String journalNumber = "";
	private String journalPrefix = "";
	private int journalCounter;
	private Date dueDate = new Date();
	private int vat = 1;
	private String memo = "";
	private long shipAddressId;
	private String shipAddress = "";
	private double discountPercent;
	private double discount;
	private double vatPercent;
	private double vatAmount;
	private double total;
	private String status;

        /**
         * Holds value of property operatorId.
         */
        private long operatorId;
        
        /**
         * Holds value of property closingReason.
         */
        private String closingReason;
        
        /**
         * Holds value of property closedBy.
         */
        private String closedBy;
        
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

	public String getVendorInvoiceNumber(){ 
		return vendorInvoiceNumber; 
	} 

	public void setVendorInvoiceNumber(String vendorInvoiceNumber){ 
		if ( vendorInvoiceNumber == null ) {
			vendorInvoiceNumber = ""; 
		} 
		this.vendorInvoiceNumber = vendorInvoiceNumber; 
	} 

	public long getTermOfPaymentId(){ 
		return termOfPaymentId; 
	} 

	public void setTermOfPaymentId(long termOfPaymentId){ 
		this.termOfPaymentId = termOfPaymentId; 
	} 

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

	public int getJournalCounter(){ 
		return journalCounter; 
	} 

	public void setJournalCounter(int journalCounter){ 
		this.journalCounter = journalCounter; 
	} 

	public Date getDueDate(){ 
		return dueDate; 
	} 

	public void setDueDate(Date dueDate){ 
		this.dueDate = dueDate; 
	} 

	public int getVat(){ 
		return vat; 
	} 

	public void setVat(int vat){ 
		this.vat = vat; 
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

	public long getShipAddressId(){ 
		return shipAddressId; 
	} 

	public void setShipAddressId(long shipAddressId){ 
		this.shipAddressId = shipAddressId; 
	} 

	public String getShipAddress(){ 
		return shipAddress; 
	} 

	public void setShipAddress(String shipAddress){ 
		if ( shipAddress == null ) {
			shipAddress = ""; 
		} 
		this.shipAddress = shipAddress; 
	} 

	public double getDiscountPercent(){ 
		return discountPercent; 
	} 

	public void setDiscountPercent(double discountPercent){ 
		this.discountPercent = discountPercent; 
	} 

	public double getDiscount(){ 
		return discount; 
	} 

	public void setDiscount(double discount){ 
		this.discount = discount; 
	} 

	public double getVatPercent(){ 
		return vatPercent; 
	} 

	public void setVatPercent(double vatPercent){ 
		this.vatPercent = vatPercent; 
	} 

	public double getVatAmount(){ 
		return vatAmount; 
	} 

	public void setVatAmount(double vatAmount){ 
		this.vatAmount = vatAmount; 
	} 

	public double getTotal(){ 
		return total; 
	} 

	public void setTotal(double total){ 
		this.total = total; 
	} 

	public String getStatus(){ 
		return status; 
	} 

	public void setStatus(String status){ 
		this.status = status; 
	} 

        /**
         * Getter for property operatorId.
         * @return Value of property operatorId.
         */
        public long getOperatorId() {
            return this.operatorId;
        }
        
        /**
         * Setter for property operatorId.
         * @param operatorId New value of property operatorId.
         */
        public void setOperatorId(long operatorId) {
            this.operatorId = operatorId;
        }
        
        /**
         * Getter for property closingReason.
         * @return Value of property closingReason.
         */
        public String getClosingReason() {
            return this.closingReason;
        }
        
        /**
         * Setter for property closingReason.
         * @param closingReason New value of property closingReason.
         */
        public void setClosingReason(String closingReason) {
            this.closingReason = closingReason;
        }
        
        /**
         * Getter for property closedBy.
         * @return Value of property closedBy.
         */
        public String getClosedBy() {
            return this.closedBy;
        }
        
        /**
         * Setter for property closedBy.
         * @param closedBy New value of property closedBy.
         */
        public void setClosedBy(String closedBy) {
            this.closedBy = closedBy;
        }
        
}
