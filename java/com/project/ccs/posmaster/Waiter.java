
package com.project.ccs.posmaster; 
 
import java.util.Date;
import com.project.main.entity.*;

public class Waiter extends Entity { 

	private String name = "";
	private String code = "";
	private String loginId = "";
	private String password = "";
	private String status = "";
	private int level;

        /**
         * Holds value of property confirmPwd.
         */
        private String confirmPwd;
        
        /**
         * Holds value of property locationId.
         */
        private long locationId;
        
	public String getName(){ 
		return name; 
	} 

	public void setName(String name){ 
		if ( name == null ) {
			name = ""; 
		} 
		this.name = name; 
	} 

	public String getCode(){ 
		return code; 
	} 

	public void setCode(String code){ 
		if ( code == null ) {
			code = ""; 
		} 
		this.code = code; 
	} 

	public String getLoginId(){ 
		return loginId; 
	} 

	public void setLoginId(String loginId){ 
		if ( loginId == null ) {
			loginId = ""; 
		} 
		this.loginId = loginId; 
	} 

	public String getPassword(){ 
		return password; 
	} 

	public void setPassword(String password){ 
		if ( password == null ) {
			password = ""; 
		} 
		this.password = password; 
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

	public int getLevel(){ 
		return level; 
	} 

	public void setLevel(int level){ 
		this.level = level; 
	} 

        /**
         * Getter for property confirmPwd.
         * @return Value of property confirmPwd.
         */
        public String getConfirmPwd() {
            return this.confirmPwd;
        }
        
        /**
         * Setter for property confirmPwd.
         * @param confirmPwd New value of property confirmPwd.
         */
        public void setConfirmPwd(String confirmPwd) {
            this.confirmPwd = confirmPwd;
        }
        
        /**
         * Getter for property locationId.
         * @return Value of property locationId.
         */
        public long getLocationId() {
            return this.locationId;
        }
        
        /**
         * Setter for property locationId.
         * @param locationId New value of property locationId.
         */
        public void setLocationId(long locationId) {
            this.locationId = locationId;
        }
        
}
