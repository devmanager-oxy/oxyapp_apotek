
<%-- 
    Document   : menujournal
    Created on : Mar 13, 2012, 10:12:46 AM
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

            String[] langNav = {"Journal"};
            String strGJ = "General Journal";
            String strGJCC = "Jurnal Recon Card";
            String strJR = "Journal Reversal";
            String strAT = "Recurring Journal";
            String strGJNew = "New Journal";
            String strJRNew = "Copy Journal";
            String strATSetup = "Journal Setup";
            String strGJAdvance = "Advance Reimbursement";
            String strJRPosted = "Reverse Posted Journal";
            String strATProcess = "Process";
            String strGJArchives = "Archives";
            String strJRArchives = "Archives";
            String strATArchives = "Archives";
            String strPostJurnal = "Post Jurnal";
            String strGJBackdated = "Backdated Journal";
            String strGJ13 = "Journal 13th Period";
            String strGJNewBackdated = "New Backdated Journal";
            String strPostJurnalBackdated = "Post Bacdated Jurnal";
            String strGJNew13 = "New Journal 13";
            String strGJArchivesBackdated = "Archives Bacdated";
            String strGJArchives13 = "Archives 13";
            String strPostJurnal13 = "Post Jurnal 13";

            String strGAJournal = "GA Journal";
            String strGaArchives = "Archives GA";
            String strPostGa = "Post Jurnal";
            
            String strCashBackJournal = "Cash Back Journal";
            String strCashBackArchives = "Archives Cash Back";
            String strPostCashBack = "Post Jurnal";

            String strAdjustmentJournal = "Adjustment Journal";
            String strAdjustmentPosting = "Posting Journal";
            String strAdjustmentArsip = "Archives";

            String strCostingJournal = "Costing Journal";
            String strCostingPosting = "Posting Journal";
            String strCostingArsip = "Archives";

            String strReturJournal = "Retur Journal";
            String strReturPosting = "Posting Journal";
            String strReturArsip = "Archives";

            String strRepackJournal = "Repack Journal";
            String strRepackPosting = "Posting Journal";
            String strRepackArsip = "Archives";

            if (lang == LANG_ID) {
                String[] navID = {"Jurnal"};
                langNav = navID;
                strGJ = "Jurnal Umum";
                strGJCC = "Jurnal Recon Card";
                strJR = "Jurnal Reversal";
                strAT = "Jurnal Berulang";
                strGJNew = "Jurnal Baru";
                strJRNew = "Copy Jurnal";
                strATSetup = "Setup Jurnal";
                strGJAdvance = "Pemakaian Kasbon";
                strJRPosted = "Jurnal Pembalikkan";
                strATProcess = "Proses";
                strGJArchives = "Arsip";
                strJRArchives = "Arsip";
                strATArchives = "Arsip";
                strPostJurnal = "Post Jurnal";
                strGJBackdated = "Journal Periode Closed";
                strGJ13 = "Jurnal Periode-13";
                strGJNewBackdated = "Jurnal Baru";
                strGJNew13 = "Jurnal Baru 13";
                strGJArchivesBackdated = "Arsip Jurnal";
                strGJArchives13 = "Arsip 13";
                strPostJurnalBackdated = "Post Jurnal";

                strAdjustmentJournal = "Jurnal Adjustment";
                strAdjustmentPosting = "Post Jurnal";
                strAdjustmentArsip = "Arsip";

                strReturJournal = "Jurnal Retur";
                strReturPosting = "Post Jurnal";
                strReturArsip = "Arsip";

                strRepackJournal = "Jurnal Repack";
                strRepackPosting = "Post Jurnal";
                strRepackArsip = "Arsip";

                strCostingJournal = "Jurnal Costing";
                strCostingPosting = "Post Jurnal";
                strCostingArsip = "Arsip";

                strGaArchives = "Arsip GA";
                strPostGa = "Post Jurnal";
                strGAJournal = "Journal GA";
                
                strCashBackJournal = "Journal Cash Back";
                strCashBackArchives = "Arsip Cash Back";
                strPostCashBack = "Post Jurnal";
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
                                                        <form name="jspmenujurnal" method ="post" action="">
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
                                                                                        <%if (glPriv || glBackdatedPriv || glCopyPriv || postGlPriv || glArchivesPriv) {%>
                                                                                        <tr> 
                                                                                            <td>
                                                                                                <table cellpadding="0" cellspacing="0" border="0">
                                                                                                    <tr height="15">
                                                                                                        <td colspan="1" ></td>
                                                                                                        <td width="80" align="center" rowspan="2" valign="middle" nowrap >&nbsp;<font face="arial" color="#888282"><%=strGJ%></font>&nbsp;</td>                                                                                
                                                                                                        <td colspan="1" ></td>
                                                                                                    </tr>
                                                                                                    <tr>
                                                                                                        <td width="5" style="border-left: 1px solid #CCCCCC;border-top: 1px solid #CCCCCC;">&nbsp;</td>
                                                                                                        <td style="border-top: 1px solid #CCCCCC;border-right: 1px solid #CCCCCC;">&nbsp;</td>
                                                                                                    </tr>  
                                                                                                    <tr>                                                                                
                                                                                                        <td colspan="3" style="border-bottom: 1px solid #CCCCCC;border-left: 1px solid #CCCCCC;border-right: 1px solid #CCCCCC;">
                                                                                                            <table cellpadding="0" cellspacing="0" border="0">
                                                                                                                <tr>
                                                                                                                    <td width="10" align="center" valign="middle"></td>  
                                                                                                                    <%if (glPriv) {%>
                                                                                                                    <td valign="top">
                                                                                                                        <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                            <tr>
                                                                                                                                <td align="center" width="90">                                                                                                                        
                                                                                                                                    <a href="<%=approot%>/<%=transactionFolder%>/gldetail.jsp?menu_idx=10"><img src="<%=approot%>/images/mn05.jpg" border="0"></a>
                                                                                                                                </td>
                                                                                                                            </tr>                                                                                                            
                                                                                                                            <tr>
                                                                                                                                <td align="center" width="90">                                                                                                                        
                                                                                                                                    <a href="<%=approot%>/<%=transactionFolder%>/gldetail.jsp?menu_idx=10" style="text-decoration: none"><font face="arial" color="#07770A"><%=strGJ%></font></a>
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                        </table>
                                                                                                                    </td>     
                                                                                                                    <td width="20" align="center" valign="middle"></td>  
                                                                                                                    <%}%>
                                                                                                                    <%if (glBackdatedPriv) {%>
                                                                                                                    <td valign="top">
                                                                                                                        <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                            <tr>
                                                                                                                                <td align="center" width="90">                                                                                                                        
                                                                                                                                    <a href="<%=approot%>/<%=transactionFolder%>/glbaliklist.jsp?menu_idx=10"><img src="<%=approot%>/images/mn14.jpg" border="0"></a>
                                                                                                                                </td>
                                                                                                                            </tr>                                                                                                            
                                                                                                                            <tr>
                                                                                                                                <td align="center" width="90">                                                                                                                        
                                                                                                                                    <a href="<%=approot%>/<%=transactionFolder%>/glbaliklist.jsp?menu_idx=10" style="text-decoration: none"><font face="arial" color="#07770A"><%=strJRPosted%></font></a>
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                        </table>
                                                                                                                    </td>     
                                                                                                                    <td width="20" align="center" valign="middle"></td>
                                                                                                                    <%}%>
                                                                                                                    <%if (glCopyPriv) {%>
                                                                                                                    <td valign="top">
                                                                                                                        <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                            <tr>
                                                                                                                                <td align="center" width="90">                                                                                                                        
                                                                                                                                    <a href="<%=approot%>/<%=transactionFolder%>/glcopy.jsp?menu_idx=10"><img src="<%=approot%>/images/mn15.jpg" border="0"></a>
                                                                                                                                </td>
                                                                                                                            </tr>                                                                                                            
                                                                                                                            <tr>
                                                                                                                                <td align="center" width="90">                                                                                                                        
                                                                                                                                    <a href="<%=approot%>/<%=transactionFolder%>/glcopy.jsp?menu_idx=10" style="text-decoration: none"><font face="arial" color="#07770A"><%=strJRNew%></font></a>
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                        </table>
                                                                                                                    </td>     
                                                                                                                    <td width="20" align="center" valign="middle"></td>
                                                                                                                    <%}%>
                                                                                                                    <%if (postGlPriv) {%>
                                                                                                                    <td valign="top">
                                                                                                                        <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                            <tr>
                                                                                                                                <td align="center" width="90">                                                                                                                        
                                                                                                                                    <a href="<%=approot%>/<%=transactionFolder%>/posting_gl.jsp?menu_idx=10"><img src="<%=approot%>/images/mn06.jpg" border="0"></a>
                                                                                                                                </td>
                                                                                                                            </tr>                                                                                                            
                                                                                                                            <tr>
                                                                                                                                <td align="center" width="90">                                                                                                                        
                                                                                                                                    <a href="<%=approot%>/<%=transactionFolder%>/posting_gl.jsp?menu_idx=10"xxx style="text-decoration: none"><font face="arial" color="#07770A"><%=strPostJurnal%></font></a>
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                        </table>
                                                                                                                    </td>     
                                                                                                                    <td width="20" align="center" valign="middle"></td>
                                                                                                                    <%}%>
                                                                                                                    <%if (glArchivesPriv) {%>
                                                                                                                    <td valign="top">
                                                                                                                        <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                            <tr>
                                                                                                                                <td align="center" width="90">                                                                                                                        
                                                                                                                                    <a href="<%=approot%>/<%=transactionFolder%>/glarchive.jsp?menu_idx=10"><img src="<%=approot%>/images/mn19.jpg" border="0"></a>
                                                                                                                                </td>
                                                                                                                            </tr>                                                                                                            
                                                                                                                            <tr>
                                                                                                                                <td align="center" width="90">                                                                                                                        
                                                                                                                                    <a href="<%=approot%>/<%=transactionFolder%>/glarchive.jsp?menu_idx=10" style="text-decoration: none"><font face="arial" color="#07770A"><%=strGJArchives%></font></a>
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                        </table>
                                                                                                                    </td>     
                                                                                                                    <td width="20" align="center" valign="middle"></td>  
                                                                                                                    <%}%>
                                                                                                                    
                                                                                                                                                                                                                                       
                                                                                                                </tr>    
                                                                                                                <tr>
                                                                                                                    <td colspan="1" >&nbsp;</td>
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
                                                                                        <%}%>
                                                                                        <%if (akrualSetupPriv || akrualProsesPriv || akrualArchivesPriv || ((per13x.getOID() != 0) && (gl13Priv || postGl13Priv || gl13ArchivesPriv))) {%>
                                                                                        <tr> 
                                                                                            <td>
                                                                                                <table cellpadding="0" cellspacing="0" border="0">
                                                                                                    <tr>
                                                                                                        <%if (akrualSetupPriv || akrualProsesPriv || akrualArchivesPriv) {%>
                                                                                                        <td>
                                                                                                            <table cellpadding="0" cellspacing="0" border="0">
                                                                                                                <tr height="15">
                                                                                                                    <td colspan="1" ></td>
                                                                                                                    <td width="100" align="center" rowspan="2" valign="middle" nowrap >&nbsp;<font face="arial" color="#888282"><%=strAT%></font>&nbsp;</td>                                                                                
                                                                                                                    <td colspan="1" ></td>
                                                                                                                </tr>
                                                                                                                <tr>
                                                                                                                    <td width="5" style="border-left: 1px solid #CCCCCC;border-top: 1px solid #CCCCCC;">&nbsp;</td>
                                                                                                                    <td style="border-top: 1px solid #CCCCCC;border-right: 1px solid #CCCCCC;">&nbsp;</td>
                                                                                                                </tr>  
                                                                                                                <tr>                                                                                
                                                                                                                    <td colspan="3" style="border-bottom: 1px solid #CCCCCC;border-left: 1px solid #CCCCCC;border-right: 1px solid #CCCCCC;">
                                                                                                                        <table cellpadding="0" cellspacing="0" border="0">
                                                                                                                            <tr>
                                                                                                                                <td width="10" align="center" valign="middle"></td>
                                                                                                                                <%if (akrualSetupPriv) {%>
                                                                                                                                <td valign="top">
                                                                                                                                    <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                                        <tr>
                                                                                                                                            <td align="center" width="90">                                                                                                                        
                                                                                                                                                <a href="<%=approot%>/<%=transactionFolder%>/akrualsetup.jsp?menu_idx=10"><img src="<%=approot%>/images/mn17.jpg" border="0"></a>
                                                                                                                                            </td>
                                                                                                                                        </tr>                                                                                                            
                                                                                                                                        <tr>
                                                                                                                                            <td align="center" width="90">                                                                                                                        
                                                                                                                                                <a href="<%=approot%>/<%=transactionFolder%>/akrualsetup.jsp?menu_idx=10" style="text-decoration: none"><font face="arial" color="#07770A"><%=strATSetup%></font></a>
                                                                                                                                            </td>
                                                                                                                                        </tr>
                                                                                                                                    </table>
                                                                                                                                </td>     
                                                                                                                                <td width="10" align="center" valign="middle"></td>
                                                                                                                                <%}%>
                                                                                                                                <%if (akrualProsesPriv) {%>
                                                                                                                                <td valign="top">
                                                                                                                                    <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                                        <tr>
                                                                                                                                            <td align="center" width="90">                                                                                                                        
                                                                                                                                                <a href="<%=approot%>/<%=transactionFolder%>/akrualproses.jsp?menu_idx=10"><img src="<%=approot%>/images/mn06.jpg" border="0"></a>
                                                                                                                                            </td>
                                                                                                                                        </tr>                                                                                                            
                                                                                                                                        <tr>
                                                                                                                                            <td align="center" width="90">                                                                                                                        
                                                                                                                                                <a href="<%=approot%>/<%=transactionFolder%>/akrualproses.jsp?menu_idx=10" style="text-decoration: none"><font face="arial" color="#07770A"><%=strATProcess%></font></a>
                                                                                                                                            </td>
                                                                                                                                        </tr>
                                                                                                                                    </table>
                                                                                                                                </td>     
                                                                                                                                <td width="10" align="center" valign="middle"></td>
                                                                                                                                <%}%>
                                                                                                                                <%if (akrualArchivesPriv) {%>
                                                                                                                                <td valign="top">
                                                                                                                                    <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                                        <tr height="55">
                                                                                                                                            <td align="center" width="90">                                                                                                                        
                                                                                                                                                <a href="<%=approot%>/<%=transactionFolder%>/akrualarsip.jsp?menu_idx=10"><img src="<%=approot%>/images/mn19.jpg" border="0"></a>
                                                                                                                                            </td>
                                                                                                                                        </tr>                                                                                                            
                                                                                                                                        <tr>
                                                                                                                                            <td align="center" width="90">                                                                                                                        
                                                                                                                                                <a href="<%=approot%>/<%=transactionFolder%>/akrualarsip.jsp?menu_idx=10" style="text-decoration: none"><font face="arial" color="#07770A"><%=strATArchives%></font></a>
                                                                                                                                            </td>
                                                                                                                                        </tr>
                                                                                                                                    </table>
                                                                                                                                </td>    
                                                                                                                                <%}%>
                                                                                                                            </tr>
                                                                                                                            <tr>
                                                                                                                                <td colspan="1" >&nbsp;</td>
                                                                                                                            </tr>
                                                                                                                        </table>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                            </table>
                                                                                                        </td>
                                                                                                        <%}%>
                                                                                                        <%if (((per13x.getOID() != 0) && (gl13Priv || postGl13Priv || gl13ArchivesPriv))) {%>
                                                                                                        <td width="10">&nbsp;</td>
                                                                                                        <td>
                                                                                                            <table cellpadding="0" cellspacing="0" border="0">
                                                                                                                <tr height="15">
                                                                                                                    <td colspan="1" ></td>
                                                                                                                    <td width="100" align="center" rowspan="2" valign="middle" nowrap >&nbsp;<font face="arial" color="#888282"><%=strGJ13%></font>&nbsp;</td>                                                                                
                                                                                                                    <td colspan="1" ></td>
                                                                                                                </tr>
                                                                                                                <tr>
                                                                                                                    <td width="5" style="border-left: 1px solid #CCCCCC;border-top: 1px solid #CCCCCC;">&nbsp;</td>
                                                                                                                    <td style="border-top: 1px solid #CCCCCC;border-right: 1px solid #CCCCCC;">&nbsp;</td>
                                                                                                                </tr>  
                                                                                                                <tr>                                                                                
                                                                                                                    <td colspan="3" style="border-bottom: 1px solid #CCCCCC;border-left: 1px solid #CCCCCC;border-right: 1px solid #CCCCCC;">
                                                                                                                        <table cellpadding="0" cellspacing="0" border="0">
                                                                                                                            <tr>
                                                                                                                                <td width="10" align="center" valign="middle"></td>
                                                                                                                                <%if (gl13Priv) {%>
                                                                                                                                <td valign="top">
                                                                                                                                    <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                                        <tr>
                                                                                                                                            <td align="center" width="90">                                                                                                                        
                                                                                                                                                <a href="<%=approot%>/<%=transactionFolder%>/gldetail13.jsp?menu_idx=10"><img src="<%=approot%>/images/mn05.jpg" border="0"></a>                                                                                                                                                
                                                                                                                                            </td>
                                                                                                                                        </tr>                                                                                                            
                                                                                                                                        <tr>
                                                                                                                                            <td align="center" width="90">                                                                                                                        
                                                                                                                                                <a href="<%=approot%>/<%=transactionFolder%>/gldetail13.jsp?menu_idx=10" style="text-decoration: none"><font face="arial" color="#07770A"><%=strGJNew13%></font></a>
                                                                                                                                            </td>
                                                                                                                                        </tr>
                                                                                                                                    </table>
                                                                                                                                </td> 
                                                                                                                                <td width="10" align="center" valign="middle"></td>
                                                                                                                                <%}%>
                                                                                                                                <%if (postGl13Priv) {%>
                                                                                                                                <td valign="top">
                                                                                                                                    <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                                        <tr>
                                                                                                                                            <td align="center" width="90">                                                                                                                        
                                                                                                                                                <a href="<%=approot%>/<%=transactionFolder%>/posting_gl13.jsp?menu_idx=10"><img src="<%=approot%>/images/mn06.jpg" border="0"></a>                                                                                                                                              
                                                                                                                                            </td>
                                                                                                                                        </tr>                                                                                                            
                                                                                                                                        <tr>
                                                                                                                                            <td align="center" width="90">                                                                                                                        
                                                                                                                                                <a href="<%=approot%>/<%=transactionFolder%>/posting_gl13.jsp?menu_idx=10" style="text-decoration: none"><font face="arial" color="#07770A"><%=strPostJurnal13%></font></a>                                                                                                                                             
                                                                                                                                            </td>
                                                                                                                                        </tr>
                                                                                                                                    </table>
                                                                                                                                </td>   
                                                                                                                                <td width="10" align="center" valign="middle"></td>
                                                                                                                                <%}%>
                                                                                                                                <%if (gl13ArchivesPriv) {%>
                                                                                                                                <td valign="top">
                                                                                                                                    <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                                        <tr height="55">
                                                                                                                                            <td align="center" width="90">                                                                                                                        
                                                                                                                                                <a href="<%=approot%>/<%=transactionFolder%>/glarchive13.jsp?menu_idx=10"><img src="<%=approot%>/images/mn19.jpg" border="0"></a>                                                                                                                                                
                                                                                                                                            </td>
                                                                                                                                        </tr>                                                                                                            
                                                                                                                                        <tr>
                                                                                                                                            <td align="center" width="90">                                                                                                                        
                                                                                                                                                <a href="<%=approot%>/<%=transactionFolder%>/glarchive13.jsp?menu_idx=10" style="text-decoration: none"><font face="arial" color="#07770A"><%=strGJArchives13%></font></a>                                                                                                                                              
                                                                                                                                            </td>
                                                                                                                                        </tr>
                                                                                                                                    </table>
                                                                                                                                </td>     
                                                                                                                                <%}%>
                                                                                                                            </tr>
                                                                                                                            <tr>
                                                                                                                                <td colspan="1" >&nbsp;</td>
                                                                                                                            </tr>
                                                                                                                        </table>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                            </table>
                                                                                                        </td>
                                                                                                        <%}%> 
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr> 
                                                                                            <td>&nbsp;</td>
                                                                                        </tr>
                                                                                        <%}%>    
                                                                                        
                                                                                        <%if (adjustmentPostPriv || adjustmentArchivesPriv || costingPostPriv || costingArchivesPriv) {%>
                                                                                        <tr> 
                                                                                            <td>
                                                                                                <table cellpadding="0" cellspacing="0" border="0">
                                                                                                    <tr>
                                                                                                        <%if (adjustmentPostPriv || adjustmentArchivesPriv) {%>
                                                                                                        <td>
                                                                                                            <table cellpadding="0" cellspacing="0" border="0">
                                                                                                                <tr height="15">
                                                                                                                    <td colspan="1" ></td>
                                                                                                                    <td width="100" align="center" rowspan="2" valign="middle" nowrap >&nbsp;<font face="arial" color="#888282"><%=strAdjustmentJournal%></font>&nbsp;</td>                                                                                
                                                                                                                    <td colspan="1" ></td>
                                                                                                                </tr>
                                                                                                                <tr>
                                                                                                                    <td width="5" style="border-left: 1px solid #CCCCCC;border-top: 1px solid #CCCCCC;">&nbsp;</td>
                                                                                                                    <td style="border-top: 1px solid #CCCCCC;border-right: 1px solid #CCCCCC;">&nbsp;</td>
                                                                                                                </tr>  
                                                                                                                <tr>                                                                                
                                                                                                                    <td colspan="3" style="border-bottom: 1px solid #CCCCCC;border-left: 1px solid #CCCCCC;border-right: 1px solid #CCCCCC;">
                                                                                                                        <table cellpadding="0" cellspacing="0" border="0">
                                                                                                                            <tr>
                                                                                                                                <td width="10" align="center" valign="middle"></td>
                                                                                                                                <%if (adjustmentPostPriv) {%>
                                                                                                                                <td valign="top">
                                                                                                                                    <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                                        <tr>
                                                                                                                                            <td align="center" width="90">                                                                                                                        
                                                                                                                                                <a href="<%=approot%>/ap/adjusmentlist.jsp?menu_idx=10"><img src="<%=approot%>/images/mn06.jpg" border="0"></a>
                                                                                                                                            </td>
                                                                                                                                        </tr>                                                                                                            
                                                                                                                                        <tr>
                                                                                                                                            <td align="center" width="90">                                                                                                                        
                                                                                                                                                <a href="<%=approot%>/ap/adjusmentlist.jsp?menu_idx=10" style="text-decoration: none"><font face="arial" color="#07770A"><%=strAdjustmentPosting%></font></a>
                                                                                                                                            </td>
                                                                                                                                        </tr>
                                                                                                                                    </table>
                                                                                                                                </td>  
                                                                                                                                <td width="10" align="center" valign="middle"></td>
                                                                                                                                <%}%>
                                                                                                                                <%if (adjustmentArchivesPriv) {%>
                                                                                                                                <td valign="top">
                                                                                                                                    <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                                        <tr height="55">
                                                                                                                                            <td align="center" width="90">                                                                                                                        
                                                                                                                                                <a href="<%=approot%>/ap/adjusmentarchive.jsp?menu_idx=10"><img src="<%=approot%>/images/mn19.jpg" border="0"></a>
                                                                                                                                            </td>
                                                                                                                                        </tr>                                                                                                            
                                                                                                                                        <tr>
                                                                                                                                            <td align="center" width="90">                                                                                                                        
                                                                                                                                                <a href="<%=approot%>/ap/adjusmentarchive.jsp?menu_idx=10" style="text-decoration: none"><font face="arial" color="#07770A"><%=strAdjustmentArsip%></font></a>                                                                                                                                                
                                                                                                                                            </td>
                                                                                                                                        </tr>
                                                                                                                                    </table>
                                                                                                                                </td> 
                                                                                                                                <%}%>
                                                                                                                            </tr>
                                                                                                                            <tr>
                                                                                                                                <td colspan="1" >&nbsp;</td>
                                                                                                                            </tr>
                                                                                                                        </table> 
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                            </table>
                                                                                                        </td>
                                                                                                        <td width="10">&nbsp;</td>
                                                                                                        <%}%>
                                                                                                        
                                                                                                        <%if (costingPostPriv || costingArchivesPriv) {%>
                                                                                                        <td>
                                                                                                            <table cellpadding="0" cellspacing="0" border="0">
                                                                                                                <tr height="15">
                                                                                                                    <td colspan="1" ></td>
                                                                                                                    <td width="100" align="center" rowspan="2" valign="middle" nowrap >&nbsp;<font face="arial" color="#888282"><%=strCostingJournal%></font>&nbsp;</td>                                                                                
                                                                                                                    <td colspan="1" ></td>
                                                                                                                </tr>
                                                                                                                <tr>
                                                                                                                    <td width="5" style="border-left: 1px solid #CCCCCC;border-top: 1px solid #CCCCCC;">&nbsp;</td>
                                                                                                                    <td style="border-top: 1px solid #CCCCCC;border-right: 1px solid #CCCCCC;">&nbsp;</td>
                                                                                                                </tr>  
                                                                                                                <tr>                                                                                
                                                                                                                    <td colspan="3" style="border-bottom: 1px solid #CCCCCC;border-left: 1px solid #CCCCCC;border-right: 1px solid #CCCCCC;">
                                                                                                                        <table cellpadding="0" cellspacing="0" border="0">
                                                                                                                            <tr>
                                                                                                                                <td width="10" align="center" valign="middle"></td>
                                                                                                                                <%if (costingPostPriv) {%>
                                                                                                                                <td valign="top">
                                                                                                                                    <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                                        <tr>
                                                                                                                                            <td align="center" width="90">                                                                                                                                                
                                                                                                                                                <a href="<%=approot%>/ap/costlist.jsp?menu_idx=10"><img src="<%=approot%>/images/mn06.jpg" border="0"></a>                                                                                                                                                
                                                                                                                                            </td>
                                                                                                                                        </tr>                                                                                                            
                                                                                                                                        <tr>
                                                                                                                                            <td align="center" width="90">                                                                                                                                                
                                                                                                                                                <a href="<%=approot%>/ap/costlist.jsp?menu_idx=10" style="text-decoration: none"><font face="arial" color="#07770A"><%=strCostingPosting%></font></a>
                                                                                                                                            </td>
                                                                                                                                        </tr>
                                                                                                                                    </table>
                                                                                                                                </td>  
                                                                                                                                <td width="10" align="center" valign="middle"></td>
                                                                                                                                <%}%>
                                                                                                                                <%if (costingArchivesPriv) {%>
                                                                                                                                <td valign="top">
                                                                                                                                    <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                                        <tr height="55">
                                                                                                                                            <td align="center" width="90">                                                                                                                                                
                                                                                                                                                <a href="<%=approot%>/ap/costarchive.jsp?menu_idx=10"><img src="<%=approot%>/images/mn19.jpg" border="0"></a>                                                                                                                                                
                                                                                                                                            </td>
                                                                                                                                        </tr>                                                                                                            
                                                                                                                                        <tr>
                                                                                                                                            <td align="center" width="90">                                                                                                                                                
                                                                                                                                                <a href="<%=approot%>/ap/costarchive.jsp?menu_idx=10" style="text-decoration: none"><font face="arial" color="#07770A"><%=strCostingArsip%></font></a>
                                                                                                                                            </td>
                                                                                                                                        </tr>
                                                                                                                                    </table>
                                                                                                                                </td> 
                                                                                                                                <%}%>
                                                                                                                            </tr>
                                                                                                                            <tr>
                                                                                                                                <td colspan="1" >&nbsp;</td>
                                                                                                                            </tr>
                                                                                                                        </table> 
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                            </table>
                                                                                                        </td>
                                                                                                        <td width="10">&nbsp;</td>
                                                                                                        <%}%>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <%}%>
                                                                                        <%if (returPostPriv || returArchivesPriv || repackPostPriv || repackArchivesPriv) {%>
                                                                                        <tr>
                                                                                            <td width="10">&nbsp;</td>
                                                                                        </tr>
                                                                                        <tr> 
                                                                                            <td>
                                                                                                <table cellpadding="0" cellspacing="0" border="0">
                                                                                                    <tr>                                                                                        
                                                                                                        <%if (returPostPriv || returArchivesPriv) {%>
                                                                                                        <td>
                                                                                                            <table cellpadding="0" cellspacing="0" border="0">
                                                                                                                <tr height="15">
                                                                                                                    <td colspan="1" ></td>
                                                                                                                    <td width="100" align="center" rowspan="2" valign="middle" nowrap >&nbsp;<font face="arial" color="#888282"><%=strReturJournal%></font>&nbsp;</td>                                                                                
                                                                                                                    <td colspan="1" ></td>
                                                                                                                </tr>
                                                                                                                <tr>
                                                                                                                    <td width="5" style="border-left: 1px solid #CCCCCC;border-top: 1px solid #CCCCCC;">&nbsp;</td>
                                                                                                                    <td style="border-top: 1px solid #CCCCCC;border-right: 1px solid #CCCCCC;">&nbsp;</td>
                                                                                                                </tr>  
                                                                                                                <tr>                                                                                
                                                                                                                    <td colspan="3" style="border-bottom: 1px solid #CCCCCC;border-left: 1px solid #CCCCCC;border-right: 1px solid #CCCCCC;">
                                                                                                                        <table cellpadding="0" cellspacing="0" border="0">                                                                                                                            
                                                                                                                            <tr>
                                                                                                                                <td width="10" align="center" valign="middle"></td>
                                                                                                                                <%if (returPostPriv) {%>
                                                                                                                                <td valign="top">
                                                                                                                                    <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                                        <tr>
                                                                                                                                            <td align="center" width="90">                                                                                                                                                
                                                                                                                                                <a href="<%=approot%>/<%=transactionFolder%>/postingretur.jsp?menu_idx=10"><img src="<%=approot%>/images/mn06.jpg" border="0"></a>
                                                                                                                                            </td>
                                                                                                                                        </tr>                                                                                                            
                                                                                                                                        <tr>
                                                                                                                                            <td align="center" width="90">                                                                                                                                                
                                                                                                                                                <a href="<%=approot%>/<%=transactionFolder%>/postingretur.jsp?menu_idx=10" style="text-decoration: none"><font face="arial" color="#07770A"><%=strReturPosting%></font></a>
                                                                                                                                            </td>
                                                                                                                                        </tr>
                                                                                                                                    </table>
                                                                                                                                </td>
                                                                                                                                <td width="10" align="center" valign="middle"></td>
                                                                                                                                <%}%>
                                                                                                                                <%if (returArchivesPriv) {%>
                                                                                                                                <td valign="top">
                                                                                                                                    <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                                        <tr height="55">
                                                                                                                                            <td align="center" width="90">                                                                                                                                                
                                                                                                                                                <a href="<%=approot%>/<%=transactionFolder%>/returarsip.jsp?menu_idx=10"><img src="<%=approot%>/images/mn19.jpg" border="0"></a>                                                                                                                                                
                                                                                                                                            </td>
                                                                                                                                        </tr>                                                                                                            
                                                                                                                                        <tr>
                                                                                                                                            <td align="center" width="90">                                                                                                                                                
                                                                                                                                                <a href="<%=approot%>/<%=transactionFolder%>/returarsip.jsp?menu_idx=10" style="text-decoration: none"><font face="arial" color="#07770A"><%=strCostingArsip%></font></a>
                                                                                                                                            </td>
                                                                                                                                        </tr>
                                                                                                                                    </table>
                                                                                                                                </td> 
                                                                                                                                <%}%>
                                                                                                                            </tr>
                                                                                                                            <tr>
                                                                                                                                <td colspan="1" >&nbsp;</td>
                                                                                                                            </tr>
                                                                                                                        </table> 
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                            </table>
                                                                                                        </td>
                                                                                                        <td width="10">&nbsp;</td>
                                                                                                        <%}%>
                                                                                                        <%if (repackPostPriv || repackArchivesPriv) {%>
                                                                                                        <td>
                                                                                                            <table cellpadding="0" cellspacing="0" border="0">
                                                                                                                <tr height="15">
                                                                                                                    <td colspan="1" ></td>
                                                                                                                    <td width="100" align="center" rowspan="2" valign="middle" nowrap >&nbsp;<font face="arial" color="#888282"><%=strRepackJournal%></font>&nbsp;</td>                                                                                
                                                                                                                    <td colspan="1" ></td>
                                                                                                                </tr>
                                                                                                                <tr>
                                                                                                                    <td width="5" style="border-left: 1px solid #CCCCCC;border-top: 1px solid #CCCCCC;">&nbsp;</td>
                                                                                                                    <td style="border-top: 1px solid #CCCCCC;border-right: 1px solid #CCCCCC;">&nbsp;</td>
                                                                                                                </tr>  
                                                                                                                <tr>                                                                                
                                                                                                                    <td colspan="3" style="border-bottom: 1px solid #CCCCCC;border-left: 1px solid #CCCCCC;border-right: 1px solid #CCCCCC;">
                                                                                                                        <table cellpadding="0" cellspacing="0" border="0">                                                                                                                            
                                                                                                                            <tr>
                                                                                                                                <td width="10" align="center" valign="middle"></td>
                                                                                                                                <%if (repackPostPriv) {%>
                                                                                                                                <td valign="top">
                                                                                                                                    <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                                        <tr>
                                                                                                                                            <td align="center" width="90">                                                                                                                                                
                                                                                                                                                <a href="<%=approot%>/<%=transactionFolder%>/postingrepack.jsp?menu_idx=10"><img src="<%=approot%>/images/mn06.jpg" border="0"></a>
                                                                                                                                            </td>
                                                                                                                                        </tr>                                                                                                            
                                                                                                                                        <tr>
                                                                                                                                            <td align="center" width="90">                                                                                                                                                
                                                                                                                                                <a href="<%=approot%>/<%=transactionFolder%>/postingrepack.jsp?menu_idx=10" style="text-decoration: none"><font face="arial" color="#07770A"><%=strRepackPosting%></font></a>
                                                                                                                                            </td>
                                                                                                                                        </tr>
                                                                                                                                    </table>
                                                                                                                                </td>
                                                                                                                                <td width="10" align="center" valign="middle"></td>
                                                                                                                                <%}%>
                                                                                                                                <%if (repackArchivesPriv) {%>
                                                                                                                                <td valign="top">
                                                                                                                                    <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                                        <tr height="55">
                                                                                                                                            <td align="center" width="90">                                                                                                                                                
                                                                                                                                                <a href="<%=approot%>/<%=transactionFolder%>/repackarsip.jsp?menu_idx=10"><img src="<%=approot%>/images/mn19.jpg" border="0"></a>                                                                                                                                                
                                                                                                                                            </td>
                                                                                                                                        </tr>                                                                                                            
                                                                                                                                        <tr>
                                                                                                                                            <td align="center" width="90">                                                                                                                                                
                                                                                                                                                <a href="<%=approot%>/<%=transactionFolder%>/repackarsip.jsp?menu_idx=10" style="text-decoration: none"><font face="arial" color="#07770A"><%=strCostingArsip%></font></a>
                                                                                                                                            </td>
                                                                                                                                        </tr>
                                                                                                                                    </table>
                                                                                                                                </td> 
                                                                                                                                <%}%>
                                                                                                                            </tr>
                                                                                                                            <tr>
                                                                                                                                <td colspan="1" >&nbsp;</td>
                                                                                                                            </tr>
                                                                                                                        </table> 
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                            </table>
                                                                                                        </td>
                                                                                                        <%}%>
                                                                                                    </tr>
                                                                                                </table>    
                                                                                            </td>
                                                                                        </tr>
                                                                                        <%}%>   
                                                                                        
                                                                                        <%if (gaPostPriv || gaArchivesPriv  || cashBackPostPriv || cashBackArchivesPriv ) {%>
                                                                                        <tr>
                                                                                            <td width="10">&nbsp;</td>
                                                                                        </tr>
                                                                                        <tr> 
                                                                                            <td>
                                                                                                <table cellpadding="0" cellspacing="0" border="0">
                                                                                                    <tr>                                                                                        
                                                                                                        <%if (gaPostPriv || gaArchivesPriv) {%>
                                                                                                        <td>
                                                                                                            <table cellpadding="0" cellspacing="0" border="0">
                                                                                                                <tr height="15">
                                                                                                                    <td colspan="1" ></td>
                                                                                                                    <td width="100" align="center" rowspan="2" valign="middle" nowrap >&nbsp;<font face="arial" color="#888282"><%=strGAJournal%></font>&nbsp;</td>                                                                                
                                                                                                                    <td colspan="1" ></td>
                                                                                                                </tr>
                                                                                                                <tr>
                                                                                                                    <td width="5" style="border-left: 1px solid #CCCCCC;border-top: 1px solid #CCCCCC;">&nbsp;</td>
                                                                                                                    <td style="border-top: 1px solid #CCCCCC;border-right: 1px solid #CCCCCC;">&nbsp;</td>
                                                                                                                </tr>  
                                                                                                                <tr>                                                                                
                                                                                                                    <td colspan="3" style="border-bottom: 1px solid #CCCCCC;border-left: 1px solid #CCCCCC;border-right: 1px solid #CCCCCC;">
                                                                                                                        <table cellpadding="0" cellspacing="0" border="0">                                                                                                                            
                                                                                                                            <tr>
                                                                                                                                <td width="10" align="center" valign="middle"></td>
                                                                                                                                <%if (gaPostPriv) {%>
                                                                                                                                <td valign="top">
                                                                                                                                    <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                                        <tr>
                                                                                                                                            <td align="center" width="90">                                                                                                                                                
                                                                                                                                                <a href="<%=approot%>/<%=transactionFolder%>/postingga.jsp?menu_idx=10"><img src="<%=approot%>/images/mn06.jpg" border="0"></a>
                                                                                                                                            </td>
                                                                                                                                        </tr>                                                                                                            
                                                                                                                                        <tr>
                                                                                                                                            <td align="center" width="90">                                                                                                                                                
                                                                                                                                                <a href="<%=approot%>/<%=transactionFolder%>/postingga.jsp?menu_idx=10" style="text-decoration: none"><font face="arial" color="#07770A"><%=strPostGa%></font></a>
                                                                                                                                            </td>
                                                                                                                                        </tr>
                                                                                                                                    </table>
                                                                                                                                </td>
                                                                                                                                <td width="10" align="center" valign="middle"></td>
                                                                                                                                <%}%>
                                                                                                                                <%if (gaArchivesPriv) {%>
                                                                                                                                <td valign="top">
                                                                                                                                    <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                                        <tr height="55">
                                                                                                                                            <td align="center" width="90">                                                                                                                                                
                                                                                                                                                <a href="<%=approot%>/<%=transactionFolder%>/arsipga.jsp?menu_idx=10"><img src="<%=approot%>/images/mn19.jpg" border="0"></a>                                                                                                                                                
                                                                                                                                            </td>
                                                                                                                                        </tr>                                                                                                            
                                                                                                                                        <tr>
                                                                                                                                            <td align="center" width="90">                                                                                                                                                
                                                                                                                                                <a href="<%=approot%>/<%=transactionFolder%>/arsipga.jsp?menu_idx=10" style="text-decoration: none"><font face="arial" color="#07770A"><%=strGaArchives%></font></a>
                                                                                                                                            </td>
                                                                                                                                        </tr>
                                                                                                                                    </table>
                                                                                                                                </td> 
                                                                                                                                <%}%>
                                                                                                                            </tr>
                                                                                                                            <tr>
                                                                                                                                <td colspan="1" >&nbsp;</td>
                                                                                                                            </tr>
                                                                                                                        </table> 
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                            </table>
                                                                                                        </td>
                                                                                                        <td width="10">&nbsp;</td>
                                                                                                        <%}%>
                                                                                                        <%if(cashBackPostPriv || cashBackArchivesPriv){ %>
                                                                                                        <td>
                                                                                                            <table cellpadding="0" cellspacing="0" border="0">
                                                                                                                <tr height="15">
                                                                                                                    <td colspan="1" ></td>
                                                                                                                    <td width="100" align="center" rowspan="2" valign="middle" nowrap >&nbsp;<font face="arial" color="#888282"><%=strCashBackJournal%></font>&nbsp;</td>                                                                                
                                                                                                                    <td colspan="1" ></td>
                                                                                                                </tr>
                                                                                                                <tr>
                                                                                                                    <td width="5" style="border-left: 1px solid #CCCCCC;border-top: 1px solid #CCCCCC;">&nbsp;</td>
                                                                                                                    <td style="border-top: 1px solid #CCCCCC;border-right: 1px solid #CCCCCC;">&nbsp;</td>
                                                                                                                </tr>  
                                                                                                                <tr>                                                                                
                                                                                                                    <td colspan="3" style="border-bottom: 1px solid #CCCCCC;border-left: 1px solid #CCCCCC;border-right: 1px solid #CCCCCC;">
                                                                                                                        <table cellpadding="0" cellspacing="0" border="0">                                                                                                                            
                                                                                                                            <tr>
                                                                                                                                <td width="10" align="center" valign="middle"></td>
                                                                                                                                <%if (cashBackPostPriv) {%>
                                                                                                                                <td valign="top">
                                                                                                                                    <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                                        <tr>
                                                                                                                                            <td align="center" width="90">                                                                                                                                                
                                                                                                                                                <a href="<%=approot%>/<%=transactionFolder%>/postingcashback.jsp?menu_idx=10"><img src="<%=approot%>/images/mn06.jpg" border="0"></a>
                                                                                                                                            </td>
                                                                                                                                        </tr>                                                                                                            
                                                                                                                                        <tr>
                                                                                                                                            <td align="center" width="90">                                                                                                                                                
                                                                                                                                                <a href="<%=approot%>/<%=transactionFolder%>/postingcashback.jsp?menu_idx=10" style="text-decoration: none"><font face="arial" color="#07770A"><%=strPostCashBack%></font></a>
                                                                                                                                            </td>
                                                                                                                                        </tr>
                                                                                                                                    </table>
                                                                                                                                </td>
                                                                                                                                <td width="10" align="center" valign="middle"></td>
                                                                                                                                <%}%>
                                                                                                                                <%if (cashBackArchivesPriv) {%>
                                                                                                                                <td valign="top">
                                                                                                                                    <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                                        <tr height="55">
                                                                                                                                            <td align="center" width="90">                                                                                                                                                
                                                                                                                                                <a href="<%=approot%>/<%=transactionFolder%>/arsipcashback.jsp?menu_idx=10"><img src="<%=approot%>/images/mn19.jpg" border="0"></a>                                                                                                                                                
                                                                                                                                            </td>
                                                                                                                                        </tr>                                                                                                            
                                                                                                                                        <tr>
                                                                                                                                            <td align="center" width="90">                                                                                                                                                
                                                                                                                                                <a href="<%=approot%>/<%=transactionFolder%>/arsipcashback.jsp?menu_idx=10" style="text-decoration: none"><font face="arial" color="#07770A"><%=strCashBackArchives%></font></a>
                                                                                                                                            </td>
                                                                                                                                        </tr>
                                                                                                                                    </table>
                                                                                                                                </td> 
                                                                                                                                <%}%>
                                                                                                                            </tr>
                                                                                                                            <tr>
                                                                                                                                <td colspan="1" >&nbsp;</td>
                                                                                                                            </tr>
                                                                                                                        </table> 
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                            </table>
                                                                                                        </td>
                                                                                                        <td width="10">&nbsp;</td>

                                                                                                        <%}%>

                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <%}%>                                                                                        
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="22" valign="middle" colspan="3">&nbsp;</td>
                                                                            </tr>
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
