
<%-- 
    Document   : budgetgroup
    Created on : Nov 8, 2014, 4:01:23 PM
    Author     : Roy
--%>

<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "com.project.ccs.posmaster.*" %>
<%@ page import = "com.project.ccs.postransaction.stock.*" %>
<%@ page import = "com.project.ccs.postransaction.receiving.*" %>
<%@ page import = "com.project.ccs.postransaction.purchase.*" %>
<%@ page import = "com.project.system.*" %>
<%@ page import = "com.project.fms.ar.*" %>
<%@ page import = "com.project.general.*" %>
<%@ page import = "com.project.ccs.report.*" %>
<%@ include file = "../main/javainit.jsp" %>
<%@ include file = "../main/check.jsp" %>
<%
            boolean priv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MENU_APAY, AppMenu.M2_MENU_PAL);
            boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_APAY, AppMenu.M2_MENU_PAL, AppMenu.PRIV_VIEW);
            boolean privAdd = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_APAY, AppMenu.M2_MENU_PAL, AppMenu.PRIV_ADD);            
            boolean privUpdate = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_APAY, AppMenu.M2_MENU_PAL, AppMenu.PRIV_VIEW);            
            boolean privDelete = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_APAY, AppMenu.M2_MENU_PAL, AppMenu.PRIV_DELETE);
            boolean purchasePrivView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_APAY, AppMenu.M2_MENU_PAL, AppMenu.PRIV_VIEW);
%>
<!-- Jsp Block -->

<%!
    public String drawList(int iJSPCommand, JspVendorGroup frmObject, VendorGroup objEntity, Vector objectClass, long bankId) {
        JSPList ctrlist = new JSPList();
        ctrlist.setAreaWidth("80%");
        ctrlist.setListStyle("listgen");
        ctrlist.setTitleStyle("tablehdr");
        ctrlist.setCellStyle("tablecell");
        ctrlist.setCellStyle1("tablecell1");
        ctrlist.setHeaderStyle("tablehdr");
        ctrlist.addHeader("Group Name", "30%");
        ctrlist.addHeader("Vendor", "");

        ctrlist.setLinkRow(0);
        ctrlist.setLinkSufix("");
        Vector lstData = ctrlist.getData();
        Vector lstLinkData = ctrlist.getLinkData();
        Vector rowx = new Vector(1, 1);
        ctrlist.reset();
        int index = -1;

        Vector vendors = DbVendor.list(0, 0, "", DbVendor.colNames[DbVendor.COL_NAME]);
        Vector vendor_value = new Vector(1, 1);
        Vector vendor_key = new Vector(1, 1);
        
        if (vendors != null && vendors.size() > 0) {
                    for (int ix = 0; ix < vendors.size(); ix++) {
                        Vendor v = (Vendor) vendors.get(ix);

                        vendor_value.add("" + v.getOID());
                        vendor_key.add(v.getName());
                    }
                }
        

        for (int i = 0; i < objectClass.size(); i++) {
            VendorGroup vendorGroup = (VendorGroup) objectClass.get(i);
            rowx = new Vector();
            if (bankId == vendorGroup.getOID()) {
                index = i;
            }

            if (index == i && (iJSPCommand == JSPCommand.EDIT || iJSPCommand == JSPCommand.ASK)) {

                String sel_vendorid = "" + vendorGroup.getVendorId();

                

                rowx.add("<input type=\"text\" name=\"" + frmObject.colNames[JspVendorGroup.JSP_GROUP_NAME] + "\" value=\"" + vendorGroup.getGroupName() + "\" class=\"formElemen\" size=\"30\">");
                rowx.add(JSPCombo.draw(frmObject.colNames[JspVendorGroup.JSP_VENDOR_ID], null, sel_vendorid, vendor_value, vendor_key, "", "formElemen"));
            } else {
                rowx.add("<a href=\"javascript:cmdEdit('" + String.valueOf(vendorGroup.getOID()) + "')\">" + vendorGroup.getGroupName() + "</a>");


                Vendor vx = new Vendor();
                try {
                    vx = DbVendor.fetchExc(vendorGroup.getVendorId());
                } catch (Exception e) {
                }
                rowx.add("" + vx.getName());

            }
            lstData.add(rowx);
        }

        rowx = new Vector();

        if (iJSPCommand == JSPCommand.ADD || (iJSPCommand == JSPCommand.SAVE && frmObject.errorSize() > 0)) {

            String sel_vendorid = "" + objEntity.getVendorId();
            rowx.add("<input type=\"text\" name=\"" + frmObject.colNames[JspVendorGroup.JSP_GROUP_NAME] + "\" value=\"" + objEntity.getGroupName() + "\" class=\"formElemen\" size=\"30\">");
            rowx.add(JSPCombo.draw(frmObject.colNames[JspVendorGroup.JSP_VENDOR_ID], null, sel_vendorid, vendor_value, vendor_key, "", "formElemen"));
        }

        lstData.add(rowx);

        return ctrlist.draw(index);
    }

