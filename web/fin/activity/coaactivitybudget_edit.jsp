<% 
/* 
 * Page Name  		:  coaactivitybudget_edit.jsp
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
<%@ page import = "com.dimata.finance.entity.activity.*" %>
<%@ page import = "com.dimata.finance.form.activity.*" %>
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

<%

	CtrlCoaActivityBudget ctrlCoaActivityBudget = new CtrlCoaActivityBudget(request);
	long oidCoaActivityBudget = FRMQueryString.requestLong(request, "hidden_coa_activity_budget_id");

	int iErrCode = FRMMessage.ERR_NONE;
	String errMsg = "";
	String whereClause = "";
	String orderClause = "";
	int iCommand = FRMQueryString.requestCommand(request);
	int start = FRMQueryString.requestInt(request,"start");

	//out.println("iCommand : "+iCommand);
	ControlLine ctrLine = new ControlLine();

	iErrCode = ctrlCoaActivityBudget.action(iCommand , oidCoaActivityBudget);

	errMsg = ctrlCoaActivityBudget.getMessage();
	JspCoaActivityBudget jspCoaActivityBudget = ctrlCoaActivityBudget.getForm();
	CoaActivityBudget coaActivityBudget = ctrlCoaActivityBudget.getCoaActivityBudget();
	oidCoaActivityBudget = coaActivityBudget.getOID();

	if(((iCommand==Command.SAVE)||(iCommand==Command.DELETE))&&(jspCoaActivityBudget.errorSize()<1)){
	%>
		<jsp:forward page="coaactivitybudget_list.jsp">
		<jsp:param name="start" value="<%=start%>" />
		<jsp:param name="hidden_coa_activity_budget_id" value="<%=coaActivityBudget.getOID()%>" />
		</jsp:forward>
	<%
	}

%>

<!-- End of Jsp Block -->


<html><!-- #BeginTemplate "/Templates/main.dwt" -->
<head>
<!-- #BeginEditable "doctitle" -->
<title>finance--</title>
<script language="JavaScript">

	function cmdCancel(){
		document.frm_coaactivitybudget.command.value="<%=Command.ADD%>";
		document.frm_coaactivitybudget.action="coaactivitybudget_edit.jsp";
		document.frm_coaactivitybudget.submit();
	} 
	function cmdCancel(){
		document.frm_coaactivitybudget.command.value="<%=Command.CANCEL%>";
		document.frm_coaactivitybudget.action="coaactivitybudget_edit.jsp";
		document.frm_coaactivitybudget.submit();
	} 

	function cmdEdit(oid){ 
		document.frm_coaactivitybudget.command.value="<%=Command.EDIT%>";
		document.frm_coaactivitybudget.action="coaactivitybudget_edit.jsp";
		document.frm_coaactivitybudget.submit(); 
	} 

	function cmdSave(){
		document.frm_coaactivitybudget.command.value="<%=Command.SAVE%>"; 
		document.frm_coaactivitybudget.action="coaactivitybudget_edit.jsp";
		document.frm_coaactivitybudget.submit();
	}

	function cmdAsk(oid){
		document.frm_coaactivitybudget.command.value="<%=Command.ASK%>"; 
		document.frm_coaactivitybudget.action="coaactivitybudget_edit.jsp";
		document.frm_coaactivitybudget.submit();
	} 

	function cmdConfirmDelete(oid){
		document.frm_coaactivitybudget.command.value="<%=Command.DELETE%>";
		document.frm_coaactivitybudget.action="coaactivitybudget_edit.jsp"; 
		document.frm_coaactivitybudget.submit();
	}  

	function cmdBack(){
		document.frm_coaactivitybudget.command.value="<%=Command.FIRST%>"; 
		document.frm_coaactivitybudget.action="coaactivitybudget_edit.jsp";
		document.frm_coaactivitybudget.submit();
	}

//-------------- script form image -------------------

	function cmdDelPic(oid){
		document.frm_coaactivitybudget.command.value="<%=Command.POST%>"; 
		document.frm_coaactivitybudget.action="coaactivitybudget_edit.jsp";
		document.frm_coaactivitybudget.submit();
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

					<form name="frm_coaactivitybudget" method="post" action="">
					<input type="hidden" name="command" value="">
					<input type="hidden" name="start" value="<%=start%>">
					<input type="hidden" name="hidden_coa_activity_budget_id" value="<%=oidCoaActivityBudget%>">
					<table width="100%" cellspacing="0" cellpadding="0" >
						<tr>
							<td colspan="3"><hr></td>
						</tr>
						<tr>
							<td width="4%">&nbsp;</td>
							<td colspan="2" class="txtheading1">*) entry required</td>
						</tr>
						<tr>
							<td width="4%">&nbsp;</td>
							<td width="29%">&nbsp;</td>
							<td width="67%">&nbsp;</td>
						</tr>
						<tr align="left">
							<td width="4%"  valign="top"  >&nbsp;</td>
							<td width="29%"  valign="top"  >Type</td>
							<td  width="67%"  valign="top">
								<input type="text" name="<%=JspCoaActivityBudget.fieldNames[JspCoaActivityBudget.FRM_FIELD_TYPE]%>" value="<%=coaActivityBudget.getType()%>" class="formElemen"><%=jspCoaActivityBudget.getErrorMsg(JspCoaActivityBudget.FRM_FIELD_TYPE)%></td>
						</tr>
						<tr align="left">
							<td width="4%"  valign="top"  >&nbsp;</td>
							<td width="29%"  valign="top"  >Coa Id</td>
							<td  width="67%"  valign="top">
								<input type="text" name="<%=JspCoaActivityBudget.fieldNames[JspCoaActivityBudget.FRM_FIELD_COA_ID]%>" value="<%=coaActivityBudget.getCoaId()%>" class="formElemen"><%=jspCoaActivityBudget.getErrorMsg(JspCoaActivityBudget.FRM_FIELD_COA_ID)%></td>
						</tr>
						<tr align="left">
							<td width="4%"  valign="top"  >&nbsp;</td>
							<td width="29%"  valign="top"  >Admin Percent</td>
							<td  width="67%"  valign="top">
								<input type="text" name="<%=JspCoaActivityBudget.fieldNames[JspCoaActivityBudget.FRM_FIELD_ADMIN_PERCENT]%>" value="<%=coaActivityBudget.getAdminPercent()%>" class="formElemen"><%=jspCoaActivityBudget.getErrorMsg(JspCoaActivityBudget.FRM_FIELD_ADMIN_PERCENT)%></td>
						</tr>
						<tr align="left">
							<td width="4%"  valign="top"  >&nbsp;</td>
							<td width="29%"  valign="top"  >Logistic Percent</td>
							<td  width="67%"  valign="top">
								<input type="text" name="<%=JspCoaActivityBudget.fieldNames[JspCoaActivityBudget.FRM_FIELD_LOGISTIC_PERCENT]%>" value="<%=coaActivityBudget.getLogisticPercent()%>" class="formElemen"><%=jspCoaActivityBudget.getErrorMsg(JspCoaActivityBudget.FRM_FIELD_LOGISTIC_PERCENT)%></td>
						</tr>
						<tr align="left">
							<td width="4%"  valign="top"  >&nbsp;</td>
							<td width="29%"  valign="top"  >Memo</td>
							<td  width="67%"  valign="top">
								<input type="text" name="<%=JspCoaActivityBudget.fieldNames[JspCoaActivityBudget.FRM_FIELD_MEMO]%>" value="<%=coaActivityBudget.getMemo()%>" class="formElemen"><%=jspCoaActivityBudget.getErrorMsg(JspCoaActivityBudget.FRM_FIELD_MEMO)%></td>
						</tr>
						<tr align="left">
							<td width="4%"  valign="top"  >&nbsp;</td>
							<td width="29%"  valign="top"  >&nbsp;</td>
							<td  width="67%"  valign="top">&nbsp;</td>
						</tr>
						<tr>
							<td colspan="3">&nbsp;</td>
						</tr>
						<tr align="left">
							<td colspan="3">
							<%
							ctrLine.setLocationImg(approot+"/images/ctr_line");
							ctrLine.initDefault();
							ctrLine.setTableWidth("80%");
							String scomDel = "javascript:cmdAsk('"+oidCoaActivityBudget+"')";
							String sconDelCom = "javascript:cmdConfirmDelete('"+oidCoaActivityBudget+"')";
							String scancel = "javascript:cmdEdit('"+oidCoaActivityBudget+"')";
							ctrLine.setBackCaption("Back to List");
								ctrLine.setDeleteCaption("Delete");
								ctrLine.setSaveCaption("Save");
								ctrLine.setAddCaption("");
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
						<%= ctrLine.drawImage(iCommand, iErrCode, errMsg)%>
							</td>
						</tr>
						<tr>
							<td colspan="3">&nbsp;</td>
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
