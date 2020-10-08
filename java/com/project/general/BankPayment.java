/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.general;

import java.util.Date;
import com.project.main.entity.*;

/**
 *
 * @author Roy
 */
public class BankPayment extends Entity {

    private int Type = 0;
    private Date createDate;
    private long createId = 0;
    
    private String journalNumber = "";
    private String journalPrefix = "";
    private int journalCounter = 0;
    private long currencyId = 0;
    
    private Date dueDate;
    private double amount = 0;
    private long coaId = 0;
    private long coaPaymentId = 0;
    private Date paymentDate;
    private long referensiId = 0;
    
    private int status = 0;    
    private long segment1Id = 0;
    private long segment2Id = 0;
    private long segment3Id = 0;
    private long segment4Id = 0;
    private long segment5Id = 0;
    private long segment6Id = 0;
    private long segment7Id = 0;
    private long segment8Id = 0;
    private long segment9Id = 0;
    private long segment10Id = 0;
    private long segment11Id = 0;
    private long segment12Id = 0;
    private long segment13Id = 0;
    private long segment14Id = 0;
    private long segment15Id = 0;
    
    private Date transactionDate;
    private long vendorId = 0;
    private String number = "";
    private long bankId = 0;
    private long systemDocNumberId = 0;

    public int getType() {
        return Type;
    }

    public void setType(int Type) {
        this.Type = Type;
    }

    public Date getCreateDate() {
        return createDate;
    }

    public void setCreateDate(Date createDate) {
        this.createDate = createDate;
    }

    public long getCreateId() {
        return createId;
    }

    public void setCreateId(long createId) {
        this.createId = createId;
    }

    public Date getDueDate() {
        return dueDate;
    }

    public void setDueDate(Date dueDate) {
        this.dueDate = dueDate;
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

    public long getCoaPaymentId() {
        return coaPaymentId;
    }

    public void setCoaPaymentId(long coaPaymentId) {
        this.coaPaymentId = coaPaymentId;
    }

    public Date getPaymentDate() {
        return paymentDate;
    }

    public void setPaymentDate(Date paymentDate) {
        this.paymentDate = paymentDate;
    }

    public long getReferensiId() {
        return referensiId;
    }

    public void setReferensiId(long referensiId) {
        this.referensiId = referensiId;
    }

    public String getJournalNumber() {
        return journalNumber;
    }

    public void setJournalNumber(String journalNumber) {
        this.journalNumber = journalNumber;
    }

    public String getJournalPrefix() {
        return journalPrefix;
    }

    public void setJournalPrefix(String journalPrefix) {
        this.journalPrefix = journalPrefix;
    }

    public int getJournalCounter() {
        return journalCounter;
    }

    public void setJournalCounter(int journalCounter) {
        this.journalCounter = journalCounter;
    }

    public long getCurrencyId() {
        return currencyId;
    }

    public void setCurrencyId(long currencyId) {
        this.currencyId = currencyId;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    public long getSegment1Id() {
        return segment1Id;
    }

    public void setSegment1Id(long segment1Id) {
        this.segment1Id = segment1Id;
    }

    public long getSegment2Id() {
        return segment2Id;
    }

    public void setSegment2Id(long segment2Id) {
        this.segment2Id = segment2Id;
    }

    public long getSegment3Id() {
        return segment3Id;
    }

    public void setSegment3Id(long segment3Id) {
        this.segment3Id = segment3Id;
    }

    public long getSegment4Id() {
        return segment4Id;
    }

    public void setSegment4Id(long segment4Id) {
        this.segment4Id = segment4Id;
    }

    public long getSegment5Id() {
        return segment5Id;
    }

    public void setSegment5Id(long segment5Id) {
        this.segment5Id = segment5Id;
    }

    public long getSegment6Id() {
        return segment6Id;
    }

    public void setSegment6Id(long segment6Id) {
        this.segment6Id = segment6Id;
    }

    public long getSegment7Id() {
        return segment7Id;
    }

    public void setSegment7Id(long segment7Id) {
        this.segment7Id = segment7Id;
    }

    public long getSegment8Id() {
        return segment8Id;
    }

    public void setSegment8Id(long segment8Id) {
        this.segment8Id = segment8Id;
    }

    public long getSegment9Id() {
        return segment9Id;
    }

    public void setSegment9Id(long segment9Id) {
        this.segment9Id = segment9Id;
    }

    public long getSegment10Id() {
        return segment10Id;
    }

    public void setSegment10Id(long segment10Id) {
        this.segment10Id = segment10Id;
    }

    public long getSegment11Id() {
        return segment11Id;
    }

    public void setSegment11Id(long segment11Id) {
        this.segment11Id = segment11Id;
    }

    public long getSegment12Id() {
        return segment12Id;
    }

    public void setSegment12Id(long segment12Id) {
        this.segment12Id = segment12Id;
    }

    public long getSegment13Id() {
        return segment13Id;
    }

    public void setSegment13Id(long segment13Id) {
        this.segment13Id = segment13Id;
    }

    public long getSegment14Id() {
        return segment14Id;
    }

    public void setSegment14Id(long segment14Id) {
        this.segment14Id = segment14Id;
    }

    public long getSegment15Id() {
        return segment15Id;
    }

    public void setSegment15Id(long segment15Id) {
        this.segment15Id = segment15Id;
    }

    public Date getTransactionDate() {
        return transactionDate;
    }

    public void setTransactionDate(Date transactionDate) {
        this.transactionDate = transactionDate;
    }

    public long getVendorId() {
        return vendorId;
    }

    public void setVendorId(long vendorId) {
        this.vendorId = vendorId;
    }

    public String getNumber() {
        return number;
    }

    public void setNumber(String number) {
        this.number = number;
    }

    public long getBankId() {
        return bankId;
    }

    public void setBankId(long bankId) {
        this.bankId = bankId;
    }

    public long getSystemDocNumberId() {
        return systemDocNumberId;
    }

    public void setSystemDocNumberId(long systemDocNumberId) {
        this.systemDocNumberId = systemDocNumberId;
    }
}
