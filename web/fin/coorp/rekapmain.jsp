<% 
/* 
 * Page Name  		:  rekapmain.jsp
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
<%@ page import = "com.dimata.sipadu.entity.coorp.*" %>
<%@ page import = "com.dimata.sipadu.form.coorp.*" %>
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

<%!

	public String drawList(Vector objectClass ,  long rekapMainId)

	{
		ControlList ctrlist = new ControlList();
		ctrlist.setAreaWidth("100%");
		ctrlist.setListStyle("listgen");
		ctrlist.setTitleStyle("tableheader");
		ctrlist.setCellStyle("cellStyle");
		ctrlist.setHeaderStyle("tableheader");
		ctrlist.addHeader("Dinas Id","100%");

		ctrlist.setLinkRow(0);
		ctrlist.setLinkSufix("");
		Vector lstData = ctrlist.getData();
		Vector lstLinkData = ctrlist.getLinkData();
		ctrlist.setLinkPrefix("javascript:cmdEdit('");
		ctrlist.setLinkSufix("')");
		ctrlist.reset();
		int index = -1;

		for (int i = 0; i < objectClass.size(); i++) {
			RekapMain rekapMain = (RekapMain)objectClass.get(i);
			 Vector rowx = new Vector();
			 if(rekapMainId == rekapMain.getOID())
				 index = i;

			rowx.add(String.valueOf(rekapMain.getDinasId()));

			lstData.add(rowx);
			lstLinkData.add(String.valueOf(rekapMain.getOID()));
		}

		return ctrlist.drawList(index);
	}

%>
<%
int iCommand = FRMQueryString.requestCommand(request);
int start = FRMQueryString.requestInt(request, "start");
int prevCommand = FRMQueryString.requestInt(request, "prev_command");
long oidRekapMain = FRMQueryString.requestLong(request, "hidden_rekap_main_id");

/*variable declaration*/
int recordToGet = 10;
String msgString = "";
int iErrCode = FRMMessage.NONE;
String whereClause = "";
String orderClause = "";

CtrlRekapMain ctrlRekapMain = new CtrlRekapMain(request);
ControlLine ctrLine = new ControlLine();
Vector listRekapMain = new Vector(1,1);

/*switch statement */
iErrCode = ctrlRekapMain.action(iCommand , oidRekapMain);
/* end switch*/
JspRekapMain jspRekapMain = ctrlRekapMain.getForm();

/*count list All RekapMain*/
int vectSize = PstRekapMain.getCount(whereClause);

RekapMain rekapMain = ctrlRekapMain.getRekapMain();
msgString =  ctrlRekapMain.getMessage();

/*switch list RekapMain*/
if((iCommand == Command.SAVE) && (iErrCode == FRMMessage.NONE))
	start = PstRekapMain.generateFindStart(rekapMain.getOID(),recordToGet, whereClause);

if((iCommand == Command.FIRST || iCommand == Command.PREV )||
  (iCommand == Command.NEXT || iCommand == Command.LAST)){
		start = ctrlRekapMain.actionList(iCommand, start, vectSize, recordToGet);
 } 
/* end switch list*/

/* get record to display */
listRekapMain = PstRekapMain.list(start,recordToGet, whereClause , orderClause);

/*handle condition if size of record to display = 0 and start > 0 	after delete*/
if (listRekapMain.size() < 1 && start > 0)
{
	 if (vectSize - recordToGet > recordToGet)
			start = start - recordToGet;   //go to Command.PREV
	 else{
		 start = 0 ;
		 iCommand = Command.FIRST;
		 prevCommand = Command.FIRST; //go to Command.FIRST
	 }
	 listRekapMain = PstRekapMain.list(start,recordToGet, whereClause , orderClause);
}
%>


<html><!-- #BeginTemplate "/Templates/main.dwt" -->
<head>
<!-- #BeginEditable "doctitle" -->
<title>sipadu--</title>
<script language="JavaScript">


function cmdAdd(){
	document.frmrekapmain.hidden_rekap_main_id.value="0";
	document.frmrekapmain.command.value="<%=Command.ADD%>";
	document.frmrekapmain.prev_command.value="<%=prevCommand%>";
	document.frmrekapmain.action="rekapmain.jsp";
	document.frmrekapmain.submit();
}

function cmdAsk(oidRekapMain){
	document.frmrekapmain.hidden_rekap_main_id.value=oidRekapMain;
	document.frmrekapmain.command.value="<%=Command.ASK%>";
	document.frmrekapmain.prev_command.value="<%=prevCommand%>";
	document.frmrekapmain.action="rekapmain.jsp";
	document.frmrekapmain.submit();
}

