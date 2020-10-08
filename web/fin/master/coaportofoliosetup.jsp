
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "com.project.fms.master.*" %>
<%@ page import = "com.project.fms.activity.*" %>
<%@ page import = "com.project.system.*" %>
<%@ page import = "com.project.*" %>
<%@ include file = "../main/javainit.jsp" %>
<% int appObjCode = 1; %>
<%@ include file = "../main/check.jsp" %>
<%            
            boolean priv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_ACCOUNTING);
            boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_ACCOUNTING, AppMenu.PRIV_VIEW);            
            boolean privUpdate = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_ACCOUNTING, AppMenu.PRIV_UPDATE);
            boolean privAdd = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_ACCOUNTING, AppMenu.PRIV_ADD);
            boolean privDelete = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_ACCOUNTING, AppMenu.PRIV_DELETE);            
%>
<!-- Jsp Block -->
<%!
    public String drawList(Vector objectClass, long portofolioSetupId, String[] lang) {
        
        JSPList ctrlist = new JSPList();
        ctrlist.setAreaWidth("100%");
        ctrlist.setListStyle("listgen");
        ctrlist.setTitleStyle("tablehdr");
        ctrlist.setCellStyle("tablecell");
        ctrlist.setHeaderStyle("tablehdr");
        //ctrlist.addHeader("Periode Id","12%");
        ctrlist.addHeader(lang[2], "10%");
        ctrlist.addHeader(lang[3], "35%");
        ctrlist.addHeader(lang[4], "35%");
        ctrlist.addHeader(lang[5], "20%");

        ctrlist.setLinkRow(0);
        ctrlist.setLinkSufix("");
        Vector lstData = ctrlist.getData();
        Vector lstLinkData = ctrlist.getLinkData();
        ctrlist.setLinkPrefix("javascript:cmdEdit('");
        ctrlist.setLinkSufix("')");
        ctrlist.reset();
        int index = -1;

        for (int i = 0; i < objectClass.size(); i++) {
            
            CoaPortofolioSetup coaPortofolioSetup = (CoaPortofolioSetup) objectClass.get(i);
            Vector rowx = new Vector();
            if (portofolioSetupId == coaPortofolioSetup.getOID()) {
                index = i;
            }

            //rowx.add(String.valueOf(coaPortofolioSetup.getPeriodeId()));

            rowx.add(DbCoaPortofolioSetup.strPortoType[coaPortofolioSetup.getType()]);

            Coa coa = new Coa();
            /*			
            try{
            coa = DbCoa.fetchExc(coaPortofolioSetup.getCoaRefId());
            }
            catch(Exception e){
            }
             */

            //rowx.add((coaPortofolioSetup.getCoaRefId()!=0) ? coa.getCode()+" - "+coa.getName() : "NONE");

            coa = new Coa();
            try {
                coa = DbCoa.fetchExc(coaPortofolioSetup.getCoaRevenueId());
            } catch (Exception e) {
            }

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

            rowx.add((coaPortofolioSetup.getCoaRevenueId() != 0) ? str + coa.getCode() + " - " + coa.getName() : "");

            coa = new Coa();
            try {
                coa = DbCoa.fetchExc(coaPortofolioSetup.getCoaExpenseId());
            } catch (Exception e) {
            }

            str = "";
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
            rowx.add((coaPortofolioSetup.getCoaExpenseId() != 0) ? str + coa.getCode() + " - " + coa.getName() : "");

            //rowx.add(String.valueOf(coaPortofolioSetup.getLevel()));
            
            //rowx.add(String.valueOf(coaPortofolioSetup.getStatus()));

            //rowx.add(coaPortofolioSetup.getCoaStatus());

            rowx.add(coaPortofolioSetup.getNote());

            lstData.add(rowx);
            lstLinkData.add(String.valueOf(coaPortofolioSetup.getOID()));
        }

        return ctrlist.draw(index);
    }

