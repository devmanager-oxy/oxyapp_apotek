/***********************************\
|  Create by Dek-Ndut               |
|                                   |
|  3/3/2008 11:30:57 AM
\***********************************/

package com.project.fms.session;

import java.util.Date;
import com.project.main.entity.*;
import java.util.*;


public class SesReportBs extends Entity {

	private String type = "";
	private String description = "";
	private double amount = 0;
	private String strAmount = "";
	private int font = 0;
	private String temp = "";

        private Vector department = new Vector();
        private Vector detail = new Vector();
        
        
        private Date transDate;
        private String journalNumber;
        private String memo;
        private double balance;
        private double amountPrevYear;
        private String strAmountPrevYear;
        private double amountMth;
        private String strAmountMth;
        private double amountBudget;
        private String strAmountBudget;
        private String code;
        private int level;
        
        
        /**
         * Holds value of property strBudgetYr.
         */
        private String strBudgetYr;
        
        /**
         * Holds value of property strBudgetSd.
         */
        private String strBudgetSd;
        
        /**
         * Holds value of property strBudgetLmth.
         */
        private String strBudgetLmth;
        
        /**
         * Holds value of property pencapaianSd.
         */
        private String pencapaianSd;
        
        /**
         * Holds value of property pencapaianIni.
         */
        private String pencapaianIni;
        
	public String getType(){
		return type;
	}

	public void setType(String type){
		if ( type == null) {
			type = "";
		}
		this.type = type;
	}

	public String getDescription(){
		return description;
	}

	public void setDescription(String description){
		if ( description == null) {
			description = "";
		}
		this.description = description;
	}

	public double getAmount(){
		return amount;
	}

	public void setAmount(double amount){
		this.amount = amount;
	}

	public String getStrAmount(){
		return strAmount;
	}

	public void setStrAmount(String strAmount){
		if ( strAmount == null) {
			strAmount = "";
		}
		this.strAmount = strAmount;
	}

	public int getFont(){
		return font;
	}

	public void setFont(int font){
		this.font = font;
	}

	public String getTemp(){
		return temp;
	}

	public void setTemp(String temp){
		if ( temp == null) {
			temp = "";
		}
		this.temp = temp;
	}
        
        public Vector getDetail() {
            return this.detail;
        }
        
        public void setDetail(Vector detail) {
            this.detail = detail;
        }
 
        public Vector getDepartment() {
            return this.department;
        }
        
        public void setDepartment(Vector department) {
            this.department = department;
        }

        /**
         * Getter for property transDate.
         * @return Value of property transDate.
         */
        public Date getTransDate() {
            return this.transDate;
        }
        
        /**
         * Setter for property transDate.
         * @param transDate New value of property transDate.
         *
         * @throws PropertyVetoException if some vetoable listeners reject the new value
         */
        public void setTransDate(Date transDate) throws java.beans.PropertyVetoException {
            this.transDate = transDate;
        }
        
        /**
         * Getter for property journalNumber.
         * @return Value of property journalNumber.
         */
        public String getJournalNumber() {
            return this.journalNumber;
        }
        
        /**
         * Setter for property journalNumber.
         * @param journalNumber New value of property journalNumber.
         */
        public void setJournalNumber(String journalNumber) {
            this.journalNumber = journalNumber;
        }
        
        /**
         * Getter for property memo.
         * @return Value of property memo.
         */
        public String getMemo() {
            return this.memo;
        }
        
        /**
         * Setter for property memo.
         * @param memo New value of property memo.
         */
        public void setMemo(String memo) {
            this.memo = memo;
        }
        
        /**
         * Getter for property balance.
         * @return Value of property balance.
         */
        public double getBalance() {
            return this.balance;
        }
        
        /**
         * Setter for property balance.
         * @param balance New value of property balance.
         */
        public void setBalance(double balance) {
            this.balance = balance;
        }
        
        /**
         * Getter for property amountPrevYear.
         * @return Value of property amountPrevYear.
         */
        public double getAmountPrevYear() {
            return this.amountPrevYear;
        }
        
        /**
         * Setter for property amountPrevYear.
         * @param amountPrevYear New value of property amountPrevYear.
         */
        public void setAmountPrevYear(double amountPrevYear) {
            this.amountPrevYear = amountPrevYear;
        }
        
        /**
         * Getter for property strAmountPrevYear.
         * @return Value of property strAmountPrevYear.
         */
        public String getStrAmountPrevYear() {
            return this.strAmountPrevYear;
        }
        
