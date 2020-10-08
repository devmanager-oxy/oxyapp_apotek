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
			displayStr = "";
		return displayStr;
	}

%>
<%
	if(session.getValue("PROFIT_MULTIPLE")!=null){
		session.removeValue("PROFIT_MULTIPLE");
	}
	String grpType = JSPRequestValue.requestString(request, "groupType");
	int iJSPCommand = JSPRequestValue.requestCommand(request);
	int start = JSPRequestValue.requestInt(request, "start");
	int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
	long oidCoa = JSPRequestValue.requestLong(request, "hidden_coa_id");
	String accGroup = JSPRequestValue.requestString(request, "acc_group");
	int valShowList = JSPRequestValue.requestInt(request, "showlist");	
	if(valShowList==0){valShowList=1;}
	

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
	Vector listReport = new Vector();
	SesReportBs sesReport = new SesReportBs();
	Vector vSesDep = new Vector();	
	
	Company company	= new Company();
	company = DbCompany.getCompany();
	//out.println(company.getDepartmentLevel());

	//setup tanggal terlama
	Date dt = new Date();
	dt.setDate(1);
	dt.setMonth(0);
	int year = dt.getYear();
	
	int yearselect = year;
	if(iJSPCommand!=JSPCommand.NONE){
		yearselect = JSPRequestValue.requestInt(request, "year");
	}
	
	dt.setYear(yearselect);
	Date endDate = (Date)dt.clone();
	endDate.setDate(31);
	endDate.setMonth(11);
	
	//out.println("dt : "+dt);
	
	String where = " to_days(start_date) >= to_days('"+JSPFormater.formatDate(dt, "yyyy-MM-dd")+"')"+
				   " and to_days(end_date)<=to_days('"+JSPFormater.formatDate(endDate, "yyyy-MM-dd")+"')";
	
	Vector temp = DbPeriode.list(0,0, where, "start_date");
	
	//out.println("v : "+temp);

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
	document.frmcoa.action="profitlossmultiple.jsp";
	document.frmcoa.submit();
}

function cmdChangeYear(){
	document.frmcoa.command.value="<%=JSPCommand.LIST%>";
	document.frmcoa.action="profitlossmultiple.jsp";
	document.frmcoa.submit();
}

function cmdPrintJournal(){	 
	window.open("<%=printroot%>.report.RptProfitLossMultiplePDF?oid=<%=appSessUser.getLoginId()%>&year=<%=yearselect%>");
}

