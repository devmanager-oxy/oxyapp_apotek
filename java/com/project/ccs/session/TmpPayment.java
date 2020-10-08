/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.ccs.session;

/**
 *
 * @author Roy Andika
 */
public class TmpPayment {

    private long paymentId = 0;
    private long currencyId = 0;
    private int payType = 0;
    private double amount = 0;
    private double costCardAmount = 0;
    private long merchantId = 0;
    private String codeMerchant = "";
    private int typePayment = 0;
    private long bankId = 0;
    private long coaId = 0;
    private long coaExpenseId = 0;
    private double persenExpense = 0;
    private long coaDiskonId = 0;
    private double persenDiskon = 0;
    private int paymentBy = 0;
    private int postingExpense = 0;
    private long pendapatanMerchant = 0;

    public long getPaymentId() {
        return paymentId;
    }

    public void setPaymentId(long paymentId) {
        this.paymentId = paymentId;
    }

    public long getCurrencyId() {
        return currencyId;
    }

    public void setCurrencyId(long currencyId) {
        this.currencyId = currencyId;
    }

    public int getPayType() {
        return payType;
    }

    public void setPayType(int payType) {
        this.payType = payType;
    }

    public double getAmount() {
        return amount;
    }

    public void setAmount(double amount) {
        this.amount = amount;
    }

    public long getMerchantId() {
        return merchantId;
    }

    public void setMerchantId(long merchantId) {
        this.merchantId = merchantId;
    }

    public String getCodeMerchant() {
        return codeMerchant;
    }

    public void setCodeMerchant(String codeMerchant) {
        this.codeMerchant = codeMerchant;
    }

    public int getTypePayment() {
        return typePayment;
    }

    public void setTypePayment(int typePayment) {
        this.typePayment = typePayment;
    }

    public long getCoaId() {
        return coaId;
    }

    public void setCoaId(long coaId) {
        this.coaId = coaId;
    }

    public long getCoaExpenseId() {
        return coaExpenseId;
    }

    public void setCoaExpenseId(long coaExpenseId) {
        this.coaExpenseId = coaExpenseId;
    }

    public double getPersenExpense() {
        return persenExpense;
    }

    public void setPersenExpense(double persenExpense) {
        this.persenExpense = persenExpense;
    }

    public long getCoaDiskonId() {
        return coaDiskonId;
    }

    public void setCoaDiskonId(long coaDiskonId) {
        this.coaDiskonId = coaDiskonId;
    }

    public double getPersenDiskon() {
        return persenDiskon;
    }

    public void setPersenDiskon(double persenDiskon) {
        this.persenDiskon = persenDiskon;
    }

    public int getPaymentBy() {
        return paymentBy;
    }

    public void setPaymentBy(int paymentBy) {
        this.paymentBy = paymentBy;
    }

    public long getBankId() {
        return bankId;
    }

    public void setBankId(long bankId) {
        this.bankId = bankId;
    }

    public double getCostCardAmount() {
        return costCardAmount;
    }

    public void setCostCardAmount(double costCardAmount) {
        this.costCardAmount = costCardAmount;
    }

    public int getPostingExpense() {
        return postingExpense;
    }

    public void setPostingExpense(int postingExpense) {
        this.postingExpense = postingExpense;
    }

    public long getPendapatanMerchant() {
        return pendapatanMerchant;
    }

    public void setPendapatanMerchant(long pendapatanMerchant) {
        this.pendapatanMerchant = pendapatanMerchant;
    }
    
     
    
}
