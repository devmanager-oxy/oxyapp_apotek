
<%-- 
    Document   : approval
    Created on : Jan 31, 2011, 4:41:41 PM
    Author     : Tu Roy
--%>
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.main.db.*" %>
<%@ page import = "com.project.ccs.posmaster.*" %>
<%@ page import = "com.project.fms.master.*" %>
<%@ page import = "com.project.general.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "com.project.crm.*" %>
<%@ include file = "../main/javainit.jsp" %>
<%@ include file = "../main/check.jsp" %>
<%
            boolean priv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_ACCOUNTING);
            boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_ACCOUNTING, AppMenu.PRIV_VIEW);
            boolean privUpdate = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_ACCOUNTING, AppMenu.PRIV_UPDATE);
            boolean privAdd = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_ACCOUNTING, AppMenu.PRIV_ADD);
            boolean privDelete = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_ACCOUNTING, AppMenu.PRIV_DELETE);
%>
<%!
    public String drawList(int iJSPCommand, JspSystemDocCode frmObject, SystemDocCode objEntity,
            Vector objectClass, long systemDocCodeId, String approot, String[] langMD, Vector keyCounter, Vector valCounter, boolean langIndo) {

        JSPList cmdist = new JSPList();
        cmdist.setAreaWidth("100%");
        cmdist.setListStyle("listgen");
        cmdist.setTitleStyle("tablehdr");
        cmdist.setCellStyle("tablecell");
        cmdist.setCellStyle1("tablecell1");
        cmdist.setHeaderStyle("tablehdr");

        cmdist.addHeader(langMD[0], "5%");
        cmdist.addHeader(langMD[1], "10%");
        cmdist.addHeader(langMD[2], "15%");
        cmdist.addHeader(langMD[3], "10%");
        cmdist.addHeader(langMD[4], "15%");
        cmdist.addHeader(langMD[5], "15%");
        cmdist.addHeader(langMD[6], "10%");
        cmdist.addHeader(langMD[7], "10%");
        cmdist.addHeader(langMD[8], "10%");

        cmdist.setLinkRow(0);
        cmdist.setLinkSufix("");
        Vector lstData = cmdist.getData();
        Vector lstLinkData = cmdist.getLinkData();
        Vector rowx = new Vector(1, 1);
        cmdist.reset();
        int index = -1;

        Vector typeDocKey = new Vector();
        Vector typeDocValue = new Vector();
        int maxStatus = DbSystemDocCode.typeDocument.length;

        for (int iSts = 0; iSts < maxStatus; iSts++) {
            typeDocValue.add(DbSystemDocCode.typeDocument[iSts]);
            typeDocKey.add(DbSystemDocCode.typeDocument[iSts]);
        }

        Vector mType_val = new Vector();
        Vector mType_key = new Vector();
        for (int x = 0; x < DbSystemDocCode.monthType.length; x++) {
            mType_val.add("" + x);
            mType_key.add("" + DbSystemDocCode.monthType[x]);
        }

        for (int i = 0; i < objectClass.size(); i++) {

            SystemDocCode systemDocCode = (SystemDocCode) objectClass.get(i);
            rowx = new Vector();

            if (systemDocCodeId == systemDocCode.getOID()) {
                index = i;
            }

            if (index == i && (iJSPCommand == JSPCommand.EDIT || iJSPCommand == JSPCommand.ASK)) {

                rowx.add("<div align=\"center\">" + (i + 1) + "</div>");

                rowx.add("<div align=\"center\"><input type=\"text\" name=\"" + frmObject.colNames[JspSystemDocCode.JSP_CODE] + "\" value=\"" + systemDocCode.getCode() + "\" class=\"formElemen\" size=\"25\" style=\"text-align:left\"></div>");
                rowx.add("<div align=\"center\">" + JSPCombo.draw(frmObject.colNames[JspSystemDocCode.JSP_TYPE], null, "" + systemDocCode.getType(), typeDocKey, typeDocValue, "formElemen", "") + "</div>");
                rowx.add("<div align=\"center\"><input type=\"text\" name=\"" + frmObject.colNames[JspSystemDocCode.JSP_SEPARATOR] + "\" value=\"" + systemDocCode.getSeparator() + "\" class=\"formElemen\" size=\"10\" style=\"text-align:left\"></div>");
                rowx.add("<div align=\"center\"><input type=\"text\" name=\"" + frmObject.colNames[JspSystemDocCode.JSP_DIGIT_COUNTER] + "\" value=\"" + systemDocCode.getDigitCounter() + "\" class=\"formElemen\" size=\"10\" style=\"text-align:right\"></div>");
                rowx.add("<div align=\"center\">" + JSPCombo.draw(frmObject.colNames[JspSystemDocCode.JSP_POSISI_AFTER_CODE], null, "" + systemDocCode.getPosisiAfterCode(), valCounter, keyCounter, "formElemen", "") + "</div>");
                rowx.add("<div align=\"center\"><input type=\"text\" name=\"" + frmObject.colNames[JspSystemDocCode.JSP_YEAR_DIGIT] + "\" value=\"" + systemDocCode.getYearDigit() + "\" class=\"formElemen\" size=\"10\" style=\"text-align:right\"></div>");
                rowx.add("<div align=\"center\"><input type=\"text\" name=\"" + frmObject.colNames[JspSystemDocCode.JSP_MONTH_DIGIT] + "\" value=\"" + systemDocCode.getMonthDigit() + "\" class=\"formElemen\" size=\"10\" style=\"text-align:right\"></div>");

                rowx.add("<div align=\"center\">" + JSPCombo.draw(frmObject.colNames[JspSystemDocCode.JSP_MONTH_TYPE], null, "" + systemDocCode.getMonthType(), mType_val, mType_key, "formElemen", "") + "</div>");

            } else {

                rowx.add("<div align=\"center\">" + (i + 1) + "</div>");
                rowx.add("<a href=\"javascript:cmdEdit('" + String.valueOf(systemDocCode.getOID()) + "')\">" + systemDocCode.getCode() + "</a>");
                rowx.add("" + systemDocCode.getType());
                rowx.add("" + systemDocCode.getSeparator());
                rowx.add("<div align=\"right\">" + systemDocCode.getDigitCounter() + "</div");

                String pos = "";

                if (langIndo) {
                    pos = DbSystemDocCode.statusPositionInd[systemDocCode.getPosisiAfterCode()];
                } else {
                    pos = DbSystemDocCode.statusPositionEng[systemDocCode.getPosisiAfterCode()];
                }
                rowx.add("<div align=\"right\">" + pos + "</div");
                rowx.add("<div align=\"right\">" + systemDocCode.getYearDigit() + "</div");
                rowx.add("<div align=\"right\">" + systemDocCode.getMonthDigit() + "</div");
                rowx.add("<div align=\"right\">" + DbSystemDocCode.monthType[systemDocCode.getMonthType()] + "</div");
            }

            lstData.add(rowx);
        }

        rowx = new Vector();

        if (iJSPCommand == JSPCommand.ADD || (iJSPCommand == JSPCommand.SAVE && frmObject.errorSize() > 0)) {

            rowx.add("<div align=\"center\">" + (objectClass.size() + 1) + "</div>");
            rowx.add("<div align=\"center\"><input type=\"text\" size=\"10\" name=\"" + frmObject.colNames[JspSystemDocCode.JSP_CODE] + "\" value=\"" + objEntity.getCode() + "\" class=\"formElemen\"></div>");
            rowx.add("<div align=\"center\">" + JSPCombo.draw(frmObject.colNames[JspSystemDocCode.JSP_TYPE], null, "" + objEntity.getType(), typeDocKey, typeDocValue, "formElemen", "") + "</div>");
            rowx.add("<div align=\"center\"><input type=\"text\" size=\"10\" name=\"" + frmObject.colNames[JspSystemDocCode.JSP_SEPARATOR] + "\" value=\"" + objEntity.getSeparator() + "\" class=\"formElemen\"></div>");

            rowx.add("<div align=\"center\"><input type=\"text\" name=\"" + frmObject.colNames[JspSystemDocCode.JSP_DIGIT_COUNTER] + "\" value=\"" + objEntity.getDigitCounter() + "\" class=\"formElemen\" size=\"10\" style=\"text-align:right\"></div>");
            rowx.add("<div align=\"center\">" + JSPCombo.draw(frmObject.colNames[JspSystemDocCode.JSP_POSISI_AFTER_CODE], null, "" + objEntity.getPosisiAfterCode(), valCounter, keyCounter, "formElemen", "") + "</div>");
            rowx.add("<div align=\"center\"><input type=\"text\" name=\"" + frmObject.colNames[JspSystemDocCode.JSP_YEAR_DIGIT] + "\" value=\"" + objEntity.getYearDigit() + "\" class=\"formElemen\" size=\"10\" style=\"text-align:right\"></div>");
            rowx.add("<div align=\"center\"><input type=\"text\" name=\"" + frmObject.colNames[JspSystemDocCode.JSP_MONTH_DIGIT] + "\" value=\"" + objEntity.getMonthDigit() + "\" class=\"formElemen\" size=\"10\" style=\"text-align:right\"></div>");
            rowx.add("<div align=\"center\">" + JSPCombo.draw(frmObject.colNames[JspSystemDocCode.JSP_MONTH_TYPE], null, "" + objEntity.getMonthType(), mType_val, mType_key, "formElemen", "") + "</div>");

        }

        lstData.add(rowx);

        return cmdist.draw(index);
    }