function cmdPrintJournalXLS(){	 
	window.open("<%=printroot%>.report.RptProfitLossMultipleXLS?oid=<%=appSessUser.getLoginId()%>&year=<%=yearselect%>");
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
					  String navigator = "<font class=\"lvl1\">Financial Report</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">P&L Multiple Period</span></font>";
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
								  	<td height="8" valign="middle" colspan="3">
										<table width="230" border="0" cellspacing="0" cellpadding="0">
		                                  <tr align="left" valign="middle">
										    <td width="50">Show List </td>
											<td width="180" colspan="0"> 
                                                  <select name="year" onChange="javascript:cmdChangeYear()">
                                                    <option value="<%=year%>" <%if(year==yearselect){%>selected<%}%>><%=(year+1900)%></option>
                                                    <option value="<%=year-1%>" <%if((year-1)==yearselect){%>selected<%}%>><%=year-1+1900%></option>
                                                    <option value="<%=year-2%>" <%if((year-2)==yearselect){%>selected<%}%>><%=year-2+1900%></option>
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
								    <td height="20" valign="middle" colspan="3"> 
                                      <table width="100%" border="0" cellpadding="1" height="20" cellspacing="1">                                        
                                        <tr> 
                                         <td height="20" valign="middle" align="center"><span class="level1"><font size="+1"><b>PROFIT & LOSS STATEMENT</b></font></span></td>
										</tr>
									  </table>
									</td>
                                  </tr>                          
								  <%
								  	Periode periode = DbPeriode.getOpenPeriod();
									String openPeriod = JSPFormater.formatDate(periode.getStartDate(), "dd MMM yyyy")+ " - " + JSPFormater.formatDate(periode.getEndDate(), "dd MMM yyyy");        
								  %>        
								  <tr align="left" valign="top">
								    <td height="20" valign="middle" colspan="3"> 
                                      <table width="100%" border="0" cellpadding="1" height="20" cellspacing="1">                                        
                                        <tr> 
										  <td height="20" valign="middle" align="center"><span class="level1"><b>MULTIPLE 
                                            PERIODS</b></span></td>
										</tr>
									  </table>
									</td>
                                  </tr>                          
								  <tr align="left" valign="top"> 
                                    <td height="10" valign="middle" colspan="3"></td>
                                  </tr>                                  
                                  <tr align="left" valign="top"> 
                                    <td height="22" valign="middle" colspan="3" class="page"> 
                                      <table width="100%" border="0" cellpadding="1" height="20" cellspacing="1">                                        
                                        <tr> 
                                          <td class="tablehdr" height="22"><div align="center"><b><font color="#FFFFFF">Description</font></b></div></td>
										  <%for(int ix=0; ix<temp.size(); ix++){
										  		Periode per = (Periode)temp.get(ix);	
										  %>
                                          <td class="tablehdr" width="100"><%=per.getName()%></td>
                                          <%}%>
                                          <td width="100" class="tablehdr" height="22">Total</td>
                                        </tr>
<!--level ACC_GROUP_REVENUE-->
										<%	
											if(DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_REVENUE,temp,"CD")!=0 || valShowList!=1)
											{	//add Group Header
												sesReport = new SesReportBs();										
												sesReport.setType("Group Level");
												sesReport.setDescription(I_Project.ACC_GROUP_REVENUE);
												sesReport.setFont(1);
												vSesDep = new Vector();
												for(int ix=0; ix<temp.size(); ix++){
										  			Periode per = (Periode)temp.get(ix);													
													vSesDep.add("0");
												}
												sesReport.setDepartment(vSesDep);												
												listReport.add(sesReport);
										%>
                                        <tr> 
                                          <td class="tablecell"><b><%=I_Project.ACC_GROUP_REVENUE%></b></td>
										  <%for(int ix=0; ix<temp.size(); ix++){
										  		Periode per = (Periode)temp.get(ix);	
										  %>
                                          	<td class="tablecell"></td>
										  <%}%>
										  <td class="tablecell"></td>
                                        </tr>									
										<% 	} %>
					<%
						if(listCoa!=null && listCoa.size()>0)
						{
							String str = "";
							String str1 = "";							
							for(int i=0; i<listCoa.size(); i++)
							{
								coa = (Coa)listCoa.get(i);								
								
								if (coa.getAccountGroup().equals(I_Project.ACC_GROUP_REVENUE))
								{
									str = switchLevel(coa.getLevel());
									str1 = switchLevel1(coa.getLevel());
									if (valShowList==1)
									{
										if ((coa.getStatus().equals("HEADER") && DbCoa.getCoaBalanceByHeader(coa.getOID(),"CD",temp)!=0) || ((!coa.getStatus().equals("HEADER")) && DbCoa.getCoaBalance(coa.getOID(),temp,"CD")!=0))
										{	//add detail
											sesReport = new SesReportBs();
											sesReport.setType(coa.getStatus());
											sesReport.setDescription(strTotal1+str1+coa.getCode()+" - "+coa.getName());
											sesReport.setAmount(DbCoa.getCoaBalance(coa.getOID(),temp,"CD"));
											sesReport.setStrAmount(""+DbCoa.getCoaBalance(coa.getOID(),temp,"CD"));
											sesReport.setFont(coa.getStatus().equals("HEADER") ? 1 : 0);
											vSesDep = new Vector();
											for(int ix=0; ix<temp.size(); ix++){
												Periode per = (Periode)temp.get(ix);													
												vSesDep.add(""+DbCoa.getCoaBalance(coa.getOID(),per,"CD"));
											}
											sesReport.setDepartment(vSesDep);			
											listReport.add(sesReport);
							  %>
                                        <tr> 
                                          <td class="<%=cssString%>" nowrap><%if(coa.getStatus().equals("HEADER")){ %><b><%}%><%=strTotal+str+coa.getCode()+" - "+coa.getName()%><%if(coa.getStatus().equals("HEADER")){ %></b><%}%></td>                                          
										  <%for(int ix=0; ix<temp.size(); ix++){
										  		Periode per = (Periode)temp.get(ix);	
										  %>
											  <td class="<%=cssString%>">
												<table width="100%" border="0" cellpadding="0" cellspacing="1">
												  <tr>
													<td width="5%"></td>													
													
                                                <td width="90%" class="<%=cssString%>" nowrap>
                                                  <div align="right"><%=strDisplay(DbCoa.getCoaBalance(coa.getOID(),per,"CD"),coa.getStatus())%></div></td>
													<td width="5%"></td>
												  </tr>
												</table>
											  </td>
										  <%}%>	
										  <td class="<%=cssString%>">
										    <table width="100%" border="0" cellpadding="0" cellspacing="1">
											  <tr>
											  	<td width="5%"></td>													
												<td width="90%" class="<%=cssString%>" nowrap>
                                                  <div align="right"><%=strDisplay(DbCoa.getCoaBalance(coa.getOID(),temp,"CD"),coa.getStatus())%></div></td>
												<td width="5%"></td>
										  	  </tr>
										  	</table>
										  </td>
                                        </tr>									
						<%				}
									}else
									{	
										if ((coa.getStatus().equals("HEADER")) || ((!coa.getStatus().equals("HEADER")) && DbCoa.getCoaBalance(coa.getOID(),temp,"CD")!=0))
										{	//add detail
											sesReport = new SesReportBs();
											sesReport.setType(coa.getStatus());
											sesReport.setDescription(strTotal1+str1+coa.getCode()+" - "+coa.getName());
											sesReport.setAmount(DbCoa.getCoaBalance(coa.getOID(),temp,"CD"));
											sesReport.setStrAmount(""+DbCoa.getCoaBalance(coa.getOID(),temp,"CD"));
											sesReport.setFont(coa.getStatus().equals("HEADER") ? 1 : 0);											
											vSesDep = new Vector();
											for(int ix=0; ix<temp.size(); ix++){
												Periode per = (Periode)temp.get(ix);													
												vSesDep.add(""+DbCoa.getCoaBalance(coa.getOID(),per,"CD"));
											}
											sesReport.setDepartment(vSesDep);			
											listReport.add(sesReport);
							  %>
                                        <tr> 
                                          <td class="<%=cssString%>" nowrap><%if(coa.getStatus().equals("HEADER")){ %><b><%}%><%=strTotal+str+coa.getCode()+" - "+coa.getName()%><%if(coa.getStatus().equals("HEADER")){ %></b><%}%></td>                                          
										  <%for(int ix=0; ix<temp.size(); ix++){
										  		Periode per = (Periode)temp.get(ix);	
										  %>
											  <td class="<%=cssString%>">
												<table width="100%" border="0" cellpadding="0" cellspacing="1">
												  <tr>
													<td width="5%"></td>													
													
                                                <td width="90%" class="<%=cssString%>" nowrap>
                                                  <div align="right"><%=strDisplay(DbCoa.getCoaBalance(coa.getOID(),per,"CD"),coa.getStatus())%></div></td>
													<td width="5%"></td>
												  </tr>
												</table>
											  </td>
										  <%}%>
										  <td class="<%=cssString%>">
										    <table width="100%" border="0" cellpadding="0" cellspacing="1">
											  <tr>
											  	<td width="5%"></td>													
												<td width="90%" class="<%=cssString%>" nowrap>
                                                  <div align="right"><%=strDisplay(DbCoa.getCoaBalance(coa.getOID(),temp,"CD"),coa.getStatus())%></div></td>
												<td width="5%"></td>
										  	  </tr>
										  	</table>
										  </td>
                                        </tr>									
					<%					}
									}
								}
							}				//add footer level
											if(DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_REVENUE,temp,"CD")!=0 || valShowList!=1)
											{	//add Group Footer
												sesReport = new SesReportBs();										
												sesReport.setType("Footer Group Level");
												sesReport.setDescription("Total "+I_Project.ACC_GROUP_REVENUE);
												sesReport.setAmount(DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_REVENUE,temp,"CD"));
												sesReport.setStrAmount(""+DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_REVENUE,temp,"CD"));
												sesReport.setFont(1);
												vSesDep = new Vector();
												for(int ix=0; ix<temp.size(); ix++){
													Periode per = (Periode)temp.get(ix);													
													vSesDep.add(""+DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_REVENUE,"CD",per));
												}
												sesReport.setDepartment(vSesDep);																											
												listReport.add(sesReport);								
						%>
                                        <tr> 
                                          <td class="tablecell2"><span class="level2"><b><%="Total "+I_Project.ACC_GROUP_REVENUE%></b></span></td>
										  <%for(int ix=0; ix<temp.size(); ix++){
										  		Periode per = (Periode)temp.get(ix);	
										  %>
											  <td class="tablecell2" align="right">
												<table width="100%" border="0" cellpadding="0" cellspacing="1">
												  <tr>
													<td width="5%"></td>
													
                                                <td width="90%" class="tablecell2" nowrap>
                                                  <div align="right"><b><%=strDisplay(DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_REVENUE,"CD",per),coa.getStatus())%></b></div></td>
													<td width="5%"></td>
												  </tr>
												</table>
											  </td>
										  <%}%>
										  <td class="tablecell2" align="right">
											<table width="100%" border="0" cellpadding="0" cellspacing="1">
											  <tr>
											  	<td width="5%"></td>
												<td width="90%" class="tablecell2" nowrap>
                                                  <div align="right"><b><%=strDisplay(DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_REVENUE,temp,"CD"),coa.getStatus())%></b></div></td>
												<td width="5%"></td>
											  </tr>
											</table>
										  </td>
										</tr>
					<%
											}	
						}
											if(DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_REVENUE,temp,"CD")!=0 || valShowList!=1)
											{	//add Space
												sesReport = new SesReportBs();										
												sesReport.setType("Space");
												sesReport.setDescription("");
												vSesDep = new Vector();
												for(int ix=0; ix<temp.size(); ix++){
													Periode per = (Periode)temp.get(ix);													
													vSesDep.add("0");
												}
												sesReport.setDepartment(vSesDep);															
												listReport.add(sesReport);																				
					%>
                                        <tr> 
                                          <td class="tablecell1" height="15"></td>
										  <%for(int ix=0; ix<temp.size(); ix++){
										  		Periode per = (Periode)temp.get(ix);	
										  %>
                                          	<td class="tablecell1"></td>
										  <%}%>
										  <td class="tablecell1"></td>
										</tr>
										<%	}	%>
