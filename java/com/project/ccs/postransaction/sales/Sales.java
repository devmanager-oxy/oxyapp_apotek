package com.project.ccs.postransaction.sales;

import java.util.Date;
import com.project.main.entity.*;

public class Sales extends Entity {

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
    private double discountAmount = 0;
    private double discountPercent = 0;
    private int vat = 0;
    private int discount = 0;
    private int warrantyStatus = 0;
    private Date warrantyDate = new Date();
    private String warrantyReceive = "";
    private Date manualDate = new Date();
    private String manualReceive = "";
    private String noteClosing = "";
    private double bookingRate = 0;
    private double exchangeAmount = 0;
    /**
     * Holds value of property proposalId.
     */
    private long proposalId;
    /**
     * Holds value of property manualStatus.
     */
    private int manualStatus;
    /**
     * Holds value of property unitUsahaId.
     */
    private long unitUsahaId;
    /**
     * Holds value of property itemGroupId.
     */
    private long itemGroupId;
    /**
     * Holds value of property vatPercent.
     */
    private double vatPercent;
    /**
     * Holds value of property vatAmount.
     */
    private double vatAmount;
    /**
     * Holds value of property type.
     */
    private int type;
    /**
     * Holds value of property pphType.
     */
    private int pphType;
    /**
     * Holds value of property pphPercent.
     */
    private double pphPercent;
    /**
     * Holds value of property pphAmount.
     */
    private double pphAmount;
    private long marketingId;
    private int paymentStatus;
    private int salesType;
    private long location_id;
    private long cashCashierId;
    private long shift_id;
    private long cash_master_id;
    private int postedStatus;
    private long postedById;
    private Date postedDate;
    private Date effectiveDate;
    private int status_stock;
    private long salesReturId;
    private double servicePercent;
    private double serviceAmount;
    private long spgId;
    private double globalDiskon;
    private double globalDiskonPercent;
    private long sopirId;
    private long helperId;
    private double diskonKartu;
    private long tableId;
    private long waitressId;
    private int jumlahOrang;
    private double biayaKartu;
    private long systemDocNumberId = 0;

    public double getBiayaKartu() {
        return biayaKartu;
    }

    public void setBiayaKartu(double biayaKartu) {
        this.biayaKartu = biayaKartu;
    }

    public int getJumlahOrang() {
        return jumlahOrang;
    }

    public void setJumlahOrang(int jumlahOrang) {
        this.jumlahOrang = jumlahOrang;
    }

    public long getWaitressId() {
        return waitressId;
    }

    public void setWaitressId(long waitressId) {
        this.waitressId = waitressId;
    }

    public long getTableId() {
        return tableId;
    }

    public void setTableId(long tableId) {
        this.tableId = tableId;
    }

    public double getDiskonKartu() {
        return diskonKartu;
    }

    public void setDiskonKartu(double diskonKartu) {
        this.diskonKartu = diskonKartu;
    }

    public long getHelperId() {
        return helperId;
    }

    public void setHelperId(long helperId) {
        this.helperId = helperId;
    }

    public long getSopirId() {
        return sopirId;
    }

    public void setSopirId(long sopirId) {
        this.sopirId = sopirId;
    }

    public double getGlobalDiskonPercent() {
        return globalDiskonPercent;
    }

    public void setGlobalDiskonPercent(double globalDiskonPercent) {
        this.globalDiskonPercent = globalDiskonPercent;
    }

    public double getGlobalDiskon() {
        return globalDiskon;
    }

    public void setGlobalDiskon(double globalDiskon) {
        this.globalDiskon = globalDiskon;
    }

    public long getSpgId() {
        return spgId;
    }

    public void setSpgId(long spgId) {
        this.spgId = spgId;
    }

    public double getServiceAmount() {
        return serviceAmount;
    }

    public void setServiceAmount(double serviceAmount) {
        this.serviceAmount = serviceAmount;
    }

    public double getServicePercent() {
        return servicePercent;
    }

    public void setServicePercent(double servicePercent) {
        this.servicePercent = servicePercent;
    }

    public Date getDate() {
        return date;
    }

    public void setDate(Date date) {
        this.date = date;
    }

    public String getNumber() {
        return number;
    }

    public void setNumber(String number) {
        if (number == null) {
            number = "";
        }
        this.number = number;
    }

    public String getNumberPrefix() {
        return numberPrefix;
    }

    public void setNumberPrefix(String numberPrefix) {
        if (numberPrefix == null) {
            numberPrefix = "";
        }
        this.numberPrefix = numberPrefix;
    }

    public int getCounter() {
        return counter;
    }

    public void setCounter(int counter) {
        this.counter = counter;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        if (name == null) {
            name = "";
        }
        this.name = name;
    }

    public long getCustomerId() {
        return customerId;
    }

    public void setCustomerId(long customerId) {
        this.customerId = customerId;
    }

