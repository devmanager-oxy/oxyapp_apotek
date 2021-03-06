
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
<%@ page import = "com.project.general.*" %>
<%@ page import = "com.project.payroll.*" %>
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
    public String drawList(int iJSPCommand, JspPaymentMethod frmObject, PaymentMethod objEntity, Vector objectClass,
            long paymentMethodId, String[] lang) {
        JSPList ctrlist = new JSPList();
        ctrlist.setAreaWidth("100%");
        ctrlist.setListStyle("listgen");
        ctrlist.setTitleStyle("tablehdr");
        ctrlist.setCellStyle("tablecell");
        ctrlist.setCellStyle1("tablecell1");
        ctrlist.setHeaderStyle("tablehdr");
        ctrlist.addHeader(lang[2], "10%");
        ctrlist.addHeader(lang[3], "10%");
        ctrlist.addHeader(lang[4], "10%");
        ctrlist.addHeader(lang[5], "20%");
        ctrlist.addHeader(lang[6], "20%");
        ctrlist.addHeader(lang[7], "10%");
        ctrlist.addHeader(lang[8], "10%");
        ctrlist.addHeader(lang[9], "10%");

        ctrlist.setLinkRow(0);
        ctrlist.setLinkSufix("");
        Vector lstData = ctrlist.getData();
        Vector lstLinkData = ctrlist.getLinkData();
        Vector rowx = new Vector(1, 1);
        ctrlist.reset();
        int index = -1;
        
        Vector listSegment = DbSegment.list(0, 0, DbSegment.colNames[DbSegment.COL_COUNT]+" = 1", null);
        Vector listSegmentDetail = new Vector();
        
        Vector seg_key = new Vector();
        Vector seg_val = new Vector();
        
        seg_key.add("ALL");
        seg_val.add(""+0);
        if(listSegment != null && listSegment.size() > 0){
            Segment s = (Segment)listSegment.get(0);
            listSegmentDetail = DbSegmentDetail.list(0, 0, DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_ID]+" = "+s.getOID(), DbSegmentDetail.colNames[DbSegmentDetail.COL_NAME]);
            if(listSegmentDetail != null && listSegmentDetail.size() > 0){
                for(int t = 0; t < listSegmentDetail.size();t++){
                    SegmentDetail sd = (SegmentDetail)listSegmentDetail.get(t);
                    seg_key.add(""+sd.getName());
                    seg_val.add(""+sd.getOID());
                }
            }
        }

        for (int i = 0; i < objectClass.size(); i++) {
            PaymentMethod paymentMethod = (PaymentMethod) objectClass.get(i);
            rowx = new Vector();
            if (paymentMethodId == paymentMethod.getOID()) {
                index = i;
            }

            if (index == i && (iJSPCommand == JSPCommand.EDIT || iJSPCommand == JSPCommand.ASK)) {
                rowx.add("<input type=\"text\" size=\"20\" name=\"" + frmObject.colNames[JspPaymentMethod.JSP_DESCRIPTION] + "\" value=\"" + paymentMethod.getDescription() + "\" class=\"formElemen\">");
                rowx.add("<input type=\"text\" size=\"10\" name=\"" + frmObject.colNames[JspPaymentMethod.JSP_POS_CODE] + "\" value=\"" + paymentMethod.getPosCode() + "\" class=\"formElemen\">");
                rowx.add("<input type=\"text\" size=\"10\" name=\"" + frmObject.colNames[JspPaymentMethod.JSP_ORDER] + "\" value=\"" + paymentMethod.getOrder() + "\" class=\"formElemen\">");
                rowx.add("<input type=\"text\" size=\"10\" name=\"" + frmObject.colNames[JspPaymentMethod.JSP_MERCHANT_PAYMENT] + "\" value=\"" + paymentMethod.getMerchantPayment() + "\" class=\"formElemen\">");
                rowx.add("<input type=\"text\" size=\"10\" name=\"" + frmObject.colNames[JspPaymentMethod.JSP_MERCHANT_TYPE] + "\" value=\"" + paymentMethod.getMerchantType() + "\" class=\"formElemen\">");
                rowx.add("<input type=\"text\" size=\"10\" name=\"" + frmObject.colNames[JspPaymentMethod.JSP_STATUS] + "\" value=\"" + paymentMethod.getStatus() + "\" class=\"formElemen\">");
                rowx.add("<input type=\"text\" size=\"10\" name=\"" + frmObject.colNames[JspPaymentMethod.JSP_AP_STATUS] + "\" value=\"" + paymentMethod.getApStatus() + "\" class=\"formElemen\">");
                rowx.add(JSPCombo.draw(frmObject.colNames[JspPaymentMethod.JSP_SEGMENT1_ID], null, ""+paymentMethod.getSegment1Id(), seg_val, seg_key, "", "formElemen"));
                
            } else {
                rowx.add("<a href=\"javascript:cmdEdit('" + String.valueOf(paymentMethod.getOID()) + "')\">" + paymentMethod.getDescription() + "</a>");
                rowx.add("" + paymentMethod.getPosCode());
                rowx.add("" + paymentMethod.getOrder());
                rowx.add((paymentMethod.getMerchantPayment() == 0) ? "-" : "Yes");
                rowx.add(DbMerchant.strType[paymentMethod.getMerchantType()]);
                rowx.add((paymentMethod.getStatus() == 1) ? "Off" : "On");
                rowx.add((paymentMethod.getApStatus() == 1) ? "On" : "Off");
                if(paymentMethod.getSegment1Id() == 0){
                    rowx.add("ALL");
                }else{
                    SegmentDetail sdx = new SegmentDetail();
                    try{
                        sdx= DbSegmentDetail.fetchExc(paymentMethod.getSegment1Id());
                    }catch(Exception e){}
                    rowx.add(""+sdx.getName());
                }
            }

            lstData.add(rowx);
        }

        rowx = new Vector();

        if (iJSPCommand == JSPCommand.ADD || (iJSPCommand == JSPCommand.SAVE && frmObject.errorSize() > 0)) {
            rowx.add("<input type=\"text\" size=\"20\" name=\"" + frmObject.colNames[JspPaymentMethod.JSP_DESCRIPTION] + "\" value=\"" + objEntity.getDescription() + "\" class=\"formElemen\">");
            rowx.add("<input type=\"text\" size=\"10\" name=\"" + frmObject.colNames[JspPaymentMethod.JSP_POS_CODE] + "\" value=\"" + objEntity.getPosCode() + "\" class=\"formElemen\">");
            rowx.add("<input type=\"text\" size=\"10\" name=\"" + frmObject.colNames[JspPaymentMethod.JSP_ORDER] + "\" value=\"" + objEntity.getOrder() + "\" class=\"formElemen\">");
            rowx.add("<input type=\"text\" size=\"10\" name=\"" + frmObject.colNames[JspPaymentMethod.JSP_MERCHANT_PAYMENT] + "\" value=\"" + objEntity.getMerchantPayment() + "\" class=\"formElemen\">");
            rowx.add("<input type=\"text\" size=\"10\" name=\"" + frmObject.colNames[JspPaymentMethod.JSP_MERCHANT_TYPE] + "\" value=\"" + objEntity.getMerchantType() + "\" class=\"formElemen\">");
            rowx.add("<input type=\"text\" size=\"10\" name=\"" + frmObject.colNames[JspPaymentMethod.JSP_STATUS] + "\" value=\"" + objEntity.getStatus() + "\" class=\"formElemen\">");
            rowx.add("<input type=\"text\" size=\"10\" name=\"" + frmObject.colNames[JspPaymentMethod.JSP_AP_STATUS] + "\" value=\"" + objEntity.getApStatus() + "\" class=\"formElemen\">");
            rowx.add(JSPCombo.draw(frmObject.colNames[JspPaymentMethod.JSP_SEGMENT1_ID], null, ""+objEntity.getSegment1Id(), seg_val, seg_key, "", "formElemen"));
        }

        lstData.add(rowx);

        return ctrlist.draw();
    }

