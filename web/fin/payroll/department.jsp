
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.main.entity.*" %>
<%@ page import = "com.project.main.db.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "com.project.*" %>
<%@ include file = "../main/javainit.jsp" %>
<% int appObjCode = 1; %>
<%@ include file = "../main/check.jsp" %>
<%
            boolean priv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_COMPANY);
            boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_COMPANY, AppMenu.PRIV_VIEW);
            boolean privUpdate = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_COMPANY, AppMenu.PRIV_UPDATE);
            boolean privAdd = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_COMPANY, AppMenu.PRIV_ADD);
            boolean privDelete = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_COMPANY, AppMenu.PRIV_DELETE);
%>
<!-- Jsp Block -->
<%!
    public String drawList(int iJSPCommand, JspDepartment frmObject, Department objEntity, Vector objectClass,
            long departmentId, String[] lang) {
        JSPList cmdist = new JSPList();
        cmdist.setAreaWidth("100%");
        cmdist.setListStyle("listgen");
        cmdist.setTitleStyle("tablehdr");
        cmdist.setCellStyle("tablecell");
        cmdist.setCellStyle1("tablecell1");
        cmdist.setHeaderStyle("tablehdr");
        //cmdist.addHeader("Code","10%");
        cmdist.addHeader(lang[0], "35%");
        cmdist.addHeader(lang[1], "20%");
        cmdist.addHeader(lang[2], "35%");
        cmdist.addHeader(lang[3], "10%");

        cmdist.setLinkRow(0);
        cmdist.setLinkSufix("");
        Vector lstData = cmdist.getData();
        Vector lstLinkData = cmdist.getLinkData();
        Vector rowx = new Vector(1, 1);
        cmdist.reset();
        int index = -1;

        for (int i = 0; i < objectClass.size(); i++) {
            Department department = (Department) objectClass.get(i);
            String str = "";
            if (department.getLevel() == 1) {
                str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
            } else if (department.getLevel() == 2) {
                str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
            } else if (department.getLevel() == 3) {
                str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
            }

            rowx = new Vector();
            if (departmentId == department.getOID()) {
                index = i;
            }

            /*if(index == i && (iJSPCommand == JSPCommand.EDIT || iJSPCommand == JSPCommand.ASK)){
            rowx.add("<input type=\"text\" name=\""+frmObject.colNames[JspDepartment.JSP_NAME] +"\" value=\""+department.getName()+"\" class=\"formElemen\" size=\"35\">");
            rowx.add("<input type=\"text\" name=\""+frmObject.colNames[JspDepartment.JSP_DESCRIPTION] +"\" value=\""+department.getDescription()+"\" class=\"formElemen\" size=\"45\">");
            }else{*/
            if (department.getLevel() == 0) {
                rowx.add("<a href=\"javascript:cmdEdit('" + String.valueOf(department.getOID()) + "')\"><b>" + str + department.getCode() + " - " + department.getName() + "</b></a>");
            } else {
                rowx.add("<a href=\"javascript:cmdEdit('" + String.valueOf(department.getOID()) + "')\">" + str + department.getCode() + " - " + department.getName() + "</a>");
            }
            rowx.add(DbDepartment.strLevel[department.getLevel()]);
            rowx.add(department.getDescription());
            rowx.add(department.getType());
            //} 

            lstData.add(rowx);
        }

        rowx = new Vector();

        /*if(iJSPCommand == JSPCommand.ADD || (iJSPCommand == JSPCommand.SAVE && frmObject.errorSize() > 0)){ 
        rowx.add("<input type=\"text\" name=\""+frmObject.colNames[JspDepartment.JSP_NAME] +"\" value=\""+objEntity.getName()+"\" class=\"formElemen\" size=\"35\">");
        rowx.add("<input type=\"text\" name=\""+frmObject.colNames[JspDepartment.JSP_DESCRIPTION] +"\" value=\""+objEntity.getDescription()+"\" class=\"formElemen\" size=\"45\">");
        }
        lstData.add(rowx);
        */
        return cmdist.draw(index);
    }

