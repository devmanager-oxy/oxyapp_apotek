/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.fms.session;

import java.util.Date;

/**
 *
 * @author Roy Andika
 */
public class SessReportBudgetSuplier {
    
    private long bankpoPaymentId;
    private String suplier = "";
    private long vendorId;
    private String divisi = "";
    private String noTT = "";
    private double value;
    private int counter = 0;
    private Date transDate;
    
    private String noRek = "";
    private long bankId = 0;
    private String contact = "";

    public String getSuplier() {
        return suplier;
    }

    public void setSuplier(String suplier) {
        this.suplier = suplier;
    }

    public String getDivisi() {
        return divisi;
    }

    public void setDivisi(String divisi) {
        this.divisi = divisi;
    }

    public String getNoTT() {
        return noTT;
    }

    public void setNoTT(String noTT) {
        this.noTT = noTT;
    }

    public double getValue() {
        return value;
    }

    public void setValue(double value) {
        this.value = value;
    }

    public long getBankpoPaymentId() {
        return bankpoPaymentId;
    }

    public void setBankpoPaymentId(long bankpoPaymentId) {
        this.bankpoPaymentId = bankpoPaymentId;
    }

    public long getVendorId() {
        return vendorId;
    }

    public void setVendorId(long vendorId) {
        this.vendorId = vendorId;
    }

    public int getCounter() {
        return counter;
    }

    public void setCounter(int counter) {
        this.counter = counter;
    }

    public Date getTransDate() {
        return transDate;
    }

    public void setTransDate(Date transDate) {
        this.transDate = transDate;
    }

    public String getNoRek() {
        return noRek;
    }

    public void setNoRek(String noRek) {
        this.noRek = noRek;
    }

    public long getBankId() {
        return bankId;
    }

    public void setBankId(long bankId) {
        this.bankId = bankId;
    }

    public String getContact() {
        return contact;
    }

    public void setContact(String contact) {
        this.contact = contact;
    }

}
