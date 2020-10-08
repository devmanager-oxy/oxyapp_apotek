
package com.project.coorp.pinjaman; 
 
import java.util.Date;
import com.project.main.entity.*;

public class PeriodeRekap extends Entity { 

	private Date startDate = new Date();
	private Date endDate = new Date();
	private String status = "";
	private String name = "";

        /**
         * Holds value of property inputTolerance.
         */
        private Date inputTolerance = new Date();
        
	public Date getStartDate(){ 
		return startDate; 
	} 

	public void setStartDate(Date startDate){ 
		this.startDate = startDate; 
	} 

	public Date getEndDate(){ 
		return endDate; 
	} 

	public void setEndDate(Date endDate){ 
		this.endDate = endDate; 
	} 

	public String getStatus(){ 
		return status; 
	} 

	public void setStatus(String status){ 
		if ( status == null ) {
			status = ""; 
		} 
		this.status = status; 
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

        /**
         * Getter for property inputTolerance.
         * @return Value of property inputTolerance.
         */
        public Date getInputTolerance() {
            return this.inputTolerance;
        }
        
        /**
         * Setter for property inputTolerance.
         * @param inputTolerance New value of property inputTolerance.
         */
        public void setInputTolerance(Date inputTolerance) {
            this.inputTolerance = inputTolerance;
        }
        
}
