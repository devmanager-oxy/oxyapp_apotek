package com.project.clinic.transaction; 
 
import com.project.main.entity.*;

public class Doctor extends Entity { 

	private String title = "";
	private String name = "";
	private long specialtyId;
	private String ssn = "";
	private String degree = "";
	private String email = "";
	private String address = "";
	private long stateId;
	private long countryId;
	private String zip = "";
	private String fax = "";
	private String phone = "";
	private String mobile = "";

	public String getTitle(){ 
		return title; 
	} 

	public void setTitle(String title){ 
                if ( title == null ) {
			title = ""; 
		} 
		this.title = title; 
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

	public long getSpecialtyId(){ 
		return specialtyId; 
	} 

	public void setSpecialtyId(long specialtyId){ 
		this.specialtyId = specialtyId; 
	} 

	public String getSsn(){ 
		return ssn; 
	} 

	public void setSsn(String ssn){ 
		if ( ssn == null ) {
			ssn = ""; 
		} 
		this.ssn = ssn; 
	} 

	public String getDegree(){ 
		return degree; 
	} 

	public void setDegree(String degree){ 
		if ( degree == null ) {
			degree = ""; 
		} 
		this.degree = degree; 
	} 

	public String getEmail(){ 
		return email; 
	} 

	public void setEmail(String email){ 
		if ( email == null ) {
			email = ""; 
		} 
		this.email = email; 
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

	public long getStateId(){ 
		return stateId; 
	} 

	public void setStateId(long stateId){ 
		this.stateId = stateId; 
	} 

	public long getCountryId(){ 
		return countryId; 
	} 

	public void setCountryId(long countryId){ 
		this.countryId = countryId; 
	} 

	public String getZip(){ 
		return zip; 
	} 

	public void setZip(String zip){ 
		if ( zip == null ) {
			zip = ""; 
		} 
		this.zip = zip; 
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

	public String getPhone(){ 
		return phone; 
	} 

	public void setPhone(String phone){ 
		if ( phone == null ) {
			phone = ""; 
		} 
		this.phone = phone; 
	} 

	public String getMobile(){ 
		return mobile; 
	} 

	public void setMobile(String mobile){ 
		if ( mobile == null ) {
			mobile = ""; 
		} 
		this.mobile = mobile; 
	} 

}
