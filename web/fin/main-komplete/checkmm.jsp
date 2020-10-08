<%@ page import="com.project.admin.*"%>
<%@ page import="com.project.coorp.member.*"%>
<%
session.setMaxInactiveInterval(2500000);

Member loginMember =  new Member();
	
try{
	
	if(session.getValue("MEMBER_LOGIN")!=null){
		loginMember = (Member)session.getValue("MEMBER_LOGIN");		
	}    
	else{
		loginMember = null;
		response.sendRedirect(approot+"/indexmm.jsp");	
	}

} catch (Exception exc){
  	System.out.println(" ==> Exception during check user");
	loginMember = null;
	response.sendRedirect(approot+"/indexmm.jsp");	
}

//System.out.println("appSessUser.getUserOID() "+appSessUser.getUserOID());
//System.out.println("session "+session.getMaxInactiveInterval());

if(loginMember==null){// || appSessUser.getUserOID()==0){
	loginMember = new Member();
	//response.sendRedirect(approot+"/index.jsp");
}


//boolean homePriv = false;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_HOMEPAGE);

boolean cashRecPriv = false;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_CASH, AppMenu.M2_MENU_CASH_RECERIVE);
boolean cashPayPriv = false;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_CASH, AppMenu.M2_MENU_CASH_PETTYCASH_PAYMENT);
boolean cashRepPriv = false;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_CASH, AppMenu.M2_MENU_CASH_PETTYCASH_REPLENISHMENT);
boolean cashLinkPriv = false;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_CASH, AppMenu.M2_MENU_CASH_ACCLINK);
boolean cashArcPriv = false;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_CASH, AppMenu.M2_MENU_CASH_ARCHIVES);

//out.println("cashRec : "+cashRec+", cashPay : "+cashPay+", cashRep : "+cashRep+", cashLink : "+cashLink+", cashArc : "+cashArc);

boolean bankDepPriv = false;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_BANK, AppMenu.M2_MENU_BANK_DEPOSIT);
boolean bankPOPriv = false;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_BANK, AppMenu.M2_MENU_BANK_PAYMENT_ON_PO);
boolean bankNonPriv = false;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_BANK, AppMenu.M2_MENU_BANK_PAYMENT_NON_PO);
boolean bankLinkPriv = false;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_BANK, AppMenu.M2_MENU_BANK_ACCLINK);
boolean bankArcPriv = false;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_BANK, AppMenu.M2_MENU_BANK_ARCHIVES);

//out.println("<br>bankDep : "+bankDep+", bankPO : "+bankPO+", bankNon : "+bankNon+", bankLink : "+bankLink+", bankArc : "+bankArc);

boolean payableInvPriv = false;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_ACCPAYABLE, AppMenu.M2_MENU_ACCPAYABLE_INVOICE);
boolean payableArcPriv = false;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_ACCPAYABLE, AppMenu.M2_MENU_ACCPAYABLE_ARCHIVES);

boolean purchaseOrdPriv = false;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_PURCHASE, AppMenu.M2_MENU_PURCHASE_NEWORDER);
boolean purchaseVndPriv = false;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_PURCHASE, AppMenu.M2_MENU_PURCHASE_VENDOR);
boolean purchaseLinkPriv = false;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_PURCHASE, AppMenu.M2_MENU_PURCHASE_ACCLINK);
boolean purchaseArcPriv = false;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_PURCHASE, AppMenu.M2_MENU_PURCHASE_ARCHIVES);

boolean glNewPriv = false;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_GENERALLEDGER, AppMenu.M2_MENU_GENERALLEDGER_NEWGL);
boolean glArcPriv = false;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_GENERALLEDGER, AppMenu.M2_MENU_GENERALLEDGER_ARCHIVES);

boolean freportPriv = false;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_FINANCEREPROT, AppMenu.M2_MENU_FINANCEREPROT);

boolean dreportPriv = false;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_DONORREPORT, AppMenu.M2_MENU_DONORREPORT);

boolean datasyncPriv = false;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_DATASYNC, AppMenu.M2_MENU_DATASYNC);

boolean masterConfPriv = false;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_CONFIGURATION);
boolean masterCoaPriv = false;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_ACC_COA);
boolean masterCatPriv = false;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_ACC_COA_CATEGORY);
boolean masterGroupPriv = false;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_ACC_COA_GROUP_ALIAS);
boolean masterBookPriv = false;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_ACC_BOOKEEPING_RATE);
boolean masterPeriodPriv = false;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_ACC_PERIOD);
boolean masterWorkPlanPriv = false;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_WORKPLAN_DATA);
boolean masterAllocationPriv = false;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_WORKPLAN_EXPENSE_ALLOCATION);
boolean masterDonorPriv = false;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_WORKPLAN_DONOR_LIST);
boolean masterActPeriodPriv = false;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_WORKPLAN_PERIOD);
boolean masterEmpPriv = false;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_HRD_EMPLOYEE);
boolean masterDepartmentPriv = false;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_HRD_DEPARTMENT);
boolean masterCountryPriv = false;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_GENERAL_COUNTRY);
boolean masterCurrencyPriv = false;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_GENERAL_CURRENCY);
boolean masterTopPriv = false;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_GENERAL_TERMOFPAYMENT);
boolean masterShipPriv = false;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_GENERAL_SHIPPING_ADDRESS);
boolean masterPayMetPriv = false;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_GENERAL_PAYMENT_METHOD);
boolean masterLocationPriv = false;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_GENERAL_LOCATION);

