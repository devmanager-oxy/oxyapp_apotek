
<%@ page import="com.project.admin.*"%>
<%@ include file="../../check-root.jsp"%>
<%
            if(appSessUser==null){ appSessUser = new QrUserSession(); }
            long systemCompanyId = 0;
//Purchasing
            boolean purcRequest = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_PURCHASING, AppMenu.M2_PURCHASE_REQUEST);
            boolean listPendingPR = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_PURCHASING, AppMenu.M2_LIST_PENDING_PR);
            boolean prArchives = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_PURCHASING, AppMenu.M2_PR_ARCHIVES);
            boolean expPRtoPO = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_PURCHASING, AppMenu.M2_EXPORT_PR_TO_PO);
            boolean dirPO = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_PURCHASING, AppMenu.M2_DIRECT_PO);
            boolean poArchives = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_PURCHASING, AppMenu.M2_PO_ARCHIVES);
            boolean privPOApproved = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_PURCHASING, AppMenu.M2_PO_APPROVED);
            boolean privPOChecked = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_PURCHASING, AppMenu.M2_PO_CHECKED);
            

//Incoming
            boolean incomFromPo = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_INCOMING, AppMenu.M2_INCOMING_FROM_PO);
            boolean directIncom = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_INCOMING, AppMenu.M2_DIRECT_INCOMING);
            boolean incomArchives = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_INCOMING, AppMenu.M2_INCOMING_ARCHIVES);
            boolean privEditIncoming = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_INCOMING, AppMenu.M2_EDIT_INCOMING);
            boolean privApproveIncoming = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_INCOMING, AppMenu.M2_INCOMING_APPROVED);
            boolean incomingKomisi = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_INCOMING, AppMenu.M2_INCOMING_KOMISI);
            boolean receivingAdjusment = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_INCOMING, AppMenu.M2_RECEIVING_ADJUSMENT);
            
//Production
            boolean newProject = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_PRODUCTION, AppMenu.M2_NEW_PROJECT);
            boolean newStock = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_PRODUCTION, AppMenu.M2_NEW_STOCK);
            boolean mstProdCategory = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_PRODUCTION, AppMenu.M2_MASTER_PRODUCT_CATEGORY);
            boolean mstProdSubCategory = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_PRODUCTION, AppMenu.M2_MASTER_PRODUCT_SUB_CATEGORY);
            boolean mstProdList = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_PRODUCTION, AppMenu.M2_MASTER_PRODUCT_LIST);
            boolean mstProdWorkCenter = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_PRODUCTION, AppMenu.M2_MASTER_PRODUCT_WORK_CENTER);
            boolean shopFlor = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_PRODUCTION, AppMenu.M2_SHOP_FLOR_MANAGEMENT);
            boolean finishGoods = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_PRODUCTION, AppMenu.M2_FINISH_GOODS);
            boolean deliv = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_PRODUCTION, AppMenu.M2_DELIVERY);
            boolean instExp = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_PRODUCTION, AppMenu.M2_INSTALATION_EXPENSE);

//Stock Management
            boolean mTransfer = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_STOCK_MANAGEMENT, AppMenu.M2_TRANSFER);
            boolean mTransferRequest = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_STOCK_MANAGEMENT, AppMenu.M2_TRANSFER_REQUEST);
            boolean privEditTransfer = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_STOCK_MANAGEMENT, AppMenu.M2_EDIT_TRANSFER);
            boolean privApprovedTransfer = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_STOCK_MANAGEMENT, AppMenu.M2_TRANSFER_APPROVED);
            boolean privCheckedTransfer = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_STOCK_MANAGEMENT, AppMenu.M2_TRANSFER_CHECKED);
            boolean privApprovedRetur = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_STOCK_MANAGEMENT, AppMenu.M2_RETUR_APPROVED);
            boolean privApprovedCosting = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_STOCK_MANAGEMENT, AppMenu.M2_COSTING_APPROVED);            
            boolean privApprovedRepack = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_STOCK_MANAGEMENT, AppMenu.M2_REPACK_APPROVED);
            boolean privApprovedAdjusment = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_STOCK_MANAGEMENT, AppMenu.M2_ADJUSMENT_APPROVED);
            boolean privApprovedOpname = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_STOCK_MANAGEMENT, AppMenu.M2_OPNAME_APPROVED);
            
            
            boolean purchRetur = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_STOCK_MANAGEMENT, AppMenu.M2_PURCHASE_RETUR);
            boolean newRetur = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_STOCK_MANAGEMENT, AppMenu.M2_NEW_RETUR);
            boolean newReturArc = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_STOCK_MANAGEMENT, AppMenu.M2_RETUR_ARCHIVES);
            boolean madjustment = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_STOCK_MANAGEMENT, AppMenu.M2_ADJUSMENT);            
            boolean mOpname = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_STOCK_MANAGEMENT, AppMenu.M2_OPNAME);
            boolean mCosting = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_STOCK_MANAGEMENT, AppMenu.M2_COSTING);
            boolean mRepack = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_STOCK_MANAGEMENT, AppMenu.M2_REPACK);
            boolean mDirectRetur = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_STOCK_MANAGEMENT, AppMenu.M2_DIRECT_RETUR);
            boolean dataSync = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_DATA_SYNCHRONIZATION, AppMenu.M2_DATA_SYNCHRONIZATION);

