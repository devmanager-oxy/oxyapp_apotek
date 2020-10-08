
package com.project.ccs.posmaster;

import java.io.*; 
import java.util.*; 
import javax.servlet.*;
import javax.servlet.http.*; 
import com.project.util.jsp.*;

public class JspItemGroup extends JSPHandler implements I_JSPInterface, I_JSPType 
{
	private ItemGroup itemGroup;

	public static final String JSP_NAME_ITEMGROUP		=  "JSP_NAME_ITEMGROUP" ;

	public static final int JSP_ITEM_GROUP_ID			=  0 ;
	public static final int JSP_NAME                                =  1 ;
	public static final int JSP_ACCOUNT_CODE			=  2 ;
        public static final int JSP_CODE                                =  3 ;
        
        public static final int JSP_TYPE                                =  4 ;
        public static final int JSP_ACCOUNT_SALES			=  5 ;
        public static final int JSP_ACCOUNT_COGS			=  6 ;
        public static final int JSP_ACCOUNT_INV                         =  7 ;
        public static final int JSP_IMAGE_NAME                          =  8 ;
        public static final int JSP_COMPANY_ID                          =  9 ;
        public static final int JSP_ACCOUNT_SALES_CASH                  =  10 ;
        
        public static final int JSP_ACCOUNT_CASH_INCOME                 =  11 ;
        public static final int JSP_ACCOUNT_CREDIT_INCOME               =  12 ;
        public static final int JSP_ACCOUNT_VAT                         =  13 ;
        public static final int JSP_ACCOUNT_PPH                         =  14 ;
        public static final int JSP_ACCOUNT_DISCOUNT                    =  15 ;
        
        public static final int JSP_ACCOUNT_SALES_JASA                  =  16 ;
        public static final int JSP_ACCOUNT_EXPENSE_JASA                =  17 ;        
        public static final int JSP_ACCOUNT_COSTING                     =  18 ;
        
        public static final int JSP_ACCOUNT_OTHER_INCOME                =  19 ;
        public static final int JSP_ACCOUNT_BONUS_INCOME                =  20 ;
        public static final int JSP_ACCOUNT_AJUSTMENT                   =  21 ;
        
        public static final int JSP_BONUS                               =  22 ;
        public static final int JSP_QTY_BELI                            =  23 ;
        public static final int JSP_QTY_BONUS                           =  24 ;
        
        public static final  int JSP_ACCOUNT_GROSIR_SALES = 25;
        public static final  int JSP_ACCOUNT_GROSIR_COGS = 26;
        public static final  int JSP_ACCOUNT_GROSIR_INVENTORY = 27;
        public static final  int JSP_ACCOUNT_GROSIR_DISCOUNT = 28;
        public static final  int JSP_ACCOUNT_GROSIR_ADJUSMENT = 29;

	public static String[] colNames = {
		"JSP_ITEM_GROUP_ID",  "JSP_NAME",
		"JSP_ACCOUNT_CODE", "JSP_CODE",
                "JSP_TYPE",
                "JSP_ACCOUNT_SALES",
                "JSP_ACCOUNT_COGS",
                "JSP_ACCOUNT_INV",
                "JSP_IMAGE_NAME",
                "JSP_COMPANY_ID",
                "JSP_ACCOUNT_SALES_CASH",
                
                "JSP_ACCOUNT_CASH_INCOME",
                "JSP_ACCOUNT_CREDIT_INCOME",
                "JSP_ACCOUNT_VAT",
                "JSP_ACCOUNT_PPH",
                "JSP_ACCOUNT_DISCOUNT",
                
                "JSP_ACCOUNT_SALES_JASA",
                "JSP_ACCOUNT_EXPENSE_JASA",
                "JSP_ACCOUNT_COSTING",
                "JSP_OTHER_INCOME",
                "JSP_BONUS_INCOME",
                "JSP_ACCOUNT_AJUSTMENT",
                "JSP_BONUS",
                "JSP_QTY_BELI",
                "JSP_QTY_BONUS",
                "JSP_ACCOUNT_GROSIR_SALES",
                "JSP_ACCOUNT_GROSIR_COGS",
                "JSP_ACCOUNT_GROSIR_INVENTORY",
                "JSP_ACCOUNT_GROSIR_DISCOUNT",
                "JSP_ACCOUNT_GROSIR_ADJUSMENT"
                
	} ;

