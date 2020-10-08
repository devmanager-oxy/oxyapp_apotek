
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.datasync.*" %>
<%@ include file = "../main/javainit.jsp" %>
<% int  appObjCode = 1;// AppObjInfo.composeObjCode(AppObjInfo.--, AppObjInfo.--, AppObjInfo.--); %>
<%@ include file = "../main/check.jsp" %>
<%
/* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
boolean privAdd=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ADD));
boolean privUpdate=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_UPDATE));
boolean privDelete=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_DELETE));
%>
<!-- Jsp Block -->
<%!

	public String drawList(int iJSPCommand,JspBackupHistory frmObject, BackupHistory objEntity, Vector objectClass,  long backupHistoryId)

	{
		JSPList ctrlist = new JSPList();
		ctrlist.setAreaWidth("100%");
		
		ctrlist.setListStyle("listgen");
		ctrlist.setTitleStyle("tablehdr");
		ctrlist.setCellStyle("tablecell");
		ctrlist.setHeaderStyle("tablehdr");
		
		ctrlist.addHeader("Date","16%");
		ctrlist.addHeader("Start Date","16%");
		ctrlist.addHeader("End Date","16%");
		ctrlist.addHeader("Operator","16%");
		ctrlist.addHeader("Type","16%");
		ctrlist.addHeader("Note","16%");

		ctrlist.setLinkRow(0);
		ctrlist.setLinkSufix("");
		Vector lstData = ctrlist.getData();
		Vector lstLinkData = ctrlist.getLinkData();
		Vector rowx = new Vector(1,1);
		ctrlist.reset();
		int index = -1;

		for (int i = 0; i < objectClass.size(); i++) {
			 BackupHistory backupHistory = (BackupHistory)objectClass.get(i);
			 rowx = new Vector();
			 if(backupHistoryId == backupHistory.getOID())
				 index = i; 

			 if(index == i && (iJSPCommand == JSPCommand.EDIT || iJSPCommand == JSPCommand.ASK)){
					
				rowx.add("<input type=\"text\" name=\""+frmObject.colNames[JspBackupHistory.JSP_DATE] +"\" value=\""+backupHistory.getDate()+"\" class=\"formElemen\">");
				rowx.add("<input type=\"text\" name=\""+frmObject.colNames[JspBackupHistory.JSP_START_DATE] +"\" value=\""+backupHistory.getStartDate()+"\" class=\"formElemen\">");
				rowx.add("<input type=\"text\" name=\""+frmObject.colNames[JspBackupHistory.JSP_END_DATE] +"\" value=\""+backupHistory.getEndDate()+"\" class=\"formElemen\">");
				rowx.add("<input type=\"text\" name=\""+frmObject.colNames[JspBackupHistory.JSP_OPERATOR] +"\" value=\""+backupHistory.getOperator()+"\" class=\"formElemen\">");
				rowx.add("<input type=\"text\" name=\""+frmObject.colNames[JspBackupHistory.JSP_TYPE] +"\" value=\""+backupHistory.getType()+"\" class=\"formElemen\">");
				rowx.add("<input type=\"text\" name=\""+frmObject.colNames[JspBackupHistory.JSP_NOTE] +"\" value=\""+backupHistory.getNote()+"\" class=\"formElemen\">");
			}else{
				rowx.add("<a href=\"javascript:cmdEdit('"+String.valueOf(backupHistory.getOID())+"')\">"+String.valueOf(backupHistory.getDate())+"</a>");

				String str_dt_StartDate = ""; 
				try{
					Date dt_StartDate = backupHistory.getStartDate();
					if(dt_StartDate==null){
						dt_StartDate = new Date();
					}

				str_dt_StartDate = JSPFormater.formatDate(dt_StartDate, "dd MMMM yyyy");
				}catch(Exception e){ str_dt_StartDate = ""; }
				rowx.add(str_dt_StartDate);

				String str_dt_EndDate = ""; 
				try{
					Date dt_EndDate = backupHistory.getEndDate();
					if(dt_EndDate==null){
						dt_EndDate = new Date();
					}

				str_dt_EndDate = JSPFormater.formatDate(dt_EndDate, "dd MMMM yyyy");
				}catch(Exception e){ str_dt_EndDate = ""; }
				rowx.add(str_dt_EndDate);
				rowx.add(String.valueOf(backupHistory.getOperator()));
				rowx.add(String.valueOf(backupHistory.getType()));
				rowx.add(backupHistory.getNote());
			} 

			lstData.add(rowx);
		}

		 rowx = new Vector();

		if(iJSPCommand == JSPCommand.ADD || (iJSPCommand == JSPCommand.SAVE && frmObject.errorSize() > 0)){ 
				rowx.add("<input type=\"text\" name=\""+frmObject.colNames[JspBackupHistory.JSP_DATE] +"\" value=\""+objEntity.getDate()+"\" class=\"formElemen\">");
				rowx.add("<input type=\"text\" name=\""+frmObject.colNames[JspBackupHistory.JSP_START_DATE] +"\" value=\""+objEntity.getStartDate()+"\" class=\"formElemen\">");
				rowx.add("<input type=\"text\" name=\""+frmObject.colNames[JspBackupHistory.JSP_END_DATE] +"\" value=\""+objEntity.getEndDate()+"\" class=\"formElemen\">");
				rowx.add("<input type=\"text\" name=\""+frmObject.colNames[JspBackupHistory.JSP_OPERATOR] +"\" value=\""+objEntity.getOperator()+"\" class=\"formElemen\">");
				rowx.add("<input type=\"text\" name=\""+frmObject.colNames[JspBackupHistory.JSP_TYPE] +"\" value=\""+objEntity.getType()+"\" class=\"formElemen\">");
				rowx.add("<input type=\"text\" name=\""+frmObject.colNames[JspBackupHistory.JSP_NOTE] +"\" value=\""+objEntity.getNote()+"\" class=\"formElemen\">");

		}

		lstData.add(rowx);

		return ctrlist.draw(index);
	}

%>
<%
int iJSPCommand = JSPRequestValue.requestCommand(request);
int start = JSPRequestValue.requestInt(request, "start");
int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
long oidBackupHistory = JSPRequestValue.requestLong(request, "hidden_backup_history_id");

/*variable declaration*/
int recordToGet = 10;
String msgString = "";
int iErrCode = JSPMessage.NONE;
String whereClause = "";
String orderClause = "";

