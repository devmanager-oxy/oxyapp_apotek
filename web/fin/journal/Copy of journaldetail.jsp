<% 
/* 
 * Page Name  		:  journaldetail.jsp
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

	public String drawList(Vector objectClass ,  long journalDetailId)

	{
		ControlList ctrlist = new ControlList();
		ctrlist.setAreaWidth("100%");
		ctrlist.setListStyle("listgen");
		ctrlist.setTitleStyle("tableheader");
		ctrlist.setCellStyle("cellStyle");
		ctrlist.setHeaderStyle("tableheader");
		ctrlist.addHeader("Coa Code","33%");
		ctrlist.addHeader("Amount","33%");
		ctrlist.addHeader("Debet Credit Flag","33%");

		ctrlist.setLinkRow(0);
		ctrlist.setLinkSufix("");
		Vector lstData = ctrlist.getData();
		Vector lstLinkData = ctrlist.getLinkData();
		ctrlist.setLinkPrefix("javascript:cmdEdit('");
		ctrlist.setLinkSufix("')");
		ctrlist.reset();
		int index = -1;

		for (int i = 0; i < objectClass.size(); i++) {
			JournalDetail journalDetail = (JournalDetail)objectClass.get(i);
			 Vector rowx = new Vector();
			 if(journalDetailId == journalDetail.getOID())
				 index = i;

			rowx.add(journalDetail.getCoaCode());

			rowx.add(String.valueOf(journalDetail.getAmount()));

			rowx.add(journalDetail.getDebetCreditFlag());

			lstData.add(rowx);
			lstLinkData.add(String.valueOf(journalDetail.getOID()));
		}

		return ctrlist.drawList(index);
	}

%>
<%
int iCommand = FRMQueryString.requestCommand(request);
int start = FRMQueryString.requestInt(request, "start");
int prevCommand = FRMQueryString.requestInt(request, "prev_command");
long oidJournalDetail = FRMQueryString.requestLong(request, "hidden_journal_detail_id");

/*variable declaration*/
int recordToGet = 10;
String msgString = "";
int iErrCode = FRMMessage.NONE;
String whereClause = "";
String orderClause = "";

CtrlJournalDetail ctrlJournalDetail = new CtrlJournalDetail(request);
ControlLine ctrLine = new ControlLine();
Vector listJournalDetail = new Vector(1,1);

/*switch statement */
iErrCode = ctrlJournalDetail.action(iCommand , oidJournalDetail);
/* end switch*/
JspJournalDetail jspJournalDetail = ctrlJournalDetail.getForm();

/*count list All JournalDetail*/
int vectSize = PstJournalDetail.getCount(whereClause);

JournalDetail journalDetail = ctrlJournalDetail.getJournalDetail();
msgString =  ctrlJournalDetail.getMessage();

/*switch list JournalDetail*/
if((iCommand == Command.SAVE) && (iErrCode == FRMMessage.NONE))
	start = PstJournalDetail.generateFindStart(journalDetail.getOID(),recordToGet, whereClause);

if((iCommand == Command.FIRST || iCommand == Command.PREV )||
  (iCommand == Command.NEXT || iCommand == Command.LAST)){
		start = ctrlJournalDetail.actionList(iCommand, start, vectSize, recordToGet);
 } 
/* end switch list*/

/* get record to display */
listJournalDetail = PstJournalDetail.list(start,recordToGet, whereClause , orderClause);

/*handle condition if size of record to display = 0 and start > 0 	after delete*/
if (listJournalDetail.size() < 1 && start > 0)
{
	 if (vectSize - recordToGet > recordToGet)
			start = start - recordToGet;   //go to Command.PREV
	 else{
		 start = 0 ;
		 iCommand = Command.FIRST;
		 prevCommand = Command.FIRST; //go to Command.FIRST
	 }
	 listJournalDetail = PstJournalDetail.list(start,recordToGet, whereClause , orderClause);
}
%>


<html><!-- #BeginTemplate "/Templates/main.dwt" -->
<head>
<!-- #BeginEditable "doctitle" -->
<title>finance--</title>
<script language="JavaScript">


function cmdAdd(){
	document.frmjournaldetail.hidden_journal_detail_id.value="0";
	document.frmjournaldetail.command.value="<%=Command.ADD%>";
	document.frmjournaldetail.prev_command.value="<%=prevCommand%>";
	document.frmjournaldetail.action="journaldetail.jsp";
	document.frmjournaldetail.submit();
}

