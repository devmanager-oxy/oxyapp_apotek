<%@ page language="java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.admin.*" %>
<%@ include file = "../main/javainit.jsp" %>
<% int  appObjCode =  ObjInfo.composeObjCode(ObjInfo.G1_ADMIN, ObjInfo.G2_ADMIN_USER, ObjInfo.OBJ_ADMIN_USER_USER); %>
<%@ include file = "../main/check.jsp" %>
<%
/* Check privilege except VIEW, view is already checked on checkappUser.jsp as basic access*/
boolean privAdd=true;//appUserQrion.checkPrivilege(ObjInfo.composeCode(appObjCode, ObjInfo.COMMAND_ADD));
boolean privView=true;//appUserQrion.checkPrivilege(ObjInfo.composeCode(appObjCode, ObjInfo.COMMAND_VIEW));
boolean privUpdate=true;//appUserQrion.checkPrivilege(ObjInfo.composeCode(appObjCode, ObjInfo.COMMAND_UPDATE));
boolean privDelete=true;//appUserQrion.checkPrivilege(ObjInfo.composeCode(appObjCode, ObjInfo.COMMAND_DELETE));
%>
<%
long appUserOID = JSPRequestValue.requestLong(request,"user_oid");
int iJSPCommand = JSPRequestValue.requestCommand(request);

User appUser = new User();
try{
	appUser = DbUser.fetch(appUserOID);
}
catch(Exception e){
}

session.putValue("USER_IMAGE", appUser);

%>
<!-- JSP Block -->
<!-- End of JSP Block -->
<html >
<!-- #BeginTemplate "/Templates/index.dwt" --> 
<head>
<!-- #BeginEditable "javascript" --> 
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title><%=systemTitle%></title>
<link href="../css/css.css" rel="stylesheet" type="text/css" />
<script type="text/javascript">
<!--
function MM_swapImgRestore() { //v3.0
  var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
}
function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}

function MM_findObj(n, d) { //v4.01
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
  if(!x && d.getElementById) x=d.getElementById(n); return x;
}

