
package com.project.payroll; 
 
import java.util.Date;
import com.project.main.entity.*;

public class Department extends Entity { 

	private String name = "";
	private String description = "";

        /**
         * Holds value of property code.
         */
        private String code = "";
        
        /**
         * Holds value of property refId.
         */
        private long refId = 0;
        
        /**
         * Holds value of property level.
         */
        private int level = 0;
        
        /**
         * Holds value of property type.
         */
        private String type;
        
	public String getName(){ 
		return name; 
	} 

	public void setName(String name){ 
		if ( name == null ) {
			name = ""; 
		} 
		this.name = name; 
	} 

	public String getDescription(){ 
		return description; 
	} 

	public void setDescription(String description){ 
		if ( description == null ) {
			description = ""; 
		} 
		this.description = description; 
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
         * Getter for property refId.
         * @return Value of property refId.
         */
        public long getRefId() {
            return this.refId;
        }
        
        /**
         * Setter for property refId.
         * @param refId New value of property refId.
         */
        public void setRefId(long refId) {
            this.refId = refId;
        }
        
        /**
         * Getter for property level.
         * @return Value of property level.
         */
        public int getLevel() {
            return this.level;
        }
        
        /**
         * Setter for property level.
         * @param level New value of property level.
         */
        public void setLevel(int level) {
            this.level = level;
        }
        
        /**
         * Getter for property type.
         * @return Value of property type.
         */
        public String getType() {
            return this.type;
        }
        
        /**
         * Setter for property type.
         * @param type New value of property type.
         */
        public void setType(String type) {
            this.type = type;
        }
        
}
