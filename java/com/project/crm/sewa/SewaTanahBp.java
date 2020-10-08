
/* Created on 	:  [date] [time] AM/PM 
 * 
 * @author	 : Eka Ds
 * @version	 : 1.0
 */

package com.project.crm.sewa; 
 
import java.util.Date;
import com.project.main.entity.*;

public class SewaTanahBp extends Entity { 

	private Date tanggal = new Date();
	private String keterangan = "";
	private String refnumber = "";
	private String mem = "";
	private double debet = 0;
	private double credit = 0;
	private long sewaTanahId = 0;
	private long sewaTanahInvId = 0;
        private long mataUangId;
        private long customerId;
        private long limbahTransactionId;
        private long irigasiTransactionId;
        
	public Date getTanggal(){ 
		return tanggal; 
	} 

	public void setTanggal(Date tanggal){ 
		this.tanggal = tanggal; 
	} 

	public String getKeterangan(){ 
		return keterangan; 
	} 

	public void setKeterangan(String keterangan){ 
		if ( keterangan == null ) {
			keterangan = ""; 
		} 
		this.keterangan = keterangan; 
	} 

	public String getRefnumber(){ 
		return refnumber; 
	} 

	public void setRefnumber(String refnumber){ 
		if ( refnumber == null ) {
			refnumber = ""; 
		} 
		this.refnumber = refnumber; 
	} 

	public String getMem(){ 
		return mem; 
	} 

	public void setMem(String mem){ 
		if ( mem == null ) {
			mem = ""; 
		} 
		this.mem = mem; 
	} 

	public double getDebet(){ 
		return debet; 
	} 

	public void setDebet(double debet){ 
		this.debet = debet; 
	} 

	public double getCredit(){ 
		return credit; 
	} 

	public void setCredit(double credit){ 
		this.credit = credit; 
	} 

	public long getSewaTanahId(){ 
		return sewaTanahId; 
	} 

	public void setSewaTanahId(long sewaTanahId){ 
		this.sewaTanahId = sewaTanahId; 
	} 

	public long getSewaTanahInvId(){ 
		return sewaTanahInvId; 
	} 

	public void setSewaTanahInvId(long sewaTanahInvId){ 
		this.sewaTanahInvId = sewaTanahInvId; 
	}

    public long getMataUangId() {
        return mataUangId;
    }

    public void setMataUangId(long mataUangId) {
        this.mataUangId = mataUangId;
    }

    public long getCustomerId() {
        return customerId;
    }

    public void setCustomerId(long customerId) {
        this.customerId = customerId;
    }

    public long getLimbahTransactionId() {
        return limbahTransactionId;
    }

    public void setLimbahTransactionId(long limbahTransactionId) {
        this.limbahTransactionId = limbahTransactionId;
    }

    public long getIrigasiTransactionId() {
        return irigasiTransactionId;
    }

    public void setIrigasiTransactionId(long irigasiTransactionId) {
        this.irigasiTransactionId = irigasiTransactionId;
    }

}
