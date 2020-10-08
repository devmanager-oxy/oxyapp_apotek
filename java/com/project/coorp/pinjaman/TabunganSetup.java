package com.project.coorp.pinjaman; 
 
import java.util.Date;
import com.project.main.entity.*;

public class TabunganSetup extends Entity { 

	private double bungaPercent;
	private int bungaType;
	private int bungaActivate;
	private double adminAmount;
	private int adminType;
	private int adminActivate;
	private int serviceStartHour;
	private int serviceStartMinute;
	private double pajakPercent;
	private int pajakType;
	private int pajakActivate;
	private long hutangCoaId;
	private long pajakCoaId;
	private long adminCoaId;
	private long bungaCoaId;

	public double getBungaPercent(){ 
		return bungaPercent; 
	} 

	public void setBungaPercent(double bungaPercent){ 
		this.bungaPercent = bungaPercent; 
	} 

	public int getBungaType(){ 
		return bungaType; 
	} 

	public void setBungaType(int bungaType){ 
		this.bungaType = bungaType; 
	} 

	public int getBungaActivate(){ 
		return bungaActivate; 
	} 

	public void setBungaActivate(int bungaActivate){ 
		this.bungaActivate = bungaActivate; 
	} 

	public double getAdminAmount(){ 
		return adminAmount; 
	} 

	public void setAdminAmount(double adminAmount){ 
		this.adminAmount = adminAmount; 
	} 

	public int getAdminType(){ 
		return adminType; 
	} 

	public void setAdminType(int adminType){ 
		this.adminType = adminType; 
	} 

	public int getAdminActivate(){ 
		return adminActivate; 
	} 

	public void setAdminActivate(int adminActivate){ 
		this.adminActivate = adminActivate; 
	} 

	public int getServiceStartHour(){ 
		return serviceStartHour; 
	} 

	public void setServiceStartHour(int serviceStartHour){ 
		this.serviceStartHour = serviceStartHour; 
	} 

	public int getServiceStartMinute(){ 
		return serviceStartMinute; 
	} 

	public void setServiceStartMinute(int serviceStartMinute){ 
		this.serviceStartMinute = serviceStartMinute; 
	} 

	public double getPajakPercent(){ 
		return pajakPercent; 
	} 

	public void setPajakPercent(double pajakPercent){ 
		this.pajakPercent = pajakPercent; 
	} 

	public int getPajakType(){ 
		return pajakType; 
	} 

	public void setPajakType(int pajakType){ 
		this.pajakType = pajakType; 
	} 

	public int getPajakActivate(){ 
		return pajakActivate; 
	} 

	public void setPajakActivate(int pajakActivate){ 
		this.pajakActivate = pajakActivate; 
	} 

	public long getHutangCoaId(){ 
		return hutangCoaId; 
	} 

	public void setHutangCoaId(long hutangCoaId){ 
		this.hutangCoaId = hutangCoaId; 
	} 

	public long getPajakCoaId(){ 
		return pajakCoaId; 
	} 

	public void setPajakCoaId(long pajakCoaId){ 
		this.pajakCoaId = pajakCoaId; 
	} 

	public long getAdminCoaId(){ 
		return adminCoaId; 
	} 

	public void setAdminCoaId(long adminCoaId){ 
		this.adminCoaId = adminCoaId; 
	} 

	public long getBungaCoaId(){ 
		return bungaCoaId; 
	} 

	public void setBungaCoaId(long bungaCoaId){ 
		this.bungaCoaId = bungaCoaId; 
	} 

}
