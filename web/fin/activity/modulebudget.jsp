<% 
/* 
 * Page Name  		:  modulebudget.jsp
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

<!--package sia-btdc -->
<%@ page import = "com.dimata.sia-btdc.entity.master.*" %>
<%@ page import = "com.dimata.sia-btdc.form.master.*" %>
<%@ page import = "com.dimata.sia-btdc.entity.admin.*" %>
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

	public String drawList(int iCommand,JspModuleBudget frmObject, ModuleBudget objEntity, Vector objectClass,  long moduleBudgetId)

	{
		ControlList ctrlist = new ControlList();
		ctrlist.setAreaWidth("100%");
		ctrlist.setListStyle("listgen");
		ctrlist.setTitleStyle("tableheader");
		ctrlist.setCellStyle("cellStyle");
		ctrlist.setHeaderStyle("tableheader");
		ctrlist.addHeader("Coa Id","25%");
		ctrlist.addHeader("Description","25%");
		ctrlist.addHeader("Currency Id","25%");
		ctrlist.addHeader("Module Id","25%");

		ctrlist.setLinkRow(0);
		ctrlist.setLinkSufix("");
		Vector lstData = ctrlist.getData();
		Vector lstLinkData = ctrlist.getLinkData();
		Vector rowx = new Vector(1,1);
		ctrlist.reset();
		int index = -1;
		String whereCls = "";
		String orderCls = "";

		/* selected CoaId*/
		Vector coaid_value = new Vector(1,1);
		Vector coaid_key = new Vector(1,1);
		coaid_value.add("");
		coaid_key.add("---select---");

		/* selected CurrencyId*/
		Vector currencyid_value = new Vector(1,1);
		Vector currencyid_key = new Vector(1,1);
		currencyid_value.add("");
		currencyid_key.add("---select---");

		for (int i = 0; i < objectClass.size(); i++) {
			 ModuleBudget moduleBudget = (ModuleBudget)objectClass.get(i);
			 rowx = new Vector();
			 if(moduleBudgetId == moduleBudget.getOID())
				 index = i; 

			 if(index == i && (iCommand == Command.EDIT || iCommand == Command.ASK)){
					
				rowx.add(ControlCombo.draw(frmObject.fieldNames[JspModuleBudget.FRM_FIELD_COA_ID],null, ""+moduleBudget.getCoaId(), coaid_value , coaid_key, "formElemen", ""));
				rowx.add("<input type=\"text\" name=\""+frmObject.fieldNames[JspModuleBudget.FRM_FIELD_DESCRIPTION] +"\" value=\""+moduleBudget.getDescription()+"\" class=\"formElemen\">");
				rowx.add(ControlCombo.draw(frmObject.fieldNames[JspModuleBudget.FRM_FIELD_CURRENCY_ID],null, ""+moduleBudget.getCurrencyId(), currencyid_value , currencyid_key, "formElemen", ""));
				rowx.add("<input type=\"text\" name=\""+frmObject.fieldNames[JspModuleBudget.FRM_FIELD_MODULE_ID] +"\" value=\""+moduleBudget.getModuleId()+"\" class=\"formElemen\">");
			}else{
				rowx.add("<a href=\"javascript:cmdEdit('"+String.valueOf(moduleBudget.getOID())+"')\">"+String.valueOf(moduleBudget.getCoaId())+"</a>");
				rowx.add(moduleBudget.getDescription());
				rowx.add(String.valueOf(moduleBudget.getCurrencyId()));
				rowx.add(String.valueOf(moduleBudget.getModuleId()));
			} 

			lstData.add(rowx);
		}

		 rowx = new Vector();

		if(iCommand == Command.ADD || (iCommand == Command.SAVE && frmObject.errorSize() > 0)){ 
				rowx.add(ControlCombo.draw(frmObject.fieldNames[JspModuleBudget.FRM_FIELD_COA_ID],null, ""+objEntity.getCoaId(), coaid_value , coaid_key, "formElemen", ""));
				rowx.add("<input type=\"text\" name=\""+frmObject.fieldNames[JspModuleBudget.FRM_FIELD_DESCRIPTION] +"\" value=\""+objEntity.getDescription()+"\" class=\"formElemen\">");
				rowx.add(ControlCombo.draw(frmObject.fieldNames[JspModuleBudget.FRM_FIELD_CURRENCY_ID],null, ""+objEntity.getCurrencyId(), currencyid_value , currencyid_key, "formElemen", ""));
				rowx.add("<input type=\"text\" name=\""+frmObject.fieldNames[JspModuleBudget.FRM_FIELD_MODULE_ID] +"\" value=\""+objEntity.getModuleId()+"\" class=\"formElemen\">");

		}

		lstData.add(rowx);

		return ctrlist.draw();
	}

