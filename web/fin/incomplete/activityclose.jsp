 
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.main.entity.*" %>
<%@ page import = "com.project.fms.activity.*" %>
<%@ page import = "com.project.*" %>
<%@ include file = "../main/javainit.jsp" %>
<% int  appObjCode = 1;// AppObjInfo.composeObjCode(AppObjInfo.--, AppObjInfo.--, AppObjInfo.--); %>
<%@ include file = "../main/check.jsp" %>
<%
/* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
boolean privAdd=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ADD));
boolean privUpdate=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_UPDATE));
boolean privDelete=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_DELETE));
%>
<%
boolean masterPriv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_WORKPLAN_PERIOD);
%>
<!-- Jsp Block -->
<%!

	public String drawList(int iJSPCommand,JspActivityPeriod frmObject, ActivityPeriod objEntity, Vector objectClass,  long activityPeriodId, String approot)

	{
		JSPList cmdist = new JSPList();
		cmdist.setAreaWidth("100%");
		
		cmdist.setListStyle("listgen");
		cmdist.setTitleStyle("tablehdr");
		cmdist.setCellStyle("tablecell");
		//cmdist.setCellStyle("tablecell1");
		cmdist.setHeaderStyle("tablehdr");
		
		cmdist.addHeader("Name","25%");
		cmdist.addHeader("Start Date","25%");
		cmdist.addHeader("End Date","25%");
		cmdist.addHeader("Status","25%");

		cmdist.setLinkRow(0);
		cmdist.setLinkSufix("");
		Vector lstData = cmdist.getData();
		Vector lstLinkData = cmdist.getLinkData();
		Vector rowx = new Vector(1,1);
		cmdist.reset();
		int index = -1;

		for (int i = 0; i < objectClass.size(); i++) {
			 ActivityPeriod activityPeriod = (ActivityPeriod)objectClass.get(i);
			 rowx = new Vector();
			 if(activityPeriodId == activityPeriod.getOID())
				 index = i; 

			 if(index == i && (iJSPCommand == JSPCommand.EDIT || iJSPCommand == JSPCommand.ASK)){
					
				rowx.add("<input type=\"text\" name=\""+frmObject.colNames[JspActivityPeriod.JSP_NAME] +"\" value=\""+activityPeriod.getName()+"\" class=\"formElemen\">");
				//rowx.add("<input type=\"text\" name=\""+frmObject.colNames[JspActivityPeriod.JSP_START_DATE] +"\" value=\""+activityPeriod.getStartDate()+"\" class=\"formElemen\">");
				rowx.add(getDates(activityPeriod.getStartDate(), "frmactivityperiod", frmObject.colNames[JspActivityPeriod.JSP_START_DATE], approot));
				//rowx.add("<input type=\"text\" name=\""+frmObject.colNames[JspActivityPeriod.JSP_END_DATE] +"\" value=\""+activityPeriod.getEndDate()+"\" class=\"formElemen\">");
				rowx.add(getDates(activityPeriod.getEndDate(), "frmactivityperiod", frmObject.colNames[JspActivityPeriod.JSP_END_DATE], approot));
				//rowx.add("<input type=\"text\" name=\""+frmObject.colNames[JspActivityPeriod.JSP_STATUS] +"\" value=\""+activityPeriod.getStatus()+"\" class=\"formElemen\">");
				rowx.add(activityPeriod.getStatus());
			}else{
				rowx.add("<a href=\"javascript:cmdEdit('"+String.valueOf(activityPeriod.getOID())+"')\">"+activityPeriod.getName()+"</a>");

				String str_dt_StartDate = ""; 
				try{
					Date dt_StartDate = activityPeriod.getStartDate();
					if(dt_StartDate==null){
						dt_StartDate = new Date();
					}

				str_dt_StartDate = JSPFormater.formatDate(dt_StartDate, "dd MMMM yyyy");
				}catch(Exception e){ str_dt_StartDate = ""; }
				rowx.add(str_dt_StartDate);

				String str_dt_EndDate = ""; 
				try{
					Date dt_EndDate = activityPeriod.getEndDate();
					if(dt_EndDate==null){
						dt_EndDate = new Date();
					}

				str_dt_EndDate = JSPFormater.formatDate(dt_EndDate, "dd MMMM yyyy");
				}catch(Exception e){ str_dt_EndDate = ""; }
				rowx.add(str_dt_EndDate);
				rowx.add(activityPeriod.getStatus());
			} 

			lstData.add(rowx);
		}

		 rowx = new Vector();

		if(iJSPCommand == JSPCommand.ADD || (iJSPCommand == JSPCommand.SAVE && frmObject.errorSize() > 0)){ 
				rowx.add("<input type=\"text\" name=\""+frmObject.colNames[JspActivityPeriod.JSP_NAME] +"\" value=\""+objEntity.getName()+"\" class=\"formElemen\">");
				//rowx.add("<input type=\"text\" name=\""+frmObject.colNames[JspActivityPeriod.JSP_START_DATE] +"\" value=\""+objEntity.getStartDate()+"\" class=\"formElemen\">");
				rowx.add(getDates(objEntity.getStartDate(), "frmactivityperiod", frmObject.colNames[JspActivityPeriod.JSP_START_DATE], approot));
				
				//rowx.add("<input type=\"text\" name=\""+frmObject.colNames[JspActivityPeriod.JSP_END_DATE] +"\" value=\""+objEntity.getEndDate()+"\" class=\"formElemen\">");
				rowx.add(getDates(objEntity.getEndDate(), "frmactivityperiod", frmObject.colNames[JspActivityPeriod.JSP_END_DATE], approot));
				//rowx.add("<input type=\"text\" name=\""+frmObject.colNames[JspActivityPeriod.JSP_STATUS] +"\" value=\""+objEntity.getStatus()+"\" class=\"formElemen\">");
				rowx.add("");

		}

		lstData.add(rowx);

		return cmdist.draw(index);
	}
	
	public String getDates(Date dt, String frmname, String strname, String approot){
		 String str = "<table width=\"15%\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\">"+
			"<tr>"+ 
			  "<td width=\"14%\">"+
				"<input type=\"text\" name=\""+strname+"\"  value=\""+(JSPFormater.formatDate(dt, "dd/MM/yyyy"))+"\" class=\"formElemen\" size=\"15\" readOnly>"+
			  "</td>"+ 
			  "<td width=\"86%\"><a href=\"javascript:void(0)\" onClick=\"if(self.gfPop)gfPop.fPopCalendar(document."+frmname+"."+strname+");return false;\" ><img class=\"PopcalTrigger\" align=\"absmiddle\" src=\""+approot+"/calendar/calbtn.gif\" height=18 border=\"0\" alt=\"sob from\" width=\"24\"></a></td>"+ 
			"</tr>"+
		  "</table>";
		  return str;
	}

%>
<%
int iJSPCommand = JSPRequestValue.requestCommand(request);
int start = JSPRequestValue.requestInt(request, "start");
int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
long oidActivityPeriod = JSPRequestValue.requestLong(request, "hidden_activity_period_id");

/*variable declaration*/
int recordToGet = 10;
String msgString = "";
int iErrCode = JSPMessage.NONE;
String whereClause = "";
String orderClause = "";

