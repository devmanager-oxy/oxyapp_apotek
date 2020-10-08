/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.general;
import com.project.main.entity.*;
/**
 *
 * @author Roy Andika
 */
public class Merchant extends Entity {
    
    private long bankId;
    private long locationId;
    private String codeMerchant = "";
    private double persenExpense;
    private String description = "";
    private long coaId;
    private long coaExpenseId;
    private int typePayment;
    private double persenDiskon = 0;
    private long coaDiskonId = 0;    
    private int paymentBy = 0;
    private long pendapatanMerchant = 0;
    private int postingExpense = 0;

    public long getBankId() {
        return bankId;
    }

    public void setBankId(long bankId) {
        this.bankId = bankId;
    }

    public long getLocationId() {
        return locationId;
    }

    public void setLocationId(long locationId) {
        this.locationId = locationId;
    }

    public String getCodeMerchant() {
        return codeMerchant;
    }

    public void setCodeMerchant(String codeMerchant) {
        this.codeMerchant = codeMerchant;
    }

    public double getPersenExpense() {
        return persenExpense;
    }

    public void setPersenExpense(double persenExpense) {
        this.persenExpense = persenExpense;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
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

    public int getTypePayment() {
        return typePayment;
    }

    public void setTypePayment(int typePayment) {
        this.typePayment = typePayment;
    }

    public double getPersenDiskon() {
        return persenDiskon;
    }

    public void setPersenDiskon(double persenDiskon) {
        this.persenDiskon = persenDiskon;
    }

    public long getCoaDiskonId() {
        return coaDiskonId;
    }

    public void setCoaDiskonId(long coaDiskonId) {
        this.coaDiskonId = coaDiskonId;
    }

    public int getPaymentBy() {
        return paymentBy;
    }

    public void setPaymentBy(int paymentBy) {
        this.paymentBy = paymentBy;
    }

    public long getPendapatanMerchant() {
        return pendapatanMerchant;
    }

    public void setPendapatanMerchant(long pendapatanMerchant) {
        this.pendapatanMerchant = pendapatanMerchant;
    }

    public int getPostingExpense() {
        return postingExpense;
    }

    public void setPostingExpense(int postingExpense) {
        this.postingExpense = postingExpense;
    }
}
