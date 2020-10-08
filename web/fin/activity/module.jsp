
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.main.entity.*" %>
<%@ page import = "com.project.fms.activity.*" %>
<%@ include file = "../main/javainit.jsp" %>
<% int appObjCode = 1;%>
<%@ include file = "../main/check.jsp" %>
<%
            boolean priv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_WORKPLAN);
            boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_WORKPLAN, AppMenu.PRIV_VIEW);
            boolean privUpdate = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_WORKPLAN, AppMenu.PRIV_UPDATE);
            boolean privAdd = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_WORKPLAN, AppMenu.PRIV_ADD);
            boolean privDelete = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_WORKPLAN, AppMenu.PRIV_DELETE);

%>
<!-- Jsp Block -->
<%!
    public String drawList(Vector objectClass, long moduleId, boolean isOpen) {
        JSPList cmdist = new JSPList();
        cmdist.setAreaWidth("100%");
        cmdist.setListStyle("listgen");
        cmdist.setTitleStyle("tablehdr");
        cmdist.setCellStyle("tablecell");
        cmdist.setCellStyle1("tablecell1");
        cmdist.setHeaderStyle("tablehdr");
        //cmdist.addHeader("Parent Id","11%");
        cmdist.addHeader("Code", "10%");
        cmdist.addHeader("Description", "15%");
        cmdist.addHeader("Level", "3%");

        cmdist.addHeader("Parent", "15%");
        cmdist.addHeader("Output and Deliverable", "15%");
        cmdist.addHeader("Performance Indicator", "15%");
        cmdist.addHeader("Assumtion and Risk", "15%");
        cmdist.addHeader("Position <br>Level", "5%");
        cmdist.addHeader("Type", "7%");

        if (isOpen) {
            cmdist.setLinkRow(0);
        } else {
            cmdist.setLinkRow(-1);
        }

        cmdist.setLinkSufix("");
        Vector lstData = cmdist.getData();
        Vector lstLinkData = cmdist.getLinkData();
        cmdist.setLinkPrefix("javascript:cmdEdit('");
        cmdist.setLinkSufix("')");
        cmdist.reset();
        int index = -1;

        for (int i = 0; i < objectClass.size(); i++) {
            Module module = (Module) objectClass.get(i);
            Vector rowx = new Vector();
            if (moduleId == module.getOID()) {
                index = i;
            }

            //rowx.add(String.valueOf(module.getParentId()));
            String sb = "";
            if (module.getLevel().equals("S")) {
                //sb = "xxx";//&nbsp;&nbsp;&nbsp;";
                sb = "&nbsp;&nbsp;&nbsp;&nbsp;";
            } else if (module.getLevel().equals("H")) {
                //sb = "xxxxxx";//"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                sb = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
            } else if (module.getLevel().equals("A")) {
                //sb = "xxxxxxxxx";//"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                sb = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
            } else if (module.getLevel().equals("SA")) {
                //sb = "xxxxxxxxx";//"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                sb = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
            } else if (module.getLevel().equals("SSA")) {
                //sb = "xxxxxxxxx";//"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                sb = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
            }

            //rowx.add(sb+((module.getLevel().equals("M")) ? "<b><u>"+module.getCode()+"</u></b>" : module.getCode()));
            rowx.add(sb + ((module.getLevel().equals("M")) ? "" + module.getCode() + "" : module.getCode()));



            //rowx.add(((module.getLevel().equals("M")) ? "<b>"+getSubstring(module.getDescription())+"</b>" : getSubstring(module.getDescription())));
            //rowx.add("<div align=\"center\">"+((module.getLevel().equals("M")) ? "<b>"+module.getLevel()+"</b>" : module.getLevel())+"</div>");
            rowx.add(((module.getLevel().equals("M")) ? "" + getSubstring(module.getDescription()) + "" : getSubstring(module.getDescription())));
            rowx.add("<div align=\"center\">" + ((module.getLevel().equals("M")) ? "" + module.getLevel() + "" : module.getLevel()) + "</div>");

            Module m = new Module();
            m.setDescription("-");
            if (module.getParentId() != 0) {
                try {
                    m = DbModule.fetchExc(module.getParentId());
                } catch (Exception e) {
                }
            }
            //rowx.add(((module.getLevel().equals("M")) ? "<b>"+getSubstring(m.getDescription())+"</b>" : getSubstring(module.getDescription())));
            rowx.add(((module.getLevel().equals("M")) ? "" + getSubstring(m.getDescription()) + "" : getSubstring(module.getDescription())));

            //rowx.add(((module.getLevel().equals("M")) ? "<b>"+getSubstring(module.getOutputDeliver())+"</b>" : getSubstring(module.getOutputDeliver())));
            rowx.add(((module.getLevel().equals("M")) ? "" + getSubstring(module.getOutputDeliver()) + "" : getSubstring(module.getOutputDeliver())));

            //rowx.add(((module.getLevel().equals("M")) ? "<b>"+getSubstring(module.getPerformIndicator())+"</b>" : getSubstring(module.getPerformIndicator())));
            rowx.add(((module.getLevel().equals("M")) ? "" + getSubstring(module.getPerformIndicator()) + "" : getSubstring(module.getPerformIndicator())));

            //rowx.add(((module.getLevel().equals("M")) ? "<b>"+getSubstring(module.getAssumRisk())+"</b>" : getSubstring(module.getAssumRisk())));
            rowx.add(((module.getLevel().equals("M")) ? "" + getSubstring(module.getAssumRisk()) + "" : getSubstring(module.getAssumRisk())));

            //rowx.add(((module.getLevel().equals("M")) ? "<b>"+module.getStatus()+"</b>" : module.getStatus()));
            rowx.add(((module.getLevel().equals("M")) ? "" + module.getPositionLevel() + "" : module.getPositionLevel()));

            //rowx.add(((module.getLevel().equals("M")) ? "<b>"+module.getType()+"</b>" : module.getType()));
            rowx.add(((module.getLevel().equals("M")) ? "" + module.getType() + "" : module.getType()));

            lstData.add(rowx);
            lstLinkData.add(String.valueOf(module.getOID()));
        }

        return cmdist.draw(index);
    }

    public String getSubstring(String s) {
        if (s.length() > 25) {
            s = "<a href=\"#\" title=\"" + s + "\"><font color=\"black\">" + s.substring(0, 23) + "...</font></a>";
        }
        return s;
    }

