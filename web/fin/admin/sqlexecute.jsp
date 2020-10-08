
<%@ page language="java" import="java.sql.*"%>
<%@ page import = "com.project.main.db.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page language="java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.main.entity.*" %>
<%@ page import = "com.project.admin.*" %>
<%@ include file="../main/javainit.jsp"%>
<%@ include file="../main/check.jsp"%>
<%
            boolean priv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MENU_ADMINISTRATOR, AppMenu.M2_MENU_SQL_EXECUTE);
            boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_ADMINISTRATOR, AppMenu.M2_MENU_SQL_EXECUTE, AppMenu.PRIV_VIEW);
            boolean privUpdate = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_ADMINISTRATOR, AppMenu.M2_MENU_SQL_EXECUTE, AppMenu.PRIV_UPDATE);
            boolean privAdd = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_ADMINISTRATOR, AppMenu.M2_MENU_SQL_EXECUTE, AppMenu.PRIV_ADD);
            boolean privDelete = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_ADMINISTRATOR, AppMenu.M2_MENU_SQL_EXECUTE, AppMenu.PRIV_DELETE);
%>
<%
            int iCommand = JSPRequestValue.requestCommand(request);
            String sql = request.getParameter("txtquery");
            ResultSet rs = null;
            String err = "";
            if (sql == null) {
                sql = "";
            }

            if (sql != null && sql.length() > 0) {                
                if (iCommand == 1) {
                    try{
                        CONResultSet dbrs = CONHandler.execQueryResult(sql);
                        rs = dbrs.getResultSet();
                    }catch(Exception e){
                        err = "Check your syntax";
                    }
                } else if (iCommand == 2) {
                    try{
                        int xx = CONHandler.execUpdate(sql);
                    }catch(Exception e){
                        err = "Check your syntax";
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
            
            function executeQuery(idx){
                if(document.frmexecute.txtquery.value !=''){
                    document.frmexecute.command.value =idx;            
                    document.frmexecute.submit();
                }    
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
                  <%@ include file="../main/menu.jsp"%>
                                            <!-- #EndEditable -->
                                        </td>
                                        <td width="100%" valign="top"> 
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                <tr> 
                                                    <td class="title"><!-- #BeginEditable "title" -->
                                           <%
            String navigator = "<font class=\"lvl1\">Administrator</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">SQL Execute</span></font>";
                                           %>
                                           <%@ include file="../main/navigator.jsp"%>
                                                    <!-- #EndEditable --></td>
                                                </tr>
                                                <!--tr> 
                      <td><img src="<%=approot%>/images/title-sp.gif" width="584" height="1"></td> 
                                                </tr-->
                                                <tr> 
                                                    <td class="container" ><!-- #BeginEditable "content" --> 
                                                        <form name="frmexecute" method="post" action="">
                                                            <input type="hidden" name="command" value="">    
                                                            <table width="100%" border="0" >
                                                                <tr height="22">
                                                                    <td width="53%" bgcolor="#CCCCCC" class="fontarial"><b>SQL Execute ... </b></td>
                                                                    <td width="47%">&nbsp;</td>
                                                                </tr>
                                                                <tr>
                                                                    <td valign="top">
                                                                        <label>
                                                                            <textarea name="txtquery" cols="100" rows="15"><%=sql%></textarea>
                                                                    </label>    </td>
                                                                    <td valign="top" class="fontarial">
                                                                        <label>&nbsp;
                                                                            <input type="button" name="Submitxx" value="Execute Query" onclick="javascript:executeQuery(1)" />&nbsp;&nbsp;execute for select <br>
                                                                            <br><br><br><br><br><br>&nbsp;&nbsp;<input type="button" name="Submit" value="Execute Update" onclick="javascript:executeQuery(2)" />
                                                                        </label> 
                                                                    &nbsp;execute for update or delete </td>
                                                                </tr>
                                                                <tr>
                                                                    <td colspan="2" class="fontarial"><b>Result Query ... </b></td>
                                                                </tr>
                                                                <tr>
                                                                    <td colspan="2"><hr width="100%"></td>
                                                                </tr>
                                                                <tr>
                                                                    <td colspan="2">
                                                                        <%
            if (rs != null) {

                int i = 0;
                out.println("<table width=\"100%\" border=\"0\">");
                if (iCommand == 1) {
                    while (rs.next()) {
                        ResultSetMetaData meta = rs.getMetaData();
                        int col = meta.getColumnCount();
                        if (i == 0) {
                            out.println("<tr height=\"20\">");
                            for (int k = 0; k < col; k++) {
                                out.println("<td width=\"10%\" class=\"tablehdr\">");
                                out.println(meta.getColumnName(k + 1));
                                out.println("</td>");
                            }
                            out.println("</tr>");
                        }

                        out.println("<tr>");
                        for (int k = 0; k < col; k++) {
                            out.println("<td class=\"tablecell\">" + rs.getObject(meta.getColumnName(k + 1)) + "</td>");
                        }
                        out.println("</tr>");
                        i++;
                    }
                } else {
                    out.println("<tr>");
                    out.println("<td>OK</td>");
                    out.println("</tr>");
                }
                out.println("</table>");
            }
                                                                    %>    </td>
                                                                </tr>
                                                                <%if(err != null && err.length() > 0){%>
                                                                <tr> 
                                                                    <td><%=err%></td>
                                                                </tr>
                                                                <%}%>
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
