<%@ page import="com.project.admin.*"%>
<%
session.setMaxInactiveInterval(2500000);

//Company sysCompany = DbCompany.getCompany();

QrUserSession appSessUser =  new QrUserSession();
User user = new User();
	
try{
	
	if(session.getValue("ADMIN_LOGIN")!=null){
		appSessUser = (QrUserSession)session.getValue("ADMIN_LOGIN");
		user = appSessUser.getUser();
		try{
			user = DbUser.fetch(user.getOID());
		}
		catch(Exception e){
		}
	}    
	else{
		appSessUser = null;
		response.sendRedirect(approot+"/indexsl.jsp");	
	}

} catch (Exception exc){
  	System.out.println(" ==> Exception during check user");
	appSessUser = null;
	response.sendRedirect(approot+"/indexsl.jsp");	
}

//System.out.println("appSessUser.getUserOID() "+appSessUser.getUserOID());
//System.out.println("session "+session.getMaxInactiveInterval());

if(appSessUser==null){// || appSessUser.getUserOID()==0){
	appSessUser = new QrUserSession();
	//response.sendRedirect(approot+"/indexpg.jsp");
}

//New Code
long systemCompanyId = 0;//appSessUser.getCompanyOID();

//Purchase
boolean pRequestPriv = true;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_INV_PURCHASING, AppMenu.M2_INV_PURCHASING_REQUEST);
boolean pOrderPriv = true;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_INV_PURCHASING, AppMenu.M2_INV_PURCHASING_ORDER);
boolean pArcPriv = true;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_INV_PURCHASING, AppMenu.M2_INV_PURCHASING_ARCHIVE);

//Incoming
boolean iReceiptPriv = true;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_INV_INCOMING, AppMenu.M2_INV_INCOMING_RECEIPT);
boolean iArcPriv = true;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_INV_INCOMING, AppMenu.M2_INV_INCOMING_ARCHIVE);

//Stock
boolean sTransferPriv = true;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_INV_STOCK, AppMenu.M2_INV_STOCK_TRANSFER);
boolean sReturnPriv = true;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_INV_STOCK, AppMenu.M2_INV_STOCK_RETURN);
boolean sAdjustmentPriv = true;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_INV_STOCK, AppMenu.M2_INV_STOCK_ADJUSTMENT);
boolean sOpnamePriv = true;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_INV_STOCK, AppMenu.M2_INV_STOCK_OPNAME);
boolean sArcPriv = true;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_INV_STOCK, AppMenu.M2_INV_STOCK_ARCHIVE);

//Production
boolean pMasterProductListPriv = false;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_INV_PRODUCTION, AppMenu.M2_INV_MASTER_PRODUCT_LIST);
boolean pMasterDetailPriv = false;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_INV_PRODUCTION, AppMenu.M2_INV_MASTER_PRODUCT_DETAIL);
boolean pMasterBOMPriv = false;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_INV_PRODUCTION, AppMenu.M2_INV_MASTER_BOM);
boolean pMasterRoutingPriv = false;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_INV_PRODUCTION, AppMenu.M2_INV_MASTER_ROUTING);
boolean pMasterOtherOverheadPriv = false;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_INV_PRODUCTION, AppMenu.M2_INV_MASTER_OTHER_OVERHEAD);
boolean pMasterWorkCenterPriv = false;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_INV_PRODUCTION, AppMenu.M2_INV_MASTER_WORKCENTER);
//
boolean pManagementCreateSfOrderPriv = false;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_INV_PRODUCTION, AppMenu.M2_INV_MANAGEMENT_CREATE_SF_ORDER);
boolean pManagementSfControlPriv = false;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_INV_PRODUCTION, AppMenu.M2_INV_MANAGEMENT_SF_CONTROL);
boolean pManagementFinishGoodsPriv = false;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_INV_PRODUCTION, AppMenu.M2_INV_FINISH_GOODS);
//
boolean pDeliveryTemplateDoPriv = false;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_INV_PRODUCTION, AppMenu.M2_INV_DELIVERY_TEMPLATE_DO);
boolean pDeliveryPreviewDoPriv = false;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_INV_PRODUCTION, AppMenu.M2_INV_DELIVERY_PREVIEW_DO);
boolean pDeliveryExpensePriv = false;// appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_INV_PRODUCTION, AppMenu.M2_INV_DELIVERY_EXPENSE);
//
boolean mMasterCategoryPriv = false;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_INV_PRODUCTION, AppMenu.M2_INV_MASTER_CATEGORY);
boolean mMasterSubCategoryPriv = false;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_INV_PRODUCTION, AppMenu.M2_INV_MASTER_SUB_CATEGORY);


//Administrator
boolean adminPriv = true;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_INV_ADMINISTRATOR, AppMenu.M2_INV_ADMINISTRATOR);

