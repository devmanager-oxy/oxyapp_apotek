
<%-- 
    Document   : approval
    Created on : Jan 31, 2011, 4:41:41 PM
    Author     : Tu Roy
--%>
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.main.db.*" %>
<%@ page import = "com.project.ccs.posmaster.*" %>
<%@ page import = "com.project.fms.master.*" %>
<%@ page import = "com.project.general.*" %>
<%@ page import = "com.project.payroll.*" %>
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
    public String drawList(int iJSPCommand, JspApproval frmObject, Approval objEntity,
            Vector objectClass, long approvalId, String approot, String[] langMD) {

        JSPList cmdist = new JSPList();
        cmdist.setAreaWidth("1100");
        cmdist.setListStyle("listgen");
        cmdist.setTitleStyle("tablehdr");
        cmdist.setCellStyle("tablecell");
        cmdist.setCellStyle1("tablecell1");
        cmdist.setHeaderStyle("tablehdr");

        cmdist.addHeader(langMD[0], "");
        cmdist.addHeader(langMD[1], "7%");
        cmdist.addHeader(langMD[6], "7%");
        cmdist.addHeader(langMD[2], "20%");
        cmdist.addHeader(langMD[7], "20%");
        cmdist.addHeader(langMD[4], "10%");
        cmdist.addHeader(langMD[3], "20%");

        cmdist.setLinkRow(0);
        cmdist.setLinkSufix("");
        Vector lstData = cmdist.getData();
        Vector lstLinkData = cmdist.getLinkData();
        Vector rowx = new Vector(1, 1);
        cmdist.reset();
        int index = -1;

        int maxType = I_Project.approvalTypeStr.length;

        Vector appKey = new Vector();
        Vector appValue = new Vector();

        for (int iType = 0; iType < maxType; iType++) {
            appKey.add(I_Project.approvalTypeKey[iType]);
            appValue.add(I_Project.approvalTypeStr[iType]);
        }

        Vector urutanKey = new Vector();
        Vector urutanValue = new Vector();

        int mxUrutan = DbApproval.approvalUrutanKey.length;

        for (int iUrutan = 0; iUrutan < mxUrutan; iUrutan++) {
            urutanKey.add("" + DbApproval.approvalUrutanKey[iUrutan]);
            urutanValue.add("" + DbApproval.approvalUrutanStr[iUrutan]);
        }

        Vector empValue = new Vector();
        Vector empKey = new Vector();

        empValue.add("" + 0);
        empKey.add("- select employee -");

        Vector vEmp = DbEmployee.list(0, 0, "", DbEmployee.colNames[DbEmployee.COL_NAME]);
        for (int iEmp = 0; iEmp < DbEmployee.getCount(""); iEmp++) {
            Employee employee = new Employee();
            employee = (Employee) vEmp.get(iEmp);
            empKey.add("" + employee.getName().toUpperCase());
            empValue.add("" + employee.getOID());
        }

        for (int i = 0; i < objectClass.size(); i++) {

            Approval approval = (Approval) objectClass.get(i);

            String employeeName = "- none -";

            if (approval.getEmployeeId() != 0) {
                employeeName = "";
                Employee objEmployee = new Employee();
                try {
                    objEmployee = (Employee) DbEmployee.fetchExc(approval.getEmployeeId());
                    employeeName = objEmployee.getName().toUpperCase();
                } catch (Exception E) {
                    System.out.println("[exception] " + E.toString());
                }
            }

            rowx = new Vector();
            if (approvalId == approval.getOID()) {
                index = i;
            }

            if (index == i && (iJSPCommand == JSPCommand.EDIT || iJSPCommand == JSPCommand.ASK)) {

                rowx.add("<div align=\"center\">" + JSPCombo.draw(frmObject.colNames[frmObject.JSP_TYPE], null, "" + approval.getType(), appKey, appValue, "formElemen", "") + "</div>");
                rowx.add("<div align=\"center\">" + JSPCombo.draw(frmObject.colNames[frmObject.JSP_URUTAN], null, "" + approval.getUrutan(), urutanKey, urutanValue, "formElemen", "") + "</div>");
                rowx.add("<div align=\"center\">" + JSPCombo.draw(frmObject.colNames[frmObject.JSP_URUTAN_APPROVAL], null, "" + approval.getUrutanApproval(), urutanKey, urutanValue, "formElemen", "") + "</div>");
                rowx.add("<div align=\"center\"><input type=\"text\" name=\"" + frmObject.colNames[JspApproval.JSP_KETERANGAN] + "\" value=\"" + approval.getKeterangan() + "\" class=\"formElemen\" size=\"30\" style=\"text-align:left\"></div>");
                rowx.add("<div align=\"center\"><input type=\"text\" name=\"" + frmObject.colNames[JspApproval.JSP_KETERANGAN_FOOTER] + "\" value=\"" + approval.getKeteranganFooter() + "\" class=\"formElemen\" size=\"30\" style=\"text-align:left\"></div>");
                rowx.add("<div align=\"center\"><input type=\"text\" name=\"" + frmObject.colNames[JspApproval.JSP_JUMLAH_DARI] + "\" value=\"" + approval.getJumlahDari() + "\" class=\"formElemen\" size=\"30\" style=\"text-align:left\"></div>");
                rowx.add("<div align=\"center\">" + JSPCombo.draw(frmObject.colNames[frmObject.JSP_EMPLOYEE_ID], null, "" + approval.getEmployeeId(), empValue, empKey, "formElemen", "") + "</div>");

            } else {

                rowx.add("<div align=\"left\"><a href=\"javascript:cmdEdit('" + String.valueOf(approval.getOID()) + "')\">" + String.valueOf(I_Project.approvalTypeStr[approval.getType()]) + "</a></div>");
                rowx.add("<div align=\"left\">" + DbApproval.approvalUrutanStr[approval.getUrutan()] + "</div>");
                rowx.add("<div align=\"left\">" + DbApproval.approvalUrutanStr[approval.getUrutanApproval()] + "</div>");
                rowx.add("<div align=\"left\">" + approval.getKeterangan() + "</div>");
                rowx.add("<div align=\"left\">" + approval.getKeteranganFooter() + "</div>");
                rowx.add("<div align=\"right\">" + JSPFormater.formatNumber(approval.getJumlahDari(), "#,###") + "</div>");
                rowx.add("<div align=\"left\">" + employeeName + "</div>");

            }

            lstData.add(rowx);
        }

        rowx = new Vector();

        if (iJSPCommand == JSPCommand.ADD || (iJSPCommand == JSPCommand.SAVE && frmObject.errorSize() > 0)) {

            rowx.add("<div align=\"center\">" + JSPCombo.draw(frmObject.colNames[frmObject.JSP_TYPE], null, "" + objEntity.getType(), appKey, appValue, "formElemen", "") + "</div>");
            rowx.add("<div align=\"center\">" + JSPCombo.draw(frmObject.colNames[frmObject.JSP_URUTAN], null, "" + objEntity.getUrutan(), urutanKey, urutanValue, "formElemen", "") + "</div>");
            rowx.add("<div align=\"center\">" + JSPCombo.draw(frmObject.colNames[frmObject.JSP_URUTAN_APPROVAL], null, "" + objEntity.getUrutanApproval(), urutanKey, urutanValue, "formElemen", "") + "</div>");
            rowx.add("<div align=\"center\"><input type=\"text\" name=\"" + frmObject.colNames[JspApproval.JSP_KETERANGAN] + "\" value=\"" + objEntity.getKeterangan() + "\" class=\"formElemen\" size=\"20\" style=\"text-align:left\"></div>");
            rowx.add("<div align=\"center\"><input type=\"text\" name=\"" + frmObject.colNames[JspApproval.JSP_KETERANGAN_FOOTER] + "\" value=\"" + objEntity.getKeteranganFooter() + "\" class=\"formElemen\" size=\"20\" style=\"text-align:left\"></div>");
            rowx.add("<div align=\"center\"><input type=\"text\" name=\"" + frmObject.colNames[JspApproval.JSP_JUMLAH_DARI] + "\" value=\"" + objEntity.getJumlahDari() + "\" class=\"formElemen\" size=\"20\" style=\"text-align:left\"></div>");
            rowx.add("<div align=\"center\">" + JSPCombo.draw(frmObject.colNames[frmObject.JSP_EMPLOYEE_ID], null, "" + objEntity.getEmployeeId(), empValue, empKey, "formElemen", "") + "</div>");

        }

        lstData.add(rowx);

        return cmdist.draw(index);
    }