        /**
         * Setter for property strAmountPrevYear.
         * @param strAmountPrevYear New value of property strAmountPrevYear.
         */
        public void setStrAmountPrevYear(String strAmountPrevYear) {
            this.strAmountPrevYear = strAmountPrevYear;
        }
        
        /**
         * Getter for property amountMth.
         * @return Value of property amountMth.
         */
        public double getAmountMth() {
            return this.amountMth;
        }
        
        /**
         * Setter for property amountMth.
         * @param amountMth New value of property amountMth.
         */
        public void setAmountMth(double amountMth) {
            this.amountMth = amountMth;
        }
        
        /**
         * Getter for property strAmountMth.
         * @return Value of property strAmountMth.
         */
        public String getStrAmountMth() {
            return this.strAmountMth;
        }
        
        /**
         * Setter for property strAmountMth.
         * @param strAmountMth New value of property strAmountMth.
         */
        public void setStrAmountMth(String strAmountMth) {
            this.strAmountMth = strAmountMth;
        }
        
        /**
         * Getter for property amountBudget.
         * @return Value of property amountBudget.
         */
        public double getAmountBudget() {
            return this.amountBudget;
        }
        
        /**
         * Setter for property amountBudget.
         * @param amountBudget New value of property amountBudget.
         */
        public void setAmountBudget(double amountBudget) {
            this.amountBudget = amountBudget;
        }
        
        /**
         * Getter for property strAmountBudget.
         * @return Value of property strAmountBudget.
         */
        public String getStrAmountBudget() {
            return this.strAmountBudget;
        }
        
        /**
         * Setter for property strAmountBudget.
         * @param strAmountBudget New value of property strAmountBudget.
         */
        public void setStrAmountBudget(String strAmountBudget) {
            this.strAmountBudget = strAmountBudget;
        }
        
        /**
         * Getter for property code.
         * @return Value of property code.
         */
        public String getCode() {
            return this.code;
        }
        
        /**
         * Setter for property code.
         * @param code New value of property code.
         */
        public void setCode(String code) {
            this.code = code;
        }
        
        /**
         * Getter for property level.
         * @return Value of property level.
         */
        public int getLevel() {
            return this.level;
        }
        
        /**
         * Setter for property level.
         * @param level New value of property level.
         */
        public void setLevel(int level) {
            this.level = level;
        }
        
        /**
         * Getter for property strBudgetYr.
         * @return Value of property strBudgetYr.
         */
        public String getStrBudgetYr() {
            return this.strBudgetYr;
        }
        
        /**
         * Setter for property strBudgetYr.
         * @param strBudgetYr New value of property strBudgetYr.
         */
        public void setStrBudgetYr(String strBudgetYr) {
            this.strBudgetYr = strBudgetYr;
        }
        
        /**
         * Getter for property strBudgetSd.
         * @return Value of property strBudgetSd.
         */
        public String getStrBudgetSd() {
            return this.strBudgetSd;
        }
        
        /**
         * Setter for property strBudgetSd.
         * @param strBudgetSd New value of property strBudgetSd.
         */
        public void setStrBudgetSd(String strBudgetSd) {
            this.strBudgetSd = strBudgetSd;
        }
        
        /**
         * Getter for property strBudgetLmth.
         * @return Value of property strBudgetLmth.
         */
        public String getStrBudgetLmth() {
            return this.strBudgetLmth;
        }
        
        /**
         * Setter for property strBudgetLmth.
         * @param strBudgetLmth New value of property strBudgetLmth.
         */
        public void setStrBudgetLmth(String strBudgetLmth) {
            this.strBudgetLmth = strBudgetLmth;
        }
        
        /**
         * Getter for property pencapainSd.
         * @return Value of property pencapainSd.
         */
        public String getPencapaianSd() {
            return this.pencapaianSd;
        }
        
        /**
         * Setter for property pencapainSd.
         * @param pencapainSd New value of property pencapainSd.
         */
        public void setPencapaianSd(String pencapaianSd) {
            this.pencapaianSd = pencapaianSd;
        }
        
        /**
         * Getter for property pencapaianIni.
         * @return Value of property pencapaianIni.
         */
        public String getPencapaianIni() {
            return this.pencapaianIni;
        }
        
        /**
         * Setter for property pencapaianIni.
         * @param pencapaianIni New value of property pencapaianIni.
         */
        public void setPencapaianIni(String pencapaianIni) {
            this.pencapaianIni = pencapaianIni;
        }
        
}
