package com.project.crm.session;


public class LimbahMonth {
	
	private long limbahOid = 0;
	private long customerOid = 0;
	private String customerName = "";
	private double bulanIni = 0;
	private double bulanLalu = 0;
	private double pemakaian = 0;
	private String keterangan = "";	
	private long periodeOid = 0;
	private double persentaseUsed = 0;	
		
	public void setCustomerName(String customerName) {
		this.customerName = customerName; 
	}

	public void setBulanIni(double bulanIni) {
		this.bulanIni = bulanIni; 
	}

	public void setBulanLalu(double bulanLalu) {
		this.bulanLalu = bulanLalu; 
	}

	public void setPemakaian(double pemakaian) {
		this.pemakaian = pemakaian; 
	}

	public void setKeterangan(String keterangan) {
		this.keterangan = keterangan; 
	}

	public String getCustomerName() {
		return (this.customerName); 
	}

	public double getBulanIni() {
		return (this.bulanIni); 
	}

	public double getBulanLalu() {
		return (this.bulanLalu); 
	}

	public double getPemakaian() {
		return (this.pemakaian); 
	}

	public String getKeterangan() {
		return (this.keterangan); 
	}
	
	public void setCustomerOid(long customerOid) {
		this.customerOid = customerOid; 
	}

	public long getCustomerOid() {
		return (this.customerOid); 
	}
	
	public void setPeriodeOid(long periodeOid) {
		this.periodeOid = periodeOid; 
	}

	public long getPeriodeOid() {
		return (this.periodeOid); 
	}
	
	public void setLimbahOid(long limbahOid) {
		this.limbahOid = limbahOid; 
	}

	public long getLimbahOid() {
		return (this.limbahOid); 
	}
	
	public void setPersentaseUsed(double persentaseUsed) {
		this.persentaseUsed = persentaseUsed; 
	}

	public double getPersentaseUsed() {
		return (this.persentaseUsed); 
	}
	
	
}
