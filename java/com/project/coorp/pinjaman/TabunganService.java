package com.project.coorp.pinjaman; 
 
import java.util.Date;
import com.project.main.entity.*;

public class TabunganService extends Entity { 

	private Date proceedDate;

	public Date getProceedDate(){ 
		return proceedDate; 
	} 

	public void setProceedDate(Date proceedDate){ 
		this.proceedDate = proceedDate; 
	} 

}
