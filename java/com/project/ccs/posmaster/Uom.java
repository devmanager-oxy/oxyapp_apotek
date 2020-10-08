
package com.project.ccs.posmaster; 
 
import java.util.Date;
import com.project.main.entity.*;

public class Uom extends Entity { 

	private String unit = "";

	public String getUnit(){ 
		return unit; 
	} 

	public void setUnit(String unit){ 
		if ( unit == null ) {
			unit = ""; 
		} 
		this.unit = unit; 
	} 

}
