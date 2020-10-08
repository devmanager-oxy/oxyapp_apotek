<% 
/* 
 * Page Name  		:  patientlab.jsp
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

<!--package oxyapp -->
<%@ page import = "com.dimata.oxyapp.entity.clinic.*" %>
<%@ page import = "com.dimata.oxyapp.form.clinic.*" %>
<%@ page import = "com.dimata.oxyapp.entity.admin.*" %>
<%@ include file = "../../main/javainit.jsp" %>

<% int  appObjCode = 1;// AppObjInfo.composeObjCode(AppObjInfo.--, AppObjInfo.--, AppObjInfo.--); %>
<%//@ include file = "../../main/checkuser.jsp" %>
<%
/* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
boolean privAdd=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ADD));
boolean privUpdate=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_UPDATE));
boolean privDelete=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_DELETE));
%>

<!-- Jsp Block -->

<%!

	public String drawList(Vector objectClass ,  long patientLabId)

	{
		ControlList ctrlist = new ControlList();
		ctrlist.setAreaWidth("100%");
		ctrlist.setListStyle("listgen");
		ctrlist.setTitleStyle("tableheader");
		ctrlist.setCellStyle("cellStyle");
		ctrlist.setHeaderStyle("tableheader");
		ctrlist.addHeader("Date","16%");
		ctrlist.addHeader("Patient Id","16%");
		ctrlist.addHeader("Test Lab Id","16%");
		ctrlist.addHeader("Result Value","16%");
		ctrlist.addHeader("Normal Value","16%");
		ctrlist.addHeader("Description","16%");

		ctrlist.setLinkRow(0);
		ctrlist.setLinkSufix("");
		Vector lstData = ctrlist.getData();
		Vector lstLinkData = ctrlist.getLinkData();
		ctrlist.setLinkPrefix("javascript:cmdEdit('");
		ctrlist.setLinkSufix("')");
		ctrlist.reset();
		int index = -1;

		for (int i = 0; i < objectClass.size(); i++) {
			PatientLab patientLab = (PatientLab)objectClass.get(i);
			 Vector rowx = new Vector();
			 if(patientLabId == patientLab.getOID())
				 index = i;

			String str_dt_Date = ""; 
			try{
				Date dt_Date = patientLab.getDate();
				if(dt_Date==null){
					dt_Date = new Date();
				}

				str_dt_Date = Formater.formatDate(dt_Date, "dd MMMM yyyy");
			}catch(Exception e){ str_dt_Date = ""; }

			rowx.add(str_dt_Date);

			rowx.add(String.valueOf(patientLab.getPatientId()));

			rowx.add(String.valueOf(patientLab.getTestLabId()));

			rowx.add(patientLab.getResultValue());

			rowx.add(patientLab.getNormalValue());

			rowx.add(patientLab.getDescription());

			lstData.add(rowx);
			lstLinkData.add(String.valueOf(patientLab.getOID()));
		}

		return ctrlist.drawList(index);
	}

%>
<%
int iCommand = FRMQueryString.requestCommand(request);
int start = FRMQueryString.requestInt(request, "start");
int prevCommand = FRMQueryString.requestInt(request, "prev_command");
long oidPatientLab = FRMQueryString.requestLong(request, "hidden_patient_lab_id");

/*variable declaration*/
int recordToGet = 10;
String msgString = "";
int iErrCode = FRMMessage.NONE;
String whereClause = "";
String orderClause = "";

CtrlPatientLab ctrlPatientLab = new CtrlPatientLab(request);
ControlLine ctrLine = new ControlLine();
Vector listPatientLab = new Vector(1,1);

/*switch statement */
iErrCode = ctrlPatientLab.action(iCommand , oidPatientLab);
/* end switch*/
JspPatientLab jspPatientLab = ctrlPatientLab.getForm();

/*count list All PatientLab*/
int vectSize = PstPatientLab.getCount(whereClause);

PatientLab patientLab = ctrlPatientLab.getPatientLab();
msgString =  ctrlPatientLab.getMessage();

