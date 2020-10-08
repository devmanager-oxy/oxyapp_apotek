
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.admin.*" %>
<%@ page import = "com.project.system.*" %>
<%@ page import = "com.project.main.db.*" %>
<!--package test -->
<%@ page import = "com.project.fms.master.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "com.project.general.*" %>
<%@ include file = "../main/javainit.jsp" %>
<% int appObjCode = 1;%>
<%@ include file = "../main/check.jsp" %>
<%
            boolean priv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_CONFIGURATION);
            boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_CONFIGURATION, AppMenu.PRIV_VIEW);
            boolean privUpdate = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_CONFIGURATION, AppMenu.PRIV_UPDATE);
            boolean privAdd = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_CONFIGURATION, AppMenu.PRIV_ADD);
            boolean privDelete = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_CONFIGURATION, AppMenu.PRIV_DELETE);
%>
<!-- Jsp Block -->
<%!
    public String drawList(Vector objectClass, long locationId) {
        JSPList ctrlist = new JSPList();
        ctrlist.setAreaWidth("70%");
        //jsplist.setAreaWidth("20%");
        ctrlist.setListStyle("listgen");
        ctrlist.setTitleStyle("tablehdr");
        ctrlist.setCellStyle("tablecell");
        ctrlist.setCellStyle1("tablecell1");
        ctrlist.setHeaderStyle("tablehdr");
        ctrlist.addHeader("Code", "10%");
        ctrlist.addHeader("Name", "20%");
        ctrlist.addHeader("Description", "70%");

        ctrlist.setLinkRow(0);
        ctrlist.setLinkSufix("");
        Vector lstData = ctrlist.getData();
        Vector lstLinkData = ctrlist.getLinkData();
        ctrlist.setLinkPrefix("javascript:cmdEdit('");
        ctrlist.setLinkSufix("')");
        ctrlist.reset();
        int index = -1;

        for (int i = 0; i < objectClass.size(); i++) {
            Location location = (Location) objectClass.get(i);
            Vector rowx = new Vector();
            if (locationId == location.getOID()) {
                index = i;
            }

            rowx.add(location.getCode());

            rowx.add(location.getName());

            rowx.add(location.getDescription());

            lstData.add(rowx);
            lstLinkData.add(String.valueOf(location.getOID()));
        }

        return ctrlist.draw(index);
    }

%>
<%
            int iJSPCommand = JSPRequestValue.requestCommand(request);
            int start = JSPRequestValue.requestInt(request, "start");
            int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
            long oidLocation = JSPRequestValue.requestLong(request, "hidden_location_id");

            /*variable declaration*/
            int recordToGet = 10;
            String msgString = "";
            int iErrCode = JSPMessage.NONE;
            String whereClause = "";
            String orderClause = "";

            CmdLocation ctrlLocation = new CmdLocation(request);
            JSPLine ctrLine = new JSPLine();
            Vector listLocation = new Vector(1, 1);

            /*switch statement */
            iErrCode = ctrlLocation.action(iJSPCommand, oidLocation);
            /* end switch*/
            JspLocation jspLocation = ctrlLocation.getForm();

            /*count list All Location*/
            int vectSize = DbLocation.getCount(whereClause);

            Location location = ctrlLocation.getLocation();
            msgString = ctrlLocation.getMessage();

            if ((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV) ||
                    (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)) {
                start = ctrlLocation.actionList(iJSPCommand, start, vectSize, recordToGet);
            }
            /* end switch list*/

            /* get record to display */
            listLocation = DbLocation.list(start, recordToGet, whereClause, orderClause);

            /*handle condition if size of record to display = 0 and start > 0 	after delete*/
            if (listLocation.size() < 1 && start > 0) {
                if (vectSize - recordToGet > recordToGet) {
                    start = start - recordToGet;
                } //go to JSPCommand.PREV
                else {
                    start = 0;
                    iJSPCommand = JSPCommand.FIRST;
                    prevJSPCommand = JSPCommand.FIRST; //go to JSPCommand.FIRST
                }
                listLocation = DbLocation.list(start, recordToGet, whereClause, orderClause);
            }
