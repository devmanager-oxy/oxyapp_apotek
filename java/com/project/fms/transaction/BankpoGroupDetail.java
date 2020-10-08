/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.fms.transaction;

import com.project.main.entity.*;
import java.util.Date;

/**
 *
 * @author Roy
 */
public class BankpoGroupDetail extends Entity {

    private long bankpoGroupId = 0;
    private long bankpoPaymentId = 0;
    private int type = 0;
    private Date date;
    private long refId = 0;
    private long vendorId = 0;
    private double amount = 0;
    private long coaId = 0;
    private long segment1Id = 0;

    public long getBankpoGroupId() {
        return bankpoGroupId;
    }

    public void setBankpoGroupId(long bankpoGroupId) {
        this.bankpoGroupId = bankpoGroupId;
    }

    public long getBankpoPaymentId() {
        return bankpoPaymentId;
    }

    public void setBankpoPaymentId(long bankpoPaymentId) {
        this.bankpoPaymentId = bankpoPaymentId;
    }

    public Date getDate() {
        return date;
    }

    public void setDate(Date date) {
        this.date = date;
    }

    public int getType() {
        return type;
    }

    public void setType(int type) {
        this.type = type;
    }

    public long getRefId() {
        return refId;
    }

    public void setRefId(long refId) {
        this.refId = refId;
    }

    public long getVendorId() {
        return vendorId;
    }

    public void setVendorId(long vendorId) {
        this.vendorId = vendorId;
    }

    public double getAmount() {
        return amount;
    }

    public void setAmount(double amount) {
        this.amount = amount;
    }

    public long getCoaId() {
        return coaId;
    }

    public void setCoaId(long coaId) {
        this.coaId = coaId;
    }

    public long getSegment1Id() {
        return segment1Id;
    }

    public void setSegment1Id(long segment1Id) {
        this.segment1Id = segment1Id;
    }
}
