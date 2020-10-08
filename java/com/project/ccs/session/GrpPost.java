/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.ccs.session;

/**
 *
 * @author Roy
 */
public class GrpPost {
    
    private long itemGroupId = 0;
    private double value = 0;
    private String name = "";    
    private String memo = "";
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
    private String accAdjusment = "";

    public long getItemGroupId() {
        return itemGroupId;
    }

    public void setItemGroupId(long itemGroupId) {
        this.itemGroupId = itemGroupId;
    }

    public double getValue() {
        return value;
    }

    public void setValue(double value) {
        this.value = value;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
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

    public String getAccCreditIncome() {
        return accCreditIncome;
    }

    public void setAccCreditIncome(String accCreditIncome) {
        this.accCreditIncome = accCreditIncome;
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

    public String getAccOtherIncome() {
        return accOtherIncome;
    }

    public void setAccOtherIncome(String accOtherIncome) {
        this.accOtherIncome = accOtherIncome;
    }

    public String getMemo() {
        return memo;
    }

    public void setMemo(String memo) {
        this.memo = memo;
    }

    public String getAccAdjusment() {
        return accAdjusment;
    }

    public void setAccAdjusment(String accAdjusment) {
        this.accAdjusment = accAdjusment;
    }

}
