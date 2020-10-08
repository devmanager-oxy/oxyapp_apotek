<% 
/* 
 * Page Name  		:  ar.jsp
 * Created on 		:  [date] [time] AM/PM 
 * 
 * @author  		:  [authorName] 
 * @version  		:  [version] 
 */

/*******************************************************************
 * Page Description 	: [project description ... ] 
 * Imput Parameters 	: [input parameter ...] 
 * Output 			: [output ...] 
 *******************************************************************/
%>

<%@ page language = "java" %>
<!-- package java -->
<%@ page import = "java.util.*" %>

<!-- package dimata -->
<%@ page import = "com.dimata.util.*" %>

<!-- package qdep -->
<%@ page import = "com.dimata.gui.jsp.*" %>
<%@ page import = "com.dimata.qdep.form.*" %>

<!--package finance -->
<%@ page import = "com.dimata.finance.entity.journal.*" %>
<%@ page import = "com.dimata.finance.form.journal.*" %>
<%@ page import = "com.dimata.finance.entity.admin.*" %>
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

	public String drawList(Vector objectClass ,  long arId)

	{
		ControlList ctrlist = new ControlList();
		ctrlist.setAreaWidth("100%");
		ctrlist.setListStyle("listgen");
		ctrlist.setTitleStyle("tableheader");
		ctrlist.setCellStyle("cellStyle");
		ctrlist.setHeaderStyle("tableheader");
		ctrlist.addHeader("Date","6%");
		ctrlist.addHeader("Po Number","6%");
		ctrlist.addHeader("Invoice Number","6%");
		ctrlist.addHeader("Currency","6%");
		ctrlist.addHeader("Due Date","6%");
		ctrlist.addHeader("Periode Id","6%");
		ctrlist.addHeader("Status","6%");
		ctrlist.addHeader("Number Counter","6%");
		ctrlist.addHeader("Exchange Rate","6%");
		ctrlist.addHeader("Voucher Number","6%");
		ctrlist.addHeader("Memo","6%");
		ctrlist.addHeader("Amount","6%");
		ctrlist.addHeader("Voucher Counter","6%");
		ctrlist.addHeader("Customer Id","6%");
		ctrlist.addHeader("User Id","6%");

		ctrlist.setLinkRow(0);
		ctrlist.setLinkSufix("");
		Vector lstData = ctrlist.getData();
		Vector lstLinkData = ctrlist.getLinkData();
		ctrlist.setLinkPrefix("javascript:cmdEdit('");
		ctrlist.setLinkSufix("')");
		ctrlist.reset();
		int index = -1;

		for (int i = 0; i < objectClass.size(); i++) {
			Ar ar = (Ar)objectClass.get(i);
			 Vector rowx = new Vector();
			 if(arId == ar.getOID())
				 index = i;

			String str_dt_Date = ""; 
			try{
				Date dt_Date = ar.getDate();
				if(dt_Date==null){
					dt_Date = new Date();
				}

				str_dt_Date = Formater.formatDate(dt_Date, "dd MMMM yyyy");
			}catch(Exception e){ str_dt_Date = ""; }

			rowx.add(str_dt_Date);

			rowx.add(ar.getPoNumber());

			rowx.add(ar.getInvoiceNumber());

			rowx.add(ar.getCurrency());

			String str_dt_DueDate = ""; 
			try{
				Date dt_DueDate = ar.getDueDate();
				if(dt_DueDate==null){
					dt_DueDate = new Date();
				}

				str_dt_DueDate = Formater.formatDate(dt_DueDate, "dd MMMM yyyy");
			}catch(Exception e){ str_dt_DueDate = ""; }

			rowx.add(str_dt_DueDate);

			rowx.add(String.valueOf(ar.getPeriodeId()));

			rowx.add(ar.getStatus());

			rowx.add(String.valueOf(ar.getNumberCounter()));

			rowx.add(String.valueOf(ar.getExchangeRate()));

			rowx.add(ar.getVoucherNumber());

			rowx.add(ar.getMemo());

			rowx.add(String.valueOf(ar.getAmount()));

			rowx.add(String.valueOf(ar.getVoucherCounter()));

			rowx.add(String.valueOf(ar.getCustomerId()));

			rowx.add(String.valueOf(ar.getUserId()));

			lstData.add(rowx);
			lstLinkData.add(String.valueOf(ar.getOID()));
		}

		return ctrlist.drawList(index);
	}

