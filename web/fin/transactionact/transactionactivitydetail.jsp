<% 
/* 
 * Page Name  		:  transactionactivitydetail.jsp
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
<%@ page import = "com.dimata.finance.entity.transaction.*" %>
<%@ page import = "com.dimata.finance.form.transaction.*" %>
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

	public String drawList(Vector objectClass ,  long transactionActivityDetailId)

	{
		ControlList ctrlist = new ControlList();
		ctrlist.setAreaWidth("100%");
		ctrlist.setListStyle("listgen");
		ctrlist.setTitleStyle("tableheader");
		ctrlist.setCellStyle("cellStyle");
		ctrlist.setHeaderStyle("tableheader");
		ctrlist.addHeader("Fa Percent","11%");
		ctrlist.addHeader("Log Percent","11%");
		ctrlist.addHeader("Fa Amount","11%");
		ctrlist.addHeader("Log Amount","11%");
		ctrlist.addHeader("Transaction Id","11%");
		ctrlist.addHeader("Predefined","11%");
		ctrlist.addHeader("Coa Id","11%");
		ctrlist.addHeader("Type","11%");
		ctrlist.addHeader("Module Amount","11%");

		ctrlist.setLinkRow(0);
		ctrlist.setLinkSufix("");
		Vector lstData = ctrlist.getData();
		Vector lstLinkData = ctrlist.getLinkData();
		ctrlist.setLinkPrefix("javascript:cmdEdit('");
		ctrlist.setLinkSufix("')");
		ctrlist.reset();
		int index = -1;

		for (int i = 0; i < objectClass.size(); i++) {
			TransactionActivityDetail transactionActivityDetail = (TransactionActivityDetail)objectClass.get(i);
			 Vector rowx = new Vector();
			 if(transactionActivityDetailId == transactionActivityDetail.getOID())
				 index = i;

			rowx.add(String.valueOf(transactionActivityDetail.getFaPercent()));

			rowx.add(String.valueOf(transactionActivityDetail.getLogPercent()));

			rowx.add(String.valueOf(transactionActivityDetail.getFaAmount()));

			rowx.add(String.valueOf(transactionActivityDetail.getLogAmount()));

			rowx.add(String.valueOf(transactionActivityDetail.getTransactionId()));

			rowx.add(String.valueOf(transactionActivityDetail.getPredefined()));

			rowx.add(String.valueOf(transactionActivityDetail.getCoaId()));

			rowx.add(String.valueOf(transactionActivityDetail.getType()));

			rowx.add(String.valueOf(transactionActivityDetail.getModuleAmount()));

			lstData.add(rowx);
			lstLinkData.add(String.valueOf(transactionActivityDetail.getOID()));
		}

		return ctrlist.drawList(index);
	}

%>
<%
int iCommand = FRMQueryString.requestCommand(request);
int start = FRMQueryString.requestInt(request, "start");
int prevCommand = FRMQueryString.requestInt(request, "prev_command");
long oidTransactionActivityDetail = FRMQueryString.requestLong(request, "hidden_transaction_activity_detail_id");

/*variable declaration*/
int recordToGet = 10;
String msgString = "";
int iErrCode = FRMMessage.NONE;
String whereClause = "";
String orderClause = "";

CtrlTransactionActivityDetail ctrlTransactionActivityDetail = new CtrlTransactionActivityDetail(request);
ControlLine ctrLine = new ControlLine();
Vector listTransactionActivityDetail = new Vector(1,1);

/*switch statement */
iErrCode = ctrlTransactionActivityDetail.action(iCommand , oidTransactionActivityDetail);
/* end switch*/
JspTransactionActivityDetail jspTransactionActivityDetail = ctrlTransactionActivityDetail.getForm();

/*count list All TransactionActivityDetail*/
int vectSize = PstTransactionActivityDetail.getCount(whereClause);

TransactionActivityDetail transactionActivityDetail = ctrlTransactionActivityDetail.getTransactionActivityDetail();
msgString =  ctrlTransactionActivityDetail.getMessage();

/*switch list TransactionActivityDetail*/
if((iCommand == Command.SAVE) && (iErrCode == FRMMessage.NONE))
	start = PstTransactionActivityDetail.generateFindStart(transactionActivityDetail.getOID(),recordToGet, whereClause);

if((iCommand == Command.FIRST || iCommand == Command.PREV )||
  (iCommand == Command.NEXT || iCommand == Command.LAST)){
		start = ctrlTransactionActivityDetail.actionList(iCommand, start, vectSize, recordToGet);
 } 
/* end switch list*/

/* get record to display */
listTransactionActivityDetail = PstTransactionActivityDetail.list(start,recordToGet, whereClause , orderClause);

