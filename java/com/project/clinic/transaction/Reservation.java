package com.project.clinic.transaction; 
 
import com.project.main.entity.*;
import java.util.Date;

public class Reservation extends Entity { 

	private Date regDate;
	private long patientId;
	private int queueNumber;
	private long doctorId;
	private Date queueTime;
	private int status;
	private String description = "";
	private long adminId;

	public Date getRegDate(){ 
		return regDate; 
	} 

	public void setRegDate(Date regDate){ 
		this.regDate = regDate; 
	} 

	public long getPatientId(){ 
		return patientId; 
	} 

	public void setPatientId(long patientId){ 
		this.patientId = patientId; 
	} 

	public int getQueueNumber(){ 
		return queueNumber; 
	} 

	public void setQueueNumber(int queueNumber){ 
		this.queueNumber = queueNumber; 
	} 

	public long getDoctorId(){ 
		return doctorId; 
	} 

	public void setDoctorId(long doctorId){ 
		this.doctorId = doctorId; 
	} 

	public Date getQueueTime(){ 
		return queueTime; 
	} 

	public void setQueueTime(Date queueTime){ 
		this.queueTime = queueTime; 
	} 

	public int getStatus(){ 
		return status; 
	} 

	public void setStatus(int status){ 
		this.status = status; 
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

	public long getAdminId(){ 
		return adminId; 
	} 

	public void setAdminId(long adminId){ 
		this.adminId = adminId; 
	} 

}
