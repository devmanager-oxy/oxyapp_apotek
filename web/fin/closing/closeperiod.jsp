
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.main.entity.*" %>
<%@ page import = "com.project.fms.master.*" %>
<%@ page import = "com.project.fms.*" %>
<%@ page import = "com.project.*" %> 
<%@ include file = "../main/javainit.jsp" %>
<%@ include file = "../main/check.jsp" %>
<%
            boolean priv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MENU_CLOSING, AppMenu.M2_MENU_CLOSING_PERIOD);
            boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_CLOSING, AppMenu.M2_MENU_CLOSING_PERIOD, AppMenu.PRIV_VIEW);
            boolean privUpdate = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_CLOSING, AppMenu.M2_MENU_CLOSING_PERIOD, AppMenu.PRIV_UPDATE);
            boolean privAdd = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_CLOSING, AppMenu.M2_MENU_CLOSING_PERIOD, AppMenu.PRIV_ADD);
            boolean privDelete = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_CLOSING, AppMenu.M2_MENU_CLOSING_PERIOD, AppMenu.PRIV_DELETE);
%>
<!-- Jsp Block -->
<%!
    final static int CMD_CLOSE = 1;

    public static long getClosing(long periodId) {
        try {
            Vector listPeriode = DbPeriode.list(0, 0, "", DbPeriode.colNames[DbPeriode.COL_START_DATE] + " desc");
            if (listPeriode != null && listPeriode.size() > 0) {
                for (int i = 0; i < listPeriode.size(); i++) {
                    Periode p = (Periode) listPeriode.get(i);
                    if (p.getOID() == periodId) {
                        try {
                            if (i != 0) {
                                Periode pcek = (Periode) listPeriode.get(i - 1);
                                return pcek.getOID();
                            }
                        } catch (Exception e) {
                        }
                    }
                }
            }
        } catch (Exception e) {
        }
        return 0;

    }