//Retail Report
            boolean rptPoReport = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_RETAIL_REPORT, AppMenu.M2_PO_REPORT);
            boolean rptIncomReport = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_RETAIL_REPORT, AppMenu.M2_INCOMING_REPORT);
            boolean rptPoRetur = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_RETAIL_REPORT, AppMenu.M2_PO_RETUR);
            boolean rptItemTransfer = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_RETAIL_REPORT, AppMenu.M2_ITEM_TRANSFER);
            boolean rptStockReport = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_RETAIL_REPORT, AppMenu.M2_STOCK_REPORT);
            boolean rptStockCard = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_RETAIL_REPORT, AppMenu.M2_STOCK_CARD);
            boolean rptCostingReport = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_RETAIL_REPORT, AppMenu.M2_COSTING_REPORT);
            boolean rptRepackReport = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_RETAIL_REPORT, AppMenu.M2_REPACK_REPORT);
            boolean rptFakturPajak = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_RETAIL_REPORT, AppMenu.M2_FAKTUR_PAJAK);
            boolean rptFakturPajakSales = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_RETAIL_REPORT, AppMenu.M2_FAKTUR_PAJAK_SALES);
            boolean rptAjustmentGA = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_RETAIL_REPORT, AppMenu.M2_AJUSTMENT_GA);
            boolean rptInventory = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_RETAIL_REPORT, AppMenu.M2_INVENTORY_REPORT);
            
//Master Data

            boolean mstMaintenance = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MASTER_MAINTENANCE, AppMenu.M2_MASTER_CONFIGURATION);
            boolean mstAccounting = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MASTER_MAINTENANCE, AppMenu.M2_MASTER_ACCOUNTING);

            boolean mstMaterial = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MASTER_MAINTENANCE, AppMenu.M2_MASTER_MATERIAL);
            boolean mstPriceChange = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MASTER_MAINTENANCE, AppMenu.M2_MASTER_PRICE_CHANGE);
            boolean mstStandarStock = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MASTER_MAINTENANCE, AppMenu.M2_MASTER_STANDAR_STOCK);
            boolean mstPromotion = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MASTER_MAINTENANCE, AppMenu.M2_MASTER_PROMOTION);
            boolean mstCategory = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MASTER_MAINTENANCE, AppMenu.M2_MASTER_CATEGORY);
            boolean mstSubCategory = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MASTER_MAINTENANCE, AppMenu.M2_MASTER_SUB_CATEGORY);
            
            boolean mstProduct = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MASTER_MAINTENANCE, AppMenu.M2_MASTER_PRODUCT);
            boolean mstAsset = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MASTER_MAINTENANCE, AppMenu.M2_MASTER_ASSET);

            boolean mstMerk = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MASTER_MAINTENANCE, AppMenu.M2_MASTER_MERK);
            boolean mstCompany = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MASTER_MAINTENANCE, AppMenu.M2_MASTER_COMPANY);

            boolean mstGeneral = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MASTER_MAINTENANCE, AppMenu.M2_MASTER_GENERAL);
            boolean mstMember = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MASTER_MAINTENANCE, AppMenu.M2_MASTER_MEMBER);
            boolean mstCashier = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MASTER_MAINTENANCE, AppMenu.M2_MASTER_CASHIER);
            boolean mstBackupData = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MASTER_MAINTENANCE, AppMenu.M2_MASTER_BACKUP_DATA);
            boolean mstMenu = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MASTER_MAINTENANCE, AppMenu.M2_MASTER_MENU);
            boolean mstResto = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MASTER_MAINTENANCE, AppMenu.M2_MASTER_RESTO);
            boolean mstApprovedMaterial = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MASTER_MAINTENANCE, AppMenu.M2_APPROVE_MATERIAL);

//Administrator
            boolean sysConfig = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_ADMINISTRATOR, AppMenu.M2_SYSTEM_CONFIG);
            boolean administrator = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_ADMINISTRATOR, AppMenu.M2_ADMINISTRATOR);
            boolean genUser = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_ADMINISTRATOR, AppMenu.M2_GEN_USER);
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
            boolean mConfigurationPriv = false; //appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_INV_MASTER, AppMenu.M2_INV_CONFIGURATION);
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

            boolean mPOReport = true;
            boolean mPORetur = true;
            boolean mItemTransfer = true;
            boolean mStockReport = true;
            boolean mPaymantReport = true;

//Data Synchronization
            boolean datasyncPriv = true;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_INV_DATASYNC, AppMenu.M2_INV_DATASYNC);

//============= POS priv ======================

            boolean posPReqPriv = true;// QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MENU_POSPURCHASEREQUEST);
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
            boolean posApprove2Priv = true;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_INCOMING, AppMenu.M2_RECEIVING_ADJUSMENT);
            boolean posApprove3Priv = true; //QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MENU_POSAPPROVAL_3);
            boolean posApprove4Priv = true; //QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MENU_POSAPPROVAL_4);
            boolean custNewPriv = true;
            boolean custQueryPriv = true;


%>
