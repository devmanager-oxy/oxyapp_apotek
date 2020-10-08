
package com.project.fms.journal; 
 
import java.util.Date;

import com.project.main.entity.*;

public class Journal extends Entity { 

	private Date date = new Date();
	private String picBy = "";
	private String currency = "";
	private String memo = "";
	private String picFrom = "";
	private long userById;
	private long userFromId;
	private long periodeId;
	private String status = "";
	private double amount = 0;
	private String reffNo = "";
	private String voucherNumber = "";
	private int voucherCounter;
	private Date voucherDate;
	private double exchangeRate = 0;
	private long userId;
	private String journalType = "";
	private long apId;
	private long arapPaymentId;
	private long arId;

	public Date getDate(){ 
		return date; 
	} 

	public void setDate(Date date){ 
		this.date = date; 
	} 

	public String getPicBy(){ 
		return picBy; 
	} 

	public void setPicBy(String picBy){ 
		if ( picBy == null ) {
			picBy = ""; 
		} 
		this.picBy = picBy; 
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

	public String getMemo(){ 
		return memo; 
	} 

	public void setMemo(String memo){ 
		if ( memo == null ) {
			memo = ""; 
		} 
		this.memo = memo; 
	} 

	public String getPicFrom(){ 
		return picFrom; 
	} 

	public void setPicFrom(String picFrom){ 
		if ( picFrom == null ) {
			picFrom = ""; 
		} 
		this.picFrom = picFrom; 
	} 

	public long getUserById(){ 
		return userById; 
	} 

	public void setUserById(long userById){ 
		this.userById = userById; 
	} 

	public long getUserFromId(){ 
		return userFromId; 
	} 

	public void setUserFromId(long userFromId){ 
		this.userFromId = userFromId; 
	} 

	public long getPeriodeId(){ 
		return periodeId; 
	} 

	public void setPeriodeId(long periodeId){ 
		this.periodeId = periodeId; 
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

	public double getAmount(){ 
		return amount; 
	} 

	public void setAmount(double amount){ 
		this.amount = amount; 
	} 

	public String getReffNo(){ 
		return reffNo; 
	} 

	public void setReffNo(String reffNo){ 
		if ( reffNo == null ) {
			reffNo = ""; 
		} 
		this.reffNo = reffNo; 
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

	public int getVoucherCounter(){ 
		return voucherCounter; 
	} 

	public void setVoucherCounter(int voucherCounter){ 
		this.voucherCounter = voucherCounter; 
	} 

	public Date getVoucherDate(){ 
		return voucherDate; 
	} 

	public void setVoucherDate(Date voucherDate){ 
		this.voucherDate = voucherDate; 
	} 

	public double getExchangeRate(){ 
		return exchangeRate; 
	} 

	public void setExchangeRate(double exchangeRate){ 
		this.exchangeRate = exchangeRate; 
	} 

	public long getUserId(){ 
		return userId; 
	} 

	public void setUserId(long userId){ 
		this.userId = userId; 
	} 

	public String getJournalType(){ 
		return journalType; 
	} 

	public void setJournalType(String journalType){ 
		if ( journalType == null ) {
			journalType = ""; 
		} 
		this.journalType = journalType; 
	} 

	public long getApId(){ 
		return apId; 
	} 

	public void setApId(long apId){ 
		this.apId = apId; 
	} 

	public long getArapPaymentId(){ 
		return arapPaymentId; 
	} 

	public void setArapPaymentId(long arapPaymentId){ 
		this.arapPaymentId = arapPaymentId; 
	} 

	public long getArId(){ 
		return arId; 
	} 

	public void setArId(long arId){ 
		this.arId = arId; 
	} 

}
