 
<%@ page language="java"%>
<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.system.*" %>
<%@ page import = "com.project.main.db.*" %>
<%@ page import = "com.project.fms.session.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "java.util.Date" %>
<%@ include file="../main/javainit.jsp"%>
<%@ include file="../main/check.jsp"%>
<%!
	public String switchLevel(int level){
		String str = "";
		switch(level)
		{
			
			case 1 : 
				str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
				break;
			case 2 :
				str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
				break;
			case 3 :
				str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
				break;
			
		}									
		return str;
	}

	public String switchLevel1(int level){
		String str = "";
		switch(level)
		{
			
			case 1 :
				str = "              ";
				break;
			case 2 :
				str = "                     ";
				break;
			case 3 :
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
		//if(coaStatus.equals("HEADER"))
		//	displayStr = "";
		return displayStr;
	}

%>
<%
//jsp content
int idAccClass = JSPRequestValue.requestInt(request, "id_class");
Vector listReport = new Vector();
%>
<html >
<!-- #BeginTemplate "/Templates/index.dwt" --> 
<head>
<!-- #BeginEditable "javascript" --> 
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Finance System</title>
<link href="../css/css.css" rel="stylesheet" type="text/css" />
<script type="text/javascript">
<!--

function cmdPrintJournal(){	 
	window.open("<%=printroot%>.report.RptBSStandardPDF?oid=<%=appSessUser.getLoginId()%>");
}

function cmdPrintJournalXLS(){	 
	window.open("<%=printroot%>.report.RptBSStandard1XLS?oid=<%=appSessUser.getLoginId()%>&id_class=<%=idAccClass%>");
}

function MM_swapImgRestore() { //v3.0
  var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
}
function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}

function MM_findObj(n, d) { //v4.01
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
  if(!x && d.getElementById) x=d.getElementById(n); return x;
}

