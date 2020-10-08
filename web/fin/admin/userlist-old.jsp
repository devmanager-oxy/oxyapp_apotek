
<%@ page language="java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.main.entity.*" %>
<%@ page import = "com.project.admin.*" %>
<%@ page import = "com.project.fms.session.*" %>
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
            int recordToGet = 25;
            String order = " " + DbUser.colNames[DbUser.COL_LOGIN_ID];
            String whereClause = "";
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
            int vectSize = DbUser.getCount("");
            if ((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV) ||
                    (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)) {
                start = cmdUser.actionList(iJSPCommand, start, vectSize, recordToGet);
            }

            listUser = SessEmployee.listUser(start, recordToGet, whereClause, order);

            /*** LANG ***/
            String[] langMD = {"User-ID", "Location", "Description", "Status", "Employee", "Level", "Group", "All Location","Last Update Date", "Registered Date"};
            if (lang == LANG_ID) {
                String[] langID = {"User-ID", "Lokasi", "Keterangan", "Status", "Pegawai", "Level", "Group", "Semua Lokasi", "Terakhir Diperbaharui", "Tanggal Didaftarkan"};
                langMD = langID;
            }

            Vector listEmployee = SessEmployee.listNameEmployee(0, 0, "", DbEmployee.colNames[DbEmployee.COL_NAME]);
            Vector grp = DbGroup.list(0, 0, "", DbGroup.colNames[DbGroup.COL_GROUP_NAME]);
            Vector listS = DbSegment.list(0, 0, DbSegment.colNames[DbSegment.COL_COUNT] + " = 1", null);
            Vector listSD = new Vector();
            if (listS != null && listS.size() > 0) {
                try {
                    Segment s = (Segment) listS.get(0);
                    listSD = DbSegmentDetail.list(0, 0, DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_ID] + " = " + s.getOID(), DbSegmentDetail.colNames[DbSegmentDetail.COL_NAME]);
                } catch (Exception e) {
                }
            }
            Hashtable err = new Hashtable();

            if (iJSPCommand == JSPCommand.SAVE) {
                if (listUser != null && listUser.size() > 0) {
                    for (int i = 0; i < listUser.size(); i++) {
                        SysUser appUser = (SysUser) listUser.get(i);
                        int ok = JSPRequestValue.requestInt(request, "check" + appUser.getUserId());

                        if (ok == 1) {
                            long userId = JSPRequestValue.requestLong(request, "usr" + appUser.getUserId());
                            if (userId != 0) {
                                DbSegmentUser.delUserSegment(userId); //mengapus segment yang sudah tersimpan sebelumnya

                                User usr = new User();
                                try {
                                    usr = DbUser.fetch(userId);

                                    String userName = JSPRequestValue.requestString(request, "username" + appUser.getUserId());
                                    long employeeId = JSPRequestValue.requestLong(request, "pegawai" + appUser.getUserId());
                                    int level = JSPRequestValue.requestInt(request, "level" + appUser.getUserId());
                                    long grpx = JSPRequestValue.requestLong(request, "grp" + appUser.getUserId());
                                    String userKey = JSPRequestValue.requestString(request, "user_key" + appUser.getUserId());
                                    String keterangan = JSPRequestValue.requestString(request, "keterangan" + appUser.getUserId());

                                    if ((userName == null || userName.length() <= 0) || employeeId == 0 || grpx == 0) {

                                        SessErrUser er = new SessErrUser();
                                        if (userName == null || userName.length() <= 0) {
                                            er.setUserId(false);
                                        }

                                        if (employeeId == 0) {
                                            er.setEmployee(false);
                                        }
                                        if (grpx == 0) {
                                            er.setGroup(false);
                                        }
                                        err.put("" + userId, er);

                                    } else {

                                        usr.setLoginId(userName);
                                        usr.setEmployeeId(employeeId);
                                        usr.setUserLevel(level);
                                        usr.setUserKey(userKey);
                                        usr.setDescription(keterangan);
                                        usr.setUpdateDate(new Date());
                                        try {
                                            long oid = DbUser.update(usr);
                                            if (oid != 0) {
                                                DbUserGroup.deleteByUser(oid);
                                                UserGroup ugroup = new UserGroup();
                                                try {
                                                    ugroup.setUserID(oid);
                                                    ugroup.setGroupID(grpx);
                                                    DbUserGroup.insert(ugroup);
                                                } catch (Exception e) {
                                                }

                                                DbSegmentUser.delUserSegment(oid);

                                                for (int t = 0; t < listSD.size(); t++) {

                                                    SegmentDetail sd = new SegmentDetail();
                                                    try {
                                                        sd = (SegmentDetail) listSD.get(t);
                                                    } catch (Exception e) {
                                                    }
                                                    int o = JSPRequestValue.requestInt(request, "seg" + oid + "" + sd.getOID());
                                                    if (o == 1) {
                                                        SegmentUser su = new SegmentUser();
                                                        su.setUserId(oid);
                                                        su.setSegmentId(sd.getOID());
                                                        try {
                                                            DbSegmentUser.insertExc(su);
                                                        } catch (Exception e) {
                                                        }
                                                    }
                                                }
                                            }
                                        } catch (Exception e) {
                                        }
                                    }
                                } catch (Exception e) {
                                }


                            }
                        }
                    }

                    listUser = SessEmployee.listUser(start, recordToGet, whereClause, order);
                }
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
            
            function cmdSave(){
                <%if (privUpdate) {%>                
                document.frmUser.list_command.value="<%=listJSPCommand%>";
                document.frmUser.command.value="<%=JSPCommand.SAVE%>";
                document.frmUser.action="userlist-edit.jsp";
                document.frmUser.submit();
                <%}%>
            }
            
            function setChecked(oid,val){
                 <%
            for (int y = 0; y < listUser.size(); y++) {
                SysUser appUser = (SysUser) listUser.get(y);
                 %>    
                     if(oid == '<%=appUser.getUserId()%>'){
                 <%
                for (int k = 0; k < listSD.size(); k++) {
                    SegmentDetail sd = (SegmentDetail) listSD.get(k);
                %>
                    document.frmUser.seg<%=appUser.getUserId()%><%=sd.getOID()%>.checked=val.checked;
                    
                    <%}%>
                }
                <%}%>
            }
            
            function backMenu(){
                document.frmUser.action="<%=approot%>/management/main_systemadmin.jsp";
                document.frmUser.submit();
            }
            
            function cmdListFirst(){
                document.frmUser.command.value="<%=JSPCommand.FIRST%>";
                document.frmUser.list_command.value="<%=JSPCommand.FIRST%>";
                document.frmUser.action="userlist-edit.jsp";
                document.frmUser.submit();
            }
            function cmdListPrev(){
                document.frmUser.command.value="<%=JSPCommand.PREV%>";
                document.frmUser.list_command.value="<%=JSPCommand.PREV%>";
                document.frmUser.action="userlist-edit.jsp";
                document.frmUser.submit();
            }
            
            function cmdListNext(){
                document.frmUser.command.value="<%=JSPCommand.NEXT%>";
                document.frmUser.list_command.value="<%=JSPCommand.NEXT%>";
                document.frmUser.action="userlist-edit.jsp";
                document.frmUser.submit();
            }
            function cmdListLast(){
                document.frmUser.command.value="<%=JSPCommand.LAST%>";
                document.frmUser.list_command.value="<%=JSPCommand.LAST%>";
                document.frmUser.action="userlist-edit.jsp";
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
                                                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr>
                                                                    <td class="container">&nbsp;</td>
                                                                </tr>                                                               
                                                                <tr>
                                                                    <td class="container">
                                                                        <table border="0" cellpadding="0" cellspacing="2" width="1000">
                                                                            <tr height="2">
                                                                                <td width="3%"></td>
                                                                                <td width="120"></td>
                                                                                <td width="5"></td>
                                                                                <td width="25%"></td>
                                                                                <td width="120"></td>
                                                                                <td width="5"></td>
                                                                                <td >&nbsp;</td>                                                                                
                                                                                <td width="50"></td>         
                                                                            </tr>                                                                             
                                                                            <%
            for (int i = 0; i < listUser.size(); i++) {
                SysUser appUser = (SysUser) listUser.get(i);
                Vector vx = DbUserGroup.list(0, 1, DbUserGroup.colNames[DbUserGroup.COL_USER_ID] + "=" + appUser.getUserId(), "");
                UserGroup ug = new UserGroup();
                if (vx != null && vx.size() > 0) {
                    ug = (UserGroup) vx.get(0);
                }




                Hashtable hashSegment = DbSegmentUser.userSegement(appUser.getUserId());

                boolean userId = true;
                boolean empErr = true;
                boolean grpErr = true;

                SessErrUser eu = new SessErrUser();
                try {
                    eu = (SessErrUser) err.get("" + appUser.getUserId());
                    if (eu != null) {
                        if (eu.isUserId() == false) {
                            userId = false;
                        }
                        if (eu.isEmployee() == false) {
                            empErr = false;
                        }
                        if (eu.isGroup() == false) {
                            grpErr = false;
                        }
                    }
                } catch (Exception e) {
                    userId = true;
                    empErr = true;
                    grpErr = true;
                }
                long grpId = ug.getGroupID();

                if (iJSPCommand == JSPCommand.SAVE && (userId == false || empErr == false || grpErr == false)) {

                    appUser.setLoginId(JSPRequestValue.requestString(request, "username" + appUser.getUserId()));
                    appUser.setEmployeeId(JSPRequestValue.requestLong(request, "pegawai" + appUser.getUserId()));
                    appUser.setLevel(JSPRequestValue.requestInt(request, "level" + appUser.getUserId()));
                    grpId = JSPRequestValue.requestLong(request, "grp" + appUser.getUserId());
                    appUser.setUserKey(JSPRequestValue.requestString(request, "user_key" + appUser.getUserId()));
                    appUser.setDescription(JSPRequestValue.requestString(request, "keterangan" + appUser.getUserId()));

                }

                                                                            %>
                                                                            <input type="hidden" name="usr<%=appUser.getUserId()%>" value="<%=appUser.getUserId()%>" size="15">
                                                                            <tr height="20">
                                                                                <td class="tablehdr" align="center"><%=(start + i + 1)%></td>
                                                                                <td class="tablecell1" >&nbsp;&nbsp;<%=langMD[0]%></td>                                                                                
                                                                                <td class="fontarial" align="center">:</td>
                                                                                <td ><input type="text" name="username<%=appUser.getUserId()%>" value="<%=appUser.getLoginId()%>" size="15">&nbsp;&nbsp;<%if (userId == false) {%><font face="arial" color="#FF0000"><i>Data required<i></font><%}%> </td>
                                                                                <td class="tablecell1" >&nbsp;&nbsp;<%=langMD[4]%></td>
                                                                                <td align="center">:</td>
                                                                                <td >
                                                                                    <select name="pegawai<%=appUser.getUserId() %>" class="fontarial">
                                                                                        <option value="0" selected>-select employee-</option>
                                                                                        <%if (listEmployee != null && listEmployee.size() > 0) {
                                                                                    for (int x = 0; x < listEmployee.size(); x++) {
                                                                                        Emp empx = (Emp) listEmployee.get(x);
                                                                                        String selected = "";
                                                                                        if (empx.getEmployeeId() == appUser.getEmployeeId()) {
                                                                                            selected = "selected";
                                                                                        }
                                                                                        %>
                                                                                        <option value="<%=empx.getEmployeeId()%>" <%=selected%> ><%=empx.getName()%></option>
                                                                                        <%}
                                                                                }%>
                                                                                    </select>   
                                                                                    &nbsp;&nbsp;<%if (empErr == false) {%><font face="arial" color="#FF0000"><i>Data required<i></font><%}%>
                                                                                </td>     
                                                                                <td align="center" class="fontarial">Saved ?</td>
                                                                            </tr>  
                                                                            <tr height="20">
                                                                                <td align="center">&nbsp;</td>
                                                                                <td class="tablecell1" >&nbsp;&nbsp;<%=langMD[5]%></td>                                                                                
                                                                                <td class="fontarial" align="center">:</td>
                                                                                <td >
                                                                                    <select name="level<%=appUser.getUserId()%>" class="fontarial">
                                                                                        <%for (int d = 0; d < DbUser.levelStr.length; d++) {%>
                                                                                        <option <%if (d == appUser.getLevel()) {%>selected<%}%> value="<%=d%>"><%=DbUser.levelStr[d]%></option>
                                                                                        <%}%>
                                                                                    </select>
                                                                                </td>
                                                                                <td class="tablecell1" >&nbsp;&nbsp;<%=langMD[6]%></td>
                                                                                <td align="center">:</td>
                                                                                <td >
                                                                                    <select name="grp<%=appUser.getUserId()%>">
                                                                                        <option value="0" <%if (0 == ug.getGroupID()) {%>selected<%}%>>- select group -</option>
                                                                                        <%if (grp != null && grp.size() > 0) {
                                                                                    for (int d = 0; d < grp.size(); d++) {
                                                                                        Group g = (Group) grp.get(d);
                                                                                        %>
                                                                                        <option value="<%=g.getOID()%>" <%if (g.getOID() == grpId) {%>selected<%}%>><%=g.getGroupName()%></option>
                                                                                        <%}
                                                                                }%>
                                                                                    </select> 
                                                                                    &nbsp;&nbsp;<%if (grpErr == false) {%><font face="arial" color="#FF0000"><i>Data required<i></font><%}%>
                                                                                </td>                                                                                
                                                                                <td align="center" class="fontarial"><input type="checkbox" name="check<%=appUser.getUserId()%>" value="1"></td>
                                                                            </tr>                                                                               
                                                                            <tr height="20">
                                                                                <td align="center">&nbsp;</td>
                                                                                <td class="tablecell1" >&nbsp;&nbsp;User Key</td>                                                                                
                                                                                <td class="fontarial" align="center">:</td>
                                                                                <td ><input type="text" name="user_key<%=appUser.getUserId()%>" value="<%=appUser.getUserKey() %>" size="15"></td>
                                                                                <td class="tablecell1" >&nbsp;&nbsp;Keterangan</td>
                                                                                <td align="center">:</td>
                                                                                <td ><input type="text" name="keterangan<%=appUser.getUserId()%>" value="<%=appUser.getDescription()%>" size="15"></td>
                                                                                <td align="center" class="fontarial"></td>
                                                                            </tr> 
                                                                             <tr height="20">
                                                                                <td align="center">&nbsp;</td>
                                                                                <td class="tablecell1" >&nbsp;&nbsp;<%=langMD[8]%></td>                                                                                
                                                                                <td class="fontarial" align="center">:</td>
                                                                                <td >&nbsp;</td>
                                                                                <td class="tablecell1" >&nbsp;&nbsp;<%=langMD[9]%></td>
                                                                                <td align="center">:</td>
                                                                                <td >&nbsp;</td>
                                                                                <td align="center" class="fontarial"></td>
                                                                            </tr> 
                                                                            <tr height="20">
                                                                                <td align="center">&nbsp;</td>
                                                                                <td class="tablecell1" valign="top">&nbsp;&nbsp;<%=langMD[1]%></td>                                                                                
                                                                                <td class="fontarial" align="center">:</td>
                                                                                <td colspan="5">
                                                                                    <%
                                                                                if (listSD != null && listSD.size() > 0) {
                                                                                    %>
                                                                                    <table width="700" border="0" cellpadding="0" cellspacing="0">
                                                                                        <%
                                                                                        int x = 0;
                                                                                        boolean ok = true;
                                                                                        while (ok) {
                                                                                            for (int t = 0; t < 4; t++) {
                                                                                                SegmentDetail sd = new SegmentDetail();
                                                                                                boolean selected = false;
                                                                                                try {
                                                                                                    sd = (SegmentDetail) listSD.get(x);
                                                                                                    try {
                                                                                                        SegmentDetail sdx = (SegmentDetail) hashSegment.get("" + sd.getOID());
                                                                                                        if (sdx != null && sdx.getOID() != 0) {
                                                                                                            selected = true;
                                                                                                        }
                                                                                                    } catch (Exception e) {
                                                                                                        System.out.println("exc : " + e.toString());
                                                                                                    }
                                                                                                } catch (Exception e) {
                                                                                                    ok = false;
                                                                                                    sd = new SegmentDetail();
                                                                                                    break;
                                                                                                }
                                                                                                if (t == 0) {
                                                                                        %>
                                                                                        <tr>
                                                                                            <%}%>
                                                                                            <td width="5"><input type="checkbox" name="seg<%=appUser.getUserId()%><%=sd.getOID()%>" value="1" <%if (selected) {%> checked<%}%> ></td>
                                                                                            <td class="fontarial"><%=sd.getName()%></td>                                                                                                                                                                    
                                                                                            <%if (t == 3) {
                                                                                            %>
                                                                                        </tr>
                                                                                        <%}%>
                                                                                        <%
                                                                                                x++;
                                                                                            }
                                                                                        }%>
                                                                                        <tr>                                                                                            
                                                                                            <td width="5"><input type="checkbox" name="all" value="1" onClick="setChecked('<%=appUser.getUserId()%>',this)"></td>                                                                                            
                                                                                            <td class="fontarial"><%=langMD[7]%></td>     
                                                                                        </tr>
                                                                                    </table>
                                                                                    <%}%>              
                                                                                </td>
                                                                            </tr> 
                                                                            <tr height="15">
                                                                                <td align="center" colspan="8"></td>                                                                                
                                                                            </tr> 
                                                                            <tr height="2">
                                                                                <td align="center"></td>
                                                                                <td bgcolor="#609836" colspan="7"></td>                                                                                
                                                                            </tr> 
                                                                            <tr height="25">
                                                                                <td align="center" colspan="8"></td>                                                                                
                                                                            </tr> 
                                                                            <%}%>
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
                                                                                <td class="container" colspan="2">
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
                                                                            <tr valign="middle"> 
                                                                                <td colspan="2" class="command"> &nbsp;</td>
                                                                            </tr>    
                                                                            <tr valign="middle"> 
                                                                                <td colspan="2" class="command"> 
                                                                                    <table width="25%" border="0" cellspacing="1" cellpadding="1">
                                                                                        <tr> 
                                                                                            <% if (privAdd) {%>
                                                                                            <td ><a href="javascript:cmdSave()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new2','','../images/save2.gif',1)"><img src="../images/save.gif" name="new2" height="22" border="0"></a></td>
                                                                                            <td nowrap width="25">&nbsp;</td>
                                                                                            <td ><a href="javascript:cmdDelete()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('del2','','../images/del2.gif',1)"><img src="../images/del.gif" name="del2" height="22" border="0"></a></td>
                                                                                            <td >&nbsp;</td>
                                                                                            <%} else {%>
                                                                                            <td width="11%">&nbsp;</td>
                                                                                            <td nowrap width="29%">&nbsp;</td>
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
