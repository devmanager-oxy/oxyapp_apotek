package com.project.clinic.transaction; 
 
import com.project.main.entity.*;
import java.util.Date;

public class MedicalRecord extends Entity { 

	private String number = "";
	private int counter;
	private long patientId;
	private long reservationId;
	private Date regDate;
	private long doctorId;
	private double weight;
	private double height;
	private double temperature;
	private double respiration;
	private double pulse;
	private String bloodClass = "";
	private String bpDiatoplic = "";
	private String bpSystolic = "";
	private String complaints = "";
	private String testConducted = "";
	private String results = "";
	private String prescription = "";
	private long diagnosisId;

	public String getNumber(){ 
		return number; 
	} 

	public void setNumber(String number){ 
		if ( number == null ) {
			number = ""; 
		} 
		this.number = number; 
	} 

	public int getCounter(){ 
		return counter; 
	} 

	public void setCounter(int counter){ 
		this.counter = counter; 
	} 

	public long getPatientId(){ 
		return patientId; 
	} 

	public void setPatientId(long patientId){ 
		this.patientId = patientId; 
	} 

	public long getReservationId(){ 
		return reservationId; 
	} 

	public void setReservationId(long reservationId){ 
		this.reservationId = reservationId; 
	} 

	public Date getRegDate(){ 
		return regDate; 
	} 

	public void setRegDate(Date regDate){ 
		this.regDate = regDate; 
	} 

	public long getDoctorId(){ 
		return doctorId; 
	} 

	public void setDoctorId(long doctorId){ 
		this.doctorId = doctorId; 
	} 

	public double getWeight(){ 
		return weight; 
	} 

	public void setWeight(double weight){ 
		this.weight = weight; 
	} 

	public double getHeight(){ 
		return height; 
	} 

	public void setHeight(double height){ 
		this.height = height; 
	} 

	public double getTemperature(){ 
		return temperature; 
	} 

	public void setTemperature(double temperature){ 
		this.temperature = temperature; 
	} 

	public double getRespiration(){ 
		return respiration; 
	} 

	public void setRespiration(double respiration){ 
		this.respiration = respiration; 
	} 

	public double getPulse(){ 
		return pulse; 
	} 

	public void setPulse(double pulse){ 
		this.pulse = pulse; 
	} 

	public String getBloodClass(){ 
		return bloodClass; 
	} 

	public void setBloodClass(String bloodClass){ 
		if ( bloodClass == null ) {
			bloodClass = ""; 
		} 
		this.bloodClass = bloodClass; 
	} 

	public String getBpDiatoplic(){ 
		return bpDiatoplic; 
	} 

	public void setBpDiatoplic(String bpDiatoplic){ 
		if ( bpDiatoplic == null ) {
			bpDiatoplic = ""; 
		} 
		this.bpDiatoplic = bpDiatoplic; 
	} 

	public String getBpSystolic(){ 
		return bpSystolic; 
	} 

	public void setBpSystolic(String bpSystolic){ 
		if ( bpSystolic == null ) {
			bpSystolic = ""; 
		} 
		this.bpSystolic = bpSystolic; 
	} 

	public String getComplaints(){ 
		return complaints; 
	} 

	public void setComplaints(String complaints){ 
		if ( complaints == null ) {
			complaints = ""; 
		} 
		this.complaints = complaints; 
	} 

	public String getTestConducted(){ 
		return testConducted; 
	} 

	public void setTestConducted(String testConducted){ 
		if ( testConducted == null ) {
			testConducted = ""; 
		} 
		this.testConducted = testConducted; 
	} 

	public String getResults(){ 
		return results; 
	} 

	public void setResults(String results){ 
		if ( results == null ) {
			results = ""; 
		} 
		this.results = results; 
	} 

	public String getPrescription(){ 
		return prescription; 
	} 

	public void setPrescription(String prescription){ 
		if ( prescription == null ) {
			prescription = ""; 
		} 
		this.prescription = prescription; 
	} 

	public long getDiagnosisId(){ 
		return diagnosisId; 
	} 

	public void setDiagnosisId(long diagnosisId){ 
		this.diagnosisId = diagnosisId; 
	} 

}
