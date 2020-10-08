
<%@ page language="java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.general.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.admin.*" %>
<%@ include file = "../main/javainit.jsp" %>
<%@ include file = "../main/check.jsp" %>
<%
            boolean priv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MENU_ADMINISTRATOR, AppMenu.M2_MENU_ADMINISTRATOR);
            boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_ADMINISTRATOR, AppMenu.M2_MENU_ADMINISTRATOR, AppMenu.PRIV_VIEW);
            boolean privUpdate = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_ADMINISTRATOR, AppMenu.M2_MENU_ADMINISTRATOR, AppMenu.PRIV_UPDATE);
            boolean privAdd = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_ADMINISTRATOR, AppMenu.M2_MENU_ADMINISTRATOR, AppMenu.PRIV_ADD);
            boolean privDelete = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_ADMINISTRATOR, AppMenu.M2_MENU_ADMINISTRATOR, AppMenu.PRIV_DELETE);
%>
<!-- JSP Block -->
<%!
    public String ctrCheckBox(long groupID) {
        JSPCheckBox chkBx = new JSPCheckBox();
        chkBx.setCellSpace("0");
        chkBx.setCellStyle("");
        chkBx.setWidth(5);
        chkBx.setTableAlign("left");
        chkBx.setCellWidth("10%");

        try {
            Vector checkValues = new Vector(1, 1);
            Vector checkCaptions = new Vector(1, 1);
            Vector allPrivs = DbPriv.list(0, 0, "", "PRIV_NAME");

            if (allPrivs != null) {
                int maxV = allPrivs.size();
                for (int i = 0; i < maxV; i++) {
                    Priv appPriv = (Priv) allPrivs.get(i);
                    checkValues.add(Long.toString(appPriv.getOID()));
                    checkCaptions.add(appPriv.getPrivName());
                }
            }

            Vector checkeds = new Vector(1, 1);

            DbGroupPriv pstGp = new DbGroupPriv(0);
            Vector privs = QrGroup.getGroupPriv(groupID);

            if (privs != null) {
                int maxV = privs.size();
                for (int i = 0; i < maxV; i++) {
                    Priv appPriv = (Priv) privs.get(i);
                    checkeds.add(Long.toString(appPriv.getOID()));
                }
            }

            chkBx.setTableWidth("100%");

            String fldName = JspGroup.colNames[JspGroup.JSP_GROUP_PRIV];
            return chkBx.draw(fldName, checkValues, checkCaptions, checkeds);

        } catch (Exception exc) {
            return "No privilege";
        }
    }
