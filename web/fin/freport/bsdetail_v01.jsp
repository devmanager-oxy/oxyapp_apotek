
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "com.project.fms.master.*" %>
<%@ page import = "com.project.fms.session.*" %>
<%@ include file = "../main/javainit.jsp" %>
<% int appObjCode = 1; %>
<%@ include file = "../main/check.jsp" %>
<%
            boolean priv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MN_FIN_REP, AppMenu.M2_MN_REPORT);
            boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_FIN_REP, AppMenu.M2_MN_REPORT, AppMenu.PRIV_VIEW);
            boolean privUpdate = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_FIN_REP, AppMenu.M2_MN_REPORT, AppMenu.PRIV_UPDATE);
            boolean privAdd = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_FIN_REP, AppMenu.M2_MN_REPORT, AppMenu.PRIV_ADD);
            boolean privDelete = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_FIN_REP, AppMenu.M2_MN_REPORT, AppMenu.PRIV_DELETE);
%>
<%!
    public String switchLevel(int level) {
        String str = "";
        switch (level) {
            case 1:
                break;
            case 2:
                str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                break;
            case 3:
                str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                break;
            case 4:
                str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                break;
            case 5:
                str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                break;
        }
        return str;
    }

    public String switchLevel1(int level) {
        String str = "";
        switch (level) {
            case 1:
                break;
            case 2:
                str = "       ";
                break;
            case 3:
                str = "              ";
                break;
            case 4:
                str = "                     ";
                break;
            case 5:
                str = "                            ";
                break;
        }
        return str;
    }

    public String strDisplay(double amount, String coaStatus) {
        String displayStr = "";
        if (amount < 0) {
            displayStr = "(" + JSPFormater.formatNumber(amount * -1, "#,###.##") + ")";
        } else if (amount > 0) {
            displayStr = JSPFormater.formatNumber(amount, "#,###.##");
        } else if (amount == 0) {
            displayStr = "";
        }
        if (coaStatus.equals("HEADER")) {
            displayStr = "";
        }
        return displayStr;
    }

