<% 
/* 
 * Page Name  		:  department.jsp
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
<%@ page import = "com.dimata.ccs.entity.master.*" %>
<%@ page import = "com.dimata.ccs.form.master.*" %>
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

	public String drawList(int iJSPCommand,JspDepartment frmObject, Department objEntity, Vector objectClass,  long departmentId)

	{
		JSPList jsplist = new JSPList();
		jsplist.setAreaWidth("100%");
		jsplist.setListStyle("listgen");
		jsplist.setTitleStyle("tableheader");
		jsplist.setCellStyle("cellStyle");
		jsplist.setHeaderStyle("tableheader");
		jsplist.addHeader("Name","100%");

		jsplist.setLinkRow(0);
		jsplist.setLinkSufix("");
		Vector lstData = jsplist.getData();
		Vector lstLinkData = jsplist.getLinkData();
		Vector rowx = new Vector(1,1);
		jsplist.reset();
		int index = -1;

		for (int i = 0; i < objectClass.size(); i++) {
			 Department department = (Department)objectClass.get(i);
			 rowx = new Vector();
			 if(departmentId == department.getOID())
				 index = i; 

			 if(index == i && (iJSPCommand == JSPCommand.EDIT || iJSPCommand == JSPCommand.ASK)){
					
				rowx.add("<input type=\"text\" name=\""+frmObject.colNames[JspDepartment.JSP_NAME] +"\" value=\""+department.getName()+"\" class=\"formElemen\">");
			}else{
				rowx.add("<a href=\"javascript:cmdEdit('"+String.valueOf(department.getOID())+"')\">"+department.getName()+"</a>");
			} 

			lstData.add(rowx);
		}

		 rowx = new Vector();

		if(iJSPCommand == JSPCommand.ADD || (iJSPCommand == JSPCommand.SAVE && frmObject.errorSize() > 0)){ 
				rowx.add("<input type=\"text\" name=\""+frmObject.colNames[JspDepartment.JSP_NAME] +"\" value=\""+objEntity.getName()+"\" class=\"formElemen\">");

		}

		lstData.add(rowx);

		return jsplist.draw();
	}

%>
<%
int iJSPCommand = JSPRequestValue.requestCommand(request);
int start = JSPRequestValue.requestInt(request, "start");
int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
long oidDepartment = JSPRequestValue.requestLong(request, "hidden_department_id");

/*variable declaration*/
int recordToGet = 10;
String msgString = "";
int iErrCode = JSPMessage.NONE;
String whereClause = "";
String orderClause = "";

CmdDepartment ctrlDepartment = new CmdDepartment(request);
JSPLine ctrLine = new JSPLine();
Vector listDepartment = new Vector(1,1);

/*switch statement */
iErrCode = ctrlDepartment.action(iJSPCommand , oidDepartment);
/* end switch*/
JspDepartment jspDepartment = ctrlDepartment.getForm();

/*count list All Department*/
int vectSize = DbDepartment.getCount(whereClause);

/*switch list Department*/
if((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV )||
  (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)){
		start = ctrlDepartment.actionList(iJSPCommand, start, vectSize, recordToGet);
 } 
/* end switch list*/

Department department = ctrlDepartment.getDepartment();
msgString =  ctrlDepartment.getMessage();

/* get record to display */
listDepartment = DbDepartment.list(start,recordToGet, whereClause , orderClause);

/*handle condition if size of record to display = 0 and start > 0 	after delete*/
if (listDepartment.size() < 1 && start > 0)
{
	 if (vectSize - recordToGet > recordToGet)
			start = start - recordToGet;   //go to JSPCommand.PREV
	 else{
		 start = 0 ;
		 iJSPCommand = JSPCommand.FIRST;
		 prevJSPCommand = JSPCommand.FIRST; //go to JSPCommand.FIRST
	 }
	 listDepartment = DbDepartment.list(start,recordToGet, whereClause , orderClause);
}
%>


<html><!-- #BeginTemplate "/Templates/main.dwt" -->
<head>
<!-- #BeginEditable "doctitle" -->
<title>ccs--</title>
<script language="JavaScript">


function cmdAdd(){
	document.frmdepartment.hidden_department_id.value="0";
	document.frmdepartment.command.value="<%=JSPCommand.ADD%>";
	document.frmdepartment.prev_command.value="<%=prevJSPCommand%>";
	document.frmdepartment.action="department.jsp";
	document.frmdepartment.submit();
}

function cmdAsk(oidDepartment){
	document.frmdepartment.hidden_department_id.value=oidDepartment;
	document.frmdepartment.command.value="<%=JSPCommand.ASK%>";
	document.frmdepartment.prev_command.value="<%=prevJSPCommand%>";
	document.frmdepartment.action="department.jsp";
	document.frmdepartment.submit();
}

