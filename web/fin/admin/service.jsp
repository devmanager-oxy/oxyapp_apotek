
<%-- 
    Document   : service
    Created on : May 29, 2012, 1:48:29 PM
    Author     : Roy Andika
--%>

<%@ page language="java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %> 
<%@ page import = "com.project.admin.*" %>
<%@ page import = "com.project.service.*" %>
<%@ include file = "../main/javainit.jsp" %>
<% int appObjCode = ObjInfo.composeObjCode(ObjInfo.G1_ADMIN, ObjInfo.G2_ADMIN_USER, ObjInfo.OBJ_ADMIN_USER_USER);%>
<%@ include file = "../main/check.jsp" %>
<%
            boolean priv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MENU_ADMINISTRATOR, AppMenu.M2_MENU_ADMINISTRATOR);
            boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_ADMINISTRATOR, AppMenu.M2_MENU_ADMINISTRATOR, AppMenu.PRIV_VIEW);
            boolean privUpdate = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_ADMINISTRATOR, AppMenu.M2_MENU_ADMINISTRATOR, AppMenu.PRIV_UPDATE);
            boolean privAdd = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_ADMINISTRATOR, AppMenu.M2_MENU_ADMINISTRATOR, AppMenu.PRIV_ADD);
            boolean privDelete = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_ADMINISTRATOR, AppMenu.M2_MENU_ADMINISTRATOR, AppMenu.PRIV_DELETE);
%>
<!-- JSP Block -->
<%
            int iCommandServiceReload = JSPRequestValue.requestInt(request, "command_reload");
            long oidServiceReload = JSPRequestValue.requestLong(request, "hidden_reload_id");

            String strServiceType[] = request.getParameterValues(JspServiceConfiguration.fieldNames[JspServiceConfiguration.JSP_SERVICE_TYPE]);
            String strStartTimeHour[] = request.getParameterValues(JspServiceConfiguration.fieldNames[JspServiceConfiguration.JSP_START_TIME] + "_hr");
            String strStartTimeMinutes[] = request.getParameterValues(JspServiceConfiguration.fieldNames[JspServiceConfiguration.JSP_START_TIME] + "_mi");
            String strInterval[] = request.getParameterValues(JspServiceConfiguration.fieldNames[JspServiceConfiguration.JSP_PERIODE]);

            int[] arrCommand = {
                iCommandServiceReload
            };

            long[] arrOidService = {
                oidServiceReload
            };

            if (strServiceType == null || strServiceType.length == 0) {
                strServiceType = new String[1];
                strServiceType[0] = String.valueOf(DbServiceConfiguration.SERVICE_TYPE_RELOAD);
            }

            Vector vectResult = new Vector(1, 1);
            int svcCount = arrOidService.length;
            CmdServiceConfiguration cmdServiceConfiguration = new CmdServiceConfiguration(request);

            vectResult = cmdServiceConfiguration.action(svcCount, arrCommand, arrOidService, strServiceType, strStartTimeHour, strStartTimeMinutes, strInterval);


            ServiceConfiguration serviceReload = new ServiceConfiguration();

            if (vectResult != null && vectResult.size() > 0) {
                serviceReload = (ServiceConfiguration) vectResult.get(0);
                oidServiceReload = serviceReload.getOID();
            }

