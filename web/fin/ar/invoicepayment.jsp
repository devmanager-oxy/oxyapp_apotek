<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.admin.*" %>
<%@ page import = "com.project.system.*" %>
<%@ page import = "com.project.main.db.*" %>
<!--package test -->
<%@ page import = "com.project.general.*" %>
<%@ page import = "com.project.fms.ar.*" %>
<%@ page import = "com.project.fms.master.*" %>
<%@ page import = "com.project.crm.project.*" %>
<%@ page import = "com.project.ccs.postransaction.sales.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.crm.*" %>
<%@ include file = "../main/javainit.jsp" %>
<% int  appObjCode = 1;// AppObjInfo.composeObjCode(AppObjInfo.--, AppObjInfo.--, AppObjInfo.--); %>
<%@ include file = "../main/check.jsp" %>
<%
	/* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
	boolean privAdd 	= true; //userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ADD));
	boolean privUpdate	= true; //userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_UPDATE));
	boolean privDelete	= true; //userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_DELETE));
%>
<%
	/* User Priv*/
	boolean masterPriv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MENU_ACCRECEIVABLE, AppMenu.M2_MENU_ACCRECEIVABLE_PAYMENT);
	boolean masterPrivView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_ACCRECEIVABLE, AppMenu.M2_MENU_ACCRECEIVABLE_PAYMENT, AppMenu.PRIV_VIEW);
	boolean masterPrivUpdate = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_ACCRECEIVABLE, AppMenu.M2_MENU_ACCRECEIVABLE_PAYMENT, AppMenu.PRIV_UPDATE);
