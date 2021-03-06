 
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
            boolean priv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_WORKPLAN);
            boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_WORKPLAN, AppMenu.PRIV_VIEW);
            boolean privUpdate = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_WORKPLAN, AppMenu.PRIV_UPDATE);
            boolean privAdd = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_WORKPLAN, AppMenu.PRIV_ADD);
            boolean privDelete = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_WORKPLAN, AppMenu.PRIV_DELETE);
%>
<%
int iJSPCommand = JSPRequestValue.requestCommand(request);
long activityPeriodId = JSPRequestValue.requestLong(request, "activity_period_id");
ActivityPeriod openAp = openAp = DbActivityPeriod.getOpenPeriod();
if(activityPeriodId==0){	
	activityPeriodId = openAp.getOID();
}

boolean isOpen = true;
if(activityPeriodId != openAp.getOID()){
	isOpen = false;
}

//jsp content
Vector listCoa = DbCoaActivityBudget.getActivityCoaByPeriod(activityPeriodId);//DbCoa.list(0,0, "(account_group='"+I_Project.ACC_GROUP_EXPENSE+"' or account_group='"+I_Project.ACC_GROUP_OTHER_EXPENSE+"') and status='POSTABLE'", "code");

//out.println("listCoa :"+listCoa);

Vector submodules = DbModule.list(0,0, "level='S' and activity_period_id="+activityPeriodId, "code");

//out.println("submodules : "+submodules);

if(iJSPCommand==JSPCommand.SAVE){
	if(listCoa!=null && listCoa.size()>0){
		for(int i=0; i<listCoa.size(); i++){
			Coa c = (Coa)listCoa.get(i);
			
			CoaActivityBudget cab = new CoaActivityBudget();
			cab.setActivityPeriodId(openAp.getOID());
			cab.setCoaId(c.getOID());
			
			int direct = JSPRequestValue.requestInt(request, "direct_"+c.getOID());
			double fa = JSPRequestValue.requestDouble(request, "fa_"+c.getOID());
			double log = JSPRequestValue.requestDouble(request, "log_"+c.getOID());
			
			cab.setType(direct);
			cab.setAdminPercent(fa);
			cab.setLogisticPercent(log);
			
			Vector modulePercents = new Vector();
			
			if(submodules!=null && submodules.size()>0){
				for(int ix=0; ix<submodules.size(); ix++){
					Module mm = (Module)submodules.get(ix);
					double mmpx = JSPRequestValue.requestDouble(request, mm.getInitial()+"_"+c.getOID());
					
					if(mmpx>0){
						CoaActivityBudgetDetail cabd = new CoaActivityBudgetDetail();
						cabd.setModuleId(mm.getOID());
						cabd.setPercent(mmpx);
						
						modulePercents.add(cabd);
					}
				}
			}
			
			cab.setAdminPercent(fa);
			cab.setLogisticPercent(log);
			
			if(cab.getType()==1 && ((modulePercents!=null && modulePercents.size()>0) || cab.getAdminPercent()>0 || cab.getLogisticPercent()>0)){						
				cab.setDetails(modulePercents);				
				DbCoaActivityBudget.processData(cab);
			}
			else{
				DbCoaActivityBudget.deleteFromBudget(cab);
			}
			
		}
	}
}

%>
<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
<head>
<!-- #BeginEditable "javascript" --> 
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title><%=systemTitle%></title>
<link href="../css/css.css" rel="stylesheet" type="text/css" />
<script language="JavaScript">
<!--
<%if(!priv || !privView){%>
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

function cmdUpdateData(oid, prefix){
	<%if(listCoa!=null && listCoa.size()>0){
		for(int i=0; i<listCoa.size(); i++){
			Coa coax = (Coa)listCoa.get(i);			
	%>
			if('<%=coax.getOID()%>'==oid){
				//alert(oid);
				var fa = document.form1.fa_<%=coax.getOID()%>.value;
				fa = removeChar(fa);
				
				var total = 0;
				var logs = document.form1.log_<%=coax.getOID()%>.value;
				//logs.trim();
				logs = removeChar(logs);
				
				document.form1.log_<%=coax.getOID()%>.value=logs;
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
						var mmpx = document.form1.<%=mm.getInitial()+"_"+coax.getOID()%>.value;
						//alert("mmpx :"+mmpx);
						if(mmpx.length>0 && mmpx!=" "){
							//alert('mmpx : '+mmpx);
							mmpx = removeChar(mmpx);
							total = total + parseFloat(mmpx);
							if(100-total<0){
								alert('invalid percentage amount');
								document.form1.<%=mm.getInitial()+"_"+coax.getOID()%>.value="";
								document.form1.<%=mm.getInitial()+"_"+coax.getOID()%>.focus();
								total = total - parseFloat(mmpx);
							}
							
						}
						<%
					}
				}
				%>
				
				//alert("total : "+total);
				document.form1.fa_<%=coax.getOID()%>.value=100-total;
				
			}
	<%}}%>
}

