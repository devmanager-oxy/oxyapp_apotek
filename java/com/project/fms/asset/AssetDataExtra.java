
package com.project.fms.asset; 
 
import java.util.Date;
import com.project.main.entity.*;


public class AssetDataExtra extends Entity { 

	private Date date;
	private int year;
	private double pengurangPerolehan;
	private double pengurangDepre;
	private long userId;
	private long assetDataId;

	public Date getDate(){ 
		return date; 
	} 

	public void setDate(Date date){ 
		this.date = date; 
	} 

	public int getYear(){ 
		return year; 
	} 

	public void setYear(int year){ 
		this.year = year; 
	} 

	public double getPengurangPerolehan(){ 
		return pengurangPerolehan; 
	} 

	public void setPengurangPerolehan(double pengurangPerolehan){ 
		this.pengurangPerolehan = pengurangPerolehan; 
	} 

	public double getPengurangDepre(){ 
		return pengurangDepre; 
	} 

	public void setPengurangDepre(double pengurangDepre){ 
		this.pengurangDepre = pengurangDepre; 
	} 

	public long getUserId(){ 
		return userId; 
	} 

	public void setUserId(long userId){ 
		this.userId = userId; 
	} 

	public long getAssetDataId(){ 
		return assetDataId; 
	} 

	public void setAssetDataId(long assetDataId){ 
		this.assetDataId = assetDataId; 
	} 

}
