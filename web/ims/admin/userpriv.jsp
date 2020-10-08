<% 
/* 
 * Page Name  		:  userpriv.jsp
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
<%@ page import = "com.dimata.finance.entity.admin.*" %>
<%@ page import = "com.dimata.finance.form.admin.*" %>
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

	public String drawList(Vector objectClass ,  long privId)

	{
		ControlList ctrlist = new ControlList();
		ctrlist.setAreaWidth("100%");
		ctrlist.setListStyle("listgen");
		ctrlist.setTitleStyle("tableheader");
		ctrlist.setCellStyle("cellStyle");
		ctrlist.setHeaderStyle("tableheader");
		ctrlist.addHeader("Mn 1","12%");
		ctrlist.addHeader("Mn 2","12%");
		ctrlist.addHeader("Cmd Add","12%");
		ctrlist.addHeader("Cmd Edit","12%");
		ctrlist.addHeader("Cmd View","12%");
		ctrlist.addHeader("Cmd Delete","12%");
		ctrlist.addHeader("Group Id","12%");
		ctrlist.addHeader("User Id","12%");

		ctrlist.setLinkRow(0);
		ctrlist.setLinkSufix("");
		Vector lstData = ctrlist.getData();
		Vector lstLinkData = ctrlist.getLinkData();
		ctrlist.setLinkPrefix("javascript:cmdEdit('");
		ctrlist.setLinkSufix("')");
		ctrlist.reset();
		int index = -1;

		for (int i = 0; i < objectClass.size(); i++) {
			UserPriv userPriv = (UserPriv)objectClass.get(i);
			 Vector rowx = new Vector();
			 if(privId == userPriv.getOID())
				 index = i;

			rowx.add(String.valueOf(userPriv.getMn1()));

			rowx.add(String.valueOf(userPriv.getMn2()));

			rowx.add(String.valueOf(userPriv.getCmdAdd()));

			rowx.add(String.valueOf(userPriv.getCmdEdit()));

			rowx.add(String.valueOf(userPriv.getCmdView()));

			rowx.add(String.valueOf(userPriv.getCmdDelete()));

			rowx.add(String.valueOf(userPriv.getGroupId()));

			rowx.add(String.valueOf(userPriv.getUserId()));

			lstData.add(rowx);
			lstLinkData.add(String.valueOf(userPriv.getOID()));
		}

		return ctrlist.drawList(index);
	}

%>
<%
int iCommand = FRMQueryString.requestCommand(request);
int start = FRMQueryString.requestInt(request, "start");
int prevCommand = FRMQueryString.requestInt(request, "prev_command");
long oidUserPriv = FRMQueryString.requestLong(request, "hidden_priv_id");

/*variable declaration*/
int recordToGet = 10;
String msgString = "";
int iErrCode = FRMMessage.NONE;
String whereClause = "";
String orderClause = "";

CtrlUserPriv ctrlUserPriv = new CtrlUserPriv(request);
ControlLine ctrLine = new ControlLine();
Vector listUserPriv = new Vector(1,1);

/*switch statement */
iErrCode = ctrlUserPriv.action(iCommand , oidUserPriv);
/* end switch*/
JspUserPriv jspUserPriv = ctrlUserPriv.getForm();

/*count list All UserPriv*/
int vectSize = PstUserPriv.getCount(whereClause);

UserPriv userPriv = ctrlUserPriv.getUserPriv();
msgString =  ctrlUserPriv.getMessage();

/*switch list UserPriv*/
if((iCommand == Command.SAVE) && (iErrCode == FRMMessage.NONE))
	start = PstUserPriv.generateFindStart(userPriv.getOID(),recordToGet, whereClause);

if((iCommand == Command.FIRST || iCommand == Command.PREV )||
  (iCommand == Command.NEXT || iCommand == Command.LAST)){
		start = ctrlUserPriv.actionList(iCommand, start, vectSize, recordToGet);
 } 
/* end switch list*/

/* get record to display */
listUserPriv = PstUserPriv.list(start,recordToGet, whereClause , orderClause);

