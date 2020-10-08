
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.general.*" %>
<%@ page import = "com.project.system.*" %>
<%@ page import = "com.project.admin.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.main.entity.*" %>
<%@ page import = "com.project.fms.transaction.*" %>
<%@ page import = "com.project.ccs.postransaction.receiving.*" %>
<%@ page import = "com.project.ccs.postransaction.purchase.*" %>
<%@ page import = "com.project.*" %>

<%@ include file = "../main/javainit.jsp" %>
<% int  appObjCode = 1;// AppObjInfo.composeObjCode(AppObjInfo.--, AppObjInfo.--, AppObjInfo.--); %>
<%@ include file = "../main/check.jsp" %>
<%
/* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
boolean privAdd=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ADD));
boolean privUpdate=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_UPDATE));
boolean privDelete=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_DELETE));
%>
<%
boolean bankPriv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MENU_BANK, AppMenu.M2_MENU_BANK_PAYMENT_ON_PO);
%>
<!-- Jsp Block -->
<%!
	public double getTotalDetail(Vector listx){
		double result = 0;
		if(listx!=null && listx.size()>0){
			for(int i=0; i<listx.size(); i++){
				BanknonpoPaymentDetail crd = (BanknonpoPaymentDetail)listx.get(i);
				result = result + crd.getAmount();
			}
		}
		return result;
	}
	
	public BankpoPaymentDetail getBankpoPaymentDetail(Receive ii, Vector bankpoPaymentDetail){	
		BankpoPaymentDetail bpd = new BankpoPaymentDetail();		
		try{
			if(bankpoPaymentDetail!=null && bankpoPaymentDetail.size()>0){
				for(int i=0; i<bankpoPaymentDetail.size(); i++){
					BankpoPaymentDetail x = (BankpoPaymentDetail)bankpoPaymentDetail.get(i);
					if(x.getInvoiceId()==ii.getOID()){
						return x;
					}
				}
			}
		}
		catch(Exception e){
			System.out.println("\nerror : "+e.toString()+"\n");
		}		
		return bpd;		
	}
	
	
	public static String getAccountRecursif(Coa coa, long oid, boolean isPostableOnly){	
		
		System.out.println("in recursif : "+coa.getOID());
		
		String result = "";
		if(!coa.getStatus().equals(I_Project.ACCOUNT_LEVEL_POSTABLE)){
			
			System.out.println("not postable ...");
			
			Vector coas = DbCoa.list(0,0, "acc_ref_id="+coa.getOID(), "code");
			
			System.out.println(coas);
			
			if(coas!=null && coas.size()>0){
				for(int i=0; i<coas.size(); i++){
					
					Coa coax = (Coa)coas.get(i);												
					String str = "";
													
					if(!isPostableOnly){
						switch(coax.getLevel()){
							case 1 : 											
								break;
							case 2 : 
								str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
								break;
							case 3 :
								str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
								break;
							case 4 :
								str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
								break;
							case 5 :
								str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
								break;				
						}
					}
					
					result = result + "<option value=\""+coax.getOID()+"\""+((oid==coax.getOID()) ? "selected" : "")+">"+str+coax.getCode()+" - "+coax.getName()+"</option>";
					
					if(!coax.getStatus().equals(I_Project.ACCOUNT_LEVEL_POSTABLE)){
						result = result + getAccountRecursif(coax, oid, isPostableOnly);
					}
					
					
				}
			}
		}
		
		return result;
	}
	
%>
<%
	CmdBankpoPayment ctrlBankpoPayment = new CmdBankpoPayment(request);
	long oidBankpoPayment = JSPRequestValue.requestLong(request, "hidden_bankpo_payment_id");
	//out.println("oidBankpoPayment : "+oidBankpoPayment);
	long oidVendor = JSPRequestValue.requestLong(request, "hidden_vendor_id");
	//out.println("oidVendor : "+oidVendor);

	Vendor vendor = new Vendor();
	if(oidVendor!=0) {
		try{
			vendor = DbVendor.fetchExc(oidVendor);
		} catch(Exception e){}
	}
	
	int iErrCode = JSPMessage.NONE;
	String errMsg = "";
	String whereClause = "vendor_id="+oidVendor + " and status = 'CHECKED'";
	String orderClause = "";
	int iJSPCommand = JSPRequestValue.requestCommand(request);
	int start = JSPRequestValue.requestInt(request, "start");

	JSPLine ctrLine = new JSPLine();	
	iErrCode = ctrlBankpoPayment.action(iJSPCommand , oidBankpoPayment);
	errMsg = ctrlBankpoPayment.getMessage();
	
	JspBankpoPayment jspBankpoPayment = ctrlBankpoPayment.getForm();
	BankpoPayment bankpoPayment = ctrlBankpoPayment.getBankpoPayment();
	
	if(oidBankpoPayment==0){
		oidBankpoPayment = bankpoPayment.getOID();
	}
	
	//out.println("oidBankpoPayment : "+oidBankpoPayment);
			
	int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");

	InvoiceSrc invSrc = new InvoiceSrc();
	if(session.getValue("SRC_POPAY")!=null){
		invSrc = (InvoiceSrc)session.getValue("SRC_POPAY");
	}

	Vector invoices = QrInvoice.getOpenInvoiceByVendor(oidVendor, invSrc);
	//out.println("<br>** 123 ** invoices : "+invoices);

	/*variable declaration*/
	int recordToGet = 10;
	String msgString = "";

	Vector listBankpoPayment = new Vector(1,1);

	/*count list All BankpoPayment*/
	int vectSize = DbBankpoPayment.getCount(whereClause);

	String msgStringMain =  ctrlBankpoPayment.getMessage();

	if((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV )||
	  (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)){
			start = ctrlBankpoPayment.actionList(iJSPCommand, start, vectSize, recordToGet);
	 } 


//END OF MAIN -- > continue to detail bellow
%>

<%
//	long oidBankpoPaymentDetail = JSPRequestValue.requestLong(request, "hidden_bankpo_payment_detail_id");

//	CmdBankpoPaymentDetail ctrlBankpoPaymentDetail = new CmdBankpoPaymentDetail(request);
	Vector listBankpoPaymentDetail = new Vector(1,1);
	listBankpoPaymentDetail = DbReceive.list(start,recordToGet, whereClause , orderClause);
	//out.println("<br>listBankpoPaymentDetail : "+listBankpoPaymentDetail);
	
	Vector vBPD = new Vector();
	if(listBankpoPaymentDetail!=null && listBankpoPaymentDetail.size()>0){		
		for(int i=0; i<listBankpoPaymentDetail.size(); i++){			
			Receive pi = (Receive)listBankpoPaymentDetail.get(i);
			int chk = JSPRequestValue.requestInt(request, "chk_"+pi.getOID());		
			
			if(chk==1){	
				double payment = JSPRequestValue.requestDouble(request, "payment_amount_"+pi.getOID());
				double invPayment = JSPRequestValue.requestDouble(request, "inv_curr_amount_"+pi.getOID());
				String memo = JSPRequestValue.requestString(request, "memo_"+pi.getOID());
				double excrate = JSPRequestValue.requestDouble(request, "exc_rate_"+pi.getOID());
									
				BankpoPaymentDetail ii = new BankpoPaymentDetail();
				ii.setBankpoPaymentId(bankpoPayment.getOID());
				ii.setMemo(memo);		
				ii.setInvoiceId(pi.getOID());
				ii.setCurrencyId(pi.getCurrencyId());
				ii.setBookedRate(excrate);
				ii.setPaymentByInvCurrencyAmount(invPayment);
				ii.setPaymentAmount(payment);			
									
				vBPD.add(ii);					
			}
		}
	}

	if(iJSPCommand==JSPCommand.SAVE && bankpoPayment.getOID()!=0 && iErrCode==0){
		DbBankpoPaymentDetail.insertItems(bankpoPayment.getOID(), vBPD);
	}
	if(bankpoPayment.getOID()!=0 && iJSPCommand==JSPCommand.SUBMIT){
		Vector vBPDx = DbBankpoPaymentDetail.list(0,0, "bankpo_payment_id="+bankpoPayment.getOID(), "");
		//out.print(vBPDx.size());
		DbReceive.checkForClosed(bankpoPayment.getOID(), vBPDx);
	}


