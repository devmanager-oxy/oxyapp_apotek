package com.project.fms.master; 
 
import java.util.Date;
import com.project.main.entity.*;

public class UnitUsaha extends Entity { 

	private String code = "";
	private String name = "";
	private long coaArId;
	private long coaApId;
	private long coaPpnId;
	private long coaPphId;
	private long coaDiscountId;
	private long locationId;

	public String getCode(){ 
		return code; 
	} 

	public void setCode(String code){ 
		if ( code == null ) {
			code = ""; 
		} 
		this.code = code; 
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

	public long getCoaArId(){ 
		return coaArId; 
	} 

	public void setCoaArId(long coaArId){ 
		this.coaArId = coaArId; 
	} 

	public long getCoaApId(){ 
		return coaApId; 
	} 

	public void setCoaApId(long coaApId){ 
		this.coaApId = coaApId; 
	} 

	public long getCoaPpnId(){ 
		return coaPpnId; 
	} 

	public void setCoaPpnId(long coaPpnId){ 
		this.coaPpnId = coaPpnId; 
	} 

	public long getCoaPphId(){ 
		return coaPphId; 
	} 

	public void setCoaPphId(long coaPphId){ 
		this.coaPphId = coaPphId; 
	} 

	public long getCoaDiscountId(){ 
		return coaDiscountId; 
	} 

	public void setCoaDiscountId(long coaDiscountId){ 
		this.coaDiscountId = coaDiscountId; 
	} 

	public long getLocationId(){ 
		return locationId; 
	} 

	public void setLocationId(long locationId){ 
		this.locationId = locationId; 
	} 

}
