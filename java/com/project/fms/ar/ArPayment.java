/***********************************\
|  Create by Dek-Ndut               |
|  Karya kami mohon jangan dibajak  |
|                                   |
|  10/17/2008 11:07:36 AM
\***********************************/
package com.project.fms.ar;

import java.util.Date;
import com.project.main.entity.*;

public class ArPayment extends Entity {

    private long arInvoiceId = 0;
    private long currencyId = 0;
    private double exchangeRate = 0;
    private double amount = 0;
    private long customerId = 0;
    private Date date;
    private String notes = "";
    private double arCurrencyAmount = 0;
    private long companyId = 0;
    private String journalNumber = "";
    private String journalNumberPrefix = "";
    private int counter = 0;
    private long projectId = 0;
    private long projectTermId = 0;
    private long arAccountId = 0;
    private long receiptAccountId = 0;
    private String bankTransferNumber = "";
    private Date transactionDate;
    private long operatorId = 0;
    private long refId;
    private long creditPaymentId = 0;

    public long getArInvoiceId() {
        return arInvoiceId;
    }

    public void setArInvoiceId(long arInvoiceId) {
        this.arInvoiceId = arInvoiceId;
    }

    public long getCurrencyId() {
        return currencyId;
    }

    public void setCurrencyId(long currencyId) {
        this.currencyId = currencyId;
    }

    public double getExchangeRate() {
        return exchangeRate;
    }

    public void setExchangeRate(double exchangeRate) {
        this.exchangeRate = exchangeRate;
    }

    public double getAmount() {
        return amount;
    }

    public void setAmount(double amount) {
        this.amount = amount;
    }

    public long getCustomerId() {
        return customerId;
    }

    public void setCustomerId(long customerId) {
        this.customerId = customerId;
    }

    public Date getDate() {
        return date;
    }

    public void setDate(Date date) {
        this.date = date;
    }

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        if (notes == null) {
            notes = "";
        }
        this.notes = notes;
    }

    public double getArCurrencyAmount() {
        return arCurrencyAmount;
    }

    public void setArCurrencyAmount(double arCurrencyAmount) {
        this.arCurrencyAmount = arCurrencyAmount;
    }

    public long getCompanyId() {
        return companyId;
    }

    public void setCompanyId(long companyId) {
        this.companyId = companyId;
    }

    public String getJournalNumber() {
        return journalNumber;
    }

    public void setJournalNumber(String journalNumber) {
        if (journalNumber == null) {
            journalNumber = "";
        }
        this.journalNumber = journalNumber;
    }

    public String getJournalNumberPrefix() {
        return journalNumberPrefix;
    }

    public void setJournalNumberPrefix(String journalNumberPrefix) {
        if (journalNumberPrefix == null) {
            journalNumberPrefix = "";
        }
        this.journalNumberPrefix = journalNumberPrefix;
    }

    public int getCounter() {
        return counter;
    }

    public void setCounter(int counter) {
        this.counter = counter;
    }

    public long getProjectId() {
        return projectId;
    }

    public void setProjectId(long projectId) {
        this.projectId = projectId;
    }

    public long getProjectTermId() {
        return projectTermId;
    }

    public void setProjectTermId(long projectTermId) {
        this.projectTermId = projectTermId;
    }

    public long getArAccountId() {
        return arAccountId;
    }

    public void setArAccountId(long arAccountId) {
        this.arAccountId = arAccountId;
    }

    public long getReceiptAccountId() {
        return receiptAccountId;
    }

    public void setReceiptAccountId(long receiptAccountId) {
        this.receiptAccountId = receiptAccountId;
    }

    public String getBankTransferNumber() {
        return bankTransferNumber;
    }

    public void setBankTransferNumber(String bankTransferNumber) {
        if (bankTransferNumber == null) {
            bankTransferNumber = "";
        }
        this.bankTransferNumber = bankTransferNumber;
    }

    /**
     * Getter for property transactionDate.
     * @return Value of property transactionDate.
     */
    public Date getTransactionDate() {
        return this.transactionDate;
    }

    /**
     * Setter for property transactionDate.
     * @param transactionDate New value of property transactionDate.
     */
    public void setTransactionDate(Date transactionDate) {
        this.transactionDate = transactionDate;
    }

    /**
     * Getter for property operatorId.
     * @return Value of property operatorId.
     */
    public long getOperatorId() {
        return this.operatorId;
    }

    /**
     * Setter for property operatorId.
     * @param operatorId New value of property operatorId.
     */
    public void setOperatorId(long operatorId) {
        this.operatorId = operatorId;
    }

    public long getRefId() {
        return refId;
    }

    public void setRefId(long refId) {
        this.refId = refId;
    }

    public long getCreditPaymentId() {
        return creditPaymentId;
    }

    public void setCreditPaymentId(long creditPaymentId) {
        this.creditPaymentId = creditPaymentId;
    }
}
