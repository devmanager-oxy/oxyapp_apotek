<% 
/* 
 * Page Name  		:  pinjamandetail.jsp
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

<%!

	public String drawList(int iCommand,JspPinjamanDetail frmObject, PinjamanDetail objEntity, Vector objectClass,  long pinjamanDetailId)

	{
		ControlList ctrlist = new ControlList();
		ctrlist.setAreaWidth("100%");
		ctrlist.setListStyle("listgen");
		ctrlist.setTitleStyle("tableheader");
		ctrlist.setCellStyle("cellStyle");
		ctrlist.setHeaderStyle("tableheader");
		ctrlist.addHeader("Jatuh Tempo","20%");
		ctrlist.addHeader("Cicilan Ke","20%");
		ctrlist.addHeader("Amount","20%");
		ctrlist.addHeader("Bunga","20%");
		ctrlist.addHeader("Status","20%");

		ctrlist.setLinkRow(0);
		ctrlist.setLinkSufix("");
		Vector lstData = ctrlist.getData();
		Vector lstLinkData = ctrlist.getLinkData();
		Vector rowx = new Vector(1,1);
		ctrlist.reset();
		int index = -1;

		for (int i = 0; i < objectClass.size(); i++) {
			 PinjamanDetail pinjamanDetail = (PinjamanDetail)objectClass.get(i);
			 rowx = new Vector();
			 if(pinjamanDetailId == pinjamanDetail.getOID())
				 index = i; 

			 if(index == i && (iCommand == Command.EDIT || iCommand == Command.ASK)){
					
				rowx.add("<input type=\"text\" name=\""+frmObject.fieldNames[JspPinjamanDetail.FRM_FIELD_JATUH_TEMPO] +"\" value=\""+pinjamanDetail.getJatuhTempo()+"\" class=\"formElemen\">");
				rowx.add("<input type=\"text\" name=\""+frmObject.fieldNames[JspPinjamanDetail.FRM_FIELD_CICILAN_KE] +"\" value=\""+pinjamanDetail.getCicilanKe()+"\" class=\"formElemen\">");
				rowx.add("<input type=\"text\" name=\""+frmObject.fieldNames[JspPinjamanDetail.FRM_FIELD_AMOUNT] +"\" value=\""+pinjamanDetail.getAmount()+"\" class=\"formElemen\">");
				rowx.add("<input type=\"text\" name=\""+frmObject.fieldNames[JspPinjamanDetail.FRM_FIELD_BUNGA] +"\" value=\""+pinjamanDetail.getBunga()+"\" class=\"formElemen\">");
				rowx.add("<input type=\"text\" name=\""+frmObject.fieldNames[JspPinjamanDetail.FRM_FIELD_STATUS] +"\" value=\""+pinjamanDetail.getStatus()+"\" class=\"formElemen\">");
			}else{

				String str_dt_JatuhTempo = ""; 
				try{
					Date dt_JatuhTempo = pinjamanDetail.getJatuhTempo();
					if(dt_JatuhTempo==null){
						dt_JatuhTempo = new Date();
					}

				str_dt_JatuhTempo = Formater.formatDate(dt_JatuhTempo, "dd MMMM yyyy");
				}catch(Exception e){ str_dt_JatuhTempo = ""; }
				rowx.add("<a href=\"javascript:cmdEdit('"+String.valueOf(pinjamanDetail.getOID())+"')\">"+str_dt_JatuhTempo+"</a>");
				rowx.add(String.valueOf(pinjamanDetail.getCicilanKe()));
				rowx.add(String.valueOf(pinjamanDetail.getAmount()));
				rowx.add(String.valueOf(pinjamanDetail.getBunga()));
				rowx.add(String.valueOf(pinjamanDetail.getStatus()));
			} 

			lstData.add(rowx);
		}

		 rowx = new Vector();

		if(iCommand == Command.ADD || (iCommand == Command.SAVE && frmObject.errorSize() > 0)){ 
				rowx.add("<input type=\"text\" name=\""+frmObject.fieldNames[JspPinjamanDetail.FRM_FIELD_JATUH_TEMPO] +"\" value=\""+objEntity.getJatuhTempo()+"\" class=\"formElemen\">");
				rowx.add("<input type=\"text\" name=\""+frmObject.fieldNames[JspPinjamanDetail.FRM_FIELD_CICILAN_KE] +"\" value=\""+objEntity.getCicilanKe()+"\" class=\"formElemen\">");
				rowx.add("<input type=\"text\" name=\""+frmObject.fieldNames[JspPinjamanDetail.FRM_FIELD_AMOUNT] +"\" value=\""+objEntity.getAmount()+"\" class=\"formElemen\">");
				rowx.add("<input type=\"text\" name=\""+frmObject.fieldNames[JspPinjamanDetail.FRM_FIELD_BUNGA] +"\" value=\""+objEntity.getBunga()+"\" class=\"formElemen\">");
				rowx.add("<input type=\"text\" name=\""+frmObject.fieldNames[JspPinjamanDetail.FRM_FIELD_STATUS] +"\" value=\""+objEntity.getStatus()+"\" class=\"formElemen\">");

		}

		lstData.add(rowx);

		return ctrlist.draw();
	}

%>
<%
int iCommand = FRMQueryString.requestCommand(request);
int start = FRMQueryString.requestInt(request, "start");
int prevCommand = FRMQueryString.requestInt(request, "prev_command");
long oidPinjamanDetail = FRMQueryString.requestLong(request, "hidden_pinjaman_detail_id");

/*variable declaration*/
int recordToGet = 10;
String msgString = "";
int iErrCode = FRMMessage.NONE;
String whereClause = "";
String orderClause = "";