%>
<%
            int iJSPCommand = JSPRequestValue.requestCommand(request);
            int start = JSPRequestValue.requestInt(request, "start");
            int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
            long oidModule = JSPRequestValue.requestLong(request, "hidden_module_id");
            long activityPeriodId = JSPRequestValue.requestLong(request, "activity_period_id");

            ActivityPeriod apx = DbActivityPeriod.getOpenPeriod();

            if (activityPeriodId == 0) {
                activityPeriodId = apx.getOID();
            }

            boolean isOpen = true;
            if (activityPeriodId != apx.getOID()) {
                isOpen = false;
            }

//out.println("activityPeriodId : "+activityPeriodId);

            /*variable declaration*/
            int recordToGet = 100;
            String msgString = "";
            int iErrCode = JSPMessage.NONE;
            String whereClause = "activity_period_id = " + activityPeriodId;
            String orderClause = "code";

            CmdModule cmdModule = new CmdModule(request);
            JSPLine ctrLine = new JSPLine();
            Vector listModule = new Vector(1, 1);

            /*switch statement */
            iErrCode = cmdModule.action(iJSPCommand, oidModule);
            /* end switch*/
            JspModule jspModule = cmdModule.getForm();

            /*count list All Module*/
            int vectSize = DbModule.getCount(whereClause);
