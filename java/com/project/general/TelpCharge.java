

package com.project.general; 
 
import java.util.Date;
import com.project.main.entity.*;

public class TelpCharge extends Entity { 

	private long userId;
	private String callType = "";
	private String areaName = "";
	private String prefixNumber = "";
	private int unitCall = 0;
	private double charge = 0;

	public long getUserId(){ 
		return userId; 
	} 

	public void setUserId(long userId){ 
		this.userId = userId; 
	} 

	public String getCallType(){ 
		return callType; 
	} 

	public void setCallType(String callType){ 
		if ( callType == null ) {
			callType = ""; 
		} 
		this.callType = callType; 
	} 

	public String getAreaName(){ 
		return areaName; 
	} 

	public void setAreaName(String areaName){ 
		if ( areaName == null ) {
			areaName = ""; 
		} 
		this.areaName = areaName; 
	} 

	public String getPrefixNumber(){ 
		return prefixNumber; 
	} 

	public void setPrefixNumber(String prefixNumber){ 
		if ( prefixNumber == null ) {
			prefixNumber = ""; 
		} 
		this.prefixNumber = prefixNumber; 
	} 

	public int getUnitCall(){ 
		return unitCall; 
	} 

	public void setUnitCall(int unitCall){ 
		this.unitCall = unitCall; 
	} 

	public double getCharge(){ 
		return charge; 
	} 

	public void setCharge(double charge){ 
		this.charge = charge; 
	} 

}
