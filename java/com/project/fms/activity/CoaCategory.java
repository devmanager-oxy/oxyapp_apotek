
package com.project.fms.activity; 
 
import java.util.Date;
import com.project.main.entity.*;

public class CoaCategory extends Entity { 

	private String name = "";

        /**
         * Holds value of property companyId.
         */
        private long companyId;
        
        /**
         * Holds value of property userId.
         */
        private long userId;
        
        /**
         * Holds value of property type.
         */
        private int type;
        
	public String getName(){ 
		return name; 
	} 

	public void setName(String name){ 
		if ( name == null ) {
			name = ""; 
		} 
		this.name = name; 
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
        
        /**
         * Getter for property userId.
         * @return Value of property userId.
         */
        public long getUserId() {
            return this.userId;
        }
        
        /**
         * Setter for property userId.
         * @param userId New value of property userId.
         */
        public void setUserId(long userId) {
            this.userId = userId;
        }
        
        /**
         * Getter for property type.
         * @return Value of property type.
         */
        public int getType() {
            return this.type;
        }
        
        /**
         * Setter for property type.
         * @param type New value of property type.
         */
        public void setType(int type) {
            this.type = type;
        }
        
}
