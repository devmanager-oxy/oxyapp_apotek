
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.admin.*" %>
<%@ page import = "com.project.system.*" %>
<%@ page import = "com.project.main.db.*" %>
<%@ page import = "com.project.fms.master.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "com.project.general.*" %>
<%@ include file = "../main/javainit.jsp" %>
<% int appObjCode = 1;%>
<%@ include file = "../main/check.jsp" %>
<%
            boolean priv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_CONFIGURATION);
            boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_CONFIGURATION, AppMenu.PRIV_VIEW);
            boolean privUpdate = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_CONFIGURATION, AppMenu.PRIV_UPDATE);
            boolean privAdd = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_CONFIGURATION, AppMenu.PRIV_ADD);
            boolean privDelete = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_CONFIGURATION, AppMenu.PRIV_DELETE);
%>
<!-- Jsp Block -->

<%
            int iJSPCommand = JSPRequestValue.requestCommand(request);
            int start = JSPRequestValue.requestInt(request, "start");
            int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
            long oidCompany = JSPRequestValue.requestLong(request, "hidden_company_id");

            Company companySess = new Company();
            if (session.getValue("SESS_COMPANY") != null) {
                companySess = (Company) session.getValue("SESS_COMPANY");
            }

            /*variable declaration*/
            int recordToGet = 10;
            String msgString = "";
            int iErrCode = JSPMessage.NONE;
            String whereClause = "";
            String orderClause = "";

            CmdCompany ctrlCompany = new CmdCompany(request);
            JSPLine ctrLine = new JSPLine();
            Vector listCompany = new Vector(1, 1);

            /*switch statement */
            iErrCode = ctrlCompany.action(iJSPCommand, oidCompany);
            /* end switch*/
            JspCompany jspCompany = ctrlCompany.getForm();

            /*count list All Company*/
            int vectSize = DbCompany.getCount(whereClause);

            Company company = ctrlCompany.getCompany();
            msgString = ctrlCompany.getMessage();


            if ((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV) ||
                    (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)) {
                start = ctrlCompany.actionList(iJSPCommand, start, vectSize, recordToGet);
            }
            /* end switch list*/

            /* get record to display */
            listCompany = DbCompany.list(start, recordToGet, whereClause, orderClause);

            /*handle condition if size of record to display = 0 and start > 0 	after delete*/
            if (listCompany.size() < 1 && start > 0) {
                if (vectSize - recordToGet > recordToGet) {
                    start = start - recordToGet;
                } //go to JSPCommand.PREV
                else {
                    start = 0;
                    iJSPCommand = JSPCommand.FIRST;
                    prevJSPCommand = JSPCommand.FIRST; //go to JSPCommand.FIRST
                }
                listCompany = DbCompany.list(start, recordToGet, whereClause, orderClause);
            }

            if (iJSPCommand == JSPCommand.BACK) {
                company = companySess;
            }

            if (iJSPCommand == JSPCommand.SUBMIT && iErrCode == 0) {
                session.putValue("SESS_COMPANY", company);
            }


            Vector v = DbCompany.list(0, 0, "", "");