/*handle condition if size of record to display = 0 and start > 0 	after delete*/
if (listTransactionActivityDetail.size() < 1 && start > 0)
{
	 if (vectSize - recordToGet > recordToGet)
			start = start - recordToGet;   //go to Command.PREV
	 else{
		 start = 0 ;
		 iCommand = Command.FIRST;
		 prevCommand = Command.FIRST; //go to Command.FIRST
	 }
	 listTransactionActivityDetail = PstTransactionActivityDetail.list(start,recordToGet, whereClause , orderClause);
}
%>


<html><!-- #BeginTemplate "/Templates/main.dwt" -->
<head>
<!-- #BeginEditable "doctitle" -->
<title>finance--</title>
<script language="JavaScript">


function cmdAdd(){
	document.frmtransactionactivitydetail.hidden_transaction_activity_detail_id.value="0";
	document.frmtransactionactivitydetail.command.value="<%=Command.ADD%>";
	document.frmtransactionactivitydetail.prev_command.value="<%=prevCommand%>";
	document.frmtransactionactivitydetail.action="transactionactivitydetail.jsp";
	document.frmtransactionactivitydetail.submit();
}

function cmdAsk(oidTransactionActivityDetail){
	document.frmtransactionactivitydetail.hidden_transaction_activity_detail_id.value=oidTransactionActivityDetail;
	document.frmtransactionactivitydetail.command.value="<%=Command.ASK%>";
	document.frmtransactionactivitydetail.prev_command.value="<%=prevCommand%>";
	document.frmtransactionactivitydetail.action="transactionactivitydetail.jsp";
	document.frmtransactionactivitydetail.submit();
}

function cmdConfirmDelete(oidTransactionActivityDetail){
	document.frmtransactionactivitydetail.hidden_transaction_activity_detail_id.value=oidTransactionActivityDetail;
	document.frmtransactionactivitydetail.command.value="<%=Command.DELETE%>";
	document.frmtransactionactivitydetail.prev_command.value="<%=prevCommand%>";
	document.frmtransactionactivitydetail.action="transactionactivitydetail.jsp";
	document.frmtransactionactivitydetail.submit();
}
function cmdSave(){
	document.frmtransactionactivitydetail.command.value="<%=Command.SAVE%>";
	document.frmtransactionactivitydetail.prev_command.value="<%=prevCommand%>";
	document.frmtransactionactivitydetail.action="transactionactivitydetail.jsp";
	document.frmtransactionactivitydetail.submit();
	}

function cmdEdit(oidTransactionActivityDetail){
	document.frmtransactionactivitydetail.hidden_transaction_activity_detail_id.value=oidTransactionActivityDetail;
	document.frmtransactionactivitydetail.command.value="<%=Command.EDIT%>";
	document.frmtransactionactivitydetail.prev_command.value="<%=prevCommand%>";
	document.frmtransactionactivitydetail.action="transactionactivitydetail.jsp";
	document.frmtransactionactivitydetail.submit();
	}

function cmdCancel(oidTransactionActivityDetail){
	document.frmtransactionactivitydetail.hidden_transaction_activity_detail_id.value=oidTransactionActivityDetail;
	document.frmtransactionactivitydetail.command.value="<%=Command.EDIT%>";
	document.frmtransactionactivitydetail.prev_command.value="<%=prevCommand%>";
	document.frmtransactionactivitydetail.action="transactionactivitydetail.jsp";
	document.frmtransactionactivitydetail.submit();
}

function cmdBack(){
	document.frmtransactionactivitydetail.command.value="<%=Command.BACK%>";
	document.frmtransactionactivitydetail.action="transactionactivitydetail.jsp";
	document.frmtransactionactivitydetail.submit();
	}

function cmdListFirst(){
	document.frmtransactionactivitydetail.command.value="<%=Command.FIRST%>";
	document.frmtransactionactivitydetail.prev_command.value="<%=Command.FIRST%>";
	document.frmtransactionactivitydetail.action="transactionactivitydetail.jsp";
	document.frmtransactionactivitydetail.submit();
}

function cmdListPrev(){
	document.frmtransactionactivitydetail.command.value="<%=Command.PREV%>";
	document.frmtransactionactivitydetail.prev_command.value="<%=Command.PREV%>";
	document.frmtransactionactivitydetail.action="transactionactivitydetail.jsp";
	document.frmtransactionactivitydetail.submit();
	}

function cmdListNext(){
	document.frmtransactionactivitydetail.command.value="<%=Command.NEXT%>";
	document.frmtransactionactivitydetail.prev_command.value="<%=Command.NEXT%>";
	document.frmtransactionactivitydetail.action="transactionactivitydetail.jsp";
	document.frmtransactionactivitydetail.submit();
}

