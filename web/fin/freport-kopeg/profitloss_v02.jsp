<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%//@ page import = "com.project.fms.journal.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "com.project.fms.master.*" %>
<%@ page import = "com.project.fms.session.*" %>
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
////boolean freportPriv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MENU_FINANCEREPROT, AppMenu.M2_MENU_FINANCEREPROT);
%>
<%!
	public String switchLevel(int level){
		String str = "";
		switch(level)
		{
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
		return str;
	}

	public String switchLevel1(int level){
		String str = "";
		switch(level)
		{
			case 1 : 											
				break;
			case 2 : 
				str = "       ";
				break;
			case 3 :
				str = "              ";
				break;
			case 4 :
				str = "                     ";
				break;
			case 5 :
				str = "                            ";
				break;				
		}									
		return str;
	}
	public String strDisplay(double amount, String coaStatus){
		String displayStr = "";
		if(amount<0)
			displayStr = "("+JSPFormater.formatNumber(amount*-1,"#,###.##")+")";
		else if(amount>0)										
			displayStr = JSPFormater.formatNumber(amount,"#,###.##");
		else if(amount==0)
			displayStr = "";
		if(coaStatus.equals("HEADER"))
			displayStr = "<b>"+displayStr+"</b>";
		return displayStr;
	}

%>
<%
	
	//pnlType = 0, biaya | pnlType = 1, pendapatan
	int pnlType = JSPRequestValue.requestInt(request, "pnl_type");

	if(session.getValue("PROFIT")!=null){
		session.removeValue("PROFIT");
	}
	String grpType = JSPRequestValue.requestString(request, "groupType");
	int iJSPCommand = JSPRequestValue.requestCommand(request);
	int start = JSPRequestValue.requestInt(request, "start");
	int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
	long oidCoa = JSPRequestValue.requestLong(request, "hidden_coa_id");
	String accGroup = JSPRequestValue.requestString(request, "acc_group");
	int valShowList = JSPRequestValue.requestInt(request, "showlist");	
	
	if(iJSPCommand==JSPCommand.NONE){
		valShowList = 2;
	}
	
	if(valShowList==0){valShowList=1;}
	int valShowLevel = JSPRequestValue.requestInt(request, "showlevel");	
	String strShowLevel = JSPRequestValue.requestString(request, "showlevel");	
	//out.println(strShowLevel);
	if(strShowLevel.equals("")){valShowLevel=-1;};
	
	if(valShowLevel==0)
		response.sendRedirect("profitloss0.jsp?menu_idx=4");
	else if(valShowLevel==1)
		response.sendRedirect("profitloss1.jsp?menu_idx=4");
	else if(valShowLevel==2)
		response.sendRedirect("profitloss2.jsp?menu_idx=4");
	else if(valShowLevel==3)
		response.sendRedirect("profitloss3.jsp?menu_idx=4");				

	/*variable declaration*/
	int recordToGet = 10;
	int iErrCode = JSPMessage.NONE;
	String whereClause = "";
	String orderClause = "code";
	
	Vector listCoa = new Vector(1,1);
	
	int vectSize = DbCoa.getCount(whereClause);
	recordToGet = vectSize;

	Coa coa = new Coa();

	/* get record to display */
	listCoa = DbCoa.list(start,recordToGet, whereClause , orderClause);

	String	strTotal = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
	String	strTotal1 = "       ";
	String cssString = "tablecell1";
	String displayStr = "";														
	double coaSummary1 = 0;
	double coaSummary2 = 0;
	double coaSummary3 = 0;
	double coaSummary4 = 0;
	double coaSummary5 = 0;			
	double coaSummary6 = 0;
	Vector listReport = new Vector();
	SesReportBs sesReport = new SesReportBs();
	
	Company company	= new Company();
	company = DbCompany.getCompany();
	//out.println(company.getDepartmentLevel());
	
	//budget
	double totalBudget = 0;
	
	double bgtSumRevenue = 0;
	double bgtSumCogs = 0;
	double bgtSumExpense = 0;
	double bgtSumOthExpense = 0;
	double bgtSumOthRevenue = 0;
	
	
	double sumRevenueMth = 0;
	double sumCogsMth = 0;
	double sumExpenseMth = 0;
	double sumOthExpenseMth = 0;
	double sumOthRevenueMth = 0;
	
	double totalAmount = 0;
	double totalMthAmount = 0;
	String displayStrBudget = "";
	String displayStrMth = "";

%>
<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
<head>
<!-- #BeginEditable "javascript" --> 
<title><%=systemTitle%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<link href="../css/default.css" rel="stylesheet" type="text/css" />
<link href="../css/css.css" rel="stylesheet" type="text/css" />
<script language="JavaScript">
<%if(!freportPriv){%>
	window.location="<%=approot%>/nopriv.jsp";
<%}%>
function cmdChangeList(){
	document.frmcoa.command.value="<%=JSPCommand.SUBMIT%>";
	document.frmcoa.action="profitloss_v01.jsp";
	document.frmcoa.submit();
}

function cmdPrintJournal(){	 
	window.open("<%=printroot%>.report.RptProfitLossPDF?oid=<%=appSessUser.getLoginId()%>");
}

function cmdPrintJournalXLS(){	 
	window.open("<%=printroot%>.report.RptProfitLossXLS?oid=<%=appSessUser.getLoginId()%>&pnl_type=<%=pnlType%>");
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
<body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','../images/print2.gif','../images/printxls2.gif')">
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
					  String navigator = "<font class=\"lvl1\">Financial Report</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">Laba Rugi Kelompok "+((pnlType==0) ? "Biaya" : "Pendapatan")+"</span></font>";
					  %>
					  <%@ include file="../main/navigator.jsp"%>
					  <!-- #EndEditable --></td>
                    </tr>
                    <!--tr> 
                      <td><img src="<%=approot%>/images/title-sp.gif" width="584" height="1"></td> 
                    </tr-->
                    <tr> 
                      <td><!-- #BeginEditable "content" --> 
                        <form name="frmcoa" method ="post" action="">
                          <input type="hidden" name="command" value="<%=iJSPCommand%>">
                          <input type="hidden" name="vectSize" value="<%=vectSize%>">
                          <input type="hidden" name="start" value="<%=start%>">
                          <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                          <input type="hidden" name="hidden_coa_id" value="<%=oidCoa%>">
                          <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
						  <input type="hidden" name="pnl_type" value="<%=pnlType%>">
						  
                          <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr align="left" valign="top"> 
                              <td height="8"  colspan="3" class="container"> 
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                  <tr align="left" valign="top"> 
                                    <td height="8" valign="middle" colspan="3"></td>
                                  </tr>             
								  <tr align="left" valign="top"> 
								  	<td height="8" valign="middle" colspan="3">
										<table width="230" border="0" cellspacing="0" cellpadding="0">
		                                  <tr align="left" valign="middle">
										    <td width="50">Show List </td>
											<td width="180" colspan="0"> 
											  <select name="showlist" onChange="javascript:cmdChangeList()">
												<option value="1" <%if(valShowList==1){%>selected<%}%>>Hide Acc. Without Transaction</option>
												<option value="2" <%if(valShowList==2){%>selected<%}%>>All</option>
											  </select>
											</td>                                                              
										  </tr>
										</table>
									</td>
								  </tr>									
								  <tr align="left" valign="top"> 
                                    <td height="10" colspan="3"></td>
                                  </tr>                          
								  <tr align="left" valign="top"> 
                                    <td height="20" valign="middle" align="center" colspan="3"><span class="level1"><font size="+1"><b>IKHTISAR 
                                      LABA/RUGI</b></font></span></td>
                                  </tr>                          
								  <%
								  	Periode periode = DbPeriode.getOpenPeriod();
									String openPeriod = JSPFormater.formatDate(periode.getStartDate(), "MMMM yyyy");//+ " - " + JSPFormater.formatDate(periode.getEndDate(), "dd MMM yyyy");        
									
									Date dtx = new Date();
									int yearx = dtx.getYear()+1900;
									
									//out.println("yearx : "+yearx);
									
								  %>        
								  <tr align="left" valign="top"> 
                                    <td height="20" valign="middle" align="center" colspan="3"><span class="level1"><b><font size="3">BULAN 
                                      <%=openPeriod.toUpperCase()%></font></b></span></td>
                                  </tr>         
								                           
								  <tr align="left" valign="top"> 
                                    <td height="10" valign="middle" colspan="3"></td>
                                  </tr>                                  
                                  <tr align="left" valign="top"> 
                                    <td height="22" valign="middle" colspan="3" class="page"> 
                                      <table width="100%" border="0" cellpadding="1" height="20" cellspacing="1">
                                        <tr> 
                                          <td width="56%" class="tablehdr" height="22">&nbsp;</td>
                                          <td class="tablehdr" height="22" width="16%">TARGET</td>
                                          <td colspan="2" class="tablehdr" height="22">REALISASI</td>
                                        </tr>
                                        <tr> 
                                          <td width="56%" class="tablehdr" height="22"> 
                                            <div align="center"><b><font color="#FFFFFF">Description</font></b></div>
                                          </td>
                                          <td class="tablehdr" height="22" width="16%">BLN 
                                            INI </td>
                                          <td width="14%" class="tablehdr" height="22">BLN 
                                            INI </td>
                                          <td width="14%" class="tablehdr" height="22">SD 
                                            BLN INI</td>
                                        </tr>
                                        <!--level ACC_GROUP_REVENUE-->
                                        <%
									//pnl = 1 => hanya pendapatan
									if(true){//pnlType==1){	
									
										if(DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_REVENUE,"CD")!=0 || valShowList!=1)
										{	//add Group Header
											sesReport = new SesReportBs();										
											sesReport.setType("Group Level");
											sesReport.setDescription(I_Project.ACC_GROUP_REVENUE);
											sesReport.setFont(1);												
											listReport.add(sesReport);
										%>
                                        <tr> 
                                          <td width="56%" class="tablecell"><b><%=I_Project.ACC_GROUP_REVENUE%></b></td>
                                          <td width="16%" class="tablecell" nowrap></td>
                                          <td width="14%" class="tablecell" nowrap></td>
                                          <td width="14%" class="tablecell" nowrap></td>
                                        </tr>
                                        <% 
										
										} 
										
										if(listCoa!=null && listCoa.size()>0)
										{
											coaSummary1 = 0;
											String str = "";
											String str1 = "";
											displayStrBudget = "";
																		
											for(int i=0; i<listCoa.size(); i++)
											{
												coa = (Coa)listCoa.get(i);
												
												if (coa.getAccountGroup().equals(I_Project.ACC_GROUP_REVENUE))
												{
													double budget = (DbCoaBudget.getBudgetRecursif(coa, yearx))/12;								
													
													//out.println("budget : "+budget);
													
													displayStrBudget = (budget==0) ? "" : JSPFormater.formatNumber(budget, "#,###.##");
												
													str = switchLevel(coa.getLevel());
													str1 = switchLevel1(coa.getLevel());
													
													double amount = DbCoa.getCoaBalanceCDRecursif(coa);
													double amountMth = DbCoa.getCoaBalanceRecursif(coa,periode,"CD");
													
													displayStr = strDisplay(amount, coa.getStatus());
													displayStrMth = strDisplay(amountMth, coa.getStatus());
													
													if(!coa.getStatus().equals("HEADER")){
														totalBudget = totalBudget + budget;
														bgtSumRevenue = bgtSumRevenue + budget;
														totalMthAmount = totalMthAmount + amountMth;
														sumRevenueMth = sumRevenueMth + amountMth;
														totalAmount = totalAmount + amount;
														coaSummary1 = coaSummary1 + amount;
													}
													
													if (valShowList==1){
													
														if (coa.getLevel()==1)//(coa.getStatus().equals("HEADER") && amount!=0) || ((!coa.getStatus().equals("HEADER")) && (amount!=0 || amountMth!=0 || budget!=0)))
														{	//add detail
															sesReport = new SesReportBs();
															sesReport.setType(coa.getStatus());
															sesReport.setDescription(strTotal1+str1+coa.getCode()+" - "+coa.getName());
															sesReport.setAmount(amount);
															sesReport.setStrAmount(""+amount);
															sesReport.setAmountMth(amountMth);
															sesReport.setStrAmountMth(""+amountMth);
															sesReport.setAmountBudget(budget);
															sesReport.setStrAmountBudget(""+budget);
															sesReport.setFont(coa.getStatus().equals("HEADER") ? 1 : 0);											
															listReport.add(sesReport);
											  %>
                                        <tr> 
                                          <td width="56%" class="<%=cssString%>" nowrap> 
                                            <%if(coa.getStatus().equals("HEADER")){ %>
                                            <b> 
                                            <%}%>
                                            <%=strTotal+str+coa.getCode()+" - "+coa.getName()%> 
                                            <%if(coa.getStatus().equals("HEADER")){ %>
                                            </b> 
                                            <%}%>
                                          </td>
                                          <td width="16%" class="<%=cssString%>" nowrap> 
                                             
                                              <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                                <tr> 
                                                  <td width="7%"></td>
                                                  <td width="88%" class="<%=cssString%>"> 
                                                    <div align="right">													
													<%if(coa.getStatus().equals("HEADER")){ %>
													<b> 
													<%}%>
													<%=displayStrBudget%>
													<%if(coa.getStatus().equals("HEADER")){ %>
													</b> 
													<%}%>
													</div>
                                                  </td>
                                                  <td width="5%"></td>
                                                </tr>
                                              </table>
                                           
                                          </td>
                                          <td width="14%" class="<%=cssString%>" nowrap> 
                                            <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                              <tr> 
                                                <td width="7%"></td>
                                                <td width="88%" class="<%=cssString%>"> 
                                                  <div align="right"> 
                                                    <%if(coa.getStatus().equals("HEADER")){ %>
                                                    <b> 
                                                    <%}%>
                                                    <%=displayStrMth%> 
                                                    <%if(coa.getStatus().equals("HEADER")){ %>
                                                    </b> 
                                                    <%}%>
                                                  </div>
                                                </td>
                                                <td width="5%"></td>
                                              </tr>
                                            </table>
                                          </td>
                                          <td width="14%" class="<%=cssString%>" nowrap> 
                                            <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                              <tr> 
                                                <td width="7%"></td>
                                                <td width="88%" class="<%=cssString%>"> 
                                                  <div align="right"><%=displayStr%></div>
                                                </td>
                                                <td width="5%"></td>
                                              </tr>
                                            </table>
                                          </td>
                                        </tr>
                                        <%				}
										}else //if valshow list 1
										{	
											if (coa.getLevel()==1)//true)//(coa.getStatus().equals("HEADER")) || ((!coa.getStatus().equals("HEADER")) && amount!=0))
											{	//add detail
												sesReport = new SesReportBs();
												sesReport.setType(coa.getStatus());
												sesReport.setDescription(strTotal1+str1+coa.getCode()+" - "+coa.getName());
												sesReport.setAmount(amount);
												sesReport.setStrAmount(""+amount);
												sesReport.setAmountMth(amountMth);
												sesReport.setStrAmountMth(""+amountMth);
												sesReport.setAmountBudget(budget);
												sesReport.setStrAmountBudget(""+budget);
												sesReport.setFont(coa.getStatus().equals("HEADER") ? 1 : 0);											
												listReport.add(sesReport);
								  %>
                                        <tr> 
                                          <td width="56%" class="<%=cssString%>" nowrap> 
                                            <%if(coa.getStatus().equals("HEADER")){ %>
                                            <b> 
                                            <%}%>
                                            <%=strTotal+str+coa.getCode()+" - "+coa.getName()%> 
                                            <%if(coa.getStatus().equals("HEADER")){ %>
                                            </b> 
                                            <%}%>
                                          </td>
                                          <td width="16%" class="<%=cssString%>" nowrap> 
                                            <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                              <tr> 
                                                <td width="7%"></td>
                                                <td width="88%" class="<%=cssString%>"> 
                                                  <div align="right"> 
                                                    <%if(coa.getStatus().equals("HEADER")){ %>
                                                    <b> 
                                                    <%}%>
                                                    <%=displayStrBudget%> 
                                                    <%if(coa.getStatus().equals("HEADER")){ %>
                                                    </b> 
                                                    <%}%>
                                                  </div>
                                                </td>
                                                <td width="5%"></td>
                                              </tr>
                                            </table>
                                          </td>
                                          <td width="14%" class="<%=cssString%>" nowrap> 
                                            <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                              <tr> 
                                                <td width="7%"></td>
                                                <td width="88%" class="<%=cssString%>"> 
                                                  <div align="right"> 
                                                    <%if(coa.getStatus().equals("HEADER")){ %>
                                                    <b> 
                                                    <%}%>
                                                    <%=displayStrMth%> 
                                                    <%if(coa.getStatus().equals("HEADER")){ %>
                                                    </b> 
                                                    <%}%>
                                                  </div>
                                                </td>
                                                <td width="5%"></td>
                                              </tr>
                                            </table>
                                          </td>
                                          <td width="14%" class="<%=cssString%>" nowrap> 
                                            <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                              <tr> 
                                                <td width="5%"></td>
                                                <td width="90%" class="<%=cssString%>"> 
                                                  <div align="right"><%=displayStr%></div>
                                                </td>
                                                <td width="5%"></td>
                                              </tr>
                                            </table>
                                          </td>
                                        </tr>
                                        <%
													}//if true
												}//else
											}//if revenue
											
										}//for
											
										if (coaSummary1<0)							
											displayStr = "("+JSPFormater.formatNumber(coaSummary1*-1,"#,###.##")+")";
										else if (coaSummary1>0)
											displayStr = JSPFormater.formatNumber(coaSummary1,"#,###.##");
										else if (coaSummary1==0)
											displayStr = "";
										
										
										if (bgtSumRevenue<0)							
											displayStrBudget = "("+JSPFormater.formatNumber(bgtSumRevenue*-1,"#,###.##")+")";
										else if (bgtSumRevenue>0)
											displayStrBudget = JSPFormater.formatNumber(bgtSumRevenue,"#,###.##");
										else if (bgtSumRevenue==0)
											displayStrBudget = "";
											
											
										if (sumRevenueMth<0)							
											displayStrMth = "("+JSPFormater.formatNumber(sumRevenueMth*-1,"#,###.##")+")";
										else if (sumRevenueMth>0)
											displayStrMth = JSPFormater.formatNumber(sumRevenueMth,"#,###.##");
										else if (sumRevenueMth==0)
											displayStrMth = "";	
												
										
										
										if(DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_REVENUE,"CD")!=0 || valShowList!=1)
										{	//add Group Footer
											sesReport = new SesReportBs();										
											sesReport.setType("Footer Group Level");
											sesReport.setDescription("Total "+I_Project.ACC_GROUP_REVENUE);
											sesReport.setAmount(coaSummary1);
											sesReport.setStrAmount(""+coaSummary1);
											sesReport.setAmountMth(sumRevenueMth);
											sesReport.setStrAmountMth(""+sumRevenueMth);
											sesReport.setAmountBudget(bgtSumRevenue);
											sesReport.setStrAmountBudget(""+bgtSumRevenue);
											sesReport.setFont(1);												
											listReport.add(sesReport);								
						%>
                                        <tr> 
                                          <td width="56%" class="tablecell2"><span class="level2"><b><%="Total "+I_Project.ACC_GROUP_REVENUE%></b></span></td>
                                          <td width="16%" class="tablecell2" align="right" nowrap> 
                                            <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                              <tr> 
                                                <td width="7%"></td>
                                                <td width="88%" class="level2"> 
                                                  <div align="right"><b> <%=displayStrBudget%> </b> </div>
                                                </td>
                                                <td width="5%"></td>
                                              </tr>
                                            </table>
                                          </td>
                                          <td width="14%" class="tablecell2" align="right" nowrap> 
                                            
                                              <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                                <tr> 
                                                  <td width="7%"></td>
                                                  <td width="88%" class="level2"> 
                                                    <div align="right"><b> <%=displayStrMth%> </b> </div>
                                                  </td>
                                                  <td width="5%"></td>
                                                </tr>
                                              </table>
                                            
                                          </td>
                                          <td width="14%" class="tablecell2" align="right" nowrap> 
                                            <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                              <tr> 
                                                <td width="5%"></td>
                                                <td width="90%" class="level2"> 
                                                  <div align="right"><b><%=displayStr%></b></div>
                                                </td>
                                                <td width="5%"></td>
                                              </tr>
                                            </table>
                                          </td>
                                        </tr>
                                        <%
											}//if dbcoa	
											
										}//if coa != null
											
										if(DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_REVENUE,"CD")!=0 || valShowList!=1)
										{	//add Space
											sesReport = new SesReportBs();										
											sesReport.setType("Space");
											sesReport.setDescription("");
											listReport.add(sesReport);																				
										%>
                                        <tr> 
                                          <td width="56%" class="tablecell1" height="15"></td>
                                          <td width="16%" class="tablecell1" nowrap> 
                                            <div align="right"></div>
                                          </td>
                                          <td width="14%" class="tablecell1" nowrap> 
                                            <div align="right"></div>
                                          </td>
                                          <td width="14%" class="tablecell1" nowrap> 
                                            <div align="left"></div>
                                          </td>
                                        </tr>
                                        <%	}
										
										}//end if pnlTyp = 1
										
										%>
                                        <!--level 2-->
                                        <!--level ACC_GROUP_EXPENSE-->
                                        <%
										
										//jika pnl type => biaya
										if(true){//pnlType == 0){
											
											if(DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_COST_OF_SALES,"DC")!=0 || valShowList!=1)
											{	//add Group Header
												sesReport = new SesReportBs();										
												sesReport.setType("Group Level");
												sesReport.setDescription(I_Project.ACC_GROUP_COST_OF_SALES);
												sesReport.setFont(1);												
												listReport.add(sesReport);
										%>
                                        <tr> 
                                          <td width="56%" class="tablecell"><b><%=I_Project.ACC_GROUP_COST_OF_SALES%></b></td>
                                          <td width="16%" class="tablecell" nowrap> 
                                            <div align="right"></div>
                                          </td>
                                          <td width="14%" class="tablecell" nowrap> 
                                            <div align="right"></div>
                                          </td>
                                          <td width="14%" class="tablecell" nowrap> 
                                            <div align="left"></div>
                                          </td>
                                        </tr>
                                        <%	}	%>
                                        <%
										if(listCoa!=null && listCoa.size()>0)
										{
											coaSummary2 = 0;
											String str = "";
											String str1 = "";
											displayStrBudget = "";
																		
											for(int i=0; i<listCoa.size(); i++)
											{
												coa = (Coa)listCoa.get(i);
												
												if (coa.getAccountGroup().equals(I_Project.ACC_GROUP_COST_OF_SALES))
												{
												
													double budget = (DbCoaBudget.getBudgetRecursif(coa, yearx))/12;								
													displayStrBudget = (budget==0) ? "" : JSPFormater.formatNumber(budget, "#,###.##");
													
													str = switchLevel(coa.getLevel());
													str1 = switchLevel1(coa.getLevel());
													double amount = DbCoa.getCoaBalanceRecursif(coa);
													double amountMth = DbCoa.getCoaBalanceRecursif(coa, periode,"DC");
													displayStr = strDisplay(amount, coa.getStatus());
													displayStrMth = strDisplay(amountMth, coa.getStatus());
													
													
													if(!coa.getStatus().equals("HEADER")){
														totalBudget = totalBudget - budget;
														bgtSumCogs = bgtSumCogs + budget;
														totalMthAmount = totalMthAmount - amountMth;
														sumCogsMth = sumCogsMth + amountMth;
														totalAmount = totalAmount - amount;
														coaSummary2 = coaSummary2 + amount;
													}
																					
													if (valShowList==1)
													{
														if (coa.getLevel()==1)//(coa.getStatus().equals("HEADER") && DbCoa.getCoaBalanceByHeader(coa.getOID(),"DC")!=0) || ((!coa.getStatus().equals("HEADER")) && (amount!=0 || amountMth!=0 || budget!=0)))
														//if ((coa.getStatus().equals("HEADER") && amount!=0) || ((!coa.getStatus().equals("HEADER")) && (amount!=0 || amountMth!=0 || budget!=0)))														
														{	//add detail
															sesReport = new SesReportBs();
															sesReport.setType(coa.getStatus());
															sesReport.setDescription(strTotal1+str1+coa.getCode()+" - "+coa.getName());
															sesReport.setAmount(amount);
															sesReport.setStrAmount(""+amount);
															sesReport.setAmountMth(amountMth);
															sesReport.setStrAmountMth(""+amountMth);
															sesReport.setAmountBudget(budget);
															sesReport.setStrAmountBudget(""+budget);
															sesReport.setFont(coa.getStatus().equals("HEADER") ? 1 : 0);											
															listReport.add(sesReport);
											  %>
                                        <tr> 
                                          <td width="56%" class="<%=cssString%>" nowrap> 
                                            <%if(coa.getStatus().equals("HEADER")){ %>
                                            <b> 
                                            <%}%>
                                            <%=strTotal+str+coa.getCode()+" - "+coa.getName()%> 
                                            <%if(coa.getStatus().equals("HEADER")){ %>
                                            </b> 
                                            <%}%>
                                          </td>
                                          <td width="16%" class="<%=cssString%>" nowrap> 
                                            <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                                <tr> 
                                                  <td width="7%"></td>
                                                  <td width="88%" class="<%=cssString%>"> 
                                                    <div align="right">
													<%if(coa.getStatus().equals("HEADER")){ %>
													<b> 
													<%}%>
													<%=displayStrBudget%>
													<%if(coa.getStatus().equals("HEADER")){ %>
													</b> 
													<%}%>
													</div>
                                                  </td>
                                                  <td width="5%"></td>
                                                </tr>
                                              </table>
                                          </td>
                                          <td width="14%" class="<%=cssString%>" nowrap> 
                                            <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                              <tr> 
                                                <td width="7%"></td>
                                                <td width="88%" class="<%=cssString%>"> 
                                                  <div align="right"> 
                                                    <%if(coa.getStatus().equals("HEADER")){ %>
                                                    <b> 
                                                    <%}%>
                                                    <%=displayStrMth%> 
                                                    <%if(coa.getStatus().equals("HEADER")){ %>
                                                    </b> 
                                                    <%}%>
                                                  </div>
                                                </td>
                                                <td width="5%"></td>
                                              </tr>
                                            </table>
                                          </td>
                                          <td width="14%" class="<%=cssString%>" nowrap> 
                                            <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                              <tr> 
                                                <td width="5%"></td>
                                                <td width="90%" class="<%=cssString%>"> 
                                                  <div align="right"><%=displayStr%></div>
                                                </td>
                                                <td width="5%"></td>
                                              </tr>
                                            </table>
                                          </td>
                                        </tr>
                                        <%				}
									}else
									{	
										if (coa.getLevel()==1)//true)//((coa.getStatus().equals("HEADER")) || ((!coa.getStatus().equals("HEADER")) && amount!=0))
										{	//add detail
											sesReport = new SesReportBs();
											sesReport.setType(coa.getStatus());
											sesReport.setDescription(strTotal1+str1+coa.getCode()+" - "+coa.getName());
											sesReport.setAmount(amount);
											sesReport.setStrAmount(""+amount);
											sesReport.setAmountMth(amountMth);
											sesReport.setStrAmountMth(""+amountMth);
											sesReport.setAmountBudget(budget);
											sesReport.setStrAmountBudget(""+budget);
											sesReport.setFont(coa.getStatus().equals("HEADER") ? 1 : 0);											
											listReport.add(sesReport);
							  %>
                                        <tr> 
                                          <td width="56%" class="<%=cssString%>" nowrap> 
                                            <%if(coa.getStatus().equals("HEADER")){ %>
                                            <b> 
                                            <%}%>
                                            <%=strTotal+str+coa.getCode()+" - "+coa.getName()%> 
                                            <%if(coa.getStatus().equals("HEADER")){ %>
                                            </b> 
                                            <%}%>
                                          </td>
                                          <td width="16%" class="<%=cssString%>" nowrap> 
                                            <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                                <tr> 
                                                  <td width="7%"></td>
                                                  <td width="88%" class="<%=cssString%>"> 
                                                    <div align="right">
													<%if(coa.getStatus().equals("HEADER")){ %>
													<b> 
													<%}%>
													<%=displayStrBudget%>
													<%if(coa.getStatus().equals("HEADER")){ %>
													</b> 
													<%}%>
													</div>
                                                  </td>
                                                  <td width="5%"></td>
                                                </tr>
                                              </table>
                                          </td>
                                          <td width="14%" class="<%=cssString%>" nowrap> 
                                           <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                              <tr> 
                                                <td width="7%"></td>
                                                <td width="88%" class="<%=cssString%>"> 
                                                  <div align="right"> 
                                                    <%if(coa.getStatus().equals("HEADER")){ %>
                                                    <b> 
                                                    <%}%>
                                                    <%=displayStrMth%> 
                                                    <%if(coa.getStatus().equals("HEADER")){ %>
                                                    </b> 
                                                    <%}%>
                                                  </div>
                                                </td>
                                                <td width="5%"></td>
                                              </tr>
                                            </table>
                                          </td>
                                          <td width="14%" class="<%=cssString%>" nowrap> 
                                            <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                              <tr> 
                                                <td width="5%"></td>
                                                <td width="90%" class="<%=cssString%>"> 
                                                  <div align="right"><%=displayStr%></div>
                                                </td>
                                                <td width="5%"></td>
                                              </tr>
                                            </table>
                                          </td>
                                        </tr>
                                        <%
														}
													}
												}
													
												if (coaSummary2<0)							
													displayStr = "("+JSPFormater.formatNumber(coaSummary2*-1,"#,###.##")+")";
												else if (coaSummary2>0)
													displayStr = JSPFormater.formatNumber(coaSummary2,"#,###.##");
												else if (coaSummary2==0)
													displayStr = "";
												
												
												if (bgtSumCogs<0)							
													displayStrBudget = "("+JSPFormater.formatNumber(bgtSumCogs*-1,"#,###.##")+")";
												else if (bgtSumCogs>0)
													displayStrBudget = JSPFormater.formatNumber(bgtSumCogs,"#,###.##");
												else if (bgtSumCogs==0)
													displayStrBudget = "";
													
													
												if (sumCogsMth<0)							
													displayStrMth = "("+JSPFormater.formatNumber(sumCogsMth*-1,"#,###.##")+")";
												else if (sumCogsMth>0)
													displayStrMth = JSPFormater.formatNumber(sumCogsMth,"#,###.##");
												else if (sumCogsMth==0)
													displayStrMth = "";	
													
										}		
							
							
										//add footer level
											if(DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_COST_OF_SALES,"DC")!=0 || valShowList!=1)
											{	//add Group Footer
												sesReport = new SesReportBs();										
												sesReport.setType("Footer Group Level");
												sesReport.setDescription("Total "+I_Project.ACC_GROUP_COST_OF_SALES);
												sesReport.setAmount(coaSummary2);
												sesReport.setStrAmount(""+coaSummary2);
												sesReport.setAmountMth(sumCogsMth);
												sesReport.setStrAmountMth(""+sumCogsMth);
												sesReport.setAmountBudget(bgtSumCogs);
												sesReport.setStrAmountBudget(""+bgtSumCogs);
												sesReport.setFont(1);												
												listReport.add(sesReport);								
						%>
                                        <tr> 
                                          <td width="56%" class="tablecell2"><span class="level2"><b><%="Total "+I_Project.ACC_GROUP_COST_OF_SALES%></b></span></td>
                                          <td width="16%" class="tablecell2" align="right" nowrap> 
                                            <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                                <tr> 
                                                  <td width="7%"></td>
                                                  <td width="88%" class="level2"> 
                                                    <div align="right"> 
                                                      <b> 
                                                      <%=displayStrBudget%> 
                                                      </b> 
                                                    </div>
                                                  </td>
                                                  <td width="5%"></td>
                                                </tr>
                                              </table>
                                          </td>
                                          <td width="14%" class="tablecell2" align="right" nowrap> 
                                            <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                                <tr> 
                                                  <td width="7%"></td>
                                                  <td width="88%" class="level2"> 
                                                    <div align="right"><b> <%=displayStrMth%> </b> </div>
                                                  </td>
                                                  <td width="5%"></td>
                                                </tr>
                                              </table>
                                          </td>
                                          <td width="14%" class="tablecell2" align="right" nowrap> 
                                            <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                              <tr> 
                                                <td width="5%"></td>
                                                <td width="90%" class="level2"> 
                                                  <div align="right"><b><%=displayStr%></b></div>
                                                </td>
                                                <td width="5%"></td>
                                              </tr>
                                            </table>
                                          </td>
                                        </tr>
                                        <%
											}	
						}
											if(DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_COST_OF_SALES,"DC")!=0 || valShowList!=1)
											{	//add Space
												sesReport = new SesReportBs();										
												sesReport.setType("Space");
												sesReport.setDescription("");
												listReport.add(sesReport);																				
					%>
                                        <tr> 
                                          <td width="56%" class="tablecell1" height="15"></td>
                                          <td width="16%" class="tablecell1" nowrap> 
                                            <div align="right"></div>
                                          </td>
                                          <td width="14%" class="tablecell1" nowrap> 
                                            <div align="right"></div>
                                          </td>
                                          <td width="14%" class="tablecell1" nowrap> 
                                            <div align="left"></div>
                                          </td>
                                        </tr>
                                        <%	}
										
										
										
											%>
                                        <!--level 3-->
                                        <!--level ACC_GROUP_EXPENSE-->
                                        <%	
											if(DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_EXPENSE,"DC")!=0 || valShowList!=1)
											{	//add Group Header
												sesReport = new SesReportBs();										
												sesReport.setType("Group Level");
												sesReport.setDescription(I_Project.ACC_GROUP_EXPENSE);
												sesReport.setFont(1);												
												listReport.add(sesReport);
										%>
                                        <tr> 
                                          <td width="56%" class="tablecell"><b><%=I_Project.ACC_GROUP_EXPENSE%></b></td>
                                          <td width="16%" class="tablecell" nowrap> 
                                            <div align="right"></div>
                                          </td>
                                          <td width="14%" class="tablecell" nowrap> 
                                            <div align="right"></div>
                                          </td>
                                          <td width="14%" class="tablecell" nowrap> 
                                            <div align="left"></div>
                                          </td>
                                        </tr>
                                        <%	}	%>
                                        <%
						if(listCoa!=null && listCoa.size()>0)
						{
							coaSummary3 = 0;
							String str = "";
							String str1 = "";
							displayStrBudget = "";
														
							for(int i=0; i<listCoa.size(); i++)
							{
								coa = (Coa)listCoa.get(i);
								
								if (coa.getAccountGroup().equals(I_Project.ACC_GROUP_EXPENSE))
								{
								
									double budget = (DbCoaBudget.getBudgetRecursif(coa, yearx))/12;								
									displayStrBudget = (budget==0) ? "" : JSPFormater.formatNumber(budget, "#,###.##");
								
									str = switchLevel(coa.getLevel());
									str1 = switchLevel1(coa.getLevel());
									double amount = DbCoa.getCoaBalanceRecursif(coa);
									double amountMth = DbCoa.getCoaBalanceRecursif(coa,periode,"DC");
									displayStr = strDisplay(amount, coa.getStatus());
									displayStrMth = strDisplay(amountMth, coa.getStatus());
									
									if(!coa.getStatus().equals("HEADER")){
										totalBudget = totalBudget - budget;
										bgtSumExpense = bgtSumExpense + budget;
										totalMthAmount = totalMthAmount - amountMth;
										sumExpenseMth = sumExpenseMth + amountMth;
										totalAmount = totalAmount - amount;
										coaSummary3 = coaSummary3 + amount;
									}
									
									if (valShowList==1)
									{
										//if ((coa.getStatus().equals("HEADER") && DbCoa.getCoaBalanceByHeader(coa.getOID(),"DC")!=0) || ((!coa.getStatus().equals("HEADER")) && amount!=0))
										if (coa.getLevel()==1)//(coa.getStatus().equals("HEADER") && DbCoa.getCoaBalanceByHeader(coa.getOID(),"DC")!=0) || ((!coa.getStatus().equals("HEADER")) && (amount!=0 || amountMth!=0 || budget!=0)))										
										{	//add detail
											sesReport = new SesReportBs();
											sesReport.setType(coa.getStatus());
											sesReport.setDescription(strTotal1+str1+coa.getCode()+" - "+coa.getName());
											sesReport.setAmount(amount);
											sesReport.setStrAmount(""+amount);
											sesReport.setAmountMth(amountMth);
											sesReport.setStrAmountMth(""+amountMth);
											sesReport.setAmountBudget(budget);
											sesReport.setStrAmountBudget(""+budget);
											sesReport.setFont(coa.getStatus().equals("HEADER") ? 1 : 0);											
											listReport.add(sesReport);
							  %>
                                        <tr> 
                                          <td width="56%" class="<%=cssString%>" nowrap> 
                                            <%if(coa.getStatus().equals("HEADER")){ %>
                                            <b> 
                                            <%}%>
                                            <%=strTotal+str+coa.getCode()+" - "+coa.getName()%> 
                                            <%if(coa.getStatus().equals("HEADER")){ %>
                                            </b> 
                                            <%}%>
                                          </td>
                                          <td width="16%" class="<%=cssString%>" nowrap> 
                                            <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                                <tr> 
                                                  <td width="7%"></td>
                                                  <td width="88%" class="<%=cssString%>"> 
                                                    <div align="right">
													<%if(coa.getStatus().equals("HEADER")){ %>
													<b> 
													<%}%>
													<%=displayStrBudget%>
													<%if(coa.getStatus().equals("HEADER")){ %>
													</b> 
													<%}%>
													</div>
                                                  </td>
                                                  <td width="5%"></td>
                                                </tr>
                                              </table>
                                          </td>
                                          <td width="14%" class="<%=cssString%>" nowrap> 
                                            <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                              <tr> 
                                                <td width="7%"></td>
                                                <td width="88%" class="<%=cssString%>"> 
                                                  <div align="right"> 
                                                    <%if(coa.getStatus().equals("HEADER")){ %>
                                                    <b> 
                                                    <%}%>
                                                    <%=displayStrMth%> 
                                                    <%if(coa.getStatus().equals("HEADER")){ %>
                                                    </b> 
                                                    <%}%>
                                                  </div>
                                                </td>
                                                <td width="5%"></td>
                                              </tr>
                                            </table>
                                          </td>
                                          <td width="14%" class="<%=cssString%>" nowrap> 
                                            <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                              <tr> 
                                                <td width="5%"></td>
                                                <td width="90%" class="<%=cssString%>"> 
                                                  <div align="right"><%=displayStr%></div>
                                                </td>
                                                <td width="5%"></td>
                                              </tr>
                                            </table>
                                          </td>
                                        </tr>
                                        <%				}
									}else
									{	
										if(coa.getLevel()==1)//true)// ((coa.getStatus().equals("HEADER")) || ((!coa.getStatus().equals("HEADER")) && amount!=0))
										{	//add detail
											sesReport = new SesReportBs();
											sesReport.setType(coa.getStatus());
											sesReport.setDescription(strTotal1+str1+coa.getCode()+" - "+coa.getName());
											sesReport.setAmount(amount);
											sesReport.setStrAmount(""+amount);
											sesReport.setAmountMth(amountMth);
											sesReport.setStrAmountMth(""+amountMth);
											sesReport.setAmountBudget(budget);
											sesReport.setStrAmountBudget(""+budget);
											sesReport.setFont(coa.getStatus().equals("HEADER") ? 1 : 0);											
											listReport.add(sesReport);
							  %>
                                        <tr> 
                                          <td width="56%" class="<%=cssString%>" nowrap> 
                                            <%if(coa.getStatus().equals("HEADER")){ %>
                                            <b> 
                                            <%}%>
                                            <%=strTotal+str+coa.getCode()+" - "+coa.getName()%> 
                                            <%if(coa.getStatus().equals("HEADER")){ %>
                                            </b> 
                                            <%}%>
                                          </td>
                                          <td width="16%" class="<%=cssString%>" nowrap> 
                                            <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                                <tr> 
                                                  <td width="7%"></td>
                                                  <td width="88%" class="<%=cssString%>"> 
                                                    <div align="right">
													<%if(coa.getStatus().equals("HEADER")){ %>
													<b> 
													<%}%>
													<%=displayStrBudget%>
													<%if(coa.getStatus().equals("HEADER")){ %>
													</b> 
													<%}%>
													</div>
                                                  </td>
                                                  <td width="5%"></td>
                                                </tr>
                                              </table>
                                          </td>
                                          <td width="14%" class="<%=cssString%>" nowrap> 
                                            <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                              <tr> 
                                                <td width="7%"></td>
                                                <td width="88%" class="<%=cssString%>"> 
                                                  <div align="right"> 
                                                    <%if(coa.getStatus().equals("HEADER")){ %>
                                                    <b> 
                                                    <%}%>
                                                    <%=displayStrMth%> 
                                                    <%if(coa.getStatus().equals("HEADER")){ %>
                                                    </b> 
                                                    <%}%>
                                                  </div>
                                                </td>
                                                <td width="5%"></td>
                                              </tr>
                                            </table>
                                          </td>
                                          <td width="14%" class="<%=cssString%>" nowrap> 
                                            <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                              <tr> 
                                                <td width="5%"></td>
                                                <td width="90%" class="<%=cssString%>"> 
                                                  <div align="right"><%=displayStr%></div>
                                                </td>
                                                <td width="5%"></td>
                                              </tr>
                                            </table>
                                          </td>
                                        </tr>
                                        <%					}
											}
										}
									
										if (coaSummary3<0)							
											displayStr = "("+JSPFormater.formatNumber(coaSummary3*-1,"#,###.##")+")";
										else if (coaSummary3>0)
											displayStr = JSPFormater.formatNumber(coaSummary3,"#,###.##");
										else if (coaSummary3==0)
											displayStr = "";
										
										if (bgtSumExpense<0)							
											displayStrBudget = "("+JSPFormater.formatNumber(bgtSumExpense*-1,"#,###.##")+")";
										else if (bgtSumExpense>0)
											displayStrBudget = JSPFormater.formatNumber(bgtSumExpense,"#,###.##");
										else if (bgtSumExpense==0)
											displayStrBudget = "";
											
										if (sumExpenseMth<0)							
											displayStrMth = "("+JSPFormater.formatNumber(sumExpenseMth*-1,"#,###.##")+")";
										else if (sumExpenseMth>0)
											displayStrMth = JSPFormater.formatNumber(sumExpenseMth,"#,###.##");
										else if (sumExpenseMth==0)
											displayStrMth = "";	
											
											
										}				
										//add footer level


										if(DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_EXPENSE,"DC")!=0 || valShowList!=1)
										{	//add Group Footer
											sesReport = new SesReportBs();										
											sesReport.setType("Footer Group Level");
											sesReport.setDescription("Total "+I_Project.ACC_GROUP_EXPENSE);
											sesReport.setAmount(coaSummary3);
											sesReport.setStrAmount(""+coaSummary3);
											sesReport.setAmountMth(sumExpenseMth);
											sesReport.setStrAmountMth(""+sumExpenseMth);
											sesReport.setAmountBudget(bgtSumExpense);
											sesReport.setStrAmountBudget(""+bgtSumExpense);
											sesReport.setFont(1);												
											listReport.add(sesReport);								
						%>
                                        <tr> 
                                          <td width="56%" class="tablecell2"><span class="level2"><b><%="Total "+I_Project.ACC_GROUP_EXPENSE%></b></span></td>
                                          <td width="16%" class="tablecell2" align="right" nowrap> 
                                            <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                              <tr> 
                                                <td width="7%"></td>
                                                <td width="88%" class="level2"> 
                                                  <div align="right"> 
                                                    <b> 
                                                    <%=displayStrBudget%> 
                                                    </b> 
                                                  </div>
                                                </td>
                                                <td width="5%"></td>
                                              </tr>
                                            </table>
                                          </td>
                                          <td width="14%" class="tablecell2" align="right" nowrap> 
                                            <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                              <tr> 
                                                <td width="7%"></td>
                                                <td width="88%" class="level2"> 
                                                  <div align="right"> 
                                                    <b> 
                                                    <%=displayStrMth%> 
                                                    </b> 
                                                  </div>
                                                </td>
                                                <td width="5%"></td>
                                              </tr>
                                            </table>
                                          </td>
                                          <td width="14%" class="tablecell2" align="right" nowrap> 
                                            <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                              <tr> 
                                                <td width="5%"></td>
                                                <td width="90%" class="level2"> 
                                                  <div align="right"><b><%=displayStr%></b></div>
                                                </td>
                                                <td width="5%"></td>
                                              </tr>
                                            </table>
                                          </td>
                                        </tr>
                                        <%
											}	
						}
											if(DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_EXPENSE,"DC")!=0 || valShowList!=1)
											{	//add Space
												sesReport = new SesReportBs();										
												sesReport.setType("Space");
												sesReport.setDescription("");
												listReport.add(sesReport);																				
					%>
                                        <tr> 
                                          <td width="56%" class="tablecell1" height="15"></td>
                                          <td width="16%" class="tablecell1" nowrap> 
                                            <div align="right"></div>
                                          </td>
                                          <td width="14%" class="tablecell1" nowrap> 
                                            <div align="right"></div>
                                          </td>
                                          <td width="14%" class="tablecell1" nowrap> 
                                            <div align="left"></div>
                                          </td>
                                        </tr>
                                        <%	}
										
										}//end if pnl type = 0
										//=======================  
										
											%>
                                        <!--level 4-->
                                        <!--level ACC_GROUP_OTHER_REVENUE-->
                                        <%
										
										//jika tampilkan pendapatan
										if(true){//pnlType==1){
											
											if(DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_OTHER_REVENUE,"CD")!=0 || valShowList!=1)
											{	//add Group Header
												sesReport = new SesReportBs();										
												sesReport.setType("Group Level");
												sesReport.setDescription(I_Project.ACC_GROUP_OTHER_REVENUE);
												sesReport.setFont(1);												
												listReport.add(sesReport);
										%>
                                        <tr> 
                                          <td width="56%" class="tablecell"><b><%=I_Project.ACC_GROUP_OTHER_REVENUE%></b></td>
                                          <td width="16%" class="tablecell" nowrap> 
                                            <div align="right"></div>
                                          </td>
                                          <td width="14%" class="tablecell" nowrap> 
                                            <div align="right"></div>
                                          </td>
                                          <td width="14%" class="tablecell" nowrap> 
                                            <div align="left"></div>
                                          </td>
                                        </tr>
                                        <% 	} %>
                                        <%
						if(listCoa!=null && listCoa.size()>0)
						{
							coaSummary4 = 0;
							String str = "";
							String str1 = "";
							displayStrBudget = "";
														
							for(int i=0; i<listCoa.size(); i++)
							{
								coa = (Coa)listCoa.get(i);
								
								if (coa.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_REVENUE))
								{
								
									double budget = (DbCoaBudget.getBudgetRecursif(coa, yearx))/12;								
									displayStrBudget = (budget==0) ? "" : JSPFormater.formatNumber(budget, "#,###.##");
								
									str = switchLevel(coa.getLevel());
									str1 = switchLevel1(coa.getLevel());
									double amount = DbCoa.getCoaBalanceCDRecursif(coa);
									double amountMth = DbCoa.getCoaBalanceRecursif(coa,periode,"CD");
									
									displayStr = strDisplay(amount, coa.getStatus());
									displayStrMth = strDisplay(amountMth, coa.getStatus());

									if(!coa.getStatus().equals("HEADER")){
										totalBudget = totalBudget + budget;
										bgtSumOthRevenue = bgtSumOthRevenue + budget;
										totalMthAmount = totalMthAmount + amountMth;
										sumOthRevenueMth = sumOthRevenueMth + amountMth;
										totalAmount = totalAmount + amount;
										coaSummary4 = coaSummary4 + amount;
									}


									if (valShowList==1)
									{
										if (coa.getLevel()==1)//(coa.getStatus().equals("HEADER") && DbCoa.getCoaBalanceByHeader(coa.getOID(),"CD")!=0) || ((!coa.getStatus().equals("HEADER")) && (amount!=0 || amountMth!=0 || budget!=0)))
										{	//add detail
											sesReport = new SesReportBs();
											sesReport.setType(coa.getStatus());
											sesReport.setDescription(strTotal1+str1+coa.getCode()+" - "+coa.getName());
											sesReport.setAmount(amount);
											sesReport.setStrAmount(""+amount);
											sesReport.setAmountMth(amountMth);
											sesReport.setStrAmountMth(""+amountMth);
											sesReport.setAmountBudget(budget);
											sesReport.setStrAmountBudget(""+budget);
											sesReport.setFont(coa.getStatus().equals("HEADER") ? 1 : 0);											
											listReport.add(sesReport);
							  %>
                                        <tr> 
                                          <td width="56%" class="<%=cssString%>" nowrap> 
                                            <%if(coa.getStatus().equals("HEADER")){ %>
                                            <b> 
                                            <%}%>
                                            <%=strTotal+str+coa.getCode()+" - "+coa.getName()%> 
                                            <%if(coa.getStatus().equals("HEADER")){ %>
                                            </b> 
                                            <%}%>
                                          </td>
                                          <td width="16%" class="<%=cssString%>" nowrap> 
                                           <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                                <tr> 
                                                  <td width="7%"></td>
                                                  <td width="88%" class="<%=cssString%>"> 
                                                    <div align="right">
													<%if(coa.getStatus().equals("HEADER")){ %>
													<b> 
													<%}%>
													<%=displayStrBudget%>
													<%if(coa.getStatus().equals("HEADER")){ %>
													</b> 
													<%}%>
													</div>
                                                  </td>
                                                  <td width="5%"></td>
                                                </tr>
                                              </table>
                                          </td>
                                          <td width="14%" class="<%=cssString%>" nowrap> 
                                            <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                              <tr> 
                                                <td width="7%"></td>
                                                <td width="88%" class="<%=cssString%>"> 
                                                  <div align="right"> 
                                                    <%if(coa.getStatus().equals("HEADER")){ %>
                                                    <b> 
                                                    <%}%>
                                                    <%=displayStrMth%> 
                                                    <%if(coa.getStatus().equals("HEADER")){ %>
                                                    </b> 
                                                    <%}%>
                                                  </div>
                                                </td>
                                                <td width="5%"></td>
                                              </tr>
                                            </table>
                                          </td>
                                          <td width="14%" class="<%=cssString%>" nowrap> 
                                            <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                              <tr> 
                                                <td width="5%"></td>
                                                <td width="90%" class="<%=cssString%>"> 
                                                  <div align="right"><%=displayStr%></div>
                                                </td>
                                                <td width="5%"></td>
                                              </tr>
                                            </table>
                                          </td>
                                        </tr>
                                        <%				}
									}else
									{	
										if(coa.getLevel()==1)//true)// ((coa.getStatus().equals("HEADER")) || ((!coa.getStatus().equals("HEADER")) && amount!=0))
										{	//add detail
											sesReport = new SesReportBs();
											sesReport.setType(coa.getStatus());
											sesReport.setDescription(strTotal1+str1+coa.getCode()+" - "+coa.getName());
											sesReport.setAmount(amount);
											sesReport.setStrAmount(""+amount);
											sesReport.setAmountMth(amountMth);
											sesReport.setStrAmountMth(""+amountMth);
											sesReport.setAmountBudget(budget);
											sesReport.setStrAmountBudget(""+budget);
											sesReport.setFont(coa.getStatus().equals("HEADER") ? 1 : 0);											
											listReport.add(sesReport);
							  %>
                                        <tr> 
                                          <td width="56%" class="<%=cssString%>" nowrap> 
                                            <%if(coa.getStatus().equals("HEADER")){ %>
                                            <b> 
                                            <%}%>
                                            <%=strTotal+str+coa.getCode()+" - "+coa.getName()%> 
                                            <%if(coa.getStatus().equals("HEADER")){ %>
                                            </b> 
                                            <%}%>
                                          </td>
                                          <td width="16%" class="<%=cssString%>" nowrap> 
                                            <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                                <tr> 
                                                  <td width="7%"></td>
                                                  <td width="88%" class="<%=cssString%>"> 
                                                    <div align="right">
													<%if(coa.getStatus().equals("HEADER")){ %>
													<b> 
													<%}%>
													<%=displayStrBudget%>
													<%if(coa.getStatus().equals("HEADER")){ %>
													</b> 
													<%}%>
													</div>
                                                  </td>
                                                  <td width="5%"></td>
                                                </tr>
                                              </table>
                                          </td>
                                          <td width="14%" class="<%=cssString%>" nowrap> 
                                            <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                              <tr> 
                                                <td width="7%"></td>
                                                <td width="88%" class="<%=cssString%>"> 
                                                  <div align="right"> 
                                                    <%if(coa.getStatus().equals("HEADER")){ %>
                                                    <b> 
                                                    <%}%>
                                                    <%=displayStrMth%> 
                                                    <%if(coa.getStatus().equals("HEADER")){ %>
                                                    </b> 
                                                    <%}%>
                                                  </div>
                                                </td>
                                                <td width="5%"></td>
                                              </tr>
                                            </table>
                                          </td>
                                          <td width="14%" class="<%=cssString%>" nowrap> 
                                            <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                              <tr> 
                                                <td width="5%"></td>
                                                <td width="90%" class="<%=cssString%>"> 
                                                  <div align="right"><%=displayStr%></div>
                                                </td>
                                                <td width="5%"></td>
                                              </tr>
                                            </table>
                                          </td>
                                        </tr>
                                        <%					}
									}
								}
								
								if (coaSummary4<0)							
									displayStr = "("+JSPFormater.formatNumber(coaSummary4*-1,"#,###.##")+")";
								else if (coaSummary4>0)
									displayStr = JSPFormater.formatNumber(coaSummary4,"#,###.##");
								else if (coaSummary4==0)
									displayStr = "";
												
							
								if (bgtSumOthRevenue<0)							
									displayStrBudget = "("+JSPFormater.formatNumber(bgtSumOthRevenue*-1,"#,###.##")+")";
								else if (bgtSumOthRevenue>0)
									displayStrBudget = JSPFormater.formatNumber(bgtSumOthRevenue,"#,###.##");
								else if (bgtSumOthRevenue==0)
									displayStrBudget = "";
									
								if (sumOthRevenueMth<0)							
									displayStrMth = "("+JSPFormater.formatNumber(sumOthRevenueMth*-1,"#,###.##")+")";
								else if (sumOthRevenueMth>0)
									displayStrMth = JSPFormater.formatNumber(sumOthRevenueMth,"#,###.##");
								else if (sumOthRevenueMth==0)
									displayStrMth = "";	
									
									
								
								}				
							
							//add footer level
								if(DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_OTHER_REVENUE,"CD")!=0 || valShowList!=1)
								{	//add Group Footer
									sesReport = new SesReportBs();										
									sesReport.setType("Footer Group Level");
									sesReport.setDescription("Total "+I_Project.ACC_GROUP_OTHER_REVENUE);
									sesReport.setAmount(coaSummary4);
									sesReport.setStrAmount(""+coaSummary4);
									sesReport.setAmountMth(sumOthRevenueMth);
									sesReport.setStrAmountMth(""+sumOthRevenueMth);
									sesReport.setAmountBudget(bgtSumOthRevenue);
									sesReport.setStrAmountBudget(""+bgtSumOthRevenue);
									sesReport.setFont(1);												
									listReport.add(sesReport);								
						%>
                                        <tr> 
                                          <td width="56%" class="tablecell2"><span class="level2"><b><%="Total "+I_Project.ACC_GROUP_OTHER_REVENUE%></b></span></td>
                                          <td width="16%" class="tablecell2" align="right" nowrap> 
                                            
                                              <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                                <tr> 
                                                  <td width="7%"></td>
                                                  <td width="88%" class="level2"> 
                                                    
                                                  <div align="right"> 
                                                    <b> 
                                                      <%=displayStrBudget%> 
                                                      </b> 
                                                    </div>
                                                  </td>
                                                  <td width="5%"></td>
                                                </tr>
                                              </table>
                                           
                                          </td>
                                          <td width="14%" class="tablecell2" align="right" nowrap> 
                                            <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                              <tr> 
                                                <td width="7%"></td>
                                                <td width="88%" class="level2"> 
                                                  <div align="right"> 
                                                    <b> 
                                                    <%=displayStrMth%> 
                                                    </b> 
                                                  </div>
                                                </td>
                                                <td width="5%"></td>
                                              </tr>
                                            </table>
                                          </td>
                                          <td width="14%" class="tablecell2" align="right" nowrap> 
                                            <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                              <tr> 
                                                <td width="5%"></td>
                                                <td width="90%" class="level2"> 
                                                  <div align="right"><b><%=displayStr%></b></div>
                                                </td>
                                                <td width="5%"></td>
                                              </tr>
                                            </table>
                                          </td>
                                        </tr>
                                        <%
											}	
						}
											if(DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_OTHER_REVENUE,"CD")!=0 || valShowList!=1)
											{	//add Space
												sesReport = new SesReportBs();										
												sesReport.setType("Space");
												sesReport.setDescription("");
												listReport.add(sesReport);																				
					%>
                                        <tr> 
                                          <td width="56%" class="tablecell1" height="15"></td>
                                          <td width="16%" class="tablecell1" nowrap> 
                                            <div align="right"></div>
                                          </td>
                                          <td width="14%" class="tablecell1" nowrap> 
                                            <div align="right"></div>
                                          </td>
                                          <td width="14%" class="tablecell1" nowrap> 
                                            <div align="left"></div>
                                          </td>
                                        </tr>
                                        <%	}
										
										}//end if pnltype = 1, menampilkan pendapatan
										
											%>
                                        <!--level 5-->
                                        <!--level ACC_GROUP_OTHER_EXPENSE-->
                                        <%
										
										//if pnl type adalah biaya
										if(true){//pnlType == 0){
										
											if(DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_OTHER_EXPENSE,"DC")!=0 || valShowList!=1)
											{	//add Group Header
												sesReport = new SesReportBs();										
												sesReport.setType("Group Level");
												sesReport.setDescription(I_Project.ACC_GROUP_OTHER_EXPENSE);
												sesReport.setFont(1);												
												listReport.add(sesReport);
										%>
                                        <tr> 
                                          <td width="56%" class="tablecell"><b><%=I_Project.ACC_GROUP_OTHER_EXPENSE%></b></td>
                                          <td width="16%" class="tablecell" nowrap> 
                                            <div align="right"></div>
                                          </td>
                                          <td width="14%" class="tablecell" nowrap> 
                                            <div align="right"></div>
                                          </td>
                                          <td width="14%" class="tablecell" nowrap> 
                                            <div align="left"></div>
                                          </td>
                                        </tr>
                                        <%	}	%>
                                        <%
						if(listCoa!=null && listCoa.size()>0)
						{
							coaSummary5 = 0;
							String str = "";
							String str1 = "";
							displayStrBudget = "";
														
							for(int i=0; i<listCoa.size(); i++)
							{
								coa = (Coa)listCoa.get(i);
								
								if (coa.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_EXPENSE))
								{
									
									double budget = (DbCoaBudget.getBudgetRecursif(coa, yearx))/12;								
									displayStrBudget = (budget==0) ? "" : JSPFormater.formatNumber(budget, "#,###.##");
								
								
									str = switchLevel(coa.getLevel());
									str1 = switchLevel1(coa.getLevel());
									double amount = DbCoa.getCoaBalanceRecursif(coa);
									double amountMth = DbCoa.getCoaBalanceRecursif(coa,periode,"DC");
									
									displayStr = strDisplay(amount, coa.getStatus());
									displayStrMth = strDisplay(amountMth, coa.getStatus());
									
									if(!coa.getStatus().equals("HEADER")){
										totalBudget = totalBudget - budget;
										bgtSumOthExpense = bgtSumOthExpense + budget;
										totalMthAmount = totalMthAmount - amountMth;
										sumOthExpenseMth = sumOthExpenseMth + amountMth;
										totalAmount = totalAmount - amount;
										coaSummary5 = coaSummary5 + amount;
									}
									
																	
									if (valShowList==1)
									{
										if (coa.getLevel()==1)//(coa.getStatus().equals("HEADER") && DbCoa.getCoaBalanceByHeader(coa.getOID(),"DC")!=0) || ((!coa.getStatus().equals("HEADER")) && (amount!=0 || amountMth!=0 || budget!=0)))
										{	//add detail
											sesReport = new SesReportBs();
											sesReport.setType(coa.getStatus());
											sesReport.setDescription(strTotal1+str1+coa.getCode()+" - "+coa.getName());
											sesReport.setAmount(amount);
											sesReport.setStrAmount(""+amount);
											sesReport.setAmountMth(amountMth);
											sesReport.setStrAmountMth(""+amountMth);
											sesReport.setAmountBudget(budget);
											sesReport.setStrAmountBudget(""+budget);
											sesReport.setFont(coa.getStatus().equals("HEADER") ? 1 : 0);											
											listReport.add(sesReport);
							  %>
                                        <tr> 
                                          <td width="56%" class="<%=cssString%>" nowrap> 
                                            <%if(coa.getStatus().equals("HEADER")){ %>
                                            <b> 
                                            <%}%>
                                            <%=strTotal+str+coa.getCode()+" - "+coa.getName()%> 
                                            <%if(coa.getStatus().equals("HEADER")){ %>
                                            </b> 
                                            <%}%>
                                          </td>
                                          <td width="16%" class="<%=cssString%>" nowrap> 
                                            <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                                <tr> 
                                                  <td width="7%"></td>
                                                  <td width="88%" class="<%=cssString%>"> 
                                                    <div align="right">
													<%if(coa.getStatus().equals("HEADER")){ %>
													<b> 
													<%}%>
													<%=displayStrBudget%>
													<%if(coa.getStatus().equals("HEADER")){ %>
													</b> 
													<%}%>
													</div>
                                                  </td>
                                                  <td width="5%"></td>
                                                </tr>
                                              </table>
                                          </td>
                                          <td width="14%" class="<%=cssString%>" nowrap> 
                                            <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                              <tr> 
                                                <td width="7%"></td>
                                                <td width="88%" class="<%=cssString%>"> 
                                                  <div align="right"> 
                                                    <%if(coa.getStatus().equals("HEADER")){ %>
                                                    <b> 
                                                    <%}%>
                                                    <%=displayStrMth%> 
                                                    <%if(coa.getStatus().equals("HEADER")){ %>
                                                    </b> 
                                                    <%}%>
                                                  </div>
                                                </td>
                                                <td width="5%"></td>
                                              </tr>
                                            </table>
                                          </td>
                                          <td width="14%" class="<%=cssString%>" nowrap> 
                                            <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                              <tr> 
                                                <td width="5%"></td>
                                                <td width="90%" class="<%=cssString%>"> 
                                                  <div align="right"><%=displayStr%></div>
                                                </td>
                                                <td width="5%"></td>
                                              </tr>
                                            </table>
                                          </td>
                                        </tr>
                                        <%				}
									}else
									{	
										if (coa.getLevel()==1)//true)// ((coa.getStatus().equals("HEADER")) || ((!coa.getStatus().equals("HEADER")) && amount!=0))
										{	//add detail
											sesReport = new SesReportBs();
											sesReport.setType(coa.getStatus());
											sesReport.setDescription(strTotal1+str1+coa.getCode()+" - "+coa.getName());
											sesReport.setAmount(amount);
											sesReport.setStrAmount(""+amount);
											sesReport.setAmountMth(amountMth);
											sesReport.setStrAmountMth(""+amountMth);
											sesReport.setAmountBudget(budget);
											sesReport.setStrAmountBudget(""+budget);
											sesReport.setFont(coa.getStatus().equals("HEADER") ? 1 : 0);											
											listReport.add(sesReport);
							  %>
                                        <tr> 
                                          <td width="56%" class="<%=cssString%>" nowrap> 
                                            <%if(coa.getStatus().equals("HEADER")){ %>
                                            <b> 
                                            <%}%>
                                            <%=strTotal+str+coa.getCode()+" - "+coa.getName()%> 
                                            <%if(coa.getStatus().equals("HEADER")){ %>
                                            </b> 
                                            <%}%>
                                          </td>
                                          <td width="16%" class="<%=cssString%>" nowrap> 
                                            <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                                <tr> 
                                                  <td width="7%"></td>
                                                  <td width="88%" class="<%=cssString%>"> 
                                                    <div align="right">
													<%if(coa.getStatus().equals("HEADER")){ %>
													<b> 
													<%}%>
													<%=displayStrBudget%>
													<%if(coa.getStatus().equals("HEADER")){ %>
													</b> 
													<%}%>
													</div>
                                                  </td>
                                                  <td width="5%"></td>
                                                </tr>
                                              </table>
                                          </td>
                                          <td width="14%" class="<%=cssString%>" nowrap> 
                                           <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                              <tr> 
                                                <td width="7%"></td>
                                                <td width="88%" class="<%=cssString%>"> 
                                                  <div align="right"> 
                                                    <%if(coa.getStatus().equals("HEADER")){ %>
                                                    <b> 
                                                    <%}%>
                                                    <%=displayStrMth%> 
                                                    <%if(coa.getStatus().equals("HEADER")){ %>
                                                    </b> 
                                                    <%}%>
                                                  </div>
                                                </td>
                                                <td width="5%"></td>
                                              </tr>
                                            </table>
                                          </td>
                                          <td width="14%" class="<%=cssString%>" nowrap> 
                                            <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                              <tr> 
                                                <td width="5%"></td>
                                                <td width="90%" class="<%=cssString%>"> 
                                                  <div align="right"><%=displayStr%></div>
                                                </td>
                                                <td width="5%"></td>
                                              </tr>
                                            </table>
                                          </td>
                                        </tr>
                                        <%					}
												}
											}
											
											if (coaSummary5<0)							
												displayStr = "("+JSPFormater.formatNumber(coaSummary5*-1,"#,###.##")+")";
											else if (coaSummary5>0)
												displayStr = JSPFormater.formatNumber(coaSummary5,"#,###.##");
											else if (coaSummary5==0)
												displayStr = "";
															//add footer level
											
											if (bgtSumOthExpense<0)							
												displayStrBudget = "("+JSPFormater.formatNumber(bgtSumOthExpense*-1,"#,###.##")+")";
											else if (bgtSumOthExpense>0)
												displayStrBudget = JSPFormater.formatNumber(bgtSumOthExpense,"#,###.##");
											else if (bgtSumOthExpense==0)
												displayStrBudget = "";
											
											if (sumOthExpenseMth<0)							
												displayStrMth = "("+JSPFormater.formatNumber(sumOthExpenseMth*-1,"#,###.##")+")";
											else if (sumOthExpenseMth>0)
												displayStrMth = JSPFormater.formatNumber(sumOthExpenseMth,"#,###.##");
											else if (sumOthExpenseMth==0)
												displayStrMth = "";	
												
												
											}				//add footer level
											
											
											if(DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_OTHER_EXPENSE,"DC")!=0 || valShowList!=1)
											{	//add Group Footer
												sesReport = new SesReportBs();										
												sesReport.setType("Footer Group Level");
												sesReport.setDescription("Total "+I_Project.ACC_GROUP_OTHER_EXPENSE);
												sesReport.setAmount(coaSummary5);
												sesReport.setStrAmount(""+coaSummary5);
												sesReport.setAmountMth(sumOthExpenseMth);
												sesReport.setStrAmountMth(""+sumOthExpenseMth);
												sesReport.setAmountBudget(bgtSumOthExpense);
												sesReport.setStrAmountBudget(""+bgtSumOthExpense);
												sesReport.setFont(1);												
												listReport.add(sesReport);								
						%>
                                        <tr> 
                                          <td width="56%" class="tablecell2"><span class="level2"><b><%="Total "+I_Project.ACC_GROUP_OTHER_EXPENSE%></b></span></td>
                                          <td width="16%" class="tablecell2" align="right" nowrap> 
                                            <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                                <tr> 
                                                  <td width="7%"></td>
                                                  <td width="88%" class="level2"> 
                                                    <div align="right"> 
                                                      <%if(coa.getStatus().equals("HEADER")){ %>
                                                      <b> 
                                                      <%}%>
                                                      <%=displayStrBudget%> 
                                                      <%if(coa.getStatus().equals("HEADER")){ %>
                                                      </b> 
                                                      <%}%>
                                                    </div>
                                                  </td>
                                                  <td width="5%"></td>
                                                </tr>
                                              </table>
                                          </td>
                                          <td width="14%" class="tablecell2" align="right" nowrap> 
                                            <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                              <tr> 
                                                <td width="7%"></td>
                                                <td width="88%" class="level2"> 
                                                  <div align="right"> 
                                                    <b> 
                                                    <%=displayStrMth%> 
                                                    </b> 
                                                  </div>
                                                </td>
                                                <td width="5%"></td>
                                              </tr>
                                            </table>
                                          </td>
                                          <td width="14%" class="tablecell2" align="right" nowrap> 
                                            <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                              <tr> 
                                                <td width="5%"></td>
                                                <td width="90%" class="level2"> 
                                                  <div align="right"><b><%=displayStr%></b></div>
                                                </td>
                                                <td width="5%"></td>
                                              </tr>
                                            </table>
                                          </td>
                                        </tr>
                                        <%
											}	
						}
											if(DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_OTHER_EXPENSE,"DC")!=0 || valShowList!=1)
											{	//add Space
												sesReport = new SesReportBs();										
												sesReport.setType("Space");
												sesReport.setDescription("");
												listReport.add(sesReport);																				
					%>
                                        <tr> 
                                          <td width="56%" class="tablecell1" height="15"></td>
                                          <td width="16%" class="tablecell1" nowrap> 
                                            <div align="right"></div>
                                          </td>
                                          <td width="14%" class="tablecell1" nowrap> 
                                            <div align="right"></div>
                                          </td>
                                          <td width="14%" class="tablecell1" nowrap> 
                                            <div align="left"></div>
                                          </td>
                                        </tr>
                                        <%	}
										
										} //end if expense other pnltypr=0
										
										
											%>
                                        <% 
											if (totalAmount<0)							
												displayStr = "("+JSPFormater.formatNumber((totalAmount)*-1,"#,###.##")+")";
											else if (totalAmount>0)							
												displayStr = JSPFormater.formatNumber((totalAmount),"#,###.##");															
											else if (totalAmount==0)							
												displayStr = "";
												
											if (totalBudget<0)							
												displayStrBudget = "("+JSPFormater.formatNumber((totalBudget)*-1,"#,###.##")+")";
											else if (totalBudget>0)							
												displayStrBudget = JSPFormater.formatNumber((totalBudget),"#,###.##");															
											else if (totalBudget==0)							
												displayStrBudget = "";
												
											if (totalMthAmount<0)							
												displayStrMth = "("+JSPFormater.formatNumber((totalMthAmount)*-1,"#,###.##")+")";
											else if (totalMthAmount>0)							
												displayStrMth = JSPFormater.formatNumber((totalMthAmount),"#,###.##");															
											else if (totalMthAmount==0)							
												displayStrMth = "";		
												
											//displayStrBudget = (totalBudget==0) ? "" : JSPFormater.formatNumber(totalBudget, "#,###.##");	

											sesReport = new SesReportBs();										
											sesReport.setType("Last Level");
											
											String strxx = "Net Income";
											/*if(pnlType==0){
												strxx = strxx +" Expense";
											}else{
												strxx = strxx + " Income";
											}
											*/
											
											sesReport.setDescription(strxx);
											sesReport.setAmount(coaSummary1-coaSummary2-coaSummary3+coaSummary4-coaSummary5);
											sesReport.setStrAmount(""+(coaSummary1-coaSummary2-coaSummary3+coaSummary4-coaSummary5));
											sesReport.setAmountMth(sumRevenueMth-sumCogsMth-sumExpenseMth+sumOthRevenueMth-sumOthExpenseMth);
											sesReport.setStrAmountMth(""+(sumRevenueMth-sumCogsMth-sumExpenseMth+sumOthRevenueMth-sumOthExpenseMth));
											sesReport.setAmountBudget(bgtSumRevenue-bgtSumCogs-bgtSumExpense+bgtSumOthRevenue-bgtSumOthExpense);
											sesReport.setStrAmountBudget(""+(bgtSumRevenue-bgtSumCogs-bgtSumExpense+bgtSumOthRevenue-bgtSumOthExpense));
											sesReport.setFont(1);												
											listReport.add(sesReport);								
										%>
                                        <tr> 
                                          <td width="56%" class="tablecell2">
										  <span class="level2">
										  <b>Net Income</b></span></td>
                                          <td width="16%" class="tablecell2" align="right" nowrap> 
                                            <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                              <tr> 
                                                <td width="5%"></td>
                                                <td width="90%" class="level2"> 
                                                  <div align="right"><b><%=displayStrBudget%></b></div>
                                                </td>
                                                <td width="5%"></td>
                                              </tr>
                                            </table>
                                             </td>
                                          <td width="14%" class="tablecell2" align="right" nowrap> 
                                            
                                              <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                                <tr> 
                                                  <td width="5%"></td>
                                                  <td width="90%" class="level2"> 
                                                    <div align="right"><b><%=displayStrMth%></b></div>
                                                  </td>
                                                  <td width="5%"></td>
                                                </tr>
                                              </table>
                                            
                                          </td>
                                          <td width="14%" class="tablecell2" align="right" nowrap> 
                                            <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                              <tr> 
                                                <td width="5%"></td>
                                                <td width="90%" class="level2"> 
                                                  <div align="right"><b><%=displayStr%></b></div>
                                                </td>
                                                <td width="5%"></td>
                                              </tr>
                                            </table>
                                          </td>
                                        </tr>
                                      </table>
									</td>
                                  </tr>												  			  
                                </table>
                              </td>
                            </tr>
							<%
								session.putValue("PROFIT", listReport);							

