
package com.project.fms.journal; 
 
import java.util.Date;

import com.project.main.entity.*;

public class Ap extends Entity { 

	private Date date = new Date();
	private Date dueDate = new Date();
	private long vendorId;
	private String invoiceNumber = "";
	private int numberCounter;
	private double amount = 0;
	private String status = "";
	private String currency = "";
	private long periodeId;
	private double exchangeRate = 0;
	private String voucherNumber = "";
	private Date voucherDate = new Date();
	private int voucherCounter;
	private long userId;
	private String memo = "";
	private double totalPayment = 0;

	public Date getDate(){ 
		return date; 
	} 

	public void setDate(Date date){ 
		this.date = date; 
	} 

	public Date getDueDate(){ 
		return dueDate; 
	} 

	public void setDueDate(Date dueDate){ 
		this.dueDate = dueDate; 
	} 

	public long getVendorId(){ 
		return vendorId; 
	} 

	public void setVendorId(long vendorId){ 
		this.vendorId = vendorId; 
	} 

	public String getInvoiceNumber(){ 
		return invoiceNumber; 
	} 

	public void setInvoiceNumber(String invoiceNumber){ 
		if ( invoiceNumber == null ) {
			invoiceNumber = ""; 
		} 
		this.invoiceNumber = invoiceNumber; 
	} 

	public int getNumberCounter(){ 
		return numberCounter; 
	} 

	public void setNumberCounter(int numberCounter){ 
		this.numberCounter = numberCounter; 
	} 

	public double getAmount(){ 
		return amount; 
	} 

	public void setAmount(double amount){ 
		this.amount = amount; 
	} 

	public String getStatus(){ 
		return status; 
	} 

	public void setStatus(String status){ 
		if ( status == null ) {
			status = ""; 
		} 
		this.status = status; 
	} 

	public String getCurrency(){ 
		return currency; 
	} 

	public void setCurrency(String currency){ 
		if ( currency == null ) {
			currency = ""; 
		} 
		this.currency = currency; 
	} 

	public long getPeriodeId(){ 
		return periodeId; 
	} 

	public void setPeriodeId(long periodeId){ 
		this.periodeId = periodeId; 
	} 

	public double getExchangeRate(){ 
		return exchangeRate; 
	} 

	public void setExchangeRate(double exchangeRate){ 
		this.exchangeRate = exchangeRate; 
	} 

	public String getVoucherNumber(){ 
		return voucherNumber; 
	} 

	public void setVoucherNumber(String voucherNumber){ 
		if ( voucherNumber == null ) {
			voucherNumber = ""; 
		} 
		this.voucherNumber = voucherNumber; 
	} 

	public Date getVoucherDate(){ 
		return voucherDate; 
	} 

	public void setVoucherDate(Date voucherDate){ 
		this.voucherDate = voucherDate; 
	} 

	public int getVoucherCounter(){ 
		return voucherCounter; 
	} 

	public void setVoucherCounter(int voucherCounter){ 
		this.voucherCounter = voucherCounter; 
	} 

	public long getUserId(){ 
		return userId; 
	} 

	public void setUserId(long userId){ 
		this.userId = userId; 
	} 

	public String getMemo(){ 
		return memo; 
	} 

	public void setMemo(String memo){ 
		if ( memo == null ) {
			memo = ""; 
		} 
		this.memo = memo; 
	} 

	public double getTotalPayment(){ 
		return totalPayment; 
	} 

	public void setTotalPayment(double totalPayment){ 
		this.totalPayment = totalPayment; 
	} 

}
