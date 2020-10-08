/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.ccs.postransaction.receiving;
import com.project.main.entity.Entity;
import java.util.Date;

public class Retur extends Entity {
    private int incluceTax;
    private double totalTax;
    private double totalAmount;
    private double taxPercent;
    private double discountTotal;
    private double discountPercent;
    private String paymentType;
    private long locationId;
    private long vendorId;
    private Date date;
    private long approval1;
    private long approval2;
    private long approval3;
    private String status;
    private long userId;
    private String note = "";
    private String number = "";
    private int counter;
    private long currencyId;

    /**
     * Holds value of property prefixNumber.
     */
    private String prefixNumber = "";
    
    /**
     * Holds value of property closedReason.
     */
    private String closedReason = "";
    
    /**
     * Holds value of property approval1Date.
     */
    private Date approval1Date;
    
    /**
     * Holds value of property approval2Date.
     */
    private Date approval2Date;
    
    /**
     * Holds value of property approval3Date.
     */
    private Date approval3Date;
    
    /**
     * Holds value of property purchaseId.
     */
    private long purchaseId;
    
    /**
     * Holds value of property dueDate.
     */
    private Date dueDate;
    
    /**
     * Holds value of property paymentAmount.
     */
    private double paymentAmount;
    
    /**
     * Holds value of property invoiceNumber.
     */
    private String invoiceNumber = "";
    
    /**
     * Holds value of property doNumber.
     */
    private String doNumber = "";
    
    /**
     * Holds value of property receiveId.
     */
    private long receiveId;
    
    public long getCurrencyId() {
        return currencyId;
    }

    public void setCurrencyId(long currencyId) {
        this.currencyId = currencyId;
    }
    
    public double getDiscountPercent() {
        return discountPercent;
    }

    public void setDiscountPercent(double discountPercent) {
        this.discountPercent = discountPercent;
    }

    public double getDiscountTotal() {
        return discountTotal;
    }

    public void setDiscountTotal(double discountTotal) {
        this.discountTotal = discountTotal;
    }

    public int getIncluceTax() {
        return incluceTax;
    }

    public void setIncluceTax(int incluceTax) {
        this.incluceTax = incluceTax;
    }

    public long getLocationId() {
        return locationId;
    }

    public void setLocationId(long locationId) {
        this.locationId = locationId;
    }

    public String getPaymentType() {
        return paymentType;
    }

    public void setPaymentType(String paymentType) {
        this.paymentType = paymentType;
    }

    public Date getDate() {
        return date;
    }

    public void setDate(Date date) {
        this.date = date;
    }

    public double getTaxPercent() {
        return taxPercent;
    }

    public void setTaxPercent(double taxPercent) {
        this.taxPercent = taxPercent;
    }

    public double getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(double totalAmount) {
        this.totalAmount = totalAmount;
    }

    public double getTotalTax() {
        return totalTax;
    }

    public void setTotalTax(double totalTax) {
        this.totalTax = totalTax;
    }

    public long getVendorId() {
        return vendorId;
    }

    public void setVendorId(long vendorId) {
        this.vendorId = vendorId;
    }

    
    public long getApproval1() {
        return approval1;
    }

    public void setApproval1(long approval1) {
        this.approval1 = approval1;
    }

    public long getApproval2() {
        return approval2;
    }

    public void setApproval2(long approval2) {
        this.approval2 = approval2;
    }

    public long getApproval3() {
        return approval3;
    }

    public void setApproval3(long approval3) {
        this.approval3 = approval3;
    }

    public int getCounter() {
        return counter;
    }

    public void setCounter(int counter) {
        this.counter = counter;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public String getNumber() {
        return number;
    }

    public void setNumber(String number) {
        this.number = number;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public long getUserId() {
        return userId;
    }

    public void setUserId(long userId) {
        this.userId = userId;
    }
    
    /**
     * Getter for property prefixNumber.
     * @return Value of property prefixNumber.
     */
    public String getPrefixNumber() {
        return this.prefixNumber;
    }
    
    /**
     * Setter for property prefixNumber.
     * @param prefixNumber New value of property prefixNumber.
     */
    public void setPrefixNumber(String prefixNumber) {
        this.prefixNumber = prefixNumber;
    }
    
    /**
     * Getter for property closedReason.
     * @return Value of property closedReason.
     */
    public String getClosedReason() {
        return this.closedReason;
    }
    
    /**
     * Setter for property closedReason.
     * @param closedReason New value of property closedReason.
     */
    public void setClosedReason(String closedReason) {
        this.closedReason = closedReason;
    }
    
    /**
     * Getter for property approval1Date.
     * @return Value of property approval1Date.
     */
    public Date getApproval1Date() {
        return this.approval1Date;
    }
    
    /**
     * Setter for property approval1Date.
     * @param approval1Date New value of property approval1Date.
     */
    public void setApproval1Date(Date approval1Date) {
        this.approval1Date = approval1Date;
    }
    
    /**
     * Getter for property approval2Date.
     * @return Value of property approval2Date.
     */
    public Date getApproval2Date() {
        return this.approval2Date;
    }
    
    /**
     * Setter for property approval2Date.
     * @param approval2Date New value of property approval2Date.
     */
    public void setApproval2Date(Date approval2Date) {
        this.approval2Date = approval2Date;
    }
    
    /**
     * Getter for property approval3Date.
     * @return Value of property approval3Date.
     */
    public Date getApproval3Date() {
        return this.approval3Date;
    }
    
    /**
     * Setter for property approval3Date.
     * @param approval3Date New value of property approval3Date.
     */
    public void setApproval3Date(Date approval3Date) {
        this.approval3Date = approval3Date;
    }
    
    /**
     * Getter for property purchaseId.
     * @return Value of property purchaseId.
     */
    public long getPurchaseId() {
        return this.purchaseId;
    }
    
    /**
     * Setter for property purchaseId.
     * @param purchaseId New value of property purchaseId.
     */
    public void setPurchaseId(long purchaseId) {
        this.purchaseId = purchaseId;
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
     * Getter for property paymentAmount.
     * @return Value of property paymentAmount.
     */
    public double getPaymentAmount() {
        return this.paymentAmount;
    }
    
    /**
     * Setter for property paymentAmount.
     * @param paymentAmount New value of property paymentAmount.
     */
    public void setPaymentAmount(double paymentAmount) {
        this.paymentAmount = paymentAmount;
    }
    
    /**
     * Getter for property invoiceNumber.
     * @return Value of property invoiceNumber.
     */
    public String getInvoiceNumber() {
        return this.invoiceNumber;
    }
    
    /**
     * Setter for property invoiceNumber.
     * @param invoiceNumber New value of property invoiceNumber.
     */
    public void setInvoiceNumber(String invoiceNumber) {
        this.invoiceNumber = invoiceNumber;
    }
    
    /**
     * Getter for property doNumber.
     * @return Value of property doNumber.
     */
    public String getDoNumber() {
        return this.doNumber;
    }
    
    /**
     * Setter for property doNumber.
     * @param doNumber New value of property doNumber.
     */
    public void setDoNumber(String doNumber) {
        this.doNumber = doNumber;
    }
    
    /**
     * Getter for property receiveId.
     * @return Value of property receiveId.
     */
    public long getReceiveId() {
        return this.receiveId;
    }
    
    /**
     * Setter for property receiveId.
     * @param receiveId New value of property receiveId.
     */
    public void setReceiveId(long receiveId) {
        this.receiveId = receiveId;
    }
    
}
