
<%-- 
    Document   : groupupdate
    Created on : Oct 6, 2011, 9:53:56 AM
    Author     : Roy Andika
--%>

<%@ page language="java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.admin.*" %>
<%@ page import = "com.project.fms.menu.*" %>
<%@ include file = "../main/javainit.jsp" %>
<% int appObjCode = ObjInfo.composeObjCode(ObjInfo.G1_ADMIN, ObjInfo.G2_ADMIN_USER, ObjInfo.OBJ_ADMIN_USER_USER);%>
<%@ include file = "../main/check.jsp" %>

<%
            boolean priv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MENU_ADMINISTRATOR, AppMenu.M2_MENU_ADMINISTRATOR);
            boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_ADMINISTRATOR, AppMenu.M2_MENU_ADMINISTRATOR, AppMenu.PRIV_VIEW);
            boolean privUpdate = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_ADMINISTRATOR, AppMenu.M2_MENU_ADMINISTRATOR, AppMenu.PRIV_UPDATE);
            boolean privAdd = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_ADMINISTRATOR, AppMenu.M2_MENU_ADMINISTRATOR, AppMenu.PRIV_ADD);
            boolean privDelete = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_ADMINISTRATOR, AppMenu.M2_MENU_ADMINISTRATOR, AppMenu.PRIV_DELETE);
