
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.fms.master.*" %>
<%@ page import = "com.project.fms.activity.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ include file = "../main/javainit.jsp" %>
<% int appObjCode = 1;%>
<%@ include file = "../main/check.jsp" %>
<%
            boolean priv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_BUDGET);
            boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_BUDGET, AppMenu.PRIV_VIEW);
            boolean privUpdate = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_BUDGET, AppMenu.PRIV_UPDATE);
            boolean privAdd = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_BUDGET, AppMenu.PRIV_ADD);
            boolean privDelete = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_BUDGET, AppMenu.PRIV_DELETE);
%>
<!-- Jsp Block -->
<%!
    public String drawList(Vector objectClass, long coaId) {
        JSPList ctrlist = new JSPList();
        ctrlist.setAreaWidth("50%");
        ctrlist.setListStyle("listgen");
        ctrlist.setTitleStyle("tablehdr");
        ctrlist.setCellStyle("tablecell");
        ctrlist.setHeaderStyle("tablehdr");
        ctrlist.addHeader("Code", "20%");
        ctrlist.addHeader("Name", "20%");
        ctrlist.addHeader("Level", "20%");
        ctrlist.addHeader("Department Name", "20%");
        ctrlist.addHeader("Section Name", "20%");

        ctrlist.setLinkRow(0);
        ctrlist.setLinkSufix("");
        Vector lstData = ctrlist.getData();
        Vector lstLinkData = ctrlist.getLinkData();
        ctrlist.setLinkPrefix("javascript:cmdEdit('");
        ctrlist.setLinkSufix("')");
        ctrlist.reset();
        int index = -1;

        for (int i = 0; i < objectClass.size(); i++) {
            Coa coa = (Coa) objectClass.get(i);
            Vector rowx = new Vector();
            if (coaId == coa.getOID()) {
                index = i;
            }
            rowx.add(coa.getCode());
            rowx.add(coa.getName());
            rowx.add(String.valueOf(coa.getLevel()));
            rowx.add(coa.getDepartmentName());
            rowx.add(coa.getSectionName());
            lstData.add(rowx);
            lstLinkData.add(String.valueOf(coa.getOID()));
        }

        return ctrlist.drawList(index);
    }