%>
<!-- End of JSP Block -->
<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
    <head>
        <!-- #BeginEditable "javascript" --> 
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <link href="../css/css.css" rel="stylesheet" type="text/css" />
        <title><%=systemTitle%></title>        
        <script language="JavaScript">           
            
            <%if (!priv || !privView) {%>
            window.location="<%=approot%>/nopriv.jsp";
            <%}%>
            function cmdStartReload(){
                document.frm_service.command_reload.value="<%= String.valueOf(JSPCommand.START) %>";   
                document.frm_service.action="service.jsp";  
                document.frm_service.submit();
            }
            
            function cmdStopReload(){
                document.frm_service.command_reload.value="<%= String.valueOf(JSPCommand.STOP) %>";   
                document.frm_service.action="service.jsp";  
                document.frm_service.submit();
            }
            
            
        </script>
        <%@ include file="../main/hdscript.jsp"%>
        <script language="JavaScript">
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
        
        <!-- #EndEditable -->
    </head>
    <body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','<%=approot%>/images/new2.gif')">
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
            String navigator = "<font class=\"lvl1\">Administrator</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">Service</span></font>";
                                           %>
                                           <%@ include file="../main/navigator.jsp"%>
                                                    <!-- #EndEditable --></td>
                                                </tr>
                                                <!--tr> 
                      <td><img src="<%=approot%>/images/title-sp.gif" width="584" height="1"></td> 
                                                </tr-->
                                                <tr> 
                                                    <td><!-- #BeginEditable "content" --> 
                                                        <form name="frm_service" method="post" action="">                                                       
                                                            <input type="hidden" name="command" value="">
                                                            <input type="hidden" name="command_reload" value="<%=String.valueOf(iCommandServiceReload)%>">
                                                            <input type="hidden" name="hidden_reload_id" value="<%=String.valueOf(oidServiceReload)%>">
                                                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr> 
                                                                    <td class="container"> 
                                                                        
                                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                            <tr> 
                                                                                <td width="65%">&nbsp;</td>
                                                                                <td>&nbsp;</td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td width="65%"><b>. : : RELOAD SERVICE : : .</b></td>
                                                                                <td>&nbsp;</td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td width="65%">&nbsp;</td>
                                                                                <td>&nbsp;</td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td align="left" width="65%"> 
                                                                                Reload Service. </td>
                                                                                <%
            Date dtReload = null;
            try {
                System.out.println("Start Time : " + dtReload);
                if (dtReload == null) {
                    dtReload = new Date();
                }
            } catch (Exception e) {
                dtReload = new Date();
            }

            Reload reload = new Reload();
            switch (iCommandServiceReload) {
                case JSPCommand.START:
                    try {
                        reload.startService();  
                    } catch (Exception e) {
                        System.out.println("exc when serviceReload.startService() : " + e.toString());
                    }
                    break;

                case JSPCommand.STOP:
                    try {
                        reload.stopService();  
                    } catch (Exception e) {
                        System.out.println("exc when serviceReload.stopService : " + e.toString());
                    }
                    break;
            }

            boolean serviceReloadRunning = reload.getStatus();

            String stopStsReload = "";
            String startStsReload = "";

            if (serviceReloadRunning) {
                startStsReload = "disabled=\"true\"";
                stopStsReload = "";
            } else {
                startStsReload = "";
                stopStsReload = "disabled=\"true\"";
            }
                                                                                %>
                                                                                <td align="left"><b><u>Reload Service Configuration</u></b></td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td align="left" width="65%">To run this service, follow steps below :</td>
                                                                                <td align="left">-&nbsp;Start Time&nbsp;: 
                                                                                <%=JSPDate.drawTime(JspServiceConfiguration.fieldNames[JspServiceConfiguration.JSP_START_TIME], dtReload, "formElemen")%></td>
                                                                                
                                                                            </tr>
                                                                            <tr> 
                                                                                <td align="left" width="65%">&nbsp;&nbsp;- 
                                                                                    Click <font color="#0000FF">start</font> 
                                                                                button to start reload service process.</td>
                                                                                <td align="left">-&nbsp;Interval&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;: 
                                                                                    <input type="text" name="<%=JspServiceConfiguration.fieldNames[JspServiceConfiguration.JSP_PERIODE]%>" value="<%=serviceReload.getPeriode()%>" class="formElemen" size="10">
                                                                                    <input type="hidden" name="<%=JspServiceConfiguration.fieldNames[JspServiceConfiguration.JSP_SERVICE_TYPE]%>" value="<%=DbServiceConfiguration.SERVICE_TYPE_RELOAD%>">
                                                                                <i>(minutes)</i></td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td align="left" width="65%">&nbsp;&nbsp;- 
                                                                                    Click <font color="#0000FF">stop</font> 
                                                                                button to stop reload service process.</td>
                                                                                <td align="left">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
                                                                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
                                                                                <input type="button" name="btnSavePresence" value="   Save   " onClick="javascript:cmdUpdatePresence()" class="formElemen" <%=startStsReload%>>
                                                                                       </td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td align="left" width="65%">Reload service status is&nbsp;&nbsp; 
                                                                                    <%
            if (serviceReloadRunning) {
                                                                                    %>
                                                                                    <font color="#009900">Running...</font> 
                                                                                    <%
                                                                                    } else {
                                                                                    %>
                                                                                    <font color="#FF0000">Stopped</font> 
                                                                                    <%
            }
                                                                                    %>
                                                                                </td>
                                                                                <td align="left">&nbsp;</td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td width="65%"> 
                                                                                <input type="button" name="Button4" value="  Start  " onClick="javascript:cmdStartReload()" class="formElemen" <%=startStsReload%>>
                                                                                       <input type="button" name="Submit24" value="  Stop  " onClick="javascript:cmdStopReload()" class="formElemen" <%=stopStsReload%>>
                                                                                       </td>
                                                                                <td>&nbsp; </td>
                                                                            </tr>
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
