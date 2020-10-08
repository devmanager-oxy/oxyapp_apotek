 
<%@ page language="java"%>
<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.system.*" %>
<%@ page import = "com.project.main.db.*" %>
<%@ page import = "com.project.datasync.*" %>
<%@ page import = "java.util.Date" %>
<%@ include file="../main/javainit.jsp"%>
<%@ include file="../main/check.jsp"%>
<%
//boolean datasyncPriv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MENU_DATASYNC, AppMenu.M2_MENU_DATASYNC);
%>
<%
//jsp content
String stDate = JSPRequestValue.requestString(request, "start_date");
String enDate = JSPRequestValue.requestString(request, "end_date");
int iJSPCommand = JSPRequestValue.requestCommand(request);
long periodId = JSPRequestValue.requestLong(request, "period_id");

Date startDate = new Date();
Date endDate = new Date();
String fileName = "";
Periode p = new Periode();

if(iJSPCommand==JSPCommand.SUBMIT){
	try{
		p = DbPeriode.fetchExc(periodId);
		startDate = p.getStartDate();//JSPFormater.formatDate(stDate, "dd/MM/yyyy");
		endDate = p.getEndDate();//JSPFormater.formatDate(enDate, "dd/MM/yyyy");
	}
	catch(Exception e){
	}
	
	//out.println(startDate);
	//out.println("<br>"+endDate);
	
	Company compx = DbCompany.getCompany();
	
	String namePrefix = p.getName()+"-"+DbSystemProperty.getValueByName("OFFICE_LOCATION");
		
	fileName = DataBackup.createFileEncripted(compx.getName());//, p.getOID(), startDate, endDate);
}

//out.println(startDate);
//out.println(startDate);

/*** LANG ***/
String[] langAT = {"Click the Generate File button to start.", "Backup process in progress, please wait ...", "Result", "Generate File"};

String[] langNav = {"Data Synchronization", "Backup", "Transfer to File"};

if (lang == LANG_ID) {
	String[] langID = {"Klik tombol Buat File untuk memulai.", "Proses backup sedang berjalan, mohon menunggu ...", "Hasilnya", "Buat File"};
	langAT = langID;

	String[] navID = {"Data Singkronisasi", "Backup", "Simpan Ke File"};
	langNav = navID;
}

%>
<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
<head>
<!-- #BeginEditable "javascript" --> 
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Finance System</title>
<link href="../css/css.css" rel="stylesheet" type="text/css" />
<script type="text/javascript">
<!--




<%if(!datasyncPriv){%>
	window.location="<%=approot%>/nopriv.jsp";
<%}%>

function cmdSubmit(){
	document.all.closecmd.style.display="none";
	document.all.closemsg.style.display="";
	document.form1.command.value="<%=JSPCommand.SUBMIT%>";
	document.form1.action="backup.jsp";
	document.form1.submit();
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
            String navigator = "<font class=\"lvl1\">" + langNav[0]+"</font><font class=\"level2\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">" + langNav[2] + "</span></font>";
                                           %>
                                           <%@ include file="../main/navigator.jsp"%>
						<!-- #EndEditable --></td>
                    </tr>
                    <!--tr> 
                      <td><img src="<%=approot%>/images/title-sp.gif" width="584" height="1"></td> 
                    </tr-->
                    <tr> 
                      <td><!-- #BeginEditable "content" --> 
                        <form name="form1" method="post" action="">
                          <input type="hidden" name="command">
						  <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                          <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr> 
                              <td class="container"> 
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                  <tr> 
                                    <td colspan="5">&nbsp;</td>
                                    <td width="12%">&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td colspan="5"><%=langAT[0]%></td>
                                    <td width="12%">&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td width="10%">&nbsp;</td>
                                    <td width="7%">&nbsp;</td>
                                    <td width="0%">&nbsp;</td>
                                    <td width="4%">&nbsp;</td>
                                    <td width="67%">&nbsp;</td>
                                    <td width="12%">&nbsp;</td>
                                  </tr>
                                  <!--tr> 
                                    <td width="10%">Accounting Period</td>
                                    <td colspan="4" nowrap> 
                                      <%
									Vector temp = DbPeriode.list(0,12, "", "start_date desc");
									%>
                                      <select name="period_id">
                                        <%if(temp!=null && temp.size()>0){
											for(int i=0; i<temp.size(); i++){
												Periode per = (Periode)temp.get(i);
										%>
                                        <option value="<%=per.getOID()%>" <%if(per.getOID()==periodId){%>selected<%}%>><%=per.getName()+" |  "+JSPFormater.formatDate(per.getStartDate(), "dd-MM-yyyy")+" / "+JSPFormater.formatDate(per.getEndDate(), "dd-MM-yyyy")%></option>
                                        <%}}%>
                                      </select>
                                    </td>
                                    <td width="12%">&nbsp;</td>
                                  </tr-->
                                  <tr id="closecmd" align="left" valign="top"> 
                                    <td height="22" valign="middle" colspan="6"> 
                                      <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                        <tr> 
                                          <td width="10%"> 
                                            <input type="button" name="Button2" value="<%=langAT[3]%>" onClick="javascript:cmdSubmit()">
                                          </td>
                                          <td width="89%">&nbsp; </td>
                                          <td width="1%">&nbsp;</td>
                                        </tr>
                                      </table>
                                    </td>
                                  </tr>
                                  <tr id="closemsg" align="left" valign="top"> 
                                    <td height="22" valign="middle" colspan="6"> 
                                      <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                        <tr> 
                                          <td> <font color="#006600"><%=langAT[1]%> </font> 
                                          </td>
                                        </tr>
                                        <tr> 
                                          <td height="1">&nbsp; </td>
                                        </tr>
                                        <tr> 
                                          <td> <img src="../images/progress_bar.gif" border="0"> 
                                          </td>
                                        </tr>
                                      </table>
                                    </td>
                                  </tr>
                                </table>
                              </td>
                            </tr>
                            <tr> 
                              <td>&nbsp;</td>
                            </tr>
							<%if(iJSPCommand==JSPCommand.SUBMIT){%>
                            <tr>
                              <td class="container"><%=langAT[2]%> :</td>
                            </tr>
                            
                            <tr> 
                              <td class="container"><font color="#FF0000"><%=fileName%></font></td>
                            </tr>
                            <%}%>
                          </table>
						  <script language="JavaScript">
					   	document.all.closecmd.style.display="";
						document.all.closemsg.style.display="none";
					   </script>
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