//Master
boolean mConfigurationPriv = false;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_INV_MASTER, AppMenu.M2_INV_CONFIGURATION);
boolean mMaterialBrandPriv = false;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_INV_MASTER, AppMenu.M2_INV_MATERIAL_BRAND);
boolean mMaterialCategoryPriv = true;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_INV_MASTER, AppMenu.M2_INV_MATERIAL_CATEGORY);
boolean mMaterialSubCategoryPriv = true;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_INV_MASTER, AppMenu.M2_INV_MATERIAL_SUB_CATEGORY);
boolean mMaterialMasterListPriv = true;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_INV_MASTER, AppMenu.M2_INV_MATERIAL_LIST);
boolean mMaterialMasterDetailPriv = true;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_INV_MASTER, AppMenu.M2_INV_MATERIAL_DETAIL);
boolean mMaterialMasterBOMPriv = true;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_INV_MASTER, AppMenu.M2_INV_MATERIAL_BOM);
boolean mMaterialMasterRoutingPriv = true;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_INV_MASTER, AppMenu.M2_INV_MATERIAL_ROUTING);
boolean mMaterialMasterOtherOverheadPriv = true;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_INV_MASTER, AppMenu.M2_INV_MATERIAL_OTHER_OVERHEAD);
boolean mMaterialWorkCenterPriv = false;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_INV_MASTER, AppMenu.M2_INV_MATERIAL_WORKCENTER);
//
boolean mGeneralContinentPriv = true;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_INV_MASTER, AppMenu.M2_INV_GENERAL_CONTINENT);
boolean mGeneralCountryPriv = true;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_INV_MASTER, AppMenu.M2_INV_GENERAL_COUNTRY);
boolean mGeneralCurrencyPriv = true;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_INV_MASTER, AppMenu.M2_INV_GENERAL_CURRENCY);
boolean mGeneralCustomerPriv = true;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_INV_MASTER, AppMenu.M2_INV_GENERAL_CUSTOMER);
boolean mGeneralShippingAddressPriv = true;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_INV_MASTER, AppMenu.M2_INV_GENERAL_SHIPPING_ADDRESS);
boolean mGeneralWarehouseLocationPriv = true;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_INV_MASTER, AppMenu.M2_INV_GENERAL_WAREHOUSE_LOCATION);
boolean mGeneralVendorPriv = true;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_INV_MASTER, AppMenu.M2_INV_GENERAL_VENDOR);
boolean mGeneralUomPriv = true;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_INV_MASTER, AppMenu.M2_INV_GENERAL_UOM);
//hrd
boolean mHrdEmployeePriv = true;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_INV_MASTER, AppMenu.M2_INV_HRD_EMPLOYEE);
boolean mHrdDepartmentPriv = true;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_INV_MASTER, AppMenu.M2_INV_HRD_DEPARTMENT);
//Accounting
boolean mAccRatePriv = false;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_INV_MASTER, AppMenu.M2_INV_ACC_BOOKEEPING_RATE);
boolean mAccPeridPriv = false;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_INV_MASTER, AppMenu.M2_INV_ACC_PERIOD);
//Menu
boolean mMenuListPriv = false;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_INV_MASTER, AppMenu.M2_INV_MENU_SHOW_LIST);
boolean mCategoryListPriv = false;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_INV_MASTER, AppMenu.M2_INV_CATEGORY_SHOW_LIST);

boolean mPOReport  = true;
boolean mPORetur = true;
boolean mItemTransfer = true;
boolean mStockReport = true;
boolean mPaymantReport = true;

//Data Synchronization
boolean datasyncPriv = true;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_INV_DATASYNC, AppMenu.M2_INV_DATASYNC);

//============= POS priv ======================

boolean posPReqPriv = true; //QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MENU_POSPURCHASEREQUEST);
boolean posPOrdPriv = true; //QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MENU_POSPURCHASEORDER);
boolean posIcomingPriv = true; //QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MENU_POSINCOMING);
boolean posReturPriv = true; //QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MENU_POSRETUR);
boolean posTransferPriv = true; //QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MENU_POSTRANSFER);
boolean posCostingPriv = true; //QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MENU_POSCOSTING);
boolean posOpnamePriv = true; //QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MENU_POSOPNAME);
boolean posAdjPriv = true; //QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MENU_POSADJUSTMENT);
boolean posMasterPriv = true; //QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MENU_POSMASTER);
boolean posCashierPriv = true; //QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MENU_POSCASHIER);
boolean posApprove1Priv = true; //QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MENU_POSAPPROVAL_1);
boolean posApprove2Priv = true; //QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MENU_POSAPPROVAL_2);
boolean posApprove3Priv = true; //QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MENU_POSAPPROVAL_3);
boolean posApprove4Priv = true; //QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MENU_POSAPPROVAL_4);
boolean custNewPriv = true;
boolean custQueryPriv = true;
//boolean masterPriv = true;

%>
