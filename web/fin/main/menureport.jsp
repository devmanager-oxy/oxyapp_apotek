
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
            String strGenPLDetail = "Generate Profit & Loss";
            String strAnggaran = "Budget";

            if (lang == LANG_ID) {
                String[] navID = {"Laporan Keuangan"};
                langNav = navID;

                strMDStupLaporan = "Setup Laporan";
                strFRJournalDetail = "Jurnal Detail";
                strFRGeneralLedger = "Buku Besar";
                strMDDetail = "Penjelasan";
                strBSDetail = "Neraca";
                strPLDetail = "Laba Rugi";
                strAnggaran = "Anggaran";
                strGenPLDetail = "Generate Laba Rugi";
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
                                        <td width="165" height="100%" valign="top" bgcolor="#E0FCC2" > 
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
                                                        <form name="jspmenureport" method ="post" action="">
                                                            <input type="hidden" name="command" value="<%=iJSPCommand%>">                                                            
                                                            <input type="hidden" name="start" value="<%=start%>">
                                                            <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                                                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <%if (fnGlDet || fnGl || fnNeraca || sysCompany.getBusinessType() == com.project.I_Project.BUSINESS_TYPE_NGO) {%>
                                                                <tr align="left" valign="top"> 
                                                                    <td height="8"  colspan="3" class="container">                                                                         
                                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                            <tr> 
                                                                                <td>&nbsp;</td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td> 
                                                                                    <table border="0" cellspacing="0" cellpadding="0">                                                                                                                
                                                                                        <tr align="left" valign="top" height="35">                                                                                                                                
                                                                                            <td width="10" align="center" valign="middle"></td>
                                                                                            <%if (fnGlDet) {%>
                                                                                            <td width="90" align="center" valign="middle">
                                                                                                <table border="0" cellpadding="0" cellspacing="0">
                                                                                                    <tr>
                                                                                                        <td align="center">                                                                                                                                    
                                                                                                            <a href="<%=approot%>/freport/worksheet.jsp?menu_idx=11"><img src="<%=approot%>/images/mn01.jpg" border="0"></a>                                                                                                                                    
                                                                                                        </td>
                                                                                                    </tr>                                                                                                            
                                                                                                    <tr>
                                                                                                        <td align="center">                                                                                                                                    
                                                                                                            <a href="<%=approot%>/freport/worksheet.jsp?menu_idx=11" style="text-decoration: none"><font face="arial" color="#07770A"><%=strFRJournalDetail%></font></a>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                            <%}%>
                                                                                            <%if (fnGl) {%>                                                                                            
                                                                                            <td width="20">&nbsp; </td>
                                                                                            <td width="90" align="center" valign="middle">
                                                                                                <table border="0" cellpadding="0" cellspacing="0">
                                                                                                    <tr>
                                                                                                        <td align="center">                                                                                                                                    
                                                                                                            <a href="<%=approot%>/freport/glreport.jsp?menu_idx=11"><img src="<%=approot%>/images/mn02.jpg" border="0"></a>                                                                                                                                    
                                                                                                        </td>
                                                                                                    </tr>                                                                                                            
                                                                                                    <tr>
                                                                                                        <td align="center">                                                                                                                                    
                                                                                                            <a href="<%=approot%>/freport/glreport.jsp?menu_idx=11" style="text-decoration: none"><font face="arial" color="#07770A"><%=strFRGeneralLedger%></font></a>                                                                                                                                    
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                            <%}%>
                                                                                            <%if (sysCompany.getBusinessType() == com.project.I_Project.BUSINESS_TYPE_NGO) {%>
                                                                                            <td width="20">&nbsp; </td>
                                                                                            <TD width="90" align="center" VALIGN="top">
                                                                                                <table border="0" cellpadding="0" cellspacing="0">
                                                                                                    <tr height="55">
                                                                                                        <td align="center">
                                                                                                            <a href="<%=approot%>/freport/report_anggaran.jsp?menu_idx=11"><img src="<%=approot%>/images/mn22.jpg" border="0"></a>
                                                                                                        </td>
                                                                                                    </tr>                                                                                                            
                                                                                                    <tr>
                                                                                                        <td align="center">                                                                                                                                    
                                                                                                            <a href="<%=approot%>/freport/report_anggaran.jsp?menu_idx=11" style="text-decoration: none"><font face="arial" color="#07770A"><%=strAnggaran%></font></a>                                                                                                                        
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </TD>
                                                                                            <%}%>
                                                                                            <%if (fnNeraca) {%>
                                                                                            <td width="20">&nbsp; </td>
                                                                                            <TD width="90" align="center" VALIGN="top">
                                                                                                <table border="0" cellpadding="0" cellspacing="0">
                                                                                                    <tr height="55">
                                                                                                        <td align="center">
                                                                                                            <a href="<%=approot%>/freport/neracabysegment.jsp?menu_idx=11"><img src="<%=approot%>/images/mn21.jpg" border="0"></a>
                                                                                                        </td>
                                                                                                    </tr>                                                                                                            
                                                                                                    <tr>
                                                                                                        <td align="center">                                                                                                                                    
                                                                                                            <a href="<%=approot%>/freport/neracabysegment.jsp?menu_idx=11" style="text-decoration: none"><font face="arial" color="#07770A"><%=strBSDetail%></font></a>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </TD>
                                                                                            <%}%>
                                                                                            <%if (fnReportBudget) {%>
                                                                                            <td width="20">&nbsp; </td>
                                                                                            <TD width="90" align="center" VALIGN="top">
                                                                                                <table border="0" cellpadding="0" cellspacing="0">
                                                                                                    <tr height="55">
                                                                                                        <td align="center">
                                                                                                            <a href="<%=approot%>/freport/budgetreport_month.jsp?menu_idx=11"><img src="<%=approot%>/images/mn09.jpg" border="0"></a>
                                                                                                        </td>
                                                                                                    </tr>                                                                                                            
                                                                                                    <tr>
                                                                                                        <td align="center">                                                                                                                                    
                                                                                                            <a href="<%=approot%>/freport/budgetreport_month.jsp?menu_idx=11" style="text-decoration: none"><font face="arial" color="#07770A"><%=strAnggaran%></font></a>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </TD>
                                                                                            <%}%>


                                                                                        </tr>     
                                                                                    </table>                                                                                    
                                                                                </td>
                                                                            </tr>        
                                                                            <%}%>
                                                                            <%if (fnProfit && sysCompany.getBusinessType() == com.project.I_Project.BUSINESS_TYPE_RETAIL) {%>
                                                                            <tr>
                                                                                <td colspan="3" height="30">&nbsp;</td>
                                                                            </tr>    
                                                                            <tr>
                                                                                <td colspan="3">
                                                                                    <table cellpadding="0" cellspacing="0" border="0">
                                                                                        <tr height="15">                                                                                            
                                                                                            <td width="20">&nbsp;</td>
                                                                                            <td valign="top">
                                                                                                <table cellpadding="0" cellspacing="0" border="0">
                                                                                                    <tr height="15">
                                                                                                        <td colspan="1" ></td>
                                                                                                        <td width="80" align="center" rowspan="2" valign="middle" nowrap >&nbsp;<font face="arial" color="#888282"><%=strPLDetail%></font>&nbsp;</td>                                                                                
                                                                                                        <td colspan="1" ></td>
                                                                                                    </tr>
                                                                                                    <tr>
                                                                                                        <td width="5" style="border-left: 1px solid #CCCCCC;border-top: 1px solid #CCCCCC;">&nbsp;</td>
                                                                                                        <td style="border-top: 1px solid #CCCCCC;border-right: 1px solid #CCCCCC;">&nbsp;</td>
                                                                                                    </tr>  
                                                                                                    <tr>                                                                                
                                                                                                        <td colspan="3" style="border-bottom: 1px solid #CCCCCC;border-left: 1px solid #CCCCCC;border-right: 1px solid #CCCCCC;">
                                                                                                            <table cellpadding="1" cellspacing="0" border="0">                                                                                                                
                                                                                                                <%if (sysCompany.getBusinessType() == com.project.I_Project.BUSINESS_TYPE_RETAIL) {%>
                                                                                                                <tr>
                                                                                                                    <td>&nbsp;</td>
                                                                                                                </tr>    
                                                                                                                <tr>
                                                                                                                    <td align="left">
                                                                                                                        <table cellpadding="1" cellspacing="0" border="0">
                                                                                                                            <tr>
                                                                                                                                <%if(false){%>
                                                                                                                                <td valign="top">
                                                                                                                                    <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                                        <tr>
                                                                                                                                            <td align="center" width="110">                                                                                                                        
                                                                                                                                                <a href="<%=approot%>/freport/profitlosssegmentmtd_v01.jsp?menu_idx=11"><img src="<%=approot%>/images/mn07.jpg" border="0"></a>
                                                                                                                                            </td>
                                                                                                                                        </tr>                                                                                                            
                                                                                                                                        <tr>
                                                                                                                                            <td align="center" width="110">                                                                                                                        
                                                                                                                                                <a href="<%=approot%>/freport/profitlosssegmentmtd_v01.jsp?menu_idx=11" style="text-decoration: none"><font face="arial" color="#07770A"><%=strPLDetail%> MTD <BR>(By Location)</font></a>                                                                                                                        
                                                                                                                                            </td>
                                                                                                                                        </tr>
                                                                                                                                    </table>
                                                                                                                                </td>  
                                                                                                                                <td width="20" align="center" valign="middle"></td>
                                                                                                                                <td valign="top">
                                                                                                                                    <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                                        <tr>
                                                                                                                                            <td align="center" width="110">                                                                                                                        
                                                                                                                                                <a href="<%=approot%>/freport/profitlosssegmentmtd_v02.jsp?menu_idx=11"><img src="<%=approot%>/images/mn07.jpg" border="0"></a>
                                                                                                                                            </td>
                                                                                                                                        </tr>                                                                                                            
                                                                                                                                        <tr>
                                                                                                                                            <td align="center" width="110">                                                                                                                        
                                                                                                                                                <a href="<%=approot%>/freport/profitlosssegment_v02.jsp?menu_idx=11" style="text-decoration: none"><font face="arial" color="#07770A"><%=strPLDetail%> MTD <BR> (Summary per period)</font></a>                                                                                                                                                                                                                                                
                                                                                                                                            </td>
                                                                                                                                        </tr>
                                                                                                                                    </table>
                                                                                                                                </td>  
                                                                                                                                <td width="20" align="center" valign="middle"></td>                                                                                                                                
                                                                                                                                <td valign="top">
                                                                                                                                    <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                                        <tr>
                                                                                                                                            <td align="center" width="110">                                                                                                                        
                                                                                                                                                <a href="<%=approot%>/freport/profitloss_segment.jsp?menu_idx=11"><img src="<%=approot%>/images/mn07.jpg" border="0"></a>
                                                                                                                                            </td>
                                                                                                                                        </tr>                                                                                                            
                                                                                                                                        <tr>
                                                                                                                                            <td align="center" width="110">                                                                                                                        
                                                                                                                                                <a href="<%=approot%>/freport/profitloss_segment.jsp?menu_idx=11" style="text-decoration: none"><font face="arial" color="#07770A"><%=strPLDetail%> MTD <BR> (Summary 3 period)</font></a>                                                                                                                        
                                                                                                                                            </td>
                                                                                                                                        </tr>
                                                                                                                                    </table>                                                                                                                                
                                                                                                                                </td>  
                                                                                                                                <%}%>                                                                                                                                
                                                                                                                                <td colspan="1" width="25">&nbsp;</td>
                                                                                                                                <td valign="top">
                                                                                                                                    <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                                        <tr>
                                                                                                                                            <td align="center" width="110">                                                                                                                        
                                                                                                                                                <a href="<%=approot%>/freport/profitloss_segmentgen.jsp?menu_idx=11"><img src="<%=approot%>/images/mn07.jpg" border="0"></a>
                                                                                                                                            </td>
                                                                                                                                        </tr>                                                                                                            
                                                                                                                                        <tr>
                                                                                                                                            <td align="center" width="110">                                                                                                                        
                                                                                                                                                <a href="<%=approot%>/freport/profitloss_segmentgen.jsp?menu_idx=11" style="text-decoration: none"><font face="arial" color="#07770A"><%=strPLDetail%> MTD <BR> (Summary 3 period)</font></a>                                                                                                                        
                                                                                                                                            </td>
                                                                                                                                        </tr>
                                                                                                                                    </table>                                                                                                                                
                                                                                                                                </td>  
                                                                                                                                <td colspan="1" width="25">&nbsp;</td>
                                                                                                                            </tr>
                                                                                                                            <tr>
                                                                                                                                <td colspan="1" >&nbsp;</td>
                                                                                                                            </tr>
                                                                                                                        </table>
                                                                                                                    </td>
                                                                                                                </tr> 
                                                                                                                <%if(false){%>
                                                                                                                <tr>
                                                                                                                    <td colspan="1" >&nbsp;</td>
                                                                                                                </tr>
                                                                                                                <tr>
                                                                                                                    <td colspan="1" >
                                                                                                                        <table cellpadding="1" cellspacing="0" border="0">
                                                                                                                            <tr>
                                                                                                                                <td valign="top">
                                                                                                                                    <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                                        <tr>
                                                                                                                                            <td align="center" width="110">                                                                                                                        
                                                                                                                                                <a href="<%=approot%>/freport/generate_pnl.jsp?menu_idx=11"><img src="<%=approot%>/images/mn06.jpg" border="0"></a>
                                                                                                                                            </td>
                                                                                                                                        </tr>                                                                                                            
                                                                                                                                        <tr>
                                                                                                                                            <td align="center" width="110">                                                                                                                        
                                                                                                                                                <a href="<%=approot%>/freport/generate_pnl.jsp?menu_idx=11" style="text-decoration: none"><font face="arial" color="#07770A">Generate<BR>Laba Rugi</font></a>                                                                                                                        
                                                                                                                                            </td>
                                                                                                                                        </tr>
                                                                                                                                    </table>
                                                                                                                                </td> 
                                                                                                                                <td width="20" align="center" valign="middle"></td>
                                                                                                                                <td valign="top">
                                                                                                                                    <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                                        <tr>
                                                                                                                                            <td align="center" width="110">                                                                                                                        
                                                                                                                                                <a href="<%=approot%>/freport/profitloss_segmentgen.jsp?menu_idx=11"><img src="<%=approot%>/images/mn07.jpg" border="0"></a>
                                                                                                                                            </td>
                                                                                                                                        </tr>                                                                                                            
                                                                                                                                        <tr>
                                                                                                                                            <td align="center" width="110">                                                                                                                        
                                                                                                                                                <a href="<%=approot%>/freport/profitloss_segmentgen.jsp?menu_idx=11" style="text-decoration: none"><font face="arial" color="#07770A"><%=strPLDetail%> MTD <BR> (By Generate)</font></a>                                                                                                                        
                                                                                                                                            </td>
                                                                                                                                        </tr>
                                                                                                                                    </table>                                                                                                                                
                                                                                                                                </td>  
                                                                                                                            </tr>   
                                                                                                                        </table>   
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                                <%}%>
                                                                                                                <%}%>
                                                                                                                <tr>
                                                                                                                    <td colspan="1" >&nbsp;</td>
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