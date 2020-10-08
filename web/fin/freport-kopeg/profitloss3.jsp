<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%//@ page import = "com.project.fms.journal.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "com.project.fms.master.*" %>
<%@ page import = "com.project.fms.session.*" %>
<%@ page import = "com.project.payroll.*" %>
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
//boolean freportPriv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MENU_FINANCEREPROT, AppMenu.M2_MENU_FINANCEREPROT);
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
			displayStr = "";
		return displayStr;
	}
%>
<%
	if(session.getValue("PROFIT3")!=null){
		session.removeValue("PROFIT3");
	}
	String grpType = JSPRequestValue.requestString(request, "groupType");
	int iJSPCommand = JSPRequestValue.requestCommand(request);
	int start = JSPRequestValue.requestInt(request, "start");
	int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
	long oidCoa = JSPRequestValue.requestLong(request, "hidden_coa_id");
	String accGroup = JSPRequestValue.requestString(request, "acc_group");
	int valShowList = JSPRequestValue.requestInt(request, "showlist");	
	if(valShowList==0){valShowList=1;}
	int valShowLevel = JSPRequestValue.requestInt(request, "showlevel");	
	String strShowLevel = JSPRequestValue.requestString(request, "showlevel");	
	//out.println(strShowLevel);
	if(strShowLevel.equals("")){valShowLevel=3;};
	
	if(valShowLevel==-1)
		response.sendRedirect("profitloss.jsp?menu_idx=4");
	else if(valShowLevel==0)
		response.sendRedirect("profitloss0.jsp?menu_idx=4");
	else if(valShowLevel==1)
		response.sendRedirect("profitloss1.jsp?menu_idx=4");
	else if(valShowLevel==2)
		response.sendRedirect("profitloss2.jsp?menu_idx=4");				

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
	String displayStr1 = "";
	String strAmount = "";																	
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
	
	Vector vDep = DbDepartment.list(0,0,"level=0","code");
	//out.println(vDep);
	
	//Count total col span
	int colSpan = 0;
	if(vDep!=null && vDep.size()>0){
		int loopingDep = vDep.size();
		int loopingSec = 0;
		int loopingSubSec = 0;
		int loopingJob = 0;
		for(int i=0; i<vDep.size(); i++){
			Department dep = (Department)vDep.get(i);												
			Vector vSec = DbDepartment.list(0,0,"level=1 and ref_id="+dep.getOID(),"code");
			if(vSec.size()>0)
				loopingSec = loopingSec + vSec.size()-1;
			else
				loopingSec = loopingSec + vSec.size();				
			if(vSec!=null && vSec.size()>0){																
				for(int ia=0; ia<vSec.size(); ia++){
					Department depSec = (Department)vSec.get(ia);												
					Vector vSubSec = DbDepartment.list(0,0,"level=2 and ref_id="+depSec.getOID(),"code");																
					if(vSubSec.size()>0)
						loopingSubSec = loopingSubSec + vSubSec.size()-1;
					else
						loopingSubSec = loopingSubSec + vSubSec.size();
					if(vSubSec!=null && vSubSec.size()>0){																
						for(int ib=0; ib<vSubSec.size(); ib++){
							Department depSubSec = (Department)vSubSec.get(ib);												
							Vector vJob = DbDepartment.list(0,0,"level=3 and ref_id="+depSubSec.getOID(),"code");																
							if(vJob.size()>0)
								loopingJob = loopingJob + vJob.size()-1;
							else
								loopingJob = loopingJob + vJob.size();
						}
					}
				}
			}
		}
		colSpan = loopingDep+loopingSec+loopingSubSec+loopingJob;
	}
	
	
	Vector vSesDep = new Vector();

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
	document.frmcoa.action="profitloss3.jsp";
	document.frmcoa.submit();
}