CtrlPinjamanDetail ctrlPinjamanDetail = new CtrlPinjamanDetail(request);
ControlLine ctrLine = new ControlLine();
Vector listPinjamanDetail = new Vector(1,1);

/*switch statement */
iErrCode = ctrlPinjamanDetail.action(iCommand , oidPinjamanDetail);
/* end switch*/
JspPinjamanDetail jspPinjamanDetail = ctrlPinjamanDetail.getForm();

/*count list All PinjamanDetail*/
int vectSize = PstPinjamanDetail.getCount(whereClause);

/*switch list PinjamanDetail*/
if((iCommand == Command.FIRST || iCommand == Command.PREV )||
  (iCommand == Command.NEXT || iCommand == Command.LAST)){
		start = ctrlPinjamanDetail.actionList(iCommand, start, vectSize, recordToGet);
 } 
/* end switch list*/

PinjamanDetail pinjamanDetail = ctrlPinjamanDetail.getPinjamanDetail();
msgString =  ctrlPinjamanDetail.getMessage();

/* get record to display */
listPinjamanDetail = PstPinjamanDetail.list(start,recordToGet, whereClause , orderClause);

/*handle condition if size of record to display = 0 and start > 0 	after delete*/
if (listPinjamanDetail.size() < 1 && start > 0)
{
	 if (vectSize - recordToGet > recordToGet)
			start = start - recordToGet;   //go to Command.PREV
	 else{
		 start = 0 ;
		 iCommand = Command.FIRST;
		 prevCommand = Command.FIRST; //go to Command.FIRST
	 }
	 listPinjamanDetail = PstPinjamanDetail.list(start,recordToGet, whereClause , orderClause);
}
%>


<html><!-- #BeginTemplate "/Templates/main.dwt" -->
<head>
<!-- #BeginEditable "doctitle" -->
<title>sipadu--</title>
<script language="JavaScript">


function cmdAdd(){
	document.frmpinjamandetail.hidden_pinjaman_detail_id.value="0";
	document.frmpinjamandetail.command.value="<%=Command.ADD%>";
	document.frmpinjamandetail.prev_command.value="<%=prevCommand%>";
	document.frmpinjamandetail.action="pinjamandetail.jsp";
	document.frmpinjamandetail.submit();
}

function cmdAsk(oidPinjamanDetail){
	document.frmpinjamandetail.hidden_pinjaman_detail_id.value=oidPinjamanDetail;
	document.frmpinjamandetail.command.value="<%=Command.ASK%>";
	document.frmpinjamandetail.prev_command.value="<%=prevCommand%>";
	document.frmpinjamandetail.action="pinjamandetail.jsp";
	document.frmpinjamandetail.submit();
}

