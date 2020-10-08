
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.main.db.*" %>
<%@ page import = "com.project.general.*" %>
<%@ page import = "com.project.general.Currency" %>
<%@ include file = "../main/javainit.jsp" %>
<% int appObjCode = 1;%>
<%@ include file = "../main/check.jsp" %>
<%
            boolean priv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_CURRENCY);
            boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_CURRENCY, AppMenu.PRIV_VIEW);
            boolean privUpdate = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_CURRENCY, AppMenu.PRIV_UPDATE);
            boolean privAdd = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_CURRENCY, AppMenu.PRIV_ADD);
            boolean privDelete = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_CURRENCY, AppMenu.PRIV_DELETE);
%>
<!-- Jsp Block -->
<%!
    public String drawList(int iCommand, JspCurrency jspObject, Currency objEntity, Vector objectClass, long currencyOid, String[] lang) {
        JSPList cmdist = new JSPList();
        cmdist.setAreaWidth("100%");
        cmdist.setListStyle("listgen");
        cmdist.setTitleStyle("tablehdr");
        cmdist.setCellStyle("tablecell");
        cmdist.setCellStyle1("tablecell1");
        cmdist.setHeaderStyle("tablehdr");
        cmdist.addHeader(lang[2], "20%");
        cmdist.addHeader(lang[3], "20%");
        cmdist.addHeader(lang[4], "30%");
        cmdist.addHeader(lang[5], "30%");

        cmdist.setLinkRow(0);
        cmdist.setLinkSufix("");
        Vector lstData = cmdist.getData();
        Vector lstLinkData = cmdist.getLinkData();
        Vector rowx = new Vector(1, 1);
        cmdist.reset();
        int index = -1;
        Vector coas = DbCoa.list(0, 0, "", "code");

        for (int i = 0; i < objectClass.size(); i++) {
            Currency currency = (Currency) objectClass.get(i);
            rowx = new Vector();
            if (currencyOid == currency.getOID()) {
                index = i;
            }

            if (index == i && (iCommand == JSPCommand.EDIT || iCommand == JSPCommand.ASK)) {

                Vector coaid_value = new Vector(1, 1);
                Vector coaid_key = new Vector(1, 1);
                String sel_coaid = "" + currency.getCoaId();

                coaid_value.add("- ");
                coaid_key.add("0");

                if (coas != null && coas.size() > 0) {
                    for (int ix = 0; ix < coas.size(); ix++) {
                        Coa coa = (Coa) coas.get(ix);

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

                        coaid_key.add("" + coa.getOID());
                        coaid_value.add(str + coa.getCode() + " - " + coa.getName());
                    }
                }

                rowx.add("<input type=\"text\" name=\"" + jspObject.colNames[JspCurrency.JSP_CURRENCY_CODE] + "\" value=\"" + currency.getCurrencyCode() + "\" class=\"formElemen\" size=\"30\">");
                rowx.add("<input type=\"text\" name=\"" + jspObject.colNames[JspCurrency.JSP_DESCRIPTION] + "\" value=\"" + currency.getDescription() + "\" class=\"formElemen\" size=\"25\">");
                rowx.add("<input type=\"text\" name=\"" + jspObject.colNames[JspCurrency.JSP_RATE] + "\" value=\"" + currency.getRate() + "\" class=\"formElemen\" size=\"25\">");
                rowx.add(JSPCombo.draw(jspObject.colNames[JspCurrency.JSP_COA_ID], null, sel_coaid, coaid_key, coaid_value, "", "formElemen"));
            } else {
                rowx.add("<a href=\"javascript:cmdEdit('" + String.valueOf(currency.getOID()) + "')\">" + currency.getCurrencyCode() + "</a>");
                rowx.add(currency.getDescription());
                rowx.add("" + currency.getRate());
                Coa objCoa = new Coa();
                try {
                    objCoa = DbCoa.fetchExc(currency.getCoaId());
                } catch (Exception e) {
                }
                if (objCoa.getOID() == 0) {
                    rowx.add("-");
                } else {
                    rowx.add("" + objCoa.getCode() + "-" + objCoa.getName());
                }

            }

            lstData.add(rowx);
        }

        rowx = new Vector();

        if (iCommand == JSPCommand.ADD || (iCommand == JSPCommand.SAVE && jspObject.errorSize() > 0)) {
            Vector coaid_value = new Vector(1, 1);
            Vector coaid_key = new Vector(1, 1);
            String sel_coaid = "" + objEntity.getCoaId();

            coaid_value.add("- ");
            coaid_key.add("0");

            if (coas != null && coas.size() > 0) {
                for (int ix = 0; ix < coas.size(); ix++) {
                    Coa coa = (Coa) coas.get(ix);

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

                    coaid_key.add("" + coa.getOID());
                    coaid_value.add(str + coa.getCode() + " - " + coa.getName());
                }
            }
            rowx.add("<input type=\"text\" name=\"" + jspObject.colNames[JspCurrency.JSP_CURRENCY_CODE] + "\" value=\"" + objEntity.getCurrencyCode() + "\" class=\"formElemen\" size=\"30\">" + jspObject.getErrorMsg(jspObject.JSP_CURRENCY_CODE));
            rowx.add("<input type=\"text\" name=\"" + jspObject.colNames[JspCurrency.JSP_DESCRIPTION] + "\" value=\"" + objEntity.getDescription() + "\" class=\"formElemen\" size=\"25\">");
            rowx.add("<input type=\"text\" name=\"" + jspObject.colNames[JspCurrency.JSP_RATE] + "\" value=\"" + objEntity.getRate() + "\" class=\"formElemen\" size=\"25\">");
            rowx.add(JSPCombo.draw(jspObject.colNames[JspCurrency.JSP_COA_ID], null, sel_coaid, coaid_key, coaid_value, "", "formElemen"));

        }

        lstData.add(rowx);

        return cmdist.draw(index);
    }

