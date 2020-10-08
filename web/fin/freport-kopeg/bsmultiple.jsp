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
	public boolean LoadValue(long coaId, Vector temp, String type){
		boolean x = false;
		if(temp!=null && temp.size()>0){
			for(int ix=0; ix<temp.size(); ix++){	
				Periode per = (Periode)temp.get(ix);
				double xx = 0;
				if(type.equals("CD")){
					xx = DbCoa.getCoaBalanceCD(coaId, per);									
				}else{
					xx = DbCoa.getCoaBalance(coaId, per);									
				}
				if(xx!=0){					
					x = true;		
				}
			}
		}
		return x;	
	}
	
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
	
	public String strDisplay(double amount){
		String displayStr = "";
		if(amount<0)
			displayStr = "("+JSPFormater.formatNumber(amount*-1,"#,###.##")+")";
		else if(amount>0)										
			displayStr = JSPFormater.formatNumber(amount,"#,###.##");
		else if(amount==0)
			displayStr = "";		
		return displayStr;
	}
	
	public double getTotalLiqAssetByPeriod(Vector liqAssetx, Periode periode){
		double result = 0;
		for(int i=0; i<liqAssetx.size(); i++){
			Coa coa = (Coa)liqAssetx.get(i);
			result = result + DbCoa.getCoaBalance(coa.getOID(), periode);
		}
		
		return result;
	}
	
	public double getTotalFixAssetByPeriod(Vector fixAssetx, Periode periode){
		double result = 0;
		for(int i=0; i<fixAssetx.size(); i++){
			Coa coa = (Coa)fixAssetx.get(i);
			result = result + DbCoa.getCoaBalance(coa.getOID(), periode);
		}
		
		return result;
	}
	
	public double getTotalOthAssetByPeriod(Vector othAssetx, Periode periode){
		double result = 0;
		for(int i=0; i<othAssetx.size(); i++){
			Coa coa = (Coa)othAssetx.get(i);
			result = result + DbCoa.getCoaBalance(coa.getOID(), periode);
		}
		
		return result;
	}
	
	public double getTotalCurrLibByPeriod(Vector currLibx, Periode periode){
		double result = 0;
		for(int i=0; i<currLibx.size(); i++){
			Coa coa = (Coa)currLibx.get(i);
			result = result + DbCoa.getCoaBalanceCD(coa.getOID(), periode);
		}
		
		return result;
	}
	
	public double getTotalLongLibByPeriod(Vector longLibx, Periode periode){
		double result = 0;
		for(int i=0; i<longLibx.size(); i++){
			Coa coa = (Coa)longLibx.get(i);
			result = result + DbCoa.getCoaBalanceCD(coa.getOID(), periode);
		}
		
		return result;
	}
	
	public double getTotalEquityByPeriod(Vector equityx, Periode periode){
		
		double result = 0;
		Vector listCoa = DbCoa.list(0,0, "", "");
		double amountX = 0;
		
		for(int i=0; i<equityx.size(); i++){
			Coa coa = (Coa)equityx.get(i);
			
			System.out.println("\n\n=======***************** ========== coa : "+coa.getCode()+"-"+coa.getName());
	
			//DbCoa.getCoaBalanceCD(coa.getOID(), periode);
														
			//ID_RETAINED_EARNINGS => pake 'S' ini adalah current year earning
			//akan mencari P&L yang sekarang
			if(coa.getCode().equals(DbSystemProperty.getValueByName("ID_RETAINED_EARNINGS")))
			{
				double totalIncome = 0;								
				Coa coax = new Coa();
				for(int zx=0; zx<listCoa.size(); zx++)
				{											
					coax= (Coa)listCoa.get(zx);
					//revenue -> Credit - Debet																			
					if (coax.getAccountGroup().equals(I_Project.ACC_GROUP_REVENUE))
					{
						totalIncome = totalIncome + DbCoa.getCYEarningCoaBalanceCD(coax.getOID(), periode);	
					}
					//cogs -> Debet - Credit
					else if (coax.getAccountGroup().equals(I_Project.ACC_GROUP_COST_OF_SALES))
					{
						totalIncome = totalIncome - DbCoa.getCYEarningCoaBalance(coax.getOID(), periode);	
					}
					//expense - > Debet - Credit
					else if (coax.getAccountGroup().equals(I_Project.ACC_GROUP_EXPENSE))
					{
						totalIncome = totalIncome - DbCoa.getCYEarningCoaBalance(coax.getOID(), periode);	
					}
					//other revenue -> Credit - Debet
					else if (coax.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_REVENUE))
					{
						totalIncome = totalIncome + DbCoa.getCYEarningCoaBalanceCD(coax.getOID(), periode);	
					}
					//other expe -> Debet -Credit
					else if (coax.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_EXPENSE))
					{
						totalIncome = totalIncome - DbCoa.getCYEarningCoaBalance(coax.getOID(), periode);	
					}
				}									
				amountX = amountX + totalIncome;										
			}
			// Bagining Balance
			// ID_BEGINING_BALANCE = Retained earning
			else if(coa.getCode().equals(DbSystemProperty.getValueByName("ID_BEGINING_BALANCE")))
			{
				amountX = amountX + DbCoa.getCoaBalance(coa.getOID(),periode);//getSumOpeningBalance();										
			}
			else{
				amountX = amountX + DbCoa.getCoaBalanceCD(coa.getOID(), periode);
			}
			
			System.out.println("amountX : "+amountX);
			
		}
		
		return result = amountX;
		
	}

%>
<%
	if(session.getValue("BS_MULTIPLE")!=null){
		session.removeValue("BS_MULTIPLE");
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
	String displayStr = "";																
	double coaSummary1 = 0;
	double coaSummary2 = 0;
	double coaSummary3 = 0;
	double coaSummary4 = 0;
	double coaSummary5 = 0;			
	double coaSummary6 = 0;
	Vector listReport = new Vector();
	SesReportBs sesReport = new SesReportBs();	
	Vector vSesDep = new Vector();	
	
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
	boolean hasValue = false;

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
	document.frmcoa.action="bsmultiple.jsp";
	document.frmcoa.submit();
}

function cmdChangeYear(){
	document.frmcoa.command.value="<%=JSPCommand.LIST%>";
	document.frmcoa.action="bsmultiple.jsp";
	document.frmcoa.submit();
}

function cmdPrintJournal(){	 
	window.open("<%=printroot%>.report.RptBSMultiplePDF?oid=<%=appSessUser.getLoginId()%>&year=<%=yearselect%>");
}

