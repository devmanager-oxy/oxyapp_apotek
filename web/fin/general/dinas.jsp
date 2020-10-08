
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.main.entity.*" %>
<%@ page import = "com.project.admin.*" %>
<%@ page import = "com.project.general.*" %>
<%@ include file = "../main/javainit.jsp" %>
<% int appObjCode = 1; %>
<%@ include file = "../main/check.jsp" %>
<%@ include file="../calendar/calendarframe.jsp"%>
<%
            boolean priv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_GENERAL);
            boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_GENERAL, AppMenu.PRIV_VIEW);
            boolean privUpdate = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_GENERAL, AppMenu.PRIV_UPDATE);
            boolean privAdd = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_GENERAL, AppMenu.PRIV_ADD);
            boolean privDelete = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_GENERAL, AppMenu.PRIV_DELETE);
%>
<!-- Jsp Block -->
<%!
    public String drawList(int iJSPCommand, JspDinas frmObject, Dinas objEntity, Vector objectClass, long dinasId) {
        JSPList ctrlist = new JSPList();
        ctrlist.setAreaWidth("40%");
        ctrlist.setListStyle("listgen");
        ctrlist.setTitleStyle("tablehdr");
        ctrlist.setCellStyle("tablecell");
        ctrlist.setCellStyle1("tablecell1");
        ctrlist.setHeaderStyle("tablehdr");
        ctrlist.addHeader("Dinas", "30%");

        ctrlist.setLinkRow(0);
        ctrlist.setLinkSufix("");
        Vector lstData = ctrlist.getData();
        Vector lstLinkData = ctrlist.getLinkData();
        Vector rowx = new Vector(1, 1);
        ctrlist.reset();

        int index = -1;

        for (int i = 0; i < objectClass.size(); i++) {
            Dinas dinas = (Dinas) objectClass.get(i);
            rowx = new Vector();
            if (dinasId == dinas.getOID()) {
                index = i;
            }

            if (index == i && (iJSPCommand == JSPCommand.EDIT || iJSPCommand == JSPCommand.ASK)) {
                rowx.add("<input type=\"text\" name=\"" + frmObject.colNames[JspDinas.JSP_NAMA] + "\" value=\"" + dinas.getNama() + "\" class=\"formElemen\" size=\"50\">");
            } else {
                rowx.add("<a href=\"javascript:cmdEdit('" + String.valueOf(dinas.getOID()) + "')\">" + dinas.getNama() + "</a>");
            }

            lstData.add(rowx);
        }

        rowx = new Vector();

        if (iJSPCommand == JSPCommand.ADD || (iJSPCommand == JSPCommand.SAVE && frmObject.errorSize() > 0)) {
            rowx.add("<input type=\"text\" name=\"" + frmObject.colNames[JspDinas.JSP_NAMA] + "\" value=\"" + objEntity.getNama() + "\" class=\"formElemen\" size=\"50\">");
        }

        lstData.add(rowx);

        return ctrlist.draw(index);

    }

%>
<%
            int iJSPCommand = JSPRequestValue.requestCommand(request);
            int start = JSPRequestValue.requestInt(request, "start");
            int previJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
            long oidDinas = JSPRequestValue.requestLong(request, "hidden_dinas_id");

            /*variable declaration*/
            int recordToGet = 10;
            String msgString = "";
            int iErrCode = JSPMessage.NONE;
            String whereClause = "";
            String orderClause = "";

            CmdDinas ctrlDinas = new CmdDinas(request);
            JSPLine ctrLine = new JSPLine();
            Vector listDinas = new Vector(1, 1);

            /*switch statement */
            iErrCode = ctrlDinas.action(iJSPCommand, oidDinas);
            /* end switch*/
            JspDinas jspDinas = ctrlDinas.getForm();

            /*count list All Dinas*/
            int vectSize = DbDinas.getCount(whereClause);

            /*switch list Dinas*/
            if ((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV) ||
                    (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)) {
                start = ctrlDinas.actionList(iJSPCommand, start, vectSize, recordToGet);
            }
            /* end switch list*/

            Dinas dinas = ctrlDinas.getDinas();
            msgString = ctrlDinas.getMessage();

            /* get record to display */
            listDinas = DbDinas.list(start, recordToGet, whereClause, orderClause);

            /*handle condition if size of record to display = 0 and start > 0 	after delete*/
            if (listDinas.size() < 1 && start > 0) {
                if (vectSize - recordToGet > recordToGet) {
                    start = start - recordToGet;
                } //go to JSPCommand.PREV
                else {
                    start = 0;
                    iJSPCommand = JSPCommand.FIRST;
                    previJSPCommand = JSPCommand.FIRST; //go to JSPCommand.FIRST
                }
                listDinas = DbDinas.list(start, recordToGet, whereClause, orderClause);
            }
