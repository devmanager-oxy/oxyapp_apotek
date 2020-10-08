/***********************************\
|  Create by Dek-Ndut               |
|                                   |
|  3/27/2008 11:54:56 AM
\***********************************/

package com.project.fms.session;

import java.util.Date;
import com.project.main.entity.*;


public class SesReportDonor extends Entity {

	private String component = "";
	private double expenses = 0;
	private double conpensation = 0;
	private double fa = 0;
	private double logistic = 0;
	private double total = 0;
	private int font = 0;
	private String temp = "";

	public String getComponent(){
		return component;
	}

	public void setComponent(String component){
		if ( component == null) {
			component = "";
		}
		this.component = component;
	}

	public double getExpenses(){
		return expenses;
	}

	public void setExpenses(double expenses){
		this.expenses = expenses;
	}

	public double getConpensation(){
		return conpensation;
	}

	public void setConpensation(double conpensation){
		this.conpensation = conpensation;
	}

	public double getFa(){
		return fa;
	}

	public void setFa(double fa){
		this.fa = fa;
	}

	public double getLogistic(){
		return logistic;
	}

	public void setLogistic(double logistic){
		this.logistic = logistic;
	}

	public double getTotal(){
		return total;
	}

	public void setTotal(double total){
		this.total = total;
	}

	public int getFont(){
		return font;
	}

	public void setFont(int font){
		this.font = font;
	}

	public String getTemp(){
		return temp;
	}

	public void setTemp(String temp){
		if ( temp == null) {
			temp = "";
		}
		this.temp = temp;
	}
}