function cmdAsk(oidJournalDetail){
	document.frmjournaldetail.hidden_journal_detail_id.value=oidJournalDetail;
	document.frmjournaldetail.command.value="<%=Command.ASK%>";
	document.frmjournaldetail.prev_command.value="<%=prevCommand%>";
	document.frmjournaldetail.action="journaldetail.jsp";
	document.frmjournaldetail.submit();
}

function cmdConfirmDelete(oidJournalDetail){
	document.frmjournaldetail.hidden_journal_detail_id.value=oidJournalDetail;
	document.frmjournaldetail.command.value="<%=Command.DELETE%>";
	document.frmjournaldetail.prev_command.value="<%=prevCommand%>";
	document.frmjournaldetail.action="journaldetail.jsp";
	document.frmjournaldetail.submit();
}
function cmdSave(){
	document.frmjournaldetail.command.value="<%=Command.SAVE%>";
	document.frmjournaldetail.prev_command.value="<%=prevCommand%>";
	document.frmjournaldetail.action="journaldetail.jsp";
	document.frmjournaldetail.submit();
	}

function cmdEdit(oidJournalDetail){
	document.frmjournaldetail.hidden_journal_detail_id.value=oidJournalDetail;
	document.frmjournaldetail.command.value="<%=Command.EDIT%>";
	document.frmjournaldetail.prev_command.value="<%=prevCommand%>";
	document.frmjournaldetail.action="journaldetail.jsp";
	document.frmjournaldetail.submit();
	}

function cmdCancel(oidJournalDetail){
	document.frmjournaldetail.hidden_journal_detail_id.value=oidJournalDetail;
	document.frmjournaldetail.command.value="<%=Command.EDIT%>";
	document.frmjournaldetail.prev_command.value="<%=prevCommand%>";
	document.frmjournaldetail.action="journaldetail.jsp";
	document.frmjournaldetail.submit();
}

function cmdBack(){
	document.frmjournaldetail.command.value="<%=Command.BACK%>";
	document.frmjournaldetail.action="journaldetail.jsp";
	document.frmjournaldetail.submit();
	}

function cmdListFirst(){
	document.frmjournaldetail.command.value="<%=Command.FIRST%>";
	document.frmjournaldetail.prev_command.value="<%=Command.FIRST%>";
	document.frmjournaldetail.action="journaldetail.jsp";
	document.frmjournaldetail.submit();
}

function cmdListPrev(){
	document.frmjournaldetail.command.value="<%=Command.PREV%>";
	document.frmjournaldetail.prev_command.value="<%=Command.PREV%>";
	document.frmjournaldetail.action="journaldetail.jsp";
	document.frmjournaldetail.submit();
	}

function cmdListNext(){
	document.frmjournaldetail.command.value="<%=Command.NEXT%>";
	document.frmjournaldetail.prev_command.value="<%=Command.NEXT%>";
	document.frmjournaldetail.action="journaldetail.jsp";
	document.frmjournaldetail.submit();
}

