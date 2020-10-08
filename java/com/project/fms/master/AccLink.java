
package com.project.fms.master; 
 
import java.util.Date;
import com.project.main.entity.*;

public class AccLink extends Entity { 

	private long coaId = 0;
	private long departmentId = 0;
	private String type = "";
	private String coaName = "";
	private String coaCode = "";
	private String departmentName = "";
	private long userId = 0;

        /**
         * Holds value of property locationId.
         */
        private long locationId;
        
        /**
         * Holds value of property companyId.
         */
        private long companyId;
        
	public long getCoaId(){ 
		return coaId; 
	} 

	public void setCoaId(long coaId){ 
		this.coaId = coaId; 
	} 

	public long getDepartmentId(){ 
		return departmentId; 
	} 

	public void setDepartmentId(long departmentId){ 
		this.departmentId = departmentId; 
	} 

	public String getType(){ 
		return type; 
	} 

	public void setType(String type){ 
		if ( type == null ) {
			type = ""; 
		} 
		this.type = type; 
	} 

	public String getCoaName(){ 
		return coaName; 
	} 

	public void setCoaName(String coaName){ 
		if ( coaName == null ) {
			coaName = ""; 
		} 
		this.coaName = coaName; 
	} 

	public String getCoaCode(){ 
		return coaCode; 
	} 

	public void setCoaCode(String coaCode){ 
		if ( coaCode == null ) {
			coaCode = ""; 
		} 
		this.coaCode = coaCode; 
	} 

	public String getDepartmentName(){ 
		return departmentName; 
	} 

	public void setDepartmentName(String departmentName){ 
		if ( departmentName == null ) {
			departmentName = ""; 
		} 
		this.departmentName = departmentName; 
	} 

	public long getUserId(){ 
		return userId; 
	} 

	public void setUserId(long userId){ 
		this.userId = userId; 
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
        
        /**
         * Getter for property companyId.
         * @return Value of property companyId.
         */
        public long getCompanyId() {
            return this.companyId;
        }
        
        /**
         * Setter for property companyId.
         * @param companyId New value of property companyId.
         */
        public void setCompanyId(long companyId) {
            this.companyId = companyId;
        }
        
}
