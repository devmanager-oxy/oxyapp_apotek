package com.project.fms.master; 
 
import java.util.Date;
import com.project.main.entity.*;

public class CoaPortofolioSetup extends Entity { 

	private String note = "";
	private long periodeId;
	private long coaRevenueId;
	private long coaExpenseId;
	private int level;
	private long coaRefId;
	private int status;
	private String coaStatus = "";

        /**
         * Holds value of property targetLaba.
         */
        private double targetLaba;
        
        /**
         * Holds value of property realSdPdpt.
         */
        private double realSdPdpt;
        
        /**
         * Holds value of property realSdBiaya.
         */
        private double realSdBiaya;
        
        /**
         * Holds value of property realSdPercent.
         */
        private double realSdPercent;
        
        /**
         * Holds value of property realPdpt.
         */
        private double realPdpt;
        
        /**
         * Holds value of property realBiaya.
         */
        private double realBiaya;
        
        /**
         * Holds value of property realPercent.
         */
        private double realPercent;
        
        /**
         * Holds value of property coaCode.
         */
        private String coaCode;
        
        /**
         * Holds value of property type.
         */
        private int type;
        
	public String getNote(){ 
		return note; 
	} 

	public void setNote(String note){ 
		if ( note == null ) {
			note = ""; 
		} 
		this.note = note; 
	} 

	public long getPeriodeId(){ 
		return periodeId; 
	} 

	public void setPeriodeId(long periodeId){ 
		this.periodeId = periodeId; 
	} 

	public long getCoaRevenueId(){ 
		return coaRevenueId; 
	} 

	public void setCoaRevenueId(long coaRevenueId){ 
		this.coaRevenueId = coaRevenueId; 
	} 

	public long getCoaExpenseId(){ 
		return coaExpenseId; 
	} 

	public void setCoaExpenseId(long coaExpenseId){ 
		this.coaExpenseId = coaExpenseId; 
	} 

	public int getLevel(){ 
		return level; 
	} 

	public void setLevel(int level){ 
		this.level = level; 
	} 

	public long getCoaRefId(){ 
		return coaRefId; 
	} 

	public void setCoaRefId(long coaRefId){ 
		this.coaRefId = coaRefId; 
	} 

	public int getStatus(){ 
		return status; 
	} 

	public void setStatus(int status){ 
		this.status = status; 
	} 

	public String getCoaStatus(){ 
		return coaStatus; 
	} 

	public void setCoaStatus(String coaStatus){ 
		if ( coaStatus == null ) {
			coaStatus = ""; 
		} 
		this.coaStatus = coaStatus; 
	} 

        /**
         * Getter for property targetLaba.
         * @return Value of property targetLaba.
         */
        public double getTargetLaba() {
            return this.targetLaba;
        }
        
        /**
         * Setter for property targetLaba.
         * @param targetLaba New value of property targetLaba.
         */
        public void setTargetLaba(double targetLaba) {
            this.targetLaba = targetLaba;
        }
        
        /**
         * Getter for property realSdPdpt.
         * @return Value of property realSdPdpt.
         */
        public double getRealSdPdpt() {
            return this.realSdPdpt;
        }
        
        /**
         * Setter for property realSdPdpt.
         * @param realSdPdpt New value of property realSdPdpt.
         */
        public void setRealSdPdpt(double realSdPdpt) {
            this.realSdPdpt = realSdPdpt;
        }
        
        /**
         * Getter for property realSdBiaya.
         * @return Value of property realSdBiaya.
         */
        public double getRealSdBiaya() {
            return this.realSdBiaya;
        }
        
        /**
         * Setter for property realSdBiaya.
         * @param realSdBiaya New value of property realSdBiaya.
         */
        public void setRealSdBiaya(double realSdBiaya) {
            this.realSdBiaya = realSdBiaya;
        }
        
        /**
         * Getter for property realSdPercent.
         * @return Value of property realSdPercent.
         */
        public double getRealSdPercent() {
            return this.realSdPercent;
        }
        
        /**
         * Setter for property realSdPercent.
         * @param realSdPercent New value of property realSdPercent.
         */
        public void setRealSdPercent(double realSdPercent) {
            this.realSdPercent = realSdPercent;
        }
        
        /**
         * Getter for property realPdpt.
         * @return Value of property realPdpt.
         */
        public double getRealPdpt() {
            return this.realPdpt;
        }
        
        /**
         * Setter for property realPdpt.
         * @param realPdpt New value of property realPdpt.
         */
        public void setRealPdpt(double realPdpt) {
            this.realPdpt = realPdpt;
        }
        
        /**
         * Getter for property realBiaya.
         * @return Value of property realBiaya.
         */
        public double getRealBiaya() {
            return this.realBiaya;
        }
        
        /**
         * Setter for property realBiaya.
         * @param realBiaya New value of property realBiaya.
         */
        public void setRealBiaya(double realBiaya) {
            this.realBiaya = realBiaya;
        }
        
        /**
         * Getter for property realPercent.
         * @return Value of property realPercent.
         */
        public double getRealPercent() {
            return this.realPercent;
        }
        
        /**
         * Setter for property realPercent.
         * @param realPercent New value of property realPercent.
         */
        public void setRealPercent(double realPercent) {
            this.realPercent = realPercent;
        }
        
        /**
         * Getter for property coaCode.
         * @return Value of property coaCode.
         */
        public String getCoaCode() {
            return this.coaCode;
        }
        
        /**
         * Setter for property coaCode.
         * @param coaCode New value of property coaCode.
         */
        public void setCoaCode(String coaCode) {
            this.coaCode = coaCode;
        }
        
        /**
         * Getter for property type.
         * @return Value of property type.
         */
        public int getType() {
            return this.type;
        }
        
        /**
         * Setter for property type.
         * @param type New value of property type.
         */
        public void setType(int type) {
            this.type = type;
        }
        
}
