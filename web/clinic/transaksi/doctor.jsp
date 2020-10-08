<% 
/* 
 * Page Name  		:  doctor.jsp
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

	public String drawList(Vector objectClass ,  long doctorId)

	{
		ControlList ctrlist = new ControlList();
		ctrlist.setAreaWidth("100%");
		ctrlist.setListStyle("listgen");
		ctrlist.setTitleStyle("tableheader");
		ctrlist.setCellStyle("cellStyle");
		ctrlist.setHeaderStyle("tableheader");
		ctrlist.addHeader("Title","7%");
		ctrlist.addHeader("Name","7%");
		ctrlist.addHeader("Specialty Id","7%");
		ctrlist.addHeader("Ssn","7%");
		ctrlist.addHeader("Degree","7%");
		ctrlist.addHeader("Email","7%");
		ctrlist.addHeader("Address","7%");
		ctrlist.addHeader("State Id","7%");
		ctrlist.addHeader("Country Id","7%");
		ctrlist.addHeader("Zip","7%");
		ctrlist.addHeader("Fax","7%");
		ctrlist.addHeader("Phone","7%");
		ctrlist.addHeader("Mobile","7%");

		ctrlist.setLinkRow(0);
		ctrlist.setLinkSufix("");
		Vector lstData = ctrlist.getData();
		Vector lstLinkData = ctrlist.getLinkData();
		ctrlist.setLinkPrefix("javascript:cmdEdit('");
		ctrlist.setLinkSufix("')");
		ctrlist.reset();
		int index = -1;

		for (int i = 0; i < objectClass.size(); i++) {
			Doctor doctor = (Doctor)objectClass.get(i);
			 Vector rowx = new Vector();
			 if(doctorId == doctor.getOID())
				 index = i;

			rowx.add(String.valueOf(doctor.getTitle()));

			rowx.add(doctor.getName());

			rowx.add(String.valueOf(doctor.getSpecialtyId()));

			rowx.add(doctor.getSsn());

			rowx.add(doctor.getDegree());

			rowx.add(doctor.getEmail());

			rowx.add(doctor.getAddress());

			rowx.add(String.valueOf(doctor.getStateId()));

			rowx.add(String.valueOf(doctor.getCountryId()));

			rowx.add(doctor.getZip());

			rowx.add(doctor.getFax());

			rowx.add(doctor.getPhone());

			rowx.add(doctor.getMobile());

			lstData.add(rowx);
			lstLinkData.add(String.valueOf(doctor.getOID()));
		}

		return ctrlist.drawList(index);
	}

%>
<%
int iCommand = FRMQueryString.requestCommand(request);
int start = FRMQueryString.requestInt(request, "start");
int prevCommand = FRMQueryString.requestInt(request, "prev_command");
long oidDoctor = FRMQueryString.requestLong(request, "hidden_doctor_id");

/*variable declaration*/
int recordToGet = 10;
String msgString = "";
int iErrCode = FRMMessage.NONE;
String whereClause = "";
String orderClause = "";

CtrlDoctor ctrlDoctor = new CtrlDoctor(request);
ControlLine ctrLine = new ControlLine();
Vector listDoctor = new Vector(1,1);

/*switch statement */
iErrCode = ctrlDoctor.action(iCommand , oidDoctor);
/* end switch*/
JspDoctor jspDoctor = ctrlDoctor.getForm();

/*count list All Doctor*/
int vectSize = PstDoctor.getCount(whereClause);

Doctor doctor = ctrlDoctor.getDoctor();
msgString =  ctrlDoctor.getMessage();

/*switch list Doctor*/
if((iCommand == Command.SAVE) && (iErrCode == FRMMessage.NONE))
	start = PstDoctor.generateFindStart(doctor.getOID(),recordToGet, whereClause);

if((iCommand == Command.FIRST || iCommand == Command.PREV )||
  (iCommand == Command.NEXT || iCommand == Command.LAST)){
		start = ctrlDoctor.actionList(iCommand, start, vectSize, recordToGet);
 } 
/* end switch list*/

/* get record to display */
listDoctor = PstDoctor.list(start,recordToGet, whereClause , orderClause);

/*handle condition if size of record to display = 0 and start > 0 	after delete*/
if (listDoctor.size() < 1 && start > 0)
{
	 if (vectSize - recordToGet > recordToGet)
			start = start - recordToGet;   //go to Command.PREV
	 else{
		 start = 0 ;
		 iCommand = Command.FIRST;
		 prevCommand = Command.FIRST; //go to Command.FIRST
	 }
	 listDoctor = PstDoctor.list(start,recordToGet, whereClause , orderClause);
}
%>