<!--level 2-->
<!--level ACC_GROUP_EXPENSE-->
										<%	
											if(DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_COST_OF_SALES,temp,"DC")!=0 || valShowList!=1)
											{	//add Group Header
												sesReport = new SesReportBs();										
												sesReport.setType("Group Level");
												sesReport.setDescription(I_Project.ACC_GROUP_COST_OF_SALES);
												sesReport.setFont(1);
												vSesDep = new Vector();
												for(int ix=0; ix<temp.size(); ix++){
													Periode per = (Periode)temp.get(ix);													
													vSesDep.add("0");
												}
												sesReport.setDepartment(vSesDep);																											
												listReport.add(sesReport);
										%>
                                        <tr> 
                                          <td class="tablecell"><b><%=I_Project.ACC_GROUP_COST_OF_SALES%></b></td>
										  <%for(int ix=0; ix<temp.size(); ix++){
										  		Periode per = (Periode)temp.get(ix);	
										  %>
                                          	<td class="tablecell"></td>
										  <%}%>										  
                                          <td class="tablecell"></td>
                                        </tr>
										<%	}	%>									
					<%
						if(listCoa!=null && listCoa.size()>0)
						{
							String str = "";
							String str1 = "";							
							for(int i=0; i<listCoa.size(); i++)
							{
								coa = (Coa)listCoa.get(i);																
								if (coa.getAccountGroup().equals(I_Project.ACC_GROUP_COST_OF_SALES))
								{
									str = switchLevel(coa.getLevel());
									str1 = switchLevel1(coa.getLevel());
									if (valShowList==1)
									{
										if ((coa.getStatus().equals("HEADER") && DbCoa.getCoaBalanceByHeader(coa.getOID(),"DC",temp)!=0) || ((!coa.getStatus().equals("HEADER")) && DbCoa.getCoaBalance(coa.getOID(),temp,"DC")!=0))
										{	//add detail
											sesReport = new SesReportBs();
											sesReport.setType(coa.getStatus());
											sesReport.setDescription(strTotal1+str1+coa.getCode()+" - "+coa.getName());
											sesReport.setAmount(DbCoa.getCoaBalance(coa.getOID(),temp,"DC"));
											sesReport.setStrAmount(""+DbCoa.getCoaBalance(coa.getOID(),temp,"DC"));
											sesReport.setFont(coa.getStatus().equals("HEADER") ? 1 : 0);											
											vSesDep = new Vector();
											for(int ix=0; ix<temp.size(); ix++){
												Periode per = (Periode)temp.get(ix);													
												vSesDep.add(""+DbCoa.getCoaBalance(coa.getOID(),per,"DC"));
											}
											sesReport.setDepartment(vSesDep);			
											listReport.add(sesReport);
							  %>
                                        <tr> 
                                          <td class="<%=cssString%>" nowrap><%if(coa.getStatus().equals("HEADER")){ %><b><%}%><%=strTotal+str+coa.getCode()+" - "+coa.getName()%><%if(coa.getStatus().equals("HEADER")){ %></b><%}%></td>                                          
										  <%for(int ix=0; ix<temp.size(); ix++){
										  		Periode per = (Periode)temp.get(ix);	
										  %>
											  <td class="<%=cssString%>">
												<table width="100%" border="0" cellpadding="0" cellspacing="1">
												  <tr>
													<td width="5%"></td>													
													
                                                <td width="90%" class="<%=cssString%>" nowrap>
                                                  <div align="right"><%=strDisplay(DbCoa.getCoaBalance(coa.getOID(),per,"DC"),coa.getStatus())%></div></td>
													<td width="5%"></td>
												  </tr>
												</table>
											  </td>
										  <%}%>	
										  <td class="<%=cssString%>">
										    <table width="100%" border="0" cellpadding="0" cellspacing="1">
											  <tr>
											  	<td width="5%"></td>													
												<td width="90%" class="<%=cssString%>" nowrap>
                                                  <div align="right"><%=strDisplay(DbCoa.getCoaBalance(coa.getOID(),temp,"DC"),coa.getStatus())%></div></td>
												<td width="5%"></td>
										  	  </tr>
										  	</table>
										  </td>
                                        </tr>									
						<%				}
									}else
									{	
										if ((coa.getStatus().equals("HEADER")) || ((!coa.getStatus().equals("HEADER")) && DbCoa.getCoaBalance(coa.getOID(),temp,"DC")!=0))
										{	//add detail
											sesReport = new SesReportBs();
											sesReport.setType(coa.getStatus());
											sesReport.setDescription(strTotal1+str1+coa.getCode()+" - "+coa.getName());
											sesReport.setAmount(DbCoa.getCoaBalance(coa.getOID(),temp,"DC"));
											sesReport.setStrAmount(""+DbCoa.getCoaBalance(coa.getOID(),temp,"DC"));
											sesReport.setFont(coa.getStatus().equals("HEADER") ? 1 : 0);											
											vSesDep = new Vector();
											for(int ix=0; ix<temp.size(); ix++){
												Periode per = (Periode)temp.get(ix);													
												vSesDep.add(""+DbCoa.getCoaBalance(coa.getOID(),per,"DC"));
											}
											sesReport.setDepartment(vSesDep);			
											listReport.add(sesReport);
							  %>
                                        <tr> 
                                          <td class="<%=cssString%>" nowrap><%if(coa.getStatus().equals("HEADER")){ %><b><%}%><%=strTotal+str+coa.getCode()+" - "+coa.getName()%><%if(coa.getStatus().equals("HEADER")){ %></b><%}%></td>                                          
										  <%for(int ix=0; ix<temp.size(); ix++){
										  		Periode per = (Periode)temp.get(ix);	
										  %>
											  <td class="<%=cssString%>">
												<table width="100%" border="0" cellpadding="0" cellspacing="1">
												  <tr>
													<td width="5%"></td>													
													
                                                <td width="90%" class="<%=cssString%>" nowrap>
                                                  <div align="right"><%=strDisplay(DbCoa.getCoaBalance(coa.getOID(),per,"DC"),coa.getStatus())%></div></td>
													<td width="5%"></td>
												  </tr>
												</table>
											  </td>
										  <%}%>	
										  <td class="<%=cssString%>">
										    <table width="100%" border="0" cellpadding="0" cellspacing="1">
											  <tr>
											  	<td width="5%"></td>													
												<td width="90%" class="<%=cssString%>" nowrap>
                                                  <div align="right"><%=strDisplay(DbCoa.getCoaBalance(coa.getOID(),temp,"DC"),coa.getStatus())%></div></td>
												<td width="5%"></td>
										  	  </tr>
										  	</table>
										  </td>
                                        </tr>									
					<%					}
									}
								}
							}				//add footer level
											if(DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_COST_OF_SALES,temp,"DC")!=0 || valShowList!=1)
											{	//add Group Footer
												sesReport = new SesReportBs();										
												sesReport.setType("Footer Group Level");
												sesReport.setDescription("Total "+I_Project.ACC_GROUP_COST_OF_SALES);
												sesReport.setAmount(DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_COST_OF_SALES,temp,"DC"));
												sesReport.setStrAmount(""+DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_COST_OF_SALES,temp,"DC"));
												sesReport.setFont(1);												
												vSesDep = new Vector();
												for(int ix=0; ix<temp.size(); ix++){
													Periode per = (Periode)temp.get(ix);													
													vSesDep.add(""+DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_COST_OF_SALES,"DC",per));
												}
												sesReport.setDepartment(vSesDep);			
												listReport.add(sesReport);								
						%>
                                        <tr> 
                                          <td class="tablecell2"><span class="level2"><b><%="Total "+I_Project.ACC_GROUP_COST_OF_SALES%></b></span></td>
										  <%for(int ix=0; ix<temp.size(); ix++){
										  		Periode per = (Periode)temp.get(ix);	
										  %>
											  <td class="tablecell2" align="right">
												<table width="100%" border="0" cellpadding="0" cellspacing="1">
												  <tr>
													<td width="5%"></td>
													
                                                <td width="90%" class="tablecell2" nowrap>
                                                  <div align="right"><b><%=strDisplay(DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_COST_OF_SALES,"DC",per),coa.getStatus())%></b></div></td>
													<td width="5%"></td>
												  </tr>
												</table>
											  </td>
										  <%}%>
                                          <td class="tablecell2" align="right">
											<table width="100%" border="0" cellpadding="0" cellspacing="1">
											  <tr>
											  	<td width="5%"></td>
												<td width="90%" class="tablecell2" nowrap>
                                                  <div align="right"><b><%=strDisplay(DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_COST_OF_SALES,temp,"DC"),coa.getStatus())%></b></div></td>
												<td width="5%"></td>
											  </tr>
											</table>
										  </td>
										</tr>
					<%
											}	
						}
											if(DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_COST_OF_SALES,temp,"DC")!=0 || valShowList!=1)
											{	//add Space
												sesReport = new SesReportBs();										
												sesReport.setType("Space");
												sesReport.setDescription("");
												vSesDep = new Vector();
												for(int ix=0; ix<temp.size(); ix++){
													Periode per = (Periode)temp.get(ix);													
													vSesDep.add("0");
												}
												sesReport.setDepartment(vSesDep);			
												listReport.add(sesReport);																				
					%>
                                        <tr> 
                                          <td class="tablecell1" height="15"></td>
										  <%for(int ix=0; ix<temp.size(); ix++){
										  		Periode per = (Periode)temp.get(ix);	
										  %>
                                          	<td class="tablecell1"></td>
										  <%}%>										  
                                          <td class="tablecell1"></td>
										</tr>
										<%	}	%>
