
<%-- 
    Document   : usereditnonpswd
    Created on : Apr 13, 2013, 9:47:38 PM
    Author     : Roy Andika
--%>

<%@ page language="java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.admin.*" %>
<%@ page import = "com.project.general.*" %>
<%@ include file = "../main/javainit.jsp" %>
<%@ page import = "com.project.fms.activity.*" %>
<% int appObjCode = ObjInfo.composeObjCode(ObjInfo.G1_ADMIN, ObjInfo.G2_ADMIN_USER, ObjInfo.OBJ_ADMIN_USER_USER);%>
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
    public String ctrCheckBox(long userID) {
        JSPCheckBox chkBx = new JSPCheckBox();
        chkBx.setCellSpace("0");
        chkBx.setCellStyle("");
        chkBx.setWidth(5);
        chkBx.setTableAlign("left");
        chkBx.setCellWidth("10%");

        try {
            Vector checkValues = new Vector(1, 1);
            Vector checkCaptions = new Vector(1, 1);
            String order = DbGroup.colNames[DbGroup.COL_GROUP_NAME];
            Vector allGroups = DbGroup.list(0, 0, "", order);

            if (allGroups != null) {
                int maxV = allGroups.size();
                for (int i = 0; i < maxV; i++) {
                    Group appGroup = (Group) allGroups.get(i);
                    checkValues.add(Long.toString(appGroup.getOID()));
                    checkCaptions.add(appGroup.getGroupName());
                }
            }

            Vector checkeds = new Vector(1, 1);
            DbUserGroup dbUg = new DbUserGroup(0);
            Vector groups = QrUser.getUserGroup(userID);

            if (groups != null) {
                int maxV = groups.size();
                for (int i = 0; i < maxV; i++) {
                    Group appGroup = (Group) groups.get(i);
                    checkeds.add(Long.toString(appGroup.getOID()));
                }
            }

            chkBx.setTableWidth("100%");

            String fldName = JspUser.colNames[JspUser.JSP_USER_GROUP];
            return chkBx.draw(fldName, checkValues, checkCaptions, checkeds);

        } catch (Exception exc) {
            return "No group assigned";
        }
    }

    public String isChecked(long oid, Vector sus) {
        if (sus != null && sus.size() > 0) {
            for (int i = 0; i < sus.size(); i++) {
                SegmentUser su = (SegmentUser) sus.get(i);
                if (oid == su.getSegmentDetailId()) {
                    return "checked";
                }
            }
        }
        return "";
    }
