package com.project.ccs.sql;

import java.util.Date;

public class SalesClosing {
	
	private String invoiceNumber = "";
	private Date tglJam  = null;
	private String member = ""; // loc name
	private double cash = 0;
	private double cCard = 0;
	private double bon = 0;
	private double discount =0;
	private double retur = 0;
	private double amount = 0;
	private double jmlQty = 0;
	
	private String name1 = ""; // status kasir
	private String name2 = ""; // keterangan
	private String name3 = ""; // status update
	private String name4 = ""; // keterangan update
	private String name5 = ""; // shift
	private String name6 = ""; // cashier name
	
	// tambahan untuk log kasir balance dan tidak
	private long locationOid = 0;
	private long shiftOid = 0;
	
	private double totPrice = 0;
	
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

	
	public void setName1(String name1) {
		this.name1 = name1; 
	}

	public void setName2(String name2) {
		this.name2 = name2; 
	}

	public void setName3(String name3) {
		this.name3 = name3; 
	}

	public String getName1() {
		return (this.name1); 
	}

	public String getName2() {
		return (this.name2); 
	}

	public String getName3() {
		return (this.name3); 
	}

	
	public void setName4(String name4) {
		this.name4 = name4; 
	}

	public void setName5(String name5) {
		this.name5 = name5; 
	}

	public void setName6(String name6) {
		this.name6 = name6; 
	}

	public void setLocationOid(long locationOid) {
		this.locationOid = locationOid; 
	}

	public void setShiftOid(long shiftOid) {
		this.shiftOid = shiftOid; 
	}

	public String getName4() {
		return (this.name4); 
	}

	public String getName5() {
		return (this.name5); 
	}

	public String getName6() {
		return (this.name6); 
	}

	public long getLocationOid() {
		return (this.locationOid); 
	}

	public long getShiftOid() {
		return (this.shiftOid); 
	}

    public double getJmlQty() {
        return jmlQty;
    }

    public void setJmlQty(double jmlQty) {
        this.jmlQty = jmlQty;
    }

    public double getTotPrice() {
        return totPrice;
    }

    public void setTotPrice(double totPrice) {
        this.totPrice = totPrice;
    }
}
