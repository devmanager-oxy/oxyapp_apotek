package com.project.crm.transaction;

import com.project.crm.transaction.*;
import java.util.Date;
import com.project.main.entity.*;


public class IrigasiTransaction extends Entity { 

	private long custumerId = 0;
	private long masterIrigasiId = 0;
	private long periodId = 0;
	private double bulanIni = 0;
	private double bulanLalu = 0;
	private double harga = 0;
    private int postStatus = 0;
	private String keterangan = "";
	private String invoiceNumber = "";
	private int invoiceNumberCounter = 0;
	private Date transactionDate = new Date();  
	private String nomorFp = "";	     
    private Date dueDate = new Date();
    
    private double totalDenda = 0;
    private int statusPembayaran = 0;
    
    private double ppn = 0;
    private double ppnPercent = 0;
    private double pph = 0;
    private double pphPercent = 0;
    private double totalHarga = 0;
    
    private double dendaDiakui = 0;
    private long dendaApproveId = 0;
    private Date dendaApproveDate = new Date();
    private String dendaKeterangan = "";
    private int dendaPostStatus = 0;
    private String dendaClientName = "";
    private String dendaClientPosition = "";
    
    public double getDendaDiakui(){
		return dendaDiakui;
	} 

	public void setDendaDiakui(double dendaDiakui){
		this.dendaDiakui = dendaDiakui;
	}
    
    public long getDendaApproveId(){
		return dendaApproveId;
	} 

	public void setDendaApproveId(long dendaApproveId){
		this.dendaApproveId = dendaApproveId;
	}
    
    public Date getDendaApproveDate(){
		return dendaApproveDate;
	} 

	public void setDendaApproveDate(Date dendaApproveDate){
		this.dendaApproveDate = dendaApproveDate;
	}
    
    public String getDendaKeterangan(){
		return dendaKeterangan;
	} 

	public void setDendaKeterangan(String dendaKeterangan){
		this.dendaKeterangan = dendaKeterangan;
	}
    
    public int getDendaPostStatus(){
		return dendaPostStatus;
	} 

	public void setDendaPostStatus(int dendaPostStatus){
		this.dendaPostStatus = dendaPostStatus;
	}
    
    public String getDendaClientName(){
		return dendaClientName;
	} 

	public void setDendaClientName(String dendaClientName){
		this.dendaClientName = dendaClientName;
	}
	
    public String getDendaClientPosition(){
		return dendaClientPosition;
	} 

	public void setDendaClientPosition(String dendaClientPosition){
		this.dendaClientPosition = dendaClientPosition;
	}
	
	
	//------------
	
        
	public double getTotalHarga(){
		return totalHarga;
	} 

	public void setTotalHarga(double totalHarga){
		this.totalHarga = totalHarga;
	}
	
	public double getPphPercent(){
		return pphPercent;
	} 

	public void setPphPercent(double pphPercent){
		this.pphPercent = pphPercent;
	}
	
	public double getPph(){
		return pph;
	} 

	public void setPph(double pph){
		this.pph = pph;
	}
	
	public double getPpnPercent(){
		return ppnPercent;
	} 

	public void setPpnPercent(double ppnPercent){
		this.ppnPercent = ppnPercent;
	}
	
	public double getPpn(){
		return ppn;
	} 

	public void setPpn(double ppn){
		this.ppn = ppn;
	}
	
	
	public int getStatusPembayaran(){
		return statusPembayaran;
	} 

	public void setStatusPembayaran(int statusPembayaran){
		this.statusPembayaran = statusPembayaran;
	}
	
	public double getTotalDenda(){
		return totalDenda;
	} 

	public void setTotalDenda(double totalDenda){
		this.totalDenda = totalDenda;
	} 
		
	public String getNomorFp(){
		return nomorFp;
	} 

	public void setNomorFp(String nomorFp){
		this.nomorFp = nomorFp;
	} 	
		
	public long getCustumerId(){
		return custumerId;
	} 

	public void setCustumerId(long custumerId){
		this.custumerId = custumerId;
	} 	

	public long getMasterIrigasiId(){
		return masterIrigasiId;
	} 

	public void setMasterIrigasiId(long masterIrigasiId){
		this.masterIrigasiId = masterIrigasiId;
	} 

	public long getPeriodId(){
		return periodId;
	} 

	public void setPeriodId(long periodId){
		this.periodId = periodId;
	} 

	public double getBulanIni(){
		return bulanIni;
	} 

	public void setBulanIni(double bulanIni){
		this.bulanIni = bulanIni;
	} 

	public double getBulanLalu(){
		return bulanLalu;
	} 

	public void setBulanLalu(double bulanLalu){
		this.bulanLalu = bulanLalu;
	} 

	public double getHarga(){
		return harga;
	} 

	public void setHarga(double harga){
		this.harga = harga;
	} 

       
    public int getPostStatus() {
        return this.postStatus;
    }
    
    
    public void setPostStatus(int postStatus) {
        this.postStatus = postStatus;
    }


	public void setKeterangan(String keterangan) {
		this.keterangan = keterangan; 
	}

	public String getKeterangan() {
		return (this.keterangan); 
	}
	
	public void setInvoiceNumber(String invoiceNumber) {
		this.invoiceNumber = invoiceNumber; 
	}

	public void setInvoiceNumberCounter(int invoiceNumberCounter) {
		this.invoiceNumberCounter = invoiceNumberCounter; 
	}

	public void setTransactionDate(Date transactionDate) {
		this.transactionDate = transactionDate; 
	}

	public String getInvoiceNumber() {
		return (this.invoiceNumber); 
	}

	public int getInvoiceNumberCounter() {
		return (this.invoiceNumberCounter); 
	}

	public Date getTransactionDate() {
		return (this.transactionDate); 
	}
	
	public void setDueDate(Date dueDate) {
		this.dueDate = dueDate; 
	}

	public Date getDueDate() {
		return (this.dueDate); 
	}        
}