%>
<%
            int iJSPCommand = JSPRequestValue.requestCommand(request);
            int start = JSPRequestValue.requestInt(request, "start");
            int prevCommand = JSPRequestValue.requestInt(request, "prev_command");
            long oidApproval = JSPRequestValue.requestLong(request, "hidden_approval_id");

            /*variable declaration*/
            int recordToGet = 30;
            String msgString = "";
            int iErrCode = JSPMessage.NONE;

            CmdApproval cmdApproval = new CmdApproval(request);
            JSPLine ctrLine = new JSPLine();
            Vector listApproval = new Vector(1, 1);

            /*switch statement */
            iErrCode = cmdApproval.action(iJSPCommand, oidApproval);
            /* end switch*/
            JspApproval jspApproval = cmdApproval.getForm();

            /*count list All Limbah */
            int vectSize = DbApproval.getCount("");

            /*switch list Limbah */
            if ((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV) ||
                    (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)) {
                start = cmdApproval.actionList(iJSPCommand, start, vectSize, recordToGet);
            }
            /* end switch list*/

            Approval approval = cmdApproval.getApproval();
            msgString = cmdApproval.getMessage();

            /* get record to display */
            listApproval = DbApproval.list(start, recordToGet, "", DbApproval.colNames[DbApproval.COL_TYPE] + "," + DbApproval.colNames[DbApproval.COL_URUTAN_APPROVAL] + " ASC ");

            /*handle condition if size of record to display = 0 and start > 0 	after delete*/
            if (listApproval.size() < 1 && start > 0) {
                if (vectSize - recordToGet > recordToGet) {
                    start = start - recordToGet;
                } //go to JSPCommand.PREV
                else {
                    start = 0;
                    iJSPCommand = JSPCommand.FIRST;
                    prevCommand = JSPCommand.FIRST; //go to JSPCommand.FIRST
                }
                listApproval = DbApproval.list(start, recordToGet, "", DbApproval.colNames[DbApproval.COL_TYPE] + "," + DbApproval.colNames[DbApproval.COL_URUTAN_APPROVAL] + " ASC ");
            }

            /*** LANG ***/
            String[] langMD = {"Type", "Printing Sequence", "Approval Header", "Approver", "Minimum Transaction Amount", "Max. Transaction Amount", "Approval Sequence", "Approval Footer"};

            String[] langNav = {"Master Data", "Document", "Setup Doc. Approval"};

            if (lang == LANG_ID) {
                String[] langID = {"Tipe", "Urutan Printout", "Header Persetujuan", "Yang Bertanggung Jawab", "Jumlah Transaksi Minimal", "Jumlah Transaksi Max", "Urutan Approval", "Keterangan Footer"};
                langMD = langID;

                String[] navID = {"Data Induk", "Dokumen", "Setup Persetujuan Dok."};
                langNav = navID;
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
        <script type="text/javascript" src="<%=approot%>/main/jquery.min.js"></script>
        <script type="text/javascript" src="<%=approot%>/main/jquery.searchabledropdown.js"></script>
        <script type="text/javascript">
            $(document).ready(function() {
                $("select").searchable();
            });
            
            $(document).ready(function() {
                $("#value").html($("#searchabledropdown :selected").text() + " (VALUE: " + $("#searchabledropdown").val() + ")");
                $("select").change(function(){
                    $("#value").html(this.options[this.selectedIndex].text + " (VALUE: " + this.value + ")");
                });
            });
        </script>
        
        <script language="JavaScript">
            
            var sysDecSymbol = "<%=sSystemDecimalSymbol%>";
            var usrDigitGroup = "<%=sUserDigitGroup%>";
            var usrDecSymbol = "<%=sUserDecimalSymbol%>";
            
            function removeChar(number){
                
                var ix;
                var result = "";
                for(ix=0; ix<number.length; ix++){
                    var xx = number.charAt(ix);                    
                    if(!isNaN(xx)){
                        result = result + xx;
                    }
                    else{
                        if(xx==',' || xx=='.'){
                            result = result + xx;
                        }
                    }
                }
                
                return result;
            }
            
            function cmdAdd(){
                document.frmapproval.hidden_approval_id.value="0";
                document.frmapproval.command.value="<%=JSPCommand.ADD%>";
                document.frmapproval.prev_command.value="<%=prevCommand%>";
                document.frmapproval.action="approval.jsp";
                document.frmapproval.submit();
            }
            function cmdAsk(oidApproval){
                
                document.frmapproval.hidden_approval_id.value=oidApproval;
                document.frmapproval.command.value="<%=JSPCommand.ASK%>";
                document.frmapproval.prev_command.value="<%=prevCommand%>";
                document.frmapproval.action="approval.jsp";
                document.frmapproval.submit();
            }
            
            function cmdConfirmDelete(oidApproval){
                document.frmapproval.hidden_approval_id.value=oidApproval;
                document.frmapproval.command.value="<%=JSPCommand.DELETE%>";
                document.frmapproval.prev_command.value="<%=prevCommand%>";
                document.frmapproval.action="approval.jsp";
                document.frmapproval.submit();
            }
            
            function cmdSave(){
                document.frmapproval.command.value="<%=JSPCommand.SAVE%>";
                document.frmapproval.prev_command.value="<%=prevCommand%>";
                document.frmapproval.action="approval.jsp";
                document.frmapproval.submit();
            }
            
            function cmdEdit(oidApproval){
                document.frmapproval.hidden_approval_id.value=oidApproval;
                document.frmapproval.command.value="<%=JSPCommand.EDIT%>";
                document.frmapproval.prev_command.value="<%=prevCommand%>";
                document.frmapproval.action="approval.jsp";
                document.frmapproval.submit();
            }
            
            function cmdCancel(oidApproval){
                document.frmapproval.hidden_approval_id.value=oidApproval;
                document.frmapproval.command.value="<%=JSPCommand.EDIT%>";
                document.frmapproval.prev_command.value="<%=prevCommand%>";
                document.frmapproval.action="approval.jsp";
                document.frmapproval.submit();
            }
            
            function cmdBack(){
                document.frmapproval.command.value="<%=JSPCommand.BACK%>";
                document.frmapproval.action="approval.jsp";
                document.frmapproval.submit();
            }
            
            function cmdListFirst(){
                document.frmapproval.command.value="<%=JSPCommand.FIRST%>";
                document.frmapproval.prev_command.value="<%=JSPCommand.FIRST%>";
                document.frmapproval.action="approval.jsp";
                document.frmapproval.submit();
            }
            
            function cmdListPrev(){
                document.frmapproval.command.value="<%=JSPCommand.PREV%>";
                document.frmapproval.prev_command.value="<%=JSPCommand.PREV%>";
                document.frmapproval.action="approval.jsp";
                document.frmapproval.submit();
            }
            
            function cmdListNext(){
                document.frmapproval.command.value="<%=JSPCommand.NEXT%>";
                document.frmapproval.prev_command.value="<%=JSPCommand.NEXT%>";
                document.frmapproval.action="approval.jsp";
                document.frmapproval.submit();
            }
            
            function cmdListLast(){
                document.frmapproval.command.value="<%=JSPCommand.LAST%>";
                document.frmapproval.prev_command.value="<%=JSPCommand.LAST%>";
                document.frmapproval.action="approval.jsp";
                document.frmapproval.submit();
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
            String navigator = "<font class=\"lvl1\">" + langNav[0] + "</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">" + langNav[2] + "</span></font>";
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
                                                        <form name="frmapproval" method ="post" action="">
                                                            <input type="hidden" name="command" value="<%=iJSPCommand%>">
                                                            <input type="hidden" name="vectSize" value="<%=vectSize%>">
                                                            <input type="hidden" name="start" value="<%=start%>">
                                                            <input type="hidden" name="prev_command" value="<%=prevCommand%>">
                                                            <input type="hidden" name="hidden_approval_id" value="<%=oidApproval%>">
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
                                                                                            <td height="22" valign="middle" colspan="3"><%= drawList(iJSPCommand, jspApproval, approval, listApproval, oidApproval, approot, langMD)%></td>
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
                if (iJSPCommand == JSPCommand.NONE || prevCommand == JSPCommand.NONE) {
                    cmd = JSPCommand.FIRST;
                } else {
                    cmd = prevCommand;
                }
            }
                                                                                                    %>
                                                                                                    <% ctrLine.setLocationImg(approot + "/images/ctr_line");
            ctrLine.initDefault();
            ctrLine.setFirstImage("<img name=\"Image23x\" border=\"0\" src=\"" + approot + "/images/first.gif\" alt=\"First\">");
            ctrLine.setPrevImage("<img name=\"Image24x\" border=\"0\" src=\"" + approot + "/images/prev.gif\" alt=\"Prev\">");
            ctrLine.setNextImage("<img name=\"Image25x\" border=\"0\" src=\"" + approot + "/images/next.gif\" alt=\"Next\">");
            ctrLine.setLastImage("<img name=\"Image26x\" border=\"0\" src=\"" + approot + "/images/last.gif\" alt=\"Last\">");

            ctrLine.setFirstOnMouseOver("MM_swapImage('Image23x','','" + approot + "/images/first2.gif',1)");
            ctrLine.setPrevOnMouseOver("MM_swapImage('Image24x','','" + approot + "/images/prev2.gif',1)");
            ctrLine.setNextOnMouseOver("MM_swapImage('Image25x','','" + approot + "/images/next2.gif',1)");
            ctrLine.setLastOnMouseOver("MM_swapImage('Image26x','','" + approot + "/images/last2.gif',1)");
                                                                                                    %>
                                                                                            <%=ctrLine.drawImageListLimit(cmd, vectSize, start, recordToGet)%> </span> </td>
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
            String scomDel = "javascript:cmdAsk('" + oidApproval + "')";
            String sconDelCom = "javascript:cmdConfirmDelete('" + oidApproval + "')";
            String scancel = "javascript:cmdEdit('" + oidApproval + "')";
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

