/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.ccs.report;

import java.util.Date;

/**
 *
 * @author Adnyana Eka Yasa
 */
public class SrcPurchaseOrderReport {

    private long locationId = 0;
    private long vendorId = 0;
    private int totalInvoice = 0;
    private int typeReport = 0;
    private int groupBy = 0;
    private Date fromDate = new Date();
    private Date toDate = new Date();
    private int ignoreDate = 0;
    private String status = "";
    private long itemCategoryId = 0;
    private long itemSubCategoryId = 0;

    public static final int GROUP_BY_SUPPLIER = 0;
    public static final int GROUP_BY_CATEGORY = 1;
    public static final int GROUP_BY_SUB_CATEGORY = 2;
    public static final int GROUP_BY_ITEM = 3;

    // INI UNTUK GROUP BY PADA LAPORAN PO PER SUPPLIER
    public static final int GROUP_TRANSAKSI = 0;
    public static final int GROUP_SUPPLIER = 1;
    public static final int GROUP_CATEGORY = 2;
    public static final int GROUP_SUB_CATEGORY = 3;
    public static final int GROUP_ITEM = 4;

    public long getItemSubCategoryId() {
        return itemSubCategoryId;
    }    

    public void setItemSubCategoryId(long itemSubCategoryId) {
        this.itemSubCategoryId = itemSubCategoryId;
    }

    public long getItemCategoryId() {
        return itemCategoryId;
    }

    public void setItemCategoryId(long itemCategoryId) {
        this.itemCategoryId = itemCategoryId;
    }

    public long getLocationId() {
        return locationId;
    }

    public void setLocationId(long locationId) {
        this.locationId = locationId;
    }

    public Date getFromDate() {
        return fromDate;
    }

    public void setFromDate(Date fromDate) {
        this.fromDate = fromDate;
    }

    public int getGroupBy() {
        return groupBy;
    }

    public void setGroupBy(int groupBy) {
        this.groupBy = groupBy;
    }

    public int getIgnoreDate() {
        return ignoreDate;
    }

    public void setIgnoreDate(int ignoreDate) {
        this.ignoreDate = ignoreDate;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Date getToDate() {
        return toDate;
    }

    public void setToDate(Date toDate) {
        this.toDate = toDate;
    }

    public int getTotalInvoice() {
        return totalInvoice;
    }

    public void setTotalInvoice(int totalInvoice) {
        this.totalInvoice = totalInvoice; 
    }

    public int getTypeReport() {
        return typeReport;
    }

    public void setTypeReport(int typeReport) {
        this.typeReport = typeReport;
    }

    public long getVendorId() {
        return vendorId;
    }

    public void setVendorId(long vendorId) {
        this.vendorId = vendorId;
    }
}
