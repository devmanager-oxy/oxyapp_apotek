
<%@ page language="java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.main.entity.*" %>
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
    public String drawListUser(Vector objectClass, String[] lang, int start) {

        JSPList jspList = new JSPList();
        jspList.setAreaWidth("1000");
        jspList.setListStyle("listgen");
        jspList.setTitleStyle("tablehdr");
        jspList.setCellStyle("tablecell");
        jspList.setCellStyle1("tablecell1");
        jspList.setHeaderStyle("tablehdr");

        jspList.addHeader("No.", "3%");
        jspList.addHeader(lang[0], "12%");
        jspList.addHeader(lang[1], "16%");
        jspList.addHeader(lang[4], "16%");
        jspList.addHeader(lang[2], "");
        jspList.addHeader(lang[6], "15%");
        jspList.addHeader(lang[5], "15%");
        jspList.addHeader(lang[3], "10%");

        jspList.setLinkRow(1);
        jspList.setLinkSufix("");

        Vector lstData = jspList.getData();
        Vector lstLinkData = jspList.getLinkData();
        jspList.setLinkPrefix("javascript:cmdEdit('");
        jspList.setLinkSufix("')");
        jspList.reset();
        int index = -1;

        for (int i = 0; i < objectClass.size(); i++) {
            User appUser = (User) objectClass.get(i);

            Vector rowx = new Vector();
            int no = i + 1;
            rowx.add("<div align=\"center\">" + String.valueOf(start + no) + "</div>");
            Employee emp = new Employee();
            try {
                emp = DbEmployee.fetchExc(appUser.getEmployeeId());
            } catch (Exception e) {
            }

            User u = new User();
            String lastLogin = "-";
            try {
                u = DbUser.fetch(appUser.getOID());
                if (u.getLastLoginDate() != null) {
                    lastLogin = JSPFormater.formatDate(u.getLastLoginDate(), "dd MMM yyyy HH:mm:ss");
                }
            } catch (Exception e) {
                lastLogin = "-";
            }

            Vector vx = DbUserGroup.list(0, 1, DbUserGroup.colNames[DbUserGroup.COL_USER_ID] + "=" + appUser.getOID(), "");
            String ketGroup = "";
            if (vx != null && vx.size() > 0) {
                UserGroup ug = (UserGroup) vx.get(0);
                try {
                    Group g = DbGroup.fetch(ug.getGroupID());
                    ketGroup = g.getGroupName();
                } catch (Exception e) {
                }
            }

            rowx.add(String.valueOf(appUser.getLoginId()));
            rowx.add(String.valueOf(appUser.getFullName()));
            rowx.add(String.valueOf(emp.getName()));
            rowx.add(String.valueOf(appUser.getDescription()));
            rowx.add(ketGroup);
            rowx.add("<div align=\"center\">" + lastLogin + "</div>");
            rowx.add(String.valueOf(User.getStatusTxt(appUser.getUserStatus())));

            lstData.add(rowx);
            lstLinkData.add(String.valueOf(appUser.getOID()));
        }

        return jspList.draw(index);
    }

%>
<%
            int recordToGet = 25;
            String msgString = "";
            int iErrCode = JSPMessage.NONE;
            String whereClause = "";
            String order = " " + DbUser.colNames[DbUser.COL_LOGIN_ID];

            Vector listUser = new Vector(1, 1);
            JSPLine jspLine = new JSPLine();

            /* GET REQUEST FROM HIDDEN TEXT */
            int iJSPCommand = JSPRequestValue.requestCommand(request);
            int start = JSPRequestValue.requestInt(request, "start");
            int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
            long appUserOID = JSPRequestValue.requestLong(request, "user_oid");
            int listJSPCommand = JSPRequestValue.requestInt(request, "list_command");
            if (listJSPCommand == JSPCommand.NONE) {
                listJSPCommand = JSPCommand.LIST;
            }

            CmdUser cmdUser = new CmdUser(request);
            JSPLine ctrLine = new JSPLine();
            int vectSize = DbUser.getCount(whereClause);

            if ((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV) ||
                    (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)) {
                start = cmdUser.actionList(iJSPCommand, start, vectSize, recordToGet);
            }

            listUser = DbUser.listPartObj(start, recordToGet, whereClause, order);

            if (listUser.size() < 1 && start > 0) {
                if (vectSize - recordToGet > recordToGet) {
                    start = start - recordToGet;
                } //go to JSPCommand.PREV
                else {
                    start = 0;
                    iJSPCommand = JSPCommand.FIRST;
                    prevJSPCommand = JSPCommand.FIRST; //go to JSPCommand.FIRST
                }
                listUser = DbUser.listPartObj(start, recordToGet, whereClause, order);
            }


//start = cmdUser.actionList(listJSPCommand, start, vectSize, recordToGet);


            /*** LANG ***/
            String[] langMD = {"User-ID", "User Name", "Description", "Status", "Employee", "Last Login", "Group"};
            if (lang == LANG_ID) {
                String[] langID = {"User-ID", "Nama User", "Keterangan", "Status", "Pegawai", "Login Terakhir", "Group"};
                langMD = langID;
            }

