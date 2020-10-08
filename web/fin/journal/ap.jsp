<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.main.entity.*" %>
<%@ page import = "com.project.general.*" %>
<%@ page import = "com.project.fms.journal.*" %>
<%@ page import = "com.project.fms.master.*" %>
<%@ page import = "com.project.general.Currency" %>
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "com.project.system.*" %>
<%@ include file = "../main/javainit.jsp" %>
<% int  appObjCode = 1;// AppObjInfo.composeObjCode(AppObjInfo.--, AppObjInfo.--, AppObjInfo.--); %>
<%//@ include file = "../main/checkuser.jsp" %>
<%
/* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
boolean privAdd=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ADD));
boolean privUpdate=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_UPDATE));
boolean privDelete=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_DELETE));
%>
<!-- Jsp Block -->
<%!

	public String drawList(Vector objectClass ,  long apId)

	{
		JSPList ctrlist = new JSPList();
		ctrlist.setAreaWidth("100%");
		ctrlist.setListStyle("listgen");
		ctrlist.setTitleStyle("tableheader");
		ctrlist.setCellStyle("cellStyle");
		ctrlist.setHeaderStyle("tableheader");
		ctrlist.addHeader("Date","14%");
		ctrlist.addHeader("Due Date","14%");
		ctrlist.addHeader("Number Counter","14%");
		ctrlist.addHeader("Amount","14%");
		ctrlist.addHeader("Invoice Number","14%");
		ctrlist.addHeader("Status","14%");
		ctrlist.addHeader("Total Payment","14%");

		ctrlist.setLinkRow(0);
		ctrlist.setLinkSufix("");
		Vector lstData = ctrlist.getData();
		Vector lstLinkData = ctrlist.getLinkData();
		ctrlist.setLinkPrefix("javascript:cmdEdit('");
		ctrlist.setLinkSufix("')");
		ctrlist.reset();
		int index = -1;

		for (int i = 0; i < objectClass.size(); i++) {
			Ap ap = (Ap)objectClass.get(i);
			 Vector rowx = new Vector();
			 if(apId == ap.getOID())
				 index = i;

			String str_dt_Date = ""; 
			try{
				Date dt_Date = ap.getDate();
				if(dt_Date==null){
					dt_Date = new Date();
				}

				str_dt_Date = JSPFormater.formatDate(dt_Date, "dd MMMM yyyy");
			}catch(Exception e){ str_dt_Date = ""; }

			rowx.add(str_dt_Date);

			String str_dt_DueDate = ""; 
			try{
				Date dt_DueDate = ap.getDueDate();
				if(dt_DueDate==null){
					dt_DueDate = new Date();
				}

				str_dt_DueDate = JSPFormater.formatDate(dt_DueDate, "dd MMMM yyyy");
			}catch(Exception e){ str_dt_DueDate = ""; }

			rowx.add(str_dt_DueDate);

			rowx.add(String.valueOf(ap.getNumberCounter()));

			rowx.add(String.valueOf(ap.getAmount()));

			rowx.add(ap.getInvoiceNumber());

			rowx.add(ap.getStatus());

			rowx.add(String.valueOf(ap.getTotalPayment()));

			lstData.add(rowx);
			lstLinkData.add(String.valueOf(ap.getOID()));
		}

		return ctrlist.drawList(index);
	}

%>
<%
int iJSPCommand = JSPRequestValue.requestCommand(request);
int start = JSPRequestValue.requestInt(request, "start");
int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
long oidAp = JSPRequestValue.requestLong(request, "hidden_ap_id");

/*variable declaration*/
int recordToGet = 10;
String msgString = "";
int iErrCode = JSPMessage.NONE;
String whereClause = "";
String orderClause = "";

CmdAp ctrlAp = new CmdAp(request);
JSPLine ctrLine = new JSPLine();
Vector listAp = new Vector(1,1);

/*switch statement */
iErrCode = ctrlAp.action(iJSPCommand , oidAp);
/* end switch*/
JspAp jspAp = ctrlAp.getForm();

/*count list All Ap*/
int vectSize = DbAp.getCount(whereClause);

Ap ap = ctrlAp.getAp();
msgString =  ctrlAp.getMessage();