//	int iErrCodeMain = ctrlBankpoPaymentDetail.action(iJSPCommand , oidBankpoPaymentDetail);
//	JspBankpoPaymentDetail jspBankpoPaymentDetail = ctrlBankpoPaymentDetail.getForm();

	/*count list All BankpoPaymentDetail*/
//	vectSize = DbBankpoPaymentDetail.getCount(whereClause);

	/*switch list BankpoPaymentDetail*/
/*	if((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV )||
	  (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)){
			start = ctrlBankpoPaymentDetail.actionList(iJSPCommand, start, vectSize, recordToGet);
	 } 
	/* end switch list*/

/*	BankpoPaymentDetail bankpoPaymentDetail = ctrlBankpoPaymentDetail.getBankpoPaymentDetail();
	msgString =  ctrlBankpoPaymentDetail.getMessage();

	/* get record to display */

	/*handle condition if size of record to display = 0 and start > 0 	after delete*/
/*	if (listBankpoPaymentDetail.size() < 1 && start > 0)
	{
		 if (vectSize - recordToGet > recordToGet)
				start = start - recordToGet;   //go to JSPCommand.PREV
		 else{
			 start = 0 ;
			 iJSPCommand = JSPCommand.FIRST;
			 prevJSPCommand = JSPCommand.FIRST; //go to JSPCommand.FIRST
		 }
		 listBankpoPaymentDetail = DbBankpoPaymentDetail.list(start,recordToGet, whereClause , orderClause);
	}
*/
	//Vector accLinks = DbAccLink.list(0,0, "type='"+I_Project.ACC_LINK_GROUP_BANK+"' and location_id="+sysCompany.getSystemLocation(), "");
	
	Vector accLinks = DbAccLink.list(0,0, "type='"+I_Project.ACC_LINK_GROUP_BANK_PO_PAYMENT_CREDIT+"' and (location_id="+sysCompany.getSystemLocation()+" or location_id=0)", "");
									  
	ExchangeRate eRate = DbExchangeRate.getStandardRate();	
	Vector accountBalance = DbAccLink.getBankAccountBalance(accLinks);
	
//	double balance = 0;
//	double totalDetail = getTotalDetail(listBankpoPaymentDetail);

%>

<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
<head>
<!-- #BeginEditable "javascript" --> 
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title><%=systemTitle%></title>
<link href="../css/css.css" rel="stylesheet" type="text/css" />

<script language="JavaScript">

<%if(!bankPriv){%>
	window.location="<%=approot%>/nopriv.jsp";
<%}%>
						
var sysDecSymbol = "<%=sSystemDecimalSymbol%>";
var usrDigitGroup = "<%=sUserDigitGroup%>";
var usrDecSymbol = "<%=sUserDecimalSymbol%>";


