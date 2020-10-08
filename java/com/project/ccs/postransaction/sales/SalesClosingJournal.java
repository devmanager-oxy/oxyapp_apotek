package com.project.ccs.postransaction.sales;

import com.project.ccs.sql.*;
import java.io.*;
import java.sql.*;
import java.util.*;
import java.util.Date;

public class SalesClosingJournal {

    private long salesId;
    private long salesReturId;
    private String invoiceNumber = "";
    private int type;
    private Date tglJam = null;
    private String member = "";
    private double cash = 0;
    private double cCard = 0;
    private double dCard = 0;
    private double bon = 0;
    private double discount = 0;
    private double retur = 0;
    private double amount = 0;
    private int jmlQty = 0;
    private long merchantId = 0;
    private String merchantName = "";
    
    private long merchant2Id = 0;
    private String merchant2Name = "";
    
    private long merchant3Id = 0;
    private String merchant3Name = "";
    
    private double transfer = 0;    
    private double discGlobal = 0;
    private double service = 0;
    private double vat = 0;    
    private double ccFee = 0;
    private double diskonFee = 0;
    private int posted = 0;  
    private double cashBack = 0;
    private double voucher = 0;
    private double difference = 0;
    
    public void setDifference(double difference) {
        this.difference = difference;
    }

    public double getDifference() {
        return (this.difference);
    }

    public void setVoucher(double voucher) {
        this.voucher = voucher;
    }

    public double getVoucher() {
        return (this.voucher);
    }

    public void setJmlQty(int JmlQty) {
        this.jmlQty = JmlQty;
    }

    public int getJmlQty() {
        return (this.jmlQty);
    }

    public void setInvoiceNumber(String invoiceNumber) {
        this.invoiceNumber = invoiceNumber;
    }

    public void setTglJam(Date tglJam) {
        this.tglJam = tglJam;
    }

    public void setMember(String member) {
        this.member = member;
    }

    public void setCash(double cash) {
        this.cash = cash;
    }

    public void setCCard(double cCard) {
        this.cCard = cCard;
    }

    public void setBon(double bon) {
        this.bon = bon;
    }

    public void setDiscount(double discount) {
        this.discount = discount;
    }

    public void setRetur(double retur) {
        this.retur = retur;
    }

    public void setAmount(double amount) {
        this.amount = amount;
    }

    public String getInvoiceNumber() {
        return (this.invoiceNumber);
    }

    public Date getTglJam() {
        return (this.tglJam);
    }

    public String getMember() {
        return (this.member);
    }

    public double getCash() {
        return (this.cash);
    }

    public double getCCard() {
        return (this.cCard);
    }

    public double getBon() {
        return (this.bon);
    }

    public double getDiscount() {
        return (this.discount);
    }

    public double getRetur() {
        return (this.retur);
    }

    public double getAmount() {
        return (this.amount);
    }

    public long getSalesId() {
        return salesId;
    }

    public void setSalesId(long salesId) {
        this.salesId = salesId;
    }

    public long getSalesReturId() {
        return salesReturId;
    }

    public void setSalesReturId(long salesReturId) {
        this.salesReturId = salesReturId;
    }

    public int getType() {
        return type;
    }

    public void setType(int type) {
        this.type = type;
    }

    public double getDCard() {
        return dCard;
    }

    public void setDCard(double dCard) {
        this.dCard = dCard;
    }

    public long getMerchantId() {
        return merchantId;
    }

    public void setMerchantId(long merchantId) {
        this.merchantId = merchantId;
    }

    public String getMerchantName() {
        return merchantName;
    }

    public void setMerchantName(String merchantName) {
        this.merchantName = merchantName;
    }

    public double getTransfer() {
        return transfer;
    }

    public void setTransfer(double transfer) {
        this.transfer = transfer;
    }

    public double getService() {
        return service;
    }

    public void setService(double service) {
        this.service = service;
    }

    public double getVat() {
        return vat;
    }

    public void setVat(double vat) {
        this.vat = vat;
    }

    public double getCcFee() {
        return ccFee;
    }

    public void setCcFee(double ccFee) {
        this.ccFee = ccFee;
    }

    public double getDiskonFee() {
        return diskonFee;
    }

    public void setDiskonFee(double diskonFee) {
        this.diskonFee = diskonFee;
    }

    public double getDiscGlobal() {
        return discGlobal;
    }

    public void setDiscGlobal(double discGlobal) {
        this.discGlobal = discGlobal;
    }

    public int getPosted() {
        return posted;
    }

    public void setPosted(int posted) {
        this.posted = posted;
    }

    public long getMerchant2Id() {
        return merchant2Id;
    }

    public void setMerchant2Id(long merchant2Id) {
        this.merchant2Id = merchant2Id;
    }

    public String getMerchant2Name() {
        return merchant2Name;
    }

    public void setMerchant2Name(String merchant2Name) {
        this.merchant2Name = merchant2Name;
    }

    public long getMerchant3Id() {
        return merchant3Id;
    }

    public void setMerchant3Id(long merchant3Id) {
        this.merchant3Id = merchant3Id;
    }

    public String getMerchant3Name() {
        return merchant3Name;
    }

    public void setMerchant3Name(String merchant3Name) {
        this.merchant3Name = merchant3Name;
    }

    public double getCashBack() {
        return cashBack;
    }

    public void setCashBack(double cashBack) {
        this.cashBack = cashBack;
    }

    
}