CmdActivityPeriod ctrlActivityPeriod = new CmdActivityPeriod(request);
JSPLine ctrLine = new JSPLine();
Vector listActivityPeriod = new Vector(1,1);

/*switch statement */
iErrCode = ctrlActivityPeriod.action(iJSPCommand , oidActivityPeriod);
/* end switch*/
JspActivityPeriod jspActivityPeriod = ctrlActivityPeriod.getForm();

/*count list All ActivityPeriod*/
int vectSize = DbActivityPeriod.getCount(whereClause);

/*switch list ActivityPeriod*/
if((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV )||
  (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)){
		start = ctrlActivityPeriod.actionList(iJSPCommand, start, vectSize, recordToGet);
 } 
/* end switch list*/

ActivityPeriod activityPeriod = ctrlActivityPeriod.getActivityPeriod();
msgString =  ctrlActivityPeriod.getMessage();

/* get record to display */
listActivityPeriod = DbActivityPeriod.list(start,recordToGet, whereClause , orderClause);

/*handle condition if size of record to display = 0 and start > 0 	after delete*/
if (listActivityPeriod.size() < 1 && start > 0)
{
	 if (vectSize - recordToGet > recordToGet)
			start = start - recordToGet;   //go to JSPCommand.PREV
	 else{
		 start = 0 ;
		 iJSPCommand = JSPCommand.FIRST;
		 prevJSPCommand = JSPCommand.FIRST; //go to JSPCommand.FIRST
	 }
	 listActivityPeriod = DbActivityPeriod.list(start,recordToGet, whereClause , orderClause);
}
%>
<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
<head>
<!-- #BeginEditable "javascript" --> 
<title>Finance System - PNK</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<link href="../css/default.css" rel="stylesheet" type="text/css" />
<link href="../css/css.css" rel="stylesheet" type="text/css" />
<script language="JavaScript">

