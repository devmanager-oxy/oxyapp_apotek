 
<%@ page language="java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.main.entity.*" %>
<%@ page import = "com.project.admin.*" %>
<%@ include file = "../main/javainit.jsp" %>
<% int  appObjCode =  0;//ObjInfo.composeObjCode(ObjInfo.G1_ADMIN, ObjInfo.G2_ADMIN_USER, ObjInfo.OBJ_ADMIN_USER_USER); %>
<%@ include file = "../main/check.jsp" %>
<%
/* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
boolean privAdd=true;//appSessUser.checkPrivilege(ObjInfo.composeCode(appObjCode, ObjInfo.COMMAND_ADD));
boolean privView=true;//appSessUser.checkPrivilege(ObjInfo.composeCode(appObjCode, ObjInfo.COMMAND_VIEW));
boolean privUpdate=true;//appSessUser.checkPrivilege(ObjInfo.composeCode(appObjCode, ObjInfo.COMMAND_UPDATE));
boolean privDelete=true;//appSessUser.checkPrivilege(ObjInfo.composeCode(appObjCode, ObjInfo.COMMAND_DELETE));
%>
<!-- JSP Block -->
<%!

public String drawListUser(Vector objectClass)
{
	String temp = ""; 
	String regdatestr = "";
	
	JSPList jspList = new JSPList();
		jspList.setAreaWidth("100%");
		//jspList.setAreaWidth("20%");
		jspList.setListStyle("listgen");
		jspList.setTitleStyle("tablehdr");
		jspList.setCellStyle("tablecell");
		jspList.setCellStyle1("tablecell1");
		jspList.setHeaderStyle("tablehdr");
		
	jspList.addHeader("Login ID","30%");
	jspList.addHeader("Full Name","40%");
	jspList.addHeader("User Key ","30%");		

	jspList.setLinkRow(0);
        jspList.setLinkSufix("");
	
	Vector lstData = jspList.getData();

	Vector lstLinkData 	= jspList.getLinkData();						
	
	jspList.setLinkPrefix("javascript:cmdEdit('");
	jspList.setLinkSufix("')");
	jspList.reset();
	int index = -1;
								
	for (int i = 0; i < objectClass.size(); i++) {
		 User appUser = (User)objectClass.get(i);

		 Vector rowx = new Vector();
		 
		 rowx.add(String.valueOf(appUser.getLoginId()));		 
		 rowx.add(String.valueOf(appUser.getFullName()));
		 rowx.add(String.valueOf(appUser.getUserKey()));		 
		 		 
		 lstData.add(rowx);
		 lstLinkData.add(String.valueOf(appUser.getOID()));
	}						

	return jspList.draw(index);
}

%>
<%

/* VARIABLE DECLARATION */
int recordToGet = 10;

String order = " " + DbUser.colNames[DbUser.COL_LOGIN_ID];

Vector listUser = new Vector(1,1);
JSPLine jspLine = new JSPLine();

/* GET REQUEST FROM HIDDEN TEXT */
int iJSPCommand = JSPRequestValue.requestCommand(request);
int start = JSPRequestValue.requestInt(request, "start"); 
long appUserOID = JSPRequestValue.requestLong(request,"user_oid");
int listJSPCommand = JSPRequestValue.requestInt(request, "list_command");


if(listJSPCommand==JSPCommand.NONE)
 listJSPCommand = JSPCommand.LIST;

CmdUser cmdUser = new CmdUser(request);
 
int vectSize = DbUser.getCount(""); 
start = cmdUser.actionList(listJSPCommand, start,vectSize,recordToGet);

listUser = DbUser.listPartObj(start,recordToGet, "", order);


if(listJSPCommand==JSPCommand.SAVE){
    String key[] = {"a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"};
    Random RndHuruf = new  Random();
    Random RndAngka = new Random();
    String userKey = new String("");
    Random RndTipe = new Random();
    User us = new User();
    for(int b=0; b<listUser.size(); b++){
       us = (User) listUser.get(b);
       userKey="";
       for(int a =0; a<10; a++){
            int tipe = RndTipe.nextInt(20);
            if(tipe < 10){//angka
                userKey += (RndAngka.nextInt(9)); 
            }else{
                int idx = RndHuruf.nextInt(25);
                userKey += key[idx];

            }
       }
       DbUser.updateUserKey(us.getOID(), userKey);
    }
    listUser = DbUser.listPartObj(start,recordToGet, "", order);
}


%>
<!-- End of JSP Block -->
<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
<head>
<!-- #BeginEditable "javascript" --> 
<title><%=titleIS%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<link href="../css/default.css" rel="stylesheet" type="text/css" />
<link href="../css/css.css" rel="stylesheet" type="text/css" />
<script language="JavaScript">

