

package com.project.fms.master; 
 
/* package java */ 
import java.util.Date;
import com.project.main.entity.*;

public class ShipAddress extends Entity { 

	private String name = "";
	private String address = "";

	public String getName(){ 
		return name; 
	} 

	public void setName(String name){ 
		if ( name == null ) {
			name = ""; 
		} 
		this.name = name; 
	} 

	public String getAddress(){ 
		return address; 
	} 

	public void setAddress(String address){ 
		if ( address == null ) {
			address = ""; 
		} 
		this.address = address; 
	} 

}
