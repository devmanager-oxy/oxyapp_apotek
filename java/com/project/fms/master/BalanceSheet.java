/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.fms.master;

/**
 *
 * @author Administrator
 */
public class BalanceSheet {

    private long departmentId;
    private int level;
    private String status = "";
    private double amount;

    public long getDepartmentId() {
        return departmentId;
    }

    public void setDepartmentId(long departmentId) {
        this.departmentId = departmentId;
    }

    public int getLevel() {
        return level;
    }

    public void setLevel(int level) {
        this.level = level;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public double getAmount() {
        return amount;
    }

    public void setAmount(double amount) {
        this.amount = amount;
    }
    
    
    
    
}