%>
<%
            JSPLine ctrLine = new JSPLine();
            int iJSPCommand = JSPRequestValue.requestCommand(request);
            long appGroupOID = JSPRequestValue.requestLong(request, "group_oid");
            int showAll = JSPRequestValue.requestInt(request, "show_all");
            boolean insertNew = false;
            if (appGroupOID == 0) {
                insertNew = true;
            }
            
            String nameOld = "";
            String descOld = "";
            if (iJSPCommand == JSPCommand.SAVE) {
                Group gx = new Group();
                try{
                    gx = DbGroup.fetch(appGroupOID);
                    nameOld = gx.getGroupName();
                    descOld = gx.getDescription();
                }catch(Exception e){
                    nameOld = "";
                    descOld = "";
                }
            }
            
            if(nameOld == null){
                nameOld = "";
            }
            
            if(descOld == null){
                descOld = "";
            }
            
            int start = JSPRequestValue.requestInt(request, "start");
            CmdGroup ctrlGroup = new CmdGroup(request);
            int iErrCode = ctrlGroup.action(iJSPCommand, appGroupOID);
            String grpxName = JSPRequestValue.requestString(request, "name_grpx");

            JspGroup frmGroup = ctrlGroup.getForm();
            String msgString = ctrlGroup.getMessage();
            Group appGroup = ctrlGroup.getGroup();
            if(appGroupOID==0){
                appGroupOID = appGroup.getOID();
            }
            
            if (iErrCode == 0) {
                msgString = "";
            }
            
            
            if (iJSPCommand == JSPCommand.DELETE && iErrCode <= 0) {
                HistoryUser hisUser = new HistoryUser();
                hisUser.setUserId(user.getOID());
                hisUser.setEmployeeId(user.getEmployeeId());
                hisUser.setRefId(appGroupOID);
                hisUser.setDescription("Delete group "+grpxName);
                hisUser.setType(DbHistoryUser.TYPE_USER_GROUP);
                hisUser.setDate(new Date());
                try {
                    DbHistoryUser.insertExc(hisUser);
                } catch (Exception e) {
                }
            }

            if (iJSPCommand == JSPCommand.SAVE) {

                String descFinance = "";
                String descInventory = "";
                String descSales = "";

                for (int i = 0; i < AppMenu.strMenu1.length; i++) {

                    for (int x = 0; x < AppMenu.strMenu2[i].length; x++) {

                        Vector vx = DbUserPriv.list(0, 0, DbUserPriv.colNames[DbUserPriv.COL_GROUP_ID] + "=" + appGroup.getOID() + " and " + DbUserPriv.colNames[DbUserPriv.COL_MN_1] + "=" + i + " and " + DbUserPriv.colNames[DbUserPriv.COL_MN_2] + "=" + x, "");
                        UserPriv uv = new UserPriv();
                        if (vx != null && vx.size() > 0) {
                            uv = (UserPriv) vx.get(0);
                        }

                        int mn = JSPRequestValue.requestInt(request, "menu2_" + i + "" + x);
                        int view = JSPRequestValue.requestInt(request, "menu2_view" + i + "" + x);
                        int edit = JSPRequestValue.requestInt(request, "menu2_update" + i + "" + x);
                        int add = JSPRequestValue.requestInt(request, "menu2_add" + i + "" + x);
                        int del = JSPRequestValue.requestInt(request, "menu2_delete" + i + "" + x);
                        int print = JSPRequestValue.requestInt(request, "menu2_print" + i + "" + x);

                        if ((uv.getOID() != 0 && mn == 0) ||
                                uv.getCmdView() != view ||
                                uv.getCmdEdit() != edit ||
                                uv.getCmdAdd() != add ||
                                uv.getCmdDelete() != del ||
                                uv.getCmdPrint() != print) {

                            if (descFinance != null && descFinance.length() > 0) {
                                descFinance = descFinance + ", ";
                                descFinance = descFinance + " Sub " + AppMenu.strMenu1[i];
                            } else {
                                descFinance = descFinance + " Sub " + AppMenu.strMenu1[i];
                            }
                            break;
                        }

                    }
                }

                if (descFinance != null && descFinance.length() > 0) {
                    descFinance = "Update Menu Finance :" + descFinance;
                }

                int totINVCk = 100 + AppMenu.strInv1.length;
                int invCk = 0;
                for (int j = 100; j < totINVCk; j++) {

                    for (int x = 0; x < AppMenu.strInv2[invCk].length; x++) {

                        Vector vx = DbUserPriv.list(0, 0, DbUserPriv.colNames[DbUserPriv.COL_GROUP_ID] + "=" + appGroup.getOID() + " and " + DbUserPriv.colNames[DbUserPriv.COL_MN_1] + "=" + j + " and " + DbUserPriv.colNames[DbUserPriv.COL_MN_2] + "=" + x, "");
                        UserPriv uv = new UserPriv();
                        if (vx != null && vx.size() > 0) {
                            uv = (UserPriv) vx.get(0);
                        }

                        int mn = JSPRequestValue.requestInt(request, "menuINV2_" + j + "" + x);
                        int view = JSPRequestValue.requestInt(request, "menuINV2_view" + j + "" + x);
                        int edit = JSPRequestValue.requestInt(request, "menuINV2_update" + j + "" + x);
                        int add = JSPRequestValue.requestInt(request, "menuINV2_add" + j + "" + x);
                        int del = JSPRequestValue.requestInt(request, "menuINV2_delete" + j + "" + x);
                        int print = JSPRequestValue.requestInt(request, "menuINV2_print" + j + "" + x);

                        if ((uv.getOID() != 0 && mn == 0) ||
                                uv.getCmdView() != view ||
                                uv.getCmdEdit() != edit ||
                                uv.getCmdAdd() != add ||
                                uv.getCmdDelete() != del ||
                                uv.getCmdPrint() != print) {

                            if (descInventory != null && descInventory.length() > 0) {
                                descInventory = descInventory + ", ";
                                descInventory = descInventory + " Sub " + AppMenu.strInv1[invCk];
                            } else {
                                descInventory = descInventory + " Sub " + AppMenu.strInv1[invCk];
                            }
                            break;
                        }
                    }
                    invCk++;
                }

                if (descInventory != null && descInventory.length() > 0) {
                    descInventory = "Update Menu Inventory :" + descInventory;
                }

                int totSales1 = 300 + AppMenu.strSales1.length;
                int sal1 = 0;
                for (int i = 300; i < totSales1; i++) {
                    for (int x = 0; x < AppMenu.strSales2[sal1].length; x++) {

                        Vector vx = DbUserPriv.list(0, 0, DbUserPriv.colNames[DbUserPriv.COL_GROUP_ID] + "=" + appGroup.getOID() + " and " + DbUserPriv.colNames[DbUserPriv.COL_MN_1] + "=" + i + " and " + DbUserPriv.colNames[DbUserPriv.COL_MN_2] + "=" + x, "");
                        UserPriv uv = new UserPriv();
                        if (vx != null && vx.size() > 0) {
                            uv = (UserPriv) vx.get(0);
                        }


                        int mn = JSPRequestValue.requestInt(request, "menuSALES2_" + i + "" + x);
                        int view = JSPRequestValue.requestInt(request, "menuSALES2_view" + i + "" + x);
                        int edit = JSPRequestValue.requestInt(request, "menuSALES2_update" + i + "" + x);
                        int add = JSPRequestValue.requestInt(request, "menuSALES2_add" + i + "" + x);
                        int del = JSPRequestValue.requestInt(request, "menuSALES2_delete" + i + "" + x);
                        int print = JSPRequestValue.requestInt(request, "menuSALES2_print" + i + "" + x);

                        if ((uv.getOID() != 0 && mn == 0) ||
                                uv.getCmdView() != view ||
                                uv.getCmdEdit() != edit ||
                                uv.getCmdAdd() != add ||
                                uv.getCmdDelete() != del ||
                                uv.getCmdPrint() != print) {

                            if (descSales != null && descSales.length() > 0) {
                                descSales = descSales + ", ";
                                descSales = descSales + " Sub " + AppMenu.strSales1[sal1];
                            } else {
                                descSales = descSales + " Sub " + AppMenu.strSales1[sal1];
                            }
                            break;

                        }
                    }
                    sal1++;
                }

                if (descSales != null && descSales.length() > 0) {
                    descSales = "Update Menu Sales :" + descSales;
                }

                String description = "";
                
                if(appGroup.getGroupName().compareToIgnoreCase(nameOld) != 0 ){
                    description = description +"update nama "+nameOld+" menjadi "+appGroup.getGroupName();
                }
                
                if(appGroup.getDescription().compareToIgnoreCase(descOld) != 0){
                    if (description != null && description.length() > 0) {
                        description = description + ". ";
                    }
                    description = description +"update desc "+descOld+" menjadi "+appGroup.getDescription();
                }

                if (descFinance != null && descFinance.length() > 0) {
                    if (description != null && description.length() > 0) {
                        description = description + ". ";
                    }
                    description = description + descFinance;
                }

                if (descInventory != null && descInventory.length() > 0) {
                    if (description != null && description.length() > 0) {
                        description = description + ". ";
                    }
                    description = description + descInventory;
                }

                if (descSales != null && descSales.length() > 0) {
                    if (description != null && description.length() > 0) {
                        description = description + ". ";
                    }
                    description = description + descSales;
                }

                if (insertNew) {
                    description = "Created";
                }

                DbUserPriv.deleteByGroup(appGroup.getOID());

                for (int i = 0; i < AppMenu.strMenu1.length; i++) {

                    for (int x = 0; x < AppMenu.strMenu2[i].length; x++) {

                        if (JSPRequestValue.requestInt(request, "menu2_" + i + "" + x) == 1) {

                            UserPriv up = new UserPriv();
                            up.setMn1(i);
                            up.setMn2(x);
                            up.setGroupId(appGroup.getOID());
                            up.setCmdView(JSPRequestValue.requestInt(request, "menu2_view" + i + "" + x));
                            up.setCmdEdit(JSPRequestValue.requestInt(request, "menu2_update" + i + "" + x));
                            up.setCmdAdd(JSPRequestValue.requestInt(request, "menu2_add" + i + "" + x));
                            up.setCmdDelete(JSPRequestValue.requestInt(request, "menu2_delete" + i + "" + x));
                            up.setCmdPrint(JSPRequestValue.requestInt(request, "menu2_print" + i + "" + x));

                            try {
                                DbUserPriv.insertExc(up);
                            } catch (Exception e) {
                                System.out.println("[exception] " + e.toString());
                            }
                        }
                    }
                }

                int totINV1 = 100 + AppMenu.strInv1.length;
                int inv = 0;
                for (int i = 100; i < totINV1; i++) {

                    for (int x = 0; x < AppMenu.strInv2[inv].length; x++) {

                        if (JSPRequestValue.requestInt(request, "menuINV2_" + i + "" + x) == 1) {
                            UserPriv up = new UserPriv();
                            up.setMn1(i);
                            up.setMn2(x);
                            up.setGroupId(appGroup.getOID());
                            up.setCmdView(JSPRequestValue.requestInt(request, "menuINV2_view" + i + "" + x));
                            up.setCmdEdit(JSPRequestValue.requestInt(request, "menuINV2_update" + i + "" + x));
                            up.setCmdAdd(JSPRequestValue.requestInt(request, "menuINV2_add" + i + "" + x));
                            up.setCmdDelete(JSPRequestValue.requestInt(request, "menuINV2_delete" + i + "" + x));
                            up.setCmdPrint(JSPRequestValue.requestInt(request, "menuINV2_print" + i + "" + x));

                            try {
                                DbUserPriv.insertExc(up);
                            } catch (Exception e) {
                                System.out.println("[exception] " + e.toString());
                            }
                        }
                    }
                    inv++;
                }


                int totSALES1 = 300 + AppMenu.strSales1.length;
                int sal = 0;
                for (int i = 300; i < totSALES1; i++) {
                    for (int x = 0; x < AppMenu.strSales2[sal].length; x++) {
                        if (JSPRequestValue.requestInt(request, "menuSALES2_" + i + "" + x) == 1) {
                            UserPriv up = new UserPriv();
                            up.setMn1(i);
                            up.setMn2(x);
                            up.setGroupId(appGroup.getOID());
                            up.setCmdView(JSPRequestValue.requestInt(request, "menuSALES2_view" + i + "" + x));
                            up.setCmdEdit(JSPRequestValue.requestInt(request, "menuSALES2_update" + i + "" + x));
                            up.setCmdAdd(JSPRequestValue.requestInt(request, "menuSALES2_add" + i + "" + x));
                            up.setCmdDelete(JSPRequestValue.requestInt(request, "menuSALES2_delete" + i + "" + x));
                            up.setCmdPrint(JSPRequestValue.requestInt(request, "menuSALES2_print" + i + "" + x));

                            try {
                                DbUserPriv.insertExc(up);
                            } catch (Exception e) {
                                System.out.println("[exception] " + e.toString());
                            }
                        }
                    }
                    sal++;
                }

                if (description != null && description.length() > 0) {
                    HistoryUser hisUser = new HistoryUser();
                    hisUser.setUserId(user.getOID());
                    hisUser.setEmployeeId(user.getEmployeeId());
                    hisUser.setRefId(appGroup.getOID());
                    hisUser.setDescription(description);
                    hisUser.setType(DbHistoryUser.TYPE_USER_GROUP);
                    hisUser.setDate(new Date());
                    try {
                        DbHistoryUser.insertExc(hisUser);
                    } catch (Exception e) {
                    }
                }
            }
            /*** LANG ***/
            String[] langMD = {"Group Name", "Description", "Privilege Assigned", "Creation/Update Date"};
            if (lang == LANG_ID) {
                String[] langID = {"Nama Kelompok", "Keterangan", "Hak Akses", "Dibuat/Diupdate"};
                langMD = langID;
            }
