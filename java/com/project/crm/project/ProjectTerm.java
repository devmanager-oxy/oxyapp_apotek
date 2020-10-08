/***********************************\
|  Create by Dek-Ndut               |
|  Karya kami mohon jangan dibajak  |
|                                   |
|  10/6/2008 3:12:12 PM
\***********************************/

package com.project.crm.project;

import java.util.Date;
import com.project.main.entity.*;


public class ProjectTerm extends Entity {

	private long projectId = 0;
	private int squence = 0;
	private int type = 0;
	private String description = "";
	private int status = 0;
	private double amount = 0;
	private long currencyId = 0;
	private long companyId = 0;
	private Date dueDate = new Date();

	public long getProjectId(){
		return projectId;
	}

	public void setProjectId(long projectId){
		this.projectId = projectId;
	}

	public int getSquence(){
		return squence;
	}

	public void setSquence(int squence){
		this.squence = squence;
	}

	public int getType(){
		return type;
	}

	public void setType(int type){
		this.type = type;
	}

	public String getDescription(){
		return description;
	}

	public void setDescription(String description){
		if ( description == null) {
			description = "";
		}
		this.description = description;
	}

	public int getStatus(){
		return status;
	}

	public void setStatus(int status){
		this.status = status;
	}

	public double getAmount(){
		return amount;
	}

	public void setAmount(double amount){
		this.amount = amount;
	}

	public long getCurrencyId(){
		return currencyId;
	}

	public void setCurrencyId(long currencyId){
		this.currencyId = currencyId;
	}

	public long getCompanyId(){
		return companyId;
	}

	public void setCompanyId(long companyId){
		this.companyId = companyId;
	}

	public Date getDueDate(){
		return dueDate;
	}

	public void setDueDate(Date dueDate){
		this.dueDate = dueDate;
	}
}
