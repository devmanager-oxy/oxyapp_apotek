
/* Created on 	:  [date] [time] AM/PM 
 * 
 * @author	 : Eka Ds
 * @version	 : 1.0
 */

package com.project.crm.sewa; 
 
import java.util.Date;
import com.project.main.entity.*;

public class SewaTanahBenefitDetail extends Entity { 

	private long sewaTanahBenefitId;
	private long sewaTanahKomperId;
	private long currencyId;
	private double jumlah;
	private String keterangan = "";
	private int kategori;
	private double persenKomper;

	public double getPersenKomper(){ 
		return persenKomper; 
	} 

	public void setPersenKomper(double persenKomper){ 
		this.persenKomper = persenKomper; 
	}
	
	public int getKategori(){ 
		return kategori; 
	} 

	public void setKategori(int kategori){ 
		this.kategori = kategori; 
	}
	
	public long getSewaTanahBenefitId(){ 
		return sewaTanahBenefitId; 
	} 

	public void setSewaTanahBenefitId(long sewaTanahBenefitId){ 
		this.sewaTanahBenefitId = sewaTanahBenefitId; 
	} 

	public long getSewaTanahKomperId(){ 
		return sewaTanahKomperId; 
	} 

	public void setSewaTanahKomperId(long sewaTanahKomperId){ 
		this.sewaTanahKomperId = sewaTanahKomperId; 
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

	public String getKeterangan(){ 
		return keterangan; 
	} 

	public void setKeterangan(String keterangan){ 
		if ( keterangan == null ) {
			keterangan = ""; 
		} 
		this.keterangan = keterangan; 
	} 

}
