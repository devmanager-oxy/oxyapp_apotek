
package com.project.ccs.posmaster; 
 
import java.util.Date;
import com.project.main.entity.*;

public class ItemMaster extends Entity { 

	private long itemGroupId;
	private long itemCategoryId;
	private long uomPurchaseId;
	private long uomRecipeId;        
	private long uomStockId;
	private long uomSalesId;
	private String code = "";
	private String barcode = "";
	private String name = "";
	private double uomPurchaseStockQty;
	private double uomStockRecipeQty;
	private double uomStockSalesQty;
	private int forSale;
	private int forBuy;
	private int isActive;
	private double sellingPrice;
	private double cogs;
	private int recipeItem;        

        /**
         * Holds value of property needRecipe.
         */
        private int needRecipe;
        
        /**
         * Holds value of property defaultVendorId.
         */
        private long defaultVendorId;
        
        /**
         * Holds value of property minStock.
         */
        private double minStock;
        
        /**
         * Holds value of property type.
         */
        
        private int type;
        private int applyStockCode;
        private int is_service;
        private double cogs_consigment;
        private int applyStockCodeSales;
        private int useExpiredDate;
        private long merk_id;
        private double new_cogs;
        private Date active_date;
        private int is_bkp;
        private int isKomisi;
        private String barcode2="";
        private String barcode3="";
        private int counterSku;
        private Date registerDate;
        
        //add by roy untuk group type beli putus atau consigment
        private int typeItem;          
        
        //add by roy untuk menhandle multy sales
        private double uomStockSales1Qty;        
        private long uomSales2Id;
        private double uomStockSales2Qty;
        private long uomSales3Id;
        private double uomStockSales3Qty;
        private long uomSales4Id;
        private double uomStockSales4Qty;
        private long uomSales5Id;
        private double uomStockSales5Qty;
        //add by ngurah untk menghandle auto order
        private double deliveryUnit;
        private long locationOrder;
        private int isAutoOrder;
        private int needBom;
        private String status;
        private Date approvedDate;
        private long userIdAproved;
        
        
        
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

	public long getUomPurchaseId(){ 
		return uomPurchaseId; 
	} 

	public void setUomPurchaseId(long uomPurchaseId){ 
		this.uomPurchaseId = uomPurchaseId; 
	} 

	public long getUomRecipeId(){ 
		return uomRecipeId; 
	} 

	public void setUomRecipeId(long uomRecipeId){ 
		this.uomRecipeId = uomRecipeId; 
	} 

	public long getUomStockId(){ 
		return uomStockId; 
	} 

	public void setUomStockId(long uomStockId){ 
		this.uomStockId = uomStockId; 
	} 

	public long getUomSalesId(){ 
		return uomSalesId; 
	} 

	public void setUomSalesId(long uomSalesId){ 
		this.uomSalesId = uomSalesId; 
	} 

	public String getCode(){ 
		return code; 
	} 

	public void setCode(String code){ 
		if ( code == null ) {
			code = ""; 
		} 
		this.code = code; 
	} 

	public String getBarcode(){ 
		return barcode; 
	} 

	public void setBarcode(String barcode){ 
		if ( barcode == null ) {
			barcode = ""; 
		} 
		this.barcode = barcode; 
	} 

	public String getName(){ 
		return name; 
	} 

	public void setName(String name){ 
		if ( name == null ) {
			name = ""; 
		} 
		this.name = name; 
	} 

	public double getUomPurchaseStockQty(){ 
		return uomPurchaseStockQty; 
	} 

	public void setUomPurchaseStockQty(double uomPurchaseStockQty){ 
		this.uomPurchaseStockQty = uomPurchaseStockQty; 
	} 

	public double getUomStockRecipeQty(){ 
		return uomStockRecipeQty; 
	} 

	public void setUomStockRecipeQty(double uomStockRecipeQty){ 
		this.uomStockRecipeQty = uomStockRecipeQty; 
	} 

	public double getUomStockSalesQty(){ 
		return uomStockSalesQty; 
	} 

	public void setUomStockSalesQty(double uomStockSalesQty){ 
		this.uomStockSalesQty = uomStockSalesQty; 
	} 

	public int getForSale(){ 
		return forSale; 
	} 

	public void setForSale(int forSale){ 
		this.forSale = forSale; 
	} 

	public int getForBuy(){ 
		return forBuy; 
	} 

	public void setForBuy(int forBuy){ 
		this.forBuy = forBuy; 
	} 

	public int getIsActive(){ 
		return isActive; 
	} 

	public void setIsActive(int isActive){ 
		this.isActive = isActive; 
	} 

	public double getSellingPrice(){ 
		return sellingPrice; 
	} 

	public void setSellingPrice(double sellingPrice){ 
		this.sellingPrice = sellingPrice; 
	} 

	public double getCogs(){ 
		return cogs; 
	} 

	public void setCogs(double cogs){ 
		this.cogs = cogs; 
	} 

	public int getRecipeItem(){ 
		return recipeItem; 
	} 

	public void setRecipeItem(int recipeItem){ 
		this.recipeItem = recipeItem; 
	} 

        /**
         * Getter for property needRecipe.
         * @return Value of property needRecipe.
         */
        public int getNeedRecipe() {
            return this.needRecipe;
        }
        
        /**
         * Setter for property needRecipe.
         * @param needRecipe New value of property needRecipe.
         */
        public void setNeedRecipe(int needRecipe) {
            this.needRecipe = needRecipe;
        }
        
        /**
         * Getter for property defaultVendor.
         * @return Value of property defaultVendor.
         */
        public long getDefaultVendorId() {
            return this.defaultVendorId;
        }
        
