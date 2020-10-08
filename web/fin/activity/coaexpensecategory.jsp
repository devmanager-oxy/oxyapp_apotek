
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.main.entity.*" %>
<%@ page import = "com.project.fms.activity.*" %>
<%@ page import = "com.project.*" %>
<%@ include file = "../main/javainit.jsp" %>
<%@ include file = "../main/check.jsp" %>
<% int appObjCode = 1; %>
<%
            boolean priv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_ACCOUNTING);
            boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_ACCOUNTING, AppMenu.PRIV_VIEW);
            boolean privUpdate = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_ACCOUNTING, AppMenu.PRIV_UPDATE);
            boolean privAdd = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_ACCOUNTING, AppMenu.PRIV_ADD);
            boolean privDelete = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_ACCOUNTING, AppMenu.PRIV_DELETE);
%>
<!-- Jsp Block -->
<%!
    public String drawList(int iJSPCommand, JspCoaCategory frmObject, CoaCategory objEntity, Vector objectClass,
            long coaCoaCategoryId, int iErrCode, String[] lang) {
        JSPList ctrlist = new JSPList();
        ctrlist.setAreaWidth("100%");
        ctrlist.setListStyle("listgen");
        ctrlist.setTitleStyle("tablehdr");
        ctrlist.setCellStyle("tablecell");
        ctrlist.setCellStyle1("tablecell1");
        ctrlist.setHeaderStyle("tablehdr");
        ctrlist.addHeader(lang[2], "30%");
        ctrlist.addHeader(lang[3], "70%");

        ctrlist.setLinkRow(0);
        ctrlist.setLinkSufix("");
        Vector lstData = ctrlist.getData();
        Vector lstLinkData = ctrlist.getLinkData();
        Vector rowx = new Vector(1, 1);
        ctrlist.reset();
        int index = -1;

        Vector type_value = new Vector(1, 1);
        Vector type_key = new Vector(1, 1);
        for (int i = 0; i < DbCoaCategory.strType.length; i++) {
            type_key.add(DbCoaCategory.strType[i]);
            type_value.add("" + i);
        }

        for (int i = 0; i < objectClass.size(); i++) {
            CoaCategory expenseCategory = (CoaCategory) objectClass.get(i);
            rowx = new Vector();
            if (coaCoaCategoryId == expenseCategory.getOID()) {
                index = i;
            }

            if (index == i && ((iJSPCommand == JSPCommand.EDIT || iJSPCommand == JSPCommand.ASK) || (iErrCode != 0 && objEntity.getOID() != 0))) {
                rowx.add(JSPCombo.draw(frmObject.colNames[frmObject.JSP_TYPE], null, "" + expenseCategory.getType(), type_value, type_key, "", "formElemen"));
                rowx.add("<input type=\"text\" size=\"50\" name=\"" + frmObject.colNames[JspCoaCategory.JSP_NAME] + "\" value=\"" + expenseCategory.getName() + "\" class=\"formElemen\">");
            } else {
                rowx.add(DbCoaCategory.strType[expenseCategory.getType()]);
                rowx.add("<a href=\"javascript:cmdEdit('" + String.valueOf(expenseCategory.getOID()) + "')\">" + expenseCategory.getName() + "</a>");
            }

            lstData.add(rowx);
        }

        rowx = new Vector();

        if (iJSPCommand == JSPCommand.ADD || (iJSPCommand == JSPCommand.SAVE && frmObject.errorSize() > 0) || (objEntity.getOID() == 0 && iErrCode != 0)) {
            rowx.add(JSPCombo.draw(frmObject.colNames[frmObject.JSP_TYPE], null, "" + objEntity.getType(), type_value, type_key, "", "formElemen"));
            rowx.add("<input type=\"text\"  size=\"50\"  name=\"" + frmObject.colNames[JspCoaCategory.JSP_NAME] + "\" value=\"" + objEntity.getName() + "\" class=\"formElemen\">");

        }

        lstData.add(rowx);

        return ctrlist.draw(index);
    }

