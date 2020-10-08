
package com.project.ccs.posmaster; 
 
import java.util.Date;
import com.project.main.entity.*;

public class WaiterTable extends Entity { 

	private String name = "";
	private int pax;
	private String status = "";

        /**
         * Holds value of property locationId.
         */
        private long locationId;
        
	public String getName(){ 
		return name; 
	} 

	public void setName(String name){ 
		if ( name == null ) {
			name = ""; 
		} 
		this.name = name; 
	} 

	public int getPax(){ 
		return pax; 
	} 

	public void setPax(int pax){ 
		this.pax = pax; 
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

        /**
         * Getter for property locationId.
         * @return Value of property locationId.
         */
        public long getLocationId() {
            return this.locationId;
        }
        
        /**
         * Setter for property locationId.
         * @param locationId New value of property locationId.
         */
        public void setLocationId(long locationId) {
            this.locationId = locationId;
        }
        
}
