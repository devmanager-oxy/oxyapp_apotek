<% 
/* 
 * Page Name  		:  arap.jsp
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

	public String drawList(Vector objectClass ,  long arapId)

	{
		ControlList ctrlist = new ControlList();
		ctrlist.setAreaWidth("100%");
		ctrlist.setListStyle("listgen");
		ctrlist.setTitleStyle("tableheader");
		ctrlist.setCellStyle("cellStyle");
		ctrlist.setHeaderStyle("tableheader");
		ctrlist.addHeader("Date","20%");
		ctrlist.addHeader("Due Date","20%");
		ctrlist.addHeader("Vendor Id","20%");
		ctrlist.addHeader("Vandor Name","20%");
		ctrlist.addHeader("Vendor Address","20%");

		ctrlist.setLinkRow(0);
		ctrlist.setLinkSufix("");
		Vector lstData = ctrlist.getData();
		Vector lstLinkData = ctrlist.getLinkData();
		ctrlist.setLinkPrefix("javascript:cmdEdit('");
		ctrlist.setLinkSufix("')");
		ctrlist.reset();
		int index = -1;

		for (int i = 0; i < objectClass.size(); i++) {
			Arap arap = (Arap)objectClass.get(i);
			 Vector rowx = new Vector();
			 if(arapId == arap.getOID())
				 index = i;

			String str_dt_Date = ""; 
			try{
				Date dt_Date = arap.getDate();
				if(dt_Date==null){
					dt_Date = new Date();
				}

				str_dt_Date = Formater.formatDate(dt_Date, "dd MMMM yyyy");
			}catch(Exception e){ str_dt_Date = ""; }

			rowx.add(str_dt_Date);

			String str_dt_DueDate = ""; 
			try{
				Date dt_DueDate = arap.getDueDate();
				if(dt_DueDate==null){
					dt_DueDate = new Date();
				}

				str_dt_DueDate = Formater.formatDate(dt_DueDate, "dd MMMM yyyy");
			}catch(Exception e){ str_dt_DueDate = ""; }

			rowx.add(str_dt_DueDate);

			rowx.add(String.valueOf(arap.getVendorId()));

			rowx.add(arap.getVandorName());

			rowx.add(arap.getVendorAddress());

			lstData.add(rowx);
			lstLinkData.add(String.valueOf(arap.getOID()));
		}

		return ctrlist.drawList(index);
	}

%>
<%
int iCommand = FRMQueryString.requestCommand(request);
int start = FRMQueryString.requestInt(request, "start");
int prevCommand = FRMQueryString.requestInt(request, "prev_command");
long oidArap = FRMQueryString.requestLong(request, "hidden_arap_id");

/*variable declaration*/
int recordToGet = 10;
String msgString = "";
int iErrCode = FRMMessage.NONE;
String whereClause = "";
String orderClause = "";

CtrlArap ctrlArap = new CtrlArap(request);
ControlLine ctrLine = new ControlLine();
Vector listArap = new Vector(1,1);

/*switch statement */
iErrCode = ctrlArap.action(iCommand , oidArap);
/* end switch*/
JspArap jspArap = ctrlArap.getForm();

/*count list All Arap*/
int vectSize = PstArap.getCount(whereClause);

Arap arap = ctrlArap.getArap();
msgString =  ctrlArap.getMessage();

/*switch list Arap*/
if((iCommand == Command.SAVE) && (iErrCode == FRMMessage.NONE))
	start = PstArap.generateFindStart(arap.getOID(),recordToGet, whereClause);

if((iCommand == Command.FIRST || iCommand == Command.PREV )||
  (iCommand == Command.NEXT || iCommand == Command.LAST)){
		start = ctrlArap.actionList(iCommand, start, vectSize, recordToGet);
 } 
/* end switch list*/

/* get record to display */
listArap = PstArap.list(start,recordToGet, whereClause , orderClause);

/*handle condition if size of record to display = 0 and start > 0 	after delete*/
if (listArap.size() < 1 && start > 0)
{
	 if (vectSize - recordToGet > recordToGet)
			start = start - recordToGet;   //go to Command.PREV
	 else{
		 start = 0 ;
		 iCommand = Command.FIRST;
		 prevCommand = Command.FIRST; //go to Command.FIRST
	 }
	 listArap = PstArap.list(start,recordToGet, whereClause , orderClause);
}
%>