%>
<%
            int iJSPCommand = JSPRequestValue.requestCommand(request);
            int start = JSPRequestValue.requestInt(request, "start");
            int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
            long oidDepartment = JSPRequestValue.requestLong(request, "hidden_department_id");

            /*variable declaration*/
            int recordToGet = 1000;
            String msgString = "";
            int iErrCode = JSPMessage.NONE;
            String whereClause = "";
            String orderClause = "code";

            CmdDepartment cmdDepartment = new CmdDepartment(request);
            JSPLine ctrLine = new JSPLine();
            Vector listDepartment = new Vector(1, 1);

            /*switch statement */
            iErrCode = cmdDepartment.action(iJSPCommand, oidDepartment);
            /* end switch*/
            JspDepartment jspDepartment = cmdDepartment.getForm();

            /*count list All Department*/
            int vectSize = DbDepartment.getCount(whereClause);

            /*switch list Department*/
            if ((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV) ||
                    (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)) {
                start = cmdDepartment.actionList(iJSPCommand, start, vectSize, recordToGet);
            }
            /* end switch list*/

            Department department = cmdDepartment.getDepartment();
            msgString = cmdDepartment.getMessage();

            /* get record to display */
            listDepartment = DbDepartment.list(start, recordToGet, whereClause, orderClause);

            /*handle condition if size of record to display = 0 and start > 0 	after delete*/
            if (listDepartment.size() < 1 && start > 0) {
                if (vectSize - recordToGet > recordToGet) {
                    start = start - recordToGet;
                } //go to JSPCommand.PREV
                else {
                    start = 0;
                    iJSPCommand = JSPCommand.FIRST;
                    prevJSPCommand = JSPCommand.FIRST; //go to JSPCommand.FIRST
                }
                listDepartment = DbDepartment.list(start, recordToGet, whereClause, orderClause);
            }

            Vector deps = DbDepartment.list(0, 0, "", "code");

            /*** LANG ***/
            String[] langMD = {"Code - Name", "Level", "Description", "Type", //0-3
                "EDITOR", "Code", "Name", "Level", "Reference", "Description", "Type"}; //4-10

            String[] langNav = {"Masterdata", "Department"};

            if (lang == LANG_ID) {
                String[] langID = {"Kode - Nama", "Level", "Keterangan", "Tipe", //0-3
                    "EDITOR", "Kode", "Nama", "Level", "Referensi", "Keterangan", "Tipe"}; //4-10
                langMD = langID;

                String[] navID = {"Data Induk", "Departemen"};
                langNav = navID;
            }

