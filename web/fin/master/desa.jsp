
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
    public String drawList(Vector objectClass, long desaId, String[] lang) {
        JSPList ctrlist = new JSPList();
        ctrlist.setAreaWidth("60%");
        ctrlist.setListStyle("listgen");
        ctrlist.setTitleStyle("tablehdr");
        ctrlist.setCellStyle("tablecell");
        ctrlist.setCellStyle1("tablecell1");
        ctrlist.setHeaderStyle("tablehdr");

        ctrlist.addHeader(lang[0], "25%");
        //ctrlist.addHeader("Kode","10%");
        ctrlist.addHeader(lang[1], "25%");

        ctrlist.setLinkRow(1);
        ctrlist.setLinkSufix("");
        Vector lstData = ctrlist.getData();
        Vector lstLinkData = ctrlist.getLinkData();
        ctrlist.setLinkPrefix("javascript:cmdEdit('");
        ctrlist.setLinkSufix("')");
        ctrlist.reset();
        int index = -1;

        for (int i = 0; i < objectClass.size(); i++) {
            Desa desa = (Desa) objectClass.get(i);
            Vector rowx = new Vector();
            if (desaId == desa.getOID()) {
                index = i;
            }

            Kecamatan kecamatan = new Kecamatan();
            try {
                kecamatan = DbKecamatan.fetchExc(desa.getKecamatanId());
            } catch (Exception e) {
                System.out.println(e.toString());
            }

            rowx.add(kecamatan.getNama());
            //rowx.add(""+desa.getKode());
            rowx.add(desa.getNama());

            lstData.add(rowx);
            lstLinkData.add(String.valueOf(desa.getOID()));

        }


        //return ctrlist.drawList(index);

        return ctrlist.draw(index);
    }

%>
<%
            int iJSPCommand = JSPRequestValue.requestCommand(request);
            int start = JSPRequestValue.requestInt(request, "start");
            int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
            long oidDesa = JSPRequestValue.requestLong(request, "hidden_desa_id");

            /*variable declaration*/
            int recordToGet = 10;
            String msgString = "";
            int iErrCode = JSPMessage.NONE;
            String whereClause = "";
            String orderClause = "kecamatan_id, kode";

            CmdDesa ctrlDesa = new CmdDesa(request);
            JSPLine ctrLine = new JSPLine();
            Vector listDesa = new Vector(1, 1);

            /*switch statement */
            iErrCode = ctrlDesa.action(iJSPCommand, oidDesa);
            /* end switch*/
            JspDesa jspDesa = ctrlDesa.getForm();

            /*count list All Kecamatan*/
            int vectSize = DbDesa.getCount(whereClause);

            Desa desa = ctrlDesa.getDesa();
            msgString = ctrlDesa.getMessage();

            /*switch list Kecamatan*/
            if ((iJSPCommand == JSPCommand.SAVE) && (iErrCode == JSPMessage.NONE)) {
                //start = DbKecamatan.findLimitStart(kecamatan.getOID(),recordToGet, whereClause);
                oidDesa = desa.getOID();
            }

            if ((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV) ||
                    (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)) {
                start = ctrlDesa.actionList(iJSPCommand, start, vectSize, recordToGet);
            }
            /* end switch list*/

            /* get record to display */
            listDesa = DbDesa.list(start, recordToGet, whereClause, orderClause);

            /*handle condition if size of record to display = 0 and start > 0 	after delete*/
            if (listDesa.size() < 1 && start > 0) {
                if (vectSize - recordToGet > recordToGet) {
                    start = start - recordToGet;
                } //go to JSPCommand.PREV
                else {
                    start = 0;
                    iJSPCommand = JSPCommand.FIRST;
                    prevJSPCommand = JSPCommand.FIRST; //go to JSPCommand.FIRST
                }
                listDesa = DbKecamatan.list(start, recordToGet, whereClause, orderClause);
            }

