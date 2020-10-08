<%@ page import="com.project.admin.*"%>
<%
session.setMaxInactiveInterval(2500000);

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
		response.sendRedirect(approot+"/index.jsp");	
	}

} catch (Exception exc){
  	System.out.println(" ==> Exception during check user");
	appSessUser = null;
	response.sendRedirect(approot+"/index.jsp");	
}

//System.out.println("appSessUser.getUserOID() "+appSessUser.getUserOID());
//System.out.println("session "+session.getMaxInactiveInterval());

if(appSessUser==null){// || appSessUser.getUserOID()==0){
	appSessUser = new QrUserSession();
	//response.sendRedirect(approot+"/index.jsp");	
}


//boolean homePriv = false;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_HOMEPAGE);

boolean cashRecPriv = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_CASH, AppMenu.M2_MENU_CASH_RECERIVE);
boolean cashPayPriv = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_CASH, AppMenu.M2_MENU_CASH_PETTYCASH_PAYMENT);
boolean cashRepPriv = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_CASH, AppMenu.M2_MENU_CASH_PETTYCASH_REPLENISHMENT);
boolean cashLinkPriv = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_CASH, AppMenu.M2_MENU_CASH_ACCLINK);
boolean cashArcPriv = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_CASH, AppMenu.M2_MENU_CASH_ARCHIVES);

//out.println("cashRec : "+cashRec+", cashPay : "+cashPay+", cashRep : "+cashRep+", cashLink : "+cashLink+", cashArc : "+cashArc);

boolean bankDepPriv = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_BANK, AppMenu.M2_MENU_BANK_DEPOSIT);
boolean bankPOPriv = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_BANK, AppMenu.M2_MENU_BANK_PAYMENT_ON_PO);
boolean bankNonPriv = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_BANK, AppMenu.M2_MENU_BANK_PAYMENT_NON_PO);
boolean bankLinkPriv = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_BANK, AppMenu.M2_MENU_BANK_ACCLINK);
boolean bankArcPriv = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_BANK, AppMenu.M2_MENU_BANK_ARCHIVES);

//out.println("<br>bankDep : "+bankDep+", bankPO : "+bankPO+", bankNon : "+bankNon+", bankLink : "+bankLink+", bankArc : "+bankArc);

boolean payableInvPriv = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_ACCPAYABLE, AppMenu.M2_MENU_ACCPAYABLE_INVOICE);
boolean payableArcPriv = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_ACCPAYABLE, AppMenu.M2_MENU_ACCPAYABLE_ARCHIVES);

boolean purchaseOrdPriv = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_PURCHASE, AppMenu.M2_MENU_PURCHASE_NEWORDER);
boolean purchaseVndPriv = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_PURCHASE, AppMenu.M2_MENU_PURCHASE_VENDOR);
boolean purchaseLinkPriv = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_PURCHASE, AppMenu.M2_MENU_PURCHASE_ACCLINK);
boolean purchaseArcPriv = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_PURCHASE, AppMenu.M2_MENU_PURCHASE_ARCHIVES);

boolean glNewPriv = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_GENERALLEDGER, AppMenu.M2_MENU_GENERALLEDGER_NEWGL);
boolean glArcPriv = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_GENERALLEDGER, AppMenu.M2_MENU_GENERALLEDGER_ARCHIVES);

boolean freportPriv = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_FINANCEREPROT, AppMenu.M2_MENU_FINANCEREPROT);

boolean dreportPriv = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_DONORREPORT, AppMenu.M2_MENU_DONORREPORT);

boolean datasyncPriv = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_DATASYNC, AppMenu.M2_MENU_DATASYNC);

boolean masterConfPriv = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_CONFIGURATION);
boolean masterCoaPriv = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_ACC_COA);
boolean masterCatPriv = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_ACC_COA_CATEGORY);
boolean masterGroupPriv = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_ACC_COA_GROUP_ALIAS);
boolean masterBookPriv = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_ACC_BOOKEEPING_RATE);
boolean masterPeriodPriv = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_ACC_PERIOD);
boolean masterWorkPlanPriv = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_WORKPLAN_DATA);
boolean masterAllocationPriv = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_WORKPLAN_EXPENSE_ALLOCATION);
boolean masterDonorPriv = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_WORKPLAN_DONOR_LIST);
boolean masterActPeriodPriv = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_WORKPLAN_PERIOD);
boolean masterEmpPriv = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_HRD_EMPLOYEE);
boolean masterDepartmentPriv = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_HRD_DEPARTMENT);
boolean masterCountryPriv = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_GENERAL_COUNTRY);
boolean masterCurrencyPriv = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_GENERAL_CURRENCY);
boolean masterTopPriv = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_GENERAL_TERMOFPAYMENT);
boolean masterShipPriv = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_GENERAL_SHIPPING_ADDRESS);
boolean masterPayMetPriv = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_GENERAL_PAYMENT_METHOD);
boolean masterLocationPriv = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_GENERAL_LOCATION);

boolean closingPeriodPriv = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_CLOSING, AppMenu.M2_MENU_CLOSING_ACCOUNT_PERIOD);
boolean closingYearlyPriv = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_CLOSING, AppMenu.M2_MENU_CLOSING_YEARLY);
boolean closingActPriv = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_CLOSING, AppMenu.M2_MENU_CLOSING_ACTIVITY_PERIOD);

