<% 
/* 
 * Page Name  		:  stock.jsp
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

<!--package ccs -->
<%@ page import = "com.dimata.ccs.entity.postransaction.*" %>
<%@ page import = "com.dimata.ccs.form.postransaction.*" %>
<%@ page import = "com.dimata.ccs.entity.admin.*" %>
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

	public String drawList(Vector objectClass ,  long stockId)

	{
		ControlList ctrlist = new ControlList();
		ctrlist.setAreaWidth("100%");
		ctrlist.setListStyle("listgen");
		ctrlist.setTitleStyle("tableheader");
		ctrlist.setCellStyle("cellStyle");
		ctrlist.setHeaderStyle("tableheader");
		ctrlist.addHeader("Date","6%");
		ctrlist.addHeader("Location Id","6%");
		ctrlist.addHeader("Type","6%");
		ctrlist.addHeader("Price","6%");
		ctrlist.addHeader("Qty","6%");
		ctrlist.addHeader("Total","6%");
		ctrlist.addHeader("In Out","6%");
		ctrlist.addHeader("Adjustment Id","6%");
		ctrlist.addHeader("Transfer In Id","6%");
		ctrlist.addHeader("Item Master Id","6%");
		ctrlist.addHeader("Item Name","6%");
		ctrlist.addHeader("Unit Id","6%");
		ctrlist.addHeader("User Id","6%");
		ctrlist.addHeader("Unit","6%");
		ctrlist.addHeader("Item Barcode","6%");

		ctrlist.setLinkRow(0);
		ctrlist.setLinkSufix("");
		Vector lstData = ctrlist.getData();
		Vector lstLinkData = ctrlist.getLinkData();
		ctrlist.setLinkPrefix("javascript:cmdEdit('");
		ctrlist.setLinkSufix("')");
		ctrlist.reset();
		int index = -1;

		for (int i = 0; i < objectClass.size(); i++) {
			Stock stock = (Stock)objectClass.get(i);
			 Vector rowx = new Vector();
			 if(stockId == stock.getOID())
				 index = i;

			String str_dt_Date = ""; 
			try{
				Date dt_Date = stock.getDate();
				if(dt_Date==null){
					dt_Date = new Date();
				}

				str_dt_Date = Formater.formatDate(dt_Date, "dd MMMM yyyy");
			}catch(Exception e){ str_dt_Date = ""; }

			rowx.add(str_dt_Date);

			rowx.add(String.valueOf(stock.getLocationId()));

			rowx.add(String.valueOf(stock.getType()));

			rowx.add(String.valueOf(stock.getPrice()));

			rowx.add(String.valueOf(stock.getQty()));

			rowx.add(String.valueOf(stock.getTotal()));

			rowx.add(String.valueOf(stock.getInOut()));

			rowx.add(String.valueOf(stock.getAdjustmentId()));

			rowx.add(String.valueOf(stock.getTransferInId()));

			rowx.add(String.valueOf(stock.getItemMasterId()));

			rowx.add(stock.getItemName());

			rowx.add(String.valueOf(stock.getUnitId()));

			rowx.add(String.valueOf(stock.getUserId()));

			rowx.add(stock.getUnit());

			rowx.add(stock.getItemBarcode());

			lstData.add(rowx);
			lstLinkData.add(String.valueOf(stock.getOID()));
		}

		return ctrlist.drawList(index);
	}

%>
<%
int iCommand = FRMQueryString.requestCommand(request);
int start = FRMQueryString.requestInt(request, "start");
int prevCommand = FRMQueryString.requestInt(request, "prev_command");
long oidStock = FRMQueryString.requestLong(request, "hidden_stock_id");

/*variable declaration*/
int recordToGet = 10;
String msgString = "";
int iErrCode = FRMMessage.NONE;
String whereClause = "";
String orderClause = "";

CtrlStock ctrlStock = new CtrlStock(request);
ControlLine ctrLine = new ControlLine();
Vector listStock = new Vector(1,1);

/*switch statement */
iErrCode = ctrlStock.action(iCommand , oidStock);
/* end switch*/
JspStock jspStock = ctrlStock.getForm();

/*count list All Stock*/
int vectSize = PstStock.getCount(whereClause);

Stock stock = ctrlStock.getStock();
msgString =  ctrlStock.getMessage();

/*switch list Stock*/
if((iCommand == Command.SAVE) && (iErrCode == FRMMessage.NONE))
	start = PstStock.generateFindStart(stock.getOID(),recordToGet, whereClause);