%>
<%
            int iJSPCommand = JSPRequestValue.requestCommand(request);
            int start = JSPRequestValue.requestInt(request, "start");
            int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
            long oidSystemDocCode = JSPRequestValue.requestLong(request, "hidden_system_doc_code_id");

            /*variable declaration*/
            int recordToGet = 30;
            String msgString = "";
            int iErrCode = JSPMessage.NONE;
            String whereClause = "";
            String orderClause = "";

            CmdSystemDocCode ctrlSystemDocCode = new CmdSystemDocCode(request);
            JSPLine ctrLine = new JSPLine();
            Vector listSystemDocCode = new Vector(1, 1);

            /*switch statement */
            iErrCode = ctrlSystemDocCode.action(iJSPCommand, oidSystemDocCode);
            /* end switch*/
            JspSystemDocCode jspSystemDocCode = ctrlSystemDocCode.getForm();

            /*count list All SystemDocCode*/
            int vectSize = DbSystemDocCode.getCount(whereClause);

            /*switch list SystemDocCode*/
            if ((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV) ||
                    (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)) {
                start = ctrlSystemDocCode.actionList(iJSPCommand, start, vectSize, recordToGet);
            }
            /* end switch list*/

            SystemDocCode systemDocCode = ctrlSystemDocCode.getSystemDocCode();
            msgString = ctrlSystemDocCode.getMessage();

            /* get record to display */
            listSystemDocCode = DbSystemDocCode.list(start, recordToGet, whereClause, orderClause);

            /*handle condition if size of record to display = 0 and start > 0 	after delete*/
            if (listSystemDocCode.size() < 1 && start > 0) {
                if (vectSize - recordToGet > recordToGet) {
                    start = start - recordToGet;
                } //go to JSPCommand.PREV
                else {
                    start = 0;
                    iJSPCommand = JSPCommand.FIRST;
                    prevJSPCommand = JSPCommand.FIRST; //go to JSPCommand.FIRST
                }
                listSystemDocCode = DbSystemDocCode.list(start, recordToGet, whereClause, orderClause);
            }

            /*** LANG ***/
            Vector keyCounter = new Vector();
            Vector valCounter = new Vector();

            String[] langMD = {"No.", "Code", "Type", "Separator", "Digit Counter", "Posistion After Code", "Year Digit", "Month Digit", "Month Type"};

            String[] langNav = {"Master Data", "Code Document Setup", "Setup Doc. Code"};

            boolean langIndo = false;

            if (lang == LANG_ID) {

                langIndo = true;

                for (int iP = 0; iP < DbSystemDocCode.statusPositionInd.length; iP++) {
                    keyCounter.add(DbSystemDocCode.statusPositionInd[iP]);
                    valCounter.add("" + iP);
                }

                String[] langID = {"No", "Kode", "Tipe", "Karakter Pemisah", "Digit Counter", "Posisi After Code", "Year Digit", "Month Digit", "Month Type"};
                langMD = langID;

                String[] navID = {"Data Induk", "Setup Kode Dokumen", "Setup Kode Dokumen"};
                langNav = navID;

            } else {
                keyCounter = new Vector();
                for (int iP = 0; iP < DbSystemDocCode.statusPositionEng.length; iP++) {
                    keyCounter.add(DbSystemDocCode.statusPositionEng[iP]);
                    valCounter.add("" + iP);
                }
            }

