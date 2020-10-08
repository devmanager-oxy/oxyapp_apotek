
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "com.project.general.*" %>
<%@ page import = "com.project.system.*" %>
<%@ page import = "com.project.ccs.posmaster.*" %>
<%@ page import = "com.project.fms.master.*" %>
<%@ include file = "../main/javainit.jsp" %>
<%@ include file = "../main/check.jsp" %>
<%@ include file="../calendar/calendarframe.jsp"%>
<%
            boolean priv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MASTER_MAINTENANCE, AppMenu.M2_MASTER_GENERAL);
            boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MASTER_MAINTENANCE, AppMenu.M2_MASTER_GENERAL, AppMenu.PRIV_VIEW);
            boolean privUpdate = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MASTER_MAINTENANCE, AppMenu.M2_MASTER_GENERAL, AppMenu.PRIV_UPDATE);
            boolean privAdd = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MASTER_MAINTENANCE, AppMenu.M2_MASTER_GENERAL, AppMenu.PRIV_ADD);
            boolean privDelete = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MASTER_MAINTENANCE, AppMenu.M2_MASTER_GENERAL, AppMenu.PRIV_DELETE);
%>
<!-- Jsp Block -->
<%!
    public String drawList(Location objEntity, Vector objectClass, long locationId, int start) {
        JSPList jsplist = new JSPList();
        jsplist.setAreaWidth("1300");
        jsplist.setListStyle("listgen");
        jsplist.setTitleStyle("tablearialhdr");
        jsplist.setCellStyle("tablearialcell");
        jsplist.setCellStyle1("tablearialcell1");
        jsplist.setHeaderStyle("tablearialhdr");

        jsplist.addHeader("No", "20", "2", "0");
        jsplist.addHeader("Type", "60", "2", "0");
        jsplist.addHeader("Code", "40", "2", "0");
        jsplist.addHeader("Name", "", "2", "0");
        jsplist.addHeader("Start", "60", "2", "0");
        jsplist.addHeader("Gol Price", "50", "2", "0");
        jsplist.addHeader("Target Amount", "50", "2", "0");

        jsplist.addHeader("Chart of account", "", "0", "9");
        jsplist.addHeader("Coa AR", "100", "0", "0");
        jsplist.addHeader("Coa AP", "100", "0", "0");
        jsplist.addHeader("Coa AP Grosir", "100", "0", "0");
        jsplist.addHeader("Coa PPN", "100", "0", "0");
        jsplist.addHeader("Coa PPH", "100", "0", "0");
        jsplist.addHeader("Coa Discount", "100", "0", "0");
        jsplist.addHeader("Coa Sales", "100", "0", "0");
        jsplist.addHeader("Coa PPH23", "100", "0", "0");
        jsplist.addHeader("Coa PPH22", "100", "0", "0");

        jsplist.addHeader("Type Grosir", "60", "2", "0");

        jsplist.setLinkRow(0);
        jsplist.setLinkSufix("");
        Vector lstData = jsplist.getData();
        Vector lstLinkData = jsplist.getLinkData();
        Vector rowx = new Vector(1, 1);
        jsplist.reset();
        int index = -1;

        /* selected Type*/
        Vector type_value = new Vector(1, 1);
        Vector type_key = new Vector(1, 1);

        for (int i = 0; i < DbLocation.strLocTypes.length; i++) {
            type_value.add(DbLocation.strLocTypes[i]);
            type_key.add(DbLocation.strLocTypes[i]);
        }

        Vector coas = DbCoa.list(0, 0, "", "code");

        //COA AR ID
        Vector coaarid_value = new Vector(1, 1);
        Vector coaarid_key = new Vector(1, 1);
        coaarid_value.add("- ");
        coaarid_key.add("0");

        if (coas != null && coas.size() > 0) {
            for (int i = 0; i < coas.size(); i++) {
                Coa coa = (Coa) coas.get(i);

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

                coaarid_key.add("" + coa.getOID());
                coaarid_value.add(str + coa.getCode() + " - " + coa.getName());
            }
        }

        //COA AP Grosir ID        
        Vector coaapGrosirid_value = new Vector(1, 1);
        Vector coaapGrosirid_key = new Vector(1, 1);

        coaapGrosirid_value.add("-");
        coaapGrosirid_key.add("0");

        if (coas != null && coas.size() > 0) {
            for (int i = 0; i < coas.size(); i++) {
                Coa coa = (Coa) coas.get(i);

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

                coaapGrosirid_key.add("" + coa.getOID());
                coaapGrosirid_value.add(str + coa.getCode() + " - " + coa.getName());
            }
        }
        
        
        Vector coaapid_value = new Vector(1, 1);
        Vector coaapid_key = new Vector(1, 1);

        coaapid_value.add("-");
        coaapid_key.add("0");

        if (coas != null && coas.size() > 0) {
            for (int i = 0; i < coas.size(); i++) {
                Coa coa = (Coa) coas.get(i);

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

                coaapid_key.add("" + coa.getOID());
                coaapid_value.add(str + coa.getCode() + " - " + coa.getName());
            }
        }

        //COA PPN ID
        Vector coappnid_value = new Vector(1, 1);
        Vector coappnid_key = new Vector(1, 1);
        coappnid_value.add("-");
        coappnid_key.add("0");

        if (coas != null && coas.size() > 0) {
            for (int i = 0; i < coas.size(); i++) {
                Coa coa = (Coa) coas.get(i);

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

                coappnid_key.add("" + coa.getOID());
                coappnid_value.add(str + coa.getCode() + " - " + coa.getName());
            }
        }

        //COA PPH ID
        Vector coapphid_value = new Vector(1, 1);
        Vector coapphid_key = new Vector(1, 1);
        coapphid_value.add("- ");
        coapphid_key.add("0");

        if (coas != null && coas.size() > 0) {
            for (int i = 0; i < coas.size(); i++) {
                Coa coa = (Coa) coas.get(i);

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

                coapphid_key.add("" + coa.getOID());
                coapphid_value.add(str + coa.getCode() + " - " + coa.getName());
            }
        }

        //COA DISCOUNT ID
        Vector coadiscountid_value = new Vector(1, 1);
        Vector coadiscountid_key = new Vector(1, 1);

        coadiscountid_value.add("- ");
        coadiscountid_key.add("0");

        if (coas != null && coas.size() > 0) {
            for (int i = 0; i < coas.size(); i++) {
                Coa coa = (Coa) coas.get(i);

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

                coadiscountid_key.add("" + coa.getOID());
                coadiscountid_value.add(str + coa.getCode() + " - " + coa.getName());
            }
        }


        //COA SALES ID
        Vector coasalesid_value = new Vector(1, 1);
        Vector coasalesid_key = new Vector(1, 1);

        coasalesid_value.add("- ");
        coasalesid_key.add("0");

        if (coas != null && coas.size() > 0) {
            for (int i = 0; i < coas.size(); i++) {
                Coa coa = (Coa) coas.get(i);

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

                coasalesid_key.add("" + coa.getOID());
                coasalesid_value.add(str + coa.getCode() + " - " + coa.getName());
            }
        }

        //COA PPH 23 ID
        Vector coapph23id_value = new Vector(1, 1);
        Vector coapph23id_key = new Vector(1, 1);

        coapph23id_value.add("- ");
        coapph23id_key.add("0");

        if (coas != null && coas.size() > 0) {
            for (int i = 0; i < coas.size(); i++) {
                Coa coa = (Coa) coas.get(i);

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

                coapph23id_key.add("" + coa.getOID());
                coapph23id_value.add(str + coa.getCode() + " - " + coa.getName());
            }
        }

        //COA PPH 22 ID
        Vector coapph22id_value = new Vector(1, 1);
        Vector coapph22id_key = new Vector(1, 1);
        String sel_coapph22id = "" + objEntity.getCoaProjectPPHPasal22Id();

        coapph22id_value.add("- ");
        coapph22id_key.add("0");

        if (coas != null && coas.size() > 0) {
            for (int i = 0; i < coas.size(); i++) {
                Coa coa = (Coa) coas.get(i);

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

                coapph22id_key.add("" + coa.getOID());
                coapph22id_value.add(str + coa.getCode() + " - " + coa.getName());
            }
        }

        for (int i = 0; i < objectClass.size(); i++) {
            Location location = (Location) objectClass.get(i);
            rowx = new Vector();
            if (locationId == location.getOID()) {
                index = i;
            }

            rowx.add("<div align=\"center\">" + (start + i + 1) + "</div>");
            rowx.add("<a href=\"javascript:cmdEdit('" + String.valueOf(location.getOID()) + "')\">" + location.getType() + "</a>");
            rowx.add(location.getCode());
            rowx.add(location.getName());
            String dateStart = "";
            if (location.getDateStart() != null) {
                try {
                    dateStart = JSPFormater.formatDate(location.getDateStart());
                } catch (Exception e) {
                }
            }
            rowx.add(dateStart);
            rowx.add(location.getGol_price());
            rowx.add(JSPFormater.formatNumber(location.getAmountTarget(),"###,###.##"));

            Coa coa = new Coa();
            try {
                coa = DbCoa.fetchExc(location.getCoaArId());
            } catch (Exception e) {
            }

            rowx.add(coa.getCode() + " - " + coa.getName());

            coa = new Coa();
            try {
                coa = DbCoa.fetchExc(location.getCoaApId());
            } catch (Exception e) {
            }

            rowx.add(coa.getCode() + " - " + coa.getName());
            
            
            coa = new Coa();
            try {
                coa = DbCoa.fetchExc(location.getCoaApGrosirId());
            } catch (Exception e) {
            }

            rowx.add(coa.getCode() + " - " + coa.getName());

            coa = new Coa();
            try {
                coa = DbCoa.fetchExc(location.getCoaPpnId());
            } catch (Exception e) {
            }

            rowx.add(coa.getCode() + " - " + coa.getName());

            coa = new Coa();
            try {
                coa = DbCoa.fetchExc(location.getCoaPphId());
            } catch (Exception e) {
            }

            rowx.add(coa.getCode() + " - " + coa.getName());

            coa = new Coa();
            try {
                coa = DbCoa.fetchExc(location.getCoaDiscountId());
            } catch (Exception e) {
            }

            rowx.add(coa.getCode() + " - " + coa.getName());

            coa = new Coa();
            try {
                coa = DbCoa.fetchExc(location.getCoaSalesId());
            } catch (Exception e) {
            }

            rowx.add(coa.getCode() + " - " + coa.getName());

            coa = new Coa();
            try {
                coa = DbCoa.fetchExc(location.getCoaProjectPPHPasal23Id());
            } catch (Exception e) {
            }

            rowx.add(coa.getCode() + " - " + coa.getName());

            coa = new Coa();
            try {
                coa = DbCoa.fetchExc(location.getCoaProjectPPHPasal22Id());
            } catch (Exception e) {
            }

            rowx.add(coa.getCode() + " - " + coa.getName());
            rowx.add(DbLocation.strKeyTypes[location.getTypeGrosir()]);
            lstData.add(rowx);
        }

        return jsplist.drawList(index);
    }

