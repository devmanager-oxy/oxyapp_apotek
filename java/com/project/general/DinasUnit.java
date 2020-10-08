package com.project.general;

import com.project.main.entity.*;

public class DinasUnit extends Entity { 

	private long dinasId;
	private String nama = "";

	public long getDinasId(){ 
		return dinasId; 
	} 

	public void setDinasId(long dinasId){ 
		this.dinasId = dinasId; 
	} 

	public String getNama(){ 
		return nama; 
	} 

	public void setNama(String nama){ 
		if ( nama == null ) {
			nama = ""; 
		} 
		this.nama = nama; 
	} 

}
