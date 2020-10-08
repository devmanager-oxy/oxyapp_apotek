
/* Created on 	:  [date] [time] AM/PM 
 * 
 * @author	 : Eka Ds
 * @version	 : 1.0
 */

package com.project.crm.sewa; 
 
import java.util.Date;
import com.project.main.entity.*;

public class SewaTanahKomper extends Entity { 

	private int kategori;
	private double persentase;
	private long sewaTanahId;

	public int getKategori(){ 
		return kategori; 
	} 

	public void setKategori(int kategori){ 
		this.kategori = kategori; 
	} 

	public double getPersentase(){ 
		return persentase; 
	} 

	public void setPersentase(double persentase){ 
		this.persentase = persentase; 
	}

	
	public void setSewaTanahId(long sewaTanahId) {
		this.sewaTanahId = sewaTanahId; 
	}

	public long getSewaTanahId() {
		return (this.sewaTanahId); 
	} 

}
