
package com.project.fms.asset; 
 
import java.util.Date;
import com.project.main.entity.*;

public class AssetData extends Entity { 

	private long itemGroupId;
	private long itemCategoryId;
	private long itemMasterId;
	private int type;
	private long locationId;
	private double depresiasiPercent;
	private double qty;
	private Date tglPerolehan;
	private double amountPerolehan;
	private int bulanMulaiDepresiasi;
	private int yearPerolehan;
	private double residu;
	private double yearlyDepresiasi;
	private double mthDepresiasi;
	private long coaAkumDepId;
	private long coaExpenseDepId;
	private long userId;
	private Date date;

        /**
         * Holds value of property totalDepreSebelum.
         */
        private double totalDepreSebelum;
        
        /**
         * Holds value of property tglDepreTerakhir.
         */
        private Date tglDepreTerakhir;
        
	public long getItemGroupId(){ 
		return itemGroupId; 
	} 

	public void setItemGroupId(long itemGroupId){ 
		this.itemGroupId = itemGroupId; 
	} 

	public long getItemCategoryId(){ 
		return itemCategoryId; 
	} 

	public void setItemCategoryId(long itemCategoryId){ 
		this.itemCategoryId = itemCategoryId; 
	} 

	public long getItemMasterId(){ 
		return itemMasterId; 
	} 

	public void setItemMasterId(long itemMasterId){ 
		this.itemMasterId = itemMasterId; 
	} 

	public int getType(){ 
		return type; 
	} 

	public void setType(int type){ 
		this.type = type; 
	} 

	public long getLocationId(){ 
		return locationId; 
	} 

	public void setLocationId(long locationId){ 
		this.locationId = locationId; 
	} 

	public double getDepresiasiPercent(){ 
		return depresiasiPercent; 
	} 

	public void setDepresiasiPercent(double depresiasiPercent){ 
		this.depresiasiPercent = depresiasiPercent; 
	} 

	public double getQty(){ 
		return qty; 
	} 

	public void setQty(double qty){ 
		this.qty = qty; 
	} 

	public Date getTglPerolehan(){ 
		return tglPerolehan; 
	} 

	public void setTglPerolehan(Date tglPerolehan){ 
		this.tglPerolehan = tglPerolehan; 
	} 

	public double getAmountPerolehan(){ 
		return amountPerolehan; 
	} 

	public void setAmountPerolehan(double amountPerolehan){ 
		this.amountPerolehan = amountPerolehan; 
	} 

	public int getBulanMulaiDepresiasi(){ 
		return bulanMulaiDepresiasi; 
	} 

	public void setBulanMulaiDepresiasi(int bulanMulaiDepresiasi){ 
		this.bulanMulaiDepresiasi = bulanMulaiDepresiasi; 
	} 

	public int getYearPerolehan(){ 
		return yearPerolehan; 
	} 

	public void setYearPerolehan(int yearPerolehan){ 
		this.yearPerolehan = yearPerolehan; 
	} 

	public double getResidu(){ 
		return residu; 
	} 

	public void setResidu(double residu){ 
		this.residu = residu; 
	} 

	public double getYearlyDepresiasi(){ 
		return yearlyDepresiasi; 
	} 

	public void setYearlyDepresiasi(double yearlyDepresiasi){ 
		this.yearlyDepresiasi = yearlyDepresiasi; 
	} 

	public double getMthDepresiasi(){ 
		return mthDepresiasi; 
	} 

	public void setMthDepresiasi(double mthDepresiasi){ 
		this.mthDepresiasi = mthDepresiasi; 
	} 

	public long getCoaAkumDepId(){ 
		return coaAkumDepId; 
	} 

	public void setCoaAkumDepId(long coaAkumDepId){ 
		this.coaAkumDepId = coaAkumDepId; 
	} 

	public long getCoaExpenseDepId(){ 
		return coaExpenseDepId; 
	} 

	public void setCoaExpenseDepId(long coaExpenseDepId){ 
		this.coaExpenseDepId = coaExpenseDepId; 
	} 

	public long getUserId(){ 
		return userId; 
	} 

	public void setUserId(long userId){ 
		this.userId = userId; 
	} 

	public Date getDate(){ 
		return date; 
	} 

	public void setDate(Date date){ 
		this.date = date; 
	} 

        /**
         * Getter for property totalDepreTerakhir.
         * @return Value of property totalDepreTerakhir.
         */
        public double getTotalDepreSebelum() {
            return this.totalDepreSebelum;
        }
        
        /**
         * Setter for property totalDepreTerakhir.
         * @param totalDepreTerakhir New value of property totalDepreTerakhir.
         */
        public void setTotalDepreSebelum(double totalDepreSebelum) {
            this.totalDepreSebelum = totalDepreSebelum;
        }
        
        /**
         * Getter for property tglDepreTerakhir.
         * @return Value of property tglDepreTerakhir.
         */
        public Date getTglDepreTerakhir() {
            return this.tglDepreTerakhir;
        }
        
        /**
         * Setter for property tglDepreTerakhir.
         * @param tglDepreTerakhir New value of property tglDepreTerakhir.
         */
        public void setTglDepreTerakhir(Date tglDepreTerakhir) {
            this.tglDepreTerakhir = tglDepreTerakhir;
        }
        
}
