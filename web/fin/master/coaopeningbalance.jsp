<% 
/* 
 * Page Name  		:  coaopeningbalance.jsp
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
<%@ page import = "com.dimata.finance.entity.master.*" %>
<%@ page import = "com.dimata.finance.form.master.*" %>
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

	public String drawList(int iCommand,JspCoaOpeningBalance frmObject, CoaOpeningBalance objEntity, Vector objectClass,  long coaOpeningBalanceId)

	{
		ControlList ctrlist = new ControlList();
		ctrlist.setAreaWidth("100%");
		ctrlist.setListStyle("listgen");
		ctrlist.setTitleStyle("tableheader");
		ctrlist.setCellStyle("cellStyle");
		ctrlist.setHeaderStyle("tableheader");
		ctrlist.addHeader("Coa Id","33%");
		ctrlist.addHeader("Periode Id","33%");
		ctrlist.addHeader("Opening Balance","33%");

		ctrlist.setLinkRow(0);
		ctrlist.setLinkSufix("");
		Vector lstData = ctrlist.getData();
		Vector lstLinkData = ctrlist.getLinkData();
		Vector rowx = new Vector(1,1);
		ctrlist.reset();
		int index = -1;

		for (int i = 0; i < objectClass.size(); i++) {
			 CoaOpeningBalance coaOpeningBalance = (CoaOpeningBalance)objectClass.get(i);
			 rowx = new Vector();
			 if(coaOpeningBalanceId == coaOpeningBalance.getOID())
				 index = i; 

			 if(index == i && (iCommand == Command.EDIT || iCommand == Command.ASK)){
					
				rowx.add("<input type=\"text\" name=\""+frmObject.fieldNames[JspCoaOpeningBalance.FRM_FIELD_COA_ID] +"\" value=\""+coaOpeningBalance.getCoaId()+"\" class=\"formElemen\">");
				rowx.add("<input type=\"text\" name=\""+frmObject.fieldNames[JspCoaOpeningBalance.FRM_FIELD_PERIODE_ID] +"\" value=\""+coaOpeningBalance.getPeriodeId()+"\" class=\"formElemen\">");
				rowx.add("<input type=\"text\" name=\""+frmObject.fieldNames[JspCoaOpeningBalance.FRM_FIELD_OPENING_BALANCE] +"\" value=\""+coaOpeningBalance.getOpeningBalance()+"\" class=\"formElemen\">");
			}else{
				rowx.add("<a href=\"javascript:cmdEdit('"+String.valueOf(coaOpeningBalance.getOID())+"')\">"+String.valueOf(coaOpeningBalance.getCoaId())+"</a>");
				rowx.add(String.valueOf(coaOpeningBalance.getPeriodeId()));
				rowx.add(String.valueOf(coaOpeningBalance.getOpeningBalance()));
			} 

			lstData.add(rowx);
		}

		 rowx = new Vector();

		if(iCommand == Command.ADD || (iCommand == Command.SAVE && frmObject.errorSize() > 0)){ 
				rowx.add("<input type=\"text\" name=\""+frmObject.fieldNames[JspCoaOpeningBalance.FRM_FIELD_COA_ID] +"\" value=\""+objEntity.getCoaId()+"\" class=\"formElemen\">");
				rowx.add("<input type=\"text\" name=\""+frmObject.fieldNames[JspCoaOpeningBalance.FRM_FIELD_PERIODE_ID] +"\" value=\""+objEntity.getPeriodeId()+"\" class=\"formElemen\">");
				rowx.add("<input type=\"text\" name=\""+frmObject.fieldNames[JspCoaOpeningBalance.FRM_FIELD_OPENING_BALANCE] +"\" value=\""+objEntity.getOpeningBalance()+"\" class=\"formElemen\">");

		}

		lstData.add(rowx);

		return ctrlist.draw();
	}

%>
<%
int iCommand = FRMQueryString.requestCommand(request);
int start = FRMQueryString.requestInt(request, "start");
int prevCommand = FRMQueryString.requestInt(request, "prev_command");
long oidCoaOpeningBalance = FRMQueryString.requestLong(request, "hidden_coa_opening_balance_id");

/*variable declaration*/
int recordToGet = 10;
String msgString = "";
int iErrCode = FRMMessage.NONE;
String whereClause = "";
String orderClause = "";

