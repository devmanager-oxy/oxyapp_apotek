<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%//@ page import = "com.project.fms.journal.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "com.project.fms.master.*" %>
<%@ page import = "com.project.fms.session.*" %>
<%@ page import = "com.project.fms.activity.*" %>
<%@ page import = "com.project.fms.report.*" %>
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
			displayStr = "("+JSPFormater.formatNumber(amount*-1,"#,###")+")";
		else if(amount>0)										
			displayStr = JSPFormater.formatNumber(amount,"#,###");
		else if(amount==0)
			displayStr = "";
		if(coaStatus.equals("HEADER"))
			displayStr = "<b>"+displayStr+"</b>";
		return displayStr;
	}
	
	public String strDisplayPercent(double amount, String coaStatus){
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
	
	if(session.getValue("DETAIL")!=null){
		session.removeValue("DETAIL");
	}
	
	
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
	
	long periodeId = JSPRequestValue.requestLong(request, "src_periode_id");
	
	Vector periodes = DbPeriode.list(0,0, "", "start_date desc");

	Periode periode = new Periode();
	
	boolean isOpen = false;
	if(periodeId==0){
		if(periodes!=null && periodes.size()>0){
			periode =(Periode)periodes.get(0);
			periodeId = periode.getOID();
			if(periode.getStatus().equals("Open")){
				isOpen = true;
			}
		}
	}
	else{
		try{
			periode = DbPeriode.fetchExc(periodeId);
			if(periode.getStatus().equals("Open")){
				isOpen = true;
			}
		}
		catch(Exception e){
		}
	}	
	
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
	//double totalBudget = 0;
	
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
	
	Vector objReport = new Vector();
	RptKinerjaL detail = new RptKinerjaL();

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

function cmdChangePeriod(){
	//document.frmcoa.command.value="<%=JSPCommand.SUBMIT%>";
	document.frmcoa.action="kinerja.jsp";
	document.frmcoa.submit();
}

function cmdChangeList(){
	document.frmcoa.command.value="<%=JSPCommand.SUBMIT%>";
	document.frmcoa.action="kinerja.jsp";
	document.frmcoa.submit();
}

function cmdPrintJournal(){	 
	window.open("<%=printroot%>.report.RptProfitLossPDF?oid=<%=appSessUser.getLoginId()%>");
}

function cmdPrintXLS(){	 
	window.open("<%=printroot%>.report.RptKinerjaXLS?oid=<%=appSessUser.getLoginId()%>");
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
					  String navigator = "<font class=\"lvl1\">Financial Report</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">Kinerja Usaha</span></font>";
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
                                    <td height="10" colspan="3"> 
                                      <table width="40%" border="0" cellspacing="0" cellpadding="0">
                                        <tr> 
                                          <td width="24%" nowrap><b>PERIODE : 
                                            <select name="src_periode_id" onChange="javascript:cmdChangePeriod()">
                                              <%if(periodes!=null && periodes.size()>0){
											  for(int i=0; i<periodes.size(); i++){
											  		Periode px = (Periode)periodes.get(i);
											  %>
                                              <option value="<%=px.getOID()%>" <%if(px.getOID()==periodeId){%>selected<%}%>><%=px.getName()%></option>
                                              <%}}%>
                                            </select>
                                            </b></td>
                                          <td width="76%">&nbsp; </td>
                                        </tr>
                                      </table>
                                    </td>
                                  </tr>
                                  <tr align="left" valign="top"> 
                                    <td height="20" valign="middle" align="center" colspan="3"><span class="level1"><font size="+1"><b>KINERJA 
                                      USAHA </b></font></span></td>
                                  </tr>
                                  <%
								  	//Periode periode = DbPeriode.getOpenPeriod();
									String openPeriod = JSPFormater.formatDate(periode.getStartDate(), "MMMM yyyy");//+ " - " + JSPFormater.formatDate(periode.getEndDate(), "dd MMM yyyy");        
									
									Date dtx = periode.getStartDate();
									int yearx = dtx.getYear()+1900;
									
									//out.println("yearx : "+yearx);
									
								  %>
                                  <tr align="left" valign="top"> 
                                    <td height="20" valign="middle" align="center" colspan="3"><span class="level1"><b><font size="3"><%=openPeriod.toUpperCase()%></font></b></span></td>
                                    <%detail.setPeriode(openPeriod);%>
								  </tr>
                                  <tr align="left" valign="top"> 
                                    <td height="10" valign="middle" colspan="3"></td>
                                  </tr>
                                  <tr align="left" valign="top"> 
                                    <td height="22" valign="middle" colspan="3" class="page"> 
                                      <table width="100%" border="0" cellpadding="1" height="20" cellspacing="1">
                                        <tr> 
                                          <td width="3%" class="tablehdr" height="22">&nbsp;</td>
                                          <td width="22%" class="tablehdr" height="22">KETERANGAN</td>
                                          <td class="tablehdr" height="22" width="13%">TAHUN</td>
                                          <td class="tablehdr" height="22" colspan="2">TARGET</td>
                                          <td colspan="2" class="tablehdr" height="22">REALISASI</td>
                                          <td class="tablehdr" height="22" colspan="3">% 
                                            Pencapaian </td>
                                        </tr>
                                        <tr> 
                                          <td width="3%" class="tablehdr" height="22">&nbsp;</td>
                                          <td width="22%" class="tablehdr" height="22"> 
                                            <div align="center"><b></b></div>
                                          </td>
                                          <td class="tablehdr" height="22" width="13%"><%=yearx%></td>
										  <%detail.setTahun(yearx);%>
                                          <td class="tablehdr" height="22" width="11%">SD 
                                            BLN INI</td>
                                          <td class="tablehdr" height="22" width="10%">BLN 
                                            INI </td>
                                          <td width="10%" class="tablehdr" height="22">SD 
                                            BLN INI </td>
                                          <td width="11%" class="tablehdr" height="22"> 
                                            BLN INI</td>
                                          <td width="7%" class="tablehdr" height="22">SD 
                                            BLN INI</td>
                                          <td width="7%" class="tablehdr" height="22">BLN 
                                            INI </td>
                                          <td width="6%" class="tablehdr" height="22">THN 
                                            <%=yearx%></td>
                                        </tr>
                                        <tr> 
                                          <td width="3%" height="16">&nbsp;</td>
                                          <td width="22%" height="16"> 
                                            <div align="center">1</div>
                                          </td>
                                          <td width="13%" height="16" nowrap> 
                                            <div align="center">2</div>
                                          </td>
                                          <td width="11%" height="16" nowrap> 
                                            <div align="center">3</div>
                                          </td>
                                          <td width="10%" height="16" nowrap> 
                                            <div align="center">4</div>
                                          </td>
                                          <td width="10%" height="16" nowrap> 
                                            <div align="center">5</div>
                                          </td>
                                          <td width="11%" height="16" nowrap> 
                                            <div align="center">6</div>
                                          </td>
                                          <td width="7%" height="16" nowrap> 
                                            <div align="center">7=5/3</div>
                                          </td>
                                          <td width="7%" height="16" nowrap> 
                                            <div align="center">8=6/4</div>
                                          </td>
                                          <td width="6%" height="16" nowrap> 
                                            <div align="center">9=5/2</div>
                                          </td>
                                        </tr>
                                        <tr> 
                                          <td width="3%" height="15" class="tablecell1" bgcolor="#CCCCCC">&nbsp;</td>
                                          <td width="22%" height="15" class="tablecell1" bgcolor="#CCCCCC">&nbsp;</td>
                                          <td width="13%" height="15" nowrap class="tablecell1" bgcolor="#CCCCCC">&nbsp;</td>
                                          <td width="11%" height="15" nowrap class="tablecell1" bgcolor="#CCCCCC">&nbsp;</td>
                                          <td width="10%" height="15" nowrap class="tablecell1" bgcolor="#CCCCCC">&nbsp;</td>
                                          <td width="10%" height="15" nowrap class="tablecell1" bgcolor="#CCCCCC">&nbsp;</td>
                                          <td width="11%" height="15" nowrap class="tablecell1" bgcolor="#CCCCCC">&nbsp;</td>
                                          <td width="7%" height="15" nowrap class="tablecell1" bgcolor="#CCCCCC">&nbsp;</td>
                                          <td width="7%" height="15" nowrap class="tablecell1" bgcolor="#CCCCCC">&nbsp;</td>
                                          <td width="6%" height="15" nowrap class="tablecell1" bgcolor="#CCCCCC">&nbsp;</td>
                                        </tr>
                                        <%
										//HITUNNG KINERJA PENDAPATAN
										
										Vector coaCats = DbCoaCategory.list(0,0, "type="+DbCoaCategory.TYPE_INCOME, "");
										
										double totalIncome = 0;
										double totalIncomeSd = 0;
										double totalYearBudget = 0;
										double totalSdBudget = 0;
										double totalBudget = 0;
										String str = "";
										String strSd = "";
										
										String strYearBgt = "";
										String strSdBgt = "";
										String strBgt = "";										
										
										if(coaCats!=null && coaCats.size()>0){
											for(int i=0; i<coaCats.size(); i++){
											
												CoaCategory cc = (CoaCategory)coaCats.get(i);
												double income = DbCoaCategory.getCoaBalanceMTD(cc, periode);
												double incomeSd = DbCoaCategory.getCoaBalanceYTD(cc, periode);
												
												totalIncome = totalIncome + income;
												totalIncomeSd = totalIncomeSd + incomeSd; 
												
												double yearBgt = DbCoaCategory.getCoaBudget(cc, periode);
												double bgt = yearBgt/12;
												double sdBgt = bgt * (dtx.getMonth()+1);
												
												totalYearBudget = totalYearBudget + yearBgt;
												totalSdBudget = totalSdBudget + sdBgt;
												totalBudget = totalBudget + bgt;											
											
											}
										}
										//set value
										detail.setTargetTahun(totalYearBudget);
										detail.setTargetSd(totalSdBudget);
										detail.setTargetBulanIni(totalBudget);
										
										detail.setRealSd(totalIncomeSd);
										detail.setRealBulanIni(totalIncome);
										
										
										//pendapatan
										str = strDisplay(totalIncome, "");
										strSd = strDisplay(totalIncomeSd, "");
										
										strYearBgt = strDisplay(totalYearBudget, "");
										strSdBgt = strDisplay(totalSdBudget, "");
										strBgt = strDisplay(totalBudget, "");
										
										double pencapaian = (totalIncome/totalBudget)*100;
										double pencapaianSd = (totalIncomeSd/totalSdBudget)*100;
										double pencapaianYear = (totalIncomeSd/totalYearBudget)*100;
										
										%>
                                        <tr> 
                                          <td width="3%" height="25" class="tablecell" bgcolor="#CCCCCC"> 
                                            <div align="center"><b>I</b></div>
                                          </td>
                                          <td width="22%" height="25" class="tablecell" bgcolor="#CCCCCC"><b>TOTAL 
                                            PENDAPATAN</b></td>
                                          <td width="13%" height="25" nowrap class="tablecell" bgcolor="#CCCCCC"> 
                                            <div align="right"><b><%=strYearBgt%></b></div>
                                          </td>
                                          <td width="11%" height="25" nowrap class="tablecell" bgcolor="#CCCCCC"> 
                                            <div align="right"><b><%=strSdBgt%></b></div>
                                          </td>
                                          <td width="10%" height="25" nowrap class="tablecell" bgcolor="#CCCCCC"> 
                                            <div align="right"><b><%=strBgt%></b></div>
                                          </td>
                                          <td width="10%" height="25" nowrap class="tablecell" bgcolor="#CCCCCC"> 
                                            <div align="right"><b><%=strSd%></b></div>
                                          </td>
                                          <td width="11%" height="25" nowrap class="tablecell" bgcolor="#CCCCCC"> 
                                            <div align="right"><b><%=str%></b></div>
                                          </td>
                                          <td width="7%" height="25" nowrap class="tablecell" bgcolor="#CCCCCC"> 
                                            <div align="right"><b><%=strDisplayPercent(pencapaianSd, "")%>%</b></div>
                                          </td>
                                          <td width="7%" height="25" nowrap class="tablecell" bgcolor="#CCCCCC"> 
                                            <div align="right"><b><%=strDisplayPercent(pencapaian, "")%>%</b></div>
                                          </td>
                                          <td width="6%" height="25" nowrap class="tablecell" bgcolor="#CCCCCC"> 
                                            <div align="right"><b><%=strDisplayPercent(pencapaianYear, "")%>%</b></div>
                                          </td>
                                        </tr>
                                        <tr> 
                                          <td width="3%" class="tablecell1" height="15"></td>
                                          <td width="22%" class="tablecell1" height="15"></td>
                                          <td width="13%" class="tablecell1" nowrap height="15"></td>
                                          <td width="11%" class="tablecell1" nowrap height="15"></td>
                                          <td width="10%" class="tablecell1" nowrap height="15"></td>
                                          <td width="10%" class="tablecell1" nowrap height="15"></td>
                                          <td width="11%" class="tablecell1" nowrap height="15"></td>
                                          <td width="7%" class="tablecell1" nowrap height="15"><b></b></td>
                                          <td width="7%" class="tablecell1" nowrap height="15"><b></b></td>
                                          <td width="6%" class="tablecell1" nowrap height="15"><b></b></td>
                                        </tr>
                                        <%
										String where = "type="+DbCoaCategory.TYPE_COGS+" or "+
													   "type="+DbCoaCategory.TYPE_GENERAL_EXPENSE+" or "+
													   "type="+DbCoaCategory.TYPE_DEPRECIATION+" or "+
													   "type="+DbCoaCategory.TYPE_INTEREST_EXPENSE;
													   
										coaCats = DbCoaCategory.list(0,0, where, "");
										
										double totalCogs = 0;
										double totalCogsSd = 0;
										str = "";
										strSd = "";
										
										double totalCogsYearBudget = 0;
										double totalCogsSdBudget = 0;
										double totalCogsBudget = 0;
										
										if(coaCats!=null && coaCats.size()>0){
											for(int i=0; i<coaCats.size(); i++){
												CoaCategory cc = (CoaCategory)coaCats.get(i);
												double amount = DbCoaCategory.getCoaBalanceMTD(cc, periode);
												double amountSd = DbCoaCategory.getCoaBalanceYTD(cc, periode);
												
												totalCogs = totalCogs + amount;
												totalCogsSd = totalCogsSd + amountSd; 
												
												double yearBgt = DbCoaCategory.getCoaBudget(cc, periode);
												double bgt = yearBgt/12;
												double sdBgt = bgt * (dtx.getMonth()+1);
												
												totalCogsYearBudget = totalCogsYearBudget + yearBgt;
												totalCogsSdBudget = totalCogsSdBudget + sdBgt;
												totalCogsBudget = totalCogsBudget + bgt;
												
											
											}
										}
										//for value
										detail.setTargetTahun2(totalCogsYearBudget);
										detail.setTargetSd2(totalCogsSdBudget);
										detail.setTargetBulanIni2(totalCogsBudget);
										
										detail.setRealSd2(totalCogsSd);
										detail.setRealBulanIni2(totalCogs);
										
																				
										//pendapatan
										str = strDisplay(totalCogs, "");
										strSd = strDisplay(totalCogsSd, "");
										
										strYearBgt = strDisplay(totalCogsYearBudget, "");
										strSdBgt = strDisplay(totalCogsSdBudget, "");
										strBgt = strDisplay(totalCogsBudget, "");
										
										double pencapaianCogs = (totalCogs/totalCogsBudget) * 100;
										double pencapaianCogsSd = (totalCogsSd/totalCogsSdBudget) * 100;
										double pencapaianCogsYear = (totalCogsSd/totalCogsYearBudget) * 100;
										
										%>
                                        <tr> 
                                          <td width="3%" class="tablecell" height="23"> 
                                            <div align="center"><b>II</b></div>
                                          </td>
                                          <td width="22%" class="tablecell" height="23"><b>TOTAL 
                                            BIAYA</b> </td>
                                          <td width="13%" class="tablecell" nowrap height="23"> 
                                            <div align="right"><b><%=strYearBgt%></b></div>
                                          </td>
                                          <td width="11%" class="tablecell" nowrap height="23"> 
                                            <div align="right"><b><%=strSdBgt%></b></div>
                                          </td>
                                          <td width="10%" class="tablecell" nowrap height="23"> 
                                            <div align="right"><b><%=strBgt%></b></div>
                                          </td>
                                          <td width="10%" class="tablecell" nowrap height="23"> 
                                            <div align="right"><b><%=strSd%></b></div>
                                          </td>
                                          <td width="11%" class="tablecell" nowrap height="23"> 
                                            <div align="right"><b><%=str%></b></div>
                                          </td>
                                          <td width="7%" height="25" nowrap class="tablecell" bgcolor="#CCCCCC"> 
                                            <div align="right"><b><%=strDisplayPercent(pencapaianCogsSd, "")%>%</b></div>
                                          </td>
                                          <td width="7%" height="25" nowrap class="tablecell" bgcolor="#CCCCCC"> 
                                            <div align="right"><b><%=strDisplayPercent(pencapaianCogs, "")%>%</b></div>
                                          </td>
                                          <td width="6%" height="25" nowrap class="tablecell" bgcolor="#CCCCCC"> 
                                            <div align="right"><b><%=strDisplayPercent(pencapaianCogsYear, "")%>%</b></div>
                                          </td>
                                        </tr>
                                        <tr> 
                                          <td width="3%" class="tablecell1" height="15">&nbsp;</td>
                                          <td width="22%" class="tablecell1" height="15">&nbsp;</td>
                                          <td width="13%" class="tablecell1" nowrap height="15">&nbsp;</td>
                                          <td width="11%" class="tablecell1" nowrap height="15">&nbsp;</td>
                                          <td width="10%" class="tablecell1" nowrap height="15">&nbsp;</td>
                                          <td width="10%" class="tablecell1" nowrap height="15">&nbsp;</td>
                                          <td width="11%" class="tablecell1" nowrap height="15">&nbsp;</td>
                                          <td width="7%" class="tablecell1" nowrap height="15">&nbsp;</td>
                                          <td width="7%" class="tablecell1" nowrap height="15">&nbsp;</td>
                                          <td width="6%" class="tablecell1" nowrap height="15">&nbsp;</td>
                                        </tr>
                                        <%
										double percentYearBudget = (totalCogsYearBudget/totalYearBudget) * 100;
										double percentSdBudget = (totalCogsSdBudget/totalSdBudget) * 100;
										double percentBudget = (totalCogsBudget/totalBudget) * 100;
										double percentIncome = (totalCogs/totalIncome) * 100;
										double percentIncomeSd = (totalCogsSd/totalIncomeSd) * 100;
										
										//for value
										detail.setTargetTahun3(percentYearBudget);
										detail.setTargetSd3(percentSdBudget);
										detail.setTargetBulanIni3(percentBudget);
										
										detail.setRealSd3(percentIncomeSd);
										detail.setRealBulanIni3(percentIncome);
										
										%>
                                        <tr> 
                                          <td width="3%" class="tablecell" height="22"> 
                                            <div align="center"><b>III</b></div>
                                          </td>
                                          <td width="22%" class="tablecell" height="22"><b>OR</b></td>
                                          <td width="13%" class="tablecell" nowrap height="22"> 
                                            <div align="right"><b><%=strDisplayPercent(percentYearBudget, "")%>%</b></div>
                                          </td>
                                          <td width="11%" class="tablecell" nowrap height="22"> 
                                            <div align="right"><b><%=strDisplayPercent(percentSdBudget, "")%>%</b></div>
                                          </td>
                                          <td width="10%" class="tablecell" nowrap height="22"> 
                                            <div align="right"><b><%=strDisplayPercent(percentBudget, "")%>%</b></div>
                                          </td>
                                          <td width="10%" class="tablecell" nowrap height="22"> 
                                            <div align="right"><b><%=strDisplayPercent(percentIncomeSd, "")%>%</b></div>
                                          </td>
                                          <td width="11%" class="tablecell" nowrap height="22"> 
                                            <div align="right"><b><%=strDisplayPercent(percentIncome, "")%>%</b></div>
                                          </td>
                                          <td width="7%" height="25" nowrap class="tablecell" bgcolor="#CCCCCC"> 
                                            <div align="right"><b><%=strDisplayPercent((percentIncomeSd/percentSdBudget)*100, "")%>%</b></div>
                                          </td>
                                          <td width="7%" height="25" nowrap class="tablecell" bgcolor="#CCCCCC"> 
                                            <div align="right"><b><%=strDisplayPercent((percentIncome/percentBudget)*100, "")%>%</b></div>
                                          </td>
                                          <td width="6%" height="25" nowrap class="tablecell" bgcolor="#CCCCCC"> 
                                            <div align="right"><b><%=strDisplayPercent((percentIncomeSd/percentYearBudget)*100, "")%>%</b></div>
                                          </td>
                                        </tr>
                                        <tr> 
                                          <td width="3%" class="tablecell1" height="15">&nbsp;</td>
                                          <td width="22%" class="tablecell1" height="15">&nbsp;</td>
                                          <td width="13%" class="tablecell1" nowrap height="15">&nbsp;</td>
                                          <td width="11%" class="tablecell1" nowrap height="15">&nbsp;</td>
                                          <td width="10%" class="tablecell1" nowrap height="15">&nbsp;</td>
                                          <td width="10%" class="tablecell1" nowrap height="15">&nbsp;</td>
                                          <td width="11%" class="tablecell1" nowrap height="15">&nbsp;</td>
                                          <td width="7%" class="tablecell1" nowrap height="15">&nbsp;</td>
                                          <td width="7%" class="tablecell1" nowrap height="15">&nbsp;</td>
                                          <td width="6%" class="tablecell1" nowrap height="15">&nbsp;</td>
                                        </tr>
                                        <%
												//for value
												double tr = totalYearBudget-totalCogsYearBudget;
												double trSd = totalSdBudget-totalCogsSdBudget;
												double trBln = totalBudget-totalCogsBudget;
												
												double trRSd = totalIncomeSd-totalCogsSd;
												double trRBln = totalIncome-totalCogs;
												
												
												detail.setTargetTahun4(tr);
												detail.setTargetSd4(trSd);
												detail.setTargetBulanIni4(trBln);
												
												detail.setRealSd4(trRSd);
												detail.setRealBulanIni4(trRBln);
										
										%>
                                        <tr> 
                                          <td width="3%" class="tablecell" height="22"> 
                                            <div align="center"><b class="lvl2">IV</b></div>
                                          </td>
                                          <td width="22%" class="tablecell" height="22"> 
                                            <div align="left"><b class="level2">LABA 
                                              BERSIH SEBELUM PAJAK</b></div>
                                          </td>
                                          <td width="13%" class="tablecell" nowrap height="22"> 
                                            <div align="right"><b class="level2"><%=strDisplay(totalYearBudget-totalCogsYearBudget, "")%></b></div>
                                          </td>
                                          <td width="11%" class="tablecell" nowrap height="22"> 
                                            <div align="right"><b class="level2"><%=strDisplay(totalSdBudget-totalCogsSdBudget, "")%></b></div>
                                          </td>
                                          <td width="10%" class="tablecell" nowrap height="22"> 
                                            <div align="right"><b class="level2"><%=strDisplay(totalBudget-totalCogsBudget, "")%></b></div>
                                          </td>
                                          <td width="10%" class="tablecell" nowrap height="22"> 
                                            <div align="right"><b class="level2"><%=strDisplay(totalIncomeSd-totalCogsSd, "")%></b></div>
                                          </td>
                                          <td width="11%" class="tablecell" nowrap height="22"> 
                                            <div align="right"><b class="level2"><%=strDisplay(totalIncome-totalCogs, "")%></b></div>
                                          </td>
                                          <td width="7%" height="25" nowrap class="tablecell" bgcolor="#CCCCCC"> 
                                            <div align="right"><b class="level2"><%=strDisplayPercent(((totalIncomeSd-totalCogsSd)/(totalSdBudget-totalCogsSdBudget))*100, "")%>%</b></div>
                                          </td>
                                          <td width="7%" height="25" nowrap class="tablecell" bgcolor="#CCCCCC"> 
                                            <div align="right" class="level2"><b><%=strDisplayPercent(((totalIncome-totalCogs)/(totalBudget-totalCogsBudget))*100, "")%>%</b></div>
                                          </td>
                                          <td width="6%" height="25" nowrap class="tablecell" bgcolor="#CCCCCC"> 
                                            <div align="right"><b class="level2"><%=strDisplayPercent(((totalIncomeSd-totalCogsSd)/(totalYearBudget-totalCogsYearBudget))*100, "")%>%</b></div>
                                          </td>
                                        </tr>
                                        <tr> 
                                          <td width="3%" class="tablecell1" height="15"></td>
                                          <td width="22%" class="tablecell1" height="15"></td>
                                          <td width="13%" class="tablecell1" nowrap height="15"></td>
                                          <td width="11%" class="tablecell1" nowrap height="15"></td>
                                          <td width="10%" class="tablecell1" nowrap height="15"></td>
                                          <td width="10%" class="tablecell1" nowrap height="15"></td>
                                          <td width="11%" class="tablecell1" nowrap height="15"></td>
                                          <td width="7%" class="tablecell1" nowrap height="15"></td>
                                          <td width="7%" class="tablecell1" nowrap height="15"></td>
                                          <td width="6%" class="tablecell1" nowrap height="15"></td>
                                        </tr>
                                        <tr> 
                                          <td width="3%" class="tablecell2">&nbsp;</td>
                                          <td width="22%" class="tablecell2"> 
                                            <span class="level2"> </span></td>
                                          <td width="13%" class="tablecell2" align="right" nowrap>&nbsp;</td>
                                          <td width="11%" class="tablecell2" align="right" nowrap>&nbsp;</td>
                                          <td width="10%" class="tablecell2" align="right" nowrap>&nbsp;</td>
                                          <td width="10%" class="tablecell2" align="right" nowrap>&nbsp;</td>
                                          <td width="11%" class="tablecell2" align="right" nowrap>&nbsp;</td>
                                          <td width="7%" class="tablecell2" align="right" nowrap>&nbsp;</td>
                                          <td width="7%" class="tablecell2" align="right" nowrap>&nbsp;</td>
                                          <td width="6%" class="tablecell2" align="right" nowrap>&nbsp;</td>
                                        </tr>
                                      </table>
                                    </td>
                                  </tr>
                                </table>
                              </td>
                            </tr>
							
							
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
                                    <td width="120"><a href="javascript:cmdPrintXLS()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('printxls','','../images/printxls2.gif',1)"><img src="../images/printxls.gif" name="printxls" width="120" height="22" border="0"></a></td>
                                    <td width="20">&nbsp;</td>
                                  </tr>
                                </table>
                                <%}%>
                              </td>
                            </tr> 
                          </table>
                        </form>
						<%
							session.putValue("DETAIL", detail);
						%>
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
