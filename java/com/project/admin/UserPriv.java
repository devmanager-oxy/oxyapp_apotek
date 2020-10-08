

package com.project.admin; 
 
import java.util.*;
import com.project.main.entity.*;

public class UserPriv extends Entity { 

	private int mn1;
	private int mn2;
	private int cmdAdd;
	private int cmdEdit;
	private int cmdView;
	private int cmdDelete;
	private long groupId;
	private long userId;
	
	private int cmdPrint;
	private int cmdPosting;
	
	public int getCmdPosting(){ 
		return cmdPosting; 
	} 

	public void setCmdPosting(int cmdPosting){ 
		this.cmdPosting = cmdPosting; 
	}
	
	public int getCmdPrint(){ 
		return cmdPrint; 
	} 

	public void setCmdPrint(int cmdPrint){ 
		this.cmdPrint = cmdPrint; 
	}

	public int getMn1(){ 
		return mn1; 
	} 

	public void setMn1(int mn1){ 
		this.mn1 = mn1; 
	} 

	public int getMn2(){ 
		return mn2; 
	} 

	public void setMn2(int mn2){ 
		this.mn2 = mn2; 
	} 

	public int getCmdAdd(){ 
		return cmdAdd; 
	} 

	public void setCmdAdd(int cmdAdd){ 
		this.cmdAdd = cmdAdd; 
	} 

	public int getCmdEdit(){ 
		return cmdEdit; 
	} 

	public void setCmdEdit(int cmdEdit){ 
		this.cmdEdit = cmdEdit; 
	} 

	public int getCmdView(){ 
		return cmdView; 
	} 

	public void setCmdView(int cmdView){ 
		this.cmdView = cmdView; 
	} 

	public int getCmdDelete(){ 
		return cmdDelete; 
	} 

	public void setCmdDelete(int cmdDelete){ 
		this.cmdDelete = cmdDelete; 
	} 

	public long getGroupId(){ 
		return groupId; 
	} 

	public void setGroupId(long groupId){ 
		this.groupId = groupId; 
	} 

	public long getUserId(){ 
		return userId; 
	} 

	public void setUserId(long userId){ 
		this.userId = userId; 
	} 

}