<%if(!adminPriv){%>
	window.location="<%=approot%>/nopriv.jsp";
<%}%>

<%if(!privView &&  !privAdd && !privUpdate && !privDelete){%>
	window.location="<%=approot%>/nopriv.jsp";
<%}%>

<% if (privAdd){%>
function cmdGenerateUserKey(){
    
	document.frmUser.list_command.value="<%=JSPCommand.SAVE%>";
	document.frmUser.command.value="<%=JSPCommand.SAVE%>";
	document.frmUser.action="generateUserKey.jsp";
	document.frmUser.submit();
}
<%}%>
 
function cmdEdit(oid){
	document.frmUser.user_oid.value=oid;
	document.frmUser.list_command.value="<%=listJSPCommand%>";
	document.frmUser.command.value="<%=JSPCommand.EDIT%>";
	document.frmUser.action="useredit.jsp";
	document.frmUser.submit();
}

function first(){
	document.frmUser.command.value="<%=JSPCommand.FIRST%>";
	document.frmUser.list_command.value="<%=JSPCommand.FIRST%>";
	document.frmUser.action="generateUserKey.jsp";
	document.frmUser.submit();
}
function prev(){
	document.frmUser.command.value="<%=JSPCommand.PREV%>";
	document.frmUser.list_command.value="<%=JSPCommand.PREV%>";
	document.frmUser.action="generateUserKey.jsp";
	document.frmUser.submit();
}

function next(){
	document.frmUser.command.value="<%=JSPCommand.NEXT%>";
	document.frmUser.list_command.value="<%=JSPCommand.NEXT%>";
	document.frmUser.action="generateUserKey.jsp";
	document.frmUser.submit();
}
function last(){
	document.frmUser.command.value="<%=JSPCommand.LAST%>";
	document.frmUser.list_command.value="<%=JSPCommand.LAST%>";
	document.frmUser.action="generateUserKey.jsp";
	document.frmUser.submit();
}

function backMenu(){
	document.frmUser.action="<%=approot%>/management/main_systemadmin.jsp";
	document.frmUser.submit();
}


<!--
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
//-->
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
                  <!-- #EndEditable -->
                </td>
                <td width="100%" valign="top"> 
                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    
                    <tr> 
                      <td><!-- #BeginEditable "content" --> 
                        <form name="frmUser" method="post" action="">
                          <input type="hidden" name=sel_top_mn">
                          <input type="hidden" name="command" value="">
                          <input type="hidden" name="user_oid" value="<%=appUserOID%>">
                          <input type="hidden" name="vectSize" value="<%=vectSize%>">
                          <input type="hidden" name="start" value="<%=start%>">
                          <input type="hidden" name="list_command" value="<%=listJSPCommand%>">
                          <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                          <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr> 
                              <td> 
                                <table width="100%" border="0" cellspacing="1" cellpadding="1" height="17">
                                  <tr valign="bottom"> 
                                    <td width="60%" height="23"><b><font color="#990000" class="lvl1">Administrator</font><font class="tit1"> 
                                      &raquo; </font><span class="lvl2">User List</span></b></td>
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
                              <td class="container" height="5"></td>
                            </tr>
                            <tr> 
                              <td class="container"> 
                                <% if ((listUser!=null)&&(listUser.size()>0)){ %>
                                <%=drawListUser(listUser)%> 
                                <%}%>
                                <table width="100%" cellpadding="0" cellspacing="0">
                                  <tr> 
                                    <td colspan="2"> <span class="command"> <%=jspLine.drawMeListLimit(listJSPCommand,vectSize,start,recordToGet,"first","prev","next","last","left")%> </span> </td>
                                  </tr>
                                  <% if (privAdd){%>
                                  <tr valign="middle"> 
                                    <td colspan="2" class="command"> 
                                      <table width="25%" border="0" cellspacing="0" cellpadding="0">
                                        <tr>
                                          <td width="11%">&nbsp;</td>
                                          <td nowrap width="29%">&nbsp;</td>
                                          <td width="13%">&nbsp;</td>
                                          <td nowrap width="47%">&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <% if(privAdd){%>
                                          <td width="15%"><a href="javascript:cmdGenerateUserKey()"> Generate User Key</a></td>
                                          <td nowrap width="29%">&nbsp;</td>
                                          <%}%>
                                          
                                              <td align="center"><a href="../admin/printUserKey.jsp" target='_blank'><img src="../images/print.gif" name="delete" height="22" border="0"></a></td>
  
                                          <td nowrap width="47%">&nbsp;</td>
                                        </tr>
                                      </table>
                                    </td>
                                  </tr>
                                  <%}%>
                                  <tr> 
                                    <td width="13%">&nbsp;</td>
                                    <td width="87%">&nbsp;</td>
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