%>
<%
            int iJSPCommand = JSPRequestValue.requestCommand(request);
            int start = JSPRequestValue.requestInt(request, "start");
            int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
            long oidCoaCategory = JSPRequestValue.requestLong(request, "hidden_coa_expense_category_id");

            /*variable declaration*/
            int recordToGet = 15;
            String msgString = "";
            int iErrCode = JSPMessage.NONE;
            String whereClause = "";
            String orderClause = "type";

            CmdCoaCategory ctrlCoaCategory = new CmdCoaCategory(request);
            JSPLine ctrLine = new JSPLine();
            Vector listCoaCategory = new Vector(1, 1);

            /*switch statement */
            iErrCode = ctrlCoaCategory.action(iJSPCommand, oidCoaCategory, user.getOID(), sysCompany.getOID());
            /* end switch*/
            JspCoaCategory jspCoaCategory = ctrlCoaCategory.getForm();

            /*count list All CoaCategory*/
            int vectSize = DbCoaCategory.getCount(whereClause);

            /*switch list CoaCategory*/
            if ((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV) ||
                    (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)) {
                start = ctrlCoaCategory.actionList(iJSPCommand, start, vectSize, recordToGet);
            }
            /* end switch list*/

            CoaCategory expenseCategory = ctrlCoaCategory.getCoaCategory();
            msgString = ctrlCoaCategory.getMessage();

            /* get record to display */
            listCoaCategory = DbCoaCategory.list(start, recordToGet, whereClause, orderClause);

            /*handle condition if size of record to display = 0 and start > 0 	after delete*/
            if (listCoaCategory.size() < 1 && start > 0) {
                if (vectSize - recordToGet > recordToGet) {
                    start = start - recordToGet;
                } //go to JSPCommand.PREV
                else {
                    start = 0;
                    iJSPCommand = JSPCommand.FIRST;
                    prevJSPCommand = JSPCommand.FIRST; //go to JSPCommand.FIRST
                }
                listCoaCategory = DbCoaCategory.list(start, recordToGet, whereClause, orderClause);
            }

            /*** LANG ***/
            String[] langMD = {"Masterdata", "Account Category", "Type", "Description"};
            if (lang == LANG_ID) {
                String[] langID = {"Data Induk", "Kategori Perkiraan", "Tipe", "Keterangan"};
                langMD = langID;
            }