/*switch list PatientLab*/
if((iCommand == Command.SAVE) && (iErrCode == FRMMessage.NONE))
	start = PstPatientLab.generateFindStart(patientLab.getOID(),recordToGet, whereClause);

if((iCommand == Command.FIRST || iCommand == Command.PREV )||
  (iCommand == Command.NEXT || iCommand == Command.LAST)){
		start = ctrlPatientLab.actionList(iCommand, start, vectSize, recordToGet);
 } 
/* end switch list*/

/* get record to display */
listPatientLab = PstPatientLab.list(start,recordToGet, whereClause , orderClause);

/*handle condition if size of record to display = 0 and start > 0 	after delete*/
if (listPatientLab.size() < 1 && start > 0)
{
	 if (vectSize - recordToGet > recordToGet)
			start = start - recordToGet;   //go to Command.PREV
	 else{
		 start = 0 ;
		 iCommand = Command.FIRST;
		 prevCommand = Command.FIRST; //go to Command.FIRST
	 }
	 listPatientLab = PstPatientLab.list(start,recordToGet, whereClause , orderClause);
}
%>


<html><!-- #BeginTemplate "/Templates/main.dwt" -->
<head>
<!-- #BeginEditable "doctitle" -->
<title>oxyapp--</title>
<script language="JavaScript">


function cmdAdd(){
	document.frmpatientlab.hidden_patient_lab_id.value="0";
	document.frmpatientlab.command.value="<%=Command.ADD%>";
	document.frmpatientlab.prev_command.value="<%=prevCommand%>";
	document.frmpatientlab.action="patientlab.jsp";
	document.frmpatientlab.submit();
}

function cmdAsk(oidPatientLab){
	document.frmpatientlab.hidden_patient_lab_id.value=oidPatientLab;
	document.frmpatientlab.command.value="<%=Command.ASK%>";
	document.frmpatientlab.prev_command.value="<%=prevCommand%>";
	document.frmpatientlab.action="patientlab.jsp";
	document.frmpatientlab.submit();
}

function cmdConfirmDelete(oidPatientLab){
	document.frmpatientlab.hidden_patient_lab_id.value=oidPatientLab;
	document.frmpatientlab.command.value="<%=Command.DELETE%>";
	document.frmpatientlab.prev_command.value="<%=prevCommand%>";
	document.frmpatientlab.action="patientlab.jsp";
	document.frmpatientlab.submit();
}
function cmdSave(){
	document.frmpatientlab.command.value="<%=Command.SAVE%>";
	document.frmpatientlab.prev_command.value="<%=prevCommand%>";
	document.frmpatientlab.action="patientlab.jsp";
	document.frmpatientlab.submit();
	}

function cmdEdit(oidPatientLab){
	document.frmpatientlab.hidden_patient_lab_id.value=oidPatientLab;
	document.frmpatientlab.command.value="<%=Command.EDIT%>";
	document.frmpatientlab.prev_command.value="<%=prevCommand%>";
	document.frmpatientlab.action="patientlab.jsp";
	document.frmpatientlab.submit();
	}

function cmdCancel(oidPatientLab){
	document.frmpatientlab.hidden_patient_lab_id.value=oidPatientLab;
	document.frmpatientlab.command.value="<%=Command.EDIT%>";
	document.frmpatientlab.prev_command.value="<%=prevCommand%>";
	document.frmpatientlab.action="patientlab.jsp";
	document.frmpatientlab.submit();
}

function cmdBack(){
	document.frmpatientlab.command.value="<%=Command.BACK%>";
	document.frmpatientlab.action="patientlab.jsp";
	document.frmpatientlab.submit();
	}

function cmdListFirst(){
	document.frmpatientlab.command.value="<%=Command.FIRST%>";
	document.frmpatientlab.prev_command.value="<%=Command.FIRST%>";
	document.frmpatientlab.action="patientlab.jsp";
	document.frmpatientlab.submit();
}

function cmdListPrev(){
	document.frmpatientlab.command.value="<%=Command.PREV%>";
	document.frmpatientlab.prev_command.value="<%=Command.PREV%>";
	document.frmpatientlab.action="patientlab.jsp";
	document.frmpatientlab.submit();
	}

