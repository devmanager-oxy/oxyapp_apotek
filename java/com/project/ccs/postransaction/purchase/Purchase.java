/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.ccs.postransaction.purchase;
import com.project.main.entity.Entity;
import java.util.Date;

public class Purchase extends Entity {
    private int incluceTax;
    private double totalTax;
    private double totalAmount;
    private double taxPercent;
    private double discountTotal;
    private double discountPercent;
    private String paymentType;
    private long locationId;
    private long vendorId;
    private Date purchDate;
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
    private String prefixNumber;
    
    /**
     * Holds value of property closedReason.
     */
    private String closedReason;
    
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
    private Date expiredDate;
    
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

    public Date getPurchDate() {
        return purchDate;
    }

    public void setPurchDate(Date purchDate) {
        this.purchDate = purchDate;
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

    public Date getExpiredDate() {
        return expiredDate;
    }

    public void setExpiredDate(Date expiredDate) {
        this.expiredDate = expiredDate;
    }
    
}
