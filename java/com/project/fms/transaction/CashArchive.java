/***********************************\
|  Create by Dek-Ndut               |
|  Karya kami mohon jangan dibajak  |
|                                   |
|  1/7/2008 2:36:52 PM
\***********************************/

package com.project.fms.transaction;

import java.util.Date;
import com.project.main.entity.*;


public class CashArchive extends Entity {

	private String searchFor = "";
	private Date startDate = new Date();
	private Date endDate = new Date();
	private int ignoreInputDate = 0;
	private Date transactionDate = new Date();
	private int ignoreTransactionDate = 0;
	private String journalNumber = "";
	private int blankJournalNumber = 0;
	private long periodeId = 0;

	public String getSearchFor(){
		return searchFor;
	}

	public void setSearchFor(String searchFor){
		if ( searchFor == null) {
			searchFor = "";
		}
		this.searchFor = searchFor;
	}

	public Date getStartDate(){
		return startDate;
	}

	public void setStartDate(Date startDate){
		this.startDate = startDate;
	}

	public Date getEndDate(){
		return endDate;
	}

	public void setEndDate(Date endDate){
		this.endDate = endDate;
	}

	public int getIgnoreInputDate(){
		return ignoreInputDate;
	}

	public void setIgnoreInputDate(int ignoreInputDate){
		this.ignoreInputDate = ignoreInputDate;
	}

	public Date getTransactionDate(){
		return transactionDate;
	}

	public void setTransactionDate(Date transactionDate){
		this.transactionDate = transactionDate;
	}

	public int getIgnoreTransactionDate(){
		return ignoreTransactionDate;
	}

	public void setIgnoreTransactionDate(int ignoreTransactionDate){
		this.ignoreTransactionDate = ignoreTransactionDate;
	}

	public String getJournalNumber(){
		return journalNumber;
	}

	public void setJournalNumber(String journalNumber){
		if ( journalNumber == null) {
			journalNumber = "";
		}
		this.journalNumber = journalNumber;
	}

	public int getBlankJournalNumber(){
		return blankJournalNumber;
	}

	public void setBlankJournalNumber(int blankJournalNumber){
		this.blankJournalNumber = blankJournalNumber;
	}

	public long getPeriodeId(){
		return periodeId;
	}

	public void setPeriodeId(long periodeId){
		this.periodeId = periodeId;
	}
}