function cmdCheckItxx(oid){
	
	//alert('xxx');
	<%if(listCoa!=null && listCoa.size()>0){
		for(int i=0; i<listCoa.size(); i++){
			Coa coax = (Coa)listCoa.get(i);			
	%>
			if('<%=coax.getOID()%>'==oid){
				//alert(oid);
				if(document.form1.direct_<%=coax.getOID()%>.checked){	
					//alert('checked');
					document.form1.fa_<%=coax.getOID()%>.value='100';
					cmdUpdateData(oid, 0);			
				}
			}
				
	<%}}%>
	
}

function cmdEdit(oid){
        <%if(privUpdate){%>
	document.form1.command.value="<%=JSPCommand.EDIT%>";
	document.form1.hidden_coa_activity_budget_id.value=oid;//"<%=JSPCommand.EDIT%>";
	document.form1.action="coaexpensebudgetedt.jsp";
	document.form1.submit();
         <%}%>
}

function cmdAdd(){
	document.form1.command.value="<%=JSPCommand.ADD%>";
	document.form1.action="coaexpensebudgetedt.jsp";
	document.form1.submit();
}

function cmdSaveBudget(){
	document.form1.command.value="<%=JSPCommand.SAVE%>";
	document.form1.action="coaexpensebudget.jsp";
	document.form1.submit();
}