function cmdPrintJournalXLS(){	 
	window.open("<%=printroot%>.report.RptBSMultipleXLS?oid=<%=appSessUser.getLoginId()%>&year=<%=yearselect%>");
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
					  String navigator = "<font class=\"lvl1\">Financial Report</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">Balance Sheet by Multiple Period</span></font>";
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
						  
						  <%
						  try{
						  %>
						  
                          <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr align="left" valign="top"> 
                              <td height="8"  colspan="3" class="container"> 
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                  <tr align="left" valign="top"> 
                                    <td height="8" valign="middle" colspan="3"></td>
                                  </tr>
                                  <tr align="left" valign="top"> 
                                    <td width="6%">Show List </td>
                                    <td width="94%" colspan="2"> 
                                      <select name="showlist" onChange="javascript:cmdChangeList()">
                                        <option value="1" <%if(valShowList==1){%>selected<%}%>>Hide 
                                        Acc. Without Transaction</option>
                                        <option value="2" <%if(valShowList==2){%>selected<%}%>>All</option>
                                      </select>
                                    </td>
                                  </tr>
                                  <tr align="left" valign="top"> 
                                    <td height="20" valign="middle" align="center" colspan="3"> 
                                      <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                        <tr> 
                                          <td width="26%"> 
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                              <tr> 
                                                <td width="23%">Year</td>
                                                <td width="44%"> 
                                                  <select name="year" onChange="javascript:cmdChangeYear()">
                                                    <option value="<%=year%>" <%if(year==yearselect){%>selected<%}%>><%=(year+1900)%></option>
                                                    <option value="<%=year-1%>" <%if((year-1)==yearselect){%>selected<%}%>><%=year-1+1900%></option>
                                                    <option value="<%=year-2%>" <%if((year-2)==yearselect){%>selected<%}%>><%=year-2+1900%></option>
                                                  </select>
                                                </td>
                                                <td width="33%">&nbsp;</td>
                                              </tr>
                                            </table>
                                          </td>
                                          <td width="48%"> 
                                            <div align="center"><span class="level1"><font size="+1"><b>BALANCE 
                                              SHEET</b></font></span></div>
                                          </td>
                                          <td width="26%">&nbsp;</td>
                                        </tr>
                                      </table>
                                    </td>
                                  </tr>
                                  <%
								  	Periode periode = DbPeriode.getOpenPeriod();
									String openPeriod = JSPFormater.formatDate(periode.getStartDate(), "dd MMM yyyy")+ " - " + JSPFormater.formatDate(periode.getEndDate(), "dd MMM yyyy");        
								  %>
                                  <tr align="left" valign="top"> 
                                    <td height="20" valign="middle" align="center" colspan="3"><span class="level1"><b>MULTIPLE 
                                      PERIODS</b></span></td>
                                  </tr>
                                  <tr align="left" valign="top"> 
                                    <td height="10" valign="middle" colspan="3"></td>
                                  </tr>
								  <%
								  //jika ada periode pada tahun yang dipilih ...
								  if(temp!=null && temp.size()>0){%>
								  <tr align="left" valign="top"> 
                                    <td height="10" valign="middle" colspan="3" class="page">
                                      <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                        <tr> 
                                          <td class="tablehdr" height="20" width="300">Description</td>
                                          <%for(int ix=0; ix<temp.size(); ix++){
										  		Periode per = (Periode)temp.get(ix);	
										  %>
                                          <td class="tablehdr" width="150" height="20"><%=per.getName()%></td>
                                          <%}%>
                                        </tr>
                                        <tr> 
                                          <td class="tablecell"><b>Activa</b></td>
                                          <%for(int ix=0; ix<temp.size(); ix++){
										  		Periode per = (Periode)temp.get(ix);	
										  %>
                                          <td width="150" class="tablecell"> 
                                            <div align="right"></div>
                                          </td>
                                          <%}%>
                                        </tr>
                                        <%
										
										//----- liquid asset -------
											//add Top Header
											sesReport = new SesReportBs();
											sesReport.setType("Top Level");
											sesReport.setDescription("Activa");
											sesReport.setFont(1);
											vSesDep = new Vector();
											for(int ix=0; ix<temp.size(); ix++){
												Periode per = (Periode)temp.get(ix);													
												vSesDep.add("0");
											}
											sesReport.setDepartment(vSesDep);
											listReport.add(sesReport);										
										
										if(DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_LIQUID_ASSET,"DC", temp)!=0 || valShowList!=1)
										{	//add Group Header
											sesReport = new SesReportBs();										
											sesReport.setType("Group Level");
											sesReport.setDescription(strTotal1+I_Project.ACC_GROUP_LIQUID_ASSET);
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
                                          <td class="tablecell"><b><%=strTotal+I_Project.ACC_GROUP_LIQUID_ASSET%></b></td>
                                          <%for(int ix=0; ix<temp.size(); ix++){
										  		Periode per = (Periode)temp.get(ix);	
										  %>
                                          <td width="150" class="tablecell"> 
                                            <div align="right"></div>
                                          </td>
                                          <%}%>
                                        </tr>
                                        <%}%>
                                        <%
										
										Vector liqAssetx = DbCoa.list(0,0, "account_group='"+I_Project.ACC_GROUP_LIQUID_ASSET+"'", "code");
										
										if(liqAssetx!=null && liqAssetx.size()>0)
										{
											String str = "";
											String str1 = "";
											for(int i=0; i<liqAssetx.size(); i++)
											{
												coa = (Coa)liqAssetx.get(i);								
												
												//if (coa.getAccountGroup().equals(I_Project.ACC_GROUP_LIQUID_ASSET))
												//{
													str = switchLevel(coa.getLevel());
													str1 = switchLevel1(coa.getLevel());
													double amount = DbCoa.getCoaBalance(coa.getOID(), temp);
													coaSummary1 = coaSummary1 + amount;
													//displayStr = strDisplay(amount, coa.getStatus());								
													if (valShowList==1)
													{
														if ((coa.getStatus().equals("HEADER") && DbCoa.getCoaBalanceByHeader(coa.getOID(),"DC", temp)!=0) || ((!coa.getStatus().equals("HEADER")) && amount!=0))
														{	//add detail
															sesReport = new SesReportBs();
															sesReport.setType(coa.getStatus());
															sesReport.setDescription(strTotal1+strTotal1+str1+coa.getCode()+" - "+coa.getName());
															sesReport.setFont(coa.getStatus().equals("HEADER") ? 1 : 0);
															vSesDep = new Vector();
															for(int ix=0; ix<temp.size(); ix++){
																Periode per = (Periode)temp.get(ix);													
																vSesDep.add(""+DbCoa.getCoaBalance(coa.getOID(), per));
															}
															sesReport.setDepartment(vSesDep);			
															listReport.add(sesReport);														
									 	%>
                                        <tr> 
                                          <td class="tablecell1"> 
                                            <%if(coa.getStatus().equals("HEADER")){ %>
                                            <b> 
                                            <%}%>
                                            <%=strTotal+strTotal+str+coa.getCode()+" - "+coa.getName()%> 
                                            <%if(coa.getStatus().equals("HEADER")){ %>
                                            </b> 
                                            <%}%>
                                          </td>
                                          <%for(int ix=0; ix<temp.size(); ix++){
												Periode per = (Periode)temp.get(ix);
												double liqAsset = DbCoa.getCoaBalance(coa.getOID(), per);
												displayStr = strDisplay(liqAsset, coa.getStatus());	
										  %>
                                          <td width="150" class="tablecell1"> 
                                            <div align="right"><%=displayStr%>&nbsp;&nbsp;</div>
                                          </td>
                                          <%}%>
                                        </tr>
                                        <%
														}
													}
													else{
														if ((coa.getStatus().equals("HEADER")) || ((!coa.getStatus().equals("HEADER")) && amount!=0)){	
														//add detail
															sesReport = new SesReportBs();
															sesReport.setType(coa.getStatus());
															sesReport.setDescription(strTotal1+strTotal1+str1+coa.getCode()+" - "+coa.getName());
															sesReport.setFont(coa.getStatus().equals("HEADER") ? 1 : 0);
															vSesDep = new Vector();
															for(int ix=0; ix<temp.size(); ix++){
																Periode per = (Periode)temp.get(ix);													
																vSesDep.add(""+DbCoa.getCoaBalance(coa.getOID(), per));
															}
															sesReport.setDepartment(vSesDep);			
															listReport.add(sesReport);														
											  %>
                                        <tr> 
                                          <td nowrap class="tablecell1"> 
                                            <%if(coa.getStatus().equals("HEADER")){ %>
                                            <b> 
                                            <%}%>
                                            <%=strTotal+strTotal+str+coa.getCode()+" - "+coa.getName()%> 
                                            <%if(coa.getStatus().equals("HEADER")){ %>
                                            </b> 
                                            <%}%>
                                          </td>
                                          <%for(int ix=0; ix<temp.size(); ix++){
												Periode per = (Periode)temp.get(ix);
												double liqAsset = DbCoa.getCoaBalance(coa.getOID(), per);
												displayStr = strDisplay(liqAsset, coa.getStatus());		
										  %>
                                          <td width="150" class="tablecell1"> 
                                            <div align="right"><%=displayStr%><%//=(liqAsset==0) ? "" : JSPFormater.formatNumber(liqAsset, "#,###.##")%>&nbsp;&nbsp;</div>
                                          </td>
                                          <%}%>
                                        </tr>
                                        <%					
														}			
													}
												//}
											
											}				//add footer level
											
											if(DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_LIQUID_ASSET,"DC", temp)!=0 || valShowList!=1)
											{	//add Group Footer
												sesReport = new SesReportBs();										
												sesReport.setType("Footer Group Level");
												sesReport.setDescription(strTotal1+"Sub Total "+I_Project.ACC_GROUP_LIQUID_ASSET);
												sesReport.setFont(1);
												vSesDep = new Vector();
												for(int ix=0; ix<temp.size(); ix++){
													Periode per = (Periode)temp.get(ix);													
													vSesDep.add(""+getTotalLiqAssetByPeriod(liqAssetx, per));
												}
												sesReport.setDepartment(vSesDep);																											
												listReport.add(sesReport);								
										%>
                                        <tr> 
                                          <td><span class="level2"><b><%=strTotal+"Sub Total "+I_Project.ACC_GROUP_LIQUID_ASSET%></b></span></td>
                                          <%for(int ix=0; ix<temp.size(); ix++){
												Periode per = (Periode)temp.get(ix);
												double totalLiqAsset = getTotalLiqAssetByPeriod(liqAssetx, per);
												displayStr = strDisplay(totalLiqAsset);			
										  %>
                                          <td width="150"> 
                                            <div align="right"><b><%=displayStr%><%//=(totalLiqAsset==0) ? "" : JSPFormater.formatNumber(totalLiqAsset, "#,###.##")%>&nbsp;&nbsp;</b></div>
                                          </td>
                                          <%}%>
                                        </tr>
                                        <%	
											}
										}
										
										//---------------end liquid asses --------
									    %>
                                        <%
										
										//--------------- start of fixed asset --------
										
										Vector fixAssetx = DbCoa.list(0,0, "account_group='"+I_Project.ACC_GROUP_FIXED_ASSET+"'", "code");
										
										System.out.println("\n=====fixAssetx : "+fixAssetx.size());
										//System.out.println("=====DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_FIXED_ASSET,\"DC\", temp) : "+(DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_FIXED_ASSET,"DC", temp)));
										
										if(DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_FIXED_ASSET,"DC", temp)!=0 || valShowList!=1)
										{	//add Group Header
											sesReport = new SesReportBs();										
											sesReport.setType("Group Level");
											sesReport.setDescription(strTotal1+I_Project.ACC_GROUP_FIXED_ASSET);
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
                                          <td class="tablecell"><b><%=strTotal+I_Project.ACC_GROUP_FIXED_ASSET%> </b></td>
                                          <%for(int ix=0; ix<temp.size(); ix++){
												Periode per = (Periode)temp.get(ix);	
										  %>
                                          <td width="150" class="tablecell"> 
                                            <div align="right"></div>
                                          </td>
                                          <%}%>
                                        </tr>
                                        <%	}	%>
                                        <%
										if(fixAssetx!=null && fixAssetx.size()>0)
										{
											String str = "";
											String str1 = "";							
											for(int i=0; i<fixAssetx.size(); i++)
											{
												coa = (Coa)fixAssetx.get(i);
												
												//System.out.println("fix assest coa : "+coa.getCode()+" - "+coa.getName());								
												
												if (coa.getAccountGroup().equals(I_Project.ACC_GROUP_FIXED_ASSET))
												{
													str = switchLevel(coa.getLevel());
													str1 = switchLevel1(coa.getLevel());
													double amount = DbCoa.getCoaBalance(coa.getOID(), temp);
													
												
													if (valShowList==1)
													{
														if ((coa.getStatus().equals("HEADER") && DbCoa.getCoaBalanceByHeader(coa.getOID(),"DC", temp)!=0) || ((!coa.getStatus().equals("HEADER")) && amount!=0))
														{	//add detail
															sesReport = new SesReportBs();
															sesReport.setType(coa.getStatus());
															sesReport.setDescription(strTotal1+strTotal1+str1+coa.getCode()+" - "+coa.getName());
															sesReport.setFont(coa.getStatus().equals("HEADER") ? 1 : 0);											
															vSesDep = new Vector();
															for(int ix=0; ix<temp.size(); ix++){
																Periode per = (Periode)temp.get(ix);													
																vSesDep.add(""+DbCoa.getCoaBalance(coa.getOID(), per));
															}
															sesReport.setDepartment(vSesDep);			
															listReport.add(sesReport);														
											  %>
                                        <tr> 
                                          <td class="tablecell1" nowrap> 
                                            <%if(coa.getStatus().equals("HEADER")){ %>
                                            <b> 
                                            <%}%>
                                            <%=strTotal+strTotal+str+coa.getCode()+" - "+coa.getName()%> 
                                            <%if(coa.getStatus().equals("HEADER")){ %>
                                            </b> 
                                            <%}%>
                                          </td>
                                          <%for(int ix=0; ix<temp.size(); ix++){
																Periode per = (Periode)temp.get(ix);
																double fixAsset = DbCoa.getCoaBalance(coa.getOID(), per);		
																displayStr = strDisplay(fixAsset, coa.getStatus());			
															  %>
                                          <td width="150" class="tablecell1"> 
                                            <div align="right"> 
                                              <div align="right"><%=displayStr%><%//=(fixAsset==0) ? "" : JSPFormater.formatNumber(fixAsset, "#,###.##")%>&nbsp;&nbsp;</div>
                                            </div>
                                          </td>
                                          <%}%>
                                        </tr>
                                        <%		}
													}else{
														if ((coa.getStatus().equals("HEADER")) || ((!coa.getStatus().equals("HEADER")) && amount!=0))
														{	//add detail
															sesReport = new SesReportBs();
															sesReport.setType(coa.getStatus());
															sesReport.setDescription(strTotal1+strTotal1+str1+coa.getCode()+" - "+coa.getName());
															sesReport.setFont(coa.getStatus().equals("HEADER") ? 1 : 0);											
															vSesDep = new Vector();
															for(int ix=0; ix<temp.size(); ix++){
																Periode per = (Periode)temp.get(ix);													
																vSesDep.add(""+DbCoa.getCoaBalance(coa.getOID(), per));
															}
															sesReport.setDepartment(vSesDep);			
															listReport.add(sesReport);														
														%>
                                        <tr> 
                                          <td class="tablecell1" nowrap> 
                                            <%if(coa.getStatus().equals("HEADER")){ %>
                                            <b> 
                                            <%}%>
                                            <%=strTotal+strTotal+str+coa.getCode()+" - "+coa.getName()%> 
                                            <%if(coa.getStatus().equals("HEADER")){ %>
                                            </b> 
                                            <%}%>
                                          </td>
                                          <%for(int ix=0; ix<temp.size(); ix++){
																Periode per = (Periode)temp.get(ix);
																double fixAsset = DbCoa.getCoaBalance(coa.getOID(), per);			
																displayStr = strDisplay(fixAsset, coa.getStatus());			
															  %>
                                          <td width="150" class="tablecell1"> 
                                            <div align="right"> 
                                              <div align="right"><%=displayStr%><%//=(fixAsset==0) ? "" : JSPFormater.formatNumber(fixAsset, "#,###.##")%>&nbsp;&nbsp;</div>
                                            </div>
                                          </td>
                                          <%}%>
                                        </tr>
													<%
														}
													}
												}
											}				//add footer level
											
											if(DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_FIXED_ASSET,"DC", temp)!=0 || valShowList!=1)
											{	//add Group Footer
												sesReport = new SesReportBs();										
												sesReport.setType("Footer Group Level");
												sesReport.setDescription(strTotal1+"Sub Total "+I_Project.ACC_GROUP_FIXED_ASSET);
												sesReport.setFont(1);
												vSesDep = new Vector();
												for(int ix=0; ix<temp.size(); ix++){
													Periode per = (Periode)temp.get(ix);													
													vSesDep.add(""+getTotalFixAssetByPeriod(fixAssetx, per));
												}
												sesReport.setDepartment(vSesDep);																											
												listReport.add(sesReport);																			
										%>
                                        <tr> 
                                          <td class="tablecell2"><span class="level2"><b><%=strTotal+"Sub Total "+I_Project.ACC_GROUP_FIXED_ASSET%></b></span></td>
                                          <%for(int ix=0; ix<temp.size(); ix++){
												Periode per = (Periode)temp.get(ix);
												double totalFixAsset = getTotalFixAssetByPeriod(fixAssetx, per);		
												displayStr = strDisplay(totalFixAsset);			
											  %>
                                          <td width="150"> 
                                            <div align="right"><b><%=displayStr%><%//=(totalFixAsset==0) ? "" : JSPFormater.formatNumber(totalFixAsset, "#,###.##")%>&nbsp;&nbsp;</b></div>
                                          </td>
                                          <%}%>
                                        </tr>
                                        <%	
											}
										}
										
										//------------- end of fixed asset ------------
									%>
                                        <%
										//--------------- start other asset ------------
										
										Vector othAssetx = DbCoa.list(0,0, "account_group='"+I_Project.ACC_GROUP_OTHER_ASSET+"'", "code");
											
										if(DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_OTHER_ASSET,"DC", temp)!=0 || valShowList!=1)
										{	//add Group Header
											sesReport = new SesReportBs();										
											sesReport.setType("Group Level");
											sesReport.setDescription(strTotal1+I_Project.ACC_GROUP_OTHER_ASSET);
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
                                          <td class="tablecell"><b><%=strTotal+I_Project.ACC_GROUP_OTHER_ASSET%></b></td>
                                          <%for(int ix=0; ix<temp.size(); ix++){
												Periode per = (Periode)temp.get(ix);	
											  %>
                                          <td width="150" class="tablecell"> 
                                            <div align="right"></div>
                                          </td>
                                          <%}%>
                                        </tr>
                                        <% 	}	%>
                                        <%
										if(othAssetx!=null && othAssetx.size()>0)
										{
											String str = "";
											String str1 = "";							
											for(int i=0; i<othAssetx.size(); i++)
											{
												coa = (Coa)othAssetx.get(i);								
												
												if (coa.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_ASSET))
												{
													str = switchLevel(coa.getLevel());
													str1 = switchLevel1(coa.getLevel());
													double amount = DbCoa.getCoaBalance(coa.getOID());
													if (valShowList==1)
													{
														if ((coa.getStatus().equals("HEADER") && DbCoa.getCoaBalanceByHeader(coa.getOID(),"DC", temp)!=0) || ((!coa.getStatus().equals("HEADER")) && amount!=0))
														{	//add detail
															sesReport = new SesReportBs();
															sesReport.setType(coa.getStatus());
															sesReport.setDescription(strTotal1+strTotal1+str1+coa.getCode()+" - "+coa.getName());
															sesReport.setFont(coa.getStatus().equals("HEADER") ? 1 : 0);											
															vSesDep = new Vector();
															for(int ix=0; ix<temp.size(); ix++){
																Periode per = (Periode)temp.get(ix);													
																vSesDep.add(""+DbCoa.getCoaBalance(coa.getOID(), per));
															}
															sesReport.setDepartment(vSesDep);			
															listReport.add(sesReport);														
											  %>
                                        <tr> 
                                          <td nowrap class="tablecell1"> 
                                            <%if(coa.getStatus().equals("HEADER")){ %>
                                            <b> 
                                            <%}%>
                                            <%=strTotal+strTotal+str+coa.getCode()+" - "+coa.getName()%> 
                                            <%if(coa.getStatus().equals("HEADER")){ %>
                                            </b> 
                                            <%}%>
                                          </td>
                                          <%for(int ix=0; ix<temp.size(); ix++){
												Periode per = (Periode)temp.get(ix);
												double othAsset = DbCoa.getCoaBalance(coa.getOID(), per);			
												displayStr = strDisplay(othAsset, coa.getStatus());			
												  %>
                                          <td width="150" class="tablecell1"> 
                                            <div align="right"><%=displayStr%><%//=(othAsset==0) ? "" : JSPFormater.formatNumber(othAsset, "#,###.##")%>&nbsp;&nbsp;</div>
                                          </td>
                                          <%}%>
                                        </tr>
                                        <%				}
											}else
											{	
												if ((coa.getStatus().equals("HEADER")) || ((!coa.getStatus().equals("HEADER")) && amount!=0))
												{	//add detail
															sesReport = new SesReportBs();
															sesReport.setType(coa.getStatus());
															sesReport.setDescription(strTotal1+strTotal1+str1+coa.getCode()+" - "+coa.getName());
															sesReport.setFont(coa.getStatus().equals("HEADER") ? 1 : 0);											
															vSesDep = new Vector();
															for(int ix=0; ix<temp.size(); ix++){
																Periode per = (Periode)temp.get(ix);													
																vSesDep.add(""+DbCoa.getCoaBalance(coa.getOID(), per));
															}
															sesReport.setDepartment(vSesDep);			
															listReport.add(sesReport);														
											  %>
                                        <tr> 
                                          <td  nowrap class="tablecell1"> 
                                            <%if(coa.getStatus().equals("HEADER")){ %>
                                            <b> 
                                            <%}%>
                                            <%=strTotal+strTotal+str+coa.getCode()+" - "+coa.getName()%> 
                                            <%if(coa.getStatus().equals("HEADER")){ %>
                                            </b> 
                                            <%}%>
                                          </td>
                                          <%for(int ix=0; ix<temp.size(); ix++){
													Periode per = (Periode)temp.get(ix);
													double othAsset = DbCoa.getCoaBalance(coa.getOID(), per);				
													displayStr = strDisplay(othAsset, coa.getStatus());			
													  %>
                                          <td width="150" class="tablecell1"> 
                                            <div align="right"><%=displayStr%><%//=(othAsset==0) ? "" : JSPFormater.formatNumber(othAsset, "#,###.##")%>&nbsp;&nbsp;</div>
                                          </td>
                                          <%}%>
                                        </tr>
                                        <%
													}
													}
												}
											
											}
											
											//add footer level
											if(DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_OTHER_ASSET,"DC", temp)!=0 || valShowList!=1)
											{	//add Group Footer
												sesReport = new SesReportBs();										
												sesReport.setType("Footer Group Level");
												sesReport.setDescription(strTotal1+"Sub Total "+I_Project.ACC_GROUP_OTHER_ASSET);
												sesReport.setFont(1);
												vSesDep = new Vector();
												for(int ix=0; ix<temp.size(); ix++){
													Periode per = (Periode)temp.get(ix);													
													vSesDep.add(""+getTotalOthAssetByPeriod(othAssetx, per));
												}
												sesReport.setDepartment(vSesDep);																											
												listReport.add(sesReport);																			
										%>
                                        <tr> 
                                          <td ><span class="level2"><b><%=strTotal+" Sub Total "+I_Project.ACC_GROUP_OTHER_ASSET%></b></span></td>
                                          <%for(int ix=0; ix<temp.size(); ix++){
												Periode per = (Periode)temp.get(ix);
												double totalOthAsset = getTotalOthAssetByPeriod(othAssetx, per);	
												displayStr = strDisplay(totalOthAsset);			
												  %>
                                          <td width="150"> 
                                            <div align="right"><b><%=displayStr%><%//=(totalOthAsset==0) ? "" : JSPFormater.formatNumber(totalOthAsset, "#,###.##")%>&nbsp;&nbsp;</b></div>
                                          </td>
                                          <%}%>
                                        </tr>
                                        <%	
											}
										}
											
											//--------- line kosong--------- 
										%>
                                        <%
										//--------- total activa -------
										
										if(coaSummary1+coaSummary2+coaSummary3!=0 || valShowList!=1)
										{	//add Group Footer
										%>
                                        <tr> 
                                          <td ><span class="level2"><b>Total Activa</b></span></td>
                                          <%
											  vSesDep = new Vector();
											  for(int ix=0; ix<temp.size(); ix++){
													Periode per = (Periode)temp.get(ix);
													double totalLiqAsset = getTotalLiqAssetByPeriod(liqAssetx, per);	
													double totalFixAsset = getTotalFixAssetByPeriod(fixAssetx, per);	
													double totalOthAsset = getTotalOthAssetByPeriod(othAssetx, per);
													totalLiqAsset = totalLiqAsset + totalFixAsset + totalOthAsset;
													displayStr = strDisplay(totalLiqAsset);		
													vSesDep.add(""+totalLiqAsset);
											  %>
                                          <td width="150"> 
                                            <div align="right"><b><%=displayStr%><%//=(totalLiqAsset==0) ? "" : JSPFormater.formatNumber(totalLiqAsset, "#,###.##")%>&nbsp;&nbsp;</b></div>
                                          </td>
                                          <%}%>
                                        </tr>
                                        <%	
												sesReport = new SesReportBs();										
												sesReport.setType("Footer Top Level");
												sesReport.setDescription("Total Activa");
												sesReport.setFont(1);
												sesReport.setDepartment(vSesDep);
												listReport.add(sesReport);								
											}									
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
                                          <td height="15">&nbsp;</td>
                                          <%for(int ix=0; ix<temp.size(); ix++){
												Periode per = (Periode)temp.get(ix);	
										  %>
                                          <td width="150"> 
                                            <div align="right"></div>
                                          </td>
                                          <%}%>
                                        </tr>
                                        <tr> 
                                          <td height="15" class="tablecell1">&nbsp;</td>
                                          <%for(int ix=0; ix<temp.size(); ix++){
												Periode per = (Periode)temp.get(ix);	
										  %>
                                          <td width="150" class="tablecell1"> 
                                            <div align="right"></div>
                                          </td>
                                          <%}%>
                                        </tr>
                                        <tr> 
                                          <td height="15" class="tablecell"><b>Liabilities</b></td>
                                          <%for(int ix=0; ix<temp.size(); ix++){
												Periode per = (Periode)temp.get(ix);	
										  %>
                                          <td width="150" class="tablecell"> 
                                            <div align="right"></div>
                                          </td>
                                          <%}%>
                                        </tr>
                                        <%	
										//-------------- start current liabilities -----------
										
											//add Top Header
											sesReport = new SesReportBs();
											sesReport.setType("Top Level");
											sesReport.setDescription("Liabilities");
											sesReport.setFont(1);
											vSesDep = new Vector();
											for(int ix=0; ix<temp.size(); ix++){
												Periode per = (Periode)temp.get(ix);													
												vSesDep.add("0");
											}
											sesReport.setDepartment(vSesDep);
											listReport.add(sesReport);										
										
										Vector currLiabilx = DbCoa.list(0,0, "account_group='"+I_Project.ACC_GROUP_CURRENT_LIABILITIES+"'", "code");							
										
										if(DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_CURRENT_LIABILITIES,"CD", temp)!=0 || valShowList!=1)
										{	//add Group Header
											sesReport = new SesReportBs();										
											sesReport.setType("Group Level");
											sesReport.setDescription(strTotal1+I_Project.ACC_GROUP_CURRENT_LIABILITIES);
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
                                          <td class="tablecell" ><b><%=strTotal+I_Project.ACC_GROUP_CURRENT_LIABILITIES%></b></td>
                                          <%for(int ix=0; ix<temp.size(); ix++){
												Periode per = (Periode)temp.get(ix);	
										  %>
                                          <td width="150" class="tablecell"> 
                                            <div align="right"></div>
                                          </td>
                                          <%}%>
                                        </tr>
                                        <%	}	%>
                                        <%
										if(currLiabilx!=null && currLiabilx.size()>0)
										{
											coaSummary4 = 0;
											String str = "";
											String str1 = "";							
											for(int i=0; i<currLiabilx.size(); i++)
											{
												coa = (Coa)currLiabilx.get(i);								
												
												if (coa.getAccountGroup().equals(I_Project.ACC_GROUP_CURRENT_LIABILITIES))
												{
													str = switchLevel(coa.getLevel());
													str1 = switchLevel1(coa.getLevel());
													double amount = DbCoa.getCoaBalanceCD(coa.getOID());
													coaSummary4 = coaSummary4 + amount;
													displayStr = strDisplay(amount, coa.getStatus());
													if (valShowList==1)
													{
														if ((coa.getStatus().equals("HEADER") && DbCoa.getCoaBalanceByHeader(coa.getOID(),"CD", temp)!=0) || ((!coa.getStatus().equals("HEADER")) && amount!=0) || LoadValue(coa.getOID(),temp,"CD"))
														{	//add detail
															sesReport = new SesReportBs();
															sesReport.setType(coa.getStatus());
															sesReport.setDescription(strTotal1+strTotal1+str1+coa.getCode()+" - "+coa.getName());
															sesReport.setFont(coa.getStatus().equals("HEADER") ? 1 : 0);
															vSesDep = new Vector();
															for(int ix=0; ix<temp.size(); ix++){
																Periode per = (Periode)temp.get(ix);													
																vSesDep.add(""+DbCoa.getCoaBalanceCD(coa.getOID(), per));
															}
															sesReport.setDepartment(vSesDep);			
															listReport.add(sesReport);														
											  %>
                                        <tr> 
                                          <td nowrap class="tablecell1"> 
                                            <%if(coa.getStatus().equals("HEADER")){ %>
                                            <b> 
                                            <%}%>
                                            <%=strTotal+strTotal+str+coa.getCode()+" - "+coa.getName()%> 
                                            <%if(coa.getStatus().equals("HEADER")){ %>
                                            </b> 
                                            <%}%>
                                          </td>
                                          <%for(int ix=0; ix<temp.size(); ix++){
												Periode per = (Periode)temp.get(ix);
												double currLib = DbCoa.getCoaBalanceCD(coa.getOID(), per);				
												displayStr = strDisplay(currLib, coa.getStatus());		
										  %>
                                          <td width="150" class="tablecell1"> 
                                            <div align="right"><%=displayStr%><%//=(currLib==0) ? "" : JSPFormater.formatNumber(currLib, "#,###.##")%>&nbsp;&nbsp;</div>
                                          </td>
                                          <%}%>
                                        </tr>
                                        <%				}
											}else
											{	
												if ((coa.getStatus().equals("HEADER")) || ((!coa.getStatus().equals("HEADER")) && amount!=0) || LoadValue(coa.getOID(),temp,"CD"))
												{	//add detail
															sesReport = new SesReportBs();
															sesReport.setType(coa.getStatus());
															sesReport.setDescription(strTotal1+strTotal1+str1+coa.getCode()+" - "+coa.getName());
															sesReport.setFont(coa.getStatus().equals("HEADER") ? 1 : 0);
															vSesDep = new Vector();
															for(int ix=0; ix<temp.size(); ix++){
																Periode per = (Periode)temp.get(ix);													
																vSesDep.add(""+DbCoa.getCoaBalanceCD(coa.getOID(), per));
															}
															sesReport.setDepartment(vSesDep);			
															listReport.add(sesReport);														
									  %>
                                        <tr> 
                                          <td  nowrap class="tablecell1"> 
                                            <%if(coa.getStatus().equals("HEADER")){ %>
                                            <b> 
                                            <%}%>
                                            <%=strTotal+strTotal+str+coa.getCode()+" - "+coa.getName()%> 
                                            <%if(coa.getStatus().equals("HEADER")){ %>
                                            </b> 
                                            <%}%>
                                          </td>
                                          <%for(int ix=0; ix<temp.size(); ix++){
												Periode per = (Periode)temp.get(ix);
												double currLib = DbCoa.getCoaBalanceCD(coa.getOID(), per);					
												displayStr = strDisplay(currLib, coa.getStatus());		
										  %>
                                          <td width="150" class="tablecell1"> 
                                            <div align="right"><%=displayStr%><%//=(currLib==0) ? "" : JSPFormater.formatNumber(currLib, "#,###.##")%>&nbsp;&nbsp;</div>
                                          </td>
                                          <%}%>
                                        </tr>
                                        <%					}
													}
												}
											if (coaSummary4<0)							
												displayStr = "("+JSPFormater.formatNumber(coaSummary4*-1,"#,###.##")+")";
											else if (coaSummary4<0)
												displayStr = JSPFormater.formatNumber(coaSummary4,"#,###.##");
											else if (coaSummary4==0)
												displayStr = "";
											}				//add footer level
											if(DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_CURRENT_LIABILITIES,"CD", temp)!=0 || valShowList!=1)
											{	//add Group Footer
												sesReport = new SesReportBs();										
												sesReport.setType("Footer Group Level");
												sesReport.setDescription(strTotal1+"Sub Total "+I_Project.ACC_GROUP_CURRENT_LIABILITIES);
												sesReport.setFont(1);
												vSesDep = new Vector();
												for(int ix=0; ix<temp.size(); ix++){
													Periode per = (Periode)temp.get(ix);													
													vSesDep.add(""+getTotalCurrLibByPeriod(currLiabilx, per));
												}
												sesReport.setDepartment(vSesDep);																											
												listReport.add(sesReport);								
										%>
                                        <tr> 
                                          <td ><span class="level2"><b><%=strTotal+" Sub Total "+I_Project.ACC_GROUP_CURRENT_LIABILITIES%></b></span></td>
                                          <%for(int ix=0; ix<temp.size(); ix++){
												Periode per = (Periode)temp.get(ix);
												double totalCurrLib = getTotalCurrLibByPeriod(currLiabilx, per);	
												displayStr = strDisplay(totalCurrLib);
										  %>
                                          <td width="150"> 
                                            <div align="right"><b><%=displayStr%><%//=(totalCurrLib==0) ? "" : JSPFormater.formatNumber(totalCurrLib, "#,###.##") %>&nbsp;&nbsp;</b></div>
                                          </td>
                                          <%}%>
                                        </tr>
                                        <%
											}	
										}
										%>


                                        <%
										// -------------------- long term liabilities ---------
										
										Vector ltermLiabilx = DbCoa.list(0,0, "account_group='"+I_Project.ACC_GROUP_LONG_TERM_LIABILITIES+"'", "code");
										if(DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_LONG_TERM_LIABILITIES,"CD", temp)!=0 || valShowList!=1)
										{	//add Group Header
											sesReport = new SesReportBs();										
											sesReport.setType("Group Level");
											sesReport.setDescription(strTotal1+I_Project.ACC_GROUP_LONG_TERM_LIABILITIES);
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
                                          <td class="tablecell" ><b><%=strTotal+I_Project.ACC_GROUP_LONG_TERM_LIABILITIES%></b></td>
                                          <%for(int ix=0; ix<temp.size(); ix++){
												Periode per = (Periode)temp.get(ix);	
										  %>
                                          <td width="150" class="tablecell"> 
                                            <div align="right"></div>
                                          </td>
                                          <%}%>
                                        </tr>
                                        <%	}	%>
                                        <%
										if(ltermLiabilx!=null && ltermLiabilx.size()>0)
										{
											coaSummary5 = 0;
											String str = "";
											String str1 = "";							
											for(int i=0; i<ltermLiabilx.size(); i++)
											{
												coa = (Coa)ltermLiabilx.get(i);								
												
												if (coa.getAccountGroup().equals(I_Project.ACC_GROUP_LONG_TERM_LIABILITIES))
												{
													str = switchLevel(coa.getLevel());
													str1 = switchLevel1(coa.getLevel());
													double amount = DbCoa.getCoaBalanceCD(coa.getOID());
													coaSummary5 = coaSummary5 + amount;
													displayStr = strDisplay(amount, coa.getStatus());
													if (valShowList==1)
													{
														if ((coa.getStatus().equals("HEADER") && DbCoa.getCoaBalanceByHeader(coa.getOID(),"CD", temp)!=0) || ((!coa.getStatus().equals("HEADER")) && amount!=0))
														{	//add detail
															sesReport = new SesReportBs();
															sesReport.setType(coa.getStatus());
															sesReport.setDescription(strTotal1+strTotal1+str1+coa.getCode()+" - "+coa.getName());
															sesReport.setFont(coa.getStatus().equals("HEADER") ? 1 : 0);
															vSesDep = new Vector();
															for(int ix=0; ix<temp.size(); ix++){
																Periode per = (Periode)temp.get(ix);													
																vSesDep.add(""+DbCoa.getCoaBalanceCD(coa.getOID(), per));
															}
															sesReport.setDepartment(vSesDep);			
															listReport.add(sesReport);														
											  %>
                                        <tr> 
                                          <td  nowrap class="tablecell1"> 
                                            <%if(coa.getStatus().equals("HEADER")){ %>
                                            <b> 
                                            <%}%>
                                            <%=strTotal+strTotal+str+coa.getCode()+" - "+coa.getName()%> 
                                            <%if(coa.getStatus().equals("HEADER")){ %>
                                            </b> 
                                            <%}%>
                                          </td>
                                          <%for(int ix=0; ix<temp.size(); ix++){
												Periode per = (Periode)temp.get(ix);
												double ltermLib = DbCoa.getCoaBalanceCD(coa.getOID(), per);					
												displayStr = strDisplay(ltermLib, coa.getStatus());
										  %>
                                          <td width="150" class="tablecell1"> 
                                            <div align="right"><%=displayStr%><%//=(ltermLib==0) ? "" : JSPFormater.formatNumber(ltermLib, "#,###.##")%>&nbsp;&nbsp;</div>
                                          </td>
                                          <%}%>
                                        </tr>
                                        <%
											}
										}else
										{	
											if ((coa.getStatus().equals("HEADER")) || ((!coa.getStatus().equals("HEADER")) && amount!=0))
											{	//add detail
															sesReport = new SesReportBs();
															sesReport.setType(coa.getStatus());
															sesReport.setDescription(strTotal1+strTotal1+str1+coa.getCode()+" - "+coa.getName());
															sesReport.setFont(coa.getStatus().equals("HEADER") ? 1 : 0);
															vSesDep = new Vector();
															for(int ix=0; ix<temp.size(); ix++){
																Periode per = (Periode)temp.get(ix);													
																vSesDep.add(""+DbCoa.getCoaBalanceCD(coa.getOID(), per));
															}
															sesReport.setDepartment(vSesDep);			
															listReport.add(sesReport);														
							 			%>
                                        <tr> 
                                          <td nowrap class="tablecell1"> 
                                            <%if(coa.getStatus().equals("HEADER")){ %>
                                            <b> 
                                            <%}%>
                                            <%=strTotal+strTotal+str+coa.getCode()+" - "+coa.getName()%> 
                                            <%if(coa.getStatus().equals("HEADER")){ %>
                                            </b> 
                                            <%}%>
                                          </td>
                                          <%for(int ix=0; ix<temp.size(); ix++){
												Periode per = (Periode)temp.get(ix);
												double ltermLib = DbCoa.getCoaBalanceCD(coa.getOID(), per);
												displayStr = strDisplay(ltermLib, coa.getStatus());						
										  %>
                                          <td width="150" class="tablecell1"> 
                                            <div align="right"><%=displayStr%><%//=(ltermLib==0) ? "" : JSPFormater.formatNumber(ltermLib, "#,###.##")%>&nbsp;&nbsp;</div>
                                          </td>
                                          <%}%>
                                        </tr>
                                        <%
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
									
									if(DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_LONG_TERM_LIABILITIES,"CD", temp)!=0 || valShowList!=1)
									{	//add Group Footer
												sesReport = new SesReportBs();										
												sesReport.setType("Footer Group Level");
												sesReport.setDescription(strTotal1+"Sub Total "+I_Project.ACC_GROUP_LONG_TERM_LIABILITIES);
												sesReport.setFont(1);
												vSesDep = new Vector();
												for(int ix=0; ix<temp.size(); ix++){
													Periode per = (Periode)temp.get(ix);													
													vSesDep.add(""+getTotalLongLibByPeriod(ltermLiabilx, per));
												}
												sesReport.setDepartment(vSesDep);																											
												listReport.add(sesReport);								
									%>
                                        <tr> 
                                          <td ><span class="level2"><b><%=strTotal+" Sub Total "+I_Project.ACC_GROUP_LONG_TERM_LIABILITIES%></b></span></td>
                                          <%for(int ix=0; ix<temp.size(); ix++){
												Periode per = (Periode)temp.get(ix);
												double totalCurrLib = getTotalLongLibByPeriod(ltermLiabilx, per);		
												displayStr = strDisplay(totalCurrLib);	
										  %>
                                          <td width="150"> 
                                            <div align="right"><b><%=displayStr%><%=(totalCurrLib==0) ? "" : JSPFormater.formatNumber(totalCurrLib, "#,###.##")%>&nbsp;&nbsp;</b></div>
                                          </td>
                                          <%}%>
                                        </tr>
                                        <%
										}	
									}%>
                                        <%
									if (coaSummary4+coaSummary5<0){
										displayStr = "("+JSPFormater.formatNumber((coaSummary4+coaSummary5)*-1,"#,###.##")+")";
									}
									else if (coaSummary4+coaSummary5>0){
										displayStr = JSPFormater.formatNumber(coaSummary4+coaSummary5,"#,###.##");						
									}
									else if (coaSummary4+coaSummary5==0){
										displayStr = "";
									}
									
									//add footer level
									if(coaSummary4+coaSummary5!=0 || valShowList!=1)
									{	//add Group Footer
									%>
                                        <tr> 
                                          <td><span class="level2"><b>Total Liabilities</b></span></td>
                                          <%
										  vSesDep = new Vector();	
										  for(int ix=0; ix<temp.size(); ix++){
												Periode per = (Periode)temp.get(ix);
												double totalLongLib = getTotalLongLibByPeriod(ltermLiabilx, per);
												double totalCurrLib = getTotalCurrLibByPeriod(currLiabilx, per);
												totalCurrLib = totalCurrLib + totalLongLib;				
												displayStr = strDisplay(totalCurrLib);	
												vSesDep.add(""+totalCurrLib);
										  %>
                                          <td width="150"> 
                                            <div align="right"><b><%=displayStr%><%//=(totalCurrLib==0) ?  "" : JSPFormater.formatNumber(totalCurrLib, "#,###.##")%>&nbsp;&nbsp;</b></div>
                                          </td>
                                          <%}%>
                                        </tr>
                                        <%
												sesReport = new SesReportBs();										
												sesReport.setType("Footer Group Level");
												sesReport.setDescription("Total Liabilities");
												sesReport.setFont(1);
												sesReport.setDepartment(vSesDep);
												listReport.add(sesReport);								
											}
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
                                          <td height="15" class="tablecell"><b>Equity</b></td>
                                          <%for(int ix=0; ix<temp.size(); ix++){
												Periode per = (Periode)temp.get(ix);	
										  %>
                                          <td width="150" class="tablecell"> 
                                            <div align="right"></div>
                                          </td>
                                          <%}%>
                                        </tr>
                                        <%	
										
										//-------------- equity ------------------
											//add Top Header
											sesReport = new SesReportBs();
											sesReport.setType("Top Level");
											sesReport.setDescription("Equity");
											sesReport.setFont(1);
											vSesDep = new Vector();
											for(int ix=0; ix<temp.size(); ix++){
												Periode per = (Periode)temp.get(ix);													
												vSesDep.add("0");
											}
											sesReport.setDepartment(vSesDep);
											listReport.add(sesReport);										
										
										if((DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_EQUITY,"CD", temp) + DbCoaOpeningBalance.getSumOpeningBalance())!=0 || valShowList!=1)
										{	//add Group Header
											sesReport = new SesReportBs();										
											sesReport.setType("Group Level");
											sesReport.setDescription(strTotal1+I_Project.ACC_GROUP_EQUITY);
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
                                          <td class="tablecell" ><b><%=strTotal+I_Project.ACC_GROUP_EQUITY%></b></td>
                                          <%for(int ix=0; ix<temp.size(); ix++){
												Periode per = (Periode)temp.get(ix);	
										  %>
                                          <td width="150" class="tablecell"> 
                                            <div align="right"></div>
                                          </td>
                                          <%}%>
                                        </tr>
                                        <%}	%>
                                        <%
										
										Vector vEquities = DbCoa.list(0,0, "account_group='"+I_Project.ACC_GROUP_EQUITY+"'", "code");
										
										if(vEquities!=null && vEquities.size()>0)
										{
											coaSummary6 = 0;
											String str = "";
											String str1 = "";							
											for(int i=0; i<vEquities.size(); i++)
											{
												coa = (Coa)vEquities.get(i);
												
												double amount = DbCoa.getCoaBalanceCD(coa.getOID());
												
												System.out.println("\n==========> Equity : "+coa.getCode()+" - "+coa.getName()+" , balance : "+amount);								
												
												if (coa.getAccountGroup().equals(I_Project.ACC_GROUP_EQUITY))
												{
													str = switchLevel(coa.getLevel());
													str1 = switchLevel1(coa.getLevel());
													
													if (valShowList==1)
													{										
														if (coa.getCode().equals(DbSystemProperty.getValueByName("ID_RETAINED_EARNING")) ||
														coa.getCode().equals(DbSystemProperty.getValueByName("ID_RETAINED_EARNINGS"))  ||
														(coa.getStatus().equals("HEADER") && (DbCoa.getCoaBalanceByHeader(coa.getOID(),"CD", temp))!=0) || 
														((!coa.getStatus().equals("HEADER") && amount!=0))){
															
															  %>
                                        <tr> 
                                          <td nowrap class="tablecell1"> 
                                            <%if(coa.getStatus().equals("HEADER")){ %>
                                            <b> 
                                            <%}%>
                                            <%=strTotal+strTotal+str+coa.getCode()+" - "+coa.getName()%> 
                                            <%if(coa.getStatus().equals("HEADER")){ %>
                                            </b> 
                                            <%}%>
                                          </td>
                                          <%
										  vSesDep = new Vector();
										  for(int ix=0; ix<temp.size(); ix++){
																
													Periode per = (Periode)temp.get(ix);
																																
													double amountX = DbCoa.getCoaBalanceCD(coa.getOID());
													
													//ID_RETAINED_EARNINGS => pake 'S' ini adalah current year earning
													//akan mencari P&L yang sekarang
													if(coa.getCode().equals(DbSystemProperty.getValueByName("ID_RETAINED_EARNINGS")))
													{
														double totalIncome = 0;								
														Coa coax = new Coa();
														for(int zx=0; zx<listCoa.size(); zx++)
														{											
															coax= (Coa)listCoa.get(zx);
															//revenue -> Credit - Debet																			
															if (coax.getAccountGroup().equals(I_Project.ACC_GROUP_REVENUE))
															{
																totalIncome = totalIncome + DbCoa.getCYEarningCoaBalanceCD(coax.getOID(), per);	
															}
															//cogs -> Debet - Credit
															else if (coax.getAccountGroup().equals(I_Project.ACC_GROUP_COST_OF_SALES))
															{
																totalIncome = totalIncome - DbCoa.getCYEarningCoaBalance(coax.getOID(), per);	
															}
															//expense - > Debet - Credit
															else if (coax.getAccountGroup().equals(I_Project.ACC_GROUP_EXPENSE))
															{
																totalIncome = totalIncome - DbCoa.getCYEarningCoaBalance(coax.getOID(), per);	
															}
															//other revenue -> Credit - Debet
															else if (coax.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_REVENUE))
															{
																totalIncome = totalIncome + DbCoa.getCYEarningCoaBalanceCD(coax.getOID(), per);	
															}
															//other expe -> Debet -Credit
															else if (coax.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_EXPENSE))
															{
																totalIncome = totalIncome - DbCoa.getCYEarningCoaBalance(coax.getOID(), per);	
															}
														}									
														amountX = totalIncome;										
													}
													// Bagining Balance
													// ID_BEGINING_BALANCE = Retained earning
													if(coa.getCode().equals(DbSystemProperty.getValueByName("ID_BEGINING_BALANCE")))
													{
														amountX = DbCoa.getCoaBalance(coa.getOID(),per);//getSumOpeningBalance();										
													}
														
													coaSummary6 = coaSummary6 + amountX;
													
													displayStr = strDisplay(amountX, coa.getStatus());
													vSesDep.add(""+amountX);
															  %>
                                          <td width="150" class="tablecell1"> 
                                            <div align="right"><%=displayStr%>&nbsp;&nbsp;</div>
                                          </td>
                                          <%}
															//add detail
															sesReport = new SesReportBs();
															sesReport.setType(coa.getStatus());
															sesReport.setDescription(strTotal1+strTotal1+str1+coa.getCode()+" - "+coa.getName());
															sesReport.setFont(coa.getStatus().equals("HEADER") ? 1 : 0);
															sesReport.setDepartment(vSesDep);			
															listReport.add(sesReport);										  
										  %>
                                        </tr>
                                        <%				
														}
													}else
													{	
														if ((coa.getStatus().equals("HEADER")) || ((!coa.getStatus().equals("HEADER") && amount!=0)) ||
															coa.getCode().equals(DbSystemProperty.getValueByName("ID_RETAINED_EARNING")) ||
															coa.getCode().equals(DbSystemProperty.getValueByName("ID_RETAINED_EARNINGS"))
														)
														{	//add detail
															%>
                                        <tr> 
                                          <td  nowrap class="tablecell1"> 
                                            <%if(coa.getStatus().equals("HEADER")){ %>
                                            <b> 
                                            <%}%>
                                            <%=strTotal+strTotal+str+coa.getCode()+" - "+coa.getName()%> 
                                            <%if(coa.getStatus().equals("HEADER")){ %>
                                            </b> 
                                            <%}%>
                                          </td>
                                          <%
										  vSesDep = new Vector();
										  for(int ix=0; ix<temp.size(); ix++){
													
													Periode per = (Periode)temp.get(ix);
													
													double amountX = DbCoa.getCoaBalanceCD(coa.getOID());
													
													//ID_RETAINED_EARNINGS => pake 'S' ini adalah current year earning
													//akan mencari P&L yang sekarang
													if(coa.getCode().equals(DbSystemProperty.getValueByName("ID_RETAINED_EARNINGS")))
													{
														double totalIncome = 0;								
														Coa coax = new Coa();
														for(int zx=0; zx<listCoa.size(); zx++)
														{											
															coax= (Coa)listCoa.get(zx);
															//revenue -> Credit - Debet																			
															if (coax.getAccountGroup().equals(I_Project.ACC_GROUP_REVENUE))
															{
																totalIncome = totalIncome + DbCoa.getCYEarningCoaBalanceCD(coax.getOID(), per);	
															}
															//cogs -> Debet - Credit
															else if (coax.getAccountGroup().equals(I_Project.ACC_GROUP_COST_OF_SALES))
															{
																totalIncome = totalIncome - DbCoa.getCYEarningCoaBalance(coax.getOID(), per);	
															}
															//expense - > Debet - Credit
															else if (coax.getAccountGroup().equals(I_Project.ACC_GROUP_EXPENSE))
															{
																totalIncome = totalIncome - DbCoa.getCYEarningCoaBalance(coax.getOID(), per);	
															}
															//other revenue -> Credit - Debet
															else if (coax.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_REVENUE))
															{
																totalIncome = totalIncome + DbCoa.getCYEarningCoaBalanceCD(coax.getOID(), per);	
															}
															//other expe -> Debet -Credit
															else if (coax.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_EXPENSE))
															{
																totalIncome = totalIncome - DbCoa.getCYEarningCoaBalance(coax.getOID(), per);	
															}
														}									
														amountX = totalIncome;										
													}
													// Bagining Balance
													// ID_BEGINING_BALANCE = Retained earning
													if(coa.getCode().equals(DbSystemProperty.getValueByName("ID_BEGINING_BALANCE")))
													{
														amountX = DbCoa.getCoaBalance(coa.getOID(),per);//getSumOpeningBalance();										
													}
														
													coaSummary6 = coaSummary6 + amountX;
													
													displayStr = strDisplay(amountX, coa.getStatus());
													vSesDep.add(""+amountX);
															  %>
                                          <td width="150" class="tablecell1"> 
                                            <div align="right"><%=displayStr%>&nbsp;&nbsp;</div>
                                          </td>
                                          <%}
															//add detail
															sesReport = new SesReportBs();
															sesReport.setType(coa.getStatus());
															sesReport.setDescription(strTotal1+strTotal1+str1+coa.getCode()+" - "+coa.getName());
															sesReport.setFont(coa.getStatus().equals("HEADER") ? 1 : 0);															
															sesReport.setDepartment(vSesDep);			
															listReport.add(sesReport);														
										  %>
                                        </tr>
                                        <%
															}
														}
													}
													%>
                                        <%
													// ------------------ total equity ------------
													
													if (coaSummary6<0)							
														displayStr = "("+JSPFormater.formatNumber(coaSummary6*-1,"#,###.##")+")";
													else if (coaSummary6>0)
														displayStr = JSPFormater.formatNumber(coaSummary6,"#,###.##");
													else if (coaSummary6==0)
														displayStr = "";
													}				//add footer level
													
													if((DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_EQUITY,"CD", temp)!=0 + DbCoaOpeningBalance.getSumOpeningBalance()) || valShowList!=1)
													{	//add Group Footer
														sesReport = new SesReportBs();										
														sesReport.setType("Footer Group Level");
														sesReport.setDescription(strTotal1+"Sub Total "+I_Project.ACC_GROUP_EQUITY);
														sesReport.setFont(1);
														vSesDep = new Vector();
														for(int ix=0; ix<temp.size(); ix++){
															Periode per = (Periode)temp.get(ix);													
															vSesDep.add(""+getTotalEquityByPeriod(vEquities, per));
														}
														sesReport.setDepartment(vSesDep);																											
														listReport.add(sesReport);								
													%>
                                        <tr> 
                                          <td ><span class="level2"><b><%=strTotal+" Sub Total "+I_Project.ACC_GROUP_EQUITY%></b></span></td>
                                          <%for(int ix=0; ix<temp.size(); ix++){
														Periode per = (Periode)temp.get(ix);
														double totalEquity = getTotalEquityByPeriod(vEquities, per);
														displayStr = strDisplay(totalEquity);	
													  %>
                                          <td width="150"> 
                                            <div align="right"><b><%=displayStr%><%//=(totalEquity==0) ? "" : JSPFormater.formatNumber(totalEquity, "#,###.##")%></b>&nbsp;&nbsp;</div>
                                          </td>
                                          <%}%>
                                        </tr>
                                        <%
														}	
													}%>
                                        <%
													
													//----------- total equity ----------------
													
													if (coaSummary6<0)							
														displayStr = "("+JSPFormater.formatNumber((coaSummary6)*-1,"#,###.##")+")";
													else if (coaSummary6<0)
														displayStr = JSPFormater.formatNumber(coaSummary6,"#,###.##");						
													else if (coaSummary6==0)
														displayStr = "";
														
													//add footer level
													if(coaSummary6!=0 || valShowList!=1)
													{	//add Group Footer
														sesReport = new SesReportBs();										
														sesReport.setType("Footer Group Level");
														sesReport.setDescription("Total Equity");
														sesReport.setFont(1);
														vSesDep = new Vector();
														for(int ix=0; ix<temp.size(); ix++){
															Periode per = (Periode)temp.get(ix);													
															vSesDep.add(""+getTotalEquityByPeriod(vEquities, per));
														}
														sesReport.setDepartment(vSesDep);																											
														listReport.add(sesReport);															
												%>
                                        <tr> 
                                          <td ><span class="level2"><b>Total Equity</b></span></td>
                                          <%for(int ix=0; ix<temp.size(); ix++){
														Periode per = (Periode)temp.get(ix);
														double totalEquity = getTotalEquityByPeriod(vEquities, per);	
														displayStr = strDisplay(totalEquity);	
													  %>
                                          <td width="150"> 
                                            <div align="right"><b><%=displayStr%><%//=(totalEquity==0) ? "" : JSPFormater.formatNumber(totalEquity, "#,###.##")%>&nbsp;&nbsp;</b></div>
                                          </td>
                                          <%}%>
                                        </tr>
                                        <%	}
													if (coaSummary4+coaSummary5+coaSummary6<0)							
														displayStr = "("+JSPFormater.formatNumber((coaSummary4+coaSummary5+coaSummary6)*-1,"#,###.##")+")";
													else if (coaSummary4+coaSummary5+coaSummary6>0)
														displayStr = JSPFormater.formatNumber((coaSummary4+coaSummary5+coaSummary6),"#,###.##");															
													else if (coaSummary4+coaSummary5+coaSummary6==0)
														displayStr = "";
													//add footer level
													if(coaSummary6!=0 || valShowList!=1)
													{	//add Group Footer
												%>
                                        <tr> 
                                          <td ><span class="level2"><b>Total Liabilities 
                                            & Equity</b></span></td>
                                          <%
										  	vSesDep = new Vector();
										  	for(int ix=0; ix<temp.size(); ix++){
														Periode per = (Periode)temp.get(ix);
														double totalLongLib = getTotalLongLibByPeriod(ltermLiabilx, per);
														double totalCurrLib = getTotalCurrLibByPeriod(currLiabilx, per);
														double totalEquity = getTotalEquityByPeriod(vEquities, per);
														totalCurrLib = totalCurrLib + totalLongLib +totalEquity;	
														displayStr = strDisplay(totalCurrLib);	
														vSesDep.add(""+totalCurrLib);
													  %>
                                          <td width="150"> 
                                            <div align="right"><b><%=displayStr%><%//=(totalCurrLib==0) ? "" : JSPFormater.formatNumber(totalCurrLib, "#,###.##")%></b>&nbsp;&nbsp;</div>
                                          </td>
                                          <%}
														//add Group Footer
														sesReport = new SesReportBs();										
														sesReport.setType("Footer Top Level");
														sesReport.setDescription("Total Liabilities & Equity");
														sesReport.setFont(1);
														sesReport.setDepartment(vSesDep);																											
														listReport.add(sesReport);
										  %>
                                        </tr>
                                        <%
													}
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
                                          <td height="15" class="tablecell1">&nbsp;</td>
                                          <%for(int ix=0; ix<temp.size(); ix++){
														Periode per = (Periode)temp.get(ix);	
													  %>
                                          <td width="150" class="tablecell1"> 
                                            <div align="right"></div>
                                          </td>
                                          <%}%>
                                        </tr>
                                      </table>
                                    </td>
                                  </tr>
								  
								 
								  
								  
								  
								  
								  
                                  <tr align="left" valign="top"> 
                                    <td height="10" valign="middle" colspan="3">&nbsp; 
                                    </td>
                                  </tr>
								  <%}else{%>
								  <tr align="left" valign="top"> 
                                    <td height="10" valign="middle" colspan="3"><font color="#FF0000">No 
                                      periode available, please select another year.</font></td>
                                  </tr>
								  <%}%>
								  
								  
								  
								  
                                  <tr align="left" valign="top"> 
                                    <td height="10" valign="middle" colspan="3"></td>
                                  </tr>
                                  
                                </table>
                              </td>
                            </tr>
							
							<%
								session.putValue("BS_MULTIPLE", listReport);							
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
						  
						  <%}
						  catch(Exception e){
						  	out.println(e.toString());
						  }%>
						  
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
