/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.fms.master;

/**
 *
 * @author Roy Andika
 */
public class Budget {

    private long coaId;
    private String accoutGroup = "";
    private String code = "";
    private String name = "";
    private int level;
    private String status = "";
    private double ammount;    
    private long coaBudgetId;
    private long coaDepartmentId;
    private long coaDivisionId;
    
    public long getCoaId() {
        return coaId;
    }

    public void setCoaId(long coaId) {
        this.coaId = coaId;
    }

    public String getAccoutGroup() {
        return accoutGroup;
    }

    public void setAccoutGroup(String accoutGroup) {
        this.accoutGroup = accoutGroup;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
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

    public double getAmmount() {
        return ammount;
    }

    public void setAmmount(double ammount) {
        this.ammount = ammount;
    }

    public long getCoaBudgetId() {
        return coaBudgetId;
    }

    public void setCoaBudgetId(long coaBudgetId) {
        this.coaBudgetId = coaBudgetId;
    }

    public long getCoaDepartmentId() {
        return coaDepartmentId;
    }

    public void setCoaDepartmentId(long coaDepartmentId) {
        this.coaDepartmentId = coaDepartmentId;
    }

    public long getCoaDivisionId() {
        return coaDivisionId;
    }

    public void setCoaDivisionId(long coaDivisionId) {
        this.coaDivisionId = coaDivisionId;
    }
    
}
