
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.fms.master.*" %>
<%@ page import = "com.project.fms.activity.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ include file = "../main/javainit.jsp" %>
<% int appObjCode = 1;%>
<%@ include file = "../main/check.jsp" %>
<%
            boolean masterPriv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_ACCOUNTING);
            boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_ACCOUNTING, AppMenu.PRIV_VIEW);
            boolean privUpdate = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_ACCOUNTING, AppMenu.PRIV_UPDATE);
            boolean privAdd = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_ACCOUNTING, AppMenu.PRIV_ADD);
            boolean privDelete = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_ACCOUNTING, AppMenu.PRIV_DELETE);
%>
<!-- Jsp Block -->
<%!
    public String drawList(Vector objectClass, long coaId) {
        JSPList ctrlist = new JSPList();
        ctrlist.setAreaWidth("50%");
        ctrlist.setListStyle("listgen");
        ctrlist.setTitleStyle("tablehdr");
        ctrlist.setCellStyle("tablecell");
        ctrlist.setHeaderStyle("tablehdr");
        ctrlist.addHeader("Code", "20%");
        ctrlist.addHeader("Name", "20%");
        ctrlist.addHeader("Level", "20%");
        ctrlist.addHeader("Department Name", "20%");
        ctrlist.addHeader("Section Name", "20%");

        ctrlist.setLinkRow(0);
        ctrlist.setLinkSufix("");
        Vector lstData = ctrlist.getData();
        Vector lstLinkData = ctrlist.getLinkData();
        ctrlist.setLinkPrefix("javascript:cmdEdit('");
        ctrlist.setLinkSufix("')");
        ctrlist.reset();
        int index = -1;

        for (int i = 0; i < objectClass.size(); i++) {
            Coa coa = (Coa) objectClass.get(i);
            Vector rowx = new Vector();
            if (coaId == coa.getOID()) {
                index = i;
            }

            rowx.add(coa.getCode());

            rowx.add(coa.getName());

            rowx.add(String.valueOf(coa.getLevel()));

            rowx.add(coa.getDepartmentName());

            rowx.add(coa.getSectionName());

            lstData.add(rowx);
            lstLinkData.add(String.valueOf(coa.getOID()));
        }

        return ctrlist.drawList(index);
    }

%>
<%
            int iJSPCommand = JSPRequestValue.requestCommand(request);
            int start = JSPRequestValue.requestInt(request, "start");
            int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
            long oidCoa = JSPRequestValue.requestLong(request, "hidden_coa_id");
            String accGroup = JSPRequestValue.requestString(request, "acc_group");
            double budget = JSPRequestValue.requestDouble(request, "budget");
            long periodeId = JSPRequestValue.requestLong(request, "open_period");

            Vector departments = DbDepartment.list(0, 0, "", "name");
            Vector sections = DbSection.list(0, 0, "", "name");

            /*variable declaration*/
            int recordToGet = 10;
            String msgString = "";
            int iErrCode = JSPMessage.NONE;
            String whereClause = "account_group='" + accGroup + "'";
            String orderClause = "";

            CmdCoa_1 ctrlCoa = new CmdCoa_1(request);
            JSPLine ctrLine = new JSPLine();
            Vector listCoa = new Vector(1, 1);

            /*switch statement */
            iErrCode = ctrlCoa.action(iJSPCommand, oidCoa);
            /* end switch*/
            JspCoa_1 jspCoa_1 = ctrlCoa.getForm();

//out.println(jspCoa_1.getErrors());

            /*count list All Coa*/
            int vectSize = DbCoa.getCount(whereClause);

            Coa coa = ctrlCoa.getCoa();
            msgString = ctrlCoa.getMessage();

            if (oidCoa == 0) {
                oidCoa = coa.getOID();
            }



            boolean isOpeningEditable = false;
            if (DbPeriode.getCount("") == 1) {
                isOpeningEditable = true;
            }

//out.println("isOpeningEditable : "+isOpeningEditable);
//out.println("DbPeriode.getCount() : "+(DbPeriode.getCount("")));