%>
<%
            int iJSPCommand = JSPRequestValue.requestCommand(request);
            int start = JSPRequestValue.requestInt(request, "start");
            int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
            long oidVendorGroup = JSPRequestValue.requestLong(request, "hidden_vendor_group_id");

            /*variable declaration*/
            int recordToGet = 10;
            String msgString = "";
            int iErrCode = JSPMessage.NONE;
            String whereClause = "";
            String orderClause = "";

            CmdVendorGroup ctrlVendorGroup = new CmdVendorGroup(request);

            JSPLine ctrLine = new JSPLine();
            Vector listVendorGroup = new Vector(1, 1);

            /*switch statement */
            iErrCode = ctrlVendorGroup.action(iJSPCommand, oidVendorGroup);
            /* end switch*/
            JspVendorGroup jspVendorGroup = ctrlVendorGroup.getForm();

            /*count list All VendorGroup*/
            int vectSize = DbVendorGroup.getCount(whereClause);

            /*switch list VendorGroup*/
            if ((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV) ||
                    (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)) {
                start = ctrlVendorGroup.actionList(iJSPCommand, start, vectSize, recordToGet);
            }
            /* end switch list*/

            VendorGroup vendorGroup = ctrlVendorGroup.getVendorGroup();
            msgString = ctrlVendorGroup.getMessage();

            /* get record to display */
            listVendorGroup = DbVendorGroup.list(start, recordToGet, whereClause, orderClause);

            /*handle condition if size of record to display = 0 and start > 0 	after delete*/
            if (listVendorGroup.size() < 1 && start > 0) {
                if (vectSize - recordToGet > recordToGet) {
                    start = start - recordToGet;
                } //go to JSPCommand.PREV
                else {
                    start = 0;
                    iJSPCommand = JSPCommand.FIRST;
                    prevJSPCommand = JSPCommand.FIRST; //go to JSPCommand.FIRST
                }
                listVendorGroup = DbVendorGroup.list(start, recordToGet, whereClause, orderClause);
            }