%>
<html ><!-- #BeginTemplate "/Templates/indexwomenu.dwt" -->
    <head>
        <!-- #BeginEditable "javascript" --> 
        <title><%=systemTitle%></title>
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
        <link href="../css/default.css" rel="stylesheet" type="text/css" />
        <link href="../css/css.css" rel="stylesheet" type="text/css" />
        <script language="JavaScript">
            <%if (!priv || !privView) {%>
            window.location="<%=approot%>/nopriv.jsp";
            <%}%>
            
            <%if (v != null && v.size() > 0) {
                Company xcom = (Company) v.get(0);
%>
    window.location="company_view.jsp?hidden_company_id=<%=xcom.getOID()%>&menu_idx=<%=menuIdx%>";
    <%}%>
    
    <%if (iJSPCommand == JSPCommand.SUBMIT && iErrCode == 0) {%>
    window.location="company_curr.jsp";
    <%}%>
    
    function cmdAdd(){
        document.frmcompany.hidden_company_id.value="0";
        document.frmcompany.command.value="<%=JSPCommand.ADD%>";
        document.frmcompany.prev_command.value="<%=prevJSPCommand%>";
        document.frmcompany.action="company.jsp";
        document.frmcompany.submit();
    }
    
    function cmdAsk(oidCompany){
        document.frmcompany.hidden_company_id.value=oidCompany;
        document.frmcompany.command.value="<%=JSPCommand.ASK%>";
        document.frmcompany.prev_command.value="<%=prevJSPCommand%>";
        document.frmcompany.action="company.jsp";
        document.frmcompany.submit();
    }
    
    function cmdConfirmDelete(oidCompany){
        document.frmcompany.hidden_company_id.value=oidCompany;
        document.frmcompany.command.value="<%=JSPCommand.DELETE%>";
        document.frmcompany.prev_command.value="<%=prevJSPCommand%>";
        document.frmcompany.action="company.jsp";
        document.frmcompany.submit();
    }
    function cmdSave(){
        document.frmcompany.command.value="<%=JSPCommand.SUBMIT%>";
        document.frmcompany.prev_command.value="<%=prevJSPCommand%>";
        document.frmcompany.action="company.jsp";
        document.frmcompany.submit();
    }
    
    function cmdEdit(oidCompany){
        <%if(privUpdate){%>
        document.frmcompany.hidden_company_id.value=oidCompany;
        document.frmcompany.command.value="<%=JSPCommand.EDIT%>";
        document.frmcompany.prev_command.value="<%=prevJSPCommand%>";
        document.frmcompany.action="company.jsp";
        document.frmcompany.submit();
        <%}%>
    }
    
    function cmdCancel(oidCompany){
        document.frmcompany.hidden_company_id.value=oidCompany;
        document.frmcompany.command.value="<%=JSPCommand.EDIT%>";
        document.frmcompany.prev_command.value="<%=prevJSPCommand%>";
        document.frmcompany.action="company.jsp";
        document.frmcompany.submit();
    }
    
    function cmdBack(){
        document.frmcompany.command.value="<%=JSPCommand.BACK%>";
        document.frmcompany.action="company.jsp";
        document.frmcompany.submit();
    }
    
    function cmdListFirst(){
        document.frmcompany.command.value="<%=JSPCommand.FIRST%>";
        document.frmcompany.prev_command.value="<%=JSPCommand.FIRST%>";
        document.frmcompany.action="company.jsp";
        document.frmcompany.submit();
    }
    
    function cmdListPrev(){
        document.frmcompany.command.value="<%=JSPCommand.PREV%>";
        document.frmcompany.prev_command.value="<%=JSPCommand.PREV%>";
        document.frmcompany.action="company.jsp";
        document.frmcompany.submit();
    }
    
    function cmdListNext(){
        document.frmcompany.command.value="<%=JSPCommand.NEXT%>";
        document.frmcompany.prev_command.value="<%=JSPCommand.NEXT%>";
        document.frmcompany.action="company.jsp";
        document.frmcompany.submit();
    }
    
    function cmdListLast(){
        document.frmcompany.command.value="<%=JSPCommand.LAST%>";
        document.frmcompany.prev_command.value="<%=JSPCommand.LAST%>";
        document.frmcompany.action="company.jsp";
        document.frmcompany.submit();
    }
    
        </script>
        <script type="text/javascript">
            <!--
            function MM_findObj(n, d) { //v4.01
                var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
                    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
                if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
                for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
                if(!x && d.getElementById) x=d.getElementById(n); return x;
            }
            function MM_preloadImages() { //v3.0
                var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
                    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
                    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
            }
            function MM_swapImgRestore() { //v3.0
                var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
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
                                        <td width="100%" valign="top"> 
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                <tr> 
                                                    <td class="title"><!-- #BeginEditable "title" -->
                                           <%
            String navigator = "<font class=\"lvl1\">Company Profile</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">Step 1 of 5</span></font>";
                                           %>
                                           <%@ include file="../main/navigator.jsp"%>
                                                    <!-- #EndEditable --></td>
                                                </tr>
                                                <tr> 
                                                    <td><span class="level2"><img src="<%=approot%>/images/title-sp.gif" width="584" height="1"></span></td>
                                                </tr>
                                                <tr> 
                                                    <td><!-- #BeginEditable "content" --> 
                                                        <form name="frmcompany" method ="post" action="">
                                                            <input type="hidden" name="command" value="<%=iJSPCommand%>">
                                                            <input type="hidden" name="vectSize" value="<%=vectSize%>">
                                                            <input type="hidden" name="start" value="<%=start%>">
                                                            <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                                                            <input type="hidden" name="hidden_company_id" value="<%=oidCompany%>">
                                                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr align="left" valign="top"> 
                                                                    <td height="8"  colspan="3">&nbsp;</td>
                                                                </tr>
                                                                <tr align="left" valign="top"> 
                                                                    <td height="8" valign="top" colspan="3"> 
                                                                        <table width="100%" border="0" cellspacing="1" cellpadding="0">
                                                                            <tr align="left"> 
                                                                            <td height="21" valign="top" width="1%">&nbsp;</td>
                                                                            <td height="21" colspan="3">&nbsp;</td>
                                                                            <tr align="left"> 
                                                                            <td height="21" valign="top" width="1%">&nbsp;</td>
                                                                            <td height="21" colspan="3">&nbsp;Please specify 
                                                                            your company name and address, </td>
                                                                            <tr align="left"> 
                                                                            <td height="21" valign="top" width="1%">&nbsp;</td>
                                                                            <td height="21" valign="top" colspan="3">&nbsp;these 
                                                                                data will be appear as your company identification 
                                                                            on all of your archives print out. </td>
                                                                            <tr align="left"> 
                                                                            <td height="21" valign="top" width="1%">&nbsp;</td>
                                                                            <td height="21" valign="top" width="9%">&nbsp;</td>
                                                                            <td height="21" colspan="2" width="90%" valign="top">&nbsp; 
                                                                            <tr align="left"> 
                                                                            <td height="21" valign="top" width="1%">&nbsp;</td>
                                                                            <td height="21" width="9%">&nbsp;Serial Number</td>
                                                                            <td height="21" colspan="2" width="90%" valign="top"> 
                                                                            <input type="text" name="<%=jspCompany.colNames[JspCompany.JSP_SERIAL_NUMBER] %>"  value="<%= company.getSerialNumber() %>" class="formElemen" size="35">
                                                                            <tr align="left"> 
                                                                            <td height="10" valign="top" width="1%"></td>
                                                                            <td height="10" width="9%"></td>
                                                                            <td height="10" colspan="2" width="90%" valign="top"> 
                                                                            <tr align="left"> 
                                                                            <td height="21" valign="top" width="1%">&nbsp;</td>
                                                                            <td height="21" width="9%">&nbsp;Company Name</td>
                                                                            <td height="21" colspan="2" width="90%" valign="top"> 
                                                                            <input type="text" name="<%=jspCompany.colNames[JspCompany.JSP_NAME] %>"  value="<%= company.getName() %>" class="formElemen" size="45">
                                                                            <%= jspCompany.getErrorMsg(jspCompany.JSP_NAME) %> 
                                                                            <tr align="left"> 
                                                                            <td height="21" valign="top" width="1%">&nbsp;</td>
                                                                            <td height="21" width="9%">&nbsp;Address</td>
                                                                            <td height="21" colspan="2" width="90%" valign="top"> 
                                                                            <input type="text" name="<%=jspCompany.colNames[JspCompany.JSP_ADDRESS] %>"  value="<%= company.getAddress() %>" class="formElemen" size="100">
                                                                            <%= jspCompany.getErrorMsg(jspCompany.JSP_ADDRESS) %> 
                                                                            <tr align="left"> 
                                                                            <td height="21" valign="top" width="1%">&nbsp;</td>
                                                                            <td height="21" width="9%">&nbsp;</td>
                                                                            <td height="21" colspan="2" width="90%" valign="top"> 
                                                                            <input type="text" name="<%=jspCompany.colNames[JspCompany.JSP_ADDRESS2] %>"  value="<%= company.getAddress2() %>" class="formElemen" size="100">
                                                                            <tr align="left"> 
                                                                            <td height="21" valign="top" width="1%">&nbsp;</td>
                                                                            <td height="21" width="9%">&nbsp;Contact Person</td>
                                                                            <td height="21" colspan="2" width="90%" valign="top"> 
                                                                            <input type="text" name="<%=jspCompany.colNames[JspCompany.JSP_CONTACT] %>"  value="<%= company.getContact() %>" class="formElemen" size="35">
                                                                            <%= jspCompany.getErrorMsg(jspCompany.JSP_CONTACT) %> 
                                                                            <tr align="left"> 
                                                                            <td height="21" valign="top" width="1%">&nbsp;</td>
                                                                            <td height="21" width="9%">&nbsp;</td>
                                                                            <td height="21" colspan="2" width="90%" valign="top">&nbsp; 
                                                                            <tr align="left"> 
                                                                            <td height="21" valign="top" width="1%">&nbsp;</td>
                                                                            <td height="21" width="9%">&nbsp;</td>
                                                                            <td height="21" colspan="2" width="90%" valign="top">
                                                                                <%if(privUpdate || privAdd){%>
                                                                                <a href="javascript:cmdSave()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('next','','../images/next2.gif',1)"><img src="../images/next.gif" name="next" width="55" height="22" border="1"></a> 
                                                                                <%}%>
                                                                            <tr align="left" > 
                                                                                <td colspan="4" class="command" valign="top">&nbsp; 
                                                                                </td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td width="1%">&nbsp;</td>
                                                                                <td width="9%">&nbsp;</td>
                                                                                <td width="90%">&nbsp;</td>
                                                                            </tr>
                                                                            <tr align="left" > 
                                                                                <td colspan="4" valign="top"> 
                                                                                    <div align="left"></div>
                                                                                </td>
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
