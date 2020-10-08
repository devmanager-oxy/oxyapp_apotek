package com.project.clinic.transaction; 
 
import com.project.main.entity.*;
import java.util.Date;

public class Patient extends Entity { 

	private Date regDate;
	private String cin = "";
	private int counter;
	private String idNumber = "";
	private String idType = "";
	private String title = "";
	private int gender;
	private String name = "";
	private String birthPlace = "";
	private Date birthDate;
	private String address = "";
	private long stateId;
	private long countryId;
	private String zip = "";
	private String fax = "";
	private long companyId;
	private String email = "";
	private String employeeNum = "";
	private long insuranceId;
	private String insuranceNo = "";
	private long insuranceRelationId;
	private String phone = "";
	private String mobile = "";
	private String occupation = "";
	private long doctorId;
	private long posMemberId;

	public Date getRegDate(){ 
		return regDate; 
	} 

	public void setRegDate(Date regDate){ 
		this.regDate = regDate; 
	} 

	public String getCin(){ 
		return cin; 
	} 

	public void setCin(String cin){ 
		if ( cin == null ) {
			cin = ""; 
		} 
		this.cin = cin; 
	} 

	public int getCounter(){ 
		return counter; 
	} 

	public void setCounter(int counter){ 
		this.counter = counter; 
	} 

	public String getIdNumber(){ 
		return idNumber; 
	} 

	public void setIdNumber(String idNumber){ 
		if ( idNumber == null ) {
			idNumber = ""; 
		} 
		this.idNumber = idNumber; 
	} 

	public String getIdType(){ 
		return idType; 
	} 

	public void setIdType(String idType){ 
		if ( idType == null ) {
			idType = ""; 
		} 
		this.idType = idType; 
	} 

	public String getTitle(){ 
		return title; 
	} 

	public void setTitle(String title){ 
		if ( title == null ) {
			title = ""; 
		} 
		this.title = title; 
	} 

	public int getGender(){ 
		return gender; 
	} 

	public void setGender(int gender){ 
		this.gender = gender; 
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

	public String getBirthPlace(){ 
		return birthPlace; 
	} 

	public void setBirthPlace(String birthPlace){ 
		if ( birthPlace == null ) {
			birthPlace = ""; 
		} 
		this.birthPlace = birthPlace; 
	} 

	public Date getBirthDate(){ 
		return birthDate; 
	} 

	public void setBirthDate(Date birthDate){ 
		this.birthDate = birthDate; 
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

	public long getCompanyId(){ 
		return companyId; 
	} 

	public void setCompanyId(long companyId){ 
		this.companyId = companyId; 
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

	public String getEmployeeNum(){ 
		return employeeNum; 
	} 

	public void setEmployeeNum(String employeeNum){ 
		if ( employeeNum == null ) {
			employeeNum = ""; 
		} 
		this.employeeNum = employeeNum; 
	} 

	public long getInsuranceId(){ 
		return insuranceId; 
	} 

	public void setInsuranceId(long insuranceId){ 
		this.insuranceId = insuranceId; 
	} 

	public String getInsuranceNo(){ 
		return insuranceNo; 
	} 

	public void setInsuranceNo(String insuranceNo){ 
		if ( insuranceNo == null ) {
			insuranceNo = ""; 
		} 
		this.insuranceNo = insuranceNo; 
	} 

	public long getInsuranceRelationId(){ 
		return insuranceRelationId; 
	} 

	public void setInsuranceRelationId(long insuranceRelationId){ 
		this.insuranceRelationId = insuranceRelationId; 
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

	public String getOccupation(){ 
		return occupation; 
	} 

	public void setOccupation(String occupation){ 
		if ( occupation == null ) {
			occupation = ""; 
		} 
		this.occupation = occupation; 
	} 

	public long getDoctorId(){ 
		return doctorId; 
	} 

	public void setDoctorId(long doctorId){ 
		this.doctorId = doctorId; 
	} 

	public long getPosMemberId(){ 
		return posMemberId; 
	} 

	public void setPosMemberId(long posMemberId){ 
		this.posMemberId = posMemberId; 
	} 

}
