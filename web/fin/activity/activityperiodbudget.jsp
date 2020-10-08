
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.main.entity.*" %>
<%@ page import = "com.project.fms.activity.*" %>
<%@ page import = "com.project.*" %>
<%@ include file = "../main/javainit.jsp" %>
<% int  appObjCode = 1; %>
<%
            boolean priv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_WORKPLAN);
            boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_WORKPLAN, AppMenu.PRIV_VIEW);
            boolean privUpdate = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_WORKPLAN, AppMenu.PRIV_UPDATE);
            boolean privAdd = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_WORKPLAN, AppMenu.PRIV_ADD);
            boolean privDelete = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_WORKPLAN, AppMenu.PRIV_DELETE);
%>
<!-- Jsp Block -->
<%!

	public String drawList(Vector objectClass ,  long donorActivityPeriodId)

	{
		JSPList cmdist = new JSPList();
		cmdist.setAreaWidth("60%");
		cmdist.setListStyle("listgen");
		cmdist.setTitleStyle("tablehdr");
		cmdist.setCellStyle("tablecell");
		//cmdist.setCellStyle("tablecell1");
		cmdist.setHeaderStyle("tablehdr");
		cmdist.addHeader("Activity Period","20%");
		cmdist.addHeader("Start Date","15%");
		cmdist.addHeader("End Date","15%");
		cmdist.addHeader("Status","20%");
		//cmdist.addHeader("Donor Component Id","20%");
		cmdist.addHeader("Budget","30%");
		//cmdist.addHeader("Allocation","20%");
		//dist.addHeader("Module Id","20%");

		cmdist.setLinkRow(0);
		cmdist.setLinkSufix("");
		Vector lstData = cmdist.getData();
		Vector lstLinkData = cmdist.getLinkData();
		cmdist.setLinkPrefix("javascript:cmdEdit('");
		cmdist.setLinkSufix("')");
		cmdist.reset();
		int index = -1;

		for (int i = 0; i < objectClass.size(); i++) {
			ActivityPeriodBudget donorActivityPeriod = (ActivityPeriodBudget)objectClass.get(i);
			 Vector rowx = new Vector();
			 if(donorActivityPeriodId == donorActivityPeriod.getOID())
				 index = i;

			ActivityPeriod a = new ActivityPeriod();
			try{
				a = DbActivityPeriod.fetchExc(donorActivityPeriod.getActivityPeriodId());
			}
			catch(Exception e){
			}			

			rowx.add(a.getName());
			
			rowx.add("<div align=\"center\">"+JSPFormater.formatDate(a.getStartDate(),"dd MMMM yyyy")+"</div>");
			rowx.add("<div align=\"center\">"+JSPFormater.formatDate(a.getEndDate(),"dd MMMM yyyy")+"</div>");
			rowx.add("<div align=\"center\">"+a.getStatus()+"</div>");

			//rowx.add(String.valueOf(donorActivityPeriod.getDonorComponentId()));

			rowx.add("<div align=\"right\">"+String.valueOf(JSPFormater.formatNumber(donorActivityPeriod.getBudget(), "#,###.##"))+"</div>");

			//rowx.add(String.valueOf(donorActivityPeriod.getAllocation()));

			//rowx.add(String.valueOf(donorActivityPeriod.getModuleId()));

			lstData.add(rowx);
			lstLinkData.add(String.valueOf(donorActivityPeriod.getOID()));
		}

		return cmdist.draw(index);
	}

%>
<%
int iJSPCommand = JSPRequestValue.requestCommand(request);
int start = JSPRequestValue.requestInt(request, "start");
int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
long oidActivityPeriodBudget = JSPRequestValue.requestLong(request, "hidden_donor_activity_period_id");
long oidModule = JSPRequestValue.requestLong(request, "hidden_module_id");

//out.println("oidModule : "+oidModule);
Module module = new Module();
try{
	module = DbModule.fetchExc(oidModule);
}
catch(Exception e){
}

