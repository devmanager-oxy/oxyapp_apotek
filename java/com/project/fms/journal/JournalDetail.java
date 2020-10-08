
package com.project.fms.journal; 
 
import java.util.Date;

import com.project.main.entity.*;

public class JournalDetail extends Entity { 

	private long journalId= 0;
	private long coaId= 0;
	private double amount = 0;
	private long departmentId= 0;
	private long sectionId = 0;
	private long periodeId= 0;
	private double exchangeRate= 0;
	private String currency = "";
	private long userId= 0;
	private String status = "";
	private int isDebet;
	private double debet= 0;
	private double credit= 0;

	public long getJournalId(){ 
		return journalId; 
	} 

	public void setJournalId(long journalId){ 
		this.journalId = journalId; 
	} 

	public long getCoaId(){ 
		return coaId; 
	} 

	public void setCoaId(long coaId){ 
		this.coaId = coaId; 
	} 

	public double getAmount(){ 
		return amount; 
	} 

	public void setAmount(double amount){ 
		this.amount = amount; 
	} 

	public long getDepartmentId(){ 
		return departmentId; 
	} 

	public void setDepartmentId(long departmentId){ 
		this.departmentId = departmentId; 
	} 

	public long getSectionId(){ 
		return sectionId; 
	} 

	public void setSectionId(long sectionId){ 
		this.sectionId = sectionId; 
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

	public String getCurrency(){ 
		return currency; 
	} 

	public void setCurrency(String currency){ 
		if ( currency == null ) {
			currency = ""; 
		} 
		this.currency = currency; 
	} 

	public long getUserId(){ 
		return userId; 
	} 

	public void setUserId(long userId){ 
		this.userId = userId; 
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

	public int getIsDebet(){ 
		return isDebet; 
	} 

	public void setIsDebet(int isDebet){ 
		this.isDebet = isDebet; 
	} 

	public double getDebet(){ 
		return debet; 
	} 

	public void setDebet(double debet){ 
		this.debet = debet; 
	} 

	public double getCredit(){ 
		return credit; 
	} 

	public void setCredit(double credit){ 
		this.credit = credit; 
	} 

}