%>
<%
int iCommand = FRMQueryString.requestCommand(request);
int start = FRMQueryString.requestInt(request, "start");
int prevCommand = FRMQueryString.requestInt(request, "prev_command");
long oidAr = FRMQueryString.requestLong(request, "hidden_ar_id");

/*variable declaration*/
int recordToGet = 10;
String msgString = "";
int iErrCode = FRMMessage.NONE;
String whereClause = "";
String orderClause = "";

CtrlAr ctrlAr = new CtrlAr(request);
ControlLine ctrLine = new ControlLine();
Vector listAr = new Vector(1,1);

/*switch statement */
iErrCode = ctrlAr.action(iCommand , oidAr);
/* end switch*/
JspAr jspAr = ctrlAr.getForm();

/*count list All Ar*/
int vectSize = PstAr.getCount(whereClause);

Ar ar = ctrlAr.getAr();
msgString =  ctrlAr.getMessage();

/*switch list Ar*/
if((iCommand == Command.SAVE) && (iErrCode == FRMMessage.NONE))
	start = PstAr.generateFindStart(ar.getOID(),recordToGet, whereClause);

if((iCommand == Command.FIRST || iCommand == Command.PREV )||
  (iCommand == Command.NEXT || iCommand == Command.LAST)){
		start = ctrlAr.actionList(iCommand, start, vectSize, recordToGet);
 } 
/* end switch list*/

/* get record to display */
listAr = PstAr.list(start,recordToGet, whereClause , orderClause);

/*handle condition if size of record to display = 0 and start > 0 	after delete*/
if (listAr.size() < 1 && start > 0)
{
	 if (vectSize - recordToGet > recordToGet)
			start = start - recordToGet;   //go to Command.PREV
	 else{
		 start = 0 ;
		 iCommand = Command.FIRST;
		 prevCommand = Command.FIRST; //go to Command.FIRST
	 }
	 listAr = PstAr.list(start,recordToGet, whereClause , orderClause);
}
%>


<html><!-- #BeginTemplate "/Templates/main.dwt" -->
<head>
<!-- #BeginEditable "doctitle" -->
<title>finance--</title>
<script language="JavaScript">


function cmdAdd(){
	document.frmar.hidden_ar_id.value="0";
	document.frmar.command.value="<%=Command.ADD%>";
	document.frmar.prev_command.value="<%=prevCommand%>";
	document.frmar.action="ar.jsp";
	document.frmar.submit();
}

function cmdAsk(oidAr){
	document.frmar.hidden_ar_id.value=oidAr;
	document.frmar.command.value="<%=Command.ASK%>";
	document.frmar.prev_command.value="<%=prevCommand%>";
	document.frmar.action="ar.jsp";
	document.frmar.submit();
}

function cmdConfirmDelete(oidAr){
	document.frmar.hidden_ar_id.value=oidAr;
	document.frmar.command.value="<%=Command.DELETE%>";
	document.frmar.prev_command.value="<%=prevCommand%>";
	document.frmar.action="ar.jsp";
	document.frmar.submit();
}
function cmdSave(){
	document.frmar.command.value="<%=Command.SAVE%>";
	document.frmar.prev_command.value="<%=prevCommand%>";
	document.frmar.action="ar.jsp";
	document.frmar.submit();
	}

function cmdEdit(oidAr){
	document.frmar.hidden_ar_id.value=oidAr;
	document.frmar.command.value="<%=Command.EDIT%>";
	document.frmar.prev_command.value="<%=prevCommand%>";
	document.frmar.action="ar.jsp";
	document.frmar.submit();
	}

function cmdCancel(oidAr){
	document.frmar.hidden_ar_id.value=oidAr;
	document.frmar.command.value="<%=Command.EDIT%>";
	document.frmar.prev_command.value="<%=prevCommand%>";
	document.frmar.action="ar.jsp";
	document.frmar.submit();
}

function cmdBack(){
	document.frmar.command.value="<%=Command.BACK%>";
	document.frmar.action="ar.jsp";
	document.frmar.submit();
	}

function cmdListFirst(){
	document.frmar.command.value="<%=Command.FIRST%>";
	document.frmar.prev_command.value="<%=Command.FIRST%>";
	document.frmar.action="ar.jsp";
	document.frmar.submit();
}

function cmdListPrev(){
	document.frmar.command.value="<%=Command.PREV%>";
	document.frmar.prev_command.value="<%=Command.PREV%>";
	document.frmar.action="ar.jsp";
	document.frmar.submit();
	}

