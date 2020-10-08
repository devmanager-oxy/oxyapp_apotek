
package com.project.ccs.postransaction.stock; 
 

import java.util.Date;
import com.project.main.entity.*;

public class StockPeriode extends Entity { 

	private Date startDate = new Date();
	private Date endDate = new Date();
	private String status = "";
	private String name = "";

    public Date getStartDate() {
        return startDate;
    }

    public void setStartDate(Date startDate) {
        this.startDate = startDate;
    }

    public Date getEndDate() {
        return endDate;
    }

    public void setEndDate(Date endDate) {
        this.endDate = endDate;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }
    
    
    
   
}
