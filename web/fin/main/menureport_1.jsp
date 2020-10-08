
<%-- 
    Document   : menureport
    Created on : Mar 14, 2012, 11:57:33 AM
    Author     : Roy Andika
--%>

<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.main.db.*" %>
<%@ page import = "com.project.main.entity.*" %>
<%@ page import = "com.project.general.*" %>
<%@ page import = "com.project.admin.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ include file = "../main/javainit.jsp" %>
<% int appObjCode = 1;%>
<%@ include file = "../main/check.jsp" %>
<%
            int iJSPCommand = JSPRequestValue.requestCommand(request);
            int start = JSPRequestValue.requestInt(request, "start");
            int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");

            boolean isGerejaxxxxx = DbSystemProperty.getModSysPropGereja();
            Vector vSeg = DbSegment.list(0, 0, "", DbSegment.colNames[DbSegment.COL_COUNT]);

            String[] langNav = {"Finance Report"};
            String strMDStupLaporan = "Report Setup";
            String strFRJournalDetail = "Journal Detail";
            String strFRGeneralLedger = "General Ledger";
            String strMDDetail = "Report Detail";
            String strBSDetail = "Balance Sheet Detail";
            String strPLDetail = "Profit & Loss Detail";
            String strFRBalanceSheet = "Balance Sheet";
            String strFRProfitLoss = "Profit & Loss";

            String strFRBudgetSulier = "Budget Suplier";

            if (lang == LANG_ID) {
                String[] navID = {"Laporan Keuangan"};
                langNav = navID;

                strMDStupLaporan = "Setup Laporan";
                strFRJournalDetail = "Jurnal Detail";
                strFRGeneralLedger = "Buku Besar";
                strFRBalanceSheet = "Neraca";
                strMDDetail = "Penjelasan";
                strBSDetail = "Neraca";
                strPLDetail = "Laba Rugi";
                strFRProfitLoss = "Laba Rugi";
                strFRBudgetSulier = "Budget Suplier";
            }