<html><!-- #BeginTemplate "/Templates/main.dwt" -->
<head>
<!-- #BeginEditable "doctitle" -->
<title>oxyapp--</title>
<script language="JavaScript">


function cmdAdd(){
	document.frmdoctor.hidden_doctor_id.value="0";
	document.frmdoctor.command.value="<%=Command.ADD%>";
	document.frmdoctor.prev_command.value="<%=prevCommand%>";
	document.frmdoctor.action="doctor.jsp";
	document.frmdoctor.submit();
}

function cmdAsk(oidDoctor){
	document.frmdoctor.hidden_doctor_id.value=oidDoctor;
	document.frmdoctor.command.value="<%=Command.ASK%>";
	document.frmdoctor.prev_command.value="<%=prevCommand%>";
	document.frmdoctor.action="doctor.jsp";
	document.frmdoctor.submit();
}

function cmdConfirmDelete(oidDoctor){
	document.frmdoctor.hidden_doctor_id.value=oidDoctor;
	document.frmdoctor.command.value="<%=Command.DELETE%>";
	document.frmdoctor.prev_command.value="<%=prevCommand%>";
	document.frmdoctor.action="doctor.jsp";
	document.frmdoctor.submit();
}
function cmdSave(){
	document.frmdoctor.command.value="<%=Command.SAVE%>";
	document.frmdoctor.prev_command.value="<%=prevCommand%>";
	document.frmdoctor.action="doctor.jsp";
	document.frmdoctor.submit();
	}

function cmdEdit(oidDoctor){
	document.frmdoctor.hidden_doctor_id.value=oidDoctor;
	document.frmdoctor.command.value="<%=Command.EDIT%>";
	document.frmdoctor.prev_command.value="<%=prevCommand%>";
	document.frmdoctor.action="doctor.jsp";
	document.frmdoctor.submit();
	}

function cmdCancel(oidDoctor){
	document.frmdoctor.hidden_doctor_id.value=oidDoctor;
	document.frmdoctor.command.value="<%=Command.EDIT%>";
	document.frmdoctor.prev_command.value="<%=prevCommand%>";
	document.frmdoctor.action="doctor.jsp";
	document.frmdoctor.submit();
}

function cmdBack(){
	document.frmdoctor.command.value="<%=Command.BACK%>";
	document.frmdoctor.action="doctor.jsp";
	document.frmdoctor.submit();
	}

function cmdListFirst(){
	document.frmdoctor.command.value="<%=Command.FIRST%>";
	document.frmdoctor.prev_command.value="<%=Command.FIRST%>";
	document.frmdoctor.action="doctor.jsp";
	document.frmdoctor.submit();
}

function cmdListPrev(){
	document.frmdoctor.command.value="<%=Command.PREV%>";
	document.frmdoctor.prev_command.value="<%=Command.PREV%>";
	document.frmdoctor.action="doctor.jsp";
	document.frmdoctor.submit();
	}

function cmdListNext(){
	document.frmdoctor.command.value="<%=Command.NEXT%>";
	document.frmdoctor.prev_command.value="<%=Command.NEXT%>";
	document.frmdoctor.action="doctor.jsp";
	document.frmdoctor.submit();
}