function cmdCheckIt(oid){
	//alert(oid);
	<%if(invoices!=null && invoices.size()>0){
		for(int i=0; i<invoices.size(); i++){
			Vector v = (Vector)invoices.get(i);
			Receive invoice = (Receive)v.get(1);
	%>		
			if(oid=='<%=invoice.getOID()%>'){
				//alert('ini tercheck : '+oid);
				if(document.frmbankpopayment.chk_<%=invoice.getOID()%>.checked){
					
					var bal = document.frmbankpopayment.inv_balance_<%=invoice.getOID()%>.value;
					var balidr = document.frmbankpopayment.balance_idr_<%=invoice.getOID()%>.value;
					
					document.frmbankpopayment.inv_curr_amount_<%=invoice.getOID()%>.value=bal;
					document.frmbankpopayment.payment_amount_<%=invoice.getOID()%>.value=balidr;					
					document.frmbankpopayment.h_inv_curr_amount_<%=invoice.getOID()%>.value=bal;
					document.frmbankpopayment.h_payment_amount_<%=invoice.getOID()%>.value=balidr;					
					document.frmbankpopayment.inv_curr_amount_<%=invoice.getOID()%>.disabled=false;
					document.frmbankpopayment.payment_amount_<%=invoice.getOID()%>.disabled=false;
					
					var total = document.frmbankpopayment.<%=JspBankpoPayment.colNames[JspBankpoPayment.JSP_AMOUNT] %>.value;
					total = cleanNumberFloat(total, sysDecSymbol, usrDigitGroup, usrDecSymbol);
					balidr = cleanNumberFloat(balidr, sysDecSymbol, usrDigitGroup, usrDecSymbol);
					
					//alert("total : "+total);
					//alert("balidr : "+balidr);
					
					document.frmbankpopayment.<%=JspBankpoPayment.colNames[JspBankpoPayment.JSP_AMOUNT] %>.value = formatFloat(''+(parseFloat(total) + parseFloat(balidr)), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 
					document.frmbankpopayment.tot.value = formatFloat(''+(parseFloat(total) + parseFloat(balidr)), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 
					
				}
				else{				
					var paymentIdr = document.frmbankpopayment.payment_amount_<%=invoice.getOID()%>.value;					
					paymentIdr = cleanNumberFloat(paymentIdr, sysDecSymbol, usrDigitGroup, usrDecSymbol);
					
					document.frmbankpopayment.inv_curr_amount_<%=invoice.getOID()%>.value="0.00";
					document.frmbankpopayment.payment_amount_<%=invoice.getOID()%>.value="0.00";					
					document.frmbankpopayment.inv_curr_amount_<%=invoice.getOID()%>.disabled=true;
					document.frmbankpopayment.payment_amount_<%=invoice.getOID()%>.disabled=true;					
					document.frmbankpopayment.h_inv_curr_amount_<%=invoice.getOID()%>.value="0.00";
					document.frmbankpopayment.h_payment_amount_<%=invoice.getOID()%>.value="0.00";					
					
					var total = document.frmbankpopayment.<%=JspBankpoPayment.colNames[JspBankpoPayment.JSP_AMOUNT] %>.value;
					total = cleanNumberFloat(total, sysDecSymbol, usrDigitGroup, usrDecSymbol);					
					
					//alert("total : "+total);
					//alert("balidr : "+balidr);
					
					document.frmbankpopayment.<%=JspBankpoPayment.colNames[JspBankpoPayment.JSP_AMOUNT] %>.value = formatFloat(''+(parseFloat(total) - parseFloat(paymentIdr)), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 
					document.frmbankpopayment.tot.value = formatFloat(''+(parseFloat(total) - parseFloat(paymentIdr)), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 
				}
				
			}
	<%}}%>
	
	cmdGetBalance();
	
}

function getAmount(oid){

	<%if(invoices!=null && invoices.size()>0){
	
		for(int i=0; i<invoices.size(); i++){
			Vector v = (Vector)invoices.get(i);
			Receive invoice = (Receive)v.get(1);
	%>		
			if(oid=='<%=invoice.getOID()%>'){
					
					var currpayment = document.frmbankpopayment.inv_curr_amount_<%=invoice.getOID()%>.value;
					currpayment = cleanNumberFloat(currpayment, sysDecSymbol, usrDigitGroup, usrDecSymbol);					
				
					
					var totAp = document.frmbankpopayment.inv_balance_<%=invoice.getOID()%>.value;
					totAp = cleanNumberFloat(totAp, sysDecSymbol, usrDigitGroup, usrDecSymbol);
					
					if(parseFloat(totAp)<parseFloat(currpayment)){
						alert("Payment amount is over the account payable,\nSystem will edit the data");
						currpayment = totAp;
					}					
					
					document.frmbankpopayment.inv_curr_amount_<%=invoice.getOID()%>.value = formatFloat(''+currpayment, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 
					
					var hcurrpayment = document.frmbankpopayment.h_inv_curr_amount_<%=invoice.getOID()%>.value;
					hcurrpayment = cleanNumberFloat(hcurrpayment, sysDecSymbol, usrDigitGroup, usrDecSymbol);
					
					var exc = document.frmbankpopayment.exc_rate_<%=invoice.getOID()%>.value;
					exc = cleanNumberFloat(exc, sysDecSymbol, usrDigitGroup, usrDecSymbol);					
					
					var payment = parseFloat(currpayment) * parseFloat(exc);					
					document.frmbankpopayment.payment_amount_<%=invoice.getOID()%>.value = formatFloat(''+payment, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 										
					
					var hpayment = parseFloat(hcurrpayment) * parseFloat(exc);					
					
					var total = document.frmbankpopayment.<%=JspBankpoPayment.colNames[JspBankpoPayment.JSP_AMOUNT] %>.value;
					total = cleanNumberFloat(total, sysDecSymbol, usrDigitGroup, usrDecSymbol);
					
					//alert("total : "+total);				
					//alert("(parseFloat(total) - parseFloat(hpayment) + parseFloat(payment)) : "+(parseFloat(total) - parseFloat(hpayment) + parseFloat(payment)));
					
					document.frmbankpopayment.<%=JspBankpoPayment.colNames[JspBankpoPayment.JSP_AMOUNT] %>.value = formatFloat(''+(parseFloat(total) - parseFloat(hpayment) + parseFloat(payment)), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 
					document.frmbankpopayment.tot.value = formatFloat(''+(parseFloat(total) - parseFloat(hpayment) + parseFloat(payment)), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 
					
					document.frmbankpopayment.h_inv_curr_amount_<%=invoice.getOID()%>.value = currpayment;
								
			}
	<%}}%>
	
	cmdGetBalance();
}

function cmdSetCheckBox(){
	//alert(oid);
	<%if(invoices!=null && invoices.size()>0){
		for(int i=0; i<invoices.size(); i++){
			Vector v = (Vector)invoices.get(i);
			Receive invoice = (Receive)v.get(1);
	%>		
				if(!document.frmbankpopayment.chk_<%=invoice.getOID()%>.checked){
					document.frmbankpopayment.inv_curr_amount_<%=invoice.getOID()%>.value="0.00";
					document.frmbankpopayment.payment_amount_<%=invoice.getOID()%>.value="0.00";					
					document.frmbankpopayment.inv_curr_amount_<%=invoice.getOID()%>.disabled=true;
					document.frmbankpopayment.payment_amount_<%=invoice.getOID()%>.disabled=true;
				}
			
	<%}}%>
}

function cmdPrintJournal(){	 
	window.open("<%=printroot%>.report.RptBankpoPaymentPDF?oid=<%=appSessUser.getLoginId()%>&po_id=<%=oidBankpoPayment%>");
}

function cmdUpdatePayment(oid){
	<%if(invoices!=null && invoices.size()>0){
		for(int i=0; i<invoices.size(); i++){
			Vector v = (Vector)invoices.get(i);			
			Receive invoice = (Receive)v.get(1);
			//System.out.println(invoice.getOID());
	%>
			if(oid=='<%=invoice.getOID()%>'){	
				var money = document.all.tot_saldo_akhir.innerHTML;
				money = removeChar(money);	
				money = cleanNumberFloat(money, sysDecSymbol, usrDigitGroup, usrDecSymbol);
				
				var paymentAmountOld = document.frmbankpopayment.inv_curr_amount_<%=invoice.getOID()%>.value;
				paymentAmountOld = removeChar(paymentAmountOld);	
				paymentAmountOld = cleanNumberFloat(paymentAmountOld, sysDecSymbol, usrDigitGroup, usrDecSymbol);
				if(paymentAmountOld.length==0 || isNaN(paymentAmountOld)){
					paymentAmountOld = "0";
					document.frmbankpopayment.inv_curr_amount_<%=invoice.getOID()%>.value="0";
				}
				
				var maxBalance = document.frmbankpopayment.inv_balance_<%=invoice.getOID()%>.value;
				maxBalance = removeChar(maxBalance);	
				maxBalance = cleanNumberFloat(maxBalance, sysDecSymbol, usrDigitGroup, usrDecSymbol);
				
				var paymentAmount = document.frmbankpopayment.payment_amount_<%=invoice.getOID()%>.value;
				paymentAmount = removeChar(paymentAmount);
				paymentAmount = cleanNumberFloat(paymentAmount, sysDecSymbol, usrDigitGroup, usrDecSymbol);
				
				var erate = document.frmbankpopayment.exc_rate_<%=invoice.getOID()%>.value;				
				erate = cleanNumberFloat(erate, sysDecSymbol, usrDigitGroup, usrDecSymbol);				

				var subtotal = document.frmbankpopayment.tot.value;
				subtotal = removeChar(subtotal);	
				subtotal = cleanNumberFloat(subtotal, sysDecSymbol, usrDigitGroup, usrDecSymbol);
				if(subtotal.length==0 || isNaN(subtotal)){
					subtotal = "0";
					document.frmbankpopayment.tot.value="0";
				}
				
				if(parseInt(money)>parseInt(paymentAmount)){
					if(parseInt(paymentAmount)>parseInt(maxBalance*erate)){
						alert('Payment amount higer than maximum allowance');
						document.frmbankpopayment.payment_amount_<%=invoice.getOID()%>.value="0";
						document.frmbankpopayment.inv_curr_amount_<%=invoice.getOID()%>.value = "0";								
						document.frmbankpopayment.payment_amount_<%=invoice.getOID()%>.focus();		
						paymentAmount = 0;	
					}
					else{
						document.frmbankpopayment.payment_amount_<%=invoice.getOID()%>.value = formatFloat(paymentAmount, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 
						document.frmbankpopayment.inv_curr_amount_<%=invoice.getOID()%>.value = formatFloat(paymentAmount/erate, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 
					}
				}
				else{
					alert('Payment amount higer than maximum allowance');
					document.frmbankpopayment.payment_amount_<%=invoice.getOID()%>.value="0";
					document.frmbankpopayment.inv_curr_amount_<%=invoice.getOID()%>.value = "0";								
					document.frmbankpopayment.payment_amount_<%=invoice.getOID()%>.focus();		
					paymentAmount = 0;	
				}
											
				subtotal = parseFloat(subtotal) - parseFloat(paymentAmountOld*erate) + parseFloat(paymentAmount);												

				document.frmbankpopayment.tot.value = formatFloat(subtotal, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);;
				document.frmbankpopayment.<%=jspBankpoPayment.colNames[jspBankpoPayment.JSP_AMOUNT] %>.value = formatFloat(subtotal, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);;
			}
				
	<%}}%>
}

function cmdUpdateInvAmount(oid){
	<%if(invoices!=null && invoices.size()>0){
		for(int i=0; i<invoices.size(); i++){
			Vector v = (Vector)invoices.get(i);			
			Receive invoice = (Receive)v.get(1);
	%>
			if(oid=='<%=invoice.getOID()%>'){	
				var money = document.all.tot_saldo_akhir.innerHTML;
				money = removeChar(money);	
				money = cleanNumberFloat(money, sysDecSymbol, usrDigitGroup, usrDecSymbol);

				var paymentAmountOld = document.frmbankpopayment.payment_amount_<%=invoice.getOID()%>.value;
				paymentAmountOld = removeChar(paymentAmountOld);	
				paymentAmountOld = cleanNumberFloat(paymentAmountOld, sysDecSymbol, usrDigitGroup, usrDecSymbol);
				if(paymentAmountOld.length==0 || isNaN(paymentAmountOld)){
					paymentAmountOld = "0";
					document.frmbankpopayment.payment_amount_<%=invoice.getOID()%>.value="0";
				}
				
				var maxBalance = document.frmbankpopayment.inv_balance_<%=invoice.getOID()%>.value;
				maxBalance = removeChar(maxBalance);	
				maxBalance = cleanNumberFloat(maxBalance, sysDecSymbol, usrDigitGroup, usrDecSymbol);
				
				var paymentAmount = document.frmbankpopayment.inv_curr_amount_<%=invoice.getOID()%>.value;
				paymentAmount = removeChar(paymentAmount);
				paymentAmount = cleanNumberFloat(paymentAmount, sysDecSymbol, usrDigitGroup, usrDecSymbol);
				
				var erate = document.frmbankpopayment.exc_rate_<%=invoice.getOID()%>.value;				
				erate = cleanNumberFloat(erate, sysDecSymbol, usrDigitGroup, usrDecSymbol);				
			
				if(parseInt(money)>parseInt(paymentAmount*erate)){
					if(parseInt(paymentAmount*erate)>parseInt(maxBalance*erate)){
						alert('Payment amount higer than maximum allowance');
						document.frmbankpopayment.payment_amount_<%=invoice.getOID()%>.value="0";
						document.frmbankpopayment.inv_curr_amount_<%=invoice.getOID()%>.value = "0";								
						document.frmbankpopayment.inv_curr_amount_<%=invoice.getOID()%>.focus();	
						paymentAmount = 0;		
					}
					else{
						document.frmbankpopayment.inv_curr_amount_<%=invoice.getOID()%>.value = formatFloat(paymentAmount, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 
						document.frmbankpopayment.payment_amount_<%=invoice.getOID()%>.value = formatFloat(paymentAmount * erate, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 
					}
				}else{
					alert('Payment amount higer than maximum allowance');
					document.frmbankpopayment.payment_amount_<%=invoice.getOID()%>.value="0";
					document.frmbankpopayment.inv_curr_amount_<%=invoice.getOID()%>.value = "0";								
					document.frmbankpopayment.inv_curr_amount_<%=invoice.getOID()%>.focus();	
					paymentAmount = 0;						
				}
				
				var subtotal = document.frmbankpopayment.tot.value;
				subtotal = removeChar(subtotal);	
				subtotal = cleanNumberFloat(subtotal, sysDecSymbol, usrDigitGroup, usrDecSymbol);
				if(subtotal.length==0 || isNaN(subtotal)){
					subtotal = "0";
					document.frmbankpopayment.tot.value="0";
				}
							
				subtotal = parseFloat(subtotal) - parseFloat(paymentAmountOld) + parseFloat(paymentAmount*erate);				
				
				document.frmbankpopayment.tot.value = formatFloat(subtotal, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);;
				document.frmbankpopayment.<%=jspBankpoPayment.colNames[jspBankpoPayment.JSP_AMOUNT] %>.value = formatFloat(subtotal, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);;
			}
	<%}}%>
}


function cmdGetAmount(){
	<%if(invoices!=null && invoices.size()>0){
		for(int i=0; i<invoices.size(); i++){
			Vector v = (Vector)invoices.get(i);			
			Receive invoice = (Receive)v.get(1);
	%>
				var balance = document.frmbankpopayment.inv_balance_<%=invoice.getOID()%>.value;
				var erate = document.frmbankpopayment.exc_rate_<%=invoice.getOID()%>.value;
				
				balance = cleanNumberFloat(balance, sysDecSymbol, usrDigitGroup, usrDecSymbol);
				erate = cleanNumberFloat(erate, sysDecSymbol, usrDigitGroup, usrDecSymbol);				
				
				document.frmbankpopayment.balance_idr_<%=invoice.getOID()%>.value = formatFloat(balance * erate, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 
				
	<%}}%>
}

function removeChar(number){
	
	var ix;
	var result = "";
	for(ix=0; ix<number.length; ix++){
		var xx = number.charAt(ix);
		//alert(xx);
		if(!isNaN(xx)){
			result = result + xx;
		}
		else{
			if(xx==',' || xx=='.'){
				result = result + xx;
			}
		}
	}
	
	return result;
}

function cmdGetBalance(){
	
	var x = document.frmbankpopayment.<%=jspBankpoPayment.colNames[jspBankpoPayment.JSP_COA_ID]%>.value;
	//alert(x);
	<%if(accountBalance!=null && accountBalance.size()>0){
		for(int i=0; i<accountBalance.size(); i++){
			Coa c = (Coa)accountBalance.get(i);
			
			c.setOpeningBalance(c.getOpeningBalance()+bankpoPayment.getAmount());
			
	%>
		
		//alert("opening balanace : "+<%=c.getOpeningBalance()%>);
		
		if(x=='<%=c.getOID()%>'){
			document.frmbankpopayment.account_balance.value="<%=JSPFormater.formatNumber(c.getOpeningBalance(),"###.##")%>";
			
			//alert('<%=c.getOpeningBalance()%>');
			//if(<%=DbCoa.getCoaBalance(c.getOID())%><0)
			//{
			//	document.all.tot_saldo_akhir.innerHTML = "(" + formatFloat("<%=JSPFormater.formatNumber((DbCoa.getCoaBalance(c.getOID())<0) ? DbCoa.getCoaBalance(c.getOID())*-1 : DbCoa.getCoaBalance(c.getOID()),"###.##")%>", '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace)+")";
			//}else
			//{
			//	document.all.tot_saldo_akhir.innerHTML = formatFloat("<%=JSPFormater.formatNumber((DbCoa.getCoaBalance(c.getOID())<0) ? DbCoa.getCoaBalance(c.getOID())*-1 : DbCoa.getCoaBalance(c.getOID()),"###.##")%>", '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);
			//}
			
			<%if(c.getOpeningBalance()<0){%>
				document.all.tot_saldo_akhir.innerHTML = "(" + formatFloat("<%=JSPFormater.formatNumber(c.getOpeningBalance()*-1,"###.##")%>", '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace)+")";
			<%}else{%>
				document.all.tot_saldo_akhir.innerHTML = formatFloat("<%=JSPFormater.formatNumber(c.getOpeningBalance(),"###.##")%>", '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);
			<%}%>

			<%if(c.getOpeningBalance()<1){%>
				//alert('No account balance to do transaction.');
				document.all.command_line.style.display="none";
				document.all.emptymessage.style.display="";
			<%}else{%>				
				document.all.command_line.style.display="";
				document.all.emptymessage.style.display="none";
			<%}%>
		}
	<%}}%>
	
	var totalPayment = document.frmbankpopayment.<%=jspBankpoPayment.colNames[jspBankpoPayment.JSP_AMOUNT]%>.value;
	totalPayment = removeChar(totalPayment);	
	totalPayment = cleanNumberFloat(totalPayment, sysDecSymbol, usrDigitGroup, usrDecSymbol);
	var totalBank = document.frmbankpopayment.account_balance.value;
	totalBank = removeChar(totalBank);	
	totalBank = cleanNumberFloat(totalBank, sysDecSymbol, usrDigitGroup, usrDecSymbol);
	
	//alert("totalPayment : "+totalPayment);
	//alert("totalBank : "+totalBank);
	//alert("bankPOPay : "+bankPOPay);
	
	if(parseFloat(totalPayment)>(parseFloat(totalBank)) || parseFloat(totalBank)==0){
		//alert('No account balance to do transaction.');
		document.all.command_line.style.display="none";
		document.all.emptymessage.style.display="";
	}else{
		document.all.command_line.style.display="";
		document.all.emptymessage.style.display="none";
	}
	
	
}

function cmdSubmitCommand(){
	document.frmbankpopayment.command.value="<%=JSPCommand.SUBMIT%>";
	document.frmbankpopayment.action="bankpopayment.jsp";
	document.frmbankpopayment.submit();
}

function cmdAdd(){
	document.frmbankpopayment.hidden_bankpo_payment_id.value="0";
	document.frmbankpopayment.command.value="<%=JSPCommand.ADD%>";
	document.frmbankpopayment.prev_command.value="<%=prevJSPCommand%>";
	document.frmbankpopayment.action="bankpopayment.jsp";
	document.frmbankpopayment.submit();
}

function cmdAsk(oidBankpoPayment){
	document.frmbankpopayment.hidden_bankpo_payment_id.value=oidBankpoPayment;
	document.frmbankpopayment.command.value="<%=JSPCommand.ASK%>";
	document.frmbankpopayment.prev_command.value="<%=prevJSPCommand%>";
	document.frmbankpopayment.action="bankpopayment.jsp";
	document.frmbankpopayment.submit();
}

function cmdConfirmDelete(oidBankpoPayment){
	document.frmbankpopayment.hidden_bankpo_payment_id.value=oidBankpoPayment;
	document.frmbankpopayment.command.value="<%=JSPCommand.DELETE%>";
	document.frmbankpopayment.prev_command.value="<%=prevJSPCommand%>";
	document.frmbankpopayment.action="bankpopayment.jsp";
	document.frmbankpopayment.submit();
}
function cmdSave(){
	document.frmbankpopayment.command.value="<%=JSPCommand.SAVE%>";
	document.frmbankpopayment.prev_command.value="<%=prevJSPCommand%>";
	document.frmbankpopayment.action="bankpopayment.jsp";
	document.frmbankpopayment.submit();
}

function cmdEdit(oidBankpoPayment){
	document.frmbankpopayment.hidden_bankpo_payment_id.value=oidBankpoPayment;
	document.frmbankpopayment.command.value="<%=JSPCommand.EDIT%>";
	document.frmbankpopayment.prev_command.value="<%=prevJSPCommand%>";
	document.frmbankpopayment.action="bankpopayment.jsp";
	document.frmbankpopayment.submit();
	}

function cmdCancel(oidBankpoPayment){
	document.frmbankpopayment.hidden_bankpo_payment_id.value=oidBankpoPayment;
	document.frmbankpopayment.command.value="<%=JSPCommand.EDIT%>";
	document.frmbankpopayment.prev_command.value="<%=prevJSPCommand%>";
	document.frmbankpopayment.action="bankpopayment.jsp";
	document.frmbankpopayment.submit();
}

function cmdBack(){
	document.frmbankpopayment.command.value="<%=JSPCommand.BACK%>";
	document.frmbankpopayment.action="bankpopayment.jsp";
	document.frmbankpopayment.submit();
	}

function cmdListFirst(){
	document.frmbankpopayment.command.value="<%=JSPCommand.FIRST%>";
	document.frmbankpopayment.prev_command.value="<%=JSPCommand.FIRST%>";
	document.frmbankpopayment.action="bankpopayment.jsp";
	document.frmbankpopayment.submit();
}

function cmdListPrev(){
	document.frmbankpopayment.command.value="<%=JSPCommand.PREV%>";
	document.frmbankpopayment.prev_command.value="<%=JSPCommand.PREV%>";
	document.frmbankpopayment.action="bankpopayment.jsp";
	document.frmbankpopayment.submit();
	}

function cmdListNext(){
	document.frmbankpopayment.command.value="<%=JSPCommand.NEXT%>";
	document.frmbankpopayment.prev_command.value="<%=JSPCommand.NEXT%>";
	document.frmbankpopayment.action="bankpopayment.jsp";
	document.frmbankpopayment.submit();
}

function cmdListLast(){
	document.frmbankpopayment.command.value="<%=JSPCommand.LAST%>";
	document.frmbankpopayment.prev_command.value="<%=JSPCommand.LAST%>";
	document.frmbankpopayment.action="bankpopayment.jsp";
	document.frmbankpopayment.submit();
}

//-------------- script control line -------------------
	function MM_swapImgRestore() { //v3.0
		var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
	}

function MM_preloadImages() { //v3.0
		var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
		var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
		if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
	}

function MM_findObj(n, d) { //v4.0
		var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
		d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
		if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
		for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
		if(!x && document.getElementById) x=document.getElementById(n); return x;
	}

function MM_swapImage() { //v3.0
		var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
		if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
	}

</script>
<script type="text/javascript">
<!--
function MM_swapImgRestore() { //v3.0
  var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
}
function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}

function MM_findObj(n, d) { //v4.01
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
  if(!x && d.getElementById) x=d.getElementById(n); return x;
}

function MM_swapImage() { //v3.0
  var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
   if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
}
//-->
</script>
<!-- #EndEditable -->
</head>
<body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','../images/savedoc2.gif','../images/post_journal2.gif','../images/print2.gif','../images/back2.gif','../images/close2.gif')">
<table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
  <tr> 
    <td valign="top"> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
        <tr> 
          <td height="96"> 
            <!-- #BeginEditable "header" --> 
            <%@ include file="../main/hmenu.jsp"%> 
            <!-- #EndEditable -->
          </td>
        </tr>
        <tr> 
          <td valign="top"> 
            <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
              <!--DWLayoutTable-->
              <tr> 
                <td width="165" height="100%" valign="top" style="background:url(<%=approot%>/images/leftmenu-bg.gif) repeat-y"> 
                  <!-- #BeginEditable "menu" --> 
				  <%@ include file="../main/menu.jsp"%>
                  <%@ include file="../calendar/calendarframe.jsp"%>
                  <!-- #EndEditable -->
                </td>
                <td width="100%" valign="top"> 
                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr> 
                      <td class="title"><!-- #BeginEditable "title" -->
					  <%
					  String navigator = "<font class=\"lvl1\">Bank</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">PO Payment</span></font>";
					  %>
					  <%@ include file="../main/navigator.jsp"%>
					  <!-- #EndEditable --></td>
                    </tr>
                    <!--tr> 
                      <td><img src="<%=approot%>/images/title-sp.gif" width="584" height="1"></td> 
                    </tr-->
                    <tr> 
                      <td><!-- #BeginEditable "content" --> 
                        <form name="frmbankpopayment" method ="post" action="">
                          <input type="hidden" name="command" value="<%=iJSPCommand%>">
                          <input type="hidden" name="vectSize" value="<%=vectSize%>">
                          <input type="hidden" name="start" value="<%=start%>">
                          <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                          <input type="hidden" name="hidden_bankpo_payment_id" value="<%=oidBankpoPayment%>">
						  <input type="hidden" name="hidden_vendor_id" value="<%=oidVendor%>">
						  <input type="hidden" name="<%=jspBankpoPayment.colNames[jspBankpoPayment.JSP_OPERATOR_ID]%>" value="<%=appSessUser.getUserOID()%>">
                          <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                          <input type="hidden" name="<%=jspBankpoPayment.colNames[jspBankpoPayment.JSP_CURRENCY_ID]%>" value="<%=sysCompany.getBookingCurrencyId()%>">
                          <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr align="left" valign="top"> 
                              <td height="8" valign="top" colspan="3" class="container"> 
                                <table width="100%" border="0" cellspacing="1" cellpadding="0">
                                  <tr align="left"> 
                                    <td height="21" valign="middle" width="12%">&nbsp;</td>
                                    <td height="21" valign="middle" width="28%">&nbsp;</td>
                                    <td height="21" valign="middle" width="13%">&nbsp;</td>
                                    <td height="21" colspan="2" width="47%" class="comment" valign="top"> 
                                      <div align="right">Date : <%=JSPFormater.formatDate(new Date(), "dd MMMM yyyy")%>&nbsp;, &nbsp;Operator : <%=appSessUser.getLoginId()%>&nbsp;&nbsp;<%= jspBankpoPayment.getErrorMsg(jspBankpoPayment.JSP_OPERATOR_ID) %>&nbsp;</div>
                                    </td>
                                  </tr>
                                  <tr align="left"> 
                                    <td height="21" valign="middle" colspan="3" bgcolor="#FFFFCC"> 
                                      <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                        <tr> 
                                          <td colspan="2" background="../images/line1.gif"><img src="../images/line1.gif" width="42" height="1"></td>
                                        </tr>
                                        <tr> 
                                          <td width="64%"><b><u>VENDOR</u></b></td>
                                          <td width="36%"><b><u>Total Balance 
                                            <%=baseCurrency.getCurrencyCode()%></u></b></td>
                                        </tr>
                                        <tr> 
                                          <td width="64%"><b><%=vendor.getCode()+" - "+vendor.getName()%> 
                                            <input type="hidden" name="<%=jspBankpoPayment.colNames[jspBankpoPayment.JSP_VENDOR_ID]%>" value="<%=vendor.getOID()%>">
                                            </b></td>
                                          <td width="36%"><b>Rp. <%=JSPFormater.formatNumber(DbBankpoPayment.getTotalInvoiceFin(oidVendor) - DbBankpoPayment.getTotalPaymentByVendorFin(oidVendor), "#,###.##")%></b> 
                                            <%
										  //out.println(DbBankpoPayment.getTotalInvoiceFin(oidVendor));
										  %>
                                          </td>
                                        </tr>
                                        <tr> 
                                          <td width="64%"> <%=vendor.getAddress()+((vendor.getCity().length()>0) ? ", "+vendor.getCity(): "")+((vendor.getState().length()>0) ? "<br>"+vendor.getState(): "")%> <%=((vendor.getPhone().length()>0) ? vendor.getPhone(): "")+((vendor.getFax().length()>0) ? vendor.getFax(): "")%></td>
                                          <td width="36%">&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td colspan="2" background="../images/line1.gif"><img src="../images/line1.gif" width="42" height="1"></td>
                                        </tr>
                                      </table>
                                    </td>
                                    <td height="21" colspan="2" width="47%" class="comment" valign="top">&nbsp;</td>
                                  </tr>
                                  <tr align="left"> 
                                    <td height="21" valign="middle" width="12%">&nbsp;</td>
                                    <td height="21" valign="middle" width="28%">&nbsp;</td>
                                    <td height="21" valign="middle" width="13%">&nbsp;</td>
                                    <td height="21" colspan="2" width="47%" class="comment" valign="top">&nbsp;</td>
                                  </tr>
                                  <tr align="left"> 
                                    <td height="21" valign="middle" width="12%">Payment 
                                      from Account</td>
                                    <td height="21" valign="middle" width="28%"> 
                                      <b> 
                                      <%									  
									  //out.println(bankpoPayment.getOID());									  
									  %>
                                      <select name="<%=jspBankpoPayment.colNames[jspBankpoPayment.JSP_COA_ID]%>" onChange="javascript:cmdGetBalance()">
                                        <%if(accLinks!=null && accLinks.size()>0){
										  		for(int i=0; i<accLinks.size(); i++){
													AccLink acl = (AccLink)accLinks.get(i);
													Coa coay = new Coa();
													try{
														coay = DbCoa.fetchExc(acl.getCoaId());
													}
													catch(Exception e){
													}
													
													if(bankpoPayment.getCoaId()==0 && i==0){
														bankpoPayment.setCoaId(acl.getCoaId());
													}
													
										  %>
                                        <option value="<%=acl.getCoaId()%>" <%if(acl.getCoaId()==bankpoPayment.getCoaId()){%>selected<%}%>><b><%=coay.getCode()+ " - "+coay.getName()%></b></option>
                                        <%=getAccountRecursif(coay, bankpoPayment.getCoaId(), isPostableOnly)%> 
                                        <%}}%>
                                      </select>
                                      </b><%= jspBankpoPayment.getErrorMsg(jspBankpoPayment.JSP_COA_ID) %></td>
                                    <td height="21" valign="middle" width="13%" nowrap>&nbsp;&nbsp;<b>Account 
                                      Balance <%=baseCurrency.getCurrencyCode()%></b>&nbsp;&nbsp;</td>
                                    <td height="21" colspan="2" width="47%" class="comment"> 
                                      <input type="hidden" name="account_balance" readOnly style="text-align:right">
                                      <b><a id="tot_saldo_akhir"></a></b></td>
                                  </tr>
                                  <tr align="left"> 
                                    <td height="21" valign="middle" width="12%">&nbsp;</td>
                                    <td height="21" valign="middle" width="28%">&nbsp; 
                                    </td>
                                    <td height="21" valign="middle" width="13%">&nbsp;&nbsp;Journal 
                                      Number</td>
                                    <td height="21" colspan="2" width="47%" class="comment" valign="top"> 
                                      <%
									  int counter = DbBankpoPayment.getNextCounter(bankpoPayment.getCoaId());
									  String strNumber = DbBankpoPayment.getNextNumber(counter, bankpoPayment.getCoaId());
									  
									  //out.println("bankpoPayment.getOID() : "+bankpoPayment.getOID());
									 // out.println("oidBankpoPayment : "+oidBankpoPayment);
									  
									  if(bankpoPayment.getOID()!=0){
											strNumber = bankpoPayment.getJournalNumber();
									  %>
                                      <input type="hidden" name="<%=jspBankpoPayment.colNames[jspBankpoPayment.JSP_JOURNAL_NUMBER] %>"  value="<%=bankpoPayment.getJournalNumber() %>" class="formElemen">
                                      <input type="hidden" name="<%=jspBankpoPayment.colNames[jspBankpoPayment.JSP_JOURNAL_COUNTER] %>"  value="<%=bankpoPayment.getJournalCounter() %>" class="formElemen">
                                      <input type="hidden" name="<%=jspBankpoPayment.colNames[jspBankpoPayment.JSP_JOURNAL_PREFIX] %>"  value="<%=bankpoPayment.getJournalPrefix() %>" class="formElemen">
                                      <%}
									  
									  %>
                                      <%=strNumber%> </td>
                                  </tr>
                                  <tr align="left"> 
                                    <td height="21" valign="middle" width="12%">Payment 
                                      Method</td>
                                    <td height="21" valign="middle" width="28%"> 
                                      <%
										Vector vpm = DbPaymentMethod.list(0,0, "", "");
										%>
                                      <select name="<%=jspBankpoPayment.colNames[jspBankpoPayment.JSP_PAYMENT_METHOD_ID]%>">
                                        <%if(vpm!=null && vpm.size()>0){
										  		for(int i=0; i<vpm.size(); i++){
													PaymentMethod pm = (PaymentMethod)vpm.get(i);
										  %>
                                        <option value="<%=pm.getOID()%>" <%if(pm.getOID()==bankpoPayment.getPaymentMethodId()){%>selected<%}%>><%=pm.getDescription()%></option>
                                        <%}}%>
                                      </select>
                                    </td>
                                    <td height="21" valign="middle" width="13%">&nbsp;&nbsp;Trans 
                                      Date</td>
                                    <td height="21" colspan="2" width="47%" class="comment" valign="top"> 
                                      <input name="<%=jspBankpoPayment.colNames[jspBankpoPayment.JSP_TRANS_DATE] %>" value="<%=JSPFormater.formatDate((bankpoPayment.getTransDate()==null) ? new Date() : bankpoPayment.getTransDate(), "dd/MM/yyyy")%>" size="11" readonly>
                                      <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmbankpopayment.<%=jspBankpoPayment.colNames[jspBankpoPayment.JSP_TRANS_DATE] %>);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> 
                                      <%= jspBankpoPayment.getErrorMsg(jspBankpoPayment.JSP_TRANS_DATE) %> </td>
                                  </tr>
                                  <tr align="left"> 
                                    <td height="21" valign="middle" width="12%" nowrap>Cheque/Transfer 
                                      Number</td>
                                    <td height="21" valign="middle" width="28%"> 
                                      <input type="text" name="<%=jspBankpoPayment.colNames[jspBankpoPayment.JSP_REF_NUMBER] %>"  value="<%= bankpoPayment.getRefNumber() %>" class="formElemen">
                                      <%= jspBankpoPayment.getErrorMsg(jspBankpoPayment.JSP_REF_NUMBER) %> </td>
                                    <td height="21" valign="middle" width="13%">&nbsp;&nbsp;Amount 
                                      <%=baseCurrency.getCurrencyCode()%> </td>
                                    <td height="21" colspan="2" width="47%" class="comment" valign="top"> 
                                      <input type="text" name="<%=jspBankpoPayment.colNames[jspBankpoPayment.JSP_AMOUNT] %>"  style="text-align:right" value="<%=JSPFormater.formatNumber(bankpoPayment.getAmount(), "#,###.##")%>" class="readonly" readonly size="25">
                                      <%= jspBankpoPayment.getErrorMsg(jspBankpoPayment.JSP_AMOUNT) %> </td>
                                  </tr>
                                  <tr align="left"> 
                                    <td height="21" valign="top" width="12%">Memo</td>
                                    <td height="21" valign="top" colspan="5"> 
                                      <textarea name="<%=jspBankpoPayment.colNames[jspBankpoPayment.JSP_MEMO] %>" class="formElemen" cols="120" rows="2"><%= bankpoPayment.getMemo() %></textarea>
                                      <%= jspBankpoPayment.getErrorMsg(jspBankpoPayment.JSP_MEMO) %> </td>
                                  <tr align="left"> 
                                    <td height="21" valign="top" width="12%">&nbsp;</td>
                                    <td height="21" valign="top" width="28%">&nbsp;</td>
                                    <td height="21" valign="top" width="13%">&nbsp;</td>
                                    <td height="21" colspan="2" width="47%" valign="top">&nbsp; 
                                  <tr align="left"> 
                                    <td height="21" valign="top" colspan="5"> 
                                      <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                        <tr> 
                                          <td> 
                                            <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                              <tr > 
                                                <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="17" height="10"></td>
                                                <td class="tab">Disbursement</td>
                                                <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                                <td class="tabheader"></td>
                                                <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                                <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                                <td width="100%" class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="10" height="10"></td>
                                              </tr>
                                            </table>
                                          </td>
                                        </tr>
                                        <tr> 
                                          <td> 
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                              <tr> 
                                                <td width="100%" class="page"> 
                                                  <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                    <tr> 
                                                      <td  class="tablehdr" width="2%">&nbsp;</td>
                                                      <td  class="tablehdr" width="9%" nowrap>Invoice/DO 
                                                        Number </td>
                                                      <td class="tablehdr" width="8%" nowrap>Inv. 
                                                        Currency</td>
                                                      <td class="tablehdr" width="11%">Balance</td>
                                                      <td class="tablehdr" width="6%" nowrap> 
                                                        Rate </td>
                                                      <td class="tablehdr" width="11%">Balance 
                                                        <%=baseCurrency.getCurrencyCode()%></td>
                                                      <td class="tablehdr" width="11%">Payment 
                                                        <%=baseCurrency.getCurrencyCode()%></td>
                                                      <td class="tablehdr" width="11%">Payment 
                                                        by Invoice<br>
                                                        Currency</td>
                                                      <td class="tablehdr" width="31%">Description</td>
                                                    </tr>
                                                    <%if(invoices!=null && invoices.size()>0){
													for(int i=0; i<invoices.size(); i++){
														Vector v = (Vector)invoices.get(i);
														
														Receive invoice = (Receive)v.get(1);
														
														//out.println("invoice : "+invoice.getOID());
														
														/*Coa c = new Coa();
														try{
															c = DbCoa.fetchExc(crd.getCoaId());
														}
														catch(Exception e){
														}
														
														String cssString = "tablecell";
														if(i%2!=0){
															cssString = "tablecell1";
														}
														*/
														BankpoPaymentDetail bpd = getBankpoPaymentDetail(invoice, vBPD);
														//out.println(bpd.getOID());
														//System.out.println("bpd = "+bpd.getMemo()+ "invoice = "+invoice.getOID()+ " - " +vBPD.size()+" bankpo_payment_id="+bankpoPayment.getOID());
														
														/*Vector vx = DbBankpoPaymentDetail.list(0,0, "invoice_id="+invoice.getOID()+" and bankpo_payment_id="+bankpoPayment.getOID(), "");
														BankpoPaymentDetail objx = new BankpoPaymentDetail();
														if(vx!=null && vx.size()>0){
															objx = (BankpoPaymentDetail)vx.get(0);
														}*/
																												
														
												%>
                                                    <tr> 
                                                      <td class="tablecell" width="2%"> 
                                                        <div align="center"> 
                                                          <input type="checkbox" name="chk_<%=invoice.getOID()%>" value="1" onClick="javascript:cmdCheckIt('<%=invoice.getOID()%>')" <%if(bpd.getPaymentAmount()!=0){%>checked<%}%>>
                                                        </div>
                                                      </td>
                                                      <td class="tablecell" width="9%"> 
                                                        <div align="center"> 
                                                          <%=invoice.getInvoiceNumber()+"/"+invoice.getDoNumber()%>
                                                        </div>
                                                      </td>
                                                      <td width="8%" class="tablecell"> 
                                                        <div align="center"> 
                                                          <%
														Currency c = new Currency();
														try{
															c = DbCurrency.fetchExc(invoice.getCurrencyId());
														}
														catch(Exception e){
														}														
														
														%>
                                                          <%=c.getCurrencyCode()%> </div>
                                                      </td>
                                                      <td width="11%" class="tablecell"> 
                                                        <div align="center"> 
                                                          <input type="text" name="inv_balance_<%=invoice.getOID()%>" value="<%=JSPFormater.formatNumber(DbReceive.getInvoiceBalance(invoice.getOID()), "#,###.##")%>"   style="text-align:right" size="15" class="readonly" readOnly>
                                                        </div>
                                                      </td>
                                                      <td width="6%" class="tablecell"> 
                                                        <div align="center"> 
                                                          <%
														  double exRateValue = 1;
														  if(c.getCurrencyCode().equals(IDRCODE)){
														  		exRateValue = eRate.getValueIdr();		 
														  }
														  else if(c.getCurrencyCode().equals(USDCODE)){
														  		exRateValue = eRate.getValueUsd();		 		
														  }
														  else{
														  		exRateValue = eRate.getValueEuro();		 		
														  }
														  %>
                                                          <input type="text" name="exc_rate_<%=invoice.getOID()%>" value="<%=JSPFormater.formatNumber(exRateValue, "#,###.##")%>"   style="text-align:right" size="5" class="readonly" readOnly>
                                                        </div>
                                                      </td>
                                                      <td width="11%" class="tablecell"> 
                                                        <div align="center"> 
                                                          <input type="text" name="balance_idr_<%=invoice.getOID()%>" value=""   style="text-align:right" size="15" class="readonly" readOnly>
                                                        </div>
                                                      </td>
                                                      <td width="11%" class="tablecell"> 
                                                        <div align="center"> 
                                                          <input type="hidden" name="h_payment_amount_<%=invoice.getOID()%>" value="<%=bpd.getPaymentAmount()%>">
                                                          <input type="text" name="payment_amount_<%=invoice.getOID()%>" value="<%=JSPFormater.formatNumber(bpd.getPaymentAmount(), "#,###.##")%>"   style="text-align:right" size="15" onClick="this.select()" class="readonly" readOnly>
                                                        </div>
                                                      </td>
                                                      <td width="11%" class="tablecell" nowrap> 
                                                        <div align="center"> 
                                                          <input type="hidden" name="h_inv_curr_amount_<%=invoice.getOID()%>" value="<%=bpd.getPaymentByInvCurrencyAmount()%>">
                                                          <%=c.getCurrencyCode()%> 
                                                          <input type="text" name="inv_curr_amount_<%=invoice.getOID()%>" value="<%=JSPFormater.formatNumber(bpd.getPaymentByInvCurrencyAmount(), "#,###.##")%>"   style="text-align:right" size="15" onClick="this.select()"  onBlur="javascript:getAmount('<%=invoice.getOID()%>')">
                                                        </div>
                                                      </td>
                                                      <td width="31%" class="tablecell"> 
                                                        <div align="left">
                                                          <input type="text" name="memo_<%=invoice.getOID()%>" size="25" value="<%=bpd.getMemo()%>">
                                                        </div>
                                                      </td>
                                                    </tr>
                                                    <%}}%>
                                                  </table>
                                                </td>
                                              </tr>
                                            </table>
                                          </td>
                                        </tr>
                                      </table>
                                    </td>
                                  </tr>
                                  <tr id="command_line"> 
                                    <td colspan="5"> 
                                      <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                        <tr> 
                                          <td width="69%">&nbsp;</td>
                                          <td width="31%">&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td width="69%"> 
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                              <tr> 
                                                <td height="5"></td>
                                              </tr>
                                              <tr> 
                                                <td width="43%">&nbsp;</td>
                                              </tr>
                                              <%
											if(bankpoPayment.getOID()==0 || bankpoPayment.getStatus().equals(I_Project.STATUS_NOT_POSTED))
											{
												if(iJSPCommand==JSPCommand.SAVE ) {
													if(iErrCode!=0)	{
										%>
                                              <tr> 
                                                <td height="5"> 
                                                  <table border="0" cellpadding="2" cellspacing="0" class="warning" align="left" width="254">
                                                    <tr> 
                                                      <td width="20"><img src="../images/error.gif" width="18" height="18"></td>
                                                      <td width="167" nowrap>Error, 
                                                        incomplete data input</td>
                                                    </tr>
                                                  </table>
                                                </td>
                                              </tr>
                                              <%	}else{%>
                                              <tr> 
                                                <td height="5"> 
                                                  <table border="0" cellpadding="2" cellspacing="0" class="success" align="left" width="254">
                                                    <tr> 
                                                      <td width="20"><img src="../images/success.gif" width="20" height="20"></td>
                                                      <td width="167" nowrap>Data 
                                                        has been saved</td>
                                                    </tr>
                                                  </table>
                                                </td>
                                              </tr>
                                              <%	}%>
                                              <tr> 
                                                <td width="43%" height="4"></td>
                                              </tr>
                                              <%
												}
											}
										%>
                                              <%
											if(bankpoPayment.getOID()==0 || bankpoPayment.getStatus().equals(I_Project.STATUS_NOT_POSTED))
											//if(bankpoPayment.getOID()!=0 && bankpoPayment.getAmount()>0 && iErrCode==0 && bankpoPayment.getStatus().equals(I_Project.STATUS_NOT_POSTED)){
											{
										%>
                                              <tr> 
                                                <td width="43%"><a href="javascript:cmdSave()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('print1111','','../images/savedoc2.gif',1)"><img src="../images/savedoc.gif" name="print1111" border="0"></a></td>
                                              </tr>
                                              <%
											}
										%>
                                            </table>
                                          </td>
                                          <td width="31%"> 
                                            <table width="100%" border="0" cellspacing="1" cellpadding="5" class="boxed1">
                                              <tr> 
                                                <td width="36%"> 
                                                  <div align="left"><b>Total <%=baseCurrency.getCurrencyCode()%> : </b></div>
                                                </td>
                                                <td width="64%"> 
                                                  <div align="right"> 
                                                    <input type="text" name="tot" value="<%=JSPFormater.formatNumber(bankpoPayment.getAmount(), "#,###.##")%>" style="text-align:right" size="20" class="readonly" readOnly>
                                                  </div>
                                                </td>
                                              </tr>
                                            </table>
                                          </td>
                                        </tr>
                                      </table>
                                    </td>
                                  </tr>
                                  <tr> 
                                    <td colspan="5">&nbsp;</td>
                                  </tr>
                                  <%
										if(bankpoPayment.getOID()!=0 && bankpoPayment.getAmount()>0 && iErrCode==0 && bankpoPayment.getStatus().equals(I_Project.STATUS_NOT_POSTED)){
								  %>
                                  <tr> 
                                    <td colspan="5"> 
                                      <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                        <tr> 
                                          <td height="2">&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td height="2" background="../images/line.gif" ><img src="../images/line.gif"></td>
                                        </tr>
                                      </table>
                                    </td>
                                  </tr>
                                  <tr> 
                                    <td colspan="5"> 
                                      <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                        <tr> 
                                          <td width="8%"><a href="javascript:cmdSubmitCommand()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('post','','../images/post_journal2.gif',1)"><img src="../images/post_journal.gif" name="post" width="92" height="22" border="0"></a></td>
                                          <td width="64%">&nbsp;</td>
                                          <td width="28%"> 
                                            <table border="0" cellpadding="5" cellspacing="0" class="info" width="233" align="right">
                                              <tr> 
                                                <td width="19"><img src="../images/inform.gif" width="20" height="20"></td>
                                                <td width="194" nowrap>Journal 
                                                  is ready to be posted</td>
                                              </tr>
                                            </table>
                                          </td>
                                        </tr>
                                      </table>
                                    </td>
                                  </tr>
                                  <%}%>
                                  <%if(bankpoPayment.getOID()!=0 && iErrCode==0 && bankpoPayment.getStatus().equals(I_Project.STATUS_POSTED)){%>
                                  <tr> 
                                    <td colspan="5"> 
                                      <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                        <tr> 
                                          <td height="2">&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td height="2" background="../images/line.gif" ><img src="../images/line.gif"></td>
                                        </tr>
                                      </table>
                                    </td>
                                  </tr>
                                  <tr> 
                                    <td colspan="5"> 
                                      <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                        <tr> 
                                          <td width="3%"><a href="javascript:cmdPrintJournal()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('print','','../images/print2.gif',1)"><img src="../images/print.gif" name="print" width="53" height="22" border="0"></a></td>
                                          <td width="3%">&nbsp;</td>
                                          <td width="9%"><a href="javascript:cmdBack()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('print11','','../images/back2.gif',1)"><img src="../images/back.gif" name="print11"  border="0"></a></td>
                                          <td width="47%"><a href="<%=approot%>/home.jsp"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new11','','../images/close2.gif',1)"><img src="../images/close.gif" name="new11"  border="0"></a></td>
                                          <td width="38%"> 
                                            <table border="0" cellpadding="5" cellspacing="0" class="success" align="right">
                                              <tr> 
                                                <td width="20"><img src="../images/success.gif" width="20" height="20"></td>
                                                <td width="220">Journal has been 
                                                  posted successfully</td>
                                              </tr>
                                            </table>
                                          </td>
                                        </tr>
                                      </table>
                                    </td>
                                  </tr>
                                  <%}%>
                                  <tr id="emptymessage"> 
                                    <td colspan="5"> 
                                      <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                        <tr> 
                                          <td> 
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                              <tr> 
                                                <td height="2">&nbsp;</td>
                                              </tr>
                                              <tr> 
                                                <td height="2" background="../images/line.gif" ><img src="../images/line.gif"></td>
                                              </tr>
                                            </table>
                                          </td>
                                        </tr>
                                        <tr> 
                                          <td> 
                                            <div align="right" class="msgnextaction"> 
                                              <table border="0" cellpadding="5" cellspacing="0" class="warning" align="right" width="317">
                                                <tr> 
                                                  <td width="2"><img src="../images/error.gif" width="20" height="20"></td>
                                                  <td width="320" nowrap>Not enought 
                                                    bank balance to do any transaction</td>
                                                </tr>
                                              </table>
                                            </div>
                                          </td>
                                        </tr>
                                      </table>
                                    </td>
                                  </tr>
                                  <tr align="left"> 
                                    <td height="21" valign="top" width="12%">&nbsp;</td>
                                    <td height="21" valign="top" width="28%">&nbsp;</td>
                                    <td height="21" valign="top" width="13%">&nbsp;</td>
                                    <td height="21" colspan="2" width="47%" valign="top">&nbsp;</td>
                                  </tr>
                                  <tr align="left"> 
                                    <td height="21" valign="top" width="12%">&nbsp;</td>
                                    <td height="21" valign="top" width="28%">&nbsp;</td>
                                    <td height="21" valign="top" width="13%">&nbsp;</td>
                                    <td height="21" colspan="2" width="47%" valign="top">&nbsp;</td>
                                  </tr>
                                  <tr align="left"> 
                                    <td height="21" valign="top" width="12%">&nbsp;</td>
                                    <td height="21" valign="top" width="28%">&nbsp;</td>
                                    <td height="21" valign="top" width="13%">&nbsp;</td>
                                    <td height="21" colspan="2" width="47%" valign="top">&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td width="12%">&nbsp;</td>
                                    <td width="28%">&nbsp;</td>
                                    <td width="13%">&nbsp;</td>
                                    <td width="47%">&nbsp;</td>
                                  </tr>
                                  <tr align="left" > 
                                    <td colspan="5" valign="top"> 
                                      <div align="left"></div>
                                    </td>
                                  </tr>
                                </table>
                              </td>
                            </tr>
                          </table>
                          <script language="JavaScript">
						cmdGetAmount();
						cmdGetBalance();
						
						//checkbox
						cmdSetCheckBox();
						</script>
						  
                        </form>
                        
                       <!-- #EndEditable -->
                      </td>
                    </tr>
                    
                    <tr> 
                      <td>&nbsp;</td>
                    </tr>
                  </table>
                </td>
              </tr>
            </table>
          </td>
        </tr>
        <tr> 
          <td height="25"> 
            <!-- #BeginEditable "footer" --> 
            <%@ include file="../main/footer.jsp"%>
            <!-- #EndEditable -->
          </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
</body>
<!-- #EndTemplate --></html>
