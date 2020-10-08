<% 
/* 
 * Page Name  		:  projectterm.jsp
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

<!--package crm -->
<%@ page import = "com.dimata.crm.entity.project.*" %>
<%@ page import = "com.dimata.crm.form.project.*" %>
<%@ page import = "com.dimata.crm.entity.admin.*" %>
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

	public String drawList(int iCommand,JspProjectTerm frmObject, ProjectTerm objEntity, Vector objectClass,  int projectTermId)

	{
		ControlList ctrlist = new ControlList();
		ctrlist.setAreaWidth("100%");
		ctrlist.setListStyle("listgen");
		ctrlist.setTitleStyle("tableheader");
		ctrlist.setCellStyle("cellStyle");
		ctrlist.setHeaderStyle("tableheader");
		ctrlist.addHeader("Squence","16%");
		ctrlist.addHeader("Type","16%");
		ctrlist.addHeader("Description","16%");
		ctrlist.addHeader("Status","16%");
		ctrlist.addHeader("Amount","16%");
		ctrlist.addHeader("Currency Id","16%");

		ctrlist.setLinkRow(0);
		ctrlist.setLinkSufix("");
		Vector lstData = ctrlist.getData();
		Vector lstLinkData = ctrlist.getLinkData();
		Vector rowx = new Vector(1,1);
		ctrlist.reset();
		int index = -1;
		String whereCls = "";
		String orderCls = "";

		/* selected Type*/
		Vector type_value = new Vector(1,1);
		Vector type_key = new Vector(1,1);
		type_value.add("");
		type_key.add("---select---");

		/* selected Status*/
		Vector status_value = new Vector(1,1);
		Vector status_key = new Vector(1,1);
		status_value.add("");
		status_key.add("---select---");

		/* selected CurrencyId*/
		Vector currencyid_value = new Vector(1,1);
		Vector currencyid_key = new Vector(1,1);
		currencyid_value.add("");
		currencyid_key.add("---select---");

		for (int i = 0; i < objectClass.size(); i++) {
			 ProjectTerm projectTerm = (ProjectTerm)objectClass.get(i);
			 rowx = new Vector();
			 if(projectTermId == projectTerm.getOID())
				 index = i; 

			 if(index == i && (iCommand == Command.EDIT || iCommand == Command.ASK)){
					
				rowx.add("<input type=\"text\" name=\""+frmObject.fieldNames[JspProjectTerm.FRM_FIELD_SQUENCE] +"\" value=\""+projectTerm.getSquence()+"\" class=\"formElemen\">");
				rowx.add(ControlCombo.draw(frmObject.fieldNames[JspProjectTerm.FRM_FIELD_TYPE],null, ""+projectTerm.getType(), type_value , type_key, "formElemen", ""));
				rowx.add("<input type=\"text\" name=\""+frmObject.fieldNames[JspProjectTerm.FRM_FIELD_DESCRIPTION] +"\" value=\""+projectTerm.getDescription()+"\" class=\"formElemen\">");
				rowx.add(ControlCombo.draw(frmObject.fieldNames[JspProjectTerm.FRM_FIELD_STATUS],null, ""+projectTerm.getStatus(), status_value , status_key, "formElemen", ""));
				rowx.add("<input type=\"text\" name=\""+frmObject.fieldNames[JspProjectTerm.FRM_FIELD_AMOUNT] +"\" value=\""+projectTerm.getAmount()+"\" class=\"formElemen\">");
				rowx.add(ControlCombo.draw(frmObject.fieldNames[JspProjectTerm.FRM_FIELD_CURRENCY_ID],null, ""+projectTerm.getCurrencyId(), currencyid_value , currencyid_key, "formElemen", ""));
			}else{
				rowx.add("<a href=\"javascript:cmdEdit('"+String.valueOf(projectTerm.getOID())+"')\">"+String.valueOf(projectTerm.getSquence())+"</a>");
				rowx.add(String.valueOf(projectTerm.getType()));
				rowx.add(projectTerm.getDescription());
				rowx.add(String.valueOf(projectTerm.getStatus()));
				rowx.add(String.valueOf(projectTerm.getAmount()));
				rowx.add(String.valueOf(projectTerm.getCurrencyId()));
			} 

			lstData.add(rowx);
		}

		 rowx = new Vector();

		if(iCommand == Command.ADD || (iCommand == Command.SAVE && frmObject.errorSize() > 0)){ 
				rowx.add("<input type=\"text\" name=\""+frmObject.fieldNames[JspProjectTerm.FRM_FIELD_SQUENCE] +"\" value=\""+objEntity.getSquence()+"\" class=\"formElemen\">");
				rowx.add(ControlCombo.draw(frmObject.fieldNames[JspProjectTerm.FRM_FIELD_TYPE],null, ""+objEntity.getType(), type_value , type_key, "formElemen", ""));
				rowx.add("<input type=\"text\" name=\""+frmObject.fieldNames[JspProjectTerm.FRM_FIELD_DESCRIPTION] +"\" value=\""+objEntity.getDescription()+"\" class=\"formElemen\">");
				rowx.add(ControlCombo.draw(frmObject.fieldNames[JspProjectTerm.FRM_FIELD_STATUS],null, ""+objEntity.getStatus(), status_value , status_key, "formElemen", ""));
				rowx.add("<input type=\"text\" name=\""+frmObject.fieldNames[JspProjectTerm.FRM_FIELD_AMOUNT] +"\" value=\""+objEntity.getAmount()+"\" class=\"formElemen\">");
				rowx.add(ControlCombo.draw(frmObject.fieldNames[JspProjectTerm.FRM_FIELD_CURRENCY_ID],null, ""+objEntity.getCurrencyId(), currencyid_value , currencyid_key, "formElemen", ""));

		}

		lstData.add(rowx);

		return ctrlist.draw();
	}

