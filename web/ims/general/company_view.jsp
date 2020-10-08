 
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.admin.*" %>
<%@ page import = "com.project.system.*" %>
<%@ page import = "com.project.main.db.*" %>
<!--package test -->
<%@ page import = "com.project.general.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ include file = "../main/javainit.jsp" %>
<% int  appObjCode = 1;// AppObjInfo.composeObjCode(AppObjInfo.--, AppObjInfo.--, AppObjInfo.--); %>
<%@ include file = "../main/check.jsp" %>
<%
	/* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
	boolean privAdd 	= true; //userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ADD));
	boolean privUpdate	= true; //userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_UPDATE));
	boolean privDelete	= true; //userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_DELETE));
%>
<!-- Jsp Block -->
<%!

	/*public String drawList(Vector objectClass ,  long companyId)

	{
		JSPList ctrlist = new JSPList();
		ctrlist.setAreaWidth("100%");
		ctrlist.setListStyle("listgen");
		ctrlist.setTitleStyle("tableheader");
		ctrlist.setCellStyle("cellStyle");
		ctrlist.setHeaderStyle("tableheader");
		::..error, can't generate list header, header is null..::

		ctrlist.setLinkRow(0);
		ctrlist.setLinkSufix("");
		Vector lstData = ctrlist.getData();
		Vector lstLinkData = ctrlist.getLinkData();
		ctrlist.setLinkPrefix("javascript:cmdEdit('");
		ctrlist.setLinkSufix("')");
		ctrlist.reset();
		int index = -1;::...error, can't generate record display, header es empty...::

		return ctrlist.drawList(index);
	}
	*/

%>
<%
int iJSPCommand = JSPRequestValue.requestCommand(request);
int start = JSPRequestValue.requestInt(request, "start");
int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
long oidCompany = JSPRequestValue.requestLong(request, "hidden_company_id");

double maxReplace = JSPRequestValue.requestDouble(request, "max_replenishment");
double maxTrans = JSPRequestValue.requestDouble(request, "max_transaction");

Company company = new Company();
try{
	company = DbCompany.fetchExc(oidCompany);
}
catch(Exception e){
}

if(iJSPCommand==JSPCommand.SUBMIT && maxTrans>0 && maxReplace>0){
	company.setMaxPettycashTransaction(maxTrans);
	company.setMaxPettycashReplenis(maxReplace);
	try{
		DbCompany.updateExc(company);
	}
	catch(Exception e){
	}
}



%>
<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
<head>
<!-- #BeginEditable "javascript" --> 
<title>POS Back Office</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<link href="../css/default.css" rel="stylesheet" type="text/css" />
<link href="../css/css.css" rel="stylesheet" type="text/css" />
<script language="JavaScript">

var sysDecSymbol = "<%=sSystemDecimalSymbol%>";
var usrDigitGroup = "<%=sUserDigitGroup%>";
var usrDecSymbol = "<%=sUserDecimalSymbol%>";

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