        /**
         * Setter for property defaultVendor.
         * @param defaultVendor New value of property defaultVendor.
         */
        public void setDefaultVendorId(long defaultVendorId) {
            this.defaultVendorId = defaultVendorId;
        }
        
        /**
         * Getter for property minStock.
         * @return Value of property minStock.
         */
        public double getMinStock() {
            return this.minStock;
        }
        
        /**
         * Setter for property minStock.
         * @param minStock New value of property minStock.
         */
        public void setMinStock(double minStock) {
            this.minStock = minStock;
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

    public int getApplyStockCode() {
        return applyStockCode;
    }

    public void setApplyStockCode(int applyStockCode) {
        this.applyStockCode = applyStockCode;
    }

    public int getIs_service() {
        return is_service;
    }

    public void setIs_service(int is_service) {
        this.is_service = is_service;
    }

    public double getCogs_consigment() {
        return cogs_consigment;
    }

    public void setCogs_consigment(double cogs_consigment) {
        this.cogs_consigment = cogs_consigment;
    }

    public int getApplyStockCodeSales() {
        return applyStockCodeSales;
    }

    public void setApplyStockCodeSales(int applyStockCodeSales) {
        this.applyStockCodeSales = applyStockCodeSales;
    }

    public int getUseExpiredDate() {
        return useExpiredDate;
    }

    public void setUseExpiredDate(int useExpiredDate) {
        this.useExpiredDate = useExpiredDate;
    }

    public long getMerk_id() {
        return merk_id;
    }

    public void setMerk_id(long merk_id) {
        this.merk_id = merk_id;
    }

    public double getNew_cogs() {
        return new_cogs;
    }

    public void setNew_cogs(double new_cogs) {
        this.new_cogs = new_cogs;
    }

    public Date getActive_date() {
        return active_date;
    }

    public void setActive_date(Date active_date) {
        this.active_date = active_date;
    }

    public int getIs_bkp() {
        return is_bkp;
    }

    public void setIs_bkp(int is_bkp) {
        this.is_bkp = is_bkp;
    }

    public int getIsKomisi() {
        return isKomisi;
    }

    public void setIsKomisi(int isKomisi) {
        this.isKomisi = isKomisi;
    }

    public String getBarcode2() {
        return barcode2;
    }

    public void setBarcode2(String barcode2) {
        this.barcode2 = barcode2;
    }

    public String getBarcode3() {
        return barcode3;
    }

    public void setBarcode3(String barcode3) {
        this.barcode3 = barcode3;
    }

    public int getCounterSku() {
        return counterSku;
    }

    public void setCounterSku(int counterSku) {
        this.counterSku = counterSku;
    }

    public Date getRegisterDate() {
        return registerDate;
    }

    public void setRegisterDate(Date registerDate) {
        this.registerDate = registerDate;
    }

    public int getTypeItem() {
        return typeItem;
    }

    public void setTypeItem(int typeItem) {
        this.typeItem = typeItem;
    }

    public double getUomStockSales1Qty() {
        return uomStockSales1Qty;
    }

    public void setUomStockSales1Qty(double uomStockSales1Qty) {
        this.uomStockSales1Qty = uomStockSales1Qty;
    }

    public long getUomSales2Id() {
        return uomSales2Id;
    }

    public void setUomSales2Id(long uomSales2Id) {
        this.uomSales2Id = uomSales2Id;
    }

    public double getUomStockSales2Qty() {
        return uomStockSales2Qty;
    }

    public void setUomStockSales2Qty(double uomStockSales2Qty) {
        this.uomStockSales2Qty = uomStockSales2Qty;
    }

    public long getUomSales3Id() {
        return uomSales3Id;
    }

    public void setUomSales3Id(long uomSales3Id) {
        this.uomSales3Id = uomSales3Id;
    }

    public double getUomStockSales3Qty() {
        return uomStockSales3Qty;
    }

    public void setUomStockSales3Qty(double uomStockSales3Qty) {
        this.uomStockSales3Qty = uomStockSales3Qty;
    }

    public long getUomSales4Id() {
        return uomSales4Id;
    }

    public void setUomSales4Id(long uomSales4Id) {
        this.uomSales4Id = uomSales4Id;
    }

    public double getUomStockSales4Qty() {
        return uomStockSales4Qty;
    }

    public void setUomStockSales4Qty(double uomStockSales4Qty) {
        this.uomStockSales4Qty = uomStockSales4Qty;
    }

    public long getUomSales5Id() {
        return uomSales5Id;
    }

    public void setUomSales5Id(long uomSales5Id) {
        this.uomSales5Id = uomSales5Id;
    }

    public double getUomStockSales5Qty() {
        return uomStockSales5Qty;
    }

    public void setUomStockSales5Qty(double uomStockSales5Qty) {
        this.uomStockSales5Qty = uomStockSales5Qty;
    }

    public double getDeliveryUnit() {
        return deliveryUnit;
    }

    public void setDeliveryUnit(double deliveryUnit) {
        this.deliveryUnit = deliveryUnit;
    }

    public long getLocationOrder() {
        return locationOrder;
    }

    public void setLocationOrder(long locationOrder) {
        this.locationOrder = locationOrder;
    }

    public int getIsAutoOrder() {
        return isAutoOrder;
    }

    public void setIsAutoOrder(int isAutoOrder) {
        this.isAutoOrder = isAutoOrder;
    }

    public int getNeedBom() {
        return needBom;
    }

    public void setNeedBom(int needBom) {
        this.needBom = needBom;
    }

    
    public Date getApprovedDate() {
        return approvedDate;
    }

    public void setApprovedDate(Date approvedDate) {
        this.approvedDate = approvedDate;
    }

    public long getUserIdAproved() {
        return userIdAproved;
    }

    public void setUserIdAproved(long userIdAproved) {
        this.userIdAproved = userIdAproved;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    

   
    
        
}
