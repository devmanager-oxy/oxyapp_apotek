
<%-- 
    Document   : coawithtransaction
    Created on : Mar 15, 2013, 11:46:54 PM
    Author     : Roy Andika
--%>

<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "com.project.fms.master.*" %>
<%@ page import = "com.project.fms.activity.*" %>
<%@ page import = "com.project.system.*" %>
<%@ include file = "../main/javainit.jsp" %>
<% int appObjCode = 1;%>
<%@ include file = "../main/check.jsp" %>
<%
            boolean masterPriv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_ACCOUNTING);
            boolean masterPrivView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_ACCOUNTING, AppMenu.PRIV_VIEW);
            boolean masterPrivUpdate = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_ACCOUNTING, AppMenu.PRIV_UPDATE);
            boolean masterPrivAdd = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_ACCOUNTING, AppMenu.PRIV_ADD);
            boolean masterPrivDelete = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_ACCOUNTING, AppMenu.PRIV_DELETE);
%>
<!-- Jsp Block -->

<%
            String grpType = JSPRequestValue.requestString(request, "groupType");
            int iJSPCommand = JSPRequestValue.requestCommand(request);
            int start = JSPRequestValue.requestInt(request, "start");
            int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
            long oidCoa = JSPRequestValue.requestLong(request, "hidden_coa_id");
            String accGroup = JSPRequestValue.requestString(request, "acc_group");

            if (iJSPCommand == JSPCommand.NONE && grpType.length() == 0) {
                grpType = I_Project.accGroup[0];
            }

            /*variable declaration*/
            int recordToGet = 10;
            String msgString = "";
            int iErrCode = JSPMessage.NONE;
            String whereClause = "";
            if (grpType.equals("")) {
                grpType = "All";
            }
            if (grpType.equals("All")) {
                whereClause = "";
            } else {
                whereClause = DbCoa.colNames[DbCoa.COL_ACCOUNT_GROUP] + " = '" + grpType + "'";
            }
            String orderClause = "code";

            CmdCoa ctrlCoa = new CmdCoa(request);
            JSPLine ctrLine = new JSPLine();
            Vector listCoa = new Vector(1, 1);

            /*switch statement */
            iErrCode = ctrlCoa.action(iJSPCommand, oidCoa, 0, 0, 0, sysCompany.getOID());
            /* end switch*/
            JspCoa jspCoa = ctrlCoa.getForm();

            /*count list All Coa*/
            int vectSize = DbCoa.getCount(whereClause);
            recordToGet = vectSize;

            Coa coa = ctrlCoa.getCoa();
            msgString = ctrlCoa.getMessage();


            if ((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV) ||
                    (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)) {
                start = ctrlCoa.actionList(iJSPCommand, start, vectSize, recordToGet);
            }
            /* end switch list*/

            /* get record to display */
            listCoa = DbCoa.list(start, recordToGet, whereClause, orderClause);

            /*handle condition if size of record to display = 0 and start > 0 	after delete*/
            if (listCoa.size() < 1 && start > 0) {
                if (vectSize - recordToGet > recordToGet) {
                    start = start - recordToGet;
                } //go to JSPCommand.PREV
                else {
                    start = 0;
                    iJSPCommand = JSPCommand.FIRST;
                    prevJSPCommand = JSPCommand.FIRST; //go to JSPCommand.FIRST
                }
                listCoa = DbCoa.list(start, recordToGet, whereClause, orderClause);
            }

            /*** LANG ***/
            String[] langMD = {"Records", "Editor", "Account Group", //0-2
                "Account", "Budget", "Transaction", "Budget Balance", "Account Group", "Is SP", "Level", "Department", "Section"}; //3-11

            String[] langNav = {"Masterdata", "Chart of Account", "All"};

            if (lang == LANG_ID) {
                String[] langID = {"Daftar", "Editor", "Kelompok Perkiraan",
                    "Perkiraan", "Anggaran", "Transaksi", "Saldo Anggaran", "Kelompok Perkiraan", "SP", "Level", "Departemen", "Bagian"
                };
                langMD = langID;

                String[] navID = {"Data Induk", "Daftar Perkiraan", "Semua"};
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
            <%if (!masterPriv || !masterPrivView) {%>
            window.location="<%=approot%>/nopriv.jsp";
            <%}%>
            
            function cmdAdd(){
                document.frmcoa.hidden_coa_id.value="0";
                document.frmcoa.command.value="<%=JSPCommand.ADD%>";
                document.frmcoa.prev_command.value="<%=prevJSPCommand%>";
                document.frmcoa.action="coa.jsp";
                document.frmcoa.submit();
            }
            
            function cmdAsk(oidCoa){
                document.frmcoa.hidden_coa_id.value=oidCoa;
                document.frmcoa.command.value="<%=JSPCommand.ASK%>";
                document.frmcoa.prev_command.value="<%=prevJSPCommand%>";
                document.frmcoa.action="coa.jsp";
                document.frmcoa.submit();
            }
            
            function cmdConfirmDelete(oidCoa){
                document.frmcoa.hidden_coa_id.value=oidCoa;
                document.frmcoa.command.value="<%=JSPCommand.DELETE%>";
                document.frmcoa.prev_command.value="<%=prevJSPCommand%>";
                document.frmcoa.action="coa.jsp";
                document.frmcoa.submit();
            }
            function cmdSave(){
                document.frmcoa.command.value="<%=JSPCommand.SAVE%>";
                document.frmcoa.prev_command.value="<%=prevJSPCommand%>";
                document.frmcoa.action="coa.jsp";
                document.frmcoa.submit();
            }
            
            function cmdEdit(oidCoa){
                document.frmcoa.hidden_coa_id.value=oidCoa;
                document.frmcoa.command.value="<%=JSPCommand.EDIT%>";
                document.frmcoa.prev_command.value="<%=prevJSPCommand%>";
                document.frmcoa.action="coaedt.jsp";
                document.frmcoa.submit();
            }
            
            function cmdToEditor(){                
                document.frmcoa.hidden_coa_id.value=0;
                document.frmcoa.command.value="<%=JSPCommand.ADD%>";
                document.frmcoa.prev_command.value="<%=prevJSPCommand%>";
                document.frmcoa.action="coaedt.jsp";
                document.frmcoa.submit();
            }	
            
            function cmdCancel(oidCoa){
                document.frmcoa.hidden_coa_id.value=oidCoa;
                document.frmcoa.command.value="<%=JSPCommand.EDIT%>";
                document.frmcoa.prev_command.value="<%=prevJSPCommand%>";
                document.frmcoa.action="coa.jsp";
                document.frmcoa.submit();
            }
            
            function cmdBack(){
                document.frmcoa.command.value="<%=JSPCommand.BACK%>";
                document.frmcoa.action="coa.jsp";
                document.frmcoa.submit();
            }
            
            function cmdListFirst(){
                document.frmcoa.command.value="<%=JSPCommand.FIRST%>";
                document.frmcoa.prev_command.value="<%=JSPCommand.FIRST%>";
                document.frmcoa.action="coa.jsp";
                document.frmcoa.submit();
            }
            
            function cmdListPrev(){
                document.frmcoa.command.value="<%=JSPCommand.PREV%>";
                document.frmcoa.prev_command.value="<%=JSPCommand.PREV%>";
                document.frmcoa.action="coa.jsp";
                document.frmcoa.submit();
            }
            
            function cmdListNext(){
                document.frmcoa.command.value="<%=JSPCommand.NEXT%>";
                document.frmcoa.prev_command.value="<%=JSPCommand.NEXT%>";
                document.frmcoa.action="coa.jsp";
                document.frmcoa.submit();
            }
            
            function cmdListLast(){
                document.frmcoa.command.value="<%=JSPCommand.LAST%>";
                document.frmcoa.prev_command.value="<%=JSPCommand.LAST%>";
                document.frmcoa.action="coa.jsp";
                document.frmcoa.submit();
            }
            
            function printXLS(){	 
                window.open("<%=printroot%>.report.RptCoaFlatXLS");
                }
                
                function cmdAccGroup(){
                    document.frmcoa.command.value="<%=JSPCommand.SUBMIT%>";
                    document.frmcoa.action="coa.jsp";
                    document.frmcoa.submit();
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
    <body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','../images/new2.gif','../images/printxls2.gif')">
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
                                                        <form name="frmcoa" method ="post" action="">
                                                            <input type="hidden" name="command" value="<%=iJSPCommand%>">
                                                            <input type="hidden" name="vectSize" value="<%=vectSize%>">
                                                            <input type="hidden" name="start" value="<%=start%>">
                                                            <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                                                            <input type="hidden" name="hidden_coa_id" value="<%=oidCoa%>">
                                                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr align="left" valign="top"> 
                                                                    <td height="8"  colspan="3" class="container"> 
                                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="8" valign="middle" colspan="3"></td>
                                                                            </tr>
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="15" valign="middle" colspan="3"> 
                                                                                    <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                                                                        <tr > 
                                                                                            <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="17" height="10"></td>
                                                                                            <td class="tabin">
                                                                                                <div align="center">&nbsp;&nbsp;<a href="coa.jsp?groupType=<%=grpType%>" class="tablink"><%=langMD[0]%></a>&nbsp;&nbsp;</div>
                                                                                            </td>
                                                                                            <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                                                                            <td class="tabin">
                                                                                                <div align="center">&nbsp;&nbsp;<a href="javascript:cmdToEditor()" class="tablink"><%=langMD[1]%></a>&nbsp;&nbsp;</div>
                                                                                            </td>
                                                                                            <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                                                                            <td class="tab">
                                                                                                <div align="center">&nbsp;&nbsp;Transaction&nbsp;&nbsp;</div>
                                                                                            </td>
                                                                                            <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                                                                            <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                                                                            <td width="100%" class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="10" height="10"></td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="22" valign="middle" colspan="3" class="page"> 
                                                                                    <table width="100%" border="0" cellpadding="1" height="20" cellspacing="1">
                                                                                        <tr> 
                                                                                            <td width="12%" height="41"><%=langMD[2]%> 
                                                                                                <select name="groupType" onChange="javascript:cmdAccGroup()">
                                                                                                    <option value="All" <%if (grpType.equals("All")) {%>selected<%}%>><%=langNav[2]%></option>
                                                                                                    <%for (int i = 0; i < I_Project.accGroup.length; i++) {%>
                                                                                                    <option value="<%=I_Project.accGroup[i]%>" <%if (I_Project.accGroup[i].equals(grpType)) {%>selected<%}%>><%=I_Project.accGroup[i]%></option>
                                                                                                    <%}%>
                                                                                                </select>
                                                                                            </td>
                                                                                            <td width="4%" height="41">&nbsp;</td>
                                                                                            <td width="6%" height="41">&nbsp;</td>
                                                                                            <td width="12%" height="41">&nbsp;</td>
                                                                                            <td width="11%" height="41">&nbsp;</td>
                                                                                            <td width="7%" height="41">&nbsp;</td>                                                                                            
                                                                                            <td width="11%" nowrap height="41">&nbsp;</td>
                                                                                            <td width="14%" nowrap height="41">&nbsp;</td>
                                                                                        </tr>
                                                                                        <tr> 
                                                                                            <td width="12%" class="tablehdr" height="22"> 
                                                                                                <div align="center"><b><font color="#FFFFFF"><%=langMD[3]%></font></b></div>
                                                                                            </td>
                                                                                            <td width="4%" class="tablehdr" height="22"><%=langMD[4]%> 
                                                                                            <%=JSPFormater.formatDate(new Date(), "yyyy")%> </td>
                                                                                            <td width="6%" class="tablehdr" height="22"><%=langMD[5]%></td>
                                                                                            <td width="12%" class="tablehdr" height="22"><%=langMD[6]%></td>
                                                                                            <td width="11%" class="tablehdr" height="22"><%=langMD[7]%></td>                                                                                            
                                                                                            <td width="11%" class="tablehdr" height="22"><%=langMD[9]%></td>
                                                                                            <td width="11%" class="tablehdr" nowrap height="22"><%=langMD[10]%></td>
                                                                                            <td width="14%" class="tablehdr" nowrap height="22"><%=langMD[11]%></td>
                                                                                        </tr>
                                                                                        <%if (listCoa != null && listCoa.size() > 0) {
                for (int i = 0; i < listCoa.size(); i++) {
                    coa = (Coa) listCoa.get(i);
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

                    String cssString = "tablecell";
                    if (i % 2 != 0) {
                        cssString = "tablecell1";
                    }


                                                                                        %>
                                                                                        <tr> 
                                                                                            <td width="12%" class="<%=cssString%>" nowrap> 
                                                                                                <font size="1"> 
                                                                                                    <%if (coa.getStatus().equals("HEADER")) {%>
                                                                                                    <b> 
                                                                                                        <%}%>                                                                                                        
                                                                                                        <%if (masterPrivUpdate) {%>
                                                                                                        <%=str + "<a href=\"javascript:cmdEdit('" + coa.getOID() + "')\">" + coa.getCode() + " - " + coa.getName() + "</a>"%> 
                                                                                                        <%} else {%>                                                                                                        
                                                                                                        <%=str + coa.getCode() + " - " + coa.getName()%> 
                                                                                                        <%}%>
                                                                                                        <%if (coa.getStatus().equals("HEADER")) {%>
                                                                                                    </b> 
                                                                                                    <%}%>
                                                                                            </font></td>
                                                                                            <td width="4%" class="<%=cssString%>"> 
                                                                                                <font size="1"> 
                                                                                                    <%
                                                                                            double cbVal = 0;
                                                                                            double coaSummary = 0;
                                                                                            double amount = 0;

                                                                                            if (!coa.getStatus().equals("HEADER")) {
                                                                                                    %>
                                                                                                </font> 
                                                                                                <div align="right"> <font size="1"> 
                                                                                                        <%
                                                                                                        Date dt = new Date();
                                                                                                        int yearx = dt.getYear() + 1900;
                                                                                                        %>
                                                                                                <%=JSPFormater.formatNumber(cbVal, "#,###.##")%> </font></div>
                                                                                                <font size="1"> 
                                                                                                    <%} else {%>
                                                                                                    &nbsp; 
                                                                                                    <%}%>
                                                                                            </font></td>
                                                                                            <td width="6%" class="<%=cssString%>"> 
                                                                                                <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                                                                                    <tr> 
                                                                                                        <td width="5%"></td>
                                                                                                        <%
                                                                                            if (coa.getStatus().equals("HEADER")) {

                                                                                                String codeBaginBalance = DbSystemProperty.getValueByName("ID_BEGINING_BALANCE");
                                                                                                for (int ix = 0; ix < listCoa.size(); ix++) {
                                                                                                    Coa coax = (Coa) listCoa.get(ix);
                                                                                                    if (coax.getAccRefId() == coa.getOID()) {
                                                                                                        if (coax.getCode().equals(codeBaginBalance)) {
                                                                                                            coaSummary = coaSummary + DbCoa.getCoaBalance(coax.getOID());
                                                                                                        } else if (coax.getAccountGroup().equals(I_Project.ACC_GROUP_LIQUID_ASSET) || coax.getAccountGroup().equals(I_Project.ACC_GROUP_FIXED_ASSET) || coax.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_ASSET) || coax.getAccountGroup().equals(I_Project.ACC_GROUP_COST_OF_SALES) || coax.getAccountGroup().equals(I_Project.ACC_GROUP_EXPENSE) || coax.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_EXPENSE)) {
                                                                                                            coaSummary = coaSummary + DbCoa.getCoaBalance(coax.getOID());
                                                                                                        } else if (coax.getAccountGroup().equals(I_Project.ACC_GROUP_EQUITY) || coax.getAccountGroup().equals(I_Project.ACC_GROUP_REVENUE) || coax.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_REVENUE) || coax.getAccountGroup().equals(I_Project.ACC_GROUP_CURRENT_LIABILITIES) || coax.getAccountGroup().equals(I_Project.ACC_GROUP_LONG_TERM_LIABILITIES)) {
                                                                                                            coaSummary = coaSummary + DbCoa.getCoaBalanceCD(coax.getOID());
                                                                                                        }
                                                                                                    }
                                                                                                }

                                                                                                String strDisplay1 = "";
                                                                                                if (coaSummary < 0) {
                                                                                                    strDisplay1 = "(" + JSPFormater.formatNumber(coaSummary * -1, "#,###.##") + ")";
                                                                                                } else {
                                                                                                    strDisplay1 = JSPFormater.formatNumber(coaSummary, "#,###.##");
                                                                                                }

                                                                                                        %>
                                                                                                        <td width="90%" class="<%=cssString%>"> 
                                                                                                            <div align="right"><font size="1"><b><%=strDisplay1%></b></font></div>
                                                                                                        </td>
                                                                                                        <%
                                                                                                        } else {

                                                                                                            String strDisplay = "";
                                                                                                            if (coa.getAccountGroup().equals(I_Project.ACC_GROUP_LIQUID_ASSET) || coa.getAccountGroup().equals(I_Project.ACC_GROUP_FIXED_ASSET) || coa.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_ASSET) || coa.getAccountGroup().equals(I_Project.ACC_GROUP_COST_OF_SALES) || coa.getAccountGroup().equals(I_Project.ACC_GROUP_EXPENSE) || coa.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_EXPENSE)) {
                                                                                                                amount = DbCoa.getCoaBalance(coa.getOID());
                                                                                                            } else if (coa.getAccountGroup().equals(I_Project.ACC_GROUP_EQUITY) || coa.getAccountGroup().equals(I_Project.ACC_GROUP_REVENUE) || coa.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_REVENUE) || coa.getAccountGroup().equals(I_Project.ACC_GROUP_CURRENT_LIABILITIES) || coa.getAccountGroup().equals(I_Project.ACC_GROUP_LONG_TERM_LIABILITIES)) {
                                                                                                                amount = DbCoa.getCoaBalanceCD(coa.getOID());
                                                                                                            }

                                                                                                            String codeBaginBalance = DbSystemProperty.getValueByName("ID_BEGINING_BALANCE");
                                                                                                            if (coa.getCode().equals(codeBaginBalance)) {
                                                                                                                amount = DbCoa.getCoaBalance(coa.getOID());
                                                                                                            }

                                                                                                            if (amount < 0) {
                                                                                                                strDisplay = "(" + JSPFormater.formatNumber(amount * -1, "#,###.##") + ")";
                                                                                                            } else {
                                                                                                                strDisplay = JSPFormater.formatNumber(amount, "#,###.##");
                                                                                                            }

                                                                                                        %>
                                                                                                        <td width="90%" class="<%=cssString%>"> 
                                                                                                            <div align="right"><font size="1"><%=strDisplay%></font></div>
                                                                                                        </td>
                                                                                                        <%}%>
                                                                                                        <td width="5%"></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                            <td width="12%" class="<%=cssString%>" nowrap> 
                                                                                                <font size="1"> 
                                                                                                    <%if (!coa.getStatus().equals("HEADER")) {%>
                                                                                                </font> 
                                                                                                <div align="right"> <font size="1"> 
                                                                                                        <%
    if (cbVal - amount < 0) {
        out.println("(" + JSPFormater.formatNumber((cbVal - amount) * -1, "#,###.##") + ")");
    } else {
        out.println(JSPFormater.formatNumber(cbVal - amount, "#,###.##"));
    }
                                                                                                        %>
                                                                                                </font></div>
                                                                                                <font size="1"> 
                                                                                                    <%} else {%>
                                                                                                    &nbsp; 
                                                                                                    <%}%>
                                                                                            </font></td>
                                                                                            <td width="11%" class="<%=cssString%>" nowrap> 
                                                                                                <font size="1"> 
                                                                                                    <%if (coa.getStatus().equals("HEADER")) {%>
                                                                                                    <b> 
                                                                                                        <%}%>
                                                                                                        <%=coa.getAccountGroup()%> 
                                                                                                        <%if (coa.getStatus().equals("HEADER")) {%>
                                                                                                    </b> 
                                                                                                    <%}%>
                                                                                            </font></td>                                                                                            
                                                                                            <td width="11%" class="<%=cssString%>"> 
                                                                                                <font size="1"> 
                                                                                                    <%if (coa.getStatus().equals("HEADER")) {%>
                                                                                                    <b> 
                                                                                                        <%}%>
                                                                                                </b></font><b> 
                                                                                                    <div align="center"><font size="1"><%=coa.getStatus()%></font></div>
                                                                                                    <font size="1"> 
                                                                                                        <%if (coa.getStatus().equals("HEADER")) {%>
                                                                                                </font></b> <font size="1"> 
                                                                                                    <%}%>
                                                                                            </font></td>
                                                                                            <td width="11%" class="<%=cssString%>"> 
                                                                                                <div align="center"> <font size="1"> 
                                                                                                        <%
                                                                                            Department dep = new Department();
                                                                                            try {
                                                                                                dep = DbDepartment.fetchExc(coa.getDepartmentId());
                                                                                            } catch (Exception e) {
                                                                                            }
                                                                                                        %>
                                                                                                        <%if (coa.getStatus().equals("HEADER")) {%>
                                                                                                        <b> 
                                                                                                            <%}%>
                                                                                                            <%=dep.getName()%> 
                                                                                                            <%if (coa.getStatus().equals("HEADER")) {%>
                                                                                                        </b> 
                                                                                                        <%}%>
                                                                                                </font></div>
                                                                                            </td>
                                                                                            <td width="14%" class="<%=cssString%>"> 
                                                                                                <div align="center"><font size="1"> 
                                                                                                        <%
                                                                                            Department sec = new Department();
                                                                                            try {
                                                                                                sec = DbDepartment.fetchExc(coa.getSectionId());
                                                                                            } catch (Exception e) {
                                                                                            }
                                                                                                        %>
                                                                                                        <%if (coa.getStatus().equals("HEADER")) {%>
                                                                                                        <b> 
                                                                                                            <%}%>
                                                                                                            <%=sec.getName()%> 
                                                                                                            <%if (coa.getStatus().equals("HEADER")) {%>
                                                                                                        </b> 
                                                                                                        <%}%>
                                                                                                </font></div>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <%}%>
                                                                                        <tr> 
                                                                                            <td width="12%" class="tablecell">&nbsp;</td>
                                                                                            <td width="4%" class="tablecell">&nbsp;</td>
                                                                                            <td width="6%" class="tablecell">&nbsp;</td>
                                                                                            <td width="12%" class="tablecell">&nbsp;</td>
                                                                                            <td width="11%" class="tablecell">&nbsp;</td>
                                                                                            <td width="7%" class="tablecell">&nbsp;</td>                                                                                            
                                                                                            <td width="11%" class="tablecell">&nbsp;</td>
                                                                                            <td width="14%" class="tablecell">&nbsp;</td>
                                                                                        </tr>
                                                                                        <%} else {%>
                                                                                        <tr> 
                                                                                            <td width="12%">&nbsp;</td>
                                                                                            <td width="4%">&nbsp;</td>
                                                                                            <td width="6%">&nbsp;</td>
                                                                                            <td width="12%">&nbsp;</td>
                                                                                            <td width="11%">&nbsp;</td>                                                                                            
                                                                                            <td width="11%">&nbsp;</td>
                                                                                            <td width="11%">&nbsp;</td>
                                                                                            <td width="14%">&nbsp;</td>
                                                                                        </tr>
                                                                                        <tr> 
                                                                                            <td width="12%"> 
                                                                                                <table width="99%" border="0" cellspacing="0" cellpadding="0">
                                                                                                    <tr> 
                                                                                                        <td width="11%">
                                                                                                            <%if (masterPrivAdd) {%>
                                                                                                            <a href="javascript:cmdToEditor()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new21','','../images/new2.gif',1)"><img src="../images/new.gif" name="new21" width="71" height="22" border="0"></a>
                                                                                                            <%}%>
                                                                                                        </td>
                                                                                                        <td width="89%">&nbsp;</td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                            <td width="4%">&nbsp;</td>
                                                                                            <td width="6%">&nbsp;</td>
                                                                                            <td width="12%">&nbsp;</td>
                                                                                            <td width="11%">&nbsp;</td>
                                                                                            <td width="7%">&nbsp;</td>                                                                                           
                                                                                            <td width="11%">&nbsp;</td>
                                                                                            <td width="14%">&nbsp;</td>
                                                                                        </tr>
                                                                                        <%}%>
                                                                                    </table>
                                                                                </td>
                                                                            </tr>                                                                            
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="0" valign="middle" colspan="3"></td>
                                                                            </tr>                                                                            
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
                                                                        </table>
                                                                    </td>
                                                                </tr>
                                                                <tr align="left" valign="top"> 
                                                                    <td height="8" valign="middle" colspan="3">&nbsp; </td>
                                                                </tr>
                                                                <tr align="left" valign="top"> 
                                                                    <td height="8" valign="middle" colspan="3" class="container"> 
                                                                        <%if (listCoa != null && listCoa.size() > 0) {%>
                                                                        <table width="30%" border="0" cellspacing="0" cellpadding="0">
                                                                            <tr> 
                                                                                <td width="71">
                                                                                    <table>
                                                                                        <tr>
                                                                                            <%if (masterPrivAdd) {%>
                                                                                            <td>  
                                                                                                <a href="javascript:cmdToEditor()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new2','','../images/new2.gif',1)"><img src="../images/new.gif" name="new2" width="71" height="22" border="0"></a>
                                                                                            </td>    
                                                                                            <td width = "6px">&nbsp;</td>
                                                                                            <%}%>
                                                                                            <td>    
                                                                                                <a href="javascript:printXLS()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('print1','','../images/printxls2.gif',1)"><img src="../images/printxls.gif" name="print1" width="120" height="22" border="0"></a> 
                                                                                            </td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </td>
                                                                                <td width="45">&nbsp;</td>
                                                                                <td width="76">&nbsp;</td>
                                                                                <td width="176">&nbsp;</td>
                                                                            </tr>
                                                                        </table>
                                                                        <%}%>
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