<!--level 3-->
<!--level ACC_GROUP_EXPENSE-->
										<%	
											if(DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_EXPENSE,temp,"DC")!=0 || valShowList!=1)
											{	//add Group Header
												sesReport = new SesReportBs();										
												sesReport.setType("Group Level");
												sesReport.setDescription(I_Project.ACC_GROUP_EXPENSE);
												sesReport.setFont(1);												
												vSesDep = new Vector();
												for(int ix=0; ix<temp.size(); ix++){
													Periode per = (Periode)temp.get(ix);													
													vSesDep.add("0");
												}
												sesReport.setDepartment(vSesDep);			
												listReport.add(sesReport);
										%>
                                        <tr> 
                                          <td class="tablecell"><b><%=I_Project.ACC_GROUP_EXPENSE%></b></td>
										  <%for(int ix=0; ix<temp.size(); ix++){
										  		Periode per = (Periode)temp.get(ix);	
										  %>
                                          	<td class="tablecell"></td>
										  <%}%>										  
                                          <td class="tablecell"></td>
                                        </tr>	
										<%	}	%>								
					<%
						if(listCoa!=null && listCoa.size()>0)
						{
							String str = "";
							String str1 = "";							
							for(int i=0; i<listCoa.size(); i++)
							{
								coa = (Coa)listCoa.get(i);								
								
								if (coa.getAccountGroup().equals(I_Project.ACC_GROUP_EXPENSE))
								{
									str = switchLevel(coa.getLevel());
									str1 = switchLevel1(coa.getLevel());
									if (valShowList==1)
									{
										if ((coa.getStatus().equals("HEADER") && DbCoa.getCoaBalanceByHeader(coa.getOID(),"DC",temp)!=0) || ((!coa.getStatus().equals("HEADER")) && DbCoa.getCoaBalance(coa.getOID(),temp,"DC")!=0))
										{	//add detail
											sesReport = new SesReportBs();
											sesReport.setType(coa.getStatus());
											sesReport.setDescription(strTotal1+str1+coa.getCode()+" - "+coa.getName());
											sesReport.setAmount(DbCoa.getCoaBalance(coa.getOID(),temp,"DC"));
											sesReport.setStrAmount(""+DbCoa.getCoaBalance(coa.getOID(),temp,"DC"));
											sesReport.setFont(coa.getStatus().equals("HEADER") ? 1 : 0);											
											vSesDep = new Vector();
											for(int ix=0; ix<temp.size(); ix++){
												Periode per = (Periode)temp.get(ix);													
												vSesDep.add(""+DbCoa.getCoaBalance(coa.getOID(),per,"DC"));
											}
											sesReport.setDepartment(vSesDep);			
											listReport.add(sesReport);
							  %>
                                        <tr> 
                                          <td class="<%=cssString%>" nowrap><%if(coa.getStatus().equals("HEADER")){ %><b><%}%><%=strTotal+str+coa.getCode()+" - "+coa.getName()%><%if(coa.getStatus().equals("HEADER")){ %></b><%}%></td>                                          
										  <%for(int ix=0; ix<temp.size(); ix++){
										  		Periode per = (Periode)temp.get(ix);	
										  %>
											  <td class="<%=cssString%>">
												<table width="100%" border="0" cellpadding="0" cellspacing="1">
												  <tr>
													<td width="5%"></td>													
													
                                                <td width="90%" class="<%=cssString%>" nowrap>
                                                  <div align="right"><%=strDisplay(DbCoa.getCoaBalance(coa.getOID(),per,"DC"),coa.getStatus())%></div></td>
													<td width="5%"></td>
												  </tr>
												</table>
											  </td>
										  <%}%>	
										  <td class="<%=cssString%>">
										    <table width="100%" border="0" cellpadding="0" cellspacing="1">
											  <tr>
											  	<td width="5%"></td>													
												<td width="90%" class="<%=cssString%>" nowrap>
                                                  <div align="right"><%=strDisplay(DbCoa.getCoaBalance(coa.getOID(),temp,"DC"),coa.getStatus())%></div></td>
												<td width="5%"></td>
										  	  </tr>
										  	</table>
										  </td>
                                        </tr>									
						<%				}
									}else
									{	
										if ((coa.getStatus().equals("HEADER")) || ((!coa.getStatus().equals("HEADER")) && DbCoa.getCoaBalance(coa.getOID(),temp,"DC")!=0))
										{	//add detail
											sesReport = new SesReportBs();
											sesReport.setType(coa.getStatus());
											sesReport.setDescription(strTotal1+str1+coa.getCode()+" - "+coa.getName());
											sesReport.setAmount(DbCoa.getCoaBalance(coa.getOID(),temp,"DC"));
											sesReport.setStrAmount(""+DbCoa.getCoaBalance(coa.getOID(),temp,"DC"));
											sesReport.setFont(coa.getStatus().equals("HEADER") ? 1 : 0);											
											vSesDep = new Vector();
											for(int ix=0; ix<temp.size(); ix++){
												Periode per = (Periode)temp.get(ix);													
												vSesDep.add(""+DbCoa.getCoaBalance(coa.getOID(),per,"DC"));
											}
											sesReport.setDepartment(vSesDep);			
											listReport.add(sesReport);
							  %>
                                        <tr> 
                                          <td class="<%=cssString%>" nowrap><%if(coa.getStatus().equals("HEADER")){ %><b><%}%><%=strTotal+str+coa.getCode()+" - "+coa.getName()%><%if(coa.getStatus().equals("HEADER")){ %></b><%}%></td>                                          
										  <%for(int ix=0; ix<temp.size(); ix++){
										  		Periode per = (Periode)temp.get(ix);	
										  %>
											  <td class="<%=cssString%>">
												<table width="100%" border="0" cellpadding="0" cellspacing="1">
												  <tr>
													<td width="5%"></td>													
													
                                                <td width="90%" class="<%=cssString%>" nowrap>
                                                  <div align="right"><%=strDisplay(DbCoa.getCoaBalance(coa.getOID(),per,"DC"),coa.getStatus())%></div></td>
													<td width="5%"></td>
												  </tr>
												</table>
											  </td>
										  <%}%>	
										  <td class="<%=cssString%>">
										    <table width="100%" border="0" cellpadding="0" cellspacing="1">
											  <tr>
											  	<td width="5%"></td>													
												<td width="90%" class="<%=cssString%>" nowrap>
                                                  <div align="right"><%=strDisplay(DbCoa.getCoaBalance(coa.getOID(),temp,"DC"),coa.getStatus())%></div></td>
												<td width="5%"></td>
										  	  </tr>
										  	</table>
										  </td>
                                        </tr>									
					<%					}
									}
								}
							}				//add footer level
											if(DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_EXPENSE,temp,"DC")!=0 || valShowList!=1)
											{	//add Group Footer
												sesReport = new SesReportBs();										
												sesReport.setType("Footer Group Level");
												sesReport.setDescription("Total "+I_Project.ACC_GROUP_EXPENSE);
												sesReport.setAmount(DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_EXPENSE,temp,"DC"));
												sesReport.setStrAmount(""+DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_EXPENSE,temp,"DC"));
												sesReport.setFont(1);												
												vSesDep = new Vector();
												for(int ix=0; ix<temp.size(); ix++){
													Periode per = (Periode)temp.get(ix);													
													vSesDep.add(""+DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_EXPENSE,"DC",per));
												}
												sesReport.setDepartment(vSesDep);			
												listReport.add(sesReport);								
						%>
                                        <tr> 
                                          <td class="tablecell2"><span class="level2"><b><%="Total "+I_Project.ACC_GROUP_EXPENSE%></b></span></td>
										  <%for(int ix=0; ix<temp.size(); ix++){
										  		Periode per = (Periode)temp.get(ix);	
										  %>
											  <td class="tablecell2" align="right">
												<table width="100%" border="0" cellpadding="0" cellspacing="1">
												  <tr>
													<td width="5%"></td>
													
                                                <td width="90%" class="tablecell2" nowrap>
                                                  <div align="right"><b><%=strDisplay(DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_EXPENSE,"DC",per),coa.getStatus())%></b></div></td>
													<td width="5%"></td>
												  </tr>
												</table>
											  </td>
										  <%}%>
                                          <td class="tablecell2" align="right">
											<table width="100%" border="0" cellpadding="0" cellspacing="1">
											  <tr>
											  	<td width="5%"></td>
												<td width="90%" class="tablecell2" nowrap>
                                                  <div align="right"><b><%=strDisplay(DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_EXPENSE,temp,"DC"),coa.getStatus())%></b></div></td>
												<td width="5%"></td>
											  </tr>
											</table>
										  </td>
										</tr>
					<%
											}	
						}
											if(DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_EXPENSE,temp,"DC")!=0 || valShowList!=1)
											{	//add Space
												sesReport = new SesReportBs();										
												sesReport.setType("Space");
												sesReport.setDescription("");
												vSesDep = new Vector();
												for(int ix=0; ix<temp.size(); ix++){
													Periode per = (Periode)temp.get(ix);													
													vSesDep.add("0");
												}
												sesReport.setDepartment(vSesDep);			
												listReport.add(sesReport);																				
					%>
                                        <tr> 
                                          <td class="tablecell1" height="15"></td>
										  <%for(int ix=0; ix<temp.size(); ix++){
										  		Periode per = (Periode)temp.get(ix);	
										  %>
                                          	<td class="tablecell1"></td>
										  <%}%>										  
                                          <td class="tablecell1"></td>
										</tr>
										<%	}	%>