/*variable declaration*/
int recordToGet = 10;
String msgString = "";
int iErrCode = JSPMessage.NONE;
String whereClause = "module_id="+oidModule;
String orderClause = "";

CmdActivityPeriodBudget ctrlActivityPeriodBudget = new CmdActivityPeriodBudget(request);
JSPLine ctrLine = new JSPLine();
Vector listActivityPeriodBudget = new Vector(1,1);

/*switch statement */
iErrCode = ctrlActivityPeriodBudget.action(iJSPCommand , oidActivityPeriodBudget);
/* end switch*/
JspActivityPeriodBudget jspActivityPeriodBudget = ctrlActivityPeriodBudget.getForm();

/*count list All ActivityPeriodBudget*/
int vectSize = DbActivityPeriodBudget.getCount(whereClause);

ActivityPeriodBudget donorActivityPeriod = ctrlActivityPeriodBudget.getActivityPeriodBudget();
msgString =  ctrlActivityPeriodBudget.getMessage();


if((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV )||
  (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)){
		start = ctrlActivityPeriodBudget.actionList(iJSPCommand, start, vectSize, recordToGet);
 } 
/* end switch list*/

/* get record to display */
listActivityPeriodBudget = DbActivityPeriodBudget.list(start,recordToGet, whereClause , orderClause);

/*handle condition if size of record to display = 0 and start > 0 	after delete*/
if (listActivityPeriodBudget.size() < 1 && start > 0)
{
	 if (vectSize - recordToGet > recordToGet)
			start = start - recordToGet;   //go to JSPCommand.PREV
	 else{
		 start = 0 ;
		 iJSPCommand = JSPCommand.FIRST;
		 prevJSPCommand = JSPCommand.FIRST; //go to JSPCommand.FIRST
	 }
	 listActivityPeriodBudget = DbActivityPeriodBudget.list(start,recordToGet, whereClause , orderClause);
}
%>
<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
<head>
<!-- #BeginEditable "javascript" --> 
<title><%=systemTitle%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<link href="../css/default.css" rel="stylesheet" type="text/css" />
<link href="../css/css.css" rel="stylesheet" type="text/css" />
<script language="JavaScript">
<!--
<%if(!priv || !privView){%>
	window.location="<%=approot%>/nopriv.jsp";
<%}%>

function cmdAdd(){
	document.frmdonoractivityperiod.hidden_donor_activity_period_id.value="0";
	document.frmdonoractivityperiod.command.value="<%=JSPCommand.ADD%>";
	document.frmdonoractivityperiod.prev_command.value="<%=prevJSPCommand%>";
	document.frmdonoractivityperiod.action="activityperiodbudget.jsp";
	document.frmdonoractivityperiod.submit();
}

function cmdAsk(oidActivityPeriodBudget){
	document.frmdonoractivityperiod.hidden_donor_activity_period_id.value=oidActivityPeriodBudget;
	document.frmdonoractivityperiod.command.value="<%=JSPCommand.ASK%>";
	document.frmdonoractivityperiod.prev_command.value="<%=prevJSPCommand%>";
	document.frmdonoractivityperiod.action="activityperiodbudget.jsp";
	document.frmdonoractivityperiod.submit();
}

function cmdConfirmDelete(oidActivityPeriodBudget){
	document.frmdonoractivityperiod.hidden_donor_activity_period_id.value=oidActivityPeriodBudget;
	document.frmdonoractivityperiod.command.value="<%=JSPCommand.DELETE%>";
	document.frmdonoractivityperiod.prev_command.value="<%=prevJSPCommand%>";
	document.frmdonoractivityperiod.action="activityperiodbudget.jsp";
	document.frmdonoractivityperiod.submit();
}
function cmdSave(){
	document.frmdonoractivityperiod.command.value="<%=JSPCommand.SAVE%>";
	document.frmdonoractivityperiod.prev_command.value="<%=prevJSPCommand%>";
	document.frmdonoractivityperiod.action="activityperiodbudget.jsp";
	document.frmdonoractivityperiod.submit();
	}

