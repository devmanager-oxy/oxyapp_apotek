package com.project.clinic.master; 
 
import com.project.main.entity.*;

public class Deseas extends Entity { 

	private String name = "";

	public String getName(){ 
		return name; 
	} 

	public void setName(String name){ 
		if ( name == null ) {
			name = ""; 
		} 
		this.name = name; 
	} 

}
