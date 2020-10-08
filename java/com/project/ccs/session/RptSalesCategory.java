/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.ccs.session;

/**
 *
 * @author Roy Andika
 */
public class RptSalesCategory {
    
    private long categoriId;
    private String category = "";
    private long itemMasterId;
    private String code = "";
    private String name = "";
    private double jumlah;
    private double selling;
    private String sku;
    private String vendor = "";
    private double diskon = 0;
    private long subCategoryId = 0;

    public long getCategoriId() {
        return categoriId;
    }

    public void setCategoriId(long categoriId) {
        this.categoriId = categoriId;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public long getItemMasterId() {
        return itemMasterId;
    }

    public void setItemMasterId(long itemMasterId) {
        this.itemMasterId = itemMasterId;
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

    public double getJumlah() {
        return jumlah;
    }

    public void setJumlah(double jumlah) {
        this.jumlah = jumlah;
    }

    public double getSelling() {
        return selling;
    }

    public void setSelling(double selling) {
        this.selling = selling;
    }

    public String getSku() {
        return sku;
    }

    public void setSku(String sku) {
        this.sku = sku;
    }

    public String getVendor() {
        return vendor;
    }

    public void setVendor(String vendor) {
        this.vendor = vendor;
    }

    public double getDiskon() {
        return diskon;
    }

    public void setDiskon(double diskon) {
        this.diskon = diskon;
    }

    public long getSubCategoryId() {
        return subCategoryId;
    }

    public void setSubCategoryId(long subCategoryId) {
        this.subCategoryId = subCategoryId;
    }

}
