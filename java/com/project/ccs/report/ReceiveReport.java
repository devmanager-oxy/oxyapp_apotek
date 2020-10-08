/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.ccs.report;
import java.util.Date;
import com.project.main.entity.Entity;
/**
 *
 * @author Adnyana Eka Yasa
 */
public class ReceiveReport extends Entity {

    private long vendorId = 0;
    private String vendorName = "";
    private int totalInvoice = 0;
    private double purchAmount = 0.0;
    private String itemCode = "";
    private String itemName = "";
    private String itemSubCategory = "";
    private String itemSubCategoryName = "";
    private String itemCategory = "";
    private String itemCategoryName = "";
    private int typeReport = 0;
    private int groupBy = 0;
    private String purchNumber = "";
    private double totalQty = 0.0;
    private String locationName="";
    private Date date;

    public double getTotalQty() {
        return totalQty;
    }

    public void setTotalQty(double totalQty) {
        this.totalQty = totalQty;
    }

    public String getPurchNumber() {
        return purchNumber;
    }

    public void setPurchNumber(String purchNumber) {
        this.purchNumber = purchNumber;
    }

    public int getGroupBy() {
        return groupBy;
    }

    public void setGroupBy(int groupBy) {
        this.groupBy = groupBy;
    }

    public int getTypeReport() {
        return typeReport;
    } 

    public void setTypeReport(int typeReport) {
        this.typeReport = typeReport;
    }

    public String getItemCategory() {
        return itemCategory;
    }

    public void setItemCategory(String itemCategory) {
        this.itemCategory = itemCategory;
    }

    public String getItemCategoryName() {
        return itemCategoryName;
    }

    public void setItemCategoryName(String itemCategoryName) {
        this.itemCategoryName = itemCategoryName;
    }

    public String getItemCode() {
        return itemCode;
    }

    public void setItemCode(String itemCode) {
        this.itemCode = itemCode;
    }

    public String getItemName() {
        return itemName;
    }

    public void setItemName(String itemName) {
        this.itemName = itemName;
    }

    public String getItemSubCategory() {
        return itemSubCategory;
    }

    public void setItemSubCategory(String itemSubCategory) {
        this.itemSubCategory = itemSubCategory;
    }

    public String getItemSubCategoryName() {
        return itemSubCategoryName;
    }

    public void setItemSubCategoryName(String itemSubCategoryName) {
        this.itemSubCategoryName = itemSubCategoryName;
    }

    public double getPurchAmount() {
        return purchAmount;
    }

    public void setPurchAmount(double purchAmount) {
        this.purchAmount = purchAmount;
    }

    public int getTotalInvoice() {
        return totalInvoice;
    }

    public void setTotalInvoice(int totalInvoice) {
        this.totalInvoice = totalInvoice;
    }

    public long getVendorId() {
        return vendorId;
    } 

    public void setVendorId(long vendorId) {
        this.vendorId = vendorId;
    }

    public String getVendorName() {
        return vendorName;
    }

    public void setVendorName(String vendorName) {
        this.vendorName = vendorName;
    }

    public String getLocationName() {
        return locationName;
    }

    public void setLocationName(String locationName) {
        this.locationName = locationName;
    }

    public Date getDate() {
        return date;
    }

    public void setDate(Date date) {
        this.date = date;
    }
}
