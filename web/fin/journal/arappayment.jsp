<% 
/* 
 * Page Name  		:  arappayment.jsp
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

	public String drawList(Vector objectClass ,  long arapPaymentId)

	{
		ControlList ctrlist = new ControlList();
		ctrlist.setAreaWidth("100%");
		ctrlist.setListStyle("listgen");
		ctrlist.setTitleStyle("tableheader");
		ctrlist.setCellStyle("cellStyle");
		ctrlist.setHeaderStyle("tableheader");
		ctrlist.addHeader("Ap Id","6%");
		ctrlist.addHeader("Periode Id","6%");
		ctrlist.addHeader("Date","6%");
		ctrlist.addHeader("Pay Method","6%");
		ctrlist.addHeader("Paid By","6%");
		ctrlist.addHeader("Amount","6%");
		ctrlist.addHeader("Rec By","6%");
		ctrlist.addHeader("Currency","6%");
		ctrlist.addHeader("Exchange Rate","6%");
		ctrlist.addHeader("Voucher Number","6%");
		ctrlist.addHeader("Voucher Date","6%");
		ctrlist.addHeader("Status","6%");
		ctrlist.addHeader("Memo","6%");
		ctrlist.addHeader("Voucher Counter","6%");
		ctrlist.addHeader("Ar Id","6%");

		ctrlist.setLinkRow(0);
		ctrlist.setLinkSufix("");
		Vector lstData = ctrlist.getData();
		Vector lstLinkData = ctrlist.getLinkData();
		ctrlist.setLinkPrefix("javascript:cmdEdit('");
		ctrlist.setLinkSufix("')");
		ctrlist.reset();
		int index = -1;

		for (int i = 0; i < objectClass.size(); i++) {
			ArapPayment arapPayment = (ArapPayment)objectClass.get(i);
			 Vector rowx = new Vector();
			 if(arapPaymentId == arapPayment.getOID())
				 index = i;

			rowx.add(String.valueOf(arapPayment.getApId()));

			rowx.add(String.valueOf(arapPayment.getPeriodeId()));

			String str_dt_Date = ""; 
			try{
				Date dt_Date = arapPayment.getDate();
				if(dt_Date==null){
					dt_Date = new Date();
				}

				str_dt_Date = Formater.formatDate(dt_Date, "dd MMMM yyyy");
			}catch(Exception e){ str_dt_Date = ""; }

			rowx.add(str_dt_Date);

			rowx.add(arapPayment.getPayMethod());

			rowx.add(arapPayment.getPaidBy());

			rowx.add(String.valueOf(arapPayment.getAmount()));

			rowx.add(arapPayment.getRecBy());

			rowx.add(arapPayment.getCurrency());

			rowx.add(String.valueOf(arapPayment.getExchangeRate()));

			rowx.add(arapPayment.getVoucherNumber());

			String str_dt_VoucherDate = ""; 
			try{
				Date dt_VoucherDate = arapPayment.getVoucherDate();
				if(dt_VoucherDate==null){
					dt_VoucherDate = new Date();
				}

				str_dt_VoucherDate = Formater.formatDate(dt_VoucherDate, "dd MMMM yyyy");
			}catch(Exception e){ str_dt_VoucherDate = ""; }

			rowx.add(str_dt_VoucherDate);

			rowx.add(arapPayment.getStatus());

			rowx.add(arapPayment.getMemo());

			rowx.add(String.valueOf(arapPayment.getVoucherCounter()));

			rowx.add(String.valueOf(arapPayment.getArId()));

			lstData.add(rowx);
			lstLinkData.add(String.valueOf(arapPayment.getOID()));
		}

		return ctrlist.drawList(index);
	}

%>
<%
int iCommand = FRMQueryString.requestCommand(request);
int start = FRMQueryString.requestInt(request, "start");
int prevCommand = FRMQueryString.requestInt(request, "prev_command");
long oidArapPayment = FRMQueryString.requestLong(request, "hidden_arap_payment_id");

/*variable declaration*/
int recordToGet = 10;
String msgString = "";
int iErrCode = FRMMessage.NONE;
String whereClause = "";
String orderClause = "";

CtrlArapPayment ctrlArapPayment = new CtrlArapPayment(request);
ControlLine ctrLine = new ControlLine();
Vector listArapPayment = new Vector(1,1);

/*switch statement */
iErrCode = ctrlArapPayment.action(iCommand , oidArapPayment);
/* end switch*/
JspArapPayment jspArapPayment = ctrlArapPayment.getForm();

/*count list All ArapPayment*/
int vectSize = PstArapPayment.getCount(whereClause);

ArapPayment arapPayment = ctrlArapPayment.getArapPayment();
msgString =  ctrlArapPayment.getMessage();

