/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.ccs.postransaction.sales;

/**
 *
 * @author Administrator
 */
import java.util.Date;
import com.project.main.entity.*;


public class CreditPayment extends Entity {
    
    private long credit_payment_id = 0;
    private long sales_id =0;
    private long currency_id  = 0;
    private Date pay_datetime = new Date();
    private double amount = 0;
    private double rate = 0;
    private long cash_cashier_id =0;
    private int postedStatus;
    private Date postedDate;
    private Date effectiveDate;
    private long postedById;
    
    private int type = 0;
    private long bankId = 0;
    private long customerId = 0;    
    private long merchantId = 0;    
    
    //@Roy Andika
    //===untuk keperluan pembayaran giro    
    private long giroId = 0;
    private Date expiredDate;
    

    public long getCredit_payment_id() {
        return credit_payment_id;
    }

    public void setCredit_payment_id(long credit_payment_id) {
        this.credit_payment_id = credit_payment_id;
    }

    public long getSales_id() {
        return sales_id;
    }

    public void setSales_id(long sales_id) {
        this.sales_id = sales_id;
    }

    public long getCurrency_id() {
        return currency_id;
    }

    public void setCurrency_id(long currency_id) {
        this.currency_id = currency_id;
    }

    public Date getPay_datetime() {
        return pay_datetime;
    }

    public void setPay_datetime(Date pay_datetime) {
        this.pay_datetime = pay_datetime;
    }

    public double getAmount() {
        return amount;
    }

    public void setAmount(double amount) {
        this.amount = amount;
    }

    public double getRate() {
        return rate;
    }

    public void setRate(double rate) {
        this.rate = rate;
    }

    public long getCash_cashier_id() {
        return cash_cashier_id;
    }

    public void setCash_cashier_id(long cash_cashier_id) {
        this.cash_cashier_id = cash_cashier_id;
    }

    public int getPostedStatus() {
        return postedStatus;
    }

    public void setPostedStatus(int postedStatus) {
        this.postedStatus = postedStatus;
    }

    public Date getPostedDate() {
        return postedDate;
    }

    public void setPostedDate(Date postedDate) {
        this.postedDate = postedDate;
    }

    public Date getEffectiveDate() {
        return effectiveDate;
    }

    public void setEffectiveDate(Date effectiveDate) {
        this.effectiveDate = effectiveDate;
    }

    public long getPostedById() {
        return postedById;
    }

    public void setPostedById(long postedById) {
        this.postedById = postedById;
    }

    public int getType() {
        return type;
    }

    public void setType(int type) {
        this.type = type;
    }

    public long getBankId() {
        return bankId;
    }

    public void setBankId(long bankId) {
        this.bankId = bankId;
    }

    public long getCustomerId() {
        return customerId;
    }

    public void setCustomerId(long customerId) {
        this.customerId = customerId;
    }

    public long getMerchantId() {
        return merchantId;
    }

    public void setMerchantId(long merchantId) {
        this.merchantId = merchantId;
    }

    public long getGiroId() {
        return giroId;
    }

    public void setGiroId(long giroId) {
        this.giroId = giroId;
    }

    public Date getExpiredDate() {
        return expiredDate;
    }

    public void setExpiredDate(Date expiredDate) {
        this.expiredDate = expiredDate;
    }
}