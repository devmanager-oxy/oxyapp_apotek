
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "com.project.fms.master.*" %>
<%@ page import = "com.project.fms.activity.*" %>
<%@ page import = "com.project.fms.reportform.*" %>
<%@ page import = "com.project.system.*" %>
<%@ include file = "../main/javainit.jsp" %>
<% int appObjCode = 1; %>
<%@ include file = "../main/check.jsp" %>
<%
            boolean priv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MN_FIN_REP, AppMenu.M2_MN_SETUP_REPORT);
            boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_FIN_REP, AppMenu.M2_MN_SETUP_REPORT, AppMenu.PRIV_VIEW);
            boolean privUpdate = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_FIN_REP, AppMenu.M2_MN_SETUP_REPORT, AppMenu.PRIV_UPDATE);
            boolean privAdd = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_FIN_REP, AppMenu.M2_MN_SETUP_REPORT, AppMenu.PRIV_ADD);
            boolean privDelete = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_FIN_REP, AppMenu.M2_MN_SETUP_REPORT, AppMenu.PRIV_DELETE);
%>
<%!
    public String drawList(Vector objectClass, long rptFormatId, int lang, int LANG_ID) {
        JSPList ctrlist = new JSPList();
        ctrlist.setAreaWidth("100%");
        ctrlist.setListStyle("listgen");
        ctrlist.setTitleStyle("tablehdr");
        ctrlist.setCellStyle("tablecell");
        ctrlist.setHeaderStyle("tablehdr");

        ctrlist.addHeader((lang != LANG_ID) ? "Name" : "Nama", "12%");
        ctrlist.addHeader((lang != LANG_ID) ? "Type" : "Tipe", "12%");
        ctrlist.addHeader((lang != LANG_ID) ? "Create Date" : "Tgl. Dibuat", "12%");
        ctrlist.addHeader((lang != LANG_ID) ? "Create By" : "Dibuat Oleh", "12%");
        ctrlist.addHeader((lang != LANG_ID) ? "Status" : "Status", "12%");
        ctrlist.addHeader((lang != LANG_ID) ? "Inactive Date" : "Tgl. Tidak Aktif", "12%");
        //ctrlist.addHeader("Report Scope","12%");
        //ctrlist.addHeader("Reference","12%");
        ctrlist.addHeader((lang != LANG_ID) ? "Last Update By" : "Dipdate Oleh", "12%");
        ctrlist.addHeader((lang != LANG_ID) ? "Last Update" : "Tgl. Update", "12%");
        ctrlist.addHeader((lang != LANG_ID) ? "Detail" : "Detail", "12%");

        //ctrlist.setLinkRow(0);
        ctrlist.setLinkRow(-1);
        ctrlist.setLinkSufix("");
        Vector lstData = ctrlist.getData();
        Vector lstLinkData = ctrlist.getLinkData();
        ctrlist.setLinkPrefix("javascript:cmdEdit('");
        ctrlist.setLinkSufix("')");
        ctrlist.reset();
        int index = -1;

        for (int i = 0; i < objectClass.size(); i++) {
            RptFormat rptFormat = (RptFormat) objectClass.get(i);
            Vector rowx = new Vector();
            if (rptFormatId == rptFormat.getOID()) {
                index = i;
            }

            if (rptFormat.getStatus() == 0) {
                rowx.add("<a href=\"javascript:cmdEdit('" + rptFormat.getOID() + "')\">" + rptFormat.getName() + "</a>");
            } else {
                rowx.add(rptFormat.getName());
            }

            rowx.add(DbRptFormat.strReportType[LANG_ID][rptFormat.getReportType()]);

            String str_dt_CreateDate = "";
            try {
                Date dt_CreateDate = rptFormat.getCreateDate();
                if (dt_CreateDate == null) {
                    dt_CreateDate = new Date();
                }

                str_dt_CreateDate = JSPFormater.formatDate(dt_CreateDate, "dd MMMM yyyy");
            } catch (Exception e) {
                str_dt_CreateDate = "";
            }

            rowx.add(str_dt_CreateDate);

            String str_dt_InactiveDate = "";
            if (rptFormat.getStatus() == 1) {
                try {
                    Date dt_InactiveDate = rptFormat.getInactiveDate();
                    if (dt_InactiveDate == null) {
                        dt_InactiveDate = new Date();
                    }

                    str_dt_InactiveDate = JSPFormater.formatDate(dt_InactiveDate, "dd MMMM yyyy");

                } catch (Exception e) {
                    str_dt_InactiveDate = "";
                }
            }

            User userx = new User();
            try {
                userx = DbUser.fetch(rptFormat.getCreatorId());
            } catch (Exception e) {
            }

            rowx.add(userx.getLoginId());

            rowx.add((rptFormat.getStatus() == 0) ? ((lang != LANG_ID) ? "Active" : "Aktif") : ((lang != LANG_ID) ? "Inactive" : "Tidak Aktif"));

            rowx.add(str_dt_InactiveDate);

            //rowx.add(String.valueOf(rptFormat.getReportScope()));
            //rowx.add(String.valueOf(rptFormat.getRefId()));

            try {
                userx = DbUser.fetch(rptFormat.getUpdateById());
            } catch (Exception e) {
            }

            rowx.add(userx.getLoginId());

            String strUpdatDate = "";
            if (rptFormat.getUpdateById() != 0 && rptFormat.getUpdateDate() != null) {
                strUpdatDate = JSPFormater.formatDate(rptFormat.getUpdateDate(), "dd MMMM yyyy");
            }

            rowx.add(strUpdatDate);

            rowx.add("<a href=\"javascript:cmdDetail('" + rptFormat.getOID() + "')\">Detail</a>");


            lstData.add(rowx);
            lstLinkData.add(String.valueOf(rptFormat.getOID()));
        }

        return ctrlist.draw(index);
    }

