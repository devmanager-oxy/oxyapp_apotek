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

//if(appSessUser==null || appSessUser.getUserOID()==0){
//	response.sendRedirect(approot+"/index.jsp");
//}


//boolean homePriv = false;//true;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_HOMEPAGE);

boolean cashRecPriv = true;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_CASH, AppMenu.M2_MENU_CASH_RECERIVE);
boolean cashPayPriv = true;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_CASH, AppMenu.M2_MENU_CASH_PETTYCASH_PAYMENT);
boolean cashRepPriv = true;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_CASH, AppMenu.M2_MENU_CASH_PETTYCASH_REPLENISHMENT);
boolean cashLinkPriv = true;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_CASH, AppMenu.M2_MENU_CASH_ACCLINK);
boolean cashArcPriv = true;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_CASH, AppMenu.M2_MENU_CASH_ARCHIVES);

//out.println("cashRec : "+cashRec+", cashPay : "+cashPay+", cashRep : "+cashRep+", cashLink : "+cashLink+", cashArc : "+cashArc);

boolean bankDepPriv = true;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_BANK, AppMenu.M2_MENU_BANK_DEPOSIT);
boolean bankPOPriv = true;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_BANK, AppMenu.M2_MENU_BANK_PAYMENT_ON_PO);
boolean bankNonPriv = true;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_BANK, AppMenu.M2_MENU_BANK_PAYMENT_NON_PO);
boolean bankLinkPriv = true;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_BANK, AppMenu.M2_MENU_BANK_ACCLINK);
boolean bankArcPriv = true;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_BANK, AppMenu.M2_MENU_BANK_ARCHIVES);

//out.println("<br>bankDep : "+bankDep+", bankPO : "+bankPO+", bankNon : "+bankNon+", bankLink : "+bankLink+", bankArc : "+bankArc);

boolean payableInvPriv = true;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_ACCPAYABLE, AppMenu.M2_MENU_ACCPAYABLE_INVOICE);
boolean payableArcPriv = true;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_ACCPAYABLE, AppMenu.M2_MENU_ACCPAYABLE_ARCHIVES);

boolean purchaseOrdPriv = true;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_PURCHASE, AppMenu.M2_MENU_PURCHASE_NEWORDER);
boolean purchaseVndPriv = true;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_PURCHASE, AppMenu.M2_MENU_PURCHASE_VENDOR);
boolean purchaseLinkPriv = true;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_PURCHASE, AppMenu.M2_MENU_PURCHASE_ACCLINK);
boolean purchaseArcPriv = true;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_PURCHASE, AppMenu.M2_MENU_PURCHASE_ARCHIVES);

boolean glNewPriv = true;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_GENERALLEDGER, AppMenu.M2_MENU_GENERALLEDGER_NEWGL);
boolean glArcPriv = true;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_GENERALLEDGER, AppMenu.M2_MENU_GENERALLEDGER_ARCHIVES);

boolean freportPriv = true;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_FINANCEREPROT, AppMenu.M2_MENU_FINANCEREPROT);

boolean dreportPriv = true;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_DONORREPORT, AppMenu.M2_MENU_DONORREPORT);

boolean datasyncPriv = true;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_DATASYNC, AppMenu.M2_MENU_DATASYNC);

boolean masterConfPriv = true;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_CONFIGURATION);
boolean masterCoaPriv = true;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_ACC_COA);
boolean masterCatPriv = true;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_ACC_COA_CATEGORY);
boolean masterGroupPriv = true;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_ACC_COA_GROUP_ALIAS);
boolean masterBookPriv = true;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_ACC_BOOKEEPING_RATE);
boolean masterPeriodPriv = true;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_ACC_PERIOD);
boolean masterWorkPlanPriv = true;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_WORKPLAN_DATA);
boolean masterAllocationPriv = true;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_WORKPLAN_EXPENSE_ALLOCATION);
boolean masterDonorPriv = true;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_WORKPLAN_DONOR_LIST);
boolean masterActPeriodPriv = true;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_WORKPLAN_PERIOD);
boolean masterEmpPriv = true;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_HRD_EMPLOYEE);
boolean masterDepartmentPriv = true;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_HRD_DEPARTMENT);
boolean masterCountryPriv = true;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_GENERAL_COUNTRY);
boolean masterCurrencyPriv = true;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_GENERAL_CURRENCY);
boolean masterTopPriv = true;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_GENERAL_TERMOFPAYMENT);
boolean masterShipPriv = true;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_GENERAL_SHIPPING_ADDRESS);
boolean masterPayMetPriv = true;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_GENERAL_PAYMENT_METHOD);
boolean masterLocationPriv = true;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_GENERAL_LOCATION);

