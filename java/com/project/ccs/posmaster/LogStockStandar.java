/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.ccs.posmaster;

import com.project.main.entity.Entity;

import java.util.Date;
/**
 *
 * @author Ngurah Wirata
 */
public class LogStockStandar extends Entity {
    private Date date;
    private String logDesc = "";
    private long stockMinId;
    private String userName = "";
    private long userId ;
    private double qtyStandar;

    public Date getDate() {
        return date;
    }

    public void setDate(Date date) {
        this.date = date;
    }

    public String getLogDesc() {
        return logDesc;
    }

    public void setLogDesc(String logDesc) {
        this.logDesc = logDesc;
    }

    public long getStockMinId() {
        return stockMinId;
    }

    public void setStockMinId(long stockMinId) {
        this.stockMinId = stockMinId;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public long getUserId() {
        return userId;
    }

    public void setUserId(long userId) {
        this.userId = userId;
    }

    public double getQtyStandar() {
        return qtyStandar;
    }

    public void setQtyStandar(double qtyStandar) {
        this.qtyStandar = qtyStandar;
    }
    
    
    

   

}
