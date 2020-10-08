
package com.project.fms.journal; 
 
import java.util.Date;

import com.project.main.entity.*;

public class ArapPayment extends Entity { 

	private long apId;
	private long periodeId;
	private Date date;
	private String paidBy = "";
	private String recBy = "";
	private String payMethod = "";
	private double amount = 0;
	private String currency = "";
	private double exchangeRate = 0;
	private String voucherNumber = "";
	private Date voucherDate = new Date();
	private int voucherCounter;
	private String status = "";
	private long userId;
	private long arId;
	private String memo = "";

	public long getApId(){ 
		return apId; 
	} 

	public void setApId(long apId){ 
		this.apId = apId; 
	} 

	public long getPeriodeId(){ 
		return periodeId; 
	} 

	public void setPeriodeId(long periodeId){ 
		this.periodeId = periodeId; 
	} 

	public Date getDate(){ 
		return date; 
	} 

	public void setDate(Date date){ 
		this.date = date; 
	} 

	public String getPaidBy(){ 
		return paidBy; 
	} 

	public void setPaidBy(String paidBy){ 
		if ( paidBy == null ) {
			paidBy = ""; 
		} 
		this.paidBy = paidBy; 
	} 

	public String getRecBy(){ 
		return recBy; 
	} 

	public void setRecBy(String recBy){ 
		if ( recBy == null ) {
			recBy = ""; 
		} 
		this.recBy = recBy; 
	} 

	public String getPayMethod(){ 
		return payMethod; 
	} 

	public void setPayMethod(String payMethod){ 
		if ( payMethod == null ) {
			payMethod = ""; 
		} 
		this.payMethod = payMethod; 
	} 

	public double getAmount(){ 
		return amount; 
	} 

	public void setAmount(double amount){ 
		this.amount = amount; 
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

	public String getStatus(){ 
		return status; 
	} 

	public void setStatus(String status){ 
		if ( status == null ) {
			status = ""; 
		} 
		this.status = status; 
	} 

	public long getUserId(){ 
		return userId; 
	} 

	public void setUserId(long userId){ 
		this.userId = userId; 
	} 

	public long getArId(){ 
		return arId; 
	} 

	public void setArId(long arId){ 
		this.arId = arId; 
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

}