//out.println("<br>iJSPCommand : "+iJSPCommand);
//out.println("msgString : "+msgString);
//out.println("iErrCode : "+iErrCode);
%>
<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
    <head>
        <!-- #BeginEditable "javascript" --> 
        <title><%=systemTitle%></title>
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
        <link href="../css/default.css" rel="stylesheet" type="text/css" />
        <link href="../css/css.css" rel="stylesheet" type="text/css" />
        <script language="JavaScript" src="../main/common.js"></script>
        <script language="JavaScript">
            <%if (!masterPriv || !privView || !privUpdate) {%>
            window.location="<%=approot%>/nopriv.jsp";
            <%}%>
            
            var sysDecSymbol = "<%=sSystemDecimalSymbol%>";
            var usrDigitGroup = "<%=sUserDigitGroup%>";
            var usrDecSymbol = "<%=sUserDecimalSymbol%>";
            
            function cmdAdd(){
                document.frmcoa.hidden_coa_id.value="0";
                document.frmcoa.command.value="<%=JSPCommand.ADD%>";
                document.frmcoa.prev_command.value="<%=prevJSPCommand%>";
                document.frmcoa.action="coaedtextra.jsp";
                document.frmcoa.submit();
            }
            
            function cmdAsk(oidCoa){
                document.frmcoa.hidden_coa_id.value=oidCoa;
                document.frmcoa.command.value="<%=JSPCommand.ASK%>";
                document.frmcoa.prev_command.value="<%=prevJSPCommand%>";
                document.frmcoa.action="coaedtextra.jsp";
                document.frmcoa.submit();
            }
            
            function cmdConfirmDelete(oidCoa){
                document.frmcoa.hidden_coa_id.value=oidCoa;
                document.frmcoa.command.value="<%=JSPCommand.DELETE%>";
                document.frmcoa.prev_command.value="<%=prevJSPCommand%>";
                document.frmcoa.action="coaedtextra.jsp";
                document.frmcoa.submit();
            }
            function cmdSave(){
                document.frmcoa.command.value="<%=JSPCommand.SAVE%>";
                document.frmcoa.prev_command.value="<%=prevJSPCommand%>";
                document.frmcoa.action="coaedtextra.jsp";
                document.frmcoa.submit();
            }
            
            function cmdEdit(oidCoa){
                document.frmcoa.hidden_coa_id.value=oidCoa;
                document.frmcoa.command.value="<%=JSPCommand.EDIT%>";
                document.frmcoa.prev_command.value="<%=prevJSPCommand%>";
                document.frmcoa.action="coaedtextra.jsp";
                document.frmcoa.submit();
            }
            
            function cmdCancel(oidCoa){
                document.frmcoa.hidden_coa_id.value=oidCoa;
                document.frmcoa.command.value="<%=JSPCommand.EDIT%>";
                document.frmcoa.prev_command.value="<%=prevJSPCommand%>";
                document.frmcoa.action="coaedtextra.jsp";
                document.frmcoa.submit();
            }
            
            function cmdBack(){
                document.frmcoa.command.value="<%=JSPCommand.BACK%>";
                document.frmcoa.action="coa.jsp";
                document.frmcoa.submit();
            }
            
            function cmdListFirst(){
                document.frmcoa.command.value="<%=JSPCommand.FIRST%>";
                document.frmcoa.prev_command.value="<%=JSPCommand.FIRST%>";
                document.frmcoa.action="coaedtextra.jsp";
                document.frmcoa.submit();
            }
            
            function cmdListPrev(){
                document.frmcoa.command.value="<%=JSPCommand.PREV%>";
                document.frmcoa.prev_command.value="<%=JSPCommand.PREV%>";
                document.frmcoa.action="coaedtextra.jsp";
                document.frmcoa.submit();
            }
            
            function cmdListNext(){
                document.frmcoa.command.value="<%=JSPCommand.NEXT%>";
                document.frmcoa.prev_command.value="<%=JSPCommand.NEXT%>";
                document.frmcoa.action="coaedtextra.jsp";
                document.frmcoa.submit();
            }
            
            function cmdListLast(){
                document.frmcoa.command.value="<%=JSPCommand.LAST%>";
                document.frmcoa.prev_command.value="<%=JSPCommand.LAST%>";
                document.frmcoa.action="coaedtextra.jsp";
                document.frmcoa.submit();
            }
            
            function cmdDept(){
                document.frmcoa.command.value="<%=JSPCommand.SUBMIT%>";	
                document.frmcoa.action="coaedtextra.jsp";
                document.frmcoa.submit();
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
            String navigator = "<font class=\"lvl1\">Master</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">Chart Of Account Extra Data</span></font>";
                                           %>
                                           <%@ include file="../main/navigator.jsp"%>
                                                    <!-- #EndEditable --></td>
                                                </tr>
                                                <!--tr> 
                      <td><img src="<%=approot%>/images/title-sp.gif" width="584" height="1"></td> 
                                                </tr-->
                                                <tr> 
                                                    <td><!-- #BeginEditable "content" --> 
                                                        <form name="frmcoa" method ="post" action="">
                                                            <input type="hidden" name="command" value="<%=iJSPCommand%>">
                                                            <input type="hidden" name="vectSize" value="<%=vectSize%>">
                                                            <input type="hidden" name="start" value="<%=start%>">
                                                            <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                                                            <input type="hidden" name="hidden_coa_id" value="<%=oidCoa%>">
                                                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr> 
                                                                    <td class="container"> 
                                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="8" valign="middle" colspan="3" class="page"> 
                                                                                    <table width="100%" border="0" cellspacing="1" cellpadding="0">
                                                                                        <tr align="left"> 
                                                                                            <td height="8" valign="middle" width="17%"></td>
                                                                                            <td height="8" colspan="2" width="83%" class="comment" valign="top"></td>
                                                                                        </tr>
                                                                                        <tr align="left"> 
                                                                                            <td height="21" valign="middle" colspan="3"> 
                                                                                                <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                                                                                    <tr > 
                                                                                                        <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="17" height="10"></td>
                                                                                                        <td class="tabin"> 
                                                                                                            <div align="center">&nbsp;&nbsp;<a href="coa.jsp?command=<%=JSPCommand.LIST%>" class="tablink">Records</a>&nbsp;&nbsp;</div>
                                                                                                        </td>
                                                                                                        <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                                                                                        <td class="tabin"> 
                                                                                                            <div align="center">&nbsp;&nbsp;<a href="coaedt.jsp?command=<%=JSPCommand.EDIT%>&hidden_coa_id=<%=oidCoa%>" class="tablink">Editor</a>&nbsp;&nbsp;</div>
                                                                                                        </td>
                                                                                                        <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                                                                                        <td class="tab"> 
                                                                                                            <div align="center">&nbsp;&nbsp;Extra&nbsp;&nbsp;</div>
                                                                                                        </td>
                                                                                                        <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                                                                                        <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                                                                                        <td width="100%" class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="10" height="10"></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            <font color="#006633"><i></i></font></td>
                                                                                        </tr>
                                                                                        <%if (msgString.length() > 0) {%>
                                                                                        <tr align="left"> 
                                                                                            <td height="21" colspan="3" width="83%" class="comment" valign="top">&nbsp;</td>
                                                                                        </tr>
                                                                                        <tr align="left"> 
                                                                                            <td height="21" colspan="3" width="83%" class="comment" valign="top"><font color="#009900"><i><%=msgString%></i></font></td>
                                                                                        </tr>
                                                                                        <%}%>
                                                                                        <tr align="left"> 
                                                                                            <td height="21" valign="middle" width="17%">&nbsp;</td>
                                                                                            <td height="21" colspan="2" width="83%" class="comment" valign="top">&nbsp;</td>
                                                                                        </tr>
                                                                                        <tr align="left"> 
                                                                                            <td height="21" valign="middle" width="17%">&nbsp;</td>
                                                                                            <td height="21" colspan="2" width="83%" class="comment" valign="top">*)= 
                                                                                            required</td>
                                                                                        </tr>
                                                                                        <tr align="left"> 
                                                                                        <td height="21" width="17%">&nbsp;&nbsp;Account 
                                                                                        Number</td>
                                                                                        <td height="21" colspan="2" width="83%"> 
                                                                                        <%= coa.getCode() %>
                                                                                        <tr align="left"> 
                                                                                        <td height="21" width="17%">&nbsp;&nbsp;Account 
                                                                                        Name</td>
                                                                                        <td height="21" colspan="2" width="83%"> 
                                                                                        <%= coa.getName() %>
                                                                                        <tr align="left"> 
                                                                                        <td height="21" width="17%">&nbsp;</td>
                                                                                        <td height="21" colspan="2" width="83%">&nbsp; 
                                                                                        <tr align="left"> 
                                                                                        <td height="21" width="17%">&nbsp;&nbsp;<b>Extra 
                                                                                        Data</b></td>
                                                                                        <td height="21" colspan="2" width="83%">&nbsp; 
                                                                                        <tr align="left"> 
                                                                                        <td height="21" width="17%">&nbsp;&nbsp;Debet 
                                                                                        Prefix Code</td>
                                                                                        <td height="21" colspan="2" width="83%"> 
                                                                                        <input type="text" name="<%=jspCoa_1.colNames[JspCoa_1.JSP_DEBET_PREFIX_CODE] %>"  value="<%= coa.getDebetPrefixCode() %>" class="formElemen" size="45">
                                                                                        * <%= jspCoa_1.getErrorMsg(JspCoa_1.JSP_DEBET_PREFIX_CODE) %> 
                                                                                        <tr align="left"> 
                                                                                        <td height="21" width="17%">&nbsp;&nbsp;Credit 
                                                                                        Prefix Code</td>
                                                                                        <td height="21" colspan="2" width="83%"> 
                                                                                        <input type="text" name="<%=jspCoa_1.colNames[JspCoa_1.JSP_CREDIT_PREFIX_CODE] %>"  value="<%= coa.getCreditPrefixCode() %>" class="formElemen" size="45">
                                                                                        * <%= jspCoa_1.getErrorMsg(JspCoa_1.JSP_CREDIT_PREFIX_CODE) %> 
                                                                                        <tr align="left"> 
                                                                                            <td height="8" valign="middle" width="17%">&nbsp;</td>
                                                                                            <td height="8" colspan="2" width="83%" valign="top">&nbsp;</td>
                                                                                        </tr>
                                                                                        <tr align="left" > 
                                                                                            <td colspan="3" class="command" valign="top"> 
                                                                                                <%
            ctrLine.setLocationImg(approot + "/images/ctr_line");
            ctrLine.initDefault();
            ctrLine.setTableWidth("50%");
            String scomDel = "javascript:cmdAsk('" + oidCoa + "')";
            String sconDelCom = "javascript:cmdConfirmDelete('" + oidCoa + "')";
            String scancel = "javascript:cmdEdit('" + oidCoa + "')";
            ctrLine.setBackCaption("");
            ctrLine.setJSPCommandStyle("buttonlink");
            ctrLine.setDeleteCaption("");
            ctrLine.setSaveCaption("Save");
            ctrLine.setAddCaption("");

            if (privDelete) {
                ctrLine.setConfirmDelJSPCommand(sconDelCom);
                ctrLine.setDeleteJSPCommand(scomDel);
                ctrLine.setEditJSPCommand(scancel);
            } else {
                ctrLine.setConfirmDelCaption("");
                ctrLine.setDeleteCaption("");
                ctrLine.setEditCaption("");
            }


            ctrLine.setOnMouseOut("MM_swapImgRestore()");
            ctrLine.setOnMouseOverSave("MM_swapImage('save','','" + approot + "/images/save2.gif',1)");
            ctrLine.setSaveImage("<img src=\"" + approot + "/images/save.gif\" name=\"save\" height=\"22\" border=\"0\">");

            //ctrLine.setOnMouseOut("MM_swapImgRestore()");
            ctrLine.setOnMouseOverBack("MM_swapImage('back','','" + approot + "/images/back2.gif',1)");
            ctrLine.setBackImage("<img src=\"" + approot + "/images/back.gif\" name=\"back\" height=\"22\" border=\"0\">");

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

            if (privAdd == false && privUpdate == false) {
                ctrLine.setSaveCaption("");
            }

            if (privAdd == false) {
                ctrLine.setAddCaption("");
            }

            try {

                                                                                                %>
                                                                                                <%= ctrLine.drawImageOnly(iJSPCommand, iErrCode, msgString)%>
                                                                                                <%} catch (Exception e) {
                out.println(e.toString());
            }%>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr> 
                                                                                            <td width="17%">&nbsp;</td>
                                                                                            <td width="83%">&nbsp;</td>
                                                                                        </tr>
                                                                                        <tr align="left" > 
                                                                                            <td colspan="3" valign="top"> 
                                                                                                <div align="left"></div>
                                                                                            </td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </td>
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