%>
<%
int iCommand = FRMQueryString.requestCommand(request);
int start = FRMQueryString.requestInt(request, "start");
int prevCommand = FRMQueryString.requestInt(request, "prev_command");
long oidModuleBudget = FRMQueryString.requestLong(request, "hidden_module_budget_id");

/*variable declaration*/
int recordToGet = 10;
String msgString = "";
int iErrCode = FRMMessage.NONE;
String whereClause = "";
String orderClause = "";

CtrlModuleBudget ctrlModuleBudget = new CtrlModuleBudget(request);
ControlLine ctrLine = new ControlLine();
Vector listModuleBudget = new Vector(1,1);

/*switch statement */
iErrCode = ctrlModuleBudget.action(iCommand , oidModuleBudget);
/* end switch*/
JspModuleBudget jspModuleBudget = ctrlModuleBudget.getForm();

/*count list All ModuleBudget*/
int vectSize = PstModuleBudget.getCount(whereClause);

/*switch list ModuleBudget*/
if((iCommand == Command.FIRST || iCommand == Command.PREV )||
  (iCommand == Command.NEXT || iCommand == Command.LAST)){
		start = ctrlModuleBudget.actionList(iCommand, start, vectSize, recordToGet);
 } 
/* end switch list*/

ModuleBudget moduleBudget = ctrlModuleBudget.getModuleBudget();
msgString =  ctrlModuleBudget.getMessage();

/* get record to display */
listModuleBudget = PstModuleBudget.list(start,recordToGet, whereClause , orderClause);

/*handle condition if size of record to display = 0 and start > 0 	after delete*/
if (listModuleBudget.size() < 1 && start > 0)
{
	 if (vectSize - recordToGet > recordToGet)
			start = start - recordToGet;   //go to Command.PREV
	 else{
		 start = 0 ;
		 iCommand = Command.FIRST;
		 prevCommand = Command.FIRST; //go to Command.FIRST
	 }
	 listModuleBudget = PstModuleBudget.list(start,recordToGet, whereClause , orderClause);
}
%>


<html><!-- #BeginTemplate "/Templates/main.dwt" -->
<head>
<!-- #BeginEditable "doctitle" -->
<title>sia-btdc--</title>
<script language="JavaScript">


function cmdAdd(){
	document.frmmodulebudget.hidden_module_budget_id.value="0";
	document.frmmodulebudget.command.value="<%=Command.ADD%>";
	document.frmmodulebudget.prev_command.value="<%=prevCommand%>";
	document.frmmodulebudget.action="modulebudget.jsp";
	document.frmmodulebudget.submit();
}

function cmdAsk(oidModuleBudget){
	document.frmmodulebudget.hidden_module_budget_id.value=oidModuleBudget;
	document.frmmodulebudget.command.value="<%=Command.ASK%>";
	document.frmmodulebudget.prev_command.value="<%=prevCommand%>";
	document.frmmodulebudget.action="modulebudget.jsp";
	document.frmmodulebudget.submit();
}

function cmdConfirmDelete(oidModuleBudget){
	document.frmmodulebudget.hidden_module_budget_id.value=oidModuleBudget;
	document.frmmodulebudget.command.value="<%=Command.DELETE%>";
	document.frmmodulebudget.prev_command.value="<%=prevCommand%>";
	document.frmmodulebudget.action="modulebudget.jsp";
	document.frmmodulebudget.submit();
}