	public static int[] fieldTypes = {
		TYPE_LONG,  TYPE_STRING + ENTRY_REQUIRED,
		TYPE_STRING, TYPE_STRING + ENTRY_REQUIRED,
                
                TYPE_INT,
                TYPE_STRING,
                TYPE_STRING,
                TYPE_STRING,
                TYPE_STRING,
                TYPE_LONG,
                TYPE_STRING,
                
                TYPE_STRING,
                TYPE_STRING,
                TYPE_STRING,
                TYPE_STRING,
                TYPE_STRING,
                
                TYPE_STRING,
                TYPE_STRING,
                TYPE_STRING,
                TYPE_STRING,
                TYPE_STRING,
                TYPE_STRING,
                TYPE_INT,
                TYPE_FLOAT,
                TYPE_FLOAT,
                
                TYPE_STRING,
                TYPE_STRING,
                TYPE_STRING,
                TYPE_STRING,
                TYPE_STRING
	} ;

	public JspItemGroup(){
	}
	public JspItemGroup(ItemGroup itemGroup){
		this.itemGroup = itemGroup;
	}

	public JspItemGroup(HttpServletRequest request, ItemGroup itemGroup){
		super(new JspItemGroup(itemGroup), request);
		this.itemGroup = itemGroup;
	}

	public String getFormName() { return JSP_NAME_ITEMGROUP; } 

	public int[] getFieldTypes() { return fieldTypes; }

	public String[] getFieldNames() { return colNames; } 

	public int getFieldSize() { return colNames.length; } 

	public ItemGroup getEntityObject(){ return itemGroup; }

	public void requestEntityObject(ItemGroup itemGroup) {
		try{
			this.requestParam();
			itemGroup.setName(getString(JSP_NAME));
			itemGroup.setAccountCode(getString(JSP_ACCOUNT_CODE));
                        itemGroup.setCode(getString(JSP_CODE));
                        
                        itemGroup.setType(getInt(JSP_TYPE));
                        itemGroup.setAccountSales(getString(JSP_ACCOUNT_SALES));
                        itemGroup.setAccountCogs(getString(JSP_ACCOUNT_COGS));
                        itemGroup.setAccountInv(getString(JSP_ACCOUNT_INV));
                        itemGroup.setImageName(getString(JSP_IMAGE_NAME));
                        itemGroup.setCompanyId(getLong(JSP_COMPANY_ID));
                        itemGroup.setAccountSalesCash(getString(JSP_ACCOUNT_SALES_CASH));
                        
                        itemGroup.setAccountCashIncome(getString(JSP_ACCOUNT_CASH_INCOME));
                        itemGroup.setAccountCreditIncome(getString(JSP_ACCOUNT_CREDIT_INCOME));
                        itemGroup.setAccountVat(getString(JSP_ACCOUNT_VAT));
                        itemGroup.setAccountPph(getString(JSP_ACCOUNT_PPH));
                        itemGroup.setAccountDiscount(getString(JSP_ACCOUNT_DISCOUNT));
                        
                        itemGroup.setAccountSalesJasa(getString(JSP_ACCOUNT_SALES_JASA));
                        itemGroup.setAccountExpenseJasa(getString(JSP_ACCOUNT_EXPENSE_JASA));
                        itemGroup.setAccountCosting(getString(JSP_ACCOUNT_COSTING));
                        itemGroup.setAccountOtherIncome(getString(JSP_ACCOUNT_OTHER_INCOME));
                        itemGroup.setAccountBonusIncome(getString(JSP_ACCOUNT_BONUS_INCOME));
                        itemGroup.setAccountAjustment(getString(JSP_ACCOUNT_AJUSTMENT));
                        
                        itemGroup.setBonus(getInt(JSP_BONUS));
                        itemGroup.setQtyBeli(getDouble(JSP_QTY_BELI));
                        itemGroup.setQtyBonus(getDouble(JSP_QTY_BONUS));
                        
                        itemGroup.setAccountGrosirSales(getString(JSP_ACCOUNT_GROSIR_SALES));
                        itemGroup.setAccountGrosirCOGS(getString(JSP_ACCOUNT_GROSIR_COGS));
                        itemGroup.setAccountGrosirInventory(getString(JSP_ACCOUNT_GROSIR_INVENTORY));
                        itemGroup.setAccountGrosirDiscount(getString(JSP_ACCOUNT_GROSIR_DISCOUNT));
                        itemGroup.setAccountGrosirAdjusment(getString(JSP_ACCOUNT_GROSIR_ADJUSMENT));
                        
		}catch(Exception e){
			System.out.println("Error on requestEntityObject : "+e.toString());
		}
	}
}
