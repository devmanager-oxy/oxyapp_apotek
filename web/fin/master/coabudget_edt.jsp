
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.fms.session.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "com.project.fms.master.*" %>
<%@ page import = "com.project.fms.activity.*" %>
<%@ page import = "com.project.system.*" %>
<%@ include file = "../main/javainit.jsp" %>
<%@ include file = "../main/check.jsp" %>
<%
            boolean masterPriv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_BUDGET);
            boolean masterPrivView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_BUDGET, AppMenu.PRIV_VIEW);
            boolean masterPrivUpdate = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_BUDGET, AppMenu.PRIV_UPDATE);
            boolean masterPrivAdd = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_BUDGET, AppMenu.PRIV_ADD);
            boolean masterPrivDelete = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_BUDGET, AppMenu.PRIV_DELETE);
%>

<%!
    public String drawList(Vector objectClass, long departmentId, int month, int year) {

        JSPList cmdist = new JSPList();
        cmdist.setAreaWidth("90%");

        cmdist.setListStyle("listgen");
        cmdist.setTitleStyle("tablehdr");
        cmdist.setCellStyle("tablecell");
        cmdist.setCellStyle1("tablecell1");
        cmdist.setHeaderStyle("tablehdr");

        cmdist.addHeader("No", "3%");
        cmdist.addHeader("Code", "47%");
        cmdist.addHeader("Name", "47%");
        cmdist.addHeader("Proses", "3%");

        cmdist.setLinkRow(0);
        cmdist.setLinkSufix("");
        Vector lstData = cmdist.getData();
        Vector lstLinkData = cmdist.getLinkData();
        cmdist.setLinkPrefix("javascript:cmdEdit('");
        cmdist.setLinkSufix("')");
        cmdist.reset();
        int index = -1;

        int no = 0;

        for (int i = 0; i < objectClass.size(); i++) {

            Coa coa = (Coa) objectClass.get(i);

            no++;

            Vector rowx = new Vector();

            rowx.add("<div align=\"center\">" + no + "</div>");

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

            str = str + coa.getCode() + " - " + coa.getName();

            rowx.add(str);

            CoaBudget coaBudget = new CoaBudget();

            try {
                coaBudget = DbCoaBudget.getValueCoaBudget(coa.getOID(), departmentId, year, month);
            } catch (Exception e) {
                System.out.println("[exception] " + e.toString());
            }

            if (coaBudget != null && coaBudget.getOID() != 0) {

                rowx.add("<div align=\"center\"><input type=\"hidden\" name=\"oid_coa_budget_\"" + no + " value =\"" + coaBudget.getOID() + ">" +
                        "<input type=\"text\" name=\"bgt_\"" + no + " size=\"15\" value =\"" + coaBudget.getAmount() + ">");

            } else {

                rowx.add("<div align=\"center\"><input type=\"hidden\" name=\"oid_coa_budget_\"" + no + " value =\"" + 0 + ">" +
                        "<input type=\"text\" name=\"bgt_\"" + no + " size=\"15\" value =\"" + 0 + ">");

            }

            rowx.add("");

            lstData.add(rowx);

            lstLinkData.add(coa.getOID() + "','" + coa.getCode() + "','" + coa.getName());

        }

        return cmdist.draw(index);
    }

%>

