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
public class ReportKonsumen {

    private String name = "";
    private long customerId = 0;
    private String invoiceNumber = "";
    private Date tanggal = new Date();
    private Date dueDate = new Date();
    private double totCredit = 0;
    private double totalPaid = 0;
    private double totalTerkini = 0;

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public long getCustomerId() {
        return customerId;
    }

    public void setCustomerId(long customerId) {
        this.customerId = customerId;
    }

    public String getInvoiceNumber() {
        return invoiceNumber;
    }

    public void setInvoiceNumber(String invoiceNumber) {
        this.invoiceNumber = invoiceNumber;
    }

    public Date getTanggal() {
        return tanggal;
    }

    public void setTanggal(Date tanggal) {
        this.tanggal = tanggal;
    }

    public Date getDueDate() {
        return dueDate;
    }

    public void setDueDate(Date dueDate) {
        this.dueDate = dueDate;
    }

    public double getTotCredit() {
        return totCredit;
    }

    public void setTotCredit(double totCredit) {
        this.totCredit = totCredit;
    }

    public double getTotalPaid() {
        return totalPaid;
    }

    public void setTotalPaid(double totalPaid) {
        this.totalPaid = totalPaid;
    }

    public double getTotalTerkini() {
        return totalTerkini;
    }

    public void setTotalTerkini(double totalTerkini) {
        this.totalTerkini = totalTerkini;
    }
    
    
    
}