boolean adminPriv = true;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_ADMINISTRATOR, AppMenu.M2_MENU_ADMINISTRATOR);

//-------------------- masing2 transaksi view & update ----------------
boolean cashRecView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_CASH, AppMenu.M2_MENU_CASH_RECERIVE, AppMenu.PRIV_VIEW);
boolean cashPayView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_CASH, AppMenu.M2_MENU_CASH_PETTYCASH_PAYMENT, AppMenu.PRIV_VIEW);
boolean cashRefView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_CASH, AppMenu.M2_MENU_CASH_PETTYCASH_REPLENISHMENT, AppMenu.PRIV_VIEW);
boolean cashRecUpdate = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_CASH, AppMenu.M2_MENU_CASH_RECERIVE, AppMenu.PRIV_UPDATE);
boolean cashPayUpdate = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_CASH, AppMenu.M2_MENU_CASH_PETTYCASH_PAYMENT, AppMenu.PRIV_UPDATE);
boolean cashRefUpdate = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_CASH, AppMenu.M2_MENU_CASH_PETTYCASH_REPLENISHMENT, AppMenu.PRIV_UPDATE);

boolean bankDepView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_BANK, AppMenu.M2_MENU_BANK_DEPOSIT, AppMenu.PRIV_VIEW);
boolean bankPOView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_BANK, AppMenu.M2_MENU_BANK_PAYMENT_ON_PO, AppMenu.PRIV_VIEW);
boolean bankNonpoView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_BANK, AppMenu.M2_MENU_BANK_PAYMENT_NON_PO, AppMenu.PRIV_VIEW);
boolean bankDepUpdate = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_BANK, AppMenu.M2_MENU_BANK_DEPOSIT, AppMenu.PRIV_UPDATE);
boolean bankPOUpdate = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_BANK, AppMenu.M2_MENU_BANK_PAYMENT_ON_PO, AppMenu.PRIV_UPDATE);
boolean bankNonpoUpdate = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_BANK, AppMenu.M2_MENU_BANK_PAYMENT_NON_PO, AppMenu.PRIV_UPDATE);

boolean payableInvView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_ACCPAYABLE, AppMenu.M2_MENU_ACCPAYABLE_INVOICE, AppMenu.PRIV_VIEW);
boolean payableInvUpdate = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_ACCPAYABLE, AppMenu.M2_MENU_ACCPAYABLE_INVOICE, AppMenu.PRIV_UPDATE);

boolean arCreate = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_ACCRECEIVABLE, AppMenu.M2_MENU_NEW_ACCRECEIVABLE);
boolean arArchives = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_ACCRECEIVABLE, AppMenu.M2_MENU_ACCRECEIVABLE_ARCHIVES);
boolean arCustomer = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_ACCRECEIVABLE, AppMenu.M2_MENU_ACCRECEIVABLE_CUSTOMER);


boolean akrualSetupPriv = true;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_ACCRECEIVABLE, AppMenu.M2_MENU_ACCRECEIVABLE_CUSTOMER);
boolean akrualProcessPriv = true;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_ACCRECEIVABLE, AppMenu.M2_MENU_ACCRECEIVABLE_CUSTOMER);

boolean assetSetupPriv = true;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_ACCRECEIVABLE, AppMenu.M2_MENU_ACCRECEIVABLE_CUSTOMER);
boolean assetProcessPriv = true;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_ACCRECEIVABLE, AppMenu.M2_MENU_ACCRECEIVABLE_CUSTOMER);


//titipan
boolean depoList = true;
boolean newDepo = true;
boolean returDepo  = true;
boolean sadloDepo = true;
boolean depoArchives = true;

//dp
boolean xxdepoList = true;
boolean xxnewDepo = true;
boolean xxreturDepo  = true;
boolean xxsadloDepo = true;
boolean xxdepoArchives = true;

//bymhd
boolean bymhdList = true;
boolean newBymhd = true;
boolean returBymhd  = true;
boolean sadloBymhd = true;
boolean bymhdArchives = true;

//minimarket
boolean xxMinimarketList = true;
boolean xxnewMinimarket = true;
boolean xxreturMinimarket  = true;
boolean xxsadloMinimarket = true;
boolean xxMinimarketArchives = true;

boolean anggotaKop = true;
boolean newPinjam = false;//true;
boolean angsurPinjam = false;// true;
boolean newPinjamBank = false;// true;
boolean angsurPinjamBank = false;// true;
boolean daftarBank= false;// true;
boolean akunPinjaman = false;// true;
boolean rekapPotonganGaji = false;



//boolean closingActPrivView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_CLOSING, AppMenu.M2_MENU_CLOSING_ACTIVITY_PERIOD, AppMenu.PRIV_VIEW);

//out.println("closingActPrivView : "+closingActPrivView);

//adminPriv = true;

//out.println("homePriv : "+homePriv+", cashPriv : "+cashPriv+", bankPriv : "+bankPriv+", payablePriv : "+payablePriv+", purchasePriv : "+purchasePriv);
//out.println("glPriv : "+glPriv+", freportPriv : "+freportPriv+", dreportPriv : "+dreportPriv+", datasyncPriv : "+datasyncPriv+", masterPriv : "+masterPriv);
//out.println("adminPriv : "+adminPriv);

//System.out.println("appSessUser.getUserOID() "+appSessUser.getUserOID());
//System.out.println("session "+session.getMaxInactiveInterval());

%>
