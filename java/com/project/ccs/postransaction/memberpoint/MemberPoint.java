package com.project.ccs.postransaction.memberpoint; 
 
import java.util.Date;
import com.project.main.entity.*;

public class MemberPoint extends Entity { 

	private long customerId;
	private Date date;
	private double point;
	private int inOut;
	private int type;
	private double pointUnitValue;
	private long salesId;
        private int groupType;
        private long itemGroupId;
        private long locationId = 0;
        
        private int postedStatus = 0;
        private long postedById = 0;
        private Date postedDate;

	public long getItemGroupId(){ 
		return itemGroupId; 
	} 

	public void setItemGroupId(long itemGroupId){ 
		this.itemGroupId = itemGroupId; 
	} 

	public int getGroupType(){ 
		return groupType; 
	} 

	public void setgroupType(int groupType){ 
		this.groupType = groupType; 
	} 
        
        public long getCustomerId(){ 
		return customerId; 
	} 

	public void setCustomerId(long customerId){ 
		this.customerId = customerId; 
	} 

	public Date getDate(){ 
		return date; 
	} 

	public void setDate(Date date){ 
		this.date = date; 
	} 

	public double getPoint(){ 
		return point; 
	} 

	public void setPoint(double point){ 
		this.point = point; 
	} 

	public int getInOut(){ 
		return inOut; 
	} 

	public void setInOut(int inOut){ 
		this.inOut = inOut; 
	} 

	public int getType(){ 
		return type; 
	} 

	public void setType(int type){ 
		this.type = type; 
	} 

	public double getPointUnitValue(){ 
		return pointUnitValue; 
	} 

	public void setPointUnitValue(double pointUnitValue){ 
		this.pointUnitValue = pointUnitValue; 
	} 

	public long getSalesId(){ 
		return salesId; 
	} 

	public void setSalesId(long salesId){ 
		this.salesId = salesId; 
	}

    public int getPostedStatus() {
        return postedStatus;
    }

    public void setPostedStatus(int postedStatus) {
        this.postedStatus = postedStatus;
    }


    public long getPostedById() {
        return postedById;
    }

    public void setPostedById(long postedById) {
        this.postedById = postedById;
    }


    public Date getPostedDate() {
        return postedDate;
    }

    public void setPostedDate(Date postedDate) {
        this.postedDate = postedDate;
    }

    public long getLocationId() {
        return locationId;
    }

    public void setLocationId(long locationId) {
        this.locationId = locationId;
    }

}
