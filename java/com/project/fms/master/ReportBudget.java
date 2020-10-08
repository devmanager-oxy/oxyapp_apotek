/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.fms.master;

import com.project.main.entity.Entity;
import java.util.Date;

/**
 *
 * @author Roy
 */
public class ReportBudget extends Entity{
    
    private long employeeId = 0;
    private long userId = 0;
    private String fullName = "";
    private Date date;
    private Date dateEnd;
    private int pkp = 0;
    private int nonPkp = 0;
    private Date createDate;
    private long vendorId = 0;
    private int ignore = 0;    

    private int non = 0;
    private int konsinyasi = 0;
    private int komisi = 0;
    
    public long getEmployeeId() {
        return employeeId;
    }

    public void setEmployeeId(long employeeId) {
        this.employeeId = employeeId;
    }

    public Date getDate() {
        return date;
    }

    public void setDate(Date date) {
        this.date = date;
    }

    public int getPkp() {
        return pkp;
    }

    public void setPkp(int pkp) {
        this.pkp = pkp;
    }

    public Date getCreateDate() {
        return createDate;
    }

    public void setCreateDate(Date createDate) {
        this.createDate = createDate;
    }

    public long getUserId() {
        return userId;
    }

    public void setUserId(long userId) {
        this.userId = userId;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public long getVendorId() {
        return vendorId;
    }

    public void setVendorId(long vendorId) {
        this.vendorId = vendorId;
    }

    public int getNonPkp() {
        return nonPkp;
    }

    public void setNonPkp(int nonPkp) {
        this.nonPkp = nonPkp;
    }

    public int getIgnore() {
        return ignore;
    }

    public void setIgnore(int ignore) {
        this.ignore = ignore;
    }

    public Date getDateEnd() {
        return dateEnd;
    }

    public void setDateEnd(Date dateEnd) {
        this.dateEnd = dateEnd;
    }

    public int getNon() {
        return non;
    }

    public void setNon(int non) {
        this.non = non;
    }

    public int getKonsinyasi() {
        return konsinyasi;
    }

    public void setKonsinyasi(int konsinyasi) {
        this.konsinyasi = konsinyasi;
    }

    public int getKomisi() {
        return komisi;
    }

    public void setKomisi(int komisi) {
        this.komisi = komisi;
    }

}
