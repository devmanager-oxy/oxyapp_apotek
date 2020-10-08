
package com.project.crm.transaction;
 
import java.util.Date;
import com.project.main.entity.*;

public class LimbahTransaction extends Entity  { 

	private long limbahtransactionid;
	private long customerid;
	private long masterlimbahid;
	private long periodid;
	private double bulanini ;
	private double bulanlalu ;
	private double percentageused;
	private double harga;
	private int postedstatus = 0;
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
	        
	public long getLimbahTransactionId(){ 
		return limbahtransactionid; 
	} 

    public void setLimbahTransactionId(long limbah_transaction){
		this.limbahtransactionid = limbah_transaction;
	}
	
	public String getNomorFp(){ 
		return nomorFp; 
	} 

    public void setNomorFp(String nomorFp){
		this.nomorFp = nomorFp;
	} 

	public void setName(long limbahtransactionid){ 
		this.limbahtransactionid = limbahtransactionid; 
	} 

	public long getCustomerId(){ 
		return customerid; 
	} 

	public void setCustomerId(long customerid){ 
		this.customerid = customerid; 
	} 

	public long getMasterLimbahId(){ 
		return masterlimbahid; 
	} 

	public void setMasterLimbahId(long masterlimbahid){
		this.masterlimbahid = masterlimbahid;
	} 

    public long getPeriodId(){
		return periodid;
	}

	public void setPeriodId(long periodid){
		this.periodid = periodid;
	}

	public double  getBulanIni(){
		return bulanini;
	} 

	public void setBulanIni(double bulanini){
		this.bulanini = bulanini;
	} 

	public double getBulanLalu(){
		return bulanlalu;
	} 

	public void setBulanLalu(double  bulanlalu){
		this.bulanlalu = bulanlalu;
	} 

	public double  getPercentageUsed(){
		return percentageused;
	} 

	public void setPercentageUsed(double  percentageused){
		this.percentageused = percentageused;
	} 

	public double  getHarga(){ 
		return harga; 
	} 

	public void setHarga(double  harga){ 
		this.harga = harga; 
	} 

	public int getPostedStatus(){ 
		return postedstatus; 
	} 

	public void setPostedStatus(int postedstatus){ 
		this.postedstatus = postedstatus; 
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