%>
<%
            JSPLine jspLine = new JSPLine();
            int iJSPCommand = JSPRequestValue.requestCommand(request);
            long appUserOID = JSPRequestValue.requestLong(request, "user_oid");
            int start = JSPRequestValue.requestInt(request, "start");
            int subMenuAdmIdx = JSPRequestValue.requestInt(request, "sub_menu_adm_idx");
            int showAll = JSPRequestValue.requestInt(request, "show_all");
            Vector segLocs = DbSegmentUser.getSegmentDetailLocation();
            User appUser = new User();
            CmdUser cmdUser = new CmdUser(request);
            JspUser jspUser = cmdUser.getForm();

            int excCode = JSPMessage.NONE;
            String msgString = "";

            if (iJSPCommand == JSPCommand.SAVE) {
                jspUser.requestEntityObject(appUser);
            }

            String memo = "";
            User userOld = new User();
            boolean add = false;
            Vector vlist = new Vector();
            if (excCode == JSPMessage.NONE) {

                if (appUserOID != 0) {
                    try {
                        userOld = DbUser.fetch(appUserOID);
                        vlist = DbUserGroup.list(0, 1, DbUserGroup.colNames[DbUserGroup.COL_USER_ID] + "=" + userOld.getOID(), null);
                    } catch (Exception e) {
                    }
                }

                excCode = cmdUser.action(iJSPCommand, appUserOID);
                msgString = cmdUser.getMessage();
                appUser = cmdUser.getUser();

                if (iJSPCommand == JSPCommand.SAVE) {

                    if (appUserOID == 0) {
                        add = true;
                        HistoryUser hisUser = new HistoryUser();
                        hisUser.setUserId(user.getOID());
                        hisUser.setEmployeeId(user.getEmployeeId());
                        hisUser.setRefId(appUser.getOID());
                        hisUser.setDescription("User " + appUser.getFullName() + " : Penambahan user baru");
                        hisUser.setType(DbHistoryUser.TYPE_USER);
                        hisUser.setDate(new Date());
                        try {
                            DbHistoryUser.insertExc(hisUser);
                        } catch (Exception e) {
                        }
                    } else {

                        if (userOld.getLoginId().compareTo(appUser.getLoginId()) != 0) {
                            memo = memo + " login_id : "+appUser.getLoginId();
                        }

                        if (userOld.getUserLevel() != appUser.getUserLevel()) {
                            if (memo.length() > 0) {
                                memo = memo + " ,";
                            }
                            memo = memo + "user level : "+DbUser.levelStr[appUser.getUserLevel()];
                        }

                        if (userOld.getEmployeeId() != appUser.getEmployeeId()) {
                            if (memo.length() > 0) {
                                memo = memo + " ,";
                            }
                            Employee e = new Employee();
                            try{
                                e = DbEmployee.fetchExc(appUser.getEmployeeId());
                            }catch(Exception ex){}
                            memo = memo + "pegawai :"+e.getName();
                        }
                        if (userOld.getUserKey().compareTo(appUser.getUserKey()) != 0) {
                            if (memo.length() > 0) {
                                memo = memo + " ,";
                            }
                            memo = memo + "user key :"+appUser.getUserKey();
                        }

                        if (userOld.getDescription().compareTo(appUser.getDescription()) != 0) {
                            if (memo.length() > 0) {
                                memo = memo + " ,";
                            }
                            memo = memo + "keterangan:"+appUser.getDescription();
                        }
                    }
                }

                if (appUserOID == 0) {
                    appUserOID = appUser.getOID();
                }

                if (jspUser.getErrors().size() < 1) {
                    msgString = JSPMessage.getMessage(JSPMessage.MSG_SAVED);
                }
            }


            Vector sgSelected = new Vector();

            if (iJSPCommand == JSPCommand.SAVE) {
                DbUserGroup.deleteByUser(appUser.getOID());
                long oid = JSPRequestValue.requestLong(request, "group_id");
                UserGroup ugroup = new UserGroup();
                try {
                    ugroup.setUserID(appUser.getOID());
                    ugroup.setGroupID(oid);
                    
                    long groupIdOld = 0;
                    if (vlist != null && vlist.size() > 0) {
                        try {
                            UserGroup ug = (UserGroup) vlist.get(0);
                            if (ug.getGroupID() != 0) {
                                Group g = new Group();
                                g = DbGroup.fetch(ug.getGroupID());
                                groupIdOld = g.getOID();
                                if (groupIdOld != oid) {
                                    if (memo.length() > 0) {
                                        memo = memo + " ,";
                                    }
                                    Group gNew = new Group();
                                    try{
                                        gNew = DbGroup.fetch(oid);
                                    }catch(Exception e){}
                                    
                                    memo = memo + "Hak akses :"+gNew.getGroupName();
                                }                                
                            }
                        } catch (Exception e) {
                        }
                    }
                    DbUserGroup.insert(ugroup);

                    Vector segByUser = DbSegmentUser.list(0, 0, DbSegmentUser.colNames[DbSegmentUser.COL_USER_ID] + " = " + appUser.getOID(), null);
                    //process segment user
                    if (segLocs != null && segLocs.size() > 0) {

                        for (int i = 0; i < segLocs.size(); i++) {
                            SegmentDetail sd = (SegmentDetail) segLocs.get(i);
                            int oidx = JSPRequestValue.requestInt(request, "chk_" + sd.getOID());
                            if (oidx != 0) {
                                sgSelected.add("" + sd.getOID());
                            }
                        }
                        
                        if (segByUser != null) {

                            if (segByUser.size() != sgSelected.size()) {
                                if (memo.length() > 0) {
                                    memo = memo + " ,";
                                }
                                memo = memo+"perubahan hak akses lokasi";
                            } else {

                                for (int x = 0; x < segByUser.size(); x++) {
                                    SegmentUser su = (SegmentUser) segByUser.get(x);
                                    boolean exist = false;
                                    for (int y = 0; y < sgSelected.size(); y++) {                                        
                                        if (su.getSegmentDetailId() == Long.parseLong("" + sgSelected.get(y))) {
                                            exist = true;
                                        }
                                        if (exist) {
                                            break;
                                        }
                                    }
                                    if (exist == false) {
                                       if (memo.length() > 0) {
                                            memo = memo + " ,";
                                        }
                                        memo = memo+"perubahan hak akses lokasi";
                                        break;
                                    }
                                }

                                if (memo.length() <= 0) {
                                    for (int y = 0; y < sgSelected.size(); y++) {
                                        boolean exist = false;
                                        for (int x = 0; x < segByUser.size(); x++) {
                                            SegmentUser su = (SegmentUser) segByUser.get(x);

                                            if (su.getSegmentDetailId() == Long.parseLong("" + sgSelected.get(y))) {
                                                exist = true;
                                            }
                                            if (exist) {
                                                break;
                                            }
                                        }
                                        if (exist == false) {
                                            if (memo.length() > 0) {
                                                memo = memo + " ,";
                                            }
                                            memo = memo+"perubahan hak akses lokasi";
                                            break;
                                        }
                                    }
                                }
                            }
                        } else {
                            if (sgSelected.size() > 0) {
                                if (memo.length() > 0) {
                                    memo = memo + " ,";
                                }
                                memo = memo+"perubahan hak akses lokasi";
                            }
                        }

                        DbSegmentUser.proceedSegment(sgSelected, appUser.getOID());
                        if(add == false && memo.length() > 0){
                            
                            memo = "Perubahan akses employee "+appUser.getFullName()+" : "+memo;
                            HistoryUser hisUser = new HistoryUser();
                            hisUser.setUserId(user.getOID());
                            hisUser.setEmployeeId(user.getEmployeeId());
                            hisUser.setRefId(appUser.getOID());
                            hisUser.setDescription(memo);
                            hisUser.setType(DbHistoryUser.TYPE_USER);
                            hisUser.setDate(new Date());
                            try {
                                DbHistoryUser.insertExc(hisUser);
                            } catch (Exception e) {
                            }
                        }
                    }

                } catch (Exception e) {
                }
            }

            sgSelected = DbSegmentUser.list(0, 0, "user_id=" + appUser.getOID(), "");

            String[] langMD = {"Login-ID", "Password", "Confirm Password", "Full Name", "Employee Number", "Level POS", "Email", "Description", //0-7
                "User Status", "Last Update Date", "Registered Date", "Last Login Date", "Last Login IP", "Group Privilege", "Company", "Employee"}; //8-15
            if (lang == LANG_ID) {
                String[] langID = {"Login-ID", "Password", "Konfirmasi Password", "Nama Lengkap", "NIP", "Level POS", "Email", "Keterangan",
                    "User Status", "Terakhir Diperbaharui", "Tanggal Didaftarkan", "Login Terakhir", "IP Login Terakhir", "Hak Akses", "Perusahan", "Pegawai"
                };
                langMD = langID;
            }