%>
<%
int iCommand = FRMQueryString.requestCommand(request);
int start = FRMQueryString.requestInt(request, "start");
int prevCommand = FRMQueryString.requestInt(request, "prev_command");
int var_projectTermId = FRMQueryString.requestInt(request, "hidden_project_term_id");

/*variable declaration*/
int recordToGet = 10;
String msgString = "";
int iErrCode = FRMMessage.NONE;
String whereClause = "";
String orderClause = "";

CtrlProjectTerm ctrlProjectTerm = new CtrlProjectTerm(request);
ControlLine ctrLine = new ControlLine();
Vector listProjectTerm = new Vector(1,1);

/*switch statement */
iErrCode = ctrlProjectTerm.action(iCommand , oidProjectTerm);
/* end switch*/
JspProjectTerm jspProjectTerm = ctrlProjectTerm.getForm();

/*count list All ProjectTerm*/
int vectSize = PstProjectTerm.getCount(whereClause);

/*switch list ProjectTerm*/
if((iCommand == Command.FIRST || iCommand == Command.PREV )||
  (iCommand == Command.NEXT || iCommand == Command.LAST)){
		start = ctrlProjectTerm.actionList(iCommand, start, vectSize, recordToGet);
 } 
/* end switch list*/

ProjectTerm projectTerm = ctrlProjectTerm.getProjectTerm();
msgString =  ctrlProjectTerm.getMessage();

/* get record to display */
listProjectTerm = PstProjectTerm.list(start,recordToGet, whereClause , orderClause);

/*handle condition if size of record to display = 0 and start > 0 	after delete*/
if (listProjectTerm.size() < 1 && start > 0)
{
	 if (vectSize - recordToGet > recordToGet)
			start = start - recordToGet;   //go to Command.PREV
	 else{
		 start = 0 ;
		 iCommand = Command.FIRST;
		 prevCommand = Command.FIRST; //go to Command.FIRST
	 }
	 listProjectTerm = PstProjectTerm.list(start,recordToGet, whereClause , orderClause);
}
%>


<html><!-- #BeginTemplate "/Templates/main.dwt" -->
<head>
<!-- #BeginEditable "doctitle" -->
<title>crm--</title>
<script language="JavaScript">


function cmdAdd(){
	document.frmprojectterm.hidden_project_term_id.value="0";
	document.frmprojectterm.command.value="<%=Command.ADD%>";
	document.frmprojectterm.prev_command.value="<%=prevCommand%>";
	document.frmprojectterm.action="projectterm.jsp";
	document.frmprojectterm.submit();
}

