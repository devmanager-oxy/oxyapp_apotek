
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "com.project.fms.master.*" %>
<%@ page import = "com.project.fms.session.*" %>
<%@ include file = "../main/javainit.jsp" %>
<% int  appObjCode = 1; %>
<%@ include file = "../main/check.jsp" %>
<%
            boolean priv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MN_FIN_REP, AppMenu.M2_MN_REPORT);
            boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_FIN_REP, AppMenu.M2_MN_REPORT, AppMenu.PRIV_VIEW);
            boolean privUpdate = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_FIN_REP, AppMenu.M2_MN_REPORT, AppMenu.PRIV_UPDATE);
            boolean privAdd = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_FIN_REP, AppMenu.M2_MN_REPORT, AppMenu.PRIV_ADD);
            boolean privDelete = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_FIN_REP, AppMenu.M2_MN_REPORT, AppMenu.PRIV_DELETE);
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
	
	public String strDisplay(double amount){
		String displayStr = "";
		if(amount<0)
			displayStr = "("+JSPFormater.formatNumber(amount*-1,"#,###")+")";
		else if(amount>0)										
			displayStr = JSPFormater.formatNumber(amount,"#,###");
		else if(amount==0)
			displayStr = "";		
		return displayStr;
	}
	
	public String getContentDisplay(String stt, String str){
		String result = "";
		if(stt.equals("HEADER")){ 
			result = "<b>";
		}
		result = result + str;
		if(stt.equals("HEADER")){
			result = result + "</b>";    
		}
		return result;
	}
		
%> 
<%

	//pnlType = 0, biaya | pnlType = 1, pendapatan
	int pnlType = JSPRequestValue.requestInt(request, "pnl_type");
	int iJSPCommand = JSPRequestValue.requestCommand(request);
	int valShowList = JSPRequestValue.requestInt(request, "showlist");	
	Vector listCoa = new Vector(1,1);	
	Coa coa = new Coa();
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
	
	//out.println("valShowList : "+valShowList);
	
	//budget
	double totalBudget = 0;
	double totalBudgetYr = 0;
	double totalBudgetSD = 0;
	
	double bgtSumRevenue = 0;
	double bgtSumCogs = 0;
	double bgtSumCogsYr = 0;
	double bgtSumCogsSD = 0;
	double bgtSumExpense = 0;
	double bgtSumExpenseSD = 0;
	double bgtSumExpenseYr = 0;
	double bgtSumOthExpense = 0;
	double bgtSumOthExpenseYr = 0;
	double bgtSumOthExpenseSD = 0;
	double bgtSumOthRevenue = 0;
	
	
	double sumRevenueMth = 0;
	double sumCogsMth = 0;
	double sumCogsLMth = 0;
	double sumExpenseMth = 0;
	double sumExpenseLMth = 0;
	double sumOthExpenseMth = 0;
	double sumOthExpenseLMth = 0;
	double sumOthRevenueMth = 0;
	
	double totalAmount = 0;
	double totalMthAmount = 0;
	double totalLMthAmount = 0;
	
	
	String displayStrBudget = "";
	String displayStrBudgetYr = "";
	String displayStrBudgetSD = "";
	String displayStrMth = "";
	String displayStrLMth = "";