<%if(!masterPriv){%>
	window.location="<%=approot%>/nopriv.jsp";
<%}%>

function cmdClose(){
	if(confirm('Are you sure to do this action ?\nthis action is undoable, all transaction in the previews period will be locked for update')){
		document.frmactivityperiod.hidden_activity_period_id.value="0";
		//document.frmactivityperiod.command.value="<%=JSPCommand.ADD%>";
		document.frmactivityperiod.action="closeactivityperiod.jsp";
		document.frmactivityperiod.submit();
		//alert('sorry, close period is under construction ...');
	}
}

function cmdAdd(){
	document.frmactivityperiod.hidden_activity_period_id.value="0";
	document.frmactivityperiod.command.value="<%=JSPCommand.ADD%>";
	document.frmactivityperiod.prev_command.value="<%=prevJSPCommand%>";
	document.frmactivityperiod.action="activityclose.jsp";
	document.frmactivityperiod.submit();
}

function cmdAsk(oidActivityPeriod){
	document.frmactivityperiod.hidden_activity_period_id.value=oidActivityPeriod;
	document.frmactivityperiod.command.value="<%=JSPCommand.ASK%>";
	document.frmactivityperiod.prev_command.value="<%=prevJSPCommand%>";
	document.frmactivityperiod.action="activityclose.jsp";
	document.frmactivityperiod.submit();
}

function cmdConfirmDelete(oidActivityPeriod){
	document.frmactivityperiod.hidden_activity_period_id.value=oidActivityPeriod;
	document.frmactivityperiod.command.value="<%=JSPCommand.DELETE%>";
	document.frmactivityperiod.prev_command.value="<%=prevJSPCommand%>";
	document.frmactivityperiod.action="activityclose.jsp";
	document.frmactivityperiod.submit();
}

function cmdSave(){
	document.frmactivityperiod.command.value="<%=JSPCommand.SAVE%>";
	document.frmactivityperiod.prev_command.value="<%=prevJSPCommand%>";
	document.frmactivityperiod.action="activityclose.jsp";
	document.frmactivityperiod.submit();
}

function cmdEdit(oidActivityPeriod){
	document.frmactivityperiod.hidden_activity_period_id.value=oidActivityPeriod;
	document.frmactivityperiod.command.value="<%=JSPCommand.EDIT%>";
	document.frmactivityperiod.prev_command.value="<%=prevJSPCommand%>";
	document.frmactivityperiod.action="activityclose.jsp";
	document.frmactivityperiod.submit();
}

function cmdCancel(oidActivityPeriod){
	document.frmactivityperiod.hidden_activity_period_id.value=oidActivityPeriod;
	document.frmactivityperiod.command.value="<%=JSPCommand.EDIT%>";
	document.frmactivityperiod.prev_command.value="<%=prevJSPCommand%>";
	document.frmactivityperiod.action="activityclose.jsp";
	document.frmactivityperiod.submit();
}

function cmdBack(){
	document.frmactivityperiod.command.value="<%=JSPCommand.BACK%>";
	document.frmactivityperiod.action="activityclose.jsp";
	document.frmactivityperiod.submit();
}

function cmdListFirst(){
	document.frmactivityperiod.command.value="<%=JSPCommand.FIRST%>";
	document.frmactivityperiod.prev_command.value="<%=JSPCommand.FIRST%>";
	document.frmactivityperiod.action="activityclose.jsp";
	document.frmactivityperiod.submit();
}

