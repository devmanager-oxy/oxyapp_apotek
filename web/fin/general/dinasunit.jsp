
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
    public String drawList(Vector objectClass, long dinasUnitId) {
        JSPList ctrlist = new JSPList();
        ctrlist.setAreaWidth("50%");
        ctrlist.setListStyle("listgen");
        ctrlist.setTitleStyle("tablehdr");
        ctrlist.setCellStyle("tablecell");
        ctrlist.setCellStyle1("tablecell1");
        ctrlist.setHeaderStyle("tablehdr");
        ctrlist.addHeader("Dinas", "50%");
        ctrlist.addHeader("Unit", "50%");

        ctrlist.setLinkRow(0);
        ctrlist.setLinkSufix("");
        Vector lstData = ctrlist.getData();
        Vector lstLinkData = ctrlist.getLinkData();
        ctrlist.setLinkPrefix("javascript:cmdEdit('");
        ctrlist.setLinkSufix("')");
        ctrlist.reset();
        int index = -1;

        for (int i = 0; i < objectClass.size(); i++) {
            DinasUnit dinasUnit = (DinasUnit) objectClass.get(i);
            Vector rowx = new Vector();
            if (dinasUnitId == dinasUnit.getOID()) {
                index = i;
            }

            Dinas din = new Dinas();
            try {
                din = DbDinas.fetchExc(dinasUnit.getDinasId());
            } catch (Exception e) {
                System.out.println("exception : " + e.toString());
            }

            rowx.add(din.getNama());

            rowx.add(dinasUnit.getNama());

            lstData.add(rowx);
            lstLinkData.add(String.valueOf(dinasUnit.getOID()));
        }

        return ctrlist.draw(index);
    }

%>
<%
            int iJSPCommand = JSPRequestValue.requestCommand(request);
            int start = JSPRequestValue.requestInt(request, "start");
            int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
            long oidDinasUnit = JSPRequestValue.requestLong(request, "hidden_dinas_unit_id");

            /*variable declaration*/
            int recordToGet = 10;
            String msgString = "";
            int iErrCode = JSPMessage.NONE;
            String whereClause = "";
            String orderClause = "";

            CmdDinasUnit ctrlDinasUnit = new CmdDinasUnit(request);
            JSPLine ctrLine = new JSPLine();
            Vector listDinasUnit = new Vector(1, 1);

            /*switch statement */
            iErrCode = ctrlDinasUnit.action(iJSPCommand, oidDinasUnit);
            /* end switch*/
            JspDinasUnit jspDinasUnit = ctrlDinasUnit.getForm();

            /*count list All DinasUnit*/
            int vectSize = DbDinasUnit.getCount(whereClause);

            DinasUnit dinasUnit = ctrlDinasUnit.getDinasUnit();
            msgString = ctrlDinasUnit.getMessage();


            if ((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV) ||
                    (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)) {
                start = ctrlDinasUnit.actionList(iJSPCommand, start, vectSize, recordToGet);
            }
            /* end switch list*/

            /* get record to display */
            listDinasUnit = DbDinasUnit.list(start, recordToGet, whereClause, orderClause);

            /*handle condition if size of record to display = 0 and start > 0 	after delete*/
            if (listDinasUnit.size() < 1 && start > 0) {
                if (vectSize - recordToGet > recordToGet) {
                    start = start - recordToGet;
                } //go to JSPCommand.PREV
                else {
                    start = 0;
                    iJSPCommand = JSPCommand.FIRST;
                    prevJSPCommand = JSPCommand.FIRST; //go to JSPCommand.FIRST
                }
                listDinasUnit = DbDinasUnit.list(start, recordToGet, whereClause, orderClause);
            }