<!--level 4-->
<!--level ACC_GROUP_OTHER_REVENUE-->
										<%	
											if(DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_OTHER_REVENUE,temp,"CD")!=0 || valShowList!=1)
											{	//add Group Header
												sesReport = new SesReportBs();										
												sesReport.setType("Group Level");
												sesReport.setDescription(I_Project.ACC_GROUP_OTHER_REVENUE);
												sesReport.setFont(1);
												vSesDep = new Vector();
												for(int ix=0; ix<temp.size(); ix++){
													Periode per = (Periode)temp.get(ix);													
													vSesDep.add("0");
												}
												sesReport.setDepartment(vSesDep);																											
												listReport.add(sesReport);
										%>
                                        <tr> 
                                          <td class="tablecell"><b><%=I_Project.ACC_GROUP_OTHER_REVENUE%></b></td>
										  <%for(int ix=0; ix<temp.size(); ix++){
										  		Periode per = (Periode)temp.get(ix);	
										  %>
                                          	<td class="tablecell"></td>
										  <%}%>										  									  
                                          <td class="tablecell"></td>
                                        </tr>									
										<% 	} %>
					<%
						if(listCoa!=null && listCoa.size()>0)
						{
							String str = "";
							String str1 = "";							
							for(int i=0; i<listCoa.size(); i++)
							{
								coa = (Coa)listCoa.get(i);								
								
								if (coa.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_REVENUE))
								{
									str = switchLevel(coa.getLevel());
									str1 = switchLevel1(coa.getLevel());
									if (valShowList==1)
									{
										if ((coa.getStatus().equals("HEADER") && DbCoa.getCoaBalanceByHeader(coa.getOID(),"CD",temp)!=0) || ((!coa.getStatus().equals("HEADER")) && DbCoa.getCoaBalance(coa.getOID(),temp,"CD")!=0))
										{	//add detail
											sesReport = new SesReportBs();
											sesReport.setType(coa.getStatus());
											sesReport.setDescription(strTotal1+str1+coa.getCode()+" - "+coa.getName());
											sesReport.setAmount(DbCoa.getCoaBalance(coa.getOID(),temp,"CD"));
											sesReport.setStrAmount(""+DbCoa.getCoaBalance(coa.getOID(),temp,"CD"));
											sesReport.setFont(coa.getStatus().equals("HEADER") ? 1 : 0);											
											vSesDep = new Vector();
											for(int ix=0; ix<temp.size(); ix++){
												Periode per = (Periode)temp.get(ix);													
												vSesDep.add(""+DbCoa.getCoaBalance(coa.getOID(),per,"CD"));
											}
											sesReport.setDepartment(vSesDep);			
											listReport.add(sesReport);
							  %>
                                        <tr> 
                                          <td class="<%=cssString%>" nowrap><%if(coa.getStatus().equals("HEADER")){ %><b><%}%><%=strTotal+str+coa.getCode()+" - "+coa.getName()%><%if(coa.getStatus().equals("HEADER")){ %></b><%}%></td>                                          
										  <%for(int ix=0; ix<temp.size(); ix++){
										  		Periode per = (Periode)temp.get(ix);	
										  %>
											  <td class="<%=cssString%>">
												<table width="100%" border="0" cellpadding="0" cellspacing="1">
												  <tr>
													<td width="5%"></td>													
													
                                                <td width="90%" class="<%=cssString%>" nowrap>
                                                  <div align="right"><%=strDisplay(DbCoa.getCoaBalance(coa.getOID(),per,"CD"),coa.getStatus())%></div></td>
													<td width="5%"></td>
												  </tr>
												</table>
											  </td>
										  <%}%>	
										  <td class="<%=cssString%>">
										    <table width="100%" border="0" cellpadding="0" cellspacing="1">
											  <tr>
											  	<td width="5%"></td>													
												<td width="90%" class="<%=cssString%>" nowrap>
                                                  <div align="right"><%=strDisplay(DbCoa.getCoaBalance(coa.getOID(),temp,"CD"),coa.getStatus())%></div></td>
												<td width="5%"></td>
										  	  </tr>
										  	</table>
										  </td>
                                        </tr>									
						<%				}
									}else
									{	
										if ((coa.getStatus().equals("HEADER")) || ((!coa.getStatus().equals("HEADER")) && DbCoa.getCoaBalance(coa.getOID(),temp,"CD")!=0))
										{	//add detail
											sesReport = new SesReportBs();
											sesReport.setType(coa.getStatus());
											sesReport.setDescription(strTotal1+str1+coa.getCode()+" - "+coa.getName());
											sesReport.setAmount(DbCoa.getCoaBalance(coa.getOID(),temp,"CD"));
											sesReport.setStrAmount(""+DbCoa.getCoaBalance(coa.getOID(),temp,"CD"));
											sesReport.setFont(coa.getStatus().equals("HEADER") ? 1 : 0);											
											vSesDep = new Vector();
											for(int ix=0; ix<temp.size(); ix++){
												Periode per = (Periode)temp.get(ix);													
												vSesDep.add(""+DbCoa.getCoaBalance(coa.getOID(),per,"CD"));
											}
											sesReport.setDepartment(vSesDep);			
											listReport.add(sesReport);
							  %>
                                        <tr> 
                                          <td class="<%=cssString%>" nowrap><%if(coa.getStatus().equals("HEADER")){ %><b><%}%><%=strTotal+str+coa.getCode()+" - "+coa.getName()%><%if(coa.getStatus().equals("HEADER")){ %></b><%}%></td>                                          
										  <%for(int ix=0; ix<temp.size(); ix++){
										  		Periode per = (Periode)temp.get(ix);	
										  %>
											  <td class="<%=cssString%>">
												<table width="100%" border="0" cellpadding="0" cellspacing="1">
												  <tr>
													<td width="5%"></td>													
													
                                                <td width="90%" class="<%=cssString%>" nowrap>
                                                  <div align="right"><%=strDisplay(DbCoa.getCoaBalance(coa.getOID(),per,"CD"),coa.getStatus())%></div></td>
													<td width="5%"></td>
												  </tr>
												</table>
											  </td>
										  <%}%>	
										  <td class="<%=cssString%>">
										    <table width="100%" border="0" cellpadding="0" cellspacing="1">
											  <tr>
											  	<td width="5%"></td>													
												<td width="90%" class="<%=cssString%>" nowrap>
                                                  <div align="right"><%=strDisplay(DbCoa.getCoaBalance(coa.getOID(),temp,"CD"),coa.getStatus())%></div></td>
												<td width="5%"></td>
										  	  </tr>
										  	</table>
										  </td>
                                        </tr>									
					<%					}
									}
								}
							}				//add footer level
											if(DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_OTHER_REVENUE,temp,"CD")!=0 || valShowList!=1)
											{	//add Group Footer
												sesReport = new SesReportBs();										
												sesReport.setType("Footer Group Level");
												sesReport.setDescription("Total "+I_Project.ACC_GROUP_OTHER_REVENUE);
												sesReport.setAmount(DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_OTHER_REVENUE,temp,"CD"));
												sesReport.setStrAmount(""+DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_OTHER_REVENUE,temp,"CD"));
												sesReport.setFont(1);												
												vSesDep = new Vector();
												for(int ix=0; ix<temp.size(); ix++){
													Periode per = (Periode)temp.get(ix);													
													vSesDep.add(""+DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_OTHER_REVENUE,"CD",per));
												}
												sesReport.setDepartment(vSesDep);			
												listReport.add(sesReport);								
						%>
                                        <tr> 
                                          <td class="tablecell2"><span class="level2"><b><%="Total "+I_Project.ACC_GROUP_OTHER_REVENUE%></b></span></td>
										  <%for(int ix=0; ix<temp.size(); ix++){
										  		Periode per = (Periode)temp.get(ix);	
										  %>
											  <td class="tablecell2" align="right">
												<table width="100%" border="0" cellpadding="0" cellspacing="1">
												  <tr>
													<td width="5%"></td>
													
                                                <td width="90%" class="tablecell2" nowrap>
                                                  <div align="right"><b><%=strDisplay(DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_OTHER_REVENUE,"CD",per),coa.getStatus())%></b></div></td>
													<td width="5%"></td>
												  </tr>
												</table>
											  </td>
										  <%}%>
                                          <td class="tablecell2" align="right">
											<table width="100%" border="0" cellpadding="0" cellspacing="1">
											  <tr>
											  	<td width="5%"></td>
												<td width="90%" class="tablecell2" nowrap>
                                                  <div align="right"><b><%=strDisplay(DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_OTHER_REVENUE,temp,"CD"),coa.getStatus())%></b></div></td>
												<td width="5%"></td>
											  </tr>
											</table>
										  </td>
										</tr>
					<%
											}	
						}
											if(DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_OTHER_REVENUE,temp,"CD")!=0 || valShowList!=1)
											{	//add Space
												sesReport = new SesReportBs();										
												sesReport.setType("Space");
												sesReport.setDescription("");
												vSesDep = new Vector();
												for(int ix=0; ix<temp.size(); ix++){
													Periode per = (Periode)temp.get(ix);													
													vSesDep.add("0");
												}
												sesReport.setDepartment(vSesDep);			
												listReport.add(sesReport);																				
					%>
                                        <tr> 
                                          <td class="tablecell1" height="15"></td>
										  <%for(int ix=0; ix<temp.size(); ix++){
										  		Periode per = (Periode)temp.get(ix);	
										  %>
                                          	<td class="tablecell1"></td>
										  <%}%>										  
                                          <td class="tablecell1"></td>
										</tr>
										<%	}	%>