%>
<%
            int iJSPCommand = JSPRequestValue.requestCommand(request);
            int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
            long periodId = JSPRequestValue.requestLong(request, "hidden_periode_id");
            long periodOpenId = JSPRequestValue.requestLong(request, "hidden_periode_open_id");
            String periodName = JSPRequestValue.requestString(request, "period_name");
            String period13Name = JSPRequestValue.requestString(request, "period_13_name");
            Date startDate = JSPFormater.formatDate(JSPRequestValue.requestString(request, "start_date"), "dd/MM/yyyy");
            Date endDate = JSPFormater.formatDate(JSPRequestValue.requestString(request, "end_date"), "dd/MM/yyyy");
            Date tolerance = JSPFormater.formatDate(JSPRequestValue.requestString(request, "tolerance"), "dd/MM/yyyy");
            int activate13 = JSPRequestValue.requestInt(request, "activate_13");
            String apply13Period = "N";
            try{
                apply13Period = DbSystemProperty.getValueByName("FINANCE_APPLY_13_PERIOD");
            }catch(Exception e){}
            boolean isYearlyClosing = false;

            Periode periodChk = new Periode();
            try{
                periodChk = DbPeriode.fetchExc(periodId);
                java.util.Date currentPeriodStart = periodChk.getEndDate();
                if(sysCompany.getEndFiscalMonth()==currentPeriodStart.getMonth()){
                    isYearlyClosing = true;
                }
            }catch(Exception e){}
            
            String result = "";
            Vector vTransaction = new Vector();

            if (iJSPCommand == JSPCommand.SAVE) {
                Periode newPeriode = new Periode();
                newPeriode.setName(periodName);
                newPeriode.setStartDate(startDate);
                newPeriode.setEndDate(endDate);
                newPeriode.setStatus(I_Project.STATUS_PERIOD_OPEN);
                newPeriode.setInputTolerance(tolerance);
                newPeriode.setTableName(I_Fms.tblGl);
                if (activate13 == 1) {
                    newPeriode.setApplyPeriod13(activate13);
                    newPeriode.setPeriod13Name(period13Name);
                } else {
                    newPeriode.setApplyPeriod13(0);                    
                    newPeriode.setPeriod13Name("");
                }

                try {
                    vTransaction = DbPeriode.preClosingPeriod(periodId);
                    
                    if (vTransaction == null || vTransaction.size() <= 0) { //jika masih ada transaksi yg masih draft, stop proses tutup periode 

                        if (periodOpenId == 0) {
                            periodOpenId = DbPeriode.insertExc(newPeriode);
                        }
                        if (!isYearlyClosing) {                            
                            DbPeriode.closePeriod(periodId, periodOpenId, isYearlyClosing);
                        } else {
                            DbPeriode.closePeriod(periodId, periodOpenId, isYearlyClosing);
                        }
                    }
                } catch (Exception e) {
                    System.out.println(e);
                }
            }

            if (iJSPCommand == JSPCommand.EDIT) {

                long oid = getClosing(periodId);
                try {
                    if (oid == 0) {
                        Periode openPeriod = DbPeriode.fetchExc(periodId);
                        startDate = openPeriod.getStartDate();
                        startDate.setMonth(startDate.getMonth() + 1);
                        startDate.setDate(1);
                        endDate = (Date) startDate.clone();
                        endDate.setMonth(endDate.getMonth() + 1);
                        endDate.setDate(endDate.getDate() - 1);
                        tolerance = (Date) endDate.clone();
                        tolerance.setDate(tolerance.getDate() + 10);
                        periodOpenId = openPeriod.getOID();
                        periodName = JSPFormater.formatDate(startDate, "MMMM yyyy");
                        period13Name = (startDate.getYear() - 1 + 1900) + " period 13th";
                    } else {
                        Periode openPeriod = DbPeriode.fetchExc(oid);
                        startDate = openPeriod.getStartDate();
                        startDate.setMonth(startDate.getMonth());
                        startDate.setDate(1);
                        endDate = (Date) startDate.clone();
                        endDate.setMonth(endDate.getMonth() + 1);
                        endDate.setDate(endDate.getDate() - 1);
                        tolerance = (Date) endDate.clone();
                        tolerance.setDate(tolerance.getDate() + 10);
                        periodOpenId = openPeriod.getOID();
                        periodName = JSPFormater.formatDate(startDate, "MMMM yyyy");
                        period13Name = (startDate.getYear() - 1 + 1900) + " period 13th";
                    }
                } catch (Exception e) {
                }
            }

            String[] langNav = {"Close Period", "Monthly Closing", "Yearly Closing"};
            if (lang == LANG_ID) {
                String[] navID = {"Tutup Periode", "Tutup Bulanan", "Tutup Tahunan"};
                langNav = navID;
            }