function cmdListLast(){
	document.frmjournaldetail.command.value="<%=Command.LAST%>";
	document.frmjournaldetail.prev_command.value="<%=Command.LAST%>";
	document.frmjournaldetail.action="journaldetail.jsp";
	document.frmjournaldetail.submit();
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

						<form name="frmjournaldetail" method ="post" action="">
				<input type="hidden" name="command" value="<%=iCommand%>">
				<input type="hidden" name="vectSize" value="<%=vectSize%>">
				<input type="hidden" name="start" value="<%=start%>">
				<input type="hidden" name="prev_command" value="<%=prevCommand%>">
				<input type="hidden" name="hidden_journal_detail_id" value="<%=oidJournalDetail%>">
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
						      <td height="14" valign="middle" colspan="3" class="comment">&nbsp;JournalDetail
						       List </td>
						  </tr>
						  <%
							try{
								if (listJournalDetail.size()>0){
							%>
						  <tr align="left" valign="top">
						        <td height="22" valign="middle" colspan="3"> <%= drawList(listJournalDetail,oidJournalDetail)%> </td>
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
							 <%if((iCommand ==Command.ADD)||(iCommand==Command.SAVE)&&(jspJournalDetail.errorSize()>0)||(iCommand==Command.EDIT)||(iCommand==Command.ASK)){%>
								 <table width="100%" border="0" cellspacing="1" cellpadding="0">
					      <tr align="left" valign="top">
					         <td height="21" valign="middle" width="17%">&nbsp;</td>
					         <td height="21" colspan="2" width="83%" class="comment">*)= required</td>
					      </tr>
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Journal Id</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspJournalDetail.fieldNames[JspJournalDetail.FRM_FIELD_JOURNAL_ID] %>"  value="<%= journalDetail.getJournalId() %>" class="formElemen">
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Coa Id</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspJournalDetail.fieldNames[JspJournalDetail.FRM_FIELD_COA_ID] %>"  value="<%= journalDetail.getCoaId() %>" class="formElemen">
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Amount</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspJournalDetail.fieldNames[JspJournalDetail.FRM_FIELD_AMOUNT] %>"  value="<%= journalDetail.getAmount() %>" class="formElemen">
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Debet Credit Flag</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspJournalDetail.fieldNames[JspJournalDetail.FRM_FIELD_DEBET_CREDIT_FLAG] %>"  value="<%= journalDetail.getDebetCreditFlag() %>" class="formElemen">
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Department Id</td>
					       <td height="21" colspan="2" width="83%">
					   <% Vector departmentid_value = new Vector(1,1);
						Vector departmentid_key = new Vector(1,1);
					 	String sel_departmentid = ""+journalDetail.getDepartmentId();
					   departmentid_key.add("---select---");
					   departmentid_value.add("");
					   %>
						<%= ControlCombo.draw(jspJournalDetail.fieldNames[JspJournalDetail.FRM_FIELD_DEPARTMENT_ID],null, sel_departmentid, departmentid_key, departmentid_value, "", "formElemen") %>
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Section Id</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspJournalDetail.fieldNames[JspJournalDetail.FRM_FIELD_SECTION_ID] %>"  value="<%= journalDetail.getSectionId() %>" class="formElemen">
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Department Name</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspJournalDetail.fieldNames[JspJournalDetail.FRM_FIELD_DEPARTMENT_NAME] %>"  value="<%= journalDetail.getDepartmentName() %>" class="formElemen">
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Section Name</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspJournalDetail.fieldNames[JspJournalDetail.FRM_FIELD_SECTION_NAME] %>"  value="<%= journalDetail.getSectionName() %>" class="formElemen">
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Coa Code</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspJournalDetail.fieldNames[JspJournalDetail.FRM_FIELD_COA_CODE] %>"  value="<%= journalDetail.getCoaCode() %>" class="formElemen">
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Arap Id</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspJournalDetail.fieldNames[JspJournalDetail.FRM_FIELD_ARAP_ID] %>"  value="<%= journalDetail.getArapId() %>" class="formElemen">
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Periode Id</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspJournalDetail.fieldNames[JspJournalDetail.FRM_FIELD_PERIODE_ID] %>"  value="<%= journalDetail.getPeriodeId() %>" class="formElemen">
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Exchange Rate</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspJournalDetail.fieldNames[JspJournalDetail.FRM_FIELD_EXCHANGE_RATE] %>"  value="<%= journalDetail.getExchangeRate() %>" class="formElemen">
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Arap Payment Id</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspJournalDetail.fieldNames[JspJournalDetail.FRM_FIELD_ARAP_PAYMENT_ID] %>"  value="<%= journalDetail.getArapPaymentId() %>" class="formElemen">
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Currency</td>
					       <td height="21" colspan="2" width="83%">
					   <% Vector currency_value = new Vector(1,1);
						Vector currency_key = new Vector(1,1);
					 	String sel_currency = ""+journalDetail.getCurrency();
					   currency_key.add("---select---");
					   currency_value.add("");
					   %>
						<%= ControlCombo.draw(jspJournalDetail.fieldNames[JspJournalDetail.FRM_FIELD_CURRENCY],null, sel_currency, currency_key, currency_value, "", "formElemen") %>
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">User Id</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspJournalDetail.fieldNames[JspJournalDetail.FRM_FIELD_USER_ID] %>"  value="<%= journalDetail.getUserId() %>" class="formElemen">
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Status</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspJournalDetail.fieldNames[JspJournalDetail.FRM_FIELD_STATUS] %>"  value="<%= journalDetail.getStatus() %>" class="formElemen">
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
									String scomDel = "javascript:cmdAsk('"+oidJournalDetail+"')";
									String sconDelCom = "javascript:cmdConfirmDelete('"+oidJournalDetail+"')";
									String scancel = "javascript:cmdEdit('"+oidJournalDetail+"')";
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
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      