
package com.project.fms.activity; 
 
import java.util.Date;
import com.project.main.entity.*;

public class DonorComponent extends Entity { 

	private long donorId = 0;
	private String code = "";
	private String name = "";
	private String description = "";
	private String donorName = "";

	public long getDonorId(){ 
		return donorId; 
	} 

	public void setDonorId(long donorId){ 
		this.donorId = donorId; 
	} 

	public String getCode(){ 
		return code; 
	} 

	public void setCode(String code){ 
		if ( code == null ) {
			code = ""; 
		} 
		this.code = code; 
	} 

	public String getName(){ 
		return name; 
	} 

	public void setName(String name){ 
		if ( name == null ) {
			name = ""; 
		} 
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

	public String getDonorName(){ 
		return donorName; 
	} 

	public void setDonorName(String donorName){ 
		if ( donorName == null ) {
			donorName = ""; 
		} 
		this.donorName = donorName; 
	} 

}
