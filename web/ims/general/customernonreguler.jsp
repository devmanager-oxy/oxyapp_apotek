
<%-- 
    Document   : customernonreguler
    Created on : May 20, 2015, 1:09:43 PM
    Author     : Roy
--%>

<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.main.entity.*" %>
<%@ page import = "com.project.admin.*" %>
<%@ page import = "com.project.ccs.session.*" %>
<%@ page import = "com.project.general.*" %>
<%@ include file = "../main/javainit.jsp" %>
<%@ include file = "../main/check.jsp" %>
<%
            boolean priv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MASTER_MAINTENANCE, AppMenu.M2_MEMBER_NON_REGULER);
            boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MASTER_MAINTENANCE, AppMenu.M2_MEMBER_NON_REGULER, AppMenu.PRIV_VIEW);
            boolean privUpdate = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MASTER_MAINTENANCE, AppMenu.M2_MEMBER_NON_REGULER, AppMenu.PRIV_UPDATE);
            boolean privAdd = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MASTER_MAINTENANCE, AppMenu.M2_MEMBER_NON_REGULER, AppMenu.PRIV_ADD);
            boolean privDelete = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MASTER_MAINTENANCE, AppMenu.M2_MEMBER_NON_REGULER, AppMenu.PRIV_DELETE);
            boolean privPrint = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MASTER_MAINTENANCE, AppMenu.M2_MEMBER_NON_REGULER, AppMenu.PRIV_PRINT);
%>
<!-- Jsp Block -->

