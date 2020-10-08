
package com.project.fms.ar;
 
/* package java */ 
import java.util.Date;
import com.project.main.entity.*;

public class ArapMemo extends Entity { 

	private Date date;
	private Date postedDate;
	private long userId;
	private long postedById;
	private String memo = "";
	private double amount;
	private int status;
	private int postedStatus;
	private int paymentStatus;
	private int type;
	private long refId;  //untuk menampung invoice id
	private long coaId;  //coa other revenue
        private long vendorId;        
        private int counter;        
        private String number = "";        
        private String prefixNumber = ""; 
        private long periodeId;
        private long approval1;
        private long approval2;
        private Date dateApp1;
        private Date dateApp2;
        private long currencyId;
        private long locationId;
        private long coaApId;

	public Date getDate(){ 
		return date; 
	} 

	public void setDate(Date date){ 
		this.date = date; 
	} 

	public Date getPostedDate(){ 
		return postedDate; 
	} 

	public void setPostedDate(Date postedDate){ 
		this.postedDate = postedDate; 
	} 

	public long getUserId(){ 
		return userId; 
	} 

	public void setUserId(long userId){ 
		this.userId = userId; 
	} 

	public long getPostedById(){ 
		return postedById; 
	} 

	public void setPostedById(long postedById){ 
		this.postedById = postedById; 
	} 

	public String getMemo(){ 
		return memo; 
	} 

	public void setMemo(String memo){ 
		if ( memo == null ) {
			memo = ""; 
		} 
		this.memo = memo; 
	} 

	public double getAmount(){ 
		return amount; 
	} 

	public void setAmount(double amount){ 
		this.amount = amount; 
	} 

	public int getStatus(){ 
		return status; 
	} 

	public void setStatus(int status){ 
		this.status = status; 
	} 

	public int getPostedStatus(){ 
		return postedStatus; 
	} 

	public void setPostedStatus(int postedStatus){ 
		this.postedStatus = postedStatus; 
	} 

	public int getPaymentStatus(){ 
		return paymentStatus; 
	} 

	public void setPaymentStatus(int paymentStatus){ 
		this.paymentStatus = paymentStatus; 
	} 

	public int getType(){ 
		return type; 
	} 

	public void setType(int type){ 
		this.type = type; 
	} 

	public long getRefId(){ 
		return refId; 
	} 

	public void setRefId(long refId){ 
		this.refId = refId; 
	} 

	public long getCoaId(){ 
		return coaId; 
	} 

	public void setCoaId(long coaId){ 
		this.coaId = coaId; 
	}

    public long getVendorId() {
        return vendorId;
    }

    public void setVendorId(long vendorId) {
        this.vendorId = vendorId;
    }

    public int getCounter() {
        return counter;
    }

    public void setCounter(int counter) {
        this.counter = counter;
    }

    public String getNumber() {
        return number;
    }

    public void setNumber(String number) {
        this.number = number;
    }

    public String getPrefixNumber() {
        return prefixNumber;
    }

    public void setPrefixNumber(String prefixNumber) {
        this.prefixNumber = prefixNumber;
    }

    public long getPeriodeId() {
        return periodeId;
    }

    public void setPeriodeId(long periodeId) {
        this.periodeId = periodeId;
    }

    public long getApproval1() {
        return approval1;
    }

    public void setApproval1(long approval1) {
        this.approval1 = approval1;
    }

    public long getApproval2() {
        return approval2;
    }

    public void setApproval2(long approval2) {
        this.approval2 = approval2;
    }

    public Date getDateApp1() {
        return dateApp1;
    }

    public void setDateApp1(Date dateApp1) {
        this.dateApp1 = dateApp1;
    }

    public Date getDateApp2() {
        return dateApp2;
    }

    public void setDateApp2(Date dateApp2) {
        this.dateApp2 = dateApp2;
    }

    public long getCurrencyId() {
        return currencyId;
    }

    public void setCurrencyId(long currencyId) {
        this.currencyId = currencyId;
    }

    public long getLocationId() {
        return locationId;
    }

    public void setLocationId(long locationId) {
        this.locationId = locationId;
    }

    public long getCoaApId() {
        return coaApId;
    }

    public void setCoaApId(long coaApId) {
        this.coaApId = coaApId;
    }

}