function cmdChangePeriod(){
	document.form1.action="coaexpensebudget.jsp";
	document.form1.submit();
}

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
//-->
</script>
<!-- #EndEditable -->
</head>
<body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','../images/new2.gif')">
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
					  String navigator = "<font class=\"lvl1\">Activity Expense</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">Budget</span></font>";
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
						  <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
						  <input type="hidden" name="hidden_coa_activity_budget_id" value="">
						  
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
                                          <td class="tab"> 
                                            <div align="center">&nbsp;&nbsp;Records&nbsp;&nbsp;</div>
                                          </td>
                                          <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                          <td class="tabin"> 
                                            <div align="center">&nbsp;&nbsp;<a href="javascript:cmdAdd()" class="tablink">Editor</a>&nbsp;&nbsp;</div>
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
                                      <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                        <tr> 
                                          <td>&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td><b>Activity Period</b> &nbsp;&nbsp; 
                                            <%
											Vector actPeriods = DbActivityPeriod.list(0,0, "", "");											
											%>
                                            <select name="activity_period_id" onChange="javascript:cmdChangePeriod()">
                                              <%if(actPeriods!=null && actPeriods.size()>0){
											  		for(int i=0; i<actPeriods.size(); i++){
														ActivityPeriod ap = (ActivityPeriod)actPeriods.get(i);
											  %>
                                              <option value="<%=ap.getOID()%>" <%if(ap.getOID()==activityPeriodId){%>selected<%}%>><%=ap.getName()%></option>
                                              <%}}%>
                                            </select>
                                          </td>
                                        </tr>
                                        <tr> 
                                          <td>&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td> 
                                            <table width="100%" border="0" cellpadding="0" height="20" cellspacing="1">
                                              <tr> 
                                                <td class="tablehdr" height="43" rowspan="2"> 
                                                  <div align="center"><b><font color="#FFFFFF">Chart 
                                                    Of Account</font></b></div>
                                                </td>
                                                <td class="tablehdr" height="21" colspan="<%=2+((submodules!=null) ? submodules.size() : 0)%>">Allocation 
                                                  % </td>
                                              </tr>
                                              <tr> 
                                                <td class="tablehdr" height="21" nowrap width="45">F&amp;A</td>
                                                <td class="tablehdr" height="21" nowrap width="45">Logistic</td>
                                                <%if(submodules!=null && submodules.size()>0){
														for(int i=0; i<submodules.size(); i++){
															Module mdx = (Module)submodules.get(i);
												%>
                                                <td class="tablehdr" height="21" nowrap width="45"><%=mdx.getInitial()%></td>
                                                <%}}%>
                                              </tr>
                                              <%if(listCoa!=null && listCoa.size()>0){
												for(int i=0; i<listCoa.size(); i++){
													Coa coa = (Coa)listCoa.get(i);
													String str = "";
													/*switch(coa.getLevel()){
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
													}*/
													
													String cssString = "tablecell";
													if(i%2!=0){
														cssString = "tablecell1";
													}													
													
													String where = "activity_period_id="+activityPeriodId+" and coa_id="+coa.getOID();
													Vector vx = DbCoaActivityBudget.list(0,0, where, "");
													CoaActivityBudget cxx = new CoaActivityBudget();
													if(vx!=null && vx.size()>0){
														cxx = (CoaActivityBudget)vx.get(0);
													}
													
													
													
											  %>
                                              <tr> 
                                                <td class="<%=cssString%>" nowrap height="29"> 
                                                  <%if(isOpen){%>
                                                  <a href="javascript:cmdEdit('<%=cxx.getOID()%>')"><%=str+coa.getCode()+" - "+coa.getName()%></a> 
                                                  <%}else{%>
                                                  <%=str+coa.getCode()+" - "+coa.getName()%> 
                                                  <%}%>
                                                </td>
                                                <td class="<%=cssString%>" height="21" nowrap><div align="center"><%=(cxx.getAdminPercent()==0) ? "" : JSPFormater.formatNumber(cxx.getAdminPercent(), "###")%></div></td>
                                                <td class="<%=cssString%>" height="21" nowrap><div align="center"><%=(cxx.getLogisticPercent()==0) ? "" : JSPFormater.formatNumber(cxx.getLogisticPercent(), "###")%></div></td>
                                                <%if(submodules!=null && submodules.size()>0){
														for(int ixxx=0; ixxx<submodules.size(); ixxx++){
															Module mdx = (Module)submodules.get(ixxx);
															
															where = "module_id="+mdx.getOID()+" and coa_activity_budget_id="+cxx.getOID();
															vx = DbCoaActivityBudgetDetail.list(0,0, where, "");
															CoaActivityBudgetDetail cxxd = new CoaActivityBudgetDetail();
															if(vx!=null && vx.size()>0){
																cxxd = (CoaActivityBudgetDetail)vx.get(0);
															}
												%>
                                                <td class="<%=cssString%>" height="21" nowrap><div align="center"><%=(cxxd.getPercent()==0) ? "" : JSPFormater.formatNumber(cxxd.getPercent(), "###")%> </div></td>
                                                <%}}%>
                                                <!--td  class="<%=cssString%>" nowrap height="29" width="71%"> 
                                                  <div align="center"> 
                                                    <table width="100%" cellpadding="0" cellspacing="1">
                                                      <tr bgcolor="#999999"> 
                                                        <td width="45" class="<%=cssString%>" height="21"> 
                                                          <div align="center">F 
                                                            &amp;A </div>
                                                        </td>
                                                        <td width="45" class="<%=cssString%>" height="21"> 
                                                          <div align="center">Logictic</div>
                                                        </td>
                                                        <%if(submodules!=null && submodules.size()>0){
											  		for(int ix=0; ix<submodules.size(); ix++){
													Module mx = (Module)submodules.get(ix);
												  %>
                                                        <td width="45" class="<%=cssString%>" height="21"> 
                                                          <div align="center"><%=mx.getInitial()%></div>
                                                        </td>
                                                        <%}}//end of module%>
                                                      </tr>
                                                      <tr> 
                                                        <td width="45" class="<%=cssString%>" height="20"> 
                                                          <div align="center"><%=(cxx.getAdminPercent()==0) ? "" : JSPFormater.formatNumber(cxx.getAdminPercent(), "###")%></div>
                                                        </td>
                                                        <td width="45" class="<%=cssString%>" height="20"> 
                                                          <div align="center"><%=(cxx.getLogisticPercent()==0) ? "" : JSPFormater.formatNumber(cxx.getLogisticPercent(), "###")%></div>
                                                        </td>
                                                        <%if(submodules!=null && submodules.size()>0){
													for(int ix=0; ix<submodules.size(); ix++){
														Module mx = (Module)submodules.get(ix);
														
														where = "module_id="+mx.getOID()+" and coa_activity_budget_id="+cxx.getOID();
														vx = DbCoaActivityBudgetDetail.list(0,0, where, "");
														CoaActivityBudgetDetail cxxd = new CoaActivityBudgetDetail();
														if(vx!=null && vx.size()>0){
															cxxd = (CoaActivityBudgetDetail)vx.get(0);
														}
													%>
                                                        <td width="45" class="<%=cssString%>" height="20"> 
                                                          <div align="center"><%=(cxxd.getPercent()==0) ? "" : JSPFormater.formatNumber(cxxd.getPercent(), "###")%> </div>
                                                        </td>
                                                        <%}}//end of module%>
                                                      </tr>
                                                    </table>
                                                  </div>
                                                </td-->
                                              </tr>
                                              <%}}//end of for all%>
                                            </table>
                                          </td>
                                        </tr>
                                        <tr> 
                                          <td> 
                                            <%if(isOpen){%>
                                            <table width="99%" border="0" cellspacing="0" cellpadding="0">
                                              <tr> 
                                                <td width="11%">&nbsp;</td>
                                                <td width="89%">&nbsp;</td>
                                              </tr>
                                              <tr> 
                                                <td width="11%"><%if(privUpdate){%><a href="javascript:cmdAdd()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new2111','','../images/new2.gif',1)"><img src="../images/new.gif" name="new2111" border="0" width="71" height="22"></a><%}%></td>
                                                <td width="89%">&nbsp;</td>
                                              </tr>
                                            </table>
                                            <%}%>
                                          </td>
                                        </tr>
                                        <tr> 
                                          <td>&nbsp;</td>
                                        </tr>
                                      </table>
                                    </td>
                                  </tr>
                                  <tr> 
                                    <td>&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td>&nbsp;</td>
                                  </tr>
                                </table>
                                
                              </td>
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
