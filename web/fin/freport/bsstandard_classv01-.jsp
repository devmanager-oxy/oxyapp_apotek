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
////boolean freportPriv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MENU_FINANCEREPROT, AppMenu.M2_MENU_FINANCEREPROT);
%>
<%	
/* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
boolean privAdd=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ADD));
boolean privUpdate=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_UPDATE));
boolean privDelete=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_DELETE));
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
			displayStr = "("+JSPFormater.formatNumber(amount*-1,"#,###")+")";
		else if(amount>0)										
			displayStr = JSPFormater.formatNumber(amount,"#,###");
		else if(amount==0)
			displayStr = "";
		//if(coaStatus.equals("HEADER"))
		//	displayStr = "";
		return displayStr;
	}

%>
<%
	if(session.getValue("BS_STANDARD")!=null){
		session.removeValue("BS_STANDARD");
	}
	
	String grpType = JSPRequestValue.requestString(request, "groupType");
	int iJSPCommand = JSPRequestValue.requestCommand(request);
	int start = JSPRequestValue.requestInt(request, "start");
	int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
	long oidCoa = JSPRequestValue.requestLong(request, "hidden_coa_id");
	String accGroup = JSPRequestValue.requestString(request, "acc_group");
	int valShowList = JSPRequestValue.requestInt(request, "showlist");
	
	int idAccClass = JSPRequestValue.requestInt(request, "id_class");
	
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
	String displayStr = "";																
	double coaSummary1 = 0;
	double coaSummary2 = 0;
	double coaSummary3 = 0;
	double coaSummary4 = 0;
	double coaSummary5 = 0;			
	double coaSummary6 = 0;
	
	String displayStrPrevYear = "";																
	double coaSummary1PrevYear = 0;
	double coaSummary2PrevYear = 0;
	double coaSummary3PrevYear = 0;
	double coaSummary4PrevYear = 0;
	double coaSummary5PrevYear = 0;			
	double coaSummary6PrevYear = 0;
	
	Vector listReport = new Vector();
	SesReportBs sesReport = new SesReportBs();
	
	
	double totalAktiva = 0;
	double totalPasiva = 0;
	
	double totalAktivaPrevYear = 0;
	double totalPasivaPrevYear = 0;
	
		
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
	document.frmcoa.action="bsstandard_classv01.jsp";
	document.frmcoa.submit();
}

function cmdPrintJournal(){	 
	window.open("<%=printroot%>.report.RptBSStandardPDF?oid=<%=appSessUser.getLoginId()%>");
}

function cmdPrintJournalXLS(){	 
	window.open("<%=printroot%>.report.RptBSStandard1XLS?oid=<%=appSessUser.getLoginId()%>&id_class=<%=idAccClass%>");
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
					  String navigator = "<font class=\"lvl1\">Financial Report</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">Neraca Unit</span></font>";
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
						  <input type="hidden" name="id_class" value="<%=idAccClass%>">
						  
                          <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr align="left" valign="top"> 
                              <td height="8"  colspan="3" class="container"> 
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                  <tr align="left"> 
                                    <td height="8" valign="middle" colspan="3"></td>
                                  </tr>                                  
								  <tr align="left"> 
                                    <td width="6%">Show List </td>
									<td width="94%" colspan="2" valign="top"> 
                                      <select name="showlist" onChange="javascript:cmdChangeList()">
										<option value="1" <%if(valShowList==1){%>selected<%}%>>Hide Acc. Without Transaction</option>
										<option value="2" <%if(valShowList==2){%>selected<%}%>>All</option>
									  </select>
									</td>                                  
								  </tr>                          
								  <tr align="left"> 
                                    <td height="20" valign="middle" align="center" colspan="3"><span class="level1"><font size="+1"><b>NERACA 
                                      UNIT <%=(idAccClass==DbCoa.ACCOUNT_CLASS_SP) ? "SIMPAN PINJAM" : "NON SIMPAN PINJAM"%></b></font></span></td>
                                  </tr>                          
								  <%
								  	Periode periode = DbPeriode.getOpenPeriod();
									
									Date dtx = (Date)periode.getStartDate().clone();
									dtx.setYear(dtx.getYear()-1);
									
									String openPeriod = "PER "+JSPFormater.formatDate(dtx, "MMM yyyy")+ " DAN " + JSPFormater.formatDate(periode.getStartDate(), "MMM yyyy");        
									
									//String openPeriod = JSPFormater.formatDate(periode.getStartDate(), "dd MMM yyyy")+ " - " + JSPFormater.formatDate(periode.getEndDate(), "dd MMM yyyy");        
								  %>        
								  <tr align="left"> 
                                    <td height="20" valign="middle" align="center" colspan="3"><span class="level1"><b><font size="3"><%=openPeriod.toUpperCase()%></font></b></span></td>
                                  </tr>         
								                           
								  <tr align="left"> 
                                    <td height="10" valign="middle" colspan="3"></td>
                                  </tr>                                  
                                  <tr align="left"> 
                                    <td height="22" valign="middle" colspan="3" class="page"> 
                                      <table width="100%" border="0" cellpadding="1" height="20" cellspacing="1">
                                        <tr> 
                                          <td width="21%" class="tablehdr" height="22">
                                            <div align="center"><b><font color="#FFFFFF">Description</font></b></div>
                                          </td>
                                          <td width="12%" class="tablehdr" height="22">THN 
										  <%
										  Date xDatex = periode.getStartDate();
										  Date abcDate = (Date)xDatex.clone();
										  abcDate.setYear(abcDate.getYear()-1);
										  %>
										  <%=JSPFormater.formatDate(abcDate, "yyyy")%>
                                          </td>
                                          <td width="12%" class="tablehdr" height="22">THN <%=JSPFormater.formatDate(periode.getStartDate(), "yyyy")%></td>
                                        </tr>
                                        <tr> 
                                          <td width="21%" class="tablecell"><b>Activa</b></td>
                                          <td width="12%" class="tablecell"></td>
                                          <td width="12%" class="tablecell"></td>
                                        </tr>
                                        <!--level Liquid Assets-->
                                        <%	//add Top Header
											sesReport = new SesReportBs();
											sesReport.setType("Top Level");
											sesReport.setDescription("Activa");
											sesReport.setFont(1);											
											listReport.add(sesReport);										
											
											if(DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_LIQUID_ASSET,"DC")!=0 || DbCoa.getCoaBalanceByGroupPrevYear(I_Project.ACC_GROUP_LIQUID_ASSET,"DC")!=0 || valShowList!=1)
											{	//add Group Header
												sesReport = new SesReportBs();										
												sesReport.setType("Group Level");
												sesReport.setDescription(strTotal1+I_Project.ACC_GROUP_LIQUID_ASSET);
												sesReport.setFont(1);												
												listReport.add(sesReport);
										%>
                                        <tr> 
                                          <td width="21%" class="tablecell"><b><%=strTotal+I_Project.ACC_GROUP_LIQUID_ASSET%></b></td>
                                          <td width="12%" class="tablecell"></td>
                                          <td width="12%" class="tablecell"></td>
                                        </tr>
                                        <%	}	%>
                                        <%
						if(listCoa!=null && listCoa.size()>0)
						{
							coaSummary1 = 0;
							coaSummary1PrevYear = 0;
							String str = "";
							String str1 = "";
							for(int i=0; i<listCoa.size(); i++)
							{
								coa = (Coa)listCoa.get(i);
								
								if (coa.getAccountGroup().equals(I_Project.ACC_GROUP_LIQUID_ASSET))
								{
									str = switchLevel(coa.getLevel());
									str1 = switchLevel1(coa.getLevel());
									double amount = 0;//DbCoa.getCoaBalance(coa.getOID());
									double amountPrevYear = 0;
									if (coa.getStatus().equals("HEADER")){
										amount = DbCoa.getCoaBalanceByHeader(coa.getOID(),"DC", idAccClass);
										amountPrevYear = DbCoa.getCoaBalanceByHeaderPrevYear(coa.getOID(),"DC", idAccClass);
									}
									
									coaSummary1 = coaSummary1 + amount;
									coaSummary1PrevYear = coaSummary1PrevYear + amountPrevYear;
									displayStr = strDisplay(amount, coa.getStatus());
									displayStrPrevYear = strDisplay(amountPrevYear, coa.getStatus());
																	
									if (valShowList==1)
									{
										if ((coa.getStatus().equals("HEADER") && amount!=0) 
										|| ((coa.getStatus().equals("HEADER")) && amountPrevYear!=0))
										{	//add detail
											sesReport = new SesReportBs();
											sesReport.setType(coa.getStatus());
											sesReport.setDescription(strTotal1+strTotal1+str1+coa.getCode()+" - "+coa.getName());
											sesReport.setAmount(amount);
											sesReport.setStrAmount(""+amount);
											sesReport.setAmountPrevYear(amountPrevYear);
											sesReport.setStrAmountPrevYear(""+amountPrevYear);
											//sesReport.setFont(coa.getStatus().equals("HEADER") ? 1 : 0);											
											sesReport.setFont(0);											
											listReport.add(sesReport);											
							  %>
                                        <tr> 
                                          <td width="21%" class="<%=cssString%>" nowrap><%=strTotal+strTotal+str+coa.getCode()+" - "+coa.getName()%></td>
                                          <td width="12%" class="<%=cssString%>"> 
                                            <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                              <tr> 
                                                <td width="5%"></td>
                                                <td width="90%" class="<%=cssString%>"> 
                                                  <div align="right"><%=displayStrPrevYear%></div>
                                                </td>
                                                <td width="5%"></td>
                                              </tr>
                                            </table>
                                          </td>
                                          <td width="12%" class="<%=cssString%>"> 
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
										}// end of (coa.getStatus().equals("HEADER") ....
									}else  // (valShowList==1) ...
									{
										if ((coa.getStatus().equals("HEADER")) 
										|| ((coa.getStatus().equals("HEADER")) && amount!=0) 
										|| ((coa.getStatus().equals("HEADER")) && amountPrevYear!=0))
										{	//add detail
											sesReport = new SesReportBs();
											sesReport.setType(coa.getStatus());
											sesReport.setDescription(strTotal1+strTotal1+str1+coa.getCode()+" - "+coa.getName());
											sesReport.setAmount(amount);
											sesReport.setStrAmount(""+amount);
											sesReport.setAmountPrevYear(amountPrevYear);
											sesReport.setStrAmountPrevYear(""+amountPrevYear);
											//sesReport.setFont(coa.getStatus().equals("HEADER") ? 1 : 0);
											sesReport.setFont(0);																						
											listReport.add(sesReport);											
							  %>
                                        <tr> 
                                          <td width="21%" class="<%=cssString%>" nowrap><%=strTotal+strTotal+str+coa.getCode()+" - "+coa.getName()%></td>
                                          <td width="12%" class="<%=cssString%>"> 
                                            <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                              <tr> 
                                                <td width="5%"></td>
                                                <td width="90%" class="<%=cssString%>"> 
                                                  <div align="right"><%=displayStrPrevYear%></div>
                                                </td>
                                                <td width="5%"></td>
                                              </tr>
                                            </table>
                                          </td>
                                          <td width="12%" class="<%=cssString%>"> 
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
								
								if (coaSummary1<0)							
									displayStr = "("+JSPFormater.formatNumber(coaSummary1*-1,"#,###")+")";
								else if (coaSummary1>0)
									displayStr = JSPFormater.formatNumber(coaSummary1,"#,###");
								else if (coaSummary1==0)
									displayStr = "";
								//}
								
								if (coaSummary1PrevYear<0)							
									displayStrPrevYear = "("+JSPFormater.formatNumber(coaSummary1PrevYear*-1,"#,###")+")";
								else if (coaSummary1PrevYear>0)
									displayStrPrevYear = JSPFormater.formatNumber(coaSummary1PrevYear,"#,###");
								else if (coaSummary1PrevYear==0)
									displayStrPrevYear = "";
									
									
									
								}				//add footer level
								
							
								if(DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_LIQUID_ASSET,"DC")!=0 || DbCoa.getCoaBalanceByGroupPrevYear(I_Project.ACC_GROUP_LIQUID_ASSET,"DC")!=0 || valShowList!=1)
								{	//add Group Footer
									sesReport = new SesReportBs();										
									sesReport.setType("Footer Group Level");
									sesReport.setDescription(strTotal1+"Sub Total "+I_Project.ACC_GROUP_LIQUID_ASSET);
									sesReport.setAmount(coaSummary1);
									sesReport.setStrAmount(""+coaSummary1);
									sesReport.setAmountPrevYear(coaSummary1PrevYear);
									sesReport.setStrAmountPrevYear(""+coaSummary1PrevYear);
									sesReport.setFont(1);												
									listReport.add(sesReport);								
						%>
                                        <tr> 
                                          <td width="21%" class="tablecell2"><span class="level2"><b><%=strTotal+"Sub Total "+I_Project.ACC_GROUP_LIQUID_ASSET%></b></span></td>
                                          <td width="11%" class="tablecell2" align="right"> 
                                            <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                              <tr> 
                                                <td width="5%"></td>
                                                <td width="90%" class="tablecell2"> 
                                                  <div align="right"><b><%=displayStrPrevYear%></b></div>
                                                </td>
                                                <td width="5%"></td>
                                              </tr>
                                            </table>
                                          </td>
                                          <td width="11%" class="tablecell2" align="right"> 
                                            <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                              <tr> 
                                                <td width="5%"></td>
                                                <td width="90%" class="tablecell2"> 
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
					%>
                                        <!--level Fix Assets-->
                                        <%	
											if(DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_FIXED_ASSET,"DC")!=0 || DbCoa.getCoaBalanceByGroupPrevYear(I_Project.ACC_GROUP_FIXED_ASSET,"DC")!=0 || valShowList!=1)
											{	//add Group Header
												sesReport = new SesReportBs();										
												sesReport.setType("Group Level");
												sesReport.setDescription(strTotal1+I_Project.ACC_GROUP_FIXED_ASSET);
												sesReport.setFont(1);												
												listReport.add(sesReport);
										%>
                                        <tr> 
                                          <td width="21%" class="tablecell"><b><%=strTotal+I_Project.ACC_GROUP_FIXED_ASSET%></b></td>
                                          <td width="12%" class="tablecell"></td>
                                          <td width="12%" class="tablecell"></td>
                                        </tr>
                                        <%	}	%>
                                        <%
						if(listCoa!=null && listCoa.size()>0)
						{
							coaSummary2 = 0;
							coaSummary2PrevYear = 0;
							String str = "";
							String str1 = "";							
							for(int i=0; i<listCoa.size(); i++)
							{
								coa = (Coa)listCoa.get(i);								
								
								if (coa.getAccountGroup().equals(I_Project.ACC_GROUP_FIXED_ASSET))
								{
									str = switchLevel(coa.getLevel());
									str1 = switchLevel1(coa.getLevel());
									double amount = 0;//DbCoa.getCoaBalance(coa.getOID());
									double amountPrevYear = 0;//DbCoa.getCoaBalance(coa.getOID());
									if (coa.getStatus().equals("HEADER")){
										amount = DbCoa.getCoaBalanceByHeader(coa.getOID(),"DC", idAccClass);
										amountPrevYear = DbCoa.getCoaBalanceByHeaderPrevYear(coa.getOID(),"DC", idAccClass);
									}
									
									coaSummary2 = coaSummary2 + amount;
									displayStr = strDisplay(amount, coa.getStatus());
									
									coaSummary2PrevYear = coaSummary2PrevYear + amountPrevYear;
									displayStrPrevYear = strDisplay(amountPrevYear, coa.getStatus());
									
									if (valShowList==1)
									{
										if ((coa.getStatus().equals("HEADER") && amount!=0) || ((coa.getStatus().equals("HEADER")) && amountPrevYear!=0))
										{	//add detail
											sesReport = new SesReportBs();
											sesReport.setType(coa.getStatus());
											sesReport.setDescription(strTotal1+strTotal1+str1+coa.getCode()+" - "+coa.getName());
											sesReport.setAmount(amount);
											sesReport.setStrAmount(""+amount);
											sesReport.setAmountPrevYear(amountPrevYear);
											sesReport.setStrAmountPrevYear(""+amountPrevYear);
											//sesReport.setFont(coa.getStatus().equals("HEADER") ? 1 : 0);											
											sesReport.setFont(0);																						
											listReport.add(sesReport);											
							  %>
                                        <tr> 
                                          <td width="21%" class="<%=cssString%>" nowrap><%=strTotal+strTotal+str+coa.getCode()+" - "+coa.getName()%></td>
                                          <td width="12%" class="<%=cssString%>"> 
                                            <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                              <tr> 
                                                <td width="5%"></td>
                                                <td width="90%" class="<%=cssString%>"> 
                                                  <div align="right"><%=displayStrPrevYear%></div>
                                                </td>
                                                <td width="5%"></td>
                                              </tr>
                                            </table>
                                          </td>
                                          <td width="12%" class="<%=cssString%>"> 
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
										if ((coa.getStatus().equals("HEADER")) || ((coa.getStatus().equals("HEADER")) && amount!=0) || ((coa.getStatus().equals("HEADER")) && amountPrevYear!=0))
										{	//add detail
											sesReport = new SesReportBs();
											sesReport.setType(coa.getStatus());
											sesReport.setDescription(strTotal1+strTotal1+str1+coa.getCode()+" - "+coa.getName());
											sesReport.setAmount(amount);
											sesReport.setStrAmount(""+amount);
											sesReport.setAmountPrevYear(amountPrevYear);
											sesReport.setStrAmountPrevYear(""+amountPrevYear);
											//sesReport.setFont(coa.getStatus().equals("HEADER") ? 1 : 0);											
											sesReport.setFont(0);																						
											listReport.add(sesReport);																				
							  %>
                                        <tr> 
                                          <td width="21%" class="<%=cssString%>" nowrap><%=strTotal+strTotal+str+coa.getCode()+" - "+coa.getName()%></td>
                                          <td width="12%" class="<%=cssString%>"> 
                                            <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                              <tr> 
                                                <td width="5%"></td>
                                                <td width="90%" class="<%=cssString%>"> 
                                                  <div align="right"><%=displayStrPrevYear%></div>
                                                </td>
                                                <td width="5%"></td>
                                              </tr>
                                            </table>
                                          </td>
                                          <td width="12%" class="<%=cssString%>"> 
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
								
								if (coaSummary2<0)							
									displayStr = "("+JSPFormater.formatNumber(coaSummary2*-1,"#,###")+")";
								else if (coaSummary2>0)
									displayStr = JSPFormater.formatNumber(coaSummary2,"#,###");
								else if (coaSummary2==0)
									displayStr = "";
								//}				//add footer level
								
								if (coaSummary2PrevYear<0)							
									displayStrPrevYear = "("+JSPFormater.formatNumber(coaSummary2PrevYear*-1,"#,###")+")";
								else if (coaSummary2PrevYear>0)
									displayStrPrevYear = JSPFormater.formatNumber(coaSummary2PrevYear,"#,###");
								else if (coaSummary2PrevYear==0)
									displayStrPrevYear = "";
									
									
									
								}				//add footer level
								
								
								if(DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_FIXED_ASSET,"DC")!=0 || DbCoa.getCoaBalanceByGroupPrevYear(I_Project.ACC_GROUP_FIXED_ASSET,"DC")!=0 || valShowList!=1)
								{	//add Group Footer
									sesReport = new SesReportBs();										
									sesReport.setType("Footer Group Level");
									sesReport.setDescription(strTotal1+"Sub Total "+I_Project.ACC_GROUP_FIXED_ASSET);
									sesReport.setAmount(coaSummary2);
									sesReport.setStrAmount(""+coaSummary2);
									sesReport.setAmountPrevYear(coaSummary2PrevYear);
									sesReport.setStrAmountPrevYear(""+coaSummary2PrevYear);
									sesReport.setFont(1);												
									listReport.add(sesReport);								
						%>
                                        <tr> 
                                          <td width="21%" class="tablecell2"><span class="level2"><b><%=strTotal+" Sub Total "+I_Project.ACC_GROUP_FIXED_ASSET%></b></span></td>
                                          <td width="11%" class="tablecell2" align="right"> 
                                            <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                              <tr> 
                                                <td width="5%"></td>
                                                <td width="90%" class="tablecell2"> 
                                                  <div align="right"><b><%=displayStrPrevYear%></b></div>
                                                </td>
                                                <td width="5%"></td>
                                              </tr>
                                            </table>
                                          </td>
                                          <td width="11%" class="tablecell2" align="right"> 
                                            <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                              <tr> 
                                                <td width="5%"></td>
                                                <td width="90%" class="tablecell2"> 
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
					%>
                                        <!--level Other Assets-->
                                        <%	
											if(DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_OTHER_ASSET,"DC")!=0 || DbCoa.getCoaBalanceByGroupPrevYear(I_Project.ACC_GROUP_OTHER_ASSET,"DC")!=0 || valShowList!=1)
											{	//add Group Header
												sesReport = new SesReportBs();										
												sesReport.setType("Group Level");
												sesReport.setDescription(strTotal1+I_Project.ACC_GROUP_OTHER_ASSET);
												sesReport.setFont(1);												
												listReport.add(sesReport);
										%>
                                        <tr> 
                                          <td width="21%" class="tablecell"><b><%=strTotal+I_Project.ACC_GROUP_OTHER_ASSET%></b></td>
                                          <td width="12%" class="tablecell"></td>
                                          <td width="12%" class="tablecell"></td>
                                        </tr>
                                        <% 	}	%>
                                        <%
						if(listCoa!=null && listCoa.size()>0)
						{
							coaSummary3 = 0;
							coaSummary3PrevYear = 0;
							String str = "";
							String str1 = "";							
							for(int i=0; i<listCoa.size(); i++)
							{
								coa = (Coa)listCoa.get(i);								
								
								if (coa.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_ASSET))
								{
									str = switchLevel(coa.getLevel());
									str1 = switchLevel1(coa.getLevel());
									double amount = 0;//DbCoa.getCoaBalance(coa.getOID());
									double amountPrevYear = 0;//DbCoa.getCoaBalance(coa.getOID());
									if (coa.getStatus().equals("HEADER")){
										amount = DbCoa.getCoaBalanceByHeader(coa.getOID(),"DC", idAccClass);
										amountPrevYear = DbCoa.getCoaBalanceByHeaderPrevYear(coa.getOID(),"DC", idAccClass);
									}
									
									coaSummary3 = coaSummary3 + amount;
									displayStr = strDisplay(amount, coa.getStatus());								
									
									coaSummary3PrevYear = coaSummary3PrevYear + amountPrevYear;
									displayStrPrevYear = strDisplay(amountPrevYear, coa.getStatus());								
									
									if (valShowList==1)
									{
										if ((coa.getStatus().equals("HEADER") && amount!=0) || ((coa.getStatus().equals("HEADER")) && amountPrevYear!=0))
										{	//add detail
											sesReport = new SesReportBs();
											sesReport.setType(coa.getStatus());
											sesReport.setDescription(strTotal1+strTotal1+str1+coa.getCode()+" - "+coa.getName());
											sesReport.setAmount(amount);
											sesReport.setStrAmount(""+amount);
											sesReport.setAmountPrevYear(amountPrevYear);
											sesReport.setStrAmountPrevYear(""+amountPrevYear);
											//sesReport.setFont(coa.getStatus().equals("HEADER") ? 1 : 0);
											sesReport.setFont(0);																																	
											listReport.add(sesReport);											
							  %>
                                        <tr> 
                                          <td width="21%" class="<%=cssString%>" nowrap><%=strTotal+strTotal+str+coa.getCode()+" - "+coa.getName()%></td>
                                          <td width="12%" class="<%=cssString%>"> 
                                            <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                              <tr> 
                                                <td width="5%"></td>
                                                <td width="90%" class="<%=cssString%>"> 
                                                  <div align="right"><%=displayStrPrevYear%></div>
                                                </td>
                                                <td width="5%"></td>
                                              </tr>
                                            </table>
                                          </td>
                                          <td width="12%" class="<%=cssString%>"> 
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
										if ((coa.getStatus().equals("HEADER")) || ((coa.getStatus().equals("HEADER")) && amount!=0) || ((coa.getStatus().equals("HEADER")) && amountPrevYear!=0))
										{	//add detail
											sesReport = new SesReportBs();
											sesReport.setType(coa.getStatus());
											sesReport.setDescription(strTotal1+strTotal1+str1+coa.getCode()+" - "+coa.getName());
											sesReport.setAmount(amount);
											sesReport.setStrAmount(""+amount);
											sesReport.setAmountPrevYear(amountPrevYear);
											sesReport.setStrAmountPrevYear(""+amountPrevYear);
											//sesReport.setFont(coa.getStatus().equals("HEADER") ? 1 : 0);											
											sesReport.setFont(0);																						
											listReport.add(sesReport);											
							  %>
                                        <tr> 
                                          <td width="21%" class="<%=cssString%>" nowrap><%=strTotal+strTotal+str+coa.getCode()+" - "+coa.getName()%></td>
                                          <td width="12%" class="<%=cssString%>"> 
                                            <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                              <tr> 
                                                <td width="5%"></td>
                                                <td width="90%" class="<%=cssString%>"> 
                                                  <div align="right"><%=displayStrPrevYear%></div>
                                                </td>
                                                <td width="5%"></td>
                                              </tr>
                                            </table>
                                          </td>
                                          <td width="12%" class="<%=cssString%>"> 
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
									displayStr = "("+JSPFormater.formatNumber(coaSummary3*-1,"#,###")+")";
								else if (coaSummary3>0)
									displayStr = JSPFormater.formatNumber(coaSummary3,"#,###");
								else if (coaSummary3==0)
									displayStr = "";
								//}				//add footer level
								
								if (coaSummary3PrevYear<0)							
									displayStrPrevYear = "("+JSPFormater.formatNumber(coaSummary3PrevYear*-1,"#,###")+")";
								else if (coaSummary3PrevYear>0)
									displayStrPrevYear = JSPFormater.formatNumber(coaSummary3PrevYear,"#,###");
								else if (coaSummary3PrevYear==0)
									displayStrPrevYear = "";
									
									
									
								}				//add footer level
								
								if(DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_OTHER_ASSET,"DC")!=0 || DbCoa.getCoaBalanceByGroupPrevYear(I_Project.ACC_GROUP_OTHER_ASSET,"DC")!=0 || valShowList!=1)
								{	//add Group Footer
									sesReport = new SesReportBs();										
									sesReport.setType("Footer Group Level");
									sesReport.setDescription(strTotal1+"Sub Total "+I_Project.ACC_GROUP_OTHER_ASSET);
									sesReport.setAmount(coaSummary3);
									sesReport.setStrAmount(""+coaSummary3);
									sesReport.setAmountPrevYear(coaSummary3PrevYear);
									sesReport.setStrAmountPrevYear(""+coaSummary3PrevYear);
									sesReport.setFont(1);												
									listReport.add(sesReport);								
						%>
                                        <tr> 
                                          <td width="21%" class="tablecell2"><span class="level2"><b><%=strTotal+" Sub Total "+I_Project.ACC_GROUP_OTHER_ASSET%></b></span></td>
                                          <td width="11%" class="tablecell2" align="right"> 
                                            <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                              <tr> 
                                                <td width="5%"></td>
                                                <td width="90%" class="tablecell2"> 
                                                  <div align="right"><b><%=displayStrPrevYear%></b></div>
                                                </td>
                                                <td width="5%"></td>
                                              </tr>
                                            </table>
                                          </td>
                                          <td width="11%" class="tablecell2" align="right"> 
                                            <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                              <tr> 
                                                <td width="5%"></td>
                                                <td width="90%" class="tablecell2"> 
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
						
						
											totalAktiva = coaSummary1+coaSummary2+coaSummary3;
											totalAktivaPrevYear = coaSummary1PrevYear+coaSummary2PrevYear+coaSummary3PrevYear;
											
											//out.println("totalAktiva : "+totalAktiva);
											
											if (coaSummary1+coaSummary2+coaSummary3<0){							
												displayStr = "("+JSPFormater.formatNumber((coaSummary1+coaSummary2+coaSummary3)*-1,"#,###")+")";
											}
											else if (coaSummary1+coaSummary2+coaSummary3>0){
												displayStr = JSPFormater.formatNumber((coaSummary1+coaSummary2+coaSummary3),"#,###");						
											}
											else if (coaSummary1+coaSummary2+coaSummary3==0){
												displayStr = "";
											}
											
											if (coaSummary1PrevYear+coaSummary2PrevYear+coaSummary3PrevYear<0){							
												displayStrPrevYear = "("+JSPFormater.formatNumber((coaSummary1PrevYear+coaSummary2PrevYear+coaSummary3PrevYear)*-1,"#,###")+")";
											}
											else if (coaSummary1PrevYear+coaSummary2PrevYear+coaSummary3PrevYear>0){
												displayStrPrevYear = JSPFormater.formatNumber((coaSummary1PrevYear+coaSummary2PrevYear+coaSummary3PrevYear),"#,###");						
											}
											else if (coaSummary1PrevYear+coaSummary2PrevYear+coaSummary3PrevYear==0){
												displayStrPrevYear = "";
											}
											
											//add footer level
											if(coaSummary1+coaSummary2+coaSummary3!=0 || coaSummary1PrevYear+coaSummary2PrevYear+coaSummary3PrevYear!=0 || valShowList!=1)
											{	//add Group Footer
												sesReport = new SesReportBs();										
												sesReport.setType("Footer Top Level");
												sesReport.setDescription("Total Activa");
												sesReport.setAmount(coaSummary1+coaSummary2+coaSummary3);
												sesReport.setStrAmount(""+(coaSummary1+coaSummary2+coaSummary3));
												sesReport.setAmountPrevYear(coaSummary1PrevYear+coaSummary2PrevYear+coaSummary3PrevYear);
												sesReport.setStrAmountPrevYear(""+(coaSummary1PrevYear+coaSummary2PrevYear+coaSummary3PrevYear));
												sesReport.setFont(1);												
												listReport.add(sesReport);								
					%>
                                        <tr> 
                                          <td width="21%" class="tablecell2"><span class="level2"><b>Total 
                                            Activa</b></span></td>
                                          <td width="11%" class="tablecell2" align="right"> 
                                            <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                              <tr> 
                                                <td width="5%"></td>
                                                <td width="90%" class="tablecell2"><span class="level2"> 
                                                  <div align="right"><b><%=displayStrPrevYear%></b></div>
                                                  </span></td>
                                                <td width="5%"></td>
                                              </tr>
                                            </table>
                                          </td>
                                          <td width="11%" class="tablecell2" align="right"> 
                                            <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                              <tr> 
                                                <td width="5%"></td>
                                                <td width="90%" class="tablecell2"><span class="level2"> 
                                                  <div align="right"><b><%=displayStr%></b></div>
                                                  </span></td>
                                                <td width="5%"></td>
                                              </tr>
                                            </table>
                                          </td>
                                          <%	
										  		}
												sesReport = new SesReportBs();										
												sesReport.setType("Space");
												sesReport.setDescription("");
												listReport.add(sesReport);									
										  %>
                                        </tr>
                                        <tr> 
                                          <td width="21%" class="tablecell1" height="15"></td>
                                          <td width="11%" class="tablecell1"></td>
                                          <td width="11%" class="tablecell1"></td>
                                        </tr>
                                        <!--level 2-->
                                        <tr> 
                                          <td width="21%" class="tablecell"><b>Liabilities</b></td>
                                          <td width="12%" class="tablecell"></td>
                                          <td width="12%" class="tablecell"></td>
                                        </tr>
                                        <!--level current liabilities-->
                                        <%	//add Top Header
											sesReport = new SesReportBs();
											sesReport.setType("Top Level");
											sesReport.setDescription("Liabilities");
											sesReport.setFont(1);											
											listReport.add(sesReport);										
											
											if(DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_CURRENT_LIABILITIES,"CD")!=0 || DbCoa.getCoaBalanceByGroupPrevYear(I_Project.ACC_GROUP_CURRENT_LIABILITIES,"CD")!=0 || valShowList!=1)
											{	//add Group Header
												sesReport = new SesReportBs();										
												sesReport.setType("Group Level");
												sesReport.setDescription(strTotal1+I_Project.ACC_GROUP_CURRENT_LIABILITIES);
												sesReport.setFont(1);												
												listReport.add(sesReport);
										%>
                                        <tr> 
                                          <td width="21%" class="tablecell"><b><%=strTotal+I_Project.ACC_GROUP_CURRENT_LIABILITIES%></b></td>
                                          <td width="12%" class="tablecell"></td>
                                          <td width="12%" class="tablecell"></td>
                                        </tr>
                                        <%	}	%>
                                        <%
						if(listCoa!=null && listCoa.size()>0)
						{
							coaSummary4 = 0;
							coaSummary4PrevYear = 0;
							String str = "";
							String str1 = "";							
							for(int i=0; i<listCoa.size(); i++)
							{
								coa = (Coa)listCoa.get(i);								
								
								if (coa.getAccountGroup().equals(I_Project.ACC_GROUP_CURRENT_LIABILITIES))
								{
									str = switchLevel(coa.getLevel());
									str1 = switchLevel1(coa.getLevel());
									double amount = 0;//DbCoa.getCoaBalanceCD(coa.getOID());
									double amountPrevYear = 0;//DbCoa.getCoaBalanceCD(coa.getOID());
									if (coa.getStatus().equals("HEADER")){
										amount = DbCoa.getCoaBalanceByHeader(coa.getOID(),"CD", idAccClass);
										amountPrevYear = DbCoa.getCoaBalanceByHeaderPrevYear(coa.getOID(),"CD", idAccClass);
									}
									
									coaSummary4 = coaSummary4 + amount;
									displayStr = strDisplay(amount, coa.getStatus());
									coaSummary4PrevYear = coaSummary4PrevYear + amountPrevYear;
									displayStrPrevYear = strDisplay(amountPrevYear, coa.getStatus());
									
									if (valShowList==1)
									{
										if ((coa.getStatus().equals("HEADER") && amount!=0) || (coa.getStatus().equals("HEADER") && amountPrevYear!=0) || ((!coa.getStatus().equals("HEADER")) && amount!=0))
										{	//add detail
											sesReport = new SesReportBs();
											sesReport.setType(coa.getStatus());
											sesReport.setDescription(strTotal1+strTotal1+str1+coa.getCode()+" - "+coa.getName());
											sesReport.setAmount(amount);
											sesReport.setStrAmount(""+amount);
											sesReport.setAmountPrevYear(amountPrevYear);
											sesReport.setStrAmountPrevYear(""+amountPrevYear);
											//sesReport.setFont(coa.getStatus().equals("HEADER") ? 1 : 0);											
											sesReport.setFont(0);																						
											listReport.add(sesReport);											
							  %>
                                        <tr> 
                                          <td width="21%" class="<%=cssString%>" nowrap><%=strTotal+strTotal+str+coa.getCode()+" - "+coa.getName()%></td>
                                          <td width="12%" class="<%=cssString%>"> 
                                            <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                              <tr> 
                                                <td width="5%"></td>
                                                <td width="90%" class="<%=cssString%>"> 
                                                  <div align="right"><%=displayStrPrevYear%></div>
                                                </td>
                                                <td width="5%"></td>
                                              </tr>
                                            </table>
                                          </td>
                                          <td width="12%" class="<%=cssString%>"> 
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
										if ((coa.getStatus().equals("HEADER")) || ((!coa.getStatus().equals("HEADER")) && amount!=0) || ((!coa.getStatus().equals("HEADER")) && amountPrevYear!=0))
										{	//add detail
											sesReport = new SesReportBs();
											sesReport.setType(coa.getStatus());
											sesReport.setDescription(strTotal1+strTotal1+str1+coa.getCode()+" - "+coa.getName());
											sesReport.setAmount(amount);
											sesReport.setStrAmount(""+amount);
											sesReport.setAmountPrevYear(amountPrevYear);
											sesReport.setStrAmountPrevYear(""+amountPrevYear);
											//sesReport.setFont(coa.getStatus().equals("HEADER") ? 1 : 0);											
											sesReport.setFont(0);																						
											listReport.add(sesReport);											
							  %>
                                        <tr> 
                                          <td width="21%" class="<%=cssString%>" nowrap><%=strTotal+strTotal+str+coa.getCode()+" - "+coa.getName()%></td>
                                          <td width="12%" class="<%=cssString%>"> 
                                            <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                              <tr> 
                                                <td width="5%"></td>
                                                <td width="90%" class="<%=cssString%>"> 
                                                  <div align="right"><%=displayStrPrevYear%></div>
                                                </td>
                                                <td width="5%"></td>
                                              </tr>
                                            </table>
                                          </td>
                                          <td width="12%" class="<%=cssString%>"> 
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
									displayStr = "("+JSPFormater.formatNumber(coaSummary4*-1,"#,###")+")";
								else if (coaSummary4<0)
									displayStr = JSPFormater.formatNumber(coaSummary4,"#,###");
								else if (coaSummary4==0)
									displayStr = "";
												//add footer level
								
								if (coaSummary4PrevYear<0)							
									displayStrPrevYear = "("+JSPFormater.formatNumber(coaSummary4PrevYear*-1,"#,###")+")";
								else if (coaSummary4PrevYear<0)
									displayStrPrevYear = JSPFormater.formatNumber(coaSummary4PrevYear,"#,###");
								else if (coaSummary4PrevYear==0)
									displayStrPrevYear = "";
								
								}				//add footer level
								
								
								if(DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_CURRENT_LIABILITIES,"CD")!=0 || DbCoa.getCoaBalanceByGroupPrevYear(I_Project.ACC_GROUP_CURRENT_LIABILITIES,"CD")!=0  || valShowList!=1)
								{	//add Group Footer
									sesReport = new SesReportBs();										
									sesReport.setType("Footer Group Level");
									sesReport.setDescription(strTotal1+"Sub Total "+I_Project.ACC_GROUP_CURRENT_LIABILITIES);
									sesReport.setAmount(coaSummary4);
									sesReport.setStrAmount(""+coaSummary4);
									sesReport.setAmountPrevYear(coaSummary4PrevYear);
									sesReport.setStrAmountPrevYear(""+coaSummary4PrevYear);
									sesReport.setFont(1);												
									listReport.add(sesReport);								
						%>
                                        <tr> 
                                          <td width="21%" class="tablecell2"><span class="level2"><b><%=strTotal+" Sub Total "+I_Project.ACC_GROUP_CURRENT_LIABILITIES%></b></span></td>
                                          <td width="11%" class="tablecell2" align="right"> 
                                            <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                              <tr> 
                                                <td width="5%"></td>
                                                <td width="90%" class="tablecell2"> 
                                                  <div align="right"><b><%=displayStrPrevYear%></b></div>
                                                </td>
                                                <td width="5%"></td>
                                              </tr>
                                            </table>
                                          </td>
                                          <td width="11%" class="tablecell2" align="right"> 
                                            <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                              <tr> 
                                                <td width="5%"></td>
                                                <td width="90%" class="tablecell2"> 
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
					%>
                                        <!--level Long term liabilities-->
                                        <%
											if(DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_LONG_TERM_LIABILITIES,"CD")!=0 || DbCoa.getCoaBalanceByGroupPrevYear(I_Project.ACC_GROUP_LONG_TERM_LIABILITIES,"CD")!=0 || valShowList!=1)
											{	//add Group Header
												sesReport = new SesReportBs();										
												sesReport.setType("Group Level");
												sesReport.setDescription(strTotal1+I_Project.ACC_GROUP_LONG_TERM_LIABILITIES);
												sesReport.setFont(1);												
												listReport.add(sesReport);
										%>
                                        <tr> 
                                          <td width="21%" class="tablecell"><b><%=strTotal+I_Project.ACC_GROUP_LONG_TERM_LIABILITIES%></b></td>
                                          <td width="12%" class="tablecell"></td>
                                          <td width="12%" class="tablecell"></td>
                                        </tr>
                                        <%	}	%>
                                        <%
						if(listCoa!=null && listCoa.size()>0)
						{
							coaSummary5 = 0;
							coaSummary5PrevYear = 0;
							String str = "";
							String str1 = "";							
							for(int i=0; i<listCoa.size(); i++)
							{
								coa = (Coa)listCoa.get(i);								
								
								if (coa.getAccountGroup().equals(I_Project.ACC_GROUP_LONG_TERM_LIABILITIES))
								{
									str = switchLevel(coa.getLevel());
									str1 = switchLevel1(coa.getLevel());
									double amount = 0;//DbCoa.getCoaBalanceCD(coa.getOID());
									double amountPrevYear = 0;//DbCoa.getCoaBalanceCD(coa.getOID());
									if (coa.getStatus().equals("HEADER")){
										amount = DbCoa.getCoaBalanceByHeader(coa.getOID(),"CD", idAccClass);
										amountPrevYear = DbCoa.getCoaBalanceByHeaderPrevYear(coa.getOID(),"CD", idAccClass);
									}
									
									coaSummary5 = coaSummary5 + amount;
									displayStr = strDisplay(amount, coa.getStatus());
									coaSummary5PrevYear = coaSummary5PrevYear + amountPrevYear;
									displayStrPrevYear = strDisplay(amountPrevYear, coa.getStatus());
									
									if (valShowList==1)
									{
										if ((coa.getStatus().equals("HEADER") && amount!=0) || ((coa.getStatus().equals("HEADER")) && amountPrevYear!=0))
										{	//add detail
											sesReport = new SesReportBs();
											sesReport.setType(coa.getStatus());
											sesReport.setDescription(strTotal1+strTotal1+str1+coa.getCode()+" - "+coa.getName());
											sesReport.setAmount(amount);
											sesReport.setStrAmount(""+amount);
											sesReport.setAmountPrevYear(amountPrevYear);
											sesReport.setStrAmountPrevYear(""+amountPrevYear);
											//sesReport.setFont(coa.getStatus().equals("HEADER") ? 1 : 0);											
											sesReport.setFont(0);																						
											listReport.add(sesReport);											
							  %>
                                        <tr> 
                                          <td width="21%" class="<%=cssString%>" nowrap><%=strTotal+strTotal+str+coa.getCode()+" - "+coa.getName()%></td>
                                          <td width="12%" class="<%=cssString%>"> 
                                            <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                              <tr> 
                                                <td width="5%"></td>
                                                <td width="90%" class="<%=cssString%>"> 
                                                  <div align="right"><%=displayStrPrevYear%></div>
                                                </td>
                                                <td width="5%"></td>
                                              </tr>
                                            </table>
                                          </td>
                                          <td width="12%" class="<%=cssString%>"> 
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
										if ((coa.getStatus().equals("HEADER")) || ((coa.getStatus().equals("HEADER")) && amount!=0) || ((coa.getStatus().equals("HEADER")) && amountPrevYear!=0))
										{	//add detail
											sesReport = new SesReportBs();
											sesReport.setType(coa.getStatus());
											sesReport.setDescription(strTotal1+strTotal1+str1+coa.getCode()+" - "+coa.getName());
											sesReport.setAmount(amount);
											sesReport.setStrAmount(""+amount);
											sesReport.setAmountPrevYear(amountPrevYear);
											sesReport.setStrAmountPrevYear(""+amountPrevYear);
											//sesReport.setFont(coa.getStatus().equals("HEADER") ? 1 : 0);											
											sesReport.setFont(0);																						
											listReport.add(sesReport);											
							  %>
                                        <tr> 
                                          <td width="21%" class="<%=cssString%>" nowrap><%=strTotal+strTotal+str+coa.getCode()+" - "+coa.getName()%></td>
                                          <td width="12%" class="<%=cssString%>"> 
                                            <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                              <tr> 
                                                <td width="5%"></td>
                                                <td width="90%" class="<%=cssString%>"> 
                                                  <div align="right"><%=displayStrPrevYear%></div>
                                                </td>
                                                <td width="5%"></td>
                                              </tr>
                                            </table>
                                          </td>
                                          <td width="12%" class="<%=cssString%>"> 
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
									displayStr = "("+JSPFormater.formatNumber(coaSummary5*-1,"#,###")+")";
								else if (coaSummary5>0)
									displayStr = JSPFormater.formatNumber(coaSummary5,"#,###");
								else if (coaSummary5==0)
									displayStr = "";
												//add footer level
								
								if (coaSummary5PrevYear<0)							
									displayStrPrevYear = "("+JSPFormater.formatNumber(coaSummary5PrevYear*-1,"#,###")+")";
								else if (coaSummary5PrevYear>0)
									displayStrPrevYear = JSPFormater.formatNumber(coaSummary5PrevYear,"#,###");
								else if (coaSummary5PrevYear==0)
									displayStrPrevYear = "";
								
								}				//add footer level
								
								if(DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_LONG_TERM_LIABILITIES,"CD")!=0 || DbCoa.getCoaBalanceByGroupPrevYear(I_Project.ACC_GROUP_LONG_TERM_LIABILITIES,"CD")!=0 || valShowList!=1)
								{	//add Group Footer
									sesReport = new SesReportBs();										
									sesReport.setType("Footer Group Level");
									sesReport.setDescription(strTotal1+"Sub Total "+I_Project.ACC_GROUP_LONG_TERM_LIABILITIES);
									sesReport.setAmount(coaSummary5);
									sesReport.setStrAmount(""+coaSummary5);
									sesReport.setAmountPrevYear(coaSummary5PrevYear);
									sesReport.setStrAmountPrevYear(""+coaSummary5PrevYear);
									sesReport.setFont(1);												
									listReport.add(sesReport);																
						%>
                                        <tr> 
                                          <td width="21%" class="tablecell2"><span class="level2"><b><%=strTotal+" Sub Total "+I_Project.ACC_GROUP_LONG_TERM_LIABILITIES%></b></span></td>
                                          <td width="11%" class="tablecell2" align="right"> 
                                            <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                              <tr> 
                                                <td width="5%"></td>
                                                <td width="90%" class="tablecell2"> 
                                                  <div align="right"><b><%=displayStrPrevYear%></b></div>
                                                </td>
                                                <td width="5%"></td>
                                              </tr>
                                            </table>
                                          </td>
                                          <td width="11%" class="tablecell2" align="right"> 
                                            <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                              <tr> 
                                                <td width="5%"></td>
                                                <td width="90%" class="tablecell2"> 
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
										
										if (coaSummary4+coaSummary5<0)
											displayStr = "("+JSPFormater.formatNumber((coaSummary4+coaSummary5)*-1,"#,###")+")";
										else if (coaSummary4+coaSummary5>0)
											displayStr = JSPFormater.formatNumber(coaSummary4+coaSummary5,"#,###");						
										else if (coaSummary4+coaSummary5==0)
											displayStr = "";
											
										if (coaSummary4PrevYear+coaSummary5PrevYear<0)
											displayStrPrevYear = "("+JSPFormater.formatNumber((coaSummary4PrevYear+coaSummary5PrevYear)*-1,"#,###")+")";
										else if (coaSummary4PrevYear+coaSummary5PrevYear>0)
											displayStrPrevYear = JSPFormater.formatNumber(coaSummary4PrevYear+coaSummary5PrevYear,"#,###");						
										else if (coaSummary4PrevYear+coaSummary5PrevYear==0)
											displayStrPrevYear = "";
												
															//add footer level
										if(coaSummary4+coaSummary5!=0 || coaSummary4PrevYear+coaSummary5PrevYear!=0 || valShowList!=1)
										{	//add Group Footer
											sesReport = new SesReportBs();										
											sesReport.setType("Footer Top Level");
											sesReport.setDescription("Total Liabilities");
											sesReport.setAmount(coaSummary4+coaSummary5);
											sesReport.setStrAmount(""+(coaSummary4+coaSummary5));
											sesReport.setAmountPrevYear(coaSummary4PrevYear+coaSummary5PrevYear);
											sesReport.setStrAmountPrevYear(""+(coaSummary4PrevYear+coaSummary5PrevYear));
											sesReport.setFont(1);												
											listReport.add(sesReport);														
									%>
                                        <tr> 
                                          <td width="21%" class="tablecell2"><span class="level2"><b>Total 
                                            Liabilities</b></span></td>
                                          <td width="11%" class="tablecell2" align="right"> 
                                            <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                              <tr> 
                                                <td width="5%"></td>
                                                <td width="90%" class="tablecell2"> 
                                                  <div align="right"><b><%=displayStrPrevYear%></b></div>
                                                </td>
                                                <td width="5%"></td>
                                              </tr>
                                            </table>
                                          </td>
                                          <td width="11%" class="tablecell2" align="right"> 
                                            <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                              <tr> 
                                                <td width="5%"></td>
                                                <td width="90%" class="tablecell2"> 
                                                  <div align="right"><b><%=displayStr%></b></div>
                                                </td>
                                                <td width="5%"></td>
                                              </tr>
                                            </table>
                                          </td>
                                        </tr>
                                        <%	}	%>
                                        <!--level 3-->
                                        <tr> 
                                          <td width="21%" class="tablecell"><b>Equity</b></td>
                                          <td width="12%" class="tablecell"></td>
                                          <td width="12%" class="tablecell"></td>
                                        </tr>
                                        <!--level equity-->
                                        <%	//add Top Header
											sesReport = new SesReportBs();
											sesReport.setType("Top Level");
											sesReport.setDescription("Equity");
											sesReport.setFont(1);											
											listReport.add(sesReport);										
											
											if((DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_EQUITY,"CD") + DbCoaOpeningBalance.getSumOpeningBalance())!=0 
											|| (DbCoa.getCoaBalanceByGroupPrevYear(I_Project.ACC_GROUP_EQUITY,"CD") + DbCoaOpeningBalance.getSumOpeningBalancePrevYear())!=0
											|| valShowList!=1)
											{	//add Group Header
												sesReport = new SesReportBs();										
												sesReport.setType("Group Level");
												sesReport.setDescription(strTotal1+I_Project.ACC_GROUP_EQUITY);
												sesReport.setFont(1);												
												listReport.add(sesReport);
										%>
                                        <tr> 
                                          <td width="21%" class="tablecell"><b><%=strTotal+I_Project.ACC_GROUP_EQUITY%></b></td>
                                          <td width="12%" class="tablecell"></td>
                                          <td width="12%" class="tablecell"></td>
                                        </tr>
                                        <%	}	%>
                                        <%
								if(listCoa!=null && listCoa.size()>0)
								{
									coaSummary6 = 0;
									coaSummary6PrevYear = 0;
									String str = "";
									String str1 = "";							
									for(int i=0; i<listCoa.size(); i++)
									{
										coa = (Coa)listCoa.get(i);								
										
										if (coa.getAccountGroup().equals(I_Project.ACC_GROUP_EQUITY))
										{
											
											//out.println("-- in equity");
											
											str = switchLevel(coa.getLevel());
											str1 = switchLevel1(coa.getLevel());
											double amount = 0;//DbCoa.getCoaBalanceCD(coa.getOID());
											double amountPrevYear = 0;//DbCoa.getCoaBalanceCD(coa.getOID());
											if (coa.getStatus().equals("HEADER") 
											//&& !coa.getCode().equals(DbSystemProperty.getValueByName("ID_HEADER_RETAINED_EARNING"))
											&& !coa.getCode().equals(DbSystemProperty.getValueByName("ID_HEADER_CURRENT_EARNING"))											
											){
												//amount = DbCoa.getCoaBalanceByHeader(coa.getOID(),"DC", idAccClass);																				
												//amountPrevYear = DbCoa.getCoaBalanceByHeaderPrevYear(coa.getOID(),"DC", idAccClass);
												amount = DbCoa.getCoaBalanceByHeader(coa.getOID(),"CD", idAccClass);																				
												amountPrevYear = DbCoa.getCoaBalanceByHeaderPrevYear(coa.getOID(),"CD", idAccClass);
												
												//out.println("-- in xx "+amount+"-> oid coa : "+coa.getOID());																				
											}
											//out.println(amount);
											
											//Retained Earnings
											//if(coa.getCode().equals(DbSystemProperty.getValueByName("ID_RETAINED_EARNINGS")) ||
											//coa.getCode().equals(DbSystemProperty.getValueByName("ID_RETAINED_EARNINGS_1"))	) 
											if(coa.getCode().equals(DbSystemProperty.getValueByName("ID_HEADER_CURRENT_EARNING")))
											{
												//ID_RETAINED_EARNINGS
												double totalIncome = 0;								
												double totalIncomePrevYear = 0;								
												Coa coax = new Coa();
												for(int ix=0; ix<listCoa.size(); ix++)
												{											
													coax= (Coa)listCoa.get(ix);
													
													boolean ok = false;
                    
													if(idAccClass==DbCoa.ACCOUNT_CLASS_SP){
														if(coax.getAccountClass()==idAccClass){
															ok = true;
														}
													}
													else{
														if(coax.getAccountClass()!=DbCoa.ACCOUNT_CLASS_SP){
															ok = true;
														}
													}
													
													if(ok){
													
														//if(coax.getAccountClass()==coa.getAccountClass()){
																																	
															if (coax.getAccountGroup().equals(I_Project.ACC_GROUP_REVENUE))
															{
																totalIncome = totalIncome + DbCoa.getCoaBalanceCD(coax.getOID());	
																totalIncomePrevYear = totalIncomePrevYear + DbCoa.getCoaBalanceCDPrevYear(coax.getOID());	
															}else if (coax.getAccountGroup().equals(I_Project.ACC_GROUP_COST_OF_SALES))
															{
																totalIncome = totalIncome - DbCoa.getCoaBalance(coax.getOID());	
																totalIncomePrevYear = totalIncomePrevYear - DbCoa.getCoaBalancePrevYear(coax.getOID());	
															}else if (coax.getAccountGroup().equals(I_Project.ACC_GROUP_EXPENSE))
															{
																totalIncome = totalIncome - DbCoa.getCoaBalance(coax.getOID());	
																totalIncomePrevYear = totalIncomePrevYear - DbCoa.getCoaBalancePrevYear(coax.getOID());	
															}else if (coax.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_REVENUE))
															{
																totalIncome = totalIncome + DbCoa.getCoaBalanceCD(coax.getOID());	
																totalIncomePrevYear = totalIncomePrevYear + DbCoa.getCoaBalanceCDPrevYear(coax.getOID());	
															}else if (coax.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_EXPENSE))
															{
																totalIncome = totalIncome - DbCoa.getCoaBalance(coax.getOID());	
																totalIncomePrevYear = totalIncomePrevYear - DbCoa.getCoaBalancePrevYear(coax.getOID());	
															}
														//}
													}
												}									
												
												//amount = totalIncome;
												//amountPrevYear = totalIncomePrevYear;
												amount = totalIncome + DbCoaOpeningBalance.getOpeningBalanceByHeader(periode, coa.getOID(), idAccClass);
												amountPrevYear = totalIncomePrevYear + DbCoaOpeningBalance.getOpeningBalanceByHeaderPrevYear(periode, coa.getOID(), idAccClass);
												
												//out.println(amount);
											}
											// Bagining Balance
											//if(coa.getCode().equals(DbSystemProperty.getValueByName("ID_BEGINING_BALANCE")))
											//{
											//	amount = DbCoa.getCoaBalance(coa.getOID());//getSumOpeningBalance();										
											//	amountPrevYear = DbCoa.getCoaBalancePrevYear(coa.getOID());//getSumOpeningBalance();										
											//}
											//if(coa.getCode().equals(DbSystemProperty.getValueByName("ID_PERIOD_EARNINGS")))
												//amount = 100000;
											//if(coa.getCode().equals(DbSystemProperty.getValueByName("ID_CURRENT_YEAR_EARNINGS")))
												//amount = 100000;
																			
											coaSummary6 = coaSummary6 + amount;	
											coaSummary6PrevYear = coaSummary6PrevYear + amountPrevYear;	
											
											//out.println("amount : "+amount+", valShowList : "+valShowList); 
											
											displayStr = strDisplay(amount, coa.getStatus());
											displayStrPrevYear = strDisplay(amountPrevYear, coa.getStatus());
											
											//tampilkan yang ada valuenya
											
											if (valShowList==1)
											{	
												if (//(coa.getCode().equals(DbSystemProperty.getValueByName("ID_RETAINED_EARNING")) && (amount!=0 || amountPrevYear!=0)) 												
												//|| (coa.getCode().equals(DbSystemProperty.getValueByName("ID_RETAINED_EARNINGS")) && (amount!=0 || amountPrevYear!=0)) 
												(coa.getCode().equals(DbSystemProperty.getValueByName("ID_HEADER_RETAINED_EARNING"))  && (amount!=0 || amountPrevYear!=0)) 
												|| (coa.getCode().equals(DbSystemProperty.getValueByName("ID_HEADER_CURRENT_EARNING"))  && (amount!=0 || amountPrevYear!=0))  
												//|| (coa.getCode().equals(DbSystemProperty.getValueByName("ID_RETAINED_EARNINGS_1")) && (amount!=0 || amountPrevYear!=0)) 
												//|| (coa.getStatus().equals("HEADER")) 
												|| ((coa.getStatus().equals("HEADER")) && (amount!=0 || amountPrevYear!=0)) )
												//|| ((coa.getStatus().equals("HEADER")) && amountPrevYear!=0))									
												//if ((coa.getStatus().equals("HEADER") && (DbCoa.getCoaBalanceByHeader(coa.getOID(),"CD", idAccClass))!=0) || ((coa.getStatus().equals("HEADER")) && amount!=0))
												{	//add detail
													sesReport = new SesReportBs();
													sesReport.setType(coa.getStatus());
													sesReport.setDescription(strTotal1+strTotal1+str1+coa.getCode()+" - "+coa.getName());
													sesReport.setAmount(amount);
													sesReport.setStrAmount(""+amount);
													sesReport.setAmountPrevYear(amountPrevYear);
													sesReport.setStrAmountPrevYear(""+amountPrevYear);
													//sesReport.setFont(coa.getStatus().equals("HEADER") ? 1 : 0);											
													sesReport.setFont(0);																						
													listReport.add(sesReport);
													
													//out.println("abc");											
									  %>
                                        <tr> 
                                          <td width="21%" class="<%=cssString%>" nowrap><%=strTotal+strTotal+str+coa.getCode()+" - "+coa.getName()%></td>
                                          <td width="12%" class="<%=cssString%>"> 
                                            <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                              <tr> 
                                                <td width="5%"></td>
                                                <td width="90%" class="<%=cssString%>"> 
                                                  <div align="right"><%=displayStrPrevYear%></div>
                                                </td>
                                                <td width="5%"></td>
                                              </tr>
                                            </table>
                                          </td>
                                          <td width="12%" class="<%=cssString%>"> 
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
										if (//coa.getCode().equals(DbSystemProperty.getValueByName("ID_RETAINED_EARNING")) 
										coa.getCode().equals(DbSystemProperty.getValueByName("ID_HEADER_RETAINED_EARNING")) 
										|| coa.getCode().equals(DbSystemProperty.getValueByName("ID_HEADER_CURRENT_EARNING"))
										//|| (idAccClass==DbCoa.ACCOUNT_CLASS_SP && coa.getCode().equals(DbSystemProperty.getValueByName("ID_RETAINED_EARNINGS"))) 
										//|| (idAccClass!=DbCoa.ACCOUNT_CLASS_SP && coa.getCode().equals(DbSystemProperty.getValueByName("ID_RETAINED_EARNINGS_1"))) 
										|| (coa.getStatus().equals("HEADER")) )
										//|| ((coa.getStatus().equals("HEADER")) && amount!=0) 
										//|| ((coa.getStatus().equals("HEADER")) && amountPrevYear!=0))
										{	//add detail
											sesReport = new SesReportBs();
											sesReport.setType(coa.getStatus());
											sesReport.setDescription(strTotal1+strTotal1+str1+coa.getCode()+" - "+coa.getName());
											sesReport.setAmount(amount);
											sesReport.setStrAmount(""+amount);
											sesReport.setAmountPrevYear(amountPrevYear);
											sesReport.setStrAmountPrevYear(""+amountPrevYear);
											//sesReport.setFont(coa.getStatus().equals("HEADER") ? 1 : 0);											
											sesReport.setFont(0);																						
											listReport.add(sesReport);											
							  %>
                                        <tr> 
                                          <td width="21%" class="<%=cssString%>" nowrap><%=strTotal+strTotal+str+coa.getCode()+" - "+coa.getName()%></td>
                                          <td width="12%" class="<%=cssString%>"> 
                                            <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                              <tr> 
                                                <td width="5%"></td>
                                                <td width="90%" class="<%=cssString%>"> 
                                                  <div align="right"><%=displayStrPrevYear%></div>
                                                </td>
                                                <td width="5%"></td>
                                              </tr>
                                            </table>
                                          </td>
                                          <td width="12%" class="<%=cssString%>"> 
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
								
								if (coaSummary6<0)							
									displayStr = "("+JSPFormater.formatNumber(coaSummary6*-1,"#,###")+")";
								else if (coaSummary6>0)
									displayStr = JSPFormater.formatNumber(coaSummary6,"#,###");
								else if (coaSummary6==0)
									displayStr = "";
												//add footer level
								
								if (coaSummary6PrevYear<0)							
									displayStrPrevYear = "("+JSPFormater.formatNumber(coaSummary6PrevYear*-1,"#,###")+")";
								else if (coaSummary6PrevYear>0)
									displayStrPrevYear = JSPFormater.formatNumber(coaSummary6PrevYear,"#,###");
								else if (coaSummary6PrevYear==0)
									displayStrPrevYear = "";
								
								
								}				//add footer level
								
								
								if((DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_EQUITY,"CD")+ DbCoaOpeningBalance.getSumOpeningBalance()!=0 )
								|| (DbCoa.getCoaBalanceByGroupPrevYear(I_Project.ACC_GROUP_EQUITY,"CD")+ DbCoaOpeningBalance.getSumOpeningBalancePrevYear()!=0 )
								|| valShowList!=1)
								{	//add Group Footer
									sesReport = new SesReportBs();										
									sesReport.setType("Footer Group Level");
									sesReport.setDescription(strTotal1+"Sub Total "+I_Project.ACC_GROUP_EQUITY);
									sesReport.setAmount(coaSummary6);
									sesReport.setStrAmount(""+coaSummary6);
									sesReport.setAmountPrevYear(coaSummary6PrevYear);
									sesReport.setStrAmountPrevYear(""+coaSummary6PrevYear);
									sesReport.setFont(1);												
									listReport.add(sesReport);																
						%>
                                        <tr> 
                                          <td width="21%" class="tablecell2"><span class="level2"><b><%=strTotal+" Sub Total "+I_Project.ACC_GROUP_EQUITY%></b></span></td>
                                          <td width="11%" class="tablecell2" align="right"> 
                                            <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                              <tr> 
                                                <td width="5%"></td>
                                                <td width="90%" class="tablecell2"> 
                                                  <div align="right"><b><%=displayStrPrevYear%></b></div>
                                                </td>
                                                <td width="5%"></td>
                                              </tr>
                                            </table>
                                          </td>
                                          <td width="11%" class="tablecell2" align="right"> 
                                            <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                              <tr> 
                                                <td width="5%"></td>
                                                <td width="90%" class="tablecell2"> 
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
											if (coaSummary6<0)							
												displayStr = "("+JSPFormater.formatNumber((coaSummary6)*-1,"#,###")+")";
											else if (coaSummary6<0)
												displayStr = JSPFormater.formatNumber(coaSummary6,"#,###");						
											else if (coaSummary6==0)
												displayStr = "";
												
											if (coaSummary6PrevYear<0)							
												displayStrPrevYear = "("+JSPFormater.formatNumber((coaSummary6PrevYear)*-1,"#,###")+")";
											else if (coaSummary6PrevYear<0)
												displayStrPrevYear = JSPFormater.formatNumber(coaSummary6PrevYear,"#,###");						
											else if (coaSummary6PrevYear==0)
												displayStrPrevYear = "";
												
											//add footer level
											if(coaSummary6!=0 || coaSummary6PrevYear!=0 || valShowList!=1)
											{	//add Group Footer
												sesReport = new SesReportBs();										
												sesReport.setType("Footer Top Level");
												sesReport.setDescription("Total Equity");
												sesReport.setAmount(coaSummary6);
												sesReport.setStrAmount(""+coaSummary6);
												sesReport.setAmountPrevYear(coaSummary6PrevYear);
												sesReport.setStrAmountPrevYear(""+coaSummary6PrevYear);
												sesReport.setFont(1);												
												listReport.add(sesReport);								
							
					%>
                                        <tr> 
                                          <td width="21%" class="tablecell2"><span class="level2"><b>Total 
                                            Equity</b></span></td>
                                          <td width="11%" class="tablecell2" align="right"> 
                                            <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                              <tr> 
                                                <td width="5%"></td>
                                                <td width="90%" class="tablecell2"> 
                                                  <div align="right"><b><%=displayStrPrevYear%></b></div>
                                                </td>
                                                <td width="5%"></td>
                                              </tr>
                                            </table>
                                          </td>
                                          <td width="11%" class="tablecell2" align="right"> 
                                            <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                              <tr> 
                                                <td width="5%"></td>
                                                <td width="90%" class="tablecell2"> 
                                                  <div align="right"><b><%=displayStr%></b></div>
                                                </td>
                                                <td width="5%"></td>
                                              </tr>
                                            </table>
                                          </td>
                                        </tr>
                                        <%	}
										
											totalPasiva = coaSummary4+coaSummary5+coaSummary6;
											totalPasivaPrevYear = coaSummary4PrevYear+coaSummary5PrevYear+coaSummary6PrevYear;
											
											//out.println("totalPasiva : "+totalPasiva);
										
											if (coaSummary4+coaSummary5+coaSummary6<0)							
												displayStr = "("+JSPFormater.formatNumber((coaSummary4+coaSummary5+coaSummary6)*-1,"#,###")+")";
											else if (coaSummary4+coaSummary5+coaSummary6>0)
												displayStr = JSPFormater.formatNumber((coaSummary4+coaSummary5+coaSummary6),"#,###");															
											else if (coaSummary4+coaSummary5+coaSummary6==0)
												displayStr = "";
												
											if (coaSummary4PrevYear+coaSummary5PrevYear+coaSummary6PrevYear<0)							
												displayStrPrevYear = "("+JSPFormater.formatNumber((coaSummary4PrevYear+coaSummary5PrevYear+coaSummary6PrevYear)*-1,"#,###")+")";
											else if (coaSummary4PrevYear+coaSummary5PrevYear+coaSummary6PrevYear>0)
												displayStrPrevYear = JSPFormater.formatNumber((coaSummary4PrevYear+coaSummary5PrevYear+coaSummary6PrevYear),"#,###");															
											else if (coaSummary4PrevYear+coaSummary5PrevYear+coaSummary6PrevYear==0)
												displayStrPrevYear = "";
												
											//add footer level
											if(coaSummary6!=0 || coaSummary6PrevYear!=0 || valShowList!=1)
											{	//add Group Footer
												sesReport = new SesReportBs();										
												sesReport.setType("Footer Top Level");
												sesReport.setDescription("Total Liabilities & Equity");
												sesReport.setAmount(coaSummary4+coaSummary5+coaSummary6);
												sesReport.setStrAmount(""+(coaSummary4+coaSummary5+coaSummary6));
												sesReport.setAmountPrevYear(coaSummary4PrevYear+coaSummary5PrevYear+coaSummary6PrevYear);
												sesReport.setStrAmountPrevYear(""+(coaSummary4PrevYear+coaSummary5PrevYear+coaSummary6PrevYear));
												sesReport.setFont(1);												
												listReport.add(sesReport);								
										%>
                                        <tr> 
                                          <td width="21%" class="tablecell2"><span class="level2"><b>Total 
                                            Liabilities & Equity</b></span></td>
                                          <td width="11%" class="tablecell2" align="right"> 
                                            <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                              <tr> 
                                                <td width="5%"></td>
                                                <td width="90%" class="tablecell2"><span class="level2"> 
                                                  <div align="right"><b><%=displayStrPrevYear%></b></div>
                                                  </span></td>
                                                <td width="5%"></td>
                                              </tr>
                                            </table>
                                          </td>
                                          <td width="11%" class="tablecell2" align="right"> 
                                            <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                              <tr> 
                                                <td width="5%"></td>
                                                <td width="90%" class="tablecell2"><span class="level2"> 
                                                  <div align="right"><b><%=displayStr%></b></div>
                                                  </span></td>
                                                <td width="5%"></td>
                                              </tr>
                                            </table>
                                          </td>
                                        </tr>
                                        <%
											}
												sesReport = new SesReportBs();										
												sesReport.setType("Space");
												sesReport.setDescription("");
												listReport.add(sesReport);																				
										%>
                                        <tr> 
                                          <td width="21%" class="tablecell1" height="15"></td>
                                          <td width="11%" class="tablecell1"></td>
                                          <td width="11%" class="tablecell1"></td>
                                        </tr>
                                        <%
												totalAktiva = Double.parseDouble(JSPFormater.formatNumber(totalAktiva, "###.##"));
												totalPasiva = Double.parseDouble(JSPFormater.formatNumber(totalPasiva, "###.##"));
												
												totalAktivaPrevYear = Double.parseDouble(JSPFormater.formatNumber(totalAktivaPrevYear, "###.##"));
												totalPasivaPrevYear = Double.parseDouble(JSPFormater.formatNumber(totalPasivaPrevYear, "###.##"));
												
												//out.println("totalAktiva 2 : "+totalAktiva);
												//out.println("totalPasiva 2 : "+totalPasiva);
										
												/*if ((coaSummary1+coaSummary2+coaSummary3)-(coaSummary4+coaSummary5+coaSummary6)<0){																			
													displayStr = "("+JSPFormater.formatNumber((coaSummary1+coaSummary2+coaSummary3)-(coaSummary4+coaSummary5+coaSummary6)*-1,"#,###")+")";
												}
												else if ((coaSummary1+coaSummary2+coaSummary3)-(coaSummary4+coaSummary5+coaSummary6)>0){
													displayStr = JSPFormater.formatNumber((coaSummary1+coaSummary2+coaSummary3)-(coaSummary4+coaSummary5+coaSummary6),"#,###");															
												}
												else if (((coaSummary1+coaSummary2+coaSummary3)-(coaSummary4+coaSummary5+coaSummary6))==0){
													displayStr = "-";
												}
												*/
												
												if (totalAktiva - totalPasiva<0){																			
													displayStr = "("+JSPFormater.formatNumber((totalAktiva - totalPasiva)*-1,"#,###")+")";
												}
												else if (totalAktiva - totalPasiva>0){
													displayStr = JSPFormater.formatNumber(totalAktiva - totalPasiva,"#,###");															
												}
												else if ((totalAktiva - totalPasiva)==0){
													displayStr = "-";
												}
												
												if (totalAktivaPrevYear - totalPasivaPrevYear<0){																			
													displayStrPrevYear = "("+JSPFormater.formatNumber((totalAktivaPrevYear - totalPasivaPrevYear)*-1,"#,###")+")";
												}
												else if (totalAktivaPrevYear - totalPasivaPrevYear>0){
													displayStrPrevYear = JSPFormater.formatNumber(totalAktivaPrevYear - totalPasivaPrevYear,"#,###");															
												}
												else if ((totalAktivaPrevYear - totalPasivaPrevYear)==0){
													displayStrPrevYear = "-";
												}
																			
												//add footer level
												if(coaSummary4+coaSummary5!=0 || coaSummary4PrevYear+coaSummary5PrevYear!=0 || valShowList!=1)
												{	//add Group Footer
													sesReport = new SesReportBs();										
													sesReport.setType("Footer Top Level");
													sesReport.setDescription(strTotal1+"");
													sesReport.setAmount((coaSummary1+coaSummary2+coaSummary3)-(coaSummary4+coaSummary5+coaSummary6));
													sesReport.setStrAmount(""+((coaSummary1+coaSummary2+coaSummary3)-(coaSummary4+coaSummary5+coaSummary6)));
													sesReport.setAmountPrevYear((coaSummary1PrevYear+coaSummary2PrevYear+coaSummary3PrevYear)-(coaSummary4PrevYear+coaSummary5PrevYear+coaSummary6PrevYear));
													sesReport.setStrAmountPrevYear(""+((coaSummary1PrevYear+coaSummary2PrevYear+coaSummary3PrevYear)-(coaSummary4PrevYear+coaSummary5PrevYear+coaSummary6PrevYear)));
													sesReport.setFont(1);												
													listReport.add(sesReport);																				
										%>
                                        <tr> 
                                          <td width="21%" class="tablecell2"><span class="level2"><b></b></span></td>
                                          <td width="11%" class="tablecell2" align="right"> 
                                            <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                              <tr> 
                                                <td width="5%"></td>
                                                <td width="90%" class="tablecell2"> 
                                                  <div align="right"><b><font color="red"><%=displayStrPrevYear%></font></b></div>
                                                </td>
                                                <td width="5%"></td>
                                              </tr>
                                            </table>
                                          </td>
                                          <td width="11%" class="tablecell2" align="right"> 
                                            <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                              <tr> 
                                                <td width="5%"></td>
                                                <td width="90%" class="tablecell2"> 
                                                  <div align="right"><b><font color="red"><%=displayStr%></font></b></div>
                                                </td>
                                                <td width="5%"></td>
                                              </tr>
                                            </table>
                                          </td>
                                        </tr>
                                        <%		}	%>
                                        <tr> 
                                          <td width="21%" class="tablecell1" height="15"></td>
                                          <td width="11%" class="tablecell1"></td>
                                          <td width="11%" class="tablecell1"></td>
                                        </tr>
                                      </table>
									</td>
                                  </tr>												  			  
                                </table>
                              </td>
                            </tr>
							
							<%
								session.putValue("BS_STANDARD", listReport);							
/*
								out.println(listReport);
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
