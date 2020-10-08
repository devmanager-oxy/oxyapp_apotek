<% 
/* 
 * Page Name  		:  opname.jsp
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

	public String drawList(Vector objectClass ,  long opnameId)

	{
		ControlList ctrlist = new ControlList();
		ctrlist.setAreaWidth("100%");
		ctrlist.setListStyle("listgen");
		ctrlist.setTitleStyle("tableheader");
		ctrlist.setCellStyle("cellStyle");
		ctrlist.setHeaderStyle("tableheader");
		ctrlist.addHeader("Counter","11%");
		ctrlist.addHeader("Number","11%");
		ctrlist.addHeader("Date","11%");
		ctrlist.addHeader("Status","11%");
		ctrlist.addHeader("Note","11%");
		ctrlist.addHeader("Approval 1","11%");
		ctrlist.addHeader("Approval 2","11%");
		ctrlist.addHeader("Approval 3","11%");
		ctrlist.addHeader("User Id","11%");

		ctrlist.setLinkRow(0);
		ctrlist.setLinkSufix("");
		Vector lstData = ctrlist.getData();
		Vector lstLinkData = ctrlist.getLinkData();
		ctrlist.setLinkPrefix("javascript:cmdEdit('");
		ctrlist.setLinkSufix("')");
		ctrlist.reset();
		int index = -1;

		for (int i = 0; i < objectClass.size(); i++) {
			Opname opname = (Opname)objectClass.get(i);
			 Vector rowx = new Vector();
			 if(opnameId == opname.getOID())
				 index = i;

			rowx.add(String.valueOf(opname.getCounter()));

			rowx.add(String.valueOf(opname.getNumber()));

			String str_dt_Date = ""; 
			try{
				Date dt_Date = opname.getDate();
				if(dt_Date==null){
					dt_Date = new Date();
				}

				str_dt_Date = Formater.formatDate(dt_Date, "dd MMMM yyyy");
			}catch(Exception e){ str_dt_Date = ""; }

			rowx.add(str_dt_Date);

			rowx.add(opname.getStatus());

			rowx.add(opname.getNote());

			rowx.add(String.valueOf(opname.getApproval1()));

			rowx.add(String.valueOf(opname.getApproval2()));

			rowx.add(String.valueOf(opname.getApproval3()));

			rowx.add(String.valueOf(opname.getUserId()));

			lstData.add(rowx);
			lstLinkData.add(String.valueOf(opname.getOID()));
		}

		return ctrlist.drawList(index);
	}

%>
<%
int iCommand = FRMQueryString.requestCommand(request);
int start = FRMQueryString.requestInt(request, "start");
int prevCommand = FRMQueryString.requestInt(request, "prev_command");
long oidOpname = FRMQueryString.requestLong(request, "hidden_opname_id");

/*variable declaration*/
int recordToGet = 10;
String msgString = "";
int iErrCode = FRMMessage.NONE;
String whereClause = "";
String orderClause = "";

CtrlOpname ctrlOpname = new CtrlOpname(request);
ControlLine ctrLine = new ControlLine();
Vector listOpname = new Vector(1,1);

/*switch statement */
iErrCode = ctrlOpname.action(iCommand , oidOpname);
/* end switch*/
JspOpname jspOpname = ctrlOpname.getForm();

/*count list All Opname*/
int vectSize = PstOpname.getCount(whereClause);

Opname opname = ctrlOpname.getOpname();
msgString =  ctrlOpname.getMessage();

/*switch list Opname*/
if((iCommand == Command.SAVE) && (iErrCode == FRMMessage.NONE))
	start = PstOpname.generateFindStart(opname.getOID(),recordToGet, whereClause);

if((iCommand == Command.FIRST || iCommand == Command.PREV )||
  (iCommand == Command.NEXT || iCommand == Command.LAST)){
		start = ctrlOpname.actionList(iCommand, start, vectSize, recordToGet);
 } 
/* end switch list*/

/* get record to display */
listOpname = PstOpname.list(start,recordToGet, whereClause , orderClause);

/*handle condition if size of record to display = 0 and start > 0 	after delete*/
if (listOpname.size() < 1 && start > 0)
{
	 if (vectSize - recordToGet > recordToGet)
			start = start - recordToGet;   //go to Command.PREV
	 else{
		 start = 0 ;
		 iCommand = Command.FIRST;
		 prevCommand = Command.FIRST; //go to Command.FIRST
	 }
	 listOpname = PstOpname.list(start,recordToGet, whereClause , orderClause);
}
%>


<html><!-- #BeginTemplate "/Templates/main.dwt" -->
<head>
<!-- #BeginEditable "doctitle" -->
<title>ccs--</title>
<script language="JavaScript">


function cmdAdd(){
	document.frmopname.hidden_opname_id.value="0";
	document.frmopname.command.value="<%=Command.ADD%>";
	document.frmopname.prev_command.value="<%=prevCommand%>";
	document.frmopname.action="opname.jsp";
	document.frmopname.submit();
}

function cmdAsk(oidOpname){
	document.frmopname.hidden_opname_id.value=oidOpname;
	document.frmopname.command.value="<%=Command.ASK%>";
	document.frmopname.prev_command.value="<%=prevCommand%>";
	document.frmopname.action="opname.jsp";
	document.frmopname.submit();
}

function cmdConfirmDelete(oidOpname){
	document.frmopname.hidden_opname_id.value=oidOpname;
	document.frmopname.command.value="<%=Command.DELETE%>";
	document.frmopname.prev_command.value="<%=prevCommand%>";
	document.frmopname.action="opname.jsp";
	document.frmopname.submit();
}
function cmdSave(){
	document.frmopname.command.value="<%=Command.SAVE%>";
	document.frmopname.prev_command.value="<%=prevCommand%>";
	document.frmopname.action="opname.jsp";
	document.frmopname.submit();
	}