%>
<%
            int iJSPCommand = JSPRequestValue.requestCommand(request);
            int start = JSPRequestValue.requestInt(request, "start");
            int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
            long oidRptFormat = JSPRequestValue.requestLong(request, "hidden_rpt_format_id");

            /*variable declaration*/
            int recordToGet = 10;
            String msgString = "";
            int iErrCode = JSPMessage.NONE;
            String whereClause = "";
            String orderClause = "";

            CmdRptFormat ctrlRptFormat = new CmdRptFormat(request);
            JSPLine ctrLine = new JSPLine();
            Vector listRptFormat = new Vector(1, 1);

            /*switch statement */
            iErrCode = ctrlRptFormat.action(iJSPCommand, oidRptFormat, user.getOID());
            /* end switch*/
            JspRptFormat jspRptFormat = ctrlRptFormat.getForm();

            /*count list All RptFormat*/
            int vectSize = DbRptFormat.getCount(whereClause);

            RptFormat rptFormat = ctrlRptFormat.getRptFormat();
            msgString = ctrlRptFormat.getMessage();

            if ((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV) ||
                    (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)) {
                start = ctrlRptFormat.actionList(iJSPCommand, start, vectSize, recordToGet);
            }
            /* end switch list*/

            /* get record to display */
            listRptFormat = DbRptFormat.list(start, recordToGet, whereClause, orderClause);

            /*handle condition if size of record to display = 0 and start > 0 	after delete*/
            if (listRptFormat.size() < 1 && start > 0) {
                if (vectSize - recordToGet > recordToGet) {
                    start = start - recordToGet;
                } //go to JSPCommand.PREV
                else {
                    start = 0;
                    iJSPCommand = JSPCommand.FIRST;
                    prevJSPCommand = JSPCommand.FIRST; //go to JSPCommand.FIRST
                }
                listRptFormat = DbRptFormat.list(start, recordToGet, whereClause, orderClause);
            }


            /*** LANG ***/
            String[] langMD = {"Report List", "Report Name", "Account Group", //0-2
                "Account", "Report Type", "Transaction", "Budget Balance", "Account Group", "Is SP", "Level", "Department", "Section", "Report Title"}; //3-12

            String[] langNav = {"Finance Report", "Report Setup", "All"};

            if (lang == LANG_ID) {
                String[] langID = {"Daftar Laporan", "Nama Laporan", "Kelompok Perkiraan",
                    "Perkiraan", "Jenis Laporan", "Type Transaksi", "Saldo Anggaran", "Kelompok Perkiraan", "SP", "Level", "Departemen", "Bagian", "Judul Laporan"
                };
                langMD = langID;

                String[] navID = {"Laporan Keuangan", "Setup Laporan", "Semua"};
                langNav = navID;
            }
