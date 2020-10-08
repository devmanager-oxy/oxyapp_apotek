package com.project.ccs.posmaster;

import com.project.main.entity.*;

public class ItemGroup extends Entity {

    private String name = "";
    private String accountCode = "";
    /**
     * Holds value of property code.
     */
    private String code = "";
    /**
     * Holds value of property type.
     */
    private int type;
    /**
     * Holds value of property accountSales.
     */
    private String accountSales = "";
    /**
     * Holds value of property accountCogs.
     */
    private String accountCogs;
    /**
     * Holds value of property accountInv.
     */
    private String accountInv = "";
    /**
     * Holds value of property imageName.
     */
    private String imageName = "";
    /**
     * Holds value of property companyId.
     */
    private long companyId;
    /**
     * Holds value of property accountSalesCash.
     */
    private String accountSalesCash = "";
    /**
     * Holds value of property accountCashIncome.
     */
    private String accountCashIncome = "";
    /**
     * Holds value of property accountCreditIncome.
     */
    private String accountCreditIncome = "";
    /**
     * Holds value of property accountVat.
     */
    private String accountVat = "";
    /**
     * Holds value of property accountPph.
     */
    private String accountPph = "";
    /**
     * Holds value of property accountDiscount.
     */
    private String accountDiscount = "";
    /**
     * Holds value of property accountSalesJasa.
     */
    private String accountSalesJasa = "";
    /**
     * Holds value of property accountExpenseJasa.
     */
    private String accountExpenseJasa = "";
    private String accountCosting = "";
    private String accountOtherIncome = "";
    private String accountBonusIncome = "";
    private String accountAjustment = "";
    private int bonus = 0;
    private double qtyBeli = 0;
    private double qtyBonus = 0;
    
    private String accountGrosirSales = "";
    private String accountGrosirCOGS = "";
    private String accountGrosirInventory = "";
    private String accountGrosirDiscount = "";
    private String accountGrosirAdjusment = "";
    

    public String getName() {
        return name;
    }

    public void setName(String name) {
        if (name == null) {
            name = "";
        }
        this.name = name;
    }

    public String getAccountCode() {
        return accountCode;
    }