%>
<!-- Jsp Block -->
<%!
	public String drawList(Vector objectClass, long arPayOid, String approot, int start, int recordToGet, double totalBalance)
	{
		JSPList jsplist = new JSPList();
		jsplist.setAreaWidth("100%");
		jsplist.setListStyle("listgen");
		jsplist.setTitleStyle("tablehdr");
		jsplist.setCellStyle("tablecell");
		jsplist.setCellStyle1("tablecell1");
		jsplist.setHeaderStyle("tablehdr");

		jsplist.addHeader("No","3%");
		jsplist.addHeader("Date","12%");
		jsplist.addHeader("Currency","6%");
		jsplist.addHeader("Receipt to Account","15%");
		jsplist.addHeader("Pay Amount","14%");
		jsplist.addHeader("Exchange Rate","10%");
		jsplist.addHeader("Amount","15%");
		jsplist.addHeader("Reference","25%");

		jsplist.setLinkRow(0);
		jsplist.setLinkSufix("");
		Vector lstData = jsplist.getData();
		Vector lstLinkData = jsplist.getLinkData();
		jsplist.setLinkPrefix("javascript:cmdEdit('");
		jsplist.setLinkSufix("')");
		jsplist.reset();
		int index = -1;

		int loopInt = 0;
		if(CONHandler.CONSVR_TYPE==CONHandler.CONSVR_MSSQL)
		{
			if((start + recordToGet)> objectClass.size())
			{
				loopInt = recordToGet - ((start + recordToGet) - objectClass.size());
			}
			else
			{
				loopInt = recordToGet;
			}
		}
		else
		{
			start = 0;
			loopInt = objectClass.size();
		}

		int count = 0;
		Vector rowx = new Vector();
		for(int i=start; (i<objectClass.size() && count<loopInt); i++)
		{
			count = count + 1;
			rowx = new Vector();
			ArPayment objArPayment = (ArPayment)objectClass.get(i);			
			if(arPayOid == objArPayment.getOID())
				index = i;

				rowx.add("<div align=\"center\">"+count+"</div>");
				String str_dt_Date = ""; 
				try
				{
					Date dt_Date = objArPayment.getDate();
					if(dt_Date==null)
					{
						dt_Date = new Date();
					}
					str_dt_Date = JSPFormater.formatDate(dt_Date, "dd MMMM yyyy");
				}
				catch(Exception e){ str_dt_Date = ""; }
				rowx.add("<a href=\"javascript:cmdEdit('"+String.valueOf(objArPayment.getOID())+"')\">"+str_dt_Date+"</a>");
				Currency colCombo2  = new Currency();
				try{
				colCombo2 = DbCurrency.fetchExc(objArPayment.getCurrencyId());
				}catch(Exception e) {}
				rowx.add(colCombo2.getCurrencyCode());

				Coa colCombo16  = new Coa();
				try{
				colCombo16 = DbCoa.fetchExc(objArPayment.getReceiptAccountId());
				}catch(Exception e) {}
				rowx.add(""+colCombo16.getCode()+" - "+colCombo16.getName());
				rowx.add("<div align=\"right\">"+JSPFormater.formatNumber(objArPayment.getAmount(),"#,###.##")+"</div>");
				rowx.add("<div align=\"right\">"+JSPFormater.formatNumber(objArPayment.getExchangeRate(),"#,###.##")+"</div>");
				rowx.add("<div align=\"right\">"+JSPFormater.formatNumber(objArPayment.getArCurrencyAmount(),"#,###.##")+"</div>");			
				rowx.add(objArPayment.getNotes());
				
			lstData.add(rowx);
		}
/*		rowx = new Vector();
		rowx.add("");
		rowx.add("");
		rowx.add("");
		rowx.add("");
		rowx.add("");
		rowx.add("");
		rowx.add("<div align=\"right\"><b>Total Payment</b></div>");			
		rowx.add("<div align=\"right\"><b>"+JSPFormater.formatNumber(getTotalDetail(objectClass), "#,###.##")+"</b></div>");
		lstData.add(rowx);
		
		rowx = new Vector();
		rowx.add("");
		rowx.add("");
		rowx.add("");
		rowx.add("");
		rowx.add("");
		rowx.add("");
		rowx.add("<div align=\"right\"><b>Balance</b></div>");			
		rowx.add("<div align=\"right\"><b>"+JSPFormater.formatNumber(totalBalance, "#,###.##")+"</b></div>");
		lstData.add(rowx);
*/
		return jsplist.draw(index);
	}

	public double getTotalDetail(Vector listx){
		double result = 0;
		if(listx!=null && listx.size()>0){
			for(int i=0; i<listx.size(); i++){
				ArPayment arPayment = (ArPayment)listx.get(i);
				result = result + (arPayment.getArCurrencyAmount());
			}
		}
		return result;
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
<%@ include file="../calendar/calendarframe.jsp"%>
<%
	int iCommand = JSPRequestValue.requestCommand(request);
	//if(iCommand==JSPCommand.NONE)
	//{
	//	iCommand = JSPCommand.ADD;
	//}

	//Load AR Invoice
	long oidInv = JSPRequestValue.requestLong(request, "oid");
	ARInvoice  arInv = new ARInvoice();
	try{
		arInv = DbARInvoice.fetchExc(oidInv);
	}catch (Exception e){
		System.out.println(e);
	}
	
	//Load Currency
	Currency curr = new Currency();
	try{
		curr = DbCurrency.fetchExc(arInv.getCurrencyId());
	}catch(Exception e){
		System.out.println(e);
	}
	//Load Customer
	Customer customer =  new Customer();
	try{
		customer = DbCustomer.fetchExc(arInv.getCustomerId());
	}catch (Exception e){
		System.out.println(e);
	}
	//Load Project
	Project proj = new Project();
	try{
		proj = DbProject.fetchExc(arInv.getProjectId());
	}catch (Exception e){
		System.out.println(e);
	}
	
	Sales sales = new Sales();
	if(arInv.getSalesSource()==1){
		try{
			sales = DbSales.fetchExc(arInv.getProjectId());
		}catch (Exception e){
			System.out.println(e);
		}
	}
	
	//Load Invoice Detail
	Vector vArDetail = new Vector(1,1);
	ARInvoiceDetail arInvDetail = new ARInvoiceDetail();
	try{
		vArDetail = DbARInvoiceDetail.list(0,0,"ar_invoice_id="+arInv.getOID(),"");
	}catch (Exception e){
		System.out.println("VardDetail ="+vArDetail);
	}
	if(vArDetail!=null && vArDetail.size()>0){
		arInvDetail = (ARInvoiceDetail)vArDetail.get(0);
	}

	
	
	int start = JSPRequestValue.requestInt(request, "start");
	int prevCommand = JSPRequestValue.requestInt(request, "prev_command");
	long oidArPayment = JSPRequestValue.requestLong(request, "hidden_arpayment");

	// variable declaration
	int recordToGet = 10;
	String msgString = "";
	int iErrCode = JSPMessage.NONE;
	//String whereClause = "company_id="+systemCompanyId+" and ar_invoice_id="+oidInv;
	String whereClause = "ar_invoice_id="+oidInv;
	String orderClause = "";
	
	Company company = new Company();
	try{
		company = DbCompany.getCompany();
	}catch(Exception ex){
	}
	
	CmdArPayment cmdArPayment = new CmdArPayment(request);
	JSPLine jspLine = new JSPLine();
	Vector listArPayment = new Vector(1,1);

	// switch statement
	iErrCode = cmdArPayment.action(iCommand , oidArPayment, company.getOID());

	// end switch
	JspArPayment jspArPayment = cmdArPayment.getForm();

	// count list All ArPayment
	int vectSize = DbArPayment.getCount(whereClause);

	//recordToGet = vectSize;

	//out.println(jspArPayment.getErrors());

	ArPayment arPay = cmdArPayment.getArPayment();
	msgString =  cmdArPayment.getMessage();
	//out.println(msgString);

	// switch list ArPayment
	//if((iCommand == JSPCommand.SAVE) && (iErrCode == JSPMessage.NONE))
	//{
	//	start = DbArPayment.generateFindStart(arPay.getOID(),recordToGet, whereClause);
	//}

	if((iCommand == JSPCommand.FIRST || iCommand == JSPCommand.PREV )||
		(iCommand == JSPCommand.NEXT || iCommand == JSPCommand.LAST))
	{
		start = cmdArPayment.actionList(iCommand, start, vectSize, recordToGet);
	} 

	// get record to display
	listArPayment = DbArPayment.list(start,recordToGet, whereClause , orderClause);

	// handle condition if size of record to display = 0 and start > 0 	after delete
	if (listArPayment.size() < 1 && start > 0)
	{
		if (vectSize - recordToGet > recordToGet)
			start = start - recordToGet;  
		else
		{
			start = 0 ;
			iCommand = JSPCommand.FIRST;
			prevCommand = JSPCommand.FIRST; 
		}
		listArPayment = DbArPayment.list(start,recordToGet, whereClause , orderClause);
	}

	//if((iCommand==JSPCommand.SAVE || iCommand==JSPCommand.DELETE) && iErrCode==0)
	//{
	//	iCommand = JSPCommand.ADD;
	//	arPay = new ArPayment();
	//	oidArPayment = 0;
	//}
	
	Vector currencies = DbCurrency.list(0,0,"company_id="+company.getOID(), "");
	ExchangeRate eRate = DbExchangeRate.getStandardRate();//systemCompanyId);
	
	//out.println("systemCompanyId : "+systemCompanyId);
	//out.println("<br>eRate.getOID() : "+eRate.getOID());
	//out.println("<br>eRate.getIDr() : "+eRate.getValueIdr());
	//out.println("<br>eRate.getUsd() : "+eRate.getValueUsd());
	//out.println("<br>eRate.getUsd() : "+eRate.getValueEuro());
	
	double totalAmount = getTotalDetail(listArPayment);
	double totalBalance = arInvDetail.getTotalAmount()-totalAmount;

%>
<html >
<!-- #BeginTemplate "/Templates/index.dwt" --> 
<head>
<!-- #BeginEditable "javascript" --> 
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title><%=systemTitle%></title>
<link href="../css/css.css" rel="stylesheet" type="text/css" />
<!--Begin Region JavaScript-->
<script language="JavaScript">

	<%if(!masterPriv || !masterPrivView){%>
		window.location="<%=approot%>/nopriv.jsp";
	<%}%>

	function cmdPrint(oid){	 
		window.open("<%=printroot%>.report.RptAccReceivablePaymentXLS?oid="+oid);
	}

	var sysDecSymbol = "<%=sSystemDecimalSymbol%>";
	var usrDigitGroup = "<%=sUserDigitGroup%>";
	var usrDecSymbol = "<%=sUserDecimalSymbol%>";

	function cmdUpdateExchange(){
		var idCurr = document.frmarpayment.<%=jspArPayment.colNames[JspArPayment.JSP_CURRENCY_ID]%>.value;
	
		<%if(currencies!=null && currencies.size()>0){
			for(int i=0; i<currencies.size(); i++){
				Currency cx = (Currency)currencies.get(i);
		%>
				if(idCurr=='<%=cx.getOID()%>'){
					<%if(cx.getCurrencyCode().equals(IDRCODE)){%>
						document.frmarpayment.<%=jspArPayment.colNames[jspArPayment.JSP_EXCHANGE_RATE]%>.value="<%=eRate.getValueIdr()%>";
					<%}
					else if(cx.getCurrencyCode().equals(USDCODE)){%>
						document.frmarpayment.<%=jspArPayment.colNames[jspArPayment.JSP_EXCHANGE_RATE]%>.value = formatFloat(<%=eRate.getValueUsd()%>, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);
					<%}
					else if(cx.getCurrencyCode().equals(EURCODE)){%>
						document.frmarpayment.<%=jspArPayment.colNames[jspArPayment.JSP_EXCHANGE_RATE]%>.value= formatFloat(<%=eRate.getValueEuro()%>, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);
					<%}%>
				}	
			<%}
			}%>

		var famount = document.frmarpayment.<%=jspArPayment.colNames[jspArPayment.JSP_AMOUNT]%>.value;
		
		//famount = removeChar(famount);
		famount = cleanNumberFloat(famount, sysDecSymbol, usrDigitGroup, usrDecSymbol);
		
		var fbooked = document.frmarpayment.<%=jspArPayment.colNames[jspArPayment.JSP_EXCHANGE_RATE]%>.value;
		fbooked = cleanNumberFloat(fbooked, sysDecSymbol, usrDigitGroup, usrDecSymbol);
				
		if(!isNaN(famount)){
			document.frmarpayment.<%=jspArPayment.colNames[jspArPayment.JSP_AR_CURRENCY_AMOUNT]%>.value= formatFloat(parseFloat(famount) * parseFloat(fbooked), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 
			document.frmarpayment.<%=jspArPayment.colNames[jspArPayment.JSP_AMOUNT]%>.value= formatFloat(famount, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);
		}
		checkNumber2();
	}

	function checkNumber2(){
		var editAmount = document.frmarpayment.edit_amount.value;		
		editAmount = cleanNumberFloat(editAmount, sysDecSymbol, usrDigitGroup, usrDecSymbol);		
		//alert("Edit Amount = "+editAmount);
		
		var currTotal = ""+<%=totalAmount%>;
		currTotal = cleanNumberFloat(currTotal, sysDecSymbol, usrDigitGroup, usrDecSymbol);				
		//alert("Last Total Payment = "+currTotal);
		
		var pbalance = ""+<%=totalBalance%>;		
		pbalance = cleanNumberFloat(pbalance, sysDecSymbol, usrDigitGroup, usrDecSymbol);				
		pbalance = parseFloat(pbalance)+parseFloat(editAmount);
		//alert("balance payment = "+pbalance);
				
		//new Amount Input
		var newAmount = document.frmarpayment.<%=jspArPayment.colNames[jspArPayment.JSP_AMOUNT]%>.value;
		newAmount = cleanNumberFloat(newAmount, sysDecSymbol, usrDigitGroup, usrDecSymbol);				
		//alert("new Amount Payment = "+newAmount);
		
		//Exchange rate
		var newExchange = document.frmarpayment.<%=jspArPayment.colNames[jspArPayment.JSP_EXCHANGE_RATE]%>.value;
		newExchange = cleanNumberFloat(newExchange, sysDecSymbol, usrDigitGroup, usrDecSymbol);				
		//alert("new Exchange = "+newExchange);
		
		newAmount = parseFloat(newAmount)*parseFloat(newExchange);
		//alert("new Amount Exchange Payment = "+newAmount);
		
		var pbalanceX = parseFloat(pbalance)/parseFloat(newExchange);
		
		/*
		if(parseFloat(newAmount)>parseFloat(pbalance))
		{
			alert("Maximum Amount limit is "+formatFloat(pbalanceX, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace)+" \nsystem will reset the data");
			document.frmarpayment.<%=jspArPayment.colNames[jspArPayment.JSP_AMOUNT]%>.value = formatFloat(pbalanceX, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 	
			document.frmarpayment.<%=jspArPayment.colNames[jspArPayment.JSP_AR_CURRENCY_AMOUNT]%>.value = formatFloat(pbalance, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 	
		}
		*/		
		
	}
	
	function cmdAdd(){
		document.frmarpayment.hidden_arpayment.value="0";
		document.frmarpayment.command.value="<%=JSPCommand.ADD%>";
		document.frmarpayment.prev_command.value="<%=prevCommand%>";
		document.frmarpayment.action="invoicepayment.jsp?oid=<%=oidInv%>";
		document.frmarpayment.submit();
	}

	function cmdAsk(oidArPayment){
		document.frmarpayment.hidden_arpayment.value=oidArPayment;
		document.frmarpayment.command.value="<%=JSPCommand.ASK%>";
		document.frmarpayment.prev_command.value="<%=prevCommand%>";
		document.frmarpayment.action="invoicepayment.jsp?oid=<%=oidInv%>";
		document.frmarpayment.submit();
	}

	function cmdDelete(oidArPayment){
		document.frmarpayment.hidden_arpayment.value=oidArPayment;
		document.frmarpayment.command.value="<%=JSPCommand.ASK%>";
		document.frmarpayment.prev_command.value="<%=prevCommand%>";
		document.frmarpayment.action="invoicepayment.jsp?oid=<%=oidInv%>";
		document.frmarpayment.submit();
	}

	function cmdConfirmDelete(oidArPayment){
		document.frmarpayment.hidden_arpayment.value=oidArPayment;
		document.frmarpayment.command.value="<%=JSPCommand.DELETE%>";
		document.frmarpayment.prev_command.value="<%=prevCommand%>";
		document.frmarpayment.action="invoicepayment.jsp?oid=<%=oidInv%>";
		document.frmarpayment.submit();
	}

	function cmdSave(){
		document.frmarpayment.command.value="<%=JSPCommand.SAVE%>";
		document.frmarpayment.prev_command.value="<%=prevCommand%>";
		document.frmarpayment.action="invoicepayment.jsp?oid=<%=oidInv%>";
		document.frmarpayment.submit();
		}

	function cmdEdit(oidArPayment){
		<%if(masterPrivUpdate){%>
		document.frmarpayment.hidden_arpayment.value=oidArPayment;
		document.frmarpayment.command.value="<%=JSPCommand.EDIT%>";
		document.frmarpayment.prev_command.value="<%=prevCommand%>";
		document.frmarpayment.action="invoicepayment.jsp?oid=<%=oidInv%>";
		document.frmarpayment.submit();
		<%}%>
		}

	function cmdCancel(oidArPayment){
		document.frmarpayment.hidden_arpayment.value=oidArPayment;
		document.frmarpayment.command.value="<%=JSPCommand.EDIT%>";
		document.frmarpayment.prev_command.value="<%=prevCommand%>";
		document.frmarpayment.action="invoicepayment.jsp?oid=<%=oidInv%>";
		document.frmarpayment.submit();
	}

	function cmdBack(){
		document.frmarpayment.command.value="<%=JSPCommand.BACK%>";
		//document.frmarpayment.hidden_arpayment.value="0";
		//document.frmarpayment.command.value="<%=JSPCommand.ADD%>";
		document.frmarpayment.action="invoicepayment.jsp?oid=<%=oidInv%>";
		document.frmarpayment.submit();
		}

	function cmdListFirst(){
		document.frmarpayment.command.value="<%=JSPCommand.FIRST%>";
		document.frmarpayment.prev_command.value="<%=JSPCommand.FIRST%>";
		document.frmarpayment.action="invoicepayment.jsp?oid=<%=oidInv%>";
		document.frmarpayment.submit();
	}

	function cmdListPrev(){
		document.frmarpayment.command.value="<%=JSPCommand.PREV%>";
		document.frmarpayment.prev_command.value="<%=JSPCommand.PREV%>";
		document.frmarpayment.action="invoicepayment.jsp?oid=<%=oidInv%>";
		document.frmarpayment.submit();
		}

	function cmdListNext(){
		document.frmarpayment.command.value="<%=JSPCommand.NEXT%>";
		document.frmarpayment.prev_command.value="<%=JSPCommand.NEXT%>";
		document.frmarpayment.action="invoicepayment.jsp?oid=<%=oidInv%>";
		document.frmarpayment.submit();
	}

	function cmdListLast(){
		document.frmarpayment.command.value="<%=JSPCommand.LAST%>";
		document.frmarpayment.prev_command.value="<%=JSPCommand.LAST%>";
		document.frmarpayment.action="invoicepayment.jsp?oid=<%=oidInv%>";
		document.frmarpayment.submit();
	}
	
	function check(evt){
		var charCode = (evt.which) ? evt.which : event.keyCode
		if (charCode > 31 && (charCode < 48 || charCode > 57) ){
			alert("Numeric input")
			return false
		}	return true
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
<!--End Region JavaScript-->


<!-- #EndEditable --> 
</head>
<body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','../images/new2.gif')">
<table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
  <tr> 
    <td valign="top"> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
        <tr> 
          <td height="96"> <!-- #BeginEditable "header" --> 
            <%@ include file="../main/hmenu.jsp"%>
            <!-- #EndEditable --> </td>
        </tr>
        <tr> 
          <td valign="top"> 
            <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
              <!--DWLayoutTable-->
              <tr> 
                <td width="165" height="100%" valign="top" style="background:url(<%=approot%>/images/leftmenu-bg.gif) repeat-y"> 
                  <!-- #BeginEditable "menu" --> 
                  <%@ include file="../main/menu.jsp"%>
                  <!-- #EndEditable --> </td>
                <td width="100%" valign="top"> 
                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr> 
                      <td class="title"><!-- #BeginEditable "title" -->
					  <%
					  String navigator = "<font class=\"lvl1\">Account Receivable</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">Payment</span></font>";
					  %>
					  <%@ include file="../main/navigator.jsp"%>
					  <!-- #EndEditable --></td>
                    </tr>
                    <!--tr> 
                      <td><img src="<%=approot%>/images/title-sp.gif" width="584" height="1"></td> 
                    </tr-->
                    <tr> 
                      <td><!-- #BeginEditable "content" --> 
                        <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
                          <tr> 
                            <td valign="top"> 
                              <table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
                                <tr> 
                                  <td valign="top"> 
                                    <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
                                      <!--DWLayoutTable-->
                                      <tr> 
                                        <td width="100%" valign="top"> 
                                          <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                            <tr> 
                                              <td> 
                                                <!--Begin Region Content-->
                                                <form name="frmarpayment" method ="post" action="">
                                                  <input type="hidden" name="command" value="<%=iCommand%>">
                                                  <input type="hidden" name="vectSize" value="<%=vectSize%>">
                                                  <input type="hidden" name="start" value="<%=start%>">
                                                  <input type="hidden" name="prev_command" value="<%=prevCommand%>">
                                                  <input type="hidden" name="hidden_arpayment" value="<%=oidArPayment%>">
                                                  <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                    <tr> 
                                                      <td class="container"> 
                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                          <tr> 
                                                            <td width="12%">&nbsp;</td>
                                                            <td width="33%">&nbsp;</td>
                                                            <td width="12%">&nbsp;</td>
                                                            <td width="43%">&nbsp;</td>
                                                          </tr>
                                                          <tr> 
                                                            <td><b>Customer</b></td>
                                                            <td><%=customer.getCode()+" / "+customer.getName()%></td>
                                                            <td><b>Invoice Number</b></td>
                                                            <td><%=arInv.getJournalNumber()%></td>
                                                          </tr>
                                                          <tr> 
                                                            <td height="20"></td>
                                                            <td><%=customer.getAddress()%><br>
                                                              <%=customer.getCity()+" "+customer.getState()%> <%=customer.getCountryName()%></td>
                                                            <td><b>Due Date</b></td>
                                                            <td><%=JSPFormater.formatDate(arInv.getDueDate(),"dd MMMM yyyy")%></td>
                                                          </tr>
                                                          <tr> 
                                                            <td height="25"><b>Project 
                                                              Number</b></td>
                                                            <td><%=proj.getNumber()%></td>
                                                            <td><b>Amount</b></td>
                                                            <td><%=curr.getCurrencyCode()%>. <%=JSPFormater.formatNumber(arInvDetail.getTotalAmount()-proj.getPphAmount(),"#,###.##")%></td>
                                                          </tr>
                                                          <tr> 
                                                            <td height="20"><b>Project 
                                                              Date</b></td>
                                                            <td><%=JSPFormater.formatDate(proj.getDate(),"dd MMMM yyyy")%></td>
                                                            <%if(totalBalance!=0){%>
                                                            <td><b><font color="#FF0000">Balance</font></b></td>
                                                            <td><font color="#FF0000"><b><%=curr.getCurrencyCode()%>. 
															<%if(arInv.getSalesSource()==0){%>
															<%=JSPFormater.formatNumber(totalBalance-proj.getPphAmount(),"#,###.##")%>
															<%}else{%>
															<%=JSPFormater.formatNumber(totalBalance-sales.getPphAmount(),"#,###.##")%>
															<%}%>
															</b></font></td>
                                                            <%}else{%>
                                                            <td></td>
                                                            <td></td>
                                                            <%}%>
                                                          </tr>
                                                          <tr> 
                                                            <td>&nbsp;</td>
                                                            <td>&nbsp;</td>
                                                            <td>&nbsp;</td>
                                                            <td>&nbsp;</td>
                                                          </tr>
                                                          <tr align="left" valign="top"> 
                                                            <td height="8"  colspan="4"> 
                                                              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr align="left" valign="top"> 
                                                                  <td height="8" valign="middle" colspan="3"></td>
                                                                </tr>
                                                                <%
							 try
							 {
						   %>
                                                                <tr align="left" valign="top"> 
                                                                  <td height="22" valign="middle" colspan="3"> 
                                                                    <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                      <tr>
                                                                        <td class="boxed1"><b class="level2">PAYMENT 
                                                                          LIST</b> 
                                                                        </td>
                                                                      </tr>
                                                                      <tr> 
                                                                        <td class="boxed1" height="5"></td>
                                                                      </tr>
                                                                      <tr> 
                                                                        <td class="boxed1"><%=drawList(listArPayment,oidArPayment, approot, start, recordToGet, totalBalance)%></td>
                                                                      </tr>
                                                                    </table>
                                                                  </td>
                                                                </tr>
                                                                <% 
							 } catch(Exception exc){}
						   %>
                                                                <tr align="left" valign="top"> 
                                                                  <td height="8" align="left" colspan="3" class="command"> 
                                                                    <span class="command"> 
                                                                    <% 
							 int cmd = 0;
							 if ((iCommand == JSPCommand.FIRST || iCommand == JSPCommand.PREV )|| (iCommand == JSPCommand.NEXT || iCommand == JSPCommand.LAST)) 
								cmd = iCommand; 
							 else
							 {
								if(iCommand == JSPCommand.NONE || prevCommand == JSPCommand.NONE)
									cmd = JSPCommand.FIRST;
								else 
									cmd = prevCommand; 
								} 
							%>
                                                                    <% 
							  jspLine.setLocationImg(approot+"/images/ctr_line");
							  jspLine.initDefault();
			 				  jspLine.setFirstImage("<img name=\"Image23x\" border=\"0\" src=\""+approot+"/images/first.gif\" alt=\"First\">");
							  jspLine.setPrevImage("<img name=\"Image24x\" border=\"0\" src=\""+approot+"/images/prev.gif\" alt=\"Prev\">");
							  jspLine.setNextImage("<img name=\"Image25x\" border=\"0\" src=\""+approot+"/images/next.gif\" alt=\"Next\">");
							  jspLine.setLastImage("<img name=\"Image26x\" border=\"0\" src=\""+approot+"/images/last.gif\" alt=\"Last\">");

							  jspLine.setFirstOnMouseOver("MM_swapImage('Image23x','','"+approot+"/images/first2.gif',1)");
							  jspLine.setPrevOnMouseOver("MM_swapImage('Image24x','','"+approot+"/images/prev2.gif',1)");
							  jspLine.setNextOnMouseOver("MM_swapImage('Image25x','','"+approot+"/images/next2.gif',1)");
							  jspLine.setLastOnMouseOver("MM_swapImage('Image26x','','"+approot+"/images/last2.gif',1)");
		   					%>
                                                                    <%=jspLine.drawImageListLimit(cmd,vectSize,start,recordToGet)%> 
                                                                    </span> </td>
                                                                </tr>
                                                                <%
							  if(iCommand!=JSPCommand.EDIT && iCommand!=JSPCommand.ADD && iCommand!=JSPCommand.ASK && iErrCode==0 && totalBalance>0)
							  {
							%>
                                                                <tr align="left" valign="top"> 
                                                                  <td height="22" valign="middle" colspan="3"> 
                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                      <tr> 
                                                                        <td width="97%">&nbsp;</td>
                                                                      </tr>
                                                                      <tr> 
                                                                        <td width="97%"><a href="javascript:cmdAdd()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new21','','../images/new2.gif',1)"><img src="../images/new.gif" name="new21" width="71" height="22" border="0"></a></td>
                                                                      </tr>
                                                                    </table>
                                                                  </td>
                                                                </tr>
                                                                <%
							  }
							%>
                                                              </table>
                                                            </td>
                                                          </tr>
                                                          <tr align="left"> 
                                                            <td height="8" valign="top" colspan="4"><br>
                                                              <%if((iCommand ==JSPCommand.ADD)||(iCommand==JSPCommand.SAVE)&&(jspArPayment.errorSize()>0)||(iCommand==JSPCommand.EDIT)||(iCommand==JSPCommand.ASK)){%>
                                                              <table width="100%" border="0" cellspacing="1" cellpadding="0">
                                                                <%
																	Vector vCurrency = DbCurrency.list(0,0, "company_id="+company.getOID(), "");
																	Vector Currency_value = new Vector(1,1);
																	Vector Currency_key = new Vector(1,1);
																	if(vCurrency!=null && vCurrency.size()>0)
																	{
																		for(int i=0; i<vCurrency.size(); i++)
																		{
																			Currency c = (Currency)vCurrency.get(i);
																			Currency_key.add(c.getCurrencyCode().trim());
																			Currency_value.add(""+c.getOID());
																		}
																	}
																	
																	//Vector vAccLink = DbAccLink.list(0,0, "company_id="+company.getOID()+" and type='"+I_Project.arAccLink[0]+"'", "");
																	Vector vAccLink = DbAccLink.list(0,0, "type='"+I_Project.arAccLink[0]+"'", "");
																	Vector AccLink_value = new Vector(1,1);
																	Vector AccLink_key = new Vector(1,1);
																	if(vAccLink!=null && vAccLink.size()>0)
																	{
																		for(int i=0; i<vAccLink.size(); i++)
																		{
																			AccLink c = (AccLink)vAccLink.get(i);
																			Coa coa = new Coa();
																			try{
																				coa = DbCoa.fetchExc(c.getCoaId());
																			}catch(Exception e){
																				System.out.println(e);
																			}				
																			AccLink_key.add(coa.getCode()+" - "+coa.getName());
																			AccLink_value.add(""+coa.getOID());
																		}
																	}
																	
																	//Vector vAccLink1 = DbAccLink.list(0,0, "company_id="+company.getOID()+" and type='"+I_Project.arAccLink[1]+"'", "");
																	Vector vAccLink1 = DbAccLink.list(0,0, "type='"+I_Project.arAccLink[1]+"'", "");
																	Vector AccLink_value1 = new Vector(1,1);
																	Vector AccLink_key1 = new Vector(1,1);
																	if(vAccLink1!=null && vAccLink1.size()>0)
																	{
																		for(int i=0; i<vAccLink1.size(); i++)
																		{
																			AccLink c1 = (AccLink)vAccLink1.get(i);
																			Coa coa1 = new Coa();
																			try{
																				coa1 = DbCoa.fetchExc(c1.getCoaId());
																			}catch(Exception e){
																				System.out.println(e);
																			}				
																			AccLink_key1.add(coa1.getCode()+" - "+coa1.getName());
																			AccLink_value1.add(""+coa1.getOID());
																		}
																	}
															
															%>
                                                                <tr align="left"> 
                                                                  <td height="3" width="15"></td>
                                                                  <td width="1%"></td>
                                                                  <td width="84%" colspan="2"></td>
                                                                <tr align="left"> 
                                                                  <td height="21">&nbsp;Payment 
                                                                    Number</td>
                                                                  <td height="21">&nbsp;  
                                                                  <td height="21" colspan="2"> 
                                                                    <%
																		int counter = DbArPayment.getNextCounter(company.getOID());
																		String strNumber = DbArPayment.getNextNumber(counter, company.getOID());
																		
																		if(arPay.getOID()!=0){
																		strNumber = arPay.getJournalNumber();
																		}									
																	%>
                                                                    <strong><%=strNumber%></strong> 
                                                                    <input type="hidden" name="<%=jspArPayment.colNames[jspArPayment.JSP_JOURNAL_NUMBER] %>"  value="<%=strNumber%>" class="formElemen">
                                                                    <input type="hidden" name="<%=jspArPayment.colNames[jspArPayment.JSP_JOURNAL_NUMBER_PREFIX] %>"  value="<%= arPay.getJournalNumberPrefix() %>" class="formElemen">
                                                                    <input type="hidden" name="<%=jspArPayment.colNames[jspArPayment.JSP_COUNTER] %>"  value="<%= arPay.getCounter() %>" class="formElemen">
                                                                <tr align="left"> 
                                                                  <td height="21">&nbsp;AR 
                                                                    Account</td>
                                                                  <td height="21">&nbsp; 
                                                                  <td height="21" colspan="2">
																  <select name="<%=jspArPayment.colNames[JspArPayment.JSP_AR_ACCOUNT_ID]%>">
																		<%if(vAccLink!=null && vAccLink.size()>0){
																		  for(int i=0; i<vAccLink.size(); i++){
																				AccLink accLink = (AccLink)vAccLink.get(i);
																				Coa coa = new Coa();
																				try{
																					coa = DbCoa.fetchExc(accLink.getCoaId());
																				}
																				catch(Exception e){
																				}
																		  %>
																			<option <%if(arPay.getArAccountId()==coa.getOID()){%>selected<%}%> value="<%=coa.getOID()%>"><%=coa.getCode()+" - "+coa.getName()%></option>
																			<%=getAccountRecursif(coa, arPay.getArAccountId(), isPostableOnly)%>
																			<%}}else{%>
																			<option>select ..</option>
																			<%}%>
																		  </select>
                                                                    <%//= JSPCombo.draw(jspArPayment.colNames[JspArPayment.JSP_AR_ACCOUNT_ID],null, ""+arPay.getArAccountId(), AccLink_value , AccLink_key, "formElemen", "") %> 
                                                                    <%= jspArPayment.getErrorMsg(jspArPayment.JSP_AR_ACCOUNT_ID) %> 
                                                                <tr align="left"> 
                                                                  <td height="21">&nbsp;Receipt 
                                                                    to Account</td>
                                                                  <td height="21">&nbsp; 
                                                                  <td height="21" colspan="2">
																  <select name="<%=jspArPayment.colNames[JspArPayment.JSP_RECEIPT_ACCOUNT_ID]%>">
																		<%if(vAccLink1!=null && vAccLink1.size()>0){
																		  for(int i=0; i<vAccLink1.size(); i++){
																				AccLink accLink = (AccLink)vAccLink1.get(i);
																				Coa coa = new Coa();
																				try{
																					coa = DbCoa.fetchExc(accLink.getCoaId());
																				}
																				catch(Exception e){
																				}
																		  %>
																			<option <%if(arPay.getReceiptAccountId()==coa.getOID()){%>selected<%}%> value="<%=coa.getOID()%>"><%=coa.getCode()+" - "+coa.getName()%></option>
																			<%=getAccountRecursif(coa, arPay.getReceiptAccountId(), isPostableOnly)%>
																			<%}}else{%>
																			<option>select ..</option>
																			<%}%>
																		  </select>
																  
																   
                                                                    <%//= JSPCombo.draw(jspArPayment.colNames[JspArPayment.JSP_RECEIPT_ACCOUNT_ID],null, ""+arPay.getReceiptAccountId(), AccLink_value1 , AccLink_key1, "formElemen", "") %> 
                                                                    <%= jspArPayment.getErrorMsg(jspArPayment.JSP_RECEIPT_ACCOUNT_ID) %> 
                                                                <tr align="left"> 
                                                                  <td height="21">&nbsp;Bank 
                                                                    Transfer Number</td>
                                                                  <td height="21">&nbsp; 
                                                                  <td height="21" colspan="2"> 
                                                                    <input type="text" name="<%=jspArPayment.colNames[jspArPayment.JSP_BANK_TRANSFER_NUMBER] %>"  value="<%= arPay.getBankTransferNumber() %>" class="formElemen">
                                                                    <%= jspArPayment.getErrorMsg(jspArPayment.JSP_BANK_TRANSFER_NUMBER) %> 
                                                                <tr align="left"> 
                                                                  <td height="21">&nbsp;Date</td>
                                                                  <td height="21">&nbsp; 
                                                                  <td height="21" colspan="2"> 
                                                                    <%//= JSPDate.drawDateWithStyle(jspArPayment.colNames[jspArPayment.JSP_DATE], (arPay.getDate()==null) ? new Date() : arPay.getDate(), 5,-10, "formElemen", "") %>
                                                                    <input name="<%=jspArPayment.colNames[jspArPayment.JSP_TRANSACTION_DATE]%>" value="<%=JSPFormater.formatDate((arPay.getDate()==null) ? new Date() : arPay.getDate(), "dd/MM/yyyy")%>" size="11" style="text-align:center" readOnly>
                                                                    <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmarpayment.<%=jspArPayment.colNames[jspArPayment.JSP_TRANSACTION_DATE]%>);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt="visit date"></a> 
                                                                    <%= jspArPayment.getErrorMsg(jspArPayment.JSP_TRANSACTION_DATE) %> 
                                                                <tr align="left"> 
                                                                  <td height="21">&nbsp;Currency</td>
                                                                  <td height="21">&nbsp; 
                                                                  <td height="21" colspan="2"> 
                                                                    <%= JSPCombo.draw(jspArPayment.colNames[JspArPayment.JSP_CURRENCY_ID],null, ""+arPay.getCurrencyId(), Currency_value , Currency_key, "onChange=\"javascript:cmdUpdateExchange()\"", "formElemen") %> 
                                                                    <%= jspArPayment.getErrorMsg(jspArPayment.JSP_CURRENCY_ID) %> 
                                                                <tr align="left"> 
                                                                  <td height="21">&nbsp;Pay 
                                                                    Amount</td>
                                                                  <td height="21">&nbsp; 
                                                                  <td height="21" colspan="2"> 
                                                                    <input type="text" style="text-align:right" name="<%=jspArPayment.colNames[jspArPayment.JSP_AMOUNT] %>"  value="<%=JSPFormater.formatNumber(arPay.getAmount(),"#,###.##") %>" class="formElemen" onBlur="javascript:cmdUpdateExchange()" onClick="this.select()">
                                                                    <%= jspArPayment.getErrorMsg(jspArPayment.JSP_AMOUNT) %> 
                                                                <tr align="left"> 
                                                                  <td height="21">&nbsp;Exchange 
                                                                    Rate</td>
                                                                  <td height="21">&nbsp; 
                                                                  <td height="21" colspan="2"> 
                                                                    <input type="text" style="text-align:right" name="<%=jspArPayment.colNames[jspArPayment.JSP_EXCHANGE_RATE] %>"  value="<%=JSPFormater.formatNumber(arPay.getExchangeRate(),"#,###.##") %>" class="readonly">
                                                                <tr align="left"> 
                                                                  <td height="21">&nbsp;Amount</td>
                                                                  <td height="21">&nbsp; 
                                                                  <td height="21" colspan="2"> 
                                                                    <input type="hidden" style="text-align:right" name="edit_amount"  value="<%=JSPFormater.formatNumber(arPay.getArCurrencyAmount(),"#,###.##") %>" class="readonly">
                                                                    <input type="text" style="text-align:right" name="<%=jspArPayment.colNames[jspArPayment.JSP_AR_CURRENCY_AMOUNT] %>"  value="<%=JSPFormater.formatNumber(arPay.getArCurrencyAmount(),"#,###.##") %>" class="readonly">
                                                                    <%= jspArPayment.getErrorMsg(jspArPayment.JSP_AR_CURRENCY_AMOUNT) %> 
                                                                <tr align="left"> 
                                                                  <td height="21">&nbsp;Reference</td>
                                                                  <td height="21">&nbsp; 
                                                                  <td height="21" colspan="2"> 
                                                                    <input type="text" name="<%=jspArPayment.colNames[jspArPayment.JSP_NOTES] %>"  value="<%= arPay.getNotes() %>" class="formElemen" size="70">
                                                                    <%= jspArPayment.getErrorMsg(jspArPayment.JSP_NOTES) %> 
                                                                    <input type="hidden" name="<%=jspArPayment.colNames[jspArPayment.JSP_DATE]%>" value="<%=JSPFormater.formatDate((arPay.getDate()==null) ? new Date() : arPay.getDate(), "dd/MM/yyyy")%>">
                                                                    <input type="hidden" name="<%=jspArPayment.colNames[jspArPayment.JSP_OPERATOR_ID] %>"  value="<%= appSessUser.getUserOID() %>" class="formElemen">
                                                                    <input type="hidden" name="<%=jspArPayment.colNames[jspArPayment.JSP_AR_INVOICE_ID] %>"  value="<%= arInv.getOID() %>" class="formElemen">
                                                                    <input type="hidden" name="<%=jspArPayment.colNames[jspArPayment.JSP_CUSTOMER_ID] %>"  value="<%= arInv.getCustomerId() %>" class="formElemen">
                                                                    <input type="hidden" name="<%=jspArPayment.colNames[jspArPayment.JSP_PROJECT_ID] %>"  value="<%= arInv.getProjectId() %>" class="formElemen">
                                                                    <input type="hidden" name="<%=jspArPayment.colNames[jspArPayment.JSP_PROJECT_TERM_ID] %>"  value="<%= arInv.getProjectTermId() %>" class="formElemen">
                                                                <tr align="left"> 
                                                                  <td height="8" valign="middle" colspan="3">&nbsp; 
                                                                  </td>
                                                                </tr>
                                                                <tr align="left" > 
                                                                  <td colspan="3" class="command" valign="top"> 
                                                                    <%
			 jspLine.setLocationImg(approot+"/images/ctr_line");
			 jspLine.initDefault();
			 jspLine.setTableWidth("80%");
			 String scomDel = "javascript:cmdAsk('"+oidArPayment+"')";
			 String sconDelCom = "javascript:cmdConfirmDelete('"+oidArPayment+"')";
			 String scancel = "javascript:cmdEdit('"+oidArPayment+"')";
			 jspLine.setBackCaption("Back to List");
			 jspLine.setJSPCommandStyle("buttonlink");
			 jspLine.setDeleteCaption("Delete");

			 jspLine.setOnMouseOut("MM_swapImgRestore()");
			 jspLine.setOnMouseOverSave("MM_swapImage('save','','"+approot+"/images/save2.gif',1)");
			 jspLine.setSaveImage("<img src=\""+approot+"/images/save.gif\" name=\"save\" height=\"22\" border=\"0\">");

			 //jspLine.setOnMouseOut("MM_swapImgRestore()");
			 jspLine.setOnMouseOverBack("MM_swapImage('back','','"+approot+"/images/cancel2.gif',1)");
			 jspLine.setBackImage("<img src=\""+approot+"/images/cancel.gif\" name=\"back\" height=\"22\" border=\"0\">");

			 jspLine.setOnMouseOverDelete("MM_swapImage('delete','','"+approot+"/images/delete2.gif',1)");
			 jspLine.setDeleteImage("<img src=\""+approot+"/images/delete.gif\" name=\"delete\" height=\"22\" border=\"0\">");

			 jspLine.setOnMouseOverEdit("MM_swapImage('edit','','"+approot+"/images/cancel2.gif',1)");
			 jspLine.setEditImage("<img src=\""+approot+"/images/cancel.gif\" name=\"edit\" height=\"22\" border=\"0\">");

			 jspLine.setWidthAllJSPCommand("90");
			 jspLine.setErrorStyle("warning");
			 jspLine.setErrorImage(approot+"/images/error.gif\" width=\"20\" height=\"20");
			 jspLine.setQuestionStyle("warning");
			 jspLine.setQuestionImage(approot+"/images/error.gif\" width=\"20\" height=\"20");
			 jspLine.setInfoStyle("success");

			 jspLine.setSuccessImage(approot+"/images/success.gif\" width=\"20\" height=\"20");

			 if (privDelete)

			 {
			   jspLine.setConfirmDelJSPCommand(sconDelCom);
			   jspLine.setDeleteJSPCommand(scomDel);
			   jspLine.setEditJSPCommand(scancel);
			 }else
			 { 
			   jspLine.setConfirmDelCaption("");
			   jspLine.setDeleteCaption("");
			   jspLine.setEditCaption("");
			 }

			 if(privAdd == false  && privUpdate == false)
			 {
			   jspLine.setSaveCaption("");
			 }

			 if (privAdd == false)
			 {
			   jspLine.setAddCaption("");
			 }

			if(iCommand==JSPCommand.EDIT){
				scomDel = "javascript:cmdPrint('"+oidArPayment+"')";
				jspLine.setDeleteJSPCommand(scomDel);
				jspLine.setOnMouseOverDelete("MM_swapImage('print','','"+approot+"/images/print2.gif',1)");
			 	jspLine.setDeleteImage("<img src=\""+approot+"/images/print.gif\" name=\"print\" height=\"22\" border=\"0\">");
				jspLine.setSaveCaption("");
			}

		   %>
                                                                    <%=jspLine.drawImageOnly(iCommand, iErrCode, msgString)%> 
                                                                  </td>
                                                                </tr>
                                                              </table>
                                                              <%}%>
                                                            </td>
                                                          </tr>
                                                        </table>
                                                      </td>
                                                    </tr>
                                                  </table>
                                                </form>
                                                <script language="JavaScript">
				<%if(iErrCode!=0 || iCommand==JSPCommand.ADD || iCommand==JSPCommand.EDIT){%>
					cmdUpdateExchange();
				<%}%>
			</script>
                                                <!--End Region Content-->
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
                              </table>
                            </td>
                          </tr>
                        </table>
                        <!-- #EndEditable --> </td>
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
          <td height="25"> <!-- #BeginEditable "footer" --> 
            <%@ include file="../main/footer.jsp"%>
            <!-- #EndEditable --> </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
</body>
<!-- #EndTemplate --> 
</html>