<%

            int iJSPCommand = JSPRequestValue.requestCommand(request);
            int start = JSPRequestValue.requestInt(request, "start");
            int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
            long oidCoa = JSPRequestValue.requestLong(request, "hidden_coa_id");
            int level_coa = JSPRequestValue.requestInt(request, "level_coa");

            String grpType = JSPRequestValue.requestString(request, "groupType");
            int budget_month = JSPRequestValue.requestInt(request, "budget_month");
            int yearx = JSPRequestValue.requestInt(request, "budget_year");            
            long segment1Id = JSPRequestValue.requestLong(request, "segment1_id");

            if (iJSPCommand == JSPCommand.NONE && grpType.length() == 0) {
                grpType = I_Project.accGroup[0];
            }

            /*variable declaration*/
            int recordToGet = 10;

            String whereClause = "";
            if (grpType.equals("")) {
                grpType = "All";
            }

            if (grpType.equals("All")) {
                if (level_coa != -1) {

                    if (level_coa == 1) {
                        whereClause = DbCoa.colNames[DbCoa.COL_LEVEL] + " = " + level_coa;
                    } else if (level_coa == 2) {
                        whereClause = "( " + DbCoa.colNames[DbCoa.COL_LEVEL] + " = 1 or " + DbCoa.colNames[DbCoa.COL_LEVEL] + " = 2 )";
                    } else if (level_coa == 3) {
                        whereClause = "( " + DbCoa.colNames[DbCoa.COL_LEVEL] + " = 1 or " + DbCoa.colNames[DbCoa.COL_LEVEL] + " = 2 or " + DbCoa.colNames[DbCoa.COL_LEVEL] + " = 3 )";
                    } else if (level_coa == 4) {
                        whereClause = "( " + DbCoa.colNames[DbCoa.COL_LEVEL] + " = 1 or " + DbCoa.colNames[DbCoa.COL_LEVEL] + " = 2 or " + DbCoa.colNames[DbCoa.COL_LEVEL] + " = 3 or " + DbCoa.colNames[DbCoa.COL_LEVEL] + " = 4 )";
                    } else if (level_coa == 5) {
                        whereClause = "( " + DbCoa.colNames[DbCoa.COL_LEVEL] + " = 1 or " + DbCoa.colNames[DbCoa.COL_LEVEL] + " = 2 or " + DbCoa.colNames[DbCoa.COL_LEVEL] + " = 3 or " + DbCoa.colNames[DbCoa.COL_LEVEL] + " = 4 or " + DbCoa.colNames[DbCoa.COL_LEVEL] + " = 5 )";
                    }
                }
            } else {

                whereClause = DbCoa.colNames[DbCoa.COL_ACCOUNT_GROUP] + " = '" + grpType + "' ";

                if (level_coa != -1) {

                    if (level_coa == 1) {
                        whereClause = whereClause + " AND ( " + DbCoa.colNames[DbCoa.COL_LEVEL] + " = " + level_coa + " ) ";
                    } else if (level_coa == 2) {
                        whereClause = whereClause + " AND ( " + DbCoa.colNames[DbCoa.COL_LEVEL] + " = 1 or " + DbCoa.colNames[DbCoa.COL_LEVEL] + " = 2 )";
                    } else if (level_coa == 3) {
                        whereClause = whereClause + " AND ( " + DbCoa.colNames[DbCoa.COL_LEVEL] + " = 1 or " + DbCoa.colNames[DbCoa.COL_LEVEL] + " = 2 or " + DbCoa.colNames[DbCoa.COL_LEVEL] + " = 3 )";
                    } else if (level_coa == 4) {
                        whereClause = whereClause + " AND ( " + DbCoa.colNames[DbCoa.COL_LEVEL] + " = 1 or " + DbCoa.colNames[DbCoa.COL_LEVEL] + " = 2 or " + DbCoa.colNames[DbCoa.COL_LEVEL] + " = 3 or " + DbCoa.colNames[DbCoa.COL_LEVEL] + " = 4 )";
                    } else if (level_coa == 5) {
                        whereClause = whereClause + " AND ( " + DbCoa.colNames[DbCoa.COL_LEVEL] + " = 1 or " + DbCoa.colNames[DbCoa.COL_LEVEL] + " = 2 or " + DbCoa.colNames[DbCoa.COL_LEVEL] + " = 3 or " + DbCoa.colNames[DbCoa.COL_LEVEL] + " = 4 or " + DbCoa.colNames[DbCoa.COL_LEVEL] + " = 5 )";
                    }
                }

            }

            String orderClause = "code";
            CmdCoa ctrlCoa = new CmdCoa(request);
            JSPLine ctrLine = new JSPLine();
            Vector listCoa = new Vector(1, 1);

            /*count list All Coa*/
            int vectSize = DbCoa.getCount(whereClause);
            recordToGet = vectSize;

            Coa coa = ctrlCoa.getCoa();

            if ((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV) ||
                    (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)) {
                start = ctrlCoa.actionList(iJSPCommand, start, vectSize, recordToGet);
            }
            /* end switch list*/

            /* get record to display */
            if (iJSPCommand == JSPCommand.LIST || iJSPCommand == JSPCommand.SAVE) {
                listCoa = DbCoa.list(start, recordToGet, whereClause, orderClause);
            }

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

            Date dt = new Date();

            if (yearx != 0) {
                yearx = yearx - 1900;
                dt.setYear(yearx);
            } else {
                yearx = dt.getYear();
            }

            //Vector v = DbPeriode.getAllPeriodInYear(dt);

            if (iJSPCommand == JSPCommand.SAVE && listCoa != null && listCoa.size() > 0) {

                for (int i = 0; i < listCoa.size(); i++) {

                    Coa coax = (Coa) listCoa.get(i);
                    double value = JSPRequestValue.requestDouble(request, "bgt_" + coax.getOID() + "_" + (yearx + 1900) + "_" + budget_month + "_" + segment1Id);
                    DbCoaBudget.processBudgetBySegment(coax.getOID(), (yearx + 1900), budget_month, segment1Id, value, coax.getCode());
                }
            }

            String[] langMD = {"Records", "Editor", "Account Group", "Bulan", "Year", "Location", "Account", "Account Level"};
            String[] langNav = {"Masterdata", "Budget/Target"};

            if (lang == LANG_ID) {
                String[] langID = {"Daftar", "Editor", "Kelompok Perkiraan", "Bulan", "Tahun", "Lokasi", "Perkiraan", "Level Perkiraan"};
                langMD = langID;

                String[] navID = {"Data Induk", "Anggaran/Target"};
                langNav = navID;
            }
            Vector segment1s = DbSegmentUser.userSegments(user.getOID(), 0);
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
                    }else{
                    if(xx==',' || xx=='.'){
                        result = result + xx;
                    }
                }
            }
            
            return result;
        }
        
        function checkNumber(obj){
            
            var st = obj.value;
            
            result = removeChar(st);
            
            result = cleanNumberFloat(result, sysDecSymbol, usrDigitGroup, usrDecSymbol);
            obj.value = formatFloat(result, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 
            
        }
        
        function cmdSearch(){                
            document.frmcoa.command.value="<%=JSPCommand.LIST%>";
            document.frmcoa.action="coabudget_edt.jsp";
            document.frmcoa.submit();
        }    
        
        function cmdAdd(){
            document.frmcoa.hidden_coa_id.value="0";
            document.frmcoa.command.value="<%=JSPCommand.ADD%>";
            document.frmcoa.prev_command.value="<%=prevJSPCommand%>";
            document.frmcoa.action="coabudget_edt.jsp";
            document.frmcoa.submit();
        }
        
        function cmdAsk(oidCoa){
            document.frmcoa.hidden_coa_id.value=oidCoa;
            document.frmcoa.command.value="<%=JSPCommand.ASK%>";
            document.frmcoa.prev_command.value="<%=prevJSPCommand%>";
            document.frmcoa.action="coabudget_edt.jsp";
            document.frmcoa.submit();
        }
        
        function cmdConfirmDelete(oidCoa){
            document.frmcoa.hidden_coa_id.value=oidCoa;
            document.frmcoa.command.value="<%=JSPCommand.DELETE%>";
            document.frmcoa.prev_command.value="<%=prevJSPCommand%>";
            document.frmcoa.action="coabudget_edt.jsp";
            document.frmcoa.submit();
        }
        
        function cmdSave(){
            document.frmcoa.command.value="<%=JSPCommand.SAVE%>";
            document.frmcoa.prev_command.value="<%=prevJSPCommand%>";
            document.frmcoa.action="coabudget_edt.jsp";
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
            document.frmcoa.action="coabudget_edt.jsp";
            document.frmcoa.submit();
        }
        
        
        function printXLS(){
            
            window.open("<%=printroot%>.report.RptCoaFlatXLS"); 				
            }
            
            function cmdAccGroup(){
                document.frmcoa.command.value="<%=JSPCommand.SUBMIT%>";
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
    <body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','../images/printxls2.gif')">
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
                                                                                <td height="22" valign="middle" colspan="3" > 
                                                                                    <table width="100%" border="0" cellpadding="1" height="20" cellspacing="1">
                                                                                        <tr> 
                                                                                            <td colspan="2" class="page">
                                                                                                <table border="0" cellpadding="0" cellspacing="1">
                                                                                                    <tr height="24">
                                                                                                        <td width ="120" class="tablecell1" style="padding:3px;"><%=langMD[2]%></td>
                                                                                                        <td width ="2" class="fontarial">:</td>
                                                                                                        <td width ="100">
                                                                                                            <select name="groupType" class="fontarial">
                                                                                                                <option value="All" <%if (grpType.equals("All")) {%>selected<%}%>>All</option>
                                                                                                                <%for (int i = 0; i < I_Project.accGroup.length; i++) {%>
                                                                                                                <option value="<%=I_Project.accGroup[i]%>" <%if (I_Project.accGroup[i].equals(grpType)) {%>selected<%}%>><%=I_Project.accGroup[i]%></option>
                                                                                                                <%}%>
                                                                                                            </select>
                                                                                                        </td>
                                                                                                        <td width="120">&nbsp;</td>
                                                                                                        <td width="100" class="tablecell1" style="padding:3px;"><%=langMD[3]%></td>
                                                                                                        <td width="2" class="fontarial">:</td>
                                                                                                        <td width = "250"> 
                                                                                                            <%
            Vector key_month = new Vector();
            Vector val_month = new Vector();

            String selectedMonth = "" + budget_month;

            for (int ix = 0; ix < DbCoaBudget.val_Month.length; ix++) {
                key_month.add(DbCoaBudget.key_Month[ix]);
                val_month.add(DbCoaBudget.val_Month[ix]);
            }
                                                                                                            %>                                                                                                            
                                                                                                            <%= JSPCombo.draw("budget_month", null, selectedMonth, val_month, key_month, "", "formElemen") %>    
                                                                                                            &nbsp;&nbsp;<i><%=langMD[4]%></i>&nbsp; 
                                                                                                            <%
            int curryear = (new Date()).getYear() + 1900;
                                                                                                            %>	
                                                                                                            <select name="budget_year" class="fontarial">
                                                                                                                <option value="<%=curryear%>" <%if (yearx == (curryear - 1900)) {%>selected<%}%>><%=curryear%></option>
                                                                                                                <option value="<%=curryear - 1%>" <%if (yearx == (curryear - 1 - 1900)) {%>selected<%}%>><%=curryear - 1%></option>
                                                                                                                <option value="<%=curryear - 2%>" <%if (yearx == (curryear - 2 - 1900)) {%>selected<%}%>><%=curryear - 2%></option>
                                                                                                                <option value="<%=curryear - 3%>" <%if (yearx == (curryear - 3 - 1900)) {%>selected<%}%>><%=curryear - 3%></option>
                                                                                                                <option value="<%=curryear - 4%>" <%if (yearx == (curryear - 4 - 1900)) {%>selected<%}%>><%=curryear - 4%></option>
                                                                                                            </select>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <tr>                                                                                                        
                                                                                                        <td class="tablecell1" style="padding:3px;"><%=langMD[7]%></td>
                                                                                                        <td class="fontarial">:</td>
                                                                                                        <td>
                                                                                                            <select name="level_coa" class="fontarial">
                                                                                                                <option value="-1" <%if (level_coa == 1) {%>selected<%}%>>All Level...</option>
                                                                                                                <option value="1" <%if (level_coa == 1) {%>selected<%}%>>1</option>
                                                                                                                <option value="2" <%if (level_coa == 2) {%>selected<%}%>>2</option>
                                                                                                                <option value="3" <%if (level_coa == 3) {%>selected<%}%>>3</option>
                                                                                                                <option value="4" <%if (level_coa == 4) {%>selected<%}%>>4</option>
                                                                                                                <option value="5" <%if (level_coa == 5) {%>selected<%}%>>5</option>
                                                                                                            </select>
                                                                                                        </td>
                                                                                                        <td>&nbsp;</td>
                                                                                                        <td class="tablecell1" style="padding:3px;"><%=langMD[5]%></td>
                                                                                                        <td class="fontarial">:</td>
                                                                                                        <td>
                                                                                                            <select name="segment1_id">
                                                                                                            <%
            if (segment1s != null && segment1s.size() > 0) {
                for (int i = 0; i < segment1s.size(); i++) {
                    SegmentDetail sd = (SegmentDetail) segment1s.get(i);

                                                                                                            %>
                                                                                                            <option value="<%=sd.getOID()%>" <%if (segment1Id == sd.getOID()) {%>selected<%}%>><%=sd.getName()%></option>
                                                                                                            <%}

                                                                                                            } else {%>
                                                                                                            <option value="<%=0%>" <%if (segment1Id == 0) {%>selected<%}%>>-</option>
                                                                                                            <%}%>      
                                                                                                        </td>
                                                                                                    </tr>                                                                                                    
                                                                                                </table> 
                                                                                            </td>
                                                                                        </tr>  
                                                                                        <tr>    
                                                                                            <td width="100%" height="30px">
                                                                                                <a href="javascript:cmdSearch()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('search','','../images/search2.gif',1)"><img src="../images/search.gif" name="search"  border="0"></a>
                                                                                            </td>
                                                                                        </tr>  
                                                                                        <tr>    
                                                                                            <td width="100%" height="20px"></td>
                                                                                        </tr>  
                                                                                        <%

            if ((iJSPCommand == JSPCommand.LIST || iJSPCommand == JSPCommand.SAVE) && (listCoa != null && listCoa.size() > 0)) {
                                                                                        %>
                                                                                        <tr>
                                                                                            <td colspan="3">
                                                                                                <table border = "0" width="100%" cellpadding="1" cellspacing="1">
                                                                                                    <tr>
                                                                                                        <td width="50%" class="tablehdr" height="22"><div align="center"><b><font color="#FFFFFF"><%=langMD[6]%></font></b></div></td>  
                                                                                                        <td width="50%" class="tablehdr" height="22"><div align="center"><b><font color="#FFFFFF"><%=DbCoaBudget.key_Month[budget_month]%> &nbsp; <%=yearx + 1900%></font></b></div></td>
                                                                                                    </tr>     
                                                                                                    <tr>                                                                                                    
                                                                                                    <%
                                                                                                        int no = 0;

                                                                                                        for (int i = 0; i < listCoa.size(); i++) {
                                                                                                    %>     
                                                                                                    <tr>                    
                                                                                                    <%
                                                                                                        no++;
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
                                                                                                        <td width="23%" height="22" class="<%=cssString%>" nowrap> 
                                                                                                            <%if (coa.getStatus().equals("HEADER")) {%>
                                                                                                            <b> 
                                                                                                                <%}%>
                                                                                                                <%if (masterPrivUpdate) {%>
                                                                                                                <%=str + "<a href=\"javascript:cmdEdit('" + coa.getOID() + "')\">" + coa.getCode() + " - " + coa.getName() + "</a>"%> 
                                                                                                                <%}%>
                                                                                                                <%if (coa.getStatus().equals("HEADER")) {%>
                                                                                                            </b> 
                                                                                                            <%}%>
                                                                                                        </td>
                                                                                                        <%

                                                                                                        CoaBudget coaBudget = new CoaBudget();

                                                                                                        try {
                                                                                                            coaBudget = DbCoaBudget.getValueCoaBudgetBySegment(coa.getOID(), segment1Id, budget_month, yearx + 1900);
                                                                                                        } catch (Exception e) {
                                                                                                            System.out.println("[exception] " + e.toString());
                                                                                                        }

                                                                                                        if (coaBudget != null && coaBudget.getOID() != 0) {

                                                                                                        %>
                                                                                                        <td class="<%=cssString%>"> 
                                                                                                            <div align="center" height="22">                                                                                                                 
                                                                                                                <input type="text" name="bgt_<%=coa.getOID() + "_" + (yearx + 1900) + "_" + budget_month + "_" + segment1Id %>" size="15" value="<%=(coaBudget.getAmount() == 0) ? "0.00" : JSPFormater.formatNumber(coaBudget.getAmount(), "#,###.##")%>" onClick="this.select()" onBlur="javascript:checkNumber(this)" style="text-align:right">
                                                                                                            </div>
                                                                                                        </td>
                                                                                                        <%
                                                                                                                                                                                                                } else {
                                                                                                        %>
                                                                                                        <td class="<%=cssString%>"> 
                                                                                                            <div align="center" height="22">
                                                                                                                <input type="text" name="bgt_<%=coa.getOID() + "_" + (yearx + 1900) + "_" + budget_month + "_" + segment1Id %>" size="15" value="0.00" onClick="this.select()" onBlur="javascript:checkNumber(this)" style="text-align:right">
                                                                                                            </div>
                                                                                                        </td>
                                                                                                        <%}%>
                                                                                                    </tr>
                                                                                                    <%}%>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr> 
                                                                                            <td width="100%" height="22" colspan="3" class="tablecell">&nbsp;</td>										  
                                                                                        </tr>
                                                                                        <%}%>                                                                                        
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                            
                                                                            <%


            if ((iJSPCommand == JSPCommand.LIST || iJSPCommand == JSPCommand.SAVE) && (listCoa != null && listCoa.size() > 0)) {

                                                                            %>
                                                                            <tr>
                                                                                <td>&nbsp;</td>
                                                                            </tr>    
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="22" valign="middle" colspan="3">&nbsp;
                                                                                    <%if (masterPrivAdd || masterPrivUpdate) {%>
                                                                                    <a href="javascript:cmdSave()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new2','','../images/save2.gif',1)"><img src="../images/save.gif" name="new2" height="22" border="0"></a>
                                                                                    <%}%>
                                                                                </td>
                                                                            </tr>
                                                                            <%
            }
                                                                            %>                                                                 
                                                                        </table>
                                                                    </td>
                                                                </tr>
                                                                <tr align="left" valign="top"> 
                                                                    <td height="8" valign="middle" colspan="3">&nbsp; </td>
                                                                </tr>
                                                                <tr align="left" valign="top"> 
                                                                    <td height="8" valign="middle" colspan="3" class="container"> 
                                                                        <%if (false) {//listCoa!=null && listCoa.size()>0){%>
                                                                        <table width="30%" border="0" cellspacing="0" cellpadding="0">
                                                                            <tr> 
                                                                                <td width="71">
                                                                                    <%if (masterPrivUpdate) {%>
                                                                                    <%} else {%>
                                                                                    <a href="javascript:printXLS()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('print1','','../images/printxls2.gif',1)"><img src="../images/printxls.gif" name="print1" width="120" height="22" border="0"></a> 
                                                                                    <%}%>
                                                                                </td>
                                                                                <td width="45">&nbsp;</td>
                                                                                <td width="76">
                                                                                    <%if (masterPrivUpdate) {%>
                                                                                    <a href="javascript:printXLS()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('print','','../images/printxls2.gif',1)"><img src="../images/printxls.gif" name="print" width="120" height="22" border="0">
                                                                                        <%}%>
                                                                                </a></td>
                                                                                <td width="176">&nbsp;</td>
                                                                            </tr>
                                                                        </table>
                                                                        <%}%>
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