%>
<%
            int iJSPCommand = JSPRequestValue.requestCommand(request);
            int start = JSPRequestValue.requestInt(request, "start");
            int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
            long oidCoa = JSPRequestValue.requestLong(request, "hidden_coa_id");
            String accGroup = JSPRequestValue.requestString(request, "acc_group");
            double budget = JSPRequestValue.requestDouble(request, "budget");
            long periodeId = JSPRequestValue.requestLong(request, "open_period");
            String groupType = JSPRequestValue.requestString(request, "groupType");
            Vector departments = DbDepartment.list(0, 0, "", "name");
            Vector sections = DbSection.list(0, 0, "", "name");

            /*variable declaration*/
            int recordToGet = 10;
            String msgString = "";
            int iErrCode = JSPMessage.NONE;
            String whereClause = "account_group='" + accGroup + "'";
            String orderClause = "";

            CmdCoa ctrlCoa = new CmdCoa(request);
            JSPLine ctrLine = new JSPLine();
            Vector listCoa = new Vector(1, 1);

            /*switch statement */
            iErrCode = ctrlCoa.action(iJSPCommand, oidCoa, budget, periodeId, appSessUser.getUserOID(), sysCompany.getOID());
            /* end switch*/
            JspCoa jspCoa = ctrlCoa.getForm();

            /*count list All Coa*/
            int vectSize = DbCoa.getCount(whereClause);

            Coa coa = ctrlCoa.getCoa();
            msgString = ctrlCoa.getMessage();

            if (oidCoa == 0) {
                oidCoa = coa.getOID();
            }

            Vector coas = DbCoa.list(0, 0, "status='" + I_Project.ACCOUNT_LEVEL_HEADER + "'", "code");

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

            if ((iJSPCommand == JSPCommand.SAVE || iJSPCommand == JSPCommand.DELETE) && iErrCode == 0) {
                oidCoa = 0;
                coa = new Coa();
                msgString = "Data have been " + ((iJSPCommand == JSPCommand.SAVE) ? "saved" : "deleted") + ", ready to insert new data";
                iJSPCommand = JSPCommand.ADD;
            }

            if (iJSPCommand == JSPCommand.ADD) {
                if (departments != null && departments.size() > 0) {
                    coa.setDepartmentId(((Department) departments.get(0)).getOID());
                }
            }

            boolean isOpeningEditable = false;
            if (DbPeriode.getCount("") == 1) {
                isOpeningEditable = true;
            }

            /*** LANG ***/
            String[] langMD = {"Records", "Editor", "required", //0-2
                "Account Classification", "Account Group", "Account Group Alias (Activity)", "Account Category", "Account Number", //3-7
                "Account Name", "Level", "Subaccount Of", "Saldo Normal", "Account Type", "Implementation Location", "Department", "Section"}; //8-15

            String[] langNav = {"Masterdata", "Account Editor"};

            if (lang == LANG_ID) {
                String[] langID = {"Daftar", "Editor", "harus diisi",
                    "Klasifikasi Perkiraan", "Kelompok Perkiraan", "Pengelompokan Perkiraan", "Kategory Perkiraan", "Nomor Perkiraan",
                    "Nama Perkiraan", "Level", "Sub-Perkiraan dari", "Saldo Normal", "Tipe", "Lokasi Implementasi", "Departemen", "Bagian"
                };
                langMD = langID;

                String[] navID = {"Data Induk", "Editor Perkiraan"};
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
        <script language="JavaScript" src="../main/common.js"></script>
        <script language="JavaScript">
            
            <%if (!priv || !privView || !privUpdate) {%>
            window.location="<%=approot%>/nopriv.jsp";
            <%}%>
            
            var sysDecSymbol = "<%=sSystemDecimalSymbol%>";
            var usrDigitGroup = "<%=sUserDigitGroup%>";
            var usrDecSymbol = "<%=sUserDecimalSymbol%>";
            
            function cmdToTransaction(){                
                document.frmcoa.hidden_coa_id.value=0;
                document.frmcoa.command.value="<%=JSPCommand.ADD%>";
                document.frmcoa.prev_command.value="<%=prevJSPCommand%>";
                document.frmcoa.action="coawithtransaction.jsp";
                document.frmcoa.submit();
            }	
            
            function changeOpening(){
                var openingBalance = parseFloat('0');                
                var sOpeningBalance = cleanNumberFloat(document.frmcoa.<%=jspCoa.colNames[JspCoa.JSP_OPENING_BALANCE] %>.value, sysDecSymbol, usrDigitGroup, usrDecSymbol);
                    if(!isNaN(sOpeningBalance)){
                        openingBalance = parseFloat(sOpeningBalance);
                    }
                    document.frmcoa.<%=jspCoa.colNames[JspCoa.JSP_OPENING_BALANCE] %>.value = formatFloat(openingBalance, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);
                }
                
                function changeBudget(){
                    var budget = parseFloat('0');                    
                    var sBudget = cleanNumberFloat(document.frmcoa.budget.value, sysDecSymbol, usrDigitGroup, usrDecSymbol);
                    if(!isNaN(sBudget)){
                        budget = parseFloat(sBudget);
                    }
                    document.frmcoa.budget.value = formatFloat(budget, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);
                }
                
                function cmdAdd(){
                    document.frmcoa.hidden_coa_id.value="0";
                    document.frmcoa.command.value="<%=JSPCommand.ADD%>";
                    document.frmcoa.prev_command.value="<%=prevJSPCommand%>";
                    document.frmcoa.action="coaedt.jsp";
                    document.frmcoa.submit();
                }
                
                function cmdAsk(oidCoa){
                    document.frmcoa.hidden_coa_id.value=oidCoa;
                    document.frmcoa.command.value="<%=JSPCommand.ASK%>";
                    document.frmcoa.prev_command.value="<%=prevJSPCommand%>";
                    document.frmcoa.action="coaedt.jsp";
                    document.frmcoa.submit();
                }
                
                function cmdConfirmDelete(oidCoa){
                    document.frmcoa.hidden_coa_id.value=oidCoa;
                    document.frmcoa.command.value="<%=JSPCommand.DELETE%>";
                    document.frmcoa.prev_command.value="<%=prevJSPCommand%>";
                    document.frmcoa.action="coaedt.jsp";
                    document.frmcoa.submit();
                }
                function cmdSave(){
                    document.frmcoa.command.value="<%=JSPCommand.SAVE%>";
                    document.frmcoa.prev_command.value="<%=prevJSPCommand%>";
                    document.frmcoa.action="coaedt.jsp";
                    document.frmcoa.submit();
                }
                
                function cmdEdit(oidCoa){
                    document.frmcoa.hidden_coa_id.value=oidCoa;
                    document.frmcoa.command.value="<%=JSPCommand.EDIT%>";
                    document.frmcoa.prev_command.value="<%=prevJSPCommand%>";
                    document.frmcoa.action="coaedt.jsp";
                    document.frmcoa.submit();
                }
                
                function cmdCancel(oidCoa){
                    document.frmcoa.hidden_coa_id.value=oidCoa;
                    document.frmcoa.command.value="<%=JSPCommand.EDIT%>";
                    document.frmcoa.prev_command.value="<%=prevJSPCommand%>";
                    document.frmcoa.action="coaedt.jsp";
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
                    document.frmcoa.action="coaedt.jsp";
                    document.frmcoa.submit();
                }
                
                function cmdListPrev(){
                    document.frmcoa.command.value="<%=JSPCommand.PREV%>";
                    document.frmcoa.prev_command.value="<%=JSPCommand.PREV%>";
                    document.frmcoa.action="coaedt.jsp";
                    document.frmcoa.submit();
                }
                
                function cmdListNext(){
                    document.frmcoa.command.value="<%=JSPCommand.NEXT%>";
                    document.frmcoa.prev_command.value="<%=JSPCommand.NEXT%>";
                    document.frmcoa.action="coaedt.jsp";
                    document.frmcoa.submit();
                }
                
                function cmdListLast(){
                    document.frmcoa.command.value="<%=JSPCommand.LAST%>";
                    document.frmcoa.prev_command.value="<%=JSPCommand.LAST%>";
                    document.frmcoa.action="coaedt.jsp";
                    document.frmcoa.submit();
                }
                
                function cmdDept(){
                    document.frmcoa.command.value="<%=JSPCommand.SUBMIT%>";
                    document.frmcoa.action="coaedt.jsp";
                    document.frmcoa.submit();
                }
                
                function cmdBudget(){
                    window.open("<%=approot%>/master/coabudget.jsp?coa_id=<%=coa.getOID()%>","budget","scrollbars=no,height=400,width=400,addressbar=no,menubar=no,toolbar=no,location=no,");
                    }
                    
                    function cmdChangeType(){
                        var x = document.frmcoa.<%=jspCoa.colNames[jspCoa.JSP_STATUS]%>.value;
                        if(x=='<%=I_Project.ACCOUNT_LEVEL_POSTABLE%>'){
                            document.all.budgetx.style.display="";		
                            document.all.auto_reverse.style.display = "";
                        }
                        else{
                            document.all.budgetx.style.display="none";		
                            document.all.auto_reverse.style.display = "none";
                        }	
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
                                                            <input type="hidden" name="groupType" value="<%=groupType%>">                                                            
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr>
                                                                    <td class="container">
                                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="8" valign="middle" colspan="3" class="page"> 
                                                                                    <table width="100%" border="0" cellspacing="1" cellpadding="0">
                                                                                        <tr align="left"> 
                                                                                            <td height="8" valign="middle" width="17%"></td>
                                                                                            <td height="8" colspan="2" width="83%" class="comment" valign="top"></td>
                                                                                        </tr>
                                                                                        <tr align="left"> 
                                                                                            <td height="21" valign="middle" colspan="3"> 
                                                                                                <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                                                                                    <tr > 
                                                                                                        <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="17" height="10"></td>
                                                                                                        <td class="tabin"> 
                                                                                                            <div align="center">&nbsp;&nbsp;<a href="coa.jsp?groupType=<%=groupType%>" class="tablink"><%=langMD[0]%></a></div>
                                                                                                        </td>
                                                                                                        <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                                                                                        <td class="tab" > 
                                                                                                            <div align="center">&nbsp;&nbsp;&nbsp;&nbsp;<%=langMD[1]%>&nbsp;&nbsp;&nbsp;&nbsp;</div>
                                                                                                        </td>
                                                                                                        <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                                                                                        <%if(false){%>
                                                                                                        <td class="tabin">
                                                                                                            <div align="center">&nbsp;&nbsp;<a href="javascript:cmdToTransaction()" class="tablink">Transaction</a>&nbsp;&nbsp;</div>
                                                                                                        </td>         
                                                                                                        <%}%>                                                                                                        
                                                                                                        <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                                                                                        <td width="100%" class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="10" height="10"></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            <font color="#006633"><i></i></font></td>
                                                                                        </tr>
                                                                                        <%if (msgString.length() > 0) {%>
                                                                                        <tr align="left"> 
                                                                                            <td height="21" colspan="3" width="83%" class="comment" valign="top">&nbsp;</td>
                                                                                        </tr>
                                                                                        <tr align="left"> 
                                                                                            <td height="21" colspan="3" width="83%" class="comment" valign="top"><font color="#009900"><i><%=msgString%></i></font></td>
                                                                                        </tr>
                                                                                        <%}%>
                                                                                        <tr align="left"> 
                                                                                            <td height="21" valign="middle" width="17%">&nbsp;</td>
                                                                                            <td height="21" colspan="2" width="83%" class="comment" valign="top">&nbsp;</td>
                                                                                        </tr>
                                                                                        <tr align="left"> 
                                                                                            <td height="21" valign="middle" width="17%">&nbsp;</td>
                                                                                            <td height="21" colspan="2" width="83%" class="comment" valign="top">*)= 
                                                                                            <%=langMD[2]%></td>
                                                                                        </tr>                                                                                        
                                                                                        <tr align="left"> 
                                                                                            <td height="21" width="17%">&nbsp;&nbsp;<%=langMD[4]%></td>
                                                                                            <td height="21" colspan="2" width="83%"> 
                                                                                            <select name="<%=jspCoa.colNames[JspCoa.JSP_ACCOUNT_GROUP] %>">
                                                                                                <%for (int i = 0; i < I_Project.accGroup.length; i++) {%>
                                                                                                <option value="<%=I_Project.accGroup[i]%>" <%if (I_Project.accGroup[i].equals(coa.getAccountGroup())) {%>selected<%}%>><%=I_Project.accGroup[i]%></option>
                                                                                                <%}%>
                                                                                            </select>
                                                                                        </tr>                                                                                        
                                                                                        <tr align="left"> 
                                                                                            <td height="21" width="17%">&nbsp;&nbsp;<%=langMD[7]%></td>
                                                                                            <td height="21" colspan="2" width="83%"> 
                                                                                                <input type="text" name="<%=jspCoa.colNames[JspCoa.JSP_CODE] %>"  value="<%= coa.getCode() %>" class="formElemen" size="15">
                                                                                                * <%= jspCoa.getErrorMsg(JspCoa.JSP_CODE) %> 
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr align="left"> 
                                                                                            <td height="21" width="17%">&nbsp;&nbsp;<%=langMD[8]%></td>
                                                                                            <td height="21" colspan="2" width="83%"> 
                                                                                                <input type="text" name="<%=jspCoa.colNames[JspCoa.JSP_NAME] %>"  value="<%= coa.getName() %>" class="formElemen" size="45">
                                                                                                * <%= jspCoa.getErrorMsg(JspCoa.JSP_NAME) %> 
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr align="left"> 
                                                                                            <td height="21" width="17%">&nbsp;&nbsp;<%=langMD[9]%></td>
                                                                                            <td height="21" colspan="2" width="83%"> 
                                                                                                <select name="<%=jspCoa.colNames[JspCoa.JSP_LEVEL] %>">
                                                                                                    <%for (int i = 1; i < 6; i++) {%>
                                                                                                    <option value="<%=i%>" <%if (i == coa.getLevel()) {%>selected<%}%>><%=i%></option>
                                                                                                    <%}%>
                                                                                                </select>
                                                                                                &nbsp;<%= jspCoa.getErrorMsg(JspCoa.JSP_LEVEL) %> 
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr align="left"> 
                                                                                            <td height="21" width="17%">&nbsp;&nbsp;<%=langMD[10]%></td>
                                                                                            <td height="21" colspan="2" width="83%"> 
                                                                                                <select name="<%=jspCoa.colNames[JspCoa.JSP_ACC_REF_ID] %>">
                                                                                                    <option value="0" <%if (0 == coa.getAccRefId()) {%>selected<%}%>>- 
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
                                                                                                    <option value="<%=coax.getOID()%>" <%if (coax.getOID() == coa.getAccRefId()) {%>selected<%}%>><%=str + "" + coax.getCode() + "-" + coax.getName()%></option>
                                                                                                    <%}
            }%>
                                                                                                </select>
                                                                                                &nbsp;<%= jspCoa.getErrorMsg(JspCoa.JSP_ACC_REF_ID) %> 
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr align="left"> 
                                                                                            <td height="21" width="17%">&nbsp;&nbsp;<%=langMD[11]%></td>
                                                                                            <td height="21" colspan="2" width="83%"> 
                                                                                                <select name="<%=jspCoa.colNames[JspCoa.JSP_SALDO_NORMAL] %>">
                                                                                                    <%for (int i = 0; i < I_Project.accSaldoNormal.length; i++) {%>                                                                                                    
                                                                                                    <option value="<%=I_Project.accSaldoNormal[i]%>" <%if (I_Project.accSaldoNormal[i].equals(coa.getSaldoNormal())) {%>selected<%}%>><%=I_Project.accSaldoNormal[i]%></option>
                                                                                                    <%}%>
                                                                                                </select>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr align="left"> 
                                                                                            <td height="21" width="17%">&nbsp;&nbsp;<%=langMD[12]%></td>
                                                                                            <td height="21" colspan="2" width="83%"> 
                                                                                                <select name="<%=jspCoa.colNames[JspCoa.JSP_STATUS] %>" onChange="javascript:cmdChangeType()">
                                                                                                    <%for (int i = 0; i < I_Project.accLevel.length; i++) {%>
                                                                                                    <option value="<%=I_Project.accLevel[i]%>" <%if (I_Project.accLevel[i].equals(coa.getStatus())) {%>selected<%}%>><%=I_Project.accLevel[i]%></option>
                                                                                                    <%}%>
                                                                                                </select><%if(false){%> &nbsp;&nbsp;<span id="auto_reverse"><input type="checkbox" name="<%=JspCoa.colNames[JspCoa.JSP_AUTO_REVERSE]%>" <% if (coa.getAutoReverse() == 1) {
                out.println("checked");
            }%> value="1">&nbsp;Auto Reverse</span><%}%>
                                                                                            </td>
                                                                                        </tr>                                                                                                                                                                                
                                                                                        <tr align="left"> 
                                                                                            <td height="8" valign="middle" width="17%">&nbsp;</td>
                                                                                            <td height="8" colspan="2" width="83%" valign="top">&nbsp; 
                                                                                            </td>
                                                                                        </tr>
                                                                                        <%if(false){%>
                                                                                        <tr align="left"  id="budgetx"> 
                                                                                            <td height="8" valign="middle" colspan="3"> 
                                                                                                <table width="31%" border="0" cellspacing="1" cellpadding="1">
                                                                                                    <tr> 
                                                                                                        <td class="boxed4"> 
                                                                                                            <%if (isOpeningEditable) {%>
                                                                                                            <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                                                                <tr> 
                                                                                                                    <td width="38%" height="10"></td>
                                                                                                                    <td width="62%" height="10"></td>
                                                                                                                </tr>
                                                                                                                <%
    Vector v = DbPeriode.list(0, 0, "status='" + I_Project.STATUS_PERIOD_OPEN + "'", "");
    Periode p = new Periode();
    if (v != null && v.size() > 0) {
        p = (Periode) v.get(0);
    }

    Vector vx = DbCoaBudget.list(0, 0, "coa_id=" + coa.getOID() + " and periode_id=" + p.getOID(), "");
    CoaBudget cb = new CoaBudget();
    if (vx != null && vx.size() > 0) {
        cb = (CoaBudget) vx.get(0);
    }
                                                                                                                %>
                                                                                                                <input type="hidden" name="open_period" value="<%=p.getOID()%>">
                                                                                                                <tr> 
                                                                                                                    <td width="38%">&nbsp;Opening 
                                                                                                                    Balance</td>
                                                                                                                    <td width="62%"> 
                                                                                                                        <input type="text" name="<%=jspCoa.colNames[JspCoa.JSP_OPENING_BALANCE] %>" value="<%=JSPFormater.formatNumber(coa.getOpeningBalance(), "#,###.#")%>" style="text-align:right" onBlur="javascript:changeOpening()" onClick="this.select()">
                                                                                                                    &nbsp;</td>
                                                                                                                </tr>
                                                                                                                <tr> 
                                                                                                                    <td width="38%">&nbsp;<b><%=p.getName()%></b> Budget</td>
                                                                                                                    <td width="62%"> 
                                                                                                                        <input type="text" name="budget" value="<%=JSPFormater.formatNumber(cb.getAmount(), "#,###.#")%>" style="text-align:right" onBlur="javascript:changeBudget()" onCLick="this.select()">
                                                                                                                        &nbsp;<a href="javascript:cmdBudget()">history</a> 
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                                <tr> 
                                                                                                                    <td width="38%" height="10"></td>
                                                                                                                    <td width="62%" height="10"></td>
                                                                                                                </tr>
                                                                                                            </table>
                                                                                                            <%}%>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr align="left"> 
                                                                                            <td height="8" valign="middle" width="17%">&nbsp;</td>
                                                                                            <td height="8" colspan="2" width="83%" valign="top">&nbsp;</td>
                                                                                        </tr>
                                                                                        <%}%>
                                                                                        <tr align="left" > 
                                                                                            <td colspan="3" class="command" valign="top"> 
                                                                                                <%
            ctrLine.setLocationImg(approot + "/images/ctr_line");
            ctrLine.initDefault();
            ctrLine.setTableWidth("50%");
            String scomDel = "javascript:cmdAsk('" + oidCoa + "')";
            String sconDelCom = "javascript:cmdConfirmDelete('" + oidCoa + "')";
            String scancel = "javascript:cmdEdit('" + oidCoa + "')";
            ctrLine.setBackCaption("Go To Records");
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


            ctrLine.setOnMouseOut("MM_swapImgRestore()");
            ctrLine.setOnMouseOverSave("MM_swapImage('save','','" + approot + "/images/save2.gif',1)");
            ctrLine.setSaveImage("<img src=\"" + approot + "/images/save.gif\" name=\"save\" height=\"22\" border=\"0\">");

            //ctrLine.setOnMouseOut("MM_swapImgRestore()");
            ctrLine.setOnMouseOverBack("MM_swapImage('back','','" + approot + "/images/back2.gif',1)");
            ctrLine.setBackImage("<img src=\"" + approot + "/images/back.gif\" name=\"back\" height=\"22\" border=\"0\">");

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

            if (privAdd == false && privUpdate == false) {
                ctrLine.setSaveCaption("");
            }

            if (privAdd == false) {
                ctrLine.setAddCaption("");
            }

            if (iJSPCommand == JSPCommand.SUBMIT) {
                if (oidCoa == 0) {
                    iJSPCommand = JSPCommand.ADD;
                } else {
                    iJSPCommand = JSPCommand.EDIT;
                }
            }

                                                                                                %>
                                                                                            <%= ctrLine.drawImageOnly(iJSPCommand, iErrCode, msgString)%> </td>
                                                                                        </tr>
                                                                                        <tr> 
                                                                                            <td width="17%">&nbsp;</td>
                                                                                            <td width="83%">&nbsp;</td>
                                                                                        </tr>
                                                                                        <tr align="left" > 
                                                                                            <td colspan="3" valign="top"> 
                                                                                                <div align="left"></div>
                                                                                            </td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                        </table>
                                                                        <script language="JavaScript">
                                                                            cmdChangeType();
                                                                        </script>
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
