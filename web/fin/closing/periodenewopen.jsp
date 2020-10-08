
<%-- 
    Document   : periodenewopen
    Created on : Feb 21, 2014, 10:24:38 PM
    Author     : Roy Andika
--%>

<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.fms.journal.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "com.project.fms.master.*" %>
<%@ page import = "com.project.fms.transaction.*" %>
<%@ page import = "com.project.*" %>
<%@ include file = "../main/javainit.jsp" %>
<% int appObjCode = 1;%>
<%@ include file = "../main/check.jsp" %>
<%
            boolean priv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MENU_CLOSING, AppMenu.M2_MENU_CLOSING_PERIOD);
            boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_CLOSING, AppMenu.M2_MENU_CLOSING_PERIOD, AppMenu.PRIV_VIEW);
            boolean privUpdate = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_CLOSING, AppMenu.M2_MENU_CLOSING_PERIOD, AppMenu.PRIV_UPDATE);
            boolean privAdd = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_CLOSING, AppMenu.M2_MENU_CLOSING_PERIOD, AppMenu.PRIV_ADD);
            boolean privDelete = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_CLOSING, AppMenu.M2_MENU_CLOSING_PERIOD, AppMenu.PRIV_DELETE);
%>
<!-- Jsp Block -->
<%!
    final static int CMD_CLOSE = 1;

    public String drawList(Vector objectClass, long periodeId, String[] lang) {
        JSPList cmdist = new JSPList();
        cmdist.setAreaWidth("100%");
        cmdist.setListStyle("listgen");
        cmdist.setTitleStyle("tablehdr");
        cmdist.setCellStyle("tablecell");
        cmdist.setCellStyle1("tablecell1");
        cmdist.setHeaderStyle("tablehdr");
        cmdist.addHeader(lang[0], "20%");
        cmdist.addHeader(lang[1], "20%");
        cmdist.addHeader(lang[2], "20%");
        cmdist.addHeader(lang[3], "20%");
        cmdist.addHeader(lang[4], "20%");

        cmdist.setLinkRow(-1);
        cmdist.setLinkSufix("");
        Vector lstData = cmdist.getData();
        Vector lstLinkData = cmdist.getLinkData();
        cmdist.setLinkPrefix("javascript:cmdEdit('");
        cmdist.setLinkSufix("')");
        cmdist.reset();
        int index = -1;

        for (int i = 0; i < objectClass.size(); i++) {
            Periode periode = (Periode) objectClass.get(i);
            Vector rowx = new Vector();
            if (periodeId == periode.getOID()) {
                index = i;
            }

            rowx.add(periode.getName());

            String str_dt_StartDate = "";
            try {
                Date dt_StartDate = periode.getStartDate();
                if (dt_StartDate == null) {
                    dt_StartDate = new Date();
                }

                str_dt_StartDate = JSPFormater.formatDate(dt_StartDate, "dd MMMM yyyy");
            } catch (Exception e) {
                str_dt_StartDate = "";
            }

            rowx.add(str_dt_StartDate);

            String str_dt_EndDate = "";
            try {
                Date dt_EndDate = periode.getEndDate();
                if (dt_EndDate == null) {
                    dt_EndDate = new Date();
                }

                str_dt_EndDate = JSPFormater.formatDate(dt_EndDate, "dd MMMM yyyy");
            } catch (Exception e) {
                str_dt_EndDate = "";
            }

            rowx.add(str_dt_EndDate);

            String str_dt_InputTolerance = "";
            try {
                Date dt_InputTolerance = periode.getInputTolerance();
                if (dt_InputTolerance == null) {
                    dt_InputTolerance = new Date();
                }

                str_dt_InputTolerance = JSPFormater.formatDate(dt_InputTolerance, "dd MMMM yyyy");
            } catch (Exception e) {
                str_dt_InputTolerance = "";
            }

            rowx.add(str_dt_InputTolerance);

            rowx.add("<div align=\"center\">" + periode.getStatus() + "</div>");

            lstData.add(rowx);
            lstLinkData.add(String.valueOf(periode.getOID()));
        }

        return cmdist.draw(index);
    }

