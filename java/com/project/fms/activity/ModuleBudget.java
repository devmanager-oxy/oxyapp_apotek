package com.project.fms.activity;

import com.project.main.entity.*;
import java.util.Date;

public class ModuleBudget extends Entity {

    private long coaId;
    private String description = "";
    private double amount;
    private long currencyId;
    private long moduleId;
    private double amountUsed;
    private int status = 0;
    private long refHistoryId = 0;
    private long userUpdateId = 0;
    private Date updateDate;

    public double getAmountUsed() {
        return amountUsed;
    }

    public void setAmountUsed(double amountUsed) {
        this.amountUsed = amountUsed;
    }

    public long getCoaId() {
        return coaId;
    }

    public void setCoaId(long coaId) {
        this.coaId = coaId;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        if (description == null) {
            description = "";
        }
        this.description = description;
    }

    public double getAmount() {
        return amount;
    }

    public void setAmount(double amount) {
        this.amount = amount;
    }

    public long getCurrencyId() {
        return currencyId;
    }

    public void setCurrencyId(long currencyId) {
        this.currencyId = currencyId;
    }

    public long getModuleId() {
        return moduleId;
    }

    public void setModuleId(long moduleId) {
        this.moduleId = moduleId;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    public long getRefHistoryId() {
        return refHistoryId;
    }

    public void setRefHistoryId(long refHistoryId) {
        this.refHistoryId = refHistoryId;
    }

    public long getUserUpdateId() {
        return userUpdateId;
    }

    public void setUserUpdateId(long userUpdateId) {
        this.userUpdateId = userUpdateId;
    }

    public Date getUpdateDate() {
        return updateDate;
    }

    public void setUpdateDate(Date updateDate) {
        this.updateDate = updateDate;
    }
}
