 
<%@ page language="java"%>
<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.system.*" %>
<%@ page import = "com.project.main.db.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "java.util.Date" %>
<%@ include file="../main/javainit.jsp"%>
<%@ include file="../main/check.jsp"%>
<%
//jsp content
int iJSPCommand = JSPRequestValue.requestCommand(request);
Date startDate = new Date();
Date endDate = new Date();
if(iJSPCommand==JSPCommand.NONE){
	Periode p = DbPeriode.getOpenPeriod();
	startDate = p.getStartDate();
	endDate = new Date();//p.getEndDate();
}

Vector coas = DbCoa.list(0,0, DbCoa.colNames[DbCoa.COL_STATUS]+"<>'"+I_Project.ACCOUNT_LEVEL_HEADER+"'", DbCoa.colNames[DbCoa.COL_CODE]);

%>
<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
<head>
<!-- #BeginEditable "javascript" --> 
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title><%=systemTitle%></title>
<link href="../css/css.css" rel="stylesheet" type="text/css" />
<script type="text/javascript">
<!--




function cmdSearch(){
	document.glreport.action="gl.jsp";
	document.glreport.submit();
}

function setChecked(val) {
	dml=document.glreport;
	len = dml.elements.length;
	var i=0;
	for( i=0 ; i<len ; i++) {		
		<%for(int k=0; k<coas.size(); k++){
			Coa c = (Coa)coas.get(k);
		%>	
			if (dml.elements[i].name=='box_<%=c.getOID()%>') {
				dml.elements[i].checked=val;
			}
		<%}%>
	}
}

function setChecked1(val) {
	//dml=document.glreport;
	//len = dml.elements.length;
	//var i=0;
	//for( i=0 ; i<len ; i++) {		
		<%for(int k=0; k<coas.size(); k++){
			Coa c = (Coa)coas.get(k);
		%>	
			//if (dml.elements[i].name=='box_<%=c.getOID()%>') {
				document.glreport.box_<%=c.getOID()%>.checked=val;
			//}
		<%}%>
	//}
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
				  <%@ include file="../calendar/calendarframe.jsp"%>
                  <!-- #EndEditable -->
                </td>
                <td width="100%" valign="top"> 
                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr> 
                      <td class="title"><!-- #BeginEditable "title" -->
					  <%
					  String navigator = "<font class=\"lvl1\">Financial Report</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">General Ledger</span></font>";
					  %>
					  <%@ include file="../main/navigator.jsp"%>
					  <!-- #EndEditable --></td>
                    </tr>
                    <!--tr> 
                      <td><img src="<%=approot%>/images/title-sp.gif" width="584" height="1"></td> 
                    </tr-->
                    <tr> 
                      <td><!-- #BeginEditable "content" --> 
                        <form id="form1" name="glreport" method="post" action="">
                          <input type="hidden" name="command">
						  <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                          <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr> 
                              <td class="container">
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                  <tr> 
                                    <td colspan="5">&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td colspan="5">Please select General Ledger 
                                      Parameters : </td>
                                  </tr>
                                  <tr> 
                                    <td width="8%">&nbsp;</td>
                                    <td width="13%">&nbsp;</td>
                                    <td width="5%">&nbsp;</td>
                                    <td width="69%">&nbsp;</td>
                                    <td width="5%">&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td width="8%">Start Date</td>
                                    <td width="13%"> 
                                      <input name="start_date" value="<%=JSPFormater.formatDate((startDate==null) ? new Date() : startDate, "dd/MM/yyyy")%>" size="11" readonly>
                                      <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.glreport.start_date);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> 
                                    </td>
                                    <td width="5%">End Date</td>
                                    <td width="69%"> 
                                      <input name="end_date" value="<%=JSPFormater.formatDate((endDate==null) ? new Date() : endDate, "dd/MM/yyyy")%>" size="11" readonly>
                                      <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.glreport.end_date);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> 
                                    </td>
                                    <td width="5%">&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td width="8%">&nbsp;</td>
                                    <td width="13%">&nbsp;</td>
                                    <td width="5%">&nbsp;</td>
                                    <td width="69%">&nbsp;</td>
                                    <td width="5%">&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td colspan="3">Account Included : <a href="javascript:setChecked1(1)">Check 
                                      All</a> | <a href="javascript:setChecked1(0)">Release 
                                      All</a></td>
                                    <td width="69%"> 
                                      <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                        <tr>
                                          <td width="3%"><a href="javascript:cmdSearch()"><img src="../images/success.gif" width="20" height="20" border="0"></a></td>
                                          <td width="1%">&nbsp;</td>
                                          <td width="96%"><a href="javascript:cmdSearch()">Generate 
                                            Report</a></td>
                                        </tr>
                                      </table>
                                    </td>
                                    <td width="5%">&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td colspan="4">&nbsp;</td>
                                    <td width="5%">&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td colspan="4"> 
                                      <table width="59%" border="0" cellspacing="1" cellpadding="1">
                                        <tr> 
                                          <td width="8%" class="tablehdr">Include</td>
                                          <td width="13%" class="tablehdr">Code</td>
                                          <td width="79%" class="tablehdr">Account</td>
                                        </tr>
                                        <%if(coas!=null && coas.size()>0){
												for(int i=0; i<coas.size(); i++){
													Coa coa = (Coa)coas.get(i);
													boolean isBold = false;
													if(coa.getStatus().equals(I_Project.ACCOUNT_LEVEL_HEADER)){
														isBold = true;
													}
													
													String cls = "tablecell";
													if(i%2>0){
														cls = "tablecell1";
													}
													
										%>
                                        <tr> 
                                          <td width="8%" class="<%=cls%>"> 
                                            <div align="center"> 
                                              <input type="checkbox" name="box_<%=coa.getOID()%>" value="1" checked>
                                            </div>
                                          </td>
                                          <td width="13%" class="<%=cls%>"> 
                                            <div align="center"><%=coa.getCode()%></div>
                                          </td>
                                          <td width="79%" class="<%=cls%>"><%=coa.getName()%></td>
                                        </tr>
                                        <%}}%>
                                        <tr> 
                                          <td width="8%">&nbsp;</td>
                                          <td width="13%">&nbsp;</td>
                                          <td width="79%">&nbsp;</td>
                                        </tr>
                                      </table>
                                    </td>
                                    <td width="5%">&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td width="8%">&nbsp;</td>
                                    <td width="13%">&nbsp;</td>
                                    <td width="5%">&nbsp;</td>
                                    <td width="69%">&nbsp;</td>
                                    <td width="5%">&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td width="8%">&nbsp;</td>
                                    <td width="13%">&nbsp;</td>
                                    <td width="5%">&nbsp;</td>
                                    <td width="69%">&nbsp;</td>
                                    <td width="5%">&nbsp;</td>
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
