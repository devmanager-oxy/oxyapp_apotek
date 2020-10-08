/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.ccs.session;

/**
 *
 * @author Roy Andika
 */
public class MasterGroup {
    
    private long itemMasterId = 0;
    private int service = 0;
    private int needBom = 0;
    private double cogs = 0;
    private String name = "";
    private int isBkp = 0;
    private String accSales = "";
    private String accCogs = "";
    private String accInv = "";
    private String accSalesCash = "";
    private String accCashIncome = "";
    private String accCreditIncome = "";
    private String accVat = "";
    private String accCosting ="";
    private String accBonusIncome = "";
    private String accOtherIncome = "";

    public long getItemMasterId() {
        return itemMasterId;
    }

    public void setItemMasterId(long itemMasterId) {
        this.itemMasterId = itemMasterId;
    }

    public String getAccSales() {
        return accSales;
    }

    public void setAccSales(String accSales) {
        this.accSales = accSales;
    }

    public String getAccCogs() {
        return accCogs;
    }

    public void setAccCogs(String accCogs) {
        this.accCogs = accCogs;
    }

    public String getAccInv() {
        return accInv;
    }

    public void setAccInv(String accInv) {
        this.accInv = accInv;
    }

    public String getAccSalesCash() {
        return accSalesCash;
    }

    public void setAccSalesCash(String accSalesCash) {
        this.accSalesCash = accSalesCash;
    }

    public String getAccCashIncome() {
        return accCashIncome;
    }

    public void setAccCashIncome(String accCashIncome) {
        this.accCashIncome = accCashIncome;
    }

    public String getAccVat() {
        return accVat;
    }

    public void setAccVat(String accVat) {
        this.accVat = accVat;
    }

    public String getAccCosting() {
        return accCosting;
    }

    public void setAccCosting(String accCosting) {
        this.accCosting = accCosting;
    }

    public String getAccBonusIncome() {
        return accBonusIncome;
    }

    public void setAccBonusIncome(String accBonusIncome) {
        this.accBonusIncome = accBonusIncome;
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

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public int getIsBkp() {
        return isBkp;
    }

    public void setIsBkp(int isBkp) {
        this.isBkp = isBkp;
    }

    public double getCogs() {
        return cogs;
    }

    public void setCogs(double cogs) {
        this.cogs = cogs;
    }

    public String getAccCreditIncome() {
        return accCreditIncome;
    }

    public void setAccCreditIncome(String accCreditIncome) {
        this.accCreditIncome = accCreditIncome;
    }

    public String getAccOtherIncome() {
        return accOtherIncome;
    }

    public void setAccOtherIncome(String accOtherIncome) {
        this.accOtherIncome = accOtherIncome;
    }
}