function cmdListNext(){
	document.frmpatientlab.command.value="<%=Command.NEXT%>";
	document.frmpatientlab.prev_command.value="<%=Command.NEXT%>";
	document.frmpatientlab.action="patientlab.jsp";
	document.frmpatientlab.submit();
}

function cmdListLast(){
	document.frmpatientlab.command.value="<%=Command.LAST%>";
	document.frmpatientlab.prev_command.value="<%=Command.LAST%>";
	document.frmpatientlab.action="patientlab.jsp";
	document.frmpatientlab.submit();
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
<link rel="stylesheet" href="../../style/main.css" type="text/css">
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
			<!-- #BeginEditable "menu_main" --><%@ include file = "../../main/menumain.jsp" %><!-- #EndEditable --> </td>
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

						<form name="frmpatientlab" method ="post" action="">
				<input type="hidden" name="command" value="<%=iCommand%>">
				<input type="hidden" name="vectSize" value="<%=vectSize%>">
				<input type="hidden" name="start" value="<%=start%>">
				<input type="hidden" name="prev_command" value="<%=prevCommand%>">
				<input type="hidden" name="hidden_patient_lab_id" value="<%=oidPatientLab%>">
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
						      <td height="14" valign="middle" colspan="3" class="comment">&nbsp;PatientLab
						       List </td>
						  </tr>
						  <%
							try{
								if (listPatientLab.size()>0){
							%>
						  <tr align="left" valign="top">
						        <td height="22" valign="middle" colspan="3"> <%= drawList(listPatientLab,oidPatientLab)%> </td>
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
							 <%if((iCommand ==Command.ADD)||(iCommand==Command.SAVE)&&(jspPatientLab.errorSize()>0)||(iCommand==Command.EDIT)||(iCommand==Command.ASK)){%>
								 <table width="100%" border="0" cellspacing="1" cellpadding="0">
					      <tr align="left" valign="top">
					         <td height="21" valign="middle" width="17%">&nbsp;</td>
					         <td height="21" colspan="2" width="83%" class="comment">*)= required</td>
					      </tr>
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Date</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspPatientLab.fieldNames[JspPatientLab.FRM_FIELD_DATE] %>"  value="<%= patientLab.getDate() %>" class="formElemen">
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Patient Id</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspPatientLab.fieldNames[JspPatientLab.FRM_FIELD_PATIENT_ID] %>"  value="<%= patientLab.getPatientId() %>" class="formElemen">
						* <%= jspPatientLab.getErrorMsg(JspPatientLab.FRM_FIELD_PATIENT_ID) %>
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Test Lab Id</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspPatientLab.fieldNames[JspPatientLab.FRM_FIELD_TEST_LAB_ID] %>"  value="<%= patientLab.getTestLabId() %>" class="formElemen">
						* <%= jspPatientLab.getErrorMsg(JspPatientLab.FRM_FIELD_TEST_LAB_ID) %>
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Result Value</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspPatientLab.fieldNames[JspPatientLab.FRM_FIELD_RESULT_VALUE] %>"  value="<%= patientLab.getResultValue() %>" class="formElemen">
						* <%= jspPatientLab.getErrorMsg(JspPatientLab.FRM_FIELD_RESULT_VALUE) %>
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Normal Value</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspPatientLab.fieldNames[JspPatientLab.FRM_FIELD_NORMAL_VALUE] %>"  value="<%= patientLab.getNormalValue() %>" class="formElemen">
						* <%= jspPatientLab.getErrorMsg(JspPatientLab.FRM_FIELD_NORMAL_VALUE) %>
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Description</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspPatientLab.fieldNames[JspPatientLab.FRM_FIELD_DESCRIPTION] %>"  value="<%= patientLab.getDescription() %>" class="formElemen">
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
									String scomDel = "javascript:cmdAsk('"+oidPatientLab+"')";
									String sconDelCom = "javascript:cmdConfirmDelete('"+oidPatientLab+"')";
									String scancel = "javascript:cmdEdit('"+oidPatientLab+"')";
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