<html><!-- #BeginTemplate "/Templates/main.dwt" -->
<head>
<!-- #BeginEditable "doctitle" -->
<title>finance--</title>
<script language="JavaScript">


function cmdAdd(){
	document.frmarap.hidden_arap_id.value="0";
	document.frmarap.command.value="<%=Command.ADD%>";
	document.frmarap.prev_command.value="<%=prevCommand%>";
	document.frmarap.action="arap.jsp";
	document.frmarap.submit();
}

function cmdAsk(oidArap){
	document.frmarap.hidden_arap_id.value=oidArap;
	document.frmarap.command.value="<%=Command.ASK%>";
	document.frmarap.prev_command.value="<%=prevCommand%>";
	document.frmarap.action="arap.jsp";
	document.frmarap.submit();
}

function cmdConfirmDelete(oidArap){
	document.frmarap.hidden_arap_id.value=oidArap;
	document.frmarap.command.value="<%=Command.DELETE%>";
	document.frmarap.prev_command.value="<%=prevCommand%>";
	document.frmarap.action="arap.jsp";
	document.frmarap.submit();
}
function cmdSave(){
	document.frmarap.command.value="<%=Command.SAVE%>";
	document.frmarap.prev_command.value="<%=prevCommand%>";
	document.frmarap.action="arap.jsp";
	document.frmarap.submit();
	}

function cmdEdit(oidArap){
	document.frmarap.hidden_arap_id.value=oidArap;
	document.frmarap.command.value="<%=Command.EDIT%>";
	document.frmarap.prev_command.value="<%=prevCommand%>";
	document.frmarap.action="arap.jsp";
	document.frmarap.submit();
	}

function cmdCancel(oidArap){
	document.frmarap.hidden_arap_id.value=oidArap;
	document.frmarap.command.value="<%=Command.EDIT%>";
	document.frmarap.prev_command.value="<%=prevCommand%>";
	document.frmarap.action="arap.jsp";
	document.frmarap.submit();
}

function cmdBack(){
	document.frmarap.command.value="<%=Command.BACK%>";
	document.frmarap.action="arap.jsp";
	document.frmarap.submit();
	}

function cmdListFirst(){
	document.frmarap.command.value="<%=Command.FIRST%>";
	document.frmarap.prev_command.value="<%=Command.FIRST%>";
	document.frmarap.action="arap.jsp";
	document.frmarap.submit();
}

function cmdListPrev(){
	document.frmarap.command.value="<%=Command.PREV%>";
	document.frmarap.prev_command.value="<%=Command.PREV%>";
	document.frmarap.action="arap.jsp";
	document.frmarap.submit();
	}

function cmdListNext(){
	document.frmarap.command.value="<%=Command.NEXT%>";
	document.frmarap.prev_command.value="<%=Command.NEXT%>";
	document.frmarap.action="arap.jsp";
	document.frmarap.submit();
}