function cmdAsk(oidProjectTerm){
	document.frmprojectterm.hidden_project_term_id.value=oidProjectTerm;
	document.frmprojectterm.command.value="<%=Command.ASK%>";
	document.frmprojectterm.prev_command.value="<%=prevCommand%>";
	document.frmprojectterm.action="projectterm.jsp";
	document.frmprojectterm.submit();
}

function cmdConfirmDelete(oidProjectTerm){
	document.frmprojectterm.hidden_project_term_id.value=oidProjectTerm;
	document.frmprojectterm.command.value="<%=Command.DELETE%>";
	document.frmprojectterm.prev_command.value="<%=prevCommand%>";
	document.frmprojectterm.action="projectterm.jsp";
	document.frmprojectterm.submit();
}

function cmdSave(){
	document.frmprojectterm.command.value="<%=Command.SAVE%>";
	document.frmprojectterm.prev_command.value="<%=prevCommand%>";
	document.frmprojectterm.action="projectterm.jsp";
	document.frmprojectterm.submit();
}

function cmdEdit(oidProjectTerm){
	document.frmprojectterm.hidden_project_term_id.value=oidProjectTerm;
	document.frmprojectterm.command.value="<%=Command.EDIT%>";
	document.frmprojectterm.prev_command.value="<%=prevCommand%>";
	document.frmprojectterm.action="projectterm.jsp";
	document.frmprojectterm.submit();
}

function cmdCancel(oidProjectTerm){
	document.frmprojectterm.hidden_project_term_id.value=oidProjectTerm;
	document.frmprojectterm.command.value="<%=Command.EDIT%>";
	document.frmprojectterm.prev_command.value="<%=prevCommand%>";
	document.frmprojectterm.action="projectterm.jsp";
	document.frmprojectterm.submit();
}

function cmdBack(){
	document.frmprojectterm.command.value="<%=Command.BACK%>";
	document.frmprojectterm.action="projectterm.jsp";
	document.frmprojectterm.submit();
}

function cmdListFirst(){
	document.frmprojectterm.command.value="<%=Command.FIRST%>";
	document.frmprojectterm.prev_command.value="<%=Command.FIRST%>";
	document.frmprojectterm.action="projectterm.jsp";
	document.frmprojectterm.submit();
}

function cmdListPrev(){
	document.frmprojectterm.command.value="<%=Command.PREV%>";
	document.frmprojectterm.prev_command.value="<%=Command.PREV%>";
	document.frmprojectterm.action="projectterm.jsp";
	document.frmprojectterm.submit();
}

function cmdListNext(){
	document.frmprojectterm.command.value="<%=Command.NEXT%>";
	document.frmprojectterm.prev_command.value="<%=Command.NEXT%>";
	document.frmprojectterm.action="projectterm.jsp";
	document.frmprojectterm.submit();
}

function cmdListLast(){
	document.frmprojectterm.command.value="<%=Command.LAST%>";
	document.frmprojectterm.prev_command.value="<%=Command.LAST%>";
	document.frmprojectterm.action="projectterm.jsp";
	document.frmprojectterm.submit();
}

//-------------- script form image -------------------

function cmdDelPict(oidProjectTerm){
	document.frmimage.hidden_project_term_id.value=oidProjectTerm;
	document.frmimage.command.value="<%=Command.POST%>";
	document.frmimage.action="projectterm.jsp";
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

						<form name="frmprojectterm" method ="post" action="">
				<input type="hidden" name="command" value="<%=iCommand%>">
				<input type="hidden" name="vectSize" value="<%=vectSize%>">
				<input type="hidden" name="start" value="<%=start%>">
				<input type="hidden" name="prev_command" value="<%=prevCommand%>">
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
						      <td height="14" valign="middle" colspan="3" class="comment">&nbsp;ProjectTerm
						       List </td>
						  </tr>
						  <%
							try{
							%>
						  <tr align="left" valign="top">
						        <td height="22" valign="middle" colspan="3"> <%= drawList(iCommand,jspProjectTerm, projectTerm,listProjectTerm,oidProjectTerm)%> </td>
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
									String scomDel = "javascript:cmdAsk('"+oidProjectTerm+"')";
									String sconDelCom = "javascript:cmdConfirmDelete('"+oidProjectTerm+"')";
									String scancel = "javascript:cmdEdit('"+oidProjectTerm+"')";
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
