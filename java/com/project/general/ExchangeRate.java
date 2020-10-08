

package com.project.general; 
 
/* package java */ 
import java.util.Date;

/* package qdep */
import com.project.main.entity.*;

public class ExchangeRate extends Entity { 

	private Date date = new Date();
	private double valueUsd = 0;
	private int status = 0;
	private long userId = 0;

        /**
         * Holds value of property time.
         */
        private Date time = new Date();
        
        /**
         * Holds value of property valueIdr.
         */
        private double valueIdr = 0;
        
        /**
         * Holds value of property valueEuro.
         */
        private double valueEuro = 0;
        
        /**
         * Holds value of property currencyIdrId.
         */
        private long currencyIdrId;
        
        /**
         * Holds value of property currencyUsdId.
         */
        private long currencyUsdId;
        
        /**
         * Holds value of property currencyEuroId.
         */
        private long currencyEuroId;
        
        private double valueYen = 0;        
        
        private long currencyYenId;
        
        private double valueAsd = 0;        
        
        private long currencyAsdId;
        
        
	public Date getDate(){ 
		return date; 
	} 

	public void setDate(Date date){ 
		this.date = date; 
	} 

	public double getValueUsd(){
            return valueUsd;
        } 

	public void setValueUsd(double valueUsd){
            this.valueUsd = valueUsd;
        } 

	public int getStatus(){ 
		return status; 
	} 

	public void setStatus(int status){ 
		this.status = status; 
	} 

	public long getUserId(){ 
		return userId; 
	} 

	public void setUserId(long userId){ 
		this.userId = userId; 
	} 

        /**
         * Getter for property time.
         * @return Value of property time.
         */
        public Date getTime() {
            return this.time;
        }
        
        /**
         * Setter for property time.
         * @param time New value of property time.
         */
        public void setTime(Date time) {
            this.time = time;
        }
        
        /**
         * Getter for property valueIdr.
         * @return Value of property valueIdr.
         */
        public double getValueIdr() {
            return this.valueIdr;
        }
        
        /**
         * Setter for property valueIdr.
         * @param valueIdr New value of property valueIdr.
         */
        public void setValueIdr(double valueIdr) {
            this.valueIdr = valueIdr;
        }
        
        /**
         * Getter for property valueEuro.
         * @return Value of property valueEuro.
         */
        public double getValueEuro() {
            return this.valueEuro;
        }
        
        /**
         * Setter for property valueEuro.
         * @param valueEuro New value of property valueEuro.
         */
        public void setValueEuro(double valueEuro) {
            this.valueEuro = valueEuro;
        }
        
        /**
         * Getter for property currencyIdrId.
         * @return Value of property currencyIdrId.
         */
        public long getCurrencyIdrId() {
            return this.currencyIdrId;
        }
        
        /**
         * Setter for property currencyIdrId.
         * @param currencyIdrId New value of property currencyIdrId.
         */
        public void setCurrencyIdrId(long currencyIdrId) {
            this.currencyIdrId = currencyIdrId;
        }
        
        /**
         * Getter for property currencyUsdId.
         * @return Value of property currencyUsdId.
         */
        public long getCurrencyUsdId() {
            return this.currencyUsdId;
        }
        
        /**
         * Setter for property currencyUsdId.
         * @param currencyUsdId New value of property currencyUsdId.
         */
        public void setCurrencyUsdId(long currencyUsdId) {
            this.currencyUsdId = currencyUsdId;
        }
        
        /**
         * Getter for property currencyEuroId.
         * @return Value of property currencyEuroId.
         */
        public long getCurrencyEuroId() {
            return this.currencyEuroId;
        }
        
        /**
         * Setter for property currencyEuroId.
         * @param currencyEuroId New value of property currencyEuroId.
         */
        public void setCurrencyEuroId(long currencyEuroId) {
            this.currencyEuroId = currencyEuroId;
        }

    public double getValueYen() {
        return valueYen;
    }

    public void setValueYen(double valueYen) {
        this.valueYen = valueYen;
    }

    public long getCurrencyYenId() {
        return currencyYenId;
    }

    public void setCurrencyYenId(long currencyYenId) {
        this.currencyYenId = currencyYenId;
    }

    public double getValueAsd() {
        return valueAsd;
    }

    public void setValueAsd(double valueAsd) {
        this.valueAsd = valueAsd;
    }

    public long getCurrencyAsdId() {
        return currencyAsdId;
    }

    public void setCurrencyAsdId(long currencyAsdId) {
        this.currencyAsdId = currencyAsdId;
    }
        
}
