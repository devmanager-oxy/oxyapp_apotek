
package com.project.datasync; 
 
import java.util.Date;
import com.project.main.entity.*;

public class BackupHistory extends Entity { 

	private Date date;
	private Date startDate;
	private Date endDate;
	private long operator;
	private int type;
	private String note = "";

        /**
         * Holds value of property companyId.
         */
        private long companyId;
        
	public Date getDate(){ 
		return date; 
	} 

	public void setDate(Date date){ 
		this.date = date; 
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

	public long getOperator(){ 
		return operator; 
	} 

	public void setOperator(long operator){ 
		this.operator = operator; 
	} 

	public int getType(){ 
		return type; 
	} 

	public void setType(int type){ 
		this.type = type; 
	} 

	public String getNote(){ 
		return note; 
	} 

	public void setNote(String note){ 
		if ( note == null ) {
			note = ""; 
		} 
		this.note = note; 
	} 

        /**
         * Getter for property companyId.
         * @return Value of property companyId.
         */
        public long getCompanyId() {
            return this.companyId;
        }
        
        /**
         * Setter for property companyId.
         * @param companyId New value of property companyId.
         */
        public void setCompanyId(long companyId) {
            this.companyId = companyId;
        }
        
}