%>
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
            
            function cmdAdd(){
                document.frmdepartment.hidden_department_id.value="0";
                document.frmdepartment.command.value="<%=JSPCommand.ADD%>";
                document.frmdepartment.prev_command.value="<%=prevJSPCommand%>";
                document.frmdepartment.action="department.jsp";
                document.frmdepartment.submit();
            }
            
            function cmdAsk(oidDepartment){
                document.frmdepartment.hidden_department_id.value=oidDepartment;
                document.frmdepartment.command.value="<%=JSPCommand.ASK%>";
                document.frmdepartment.prev_command.value="<%=prevJSPCommand%>";
                document.frmdepartment.action="department.jsp";
                document.frmdepartment.submit();
            }
            
            function cmdConfirmDelete(oidDepartment){
                document.frmdepartment.hidden_department_id.value=oidDepartment;
                document.frmdepartment.command.value="<%=JSPCommand.DELETE%>";
                document.frmdepartment.prev_command.value="<%=prevJSPCommand%>";
                document.frmdepartment.action="department.jsp";
                document.frmdepartment.submit();
            }
            
            function cmdSave(){
                document.frmdepartment.command.value="<%=JSPCommand.SAVE%>";
                document.frmdepartment.prev_command.value="<%=prevJSPCommand%>";
                document.frmdepartment.action="department.jsp";
                document.frmdepartment.submit();
            }
            
            function cmdEdit(oidDepartment){
                <%if (privUpdate) {%>
                document.frmdepartment.hidden_department_id.value=oidDepartment;
                document.frmdepartment.command.value="<%=JSPCommand.EDIT%>";
                document.frmdepartment.prev_command.value="<%=prevJSPCommand%>";
                document.frmdepartment.action="department.jsp";
                document.frmdepartment.submit();
                <%}%>
            }
            
            function cmdCancel(oidDepartment){
                document.frmdepartment.hidden_department_id.value=oidDepartment;
                document.frmdepartment.command.value="<%=JSPCommand.EDIT%>";
                document.frmdepartment.prev_command.value="<%=prevJSPCommand%>";
                document.frmdepartment.action="department.jsp";
                document.frmdepartment.submit();
            }
            
            function cmdBack(){
                document.frmdepartment.command.value="<%=JSPCommand.BACK%>";
                document.frmdepartment.action="department.jsp";
                document.frmdepartment.submit();
            }
            
            function cmdListFirst(){
                document.frmdepartment.command.value="<%=JSPCommand.FIRST%>";
                document.frmdepartment.prev_command.value="<%=JSPCommand.FIRST%>";
                document.frmdepartment.action="department.jsp";
                document.frmdepartment.submit();
            }
            
            function cmdListPrev(){
                document.frmdepartment.command.value="<%=JSPCommand.PREV%>";
                document.frmdepartment.prev_command.value="<%=JSPCommand.PREV%>";
                document.frmdepartment.action="department.jsp";
                document.frmdepartment.submit();
            }
            
            function cmdListNext(){
                document.frmdepartment.command.value="<%=JSPCommand.NEXT%>";
                document.frmdepartment.prev_command.value="<%=JSPCommand.NEXT%>";
                document.frmdepartment.action="department.jsp";
                document.frmdepartment.submit();
            }
            
            function cmdListLast(){
                document.frmdepartment.command.value="<%=JSPCommand.LAST%>";
                document.frmdepartment.prev_command.value="<%=JSPCommand.LAST%>";
                document.frmdepartment.action="department.jsp";
                document.frmdepartment.submit();
            }
            
            //-------------- script form image -------------------
            
            function cmdDelPict(oidDepartment){
                document.frmimage.hidden_department_id.value=oidDepartment;
                document.frmimage.command.value="<%=JSPCommand.POST%>";
                document.frmimage.action="department.jsp";
                document.frmimage.submit();
            }
            
            //-------------- script control line -------------------
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
            
        </script>
        <script language="JavaScript">
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
                  <%@ include file="../calendar/calendarframe.jsp"%>
                                            <!-- #EndEditable -->
                                        </td>
                                        <td width="100%" valign="top"> 
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                <tr> 
                                                    <td class="title"><!-- #BeginEditable "title" -->
                                           <%
            String navigator = "<font class=\"lvl1\">" + langNav[0] + "</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">" + langNav[1] + "</span></font>";
                                           %>
                                           <%@ include file="../main/navigator.jsp"%>
                                                    <!-- #EndEditable --></td>
                                                </tr>
                                                <!--tr> 
                      <td><img src="<%=approot%>/images/title-sp.gif" width="584" height="1"></td> 
                                                </tr-->
                                                <tr> 
                                                    <td><!-- #BeginEditable "content" --> 
                                                        <form name="frmdepartment" method ="post" action="">
                                                            <input type="hidden" name="command" value="<%=iJSPCommand%>">
                                                            <input type="hidden" name="vectSize" value="<%=vectSize%>">
                                                            <input type="hidden" name="start" value="<%=start%>">
                                                            <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                                                            <input type="hidden" name="hidden_department_id" value="<%=oidDepartment%>">
                                                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                            
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr>
                                                                    <td class="container">
                                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="8"  colspan="3"> 
                                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="8" valign="middle" colspan="3" class="comment"></td>
                                                                                        </tr>
                                                                                        <%
            try {
                                                                                        %>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="22" valign="middle" colspan="3"> 
                                                                                                <table width="87%" border="0" cellspacing="0" cellpadding="0">
                                                                                                    <tr> 
                                                                                                        <td class="boxed1" nowrap><%= drawList(iJSPCommand, jspDepartment, department, listDepartment, oidDepartment, langMD)%></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <%
            } catch (Exception exc) {
            }%>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="8" align="left" colspan="3" class="command" valign="top"> 
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
            ctrLine.setFirstImage("<img name=\"Image23x\" border=\"0\" src=\"" + approot + "/images/first.gif\" alt=\"First\">");
            ctrLine.setPrevImage("<img name=\"Image24x\" border=\"0\" src=\"" + approot + "/images/prev.gif\" alt=\"Prev\">");
            ctrLine.setNextImage("<img name=\"Image25x\" border=\"0\" src=\"" + approot + "/images/next.gif\" alt=\"Next\">");
            ctrLine.setLastImage("<img name=\"Image26x\" border=\"0\" src=\"" + approot + "/images/last.gif\" alt=\"Last\">");

            ctrLine.setFirstOnMouseOver("MM_swapImage('Image23x','','" + approot + "/images/first2.gif',1)");
            ctrLine.setPrevOnMouseOver("MM_swapImage('Image24x','','" + approot + "/images/prev2.gif',1)");
            ctrLine.setNextOnMouseOver("MM_swapImage('Image25x','','" + approot + "/images/next2.gif',1)");
            ctrLine.setLastOnMouseOver("MM_swapImage('Image26x','','" + approot + "/images/last2.gif',1)");
                                                                                                    %>
                                                                                            <%=ctrLine.drawImageListLimit(cmd, vectSize, start, recordToGet)%> </span> </td>
                                                                                        </tr>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="15" valign="middle" colspan="3">&nbsp;</td>
                                                                                        </tr>
                                                                                        <%if (iJSPCommand != JSPCommand.ADD && iJSPCommand != JSPCommand.EDIT && iJSPCommand != JSPCommand.ASK && iErrCode == 0) {%>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="22" valign="middle" colspan="3">
                                                                                                <%if (privAdd) {%>
                                                                                                    <a href="javascript:cmdAdd()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new21','','../images/new2.gif',1)"><img src="../images/new.gif" name="new21" width="71" height="22" border="0"></a>
                                                                                                <%}%>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <%}%>
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                            <%if (iJSPCommand == JSPCommand.ADD || iJSPCommand == JSPCommand.EDIT || iJSPCommand == JSPCommand.ASK || iErrCode != 0) {%>
                                                                            <tr align="left" valign="top" >
                                                                                <td colspan="3" class="command">
                                                                                    <table width="100%" border="0" cellspacing="1" cellpadding="0">
                                                                                        <tr>
                                                                                            <td width="9%">&nbsp;</td>
                                                                                            <td width="91%">&nbsp;</td>
                                                                                        </tr>
                                                                                        <tr>
                                                                                            <td width="9%"><b><%=langMD[4]%></b></td>
                                                                                            <td width="91%">&nbsp;</td>
                                                                                        </tr>
                                                                                        <tr>
                                                                                            <td width="9%">&nbsp;</td>
                                                                                            <td width="91%">&nbsp;</td>
                                                                                        </tr>
                                                                                        <tr> 
                                                                                            <td width="9%"><%=langMD[5]%></td>
                                                                                            <td width="91%"> 
                                                                                                <input type="text" name="<%=JspDepartment.colNames[JspDepartment.JSP_CODE]%>" size="10" maxlength="7" value="<%=department.getCode()%>">
                                                                                            * <%= jspDepartment.getErrorMsg(JspDepartment.JSP_CODE) %></td>
                                                                                        </tr>
                                                                                        <tr> 
                                                                                            <td width="9%"><%=langMD[6]%></td>
                                                                                            <td width="91%"> 
                                                                                                <input type="text" name="<%=JspDepartment.colNames[JspDepartment.JSP_NAME]%>" size="45" value="<%=department.getName()%>">
                                                                                            * <%= jspDepartment.getErrorMsg(JspDepartment.JSP_NAME) %></td>
                                                                                        </tr>
                                                                                        <tr>
                                                                                            <td width="9%"><%=langMD[7]%></td>
                                                                                            <td width="91%"> 
                                                                                                <select name="<%=JspDepartment.colNames[JspDepartment.JSP_LEVEL]%>">
                                                                                                    <%for (int i = 0; i < DbDepartment.strLevel.length; i++) {%>	
                                                                                                    <option value="<%=i%>" <%if (department.getLevel() == i) {%>selected<%}%>><%=DbDepartment.strLevel[i]%></option>
                                                                                                    <%}%>
                                                                                                </select>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr>
                                                                                            <td width="9%"><%=langMD[8]%></td>
                                                                                            <td width="91%"> 
                                                                                                <select name="<%=JspDepartment.colNames[JspDepartment.JSP_REF_ID]%>">
                                                                                                    <option value="0">None</option>	
                                                                                                    <%
    if (deps != null && deps.size() > 0) {
        for (int i = 0; i < deps.size(); i++) {
            Department d = (Department) deps.get(i);
            String str = "";
            if (d.getLevel() == 1) {
                str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
            } else if (d.getLevel() == 2) {
                str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
            } else if (d.getLevel() == 3) {
                str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
            }
                                                                                                    %>
                                                                                                    <option value="<%=d.getOID()%>" <%if (department.getRefId() == d.getOID()) {%>selected<%}%>><%=str + d.getCode() + " - " + d.getName()%></option>
                                                                                                    <%}
    }%>
                                                                                                </select>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr>
                                                                                            <td width="9%"><%=langMD[9]%></td>
                                                                                            <td width="91%"> 
                                                                                                <textarea name="<%=JspDepartment.colNames[JspDepartment.JSP_DESCRIPTION]%>" cols="120" rows="2"><%=department.getDescription()%></textarea>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr> 
                                                                                            <td width="9%"><%=langMD[10]%></td>
                                                                                            <td width="91%"> 
                                                                                                <select name="<%=JspDepartment.colNames[JspDepartment.JSP_TYPE]%>">
                                                                                                    <%try {
        for (int i = 0; i < I_Project.accLevel.length; i++) {
                                                                                                    %>
                                                                                                    <option value="<%=I_Project.accLevel[i]%>" <%if (department.getType().equals(I_Project.accLevel[i])) {%>selected<%}%>><%=I_Project.accLevel[i]%></option>
                                                                                                    <%}

    } catch (Exception e) {
        out.println("exception ini .." + e.toString());
    }%>
                                                                                                </select>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr>
                                                                                            <td width="9%">&nbsp;</td>
                                                                                            <td width="91%">&nbsp;</td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                            <%}%>
                                                                            <tr align="left" valign="top" > 
                                                                                <td colspan="3" class="command"> 
                                                                                    <%
            ctrLine.setLocationImg(approot + "/images/ctr_line");
            ctrLine.initDefault();
            ctrLine.setTableWidth("80%");
            String scomDel = "javascript:cmdAsk('" + oidDepartment + "')";
            String sconDelCom = "javascript:cmdConfirmDelete('" + oidDepartment + "')";
            String scancel = "javascript:cmdEdit('" + oidDepartment + "')";
            ctrLine.setBackCaption("Back to List");
            ctrLine.setJSPCommandStyle("buttonlink");
            ctrLine.setDeleteCaption("Delete");

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
                                                                                    %>
                                                                                    <%if (iJSPCommand == JSPCommand.ADD || iJSPCommand == JSPCommand.EDIT || iJSPCommand == JSPCommand.ASK || iErrCode != 0) {%>
                                                                                    <%= ctrLine.drawImageOnly(iJSPCommand, iErrCode, msgString)%> 
                                                                                    <%}%>
                                                                                </td>
                                                                            </tr>
                                                                            <tr align="left" valign="top" > 
                                                                                <td colspan="3" class="command">&nbsp; </td>
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