%>
<html >
    <!-- #BeginTemplate "/Templates/index.dwt" --> 
    <head>
        <!-- #BeginEditable "javascript" --> 
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
        <link href="../css/css.css" rel="stylesheet" type="text/css" />
        <title><%=systemTitle%></title>
        <script language="JavaScript">            
            
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
    <body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','<%=approot%>/images/BtnNewOn.jpg')">
        <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
            <tr> 
                <td valign="top"> 
                    <table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
                        <tr> 
                            <td height="96"> <!-- #BeginEditable "header" --> 
            <%@ include file = "../main/hmenu.jsp" %>
                            <!-- #EndEditable --> </td>
                        </tr>
                        <tr> 
                            <td valign="top"> 
                                <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
                                    <!--DWLayoutTable-->
                                    <tr> 
                                        <td width="165" height="100%" valign="top" style="background:url(<%=approot%>/images/leftmenu-bg.gif) repeat-y"> 
                                            <!-- #BeginEditable "menu" --> 
                  <%@ include file="../main/menu.jsp" %>
                                        <!-- #EndEditable --> </td>
                                        <td width="100%" valign="top"> 
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                <tr> 
                                                    <td class="title"><!-- #BeginEditable "title" -->
                                           <%
            String navigator = "&nbsp;<font class=\"lvl1\">" + langNav[0] + "</font>";
                                           %>
                                           <%@ include file="../main/navigator.jsp"%>
                                                    <!-- #EndEditable --></td>
                                                </tr>                                                
                                                <tr> 
                                                    <td><!-- #BeginEditable "content" --> 
                                                        <form name="jspkecamatan" method ="post" action="">
                                                            <input type="hidden" name="command" value="<%=iJSPCommand%>">                                                            
                                                            <input type="hidden" name="start" value="<%=start%>">
                                                            <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                                                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr align="left" valign="top"> 
                                                                    <td height="8"  colspan="3" class="container"> 
                                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">                                                                            
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="22" valign="middle" colspan="3"> 
                                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                        <tr> 
                                                                                            <td>&nbsp;</td>
                                                                                        </tr>
                                                                                        <tr> 
                                                                                            <td> 
                                                                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                                    <tr> 
                                                                                                        <td width="100%"> 
                                                                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                                                <tr> 
                                                                                                                    <td> 
                                                                                                                        <table cellpadding="0" cellspacing="0" border="0">
                                                                                                                            <tr align="left" valign="top" height="35"> 
                                                                                                                                <%if (isGerejaxxxxx == false && vSeg.size() <= 0) {%>
                                                                                                                                <%if (fnSTR) {%>
                                                                                                                                <td width="120" align="center" valign="middle" class="menu-idx">
                                                                                                                                <a href="<%=approot%>/report/rptformat.jsp?valxx=11"><%=strMDStupLaporan%></a></td>
                                                                                                                                <td width="1">&nbsp; </td>
                                                                                                                                <%}%>
                                                                                                                                <%}%>
                                                                                                                                <td width="10" align="center" valign="middle"></td>
                                                                                                                                <td width="90" align="center" valign="middle">
                                                                                                                                    <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                                        <tr>
                                                                                                                                            <td align="center">
                                                                                                                                                <%if (fnGlDet) {%>
                                                                                                                                                <a href="<%=approot%>/freport/worksheet.jsp?valxx=11"><img src="<%=approot%>/images/mn16.jpg" border="0"></a>
                                                                                                                                                <%} else {%>
                                                                                                                                                <img src="<%=approot%>/images/mn16 disable.jpg" border="0">
                                                                                                                                                <%}%>
                                                                                                                                            </td>
                                                                                                                                        </tr>                                                                                                            
                                                                                                                                        <tr>
                                                                                                                                            <td align="center">
                                                                                                                                                <%if (fnGlDet) {%>
                                                                                                                                                <a href="<%=approot%>/freport/worksheet.jsp?valxx=11" style="text-decoration: none"><font face="arial" color="#07770A"><%=strFRJournalDetail%></font></a>
                                                                                                                                                <%} else {%>
                                                                                                                                                <font face="arial" color="#92999E"><%=strFRJournalDetail%></font>
                                                                                                                                                <%}%>
                                                                                                                                            </td>
                                                                                                                                        </tr>
                                                                                                                                    </table>
                                                                                                                                </td>
                                                                                                                                <td width="90" align="center" valign="middle">
                                                                                                                                    <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                                        <tr>
                                                                                                                                            <td align="center">
                                                                                                                                                <%if (fnGl) {%>
                                                                                                                                                <a href="<%=approot%>/freport/glreport.jsp?valxx=11"><img src="<%=approot%>/images/mn16.jpg" border="0"></a>
                                                                                                                                                <%} else {%>
                                                                                                                                                <img src="<%=approot%>/images/mn16 disable.jpg" border="0">
                                                                                                                                                <%}%>
                                                                                                                                            </td>
                                                                                                                                        </tr>                                                                                                            
                                                                                                                                        <tr>
                                                                                                                                            <td align="center">
                                                                                                                                                <%if (fnGl) {%>
                                                                                                                                                <a href="<%=approot%>/freport/glreport.jsp?valxx=11" style="text-decoration: none"><font face="arial" color="#07770A"><%=strFRGeneralLedger%></font></a>
                                                                                                                                                <%} else {%>
                                                                                                                                                <font face="arial" color="#92999E"><%=strFRGeneralLedger%></font>
                                                                                                                                                <%}%>
                                                                                                                                            </td>
                                                                                                                                        </tr>
                                                                                                                                    </table>
                                                                                                                                </td>
                                                                                                                                <td width="1">&nbsp; </td>
                                                                                                                                <td width="90" align="center" valign="middle">
                                                                                                                                     <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                                        <tr>
                                                                                                                                            <td align="center">
                                                                                                                                                <%if (fnGl) {%>
                                                                                                                                                <a href="<%=approot%>/freport/reportbudgetsuplier.jsp?valxx=11"><img src="<%=approot%>/images/mn16.jpg" border="0"></a>
                                                                                                                                                <%} else {%>
                                                                                                                                                <img src="<%=approot%>/images/mn16 disable.jpg" border="0">
                                                                                                                                                <%}%>
                                                                                                                                            </td>
                                                                                                                                        </tr>                                                                                                            
                                                                                                                                        <tr>
                                                                                                                                            <td align="center">
                                                                                                                                                <%if (fnGl) {%>
                                                                                                                                                <a href="<%=approot%>/freport/reportbudgetsuplier.jsp?valxx=11" style="text-decoration: none"><font face="arial" color="#07770A"><%=strFRBudgetSulier%></font></a>
                                                                                                                                                <%} else {%>
                                                                                                                                                <font face="arial" color="#92999E"><%=strFRBudgetSulier%></font>
                                                                                                                                                <%}%>
                                                                                                                                            </td>
                                                                                                                                        </tr>
                                                                                                                                    </table>
                                                                                                                                </td>
                                                                                                                                <%if (isGerejaxxxxx == false && vSeg.size() <= 0) {%>
                                                                                                                                <%if (fnNeraca) {%>
                                                                                                                                <td width="120" align="center" valign="middle" class="menu-idx"><a href="<%=approot%>/freport/neraca.jsp?valxx=11"><%=strFRBalanceSheet%></a></td>
                                                                                                                                <td width="1">&nbsp; </td>
                                                                                                                                <%}%>
                                                                                                                                <%if (fn) {%>
                                                                                                                                <td width="120" align="center" valign="middle" class="menu-idx"><a href="<%=approot%>/freport/profitloss_rpt.jsp?valxx=11"><%=strFRProfitLoss%></a></td>
                                                                                                                                <td width="1">&nbsp; </td>
                                                                                                                                <%}%>
                                                                                                                                <%}%>
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
                                                                                </td>
                                                                            </tr>        
                                                                            <%if (isGerejaxxxxx == true || (vSeg != null && vSeg.size() > 0)) {%>                                                                            
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="26" valign="middle" colspan="3">&nbsp;</td>
                                                                            </tr>
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="22" valign="middle" colspan="3"> 
                                                                                    <table cellpadding="0" cellspacing="0" border="0">
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td colspan="8" align="center"><font face="arial" color="#92999E"><%=strMDDetail%></font></td>
                                                                                        </tr>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td colspan="8" align="center" height="3"></td>
                                                                                        </tr>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td colspan="8" align="left" >
                                                                                                <table cellpadding="0" cellspacing="0" border="0">
                                                                                                    <tr>
                                                                                                        <TD>
                                                                                                        <IMG SRC="<%=approot%>/images/rpt-1.gif" WIDTH=112 HEIGHT=33 ALT=""></TD>
                                                                                                        <TD>
                                                                                                        <IMG SRC="<%=approot%>/images/rpt-2.gif" WIDTH=142 HEIGHT=33 ALT=""></TD>
                                                                                                        <TD>
                                                                                                        <IMG SRC="<%=approot%>/images/rpt-3.gif" WIDTH=110 HEIGHT=33 ALT=""></TD>
                                                                                                    </tr>
                                                                                                    <tr>
                                                                                                        <TD ALIGN="center" VALIGN="top">
                                                                                                            <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                <tr>
                                                                                                                    <td align="center">
                                                                                                                        <%if (fnNeraca) {%>
                                                                                                                        <a href="<%=approot%>/freport/neracabysegment.jsp?valxx=11"><img src="<%=approot%>/images/mn16.jpg" border="0"></a>
                                                                                                                        <%} else {%>
                                                                                                                        <img src="<%=approot%>/images/mn16 disable.jpg" border="0">
                                                                                                                        <%}%>
                                                                                                                    </td>
                                                                                                                </tr>                                                                                                            
                                                                                                                <tr>
                                                                                                                    <td align="center">
                                                                                                                        <%if (fnNeraca) {%>
                                                                                                                        <a href="<%=approot%>/freport/neracabysegment.jsp?valxx=11" style="text-decoration: none"><font face="arial" color="#07770A"><%=strBSDetail%></font></a>
                                                                                                                        <%} else {%>
                                                                                                                        <font face="arial" color="#92999E"><%=strBSDetail%></font>
                                                                                                                        <%}%>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                            </table>
                                                                                                        </TD>
                                                                                                        <TD align="center" VALIGN="top">
                                                                                                            <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                <tr>
                                                                                                                    <td align="center">
                                                                                                                        <%if (fnProfit) {%>
                                                                                                                        <a href="<%=approot%>/freport/profitloss0_v02.jsp?valxx=11"><img src="<%=approot%>/images/mn16.jpg" border="0"></a>
                                                                                                                        <%} else {%>
                                                                                                                        <img src="<%=approot%>/images/mn16 disable.jpg" border="0">
                                                                                                                        <%}%>
                                                                                                                    </td>
                                                                                                                </tr>                                                                                                            
                                                                                                                <tr>
                                                                                                                    <td align="center">
                                                                                                                        <%if (fnProfit) {%>
                                                                                                                        <a href="<%=approot%>/freport/profitloss0_v02.jsp?valxx=11" style="text-decoration: none"><font face="arial" color="#07770A"><%=strPLDetail%> <BR>(By Location)</font></a>
                                                                                                                        <%} else {%>
                                                                                                                        <font face="arial" color="#92999E"><%=strPLDetail%> <BR>(By Location)</font>
                                                                                                                        <%}%>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                            </table>
                                                                                                        </TD>
                                                                                                        <TD align="center" VALIGN="top">
                                                                                                            <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                <tr>
                                                                                                                    <td align="center">
                                                                                                                        <%if (fnProfit) {%>
                                                                                                                        <a href="<%=approot%>/freport/profitlossmultiple.jsp?valxx=11"><img src="<%=approot%>/images/mn16.jpg" border="0"></a>
                                                                                                                        <%} else {%>
                                                                                                                        <img src="<%=approot%>/images/mn16 disable.jpg" border="0">
                                                                                                                        <%}%>
                                                                                                                    </td>
                                                                                                                </tr>                                                                                                            
                                                                                                                <tr>
                                                                                                                    <td align="center">            
                                                                                                                        <%if (fnProfit) {%>
                                                                                                                        <a href="<%=approot%>/freport/profitlossmultiple.jsp?valxx=11" style="text-decoration: none"><font face="arial" color="#07770A"><%=strPLDetail%> <BR>(Summary per period)</font></a>                                                                                                                        
                                                                                                                        <%} else {%>
                                                                                                                        <font face="arial" color="#92999E"><%=strPLDetail%> <BR>(Summary per period)</font>
                                                                                                                        <%}%>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                            </table>
                                                                                                        </TD>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr align="left" valign="top" height="35">  
                                                                                            <%if (false) {%>
                                                                                            <td width="120" align="center" valign="middle" class="menu-idx"><a href="<%=approot%>/freport/profitloss0_v01.jsp?valxx=11"><%=strPLDetail%></a><br>
                                                                                            <font size="1"><b><i>by department</i></b></font></td>                                                                                            
                                                                                            <td width="1">&nbsp; </td>                                                                                            
                                                                                            <td width="120" align="center" valign="middle" class="menu-idx"><a href="<%=approot%>/freport/profitlossmultipledep.jsp?valxx=11"><%=strPLDetail%></a><br>
                                                                                            <font size="1"><i>by dep. per period</i></font></td>
                                                                                            <td width="1">&nbsp; </td>
                                                                                            <%}%>
                                                                                        </tr>
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                            <%}%>
                                                                        </table>
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
            <%@ include file = "../main/footer.jsp" %>
                            <!-- #EndEditable --> </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </body>
    <!-- #EndTemplate --> 
</html>