function cmdPrintJournal(){	 
	window.open("<%=printroot%>.report.RptProfitLoss3XLS?oid=<%=appSessUser.getLoginId()%>");
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
<body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','../images/printxls2.gif')">
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
					  String navigator = "<font class=\"lvl1\">Financial Report</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">P&L Job Detail Base</span></font>";
					  %>
					  <%@ include file="../main/navigator.jsp"%>
					  <span class="level1">Financial 
                        Report </span> &raquo; Profit &amp; Loss &raquo; <span class="level2">Job 
                        Base <br>
                        </span><!-- #EndEditable --></td>
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
                                    <td height="20" valign="middle" align="center" colspan="3"><span class="level1"><font size="+1"><b>PROFIT & LOSS STATEMENT</b></font></span></td>
                                  </tr>                          
								  <%
								  	Periode periode = DbPeriode.getOpenPeriod();
									String openPeriod = JSPFormater.formatDate(periode.getStartDate(), "dd MMM yyyy")+ " - " + JSPFormater.formatDate(periode.getEndDate(), "dd MMM yyyy");        
								  %>        
								  <tr align="left" valign="top"> 
                                    <td height="20" valign="middle" align="center" colspan="3"><span class="level1"><b>PERIOD <%=openPeriod.toUpperCase()%></b></span></td>
                                  </tr>         
								                           
								  <tr align="left" valign="top"> 
                                    <td height="10" valign="middle" colspan="3"></td>
                                  </tr>                                  
                                  <tr align="left" valign="top"> 
                                    <td height="22" valign="middle" colspan="3" class="page"> 
                                      <table width="100%" border="0" cellpadding="0" height="20" cellspacing="1">                                        
                                        <tr> 
                                          <td width="400" class="tablehdr" height="22" rowspan="4" nowrap><div align="center"><b><font color="#FFFFFF">Description</font></b></div></td>
										  <%
											  	if(vDep!=null && vDep.size()>0){
													for(int i=0; i<vDep.size(); i++){
														Department dep = (Department)vDep.get(i);												
														Vector vSec = DbDepartment.list(0,0,"level=1 and ref_id="+dep.getOID(),"code");
														if(vSec!=null && vSec.size()>0){															
															int looping = 0;
															int loopingJob = 0;
															for(int ia=0; ia<vSec.size(); ia++){
																Department depSec = (Department)vSec.get(ia);												
																Vector vSubSec = DbDepartment.list(0,0,"level=2 and ref_id="+depSec.getOID(),"code");																
																if(vSubSec.size()>0)
																	looping = looping + vSubSec.size()-1;
																else
																	looping = looping + vSubSec.size();
																if(vSubSec!=null && vSubSec.size()>0){																
																	for(int ib=0; ib<vSubSec.size(); ib++){
																		Department depSubSec = (Department)vSubSec.get(ib);												
																		Vector vJob = DbDepartment.list(0,0,"level=3 and ref_id="+depSubSec.getOID(),"code");																
																		if(vJob.size()>0)
																			loopingJob = loopingJob + vJob.size()-1;
																		else
																			loopingJob = loopingJob + vJob.size();
																	}
																}

															}
										  %>
										  			<td width="150" class="tablehdr" height="22" colspan="<%=vSec.size()+looping+loopingJob%>" nowrap><%=dep.getName()%></td>
										  <%					
										  				} else
														{
										  %>
										  			<td width="150" class="tablehdr" height="22" colspan="<%=vSec.size()%>" nowrap><%=dep.getName()%></td>										  	
										  <%	}	}	}	%>										  
										  <td width="150" class="tablehdr" height="22" rowspan="4" nowrap>Total Corporate</td>
                                        </tr>
										<tr>											
										  <%
											  	if(vDep!=null && vDep.size()>0){
													for(int i=0; i<vDep.size(); i++){
														Department dep = (Department)vDep.get(i);												
														Vector vSec = DbDepartment.list(0,0,"level=1 and ref_id="+dep.getOID(),"code");
														if(vSec!=null && vSec.size()>0){															
															Vector vSubSec = new Vector();
															int loopingJob = 0;
															for(int ia=0; ia<vSec.size(); ia++){
																Department depSec = (Department)vSec.get(ia);												
																vSubSec = DbDepartment.list(0,0,"level=2 and ref_id="+depSec.getOID(),"code");
																if(vSubSec!=null && vSubSec.size()>0){																
																	for(int ib=0; ib<vSubSec.size(); ib++){
																		Department depSubSec = (Department)vSubSec.get(ib);												
																		Vector vJob = DbDepartment.list(0,0,"level=3 and ref_id="+depSubSec.getOID(),"code");																
																		if(vJob.size()>0)
																			loopingJob = loopingJob + vJob.size()-1;
																		else
																			loopingJob = loopingJob + vJob.size();
																	}
																}
										  %>
													<td width="140" class="tablehdr" height="20" colspan="<%=vSubSec.size()+loopingJob%>" nowrap><div align="center"><b><font color="#FFFFFF"><%=depSec.getName()%></font></b></div></td>										  
										  <%				}					
										  				} else
														{
										  %>
													<td width="140" class="tablehdr" height="20" nowrap><div align="center"><b><font color="#FFFFFF"></font></b></div></td>										  										  	
										  <%	}	}	}	%>										  
										</tr>
										<tr>											
										  <%
											  	if(vDep!=null && vDep.size()>0){
													for(int i=0; i<vDep.size(); i++){
														Department dep = (Department)vDep.get(i);												
														Vector vSec = DbDepartment.list(0,0,"level=1 and ref_id="+dep.getOID(),"code");
														if(vSec!=null && vSec.size()>0){															
															for(int ia=0; ia<vSec.size(); ia++){
																Department depSec = (Department)vSec.get(ia);												
																Vector vSubSec = DbDepartment.list(0,0,"level=2 and ref_id="+depSec.getOID(),"code");
																if(vSubSec!=null && vSubSec.size()>0){															
																	for(int ib=0; ib<vSubSec.size(); ib++){
																		Department depSubSec = (Department)vSubSec.get(ib);
																		Vector vJob = DbDepartment.list(0,0,"level=3 and ref_id="+depSubSec.getOID(),"code");																												
										  %>
													<td width="140" class="tablehdr" height="20" colspan="<%=vJob.size()%>" nowrap><div align="center"><b><font color="#FFFFFF"><%=depSubSec.getName()%></font></b></div></td>										  
										  <%						}					
																} else
																{
										  %>
													<td width="140" class="tablehdr" height="20" nowrap><div align="center"><b><font color="#FFFFFF"></font></b></div></td>										  
										  <%					}															  															  										  
										  					}					
										  				} else
														{
										  %>
													<td width="140" class="tablehdr" height="20" nowrap><div align="center"><b><font color="#FFFFFF"></font></b></div></td>										  										  	
										  <%	}	}	}	%>										  
										</tr>
										<tr>											
										  <%
											  	if(vDep!=null && vDep.size()>0){
													for(int i=0; i<vDep.size(); i++){
														Department dep = (Department)vDep.get(i);												
														Vector vSec = DbDepartment.list(0,0,"level=1 and ref_id="+dep.getOID(),"code");
														if(vSec!=null && vSec.size()>0){															
															for(int ia=0; ia<vSec.size(); ia++){
																Department depSec = (Department)vSec.get(ia);												
																Vector vSubSec = DbDepartment.list(0,0,"level=2 and ref_id="+depSec.getOID(),"code");
																if(vSubSec!=null && vSubSec.size()>0){															
																	for(int ib=0; ib<vSubSec.size(); ib++){
																		Department depSubSec = (Department)vSubSec.get(ib);
																		Vector vJob = DbDepartment.list(0,0,"level=3 and ref_id="+depSubSec.getOID(),"code");																												
																		if(vJob!=null && vJob.size()>0){															
																			for(int ic=0; ic<vJob.size(); ic++){
																				Department depJob = (Department)vJob.get(ic);
										  %>
													<td width="140" class="tablehdr" height="20" nowrap><div align="center"><b><font color="#FFFFFF"><%=depJob.getName()%></font></b></div></td>										  										  
										  <%
																			}
																		}else
																		{
										  %>
													<td width="140" class="tablehdr" height="20" nowrap><div align="center"><b><font color="#FFFFFF"></font></b></div></td>										  
										  <%							}
										  							}					
																} else
																{
										  %>
													<td width="140" class="tablehdr" height="20" nowrap><div align="center"><b><font color="#FFFFFF"></font></b></div></td>										  
										  <%					}															  															  										  
										  					}					
										  				} else
														{
										  %>
													<td width="140" class="tablehdr" height="20" nowrap><div align="center"><b><font color="#FFFFFF"></font></b></div></td>										  										  	
										  <%	}	}	}	%>										  
										</tr>

<!--level ACC_GROUP_REVENUE-->
										<%	
											if(DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_REVENUE,"CD")!=0 || valShowList!=1)
											{	//add Group Header
												sesReport = new SesReportBs();										
												sesReport.setType("Group Level");
												sesReport.setDescription(I_Project.ACC_GROUP_REVENUE);
												sesReport.setFont(1);												
												vSesDep = new Vector();
												for(int i=0;i<colSpan;i++)
												{
													vSesDep.add("");
												}
												sesReport.setDepartment(vSesDep);																								
												listReport.add(sesReport);
										%>
                                        <tr> 
                                          <td class="tablecell"><b><%=I_Project.ACC_GROUP_REVENUE%></b></td>
                                          <td class="tablecell" colspan="<%=colSpan+1%>"></td>
                                        </tr>									
										<% 	} %>
					<%
						if(listCoa!=null && listCoa.size()>0)
						{
							coaSummary1 = 0;
							String str = "";
							String str1 = "";							
							for(int i=0; i<listCoa.size(); i++)
							{
								coa = (Coa)listCoa.get(i);								
								
								if (coa.getAccountGroup().equals(I_Project.ACC_GROUP_REVENUE))
								{
									str = switchLevel(coa.getLevel());
									str1 = switchLevel1(coa.getLevel());
									double amount = DbCoa.getCoaBalanceCD(coa.getOID());
									strAmount = ""+amount;
									coaSummary1 = coaSummary1 + amount;
									displayStr = strDisplay(amount, coa.getStatus());
									if (valShowList==1)
									{
										if ((coa.getStatus().equals("HEADER") && DbCoa.getCoaBalanceByHeader(coa.getOID(),"CD")!=0) || ((!coa.getStatus().equals("HEADER")) && amount!=0))
										{	
							  %>
                                        <tr> 
                                          <td class="<%=cssString%>" nowrap><%if(coa.getStatus().equals("HEADER")){ %><b><%}%><%=strTotal+str+coa.getCode()+" - "+coa.getName()%><%if(coa.getStatus().equals("HEADER")){ %></b><%}%></td>                                          
										  <%
										  		vSesDep = new Vector();
											  	if(vDep!=null && vDep.size()>0){
													for(int ix=0; ix<vDep.size(); ix++){
														Department dep = (Department)vDep.get(ix);																										
														Vector vSec = DbDepartment.list(0,0,"level=1 and ref_id="+dep.getOID(),"code");
														if(vSec!=null && vSec.size()>0){
															for(int ia=0; ia<vSec.size(); ia++){
																Department depSec = (Department)vSec.get(ia);
																Vector vSubSec = DbDepartment.list(0,0,"level=2 and ref_id="+depSec.getOID(),"code");
																if(vSubSec!=null && vSubSec.size()>0){															
																	for(int ib=0; ib<vSubSec.size(); ib++){
																		Department depSubSec = (Department)vSubSec.get(ib);												
																		Vector vJob = DbDepartment.list(0,0,"level=3 and ref_id="+depSubSec.getOID(),"code");
																		if(vJob!=null && vJob.size()>0){															
																			for(int ic=0; ic<vJob.size(); ic++){
																				Department depJob = (Department)vJob.get(ic);
																				amount = DbCoa.getCoaBalance(coa.getOID(),dep.getOID(),depSec.getOID(),depSubSec.getOID(),depJob.getOID(),"CD");
																				displayStr1 = strDisplay(amount, coa.getStatus());
																				vSesDep.add(displayStr1);
																				//total by job
										  %>
										  <td class="<%=cssString%>">
										    <table width="100%" border="0" cellpadding="0" cellspacing="1">
											  <tr>
											  	<td width="5%"></td>													
												<td width="90%" class="<%=cssString%>"><div align="right"><%=displayStr1%></div></td>
												<td width="5%"></td>
										  	  </tr>
										  	</table>
										  </td>
										  <%	
																			}
																		}else 
																		{	//total by sub section
																			vSesDep.add("");
										  %>
										  									<td class="<%=cssString%>"></td>
										  <%	
										  								}
																	}
																}else 
																{	//total by section
																	vSesDep.add("");
										  %>
										  							<td class="<%=cssString%>"></td>
										  <%
																}
															}
										  				} else
														{	//total by department
															vSesDep.add("");
										  %>
															<td class="<%=cssString%>"></td>
										  <%	}	}	}	%>
										  <td class="<%=cssString%>">
										    <table width="100%" border="0" cellpadding="0" cellspacing="1">
											  <tr>
											  	<td width="5%"></td>													
												<td width="90%" class="<%=cssString%>"><div align="right"><%=displayStr%></div></td>
												<td width="5%"></td>
										  	  </tr>
										  	</table>
										  </td>
                                        </tr>									
						<%				
										//add detail
										sesReport = new SesReportBs();
										sesReport.setType(coa.getStatus());
										sesReport.setDescription(strTotal1+str1+coa.getCode()+" - "+coa.getName());
										sesReport.setAmount(amount);
										sesReport.setStrAmount(strAmount);
										sesReport.setFont(coa.getStatus().equals("HEADER") ? 1 : 0);											
										sesReport.setDepartment(vSesDep);										
										listReport.add(sesReport);
										}
									}else
									{	
										if ((coa.getStatus().equals("HEADER")) || ((!coa.getStatus().equals("HEADER")) && amount!=0))
										{	
							  %>
                                        <tr> 
                                          <td class="<%=cssString%>" nowrap><%if(coa.getStatus().equals("HEADER")){ %><b><%}%><%=strTotal+str+coa.getCode()+" - "+coa.getName()%><%if(coa.getStatus().equals("HEADER")){ %></b><%}%></td>                                          
										  <%
										  		vSesDep = new Vector();
											  	if(vDep!=null && vDep.size()>0){
													for(int ix=0; ix<vDep.size(); ix++){
														Department dep = (Department)vDep.get(ix);																										
														Vector vSec = DbDepartment.list(0,0,"level=1 and ref_id="+dep.getOID(),"code");
														if(vSec!=null && vSec.size()>0){
															for(int ia=0; ia<vSec.size(); ia++){
																Department depSec = (Department)vSec.get(ia);
																Vector vSubSec = DbDepartment.list(0,0,"level=2 and ref_id="+depSec.getOID(),"code");
																if(vSubSec!=null && vSubSec.size()>0){															
																	for(int ib=0; ib<vSubSec.size(); ib++){
																		Department depSubSec = (Department)vSubSec.get(ib);												
																		Vector vJob = DbDepartment.list(0,0,"level=3 and ref_id="+depSubSec.getOID(),"code");
																		if(vJob!=null && vJob.size()>0){															
																			for(int ic=0; ic<vJob.size(); ic++){
																				Department depJob = (Department)vJob.get(ic);
																				amount = DbCoa.getCoaBalance(coa.getOID(),dep.getOID(),depSec.getOID(),depSubSec.getOID(),depJob.getOID(),"CD");
																				displayStr1 = strDisplay(amount, coa.getStatus());
																				vSesDep.add(displayStr1);
																				//total by job
										  %>
										  <td class="<%=cssString%>">
										    <table width="100%" border="0" cellpadding="0" cellspacing="1">
											  <tr>
											  	<td width="5%"></td>													
												<td width="90%" class="<%=cssString%>"><div align="right"><%=displayStr1%></div></td>
												<td width="5%"></td>
										  	  </tr>
										  	</table>
										  </td>
										  <%	
																			}
																		}else 
																		{	//total by sub section
																			vSesDep.add("");
										  %>
										  									<td class="<%=cssString%>"></td>
										  <%	
										  								}
																	}
																}else 
																{	//total by section
																	vSesDep.add("");
										  %>
										  							<td class="<%=cssString%>"></td>
										  <%
																}
															}
										  				} else
														{	//total by department
															vSesDep.add("");
										  %>
															<td class="<%=cssString%>"></td>
										  <%	}	}	}	%>
										  <td class="<%=cssString%>">
										    <table width="100%" border="0" cellpadding="0" cellspacing="1">
											  <tr>
											  	<td width="5%"></td>													
												<td width="90%" class="<%=cssString%>"><div align="right"><%=displayStr%></div></td>
												<td width="5%"></td>
										  	  </tr>
										  	</table>
										  </td>
                                        </tr>									
										  <%	
												//add detail
												sesReport = new SesReportBs();
												sesReport.setType(coa.getStatus());
												sesReport.setDescription(strTotal1+str1+coa.getCode()+" - "+coa.getName());
												sesReport.setAmount(amount);
												sesReport.setStrAmount(strAmount);
												sesReport.setFont(coa.getStatus().equals("HEADER") ? 1 : 0);
												sesReport.setDepartment(vSesDep);										
												listReport.add(sesReport);
										}
									}
								}
							if (coaSummary1<0)							
								displayStr = "("+JSPFormater.formatNumber(coaSummary1*-1,"#,###.##")+")";
							else if (coaSummary1>0)
								displayStr = JSPFormater.formatNumber(coaSummary1,"#,###.##");
							else if (coaSummary1==0)
								displayStr = "";
							}				//add footer level
											if(DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_REVENUE,"CD")!=0 || valShowList!=1)
											{									
						%>
                                        <tr> 
                                          <td class="tablecell2"><span class="level2"><b><%="Total "+I_Project.ACC_GROUP_REVENUE%></b></span></td>
										  <%
										  		vSesDep = new Vector();
											  	if(vDep!=null && vDep.size()>0){
													for(int ix=0; ix<vDep.size(); ix++){
														Department dep = (Department)vDep.get(ix);
														Vector vSec = DbDepartment.list(0,0,"level=1 and ref_id="+dep.getOID(),"code");
														if(vSec!=null && vSec.size()>0){
															for(int ia=0; ia<vSec.size(); ia++){
																Department depSec = (Department)vSec.get(ia);												
																Vector vSubSec = DbDepartment.list(0,0,"level=2 and ref_id="+depSec.getOID(),"code");
																if(vSubSec!=null && vSubSec.size()>0){															
																	for(int ib=0; ib<vSubSec.size(); ib++){
																		Department depSubSec = (Department)vSubSec.get(ib);												
																		Vector vJob = DbDepartment.list(0,0,"level=3 and ref_id="+depSubSec.getOID(),"code");
																		if(vJob!=null && vJob.size()>0){															
																			for(int ic=0; ic<vJob.size(); ic++){
																				Department depJob = (Department)vJob.get(ic);
																				double amount = DbCoa.getCoaBalance(listCoa,I_Project.ACC_GROUP_REVENUE,"CD",dep.getOID(),depSec.getOID(),depSubSec.getOID(),depJob.getOID());																
																				displayStr1 = strDisplay(amount, "");
																				vSesDep.add(displayStr1);
																				//total by job
										  %>
										  <td class="tablecell2">
										    <table width="100%" border="0" cellpadding="0" cellspacing="1">
											  <tr>
											  	<td width="5%"></td>													
												<td width="90%" class="tablecell2"><div align="right"><b><%=displayStr1%></b></div></td>
												<td width="5%"></td>
										  	  </tr>
										  	</table>
										  </td>
										  <%	
																			}
																		}else 
																		{	//total by sub section
																			vSesDep.add("");
										  %>
											  								<td class="tablecell2"></td>
										  <%
																		}
																	}
																}else 
																{	//total by section
																	vSesDep.add("");
										  %>
										  							<td class="tablecell2"></td>
										  <%
																}
															}
										  				} else
														{	//total by department
															vSesDep.add("");
										  %>
															<td class="tablecell2"></td>
										  <%	}	}	}	%>
                                          <td class="tablecell2" align="right">
											<table width="100%" border="0" cellpadding="0" cellspacing="1">
											  <tr>
											  	<td width="5%"></td>
												<td width="90%" class="tablecell2"><div align="right"><b><%=displayStr%></b></div></td>
												<td width="5%"></td>
											  </tr>
											</table>
										  </td>
										</tr>
					<%
												//add Group Footer
												sesReport = new SesReportBs();										
												sesReport.setType("Footer Group Level");
												sesReport.setDescription("Total "+I_Project.ACC_GROUP_REVENUE);
												sesReport.setAmount(coaSummary1);
												sesReport.setStrAmount(""+coaSummary1);
												sesReport.setFont(1);
												sesReport.setDepartment(vSesDep);																																		
												listReport.add(sesReport);					
											}	
						}
											if(DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_REVENUE,"CD")!=0 || valShowList!=1)
											{	//add Space
												sesReport = new SesReportBs();										
												sesReport.setType("Space");
												sesReport.setDescription("");
												vSesDep = new Vector();
												for(int i=0;i<colSpan;i++)
												{
													vSesDep.add("");
												}
												sesReport.setDepartment(vSesDep);																								
												listReport.add(sesReport);																				
					%>
                                        <tr> 
                                          <td class="tablecell1" height="15"></td>
                                          <td class="tablecell1" colspan="<%=colSpan+1%>"></td>
										</tr>
										<%	}	%>
