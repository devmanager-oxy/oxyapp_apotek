
package com.project.fms.activity; 
 
import java.util.Date;
import com.project.main.entity.*;

public class ActivityPeriodBudget extends Entity { 

	private long activityPeriodId = 0;
	private double budget = 0;
	private long moduleId = 0;

	public long getActivityPeriodId(){ 
		return activityPeriodId; 
	} 

	public void setActivityPeriodId(long activityPeriodId){ 
		this.activityPeriodId = activityPeriodId; 
	} 

	public double getBudget(){ 
		return budget; 
	} 

	public void setBudget(double budget){ 
		this.budget = budget; 
	} 

	public long getModuleId(){ 
		return moduleId; 
	} 

	public void setModuleId(long moduleId){ 
		this.moduleId = moduleId; 
	} 

}