function cmdConfirmDelete(oidDepartment){
	document.frmdepartment.hidden_department_id.value=oidDepartment;
	document.frmdepartment.command.value="<%=JSPCommand.DELETE%>";
	document.frmdepartment.prev_command.value="<%=prevJSPCommand%>";
	document.frmdepartment.action="department.jsp";
	document.frmdepartment.submit();
}

function cmdSave(){
	document.frmdepartment.command.value="<%=JSPCommand.SAVE%>";
	document.frmdepartment.prev_command.value="<%=prevJSPCommand%>";
	document.frmdepartment.action="department.jsp";
	document.frmdepartment.submit();
}

function cmdEdit(oidDepartment){
	document.frmdepartment.hidden_department_id.value=oidDepartment;
	document.frmdepartment.command.value="<%=JSPCommand.EDIT%>";
	document.frmdepartment.prev_command.value="<%=prevJSPCommand%>";
	document.frmdepartment.action="department.jsp";
	document.frmdepartment.submit();
}

function cmdCancel(oidDepartment){
	document.frmdepartment.hidden_department_id.value=oidDepartment;
	document.frmdepartment.command.value="<%=JSPCommand.EDIT%>";
	document.frmdepartment.prev_command.value="<%=prevJSPCommand%>";
	document.frmdepartment.action="department.jsp";
	document.frmdepartment.submit();
}

function cmdBack(){
	document.frmdepartment.command.value="<%=JSPCommand.BACK%>";
	document.frmdepartment.action="department.jsp";
	document.frmdepartment.submit();
}

function cmdListFirst(){
	document.frmdepartment.command.value="<%=JSPCommand.FIRST%>";
	document.frmdepartment.prev_command.value="<%=JSPCommand.FIRST%>";
	document.frmdepartment.action="department.jsp";
	document.frmdepartment.submit();
}

function cmdListPrev(){
	document.frmdepartment.command.value="<%=JSPCommand.PREV%>";
	document.frmdepartment.prev_command.value="<%=JSPCommand.PREV%>";
	document.frmdepartment.action="department.jsp";
	document.frmdepartment.submit();
}

function cmdListNext(){
	document.frmdepartment.command.value="<%=JSPCommand.NEXT%>";
	document.frmdepartment.prev_command.value="<%=JSPCommand.NEXT%>";
	document.frmdepartment.action="department.jsp";
	document.frmdepartment.submit();
}

function cmdListLast(){
	document.frmdepartment.command.value="<%=JSPCommand.LAST%>";
	document.frmdepartment.prev_command.value="<%=JSPCommand.LAST%>";
	document.frmdepartment.action="department.jsp";
	document.frmdepartment.submit();
}

//-------------- script form image -------------------

function cmdDelPict(oidDepartment){
	document.frmimage.hidden_department_id.value=oidDepartment;
	document.frmimage.command.value="<%=JSPCommand.POST%>";
	document.frmimage.action="department.jsp";
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

						<form name="frmdepartment" method ="post" action="">
				<input type="hidden" name="command" value="<%=iJSPCommand%>">
				<input type="hidden" name="vectSize" value="<%=vectSize%>">
				<input type="hidden" name="start" value="<%=start%>">
				<input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
				<input type="hidden" name="hidden_department_id" value="<%=oidDepartment%>">
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
						      <td height="14" valign="middle" colspan="3" class="comment">&nbsp;Department
						       List </td>
						  </tr>
						  <%
							try{
							%>
						  <tr align="left" valign="top">
						        <td height="22" valign="middle" colspan="3"> <%= drawList(iJSPCommand,jspDepartment, department,listDepartment,oidDepartment)%> </td>
						  </tr>
						  <% 
						  }catch(Exception exc){ 
						  }%>
						  <tr align="left" valign="top">
						      <td height="8" align="left" colspan="3" class="command">
							          <span class="command">
							       <% 
								   int cmd = 0;
									   if ((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV )|| 
										(iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST))
											cmd =iJSPCommand; 
								   else{
									  if(iJSPCommand == JSPCommand.NONE || prevJSPCommand == JSPCommand.NONE)
										cmd = JSPCommand.FIRST;
									  else 
									  	cmd =prevJSPCommand; 
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
									String scomDel = "javascript:cmdAsk('"+oidDepartment+"')";
									String sconDelCom = "javascript:cmdConfirmDelete('"+oidDepartment+"')";
									String scancel = "javascript:cmdEdit('"+oidDepartment+"')";
									ctrLine.setBackCaption("Back to List");
									ctrLine.setJSPCommandStyle("buttonlink");

									if (privDelete){
										ctrLine.setConfirmDelJSPCommand(sconDelCom);
										ctrLine.setDeleteJSPCommand(scomDel);
										ctrLine.setEditJSPCommand(scancel);
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
								<%= ctrLine.drawImage(iJSPCommand, iErrCode, msgString)%>
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
