

package com.project.general; 
 
/* package java */ 
import java.util.Date;

/* package qdep */
import com.project.main.entity.*;

public class PayMethod extends Entity { 

	private String payMethod = "";
	private String description = "";

	public String getPayMethod(){ 
		return payMethod; 
	} 

	public void setPayMethod(String payMethod){ 
		if ( payMethod == null ) {
			payMethod = ""; 
		} 
		this.payMethod = payMethod; 
	} 

	public String getDescription(){ 
		return description; 
	} 

	public void setDescription(String description){ 
		if ( description == null ) {
			description = ""; 
		} 
		this.description = description; 
	} 

}