/*handle condition if size of record to display = 0 and start > 0 	after delete*/
if (listUserPriv.size() < 1 && start > 0)
{
	 if (vectSize - recordToGet > recordToGet)
			start = start - recordToGet;   //go to Command.PREV
	 else{
		 start = 0 ;
		 iCommand = Command.FIRST;
		 prevCommand = Command.FIRST; //go to Command.FIRST
	 }
	 listUserPriv = PstUserPriv.list(start,recordToGet, whereClause , orderClause);
}
%>


<html><!-- #BeginTemplate "/Templates/main.dwt" -->
<head>
<!-- #BeginEditable "doctitle" -->
<title>finance--</title>
<script language="JavaScript">


function cmdAdd(){
	document.frmuserpriv.hidden_priv_id.value="0";
	document.frmuserpriv.command.value="<%=Command.ADD%>";
	document.frmuserpriv.prev_command.value="<%=prevCommand%>";
	document.frmuserpriv.action="userpriv.jsp";
	document.frmuserpriv.submit();
}

function cmdAsk(oidUserPriv){
	document.frmuserpriv.hidden_priv_id.value=oidUserPriv;
	document.frmuserpriv.command.value="<%=Command.ASK%>";
	document.frmuserpriv.prev_command.value="<%=prevCommand%>";
	document.frmuserpriv.action="userpriv.jsp";
	document.frmuserpriv.submit();
}

function cmdConfirmDelete(oidUserPriv){
	document.frmuserpriv.hidden_priv_id.value=oidUserPriv;
	document.frmuserpriv.command.value="<%=Command.DELETE%>";
	document.frmuserpriv.prev_command.value="<%=prevCommand%>";
	document.frmuserpriv.action="userpriv.jsp";
	document.frmuserpriv.submit();
}
function cmdSave(){
	document.frmuserpriv.command.value="<%=Command.SAVE%>";
	document.frmuserpriv.prev_command.value="<%=prevCommand%>";
	document.frmuserpriv.action="userpriv.jsp";
	document.frmuserpriv.submit();
	}

function cmdEdit(oidUserPriv){
	document.frmuserpriv.hidden_priv_id.value=oidUserPriv;
	document.frmuserpriv.command.value="<%=Command.EDIT%>";
	document.frmuserpriv.prev_command.value="<%=prevCommand%>";
	document.frmuserpriv.action="userpriv.jsp";
	document.frmuserpriv.submit();
	}

function cmdCancel(oidUserPriv){
	document.frmuserpriv.hidden_priv_id.value=oidUserPriv;
	document.frmuserpriv.command.value="<%=Command.EDIT%>";
	document.frmuserpriv.prev_command.value="<%=prevCommand%>";
	document.frmuserpriv.action="userpriv.jsp";
	document.frmuserpriv.submit();
}

function cmdBack(){
	document.frmuserpriv.command.value="<%=Command.BACK%>";
	document.frmuserpriv.action="userpriv.jsp";
	document.frmuserpriv.submit();
	}

function cmdListFirst(){
	document.frmuserpriv.command.value="<%=Command.FIRST%>";
	document.frmuserpriv.prev_command.value="<%=Command.FIRST%>";
	document.frmuserpriv.action="userpriv.jsp";
	document.frmuserpriv.submit();
}

function cmdListPrev(){
	document.frmuserpriv.command.value="<%=Command.PREV%>";
	document.frmuserpriv.prev_command.value="<%=Command.PREV%>";
	document.frmuserpriv.action="userpriv.jsp";
	document.frmuserpriv.submit();
	}

function cmdListNext(){
	document.frmuserpriv.command.value="<%=Command.NEXT%>";
	document.frmuserpriv.prev_command.value="<%=Command.NEXT%>";
	document.frmuserpriv.action="userpriv.jsp";
	document.frmuserpriv.submit();
}

