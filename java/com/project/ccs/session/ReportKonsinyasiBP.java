/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.ccs.session;

/**
 *
 * @author Roy Andika
 */
public class ReportKonsinyasiBP {
    private long itemMasterId = 0;
    private String sku = "";
    private String itemName = "";
    
    private double cost = 0;
    private double begining = 0;
    private double receiving = 0;
    private double sold = 0;
    private double retur = 0;
    private double transferIn = 0;
    private double transferOut = 0;

    public long getItemMasterId() {
        return itemMasterId;
    }

    public void setItemMasterId(long itemMasterId) {
        this.itemMasterId = itemMasterId;
    }

    public String getSku() {
        return sku;
    }

    public void setSku(String sku) {
        this.sku = sku;
    }

    public String getItemName() {
        return itemName;
    }

    public void setItemName(String itemName) {
        this.itemName = itemName;
    }

    public double getCost() {
        return cost;
    }

    public void setCost(double cost) {
        this.cost = cost;
    }

    public double getBegining() {
        return begining;
    }

    public void setBegining(double begining) {
        this.begining = begining;
    }

    public double getReceiving() {
        return receiving;
    }

    public void setReceiving(double receiving) {
        this.receiving = receiving;
    }

    public double getSold() {
        return sold;
    }

    public void setSold(double sold) {
        this.sold = sold;
    }

    public double getRetur() {
        return retur;
    }

    public void setRetur(double retur) {
        this.retur = retur;
    }

    public double getTransferIn() {
        return transferIn;
    }

    public void setTransferIn(double transferIn) {
        this.transferIn = transferIn;
    }

    public double getTransferOut() {
        return transferOut;
    }

    public void setTransferOut(double transferOut) {
        this.transferOut = transferOut;
    }
    

}