<%
            int iJSPCommand = JSPRequestValue.requestCommand(request);
            int start = JSPRequestValue.requestInt(request, "start");
            int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
            long oidCustomer = JSPRequestValue.requestLong(request, "hidden_customer_id");

            String code = JSPRequestValue.requestString(request, "src_code");
            String srcName = JSPRequestValue.requestString(request, "src_name");
            String srcAddress = JSPRequestValue.requestString(request, "src_address");
            String srcId = JSPRequestValue.requestString(request, "src_id");
            int statusDraft = JSPRequestValue.requestInt(request, "status_draft");
            int statusApprove = JSPRequestValue.requestInt(request, "status_approve");
            int statusExpired = JSPRequestValue.requestInt(request, "status_expired");
            int type = JSPRequestValue.requestInt(request, "type");
            long srcLocationId = JSPRequestValue.requestLong(request, "src_location_id");

            if (session.getValue("REPORT_CUSTOMER") != null) {
                session.removeValue("REPORT_CUSTOMER");
            }

            Vector locations = userLocations;

            Date regStart = new Date();
            Date regEnd = new Date();
            int regIgnore = JSPRequestValue.requestInt(request, "reg_ignore");

            long oidPub = 0;
            try {
                oidPub = Long.parseLong(DbSystemProperty.getValueByName("OID_CUSTOMER_PUBLIC"));
            } catch (Exception e) {
                oidPub = 0;
            }

            if (JSPRequestValue.requestString(request, "reg_start").length() > 0) {
                regStart = JSPFormater.formatDate(JSPRequestValue.requestString(request, "reg_start"), "dd/MM/yyyy");
            }
            if (JSPRequestValue.requestString(request, "dob_end").length() > 0) {
                regEnd = JSPFormater.formatDate(JSPRequestValue.requestString(request, "reg_end"), "dd/MM/yyyy");
            }


            Date dobStart = new Date();
            Date dobEnd = new Date();
            int dobIgnore = JSPRequestValue.requestInt(request, "dob_ignore");

            if (JSPRequestValue.requestString(request, "dob_start").length() > 0) {
                dobStart = JSPFormater.formatDate(JSPRequestValue.requestString(request, "dob_start"), "dd/MM/yyyy");
            }
            if (JSPRequestValue.requestString(request, "dob_end").length() > 0) {
                dobEnd = JSPFormater.formatDate(JSPRequestValue.requestString(request, "dob_end"), "dd/MM/yyyy");
            }

            if (iJSPCommand == JSPCommand.NONE || iJSPCommand == JSPCommand.BACK) {
                statusDraft = 1;
                statusApprove = 1;
                dobIgnore = 1;
                regIgnore = 1;
                type = -1;
                if (locations.size() != totLocationxAll && locations != null && locations.size() > 0) {
                    try {
                        Location d = (Location) locations.get(0);
                        srcLocationId = d.getOID();
                    } catch (Exception e) {
                    }
                }
            }

            /*variable declaration*/
            int recordToGet = 50;
            String whereClause = "";
            String orderClause = DbCustomer.colNames[DbCustomer.COL_CODE];

            if (type == -1) {
                if (whereClause.length() > 0) {
                    whereClause = whereClause + " and ";
                }
                whereClause = whereClause + DbCustomer.colNames[DbCustomer.COL_TYPE] + " in (" + DbCustomer.CUSTOMER_TYPE_COMPANY + ")";
            } else {
                if (whereClause.length() > 0) {
                    whereClause = whereClause + " and ";
                }
                whereClause = whereClause + DbCustomer.colNames[DbCustomer.COL_TYPE] + " = " + type;
            }

            if (srcLocationId != 0) {
                whereClause = whereClause + " and " + DbCustomer.colNames[DbCustomer.COL_KECAMATAN_ID] + " = " + srcLocationId;
            }

            if (oidPub != 0) {
                whereClause = whereClause + " and " + DbCustomer.colNames[DbCustomer.COL_CUSTOMER_ID] + " != " + oidPub;
            }

            String status = "";
            if (statusDraft == 1 || statusApprove == 1 || statusExpired == 1) {
                if (statusDraft == 1) {
                    if (status.length() > 0) {
                        status = status + ",";
                    }
                    status = status + "'','" + I_Project.DOC_STATUS_DRAFT + "'";
                }

                if (statusApprove == 1) {
                    if (status.length() > 0) {
                        status = status + ",";
                    }
                    status = status + "'" + I_Project.DOC_STATUS_APPROVED + "'";
                }

                if (statusExpired == 1) {
                    if (status.length() > 0) {
                        status = status + ",";
                    }
                    status = status + "'" + I_Project.DOC_STATUS_EXPIRED + "'";
                }
            } else {
                status = "-1";
            }
            if (status.length() > 0) {
                if (whereClause.length() > 0) {
                    whereClause = whereClause + " and ";
                }

                whereClause = whereClause + DbCustomer.colNames[DbCustomer.COL_STATUS] + " in (" + status + ") ";
            }

            if (code != null && code.length() > 0) {
                if (whereClause.length() > 0) {
                    whereClause = whereClause + " and ";
                }
                whereClause = whereClause + DbCustomer.colNames[DbCustomer.COL_CODE] + " like '%" + code + "%' ";
            }

            if (srcName != null && srcName.length() > 0) {
                if (whereClause.length() > 0) {
                    whereClause = whereClause + " and ";
                }
                whereClause = whereClause + DbCustomer.colNames[DbCustomer.COL_NAME] + " like '%" + srcName + "%' ";
            }

            if (srcAddress != null && srcAddress.length() > 0) {
                if (whereClause.length() > 0) {
                    whereClause = whereClause + " and ";
                }
                whereClause = whereClause + DbCustomer.colNames[DbCustomer.COL_ADDRESS_1] + " like '%" + srcAddress + "%' ";
            }

            if (srcId != null && srcId.length() > 0) {
                if (whereClause.length() > 0) {
                    whereClause = whereClause + " and ";
                }
                whereClause = whereClause + DbCustomer.colNames[DbCustomer.COL_ID_NUMBER] + " like '%" + srcId + "%' ";
            }

            if (dobIgnore == 0) {
                if (whereClause.length() > 0) {
                    whereClause = whereClause + " and ";
                }
                whereClause = whereClause + " ( " + DbCustomer.colNames[DbCustomer.COL_DOB] + " between '" + JSPFormater.formatDate(dobStart, "yyyy-MM-dd") + " 00:00:00' and '" + JSPFormater.formatDate(dobEnd, "yyyy-MM-dd") + " 23:59:59') and " + DbCustomer.colNames[DbCustomer.COL_DOB_IGNORE] + " = 0";
            }

            if (regIgnore == 0) {
                if (whereClause.length() > 0) {
                    whereClause = whereClause + " and ";
                }
                whereClause = whereClause + " ( " + DbCustomer.colNames[DbCustomer.COL_REG_DATE] + " between '" + JSPFormater.formatDate(regStart, "yyyy-MM-dd") + " 00:00:00' and '" + JSPFormater.formatDate(regEnd, "yyyy-MM-dd") + " 23:59:59') ";
            }

            CmdCustomerOpr cmdCustomer = new CmdCustomerOpr(request);
            JSPLine ctrLine = new JSPLine();
            Vector listCustomer = new Vector(1, 1);

            /*count list All Customer*/
            int vectSize = DbCustomer.getCount(whereClause);

            if ((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV) ||
                    (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)) {
                start = cmdCustomer.actionList(iJSPCommand, start, vectSize, recordToGet);
            }
            /* end switch list*/

            /* get record to display */
            listCustomer = DbCustomer.list(start, recordToGet, whereClause, orderClause);

            /*handle condition if size of record to display = 0 and start > 0 	after delete*/
            if (listCustomer.size() < 1 && start > 0) {
                if (vectSize - recordToGet > recordToGet) {
                    start = start - recordToGet;
                } //go to JSPCommand.PREV
                else {
                    start = 0;
                    iJSPCommand = JSPCommand.FIRST;
                    prevJSPCommand = JSPCommand.FIRST; //go to JSPCommand.FIRST
                }
                listCustomer = DbCustomer.list(start, recordToGet, whereClause, orderClause);
            }

            Vector list = DbLocation.listAll();
            Hashtable lx = new Hashtable();
            if (list != null && list.size() > 0) {
                for (int i = 0; i < list.size(); i++) {
                    Location l = (Location) list.get(i);
                    lx.put("" + l.getOID(), l.getName());
                }
            }

            MemberParameter memberParameter = new MemberParameter();
            memberParameter.setType(type);
            memberParameter.setName(srcName);
            memberParameter.setCode(code);
            memberParameter.setId(srcId);
            memberParameter.setLocationRegId(srcLocationId);
            memberParameter.setIgnoreReg(regIgnore);
            memberParameter.setRegStart(regStart);
            memberParameter.setRegEnd(regEnd);
            memberParameter.setIgnoreDob(dobIgnore);
            memberParameter.setDobStart(dobStart);
            memberParameter.setDobEnd(dobEnd);
            memberParameter.setAddress(srcAddress);
            memberParameter.setStatusDraft(statusDraft);
            memberParameter.setStatusApprove(statusApprove);
            memberParameter.setStatusExpired(statusExpired);