%>
<html >
    <!-- #BeginTemplate "/Templates/index.dwt" --> 
    <head>
        <!-- #BeginEditable "javascript" --> 
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <title><%=systemTitle%></title>
        <link href="../css/css.css" rel="stylesheet" type="text/css" />
        <script language="JavaScript">
            
            <%if (!priv || !privView) {%>
            window.location="<%=approot%>/nopriv.jsp";
            <%}%>
            
            function cmdDetail(oidRptFormat){
                document.frmrptformat.hidden_rpt_format_id.value=oidRptFormat;
                document.frmrptformat.command.value="<%=JSPCommand.LIST%>";
                document.frmrptformat.prev_command.value="<%=prevJSPCommand%>";
                document.frmrptformat.action="rptformatdetail.jsp";
                document.frmrptformat.submit();
            }
            
            function cmdAdd(){
                document.frmrptformat.hidden_rpt_format_id.value="0";
                document.frmrptformat.command.value="<%=JSPCommand.ADD%>";
                document.frmrptformat.prev_command.value="<%=prevJSPCommand%>";
                document.frmrptformat.action="rptformat.jsp";
                document.frmrptformat.submit();
            }
            
            function cmdAsk(oidRptFormat){
                document.frmrptformat.hidden_rpt_format_id.value=oidRptFormat;
                document.frmrptformat.command.value="<%=JSPCommand.ASK%>";
                document.frmrptformat.prev_command.value="<%=prevJSPCommand%>";
                document.frmrptformat.action="rptformat.jsp";
                document.frmrptformat.submit();
            }
            
            function cmdConfirmDelete(oidRptFormat){
                document.frmrptformat.hidden_rpt_format_id.value=oidRptFormat;
                document.frmrptformat.command.value="<%=JSPCommand.DELETE%>";
                document.frmrptformat.prev_command.value="<%=prevJSPCommand%>";
                document.frmrptformat.action="rptformat.jsp";
                document.frmrptformat.submit();
            }
            function cmdSave(){
                document.frmrptformat.command.value="<%=JSPCommand.SAVE%>";
                document.frmrptformat.prev_command.value="<%=prevJSPCommand%>";
                document.frmrptformat.action="rptformat.jsp";
                document.frmrptformat.submit();
            }
            
            function cmdEdit(oidRptFormat){
                <%if(privUpdate){%>
                document.frmrptformat.hidden_rpt_format_id.value=oidRptFormat;
                document.frmrptformat.command.value="<%=JSPCommand.EDIT%>";
                document.frmrptformat.prev_command.value="<%=prevJSPCommand%>";
                document.frmrptformat.action="rptformat.jsp";
                document.frmrptformat.submit();
                <%}%>
            }
            
            function cmdCancel(oidRptFormat){
                document.frmrptformat.hidden_rpt_format_id.value=oidRptFormat;
                document.frmrptformat.command.value="<%=JSPCommand.EDIT%>";
                document.frmrptformat.prev_command.value="<%=prevJSPCommand%>";
                document.frmrptformat.action="rptformat.jsp";
                document.frmrptformat.submit();
            }
            
            function cmdBack(){
                document.frmrptformat.command.value="<%=JSPCommand.BACK%>";
                document.frmrptformat.action="rptformat.jsp";
                document.frmrptformat.submit();
            }
            
            function cmdListFirst(){
                document.frmrptformat.command.value="<%=JSPCommand.FIRST%>";
                document.frmrptformat.prev_command.value="<%=JSPCommand.FIRST%>";
                document.frmrptformat.action="rptformat.jsp";
                document.frmrptformat.submit();
            }
            
            function cmdListPrev(){
                document.frmrptformat.command.value="<%=JSPCommand.PREV%>";
                document.frmrptformat.prev_command.value="<%=JSPCommand.PREV%>";
                document.frmrptformat.action="rptformat.jsp";
                document.frmrptformat.submit();
            }
            
            function cmdListNext(){
                document.frmrptformat.command.value="<%=JSPCommand.NEXT%>";
                document.frmrptformat.prev_command.value="<%=JSPCommand.NEXT%>";
                document.frmrptformat.action="rptformat.jsp";
                document.frmrptformat.submit();
            }
            
            function cmdListLast(){
                document.frmrptformat.command.value="<%=JSPCommand.LAST%>";
                document.frmrptformat.prev_command.value="<%=JSPCommand.LAST%>";
                document.frmrptformat.action="rptformat.jsp";
                document.frmrptformat.submit();
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
    <body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','../images/new2.gif')">
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
            String navigator = "<font class=\"lvl1\">" + langNav[0] + "</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">" + langNav[1] + "</span></font>";
                                           %>
                                                    <%@ include file="../main/navigator.jsp"%><!-- #EndEditable --></td>
                                                </tr>
                                                <!--tr> 
                      <td><img src="<%=approot%>/images/title-sp.gif" width="584" height="1"></td> 
                                                </tr-->
                                                <tr> 
                                                    <td><!-- #BeginEditable "content" --> 
                                                        <form name="frmrptformat" method ="post" action="">
                                                            <input type="hidden" name="command" value="<%=iJSPCommand%>">
                                                            <input type="hidden" name="vectSize" value="<%=vectSize%>">
                                                            <input type="hidden" name="start" value="<%=start%>">
                                                            <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                                                            <input type="hidden" name="hidden_rpt_format_id" value="<%=oidRptFormat%>">
                                                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr>
                                                                    <td class="container"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="8"  colspan="3"> 
                                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="8" valign="middle" colspan="3">&nbsp; 
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="14" valign="middle" colspan="3" class="comment"><b>&nbsp;<%=langMD[0]%></b></td>
                                                                                        </tr>
                                                                                        <%
            try {
                if (listRptFormat.size() > 0) {
                                                                                        %>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="22" valign="middle" colspan="3"> 
                                                                                            <%= drawList(listRptFormat, oidRptFormat, lang, LANG_ID)%> </td>
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
                                                                                                    <% ctrLine.setLocationImg(approot + "/images/ctr_line");
            ctrLine.initDefault();
                                                                                                    %>
                                                                                            <%=ctrLine.drawImageListLimit(cmd, vectSize, start, recordToGet)%> </span> </td>
                                                                                        </tr>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="22" valign="middle" colspan="3">
                                                                                                <%if(privAdd){%>
                                                                                                <a href="javascript:cmdAdd()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new21','','../images/new2.gif',1)"><img src="../images/new.gif" name="new21" width="71" height="22" border="0"></a>
                                                                                                <%}else{%>
                                                                                                &nbsp;
                                                                                                <%}%>
                                                                                                </td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="8" valign="middle" colspan="3"> 
                                                                                    <%if ((iJSPCommand == JSPCommand.ADD) || (iJSPCommand == JSPCommand.SAVE) && (jspRptFormat.errorSize() > 0) || (iJSPCommand == JSPCommand.EDIT) || (iJSPCommand == JSPCommand.ASK)) {%>
                                                                                    <table width="100%" border="0" cellspacing="1" cellpadding="0">
                                                                                        <tr align="left"> 
                                                                                            <td height="21" valign="middle" width="7%">&nbsp;</td>
                                                                                            <td height="21" colspan="2" width="93%" class="comment" valign="top">*)= 
                                                                                            required</td>
                                                                                        </tr>
                                                                                        <tr align="left"> 
                                                                                            <td height="21" width="7%" nowrap><b>&nbsp;<b>&nbsp;</b><%=langMD[5]%>&nbsp;&nbsp;</b></td>
                                                                                            <td height="21" colspan="2" width="93%"> 										  										  
                                                                                            <select name="<%=jspRptFormat.colNames[JspRptFormat.JSP_REPORT_TYPE]%>">
                                                                                                <%for (int i = 0; i < DbRptFormat.strReportType.length; i++) {%>
                                                                                                <option value="<%=i%>" <%if (i == rptFormat.getReportType()) {%>selected<%}%>><%=DbRptFormat.strReportType[LANG_ID][i]%></option>
                                                                                                <%}%> 
                                                                                            </select>
                                                                                        </tr>
                                                                                        <tr align="left"> 
                                                                                            <td height="21" width="7%" nowrap>&nbsp;<b>&nbsp;<%=langMD[1]%>&nbsp;&nbsp;</b></td>
                                                                                            <td height="21" colspan="2" width="93%"> 
                                                                                            <input type="text" name="<%=jspRptFormat.colNames[JspRptFormat.JSP_NAME] %>"  value="<%= rptFormat.getName() %>" class="formElemen" size="30">
                                                                                            * <%= jspRptFormat.getErrorMsg(JspRptFormat.JSP_NAME) %> 
                                                                                        </tr>
                                                                                        <tr align="left"> 
                                                                                            <td height="21" width="7%" nowrap>&nbsp;<b>&nbsp;<%=langMD[12]%>&nbsp;&nbsp;</b></td>
                                                                                            <td height="21" colspan="2" width="93%"> 
                                                                                            <input type="text" name="<%=jspRptFormat.colNames[JspRptFormat.JSP_REPORT_TITLE] %>"  value="<%= rptFormat.getReportTitle() %>" class="formElemen" size="30">
                                                                                            * <%= jspRptFormat.getErrorMsg(JspRptFormat.JSP_REPORT_TITLE) %> 
                                                                                        </tr>
                                                                                        <tr align="left" > 
                                                                                            <td colspan="3" class="command" valign="top">&nbsp;</td>
                                                                                        </tr>
                                                                                        <tr align="left" > 
                                                                                            <td colspan="3" class="command" valign="top"> 
                                                                                                <%
    ctrLine.setLocationImg(approot + "/images/ctr_line");
    ctrLine.initDefault();
    ctrLine.setTableWidth("60%");
    String scomDel = "javascript:cmdAsk('" + oidRptFormat + "')";
    String sconDelCom = "javascript:cmdConfirmDelete('" + oidRptFormat + "')";
    String scancel = "javascript:cmdEdit('" + oidRptFormat + "')";
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
                                                                                            <td width="7%">&nbsp;</td>
                                                                                            <td width="93%">&nbsp;</td>
                                                                                        </tr>
                                                                                        <tr align="left" > 
                                                                                            <td colspan="3" valign="top"> 
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