%>
<%
            int cmdx = JSPRequestValue.requestInt(request, "cmd");
            int iJSPCommand = JSPRequestValue.requestCommand(request);
            if (cmdx != 0) {
                iJSPCommand = cmdx;
            }
            int start = JSPRequestValue.requestInt(request, "start");
            int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
            long oidPeriode = JSPRequestValue.requestLong(request, "hidden_periode_id");

            /*variable declaration*/
            int recordToGet = 20;
            String msgString = "";
            int iErrCode = JSPMessage.NONE;
            String whereClause = "";
            String orderClause = DbPeriode.colNames[DbPeriode.COL_START_DATE] + " desc";

            CmdPeriode ctrlPeriode = new CmdPeriode(request);
            JSPLine ctrLine = new JSPLine();
            Vector listPeriode = new Vector(1, 1);

            /*switch statement */
            iErrCode = ctrlPeriode.action(iJSPCommand, oidPeriode);
            /* end switch*/
            JspPeriode jspPeriode = ctrlPeriode.getForm();

            /*count list All Periode*/
            int vectSize = DbPeriode.getCount(whereClause);

            Periode periode = ctrlPeriode.getPeriode();
            msgString = ctrlPeriode.getMessage();


            if ((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV) ||
                    (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)) {
                start = ctrlPeriode.actionList(iJSPCommand, start, vectSize, recordToGet);
            }
            /* end switch list*/

            /* get record to display */
            listPeriode = DbPeriode.list(start, recordToGet, whereClause, orderClause);

            /*handle condition if size of record to display = 0 and start > 0 	after delete*/
            if (listPeriode.size() < 1 && start > 0) {
                if (vectSize - recordToGet > recordToGet) {
                    start = start - recordToGet;
                } //go to JSPCommand.PREV
                else {
                    start = 0;
                    iJSPCommand = JSPCommand.FIRST;
                    prevJSPCommand = JSPCommand.FIRST; //go to JSPCommand.FIRST
                }
                listPeriode = DbPeriode.list(start, recordToGet, whereClause, orderClause);
            }

            /*** LANG ***/
            String[] langMD = {"Name", "Start Date", "End Date", "Input Tolerance", "Status", "required", "Can not open new accounting periode while pre-closed period exist"}; //0-5
            String[] langNav = {"Close Period", "Open New Accounting Period", "Yearly Closing"};
            if (lang == LANG_ID) {
                String[] langID = {"Nama", "Tanggal Mulai", "Tanggal Berakhir", "Batas Akhir Input", "Status", "harus diisi", "Tidak bisa membuka periode baru selama masih ada periode dengan status Pre Closed"};
                langMD = langID;
                String[] navID = {"Tutup Periode", "Buka Periode Akunting Baru", "Tutup Tahunan"};
                langNav = navID;
            }
%>