%>

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
            int start = JSPRequestValue.requestInt(request, "start");

            CmdGroup ctrlGroup = new CmdGroup(request);

            int iErrCode = ctrlGroup.action(iJSPCommand, appGroupOID);
            JspGroup frmGroup = ctrlGroup.getForm();
            String msgString = ctrlGroup.getMessage();
            Group appGroup = ctrlGroup.getGroup();

            Vector vMenuFinance = new Vector();
            String orderFinance = DbMenu.colNames[DbMenu.COL_LEVEL] + " ASC ";
            vMenuFinance = DbMenu.list(0, 0, "", orderFinance);

            if (iErrCode == 0) {
                msgString = "";
            }

            if (iJSPCommand == JSPCommand.SAVE) {
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

                            try {
                                DbUserPriv.insertExc(up);
                            } catch (Exception e) {}
                        }
                    }
                }

                int totCRM1 = 200 + AppMenu.strCRM1.length;
                int ids = 0;
                for (int i = 200; i < totCRM1; i++) {

                    for (int x = 0; x < AppMenu.strCrm2[ids].length; x++) {

                        if (JSPRequestValue.requestInt(request, "menuCRM2_" + i + "" + x) == 1) {
                            UserPriv up = new UserPriv();
                            up.setMn1(i);
                            up.setMn2(x);
                            up.setGroupId(appGroup.getOID());
                            up.setCmdView(JSPRequestValue.requestInt(request, "menuCRM2_view" + i + "" + x));

                            try {
                                DbUserPriv.insertExc(up);
                            } catch (Exception e) {}
                        }
                    }
                    ids++;
                }

            }

            /*** LANG ***/
            String[] langMD = {"Group Name", "Description", "Privilege Assigned", "Creation/Update Date"};
            if (lang == LANG_ID) {
                String[] langID = {"Nama Kelompok", "Keterangan", "Hak Akses", "Dibuat/Diperbaharui Tanggal"};
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
            String navigator = "<font class=\"lvl1\">Administrator</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">Group Edit</span></font>";
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
                                                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr> 
                                                                    <td class="container"> 
                                                                        <table width="100%">
                                                                            <%
            //if(((iJSPCommand==JSPCommand.SAVE)&&(frmGroup.errorSize()>0))
            if (((iJSPCommand == JSPCommand.SAVE)) || (iJSPCommand == JSPCommand.ADD) || (iJSPCommand == JSPCommand.EDIT) || (iJSPCommand == JSPCommand.ASK)) {

                                                                            %>
                                                                            <tr> 
                                                                                <td colspan="2" class="txtheading1"></td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td colspan="2" height="20" class="bigtitleflash">&nbsp;</td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td width="13%"><%=langMD[0]%></td>
                                                                                <td width="87%"> 
                                                                                    <input type="text" name="<%=frmGroup.colNames[frmGroup.JSP_GROUP_NAME] %>" value="<%=appGroup.getGroupName()%>" class="formElemen" size="30">
                                                                                * &nbsp;<%= frmGroup.getErrorMsg(frmGroup.JSP_GROUP_NAME) %></td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td width="13%" valign="top"><%=langMD[1]%></td>
                                                                                <td width="87%"> 
                                                                                    <textarea name="<%=frmGroup.colNames[frmGroup.JSP_DESCRIPTION] %>" cols="40" rows="3" class="formElemen"><%=appGroup.getDescription()%></textarea>
                                                                                </td>
                                                                            </tr>
                                                                            <tr> 
                                                                            <td width="13%" valign="top" height="14" nowrap><%=langMD[2]%></td>
                                                                            <td width="87%" height="14"> 
                                                                                <%//=ctrCheckBox(appGroupOID)%>
                                                                                <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                                    <tr> 
                                                                                        <td colspan="2">1. <U>MENU FINANCE</U></td>
                                                                                    </tr>                                                                                    
                                                                                    <%if (vMenuFinance != null && vMenuFinance.size() > 0) {%>
                                                                                    <tr> 
                                                                                        <td colspan="2">
                                                                                            <table width="70%" border="0" cellspacing="1" cellpadding="1">
                                                                                                <tr>
                                                                                                    <td width="60%" class="tablehdr">Menu</td>
                                                                                                    <td width="10%" class="tablehdr">View</td>
                                                                                                    <td width="10%" class="tablehdr">Update</td>
                                                                                                    <td width="10%" class="tablehdr">Add</td>
                                                                                                    <td width="10%" class="tablehdr">Delete</td>
                                                                                                </tr>
                                                                                                <%
                                                                                for (int im = 0; im < vMenuFinance.size(); im++) {

                                                                                    Menu mFin = (Menu) vMenuFinance.get(im);

                                                                                    String str = "";

                                                                                    switch (mFin.getLevel()) {
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
                                                                                    }

                                                                                    String style = "";
                                                                                    String mnFin = "";
                                                                                    if (lang == LANG_ID) {
                                                                                        mnFin = mFin.getMenuInd();
                                                                                    } else {
                                                                                        mnFin = mFin.getMenuEng();
                                                                                    }

                                                                                    if (im % 2 == 0) {
                                                                                        style = "tablecell";
                                                                                    } else {
                                                                                        style = "tablecell1";
                                                                                    }

                                                                                                %>
                                                                                                <tr>
                                                                                                    <td class="<%=style%>">&nbsp;&nbsp;<%=str%><%=mFin.getCodeMenu()%> - <%=mnFin%></td>
                                                                                                    <td class="<%=style%>" align="center"><input type="checkbox" name="menuFinView_<%=mFin.getOID()%>" value="1"></td>
                                                                                                    <td class="<%=style%>" align="center"><input type="checkbox" name="menuFinUpdate_<%=mFin.getOID()%>" value="1"></td>
                                                                                                    <td class="<%=style%>" align="center"><input type="checkbox" name="menuFinAdd_<%=mFin.getOID()%>" value="1"></td>
                                                                                                    <td class="<%=style%>" align="center"><input type="checkbox" name="menuFinDelete_<%=mFin.getOID()%>" value="1"></td>
                                                                                                </tr>
                                                                                                <%
                                                                                }
                                                                                                %>
                                                                                            </table>
                                                                                        </td>
                                                                                    </tr>
                                                                                    <%}%>
                                                                                    
                                                                                    <%

                                                                                for (int i = 0; i < AppMenu.strMenu1.length; i++) {%>
                                                                                    <tr> 
                                                                                        <td colspan="2"> <b><%=AppMenu.strMenu1[i].toUpperCase()%></b> </td>
                                                                                    </tr>
                                                                                    <tr> 
                                                                                        <td width="3%">&nbsp;</td>
                                                                                        <td width="97%"> 
                                                                                            <table width="95%" border="0" cellspacing="0" cellpadding="0">
                                                                                                <%for (int x = 0; x < AppMenu.strMenu2[i].length; x++) {

                                                                                                                                                                            int count = DbUserPriv.getCount(DbUserPriv.colNames[DbUserPriv.COL_GROUP_ID] + "=" + appGroup.getOID() + " and " + DbUserPriv.colNames[DbUserPriv.COL_MN_1] + "=" + i + " and " + DbUserPriv.colNames[DbUserPriv.COL_MN_2] + "=" + x);
                                                                                                                                                                            Vector vx = DbUserPriv.list(0, 0, DbUserPriv.colNames[DbUserPriv.COL_GROUP_ID] + "=" + appGroup.getOID() + " and " + DbUserPriv.colNames[DbUserPriv.COL_MN_1] + "=" + i + " and " + DbUserPriv.colNames[DbUserPriv.COL_MN_2] + "=" + x, "");
                                                                                                                                                                            UserPriv uv = new UserPriv();
                                                                                                                                                                            if (vx != null && vx.size() > 0) {
                                                                                                                                                                                uv = (UserPriv) vx.get(0);
                                                                                                                                                                            }
                                                                                                %>
                                                                                                <tr> 
                                                                                                    <td width="3%"> 
                                                                                                    <input type="checkbox" name="menu2_<%=i%><%=x%>" value="1" <%if (uv.getOID() != 0) {%>checked<%}%>>
                                                                                                           </td>
                                                                                                    <td width="22%"><%=AppMenu.strMenu2[i][x]%></td>
                                                                                                    <td width="75%"> 
                                                                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                                            <tr> 
                                                                                                                <td width="3%"> 
                                                                                                                <input type="checkbox" name="menu2_view<%=i%><%=x%>" value="1" <%if (uv.getCmdView() == 1) {%>checked<%}%>></td>
                                                                                                                <td width="10%">&nbsp;View</td>
                                                                                                                
                                                                                                                <td width="3%"> 
                                                                                                                <input type="checkbox" name="menu2_update<%=i%><%=x%>" value="1" <%if (uv.getCmdEdit() == 1) {%>checked<%}%>></td>
                                                                                                                <td width="10%">&nbsp;Update</td>
                                                                                                                
                                                                                                                <td width="3%"> 
                                                                                                                <input type="checkbox" name="menu2_add<%=i%><%=x%>" value="1" <%if (uv.getCmdAdd() == 1) {%>checked<%}%>></td>
                                                                                                                <td width="10%">&nbsp;Add</td>
                                                                                                                
                                                                                                                <td width="3%">
                                                                                                                <input type="checkbox" name="menu2_delete<%=i%><%=x%>" value="1" <%if (uv.getCmdDelete() == 1) {%>checked<%}%>></td>
                                                                                                                <td width="58%">&nbsp;Delete</td>
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
                                                                                    <tr> 
                                                                                        <td colspan="2">&nbsp;</td>
                                                                                    </tr>
                                                                                    <tr> 
                                                                                        <td colspan="2"> <b>2. MENU CRM</b></td>
                                                                                    </tr>
                                                                                    <tr> 
                                                                                        <td colspan="2" height = 10px></td>
                                                                                    </tr>
                                                                                    <%
                                                                                int totCRM1 = 200 + AppMenu.strCRM1.length;
                                                                                int idx = 0;
                                                                                for (int j = 200; j < totCRM1; j++) {%>
                                                                                    <tr> 
                                                                                        <td colspan="2"> <b><%=AppMenu.strCRM1[idx].toUpperCase()%></b></td>
                                                                                    </tr>
                                                                                    <tr> 
                                                                                        <td width="3%">&nbsp;</td>
                                                                                        <td width="97%"> 
                                                                                            <table width="95%" border="0" cellspacing="0" cellpadding="0">
                                                                                                
                                                                                                <%for (int x = 0; x < AppMenu.strCrm2[idx].length; x++) {

                                                                                            int count = DbUserPriv.getCount(DbUserPriv.colNames[DbUserPriv.COL_GROUP_ID] + "=" + appGroup.getOID() + " and " + DbUserPriv.colNames[DbUserPriv.COL_MN_1] + "=" + j + " and " + DbUserPriv.colNames[DbUserPriv.COL_MN_2] + "=" + x);
                                                                                            Vector vx = DbUserPriv.list(0, 0, DbUserPriv.colNames[DbUserPriv.COL_GROUP_ID] + "=" + appGroup.getOID() + " and " + DbUserPriv.colNames[DbUserPriv.COL_MN_1] + "=" + j + " and " + DbUserPriv.colNames[DbUserPriv.COL_MN_2] + "=" + x, "");
                                                                                            UserPriv uv = new UserPriv();
                                                                                            if (vx != null && vx.size() > 0) {
                                                                                                uv = (UserPriv) vx.get(0);
                                                                                            }
                                                                                                %>
                                                                                                <tr> 
                                                                                                    <td width="3%"> 
                                                                                                    <input type="checkbox" name="menuCRM2_<%=j%><%=x%>" value="1" <%if (uv.getOID() != 0) {%>checked<%}%>>
                                                                                                           </td>
                                                                                                    <td width="22%"><%=AppMenu.strCrm2[idx][x]%></td>
                                                                                                    <td width="75%"> 
                                                                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                                            <tr> 
                                                                                                                <td width="3%"> 
                                                                                                                <input type="checkbox" name="menuCRM2_view<%=j%><%=x%>" value="1" <%if (uv.getCmdView() == 1) {%>checked<%}%>>
                                                                                                                       </td>
                                                                                                                <td width="10%">&nbsp;View</td>
                                                                                                                <td width="3%"> 
                                                                                                                <input type="checkbox" name="menuCRM2_update<%=j%><%=x%>" value="1" <%if (uv.getCmdEdit() == 1) {%>checked<%}%>>
                                                                                                                       </td>
                                                                                                                <td width="64%">&nbsp;Update</td>
                                                                                                                <td width="20%">&nbsp;</td>
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
                                                                                    <%idx++;%>
                                                                                    <%}%>
                                                                                </table>
                                                                            </td>
                                                                            <tr> 
                                                                            <td width="13%" valign="top" height="14" nowrap><%=langMD[3]%></td>
                                                                            <td width="87%" height="14"><%=JSPDate.drawDate(frmGroup.colNames[JspGroup.JSP_REG_DATE], appGroup.getRegDate(), "formElemen", 0, -30)%> </td>
                                                                            <tr> 
                                                                            <td width="13%" valign="top" height="14" nowrap><a name="go"></a></td>
                                                                            <td width="87%" height="14">&nbsp;</td>
                                                                            <%if (iJSPCommand == JSPCommand.SAVE && iErrCode == 0) {%>
                                                                            <tr> 
                                                                                <td colspan="2" class="command"><font color="#006600"><i>Data 
                                                                                has been saved</i></font></td>
                                                                            </tr>
                                                                            <%}%>
                                                                            <tr> 
                                                                                <td colspan="2" class="command"> 
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

                                                                                //ctrLine.setOnMouseOut("MM_swapImgRestore()");
                                                                                ctrLine.setOnMouseOverBack("MM_swapImage('back','','" + approot + "/images/cancel2.gif',1)");
                                                                                ctrLine.setBackImage("<img src=\"" + approot + "/images/cancel.gif\" name=\"back\" height=\"22\" border=\"0\">");

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
                                                                                <td width="13%">&nbsp; Processing OK .. back 
                                                                                to list. </td>
                                                                                <td width="87%">&nbsp; <a href="javascript:cmdBack()">click 
                                                                                    here</a> 
                                                                                    <script language="JavaScript">
                                                                                        //cmdBack();
                                                                                    </script>
                                                                                </td>
                                                                            </tr>
                                                                            <% }
                                                                            %>
                                                                            <tr> 
                                                                                <td width="13%">&nbsp;</td>
                                                                                <td width="87%">&nbsp;</td>
                                                                            </tr>
                                                                        </table>
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
