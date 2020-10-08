
<%-- 
    Document   : giro
    Created on : Apr 21, 2014, 12:49:44 PM
    Author     : Roy Andika
--%>

<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.main.db.*" %>
<%@ page import = "com.project.general.*" %>
<%@ include file = "../main/javainit.jsp" %>
<% int appObjCode = 1;%>
<%@ include file = "../main/check.jsp" %>
<%
            boolean priv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_GENERAL);
            boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_GENERAL, AppMenu.PRIV_VIEW);
            boolean privUpdate = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_GENERAL, AppMenu.PRIV_UPDATE);
            boolean privAdd = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_GENERAL, AppMenu.PRIV_ADD);
            boolean privDelete = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_GENERAL, AppMenu.PRIV_DELETE);
%>
<!-- Jsp Block -->
<%!
    public String drawList(int iJSPCommand, JspGiro frmObject, Giro objEntity, Vector objectClass, long giroId) {
        JSPList ctrlist = new JSPList();
        ctrlist.setAreaWidth("700");
        ctrlist.setListStyle("listgen");
        ctrlist.setTitleStyle("tablehdr");
        ctrlist.setCellStyle("tablecell");
        ctrlist.setCellStyle1("tablecell1");
        ctrlist.setHeaderStyle("tablehdr");
        ctrlist.addHeader("Name", "200");        
        ctrlist.addHeader("Giro Account", "");

        ctrlist.setLinkRow(0);
        ctrlist.setLinkSufix("");
        Vector lstData = ctrlist.getData();
        Vector lstLinkData = ctrlist.getLinkData();
        Vector rowx = new Vector(1, 1);
        ctrlist.reset();
        int index = -1;
        
        Vector coas = DbCoa.list(0, 0, "", "code");

        for (int i = 0; i < objectClass.size(); i++) {
            Giro giro = (Giro) objectClass.get(i);
            rowx = new Vector();
            if (giroId == giro.getOID()) {
                index = i;
            }

            if (index == i && (iJSPCommand == JSPCommand.EDIT || iJSPCommand == JSPCommand.ASK)) {

                Vector coaid_value = new Vector(1, 1);
                Vector coaid_key = new Vector(1, 1);
                String sel_coaid = "" + giro.getCoaId();                

                coaid_value.add("- ");
                coaid_key.add("0");
                
                if (coas != null && coas.size() > 0) {
                    for (int ix = 0; ix < coas.size(); ix++) {
                        Coa coa = (Coa) coas.get(ix);

                        String str = "";

                        switch (coa.getLevel()) {
                            case 1:
                                break;
                            case 2:
                                str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                                break;
                            case 3:
                                str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                                break;
                            case 4:
                                str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                                break;
                            case 5:
                                str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                                break;
                        }

                        coaid_key.add("" + coa.getOID());
                        coaid_value.add(str + coa.getCode() + " - " + coa.getName());
                    }
                }
                
                rowx.add("<input type=\"text\" name=\"" + frmObject.colNames[JspGiro.JSP_NAME] + "\" value=\"" + giro.getName() + "\" class=\"formElemen\" size=\"30\">");                
                rowx.add(JSPCombo.draw(frmObject.colNames[JspGiro.JSP_COA_ID], null, sel_coaid, coaid_key, coaid_value, "", "formElemen"));                
            } else {
                rowx.add("<a href=\"javascript:cmdEdit('" + String.valueOf(giro.getOID()) + "')\">" + giro.getName() + "</a>");
                
                Coa objCoa = new Coa();
                try {
                    objCoa = DbCoa.fetchExc(giro.getCoaId());
                } catch (Exception e) {
                }
                if (objCoa.getOID() == 0) {
                    rowx.add("-");
                } else {
                    rowx.add("" + objCoa.getCode() + "-" + objCoa.getName());
                }
            }
            lstData.add(rowx);
        }

        rowx = new Vector();

        if (iJSPCommand == JSPCommand.ADD || (iJSPCommand == JSPCommand.SAVE && frmObject.errorSize() > 0)) {
            Vector coaid_value = new Vector(1, 1);
            Vector coaid_key = new Vector(1, 1);
            String sel_coaid = "" + objEntity.getCoaId();            
            
            coaid_value.add("- ");
            coaid_key.add("0");
            if (coas != null && coas.size() > 0) {
                for (int ix = 0; ix < coas.size(); ix++) {
                    Coa coa = (Coa) coas.get(ix);

                    String str = "";

                    switch (coa.getLevel()) {
                        case 1:
                            break;
                        case 2:
                            str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                            break;
                        case 3:
                            str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                            break;
                        case 4:
                            str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                            break;
                        case 5:
                            str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                            break;
                    }

                    coaid_key.add("" + coa.getOID());
                    coaid_value.add(str + coa.getCode() + " - " + coa.getName());
                }
            }
            rowx.add("<input type=\"text\" name=\"" + frmObject.colNames[JspGiro.JSP_NAME] + "\" value=\"" + objEntity.getName() + "\" class=\"formElemen\" size=\"30\">");            
            rowx.add(JSPCombo.draw(frmObject.colNames[JspGiro.JSP_COA_ID], null, sel_coaid, coaid_key, coaid_value, "", "formElemen"));            
        }

        lstData.add(rowx);

        return ctrlist.draw(index);
    }

