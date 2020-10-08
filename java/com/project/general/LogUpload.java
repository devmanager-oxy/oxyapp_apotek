/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.general;

import com.project.main.entity.Entity;
import java.util.Date;

/**
 *
 * @author Roy
 */

public class LogUpload extends Entity {

    private Date logDate;
    private long userId = 0;
    private String tableName = "";
    private String queryString = "";
    private Date updateStatus ;
    private int status = 0;

    public Date getLogDate() {
        return logDate;
    }

    public void setLogDate(Date logDate) {
        this.logDate = logDate;
    }

    public long getUserId() {
        return userId;
    }

    public void setUserId(long userId) {
        this.userId = userId;
    }

    public String getTableName() {
        return tableName;
    }

    public void setTableName(String tableName) {
        this.tableName = tableName;
    }

    public String getQueryString() {
        return queryString;
    }

    public void setQueryString(String queryString) {
        this.queryString = queryString;
    }

    public Date getUpdateStatus() {
        return updateStatus;
    }

    public void setUpdateStatus(Date updateStatus) {
        this.updateStatus = updateStatus;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }
}
