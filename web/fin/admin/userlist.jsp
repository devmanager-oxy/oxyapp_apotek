
<%@ page language="java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.util.*" %> 
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.main.entity.*" %>
<%@ page import = "com.project.general.*" %>
<%@ page import = "com.project.admin.*" %>
<%@ include file = "../main/javainit.jsp" %> 
<% int appObjCode = 0;%>
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
    public String drawListUser(Vector objectClass, String[] lang) {
        String temp = "";
        String regdatestr = "";

        JSPList jspList = new JSPList();
        jspList.setAreaWidth("100%");
        jspList.setListStyle("listgen");
        jspList.setTitleStyle("tablehdr");
        jspList.setCellStyle("tablecell");
        jspList.setCellStyle1("tablecell1");
        jspList.setHeaderStyle("tablehdr");

        jspList.addHeader(lang[0], "15%");
        jspList.addHeader(lang[1], "25%");
        jspList.addHeader(lang[2], "50%");
        jspList.addHeader(lang[3], "10%");

        jspList.setLinkRow(0);
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

            rowx.add(String.valueOf(appUser.getLoginId()));
            rowx.add(String.valueOf(appUser.getFullName()));
            rowx.add(String.valueOf(appUser.getDescription()));
            rowx.add(String.valueOf(User.getStatusTxt(appUser.getUserStatus())));

            lstData.add(rowx);
            lstLinkData.add(String.valueOf(appUser.getOID()));
        }

        return jspList.draw(index);
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

            int recordToGet = 20;
            String where = "";
            String order = " " + DbUser.colNames[DbUser.COL_LOGIN_ID];
            Vector listUser = new Vector(1, 1);
            JSPLine jspLine = new JSPLine();

            int iJSPCommand = JSPRequestValue.requestCommand(request);
            int start = JSPRequestValue.requestInt(request, "start");
            long appUserOID = JSPRequestValue.requestLong(request, "user_oid");
            int listJSPCommand = JSPRequestValue.requestInt(request, "list_command");
            String loginId = JSPRequestValue.requestString(request, "login_id");
            String fullName = JSPRequestValue.requestString(request, "fullname");
            int showAll = JSPRequestValue.requestInt(request, "show_all");
            if (listJSPCommand == JSPCommand.NONE) {
                listJSPCommand = JSPCommand.LIST;
            }

            if (loginId != null && loginId.length() > 0) {
                where = "login_id like '%" + loginId + "%'";
            }

            if (fullName != null && fullName.length() > 0) {
                if (where != null && where.length() > 0) {
                    where = where + " and ";
                }
                where = where + "full_name like '%" + fullName + "%'";
            }

            CmdUser cmdUser = new CmdUser(request);
            int vectSize = DbUser.getCount(where);
            start = cmdUser.actionList(listJSPCommand, start, vectSize, recordToGet);
            listUser = DbUser.listPartObj(start, recordToGet, where, order);

            String[] langMD = {"Login-ID", "Full Name", "Description", "Status", "All Location", "Location Access","Group Access"};
            if (lang == LANG_ID) {
                String[] langID = {"Login-ID", "Nama Lengkap", "Keterangan", "Status", "Semua Lokasi", "Lokasi Akses","Group Access"};
                langMD = langID;
            }

            Vector segLocs = DbSegmentUser.getSegmentDetailLocation();

            if (iJSPCommand == JSPCommand.SAVE && listUser != null && listUser.size() > 0){
                for (int i = 0; i < listUser.size(); i++) {
                    User userapp = (User) listUser.get(i);
                    Vector sgSelected = new Vector();

                    Vector segByUser = DbSegmentUser.list(0, 0, DbSegmentUser.colNames[DbSegmentUser.COL_USER_ID] + " = " + userapp.getOID(), null);
                    //process segment user
                    if (segLocs != null && segLocs.size() > 0) {

                        for (int x = 0; x < segLocs.size(); x++) {
                            SegmentDetail sd = (SegmentDetail) segLocs.get(x);
                            long oidx = JSPRequestValue.requestLong(request, "chk_" + userapp.getOID() + "" + sd.getOID());
                            if (oidx != 0) {
                                sgSelected.add("" + oidx);
                            }
                        }
                        String memo = "";
                        if (segByUser != null) {

                            if (segByUser.size() != sgSelected.size()) {
                                memo = "User "+userapp.getFullName()+" : perubahan hak akses lokasi";
                            } else {

                                for (int x = 0; x < segByUser.size(); x++) {
                                    SegmentUser su = (SegmentUser) segByUser.get(x);
                                    boolean exist = false;
                                    for (int y = 0; y < sgSelected.size(); y++) {
                                        System.out.println(su.getOID()+" :::: "+Long.parseLong("" + sgSelected.get(y)));
                                        if (su.getSegmentDetailId() == Long.parseLong("" + sgSelected.get(y))) {
                                            exist = true;
                                        }
                                        if (exist) {
                                            break;
                                        }
                                    }
                                    if (exist == false) {
                                       memo = "User "+userapp.getFullName()+" : perubahan hak akses lokasi";
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
                                            memo = "User "+userapp.getFullName()+" : perubahan hak akses lokasi";
                                            break;
                                        }
                                    }
                                }
                            }
                        } else {
                            if (sgSelected.size() > 0) {
                                memo = "User "+userapp.getFullName()+" : perubahan hak akses lokasi";
                            }
                        }

                        DbSegmentUser.proceedSegment(sgSelected, userapp.getOID());
                        if (memo != null && memo.length() > 0) {
                            HistoryUser hisUser = new HistoryUser();
                            hisUser.setUserId(user.getOID());
                            hisUser.setEmployeeId(user.getEmployeeId());
                            hisUser.setRefId(userapp.getOID());
                            hisUser.setDescription(memo);
                            hisUser.setType(DbHistoryUser.TYPE_USER);
                            hisUser.setDate(new Date());
                            try {
                                DbHistoryUser.insertExc(hisUser);
                            } catch (Exception e) {
                            }
                        }

                    }
                }

                iJSPCommand = JSPCommand.LIST;
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
            
            
            function cmdUnShowAll(){                
                document.frmUser.command.value="<%=JSPCommand.LIST%>";
                document.frmUser.list_command.value="<%=JSPCommand.NONE%>"; 
                document.frmUser.show_all.value=0;
                document.frmUser.action="userlist.jsp";
                document.frmUser.submit();
            }
            
            function cmdShowAll(){                
                document.frmUser.command.value="<%=JSPCommand.LIST%>";
                document.frmUser.list_command.value="<%=JSPCommand.NONE%>"; 
                document.frmUser.show_all.value=1;
                document.frmUser.action="userlist.jsp";
                document.frmUser.submit();
            }
            
            function setChecked(val,sel){
                 <%
            if ((listUser != null) && (listUser.size() > 0)) {
                for (int i = 0; i < listUser.size(); i++) {
                    User userapp = (User) listUser.get(i);
                    %>
                        if(val== '<%=userapp.getOID() %>'){                            
                    <%
                    if ((segLocs != null) && (segLocs.size() > 0)) {
                        for (int k = 0; k < segLocs.size(); k++) {
                            SegmentDetail sg1 = (SegmentDetail) segLocs.get(k);
                 %>
                     document.frmUser.chk_<%=userapp.getOID() + "" + sg1.getOID()%>.checked=sel.checked;
                     <%
                        }
                    }
                    %>
                    } 
                    <%
                }
            }%>
        }
        
        function cmdEdit(oid){
            <%if (privUpdate) {%>
            document.frmUser.user_oid.value=oid;
            document.frmUser.list_command.value="<%=listJSPCommand%>";
            document.frmUser.command.value="<%=JSPCommand.EDIT%>";
            document.frmUser.action="usereditnonpswd.jsp";
            document.frmUser.submit();
            <%}%>
        }
        
        function cmdSave(){
            document.frmUser.command.value="<%=JSPCommand.SAVE%>";
            document.frmUser.list_command.value="<%=JSPCommand.SAVE%>";
            document.frmUser.action="userlist.jsp";
            document.frmUser.submit();
        }
        
        function cmdSearch(){
            document.frmUser.command.value="<%=JSPCommand.LIST%>";
            document.frmUser.action="userlist.jsp";
            document.frmUser.submit();
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
    <body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','../images/new2.gif','../images/save2.gif','../images/search2.gif')">
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
                                                            <input type="hidden" name="show_all" value="0">
                                                            <input type="hidden" name="list_command" value="<%=listJSPCommand%>">
                                                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr> 
                                                                    <td class="container"> 
                                                                        <table width="600" border="0" cellspacing="1" cellpadding="1">
                                                                            <tr height="10"> 
                                                                                <td width="80"></td>
                                                                                <td width="1"></td>                                                                               
                                                                                <td ></td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td colspan="3" height="22" valign="top" class="fontarial"><b><i>Search user by :</i></b></td>                                                                                
                                                                            </tr>
                                                                            <tr height="23"> 
                                                                                <td class="tablecell1">&nbsp;<%=langMD[0]%></td>
                                                                                <td class="fontarial" width="1">:</td>
                                                                                <td ><input type="text" name="login_id" value="<%=loginId%>" size="20"></td>
                                                                            </tr>
                                                                            <tr height="23"> 
                                                                                <td class="tablecell1">&nbsp;<%=langMD[1]%></td>
                                                                                <td class="fontarial" width="1">:</td>
                                                                                <td ><input type="text" name="fullname" value="<%=fullName%>" size="20"></td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td colspan="3">
                                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0"><tr><td height="2" background="../images/line.gif" ><img src="../images/line.gif"></td></tr></table>
                                                                                </td>
                                                                            </tr>    
                                                                            <tr> 
                                                                                <td colspan="3"><a href="javascript:cmdSearch()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('search211','','../images/search2.gif',1)"><img src="../images/search.gif" name="search211" border="0"></a></td>                                                                                
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                </tr>
                                                                <tr> 
                                                                    <td class="container"> 
                                                                        <table width="100%" cellpadding="0" cellspacing="0">
                                                                            <tr> 
                                                                                <td colspan="2">&nbsp;</td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td colspan="2">&nbsp;</td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td colspan="2"> 
                                                                                    <table width="1150" border="0" cellspacing="1" cellpadding="1">
                                                                                        <tr height="25"> 
                                                                                            <td class="tablehdr" width="20">No</td>
                                                                                            <td class="tablehdr" width="100"><%=langMD[0]%></td>
                                                                                            <td class="tablehdr" width="120"><%=langMD[6]%></td>
                                                                                            <td class="tablehdr" ><%=langMD[1]%></td>
                                                                                            <td class="tablehdr" width="700"><%=langMD[5]%></td>
                                                                                        </tr>
                                                                                        <% if ((listUser != null) && (listUser.size() > 0)) {
                for (int i = 0; i < listUser.size(); i++) {
                    User userapp = (User) listUser.get(i);

                    String celStyle = "tablecell1";
                    if (i % 2 == 0) {
                        celStyle = "tablecell";
                    }
                    
                    Vector vlist = DbUserGroup.list(0, 1, DbUserGroup.colNames[DbUserGroup.COL_USER_ID]+"="+userapp.getOID(), null);
                    String strGroup = "";
                    if(vlist != null && vlist.size() > 0){
                        try{
                            UserGroup ug = (UserGroup)vlist.get(0);
                            if(ug.getGroupID() != 0){
                                Group g = new Group();
                                g = DbGroup.fetch(ug.getGroupID());
                                strGroup = g.getGroupName();
                            }    
                        }catch(Exception e){}
                    }
                    
                    
                                                                                        %>
                                                                                        <tr> 
                                                                                            <td class="<%=celStyle%>" valign="top" align="center"><%=start + i + 1%>.</td>
                                                                                            <td class="<%=celStyle%>" valign="top" style="padding:3px;"><a href="javascript:cmdEdit('<%=userapp.getOID()%>')"><%=userapp.getLoginId()%></a></td>
                                                                                            <td class="<%=celStyle%>" valign="top" style="padding:3px;"><%=strGroup%></td>
                                                                                            <td class="<%=celStyle%>" valign="top" style="padding:3px;"><%=userapp.getFullName()%></td>
                                                                                            <td class="<%=celStyle%>" > 
                                                                                                <table width="700" border="0" cellspacing="0" cellpadding="0">
                                                                                                    <tr>
                                                                                                        <td><input type="checkbox" name="chk_all_<%=userapp.getOID()%>" value="1" onClick="setChecked('<%=userapp.getOID()%>',this)"></td>
                                                                                                        <td class="fontarial">&nbsp;<b><i><%=langMD[4]%></i></b></td>
                                                                                                    </tr>    
                                                                                                    <%
                                                                                            int loopx = 0;
                                                                                            if (segLocs != null && segLocs.size() > 0) {
                                                                                                loopx = segLocs.size() / 5;
                                                                                                if (segLocs.size() % 5 > 0) {
                                                                                                    loopx = loopx + 1;
                                                                                                }

                                                                                                Vector sgSelected = DbSegmentUser.list(0, 0, "user_id=" + userapp.getOID(), "");

                                                                                                for (int x = 0; x < loopx; x++) {
                                                                                                    int idx = 5 * x;
                                                                                                    SegmentDetail sg1 = (SegmentDetail) segLocs.get(idx);

                                                                                                    int idxn = idx + 1;
                                                                                                    SegmentDetail sg2 = new SegmentDetail();
                                                                                                    if (idxn < segLocs.size()) {
                                                                                                        sg2 = (SegmentDetail) segLocs.get(idxn);
                                                                                                    }

                                                                                                    int idxn2 = idx + 2;
                                                                                                    SegmentDetail sg3 = new SegmentDetail();
                                                                                                    if (idxn2 < segLocs.size()) {
                                                                                                        sg3 = (SegmentDetail) segLocs.get(idxn2);
                                                                                                    }

                                                                                                    int idxn3 = idx + 3;
                                                                                                    SegmentDetail sg4 = new SegmentDetail();
                                                                                                    if (idxn3 < segLocs.size()) {
                                                                                                        sg4 = (SegmentDetail) segLocs.get(idxn3);
                                                                                                    }

                                                                                                    int idxn4 = idx + 4;
                                                                                                    SegmentDetail sg5 = new SegmentDetail();
                                                                                                    if (idxn4 < segLocs.size()) {
                                                                                                        sg5 = (SegmentDetail) segLocs.get(idxn4);
                                                                                                    }

                                                                                                    %>
                                                                                                    <tr> 
                                                                                                        <td width="4%"> 
                                                                                                        <input type="checkbox" name="chk_<%=userapp.getOID() + "" + sg1.getOID()%>" value="<%=sg1.getOID()%>" <%=isChecked(sg1.getOID(), sgSelected)%>>
                                                                                                               </td>
                                                                                                        <td width="44%" nowrap>&nbsp;<%=sg1.getName()%></td>
                                                                                                        <td width="4%"> 
                                                                                                        <%if (sg2.getOID() != 0) {%>
                                                                                                        <input type="checkbox" name="chk_<%=userapp.getOID() + "" + sg2.getOID()%>" value="<%=sg2.getOID()%>" <%=isChecked(sg2.getOID(), sgSelected)%>>
                                                                                                               <%}%>
                                                                                                               </td>
                                                                                                        <td width="48%" nowrap> 
                                                                                                            <%if (sg2.getOID() != 0) {%>
                                                                                                            &nbsp;<%=sg2.getName()%> 
                                                                                                            <%}%>
                                                                                                        </td>
                                                                                                        <td width="4%"> 
                                                                                                        <%if (sg3.getOID() != 0) {%>
                                                                                                        <input type="checkbox" name="chk_<%=userapp.getOID() + "" + sg3.getOID()%>" value="<%=sg3.getOID()%>" <%=isChecked(sg3.getOID(), sgSelected)%>>
                                                                                                               <%}%>
                                                                                                               </td>
                                                                                                        <td width="48%" nowrap> 
                                                                                                            <%if (sg3.getOID() != 0) {%>
                                                                                                            &nbsp;<%=sg3.getName()%> 
                                                                                                            <%}%>
                                                                                                        </td>
                                                                                                        <td width="4%"> 
                                                                                                        <%if (sg4.getOID() != 0) {%>
                                                                                                        <input type="checkbox" name="chk_<%=userapp.getOID() + "" + sg4.getOID()%>" value="<%=sg4.getOID()%>" <%=isChecked(sg4.getOID(), sgSelected)%>>
                                                                                                               <%}%>
                                                                                                               </td>
                                                                                                        <td width="48%" nowrap> 
                                                                                                            <%if (sg4.getOID() != 0) {%>
                                                                                                            &nbsp;<%=sg4.getName()%> 
                                                                                                            <%}%>
                                                                                                        </td>
                                                                                                        <td width="4%"> 
                                                                                                        <%if (sg5.getOID() != 0) {%>
                                                                                                        <input type="checkbox" name="chk_<%=userapp.getOID() + "" + sg5.getOID()%>" value="<%=sg5.getOID()%>" <%=isChecked(sg5.getOID(), sgSelected)%>>
                                                                                                               <%}%>
                                                                                                               </td>
                                                                                                        <td width="48%" nowrap> 
                                                                                                            <%if (sg5.getOID() != 0) {%>
                                                                                                            &nbsp;<%=sg5.getName()%> 
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
                                                                                        
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td colspan="2">
                                                                                    <span class="command"> 
                                                                                        <%
            int cmd = 0;
            if ((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV) ||
                    (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)) {
                cmd = iJSPCommand;
            } else {
                if (iJSPCommand == JSPCommand.NONE || iJSPCommand == JSPCommand.LIST) {
                    cmd = JSPCommand.FIRST;
                } else {
                    cmd = JSPCommand.LIST;
                }
            }
                                                                                        %>
                                                                                        <%jspLine.setLocationImg(approot + "/images/ctr_line");
            jspLine.initDefault();
                                                                                        %>
                                                                                    <%=jspLine.drawImageListLimit(cmd, vectSize, start, recordToGet)%> </span>
                                                                                </td>
                                                                            </tr>      
                                                                            <tr> 
                                                                                <td colspan="2" height="25"></td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td colspan="2" height="25">
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
     int countx = DbHistoryUser.getCount(DbHistoryUser.colNames[DbHistoryUser.COL_TYPE] + " = " + DbHistoryUser.TYPE_USER);
     Vector historys = DbHistoryUser.list(0, max, DbHistoryUser.colNames[DbHistoryUser.COL_TYPE] + " = " + DbHistoryUser.TYPE_USER, DbHistoryUser.colNames[DbHistoryUser.COL_DATE] + " desc");
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
                                                                            <tr> 
                                                                                <td colspan="2" height="25"></td>
                                                                            </tr>
                                                                            <tr valign="middle"> 
                                                                                <td colspan="2" class="command"> 
                                                                                    <table width="25%" border="0" cellspacing="1" cellpadding="1">
                                                                                        <tr> 
                                                                                            <%if (privAdd) {%>
                                                                                            <td width="11%"><a href="javascript:addNew()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new2','','../images/new2.gif',1)"><img src="../images/new.gif" name="new2" width="71" height="22" border="0"></a></td>
                                                                                            <td nowrap width="29%">&nbsp;</td>
                                                                                            <td width="11%">&nbsp;</td>
                                                                                            <td nowrap width="29%"><a href="javascript:cmdSave()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('save21','','../images/save2.gif',1)"><img src="../images/save.gif" name="save21" border="0"></a></td>
                                                                                            <%}%>
                                                                                            <td width="13%">&nbsp;</td>
                                                                                            <td nowrap width="47%">&nbsp;</td>
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
                                                    <!-- #EndEditable --> </td>
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
<!-- #EndTemplate --></html>
