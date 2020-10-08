package com.project.fms.transaction; 
 
/* package java */ 
import java.util.Date;
import com.project.main.entity.*;

public class TransactionActivityDetail extends Entity { 
	private long transactionId;
	private int isDirect;
	private long coaId;
	private int type;
	private long moduleId;
        /**
         * Holds value of property memo.
         */
        private String memo = "";
        
        /**
         * Holds value of property donorId.
         */
        private long donorId;
        
        /**
         * Holds value of property amount.
         */
        private double amount;
        
        /**
         * Holds value of property percent.
         */
        private double percent;
        
        /**
         * Holds value of property coaExpenseCategoryId.
         */
        private long coaExpenseCategoryId;
        
        /**
         * Holds value of property coaNatureExpenseCategoryId.
         */
        private long coaNatureExpenseCategoryId;
        
        /**
         * Holds value of property activityPeriodId.
         */
        private long activityPeriodId;
        
        /**
         * Holds value of property transDate.
         */
        private Date transDate;
        
	public long getTransactionId(){ 
		return transactionId; 
	} 

	public void setTransactionId(long transactionId){ 
		this.transactionId = transactionId; 
	} 

	public int getIsDirect(){
            return isDirect;
        } 

	public void setIsDirect(int isDirect){
            this.isDirect = isDirect;
        } 

	public long getCoaId(){ 
		return coaId; 
	} 

	public void setCoaId(long coaId){ 
		this.coaId = coaId; 
	} 

	public int getType(){ 
		return type; 
	} 

	public void setType(int type){ 
		this.type = type; 
	} 

	public long getModuleId(){ 
		return moduleId; 
	} 

	public void setModuleId(long moduleId){ 
		this.moduleId = moduleId; 
	} 

        /**
         * Getter for property memo.
         * @return Value of property memo.
         */
        public String getMemo() {
            return this.memo;
        }
        
        /**
         * Setter for property memo.
         * @param memo New value of property memo.
         */
        public void setMemo(String memo) {
            this.memo = memo;
        }
        
        /**
         * Getter for property donorId.
         * @return Value of property donorId.
         */
        public long getDonorId() {
            return this.donorId;
        }
        
        /**
         * Setter for property donorId.
         * @param donorId New value of property donorId.
         */
        public void setDonorId(long donorId) {
            this.donorId = donorId;
        }
        
        /**
         * Getter for property amount.
         * @return Value of property amount.
         */
        public double getAmount() {
            return this.amount;
        }
        
        /**
         * Setter for property amount.
         * @param amount New value of property amount.
         */
        public void setAmount(double amount) {
            this.amount = amount;
        }
        
        /**
         * Getter for property percent.
         * @return Value of property percent.
         */
        public double getPercent() {
            return this.percent;
        }
        
        /**
         * Setter for property percent.
         * @param percent New value of property percent.
         */
        public void setPercent(double percent) {
            this.percent = percent;
        }
        
        /**
         * Getter for property coaExpenseCategoryId.
         * @return Value of property coaExpenseCategoryId.
         */
        public long getCoaExpenseCategoryId() {
            return this.coaExpenseCategoryId;
        }
        
        /**
         * Setter for property coaExpenseCategoryId.
         * @param coaExpenseCategoryId New value of property coaExpenseCategoryId.
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
         * Getter for property transDate.
         * @return Value of property transDate.
         */
        public Date getTransDate() {
            return this.transDate;
        }
        
        /**
         * Setter for property transDate.
         * @param transDate New value of property transDate.
         */
        public void setTransDate(Date transDate) {
            this.transDate = transDate;
        }
        
}
