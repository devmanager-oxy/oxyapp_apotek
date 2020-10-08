
package com.project.fms.activity; 
 
import java.util.Date;
import com.project.main.entity.*;

public class CoaActivity extends Entity { 

	private long coaId = 0;
	private long moduleId = 0;

        /**
         * Holds value of property departmentId.
         */
        private long departmentId;
        
        /**
         * Holds value of property sectionId.
         */
        private long sectionId;
        
	public long getCoaId(){ 
		return coaId; 
	} 

	public void setCoaId(long coaId){ 
		this.coaId = coaId; 
	} 

	public long getModuleId(){ 
		return moduleId; 
	} 

	public void setModuleId(long moduleId){ 
		this.moduleId = moduleId; 
	} 

        /**
         * Getter for property departmentId.
         * @return Value of property departmentId.
         */
        public long getDepartmentId() {
            return this.departmentId;
        }
        
        /**
         * Setter for property departmentId.
         * @param departmentId New value of property departmentId.
         */
        public void setDepartmentId(long departmentId) {
            this.departmentId = departmentId;
        }
        
        /**
         * Getter for property sectionId.
         * @return Value of property sectionId.
         */
        public long getSectionId() {
            return this.sectionId;
        }
        
        /**
         * Setter for property sectionId.
         * @param sectionId New value of property sectionId.
         */
        public void setSectionId(long sectionId) {
            this.sectionId = sectionId;
        }
        
}
