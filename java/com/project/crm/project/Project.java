/***********************************\
|  Create by Dek-Ndut               |
|  Karya kami mohon jangan dibajak  |
|                                   |
|  9/29/2008 3:16:36 PM             |
\***********************************/

package com.project.crm.project;

import java.util.Date;
import com.project.main.entity.*;

public class Project extends Entity {

	private Date date = new Date();
	private String number = "";
	private String numberPrefix = "";
	private int counter = 0;
	private String name = "";
	private long customerId = 0;
	private String customerPic = "";
	private String customerPicPhone = "";
	private String customerAddress = "";
	private Date startDate = new Date();
	private Date endDate = new Date();
	private String customerPicPosition = "";
	private long employeeId = 0;
	private long userId = 0;
	private String employeeHp = "";
	private String description = "";
	private int status = 0;
	private double amount = 0;
	private long currencyId = 0;
	private long companyId = 0;
	private long categoryId = 0;
        
        private double discountPercent = 0;
        private double discountAmount = 0;
        private int vat = 0;
        private int discount;
        private int warrantyStatus;
        private Date warrantyDate;
        private String warrantyReceive = "";
        private int manualStatus = 0;
        private Date manualDate;
        private String manualReceive = "";
        private String noteClosing = "";
        private double bookingRate = 0;
        private double exchangeAmount = 0;
        private long proposalId;
        private long unitUsahaId;
        private double pphPercent;
        private double pphAmount;
        private int pphType;

	public Date getDate(){
		return date;
	}

	public void setDate(Date date){
		this.date = date;
	}

	public String getNumber(){
		return number;
	}

	public void setNumber(String number){
		if ( number == null) {
			number = "";
		}
		this.number = number;
	}

	public String getNumberPrefix(){
		return numberPrefix;
	}

	public void setNumberPrefix(String numberPrefix){
		if ( numberPrefix == null) {
			numberPrefix = "";
		}
		this.numberPrefix = numberPrefix;
	}

	public int getCounter(){
		return counter;
	}

	public void setCounter(int counter){
		this.counter = counter;
	}

	public String getName(){
		return name;
	}

	public void setName(String name){
		if ( name == null) {
			name = "";
		}
		this.name = name;
	}

	public long getCustomerId(){
		return customerId;
	}

	public void setCustomerId(long customerId){
		this.customerId = customerId;
	}

	public String getCustomerPic(){
		return customerPic;
	}

	public void setCustomerPic(String customerPic){
		if ( customerPic == null) {
			customerPic = "";
		}
		this.customerPic = customerPic;
	}

	public String getCustomerPicPhone(){
		return customerPicPhone;
	}

	public void setCustomerPicPhone(String customerPicPhone){
		if ( customerPicPhone == null) {
			customerPicPhone = "";
		}
		this.customerPicPhone = customerPicPhone;
	}

	public String getCustomerAddress(){
		return customerAddress;
	}

	public void setCustomerAddress(String customerAddress){
		if ( customerAddress == null) {
			customerAddress = "";
		}
		this.customerAddress = customerAddress;
	}

	public Date getStartDate(){
		return startDate;
	}

	public void setStartDate(Date startDate){
		this.startDate = startDate;
	}

	public Date getEndDate(){
		return endDate;
	}

	public void setEndDate(Date endDate){
		this.endDate = endDate;
	}

	public String getCustomerPicPosition(){
		return customerPicPosition;
	}

	public void setCustomerPicPosition(String customerPicPosition){
		if ( customerPicPosition == null) {
			customerPicPosition = "";
		}
		this.customerPicPosition = customerPicPosition;
	}

	public long getEmployeeId(){
		return employeeId;
	}

	public void setEmployeeId(long employeeId){
		this.employeeId = employeeId;
	}

	public long getUserId(){
		return userId;
	}

	public void setUserId(long userId){
		this.userId = userId;
	}

	public String getEmployeeHp(){
		return employeeHp;
	}

	public void setEmployeeHp(String employeeHp){
		if ( employeeHp == null) {
			employeeHp = "";
		}
		this.employeeHp = employeeHp;
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

	public int getStatus(){
		return status;
	}

	public void setStatus(int status){
		this.status = status;
	}

	public double getAmount(){
		return amount;
	}

	public void setAmount(double amount){
		this.amount = amount;
	}

	public long getCurrencyId(){
		return currencyId;
	}

	public void setCurrencyId(long currencyId){
		this.currencyId = currencyId;
	}

	public long getCompanyId(){
		return companyId;
	}

	public void setCompanyId(long companyId){
		this.companyId = companyId;
	}

	public long getCategoryId(){
		return categoryId;
	}

	public void setCategoryId(long categoryId){
		this.categoryId = categoryId;
	}

    public double getDiscountPercent() {
        return discountPercent;
    }

    public void setDiscountPercent(double discountPercent) {
        this.discountPercent = discountPercent;
    }

    public double getDiscountAmount() {
        return discountAmount;
    }

    public void setDiscountAmount(double discountAmount) {
        this.discountAmount = discountAmount;
    }

    public int getVat() {
        return vat;
    }

    public void setVat(int vat) {
        this.vat = vat;
    }

    public int getDiscount() {
        return discount;
    }

    public void setDiscount(int discount) {
        this.discount = discount;
    }

    public int getWarrantyStatus() {
        return warrantyStatus;
    }

    public void setWarrantyStatus(int warrantyStatus) {
        this.warrantyStatus = warrantyStatus;
    }

    public Date getWarrantyDate() {
        return warrantyDate;
    }

    public void setWarrantyDate(Date warrantyDate) {
        this.warrantyDate = warrantyDate;
    }

    public String getWarrantyReceive() {
        return warrantyReceive;
    }

    public void setWarrantyReceive(String warrantyReceive) {
        this.warrantyReceive = warrantyReceive;
    }

    public int getManualStatus() {
        return manualStatus;
    }

    public void setManualStatus(int manualStatus) {
        this.manualStatus = manualStatus;
    }

    public Date getManualDate() {
        return manualDate;
    }

    public void setManualDate(Date manualDate) {
        this.manualDate = manualDate;
    }

    public String getManualReceive() {
        return manualReceive;
    }

    public void setManualReceive(String manualReceive) {
        this.manualReceive = manualReceive;
    }

    public String getNoteClosing() {
        return noteClosing;
    }

    public void setNoteClosing(String noteClosing) {
        this.noteClosing = noteClosing;
    }

    public double getBookingRate() {
        return bookingRate;
    }

    public void setBookingRate(double bookingRate) {
        this.bookingRate = bookingRate;
    }

    public double getExchangeAmount() {
        return exchangeAmount;
    }

    public void setExchangeAmount(double exchangeAmount) {
        this.exchangeAmount = exchangeAmount;
    }

    public long getProposalId() {
        return proposalId;
    }

    public void setProposalId(long proposalId) {
        this.proposalId = proposalId;
    }

    public long getUnitUsahaId() {
        return unitUsahaId;
    }

    public void setUnitUsahaId(long unitUsahaId) {
        this.unitUsahaId = unitUsahaId;
    }

    public double getPphPercent() {
        return pphPercent;
    }

    public void setPphPercent(double pphPercent) {
        this.pphPercent = pphPercent;
    }

    public double getPphAmount() {
        return pphAmount;
    }

    public void setPphAmount(double pphAmount) {
        this.pphAmount = pphAmount;
    }

    public int getPphType() {
        return pphType;
    }

    public void setPphType(int pphType) {
        this.pphType = pphType;
    }
}
