
<%@ page language="java"%>
<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.system.*" %>
<%@ page import = "com.project.main.db.*" %>
<%@ page import = "java.util.Date" %>
<%@ include file="main/javainit.jsp"%>
<%@ include file="main/check.jsp"%>
<%
//jsp content
            int iJSPCommand = JSPRequestValue.requestCommand(request);
            String oldPwdError = "";
            String newPwdError = "";
            String cnfPwdError = "";
            boolean isOK = true;
            long oid = 0;

            if (iJSPCommand == JSPCommand.SAVE) {

                String loginId = JSPRequestValue.requestString(request, "login_id");
                String oldPwd = JSPRequestValue.requestString(request, "old_password");
                String newPwd = JSPRequestValue.requestString(request, "new_password");
                String cnfNewPwd = JSPRequestValue.requestString(request, "cnf_new_password");

                //check for error
                if (oldPwd.length() == 0) {
                    oldPwdError = "Entry Required";
                    isOK = false;
                }
                if (newPwd.length() == 0) {
                    newPwdError = "Entry Required";
                    if (isOK) {
                        isOK = false;
                    }
                }
                if (newPwd.length() < 5) {
                    cnfPwdError = "Minimum 5 digit character";
                    if (isOK) {
                        isOK = false;
                    }
                }
                if (!newPwd.equals(cnfNewPwd)) {
                    cnfPwdError = "Confirm password incorrect";
                    if (isOK) {
                        isOK = false;
                    }
                }
                if (!newPwd.equals(cnfNewPwd)) {
                    cnfPwdError = "Confirm password incorrect";
                    if (isOK) {
                        isOK = false;
                    }
                }

                User upadteuser = DbUser.fetch(appSessUser.getUserOID());
                String memo = "";

                String sysPswd = "N";
                try {
                    sysPswd = DbSystemProperty.getValueByName("SYS_MD5");
                } catch (Exception e) {
                }

                String cmpOldPswd = "";

                if (sysPswd.equals("Y")) {
                    cmpOldPswd = MD5.getMD5Hash(oldPwd);
                } else {
                    cmpOldPswd = oldPwd;
                }

                if (!upadteuser.getLoginId().equals(loginId) || !upadteuser.getPassword().equals(cmpOldPswd)) {
                    oldPwdError = "Invalid password";
                    if (isOK) {
                        isOK = false;
                    }
                }

                int count = DbUser.getCountUser(upadteuser.getOID(), upadteuser.getLoginId(), newPwd);
                if (count > 0) {
                    newPwdError = "User or password already exist";
                    isOK = false;
                }

                if (isOK) {
                    if (upadteuser.getPassword().compareTo(newPwd) != 0) {
                        memo = "Perubahan password employee " + upadteuser.getFullName() + " : ***** (Ganti password sendiri)";
                    }
                    try {

                        if (sysPswd.equals("Y")) {
                            //encrypt password using MD5 Hash
                            String md5Password = MD5.getMD5Hash(newPwd);
                            upadteuser.setPassword(md5Password);
                        } else {
                            upadteuser.setPassword(newPwd);
                        }

                        oid = DbUser.updateUser(upadteuser);
                        if (oid != 0) {
                            HistoryUser hisUser = new HistoryUser();
                            hisUser.setUserId(user.getOID());
                            hisUser.setEmployeeId(user.getEmployeeId());
                            hisUser.setRefId(upadteuser.getOID());
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
                }
            }
%>
<html >
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <title>pwd update</title>
        <link href="css/css.css" rel="stylesheet" type="text/css" />
        <script type="text/javascript">
            <!--
            <%if (isOK && oid != 0 && iJSPCommand == JSPCommand.SAVE) {%>
            alert('Your password has been updated, please re-login with your new password !');
            window.location="<%=approot%>/../index.jsp"
            <%}%>
            
            function cmdSave(){
                document.form1.command.value="<%=JSPCommand.SAVE%>";
                document.form1.action="updatepwd.jsp";
                document.form1.submit();
            }
            
            function MM_preloadImages() { //v3.0
                var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
                    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
                    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
            }
            
            function MM_swapImgRestore() { //v3.0
                var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
            }
            //-->
        </script>
    </head>
    <body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','images/save2.gif')">
        <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
            <tr> 
                <td valign="top"> 
                    <table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
                        <!--tr> 
                      <td><img src="<%=approot%>/images/title-sp.gif" width="584" height="1"></td> 
                    </tr-->
                        <tr> 
                            <td> 
                                <form id="form1" name="form1" method="post" action="">
                                    <input type="hidden" name="command">
                                    <table width="45%" border="0" cellspacing="0" cellpadding="0" align="center">
                                        <tr> 
                                            <td class="container" width="19%"><img src="images/logout.jpg" width="200" height="236"></td>
                                            <td class="container" width="81%"> 
                                                <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                    <tr valign="top"> 
                                                        <td colspan="2" height="28">&nbsp;<b>UPDATE PASSWORD</b></td>
                                                    </tr>
                                                    <tr> 
                                                        <td width="30%">&nbsp;Login ID</td>
                                                        <td width="70%"> 
                                                            <input type="text" name="login_id" size="30" readOnly class="readonly" value="<%=appSessUser.getLoginId()%>">
                                                        </td>
                                                    </tr>
                                                    <tr> 
                                                        <td width="30%">&nbsp;Old Password</td>
                                                        <td width="70%"> 
                                                            <input type="password" name="old_password" size="30">
                                                        * <span class="errfont"><%=oldPwdError%></span></td>
                                                    </tr>
                                                    <tr> 
                                                        <td width="30%">&nbsp;</td>
                                                        <td width="70%">&nbsp;</td>
                                                    </tr>
                                                    <tr> 
                                                        <td width="30%">&nbsp;New Password</td>
                                                        <td width="70%"> 
                                                            <input type="password" name="new_password" size="30">
                                                        * <span class="errfont"><%=newPwdError%></span></td>
                                                    </tr>
                                                    <tr> 
                                                        <td width="30%" nowrap>&nbsp;Confirm New Password</td>
                                                        <td width="70%"> 
                                                            <input type="password" name="cnf_new_password" size="30">
                                                        * <span class="errfont"><%=cnfPwdError%></span></td>
                                                    </tr>
                                                    <tr> 
                                                        <td width="30%">&nbsp;</td>
                                                        <td width="70%">&nbsp;</td>
                                                    </tr>
                                                    <tr> 
                                                        <td colspan="2">&nbsp;<a href="javascript:cmdSave()"><b><font color="#0000FF">Save</font></b></a> 
                                                        | <b><a href="../index.jsp"><font color="#0000FF">Login Page</font></a></b></td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                    </table>
                                </form>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </body>
</html>
