 
<%@ page language="java"%>
<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.system.*" %>
<%@ page import = "com.project.main.db.*" %>
<%@ page import = "com.project.fms.activity.*" %>
<%@ page import = "java.util.Date" %>
<%@ page import = "com.project.*" %>
<%@ include file="../main/javainit.jsp"%>
<%@ include file="../main/check.jsp"%>
<%
/* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
boolean privAdd=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ADD));
boolean privUpdate=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_UPDATE));
boolean privDelete=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_DELETE));
%>
<%!
public double getValueX(Module m, Vector selected){
	
	if(selected!=null && selected.size()>0){
		for(int i=0; i<selected.size(); i++){
			CoaActivityBudgetDetail cabd = (CoaActivityBudgetDetail)selected.get(i);	
			if(cabd.getModuleId()==m.getOID()){
				return cabd.getPercent();
			}
		}
	}
	
	return 0;
}
%>
<%
int iJSPCommand = JSPRequestValue.requestCommand(request);
long activityPeriodId = JSPRequestValue.requestLong(request, "activity_period_id");
long coaActivityBudgetId = JSPRequestValue.requestLong(request, "hidden_coa_activity_budget_id");

//out.println("coaActivityBudgetId : "+coaActivityBudgetId);

ActivityPeriod openAp = openAp = DbActivityPeriod.getOpenPeriod();

JSPLine ctrLine = new JSPLine();

if(activityPeriodId==0){	
	activityPeriodId = openAp.getOID();
}

boolean isOpen = true;
if(activityPeriodId != openAp.getOID()){
	isOpen = false;
}

//jsp content
//Vector listCoa = DbCoa.list(0,0, "(account_group='"+I_Project.ACC_GROUP_EXPENSE+"' or account_group='"+I_Project.ACC_GROUP_OTHER_EXPENSE+"') and status='POSTABLE'", "code");
Vector listCoa = DbCoa.list(0,0, "", "code");

//out.println("listCoa :"+listCoa);

Vector submodules = DbModule.list(0,0, "level='S' and activity_period_id="+activityPeriodId, "code");
Vector selected = new Vector();


Vector expenseCategory = DbCoaExpenseCategory.list(0,0, "", "");

Vector natureExpenseCategory = DbCoaNatureExpenseCategory.list(0,0, "", "");

//out.println("submodules : "+submodules);
//------------------------------------

/*variable declaration*/
int recordToGet = 10;
String msgString = "";
int iErrCode = JSPMessage.NONE;
String whereClause = "";
String orderClause = "";


CmdCoaActivityBudget ctrlCoaActivityBudget = new CmdCoaActivityBudget(request);
iErrCode = ctrlCoaActivityBudget.action(iJSPCommand, coaActivityBudgetId);
JspCoaActivityBudget jspCoaActivityBudget = ctrlCoaActivityBudget.getForm();
CoaActivityBudget coaActivityBudget = ctrlCoaActivityBudget.getCoaActivityBudget();
msgString =  ctrlCoaActivityBudget.getMessage();

//out.println("coa : "+coaActivityBudget.getCoaId());

if(iJSPCommand==JSPCommand.ADD && coaActivityBudgetId==0){
	coaActivityBudget.setAdminPercent(100);
}

if(iJSPCommand==JSPCommand.SAVE){

	if(submodules!=null && submodules.size()>0){
		for(int i=0; i<submodules.size(); i++){
			Module m = (Module)submodules.get(i);			
			double percent = JSPRequestValue.requestLong(request, "mdl_"+m.getOID());
			if(percent>0){
				CoaActivityBudgetDetail cabd = new CoaActivityBudgetDetail();
				cabd.setModuleId(m.getOID());
				cabd.setPercent(percent);
				cabd.setCoaActivityBudgetId(coaActivityBudgetId);
				selected.add(cabd);			
			}
		}
	}
	
	if(iErrCode==0){
		DbCoaActivityBudgetDetail.processDetails(selected, coaActivityBudgetId);
	}
}



%>
<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
<head>
<!-- #BeginEditable "javascript" --> 
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title><%=systemTitle%></title>
<link href="../css/css.css" rel="stylesheet" type="text/css" />

<script type="text/javascript">
<!--



<%if(!masterPriv){%>
	window.location="<%=approot%>/nopriv.jsp";
<%}%>

var sysDecSymbol = "<%=sSystemDecimalSymbol%>";
var usrDigitGroup = "<%=sUserDigitGroup%>";
var usrDecSymbol = "<%=sUserDecimalSymbol%>";

