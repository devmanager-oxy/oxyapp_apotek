/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.ccs.postransaction.sales;

import com.project.main.entity.Entity;
import java.util.Date;

/**
 *
 * @author Roy Andika
 */
public class GiroTransaction extends Entity {

    private int transactionType = 0;
    private long sourceId = 0;
    private long coaId = 0;
    private Date dateTransaction = new Date();
    private Date dueDate = new Date();
    private int status = 0;
    private long giroId = 0;
    private double amount = 0;    
    private long customerId = 0;
    private String number = "";
    private long segmentId = 0;
    private String numberPrefix = "";
    private int counter = 0;
    private long segment1IdPosted = 0;

    public int getTransactionType() {
        return transactionType;
    }

    public void setTransactionType(int transactionType) {
        this.transactionType = transactionType;
    }

    public long getSourceId() {
        return sourceId;
    }

    public void setSourceId(long sourceId) {
        this.sourceId = sourceId;
    }

    public long getCoaId() {
        return coaId;
    }

    public void setCoaId(long coaId) {
        this.coaId = coaId;
    }

    public Date getDateTransaction() {
        return dateTransaction;
    }

    public void setDateTransaction(Date dateTransaction) {
        this.dateTransaction = dateTransaction;
    }

    public Date getDueDate() {
        return dueDate;
    }

    public void setDueDate(Date dueDate) {
        this.dueDate = dueDate;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    public long getGiroId() {
        return giroId;
    }

    public void setGiroId(long giroId) {
        this.giroId = giroId;
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

    public String getNumber() {
        return number;
    }

    public void setNumber(String number) {
        this.number = number;
    }

    public long getSegmentId() {
        return segmentId;
    }

    public void setSegmentId(long segmentId) {
        this.segmentId = segmentId;
    }

    public String getNumberPrefix() {
        return numberPrefix;
    }

    public void setNumberPrefix(String numberPrefix) {
        this.numberPrefix = numberPrefix;
    }

    public int getCounter() {
        return counter;
    }

    public void setCounter(int counter) {
        this.counter = counter;
    }

    public long getSegment1IdPosted() {
        return segment1IdPosted;
    }

    public void setSegment1IdPosted(long segment1IdPosted) {
        this.segment1IdPosted = segment1IdPosted;
    }
}
