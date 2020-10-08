/***********************************\
|  Create by Dek-Ndut               |
|  Karya kami mohon jangan dibajak  |
|                                   |
|  10/7/2008 8:34:41 PM
\***********************************/

package com.project.crm.project;

import java.util.Date;
import com.project.main.entity.*;


public class ProjectProductDetail extends Entity {

	private long projectId = 0;
	private long categoryId = 0;
	private String itemDescription = "";
	private int squence = 0;
	private double amount = 0;
	private int status = 0;
	private long currencyId = 0;
	private long companyId = 0;

	public long getProjectId(){
		return projectId;
	}

	public void setProjectId(long projectId){
		this.projectId = projectId;
	}

	public long getCategoryId(){
		return categoryId;
	}

	public void setCategoryId(long categoryId){
		this.categoryId = categoryId;
	}

	public String getItemDescription(){
		return itemDescription;
	}

	public void setItemDescription(String itemDescription){
		if ( itemDescription == null) {
			itemDescription = "";
		}
		this.itemDescription = itemDescription;
	}

	public int getSquence(){
		return squence;
	}

	public void setSquence(int squence){
		this.squence = squence;
	}

	public double getAmount(){
		return amount;
	}

	public void setAmount(double amount){
		this.amount = amount;
	}

	public int getStatus(){
		return status;
	}

	public void setStatus(int status){
		this.status = status;
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
}