<!--level 2-->
<!--level ACC_GROUP_EXPENSE-->
										<%	
											if(DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_COST_OF_SALES,"DC")!=0 || valShowList!=1)
											{	//add Group Header
												sesReport = new SesReportBs();										
												sesReport.setType("Group Level");
												sesReport.setDescription(I_Project.ACC_GROUP_COST_OF_SALES);
												sesReport.setFont(1);												
												vSesDep = new Vector();
												for(int i=0;i<colSpan;i++)
												{
													vSesDep.add("");
												}
												sesReport.setDepartment(vSesDep);																								
												listReport.add(sesReport);
										%>
                                        <tr> 
                                          <td class="tablecell"><b><%=I_Project.ACC_GROUP_COST_OF_SALES%></b></td>
                                          <td class="tablecell" colspan="<%=colSpan+1%>"></td>
                                        </tr>
										<%	}	%>									
					<%
						if(listCoa!=null && listCoa.size()>0)
						{
							coaSummary2 = 0;
							String str = "";
							String str1 = "";							
							for(int i=0; i<listCoa.size(); i++)
							{
								coa = (Coa)listCoa.get(i);								
								
								if (coa.getAccountGroup().equals(I_Project.ACC_GROUP_COST_OF_SALES))
								{
									str = switchLevel(coa.getLevel());
									str1 = switchLevel1(coa.getLevel());
									double amount = DbCoa.getCoaBalance(coa.getOID());
									strAmount = ""+amount;
									coaSummary2 = coaSummary2 + amount;
									displayStr = strDisplay(amount, coa.getStatus());
									if (valShowList==1)
									{
										if ((coa.getStatus().equals("HEADER") && DbCoa.getCoaBalanceByHeader(coa.getOID(),"DC")!=0) || ((!coa.getStatus().equals("HEADER")) && amount!=0))
										{
							  %>
                                        <tr> 
                                          <td class="<%=cssString%>" nowrap><%if(coa.getStatus().equals("HEADER")){ %><b><%}%><%=strTotal+str+coa.getCode()+" - "+coa.getName()%><%if(coa.getStatus().equals("HEADER")){ %></b><%}%></td>                                          
										  <%
										  		vSesDep = new Vector();
											  	if(vDep!=null && vDep.size()>0){
													for(int ix=0; ix<vDep.size(); ix++){
														Department dep = (Department)vDep.get(ix);																										
														Vector vSec = DbDepartment.list(0,0,"level=1 and ref_id="+dep.getOID(),"code");
														if(vSec!=null && vSec.size()>0){
															for(int ia=0; ia<vSec.size(); ia++){
																Department depSec = (Department)vSec.get(ia);
																Vector vSubSec = DbDepartment.list(0,0,"level=2 and ref_id="+depSec.getOID(),"code");
																if(vSubSec!=null && vSubSec.size()>0){															
																	for(int ib=0; ib<vSubSec.size(); ib++){
																		Department depSubSec = (Department)vSubSec.get(ib);												
																		Vector vJob = DbDepartment.list(0,0,"level=3 and ref_id="+depSubSec.getOID(),"code");
																		if(vJob!=null && vJob.size()>0){															
																			for(int ic=0; ic<vJob.size(); ic++){
																				Department depJob = (Department)vJob.get(ic);
																				amount = DbCoa.getCoaBalance(coa.getOID(),dep.getOID(),depSec.getOID(),depSubSec.getOID(),depJob.getOID(),"DC");
																				displayStr1 = strDisplay(amount, coa.getStatus());
																				vSesDep.add(displayStr1);
																				//total by job
										  %>
										  <td class="<%=cssString%>">
										    <table width="100%" border="0" cellpadding="0" cellspacing="1">
											  <tr>
											  	<td width="5%"></td>													
												<td width="90%" class="<%=cssString%>"><div align="right"><%=displayStr1%></div></td>
												<td width="5%"></td>
										  	  </tr>
										  	</table>
										  </td>
										  <%	
																			}
																		}else 
																		{	//total by sub section
																			vSesDep.add("");
										  %>
										  									<td class="<%=cssString%>"></td>
										  <%	
										  								}
																	}
																}else 
																{	//total by section
																	vSesDep.add("");
										  %>
										  							<td class="<%=cssString%>"></td>
										  <%
																}
															}
										  				} else
														{	//total by department
															vSesDep.add("");
										  %>
															<td class="<%=cssString%>"></td>
										  <%	}	}	}	%>
										  <td class="<%=cssString%>">
										    <table width="100%" border="0" cellpadding="0" cellspacing="1">
											  <tr>
											  	<td width="5%"></td>													
												<td width="90%" class="<%=cssString%>"><div align="right"><%=displayStr%></div></td>
												<td width="5%"></td>
										  	  </tr>
										  	</table>
										  </td>
                                        </tr>									
						<%					//add detail
											sesReport = new SesReportBs();
											sesReport.setType(coa.getStatus());
											sesReport.setDescription(strTotal1+str1+coa.getCode()+" - "+coa.getName());
											sesReport.setAmount(amount);
											sesReport.setStrAmount(strAmount);
											sesReport.setFont(coa.getStatus().equals("HEADER") ? 1 : 0);											
											sesReport.setDepartment(vSesDep);										
											listReport.add(sesReport);			
										}
									}else
									{	
										if ((coa.getStatus().equals("HEADER")) || ((!coa.getStatus().equals("HEADER")) && amount!=0))
										{	
							  %>
                                        <tr> 
                                          <td class="<%=cssString%>" nowrap><%if(coa.getStatus().equals("HEADER")){ %><b><%}%><%=strTotal+str+coa.getCode()+" - "+coa.getName()%><%if(coa.getStatus().equals("HEADER")){ %></b><%}%></td>                                          
										  <%
										  		vSesDep = new Vector();
											  	if(vDep!=null && vDep.size()>0){
													for(int ix=0; ix<vDep.size(); ix++){
														Department dep = (Department)vDep.get(ix);																										
														Vector vSec = DbDepartment.list(0,0,"level=1 and ref_id="+dep.getOID(),"code");
														if(vSec!=null && vSec.size()>0){
															for(int ia=0; ia<vSec.size(); ia++){
																Department depSec = (Department)vSec.get(ia);
																Vector vSubSec = DbDepartment.list(0,0,"level=2 and ref_id="+depSec.getOID(),"code");
																if(vSubSec!=null && vSubSec.size()>0){															
																	for(int ib=0; ib<vSubSec.size(); ib++){
																		Department depSubSec = (Department)vSubSec.get(ib);												
																		Vector vJob = DbDepartment.list(0,0,"level=3 and ref_id="+depSubSec.getOID(),"code");
																		if(vJob!=null && vJob.size()>0){															
																			for(int ic=0; ic<vJob.size(); ic++){
																				Department depJob = (Department)vJob.get(ic);
																				amount = DbCoa.getCoaBalance(coa.getOID(),dep.getOID(),depSec.getOID(),depSubSec.getOID(),depJob.getOID(),"DC");
																				displayStr1 = strDisplay(amount, coa.getStatus());
																				vSesDep.add(displayStr1);
																				//total by job
										  %>
										  <td class="<%=cssString%>">
										    <table width="100%" border="0" cellpadding="0" cellspacing="1">
											  <tr>
											  	<td width="5%"></td>													
												<td width="90%" class="<%=cssString%>"><div align="right"><%=displayStr1%></div></td>
												<td width="5%"></td>
										  	  </tr>
										  	</table>
										  </td>
										  <%	
																			}
																		}else 
																		{	//total by sub section
																			vSesDep.add("");
										  %>
										  									<td class="<%=cssString%>"></td>
										  <%	
										  								}
																	}
																}else 
																{	//total by section
																	vSesDep.add("");
										  %>
										  							<td class="<%=cssString%>"></td>
										  <%
																}
															}
										  				} else
														{	//total by department
															vSesDep.add("");
										  %>
															<td class="<%=cssString%>"></td>
										  <%	}	}	}	%>
										  <td class="<%=cssString%>">
										    <table width="100%" border="0" cellpadding="0" cellspacing="1">
											  <tr>
											  	<td width="5%"></td>													
												<td width="90%" class="<%=cssString%>"><div align="right"><%=displayStr%></div></td>
												<td width="5%"></td>
										  	  </tr>
										  	</table>
										  </td>
                                        </tr>									
					<%						//add detail
											sesReport = new SesReportBs();
											sesReport.setType(coa.getStatus());
											sesReport.setDescription(strTotal1+str1+coa.getCode()+" - "+coa.getName());
											sesReport.setAmount(amount);
											sesReport.setStrAmount(strAmount);
											sesReport.setFont(coa.getStatus().equals("HEADER") ? 1 : 0);											
											sesReport.setDepartment(vSesDep);										
											listReport.add(sesReport);
										}
									}
								}
							if (coaSummary2<0)							
								displayStr = "("+JSPFormater.formatNumber(coaSummary2*-1,"#,###.##")+")";
							else if (coaSummary2>0)
								displayStr = JSPFormater.formatNumber(coaSummary2,"#,###.##");
							else if (coaSummary2==0)
								displayStr = "";
							}				//add footer level
											if(DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_COST_OF_SALES,"DC")!=0 || valShowList!=1)
											{									
						%>
                                        <tr> 
                                          <td class="tablecell2"><span class="level2"><b><%="Total "+I_Project.ACC_GROUP_COST_OF_SALES%></b></span></td>
										  <%
										  		vSesDep = new Vector();
											  	if(vDep!=null && vDep.size()>0){
													for(int ix=0; ix<vDep.size(); ix++){
														Department dep = (Department)vDep.get(ix);
														Vector vSec = DbDepartment.list(0,0,"level=1 and ref_id="+dep.getOID(),"code");
														if(vSec!=null && vSec.size()>0){
															for(int ia=0; ia<vSec.size(); ia++){
																Department depSec = (Department)vSec.get(ia);												
																Vector vSubSec = DbDepartment.list(0,0,"level=2 and ref_id="+depSec.getOID(),"code");
																if(vSubSec!=null && vSubSec.size()>0){															
																	for(int ib=0; ib<vSubSec.size(); ib++){
																		Department depSubSec = (Department)vSubSec.get(ib);												
																		Vector vJob = DbDepartment.list(0,0,"level=3 and ref_id="+depSubSec.getOID(),"code");
																		if(vJob!=null && vJob.size()>0){															
																			for(int ic=0; ic<vJob.size(); ic++){
																				Department depJob = (Department)vJob.get(ic);
																				double amount = DbCoa.getCoaBalance(listCoa,I_Project.ACC_GROUP_COST_OF_SALES,"DC",dep.getOID(),depSec.getOID(),depSubSec.getOID(),depJob.getOID());																
																				displayStr1 = strDisplay(amount, "");
																				vSesDep.add(displayStr1);
																				//total by job
										  %>
										  <td class="tablecell2">
										    <table width="100%" border="0" cellpadding="0" cellspacing="1">
											  <tr>
											  	<td width="5%"></td>													
												<td width="90%" class="tablecell2"><div align="right"><b><%=displayStr1%></b></div></td>
												<td width="5%"></td>
										  	  </tr>
										  	</table>
										  </td>
										  <%	
																			}
																		}else 
																		{	//total by sub section
																			vSesDep.add("");
										  %>
											  								<td class="tablecell2"></td>
										  <%
																		}
																	}
																}else 
																{	//total by section
																	vSesDep.add("");
										  %>
										  							<td class="tablecell2"></td>
										  <%
																}
															}
										  				} else
														{	//total by department
															vSesDep.add("");
										  %>
															<td class="tablecell2"></td>
										  <%	}	}	}	%>
                                          <td class="tablecell2" align="right">
											<table width="100%" border="0" cellpadding="0" cellspacing="1">
											  <tr>
											  	<td width="5%"></td>
												<td width="90%" class="tablecell2"><div align="right"><b><%=displayStr%></b></div></td>
												<td width="5%"></td>
											  </tr>
											</table>
										  </td>
										</tr>
					<%							//add Group Footer
												sesReport = new SesReportBs();										
												sesReport.setType("Footer Group Level");
												sesReport.setDescription("Total "+I_Project.ACC_GROUP_COST_OF_SALES);
												sesReport.setAmount(coaSummary2);
												sesReport.setStrAmount(""+coaSummary2);
												sesReport.setFont(1);												
												sesReport.setDepartment(vSesDep);										
												listReport.add(sesReport);
											}	
						}
											if(DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_COST_OF_SALES,"DC")!=0 || valShowList!=1)
											{	//add Space
												sesReport = new SesReportBs();										
												sesReport.setType("Space");
												sesReport.setDescription("");
												vSesDep = new Vector();
												for(int i=0;i<colSpan;i++)
												{
													vSesDep.add("");
												}
												sesReport.setDepartment(vSesDep);																								
												listReport.add(sesReport);																				
					%>
                                        <tr> 
                                          <td class="tablecell1" height="15"></td>
                                          <td class="tablecell1" colspan="<%=colSpan+1%>"></td>
										</tr>
										<%	}	%>