%>
<%
            int iJSPCommand = JSPRequestValue.requestCommand(request);
            int start = JSPRequestValue.requestInt(request, "start");
            int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
            long oidGiro = JSPRequestValue.requestLong(request, "hidden_giro_id");

            /*variable declaration*/
            int recordToGet = 10;
            String msgString = "";
            int iErrCode = JSPMessage.NONE;
            String whereClause = "";
            String orderClause = "";

            CmdGiro ctrlGiro = new CmdGiro(request);
            JSPLine ctrLine = new JSPLine();
            Vector listGiro = new Vector(1, 1);

            /*switch statement */
            iErrCode = ctrlGiro.action(iJSPCommand, oidGiro);
            /* end switch*/
            JspGiro jspGiro = ctrlGiro.getForm();

            /*count list All Giro*/
            int vectSize = DbGiro.getCount(whereClause);

            /*switch list Giro*/
            if ((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV) ||
                    (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)) {
                start = ctrlGiro.actionList(iJSPCommand, start, vectSize, recordToGet);
            }
            /* end switch list*/

            Giro giro = ctrlGiro.getGiro();
            msgString = ctrlGiro.getMessage();

            /* get record to display */
            listGiro = DbGiro.list(start, recordToGet, whereClause, orderClause);

            /*handle condition if size of record to display = 0 and start > 0 	after delete*/
            if (listGiro.size() < 1 && start > 0) {
                if (vectSize - recordToGet > recordToGet) {
                    start = start - recordToGet;
                } //go to JSPCommand.PREV
                else {
                    start = 0;
                    iJSPCommand = JSPCommand.FIRST;
                    prevJSPCommand = JSPCommand.FIRST; //go to JSPCommand.FIRST
                }
                listGiro = DbGiro.list(start, recordToGet, whereClause, orderClause);
            }