%>
<%
            int iJSPCommand = JSPRequestValue.requestCommand(request);
            int start = JSPRequestValue.requestInt(request, "start");
            int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
            long oidLocation = JSPRequestValue.requestLong(request, "hidden_location_id");
            int showAll = JSPRequestValue.requestInt(request, "show_all");

            /*variable declaration*/
            int recordToGet = 20;
            String msgString = "";
            int iErrCode = JSPMessage.NONE;
            String whereClause = "";
            String orderClause = "";

            CmdLocation ctrlLocation = new CmdLocation(request);
            ctrlLocation.setUserId(user.getOID());
            ctrlLocation.setEmployeeId(user.getEmployeeId());
            JSPLine jspLine = new JSPLine();
            Vector listLocation = new Vector(1, 1);

            /*switch statement */
            iErrCode = ctrlLocation.action(iJSPCommand, oidLocation);
            /* end switch*/
            JspLocation jspLocation = ctrlLocation.getForm();

            /*count list All Location*/
            int vectSize = DbLocation.getCount(whereClause);

            /*switch list Location*/
            if ((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV) ||
                    (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)) {
                start = ctrlLocation.actionList(iJSPCommand, start, vectSize, recordToGet);
            }
            /* end switch list*/

            Location location = ctrlLocation.getLocation();
            msgString = ctrlLocation.getMessage();

            /* get record to display */
            listLocation = DbLocation.list(start, recordToGet, whereClause, orderClause);

            /*handle condition if size of record to display = 0 and start > 0 	after delete*/
            if (listLocation.size() < 1 && start > 0) {
                if (vectSize - recordToGet > recordToGet) {
                    start = start - recordToGet;
                } //go to JSPCommand.PREV
                else {
                    start = 0;
                    iJSPCommand = JSPCommand.FIRST;
                    prevJSPCommand = JSPCommand.FIRST; //go to JSPCommand.FIRST
                }
                listLocation = DbLocation.list(start, recordToGet, whereClause, orderClause);
            }