boolean closingPeriodPriv = false;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_CLOSING, AppMenu.M2_MENU_CLOSING_ACCOUNT_PERIOD);
boolean closingYearlyPriv = false;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_CLOSING, AppMenu.M2_MENU_CLOSING_YEARLY);
boolean closingActPriv = false;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_CLOSING, AppMenu.M2_MENU_CLOSING_ACTIVITY_PERIOD);

boolean adminPriv = false;//true;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_ADMINISTRATOR, AppMenu.M2_MENU_ADMINISTRATOR);

//-------------------- masing2 transaksi view & update ----------------
boolean cashRecView = false;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_CASH, AppMenu.M2_MENU_CASH_RECERIVE, AppMenu.PRIV_VIEW);
boolean cashPayView = false;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_CASH, AppMenu.M2_MENU_CASH_PETTYCASH_PAYMENT, AppMenu.PRIV_VIEW);
boolean cashRefView = false;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_CASH, AppMenu.M2_MENU_CASH_PETTYCASH_REPLENISHMENT, AppMenu.PRIV_VIEW);
boolean cashRecUpdate = false;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_CASH, AppMenu.M2_MENU_CASH_RECERIVE, AppMenu.PRIV_UPDATE);
boolean cashPayUpdate = false;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_CASH, AppMenu.M2_MENU_CASH_PETTYCASH_PAYMENT, AppMenu.PRIV_UPDATE);
boolean cashRefUpdate = false;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_CASH, AppMenu.M2_MENU_CASH_PETTYCASH_REPLENISHMENT, AppMenu.PRIV_UPDATE);

boolean bankDepView = false;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_BANK, AppMenu.M2_MENU_BANK_DEPOSIT, AppMenu.PRIV_VIEW);
boolean bankPOView = false;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_BANK, AppMenu.M2_MENU_BANK_PAYMENT_ON_PO, AppMenu.PRIV_VIEW);
boolean bankNonpoView = false;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_BANK, AppMenu.M2_MENU_BANK_PAYMENT_NON_PO, AppMenu.PRIV_VIEW);
boolean bankDepUpdate = false;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_BANK, AppMenu.M2_MENU_BANK_DEPOSIT, AppMenu.PRIV_UPDATE);
boolean bankPOUpdate = false;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_BANK, AppMenu.M2_MENU_BANK_PAYMENT_ON_PO, AppMenu.PRIV_UPDATE);
boolean bankNonpoUpdate = false;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_BANK, AppMenu.M2_MENU_BANK_PAYMENT_NON_PO, AppMenu.PRIV_UPDATE);

boolean payableInvView = false;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_ACCPAYABLE, AppMenu.M2_MENU_ACCPAYABLE_INVOICE, AppMenu.PRIV_VIEW);
boolean payableInvUpdate = false;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_ACCPAYABLE, AppMenu.M2_MENU_ACCPAYABLE_INVOICE, AppMenu.PRIV_UPDATE);

boolean arCreate = false;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_ACCRECEIVABLE, AppMenu.M2_MENU_NEW_ACCRECEIVABLE);
boolean arArchives = false;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_ACCRECEIVABLE, AppMenu.M2_MENU_ACCRECEIVABLE_ARCHIVES);
boolean arCustomer = false;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_ACCRECEIVABLE, AppMenu.M2_MENU_ACCRECEIVABLE_CUSTOMER);


boolean akrualSetupPriv = false;//true;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_ACCRECEIVABLE, AppMenu.M2_MENU_ACCRECEIVABLE_CUSTOMER);
boolean akrualProcessPriv = false;//true;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_ACCRECEIVABLE, AppMenu.M2_MENU_ACCRECEIVABLE_CUSTOMER);

boolean depoList = false;//true;
boolean newDepo = false;//true;
boolean returDepo  = false;//true;
boolean sadloDepo = false;//true;
boolean depoArchives = false;//true;

boolean anggotaKop = false;
boolean newPinjam = true;
boolean angsurPinjam = true;
boolean newPinjamBank = true;
boolean angsurPinjamBank = true;
boolean rekapPotonganGaji = true;
boolean bukutabungan = true;


//boolean closingActPrivView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_CLOSING, AppMenu.M2_MENU_CLOSING_ACTIVITY_PERIOD, AppMenu.PRIV_VIEW);

//out.println("closingActPrivView : "+closingActPrivView);

//adminPriv = true;

//out.println("homePriv : "+homePriv+", cashPriv : "+cashPriv+", bankPriv : "+bankPriv+", payablePriv : "+payablePriv+", purchasePriv : "+purchasePriv);
//out.println("glPriv : "+glPriv+", freportPriv : "+freportPriv+", dreportPriv : "+dreportPriv+", datasyncPriv : "+datasyncPriv+", masterPriv : "+masterPriv);
//out.println("adminPriv : "+adminPriv);

//System.out.println("appSessUser.getUserOID() "+appSessUser.getUserOID());
//System.out.println("session "+session.getMaxInactiveInterval());

%>