//recordToGet = vectSize;

            Module module = cmdModule.getModule();
            msgString = cmdModule.getMessage();


            if ((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV) ||
                    (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)) {
                start = cmdModule.actionList(iJSPCommand, start, vectSize, recordToGet);
            }
            /* end switch list*/

            /* get record to display */
            listModule = DbModule.list(start, recordToGet, whereClause, orderClause);

            /*handle condition if size of record to display = 0 and start > 0 	after delete*/
            if (listModule.size() < 1 && start > 0) {
                if (vectSize - recordToGet > recordToGet) {
                    start = start - recordToGet;
                } //go to JSPCommand.PREV
                else {
                    start = 0;
                    iJSPCommand = JSPCommand.FIRST;
                    prevJSPCommand = JSPCommand.FIRST; //go to JSPCommand.FIRST
                }
                listModule = DbModule.list(start, recordToGet, whereClause, orderClause);
            }

            System.out.println(listModule.size());

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
            
            function cmdChangePeriod(){
                document.frmmodule.command.value="<%=JSPCommand.LIST%>";
                document.frmmodule.action="module.jsp";
                document.frmmodule.submit();
            }
            
            function cmdAdd(){
                document.frmmodule.hidden_module_id.value="0";
                document.frmmodule.command.value="<%=JSPCommand.ADD%>";
                document.frmmodule.prev_command.value="<%=prevJSPCommand%>";
                document.frmmodule.action="moduledt.jsp";
                document.frmmodule.submit();
            }
            
            function cmdAsk(oidModule){
                document.frmmodule.hidden_module_id.value=oidModule;
                document.frmmodule.command.value="<%=JSPCommand.ASK%>";
                document.frmmodule.prev_command.value="<%=prevJSPCommand%>";
                document.frmmodule.action="module.jsp";
                document.frmmodule.submit();
            }
            
            function cmdConfirmDelete(oidModule){
                document.frmmodule.hidden_module_id.value=oidModule;
                document.frmmodule.command.value="<%=JSPCommand.DELETE%>";
                document.frmmodule.prev_command.value="<%=prevJSPCommand%>";
                document.frmmodule.action="module.jsp";
                document.frmmodule.submit();
            }
            function cmdSave(){
                document.frmmodule.command.value="<%=JSPCommand.SAVE%>";
                document.frmmodule.prev_command.value="<%=prevJSPCommand%>";
                document.frmmodule.action="module.jsp";
                document.frmmodule.submit();
            }
            
            function cmdEdit(oidModule){
                <%if(privUpdate){%>
                document.frmmodule.hidden_module_id.value=oidModule;
                document.frmmodule.command.value="<%=JSPCommand.EDIT%>";
                document.frmmodule.prev_command.value="<%=prevJSPCommand%>";
                document.frmmodule.action="moduledt.jsp";
                document.frmmodule.submit();
                <%}%>
            }
            
            function cmdCancel(oidModule){
                document.frmmodule.hidden_module_id.value=oidModule;
                document.frmmodule.command.value="<%=JSPCommand.EDIT%>";
                document.frmmodule.prev_command.value="<%=prevJSPCommand%>";
                document.frmmodule.action="module.jsp";
                document.frmmodule.submit();
            }
            
            function cmdBack(){
                document.frmmodule.command.value="<%=JSPCommand.BACK%>";
                document.frmmodule.action="module.jsp";
                document.frmmodule.submit();
            }
            
            function cmdListFirst(){
                document.frmmodule.command.value="<%=JSPCommand.FIRST%>";
                document.frmmodule.prev_command.value="<%=JSPCommand.FIRST%>";
                document.frmmodule.action="module.jsp";
                document.frmmodule.submit();
            }
            
            function cmdListPrev(){
                document.frmmodule.command.value="<%=JSPCommand.PREV%>";
                document.frmmodule.prev_command.value="<%=JSPCommand.PREV%>";
                document.frmmodule.action="module.jsp";
                document.frmmodule.submit();
            }
            
            function cmdListNext(){
                document.frmmodule.command.value="<%=JSPCommand.NEXT%>";
                document.frmmodule.prev_command.value="<%=JSPCommand.NEXT%>";
                document.frmmodule.action="module.jsp";
                document.frmmodule.submit();
            }
            
            function cmdListLast(){
                document.frmmodule.command.value="<%=JSPCommand.LAST%>";
                document.frmmodule.prev_command.value="<%=JSPCommand.LAST%>";
                document.frmmodule.action="module.jsp";
                document.frmmodule.submit();
            }
            
            function cmdToEditor(){
                //alert(document.frmcoa.menu_index.value);
                document.frmmodule.hidden_module_id.value=0;
                document.frmmodule.command.value="<%=JSPCommand.ADD%>";
                document.frmmodule.prev_command.value="<%=prevJSPCommand%>";
                document.frmmodule.action="moduledt.jsp";
                document.frmmodule.submit();
            }	
            
            function printXLS(){	 
                window.open("<%=printroot%>.report.RptModuleFlatXLS?period=<%=activityPeriodId%>");//,"budget","scrollbars=no,height=400,width=400,addressbar=no,menubar=no,toolbar=no,location=no,");  								
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
        <!-- #EndEditable -->
    </head>
    <body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','../images/new2.gif','../images/printxls2.gif')">
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
            String navigator = "<font class=\"lvl1\">Master</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">Activity List</span></font>";
                                           %>
                                           <%@ include file="../main/navigator.jsp"%>
                                                    <!-- #EndEditable --></td>
                                                </tr>
                                                <!--tr> 
                      <td><img src="<%=approot%>/images/title-sp.gif" width="584" height="1"></td> 
                                                </tr-->
                                                <tr> 
                                                    <td><!-- #BeginEditable "content" --> 
                                                        <form name="frmmodule" method ="post" action="">
                                                            <input type="hidden" name="command" value="<%=iJSPCommand%>">
                                                            <input type="hidden" name="vectSize" value="<%=vectSize%>">
                                                            <input type="hidden" name="start" value="<%=start%>">
                                                            <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                                                            <input type="hidden" name="hidden_module_id" value="<%=oidModule%>">
                                                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr>
                                                                    <td class="container"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="8"  colspan="3"> 
                                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="8" valign="middle" colspan="3"></td>
                                                                                        </tr>
                                                                                        <tr align="left" valign="buttom"> 
                                                                                            <td height="15" valign="middle" colspan="3"> 
                                                                                                <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                                                                                    <tr > 
                                                                                                        <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="17" height="10"></td>
                                                                                                        <td class="tab"> 
                                                                                                            <div align="center">&nbsp;&nbsp;Records&nbsp;&nbsp;</div>
                                                                                                        </td>
                                                                                                        <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                                                                                        <td class="tabin"> 
                                                                                                            <div align="center">
                                                                                                                <%if (isOpen) {%>
                                                                                                                &nbsp;&nbsp;<a href="javascript:cmdToEditor()" class="tablink">Editor</a>&nbsp;&nbsp;
                                                                                                                <%} else {%>
                                                                                                                <b>Editor</b>
                                                                                                                <%}%>
                                                                                                            </div>
                                                                                                        </td>
                                                                                                        <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                                                                                        <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                                                                                        <td width="100%" class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="10" height="10"></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="10" valign="middle" colspan="3"></td>
                                                                                        </tr>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="22" valign="middle" colspan="3"><b>Activity 
                                                                                                Period</b> &nbsp;&nbsp; 
                                                                                                <%
            Vector actPeriods = DbActivityPeriod.list(0, 0, "", "");
                                                                                                %>
                                                                                                <select name="activity_period_id" onChange="javascript:cmdChangePeriod()">
                                                                                                    <%if (actPeriods != null && actPeriods.size() > 0) {
                for (int i = 0; i < actPeriods.size(); i++) {
                    ActivityPeriod ap = (ActivityPeriod) actPeriods.get(i);
                                                                                                    %>
                                                                                                    <option value="<%=ap.getOID()%>" <%if (ap.getOID() == activityPeriodId) {%>selected<%}%>><%=ap.getName()%></option>
                                                                                                    <%}
            }%>
                                                                                                </select>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr align="left" valign="top">
                                                                                            <td height="10" valign="middle" colspan="3"></td>
                                                                                        </tr>
                                                                                        <%
            try {
                if (listModule.size() > 0) {
                                                                                        %>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="22" valign="middle" colspan="3" class="page"> 
                                                                                            <%= drawList(listModule, oidModule, isOpen)%> </td>
                                                                                        </tr>
                                                                                        <%  } else {%>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="22" valign="middle" colspan="3"> 
                                                                                                <table width="30%" border="0" cellspacing="0" cellpadding="0">
                                                                                                    <tr> 
                                                                                                        <td width="28" height="20">&nbsp;</td>
                                                                                                        <td width="67" height="20">&nbsp;</td>
                                                                                                        <td width="30" height="20">&nbsp;</td>
                                                                                                        <td width="216" height="20">&nbsp;</td>
                                                                                                    </tr>
                                                                                                    <tr> 
                                                                                                        <td width="28"><a href="javascript:cmdToEditor()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new21','','../images/new2.gif',1)"><img src="../images/new.gif" name="new21" width="71" height="22" border="0"></a></td>
                                                                                                        <td width="67">&nbsp;</td>
                                                                                                        <td width="30">&nbsp;</td>
                                                                                                        <td width="216">&nbsp;</td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <%}
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
                                                                                        <!--tr align="left" valign="top"> 
                          <td height="22" valign="middle" colspan="3">&nbsp;<a href="javascript:cmdAdd()" class="command"><u>Add 
                            New</u></a></td>
                                                                                        </tr-->
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="8" valign="middle" colspan="3"> 
                                                                                    <%if (listModule != null && listModule.size() > 0) {%>
                                                                                    <table width="30%" border="0" cellspacing="0" cellpadding="0">
                                                                                        <tr>
                                                                                            <td width="71">&nbsp;</td>
                                                                                            <td width="45">&nbsp;</td>
                                                                                            <td width="76">&nbsp;</td>
                                                                                            <td width="176">&nbsp;</td>
                                                                                        </tr>
                                                                                        <tr> 
                                                                                            <td width="71">
                                                                                                <%if (isOpen) {%>
                                                                                                <%if (privUpdate) {%><a href="javascript:cmdToEditor()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new2','','../images/new2.gif',1)"><img src="../images/new.gif" name="new2" width="71" height="22" border="0"></a><%} else {%>
                                                                                                <a href="javascript:printXLS()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('print1','','../images/printxls2.gif',1)"><img src="../images/printxls.gif" name="print1" height="22" border="0"></a> 
                                                                                                <%}%>
                                                                                                <%} else {%>
                                                                                                &nbsp;
                                                                                                <%}%>
                                                                                            </td>
                                                                                            <td width="45">&nbsp;</td>
                                                                                            <td width="76"><%if (privUpdate) {%><a href="javascript:printXLS()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('print','','../images/printxls2.gif',1)"><img src="../images/printxls.gif" name="print" height="22" border="0"></a><%}%></td>
                                                                                            <td width="176">&nbsp;</td>
                                                                                        </tr>
                                                                                    </table>
                                                                                    <%}%>
                                                                                </td>
                                                                            </tr>
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="8" valign="middle" colspan="3">&nbsp; </td>
                                                                            </tr>
                                                                    </table></td>
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