CmdBackupHistory ctrlBackupHistory = new CmdBackupHistory(request);
JSPLine ctrLine = new JSPLine();
Vector listBackupHistory = new Vector(1,1);

/*switch statement */
iErrCode = ctrlBackupHistory.action(iJSPCommand , oidBackupHistory);
/* end switch*/
JspBackupHistory jspBackupHistory = ctrlBackupHistory.getForm();

/*count list All BackupHistory*/
int vectSize = DbBackupHistory.getCount(whereClause);

/*switch list BackupHistory*/
if((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV )||
  (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)){
		start = ctrlBackupHistory.actionList(iJSPCommand, start, vectSize, recordToGet);
 } 
/* end switch list*/

BackupHistory backupHistory = ctrlBackupHistory.getBackupHistory();
msgString =  ctrlBackupHistory.getMessage();

/* get record to display */
listBackupHistory = DbBackupHistory.list(start,recordToGet, whereClause , orderClause);

/*handle condition if size of record to display = 0 and start > 0 	after delete*/
if (listBackupHistory.size() < 1 && start > 0)
{
	 if (vectSize - recordToGet > recordToGet)
			start = start - recordToGet;   //go to JSPCommand.PREV
	 else{
		 start = 0 ;
		 iJSPCommand = JSPCommand.FIRST;
		 prevJSPCommand = JSPCommand.FIRST; //go to JSPCommand.FIRST
	 }
	 listBackupHistory = DbBackupHistory.list(start,recordToGet, whereClause , orderClause);
}
%>
<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
<head>
<!-- #BeginEditable "javascript" --> 
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Finance System</title>
<link href="../css/css.css" rel="stylesheet" type="text/css" />
<script language="JavaScript">
function cmdAdd(){
	document.frmbackuphistory.hidden_backup_history_id.value="0";
	document.frmbackuphistory.command.value="<%=JSPCommand.ADD%>";
	document.frmbackuphistory.prev_command.value="<%=prevJSPCommand%>";
	document.frmbackuphistory.action="backuphistory.jsp";
	document.frmbackuphistory.submit();
}

function cmdAsk(oidBackupHistory){
	document.frmbackuphistory.hidden_backup_history_id.value=oidBackupHistory;
	document.frmbackuphistory.command.value="<%=JSPCommand.ASK%>";
	document.frmbackuphistory.prev_command.value="<%=prevJSPCommand%>";
	document.frmbackuphistory.action="backuphistory.jsp";
	document.frmbackuphistory.submit();
}

function cmdConfirmDelete(oidBackupHistory){
	document.frmbackuphistory.hidden_backup_history_id.value=oidBackupHistory;
	document.frmbackuphistory.command.value="<%=JSPCommand.DELETE%>";
	document.frmbackuphistory.prev_command.value="<%=prevJSPCommand%>";
	document.frmbackuphistory.action="backuphistory.jsp";
	document.frmbackuphistory.submit();
}

function cmdSave(){
	document.frmbackuphistory.command.value="<%=JSPCommand.SAVE%>";
	document.frmbackuphistory.prev_command.value="<%=prevJSPCommand%>";
	document.frmbackuphistory.action="backuphistory.jsp";
	document.frmbackuphistory.submit();
}

function cmdEdit(oidBackupHistory){
	document.frmbackuphistory.hidden_backup_history_id.value=oidBackupHistory;
	document.frmbackuphistory.command.value="<%=JSPCommand.EDIT%>";
	document.frmbackuphistory.prev_command.value="<%=prevJSPCommand%>";
	document.frmbackuphistory.action="backuphistory.jsp";
	document.frmbackuphistory.submit();
}