%>
<!-- End of JSP Block -->
<html >
    <!-- #BeginTemplate "/Templates/index.dwt" --> 
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
            
            <%if (!privView && !privAdd && !privUpdate && !privDelete) {%>
            window.location="<%=approot%>/nopriv.jsp";
            <%}%>
            
            <%if (iJSPCommand == JSPCommand.SAVE || iJSPCommand == JSPCommand.ASK || iJSPCommand == JSPCommand.DELETE) {%>
            window.location="#go";
            <%}%>
            
            
            function cmdUnShowAll(){                
                document.jspUser.command.value="<%=JSPCommand.EDIT%>";                
                document.jspUser.show_all.value=0;
                document.jspUser.action="usereditnonpswd.jsp";
                document.jspUser.submit();
            }
            
            function cmdShowAll(){                
                document.jspUser.command.value="<%=JSPCommand.EDIT%>";                
                document.jspUser.show_all.value=1;
                document.jspUser.action="usereditnonpswd.jsp";
                document.jspUser.submit();
            }
            
            function setChecked(sel){
                    <%
            if ((segLocs != null) && (segLocs.size() > 0)) {
                for (int k = 0; k < segLocs.size(); k++) {
                    SegmentDetail sg1 = (SegmentDetail) segLocs.get(k);
                 %>
                     document.jspUser.chk_<%=sg1.getOID()%>.checked=sel.checked;
                     <%
                }
            }
                    %>
                    }
                    
                    function cmdCancel(){                
                        document.jspUser.command.value="<%=JSPCommand.EDIT%>";
                        document.jspUser.action="usereditnonpswd.jsp";
                        document.jspUser.submit();
                    }
                    
                    <%if (privAdd || privUpdate) {%>
                    function cmdSave(){
                        document.jspUser.command.value="<%=JSPCommand.SAVE%>";
                        document.jspUser.action="usereditnonpswd.jsp";
                        document.jspUser.submit();
                    }
                    <%}%>
                    
                    <% if (privDelete) {%>
                    function cmdDelete(oid){
                        document.jspUser.user_oid.value=oid;
                        document.jspUser.command.value="<%=JSPCommand.ASK%>";
                        document.jspUser.action="usereditnonpswd.jsp";
                        document.jspUser.submit();
                    }
                    
                    function cmdConfirmDelete(oid){
                        document.jspUser.user_oid.value=oid;
                        document.jspUser.command.value="<%=JSPCommand.DELETE%>";
                        document.jspUser.action="usereditnonpswd.jsp";
                        document.jspUser.submit();
                    }
                    <%}%>
                    
                    function cmdPassword(oid){
                        document.jspUser.user_oid.value=oid;                
                        document.jspUser.command.value="<%=JSPCommand.EDIT%>";
                        document.jspUser.menu_idx.value="<%=15%>";
                        document.jspUser.sub_menu_adm_idx.value="<%=1%>";
                        document.jspUser.action="userpassword.jsp";
                        document.jspUser.submit();
                    }
                    
                    function cmdPhoto(oid){
                        document.jspUser.user_oid.value=oid;                
                        document.jspUser.command.value="<%=JSPCommand.EDIT%>";
                        document.jspUser.menu_idx.value="<%=15%>";
                        document.jspUser.sub_menu_adm_idx.value="<%=2%>";
                        document.jspUser.action="userphoto.jsp";
                        document.jspUser.submit();
                    }
                    
                    function cmdBack(oid){
                        document.jspUser.user_oid.value=oid;
                        document.jspUser.command.value="<%=JSPCommand.LIST%>";
                        document.jspUser.action="userlist.jsp";
                        document.jspUser.submit();
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
            String navigator = "<font class=\"lvl1\">Administrator</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">User Editor</span></font>";
                                           %>
                                           <%@ include file="../main/navigator.jsp"%>
                                                    <!-- #EndEditable --></td>
                                                </tr>
                                                <!--tr> 
                      <td><img src="<%=approot%>/images/title-sp.gif" width="584" height="1"></td> 
                                                </tr-->
                                                <tr> 
                                                    <td><!-- #BeginEditable "content" --> 
                                                        <form name="jspUser" method="post" action="">
                                                            <input type="hidden" name="command" value="">
                                                            <input type="hidden" name="user_oid" value="<%=appUserOID%>">
                                                            <input type="hidden" name="start" value="<%=start%>">
                                                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                            <input type="hidden" name="show_all" value="0">
                                                            <input type="hidden" name="sub_menu_adm_idx" value="<%=subMenuAdmIdx%>">                                                            
                                                            <input type="hidden" name="<%=jspUser.colNames[jspUser.JSP_PASSWORD] %>" value="<%=appUser.getPassword()%>">                                                            
                                                            <input type="hidden" name="<%=jspUser.colNames[jspUser.JSP_CJSP_PASSWORD] %>" value="<%=appUser.getPassword()%>">                                                            
                                                            <input type="hidden" name="<%=jspUser.colNames[jspUser.JSP_LAST_LOGIN_IP] %>" value="<%=appUser.getLastLoginIp()%>">                                                            
                                                            <table width="900" border="0" cellspacing="0" cellpadding="0">
                                                                <tr> 
                                                                    <td class="container"> 
                                                                        <table width="100%" border="0" cellpadding="1" cellspacing="1">                                                                            
                                                                            <%if (appUser.getOID() != 0) {%>
                                                                            <tr> 
                                                                                <td colspan="3"><%@ include file="tbmenuadmin.jsp"%></td>
                                                                            </tr>
                                                                            <%}%>
                                                                            <tr> 
                                                                                <td colspan="3" height="10"></td>
                                                                            </tr>
                                                                            <tr height="22"> 
                                                                                <td width="15%" class="tablecell1">&nbsp;&nbsp;<%=langMD[0]%></td>
                                                                                <td width="33%" >&nbsp;:&nbsp; 
                                                                                    <input type="text" name="<%=jspUser.colNames[jspUser.JSP_LOGIN_ID] %>" value="<%=appUser.getLoginId()%>" class="formElemen" size="35">
                                                                                * &nbsp;<%= jspUser.getErrorMsg(jspUser.JSP_LOGIN_ID) %></td>
                                                                                <td rowspan="7" height="26" valign="top" width="52%"> 
                                                                                    <%if (appUser.getOID() != 0) {%>
                                                                                    <a href="userphoto.jsp?command=<%=JSPCommand.EDIT%>&menu_idx=15&sub_menu_adm_idx=2&user_oid=<%=appUser.getOID()%>"><img src="../../general/imagesuser/pic_<%=appUser.getOID()%>.jpg" width="115" border="0"></a> 
                                                                                    <%}%>
                                                                                </td>
                                                                            </tr> 
                                                                            <tr height="22"> 
                                                                                <td class="tablecell">&nbsp;&nbsp;<%=langMD[5]%></td>
                                                                                <td >&nbsp;:&nbsp; 
                                                                                    <select name="<%=jspUser.colNames[jspUser.JSP_USER_LEVEL] %>" class="formElemen">
                                                                                        <%for (int i = 0; i < DbUser.levelStr.length; i++) {%>
                                                                                        <option <%if (i == appUser.getUserLevel()) {%>selected<%}%> value="<%=i%>"><%=DbUser.levelStr[i]%></option>
                                                                                        <%}%>
                                                                                    </select>
                                                                                </td>
                                                                            </tr>                                                                            
                                                                            <tr height="22"> 
                                                                                <td valign="top" class="tablecell1">&nbsp;&nbsp;<%=langMD[15]%></td>
                                                                                <td >&nbsp;:&nbsp; 
                                                                                    <%
            Vector listEmployee = DbEmployee.list(0, 0, "", "name");
            Vector empKey = new Vector(1, 1);
            Vector empValue = new Vector(1, 1);
            if (listEmployee != null && listEmployee.size() > 0) {
                for (int i = 0; i < listEmployee.size(); i++) {
                    Employee employee = (Employee) listEmployee.get(i);
                    empKey.add(employee.getName());
                    empValue.add("" + employee.getOID());
                }
            }
                                                                                    %>
                                                                                    <%=JSPCombo.draw(jspUser.colNames[jspUser.JSP_EMPLOYEE_ID], "select...", "" + appUser.getEmployeeId(), empValue, empKey)%> 
                                                                                </td>
                                                                            </tr>
                                                                            <tr height="22"> 
                                                                                <td valign="top" class="tablecell">&nbsp;&nbsp;User Key</td>
                                                                                <td valign="top">&nbsp;:&nbsp; 
                                                                                    <input type="text" name="<%=jspUser.colNames[jspUser.JSP_USER_KEY] %>" value="<%=(appUser.getUserKey() == null) ? "" : appUser.getUserKey()%>" size="35" class="formElemen">
                                                                                &nbsp;<%= jspUser.getErrorMsg(jspUser.JSP_USER_KEY) %></td>                                                                                
                                                                            </tr>
                                                                            <tr height="22"> 
                                                                                <td valign="top" class="tablecell1">&nbsp;&nbsp;<%=langMD[7]%></td>
                                                                                <td valign="top">&nbsp;:&nbsp; 
                                                                                    <textarea name="<%=jspUser.colNames[jspUser.JSP_DESCRIPTION] %>" cols="32" rows="3" class="formElemen"><%=(appUser.getDescription() == null) ? "" : appUser.getDescription()%></textarea>
                                                                                &nbsp;<%= jspUser.getErrorMsg(jspUser.JSP_DESCRIPTION) %></td>
                                                                                
                                                                            </tr>
                                                                            <tr height="22"> 
                                                                                <td class="tablecell">&nbsp;&nbsp;<%=langMD[8]%></td>
                                                                                <td >&nbsp;:&nbsp; 
                                                                                    <%
            JSPCombo cmbox = new JSPCombo();
            Vector sts = User.getStatusTxts();
            Vector stsVals = User.getStatusVals();
                                                                                    %>
                                                                                    <%=cmbox.draw(jspUser.colNames[jspUser.JSP_USER_STATUS], "formElemen",
                        null, Integer.toString(appUser.getUserStatus()), stsVals, sts)%> &nbsp;<%= jspUser.getErrorMsg(jspUser.JSP_USER_STATUS) %></td>
                                                                                <td >&nbsp;</td>
                                                                            </tr>
                                                                            <tr height="22"> 
                                                                                <td class="tablecell1">&nbsp;&nbsp;<%=langMD[9]%></td>
                                                                                <td >&nbsp;:&nbsp;<%=(appUser.getUpdateDate() == null) ? "-" : JSPFormater.formatDate(appUser.getUpdateDate(), "dd MMM yyyy")%> 
                                                                                    <input type="hidden" name="<%=jspUser.colNames[jspUser.JSP_UPDATE_DATE] %>2" value="<%=appUser.getUpdateDate()%>">
                                                                                </td>
                                                                                <td >&nbsp;</td>
                                                                            </tr>
                                                                            <tr height="22"> 
                                                                                <td class="tablecell">&nbsp;&nbsp;<%=langMD[10]%></td>
                                                                                <td >&nbsp;:&nbsp;<%=(appUser.getRegDate() == null) ? "-" : JSPFormater.formatDate(appUser.getRegDate(), "dd MMM yyyy")%></td>
                                                                                <td >&nbsp;</td>
                                                                            </tr>
                                                                            <tr height="22"> 
                                                                                <td class="tablecell1">&nbsp;&nbsp;<%=langMD[11]%></td>
                                                                                <td >&nbsp;:&nbsp; 
                                                                                    <% if (appUser.getLastLoginDate() == null) {
                out.println("-");
            } else {
                out.println(appUser.getLastLoginDate());
            }%>
                                                                                </td>
                                                                                <td >&nbsp;</td>
                                                                            </tr>
                                                                            <tr height="22"> 
                                                                                <td class="tablecell">&nbsp;&nbsp;<%=langMD[12]%></td>
                                                                                <td > &nbsp;:&nbsp;
                                                                                    <% if (appUser.getLastLoginIp() == null) {
                out.println("-");
            } else {
                out.println(appUser.getLastLoginIp());
            }%>
                                                                                </td>
                                                                                <td >&nbsp;</td>
                                                                            </tr>
                                                                            <tr height="22"> 
                                                                                <td nowrap class="tablecell1">&nbsp;&nbsp;<%=langMD[13]%></td>
                                                                                <td height="14">&nbsp;:&nbsp; 
                                                                                    <%
            Vector grp = DbGroup.list(0, 0, "", "");
            Vector vx = DbUserGroup.list(0, 0, DbUserGroup.colNames[DbUserGroup.COL_USER_ID] + "=" + appUser.getOID(), "");
            long oidx = 0;
            if (vx != null && vx.size() > 0) {
                UserGroup ug = (UserGroup) vx.get(0);
                oidx = ug.getGroupID();
            }
                                                                                    %>
                                                                                    <select name="group_id">
                                                                                        <option value="0">- select - </option>
                                                                                        <%if (grp != null && grp.size() > 0) {
                for (int i = 0; i < grp.size(); i++) {
                    Group g = (Group) grp.get(i);
                                                                                        %>
                                                                                        <option value="<%=g.getOID()%>" <%if (g.getOID() == oidx) {%>selected<%}%>><%=g.getGroupName()%></option>
                                                                                        <%}
            }%>
                                                                                    </select>
                                                                                </td>
                                                                                <td >&nbsp;</td>
                                                                            </tr>  
                                                                            <%
            Vector segments = DbSegment.list(0, 0, "", "count");
            if (segments != null && segments.size() > 0) {
                for (int i = 0; i < segments.size(); i++) {
                    Segment seg = (Segment) segments.get(i);
                                                                            %>
                                                                            <tr align="left"> 
                                                                                <td valign="top" class="tablecell">&nbsp;&nbsp;<%=seg.getName()%></td>
                                                                                <td > 
                                                                                    <table width="50%" border="0" cellspacing="0" cellpadding="0">
                                                                                        <tr>
                                                                                            <td><input type="checkbox" name="chk_all" value="1" onClick="setChecked(this)"></td>
                                                                                            <td class="fontarial">&nbsp;<b><i>Semua Lokasi</i></b></td>
                                                                                        </tr> 
                                                                                        <%
                                                                                    int loopx = 0;
                                                                                    if (segLocs != null && segLocs.size() > 0) {
                                                                                        loopx = segLocs.size() / 2;
                                                                                        if (segLocs.size() % 2 > 0) {
                                                                                            loopx = loopx + 1;
                                                                                        }

                                                                                        for (int x = 0; x < loopx; x++) {
                                                                                            int idx = 2 * x;
                                                                                            SegmentDetail sg1 = (SegmentDetail) segLocs.get(idx);
                                                                                            int idxn = idx + 1;
                                                                                            SegmentDetail sg2 = new SegmentDetail();
                                                                                            if (idxn < segLocs.size()) {
                                                                                                sg2 = (SegmentDetail) segLocs.get(idxn);
                                                                                            }

                                                                                        %>
                                                                                        <tr> 
                                                                                            <td width="4%"> 
                                                                                            <input type="checkbox" name="chk_<%=sg1.getOID()%>" value="1" <%=isChecked(sg1.getOID(), sgSelected)%>>
                                                                                                   </td>
                                                                                            <td width="44%" nowrap>&nbsp;<%=sg1.getName()%></td>
                                                                                            <td width="4%"> 
                                                                                            <%if (sg2.getOID() != 0) {%>
                                                                                            <input type="checkbox" name="chk_<%=sg2.getOID()%>" value="1" <%=isChecked(sg2.getOID(), sgSelected)%>>
                                                                                                   <%}%>
                                                                                                   </td>
                                                                                            <td width="48%" nowrap> 
                                                                                                <%if (sg2.getOID() != 0) {%>
                                                                                                &nbsp;<%=sg2.getName()%> 
                                                                                                <%}%>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <%}
                                                                                    }%>
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                            <%}
            }%>                                                
                                                                            <tr> 
                                                                                <td colspan="3" class="command">&nbsp;</td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td colspan="3"> 
                                                                                    <%
            jspLine.setLocationImg(approot + "/images/ctr_line");
            jspLine.initDefault();
            jspLine.setTableWidth("60%");
            String scomDel = "javascript:cmdDelete('" + appUserOID + "')";
            String sconDelCom = "javascript:cmdConfirmDelete('" + appUserOID + "')";
            String scancel = "javascript:cmdCancel('" + appUserOID + "')";
            jspLine.setBackCaption("Back to List");
            jspLine.setJSPCommandStyle("buttonlink");
            jspLine.setDeleteCaption("Delete Data");
            jspLine.setAddCaption("");

            jspLine.setOnMouseOut("MM_swapImgRestore()");
            jspLine.setOnMouseOverSave("MM_swapImage('save','','" + approot + "/images/save2.gif',1)");
            jspLine.setSaveImage("<img src=\"" + approot + "/images/save.gif\" name=\"save\" height=\"22\" border=\"0\">");

            jspLine.setOnMouseOverBack("MM_swapImage('back','','" + approot + "/images/back2.gif',1)");
            jspLine.setBackImage("<img src=\"" + approot + "/images/back.gif\" name=\"back\" height=\"22\" border=\"0\">");

            jspLine.setOnMouseOverDelete("MM_swapImage('delete','','" + approot + "/images/delete2.gif',1)");
            jspLine.setDeleteImage("<img src=\"" + approot + "/images/delete.gif\" name=\"delete\" height=\"22\" border=\"0\">");

            jspLine.setOnMouseOverEdit("MM_swapImage('edit','','" + approot + "/images/back2.gif',1)");
            jspLine.setEditImage("<img src=\"" + approot + "/images/back.gif\" name=\"edit\" height=\"22\" border=\"0\">");


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
                                                                                <%= jspLine.drawImageOnly(iJSPCommand, excCode, msgString)%></td>
                                                                            </tr>
                                                                            <tr height="25"> 
                                                                                <td width="15%">&nbsp;</td>
                                                                                <td width="33%">&nbsp;</td>
                                                                                <td width="52%">&nbsp;</td>
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
     int countx = DbHistoryUser.getCount(DbHistoryUser.colNames[DbHistoryUser.COL_TYPE] + " = " + DbHistoryUser.TYPE_USER+" and " + DbHistoryUser.colNames[DbHistoryUser.COL_REF_ID] + " = " + appUserOID);
     Vector historys = DbHistoryUser.list(0, max, DbHistoryUser.colNames[DbHistoryUser.COL_TYPE] + " = " + DbHistoryUser.TYPE_USER+" and " + DbHistoryUser.colNames[DbHistoryUser.COL_REF_ID] + " = " + appUserOID, DbHistoryUser.colNames[DbHistoryUser.COL_DATE] + " desc");
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
                                                    </span><!-- #EndEditable --> </td>
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
