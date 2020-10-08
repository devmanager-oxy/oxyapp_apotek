
package com.project.fms.master; 
 
/* package java */ 
import java.util.Date;
import com.project.main.entity.*;

public class TermOfPayment extends Entity { 

	private String description = "";
	private int due = 0;
	private int qtyDisc = 0;
	private int discPercent = 0;

	public String getDescription(){ 
		return description; 
	} 

	public void setDescription(String description){ 
		if ( description == null ) {
			description = ""; 
		} 
		this.description = description; 
	} 

	public int getDue(){ 
		return due; 
	} 

	public void setDue(int due){ 
		this.due = due; 
	} 

	public int getQtyDisc(){ 
		return qtyDisc; 
	} 

	public void setQtyDisc(int qtyDisc){ 
		this.qtyDisc = qtyDisc; 
	} 

	public int getDiscPercent(){ 
		return discPercent; 
	} 

	public void setDiscPercent(int discPercent){ 
		this.discPercent = discPercent; 
	} 

}