function cmdListNext(){
	document.frmar.command.value="<%=Command.NEXT%>";
	document.frmar.prev_command.value="<%=Command.NEXT%>";
	document.frmar.action="ar.jsp";
	document.frmar.submit();
}

function cmdListLast(){
	document.frmar.command.value="<%=Command.LAST%>";
	document.frmar.prev_command.value="<%=Command.LAST%>";
	document.frmar.action="ar.jsp";
	document.frmar.submit();
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
<!-- #EndEditable -->
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="stylesheet" href="../style/main.css" type="text/css">
</head>
<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<table width="100%" border="0" cellspacing="2" cellpadding="2" height="100%">
	<tr>
		<td colspan="2" height="25" class="toptitle">
			<div align="center">Header Title</div>
		</td>
	</tr>
	<tr>
		<td colspan="2" class="topmenu" height="20">
			<!-- #BeginEditable "menu_main" --><%@ include file = "../main/menumain.jsp" %><!-- #EndEditable --> </td>
	</tr>
	<tr>
		<td width="88%" valign="top" align="left">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td height="20" class="contenttitle" >
					<!-- #BeginEditable "contenttitle" -->
					Content Title .......
					<!-- #EndEditable -->
					</td>
				</tr>
				<tr>
					<td valign="top">
					<!-- #BeginEditable "content" -->

						<form name="frmar" method ="post" action="">
				<input type="hidden" name="command" value="<%=iCommand%>">
				<input type="hidden" name="vectSize" value="<%=vectSize%>">
				<input type="hidden" name="start" value="<%=start%>">
				<input type="hidden" name="prev_command" value="<%=prevCommand%>">
				<input type="hidden" name="hidden_ar_id" value="<%=oidAr%>">
						<table width="100%" border="0" cellspacing="0" cellpadding="0">
						 <tr align="left" valign="top">
							 <td height="8"  colspan="3">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						  <tr align="left" valign="top">
						      <td height="8" valign="middle" colspan="3">
						      		<hr>
						      </td>
						  </tr>
						  <tr align="left" valign="top">
						      <td height="14" valign="middle" colspan="3" class="comment">&nbsp;Ar
						       List </td>
						  </tr>
						  <%
							try{
								if (listAr.size()>0){
							%>
						  <tr align="left" valign="top">
						        <td height="22" valign="middle" colspan="3"> <%= drawList(listAr,oidAr)%> </td>
						  </tr>
						  <%  } 
						  }catch(Exception exc){ 
						  }%>
						  <tr align="left" valign="top">
						      <td height="8" align="left" colspan="3" class="command">
							          <span class="command">
							       <% 
								   int cmd = 0;
									   if ((iCommand == Command.FIRST || iCommand == Command.PREV )|| 
										(iCommand == Command.NEXT || iCommand == Command.LAST))
											cmd =iCommand; 
								   else{
									  if(iCommand == Command.NONE || prevCommand == Command.NONE)
										cmd = Command.FIRST;
									  else 
									  	cmd =prevCommand; 
								   } 
							    %>
								 <% ctrLine.setLocationImg(approot+"/images/ctr_line");
							   	ctrLine.initDefault();
								 %>
							    <%=ctrLine.drawImageListLimit(cmd,vectSize,start,recordToGet)%> </span> </td>
						  </tr>
						  <tr align="left" valign="top">
						        <td height="22" valign="middle" colspan="3"><a href="javascript:cmdAdd()" class="command">Add
						          New</a></td>
						  </tr>
					</table>
							 </td>
						 </tr>
						 <tr align="left" valign="top">
								  <td height="8" valign="middle" colspan="3">
							 <%if((iCommand ==Command.ADD)||(iCommand==Command.SAVE)&&(jspAr.errorSize()>0)||(iCommand==Command.EDIT)||(iCommand==Command.ASK)){%>
								 <table width="100%" border="0" cellspacing="1" cellpadding="0">
					      <tr align="left" valign="top">
					         <td height="21" valign="middle" width="17%">&nbsp;</td>
					         <td height="21" colspan="2" width="83%" class="comment">*)= required</td>
					      </tr>
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Date</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspAr.fieldNames[JspAr.FRM_FIELD_DATE] %>"  value="<%= ar.getDate() %>" class="formElemen">
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Due Date</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspAr.fieldNames[JspAr.FRM_FIELD_DUE_DATE] %>"  value="<%= ar.getDueDate() %>" class="formElemen">
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Invoice Number</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspAr.fieldNames[JspAr.FRM_FIELD_INVOICE_NUMBER] %>"  value="<%= ar.getInvoiceNumber() %>" class="formElemen">
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Number Counter</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspAr.fieldNames[JspAr.FRM_FIELD_NUMBER_COUNTER] %>"  value="<%= ar.getNumberCounter() %>" class="formElemen">
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Amount</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspAr.fieldNames[JspAr.FRM_FIELD_AMOUNT] %>"  value="<%= ar.getAmount() %>" class="formElemen">
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Status</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspAr.fieldNames[JspAr.FRM_FIELD_STATUS] %>"  value="<%= ar.getStatus() %>" class="formElemen">
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Po Number</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspAr.fieldNames[JspAr.FRM_FIELD_PO_NUMBER] %>"  value="<%= ar.getPoNumber() %>" class="formElemen">
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Currency</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspAr.fieldNames[JspAr.FRM_FIELD_CURRENCY] %>"  value="<%= ar.getCurrency() %>" class="formElemen">
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Periode Id</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspAr.fieldNames[JspAr.FRM_FIELD_PERIODE_ID] %>"  value="<%= ar.getPeriodeId() %>" class="formElemen">
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Exchange Rate</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspAr.fieldNames[JspAr.FRM_FIELD_EXCHANGE_RATE] %>"  value="<%= ar.getExchangeRate() %>" class="formElemen">
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Voucher Number</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspAr.fieldNames[JspAr.FRM_FIELD_VOUCHER_NUMBER] %>"  value="<%= ar.getVoucherNumber() %>" class="formElemen">
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Voucher Date</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspAr.fieldNames[JspAr.FRM_FIELD_VOUCHER_DATE] %>"  value="<%= ar.getVoucherDate() %>" class="formElemen">
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Voucher Counter</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspAr.fieldNames[JspAr.FRM_FIELD_VOUCHER_COUNTER] %>"  value="<%= ar.getVoucherCounter() %>" class="formElemen">
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">User Id</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspAr.fieldNames[JspAr.FRM_FIELD_USER_ID] %>"  value="<%= ar.getUserId() %>" class="formElemen">
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Customer Id</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspAr.fieldNames[JspAr.FRM_FIELD_CUSTOMER_ID] %>"  value="<%= ar.getCustomerId() %>" class="formElemen">
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Memo</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspAr.fieldNames[JspAr.FRM_FIELD_MEMO] %>"  value="<%= ar.getMemo() %>" class="formElemen">
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Total Payment</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspAr.fieldNames[JspAr.FRM_FIELD_TOTAL_PAYMENT] %>"  value="<%= ar.getTotalPayment() %>" class="formElemen">
								 <tr align="left" valign="top">
								   <td height="8" valign="middle" width="17%">&nbsp;</td>
								   <td height="8" colspan="2" width="83%">&nbsp; </td>
								 </tr>
								 <tr align="left" valign="top" >
								   <td colspan="3" class="command">
									<%
									ctrLine.setLocationImg(approot+"/images/ctr_line");
									ctrLine.initDefault();
									ctrLine.setTableWidth("80%");
									String scomDel = "javascript:cmdAsk('"+oidAr+"')";
									String sconDelCom = "javascript:cmdConfirmDelete('"+oidAr+"')";
									String scancel = "javascript:cmdEdit('"+oidAr+"')";
									ctrLine.setBackCaption("Back to List");
									ctrLine.setCommandStyle("buttonlink");
										ctrLine.setDeleteCaption("Delete");
										ctrLine.setSaveCaption("Save");
										ctrLine.setAddCaption("");

									if (privDelete){
										ctrLine.setConfirmDelCommand(sconDelCom);
										ctrLine.setDeleteCommand(scomDel);
										ctrLine.setEditCommand(scancel);
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
								<%= ctrLine.drawImage(iCommand, iErrCode, msgString)%>
								 	 </td>
								 </tr>
								 <tr>
								   	<td width="13%">&nbsp;</td>
								   	<td width="87%">&nbsp;</td>
								 </tr>
								 <tr align="left" valign="top" >
								   	<td colspan="3"><div align="left"></div>
								     </td>
								 </tr>
							 </table>
							<%}%>
						 </td>
					 </tr>
					 </table>
					</form>


					<!-- #EndEditable -->
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td colspan="2" height="20" class="footer">
			<div align="center"> copyright Bali Information Technologies 2002</div>
		</td>
	</tr>
</table>
</body>
<!-- #EndTemplate -->
</html>
