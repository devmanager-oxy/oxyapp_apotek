 
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%//@ page import = "com.project.fms.journal.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "com.project.fms.master.*" %>
<%@ page import = "com.project.fms.activity.*" %>
<%@ page import = "com.project.system.*" %>
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
boolean masterPriv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_ACC_COA);
boolean masterPrivView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_ACC_COA, AppMenu.PRIV_VIEW);
boolean masterPrivUpdate = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_ACC_COA, AppMenu.PRIV_UPDATE);
%>
<!-- Jsp Block -->
<%!

	public String drawList(Vector objectClass ,  long coaId)

	{
		JSPList ctrlist = new JSPList();
		ctrlist.setAreaWidth("50%");
		ctrlist.setListStyle("listgen");
		ctrlist.setTitleStyle("tablehdr");
		ctrlist.setCellStyle("tablecell");
		ctrlist.setHeaderStyle("tablehdr");
		ctrlist.addHeader("Code","20%");
		ctrlist.addHeader("Name","20%");
		ctrlist.addHeader("Level","20%");
		ctrlist.addHeader("Department Name","20%");
		ctrlist.addHeader("Section Name","20%");

		ctrlist.setLinkRow(0);
		ctrlist.setLinkSufix("");
		Vector lstData = ctrlist.getData();
		Vector lstLinkData = ctrlist.getLinkData();
		ctrlist.setLinkPrefix("javascript:cmdEdit('");
		ctrlist.setLinkSufix("')");
		ctrlist.reset();
		int index = -1;

		for (int i = 0; i < objectClass.size(); i++) {
			Coa coa = (Coa)objectClass.get(i);
			 Vector rowx = new Vector();
			 if(coaId == coa.getOID())
				 index = i;

			rowx.add(coa.getCode());

			rowx.add(coa.getName());

			rowx.add(String.valueOf(coa.getLevel()));

			rowx.add(coa.getDepartmentName());

			rowx.add(coa.getSectionName());

			lstData.add(rowx);
			lstLinkData.add(String.valueOf(coa.getOID()));
		}

		return ctrlist.draw(index);
	}

%>
<%
String grpType = JSPRequestValue.requestString(request, "groupType");
int iJSPCommand = JSPRequestValue.requestCommand(request);
int start = JSPRequestValue.requestInt(request, "start");
int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
long oidCoa = JSPRequestValue.requestLong(request, "hidden_coa_id");
String accGroup = JSPRequestValue.requestString(request, "acc_group");

if(iJSPCommand==JSPCommand.NONE && grpType.length()==0){
	grpType = I_Project.accGroup[0];
}

/*variable declaration*/
int recordToGet = 10;
String msgString = "";
int iErrCode = JSPMessage.NONE;
String whereClause = "";//account_group='"+accGroup+"'";
if (grpType.equals(""))
	grpType = "All";
if (grpType.equals("All"))
	whereClause = "";
else
	whereClause = DbCoa.colNames[DbCoa.COL_ACCOUNT_GROUP] + " = '"+ grpType + "'"; 
String orderClause = "code";



//out.println("grpType : "+grpType);


CmdCoa ctrlCoa = new CmdCoa(request);
JSPLine ctrLine = new JSPLine();
Vector listCoa = new Vector(1,1);

/*switch statement */

iErrCode = ctrlCoa.action(iJSPCommand , oidCoa, 0, 0, 0, sysCompany.getOID());
/* end switch*/
JspCoa jspCoa = ctrlCoa.getForm();

/*count list All Coa*/
int vectSize = DbCoa.getCount(whereClause);
recordToGet = vectSize;

Coa coa = ctrlCoa.getCoa();
msgString =  ctrlCoa.getMessage();


if((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV )||
  (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)){
		start = ctrlCoa.actionList(iJSPCommand, start, vectSize, recordToGet);
 } 
/* end switch list*/

/* get record to display */
listCoa = DbCoa.list(start,recordToGet, whereClause , orderClause);

if(iJSPCommand==JSPCommand.POST && listCoa!=null && listCoa.size()>0){
	for(int i=0; i<listCoa.size(); i++){
		Coa coaX =(Coa)listCoa.get(i);
		if(!coaX.getStatus().equals("HEADER")){
			long oidx = JSPRequestValue.requestLong(request, "slc_"+coaX.getOID());
			if(oidx!=0){
				try{
					coaX = DbCoa.fetchExc(coaX.getOID());
					coaX.setCoaCategoryId(oidx);
					DbCoa.updateExc(coaX);
				}
				catch(Exception e){
				}				
			}
		}
	}
	
	listCoa = DbCoa.list(start,recordToGet, whereClause , orderClause);
}

