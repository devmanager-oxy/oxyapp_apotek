/***********************************\
|  Create by Dek-Ndut               |
|                                   |
|  3/30/2008 3:37:45 PM
\***********************************/

package com.project.fms.session;

import java.util.Date;
import com.project.main.entity.*;


public class SesReportIfc extends Entity {

	private String description = "";
	private double total = 0;
	private double percent = 0;
	private int font = 0;
	private String temp = "";

	public String getDescription(){
		return description;
	}

	public void setDescription(String description){
		if ( description == null) {
			description = "";
		}
		this.description = description;
	}

	public double getTotal(){
		return total;
	}

	public void setTotal(double total){
		this.total = total;
	}

	public double getPercent(){
		return percent;
	}

	public void setPercent(double percent){
		this.percent = percent;
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
