<% 
/* 
 * Page Name  		:  journalumum.jsp
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

	public String drawList(Vector objectClass ,  long journalId)

	{
		ControlList ctrlist = new ControlList();
		ctrlist.setAreaWidth("100%");
		ctrlist.setListStyle("listgen");
		ctrlist.setTitleStyle("tableheader");
		ctrlist.setCellStyle("cellStyle");
		ctrlist.setHeaderStyle("tableheader");
		ctrlist.addHeader("Date","14%");
		ctrlist.addHeader("Pic By","14%");
		ctrlist.addHeader("Currency","14%");
		ctrlist.addHeader("Memo","14%");
		ctrlist.addHeader("Amount","14%");
		ctrlist.addHeader("Periode Id","14%");
		ctrlist.addHeader("Status","14%");

		ctrlist.setLinkRow(0);
		ctrlist.setLinkSufix("");
		Vector lstData = ctrlist.getData();
		Vector lstLinkData = ctrlist.getLinkData();
		ctrlist.setLinkPrefix("javascript:cmdEdit('");
		ctrlist.setLinkSufix("')");
		ctrlist.reset();
		int index = -1;

		for (int i = 0; i < objectClass.size(); i++) {
			JournalUmum journalUmum = (JournalUmum)objectClass.get(i);
			 Vector rowx = new Vector();
			 if(journalId == journalUmum.getOID())
				 index = i;

			String str_dt_Date = ""; 
			try{
				Date dt_Date = journalUmum.getDate();
				if(dt_Date==null){
					dt_Date = new Date();
				}

				str_dt_Date = Formater.formatDate(dt_Date, "dd MMMM yyyy");
			}catch(Exception e){ str_dt_Date = ""; }

			rowx.add(str_dt_Date);

			rowx.add(journalUmum.getPicBy());

			rowx.add(journalUmum.getCurrency());

			rowx.add(journalUmum.getMemo());

			rowx.add(String.valueOf(journalUmum.getAmount()));

			rowx.add(String.valueOf(journalUmum.getPeriodeId()));

			rowx.add(journalUmum.getStatus());

			lstData.add(rowx);
			lstLinkData.add(String.valueOf(journalUmum.getOID()));
		}

		return ctrlist.drawList(index);
	}

%>
<%
int iCommand = FRMQueryString.requestCommand(request);
int start = FRMQueryString.requestInt(request, "start");
int prevCommand = FRMQueryString.requestInt(request, "prev_command");
long oidJournalUmum = FRMQueryString.requestLong(request, "hidden_journal_id");

/*variable declaration*/
int recordToGet = 10;
String msgString = "";
int iErrCode = FRMMessage.NONE;
String whereClause = "";
String orderClause = "";

CtrlJournalUmum ctrlJournalUmum = new CtrlJournalUmum(request);
ControlLine ctrLine = new ControlLine();
Vector listJournalUmum = new Vector(1,1);

/*switch statement */
iErrCode = ctrlJournalUmum.action(iCommand , oidJournalUmum);
/* end switch*/
JspJournalUmum jspJournalUmum = ctrlJournalUmum.getForm();

/*count list All JournalUmum*/
int vectSize = PstJournalUmum.getCount(whereClause);

JournalUmum journalUmum = ctrlJournalUmum.getJournalUmum();
msgString =  ctrlJournalUmum.getMessage();

/*switch list JournalUmum*/
if((iCommand == Command.SAVE) && (iErrCode == FRMMessage.NONE))
	start = PstJournalUmum.generateFindStart(journalUmum.getOID(),recordToGet, whereClause);

if((iCommand == Command.FIRST || iCommand == Command.PREV )||
  (iCommand == Command.NEXT || iCommand == Command.LAST)){
		start = ctrlJournalUmum.actionList(iCommand, start, vectSize, recordToGet);
 } 
/* end switch list*/

/* get record to display */
listJournalUmum = PstJournalUmum.list(start,recordToGet, whereClause , orderClause);

/*handle condition if size of record to display = 0 and start > 0 	after delete*/
if (listJournalUmum.size() < 1 && start > 0)
{
	 if (vectSize - recordToGet > recordToGet)
			start = start - recordToGet;   //go to Command.PREV
	 else{
		 start = 0 ;
		 iCommand = Command.FIRST;
		 prevCommand = Command.FIRST; //go to Command.FIRST
	 }
	 listJournalUmum = PstJournalUmum.list(start,recordToGet, whereClause , orderClause);
}
%>


