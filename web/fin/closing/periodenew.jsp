
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
            int recordToGet = 15;
            String msgString = "";
            int iErrCode = JSPMessage.NONE;
            String whereClause = "status='" + I_Project.STATUS_PERIOD_PRE_CLOSED + "' or status='" + I_Project.STATUS_PERIOD_OPEN + "'";
            String orderClause = " start_date desc";

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
%>


<%
//get open period id
            Periode p = new Periode();
            try {
                p = DbPeriode.getOpenPeriod();
            } catch (Exception e) {
                System.out.println(e);
            }

            if (iJSPCommand == CMD_CLOSE) {
            }

            String whereQry = "trans_date between '" + JSPFormater.formatDate(p.getStartDate(), "yyyy-MM-dd") + "' and '" + JSPFormater.formatDate(p.getEndDate(), "yyyy-MM-dd") + "' ";
            Vector pcPayment = new Vector();//DbPettycashPayment.list(0,0, whereQry + "and activity_status <> 'Posted' ", "");
            Vector pcReplenishment = new Vector();//DbPettycashReplenishment.list(0,0, whereQry + "and status <> 'Posted' ", "");
            Vector bankNonPO = new Vector();//DbBanknonpoPayment.list(0,0, whereQry + "and activity_status <> 'Posted' and type<>"+I_Project.TYPE_INT_EMPLOYEE_ADVANCE, "");
            Vector bankPO = new Vector();//DbBankpoPayment.list(0,0, whereQry + "and status <> 'Posted' ", "");
            Vector inv = new Vector();//DbInvoice.list(0,0, whereQry + "and (status <> 'Posted' or activity_status <> 'Posted') and status <> 'closed'", "");
            Vector gl = new Vector();//DbGl.list(0,0, whereQry + "and activity_status <> 'Posted'", "");

            /*if (applyActivity) {
            pcPayment = DbPettycashPayment.list(0, 0, whereQry + "and activity_status <> 'Posted' ", "");
            pcReplenishment = DbPettycashReplenishment.list(0, 0, whereQry + "and status <> 'Posted' ", "");
            bankNonPO = DbBanknonpoPayment.list(0, 0, whereQry + "and activity_status <> 'Posted' and type<>" + I_Project.TYPE_INT_EMPLOYEE_ADVANCE, "");
            bankPO = DbBankpoPayment.list(0, 0, whereQry + "and status <> 'Posted' ", "");
            inv = DbInvoice.list(0, 0, whereQry + "and (status <> 'Posted' or activity_status <> 'Posted') and status <> 'closed'", "");
            gl = DbGl.list(0, 0, whereQry + "and activity_status <> 'Posted'", "");
            }*/


            if (iJSPCommand == CMD_CLOSE) {
                //if ((pcPayment != null && pcPayment.size() > 0) || (pcReplenishment != null && pcReplenishment.size() > 0) || (bankPO != null && bankPO.size() > 0) || (bankNonPO != null && bankNonPO.size() > 0) || (inv != null && inv.size() > 0) || (gl != null && gl.size() > 0)) {
                //    response.sendRedirect("../closing/closinglist.jsp?menu_idx=13");
                //} else {
                //response.sendRedirect("periodenew.jsp?menu_idx=13&cmd="+JSPCommand.ADD);
                response.sendRedirect("../closing/openperiod.jsp?menu_idx=13");
            //}
            }

            /*** LANG ***/
            String[] langMD = {"Name", "Start Date", "End Date", "Input Tolerance", "Status", "required", "Can not open new accounting periode while pre-closed period exist"}; //0-5
            String[] langNav = {"Close Period", "Open New Accounting Period", "Yearly Closing"};
            if (lang == LANG_ID) {
                String[] langID = {"Nama", "Tanggal Mulai", "Tanggal Berakhir", "Batas Akhir Memasukkan Data", "Status", "harus diisi", "Tidak bisa membuka periode baru selama masih ada periode dengan status Pre Closed"};
                langMD = langID;
                String[] navID = {"Tutup Periode", "Buka Periode Akunting Baru", "Tutup Tahunan"};
                langNav = navID;
            }

            boolean isPreClosedPeriodExist = DbPeriode.isPreClosedPeriodExist();
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
                document.frmperiode.action="periodenew.jsp";
                document.frmperiode.submit();
            }
            
            function cmdAsk(oidPeriode){
                document.frmperiode.hidden_periode_id.value=oidPeriode;
                document.frmperiode.command.value="<%=JSPCommand.ASK%>";
                document.frmperiode.prev_command.value="<%=prevJSPCommand%>";
                document.frmperiode.action="periodenew.jsp";
                document.frmperiode.submit();
            }
            
            function cmdConfirmDelete(oidPeriode){
                document.frmperiode.hidden_periode_id.value=oidPeriode;
                document.frmperiode.command.value="<%=JSPCommand.DELETE%>";
                document.frmperiode.prev_command.value="<%=prevJSPCommand%>";
                document.frmperiode.action="periodenew.jsp";
                document.frmperiode.submit();
            }
            function cmdSave(){
                document.frmperiode.command.value="<%=JSPCommand.SAVE%>";
                document.frmperiode.prev_command.value="<%=prevJSPCommand%>";
                document.frmperiode.action="periodenew.jsp";
                document.frmperiode.submit();
            }
            
            function cmdEdit(oidPeriode){
                document.frmperiode.hidden_periode_id.value=oidPeriode;
                document.frmperiode.command.value="<%=JSPCommand.EDIT%>";
                document.frmperiode.prev_command.value="<%=prevJSPCommand%>";
                document.frmperiode.action="periodenew.jsp";
                document.frmperiode.submit();
            }
            
            function cmdCancel(oidPeriode){
                document.frmperiode.hidden_periode_id.value=oidPeriode;
                document.frmperiode.command.value="<%=JSPCommand.EDIT%>";
                document.frmperiode.prev_command.value="<%=prevJSPCommand%>";
                document.frmperiode.action="periodenew.jsp";
                document.frmperiode.submit();
            }
            
            function cmdBack(){
                document.frmperiode.command.value="<%=JSPCommand.BACK%>";
                document.frmperiode.action="periodenew.jsp";
                document.frmperiode.submit();
            }
            
            function cmdListFirst(){
                document.frmperiode.command.value="<%=JSPCommand.FIRST%>";
                document.frmperiode.prev_command.value="<%=JSPCommand.FIRST%>";
                document.frmperiode.action="periodenew.jsp";
                document.frmperiode.submit();
            }
            
            function cmdListPrev(){
                document.frmperiode.command.value="<%=JSPCommand.PREV%>";
                document.frmperiode.prev_command.value="<%=JSPCommand.PREV%>";
                document.frmperiode.action="periodenew.jsp";
                document.frmperiode.submit();
            }
            
            function cmdListNext(){
                document.frmperiode.command.value="<%=JSPCommand.NEXT%>";
                document.frmperiode.prev_command.value="<%=JSPCommand.NEXT%>";
                document.frmperiode.action="periodenew.jsp";
                document.frmperiode.submit();
            }
            
            function cmdListLast(){
                document.frmperiode.command.value="<%=JSPCommand.LAST%>";
                document.frmperiode.prev_command.value="<%=JSPCommand.LAST%>";
                document.frmperiode.action="periodenew.jsp";
                document.frmperiode.submit();
            }
            
            function cmdOpen(){
                //if(confirm('Are you sure to do this action ?\nthis action is unrecoverable, all transaction in the previews period will be locked for update')){
                document.frmperiode.action = "periodenew.jsp";
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
                                                            <input type="hidden" name="hidden_periode_id" value="<%=oidPeriode%>"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr>
                                                                    <td class="container"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="8"  colspan="3"> 
                                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="10" valign="middle" colspan="3" class="comment"></td>
                                                                                        </tr>
                                                                                        <%
            try {
                if (listPeriode.size() > 0) {
                                                                                        %>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="22" valign="middle" colspan="3"> 
                                                                                                <table width="70%" border="0" cellspacing="0" cellpadding="0">
                                                                                                    <tr> 
                                                                                                        <td class="boxed1"><%= drawList(listPeriode, oidPeriode, langMD)%></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <%  }
            } catch (Exception exc) {
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
                                                                                        <tr align="left" valign="top">
                                                                                            <td height="12" valign="middle" colspan="3">&nbsp;</td>
                                                                                        </tr>
                                                                                        
                                                                                        <%if (isPreClosedPeriodExist) {%>
                                                                                        <tr align="left" valign="top"> 
                                                                                            
                                                                                            <td height="22" valign="middle" colspan="3"><font color="#FF0000"><%=langMD[6]%></font></td>
                                                                                        </tr>
                                                                                        <%} else {%>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="22" valign="middle" colspan="3"><%if (privUpdate) {%>
                                                                                                <a href="javascript:cmdOpen()"><b>Open 
                                                                                                Period</b></a> 
                                                                                                <%}%> 
                                                                                                
                                                                                            </td>
                                                                                        </tr>
                                                                                        <%}%>
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                            <tr align="left" valign="top"> 
                                                                                
                                                                                <td height="8" valign="middle" colspan="3">&nbsp; 
                                                                                </td>
                                                                            </tr>
                                                                    </table></td>
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
