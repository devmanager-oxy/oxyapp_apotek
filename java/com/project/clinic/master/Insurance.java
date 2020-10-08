package com.project.clinic.master; 
 
import com.project.main.entity.*;

public class Insurance extends Entity { 

	private String name = "";
	private String code = "";
        private String priceGroup  = "";
        private long memberId = 0;
        private double discPercent = 0;

        public double getDiscPercent(){ 
		return discPercent; 
	} 

	public void setDiscPercent(double discPercent){ 
		
		this.discPercent = discPercent; 
	}
        
        public String getPriceGroup(){ 
		return priceGroup; 
	} 

	public void setPriceGroup(String priceGroup){ 
		if ( priceGroup == null ) {
			priceGroup = ""; 
		} 
		this.priceGroup = priceGroup; 
	}
        
        public long getMemberId(){ 
		return memberId; 
	} 

	public void setMemberId(long memberId){ 
		
		this.memberId = memberId; 
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

	public String getCode(){ 
		return code; 
	} 

	public void setCode(String code){ 
		if ( code == null ) {
			code = ""; 
		} 
		this.code = code; 
	} 

}