if((iCommand == Command.FIRST || iCommand == Command.PREV )||
  (iCommand == Command.NEXT || iCommand == Command.LAST)){
		start = ctrlStock.actionList(iCommand, start, vectSize, recordToGet);
 } 
/* end switch list*/

/* get record to display */
listStock = PstStock.list(start,recordToGet, whereClause , orderClause);

/*handle condition if size of record to display = 0 and start > 0 	after delete*/
if (listStock.size() < 1 && start > 0)
{
	 if (vectSize - recordToGet > recordToGet)
			start = start - recordToGet;   //go to Command.PREV
	 else{
		 start = 0 ;
		 iCommand = Command.FIRST;
		 prevCommand = Command.FIRST; //go to Command.FIRST
	 }
	 listStock = PstStock.list(start,recordToGet, whereClause , orderClause);
}
%>


<html><!-- #BeginTemplate "/Templates/main.dwt" -->
<head>
<!-- #BeginEditable "doctitle" -->
<title>ccs--</title>
<script language="JavaScript">


function cmdAdd(){
	document.frmstock.hidden_stock_id.value="0";
	document.frmstock.command.value="<%=Command.ADD%>";
	document.frmstock.prev_command.value="<%=prevCommand%>";
	document.frmstock.action="stock.jsp";
	document.frmstock.submit();
}

function cmdAsk(oidStock){
	document.frmstock.hidden_stock_id.value=oidStock;
	document.frmstock.command.value="<%=Command.ASK%>";
	document.frmstock.prev_command.value="<%=prevCommand%>";
	document.frmstock.action="stock.jsp";
	document.frmstock.submit();
}

function cmdConfirmDelete(oidStock){
	document.frmstock.hidden_stock_id.value=oidStock;
	document.frmstock.command.value="<%=Command.DELETE%>";
	document.frmstock.prev_command.value="<%=prevCommand%>";
	document.frmstock.action="stock.jsp";
	document.frmstock.submit();
}
function cmdSave(){
	document.frmstock.command.value="<%=Command.SAVE%>";
	document.frmstock.prev_command.value="<%=prevCommand%>";
	document.frmstock.action="stock.jsp";
	document.frmstock.submit();
	}

function cmdEdit(oidStock){
	document.frmstock.hidden_stock_id.value=oidStock;
	document.frmstock.command.value="<%=Command.EDIT%>";
	document.frmstock.prev_command.value="<%=prevCommand%>";
	document.frmstock.action="stock.jsp";
	document.frmstock.submit();
	}

function cmdCancel(oidStock){
	document.frmstock.hidden_stock_id.value=oidStock;
	document.frmstock.command.value="<%=Command.EDIT%>";
	document.frmstock.prev_command.value="<%=prevCommand%>";
	document.frmstock.action="stock.jsp";
	document.frmstock.submit();
}

function cmdBack(){
	document.frmstock.command.value="<%=Command.BACK%>";
	document.frmstock.action="stock.jsp";
	document.frmstock.submit();
	}

function cmdListFirst(){
	document.frmstock.command.value="<%=Command.FIRST%>";
	document.frmstock.prev_command.value="<%=Command.FIRST%>";
	document.frmstock.action="stock.jsp";
	document.frmstock.submit();
}

function cmdListPrev(){
	document.frmstock.command.value="<%=Command.PREV%>";
	document.frmstock.prev_command.value="<%=Command.PREV%>";
	document.frmstock.action="stock.jsp";
	document.frmstock.submit();
	}

function cmdListNext(){
	document.frmstock.command.value="<%=Command.NEXT%>";
	document.frmstock.prev_command.value="<%=Command.NEXT%>";
	document.frmstock.action="stock.jsp";
	document.frmstock.submit();
}

