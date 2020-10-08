
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.main.db.*" %>
<%@ page import = "com.project.main.entity.*" %>
<%@ page import = "com.project.general.*" %>
<%@ page import = "com.project.admin.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ include file = "../main/javainit.jsp" %>
<% int  appObjCode = 1; %>
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
    public String drawList(Vector objectClass, long kecamatanId, String[] lang) {
        JSPList ctrlist = new JSPList();
        ctrlist.setAreaWidth("50%");
        ctrlist.setListStyle("listgen");
        ctrlist.setTitleStyle("tablehdr");
        ctrlist.setCellStyle("tablecell");
        ctrlist.setCellStyle1("tablecell1");
        ctrlist.setHeaderStyle("tablehdr");

        //ctrlist.addHeader("Kabupaten","25%");
        //ctrlist.addHeader("Kode","20%");
        ctrlist.addHeader(lang[0], "30%");

        ctrlist.setLinkRow(0);
        ctrlist.setLinkSufix("");
        Vector lstData = ctrlist.getData();
        Vector lstLinkData = ctrlist.getLinkData();
        ctrlist.setLinkPrefix("javascript:cmdEdit('");
        ctrlist.setLinkSufix("')");
        ctrlist.reset();
        int index = -1;

        for (int i = 0; i < objectClass.size(); i++) {
            Kecamatan kecamatan = (Kecamatan) objectClass.get(i);
            Vector rowx = new Vector();
            if (kecamatanId == kecamatan.getOID()) {
                index = i;
            }
            /*
            Kabupaten kabupaten = new Kabupaten();
            try{
            kabupaten = DbKabupaten.fetchExc(kecamatan.getKabupatenId());
            }catch(Exception e){
            System.out.println(e.toString());
            }*/

            //rowx.add(kabupaten.getNama());
            //rowx.add(""+kecamatan.getKode());
            rowx.add(kecamatan.getNama());

            lstData.add(rowx);
            lstLinkData.add(String.valueOf(kecamatan.getOID()));

        }


        //return ctrlist.drawList(index);

        return ctrlist.draw(index);
    }

%>
<%
            int iJSPCommand = JSPRequestValue.requestCommand(request);
            int start = JSPRequestValue.requestInt(request, "start");
            int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
            long oidKecamatan = JSPRequestValue.requestLong(request, "hidden_kecamatan_id");

            /*variable declaration*/
            int recordToGet = 10;
            String msgString = "";
            int iErrCode = JSPMessage.NONE;
            String whereClause = "";
            String orderClause = "kabupaten_id, kode";

            CmdKecamatan ctrlKecamatan = new CmdKecamatan(request);
            JSPLine ctrLine = new JSPLine();
            Vector listKecamatan = new Vector(1, 1);

            /*switch statement */
            iErrCode = ctrlKecamatan.action(iJSPCommand, oidKecamatan);
            /* end switch*/
            JspKecamatan jspKecamatan = ctrlKecamatan.getForm();

            /*count list All Kecamatan*/
            int vectSize = DbKecamatan.getCount(whereClause);

            Kecamatan kecamatan = ctrlKecamatan.getKecamatan();
            msgString = ctrlKecamatan.getMessage();

            /*switch list Kecamatan*/
            if ((iJSPCommand == JSPCommand.SAVE) && (iErrCode == JSPMessage.NONE)) {
                //start = DbKecamatan.findLimitStart(kecamatan.getOID(),recordToGet, whereClause);
                oidKecamatan = kecamatan.getOID();
            }

            if ((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV) ||
                    (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)) {
                start = ctrlKecamatan.actionList(iJSPCommand, start, vectSize, recordToGet);
            }
            /* end switch list*/

            /* get record to display */
            listKecamatan = DbKecamatan.list(start, recordToGet, whereClause, orderClause);

            /*handle condition if size of record to display = 0 and start > 0 	after delete*/
            if (listKecamatan.size() < 1 && start > 0) {
                if (vectSize - recordToGet > recordToGet) {
                    start = start - recordToGet;
                } //go to JSPCommand.PREV
                else {
                    start = 0;
                    iJSPCommand = JSPCommand.FIRST;
                    prevJSPCommand = JSPCommand.FIRST; //go to JSPCommand.FIRST
                }
                listKecamatan = DbKecamatan.list(start, recordToGet, whereClause, orderClause);
            }

