package com.project.general;

import java.util.Date;
import com.project.main.entity.Entity;

public class Company extends Entity {

    private String name = "";
    private String serialNumber = "";
    private String address = "";
    private int fiscalYear = 0;
    private int endFiscalMonth = 0;
    private int entryStartMonth = 0;
    private int numberOfPeriod = 0;
    private String cashReceiveCode = "";
    private String pettycashPaymentCode = "";
    private String pettycashReplaceCode = "";
    private String bankDepositCode = "";
    private String bankPaymentPoCode = "";
    private String bankPaymentNonpoCode = "";
    private String purchaseOrderCode = "";
    private String generalLedgerCode = "";
    private double maxPettycashReplenis = 0;
    private double maxPettycashTransaction = 0;
    private String bookingCurrencyCode = "";
    private long bookingCurrencyId = 0;
    private long systemLocation = 0;
    private String activationCode = "";
    private String systemLocationCode = "";
    private String contact = "";
    private String address2 = "";
    private String invoiceCode = "";
    private int departmentLevel = 0;
    private double governmentVat = 0;
    private String projectCode = "";
    private Date lastUpdate = new Date();
    private String paymentCode = "";
    private String installBudgetCode = "";
    private String installTravelCode = "";
    private String installSettlementCode = "";
    private int categoryLevel = 0;
    private String customerRequestCode = "";
    private String introLetterCode = "";
    private String proposalCode = "";
    private String phone = "";
    private String fax = "";
    private String email = "";
    private String website = "";
    private String purchaseRequestCode;
    private double defaultSalesMargin;
    private String returnGoodsCode;
    private String transferGoodsCode;
    private String costingGoodsCode;
    private String adjustmentCode;
    private String opnameCode;
    private int integratedHotelSystem;
    private int integratedFinanceSystem;
    private String shopOrderCode;
    private String pinjamanKoperasiCode;
    private String pinjamanBankCode;
    private String bayarAngsuranCode;
    private String bayarAngsuranBankCode;
    private String pinjamanKoperasiBankCode;
    private String bayarAngsuranKopBankCode;
    private String businessName = "";
    private String taxNumber = "";
    private int useBkp;
    private double TaxAmount;
    private int multiCurrency;
    private int multiBank;
    private int businessType = 0;

    public String getActivationCode() {
        return activationCode;
    }

