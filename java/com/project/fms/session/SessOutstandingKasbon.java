/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.fms.session;

/**
 *
 * @author Roy Andika
 */
public class SessOutstandingKasbon { 
    
    private long pettycashPaymentId;
    private String journalNumber = "";
    private long coaId;
    private double amount;
    private long employeeId;    
    private String memo;    
    
    private long cashreceiveId;
    private double cashreceiveAmount = 0;
    
    private long glId;
    private long glAmount = 0;
    
    private double saldoSisa = 0;
    

    public long getPettycashPaymentId() {
        return pettycashPaymentId;
    }

    public void setPettycashPaymentId(long pettycashPaymentId) {
        this.pettycashPaymentId = pettycashPaymentId;
    }

    public String getJournalNumber() {
        return journalNumber;
    }

    public void setJournalNumber(String journalNumber) {
        this.journalNumber = journalNumber;
    }

    public long getCoaId() {
        return coaId;
    }

    public void setCoaId(long coaId) {
        this.coaId = coaId;
    }

    public double getAmount() {
        return amount;
    }

    public void setAmount(double amount) {
        this.amount = amount;
    }

    public long getEmployeeId() {
        return employeeId;
    }

    public void setEmployeeId(long employeeId) {
        this.employeeId = employeeId;
    }

    public double getSaldoSisa() {
        return saldoSisa;
    }

    public void setSaldoSisa(double saldoSisa) {
        this.saldoSisa = saldoSisa;
    }

    public long getCashreceiveId() {
        return cashreceiveId;
    }

    public void setCashreceiveId(long cashreceiveId) {
        this.cashreceiveId = cashreceiveId;
    }

    public double getCashreceiveAmount() {
        return cashreceiveAmount;
    }

    public void setCashreceiveAmount(double cashreceiveAmount) {
        this.cashreceiveAmount = cashreceiveAmount;
    }

    public long getGlId() {
        return glId;
    }

    public void setGlId(long glId) {
        this.glId = glId;
    }

    public long getGlAmount() {
        return glAmount;
    }

    public void setGlAmount(long glAmount) {
        this.glAmount = glAmount;
    }

    public String getMemo() {
        return memo;
    }

    public void setMemo(String memo) {
        this.memo = memo;
    }
    
    
}