    public void setAccountCode(String accountCode) {
        if (accountCode == null) {
            accountCode = "";
        }
        this.accountCode = accountCode;
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
     * Getter for property categoryType.
     * @return Value of property categoryType.
     */
    public int getType() {
        return this.type;
    }

    /**
     * Setter for property categoryType.
     * @param categoryType New value of property categoryType.
     */
    public void setType(int type) {
        this.type = type;
    }

    /**
     * Getter for property accountSales.
     * @return Value of property accountSales.
     */
    public String getAccountSales() {
        return this.accountSales;
    }

    /**
     * Setter for property accountSales.
     * @param accountSales New value of property accountSales.
     */
    public void setAccountSales(String accountSales) {
        this.accountSales = accountSales;
    }

    /**
     * Getter for property accountCogs.
     * @return Value of property accountCogs.
     */
    public String getAccountCogs() {
        return this.accountCogs;
    }

    /**
     * Setter for property accountCogs.
     * @param accountCogs New value of property accountCogs.
     */
    public void setAccountCogs(String accountCogs) {
        this.accountCogs = accountCogs;
    }

    /**
     * Getter for property accountInv.
     * @return Value of property accountInv.
     */
    public String getAccountInv() {
        return this.accountInv;
    }

    /**
     * Setter for property accountInv.
     * @param accountInv New value of property accountInv.
     */
    public void setAccountInv(String accountInv) {
        this.accountInv = accountInv;
    }

    /**
     * Getter for property imageName.
     * @return Value of property imageName.
     */
    public String getImageName() {
        return this.imageName;
    }

    /**
     * Setter for property imageName.
     * @param imageName New value of property imageName.
     */
    public void setImageName(String imageName) {
        this.imageName = imageName;
    }

    /**
     * Getter for property companyId.
     * @return Value of property companyId.
     */
    public long getCompanyId() {
        return this.companyId;
    }

    /**
     * Setter for property companyId.
     * @param companyId New value of property companyId.
     */
    public void setCompanyId(long companyId) {
        this.companyId = companyId;
    }

    /**
     * Getter for property accountSalesCash.
     * @return Value of property accountSalesCash.
     */
    public String getAccountSalesCash() {
        return this.accountSalesCash;
    }

    /**
     * Setter for property accountSalesCash.
     * @param accountSalesCash New value of property accountSalesCash.
     */
    public void setAccountSalesCash(String accountSalesCash) {
        this.accountSalesCash = accountSalesCash;
    }

    /**
     * Getter for property accountCashIncome.
     * @return Value of property accountCashIncome.
     */
    public String getAccountCashIncome() {
        return this.accountCashIncome;
    }

    /**
     * Setter for property accountCashIncome.
     * @param accountCashIncome New value of property accountCashIncome.
     */
    public void setAccountCashIncome(String accountCashIncome) {
        this.accountCashIncome = accountCashIncome;
    }

    /**
     * Getter for property accountCreditIncome.
     * @return Value of property accountCreditIncome.
     */
    public String getAccountCreditIncome() {
        return this.accountCreditIncome;
    }

    /**
     * Setter for property accountCreditIncome.
     * @param accountCreditIncome New value of property accountCreditIncome.
     */
    public void setAccountCreditIncome(String accountCreditIncome) {
        this.accountCreditIncome = accountCreditIncome;
    }

    /**
     * Getter for property accountVat.
     * @return Value of property accountVat.
     */
    public String getAccountVat() {
        return this.accountVat;
    }

    /**
     * Setter for property accountVat.
     * @param accountVat New value of property accountVat.
     */
    public void setAccountVat(String accountVat) {
        this.accountVat = accountVat;
    }

    /**
     * Getter for property accountPph.
     * @return Value of property accountPph.
     */
    public String getAccountPph() {
        return this.accountPph;
    }

    /**
     * Setter for property accountPph.
     * @param accountPph New value of property accountPph.
     */
    public void setAccountPph(String accountPph) {
        this.accountPph = accountPph;
    }

    /**
     * Getter for property accountDiscount.
     * @return Value of property accountDiscount.
     */
    public String getAccountDiscount() {
        return this.accountDiscount;
    }

    /**
     * Setter for property accountDiscount.
     * @param accountDiscount New value of property accountDiscount.
     */
    public void setAccountDiscount(String accountDiscount) {
        this.accountDiscount = accountDiscount;
    }

    /**
     * Getter for property accountSalesJasa.
     * @return Value of property accountSalesJasa.
     */
    public String getAccountSalesJasa() {
        return this.accountSalesJasa;
    }

    /**
     * Setter for property accountSalesJasa.
     * @param accountSalesJasa New value of property accountSalesJasa.
     */
    public void setAccountSalesJasa(String accountSalesJasa) {
        this.accountSalesJasa = accountSalesJasa;
    }

    /**
     * Getter for property accountExpenseJasa.
     * @return Value of property accountExpenseJasa.
     */
    public String getAccountExpenseJasa() {
        return this.accountExpenseJasa;
    }

    /**
     * Setter for property accountExpenseJasa.
     * @param accountExpenseJasa New value of property accountExpenseJasa.
     */
    public void setAccountExpenseJasa(String accountExpenseJasa) {
        this.accountExpenseJasa = accountExpenseJasa;
    }

    public String getAccountCosting() {
        return accountCosting;
    }

    public void setAccountCosting(String accountCosting) {
        this.accountCosting = accountCosting;
    }

    public String getAccountOtherIncome() {
        return accountOtherIncome;
    }

    public void setAccountOtherIncome(String accountOtherIncome) {
        this.accountOtherIncome = accountOtherIncome;
    }

    public String getAccountBonusIncome() {
        return accountBonusIncome;
    }

    public void setAccountBonusIncome(String accountBonusIncome) {
        this.accountBonusIncome = accountBonusIncome;
    }

    public String getAccountAjustment() {
        return accountAjustment;
    }

    public void setAccountAjustment(String accountAjustment) {
        this.accountAjustment = accountAjustment;
    }

    public int getBonus() {
        return bonus;
    }

    public void setBonus(int bonus) {
        this.bonus = bonus;
    }

    public double getQtyBeli() {
        return qtyBeli;
    }

    public void setQtyBeli(double qtyBeli) {
        this.qtyBeli = qtyBeli;
    }

    public double getQtyBonus() {
        return qtyBonus;
    }

    public void setQtyBonus(double qtyBonus) {
        this.qtyBonus = qtyBonus;
    }

    public String getAccountGrosirSales() {
        return accountGrosirSales;
    }

    public void setAccountGrosirSales(String accountGrosirSales) {
        this.accountGrosirSales = accountGrosirSales;
    }

    public String getAccountGrosirCOGS() {
        return accountGrosirCOGS;
    }

    public void setAccountGrosirCOGS(String accountGrosirCOGS) {
        this.accountGrosirCOGS = accountGrosirCOGS;
    }

    public String getAccountGrosirInventory() {
        return accountGrosirInventory;
    }

    public void setAccountGrosirInventory(String accountGrosirInventory) {
        this.accountGrosirInventory = accountGrosirInventory;
    }

    public String getAccountGrosirDiscount() {
        return accountGrosirDiscount;
    }

    public void setAccountGrosirDiscount(String accountGrosirDiscount) {
        this.accountGrosirDiscount = accountGrosirDiscount;
    }

    public String getAccountGrosirAdjusment() {
        return accountGrosirAdjusment;
    }

    public void setAccountGrosirAdjusment(String accountGrosirAdjusment) {
        this.accountGrosirAdjusment = accountGrosirAdjusment;
    }
}
