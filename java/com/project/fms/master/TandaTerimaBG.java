/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.fms.master;

import com.project.main.entity.Entity;
import java.util.Date;

/**
 *
 * @author Roy Andika
 */
public class TandaTerimaBG extends Entity {

    private long bankpoPaymentId = 0;
    private long vendorId = 0;
    private String supplierName = "";
    private Date transDate;
    private double amount = 0;
    private long tandaTerimaBgMainId;

    /**
     * @return the bankpoPaymentId
     */
    public long getBankpoPaymentId() {
        return bankpoPaymentId;
    }

    /**
     * @param bankpoPaymentId the bankpoPaymentId to set
     */
    public void setBankpoPaymentId(long bankpoPaymentId) {
        this.bankpoPaymentId = bankpoPaymentId;
    }

    /**
     * @return the vendorId
     */
    public long getVendorId() {
        return vendorId;
    }

    /**
     * @param vendorId the vendorId to set
     */
    public void setVendorId(long vendorId) {
        this.vendorId = vendorId;
    }

    /**
     * @return the supplierName
     */
    public String getSupplierName() {
        return supplierName;
    }

    /**
     * @param supplierName the supplierName to set
     */
    public void setSupplierName(String supplierName) {
        this.supplierName = supplierName;
    }

    /**
     * @return the transDate
     */
    public Date getTransDate() {
        return transDate;
    }

    /**
     * @param transDate the transDate to set
     */
    public void setTransDate(Date transDate) {
        this.transDate = transDate;
    }

    /**
     * @return the amount
     */
    public double getAmount() {
        return amount;
    }

    /**
     * @param amount the amount to set
     */
    public void setAmount(double amount) {
        this.amount = amount;
    }

    /**
     * @return the tandaTerimaBgMainId
     */
    public long getTandaTerimaBgMainId() {
        return tandaTerimaBgMainId;
    }

    /**
     * @param tandaTerimaBgMainId the tandaTerimaBgMainId to set
     */
    public void setTandaTerimaBgMainId(long tandaTerimaBgMainId) {
        this.tandaTerimaBgMainId = tandaTerimaBgMainId;
    }
}