function cmdListLast(){
	document.frmstock.command.value="<%=Command.LAST%>";
	document.frmstock.prev_command.value="<%=Command.LAST%>";
	document.frmstock.action="stock.jsp";
	document.frmstock.submit();
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

						<form name="frmstock" method ="post" action="">
				<input type="hidden" name="command" value="<%=iCommand%>">
				<input type="hidden" name="vectSize" value="<%=vectSize%>">
				<input type="hidden" name="start" value="<%=start%>">
				<input type="hidden" name="prev_command" value="<%=prevCommand%>">
				<input type="hidden" name="hidden_stock_id" value="<%=oidStock%>">
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
						      <td height="14" valign="middle" colspan="3" class="comment">&nbsp;Stock
						       List </td>
						  </tr>
						  <%
							try{
								if (listStock.size()>0){
							%>
						  <tr align="left" valign="top">
						        <td height="22" valign="middle" colspan="3"> <%= drawList(listStock,oidStock)%> </td>
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
							 <%if((iCommand ==Command.ADD)||(iCommand==Command.SAVE)&&(jspStock.errorSize()>0)||(iCommand==Command.EDIT)||(iCommand==Command.ASK)){%>
								 <table width="100%" border="0" cellspacing="1" cellpadding="0">
					      <tr align="left" valign="top">
					         <td height="21" valign="middle" width="17%">&nbsp;</td>
					         <td height="21" colspan="2" width="83%" class="comment">*)= required</td>
					      </tr>
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Location Id</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspStock.fieldNames[JspStock.FRM_FIELD_LOCATION_ID] %>"  value="<%= stock.getLocationId() %>" class="formElemen">
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Type</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspStock.fieldNames[JspStock.FRM_FIELD_TYPE] %>"  value="<%= stock.getType() %>" class="formElemen">
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Qty</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspStock.fieldNames[JspStock.FRM_FIELD_QTY] %>"  value="<%= stock.getQty() %>" class="formElemen">
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Price</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspStock.fieldNames[JspStock.FRM_FIELD_PRICE] %>"  value="<%= stock.getPrice() %>" class="formElemen">
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Total</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspStock.fieldNames[JspStock.FRM_FIELD_TOTAL] %>"  value="<%= stock.getTotal() %>" class="formElemen">
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Item Master Id</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspStock.fieldNames[JspStock.FRM_FIELD_ITEM_MASTER_ID] %>"  value="<%= stock.getItemMasterId() %>" class="formElemen">
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Item Code</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspStock.fieldNames[JspStock.FRM_FIELD_ITEM_CODE] %>"  value="<%= stock.getItemCode() %>" class="formElemen">
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Item Barcode</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspStock.fieldNames[JspStock.FRM_FIELD_ITEM_BARCODE] %>"  value="<%= stock.getItemBarcode() %>" class="formElemen">
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Item Name</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspStock.fieldNames[JspStock.FRM_FIELD_ITEM_NAME] %>"  value="<%= stock.getItemName() %>" class="formElemen">
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Unit Id</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspStock.fieldNames[JspStock.FRM_FIELD_UNIT_ID] %>"  value="<%= stock.getUnitId() %>" class="formElemen">
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Unit</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspStock.fieldNames[JspStock.FRM_FIELD_UNIT] %>"  value="<%= stock.getUnit() %>" class="formElemen">
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">In Out</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspStock.fieldNames[JspStock.FRM_FIELD_IN_OUT] %>"  value="<%= stock.getInOut() %>" class="formElemen">
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Date</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspStock.fieldNames[JspStock.FRM_FIELD_DATE] %>"  value="<%= stock.getDate() %>" class="formElemen">
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">User Id</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspStock.fieldNames[JspStock.FRM_FIELD_USER_ID] %>"  value="<%= stock.getUserId() %>" class="formElemen">
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">No Faktur</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspStock.fieldNames[JspStock.FRM_FIELD_NO_FAKTUR] %>"  value="<%= stock.getNoFaktur() %>" class="formElemen">
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Incoming Id</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspStock.fieldNames[JspStock.FRM_FIELD_INCOMING_ID] %>"  value="<%= stock.getIncomingId() %>" class="formElemen">
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Retur Id</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspStock.fieldNames[JspStock.FRM_FIELD_RETUR_ID] %>"  value="<%= stock.getReturId() %>" class="formElemen">
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Transfer Id</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspStock.fieldNames[JspStock.FRM_FIELD_TRANSFER_ID] %>"  value="<%= stock.getTransferId() %>" class="formElemen">
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Transfer In Id</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspStock.fieldNames[JspStock.FRM_FIELD_TRANSFER_IN_ID] %>"  value="<%= stock.getTransferInId() %>" class="formElemen">
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Adjustment Id</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspStock.fieldNames[JspStock.FRM_FIELD_ADJUSTMENT_ID] %>"  value="<%= stock.getAdjustmentId() %>" class="formElemen">
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
									String scomDel = "javascript:cmdAsk('"+oidStock+"')";
									String sconDelCom = "javascript:cmdConfirmDelete('"+oidStock+"')";
									String scancel = "javascript:cmdEdit('"+oidStock+"')";
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