function cmdEdit(oidOpname){
	document.frmopname.hidden_opname_id.value=oidOpname;
	document.frmopname.command.value="<%=Command.EDIT%>";
	document.frmopname.prev_command.value="<%=prevCommand%>";
	document.frmopname.action="opname.jsp";
	document.frmopname.submit();
	}

function cmdCancel(oidOpname){
	document.frmopname.hidden_opname_id.value=oidOpname;
	document.frmopname.command.value="<%=Command.EDIT%>";
	document.frmopname.prev_command.value="<%=prevCommand%>";
	document.frmopname.action="opname.jsp";
	document.frmopname.submit();
}

function cmdBack(){
	document.frmopname.command.value="<%=Command.BACK%>";
	document.frmopname.action="opname.jsp";
	document.frmopname.submit();
	}

function cmdListFirst(){
	document.frmopname.command.value="<%=Command.FIRST%>";
	document.frmopname.prev_command.value="<%=Command.FIRST%>";
	document.frmopname.action="opname.jsp";
	document.frmopname.submit();
}

function cmdListPrev(){
	document.frmopname.command.value="<%=Command.PREV%>";
	document.frmopname.prev_command.value="<%=Command.PREV%>";
	document.frmopname.action="opname.jsp";
	document.frmopname.submit();
	}

function cmdListNext(){
	document.frmopname.command.value="<%=Command.NEXT%>";
	document.frmopname.prev_command.value="<%=Command.NEXT%>";
	document.frmopname.action="opname.jsp";
	document.frmopname.submit();
}

function cmdListLast(){
	document.frmopname.command.value="<%=Command.LAST%>";
	document.frmopname.prev_command.value="<%=Command.LAST%>";
	document.frmopname.action="opname.jsp";
	document.frmopname.submit();
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

						<form name="frmopname" method ="post" action="">
				<input type="hidden" name="command" value="<%=iCommand%>">
				<input type="hidden" name="vectSize" value="<%=vectSize%>">
				<input type="hidden" name="start" value="<%=start%>">
				<input type="hidden" name="prev_command" value="<%=prevCommand%>">
				<input type="hidden" name="hidden_opname_id" value="<%=oidOpname%>">
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
						      <td height="14" valign="middle" colspan="3" class="comment">&nbsp;Opname
						       List </td>
						  </tr>
						  <%
							try{
								if (listOpname.size()>0){
							%>
						  <tr align="left" valign="top">
						        <td height="22" valign="middle" colspan="3"> <%= drawList(listOpname,oidOpname)%> </td>
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
							 <%if((iCommand ==Command.ADD)||(iCommand==Command.SAVE)&&(jspOpname.errorSize()>0)||(iCommand==Command.EDIT)||(iCommand==Command.ASK)){%>
								 <table width="100%" border="0" cellspacing="1" cellpadding="0">
					      <tr align="left" valign="top">
					         <td height="21" valign="middle" width="17%">&nbsp;</td>
					         <td height="21" colspan="2" width="83%" class="comment">*)= required</td>
					      </tr>
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Counter</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspOpname.fieldNames[JspOpname.FRM_FIELD_COUNTER] %>"  value="<%= opname.getCounter() %>" class="formElemen">
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Number</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspOpname.fieldNames[JspOpname.FRM_FIELD_NUMBER] %>"  value="<%= opname.getNumber() %>" class="formElemen">
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Date</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspOpname.fieldNames[JspOpname.FRM_FIELD_DATE] %>"  value="<%= opname.getDate() %>" class="formElemen">
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Status</td>
					       <td height="21" colspan="2" width="83%">
					   <% Vector status_value = new Vector(1,1);
						Vector status_key = new Vector(1,1);
					 	String sel_status = ""+opname.getStatus();
					   status_key.add("---select---");
					   status_value.add("");
					   %>
						<%= ControlCombo.draw(jspOpname.fieldNames[JspOpname.FRM_FIELD_STATUS],null, sel_status, status_key, status_value, "", "formElemen") %>
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Note</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspOpname.fieldNames[JspOpname.FRM_FIELD_NOTE] %>"  value="<%= opname.getNote() %>" class="formElemen">
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Approval 1</td>
					       <td height="21" colspan="2" width="83%">
					   <% Vector approval1_value = new Vector(1,1);
						Vector approval1_key = new Vector(1,1);
					 	String sel_approval1 = ""+opname.getApproval1();
					   approval1_key.add("---select---");
					   approval1_value.add("");
					   %>
						<%= ControlCombo.draw(jspOpname.fieldNames[JspOpname.FRM_FIELD_APPROVAL_1],null, sel_approval1, approval1_key, approval1_value, "", "formElemen") %>
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Approval 2</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspOpname.fieldNames[JspOpname.FRM_FIELD_APPROVAL_2] %>"  value="<%= opname.getApproval2() %>" class="formElemen">
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Approval 3</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspOpname.fieldNames[JspOpname.FRM_FIELD_APPROVAL_3] %>"  value="<%= opname.getApproval3() %>" class="formElemen">
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">User Id</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspOpname.fieldNames[JspOpname.FRM_FIELD_USER_ID] %>"  value="<%= opname.getUserId() %>" class="formElemen">
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
									String scomDel = "javascript:cmdAsk('"+oidOpname+"')";
									String sconDelCom = "javascript:cmdConfirmDelete('"+oidOpname+"')";
									String scancel = "javascript:cmdEdit('"+oidOpname+"')";
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
