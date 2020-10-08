

<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.main.entity.*" %>
<%@ page import = "com.project.fms.transaction.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "com.project.general.*" %>
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
boolean payablePriv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MENU_ACCPAYABLE, AppMenu.M2_MENU_ACCPAYABLE_INVOICE);
%>

<%!

public InvoiceItem getInvoiceItem(PurchaseItem pi, Vector invoiceItems){
	
	InvoiceItem ii = new InvoiceItem();
	
	try{
		if(invoiceItems!=null && invoiceItems.size()>0){
			for(int i=0; i<invoiceItems.size(); i++){
				InvoiceItem x = (InvoiceItem)invoiceItems.get(i);
				if(x.getPurchaseItemId()==pi.getOID()){
					return x;
				}
			}
		}
	}
	catch(Exception e){
		System.out.println("\nerror : "+e.toString()+"\n");
	}
	
	return ii;
	
}

%>

<!-- Jsp Block -->
<%

	CmdInvoice ctrlInvoice = new CmdInvoice(request);
	long oidInvoice = JSPRequestValue.requestLong(request, "hidden_invoice_id");
	
	long purchaseId = JSPRequestValue.requestLong(request, "hidden_po_id");
	
	Purchase purchase = new Purchase();
	
	if(purchaseId!=0){
		try{
			purchase = DbPurchase.fetchExc(purchaseId);
		}
		catch(Exception e){
		}
	}
	
	//out.println("purchaseId : "+purchaseId);

	int iErrCode = JSPMessage.ERR_NONE;
	String errMsg = "";
	String whereClause = "";
	String orderClause = "";
	int iJSPCommand = JSPRequestValue.requestCommand(request);
	int start = JSPRequestValue.requestInt(request,"start");

	//out.println("iJSPCommand : "+iJSPCommand);
	JSPLine ctrLine = new JSPLine();

	iErrCode = ctrlInvoice.action(iJSPCommand , oidInvoice);

	errMsg = ctrlInvoice.getMessage();
	JspInvoice jspInvoice = ctrlInvoice.getForm();
	Invoice invoice = ctrlInvoice.getInvoice();
	
	if(oidInvoice==0){
		oidInvoice = invoice.getOID();
	}
	
	
	invoice.setVendorId(purchase.getVendorId());
	invoice.setCurrencyId(purchase.getCurrencyId());
	invoice.setPurchaseId(purchase.getOID());
	invoice.setApplyVat(purchase.getVat());
	invoice.setVatPercent(purchase.getVatPercent());
	
	Vector listInvoiceDetail = new Vector();
	listInvoiceDetail = DbPurchaseItem.list(0,0, "purchase_id="+purchase.getOID(), "");
	
	//out.println("<br>listInvoiceDetail : "+listInvoiceDetail);
	
	Vector vInvEdit = new Vector();
	
	if(listInvoiceDetail!=null && listInvoiceDetail.size()>0){
		
		for(int i=0; i<listInvoiceDetail.size(); i++){
			
			PurchaseItem pi = (PurchaseItem)listInvoiceDetail.get(i);
			
			if(iJSPCommand==JSPCommand.NONE){
			
					//out.println("<br>none command ... ");
				
					double qtyx = DbInvoiceItem.getItemReceived(pi);
					double price = (pi.getTotalAmount()/pi.getQty()) - ((pi.getTotalAmount()*purchase.getDiscountPercent()/100)/pi.getQty());
			
					InvoiceItem ii = new InvoiceItem();
					ii.setPurchaseItemId(pi.getOID());
					ii.setInvoiceId(invoice.getOID());
					ii.setCoaId(pi.getCoaId());
					ii.setInvQty(pi.getQty()-qtyx);
					ii.setPrice(price);
					ii.setTotal(price * ii.getInvQty());
					ii.setMemo("");
					ii.setItemType(pi.getItemType());
					ii.setItemName(pi.getItemName());
					ii.setDepartmentId(pi.getDepartmentId());
					//ii.setTotal(invAmount);
					
					//out.println("<br>qtyx : "+qtyx);
					//out.println("<br>price : "+price);
					//out.println("<br>price * qtyx : "+price * qtyx);
					
					vInvEdit.add(ii);
					
			}
			else{
			
					//out.println("<br>non none command");
					
					double invQty = JSPRequestValue.requestDouble(request, "invqty_"+pi.getOID());
							
				//if(invQty>0){
				
					double invPrice = JSPRequestValue.requestDouble(request, "invprice_"+pi.getOID());
					String invDesc = JSPRequestValue.requestString(request, "invdesc_"+pi.getOID());
					//double invAmount = JSPRequestValue.requestDouble(request, "invamount_"+pi.getOID());
					
					InvoiceItem ii = new InvoiceItem();
					ii.setPurchaseItemId(pi.getOID());
					ii.setInvoiceId(invoice.getOID());
					ii.setCoaId(pi.getCoaId());
					ii.setInvQty(invQty);
					ii.setPrice(invPrice);
					ii.setTotal(invPrice * invQty);
					ii.setMemo(invDesc);
					ii.setItemType(pi.getItemType());
					ii.setItemName(pi.getItemName());
					//ii.setTotal(invAmount);
					
					//out.println("invQty : "+invQty);
					//out.println("invPrice : "+invPrice);
					//out.println("total : "+invPrice * invQty);
					
					vInvEdit.add(ii);
				//}
			
			}
			
		}
	}
	
	//out.println("<br>vInvEdit : "+vInvEdit);
	
	//out.println("<br>invoice.getOID() : "+invoice.getOID());
	//out.println("<br>iErrCode : "+iErrCode);
	//out.println("<br>errr : "+jspInvoice.getErrors());
	
	if(iJSPCommand==JSPCommand.SAVE && invoice.getOID()!=0 && iErrCode==0){
		DbInvoiceItem.insertItems(invoice.getOID(), vInvEdit);
		DbPurchase.checkForClosed(purchase);
	}
	
	
	double total = 0;
	if(vInvEdit!=null && vInvEdit.size()>0){
		for(int i=0; i<vInvEdit.size(); i++){
			InvoiceItem ii = (InvoiceItem)vInvEdit.get(i);
			total = total + ii.getTotal();
		}
	}
	
	if(invoice.getOID()!=0 && iJSPCommand==JSPCommand.SUBMIT){
		vInvEdit = DbInvoiceItem.list(0,0, "invoice_id="+invoice.getOID(), "");
	}
	
	invoice.setSubTotal(total);
	invoice.setVatAmount(total * (invoice.getVatPercent()/100));
	invoice.setGrandTotal(total + invoice.getVatAmount());
	
	//out.println("<br>vInvEdit : "+vInvEdit);