function cmdListLast(){
	document.frmarap.command.value="<%=Command.LAST%>";
	document.frmarap.prev_command.value="<%=Command.LAST%>";
	document.frmarap.action="arap.jsp";
	document.frmarap.submit();
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

						<form name="frmarap" method ="post" action="">
				<input type="hidden" name="command" value="<%=iCommand%>">
				<input type="hidden" name="vectSize" value="<%=vectSize%>">
				<input type="hidden" name="start" value="<%=start%>">
				<input type="hidden" name="prev_command" value="<%=prevCommand%>">
				<input type="hidden" name="hidden_arap_id" value="<%=oidArap%>">
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
						      <td height="14" valign="middle" colspan="3" class="comment">&nbsp;Arap
						       List </td>
						  </tr>
						  <%
							try{
								if (listArap.size()>0){
							%>
						  <tr align="left" valign="top">
						        <td height="22" valign="middle" colspan="3"> <%= drawList(listArap,oidArap)%> </td>
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
							 <%if((iCommand ==Command.ADD)||(iCommand==Command.SAVE)&&(jspArap.errorSize()>0)||(iCommand==Command.EDIT)||(iCommand==Command.ASK)){%>
								 <table width="100%" border="0" cellspacing="1" cellpadding="0">
					      <tr align="left" valign="top">
					         <td height="21" valign="middle" width="17%">&nbsp;</td>
					         <td height="21" colspan="2" width="83%" class="comment">*)= required</td>
					      </tr>
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Date</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspArap.fieldNames[JspArap.FRM_FIELD_DATE] %>"  value="<%= arap.getDate() %>" class="formElemen">
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Due Date</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspArap.fieldNames[JspArap.FRM_FIELD_DUE_DATE] %>"  value="<%= arap.getDueDate() %>" class="formElemen">
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Vendor Id</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspArap.fieldNames[JspArap.FRM_FIELD_VENDOR_ID] %>"  value="<%= arap.getVendorId() %>" class="formElemen">
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Vandor Name</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspArap.fieldNames[JspArap.FRM_FIELD_VANDOR_NAME] %>"  value="<%= arap.getVandorName() %>" class="formElemen">
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Vendor Address</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspArap.fieldNames[JspArap.FRM_FIELD_VENDOR_ADDRESS] %>"  value="<%= arap.getVendorAddress() %>" class="formElemen">
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Invoice Number</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspArap.fieldNames[JspArap.FRM_FIELD_INVOICE_NUMBER] %>"  value="<%= arap.getInvoiceNumber() %>" class="formElemen">
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Number Counter</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspArap.fieldNames[JspArap.FRM_FIELD_NUMBER_COUNTER] %>"  value="<%= arap.getNumberCounter() %>" class="formElemen">
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Note</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspArap.fieldNames[JspArap.FRM_FIELD_NOTE] %>"  value="<%= arap.getNote() %>" class="formElemen">
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Amount</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspArap.fieldNames[JspArap.FRM_FIELD_AMOUNT] %>"  value="<%= arap.getAmount() %>" class="formElemen">
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Ppn</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspArap.fieldNames[JspArap.FRM_FIELD_PPN] %>"  value="<%= arap.getPpn() %>" class="formElemen">
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Status</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspArap.fieldNames[JspArap.FRM_FIELD_STATUS] %>"  value="<%= arap.getStatus() %>" class="formElemen">
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Po Number</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspArap.fieldNames[JspArap.FRM_FIELD_PO_NUMBER] %>"  value="<%= arap.getPoNumber() %>" class="formElemen">
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Currency</td>
					       <td height="21" colspan="2" width="83%">
					   <% Vector currency_value = new Vector(1,1);
						Vector currency_key = new Vector(1,1);
					 	String sel_currency = ""+arap.getCurrency();
					   currency_key.add("---select---");
					   currency_value.add("");
					   %>
						<%= ControlCombo.draw(jspArap.fieldNames[JspArap.FRM_FIELD_CURRENCY],null, sel_currency, currency_key, currency_value, "", "formElemen") %>
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Periode Id</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspArap.fieldNames[JspArap.FRM_FIELD_PERIODE_ID] %>"  value="<%= arap.getPeriodeId() %>" class="formElemen">
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Exchange Rate</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspArap.fieldNames[JspArap.FRM_FIELD_EXCHANGE_RATE] %>"  value="<%= arap.getExchangeRate() %>" class="formElemen">
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Voucher Number</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspArap.fieldNames[JspArap.FRM_FIELD_VOUCHER_NUMBER] %>"  value="<%= arap.getVoucherNumber() %>" class="formElemen">
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Voucher Date</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspArap.fieldNames[JspArap.FRM_FIELD_VOUCHER_DATE] %>"  value="<%= arap.getVoucherDate() %>" class="formElemen">
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Voucher Counter</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspArap.fieldNames[JspArap.FRM_FIELD_VOUCHER_COUNTER] %>"  value="<%= arap.getVoucherCounter() %>" class="formElemen">
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">User Id</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspArap.fieldNames[JspArap.FRM_FIELD_USER_ID] %>"  value="<%= arap.getUserId() %>" class="formElemen">
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
									String scomDel = "javascript:cmdAsk('"+oidArap+"')";
									String sconDelCom = "javascript:cmdConfirmDelete('"+oidArap+"')";
									String scancel = "javascript:cmdEdit('"+oidArap+"')";
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