function cmdConfirmDelete(oidRekapMain){
	document.frmrekapmain.hidden_rekap_main_id.value=oidRekapMain;
	document.frmrekapmain.command.value="<%=Command.DELETE%>";
	document.frmrekapmain.prev_command.value="<%=prevCommand%>";
	document.frmrekapmain.action="rekapmain.jsp";
	document.frmrekapmain.submit();
}
function cmdSave(){
	document.frmrekapmain.command.value="<%=Command.SAVE%>";
	document.frmrekapmain.prev_command.value="<%=prevCommand%>";
	document.frmrekapmain.action="rekapmain.jsp";
	document.frmrekapmain.submit();
	}

function cmdEdit(oidRekapMain){
	document.frmrekapmain.hidden_rekap_main_id.value=oidRekapMain;
	document.frmrekapmain.command.value="<%=Command.EDIT%>";
	document.frmrekapmain.prev_command.value="<%=prevCommand%>";
	document.frmrekapmain.action="rekapmain.jsp";
	document.frmrekapmain.submit();
	}

function cmdCancel(oidRekapMain){
	document.frmrekapmain.hidden_rekap_main_id.value=oidRekapMain;
	document.frmrekapmain.command.value="<%=Command.EDIT%>";
	document.frmrekapmain.prev_command.value="<%=prevCommand%>";
	document.frmrekapmain.action="rekapmain.jsp";
	document.frmrekapmain.submit();
}

function cmdBack(){
	document.frmrekapmain.command.value="<%=Command.BACK%>";
	document.frmrekapmain.action="rekapmain.jsp";
	document.frmrekapmain.submit();
	}

function cmdListFirst(){
	document.frmrekapmain.command.value="<%=Command.FIRST%>";
	document.frmrekapmain.prev_command.value="<%=Command.FIRST%>";
	document.frmrekapmain.action="rekapmain.jsp";
	document.frmrekapmain.submit();
}

function cmdListPrev(){
	document.frmrekapmain.command.value="<%=Command.PREV%>";
	document.frmrekapmain.prev_command.value="<%=Command.PREV%>";
	document.frmrekapmain.action="rekapmain.jsp";
	document.frmrekapmain.submit();
	}

function cmdListNext(){
	document.frmrekapmain.command.value="<%=Command.NEXT%>";
	document.frmrekapmain.prev_command.value="<%=Command.NEXT%>";
	document.frmrekapmain.action="rekapmain.jsp";
	document.frmrekapmain.submit();
}