function cmdEdit(oidActivityPeriodBudget){
	document.frmdonoractivityperiod.hidden_donor_activity_period_id.value=oidActivityPeriodBudget;
	document.frmdonoractivityperiod.command.value="<%=JSPCommand.EDIT%>";
	document.frmdonoractivityperiod.prev_command.value="<%=prevJSPCommand%>";
	document.frmdonoractivityperiod.action="activityperiodbudget.jsp";
	document.frmdonoractivityperiod.submit();
	}

function cmdCancel(oidActivityPeriodBudget){
	document.frmdonoractivityperiod.hidden_donor_activity_period_id.value=oidActivityPeriodBudget;
	document.frmdonoractivityperiod.command.value="<%=JSPCommand.EDIT%>";
	document.frmdonoractivityperiod.prev_command.value="<%=prevJSPCommand%>";
	document.frmdonoractivityperiod.action="activityperiodbudget.jsp";
	document.frmdonoractivityperiod.submit();
}

function cmdBack(){
	document.frmdonoractivityperiod.command.value="<%=JSPCommand.BACK%>";
	document.frmdonoractivityperiod.action="activityperiodbudget.jsp";
	document.frmdonoractivityperiod.submit();
	}

function cmdListFirst(){
	document.frmdonoractivityperiod.command.value="<%=JSPCommand.FIRST%>";
	document.frmdonoractivityperiod.prev_command.value="<%=JSPCommand.FIRST%>";
	document.frmdonoractivityperiod.action="activityperiodbudget.jsp";
	document.frmdonoractivityperiod.submit();
}

function cmdListPrev(){
	document.frmdonoractivityperiod.command.value="<%=JSPCommand.PREV%>";
	document.frmdonoractivityperiod.prev_command.value="<%=JSPCommand.PREV%>";
	document.frmdonoractivityperiod.action="activityperiodbudget.jsp";
	document.frmdonoractivityperiod.submit();
	}

function cmdListNext(){
	document.frmdonoractivityperiod.command.value="<%=JSPCommand.NEXT%>";
	document.frmdonoractivityperiod.prev_command.value="<%=JSPCommand.NEXT%>";
	document.frmdonoractivityperiod.action="activityperiodbudget.jsp";
	document.frmdonoractivityperiod.submit();
}

function cmdListLast(){
	document.frmdonoractivityperiod.command.value="<%=JSPCommand.LAST%>";
	document.frmdonoractivityperiod.prev_command.value="<%=JSPCommand.LAST%>";
	document.frmdonoractivityperiod.action="activityperiodbudget.jsp";
	document.frmdonoractivityperiod.submit();
}

var sysDecSymbol = "<%=sSystemDecimalSymbol%>";
var usrDigitGroup = "<%=sUserDigitGroup%>";
var usrDecSymbol = "<%=sUserDecimalSymbol%>";

function changeData(){
	var dat = parseFloat('0');
	//alert('a');
    var sdat = cleanNumberFloat(document.frmdonoractivityperiod.<%=jspActivityPeriodBudget.colNames[JspActivityPeriodBudget.JSP_BUDGET] %>.value, sysDecSymbol, usrDigitGroup, usrDecSymbol);
    if(!isNaN(sdat)){
        dat = parseFloat(sdat);
    }
	document.frmdonoractivityperiod.<%=jspActivityPeriodBudget.colNames[JspActivityPeriodBudget.JSP_BUDGET] %>.value = formatFloat(dat, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);
}

