
<%@ page language="java"%>
<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.system.*" %>
<%@ page import = "com.project.ccs.utility.service.salessynch.*" %>
<%@ page import = "com.project.main.db.*" %>  
<%@ page import = "java.util.Date" %>
<%@ include file="../main/javainit.jsp"%> 
<%@ include file="../main/check.jsp"%>
<%
            boolean priv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MENU_ADMINISTRATOR, AppMenu.M2_MENU_SALES_EDITOR);
            boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_ADMINISTRATOR, AppMenu.M2_MENU_SALES_EDITOR, AppMenu.PRIV_VIEW);
            boolean privUpdate = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_ADMINISTRATOR, AppMenu.M2_MENU_SALES_EDITOR, AppMenu.PRIV_UPDATE);
            boolean privAdd = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_ADMINISTRATOR, AppMenu.M2_MENU_SALES_EDITOR, AppMenu.PRIV_ADD);
            boolean privDelete = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_ADMINISTRATOR, AppMenu.M2_MENU_SALES_EDITOR, AppMenu.PRIV_DELETE);
%>
<%
            int iJSPCommand = JSPRequestValue.requestCommand(request);
            ServiceManagerTransaction svc1 = ServiceManagerTransaction.getSingleObject();
            
            String startDisabled1  = "";
            String stopDisabled1 = "";            

            if (iJSPCommand == JSPCommand.START) {                
                svc1.startWatcherUploaderSynch_1();
            } else if (iJSPCommand == JSPCommand.STOP) {
                svc1.stopWatcherUploaderSynch_1();
            }

            boolean running1 = svc1.getStatus();
            if (!running1) {
                startDisabled1 = "";
                stopDisabled1 = "disabled";
            } else {
                startDisabled1 = "disabled";
                stopDisabled1 = "";
            }
%>
<html >
    <!-- #BeginTemplate "/Templates/index.dwt" --> 
    <head>
        <!-- #BeginEditable "javascript" --> 
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <title><%=systemTitle%></title>
        <link href="../css/css.css" rel="stylesheet" type="text/css" />
        <script type="text/javascript">
            <!--
            <%if (!priv || !privView) {%>
            window.location="<%=approot%>/nopriv.jsp";
            <%}%>
            
            function cmdStartMe(){
                document.frmsvc.command.value="<%=JSPCommand.START%>";
                document.frmsvc.action="synchuploadsvc.jsp";
                document.frmsvc.submit();
            }
            
            function cmdStopMe(){
                document.frmsvc.command.value="<%=JSPCommand.STOP%>";
                document.frmsvc.action="synchuploadsvc.jsp";
                document.frmsvc.submit();
            }
            
            
            function MM_swapImgRestore() { //v3.0
                var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
            }
            function MM_preloadImages() { //v3.0
                var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
                    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
                    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
            }
            
            function MM_findObj(n, d) { //v4.01
                var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
                    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
                if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
                for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
                if(!x && d.getElementById) x=d.getElementById(n); return x;
            }
            
            function MM_swapImage() { //v3.0
                var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
                if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
            }
            //-->
        </script>
        <!-- #EndEditable --> 
    </head>
    <body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif')">
        <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
            <tr> 
                <td valign="top"> 
                    <table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
                        <tr> 
                            <td height="96"> <!-- #BeginEditable "header" --> 
            <%@ include file="../main/hmenu.jsp"%>
                            <!-- #EndEditable --> </td>
                        </tr>
                        <tr> 
                            <td valign="top"> 
                                <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
                                    <!--DWLayoutTable-->
                                    <tr> 
                                        <td width="165" height="100%" valign="top" background="<%=approot%>/images/leftbg.gif"> 
                                            <!-- #BeginEditable "menu" --> 
                  <%@ include file="menu.jsp"%>
                                        <!-- #EndEditable --> </td>
                                        <td width="100%" valign="top"> 
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                <tr> 
                                                    <td><!-- #BeginEditable "content" --> 
                                                        <form id="frmsvc" name="frmsvc" method="post" action="">
                                                            <input type="hidden" name="command">
                                                            <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                <tr>
                                                                    <td class="container">
                                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                            <tr> 
                                                                                <td> 
                                                                                    <table width="100%" border="0" cellspacing="1" cellpadding="1" height="17">
                                                                                        <tr valign="bottom"> 
                                                                                            <td width="60%" height="23"><b><font color="#990000" class="lvl1">Administrator 
                                                                                                    </font><font class="tit1">&raquo; 
                                                                                            </font><span class="lvl2">Master Synchronization</span></b></td>
                                                                                            <td width="40%" height="23"> 
                                                                                                <%@ include file = "../main/userpreview.jsp" %>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr > 
                                                                                            <td colspan="2" height="3" background="<%=approot%>/images/line1.gif" ></td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td>&nbsp;</td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td></td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td height="35">Current Status : <b><%=(running1) ? "<font color=\"#006633\">Running</font>" : "<font color=\"#FF0000\">Stoped</font>"%></b></td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td> 
                                                                                    <input type="button" id="btnsvc1start" name="btnsvc1start" value="  Start  " <%=startDisabled1%> onClick="javascript:cmdStartMe()">
                                                                                    <input type="button" id="btnsvc1stop" name="btnsvc1stop" value="  Stop  " <%=stopDisabled1%> onClick="javascript:cmdStopMe()">
                                                                                </td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td>&nbsp;</td>
                                                                            </tr>
                                                                            
                                                                            <tr> 
                                                                                <td>&nbsp;</td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td>&nbsp;</td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td>&nbsp;</td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td>&nbsp;</td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td>&nbsp;</td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td>&nbsp;</td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td>&nbsp;</td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td>&nbsp;</td>
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
            <%@ include file="../main/footer.jsp"%>
                            <!-- #EndEditable --> </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </body>
    <!-- #EndTemplate -->
</html>
