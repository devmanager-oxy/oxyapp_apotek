<% 
/* 
 * Page Name  		:  location.jsp
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

	public String drawList(int iJSPCommand,JspLocation frmObject, Location objEntity, Vector objectClass,  long locationId)

	{
		JSPList jsplist = new JSPList();
		jsplist.setAreaWidth("100%");
		jsplist.setListStyle("listgen");
		jsplist.setTitleStyle("tableheader");
		jsplist.setCellStyle("cellStyle");
		jsplist.setHeaderStyle("tableheader");
		jsplist.addHeader("Type","14%");
		jsplist.addHeader("Name","14%");
		jsplist.addHeader("Address Street","14%");
		jsplist.addHeader("Address Country","14%");
		jsplist.addHeader("Address City","14%");
		jsplist.addHeader("Telp","14%");
		jsplist.addHeader("Pic","14%");

		jsplist.setLinkRow(0);
		jsplist.setLinkSufix("");
		Vector lstData = jsplist.getData();
		Vector lstLinkData = jsplist.getLinkData();
		Vector rowx = new Vector(1,1);
		jsplist.reset();
		int index = -1;
		String whereCls = "";
		String orderCls = "";

		/* selected Type*/
		Vector type_value = new Vector(1,1);
		Vector type_key = new Vector(1,1);
		type_value.add("");
		type_key.add("---select---");

		for (int i = 0; i < objectClass.size(); i++) {
			 Location location = (Location)objectClass.get(i);
			 rowx = new Vector();
			 if(locationId == location.getOID())
				 index = i; 

			 if(index == i && (iJSPCommand == JSPCommand.EDIT || iJSPCommand == JSPCommand.ASK)){
					
				rowx.add(JSPCombo.draw(frmObject.colNames[JspLocation.JSP_TYPE],null, ""+location.getType(), type_value , type_key, "formElemen", ""));
				rowx.add("<input type=\"text\" name=\""+frmObject.colNames[JspLocation.JSP_NAME] +"\" value=\""+location.getName()+"\" class=\"formElemen\">");
				rowx.add("<input type=\"text\" name=\""+frmObject.colNames[JspLocation.JSP_ADDRESS_STREET] +"\" value=\""+location.getAddressStreet()+"\" class=\"formElemen\">");
				rowx.add("<input type=\"text\" name=\""+frmObject.colNames[JspLocation.JSP_ADDRESS_COUNTRY] +"\" value=\""+location.getAddressCountry()+"\" class=\"formElemen\">");
				rowx.add("<input type=\"text\" name=\""+frmObject.colNames[JspLocation.JSP_ADDRESS_CITY] +"\" value=\""+location.getAddressCity()+"\" class=\"formElemen\">");
				rowx.add("<input type=\"text\" name=\""+frmObject.colNames[JspLocation.JSP_TELP] +"\" value=\""+location.getTelp()+"\" class=\"formElemen\">");
				rowx.add("<input type=\"text\" name=\""+frmObject.colNames[JspLocation.JSP_PIC] +"\" value=\""+location.getPic()+"\" class=\"formElemen\">");
			}else{
				rowx.add("<a href=\"javascript:cmdEdit('"+String.valueOf(location.getOID())+"')\">"+location.getType()+"</a>");
				rowx.add(location.getName());
				rowx.add(location.getAddressStreet());
				rowx.add(location.getAddressCountry());
				rowx.add(location.getAddressCity());
				rowx.add(location.getTelp());
				rowx.add(location.getPic());
			} 

			lstData.add(rowx);
		}

		 rowx = new Vector();

		if(iJSPCommand == JSPCommand.ADD || (iJSPCommand == JSPCommand.SAVE && frmObject.errorSize() > 0)){ 
				rowx.add(JSPCombo.draw(frmObject.colNames[JspLocation.JSP_TYPE],null, ""+objEntity.getType(), type_value , type_key, "formElemen", ""));
				rowx.add("<input type=\"text\" name=\""+frmObject.colNames[JspLocation.JSP_NAME] +"\" value=\""+objEntity.getName()+"\" class=\"formElemen\">");
				rowx.add("<input type=\"text\" name=\""+frmObject.colNames[JspLocation.JSP_ADDRESS_STREET] +"\" value=\""+objEntity.getAddressStreet()+"\" class=\"formElemen\">");
				rowx.add("<input type=\"text\" name=\""+frmObject.colNames[JspLocation.JSP_ADDRESS_COUNTRY] +"\" value=\""+objEntity.getAddressCountry()+"\" class=\"formElemen\">");
				rowx.add("<input type=\"text\" name=\""+frmObject.colNames[JspLocation.JSP_ADDRESS_CITY] +"\" value=\""+objEntity.getAddressCity()+"\" class=\"formElemen\">");
				rowx.add("<input type=\"text\" name=\""+frmObject.colNames[JspLocation.JSP_TELP] +"\" value=\""+objEntity.getTelp()+"\" class=\"formElemen\">");
				rowx.add("<input type=\"text\" name=\""+frmObject.colNames[JspLocation.JSP_PIC] +"\" value=\""+objEntity.getPic()+"\" class=\"formElemen\">");

		}

		lstData.add(rowx);

		return jsplist.draw();
	}

%>
<%
int iJSPCommand = JSPRequestValue.requestCommand(request);
int start = JSPRequestValue.requestInt(request, "start");
int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
long oidLocation = JSPRequestValue.requestLong(request, "hidden_location_id");

/*variable declaration*/
int recordToGet = 10;
String msgString = "";
int iErrCode = JSPMessage.NONE;
String whereClause = "";
String orderClause = "";

CmdLocation ctrlLocation = new CmdLocation(request);
JSPLine ctrLine = new JSPLine();
Vector listLocation = new Vector(1,1);

