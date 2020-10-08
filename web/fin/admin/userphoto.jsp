
<%-- 
    Document   : userphoto
    Created on : Apr 20, 2013, 10:45:55 PM
    Author     : Roy Andika
--%>

<%@ page language="java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.admin.*" %>
<%@ include file = "../main/javainit.jsp" %>
<%@ page import = "com.project.fms.activity.*" %>
<%@ include file = "../main/check.jsp" %>
<%
            boolean priv = true;
            boolean privView = true;
            boolean privUpdate = true;
            boolean privAdd = true;
            boolean privDelete = true;
%>
<!-- JSP Block -->
<%
            JSPLine jspLine = new JSPLine();
            int iJSPCommand = JSPRequestValue.requestCommand(request);
            long appUserOID = JSPRequestValue.requestLong(request, "user_oid");
            int start = JSPRequestValue.requestInt(request, "start");
            int subMenuAdmIdx = JSPRequestValue.requestInt(request, "sub_menu_adm_idx");            
            
            User appUser = new User();
            
            String msgString = "";
            int excCode = JSPMessage.NONE;

            if (iJSPCommand == JSPCommand.EDIT) {
                try{
                    appUser = DbUser.fetch(appUserOID);                    
                }catch(Exception e){}        
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
            
            function cmdPassword(oid){
                document.jspUser.user_oid.value=oid;                
                document.jspUser.command.value="<%=JSPCommand.EDIT%>";
                document.jspUser.menu_idx.value="<%=15%>";
                document.jspUser.sub_menu_adm_idx.value="<%=1%>";
                document.jspUser.action="userpassword.jsp";
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
                                                        <form name="jspUser" method="post" enctype="multipart/form-data" action="userphotosave.jsp?command=<%=JSPCommand.EDIT%>&menu_idx=15&sub_menu_adm_idx=2&user_oid=<%=appUser.getOID()%>" >    
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
                                                                                <td colspan="3" height="10"></td>
                                                                            </tr>
                                                                            <tr height="22"> 
                                                                                <td width="15%" bgcolor="#EBEBEB" >&nbsp;<%=langMD[0]%></td>
                                                                                <td width="33%" >&nbsp;:&nbsp; 
                                                                                    <input type="text" name="user_login_id" value="<%=appUser.getLoginId()%>" class="formElemen" size="35" readonly>
                                                                                </td>
                                                                                <td > </td>
                                                                            </tr>    
                                                                            <tr height="120"> 
                                                                                <td width="15%" bgcolor="#EBEBEB" valign="top">&nbsp;Pictures</td>
                                                                                <td colspan="2">&nbsp; &nbsp; 
                                                                                    <img src="../../general/imagesuser/pic_<%=appUser.getOID()%>.jpg" height="120" border="1">
                                                                                </td>
                                                                            </tr>     
                                                                             <tr > 
                                                                                <td width="15%" bgcolor="#EBEBEB" valign="top">&nbsp;Upload</td>
                                                                                <td colspan="2">&nbsp; &nbsp; 
                                                                                    <input type="file" name="pict">
                                                                                    <input type="submit" name="Submit" value="save picture">
                                                                                </td>
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