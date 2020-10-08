/*
 * SessPurchaseOrder.java
 *
 * Created on January 17, 2009, 9:43 AM
 */

package com.project.ccs.report;
import java.util.*;
import com.project.main.entity.*;

/**
 *
 * @author  offices
 */
public class SessPurchaseOrder extends Entity {
    
    /**
     * Holds value of property vendor.
     */
    private String vendor;
    
    /**
     * Holds value of property address.
     */
    private String address;
    
    /**
     * Holds value of property poNumber.
     */
    private String poNumber;
    
    /**
     * Holds value of property date.
     */
    private Date date;
    
    /**
     * Holds value of property paymentType.
     */
    private String paymentType;
    
    /**
     * Holds value of property notes.
     */
    private String notes;
    
    /**
     * Holds value of property deliverTo.
     */
    private String deliverTo;
    
    /**
     * Holds value of property applayVat.
     */
    private int applayVat;
    
    /**
     * Holds value of property subTotal.
     */
    private double subTotal;
    
    /**
     * Holds value of property discount1.
     */
    private double discount1;
    
    /**
     * Holds value of property discount2.
     */
    private double discount2;
    
    /**
     * Holds value of property vat1.
     */
    private double vat1;
    
    /**
     * Holds value of property grandTotal.
     */
    private double grandTotal;
    
    /**
     * Holds value of property vat2.
     */
    private double vat2;
    private Date expiredDate;
    
    /** Creates a new instance of SessPurchaseOrder */
    public SessPurchaseOrder() {
    }
    
    /**
     * Getter for property vendor.
     * @return Value of property vendor.
     */
    public String getVendor() {
        return this.vendor;
    }
    
    /**
     * Setter for property vendor.
     * @param vendor New value of property vendor.
     */
    public void setVendor(String vendor) {
        this.vendor = vendor;
    }
    
    /**
     * Getter for property address.
     * @return Value of property address.
     */
    public String getAddress() {
        return this.address;
    }
    
    /**
     * Setter for property address.
     * @param address New value of property address.
     */
    public void setAddress(String address) {
        this.address = address;
    }
    
    /**
     * Getter for property poNumber.
     * @return Value of property poNumber.
     */
    public String getPoNumber() {
        return this.poNumber;
    }
    
    /**
     * Setter for property poNumber.
     * @param poNumber New value of property poNumber.
     */
    public void setPoNumber(String poNumber) {
        this.poNumber = poNumber;
    }
    
    /**
     * Getter for property date.
     * @return Value of property date.
     */
    public Date getDate() {
        return this.date;
    }
    
    /**
     * Setter for property date.
     * @param date New value of property date.
     */
    public void setDate(Date date) {
        this.date = date;
    }
    
    /**
     * Getter for property paymentType.
     * @return Value of property paymentType.
     */
    public String getPaymentType() {
        return this.paymentType;
    }
    
    /**
     * Setter for property paymentType.
     * @param paymentType New value of property paymentType.
     */
    public void setPaymentType(String paymentType) {
        this.paymentType = paymentType;
    }
    
    /**
     * Getter for property note.
     * @return Value of property note.
     */
    public String getNotes() {
        return this.notes;
    }
    
    /**
     * Setter for property note.
     * @param note New value of property note.
     */
    public void setNotes(String notes) {
        this.notes = notes;
    }
    
    /**
     * Getter for property deliverTo.
     * @return Value of property deliverTo.
     */
    public String getDeliverTo() {
        return this.deliverTo;
    }
    
    /**
     * Setter for property deliverTo.
     * @param deliverTo New value of property deliverTo.
     */
    public void setDeliverTo(String deliverTo) {
        this.deliverTo = deliverTo;
    }
    
    /**
     * Getter for property applayVat.
     * @return Value of property applayVat.
     */
    public int getApplayVat() {
        return this.applayVat;
    }
    
    /**
     * Setter for property applayVat.
     * @param applayVat New value of property applayVat.
     */
    public void setApplayVat(int applayVat) {
        this.applayVat = applayVat;
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
     * Getter for property discount1.
     * @return Value of property discount1.
     */
    public double getDiscount1() {
        return this.discount1;
    }
    
    /**
     * Setter for property discount1.
     * @param discount1 New value of property discount1.
     */
    public void setDiscount1(double discount1) {
        this.discount1 = discount1;
    }
    
    /**
     * Getter for property discount2.
     * @return Value of property discount2.
     */
    public double getDiscount2() {
        return this.discount2;
    }
    
    /**
     * Setter for property discount2.
     * @param discount2 New value of property discount2.
     */
    public void setDiscount2(double discount2) {
        this.discount2 = discount2;
    }
    
    /**
     * Getter for property vat.
     * @return Value of property vat.
     */
    public double getVat1() {
        return this.vat1;
    }
    
    /**
     * Setter for property vat.
     * @param vat New value of property vat.
     */
    public void setVat1(double vat1) {
        this.vat1 = vat1;
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
     * Getter for property vat2.
     * @return Value of property vat2.
     */
    public double getVat2() {
        return this.vat2;
    }
    
    /**
     * Setter for property vat2.
     * @param vat2 New value of property vat2.
     */
    public void setVat2(double vat2) {
        this.vat2 = vat2;
    }

    public Date getExpiredDate() {
        return expiredDate;
    }

    public void setExpiredDate(Date expiredDate) {
        this.expiredDate = expiredDate;
    }
    
}