function cmdListLast(){
	document.frmdoctor.command.value="<%=Command.LAST%>";
	document.frmdoctor.prev_command.value="<%=Command.LAST%>";
	document.frmdoctor.action="doctor.jsp";
	document.frmdoctor.submit();
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

						<form name="frmdoctor" method ="post" action="">
				<input type="hidden" name="command" value="<%=iCommand%>">
				<input type="hidden" name="vectSize" value="<%=vectSize%>">
				<input type="hidden" name="start" value="<%=start%>">
				<input type="hidden" name="prev_command" value="<%=prevCommand%>">
				<input type="hidden" name="hidden_doctor_id" value="<%=oidDoctor%>">
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
						      <td height="14" valign="middle" colspan="3" class="comment">&nbsp;Doctor
						       List </td>
						  </tr>
						  <%
							try{
								if (listDoctor.size()>0){
							%>
						  <tr align="left" valign="top">
						        <td height="22" valign="middle" colspan="3"> <%= drawList(listDoctor,oidDoctor)%> </td>
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
							 <%if((iCommand ==Command.ADD)||(iCommand==Command.SAVE)&&(jspDoctor.errorSize()>0)||(iCommand==Command.EDIT)||(iCommand==Command.ASK)){%>
								 <table width="100%" border="0" cellspacing="1" cellpadding="0">
					      <tr align="left" valign="top">
					         <td height="21" valign="middle" width="17%">&nbsp;</td>
					         <td height="21" colspan="2" width="83%" class="comment">*)= required</td>
					      </tr>
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Title</td>
					       <td height="21" colspan="2" width="83%">
					   <% Vector title_value = new Vector(1,1);
						Vector title_key = new Vector(1,1);
					 	String sel_title = ""+doctor.getTitle();
					   title_key.add("---select---");
					   title_value.add("");
					   %>
						<%= ControlCombo.draw(jspDoctor.fieldNames[JspDoctor.FRM_FIELD_TITLE],null, sel_title, title_key, title_value, "", "formElemen") %>
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Name</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspDoctor.fieldNames[JspDoctor.FRM_FIELD_NAME] %>"  value="<%= doctor.getName() %>" class="formElemen">
						* <%= jspDoctor.getErrorMsg(JspDoctor.FRM_FIELD_NAME) %>
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Specialty Id</td>
					       <td height="21" colspan="2" width="83%">
					   <% Vector specialtyid_value = new Vector(1,1);
						Vector specialtyid_key = new Vector(1,1);
					 	String sel_specialtyid = ""+doctor.getSpecialtyId();
					   specialtyid_key.add("---select---");
					   specialtyid_value.add("");
					   %>
						<%= ControlCombo.draw(jspDoctor.fieldNames[JspDoctor.FRM_FIELD_SPECIALTY_ID],null, sel_specialtyid, specialtyid_key, specialtyid_value, "", "formElemen") %>
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Ssn</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspDoctor.fieldNames[JspDoctor.FRM_FIELD_SSN] %>"  value="<%= doctor.getSsn() %>" class="formElemen">
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Degree</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspDoctor.fieldNames[JspDoctor.FRM_FIELD_DEGREE] %>"  value="<%= doctor.getDegree() %>" class="formElemen">
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Email</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspDoctor.fieldNames[JspDoctor.FRM_FIELD_EMAIL] %>"  value="<%= doctor.getEmail() %>" class="formElemen">
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Address</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspDoctor.fieldNames[JspDoctor.FRM_FIELD_ADDRESS] %>"  value="<%= doctor.getAddress() %>" class="formElemen">
						* <%= jspDoctor.getErrorMsg(JspDoctor.FRM_FIELD_ADDRESS) %>
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">State Id</td>
					       <td height="21" colspan="2" width="83%">
					   <% Vector stateid_value = new Vector(1,1);
						Vector stateid_key = new Vector(1,1);
					 	String sel_stateid = ""+doctor.getStateId();
					   stateid_key.add("---select---");
					   stateid_value.add("");
					   %>
						<%= ControlCombo.draw(jspDoctor.fieldNames[JspDoctor.FRM_FIELD_STATE_ID],null, sel_stateid, stateid_key, stateid_value, "", "formElemen") %>
						* <%= jspDoctor.getErrorMsg(JspDoctor.FRM_FIELD_STATE_ID) %>
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Country Id</td>
					       <td height="21" colspan="2" width="83%">
					   <% Vector countryid_value = new Vector(1,1);
						Vector countryid_key = new Vector(1,1);
					 	String sel_countryid = ""+doctor.getCountryId();
					   countryid_key.add("---select---");
					   countryid_value.add("");
					   %>
						<%= ControlCombo.draw(jspDoctor.fieldNames[JspDoctor.FRM_FIELD_COUNTRY_ID],null, sel_countryid, countryid_key, countryid_value, "", "formElemen") %>
						* <%= jspDoctor.getErrorMsg(JspDoctor.FRM_FIELD_COUNTRY_ID) %>
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Zip</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspDoctor.fieldNames[JspDoctor.FRM_FIELD_ZIP] %>"  value="<%= doctor.getZip() %>" class="formElemen">
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Fax</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspDoctor.fieldNames[JspDoctor.FRM_FIELD_FAX] %>"  value="<%= doctor.getFax() %>" class="formElemen">
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Phone</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspDoctor.fieldNames[JspDoctor.FRM_FIELD_PHONE] %>"  value="<%= doctor.getPhone() %>" class="formElemen">
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Mobile</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspDoctor.fieldNames[JspDoctor.FRM_FIELD_MOBILE] %>"  value="<%= doctor.getMobile() %>" class="formElemen">
						* <%= jspDoctor.getErrorMsg(JspDoctor.FRM_FIELD_MOBILE) %>
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
									String scomDel = "javascript:cmdAsk('"+oidDoctor+"')";
									String sconDelCom = "javascript:cmdConfirmDelete('"+oidDoctor+"')";
									String scancel = "javascript:cmdEdit('"+oidDoctor+"')";
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
