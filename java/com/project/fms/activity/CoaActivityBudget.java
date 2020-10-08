
package com.project.fms.activity; 
 
import java.util.Date;
import com.project.main.entity.*;
import java.util.*;

public class CoaActivityBudget extends Entity { 

	private int type;
	private long coaId;
	private double adminPercent;
	private double logisticPercent;
	private String memo = "";

        /**
         * Holds value of property details.
         */
        private Vector details;
        
        /**
         * Holds value of property activityPeriodId.
         */
        private long activityPeriodId;
        
        /**
         * Holds value of property coaExpenseCategoryId.
         */
        private long coaExpenseCategoryId;
        
        /**
         * Holds value of property coaNatureExpenseCategoryId.
         */
        private long coaNatureExpenseCategoryId;
        
	public int getType(){ 
		return type; 
	} 

	public void setType(int type){ 
		 
		this.type = type; 
	} 

	public long getCoaId(){ 
		return coaId; 
	} 

	public void setCoaId(long coaId){ 
		this.coaId = coaId; 
	} 

	public double getAdminPercent(){ 
		return adminPercent; 
	} 

	public void setAdminPercent(double adminPercent){ 
		this.adminPercent = adminPercent; 
	} 

	public double getLogisticPercent(){ 
		return logisticPercent; 
	} 

	public void setLogisticPercent(double logisticPercent){ 
		this.logisticPercent = logisticPercent; 
	} 

	public String getMemo(){ 
		return memo; 
	} 

	public void setMemo(String memo){ 
		if ( memo == null ) {
			memo = ""; 
		} 
		this.memo = memo; 
	} 

        /**
         * Getter for property details.
         * @return Value of property details.
         */
        public Vector getDetails() {
            return this.details;
        }
        
        /**
         * Setter for property details.
         * @param details New value of property details.
         */
        public void setDetails(Vector details) {
            this.details = details;
        }
        
        /**
         * Getter for property activityPeriodId.
         * @return Value of property activityPeriodId.
         */
        public long getActivityPeriodId() {
            return this.activityPeriodId;
        }
        
        /**
         * Setter for property activityPeriodId.
         * @param activityPeriodId New value of property activityPeriodId.
         */
        public void setActivityPeriodId(long activityPeriodId) {
            this.activityPeriodId = activityPeriodId;
        }
        
        /**
         * Getter for property coaExpenseCategory.
         * @return Value of property coaExpenseCategory.
         */
        public long getCoaExpenseCategoryId() {
            return this.coaExpenseCategoryId;
        }
        
        /**
         * Setter for property coaExpenseCategory.
         * @param coaExpenseCategory New value of property coaExpenseCategory.
         */
        public void setCoaExpenseCategoryId(long coaExpenseCategoryId) {
            this.coaExpenseCategoryId = coaExpenseCategoryId;
        }
        
        /**
         * Getter for property coaNatureExpenseCategoryId.
         * @return Value of property coaNatureExpenseCategoryId.
         */
        public long getCoaNatureExpenseCategoryId() {
            return this.coaNatureExpenseCategoryId;
        }
        
        /**
         * Setter for property coaNatureExpenseCategoryId.
         * @param coaNatureExpenseCategoryId New value of property coaNatureExpenseCategoryId.
         */
        public void setCoaNatureExpenseCategoryId(long coaNatureExpenseCategoryId) {
            this.coaNatureExpenseCategoryId = coaNatureExpenseCategoryId;
        }
        
}