<html><!-- #BeginTemplate "/Templates/main.dwt" -->
<head>
<!-- #BeginEditable "doctitle" -->
<title>finance--</title>
<script language="JavaScript">


function cmdAdd(){
	document.frmjournalumum.hidden_journal_id.value="0";
	document.frmjournalumum.command.value="<%=Command.ADD%>";
	document.frmjournalumum.prev_command.value="<%=prevCommand%>";
	document.frmjournalumum.action="journalumum.jsp";
	document.frmjournalumum.submit();
}

function cmdAsk(oidJournalUmum){
	document.frmjournalumum.hidden_journal_id.value=oidJournalUmum;
	document.frmjournalumum.command.value="<%=Command.ASK%>";
	document.frmjournalumum.prev_command.value="<%=prevCommand%>";
	document.frmjournalumum.action="journalumum.jsp";
	document.frmjournalumum.submit();
}

function cmdConfirmDelete(oidJournalUmum){
	document.frmjournalumum.hidden_journal_id.value=oidJournalUmum;
	document.frmjournalumum.command.value="<%=Command.DELETE%>";
	document.frmjournalumum.prev_command.value="<%=prevCommand%>";
	document.frmjournalumum.action="journalumum.jsp";
	document.frmjournalumum.submit();
}
function cmdSave(){
	document.frmjournalumum.command.value="<%=Command.SAVE%>";
	document.frmjournalumum.prev_command.value="<%=prevCommand%>";
	document.frmjournalumum.action="journalumum.jsp";
	document.frmjournalumum.submit();
	}

function cmdEdit(oidJournalUmum){
	document.frmjournalumum.hidden_journal_id.value=oidJournalUmum;
	document.frmjournalumum.command.value="<%=Command.EDIT%>";
	document.frmjournalumum.prev_command.value="<%=prevCommand%>";
	document.frmjournalumum.action="journalumum.jsp";
	document.frmjournalumum.submit();
	}

function cmdCancel(oidJournalUmum){
	document.frmjournalumum.hidden_journal_id.value=oidJournalUmum;
	document.frmjournalumum.command.value="<%=Command.EDIT%>";
	document.frmjournalumum.prev_command.value="<%=prevCommand%>";
	document.frmjournalumum.action="journalumum.jsp";
	document.frmjournalumum.submit();
}

function cmdBack(){
	document.frmjournalumum.command.value="<%=Command.BACK%>";
	document.frmjournalumum.action="journalumum.jsp";
	document.frmjournalumum.submit();
	}

function cmdListFirst(){
	document.frmjournalumum.command.value="<%=Command.FIRST%>";
	document.frmjournalumum.prev_command.value="<%=Command.FIRST%>";
	document.frmjournalumum.action="journalumum.jsp";
	document.frmjournalumum.submit();
}

function cmdListPrev(){
	document.frmjournalumum.command.value="<%=Command.PREV%>";
	document.frmjournalumum.prev_command.value="<%=Command.PREV%>";
	document.frmjournalumum.action="journalumum.jsp";
	document.frmjournalumum.submit();
	}

function cmdListNext(){
	document.frmjournalumum.command.value="<%=Command.NEXT%>";
	document.frmjournalumum.prev_command.value="<%=Command.NEXT%>";
	document.frmjournalumum.action="journalumum.jsp";
	document.frmjournalumum.submit();
}

