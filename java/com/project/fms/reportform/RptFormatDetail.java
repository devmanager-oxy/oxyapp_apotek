package com.project.fms.reportform;

import com.project.main.entity.*;

public class RptFormatDetail extends Entity {

    private String description;
    private int level;
    private long refId;
    private int type;
    private long rptFormatId;
    private int squence;
    private boolean newPage = false;

    public int getSquence() {
        return squence;
    }

    public void setSquence(int squence) {
        this.squence = squence;
    }

    public long getRptFormatId() {
        return rptFormatId;
    }

    public void setRptFormatId(long rptFormatId) {
        this.rptFormatId = rptFormatId;
    }

    public int getType() {
        return type;
    }

    public void setType(int type) {
        this.type = type;
    }

    public long getRefId() {
        return refId;
    }

    public void setRefId(long refId) {
        this.refId = refId;
    }

    public int getLevel() {
        return level;
    }

    public void setLevel(int level) {
        this.level = level;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public boolean isNewPage() {
        return newPage;
    }

    public void setNewPage(boolean newPage) {
        this.newPage = newPage;
    }
    
}