if((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV )||
  (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)){
		start = ctrlAp.actionList(iJSPCommand, start, vectSize, recordToGet);
 } 
/* end switch list*/

/* get record to display */
listAp = DbAp.list(start,recordToGet, whereClause , orderClause);

/*handle condition if size of record to display = 0 and start > 0 	after delete*/
if (listAp.size() < 1 && start > 0)
{
	 if (vectSize - recordToGet > recordToGet)
			start = start - recordToGet;   //go to JSPCommand.PREV
	 else{
		 start = 0 ;
		 iJSPCommand = JSPCommand.FIRST;
		 prevJSPCommand = JSPCommand.FIRST; //go to JSPCommand.FIRST
	 }
	 listAp = DbAp.list(start,recordToGet, whereClause , orderClause);
}

int nextCounter = DbJournal.getNextVoucherCounter(new Date());
String nextVcoucher = DbJournal.getNextVoucherNumber(new Date(), nextCounter);

Vector vendors = DbVendor.list(0,0, "", "code, name");

%>
<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
<head>
<!-- #BeginEditable "javascript" --> 
<title>Finance System - PNK</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<link href="../css/default.css" rel="stylesheet" type="text/css" />
<link href="../css/css.css" rel="stylesheet" type="text/css" />
<script language="JavaScript">

function cmdVendorEdit(){
	var oid = document.frmap.<%=jspAp.colNames[JspAp.JSP_VENDOR_ID] %>.value;
	window.open("<%=approot%>/journal/vendoredt.jsp?hidden_vendor_id="+oid+"&command=<%=JSPCommand.EDIT%>","vndedt","addressbar=no, scrollbars=yes,height=400,width=400, menubar=no,toolbar=no,location=no,");
}

function cmdVendorChange(){
	var oid = document.frmap.<%=jspAp.colNames[JspAp.JSP_VENDOR_ID] %>.value;
	<%if(vendors!=null && vendors.size()>0){
		 for(int i=0; i<vendors.size(); i++){
		 	Vendor x = (Vendor)vendors.get(i);
	%> 
		    if(oid=='<%=x.getOID()%>'){
				document.frmap.address1.value="<%=x.getAddress()%>";
				document.frmap.address2.value="<%=x.getCity()+((x.getState().length()>0) ? ", "+x.getState() : "")%>";
			}		
	
	<%}}%>
}

function cmdAdd(){
	document.frmap.hidden_ap_id.value="0";
	document.frmap.command.value="<%=JSPCommand.ADD%>";
	document.frmap.prev_command.value="<%=prevJSPCommand%>";
	document.frmap.action="ap.jsp";
	document.frmap.submit();
}

function cmdAsk(oidAp){
	document.frmap.hidden_ap_id.value=oidAp;
	document.frmap.command.value="<%=JSPCommand.ASK%>";
	document.frmap.prev_command.value="<%=prevJSPCommand%>";
	document.frmap.action="ap.jsp";
	document.frmap.submit();
}

function cmdConfirmDelete(oidAp){
	document.frmap.hidden_ap_id.value=oidAp;
	document.frmap.command.value="<%=JSPCommand.DELETE%>";
	document.frmap.prev_command.value="<%=prevJSPCommand%>";
	document.frmap.action="ap.jsp";
	document.frmap.submit();
}
function cmdSave(){
	document.frmap.command.value="<%=JSPCommand.SAVE%>";
	document.frmap.prev_command.value="<%=prevJSPCommand%>";
	document.frmap.action="ap.jsp";
	document.frmap.submit();
	}

function cmdEdit(oidAp){
	document.frmap.hidden_ap_id.value=oidAp;
	document.frmap.command.value="<%=JSPCommand.EDIT%>";
	document.frmap.prev_command.value="<%=prevJSPCommand%>";
	document.frmap.action="ap.jsp";
	document.frmap.submit();
	}

function cmdCancel(oidAp){
	document.frmap.hidden_ap_id.value=oidAp;
	document.frmap.command.value="<%=JSPCommand.EDIT%>";
	document.frmap.prev_command.value="<%=prevJSPCommand%>";
	document.frmap.action="ap.jsp";
	document.frmap.submit();
}