%>
<%
            int iJSPCommand = JSPRequestValue.requestCommand(request);
            int start = JSPRequestValue.requestInt(request, "start");
            int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
            long oidCoaPortofolioSetup = JSPRequestValue.requestLong(request, "hidden_portofolio_setup_id");
            long periodeId = JSPRequestValue.requestLong(request, JspCoaPortofolioSetup.colNames[JspCoaPortofolioSetup.JSP_PERIODE_ID]);

            String wherex = "status='" + I_Project.ACCOUNT_LEVEL_HEADER + "'" +
                    " and (account_group='" + I_Project.ACC_GROUP_REVENUE + "'" +
                    " or account_group='" + I_Project.ACC_GROUP_EXPENSE + "'" +
                    " or account_group='" + I_Project.ACC_GROUP_OTHER_REVENUE + "'" +
                    " or account_group='" + I_Project.ACC_GROUP_OTHER_EXPENSE + "')";

            Vector coas = DbCoa.list(0, 0, wherex, "code");

            wherex = //"status='"+I_Project.ACCOUNT_LEVEL_HEADER+"'"+
                    //" and (account_group='"+I_Project.ACC_GROUP_REVENUE+"'"+
                    " (account_group='" + I_Project.ACC_GROUP_REVENUE + "'" +
                    " or account_group='" + I_Project.ACC_GROUP_OTHER_REVENUE + "')";

            Vector coaRevenues = DbCoa.list(0, 0, wherex, "code");

            wherex = //"status='"+I_Project.ACCOUNT_LEVEL_HEADER+"'"+
                    //" and (account_group='"+I_Project.ACC_GROUP_EXPENSE+"'"+
                    " (account_group='" + I_Project.ACC_GROUP_EXPENSE + "'" +
                    " or account_group='" + I_Project.ACC_GROUP_OTHER_EXPENSE + "')";

            Vector coaExpenses = DbCoa.list(0, 0, wherex, "code");

            Vector periodes = DbPeriode.list(0, 0, "", "start_date desc");
            boolean isOpen = false;
            if (periodeId == 0) {
                if (periodes != null && periodes.size() > 0) {
                    Periode p = (Periode) periodes.get(0);
                    periodeId = p.getOID();
                    if (p.getStatus().equals("Open")) {
                        isOpen = true;
                    }
                }
            } else {
                try {
                    Periode p = DbPeriode.fetchExc(periodeId);
                    if (p.getStatus().equals("Open")) {
                        isOpen = true;
                    }
                } catch (Exception e) {
                }
            }

            /*variable declaration*/
            int recordToGet = 10000;
            String msgString = "";
            int iErrCode = JSPMessage.NONE;
            String whereClause = "periode_id=" + periodeId;
            String orderClause = "type, coa_code";

            CmdCoaPortofolioSetup ctrlCoaPortofolioSetup = new CmdCoaPortofolioSetup(request);
            JSPLine ctrLine = new JSPLine();
            Vector listCoaPortofolioSetup = new Vector(1, 1);

            /*switch statement */
            iErrCode = ctrlCoaPortofolioSetup.action(iJSPCommand, oidCoaPortofolioSetup);
            /* end switch*/
            JspCoaPortofolioSetup jspCoaPortofolioSetup = ctrlCoaPortofolioSetup.getForm();

            /*count list All CoaPortofolioSetup*/
            int vectSize = DbCoaPortofolioSetup.getCount(whereClause);

            CoaPortofolioSetup coaPortofolioSetup = ctrlCoaPortofolioSetup.getCoaPortofolioSetup();
            msgString = ctrlCoaPortofolioSetup.getMessage();

