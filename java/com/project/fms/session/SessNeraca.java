/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.fms.session;

/**
 *
 * @author Roy
 */
public class SessNeraca {

    private int level = 0;
    private String status = "";
    private String code = "";
    private String coa = "";
    private double balancePrevious = 0;
    private double balance = 0;

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public double getBalancePrevious() {
        return balancePrevious;
    }

    public void setBalancePrevious(double balancePrevious) {
        this.balancePrevious = balancePrevious;
    }

    public double getBalance() {
        return balance;
    }

    public void setBalance(double balance) {
        this.balance = balance;
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

    public String getCoa() {
        return coa;
    }

    public void setCoa(String coa) {
        this.coa = coa;
    }
}