//out.println(listDesa);

            /*** LANG ***/
            String[] langMD = {"Sub-District", "Village Name", "Village", "required"};
            String[] langNav = {"Masterdata", "Village Area"};
            if (lang == LANG_ID) {
                String[] langID = {"Kecamatan", "Nama Desa", "Data Desa", "harus diisi"};
                langMD = langID;
                String[] navID = {"Data Induk", "Desa"};
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
            
            <%if (!priv || !privView) {%>
            window.location="<%=approot%>/nopriv.jsp";
            <%}%>
            
            
            function cmdAdd(){
                document.jspkecamatan.hidden_desa_id.value="0";
                document.jspkecamatan.command.value="<%=JSPCommand.ADD%>";
                document.jspkecamatan.prev_command.value="<%=prevJSPCommand%>";
                document.jspkecamatan.action="desa.jsp";
                document.jspkecamatan.submit();
            }
            
            function cmdAsk(oidDesa){
                document.jspkecamatan.hidden_desa_id.value=oidDesa;
                document.jspkecamatan.command.value="<%=JSPCommand.ASK%>";
                document.jspkecamatan.prev_command.value="<%=prevJSPCommand%>";
                document.jspkecamatan.action="desa.jsp";
                document.jspkecamatan.submit();
            }
            
            function cmdConfirmDelete(oidDesa){
                document.jspkecamatan.hidden_desa_id.value=oidDesa;
                document.jspkecamatan.command.value="<%=JSPCommand.DELETE%>";
                document.jspkecamatan.prev_command.value="<%=prevJSPCommand%>";
                document.jspkecamatan.action="desa.jsp";
                document.jspkecamatan.submit();
            }
            function cmdSave(){
                document.jspkecamatan.command.value="<%=JSPCommand.SAVE%>";
                document.jspkecamatan.prev_command.value="<%=prevJSPCommand%>";
                document.jspkecamatan.action="desa.jsp";
                document.jspkecamatan.submit();
            }
            
            function cmdEdit(oidDesa){
                <%if (privUpdate) {%>
                document.jspkecamatan.hidden_desa_id.value=oidDesa;
                document.jspkecamatan.command.value="<%=JSPCommand.EDIT%>";
                document.jspkecamatan.prev_command.value="<%=prevJSPCommand%>";
                document.jspkecamatan.action="desa.jsp";
                document.jspkecamatan.submit();
                <%}%>
            }
            
            function cmdCancel(oidDesa){
                document.jspkecamatan.hidden_desa_id.value=oidDesa;
                document.jspkecamatan.command.value="<%=JSPCommand.EDIT%>";
                document.jspkecamatan.prev_command.value="<%=prevJSPCommand%>";
                document.jspkecamatan.action="desa.jsp";
                document.jspkecamatan.submit();
            }
            
            function cmdBack(){
                document.jspkecamatan.command.value="<%=JSPCommand.BACK%>";
                document.jspkecamatan.action="desa.jsp";
                document.jspkecamatan.submit();
            }
            
            function cmdListFirst(){
                document.jspkecamatan.command.value="<%=JSPCommand.FIRST%>";
                document.jspkecamatan.prev_command.value="<%=JSPCommand.FIRST%>";
                document.jspkecamatan.action="desa.jsp";
                document.jspkecamatan.submit();
            }
            
            function cmdListPrev(){
                document.jspkecamatan.command.value="<%=JSPCommand.PREV%>";
                document.jspkecamatan.prev_command.value="<%=JSPCommand.PREV%>";
                document.jspkecamatan.action="desa.jsp";
                document.jspkecamatan.submit();
            }
            
            function cmdListNext(){
                document.jspkecamatan.command.value="<%=JSPCommand.NEXT%>";
                document.jspkecamatan.prev_command.value="<%=JSPCommand.NEXT%>";
                document.jspkecamatan.action="desa.jsp";
                document.jspkecamatan.submit();
            }
            
            function cmdListLast(){
                document.jspkecamatan.command.value="<%=JSPCommand.LAST%>";
                document.jspkecamatan.prev_command.value="<%=JSPCommand.LAST%>";
                document.jspkecamatan.action="desa.jsp";
                document.jspkecamatan.submit();
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
    <body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','<%=approot%>/images/BtnNewOn.jpg')">
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
                                                            <input type="hidden" name="hidden_desa_id" value="<%=oidDesa%>">
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
                                                                                                                    <td> 
                                                                                                                        <table width="100%" cellpadding="0" cellspacing="0" border="0">
                                                                                                                            <%
            try {
                if (listDesa.size() > 0) {

                                                                                                                            %>
                                                                                                                            <tr align="left" valign="top"> 
                                                                                                                                <td height="22" valign="middle" colspan="3"> 
                                                                                                                                <%= drawList(listDesa, oidDesa, langMD)%> </td>
                                                                                                                            </tr>
                                                                                                                            <%  }
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
                                                                                                                                        <% ctrLine.setLocationImg(approot + "/images");
            ctrLine.initDefault();
                                                                                                                                        %>
                                                                                                                                    <%=ctrLine.drawImageListLimit(cmd, vectSize, start, recordToGet)%> </span> 
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                            <%
            if ((iJSPCommand != JSPCommand.ADD && iJSPCommand != JSPCommand.ASK && iJSPCommand != JSPCommand.EDIT) && (jspDesa.errorSize() < 1)) {
                if (privAdd) {%>
                                                                                                                            <tr align="left" valign="top"> 
                                                                                                                                <td> 
                                                                                                                                    <table cellpadding="0" cellspacing="0" border="0">
                                                                                                                                        <tr> 
                                                                                                                                            <td width="4"><img src="<%=approot%>/images/spacer.gif" width="1" height="1"></td>
                                                                                                                                            <td width="20"><a href="javascript:cmdAdd()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image261','','<%=approot%>/images/ctr_line/BtnNewOn.jpg',1)"><img name="Image261" border="0" src="<%=approot%>/images/ctr_line/BtnNew.jpg" width="18" height="16" alt="Add new data"></a></td>
                                                                                                                                            <td width="6"><img src="<%=approot%>/images/spacer.gif" width="1" height="1"></td>
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
                                                                                                                                    <%if ((iJSPCommand == JSPCommand.ADD) || (iJSPCommand == JSPCommand.SAVE) && (jspDesa.errorSize() > 0) || (iJSPCommand == JSPCommand.EDIT) || (iJSPCommand == JSPCommand.ASK)) {%>
                                                                                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                                                                        <tr> 
                                                                                                                                            <td colspan="2" class="listtitle"><b><%=oidDesa == 0 ? "Entry" : "Edit"%> <%=langMD[2]%></b></td>
                                                                                                                                        </tr>
                                                                                                                                        <tr> 
                                                                                                                                            <td height="100%" colspan="2"> 
                                                                                                                                                <table border="0" cellspacing="1" cellpadding="0" width="71%" height="78">
                                                                                                                                                    <tr align="left"> 
                                                                                                                                                        <td valign="top" width="17%">&nbsp;</td>
                                                                                                                                                        <td width="83%" class="comment" valign="top"><font color="#ff0000">* 
                                                                                                                                                        ) <%=langMD[3]%></font></td>
                                                                                                                                                    </tr>
                                                                                                                                                    <tr align="left"> 
                                                                                                                                                        <td valign="top" width="17%"><%=langMD[0]%></td>
                                                                                                                                                        <td width="83%" height="21" valign="top"> 
                                                                                                                                                            <% Vector proKey = new Vector(1, 1);
    Vector proValue = new Vector(1, 1);
    Vector listKecamatan = DbKecamatan.list(0, 0, "", "");
    for (int i = 0; i < listKecamatan.size(); i++) {
        Kecamatan kecamatan = (Kecamatan) listKecamatan.get(i);
        proKey.add(kecamatan.getKode() + " - " + kecamatan.getNama());
        proValue.add("" + kecamatan.getOID());
    }
    out.println(JSPCombo.draw(jspDesa.fieldNames[JspDesa.JSP_KECAMATAN_ID], "formElemen", null, "" + desa.getKecamatanId(), proValue, proKey));
                                                                                                                                                            %>
                                                                                                                                                        </td>
                                                                                                                                                    </tr>
                                                                                                                                                    <tr align="left"> 
                                                                                                                                                        <td width="17%" height="23"><%=langMD[1]%></td>
                                                                                                                                                        <td width="83%" height="21" valign="top"> 
                                                                                                                                                            <input type="text" name="<%=jspDesa.fieldNames[JspDesa.JSP_NAMA] %>"  value="<%= (desa.getNama() == null) ? "" : desa.getNama() %>" class="elemenForm" size="70">
                                                                                                                                                            * <%=jspDesa.getErrorMsg(JspDesa.JSP_NAMA)%> 
                                                                                                                                                        </td>
                                                                                                                                                    </tr>
                                                                                                                                                </table>
                                                                                                                                            </td>
                                                                                                                                        </tr>
                                                                                                                                        <tr align="left" valign="top" > 
                                                                                                                                            <td colspan="2" class="command"> 
                                                                                                                                                <%
    ctrLine.setLocationImg(approot + "/images/ctr_line");
    ctrLine.initDefault();
    ctrLine.setTableWidth("40%");
    String scomDel = "javascript:cmdAsk('" + oidDesa + "')";
    String sconDelCom = "javascript:cmdConfirmDelete('" + oidDesa + "')";
    String scancel = "javascript:cmdEdit('" + oidDesa + "')";
    ctrLine.setBackCaption("Back");
    ctrLine.setJSPCommandStyle("buttonlink");
    ctrLine.setDeleteCaption("Delete");
    ctrLine.setSaveCaption("save");
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

    //if(privNone){
    //	ctrLine.setDeleteCaption("Delete");
    //	ctrLine.setSaveCaption("Save");
    //	ctrLine.setAddCaption("Entry Literatur Baru");
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
                                                                                                                            <tr align="left" valign="top"> 
                                                                                                                                <td>&nbsp; </td>
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