    public String getCustomerPic() {
        return customerPic;
    }

    public void setCustomerPic(String customerPic) {
        if (customerPic == null) {
            customerPic = "";
        }
        this.customerPic = customerPic;
    }

    public String getCustomerPicPhone() {
        return customerPicPhone;
    }

    public void setCustomerPicPhone(String customerPicPhone) {
        if (customerPicPhone == null) {
            customerPicPhone = "";
        }
        this.customerPicPhone = customerPicPhone;
    }

    public String getCustomerAddress() {
        return customerAddress;
    }

    public void setCustomerAddress(String customerAddress) {
        if (customerAddress == null) {
            customerAddress = "";
        }
        this.customerAddress = customerAddress;
    }

    public Date getStartDate() {
        return startDate;
    }

    public void setStartDate(Date startDate) {
        this.startDate = startDate;
    }

    public Date getEndDate() {
        return endDate;
    }

    public void setEndDate(Date endDate) {
        this.endDate = endDate;
    }

    public String getCustomerPicPosition() {
        return customerPicPosition;
    }

    public void setCustomerPicPosition(String customerPicPosition) {
        if (customerPicPosition == null) {
            customerPicPosition = "";
        }
        this.customerPicPosition = customerPicPosition;
    }

    public long getEmployeeId() {
        return employeeId;
    }

    public void setEmployeeId(long employeeId) {
        this.employeeId = employeeId;
    }

    public long getUserId() {
        return userId;
    }

    public void setUserId(long userId) {
        this.userId = userId;
    }

    public String getEmployeeHp() {
        return employeeHp;
    }