/*switch statement */
iErrCode = ctrlLocation.action(iJSPCommand , oidLocation);
/* end switch*/
JspLocation jspLocation = ctrlLocation.getForm();

/*count list All Location*/
int vectSize = DbLocation.getCount(whereClause);

/*switch list Location*/
if((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV )||
  (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)){
		start = ctrlLocation.actionList(iJSPCommand, start, vectSize, recordToGet);
 } 
/* end switch list*/

Location location = ctrlLocation.getLocation();
msgString =  ctrlLocation.getMessage();

/* get record to display */
listLocation = DbLocation.list(start,recordToGet, whereClause , orderClause);

/*handle condition if size of record to display = 0 and start > 0 	after delete*/
if (listLocation.size() < 1 && start > 0)
{
	 if (vectSize - recordToGet > recordToGet)
			start = start - recordToGet;   //go to JSPCommand.PREV
	 else{
		 start = 0 ;
		 iJSPCommand = JSPCommand.FIRST;
		 prevJSPCommand = JSPCommand.FIRST; //go to JSPCommand.FIRST
	 }
	 listLocation = DbLocation.list(start,recordToGet, whereClause , orderClause);
}
%>


<html><!-- #BeginTemplate "/Templates/main.dwt" -->
<head>
<!-- #BeginEditable "doctitle" -->
<title>ccs--</title>
<script language="JavaScript">


function cmdAdd(){
	document.frmlocation.hidden_location_id.value="0";
	document.frmlocation.command.value="<%=JSPCommand.ADD%>";
	document.frmlocation.prev_command.value="<%=prevJSPCommand%>";
	document.frmlocation.action="location.jsp";
	document.frmlocation.submit();
}

function cmdAsk(oidLocation){
	document.frmlocation.hidden_location_id.value=oidLocation;
	document.frmlocation.command.value="<%=JSPCommand.ASK%>";
	document.frmlocation.prev_command.value="<%=prevJSPCommand%>";
	document.frmlocation.action="location.jsp";
	document.frmlocation.submit();
}

function cmdConfirmDelete(oidLocation){
	document.frmlocation.hidden_location_id.value=oidLocation;
	document.frmlocation.command.value="<%=JSPCommand.DELETE%>";
	document.frmlocation.prev_command.value="<%=prevJSPCommand%>";
	document.frmlocation.action="location.jsp";
	document.frmlocation.submit();
}

function cmdSave(){
	document.frmlocation.command.value="<%=JSPCommand.SAVE%>";
	document.frmlocation.prev_command.value="<%=prevJSPCommand%>";
	document.frmlocation.action="location.jsp";
	document.frmlocation.submit();
}

function cmdEdit(oidLocation){
	document.frmlocation.hidden_location_id.value=oidLocation;
	document.frmlocation.command.value="<%=JSPCommand.EDIT%>";
	document.frmlocation.prev_command.value="<%=prevJSPCommand%>";
	document.frmlocation.action="location.jsp";
	document.frmlocation.submit();
}

function cmdCancel(oidLocation){
	document.frmlocation.hidden_location_id.value=oidLocation;
	document.frmlocation.command.value="<%=JSPCommand.EDIT%>";
	document.frmlocation.prev_command.value="<%=prevJSPCommand%>";
	document.frmlocation.action="location.jsp";
	document.frmlocation.submit();
}

function cmdBack(){
	document.frmlocation.command.value="<%=JSPCommand.BACK%>";
	document.frmlocation.action="location.jsp";
	document.frmlocation.submit();
}

function cmdListFirst(){
	document.frmlocation.command.value="<%=JSPCommand.FIRST%>";
	document.frmlocation.prev_command.value="<%=JSPCommand.FIRST%>";
	document.frmlocation.action="location.jsp";
	document.frmlocation.submit();
}

function cmdListPrev(){
	document.frmlocation.command.value="<%=JSPCommand.PREV%>";
	document.frmlocation.prev_command.value="<%=JSPCommand.PREV%>";
	document.frmlocation.action="location.jsp";
	document.frmlocation.submit();
}

function cmdListNext(){
	document.frmlocation.command.value="<%=JSPCommand.NEXT%>";
	document.frmlocation.prev_command.value="<%=JSPCommand.NEXT%>";
	document.frmlocation.action="location.jsp";
	document.frmlocation.submit();
}

function cmdListLast(){
	document.frmlocation.command.value="<%=JSPCommand.LAST%>";
	document.frmlocation.prev_command.value="<%=JSPCommand.LAST%>";
	document.frmlocation.action="location.jsp";
	document.frmlocation.submit();
}

//-------------- script form image -------------------

function cmdDelPict(oidLocation){
	document.frmimage.hidden_location_id.value=oidLocation;
	document.frmimage.command.value="<%=JSPCommand.POST%>";
	document.frmimage.action="location.jsp";
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

						<form name="frmlocation" method ="post" action="">
				<input type="hidden" name="command" value="<%=iJSPCommand%>">
				<input type="hidden" name="vectSize" value="<%=vectSize%>">
				<input type="hidden" name="start" value="<%=start%>">
				<input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
				<input type="hidden" name="hidden_location_id" value="<%=oidLocation%>">
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
						      <td height="14" valign="middle" colspan="3" class="comment">&nbsp;Location
						       List </td>
						  </tr>
						  <%
							try{
							%>
						  <tr align="left" valign="top">
						        <td height="22" valign="middle" colspan="3"> <%= drawList(iJSPCommand,jspLocation, location,listLocation,oidLocation)%> </td>
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
									String scomDel = "javascript:cmdAsk('"+oidLocation+"')";
									String sconDelCom = "javascript:cmdConfirmDelete('"+oidLocation+"')";
									String scancel = "javascript:cmdEdit('"+oidLocation+"')";
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