<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
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
            
            function cmdAdd(){
                document.frmperiode.hidden_periode_id.value="0";
                document.frmperiode.command.value="<%=JSPCommand.ADD%>";
                document.frmperiode.prev_command.value="<%=prevJSPCommand%>";
                document.frmperiode.action="periodenewopen.jsp";
                document.frmperiode.submit();
            }
            
            function cmdAsk(oidPeriode){
                document.frmperiode.hidden_periode_id.value=oidPeriode;
                document.frmperiode.command.value="<%=JSPCommand.ASK%>";
                document.frmperiode.prev_command.value="<%=prevJSPCommand%>";
                document.frmperiode.action="periodenewopen.jsp";
                document.frmperiode.submit();
            }
            
            function cmdConfirmDelete(oidPeriode){
                document.frmperiode.hidden_periode_id.value=oidPeriode;
                document.frmperiode.command.value="<%=JSPCommand.DELETE%>";
                document.frmperiode.prev_command.value="<%=prevJSPCommand%>";
                document.frmperiode.action="periodenewopen.jsp";
                document.frmperiode.submit();
            }
            function cmdSave(){
                document.frmperiode.command.value="<%=JSPCommand.SAVE%>";
                document.frmperiode.prev_command.value="<%=prevJSPCommand%>";
                document.frmperiode.action="periodenewopen.jsp";
                document.frmperiode.submit();
            }
            
            function cmdEdit(oidPeriode){
                document.frmperiode.hidden_periode_id.value=oidPeriode;
                document.frmperiode.command.value="<%=JSPCommand.EDIT%>";
                document.frmperiode.prev_command.value="<%=prevJSPCommand%>";
                document.frmperiode.action="periodenewopen.jsp";
                document.frmperiode.submit();
            }
            
            function cmdCancel(oidPeriode){
                document.frmperiode.hidden_periode_id.value=oidPeriode;
                document.frmperiode.command.value="<%=JSPCommand.EDIT%>";
                document.frmperiode.prev_command.value="<%=prevJSPCommand%>";
                document.frmperiode.action="periodenewopen.jsp";
                document.frmperiode.submit();
            }
            
            function cmdBack(){
                document.frmperiode.command.value="<%=JSPCommand.BACK%>";
                document.frmperiode.action="periodenewopen.jsp";
                document.frmperiode.submit();
            }
            
            function cmdListFirst(){
                document.frmperiode.command.value="<%=JSPCommand.FIRST%>";
                document.frmperiode.prev_command.value="<%=JSPCommand.FIRST%>";
                document.frmperiode.action="periodenewopen.jsp";
                document.frmperiode.submit();
            }
            
            function cmdListPrev(){
                document.frmperiode.command.value="<%=JSPCommand.PREV%>";
                document.frmperiode.prev_command.value="<%=JSPCommand.PREV%>";
                document.frmperiode.action="periodenewopen.jsp";
                document.frmperiode.submit();
            }
            
            function cmdListNext(){
                document.frmperiode.command.value="<%=JSPCommand.NEXT%>";
                document.frmperiode.prev_command.value="<%=JSPCommand.NEXT%>";
                document.frmperiode.action="periodenewopen.jsp";
                document.frmperiode.submit();
            }
            
            function cmdListLast(){
                document.frmperiode.command.value="<%=JSPCommand.LAST%>";
                document.frmperiode.prev_command.value="<%=JSPCommand.LAST%>";
                document.frmperiode.action="periodenewopen.jsp";
                document.frmperiode.submit();
            }
            
            function cmdOpen(){
                //if(confirm('Are you sure to do this action ?\nthis action is unrecoverable, all transaction in the previews period will be locked for update')){
                document.frmperiode.action = "periodenewopen.jsp";
                document.frmperiode.command.value="<%=CMD_CLOSE%>";
                document.frmperiode.submit();
                //}
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
    <body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','../images/new2.gif','../images/closeperiode2.gif')">
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
                  <%@ include file="../calendar/calendarframe.jsp"%>
                                            <!-- #EndEditable -->
                                        </td>
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
                                                        <form name="frmperiode" method ="post" action="">
                                                            <input type="hidden" name="command" value="<%=iJSPCommand%>">
                                                            <input type="hidden" name="vectSize" value="<%=vectSize%>">
                                                            <input type="hidden" name="start" value="<%=start%>">
                                                            <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">                                                            
                                                            <input type="hidden" name="hidden_periode_id" value="<%=oidPeriode%>">
                                                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr>
                                                                    <td class="container">
                                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="8"  colspan="3"> 
                                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="10" valign="middle" colspan="3" class="comment"></td>
                                                                                        </tr>
                                                                                        
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="22" valign="middle" colspan="3"> 
                                                                                                <table width="700" border="0" cellspacing="0" cellpadding="0">
                                                                                                    <tr> 
                                                                                                        <td class="boxed1">
                                                                                                            <table width="100%" border="0" cellspacing="1" cellpadding="0">
                                                                                                                <tr height="25"> 
                                                                                                                    <td class="tablehdr" width="25">No</td>
                                                                                                                    <td class="tablehdr"><%=langMD[0]%></td>
                                                                                                                    <td class="tablehdr" width="19%"><%=langMD[1]%></td>
                                                                                                                    <td class="tablehdr" width="19%"><%=langMD[2]%></td>
                                                                                                                    <td class="tablehdr" width="19%"><%=langMD[3]%></td>
                                                                                                                    <td class="tablehdr" width="10%">Table</td>
                                                                                                                    <td class="tablehdr" width="80"><%=langMD[4]%></td>
                                                                                                                </tr>
                                                                                                                <%
            for (int i = 0; i < listPeriode.size(); i++) {

                Periode per = (Periode) listPeriode.get(i);
                String style = "";
                if (i % 2 == 0) {
                    style = "tablecell";
                } else {
                    style = "tablecell1";
                }

                String str_dt_StartDate = "";
                try {
                    Date dt_StartDate = per.getStartDate();
                    if (dt_StartDate == null) {
                        dt_StartDate = new Date();
                    }
                    str_dt_StartDate = JSPFormater.formatDate(dt_StartDate, "dd MMM yyyy");
                } catch (Exception e) {
                    str_dt_StartDate = "";
                }

                String str_dt_EndDate = "";
                try {
                    Date dt_EndDate = per.getEndDate();
                    if (dt_EndDate == null) {
                        dt_EndDate = new Date();
                    }

                    str_dt_EndDate = JSPFormater.formatDate(dt_EndDate, "dd MMM yyyy");
                } catch (Exception e) {
                    str_dt_EndDate = "";
                }

                String str_dt_InputTolerance = "";
                try {
                    Date dt_InputTolerance = per.getInputTolerance();
                    if (dt_InputTolerance == null) {
                        dt_InputTolerance = new Date();
                    }

                    str_dt_InputTolerance = JSPFormater.formatDate(dt_InputTolerance, "dd MMM yyyy");
                } catch (Exception e) {
                    str_dt_InputTolerance = "";
                }
                                                                                                                %>
                                                                                                                <tr height="20">
                                                                                                                    <td class="<%=style%>" align="center"><%=(start + i + 1)%></td>
                                                                                                                    <%if (per.getStatus().compareToIgnoreCase(I_Project.STATUS_PERIOD_CLOSED) == 0) {%>
                                                                                                                    <td class="<%=style%>"><%=per.getName()%></td>
                                                                                                                    <%} else {%>
                                                                                                                    <td class="<%=style%>"><a href="javascript:cmdEdit('<%=per.getOID()%>')"> <%=per.getName()%></a></td>
                                                                                                                    <%}%>
                                                                                                                    
                                                                                                                    <td class="<%=style%>" align="center"><%=str_dt_StartDate%></td>
                                                                                                                    <td class="<%=style%>" align="center"><%=str_dt_EndDate%></td>
                                                                                                                    <td class="<%=style%>" align="center"><%=str_dt_InputTolerance%></td>
                                                                                                                    <td class="<%=style%>" align="center"><%=per.getTableName() %></td>
                                                                                                                    <%if (per.getStatus().compareToIgnoreCase(I_Project.STATUS_PERIOD_OPEN) == 0) {%>
                                                                                                                    <td bgcolor="61BA4D" align="center" class="fontarial" ><font size="1"> <%=per.getStatus().toUpperCase()%></font></td>
                                                                                                                    <%} else if (per.getStatus().compareToIgnoreCase(I_Project.STATUS_PERIOD_PRE_CLOSED) == 0) {%>
                                                                                                                    <td bgcolor="EF9E3E" align="center" class="fontarial" ><font size="1"> <%=per.getStatus().toUpperCase()%></font></td>
                                                                                                                    <%} else if (per.getStatus().compareToIgnoreCase(I_Project.STATUS_PERIOD_CLOSED) == 0) {%>
                                                                                                                    <td bgcolor="EE6022" align="center" class="fontarial" ><font size="1"> <%=per.getStatus().toUpperCase()%></font></td>
                                                                                                                    <%} else if (per.getStatus().compareToIgnoreCase(I_Project.STATUS_PERIOD_PREPARED_OPEN) == 0) {%>
                                                                                                                    <td bgcolor="CCCCCC" align="center" class="fontarial" ><font size="1"> <%=per.getStatus().toUpperCase()%></font></td>
                                                                                                                    <%}%>
                                                                                                                </tr>
                                                                                                                <%}%>
                                                                                                            </table>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <tr>
                                                                                                        <td height="8" align="left" class="command" valign="top"> 
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
                                                                                <%=ctrLine.drawImageListLimit(cmd, vectSize, start, recordToGet)%> </span> 
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr height="30">
                                                                                            
                                                                                            <td height="8" align="left" class="command" valign="top">&nbsp;</td> 
                                                                                        </tr>
                                                                                        <%if ((iJSPCommand != JSPCommand.ADD && iJSPCommand != JSPCommand.ASK && iJSPCommand != JSPCommand.EDIT) && (jspPeriode.errorSize() < 1)) {
                if (privAdd) {%>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td colspan="3"> 
                                                                                                <table cellpadding="0" cellspacing="0" border="0">
                                                                                                    <tr> 
                                                                                                        <td width="4"><img src="<%=approot%>/images/spacer.gif" width="1" height="1"></td>
                                                                                                        <td width="20"><a href="javascript:cmdAdd()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image261','','<%=approot%>/images/ctr_line/BtnNewOn.jpg',1)"><img name="Image261" border="0" src="<%=approot%>/images/ctr_line/BtnNew.jpg" width="20"  alt="Add new data"></a></td>
                                                                                                        <td width="6"><img src="<%=approot%>/images/spacer.gif" width="1" height="1"></td>
                                                                                                        <td height="22" valign="middle" colspan="3" width="951"> 
                                                                                                            <%if (privAdd) {%>
                                                                                                            <a href="javascript:cmdAdd()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new21','','../images/new2.gif',1)">Add New</a> 
                                                                                                            <%}%>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <%}
            }%>
                                                                                        <%
            try {

                if ((iJSPCommand == JSPCommand.ADD) || (iJSPCommand == JSPCommand.SAVE) && (jspPeriode.errorSize() > 0) || (iJSPCommand == JSPCommand.EDIT) || (iJSPCommand == JSPCommand.ASK)) {
                                                                                        %>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="22" valign="middle" colspan="3" class="boxed1"> 
                                                                                                <table width="300" border="0" cellspacing="2" cellpadding="0">
                                                                                                    <tr height="22"> 
                                                                                                        <td class="fontarial" width="100" bgcolor="#CCCCCC">&nbsp;<%=langMD[0]%></td>    
                                                                                                        <td class="fontarial" width="1">:</td>  
                                                                                                        <td ><input type="text" name="<%=jspPeriode.colNames[JspPeriode.JSP_NAME]%>" value="<%=periode.getName()%>" class="fontarial"></td>    
                                                                                                    </tr>
                                                                                                    <tr height="22"> 
                                                                                                        <td class="fontarial" bgcolor="#CCCCCC">&nbsp;<%=langMD[1]%></td>    
                                                                                                        <td class="fontarial">:</td>  
                                                                                                        <td ><table border="0" cellspacing="0" cellpadding="0">  
                                                                                                                <tr>
                                                                                                                    <td><input name="<%=jspPeriode.colNames[JspPeriode.JSP_START_DATE]%>" value="<%=JSPFormater.formatDate((periode.getStartDate() == null ? new Date() : periode.getStartDate()), "dd/MM/yyyy")%>" size="11" readOnly></td>
                                                                                                                    <td><a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmperiode.<%=jspPeriode.colNames[JspPeriode.JSP_START_DATE]%>);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a></td>                                                                                                                                
                                                                                                                </tr>
                                                                                                            </table>
                                                                                                        </td>    
                                                                                                    </tr>
                                                                                                    <tr height="22"> 
                                                                                                        <td class="fontarial" bgcolor="#CCCCCC">&nbsp;<%=langMD[2]%></td>    
                                                                                                        <td class="fontarial">:</td>  
                                                                                                        <td >
                                                                                                            <table border="0" cellspacing="0" cellpadding="0">  
                                                                                                                <tr>
                                                                                                                    <td><input name="<%=jspPeriode.colNames[JspPeriode.JSP_END_DATE]%>" value="<%=JSPFormater.formatDate((periode.getEndDate() == null ? new Date() : periode.getEndDate()), "dd/MM/yyyy")%>" size="11" readOnly></td>
                                                                                                                    <td><a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmperiode.<%=jspPeriode.colNames[JspPeriode.JSP_END_DATE]%>);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a></td>                                                                                                                                
                                                                                                                </tr>
                                                                                                            </table>
                                                                                                        </td>    
                                                                                                    </tr>
                                                                                                    <tr height="22"> 
                                                                                                        <td class="fontarial" bgcolor="#CCCCCC">&nbsp;<%=langMD[3]%></td> 
                                                                                                        <td class="fontarial">:</td>  
                                                                                                        <td >
                                                                                                            <table border="0" cellspacing="0" cellpadding="0">  
                                                                                                                <tr>
                                                                                                                    <td><input name="<%=jspPeriode.colNames[JspPeriode.JSP_INPUT_TOLERANCE]%>" value="<%=JSPFormater.formatDate((periode.getInputTolerance() == null ? new Date() : periode.getInputTolerance()), "dd/MM/yyyy")%>" size="11" readOnly></td>
                                                                                                                    <td><a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmperiode.<%=jspPeriode.colNames[JspPeriode.JSP_INPUT_TOLERANCE]%>);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a></td>                                                                                                                                
                                                                                                                </tr>
                                                                                                            </table>
                                                                                                        </td>    
                                                                                                    </tr>
                                                                                                    <tr height="22"> 
                                                                                                        <td class="fontarial" bgcolor="#CCCCCC">&nbsp;<%=langMD[4]%></td> 
                                                                                                        <td class="fontarial">:</td>  
                                                                                                        <td >
                                                                                                            <select name="<%=jspPeriode.colNames[JspPeriode.JSP_STATUS]%>" class="fontarial">
                                                                                                                <option value="<%=I_Project.STATUS_PERIOD_OPEN%>"  <%if (periode.getStatus().equals(I_Project.STATUS_PERIOD_OPEN)) {%> selected<%}%> > <%=I_Project.STATUS_PERIOD_OPEN.toUpperCase()%></option>
                                                                                                                <option value="<%=I_Project.STATUS_PERIOD_PRE_CLOSED%>" <%if (periode.getStatus().equals(I_Project.STATUS_PERIOD_PRE_CLOSED)) {%> selected<%}%> ><%=I_Project.STATUS_PERIOD_PRE_CLOSED.toUpperCase()%></option>
                                                                                                                <option value="<%=I_Project.STATUS_PERIOD_PREPARED_OPEN%>" <%if (periode.getStatus().equals(I_Project.STATUS_PERIOD_PREPARED_OPEN)) {%> selected<%}%> ><%=I_Project.STATUS_PERIOD_PREPARED_OPEN.toUpperCase()%></option>
                                                                                                            </select>
                                                                                                        </td>    
                                                                                                    </tr>
                                                                                                    <tr height="22"> 
                                                                                                        <td class="fontarial" bgcolor="#CCCCCC">&nbsp;Table</td> 
                                                                                                        <td class="fontarial">:</td>  
                                                                                                        <% 
                                                                                                        if(periode.getTableName()==null){
                                                                                                            periode.setTableName("");
                                                                                                        }
                                                                                                                
                                                                                                                
                                                                                                                
                                                                                                        %>
                                                                                                        <td >
                                                                                                            <select name="<%=jspPeriode.colNames[JspPeriode.JSP_TABLE_NAME]%>" class="fontarial">
                                                                                                                <option value="0"  <%if (periode.getTableName().equals("")) {%> selected<%}%> > - none -</option>
                                                                                                                <%for(int t = 0 ; t < DbPeriode.strValuePeriods.length;t++){%>
                                                                                                                    <option value="<%=DbPeriode.strValuePeriods[t]%>"  <%if (periode.getTableName().equals(DbPeriode.strValuePeriods[t])) {%> selected<%}%> ><%=DbPeriode.strKeyPeriods[t]%></option>
                                                                                                                <%}%>
                                                                                                            </select>
                                                                                                        </td>    
                                                                                                    </tr>
                                                                                                </table>        
                                                                                            </td>      
                                                                                        </tr> 
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="22" valign="middle" colspan="3">&nbsp;</td>      
                                                                                        </tr> 
                                                                                        <tr align="left" valign="top">
                                                                                            <td colspan="3" class="command"> 
                                                                                                <%
            ctrLine.setLocationImg(approot + "/images/ctr_line");
            ctrLine.initDefault();
            ctrLine.setTableWidth("40%");
            String scomDel = "javascript:cmdAsk('" + oidPeriode + "')";
            String sconDelCom = "javascript:cmdConfirmDelete('" + oidPeriode + "')";
            String scancel = "javascript:cmdEdit('" + oidPeriode + "')";
            ctrLine.setBackCaption("Back");
            ctrLine.setJSPCommandStyle("buttonlink");
            ctrLine.setDeleteCaption("");
            ctrLine.setSaveCaption("save");            

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
            
            ctrLine.setAddCaption("");
            ctrLine.setDeleteJSPCommand("");

                                                                                                %>
                                                                                                <%= ctrLine.drawImage(iJSPCommand, iErrCode, msgString)%> 
                                                                                            </td>
                                                                                        </tr>
                                                                                        <%}%>
                                                                                        <%
            } catch (Exception exc) {
            }%>
                                                                                       
                                                                                        
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                            <tr align="left" valign="top"> 
                                                                                
                                                                                <td height="8" valign="middle" colspan="3">&nbsp; 
                                                                                </td>
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