/*switch list ArapPayment*/
if((iCommand == Command.SAVE) && (iErrCode == FRMMessage.NONE))
	start = PstArapPayment.generateFindStart(arapPayment.getOID(),recordToGet, whereClause);

if((iCommand == Command.FIRST || iCommand == Command.PREV )||
  (iCommand == Command.NEXT || iCommand == Command.LAST)){
		start = ctrlArapPayment.actionList(iCommand, start, vectSize, recordToGet);
 } 
/* end switch list*/

/* get record to display */
listArapPayment = PstArapPayment.list(start,recordToGet, whereClause , orderClause);

/*handle condition if size of record to display = 0 and start > 0 	after delete*/
if (listArapPayment.size() < 1 && start > 0)
{
	 if (vectSize - recordToGet > recordToGet)
			start = start - recordToGet;   //go to Command.PREV
	 else{
		 start = 0 ;
		 iCommand = Command.FIRST;
		 prevCommand = Command.FIRST; //go to Command.FIRST
	 }
	 listArapPayment = PstArapPayment.list(start,recordToGet, whereClause , orderClause);
}
%>


<html><!-- #BeginTemplate "/Templates/main.dwt" -->
<head>
<!-- #BeginEditable "doctitle" -->
<title>finance--</title>
<script language="JavaScript">


function cmdAdd(){
	document.frmarappayment.hidden_arap_payment_id.value="0";
	document.frmarappayment.command.value="<%=Command.ADD%>";
	document.frmarappayment.prev_command.value="<%=prevCommand%>";
	document.frmarappayment.action="arappayment.jsp";
	document.frmarappayment.submit();
}

function cmdAsk(oidArapPayment){
	document.frmarappayment.hidden_arap_payment_id.value=oidArapPayment;
	document.frmarappayment.command.value="<%=Command.ASK%>";
	document.frmarappayment.prev_command.value="<%=prevCommand%>";
	document.frmarappayment.action="arappayment.jsp";
	document.frmarappayment.submit();
}

function cmdConfirmDelete(oidArapPayment){
	document.frmarappayment.hidden_arap_payment_id.value=oidArapPayment;
	document.frmarappayment.command.value="<%=Command.DELETE%>";
	document.frmarappayment.prev_command.value="<%=prevCommand%>";
	document.frmarappayment.action="arappayment.jsp";
	document.frmarappayment.submit();
}
function cmdSave(){
	document.frmarappayment.command.value="<%=Command.SAVE%>";
	document.frmarappayment.prev_command.value="<%=prevCommand%>";
	document.frmarappayment.action="arappayment.jsp";
	document.frmarappayment.submit();
	}

function cmdEdit(oidArapPayment){
	document.frmarappayment.hidden_arap_payment_id.value=oidArapPayment;
	document.frmarappayment.command.value="<%=Command.EDIT%>";
	document.frmarappayment.prev_command.value="<%=prevCommand%>";
	document.frmarappayment.action="arappayment.jsp";
	document.frmarappayment.submit();
	}

function cmdCancel(oidArapPayment){
	document.frmarappayment.hidden_arap_payment_id.value=oidArapPayment;
	document.frmarappayment.command.value="<%=Command.EDIT%>";
	document.frmarappayment.prev_command.value="<%=prevCommand%>";
	document.frmarappayment.action="arappayment.jsp";
	document.frmarappayment.submit();
}

function cmdBack(){
	document.frmarappayment.command.value="<%=Command.BACK%>";
	document.frmarappayment.action="arappayment.jsp";
	document.frmarappayment.submit();
	}

function cmdListFirst(){
	document.frmarappayment.command.value="<%=Command.FIRST%>";
	document.frmarappayment.prev_command.value="<%=Command.FIRST%>";
	document.frmarappayment.action="arappayment.jsp";
	document.frmarappayment.submit();
}

function cmdListPrev(){
	document.frmarappayment.command.value="<%=Command.PREV%>";
	document.frmarappayment.prev_command.value="<%=Command.PREV%>";
	document.frmarappayment.action="arappayment.jsp";
	document.frmarappayment.submit();
	}

function cmdListNext(){
	document.frmarappayment.command.value="<%=Command.NEXT%>";
	document.frmarappayment.prev_command.value="<%=Command.NEXT%>";
	document.frmarappayment.action="arappayment.jsp";
	document.frmarappayment.submit();
}