<!--level 3-->
<!--level ACC_GROUP_EXPENSE-->
										<%	
											if(DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_EXPENSE,"DC")!=0 || valShowList!=1)
											{	//add Group Header
												sesReport = new SesReportBs();										
												sesReport.setType("Group Level");
												sesReport.setDescription(I_Project.ACC_GROUP_EXPENSE);
												sesReport.setFont(1);												
												vSesDep = new Vector();
												for(int i=0;i<colSpan;i++)
												{
													vSesDep.add("");
												}
												sesReport.setDepartment(vSesDep);																								
												listReport.add(sesReport);
										%>
                                        <tr> 
                                          <td class="tablecell"><b><%=I_Project.ACC_GROUP_EXPENSE%></b></td>
                                          <td class="tablecell" colspan="<%=colSpan+1%>"></td>
                                        </tr>	
										<%	}	%>								
					<%
						if(listCoa!=null && listCoa.size()>0)
						{
							coaSummary3 = 0;
							String str = "";
							String str1 = "";							
							for(int i=0; i<listCoa.size(); i++)
							{
								coa = (Coa)listCoa.get(i);								
								
								if (coa.getAccountGroup().equals(I_Project.ACC_GROUP_EXPENSE))
								{
									str = switchLevel(coa.getLevel());
									str1 = switchLevel1(coa.getLevel());
									double amount = DbCoa.getCoaBalance(coa.getOID());
									strAmount = ""+amount;
									coaSummary3 = coaSummary3 + amount;
									displayStr = strDisplay(amount, coa.getStatus());
									if (valShowList==1)
									{
										if ((coa.getStatus().equals("HEADER") && DbCoa.getCoaBalanceByHeader(coa.getOID(),"DC")!=0) || ((!coa.getStatus().equals("HEADER")) && amount!=0))
										{
							  %>
                                        <tr> 
                                          <td class="<%=cssString%>" nowrap><%if(coa.getStatus().equals("HEADER")){ %><b><%}%><%=strTotal+str+coa.getCode()+" - "+coa.getName()%><%if(coa.getStatus().equals("HEADER")){ %></b><%}%></td>                                          
										  <%
										  		vSesDep = new Vector();
											  	if(vDep!=null && vDep.size()>0){
													for(int ix=0; ix<vDep.size(); ix++){
														Department dep = (Department)vDep.get(ix);																										
														Vector vSec = DbDepartment.list(0,0,"level=1 and ref_id="+dep.getOID(),"code");
														if(vSec!=null && vSec.size()>0){
															for(int ia=0; ia<vSec.size(); ia++){
																Department depSec = (Department)vSec.get(ia);
																Vector vSubSec = DbDepartment.list(0,0,"level=2 and ref_id="+depSec.getOID(),"code");
																if(vSubSec!=null && vSubSec.size()>0){															
																	for(int ib=0; ib<vSubSec.size(); ib++){
																		Department depSubSec = (Department)vSubSec.get(ib);
																		Vector vJob = DbDepartment.list(0,0,"level=3 and ref_id="+depSubSec.getOID(),"code");
																		if(vJob!=null && vJob.size()>0){															
																			for(int ic=0; ic<vJob.size(); ic++){
																				Department depJob = (Department)vJob.get(ic);
																				amount = DbCoa.getCoaBalance(coa.getOID(),dep.getOID(),depSec.getOID(),depSubSec.getOID(),depJob.getOID(),"DC");
																				displayStr1 = strDisplay(amount, coa.getStatus());
																				vSesDep.add(displayStr1);
																				//total by job
										  %>
										  <td class="<%=cssString%>">
										    <table width="100%" border="0" cellpadding="0" cellspacing="1">
											  <tr>
											  	<td width="5%"></td>													
												<td width="90%" class="<%=cssString%>"><div align="right"><%=displayStr1%></div></td>
												<td width="5%"></td>
										  	  </tr>
										  	</table>
										  </td>
										  <%	
																			}
																		}else 
																		{	//total by sub section
																			vSesDep.add("");
										  %>
										  									<td class="<%=cssString%>"></td>
										  <%	
										  								}
																	}
																}else 
																{	//total by section
																	vSesDep.add("");
										  %>
										  							<td class="<%=cssString%>"></td>
										  <%
																}
															}
										  				} else
														{	//total by department
															vSesDep.add("");
										  %>
															<td class="<%=cssString%>"></td>
										  <%	}	}	}	%>
										  <td class="<%=cssString%>">
										    <table width="100%" border="0" cellpadding="0" cellspacing="1">
											  <tr>
											  	<td width="5%"></td>													
												<td width="90%" class="<%=cssString%>"><div align="right"><%=displayStr%></div></td>
												<td width="5%"></td>
										  	  </tr>
										  	</table>
										  </td>
                                        </tr>									
						<%					//add detail
											sesReport = new SesReportBs();
											sesReport.setType(coa.getStatus());
											sesReport.setDescription(strTotal1+str1+coa.getCode()+" - "+coa.getName());
											sesReport.setAmount(amount);
											sesReport.setStrAmount(strAmount);
											sesReport.setFont(coa.getStatus().equals("HEADER") ? 1 : 0);											
											sesReport.setDepartment(vSesDep);										
											listReport.add(sesReport);
										}
									}else
									{	
										if ((coa.getStatus().equals("HEADER")) || ((!coa.getStatus().equals("HEADER")) && amount!=0))
										{	
							  %>
                                        <tr> 
                                          <td class="<%=cssString%>" nowrap><%if(coa.getStatus().equals("HEADER")){ %><b><%}%><%=strTotal+str+coa.getCode()+" - "+coa.getName()%><%if(coa.getStatus().equals("HEADER")){ %></b><%}%></td>                                          
										  <%
										  		vSesDep = new Vector();
											  	if(vDep!=null && vDep.size()>0){
													for(int ix=0; ix<vDep.size(); ix++){
														Department dep = (Department)vDep.get(ix);																										
														Vector vSec = DbDepartment.list(0,0,"level=1 and ref_id="+dep.getOID(),"code");
														if(vSec!=null && vSec.size()>0){
															for(int ia=0; ia<vSec.size(); ia++){
																Department depSec = (Department)vSec.get(ia);
																Vector vSubSec = DbDepartment.list(0,0,"level=2 and ref_id="+depSec.getOID(),"code");
																if(vSubSec!=null && vSubSec.size()>0){															
																	for(int ib=0; ib<vSubSec.size(); ib++){
																		Department depSubSec = (Department)vSubSec.get(ib);												
																		Vector vJob = DbDepartment.list(0,0,"level=3 and ref_id="+depSubSec.getOID(),"code");
																		if(vJob!=null && vJob.size()>0){															
																			for(int ic=0; ic<vJob.size(); ic++){
																				Department depJob = (Department)vJob.get(ic);
																				amount = DbCoa.getCoaBalance(coa.getOID(),dep.getOID(),depSec.getOID(),depSubSec.getOID(),depJob.getOID(),"DC");
																				displayStr1 = strDisplay(amount, coa.getStatus());
																				vSesDep.add(displayStr1);
																				//total by job
										  %>
										  <td class="<%=cssString%>">
										    <table width="100%" border="0" cellpadding="0" cellspacing="1">
											  <tr>
											  	<td width="5%"></td>													
												<td width="90%" class="<%=cssString%>"><div align="right"><%=displayStr1%></div></td>
												<td width="5%"></td>
										  	  </tr>
										  	</table>
										  </td>
										  <%	
																			}
																		}else 
																		{	//total by sub section
																			vSesDep.add("");
										  %>
										  									<td class="<%=cssString%>"></td>
										  <%	
										  								}
																	}
																}else 
																{	//total by section
																	vSesDep.add("");
										  %>
										  							<td class="<%=cssString%>"></td>
										  <%
																}
															}
										  				} else
														{	//total by department
															vSesDep.add("");
										  %>
															<td class="<%=cssString%>"></td>
										  <%	}	}	}	%>
										  <td class="<%=cssString%>">
										    <table width="100%" border="0" cellpadding="0" cellspacing="1">
											  <tr>
											  	<td width="5%"></td>													
												<td width="90%" class="<%=cssString%>"><div align="right"><%=displayStr%></div></td>
												<td width="5%"></td>
										  	  </tr>
										  	</table>
										  </td>
                                        </tr>									
					<%						//add detail
											sesReport = new SesReportBs();
											sesReport.setType(coa.getStatus());
											sesReport.setDescription(strTotal1+str1+coa.getCode()+" - "+coa.getName());
											sesReport.setAmount(amount);
											sesReport.setStrAmount(strAmount);
											sesReport.setFont(coa.getStatus().equals("HEADER") ? 1 : 0);											
											sesReport.setDepartment(vSesDep);										
											listReport.add(sesReport);
										}
									}
								}
							if (coaSummary3<0)							
								displayStr = "("+JSPFormater.formatNumber(coaSummary3*-1,"#,###.##")+")";
							else if (coaSummary3>0)
								displayStr = JSPFormater.formatNumber(coaSummary3,"#,###.##");
							else if (coaSummary3==0)
								displayStr = "";
							}				//add footer level
											if(DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_EXPENSE,"DC")!=0 || valShowList!=1)
											{									
						%>
                                        <tr> 
                                          <td class="tablecell2"><span class="level2"><b><%="Total "+I_Project.ACC_GROUP_EXPENSE%></b></span></td>
										  <%
										  		vSesDep = new Vector();
											  	if(vDep!=null && vDep.size()>0){
													for(int ix=0; ix<vDep.size(); ix++){
														Department dep = (Department)vDep.get(ix);
														Vector vSec = DbDepartment.list(0,0,"level=1 and ref_id="+dep.getOID(),"code");
														if(vSec!=null && vSec.size()>0){
															for(int ia=0; ia<vSec.size(); ia++){
																Department depSec = (Department)vSec.get(ia);												
																Vector vSubSec = DbDepartment.list(0,0,"level=2 and ref_id="+depSec.getOID(),"code");
																if(vSubSec!=null && vSubSec.size()>0){															
																	for(int ib=0; ib<vSubSec.size(); ib++){
																		Department depSubSec = (Department)vSubSec.get(ib);												
																		Vector vJob = DbDepartment.list(0,0,"level=3 and ref_id="+depSubSec.getOID(),"code");
																		if(vJob!=null && vJob.size()>0){															
																			for(int ic=0; ic<vJob.size(); ic++){
																				Department depJob = (Department)vJob.get(ic);
																				double amount = DbCoa.getCoaBalance(listCoa,I_Project.ACC_GROUP_EXPENSE,"DC",dep.getOID(),depSec.getOID(),depSubSec.getOID(),depJob.getOID());																
																				displayStr1 = strDisplay(amount, "");
																				vSesDep.add(displayStr1);
																				//total by job
										  %>
										  <td class="tablecell2">
										    <table width="100%" border="0" cellpadding="0" cellspacing="1">
											  <tr>
											  	<td width="5%"></td>													
												<td width="90%" class="tablecell2"><div align="right"><b><%=displayStr1%></b></div></td>
												<td width="5%"></td>
										  	  </tr>
										  	</table>
										  </td>
										  <%	
																			}
																		}else 
																		{	//total by sub section
																			vSesDep.add("");
										  %>
											  								<td class="tablecell2"></td>
										  <%
																		}
																	}
																}else 
																{	//total by section
																	vSesDep.add("");
										  %>
										  							<td class="tablecell2"></td>
										  <%
																}
															}
										  				} else
														{	//total by department
															vSesDep.add("");
										  %>
															<td class="tablecell2"></td>
										  <%	}	}	}	%>
                                          <td class="tablecell2" align="right">
											<table width="100%" border="0" cellpadding="0" cellspacing="1">
											  <tr>
											  	<td width="5%"></td>
												<td width="90%" class="tablecell2"><div align="right"><b><%=displayStr%></b></div></td>
												<td width="5%"></td>
											  </tr>
											</table>
										  </td>
										</tr>
					<%							//add Group Footer
												sesReport = new SesReportBs();										
												sesReport.setType("Footer Group Level");
												sesReport.setDescription("Total "+I_Project.ACC_GROUP_EXPENSE);
												sesReport.setAmount(coaSummary3);
												sesReport.setStrAmount(""+coaSummary3);
												sesReport.setFont(1);												
												sesReport.setDepartment(vSesDep);										
												listReport.add(sesReport);
											}	
						}
											if(DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_EXPENSE,"DC")!=0 || valShowList!=1)
											{	//add Space
												sesReport = new SesReportBs();										
												sesReport.setType("Space");
												sesReport.setDescription("");
												vSesDep = new Vector();
												for(int i=0;i<colSpan;i++)
												{
													vSesDep.add("");
												}
												sesReport.setDepartment(vSesDep);																								
												listReport.add(sesReport);																				
					%>
                                        <tr> 
                                          <td class="tablecell1" height="15"></td>
                                          <td class="tablecell1" colspan="<%=colSpan+1%>"></td>
										</tr>
										<%	}	%>