function checkNumber(){
	var st = document.frmcompany.max_replenishment.value;		
	
	var result = removeChar(st);
	
	result = cleanNumberFloat(result, sysDecSymbol, usrDigitGroup, usrDecSymbol);
	document.frmcompany.max_replenishment.value = formatFloat(result, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 
}

function checkNumber2(){
	var st1 = document.frmcompany.max_replenishment.value;		
	var result1 = removeChar(st1);
	result1 = cleanNumberFloat(result1, sysDecSymbol, usrDigitGroup, usrDecSymbol);
	
	var st = document.frmcompany.max_transaction.value;		
	
	var result = removeChar(st);
	
	result = cleanNumberFloat(result, sysDecSymbol, usrDigitGroup, usrDecSymbol);
	
	if(parseFloat(result)>parseFloat(result1)){
		alert('Transaction amount over the replenishment amount');
		document.frmcompany.max_transaction.value = formatFloat(result1, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 		
		document.frmcompany.max_transaction.select();
	}
	else{	
		document.frmcompany.max_transaction.value = formatFloat(result, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 
	}
}

function cmdAdd(){
	document.frmcompany.hidden_company_id.value="0";
	document.frmcompany.command.value="<%=JSPCommand.ADD%>";
	document.frmcompany.prev_command.value="<%=prevJSPCommand%>";
	document.frmcompany.action="company.jsp";
	document.frmcompany.submit();
}

function cmdAsk(oidCompany){
	document.frmcompany.hidden_company_id.value=oidCompany;
	document.frmcompany.command.value="<%=JSPCommand.ASK%>";
	document.frmcompany.prev_command.value="<%=prevJSPCommand%>";
	document.frmcompany.action="company.jsp";
	document.frmcompany.submit();
}

function cmdConfirmDelete(oidCompany){
	document.frmcompany.hidden_company_id.value=oidCompany;
	document.frmcompany.command.value="<%=JSPCommand.DELETE%>";
	document.frmcompany.prev_command.value="<%=prevJSPCommand%>";
	document.frmcompany.action="company.jsp";
	document.frmcompany.submit();
}
function cmdSave(){
	document.frmcompany.command.value="<%=JSPCommand.SUBMIT%>";
	document.frmcompany.action="company_view.jsp";
	document.frmcompany.submit();
	}

function cmdEdit(oidCompany){
	document.frmcompany.hidden_company_id.value=oidCompany;
	document.frmcompany.command.value="<%=JSPCommand.EDIT%>";
	document.frmcompany.prev_command.value="<%=prevJSPCommand%>";
	document.frmcompany.action="company.jsp";
	document.frmcompany.submit();
	}

function cmdCancel(oidCompany){
	document.frmcompany.hidden_company_id.value=oidCompany;
	document.frmcompany.command.value="<%=JSPCommand.EDIT%>";
	document.frmcompany.prev_command.value="<%=prevJSPCommand%>";
	document.frmcompany.action="company.jsp";
	document.frmcompany.submit();
}

function cmdBack(){
	document.frmcompany.command.value="<%=JSPCommand.BACK%>";
	document.frmcompany.action="company.jsp";
	document.frmcompany.submit();
	}

function cmdListFirst(){
	document.frmcompany.command.value="<%=JSPCommand.FIRST%>";
	document.frmcompany.prev_command.value="<%=JSPCommand.FIRST%>";
	document.frmcompany.action="company.jsp";
	document.frmcompany.submit();
}

function cmdListPrev(){
	document.frmcompany.command.value="<%=JSPCommand.PREV%>";
	document.frmcompany.prev_command.value="<%=JSPCommand.PREV%>";
	document.frmcompany.action="company.jsp";
	document.frmcompany.submit();
	}

function cmdListNext(){
	document.frmcompany.command.value="<%=JSPCommand.NEXT%>";
	document.frmcompany.prev_command.value="<%=JSPCommand.NEXT%>";
	document.frmcompany.action="company.jsp";
	document.frmcompany.submit();
}

function cmdListLast(){
	document.frmcompany.command.value="<%=JSPCommand.LAST%>";
	document.frmcompany.prev_command.value="<%=JSPCommand.LAST%>";
	document.frmcompany.action="company.jsp";
	document.frmcompany.submit();
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
<script language="JavaScript">
</script>
<!-- #EndEditable -->
</head>
<body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','../images/save2.gif')">
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
                <td width="165" height="100%" valign="top" background="<%=approot%>/images/leftbg.gif"> 
                  <!-- #BeginEditable "menu" --> 
                  <%@ include file="../main/menu.jsp"%>
                  <!-- #EndEditable -->
                </td>
                <td width="100%" valign="top"> 
                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    
                    <tr> 
                      <td><!-- #BeginEditable "content" --> 
                        <form name="frmcompany" method ="post" action="">
                          <input type="hidden" name="command" value="<%=iJSPCommand%>">
                          <input type="hidden" name="hidden_company_id" value="<%=oidCompany%>">
                          <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
						  <table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td class="container"> 
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                  <tr align="left" valign="top"> 
                                    <td height="8"  colspan="3"> 
                                      <table width="100%" border="0" cellspacing="1" cellpadding="1" height="17">
                                        <tr valign="bottom"> 
                                          <td width="60%" height="23"><b><font color="#990000" class="lvl1">Master 
                                            Maintenance </font><font class="tit1">&raquo; 
                                            </font><font class="tit1"><span class="lvl2">Company 
                                            Configuration</span></font></b></td>
                                          <td width="40%" height="23"> 
                                            <%@ include file = "../main/userpreview.jsp" %>
                                          </td>
                                        </tr>
                                        <tr > 
                                          <td colspan="2" height="3" background="<%=approot%>/images/line1.gif" ></td>
                                        </tr>
                                      </table>
                                    </td>
                                  </tr>
                                  <tr align="left" valign="top"> 
                                    <td height="8"  colspan="3">&nbsp;</td>
                                  </tr>
                                  <tr align="left" valign="top"> 
                                    <td height="8" valign="top" colspan="3"> 
                                      <table width="95%" border="0" cellspacing="1" cellpadding="0">
                                        <tr align="left"> 
                                          <td height="17" colspan="4"><i><font color="#990000"><b>Company 
                                            Profile</b></font></i></td>
                                        <tr align="left"> 
                                          <td height="8" width="21%"></td>
                                          <td height="8" width="22%"> 
                                          <td height="8" width="19%"> 
                                          <td height="8" width="37%"> 
                                        <tr align="left"> 
                                          <td height="17" width="21%"><b>Serial 
                                            Number</b></td>
                                          <td height="17" width="22%"> <%= (company.getSerialNumber().length()<1) ? "-" : company.getSerialNumber() %> 
                                          <td height="17" width="19%">&nbsp; 
                                          <td height="17" width="37%">&nbsp; 
                                        <tr align="left"> 
                                          <td height="17" width="21%"><b>Company 
                                            Name</b></td>
                                          <td height="17" colspan="3"> <%= company.getName() %> 
                                        <tr align="left"> 
                                          <td height="17" width="21%"><b>Address</b></td>
                                          <td height="17" colspan="3"> <%= company.getAddress() %> 
                                        <tr align="left"> 
                                          <td height="17" width="21%"><b></b></td>
                                          <td height="17" colspan="3"> <%= company.getAddress2() %> 
                                        <tr align="left"> 
                                          <td height="17" width="21%"><b>Contact 
                                            Person</b></td>
                                          <td height="17" colspan="3"> <%= company.getContact() %> 
                                        <tr align="left"> 
                                          <td height="17" width="21%">&nbsp;</td>
                                          <td height="17" width="22%">&nbsp; 
                                          <td height="17" width="19%">&nbsp; 
                                          <td height="17" width="37%">&nbsp; 
                                        <tr align="left"> 
                                          <td height="17" width="21%"><i><font color="#990000"><b>Financial 
                                            Setup</b></font></i></td>
                                          <td height="17" width="22%">&nbsp;</td>
                                          <td width="19%" class="command" height="17"><b><i><font color="#990000">Document 
                                            Prefix Code</font></i></b></td>
                                          <td height="17" width="37%">&nbsp;</td>
                                        <tr align="left"> 
                                          <td height="8" width="21%"></td>
                                          <td height="8" width="22%"> 
                                          <td width="19%" class="command" height="8"></td>
                                          <td height="8" width="37%"> 
                                        <tr align="left" > 
                                          <td height="17" width="21%"><b>Current 
                                            Fiscal Year</b></td>
                                          <td width="22%" class="command" height="17"> 
                                            <%=company.getFiscalYear()%> </td>
                                          <td height="17" width="19%"><b>&nbsp;Cash 
                                            Receive Code</b></td>
                                          <td width="37%" class="command" height="17"> 
                                            <%=company.getCashReceiveCode()%> </td>
                                        </tr>
                                        <tr align="left" > 
                                          <td height="17" width="21%"><b>End Fiscal 
                                            Month</b></td>
                                          <td width="22%" class="command" height="17"> 
                                            <%=I_Project.longMonths[company.getEndFiscalMonth()]%> </td>
                                          <td height="17" width="19%"><b>&nbsp;Petty 
                                            Cash Payment Code</b></td>
                                          <td width="37%" class="command" height="17"> 
                                            <%=company.getPettycashPaymentCode()%> </td>
                                        </tr>
                                        <tr align="left" > 
                                          <td height="17" width="21%"><b>Current 
                                            Open Period</b></td>
                                          <td width="22%" class="command" height="17"> 
                                            <%=I_Project.longMonths[company.getEntryStartMonth()]%> </td>
                                          <td height="17" width="19%"><b>&nbsp;Petty 
                                            Cash Replenishment Code</b></td>
                                          <td width="37%" class="command" height="17"> 
                                            <%=company.getPettycashReplaceCode()%> </td>
                                        </tr>
                                        <tr align="left" > 
                                          <td height="17" width="21%"><b>Number 
                                            Of Period in a Year</b></td>
                                          <td width="22%" class="command" height="17"> 
                                            <%=company.getNumberOfPeriod()%> </td>
                                          <td height="17" width="19%"><b>&nbsp;Bank 
                                            Deposit Code</b></td>
                                          <td width="37%" class="command" height="17"> 
                                            <%=company.getBankDepositCode()%> </td>
                                        </tr>
                                        <tr align="left" > 
                                          <td height="17" width="21%"><b>Booking 
                                            Currency</b></td>
                                          <td width="22%" class="command" height="17"> 
                                            <%
						  Currency c = new Currency();
						  try{
						  	c = DbCurrency.fetchExc(company.getBookingCurrencyId());
						  }
						  catch(Exception e){
						  }
						  %>
                                            <%=c.getCurrencyCode()%> </td>
                                          <td height="17" width="19%"><b>&nbsp;Bank 
                                            Payment with PO Code</b></td>
                                          <td width="37%" class="command" height="17"> 
                                            <%=company.getBankPaymentPoCode()%> </td>
                                        </tr>
                                        <tr align="left" > 
                                          <td height="17" width="21%"><b>System 
                                            Location</b></td>
                                          <td width="22%" class="command" height="17"> 
                                            <%
						  Location l = new Location();
						  try{
						  	l = DbLocation.fetchExc(company.getSystemLocation());
						  }
						  catch(Exception e){
						  }
						  %>
                                            <%=l.getCode() + " - "+ l.getName()%></td>
                                          <td height="17" width="19%"><b>&nbsp;Bank 
                                            Payment Non PO Code</b></td>
                                          <td width="37%" class="command" height="17"> 
                                            <%= (company.getBankPaymentNonpoCode())%> </td>
                                        </tr>
                                        <tr align="left" > 
                                          <td height="17" width="21%"><b>Max. 
                                            Petty Cash Replenishment</b></td>
                                          <td width="22%" class="command" height="17"> 
                                            <input type="text" name="max_replenishment" value="<%= JSPFormater.formatNumber(company.getMaxPettycashReplenis(), "#,###.##") %>" onClick="this.select()" style="text-align:right" onBlur="javascript:checkNumber()">
                                          </td>
                                          <td height="17" width="19%"><b>&nbsp;Purchase 
                                            Order Code</b></td>
                                          <td width="37%" class="command" height="17"> 
                                            <%= (company.getPurchaseOrderCode())%> </td>
                                        </tr>
                                        <tr align="left" > 
                                          <td height="17" width="21%"><b>Max. 
                                            Petty Cash Transaction</b></td>
                                          <td width="22%" class="command" height="17"> 
                                            <input type="text" name="max_transaction" value="<%= JSPFormater.formatNumber(company.getMaxPettycashTransaction(), "#,###.##") %>" onClick="this.select()" style="text-align:right" onBlur="javascript:checkNumber2()">
                                          </td>
                                          <td height="17" width="19%"><b>&nbsp;General 
                                            Ledger Code</b></td>
                                          <td width="37%" class="command" height="17"> 
                                            <%= (company.getGeneralLedgerCode())%> </td>
                                        </tr>
                                        <tr align="left" > 
                                          <td height="14"><b>Default Government 
                                            Tax</b></td>
                                          <td height="14"><%=JSPFormater.formatNumber(company.getGovernmentVat(), "#,###.#")%> %</td>
                                          <td height="21" width="15%"><b>&nbsp;Default 
                                            Sales Margins</b></td>
                                          <td height="14"> <%= company.getDefaultSalesMargin()%>%</td>
                                        </tr>
                                        <tr align="left" > 
                                          <td height="14"><b>Department Level</b></td>
                                          <td height="14"> 
                                            <%if(company.getDepartmentLevel()==-1){%>
                                            TOTAL CORPORATE 
                                            <%}else{%>
                                            <%=DbDepartment.strLevel[company.getDepartmentLevel()]%> 
                                            <%}%>
                                          </td>
                                          <td height="21" width="15%"><b>&nbsp;Purchase 
                                            Request Code </b></td>
                                          <td height="14"> <%=company.getPurchaseRequestCode()%></td>
                                        </tr>
                                        <tr align="left" > 
                                          <td height="14">&nbsp;</td>
                                          <td height="14">&nbsp;</td>
                                          <td height="21" width="15%"><b>&nbsp;Return 
                                            Goods Code</b></td>
                                          <td height="14"> <%=company.getReturnGoodsCode()%></td>
                                        </tr>
                                        <tr align="left" > 
                                          <td height="14">&nbsp;</td>
                                          <td height="14">&nbsp;</td>
                                          <td height="21" width="15%"><b>&nbsp;Transfer 
                                            Goods Code </b></td>
                                          <td height="14"> <%=company.getTransferGoodsCode()%> </td>
                                        </tr>
                                        <tr align="left" > 
                                          <td height="14">&nbsp;</td>
                                          <td height="14">&nbsp;</td>
                                          <td height="21" width="15%"><b>&nbsp;Costing 
                                            Goods Code </b></td>
                                          <td height="14"> <%=company.getCostingGoodsCode()%> </td>
                                        </tr>
                                        <tr align="left" > 
                                          <td height="14">&nbsp;</td>
                                          <td height="14">&nbsp;</td>
                                          <td height="21" width="15%"><b>&nbsp;Adjustment 
                                            Code</b></td>
                                          <td height="14"> <%=company.getAdjustmentCode()%></td>
                                        </tr>
                                        <tr align="left" > 
                                          <td height="14">&nbsp;</td>
                                          <td height="14">&nbsp;</td>
                                          <td height="21" width="15%"><b>&nbsp;Opname 
                                            Code</b></td>
                                          <td height="14"> <%=company.getOpnameCode()%> </td>
                                        </tr>
                                        <tr align="left" > 
                                          <td height="14">&nbsp;</td>
                                          <td height="14">&nbsp;</td>
                                          <td height="21" width="15%"><b>&nbsp;Integrated 
                                            Into Hotel System</b></td>
                                          <td height="14"> 
                                            <%if(company.getIntegratedHotelSystem()==1){%>
                                            YES 
                                            <%}%>
                                          </td>
                                        </tr>
                                        <tr align="left" > 
                                          <td height="14">&nbsp;</td>
                                          <td height="14">&nbsp;</td>
                                          <td height="21" width="15%"><b>&nbsp;Integrated 
                                            Into Finance System</b></td>
                                          <td height="14"> 
                                            <%if(company.getIntegratedFinanceSystem()==1){%>
                                            YES 
                                            <%}%>
                                          </td>
                                        </tr>
                                        <tr align="left" > 
                                          <td height="14">&nbsp;</td>
                                          <td height="14">&nbsp; </td>
                                          <td height="14"></td>
                                          <td height="14"></td>
                                        </tr>
                                        <tr align="left" > 
                                          <td height="8" colspan="4"> 
                                            <table width="80%" border="0" cellspacing="0" cellpadding="0">
                                              <tr> 
                                                <td background="../images/line.gif" height="5"></td>
                                              </tr>
                                            </table>
                                          </td>
                                        </tr>
                                        <tr> 
                                          <td colspan="2" height="17"> 
                                            <table width="99%" border="0" cellspacing="1" cellpadding="1">
                                              <tr> 
                                                <td width="6%"><a href="javascript:cmdSave()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new2','','../images/save2.gif',1)"><img src="../images/save.gif" name="new2"  border="0"></a></td>
                                                <td width="94%">&nbsp;</td>
                                              </tr>
                                            </table>
                                          </td>
                                          <td width="19%" height="17">&nbsp;</td>
                                          <td width="37%" height="17">&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td width="21%" height="17">&nbsp;</td>
                                          <td width="22%" height="17">&nbsp;</td>
                                          <td width="19%" height="17">&nbsp;</td>
                                          <td width="37%" height="17">&nbsp;</td>
                                        </tr>
                                      </table>
                                    </td>
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