%>
<html >
    <!-- #BeginTemplate "/Templates/index.dwt" --> 
    <head>
        <!-- #BeginEditable "javascript" --> 
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <link href="../css/default.css" rel="stylesheet" type="text/css" />
        <link href="../css/css.css" rel="stylesheet" type="text/css" />        
        <title><%=systemTitle%></title>
        <script language="JavaScript">
            <%if (!priv || !privView) {%>
            window.location="<%=approot%>/nopriv.jsp";
            <%}%>
            
            function cmdAdd(){
                document.frmdinas.hidden_dinas_id.value="0";
                document.frmdinas.command.value="<%=JSPCommand.ADD%>";
                document.frmdinas.prev_command.value="<%=previJSPCommand%>";
                document.frmdinas.action="dinas.jsp";
                document.frmdinas.submit();
            }
            
            function cmdAsk(oidDinas){
                document.frmdinas.hidden_dinas_id.value=oidDinas;
                document.frmdinas.command.value="<%=JSPCommand.ASK%>";
                document.frmdinas.prev_command.value="<%=previJSPCommand%>";
                document.frmdinas.action="dinas.jsp";
                document.frmdinas.submit();
            }
            
            function cmdConfirmDelete(oidDinas){
                document.frmdinas.hidden_dinas_id.value=oidDinas;
                document.frmdinas.command.value="<%=JSPCommand.DELETE%>";
                document.frmdinas.prev_command.value="<%=previJSPCommand%>";
                document.frmdinas.action="dinas.jsp";
                document.frmdinas.submit();
            }
            
            function cmdSave(){
                document.frmdinas.command.value="<%=JSPCommand.SAVE%>";
                document.frmdinas.prev_command.value="<%=previJSPCommand%>";
                document.frmdinas.action="dinas.jsp";
                document.frmdinas.submit();
            }
            
            function cmdEdit(oidDinas){
                <%if (privUpdate) {%>
                document.frmdinas.hidden_dinas_id.value=oidDinas;
                document.frmdinas.command.value="<%=JSPCommand.EDIT%>";
                document.frmdinas.prev_command.value="<%=previJSPCommand%>";
                document.frmdinas.action="dinas.jsp";
                document.frmdinas.submit();
                <%}%>   
            }
            
            function cmdCancel(oidDinas){
                document.frmdinas.hidden_dinas_id.value=oidDinas;
                document.frmdinas.command.value="<%=JSPCommand.EDIT%>";
                document.frmdinas.prev_command.value="<%=previJSPCommand%>";
                document.frmdinas.action="dinas.jsp";
                document.frmdinas.submit();
            }
            
            function cmdBack(){
                document.frmdinas.command.value="<%=JSPCommand.BACK%>";
                document.frmdinas.action="dinas.jsp";
                document.frmdinas.submit();
            }
            
            function cmdListFirst(){
                document.frmdinas.command.value="<%=JSPCommand.FIRST%>";
                document.frmdinas.prev_command.value="<%=JSPCommand.FIRST%>";
                document.frmdinas.action="dinas.jsp";
                document.frmdinas.submit();
            }
            
            function cmdListPrev(){
                document.frmdinas.command.value="<%=JSPCommand.PREV%>";
                document.frmdinas.prev_command.value="<%=JSPCommand.PREV%>";
                document.frmdinas.action="dinas.jsp";
                document.frmdinas.submit();
            }
            
            function cmdListNext(){
                document.frmdinas.command.value="<%=JSPCommand.NEXT%>";
                document.frmdinas.prev_command.value="<%=JSPCommand.NEXT%>";
                document.frmdinas.action="dinas.jsp";
                document.frmdinas.submit();
            }
            
            function cmdListLast(){
                document.frmdinas.command.value="<%=JSPCommand.LAST%>";
                document.frmdinas.prev_command.value="<%=JSPCommand.LAST%>";
                document.frmdinas.action="dinas.jsp";
                document.frmdinas.submit();
            }
            
            //-------------- script form image -------------------
            
            function cmdDelPict(oidDinas){
                document.frmimage.hidden_dinas_id.value=oidDinas;
                document.frmimage.command.value="<%=JSPCommand.POST%>";
                document.frmimage.action="dinas.jsp";
                document.frmimage.submit();
            }
            
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
                                        <td width="165" height="100%" valign="top" style="background:url(<%=approot%>/images/leftmenu-bg.gif) repeat-y"> 
                                            <!-- #BeginEditable "menu" --> 
                  <%@ include file="../main/menu.jsp"%>
                                        <!-- #EndEditable --> </td>
                                        <td width="100%" valign="top"> 
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                <tr> 
                                                    <td class="title"><!-- #BeginEditable "title" -->
                                           <%
            String navigator = "<font class=\"lvl1\">Master</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">List Dinas</span></font>";
                                           %>
                                           <%@ include file="../main/navigator.jsp"%>
                                                    <!-- #EndEditable --></td>
                                                </tr>
                                                <!--tr> 
                      <td><img src="<%=approot%>/images/title-sp.gif" width="584" height="1"></td> 
                                                </tr-->
                                                <tr> 
                                                    <td><!-- #BeginEditable "content" --> 
                                                        <form name="frmdinas" method ="post" action="">
                                                            <input type="hidden" name="command" value="<%=iJSPCommand%>">
                                                            <input type="hidden" name="vectSize" value="<%=vectSize%>">
                                                            <input type="hidden" name="start" value="<%=start%>">
                                                            <input type="hidden" name="prev_command" value="<%=previJSPCommand%>">
                                                            <input type="hidden" name="hidden_dinas_id" value="<%=oidDinas%>">
                                                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                            <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                <tr>
                                                                    <td class="container">
                                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="8"> 
                                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="8" valign="middle" colspan="3">&nbsp; 
                                                                                            </td>
                                                                                        </tr>
                                                                                        <%
            try {
                                                                                        %>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="22" valign="middle" colspan="3"> 
                                                                                            <%= drawList(iJSPCommand, jspDinas, dinas, listDinas, oidDinas)%> </td>
                                                                                        </tr>
                                                                                        <%
            } catch (Exception exc) {
            }%>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="8" align="left" colspan="3" class="command"> 
                                                                                                <span class="command"> 
                                                                                                    <%
            int cmd = 0;
            if ((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV) ||
                    (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)) {
                cmd = iJSPCommand;
            } else {
                if (iJSPCommand == JSPCommand.NONE || previJSPCommand == JSPCommand.NONE) {
                    cmd = JSPCommand.FIRST;
                } else {
                    cmd = previJSPCommand;
                }
            }
                                                                                                    %>
                                                                                                    <% ctrLine.setLocationImg(approot + "/images/ctr_line");
            ctrLine.initDefault();
                                                                                                    %>
                                                                                            <%=ctrLine.drawImageListLimit(cmd, vectSize, start, recordToGet)%> </span> </td>
                                                                                        </tr>
                                                                                        
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="10" valign="middle" colspan="3">&nbsp;</td>
                                                                                        </tr>
                                                                                        
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                            <%if (iJSPCommand != JSPCommand.EDIT && iJSPCommand != JSPCommand.ADD && iJSPCommand != JSPCommand.ASK && (iErrCode == 0)) {%>
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="8" valign="middle" width="17%">
                                                                                    <%if (privAdd) {%>
                                                                                        <a href="javascript:cmdAdd()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new21','','../images/new2.gif',1)"><img src="../images/new.gif" name="new21" width="71" height="22" border="0"></a> 
                                                                                    <%}%>
                                                                                </td>
                                                                            </tr>
                                                                            <%} else {%>
                                                                            <tr align="left" valign="top" > 
                                                                                <td class="command"> 
                                                                                    <%
    ctrLine.setLocationImg(approot + "/images/ctr_line");
    ctrLine.initDefault();
    ctrLine.setTableWidth("80%");
    String scomDel = "javascript:cmdAsk('" + oidDinas + "')";
    String sconDelCom = "javascript:cmdConfirmDelete('" + oidDinas + "')";
    String scancel = "javascript:cmdEdit('" + oidDinas + "')";
    ctrLine.setBackCaption("Back to List");
    ctrLine.setJSPCommandStyle("buttonlink");

    if (privDelete) {
        ctrLine.setConfirmDelJSPCommand(sconDelCom);
        ctrLine.setDeleteJSPCommand(scomDel);
        ctrLine.setEditJSPCommand(scancel);
    } else {
        ctrLine.setConfirmDelCaption("");
        ctrLine.setDeleteCaption("");
        ctrLine.setEditCaption("");
    }

    if (privAdd == false && privUpdate == false) {
        ctrLine.setSaveCaption("");
    }

    if (privAdd == false) {
        ctrLine.setAddCaption("");
    }
                                                                                    %>
                                                                                <%= ctrLine.drawImage(iJSPCommand, iErrCode, msgString)%> </td>
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