boolean closingPeriodPriv = true;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_CLOSING, AppMenu.M2_MENU_CLOSING_ACCOUNT_PERIOD);
boolean closingYearlyPriv = true;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_CLOSING, AppMenu.M2_MENU_CLOSING_YEARLY);
boolean closingActPriv = true;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_CLOSING, AppMenu.M2_MENU_CLOSING_ACTIVITY_PERIOD);

boolean adminPriv = true;//true;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_ADMINISTRATOR, AppMenu.M2_MENU_ADMINISTRATOR);

//-------------------- masing2 transaksi view & update ----------------
boolean cashRecView = true;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_CASH, AppMenu.M2_MENU_CASH_RECERIVE, AppMenu.PRIV_VIEW);
boolean cashPayView = true;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_CASH, AppMenu.M2_MENU_CASH_PETTYCASH_PAYMENT, AppMenu.PRIV_VIEW);
boolean cashRefView = true;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_CASH, AppMenu.M2_MENU_CASH_PETTYCASH_REPLENISHMENT, AppMenu.PRIV_VIEW);
boolean cashRecUpdate = true;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_CASH, AppMenu.M2_MENU_CASH_RECERIVE, AppMenu.PRIV_UPDATE);
boolean cashPayUpdate = true;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_CASH, AppMenu.M2_MENU_CASH_PETTYCASH_PAYMENT, AppMenu.PRIV_UPDATE);
boolean cashRefUpdate = true;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_CASH, AppMenu.M2_MENU_CASH_PETTYCASH_REPLENISHMENT, AppMenu.PRIV_UPDATE);

boolean bankDepView = true;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_BANK, AppMenu.M2_MENU_BANK_DEPOSIT, AppMenu.PRIV_VIEW);
boolean bankPOView = true;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_BANK, AppMenu.M2_MENU_BANK_PAYMENT_ON_PO, AppMenu.PRIV_VIEW);
boolean bankNonpoView = true;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_BANK, AppMenu.M2_MENU_BANK_PAYMENT_NON_PO, AppMenu.PRIV_VIEW);
boolean bankDepUpdate = true;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_BANK, AppMenu.M2_MENU_BANK_DEPOSIT, AppMenu.PRIV_UPDATE);
boolean bankPOUpdate = true;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_BANK, AppMenu.M2_MENU_BANK_PAYMENT_ON_PO, AppMenu.PRIV_UPDATE);
boolean bankNonpoUpdate = true;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_BANK, AppMenu.M2_MENU_BANK_PAYMENT_NON_PO, AppMenu.PRIV_UPDATE);

boolean payableInvView = true;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_ACCPAYABLE, AppMenu.M2_MENU_ACCPAYABLE_INVOICE, AppMenu.PRIV_VIEW);
boolean payableInvUpdate = true;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_ACCPAYABLE, AppMenu.M2_MENU_ACCPAYABLE_INVOICE, AppMenu.PRIV_UPDATE);

boolean arCreate = true;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_ACCRECEIVABLE, AppMenu.M2_MENU_NEW_ACCRECEIVABLE);
boolean arArchives = true;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_ACCRECEIVABLE, AppMenu.M2_MENU_ACCRECEIVABLE_ARCHIVES);
boolean arCustomer = true;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_ACCRECEIVABLE, AppMenu.M2_MENU_ACCRECEIVABLE_CUSTOMER);

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


boolean applyActivity = false;
boolean isYearlyClose = false;



//boolean closingActPrivView = true;//appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_CLOSING, AppMenu.M2_MENU_CLOSING_ACTIVITY_PERIOD, AppMenu.PRIV_VIEW);

//out.println("closingActPrivView : "+closingActPrivView);

//adminPriv = true;

//out.println("homePriv : "+homePriv+", cashPriv : "+cashPriv+", bankPriv : "+bankPriv+", payablePriv : "+payablePriv+", purchasePriv : "+purchasePriv);
//out.println("glPriv : "+glPriv+", freportPriv : "+freportPriv+", dreportPriv : "+dreportPriv+", datasyncPriv : "+datasyncPriv+", masterPriv : "+masterPriv);
//out.println("adminPriv : "+adminPriv);

//System.out.println("appSessUser.getUserOID() "+appSessUser.getUserOID());
//System.out.println("session "+session.getMaxInactiveInterval());

%>
<script language="JavaScript">
<%if(appSessUser==null || appSessUser.getUserOID()==0){%>
	window.location="<%=approot%>/index.jsp";
<%}%>
</script>