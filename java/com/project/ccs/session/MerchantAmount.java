/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.ccs.session;

/**
 *
 * @author Roy Andika
 */
public class MerchantAmount {
    private long merchantId = 0;
    private double cAmount = 0;
    private double dAmount = 0;

    public long getMerchantId() {
        return merchantId;
    }

    public void setMerchantId(long merchantId) {
        this.merchantId = merchantId;
    }

    public double getCAmount() {
        return cAmount;
    }

    public void setCAmount(double cAmount) {
        this.cAmount = cAmount;
    }

    public double getDAmount() {
        return dAmount;
    }

    public void setDAmount(double dAmount) {
        this.dAmount = dAmount;
    }

    
}
