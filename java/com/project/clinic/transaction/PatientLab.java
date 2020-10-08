package com.project.clinic.transaction; 
 
import com.project.main.entity.*;
import java.util.Date;

public class PatientLab extends Entity { 

	private Date date;
	private long patientId;
	private long testLabId;
	private String resultValue = "";
	private String normalValue = "";
	private String description = "";

	public Date getDate(){ 
		return date; 
	} 

	public void setDate(Date date){ 
		this.date = date; 
	} 

	public long getPatientId(){ 
		return patientId; 
	} 

	public void setPatientId(long patientId){ 
		this.patientId = patientId; 
	} 

	public long getTestLabId(){ 
		return testLabId; 
	} 

	public void setTestLabId(long testLabId){ 
		this.testLabId = testLabId; 
	} 

	public String getResultValue(){ 
		return resultValue; 
	} 

	public void setResultValue(String resultValue){ 
		if ( resultValue == null ) {
			resultValue = ""; 
		} 
		this.resultValue = resultValue; 
	} 

	public String getNormalValue(){ 
		return normalValue; 
	} 

	public void setNormalValue(String normalValue){ 
		if ( normalValue == null ) {
			normalValue = ""; 
		} 
		this.normalValue = normalValue; 
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

}