<!--level 4-->
<!--level ACC_GROUP_OTHER_REVENUE-->
										<%	
											if(DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_OTHER_REVENUE,"CD")!=0 || valShowList!=1)
											{	//add Group Header
												sesReport = new SesReportBs();										
												sesReport.setType("Group Level");
												sesReport.setDescription(I_Project.ACC_GROUP_OTHER_REVENUE);
												sesReport.setFont(1);												
												vSesDep = new Vector();
												for(int i=0;i<colSpan;i++)
												{
													vSesDep.add("");
												}
												sesReport.setDepartment(vSesDep);																								
												listReport.add(sesReport);
										%>
                                        <tr> 
                                          <td class="tablecell"><b><%=I_Project.ACC_GROUP_OTHER_REVENUE%></b></td>
                                          <td class="tablecell" colspan="<%=colSpan+1%>"></td>
                                        </tr>									
										<% 	} %>
					<%
						if(listCoa!=null && listCoa.size()>0)
						{
							coaSummary4 = 0;
							String str = "";
							String str1 = "";							
							for(int i=0; i<listCoa.size(); i++)
							{
								coa = (Coa)listCoa.get(i);								
								
								if (coa.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_REVENUE))
								{
									str = switchLevel(coa.getLevel());
									str1 = switchLevel1(coa.getLevel());
									double amount = DbCoa.getCoaBalanceCD(coa.getOID());
									strAmount = ""+amount;
									coaSummary4 = coaSummary4 + amount;
									displayStr = strDisplay(amount, coa.getStatus());
									if (valShowList==1)
									{
										if ((coa.getStatus().equals("HEADER") && DbCoa.getCoaBalanceByHeader(coa.getOID(),"CD")!=0) || ((!coa.getStatus().equals("HEADER")) && amount!=0))
										{	
							  %>
                                        <tr> 
                                          <td class="<%=cssString%>" nowrap><%if(coa.getStatus().equals("HEADER")){ %><b><%}%><%=strTotal+str+coa.getCode()+" - "+coa.getName()%><%if(coa.getStatus().equals("HEADER")){ %></b><%}%></td>                                          
										  <%
										  		vSesDep = new Vector();
											  	if(vDep!=null && vDep.size()>0){
													for(int ix=0; ix<vDep.size(); ix++){
														Department dep = (Department)vDep.get(ix);																										
														Vector vSec = DbDepartment.list(0,0,"level=1 and ref_id="+dep.getOID(),"code");
														if(vSec!=null && vSec.size()>0){
															for(int ia=0; ia<vSec.size(); ia++){
																Department depSec = (Department)vSec.get(ia);
																Vector vSubSec = DbDepartment.list(0,0,"level=2 and ref_id="+depSec.getOID(),"code");
																if(vSubSec!=null && vSubSec.size()>0){															
																	for(int ib=0; ib<vSubSec.size(); ib++){
																		Department depSubSec = (Department)vSubSec.get(ib);												
																		Vector vJob = DbDepartment.list(0,0,"level=3 and ref_id="+depSubSec.getOID(),"code");
																		if(vJob!=null && vJob.size()>0){															
																			for(int ic=0; ic<vJob.size(); ic++){
																				Department depJob = (Department)vJob.get(ic);
																				amount = DbCoa.getCoaBalance(coa.getOID(),dep.getOID(),depSec.getOID(),depSubSec.getOID(),depJob.getOID(),"CD");
																				displayStr1 = strDisplay(amount, coa.getStatus());
																				vSesDep.add(displayStr1);
																				//total by job
										  %>
										  <td class="<%=cssString%>">
										    <table width="100%" border="0" cellpadding="0" cellspacing="1">
											  <tr>
											  	<td width="5%"></td>													
												<td width="90%" class="<%=cssString%>"><div align="right"><%=displayStr1%></div></td>
												<td width="5%"></td>
										  	  </tr>
										  	</table>
										  </td>
										  <%	
																			}
																		}else 
																		{	//total by sub section
																			vSesDep.add("");
										  %>
										  									<td class="<%=cssString%>"></td>
										  <%	
										  								}
																	}
																}else 
																{	//total by section
																	vSesDep.add("");
										  %>
										  							<td class="<%=cssString%>"></td>
										  <%
																}
															}
										  				} else
														{	//total by department
															vSesDep.add("");
										  %>
															<td class="<%=cssString%>"></td>
										  <%	}	}	}	%>
										  <td class="<%=cssString%>">
										    <table width="100%" border="0" cellpadding="0" cellspacing="1">
											  <tr>
											  	<td width="5%"></td>													
												<td width="90%" class="<%=cssString%>"><div align="right"><%=displayStr%></div></td>
												<td width="5%"></td>
										  	  </tr>
										  	</table>
										  </td>
                                        </tr>									
						<%					//add detail
											sesReport = new SesReportBs();
											sesReport.setType(coa.getStatus());
											sesReport.setDescription(strTotal1+str1+coa.getCode()+" - "+coa.getName());
											sesReport.setAmount(amount);
											sesReport.setStrAmount(strAmount);
											sesReport.setFont(coa.getStatus().equals("HEADER") ? 1 : 0);											
											sesReport.setDepartment(vSesDep);										
											listReport.add(sesReport);
										}
									}else
									{	
										if ((coa.getStatus().equals("HEADER")) || ((!coa.getStatus().equals("HEADER")) && amount!=0))
										{	
							  %>
                                        <tr> 
                                          <td class="<%=cssString%>" nowrap><%if(coa.getStatus().equals("HEADER")){ %><b><%}%><%=strTotal+str+coa.getCode()+" - "+coa.getName()%><%if(coa.getStatus().equals("HEADER")){ %></b><%}%></td>                                          
										  <%
										  		vSesDep = new Vector();
											  	if(vDep!=null && vDep.size()>0){
													for(int ix=0; ix<vDep.size(); ix++){
														Department dep = (Department)vDep.get(ix);																										
														Vector vSec = DbDepartment.list(0,0,"level=1 and ref_id="+dep.getOID(),"code");
														if(vSec!=null && vSec.size()>0){
															for(int ia=0; ia<vSec.size(); ia++){
																Department depSec = (Department)vSec.get(ia);
																Vector vSubSec = DbDepartment.list(0,0,"level=2 and ref_id="+depSec.getOID(),"code");
																if(vSubSec!=null && vSubSec.size()>0){															
																	for(int ib=0; ib<vSubSec.size(); ib++){
																		Department depSubSec = (Department)vSubSec.get(ib);												
																		Vector vJob = DbDepartment.list(0,0,"level=3 and ref_id="+depSubSec.getOID(),"code");
																		if(vJob!=null && vJob.size()>0){															
																			for(int ic=0; ic<vJob.size(); ic++){
																				Department depJob = (Department)vJob.get(ic);
																				amount = DbCoa.getCoaBalance(coa.getOID(),dep.getOID(),depSec.getOID(),depSubSec.getOID(),depJob.getOID(),"CD");
																				displayStr1 = strDisplay(amount, coa.getStatus());
																				vSesDep.add(displayStr1);
																				//total by job
										  %>
										  <td class="<%=cssString%>">
										    <table width="100%" border="0" cellpadding="0" cellspacing="1">
											  <tr>
											  	<td width="5%"></td>													
												<td width="90%" class="<%=cssString%>"><div align="right"><%=displayStr1%></div></td>
												<td width="5%"></td>
										  	  </tr>
										  	</table>
										  </td>
										  <%	
																			}
																		}else 
																		{	//total by sub section
																			vSesDep.add("");
										  %>
										  									<td class="<%=cssString%>"></td>
										  <%	
										  								}
																	}
																}else 
																{	//total by section
																	vSesDep.add("");
										  %>
										  							<td class="<%=cssString%>"></td>
										  <%
																}
															}
										  				} else
														{	//total by department
															vSesDep.add("");
										  %>
															<td class="<%=cssString%>"></td>
										  <%	}	}	}	%>
										  <td class="<%=cssString%>">
										    <table width="100%" border="0" cellpadding="0" cellspacing="1">
											  <tr>
											  	<td width="5%"></td>													
												<td width="90%" class="<%=cssString%>"><div align="right"><%=displayStr%></div></td>
												<td width="5%"></td>
										  	  </tr>
										  	</table>
										  </td>
                                        </tr>									
					<%						//add detail
											sesReport = new SesReportBs();
											sesReport.setType(coa.getStatus());
											sesReport.setDescription(strTotal1+str1+coa.getCode()+" - "+coa.getName());
											sesReport.setAmount(amount);
											sesReport.setStrAmount(strAmount);
											sesReport.setFont(coa.getStatus().equals("HEADER") ? 1 : 0);											
											sesReport.setDepartment(vSesDep);										
											listReport.add(sesReport);
										}
									}
								}
							if (coaSummary4<0)							
								displayStr = "("+JSPFormater.formatNumber(coaSummary4*-1,"#,###.##")+")";
							else if (coaSummary4>0)
								displayStr = JSPFormater.formatNumber(coaSummary4,"#,###.##");
							else if (coaSummary4==0)
								displayStr = "";
							}				//add footer level
											if(DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_OTHER_REVENUE,"CD")!=0 || valShowList!=1)
											{									
						%>
                                        <tr> 
                                          <td class="tablecell2"><span class="level2"><b><%="Total "+I_Project.ACC_GROUP_OTHER_REVENUE%></b></span></td>
										  <%
										  		vSesDep = new Vector();
											  	if(vDep!=null && vDep.size()>0){
													for(int ix=0; ix<vDep.size(); ix++){
														Department dep = (Department)vDep.get(ix);
														Vector vSec = DbDepartment.list(0,0,"level=1 and ref_id="+dep.getOID(),"code");
														if(vSec!=null && vSec.size()>0){
															for(int ia=0; ia<vSec.size(); ia++){
																Department depSec = (Department)vSec.get(ia);												
																Vector vSubSec = DbDepartment.list(0,0,"level=2 and ref_id="+depSec.getOID(),"code");
																if(vSubSec!=null && vSubSec.size()>0){															
																	for(int ib=0; ib<vSubSec.size(); ib++){
																		Department depSubSec = (Department)vSubSec.get(ib);												
																		Vector vJob = DbDepartment.list(0,0,"level=3 and ref_id="+depSubSec.getOID(),"code");
																		if(vJob!=null && vJob.size()>0){															
																			for(int ic=0; ic<vJob.size(); ic++){
																				Department depJob = (Department)vJob.get(ic);
																				double amount = DbCoa.getCoaBalance(listCoa,I_Project.ACC_GROUP_OTHER_REVENUE,"CD",dep.getOID(),depSec.getOID(),depSubSec.getOID(),depJob.getOID());																
																				displayStr1 = strDisplay(amount, "");
																				vSesDep.add(displayStr1);
																				//total by job
										  %>
										  <td class="tablecell2">
										    <table width="100%" border="0" cellpadding="0" cellspacing="1">
											  <tr>
											  	<td width="5%"></td>													
												<td width="90%" class="tablecell2"><div align="right"><b><%=displayStr1%></b></div></td>
												<td width="5%"></td>
										  	  </tr>
										  	</table>
										  </td>
										  <%	
																			}
																		}else 
																		{	//total by sub section
																			vSesDep.add("");
										  %>
											  								<td class="tablecell2"></td>
										  <%
																		}
																	}
																}else 
																{	//total by section
																	vSesDep.add("");
										  %>
										  							<td class="tablecell2"></td>
										  <%
																}
															}
										  				} else
														{	//total by department
															vSesDep.add("");
										  %>
															<td class="tablecell2"></td>
										  <%	}	}	}	%>
                                          <td class="tablecell2" align="right">
											<table width="100%" border="0" cellpadding="0" cellspacing="1">
											  <tr>
											  	<td width="5%"></td>
												<td width="90%" class="tablecell2"><div align="right"><b><%=displayStr%></b></div></td>
												<td width="5%"></td>
											  </tr>
											</table>
										  </td>
										</tr>
					<%							//add Group Footer
												sesReport = new SesReportBs();										
												sesReport.setType("Footer Group Level");
												sesReport.setDescription("Total "+I_Project.ACC_GROUP_OTHER_REVENUE);
												sesReport.setAmount(coaSummary4);
												sesReport.setStrAmount(""+coaSummary4);
												sesReport.setFont(1);												
												sesReport.setDepartment(vSesDep);										
												listReport.add(sesReport);
											}	
						}
											if(DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_OTHER_REVENUE,"CD")!=0 || valShowList!=1)
											{	//add Space
												sesReport = new SesReportBs();										
												sesReport.setType("Space");
												sesReport.setDescription("");
												vSesDep = new Vector();
												for(int i=0;i<colSpan;i++)
												{
													vSesDep.add("");
												}
												sesReport.setDepartment(vSesDep);																								
												listReport.add(sesReport);																				
					%>
                                        <tr> 
                                          <td class="tablecell1" height="15"></td>
                                          <td class="tablecell1" colspan="<%=colSpan+1%>"></td>
										</tr>
										<%	}	%>
