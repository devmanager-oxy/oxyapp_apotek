package com.project.clinic.transaction; 
 
import com.project.main.entity.*;

public class PatientXray extends Entity { 

	private long name;
	private String description = "";
	private String imageName = "";

	public long getName(){ 
		return name; 
	} 

	public void setName(long name){ 
		this.name = name; 
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

	public String getImageName(){ 
		return imageName; 
	} 

	public void setImageName(String imageName){ 
		if ( imageName == null ) {
			imageName = ""; 
		} 
		this.imageName = imageName; 
	} 

}
