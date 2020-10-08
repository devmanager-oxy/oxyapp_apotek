
package com.project.fms.activity; 
 
import java.util.Date;
import com.project.main.entity.*;

public class CoaGroupAlias extends Entity { 

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
