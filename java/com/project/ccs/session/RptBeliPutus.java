/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.ccs.session;

/**
 *
 * @author Roy Andika
 */
public class RptBeliPutus {
    
    private long itemMasterId;
    private String sku = "";
    private String itemName = "";
    
    private double stockAwalQty = 0;
    private double stockAwalPrice = 0;
    
    private double pembelianQty = 0;
    private double pembelianPrice = 0;
    
    private double penjualanQty = 0;
    private double penjualanPrice = 0;
    
    private double cogs = 0;
    
    private double returQty = 0;
    private double returPrice = 0;
    
    private double saldoAkhirQty = 0;
    private double saldoAkhirPrice = 0;

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

    public double getStockAwalQty() {
        return stockAwalQty;
    }

    public void setStockAwalQty(double stockAwalQty) {
        this.stockAwalQty = stockAwalQty;
    }

    public double getStockAwalPrice() {
        return stockAwalPrice;
    }

    public void setStockAwalPrice(double stockAwalPrice) {
        this.stockAwalPrice = stockAwalPrice;
    }

    public double getPembelianQty() {
        return pembelianQty;
    }

    public void setPembelianQty(double pembelianQty) {
        this.pembelianQty = pembelianQty;
    }

    public double getPembelianPrice() {
        return pembelianPrice;
    }

    public void setPembelianPrice(double pembelianPrice) {
        this.pembelianPrice = pembelianPrice;
    }

    public double getPenjualanQty() {
        return penjualanQty;
    }

    public void setPenjualanQty(double penjualanQty) {
        this.penjualanQty = penjualanQty;
    }

    public double getPenjualanPrice() {
        return penjualanPrice;
    }

    public void setPenjualanPrice(double penjualanPrice) {
        this.penjualanPrice = penjualanPrice;
    }

    public double getCogs() {
        return cogs;
    }

    public void setCogs(double cogs) {
        this.cogs = cogs;
    }

    public double getReturQty() {
        return returQty;
    }

    public void setReturQty(double returQty) {
        this.returQty = returQty;
    }

    public double getReturPrice() {
        return returPrice;
    }

    public void setReturPrice(double returPrice) {
        this.returPrice = returPrice;
    }

    public double getSaldoAkhirQty() {
        return saldoAkhirQty;
    }

    public void setSaldoAkhirQty(double saldoAkhirQty) {
        this.saldoAkhirQty = saldoAkhirQty;
    }

    public double getSaldoAkhirPrice() {
        return saldoAkhirPrice;
    }

    public void setSaldoAkhirPrice(double saldoAkhirPrice) {
        this.saldoAkhirPrice = saldoAkhirPrice;
    }
}