%>
<!-- End of JSP Block -->
<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
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
            
            <% if (privAdd) {%>
            function addNew(){
                document.frmUser.user_oid.value="0";
                document.frmUser.list_command.value="<%=listJSPCommand%>";
                document.frmUser.command.value="<%=JSPCommand.ADD%>";
                document.frmUser.action="useredit.jsp";
                document.frmUser.submit();
            }
            <%}%>
            
            function cmdEdit(oid){
                <%if (privUpdate) {%>
                document.frmUser.user_oid.value=oid;
                document.frmUser.list_command.value="<%=listJSPCommand%>";
                document.frmUser.command.value="<%=JSPCommand.EDIT%>";
                document.frmUser.action="usereditnonpswd.jsp";
                document.frmUser.submit();
                <%}%>
            }
            
            function cmdEditAll(start){
                <%if (privUpdate) {%>                
                document.frmUser.start.value=start;
                document.frmUser.list_command.value="<%=listJSPCommand%>";
                document.frmUser.command.value="<%=JSPCommand.EDIT%>";
                document.frmUser.action="userlist-edit.jsp";
                document.frmUser.submit();
                <%}%>
            }
            
            function cmdListFirst(){
                document.frmUser.command.value="<%=JSPCommand.FIRST%>";
                document.frmUser.list_command.value="<%=JSPCommand.FIRST%>";
                document.frmUser.action="userlist.jsp";
                document.frmUser.submit();
            }
            function cmdListPrev(){
                document.frmUser.command.value="<%=JSPCommand.PREV%>";
                document.frmUser.list_command.value="<%=JSPCommand.PREV%>";
                document.frmUser.action="userlist.jsp";
                document.frmUser.submit();
            }
            
            function cmdListNext(){
                document.frmUser.command.value="<%=JSPCommand.NEXT%>";
                document.frmUser.list_command.value="<%=JSPCommand.NEXT%>";
                document.frmUser.action="userlist.jsp";
                document.frmUser.submit();
            }
            function cmdListLast(){
                document.frmUser.command.value="<%=JSPCommand.LAST%>";
                document.frmUser.list_command.value="<%=JSPCommand.LAST%>";
                document.frmUser.action="userlist.jsp";
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
            String navigator = "<font class=\"lvl1\">Administrator</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">User List</span></font>";
                                           %>
                                           <%@ include file="../main/navigator.jsp"%>
                                                    <!-- #EndEditable --></td>
                                                </tr>
                                                <!--tr> 
                      <td><img src="<%=approot%>/images/title-sp.gif" width="584" height="1"></td> 
                                                </tr-->
                                                <tr> 
                                                    <td><!-- #BeginEditable "content" --> 
                                                        <form name="frmUser" method="post" action="">
                                                            <input type="hidden" name=sel_top_mn">
                                                            <input type="hidden" name="command" value="">
                                                            <input type="hidden" name="user_oid" value="<%=appUserOID%>">
                                                            <input type="hidden" name="vectSize" value="<%=vectSize%>">
                                                            <input type="hidden" name="start" value="<%=start%>">
                                                            <input type="hidden" name="list_command" value="<%=listJSPCommand%>">
                                                            <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                                                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr>
                                                                    <td class="container">&nbsp;</td>
                                                                </tr>
                                                                <tr>
                                                                    <td class="container">
                                                                        
                                                                    </td>
                                                                </tr>
                                                                <% if ((listUser != null) && (listUser.size() > 0)) {%>
                                                                <tr> 
                                                                    <td class="container">                                                                         
                                                                        <%=drawListUser(listUser, langMD, start)%> 
                                                                    </td>    
                                                                </tr>  
                                                                <tr>
                                                                    <td class="container">
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
                                                                            <% ctrLine.setLocationImg(approot + "/images/ctr_line");
     ctrLine.initDefault();
                                                                            %>
                                                                        <%=ctrLine.drawImageListLimit(cmd, vectSize, start, recordToGet)%> </span>                                                                                                                                        
                                                                    </td>
                                                                </tr>
                                                                <%}%>
                                                                <tr>
                                                                    <td class="container">
                                                                        <table width="100%" cellpadding="0" cellspacing="0">
                                                                            <tr>
                                                                                <td colspan="2">&nbsp;</td>
                                                                            </tr>                                                                               
                                                                            <tr valign="middle"> 
                                                                                <td colspan="2" class="command"> 
                                                                                    <table border="0" cellspacing="1" cellpadding="1">
                                                                                        <tr> 
                                                                                            <% if (privAdd) {%>
                                                                                            <td width="20"><a href="javascript:addNew()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new2','','../images/new2.gif',1)"><img src="../images/new.gif" name="new2" width="71" height="22" border="0"></a></td>                                                                                            
                                                                                            <%}%>
                                                                                            <% if (privAdd || privUpdate) {%>
                                                                                            <td width="20">&nbsp;</td>
                                                                                            <td >
                                                                                                <table border=0>
                                                                                                    <tr>
                                                                                                        <td><a href="javascript:cmdEditAll('<%=start%>')"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new21','','../images/revised.gif',1)"><img src="../images/revised.gif" name="new21" height="22" border="0"></a></td>
                                                                                                        <td><a href="javascript:cmdEditAll('<%=start%>')" ><font face="arial"><b>Edit Data</b></font></a></td>
                                                                                                    </tr>    
                                                                                                </table> 
                                                                                            </td>  
                                                                                            <%}%>
                                                                                            <td >&nbsp;</td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
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