    public void setEmployeeHp(String employeeHp) {
        if (employeeHp == null) {
            employeeHp = "";
        }
        this.employeeHp = employeeHp;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        if (description == null) {
            description = "";
        }
        this.description = description;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    public double getAmount() {
        return amount;
    }

    public void setAmount(double amount) {
        this.amount = amount;
    }

    public long getCurrencyId() {
        return currencyId;
    }

    public void setCurrencyId(long currencyId) {
        this.currencyId = currencyId;
    }

    public long getCompanyId() {
        return companyId;
    }

    public void setCompanyId(long companyId) {
        this.companyId = companyId;
    }

    public long getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(long categoryId) {
        this.categoryId = categoryId;
    }

    public double getDiscountAmount() {
        return this.discountAmount;
    }

    public void setDiscountAmount(double discountAmount) {
        this.discountAmount = discountAmount;
    }

    public double getDiscountPercent() {
        return this.discountPercent;
    }

    public void setDiscountPercent(double discountPercent) {
        this.discountPercent = discountPercent;
    }

    public int getVat() {
        return this.vat;
    }

    public void setVat(int vat) {
        this.vat = vat;
    }

    public int getDiscount() {
        return this.discount;
    }

    public void setDiscount(int discount) {
        this.discount = discount;
    }

    public int getWarrantyStatus() {
        return this.warrantyStatus;
    }

    public void setWarrantyStatus(int warrantyStatus) {
        this.warrantyStatus = warrantyStatus;
    }

    public Date getWarrantyDate() {
        return this.warrantyDate;
    }

    public void setWarrantyDate(Date warrantyDate) {
        this.warrantyDate = warrantyDate;
    }

    public String getWarrantyReceive() {
        return this.warrantyReceive;
    }

    public void setWarrantyReceive(String warrantyReceive) {
        this.warrantyReceive = warrantyReceive;
    }

    public Date getManualDate() {
        return this.manualDate;
    }

    public void setManualDate(Date manualDate) {
        this.manualDate = manualDate;
    }

    public String getManualReceive() {
        return this.manualReceive;
    }

    public void setManualReceive(String manualReceive) {
        this.manualReceive = manualReceive;
    }

    public String getNoteClosing() {
        return this.noteClosing;
    }

    public void setNoteClosing(String noteClosing) {
        this.noteClosing = noteClosing;
    }

    public double getBookingRate() {
        return this.bookingRate;
    }

    public void setBookingRate(double bookingRate) {
        this.bookingRate = bookingRate;
    }

    public double getExchangeAmount() {
        return this.exchangeAmount;
    }

    public void setExchangeAmount(double exchangeAmount) {
        this.exchangeAmount = exchangeAmount;
    }

    /**
     * Getter for property proposalId.
     * @return Value of property proposalId.
     */
    public long getProposalId() {
        return this.proposalId;
    }

    /**
     * Setter for property proposalId.
     * @param proposalId New value of property proposalId.
     */
    public void setProposalId(long proposalId) {
        this.proposalId = proposalId;
    }

    /**
     * Getter for property manualStatus.
     * @return Value of property manualStatus.
     */
    public int getManualStatus() {
        return this.manualStatus;
    }

    /**
     * Setter for property manualStatus.
     * @param manualStatus New value of property manualStatus.
     */
    public void setManualStatus(int manualStatus) {
        this.manualStatus = manualStatus;
    }

    /**
     * Getter for property unitUsahaId.
     * @return Value of property unitUsahaId.
     */
    public long getUnitUsahaId() {
        return this.unitUsahaId;
    }

    /**
     * Setter for property unitUsahaId.
     * @param unitUsahaId New value of property unitUsahaId.
     */
    public void setUnitUsahaId(long unitUsahaId) {
        this.unitUsahaId = unitUsahaId;
    }

    /**
     * Getter for property itemGroupId.
     * @return Value of property itemGroupId.
     */
    public long getItemGroupId() {
        return this.itemGroupId;
    }

    /**
     * Setter for property itemGroupId.
     * @param itemGroupId New value of property itemGroupId.
     */
    public void setItemGroupId(long itemGroupId) {
        this.itemGroupId = itemGroupId;
    }

    /**
     * Getter for property vatPercent.
     * @return Value of property vatPercent.
     */
    public double getVatPercent() {
        return this.vatPercent;
    }

    /**
     * Setter for property vatPercent.
     * @param vatPercent New value of property vatPercent.
     */
    public void setVatPercent(double vatPercent) {
        this.vatPercent = vatPercent;
    }

    /**
     * Getter for property vatAmount.
     * @return Value of property vatAmount.
     */
    public double getVatAmount() {
        return this.vatAmount;
    }

    /**
     * Setter for property vatAmount.
     * @param vatAmount New value of property vatAmount.
     */
    public void setVatAmount(double vatAmount) {
        this.vatAmount = vatAmount;
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

    /**
     * Getter for property pphType.
     * @return Value of property pphType.
     */
    public int getPphType() {
        return this.pphType;
    }

    /**
     * Setter for property pphType.
     * @param pphType New value of property pphType.
     */
    public void setPphType(int pphType) {
        this.pphType = pphType;
    }

    /**
     * Getter for property pphPercentage.
     * @return Value of property pphPercentage.
     */
    public double getPphPercent() {
        return this.pphPercent;
    }

    /**
     * Setter for property pphPercentage.
     * @param pphPercentage New value of property pphPercentage.
     */
    public void setPphPercent(double pphPercent) {
        this.pphPercent = pphPercent;
    }

    /**
     * Getter for property pphAmount.
     * @return Value of property pphAmount.
     */
    public double getPphAmount() {
        return this.pphAmount;
    }

    /**
     * Setter for property pphAmount.
     * @param pphAmount New value of property pphAmount.
     */
    public void setPphAmount(double pphAmount) {
        this.pphAmount = pphAmount;
    }

    public int getSalesType() {
        return salesType;
    }

    public void setSalesType(int salesType) {
        this.salesType = salesType;
    }

    public long getMarketingId() {
        return marketingId;
    }

    public void setMarketingId(long marketingId) {
        this.marketingId = marketingId;
    }

    public long getLocation_id() {
        return location_id;
    }

    public void setLocation_id(long location_id) {
        this.location_id = location_id;
    }

    public int getPaymentStatus() {
        return paymentStatus;
    }

    public void setPaymentStatus(int paymentStatus) {
        this.paymentStatus = paymentStatus;
    }

    public long getCashCashierId() {
        return cashCashierId;
    }

    public void setCashCashierId(long cashCashierId) {
        this.cashCashierId = cashCashierId;
    }

    public long getShift_id() {
        return shift_id;
    }

    public void setShift_id(long shift_id) {
        this.shift_id = shift_id;
    }

    public long getCash_master_id() {
        return cash_master_id;
    }

    public void setCash_master_id(long cash_master_id) {
        this.cash_master_id = cash_master_id;
    }

    public int getPostedStatus() {
        return postedStatus;
    }

    public void setPostedStatus(int postedStatus) {
        this.postedStatus = postedStatus;
    }

    public long getPostedById() {
        return postedById;
    }

    public void setPostedById(long postedById) {
        this.postedById = postedById;
    }

    public Date getPostedDate() {
        return postedDate;
    }

    public void setPostedDate(Date postedDate) {
        this.postedDate = postedDate;
    }

    public Date getEffectiveDate() {
        return effectiveDate;
    }

    public void setEffectiveDate(Date effectiveDate) {
        this.effectiveDate = effectiveDate;
    }

    public int getStatus_stock() {
        return status_stock;
    }

    public void setStatus_stock(int status_stock) {
        this.status_stock = status_stock;
    }

    public long getSalesReturId() {
        return salesReturId;
    }

    public void setSalesReturId(long salesReturId) {
        this.salesReturId = salesReturId;
    }

    public long getSystemDocNumberId() {
        return systemDocNumberId;
    }

    public void setSystemDocNumberId(long systemDocNumberId) {
        this.systemDocNumberId = systemDocNumberId;
    }
}