function cmdListLast(){
	document.frmarappayment.command.value="<%=Command.LAST%>";
	document.frmarappayment.prev_command.value="<%=Command.LAST%>";
	document.frmarappayment.action="arappayment.jsp";
	document.frmarappayment.submit();
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

						<form name="frmarappayment" method ="post" action="">
				<input type="hidden" name="command" value="<%=iCommand%>">
				<input type="hidden" name="vectSize" value="<%=vectSize%>">
				<input type="hidden" name="start" value="<%=start%>">
				<input type="hidden" name="prev_command" value="<%=prevCommand%>">
				<input type="hidden" name="hidden_arap_payment_id" value="<%=oidArapPayment%>">
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
						      <td height="14" valign="middle" colspan="3" class="comment">&nbsp;ArapPayment
						       List </td>
						  </tr>
						  <%
							try{
								if (listArapPayment.size()>0){
							%>
						  <tr align="left" valign="top">
						        <td height="22" valign="middle" colspan="3"> <%= drawList(listArapPayment,oidArapPayment)%> </td>
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
							 <%if((iCommand ==Command.ADD)||(iCommand==Command.SAVE)&&(jspArapPayment.errorSize()>0)||(iCommand==Command.EDIT)||(iCommand==Command.ASK)){%>
								 <table width="100%" border="0" cellspacing="1" cellpadding="0">
					      <tr align="left" valign="top">
					         <td height="21" valign="middle" width="17%">&nbsp;</td>
					         <td height="21" colspan="2" width="83%" class="comment">*)= required</td>
					      </tr>
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Ap Id</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspArapPayment.fieldNames[JspArapPayment.FRM_FIELD_AP_ID] %>"  value="<%= arapPayment.getApId() %>" class="formElemen">
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Periode Id</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspArapPayment.fieldNames[JspArapPayment.FRM_FIELD_PERIODE_ID] %>"  value="<%= arapPayment.getPeriodeId() %>" class="formElemen">
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Date</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspArapPayment.fieldNames[JspArapPayment.FRM_FIELD_DATE] %>"  value="<%= arapPayment.getDate() %>" class="formElemen">
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Paid By</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspArapPayment.fieldNames[JspArapPayment.FRM_FIELD_PAID_BY] %>"  value="<%= arapPayment.getPaidBy() %>" class="formElemen">
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Rec By</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspArapPayment.fieldNames[JspArapPayment.FRM_FIELD_REC_BY] %>"  value="<%= arapPayment.getRecBy() %>" class="formElemen">
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Pay Method</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspArapPayment.fieldNames[JspArapPayment.FRM_FIELD_PAY_METHOD] %>"  value="<%= arapPayment.getPayMethod() %>" class="formElemen">
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Amount</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspArapPayment.fieldNames[JspArapPayment.FRM_FIELD_AMOUNT] %>"  value="<%= arapPayment.getAmount() %>" class="formElemen">
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Currency</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspArapPayment.fieldNames[JspArapPayment.FRM_FIELD_CURRENCY] %>"  value="<%= arapPayment.getCurrency() %>" class="formElemen">
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Exchange Rate</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspArapPayment.fieldNames[JspArapPayment.FRM_FIELD_EXCHANGE_RATE] %>"  value="<%= arapPayment.getExchangeRate() %>" class="formElemen">
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Voucher Number</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspArapPayment.fieldNames[JspArapPayment.FRM_FIELD_VOUCHER_NUMBER] %>"  value="<%= arapPayment.getVoucherNumber() %>" class="formElemen">
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Voucher Date</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspArapPayment.fieldNames[JspArapPayment.FRM_FIELD_VOUCHER_DATE] %>"  value="<%= arapPayment.getVoucherDate() %>" class="formElemen">
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Voucher Counter</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspArapPayment.fieldNames[JspArapPayment.FRM_FIELD_VOUCHER_COUNTER] %>"  value="<%= arapPayment.getVoucherCounter() %>" class="formElemen">
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Status</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspArapPayment.fieldNames[JspArapPayment.FRM_FIELD_STATUS] %>"  value="<%= arapPayment.getStatus() %>" class="formElemen">
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">User Id</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspArapPayment.fieldNames[JspArapPayment.FRM_FIELD_USER_ID] %>"  value="<%= arapPayment.getUserId() %>" class="formElemen">
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Ar Id</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspArapPayment.fieldNames[JspArapPayment.FRM_FIELD_AR_ID] %>"  value="<%= arapPayment.getArId() %>" class="formElemen">
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Memo</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspArapPayment.fieldNames[JspArapPayment.FRM_FIELD_MEMO] %>"  value="<%= arapPayment.getMemo() %>" class="formElemen">
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
									String scomDel = "javascript:cmdAsk('"+oidArapPayment+"')";
									String sconDelCom = "javascript:cmdConfirmDelete('"+oidArapPayment+"')";
									String scancel = "javascript:cmdEdit('"+oidArapPayment+"')";
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