function cmdBack(){
	document.frmap.command.value="<%=JSPCommand.BACK%>";
	document.frmap.action="ap.jsp";
	document.frmap.submit();
	}

function cmdListFirst(){
	document.frmap.command.value="<%=JSPCommand.FIRST%>";
	document.frmap.prev_command.value="<%=JSPCommand.FIRST%>";
	document.frmap.action="ap.jsp";
	document.frmap.submit();
}

function cmdListPrev(){
	document.frmap.command.value="<%=JSPCommand.PREV%>";
	document.frmap.prev_command.value="<%=JSPCommand.PREV%>";
	document.frmap.action="ap.jsp";
	document.frmap.submit();
	}

function cmdListNext(){
	document.frmap.command.value="<%=JSPCommand.NEXT%>";
	document.frmap.prev_command.value="<%=JSPCommand.NEXT%>";
	document.frmap.action="ap.jsp";
	document.frmap.submit();
}

function cmdListLast(){
	document.frmap.command.value="<%=JSPCommand.LAST%>";
	document.frmap.prev_command.value="<%=JSPCommand.LAST%>";
	document.frmap.action="ap.jsp";
	document.frmap.submit();
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
<body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif')">
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
                      <td class="title"><!-- #BeginEditable "title" --><span class="level1">Cash </span> &raquo; 
                        <span class="level1">Petty Cash</span> &raquo; <span class="level2">Payment<br>
                        </span><!-- #EndEditable --></td>
                    </tr>
                    <!--tr> 
                      <td><img src="<%=approot%>/images/title-sp.gif" width="584" height="1"></td> 
                    </tr-->
                    <tr> 
                      <td><!-- #BeginEditable "content" --> 
              <form name="frmap" method ="post" action="">
                <input type="hidden" name="command" value="<%=iJSPCommand%>">
                <input type="hidden" name="vectSize" value="<%=vectSize%>">
                <input type="hidden" name="start" value="<%=start%>">
                <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                <input type="hidden" name="hidden_ap_id" value="<%=oidAp%>">
                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                  <tr align="left" valign="top"> 
                    <td height="8"  colspan="3"> 
                      <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr align="left" valign="top"> 
                          <td height="8" valign="middle" colspan="3"> 
                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                              <tr align="left" valign="top"> 
                                <td height="8" valign="middle" colspan="3"></td>
                              </tr>
                              <tr align="left" valign="top"> 
                                <td height="16" valign="middle" colspan="3" class="comment"> 
                                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                    <tr> 
                                      <td width="27%"><b><u>Account Payable &gt; 
                                        New Bill</u></b> </td>
                                      <td width="73%">Voucher No : <%=nextVcoucher%> 
                                        <input type="hidden" name="<%=jspAp.colNames[JspAp.JSP_VOUCHER_COUNTER] %>"  value="<%= nextCounter %>" class="formElemen">
                                        <input type="hidden" name="<%=jspAp.colNames[JspAp.JSP_VOUCHER_NUMBER] %>"  value="<%= nextVcoucher %>" class="formElemen">
                                        , &nbsp;&nbsp;Date : <%=JSPFormater.formatDate(new Date(), "dd MMMM yyyy")%> 
                                        <input type="hidden" name="<%=jspAp.colNames[JspAp.JSP_VOUCHER_DATE] %>"  value="<%= JSPFormater.formatDate(new Date(), "dd/MM/yyyy") %>" class="formElemen">
                                      </td>
                                    </tr>
                                  </table>
                                </td>
                              </tr>
                              <tr align="left" valign="top"> 
                                <td height="14" valign="top" colspan="3" class="comment"> 
                                  <table width="100%" border="0" cellspacing="1" cellpadding="0">
                                    <tr> 
                                      <td width="6%" height="5"></td>
                                      <td width="22%" height="5"></td>
                                      <td width="3%" height="5"></td>
                                      <td width="9%" height="5"></td>
                                      <td width="58%" height="5"></td>
                                      <td width="2%" height="5"></td>
                                    </tr>
                                    <tr> 
                                      <td width="6%"><a href="javascript:cmdVendorEdit()"><u>Vendor</u></a> 
                                      </td>
                                      <td width="22%"> 
                                        <select name="<%=jspAp.colNames[JspAp.JSP_VENDOR_ID] %>" onChange="javascript:cmdVendorChange()">
                                          <%if(vendors!=null && vendors.size()>0){
											for(int i=0; i<vendors.size(); i++){
												Vendor v = (Vendor)vendors.get(i);
										%>
                                          <option value="<%=v.getOID()%>" <%if(ap.getVendorId()==v.getOID()){%>selected<%}%>><%=v.getCode()+" - "+v.getName()%></option>
                                          <%}}%>
                                        </select>
                                      </td>
                                      <td width="3%">&nbsp;</td>
                                      <td width="9%">Date</td>
                                      <td width="58%"> 
                                        <input name="<%=jspAp.colNames[JspAp.JSP_DATE] %>" value="<%=JSPFormater.formatDate((ap.getDate()==null) ? new Date() : ap.getDate(), "dd/MM/yyyy")%>" size="11">
                                        <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmap.<%=jspAp.colNames[JspAp.JSP_DATE] %>);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> 
                                      </td>
                                      <td width="2%">&nbsp;</td>
                                    </tr>
                                    <tr> 
                                      <td width="6%">Address</td>
                                      <td width="22%"> 
                                        <input type="text" name="address1" size="40" value="" readOnly>
                                      </td>
                                      <td width="3%">&nbsp;</td>
                                      <td width="9%">Invoice Number</td>
                                      <td width="58%"> 
                                        <input type="text" name="<%=jspAp.colNames[JspAp.JSP_INVOICE_NUMBER] %>"  value="<%= ap.getInvoiceNumber() %>" class="formElemen">
                                      </td>
                                      <td width="2%">&nbsp;</td>
                                    </tr>
                                    <tr> 
                                      <td width="6%">&nbsp;</td>
                                      <td width="22%"> 
                                        <input type="text" name="address2" size="40" value="" readOnly>
                                      </td>
                                      <td width="3%">&nbsp;</td>
                                      <td width="9%">Due Date</td>
                                      <td width="58%"> 
                                        <input name="<%=jspAp.colNames[JspAp.JSP_DUE_DATE] %>" value="<%=JSPFormater.formatDate((ap.getDueDate()==null) ? new Date() : ap.getDueDate(), "dd/MM/yyyy")%>" size="11">
                                        <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmap.<%=jspAp.colNames[JspAp.JSP_DUE_DATE] %>);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> 
                                      </td>
                                      <td width="2%">&nbsp;</td>
                                    </tr>
                                    <tr> 
                                      <td width="6%" height="5"></td>
                                      <td colspan="4" height="5"></td>
                                      <td width="2%" height="5"></td>
                                    </tr>
                                    <tr> 
                                      <td width="6%">Memo</td>
                                      <td colspan="4"> 
                                        <input type="text" name="<%=jspAp.colNames[JspAp.JSP_MEMO] %>" class="formElemen" size="90" value="<%= ap.getMemo() %>">
                                      </td>
                                      <td width="2%">&nbsp;</td>
                                    </tr>
                                    <tr> 
                                      <td width="6%" height="5"></td>
                                      <td width="22%" height="5"></td>
                                      <td width="3%" height="5"></td>
                                      <td width="9%" height="5"></td>
                                      <td width="58%" height="5"></td>
                                      <td width="2%" height="5"></td>
                                    </tr>
                                    <tr> 
                                      <td colspan="5" class="boxed4"> 
                                        <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                          <tr> 
                                            <td colspan="5" height="5"></td>
                                          </tr>
                                          <tr> 
                                            <td width="102">&nbsp;<u><b>Detail 
                                              </b></u></td>
                                            <td width="292">&nbsp;</td>
                                            <td width="59">&nbsp;</td>
                                            <td width="229">&nbsp;</td>
                                            <td width="193">&nbsp;</td>
                                          </tr>
                                          <tr> 
                                            <td colspan="5"> 
                                              <table width="100%" border="0" cellspacing="1" cellpadding="0">
                                                <tr> 
                                                  <td class="tablehdr" width="10%" height="16">Department</td>
                                                  <td class="tablehdr" width="30%" height="16"> 
                                                    Account</td>
                                                  <td class="tablehdr" width="6%" height="16">Curr</td>
                                                  <td class="tablehdr" width="11%" height="16">Exc. 
                                                    Rate </td>
                                                  <td class="tablehdr" width="14%" height="16">Debet</td>
                                                  <td class="tablehdr" width="14%" height="16">Credit</td>
                                                  <td class="tablehdr" width="15%" height="16">Memo</td>
                                                </tr>
                                                <tr> 
                                                  <td class="tablecell" width="10%"> 
                                                    <div align="center"><b>Payable 
                                                      Account</b> </div>
                                                  </td>
                                                  <td class="tablecell" width="30%"> 
                                                    <%
											  Vector coasExp = DbCoa.list(0,0, "account_group='"+I_Project.ACC_GROUP_CURRENT_LIABILITIES+"' and status='"+I_Project.ACCOUNT_LEVEL_POSTABLE+"'", "code");
											  %>
                                                    <select name="select">
                                                      <%if(coasExp!=null && coasExp.size()>0){
													for(int i=0; i<coasExp.size(); i++){
														Coa coa = (Coa)coasExp.get(i);
												%>
                                                      <option value="<%=coa.getOID()%>"><%=coa.getCode()+" - "+coa.getName()%></option>
                                                      <%}}%>
                                                    </select>
                                                  </td>
                                                  <td class="tablecell" width="6%"> 
                                                    <div align="center"> 
                                                      <%
											  Vector currencies = DbCurrency.list(0,0, "", "");
											  %>
                                                      <select name="select2">
                                                        <%if(currencies!=null && currencies.size()>0){
													for(int i=0; i<currencies.size(); i++){
														Currency c = (Currency)currencies.get(i);
												%>
                                                        <option selected value="<%=c.getOID()%>"><%=c.getCurrencyCode()%></option>
                                                        <%}}%>
                                                      </select>
                                                    </div>
                                                  </td>
                                                  <td class="tablecell" width="11%"> 
                                                    <div align="center"> 
                                                      <input type="text" name="textfield322" size="15">
                                                    </div>
                                                  </td>
                                                  <td class="tablecell" width="14%">&nbsp;</td>
                                                  <td class="tablecell" width="14%"> 
                                                    <div align="center"> 
                                                      <input type="text" name="textfield3" size="25">
                                                    </div>
                                                  </td>
                                                  <td class="tablecell" width="15%"> 
                                                    <input type="text" name="textfield323" size="30">
                                                  </td>
                                                </tr>
                                                <tr> 
                                                  <td width="10%" class="tablecell"> 
                                                    <%
												  Vector dep = DbDepartment.list(0,0, "", "");
												  %>
                                                    <select name="select4">
                                                      <%if(dep!=null && dep.size()>0){
													  		for(int i=0; i<dep.size(); i++){
																Department d = (Department)dep.get(i);
													  %>
                                                      <option value="<%=d.getOID()%>"><%=d.getName()%></option>
                                                      <%}}%>
                                                    </select>
                                                  </td>
                                                  <td width="30%" class="tablecell"> 
                                                    <%
													//check for activity
													Vector coas = new Vector();
													if(includeActivity){
													
													}else{													
												  		coas = DbCoa.list(0,0, "account_group<>'"+I_Project.ACC_GROUP_CURRENT_LIABILITIES+"' and status='"+I_Project.ACCOUNT_LEVEL_POSTABLE+"'", "code");
												    }
												  %>
                                                    <select name="select5">
                                                      <%if(coas!=null && coas.size()>0){
													for(int i=0; i<coas.size(); i++){
														Coa coa = (Coa)coas.get(i);
												%>
                                                      <option value="<%=coa.getOID()%>"><%=coa.getCode()+" - "+coa.getName()%></option>
                                                      <%}}%>
                                                    </select>
                                                  </td>
                                                  <td width="6%" class="tablecell"> 
                                                    <div align="center"> 
                                                      <select name="select3">
                                                        <%if(currencies!=null && currencies.size()>0){
													for(int i=0; i<currencies.size(); i++){
														Currency c = (Currency)currencies.get(i);
												%>
                                                        <option selected value="<%=c.getOID()%>"><%=c.getCurrencyCode()%></option>
                                                        <%}}%>
                                                      </select>
                                                    </div>
                                                  </td>
                                                  <td width="11%" class="tablecell"> 
                                                    <div align="center"> 
                                                      <input type="text" name="textfield3222" size="15">
                                                    </div>
                                                  </td>
                                                  <td width="14%" class="tablecell"> 
                                                    <div align="center"> 
                                                      <input type="text" name="textfield32" size="25">
                                                    </div>
                                                  </td>
                                                  <td width="14%" class="tablecell">&nbsp;</td>
                                                  <td width="15%" class="tablecell">&nbsp;</td>
                                                </tr>
                                                <tr> 
                                                  <td width="10%">&nbsp;</td>
                                                  <td width="30%">&nbsp;</td>
                                                  <td width="6%">&nbsp;</td>
                                                  <td width="11%">&nbsp;</td>
                                                  <td width="14%">&nbsp;</td>
                                                  <td width="14%">&nbsp;</td>
                                                  <td width="15%">&nbsp;</td>
                                                </tr>
                                              </table>
                                            </td>
                                          </tr>
                                          <tr> 
                                            <td width="102">&nbsp;</td>
                                            <td width="292">&nbsp;</td>
                                            <td width="59">&nbsp;</td>
                                            <td width="229">&nbsp;</td>
                                            <td width="193">&nbsp;</td>
                                          </tr>
                                        </table>
                                      </td>
                                      <td width="2%">&nbsp;</td>
                                    </tr>
                                    <tr> 
                                      <td width="6%">&nbsp;</td>
                                      <td width="22%">&nbsp;</td>
                                      <td width="3%">&nbsp;</td>
                                      <td width="9%">&nbsp;</td>
                                      <td width="58%">&nbsp;</td>
                                      <td width="2%">&nbsp;</td>
                                    </tr>
                                    <tr> 
                                      <td width="6%">&nbsp;</td>
                                      <td width="22%">&nbsp;</td>
                                      <td width="3%">&nbsp;</td>
                                      <td width="9%">&nbsp;</td>
                                      <td width="58%">&nbsp;</td>
                                      <td width="2%">&nbsp;</td>
                                    </tr>
                                  </table>
                                </td>
                              </tr>
                            </table>
                          </td>
                        </tr>
                        <%
							try{
								if (listAp.size()>0){
							%>
                        <%  } 
						  }catch(Exception exc){ 
						  }%>
                      </table>
                    </td>
                  </tr>
                  <tr align="left" valign="top"> 
                    <td height="8" valign="middle" colspan="3"> 
                      <table width="100%" border="0" cellspacing="1" cellpadding="0">
                        <tr align="left"> 
                          <td height="21" valign="middle" width="17%">&nbsp;</td>
                          <td height="21" colspan="2" width="83%" class="comment" valign="top">*)= 
                            required</td>
                        </tr>
                        <tr align="left"> 
                          <td height="21" width="17%">Date</td>
                          <td height="21" colspan="2" width="83%" valign="top">&nbsp; 
                        <tr align="left"> 
                          <td height="21" width="17%">Due Date</td>
                          <td height="21" colspan="2" width="83%" valign="top">&nbsp; 
                        <tr align="left"> 
                          <td height="21" width="17%">&nbsp;</td>
                          <td height="21" colspan="2" width="83%" valign="top">&nbsp; 
                        <tr align="left"> 
                          <td height="21" valign="top" width="17%">&nbsp;</td>
                          <td height="21" colspan="2" width="83%" valign="top">&nbsp; 
                        <tr align="left"> 
                          <td height="21" valign="top" width="17%">Number Counter</td>
                          <td height="21" colspan="2" width="83%" valign="top"> 
                            <input type="text" name="<%=jspAp.colNames[JspAp.JSP_NUMBER_COUNTER] %>"  value="<%= ap.getNumberCounter() %>" class="formElemen">
                        <tr align="left"> 
                          <td height="21" valign="top" width="17%">Amount</td>
                          <td height="21" colspan="2" width="83%" valign="top"> 
                            <input type="text" name="<%=jspAp.colNames[JspAp.JSP_AMOUNT] %>"  value="<%= ap.getAmount() %>" class="formElemen">
                        <tr align="left"> 
                          <td height="21" valign="top" width="17%">Status</td>
                          <td height="21" colspan="2" width="83%" valign="top"> 
                            <input type="text" name="<%=jspAp.colNames[JspAp.JSP_STATUS] %>"  value="<%= ap.getStatus() %>" class="formElemen">
                        <tr align="left"> 
                          <td height="21" valign="top" width="17%">Currency</td>
                          <td height="21" colspan="2" width="83%" valign="top"> 
                            <input type="text" name="<%=jspAp.colNames[JspAp.JSP_CURRENCY] %>"  value="<%= ap.getCurrency() %>" class="formElemen">
                        <tr align="left"> 
                          <td height="21" width="17%">Periode Id</td>
                          <td height="21" colspan="2" width="83%" valign="top"> 
                            <input type="text" name="<%=jspAp.colNames[JspAp.JSP_PERIODE_ID] %>"  value="<%= ap.getPeriodeId() %>" class="formElemen">
                        <tr align="left"> 
                          <td height="21" width="17%">Exchange Rate</td>
                          <td height="21" colspan="2" width="83%" valign="top"> 
                            <input type="text" name="<%=jspAp.colNames[JspAp.JSP_EXCHANGE_RATE] %>"  value="<%= ap.getExchangeRate() %>" class="formElemen">
                        <tr align="left"> 
                          <td height="21" valign="middle" width="17%">Voucher 
                            Number</td>
                          <td height="21" colspan="2" width="83%" valign="top">&nbsp; 
                        <tr align="left"> 
                          <td height="21" valign="middle" width="17%">Voucher 
                            Date</td>
                          <td height="21" colspan="2" width="83%" valign="top">&nbsp; 
                        <tr align="left"> 
                          <td height="21" valign="middle" width="17%">Voucher 
                            Counter</td>
                          <td height="21" colspan="2" width="83%" valign="top">&nbsp; 
                        <tr align="left"> 
                          <td height="21" valign="middle" width="17%">User Id</td>
                          <td height="21" colspan="2" width="83%" valign="top"> 
                            <input type="text" name="<%=jspAp.colNames[JspAp.JSP_USER_ID] %>"  value="<%= ap.getUserId() %>" class="formElemen">
                        <tr align="left"> 
                          <td height="21" valign="middle" width="17%">Memo</td>
                          <td height="21" colspan="2" width="83%" valign="top">&nbsp; 
                        <tr align="left"> 
                          <td height="21" valign="middle" width="17%">Total Payment</td>
                          <td height="21" colspan="2" width="83%" valign="top"> 
                            <input type="text" name="<%=jspAp.colNames[JspAp.JSP_TOTAL_PAYMENT] %>"  value="<%= ap.getTotalPayment() %>" class="formElemen">
                        <tr align="left"> 
                          <td height="8" valign="middle" width="17%">&nbsp;</td>
                          <td height="8" colspan="2" width="83%" valign="top">&nbsp; 
                          </td>
                        </tr>
                        <tr align="left" > 
                          <td colspan="3" class="command" valign="top"> 
                            <%
									ctrLine.setLocationImg(approot+"/images/ctr_line");
									ctrLine.initDefault();
									ctrLine.setTableWidth("80%");
									String scomDel = "javascript:cmdAsk('"+oidAp+"')";
									String sconDelCom = "javascript:cmdConfirmDelete('"+oidAp+"')";
									String scancel = "javascript:cmdEdit('"+oidAp+"')";
									ctrLine.setBackCaption("Back to List");
									ctrLine.setJSPCommandStyle("buttonlink");
										ctrLine.setDeleteCaption("Delete");
										ctrLine.setSaveCaption("Save");
										ctrLine.setAddCaption("");

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
                            <%= ctrLine.drawImage(iJSPCommand, iErrCode, msgString)%> </td>
                        </tr>
                        <tr> 
                          <td width="13%">&nbsp;</td>
                          <td width="87%">&nbsp;</td>
                        </tr>
                        <tr align="left" > 
                          <td colspan="3" valign="top"> 
                            <div align="left"></div>
                          </td>
                        </tr>
                      </table>
                    </td>
                  </tr>
                </table>
                <script language="JavaScript">
					cmdVendorChange();
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
