package com.project.ccs.postransaction.memberpoint; 
 
import java.util.Date;
import com.project.main.entity.*;

public class MemberPointSetup extends Entity { 

	private int groupType;
	private double amount;
	private double point;
	private long userId;
	private Date date;
	private Date lastUpdateDate;
	private int status;
	private double pointUnitValue;
	private Date startDate;
	private Date endDate;
	private int amountRounding;
        private double minRouding;
	private long itemGroupId;

	public long getItemGroupId(){ 
		return itemGroupId; 
	} 

	public void setItemGroupId(long itemGroupId){ 
		this.itemGroupId = itemGroupId; 
	} 
        
        public int getGroupType(){ 
		return groupType; 
	} 

	public void setGroupType(int groupType){ 
		this.groupType = groupType; 
	} 

	public double getAmount(){ 
		return amount; 
	} 

	public void setAmount(double amount){ 
		this.amount = amount; 
	} 

	public double getPoint(){ 
		return point; 
	} 

	public void setPoint(double point){ 
		this.point = point; 
	} 

	public long getUserId(){ 
		return userId; 
	} 

	public void setUserId(long userId){ 
		this.userId = userId; 
	} 

	public Date getDate(){ 
		return date; 
	} 

	public void setDate(Date date){ 
		this.date = date; 
	} 

	public Date getLastUpdateDate(){ 
		return lastUpdateDate; 
	} 

	public void setLastUpdateDate(Date lastUpdateDate){ 
		this.lastUpdateDate = lastUpdateDate; 
	} 

	public int getStatus(){ 
		return status; 
	} 

	public void setStatus(int status){ 
		this.status = status; 
	} 

	public double getPointUnitValue(){ 
		return pointUnitValue; 
	} 

	public void setPointUnitValue(double pointUnitValue){ 
		this.pointUnitValue = pointUnitValue; 
	} 

	public Date getStartDate(){ 
		return startDate; 
	} 

	public void setStartDate(Date startDate){ 
		this.startDate = startDate; 
	} 

	public Date getEndDate(){ 
		return endDate; 
	} 

	public void setEndDate(Date endDate){ 
		this.endDate = endDate; 
	} 

	public int getAmountRounding(){ 
		return amountRounding; 
	} 

	public void setAmountRounding(int amountRounding){ 
		this.amountRounding = amountRounding; 
	} 

	public double getMinRouding(){ 
		return minRouding; 
	} 

	public void setMinRouding(double minRouding){ 
		this.minRouding = minRouding; 
	} 

}