//out.println(listKecamatan);

            /*** LANG ***/
            String[] langMD = {"Sub-District Name", "Sub-District", "required"};
            String[] langNav = {"Masterdata", "Sub-District"};
            if (lang == LANG_ID) {
                String[] langID = {"Nama Kecamatan", "Kecamatan", "harus diisi"};
                langMD = langID;
                String[] navID = {"Data Induk", "Kecamatan"};
                langNav = navID;
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
            <!--
            <%if (!priv || !privView) {%>
            window.location="<%=approot%>/nopriv.jsp";
            <%}%>
            
            
            function cmdAdd(){
                document.jspkecamatan.hidden_kecamatan_id.value="0";
                document.jspkecamatan.command.value="<%=JSPCommand.ADD%>";
                document.jspkecamatan.prev_command.value="<%=prevJSPCommand%>";
                document.jspkecamatan.action="kecamatan.jsp";
                document.jspkecamatan.submit();
            }
            
            function cmdAsk(oidKecamatan){
                document.jspkecamatan.hidden_kecamatan_id.value=oidKecamatan;
                document.jspkecamatan.command.value="<%=JSPCommand.ASK%>";
                document.jspkecamatan.prev_command.value="<%=prevJSPCommand%>";
                document.jspkecamatan.action="kecamatan.jsp";
                document.jspkecamatan.submit();
            }
            
            function cmdConfirmDelete(oidKecamatan){
                document.jspkecamatan.hidden_kecamatan_id.value=oidKecamatan;
                document.jspkecamatan.command.value="<%=JSPCommand.DELETE%>";
                document.jspkecamatan.prev_command.value="<%=prevJSPCommand%>";
                document.jspkecamatan.action="kecamatan.jsp";
                document.jspkecamatan.submit();
            }
            function cmdSave(){
                document.jspkecamatan.command.value="<%=JSPCommand.SAVE%>";
                document.jspkecamatan.prev_command.value="<%=prevJSPCommand%>";
                document.jspkecamatan.action="kecamatan.jsp";
                document.jspkecamatan.submit();
            }
            
            function cmdEdit(oidKecamatan){
                <%if (privUpdate) {%>
                document.jspkecamatan.hidden_kecamatan_id.value=oidKecamatan;
                document.jspkecamatan.command.value="<%=JSPCommand.EDIT%>";
                document.jspkecamatan.prev_command.value="<%=prevJSPCommand%>";
                document.jspkecamatan.action="kecamatan.jsp";
                document.jspkecamatan.submit();
                <%}%>
            }
            
            function cmdCancel(oidKecamatan){
                document.jspkecamatan.hidden_kecamatan_id.value=oidKecamatan;
                document.jspkecamatan.command.value="<%=JSPCommand.EDIT%>";
                document.jspkecamatan.prev_command.value="<%=prevJSPCommand%>";
                document.jspkecamatan.action="kecamatan.jsp";
                document.jspkecamatan.submit();
            }
            
            function cmdBack(){
                document.jspkecamatan.command.value="<%=JSPCommand.BACK%>";
                document.jspkecamatan.action="kecamatan.jsp";
                document.jspkecamatan.submit();
            }
            
            function cmdListFirst(){
                document.jspkecamatan.command.value="<%=JSPCommand.FIRST%>";
                document.jspkecamatan.prev_command.value="<%=JSPCommand.FIRST%>";
                document.jspkecamatan.action="kecamatan.jsp";
                document.jspkecamatan.submit();
            }
            
            function cmdListPrev(){
                document.jspkecamatan.command.value="<%=JSPCommand.PREV%>";
                document.jspkecamatan.prev_command.value="<%=JSPCommand.PREV%>";
                document.jspkecamatan.action="kecamatan.jsp";
                document.jspkecamatan.submit();
            }
            
            function cmdListNext(){
                document.jspkecamatan.command.value="<%=JSPCommand.NEXT%>";
                document.jspkecamatan.prev_command.value="<%=JSPCommand.NEXT%>";
                document.jspkecamatan.action="kecamatan.jsp";
                document.jspkecamatan.submit();
            }
            
            function cmdListLast(){
                document.jspkecamatan.command.value="<%=JSPCommand.LAST%>";
                document.jspkecamatan.prev_command.value="<%=JSPCommand.LAST%>";
                document.jspkecamatan.action="kecamatan.jsp";
                document.jspkecamatan.submit();
            }
            
            //-------------- script control line -------------------
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
            String navigator = "<font class=\"lvl1\">" + langNav[0] + "</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">" + langNav[1] + "</span></font>";
                                           %>
                                           <%@ include file="../main/navigator.jsp"%>
                                                    <!-- #EndEditable --></td>
                                                </tr>
                                                <!--tr> 
                      <td><img src="<%=approot%>/images/title-sp.gif" width="584" height="1"></td> 
                                                </tr-->
                                                <tr> 
                                                    <td><!-- #BeginEditable "content" --> 
                                                        <form name="jspkecamatan" method ="post" action="">
                                                            <input type="hidden" name="command" value="<%=iJSPCommand%>">
                                                            <input type="hidden" name="vectSize" value="<%=vectSize%>">
                                                            <input type="hidden" name="start" value="<%=start%>">
                                                            <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                                                            <input type="hidden" name="hidden_kecamatan_id" value="<%=oidKecamatan%>">
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
                                                                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                                    <tr> 
                                                                                                        <td width="100%"> 
                                                                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                                                <tr> 
                                                                                                                    <td > 
                                                                                                                        <table width="100%" cellpadding="0" cellspacing="0" border="0">
                                                                                                                            <%
            try {
                if (listKecamatan.size() > 0) {

                    //out.println("ada data : ");

                    //db server selection

                    Vector temp = new Vector();

                    switch (CONHandler.CONSVR_TYPE) {
                        case CONHandler.CONSVR_MYSQL:
                            temp = listKecamatan;
                            break;

                        case CONHandler.CONSVR_POSTGRESQL:
                            temp = listKecamatan;
                            break;

                        case CONHandler.CONSVR_SYBASE:
                            temp = listKecamatan;
                            break;

                        case CONHandler.CONSVR_ORACLE:
                            temp = listKecamatan;
                            break;

                        case CONHandler.CONSVR_MSSQL:
                            int loopInt = 0;
                            if ((start + recordToGet) > listKecamatan.size()) {
                                loopInt = recordToGet - ((start + recordToGet) - listKecamatan.size());
                            } else {
                                loopInt = recordToGet;
                            }

                            int count = 0;
                            for (int i = start; (i < listKecamatan.size() && count < loopInt); i++) {
                                Kecamatan im = (Kecamatan) listKecamatan.get(i);
                                count = count + 1;
                                temp.add(im);
                            }
                            break;

                        default:
                            temp = listKecamatan;
                            break;
                    }

                                                                                                                            %>
                                                                                                                            <tr align="left" valign="top"> 
                                                                                                                                <td height="22" valign="middle" colspan="3"> 
                                                                                                                                <%= drawList(temp, oidKecamatan, langMD)%> </td>
                                                                                                                            </tr>
                                                                                                                            <%  }
            } catch (Exception exc) {
            }%>
                                                                                                                            <tr align="left" valign="top"> 
                                                                                                                                <td height="8" align="left" colspan="3"> 
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
                                                                                                                                        <% ctrLine.setLocationImg(approot + "/images");
            ctrLine.initDefault();
                                                                                                                                        %>
                                                                                                                                    <%=ctrLine.drawImageListLimit(cmd, vectSize, start, recordToGet)%> </span> 
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                            <%
            if ((iJSPCommand != JSPCommand.ADD && iJSPCommand != JSPCommand.ASK && iJSPCommand != JSPCommand.EDIT) && (jspKecamatan.errorSize() < 1)) {
                if (privAdd) {%>
                                                                                                                            <tr align="left" valign="top"> 
                                                                                                                                <td> 
                                                                                                                                    <table cellpadding="0" cellspacing="0" border="0">
                                                                                                                                        <tr> 
                                                                                                                                            <td width="4"><img src="<%=approot%>/images/spacer.gif" width="1" height="1"></td>
                                                                                                                                            <td height="22" valign="middle" colspan="3" width="951"> 
                                                                                                                                            <%if (privAdd) {%>
                                                                                                                                                <a href="javascript:cmdAdd()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new21','','../images/new2.gif',1)"><img src="../images/new.gif" name="new21" width="71" height="22" border="0"></a> 
                                                                                                                                            <%}%>
                                                                                                                                            </td>
                                                                                                                                        </tr>
                                                                                                                                    </table>
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                            <%}
            }%>
                                                                                                                            <tr align="left" valign="top"> 
                                                                                                                                <td> 
                                                                                                                                    <%if ((iJSPCommand == JSPCommand.ADD) || (iJSPCommand == JSPCommand.SAVE) && (jspKecamatan.errorSize() > 0) || (iJSPCommand == JSPCommand.EDIT) || (iJSPCommand == JSPCommand.ASK)) {%>
                                                                                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                                                                        <tr> 
                                                                                                                                            <td colspan="2" class="listtitle"><b><%=oidKecamatan == 0 ? "Entry" : "Edit"%> Kecamatan</b></td>
                                                                                                                                        </tr>
                                                                                                                                        <tr valign="top"> 
                                                                                                                                            <td height="100%" colspan="2"> 
                                                                                                                                                <table border="0" cellspacing="1" cellpadding="0" width="66%" height="67">
                                                                                                                                                    <tr align="left"> 
                                                                                                                                                        <td valign="top" width="17%" height="19">&nbsp;</td>
                                                                                                                                                        <td width="83%" class="comment" valign="top" height="19">
                                                                                                                                                        <font color="#ff0000">* ) <%=langMD[2]%></font></td>
                                                                                                                                                    </tr>
                                                                                                                                                    <!--tr align="left"> 
                                                            <td valign="top" width="17%">Kabupaten</td>
                                                            <td width="83%" height="21" valign="top"> 
                                                              <!--% Vector proKey = new Vector(1,1);
                                                         Vector proValue = new Vector(1,1);
                                                             Vector listKabupaten = DbKabupaten.list(0, 0, "", "");
                                                         for(int i=0; i<listKabupaten.size();i++){
                                                            Kabupaten kabupaten = (Kabupaten)listKabupaten.get(i);
                                                                    proKey.add(kabupaten.getKode()+ " - "+kabupaten.getNama());
                                                                    proValue.add(""+kabupaten.getOID());
                                                             }
                                                             out.println(JSPCombo.draw(jspKecamatan.fieldNames[JspKecamatan.JSP_KABUPATEN_ID],"formElemen",null,""+kecamatan.getKabupatenId(),proValue,proKey));
                                                      %-->
                                                                      <!--%=jspKecamatan.getErrorMsg(JspKecamatan.JSP_KABUPATEN_ID)%-->
                                                                      <!--/td>
                                                          </tr-->
                                                                                                                                                    <tr align="left"> 
                                                                                                                                                        <td width="17%" height="52"><%=langMD[1]%></td>
                                                                                                                                                        <td width="83%" height="52"> 
                                                                                                                                                            <input type="text" name="<%=jspKecamatan.fieldNames[JspKecamatan.JSP_NAMA] %>"  value="<%= (kecamatan.getNama() == null) ? "" : kecamatan.getNama() %>" class="elemenForm" size="70">
                                                                                                                                                            * <%=jspKecamatan.getErrorMsg(JspKecamatan.JSP_NAMA)%> 
                                                                                                                                                        </td>
                                                                                                                                                    </tr>
                                                                                                                                                </table>
                                                                                                                                            </td>
                                                                                                                                        </tr>
                                                                                                                                        <tr align="left" valign="top" > 
                                                                                                                                            <td colspan="2" > 
                                                                                                                                                <%
    ctrLine.setLocationImg(approot + "/images/ctr_line");
    ctrLine.initDefault();
    ctrLine.setTableWidth("40%");
    String scomDel = "javascript:cmdAsk('" + oidKecamatan + "')";
    String sconDelCom = "javascript:cmdConfirmDelete('" + oidKecamatan + "')";
    String scancel = "javascript:cmdEdit('" + oidKecamatan + "')";
    ctrLine.setBackCaption("Back");
    ctrLine.setJSPCommandStyle("buttonlink");
    ctrLine.setDeleteCaption("Delete");
    ctrLine.setSaveCaption("Save");
    ctrLine.setAddCaption("Entry Literatur Baru");

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
    

    //if (privNone) {
    //    ctrLine.setDeleteCaption("Delete");
    //    ctrLine.setSaveCaption("Save");
    //    ctrLine.setAddCaption("Entry Literatur Baru");
    //}

                                                                                                                                                %>
                                                                                                                                                <%= ctrLine.drawImage(iJSPCommand, iErrCode, msgString)%> 
                                                                                                                                            </td>
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
                                                                                                                        </table>
                                                                                                                    </td>
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