function MM_swapImage() { //v3.0
  var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
   if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
}
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
          <td height="96"> <!-- #BeginEditable "header" --> 
            <%@ include file="../main/hmenu.jsp"%>
            <!-- #EndEditable --> </td>
        </tr>
        <tr> 
          <td valign="top"> 
            <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
              <!--DWLayoutTable-->
              <tr> 
                <td width="165" height="100%" valign="top" style="background:url(<%=approot%>/images/leftmenu-bg.gif) repeat-y"> 
                  <!-- #BeginEditable "menu" --> 
                  <%@ include file="../main/menu.jsp"%>
                  <!-- #EndEditable --> </td>
                <td width="100%" valign="top"> 
                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr> 
                      <td class="title"><!-- #BeginEditable "title" --><%
					  String navigator = "<font class=\"lvl1\">Financial Report</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">Neraca Unit</span></font>";
					  %>
					  <%@ include file="../main/navigator.jsp"%><!-- #EndEditable --></td>
                    </tr>
                    <!--tr> 
                      <td><img src="<%=approot%>/images/title-sp.gif" width="584" height="1"></td> 
                    </tr-->
                    <tr> 
                      <td><!-- #BeginEditable "content" --> 
                        <form id="form1" name="form1" method="post" action="">
                          <input type="hidden" name="command"><table width="100%" border="0" cellspacing="1" cellpadding="1">
  <tr>
    <td class="container"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                              <td>&nbsp;</td>
                            </tr>
                            <tr> 
                              <td> 
                                <div align="center"><span class="level1"><font size="+1"><b>NERACA 
                                  UNIT <%=(idAccClass==DbCoa.ACCOUNT_CLASS_SP) ? "SIMPAN PINJAM" : "NON SIMPAN PINJAM"%></b></font></span></div>
                              </td>
                            </tr>
                            <%
								  	Periode periode = DbPeriode.getOpenPeriod();
									
									Date dtx = (Date)periode.getStartDate().clone();
									dtx.setYear(dtx.getYear()-1);
									
									String openPeriod = "PER "+JSPFormater.formatDate(dtx, "MMM yyyy")+ " DAN " + JSPFormater.formatDate(periode.getStartDate(), "MMM yyyy");        
									
								  %>
                            <tr> 
                              <td> 
                                <div align="center"><span class="level1"><b><font size="3"><%=openPeriod.toUpperCase()%></font></b></span></div>
                              </td>
                            </tr>
                            <tr> 
                              <td>&nbsp;</td>
                            </tr>
                            <tr> 
                              <td>
                                      <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                        <tr> 
                                          <td  class="tablehdr" width="51%">Description</td>
                                          <td  class="tablehdr" width="25%">THN 
                                            <%
										  Date xDatex = periode.getStartDate();
										  Date abcDate = (Date)xDatex.clone();
										  abcDate.setYear(abcDate.getYear()-1);
										  %>
                                            <%=JSPFormater.formatDate(abcDate, "yyyy")%> </td>
                                          <td  class="tablehdr" width="24%">THN 
                                            <%=JSPFormater.formatDate(periode.getStartDate(), "yyyy")%></td>
                                        </tr>
                                        <tr> 
                                          <td width="51%" class="level2"><b>ACTIVA</b></td>
                                          <td width="25%" class="level2">&nbsp;</td>
                                          <td width="24%" class="level2">&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td width="51%" class="tablecell1"><b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;LIQUID 
                                            ASSET</b></td>
                                          <td width="25%" class="tablecell1">&nbsp;</td>
                                          <td width="24%" class="tablecell1">&nbsp;</td>
                                        </tr>
                                        <%
										
										//-- report ---
										SesReportBs sesReport = new SesReportBs();																				
										sesReport.setDescription("ACTIVA");
										sesReport.setFont(1);
										listReport.add(sesReport);
										
										sesReport = new SesReportBs();										
										sesReport.setDescription("       LIQUID ASSET");
										sesReport.setFont(1);
										listReport.add(sesReport);
								  
								  		//-- report ---		
										
								  String displayStr = "";
								  String displayStrPrevYear = "";
								  String displayStrTotal = "";
								  String displayStrPrevYearTotal = "";
								  
								  double amountTotal = 0;
								  double amountPrevYearTotal = 0;
								  double activaTotal = 0;
								  double activaPrevYearTotal = 0;								  
								  
								  Vector temp = DbCoa.list(0,0, "account_group='Liquid Assets' and status='HEADER'", "code");
								  
								  if(temp!=null && temp.size()>0){
								  
								  for(int i=0; i<temp.size(); i++){
								  	 Coa coa = (Coa)temp.get(i);
									 double amount = DbCoa.getCoaBalanceByHeader(coa.getOID(),"DC", idAccClass);
									 double amountPrevYear = DbCoa.getCoaBalanceByHeaderPrevYear(coa.getOID(),"DC", idAccClass);
									 
									 displayStr = strDisplay(amount, coa.getStatus());
									 displayStrPrevYear = strDisplay(amountPrevYear, coa.getStatus());
									 
									 amountTotal = amountTotal + amount;
								  	 amountPrevYearTotal = amountPrevYearTotal + amountPrevYear;
									 
									 //report
									 sesReport = new SesReportBs();										
									 sesReport.setDescription(switchLevel1(coa.getLevel())+coa.getCode()+" - "+coa.getName());
									 sesReport.setAmount(amount);
									 sesReport.setAmountPrevYear(amountPrevYear);									 
									 sesReport.setStrAmount(""+amount);
									 sesReport.setStrAmountPrevYear(""+amountPrevYear);
									 sesReport.setFont(0);									 
									 listReport.add(sesReport);
								  
								  %>
                                        <tr> 
                                          <td width="51%" class="tablecell"><%=switchLevel(coa.getLevel())+coa.getCode()+" - "+coa.getName()%></td>
                                          <td width="25%" class="tablecell"> 
                                            <div align="right"><%=displayStrPrevYear%></div>
                                          </td>
                                          <td width="24%" class="tablecell"> 
                                            <div align="right"><%=displayStr%></div>
                                          </td>
                                        </tr>
                                        <%}}
										
										displayStrTotal = strDisplay(amountTotal, "HEADER");
									 	displayStrPrevYearTotal = strDisplay(amountPrevYearTotal, "HEADER");
										
										activaTotal = activaTotal + amountTotal;
								  		activaPrevYearTotal = activaPrevYearTotal + amountPrevYearTotal;
										
										//-----report
										sesReport = new SesReportBs();										
										sesReport.setDescription("       TOTAL LIQUID ASSET");
										sesReport.setAmount(amountTotal);
										sesReport.setAmountPrevYear(amountPrevYearTotal);
										sesReport.setStrAmount(""+amountTotal);
									    sesReport.setStrAmountPrevYear(""+amountPrevYearTotal);
										sesReport.setFont(1);									 
										listReport.add(sesReport);
										
										%>
                                        <tr> 
                                          <td width="51%" class="tablecell1">&nbsp;</td>
                                          <td width="25%" class="tablecell1"> 
                                            <div align="right"><b><%=displayStrPrevYearTotal%></b></div>
                                          </td>
                                          <td width="24%" class="tablecell1"> 
                                            <div align="right"><b><%=displayStrTotal%></b></div>
                                          </td>
                                        </tr>
                                        <tr> 
                                          <td width="51%" class="tablecell1"><b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;FIXED 
                                            ASSET</b> </td>
                                          <td width="25%" class="tablecell1">&nbsp;</td>
                                          <td width="24%" class="tablecell1">&nbsp;</td>
                                        </tr>
                                        <%
										
										//-----report
										sesReport = new SesReportBs();																				
										sesReport.setDescription("       FIXED ASSET");
										sesReport.setFont(1);
										listReport.add(sesReport);
								  
								  displayStr = "";
								  displayStrPrevYear = "";
								  
								  amountTotal = 0;
								  amountPrevYearTotal = 0;								  
								  
								  temp = DbCoa.list(0,0, "account_group='Fixed Assets' and status='HEADER'", "code");
								  
								  if(temp!=null && temp.size()>0){
								  
								  for(int i=0; i<temp.size(); i++){
								  	 Coa coa = (Coa)temp.get(i);
									 double amount = DbCoa.getCoaBalanceByHeader(coa.getOID(),"DC", idAccClass);
									 double amountPrevYear = DbCoa.getCoaBalanceByHeaderPrevYear(coa.getOID(),"DC", idAccClass);
									 
									 displayStr = strDisplay(amount, coa.getStatus());
									 displayStrPrevYear = strDisplay(amountPrevYear, coa.getStatus());
									 
									 amountTotal = amountTotal + amount;
								  	 amountPrevYearTotal = amountPrevYearTotal + amountPrevYear;
									 
									 //report
									 sesReport = new SesReportBs();																			 
									 sesReport.setDescription(switchLevel1(coa.getLevel())+coa.getCode()+" - "+coa.getName());
									 sesReport.setAmount(amount);
									 sesReport.setAmountPrevYear(amountPrevYear);
									 sesReport.setStrAmount(""+amount);
									 sesReport.setStrAmountPrevYear(""+amountPrevYear);
									 sesReport.setFont(0);	
									 listReport.add(sesReport);
									 
								  %>
                                        <tr> 
                                          <td width="51%" class="tablecell"><%=switchLevel(coa.getLevel())+coa.getCode()+" - "+coa.getName()%></td>
                                          <td width="25%" class="tablecell"> 
                                            <div align="right"><%=displayStrPrevYear%></div>
                                          </td>
                                          <td width="24%" class="tablecell"> 
                                            <div align="right"><%=displayStr%></div>
                                          </td>
                                        </tr>
                                        <%}}
										
										displayStrTotal = strDisplay(amountTotal, "HEADER");
									 	displayStrPrevYearTotal = strDisplay(amountPrevYearTotal, "HEADER");
										
										activaTotal = activaTotal + amountTotal;
								  		activaPrevYearTotal = activaPrevYearTotal + amountPrevYearTotal;
										
										//-----report
										sesReport = new SesReportBs();																				
										sesReport.setDescription("       TOTAL FIXED ASSET");
										sesReport.setAmount(amountTotal);
										sesReport.setAmountPrevYear(amountPrevYearTotal);
										sesReport.setStrAmount(""+amountTotal);
									 	sesReport.setStrAmountPrevYear(""+amountPrevYearTotal);
										sesReport.setFont(1);
										listReport.add(sesReport);
										
										%>
                                        <tr> 
                                          <td width="51%" class="tablecell1">&nbsp;</td>
                                          <td width="25%" class="tablecell1"> 
                                            <div align="right"><b><%=displayStrPrevYearTotal%></b></div>
                                          </td>
                                          <td width="24%" class="tablecell1"> 
                                            <div align="right"><b><%=displayStrTotal%></b></div>
                                          </td>
                                        </tr>
                                        <tr> 
                                          <td width="51%" class="tablecell1"><b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;OTHER 
                                            ASSET</b> </td>
                                          <td width="25%" class="tablecell1">&nbsp;</td>
                                          <td width="24%" class="tablecell1">&nbsp;</td>
                                        </tr>
                                        <%
										
										//-----report
										sesReport = new SesReportBs();										
										sesReport.setDescription("       OTHER ASSET");
										sesReport.setFont(1);
										listReport.add(sesReport);
								  
								  displayStr = "";
								  displayStrPrevYear = "";
								  
								  amountTotal = 0;
								  amountPrevYearTotal = 0;
								  
								  temp = DbCoa.list(0,0, "account_group='Other Assets' and status='HEADER'", "code");
								  
								  if(temp!=null && temp.size()>0){
								  
								  for(int i=0; i<temp.size(); i++){
								  	 Coa coa = (Coa)temp.get(i);
									 double amount = DbCoa.getCoaBalanceByHeader(coa.getOID(),"DC", idAccClass);
									 double amountPrevYear = DbCoa.getCoaBalanceByHeaderPrevYear(coa.getOID(),"DC", idAccClass);
									 
									 displayStr = strDisplay(amount, coa.getStatus());
									 displayStrPrevYear = strDisplay(amountPrevYear, coa.getStatus());
									 
									 amountTotal = amountTotal + amount;
								  	 amountPrevYearTotal = amountPrevYearTotal + amountPrevYear;
									 
									 //report
									 sesReport = new SesReportBs();																			 
									 sesReport.setDescription(switchLevel1(coa.getLevel())+coa.getCode()+" - "+coa.getName());
									 sesReport.setAmount(amount);
									 sesReport.setAmountPrevYear(amountPrevYear);
									 sesReport.setStrAmount(""+amount);
									 sesReport.setStrAmountPrevYear(""+amountPrevYear);
									 sesReport.setFont(0);
									 listReport.add(sesReport);
									 
								  %>
                                        <tr> 
                                          <td width="51%" class="tablecell"><%=switchLevel(coa.getLevel())+coa.getCode()+" - "+coa.getName()%></td>
                                          <td width="25%" class="tablecell"> 
                                            <div align="right"><%=displayStrPrevYear%></div>
                                          </td>
                                          <td width="24%" class="tablecell"> 
                                            <div align="right"><%=displayStr%></div>
                                          </td>
                                        </tr>
                                        <%}}
										
										displayStrTotal = strDisplay(amountTotal, "HEADER");
									 	displayStrPrevYearTotal = strDisplay(amountPrevYearTotal, "HEADER");
										
										activaTotal = activaTotal + amountTotal;
								  		activaPrevYearTotal = activaPrevYearTotal + amountPrevYearTotal;
										
										//-----report
										sesReport = new SesReportBs();																				
										sesReport.setDescription("       TOTAL OTHER ASSET");
										sesReport.setAmount(amountTotal);
										sesReport.setAmountPrevYear(amountPrevYearTotal);
										sesReport.setStrAmount(""+amountTotal);
									    sesReport.setStrAmountPrevYear(""+amountPrevYearTotal);
										sesReport.setFont(1);
										listReport.add(sesReport);
																				
										%>
                                        <tr> 
                                          <td width="51%" class="tablecell1">&nbsp;</td>
                                          <td width="25%" class="tablecell1"> 
                                            <div align="right"><%=displayStrPrevYearTotal%></div>
                                          </td>
                                          <td width="24%" class="tablecell1"> 
                                            <div align="right"><%=displayStrTotal%></div>
                                          </td>
                                        </tr>
                                        <%
										displayStrTotal = strDisplay(activaTotal, "HEADER");
									 	displayStrPrevYearTotal = strDisplay(activaPrevYearTotal, "HEADER");
										
										//-----report
										sesReport = new SesReportBs();																				
										sesReport.setDescription("TOTAL ACTIVA");
										sesReport.setAmount(activaTotal);
										sesReport.setAmountPrevYear(activaPrevYearTotal);
										sesReport.setStrAmount(""+activaTotal);
									    sesReport.setStrAmountPrevYear(""+activaPrevYearTotal);
										sesReport.setFont(1);
										listReport.add(sesReport);
										
										//-----report
										sesReport = new SesReportBs();										
										sesReport.setType("0");
										sesReport.setDescription("");
										listReport.add(sesReport);
										
										//-----report
										sesReport = new SesReportBs();										
										sesReport.setType("0");
										sesReport.setDescription("");
										listReport.add(sesReport);
										
										%>
                                        <tr> 
                                          <td width="51%" class="level2"><b>TOTAL 
                                            ACTIVA</b></td>
                                          <td width="25%" class="level2"> 
                                            <div align="right"><b><%=displayStrPrevYearTotal%></b></div>
                                          </td>
                                          <td width="24%" class="level2"> 
                                            <div align="right"><b><%=displayStrTotal%></b></div>
                                          </td>
                                        </tr>
                                        <tr bgcolor="#CCCCCC"> 
                                          <td width="51%" height="3"></td>
                                          <td width="25%" height="3"></td>
                                          <td width="24%" height="3"></td>
                                        </tr>
                                        <tr> 
                                          <td width="51%" class="level2">&nbsp;</td>
                                          <td width="25%">&nbsp;</td>
                                          <td width="24%">&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td width="51%" class="level2"><b>PASIVA</b></td>
                                          <td width="25%" class="level2">&nbsp;</td>
                                          <td width="24%" class="level2">&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td width="51%" class="tablecell1"><b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;LIABILITIES</b></td>
                                          <td width="25%" class="tablecell1">&nbsp;</td>
                                          <td width="24%" class="tablecell1">&nbsp;</td>
                                        </tr>
                                        <%
										
										//-----report
										sesReport = new SesReportBs();																				
										sesReport.setDescription("PASIVA");										
										sesReport.setFont(1);
										listReport.add(sesReport);
										
										//-----report
										sesReport = new SesReportBs();																				
										sesReport.setDescription("       LIABILITIES");									
										sesReport.setFont(1);
										listReport.add(sesReport);
										
								  
								  displayStr = "";
								  displayStrPrevYear = "";
								  
								  amountTotal = 0;
								  amountPrevYearTotal = 0;
								  activaTotal = 0;
								  activaPrevYearTotal = 0;
								  
								  temp = DbCoa.list(0,0, "(account_group='Current Liabilities' or account_group='Long Term Liabilities') and status='HEADER'", "code");
								  
								  if(temp!=null && temp.size()>0){
								  
								  for(int i=0; i<temp.size(); i++){
								  	 Coa coa = (Coa)temp.get(i);
									 double amount = DbCoa.getCoaBalanceByHeader(coa.getOID(),"CD", idAccClass);
									 double amountPrevYear = DbCoa.getCoaBalanceByHeaderPrevYear(coa.getOID(),"CD", idAccClass);
									 
									 displayStr = strDisplay(amount, coa.getStatus());
									 displayStrPrevYear = strDisplay(amountPrevYear, coa.getStatus());
									 
									 amountTotal = amountTotal + amount;
								  	 amountPrevYearTotal = amountPrevYearTotal + amountPrevYear;
									 
									 //report
									 sesReport = new SesReportBs();																			 
									 sesReport.setDescription(switchLevel1(coa.getLevel())+coa.getCode()+" - "+coa.getName());
									 sesReport.setAmount(amount);
									 sesReport.setAmountPrevYear(amountPrevYear);
									 sesReport.setStrAmount(""+amount);
									 sesReport.setStrAmountPrevYear(""+amountPrevYear);
									 sesReport.setFont(0);
									 listReport.add(sesReport);
								  %>
                                        <tr> 
                                          <td width="51%" class="tablecell"><%=switchLevel(coa.getLevel())+coa.getCode()+" - "+coa.getName()%></td>
                                          <td width="25%" class="tablecell"> 
                                            <div align="right"><%=displayStrPrevYear%></div>
                                          </td>
                                          <td width="24%" class="tablecell"> 
                                            <div align="right"><%=displayStr%></div>
                                          </td>
                                        </tr>
                                        <%}}
																				
										displayStrTotal = strDisplay(amountTotal, "HEADER");
									 	displayStrPrevYearTotal = strDisplay(amountPrevYearTotal, "HEADER");
										
										activaTotal = activaTotal + amountTotal;
								  		activaPrevYearTotal = activaPrevYearTotal + amountPrevYearTotal;
										
										//-----report
										sesReport = new SesReportBs();																				
										sesReport.setDescription("       TOTAL LIABILITIES");
										sesReport.setAmount(amountTotal);
										sesReport.setAmountPrevYear(amountPrevYearTotal);
										sesReport.setStrAmount(""+amountTotal);
									    sesReport.setStrAmountPrevYear(""+amountPrevYearTotal);
										sesReport.setFont(1);
										listReport.add(sesReport);
										
										%>
                                        <tr> 
                                          <td width="51%" class="tablecell1">&nbsp;</td>
                                          <td width="25%" class="tablecell1"> 
                                            <div align="right"><b><%=displayStrPrevYearTotal%></b></div>
                                          </td>
                                          <td width="24%" class="tablecell1"> 
                                            <div align="right"><b><%=displayStrTotal%></b></div>
                                          </td>
                                        </tr>
                                        <tr> 
                                          <td width="51%" class="tablecell1"><b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;EQUITY</b></td>
                                          <td width="25%" class="tablecell1">&nbsp;</td>
                                          <td width="24%" class="tablecell1">&nbsp;</td>
                                        </tr>
                                        <%
										
										//-----report
										sesReport = new SesReportBs();																				
										sesReport.setDescription("       EQUITY");									
										sesReport.setFont(1);
										listReport.add(sesReport);
								  
								  displayStr = "";
								  displayStrPrevYear = "";
								  
								  amountTotal = 0;
								  amountPrevYearTotal = 0;
								  
								  temp = DbCoa.list(0,0, "(account_group='Equity') and status='HEADER'", "code");
								  
								  if(temp!=null && temp.size()>0){
								  
								  for(int i=0; i<temp.size(); i++){
								  	 Coa coa = (Coa)temp.get(i);
									 
									 double amount = 0;
									 double amountPrevYear = 0;
									 
									 if (!coa.getCode().equals(DbSystemProperty.getValueByName("ID_HEADER_CURRENT_EARNING"))){
												amount = DbCoa.getCoaBalanceByHeader(coa.getOID(),"CD", idAccClass);																				
												amountPrevYear = DbCoa.getCoaBalanceByHeaderPrevYear(coa.getOID(),"CD", idAccClass);
									 }									
									 else if(coa.getCode().equals(DbSystemProperty.getValueByName("ID_HEADER_CURRENT_EARNING"))){
												//ID_RETAINED_EARNINGS
												double totalIncome = 0;								
												double totalIncomePrevYear = 0;								
												Coa coax = new Coa();
												
												Vector listCoa = DbCoa.list(0,0, "account_group='Revenue' or account_group='Expense' or account_group='Other Revenue' or account_group='Other Expense'", "code");
												
												for(int ix=0; ix<listCoa.size(); ix++){											
													
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
													
																																	
															if (coax.getAccountGroup().equals(I_Project.ACC_GROUP_REVENUE))	{																
																totalIncome = totalIncome + DbCoa.getCoaBalanceCD(coax.getOID());	
																totalIncomePrevYear = totalIncomePrevYear + DbCoa.getCoaBalanceCDPrevYear(coax.getOID());	
																
															}else if (coax.getAccountGroup().equals(I_Project.ACC_GROUP_COST_OF_SALES))	{
																totalIncome = totalIncome - DbCoa.getCoaBalance(coax.getOID());	
																totalIncomePrevYear = totalIncomePrevYear - DbCoa.getCoaBalancePrevYear(coax.getOID());	
															}else if (coax.getAccountGroup().equals(I_Project.ACC_GROUP_EXPENSE))	{
																totalIncome = totalIncome - DbCoa.getCoaBalance(coax.getOID());	
																totalIncomePrevYear = totalIncomePrevYear - DbCoa.getCoaBalancePrevYear(coax.getOID());	
															}else if (coax.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_REVENUE))	{
																totalIncome = totalIncome + DbCoa.getCoaBalanceCD(coax.getOID());	
																totalIncomePrevYear = totalIncomePrevYear + DbCoa.getCoaBalanceCDPrevYear(coax.getOID());	
															}else if (coax.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_EXPENSE))	{
																totalIncome = totalIncome - DbCoa.getCoaBalance(coax.getOID());	
																totalIncomePrevYear = totalIncomePrevYear - DbCoa.getCoaBalancePrevYear(coax.getOID());	
															}
													}
												}//end for									
												
												amount = totalIncome + DbCoaOpeningBalance.getOpeningBalanceByHeader(periode, coa.getOID(), idAccClass);
												amountPrevYear = totalIncomePrevYear + DbCoaOpeningBalance.getOpeningBalanceByHeaderPrevYear(periode, coa.getOID(), idAccClass);
												
									 }
									 else{
									 	amount = DbCoa.getCoaBalanceByHeader(coa.getOID(),"CD", idAccClass);
									 	amountPrevYear = DbCoa.getCoaBalanceByHeaderPrevYear(coa.getOID(),"CD", idAccClass);
									 }
									
									 displayStr = strDisplay(amount, coa.getStatus());
									 displayStrPrevYear = strDisplay(amountPrevYear, coa.getStatus()); 
									 
									 amountTotal = amountTotal + amount;
								  	 amountPrevYearTotal = amountPrevYearTotal + amountPrevYear;
									 
									 //report
									 sesReport = new SesReportBs();																			 
									 sesReport.setDescription(switchLevel1(coa.getLevel())+coa.getCode()+" - "+coa.getName());
									 sesReport.setAmount(amount);
									 sesReport.setAmountPrevYear(amountPrevYear);
									 sesReport.setStrAmount(""+amount);
									 sesReport.setStrAmountPrevYear(""+amountPrevYear);
									 sesReport.setFont(0);
									 listReport.add(sesReport);
									 
								  %>
                                        <tr> 
                                          <td width="51%" class="tablecell"><%=switchLevel(coa.getLevel())+coa.getCode()+" - "+coa.getName()%></td>
                                          <td width="25%" class="tablecell"> 
                                            <div align="right"><%=displayStrPrevYear%></div>
                                          </td>
                                          <td width="24%" class="tablecell"> 
                                            <div align="right"><%=displayStr%></div>
                                          </td>
                                        </tr>
                                        <%}}
																				
										displayStrTotal = strDisplay(amountTotal, "HEADER");
									 	displayStrPrevYearTotal = strDisplay(amountPrevYearTotal, "HEADER");
										
										activaTotal = activaTotal + amountTotal;
								  		activaPrevYearTotal = activaPrevYearTotal + amountPrevYearTotal;
										
										//-----report
										sesReport = new SesReportBs();																				
										sesReport.setDescription("       TOTAL EQUITY");
										sesReport.setAmount(amountTotal);
										sesReport.setAmountPrevYear(amountPrevYearTotal);
										sesReport.setStrAmount(""+amountTotal);
									    sesReport.setStrAmountPrevYear(""+amountPrevYearTotal);
										sesReport.setFont(1);
										listReport.add(sesReport); 
										
										//-----report
										sesReport = new SesReportBs();																				
										sesReport.setDescription("TOTAL PASIVA");
										sesReport.setAmount(activaTotal);
										sesReport.setAmountPrevYear(activaPrevYearTotal);
										sesReport.setStrAmount(""+activaTotal);
									    sesReport.setStrAmountPrevYear(""+activaPrevYearTotal);
										sesReport.setFont(1);
										listReport.add(sesReport); 
										%>
                                        <tr> 
                                          <td width="51%" class="tablecell1">&nbsp;</td>
                                          <td width="25%" class="tablecell1"> 
                                            <div align="right"><b><%=displayStrPrevYearTotal%></b></div>
                                          </td>
                                          <td width="24%" class="tablecell1"> 
                                            <div align="right"><b><%=displayStrTotal%></b></div>
                                          </td>
                                        </tr>
                                        <%
										displayStrTotal = strDisplay(activaTotal, "HEADER");
									 	displayStrPrevYearTotal = strDisplay(activaPrevYearTotal, "HEADER");
										
										%>
                                        <tr> 
                                          <td width="51%" class="level2"><b>TOTAL 
                                            PASIVA</b></td>
                                          <td width="25%" class="level2"> 
                                            <div align="right"><b><%=displayStrPrevYearTotal%></b></div>
                                          </td>
                                          <td width="24%" class="level2"> 
                                            <div align="right"><b><%=displayStrTotal%></b></div>
                                          </td>
                                        </tr>
										<tr bgcolor="#CCCCCC"> 
                                          <td width="51%" height="3"></td>
                                          <td width="25%" height="3"></td>
                                          <td width="24%" height="3"></td>
                                        </tr>
                                        <tr> 
                                          <td width="51%">&nbsp;</td>
                                          <td width="25%">&nbsp;</td>
                                          <td width="24%">&nbsp;</td>
                                        </tr>
                                        <tr align="left" valign="top"> 
                              <td height="8" valign="middle" colspan="3" class="container"> 
                                <%
								
								session.putValue("BS_STANDARD", listReport);
								
								//if(listCoa!=null && listCoa.size()>0){%>
                                <table width="200" border="0" cellspacing="0" cellpadding="0">
                                  <tr> 
                                    <td width="60"><a href="javascript:cmdPrintJournal()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('print','','../images/print2.gif',1)"><img src="../images/print.gif" name="print" width="53" height="22" border="0"></a></td>
                                    <td width="0">&nbsp;</td>
                                    <td width="120"><a href="javascript:cmdPrintJournalXLS()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('printxls','','../images/printxls2.gif',1)"><img src="../images/printxls.gif" name="printxls" width="120" height="22" border="0"></a></td>
                                    <td width="20">&nbsp;</td>
                                  </tr>
                                </table>
                                <%//}
								
								%>
                              </td>
                            </tr>
                                        <tr> 
                                          <td width="51%">&nbsp;</td>
                                          <td width="25%">&nbsp;</td>
                                          <td width="24%">&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td width="51%">&nbsp;</td>
                                          <td width="25%">&nbsp;</td>
                                          <td width="24%">&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td width="51%">&nbsp;</td>
                                          <td width="25%">&nbsp;</td>
                                          <td width="24%">&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td width="51%">&nbsp;</td>
                                          <td width="25%">&nbsp;</td>
                                          <td width="24%">&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td width="51%">&nbsp;</td>
                                          <td width="25%">&nbsp;</td>
                                          <td width="24%">&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td width="51%">&nbsp;</td>
                                          <td width="25%">&nbsp;</td>
                                          <td width="24%">&nbsp;</td>
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
                          </table></td>
  </tr>
</table>
                         <%
								session.putValue("BS_STANDARD", listReport);							
								//out.println(listReport);
						%> 
                        </form>
                        <!-- #EndEditable --> </td>
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
          <td height="25"> <!-- #BeginEditable "footer" --> 
            <%@ include file="../main/footer.jsp"%>
            <!-- #EndEditable --> </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
</body>
<!-- #EndTemplate -->
</html>