function cmdSave(){
	document.frmmodulebudget.command.value="<%=Command.SAVE%>";
	document.frmmodulebudget.prev_command.value="<%=prevCommand%>";
	document.frmmodulebudget.action="modulebudget.jsp";
	document.frmmodulebudget.submit();
}

function cmdEdit(oidModuleBudget){
	document.frmmodulebudget.hidden_module_budget_id.value=oidModuleBudget;
	document.frmmodulebudget.command.value="<%=Command.EDIT%>";
	document.frmmodulebudget.prev_command.value="<%=prevCommand%>";
	document.frmmodulebudget.action="modulebudget.jsp";
	document.frmmodulebudget.submit();
}

function cmdCancel(oidModuleBudget){
	document.frmmodulebudget.hidden_module_budget_id.value=oidModuleBudget;
	document.frmmodulebudget.command.value="<%=Command.EDIT%>";
	document.frmmodulebudget.prev_command.value="<%=prevCommand%>";
	document.frmmodulebudget.action="modulebudget.jsp";
	document.frmmodulebudget.submit();
}

function cmdBack(){
	document.frmmodulebudget.command.value="<%=Command.BACK%>";
	document.frmmodulebudget.action="modulebudget.jsp";
	document.frmmodulebudget.submit();
}

function cmdListFirst(){
	document.frmmodulebudget.command.value="<%=Command.FIRST%>";
	document.frmmodulebudget.prev_command.value="<%=Command.FIRST%>";
	document.frmmodulebudget.action="modulebudget.jsp";
	document.frmmodulebudget.submit();
}

function cmdListPrev(){
	document.frmmodulebudget.command.value="<%=Command.PREV%>";
	document.frmmodulebudget.prev_command.value="<%=Command.PREV%>";
	document.frmmodulebudget.action="modulebudget.jsp";
	document.frmmodulebudget.submit();
}

function cmdListNext(){
	document.frmmodulebudget.command.value="<%=Command.NEXT%>";
	document.frmmodulebudget.prev_command.value="<%=Command.NEXT%>";
	document.frmmodulebudget.action="modulebudget.jsp";
	document.frmmodulebudget.submit();
}

function cmdListLast(){
	document.frmmodulebudget.command.value="<%=Command.LAST%>";
	document.frmmodulebudget.prev_command.value="<%=Command.LAST%>";
	document.frmmodulebudget.action="modulebudget.jsp";
	document.frmmodulebudget.submit();
}

//-------------- script form image -------------------

function cmdDelPict(oidModuleBudget){
	document.frmimage.hidden_module_budget_id.value=oidModuleBudget;
	document.frmimage.command.value="<%=Command.POST%>";
	document.frmimage.action="modulebudget.jsp";
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

						<form name="frmmodulebudget" method ="post" action="">
				<input type="hidden" name="command" value="<%=iCommand%>">
				<input type="hidden" name="vectSize" value="<%=vectSize%>">
				<input type="hidden" name="start" value="<%=start%>">
				<input type="hidden" name="prev_command" value="<%=prevCommand%>">
				<input type="hidden" name="hidden_module_budget_id" value="<%=oidModuleBudget%>">
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
						      <td height="14" valign="middle" colspan="3" class="comment">&nbsp;ModuleBudget
						       List </td>
						  </tr>
						  <%
							try{
							%>
						  <tr align="left" valign="top">
						        <td height="22" valign="middle" colspan="3"> <%= drawList(iCommand,jspModuleBudget, moduleBudget,listModuleBudget,oidModuleBudget)%> </td>
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
									String scomDel = "javascript:cmdAsk('"+oidModuleBudget+"')";
									String sconDelCom = "javascript:cmdConfirmDelete('"+oidModuleBudget+"')";
									String scancel = "javascript:cmdEdit('"+oidModuleBudget+"')";
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