//copy previous setup
            if (iJSPCommand == JSPCommand.POST) {
                DbCoaPortofolioSetup.copyPreviousSetup(periodeId);
                DbCoaPortofolioSetup.setPortofolioValue(periodeId);
            }


            if ((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV) ||
                    (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)) {
                start = ctrlCoaPortofolioSetup.actionList(iJSPCommand, start, vectSize, recordToGet);
            }
            /* end switch list*/

            /* get record to display */
            listCoaPortofolioSetup = DbCoaPortofolioSetup.list(start, recordToGet, whereClause, orderClause);

            /*handle condition if size of record to display = 0 and start > 0 	after delete*/
            if (listCoaPortofolioSetup.size() < 1 && start > 0) {
                if (vectSize - recordToGet > recordToGet) {
                    start = start - recordToGet;
                } //go to JSPCommand.PREV
                else {
                    start = 0;
                    iJSPCommand = JSPCommand.FIRST;
                    prevJSPCommand = JSPCommand.FIRST; //go to JSPCommand.FIRST
                }
                listCoaPortofolioSetup = DbCoaPortofolioSetup.list(start, recordToGet, whereClause, orderClause);
            }

            /*** LANG ***/
            String[] langMD = {"PERIOD", "required", "Portofolio Type", "CoA Revenue", "CoA Expense", "Note"};//0-5

            String[] langNav = {"Masterdata", "Portfolio Setup"};

            if (lang == LANG_ID) {
                String[] langID = {"PERIODE", "harus diisi", "Tipe Portofolio", "Daftar Perkiraan Pendapatan", "Perkiraan Biaya", "Catatan"};
                langMD = langID;

                String[] navID = {"Data Induk", "Portofolio Setup"};
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
        <title>finance</title>        
        <script language="JavaScript">            
            <%if (iJSPCommand == JSPCommand.ADD || iJSPCommand == JSPCommand.EDIT || iErrCode != 0 || true) {%>						
                window.location="#go";
            <%}%>
            
            function cmdCopy(){
                if(confirm("Warning!,this action will replace current setup with previeous periode setup, \nare you sure ?")){
                    document.frmcoaportofoliosetup.hidden_portofolio_setup_id.value="0";
                    document.frmcoaportofoliosetup.command.value="<%=JSPCommand.POST%>";
                    document.frmcoaportofoliosetup.prev_command.value="<%=prevJSPCommand%>";
                    document.frmcoaportofoliosetup.action="coaportofoliosetup.jsp";
                    document.frmcoaportofoliosetup.submit();
                }
            }
            
            function cmdChangePeriod(){
                document.frmcoaportofoliosetup.hidden_portofolio_setup_id.value="0";
                document.frmcoaportofoliosetup.command.value="<%=JSPCommand.LIST%>";
                document.frmcoaportofoliosetup.prev_command.value="<%=prevJSPCommand%>";
                document.frmcoaportofoliosetup.action="coaportofoliosetup.jsp";
                document.frmcoaportofoliosetup.submit();
            }
            
            function cmdAdd(){
                document.frmcoaportofoliosetup.hidden_portofolio_setup_id.value="0";
                document.frmcoaportofoliosetup.command.value="<%=JSPCommand.ADD%>";
                document.frmcoaportofoliosetup.prev_command.value="<%=prevJSPCommand%>";
                document.frmcoaportofoliosetup.action="coaportofoliosetup.jsp";
                document.frmcoaportofoliosetup.submit();
            }
            
            function cmdAsk(oidCoaPortofolioSetup){
                document.frmcoaportofoliosetup.hidden_portofolio_setup_id.value=oidCoaPortofolioSetup;
                document.frmcoaportofoliosetup.command.value="<%=JSPCommand.ASK%>";
                document.frmcoaportofoliosetup.prev_command.value="<%=prevJSPCommand%>";
                document.frmcoaportofoliosetup.action="coaportofoliosetup.jsp";
                document.frmcoaportofoliosetup.submit();
            }
            
            function cmdConfirmDelete(oidCoaPortofolioSetup){
                document.frmcoaportofoliosetup.hidden_portofolio_setup_id.value=oidCoaPortofolioSetup;
                document.frmcoaportofoliosetup.command.value="<%=JSPCommand.DELETE%>";
                document.frmcoaportofoliosetup.prev_command.value="<%=prevJSPCommand%>";
                document.frmcoaportofoliosetup.action="coaportofoliosetup.jsp";
                document.frmcoaportofoliosetup.submit();
            }
            function cmdSave(){
                document.frmcoaportofoliosetup.command.value="<%=JSPCommand.SAVE%>";
                document.frmcoaportofoliosetup.prev_command.value="<%=prevJSPCommand%>";
                document.frmcoaportofoliosetup.action="coaportofoliosetup.jsp";
                document.frmcoaportofoliosetup.submit();
            }
            
            function cmdEdit(oidCoaPortofolioSetup){
                document.frmcoaportofoliosetup.hidden_portofolio_setup_id.value=oidCoaPortofolioSetup;
                document.frmcoaportofoliosetup.command.value="<%=JSPCommand.EDIT%>";
                document.frmcoaportofoliosetup.prev_command.value="<%=prevJSPCommand%>";
                document.frmcoaportofoliosetup.action="coaportofoliosetup.jsp";
                document.frmcoaportofoliosetup.submit();
            }
            
            function cmdCancel(oidCoaPortofolioSetup){
                document.frmcoaportofoliosetup.hidden_portofolio_setup_id.value=oidCoaPortofolioSetup;
                document.frmcoaportofoliosetup.command.value="<%=JSPCommand.EDIT%>";
                document.frmcoaportofoliosetup.prev_command.value="<%=prevJSPCommand%>";
                document.frmcoaportofoliosetup.action="coaportofoliosetup.jsp";
                document.frmcoaportofoliosetup.submit();
            }
            
            function cmdBack(){
                document.frmcoaportofoliosetup.command.value="<%=JSPCommand.BACK%>";
                document.frmcoaportofoliosetup.action="coaportofoliosetup.jsp";
                document.frmcoaportofoliosetup.submit();
            }
            
            function cmdListFirst(){
                document.frmcoaportofoliosetup.command.value="<%=JSPCommand.FIRST%>";
                document.frmcoaportofoliosetup.prev_command.value="<%=JSPCommand.FIRST%>";
                document.frmcoaportofoliosetup.action="coaportofoliosetup.jsp";
                document.frmcoaportofoliosetup.submit();
            }
            
            function cmdListPrev(){
                document.frmcoaportofoliosetup.command.value="<%=JSPCommand.PREV%>";
                document.frmcoaportofoliosetup.prev_command.value="<%=JSPCommand.PREV%>";
                document.frmcoaportofoliosetup.action="coaportofoliosetup.jsp";
                document.frmcoaportofoliosetup.submit();
            }
            
            function cmdListNext(){
                document.frmcoaportofoliosetup.command.value="<%=JSPCommand.NEXT%>";
                document.frmcoaportofoliosetup.prev_command.value="<%=JSPCommand.NEXT%>";
                document.frmcoaportofoliosetup.action="coaportofoliosetup.jsp";
                document.frmcoaportofoliosetup.submit();
            }
            
            function cmdListLast(){
                document.frmcoaportofoliosetup.command.value="<%=JSPCommand.LAST%>";
                document.frmcoaportofoliosetup.prev_command.value="<%=JSPCommand.LAST%>";
                document.frmcoaportofoliosetup.action="coaportofoliosetup.jsp";
                document.frmcoaportofoliosetup.submit();
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
                                                        <form name="frmcoaportofoliosetup" method ="post" action="">
                                                            <input type="hidden" name="command" value="<%=iJSPCommand%>">
                                                            <input type="hidden" name="vectSize" value="<%=vectSize%>">
                                                            <input type="hidden" name="start" value="<%=start%>">
                                                            <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                                                            <input type="hidden" name="hidden_portofolio_setup_id" value="<%=oidCoaPortofolioSetup%>">
                                                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr>
                                                                    <td class="container"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="8"  colspan="3"> 
                                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                        <tr align="left" valign="top">
                                                                                            <td height="8" valign="middle" colspan="3">&nbsp;</td>
                                                                                        </tr>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="8" valign="middle" colspan="3"> 
                                                                                                <table width="40%" border="0" cellspacing="0" cellpadding="0">
                                                                                                    <tr> 
                                                                                                        <td nowrap width="22%"><b><%=langMD[0]%> :</b> 
                                                                                                            <select name="<%=jspCoaPortofolioSetup.colNames[JspCoaPortofolioSetup.JSP_PERIODE_ID]%>" onChange="javascript:cmdChangePeriod()">
                                                                                                                <%if (periodes != null && periodes.size() > 0) {
                for (int i = 0; i < periodes.size(); i++) {
                    Periode px = (Periode) periodes.get(i);
                                                                                                                %>
                                                                                                                <option value="<%=px.getOID()%>" <%if (px.getOID() == periodeId) {%>selected<%}%>><%=px.getName()%></option>
                                                                                                                <%}
            }%>
                                                                                                            </select>
                                                                                                        </td>
                                                                                                        <td width="2%"><img src="../images/spacer.gif" width="10" height="1"></td>
                                                                                                        <td width="76%"> <%if (isOpen) {%>
                                                                                                            <input type="button" name="Button" value="Copy Previous Setup" onClick="javascript:cmdCopy()">
                                                                                                            <%} else {%>
                                                                                                            &nbsp;
                                                                                                            <%}%>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="14" valign="middle" colspan="3" class="comment">&nbsp;</td>
                                                                                        </tr>
                                                                                        <%
            try {
                if (listCoaPortofolioSetup.size() > 0) {
                                                                                        %>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="22" valign="middle" colspan="3"> 
                                                                                            <%= drawList(listCoaPortofolioSetup, oidCoaPortofolioSetup, langMD)%> </td>
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
                                                                                        <%

            if (isOpen && iJSPCommand != JSPCommand.ADD && iJSPCommand != JSPCommand.EDIT && iErrCode == 0) {%>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="22" valign="middle" colspan="3">
                                                                                                <%if(privAdd){%>
                                                                                                    <a href="javascript:cmdAdd()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new21','','../images/new2.gif',1)"><img src="../images/new.gif" name="new21" width="71" height="22" border="0"></a>
                                                                                                <%}else{%>
                                                                                                    &nbsp;
                                                                                                <%}%>
                                                                                                </td>
                                                                                        </tr>
                                                                                        <%}%>
                                                                                    </table><a name="go"></a> 
                                                                                </td>
                                                                            </tr>
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="8" valign="middle" colspan="3"> 
                                                                                    <%if (isOpen && ((iJSPCommand == JSPCommand.ADD) || (iJSPCommand == JSPCommand.SAVE) && (jspCoaPortofolioSetup.errorSize() > 0) || (iJSPCommand == JSPCommand.EDIT) || (iJSPCommand == JSPCommand.ASK))) {%>
                                                                                    
                                                                                    <table width="100%" border="0" cellspacing="1" cellpadding="0">
                                                                                        <tr align="left"> 
                                                                                            <td height="21" valign="middle" width="9%">&nbsp;</td>
                                                                                            <td height="21" colspan="2" width="91%" class="comment" valign="top">&nbsp;</td>
                                                                                        </tr>
                                                                                        <tr align="left"> 
                                                                                            <td height="21" valign="middle" width="9%">&nbsp;</td>
                                                                                            <td height="21" colspan="2" width="91%" class="comment" valign="top">&nbsp;</td>
                                                                                        </tr>
                                                                                        <tr align="left"> 
                                                                                            <td height="21" valign="middle" width="9%">&nbsp;</td>
                                                                                            <td height="21" colspan="2" width="91%" class="comment" valign="top">*)= <%=langMD[1]%></td>
                                                                                        </tr>
                                                                                        <tr align="left">
                                                                                        <td height="21" width="9%"><%=langMD[2]%></td>
                                                                                        <td height="21" colspan="2" width="91%">
                                                                                        <select name="<%=jspCoaPortofolioSetup.colNames[JspCoaPortofolioSetup.JSP_TYPE] %>">
                                                                                            <%for (int i = 0; i < DbCoaPortofolioSetup.strPortoType.length; i++) {%>
                                                                                            <option value="<%=i%>" <%if (coaPortofolioSetup.getType() == i) {%>checked<%}%>><%=DbCoaPortofolioSetup.strPortoType[i]%></option>
                                                                                            <%}%>
                                                                                        </select>                                                                                        
                                                                                        <!--tr align="left"> 
                                          <td height="21" width="9%">Coa Parent</td>
                                          <td height="21" colspan="2" width="91%"> 
                                            <select name="<%=jspCoaPortofolioSetup.colNames[JspCoaPortofolioSetup.JSP_COA_REF_ID] %>">
                                              <option value="0" <%if (0 == coaPortofolioSetup.getCoaRefId()) {%>selected<%}%>>- 
                                              No Reference -</option>
                                              <%
    if (coas != null && coas.size() > 0) {
        for (int i = 0; i < coas.size(); i++) {
            Coa coax = (Coa) coas.get(i);
            String str = "";
            switch (coax.getLevel()) {

                case 1:
                    break;
                case 2:
                    str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                    break;
                case 3:
                    str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                    break;
                case 4:
                    str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                    break;
                case 5:
                    str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                    break;
            }
                                                                 %>
                                              <option value="<%=coax.getOID()%>" <%if (coax.getOID() == coaPortofolioSetup.getCoaRefId()) {%>selected<%}%>><%=str + "" + coax.getCode() + "-" + coax.getName()%></option>
                                              <%}
    }%>
                                                                                        </select></td></tr-->
                                                                                        <tr align="left"> 
                                                                                        <td height="21" width="9%"><%=langMD[3]%></td>
                                                                                        <td height="21" colspan="2" width="91%"> 
                                                                                        <select name="<%=jspCoaPortofolioSetup.colNames[JspCoaPortofolioSetup.JSP_COA_REVENUE_ID] %>">
                                                                                            <option value="0" <%if (0 == coaPortofolioSetup.getCoaRevenueId()) {%>selected<%}%>>- 
                                                                                                    No Reference -</option>
                                                                                            <%
    if (coaRevenues != null && coaRevenues.size() > 0) {
        for (int i = 0; i < coaRevenues.size(); i++) {
            Coa coax = (Coa) coaRevenues.get(i);
            String str = "";
            switch (coax.getLevel()) {

                case 1:
                    break;
                case 2:
                    str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                    break;
                case 3:
                    str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                    break;
                case 4:
                    str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                    break;
                case 5:
                    str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                    break;
            }
                                                                                            %>
                                                                                            <option value="<%=coax.getOID()%>" <%if (coax.getOID() == coaPortofolioSetup.getCoaRevenueId()) {%>selected<%}%>><%=str + "" + coax.getCode() + "-" + coax.getName()%></option>
                                                                                            <%}
    }%>
                                                                                        </select>
                                                                                        <tr align="left"> 
                                                                                        <td height="21" width="9%"><%=langMD[4]%></td>
                                                                                        <td height="21" colspan="2" width="91%"> 
                                                                                        <select name="<%=jspCoaPortofolioSetup.colNames[JspCoaPortofolioSetup.JSP_COA_EXPENSE_ID] %>">
                                                                                            <option value="0" <%if (0 == coaPortofolioSetup.getCoaExpenseId()) {%>selected<%}%>>- 
                                                                                                    No Reference -</option>
                                                                                            <%
    if (coaExpenses != null && coaExpenses.size() > 0) {
        for (int i = 0; i < coaExpenses.size(); i++) {
            Coa coax = (Coa) coaExpenses.get(i);
            String str = "";
            switch (coax.getLevel()) {

                case 1:
                    break;
                case 2:
                    str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                    break;
                case 3:
                    str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                    break;
                case 4:
                    str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                    break;
                case 5:
                    str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                    break;
            }
                                                                                            %>
                                                                                            <option value="<%=coax.getOID()%>" <%if (coax.getOID() == coaPortofolioSetup.getCoaExpenseId()) {%>selected<%}%>><%=str + "" + coax.getCode() + "-" + coax.getName()%></option>
                                                                                            <%}
    }%>
                                                                                        </select>
                                                                                        <tr align="left"> 
                                                                                        <td height="21" width="9%"><%=langMD[5]%></td>
                                                                                        <td height="21" colspan="2" width="91%"> 
                                                                                        <input type="text" name="<%=jspCoaPortofolioSetup.colNames[JspCoaPortofolioSetup.JSP_NOTE] %>"  value="<%= coaPortofolioSetup.getNote() %>" class="formElemen" size="50">
                                                                                        <tr align="left"> 
                                                                                            <td height="8" valign="middle" width="9%">&nbsp;</td>
                                                                                            <td height="8" colspan="2" width="91%" valign="top">&nbsp; 
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr align="left" > 
                                                                                            <td colspan="3" class="command" valign="top"> 
                                                                                                <%
    ctrLine.setLocationImg(approot + "/images/ctr_line");
    ctrLine.initDefault();
    ctrLine.setTableWidth("80%");
    String scomDel = "javascript:cmdAsk('" + oidCoaPortofolioSetup + "')";
    String sconDelCom = "javascript:cmdConfirmDelete('" + oidCoaPortofolioSetup + "')";
    String scancel = "javascript:cmdEdit('" + oidCoaPortofolioSetup + "')";
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
                                                                                            <td width="9%">&nbsp;</td>
                                                                                            <td width="91%">&nbsp;</td>
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
