package com.project.fms.asset; 
 
import java.util.Date;
import com.project.main.entity.*;


public class AssetDataDepresiasi extends Entity { 

	private long assetDataId;
	private Date date;
	private long periodeId;
	private int mth;
	private int year;
	private double amount;
	private long userId;
	private String number = "";
	private String prefixNumber = "";
	private int counter;
	private long coaAkumDepId;
	private long coaExpenseDepId;
	private Date depreDate;

        /**
         * Holds value of property pengurang.
         */
        private double pengurang;
        
	public long getAssetDataId(){ 
		return assetDataId; 
	} 

	public void setAssetDataId(long assetDataId){ 
		this.assetDataId = assetDataId; 
	} 

	public Date getDate(){ 
		return date; 
	} 

	public void setDate(Date date){ 
		this.date = date; 
	} 

	public long getPeriodeId(){ 
		return periodeId; 
	} 

	public void setPeriodeId(long periodeId){ 
		this.periodeId = periodeId; 
	} 

	public int getMth(){ 
		return mth; 
	} 

	public void setMth(int mth){ 
		this.mth = mth; 
	} 

	public int getYear(){ 
		return year; 
	} 

	public void setYear(int year){ 
		this.year = year; 
	} 

	public double getAmount(){ 
		return amount; 
	} 

	public void setAmount(double amount){ 
		this.amount = amount; 
	} 

	public long getUserId(){ 
		return userId; 
	} 

	public void setUserId(long userId){ 
		this.userId = userId; 
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

	public String getPrefixNumber(){ 
		return prefixNumber; 
	} 

	public void setPrefixNumber(String prefixNumber){ 
		if ( prefixNumber == null ) {
			prefixNumber = ""; 
		} 
		this.prefixNumber = prefixNumber; 
	} 

	public int getCounter(){ 
		return counter; 
	} 

	public void setCounter(int counter){ 
		this.counter = counter; 
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

	public Date getDepreDate(){ 
		return depreDate; 
	} 

	public void setDepreDate(Date depreDate){ 
		this.depreDate = depreDate; 
	} 

        /**
         * Getter for property pengurang.
         * @return Value of property pengurang.
         */
        public double getPengurang() {
            return this.pengurang;
        }
        
        /**
         * Setter for property pengurang.
         * @param pengurang New value of property pengurang.
         */
        public void setPengurang(double pengurang) {
            this.pengurang = pengurang;
        }
        
}
