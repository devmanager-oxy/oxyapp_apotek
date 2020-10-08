package com.project.fms.ar;

import com.project.main.entity.*;

public class ARInvoiceDetail extends Entity {

    private long arInvoiceId;
    private String itemName = "";
    private long coaId;
    private int qty;
    private double price;
    private double discount;
    private double totalAmount;
    private long departmentId;
    private long companyId;
    private String memo = "";

    public long getArInvoiceId() {
        return arInvoiceId;
    }

    public void setArInvoiceId(long arInvoiceId) {
        this.arInvoiceId = arInvoiceId;
    }

    public String getItemName() {
        return itemName;
    }

    public void setItemName(String itemName) {
        if (itemName == null) {
            itemName = "";
        }
        this.itemName = itemName;
    }

    public long getCoaId() {
        return coaId;
    }

    public void setCoaId(long coaId) {
        this.coaId = coaId;
    }

    public int getQty() {
        return qty;
    }

    public void setQty(int qty) {
        this.qty = qty;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public double getDiscount() {
        return discount;
    }

    public void setDiscount(double discount) {
        this.discount = discount;
    }

    public double getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(double totalAmount) {
        this.totalAmount = totalAmount;
    }

    public long getDepartmentId() {
        return departmentId;
    }

    public void setDepartmentId(long departmentId) {
        this.departmentId = departmentId;
    }

    public long getCompanyId() {
        return companyId;
    }

    public void setCompanyId(long companyId) {
        this.companyId = companyId;
    }

    public String getMemo() {
        return memo;
    }

    public void setMemo(String memo) {
        this.memo = memo;
    }
}