function cmdListLast(){
	document.frmtransactionactivitydetail.command.value="<%=Command.LAST%>";
	document.frmtransactionactivitydetail.prev_command.value="<%=Command.LAST%>";
	document.frmtransactionactivitydetail.action="transactionactivitydetail.jsp";
	document.frmtransactionactivitydetail.submit();
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

						<form name="frmtransactionactivitydetail" method ="post" action="">
				<input type="hidden" name="command" value="<%=iCommand%>">
				<input type="hidden" name="vectSize" value="<%=vectSize%>">
				<input type="hidden" name="start" value="<%=start%>">
				<input type="hidden" name="prev_command" value="<%=prevCommand%>">
				<input type="hidden" name="hidden_transaction_activity_detail_id" value="<%=oidTransactionActivityDetail%>">
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
						      <td height="14" valign="middle" colspan="3" class="comment">&nbsp;TransactionActivityDetail
						       List </td>
						  </tr>
						  <%
							try{
								if (listTransactionActivityDetail.size()>0){
							%>
						  <tr align="left" valign="top">
						        <td height="22" valign="middle" colspan="3"> <%= drawList(listTransactionActivityDetail,oidTransactionActivityDetail)%> </td>
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
							 <%if((iCommand ==Command.ADD)||(iCommand==Command.SAVE)&&(jspTransactionActivityDetail.errorSize()>0)||(iCommand==Command.EDIT)||(iCommand==Command.ASK)){%>
								 <table width="100%" border="0" cellspacing="1" cellpadding="0">
					      <tr align="left" valign="top">
					         <td height="21" valign="middle" width="17%">&nbsp;</td>
					         <td height="21" colspan="2" width="83%" class="comment">*)= required</td>
					      </tr>
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Fa Percent</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspTransactionActivityDetail.fieldNames[JspTransactionActivityDetail.FRM_FIELD_FA_PERCENT] %>"  value="<%= transactionActivityDetail.getFaPercent() %>" class="formElemen">
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Log Percent</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspTransactionActivityDetail.fieldNames[JspTransactionActivityDetail.FRM_FIELD_LOG_PERCENT] %>"  value="<%= transactionActivityDetail.getLogPercent() %>" class="formElemen">
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Fa Amount</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspTransactionActivityDetail.fieldNames[JspTransactionActivityDetail.FRM_FIELD_FA_AMOUNT] %>"  value="<%= transactionActivityDetail.getFaAmount() %>" class="formElemen">
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Log Amount</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspTransactionActivityDetail.fieldNames[JspTransactionActivityDetail.FRM_FIELD_LOG_AMOUNT] %>"  value="<%= transactionActivityDetail.getLogAmount() %>" class="formElemen">
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Transaction Id</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspTransactionActivityDetail.fieldNames[JspTransactionActivityDetail.FRM_FIELD_TRANSACTION_ID] %>"  value="<%= transactionActivityDetail.getTransactionId() %>" class="formElemen">
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Predefined</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspTransactionActivityDetail.fieldNames[JspTransactionActivityDetail.FRM_FIELD_PREDEFINED] %>"  value="<%= transactionActivityDetail.getPredefined() %>" class="formElemen">
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Coa Id</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspTransactionActivityDetail.fieldNames[JspTransactionActivityDetail.FRM_FIELD_COA_ID] %>"  value="<%= transactionActivityDetail.getCoaId() %>" class="formElemen">
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Type</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspTransactionActivityDetail.fieldNames[JspTransactionActivityDetail.FRM_FIELD_TYPE] %>"  value="<%= transactionActivityDetail.getType() %>" class="formElemen">
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Module Amount</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspTransactionActivityDetail.fieldNames[JspTransactionActivityDetail.FRM_FIELD_MODULE_AMOUNT] %>"  value="<%= transactionActivityDetail.getModuleAmount() %>" class="formElemen">
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Module Id</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspTransactionActivityDetail.fieldNames[JspTransactionActivityDetail.FRM_FIELD_MODULE_ID] %>"  value="<%= transactionActivityDetail.getModuleId() %>" class="formElemen">
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Module Percent</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspTransactionActivityDetail.fieldNames[JspTransactionActivityDetail.FRM_FIELD_MODULE_PERCENT] %>"  value="<%= transactionActivityDetail.getModulePercent() %>" class="formElemen">
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
									String scomDel = "javascript:cmdAsk('"+oidTransactionActivityDetail+"')";
									String sconDelCom = "javascript:cmdConfirmDelete('"+oidTransactionActivityDetail+"')";
									String scancel = "javascript:cmdEdit('"+oidTransactionActivityDetail+"')";
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