function cmdCancel(oidBackupHistory){
	document.frmbackuphistory.hidden_backup_history_id.value=oidBackupHistory;
	document.frmbackuphistory.command.value="<%=JSPCommand.EDIT%>";
	document.frmbackuphistory.prev_command.value="<%=prevJSPCommand%>";
	document.frmbackuphistory.action="backuphistory.jsp";
	document.frmbackuphistory.submit();
}

function cmdBack(){
	document.frmbackuphistory.command.value="<%=JSPCommand.BACK%>";
	document.frmbackuphistory.action="backuphistory.jsp";
	document.frmbackuphistory.submit();
}

function cmdListFirst(){
	document.frmbackuphistory.command.value="<%=JSPCommand.FIRST%>";
	document.frmbackuphistory.prev_command.value="<%=JSPCommand.FIRST%>";
	document.frmbackuphistory.action="backuphistory.jsp";
	document.frmbackuphistory.submit();
}

function cmdListPrev(){
	document.frmbackuphistory.command.value="<%=JSPCommand.PREV%>";
	document.frmbackuphistory.prev_command.value="<%=JSPCommand.PREV%>";
	document.frmbackuphistory.action="backuphistory.jsp";
	document.frmbackuphistory.submit();
}

function cmdListNext(){
	document.frmbackuphistory.command.value="<%=JSPCommand.NEXT%>";
	document.frmbackuphistory.prev_command.value="<%=JSPCommand.NEXT%>";
	document.frmbackuphistory.action="backuphistory.jsp";
	document.frmbackuphistory.submit();
}

function cmdListLast(){
	document.frmbackuphistory.command.value="<%=JSPCommand.LAST%>";
	document.frmbackuphistory.prev_command.value="<%=JSPCommand.LAST%>";
	document.frmbackuphistory.action="backuphistory.jsp";
	document.frmbackuphistory.submit();
}

//-------------- script form image -------------------

function cmdDelPict(oidBackupHistory){
	document.frmimage.hidden_backup_history_id.value=oidBackupHistory;
	document.frmimage.command.value="<%=JSPCommand.POST%>";
	document.frmimage.action="backuphistory.jsp";
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
</head>
<body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif')">
<table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
  <tr> 
    <td valign="top"> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
        <tr> 
          <td height="96"> 
            <!-- #BeginEditable "header" --> 
            <%@ include file="../main/hmenu.jsp"%>
            <!-- #EndEditable -->
          </td>
        </tr>
        <tr> 
          <td valign="top"> 
            <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
              <!--DWLayoutTable-->
              <tr> 
                <td width="165" height="100%" valign="top" style="background:url(<%=approot%>/images/leftmenu-bg.gif) repeat-y"> 
                  <!-- #BeginEditable "menu" --> 
                  <%@ include file="../main/menu.jsp"%>
                  <!-- #EndEditable -->
                </td>
                <td width="100%" valign="top"> 
                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr> 
                      <td class="title"><!-- #BeginEditable "title" --><span class="level1">Data 
                        Syncrhornization</span> &raquo; <span class="level1">Backup</span> 
                        &raquo; <span class="level2">History</span><span class="level2"><br>
                        </span><!-- #EndEditable --></td>
                    </tr>
                    <!--tr> 
                      <td><img src="<%=approot%>/images/title-sp.gif" width="584" height="1"></td> 
                    </tr-->
                    <tr> 
                      <td><!-- #BeginEditable "content" --> 
                        <form name="frmbackuphistory" method ="post" action="">
                          <input type="hidden" name="command" value="<%=iJSPCommand%>">
                          <input type="hidden" name="vectSize" value="<%=vectSize%>">
                          <input type="hidden" name="start" value="<%=start%>">
                          <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                          <input type="hidden" name="hidden_backup_history_id" value="<%=oidBackupHistory%>">
						  <table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td class="container"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr align="left" valign="top"> 
                              <td height="8"  colspan="3"> 
                                      <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                        <tr align="left" valign="top">
                                          <td height="22" valign="middle" colspan="3">&nbsp;</td>
                                        </tr>
                                        <%
							try{
							%>
                                        <tr align="left" valign="top"> 
                                          <td height="22" valign="middle" colspan="3"> 
                                            <%= drawList(iJSPCommand,jspBackupHistory, backupHistory,listBackupHistory,oidBackupHistory)%> </td>
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
									String scomDel = "javascript:cmdAsk('"+oidBackupHistory+"')";
									String sconDelCom = "javascript:cmdConfirmDelete('"+oidBackupHistory+"')";
									String scancel = "javascript:cmdEdit('"+oidBackupHistory+"')";
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
                                <%= ctrLine.drawImage(iJSPCommand, iErrCode, msgString)%> </td>
                            </tr>
                          </table></td>
  </tr>
</table>
						  
                          
                        </form>
                        
                        <!-- #EndEditable -->
                      </td>
                    </tr>
                    
                    <tr> 
                      <td>&nbsp;</td>
                    </tr>
                  </table>
                </td>
              </tr>
            </table>
          </td>
        </tr>
        <tr> 
          <td height="25"> 
            <!-- #BeginEditable "footer" --> 
            <%@ include file="../main/footer.jsp"%>
            <!-- #EndEditable -->
          </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
</body>
<!-- #EndTemplate --></html>