%>
<html ><!-- #BeginTemplate "/Templates/indexsp.dwt" -->
    <head>
        <!-- #BeginEditable "javascript" --> 
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <title><%=systemTitle%></title>
        <link href="../css/css.css" rel="stylesheet" type="text/css" />
        <script language="JavaScript">
            <%if (!priv || !privView) {%>
            window.location="<%=approot%>/nopriv.jsp";
            <%}%>
            
            function cmdAdd(){
                document.frmgiro.hidden_giro_id.value="0";
                document.frmgiro.command.value="<%=JSPCommand.ADD%>";
                document.frmgiro.prev_command.value="<%=prevJSPCommand%>";
                document.frmgiro.action="giro.jsp";
                document.frmgiro.submit();
            }
            
            function cmdAsk(oidGiro){
                document.frmgiro.hidden_giro_id.value=oidGiro;
                document.frmgiro.command.value="<%=JSPCommand.ASK%>";
                document.frmgiro.prev_command.value="<%=prevJSPCommand%>";
                document.frmgiro.action="giro.jsp";
                document.frmgiro.submit();
            }
            
            function cmdConfirmDelete(oidGiro){
                document.frmgiro.hidden_giro_id.value=oidGiro;
                document.frmgiro.command.value="<%=JSPCommand.DELETE%>";
                document.frmgiro.prev_command.value="<%=prevJSPCommand%>";
                document.frmgiro.action="giro.jsp";
                document.frmgiro.submit();
            }
            
            function cmdSave(){
                document.frmgiro.command.value="<%=JSPCommand.SAVE%>";
                document.frmgiro.prev_command.value="<%=prevJSPCommand%>";
                document.frmgiro.action="giro.jsp";
                document.frmgiro.submit();
            }
            
            function cmdEdit(oidGiro){
                document.frmgiro.hidden_giro_id.value=oidGiro;
                document.frmgiro.command.value="<%=JSPCommand.EDIT%>";
                document.frmgiro.prev_command.value="<%=prevJSPCommand%>";
                document.frmgiro.action="giro.jsp";
                document.frmgiro.submit();
            }
            
            function cmdCancel(oidGiro){
                document.frmgiro.hidden_giro_id.value=oidGiro;
                document.frmgiro.command.value="<%=JSPCommand.EDIT%>";
                document.frmgiro.prev_command.value="<%=prevJSPCommand%>";
                document.frmgiro.action="giro.jsp";
                document.frmgiro.submit();
            }
            
            function cmdBack(){
                document.frmgiro.command.value="<%=JSPCommand.BACK%>";
                document.frmgiro.action="giro.jsp";
                document.frmgiro.submit();
            }
            
            function cmdListFirst(){
                document.frmgiro.command.value="<%=JSPCommand.FIRST%>";
                document.frmgiro.prev_command.value="<%=JSPCommand.FIRST%>";
                document.frmgiro.action="giro.jsp";
                document.frmgiro.submit();
            }
            
            function cmdListPrev(){
                document.frmgiro.command.value="<%=JSPCommand.PREV%>";
                document.frmgiro.prev_command.value="<%=JSPCommand.PREV%>";
                document.frmgiro.action="giro.jsp";
                document.frmgiro.submit();
            }
            
            function cmdListNext(){
                document.frmgiro.command.value="<%=JSPCommand.NEXT%>";
                document.frmgiro.prev_command.value="<%=JSPCommand.NEXT%>";
                document.frmgiro.action="giro.jsp";
                document.frmgiro.submit();
            }
            
            function cmdListLast(){
                document.frmgiro.command.value="<%=JSPCommand.LAST%>";
                document.frmgiro.prev_command.value="<%=JSPCommand.LAST%>";
                document.frmgiro.action="giro.jsp";
                document.frmgiro.submit();
            }
            
            //-------------- script form image -------------------
            
            function cmdDelPict(oidGiro){
                document.frmimage.hidden_giro_id.value=oidGiro;
                document.frmimage.command.value="<%=JSPCommand.POST%>";
                document.frmimage.action="giro.jsp";
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
            String navigator = "<font class=\"lvl1\">Data Induk</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">Giro</span></font>";
                                           %>
                                           <%@ include file="../main/navigator.jsp"%>
                                                    <!-- #EndEditable --></td>
                                                </tr>
                                                <!--tr> 
                      <td><img src="<%=approot%>/imagessp/title-sp.gif" width="584" height="1"></td> 
                                                </tr-->
                                                <tr> 
                                                    <td><!-- #BeginEditable "content" --> 
                                                        <form name="frmgiro" method ="post" action="">
                                                            <input type="hidden" name="command" value="<%=iJSPCommand%>">
                                                            <input type="hidden" name="vectSize" value="<%=vectSize%>">
                                                            <input type="hidden" name="start" value="<%=start%>">
                                                            <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                                                            <input type="hidden" name="hidden_giro_id" value="<%=oidGiro%>">
                                                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr align="left" valign="top"> 
                                                                    <td height="8"  colspan="3" class="container"> 
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
                                                                                <%= drawList(iJSPCommand, jspGiro, giro, listGiro, oidGiro)%> </td>
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
                if (iJSPCommand == JSPCommand.NONE || prevJSPCommand == JSPCommand.NONE) {
                    cmd = JSPCommand.FIRST;
                } else {
                    cmd = prevJSPCommand;
                }
            }
                                                                                        %>
                                                                                        <% ctrLine.setLocationImg(approot + "/images/ctr_line");
            ctrLine.initDefault();
                                                                                        %>
                                                                                <%=ctrLine.drawImageListLimit(cmd, vectSize, start, recordToGet)%> </span> </td>
                                                                            </tr>
                                                                            <%if (iJSPCommand != JSPCommand.EDIT && iJSPCommand != JSPCommand.ADD && iJSPCommand != JSPCommand.ASK && (iErrCode == 0)) {%>
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="22" valign="middle" colspan="3">&nbsp;<a href="javascript:cmdAdd()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new21','','../images/new2.gif',1)"><img src="../images/new.gif" name="new21" width="71" height="22" border="0"></a></td>
                                                                            </tr>
                                                                            <%} else {%>
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="22" valign="middle" colspan="3"> 
                                                                                    <%
    ctrLine.setLocationImg(approot + "/images/ctr_line");
    ctrLine.initDefault();
    ctrLine.setTableWidth("60%");
    String scomDel = "javascript:cmdAsk('" + oidGiro + "')";
    String sconDelCom = "javascript:cmdConfirmDelete('" + oidGiro + "')";
    String scancel = "javascript:cmdEdit('" + oidGiro + "')";
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
                                                                <tr align="left" valign="top"> 
                                                                    <td height="8" valign="middle" width="17%">&nbsp;</td>
                                                                    <td height="8" colspan="2" width="83%">&nbsp; </td>
                                                                </tr>
                                                                <tr align="left" valign="top" > 
                                                                    <td colspan="3" class="command">&nbsp; </td>
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