%>
<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
<head>
<!-- #BeginEditable "javascript" --> 
<title><%=systemTitle%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<link href="../css/default.css" rel="stylesheet" type="text/css" />
<link href="../css/css.css" rel="stylesheet" type="text/css" />
<script language="JavaScript">
<%if(!priv || !privView){%>
	window.location="<%=approot%>/nopriv.jsp";
<%}%>
function cmdChangeList(){
	document.frmcoa.command.value="<%=JSPCommand.SUBMIT%>";
	document.frmcoa.action="biaya_v01.jsp";
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
                                    <td height="20" valign="middle" align="center" colspan="3"><span class="level1"><font size="+1"><b> 
                                      <%if(pnlType==0){%>
                                      REALISASI PENYERAPAN BIAYA 
                                      <%}else{%>
                                      REALISASI PENYERAPAN PENDAPATAN 
                                      <%}%>
                                      </b></font></span></td>
                                  </tr>
                                  <%
								  	Periode periode = DbPeriode.getOpenPeriod();
									Date startDate = periode.getStartDate();
									String openPeriod = JSPFormater.formatDate(periode.getStartDate(), "MMMM yyyy");//+ " - " + JSPFormater.formatDate(periode.getEndDate(), "dd MMM yyyy");        
									
									Date dtx = new Date();
									int yearx = dtx.getYear()+1900;
									
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
                                          <td width="31%" class="tablehdr" height="22"><font size="1"></font></td>
                                          <td class="tablehdr" height="22" colspan="3"><font size="1">TARGET</font></td>
                                          <td colspan="3" class="tablehdr" height="22"><font size="1">REALISASI</font></td>
                                          <td colspan="2" class="tablehdr" height="22"><font size="1">% 
                                            PENCAPAIAN</font></td>
                                        </tr>
                                        <tr> 
                                          <td width="31%" class="tablehdr" height="22"> 
                                            <div align="center"><font size="1"><b><font color="#FFFFFF">Description</font></b></font></div>
                                          </td>
                                          <td class="tablehdr" height="22" width="9%"><font size="1">TAHUN 
                                            <%=yearx%> </font></td>
                                          <td class="tablehdr" height="22" width="9%"><font size="1">S/D 
                                            BLN INI</font></td>
                                          <td class="tablehdr" height="22" width="9%"><font size="1">BLN 
                                            INI </font></td>
                                          <td width="10%" class="tablehdr" height="22"><font size="1">S/D 
                                            BLN LALU</font></td>
                                          <td width="10%" class="tablehdr" height="22"><font size="1">BLN 
                                            INI </font></td>
                                          <td width="10%" class="tablehdr" height="22"><font size="1">SD 
                                            BLN INI</font></td>
                                          <td width="6%" class="tablehdr" height="22"><font size="1">S/D 
                                            BLN INI</font></td>
                                          <td width="6%" class="tablehdr" height="22"><font size="1">BLN 
                                            INI </font></td>
                                        </tr>
                                        <!--level 2-->
                                        <!--level ACC_GROUP_EXPENSE-->
                                        <%
										
										listCoa = DbCoa.list(0,0, "account_group='Cost Of Sales'", "code");
										
										sesReport = new SesReportBs();										
										sesReport.setType("Group Level");
										sesReport.setDescription("HARGA POKOK PENJUALAN");//I_Project.ACC_GROUP_COST_OF_SALES);
										sesReport.setCode("");
										//sesReport.setFont(1);
										sesReport.setLevel(9);												
										listReport.add(sesReport);
										
										%>
                                        <tr> 
                                          <td width="31%" class="tablecell"><b><font size="1"><%="HARGA POKOK PENJUALAN"%> 
                                            <%//=I_Project.ACC_GROUP_COST_OF_SALES%>
                                            </font></b></td>
                                          <td width="9%" class="tablecell" nowrap><font size="1"></font></td>
                                          <td width="9%" class="tablecell" nowrap><font size="1"></font></td>
                                          <td width="9%" class="tablecell" nowrap> 
                                            <div align="right"><font size="1"><font size="1"></font></font></div>
                                          </td>
                                          <td width="10%" class="tablecell" nowrap><font size="1"></font></td>
                                          <td width="10%" class="tablecell" nowrap> 
                                            <div align="right"><font size="1"><font size="1"></font></font></div>
                                          </td>
                                          <td width="10%" class="tablecell" nowrap> 
                                            <div align="left"><font size="1"><font size="1"></font></font></div>
                                          </td>
                                          <td width="6%" class="tablecell" nowrap><font size="1"></font></td>
                                          <td width="6%" class="tablecell" nowrap><font size="1"></font></td>
                                        </tr>
                                        <%
										
										if(listCoa!=null && listCoa.size()>0)
										{
											coaSummary2 = 0;
											String str = "";
											String str1 = "";
											displayStrBudget = "";
																		
											for(int i=0; i<listCoa.size(); i++){
											
													coa = (Coa)listCoa.get(i);
												
													//budget ====================
													double budgetYr = DbCoaBudget.getBudgetRecursif(coa, yearx);
													double budget = budgetYr/12;								
													double budgetSD = budget * (startDate.getMonth()+1);								
													displayStrBudget = (budget==0) ? "" : JSPFormater.formatNumber(budget, "#,###");
													displayStrBudgetYr = (budgetYr==0) ? "" : JSPFormater.formatNumber(budgetYr, "#,###");
													displayStrBudgetSD = (budgetSD==0) ? "" : JSPFormater.formatNumber(budgetSD, "#,###");
													
													str = switchLevel(coa.getLevel());
													str1 = switchLevel1(coa.getLevel());
													
													//amount ====================
													double amount = DbCoa.getCoaBalanceRecursif(coa);
													double amountMth = DbCoa.getCoaBalanceRecursif(coa, periode,"DC");
													double amountLMth = amount - amountMth;
													displayStr = strDisplay(amount, coa.getStatus());
													displayStrMth = strDisplay(amountMth, coa.getStatus());
													displayStrLMth = strDisplay(amountLMth, coa.getStatus());
													
													//pencapaian ================
													
													if(!coa.getStatus().equals("HEADER")){
														totalBudget = totalBudget + budget;
														totalBudgetYr = totalBudgetYr + budgetYr;
														totalBudgetSD = totalBudgetSD + budgetSD;
														bgtSumCogs = bgtSumCogs + budget;
														bgtSumCogsYr = bgtSumCogsYr + budgetYr;
														bgtSumCogsSD = bgtSumCogsSD + budgetSD;
														totalMthAmount = totalMthAmount + amountMth;
														totalLMthAmount = totalLMthAmount + amountLMth;
														sumCogsMth = sumCogsMth + amountMth;
														sumCogsLMth = sumCogsLMth + amountLMth;
														totalAmount = totalAmount + amount;
														coaSummary2 = coaSummary2 + amount;
													}
																					
													sesReport = new SesReportBs();
													sesReport.setType(coa.getStatus());
													sesReport.setDescription(coa.getName());
													sesReport.setCode(coa.getCode());
													sesReport.setAmount(amount);
													sesReport.setStrAmount(""+amount);
													sesReport.setAmountMth(amountMth);
													sesReport.setStrAmountMth(""+amountMth);
													sesReport.setAmountBudget(budget);
													//sesReport.setStrAmountBudget(""+budget);
													//sesReport.setFont(coa.getStatus().equals("HEADER") ? 1 : 0);
													
													if(budget==0){
														sesReport.setStrAmountBudget(""+0);
													}else{
														sesReport.setStrAmountBudget(""+budget);
													}
													
													if(budgetSD==0){
														sesReport.setStrBudgetSd(""+0);
													}else{
														sesReport.setStrBudgetSd(""+budgetSD);
													}
													
													sesReport.setStrBudgetYr(""+budgetYr);
													sesReport.setStrBudgetLmth(""+amountLMth);
													sesReport.setLevel(coa.getLevel());
													
													//======================= for persentase ===================
													double psd = (amount/budgetSD)*100;
													double psIni = (amountMth/budget)*100;
													
													if(budgetSD==0 || amount==0){
														sesReport.setPencapaianSd(""+0);
													}else{
														sesReport.setPencapaianSd(""+psd);
													}
													
													if(budget==0 || amountMth==0){
														sesReport.setPencapaianIni(""+0);
													}else{
														sesReport.setPencapaianIni(""+psIni);
													}
													//======================== end ============================
																								
													listReport.add(sesReport);
										  %>
                                        <tr> 
                                          <td width="31%" class="<%=cssString%>" nowrap> 
                                            <font size="1"><%=getContentDisplay(coa.getStatus(), strTotal+str+coa.getCode()+" - "+coa.getName())%></font></td>
                                          <td width="9%" class="<%=cssString%>" nowrap> 
                                            <div align="right"> <font size="1"><%=getContentDisplay(coa.getStatus(), displayStrBudgetYr)%> </font></div>
                                          </td>
                                          <td width="9%" class="<%=cssString%>" nowrap> 
                                            <div align="right"> 
                                              <div align="right"> <font size="1"><%=getContentDisplay(coa.getStatus(), displayStrBudgetSD)%> </font></div>
                                            </div>
                                          </td>
                                          <td width="9%" class="<%=cssString%>" nowrap> 
                                            <div align="right"> <font size="1"><%=getContentDisplay(coa.getStatus(), displayStrBudget)%> </font></div>
                                          </td>
                                          <td width="10%" class="<%=cssString%>" nowrap> 
                                            <div align="right"><font size="1"><%=getContentDisplay(coa.getStatus(), displayStrLMth)%></font></div>
                                          </td>
                                          <td width="10%" class="<%=cssString%>" nowrap> 
                                            <div align="right"> <font size="1"><%=getContentDisplay(coa.getStatus(), displayStrMth)%> </font></div>
                                          </td>
                                          <td width="10%" class="<%=cssString%>" nowrap> 
                                            <div align="right"><font size="1"><%=getContentDisplay(coa.getStatus(), displayStr)%></font></div>
                                          </td>
                                          <td width="6%" class="<%=cssString%>" nowrap> 
                                            <div align="center"> <font size="1"><%=getContentDisplay(coa.getStatus(), (budgetSD==0 || amount==0) ? "" : JSPFormater.formatNumber((amount/budgetSD)*100,"#,###")+"%")%> </font></div>
                                          </td>
                                          <td width="6%" class="<%=cssString%>" nowrap> 
                                            <div align="center"> <font size="1"><%=getContentDisplay(coa.getStatus(), (budget==0 || amountMth==0) ? "" : JSPFormater.formatNumber((amountMth/budget)*100,"#,###")+"%")%> </font></div>
                                          </td>
                                        </tr>
                                        <%
													
											}//end for cogs		
											
											displayStr = strDisplay(coaSummary2);																								
											displayStrBudget = strDisplay(bgtSumCogs);	
											displayStrBudgetYr = strDisplay(bgtSumCogsYr);	
											displayStrBudgetSD = strDisplay(bgtSumCogsSD);	
											displayStrMth = strDisplay(sumCogsMth);	
											displayStrLMth = strDisplay(sumCogsLMth);
																		
											//--------------------------------------
											String xtotal = "TOTAL HARGA POKOK PENJUALAN";
										
											sesReport = new SesReportBs();										
											sesReport.setType("Footer Group Level");
											sesReport.setDescription(xtotal);
											sesReport.setCode("");
											sesReport.setAmount(coaSummary2);
											sesReport.setStrAmount(""+coaSummary2);
											sesReport.setAmountMth(sumCogsMth);
											sesReport.setStrAmountMth(""+sumCogsMth);
											sesReport.setAmountBudget(bgtSumCogs);
											//sesReport.setStrAmountBudget(""+bgtSumCogs);
											//sesReport.setFont(9);
											
											if(bgtSumCogs==0){
												sesReport.setStrAmountBudget(""+0);
											}else{
												sesReport.setStrAmountBudget(""+bgtSumCogs);
											}
											
											if(bgtSumCogsSD==0){
												sesReport.setStrBudgetSd(""+0);
											}else{
												sesReport.setStrBudgetSd(""+bgtSumCogsSD);
											}
											
											sesReport.setStrBudgetYr(""+bgtSumCogsYr);
											sesReport.setStrBudgetLmth(""+sumCogsLMth);
											sesReport.setLevel(99);
											
											//======================= for persentase ===================
											double psd = (coaSummary2/bgtSumCogsSD)*100;
											double psIni = (sumCogsMth/bgtSumCogs)*100;
											
											if(bgtSumCogsSD==0 || coaSummary2==0){
												sesReport.setPencapaianSd(""+0);
											}else{
												sesReport.setPencapaianSd(""+psd);
											}
											
											if(bgtSumCogs==0 || sumCogsMth==0){
												sesReport.setPencapaianIni(""+0);
											}else{
												sesReport.setPencapaianIni(""+psIni);
											}
											//======================== end ============================
																							
											listReport.add(sesReport);								
						%>
                                        <tr> 
                                          <td width="31%" class="tablecell2"><span class="level2"><b><font size="1"><%=xtotal%></font></b></span></td>
                                          <td width="9%" class="tablecell2" align="right" nowrap> 
                                            <div align="right"><font size="1"><b><%=displayStrBudgetYr%></b></font></div>
                                          </td>
                                          <td width="9%" class="tablecell2" align="right" nowrap> 
                                            <div align="right"><font size="1"><b><%=displayStrBudgetSD%></b></font></div>
                                          </td>
                                          <td width="9%" class="tablecell2" align="right" nowrap> 
                                            <div align="right"> <font size="1"><b> 
                                              <%=displayStrBudget%> </b> </font></div>
                                          </td>
                                          <td width="10%" class="tablecell2" align="right" nowrap><b><font size="1"><%=displayStrLMth%></font></b></td>
                                          <td width="10%" class="tablecell2" align="right" nowrap> 
                                            <div align="right"><font size="1"><b> 
                                              <%=displayStrMth%> </b> </font></div>
                                          </td>
                                          <td width="10%" class="tablecell2" align="right" nowrap> 
                                            <div align="right"><font size="1"><b><%=displayStr%></b></font></div>
                                          </td>
                                          <td width="6%" class="tablecell2" align="right" nowrap> 
                                            <div align="center"> <font size="1"><b> 
                                              <%=(bgtSumCogsSD==0 || coaSummary2==0) ? "" : JSPFormater.formatNumber((coaSummary2/bgtSumCogsSD)*100,"#,###")%>% </b> </font></div>
                                          </td>
                                          <td width="6%" class="tablecell2" align="right" nowrap> 
                                            <div align="center"> <font size="1"><b> 
                                              <%=(bgtSumCogs==0 || sumCogsMth==0) ? "" : JSPFormater.formatNumber((sumCogsMth/bgtSumCogs)*100,"#,###")%>% </b> </font></div>
                                          </td>
                                        </tr>
                                        <%
												
										}//end list coa !=null
										
										//space
										sesReport = new SesReportBs();										
										sesReport.setType("Space");
										sesReport.setDescription("");
										sesReport.setCode("");
										listReport.add(sesReport);																				
									%>
                                        <tr> 
                                          <td width="31%" class="tablecell1" height="15"><font size="1"></font></td>
                                          <td width="9%" class="tablecell1" nowrap><font size="1"></font></td>
                                          <td width="9%" class="tablecell1" nowrap><font size="1"></font></td>
                                          <td width="9%" class="tablecell1" nowrap> 
                                            <div align="right"><font size="1"><font size="1"></font></font></div>
                                          </td>
                                          <td width="10%" class="tablecell1" nowrap><font size="1"></font></td>
                                          <td width="10%" class="tablecell1" nowrap> 
                                            <div align="right"><font size="1"><font size="1"></font></font></div>
                                          </td>
                                          <td width="10%" class="tablecell1" nowrap> 
                                            <div align="left"><font size="1"><font size="1"></font></font></div>
                                          </td>
                                          <td width="6%" class="tablecell1" nowrap><font size="1"></font></td>
                                          <td width="6%" class="tablecell1" nowrap> 
                                            <div align="center"><font size="1"><font size="1"></font></font></div>
                                          </td>
                                        </tr>
                                        <!--level 3-->
                                        <!--level ACC_GROUP_EXPENSE-->
                                        <%	
											sesReport = new SesReportBs();										
											sesReport.setType("Group Level");
											sesReport.setDescription("BIAYA");//I_Project.ACC_GROUP_EXPENSE);
											sesReport.setCode("5");
											//sesReport.setFont(1);
											sesReport.setLevel(9);												
											listReport.add(sesReport);
										%>
                                        <tr> 
                                          <td width="31%" class="tablecell"><b><font size="1"><%="BIAYA"%> 
                                            <%//=I_Project.ACC_GROUP_EXPENSE%>
                                            </font></b></td>
                                          <td width="9%" class="tablecell" nowrap><font size="1"></font></td>
                                          <td width="9%" class="tablecell" nowrap><font size="1"></font></td>
                                          <td width="9%" class="tablecell" nowrap> 
                                            <div align="right"><font size="1"><font size="1"></font></font></div>
                                          </td>
                                          <td width="10%" class="tablecell" nowrap><font size="1"></font></td>
                                          <td width="10%" class="tablecell" nowrap> 
                                            <div align="right"><font size="1"><font size="1"></font></font></div>
                                          </td>
                                          <td width="10%" class="tablecell" nowrap> 
                                            <div align="left"><font size="1"><font size="1"></font></font></div>
                                          </td>
                                          <td width="6%" class="tablecell" nowrap><font size="1"></font></td>
                                          <td width="6%" class="tablecell" nowrap> 
                                            <div align="center"><font size="1"><font size="1"></font></font></div>
                                          </td>
                                        </tr>
                                        <%	
										
										listCoa = DbCoa.list(0,0, "account_group='Expense' or account_group='Other Expense'", "code");
										
										if(listCoa!=null && listCoa.size()>0){
										
											coaSummary3 = 0;
											String str = "";
											String str1 = "";
											displayStrBudget = "";
											displayStrBudgetYr = "";
											displayStrBudgetSD = "";
																		
											for(int i=0; i<listCoa.size(); i++){
											
													coa = (Coa)listCoa.get(i);
												
													double budgetYr = DbCoaBudget.getBudgetRecursif(coa, yearx);
													double budget = budgetYr/12;
													double budgetSD = budget*(startDate.getMonth()+1);
													displayStrBudget = (budget==0) ? "" : JSPFormater.formatNumber(budget, "#,###");
													displayStrBudgetYr = (budgetYr==0) ? "" : JSPFormater.formatNumber(budgetYr, "#,###");
													displayStrBudgetSD = (budgetSD==0) ? "" : JSPFormater.formatNumber(budgetSD, "#,###");
												
													str = switchLevel(coa.getLevel());
													str1 = switchLevel1(coa.getLevel());
													double amount = DbCoa.getCoaBalanceRecursif(coa);
													double amountMth = DbCoa.getCoaBalanceRecursif(coa,periode,"DC");
													double amountLMth = amount - amountMth;//DbCoa.getCoaBalanceRecursif(coa,periode,"DC");
													displayStr = strDisplay(amount, coa.getStatus());
													displayStrMth = strDisplay(amountMth, coa.getStatus());
													displayStrLMth = strDisplay(amountLMth, coa.getStatus());
													
													if(!coa.getStatus().equals("HEADER")){
														totalBudget = totalBudget + budget;
														totalBudgetYr = totalBudgetYr + budgetYr;
														totalBudgetSD = totalBudgetSD + budgetSD;
														bgtSumExpense = bgtSumExpense + budget;
														bgtSumExpenseSD = bgtSumExpenseSD + budgetSD;
														bgtSumExpenseYr = bgtSumExpenseYr + budgetYr;
														totalMthAmount = totalMthAmount + amountMth;
														totalLMthAmount = totalLMthAmount + amountLMth;
														sumExpenseMth = sumExpenseMth + amountMth;
														sumExpenseLMth = sumExpenseLMth + amountLMth;
														totalAmount = totalAmount + amount;
														coaSummary3 = coaSummary3 + amount;
													}
													
													sesReport = new SesReportBs();
													sesReport.setType(coa.getStatus());
													sesReport.setDescription(coa.getName());
													sesReport.setCode(coa.getCode());
													sesReport.setAmount(amount);
													sesReport.setStrAmount(""+amount);
													sesReport.setAmountMth(amountMth);
													sesReport.setStrAmountMth(""+amountMth);
													sesReport.setAmountBudget(budget);
													//sesReport.setStrAmountBudget(""+budget);
													//sesReport.setFont(coa.getStatus().equals("HEADER") ? 1 : 0);
													
													if(budget==0){
														sesReport.setStrAmountBudget(""+0);
													}else{
														sesReport.setStrAmountBudget(""+budget);
													}
													
													if(budgetSD==0){
														sesReport.setStrBudgetSd(""+0);
													}else{
														sesReport.setStrBudgetSd(""+budgetSD);
													}
													
													sesReport.setStrBudgetYr(""+budgetYr);
													sesReport.setStrBudgetLmth(""+amountLMth);
													sesReport.setLevel(coa.getLevel());
													
													//======================= for persentase ===================
													double psd = (amount/budgetSD)*100;
													double psIni = (amountMth/budget)*100;
													
													if(budgetSD==0 || amount==0){
														sesReport.setPencapaianSd(""+0);
													}else{
														sesReport.setPencapaianSd(""+psd);
													}
													
													if(budget==0 || amountMth==0){
														sesReport.setPencapaianIni(""+0);
													}else{
														sesReport.setPencapaianIni(""+psIni);
													}
													//======================== end ============================
																								
													listReport.add(sesReport);
									  %>
                                        <tr> 
                                          <td width="31%" class="<%=cssString%>" nowrap> 
                                            <font size="1"><%=getContentDisplay(coa.getStatus(), strTotal+str+coa.getCode()+" - "+coa.getName())%></font></td>
                                          <td width="9%" class="<%=cssString%>" nowrap> 
                                            <div align="right"> <font size="1"><%=getContentDisplay(coa.getStatus(), displayStrBudgetYr)%> </font></div>
                                          </td>
                                          <td width="9%" class="<%=cssString%>" nowrap> 
                                            <div align="right"> <font size="1"><%=getContentDisplay(coa.getStatus(), displayStrBudgetSD)%> </font></div>
                                          </td>
                                          <td width="9%" class="<%=cssString%>" nowrap> 
                                            <div align="right"> <font size="1"><%=getContentDisplay(coa.getStatus(), displayStrBudget)%> </font></div>
                                          </td>
                                          <td width="10%" class="<%=cssString%>" nowrap> 
                                            <div align="right"><font size="1"><%=getContentDisplay(coa.getStatus(), displayStrLMth)%></font></div>
                                          </td>
                                          <td width="10%" class="<%=cssString%>" nowrap> 
                                            <div align="right"> <font size="1"><%=getContentDisplay(coa.getStatus(), displayStrMth)%> </font></div>
                                          </td>
                                          <td width="10%" class="<%=cssString%>" nowrap> 
                                            <div align="right"><font size="1"><%=getContentDisplay(coa.getStatus(), displayStr)%></font></div>
                                          </td>
                                          <td width="6%" class="<%=cssString%>" nowrap> 
                                            <div align="center"> <font size="1"><%=getContentDisplay(coa.getStatus(), (budgetSD==0 || amount==0) ? "" : JSPFormater.formatNumber((amount/budgetSD)*100,"#,###")+"%")%> </font></div>
                                          </td>
                                          <td width="6%" class="<%=cssString%>" nowrap> 
                                            <div align="center"> <font size="1"><%=getContentDisplay(coa.getStatus(), (budget==0 || amountMth==0) ? "" : JSPFormater.formatNumber((amountMth/budget)*100,"#,###")+"%")%> </font></div>
                                          </td>
                                        </tr>
                                        <%
											}//end for coa 				
											
											displayStr = strDisplay(coaSummary3);
											displayStrBudget = strDisplay(bgtSumExpense);
											displayStrBudgetSD = strDisplay(bgtSumExpenseSD);
											displayStrBudgetYr = strDisplay(bgtSumExpenseYr);
											displayStrMth = strDisplay(sumExpenseMth);
											displayStrLMth = strDisplay(sumExpenseLMth);
										
											//----------------------------
											String xtotal = "TOTAL BIAYA";
										
											sesReport = new SesReportBs();										
											sesReport.setType("Footer Group Level");
											sesReport.setDescription(xtotal);
											sesReport.setCode("");
											sesReport.setAmount(coaSummary3);
											sesReport.setStrAmount(""+coaSummary3);
											sesReport.setAmountMth(sumExpenseMth);
											sesReport.setStrAmountMth(""+sumExpenseMth);
											sesReport.setAmountBudget(bgtSumExpense);
											//sesReport.setStrAmountBudget(""+bgtSumExpense);
											//sesReport.setFont(9);
											
											if(bgtSumExpense==0){
												sesReport.setStrAmountBudget(""+0);
											}else{
												sesReport.setStrAmountBudget(""+bgtSumExpense);
											}
											
											if(bgtSumExpenseSD==0){
												sesReport.setStrBudgetSd(""+0);
											}else{
												sesReport.setStrBudgetSd(""+bgtSumExpenseSD);
											}
											
											sesReport.setStrBudgetYr(""+bgtSumExpenseYr);
											sesReport.setStrBudgetLmth(""+sumExpenseLMth);
											sesReport.setLevel(99);
											
											//======================= for persentase ===================
											double psd = (coaSummary3/bgtSumExpenseSD)*100;
											double psIni = (sumExpenseMth/bgtSumExpense)*100;
											
											if(bgtSumExpenseSD==0 || coaSummary3==0){
												sesReport.setPencapaianSd(""+0);
											}else{
												sesReport.setPencapaianSd(""+psd);
											}
											
											if(bgtSumExpense==0 || sumExpenseMth==0){
												sesReport.setPencapaianIni(""+0);
											}else{
												sesReport.setPencapaianIni(""+psIni);
											}
											//======================== end ============================
																							
											listReport.add(sesReport);								
										%>
                                        <tr> 
                                          <td width="31%" class="tablecell2"><span class="level2"><b><font size="1"><%=xtotal%></font></b></span></td>
                                          <td width="9%" class="tablecell2" align="right" nowrap><b><font size="1"><%=displayStrBudgetYr%></font></b></td>
                                          <td width="9%" class="tablecell2" align="right" nowrap><b><font size="1"><%=displayStrBudgetSD%></font></b></td>
                                          <td width="9%" class="tablecell2" align="right" nowrap> 
                                            <div align="right"> <font size="1"><b> 
                                              <%=displayStrBudget%> </b> </font></div>
                                          </td>
                                          <td width="10%" class="tablecell2" align="right" nowrap><b><font size="1"><%=displayStrLMth%></font></b></td>
                                          <td width="10%" class="tablecell2" align="right" nowrap> 
                                            <div align="right"> <font size="1"><b> 
                                              <%=displayStrMth%> </b> </font></div>
                                          </td>
                                          <td width="10%" class="tablecell2" align="right" nowrap> 
                                            <div align="right"><font size="1"><b><%=displayStr%></b></font></div>
                                          </td>
                                          <td width="6%" class="tablecell2" align="right" nowrap> 
                                            <div align="center"> <font size="1"><b> 
                                              <%=(bgtSumExpenseSD==0 || coaSummary3==0) ? "" : JSPFormater.formatNumber((coaSummary3/bgtSumExpenseSD)*100,"#,###")%>% </b> </font></div>
                                          </td>
                                          <td width="6%" class="tablecell2" align="right" nowrap> 
                                            <div align="center"> <font size="1"><b> 
                                              <%=(bgtSumExpense==0 || sumExpenseMth==0) ? "" : JSPFormater.formatNumber((sumExpenseMth/bgtSumExpense)*100,"#,###")%>% </b> </font></div>
                                          </td>
                                        </tr>
                                        <%
												
										}//end list != null
										
										sesReport = new SesReportBs();										
										sesReport.setType("Space");
										sesReport.setDescription("");
										sesReport.setCode("");
										listReport.add(sesReport);
																														
										%>
                                        <tr> 
                                          <td width="31%" class="tablecell1" height="15"><font size="1"></font></td>
                                          <td width="9%" class="tablecell1" nowrap><font size="1"></font></td>
                                          <td width="9%" class="tablecell1" nowrap><font size="1"></font></td>
                                          <td width="9%" class="tablecell1" nowrap> 
                                            <div align="right"><font size="1"><font size="1"></font></font></div>
                                          </td>
                                          <td width="10%" class="tablecell1" nowrap><font size="1"></font></td>
                                          <td width="10%" class="tablecell1" nowrap> 
                                            <div align="right"><font size="1"><font size="1"></font></font></div>
                                          </td>
                                          <td width="10%" class="tablecell1" nowrap> 
                                            <div align="left"><font size="1"><font size="1"></font></font></div>
                                          </td>
                                          <td width="6%" class="tablecell1" nowrap><font size="1"></font></td>
                                          <td width="6%" class="tablecell1" nowrap> 
                                            <div align="center"><font size="1"><font size="1"></font></font></div>
                                          </td>
                                        </tr>
                                        <% 
											displayStr = strDisplay(totalAmount);
											displayStrBudget = strDisplay(totalBudget);
											displayStrBudgetYr = strDisplay(totalBudgetYr);
											displayStrBudgetSD = strDisplay(totalBudgetSD);
											displayStrMth = strDisplay(totalMthAmount);
											displayStrLMth = strDisplay(totalLMthAmount);	
											
											
											sesReport = new SesReportBs();										
											sesReport.setType("Last Level");
											
											String strxx = "";//"Net";
											if(pnlType==0){
												//strxx = strxx +" Expense";
												strxx = strxx +" GRAND TOTAL BIAYA";
											}else{
												//strxx = strxx + " Income";
												strxx = strxx + " GRAND TOTAL PENDAPATAN";
											}
											
											sesReport.setDescription(strxx);
											sesReport.setCode("");
											sesReport.setAmount(coaSummary1+coaSummary2+coaSummary3+coaSummary4+coaSummary5);
											sesReport.setStrAmount(""+(coaSummary1+coaSummary2+coaSummary3+coaSummary4+coaSummary5));
											sesReport.setAmountMth(sumRevenueMth+sumCogsMth+sumExpenseMth+sumOthRevenueMth+sumOthExpenseMth);
											sesReport.setStrAmountMth(""+(sumRevenueMth+sumCogsMth+sumExpenseMth+sumOthRevenueMth+sumOthExpenseMth));
											sesReport.setAmountBudget(bgtSumRevenue-bgtSumCogs+bgtSumExpense+bgtSumOthRevenue+bgtSumOthExpense);
											
											if((bgtSumRevenue+bgtSumCogs+bgtSumExpense+bgtSumOthRevenue+bgtSumOthExpense)==0){
												sesReport.setStrAmountBudget(""+0);
											}else{
												sesReport.setStrAmountBudget(""+(bgtSumRevenue+bgtSumCogs+bgtSumExpense+bgtSumOthRevenue+bgtSumOthExpense));
											}
											
											if(totalBudgetSD==0){
												sesReport.setStrBudgetSd(""+0);
											}else{
												sesReport.setStrBudgetSd(""+totalBudgetSD);
											}
											
											sesReport.setStrBudgetYr(""+totalBudgetYr);
											sesReport.setStrBudgetLmth(""+totalLMthAmount);
											sesReport.setLevel(99);
											
											//======================= for persentase ===================
											double psd = (totalAmount/totalBudgetSD)*100;
											double psIni = (totalMthAmount/totalBudget)*100;
											
											if(totalBudgetSD==0 || totalAmount==0){
												sesReport.setPencapaianSd(""+0);
											}else{
												sesReport.setPencapaianSd(""+psd);
											}
											
											if(totalBudget==0 || totalMthAmount==0){
												sesReport.setPencapaianIni(""+0);
											}else{
												sesReport.setPencapaianIni(""+psIni);
											}
											//======================== end ============================
																							
											listReport.add(sesReport);								
										%>
                                        <tr> 
                                          <td width="31%" class="tablecell2"> 
                                            <font size="1"><span class="level2"> 
                                            <b><%=strxx%></b></span></font></td>
                                          <td width="9%" class="tablecell2" align="right" nowrap><b><font size="1"><%=displayStrBudgetYr%></font></b></td>
                                          <td width="9%" class="tablecell2" align="right" nowrap><b><font size="1"><%=displayStrBudgetSD%></font></b></td>
                                          <td width="9%" class="tablecell2" align="right" nowrap> 
                                            <div align="right"><font size="1"><b><%=displayStrBudget%></b></font></div>
                                          </td>
                                          <td width="10%" class="tablecell2" align="right" nowrap><b><font size="1"><%=displayStrLMth%></font></b></td>
                                          <td width="10%" class="tablecell2" align="right" nowrap> 
                                            <div align="right"><font size="1"><b><%=displayStrMth%></b></font></div>
                                          </td>
                                          <td width="10%" class="tablecell2" align="right" nowrap> 
                                            <div align="right"><font size="1"><b><%=displayStr%></b></font></div>
                                          </td>
                                          <td width="6%" class="tablecell2" align="right" nowrap> 
                                            <div align="center"><font size="1"><b> 
                                              <%=(totalBudgetSD==0 || totalAmount==0) ? "" : JSPFormater.formatNumber((totalAmount/totalBudgetSD)*100,"#,###")%>% </b></font></div>
                                          </td>
                                          <td width="6%" class="tablecell2" align="right" nowrap> 
                                            <div align="center"><font size="1"><b><%=(totalBudget==0 || totalMthAmount==0) ? "" : JSPFormater.formatNumber((totalMthAmount/totalBudget)*100,"#,###")%>% </b></font></div>
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
							%>
							
                            <tr align="left" valign="top"> 
                              <td height="8" valign="middle" colspan="3">&nbsp; </td>
                            </tr>
                            <tr align="left" valign="top"> 
                              <td height="8" valign="middle" colspan="3" class="container"> 
                                <%if(true){//listCoa!=null && listCoa.size()>0){%>
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
