/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.ccs.session;

/**
 *
 * @author Roy Andika
 */
public class CoaSalesDetail {

    private long salesDetailId = 0;
    private long accSales = 0;
    private long accInv = 0;
    private long accCogs = 0;
    private long productMasterId = 0;
    private String itemName = "";
    private int isBkp = 0;
    private long accPpn = 0;
    private int service = 0;
    private int needBom = 0;
    private long accOtherIncome = 0;

    public long getSalesDetailId() {
        return salesDetailId;
    }

    public void setSalesDetailId(long salesDetailId) {
        this.salesDetailId = salesDetailId;
    }

    public long getAccSales() {
        return accSales;
    }

    public void setAccSales(long accSales) {
        this.accSales = accSales;
    }

    public long getAccInv() {
        return accInv;
    }

    public void setAccInv(long accInv) {
        this.accInv = accInv;
    }

    public long getAccCogs() {
        return accCogs;
    }

    public void setAccCogs(long accCogs) {
        this.accCogs = accCogs;
    }

    public long getProductMasterId() {
        return productMasterId;
    }

    public void setProductMasterId(long productMasterId) {
        this.productMasterId = productMasterId;
    }

    public String getItemName() {
        return itemName;
    }

    public void setItemName(String itemName) {
        this.itemName = itemName;
    }

    public int getIsBkp() {
        return isBkp;
    }

    public void setIsBkp(int isBkp) {
        this.isBkp = isBkp;
    }

    public long getAccPpn() {
        return accPpn;
    }

    public void setAccPpn(long accPpn) {
        this.accPpn = accPpn;
    }

    public int getService() {
        return service;
    }

    public void setService(int service) {
        this.service = service;
    }

    public int getNeedBom() {
        return needBom;
    }

    public void setNeedBom(int needBom) {
        this.needBom = needBom;
    }

    public long getAccOtherIncome() {
        return accOtherIncome;
    }

    public void setAccOtherIncome(long accOtherIncome) {
        this.accOtherIncome = accOtherIncome;
    }
}