%>
<!-- End of JSP Block -->
<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
    <head>
        <!-- #BeginEditable "javascript" --> 
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <title><%=systemTitle%></title>
        <link href="../css/css.css" rel="stylesheet" type="text/css" />
        <script language="JavaScript">
            
            <%if (!priv || !privView) {%>
            window.location="<%=approot%>/nopriv.jsp";
            <%}%>
            
            <%if (!privView && !privAdd && !privUpdate && !privDelete) {%>
            window.location="<%=approot%>/nopriv.jsp";
            <%}%>
            
            <%if (frmGroup.errorSize() > 0) {%>
            window.location="#go";
            <%}%>
            
            function cmdCancel(){
                document.frmGroup.command.value="<%=JSPCommand.EDIT%>";
                document.frmGroup.action="groupedit.jsp";
                document.frmGroup.submit();
            }
            
            function cmdUnShowAll(){
                document.frmGroup.command.value="<%=JSPCommand.EDIT%>";
                document.frmGroup.show_all.value=0;
                document.frmGroup.action="groupedit.jsp";
                document.frmGroup.submit();
            }
            
            function cmdShowAll(){
                document.frmGroup.command.value="<%=JSPCommand.EDIT%>";
                document.frmGroup.show_all.value=1;
                document.frmGroup.action="groupedit.jsp";
                document.frmGroup.submit();
            }
            
            <% if (privAdd || privUpdate) {%>
            function cmdSave(){
                document.frmGroup.command.value="<%=JSPCommand.SAVE%>";
                document.frmGroup.action="groupedit.jsp";
                document.frmGroup.submit();
            }
            <%}%>
            
            <% if (privDelete) {%>
            function cmdAsk(oid){
                document.frmGroup.group_oid.value=oid;
                document.frmGroup.command.value="<%=JSPCommand.ASK%>";
                document.frmGroup.action="groupedit.jsp";
                document.frmGroup.submit();
            }
            function cmdDelete(oid){
                document.frmGroup.group_oid.value=oid;
                document.frmGroup.command.value="<%=JSPCommand.DELETE%>";
                document.frmGroup.action="groupedit.jsp";
                document.frmGroup.submit();
            }
            <%}%>
            function cmdBack(oid){
                document.frmGroup.group_oid.value=oid;
                document.frmGroup.command.value="<%=JSPCommand.LIST%>";
                document.frmGroup.action="grouplist.jsp";
                document.frmGroup.submit();
            }
            
            <%

            for (int i = 0;
                    i < AppMenu.strMenu1.length;
                    i++) {
                out.println("function setCheckedAllFin" + i + "(val) {");
                for (int x = 0; x < AppMenu.strMenu2[i].length; x++) {
                    out.println("document.frmGroup.menu2_" + (i + "" + x) + ".checked = val.checked;");
                    out.println("document.frmGroup.menu2_view" + (i + "" + x) + ".checked = val.checked;");
                    out.println("document.frmGroup.menu2_add" + (i + "" + x) + ".checked = val.checked;");
                    out.println("document.frmGroup.menu2_update" + (i + "" + x) + ".checked = val.checked;");
                    out.println("document.frmGroup.menu2_delete" + (i + "" + x) + ".checked = val.checked;");
                    out.println("document.frmGroup.menu2_print" + (i + "" + x) + ".checked = val.checked;");
                }
                out.println("}");
            }
            int totInventory = 100 + AppMenu.strInv1.length;
            int idxInventory = 0;
            for (int j = 100;
                    j < totInventory;
                    j++) {
                out.println("function setCheckedAllInv" + j + "(val) {");
                for (int x = 0; x < AppMenu.strInv2[idxInventory].length; x++) {
                    out.println("document.frmGroup.menuINV2_" + (j + "" + x) + ".checked = val.checked;");
                    out.println("document.frmGroup.menuINV2_view" + (j + "" + x) + ".checked = val.checked;");
                    out.println("document.frmGroup.menuINV2_add" + (j + "" + x) + ".checked = val.checked;");
                    out.println("document.frmGroup.menuINV2_update" + (j + "" + x) + ".checked = val.checked;");
                    out.println("document.frmGroup.menuINV2_delete" + (j + "" + x) + ".checked = val.checked;");
                    out.println("document.frmGroup.menuINV2_print" + (j + "" + x) + ".checked = val.checked;");
                }
                out.println("}");
                idxInventory++;
            }
            int totSales = 300 + AppMenu.strSales1.length;
            int idxSale = 0;
            for (int j = 300;
                    j < totSales;
                    j++) {
                out.println("function setCheckedAllSales" + j + "(val) {");
                for (int x = 0; x < AppMenu.strSales2[idxSale].length; x++) {
                    out.println("document.frmGroup.menuSALES2_" + (j + "" + x) + ".checked = val.checked;");
                    out.println("document.frmGroup.menuSALES2_view" + (j + "" + x) + ".checked = val.checked;");
                    out.println("document.frmGroup.menuSALES2_add" + (j + "" + x) + ".checked = val.checked;");
                    out.println("document.frmGroup.menuSALES2_update" + (j + "" + x) + ".checked = val.checked;");
                    out.println("document.frmGroup.menuSALES2_delete" + (j + "" + x) + ".checked = val.checked;");
                    out.println("document.frmGroup.menuSALES2_print" + (j + "" + x) + ".checked = val.checked;");
                }
                out.println("}");
                idxSale++;
            }

            %>

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
                                           <%    String navigator = "<font class=\"lvl1\">Administrator</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">Group Edit</span></font>";
                                           %>
                                           <%@ include file="../main/navigator.jsp"%>
                                                    <!-- #EndEditable --></td>
                                                </tr>
                                                <!--tr> 
                                                    <td><img src="<%=approot%>/images/title-sp.gif" width="584" height="1"></td> 
                                                </tr-->
                                                <tr> 
                                                    <td><!-- #BeginEditable "content" --> 
                                                        <form name="frmGroup" method="post" action="">
                                                            <input type="hidden" name="command" value="">
                                                            <input type="hidden" name="group_oid" value="<%=appGroupOID%>">
                                                            <input type="hidden" name="start" value="<%=start%>">
                                                            <input type="hidden" name="show_all" value="0">
                                                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>">                                                            
                                                            <input type="hidden" name="name_grpx" value="<%=appGroup.getGroupName()%>">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr> 
                                                                    <td class="container"> 
                                                                        <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                                                            <%    if (((iJSPCommand == JSPCommand.SAVE)) || (iJSPCommand == JSPCommand.ADD) || (iJSPCommand == JSPCommand.EDIT) || (iJSPCommand == JSPCommand.ASK)) {
                                                                            %>
                                                                            <tr> 
                                                                                <td colspan="2" class="txtheading1"></td>
                                                                            </tr>                                                                           
                                                                            <tr height="23"> 
                                                                                <td width="130" class="tablecell">&nbsp;&nbsp;<%=langMD[0]%></td>
                                                                                <td width="2" class="fontarial">:</td>
                                                                                <td > 
                                                                                    <input type="text" name="<%=frmGroup.colNames[frmGroup.JSP_GROUP_NAME] %>" value="<%=appGroup.getGroupName()%>" class="formElemen" size="30">
                                                                                * &nbsp;<%= frmGroup.getErrorMsg(frmGroup.JSP_GROUP_NAME) %></td>
                                                                            </tr>
                                                                            <tr height="23">  
                                                                                <td class="tablecell">&nbsp;&nbsp;<%=langMD[1]%></td>
                                                                                <td width="2" class="fontarial">:</td>
                                                                                <td > 
                                                                                    <textarea name="<%=frmGroup.colNames[frmGroup.JSP_DESCRIPTION] %>" cols="40" rows="3" class="formElemen"><%=appGroup.getDescription()%></textarea>
                                                                                </td>
                                                                            </tr>
                                                                            <tr height="23"> 
                                                                                <td class="tablecell">&nbsp;&nbsp;<%=langMD[3]%></td>
                                                                                <td width="2" class="fontarial">:</td>
                                                                                <td ><%=JSPDate.drawDate(frmGroup.colNames[JspGroup.JSP_REG_DATE], new Date(), "formElemen", 0, -30)%> </td>
                                                                            </tr>                                                                                                                                                     
                                                                            <tr> 
                                                                                <td valign="top"><table border="0" cellpadding="0" cellspacing="0"><tr height="23"><td class="tablecell" width="130">&nbsp;&nbsp;<%=langMD[2]%></td></tr></table></td>
                                                                                <td colspan="2"> 
                                                                                    <table width="100%" border="0" cellspacing="1" cellpadding="1">                                                                                    
                                                                                        <tr> 
                                                                                            <td colspan="2" class="fontarial"><b><i>Menu Finance :</i></b></td>
                                                                                        </tr> 
                                                                                        <tr> 
                                                                                            <td colspan="2" >
                                                                                                <table width="700" border="0" cellspacing="0" cellpadding="0">
                                                                                                    <tr><td background="../images/line.gif"><img src="../images/line.gif"></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <%
        for (int i = 0; i < AppMenu.strMenu1.length; i++) {%>
                                                                                        <tr> 
                                                                                            <td colspan="2" class="tablecell"><i><input type="checkbox" name="checkboxFin<%=i%>" onClick="javascript:setCheckedAllFin<%=i%>(this)">&nbsp;<%=AppMenu.strMenu1[i]%></i></td>
                                                                                        </tr>
                                                                                        <tr> 
                                                                                            <td width="3%">&nbsp;</td>
                                                                                            <td width="97%"> 
                                                                                                <table width="95%" border="0" cellspacing="0" cellpadding="0">
                                                                                                    <%
                                                                                            for (int x = 0; x < AppMenu.strMenu2[i].length; x++) {

                                                                                                Vector vx = DbUserPriv.list(0, 0, DbUserPriv.colNames[DbUserPriv.COL_GROUP_ID] + "=" + appGroup.getOID() + " and " + DbUserPriv.colNames[DbUserPriv.COL_MN_1] + "=" + i + " and " + DbUserPriv.colNames[DbUserPriv.COL_MN_2] + "=" + x, "");
                                                                                                UserPriv uv = new UserPriv();
                                                                                                if (vx != null && vx.size() > 0) {
                                                                                                    uv = (UserPriv) vx.get(0);
                                                                                                }
                                                                                                    %>
                                                                                                    <tr> 
                                                                                                        <td width="3%"><input type="checkbox" name="menu2_<%=i%><%=x%>" value="1" <%if (uv.getOID() != 0) {%>checked<%}%>></td>
                                                                                                        <td width="22%" class="fontarial"><%=AppMenu.strMenu2[i][x]%></td>
                                                                                                        <td width="75%"> 
                                                                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                                                <tr> 
                                                                                                                    <td width="28"><input type="checkbox" name="menu2_view<%=i%><%=x%>" value="1" <%if (uv.getCmdView() == 1) {%>checked<%}%>></td>
                                                                                                                    <td width="59" class="fontarial">&nbsp;View</td>
                                                                                                                    <td width="25" class="fontarial"><input type="checkbox" name="menu2_update<%=i%><%=x%>" value="1" <%if (uv.getCmdEdit() == 1) {%>checked<%}%>></td>
                                                                                                                    <td width="92" class="fontarial">&nbsp;Update</td>
                                                                                                                    <td width="25"><input type="checkbox" name="menu2_add<%=i%><%=x%>" value="1" <%if (uv.getCmdAdd() == 1) {%>checked<%}%>></td>
                                                                                                                    <td width="100" class="fontarial">&nbsp;Add</td>
                                                                                                                    <td width="29"><input type="checkbox" name="menu2_delete<%=i%><%=x%>" value="1" <%if (uv.getCmdDelete() == 1) {%>checked<%}%>></td>
                                                                                                                    <td width="83" class="fontarial">&nbsp;Delete</td>
                                                                                                                    <td width="26"><input type="checkbox" name="menu2_print<%=i%><%=x%>" value="1" <%if (uv.getCmdPrint() == 1) {%>checked<%}%>></td>
                                                                                                                    <td width="264" class="fontarial">Print</td>
                                                                                                                    <td width="51"></td>
                                                                                                                </tr>
                                                                                                            </table>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <%}%>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr> 
                                                                                            <td width="3%">&nbsp;</td>
                                                                                            <td width="97%">&nbsp;</td>
                                                                                        </tr>
                                                                                        <%}%>
                                                                                        
                                                                                        <%if (sysCompany.getBusinessType() == com.project.I_Project.BUSINESS_TYPE_RETAIL) {%>
                                                                                        <tr> 
                                                                                            <td colspan="2">&nbsp;</td>
                                                                                        </tr>                                                                                    
                                                                                        <tr> 
                                                                                            <td colspan="2" class="fontarial"><b><i>Menu Retail</i></b></td>
                                                                                        </tr>
                                                                                        <tr> 
                                                                                            <td colspan="2" >
                                                                                                <table width="700" border="0" cellspacing="0" cellpadding="0">
                                                                                                    <tr>
                                                                                                        <td background="../images/line.gif"><img src="../images/line.gif"></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <%
    int totINV1 = 100 + AppMenu.strInv1.length;
    int idxInv = 0;
    for (int j = 100; j < totINV1; j++) {%>
                                                                                        <tr> 
                                                                                            <td colspan="2" class="tablecell"><i><input type="checkbox" name="checkboxInv<%=j%>" onClick="javascript:setCheckedAllInv<%=j%>(this)">&nbsp;<%=AppMenu.strInv1[idxInv]%></i></td>
                                                                                        </tr>
                                                                                        <tr> 
                                                                                            <td width="3%">&nbsp;</td>
                                                                                            <td width="97%"> 
                                                                                                <table width="95%" border="0" cellspacing="0" cellpadding="0">
                                                                                                    <%
                                                                                            for (int x = 0; x < AppMenu.strInv2[idxInv].length; x++) {

                                                                                                Vector vx = DbUserPriv.list(0, 0, DbUserPriv.colNames[DbUserPriv.COL_GROUP_ID] + "=" + appGroup.getOID() + " and " + DbUserPriv.colNames[DbUserPriv.COL_MN_1] + "=" + j + " and " + DbUserPriv.colNames[DbUserPriv.COL_MN_2] + "=" + x, "");
                                                                                                UserPriv uv = new UserPriv();
                                                                                                if (vx != null && vx.size() > 0) {
                                                                                                    uv = (UserPriv) vx.get(0);
                                                                                                }
                                                                                                    %>
                                                                                                    <tr> 
                                                                                                        <td width="3%" class="fontarial"><input type="checkbox" name="menuINV2_<%=j%><%=x%>" value="1" <%if (uv.getOID() != 0) {%>checked<%}%>></td>
                                                                                                        <td width="22%" class="fontarial"><%=AppMenu.strInv2[idxInv][x]%></td>
                                                                                                        <td width="75%"> 
                                                                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                                                <tr> 
                                                                                                                    <td width="28"><input type="checkbox" name="menuINV2_view<%=j%><%=x%>" value="1" <%if (uv.getCmdView() == 1) {%>checked<%}%>></td>
                                                                                                                    <td width="59" class="fontarial">&nbsp;View</td>
                                                                                                                    <td width="25"><input type="checkbox" name="menuINV2_update<%=j%><%=x%>" value="1" <%if (uv.getCmdEdit() == 1) {%>checked<%}%>></td>
                                                                                                                    <td width="92" class="fontarial">&nbsp;Update</td>
                                                                                                                    <td width="25"><input type="checkbox" name="menuINV2_add<%=j%><%=x%>" value="1" <%if (uv.getCmdAdd() == 1) {%>checked<%}%>></td>
                                                                                                                    <td width="100" class="fontarial">&nbsp;Add</td>
                                                                                                                    <td width="29"><input type="checkbox" name="menuINV2_delete<%=j%><%=x%>" value="1" <%if (uv.getCmdDelete() == 1) {%>checked<%}%>></td>
                                                                                                                    <td width="83" class="fontarial">&nbsp;Delete</td>
                                                                                                                    <td width="26"><input type="checkbox" name="menuINV2_print<%=j%><%=x%>" value="1" <%if (uv.getCmdPrint() == 1) {%>checked<%}%>></td>
                                                                                                                    <td width="264" class="fontarial">Print</td>
                                                                                                                    <td width="51">&nbsp;</td>
                                                                                                                </tr>
                                                                                                            </table>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <%}%>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr> 
                                                                                            <td width="3%">&nbsp;</td>
                                                                                            <td width="97%">&nbsp;</td>
                                                                                        </tr>
                                                                                        <%idxInv++;%>
                                                                                        <%}%>
                                                                                        <tr> 
                                                                                            <td width="3%">&nbsp;</td>
                                                                                            <td width="97%">&nbsp;</td>
                                                                                        </tr>                                                                                       
                                                                                        <tr> 
                                                                                            <td colspan="2" class="fontarial"><b><i>Menu Sales</i></b></td>
                                                                                        </tr>
                                                                                        <tr> 
                                                                                            <td colspan="2" >
                                                                                                <table width="700" border="0" cellspacing="0" cellpadding="0">
                                                                                                    <tr>
                                                                                                        <td background="../images/line.gif"><img src="../images/line.gif"></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <%
    int totSales1 = 300 + AppMenu.strSales1.length;
    int idxSales = 0;
    for (int j = 300; j < totSales1; j++) {%>
                                                                                        <tr> 
                                                                                            <td colspan="2" class="tablecell"><i><input type="checkbox" name="checkboxSales<%=j%>" onClick="javascript:setCheckedAllSales<%=j%>(this)">&nbsp;<%=AppMenu.strSales1[idxSales]%></i></td>                                                                                        
                                                                                        </tr>
                                                                                        <tr> 
                                                                                            <td width="3%">&nbsp;</td>
                                                                                            <td width="97%"> 
                                                                                                <table width="95%" border="0" cellspacing="0" cellpadding="0">
                                                                                                    <%
                                                                                            for (int x = 0; x < AppMenu.strSales2[idxSales].length; x++) {

                                                                                                Vector vx = DbUserPriv.list(0, 0, DbUserPriv.colNames[DbUserPriv.COL_GROUP_ID] + "=" + appGroup.getOID() + " and " + DbUserPriv.colNames[DbUserPriv.COL_MN_1] + "=" + j + " and " + DbUserPriv.colNames[DbUserPriv.COL_MN_2] + "=" + x, "");
                                                                                                UserPriv uv = new UserPriv();
                                                                                                if (vx != null && vx.size() > 0) {
                                                                                                    uv = (UserPriv) vx.get(0);
                                                                                                }
                                                                                                    %>
                                                                                                    <tr> 
                                                                                                        <td width="3%"><input type="checkbox" name="menuSALES2_<%=j%><%=x%>" value="1" <%if (uv.getOID() != 0) {%>checked<%}%>></td>
                                                                                                        <td width="22%" class="fontarial"><%=AppMenu.strSales2[idxSales][x]%></td>
                                                                                                        <td width="75%"> 
                                                                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                                                <tr> 
                                                                                                                    <td width="28" class="fontarial"> 
                                                                                                                    <input type="checkbox" name="menuSALES2_view<%=j%><%=x%>" value="1" <%if (uv.getCmdView() == 1) {%>checked<%}%>>
                                                                                                                           </td>
                                                                                                                    <td width="59" class="fontarial">&nbsp;View</td>
                                                                                                                    <td width="25" class="fontarial"> 
                                                                                                                    <input type="checkbox" name="menuSALES2_update<%=j%><%=x%>" value="1" <%if (uv.getCmdEdit() == 1) {%>checked<%}%>>
                                                                                                                           </td>
                                                                                                                    <td width="92" class="fontarial">&nbsp;Update</td>
                                                                                                                    <td width="25" class="fontarial"> 
                                                                                                                    <input type="checkbox" name="menuSALES2_add<%=j%><%=x%>" value="1" <%if (uv.getCmdAdd() == 1) {%>checked<%}%>>
                                                                                                                           </td>
                                                                                                                    <td width="100" class="fontarial">&nbsp;Add</td>
                                                                                                                    <td width="29" class="fontarial"> 
                                                                                                                    <input type="checkbox" name="menuSALES2_delete<%=j%><%=x%>" value="1" <%if (uv.getCmdDelete() == 1) {%>checked<%}%>>
                                                                                                                           </td>
                                                                                                                    <td width="83" class="fontarial">&nbsp;Delete</td>
                                                                                                                    <td width="26" class="fontarial"> 
                                                                                                                    <input type="checkbox" name="menuSALES2_print<%=j%><%=x%>" value="1" <%if (uv.getCmdPrint() == 1) {%>checked<%}%>>
                                                                                                                           </td>
                                                                                                                    <td width="264" class="fontarial">Print</td>
                                                                                                                    <td width="51" class="fontarial">&nbsp;</td>
                                                                                                                </tr>
                                                                                                            </table>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <%}%>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr> 
                                                                                            <td width="3%">&nbsp;</td>
                                                                                            <td width="97%">&nbsp;</td>
                                                                                        </tr>
                                                                                        <%idxSales++;%>
                                                                                        <%}%>
                                                                                        <%}%>
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td colspan="3" class="command">&nbsp;</td>
                                                                            </tr>
                                                                            <% if (appGroupOID != 0) {%>
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
     int countx = DbHistoryUser.getCount(DbHistoryUser.colNames[DbHistoryUser.COL_TYPE] + " = " + DbHistoryUser.TYPE_USER_GROUP + " and " + DbHistoryUser.colNames[DbHistoryUser.COL_REF_ID] + " = " + appGroupOID);
     Vector historys = DbHistoryUser.list(0, max, DbHistoryUser.colNames[DbHistoryUser.COL_TYPE] + " = " + DbHistoryUser.TYPE_USER_GROUP + " and " + DbHistoryUser.colNames[DbHistoryUser.COL_REF_ID] + " = " + appGroupOID, DbHistoryUser.colNames[DbHistoryUser.COL_DATE] + " desc");
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
                                                                            <%}%>
                                                                            <tr> 
                                                                                <td colspan="3" class="command">&nbsp;</td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td colspan="3">&nbsp;</td>
                                                                            </tr>
                                                                            <%if (iJSPCommand == JSPCommand.SAVE && iErrCode == 0) {%>
                                                                            <tr> 
                                                                                <td colspan="3" class="command"><font color="#006600"><i>Data has been saved</i></font></td>
                                                                            </tr>
                                                                            <%}%>
                                                                            <tr> 
                                                                                <td colspan="3" class="command"> 
                                                                                    <%
        ctrLine.setLocationImg(approot + "/images/ctr_line");
        ctrLine.initDefault();
        ctrLine.setTableWidth("80%");
        String scomDel = "javascript:cmdAsk('" + appGroupOID + "')";
        String sconDelCom = "javascript:cmdDelete('" + appGroupOID + "')";
        String scancel = "javascript:cmdCancel('" + appGroupOID + "')";
        ctrLine.setBackCaption("Back to Group List");
        ctrLine.setJSPCommandStyle("buttonlink");
        ctrLine.setSaveCaption("Save Group");
        ctrLine.setDeleteCaption("Delete Group");
        ctrLine.setAddCaption("");

        ctrLine.setOnMouseOut("MM_swapImgRestore()");
        ctrLine.setOnMouseOverSave("MM_swapImage('save','','" + approot + "/images/save2.gif',1)");
        ctrLine.setSaveImage("<img src=\"" + approot + "/images/save.gif\" name=\"save\" height=\"22\" border=\"0\">");

        ctrLine.setOnMouseOverBack("MM_swapImage('back','','" + approot + "/images/back2.gif',1)");
        ctrLine.setBackImage("<img src=\"" + approot + "/images/back.gif\" name=\"back\" height=\"22\" border=\"0\">");

        ctrLine.setOnMouseOverDelete("MM_swapImage('delete','','" + approot + "/images/delete2.gif',1)");
        ctrLine.setDeleteImage("<img src=\"" + approot + "/images/delete.gif\" name=\"delete\" height=\"22\" border=\"0\">");

        ctrLine.setOnMouseOverEdit("MM_swapImage('edit','','" + approot + "/images/back2.gif',1)");
        ctrLine.setEditImage("<img src=\"" + approot + "/images/back.gif\" name=\"edit\" height=\"22\" border=\"0\">");


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

        if (iJSPCommand == JSPCommand.SAVE && iErrCode == 0) {
            iJSPCommand = JSPCommand.EDIT;
        }
                                                                                    %>
                                                                                <%= ctrLine.drawImageOnly(iJSPCommand, iErrCode, msgString)%> </td>
                                                                            </tr>
                                                                            <%} else {%>
                                                                            <tr> 
                                                                                <td colspan="2">&nbsp; Processing OK .. back to list. </td>                                                                                
                                                                                <td >&nbsp; <a href="javascript:cmdBack()">click here</a> </td>
                                                                            </tr>
                                                                            <% }
                                                                            %>
                                                                            <tr> 
                                                                                <td colspan="3">&nbsp;</td>                                                                                 
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