%>
<html >
    <!-- #BeginTemplate "/Templates/index.dwt" --> 
    <head>
        <!-- #BeginEditable "javascript" --> 
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <link href="../css/css.css" rel="stylesheet" type="text/css" />
        <title><%=systemTitle%></title>
        <script language="JavaScript">
            <%if (!priv || !privView) {%>
            window.location="<%=approot%>/nopriv.jsp";
            <%}%>
            
            function cmdAdd(){
                document.frmdinasunit.hidden_dinas_unit_id.value="0";
                document.frmdinasunit.command.value="<%=JSPCommand.ADD%>";
                document.frmdinasunit.prev_command.value="<%=prevJSPCommand%>";
                document.frmdinasunit.action="dinasunit.jsp";
                document.frmdinasunit.submit();
            }
            
            function cmdAsk(oidDinasUnit){
                document.frmdinasunit.hidden_dinas_unit_id.value=oidDinasUnit;
                document.frmdinasunit.command.value="<%=JSPCommand.ASK%>";
                document.frmdinasunit.prev_command.value="<%=prevJSPCommand%>";
                document.frmdinasunit.action="dinasunit.jsp";
                document.frmdinasunit.submit();
            }
            
            function cmdConfirmDelete(oidDinasUnit){
                document.frmdinasunit.hidden_dinas_unit_id.value=oidDinasUnit;
                document.frmdinasunit.command.value="<%=JSPCommand.DELETE%>";
                document.frmdinasunit.prev_command.value="<%=prevJSPCommand%>";
                document.frmdinasunit.action="dinasunit.jsp";
                document.frmdinasunit.submit();
            }
            function cmdSave(){
                document.frmdinasunit.command.value="<%=JSPCommand.SAVE%>";
                document.frmdinasunit.prev_command.value="<%=prevJSPCommand%>";
                document.frmdinasunit.action="dinasunit.jsp";
                document.frmdinasunit.submit();
            }
            
            function cmdEdit(oidDinasUnit){
                <%if (privUpdate) {%>
                document.frmdinasunit.hidden_dinas_unit_id.value=oidDinasUnit;
                document.frmdinasunit.command.value="<%=JSPCommand.EDIT%>";
                document.frmdinasunit.prev_command.value="<%=prevJSPCommand%>";
                document.frmdinasunit.action="dinasunit.jsp";
                document.frmdinasunit.submit();
                <%}%>
            }
            
            function cmdCancel(oidDinasUnit){
                document.frmdinasunit.hidden_dinas_unit_id.value=oidDinasUnit;
                document.frmdinasunit.command.value="<%=JSPCommand.EDIT%>";
                document.frmdinasunit.prev_command.value="<%=prevJSPCommand%>";
                document.frmdinasunit.action="dinasunit.jsp";
                document.frmdinasunit.submit();
            }
            
            function cmdBack(){
                document.frmdinasunit.command.value="<%=JSPCommand.BACK%>";
                document.frmdinasunit.action="dinasunit.jsp";
                document.frmdinasunit.submit();
            }
            
            function cmdListFirst(){
                document.frmdinasunit.command.value="<%=JSPCommand.FIRST%>";
                document.frmdinasunit.prev_command.value="<%=JSPCommand.FIRST%>";
                document.frmdinasunit.action="dinasunit.jsp";
                document.frmdinasunit.submit();
            }
            
            function cmdListPrev(){
                document.frmdinasunit.command.value="<%=JSPCommand.PREV%>";
                document.frmdinasunit.prev_command.value="<%=JSPCommand.PREV%>";
                document.frmdinasunit.action="dinasunit.jsp";
                document.frmdinasunit.submit();
            }
            
            function cmdListNext(){
                document.frmdinasunit.command.value="<%=JSPCommand.NEXT%>";
                document.frmdinasunit.prev_command.value="<%=JSPCommand.NEXT%>";
                document.frmdinasunit.action="dinasunit.jsp";
                document.frmdinasunit.submit();
            }
            
            function cmdListLast(){
                document.frmdinasunit.command.value="<%=JSPCommand.LAST%>";
                document.frmdinasunit.prev_command.value="<%=JSPCommand.LAST%>";
                document.frmdinasunit.action="dinasunit.jsp";
                document.frmdinasunit.submit();
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
            String navigator = "<font class=\"lvl1\">Master</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">Unit Dinas</span></font>";
                                           %>
                                           <%@ include file="../main/navigator.jsp"%>
                                                    <!-- #EndEditable --></td>
                                                </tr>
                                                <!--tr> 
                      <td><img src="<%=approot%>/images/title-sp.gif" width="584" height="1"></td> 
                                                </tr-->
                                                <tr> 
                                                    <td><!-- #BeginEditable "content" --> 
                                                        <form name="frmdinasunit" method ="post" action="">
                                                            <input type="hidden" name="command" value="<%=iJSPCommand%>">
                                                            <input type="hidden" name="vectSize" value="<%=vectSize%>">
                                                            <input type="hidden" name="start" value="<%=start%>">
                                                            <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                                                            <input type="hidden" name="hidden_dinas_unit_id" value="<%=oidDinasUnit%>">
                                                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                            <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                <tr>
                                                                    <td class="container"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="8"  colspan="3"> 
                                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="8" valign="middle" colspan="3">&nbsp; 
                                                                                            </td>
                                                                                        </tr>
                                                                                        <%
            try {
                if (listDinasUnit != null && listDinasUnit.size() > 0) {
                                                                                        %>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="22" valign="middle" colspan="3"> 
                                                                                            <%= drawList(listDinasUnit, oidDinasUnit)%> </td>
                                                                                        </tr>
                                                                                        <%  }
            } catch (Exception exc) {
                out.println(exc.toString());
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
                                                                                            <td height="8" valign="middle" width="17%">
                                                                                                <%if (privAdd) {%>
                                                                                                <a href="javascript:cmdAdd()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new21','','../images/new2.gif',1)"><img src="../images/new.gif" name="new21" width="71" height="22" border="0"></a> 
                                                                                                <%}%>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <%}%>
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="8" valign="middle" colspan="3"> 
                                                                                    <%if ((iJSPCommand == JSPCommand.ADD) || (iJSPCommand == JSPCommand.SAVE) && (jspDinasUnit.errorSize() > 0) || (iJSPCommand == JSPCommand.EDIT) || (iJSPCommand == JSPCommand.ASK)) {%>
                                                                                    <table width="100%" border="0" cellspacing="1" cellpadding="0">
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="21" valign="middle" width="17%">&nbsp;</td>
                                                                                            <td height="21" colspan="2" width="83%" class="comment">*)= 
                                                                                            required</td>
                                                                                        </tr>
                                                                                        <tr align="left" valign="top"> 
                                                                                        <td height="21" valign="top" width="17%">Dinas 
                                                                                        Id</td>
                                                                                        <td height="21" colspan="2" width="83%"> 
                                                                                        <%
    Vector dinasid_value = new Vector(1, 1);
    Vector dinasid_key = new Vector(1, 1);
    String sel_dinasid = "" + dinasUnit.getDinasId();
    Vector dinasx = DbDinas.list(0, 0, "", "");
    if (dinasx != null && dinasx.size() > 0) {
        for (int i = 0; i < dinasx.size(); i++) {
            Dinas din = (Dinas) dinasx.get(i);
            dinasid_key.add("" + din.getOID());
            dinasid_value.add(din.getNama());
        }
    }
                                                                                        %>
                                                                                        <%= JSPCombo.draw(jspDinasUnit.colNames[JspDinasUnit.JSP_DINAS_ID], null, sel_dinasid, dinasid_key, dinasid_value, "", "formElemen") %> * <%= jspDinasUnit.getErrorMsg(JspDinasUnit.JSP_DINAS_ID) %> 
                                                                                        <tr align="left" valign="top"> 
                                                                                        <td height="21" valign="top" width="17%">Nama</td>
                                                                                        <td height="21" colspan="2" width="83%"> 
                                                                                        <input type="text" name="<%=jspDinasUnit.colNames[JspDinasUnit.JSP_NAMA] %>"  value="<%= dinasUnit.getNama() %>" class="formElemen">
                                                                                        * <%= jspDinasUnit.getErrorMsg(JspDinasUnit.JSP_NAMA) %> 
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="8" valign="middle" width="17%">&nbsp;</td>
                                                                                            <td height="8" colspan="2" width="83%">&nbsp; </td>
                                                                                        </tr>
                                                                                        <tr align="left" valign="top" > 
                                                                                            <td colspan="3" class="command"> 
                                                                                                <%
    ctrLine.setLocationImg(approot + "/images/ctr_line");
    ctrLine.initDefault();
    ctrLine.setTableWidth("80%");
    String scomDel = "javascript:cmdAsk('" + oidDinasUnit + "')";
    String sconDelCom = "javascript:cmdConfirmDelete('" + oidDinasUnit + "')";
    String scancel = "javascript:cmdEdit('" + oidDinasUnit + "')";
    ctrLine.setBackCaption("Back to List");
    ctrLine.setJSPCommandStyle("buttonlink");
    ctrLine.setDeleteCaption("Delete");
    ctrLine.setSaveCaption("Save");
    ctrLine.setAddCaption("");

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
                                                                                        <tr> 
                                                                                            <td width="13%">&nbsp;</td>
                                                                                            <td width="87%">&nbsp;</td>
                                                                                        </tr>
                                                                                        <tr align="left" valign="top" > 
                                                                                            <td colspan="3">
                                                                                                <div align="left"></div>
                                                                                            </td>
                                                                                        </tr>
                                                                                    </table>
                                                                                    <%}%>
                                                                                </td>
                                                                            </tr>
                                                                    </table></td>
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
