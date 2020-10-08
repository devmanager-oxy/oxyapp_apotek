package com.project.general; 
 
import java.util.Date;
import com.project.main.entity.*;

public class LogOperation extends Entity { 

	private Date date;
	private String logDesc = "";
	private long userId;
        private String userName = "";
        private long ownerId;

	public long getOwnerId(){ 
		return ownerId; 
	} 

	public void setOwnerId(long ownerId){ 
		this.ownerId = ownerId; 
	} 
        
        public String getUserName(){ 
		return userName; 
	} 

	public void setUserName(String userName){ 
		this.userName = userName; 
	} 
        
        public Date getDate(){ 
		return date; 
	} 

	public void setDate(Date date){ 
		this.date = date; 
	} 

	public String getLogDesc(){ 
		return logDesc; 
	} 

	public void setLogDesc(String logDesc){ 
		if ( logDesc == null ) {
			logDesc = ""; 
		} 
		this.logDesc = logDesc; 
	} 

	public long getUserId(){ 
		return userId; 
	} 

	public void setUserId(long userId){ 
		this.userId = userId; 
	} 

}
