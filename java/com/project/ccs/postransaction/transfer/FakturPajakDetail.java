
package com.project.ccs.postransaction.transfer;
import com.project.main.entity.*;
import java.util.Date;

public class FakturPajakDetail extends Entity {

    private long fakturPajakDetailId;
    private long fakturPajakId;
    private long itemMasterId;
    private double total;
    private double discount;
    private String itemName = "";
    private double qty;
    private double price;
    private long transferId;
    private long salesId;
    private Date date;
    private int counter;

    public long getFakturPajakDetailId() {
        return fakturPajakDetailId;
    }

    public void setFakturPajakDetailId(long fakturPajakDetailId) {
        this.fakturPajakDetailId = fakturPajakDetailId;
    }

    public long getFakturPajakId() {
        return fakturPajakId;
    }

    public void setFakturPajakId(long fakturPajakId) {
        this.fakturPajakId = fakturPajakId;
    }

    public long getItemMasterId() {
        return itemMasterId;
    }

    public void setItemMasterId(long itemMasterId) {
        this.itemMasterId = itemMasterId;
    }

    public String getItemName() {
        return itemName;
    }

    public void setItemName(String itemName) {
        this.itemName = itemName;
    }

    public double getTotal() {
        return total;
    }

    public void setTotal(double total) {
        this.total = total;
    }

    public double getDiscount() {
        return discount;
    }

    public void setDiscount(double discount) {
        this.discount = discount;
    }

    public double getQty() {
        return qty;
    }

    public void setQty(double qty) {
        this.qty = qty;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public long getTransferId() {
        return transferId;
    }

    public void setTransferId(long transferId) {
        this.transferId = transferId;
    }

    public long getSalesId() {
        return salesId;
    }

    public void setSalesId(long salesId) {
        this.salesId = salesId;
    }

    public Date getDate() {
        return date;
    }

    public void setDate(Date date) {
        this.date = date;
    }

    public int getCounter() {
        return counter;
    }

    public void setCounter(int counter) {
        this.counter = counter;
    }
}
