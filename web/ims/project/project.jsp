<% 
/* 
 * Page Name  		:  project.jsp
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

	public String drawList(Vector objectClass ,  long projectId)

	{
		ControlList ctrlist = new ControlList();
		ctrlist.setAreaWidth("100%");
		ctrlist.setListStyle("listgen");
		ctrlist.setTitleStyle("tableheader");
		ctrlist.setCellStyle("cellStyle");
		ctrlist.setHeaderStyle("tableheader");
		ctrlist.addHeader("Date","6%");
		ctrlist.addHeader("Number Prefix","6%");
		ctrlist.addHeader("Counter","6%");
		ctrlist.addHeader("Name","6%");
		ctrlist.addHeader("Customer Id","6%");
		ctrlist.addHeader("Customer Pic","6%");
		ctrlist.addHeader("Customer Pic Phone","6%");
		ctrlist.addHeader("Number","6%");
		ctrlist.addHeader("End Date","6%");
		ctrlist.addHeader("Customer Pic Position","6%");
		ctrlist.addHeader("Start Date","6%");
		ctrlist.addHeader("User Id","6%");
		ctrlist.addHeader("Employee Hp","6%");
		ctrlist.addHeader("Description","6%");
		ctrlist.addHeader("Status","6%");

		ctrlist.setLinkRow(0);
		ctrlist.setLinkSufix("");
		Vector lstData = ctrlist.getData();
		Vector lstLinkData = ctrlist.getLinkData();
		ctrlist.setLinkPrefix("javascript:cmdEdit('");
		ctrlist.setLinkSufix("')");
		ctrlist.reset();
		int index = -1;

		for (int i = 0; i < objectClass.size(); i++) {
			Project project = (Project)objectClass.get(i);
			 Vector rowx = new Vector();
			 if(projectId == project.getOID())
				 index = i;

			String str_dt_Date = ""; 
			try{
				Date dt_Date = project.getDate();
				if(dt_Date==null){
					dt_Date = new Date();
				}

				str_dt_Date = Formater.formatDate(dt_Date, "dd MMMM yyyy");
			}catch(Exception e){ str_dt_Date = ""; }

			rowx.add(str_dt_Date);

			rowx.add(project.getNumberPrefix());

			rowx.add(String.valueOf(project.getCounter()));

			rowx.add(project.getName());

			rowx.add(String.valueOf(project.getCustomerId()));

			rowx.add(project.getCustomerPic());

			rowx.add(project.getCustomerPicPhone());

			rowx.add(project.getNumber());

			String str_dt_EndDate = ""; 
			try{
				Date dt_EndDate = project.getEndDate();
				if(dt_EndDate==null){
					dt_EndDate = new Date();
				}

				str_dt_EndDate = Formater.formatDate(dt_EndDate, "dd MMMM yyyy");
			}catch(Exception e){ str_dt_EndDate = ""; }

			rowx.add(str_dt_EndDate);

			rowx.add(project.getCustomerPicPosition());

			String str_dt_StartDate = ""; 
			try{
				Date dt_StartDate = project.getStartDate();
				if(dt_StartDate==null){
					dt_StartDate = new Date();
				}

				str_dt_StartDate = Formater.formatDate(dt_StartDate, "dd MMMM yyyy");
			}catch(Exception e){ str_dt_StartDate = ""; }

			rowx.add(str_dt_StartDate);

			rowx.add(String.valueOf(project.getUserId()));

			rowx.add(project.getEmployeeHp());

			rowx.add(project.getDescription());

			rowx.add(String.valueOf(project.getStatus()));

			lstData.add(rowx);
			lstLinkData.add(String.valueOf(project.getOID()));
		}

		return ctrlist.drawList(index);
	}

%>
<%
int iCommand = FRMQueryString.requestCommand(request);
int start = FRMQueryString.requestInt(request, "start");
int prevCommand = FRMQueryString.requestInt(request, "prev_command");
long oidProject = FRMQueryString.requestLong(request, "hidden_project_id");

/*variable declaration*/
int recordToGet = 10;
String msgString = "";
int iErrCode = FRMMessage.NONE;
String whereClause = "";
String orderClause = "";

CtrlProject ctrlProject = new CtrlProject(request);
ControlLine ctrLine = new ControlLine();
Vector listProject = new Vector(1,1);

/*switch statement */
iErrCode = ctrlProject.action(iCommand , oidProject);
/* end switch*/
JspProject jspProject = ctrlProject.getForm();

/*count list All Project*/
int vectSize = PstProject.getCount(whereClause);

Project project = ctrlProject.getProject();
msgString =  ctrlProject.getMessage();

