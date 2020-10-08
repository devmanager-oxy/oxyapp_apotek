
package com.project.ccs.postransaction.transfer; 
 
import java.util.Date;
import com.project.main.entity.*;

public class Transfer extends Entity { 

	private Date date;
	private String status = "";
	private long fromLocationId;
	private long toLocationId;
	private String note = "";
	private int counter;
	private String number = "";
	private long approval1;
	private long approval2;
	private long approval3;
	private long userId;
	private String prefixNumber = "";

        /**
         * Holds value of property approval1Date.
         */
        private Date approval1Date;
        
        /**
         * Holds value of property approval2Date.
         */
        private Date approval2Date;
        
        /**
         * Holds value of property approval3Date.
         */
        private Date approval3Date;
        private int type;
        
	public Date getDate(){ 
		return date; 
	} 

	public void setDate(Date date){ 
		this.date = date; 
	} 

	public String getStatus(){ 
		return status; 
	} 

	public void setStatus(String status){ 
		if ( status == null ) {
			status = ""; 
		} 
		this.status = status; 
	} 

	public long getFromLocationId(){ 
		return fromLocationId; 
	} 

	public void setFromLocationId(long fromLocationId){ 
		this.fromLocationId = fromLocationId; 
	} 

	public long getToLocationId(){ 
		return toLocationId; 
	} 

	public void setToLocationId(long toLocationId){ 
		this.toLocationId = toLocationId; 
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

	public int getCounter(){ 
		return counter; 
	} 

	public void setCounter(int counter){ 
		this.counter = counter; 
	} 

	public String getNumber(){ 
		return number; 
	} 

	public void setNumber(String number){ 
		if ( number == null ) {
			number = ""; 
		} 
		this.number = number; 
	} 

	public long getApproval1(){ 
		return approval1; 
	} 

	public void setApproval1(long approval1){ 
		this.approval1 = approval1; 
	} 

	public long getApproval2(){ 
		return approval2; 
	} 

	public void setApproval2(long approval2){ 
		this.approval2 = approval2; 
	} 

	public long getApproval3(){ 
		return approval3; 
	} 

	public void setApproval3(long approval3){ 
		this.approval3 = approval3; 
	} 

	public long getUserId(){ 
		return userId; 
	} 

	public void setUserId(long userId){ 
		this.userId = userId; 
	} 

	public String getPrefixNumber(){ 
		return prefixNumber; 
	} 

	public void setPrefixNumber(String prefixNumber){ 
		if ( prefixNumber == null ) {
			prefixNumber = ""; 
		} 
		this.prefixNumber = prefixNumber; 
	} 

        /**
         * Getter for property approval1Date.
         * @return Value of property approval1Date.
         */
        public Date getApproval1Date() {
            return this.approval1Date;
        }
        
        /**
         * Setter for property approval1Date.
         * @param approval1Date New value of property approval1Date.
         */
        public void setApproval1Date(Date approval1Date) {
            this.approval1Date = approval1Date;
        }
        
        /**
         * Getter for property approval2Date.
         * @return Value of property approval2Date.
         */
        public Date getApproval2Date() {
            return this.approval2Date;
        }
        
        /**
         * Setter for property approval2Date.
         * @param approval2Date New value of property approval2Date.
         */
        public void setApproval2Date(Date approval2Date) {
            this.approval2Date = approval2Date;
        }
        
        /**
         * Getter for property approval3Date.
         * @return Value of property approval3Date.
         */
        public Date getApproval3Date() {
            return this.approval3Date;
        }
        
        /**
         * Setter for property approval3Date.
         * @param approval3Date New value of property approval3Date.
         */
        public void setApproval3Date(Date approval3Date) {
            this.approval3Date = approval3Date;
        }

    public int getType() {
        return type;
    }

    public void setType(int type) {
        this.type = type;
    }
        
}