function cmdListPrev(){
	document.frmactivityperiod.command.value="<%=JSPCommand.PREV%>";
	document.frmactivityperiod.prev_command.value="<%=JSPCommand.PREV%>";
	document.frmactivityperiod.action="activityclose.jsp";
	document.frmactivityperiod.submit();
}

function cmdListNext(){
	document.frmactivityperiod.command.value="<%=JSPCommand.NEXT%>";
	document.frmactivityperiod.prev_command.value="<%=JSPCommand.NEXT%>";
	document.frmactivityperiod.action="activityclose.jsp";
	document.frmactivityperiod.submit();
}

function cmdListLast(){
	document.frmactivityperiod.command.value="<%=JSPCommand.LAST%>";
	document.frmactivityperiod.prev_command.value="<%=JSPCommand.LAST%>";
	document.frmactivityperiod.action="activityclose.jsp";
	document.frmactivityperiod.submit();
}

//-------------- script form image -------------------

function cmdDelPict(oidActivityPeriod){
	document.frmimage.hidden_activity_period_id.value=oidActivityPeriod;
	document.frmimage.command.value="<%=JSPCommand.POST%>";
	document.frmimage.action="activityclose.jsp";
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
<body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','../images/new2.gif','../images/closeperiode2.gif')">
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
                  <%@ include file="../calendar/calendarframe.jsp"%>
                  <!-- #EndEditable -->
                </td>
                <td width="100%" valign="top"> 
                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr> 
                      <td class="title"><!-- #BeginEditable "title" -->Data Synchronization 
                        &raquo; <span class="level2">Activity Closing<br>
                        </span><!-- #EndEditable --></td>
                    </tr>
                    <!--tr> 
                      <td><img src="<%=approot%>/images/title-sp.gif" width="584" height="1"></td> 
                    </tr-->
                    <tr> 
                      <td><!-- #BeginEditable "content" --> 
                        <form name="frmactivityperiod" method ="post" action="">
                          <input type="hidden" name="command" value="<%=iJSPCommand%>">
                          <input type="hidden" name="vectSize" value="<%=vectSize%>">
                          <input type="hidden" name="start" value="<%=start%>">
                          <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                          <input type="hidden" name="hidden_activity_period_id" value="<%=oidActivityPeriod%>">
                          <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
						  <table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
                              <td class="container"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr align="left" valign="top"> 
                              <td height="8"  colspan="3"> 
                                      <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                        <tr align="left" valign="top"> 
                                          <td height="8" valign="middle" colspan="3"> 
                                          </td>
                                        </tr>
                                        <%
							try{
							%>
                                        <tr align="left" valign="top"> 
                                          <td height="22" valign="middle" colspan="3"> 
                                            <table width="70%" border="0" cellspacing="0" cellpadding="0">
                                              <tr> 
                                                <td class="boxed1"><%= drawList(iJSPCommand,jspActivityPeriod, activityPeriod,listActivityPeriod,oidActivityPeriod, approot)%></td>
                                              </tr>
                                            </table>
                                          </td>
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
								
								ctrLine.setFirstImage("<img name=\"Image23x\" border=\"0\" src=\""+approot+"/images/first.gif\" alt=\"First\">");
								   ctrLine.setPrevImage("<img name=\"Image24x\" border=\"0\" src=\""+approot+"/images/prev.gif\" alt=\"Prev\">");
								   ctrLine.setNextImage("<img name=\"Image25x\" border=\"0\" src=\""+approot+"/images/next.gif\" alt=\"Next\">");
								   ctrLine.setLastImage("<img name=\"Image26x\" border=\"0\" src=\""+approot+"/images/last.gif\" alt=\"Last\">");
								   
								   ctrLine.setFirstOnMouseOver("MM_swapImage('Image23x','','"+approot+"/images/first2.gif',1)");
								   ctrLine.setPrevOnMouseOver("MM_swapImage('Image24x','','"+approot+"/images/prev2.gif',1)");
								   ctrLine.setNextOnMouseOver("MM_swapImage('Image25x','','"+approot+"/images/next2.gif',1)");
								   ctrLine.setLastOnMouseOver("MM_swapImage('Image26x','','"+approot+"/images/last2.gif',1)");
								 %>
                                            <%=ctrLine.drawImageListLimit(cmd,vectSize,start,recordToGet)%> </span> </td>
                                        </tr>
                                        <tr align="left" valign="top">
                                          <td height="12" valign="middle" colspan="3">&nbsp;</td>
                                        </tr>
                                        <%if(iJSPCommand!=JSPCommand.ADD && iJSPCommand!=JSPCommand.EDIT && iJSPCommand!=JSPCommand.ASK && iErrCode==0){%>
										<%if(listActivityPeriod==null || listActivityPeriod.size()==0){%>
                                        <tr align="left" valign="top"> 
                                          <td height="22" valign="middle" colspan="3"><a href="javascript:cmdAdd()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new21','','../images/new2.gif',1)"><img src="../images/new.gif" name="new21" width="71" height="22" border="0"></a></td>
                                        </tr>
										<%}%>
                                        <%
						if(listActivityPeriod!=null && listActivityPeriod.size()>0){%>
                                        <tr align="left" valign="top"> 
                                          <td height="22" valign="middle" colspan="3"><a href="javascript:cmdClose()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new211','','../images/closeperiode2.gif',1)"><img src="../images/closeperiode.gif" name="new211" border="0"></a> 
                                          </td>
                                        </tr>
                                        <%
						}
						%>
                                        <%}%>
                                      </table>
                              </td>
                            </tr>
                            <tr align="left" valign="top"> 
                              <td height="8" valign="middle" width="17%">&nbsp;</td>
                              <td height="8" colspan="2" width="83%"> </td>
                            </tr>
                            <tr align="left" valign="top" > 
                              <td colspan="3" class="command"> 
                                <%
									ctrLine.setLocationImg(approot+"/images/ctr_line");
									ctrLine.initDefault();
									ctrLine.setTableWidth("50%");
									String scomDel = "javascript:cmdAsk('"+oidActivityPeriod+"')";
									String sconDelCom = "javascript:cmdConfirmDelete('"+oidActivityPeriod+"')";
									String scancel = "javascript:cmdEdit('"+oidActivityPeriod+"')";
									ctrLine.setBackCaption("Back to List");
									ctrLine.setJSPCommandStyle("buttonlink");
									
									ctrLine.setOnMouseOut("MM_swapImgRestore()");
									ctrLine.setOnMouseOverSave("MM_swapImage('save','','"+approot+"/images/save2.gif',1)");
									ctrLine.setSaveImage("<img src=\""+approot+"/images/save.gif\" name=\"save\" height=\"22\" border=\"0\">");
									
									//ctrLine.setOnMouseOut("MM_swapImgRestore()");
									ctrLine.setOnMouseOverBack("MM_swapImage('back','','"+approot+"/images/cancel2.gif',1)");
									ctrLine.setBackImage("<img src=\""+approot+"/images/cancel.gif\" name=\"back\" height=\"22\" border=\"0\">");
									
									ctrLine.setOnMouseOverDelete("MM_swapImage('delete','','"+approot+"/images/delete2.gif',1)");
									ctrLine.setDeleteImage("<img src=\""+approot+"/images/delete.gif\" name=\"delete\" height=\"22\" border=\"0\">");
									
									ctrLine.setOnMouseOverEdit("MM_swapImage('edit','','"+approot+"/images/cancel2.gif',1)");
									ctrLine.setEditImage("<img src=\""+approot+"/images/cancel.gif\" name=\"edit\" height=\"22\" border=\"0\">");
									
									
									ctrLine.setWidthAllJSPCommand("90");
									ctrLine.setErrorStyle("warning");
									ctrLine.setErrorImage(approot+"/images/error.gif\" width=\"20\" height=\"20");
									ctrLine.setQuestionStyle("warning");
									ctrLine.setQuestionImage(approot+"/images/error.gif\" width=\"20\" height=\"20");
									ctrLine.setInfoStyle("success");
									ctrLine.setSuccessImage(approot+"/images/success.gif\" width=\"20\" height=\"20");

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
                                <%if((iJSPCommand ==JSPCommand.ADD)||(iJSPCommand==JSPCommand.SAVE)&&(iErrCode!=0)||(iJSPCommand==JSPCommand.EDIT)||(iJSPCommand==JSPCommand.ASK)){%>
                                <%= ctrLine.drawImageOnly(iJSPCommand, iErrCode, msgString)%> 
                                <%}%>
                              </td>
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