%>
<html ><!-- #BeginTemplate "/Templates/indexwomenu.dwt" -->
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
                document.frmlocation.hidden_location_id.value="0";
                document.frmlocation.command.value="<%=JSPCommand.ADD%>";
                document.frmlocation.prev_command.value="<%=prevJSPCommand%>";
                document.frmlocation.action="company_loc.jsp";
                document.frmlocation.submit();
            }
            
            function cmdAsk(oidLocation){
                document.frmlocation.hidden_location_id.value=oidLocation;
                document.frmlocation.command.value="<%=JSPCommand.ASK%>";
                document.frmlocation.prev_command.value="<%=prevJSPCommand%>";
                document.frmlocation.action="company_loc.jsp";
                document.frmlocation.submit();
            }
            
            function cmdConfirmDelete(oidLocation){
                document.frmlocation.hidden_location_id.value=oidLocation;
                document.frmlocation.command.value="<%=JSPCommand.DELETE%>";
                document.frmlocation.prev_command.value="<%=prevJSPCommand%>";
                document.frmlocation.action="company_loc.jsp";
                document.frmlocation.submit();
            }
            function cmdSave(){
                document.frmlocation.command.value="<%=JSPCommand.SAVE%>";
                document.frmlocation.prev_command.value="<%=prevJSPCommand%>";
                document.frmlocation.action="company_loc.jsp";
                document.frmlocation.submit();
            }
            
            function cmdEdit(oidLocation){
                <%if(privUpdate){%>
                document.frmlocation.hidden_location_id.value=oidLocation;
                document.frmlocation.command.value="<%=JSPCommand.EDIT%>";
                document.frmlocation.prev_command.value="<%=prevJSPCommand%>";
                document.frmlocation.action="company_loc.jsp";
                document.frmlocation.submit();
                <%}%>
            }
            
            function cmdCancel(oidLocation){
                document.frmlocation.hidden_location_id.value=oidLocation;
                document.frmlocation.command.value="<%=JSPCommand.EDIT%>";
                document.frmlocation.prev_command.value="<%=prevJSPCommand%>";
                document.frmlocation.action="company_loc.jsp";
                document.frmlocation.submit();
            }
            
            function cmdBack(){
                document.frmlocation.command.value="<%=JSPCommand.BACK%>";
                document.frmlocation.action="company_loc.jsp";
                document.frmlocation.submit();
            }
            
            function cmdListFirst(){
                document.frmlocation.command.value="<%=JSPCommand.FIRST%>";
                document.frmlocation.prev_command.value="<%=JSPCommand.FIRST%>";
                document.frmlocation.action="company_loc.jsp";
                document.frmlocation.submit();
            }
            
            function cmdListPrev(){
                document.frmlocation.command.value="<%=JSPCommand.PREV%>";
                document.frmlocation.prev_command.value="<%=JSPCommand.PREV%>";
                document.frmlocation.action="company_loc.jsp";
                document.frmlocation.submit();
            }
            
            function cmdListNext(){
                document.frmlocation.command.value="<%=JSPCommand.NEXT%>";
                document.frmlocation.prev_command.value="<%=JSPCommand.NEXT%>";
                document.frmlocation.action="company_loc.jsp";
                document.frmlocation.submit();
            }
            
            function cmdListLast(){
                document.frmlocation.command.value="<%=JSPCommand.LAST%>";
                document.frmlocation.prev_command.value="<%=JSPCommand.LAST%>";
                document.frmlocation.action="company_loc.jsp";
                document.frmlocation.submit();
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
    <body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif')">
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
                                        <td width="100%" valign="top"> 
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                <tr> 
                                                    <td class="title"><!-- #BeginEditable "title" -->
                                           <%
            String navigator = "<font class=\"lvl1\">Company Profile</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">Step 3 of 5</span></font>";
                                           %>
                                           <%@ include file="../main/navigator.jsp"%>
                                                    <!-- #EndEditable --></td>
                                                </tr>
                                                <tr> 
                                                    <td><span class="level2"><img src="<%=approot%>/images/title-sp.gif" width="584" height="1"></span></td>
                                                </tr>
                                                <tr> 
                                                    <td><!-- #BeginEditable "content" --> 
                                                        <form name="frmlocation" method ="post" action="">
                                                            <input type="hidden" name="command" value="<%=iJSPCommand%>">
                                                            <input type="hidden" name="vectSize" value="<%=vectSize%>">
                                                            <input type="hidden" name="start" value="<%=start%>">
                                                            <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                                                            <input type="hidden" name="hidden_location_id" value="<%=oidLocation%>">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr align="left" valign="top"> 
                                                                    <td height="8"  colspan="3"> 
                                                                        <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="8" valign="middle" width="2%"></td>
                                                                                <td height="8" valign="middle" colspan="3" width="98%">&nbsp; 
                                                                                </td>
                                                                            </tr>
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="15" valign="middle" width="2%">&nbsp;</td>
                                                                                <td height="15" valign="middle" colspan="3" width="98%">&nbsp;</td>
                                                                            </tr>
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="22" valign="middle" width="2%">&nbsp;</td>
                                                                                <td height="22" valign="middle" colspan="3" width="98%">Please 
                                                                                    specify minimum one location where this 
                                                                                finance system setted up. </td>
                                                                            </tr>
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="15" valign="middle" width="2%">&nbsp;</td>
                                                                                <td height="15" valign="middle" colspan="3" width="98%">&nbsp;</td>
                                                                            </tr>
                                                                            <%
            try {
                if (listLocation.size() > 0) {
                                                                            %>
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="22" valign="middle" width="2%">&nbsp;</td>
                                                                                <td height="22" valign="middle" colspan="3" width="98%"> 
                                                                                <%= drawList(listLocation, oidLocation)%> </td>
                                                                            </tr>
                                                                            <%  }
            } catch (Exception exc) {
            }%>
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="8" align="left" width="2%" class="command">&nbsp;</td>
                                                                                <td height="8" align="left" colspan="3" class="command" width="98%"> 
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
                                                                                <%=ctrLine.drawImageListLimit(cmd, vectSize, start, recordToGet)%> </span> </td>
                                                                            </tr>
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="22" valign="middle" width="2%">&nbsp;</td>
                                                                                <td height="22" valign="middle" colspan="3" width="98%"> 
                                                                                    <table width="99%" border="0" cellspacing="0" cellpadding="0">
                                                                                        <tr>
                                                                                            <td width="9%">&nbsp;</td>
                                                                                            <td width="6%">&nbsp;</td>
                                                                                            <td width="8%">&nbsp;</td>
                                                                                            <td width="77%">&nbsp;</td>
                                                                                        </tr>
                                                                                        <tr> 
                                                                                            <td width="9%"><%if(privAdd){%><a href="javascript:cmdAdd()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new','','../images/new2.gif',1)"><img src="../images/new.gif" name="new" width="71" height="22" border="0"></a><%}%></td>
                                                                                            <td width="6%"><a href="company_curr.jsp?command=<%=JSPCommand.BACK%>" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('back','','../images/back2.gif',1)"><img src="../images/back.gif" name="back" width="51" height="22" border="0"></a></td>
                                                                                            <td width="8%"><a href="company_2.jsp" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('next','','../images/next2.gif',1)"><img src="../images/next.gif" name="next" width="55" height="22" border="0"></a></td>
                                                                                            <td width="77%">&nbsp;</td>
                                                                                        </tr>
                                                                                    </table>
                                                                                    
                                                                                </td>
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                </tr>
                                                                <tr align="left" valign="top"> 
                                                                    <td height="8" valign="middle" colspan="3"> 
                                                                        <%if ((iJSPCommand == JSPCommand.ADD) || (iJSPCommand == JSPCommand.SAVE) && (jspLocation.errorSize() > 0) || (iJSPCommand == JSPCommand.EDIT) || (iJSPCommand == JSPCommand.ASK)) {%>
                                                                        <table width="100%" border="0" cellspacing="1" cellpadding="0">
                                                                            <tr align="left">
                                                                                <td height="21" valign="middle" width="2%">&nbsp;</td>
                                                                                <td height="21" valign="middle" width="8%">&nbsp;</td>
                                                                                <td height="21" colspan="2" width="90%" class="comment" valign="top">&nbsp;</td>
                                                                            </tr>
                                                                            <tr align="left">
                                                                                <td height="21" valign="middle" width="2%">&nbsp;</td>
                                                                                <td height="21" valign="middle" width="8%">&nbsp;</td>
                                                                                <td height="21" colspan="2" width="90%" class="comment" valign="top">&nbsp;</td>
                                                                            </tr>
                                                                            <tr align="left"> 
                                                                                <td height="21" valign="middle" width="2%">&nbsp;</td>
                                                                                <td height="21" valign="middle" width="8%">&nbsp;</td>
                                                                                <td height="21" colspan="2" width="90%" class="comment" valign="top">*)= 
                                                                                required</td>
                                                                            </tr>
                                                                            <tr align="left"> 
                                                                            <td height="21" width="2%">&nbsp;</td>
                                                                            <td height="21" width="8%">&nbsp;Code</td>
                                                                            <td height="21" colspan="2" width="90%" valign="top"> 
                                                                            <input type="text" name="<%=jspLocation.colNames[JspLocation.JSP_CODE] %>"  value="<%= location.getCode() %>" class="formElemen" size="5" maxlength="1">
                                                                            * <%= jspLocation.getErrorMsg(JspLocation.JSP_CODE) %> 
                                                                            <tr align="left"> 
                                                                            <td height="21" width="2%">&nbsp;</td>
                                                                            <td height="21" width="8%">&nbsp;Name</td>
                                                                            <td height="21" colspan="2" width="90%" valign="top"> 
                                                                            <input type="text" name="<%=jspLocation.colNames[JspLocation.JSP_NAME] %>"  value="<%= location.getName() %>" class="formElemen" size="35">
                                                                            * <%= jspLocation.getErrorMsg(JspLocation.JSP_NAME) %> 
                                                                            <tr align="left"> 
                                                                            <td height="21" width="2%">&nbsp;</td>
                                                                            <td height="21" width="8%">&nbsp;Description</td>
                                                                            <td height="21" colspan="2" width="90%" valign="top"> 
                                                                            <input type="text" name="<%=jspLocation.colNames[JspLocation.JSP_DESCRIPTION] %>"  value="<%= location.getDescription() %>" class="formElemen" size="100">
                                                                            <tr align="left"> 
                                                                                <td height="8" valign="middle" width="2%">&nbsp;</td>
                                                                                <td height="8" valign="middle" width="8%">&nbsp;</td>
                                                                                <td height="8" colspan="2" width="90%" valign="top">&nbsp;</td>
                                                                            </tr>
                                                                            <tr align="left"> 
                                                                                <td height="8" valign="middle" width="2%">&nbsp;</td>
                                                                                <td height="8" valign="middle" colspan="3"> 
                                                                                    <%
    ctrLine.setLocationImg(approot + "/images");
    ctrLine.initDefault();
    ctrLine.setTableWidth("80%");
    String scomDel = "javascript:cmdAsk('" + oidLocation + "')";
    String sconDelCom = "javascript:cmdConfirmDelete('" + oidLocation + "')";
    String scancel = "javascript:cmdEdit('" + oidLocation + "')";
    ctrLine.setBackCaption("Back to List");
    ctrLine.setJSPCommandStyle("buttonlink");
    ctrLine.setDeleteCaption("Delete");
    ctrLine.setSaveCaption("Save");
    ctrLine.setAddCaption("");

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


    ctrLine.setWidthAllJSPCommand("70");
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
                                                                                <%= ctrLine.drawImageOnly(iJSPCommand, iErrCode, msgString)%> </td>
                                                                            </tr>
                                                                            <tr align="left" > 
                                                                                <td colspan="4" class="command" valign="top">&nbsp; 
                                                                                </td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td width="2%">&nbsp;</td>
                                                                                <td width="8%">&nbsp;</td>
                                                                                <td width="90%">&nbsp;</td>
                                                                            </tr>
                                                                            <tr align="left" > 
                                                                                <td colspan="4" valign="top"> 
                                                                                    <div align="left"></div>
                                                                                </td>
                                                                            </tr>
                                                                        </table>
                                                                        <%}%>
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </form>
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
