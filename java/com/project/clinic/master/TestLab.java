package com.project.clinic.master; 
 
import com.project.main.entity.*;

public class TestLab extends Entity { 

	private String testName = "";

	public String getTestName(){ 
		return testName; 
	} 

	public void setTestName(String testName){ 
		if ( testName == null ) {
			testName = ""; 
		} 
		this.testName = testName; 
	} 

}