%>
<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
    <head>
        <!-- #BeginEditable "javascript" --> 
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <title><%=titleIS%></title>
        <link href="../css/css.css" rel="stylesheet" type="text/css" />
        <script language="JavaScript">
            
            <%if (!priv || !privView) {%>
            window.location="<%=approot%>/nopriv.jsp";
            <%}%>
            
            function cmdUnShowAll(){                
                document.frmlocation.command.value="<%=JSPCommand.LIST%>";                
                document.frmlocation.show_all.value=0;
                document.frmlocation.action="location.jsp";
                document.frmlocation.submit();
            }
            
            function cmdShowAll(){                
                document.frmlocation.command.value="<%=JSPCommand.LIST%>";                
                document.frmlocation.show_all.value=1;
                document.frmlocation.action="location.jsp";
                document.frmlocation.submit();
            }
            
            function cmdAdd(){
                document.frmlocation.hidden_location_id.value="0";
                document.frmlocation.command.value="<%=JSPCommand.ADD%>";
                document.frmlocation.prev_command.value="<%=prevJSPCommand%>";
                document.frmlocation.action="location.jsp";
                document.frmlocation.submit();
            }
            
            function cmdAsk(oidLocation){
                document.frmlocation.hidden_location_id.value=oidLocation;
                document.frmlocation.command.value="<%=JSPCommand.ASK%>";
                document.frmlocation.prev_command.value="<%=prevJSPCommand%>";
                document.frmlocation.action="location.jsp";
                document.frmlocation.submit();
            }
            
            function cmdConfirmDelete(oidLocation){
                document.frmlocation.hidden_location_id.value=oidLocation;
                document.frmlocation.command.value="<%=JSPCommand.DELETE%>";
                document.frmlocation.prev_command.value="<%=prevJSPCommand%>";
                document.frmlocation.action="location.jsp";
                document.frmlocation.submit();
            }
            
            function cmdSave(){
                document.frmlocation.command.value="<%=JSPCommand.SAVE%>";
                document.frmlocation.prev_command.value="<%=prevJSPCommand%>";
                document.frmlocation.action="location.jsp";
                document.frmlocation.submit();
            }
            
            function cmdEdit(oidLocation){
                <%if (privAdd || privUpdate || privDelete) {%>
                document.frmlocation.hidden_location_id.value=oidLocation;
                document.frmlocation.command.value="<%=JSPCommand.EDIT%>";
                document.frmlocation.prev_command.value="<%=prevJSPCommand%>";
                document.frmlocation.action="location.jsp";
                document.frmlocation.submit();
                <%}%>
            }
            
            function cmdCancel(oidLocation){
                document.frmlocation.hidden_location_id.value=oidLocation;
                document.frmlocation.command.value="<%=JSPCommand.EDIT%>";
                document.frmlocation.prev_command.value="<%=prevJSPCommand%>";
                document.frmlocation.action="location.jsp";
                document.frmlocation.submit();
            }
            
            function cmdBack(){
                document.frmlocation.command.value="<%=JSPCommand.BACK%>";
                document.frmlocation.action="location.jsp";
                document.frmlocation.submit();
            }
            
            function cmdListFirst(){
                document.frmlocation.command.value="<%=JSPCommand.FIRST%>";
                document.frmlocation.prev_command.value="<%=JSPCommand.FIRST%>";
                document.frmlocation.action="location.jsp";
                document.frmlocation.submit();
            }
            
            function cmdListPrev(){
                document.frmlocation.command.value="<%=JSPCommand.PREV%>";
                document.frmlocation.prev_command.value="<%=JSPCommand.PREV%>";
                document.frmlocation.action="location.jsp";
                document.frmlocation.submit();
            }
            
            function cmdListNext(){
                document.frmlocation.command.value="<%=JSPCommand.NEXT%>";
                document.frmlocation.prev_command.value="<%=JSPCommand.NEXT%>";
                document.frmlocation.action="location.jsp";
                document.frmlocation.submit();
            }
            
            function cmdListLast(){
                document.frmlocation.command.value="<%=JSPCommand.LAST%>";
                document.frmlocation.prev_command.value="<%=JSPCommand.LAST%>";
                document.frmlocation.action="location.jsp";
                document.frmlocation.submit();
            }
            
            //-------------- script form image -------------------
            
            function cmdDelPict(oidLocation){
                document.frmimage.hidden_location_id.value=oidLocation;
                document.frmimage.command.value="<%=JSPCommand.POST%>";
                document.frmimage.action="location.jsp";
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
        <!-- #EndEditable -->
    </head>
    <body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','../images/new2.gif')">
        <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
            <tr> 
                <td valign="top"> 
                    <table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
                        <tr> 
                            <td height="96"> 
                                <!-- #BeginEditable "header" --> 
            <%@ include file = "../main/hmenu.jsp" %>
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
                                            <!-- #EndEditable -->
                                        </td>
                                        <td width="100%" valign="top"> 
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                
                                                <tr> 
                                                    <td><!-- #BeginEditable "content" --> 
                                                        <form name="frmlocation" method ="post" action="">
                                                            <input type="hidden" name="command" value="<%=iJSPCommand%>">
                                                            <input type="hidden" name="vectSize" value="<%=vectSize%>">
                                                            <input type="hidden" name="start" value="<%=start%>">
                                                            <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                                                            <input type="hidden" name="show_all" value="0">
                                                            <input type="hidden" name="hidden_location_id" value="<%=oidLocation%>">
                                                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr> 
                                                                    <td> 
                                                                        <table width="100%" border="0" cellspacing="1" cellpadding="1" height="17">
                                                                            <tr valign="bottom"> 
                                                                                <td width="60%" height="24"><b><font color="#990000" class="lvl1">Master 
                                                                                        Maintenance </font><font class="tit1">&raquo; 
                                                                                </font> <span class="lvl2">Location</span></b></td>
                                                                                <td width="40%" height="24"> 
                                                                                    <%@ include file = "../main/userpreview.jsp" %>
                                                                                </td>
                                                                            </tr>
                                                                            <tr > 
                                                                                <td colspan="2" height="3" background="<%=approot%>/images/line1.gif" ></td>
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                </tr>
                                                                <tr> 
                                                                    <td class="container"> 
                                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="8"  colspan="3"> 
                                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="5" valign="middle" colspan="3" class="comment"></td>
                                                                                        </tr>
                                                                                        <%
            try {
                                                                                        %>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="22" valign="middle" colspan="3"> 
                                                                                            <%= drawList(location, listLocation, oidLocation, start)%> </td>
                                                                                        </tr>
                                                                                        <%
            } catch (Exception exc) {
                out.println(exc.toString());
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
                                                                                                    <% jspLine.setLocationImg(approot + "/images/ctr_line");
            jspLine.initDefault();
                                                                                                    %>
                                                                                                <%=jspLine.drawImageListLimit(cmd, vectSize, start, recordToGet)%> </span> 
                                                                                            </td>
                                                                                        </tr>
                                                                                        <%
            if (iJSPCommand != JSPCommand.EDIT && iJSPCommand != JSPCommand.ADD && iJSPCommand != JSPCommand.ASK && iErrCode == 0) {
                                                                                        %>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="5" valign="middle" colspan="3"></td>
                                                                                        </tr>
                                                                                        <%if (privAdd) {%>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="22" valign="middle" colspan="3"><a href="javascript:cmdAdd()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new21','','../images/new2.gif',1)"><img src="../images/new.gif" name="new21" width="71" height="22" border="0"></a></td>
                                                                                        </tr>
                                                                                        <%}%>
                                                                                        <%}%>
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="8" valign="middle" width="17%">&nbsp;</td>
                                                                                <td height="8" colspan="2" width="83%">&nbsp; </td>
                                                                            </tr>
                                                                            <tr align="left" valign="top"> 
                                                                                <td valign="middle" colspan="3"> 
                                                                                    <%if ((iJSPCommand == JSPCommand.ADD) || (iJSPCommand == JSPCommand.SAVE && iErrCode != 0) || (iJSPCommand == JSPCommand.EDIT) || (iJSPCommand == JSPCommand.ASK)) {%>
                                                                                    <table width="100%" border="0" cellspacing="1" cellpadding="0">
                                                                                        <tr align="left"> 
                                                                                            <td height="21" width="170">&nbsp;Type</td>
                                                                                            <td height="21" colspan="2" valign="top"> 
                                                                                                <select name="<%=jspLocation.colNames[JspLocation.JSP_TYPE]%>">                                                                                                    
                                                                                                    <%
    for (int i = 0; i < DbLocation.strLocTypes.length; i++) {

                                                                                                    %>  
                                                                                                    <option value="<%=DbLocation.strLocTypes[i]%>" <%if (DbLocation.strLocTypes[i].compareTo(location.getType()) == 0) {%>selected<%}%>    ><%=DbLocation.strLocTypes[i]%></option>
                                                                                                    
                                                                                                    <%
    }
                                                                                                    %>
                                                                                                </select>
                                                                                            </td> 
                                                                                        </tr> 
                                                                                        <tr align="left"> 
                                                                                            <td height="21" >&nbsp;Code</td>
                                                                                            <td height="21" colspan="2" valign="top"> 
                                                                                                <input type="text" name="<%=jspLocation.colNames[JspLocation.JSP_CODE] %>"  value="<%= location.getCode() %>" class="formElemen" size="5" maxlength="4">
                                                                                            * <%= jspLocation.getErrorMsg(JspLocation.JSP_CODE) %></td> 
                                                                                        </tr> 
                                                                                        <tr align="left"> 
                                                                                            <td height="21" >&nbsp;Name</td>
                                                                                            <td height="21" colspan="2" valign="top"> 
                                                                                                <input type="text" name="<%=jspLocation.colNames[JspLocation.JSP_NAME] %>"  value="<%= location.getName() %>" class="formElemen" size="65">
                                                                                            * <%= jspLocation.getErrorMsg(JspLocation.JSP_NAME) %></td> 
                                                                                        </tr>    
                                                                                        <tr align="left"> 
                                                                                            <td height="21" >&nbsp;Address</td>
                                                                                            <td height="21" colspan="2" valign="top"> 
                                                                                            <textarea name="<%=jspLocation.colNames[JspLocation.JSP_ADDRESS_STREET] %>" class="formElemen" cols="62" rows="2"><%= location.getAddressStreet() %></textarea></td> 
                                                                                        </tr>
                                                                                        <tr align="left"> 
                                                                                            <td height="21" >&nbsp;Telp</td>
                                                                                            <td height="21" colspan="2" valign="top"> 
                                                                                                <input type="text" name="<%=jspLocation.colNames[JspLocation.JSP_TELP] %>"  value="<%= location.getTelp() %>" class="formElemen" size="65">
                                                                                            </td> 
                                                                                        </tr>  
                                                                                        <tr align="left"> 
                                                                                            <td height="21">&nbsp;Pic</td>
                                                                                            <td height="21" colspan="2" valign="top"> 
                                                                                                <input type="text" name="<%=jspLocation.colNames[JspLocation.JSP_PIC] %>"  value="<%=location.getPic() %>" class="formElemen" size="65">
                                                                                            </td> 
                                                                                        </tr> 
                                                                                        <tr align="left">
                                                                                            <td height="21" >&nbsp;Delivery Request</td>
                                                                                            <td > 
                                                                                                <select name="<%=jspLocation.colNames[JspLocation.JSP_LOCATION_ID_REQUEST]%>">
                                                                                                    
                                                                                                    <%
    Vector locations = DbLocation.list(0, 0, "", "name");
    if (locations != null && locations.size() > 0) {
        for (int i = 0; i < locations.size(); i++) {
            Location d = (Location) locations.get(i);
            String str = "";

                                                                                                    %>
                                                                                                    <option value="<%=d.getOID()%>" <%if (location.getLocationIdRequest() == d.getOID()) {%>selected<%}%>><%=d.getName()%></option>
                                                                                                    <%}
    }%>
                                                                                                </select>
                                                                                            </td>
                                                                                            
                                                                                        </tr>
                                                                                        <tr align="left">
                                                                                            <td height="21">&nbsp;Gol Price</td>
                                                                                            <td > 
                                                                                                <select name="<%=jspLocation.colNames[JspLocation.JSP_GOL_PRICE] %>">
                                                                                                    <%
    Location loc = new Location();
    if (oidLocation != 0) {
        try {
            loc = DbLocation.fetchExc(oidLocation);
        } catch (Exception e) {
            loc = new Location();
            loc.setGol_price("");
        }
    } else {
        loc.setGol_price("");
    }
                                                                                                    %>
                                                                                                    
                                                                                                    <%
    if (DbLocation.golPrice.length > 0) {
        for (int i = 0; i < DbLocation.golPrice.length; i++) {

                                                                                                    %>
                                                                                                    
                                                                                                    <option value="<%=DbLocation.golPrice[i]%>" <%if (loc.getGol_price().equalsIgnoreCase(DbLocation.golPrice[i])) {%>selected<%}%>><%=DbLocation.golPrice[i] %></option>
                                                                                                    <%}
    }%>
                                                                                                </select>
                                                                                            </td>
                                                                                            
                                                                                        </tr>
                                                                                        <tr align="left"> 
                                                                                            <td height="21" >&nbsp;Coa AR</td>
                                                                                            <td height="21" colspan="2" valign="top"> 
                                                                                                <%
    Vector coas = DbCoa.list(0, 0, "", "code");

    Vector coaarid_value = new Vector(1, 1);
    Vector coaarid_key = new Vector(1, 1);
    String sel_coaarid = "" + location.getCoaArId();
    coaarid_value.add("- ");
    coaarid_key.add("0");

    if (coas != null && coas.size() > 0) {
        for (int i = 0; i < coas.size(); i++) {
            Coa coa = (Coa) coas.get(i);

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

            coaarid_key.add("" + coa.getOID());
            coaarid_value.add(str + coa.getCode() + " - " + coa.getName());
        }
    }
                                                                                                %>
                                                                                                <%= JSPCombo.draw(jspLocation.colNames[JspLocation.JSP_COA_AR_ID], null, sel_coaarid, coaarid_key, coaarid_value, "", "formElemen") %> 
                                                                                            </td> 
                                                                                        </tr>
                                                                                        <tr align="left"> 
                                                                                            <td height="21" >&nbsp;Coa AP Retail</td>
                                                                                            <td height="21" colspan="2" valign="top"> 
                                                                                                <%
    Vector coaapid_value = new Vector(1, 1);
    Vector coaapid_key = new Vector(1, 1);
    String sel_coaapid = "" + location.getCoaApId();

    coaapid_value.add("- ");
    coaapid_key.add("0");

    if (coas != null && coas.size() > 0) {
        for (int i = 0; i < coas.size(); i++) {
            Coa coa = (Coa) coas.get(i);

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

            coaapid_key.add("" + coa.getOID());
            coaapid_value.add(str + coa.getCode() + " - " + coa.getName());
        }
    }


                                                                                                %>
                                                                                                <%= JSPCombo.draw(jspLocation.colNames[JspLocation.JSP_COA_AP_ID], null, sel_coaapid, coaapid_key, coaapid_value, "", "formElemen") %> 
                                                                                            </td> 
                                                                                        </tr>
                                                                                        <tr align="left"> 
                                                                                            <td height="21" >&nbsp;Coa AP Grosir</td>
                                                                                            <td height="21" colspan="2" valign="top"> 
                                                                                                <%
    Vector coaapGrosirid_value = new Vector(1, 1);
    Vector coaapGrosirid_key = new Vector(1, 1);
    String sel_coaapGrosirid = "" + location.getCoaApGrosirId();

    coaapGrosirid_value.add("- ");
    coaapGrosirid_key.add("0");

    if (coas != null && coas.size() > 0) {
        for (int i = 0; i < coas.size(); i++) {
            Coa coa = (Coa) coas.get(i);

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

            coaapGrosirid_key.add("" + coa.getOID());
            coaapGrosirid_value.add(str + coa.getCode() + " - " + coa.getName());
        }
    }


                                                                                                %>
                                                                                                <%= JSPCombo.draw(jspLocation.colNames[JspLocation.JSP_COA_AP_GROSIR_ID], null, sel_coaapGrosirid, coaapGrosirid_key, coaapGrosirid_value, "", "formElemen") %> 
                                                                                            </td> 
                                                                                        </tr>
                                                                                        <tr align="left"> 
                                                                                            <td height="21" >&nbsp;Coa PPN</td>
                                                                                            <td height="21" colspan="2" valign="top"> 
                                                                                                <%
    Vector coappnid_value = new Vector(1, 1);
    Vector coappnid_key = new Vector(1, 1);
    String sel_coappnid = "" + location.getCoaPpnId();
    coappnid_value.add("- ");
    coappnid_key.add("0");

    if (coas != null && coas.size() > 0) {
        for (int i = 0; i < coas.size(); i++) {
            Coa coa = (Coa) coas.get(i);

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

            coappnid_key.add("" + coa.getOID());
            coappnid_value.add(str + coa.getCode() + " - " + coa.getName());
        }
    }

                                                                                                %>
                                                                                                <%= JSPCombo.draw(jspLocation.colNames[JspLocation.JSP_COA_PPN_ID], null, sel_coappnid, coappnid_key, coappnid_value, "", "formElemen") %>  
                                                                                            </td> 
                                                                                        </tr>
                                                                                        <tr align="left"> 
                                                                                            <td height="21" >&nbsp;Coa PPH</td>
                                                                                            <td height="21" colspan="2" valign="top"> 
                                                                                                <% Vector coapphid_value = new Vector(1, 1);
    Vector coapphid_key = new Vector(1, 1);
    String sel_coapphid = "" + location.getCoaPphId();
    coapphid_value.add("- ");
    coapphid_key.add("0");

    if (coas != null && coas.size() > 0) {
        for (int i = 0; i < coas.size(); i++) {
            Coa coa = (Coa) coas.get(i);

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

            coapphid_key.add("" + coa.getOID());
            coapphid_value.add(str + coa.getCode() + " - " + coa.getName());
        }
    }

                                                                                                %>
                                                                                                <%= JSPCombo.draw(jspLocation.colNames[JspLocation.JSP_COA_PPH_ID], null, sel_coapphid, coapphid_key, coapphid_value, "", "formElemen") %> 
                                                                                            </td> 
                                                                                        </tr>
                                                                                        <tr align="left"> 
                                                                                            <td height="21" >&nbsp;Coa Discount</td>
                                                                                            <td height="21" colspan="2" valign="top"> 
                                                                                                <%
    Vector coadiscountid_value = new Vector(1, 1);
    Vector coadiscountid_key = new Vector(1, 1);
    String sel_coadiscountid = "" + location.getCoaDiscountId();

    coadiscountid_value.add("- ");
    coadiscountid_key.add("0");

    if (coas != null && coas.size() > 0) {
        for (int i = 0; i < coas.size(); i++) {
            Coa coa = (Coa) coas.get(i);

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

            coadiscountid_key.add("" + coa.getOID());
            coadiscountid_value.add(str + coa.getCode() + " - " + coa.getName());
        }
    }


                                                                                                %>
                                                                                                <%= JSPCombo.draw(jspLocation.colNames[JspLocation.JSP_COA_DISCOUNT_ID], null, sel_coadiscountid, coadiscountid_key, coadiscountid_value, "", "formElemen") %> 
                                                                                            </td> 
                                                                                        </tr>
                                                                                        <tr align="left"> 
                                                                                            <td height="21" >&nbsp;Coa Sales</td>
                                                                                            <td height="21" colspan="2" valign="top"> 
                                                                                                <%
    Vector coasalesid_value = new Vector(1, 1);
    Vector coasalesid_key = new Vector(1, 1);
    String sel_coasalesid = "" + location.getCoaSalesId();

    coasalesid_value.add("- ");
    coasalesid_key.add("0");

    if (coas != null && coas.size() > 0) {
        for (int i = 0; i < coas.size(); i++) {
            Coa coa = (Coa) coas.get(i);

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

            coasalesid_key.add("" + coa.getOID());
            coasalesid_value.add(str + coa.getCode() + " - " + coa.getName());
        }
    }
                                                                                                %>
                                                                                                <%= JSPCombo.draw(jspLocation.colNames[JspLocation.JSP_COA_SALES_ID], null, sel_coasalesid, coasalesid_key, coasalesid_value, "", "formElemen") %> 
                                                                                            </td> 
                                                                                        </tr>
                                                                                        <tr align="left"> 
                                                                                            <td height="21" >&nbsp;Coa PPH 23</td>
                                                                                            <td height="21" colspan="2" valign="top"> 
                                                                                                <%
    Vector coapph23id_value = new Vector(1, 1);
    Vector coapph23id_key = new Vector(1, 1);
    String sel_coapph23id = "" + location.getCoaProjectPPHPasal23Id();

    coapph23id_value.add("- ");
    coapph23id_key.add("0");

    if (coas != null && coas.size() > 0) {
        for (int i = 0; i < coas.size(); i++) {
            Coa coa = (Coa) coas.get(i);

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

            coapph23id_key.add("" + coa.getOID());
            coapph23id_value.add(str + coa.getCode() + " - " + coa.getName());
        }
    }
                                                                                                %>
                                                                                                <%= JSPCombo.draw(jspLocation.colNames[JspLocation.JSP_COA_PROJECT_PPH_PASAL_23_ID], null, sel_coapph23id, coapph23id_key, coapph23id_value, "", "formElemen") %> 
                                                                                            </td> 
                                                                                        </tr>
                                                                                        <tr align="left"> 
                                                                                            <td height="21" >&nbsp;Coa PPH 22</td>
                                                                                            <td height="21" colspan="2" valign="top"> 
                                                                                                <%
    Vector coapph22id_value = new Vector(1, 1);
    Vector coapph22id_key = new Vector(1, 1);
    String sel_coapph22id = "" + location.getCoaProjectPPHPasal22Id();

    coapph22id_value.add("- ");
    coapph22id_key.add("0");

    if (coas != null && coas.size() > 0) {
        for (int i = 0; i < coas.size(); i++) {
            Coa coa = (Coa) coas.get(i);

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

            coapph22id_key.add("" + coa.getOID());
            coapph22id_value.add(str + coa.getCode() + " - " + coa.getName());
        }
    }
                                                                                                %>
                                                                                                <%= JSPCombo.draw(jspLocation.colNames[JspLocation.JSP_COA_PROJECT_PPH_PASAL_22_ID], null, sel_coapph22id, coapph22id_key, coapph22id_value, "", "formElemen") %> 
                                                                                            </td> 
                                                                                        </tr>
                                                                                        <tr align="left"> 
                                                                                            <td height="21" valign="middle" >&nbsp;Start Date</td>
                                                                                            <td>
                                                                                                <table border="0" cellpadding="0" cellspacing="0">
                                                                                                    <tr>
                                                                                                        <td><input name="<%=jspLocation.colNames[JspLocation.JSP_DATE_START]%>" value="<%=JSPFormater.formatDate((location.getDateStart() == null) ? new Date() : location.getDateStart(), "dd/MM/yyyy")%>" size="11" style="text-align:center" readOnly></td>
                                                                                                        <td><a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmlocation.<%=jspLocation.colNames[JspLocation.JSP_DATE_START]%>);return false;"><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt="visit date" ></a></td>
                                                                                                    </tr>
                                                                                                </table>  
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr align="left"> 
                                                                                            <td height="21" valign="middle" >&nbsp;Type Grosir</td>
                                                                                            <td>
                                                                                                <select name="<%=jspLocation.colNames[JspLocation.JSP_TYPE_GROSIR]%>">
                                                                                                    <option value="<%=DbLocation.strValueTypes[DbLocation.TYPE_RETAIL]%>" <%if (location.getTypeGrosir() == 0) {%> selected<%}%> ><%=DbLocation.strKeyTypes[DbLocation.TYPE_RETAIL]%></option>
                                                                                                    <option value="<%=DbLocation.strValueTypes[DbLocation.TYPE_GROSIR]%>" <%if (location.getTypeGrosir() == 1) {%> selected<%}%>><%=DbLocation.strKeyTypes[DbLocation.TYPE_GROSIR]%></option>
                                                                                                </select>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr align="left"> 
                                                                                            <td height="21" valign="middle" >&nbsp;Type 24 Hour</td>
                                                                                            <td>
                                                                                                <select name="<%=jspLocation.colNames[JspLocation.JSP_TYPE_24HOUR]%>">
                                                                                                    <option value="<%=DbLocation.strValue24Hour[DbLocation.TYPE_24HOUR_YES]%>" <%if (location.getType24Hour() == 0) {%> selected<%}%> ><%=DbLocation.strKey24Hour[DbLocation.TYPE_24HOUR_YES]%></option>
                                                                                                    <option value="<%=DbLocation.strValue24Hour[DbLocation.TYPE_24HOUR_NO]%>"  <%if (location.getType24Hour() == 1) {%> selected<%}%>><%=DbLocation.strKey24Hour[DbLocation.TYPE_24HOUR_NO]%></option>
                                                                                                </select>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr align="left"> 
                                                                                            <td height="21" >&nbsp;Amount Target</td>
                                                                                            <td height="21" colspan="2" valign="top">                                                                                                
                                                                                                <input type="text" name="<%=jspLocation.colNames[JspLocation.JSP_AMOUNT_TARGET] %>"  value="<%=JSPFormater.formatNumber(location.getAmountTarget(), "###.##") %>" class="formElemen" size="65">
                                                                                                * <%= jspLocation.getErrorMsg(JspLocation.JSP_AMOUNT_TARGET) %>
                                                                                            </td> 
                                                                                        </tr>
                                                                                        
                                                                                        <tr align="left"> 
                                                                                            <td height="21" valign="middle" >&nbsp;Active Auto Replenishment</td>
                                                                                            <td><input type="checkbox" name="<%=jspLocation.colNames[jspLocation.JSP_AKTIF_AUTO_ORDER] %>"  value="1" <%if (location.getAktifAutoOrder() == 1) {%>checked<%}%> class="formElemen"></td>
                                                                                        </tr>
                                                                                        
                                                                                        <tr align="left"> 
                                                                                            <td height="21" >&nbsp;NPWP</td>
                                                                                            <td height="21" colspan="2" valign="top">                                                                                                
                                                                                                <input type="text" name="<%=jspLocation.colNames[JspLocation.JSP_NPWP] %>"  value="<%= location.getNpwp() %>" class="formElemen" size="65">
                                                                                                * <%= jspLocation.getErrorMsg(JspLocation.JSP_NPWP) %>
                                                                                            </td> 
                                                                                        </tr>
                                                                                        <tr align="left"> 
                                                                                            <td height="21" >&nbsp;Prefix Faktur Pajak Sales</td>
                                                                                            <td height="21" colspan="2" valign="top"> 
                                                                                                <input type="text" name="<%=jspLocation.colNames[JspLocation.JSP_PREFIX_FAKTUR_PAJAK] %>"  value="<%= location.getPrefixFakturPajak() %>" class="formElemen" size="65">
                                                                                                * <%= jspLocation.getErrorMsg(JspLocation.JSP_PREFIX_FAKTUR_PAJAK) %>                                                                                               
                                                                                            </td> 
                                                                                        </tr>
                                                                                        <tr align="left"> 
                                                                                            <td height="21" >&nbsp;Prefix Faktur Pajak Transfer</td>
                                                                                            <td height="21" colspan="2" valign="top"> 
                                                                                                <input type="text" name="<%=jspLocation.colNames[JspLocation.JSP_PREFIX_FAKTUR_TRANSFER] %>"  value="<%= location.getPrefixFakturTransfer() %>" class="formElemen" size="65">
                                                                                                * <%= jspLocation.getErrorMsg(JspLocation.JSP_PREFIX_FAKTUR_TRANSFER) %>                                                                                               
                                                                                            </td> 
                                                                                        </tr>
                                                                                        <tr align="left"> 
                                                                                            <td height="8" valign="middle" >&nbsp;</td>
                                                                                            <td height="8" colspan="2" valign="top">&nbsp;</td>
                                                                                        </tr>
                                                                                    </table>
                                                                                    <%}%>
                                                                                </td>
                                                                            </tr>
                                                                            <%if ((iJSPCommand == JSPCommand.ADD) || (iJSPCommand == JSPCommand.SAVE && iErrCode != 0) || (iJSPCommand == JSPCommand.EDIT) || (iJSPCommand == JSPCommand.ASK)) {%>
                                                                            <tr align="left" valign="top" > 
                                                                                <td colspan="3" class="command"> 
                                                                                    <%
    jspLine.setLocationImg(approot + "/images/ctr_line");
    jspLine.initDefault();
    jspLine.setTableWidth("80%");
    String scomDel = "javascript:cmdAsk('" + oidLocation + "')";
    String sconDelCom = "javascript:cmdConfirmDelete('" + oidLocation + "')";
    String scancel = "javascript:cmdEdit('" + oidLocation + "')";
    jspLine.setBackCaption("Back to List");
    jspLine.setJSPCommandStyle("buttonlink");

    jspLine.setOnMouseOut("MM_swapImgRestore()");
    jspLine.setOnMouseOverSave("MM_swapImage('save','','" + approot + "/images/save2.gif',1)");
    jspLine.setSaveImage("<img src=\"" + approot + "/images/save.gif\" name=\"save\" height=\"22\" border=\"0\">");

    //jspLine.setOnMouseOut("MM_swapImgRestore()");
    jspLine.setOnMouseOverBack("MM_swapImage('back','','" + approot + "/images/cancel2.gif',1)");
    jspLine.setBackImage("<img src=\"" + approot + "/images/cancel.gif\" name=\"back\" height=\"22\" border=\"0\">");

    jspLine.setOnMouseOverDelete("MM_swapImage('delete','','" + approot + "/images/delete2.gif',1)");
    jspLine.setDeleteImage("<img src=\"" + approot + "/images/delete.gif\" name=\"delete\" height=\"22\" border=\"0\">");

    jspLine.setOnMouseOverEdit("MM_swapImage('edit','','" + approot + "/images/cancel2.gif',1)");
    jspLine.setEditImage("<img src=\"" + approot + "/images/cancel.gif\" name=\"edit\" height=\"22\" border=\"0\">");


    jspLine.setWidthAllJSPCommand("90");
    jspLine.setErrorStyle("warning");
    jspLine.setErrorImage(approot + "/images/error.gif\" width=\"20\" height=\"20");
    jspLine.setQuestionStyle("warning");
    jspLine.setQuestionImage(approot + "/images/error.gif\" width=\"20\" height=\"20");
    jspLine.setInfoStyle("success");
    jspLine.setSuccessImage(approot + "/images/success.gif\" width=\"20\" height=\"20");

    if (privDelete) {
        jspLine.setConfirmDelJSPCommand(sconDelCom);
        jspLine.setDeleteJSPCommand(scomDel);
        jspLine.setEditJSPCommand(scancel);
    } else {
        jspLine.setConfirmDelCaption("");
        jspLine.setDeleteCaption("");
        jspLine.setEditCaption("");
    }

    if (privAdd == false && privUpdate == false) {
        jspLine.setSaveCaption("");
    }

    if (privAdd == false) {
        jspLine.setAddCaption("");
    }
                                                                                    %>
                                                                                <%= jspLine.drawImageOnly(iJSPCommand, iErrCode, msgString)%> </td>
                                                                            </tr>
                                                                            <%}%>
                                                                            <tr height="30">
                                                                                <td colspan="3">
                                                                                </td>    
                                                                            </tr>    
                                                                            <tr>
                                                                                <td colspan="3">
                                                                                    <table width="800" >
                                                                                        <tr>
                                                                                            <td width="120" bgcolor="#F3F3F3" class="fontarial" align="center"><b><i>Date</i><b></td>
                                                                                            <td width="470" bgcolor="#F3F3F3" class="fontarial" align="center"><b><i>Description</i><b></td>
                                                                                            <td bgcolor="#F3F3F3" class="fontarial" align="center"><b><i>By</i><b></td>
                                                                                        </tr>   
                                                                                        <%
            int max = 10;
            if (showAll == 1) {
                max = 0;
            }
            int countx = DbHistoryUser.getCount(DbHistoryUser.colNames[DbHistoryUser.COL_TYPE] + " = " + DbHistoryUser.TYPE_LOCATION);
            Vector historys = DbHistoryUser.list(0, max, DbHistoryUser.colNames[DbHistoryUser.COL_TYPE] + " = " + DbHistoryUser.TYPE_LOCATION, DbHistoryUser.colNames[DbHistoryUser.COL_DATE] + " desc");
            if (historys != null && historys.size() > 0) {

                for (int r = 0; r < historys.size(); r++) {
                    HistoryUser hu = (HistoryUser) historys.get(r);

                    Employee e = new Employee();
                    try {
                        e = DbEmployee.fetchExc(hu.getEmployeeId());
                    } catch (Exception ex) {
                    }
                    String name = "-";
                    if (e.getName() != null && e.getName().length() > 0) {
                        name = e.getName();
                    }
                                                                                        %>
                                                                                        <tr>
                                                                                            <td colspan="3" height="1" bgcolor="#CCCCCC"></td>
                                                                                        </tr>
                                                                                        <tr>
                                                                                            <td class="fontarial" style=padding:3px;><%=JSPFormater.formatDate(hu.getDate(), "dd MMM yyyy HH:mm:ss ")%></td>
                                                                                            <td class="fontarial" style=padding:3px;><i><%=hu.getDescription()%></i></td>
                                                                                            <td class="fontarial" style=padding:3px;><%=name%></td>
                                                                                        </tr>
                                                                                        <%
                                                                                            }

                                                                                        } else {
                                                                                        %>
                                                                                        <tr>
                                                                                            <td colspan="3" class="fontarial" style=padding:3px;><i>No history available</i></td>
                                                                                        </tr>
                                                                                        <%}%>
                                                                                        <tr>
                                                                                            <td colspan="3" height="1" bgcolor="#CCCCCC"></td>
                                                                                        </tr>
                                                                                        <%
            if (countx > max) {
                if (showAll == 0) {
                                                                                        %>
                                                                                        <tr>
                                                                                            <td colspan="3" height="1" class="fontarial"><a href="javascript:cmdShowAll()"><i>Show All History (<%=countx%>) Data</i></a></td>
                                                                                        </tr>
                                                                                        <%
                                                                                            } else {
                                                                                        %>
                                                                                        <tr>
                                                                                            <td colspan="3" height="1" class="fontarial"><a href="javascript:cmdUnShowAll()"><i>Show By Limit</i></a></td>
                                                                                        </tr>
                                                                                        <%
                }
            }%>
                                                                                                                                                                                                                                                      
                                                                                    </table>
                                                                                    
                                                                                </td>
                                                                            </tr>    
                                                                        </table>
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </form>
                                                        
                                                        <span class="level2"><br>
                                                        </span><!-- #EndEditable -->
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
            <%@ include file = "../main/footer.jsp" %>
                                <!-- #EndEditable -->
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </body>
<!-- #EndTemplate --></html>