function cmdListLast(){
	document.frmrekapmain.command.value="<%=Command.LAST%>";
	document.frmrekapmain.prev_command.value="<%=Command.LAST%>";
	document.frmrekapmain.action="rekapmain.jsp";
	document.frmrekapmain.submit();
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

						<form name="frmrekapmain" method ="post" action="">
				<input type="hidden" name="command" value="<%=iCommand%>">
				<input type="hidden" name="vectSize" value="<%=vectSize%>">
				<input type="hidden" name="start" value="<%=start%>">
				<input type="hidden" name="prev_command" value="<%=prevCommand%>">
				<input type="hidden" name="hidden_rekap_main_id" value="<%=oidRekapMain%>">
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
						      <td height="14" valign="middle" colspan="3" class="comment">&nbsp;RekapMain
						       List </td>
						  </tr>
						  <%
							try{
								if (listRekapMain.size()>0){
							%>
						  <tr align="left" valign="top">
						        <td height="22" valign="middle" colspan="3"> <%= drawList(listRekapMain,oidRekapMain)%> </td>
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
							 <%if((iCommand ==Command.ADD)||(iCommand==Command.SAVE)&&(jspRekapMain.errorSize()>0)||(iCommand==Command.EDIT)||(iCommand==Command.ASK)){%>
								 <table width="100%" border="0" cellspacing="1" cellpadding="0">
					      <tr align="left" valign="top">
					         <td height="21" valign="middle" width="17%">&nbsp;</td>
					         <td height="21" colspan="2" width="83%" class="comment">*)= required</td>
					      </tr>
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Dinas Id</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspRekapMain.fieldNames[JspRekapMain.FRM_FIELD_DINAS_ID] %>"  value="<%= rekapMain.getDinasId() %>" class="formElemen">
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Dinas Unit Id</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspRekapMain.fieldNames[JspRekapMain.FRM_FIELD_DINAS_UNIT_ID] %>"  value="<%= rekapMain.getDinasUnitId() %>" class="formElemen">
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Periode Rekap Id</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspRekapMain.fieldNames[JspRekapMain.FRM_FIELD_PERIODE_REKAP_ID] %>"  value="<%= rekapMain.getPeriodeRekapId() %>" class="formElemen">
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Status</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspRekapMain.fieldNames[JspRekapMain.FRM_FIELD_STATUS] %>"  value="<%= rekapMain.getStatus() %>" class="formElemen">
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Date</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspRekapMain.fieldNames[JspRekapMain.FRM_FIELD_DATE] %>"  value="<%= rekapMain.getDate() %>" class="formElemen">
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Counter</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspRekapMain.fieldNames[JspRekapMain.FRM_FIELD_COUNTER] %>"  value="<%= rekapMain.getCounter() %>" class="formElemen">
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Prefix Number</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspRekapMain.fieldNames[JspRekapMain.FRM_FIELD_PREFIX_NUMBER] %>"  value="<%= rekapMain.getPrefixNumber() %>" class="formElemen">
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Number</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspRekapMain.fieldNames[JspRekapMain.FRM_FIELD_NUMBER] %>"  value="<%= rekapMain.getNumber() %>" class="formElemen">
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Note</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspRekapMain.fieldNames[JspRekapMain.FRM_FIELD_NOTE] %>"  value="<%= rekapMain.getNote() %>" class="formElemen">
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Angsuran Coa Debet Id</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspRekapMain.fieldNames[JspRekapMain.FRM_FIELD_ANGSURAN_COA_DEBET_ID] %>"  value="<%= rekapMain.getAngsuranCoaDebetId() %>" class="formElemen">
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Angsuran Coa Credit Id</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspRekapMain.fieldNames[JspRekapMain.FRM_FIELD_ANGSURAN_COA_CREDIT_ID] %>"  value="<%= rekapMain.getAngsuranCoaCreditId() %>" class="formElemen">
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Bunga Coa Debet Id</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspRekapMain.fieldNames[JspRekapMain.FRM_FIELD_BUNGA_COA_DEBET_ID] %>"  value="<%= rekapMain.getBungaCoaDebetId() %>" class="formElemen">
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Bunga Coa Credit Id</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspRekapMain.fieldNames[JspRekapMain.FRM_FIELD_BUNGA_COA_CREDIT_ID] %>"  value="<%= rekapMain.getBungaCoaCreditId() %>" class="formElemen">
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Minimarket Coa Debet Id</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspRekapMain.fieldNames[JspRekapMain.FRM_FIELD_MINIMARKET_COA_DEBET_ID] %>"  value="<%= rekapMain.getMinimarketCoaDebetId() %>" class="formElemen">
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Minimarket Coa Credit Id</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspRekapMain.fieldNames[JspRekapMain.FRM_FIELD_MINIMARKET_COA_CREDIT_ID] %>"  value="<%= rekapMain.getMinimarketCoaCreditId() %>" class="formElemen">
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Fasjabtel Coa Debet Id</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspRekapMain.fieldNames[JspRekapMain.FRM_FIELD_FASJABTEL_COA_DEBET_ID] %>"  value="<%= rekapMain.getFasjabtelCoaDebetId() %>" class="formElemen">
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Fasjabtel Coa Credit Id</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspRekapMain.fieldNames[JspRekapMain.FRM_FIELD_FASJABTEL_COA_CREDIT_ID] %>"  value="<%= rekapMain.getFasjabtelCoaCreditId() %>" class="formElemen">
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Titipan Coa Debet Id</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspRekapMain.fieldNames[JspRekapMain.FRM_FIELD_TITIPAN_COA_DEBET_ID] %>"  value="<%= rekapMain.getTitipanCoaDebetId() %>" class="formElemen">
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Titipan Coa Credit Id</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspRekapMain.fieldNames[JspRekapMain.FRM_FIELD_TITIPAN_COA_CREDIT_ID] %>"  value="<%= rekapMain.getTitipanCoaCreditId() %>" class="formElemen">
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Simpanan Coa Debet Id</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspRekapMain.fieldNames[JspRekapMain.FRM_FIELD_SIMPANAN_COA_DEBET_ID] %>"  value="<%= rekapMain.getSimpananCoaDebetId() %>" class="formElemen">
					    <tr align="left" valign="top">
					       <td height="21" valign="top" width="17%">Simpanan Coa Credit Id</td>
					       <td height="21" colspan="2" width="83%">
							<input type="text" name="<%=jspRekapMain.fieldNames[JspRekapMain.FRM_FIELD_SIMPANAN_COA_CREDIT_ID] %>"  value="<%= rekapMain.getSimpananCoaCreditId() %>" class="formElemen">
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
									String scomDel = "javascript:cmdAsk('"+oidRekapMain+"')";
									String sconDelCom = "javascript:cmdConfirmDelete('"+oidRekapMain+"')";
									String scancel = "javascript:cmdEdit('"+oidRekapMain+"')";
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