/*								out.println(listReport);
								if(listReport!=null && listReport.size()>0)
								{
									for(int i=0; i<listReport.size(); i++)
									{
									SesReportBs x = new SesReportBs();
										x = (SesReportBs)listReport.get(i);
										out.println(x.getDescription());
										out.println(x.getStrAmount());
									}
								}
*/
							%>
							
                            <tr align="left" valign="top"> 
                              <td height="8" valign="middle" colspan="3">&nbsp; </td>
                            </tr>
                            <tr align="left" valign="top"> 
                              <td height="8" valign="middle" colspan="3" class="container"> 
                                <%if(listCoa!=null && listCoa.size()>0){%>
                                <table width="200" border="0" cellspacing="0" cellpadding="0">
                                  <tr> 
								    <%if(1==2){%>
                                    <td width="60"><a href="javascript:cmdPrintJournal()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('print','','../images/print2.gif',1)"><img src="../images/print.gif" name="print" width="53" height="22" border="0"></a></td>
                                    <td width="0">&nbsp;</td>
									<%}%>
                                    <td width="120"><a href="javascript:cmdPrintJournalXLS()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('printxls','','../images/printxls2.gif',1)"><img src="../images/printxls.gif" name="printxls" width="120" height="22" border="0"></a></td>
                                    <td width="20">&nbsp;</td>
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