    public void setActivationCode(String activationCode) {
        this.activationCode = activationCode;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getAddress2() {
        return address2;
    }

    public void setAddress2(String address2) {
        this.address2 = address2;
    }

    public String getAdjustmentCode() {
        return adjustmentCode;
    }

    public void setAdjustmentCode(String adjustmentCode) {
        this.adjustmentCode = adjustmentCode;
    }

    public String getBankDepositCode() {
        return bankDepositCode;
    }

    public void setBankDepositCode(String bankDepositCode) {
        this.bankDepositCode = bankDepositCode;
    }

    public String getBankPaymentNonpoCode() {
        return bankPaymentNonpoCode;
    }

    public void setBankPaymentNonpoCode(String bankPaymentNonpoCode) {
        this.bankPaymentNonpoCode = bankPaymentNonpoCode;
    }

    public String getBankPaymentPoCode() {
        return bankPaymentPoCode;
    }

    public void setBankPaymentPoCode(String bankPaymentPoCode) {
        this.bankPaymentPoCode = bankPaymentPoCode;
    }

    public String getBayarAngsuranBankCode() {
        return bayarAngsuranBankCode;
    }

    public void setBayarAngsuranBankCode(String bayarAngsuranBankCode) {
        this.bayarAngsuranBankCode = bayarAngsuranBankCode;
    }

    public String getBayarAngsuranCode() {
        return bayarAngsuranCode;
    }

    public void setBayarAngsuranCode(String bayarAngsuranCode) {
        this.bayarAngsuranCode = bayarAngsuranCode;
    }

    public String getBayarAngsuranKopBankCode() {
        return bayarAngsuranKopBankCode;
    }

    public void setBayarAngsuranKopBankCode(String bayarAngsuranKopBankCode) {
        this.bayarAngsuranKopBankCode = bayarAngsuranKopBankCode;
    }

    public String getBookingCurrencyCode() {
        return bookingCurrencyCode;
    }

    public void setBookingCurrencyCode(String bookingCurrencyCode) {
        this.bookingCurrencyCode = bookingCurrencyCode;
    }

    public long getBookingCurrencyId() {
        return bookingCurrencyId;
    }

    public void setBookingCurrencyId(long bookingCurrencyId) {
        this.bookingCurrencyId = bookingCurrencyId;
    }

    public String getBusinessName() {
        return businessName;
    }

    public void setBusinessName(String businessName) {
        this.businessName = businessName;
    }

    public String getCashReceiveCode() {
        return cashReceiveCode;
    }

    public void setCashReceiveCode(String cashReceiveCode) {
        this.cashReceiveCode = cashReceiveCode;
    }

    public int getCategoryLevel() {
        return categoryLevel;
    }

    public void setCategoryLevel(int categoryLevel) {
        this.categoryLevel = categoryLevel;
    }

    public String getContact() {
        return contact;
    }

    public void setContact(String contact) {
        this.contact = contact;
    }

    public String getCostingGoodsCode() {
        return costingGoodsCode;
    }

    public void setCostingGoodsCode(String costingGoodsCode) {
        this.costingGoodsCode = costingGoodsCode;
    }

    public String getCustomerRequestCode() {
        return customerRequestCode;
    }

    public void setCustomerRequestCode(String customerRequestCode) {
        this.customerRequestCode = customerRequestCode;
    }

    public double getDefaultSalesMargin() {
        return defaultSalesMargin;
    }

    public void setDefaultSalesMargin(double defaultSalesMargin) {
        this.defaultSalesMargin = defaultSalesMargin;
    }

    public int getDepartmentLevel() {
        return departmentLevel;
    }

    public void setDepartmentLevel(int departmentLevel) {
        this.departmentLevel = departmentLevel;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public int getEndFiscalMonth() {
        return endFiscalMonth;
    }

    public void setEndFiscalMonth(int endFiscalMonth) {
        this.endFiscalMonth = endFiscalMonth;
    }

    public int getEntryStartMonth() {
        return entryStartMonth;
    }

    public void setEntryStartMonth(int entryStartMonth) {
        this.entryStartMonth = entryStartMonth;
    }

    public String getFax() {
        return fax;
    }

    public void setFax(String fax) {
        this.fax = fax;
    }

    public int getFiscalYear() {
        return fiscalYear;
    }

    public void setFiscalYear(int fiscalYear) {
        this.fiscalYear = fiscalYear;
    }

    public String getGeneralLedgerCode() {
        return generalLedgerCode;
    }

    public void setGeneralLedgerCode(String generalLedgerCode) {
        this.generalLedgerCode = generalLedgerCode;
    }

    public double getGovernmentVat() {
        return governmentVat;
    }

    public void setGovernmentVat(double governmentVat) {
        this.governmentVat = governmentVat;
    }

    public String getInstallBudgetCode() {
        return installBudgetCode;
    }

    public void setInstallBudgetCode(String installBudgetCode) {
        this.installBudgetCode = installBudgetCode;
    }

    public String getInstallSettlementCode() {
        return installSettlementCode;
    }

    public void setInstallSettlementCode(String installSettlementCode) {
        this.installSettlementCode = installSettlementCode;
    }

    public String getInstallTravelCode() {
        return installTravelCode;
    }

    public void setInstallTravelCode(String installTravelCode) {
        this.installTravelCode = installTravelCode;
    }

    public int getIntegratedFinanceSystem() {
        return integratedFinanceSystem;
    }

    public void setIntegratedFinanceSystem(int integratedFinanceSystem) {
        this.integratedFinanceSystem = integratedFinanceSystem;
    }

    public int getIntegratedHotelSystem() {
        return integratedHotelSystem;
    }

    public void setIntegratedHotelSystem(int integratedHotelSystem) {
        this.integratedHotelSystem = integratedHotelSystem;
    }

    public String getIntroLetterCode() {
        return introLetterCode;
    }

    public void setIntroLetterCode(String introLetterCode) {
        this.introLetterCode = introLetterCode;
    }

    public String getInvoiceCode() {
        return invoiceCode;
    }

    public void setInvoiceCode(String invoiceCode) {
        this.invoiceCode = invoiceCode;
    }

    public Date getLastUpdate() {
        return lastUpdate;
    }

    public void setLastUpdate(Date lastUpdate) {
        this.lastUpdate = lastUpdate;
    }

    public double getMaxPettycashReplenis() {
        return maxPettycashReplenis;
    }

    public void setMaxPettycashReplenis(double maxPettycashReplenis) {
        this.maxPettycashReplenis = maxPettycashReplenis;
    }

    public double getMaxPettycashTransaction() {
        return maxPettycashTransaction;
    }

    public void setMaxPettycashTransaction(double maxPettycashTransaction) {
        this.maxPettycashTransaction = maxPettycashTransaction;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public int getNumberOfPeriod() {
        return numberOfPeriod;
    }

    public void setNumberOfPeriod(int numberOfPeriod) {
        this.numberOfPeriod = numberOfPeriod;
    }

    public String getOpnameCode() {
        return opnameCode;
    }

    public void setOpnameCode(String opnameCode) {
        this.opnameCode = opnameCode;
    }

    public String getPaymentCode() {
        return paymentCode;
    }

    public void setPaymentCode(String paymentCode) {
        this.paymentCode = paymentCode;
    }

    public String getPettycashPaymentCode() {
        return pettycashPaymentCode;
    }

    public void setPettycashPaymentCode(String pettycashPaymentCode) {
        this.pettycashPaymentCode = pettycashPaymentCode;
    }

    public String getPettycashReplaceCode() {
        return pettycashReplaceCode;
    }

    public void setPettycashReplaceCode(String pettycashReplaceCode) {
        this.pettycashReplaceCode = pettycashReplaceCode;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getPinjamanBankCode() {
        return pinjamanBankCode;
    }

    public void setPinjamanBankCode(String pinjamanBankCode) {
        this.pinjamanBankCode = pinjamanBankCode;
    }

    public String getPinjamanKoperasiBankCode() {
        return pinjamanKoperasiBankCode;
    }

    public void setPinjamanKoperasiBankCode(String pinjamanKoperasiBankCode) {
        this.pinjamanKoperasiBankCode = pinjamanKoperasiBankCode;
    }

    public String getPinjamanKoperasiCode() {
        return pinjamanKoperasiCode;
    }

    public void setPinjamanKoperasiCode(String pinjamanKoperasiCode) {
        this.pinjamanKoperasiCode = pinjamanKoperasiCode;
    }

    public String getProjectCode() {
        return projectCode;
    }

    public void setProjectCode(String projectCode) {
        this.projectCode = projectCode;
    }

    public String getProposalCode() {
        return proposalCode;
    }

    public void setProposalCode(String proposalCode) {
        this.proposalCode = proposalCode;
    }

    public String getPurchaseOrderCode() {
        return purchaseOrderCode;
    }

    public void setPurchaseOrderCode(String purchaseOrderCode) {
        this.purchaseOrderCode = purchaseOrderCode;
    }

    public String getPurchaseRequestCode() {
        return purchaseRequestCode;
    }

    public void setPurchaseRequestCode(String purchaseRequestCode) {
        this.purchaseRequestCode = purchaseRequestCode;
    }

    public String getReturnGoodsCode() {
        return returnGoodsCode;
    }

    public void setReturnGoodsCode(String returnGoodsCode) {
        this.returnGoodsCode = returnGoodsCode;
    }

    public String getSerialNumber() {
        return serialNumber;
    }

    public void setSerialNumber(String serialNumber) {
        this.serialNumber = serialNumber;
    }

    public String getShopOrderCode() {
        return shopOrderCode;
    }

    public void setShopOrderCode(String shopOrderCode) {
        this.shopOrderCode = shopOrderCode;
    }

    public long getSystemLocation() {
        return systemLocation;
    }

    public void setSystemLocation(long systemLocation) {
        this.systemLocation = systemLocation;
    }

    public String getSystemLocationCode() {
        return systemLocationCode;
    }

    public void setSystemLocationCode(String systemLocationCode) {
        this.systemLocationCode = systemLocationCode;
    }

    public String getTaxNumber() {
        return taxNumber;
    }

    public void setTaxNumber(String taxNumber) {
        this.taxNumber = taxNumber;
    }

    public String getTransferGoodsCode() {
        return transferGoodsCode;
    }

    public void setTransferGoodsCode(String transferGoodsCode) {
        this.transferGoodsCode = transferGoodsCode;
    }

    public String getWebsite() {
        return website;
    }

    public void setWebsite(String website) {
        this.website = website;
    }

    public int getUseBkp() {
        return useBkp;
    }

    public void setUseBkp(int useBkp) {
        this.useBkp = useBkp;
    }

    public double getTaxAmount() {
        return TaxAmount;
    }

    public void setTaxAmount(double TaxAmount) {
        this.TaxAmount = TaxAmount;
    }

    public int getMultiCurrency() {
        return multiCurrency;
    }

    public void setMultiCurrency(int multiCurrency) {
        this.multiCurrency = multiCurrency;
    }

    public int getMultiBank() {
        return multiBank;
    }

    public void setMultiBank(int multiBank) {
        this.multiBank = multiBank;
    }

    public int getBusinessType() {
        return businessType;
    }

    public void setBusinessType(int businessType) {
        this.businessType = businessType;
    }
}
