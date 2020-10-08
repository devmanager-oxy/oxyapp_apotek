
package com.project.fms.master; 
 
import java.util.Date;
import com.project.main.entity.*;

public class Donor extends Entity { 

	private String name = "";
	private String address = "";
	private String city = "";
	private String state = "";
	private String countryName = "";
	private String description = "";
	private long countryId = 0;
	private String phone = "";
	private String fax = "";
	private String hp = "";
	private String code = "";

        /**
         * Holds value of property contactPerson.
         */
        private String contactPerson = "";
        
	public String getName(){ 
		return name; 
	} 

	public void setName(String name){ 
		if ( name == null ) {
			name = ""; 
		} 
		this.name = name; 
	} 

	public String getAddress(){ 
		return address; 
	} 

	public void setAddress(String address){ 
		if ( address == null ) {
			address = ""; 
		} 
		this.address = address; 
	} 

	public String getCity(){ 
		return city; 
	} 

	public void setCity(String city){ 
		if ( city == null ) {
			city = ""; 
		} 
		this.city = city; 
	} 

	public String getState(){ 
		return state; 
	} 

	public void setState(String state){ 
		if ( state == null ) {
			state = ""; 
		} 
		this.state = state; 
	} 

	public String getCountryName(){ 
		return countryName; 
	} 

	public void setCountryName(String countryName){ 
		if ( countryName == null ) {
			countryName = ""; 
		} 
		this.countryName = countryName; 
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

	public long getCountryId(){ 
		return countryId; 
	} 

	public void setCountryId(long countryId){ 
		this.countryId = countryId; 
	} 

	public String getPhone(){ 
		return phone; 
	} 

	public void setPhone(String phone){ 
		if ( phone == null ) {
			phone = ""; 
		} 
		this.phone = phone; 
	} 

	public String getFax(){ 
		return fax; 
	} 

	public void setFax(String fax){ 
		if ( fax == null ) {
			fax = ""; 
		} 
		this.fax = fax; 
	} 

	public String getHp(){ 
		return hp; 
	} 

	public void setHp(String hp){ 
		if ( hp == null ) {
			hp = ""; 
		} 
		this.hp = hp; 
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

        /**
         * Getter for property contactPerson.
         * @return Value of property contactPerson.
         */
        public String getContactPerson() {
            return this.contactPerson;
        }
        
        /**
         * Setter for property contactPerson.
         * @param contactPerson New value of property contactPerson.
         */
        public void setContactPerson(String contactPerson) {
            this.contactPerson = contactPerson;
        }
        
}
