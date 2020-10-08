
<%-- 
    Document   : moduledel
    Created on : Sep 21, 2011, 7:59:30 PM
    Author     : Roy Andika
--%>

<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.main.entity.*" %>
<%@ page import = "com.project.fms.activity.*" %>
<%@ page import = "com.project.*" %>
<%@ include file = "../main/javainit.jsp" %>
<%@ include file = "../main/check.jsp" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
            boolean useGereja = DbSystemProperty.getModSysPropGereja();
            int index = JSPRequestValue.requestInt(request, "index");

            String[] langCT = {"Activity Period", "Initial", "Code", "Description", "Output & Deliverable", "Performance Indikator", "Assumtion and Risk", //0-6
                "Cost Implication", "Level", "Parent", "Postable", "Type", "Status", "Nomor", "Memo", "Coa", "Budget"}; //7-12


            String[] langNav = {"Activity", "Activity List", "Budget List", "Data Saved", "Error, Data Incomplete", "Delete data sucsesful"};

            if (lang == LANG_ID) {
                String[] langID = {"Periode", "Inisial", "Kode", "Kegiatan", "Sasaran", "Indikator Performance", "Asumsi dan Resiko", //0-6
                    "Implikasi Biaya", "Level", "Induk", "Postable", "Type", "Status", "No", "keterangan", "Akun Perkiraan", "Anggaran"}; //7-12

                langCT = langID;

                String[] navID = {"Kegiatan", "Data Kerja", "Daftar Anggaran", "Data Sudah Tersimpan", "Error, Data Belum Lengkap", "Delete data berhasil"};
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
            function cmdBack(){               
                <%if (useGereja) {%>
                document.frmmodule.action="moduleg.jsp";
                <%} else {%>
                document.frmmodule.action="module.jsp";
                <%}%>
                document.frmmodule.submit();
            }
        </script>        
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
            String navigator = "<font class=\"lvl1\">" + langNav[0] + "</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">" + langNav[1] + "</span></font>";
                                           %>
                                           <%@ include file="../main/navigator.jsp"%>
                                             
                                                <tr> 
                                                    <td><!-- #BeginEditable "content" --> 
                                                        <form name="frmmodule" method ="post" action="">                                                                                                                      
                                                            <input type="hidden" name="index" value="<%=index%>">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr> 
                                                                    <td class="container"> 
                                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                            <tr>
                                                                                <td height="30"></td>
                                                                            </tr>    
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="8" valign="middle" colspan="3" > 
                                                                                    <table border="0" cellpadding="5" cellspacing="0" class="success">
                                                                                        <tr>
                                                                                            <td width="20"><img src="/btdc-fin/images/success.gif" width="20" height="20"></td>
                                                                                            <td width="200" nowrap><%=langNav[5]%></td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td height="10"></td>
                                                                            </tr>  
                                                                            <tr>
                                                                                <td width="80">
                                                                                    <a href="javascript:cmdBack()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('newc1','','../images/back2.gif',1)"><img src="../images/back.gif" name="newc1" border="0"></a>
                                                                                </td>
                                                                            </tr>                            
                                                                        </table>
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </form>
                                                    </td>
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
