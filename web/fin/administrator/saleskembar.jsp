
<%-- 
    Document   : saleskembar
    Created on : Jun 9, 2014, 11:36:54 AM
    Author     : Roy Andika
--%>

<%@ page import = "com.project.main.db.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page language="java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.main.entity.*" %>
<%@ page import = "com.project.admin.*" %>
<%@ page import = "java.sql.ResultSet" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.main.db.*" %>
<%@ page import = "com.project.admin.*" %>
<%@ page import = "com.project.ccs.postransaction.sales.*" %>
<%@ page import = "com.project.ccs.sql.*" %>
<%@ page import = "com.project.ccs.session.*" %>
<%@ page import = "com.project.ccs.posmaster.Shift" %>
<%@ page import = "com.project.ccs.posmaster.*" %>
<%@ page import = "com.project.fms.master.*" %>
<%@ page import = "com.project.general.*" %>
<%@ include file="../main/javainit.jsp"%>
<%@ include file="../main/check.jsp"%>
<%@ include file="../calendar/calendarframe.jsp"%>
<%
            boolean priv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MENU_ADMINISTRATOR, AppMenu.M2_MENU_SALES_EDITOR);
            boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_ADMINISTRATOR, AppMenu.M2_MENU_SALES_EDITOR, AppMenu.PRIV_VIEW);            
%>
<%
            int iJSPCommand = JSPRequestValue.requestCommand(request);            
            String number = JSPRequestValue.requestString(request, "number");

            Vector result = new Vector();
            if (iJSPCommand == JSPCommand.SUBMIT || iJSPCommand == JSPCommand.ACTIVATE) {                
                
                result = SessPostSales.getNumberDouble(number);                
                
                if(iJSPCommand == JSPCommand.ACTIVATE){
                    
                    if(result != null && result.size() > 0){
                        for(int i = 0; i < result.size() ; i++){
                            Sales s = (Sales)result.get(i);
                            SessPostSales.prosesNumberDoule(s.getNumber());
                        }        
                    }
                }
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
            
            function cmdSearch(){
                document.frmsaleseditor.command.value="<%=JSPCommand.SUBMIT%>";
                document.frmsaleseditor.action="saleskembar.jsp?menu_idx=<%=menuIdx%>";
                document.frmsaleseditor.submit();
            }
            
            function cmdSave(){
                document.frmsaleseditor.command.value="<%=JSPCommand.ACTIVATE %>";
                document.frmsaleseditor.action="saleskembar.jsp?menu_idx=<%=menuIdx%>";
                document.frmsaleseditor.submit();
            }
            
            <!--
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
            //-->
            
        </script>     
    </head>
    <body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','../images/new2.gif')">
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
                  <%@ include file="menu.jsp"%>
                                            <!-- #EndEditable -->
                                        </td>
                                        <td width="100%" valign="top"> 
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                <tr> 
                                                    <td class="title"><!-- #BeginEditable "title" -->
                                           <%
            String navigator = "<font class=\"lvl1\">Administrator</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">Sales Kembar</span></font>";
                                           %>
                                           <%@ include file="../main/navigator.jsp"%>
                                                    <!-- #EndEditable --></td>
                                                </tr>
                                                <!--tr> 
                      <td><img src="<%=approot%>/images/title-sp.gif" width="584" height="1"></td> 
                                                </tr-->
                                                <tr> 
                                                    <td class="container" ><!-- #BeginEditable "content" --> 
                                                        <form name="frmsaleseditor" method="post" action="">
                                                            <input type="hidden" name="command" value="">    
                                                            <table width="100%" border="0" >
                                                                <tr height="22">
                                                                    <td>
                                                                        <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                            <tr> 
                                                                                <td colspan="2">&nbsp;</td>
                                                                            </tr>                                                                            
                                                                            <tr height="22"> 
                                                                                <td width="14%" class="tablearialcell1">&nbsp;Number</td>
                                                                                <td width="86%">:&nbsp;<input type="text" name="number" value="<%=number%>" size="25"> 
                                                                                </td>
                                                                            </tr>
                                                                           
                                                                            <tr height="22"> 
                                                                                <td width="14%" >&nbsp;</td>
                                                                                <td width="86%"><a href="javascript:cmdSearch()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new2','','../images/search2.gif',1)"><img src="../images/search.gif" name="new2" border="0"></a></td>
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td>&nbsp;</td>
                                                                </tr> 
                                                                <tr>
                                                                    <td>
                                                                        <table cellpadding="0" cellspacing="1">
                                                                            <tr height="22">
                                                                                <td class="tablehdr" width="30">No.</td>
                                                                                <td class="tablehdr" width="150">Sales Number</td>
                                                                                <td class="tablehdr" width="100">Qty</td>                                                                                
                                                                            </tr>
                                                                            <%if (result != null && result.size() > 0) {

                for (int x = 0; x < result.size(); x++) {
                    Sales sales = (Sales)result.get(x);

                                                                            %>
                                                                            <tr height="22">
                                                                                <td class="tablecell1" align="center"><%=(x+1)%></td>
                                                                                <td class="tablecell1" align="center"><%=sales.getNumber() %></td>
                                                                                <td class="tablecell1" align="center"><%=JSPFormater.formatNumber(sales.getAmount(), "###,###") %></td>                                                                               
                                                                                
                                                                            </tr>
                                                                            <%}%>
                                                                            <tr height="22">
                                                                                <td colspan="2">&nbsp;</td>
                                                                            </tr>
                                                                            <tr height="22">
                                                                                <td colspan="2">
                                                                                    <a href="javascript:cmdSave()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('post','','../images/save2.gif',1)"><img src="../images/save.gif" name="post" border="0"></a>                                                                               
                                                                                </td>
                                                                            </tr>                                                                            
                                                                            <%}%>
                                                                        </table>
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
