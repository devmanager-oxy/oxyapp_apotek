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
<!--



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
//-->
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
                                      <td width="29%"><font size="3"><b><font face="Geneva, Arial, Helvetica, san-serif"><u>PURCHASES</u></font></b></font></td>
                                      <td width="24%"><font size="3"><b><font face="Geneva, Arial, Helvetica, san-serif"><u>NEW 
                                        BILL </u></font></b></font></td>
                                      <td width="47%">&nbsp;Date : <%=JSPFormater.formatDate(new Date(), "dd MMMM yyyy")%> 
                                        <input type="hidden" name="<%=jspAp.colNames[JspAp.JSP_VOUCHER_DATE] %>"  value="<%= JSPFormater.formatDate(new Date(), "dd/MM/yyyy") %>" class="formElemen">
                                        , Operator : Admin</td>
                                    </tr>
                                  </table>
                                </td>
                              </tr>
                              <tr align="left" valign="top"> 
                                <td height="14" valign="top" colspan="3" class="comment"> 
                                  <table width="100%" border="0" cellspacing="1" cellpadding="0">
                                    <tr> 
                                      <td width="9%" height="5"></td>
                                      <td width="25%" height="5"></td>
                                      <td width="2%" height="5"></td>
                                      <td width="9%" height="5"></td>
                                      <td width="55%" height="5"></td>
                                      <td width="0%" height="5"></td>
                                    </tr>
                                    <tr> 
                                      <td width="9%" valign="middle">&nbsp;</td>
                                      <td width="25%">&nbsp; </td>
                                      <td width="2%">&nbsp;</td>
                                      <td width="9%">&nbsp;</td>
                                      <td width="55%">&nbsp; </td>
                                      <td width="0%">&nbsp;</td>
                                    </tr>
                                    <tr> 
                                      <td width="9%"><a href="javascript:cmdVendorEdit()" title="click to manage vendor"><u>Vendor</u></a> 
                                      </td>
                                      <td width="25%"> 
                                        <select name="select6">
                                          <option selected>V001 - PT. Maju Jaya</option>
                                          <option>V002 - CV Rahayu</option>
                                        </select>
                                      </td>
                                      <td width="2%">&nbsp;</td>
                                      <td width="9%">Purchase Nomber</td>
                                      <td width="55%">PO11070001 </td>
                                      <td width="0%">&nbsp;</td>
                                    </tr>
                                    <tr> 
                                      <td width="9%">&nbsp;</td>
                                      <td width="25%"><b><i> 
                                        <textarea name="textfield" cols="45" rows="3">Vendor address ..</textarea>
                                        </i></b></td>
                                      <td width="2%">&nbsp;</td>
                                      <td width="9%" valign="top">Transaction 
                                        Date</td>
                                      <td width="55%" valign="top"> 
                                        <input name="<%=jspAp.colNames[JspAp.JSP_DATE] %>" value="<%=JSPFormater.formatDate((ap.getDate()==null) ? new Date() : ap.getDate(), "dd/MM/yyyy")%>" size="11">
                                        <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmap.<%=jspAp.colNames[JspAp.JSP_DATE] %>);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> 
                                      </td>
                                      <td width="0%">&nbsp;</td>
                                    </tr>
                                    <tr> 
                                      <td width="9%">PO Currency</td>
                                      <td width="25%"> 
                                        <select name="select3">
                                          <option>USD</option>
                                          <option selected>Rp.</option>
                                        </select>
                                      </td>
                                      <td width="2%">&nbsp;</td>
                                      <td width="9%">Ship To</td>
                                      <td width="55%" valign="top"> 
                                        <select name="select7">
                                          <option selected>Address 1</option>
                                          <option>Address 2</option>
                                        </select>
                                      </td>
                                      <td width="0%">&nbsp;</td>
                                    </tr>
                                    <tr> 
                                      <td width="9%">Vendor Invoice No </td>
                                      <td width="25%"> 
                                        <input type="text" name="<%=jspAp.colNames[JspAp.JSP_INVOICE_NUMBER] %>2"  value="<%= ap.getInvoiceNumber() %>" class="formElemen">
                                      </td>
                                      <td width="2%">&nbsp;</td>
                                      <td width="9%">&nbsp;</td>
                                      <td rowspan="4" width="55%" valign="top"> 
                                        <textarea name="address1" cols="40" readonly="readOnly" rows="4">Jln. Teuku Umar 123x. Denpasar - Bali</textarea>
                                      </td>
                                      <td width="0%">&nbsp;</td>
                                    </tr>
                                    <tr> 
                                      <td width="9%"><a href="#" title="click to manage payment term">Term 
                                        Of Payment</a></td>
                                      <td width="25%"> 
                                        <select name="select2">
                                          <option>Consignment</option>
                                          <option>Due on receive</option>
                                          <option>Net 15</option>
                                          <option>Net 30</option>
                                          <option>Net 60</option>
                                        </select>
                                      </td>
                                      <td width="2%">&nbsp;</td>
                                      <td width="9%">&nbsp;</td>
                                      <td width="0%">&nbsp;</td>
                                    </tr>
                                    <tr> 
                                      <td width="9%">Due Date</td>
                                      <td width="25%"> 
                                        <input name="<%=jspAp.colNames[JspAp.JSP_DUE_DATE] %>" value="<%=JSPFormater.formatDate((ap.getDueDate()==null) ? new Date() : ap.getDueDate(), "dd/MM/yyyy")%>" size="11">
                                        <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmap.<%=jspAp.colNames[JspAp.JSP_DUE_DATE] %>);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> 
                                      </td>
                                      <td width="2%">&nbsp;</td>
                                      <td width="9%">&nbsp;</td>
                                      <td width="0%">&nbsp;</td>
                                    </tr>
                                    <tr> 
                                      <td width="9%">Apply VAT</td>
                                      <td width="25%"> 
                                        <input type="checkbox" name="checkbox2" value="checkbox" checked>
                                        Yes </td>
                                      <td width="2%">&nbsp;</td>
                                      <td width="9%">&nbsp;</td>
                                      <td width="0%">&nbsp;</td>
                                    </tr>
                                    <tr> 
                                      <td width="9%">Memo</td>
                                      <td colspan="4"> 
                                        <input type="text" name="<%=jspAp.colNames[JspAp.JSP_MEMO] %>" class="formElemen" size="90" value="<%= ap.getMemo() %>">
                                      </td>
                                      <td width="0%">&nbsp;</td>
                                    </tr>
                                    <tr> 
                                      <td width="9%">&nbsp;</td>
                                      <td colspan="4">&nbsp; </td>
                                      <td width="0%">&nbsp;</td>
                                    </tr>
                                    <tr> 
                                      <td width="9%" height="5"></td>
                                      <td width="25%" height="5"></td>
                                      <td width="2%" height="5"></td>
                                      <td width="9%" height="5"></td>
                                      <td width="55%" height="5"></td>
                                      <td width="0%" height="5"></td>
                                    </tr>
                                    <tr> 
                                      <td colspan="5" class="boxed4"> 
                                        <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                          <tr> 
                                            <td colspan="5" height="5"></td>
                                          </tr>
                                          <tr> 
                                            <td colspan="5" valign="top"> 
                                              <table width="100%" border="0" cellspacing="1" cellpadding="0">
                                                <tr> 
                                                  <td colspan="8" height="16"> 
                                                    <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                      <tr> 
                                                        <td width="1%">&nbsp;</td>
                                                        <td width="100"  class="tablehdr"> 
                                                          <div align="center">Expense</div>
                                                        </td>
                                                        <td width="100" bgcolor="#C0D6C0"> 
                                                          <div align="center"><a href="apactivity-proto1.jsp?menu_idx=2">Activity</a></div>
                                                        </td>
                                                        <td width="74%">&nbsp;</td>
                                                      </tr>
                                                    </table>
                                                  </td>
                                                </tr>
                                                <tr> 
                                                  <td class="tablehdr" width="2%" height="16">No</td>
                                                  <td class="tablehdr" width="16%" height="16"> 
                                                    Item</td>
                                                  <td class="tablehdr" width="17%" height="16">Account#</td>
                                                  <td class="tablehdr" width="8%" height="16">Type</td>
                                                  <td class="tablehdr" width="7%" height="16">Qty</td>
                                                  <td class="tablehdr" width="25%" height="16">@Price</td>
                                                  <td class="tablehdr" width="8%" height="16">Discount</td>
                                                  <td class="tablehdr" width="17%" height="16">Total</td>
                                                </tr>
                                                <tr> 
                                                  <td class="tablecell" width="2%" height="16"> 
                                                    <div align="center">1</div>
                                                  </td>
                                                  <td class="tablecell" width="16%" height="16"><a href="#">1 
                                                    Unit komputer pentium IV</a></td>
                                                  <td class="tablecell" width="17%" height="16" nowrap> 
                                                    <div align="center">2-1010 
                                                      - Suspense Account</div>
                                                  </td>
                                                  <td class="tablecell" width="8%" height="16"> 
                                                    <div align="center">Komputer 
                                                    </div>
                                                  </td>
                                                  <td class="tablecell" width="7%" height="16"> 
                                                    <div align="center">1</div>
                                                  </td>
                                                  <td class="tablecell" width="25%" height="16"> 
                                                    <div align="right">Rp. 3,000,000.-</div>
                                                  </td>
                                                  <td class="tablecell" width="8%" height="16"> 
                                                    <div align="right">Rp. 0.- 
                                                    </div>
                                                  </td>
                                                  <td class="tablecell" width="17%" height="16" nowrap> 
                                                    <div align="right">Rp. 3,000,000.-</div>
                                                  </td>
                                                </tr>
                                                <tr> 
                                                  <td width="2%" class="tablecell"> 
                                                    <div align="center">2 </div>
                                                  </td>
                                                  <td width="16%" class="tablecell"><a href="#">1 
                                                    Unit Cash Drawer</a></td>
                                                  <td width="17%" class="tablecell"> 
                                                    <div align="center">2-1010 
                                                      - Suspense Account</div>
                                                  </td>
                                                  <td width="8%" class="tablecell"> 
                                                    <div align="center">Komputer 
                                                    </div>
                                                  </td>
                                                  <td width="7%" class="tablecell"> 
                                                    <div align="center">1 </div>
                                                  </td>
                                                  <td width="25%" class="tablecell"> 
                                                    <div align="right">Rp. 1,000,000.-</div>
                                                  </td>
                                                  <td width="8%" class="tablecell"> 
                                                    <div align="right">Rp. 0.-</div>
                                                  </td>
                                                  <td width="17%" class="tablecell"> 
                                                    <div align="right">Rp. 1,000,000.-</div>
                                                  </td>
                                                </tr>
                                                <tr> 
                                                  <td colspan="2">&nbsp; </td>
                                                  <td width="17%">&nbsp;</td>
                                                  <td width="8%">&nbsp;</td>
                                                  <td width="7%">&nbsp;</td>
                                                  <td width="25%"> 
                                                    <div align="right"><b>SUB 
                                                      TOTAL</b></div>
                                                  </td>
                                                  <td width="8%">&nbsp;</td>
                                                  <td width="17%"> 
                                                    <div align="right"><b>Rp. 
                                                      4,000,000.-</b></div>
                                                  </td>
                                                </tr>
                                                <tr> 
                                                  <td colspan="2">&nbsp;</td>
                                                  <td width="17%">&nbsp;</td>
                                                  <td width="8%">&nbsp;</td>
                                                  <td width="7%">&nbsp;</td>
                                                  <td width="25%"> 
                                                    <div align="right"><b>DISCOUNT</b></div>
                                                  </td>
                                                  <td width="8%"> 
                                                    <div align="center"> 
                                                      <input type="text" name="textfield2" size="5" value="10" style="text-align:right">
                                                      % </div>
                                                  </td>
                                                  <td width="17%"> 
                                                    <div align="right"> 
                                                      <input type="text" name="textfield4" value="400,000.-" style="text-align:right">
                                                    </div>
                                                  </td>
                                                </tr>
                                                <tr> 
                                                  <td colspan="2">&nbsp;</td>
                                                  <td width="17%">&nbsp;</td>
                                                  <td width="8%">&nbsp;</td>
                                                  <td width="7%">&nbsp;</td>
                                                  <td width="25%"> 
                                                    <div align="right"><b>VAT</b></div>
                                                  </td>
                                                  <td width="8%"> 
                                                    <div align="center"> 
                                                      <input type="text" name="textfield3" size="5" value="10" style="text-align:right">
                                                      % </div>
                                                  </td>
                                                  <td width="17%"> 
                                                    <div align="right"> 
                                                      <input type="text" name="textfield5" value="400,000.-" style="text-align:right">
                                                    </div>
                                                  </td>
                                                </tr>
                                                <tr> 
                                                  <td colspan="2" height="5">&nbsp;</td>
                                                  <td width="17%" height="5">&nbsp;</td>
                                                  <td width="8%" height="5">&nbsp;</td>
                                                  <td width="7%" height="5">&nbsp;</td>
                                                  <td width="25%" height="5"> 
                                                    <div align="right"><b>TOTAL</b></div>
                                                  </td>
                                                  <td width="8%" height="5">&nbsp;</td>
                                                  <td width="17%" height="5"> 
                                                    <div align="right"><b>Rp. 
                                                      4,800,000.-</b></div>
                                                  </td>
                                                </tr>
                                              </table>
                                            </td>
                                          </tr>
                                        </table>
                                      </td>
                                      <td width="0%">&nbsp;</td>
                                    </tr>
                                    <tr> 
                                      <td width="9%">Status</td>
                                      <td width="25%"> 
                                        <select name="select">
                                          <option>Draft</option>
                                          <option selected>Open</option>
                                          <option selected>Closed</option>
                                        </select>
                                      </td>
                                      <td width="2%">&nbsp;</td>
                                      <td colspan="2"> 
                                        <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                          <tr> 
                                            <td width="3%"><img src="../images/ctr_line/BtnNew.jpg" width="22" height="22"></td>
                                            <td width="7%"><a href="#">New</a></td>
                                            <td width="3%"><img src="../images/ctr_line/print.jpg" width="24" height="24"></td>
                                            <td width="11%"><a href="#">Print 
                                              PO</a></td>
                                            <td width="3%"><img src="../images/ctr_line/save.jpg" width="22" height="22"></td>
                                            <td width="73%"><a href="#">Save</a></td>
                                          </tr>
                                        </table>
                                      </td>
                                      <td width="0%">&nbsp;</td>
                                    </tr>
                                    <tr> 
                                      <td width="9%">&nbsp;</td>
                                      <td width="25%">&nbsp;</td>
                                      <td width="2%">&nbsp;</td>
                                      <td width="9%">&nbsp;</td>
                                      <td width="55%">&nbsp;</td>
                                      <td width="0%">&nbsp;</td>
                                    </tr>
                                    <tr> 
                                      <td width="9%">&nbsp;</td>
                                      <td width="25%">&nbsp;</td>
                                      <td width="2%">&nbsp;</td>
                                      <td width="9%">&nbsp;</td>
                                      <td width="55%">&nbsp;</td>
                                      <td width="0%">&nbsp;</td>
                                    </tr>
                                    <tr> 
                                      <td width="9%">&nbsp;</td>
                                      <td width="25%">1. implementasi aktivity 
                                        agar nanti di payment tidak implementasi 
                                        lagi </td>
                                      <td width="2%">&nbsp;</td>
                                      <td width="9%">&nbsp;</td>
                                      <td width="55%">&nbsp;</td>
                                      <td width="0%">&nbsp;</td>
                                    </tr>
                                    <tr> 
                                      <td width="9%">&nbsp;</td>
                                      <td width="25%">&nbsp;</td>
                                      <td width="2%">&nbsp;</td>
                                      <td width="9%">&nbsp;</td>
                                      <td width="55%">&nbsp;</td>
                                      <td width="0%">&nbsp;</td>
                                    </tr>
                                    <tr> 
                                      <td width="9%">&nbsp;</td>
                                      <td width="25%">2. Currency PO bisa dipilih 
                                        dan detail mengikuti currency PO</td>
                                      <td width="2%">&nbsp;</td>
                                      <td width="9%">&nbsp;</td>
                                      <td width="55%">&nbsp;</td>
                                      <td width="0%">&nbsp;</td>
                                    </tr>
                                    <tr> 
                                      <td width="9%">&nbsp;</td>
                                      <td width="25%">&nbsp;</td>
                                      <td width="2%">&nbsp;</td>
                                      <td width="9%">&nbsp;</td>
                                      <td width="55%">&nbsp;</td>
                                      <td width="0%">&nbsp;</td>
                                    </tr>
                                    <tr> 
                                      <td width="9%">&nbsp;</td>
                                      <td width="25%">&nbsp;</td>
                                      <td width="2%">&nbsp;</td>
                                      <td width="9%">&nbsp;</td>
                                      <td width="55%">&nbsp;</td>
                                      <td width="0%">&nbsp;</td>
                                    </tr>
                                    <tr> 
                                      <td width="9%">&nbsp;</td>
                                      <td width="25%">&nbsp;</td>
                                      <td width="2%">&nbsp;</td>
                                      <td width="9%">&nbsp;</td>
                                      <td width="55%">&nbsp;</td>
                                      <td width="0%">&nbsp;</td>
                                    </tr>
                                    <tr> 
                                      <td width="9%">&nbsp;</td>
                                      <td width="25%">&nbsp;</td>
                                      <td width="2%">&nbsp;</td>
                                      <td width="9%">&nbsp;</td>
                                      <td width="55%">&nbsp;</td>
                                      <td width="0%">&nbsp;</td>
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
                    <td height="8" valign="middle" colspan="3">&nbsp; </td>
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
