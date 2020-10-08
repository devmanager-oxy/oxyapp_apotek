/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.ccs.postransaction.sales;
import java.util.Date;
import com.project.main.entity.*;
/**
 *
 * @author Administrator
 */
public class Payment extends Entity{
    private long sales_id=0;
    private long currency_id=0;
    private Date pay_date = new Date();
    private int pay_type = 0;
    private double amount = 0;
    private double rate =0;
    private double cost_card_amount = 0;
    private double cost_card_percent = 0;
    private long bankId;
    private long merchantId;
    
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

    public Date getPay_date() {
        return pay_date;
    }

    public void setPay_date(Date pay_date) {
        this.pay_date = pay_date;
    }

    public int getPay_type() {
        return pay_type;
    }

    public void setPay_type(int pay_type) {
        this.pay_type = pay_type;
    }

    public double getAmount() {
        return amount;
    }

    public void setAmount(double amount) {
        this.amount = amount;
    }

    public double getCost_card_amount() {
        return cost_card_amount;
    }

    public void setCost_card_amount(double cost_card_amount) {
        this.cost_card_amount = cost_card_amount;
    }

    public double getCost_card_percent() {
        return cost_card_percent;
    }

    public void setCost_card_percent(double cost_card_percent) {
        this.cost_card_percent = cost_card_percent;
    }

    public double getRate() {
        return rate;
    }

    public void setRate(double rate) {
        this.rate = rate;
    }

    public long getBankId() {
        return bankId;
    }

    public void setBankId(long bankId) {
        this.bankId = bankId;
    }

    public long getMerchantId() {
        return merchantId;
    }

    public void setMerchantId(long merchantId) {
        this.merchantId = merchantId;
    }
}