function cmdConfirmDelete(oidPinjamanDetail){
	document.frmpinjamandetail.hidden_pinjaman_detail_id.value=oidPinjamanDetail;
	document.frmpinjamandetail.command.value="<%=Command.DELETE%>";
	document.frmpinjamandetail.prev_command.value="<%=prevCommand%>";
	document.frmpinjamandetail.action="pinjamandetail.jsp";
	document.frmpinjamandetail.submit();
}

function cmdSave(){
	document.frmpinjamandetail.command.value="<%=Command.SAVE%>";
	document.frmpinjamandetail.prev_command.value="<%=prevCommand%>";
	document.frmpinjamandetail.action="pinjamandetail.jsp";
	document.frmpinjamandetail.submit();
}

function cmdEdit(oidPinjamanDetail){
	document.frmpinjamandetail.hidden_pinjaman_detail_id.value=oidPinjamanDetail;
	document.frmpinjamandetail.command.value="<%=Command.EDIT%>";
	document.frmpinjamandetail.prev_command.value="<%=prevCommand%>";
	document.frmpinjamandetail.action="pinjamandetail.jsp";
	document.frmpinjamandetail.submit();
}

function cmdCancel(oidPinjamanDetail){
	document.frmpinjamandetail.hidden_pinjaman_detail_id.value=oidPinjamanDetail;
	document.frmpinjamandetail.command.value="<%=Command.EDIT%>";
	document.frmpinjamandetail.prev_command.value="<%=prevCommand%>";
	document.frmpinjamandetail.action="pinjamandetail.jsp";
	document.frmpinjamandetail.submit();
}

function cmdBack(){
	document.frmpinjamandetail.command.value="<%=Command.BACK%>";
	document.frmpinjamandetail.action="pinjamandetail.jsp";
	document.frmpinjamandetail.submit();
}

function cmdListFirst(){
	document.frmpinjamandetail.command.value="<%=Command.FIRST%>";
	document.frmpinjamandetail.prev_command.value="<%=Command.FIRST%>";
	document.frmpinjamandetail.action="pinjamandetail.jsp";
	document.frmpinjamandetail.submit();
}

function cmdListPrev(){
	document.frmpinjamandetail.command.value="<%=Command.PREV%>";
	document.frmpinjamandetail.prev_command.value="<%=Command.PREV%>";
	document.frmpinjamandetail.action="pinjamandetail.jsp";
	document.frmpinjamandetail.submit();
}

function cmdListNext(){
	document.frmpinjamandetail.command.value="<%=Command.NEXT%>";
	document.frmpinjamandetail.prev_command.value="<%=Command.NEXT%>";
	document.frmpinjamandetail.action="pinjamandetail.jsp";
	document.frmpinjamandetail.submit();
}

function cmdListLast(){
	document.frmpinjamandetail.command.value="<%=Command.LAST%>";
	document.frmpinjamandetail.prev_command.value="<%=Command.LAST%>";
	document.frmpinjamandetail.action="pinjamandetail.jsp";
	document.frmpinjamandetail.submit();
}

//-------------- script form image -------------------

function cmdDelPict(oidPinjamanDetail){
	document.frmimage.hidden_pinjaman_detail_id.value=oidPinjamanDetail;
	document.frmimage.command.value="<%=Command.POST%>";
	document.frmimage.action="pinjamandetail.jsp";
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

						<form name="frmpinjamandetail" method ="post" action="">
				<input type="hidden" name="command" value="<%=iCommand%>">
				<input type="hidden" name="vectSize" value="<%=vectSize%>">
				<input type="hidden" name="start" value="<%=start%>">
				<input type="hidden" name="prev_command" value="<%=prevCommand%>">
				<input type="hidden" name="hidden_pinjaman_detail_id" value="<%=oidPinjamanDetail%>">
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
						      <td height="14" valign="middle" colspan="3" class="comment">&nbsp;PinjamanDetail
						       List </td>
						  </tr>
						  <%
							try{
							%>
						  <tr align="left" valign="top">
						        <td height="22" valign="middle" colspan="3"> <%= drawList(iCommand,jspPinjamanDetail, pinjamanDetail,listPinjamanDetail,oidPinjamanDetail)%> </td>
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
									String scomDel = "javascript:cmdAsk('"+oidPinjamanDetail+"')";
									String sconDelCom = "javascript:cmdConfirmDelete('"+oidPinjamanDetail+"')";
									String scancel = "javascript:cmdEdit('"+oidPinjamanDetail+"')";
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