%>
<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
    <head>
        <!-- #BeginEditable "javascript" --> 
        <title><%=systemTitle%></title>
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
        <link href="../css/default.css" rel="stylesheet" type="text/css" />
        <link href="../css/css.css" rel="stylesheet" type="text/css" />
        <script language="JavaScript">            
            <%if (!priv || !privView) {%>
            window.location="<%=approot%>/nopriv.jsp";
            <%}%>
            
            <%if (iJSPCommand == JSPCommand.SAVE && ((vTransaction == null || vTransaction.size() <= 0))) {%>
            window.location="../closing/periode.jsp";
            <%}%>
            
            function cmdSave(){
                document.all.closecmd.style.display="none";
                document.all.closemsg.style.display="";
                document.frmactivityperiod.command.value="<%=JSPCommand.SAVE%>";
                document.frmactivityperiod.prev_command.value="<%=prevJSPCommand%>";
                document.frmactivityperiod.action="closeperiod.jsp";
                document.frmactivityperiod.submit();
            }
            
            function cmdBack(){
                document.frmactivityperiod.command.value="<%=JSPCommand.BACK%>";
                document.frmactivityperiod.action="../closing/periode.jsp";
                document.frmactivityperiod.submit();
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
    <body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','../images/saveclose2.gif','../images/cancel2.gif')">
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
                                        <td width="165" height="100%" valign="top" style="<%="background:url(" + approot + "/images/leftmenu-bg.gif) repeat-y"%>"> 
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
            String navigator = "<font class=\"lvl1\">" + langNav[0] + "</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">" + ((!isYearlyClosing) ? langNav[1] : langNav[2]) + "</span></font>";
%>
<%@ include file="../main/navigator.jsp"%>
                                                    <!-- #EndEditable --></td>
                                                </tr>
                                                <!--tr> 
<td><img src="<%=approot%>/images/title-sp.gif" width="584" height="1"></td> 
                                                </tr-->
                                                <tr> 
                                                    <td><!-- #BeginEditable "content" --> 
                                                        <form name="frmactivityperiod" method ="post" action="">
                                                            <input type="hidden" name="command" value="<%=iJSPCommand%>">
                                                            <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                                                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                            <input type="hidden" name="hidden_periode_id" value="<%=periodId%>">
                                                            <input type="hidden" name="hidden_periode_open_id" value="<%=periodOpenId%>">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr> 
                                                                    <td class="container">
                                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="8"  colspan="3"> 
                                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="8" valign="middle" colspan="3"> 
                                                                                            </td>
                                                                                        </tr>
                                                                                        <%
            try {
                                                                                        %>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="22" valign="middle" colspan="3"> 
                                                                                                <table width="800" border="0" cellspacing="1" cellpadding="1">
                                                                                                    <tr> 
                                                                                                        <td colspan="3"><i><font face="arial" color="#FF0000">Please 
                                                                                                                    click &quot; Save &amp; Close 
                                                                                                                    &quot; button to complete closing 
                                                                                                        period process.</font></i></td>
                                                                                                    </tr>
                                                                                                    <tr height="10"> 
                                                                                                        <td ></td>
                                                                                                        <td width="1"></td>
                                                                                                        <td ></td>
                                                                                                    </tr>                                                                                                    
                                                                                                    <tr> 
                                                                                                        <td width="100" class="tablecell1" style="padding:3px;">Period</td>
                                                                                                        <td width="1" class="fontarial">:</td>
                                                                                                        <td ><input type="text" name="period_name" value="<%=periodName%>" class="fontarial" size="30"></td>
                                                                                                    </tr>
                                                                                                    <tr> 
                                                                                                        <td class="tablecell" style="padding:3px;">Start Date</td>
                                                                                                        <td width="1" class="fontarial">:</td>
                                                                                                        <td ><input name="start_date" value="<%=JSPFormater.formatDate((startDate == null) ? new Date() : startDate, "dd/MM/yyyy")%>" size="11" readonly class="readonly"></td>
                                                                                                    </tr>
                                                                                                    <tr> 
                                                                                                        <td class="tablecell1" style="padding:3px;">End Date</td>
                                                                                                        <td width="1" class="fontarial">:</td>
                                                                                                        <td ><input name="end_date" value="<%=JSPFormater.formatDate((endDate == null) ? new Date() : endDate, "dd/MM/yyyy")%>" size="11" readonly class="readonly"></td>
                                                                                                    </tr>
                                                                                                    <tr> 
                                                                                                        <td class="tablecell" style="padding:3px;">Input Tolerance</td>
                                                                                                        <td width="1" class="fontarial">:</td>
                                                                                                        <td >
                                                                                                            <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                <tr>
                                                                                                                    <td><input name="tolerance" value="<%=JSPFormater.formatDate((tolerance == null) ? new Date() : tolerance, "dd/MM/yyyy")%>" size="11" readonly></td>
                                                                                                                    <td><a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmactivityperiod.tolerance);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a></td> 
                                                                                                                </tr>    
                                                                                                            </table>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <%if (isYearlyClosing && apply13Period.equalsIgnoreCase("Y")) {%>
                                                                                                    <tr> 
                                                                                                        <td class="tablecell1" style="padding:3px;">Apply Period 13th</td>
                                                                                                        <td width="1" class="fontarial">:</td>
                                                                                                        <td ><input type="checkbox" name="activate_13" value="1" checked>Yes</td>
                                                                                                    </tr>
                                                                                                    <tr> 
                                                                                                        <td class="tablecell" style="padding:3px;">Period 13th Name</td>
                                                                                                        <td width="1" class="fontarial">:</td>
                                                                                                        <td ><input type="text" name="period_13_name" value="<%=period13Name%>" size="50"></td>
                                                                                                    </tr>
                                                                                                    <%}else{%>
                                                                                                    <input type="hidden" name="activate_13" value="0">
                                                                                                    <input type="hidden" name="period_13_name" value="">
                                                                                                    <%}%>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <%
            } catch (Exception exc) {
            }%>
                                                                                        <%if (vTransaction != null && vTransaction.size() > 0) {%>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="10" valign="middle" colspan="3"></td>
                                                                                        </tr>
                                                                                        <tr>
                                                                                            <td>
                                                                                                <table width="600" border="0" cellspacing="1" cellpadding="0">
                                                                                                    <tr> 
                                                                                                        <td class="tablehdr" width="20">No.</td>
                                                                                                        <td class="tablehdr" width="100">Jurnal Number</td>
                                                                                                        <td class="tablehdr" >Memo</td>                                                                                                        
                                                                                                    </tr>
                                                                                                    <%
    for (int x = 0; x < vTransaction.size(); x++) {
        CommonObj obj = (CommonObj) vTransaction.get(x);

        String style = "";
        if (x % 2 == 0) {
            style = "tablecell";
        } else {
            style = "tablecell1";
        }

                                                                                                    %>
                                                                                                    <tr> 
                                                                                                        <td class="<%=style%>" align="center"><%=(x + 1) %></td>
                                                                                                        <td class="<%=style%>" align="left" style="padding:3px;"><%=obj.getNumber()%></td>
                                                                                                        <td class="<%=style%>" style="padding:3px;"><%=obj.getMemo() %></td>                                                                                                        
                                                                                                    </tr>                                                        
                                                                                                    <%}%>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <%}%>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="24" valign="middle" colspan="3">
                                                                                                <%if (result.length() > 0) {%>
                                                                                                <font color="#FF0000"><%=result%></font>
                                                                                                <%}%>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="24" valign="middle" colspan="3">                                                                                                 
                                                                                                <table width="80%" border="0" cellspacing="1" cellpadding="1" >                                                                                                                            
                                                                                                    <tr > 
                                                                                                        <td height="3" background="<%=approot%>/images/line1.gif" ></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>        
                                                                                        <tr id="closecmd" align="left" valign="top"> 
                                                                                            <td height="22" valign="middle" colspan="3"> 
                                                                                                <table width="200" border="0" cellspacing="0" cellpadding="0">
                                                                                                    <tr> 
                                                                                                        <td width="130"><a href="javascript:cmdSave()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new21','','../images/closeperiode2.gif',1)"><img src="../images/closeperiode.gif" name="new21" border="0"></a></td>
                                                                                                        <td ><a href="javascript:cmdBack()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new211','','../images/cancel2.gif',1)"><img src="../images/cancel.gif" name="new211" border="0" width="63" height="22"></a></td>                                                                                                        
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr id="closemsg" align="left" valign="top"> 
                                                                                            <td height="22" valign="middle" colspan="3"> 
                                                                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                                    <tr> 
                                                                                                        <td><font color="#006600">Closing period process in progress, please wait .... </font></td>
                                                                                                    </tr>
                                                                                                    <tr> 
                                                                                                        <td height="1">&nbsp;</td>
                                                                                                    </tr>
                                                                                                    <tr> 
                                                                                                        <td><img src="../images/progress_bar.gif" border="0"></td>
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