%>
<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
    <head>
        <!-- #BeginEditable "javascript" --> 
        <title><%=titleIS%></title>
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
        <link href="../css/default.css" rel="stylesheet" type="text/css" />
        <link href="../css/css.css" rel="stylesheet" type="text/css" />
        <script language="JavaScript">
            
            <%if (!priv || !privView) {%>
            window.location="<%=approot%>/nopriv.jsp";
            <%}%>
            
            function cmdPrintXls(){	                       
                window.open("<%=printroot%>.report.ReportCustomerXLS?user_id=<%=appSessUser.getUserOID()%>&lang=<%=lang%>","",'scrollbars=yes,status=yes,width=750,height=600,resizable=yes');
                }
                
                function cmdAdd(){
                    document.frmcustomer.hidden_customer_id.value="0";
                    document.frmcustomer.command.value="<%=JSPCommand.ADD%>";
                    document.frmcustomer.prev_command.value="<%=prevJSPCommand%>";
                    document.frmcustomer.action="customeredt.jsp";
                    document.frmcustomer.submit();
                }
                
                function cmdAsk(oidCustomer){
                    document.frmcustomer.hidden_customer_id.value=oidCustomer;
                    document.frmcustomer.command.value="<%=JSPCommand.ASK%>";
                    document.frmcustomer.prev_command.value="<%=prevJSPCommand%>";
                    document.frmcustomer.action="customernonreguler.jsp";
                    document.frmcustomer.submit();
                }
                
                function cmdConfirmDelete(oidCustomer){
                    document.frmcustomer.hidden_customer_id.value=oidCustomer;
                    document.frmcustomer.command.value="<%=JSPCommand.DELETE%>";
                    document.frmcustomer.prev_command.value="<%=prevJSPCommand%>";
                    document.frmcustomer.action="customernonreguler.jsp";
                    document.frmcustomer.submit();
                }
                function cmdSave(){
                    document.frmcustomer.command.value="<%=JSPCommand.SAVE%>";
                    document.frmcustomer.prev_command.value="<%=prevJSPCommand%>";
                    document.frmcustomer.action="customernonreguler.jsp";
                    document.frmcustomer.submit();
                }
                
                function cmdEdit(oidCustomer){                		
                    document.frmcustomer.hidden_customer_id.value=oidCustomer;
                    document.frmcustomer.command.value="<%=JSPCommand.EDIT%>";
                    document.frmcustomer.prev_command.value="<%=prevJSPCommand%>";
                    document.frmcustomer.action="customeredtnonreguler.jsp";
                    document.frmcustomer.submit();                
                }
                
                function cmdCancel(oidCustomer){
                    document.frmcustomer.hidden_customer_id.value=oidCustomer;
                    document.frmcustomer.command.value="<%=JSPCommand.EDIT%>";
                    document.frmcustomer.prev_command.value="<%=prevJSPCommand%>";
                    document.frmcustomer.action="customernonreguler.jsp";
                    document.frmcustomer.submit();
                }
                
                function cmdBack(){
                    document.frmcustomer.command.value="<%=JSPCommand.BACK%>";
                    document.frmcustomer.action="customernonreguler.jsp";
                    document.frmcustomer.submit();
                }
                
                function cmdListFirst(){
                    document.frmcustomer.command.value="<%=JSPCommand.FIRST%>";
                    document.frmcustomer.prev_command.value="<%=JSPCommand.FIRST%>";
                    document.frmcustomer.action="customernonreguler.jsp";
                    document.frmcustomer.submit();
                }
                
                function cmdListPrev(){
                    document.frmcustomer.command.value="<%=JSPCommand.PREV%>";
                    document.frmcustomer.prev_command.value="<%=JSPCommand.PREV%>";
                    document.frmcustomer.action="customernonreguler.jsp";
                    document.frmcustomer.submit();
                }
                
                function cmdListNext(){
                    document.frmcustomer.command.value="<%=JSPCommand.NEXT%>";
                    document.frmcustomer.prev_command.value="<%=JSPCommand.NEXT%>";
                    document.frmcustomer.action="customernonreguler.jsp";
                    document.frmcustomer.submit();
                }
                
                function cmdListLast(){
                    document.frmcustomer.command.value="<%=JSPCommand.LAST%>";
                    document.frmcustomer.prev_command.value="<%=JSPCommand.LAST%>";
                    document.frmcustomer.action="customernonreguler.jsp";
                    document.frmcustomer.submit();
                }
                
                function cmdSearch(){
                    document.frmcustomer.command.value="<%=JSPCommand.SUBMIT%>";
                    document.frmcustomer.action="customernonreguler.jsp";
                    document.frmcustomer.submit();
                }
                
                function cmdSearchActive(){
                    document.all.searching.style.display="";
                    document.all.activate.style.display="none";
                    document.all.deactivate.style.display="";
                    document.frmcustomer.hidden_search.value="1";
                }
                
                function cmdSearchHide(){
                    document.all.searching.style.display="none";
                    document.all.activate.style.display="";
                    document.all.deactivate.style.display="none";
                    document.frmcustomer.hidden_search.value="0";
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
                                        <td width="165" height="100%" valign="top" background="<%=approot%>/images/leftbg.gif"> 
                                            <!-- #BeginEditable "menu" --> 
              <%@ include file="../main/menu.jsp"%>
              <%@ include file="../calendar/calendarframe.jsp"%>
              <!-- #EndEditable -->
                                        </td>
                                        <td width="100%" valign="top"> 
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">                                                
                                                <tr> 
                                                    <td><!-- #BeginEditable "content" --> 
                                                        <form name="frmcustomer" method ="post" action="">
                                                            <input type="hidden" name="command" value="<%=iJSPCommand%>">
                                                            <input type="hidden" name="vectSize" value="<%=vectSize%>">
                                                            <input type="hidden" name="start" value="<%=start%>">
                                                            <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">    
                                                            <input type="hidden" name="hidden_customer_id" value="<%=oidCustomer%>">   
                                                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr align="left" valign="top"> 
                                                                    <td height="8"  colspan="3"> 
                                                                        <table width="100%" border="0" cellspacing="1" cellpadding="1" height="17">
                                                                            <tr valign="bottom"> 
                                                                                <td width="60%" height="23"><b><font color="#990000" class="lvl1">Master 
                                                                                        Maintenance </font><font class="tit1">&raquo; 
                                                                                        </font><span class="lvl2">Member List (Opr)
                                                                                </span></b></td>
                                                                                <td width="40%" height="23"> 
                                                                                    <%@ include file = "../main/userpreview.jsp" %>
                                                                                </td>
                                                                            </tr>
                                                                            <tr > 
                                                                                <td colspan="2" height="3" background="../images/line1.gif" ></td>
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                </tr>
                                                                <tr align="left" valign="top"> 
                                                                    <td height="8"  colspan="3" class="container"> 
                                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                            <tr  id="searching"> 
                                                                                <td height="14" valign="top" colspan="3" class="comment" width="99%"> 
                                                                                    <table border="0" cellspacing="1" cellpadding="0">
                                                                                        <tr> 
                                                                                            <td width="100" height="8"></td>
                                                                                            <td width="1" height="8"></td>
                                                                                            <td width="200" height="8"></td>
                                                                                            <td width="100" height="8"></td>
                                                                                            <td width="1" height="8"></td>
                                                                                            <td width="150" height="8"></td>
                                                                                        </tr>
                                                                                        <tr> 
                                                                                            <td colspan="4" class="fontarial"><b><i>Search Parameter :</i></b></td>
                                                                                        </tr>
                                                                                        <tr height="22"> 
                                                                                            <td nowrap class="tablearialcell1">&nbsp;Type</td>
                                                                                            <td class="fontarial">:</td>
                                                                                            <td >
                                                                                                <select name="type" class="fontarial">
                                                                                                    <option value="<%=-1%>" <%if (type == -1) {%> selected<%}%> >- All Type -</option>
                                                                                                    <option value="<%=DbCustomer.CUSTOMER_TYPE_COMPANY%>" <%if (type == DbCustomer.CUSTOMER_TYPE_COMPANY) {%> selected<%}%> ><%=DbCustomer.customerGroup[DbCustomer.CUSTOMER_TYPE_COMPANY]%> </option>                                                                                                    
                                                                                                </select>
                                                                                            </td>
                                                                                            <td class="tablearialcell1">&nbsp;Reg. Date</td>
                                                                                            <td class="fontarial">:</td>
                                                                                            <td >
                                                                                                <table border="0" cellpadding="0" cellspacing="0">
                                                                                                    <tr>
                                                                                                        <td><input name="reg_start" value="<%=JSPFormater.formatDate((regStart == null) ? new Date() : regStart, "dd/MM/yyyy")%>" size="11" readonly></td>
                                                                                                        <td><a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmcustomer.reg_start);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a></td>
                                                                                                        <td class="fontarial">&nbsp;&nbsp;to&nbsp;&nbsp;</td>
                                                                                                        <td><input name="reg_end" value="<%=JSPFormater.formatDate((regEnd == null) ? new Date() : regEnd, "dd/MM/yyyy")%>" size="11" readonly></td>
                                                                                                        <td><a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmcustomer.reg_end);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a></td>
                                                                                                        <td><input type="checkbox"  name="reg_ignore" value="1" <%if (regIgnore == 1) {%> checked<%}%> ></td>
                                                                                                        <td class="fontarial">Ignore</td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr height="23"> 
                                                                                            <td class="tablearialcell">&nbsp;Name</td>
                                                                                            <td class="fontarial">:</td>
                                                                                            <td ><input type="text" name="src_name" value="<%=srcName%>" class="fontarial" size="20"></td>
                                                                                            <td class="tablearialcell">&nbsp;Date Of Birth</td>
                                                                                            <td class="fontarial">:</td>
                                                                                            <td >
                                                                                                <table border="0" cellpadding="0" cellspacing="0">
                                                                                                    <tr>
                                                                                                        <td><input name="dob_start" value="<%=JSPFormater.formatDate((dobStart == null) ? new Date() : dobStart, "dd/MM/yyyy")%>" size="11" readonly></td>
                                                                                                        <td><a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmcustomer.dob_start);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a></td>
                                                                                                        <td class="fontarial">&nbsp;&nbsp;to&nbsp;&nbsp;</td>
                                                                                                        <td><input name="dob_end" value="<%=JSPFormater.formatDate((dobEnd == null) ? new Date() : dobEnd, "dd/MM/yyyy")%>" size="11" readonly></td>
                                                                                                        <td><a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmcustomer.dob_end);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a></td>
                                                                                                        <td><input type="checkbox"  name="dob_ignore" value="1" <%if (dobIgnore == 1) {%> checked<%}%> ></td>
                                                                                                        <td class="fontarial">Ignore</td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr height="22"> 
                                                                                            <td nowrap class="tablearialcell1">&nbsp;Code</td>
                                                                                            <td class="fontarial">:</td>
                                                                                            <td ><input type="text" name="src_code"  value="<%=code%>" class="fontarial" size="20"></td>
                                                                                            <td class="tablearialcell1">&nbsp;Address</td>
                                                                                            <td class="fontarial">:</td>
                                                                                            <td ><input type="text" name="src_address" value="<%=srcAddress%>" class="fontarial" size="20"></td>
                                                                                        </tr>
                                                                                        <tr height="22"> 
                                                                                            <td nowrap class="tablearialcell">&nbsp;ID / KTP Member</td>
                                                                                            <td class="fontarial">:</td>
                                                                                            <td ><input type="text" name="src_id"  value="<%=srcId%>" class="fontarial" size="20"></td>
                                                                                            <td class="tablearialcell">&nbsp;Status</td>
                                                                                            <td class="fontarial">:</td>
                                                                                            <td >
                                                                                                <table border="0" cellpadding="0" cellspacing="0">
                                                                                                    <tr>
                                                                                                        <td><input type="checkbox" name="status_draft" value="1" <%if (statusDraft == 1) {%> checked<%}%> ></td>
                                                                                                        <td class="fontarial">&nbsp;Draft</td>
                                                                                                        <td>&nbsp;&nbsp;<input type="checkbox" name="status_approve" value="1" <%if (statusApprove == 1) {%> checked<%}%> ></td>
                                                                                                        <td class="fontarial">&nbsp;Approve</td>
                                                                                                        <td>&nbsp;&nbsp;<input type="checkbox" name="status_expired" value="1" <%if (statusExpired == 1) {%> checked<%}%> ></td>
                                                                                                        <td class="fontarial">&nbsp;Expired</td>
                                                                                                    </tr>    
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr height="22"> 
                                                                                            <td nowrap class="tablearialcell1">&nbsp;Location Reg.</td>
                                                                                            <td class="fontarial">:</td>
                                                                                            <td colspan="4">
                                                                                                <select name="src_location_id">                                                                                                                
                                                                                                    <%if (locations.size() == totLocationxAll) {%>
                                                                                                    <option value="0" <%if (srcLocationId == 0) {%>selected<%}%>>- All Location -</option>
                                                                                                    <%
            }
            if (locations != null && locations.size() > 0) {
                for (int i = 0; i < locations.size(); i++) {
                    Location d = (Location) locations.get(i);

                                                                                                    %>
                                                                                                    <option value="<%=d.getOID()%>" <%if (srcLocationId == d.getOID()) {%>selected<%}%>><%=d.getName()%></option>
                                                                                                    <%}
            }%>
                                                                                                </select>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr> 
                                                                                            <td colspan="6" height="2"> 
                                                                                                <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                                                    <tr > 
                                                                                                        <td height="3" background="../images/line1.gif" ></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr> 
                                                                                            <td colspan="6"> 
                                                                                                <a href="javascript:cmdSearch()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('sr21','','../images/search2.gif',1)"><img src="../images/search.gif" name="sr21" border="0"></a>
                                                                                            </td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td height="8" valign="middle" colspan="3" class="comment" width="99%"></td>
                                                                            </tr>
                                                                            <tr id="activate"> 
                                                                                <td height="14" valign="middle" colspan="3" class="comment" width="99%"><b></b></td>
                                                                            </tr>
                                                                            <%
            try {
                if (listCustomer.size() > 0) {
                                                                            %>
                                                                            
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="22" valign="middle" colspan="3" width="99%"> 
                                                                                    <table width="1150" border="0" cellpadding="1" cellspacing="1">
                                                                                        <tr height="24">
                                                                                            <td class="tablearialhdr" width="15">No.</td>
                                                                                            <td class="tablearialhdr" width="60">Code</td>
                                                                                            <td class="tablearialhdr" width="60">Type</td>
                                                                                            <td class="tablearialhdr" width="70">Reg. Date</td>
                                                                                            <td class="tablearialhdr" >Name</td>
                                                                                            <td class="tablearialhdr" width="100">ID Type / Number</td>
                                                                                            <td class="tablearialhdr" width="120">Telphone / Mobile</td>
                                                                                            <td class="tablearialhdr" width="150">Address</td>
                                                                                            <td class="tablearialhdr" width="150">Location Reg.</td>
                                                                                            <td class="tablearialhdr" width="60">Email</td>                                                                                                                                                                                                                                                                                  
                                                                                            <td class="tablearialhdr" width="70">Status</td>                                                                                            
                                                                                        </tr>
                                                                                        <%
                                                                                    for (int i = 0; i < listCustomer.size(); i++) {
                                                                                        Customer c = (Customer) listCustomer.get(i);

                                                                                        String style = "";
                                                                                        if (i % 2 == 0) {
                                                                                            style = "tablecell";
                                                                                        } else {
                                                                                            style = "tablecell1";
                                                                                        }

                                                                                        String telephone = "";
                                                                                        if (c.getPhone() != null && c.getPhone().length() > 0) {
                                                                                            if (telephone.length() > 0) {
                                                                                                telephone = telephone + ", ";
                                                                                            }
                                                                                            telephone = telephone + "" + c.getPhone();
                                                                                        }

                                                                                        if (c.getHp() != null && c.getHp().length() > 0) {
                                                                                            if (telephone.length() > 0) {
                                                                                                telephone = telephone + ", ";
                                                                                            }
                                                                                            telephone = telephone + "" + c.getHp();
                                                                                        }

                                                                                        String strReg = "";
                                                                                        if (c.getRegDate() != null) {
                                                                                            try {
                                                                                                strReg = JSPFormater.formatDate(c.getRegDate(), "dd MMM yyyy");
                                                                                            } catch (Exception e) {
                                                                                            }
                                                                                        } else {
                                                                                            strReg = "";
                                                                                        }

                                                                                        String sts = "DRAFT";
                                                                                        if (c.getStatus().length() > 0) {
                                                                                            sts = c.getStatus();
                                                                                        }

                                                                                        String locName = "";
                                                                                        try {
                                                                                            locName = String.valueOf(lx.get("" + c.getKecamatanId()));
                                                                                        } catch (Exception e) {
                                                                                            locName = "";
                                                                                        }
                                                                                        
                                                                                        if(locName == null || locName.equals("null")){
                                                                                            locName = "";
                                                                                        }
                                                                                        %>
                                                                                        <tr height="23">
                                                                                            <td class="<%=style%>" align="center"><%=(start + i + 1)%></td>
                                                                                            <td class="<%=style%>" align="left" style="padding:3px;">
                                                                                            <%if (privUpdate || privDelete) {%> <a href="javascript:cmdEdit('<%=c.getOID()%>')"><%}%>  <%=c.getCode() %><%if (privUpdate || privDelete) {%></a><%}%></td>
                                                                                            <td class="<%=style%>" align="left" style="padding:3px;"><%=DbCustomer.customerGroup[c.getType()]%> </td>
                                                                                            <td class="<%=style%>" align="center" style="padding:3px;"><%=strReg%></td>
                                                                                            <td class="<%=style%>" align="left" style="padding:3px;"><%=c.getName()%></td>
                                                                                            <td class="<%=style%>" align="left" style="padding:3px;"><%=(c.getIdType() != null && c.getIdType().length() > 0) ? c.getIdType()+"/" : "" %>  <%=c.getIdNumber() != null ? c.getIdNumber() : "" %></td>
                                                                                            <td class="<%=style%>" align="left" style="padding:3px;"><%=telephone%></td>  
                                                                                            <td class="<%=style%>" align="left" style="padding:3px;"><%=c.getAddress1()%></td>        
                                                                                            <td class="<%=style%>" align="left" style="padding:3px;"><%=locName%></td>    
                                                                                            <td class="<%=style%>" align="left" style="padding:3px;"><%=c.getEmail()%></td>                                                                                                                                                                                        
                                                                                            <%if (sts.compareTo(I_Project.DOC_STATUS_DRAFT) == 0 || sts.compareTo(I_Project.DOC_STATUS_APPROVED) == 0) {%>
                                                                                            <td bgcolor="72D5BF" align="center" class="fontarial"><font size="1"><%=sts%></font></td>
                                                                                            <%} else {%>
                                                                                            <td bgcolor="D4543A" align="center" class="fontarial"><font size="1"><%=sts%></font></td>
                                                                                            <%}%>
                                                                                        </tr>
                                                                                        <%}%>
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                            
                                                                            
                                                                            <%  }
            } catch (Exception exc) {
            }%>
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="8" align="left" colspan="3" class="command" width="99%"> 
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
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="8" valign="middle" colspan="3">&nbsp; </td>
                                                                            </tr>
                                                                            <%
                                                                            if (privAdd || privPrint) {

                session.putValue("REPORT_CUSTOMER", memberParameter);
                                                                            %>
                                                                            <tr align="left" valign="top"> 
                                                                                <td colspan="3">
                                                                                    <table>
                                                                                        <tr>
                                                                                            <%if(privAdd){%>
                                                                                            <td width="25"><a href="javascript:cmdAdd()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('add','','../images/add2.gif',1)"><img src="../images/add.gif" name="add" border="0"></td>
                                                                                            <td width="15"></td>
                                                                                            <%}%>
                                                                                            <%if(privPrint){%>
                                                                                            <td width="25"><a href="javascript:cmdPrintXls()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('print1','','../images/printxls2.gif',1)"><img src="../images/printxls.gif" name="print1" height="22" border="0"></a></td>
                                                                                            <%}%>
                                                                                        </tr>    
                                                                                    </table>    
                                                                                </td>                                                                                
                                                                            </tr>
                                                                            <%}%>
                                                                            
                                                                            <tr align="left" valign="top" height="35"> 
                                                                                <td colspan="3"></td>
                                                                            </tr>    
                                                                        </table>
                                                                    </td>
                                                                </tr>                                                                
                                                            </table>
                                                        </form>
                                                        <!-- #EndEditable -->
                                                    </td>
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