function cmdListLast(){
	document.frmuserpriv.command.value="<%=Command.LAST%>";
	document.frmuserpriv.prev_command.value="<%=Command.LAST%>";
	document.frmuserpriv.action="userpriv.jsp";
	document.frmuserpriv.submit();
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

						<form name="frmuserpriv" method ="post" action="">
				<input type="hidden" name="command" value="<%=iCommand%>">
				<input type="hidden" name="vectSize" value="<%=vectSize%>">
				<input type="hidden" name="start" value="<%=start%>">
				<input type="hidden" name="prev_command" value="<%=prevCommand%>">
				<input type="hidden" name="hidden_priv_id" value="<%=oidUserPriv%>">
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
						      <td height="14" valign="middle" colspan="3" class="comment">&nbsp;UserPriv
						       List </td>
						  </tr>
						  <%
							try{
								if (listUserPriv.size()>0){
							%>
						  <tr align="left" valign="top">
						        <td height="22" valign="middle" colspan="3"> <%= drawList(listUserPriv,oidUserPriv)%> </td>
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
							 <%if((iCommand ==Command.ADD)||(iCommand==Command.SAVE)&&(jspUserPriv.errorSize()>0)||(iCommand==Command.EDIT)||(iCommand==Command.ASK)){%>
								 <table width="100%" border="0" cellspacing="1" cellpadding="0">
					      <tr align="left" valign="top">
					         <td height="21" valign="middle" width="17%">&nbsp;</td>
					         <td height="21" colspan="2" width="83%" class="comment">*)= required</td>
					      </tr>
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Mn 1</td>
					       <td height="21" colspan="2" width="83%">
					   <% Vector mn1_value = new Vector(1,1);
						Vector mn1_key = new Vector(1,1);
					 	String sel_mn1 = ""+userPriv.getMn1();
					   mn1_key.add("---select---");
					   mn1_value.add("");
					   %>
						<%= ControlCombo.draw(jspUserPriv.fieldNames[JspUserPriv.FRM_FIELD_MN_1],null, sel_mn1, mn1_key, mn1_value, "", "formElemen") %>
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Mn 2</td>
					       <td height="21" colspan="2" width="83%">
					   <% Vector mn2_value = new Vector(1,1);
						Vector mn2_key = new Vector(1,1);
					 	String sel_mn2 = ""+userPriv.getMn2();
					   mn2_key.add("---select---");
					   mn2_value.add("");
					   %>
						<%= ControlCombo.draw(jspUserPriv.fieldNames[JspUserPriv.FRM_FIELD_MN_2],null, sel_mn2, mn2_key, mn2_value, "", "formElemen") %>
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Cmd Add</td>
					       <td height="21" colspan="2" width="83%">
					   <% Vector cmdadd_value = new Vector(1,1);
						Vector cmdadd_key = new Vector(1,1);
					 	String sel_cmdadd = ""+userPriv.getCmdAdd();
					   cmdadd_key.add("---select---");
					   cmdadd_value.add("");
					   %>
						<%= ControlCombo.draw(jspUserPriv.fieldNames[JspUserPriv.FRM_FIELD_CMD_ADD],null, sel_cmdadd, cmdadd_key, cmdadd_value, "", "formElemen") %>
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Cmd Edit</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspUserPriv.fieldNames[JspUserPriv.FRM_FIELD_CMD_EDIT] %>"  value="<%= userPriv.getCmdEdit() %>" class="formElemen">
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Cmd View</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspUserPriv.fieldNames[JspUserPriv.FRM_FIELD_CMD_VIEW] %>"  value="<%= userPriv.getCmdView() %>" class="formElemen">
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Cmd Delete</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspUserPriv.fieldNames[JspUserPriv.FRM_FIELD_CMD_DELETE] %>"  value="<%= userPriv.getCmdDelete() %>" class="formElemen">
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Group Id</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspUserPriv.fieldNames[JspUserPriv.FRM_FIELD_GROUP_ID] %>"  value="<%= userPriv.getGroupId() %>" class="formElemen">
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">User Id</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspUserPriv.fieldNames[JspUserPriv.FRM_FIELD_USER_ID] %>"  value="<%= userPriv.getUserId() %>" class="formElemen">
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
									String scomDel = "javascript:cmdAsk('"+oidUserPriv+"')";
									String sconDelCom = "javascript:cmdConfirmDelete('"+oidUserPriv+"')";
									String scancel = "javascript:cmdEdit('"+oidUserPriv+"')";
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