%>
<%
            if (session.getValue("BS_STANDARD") != null) {
                session.removeValue("BS_STANDARD");
            }

            String grpType = JSPRequestValue.requestString(request, "groupType");
            int iJSPCommand = JSPRequestValue.requestCommand(request);
            int start = JSPRequestValue.requestInt(request, "start");
            int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
            long oidCoa = JSPRequestValue.requestLong(request, "hidden_coa_id");
            String accGroup = JSPRequestValue.requestString(request, "acc_group");
            int valShowList = JSPRequestValue.requestInt(request, "showlist");
            if (valShowList == 0) {
                valShowList = 1;
            }

            /*variable declaration*/
            int recordToGet = 10;
            int iErrCode = JSPMessage.NONE;
            String whereClause = "";
            String orderClause = "code";

            Vector listCoa = new Vector(1, 1);

            int vectSize = DbCoa.getCount(whereClause);
            recordToGet = vectSize;

            Coa coa = new Coa();

            /* get record to display */
            listCoa = DbCoa.list(start, recordToGet, whereClause, orderClause);

            String strTotal = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
            String strTotal1 = "       ";
            String cssString = "tablecell1";
            String displayStr = "";
            String displayStr_lastYear = "";
            double coaSummary1 = 0;
            double coaSummary1_lastYear = 0;
            double coaSummary2 = 0;
            double coaSummary2_lastYear = 0;
            double coaSummary3 = 0;
            double coaSummary3_lastYear = 0;
            double coaSummary4 = 0;
            double coaSummary4_lastYear = 0;
            double coaSummary5 = 0;
            double coaSummary5_lastYear = 0;
            double coaSummary6 = 0;
            double coaSummary6_lastYear = 0;
            
            Vector listReport = new Vector();
            SesReportBs sesReport = new SesReportBs();

            double totalAktiva = 0;
            double totalAktiva_lastYear = 0;
            double totalPasiva = 0;
            double totalPasiva_lastYear = 0;


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
                document.frmcoa.action="bsdetail_v01.jsp";
                document.frmcoa.submit();
            }
            
            function cmdPrintJournal(){	 
                window.open("<%=printroot%>.report.RptBSStandardPDF?oid=<%=appSessUser.getLoginId()%>");
                }
                
                function cmdPrintJournalXLS(){	 
                    window.open("<%=printroot%>.report.RptPenjelasanNAXLS?oid=<%=appSessUser.getLoginId()%>");
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
            String navigator = "<font class=\"lvl1\">Financial Report</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">Penjelasan Neraca Akhir</span></font>";
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
                                                                            <tr align="left"> 
                                                                                <td height="8" valign="middle" colspan="3"></td>
                                                                            </tr>                                  
                                                                            <tr align="left"> 
                                                                                <td width="6%">Show List </td>
                                                                                <td width="94%" colspan="2" valign="top"> 
                                                                                    <select name="showlist" onChange="javascript:cmdChangeList()">
                                                                                        <option value="1" <%if (valShowList == 1) {%>selected<%}%>>Hide Acc. Without Transaction</option>
                                                                                        <option value="2" <%if (valShowList == 2) {%>selected<%}%>>All</option>
                                                                                    </select>
                                                                                </td>                                  
                                                                            </tr>                          
                                                                            <tr align="left"> 
                                                                                <td height="20" valign="middle" align="center" colspan="3"><span class="level1"><font size="+1"><b>PENJELASAN 
                                                                                NERACA AKHIR</b></font></span></td>
                                                                            </tr>                          
                                                                            <%
            Periode periode = DbPeriode.getOpenPeriod();
            
            String bulan = "";
            
            if(periode.getStartDate().getMonth() == 0){
                bulan = "Januari";                
            }else if(periode.getStartDate().getMonth() == 1){
                bulan = "Februari";                
            }else if(periode.getStartDate().getMonth() == 2){
                bulan = "Maret";                
            }else if(periode.getStartDate().getMonth() == 3){
                bulan = "April";                
            }else if(periode.getStartDate().getMonth() == 4){
                bulan = "Mei";                
            }else if(periode.getStartDate().getMonth() == 5){
                bulan = "Juni";                
            }else if(periode.getStartDate().getMonth() == 6){
                bulan = "Juli";                
            }else if(periode.getStartDate().getMonth() == 7){
                bulan = "Agustus";                
            }else if(periode.getStartDate().getMonth() == 8){
                bulan = "September";                
            }else if(periode.getStartDate().getMonth() == 9){
                bulan = "Oktober";                
            }else if(periode.getStartDate().getMonth() == 10){
                bulan = "November";                
            }else if(periode.getStartDate().getMonth() == 11){
                bulan = "Desember";                
            }
            
            String openPeriod = "BULAN " + bulan.toUpperCase()+" "+JSPFormater.formatDate(periode.getStartDate(), "yyyy");//+ " - " + JSPFormater.formatDate(periode.getEndDate(), "dd MMM yyyy");        
%>        
                                                                            <tr align="left"> 
                                                                                <td height="20" valign="middle" align="center" colspan="3"><span class="level1"><b><%=openPeriod.toUpperCase()%></b></span></td>
                                                                            </tr>         
                                                                            
                                                                            <tr align="left"> 
                                                                                <td height="10" valign="middle" colspan="3"></td>
                                                                            </tr>                                  
                                                                            <tr align="left"> 
                                                                                <td height="22" valign="middle" colspan="3" class="page"> 
                                                                                    <table width="100%" border="0" cellpadding="1" height="20" cellspacing="1">
                                                                                        <tr> 
                                                                                            <td width="50%" class="tablehdr" height="22"> 
                                                                                                <div align="center"><font size="1"><b><font color="#FFFFFF">Description</font></b></font></div>
                                                                                            </td>
                                                                                            <td width="25%" class="tablehdr" height="22"><font size="1"><%=bulan%>&nbsp;<%=JSPFormater.formatDate(periode.getStartDate(), "yyyy")%></font></td>
                                                                                            <% 
                                                                                            int year = periode.getStartDate().getYear()+1900 -1 ;   
                                                                                            %>
                                                                                            <td width="25%" class="tablehdr" height="22"><font size="1"><%=bulan%>&nbsp;<%=year%></font></td>
                                                                                        </tr>
                                                                                        <tr> 
                                                                                            <td width="50%" class="tablecell"><b>ACTIVA</b></td>
                                                                                            <td width="25%" class="tablecell">&nbsp;</td>
                                                                                            <td width="25%" class="tablecell">&nbsp;</td>
                                                                                        </tr>
                                                                                        <!--level Liquid Assets-->
                                        <%	//add Top Header
                                        
            sesReport = new SesReportBs();
            sesReport.setType("Top Level");
            sesReport.setDescription("ACTIVA");
            sesReport.setFont(1);
            listReport.add(sesReport);

            sesReport = new SesReportBs();
            sesReport.setType("Group Level");
            sesReport.setDescription(strTotal1 + I_Project.ACC_GROUP_LIQUID_ASSET);
            sesReport.setFont(1);
            listReport.add(sesReport);
                                                                                 %>
                                                                                        <tr> 
                                                                                            <td width="50%" class="tablecell"><b><font size="1"><%=strTotal + I_Project.ACC_GROUP_LIQUID_ASSET%></font></b></td>
                                                                                            <td width="25%" class="tablecell">&nbsp;</td>
                                                                                            <td width="25%" class="tablecell">&nbsp;</td>
                                                                                        </tr>
                                                                                        <%

            listCoa = DbCoa.list(0, 0, "account_group='Liquid Assets'", "code");
           
            if (listCoa != null && listCoa.size() > 0) {
                
                coaSummary1 = 0;
                coaSummary1_lastYear = 0;
                
                String str = "";
                String str1 = "";
                
                for (int i = 0; i < listCoa.size(); i++) {
                    
                    coa = (Coa) listCoa.get(i);

                    str = switchLevel(coa.getLevel());
                    str1 = switchLevel1(coa.getLevel());
                    
                    double amount = DbCoa.getCoaBalance(coa.getOID());                    
                    //untuk mendapatkan balance tahun sebelumnya
                    double amountPerevious = DbCoa.getCoaBalanceLastYear(coa.getOID());
                    
                    coaSummary1 = coaSummary1 + amount;
                    coaSummary1_lastYear = coaSummary1_lastYear + amountPerevious;
                    
                    displayStr = strDisplay(amount, coa.getStatus());
                    displayStr_lastYear = strDisplay(amountPerevious, coa.getStatus());

                    sesReport = new SesReportBs();
                    sesReport.setType(coa.getStatus());
                    sesReport.setDescription(strTotal1 + strTotal1 + str1 + coa.getCode() + " - " + coa.getName());
                    
                    sesReport.setAmount(amount);
                    sesReport.setStrAmount("" + amount);
                    
                    sesReport.setAmountPrevYear(amountPerevious);
                    sesReport.setStrAmountPrevYear(""+amountPerevious);
                    
                    sesReport.setFont(coa.getStatus().equals("HEADER") ? 1 : 0);
                    listReport.add(sesReport);
                                                                                        %>
                                                                                        <tr> 
                                                                                            <td width="50%" class="<%=cssString%>" nowrap><font size="1"> 
                                                                                                    <%if (coa.getStatus().equals("HEADER")) {%>
                                                                                                    <b> 
                                                                                                        <%}%>
                                                                                                        <%=strTotal + strTotal + str + coa.getCode() + " - " + coa.getName()%> 
                                                                                                        <%if (coa.getStatus().equals("HEADER")) {%>
                                                                                                    </b> 
                                                                                                    <%}%>
                                                                                            </font></td>
                                                                                            <td width="25%" class="<%=cssString%>"> 
                                                                                                <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                                                                                    <tr> 
                                                                                                        <td width="5%"></td>
                                                                                                        <td width="90%" class="<%=cssString%>"> 
                                                                                                            <div align="right"><font size="1"><%=displayStr%></font></div>
                                                                                                        </td>
                                                                                                        <td width="5%"></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                            <td width="25%" class="<%=cssString%>"> 
                                                                                                <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                                                                                    <tr> 
                                                                                                        <td width="5%"></td>
                                                                                                        <td width="90%" class="<%=cssString%>"> 
                                                                                                            <div align="right"><font size="1"><%=displayStr_lastYear%></font></div>
                                                                                                        </td>
                                                                                                        <td width="5%"></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <%
                                                                                            }//end for

                                                                                            if (coaSummary1 < 0) {
                                                                                                displayStr = "(" + JSPFormater.formatNumber(coaSummary1 * -1, "#,###.##") + ")";
                                                                                            } else if (coaSummary1 > 0) {
                                                                                                displayStr = JSPFormater.formatNumber(coaSummary1, "#,###.##");
                                                                                            } else if (coaSummary1 == 0) {
                                                                                                displayStr = "";
                                                                                            }
                
                                                                                            if (coaSummary1_lastYear < 0) {
                                                                                                displayStr_lastYear = "(" + JSPFormater.formatNumber(coaSummary1_lastYear * -1, "#,###.##") + ")";
                                                                                            } else if (coaSummary1_lastYear > 0) {
                                                                                                displayStr_lastYear = JSPFormater.formatNumber(coaSummary1_lastYear, "#,###.##");
                                                                                            } else if (coaSummary1_lastYear == 0) {
                                                                                                displayStr_lastYear = "";
                                                                                            }

                                                                                            sesReport = new SesReportBs();
                                                                                            sesReport.setType("Footer Group Level");
                                                                                            sesReport.setDescription(strTotal1 + "Sub Total " + I_Project.ACC_GROUP_LIQUID_ASSET);
                                                                                            sesReport.setAmount(coaSummary1);
                                                                                            sesReport.setAmountPrevYear(coaSummary1_lastYear);
                                                                                            sesReport.setStrAmount("" + coaSummary1);
                                                                                            sesReport.setStrAmountPrevYear("" + coaSummary1_lastYear);
                                                                                            sesReport.setFont(1);
                                                                                            listReport.add(sesReport);
                                                                                        %>
                                                                                        
                                                                                        <tr> 
                                                                                            <td width="50%" class="tablecell2"><span class="level2"><b><font size="1"><%=" Sub Total " + I_Project.ACC_GROUP_LIQUID_ASSET%></font></b></span></td>
                                                                                            <td width="25%" class="tablecell2" align="right"> 
                                                                                                <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                                                                                    <tr> 
                                                                                                        <td width="5%"></td>
                                                                                                        <td width="90%" class="tablecell2"> 
                                                                                                            <div align="right"><font size="1"><b><%=displayStr%></b></font></div>
                                                                                                        </td>
                                                                                                        <td width="5%"></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                            <td width="25%" class="tablecell2" align="right"> 
                                                                                                <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                                                                                    <tr> 
                                                                                                        <td width="5%"></td>
                                                                                                        <td width="90%" class="tablecell2"> 
                                                                                                            <div align="right"><font size="1"><b><%=displayStr_lastYear%></b></font></div>
                                                                                                        </td>
                                                                                                        <td width="5%"></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <%
            }//end list != null
%>
  

                                                                                        <!--level Fix Assets-->
                                                                                        <%
            sesReport = new SesReportBs();
            sesReport.setType("Group Level");
            sesReport.setDescription(strTotal1 + I_Project.ACC_GROUP_FIXED_ASSET);
            sesReport.setFont(1);
            listReport.add(sesReport);
                                                                                        %>
                                                                                        <tr> 
                                                                                            <td width="50%" class="tablecell"><b><font size="1"><%=strTotal + I_Project.ACC_GROUP_FIXED_ASSET%></font></b></td>
                                                                                            <td width="25%" class="tablecell"><font size="1"></font></td>
                                                                                            <td width="25%" class="tablecell"><font size="1"></font></td>
                                                                                        </tr>
                                                                                        <%

            listCoa = DbCoa.list(0, 0, "account_group='Fixed Assets'", "code");

            if (listCoa != null && listCoa.size() > 0) {
                coaSummary2 = 0;
                String str = "";
                String str1 = "";
                for (int i = 0; i < listCoa.size(); i++) {
                    
                    coa = (Coa) listCoa.get(i);

                    str = switchLevel(coa.getLevel());
                    str1 = switchLevel1(coa.getLevel());
                    
                    double amount = DbCoa.getCoaBalance(coa.getOID());
                    double amountPerevious = DbCoa.getCoaBalanceLastYear(coa.getOID());
                    
                    coaSummary2 = coaSummary2 + amount;
                    coaSummary2_lastYear = coaSummary2_lastYear + amountPerevious;
                    
                    displayStr = strDisplay(amount, coa.getStatus());
                    displayStr_lastYear = strDisplay(amountPerevious, coa.getStatus());

                    sesReport = new SesReportBs();
                    sesReport.setType(coa.getStatus());
                    sesReport.setDescription(strTotal1 + strTotal1 + str1 + coa.getCode() + " - " + coa.getName());
                    sesReport.setAmount(amount);
                    sesReport.setStrAmount("" + amount);
                    sesReport.setAmountPrevYear(amountPerevious);
                    sesReport.setStrAmountPrevYear("" + amountPerevious);
                    sesReport.setFont(coa.getStatus().equals("HEADER") ? 1 : 0);
                    listReport.add(sesReport);
                                                                                        %>
                                                                                        <tr> 
                                                                                            <td width="50%" class="<%=cssString%>" nowrap><font size="1"> 
                                                                                                    <%if (coa.getStatus().equals("HEADER")) {%>
                                                                                                    <b> 
                                                                                                        <%}%>
                                                                                                        <%=strTotal + strTotal + str + coa.getCode() + " - " + coa.getName()%> 
                                                                                                        <%if (coa.getStatus().equals("HEADER")) {%>
                                                                                                    </b> 
                                                                                                    <%}%>
                                                                                            </font></td>
                                                                                            <td width="25%" class="<%=cssString%>"> 
                                                                                                <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                                                                                    <tr> 
                                                                                                        <td width="5%"></td>
                                                                                                        <td width="90%" class="<%=cssString%>"> 
                                                                                                            <div align="right"><font size="1"><%=displayStr%></font></div>
                                                                                                        </td>
                                                                                                        <td width="5%"></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                            <td width="25%" class="<%=cssString%>"> 
                                                                                                <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                                                                                    <tr> 
                                                                                                        <td width="5%"></td>
                                                                                                        <td width="90%" class="<%=cssString%>"> 
                                                                                                            <div align="right"><font size="1"><%=displayStr_lastYear%></font></div>
                                                                                                        </td>
                                                                                                        <td width="5%"></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <%

                                                                                            }//end for

                                                                                            if (coaSummary2 < 0) {
                                                                                                displayStr = "(" + JSPFormater.formatNumber(coaSummary2 * -1, "#,###.##") + ")";
                                                                                            } else if (coaSummary2 > 0) {
                                                                                                displayStr = JSPFormater.formatNumber(coaSummary2, "#,###.##");
                                                                                            } else if (coaSummary2 == 0) {
                                                                                                displayStr = "";
                                                                                            }
                
                                                                                            if (coaSummary2_lastYear < 0) {
                                                                                                displayStr_lastYear = "(" + JSPFormater.formatNumber(coaSummary2_lastYear * -1, "#,###.##") + ")";
                                                                                            } else if (coaSummary2_lastYear > 0) {
                                                                                                displayStr_lastYear = JSPFormater.formatNumber(coaSummary2_lastYear, "#,###.##");
                                                                                            } else if (coaSummary2_lastYear == 0) {
                                                                                                displayStr_lastYear = "";
                                                                                            }

                                                                                            sesReport = new SesReportBs();
                                                                                            sesReport.setType("Footer Group Level");
                                                                                            sesReport.setDescription(strTotal1 + "Sub Total " + I_Project.ACC_GROUP_FIXED_ASSET);
                                                                                            sesReport.setAmount(coaSummary2);
                                                                                            sesReport.setStrAmount("" + coaSummary2);                                                                                            
                                                                                            sesReport.setAmountPrevYear(coaSummary2_lastYear);
                                                                                            sesReport.setStrAmountPrevYear("" + coaSummary2_lastYear);
                                                                                            sesReport.setFont(1);
                                                                                            listReport.add(sesReport);
                                                                                        %>
                                                                                        <tr> 
                                                                                            <td width="50%" class="tablecell2"><span class="level2"><b><font size="1"><%=strTotal + " Sub Total " + I_Project.ACC_GROUP_FIXED_ASSET%></font></b></span></td>
                                                                                            <td width="25%" class="tablecell2" align="right"> 
                                                                                                <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                                                                                    <tr> 
                                                                                                        <td width="5%"></td>
                                                                                                        <td width="90%" class="tablecell2"> 
                                                                                                            <div align="right"><font size="1"><b><%=displayStr%></b></font></div>
                                                                                                        </td>
                                                                                                        <td width="5%"></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                            <td width="25%" class="tablecell2" align="right"> 
                                                                                                <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                                                                                    <tr> 
                                                                                                        <td width="5%"></td>
                                                                                                        <td width="90%" class="tablecell2"> 
                                                                                                            <div align="right"><font size="1"><b><%=displayStr_lastYear%></b></font></div>
                                                                                                        </td>
                                                                                                        <td width="5%"></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <%

            } //end if != null
%>
                                                                                        <!--level Other Assets-->
                                                                                        <%
            sesReport = new SesReportBs();
            sesReport.setType("Group Level");
            sesReport.setDescription(strTotal1 + I_Project.ACC_GROUP_OTHER_ASSET);
            sesReport.setFont(1);
            listReport.add(sesReport);
                                                                                        %>
                                                                                        <tr> 
                                                                                            <td width="50%" class="tablecell"><b><font size="1"><%=strTotal + I_Project.ACC_GROUP_OTHER_ASSET%></font></b></td>
                                                                                            <td width="25%" class="tablecell"><font size="1"></font></td>
                                                                                            <td width="25%" class="tablecell"><font size="1"></font></td>
                                                                                        </tr>
                                                                                        <%

            listCoa = DbCoa.list(0, 0, "account_group='Other Assets'", "code");

            if (listCoa != null && listCoa.size() > 0) {
                coaSummary3 = 0;
                String str = "";
                String str1 = "";
                for (int i = 0; i < listCoa.size(); i++) {
                    coa = (Coa) listCoa.get(i);

                    str = switchLevel(coa.getLevel());
                    str1 = switchLevel1(coa.getLevel());
                    
                    double amount = DbCoa.getCoaBalance(coa.getOID());
                    double amountPerevious = DbCoa.getCoaBalanceLastYear(coa.getOID());
                    
                    coaSummary3 = coaSummary3 + amount;
                    coaSummary3_lastYear = coaSummary3_lastYear + amountPerevious;
                    
                    displayStr = strDisplay(amount, coa.getStatus());
                    displayStr_lastYear = strDisplay(amountPerevious, coa.getStatus());
                    
                    sesReport = new SesReportBs();
                    sesReport.setType(coa.getStatus());
                    sesReport.setDescription(strTotal1 + strTotal1 + str1 + coa.getCode() + " - " + coa.getName());
                    
                    sesReport.setAmount(amount);
                    sesReport.setStrAmount("" + amount);
                    
                    sesReport.setAmountPrevYear(amountPerevious);
                    sesReport.setStrAmountPrevYear("" + amountPerevious);
                    
                    sesReport.setFont(coa.getStatus().equals("HEADER") ? 1 : 0);
                    listReport.add(sesReport);
                                                                                        %>
                                                                                        <tr> 
                                                                                            <td width="50%" class="<%=cssString%>" nowrap><font size="1"> 
                                                                                                    <%if (coa.getStatus().equals("HEADER")) {%>
                                                                                                    <b> 
                                                                                                        <%}%>
                                                                                                        <%=strTotal + strTotal + str + coa.getCode() + " - " + coa.getName()%> 
                                                                                                        <%if (coa.getStatus().equals("HEADER")) {%>
                                                                                                    </b> 
                                                                                                    <%}%>
                                                                                            </font></td>
                                                                                            <td width="25%" class="<%=cssString%>"> 
                                                                                                <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                                                                                    <tr> 
                                                                                                        <td width="5%"></td>
                                                                                                        <td width="90%" class="<%=cssString%>"> 
                                                                                                            <div align="right"><font size="1"><%=displayStr%></font></div>
                                                                                                        </td>
                                                                                                        <td width="5%"></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                            <td width="25%" class="<%=cssString%>"> 
                                                                                                <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                                                                                    <tr> 
                                                                                                        <td width="5%"></td>
                                                                                                        <td width="90%" class="<%=cssString%>"> 
                                                                                                            <div align="right"><font size="1"><%=displayStr_lastYear%></font></div>
                                                                                                        </td>
                                                                                                        <td width="5%"></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <%
                                                                                            } // end for

                                                                                            if (coaSummary3 < 0) {
                                                                                                displayStr = "(" + JSPFormater.formatNumber(coaSummary3 * -1, "#,###.##") + ")";
                                                                                            } else if (coaSummary3 > 0) {
                                                                                                displayStr = JSPFormater.formatNumber(coaSummary3, "#,###.##");
                                                                                            } else if (coaSummary3 == 0) {
                                                                                                displayStr = "";
                                                                                            }

                                                                                            if (coaSummary3_lastYear < 0) {
                                                                                                displayStr_lastYear = "(" + JSPFormater.formatNumber(coaSummary3_lastYear * -1, "#,###.##") + ")";
                                                                                            } else if (coaSummary3_lastYear > 0) {
                                                                                                displayStr_lastYear = JSPFormater.formatNumber(coaSummary3_lastYear, "#,###.##");
                                                                                            } else if (coaSummary3_lastYear == 0) {
                                                                                                displayStr_lastYear = "";
                                                                                            }

                                                                                            sesReport = new SesReportBs();
                                                                                            sesReport.setType("Footer Group Level");
                                                                                            sesReport.setDescription(strTotal1 + "Sub Total " + I_Project.ACC_GROUP_OTHER_ASSET);
                                                                                            sesReport.setAmount(coaSummary3);
                                                                                            sesReport.setStrAmount("" + coaSummary3);
                                                                                            sesReport.setAmountPrevYear(coaSummary3_lastYear);
                                                                                            sesReport.setStrAmountPrevYear("" + coaSummary3_lastYear);
                                                                                            sesReport.setFont(1);
                                                                                            listReport.add(sesReport);
                                                                                            
                                                                                        %>
                                                                                        <tr> 
                                                                                            <td width="50%" class="tablecell2"><span class="level2"><b><font size="1"><%=strTotal + " Sub Total " + I_Project.ACC_GROUP_OTHER_ASSET%></font></b></span></td>
                                                                                            <td width="25%" class="tablecell2" align="right"> 
                                                                                                <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                                                                                    <tr> 
                                                                                                        <td width="5%"></td>
                                                                                                        <td width="90%" class="tablecell2"> 
                                                                                                            <div align="right"><font size="1"><b><%=displayStr%></b></font></div>
                                                                                                        </td>
                                                                                                        <td width="5%"></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                            <td width="25%" class="tablecell2" align="right"> 
                                                                                                <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                                                                                    <tr> 
                                                                                                        <td width="5%"></td>
                                                                                                        <td width="90%" class="tablecell2"> 
                                                                                                            <div align="right"><font size="1"><b><%=displayStr_lastYear%></b></font></div>
                                                                                                        </td>
                                                                                                        <td width="5%"></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <%
            }//end list !=null

            totalAktiva = coaSummary1 + coaSummary2 + coaSummary3;
            totalAktiva_lastYear = coaSummary1_lastYear + coaSummary2_lastYear + coaSummary3_lastYear;       
                

            if (coaSummary1 + coaSummary2 + coaSummary3 < 0) {
                displayStr = "(" + JSPFormater.formatNumber((coaSummary1 + coaSummary2 + coaSummary3) * -1, "#,###.##") + ")";
            } else if (coaSummary1 + coaSummary2 + coaSummary3 > 0) {
                displayStr = JSPFormater.formatNumber((coaSummary1 + coaSummary2 + coaSummary3), "#,###.##");
            } else if (coaSummary1 + coaSummary2 + coaSummary3 == 0) {
                displayStr = "";
            }
            
            if (coaSummary1_lastYear + coaSummary2_lastYear + coaSummary3_lastYear < 0) {
                displayStr_lastYear = "(" + JSPFormater.formatNumber((coaSummary1_lastYear + coaSummary2_lastYear + coaSummary3_lastYear) * -1, "#,###.##") + ")";
            } else if (coaSummary1_lastYear + coaSummary2_lastYear + coaSummary3_lastYear > 0) {
                displayStr_lastYear = JSPFormater.formatNumber((coaSummary1_lastYear + coaSummary2_lastYear + coaSummary3_lastYear), "#,###.##");
            } else if (coaSummary1_lastYear + coaSummary2_lastYear + coaSummary3_lastYear == 0) {
                displayStr_lastYear = "";
            }
            
            //add footer level
            if ((coaSummary1 + coaSummary2 + coaSummary3 != 0 ) || ( coaSummary1_lastYear + coaSummary2_lastYear + coaSummary3_lastYear != 0 ) || valShowList != 1) {	//add Group Footer
                
                sesReport = new SesReportBs();
                sesReport.setType("Footer Top Level");
                sesReport.setDescription("TOTAL ACTIVA");
                sesReport.setAmount(coaSummary1 + coaSummary2 + coaSummary3);
                sesReport.setStrAmount("" + (coaSummary1 + coaSummary2 + coaSummary3));                
                sesReport.setAmountPrevYear(coaSummary1_lastYear + coaSummary2_lastYear + coaSummary3_lastYear);
                sesReport.setStrAmountPrevYear("" + (coaSummary1_lastYear + coaSummary2_lastYear + coaSummary3_lastYear));
                
                sesReport.setFont(1);
                listReport.add(sesReport);
                                                                                        %>
                                                                                        <tr> 
                                                                                            <td width="50%" class="tablecell2"><span class="level2"><b>TOTAL 
                                                                                            ACTIVA</b></span></td>
                                                                                            <td width="25%" class="tablecell2" align="right"> 
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
                                                                                            <td width="25%" class="tablecell2" align="right"> 
                                                                                                <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                                                                                    <tr> 
                                                                                                        <td width="5%"></td>
                                                                                                        <td width="90%" class="tablecell2"><span class="level2"> 
                                                                                                                <div align="right"><b><%=displayStr_lastYear%></b></div>
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
                                                                                            <td width="50%" class="tablecell1" height="15"><font size="1"></font></td>
                                                                                            <td width="25%" class="tablecell1"><font size="1"></font></td>
                                                                                            <td width="25%" class="tablecell1"><font size="1"></font></td>
                                                                                        </tr>
                                                                                        <tr>
                                                                                            <td width="50%" class="tablecell"><b>PASIVA</b></td>
                                                                                            <td width="25%" class="tablecell">&nbsp;</td>
                                                                                            <td width="25%" class="tablecell">&nbsp;</td>
                                                                                        </tr>
                                                                                        <!--level 2-->
                                                                                        <tr> 
                                                                                            <td width="50%" class="tablecell"><b><font size="1">Liabilities</font></b></td>
                                                                                            <td width="25%" class="tablecell"><font size="1"></font></td>
                                                                                            <td width="25%" class="tablecell"><font size="1"></font></td>
                                                                                        </tr>
                                                                                        <!--level current liabilities-->
                                        <%	//add Top Header
            sesReport = new SesReportBs();
            sesReport.setType("Top Level");
            sesReport.setDescription("PASIVA");
            sesReport.setFont(1);
            listReport.add(sesReport);

            sesReport = new SesReportBs();
            sesReport.setType("Top Level");
            sesReport.setDescription("Liabilities");
            sesReport.setFont(1);
            listReport.add(sesReport);

            sesReport = new SesReportBs();
            sesReport.setType("Group Level");
            sesReport.setDescription(strTotal1 + I_Project.ACC_GROUP_CURRENT_LIABILITIES);
            sesReport.setFont(1);
            listReport.add(sesReport);
                                                                                 %>
                                                                                        <tr> 
                                                                                            <td width="50%" class="tablecell"><b><font size="1"><%=strTotal + I_Project.ACC_GROUP_CURRENT_LIABILITIES%></font></b></td>
                                                                                            <td width="25%" class="tablecell"><font size="1"></font></td>
                                                                                            <td width="25%" class="tablecell"><font size="1"></font></td>
                                                                                        </tr>
                                                                                        <%

            listCoa = DbCoa.list(0, 0, "account_group='Current Liabilities'", "code");

            if (listCoa != null && listCoa.size() > 0) {
                coaSummary4 = 0;
                String str = "";
                String str1 = "";
                
                for (int i = 0; i < listCoa.size(); i++) {
                    
                    coa = (Coa) listCoa.get(i);

                    str = switchLevel(coa.getLevel());
                    str1 = switchLevel1(coa.getLevel());
                    
                    double amount = DbCoa.getCoaBalanceCD(coa.getOID());
                    double amountPrevious = DbCoa.getCoaBalanceLastYear(coa.getOID());
                    
                    coaSummary4 = coaSummary4 + amount;
                    coaSummary4_lastYear = coaSummary4_lastYear + amountPrevious;

                    displayStr = strDisplay(amount, coa.getStatus());
                    displayStr_lastYear = strDisplay(amountPrevious, coa.getStatus());

                    sesReport = new SesReportBs();
                    sesReport.setType(coa.getStatus());
                    sesReport.setDescription(strTotal1 + strTotal1 + str1 + coa.getCode() + " - " + coa.getName());
                    
                    sesReport.setAmount(amount);
                    sesReport.setStrAmount("" + amount);
                    
                    sesReport.setAmountPrevYear(amountPrevious);
                    sesReport.setStrAmountPrevYear("" + amountPrevious);
                    
                    sesReport.setFont(coa.getStatus().equals("HEADER") ? 1 : 0);
                    listReport.add(sesReport);
                    
                                                                                        %>
                                                                                        <tr> 
                                                                                            <td width="50%" class="<%=cssString%>" nowrap><font size="1"> 
                                                                                                    <%if (coa.getStatus().equals("HEADER")) {%>
                                                                                                    <b> 
                                                                                                        <%}%>
                                                                                                        <%=strTotal + strTotal + str + coa.getCode() + " - " + coa.getName()%> 
                                                                                                        <%if (coa.getStatus().equals("HEADER")) {%>
                                                                                                    </b> 
                                                                                                    <%}%>
                                                                                            </font></td>
                                                                                            <td width="25%" class="<%=cssString%>"> 
                                                                                                <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                                                                                    <tr> 
                                                                                                        <td width="5%"></td>
                                                                                                        <td width="90%" class="<%=cssString%>"> 
                                                                                                            <div align="right"><font size="1"><%=displayStr%></font></div>
                                                                                                        </td>
                                                                                                        <td width="5%"></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                            <td width="25%" class="<%=cssString%>"> 
                                                                                                <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                                                                                    <tr> 
                                                                                                        <td width="5%"></td>
                                                                                                        <td width="90%" class="<%=cssString%>"> 
                                                                                                            <div align="right"><font size="1"><%=displayStr_lastYear%></font></div>
                                                                                                        </td>
                                                                                                        <td width="5%"></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <%
                                                                                            }//end for

                                                                                            if (coaSummary4 < 0) {
                                                                                                displayStr = "(" + JSPFormater.formatNumber(coaSummary4 * -1, "#,###.##") + ")";
                                                                                            } else if (coaSummary4 < 0) {
                                                                                                displayStr = JSPFormater.formatNumber(coaSummary4, "#,###.##");
                                                                                            } else if (coaSummary4 == 0) {
                                                                                                displayStr = "";
                                                                                            }
                
                                                                                            if (coaSummary4_lastYear < 0) {
                                                                                                displayStr_lastYear = "(" + JSPFormater.formatNumber(coaSummary4_lastYear * -1, "#,###.##") + ")";
                                                                                            } else if (coaSummary4_lastYear < 0) {
                                                                                                displayStr_lastYear = JSPFormater.formatNumber(coaSummary4_lastYear, "#,###.##");
                                                                                            } else if (coaSummary4_lastYear == 0) {
                                                                                                displayStr_lastYear = "";
                                                                                            }

                                                                                            sesReport = new SesReportBs();
                                                                                            sesReport.setType("Footer Group Level");
                                                                                            sesReport.setDescription(strTotal1 + "Sub Total " + I_Project.ACC_GROUP_CURRENT_LIABILITIES);
                                                                                            
                                                                                            sesReport.setAmount(coaSummary4);
                                                                                            sesReport.setStrAmount("" + coaSummary4);
                                                                                            
                                                                                            sesReport.setAmountPrevYear(coaSummary4_lastYear);
                                                                                            sesReport.setStrAmountPrevYear("" + coaSummary4_lastYear);
                                                                                            
                                                                                            sesReport.setFont(1);
                                                                                            listReport.add(sesReport);
                                                                                            
                                                                                        %>
                                                                                        <tr> 
                                                                                            <td width="50%" class="tablecell2"><span class="level2"><b><font size="1"><%=strTotal + " Sub Total " + I_Project.ACC_GROUP_CURRENT_LIABILITIES%></font></b></span></td>
                                                                                            <td width="25%" class="tablecell2" align="right"> 
                                                                                                <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                                                                                    <tr> 
                                                                                                        <td width="5%"></td>
                                                                                                        <td width="90%" class="tablecell2"> 
                                                                                                            <div align="right"><font size="1"><b><%=displayStr%></b></font></div>
                                                                                                        </td>
                                                                                                        <td width="5%"></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                            <td width="25%" class="tablecell2" align="right"> 
                                                                                                <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                                                                                    <tr> 
                                                                                                        <td width="5%"></td>
                                                                                                        <td width="90%" class="tablecell2"> 
                                                                                                            <div align="right"><font size="1"><b><%=displayStr_lastYear%></b></font></div>
                                                                                                        </td>
                                                                                                        <td width="5%"></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <%

            }//end if not null

                                                                                        %>
                                                                                        <!--level Long term liabilities-->
                                                                                        <%
            sesReport = new SesReportBs();
            sesReport.setType("Group Level");
            sesReport.setDescription(strTotal1 + I_Project.ACC_GROUP_LONG_TERM_LIABILITIES);
            sesReport.setFont(1);
            listReport.add(sesReport);
                                                                                        %>
                                                                                        <tr> 
                                                                                            <td width="50%" class="tablecell"><b><font size="1"><%=strTotal + I_Project.ACC_GROUP_LONG_TERM_LIABILITIES%></font></b></td>
                                                                                            <td width="25%" class="tablecell"><font size="1"></font></td>
                                                                                            <td width="25%" class="tablecell"><font size="1"></font></td>
                                                                                        </tr>
                                                                                        <%

            listCoa = DbCoa.list(0, 0, "account_group='Long Term Liabilities'", "code");

            if (listCoa != null && listCoa.size() > 0) {
                
                coaSummary5 = 0;
                String str = "";
                String str1 = "";
                
                for (int i = 0; i < listCoa.size(); i++) {
                    coa = (Coa) listCoa.get(i);

                    str = switchLevel(coa.getLevel());
                    str1 = switchLevel1(coa.getLevel());
                    
                    double amount = DbCoa.getCoaBalanceCD(coa.getOID());
                    double amountPerevious = DbCoa.getCoaBalanceLastYear(coa.getOID());
                    
                    displayStr_lastYear = strDisplay(amountPerevious, coa.getStatus());
                    
                    coaSummary5 = coaSummary5 + amount;
                    coaSummary5_lastYear = coaSummary5_lastYear + amountPerevious;
                    
                    displayStr = strDisplay(amount, coa.getStatus());
                    displayStr_lastYear = strDisplay(amountPerevious, coa.getStatus());
                    
                    sesReport = new SesReportBs();
                    sesReport.setType(coa.getStatus());
                    sesReport.setDescription(strTotal1 + strTotal1 + str1 + coa.getCode() + " - " + coa.getName());
                    
                    sesReport.setAmount(amount);
                    sesReport.setStrAmount("" + amount);
                    
                    sesReport.setAmountPrevYear(amountPerevious);
                    sesReport.setStrAmountPrevYear("" + amountPerevious);
                    
                    sesReport.setFont(coa.getStatus().equals("HEADER") ? 1 : 0);
                    listReport.add(sesReport);
                                                                                        %>
                                                                                        <tr> 
                                                                                            <td width="50%" class="<%=cssString%>" nowrap><font size="1"> 
                                                                                                    <%if (coa.getStatus().equals("HEADER")) {%>
                                                                                                    <b> 
                                                                                                        <%}%>
                                                                                                        <%=strTotal + strTotal + str + coa.getCode() + " - " + coa.getName()%> 
                                                                                                        <%if (coa.getStatus().equals("HEADER")) {%>
                                                                                                    </b> 
                                                                                                    <%}%>
                                                                                            </font></td>
                                                                                            <td width="25%" class="<%=cssString%>"> 
                                                                                                <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                                                                                    <tr> 
                                                                                                        <td width="5%"></td>
                                                                                                        <td width="90%" class="<%=cssString%>"> 
                                                                                                            <div align="right"><font size="1"><%=displayStr%></font></div>
                                                                                                        </td>
                                                                                                        <td width="5%"></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                            <td width="25%" class="<%=cssString%>"> 
                                                                                                <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                                                                                    <tr> 
                                                                                                        <td width="5%"></td>
                                                                                                        <td width="90%" class="<%=cssString%>"> 
                                                                                                            <div align="right"><font size="1"><%=displayStr_lastYear%></font></div>
                                                                                                        </td>
                                                                                                        <td width="5%"></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                            
                                                                                        </tr>
                                                                                        <%
                                                                                            }//end for

                                                                                            if (coaSummary5 < 0) {
                                                                                                displayStr = "(" + JSPFormater.formatNumber(coaSummary5 * -1, "#,###.##") + ")";
                                                                                            } else if (coaSummary5 > 0) {
                                                                                                displayStr = JSPFormater.formatNumber(coaSummary5, "#,###.##");
                                                                                            } else if (coaSummary5 == 0) {
                                                                                                displayStr = "";
                                                                                            }
                
                                                                                            if (coaSummary5_lastYear < 0) {
                                                                                                displayStr_lastYear = "(" + JSPFormater.formatNumber(coaSummary5_lastYear * -1, "#,###.##") + ")";
                                                                                            } else if (coaSummary5_lastYear > 0) {
                                                                                                displayStr_lastYear = JSPFormater.formatNumber(coaSummary5_lastYear, "#,###.##");
                                                                                            } else if (coaSummary5_lastYear == 0) {
                                                                                                displayStr_lastYear = "";
                                                                                            }

                                                                                            sesReport = new SesReportBs();
                                                                                            sesReport.setType("Footer Group Level");
                                                                                            sesReport.setDescription(strTotal1 + "Sub Total " + I_Project.ACC_GROUP_LONG_TERM_LIABILITIES);
                                                                                            sesReport.setAmount(coaSummary5);
                                                                                            sesReport.setStrAmount("" + coaSummary5);
                                                                                            
                                                                                            sesReport.setAmountPrevYear(coaSummary5_lastYear);
                                                                                            sesReport.setStrAmountPrevYear("" + coaSummary5_lastYear);
                                                                                            sesReport.setFont(1);
                                                                                            listReport.add(sesReport);
                                                                                        %>
                                                                                        <tr> 
                                                                                            <td width="50%" class="tablecell2"><span class="level2"><b><font size="1"><%=strTotal + " Sub Total " + I_Project.ACC_GROUP_LONG_TERM_LIABILITIES%></font></b></span></td>
                                                                                            <td width="25%" class="tablecell2" align="right"> 
                                                                                                <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                                                                                    <tr> 
                                                                                                        <td width="5%"></td>
                                                                                                        <td width="90%" class="tablecell2"> 
                                                                                                            <div align="right"><font size="1"><b><%=displayStr%></b></font></div>
                                                                                                        </td>
                                                                                                        <td width="5%"></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                            <td width="25%" class="tablecell2" align="right"> 
                                                                                                <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                                                                                    <tr> 
                                                                                                        <td width="5%"></td>
                                                                                                        <td width="90%" class="tablecell2"> 
                                                                                                            <div align="right"><font size="1"><b><%=displayStr_lastYear%></b></font></div>
                                                                                                        </td>
                                                                                                        <td width="5%"></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <%
            }//end if null

            if (coaSummary4 + coaSummary5 < 0) {
                displayStr = "(" + JSPFormater.formatNumber((coaSummary4 + coaSummary5) * -1, "#,###.##") + ")";
            } else if (coaSummary4 + coaSummary5 > 0) {
                displayStr = JSPFormater.formatNumber(coaSummary4 + coaSummary5, "#,###.##");
            } else if (coaSummary4 + coaSummary5 == 0) {
                displayStr = "";
            }
            
            if (coaSummary4_lastYear + coaSummary5_lastYear < 0) {
                displayStr_lastYear = "(" + JSPFormater.formatNumber((coaSummary4_lastYear + coaSummary5_lastYear) * -1, "#,###.##") + ")";
            } else if (coaSummary4_lastYear + coaSummary5_lastYear > 0) {
                displayStr_lastYear = JSPFormater.formatNumber(coaSummary4_lastYear + coaSummary5_lastYear, "#,###.##");
            } else if (coaSummary4_lastYear + coaSummary5_lastYear == 0) {
                displayStr_lastYear = "";
            }

            //add footer level
            if ( ( coaSummary4 + coaSummary5 != 0 ) || ( coaSummary4_lastYear + coaSummary5_lastYear != 0 ) || valShowList != 1) {	//add Group Footer
                sesReport = new SesReportBs();
                sesReport.setType("Footer Top Level");
                sesReport.setDescription("Total Liabilities");
                
                sesReport.setAmount(coaSummary4 + coaSummary5);
                sesReport.setStrAmount("" + (coaSummary4 + coaSummary5));
                
                sesReport.setAmountPrevYear(coaSummary4_lastYear + coaSummary5_lastYear);
                sesReport.setStrAmountPrevYear("" + (coaSummary4_lastYear + coaSummary5_lastYear));
                
                sesReport.setFont(1);
                listReport.add(sesReport);
                                                                                        %>
                                                                                        <tr> 
                                                                                            <td width="50%" class="tablecell2"><span class="level2"><b><font size="1">Total 
                                                                                            Liabilities</font></b></span></td>
                                                                                            <td width="25%" class="tablecell2" align="right"> 
                                                                                                <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                                                                                    <tr> 
                                                                                                        <td width="5%"></td>
                                                                                                        <td width="90%" class="tablecell2"> 
                                                                                                            <div align="right"><font size="1"><b><%=displayStr%></b></font></div>
                                                                                                        </td>
                                                                                                        <td width="5%"></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                            <td width="25%" class="tablecell2" align="right"> 
                                                                                                <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                                                                                    <tr> 
                                                                                                        <td width="5%"></td>
                                                                                                        <td width="90%" class="tablecell2"> 
                                                                                                            <div align="right"><font size="1"><b><%=displayStr_lastYear%></b></font></div>
                                                                                                        </td>
                                                                                                        <td width="5%"></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <%	}%>
                                                                                        <!--level 3-->
                                                                                        <tr> 
                                                                                            <td width="50%" class="tablecell"><b><font size="1">Equity</font></b></td>
                                                                                            <td width="25%" class="tablecell"><font size="1"></font></td>
                                                                                            <td width="25%" class="tablecell"><font size="1"></font></td>
                                                                                        </tr>
                                                                                        <!--level equity-->
                                        <%	//add Top Header
            sesReport = new SesReportBs();
            sesReport.setType("Top Level");
            sesReport.setDescription("Equity");
            sesReport.setFont(1);
            listReport.add(sesReport);

            sesReport = new SesReportBs();
            sesReport.setType("Group Level");
            sesReport.setDescription(strTotal1 + I_Project.ACC_GROUP_EQUITY);
            sesReport.setFont(1);
            listReport.add(sesReport);
                                                                                 %>
                                                                                        <tr> 
                                                                                            <td width="50%" class="tablecell"><b><font size="1"><%=strTotal + I_Project.ACC_GROUP_EQUITY%></font></b></td>
                                                                                            <td width="25%" class="tablecell"><font size="1"></font></td>
                                                                                            <td width="25%" class="tablecell"><font size="1"></font></td>
                                                                                        </tr>
                                                                                        <%

            listCoa = DbCoa.list(0, 0, "account_group='Equity'", "code");

            if (listCoa != null && listCoa.size() > 0) {
                coaSummary6 = 0;
                String str = "";
                String str1 = "";
                for (int i = 0; i < listCoa.size(); i++) {
                    coa = (Coa) listCoa.get(i);
                    str = switchLevel(coa.getLevel());
                    str1 = switchLevel1(coa.getLevel());
                    
                    double amount = DbCoa.getCoaBalanceCD(coa.getOID());
                    double amountPerevious = DbCoa.getCoaBalanceCDLastYear(coa.getOID());

                    //Retained Earnings
                    if (coa.getCode().equals(DbSystemProperty.getValueByName("ID_RETAINED_EARNINGS")) || coa.getCode().equals(DbSystemProperty.getValueByName("ID_RETAINED_EARNINGS_1"))) {
                        
                        double totalIncome = 0;
                        double totalIncome_lastYear = 0;

                        Coa coax = new Coa();
                        int idAccClass = coa.getAccountClass();
                        String wherex = "account_group='Revenue' or account_group='Other Revenue' or account_group='Expense' or account_group='Other Expense' or account_group='Cost Of Sales'";
                        Vector temCoas = DbCoa.list(0, 0, wherex, "code");

                        for (int ix = 0; ix < temCoas.size(); ix++) {
                            
                            coax = (Coa) temCoas.get(ix);
                            
                            boolean ok = false;

                            if (idAccClass == DbCoa.ACCOUNT_CLASS_SP) {
                                if (coax.getAccountClass() == idAccClass) {
                                    ok = true;
                                }
                            } else {
                                if (coax.getAccountClass() != DbCoa.ACCOUNT_CLASS_SP) {
                                    ok = true;
                                }
                            }

                            if (ok) {
                                //if(coax.getAccountClass()==coa.getAccountClass()){

                                if (coax.getAccountGroup().equals(I_Project.ACC_GROUP_REVENUE)) {
                                    totalIncome = totalIncome + DbCoa.getCoaBalanceCD(coax.getOID());
                                    totalIncome_lastYear = totalIncome_lastYear + DbCoa.getCoaBalanceCDLastYear(coax.getOID());
                                    
                                } else if (coax.getAccountGroup().equals(I_Project.ACC_GROUP_COST_OF_SALES)) {
                                    totalIncome = totalIncome - DbCoa.getCoaBalance(coax.getOID());
                                    totalIncome_lastYear = totalIncome_lastYear - DbCoa.getCoaBalanceLastYear(coax.getOID());
                                    
                                } else if (coax.getAccountGroup().equals(I_Project.ACC_GROUP_EXPENSE)) {
                                    totalIncome = totalIncome - DbCoa.getCoaBalance(coax.getOID());
                                    totalIncome_lastYear = totalIncome_lastYear - DbCoa.getCoaBalanceLastYear(coax.getOID());
                                    
                                } else if (coax.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_REVENUE)) {
                                    totalIncome = totalIncome + DbCoa.getCoaBalanceCD(coax.getOID());
                                    totalIncome_lastYear = totalIncome_lastYear + DbCoa.getCoaBalanceCDLastYear(coax.getOID());
                                    
                                } else if (coax.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_EXPENSE)) {
                                    totalIncome = totalIncome - DbCoa.getCoaBalance(coax.getOID());
                                    totalIncome_lastYear = totalIncome_lastYear - DbCoa.getCoaBalanceLastYear(coax.getOID());
                                }
                            }
                        }
                        //amount = totalIncome;										
                        amount = totalIncome + DbCoaOpeningBalance.getOpeningBalance(periode, coa.getOID());
                        amountPerevious = totalIncome_lastYear + DbCoaOpeningBalance.getOpeningBalanceLastYear(periode, coa.getOID());
                    }
                    // Bagining Balance
                    //if(coa.getCode().equals(DbSystemProperty.getValueByName("ID_BEGINING_BALANCE")))
                    //{
                    //amount = DbCoa.getCoaBalanceCD(coa.getOID());
                    //	amount = DbCoa.getCoaBalance(coa.getOID());//getSumOpeningBalance();										
                    //}


                    coaSummary6 = coaSummary6 + amount;
                    coaSummary6_lastYear = coaSummary6_lastYear + amountPerevious;

                    //out.println("<br>coa : "+coa.getCode()+" - "+coa.getName());	
                    //out.println("<br>amount : "+JSPFormater.formatNumber(amount,"#,###.##"));
                    //out.println("--- coaSummary : "+JSPFormater.formatNumber(coaSummary6,"#,###.##"));

                    displayStr = strDisplay(amount, coa.getStatus());

                    sesReport = new SesReportBs();
                    sesReport.setType(coa.getStatus());
                    sesReport.setDescription(strTotal1 + strTotal1 + str1 + coa.getCode() + " - " + coa.getName());
                    
                    sesReport.setAmount(amount);
                    sesReport.setStrAmount("" + amount);
                    
                    sesReport.setAmountPrevYear(amountPerevious);
                    sesReport.setStrAmountPrevYear("" + amountPerevious);
                    
                    sesReport.setFont(coa.getStatus().equals("HEADER") ? 1 : 0);
                    listReport.add(sesReport);
                                                                                        %>
                                                                                        <tr> 
                                                                                            <td width="50%" class="<%=cssString%>" nowrap><font size="1"> 
                                                                                                    <%if (coa.getStatus().equals("HEADER")) {%>
                                                                                                    <b> 
                                                                                                        <%}%>
                                                                                                        <%=strTotal + strTotal + str + coa.getCode() + " - " + coa.getName()%> 
                                                                                                        <%if (coa.getStatus().equals("HEADER")) {%>
                                                                                                    </b> 
                                                                                                    <%}%>
                                                                                            </font></td>
                                                                                            <td width="25%" class="<%=cssString%>"> 
                                                                                                <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                                                                                    <tr> 
                                                                                                        <td width="5%"></td>
                                                                                                        <td width="90%" class="<%=cssString%>"> 
                                                                                                            <div align="right"><font size="1"><%=displayStr%></font></div>
                                                                                                        </td>
                                                                                                        <td width="5%"></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                            <td width="25%" class="<%=cssString%>"> 
                                                                                                <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                                                                                    <tr> 
                                                                                                        <td width="5%"></td>
                                                                                                        <td width="90%" class="<%=cssString%>"> 
                                                                                                            <div align="right"><font size="1"><%=displayStr_lastYear%></font></div>
                                                                                                        </td>
                                                                                                        <td width="5%"></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <%
                                                                                            }//end for

                                                                                            if (coaSummary6 < 0) {
                                                                                                displayStr = "(" + JSPFormater.formatNumber(coaSummary6 * -1, "#,###.##") + ")";
                                                                                            } else if (coaSummary6 > 0) {
                                                                                                displayStr = JSPFormater.formatNumber(coaSummary6, "#,###.##");
                                                                                            } else if (coaSummary6 == 0) {
                                                                                                displayStr = "";
                                                                                            }
                
                                                                                            
                                                                                            if (coaSummary6_lastYear < 0) {
                                                                                                displayStr_lastYear = "(" + JSPFormater.formatNumber(coaSummary6_lastYear * -1, "#,###.##") + ")";
                                                                                            } else if (coaSummary6_lastYear > 0) {
                                                                                                displayStr_lastYear = JSPFormater.formatNumber(coaSummary6_lastYear, "#,###.##");
                                                                                            } else if (coaSummary6 == 0) {
                                                                                                displayStr_lastYear = "";
                                                                                            }
                                                                                            //add footer level

                                                                                            sesReport = new SesReportBs();
                                                                                            sesReport.setType("Footer Group Level");
                                                                                            sesReport.setDescription(strTotal1 + "Sub Total " + I_Project.ACC_GROUP_EQUITY);
                                                                                            sesReport.setAmount(coaSummary6);
                                                                                            sesReport.setStrAmount("" + coaSummary6);
                                                                                            
                                                                                            sesReport.setAmountPrevYear(coaSummary6_lastYear);
                                                                                            sesReport.setStrAmountPrevYear("" + coaSummary6_lastYear);
                                                                                            sesReport.setFont(1);
                                                                                            listReport.add(sesReport);
                                                                                        %>
                                                                                        <tr> 
                                                                                            <td width="50%" class="tablecell2"><span class="level2"><b><font size="1"><%=strTotal + " Sub Total " + I_Project.ACC_GROUP_EQUITY%></font></b></span></td>
                                                                                            <td width="25%" class="tablecell2" align="right"> 
                                                                                                <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                                                                                    <tr> 
                                                                                                        <td width="5%"></td>
                                                                                                        <td width="90%" class="tablecell2"> 
                                                                                                            <div align="right"><font size="1"><b><%=displayStr%></b></font></div>
                                                                                                        </td>
                                                                                                        <td width="5%"></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                            <td width="25%" class="tablecell2" align="right"> 
                                                                                                <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                                                                                    <tr> 
                                                                                                        <td width="5%"></td>
                                                                                                        <td width="90%" class="tablecell2"> 
                                                                                                            <div align="right"><font size="1"><b><%=displayStr_lastYear%></b></font></div>
                                                                                                        </td>
                                                                                                        <td width="5%"></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <%

            }//end if not null

            if (coaSummary6 < 0) {
                displayStr = "(" + JSPFormater.formatNumber((coaSummary6) * -1, "#,###.##") + ")";
            } else if (coaSummary6 < 0) {
                displayStr = JSPFormater.formatNumber(coaSummary6, "#,###.##");
            } else if (coaSummary6 == 0) {
                displayStr = "";
            }
            
            if (coaSummary6_lastYear < 0) {
                displayStr_lastYear = "(" + JSPFormater.formatNumber((coaSummary6_lastYear) * -1, "#,###.##") + ")";
            } else if (coaSummary6_lastYear < 0) {
                displayStr_lastYear = JSPFormater.formatNumber(coaSummary6_lastYear, "#,###.##");
            } else if (coaSummary6 == 0) {
                displayStr_lastYear = "";
            }
            
            //add footer level

            if (coaSummary6 != 0 || coaSummary6_lastYear != 0 || valShowList != 1) {	//add Group Footer
                
                sesReport = new SesReportBs();
                sesReport.setType("Footer Top Level");
                sesReport.setDescription("Total Equity");
                sesReport.setAmount(coaSummary6);
                sesReport.setStrAmount("" + coaSummary6);
                
                sesReport.setAmountPrevYear(coaSummary6_lastYear);
                sesReport.setStrAmountPrevYear("" + coaSummary6_lastYear);
                sesReport.setFont(1);
                listReport.add(sesReport);

                                                                                        %>
                                                                                        <tr> 
                                                                                            <td width="50%" class="tablecell2"><span class="level2"><b><font size="1">Total 
                                                                                            Equity</font></b></span></td>
                                                                                            <td width="25%" class="tablecell2" align="right"> 
                                                                                                <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                                                                                    <tr> 
                                                                                                        <td width="5%"></td>
                                                                                                        <td width="90%" class="tablecell2"> 
                                                                                                            <div align="right"><font size="1"><b><%=displayStr%></b></font></div>
                                                                                                        </td>
                                                                                                        <td width="5%"></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                            <td width="25%" class="tablecell2" align="right"> 
                                                                                                <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                                                                                    <tr> 
                                                                                                        <td width="5%"></td>
                                                                                                        <td width="90%" class="tablecell2"> 
                                                                                                            <div align="right"><font size="1"><b><%=displayStr_lastYear%></b></font></div>
                                                                                                        </td>
                                                                                                        <td width="5%"></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <%	}

            totalPasiva = coaSummary4 + coaSummary5 + coaSummary6;
            totalPasiva_lastYear = coaSummary4_lastYear + coaSummary5_lastYear + coaSummary6_lastYear;

            //out.println("coaSummary4 : "+coaSummary4 +" , coaSummary5 : "+coaSummary5+", coaSummary6 : "+coaSummary6 );

            if (coaSummary4 + coaSummary5 + coaSummary6 < 0) {
                displayStr = "(" + JSPFormater.formatNumber((coaSummary4 + coaSummary5 + coaSummary6) * -1, "#,###.##") + ")";
            } else if (coaSummary4 + coaSummary5 + coaSummary6 > 0) {
                displayStr = JSPFormater.formatNumber((coaSummary4 + coaSummary5 + coaSummary6), "#,###.##");
            } else if (coaSummary4 + coaSummary5 + coaSummary6 == 0) {
                displayStr = "";
            }
            
            if (coaSummary4_lastYear + coaSummary5_lastYear + coaSummary6_lastYear < 0) {
                displayStr_lastYear = "(" + JSPFormater.formatNumber((coaSummary4_lastYear + coaSummary5_lastYear + coaSummary6_lastYear) * -1, "#,###.##") + ")";
            } else if (coaSummary4_lastYear + coaSummary5_lastYear + coaSummary6_lastYear > 0) {
                displayStr_lastYear = JSPFormater.formatNumber((coaSummary4_lastYear + coaSummary5_lastYear + coaSummary6_lastYear), "#,###.##");
            } else if (coaSummary4_lastYear + coaSummary5_lastYear + coaSummary6_lastYear == 0) {
                displayStr_lastYear = "";
            }
            
            //add footer level
            if (coaSummary6 != 0 || valShowList != 1) {	//add Group Footer
                sesReport = new SesReportBs();
                sesReport.setType("Footer Top Level");
                sesReport.setDescription("TOTAL PASIVA");
                sesReport.setAmount(coaSummary4 + coaSummary5 + coaSummary6);
                sesReport.setStrAmount("" + (coaSummary4 + coaSummary5 + coaSummary6));
                
                sesReport.setAmountPrevYear(coaSummary4_lastYear + coaSummary5_lastYear + coaSummary6_lastYear);
                sesReport.setStrAmountPrevYear("" + (coaSummary4_lastYear + coaSummary5_lastYear + coaSummary6_lastYear));
                sesReport.setFont(1);
                listReport.add(sesReport);
                                                                                        %>
                                                                                        <tr> 
                                                                                            <td width="50%" class="tablecell2"><span class="level2"><b>TOTAL 
                                                                                            PASIVA<font size="1"> </font></b></span></td>
                                                                                            <td width="25%" class="tablecell2" align="right"> 
                                                                                                <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                                                                                    <tr> 
                                                                                                        <td width="5%"></td>
                                                                                                        <td width="90%" class="tablecell2">
                                                                                                            <div align="right"><span class="level2"><b><%=displayStr%></b></span></div>
                                                                                                        </td>
                                                                                                        <td width="5%"></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                            <td width="25%" class="tablecell2" align="right"> 
                                                                                                <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                                                                                    <tr> 
                                                                                                        <td width="5%"></td>
                                                                                                        <td width="90%" class="tablecell2">
                                                                                                            <div align="right"><span class="level2"><b><%=displayStr_lastYear%></b></span></div>
                                                                                                        </td>
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
                                                                                            <td width="50%" class="tablecell1" height="15"><font size="1"></font></td>
                                                                                            <td width="25%" class="tablecell1"><font size="1"></font></td>
                                                                                            <td width="25%" class="tablecell1"><font size="1"></font></td>
                                                                                        </tr>
                                                                                        <%
            totalAktiva = Double.parseDouble(JSPFormater.formatNumber(totalAktiva, "###.##"));
            totalPasiva = Double.parseDouble(JSPFormater.formatNumber(totalPasiva, "###.##"));
            
            totalAktiva_lastYear = Double.parseDouble(JSPFormater.formatNumber(totalAktiva_lastYear, "###.##"));
            totalPasiva_lastYear = Double.parseDouble(JSPFormater.formatNumber(totalPasiva_lastYear, "###.##"));

            if (totalAktiva - totalPasiva < 0) {
                displayStr = "(" + JSPFormater.formatNumber((totalAktiva - totalPasiva) * -1, "#,###.##") + ")";
            } else if (totalAktiva - totalPasiva > 0) {
                displayStr = JSPFormater.formatNumber(totalAktiva - totalPasiva, "#,###.##");
            } else if ((totalAktiva - totalPasiva) == 0) {
                displayStr = "-";
            }
            
            if (totalAktiva_lastYear - totalPasiva_lastYear < 0) {
                displayStr_lastYear = "(" + JSPFormater.formatNumber((totalAktiva_lastYear - totalPasiva_lastYear) * -1, "#,###.##") + ")";
            } else if (totalAktiva_lastYear - totalPasiva_lastYear > 0) {
                displayStr_lastYear = JSPFormater.formatNumber(totalAktiva_lastYear - totalPasiva_lastYear, "#,###.##");
            } else if ((totalAktiva_lastYear - totalPasiva_lastYear) == 0) {
                displayStr_lastYear = "-";
            }

            //add footer level
            if (coaSummary4 + coaSummary5 != 0 || coaSummary4_lastYear + coaSummary5_lastYear != 0 || valShowList != 1) {	//add Group Footer
                
                sesReport = new SesReportBs();
                sesReport.setType("Footer Top Level");
                sesReport.setDescription(strTotal1 + "");
                sesReport.setAmount((coaSummary1 + coaSummary2 + coaSummary3) - (coaSummary4 + coaSummary5 + coaSummary6));
                sesReport.setStrAmount("" + ((coaSummary1 + coaSummary2 + coaSummary3) - (coaSummary4 + coaSummary5 + coaSummary6)));
                
                sesReport.setAmountPrevYear((coaSummary1_lastYear + coaSummary2_lastYear + coaSummary3_lastYear) - (coaSummary4_lastYear + coaSummary5_lastYear + coaSummary6_lastYear));
                sesReport.setStrAmountPrevYear("" + ((coaSummary1_lastYear + coaSummary2_lastYear + coaSummary3_lastYear) - (coaSummary4 + coaSummary5_lastYear + coaSummary6_lastYear)));
                sesReport.setFont(1);
                listReport.add(sesReport);
                                                                                        %>
                                                                                        <tr> 
                                                                                            <td width="50%" class="tablecell2">&nbsp;</td>
                                                                                            <td width="25%" class="tablecell2" align="right"> 
                                                                                                <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                                                                                    <tr> 
                                                                                                        <td width="5%"></td>
                                                                                                        <td width="90%" class="tablecell2"> 
                                                                                                            <div align="right"><font size="1"><b><font color="#FF0000"><%=displayStr%></font></b></font></div>
                                                                                                        </td>
                                                                                                        <td width="5%"></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                            <td width="25%" class="tablecell2" align="right"> 
                                                                                                <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                                                                                    <tr> 
                                                                                                        <td width="5%"></td>
                                                                                                        <td width="90%" class="tablecell2"> 
                                                                                                            <div align="right"><font size="1"><b><font color="#FF0000"><%=displayStr_lastYear%></font></b></font></div>
                                                                                                        </td>
                                                                                                        <td width="5%"></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <%		}%>
                                                                                        <tr> 
                                                                                            <td width="50%" class="tablecell1" height="15"><font size="1"></font></td>
                                                                                            <td width="25%" class="tablecell1"><font size="1"></font></td>
                                                                                            <td width="25%" class="tablecell1"><font size="1"></font></td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </td>
                                                                            </tr>												  			  
                                                                        </table>
                                                                    </td>
                                                                </tr>
                                                                
                                                                <%
            session.putValue("BS_STANDARD", listReport);

                                                                %>
                                                                
                                                                
                                                                <tr align="left" valign="top"> 
                                                                    <td height="8" valign="middle" colspan="3">&nbsp; </td>
                                                                </tr>
                                                                <tr align="left" valign="top"> 
                                                                    <td height="8" valign="middle" colspan="3" class="container"> 
                                                                        <%if (listCoa != null && listCoa.size() > 0) {%>
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