%>
<html >
    <!-- #BeginTemplate "/Templates/index.dwt" --> 
    <head>
        <!-- #BeginEditable "javascript" --> 
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
        <title><%=systemTitle%></title>
        <link href="../css/default.css" rel="stylesheet" type="text/css" />
        <link href="../css/css.css" rel="stylesheet" type="text/css" />
        <script language="JavaScript">
            
            function cmdAdd(){
                document.frmsystemdoccode.hidden_system_doc_code_id.value="0";
                document.frmsystemdoccode.command.value="<%=JSPCommand.ADD%>";
                document.frmsystemdoccode.prev_command.value="<%=prevJSPCommand%>";
                document.frmsystemdoccode.action="systemdoccode.jsp";
                document.frmsystemdoccode.submit();
            }
            
            function cmdAsk(oidSystemDocCode){
                document.frmsystemdoccode.hidden_system_doc_code_id.value=oidSystemDocCode;
                document.frmsystemdoccode.command.value="<%=JSPCommand.ASK%>";
                document.frmsystemdoccode.prev_command.value="<%=prevJSPCommand%>";
                document.frmsystemdoccode.action="systemdoccode.jsp";
                document.frmsystemdoccode.submit();
            }
            
            function cmdConfirmDelete(oidSystemDocCode){
                document.frmsystemdoccode.hidden_system_doc_code_id.value=oidSystemDocCode;
                document.frmsystemdoccode.command.value="<%=JSPCommand.DELETE%>";
                document.frmsystemdoccode.prev_command.value="<%=prevJSPCommand%>";
                document.frmsystemdoccode.action="systemdoccode.jsp";
                document.frmsystemdoccode.submit();
            }
            
            function cmdSave(){
                document.frmsystemdoccode.command.value="<%=JSPCommand.SAVE%>";
                document.frmsystemdoccode.prev_command.value="<%=prevJSPCommand%>";
                document.frmsystemdoccode.action="systemdoccode.jsp";
                document.frmsystemdoccode.submit();
            }
            
            function cmdEdit(oidSystemDocCode){
                document.frmsystemdoccode.hidden_system_doc_code_id.value=oidSystemDocCode;
                document.frmsystemdoccode.command.value="<%=JSPCommand.EDIT%>";
                document.frmsystemdoccode.prev_command.value="<%=prevJSPCommand%>";
                document.frmsystemdoccode.action="systemdoccode.jsp";
                document.frmsystemdoccode.submit();
            }
            
            function cmdCancel(oidSystemDocCode){
                document.frmsystemdoccode.hidden_system_doc_code_id.value=oidSystemDocCode;
                document.frmsystemdoccode.command.value="<%=JSPCommand.EDIT%>";
                document.frmsystemdoccode.prev_command.value="<%=prevJSPCommand%>";
                document.frmsystemdoccode.action="systemdoccode.jsp";
                document.frmsystemdoccode.submit();
            }
            
            function cmdBack(){
                document.frmsystemdoccode.command.value="<%=JSPCommand.BACK%>";
                document.frmsystemdoccode.action="systemdoccode.jsp";
                document.frmsystemdoccode.submit();
            }
            
            function cmdListFirst(){
                document.frmsystemdoccode.command.value="<%=JSPCommand.FIRST%>";
                document.frmsystemdoccode.prev_command.value="<%=JSPCommand.FIRST%>";
                document.frmsystemdoccode.action="systemdoccode.jsp";
                document.frmsystemdoccode.submit();
            }
            
            function cmdListPrev(){
                document.frmsystemdoccode.command.value="<%=JSPCommand.PREV%>";
                document.frmsystemdoccode.prev_command.value="<%=JSPCommand.PREV%>";
                document.frmsystemdoccode.action="systemdoccode.jsp";
                document.frmsystemdoccode.submit();
            }
            
            function cmdListNext(){
                document.frmsystemdoccode.command.value="<%=JSPCommand.NEXT%>";
                document.frmsystemdoccode.prev_command.value="<%=JSPCommand.NEXT%>";
                document.frmsystemdoccode.action="systemdoccode.jsp";
                document.frmsystemdoccode.submit();
            }
            
            function cmdListLast(){
                document.frmsystemdoccode.command.value="<%=JSPCommand.LAST%>";
                document.frmsystemdoccode.prev_command.value="<%=JSPCommand.LAST%>";
                document.frmsystemdoccode.action="systemdoccode.jsp";
                document.frmsystemdoccode.submit();
            }
            
            //-------------- script form image -------------------
            
            function cmdDelPict(oidSystemDocCode){
                document.frmimage.hidden_system_doc_code_id.value=oidSystemDocCode;
                document.frmimage.command.value="<%=JSPCommand.POST%>";
                document.frmimage.action="systemdoccode.jsp";
                document.frmimage.submit();
            }
            
            //-------------- script form image -------------------
            
            function cmdDelPict(oidApproval){
                document.frmimage.hidden_limbah_id.value=oidApproval;
                document.frmimage.command.value="<%=JSPCommand.POST%>";
                document.frmimage.action="approval.jsp";
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
        <style type="text/css">
            <!--
            .style2 {
                color: #FF0000;
                font-weight: bold;
            }
            -->
        </style>
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
                  <%@ include file="../calendar/calendarframe.jsp"%>
                                        <!-- #EndEditable --> </td>
                                        <td width="100%" valign="top"> 
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                <tr> 
                                                    <td class="title"><!-- #BeginEditable "title" --> 
                                                        <table width="100%" border="0" cellspacing="1" cellpadding="1" height="17">
                                                            <tr valign="bottom"> 
                                                                <td class="title"><!-- #BeginEditable "title" -->
                                           <%
            String navigator = "<font class=\"lvl1\">" + langNav[0] + "</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">" + langNav[1] + "</span></font>";
                                           %>
                                           <%@ include file="../main/navigator.jsp"%>
                                                                <!-- #EndEditable --></td>
                                                            </tr>
                                                        </table>
                                                    <!-- #EndEditable --></td>
                                                </tr>
                                                <!--tr> 
                      <td><img src="<%=approot%>/images/title-sp.gif" width="584" height="1"></td> 
                                                </tr-->
                                                <tr> 
                                                    <td><!-- #BeginEditable "content" --> 
                                                        <form name="frmsystemdoccode" method ="post" action="">
                                                            <input type="hidden" name="command" value="<%=iJSPCommand%>">
                                                            <input type="hidden" name="vectSize" value="<%=vectSize%>">
                                                            <input type="hidden" name="start" value="<%=start%>">
                                                            <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                                                            <input type="hidden" name="hidden_system_doc_code_id" value="<%=oidSystemDocCode%>">
                                                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr> 
                                                                    <td class="container"> 
                                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="8"> 
                                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="8" valign="middle" colspan="3" class="listtitle"></td>
                                                                                        </tr>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="8" valign="middle" colspan="3" class="listtitle"></td>
                                                                                        </tr>
                                                                                        <%
            try {
                                                                                        %>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="22" valign="middle" colspan="3"><%= drawList(iJSPCommand, jspSystemDocCode, systemDocCode, listSystemDocCode, oidSystemDocCode, approot, langMD, keyCounter, valCounter, langIndo)%></td>
                                                                                        </tr>
                                                                                        <%
            } catch (Exception exc) {
                System.out.println("err>> : " + exc.toString());
            }%>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="8" align="left" colspan="3" class="command" valign="top"> 
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
                                                                                <%=ctrLine.drawImageListLimit(cmd, vectSize, start, recordToGet)%> </span></td>
                                                                                        </tr>
                                                                                        <%if (iJSPCommand != JSPCommand.EDIT && iJSPCommand != JSPCommand.ADD && iJSPCommand != JSPCommand.ASK && iErrCode == 0) {%>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="22" valign="middle" colspan="3"> 
                                                                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                                    <tr> 
                                                                                                        <td width="97%">&nbsp;</td>
                                                                                                    </tr>
                                                                                                    <tr> 
                                                                                                        <td width="97%"><a href="javascript:cmdAdd()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new21','','../images/new2.gif',1)"><img src="../images/new.gif" name="new21" width="71" height="22" border="0"></a></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <%}%>
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="8" valign="middle">&nbsp;</td>
                                                                            </tr>
                                                                            <tr align="left" valign="top" > 
                                                                                <td class="command"> 
                                                                                    <%
            ctrLine.setLocationImg(approot + "/images/ctr_line");
            ctrLine.initDefault();
            ctrLine.setTableWidth("80%");
            String scomDel = "javascript:cmdAsk('" + oidSystemDocCode + "')";
            String sconDelCom = "javascript:cmdConfirmDelete('" + oidSystemDocCode + "')";
            String scancel = "javascript:cmdEdit('" + oidSystemDocCode + "')";
            ctrLine.setBackCaption("Back to List");
            ctrLine.setJSPCommandStyle("buttonlink");
            ctrLine.setDeleteCaption("Delete");

            ctrLine.setOnMouseOut("MM_swapImgRestore()");
            ctrLine.setOnMouseOverSave("MM_swapImage('save','','" + approot + "/images/save2.gif',1)");
            ctrLine.setSaveImage("<img src=\"" + approot + "/images/save.gif\" name=\"save\" height=\"22\" border=\"0\">");

            ctrLine.setOnMouseOverBack("MM_swapImage('back','','" + approot + "/images/cancel2.gif',1)");
            ctrLine.setBackImage("<img src=\"" + approot + "/images/cancel.gif\" name=\"back\" height=\"22\" border=\"0\">");

            ctrLine.setOnMouseOverDelete("MM_swapImage('delete','','" + approot + "/images/delete2.gif',1)");
            ctrLine.setDeleteImage("<img src=\"" + approot + "/images/delete.gif\" name=\"delete\" height=\"22\" border=\"0\">");

            ctrLine.setOnMouseOverEdit("MM_swapImage('edit','','" + approot + "/images/cancel2.gif',1)");
            ctrLine.setEditImage("<img src=\"" + approot + "/images/cancel.gif\" name=\"edit\" height=\"22\" border=\"0\">");


            ctrLine.setWidthAllJSPCommand("90");
            ctrLine.setErrorStyle("warning");
            ctrLine.setErrorImage(approot + "/images/error.gif\" width=\"20\" height=\"20");
            ctrLine.setQuestionStyle("warning");
            ctrLine.setQuestionImage(approot + "/images/error.gif\" width=\"20\" height=\"20");
            ctrLine.setInfoStyle("success");
            ctrLine.setSuccessImage(approot + "/images/success.gif\" width=\"20\" height=\"20");

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
                                                                                    <%if (iJSPCommand == JSPCommand.EDIT || iJSPCommand == JSPCommand.ADD || iJSPCommand == JSPCommand.ASK || iErrCode != 0) {%>
                                                                                    <%= ctrLine.drawImageOnly(iJSPCommand, iErrCode, msgString)%> 
                                                                                    <%}%>
                                                                                </td>
                                                                            </tr>
                                                                            <tr align="left" valign="top" > 
                                                                                <td class="command"> 
                                                                                    <%if (iErrCode != 0) {%>
                                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                        <tr> 
                                                                                            <td width="22%" ><span class="style2">Keterangan 
                                                                                            Error : </span></td>
                                                                                            <td width="78%">&nbsp;</td>
                                                                                        </tr>
                                                                                        <tr> 
                                                                                            <td colspan="2" align="left">1. <%=CmdApproval.resultText[0][iErrCode]%></td>
                                                                                        </tr>
                                                                                        <tr> 
                                                                                            <td align="right">&nbsp;</td>
                                                                                            <td>&nbsp;</td>
                                                                                        </tr>
                                                                                    </table>
                                                                                    <%}%>
                                                                                </td>
                                                                            </tr>
                                                                            <tr align="left" valign="top" > 
                                                                                <td class="command">&nbsp;</td>
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