%>
<html ><!-- #BeginTemplate "/Templates/indexsp.dwt" -->
    <head>
        <!-- #BeginEditable "javascript" --> 
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <title><%=systemTitle%></title>
        <link href="../css/css.css" rel="stylesheet" type="text/css" />
        <script language="JavaScript">
            <%if (!priv || !privView) {%>
            window.location="<%=approot%>/nopriv.jsp";
            <%}%>
            
            function cmdAdd(){
                document.frmvendorgroup.hidden_vendor_group_id.value="0";
                document.frmvendorgroup.command.value="<%=JSPCommand.ADD%>";
                document.frmvendorgroup.prev_command.value="<%=prevJSPCommand%>";
                document.frmvendorgroup.action="budgetgroup.jsp";
                document.frmvendorgroup.submit();
            }
            
            function cmdAsk(oidVendorGroup){
                document.frmvendorgroup.hidden_vendor_group_id.value=oidVendorGroup;
                document.frmvendorgroup.command.value="<%=JSPCommand.ASK%>";
                document.frmvendorgroup.prev_command.value="<%=prevJSPCommand%>";
                document.frmvendorgroup.action="budgetgroup.jsp";
                document.frmvendorgroup.submit();
            }
            
            function cmdConfirmDelete(oidVendorGroup){
                document.frmvendorgroup.hidden_vendor_group_id.value=oidVendorGroup;
                document.frmvendorgroup.command.value="<%=JSPCommand.DELETE%>";
                document.frmvendorgroup.prev_command.value="<%=prevJSPCommand%>";
                document.frmvendorgroup.action="budgetgroup.jsp";
                document.frmvendorgroup.submit();
            }
            
            function cmdSave(){
                document.frmvendorgroup.command.value="<%=JSPCommand.SAVE%>";
                document.frmvendorgroup.prev_command.value="<%=prevJSPCommand%>";
                document.frmvendorgroup.action="budgetgroup.jsp";
                document.frmvendorgroup.submit();
            }
            
            function cmdEdit(oidVendorGroup){
                document.frmvendorgroup.hidden_vendor_group_id.value=oidVendorGroup;
                document.frmvendorgroup.command.value="<%=JSPCommand.EDIT%>";
                document.frmvendorgroup.prev_command.value="<%=prevJSPCommand%>";
                document.frmvendorgroup.action="budgetgroup.jsp";
                document.frmvendorgroup.submit();
            }
            
            function cmdCancel(oidVendorGroup){
                document.frmvendorgroup.hidden_vendor_group_id.value=oidVendorGroup;
                document.frmvendorgroup.command.value="<%=JSPCommand.EDIT%>";
                document.frmvendorgroup.prev_command.value="<%=prevJSPCommand%>";
                document.frmvendorgroup.action="budgetgroup.jsp";
                document.frmvendorgroup.submit();
            }
            
            function cmdBack(){
                document.frmvendorgroup.command.value="<%=JSPCommand.BACK%>";
                document.frmvendorgroup.action="budgetgroup.jsp";
                document.frmvendorgroup.submit();
            }
            
            function cmdListFirst(){
                document.frmvendorgroup.command.value="<%=JSPCommand.FIRST%>";
                document.frmvendorgroup.prev_command.value="<%=JSPCommand.FIRST%>";
                document.frmvendorgroup.action="budgetgroup.jsp";
                document.frmvendorgroup.submit();
            }
            
            function cmdListPrev(){
                document.frmvendorgroup.command.value="<%=JSPCommand.PREV%>";
                document.frmvendorgroup.prev_command.value="<%=JSPCommand.PREV%>";
                document.frmvendorgroup.action="budgetgroup.jsp";
                document.frmvendorgroup.submit();
            }
            
            function cmdListNext(){
                document.frmvendorgroup.command.value="<%=JSPCommand.NEXT%>";
                document.frmvendorgroup.prev_command.value="<%=JSPCommand.NEXT%>";
                document.frmvendorgroup.action="budgetgroup.jsp";
                document.frmvendorgroup.submit();
            }
            
            function cmdListLast(){
                document.frmvendorgroup.command.value="<%=JSPCommand.LAST%>";
                document.frmvendorgroup.prev_command.value="<%=JSPCommand.LAST%>";
                document.frmvendorgroup.action="budgetgroup.jsp";
                document.frmvendorgroup.submit();
            }
            
            //-------------- script form image -------------------
            
            function cmdDelPict(oidVendorGroup){
                document.frmimage.hidden_vendor_group_id.value=oidVendorGroup;
                document.frmimage.command.value="<%=JSPCommand.POST%>";
                document.frmimage.action="budgetgroup.jsp";
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
            String navigator = "<font class=\"lvl1\">Data Induk</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">Budget Group</span></font>";
                                           %>
                                           <%@ include file="../main/navigator.jsp"%>
                                                    <!-- #EndEditable --></td>
                                                </tr>
                                                <!--tr> 
                      <td><img src="<%=approot%>/imagessp/title-sp.gif" width="584" height="1"></td> 
                                                </tr-->
                                                <tr> 
                                                    <td><!-- #BeginEditable "content" --> 
                                                        <form name="frmvendorgroup" method ="post" action="">
                                                            <input type="hidden" name="command" value="<%=iJSPCommand%>">
                                                            <input type="hidden" name="vectSize" value="<%=vectSize%>">
                                                            <input type="hidden" name="start" value="<%=start%>">
                                                            <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                                                            <input type="hidden" name="hidden_vendor_group_id" value="<%=oidVendorGroup%>">
                                                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr align="left" valign="top"> 
                                                                    <td height="8"  colspan="3" class="container"> 
                                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="8" valign="middle" colspan="3">&nbsp; 
                                                                                </td>
                                                                            </tr>
                                                                            <%
            try {
                                                                            %>
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="22" valign="middle" colspan="3"> 
                                                                                <%= drawList(iJSPCommand, jspVendorGroup, vendorGroup, listVendorGroup, oidVendorGroup)%> </td>
                                                                            </tr>
                                                                            <%
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
                                                                                        <% ctrLine.setLocationImg(approot + "/images/ctr_line");
            ctrLine.initDefault();
                                                                                        %>
                                                                                <%=ctrLine.drawImageListLimit(cmd, vectSize, start, recordToGet)%> </span> </td>
                                                                            </tr>
                                                                            <%if (iJSPCommand != JSPCommand.EDIT && iJSPCommand != JSPCommand.ADD && iJSPCommand != JSPCommand.ASK && (iErrCode == 0)) {%>
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="22" valign="middle" colspan="3">&nbsp;<a href="javascript:cmdAdd()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new21','','../images/new2.gif',1)"><img src="../images/new.gif" name="new21" width="71" height="22" border="0"></a></td>
                                                                            </tr>
                                                                            <%} else {%>
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="22" valign="middle" colspan="3"> 
                                                                                    <%
    ctrLine.setLocationImg(approot + "/images/ctr_line");
    ctrLine.initDefault();
    ctrLine.setTableWidth("60%");
    String scomDel = "javascript:cmdAsk('" + oidVendorGroup + "')";
    String sconDelCom = "javascript:cmdConfirmDelete('" + oidVendorGroup + "')";
    String scancel = "javascript:cmdEdit('" + oidVendorGroup + "')";
    ctrLine.setBackCaption("Back to List");
    ctrLine.setJSPCommandStyle("buttonlink");

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
                                                                                <%= ctrLine.drawImage(iJSPCommand, iErrCode, msgString)%> </td>
                                                                            </tr>
                                                                            <%}%>
                                                                        </table>
                                                                    </td>
                                                                </tr>
                                                                <tr align="left" valign="top"> 
                                                                    <td height="8" valign="middle" width="17%">&nbsp;</td>
                                                                    <td height="8" colspan="2" width="83%">&nbsp; </td>
                                                                </tr>
                                                                <tr align="left" valign="top" > 
                                                                    <td colspan="3" class="command">&nbsp; </td>
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
