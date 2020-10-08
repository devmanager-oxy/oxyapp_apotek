/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.simprop.session;

import java.util.Date;

/**
 *
 * @author Roy Andika
 */
public class PaymentArchives {
    
    private long invOid;
    private String invNumber = "";
    private String invCustomer = "";
    private String invDescription = "";
    private Date invDueDate;
    private double invAmount;
    
    private long pembId;
    private String pemNumber = "";
    private Date pemDate;
    private double pemAmount;
    private String pemCashier = "";
    private String empName = "";
    private long userId = 0;

    public long getInvOid() {
        return invOid;
    }

    public void setInvOid(long invOid) {
        this.invOid = invOid;
    }

    public String getInvNumber() {
        return invNumber;
    }

    public void setInvNumber(String invNumber) {
        this.invNumber = invNumber;
    }

    public String getInvCustomer() {
        return invCustomer;
    }

    public void setInvCustomer(String invCustomer) {
        this.invCustomer = invCustomer;
    }

    public String getInvDescription() {
        return invDescription;
    }

    public void setInvDescription(String invDescription) {
        this.invDescription = invDescription;
    }

    public Date getInvDueDate() {
        return invDueDate;
    }

    public void setInvDueDate(Date invDueDate) {
        this.invDueDate = invDueDate;
    }

    public double getInvAmount() {
        return invAmount;
    }

    public void setInvAmount(double invAmount) {
        this.invAmount = invAmount;
    }

    public String getPemNumber() {
        return pemNumber;
    }

    public void setPemNumber(String pemNumber) {
        this.pemNumber = pemNumber;
    }

    public Date getPemDate() {
        return pemDate;
    }

    public void setPemDate(Date pemDate) {
        this.pemDate = pemDate;
    }

    public double getPemAmount() {
        return pemAmount;
    }

    public void setPemAmount(double pemAmount) {
        this.pemAmount = pemAmount;
    }

    public String getPemCashier() {
        return pemCashier;
    }

    public void setPemCashier(String pemCashier) {
        this.pemCashier = pemCashier;
    }

    public String getEmpName() {
        return empName;
    }

    public void setEmpName(String empName) {
        this.empName = empName;
    }

    public long getPembId() {
        return pembId;
    }

    public void setPembId(long pembId) {
        this.pembId = pembId;
    }

    public long getUserId() {
        return userId;
    }

    public void setUserId(long userId) {
        this.userId = userId;
    }
    
}
