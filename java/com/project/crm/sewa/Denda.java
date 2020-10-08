/* Created on 	:  [date] [time] AM/PM 
 * 
 * @author	 : Eka Ds
 * @version	 : 1.0
 */

package com.project.crm.sewa; 
 
import java.util.Date;
import com.project.main.entity.*;

public class Denda extends Entity { 

	private long sewaTanahId;
	private long limbahTransaksiId;
	private long irigasiTransaksiId;
	private Date tanggal;
	private long assesmentId;
	private long currencyId;
	private double jumlah;
	private String status = "";
	private long createdById;
	private Date createdDate;
	private long postedById;
	private Date postedDate;
	private int counter;
	private String prefixNumber = "";
	private String number = "";
	private String keterangan = "";
	private String noFp = "";
	private long sewaTanahInvoiceId;
	
	private long investorId;
	private long saranaId;
	private int type;

	public int getType(){ 
		return type; 
	} 

	public void setType(int type){ 
		this.type = type; 
	}
	
	public long getSaranaId(){ 
		return saranaId; 
	} 

	public void setSaranaId(long saranaId){ 
		this.saranaId = saranaId; 
	}
	
	public long getInvestorId(){ 
		return investorId; 
	} 

	public void setInvestorId(long investorId){ 
		this.investorId = investorId; 
	}

	public long getSewaTanahId(){ 
		return sewaTanahId; 
	} 

	public void setSewaTanahId(long sewaTanahId){ 
		this.sewaTanahId = sewaTanahId; 
	} 
		
	public long getSewaTanahInvoiceId(){ 
		return sewaTanahInvoiceId; 
	} 

	public void setSewaTanahInvoiceId(long sewaTanahInvoiceId){ 
		this.sewaTanahInvoiceId = sewaTanahInvoiceId; 
	} 	

	public long getLimbahTransaksiId(){ 
		return limbahTransaksiId; 
	} 

	public void setLimbahTransaksiId(long limbahTransaksiId){ 
		this.limbahTransaksiId = limbahTransaksiId; 
	} 

	public long getIrigasiTransaksiId(){ 
		return irigasiTransaksiId; 
	} 

	public void setIrigasiTransaksiId(long irigasiTransaksiId){ 
		this.irigasiTransaksiId = irigasiTransaksiId; 
	} 

	public Date getTanggal(){ 
		return tanggal; 
	} 

	public void setTanggal(Date tanggal){ 
		this.tanggal = tanggal; 
	} 

	public long getAssesmentId(){ 
		return assesmentId; 
	} 

	public void setAssesmentId(long assesmentId){ 
		this.assesmentId = assesmentId; 
	} 

	public long getCurrencyId(){ 
		return currencyId; 
	} 

	public void setCurrencyId(long currencyId){ 
		this.currencyId = currencyId; 
	} 

	public double getJumlah(){ 
		return jumlah; 
	} 

	public void setJumlah(double jumlah){ 
		this.jumlah = jumlah; 
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

	public long getCreatedById(){ 
		return createdById; 
	} 

	public void setCreatedById(long createdById){ 
		this.createdById = createdById; 
	} 

	public Date getCreatedDate(){ 
		return createdDate; 
	} 

	public void setCreatedDate(Date createdDate){ 
		this.createdDate = createdDate; 
	} 

	public long getPostedById(){ 
		return postedById; 
	} 

	public void setPostedById(long postedById){ 
		this.postedById = postedById; 
	} 

	public Date getPostedDate(){ 
		return postedDate; 
	} 

	public void setPostedDate(Date postedDate){ 
		this.postedDate = postedDate; 
	} 

	public int getCounter(){ 
		return counter; 
	} 

	public void setCounter(int counter){ 
		this.counter = counter; 
	} 

	public String getPrefixNumber(){ 
		return prefixNumber; 
	} 

	public void setPrefixNumber(String prefixNumber){ 
		if ( prefixNumber == null ) {
			prefixNumber = ""; 
		} 
		this.prefixNumber = prefixNumber; 
	} 

	public String getNumber(){ 
		return number; 
	} 

	public void setNumber(String number){ 
		if ( number == null ) {
			number = ""; 
		} 
		this.number = number; 
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

	public String getNoFp(){ 
		return noFp; 
	} 

	public void setNoFp(String noFp){ 
		if ( noFp == null ) {
			noFp = ""; 
		} 
		this.noFp = noFp; 
	} 

}
