package com.project.general;

import com.project.main.entity.*;

public class Dinas extends Entity { 

	private String nama = "";

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