/*switch list Project*/
if((iCommand == Command.SAVE) && (iErrCode == FRMMessage.NONE))
	start = PstProject.generateFindStart(project.getOID(),recordToGet, whereClause);

if((iCommand == Command.FIRST || iCommand == Command.PREV )||
  (iCommand == Command.NEXT || iCommand == Command.LAST)){
		start = ctrlProject.actionList(iCommand, start, vectSize, recordToGet);
 } 
/* end switch list*/

/* get record to display */
listProject = PstProject.list(start,recordToGet, whereClause , orderClause);

/*handle condition if size of record to display = 0 and start > 0 	after delete*/
if (listProject.size() < 1 && start > 0)
{
	 if (vectSize - recordToGet > recordToGet)
			start = start - recordToGet;   //go to Command.PREV
	 else{
		 start = 0 ;
		 iCommand = Command.FIRST;
		 prevCommand = Command.FIRST; //go to Command.FIRST
	 }
	 listProject = PstProject.list(start,recordToGet, whereClause , orderClause);
}
%>


<html><!-- #BeginTemplate "/Templates/main.dwt" -->
<head>
<!-- #BeginEditable "doctitle" -->
<title>crm--</title>
<script language="JavaScript">


function cmdAdd(){
	document.frmproject.hidden_project_id.value="0";
	document.frmproject.command.value="<%=Command.ADD%>";
	document.frmproject.prev_command.value="<%=prevCommand%>";
	document.frmproject.action="project.jsp";
	document.frmproject.submit();
}

function cmdAsk(oidProject){
	document.frmproject.hidden_project_id.value=oidProject;
	document.frmproject.command.value="<%=Command.ASK%>";
	document.frmproject.prev_command.value="<%=prevCommand%>";
	document.frmproject.action="project.jsp";
	document.frmproject.submit();
}

function cmdConfirmDelete(oidProject){
	document.frmproject.hidden_project_id.value=oidProject;
	document.frmproject.command.value="<%=Command.DELETE%>";
	document.frmproject.prev_command.value="<%=prevCommand%>";
	document.frmproject.action="project.jsp";
	document.frmproject.submit();
}
function cmdSave(){
	document.frmproject.command.value="<%=Command.SAVE%>";
	document.frmproject.prev_command.value="<%=prevCommand%>";
	document.frmproject.action="project.jsp";
	document.frmproject.submit();
	}

function cmdEdit(oidProject){
	document.frmproject.hidden_project_id.value=oidProject;
	document.frmproject.command.value="<%=Command.EDIT%>";
	document.frmproject.prev_command.value="<%=prevCommand%>";
	document.frmproject.action="project.jsp";
	document.frmproject.submit();
	}

function cmdCancel(oidProject){
	document.frmproject.hidden_project_id.value=oidProject;
	document.frmproject.command.value="<%=Command.EDIT%>";
	document.frmproject.prev_command.value="<%=prevCommand%>";
	document.frmproject.action="project.jsp";
	document.frmproject.submit();
}

function cmdBack(){
	document.frmproject.command.value="<%=Command.BACK%>";
	document.frmproject.action="project.jsp";
	document.frmproject.submit();
	}

function cmdListFirst(){
	document.frmproject.command.value="<%=Command.FIRST%>";
	document.frmproject.prev_command.value="<%=Command.FIRST%>";
	document.frmproject.action="project.jsp";
	document.frmproject.submit();
}

function cmdListPrev(){
	document.frmproject.command.value="<%=Command.PREV%>";
	document.frmproject.prev_command.value="<%=Command.PREV%>";
	document.frmproject.action="project.jsp";
	document.frmproject.submit();
	}

function cmdListNext(){
	document.frmproject.command.value="<%=Command.NEXT%>";
	document.frmproject.prev_command.value="<%=Command.NEXT%>";
	document.frmproject.action="project.jsp";
	document.frmproject.submit();
}

