
package com.project.general; 

/* package qdep */
import com.project.main.entity.*;

public class Currency extends Entity { 

	private String currencyCode = "";
	private String description = "";
        private double rate = 0;
        private long coaId;

	public String getCurrencyCode(){ 
		return currencyCode; 
	} 

	public void setCurrencyCode(String currencyCode){ 
		if ( currencyCode == null ) {
			currencyCode = ""; 
		} 
		this.currencyCode = currencyCode; 
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

        public double getRate() {
            return rate;
        }

        public void setRate(double rate) {
            this.rate = rate;
        }

    public long getCoaId() {
        return coaId;
    }

    public void setCoaId(long coaId) {
        this.coaId = coaId;
    }

}
