
<%-- 
    Document   : menuar
    Created on : Mar 14, 2012, 11:50:35 AM
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

            String[] langNav = {"Account Receivable"};
            String strARAgingAnalysis = "Aging Analysis";
            String strARMember = "Customer Receivable Report";
            String strARAccList = "AR Acc. Setup";
            String strARGiroList = "Outstanding BG";
            String strARGiroArchives = "BG Archives";

            if (lang == LANG_ID) {
                String[] navID = {"Piutang"};
                langNav = navID;
                strARAgingAnalysis = "Analisis Aging";
                strARMember = "Laporan Piutang Konsumen";
                strARAccList = "Setup Acc. Piutang";
                strARGiroList = "BG Outstanding";
                strARGiroArchives = "Arsip BG";
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
                                                                                                <table border="0" cellspacing="0" cellpadding="0">
                                                                                                    <tr> 
                                                                                                        <td > 
                                                                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                                                <tr> 
                                                                                                                    <%if (arAging) {%>
                                                                                                                    <td valign="top">
                                                                                                                        <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                            <tr>
                                                                                                                                <td align="center" width="90">                                                                                                                        
                                                                                                                                    <a href="<%=approot%>/ar/aging.jsp?menu_idx=4"><img src="<%=approot%>/images/mn20.jpg" border="0"></a>
                                                                                                                                </td>
                                                                                                                            </tr>                                                                                                            
                                                                                                                            <tr>
                                                                                                                                <td align="center" width="90">                                                                                                                        
                                                                                                                                    <a href="<%=approot%>/ar/aging.jsp?menu_idx=4" style="text-decoration: none"><font face="arial" color="#07770A"><%=strARAgingAnalysis%></font></a>
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                        </table>
                                                                                                                    </td>     
                                                                                                                    <td width="20" align="center" valign="middle"></td>
                                                                                                                    <td>        
                                                                                                                        <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                            <tr>
                                                                                                                                <td align="center" width="90">                                                                                                                        
                                                                                                                                    <a href="<%=approot%>/ar/giro_ar.jsp?menu_idx=4"><img src="<%=approot%>/images/mn06.jpg" border="0"></a>
                                                                                                                                </td>
                                                                                                                            </tr>                                                                                                            
                                                                                                                            <tr>
                                                                                                                                <td align="center" width="90">                                                                                                                        
                                                                                                                                    <a href="<%=approot%>/ar/giro_ar.jsp?menu_idx=4" style="text-decoration: none"><font face="arial" color="#07770A"><%=strARGiroList%></font></a>
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                        </table>
                                                                                                                    </td>  
                                                                                                                    <td width="20" align="center" valign="middle"></td>
                                                                                                                    <td>        
                                                                                                                        <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                            <tr>
                                                                                                                                <td align="center" width="90">                                                                                                                        
                                                                                                                                    <a href="<%=approot%>/ar/giro_archives.jsp?menu_idx=4"><img src="<%=approot%>/images/mn19.jpg" border="0"></a>
                                                                                                                                </td>
                                                                                                                            </tr>                                                                                                            
                                                                                                                            <tr>
                                                                                                                                <td align="center" width="90">                                                                                                                        
                                                                                                                                    <a href="<%=approot%>/ar/giro_archives.jsp?menu_idx=4" style="text-decoration: none"><font face="arial" color="#07770A"><%=strARGiroArchives%></font></a>
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                        </table>
                                                                                                                    </td>  
                                                                                                                    <td width="20" align="center" valign="middle"></td>     
                                                                                                                    <td valign="top">                                                                                                                        
                                                                                                                        <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                            <tr>
                                                                                                                                <td align="center" width="90">                                                                                                                        
                                                                                                                                    <a href="<%=approot%>/ar/armember.jsp?menu_idx=4"><img src="<%=approot%>/images/mn08.jpg" border="0"></a>
                                                                                                                                </td>
                                                                                                                            </tr>                                                                                                            
                                                                                                                            <tr>
                                                                                                                                <td align="center" width="90">                                                                                                                        
                                                                                                                                    <a href="<%=approot%>/ar/armember.jsp?menu_idx=4" style="text-decoration: none"><font face="arial" color="#07770A"><%=strARMember%></font></a>
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                        </table>
                                                                                                                    </td>     
                                                                                                                    <td width="20" align="center" valign="middle"></td>
                                                                                                                    <%}%>    
                                                                                                                                                                                                                                   
                                                                                                                    <%if (arList) {%>
                                                                                                                    <td>
                                                                                                                        <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                            <tr>
                                                                                                                                <td align="center" width="90">                                                                                                                        
                                                                                                                                    <a href="<%=approot%>/master/aracclink.jsp?menu_idx=4"><img src="<%=approot%>/images/mn17.jpg" border="0"></a>
                                                                                                                                </td>
                                                                                                                            </tr>                                                                                                            
                                                                                                                            <tr>
                                                                                                                                <td align="center" width="90">                                                                                                                        
                                                                                                                                    <a href="<%=approot%>/master/aracclink.jsp?menu_idx=4" style="text-decoration: none"><font face="arial" color="#07770A"><%=strARAccList%></font></a>
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                        </table>
                                                                                                                    </td>     
                                                                                                                    <td width="20" align="center" valign="middle"></td>
                                                                                                                    <%}%>                                                                                                                
                                                                                                                    <td width="20" align="center" valign="middle"></td>
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