//-------------- script control line -------------------
//-->
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
                      <td class="title"><!-- #BeginEditable "title" -->
					  <%
					  String navigator = "<font class=\"lvl1\">Activity Period</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">Budget</span></font>";
					  %>
					  <%@ include file="../main/navigator.jsp"%>
					  <!-- #EndEditable --></td>
                    </tr>
                    <!--tr> 
                      <td><img src="<%=approot%>/images/title-sp.gif" width="584" height="1"></td> 
                    </tr-->
                    <tr> 
                      <td><!-- #BeginEditable "content" --> 
              <form name="frmdonoractivityperiod" method ="post" action="">
                <input type="hidden" name="command" value="<%=iJSPCommand%>">
                <input type="hidden" name="vectSize" value="<%=vectSize%>">
                <input type="hidden" name="start" value="<%=start%>">
                <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                <input type="hidden" name="hidden_donor_activity_period_id" value="<%=oidActivityPeriodBudget%>">
				<input type="hidden" name="hidden_module_id" value="<%=oidModule%>">
				<input type="hidden" name="menu_idx" value="<%=menuIdx%>">
				<input type="hidden" name="<%=jspActivityPeriodBudget.colNames[JspActivityPeriodBudget.JSP_MODULE_ID] %>" value="<%=oidModule%>">
				
                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                  <tr align="left" valign="top"> 
                    <td height="8"  colspan="3"> 
                      <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr align="left" valign="top"> 
                          <td height="8" valign="middle" colspan="3"> 
                                      <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                        <tr> 
                                          <td height="8"></td>
                                        </tr>
                                        <tr> 
                                          <td height="16"> 
                                            <table width="57%" border="0" cellpadding="1" height="20" cellspacing="1">
                                              <tr> 
                                                <td width="17%" bgcolor="#CCCCCC" onClick=""> 
                                                  <div align="center"><a href="javascript:cmdActivity()"><font color="#666666">ACTIVITY</font></a></div>
                                                </td>
                                                <td width="18%" bgcolor="#CCCCCC" onClick=""> 
                                                  <div align="center"> <font color="#666666">ACCOUNT 
                                                    LIST</font></div>
                                                </td>
                                                <td width="31%" bgcolor="#666666"> 
                                                  <div align="center"><font color="#FFFFFF"><b>ACTIVITY 
                                                    PERIOD &amp; BUDGETING</b> 
                                                    </font></div>
                                                </td>
                                                <td width="34%" bgcolor="#CCCCCC"> 
                                                  <div align="center"><font color="#666666">DONOR 
                                                    COMPONENTS &amp; BUDGETING</font> 
                                                  </div>
                                                </td>
                                              </tr>
                                            </table>
                                          </td>
                                        </tr>
                                      </table>
                          </td>
                        </tr>
                        <tr align="left" valign="top"> 
                          <td height="14" valign="middle" colspan="3" class="comment">&nbsp;</td>
                        </tr>
                        <tr align="left" valign="top"> 
                          <td height="14" valign="middle" colspan="3" class="comment">&nbsp;<b><%=module.getCode()+ " - "+module.getDescription()%></b></td>
                        </tr>
                        <tr align="left" valign="top"> 
                          <td height="14" valign="middle" colspan="3" class="comment">&nbsp;</td>
                        </tr>
                        <%
							try{
								if (listActivityPeriodBudget.size()>0){
							%>
                        <tr align="left" valign="top"> 
                          <td height="22" valign="middle" colspan="3"> <%= drawList(listActivityPeriodBudget,oidActivityPeriodBudget)%> </td>
                        </tr>
                        <%  } 
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
                        <%if(iJSPCommand!=JSPCommand.ADD && iJSPCommand!=JSPCommand.EDIT && iJSPCommand!=JSPCommand.ASK && iErrCode==0){%>
                        <tr align="left" valign="top"> 
                          <td height="22" valign="middle" colspan="3">&nbsp;<a href="javascript:cmdAdd()" class="command"><u>Add 
                            New</u></a></td>
                        </tr>
                        <%}%>
                      </table>
                    </td>
                  </tr>
                  <tr align="left" valign="top"> 
                    <td height="8" valign="middle" colspan="3"> 
                      <%if((iJSPCommand ==JSPCommand.ADD)||(iJSPCommand==JSPCommand.SAVE)&&(iErrCode!=0)||(iJSPCommand==JSPCommand.EDIT)||(iJSPCommand==JSPCommand.ASK)){%>
                      <table width="100%" border="0" cellspacing="1" cellpadding="0">
                        <tr align="left"> 
                          <td height="21" valign="middle" width="9%">&nbsp;</td>
                          <td height="21" colspan="2" width="91%" class="comment" valign="top">&nbsp;</td>
                        </tr>
                        <tr align="left">
                          <td height="21" valign="middle" width="9%">&nbsp;</td>
                          <td height="21" colspan="2" width="91%" class="comment" valign="top">&nbsp;</td>
                        </tr>
                        <tr align="left">
                          <td height="21" valign="middle" width="9%">&nbsp;</td>
                          <td height="21" colspan="2" width="91%" class="comment" valign="top">*)= 
                            required</td>
                        </tr>
                        <tr align="left"> 
                          <td height="21" width="9%">&nbsp;Activity Period</td>
                          <td height="21" colspan="2" width="91%" valign="top"> 
                            <%
							Vector pers = DbActivityPeriod.list(0,0, "status='"+I_Project.STATUS_PERIOD_OPEN+"' or status='"+I_Project.STATUS_PERIOD_PREPARED_OPEN+"'", "start_date");
							
							%>
                            <select name="<%=jspActivityPeriodBudget.colNames[JspActivityPeriodBudget.JSP_ACTIVITY_PERIOD_ID] %>">
                              <%if(pers!=null && pers.size()>0){
							  		for(int i=0; i<pers.size(); i++){
										ActivityPeriod ap = (ActivityPeriod)pers.get(i);
							  %>
                              <option value="<%=ap.getOID()%>" <%if(ap.getOID()==donorActivityPeriod.getActivityPeriodId()){%>selected<%}%>><%=ap.getName()+" : "+JSPFormater.formatDate(ap.getStartDate(), "dd MMMM yyyy")+" - "+JSPFormater.formatDate(ap.getEndDate(), "dd MMMM yyyy")%></option>
                              <%}}%>
                            </select>
                            * <%= jspActivityPeriodBudget.getErrorMsg(jspActivityPeriodBudget.JSP_ACTIVITY_PERIOD_ID) %> 
                        <tr align="left"> 
                          <td height="21" width="9%">&nbsp;Budget</td>
                          <td height="21" colspan="2" width="91%" valign="top"> 
                            <input type="text" name="<%=jspActivityPeriodBudget.colNames[JspActivityPeriodBudget.JSP_BUDGET] %>"  value="<%= JSPFormater.formatNumber(donorActivityPeriod.getBudget(),"#,###.##") %>" class="formElemen" size="25" style="text-align:right" onBlur="javascript:changeData()">
                            * <%= jspActivityPeriodBudget.getErrorMsg(jspActivityPeriodBudget.JSP_BUDGET) %> 
                        <tr align="left"> 
                          <td height="8" valign="middle" width="9%">&nbsp;</td>
                          <td height="8" colspan="2" width="91%" valign="top">&nbsp; 
                          </td>
                        </tr>
                        <tr align="left" > 
                          <td colspan="3" class="command" valign="top"> 
                            <%
									ctrLine.setLocationImg(approot+"/images/ctr_line");
									ctrLine.initDefault();
									ctrLine.setTableWidth("50%");
									String scomDel = "javascript:cmdAsk('"+oidActivityPeriodBudget+"')";
									String sconDelCom = "javascript:cmdConfirmDelete('"+oidActivityPeriodBudget+"')";
									String scancel = "javascript:cmdEdit('"+oidActivityPeriodBudget+"')";
									ctrLine.setBackCaption("Back to List");
									ctrLine.setJSPCommandStyle("buttonlink");
										ctrLine.setDeleteCaption("Delete");
										ctrLine.setSaveCaption("Save");
										ctrLine.setAddCaption("");

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
                        <tr> 
                          <td width="9%">&nbsp;</td>
                          <td width="91%">&nbsp;</td>
                        </tr>
                        <tr align="left" > 
                          <td colspan="3" valign="top"> 
                            <div align="left"></div>
                          </td>
                        </tr>
                      </table>
                      <%}%>
                    </td>
                  </tr>
                </table>
              </form>
              <title></title>
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