function removeChar(number){
	
	var ix;
	var result = "";
	for(ix=0; ix<number.length; ix++){
		var xx = number.charAt(ix);
		//alert(xx);
		if(!isNaN(xx) && xx!=" "){
			result = result + xx;
		}
		else{
			if(xx==',' || xx=='.'){
				result = result + xx;
			}
		}
	}
	
	return result;
}

function cmdUpdateData(){

	//alert(oid);
	var fa = document.form1.<%=JspCoaActivityBudget.colNames[JspCoaActivityBudget.JSP_ADMIN_PERCENT]%>.value;
	fa = removeChar(fa);
	
	var total = 0;
	var logs = document.form1.<%=JspCoaActivityBudget.colNames[JspCoaActivityBudget.JSP_LOGISTIC_PERCENT]%>.value;
	//logs.trim();
	logs = removeChar(logs);
	
	document.form1.<%=JspCoaActivityBudget.colNames[JspCoaActivityBudget.JSP_LOGISTIC_PERCENT]%>.value=logs;
	if(logs.length>0 && logs!=" "){
		//alert('log lebih');
		total = parseFloat(logs);
		//alert('logs : '+logs);
	}
	
	<%
	if(submodules!=null && submodules.size()>0){
		for(int ix=0; ix<submodules.size(); ix++){
			Module mm = (Module)submodules.get(ix);
			%>
			var mmpx = document.form1.mdl_<%=mm.getOID()%>.value;
			//alert("mmpx :"+mmpx);
			if(mmpx.length>0 && mmpx!=" "){
				//alert('mmpx : '+mmpx);
				mmpx = removeChar(mmpx);
				total = total + parseFloat(mmpx);
				if(100-total<0){
					alert('invalid percentage amount');
					document.form1.mdl_<%=mm.getOID()%>.value="";
					document.form1.mdl_<%=mm.getOID()%>.focus();
					total = total - parseFloat(mmpx);
				}
				
			}
			<%
		}
	}
	%>
	
	//alert("total : "+total);
	document.form1.<%=JspCoaActivityBudget.colNames[JspCoaActivityBudget.JSP_ADMIN_PERCENT]%>.value=100-total;

}

function cmdBack(){
	document.form1.command.value="<%=JSPCommand.LIST%>";
	document.form1.action="coaexpensebudget.jsp";
	document.form1.submit();
}

function cmdSave(){
	document.form1.command.value="<%=JSPCommand.SAVE%>";
	document.form1.action="coaexpensebudgetedt.jsp";
	document.form1.submit();
}

function cmdAdd(){
	document.form1.hidden_coa_activity_budget_id.value="0";
	document.form1.command.value="<%=JSPCommand.ADD%>";
	document.form1.action="coaexpensebudgetedt.jsp";
	document.form1.submit();
}

function cmdAsk(oid){
	document.form1.command.value="<%=JSPCommand.ASK%>";
	document.form1.hidden_coa_activity_budget_id.value=oid;
	document.form1.action="coaexpensebudgetedt.jsp";
	document.form1.submit();
}

function cmdEdit(oid){
	document.form1.command.value="<%=JSPCommand.EDIT%>";
	document.form1.hidden_coa_activity_budget_id.value=oid;
	document.form1.action="coaexpensebudgetedt.jsp";
	document.form1.submit();
}

function cmdDelete(oid){
	document.form1.command.value="<%=JSPCommand.DELETE%>";
	document.form1.hidden_coa_activity_budget_id.value=oid;
	document.form1.action="coaexpensebudgetedt.jsp";
	document.form1.submit();
}

<!--