function cmdListLast(){
	document.frmjournalumum.command.value="<%=Command.LAST%>";
	document.frmjournalumum.prev_command.value="<%=Command.LAST%>";
	document.frmjournalumum.action="journalumum.jsp";
	document.frmjournalumum.submit();
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

						<form name="frmjournalumum" method ="post" action="">
				<input type="hidden" name="command" value="<%=iCommand%>">
				<input type="hidden" name="vectSize" value="<%=vectSize%>">
				<input type="hidden" name="start" value="<%=start%>">
				<input type="hidden" name="prev_command" value="<%=prevCommand%>">
				<input type="hidden" name="hidden_journal_id" value="<%=oidJournalUmum%>">
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
						      <td height="14" valign="middle" colspan="3" class="comment">&nbsp;JournalUmum
						       List </td>
						  </tr>
						  <%
							try{
								if (listJournalUmum.size()>0){
							%>
						  <tr align="left" valign="top">
						        <td height="22" valign="middle" colspan="3"> <%= drawList(listJournalUmum,oidJournalUmum)%> </td>
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
							 <%if((iCommand ==Command.ADD)||(iCommand==Command.SAVE)&&(jspJournalUmum.errorSize()>0)||(iCommand==Command.EDIT)||(iCommand==Command.ASK)){%>
								 <table width="100%" border="0" cellspacing="1" cellpadding="0">
					      <tr align="left" valign="top">
					         <td height="21" valign="middle" width="17%">&nbsp;</td>
					         <td height="21" colspan="2" width="83%" class="comment">*)= required</td>
					      </tr>
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Date</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspJournalUmum.fieldNames[JspJournalUmum.FRM_FIELD_DATE] %>"  value="<%= journalUmum.getDate() %>" class="formElemen">
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Pic By</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspJournalUmum.fieldNames[JspJournalUmum.FRM_FIELD_PIC_BY] %>"  value="<%= journalUmum.getPicBy() %>" class="formElemen">
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Currency</td>
					       <td height="21" colspan="2" width="83%">
					   <% Vector currency_value = new Vector(1,1);
						Vector currency_key = new Vector(1,1);
					 	String sel_currency = ""+journalUmum.getCurrency();
					   currency_key.add("---select---");
					   currency_value.add("");
					   %>
						<%= ControlCombo.draw(jspJournalUmum.fieldNames[JspJournalUmum.FRM_FIELD_CURRENCY],null, sel_currency, currency_key, currency_value, "", "formElemen") %>
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Memo</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspJournalUmum.fieldNames[JspJournalUmum.FRM_FIELD_MEMO] %>"  value="<%= journalUmum.getMemo() %>" class="formElemen">
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Pic From</td>
					       <td height="21" colspan="2" width="83%">
					   <% Vector picfrom_value = new Vector(1,1);
						Vector picfrom_key = new Vector(1,1);
					 	String sel_picfrom = ""+journalUmum.getPicFrom();
					   picfrom_key.add("---select---");
					   picfrom_value.add("");
					   %>
						<%= ControlCombo.draw(jspJournalUmum.fieldNames[JspJournalUmum.FRM_FIELD_PIC_FROM],null, sel_picfrom, picfrom_key, picfrom_value, "", "formElemen") %>
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">User By Id</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspJournalUmum.fieldNames[JspJournalUmum.FRM_FIELD_USER_BY_ID] %>"  value="<%= journalUmum.getUserById() %>" class="formElemen">
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">User From Id</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspJournalUmum.fieldNames[JspJournalUmum.FRM_FIELD_USER_FROM_ID] %>"  value="<%= journalUmum.getUserFromId() %>" class="formElemen">
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Periode Id</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspJournalUmum.fieldNames[JspJournalUmum.FRM_FIELD_PERIODE_ID] %>"  value="<%= journalUmum.getPeriodeId() %>" class="formElemen">
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Status</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspJournalUmum.fieldNames[JspJournalUmum.FRM_FIELD_STATUS] %>"  value="<%= journalUmum.getStatus() %>" class="formElemen">
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Amount</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspJournalUmum.fieldNames[JspJournalUmum.FRM_FIELD_AMOUNT] %>"  value="<%= journalUmum.getAmount() %>" class="formElemen">
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Reff No</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspJournalUmum.fieldNames[JspJournalUmum.FRM_FIELD_REFF_NO] %>"  value="<%= journalUmum.getReffNo() %>" class="formElemen">
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Voucher Number</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspJournalUmum.fieldNames[JspJournalUmum.FRM_FIELD_VOUCHER_NUMBER] %>"  value="<%= journalUmum.getVoucherNumber() %>" class="formElemen">
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Voucher Counter</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspJournalUmum.fieldNames[JspJournalUmum.FRM_FIELD_VOUCHER_COUNTER] %>"  value="<%= journalUmum.getVoucherCounter() %>" class="formElemen">
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Voucher Date</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspJournalUmum.fieldNames[JspJournalUmum.FRM_FIELD_VOUCHER_DATE] %>"  value="<%= journalUmum.getVoucherDate() %>" class="formElemen">
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Exchange Rate</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspJournalUmum.fieldNames[JspJournalUmum.FRM_FIELD_EXCHANGE_RATE] %>"  value="<%= journalUmum.getExchangeRate() %>" class="formElemen">
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">User Id</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspJournalUmum.fieldNames[JspJournalUmum.FRM_FIELD_USER_ID] %>"  value="<%= journalUmum.getUserId() %>" class="formElemen">
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
									String scomDel = "javascript:cmdAsk('"+oidJournalUmum+"')";
									String sconDelCom = "javascript:cmdConfirmDelete('"+oidJournalUmum+"')";
									String scancel = "javascript:cmdEdit('"+oidJournalUmum+"')";
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