//out.println("listCoa : "+listCoa);
Vector coaCategories = DbCoaCategory.list(0,0, "", "type");



%>
<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
<head>
<!-- #BeginEditable "javascript" --> 
<title><%=systemTitle%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<link href="../css/default.css" rel="stylesheet" type="text/css" />
<link href="../css/css.css" rel="stylesheet" type="text/css" />
<script language="JavaScript">
<!--
<%if(!masterPriv || !masterPrivView){%>
	window.location="<%=approot%>/nopriv.jsp";
<%}%>

function cmdAdd(){
	document.frmcoa.hidden_coa_id.value="0";
	document.frmcoa.command.value="<%=JSPCommand.ADD%>";
	document.frmcoa.prev_command.value="<%=prevJSPCommand%>";
	document.frmcoa.action="iktisarsetup.jsp";
	document.frmcoa.submit();
}

function cmdAsk(oidCoa){
	document.frmcoa.hidden_coa_id.value=oidCoa;
	document.frmcoa.command.value="<%=JSPCommand.ASK%>";
	document.frmcoa.prev_command.value="<%=prevJSPCommand%>";
	document.frmcoa.action="iktisarsetup.jsp";
	document.frmcoa.submit();
}

function cmdConfirmDelete(oidCoa){
	document.frmcoa.hidden_coa_id.value=oidCoa;
	document.frmcoa.command.value="<%=JSPCommand.DELETE%>";
	document.frmcoa.prev_command.value="<%=prevJSPCommand%>";
	document.frmcoa.action="iktisarsetup.jsp";
	document.frmcoa.submit();
}
function cmdSave(){
	document.frmcoa.command.value="<%=JSPCommand.SAVE%>";
	document.frmcoa.prev_command.value="<%=prevJSPCommand%>";
	document.frmcoa.action="iktisarsetup.jsp";
	document.frmcoa.submit();
	}

function cmdEdit(oidCoa){
	document.frmcoa.hidden_coa_id.value=oidCoa;
	document.frmcoa.command.value="<%=JSPCommand.EDIT%>";
	document.frmcoa.prev_command.value="<%=prevJSPCommand%>";
	document.frmcoa.action="coaedt.jsp";
	document.frmcoa.submit();
	}

function cmdToEditor(){
	//alert(document.frmcoa.menu_index.value);
	document.frmcoa.hidden_coa_id.value=0;
	document.frmcoa.command.value="<%=JSPCommand.POST%>";
	document.frmcoa.prev_command.value="<%=prevJSPCommand%>";
	document.frmcoa.action="iktisarsetup.jsp";
	document.frmcoa.submit();
}	

function cmdCancel(oidCoa){
	document.frmcoa.hidden_coa_id.value=oidCoa;
	document.frmcoa.command.value="<%=JSPCommand.EDIT%>";
	document.frmcoa.prev_command.value="<%=prevJSPCommand%>";
	document.frmcoa.action="iktisarsetup.jsp";
	document.frmcoa.submit();
}

function cmdBack(){
	document.frmcoa.command.value="<%=JSPCommand.BACK%>";
	document.frmcoa.action="iktisarsetup.jsp";
	document.frmcoa.submit();
	}

function cmdListFirst(){
	document.frmcoa.command.value="<%=JSPCommand.FIRST%>";
	document.frmcoa.prev_command.value="<%=JSPCommand.FIRST%>";
	document.frmcoa.action="iktisarsetup.jsp";
	document.frmcoa.submit();
}

function cmdListPrev(){
	document.frmcoa.command.value="<%=JSPCommand.PREV%>";
	document.frmcoa.prev_command.value="<%=JSPCommand.PREV%>";
	document.frmcoa.action="iktisarsetup.jsp";
	document.frmcoa.submit();
	}

function cmdListNext(){
	document.frmcoa.command.value="<%=JSPCommand.NEXT%>";
	document.frmcoa.prev_command.value="<%=JSPCommand.NEXT%>";
	document.frmcoa.action="iktisarsetup.jsp";
	document.frmcoa.submit();
}