function cmdListLast(){
	document.frmproject.command.value="<%=Command.LAST%>";
	document.frmproject.prev_command.value="<%=Command.LAST%>";
	document.frmproject.action="project.jsp";
	document.frmproject.submit();
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

						<form name="frmproject" method ="post" action="">
				<input type="hidden" name="command" value="<%=iCommand%>">
				<input type="hidden" name="vectSize" value="<%=vectSize%>">
				<input type="hidden" name="start" value="<%=start%>">
				<input type="hidden" name="prev_command" value="<%=prevCommand%>">
				<input type="hidden" name="hidden_project_id" value="<%=oidProject%>">
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
						      <td height="14" valign="middle" colspan="3" class="comment">&nbsp;Project
						       List </td>
						  </tr>
						  <%
							try{
								if (listProject.size()>0){
							%>
						  <tr align="left" valign="top">
						        <td height="22" valign="middle" colspan="3"> <%= drawList(listProject,oidProject)%> </td>
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
							 <%if((iCommand ==Command.ADD)||(iCommand==Command.SAVE)&&(jspProject.errorSize()>0)||(iCommand==Command.EDIT)||(iCommand==Command.ASK)){%>
								 <table width="100%" border="0" cellspacing="1" cellpadding="0">
					      <tr align="left" valign="top">
					         <td height="21" valign="middle" width="17%">&nbsp;</td>
					         <td height="21" colspan="2" width="83%" class="comment">*)= required</td>
					      </tr>
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Date</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspProject.fieldNames[JspProject.FRM_FIELD_DATE] %>"  value="<%= project.getDate() %>" class="formElemen">
						* <%= jspProject.getErrorMsg(JspProject.FRM_FIELD_DATE) %>
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Number</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspProject.fieldNames[JspProject.FRM_FIELD_NUMBER] %>"  value="<%= project.getNumber() %>" class="formElemen">
						* <%= jspProject.getErrorMsg(JspProject.FRM_FIELD_NUMBER) %>
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Number Prefix</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspProject.fieldNames[JspProject.FRM_FIELD_NUMBER_PREFIX] %>"  value="<%= project.getNumberPrefix() %>" class="formElemen">
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Counter</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspProject.fieldNames[JspProject.FRM_FIELD_COUNTER] %>"  value="<%= project.getCounter() %>" class="formElemen">
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Name</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspProject.fieldNames[JspProject.FRM_FIELD_NAME] %>"  value="<%= project.getName() %>" class="formElemen">
						* <%= jspProject.getErrorMsg(JspProject.FRM_FIELD_NAME) %>
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Customer Id</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspProject.fieldNames[JspProject.FRM_FIELD_CUSTOMER_ID] %>"  value="<%= project.getCustomerId() %>" class="formElemen">
						* <%= jspProject.getErrorMsg(JspProject.FRM_FIELD_CUSTOMER_ID) %>
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Customer Pic</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspProject.fieldNames[JspProject.FRM_FIELD_CUSTOMER_PIC] %>"  value="<%= project.getCustomerPic() %>" class="formElemen">
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Customer Pic Phone</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspProject.fieldNames[JspProject.FRM_FIELD_CUSTOMER_PIC_PHONE] %>"  value="<%= project.getCustomerPicPhone() %>" class="formElemen">
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Customer Address</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspProject.fieldNames[JspProject.FRM_FIELD_CUSTOMER_ADDRESS] %>"  value="<%= project.getCustomerAddress() %>" class="formElemen">
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Start Date</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspProject.fieldNames[JspProject.FRM_FIELD_START_DATE] %>"  value="<%= project.getStartDate() %>" class="formElemen">
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">End Date</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspProject.fieldNames[JspProject.FRM_FIELD_END_DATE] %>"  value="<%= project.getEndDate() %>" class="formElemen">
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Customer Pic Position</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspProject.fieldNames[JspProject.FRM_FIELD_CUSTOMER_PIC_POSITION] %>"  value="<%= project.getCustomerPicPosition() %>" class="formElemen">
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Employee Id</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspProject.fieldNames[JspProject.FRM_FIELD_EMPLOYEE_ID] %>"  value="<%= project.getEmployeeId() %>" class="formElemen">
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">User Id</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspProject.fieldNames[JspProject.FRM_FIELD_USER_ID] %>"  value="<%= project.getUserId() %>" class="formElemen">
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Employee Hp</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspProject.fieldNames[JspProject.FRM_FIELD_EMPLOYEE_HP] %>"  value="<%= project.getEmployeeHp() %>" class="formElemen">
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Description</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspProject.fieldNames[JspProject.FRM_FIELD_DESCRIPTION] %>"  value="<%= project.getDescription() %>" class="formElemen">
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Status</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspProject.fieldNames[JspProject.FRM_FIELD_STATUS] %>"  value="<%= project.getStatus() %>" class="formElemen">
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Amount</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspProject.fieldNames[JspProject.FRM_FIELD_AMOUNT] %>"  value="<%= project.getAmount() %>" class="formElemen">
						* <%= jspProject.getErrorMsg(JspProject.FRM_FIELD_AMOUNT) %>
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Currency Id</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspProject.fieldNames[JspProject.FRM_FIELD_CURRENCY_ID] %>"  value="<%= project.getCurrencyId() %>" class="formElemen">
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
									String scomDel = "javascript:cmdAsk('"+oidProject+"')";
									String sconDelCom = "javascript:cmdConfirmDelete('"+oidProject+"')";
									String scancel = "javascript:cmdEdit('"+oidProject+"')";
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
