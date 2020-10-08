
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
<% int appObjCode = 1;%>
<%@ include file = "../main/check.jsp" %>
<%
            boolean priv = true;
            boolean privView = true;
            boolean privUpdate = true;
            boolean privAdd = true;
            boolean privDelete = true;
%>
<%
            int iJSPCommand = JSPRequestValue.requestCommand(request);
            int start = JSPRequestValue.requestInt(request, "start");
            int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");

            String[] langNav = {"Journal"};

            String strGJ = "General Journal";
            String strJR = "Journal Reversal";
            String strAT = "Recurring Journal";
            String strGJNew = "New Journal";
            String strJRNew = "New Journal";
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
            String strGJNewBackdated = "New Backdated Journal";String strPostJurnalBackdated = "Post Bacdated Jurnal";
            String strGJNew13 = "New Journal 13";String strGJArchivesBackdated = "Archives Bacdated";String strGJArchives13 = "Archives 13";String strPostJurnal13 = "Post Jurnal 13"; 
            if (lang == LANG_ID) {
                String[] navID = {"Jurnal"};
                langNav = navID;
                strGJ = "Jurnal Umum";
                strJR = "Jurnal Reversal";
                strAT = "Jurnal Berulang";
                strGJNew = "Jurnal Baru";
                strJRNew = "Jurnal Reversal";
                strATSetup = "Setup Jurnal";
                strGJAdvance = "Pemakaian Kasbon";
                strJRPosted = "Jurnal Pembalikkan";
                strATProcess = "Proses";
                strGJArchives = "Arsip";
                strJRArchives = "Arsip";
                strATArchives = "Arsip";
                strPostJurnal = "Post Jurnal";
                strGJBackdated = "Journal Periode Closed";
                strGJ13 = "Journal Periode-13";
                strGJNewBackdated = "Jurnal Baru";
                strGJNew13 = "Journal Baru 13";strGJArchivesBackdated = "Arsip Jurnal";strGJArchives13 = "Arsip 13";strPostJurnalBackdated = "Post Jurnal";
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
            <%if (!priv || !privView) {%>
            window.location="<%=approot%>/nopriv.jsp";
            <%}%>
            
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
                                                                                                                            <tr height="35">
                                                                                                                                <%if (glPriv) {%>
                                                                                                                                <td width="120" align="center" valign="middle" class="menu-idx-up"><%=strGJ%></td>
                                                                                                                                <td width="1">&nbsp;</td>
                                                                                                                                <td width="120" align="center" valign="middle" class="menu-idx-up"><%=strJR%></td>
                                                                                                                                <td width="1">&nbsp;</td>
                                                                                                                                <td width="120" align="center" valign="middle" class="menu-idx-up"><%=strAT%></td>
                                                                                                                                <td width="1">&nbsp;</td>
                                                                                                                                <%}%>
                                                                                                                            </tr>    
                                                                                                                            <tr>
                                                                                                                                <%if (glPriv) {%>
                                                                                                                                <%
    String styleb = "style=\"border-left:solid 1px #999;\"";
                                                                                                                                %>
                                                                                                                                <td width="120" align="center" valign="middle" <%=styleb%> >&nbsp;</td>
                                                                                                                                <td width="1">&nbsp;</td>
                                                                                                                                <td width="120" align="center" valign="middle" <%=styleb%>>&nbsp;</td>
                                                                                                                                <td width="1">&nbsp;</td>
                                                                                                                                <td width="120" align="center" valign="middle" <%=styleb%>>&nbsp;</td>
                                                                                                                                <td width="1">&nbsp;</td>
                                                                                                                                <%}%>
                                                                                                                            </tr>    
                                                                                                                            <tr >
                                                                                                                                <%if (glPriv) {%>
                                                                                                                                <td width="120" align="left" valign="middle" >
                                                                                                                                    <table width="120" border="0" cellpadding="0" cellspacing="0" height="35">
                                                                                                                                        <tr>
                                                                                                                                            <td width="10">
                                                                                                                                                <table width="10" cellpadding="0" cellspacing="0" height="35">
                                                                                                                                                    <tr>
                                                                                                                                                        <td style="border-left:solid 1px #999;border-bottom:solid 1px #999;">&nbsp;</td>
                                                                                                                                                    </tr>
                                                                                                                                                    <%
    String stylex = "";
    stylex = "style=\"border-left:solid 1px #999;\"";
                                                                                                                                                    %>
                                                                                                                                                    <tr>
                                                                                                                                                        <td <%=stylex%>>&nbsp;</td>
                                                                                                                                                    </tr>
                                                                                                                                                </table>
                                                                                                                                            </td>
                                                                                                                                            <td width="110" align="center" valign="middle" class="menu-idx"><a href="<%=approot%>/<%=transactionFolder%>/gldetail.jsp"><%=strGJNew%></a></td>
                                                                                                                                        </tr>    
                                                                                                                                    </table>    
                                                                                                                                </td>
                                                                                                                                <td width="1">&nbsp;</td>
                                                                                                                                <td width="120" align="left" valign="middle" >
                                                                                                                                    <table width="120" border="0" cellpadding="0" cellspacing="0" height="35">
                                                                                                                                        <tr>
                                                                                                                                            <td width="10">
                                                                                                                                                <table width="10" cellpadding="0" cellspacing="0" height="35">
                                                                                                                                                    <tr>
                                                                                                                                                        <td style="border-left:solid 1px #999;border-bottom:solid 1px #999;">&nbsp;</td>
                                                                                                                                                    </tr>
                                                                                                                                                    <%
    stylex = "";
    stylex = "style=\"border-left:solid 1px #999;\"";
                                                                                                                                                    %>
                                                                                                                                                    <tr>
                                                                                                                                                        <td <%=stylex%>>&nbsp;</td>
                                                                                                                                                    </tr>
                                                                                                                                                </table>
                                                                                                                                            </td>
                                                                                                                                            <td width="110" align="center" valign="middle" class="menu-idx"><a href="<%=approot%>/<%=transactionFolder%>/journalreversal.jsp"><%=strJRNew%></a></td>
                                                                                                                                        </tr>    
                                                                                                                                    </table>    
                                                                                                                                </td>
                                                                                                                                <td width="1">&nbsp;</td>
                                                                                                                                <td width="120" align="left" valign="middle" >
                                                                                                                                    <table width="120" border="0" cellpadding="0" cellspacing="0" height="35">
                                                                                                                                        <tr>
                                                                                                                                            <td width="10">
                                                                                                                                                <table width="10" cellpadding="0" cellspacing="0" height="35">
                                                                                                                                                    <tr>
                                                                                                                                                        <td style="border-left:solid 1px #999;border-bottom:solid 1px #999;">&nbsp;</td>
                                                                                                                                                    </tr>
                                                                                                                                                    <%
    stylex = "";
    stylex = "style=\"border-left:solid 1px #999;\"";
                                                                                                                                                    %>
                                                                                                                                                    <tr>
                                                                                                                                                        <td <%=stylex%>>&nbsp;</td>
                                                                                                                                                    </tr>
                                                                                                                                                </table>
                                                                                                                                            </td>
                                                                                                                                            <td width="110" align="center" valign="middle" class="menu-idx"><a href="<%=approot%>/<%=transactionFolder%>/akrualsetup.jsp"><%=strATSetup%></a></td>
                                                                                                                                        </tr>    
                                                                                                                                    </table>    
                                                                                                                                </td>
                                                                                                                                <td width="1">&nbsp;</td>
                                                                                                                                
                                                                                                                                <%}%>
                                                                                                                            </tr>    
                                                                                                                            <tr>
                                                                                                                                <%if (glPriv) {%>
                                                                                                                                <%
    String styleb = "style=\"border-left:solid 1px #999;\"";
                                                                                                                                %>
                                                                                                                                <td width="120" align="center" valign="middle" <%=styleb%> >&nbsp;</td>
                                                                                                                                <td width="1">&nbsp;</td>
                                                                                                                                <td width="120" align="center" valign="middle" <%=styleb%>>&nbsp;</td>
                                                                                                                                <td width="1">&nbsp;</td>
                                                                                                                                <td width="120" align="center" valign="middle" <%=styleb%>>&nbsp;</td>
                                                                                                                                <td width="1">&nbsp;</td>
                                                                                                                                <%}%>
                                                                                                                            </tr>   
                                                                                                                            <tr >
                                                                                                                                <%if (glPriv) {%>
                                                                                                                                <td width="120" align="left" valign="middle" >
                                                                                                                                    <table width="120" border="0" cellpadding="0" cellspacing="0" height="35">
                                                                                                                                        <tr>
                                                                                                                                            <td width="10">
                                                                                                                                                <table width="10" cellpadding="0" cellspacing="0" height="35">
                                                                                                                                                    <tr>
                                                                                                                                                        <td style="border-left:solid 1px #999;border-bottom:solid 1px #999;">&nbsp;</td>
                                                                                                                                                    </tr>
                                                                                                                                                    <%
    String stylex = "";
    stylex = "style=\"border-left:solid 1px #999;\"";
                                                                                                                                                    %>
                                                                                                                                                    <tr>
                                                                                                                                                        <td <%=stylex%>>&nbsp;</td>
                                                                                                                                                    </tr>
                                                                                                                                                </table>
                                                                                                                                            </td>
                                                                                                                                            <td width="110" align="center" valign="middle" class="menu-idx"><a href="<%=approot%>/<%=transactionFolder%>/glkasbon.jsp"><%=strGJAdvance%></a></td>
                                                                                                                                        </tr>    
                                                                                                                                    </table>    
                                                                                                                                </td>
                                                                                                                                <td width="1">&nbsp;</td>
                                                                                                                                <td width="120" align="left" valign="middle" >
                                                                                                                                    <table width="120" border="0" cellpadding="0" cellspacing="0" height="35">
                                                                                                                                        <tr>
                                                                                                                                            <td width="10">
                                                                                                                                                <table width="10" cellpadding="0" cellspacing="0" height="35">
                                                                                                                                                    <tr>
                                                                                                                                                        <td style="border-left:solid 1px #999;border-bottom:solid 1px #999;">&nbsp;</td>
                                                                                                                                                    </tr>
                                                                                                                                                    <%
    stylex = "";
    stylex = "style=\"border-left:solid 1px #999;\"";
                                                                                                                                                    %>
                                                                                                                                                    <tr>
                                                                                                                                                        <td <%=stylex%>>&nbsp;</td>
                                                                                                                                                    </tr>
                                                                                                                                                </table>
                                                                                                                                            </td>
                                                                                                                                            <td width="110" align="center" valign="middle" class="menu-idx"><a href="<%=approot%>/<%=transactionFolder%>/glreverse.jsp"><%=strJRPosted%></a></td>
                                                                                                                                        </tr>    
                                                                                                                                    </table>    
                                                                                                                                </td>
                                                                                                                                <td width="1">&nbsp;</td>
                                                                                                                                <td width="120" align="left" valign="middle" >
                                                                                                                                    <table width="120" border="0" cellpadding="0" cellspacing="0" height="35">
                                                                                                                                        <tr>
                                                                                                                                            <td width="10">
                                                                                                                                                <table width="10" cellpadding="0" cellspacing="0" height="35">
                                                                                                                                                    <tr>
                                                                                                                                                        <td style="border-left:solid 1px #999;border-bottom:solid 1px #999;">&nbsp;</td>
                                                                                                                                                    </tr>
                                                                                                                                                    <%
    stylex = "";
    stylex = "style=\"border-left:solid 1px #999;\"";
                                                                                                                                                    %>
                                                                                                                                                    <tr>
                                                                                                                                                        <td <%=stylex%>>&nbsp;</td>
                                                                                                                                                    </tr>
                                                                                                                                                </table>
                                                                                                                                            </td>
                                                                                                                                            <td width="110" align="center" valign="middle" class="menu-idx"><a href="<%=approot%>/<%=transactionFolder%>/akrualproses.jsp"><%=strATProcess%></a></td>
                                                                                                                                        </tr>    
                                                                                                                                    </table>    
                                                                                                                                </td>
                                                                                                                                <td width="1">&nbsp;</td>                                                                                                                                
                                                                                                                                <%}%>
                                                                                                                            </tr>   
                                                                                                                            <tr>
                                                                                                                                <%if (glPriv) {%>
                                                                                                                                <%
    String styleb = "style=\"border-left:solid 1px #999;\"";
                                                                                                                                %>
                                                                                                                                <td width="120" align="center" valign="middle" <%=styleb%> >&nbsp;</td>
                                                                                                                                <td width="1">&nbsp;</td>
                                                                                                                                <td width="120" align="center" valign="middle" <%=styleb%>>&nbsp;</td>
                                                                                                                                <td width="1">&nbsp;</td>
                                                                                                                                <td width="120" align="center" valign="middle" <%=styleb%>>&nbsp;</td>
                                                                                                                                <td width="1">&nbsp;</td>
                                                                                                                                <%}%>
                                                                                                                            </tr>  
                                                                                                                            <tr >
                                                                                                                                <%if (glPriv) {%>
                                                                                                                                <td width="120" align="left" valign="middle" >
                                                                                                                                    <table width="120" border="0" cellpadding="0" cellspacing="0" height="35">
                                                                                                                                        <tr>
                                                                                                                                            <td width="10">
                                                                                                                                                <table width="10" cellpadding="0" cellspacing="0" height="35">
                                                                                                                                                    <tr>
                                                                                                                                                        <td style="border-left:solid 1px #999;border-bottom:solid 1px #999;">&nbsp;</td>
                                                                                                                                                    </tr>
                                                                                                                                                    <%
    String stylex = "";
    stylex = "style=\"border-left:solid 1px #999;\"";
                                                                                                                                                    %>
                                                                                                                                                    <tr>
                                                                                                                                                        <td >&nbsp;</td>
                                                                                                                                                    </tr>
                                                                                                                                                </table>
                                                                                                                                            </td>
                                                                                                                                            <td width="110" align="center" valign="middle" class="menu-idx"><a href="<%=approot%>/<%=transactionFolder%>/glarchive.jsp"><%=strGJArchives%></a></td>
                                                                                                                                        </tr>    
                                                                                                                                    </table>    
                                                                                                                                </td>
                                                                                                                                <td width="1">&nbsp;</td>
                                                                                                                                <td width="120" align="left" valign="middle" >
                                                                                                                                    <table width="120" border="0" cellpadding="0" cellspacing="0" height="35">
                                                                                                                                        <tr>
                                                                                                                                            <td width="10">
                                                                                                                                                <table width="10" cellpadding="0" cellspacing="0" height="35">
                                                                                                                                                    <tr>
                                                                                                                                                        <td style="border-left:solid 1px #999;border-bottom:solid 1px #999;">&nbsp;</td>
                                                                                                                                                    </tr>
                                                                                                                                                    <%
    stylex = "";
    stylex = "style=\"border-left:solid 1px #999;\"";
                                                                                                                                                    %>
                                                                                                                                                    <tr>
                                                                                                                                                        <td >&nbsp;</td>
                                                                                                                                                    </tr>
                                                                                                                                                </table>
                                                                                                                                            </td>
                                                                                                                                            <td width="110" align="center" valign="middle" class="menu-idx"><a href="<%=approot%>/<%=transactionFolder%>/glreversearchive.jsp"><%=strJRArchives%></a></td>
                                                                                                                                        </tr>    
                                                                                                                                    </table>    
                                                                                                                                </td>
                                                                                                                                <td width="1">&nbsp;</td>
                                                                                                                                <td width="120" align="left" valign="middle" >
                                                                                                                                    <table width="120" border="0" cellpadding="0" cellspacing="0" height="35">
                                                                                                                                        <tr>
                                                                                                                                            <td width="10">
                                                                                                                                                <table width="10" cellpadding="0" cellspacing="0" height="35">
                                                                                                                                                    <tr>
                                                                                                                                                        <td style="border-left:solid 1px #999;border-bottom:solid 1px #999;">&nbsp;</td>
                                                                                                                                                    </tr>
                                                                                                                                                    <%
    stylex = "";
    stylex = "style=\"border-left:solid 1px #999;\"";
                                                                                                                                                    %>
                                                                                                                                                    <tr>
                                                                                                                                                        <td>&nbsp;</td>
                                                                                                                                                    </tr>
                                                                                                                                                </table>
                                                                                                                                            </td>
                                                                                                                                            <td width="110" align="center" valign="middle" class="menu-idx"><a href="<%=approot%>/<%=transactionFolder%>/akrualarsip.jsp?"><%=strATArchives%></a></td>
                                                                                                                                        </tr>    
                                                                                                                                    </table>    
                                                                                                                                </td>
                                                                                                                                <td width="1">&nbsp;</td>                                                                                                                                
                                                                                                                                <%}%>
                                                                                                                            </tr>  
                                                                                                                        </table>    
                                                                                                                    </td>    
                                                                                                                </tr> 
                                                                                                                <%if (postGlPriv) {%>
                                                                                                                <tr>
                                                                                                                    <td height="35">&nbsp;</td>
                                                                                                                </tr>
                                                                                                                <tr>
                                                                                                                    <td>
                                                                                                                        <table cellpadding="0" cellspacing="0" border="0">
                                                                                                                            <tr align="left" valign="top" height="35"> 
                                                                                                                                
                                                                                                                                <td width="120" align="center" valign="middle" class="menu-idx"><a href="<%=approot%>/<%=transactionFolder%>/posting_gl.jsp"><%=strPostJurnal%></a></td>
                                                                                                                                <td width="1">&nbsp; </td>
                                                                                                                            </tr>                      
                                                                                                                        </table>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                                <%}%>                                                                                                                
                                                                                                                <%if (((per13x.getOID() != 0) && (gl13Priv || postGl13Priv))) {%>
                                                                                                                <tr>
                                                                                                                    <td height="35">&nbsp;</td>
                                                                                                                </tr>
                                                                                                                <tr>
                                                                                                                    <td>
                                                                                                                        <table cellpadding="0" cellspacing="0" border="0">
                                                                                                                            <tr height="35">
                                                                                                                                <%if ((per13x.getOID() != 0) && (gl13Priv)) {%>
                                                                                                                                <td width="120" align="center" valign="middle" class="menu-idx-up"><%=strGJ13%></td>
                                                                                                                                <td width="1">&nbsp;</td>
                                                                                                                                <%}%>
                                                                                                                            </tr>    
                                                                                                                        </table>     
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                                <tr>   
                                                                                                                    <td>
                                                                                                                        <table cellpadding="0" cellspacing="0" border="0">
                                                                                                                            <tr>
                                                                                                                                <%
    String styleb2 = "";
    if ((per13x.getOID() != 0) && (gl13Priv)) {
        styleb2 = "style=\"border-left:solid 1px #999;\"";
    }
                                                                                                                                %>
                                                                                                                                <td width="120" align="center" valign="middle" <%=styleb2%>>&nbsp;</td>
                                                                                                                                <td width="1">&nbsp;</td>
                                                                                                                            </tr>
                                                                                                                        </table>
                                                                                                                    </td>
                                                                                                                </tr>   
                                                                                                                <tr>
                                                                                                                    <td>
                                                                                                                        <table cellpadding="0" cellspacing="0" border="0">
                                                                                                                            <tr>
                                                                                                                                <td width="120" align="left" valign="middle" >
                                                                                                                                    <table width="120" border="0" cellpadding="0" cellspacing="0" height="35">
                                                                                                                                        <tr>
                                                                                                                                            <td width="10">
                                                                                                                                                <table width="10" cellpadding="0" cellspacing="0" height="35">
                                                                                                                                                    <tr>
                                                                                                                                                        <td style="border-left:solid 1px #999;border-bottom:solid 1px #999;">&nbsp;</td>
                                                                                                                                                    </tr>
                                                                                                                                                    <%
    String stylex = "";
    stylex = "style=\"border-left:solid 1px #999;\"";
                                                                                                                                                    %>
                                                                                                                                                    <tr>
                                                                                                                                                        <td <%=stylex%>>&nbsp;</td>
                                                                                                                                                    </tr>
                                                                                                                                                </table>
                                                                                                                                            </td>
                                                                                                                                            <td width="110" align="center" valign="middle" class="menu-idx"><a href="<%=approot%>/<%=transactionFolder%>/gldetail13.jsp"><%=strGJNew13%></a></td>
                                                                                                                                        </tr>    
                                                                                                                                    </table>    
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                        </table>
                                                                                                                    </td>     
                                                                                                                </tr>
                                                                                                                <tr>   
                                                                                                                    <td>
                                                                                                                        <table cellpadding="0" cellspacing="0" border="0">
                                                                                                                            <tr>
                                                                                                                                <%
    styleb2 = "";
    if ((per13x.getOID() != 0) && (gl13Priv)) {
        styleb2 = "style=\"border-left:solid 1px #999;\"";
    }
                                                                                                                                %>
                                                                                                                                <td width="120" align="center" valign="middle" <%=styleb2%>>&nbsp;</td>
                                                                                                                                <td width="1">&nbsp;</td>
                                                                                                                            </tr>
                                                                                                                        </table>
                                                                                                                    </td>
                                                                                                                </tr>   
                                                                                                                <tr>
                                                                                                                    <td>
                                                                                                                        <table cellpadding="0" cellspacing="0" border="0">
                                                                                                                            <tr>
                                                                                                                                <td width="120" align="left" valign="middle" >
                                                                                                                                    <table width="120" border="0" cellpadding="0" cellspacing="0" height="35">
                                                                                                                                        <tr>
                                                                                                                                            <td width="10">
                                                                                                                                                <table width="10" cellpadding="0" cellspacing="0" height="35">
                                                                                                                                                    <tr>
                                                                                                                                                        <td style="border-left:solid 1px #999;border-bottom:solid 1px #999;">&nbsp;</td>
                                                                                                                                                    </tr>
                                                                                                                                                    <%
    stylex = "";
    stylex = "style=\"border-left:solid 1px #999;\"";
                                                                                                                                                    %>
                                                                                                                                                    <tr>
                                                                                                                                                        <td <%=stylex%>>&nbsp;</td>
                                                                                                                                                    </tr>
                                                                                                                                                </table>
                                                                                                                                            </td>
                                                                                                                                            <td width="110" align="center" valign="middle" class="menu-idx"><a href="<%=approot%>/<%=transactionFolder%>/glarchive13.jsp"><%=strGJArchives13%></a></td>
                                                                                                                                        </tr>    
                                                                                                                                    </table>    
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                        </table>
                                                                                                                    </td>     
                                                                                                                </tr>
                                                                                                                <tr>   
                                                                                                                    <td>
                                                                                                                        <table cellpadding="0" cellspacing="0" border="0">
                                                                                                                            <tr>
                                                                                                                                <%
    styleb2 = "";
    if ((per13x.getOID() != 0) && (gl13Priv)) {
        styleb2 = "style=\"border-left:solid 1px #999;\"";
    }
                                                                                                                                %>
                                                                                                                                <td width="120" align="center" valign="middle" <%=styleb2%>>&nbsp;</td>
                                                                                                                                <td width="1">&nbsp;</td>
                                                                                                                            </tr>
                                                                                                                        </table>
                                                                                                                    </td>
                                                                                                                </tr>   
                                                                                                                <tr>
                                                                                                                    <td>
                                                                                                                        <table cellpadding="0" cellspacing="0" border="0">
                                                                                                                            <tr>
                                                                                                                                <td width="120" align="left" valign="middle" >
                                                                                                                                    <table width="120" border="0" cellpadding="0" cellspacing="0" height="35">
                                                                                                                                        <tr>
                                                                                                                                            <td width="10">
                                                                                                                                                <table width="10" cellpadding="0" cellspacing="0" height="35">
                                                                                                                                                    <tr>
                                                                                                                                                        <td style="border-left:solid 1px #999;border-bottom:solid 1px #999;">&nbsp;</td>
                                                                                                                                                    </tr>
                                                                                                                                                    <%
    stylex = "";
    stylex = "style=\"border-left:solid 1px #999;\"";
                                                                                                                                                    %>
                                                                                                                                                    <tr>
                                                                                                                                                        <td >&nbsp;</td>
                                                                                                                                                    </tr>
                                                                                                                                                </table>
                                                                                                                                            </td>
                                                                                                                                            <td width="110" align="center" valign="middle" class="menu-idx"><a href="<%=approot%>/<%=transactionFolder%>/posting_gl13.jsp"><%=strPostJurnal13%></a></td>
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
                                                                                            </td>
                                                                                        </tr>
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
