package com.project.fms.master;

import java.util.Date;
import com.project.main.entity.*;

public class Periode extends Entity {

    private Date startDate = new Date();
    private Date endDate = new Date();
    private String status = "";
    private String name = "";
    private Date inputTolerance = new Date();
    private int type = 0;
    private int applyPeriod13 = 0;
    private String period13Name = "";
    private String tableName = "gl";

    public String getPeriod13Name() {
        return period13Name;
    }

    public void setPeriod13Name(String period13Name) {
        this.period13Name = period13Name;
    }

    public int getApplyPeriod13() {
        return applyPeriod13;
    }

    public void setApplyPeriod13(int applyPeriod13) {
        this.applyPeriod13 = applyPeriod13;
    }

    public int getType() {
        return type;
    }

    public void setType(int type) {
        this.type = type;
    }

    public Date getStartDate() {
        return startDate;
    }

    public void setStartDate(Date startDate) {
        this.startDate = startDate;
    }

    public Date getEndDate() {
        return endDate;
    }

    public void setEndDate(Date endDate) {
        this.endDate = endDate;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        if (status == null) {
            status = "";
        }
        this.status = status;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        if (name == null) {
            name = "";
        }
        this.name = name;
    }

    /**
     * Getter for property inputTolerance.
     * @return Value of property inputTolerance.
     */
    public Date getInputTolerance() {
        return this.inputTolerance;
    }

    /**
     * Setter for property inputTolerance.
     * @param inputTolerance New value of property inputTolerance.
     */
    public void setInputTolerance(Date inputTolerance) {
        this.inputTolerance = inputTolerance;
    }

    public String getTableName() {
        return tableName;
    }

    public void setTableName(String tableName) {
        this.tableName = tableName;
    }

}
