
<%@ page language="java" %>
<%@ page import = "java.util.*" %> 
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %> 
<%@ page import = "com.project.admin.*" %>
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
            User appUser = new User();
            CmdUser cmdUser = new CmdUser(request);
            JspUser jspUser = cmdUser.getForm();

            Vector segLocs = DbSegmentUser.getSegmentDetailLocation();

            int excCode = JSPMessage.NONE;
            String msgString = "";

            if (iJSPCommand == JSPCommand.SAVE) {
                jspUser.requestEntityObject(appUser);
                String pwd = JSPRequestValue.requestString(request, jspUser.colNames[jspUser.JSP_PASSWORD]);
                String repwd = JSPRequestValue.requestString(request, jspUser.colNames[jspUser.JSP_CJSP_PASSWORD]);
                if (!pwd.equals(repwd)) {
                    excCode = JSPMessage.ERR_PWDSYNC;
                    msgString = JSPMessage.getMessage(excCode);
                }
            }

            if (excCode == JSPMessage.NONE) {
                excCode = cmdUser.action(iJSPCommand, appUserOID);
                msgString = cmdUser.getMessage();
                appUser = cmdUser.getUser();

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
                    DbUserGroup.insert(ugroup);

                    //process segment user
                    if (segLocs != null && segLocs.size() > 0) {

                        for (int i = 0; i < segLocs.size(); i++) {
                            SegmentDetail sd = (SegmentDetail) segLocs.get(i);
                            long oidx = JSPRequestValue.requestLong(request, "chk_" + sd.getOID());
                            if (oidx != 0) {
                                sgSelected.add("" + oidx);
                            }
                        }
                        DbSegmentUser.proceedSegment(sgSelected, appUser.getOID());

                    }


                } catch (Exception e) {
                }

            }

            sgSelected = DbSegmentUser.list(0, 0, "user_id=" + appUser.getOID(), "");

            /*** LANG ***/
            String[] langMD = {"Login-ID", "Password", "Confirm Password", "Full Name", "Employee Number", "Level", "Email", "Description", //0-7
                "User Status", "Last Update Date", "Registered Date", "Last Login Date", "Last Login IP", "Group Privilege", "Company"}; //8-14
            if (lang == LANG_ID) {
                String[] langID = {"Login-ID", "Password", "Konfirmasi Password", "Nama Lengkap", "NIP", "Level", "Email", "Keterangan",
                    "User Status", "Terakhir Diperbaharui", "Tanggal Didaftarkan", "Login Terakhir", "IP Login Terakhir", "Hak Akses", "Perusahan"
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
                        document.jspUser.action="useredit.jsp";
                        document.jspUser.submit();
                    }
                    
                    <%if (privAdd || privUpdate) {%>
                    function cmdSave(){
                        document.jspUser.command.value="<%=JSPCommand.SAVE%>";
                        document.jspUser.action="useredit.jsp";
                        document.jspUser.submit();
                    }
                    <%}%>
                    
                    <% if (privDelete) {%>
                    function cmdDelete(oid){
                        document.jspUser.user_oid.value=oid;
                        document.jspUser.command.value="<%=JSPCommand.ASK%>";
                        document.jspUser.action="useredit.jsp";
                        document.jspUser.submit();
                    }
                    
                    function cmdConfirmDelete(oid){
                        document.jspUser.user_oid.value=oid;
                        document.jspUser.command.value="<%=JSPCommand.DELETE%>";
                        document.jspUser.action="useredit.jsp";
                        document.jspUser.submit();
                    }
                    <%}%>
                    
                    
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
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr> 
                                                                    <td class="container"> 
                                                                        <table width="100%" border="0" cellpadding="1" cellspacing="1">
                                                                            <%if ((excCode > -1) || ((iJSPCommand == JSPCommand.SAVE) && (jspUser.errorSize() > 0)) || (iJSPCommand == JSPCommand.ADD) || (iJSPCommand == JSPCommand.EDIT) || (iJSPCommand == JSPCommand.ASK)) {%>
                                                                            <tr> 
                                                                                <td colspan="3">&nbsp; </td>
                                                                            </tr>
                                                                            
                                                                            <tr height="22"> 
                                                                                <td width="15%" class="tablecell1">&nbsp;&nbsp;<%=langMD[0]%></td>
                                                                                <td size="2" class="fontarial">:</td>
                                                                                <td width="33%" > 
                                                                                    <input type="text" name="<%=jspUser.colNames[jspUser.JSP_LOGIN_ID] %>" value="<%=appUser.getLoginId()%>" class="formElemen">
                                                                                * &nbsp;<%= jspUser.getErrorMsg(jspUser.JSP_LOGIN_ID) %></td>
                                                                                <td rowspan="7" height="26" valign="top" width="52%"> 
                                                                                    <%if (appUser.getOID() != 0) {%>
                                                                                    <a href="user_image.jsp?user_oid=<%=appUserOID%>"><img src="../images/<%=appUser.getEmployeeNum()%>.jpg" width="115" border="0"></a> 
                                                                                    <%}%>
                                                                                </td>
                                                                            </tr>
                                                                            <tr height="23"> 
                                                                                <td class="tablecell1">&nbsp;&nbsp;<%=langMD[1]%></td>
                                                                                <td size="2" class="fontarial">:</td>
                                                                                <td > 
                                                                                    <input type="password" name="<%=jspUser.colNames[jspUser.JSP_PASSWORD] %>" value="<%=appUser.getPassword()%>" class="formElemen">
                                                                                * &nbsp;<%= jspUser.getErrorMsg(jspUser.JSP_PASSWORD) %></td>
                                                                            </tr>
                                                                            <tr height="23"> 
                                                                                <td class="tablecell1">&nbsp;&nbsp;<%=langMD[2]%></td>
                                                                                <td class="fontarial">:</td>
                                                                                <td > 
                                                                                    <input type="password" name="<%=jspUser.colNames[jspUser.JSP_CJSP_PASSWORD] %>" value="<%=appUser.getPassword()%>" class="formElemen">
                                                                                * &nbsp;<%= jspUser.getErrorMsg(jspUser.JSP_CJSP_PASSWORD) %></td>
                                                                            </tr>                                                                            
                                                                            <tr height="23"> 
                                                                                <td class="tablecell1">&nbsp;&nbsp;<%=langMD[5]%></td>
                                                                                <td class="fontarial">:</td>
                                                                                <td > 
                                                                                    <select name="<%=jspUser.colNames[jspUser.JSP_USER_LEVEL] %>" class="formElemen">
                                                                                        <%for (int i = 0; i < DbUser.levelStr.length; i++) {%>
                                                                                        <option <%if (i == appUser.getUserLevel()) {%>selected<%}%> value="<%=i%>"><%=DbUser.levelStr[i]%></option>
                                                                                        <%}%>
                                                                                    </select>
                                                                                </td>
                                                                            </tr>                                                                            
                                                                            <tr height="23"> 
                                                                                <td class="tablecell1">&nbsp;&nbsp;Employee</td>
                                                                                <td class="fontarial">:</td>
                                                                                <td > 
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
                                                                                    <%= jspUser.getErrorMsg(jspUser.JSP_EMPLOYEE_ID) %>
                                                                                </td>
                                                                            </tr>
                                                                            <tr height="23"> 
                                                                                <td class="tablecell1">&nbsp;&nbsp;User Key</td>
                                                                                <td class="fontarial">:</td>
                                                                                <td > 
                                                                                    <input type="text" name="<%=jspUser.colNames[jspUser.JSP_USER_KEY] %>" value="<%=(appUser.getUserKey() == null) ? "" : appUser.getUserKey()%>" class="formElemen">
                                                                                &nbsp;<%= jspUser.getErrorMsg(jspUser.JSP_USER_KEY) %></td>                                                                                
                                                                            </tr>
                                                                            <tr height="23"> 
                                                                                <td class="tablecell1" valign="top">&nbsp;&nbsp;<%=langMD[7]%></td>
                                                                                <td class="fontarial">:</td>
                                                                                <td > 
                                                                                    <textarea name="<%=jspUser.colNames[jspUser.JSP_DESCRIPTION] %>" cols="48" rows="4" class="formElemen"><%=(appUser.getDescription() == null) ? "" : appUser.getDescription()%></textarea>
                                                                                &nbsp;<%= jspUser.getErrorMsg(jspUser.JSP_DESCRIPTION) %></td>                                                                                
                                                                            </tr>
                                                                            <tr height="23"> 
                                                                                <td class="tablecell1">&nbsp;&nbsp;<%=langMD[8]%></td>
                                                                                <td class="fontarial">:</td>
                                                                                <td > 
                                                                                    <%
    JSPCombo cmbox = new JSPCombo();
    Vector sts = User.getStatusTxts();
    Vector stsVals = User.getStatusVals();
                                                                                    %>
                                                                                    <%=cmbox.draw(jspUser.colNames[jspUser.JSP_USER_STATUS], "formElemen",
                        null, Integer.toString(appUser.getUserStatus()), stsVals, sts)%> &nbsp;<%= jspUser.getErrorMsg(jspUser.JSP_USER_STATUS) %></td>                                                                                
                                                                            </tr>
                                                                            <tr height="23"> 
                                                                                <td class="tablecell1">&nbsp;&nbsp;<%=langMD[9]%></td>
                                                                                <td class="fontarial">:</td>
                                                                                <td ><%=(appUser.getUpdateDate() == null) ? "-" : JSPFormater.formatDate(appUser.getUpdateDate(), "dd MMMM yyyy hh:mm:ss")%> 
                                                                                    <input type="hidden" name="<%=jspUser.colNames[jspUser.JSP_UPDATE_DATE] %>2" value="<%=appUser.getUpdateDate()%>">
                                                                                </td>                                                                                
                                                                            </tr>
                                                                            <tr height="23"> 
                                                                                <td class="tablecell1">&nbsp;&nbsp;<%=langMD[10]%></td>
                                                                                <td class="fontarial">:</td>
                                                                                <td ><%=(appUser.getRegDate() == null) ? "-" : JSPFormater.formatDate(appUser.getRegDate(), "dd MMMM yyyy hh:mm:ss")%></td>                                                                                
                                                                            </tr>
                                                                            <tr height="23"> 
                                                                                <td class="tablecell1">&nbsp;&nbsp;<%=langMD[11]%></td>
                                                                                <td class="fontarial">:</td>
                                                                                <td width="33%"> 
                                                                                    <% if (appUser.getLastLoginDate() == null) {
        out.println("-");
    } else {
        out.println(JSPFormater.formatDate(appUser.getLastLoginDate(), "dd MMMM yyyy hh:mm:ss"));
    }%>
                                                                                </td>                                                                                
                                                                            </tr>                                                                            
                                                                            <tr height="23"> 
                                                                                <td class="tablecell1">&nbsp;&nbsp;<%=langMD[13]%></td>
                                                                                <td class="fontarial">:</td>
                                                                                <td height="14"> 
                                                                                    <%
    Vector grp = DbGroup.list(0, 0, "", "");
    Vector vx = DbUserGroup.list(0, 0, DbUserGroup.colNames[DbUserGroup.COL_USER_ID] + "=" + appUser.getOID(), "");
    long oidx = 0;
    if (vx != null && vx.size() > 0) {
        UserGroup ug = (UserGroup) vx.get(0);
        oidx = ug.getGroupID();
    }
                                                                                    %>
                                                                                    <select name="group_id" class="fontarial">
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
                                                                            </tr>
                                                                            <%
    Vector segments = DbSegment.list(0, 0, "", "count");
    int sizeSegment = 0;
    if (segments != null && segments.size() > 0) {
        sizeSegment = segments.size();
        for (int i = 0; i < segments.size(); i++) {
            Segment seg = (Segment) segments.get(i);
            Vector sgDetails = DbSegmentDetail.list(0, 0, "segment_id=" + seg.getOID(), "");
            String whereSegment = "";
                                                                            %>
                                                                            <tr geight="23"> 
                                                                                <td class="tablecell1" valign="top">&nbsp;&nbsp;<%=seg.getName()%></td>
                                                                                <td class="fontarial" valign="top">:</td>
                                                                                <td colspan="2"> 
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
                                                                                            <input type="checkbox" name="chk_<%=sg1.getOID()%>" value="<%=sg1.getOID()%>" <%=isChecked(sg1.getOID(), sgSelected)%>>
                                                                                                   </td>
                                                                                            <td width="44%" nowrap>&nbsp;<%=sg1.getName()%></td>
                                                                                            <td width="4%"> 
                                                                                            <%if (sg2.getOID() != 0) {%>
                                                                                            <input type="checkbox" name="chk_<%=sg2.getOID()%>" value="<%=sg2.getOID()%>" <%=isChecked(sg2.getOID(), sgSelected)%>>
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
                                                                                <td colspan="3"> 
                                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                        <tr><td background="../images/line.gif"><img src="../images/line.gif"></td>
                                                                                        </tr>
                                                                                    </table>           
                                                                                </td>
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
                                                                                <%= jspLine.drawImageOnly(iJSPCommand, excCode, msgString)%></td>
                                                                            </tr>
                                                                            <%} else {%>
                                                                            <tr> 
                                                                                <td >&nbsp; Processing OK .. back 
                                                                                to list. </td>
                                                                                <td >&nbsp; <a href="javascript:cmdBack()">click 
                                                                                    here</a> 
                                                                                    <script language="JavaScript">
                                                                                        cmdBack();
                                                                                    </script>
                                                                                </td>
                                                                                <td width="52%">&nbsp;</td>
                                                                            </tr>
                                                                            <% }
                                                                            %>                                                                            
                                                                        </table>
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </form>
                                                        <span class="level2"><br>
                                                    </span><!-- #EndEditable --> </td>
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
