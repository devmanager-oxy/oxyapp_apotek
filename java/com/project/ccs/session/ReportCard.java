/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.ccs.session;

import java.util.Date;

/**
 *
 * @author Roy Andika
 */
public class ReportCard {
    
    private long salesId = 0 ;
    private String salesNumber = "";
    private Date date;
    private long bankId;
    private String bankName = "";
    private String description = "";
    private long merchantId ;
    private double persenExpense;
    private String codeMerchant = "";

    public long getSalesId() {
        return salesId;
    }

    public void setSalesId(long salesId) {
        this.salesId = salesId;
    }

    public String getSalesNumber() {
        return salesNumber;
    }

    public void setSalesNumber(String salesNumber) {
        this.salesNumber = salesNumber;
    }

    public Date getDate() {
        return date;
    }

    public void setDate(Date date) {
        this.date = date;
    }

    public long getBankId() {
        return bankId;
    }

    public void setBankId(long bankId) {
        this.bankId = bankId;
    }

    public String getBankName() {
        return bankName;
    }

    public void setBankName(String bankName) {
        this.bankName = bankName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public long getMerchantId() {
        return merchantId;
    }

    public void setMerchantId(long merchantId) {
        this.merchantId = merchantId;
    }

    public double getPersenExpense() {
        return persenExpense;
    }

    public void setPersenExpense(double persenExpense) {
        this.persenExpense = persenExpense;
    }

    public String getCodeMerchant() {
        return codeMerchant;
    }

    public void setCodeMerchant(String codeMerchant) {
        this.codeMerchant = codeMerchant;
    }
    
    
}