%>
<!-- End of Jsp Block -->
<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
<head>
<!-- #BeginEditable "javascript" --> 
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title><%=systemTitle%></title>
<link href="../css/css.css" rel="stylesheet" type="text/css" />

<script language="JavaScript">

<%if(!payablePriv){%>
	window.location="<%=approot%>/nopriv.jsp";
<%}%>

	var sysDecSymbol = "<%=sSystemDecimalSymbol%>";
	var usrDigitGroup = "<%=sUserDigitGroup%>";
	var usrDecSymbol = "<%=sUserDecimalSymbol%>";

	function cmdPrintJournal(){	 
		window.open("<%=printroot%>.report.RptAccPaymentPDF?oid=<%=appSessUser.getLoginId()%>&inv_id=<%=oidInvoice%>");
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

	function cmdUpdatePrice(oidPi, qty){
		//alert("oidPi : "+oidPi);
		//alert("qty : "+qty);
		
		<%if(listInvoiceDetail!=null && listInvoiceDetail.size()>0){
			for(int i=0; i<listInvoiceDetail.size(); i++){
				PurchaseItem pi = (PurchaseItem)listInvoiceDetail.get(i);
		%>
				if('<%=pi.getOID()%>'==oidPi){
					var qty = document.frm_invoice.invqty_<%=pi.getOID()%>.value;
					qty = removeChar(qty);
					document.frm_invoice.invqty_<%=pi.getOID()%>.value = qty;
					
					var price = document.frm_invoice.invprice_<%=pi.getOID()%>.value;
					price = removeChar(price);	
					price = cleanNumberFloat(price, sysDecSymbol, usrDigitGroup, usrDecSymbol);
					
					var amountOld = document.frm_invoice.invamount_<%=pi.getOID()%>.value;
					amountOld = removeChar(amountOld);	
					amountOld = cleanNumberFloat(amountOld, sysDecSymbol, usrDigitGroup, usrDecSymbol);
					
					if(qty.length==0 || isNaN(qty)){
						qty = "0";
						document.frm_invoice.invqty_<%=pi.getOID()%>.value="0";
					}
					
					if(parseInt(qty)>parseInt('<%=pi.getQty()-DbInvoiceItem.getItemReceived(pi)%>')){
						alert('Invoice quantity higer than maximum allowance');
						document.frm_invoice.invqty_<%=pi.getOID()%>.value="0";
						document.frm_invoice.invqty_<%=pi.getOID()%>.focus();
						document.frm_invoice.invamount_<%=pi.getOID()%>.value = "0";						
					}
					else{
						document.frm_invoice.invamount_<%=pi.getOID()%>.value = formatFloat(parseInt(qty) * price, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);;
					}
										
					var amountNew = document.frm_invoice.invamount_<%=pi.getOID()%>.value;
					amountNew = removeChar(amountNew);	
					amountNew = cleanNumberFloat(amountNew, sysDecSymbol, usrDigitGroup, usrDecSymbol);
					
					var subtotal = document.frm_invoice.<%=jspInvoice.colNames[jspInvoice.JSP_SUB_TOTAL]%>.value;
					subtotal = removeChar(subtotal);	
					subtotal = cleanNumberFloat(subtotal, sysDecSymbol, usrDigitGroup, usrDecSymbol);
					
					var vatpercent = document.frm_invoice.<%=jspInvoice.colNames[jspInvoice.JSP_VAT_PERCENT]%>.value;
					vatpercent = removeChar(vatpercent);	
					vatpercent = cleanNumberFloat(vatpercent, sysDecSymbol, usrDigitGroup, usrDecSymbol);
					
					//alert("subtotal : "+subtotal);
					//alert("<br>amountOld : "+amountOld);
					//alert("<br>amountNew : "+amountNew);
					
					subtotal = parseFloat(subtotal) - parseFloat(amountOld) + parseFloat(amountNew);
					var vatAmount = subtotal * (parseFloat(vatpercent)/100);
					
					//alert("<br>subtotal : "+subtotal);
					
					document.frm_invoice.<%=jspInvoice.colNames[jspInvoice.JSP_SUB_TOTAL]%>.value = formatFloat(subtotal, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);;
					document.frm_invoice.<%=jspInvoice.colNames[jspInvoice.JSP_VAT_AMOUNT]%>.value = formatFloat(vatAmount, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);;
					document.frm_invoice.<%=jspInvoice.colNames[jspInvoice.JSP_GRAND_TOTAL]%>.value = formatFloat(subtotal + vatAmount, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);;
					
				}
		<%	}
		}%>
		
	}
	
	function cmdSubmitCommand(){
		document.frm_invoice.command.value="<%=JSPCommand.SUBMIT%>";
		document.frm_invoice.action="invoice_edit.jsp";
		document.frm_invoice.submit();
	}
	
	function cmdCancel(){
		document.frm_invoice.command.value="<%=JSPCommand.CANCEL%>";
		document.frm_invoice.action="invoice_edit.jsp";
		document.frm_invoice.submit();
	} 

	function cmdEdit(oid){ 
		document.frm_invoice.command.value="<%=JSPCommand.EDIT%>";
		document.frm_invoice.action="invoice_edit.jsp";
		document.frm_invoice.submit(); 
	} 

	function cmdSave(){
		document.frm_invoice.command.value="<%=JSPCommand.SAVE%>"; 
		document.frm_invoice.action="invoice_edit.jsp";
		document.frm_invoice.submit();
	}

	function cmdAsk(oid){
		document.frm_invoice.command.value="<%=JSPCommand.ASK%>"; 
		document.frm_invoice.action="invoice_edit.jsp";
		document.frm_invoice.submit();
	} 

	function cmdConfirmDelete(oid){
		document.frm_invoice.command.value="<%=JSPCommand.DELETE%>";
		document.frm_invoice.action="invoice_edit.jsp"; 
		document.frm_invoice.submit();
	}  

	function cmdBack(){
		document.frm_invoice.command.value="<%=JSPCommand.FIRST%>"; 
		document.frm_invoice.action="invoicesrc.jsp";
		document.frm_invoice.submit();
	}
	
	
function cmdActivity(oid){
	<%if(oidInvoice!=0 && invoice.getStatus().equals("Posted")){%>
		document.frm_invoice.hidden_invoice_id.value=oid;
		document.frm_invoice.command.value="<%=JSPCommand.NONE%>";
		
		document.frm_invoice.action="invoiceactivity.jsp";
		document.frm_invoice.submit();
	<%}else{%>
		alert('Please finish and post this journal before continue to activity data.');
	<%}%>
	
}

//-------------- script form image -------------------

	function cmdDelPic(oid){
		document.frm_invoice.command.value="<%=JSPCommand.POST%>"; 
		document.frm_invoice.action="invoice_edit.jsp";
		document.frm_invoice.submit();
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
                      <td class="title"><!-- #BeginEditable "title" --><span class="level1">Account 
                        Payable </span> &raquo; <span class="level2">New Invoice<br>
                        </span><!-- #EndEditable --></td>
                    </tr>
                    <!--tr> 
                      <td><img src="<%=approot%>/images/title-sp.gif" width="584" height="1"></td> 
                    </tr-->
                    <tr> 
                      <td><!-- #BeginEditable "content" --> 
                        <form name="frm_invoice" method="post" action="">
                          <input type="hidden" name="command" value="">
                          <input type="hidden" name="start" value="<%=start%>">
                          <input type="hidden" name="hidden_invoice_id" value="<%=oidInvoice%>">						  
						  <input type="hidden" name="hidden_po_id" value="<%=purchaseId%>">						  
						  
						  <input type="hidden" name="<%=JspInvoice.colNames[JspInvoice.JSP_OPERATOR_ID]%>" value="<%=appSessUser.getUserOID()%>">
                          <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
						  
						  <table width="100%" border="0" cellspacing="0" cellpadding="0">
  							<tr>
                              <td class="container"> 
                                <table width="100%" cellspacing="1" cellpadding="1" >
                                  <tr> 
                                    <td colspan="4" height="22"> 
                                      <div align="right">Date : <%=JSPFormater.formatDate(new Date(), "dd MMMM yyyy")%>&nbsp;, &nbsp;Operator : <%=appSessUser.getLoginId()%>&nbsp;&nbsp;<%= jspInvoice.getErrorMsg(jspInvoice.JSP_OPERATOR_ID) %>&nbsp; </div>
                                    </td>
                                  </tr>
                                  <tr> 
                                    <td colspan="4" height="5"></td>
                                  </tr>
                                  <tr align="left"> 
                                    <td width="12%" height="22"  >Vendor </td>
                                    <td  width="28%" height="22"> 
                                      <%
									Vendor v = new Vendor();
									try{
										v = DbVendor.fetchExc(invoice.getVendorId());
									}
									catch(Exception e){
									}
									%>
                                      <%=v.getCode()+" - "+v.getName()%> 
                                      <input type="hidden" name="<%=JspInvoice.colNames[JspInvoice.JSP_VENDOR_ID]%>" value="<%=invoice.getVendorId()%>">
                                      <%=jspInvoice.getErrorMsg(JspInvoice.JSP_VENDOR_ID)%> </td>
                                    <td  width="10%" height="22">&nbsp;</td>
                                    <td  width="50%" height="22">&nbsp;</td>
                                  </tr>
                                  <tr align="left"> 
                                    <td width="12%"  >&nbsp;</td>
                                    <td  width="28%"><%=v.getAddress() + ((v.getCity().length()>0) ? ", "+v.getCity() : "") + ((v.getState().length()>0) ? "<br>"+v.getState() : "") + ((v.getCountryName().length()>0) ? ", "+v.getCountryName() : "") %></td>
                                    <td  width="10%">&nbsp;</td>
                                    <td  width="50%">&nbsp;</td>
                                  </tr>
                                  <tr align="left"> 
                                    <td colspan="4" height="5"  ></td>
                                  </tr>
                                  <tr align="left"> 
                                    <td width="12%"  >Purchase Number</td>
                                    <td  width="28%"> <%=purchase.getJournalNumber()%> 
                                      <input type="hidden" name="<%=JspInvoice.colNames[JspInvoice.JSP_PURCHASE_ID]%>" value="<%=invoice.getPurchaseId()%>" class="formElemen">
                                      <%=jspInvoice.getErrorMsg(JspInvoice.JSP_PURCHASE_ID)%> </td>
                                    <td  width="10%">Journal Number</td>
                                    <td  width="50%"> 
                                      <%
									  int counter = DbInvoice.getNextCounter();
									  String strNumber = DbInvoice.getNextNumber(counter);
									  
									  if(invoice.getOID()!=0){
											strNumber = invoice.getJournalNumber();
									  }
									  
									  %>
                                      <%=strNumber%> 
                                      <input type="hidden" name="<%=JspInvoice.colNames[JspInvoice.JSP_JOURNAL_NUMBER]%>" value="<%=invoice.getJournalNumber()%>" class="formElemen">
                                      <input type="hidden" name="<%=JspInvoice.colNames[JspInvoice.JSP_JOURNAL_PREFIX]%>" value="<%=invoice.getJournalPrefix()%>" class="formElemen">
                                      <input type="hidden" name="<%=JspInvoice.colNames[JspInvoice.JSP_JOURNAL_COUNTER]%>" value="<%=invoice.getJournalCounter()%>" class="formElemen">
                                      <%=jspInvoice.getErrorMsg(JspInvoice.JSP_JOURNAL_NUMBER)%></td>
                                  </tr>
                                  <tr align="left"> 
                                    <td width="12%"  >Purchase Currency </td>
                                    <td  width="28%"> 
                                      <% 
									  Currency c = new Currency();
									  try{
									  	c = DbCurrency.fetchExc(invoice.getCurrencyId());
									  }
									  catch(Exception e){
									  }
									  %>
                                      <%=c.getCurrencyCode()%> 
                                      <input type="hidden" name="<%=JspInvoice.colNames[JspInvoice.JSP_CURRENCY_ID]%>" value="<%=invoice.getCurrencyId()%>">
                                      <%=jspInvoice.getErrorMsg(JspInvoice.JSP_CURRENCY_ID)%></td>
                                    <td  width="10%">Transaction Date</td>
                                    <td  width="50%"> 
                                      <input name="<%=JspInvoice.colNames[JspInvoice.JSP_TRANS_DATE]%>" value="<%=JSPFormater.formatDate((invoice.getTransDate()==null) ? new Date() : invoice.getTransDate(), "dd/MM/yyyy")%>" size="11" readOnly>
                                      <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frm_invoice.<%=JspInvoice.colNames[JspInvoice.JSP_TRANS_DATE]%>);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> 
                                      * <%=jspInvoice.getErrorMsg(JspInvoice.JSP_TRANS_DATE)%></td>
                                  </tr>
                                  <tr align="left"> 
                                    <td width="12%"  >Apply VAT</td>
                                    <td  width="28%"> 
                                      <%if(invoice.getApplyVat()==1){%>
                                      YES 
                                      <%}else{%>
                                      NO 
                                      <%}%>
                                      <input type="hidden" name="<%=JspInvoice.colNames[JspInvoice.JSP_APPLY_VAT]%>" value="<%=invoice.getApplyVat()%>">
                                    </td>
                                    <td  width="10%">Term of Payment</td>
                                    <td  width="50%"> 
                                      <input name="<%=JspInvoice.colNames[JspInvoice.JSP_DUE_DATE]%>" value="<%=JSPFormater.formatDate((invoice.getDueDate()==null) ? new Date() : invoice.getDueDate(), "dd/MM/yyyy")%>" size="11" readOnly>
                                      <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frm_invoice.<%=JspInvoice.colNames[JspInvoice.JSP_DUE_DATE]%>);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> 
                                      * <%=jspInvoice.getErrorMsg(JspInvoice.JSP_DUE_DATE)%></td>
                                  </tr>
                                  <tr align="left"> 
                                    <td width="12%"  >Vendor Invoice Number</td>
                                    <td  width="28%"> 
                                      <input type="text" name="<%=JspInvoice.colNames[JspInvoice.JSP_VENDOR_INVOICE_NUMBER]%>" value="<%=invoice.getVendorInvoiceNumber()%>" class="formElemen" size="30">
                                      * <%=jspInvoice.getErrorMsg(JspInvoice.JSP_VENDOR_INVOICE_NUMBER)%> </td>
                                    <td  width="10%">&nbsp;</td>
                                    <td  width="50%">&nbsp; </td>
                                  </tr>
                                  <tr align="left"> 
                                    <td width="12%"  >Memo</td>
                                    <td colspan="3"> 
                                      <textarea name="<%=JspInvoice.colNames[JspInvoice.JSP_MEMO]%>" class="formElemen" cols="120" rows="2"><%=invoice.getMemo()%></textarea>
                                      * <%=jspInvoice.getErrorMsg(JspInvoice.JSP_MEMO)%> </td>
                                  </tr>
                                  <tr align="left"> 
                                    <td width="12%"  >&nbsp;</td>
                                    <td  width="28%">&nbsp; </td>
                                    <td  width="10%">&nbsp;</td>
                                    <td  width="50%">&nbsp;</td>
                                  </tr>
                                  <tr align="left"> 
                                    <td colspan="4"  > 
                                      <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                        <tr > 
                                          <td class="tabheader" height="22"><img src="<%=approot%>/images/spacer.gif" width="17" height="10"></td>
                                          <td class="tab" height="22">Disbursement</td>
                                          <td class="tabheader" height="22"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
										  <%if(applyActivity){%>
                                          <td class="tabin" height="22"> 
                                            <%if(true){%>
                                            <a href="javascript:cmdActivity('<%=oidInvoice%>')" class="tablink">Activity</a> 
                                            <%}else{%>
                                            <a href="#" class="tablink" title="petty cash payment required">Activity</a> 
                                            <%}%>
                                          </td>
										  <%}%>
                                          <td class="tabheader" height="22"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                          <td class="tabheader" height="22"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                          <td width="100%" class="tabheader" height="22"><img src="<%=approot%>/images/spacer.gif" width="10" height="10"></td>
                                        </tr>
                                      </table>
                                    </td>
                                  </tr>
                                  <tr align="left"> 
                                    <td colspan="4" class="page" > 
                                      <table width="100%" border="0" cellspacing="1" cellpadding="0">
                                        <tr> 
                                          <td  class="tablehdr" width="13%" height="20">Item</td>
                                          <td  class="tablehdr" width="7%" height="20">Type</td>
                                          <td  class="tablehdr" width="14%" height="20">Account 
                                            - Description</td>
                                          <td  class="tablehdr" width="9%" height="20">Department 
                                          </td>
                                          <td  class="tablehdr" width="5%" height="20" nowrap>PO 
                                            Qty</td>
                                          <td  class="tablehdr" width="6%" height="20">Received</td>
                                          <td  class="tablehdr" width="6%" height="20">Invoice 
                                            Qty </td>
                                          <td  class="tablehdr" width="9%" height="20">@Price</td>
                                          <td class="tablehdr" width="9%" height="20">Invoice 
                                            Amount </td>
                                          <td class="tablehdr" width="22%" height="20">Description</td>
                                        </tr>
                                        <%if(listInvoiceDetail!=null && listInvoiceDetail.size()>0){
													for(int i=0; i<listInvoiceDetail.size(); i++){
														PurchaseItem crd = (PurchaseItem)listInvoiceDetail.get(i);
														Coa cx = new Coa();
														try{
															cx = DbCoa.fetchExc(crd.getCoaId());
														}
														catch(Exception e){
														}
														
														String cssString = "tablecell";
														if(i%2!=0){
															cssString = "tablecell1";
														}
														
														InvoiceItem invItem = getInvoiceItem(crd, vInvEdit);
														
														//out.println(invItem.getOID());
														
												%>
                                        <%
												  double recQty = DbInvoiceItem.getItemReceived(crd);
												  if(iJSPCommand==JSPCommand.SAVE && invoice.getOID()!=0){
														recQty = recQty - invItem.getInvQty();
												  }
											  %>
                                        
										<%if(iJSPCommand!=JSPCommand.SUBMIT){
											if(recQty != crd.getQty()){
										%>
                                        <tr> 
                                          <td class="<%=cssString%>" width="13%" height="17"><%=crd.getItemName()%></td>
                                          <td class="<%=cssString%>" width="7%" height="17"><%=crd.getItemType()%></td>
                                          <td class="<%=cssString%>" width="14%" nowrap height="17"><%=cx.getCode()+" - "+cx.getName()%> </td>
                                          <td class="<%=cssString%>" width="9%" nowrap height="17"> 
                                            <%
										  if(crd.getDepartmentId()!=0){
											Department d = new Department();
										  	try{
												d = DbDepartment.fetchExc(crd.getDepartmentId());	
											}
											catch(Exception e){
											}
										  	out.println(d.getCode()+" - "+d.getName());
										  }
										  else{
										  	out.println("TOTAL CORPORATE");
										  }
										  %>
                                          </td>
                                          <td class="<%=cssString%>" width="5%" height="17"> 
                                            <div align="center"><%=crd.getQty()%> 
                                              <input type="hidden" name="poqty_<%=crd.getOID()%>" value="<%=crd.getQty()%>">
                                            </div>
                                          </td>
                                          <td class="<%=cssString%>" width="6%" height="17"> 
                                            <div align="center">
											<%if(iJSPCommand!=JSPCommand.SUBMIT){%>  
                                              <input type="text" name="invrec_<%=crd.getOID()%>" size="3" style="text-align:right" value="<%=recQty%>" class="readonly" readOnly>
											<%}else{
												out.println(recQty);
											}%> 
                                            </div>
											
                                          </td>
                                          <td class="<%=cssString%>" width="6%" height="17"> 
                                            <div align="center"> 
											  <%if(iJSPCommand!=JSPCommand.SUBMIT){%>   	
                                              <input type="text" name="invqty_<%=crd.getOID()%>" size="3" value="<%=invItem.getInvQty()%>" style="text-align:right" onClick="this.select()" onBlur="javascript:cmdUpdatePrice('<%=crd.getOID()%>','<%=crd.getQty()%>')">
											  <%}else{
												out.println(invItem.getInvQty());
											  }%>
                                            </div>
                                          </td>
                                          <td class="<%=cssString%>" width="9%" height="17"> 
                                            <div align="center">
											  <%if(iJSPCommand!=JSPCommand.SUBMIT){%>  	 
                                              <input type="text" name="invprice_<%=crd.getOID()%>" size="15" value="<%=JSPFormater.formatNumber(invItem.getPrice(), "#,###.##")%>" readOnly class="readonly" style="text-align:right">
                                              <%}else{
											  	out.println(JSPFormater.formatNumber(invItem.getPrice(), "#,###.##"));
											  }
											  //out.println("crd.getTotalAmount() : "+crd.getTotalAmount());
											  //out.println("<br>crd.getQty() : "+crd.getQty());
											  //out.println("<br>crd.getTotalAmount() : "+crd.getTotalAmount());
											  //out.println("<br>purchase.getDiscountPercent() : "+purchase.getDiscountPercent());
											  %>
                                            </div>
                                          </td>
                                          <td width="9%" class="<%=cssString%>" height="17"> 
                                            <div align="center">
											  <%if(iJSPCommand!=JSPCommand.SUBMIT){%>  
                                              <input type="text" name="invamount_<%=crd.getOID()%>" size="15"  value="<%=JSPFormater.formatNumber(invItem.getTotal(), "#,###.##")%>" readOnly class="readonly" style="text-align:right">
											  <%}else{%>
											  <%=JSPFormater.formatNumber(invItem.getTotal(), "#,###.##")%>
											  <%}%>
                                            </div>
                                          </td>
                                          <td width="22%" class="<%=cssString%>" height="17"> 
                                            <%if(iJSPCommand!=JSPCommand.SUBMIT){%>  
											<div align="center">  
                                              <textarea name="invdesc_<%=crd.getOID()%>" cols="35" rows="3"><%=invItem.getMemo()%></textarea>
											  </div><%}else{%>
											  <%=invItem.getMemo()%>
											  <%}%>
                                            
                                          </td>
                                        </tr>
										<%}
										}else{
										//out.println("in it");
											if(invItem.getOID()!=0){
											
											try{
											
											
										%>
										<tr> 
                                          <td class="<%=cssString%>" width="13%" height="17"><%=crd.getItemName()%></td>
                                          <td class="<%=cssString%>" width="7%" height="17"><%=crd.getItemType()%></td>
                                          <td class="<%=cssString%>" width="14%" nowrap height="17"><%=cx.getCode()+" - "+cx.getName()%> </td>
                                          <td class="<%=cssString%>" width="9%" nowrap height="17"> 
                                            <%
										  if(crd.getDepartmentId()!=0){
											Department d = new Department();
										  	try{
												d = DbDepartment.fetchExc(crd.getDepartmentId());	
											}
											catch(Exception e){
											}
										  	out.println(d.getCode()+" - "+d.getName());
										  }
										  else{
										  	out.println("TOTAL CORPORATE");
										  }
										  %>
                                          </td>
                                          <td class="<%=cssString%>" width="5%" height="17"> 
                                            <div align="center"><%=crd.getQty()%> 
                                              <input type="hidden" name="poqty_<%=crd.getOID()%>" value="<%=crd.getQty()%>">
                                            </div>
                                          </td>
                                          <td class="<%=cssString%>" width="6%" height="17"> 
                                            <div align="center">
												<%=recQty%>
                                            </div>
											
                                          </td>
                                          <td class="<%=cssString%>" width="6%" height="17"> 
                                            <div align="center"> 
												<%=invItem.getInvQty()%>
                                            </div>
                                          </td>
                                          <td class="<%=cssString%>" width="9%" height="17"> 
                                            <div align="center">
											  <%=JSPFormater.formatNumber(invItem.getPrice(), "#,###.##")%>
                                            </div>
                                          </td>
                                          <td width="9%" class="<%=cssString%>" height="17"> 
                                            <div align="center">
											  <%=JSPFormater.formatNumber(invItem.getTotal(), "#,###.##")%>
                                            </div>
                                          </td>
                                          <td width="22%" class="<%=cssString%>" height="17"> 
											  <%=invItem.getMemo()%>
                                          </td>
                                        </tr>
										<%
										}
										catch(Exception e){
											System.out.println(e.toString());
										}
										
										}}%>
                                        <%}}%>
                                      </table>
                                    </td>
                                  </tr>
                                  <tr align="left"> 
                                    <td width="12%"  >&nbsp;</td>
                                    <td  width="28%">&nbsp; </td>
                                    <td  width="10%">&nbsp;</td>
                                    <td  width="50%">&nbsp;</td>
                                  </tr>
                                  <tr align="left"> 
                                    <td colspan="2"  > 
									<%if(invoice.getOID()==0 || invoice.getStatus().equals(I_Project.STATUS_NOT_POSTED)){
									//if(invoice.getStatus().equals(I_Project.STATUS_NOT_POSTED)){
									%>
                                      <table width="100%" border="0" cellspacing="0" cellpadding="0">
									   <%if(iJSPCommand==JSPCommand.SAVE){
									   		if(iErrCode!=0){%>
                                        <tr> 
                                          <td> 
                                            <table border="0" cellpadding="2" cellspacing="0" class="warning" align="left" width="250">
                                              <tr> 
                                                <td width="24"><img src="../images/error.gif" width="18" height="18"></td>
                                                <td width="218" nowrap>Error, 
                                                  incomplete data input</td>
                                              </tr>
                                            </table>
                                          </td>
                                        </tr>
										<%}else{%>
										<tr> 
                                          <td> 
                                            <table border="0" cellpadding="2" cellspacing="0" class="success" align="left" width="216">
                                              <tr> 
                                                <td width="20"><img src="../images/success.gif" width="20" height="20"></td>
                                                <td width="150" nowrap>Data has 
                                                  been saved</td>
                                              </tr>
                                            </table>
                                          </td>
                                        </tr>
										<%}%>
                                        <tr>
                                          <td height="5"></td>
                                        </tr>
										<%}%>
                                        <tr> 
                                          <td><a href="javascript:cmdSave()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('print1111','','../images/savedoc2.gif',1)"><img src="../images/savedoc.gif" name="print1111" border="0"></a></td>
                                        </tr>
                                      </table>
									 <%}%> 
                                    </td>
                                    <td  width="10%">&nbsp;</td>
                                    <td  width="50%"> 
                                      <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                        <tr> 
                                          <td width="30%">&nbsp;</td>
                                          <td width="70%" class="boxed1"> 
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0" align="right">
                                              <tr> 
                                                <td width="42%" class="tablecell"> 
                                                  <div align="left"><b>&nbsp;SUB 
                                                    TOTAL </b></div>
                                                </td>
                                                <td width="16%" class="tablecell">&nbsp;</td>
                                                <td width="42%" class="tablecell"> 
                                                  <div align="right"> 
                                                    <input type="text" name="<%=jspInvoice.colNames[jspInvoice.JSP_SUB_TOTAL]%>" value="<%=JSPFormater.formatNumber(invoice.getSubTotal(), "#,###.##")%>" style="text-align:right" size="20" class="readonly rightalign" readOnly>
                                                  </div>
                                                </td>
                                              </tr>
                                              <tr> 
                                                <td width="42%" class="tablecell"> 
                                                  <div align="left"><b>&nbsp;VAT 
                                                    </b></div>
                                                </td>
                                                <td width="16%" class="tablecell"> 
                                                  <div align="center"> 
                                                    <input type="text" name="<%=jspInvoice.colNames[jspInvoice.JSP_VAT_PERCENT]%>" value="<%=JSPFormater.formatNumber(invoice.getVatPercent(), "#,###.##")%>" style="text-align:right" size="5"  onBlur="javascript:cmdUpdateDiscount()" class="readonly" readOnly>
                                                    % </div>
                                                </td>
                                                <td width="42%" class="tablecell"> 
                                                  <div align="right"> 
                                                    <input type="text" name="<%=jspInvoice.colNames[jspInvoice.JSP_VAT_AMOUNT]%>" value="<%=JSPFormater.formatNumber(invoice.getVatAmount(), "#,###.##")%>" style="text-align:right" size="20" class="readonly rightalign" readOnly>
                                                  </div>
                                                </td>
                                              </tr>
                                              <tr> 
                                                <td width="42%" class="tablecell"> 
                                                  <div align="left"><b>&nbsp;GRAND 
                                                    TOTAL </b></div>
                                                </td>
                                                <td width="16%" class="tablecell">&nbsp;</td>
                                                <td width="42%" class="tablecell"> 
                                                  <div align="right"> 
                                                    <input type="text" name="<%=jspInvoice.colNames[jspInvoice.JSP_GRAND_TOTAL]%>" value="<%=JSPFormater.formatNumber(invoice.getGrandTotal(), "#,###.##")%>" style="text-align:right" size="20" class="readonly rightalign" readOnly>
                                                  </div>
                                                </td>
                                              </tr>
                                            </table>
                                          </td>
                                        </tr>
                                      </table>
                                    </td>
                                  </tr>
                                  <tr align="left"> 
                                    <td width="12%" height="20"  >&nbsp;</td>
                                    <td  width="28%" height="20">&nbsp;</td>
                                    <td  width="10%" height="20">&nbsp;</td>
                                    <td  width="50%" height="20">&nbsp;</td>
                                  </tr>
								  <%if(invoice.getOID()!=0 && iErrCode==0 && invoice.getStatus().equals(I_Project.STATUS_NOT_POSTED)){%>
                                  <tr align="left"> 
                                    <td colspan="4"  background="../images/line.gif" ><img src="../images/line.gif" width="39" height="5"></td>
                                  </tr>
                                  <tr align="left"> 
                                    <td colspan="4"  > 
                                      <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                        <tr> 
                                          <td width="8%"><a href="javascript:cmdSubmitCommand()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('post','','../images/post_journal2.gif',1)"><img src="../images/post_journal.gif" name="post" width="92" height="22" border="0"></a></td>
                                          <td width="68%">&nbsp;</td>
                                          <td width="24%"> 
                                            <div align="right" class="msgnextaction"> 
                                              <table border="0" cellpadding="5" cellspacing="0" class="info" width="219" align="right">
                                                <tr> 
                                                  <td width="13"><img src="../images/inform.gif" width="20" height="20"></td>
                                                  <td width="186" nowrap>Journal 
                                                    is ready to be posted</td>
                                                </tr>
                                              </table>
                                            </div>
                                          </td>
                                        </tr>
                                      </table>
                                    </td>
                                  </tr>
								  <%}%>
                                  <tr align="left"> 
                                    <td width="12%"  >&nbsp;</td>
                                    <td  width="28%">&nbsp;</td>
                                    <td  width="10%">&nbsp;</td>
                                    <td  width="50%">&nbsp;</td>
                                  </tr>
								  <%if(invoice.getOID()!=0 && iErrCode==0 && invoice.getStatus().equals(I_Project.STATUS_POSTED)){%>
                                  <tr> 
                                    <td colspan="4" background="../images/line.gif"><img src="../images/line.gif" width="39" height="5"></td>
                                  </tr>
                                  <tr> 
                                    <td colspan="4"> 
                                      <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                        <tr> 
                                          <td width="48%"> 
                                            <table width="69%" border="0" cellspacing="0" cellpadding="0">
                                              <tr> 
                                                <td width="13%"><a href="javascript:cmdPrintJournal()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('print3','','../images/print2.gif',1)"><img src="../images/print.gif" name="print3" width="53" height="22" border="0"></a></td>
                                                <td width="5%"><img src="<%=approot%>/images/spacer.gif" width="20" height="10"></td>
                                                <td width="13%"><a href="javascript:cmdBack()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('print11','','../images/back2.gif',1)"><img src="../images/back.gif" name="print11"  border="0"></a></td>
                                                <td width="4%"><img src="<%=approot%>/images/spacer.gif" width="20" height="10"></td>
                                                <td width="42%"><a href="../home.jsp" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('print1','','../images/close2.gif',1)"><img src="../images/close.gif" name="print1"  border="0"></a></td>
                                                <td width="0%">&nbsp;</td>
                                                <td width="0%">&nbsp;</td>
                                              </tr>
                                            </table>
                                          </td>
                                          <td width="52%"> 
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
                                  <tr align="left"> 
                                    <td colspan="4"> 
                                      <%
										ctrLine.setLocationImg(approot+"/images/ctr_line");
										ctrLine.initDefault();
										ctrLine.setTableWidth("80%");
										String scomDel = "javascript:cmdAsk('"+oidInvoice+"')";
										String sconDelCom = "javascript:cmdConfirmDelete('"+oidInvoice+"')";
										String scancel = "javascript:cmdEdit('"+oidInvoice+"')";
										ctrLine.setBackCaption("Back to List");
										ctrLine.setDeleteCaption("Delete");
										ctrLine.setSaveCaption("Save");
										ctrLine.setAddCaption("");
										ctrLine.setJSPCommandStyle("buttonlink");

										if (privDelete){
											ctrLine.setConfirmDelJSPCommand(sconDelCom);
											ctrLine.setDeleteJSPCommand(scomDel);
											ctrLine.setEditJSPCommand(scancel);
										}else{ 
											ctrLine.setConfirmDelCaption("");
											ctrLine.setDeleteCaption("");
											ctrLine.setEditCaption("");
										}

										if(privAdd == false  && privUpdate == false){
											ctrLine.setSaveCaption("");
										}
			
										if (privAdd == false){
											ctrLine.setAddCaption("");
										}
										%>
                                      <%//= ctrLine.drawImage(iJSPCommand, iErrCode, errMsg)%>
                                    </td>
                                  </tr>
                                  <tr> 
                                    <td colspan="4">&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td colspan="4">&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td colspan="4">&nbsp;</td>
                                  </tr>
                                </table>
                              </td>
  </tr>
</table>
                          
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
