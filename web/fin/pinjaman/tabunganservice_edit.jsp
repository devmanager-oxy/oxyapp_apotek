<% 
/* 
 * Page Name  		:  tabunganservice_edit.jsp
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

<!--package sipadu -->
<%@ page import = "com.dimata.sipadu.entity.pinjaman.*" %>
<%@ page import = "com.dimata.sipadu.form.pinjaman.*" %>
<%@ page import = "com.dimata.sipadu.entity.admin.*" %>
<%@ include file = "::...error, can't generate level, level = 0..::main/javainit.jsp" %>

<% int  appObjCode = 1;// AppObjInfo.composeObjCode(AppObjInfo.--, AppObjInfo.--, AppObjInfo.--); %>
<%//@ include file = "::...error, can't generate level, level = 0..::main/checkuser.jsp" %>
<%
/* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
boolean privAdd=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ADD));
boolean privUpdate=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_UPDATE));
boolean privDelete=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_DELETE));
%>

<!-- Jsp Block -->

<%

	CtrlTabunganService ctrlTabunganService = new CtrlTabunganService(request);
	long oidTabunganService = FRMQueryString.requestLong(request, "hidden_tabungan_service_id");

	int iErrCode = FRMMessage.ERR_NONE;
	String errMsg = "";
	String whereClause = "";
	String orderClause = "";
	int iCommand = FRMQueryString.requestCommand(request);
	int start = FRMQueryString.requestInt(request,"start");

	//out.println("iCommand : "+iCommand);
	ControlLine ctrLine = new ControlLine();

	iErrCode = ctrlTabunganService.action(iCommand , oidTabunganService);

	errMsg = ctrlTabunganService.getMessage();
	JspTabunganService jspTabunganService = ctrlTabunganService.getForm();
	TabunganService tabunganService = ctrlTabunganService.getTabunganService();
	oidTabunganService = tabunganService.getOID();

	if(((iCommand==Command.SAVE)||(iCommand==Command.DELETE))&&(jspTabunganService.errorSize()<1)){
	%>
		<jsp:forward page="tabunganservice_list.jsp">
		<jsp:param name="start" value="<%=start%>" />
		<jsp:param name="hidden_tabungan_service_id" value="<%=tabunganService.getOID()%>" />
		</jsp:forward>
	<%
	}

%>

<!-- End of Jsp Block -->


<html><!-- #BeginTemplate "/Templates/main.dwt" -->
<head>
<!-- #BeginEditable "doctitle" -->
<title>sipadu--</title>
<script language="JavaScript">

	function cmdCancel(){
		document.frm_tabunganservice.command.value="<%=Command.ADD%>";
		document.frm_tabunganservice.action="tabunganservice_edit.jsp";
		document.frm_tabunganservice.submit();
	} 
	function cmdCancel(){
		document.frm_tabunganservice.command.value="<%=Command.CANCEL%>";
		document.frm_tabunganservice.action="tabunganservice_edit.jsp";
		document.frm_tabunganservice.submit();
	} 

	function cmdEdit(oid){ 
		document.frm_tabunganservice.command.value="<%=Command.EDIT%>";
		document.frm_tabunganservice.action="tabunganservice_edit.jsp";
		document.frm_tabunganservice.submit(); 
	} 

	function cmdSave(){
		document.frm_tabunganservice.command.value="<%=Command.SAVE%>"; 
		document.frm_tabunganservice.action="tabunganservice_edit.jsp";
		document.frm_tabunganservice.submit();
	}

	function cmdAsk(oid){
		document.frm_tabunganservice.command.value="<%=Command.ASK%>"; 
		document.frm_tabunganservice.action="tabunganservice_edit.jsp";
		document.frm_tabunganservice.submit();
	} 

	function cmdConfirmDelete(oid){
		document.frm_tabunganservice.command.value="<%=Command.DELETE%>";
		document.frm_tabunganservice.action="tabunganservice_edit.jsp"; 
		document.frm_tabunganservice.submit();
	}  

	function cmdBack(){
		document.frm_tabunganservice.command.value="<%=Command.FIRST%>"; 
		document.frm_tabunganservice.action="tabunganservice_edit.jsp";
		document.frm_tabunganservice.submit();
	}

//-------------- script form image -------------------

	function cmdDelPic(oid){
		document.frm_tabunganservice.command.value="<%=Command.POST%>"; 
		document.frm_tabunganservice.action="tabunganservice_edit.jsp";
		document.frm_tabunganservice.submit();
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
<link rel="stylesheet" href="::...error, can't generate level, level = 0..::style/main.css" type="text/css">
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
			<!-- #BeginEditable "menu_main" --><%@ include file = "::...error, can't generate level, level = 0..::main/menumain.jsp" %><!-- #EndEditable --> </td>
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

					<form name="frm_tabunganservice" method="post" action="">
					<input type="hidden" name="command" value="">
					<input type="hidden" name="start" value="<%=start%>">
					<input type="hidden" name="hidden_tabungan_service_id" value="<%=oidTabunganService%>">
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
							<td width="29%"  valign="top"  >Proceed Date</td>
							<td  width="67%"  valign="top">
								<%=ControlDate.drawDateWithStyle(JspTabunganService.fieldNames[JspTabunganService.FRM_FIELD_PROCEED_DATE], (tabunganService.getProceedDate()==null) ? new Date() : tabunganService.getProceedDate(), 1, -5, "formElemen", "")%> * <%=jspTabunganService.getErrorMsg(JspTabunganService.FRM_FIELD_PROCEED_DATE)%></td>
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
							String scomDel = "javascript:cmdAsk('"+oidTabunganService+"')";
							String sconDelCom = "javascript:cmdConfirmDelete('"+oidTabunganService+"')";
							String scancel = "javascript:cmdEdit('"+oidTabunganService+"')";
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
