package com.project.clinic.transaction; 
 
import com.project.main.entity.*;

public class PatientDesease extends Entity { 

	private long deseaseId;
	private long patientId;

	public long getDeseaseId(){ 
		return deseaseId; 
	} 

	public void setDeseaseId(long deseaseId){ 
		this.deseaseId = deseaseId; 
	} 

	public long getPatientId(){ 
		return patientId; 
	} 

	public void setPatientId(long patientId){ 
		this.patientId = patientId; 
	} 

}
