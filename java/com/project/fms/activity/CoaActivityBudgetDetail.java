
package com.project.fms.activity; 
 
import java.util.Date;
import com.project.main.entity.*;

public class CoaActivityBudgetDetail extends Entity { 

	private long coaActivityBudgetId;
	private double percent;
	private long moduleId;

	public long getCoaActivityBudgetId(){ 
		return coaActivityBudgetId; 
	} 

	public void setCoaActivityBudgetId(long coaActivityBudgetId){ 
		this.coaActivityBudgetId = coaActivityBudgetId; 
	} 

	public double getPercent(){ 
		return percent; 
	} 

	public void setPercent(double percent){ 
		this.percent = percent; 
	} 

	public long getModuleId(){ 
		return moduleId; 
	} 

	public void setModuleId(long moduleId){ 
		this.moduleId = moduleId; 
	} 

}