%>
<%
            int iCommand = JSPRequestValue.requestCommand(request);
            int start = JSPRequestValue.requestInt(request, "start");
            int prevCommand = JSPRequestValue.requestInt(request, "prev_command");
            long oidCurrency = JSPRequestValue.requestLong(request, "hidden_currency_id");
            int showAll = JSPRequestValue.requestInt(request, "show_all");
            /*variable declaration*/
            int recordToGet = 10;
            String msgString = "";
            int iErrCode = JSPMessage.NONE;
            String whereClause = "";
            String orderClause = "";

            CmdCurrency ctrlCurrency = new CmdCurrency(request);
            ctrlCurrency.setUserId(user.getOID());
            JSPLine ctrLine = new JSPLine();
            Vector listCurrency = new Vector(1, 1);

            /*switch statement */
            iErrCode = ctrlCurrency.action(iCommand, oidCurrency);
            /* end switch*/
            JspCurrency jspCurrency = ctrlCurrency.getForm();

            /*count list All Currency*/
            int vectSize = DbCurrency.getCount(whereClause);

            /*switch list Currency*/
            if ((iCommand == JSPCommand.FIRST || iCommand == JSPCommand.PREV) ||
                    (iCommand == JSPCommand.NEXT || iCommand == JSPCommand.LAST)) {
                start = ctrlCurrency.actionList(iCommand, start, vectSize, recordToGet);
            }
            /* end switch list*/

            Currency currency = ctrlCurrency.getCurrency();
            msgString = ctrlCurrency.getMessage();

            /* get record to display */
            listCurrency = DbCurrency.list(start, recordToGet, whereClause, orderClause);

            /*handle condition if size of record to display = 0 and start > 0 	after delete*/
            if (listCurrency.size() < 1 && start > 0) {
                if (vectSize - recordToGet > recordToGet) {
                    start = start - recordToGet;
                } //go to JSPCommand.PREV
                else {
                    start = 0;
                    iCommand = JSPCommand.FIRST;
                    prevCommand = JSPCommand.FIRST; //go to JSPCommand.FIRST
                }
                listCurrency = DbCurrency.list(start, recordToGet, whereClause, orderClause);
            }

            /*** LANG ***/
            String[] langMD = {"Masterdata", "Currency", "Code", "Description", "Rate", "Coa"}; //0-5
            if (lang == LANG_ID) {
                String[] langID = {"Data Induk", "Mata Uang", "Kode", "Keterangan", "Rate", "Coa"}; //0-5
                langMD = langID;
            }