%>
<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
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
                document.frmexpensecategory.hidden_coa_expense_category_id.value="0";
                document.frmexpensecategory.command.value="<%=JSPCommand.ADD%>";
                document.frmexpensecategory.prev_command.value="<%=prevJSPCommand%>";
                document.frmexpensecategory.action="coaexpensecategory.jsp";
                document.frmexpensecategory.submit();
            }
            
            function cmdAsk(oidCoaCategory){
                document.frmexpensecategory.hidden_coa_expense_category_id.value=oidCoaCategory;
                document.frmexpensecategory.command.value="<%=JSPCommand.ASK%>";
                document.frmexpensecategory.prev_command.value="<%=prevJSPCommand%>";
                document.frmexpensecategory.action="coaexpensecategory.jsp";
                document.frmexpensecategory.submit();
            }
            
            function cmdConfirmDelete(oidCoaCategory){
                document.frmexpensecategory.hidden_coa_expense_category_id.value=oidCoaCategory;
                document.frmexpensecategory.command.value="<%=JSPCommand.DELETE%>";
                document.frmexpensecategory.prev_command.value="<%=prevJSPCommand%>";
                document.frmexpensecategory.action="coaexpensecategory.jsp";
                document.frmexpensecategory.submit();
            }
            
            function cmdSave(){
                document.frmexpensecategory.command.value="<%=JSPCommand.SAVE%>";
                document.frmexpensecategory.prev_command.value="<%=prevJSPCommand%>";
                document.frmexpensecategory.action="coaexpensecategory.jsp";
                document.frmexpensecategory.submit();
            }
            
            function cmdEdit(oidCoaCategory){
                <%if (privUpdate) {%>
                document.frmexpensecategory.hidden_coa_expense_category_id.value=oidCoaCategory;
                document.frmexpensecategory.command.value="<%=JSPCommand.EDIT%>";
                document.frmexpensecategory.prev_command.value="<%=prevJSPCommand%>";
                document.frmexpensecategory.action="coaexpensecategory.jsp";
                document.frmexpensecategory.submit();
                <%}%>
            }
            
            function cmdCancel(oidCoaCategory){
                document.frmexpensecategory.hidden_coa_expense_category_id.value=oidCoaCategory;
                document.frmexpensecategory.command.value="<%=JSPCommand.EDIT%>";
                document.frmexpensecategory.prev_command.value="<%=prevJSPCommand%>";
                document.frmexpensecategory.action="coaexpensecategory.jsp";
                document.frmexpensecategory.submit();
            }
            
            function cmdBack(){
                document.frmexpensecategory.command.value="<%=JSPCommand.BACK%>";
                document.frmexpensecategory.action="coaexpensecategory.jsp";
                document.frmexpensecategory.submit();
            }
            
            function cmdListFirst(){
                document.frmexpensecategory.command.value="<%=JSPCommand.FIRST%>";
                document.frmexpensecategory.prev_command.value="<%=JSPCommand.FIRST%>";
                document.frmexpensecategory.action="coaexpensecategory.jsp";
                document.frmexpensecategory.submit();
            }
            
            function cmdListPrev(){
                document.frmexpensecategory.command.value="<%=JSPCommand.PREV%>";
                document.frmexpensecategory.prev_command.value="<%=JSPCommand.PREV%>";
                document.frmexpensecategory.action="coaexpensecategory.jsp";
                document.frmexpensecategory.submit();
            }
            
            function cmdListNext(){
                document.frmexpensecategory.command.value="<%=JSPCommand.NEXT%>";
                document.frmexpensecategory.prev_command.value="<%=JSPCommand.NEXT%>";
                document.frmexpensecategory.action="coaexpensecategory.jsp";
                document.frmexpensecategory.submit();
            }
            
            function cmdListLast(){
                document.frmexpensecategory.command.value="<%=JSPCommand.LAST%>";
                document.frmexpensecategory.prev_command.value="<%=JSPCommand.LAST%>";
                document.frmexpensecategory.action="coaexpensecategory.jsp";
                document.frmexpensecategory.submit();
            }
            
            //-------------- script form image -------------------
            
            function cmdDelPict(oidCoaCategory){
                document.frmimage.hidden_coa_expense_category_id.value=oidCoaCategory;
                document.frmimage.command.value="<%=JSPCommand.POST%>";
                document.frmimage.action="coaexpensecategory.jsp";
                document.frmimage.submit();
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
            String navigator = "<font class=\"lvl1\">" + langMD[0] + "</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">" + langMD[1] + "</span></font>";
                                           %>
                                           <%@ include file="../main/navigator.jsp"%>
                                                    <!-- #EndEditable --></td>
                                                </tr>
                                                <!--tr> 
                      <td><img src="<%=approot%>/images/title-sp.gif" width="584" height="1"></td> 
                                                </tr-->
                                                <tr> 
                                                    <td><!-- #BeginEditable "content" --> 
                                                        <form name="frmexpensecategory" method ="post" action="">
                                                            <input type="hidden" name="command" value="<%=iJSPCommand%>">
                                                            <input type="hidden" name="vectSize" value="<%=vectSize%>">
                                                            <input type="hidden" name="start" value="<%=start%>">
                                                            <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                                                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                            <input type="hidden" name="hidden_coa_expense_category_id" value="<%=oidCoaCategory%>">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr>
                                                                    <td class="container"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="8"  colspan="3"> 
                                                                                    <table width="73%" border="0" cellspacing="0" cellpadding="0">
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="8" valign="middle" colspan="3">&nbsp; 
                                                                                            </td>
                                                                                        </tr>
                                                                                        <%
            try {
                                                                                        %>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="22" valign="middle" colspan="3" class="boxed1"> 
                                                                                            <%= drawList(iJSPCommand, jspCoaCategory, expenseCategory, listCoaCategory, oidCoaCategory, iErrCode, langMD)%> </td>
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
                                                                                        <%
            if (iJSPCommand != JSPCommand.EDIT && iJSPCommand != JSPCommand.ADD && iJSPCommand != JSPCommand.ASK && iErrCode == 0) {
                                                                                        %>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="22" valign="middle" colspan="3">
                                                                                                <%if (privAdd){%>
                                                                                                <a href="javascript:cmdAdd()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new21','','../images/new2.gif',1)"><img src="../images/new.gif" name="new21" width="71" height="22" border="0"></a>
                                                                                                <%} else {%>
                                                                                                &nbsp;
                                                                                                <%}%>
                                                                                            </td>
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
                                                                                <td colspan="3" class="command"> 
                                                                                    <%
            ctrLine.setLocationImg(approot + "/images/ctr_line");
            ctrLine.initDefault();
            ctrLine.setTableWidth("80%");
            String scomDel = "javascript:cmdAsk('" + oidCoaCategory + "')";
            String sconDelCom = "javascript:cmdConfirmDelete('" + oidCoaCategory + "')";
            String scancel = "javascript:cmdEdit('" + oidCoaCategory + "')";
            ctrLine.setBackCaption("Back to List");
            ctrLine.setJSPCommandStyle("buttonlink");

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

            if (privAdd == false){
                ctrLine.setAddCaption("");
            }
                                                                                    %>
                                                                                    <%
            if (iJSPCommand == JSPCommand.EDIT || iJSPCommand == JSPCommand.ADD || iJSPCommand == JSPCommand.ASK || iErrCode != 0) {
                                                                                    %>
                                                                                    <%= ctrLine.drawImageOnly(iJSPCommand, iErrCode, msgString)%> 
                                                                                    <%}%>
                                                                                </td>
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