CtrlCoaOpeningBalance ctrlCoaOpeningBalance = new CtrlCoaOpeningBalance(request);
ControlLine ctrLine = new ControlLine();
Vector listCoaOpeningBalance = new Vector(1,1);

/*switch statement */
iErrCode = ctrlCoaOpeningBalance.action(iCommand , oidCoaOpeningBalance);
/* end switch*/
JspCoaOpeningBalance jspCoaOpeningBalance = ctrlCoaOpeningBalance.getForm();

/*count list All CoaOpeningBalance*/
int vectSize = PstCoaOpeningBalance.getCount(whereClause);

/*switch list CoaOpeningBalance*/
if((iCommand == Command.FIRST || iCommand == Command.PREV )||
  (iCommand == Command.NEXT || iCommand == Command.LAST)){
		start = ctrlCoaOpeningBalance.actionList(iCommand, start, vectSize, recordToGet);
 } 
/* end switch list*/

CoaOpeningBalance coaOpeningBalance = ctrlCoaOpeningBalance.getCoaOpeningBalance();
msgString =  ctrlCoaOpeningBalance.getMessage();

/* get record to display */
listCoaOpeningBalance = PstCoaOpeningBalance.list(start,recordToGet, whereClause , orderClause);

/*handle condition if size of record to display = 0 and start > 0 	after delete*/
if (listCoaOpeningBalance.size() < 1 && start > 0)
{
	 if (vectSize - recordToGet > recordToGet)
			start = start - recordToGet;   //go to Command.PREV
	 else{
		 start = 0 ;
		 iCommand = Command.FIRST;
		 prevCommand = Command.FIRST; //go to Command.FIRST
	 }
	 listCoaOpeningBalance = PstCoaOpeningBalance.list(start,recordToGet, whereClause , orderClause);
}
%>


<html><!-- #BeginTemplate "/Templates/main.dwt" -->
<head>
<!-- #BeginEditable "doctitle" -->
<title>finance--</title>
<script language="JavaScript">

<%if(!masterPriv){%>
	window.location="<%=approot%>/nopriv.jsp";
<%}%>

function cmdAdd(){
	document.frmcoaopeningbalance.hidden_coa_opening_balance_id.value="0";
	document.frmcoaopeningbalance.command.value="<%=Command.ADD%>";
	document.frmcoaopeningbalance.prev_command.value="<%=prevCommand%>";
	document.frmcoaopeningbalance.action="coaopeningbalance.jsp";
	document.frmcoaopeningbalance.submit();
}

function cmdAsk(oidCoaOpeningBalance){
	document.frmcoaopeningbalance.hidden_coa_opening_balance_id.value=oidCoaOpeningBalance;
	document.frmcoaopeningbalance.command.value="<%=Command.ASK%>";
	document.frmcoaopeningbalance.prev_command.value="<%=prevCommand%>";
	document.frmcoaopeningbalance.action="coaopeningbalance.jsp";
	document.frmcoaopeningbalance.submit();
}

function cmdConfirmDelete(oidCoaOpeningBalance){
	document.frmcoaopeningbalance.hidden_coa_opening_balance_id.value=oidCoaOpeningBalance;
	document.frmcoaopeningbalance.command.value="<%=Command.DELETE%>";
	document.frmcoaopeningbalance.prev_command.value="<%=prevCommand%>";
	document.frmcoaopeningbalance.action="coaopeningbalance.jsp";
	document.frmcoaopeningbalance.submit();
}

function cmdSave(){
	document.frmcoaopeningbalance.command.value="<%=Command.SAVE%>";
	document.frmcoaopeningbalance.prev_command.value="<%=prevCommand%>";
	document.frmcoaopeningbalance.action="coaopeningbalance.jsp";
	document.frmcoaopeningbalance.submit();
}

function cmdEdit(oidCoaOpeningBalance){
	document.frmcoaopeningbalance.hidden_coa_opening_balance_id.value=oidCoaOpeningBalance;
	document.frmcoaopeningbalance.command.value="<%=Command.EDIT%>";
	document.frmcoaopeningbalance.prev_command.value="<%=prevCommand%>";
	document.frmcoaopeningbalance.action="coaopeningbalance.jsp";
	document.frmcoaopeningbalance.submit();
}

