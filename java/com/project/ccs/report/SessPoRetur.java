/*
 * SessPoReturn.java
 *
 * Created on January 17, 2009, 9:29 AM
 */

package com.project.ccs.report;

import java.util.*;
import com.project.main.entity.*;

/**
 *
 * @author  Kyo
 */
public class SessPoRetur extends Entity {
    
    /**
     * Holds value of property incomingNumber.
     */
    private String incomingNumber;
    
    /**
     * Holds value of property incomingDate.
     */
    private Date incomingDate;
    
    /**
     * Holds value of property vendor.
     */
    private String vendor;
    
    /**
     * Holds value of property address.
     */
    private String address;
    
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
     * Holds value of property doNumber.
     */
    private String doNumber;
    
    /**
     * Holds value of property invoiceNumber.
     */
    private String invoiceNumber;
    
    /**
     * Holds value of property returFrom.
     */
    private String returFrom;
    
    /**
     * Holds value of property docNumber.
     */
    private String docNumber;
    
    /**
     * Holds value of property applayVat.
     */
    private int applayVat;
    
    /**
     * Holds value of property top.
     */
    private Date top;
    
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
     * Holds value of property vat2.
     */
    private double vat2;
    
    /**
     * Holds value of property grandTotal.
     */
    private double grandTotal;
    
    /**
     * Holds value of property poNumber.
     */
    private String poNumber;
    
    /**
     * Holds value of property poDate.
     */
    private Date poDate;
    
    /**
     * Holds value of property oidPo.
     */
    private long oidPo;
    
    /** Creates a new instance of SessPoReturn */
    public SessPoRetur() {
    }
    
    /**
     * Getter for property incomingNumber.
     * @return Value of property incomingNumber.
     */
    public String getIncomingNumber() {
        return this.incomingNumber;
    }
    
    /**
     * Setter for property incomingNumber.
     * @param incomingNumber New value of property incomingNumber.
     */
    public void setIncomingNumber(String incomingNumber) {
        this.incomingNumber = incomingNumber;
    }
    
    /**
     * Getter for property incomingDate.
     * @return Value of property incomingDate.
     */
    public Date getIncomingDate() {
        return this.incomingDate;
    }
    
    /**
     * Setter for property incomingDate.
     * @param incomingDate New value of property incomingDate.
     */
    public void setIncomingDate(Date incomingDate) {
        this.incomingDate = incomingDate;
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
     * Getter for property notes.
     * @return Value of property notes.
     */
    public String getNotes() {
        return this.notes;
    }
    
    /**
     * Setter for property notes.
     * @param notes New value of property notes.
     */
    public void setNotes(String notes) {
        this.notes = notes;
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
     * Getter for property returnFrom.
     * @return Value of property returnFrom.
     */
    public String getReturFrom() {
        return this.returFrom;
    }
    
    /**
     * Setter for property returnFrom.
     * @param returnFrom New value of property returnFrom.
     */
    public void setReturFrom(String returFrom) {
        this.returFrom = returFrom;
    }
    
    /**
     * Getter for property docNumber.
     * @return Value of property docNumber.
     */
    public String getDocNumber() {
        return this.docNumber;
    }
    
    /**
     * Setter for property docNumber.
     * @param docNumber New value of property docNumber.
     */
    public void setDocNumber(String docNumber) {
        this.docNumber = docNumber;
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
     * Getter for property top.
     * @return Value of property top.
     */
    public Date getTop() {
        return this.top;
    }
    
    /**
     * Setter for property top.
     * @param top New value of property top.
     */
    public void setTop(Date top) {
        this.top = top;
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
     * Getter for property vat1.
     * @return Value of property vat1.
     */
    public double getVat1() {
        return this.vat1;
    }
    
    /**
     * Setter for property vat1.
     * @param vat1 New value of property vat1.
     */
    public void setVat1(double vat1) {
        this.vat1 = vat1;
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
     * Getter for property poDate.
     * @return Value of property poDate.
     */
    public Date getPoDate() {
        return this.poDate;
    }
    
    /**
     * Setter for property poDate.
     * @param poDate New value of property poDate.
     */
    public void setPoDate(Date poDate) {
        this.poDate = poDate;
    }
    
    /**
     * Getter for property oidPo.
     * @return Value of property oidPo.
     */
    public long getOidPo() {
        return this.oidPo;
    }
    
    /**
     * Setter for property oidPo.
     * @param oidPo New value of property oidPo.
     */
    public void setOidPo(long oidPo) {
        this.oidPo = oidPo;
    }
    
}
