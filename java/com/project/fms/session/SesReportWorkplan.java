/***********************************\
|  Create by Dek-Ndut               |
|                                   |
|  3/27/2008 5:04:11 PM
\***********************************/

package com.project.fms.session;

import java.util.Date;
import com.project.main.entity.*;


public class SesReportWorkplan extends Entity {

	private String code = "";
	private String level = "";
	private String description = "";
	private String output = "";
	private String indicator = "";
	private String risk = "";
	private double directCost = 0;
	private double compensation = 0;
	private double overhead = 0;
	private double total = 0;
	private int font = 0;
	private String temp = "";

	public String getCode(){
		return code;
	}

	public void setCode(String code){
		if ( code == null) {
			code = "";
		}
		this.code = code;
	}

	public String getLevel(){
		return level;
	}

	public void setLevel(String level){
		if ( level == null) {
			level = "";
		}
		this.level = level;
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

	public String getOutput(){
		return output;
	}

	public void setOutput(String output){
		if ( output == null) {
			output = "";
		}
		this.output = output;
	}

	public String getIndicator(){
		return indicator;
	}

	public void setIndicator(String indicator){
		if ( indicator == null) {
			indicator = "";
		}
		this.indicator = indicator;
	}

	public String getRisk(){
		return risk;
	}

	public void setRisk(String risk){
		if ( risk == null) {
			risk = "";
		}
		this.risk = risk;
	}

	public double getDirectCost(){
		return directCost;
	}

	public void setDirectCost(double directCost){
		this.directCost = directCost;
	}

	public double getCompensation(){
		return compensation;
	}

	public void setCompensation(double compensation){
		this.compensation = compensation;
	}

	public double getOverhead(){
		return overhead;
	}

	public void setOverhead(double overhead){
		this.overhead = overhead;
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