//-->//-->
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
					  String navigator = "<font class=\"lvl1\">Master</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">Expense Predefined Editor</span></font>";
					  %>
					  <%@ include file="../main/navigator.jsp"%>
					  <!-- #EndEditable --></td>
                    </tr>
                    <!--tr> 
                      <td><img src="<%=approot%>/images/title-sp.gif" width="584" height="1"></td> 
                    </tr-->
                    <tr> 
                      <td><!-- #BeginEditable "content" --> 
                        <form id="form1" name="form1" method="post" action="">
                          <input type="hidden" name="command">
						  <input type="hidden" name="hidden_coa_activity_budget_id" value="<%=coaActivityBudgetId%>">
						  <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
						  <input type="hidden" name="<%=JspCoaActivityBudget.colNames[JspCoaActivityBudget.JSP_ACTIVITY_PERIOD_ID]%>" value="<%=openAp.getOID()%>">
						  
                          <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr> 
                              <td class="container"> 
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                  <tr> 
                                    <td> 
                                      <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                        <tr > 
                                          <td>&nbsp;</td>
                                          <td>&nbsp;</td>
                                          <td>&nbsp;</td>
                                          <td>&nbsp;</td>
                                          <td>&nbsp;</td>
                                          <td>&nbsp;</td>
                                          <td width="100%">&nbsp;</td>
                                        </tr>
                                        <tr > 
                                          <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="17" height="10"></td>
                                          <td class="tabin"> 
                                            <div align="center">&nbsp;&nbsp;<a href="javascript:cmdBack()" class="tablink">Records</a>&nbsp;&nbsp;</div>
                                          </td>
                                          <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                          <td class="tab"> 
                                            <div align="center">&nbsp;&nbsp;Editor&nbsp;&nbsp;</div>
                                          </td>
                                          <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                          <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                          <td width="100%" class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="10" height="10"></td>
                                        </tr>
                                      </table>
                                    </td>
                                  </tr>
                                  <tr> 
                                    <td class="page"> 
                                      <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                        <tr> 
                                          <td width="12%">&nbsp;</td>
                                          <td width="37%">&nbsp;</td>
                                          <td width="51%">&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td width="12%">Account</td>
                                          <td width="37%"> 
                                            <select name="<%=JspCoaActivityBudget.colNames[JspCoaActivityBudget.JSP_COA_ID]%>">
                                              <%if(listCoa!=null && listCoa.size()>0){
									   		for(int i=0; i<listCoa.size(); i++){
												Coa coa = (Coa)listCoa.get(i);
												
												String str = "";
												switch(coa.getLevel()){
													case 1 : 											
														break;
													case 2 : 
														str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
														break;
													case 3 :
														str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
														break;
													case 4 :
														str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
														break;
													case 5 :
														str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
														break;				
												}
												
									   %>
                                              <option value="<%=coa.getOID()%>" <%if(coaActivityBudget.getCoaId()==coa.getOID()){%>selected<%}%>><%=str+coa.getCode()+" - "+coa.getName()%></option>
                                              <%}}%>
                                            </select>
                                            <%= (jspCoaActivityBudget.getErrorMsg(JspCoaActivityBudget.JSP_COA_ID).length()==0) ? "" : "<br>"+jspCoaActivityBudget.getErrorMsg(JspCoaActivityBudget.JSP_COA_ID) %> </td>
                                          <td width="51%">&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td width="12%">&nbsp;</td>
                                          <td width="37%">&nbsp;</td>
                                          <td width="51%">&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td colspan="2"> 
                                            <table width="76%" border="0" cellspacing="1" cellpadding="1">
                                              <tr> 
                                                <td height="19" class="tablehdr">Activity</td>
                                                <td height="19" class="tablehdr">Allocation 
                                                  (%) </td>
                                              </tr>
                                              <tr> 
                                                <td class="tablecell">&nbsp;&nbsp;F&amp;A</td>
                                                <td class="tablecell"> 
                                                  <div align="center"> 
                                                    <input type="text" name="<%=JspCoaActivityBudget.colNames[JspCoaActivityBudget.JSP_ADMIN_PERCENT]%>" class="readonly" style="text-align:center" value="<%=JSPFormater.formatNumber(coaActivityBudget.getAdminPercent(), "###")%>" size="10" readOnly>
                                                  </div>
                                                </td>
                                              </tr>
                                              <tr> 
                                                <td class="tablecell1">&nbsp;&nbsp;Logistic</td>
                                                <td class="tablecell1"> 
                                                  <div align="center"> 
                                                    <input type="text" name="<%=JspCoaActivityBudget.colNames[JspCoaActivityBudget.JSP_LOGISTIC_PERCENT]%>" style="text-align:center" value="<%=(coaActivityBudget.getLogisticPercent()==0) ? "" : JSPFormater.formatNumber(coaActivityBudget.getLogisticPercent(), "###")%>" onBlur="javascript:cmdUpdateData()" size="10" onClick="this.select()">
                                                  </div>
                                                </td>
                                              </tr>
                                              <%if(submodules!=null && submodules.size()>0){
										  		for(int i=0; i<submodules.size(); i++){
													Module mx = (Module)submodules.get(i);
													String str = "tablecell";
													if(i%2>0){
														str = "tablecell1";
													}
													
													double val = 0;
													if(iJSPCommand==JSPCommand.EDIT){
														String where = "module_id="+mx.getOID()+" and coa_activity_budget_id="+coaActivityBudget.getOID();
														Vector vx = DbCoaActivityBudgetDetail.list(0,0, where, "");
														CoaActivityBudgetDetail cxxd = new CoaActivityBudgetDetail();
														if(vx!=null && vx.size()>0){
															cxxd = (CoaActivityBudgetDetail)vx.get(0);
															val = cxxd.getPercent();
														}
													}
													else{
														val = getValueX(mx, selected);
													}
										  		%>
                                              <tr> 
                                                <td class="<%=str%>">&nbsp;&nbsp;<%=mx.getInitial()%></td>
                                                <td class="<%=str%>"> 
                                                  <div align="center"> 
                                                    <input type="text" name="mdl_<%=mx.getOID()%>" style="text-align:center" value="<%=(val==0) ? "" : JSPFormater.formatNumber(val, "###")%>" onBlur="javascript:cmdUpdateData()" size="10" onClick="this.select()">
                                                  </div>
                                                </td>
                                              </tr>
                                              <%}}%>
                                              <tr> 
                                                <td>&nbsp;</td>
                                                <td> 
                                                  <div align="center"></div>
                                                </td>
                                              </tr>
                                            </table>
                                          </td>
                                          <td width="51%">&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td colspan="2"> 
                                            <%
									ctrLine.setLocationImg(approot+"/images/ctr_line");
									ctrLine.initDefault();
									ctrLine.setTableWidth("50%");
									String scomDel = "javascript:cmdAsk('"+coaActivityBudgetId+"')";
									String sconDelCom = "javascript:cmdDelete('"+coaActivityBudgetId+"')";
									String scancel = "javascript:cmdEdit('"+coaActivityBudgetId+"')";
									ctrLine.setBackCaption("Go To Records");
									ctrLine.setJSPCommandStyle("buttonlink");
										ctrLine.setDeleteCaption("Delete");
										ctrLine.setSaveCaption("Save");
										ctrLine.setAddCaption("Add New");

									if (privDelete){
										ctrLine.setConfirmDelJSPCommand(sconDelCom);
										ctrLine.setDeleteJSPCommand(scomDel);
										ctrLine.setEditJSPCommand(scancel);
									}else{ 
										ctrLine.setConfirmDelCaption("");
										ctrLine.setDeleteCaption("");
										ctrLine.setEditCaption("");
									}
									
									
									ctrLine.setOnMouseOut("MM_swapImgRestore()");
									ctrLine.setOnMouseOverSave("MM_swapImage('save','','"+approot+"/images/save2.gif',1)");
									ctrLine.setSaveImage("<img src=\""+approot+"/images/save.gif\" name=\"save\" height=\"22\" border=\"0\">");
									
									ctrLine.setOnMouseOut("MM_swapImgRestore()");
									ctrLine.setOnMouseOverAddNew("MM_swapImage('new','','"+approot+"/images/new2.gif',1)");
									ctrLine.setAddNewImage("<img src=\""+approot+"/images/new.gif\" name=\"new\" height=\"22\" border=\"0\">");
									
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

									if(privAdd == false  && privUpdate == false){
										ctrLine.setSaveCaption("");
									}

									if (privAdd == false){
										ctrLine.setAddCaption("");
									}
									
									/*if(iJSPCommand==JSPCommand.SAVE && iErrCode==0){
										if(coaActivityBudgetId==0){
											iJSPCommand = JSPCommand.ADD;
										}
										else{
											iJSPCommand = JSPCommand.EDIT;
										}
									}*/
									
									%>
                                            <%= ctrLine.drawImageOnly(iJSPCommand, iErrCode, msgString)%> </td>
                                          <td width="51%">&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td width="12%">&nbsp;</td>
                                          <td width="37%">&nbsp;</td>
                                          <td width="51%">&nbsp;</td>
                                        </tr>
                                      </table>
                                    </td>
                                  </tr>
                                  <tr> 
                                    <td>&nbsp;</td>
                                  </tr>
                                </table>
                              </td>
                            </tr>
                            <tr> 
                              <td class="container">&nbsp; </td>
                            </tr>
                            <tr> 
                              <td>&nbsp;</td>
                            </tr>
                            <tr> 
                              <td>&nbsp;</td>
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
