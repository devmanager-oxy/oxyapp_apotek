
<%-- 
    Document   : userpassword
    Created on : Apr 20, 2013, 1:24:52 PM
    Author     : Roy Andika
--%>

<%@ page language="java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.admin.*" %>
<%@ page import = "com.project.general.*" %>
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
<%
            JSPLine jspLine = new JSPLine();
            int iJSPCommand = JSPRequestValue.requestCommand(request);
            long appUserOID = JSPRequestValue.requestLong(request, "user_oid");
            int start = JSPRequestValue.requestInt(request, "start");
            int subMenuAdmIdx = JSPRequestValue.requestInt(request, "sub_menu_adm_idx");
            String userLoginId = JSPRequestValue.requestString(request, "user_login_id");
            String userPassword = JSPRequestValue.requestString(request, "user_password");
            String userKonfirmasiPassword = JSPRequestValue.requestString(request, "user_konfirmasi_password");

            User appUser = new User();

            String msgString = "";
            int excCode = JSPMessage.NONE;

            if (iJSPCommand == JSPCommand.EDIT) {
                try {
                    appUser = DbUser.fetch(appUserOID);
                    userLoginId = appUser.getLoginId();
                } catch (Exception e) {
                }
            }

            if (iJSPCommand == JSPCommand.SAVE) {

                if (userPassword != null && userPassword.length() > 0 && userPassword.equals(userKonfirmasiPassword)) {
                    try {
                        appUser = DbUser.fetch(appUserOID);
                    } catch (Exception e) {
                    }

                    User appUserOld = new User();
                    try {
                        appUserOld = DbUser.fetch(appUserOID);
                    } catch (Exception e) {
                    }

                    appUser.setLoginId(userLoginId);

                    String memo = "";
                    if (appUserOld.getLoginId().compareTo(userLoginId) != 0) {
                        if (memo.length() > 0) {
                            memo = memo + " ,";
                        }
                        memo = memo + "login id : " + userLoginId;
                    }


                    String sysPswd = "N";
                    try {
                        sysPswd = DbSystemProperty.getValueByName("SYS_MD5");
                    } catch (Exception e) {
                    }

                    if (sysPswd.equals("Y")) {
                        //encrypt password using MD5 Hash
                        String md5Password = MD5.getMD5Hash(userPassword);
                        appUser.setPassword(md5Password);
                    } else {
                        appUser.setPassword(userPassword);
                    }

                    if (appUserOld.getPassword().compareTo(userPassword) != 0) {
                        if (memo.length() > 0) {
                            memo = memo + " ,";
                        }
                        memo = memo + "password : *****";
                    }

                    try {
                        DbUser.updateUser(appUser);
                        if (memo != null && memo.length() > 0) {
                            memo = "Perubahan password "+appUser.getFullName()+" : "+ memo;
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
                    } catch (Exception e) {
                    }
                    excCode = 0;
                    msgString = JSPMessage.getMessage(JSPMessage.MSG_SAVED);
                } else {
                    userKonfirmasiPassword = "";
                    excCode = JSPMessage.ERR_PWDSYNC;
                    msgString = JSPMessage.getMessage(excCode);
                }
            }

            String[] langMD = {"Login-ID", "Password", "Confirm Password"};
            if (lang == LANG_ID) {
                String[] langID = {"Login-ID", "Password", "Konfirmasi Password"};
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
            
            function cmdBack(oid){
                document.jspUser.user_oid.value=oid;
                document.jspUser.command.value="<%=JSPCommand.LIST%>";
                document.jspUser.action="userlist.jsp";
                document.jspUser.submit();
            }
            
            <%if (privAdd || privUpdate) {%>
            function cmdSave(){
                document.jspUser.command.value="<%=JSPCommand.SAVE%>";
                document.jspUser.action="userpassword.jsp";
                document.jspUser.submit();
            }
            <%}%>
            
            function cmdLoginId(oid){
                document.jspUser.user_oid.value=oid;                
                document.jspUser.command.value="<%=JSPCommand.EDIT%>";
                document.jspUser.menu_idx.value="<%=15%>";
                document.jspUser.sub_menu_adm_idx.value="<%=0%>";
                document.jspUser.action="usereditnonpswd.jsp";
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
                                                            <input type="hidden" name="sub_menu_adm_idx" value="<%=subMenuAdmIdx%>">                                                            
                                                            <table width="900" border="0" cellspacing="0" cellpadding="0">
                                                                <tr> 
                                                                    <td class="container"> 
                                                                        <table width="100%" border="0" cellpadding="1" cellspacing="1">                                                                           
                                                                            <tr> 
                                                                                <td colspan="3"><%@ include file="tbmenuadmin.jsp"%></td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td colspan="3" height="10"></td>
                                                                            </tr>
                                                                            <tr height="22"> 
                                                                                <td width="15%" bgcolor="#EBEBEB" ><%=langMD[0]%></td>
                                                                                <td width="33%" >&nbsp;:&nbsp; 
                                                                                    <input type="text" name="user_login_id" value="<%=userLoginId%>" class="formElemen" size="35">
                                                                                </td>
                                                                                <td > </td>
                                                                            </tr>    
                                                                            <tr height="22"> 
                                                                                <td bgcolor="#EBEBEB" ><%=langMD[1]%></td>
                                                                                <td >&nbsp;:&nbsp; 
                                                                                    <input type="password" name="user_password" value="<%=userPassword%>" class="formElemen" size="35">                                                                                
                                                                                </td>
                                                                                <td >&nbsp;</td>
                                                                            </tr>         
                                                                            <tr> 
                                                                                <td bgcolor="#EBEBEB"><%=langMD[2]%></td>
                                                                                <td >&nbsp;:&nbsp; 
                                                                                    <input type="password" name="user_konfirmasi_password" value="<%=userKonfirmasiPassword%>" class="formElemen" size="35">
                                                                                </td>
                                                                                <td >&nbsp;</td>
                                                                            </tr>
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

            jspLine.setDeleteCaption("");

            if (privAdd == false && privUpdate == false) {
                jspLine.setSaveCaption("");
            }

            if (privAdd == false) {
                jspLine.setAddCaption("");
            }
                                                                                    %>
                                                                                <%= jspLine.drawImageOnly(iJSPCommand, excCode, msgString)%></td>
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