%>
<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
    <head>
        <!-- #BeginEditable "javascript" --> 
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
        <title><%=systemTitle%></title>
        <link href="../css/css.css" rel="stylesheet" type="text/css" />
        <link href="../css/css2.css" rel="stylesheet" type="text/css" />
        <script language="JavaScript">
            
            <%if (!priv || !privView) {%>
            window.location="<%=approot%>/nopriv.jsp";
            <%}%>
            
            function cmdUnShowAll(){                
                document.jspcurrency.command.value="<%=JSPCommand.LIST%>";                
                document.jspcurrency.show_all.value=0;
                document.jspcurrency.action="currency.jsp";
                document.jspcurrency.submit();
            }
            
            function cmdShowAll(){                
                document.jspcurrency.command.value="<%=JSPCommand.LIST%>";                
                document.jspcurrency.show_all.value=1;
                document.jspcurrency.action="currency.jsp";
                document.jspcurrency.submit();
            }
            
            
            function cmdAdd(){
                document.jspcurrency.hidden_currency_id.value="0";
                document.jspcurrency.command.value="<%=JSPCommand.ADD%>";
                document.jspcurrency.prev_command.value="<%=prevCommand%>";
                document.jspcurrency.action="currency.jsp";
                document.jspcurrency.submit();
            }
            
            function cmdAsk(oidCurrency){
                document.jspcurrency.hidden_currency_id.value=oidCurrency;
                document.jspcurrency.command.value="<%=JSPCommand.ASK%>";
                document.jspcurrency.prev_command.value="<%=prevCommand%>";
                document.jspcurrency.action="currency.jsp";
                document.jspcurrency.submit();
            }
            
            function cmdConfirmDelete(oidCurrency){
                document.jspcurrency.hidden_currency_id.value=oidCurrency;
                document.jspcurrency.command.value="<%=JSPCommand.DELETE%>";
                document.jspcurrency.prev_command.value="<%=prevCommand%>";
                document.jspcurrency.action="currency.jsp";
                document.jspcurrency.submit();
            }
            
            function cmdSave(){
                document.jspcurrency.command.value="<%=JSPCommand.SAVE%>";
                document.jspcurrency.prev_command.value="<%=prevCommand%>";
                document.jspcurrency.action="currency.jsp";
                document.jspcurrency.submit();
            }
            
            function cmdEdit(oidCurrency){
                <%if (privUpdate) {%>
                document.jspcurrency.hidden_currency_id.value=oidCurrency;
                document.jspcurrency.command.value="<%=JSPCommand.EDIT%>";
                document.jspcurrency.prev_command.value="<%=prevCommand%>";
                document.jspcurrency.action="currency.jsp";
                document.jspcurrency.submit();
                <%}%>
            }
            
            function cmdCancel(oidCurrency){
                document.jspcurrency.hidden_currency_id.value=oidCurrency;
                document.jspcurrency.command.value="<%=JSPCommand.EDIT%>";
                document.jspcurrency.prev_command.value="<%=prevCommand%>";
                document.jspcurrency.action="currency.jsp";
                document.jspcurrency.submit();
            }
            
            function cmdBack(){
                document.jspcurrency.command.value="<%=JSPCommand.BACK%>";
                document.jspcurrency.action="currency.jsp";
                document.jspcurrency.submit();
            }
            
            function cmdListFirst(){
                document.jspcurrency.command.value="<%=JSPCommand.FIRST%>";
                document.jspcurrency.prev_command.value="<%=JSPCommand.FIRST%>";
                document.jspcurrency.action="currency.jsp";
                document.jspcurrency.submit();
            }
            
            function cmdListPrev(){
                document.jspcurrency.command.value="<%=JSPCommand.PREV%>";
                document.jspcurrency.prev_command.value="<%=JSPCommand.PREV%>";
                document.jspcurrency.action="currency.jsp";
                document.jspcurrency.submit();
            }
            
            function cmdListNext(){
                document.jspcurrency.command.value="<%=JSPCommand.NEXT%>";
                document.jspcurrency.prev_command.value="<%=JSPCommand.NEXT%>";
                document.jspcurrency.action="currency.jsp";
                document.jspcurrency.submit();
            }
            
            function cmdListLast(){
                document.jspcurrency.command.value="<%=JSPCommand.LAST%>";
                document.jspcurrency.prev_command.value="<%=JSPCommand.LAST%>";
                document.jspcurrency.action="currency.jsp";
                document.jspcurrency.submit();
            }
            
            //-------------- script form image -------------------            
            function cmdDelPict(oidCurrency){
                document.jspimage.hidden_currency_code.value=oidCurrency;
                document.jspimage.command.value="<%=JSPCommand.POST%>";
                document.jspimage.action="currency.jsp";
                document.jspimage.submit();
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
                                                        <form name="jspcurrency" method ="post" action="">
                                                            <input type="hidden" name="command" value="<%=iCommand%>">
                                                            <input type="hidden" name="vectSize" value="<%=vectSize%>">
                                                            <input type="hidden" name="start" value="<%=start%>">
                                                            <input type="hidden" name="prev_command" value="<%=prevCommand%>">
                                                            <input type="hidden" name="hidden_currency_id" value="<%=oidCurrency%>">
                                                            <input type="hidden" name="show_all" value="0">
                                                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>">     
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr>
                                                                    <td class="container"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="8"  colspan="3"> 
                                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="8" valign="middle" colspan="3" class="listtitle"></td>
                                                                                        </tr>
                                                                                        <%
            try {
                                                                                        %>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="22" valign="middle" colspan="3"> 
                                                                                                <table width="80%" border="0" cellspacing="0" cellpadding="0">
                                                                                                    <tr>
                                                                                                        <td class="boxed1"><%= drawList(iCommand, jspCurrency, currency, listCurrency, oidCurrency, langMD)%></td>
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
            if ((iCommand == JSPCommand.FIRST || iCommand == JSPCommand.PREV) ||
                    (iCommand == JSPCommand.NEXT || iCommand == JSPCommand.LAST)) {
                cmd = iCommand;
            } else {
                if (iCommand == JSPCommand.NONE || prevCommand == JSPCommand.NONE) {
                    cmd = JSPCommand.FIRST;
                } else {
                    cmd = prevCommand;
                }
            }
                                                                                        %>
                                                                                        <% ctrLine.setLocationImg(approot + "/images/ctr_line");
            ctrLine.initDefault();
                                                                                        %>
                                                                                <%=ctrLine.drawImageListLimit(cmd, vectSize, start, recordToGet)%> </span>  </td>
                                                                                        </tr>
                                                                                        
                                                                                        <%if (iCommand != JSPCommand.EDIT && iCommand != JSPCommand.ADD && iCommand != JSPCommand.ASK && iErrCode == 0) {%>
                                                                                        <tr align="left" valign="top">
                                                                                            <td height="14" valign="middle" colspan="3">&nbsp;</td>
                                                                                        </tr>
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
                                                                                <td height="8" valign="middle" width="17%">&nbsp;</td>
                                                                                <td height="8" colspan="2" width="83%">&nbsp; </td>
                                                                            </tr>
                                                                            <tr align="left" valign="top" > 
                                                                                <td colspan="3" class="command"> 
                                                                                    <%
            ctrLine.setLocationImg(approot + "/images/ctr_line");
            ctrLine.initDefault();
            ctrLine.setTableWidth("80%");
            String scomDel = "javascript:cmdAsk('" + oidCurrency + "')";
            String sconDelCom = "javascript:cmdConfirmDelete('" + oidCurrency + "')";
            String scancel = "javascript:cmdEdit('" + oidCurrency + "')";
            ctrLine.setBackCaption("Back to List");
            ctrLine.setJSPCommandStyle("buttonlink");
            ctrLine.setDeleteCaption("");
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
                                                                                    <%if (iCommand == JSPCommand.EDIT || iCommand == JSPCommand.ADD || iCommand == JSPCommand.ASK || iErrCode != 0) {%>
                                                                                    <%= ctrLine.drawImageOnly(iCommand, iErrCode, msgString)%> 
                                                                                    <%}%>
                                                                                </td>
                                                                            </tr>
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="8" valign="middle" width="17%">&nbsp;</td>
                                                                                <td height="8" colspan="2" width="83%">&nbsp; </td>
                                                                            </tr>
                                                                            <tr align="left" valign="top">                                                                                 
                                                                                <td height="8" colspan="3" >
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
            int countx = DbHistoryUser.getCount(DbHistoryUser.colNames[DbHistoryUser.COL_TYPE] + " = " + DbHistoryUser.TYPE_CURRENCY);
            Vector historys = DbHistoryUser.list(0, max, DbHistoryUser.colNames[DbHistoryUser.COL_TYPE] + " = " + DbHistoryUser.TYPE_CURRENCY, DbHistoryUser.colNames[DbHistoryUser.COL_DATE] + " desc");
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

                    SegmentDetail sdx = new SegmentDetail();
                    try {
                        sdx = DbSegmentDetail.fetchExc(hu.getRefId());
                    } catch (Exception ex) {
                    }
                    String desc = "";
                    if (sdx.getOID() != 0 && sdx.getName() != null && sdx.getName().length() > 0) {
                        desc = desc + sdx.getName() + " : ";
                    }

                    desc = desc + hu.getDescription();
                                                                                        %>
                                                                                        <tr>
                                                                                            <td colspan="3" height="1" bgcolor="#CCCCCC"></td>
                                                                                        </tr>
                                                                                        <tr>
                                                                                            <td class="fontarial" style=padding:3px;><%=JSPFormater.formatDate(hu.getDate(), "dd MMM yyyy HH:mm:ss ")%></td>
                                                                                            <td class="fontarial" style=padding:3px;><i><%=desc%></i></td>
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