<!--level 5-->
<!--level ACC_GROUP_OTHER_EXPENSE-->
										<%	
											if(DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_OTHER_EXPENSE,temp,"DC")!=0 || valShowList!=1)
											{	//add Group Header
												sesReport = new SesReportBs();										
												sesReport.setType("Group Level");
												sesReport.setDescription(I_Project.ACC_GROUP_OTHER_EXPENSE);
												sesReport.setFont(1);												
												vSesDep = new Vector();
												for(int ix=0; ix<temp.size(); ix++){
													Periode per = (Periode)temp.get(ix);													
													vSesDep.add("0");
												}
												sesReport.setDepartment(vSesDep);			
												listReport.add(sesReport);
										%>
                                        <tr> 
                                          <td class="tablecell"><b><%=I_Project.ACC_GROUP_OTHER_EXPENSE%></b></td>
										  <%for(int ix=0; ix<temp.size(); ix++){
										  		Periode per = (Periode)temp.get(ix);	
										  %>
                                          	<td class="tablecell"></td>
										  <%}%>										  
                                          <td class="tablecell"></td>
                                        </tr>	
										<%	}	%>								
					<%
						if(listCoa!=null && listCoa.size()>0)
						{
							String str = "";
							String str1 = "";							
							for(int i=0; i<listCoa.size(); i++)
							{
								coa = (Coa)listCoa.get(i);								
								
								if (coa.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_EXPENSE))
								{
									str = switchLevel(coa.getLevel());
									str1 = switchLevel1(coa.getLevel());
									if (valShowList==1)
									{
										if ((coa.getStatus().equals("HEADER") && DbCoa.getCoaBalanceByHeader(coa.getOID(),"DC",temp)!=0) || ((!coa.getStatus().equals("HEADER")) && DbCoa.getCoaBalance(coa.getOID(),temp,"DC")!=0))
										{	//add detail
											sesReport = new SesReportBs();
											sesReport.setType(coa.getStatus());
											sesReport.setDescription(strTotal1+str1+coa.getCode()+" - "+coa.getName());
											sesReport.setAmount(DbCoa.getCoaBalance(coa.getOID(),temp,"DC"));
											sesReport.setStrAmount(""+DbCoa.getCoaBalance(coa.getOID(),temp,"DC"));
											sesReport.setFont(coa.getStatus().equals("HEADER") ? 1 : 0);											
											vSesDep = new Vector();
											for(int ix=0; ix<temp.size(); ix++){
												Periode per = (Periode)temp.get(ix);													
												vSesDep.add(""+DbCoa.getCoaBalance(coa.getOID(),per,"DC"));
											}
											sesReport.setDepartment(vSesDep);			
											listReport.add(sesReport);
							  %>
                                        <tr> 
                                          <td class="<%=cssString%>" nowrap><%if(coa.getStatus().equals("HEADER")){ %><b><%}%><%=strTotal+str+coa.getCode()+" - "+coa.getName()%><%if(coa.getStatus().equals("HEADER")){ %></b><%}%></td>                                          
										  <%for(int ix=0; ix<temp.size(); ix++){
										  		Periode per = (Periode)temp.get(ix);	
										  %>
											  <td class="<%=cssString%>">
												<table width="100%" border="0" cellpadding="0" cellspacing="1">
												  <tr>
													<td width="5%"></td>													
													
                                                <td width="90%" class="<%=cssString%>" nowrap>
                                                  <div align="right"><%=strDisplay(DbCoa.getCoaBalance(coa.getOID(),per,"DC"),coa.getStatus())%></div></td>
													<td width="5%"></td>
												  </tr>
												</table>
											  </td>
										  <%}%>	
										  <td class="<%=cssString%>">
										    <table width="100%" border="0" cellpadding="0" cellspacing="1">
											  <tr>
											  	<td width="5%"></td>													
												<td width="90%" class="<%=cssString%>" nowrap>
                                                  <div align="right"><%=strDisplay(DbCoa.getCoaBalance(coa.getOID(),temp,"DC"),coa.getStatus())%></div></td>
												<td width="5%"></td>
										  	  </tr>
										  	</table>
										  </td>
                                        </tr>									
						<%				}
									}else
									{	
										if ((coa.getStatus().equals("HEADER")) || ((!coa.getStatus().equals("HEADER")) && DbCoa.getCoaBalance(coa.getOID(),temp,"DC")!=0))
										{	//add detail
											sesReport = new SesReportBs();
											sesReport.setType(coa.getStatus());
											sesReport.setDescription(strTotal1+str1+coa.getCode()+" - "+coa.getName());
											sesReport.setAmount(DbCoa.getCoaBalance(coa.getOID(),temp,"DC"));
											sesReport.setStrAmount(""+DbCoa.getCoaBalance(coa.getOID(),temp,"DC"));
											sesReport.setFont(coa.getStatus().equals("HEADER") ? 1 : 0);											
											vSesDep = new Vector();
											for(int ix=0; ix<temp.size(); ix++){
												Periode per = (Periode)temp.get(ix);													
												vSesDep.add(""+DbCoa.getCoaBalance(coa.getOID(),per,"DC"));
											}
											sesReport.setDepartment(vSesDep);			
											listReport.add(sesReport);
							  %>
                                        <tr> 
                                          <td class="<%=cssString%>" nowrap><%if(coa.getStatus().equals("HEADER")){ %><b><%}%><%=strTotal+str+coa.getCode()+" - "+coa.getName()%><%if(coa.getStatus().equals("HEADER")){ %></b><%}%></td>                                          
										  <%for(int ix=0; ix<temp.size(); ix++){
										  		Periode per = (Periode)temp.get(ix);	
										  %>
											  <td class="<%=cssString%>">
												<table width="100%" border="0" cellpadding="0" cellspacing="1">
												  <tr>
													<td width="5%"></td>													
													
                                                <td width="90%" class="<%=cssString%>" nowrap>
                                                  <div align="right"><%=strDisplay(DbCoa.getCoaBalance(coa.getOID(),per,"DC"),coa.getStatus())%></div></td>
													<td width="5%"></td>
												  </tr>
												</table>
											  </td>
										  <%}%>	
										  <td class="<%=cssString%>">
										    <table width="100%" border="0" cellpadding="0" cellspacing="1">
											  <tr>
											  	<td width="5%"></td>													
												<td width="90%" class="<%=cssString%>" nowrap>
                                                  <div align="right"><%=strDisplay(DbCoa.getCoaBalance(coa.getOID(),temp,"DC"),coa.getStatus())%></div></td>
												<td width="5%"></td>
										  	  </tr>
										  	</table>
										  </td>
                                        </tr>									
					<%					}
									}
								}
							}				//add footer level
											if(DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_OTHER_EXPENSE,temp,"DC")!=0 || valShowList!=1)
											{	//add Group Footer
												sesReport = new SesReportBs();										
												sesReport.setType("Footer Group Level");
												sesReport.setDescription("Total "+I_Project.ACC_GROUP_OTHER_EXPENSE);
												sesReport.setAmount(DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_OTHER_EXPENSE,temp,"DC"));
												sesReport.setStrAmount(""+DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_OTHER_EXPENSE,temp,"DC"));
												sesReport.setFont(1);												
												vSesDep = new Vector();
												for(int ix=0; ix<temp.size(); ix++){
													Periode per = (Periode)temp.get(ix);													
													vSesDep.add(""+DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_OTHER_EXPENSE,"DC",per));
												}
												sesReport.setDepartment(vSesDep);			
												listReport.add(sesReport);								
						%>
                                        <tr> 
                                          <td class="tablecell2"><span class="level2"><b><%="Total "+I_Project.ACC_GROUP_OTHER_EXPENSE%></b></span></td>
										  <%for(int ix=0; ix<temp.size(); ix++){
										  		Periode per = (Periode)temp.get(ix);	
										  %>
											  <td class="tablecell2" align="right">
												<table width="100%" border="0" cellpadding="0" cellspacing="1">
												  <tr>
													<td width="5%"></td>
													
                                                <td width="90%" class="tablecell2" nowrap>
                                                  <div align="right"><b><%=strDisplay(DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_OTHER_EXPENSE,"DC",per),coa.getStatus())%></b></div></td>
													<td width="5%"></td>
												  </tr>
												</table>
											  </td>
										  <%}%>
                                          <td class="tablecell2" align="right">
											<table width="100%" border="0" cellpadding="0" cellspacing="1">
											  <tr>
											  	<td width="5%"></td>
												<td width="90%" class="tablecell2" nowrap>
                                                  <div align="right"><b><%=strDisplay(DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_OTHER_EXPENSE,temp,"DC"),coa.getStatus())%></b></div></td>
												<td width="5%"></td>
											  </tr>
											</table>
										  </td>
										</tr>
					<%
											}	
						}
											if(DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_OTHER_EXPENSE,temp,"DC")!=0 || valShowList!=1)
											{	//add Space
												sesReport = new SesReportBs();										
												sesReport.setType("Space");
												sesReport.setDescription("");
												vSesDep = new Vector();
												for(int ix=0; ix<temp.size(); ix++){
													Periode per = (Periode)temp.get(ix);													
													vSesDep.add("0");
												}
												sesReport.setDepartment(vSesDep);			
												listReport.add(sesReport);																				
					%>
                                        <tr> 
                                          <td class="tablecell1" height="15"></td>
										  <%for(int ix=0; ix<temp.size(); ix++){
										  		Periode per = (Periode)temp.get(ix);	
										  %>
                                          	<td class="tablecell1"></td>
										  <%}%>										  									  										  
                                          <td class="tablecell1"></td>
										</tr>
										<%	}	%>

										<%
											sesReport = new SesReportBs();										
											sesReport.setType("Last Level");
											sesReport.setDescription("Net Income");
											sesReport.setAmount(DbCoa.getNetIncomeByPeriod(temp));
											sesReport.setStrAmount(""+(DbCoa.getNetIncomeByPeriod(temp)));
											sesReport.setFont(1);												
											vSesDep = new Vector();
											for(int ix=0; ix<temp.size(); ix++){
												Periode per = (Periode)temp.get(ix);													
												vSesDep.add(""+DbCoa.getNetIncomeByPeriod(per));
											}
											sesReport.setDepartment(vSesDep);			
											listReport.add(sesReport);								
										%>										
                                        <tr> 
                                          <td class="tablecell2"><span class="level2"><b>Net Income</b></span></td>
										  <%for(int ix=0; ix<temp.size(); ix++){
										  		Periode per = (Periode)temp.get(ix);	
										  %>
											  <td class="tablecell2" align="right">
												<table width="100%" border="0" cellpadding="0" cellspacing="1">
												  <tr>
													<td width="5%"></td>
													
                                                <td width="90%" class="tablecell2" nowrap>
                                                  <div align="right"><b><%=strDisplay(DbCoa.getNetIncomeByPeriod(per),"")%></b></div></td>
													<td width="5%"></td>
												  </tr>
												</table>
											  </td>
										  <%}%>										  
                                          <td class="tablecell2" align="right">
											<table width="100%" border="0" cellpadding="0" cellspacing="1">
											  <tr>
											  	<td width="5%"></td>
												<td width="90%" class="tablecell2" nowrap>
                                                  <div align="right"><b><%=strDisplay(DbCoa.getNetIncomeByPeriod(temp),"")%></b></div></td>
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
								session.putValue("PROFIT_MULTIPLE", listReport);							

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
                                    <td width="60"><a href="javascript:cmdPrintJournal()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('print','','../images/print2.gif',1)"><img src="../images/print.gif" name="print" width="53" height="22" border="0"></a></td>
                                    <td width="0">&nbsp;</td>
                                    <td width="120"><a href="javascript:cmdPrintJournalXLS()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('printxls','','../images/printxls2.gif',1)"><img src="../images/printxls.gif" name="printxls" width="120" height="22" border="0"></a></td>
                                    <td width="20">&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td width="60">&nbsp;</td>
                                    <td width="0">&nbsp;</td>
                                    <td width="120">&nbsp;</td>
                                    <td width="20">&nbsp;</td>
                                  </tr>
                                  <tr>
                                    <td width="60">&nbsp;</td>
                                    <td width="0">&nbsp;</td>
                                    <td width="120">&nbsp;</td>
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
