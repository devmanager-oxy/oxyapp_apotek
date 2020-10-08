
package com.project.fms.master; 
 
import java.util.Date;
import com.project.main.entity.*;

public class CoaOpeningBalance extends Entity { 

	private long coaId;
	private long periodeId;
	private double openingBalance;

	public long getCoaId(){ 
		return coaId; 
	} 

	public void setCoaId(long coaId){ 
		this.coaId = coaId; 
	} 

	public long getPeriodeId(){ 
		return periodeId; 
	} 

	public void setPeriodeId(long periodeId){ 
		this.periodeId = periodeId; 
	} 

	public double getOpeningBalance(){ 
		return openingBalance; 
	} 

	public void setOpeningBalance(double openingBalance){ 
		this.openingBalance = openingBalance; 
	} 

}