function cmdListLast(){
	document.frmcoa.command.value="<%=JSPCommand.LAST%>";
	document.frmcoa.prev_command.value="<%=JSPCommand.LAST%>";
	document.frmcoa.action="iktisarsetup.jsp";
	document.frmcoa.submit();
}

function printXLS(){	 
	window.open("<%=printroot%>.report.RptCoaFlatXLS");//,"budget","scrollbars=no,height=400,width=400,addressbar=no,menubar=no,toolbar=no,location=no,");  				
}

function cmdAccGroup(){
	document.frmcoa.command.value="<%=JSPCommand.SUBMIT%>";
	document.frmcoa.action="iktisarsetup.jsp";
	document.frmcoa.submit();
}


//-------------- script control line -------------------

function MM_swapImgRestore() { //v3.0
  var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
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
                      <td class="title"><!-- #BeginEditable "title" --> 
                        <%
					  String navigator = "<font class=\"lvl1\">Master</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">Ikhtisar Laba Rugi Setup</span></font>";
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
                                    <td height="22" valign="middle" colspan="3" class="page"> 
                                      <table width="100%" border="0" cellpadding="1" height="20" cellspacing="1">
                                        <tr> 
                                          <td width="23%" height="41">Account 
                                            Group&nbsp;&nbsp;&nbsp;&nbsp; 
                                            <select name="groupType" onChange="javascript:cmdAccGroup()">
                                              <option value="All" <%if(grpType.equals("All")) { %>selected<%}%>>All</option>
                                              <%for(int i=0; i<I_Project.accGroup.length; i++){
											  %>
                                              <option value="<%=I_Project.accGroup[i]%>" <%if(I_Project.accGroup[i].equals(grpType)){%>selected<%}%>><%=I_Project.accGroup[i]%></option>
                                              <%}%>
                                            </select>
                                          </td>
                                          <td width="11%" height="41">&nbsp;</td>
                                          <td width="11%" height="41">&nbsp;</td>
                                          <td width="12%" height="41">&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td width="23%" class="tablehdr" height="22"> 
                                            <div align="center"><b><font color="#FFFFFF">Account</font></b></div>
                                          </td>
                                          <td width="11%" class="tablehdr" height="22">Balance 
                                            Total</td>
                                          <td width="11%" class="tablehdr" height="22">Account 
                                            Group</td>
                                          <td width="12%" class="tablehdr" height="22" nowrap>Account 
                                            Category</td>
                                        </tr>
                                        <%if(listCoa!=null && listCoa.size()>0){								
							  	for(int i=0; i<listCoa.size(); i++){
									coa = (Coa)listCoa.get(i);
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
									
									String cssString = "tablecell";
									if(i%2!=0){
										cssString = "tablecell1";
									}
									
									
							  %>
                                        <tr> 
                                          <td width="23%" class="<%=cssString%>" nowrap> 
                                            <%if(coa.getStatus().equals("HEADER")){ %>
                                            <b> 
                                            <%}%>
                                            <%=str+"<a href=\"javascript:cmdEdit('"+coa.getOID()+"')\">"+coa.getCode()+" - "+coa.getName()+"</a>"%> 
                                            <%if(coa.getStatus().equals("HEADER")){ %>
                                            </b> 
                                            <%}%>
                                          </td>
                                          <td width="11%" class="<%=cssString%>"> 
                                            <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                              <tr> 
                                                <td width="5%"></td>
                                                <%										  	
											if(coa.getStatus().equals("HEADER")){
												double coaSummary = 0;
												String codeBaginBalance = DbSystemProperty.getValueByName("ID_BEGINING_BALANCE");
												for(int ix=0; ix<listCoa.size(); ix++){
													Coa coax = (Coa)listCoa.get(ix);
													if (coax.getAccRefId()==coa.getOID())
													{
														if (coax.getCode().equals(codeBaginBalance))
															coaSummary = coaSummary + DbCoa.getCoaBalance(coax.getOID());//DbCoaOpeningBalance.getSumOpeningBalance();	
														else	
														// by acc group
														/*
															if (coax.getAccountGroup().equals(I_Project.ACC_GROUP_LIQUID_ASSET) || coax.getAccountGroup().equals(I_Project.ACC_GROUP_FIXED_ASSET) || coax.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_ASSET) || coax.getAccountGroup().equals(I_Project.ACC_GROUP_CURRENT_LIABILITIES) || coax.getAccountGroup().equals(I_Project.ACC_GROUP_LONG_TERM_LIABILITIES) || coax.getAccountGroup().equals(I_Project.ACC_GROUP_COST_OF_SALES) || coax.getAccountGroup().equals(I_Project.ACC_GROUP_EXPENSE) || coax.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_EXPENSE))
															{
																coaSummary = coaSummary + DbCoa.getCoaBalance(coax.getOID());	
															}else if (coax.getAccountGroup().equals(I_Project.ACC_GROUP_EQUITY) || coax.getAccountGroup().equals(I_Project.ACC_GROUP_REVENUE) || coax.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_REVENUE))
															{
																coaSummary = coaSummary + DbCoa.getCoaBalanceCD(coax.getOID());	
															}
														*/
															if (coax.getAccountGroup().equals(I_Project.ACC_GROUP_LIQUID_ASSET) || coax.getAccountGroup().equals(I_Project.ACC_GROUP_FIXED_ASSET) || coax.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_ASSET) || coax.getAccountGroup().equals(I_Project.ACC_GROUP_COST_OF_SALES) || coax.getAccountGroup().equals(I_Project.ACC_GROUP_EXPENSE) || coax.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_EXPENSE))
															{
																coaSummary = coaSummary + DbCoa.getCoaBalance(coax.getOID());	
															}else if (coax.getAccountGroup().equals(I_Project.ACC_GROUP_EQUITY) || coax.getAccountGroup().equals(I_Project.ACC_GROUP_REVENUE) || coax.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_REVENUE) || coax.getAccountGroup().equals(I_Project.ACC_GROUP_CURRENT_LIABILITIES) || coax.getAccountGroup().equals(I_Project.ACC_GROUP_LONG_TERM_LIABILITIES))
															{
																coaSummary = coaSummary + DbCoa.getCoaBalanceCD(coax.getOID());	
															}
													}
												}
												String strDisplay1 = "";
												if(coaSummary<0)
													strDisplay1 = "("+JSPFormater.formatNumber(coaSummary*-1,"#,###.##")+")";
												else
													strDisplay1 = JSPFormater.formatNumber(coaSummary,"#,###.##");

												
													
										  %>
                                                <td width="90%" class="<%=cssString%>"> 
                                                  <div align="right"><b><%=strDisplay1%></b></div>
                                                </td>
                                                <%										  
										  	}else{
												
													String strDisplay = "";
													double amount = 0;
												/*	
													if (coa.getAccountGroup().equals(I_Project.ACC_GROUP_LIQUID_ASSET) || coa.getAccountGroup().equals(I_Project.ACC_GROUP_FIXED_ASSET) || coa.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_ASSET) || coa.getAccountGroup().equals(I_Project.ACC_GROUP_CURRENT_LIABILITIES) || coa.getAccountGroup().equals(I_Project.ACC_GROUP_LONG_TERM_LIABILITIES) || coa.getAccountGroup().equals(I_Project.ACC_GROUP_COST_OF_SALES) || coa.getAccountGroup().equals(I_Project.ACC_GROUP_EXPENSE) || coa.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_EXPENSE))
													{
														amount = DbCoa.getCoaBalance(coa.getOID());
													}else if (coa.getAccountGroup().equals(I_Project.ACC_GROUP_EQUITY) || coa.getAccountGroup().equals(I_Project.ACC_GROUP_REVENUE) || coa.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_REVENUE))
													{
														amount = DbCoa.getCoaBalanceCD(coa.getOID());
													}
												*/
													if (coa.getAccountGroup().equals(I_Project.ACC_GROUP_LIQUID_ASSET) || coa.getAccountGroup().equals(I_Project.ACC_GROUP_FIXED_ASSET) || coa.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_ASSET) || coa.getAccountGroup().equals(I_Project.ACC_GROUP_COST_OF_SALES) || coa.getAccountGroup().equals(I_Project.ACC_GROUP_EXPENSE) || coa.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_EXPENSE))
													{
														amount = DbCoa.getCoaBalance(coa.getOID());
													}else if (coa.getAccountGroup().equals(I_Project.ACC_GROUP_EQUITY) || coa.getAccountGroup().equals(I_Project.ACC_GROUP_REVENUE) || coa.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_REVENUE) || coa.getAccountGroup().equals(I_Project.ACC_GROUP_CURRENT_LIABILITIES)   || coa.getAccountGroup().equals(I_Project.ACC_GROUP_LONG_TERM_LIABILITIES))
													{
														amount = DbCoa.getCoaBalanceCD(coa.getOID());
														System.out.println(coa.getCode()+" - "+coa.getName()+" amount cd = "+amount);
													}
													
													//amount = DbCoa.getCoaBalance(coa.getOID());
													String codeBaginBalance = DbSystemProperty.getValueByName("ID_BEGINING_BALANCE");
													if (coa.getCode().equals(codeBaginBalance))
														amount = DbCoa.getCoaBalance(coa.getOID());;//DbCoaOpeningBalance.getSumOpeningBalance();
													if(amount<0)
														strDisplay = "("+JSPFormater.formatNumber(amount*-1,"#,###.##")+")";
													else
														strDisplay = JSPFormater.formatNumber(amount,"#,###.##");
													
										  %>
                                                <td width="90%" class="<%=cssString%>"> 
                                                  <div align="right"><%=strDisplay%></div>
                                                </td>
                                                <%}%>
                                                <td width="5%"></td>
                                              </tr>
                                            </table>
                                          </td>
                                          <td width="11%" class="<%=cssString%>" nowrap> 
                                            <%if(coa.getStatus().equals("HEADER")){ %>
                                            <b> 
                                            <%}%>
                                            <%=coa.getAccountGroup()%> 
                                            <%if(coa.getStatus().equals("HEADER")){ %>
                                            </b> 
                                            <%}%>
                                          </td>
                                          <td width="12%" class="<%=cssString%>" nowrap> 
                                            <%
											//out.println("coa.getCoaCategoryId() : "+coa.getCoaCategoryId());
											
											if(!coa.getStatus().equals("HEADER")){ %>
                                            <select name="slc_<%=coa.getOID()%>">
												<option value="0">-</option>
                                              <%
											  if(coaCategories!=null && coaCategories.size()>0){
												  for(int x=0; x<coaCategories.size(); x++){
													CoaCategory cc = (CoaCategory)coaCategories.get(x);
												  %>
                                              <option <%if(cc.getOID()==coa.getCoaCategoryId()){%>selected<%}%> value="<%=cc.getOID()%>"><%=cc.getName()%></option>
                                              <%
											  	  }
											  }%>
                                            </select>
                                            <%}%>
                                          </td>
                                        </tr>
                                        <%}%>
                                        <tr> 
                                          <td width="23%" class="tablecell">&nbsp;</td>
                                          <td width="11%" class="tablecell">&nbsp;</td>
                                          <td width="11%" class="tablecell">&nbsp;</td>
                                          <td width="12%" class="tablecell">&nbsp;</td>
                                        </tr>
                                        <%}else{%>
                                        <tr> 
                                          <td width="23%">&nbsp;</td>
                                          <td width="11%">&nbsp;</td>
                                          <td width="11%">&nbsp;</td>
                                          <td width="12%">&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td width="23%">&nbsp; </td>
                                          <td width="11%">&nbsp;</td>
                                          <td width="11%">&nbsp;</td>
                                          <td width="12%">&nbsp;</td>
                                        </tr>
                                        <%}%>
                                      </table>
                                    </td>
                                  </tr>
                                  <tr align="left" valign="top">
                                    <td height="0" valign="middle" colspan="3">&nbsp;</td>
                                  </tr>
                                  <%
							try{
								if (listCoa.size()>0){
							%>
                                  <tr align="left" valign="top"> 
                                    <td height="0" valign="middle" colspan="3"><a href="javascript:cmdToEditor()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new21','','../images/save2.gif',1)"><img src="../images/save.gif" name="new21" border="0"></a> 
                                    </td>
                                  </tr>
                                  <%  } 
						  }catch(Exception exc){ 
						  		out.println(exc.toString());
						  }%>
                                  <tr align="left" valign="top"> 
                                    <td height="8" align="left" colspan="3" class="command"> 
                                      <span class="command"> </span> </td>
                                  </tr>
                                  <!--tr align="left" valign="top"> 
                          <td height="22" valign="middle" colspan="3">&nbsp;<a href="javascript:cmdAdd()" class="command"><u>Add 
                            New</u></a></td>
                        </tr-->
                                </table>
                              </td>
                            </tr>
                            <tr align="left" valign="top"> 
                              <td height="8" valign="middle" colspan="3">&nbsp; </td>
                            </tr>
                            <tr align="left" valign="top"> 
                              <td height="8" valign="middle" colspan="3" class="container">&nbsp; 
                              </td>
                            </tr>
                          </table>
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