%>
<%
            int iJSPCommand = JSPRequestValue.requestCommand(request);
            int start = JSPRequestValue.requestInt(request, "start");
            int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
            long oidPaymentMethod = JSPRequestValue.requestLong(request, "hidden_payment_method_id");


            /*variable declaration*/
            int recordToGet = 10;
            String msgString = "";
            int iErrCode = JSPMessage.NONE;
            String whereClause = "";
            String orderClause = ""+DbPaymentMethod.colNames[DbPaymentMethod.COL_POS_CODE];

            CmdPaymentMethod ctrlPaymentMethod = new CmdPaymentMethod(request);
            JSPLine ctrLine = new JSPLine();
            Vector listPaymentMethod = new Vector(1, 1);

            /*switch statement */
            iErrCode = ctrlPaymentMethod.action(iJSPCommand, oidPaymentMethod);
            /* end switch*/
            JspPaymentMethod jspPaymentMethod = ctrlPaymentMethod.getForm();

            /*count list All PaymentMethod*/
            int vectSize = DbPaymentMethod.getCount(whereClause);

            /*switch list PaymentMethod*/
            if ((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV) ||
                    (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)) {
                start = ctrlPaymentMethod.actionList(iJSPCommand, start, vectSize, recordToGet);
            }
            /* end switch list*/

            PaymentMethod paymentMethod = ctrlPaymentMethod.getPaymentMethod();
            msgString = ctrlPaymentMethod.getMessage();

            /* get record to display */
            listPaymentMethod = DbPaymentMethod.list(start, recordToGet, whereClause, orderClause);            

            /*handle condition if size of record to display = 0 and start > 0 	after delete*/
            if (listPaymentMethod.size() < 1 && start > 0) {
                if (vectSize - recordToGet > recordToGet) {
                    start = start - recordToGet;
                } //go to JSPCommand.PREV
                else {
                    start = 0;
                    iJSPCommand = JSPCommand.FIRST;
                    prevJSPCommand = JSPCommand.FIRST; //go to JSPCommand.FIRST
                }
                listPaymentMethod = DbPaymentMethod.list(start, recordToGet, whereClause, orderClause);
            }

            String[] langMD = {"Masterdata", "Payment Method", "Description", "POS Code", "Report Order", "Merchant Base", "Merchant Type", "Status", "AP Status","Segment"};
            if (lang == LANG_ID) {
                String[] langID = {"Data Induk", "Metode Pembayaran", "Keterangan", "Kode POS", "Urutan Report", "Dgn Merchant", "Tipe Merchant", "Status", "AP Status","Segment"};
                langMD = langID;
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
                document.frmpaymentmethod.hidden_payment_method_id.value="0";
                document.frmpaymentmethod.command.value="<%=JSPCommand.ADD%>";
                document.frmpaymentmethod.prev_command.value="<%=prevJSPCommand%>";
                document.frmpaymentmethod.action="paymentmethod.jsp";
                document.frmpaymentmethod.submit();
            }
            
            function cmdAsk(oidPaymentMethod){
                document.frmpaymentmethod.hidden_payment_method_id.value=oidPaymentMethod;
                document.frmpaymentmethod.command.value="<%=JSPCommand.ASK%>";
                document.frmpaymentmethod.prev_command.value="<%=prevJSPCommand%>";
                document.frmpaymentmethod.action="paymentmethod.jsp";
                document.frmpaymentmethod.submit();
            }
            
            function cmdConfirmDelete(oidPaymentMethod){
                document.frmpaymentmethod.hidden_payment_method_id.value=oidPaymentMethod;
                document.frmpaymentmethod.command.value="<%=JSPCommand.DELETE%>";
                document.frmpaymentmethod.prev_command.value="<%=prevJSPCommand%>";
                document.frmpaymentmethod.action="paymentmethod.jsp";
                document.frmpaymentmethod.submit();
            }
            
            function cmdSave(){
                document.frmpaymentmethod.command.value="<%=JSPCommand.SAVE%>";
                document.frmpaymentmethod.prev_command.value="<%=prevJSPCommand%>";
                document.frmpaymentmethod.action="paymentmethod.jsp";
                document.frmpaymentmethod.submit();
            }
            
            function cmdEdit(oidPaymentMethod){
                <%if (privUpdate) {%>
                document.frmpaymentmethod.hidden_payment_method_id.value=oidPaymentMethod;
                document.frmpaymentmethod.command.value="<%=JSPCommand.EDIT%>";
                document.frmpaymentmethod.prev_command.value="<%=prevJSPCommand%>";
                document.frmpaymentmethod.action="paymentmethod.jsp";
                document.frmpaymentmethod.submit();
                <%}%>
            }
            
            function cmdCancel(oidPaymentMethod){
                document.frmpaymentmethod.hidden_payment_method_id.value=oidPaymentMethod;
                document.frmpaymentmethod.command.value="<%=JSPCommand.EDIT%>";
                document.frmpaymentmethod.prev_command.value="<%=prevJSPCommand%>";
                document.frmpaymentmethod.action="paymentmethod.jsp";
                document.frmpaymentmethod.submit();
            }
            
            function cmdBack(){
                document.frmpaymentmethod.command.value="<%=JSPCommand.BACK%>";
                document.frmpaymentmethod.action="paymentmethod.jsp";
                document.frmpaymentmethod.submit();
            }
            
            function cmdListFirst(){
                document.frmpaymentmethod.command.value="<%=JSPCommand.FIRST%>";
                document.frmpaymentmethod.prev_command.value="<%=JSPCommand.FIRST%>";
                document.frmpaymentmethod.action="paymentmethod.jsp";
                document.frmpaymentmethod.submit();
            }
            
            function cmdListPrev(){
                document.frmpaymentmethod.command.value="<%=JSPCommand.PREV%>";
                document.frmpaymentmethod.prev_command.value="<%=JSPCommand.PREV%>";
                document.frmpaymentmethod.action="paymentmethod.jsp";
                document.frmpaymentmethod.submit();
            }
            
            function cmdListNext(){
                document.frmpaymentmethod.command.value="<%=JSPCommand.NEXT%>";
                document.frmpaymentmethod.prev_command.value="<%=JSPCommand.NEXT%>";
                document.frmpaymentmethod.action="paymentmethod.jsp";
                document.frmpaymentmethod.submit();
            }
            
            function cmdListLast(){
                document.frmpaymentmethod.command.value="<%=JSPCommand.LAST%>";
                document.frmpaymentmethod.prev_command.value="<%=JSPCommand.LAST%>";
                document.frmpaymentmethod.action="paymentmethod.jsp";
                document.frmpaymentmethod.submit();
            }
            
            //-------------- script form image -------------------
            
            function cmdDelPict(oidPaymentMethod){
                document.frmimage.hidden_payment_method_id.value=oidPaymentMethod;
                document.frmimage.command.value="<%=JSPCommand.POST%>";
                document.frmimage.action="paymentmethod.jsp";
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
                                                        <form name="frmpaymentmethod" method ="post" action="">
                                                            <input type="hidden" name="command" value="<%=iJSPCommand%>">
                                                            <input type="hidden" name="vectSize" value="<%=vectSize%>">
                                                            <input type="hidden" name="start" value="<%=start%>">
                                                            <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                                                            <input type="hidden" name="hidden_payment_method_id" value="<%=oidPaymentMethod%>">
                                                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr>
                                                                    <td class="container"> <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="8"  colspan="3"> 
                                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="8" valign="middle" colspan="3"></td>
                                                                                        </tr>
                                                                                        <%
            try {
                                                                                        %>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="22" valign="middle" colspan="3"> 
                                                                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                                    <tr>
                                                                                                        <td class="boxed1"><%= drawList(iJSPCommand, jspPaymentMethod, paymentMethod, listPaymentMethod, oidPaymentMethod, langMD)%></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
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
                                                                                        <tr align="left" valign="top">
                                                                                            <td height="14" valign="middle" colspan="3">&nbsp;</td>
                                                                                        </tr>
                                                                                        <%
            if (iJSPCommand != JSPCommand.EDIT && iJSPCommand != JSPCommand.ADD && iJSPCommand != JSPCommand.ASK && iErrCode == 0) {
                                                                                        %>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="22" valign="middle" colspan="3"><%if (privAdd) {%><a href="javascript:cmdAdd()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new21','','../images/new2.gif',1)"><img src="../images/new.gif" name="new21" width="71" height="22" border="0"></a><%}%></td>
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
            ctrLine.setTableWidth("40%");
            String scomDel = "javascript:cmdAsk('" + oidPaymentMethod + "')";
            String sconDelCom = "javascript:cmdConfirmDelete('" + oidPaymentMethod + "')";
            String scancel = "javascript:cmdEdit('" + oidPaymentMethod + "')";
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
                                                                                    <%if ((iJSPCommand == JSPCommand.ADD) || (iJSPCommand == JSPCommand.SAVE) && (iErrCode != 0) || (iJSPCommand == JSPCommand.EDIT) || (iJSPCommand == JSPCommand.ASK)) {%>
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
