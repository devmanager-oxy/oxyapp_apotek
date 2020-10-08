
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.admin.*" %>
<%@ page import = "com.project.system.*" %>
<%@ page import = "com.project.main.db.*" %>
<%@ page import = "com.project.fms.master.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "com.project.general.Location" %>
<%@ page import = "com.project.general.DbLocation" %>
<%@ page import = "com.project.general.CmdLocation" %>
<%@ page import = "com.project.general.JspLocation" %>
<%@ include file = "../main/javainit.jsp" %>
<% int appObjCode = 1;%>
<%@ include file = "../main/check.jsp" %>
<%
            boolean priv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_GENERAL);
            boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_GENERAL, AppMenu.PRIV_VIEW);
            boolean privUpdate = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_GENERAL, AppMenu.PRIV_UPDATE);
            boolean privAdd = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_GENERAL, AppMenu.PRIV_ADD);
            boolean privDelete = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_GENERAL, AppMenu.PRIV_DELETE);
%>
<!-- Jsp Block -->
<%!
    public String drawList(Vector objectClass, long locationId, String[] lang) {
        JSPList ctrlist = new JSPList();
        ctrlist.setAreaWidth("100%");
        ctrlist.setListStyle("listgen");
        ctrlist.setTitleStyle("tablehdr");
        ctrlist.setCellStyle("tablecell");
        ctrlist.setCellStyle1("tablecell1");
        ctrlist.setHeaderStyle("tablehdr");
        ctrlist.addHeader(lang[0], "5%");
        ctrlist.addHeader(lang[1], "8%");
        ctrlist.addHeader(lang[2], "7%");
        ctrlist.addHeader(lang[4], "10%");
        ctrlist.addHeader(lang[5], "10%");
        ctrlist.addHeader(lang[6], "10%");
        ctrlist.addHeader(lang[7], "10%");
        ctrlist.addHeader(lang[8], "10%");
        ctrlist.addHeader(lang[10],"10%");
        ctrlist.addHeader(lang[11],"10%");
        ctrlist.addHeader(lang[12],"10%");

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

            Coa coa = new Coa();
            try {
                coa = DbCoa.fetchExc(location.getCoaArId());
            } catch (Exception e) {
            }

            rowx.add(coa.getCode() + " - " + coa.getName());

            coa = new Coa();
            try {
                coa = DbCoa.fetchExc(location.getCoaApId());
            } catch (Exception e) {
            }

            rowx.add(coa.getCode() + " - " + coa.getName());

            coa = new Coa();
            try {
                coa = DbCoa.fetchExc(location.getCoaPpnId());
            } catch (Exception e) {
            }

            rowx.add(coa.getCode() + " - " + coa.getName());

            coa = new Coa();
            try {
                coa = DbCoa.fetchExc(location.getCoaPphId());
            } catch (Exception e) {
            }

            rowx.add(coa.getCode() + " - " + coa.getName());

            coa = new Coa();
            try {
                coa = DbCoa.fetchExc(location.getCoaDiscountId());
            } catch (Exception e) {
            }

            rowx.add(coa.getCode() + " - " + coa.getName());
            
            coa = new Coa();
            try {
                coa = DbCoa.fetchExc(location.getCoaSalesId());
            } catch (Exception e){
            }

            rowx.add(coa.getCode() + " - " + coa.getName());
            
            coa = new Coa();
            try {
                coa = DbCoa.fetchExc(location.getCoaProjectPPHPasal23Id());
            } catch (Exception e){
            }

            rowx.add(coa.getCode() + " - " + coa.getName());
            
            coa = new Coa();
            try {
                coa = DbCoa.fetchExc(location.getCoaProjectPPHPasal22Id());
            } catch (Exception e){
            }

            rowx.add(coa.getCode() + " - " + coa.getName());

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

            /*** LANG ***/
            String[] langMD = {"Code", "Name", "Description", "required", "Coa AR", "Coa AP", "Coa PPN", "Coa PPH", "Coa Discount", "Type","Coa Sales","Coa pph pasal 23","Coa pph pasal 23"}; //0-12
            String[] langNav = {"Masterdata", "Location"};
            if (lang == LANG_ID) {
                String[] langID = {"Kode", "Nama", "Keterangan", "harus diisi", "Coa AR", "Coa AP", "Coa PPN", "Coa PPH", "Coa Discount", "Tipe","Coa Sales","Coa pph pasal 23","Coa pph pasal 22"}; //0-12
                langMD = langID;
                String[] navID = {"Data Induk", "Daftar Lokasi"};
                langNav = navID;
            }
%>
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
            
            function cmdAdd(){
                document.frmlocation.hidden_location_id.value="0";
                document.frmlocation.command.value="<%=JSPCommand.ADD%>";
                document.frmlocation.prev_command.value="<%=prevJSPCommand%>";
                document.frmlocation.action="location.jsp";
                document.frmlocation.submit();
            }
            
            function cmdAsk(oidLocation){
                document.frmlocation.hidden_location_id.value=oidLocation;
                document.frmlocation.command.value="<%=JSPCommand.ASK%>";
                document.frmlocation.prev_command.value="<%=prevJSPCommand%>";
                document.frmlocation.action="location.jsp";
                document.frmlocation.submit();
            }
            
            function cmdConfirmDelete(oidLocation){
                document.frmlocation.hidden_location_id.value=oidLocation;
                document.frmlocation.command.value="<%=JSPCommand.DELETE%>";
                document.frmlocation.prev_command.value="<%=prevJSPCommand%>";
                document.frmlocation.action="location.jsp";
                document.frmlocation.submit();
            }
            function cmdSave(){
                document.frmlocation.command.value="<%=JSPCommand.SAVE%>";
                document.frmlocation.prev_command.value="<%=prevJSPCommand%>";
                document.frmlocation.action="location.jsp";
                document.frmlocation.submit();
            }
            
            function cmdEdit(oidLocation){
                <%if (privUpdate) {%>
                document.frmlocation.hidden_location_id.value=oidLocation;
                document.frmlocation.command.value="<%=JSPCommand.EDIT%>";
                document.frmlocation.prev_command.value="<%=prevJSPCommand%>";
                document.frmlocation.action="location.jsp";
                document.frmlocation.submit();
                <%}%>
            }
            
            function cmdCancel(oidLocation){
                document.frmlocation.hidden_location_id.value=oidLocation;
                document.frmlocation.command.value="<%=JSPCommand.EDIT%>";
                document.frmlocation.prev_command.value="<%=prevJSPCommand%>";
                document.frmlocation.action="location.jsp";
                document.frmlocation.submit();
            }
            
            function cmdBack(){
                document.frmlocation.command.value="<%=JSPCommand.BACK%>";
                document.frmlocation.action="location.jsp";
                document.frmlocation.submit();
            }
            
            function cmdListFirst(){
                document.frmlocation.command.value="<%=JSPCommand.FIRST%>";
                document.frmlocation.prev_command.value="<%=JSPCommand.FIRST%>";
                document.frmlocation.action="location.jsp";
                document.frmlocation.submit();
            }
            
            function cmdListPrev(){
                document.frmlocation.command.value="<%=JSPCommand.PREV%>";
                document.frmlocation.prev_command.value="<%=JSPCommand.PREV%>";
                document.frmlocation.action="location.jsp";
                document.frmlocation.submit();
            }
            
            function cmdListNext(){
                document.frmlocation.command.value="<%=JSPCommand.NEXT%>";
                document.frmlocation.prev_command.value="<%=JSPCommand.NEXT%>";
                document.frmlocation.action="location.jsp";
                document.frmlocation.submit();
            }
            
            function cmdListLast(){
                document.frmlocation.command.value="<%=JSPCommand.LAST%>";
                document.frmlocation.prev_command.value="<%=JSPCommand.LAST%>";
                document.frmlocation.action="location.jsp";
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
    <body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','../images/new2.gif')">
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
                                                        <form name="frmlocation" method ="post" action="">
                                                            <input type="hidden" name="command" value="<%=iJSPCommand%>">
                                                            <input type="hidden" name="vectSize" value="<%=vectSize%>">
                                                            <input type="hidden" name="start" value="<%=start%>">
                                                            <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                                                            <input type="hidden" name="hidden_location_id" value="<%=oidLocation%>">
                                                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr> 
                                                                    <td class="container"> 
                                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="8"  colspan="3"> 
                                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="8" valign="middle" colspan="3"> 
                                                                                            </td>
                                                                                        </tr>
                                                                                        <%
            try {
                if (listLocation.size() > 0){
                                                                                        %>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="22" valign="middle" colspan="3"> 
                                                                                                <table width="95%" border="0" cellspacing="0" cellpadding="0">
                                                                                                    <tr> 
                                                                                                        <td class="boxed1"><%= drawList(listLocation, oidLocation, langMD)%></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <%  }
            } catch (Exception exc) {
            }%>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="8" align="left" colspan="3" class="command"> 
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
                                                                                                    <%
            ctrLine.setLocationImg(approot + "/images/ctr_line");
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
                                                                                            <td height="11" valign="middle" colspan="3">&nbsp;</td>
                                                                                        </tr>
                                                                                        <%
            if (iJSPCommand != JSPCommand.EDIT && iJSPCommand != JSPCommand.ADD && iJSPCommand != JSPCommand.ASK && iErrCode == 0) {
                                                                                        %>
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
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="8" valign="middle" colspan="3"> 
                                                                                    <%if ((iJSPCommand == JSPCommand.ADD) || (iJSPCommand == JSPCommand.SAVE && iErrCode != 0) || (iJSPCommand == JSPCommand.EDIT) || (iJSPCommand == JSPCommand.ASK)) {%>
                                                                                    <table width="100%" border="0" cellspacing="1" cellpadding="0">
                                                                                        <tr align="left"> 
                                                                                            <td height="21" valign="middle" width="9%">&nbsp;</td>
                                                                                            <td height="21" colspan="2" width="91%" class="comment" valign="top">*)= <%=langMD[3]%></td>
                                                                                        </tr>
                                                                                        <tr align="left"> 
                                                                                            <td height="21" width="9%">&nbsp;<%=langMD[0]%></td>
                                                                                            <td height="21" colspan="2" width="91%" valign="top"> 
                                                                                                <input type="text" name="<%=jspLocation.colNames[JspLocation.JSP_CODE] %>"  value="<%= location.getCode() %>" class="formElemen" size="5" maxlength="4">
                                                                                            * <%= jspLocation.getErrorMsg(JspLocation.JSP_CODE) %></td> 
                                                                                        </tr> 
                                                                                        <tr align="left"> 
                                                                                            <td height="21" width="9%">&nbsp;<%=langMD[9]%></td>
                                                                                            <td height="21" colspan="2" width="91%" valign="top"> 
                                                                                                <select name="<%=jspLocation.colNames[JspLocation.JSP_TYPE]%>">                                                                                                    
                                                                                                    <%
    for(int i = 0; i < DbLocation.strLocTypes.length; i++){

                                                                                                    %>  
                                                                                                    <option value="<%=DbLocation.strLocTypes[i]%>" <%if (DbLocation.strLocTypes[i].compareTo(location.getType()) == 0) {%>selected<%}%>    ><%=DbLocation.strLocTypes[i]%></option>
                                                                                                    
                                                                                                    <%
    }
                                                                                                    %>
                                                                                                </select>
                                                                                            </td> 
                                                                                        </tr> 
                                                                                        <tr align="left"> 
                                                                                            <td height="21" width="9%">&nbsp;<%=langMD[1]%></td>
                                                                                            <td height="21" colspan="2" width="91%" valign="top"> 
                                                                                                <input type="text" name="<%=jspLocation.colNames[JspLocation.JSP_NAME] %>"  value="<%= location.getName() %>" class="formElemen" size="65">
                                                                                            * <%= jspLocation.getErrorMsg(JspLocation.JSP_NAME) %></td> 
                                                                                        </tr>    
                                                                                        <tr align="left"> 
                                                                                            <td height="21" width="9%">&nbsp;<%=langMD[2]%></td>
                                                                                            <td height="21" colspan="2" width="91%" valign="top"> 
                                                                                            <textarea name="<%=jspLocation.colNames[JspLocation.JSP_DESCRIPTION] %>" class="formElemen" cols="120" rows="2"><%= location.getDescription() %></textarea></td> 
                                                                                        </tr>
                                                                                        <tr align="left"> 
                                                                                            <td height="21" width="9%">&nbsp;<%=langMD[4]%></td>
                                                                                            <td height="21" colspan="2" width="91%" valign="top"> 
                                                                                                <%
    Vector coas = DbCoa.list(0, 0, "", "code");

    Vector coaarid_value = new Vector(1, 1);
    Vector coaarid_key = new Vector(1, 1);
    String sel_coaarid = "" + location.getCoaArId();
    coaarid_value.add("- ");
    coaarid_key.add("0");

    if (coas != null && coas.size() > 0) {
        for (int i = 0; i < coas.size(); i++) {
            Coa coa = (Coa) coas.get(i);

            String str = "";

            switch (coa.getLevel()){
                case 1:
                    break;
                case 2:
                    str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                    break;
                case 3:
                    str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                    break;
                case 4:
                    str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                    break;
                case 5:
                    str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                    break;
            }

            coaarid_key.add("" + coa.getOID());
            coaarid_value.add(str + coa.getCode() + " - " + coa.getName());
        }
    }
                                                                                                %>
                                                                                                <%= JSPCombo.draw(jspLocation.colNames[JspLocation.JSP_COA_AR_ID], null, sel_coaarid, coaarid_key, coaarid_value, "", "formElemen") %> 
                                                                                            </td> 
                                                                                        </tr>
                                                                                        <tr align="left"> 
                                                                                            <td height="21" width="9%">&nbsp;<%=langMD[5]%></td>
                                                                                            <td height="21" colspan="2" width="91%" valign="top"> 
                                                                                                <%
    Vector coaapid_value = new Vector(1, 1);
    Vector coaapid_key = new Vector(1, 1);
    String sel_coaapid = "" + location.getCoaApId();

    coaapid_value.add("- ");
    coaapid_key.add("0");

    if (coas != null && coas.size() > 0) {
        for (int i = 0; i < coas.size(); i++) {
            Coa coa = (Coa) coas.get(i);

            String str = "";

            switch (coa.getLevel()) {
                case 1:
                    break;
                case 2:
                    str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                    break;
                case 3:
                    str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                    break;
                case 4:
                    str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                    break;
                case 5:
                    str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                    break;
            }

            coaapid_key.add("" + coa.getOID());
            coaapid_value.add(str + coa.getCode() + " - " + coa.getName());
        }
    }


                                                                                                %>
                                                                                                <%= JSPCombo.draw(jspLocation.colNames[JspLocation.JSP_COA_AP_ID], null, sel_coaapid, coaapid_key, coaapid_value, "", "formElemen") %> 
                                                                                            </td> 
                                                                                        </tr>
                                                                                        <tr align="left"> 
                                                                                            <td height="21" width="9%">&nbsp;<%=langMD[6]%></td>
                                                                                            <td height="21" colspan="2" width="91%" valign="top"> 
                                                                                                <%
    Vector coappnid_value = new Vector(1, 1);
    Vector coappnid_key = new Vector(1, 1);
    String sel_coappnid = "" + location.getCoaPpnId();
    coappnid_value.add("- ");
    coappnid_key.add("0");

    if (coas != null && coas.size() > 0) {
        for (int i = 0; i < coas.size(); i++){
            Coa coa = (Coa) coas.get(i);

            String str = "";

            switch (coa.getLevel()) {
                case 1:
                    break;
                case 2:
                    str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                    break;
                case 3:
                    str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                    break;
                case 4:
                    str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                    break;
                case 5:
                    str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                    break;
            }

            coappnid_key.add("" + coa.getOID());
            coappnid_value.add(str + coa.getCode() + " - " + coa.getName());
        }
    }

                                                                                                %>
                                                                                                <%= JSPCombo.draw(jspLocation.colNames[JspLocation.JSP_COA_PPN_ID], null, sel_coappnid, coappnid_key, coappnid_value, "", "formElemen") %>  
                                                                                            </td> 
                                                                                        </tr>
                                                                                        <tr align="left"> 
                                                                                            <td height="21" width="9%">&nbsp;<%=langMD[7]%></td>
                                                                                            <td height="21" colspan="2" width="91%" valign="top"> 
                                                                                                <% Vector coapphid_value = new Vector(1, 1);
    Vector coapphid_key = new Vector(1, 1);
    String sel_coapphid = "" + location.getCoaPphId();
    coapphid_value.add("- ");
    coapphid_key.add("0");

    if (coas != null && coas.size() > 0) {
        for (int i = 0; i < coas.size(); i++) {
            Coa coa = (Coa) coas.get(i);

            String str = "";

            switch (coa.getLevel()) {
                case 1:
                    break;
                case 2:
                    str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                    break;
                case 3:
                    str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                    break;
                case 4:
                    str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                    break;
                case 5:
                    str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                    break;
            }

            coapphid_key.add("" + coa.getOID());
            coapphid_value.add(str + coa.getCode() + " - " + coa.getName());
        }
    }

                                                                                                %>
                                                                                                <%= JSPCombo.draw(jspLocation.colNames[JspLocation.JSP_COA_PPH_ID], null, sel_coapphid, coapphid_key, coapphid_value, "", "formElemen") %> 
                                                                                            </td> 
                                                                                        </tr>
                                                                                        <tr align="left"> 
                                                                                            <td height="21" width="9%">&nbsp;<%=langMD[8]%></td>
                                                                                            <td height="21" colspan="2" width="91%" valign="top"> 
                                                                                                <%
    Vector coadiscountid_value = new Vector(1, 1);
    Vector coadiscountid_key = new Vector(1, 1);
    String sel_coadiscountid = "" + location.getCoaDiscountId();

    coadiscountid_value.add("- ");
    coadiscountid_key.add("0");

    if (coas != null && coas.size() > 0) {
        for (int i = 0; i < coas.size(); i++) {
            Coa coa = (Coa) coas.get(i);

            String str = "";

            switch (coa.getLevel()) {
                case 1:
                    break;
                case 2:
                    str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                    break;
                case 3:
                    str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                    break;
                case 4:
                    str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                    break;
                case 5:
                    str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                    break;
            }

            coadiscountid_key.add("" + coa.getOID());
            coadiscountid_value.add(str + coa.getCode() + " - " + coa.getName());
        }
    }


                                                                                                %>
                                                                                                <%= JSPCombo.draw(jspLocation.colNames[JspLocation.JSP_COA_DISCOUNT_ID], null, sel_coadiscountid, coadiscountid_key, coadiscountid_value, "", "formElemen") %> 
                                                                                            </td> 
                                                                                        </tr>
                                                                                        <tr align="left"> 
                                                                                            <td height="21" width="9%">&nbsp;<%=langMD[10]%></td>
                                                                                            <td height="21" colspan="2" width="91%" valign="top"> 
                                                                                                <%
    Vector coasalesid_value = new Vector(1, 1);
    Vector coasalesid_key = new Vector(1, 1);
    String sel_coasalesid = "" + location.getCoaSalesId();

    coasalesid_value.add("- ");
    coasalesid_key.add("0");

    if (coas != null && coas.size() > 0) {
        for (int i = 0; i < coas.size(); i++) {
            Coa coa = (Coa) coas.get(i);

            String str = "";

            switch (coa.getLevel()) {
                case 1:
                    break;
                case 2:
                    str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                    break;
                case 3:
                    str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                    break;
                case 4:
                    str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                    break;
                case 5:
                    str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                    break;
            }

            coasalesid_key.add("" + coa.getOID());
            coasalesid_value.add(str + coa.getCode() + " - " + coa.getName());
        }
    }
                                                                                                %>
                                                                                                <%= JSPCombo.draw(jspLocation.colNames[JspLocation.JSP_COA_SALES_ID], null, sel_coasalesid, coasalesid_key, coasalesid_value, "", "formElemen") %> 
                                                                                            </td> 
                                                                                        </tr>
                                                                                        <tr align="left"> 
                                                                                            <td height="21" width="9%">&nbsp;<%=langMD[11]%></td>
                                                                                            <td height="21" colspan="2" width="91%" valign="top"> 
                                                                                                <%
    Vector coapph23id_value = new Vector(1, 1);
    Vector coapph23id_key = new Vector(1, 1);
    String sel_coapph23id = "" + location.getCoaProjectPPHPasal23Id();

    coapph23id_value.add("- ");
    coapph23id_key.add("0");

    if (coas != null && coas.size() > 0) {
        for (int i = 0; i < coas.size(); i++) {
            Coa coa = (Coa) coas.get(i);

            String str = "";

            switch (coa.getLevel()) {
                case 1:
                    break;
                case 2:
                    str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                    break;
                case 3:
                    str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                    break;
                case 4:
                    str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                    break;
                case 5:
                    str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                    break;
            }

            coapph23id_key.add("" + coa.getOID());
            coapph23id_value.add(str + coa.getCode() + " - " + coa.getName());
        }
    }
                                                                                                %>
                                                                                                <%= JSPCombo.draw(jspLocation.colNames[JspLocation.JSP_COA_PROJECT_PPH_PASAL_23_ID], null, sel_coapph23id, coapph23id_key, coapph23id_value, "", "formElemen") %> 
                                                                                            </td> 
                                                                                        </tr>
                                                                                        <tr align="left"> 
                                                                                            <td height="21" width="9%">&nbsp;<%=langMD[11]%></td>
                                                                                            <td height="21" colspan="2" width="91%" valign="top"> 
                                                                                                <%
    Vector coapph22id_value = new Vector(1, 1);
    Vector coapph22id_key = new Vector(1, 1);
    String sel_coapph22id = "" + location.getCoaProjectPPHPasal22Id();

    coapph22id_value.add("- ");
    coapph22id_key.add("0");

    if (coas != null && coas.size() > 0) {
        for (int i = 0; i < coas.size(); i++) {
            Coa coa = (Coa) coas.get(i);

            String str = "";

            switch (coa.getLevel()) {
                case 1:
                    break;
                case 2:
                    str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                    break;
                case 3:
                    str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                    break;
                case 4:
                    str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                    break;
                case 5:
                    str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                    break;
            }

            coapph22id_key.add("" + coa.getOID());
            coapph22id_value.add(str + coa.getCode() + " - " + coa.getName());
        }
    }
                                                                                                %>
                                                                                                <%= JSPCombo.draw(jspLocation.colNames[JspLocation.JSP_COA_PROJECT_PPH_PASAL_22_ID], null, sel_coapph22id, coapph22id_key, coapph22id_value, "", "formElemen") %> 
                                                                                            </td> 
                                                                                        </tr>
                                                                                        <tr align="left"> 
                                                                                            <td height="8" valign="middle" width="9%">&nbsp;</td>
                                                                                            <td height="8" colspan="2" width="91%" valign="top">&nbsp;</td>
                                                                                        </tr>
                                                                                        <tr align="left" > 
                                                                                            <td colspan="3" class="command" valign="top"> 
                                                                                                <%
    ctrLine.setLocationImg(approot + "/images/ctr_line");
    ctrLine.initDefault();
    ctrLine.setTableWidth("40%");
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
                                                                                            <%=ctrLine.drawImageOnly(iJSPCommand, iErrCode, msgString)%> </td>
                                                                                        </tr>
                                                                                        <tr> 
                                                                                            <td width="9%">&nbsp;</td>
                                                                                            <td width="91%">&nbsp;</td>
                                                                                        </tr>
                                                                                        <tr align="left" > 
                                                                                            <td colspan="3" valign="top"> 
                                                                                                <div align="left"></div>
                                                                                            </td>
                                                                                        </tr>
                                                                                    </table>
                                                                                    <%}%>
                                                                                </td>
                                                                            </tr>
                                                                        </table>
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