<!--level 5-->
<!--level ACC_GROUP_OTHER_EXPENSE-->
										<%	
											if(DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_OTHER_EXPENSE,"DC")!=0 || valShowList!=1)
											{	//add Group Header
												sesReport = new SesReportBs();										
												sesReport.setType("Group Level");
												sesReport.setDescription(I_Project.ACC_GROUP_OTHER_EXPENSE);
												sesReport.setFont(1);												
												listReport.add(sesReport);
												vSesDep = new Vector();
												for(int i=0;i<colSpan;i++)
												{
													vSesDep.add("");
												}
												sesReport.setDepartment(vSesDep);																								
										%>
                                        <tr> 
                                          <td class="tablecell"><b><%=I_Project.ACC_GROUP_OTHER_EXPENSE%></b></td>
                                          <td class="tablecell" colspan="<%=colSpan+1%>"></td>
                                        </tr>	
										<%	}	%>								
					<%
						if(listCoa!=null && listCoa.size()>0)
						{
							coaSummary5 = 0;
							String str = "";
							String str1 = "";							
							for(int i=0; i<listCoa.size(); i++)
							{
								coa = (Coa)listCoa.get(i);								
								
								if (coa.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_EXPENSE))
								{
									str = switchLevel(coa.getLevel());
									str1 = switchLevel1(coa.getLevel());
									double amount = DbCoa.getCoaBalance(coa.getOID());
									strAmount = ""+amount;
									coaSummary5 = coaSummary5 + amount;
									displayStr = strDisplay(amount, coa.getStatus());
									if (valShowList==1)
									{
										if ((coa.getStatus().equals("HEADER") && DbCoa.getCoaBalanceByHeader(coa.getOID(),"DC")!=0) || ((!coa.getStatus().equals("HEADER")) && amount!=0))
										{	
							  %>
                                        <tr> 
                                          <td class="<%=cssString%>" nowrap><%if(coa.getStatus().equals("HEADER")){ %><b><%}%><%=strTotal+str+coa.getCode()+" - "+coa.getName()%><%if(coa.getStatus().equals("HEADER")){ %></b><%}%></td>                                          
										  <%
										  		vSesDep = new Vector();
											  	if(vDep!=null && vDep.size()>0){
													for(int ix=0; ix<vDep.size(); ix++){
														Department dep = (Department)vDep.get(ix);																										
														Vector vSec = DbDepartment.list(0,0,"level=1 and ref_id="+dep.getOID(),"code");
														if(vSec!=null && vSec.size()>0){
															for(int ia=0; ia<vSec.size(); ia++){
																Department depSec = (Department)vSec.get(ia);
																Vector vSubSec = DbDepartment.list(0,0,"level=2 and ref_id="+depSec.getOID(),"code");
																if(vSubSec!=null && vSubSec.size()>0){															
																	for(int ib=0; ib<vSubSec.size(); ib++){
																		Department depSubSec = (Department)vSubSec.get(ib);												
																		Vector vJob = DbDepartment.list(0,0,"level=3 and ref_id="+depSubSec.getOID(),"code");
																		if(vJob!=null && vJob.size()>0){															
																			for(int ic=0; ic<vJob.size(); ic++){
																				Department depJob = (Department)vJob.get(ic);
																				amount = DbCoa.getCoaBalance(coa.getOID(),dep.getOID(),depSec.getOID(),depSubSec.getOID(),depJob.getOID(),"DC");
																				displayStr1 = strDisplay(amount, coa.getStatus());
																				vSesDep.add(displayStr1);
																				//total by job
										  %>
										  <td class="<%=cssString%>">
										    <table width="100%" border="0" cellpadding="0" cellspacing="1">
											  <tr>
											  	<td width="5%"></td>													
												<td width="90%" class="<%=cssString%>"><div align="right"><%=displayStr1%></div></td>
												<td width="5%"></td>
										  	  </tr>
										  	</table>
										  </td>
										  <%	
																			}
																		}else 
																		{	//total by sub section
																			vSesDep.add("");
										  %>
										  									<td class="<%=cssString%>"></td>
										  <%	
										  								}
																	}
																}else 
																{	//total by section
																	vSesDep.add("");
										  %>
										  							<td class="<%=cssString%>"></td>
										  <%
																}
															}
										  				} else
														{	//total by department
															vSesDep.add("");
										  %>
															<td class="<%=cssString%>"></td>
										  <%	}	}	}	%>

										  <td class="<%=cssString%>">
										    <table width="100%" border="0" cellpadding="0" cellspacing="1">
											  <tr>
											  	<td width="5%"></td>													
												<td width="90%" class="<%=cssString%>"><div align="right"><%=displayStr%></div></td>
												<td width="5%"></td>
										  	  </tr>
										  	</table>
										  </td>
                                        </tr>									
						<%					//add detail
											sesReport = new SesReportBs();
											sesReport.setType(coa.getStatus());
											sesReport.setDescription(strTotal1+str1+coa.getCode()+" - "+coa.getName());
											sesReport.setAmount(amount);
											sesReport.setStrAmount(strAmount);
											sesReport.setFont(coa.getStatus().equals("HEADER") ? 1 : 0);											
											sesReport.setDepartment(vSesDep);										
											listReport.add(sesReport);
										}
									}else
									{	
										if ((coa.getStatus().equals("HEADER")) || ((!coa.getStatus().equals("HEADER")) && amount!=0))
										{	
							  %>
                                        <tr> 
                                          <td class="<%=cssString%>" nowrap><%if(coa.getStatus().equals("HEADER")){ %><b><%}%><%=strTotal+str+coa.getCode()+" - "+coa.getName()%><%if(coa.getStatus().equals("HEADER")){ %></b><%}%></td>                                          
										  <%
										  		vSesDep = new Vector();
											  	if(vDep!=null && vDep.size()>0){
													for(int ix=0; ix<vDep.size(); ix++){
														Department dep = (Department)vDep.get(ix);																										
														Vector vSec = DbDepartment.list(0,0,"level=1 and ref_id="+dep.getOID(),"code");
														if(vSec!=null && vSec.size()>0){
															for(int ia=0; ia<vSec.size(); ia++){
																Department depSec = (Department)vSec.get(ia);
																Vector vSubSec = DbDepartment.list(0,0,"level=2 and ref_id="+depSec.getOID(),"code");
																if(vSubSec!=null && vSubSec.size()>0){															
																	for(int ib=0; ib<vSubSec.size(); ib++){
																		Department depSubSec = (Department)vSubSec.get(ib);												
																		Vector vJob = DbDepartment.list(0,0,"level=3 and ref_id="+depSubSec.getOID(),"code");
																		if(vJob!=null && vJob.size()>0){															
																			for(int ic=0; ic<vJob.size(); ic++){
																				Department depJob = (Department)vJob.get(ic);
																				amount = DbCoa.getCoaBalance(coa.getOID(),dep.getOID(),depSec.getOID(),depSubSec.getOID(),depJob.getOID(),"DC");
																				displayStr1 = strDisplay(amount, coa.getStatus());
																				vSesDep.add(displayStr1);
																				//total by job
										  %>
										  <td class="<%=cssString%>">
										    <table width="100%" border="0" cellpadding="0" cellspacing="1">
											  <tr>
											  	<td width="5%"></td>													
												<td width="90%" class="<%=cssString%>"><div align="right"><%=displayStr1%></div></td>
												<td width="5%"></td>
										  	  </tr>
										  	</table>
										  </td>
										  <%	
																			}
																		}else 
																		{	//total by sub section
																			vSesDep.add("");
										  %>
										  									<td class="<%=cssString%>"></td>
										  <%	
										  								}
																	}
																}else 
																{	//total by section
																	vSesDep.add("");
										  %>
										  							<td class="<%=cssString%>"></td>
										  <%
																}
															}
										  				} else
														{	//total by department
															vSesDep.add("");
										  %>
															<td class="<%=cssString%>"></td>
										  <%	}	}	}	%>
										  <td class="<%=cssString%>">
										    <table width="100%" border="0" cellpadding="0" cellspacing="1">
											  <tr>
											  	<td width="5%"></td>													
												<td width="90%" class="<%=cssString%>"><div align="right"><%=displayStr%></div></td>
												<td width="5%"></td>
										  	  </tr>
										  	</table>
										  </td>
                                        </tr>									
					<%						//add detail
											sesReport = new SesReportBs();
											sesReport.setType(coa.getStatus());
											sesReport.setDescription(strTotal1+str1+coa.getCode()+" - "+coa.getName());
											sesReport.setAmount(amount);
											sesReport.setStrAmount(strAmount);
											sesReport.setFont(coa.getStatus().equals("HEADER") ? 1 : 0);											
											sesReport.setDepartment(vSesDep);										
											listReport.add(sesReport);
										}
									}
								}
							if (coaSummary5<0)							
								displayStr = "("+JSPFormater.formatNumber(coaSummary5*-1,"#,###.##")+")";
							else if (coaSummary5>0)
								displayStr = JSPFormater.formatNumber(coaSummary5,"#,###.##");
							else if (coaSummary5==0)
								displayStr = "";
							}				//add footer level
											if(DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_OTHER_EXPENSE,"DC")!=0 || valShowList!=1)
											{									
						%>
                                        <tr> 
                                          <td class="tablecell2"><span class="level2"><b><%="Total "+I_Project.ACC_GROUP_OTHER_EXPENSE%></b></span></td>
										  <%
										  		vSesDep = new Vector();
											  	if(vDep!=null && vDep.size()>0){
													for(int ix=0; ix<vDep.size(); ix++){
														Department dep = (Department)vDep.get(ix);
														Vector vSec = DbDepartment.list(0,0,"level=1 and ref_id="+dep.getOID(),"code");
														if(vSec!=null && vSec.size()>0){
															for(int ia=0; ia<vSec.size(); ia++){
																Department depSec = (Department)vSec.get(ia);												
																Vector vSubSec = DbDepartment.list(0,0,"level=2 and ref_id="+depSec.getOID(),"code");
																if(vSubSec!=null && vSubSec.size()>0){															
																	for(int ib=0; ib<vSubSec.size(); ib++){
																		Department depSubSec = (Department)vSubSec.get(ib);												
																		Vector vJob = DbDepartment.list(0,0,"level=3 and ref_id="+depSubSec.getOID(),"code");
																		if(vJob!=null && vJob.size()>0){															
																			for(int ic=0; ic<vJob.size(); ic++){
																				Department depJob = (Department)vJob.get(ic);
																				double amount = DbCoa.getCoaBalance(listCoa,I_Project.ACC_GROUP_OTHER_EXPENSE,"DC",dep.getOID(),depSec.getOID(),depSubSec.getOID(),depJob.getOID());																
																				displayStr1 = strDisplay(amount, "");
																				vSesDep.add(displayStr1);
																				//total by job
										  %>
										  <td class="tablecell2">
										    <table width="100%" border="0" cellpadding="0" cellspacing="1">
											  <tr>
											  	<td width="5%"></td>													
												<td width="90%" class="tablecell2"><div align="right"><b><%=displayStr1%></b></div></td>
												<td width="5%"></td>
										  	  </tr>
										  	</table>
										  </td>
										  <%	
																			}
																		}else 
																		{	//total by sub section
																			vSesDep.add("");
										  %>
											  								<td class="tablecell2"></td>
										  <%
																		}
																	}
																}else 
																{	//total by section
																	vSesDep.add("");
										  %>
										  							<td class="tablecell2"></td>
										  <%
																}
															}
										  				} else
														{	//total by department
															vSesDep.add("");
										  %>
															<td class="tablecell2"></td>
										  <%	}	}	}	%>
                                          <td class="tablecell2" align="right">
											<table width="100%" border="0" cellpadding="0" cellspacing="1">
											  <tr>
											  	<td width="5%"></td>
												<td width="90%" class="tablecell2"><div align="right"><b><%=displayStr1%></b></div></td>
												<td width="5%"></td>
											  </tr>
											</table>
										  </td>
										</tr>
					<%							//add Group Footer
												sesReport = new SesReportBs();										
												sesReport.setType("Footer Group Level");
												sesReport.setDescription("Total "+I_Project.ACC_GROUP_OTHER_EXPENSE);
												sesReport.setAmount(coaSummary5);
												sesReport.setStrAmount(""+coaSummary5);
												sesReport.setFont(1);												
												sesReport.setDepartment(vSesDep);										
												listReport.add(sesReport);
											}	
						}
											if(DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_OTHER_EXPENSE,"DC")!=0 || valShowList!=1)
											{	//add Space
												sesReport = new SesReportBs();										
												sesReport.setType("Space");
												sesReport.setDescription("");
												vSesDep = new Vector();
												for(int i=0;i<colSpan;i++)
												{
													vSesDep.add("");
												}
												sesReport.setDepartment(vSesDep);																								
												listReport.add(sesReport);																				
					%>
                                        <tr> 
                                          <td class="tablecell1" height="15"></td>
                                          <td class="tablecell1" colspan="<%=colSpan+1%>"></td>
										</tr>
										<%	}	%>

										<%
											displayStr = strDisplay(coaSummary1-coaSummary2-coaSummary3+coaSummary4-coaSummary5, "");
										%>										
                                        <tr> 
                                          <td class="tablecell2"><span class="level2"><b>Net Income</b></span></td>
										  <%
										  		vSesDep = new Vector();
											  	if(vDep!=null && vDep.size()>0){
													for(int ix=0; ix<vDep.size(); ix++){
														Department dep = (Department)vDep.get(ix);
														Vector vSec = DbDepartment.list(0,0,"level=1 and ref_id="+dep.getOID(),"code");
														if(vSec!=null && vSec.size()>0){
															for(int ia=0; ia<vSec.size(); ia++){
																Department depSec = (Department)vSec.get(ia);												
																Vector vSubSec = DbDepartment.list(0,0,"level=2 and ref_id="+depSec.getOID(),"code");
																if(vSubSec!=null && vSubSec.size()>0){															
																	for(int ib=0; ib<vSubSec.size(); ib++){
																		Department depSubSec = (Department)vSubSec.get(ib);												
																		Vector vJob = DbDepartment.list(0,0,"level=3 and ref_id="+depSubSec.getOID(),"code");
																		if(vJob!=null && vJob.size()>0){															
																			for(int ic=0; ic<vJob.size(); ic++){
																				Department depJob = (Department)vJob.get(ic);
																				double amount = DbCoa.getCoaBalance(listCoa,I_Project.ACC_GROUP_REVENUE,"CD",dep.getOID(),depSec.getOID(),depSubSec.getOID(),depJob.getOID())-
																						DbCoa.getCoaBalance(listCoa,I_Project.ACC_GROUP_COST_OF_SALES,"DC",dep.getOID(),depSec.getOID(),depSubSec.getOID(),depJob.getOID())-
																						DbCoa.getCoaBalance(listCoa,I_Project.ACC_GROUP_EXPENSE,"DC",dep.getOID(),depSec.getOID(),depSubSec.getOID(),depJob.getOID())+
																						DbCoa.getCoaBalance(listCoa,I_Project.ACC_GROUP_OTHER_REVENUE,"CD",dep.getOID(),depSec.getOID(),depSubSec.getOID(),depJob.getOID())-
																						DbCoa.getCoaBalance(listCoa,I_Project.ACC_GROUP_OTHER_EXPENSE,"DC",dep.getOID(),depSec.getOID(),depSubSec.getOID(),depJob.getOID());																
																				displayStr1 = strDisplay(amount, "");
																				vSesDep.add(displayStr1);
																				//total by job
										  %>
										  <td class="tablecell2">
										    <table width="100%" border="0" cellpadding="0" cellspacing="1">
											  <tr>
											  	<td width="5%"></td>													
												<td width="90%" class="tablecell2"><div align="right"><b><%=displayStr1%></b></div></td>
												<td width="5%"></td>
										  	  </tr>
										  	</table>
										  </td>
										  <%	
																			}
																		}else 
																		{	//total by section
																			vSesDep.add("");
										  %>
												  							<td class="tablecell2"></td>
										  <%	
																		}
																	}
																}else 
																{	//total by section
																	vSesDep.add("");
										  %>
										  							<td class="tablecell2"></td>
										  <%
																}
															}
										  				} else
														{	//total by department
															vSesDep.add("");
										  %>
															<td class="tablecell2"></td>
										  <%	}	}	}	%>

                                          <td class="tablecell2" align="right">
											<table width="100%" border="0" cellpadding="0" cellspacing="1">
											  <tr>
											  	<td width="5%"></td>
												<td width="90%" class="tablecell2"><div align="right"><b><%=displayStr%></b></div></td>
												<td width="5%"></td>
											  </tr>
											</table>
										  </td>
										</tr>
										  <%
										  	sesReport = new SesReportBs();										
											sesReport.setType("Last Level");
											sesReport.setDescription("Net Income");
											sesReport.setAmount(coaSummary1-coaSummary2-coaSummary3+coaSummary4-coaSummary5);
											sesReport.setStrAmount(""+(coaSummary1-coaSummary2-coaSummary3+coaSummary4-coaSummary5));
											sesReport.setFont(1);												
											sesReport.setDepartment(vSesDep);										
											listReport.add(sesReport);
										  %>										

									  </table>
									</td>
                                  </tr>												  			  
                                </table>
                              </td>
                            </tr>
							<%
								session.putValue("PROFIT3", listReport);							

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
                                <table width="80" border="0" cellspacing="0" cellpadding="0">
                                  <tr> 
                                    <td width="60"><a href="javascript:cmdPrintJournal()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('printxls','','../images/printxls2.gif',1)"><img src="../images/printxls.gif" name="printxls" width="120" height="22" border="0"></a></td>
                                    <td width="0">&nbsp;</td>
                                    <td width="0">&nbsp;</td>
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
