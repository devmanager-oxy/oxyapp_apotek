
package com.project.ccs.posmaster; 
 
import java.util.Date;
import com.project.main.entity.*;

public class ItemCategory extends Entity { 

	private long itemGroupId;
	private String name = "";
	private int priority;
	private String accountCode = "";

        /**
         * Holds value of property code.
         */
        private String code;
        
        /**
         * Holds value of property groupCode.
         */
        private String groupCode;
        
        /**
         * Holds value of property groupType.
         */
        private int groupType;
        
	public long getItemGroupId(){ 
		return itemGroupId; 
	} 

	public void setItemGroupId(long itemGroupId){ 
		this.itemGroupId = itemGroupId; 
	} 

	public String getName(){ 
		return name; 
	} 

	public void setName(String name){ 
		if ( name == null ) {
			name = ""; 
		} 
		this.name = name; 
	} 

	public int getPriority(){ 
		return priority; 
	} 

	public void setPriority(int priority){ 
		this.priority = priority; 
	} 

	public String getAccountCode(){ 
		return accountCode; 
	} 

	public void setAccountCode(String accountCode){ 
		if ( accountCode == null ) {
			accountCode = ""; 
		} 
		this.accountCode = accountCode; 
	} 

        /**
         * Getter for property code.
         * @return Value of property code.
         */
        public String getCode() {
            return this.code;
        }
        
        /**
         * Setter for property code.
         * @param code New value of property code.
         */
        public void setCode(String code) {
            this.code = code;
        }
        
        /**
         * Getter for property groupCode.
         * @return Value of property groupCode.
         */
        public String getGroupCode() {
            return this.groupCode;
        }
        
        /**
         * Setter for property groupCode.
         * @param groupCode New value of property groupCode.
         */
        public void setGroupCode(String groupCode) {
            this.groupCode = groupCode;
        }
        
        /**
         * Getter for property groupType.
         * @return Value of property groupType.
         */
        public int getGroupType() {
            return this.groupType;
        }
        
        /**
         * Setter for property groupType.
         * @param groupType New value of property groupType.
         */
        public void setGroupType(int groupType) {
            this.groupType = groupType;
        }
        
}