function cmdCancel(oidCoaOpeningBalance){
	document.frmcoaopeningbalance.hidden_coa_opening_balance_id.value=oidCoaOpeningBalance;
	document.frmcoaopeningbalance.command.value="<%=Command.EDIT%>";
	document.frmcoaopeningbalance.prev_command.value="<%=prevCommand%>";
	document.frmcoaopeningbalance.action="coaopeningbalance.jsp";
	document.frmcoaopeningbalance.submit();
}

function cmdBack(){
	document.frmcoaopeningbalance.command.value="<%=Command.BACK%>";
	document.frmcoaopeningbalance.action="coaopeningbalance.jsp";
	document.frmcoaopeningbalance.submit();
}

function cmdListFirst(){
	document.frmcoaopeningbalance.command.value="<%=Command.FIRST%>";
	document.frmcoaopeningbalance.prev_command.value="<%=Command.FIRST%>";
	document.frmcoaopeningbalance.action="coaopeningbalance.jsp";
	document.frmcoaopeningbalance.submit();
}

function cmdListPrev(){
	document.frmcoaopeningbalance.command.value="<%=Command.PREV%>";
	document.frmcoaopeningbalance.prev_command.value="<%=Command.PREV%>";
	document.frmcoaopeningbalance.action="coaopeningbalance.jsp";
	document.frmcoaopeningbalance.submit();
}

function cmdListNext(){
	document.frmcoaopeningbalance.command.value="<%=Command.NEXT%>";
	document.frmcoaopeningbalance.prev_command.value="<%=Command.NEXT%>";
	document.frmcoaopeningbalance.action="coaopeningbalance.jsp";
	document.frmcoaopeningbalance.submit();
}

function cmdListLast(){
	document.frmcoaopeningbalance.command.value="<%=Command.LAST%>";
	document.frmcoaopeningbalance.prev_command.value="<%=Command.LAST%>";
	document.frmcoaopeningbalance.action="coaopeningbalance.jsp";
	document.frmcoaopeningbalance.submit();
}

//-------------- script form image -------------------

function cmdDelPict(oidCoaOpeningBalance){
	document.frmimage.hidden_coa_opening_balance_id.value=oidCoaOpeningBalance;
	document.frmimage.command.value="<%=Command.POST%>";
	document.frmimage.action="coaopeningbalance.jsp";
	document.frmimage.submit();
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

						<form name="frmcoaopeningbalance" method ="post" action="">
				<input type="hidden" name="command" value="<%=iCommand%>">
				<input type="hidden" name="vectSize" value="<%=vectSize%>">
				<input type="hidden" name="start" value="<%=start%>">
				<input type="hidden" name="prev_command" value="<%=prevCommand%>">
				<input type="hidden" name="hidden_coa_opening_balance_id" value="<%=oidCoaOpeningBalance%>">
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
						      <td height="14" valign="middle" colspan="3" class="comment">&nbsp;CoaOpeningBalance
						       List </td>
						  </tr>
						  <%
							try{
							%>
						  <tr align="left" valign="top">
						        <td height="22" valign="middle" colspan="3"> <%= drawList(iCommand,jspCoaOpeningBalance, coaOpeningBalance,listCoaOpeningBalance,oidCoaOpeningBalance)%> </td>
						  </tr>
						  <% 
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
								   <td height="8" valign="middle" width="17%">&nbsp;</td>
								   <td height="8" colspan="2" width="83%">&nbsp; </td>
								 </tr>
								 <tr align="left" valign="top" >
								   <td colspan="3" class="command">
									<%
									ctrLine.setLocationImg(approot+"/images/ctr_line");
									ctrLine.initDefault();
									ctrLine.setTableWidth("80%");
									String scomDel = "javascript:cmdAsk('"+oidCoaOpeningBalance+"')";
									String sconDelCom = "javascript:cmdConfirmDelete('"+oidCoaOpeningBalance+"')";
									String scancel = "javascript:cmdEdit('"+oidCoaOpeningBalance+"')";
									ctrLine.setBackCaption("Back to List");
									ctrLine.setCommandStyle("buttonlink");

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