function MM_swapImage() { //v3.0
  var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
   if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
}
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
          <td height="96"> <!-- #BeginEditable "header" --> 
            <%@ include file="../main/hmenu.jsp"%>
            <!-- #EndEditable --> </td>
        </tr>
        <tr> 
          <td valign="top"> 
            <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
              <!--DWLayoutTable-->
              <tr> 
                <td width="165" height="100%" valign="top" background="<%=approot%>/images/leftbg.gif"> 
                  <!-- #BeginEditable "menu" --> 
                  <%@ include file="../main/menu.jsp"%>
                  <!-- #EndEditable --> </td>
                <td width="100%" valign="top"> 
                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr> 
                      <td><!-- #BeginEditable "content" --> 
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                          <tr> 
                            <td class="title"> 
                              <table width="100%" border="0" cellspacing="1" cellpadding="1" height="17">
                                <tr valign="bottom"> 
                                  <td width="60%" height="23"><b><font color="#990000" class="lvl1">Administrator</font><font class="tit1"> 
                                    &raquo; </font><span class="lvl2">User Image 
                                    Editor</span></b></td>
                                  <td width="40%" height="23"> 
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
                            <td valign="top" class="container"> 
                              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                <tr> 
                                  <td valign="top"> 
                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                      <tr> 
                                        <td width="100%" valign="top"> 
                                          <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                            <tr> 
                                              <td width="16%">&nbsp;</td>
                                              <td width="81%">&nbsp;</td>
                                              <td width="1%">&nbsp;</td>
                                              <td width="2%">&nbsp;</td>
                                            </tr>
                                            <tr> 
                                              <td width="16%">Full Name</td>
                                              <td width="81%">: <%=user.getFullName()%></td>
                                              <td width="1%">&nbsp;</td>
                                              <td width="2%">&nbsp;</td>
                                            </tr>
                                            <tr> 
                                              <td width="16%">Employee Number</td>
                                              <td width="81%">: <%=user.getEmployeeNum()%></td>
                                              <td width="1%">&nbsp;</td>
                                              <td width="2%">&nbsp;</td>
                                            </tr>
                                            <tr> 
                                              <td width="16%">&nbsp;</td>
                                              <td width="81%">&nbsp;</td>
                                              <td width="1%">&nbsp;</td>
                                              <td width="2%">&nbsp;</td>
                                            </tr>
                                          </table>
                                          <form name="frmimage" method="post" enctype="multipart/form-data" action="user_image_save.jsp?pic_name=<%=user.getEmployeeNum()%>">
                                            <input type="hidden" name="command" value ="<%=iJSPCommand%>">
                                            <input type="hidden" name="del_command" value="">
                                            <table width="100%" cellpadding="1" cellspacing="1">
                                              <tr> 
                                                <td width="16%"><b><i>Employee 
                                                  Image Editor</i></b></td>
                                                <td width="81%">&nbsp;</td>
                                                <td width="1%">&nbsp;</td>
                                                <td width="2%">&nbsp;</td>
                                              </tr>
                                              <tr> 
                                                <td width="16%">&nbsp;</td>
                                                <td width="81%">&nbsp;</td>
                                                <td width="1%">&nbsp;</td>
                                                <td width="2%">&nbsp;</td>
                                              </tr>
                                              <tr> 
                                                <td width="16%"><img src="../images/<%=appUser.getEmployeeNum()%>.jpg" height="120" border="1"></td>
                                                <td width="81%" valign="top"><b> 
                                                  <input type="file" name="pict">
                                                  <input type="submit" name="Submit" value="save picture">
                                                  </b></td>
                                                <td width="1%">&nbsp;</td>
                                                <td width="2%">&nbsp;</td>
                                              </tr>
                                              <tr> 
                                                <td width="16%">&nbsp;</td>
                                                <td width="81%">&nbsp;</td>
                                                <td width="1%">&nbsp;</td>
                                                <td width="2%">&nbsp;</td>
                                              </tr>
                                              <tr> 
                                                <td width="16%"> 
                                                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                    <tr> 
                                                      <td width="16%"><a href="useredit.jsp?user_oid=<%=appUser.getOID()%>&command=<%=JSPCommand.EDIT%>"><img src="../images/back.gif" border="0"></a></td>
                                                      <td width="84%">&nbsp;</td>
                                                    </tr>
                                                  </table>
                                                </td>
                                                <td width="81%">&nbsp;</td>
                                                <td width="1%">&nbsp;</td>
                                                <td width="2%">&nbsp;</td>
                                              </tr>
                                              <tr> 
                                                <td width="16%">&nbsp;</td>
                                                <td width="81%">&nbsp;</td>
                                                <td width="1%">&nbsp;</td>
                                                <td width="2%">&nbsp;</td>
                                              </tr>
                                              <tr> 
                                                <td width="16%">&nbsp;</td>
                                                <td width="81%">&nbsp;</td>
                                                <td width="1%">&nbsp;</td>
                                                <td width="2%">&nbsp;</td>
                                              </tr>
                                              <tr> 
                                                <td width="16%">&nbsp;</td>
                                                <td width="81%">&nbsp;</td>
                                                <td width="1%">&nbsp;</td>
                                                <td width="2%">&nbsp;</td>
                                              </tr>
                                              <tr> 
                                                <td width="16%">&nbsp;</td>
                                                <td width="81%">&nbsp;</td>
                                                <td width="1%">&nbsp;</td>
                                                <td width="2%">&nbsp;</td>
                                              </tr>
                                            </table>
                                          </form>
                                          <br>
                                        </td>
                                      </tr>
                                    </table>
                                  </td>
                                </tr>
                              </table>
                            </td>
                          </tr>
                          <% if(appUserOID != 0){%>
                          <%}%>
                        </table>
                        
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
          <td height="25"> <!-- #BeginEditable "footer" --> 
            <%@ include file = "../main/footer.jsp" %>
            <!-- #EndEditable --> </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
</body>
<!-- #EndTemplate -->
</html>
