
<%-- 
    Document   : vendoredt
    Created on : Aug 13, 2015, 10:18:02 AM
    Author     : Roy
--%>


<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.admin.*" %>
<%@ page import = "com.project.system.*" %>
<%@ page import = "com.project.general.*" %>
<%@ page import = "com.project.main.db.*" %>
<%@ page import = "com.project.fms.master.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ include file = "../main/javainit.jsp" %>
<% int appObjCode = 1;%>
<%@ include file = "../main/check.jsp" %>
<%
            boolean priv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_VENDOR);
            boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_VENDOR, AppMenu.PRIV_VIEW);
            boolean privUpdate = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_VENDOR, AppMenu.PRIV_UPDATE);
            boolean privAdd = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_VENDOR, AppMenu.PRIV_ADD);
            boolean privDelete = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_VENDOR, AppMenu.PRIV_DELETE);
%>
<!-- Jsp Block -->
<%
            int iJSPCommand = JSPRequestValue.requestCommand(request);
            int start = JSPRequestValue.requestInt(request, "start");
            int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
            long oidVendor = JSPRequestValue.requestLong(request, "hidden_vendor_id");
            int showAll = JSPRequestValue.requestInt(request, "show_all");
            int group = JSPRequestValue.requestInt(request, "src_group");
            String srcName = JSPRequestValue.requestString(request, "src_name");
            String srcCode = JSPRequestValue.requestString(request, "src_code");
            long bankId = JSPRequestValue.requestLong(request, "src_bank");
            String srcContact = JSPRequestValue.requestString(request, "src_contact");
            int paymentType = JSPRequestValue.requestInt(request, "src_payment_type");


            /*variable declaration*/
            int recordToGet = 30;
            String msgString = "";
            int iErrCode = JSPMessage.NONE;
            String whereClause = "";//DbVendor.colNames[DbVendor.COL_SEGMENT_ID] + "=" + oidSegment;
            String orderClause = DbVendor.colNames[DbVendor.COL_NAME];
            
            if(iJSPCommand ==JSPCommand.NONE){
                group = -1;
                paymentType = -1;
            }
            
            if(group != -1){
                if(whereClause != null && whereClause.length() > 0){ whereClause = whereClause + " and "; }
                whereClause = whereClause + DbVendor.colNames[DbVendor.COL_TYPE]+" = "+group;
            }                
                
            if(srcCode != null && srcCode.length() > 0){
                if(whereClause != null && whereClause.length() > 0){ whereClause = whereClause + " and "; }
                whereClause = whereClause + DbVendor.colNames[DbVendor.COL_CODE]+" like '%"+srcCode+"%'";
            }  

            if(srcName != null && srcName.length() > 0){
                if(whereClause != null && whereClause.length() > 0){ whereClause = whereClause + " and "; }
                whereClause = whereClause + DbVendor.colNames[DbVendor.COL_NAME]+" like '%"+srcName+"%'";
            }   

            if(bankId != 0){
                if(whereClause != null && whereClause.length() > 0){ whereClause = whereClause + " and "; }
                whereClause = whereClause + DbVendor.colNames[DbVendor.COL_BANK_ID]+"="+bankId;
            }
            
            if(paymentType != -1){
                if(whereClause != null && whereClause.length() > 0){ whereClause = whereClause + " and "; }
                whereClause = whereClause + DbVendor.colNames[DbVendor.COL_PAYMENT_TYPE]+"="+paymentType;
            }
            
            if(srcContact != null && srcContact.length() > 0){
                if(whereClause != null && whereClause.length() > 0){ whereClause = whereClause + " and "; }
                whereClause = whereClause + DbVendor.colNames[DbVendor.COL_CONTACT]+" like '%"+srcContact+"%'";
            }   

            CmdVendorFinance ctrlVendorFinance = new CmdVendorFinance(request);
            ctrlVendorFinance.setUserId(user.getOID());
            JSPLine ctrLine = new JSPLine();

            /*switch statement */
            iErrCode = ctrlVendorFinance.action(iJSPCommand, oidVendor);
            /* end switch*/
            JspVendorFinance jspVendorFinance = ctrlVendorFinance.getForm();

            /*count list All Vendor*/
            int vectSize = DbVendor.getCount(whereClause);

            /*switch list Vendor*/
            if ((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV) ||
                    (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)) {
                start = ctrlVendorFinance.actionList(iJSPCommand, start, vectSize, recordToGet);
            }

            /* end switch list*/
            msgString = ctrlVendorFinance.getMessage();

            /* get record to display */
            Vector listVendor = DbVendor.list(start, recordToGet, whereClause, orderClause);

            /*handle condition if size of record to display = 0 and start > 0 	after delete*/
            if (listVendor.size() < 1 && start > 0) {
                if (vectSize - recordToGet > recordToGet) {
                    start = start - recordToGet;
                } //go to JSPCommand.PREV
                else {
                    start = 0;
                    iJSPCommand = JSPCommand.FIRST;
                    prevJSPCommand = JSPCommand.FIRST; //go to JSPCommand.FIRST
                }
                listVendor = DbVendor.list(start, recordToGet, whereClause, orderClause);
            }

            /*** LANG ***/
            String[] langMD = {"Code", "Name", "Bank", "Payment Type", "Contact Person", "Group","Rekening Number"};

            String[] langNav = {"Masterdata", "Vendor List", "All"};

            if (lang == LANG_ID) {
                String[] langID = {"Kode", "Nama", "Bank", "Tipe Pembayaran", "Kontak ", "Group","Nomor Rekening"};
                langMD = langID;

                String[] navID = {"Data Induk", "Data Suplier", "Semua"};
                langNav = navID;
            }

            Vector listBank = DbBank.list(0, 0, "", DbBank.colNames[DbBank.COL_NAME]);
            Hashtable hashBank = new Hashtable();

            Vector valueType = new Vector();
            Vector keyType = new Vector();

            for (int x = 0; x < DbVendor.keyPayment.length; x++) {
                valueType.add(String.valueOf(DbVendor.valuePayment[x]));
                keyType.add(String.valueOf(DbVendor.keyPayment[x]));
            }

            Vector valueBank = new Vector();
            Vector keyBank = new Vector();
            valueBank.add(String.valueOf(0));
            keyBank.add("- select Bank -");

            if (listBank != null && listBank.size() > 0) {
                for (int i = 0; i < listBank.size(); i++) {
                    Bank bank = (Bank) listBank.get(i);
                    valueBank.add(String.valueOf(bank.getOID()));
                    keyBank.add(String.valueOf(bank.getName()));
                }
            }
%>
<html >
    <!-- #BeginTemplate "/Templates/index.dwt" --> 
    <head>
        <!-- #BeginEditable "javascript" --> 
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <title><%=systemTitle%></title>
        <link href="../css/css.css" rel="stylesheet" type="text/css" />
        <script language="JavaScript">
            function cmdUnShowAll(){                
                document.frmvendor.command.value="<%=JSPCommand.LIST%>";                
                document.frmvendor.show_all.value=0;
                document.frmvendor.action="vendorlist.jsp";
                document.frmvendor.submit();
            }
            
            function cmdShowAll(){                
                document.frmvendor.command.value="<%=JSPCommand.LIST%>";                
                document.frmvendor.show_all.value=1;
                document.frmvendor.action="vendorlist.jsp";
                document.frmvendor.submit();
            }
            
            function cmdSearch(){
                document.frmvendor.command.value="<%=JSPCommand.LIST%>";
                document.frmvendor.action="vendorlist.jsp";
                document.frmvendor.submit();
            }
            
            function cmdSave(){
                document.frmvendor.command.value="<%=JSPCommand.SAVE%>";
                document.frmvendor.prev_command.value="<%=prevJSPCommand%>";
                document.frmvendor.action="vendorlist.jsp";
                document.frmvendor.submit();
            }
            
            function cmdEdit(oidVendor){
                <%if (privUpdate) {%>
                document.frmvendor.hidden_vendor_id.value=oidVendor;
                document.frmvendor.command.value="<%=JSPCommand.EDIT%>";
                document.frmvendor.prev_command.value="<%=prevJSPCommand%>";
                document.frmvendor.action="vendorlist.jsp";
                document.frmvendor.submit();
                <%}%> 
            }
            
            function cmdCancel(oidVendor){
                document.frmvendor.hidden_vendor_id.value=oidVendor;
                document.frmvendor.command.value="<%=JSPCommand.EDIT%>";
                document.frmvendor.prev_command.value="<%=prevJSPCommand%>";
                document.frmvendor.action="vendorlist.jsp";
                document.frmvendor.submit();
            }
            
            function cmdBack(){
                document.frmvendor.command.value="<%=JSPCommand.BACK%>";
                document.frmvendor.action="vendorlist.jsp";
                document.frmvendor.submit();
            }
            
            function cmdListFirst(){
                document.frmvendor.command.value="<%=JSPCommand.FIRST%>";
                document.frmvendor.prev_command.value="<%=JSPCommand.FIRST%>";
                document.frmvendor.action="vendorlist.jsp";
                document.frmvendor.submit();
            }
            
            function cmdListPrev(){
                document.frmvendor.command.value="<%=JSPCommand.PREV%>";
                document.frmvendor.prev_command.value="<%=JSPCommand.PREV%>";
                document.frmvendor.action="vendorlist.jsp";
                document.frmvendor.submit();
            }
            
            function cmdListNext(){
                document.frmvendor.command.value="<%=JSPCommand.NEXT%>";
                document.frmvendor.prev_command.value="<%=JSPCommand.NEXT%>";
                document.frmvendor.action="vendorlist.jsp";
                document.frmvendor.submit();
            }
            
            function cmdListLast(){
                document.frmvendor.command.value="<%=JSPCommand.LAST%>";
                document.frmvendor.prev_command.value="<%=JSPCommand.LAST%>";
                document.frmvendor.action="vendorlist.jsp";
                document.frmvendor.submit();
            }
            
            //-------------- script form image -------------------
            
            function cmdDelPict(oidVendor){
                document.frmimage.hidden_vendor_id.value=oidVendor;
                document.frmimage.command.value="<%=JSPCommand.POST%>";
                document.frmimage.action="vendorlist.jsp";
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
                                                    <%@ include file="../main/navigator.jsp"%><!-- #EndEditable --></td>
                                                </tr>
                                                <!--tr> 
                      <td><img src="<%=approot%>/images/title-sp.gif" width="584" height="1"></td> 
                                                </tr-->
                                                <tr> 
                                                    <td><!-- #BeginEditable "content" --> 
                                                        <form name="frmvendor" method ="post" action="">
                                                            <input type="hidden" name="command" value="<%=iJSPCommand%>">
                                                            <input type="hidden" name="vectSize" value="<%=vectSize%>">
                                                            <input type="hidden" name="start" value="<%=start%>">
                                                            <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                                                            <input type="hidden" name="hidden_vendor_id" value="<%=oidVendor%>"> 
                                                            <input type="hidden" name="show_all" value="0">
                                                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr align="left" valign="top"> 
                                                                    <td height="8"  colspan="3" class="container"> 
                                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                            <tr align="left" valign="top">
                                                                                <td height="8" valign="middle" colspan="3">&nbsp;</td>
                                                                            </tr>
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="8" valign="middle" colspan="3"> 
                                                                                    <table width="100%" border="0" cellspacing="2" cellpadding="2">
                                                                                        <tr>
                                                                                            <td width="100" class="tablecell" style="padding-left:3px;"><%=langMD[5]%></td>
                                                                                            <td width="1" class="fontarial">:</td>
                                                                                            <td width="300">
                                                                                                <select name ="src_group" class="fontarial">
                                                                                                    <option value="-1" <%if (group == -1) {%> selected <%}%> >- All Group -</option>
                                                                                                    <option value="<%=DbVendor.VENDOR_TYPE_SUPPLIER%>" <%if (group == DbVendor.VENDOR_TYPE_SUPPLIER) {%> selected <%}%> ><%=DbVendor.vendorType[DbVendor.VENDOR_TYPE_SUPPLIER] %></option>
                                                                                                    <option value="<%=DbVendor.VENDOR_TYPE_GA%>" <%if (group == DbVendor.VENDOR_TYPE_GA) {%> selected <%}%> ><%=DbVendor.vendorType[DbVendor.VENDOR_TYPE_GA] %></option>
                                                                                                </select>
                                                                                            </td>
                                                                                            <td width="100" class="tablecell" style="padding-left:3px;"><%=langMD[0]%></td>
                                                                                            <td width="1" class="fontarial">:</td>
                                                                                            <td ><input type="text" name="src_code" class="fontarial" size="20" value="<%=srcCode%>"></td>  
                                                                                        </tr>
                                                                                        <tr>
                                                                                            <td class="tablecell" style="padding-left:3px;"><%=langMD[1]%></td>
                                                                                            <td class="fontarial">:</td>
                                                                                            <td ><input type="text" name="src_name" value="<%=srcName%>" class="fontarial" size="20"></td>
                                                                                            <td class="tablecell" style="padding-left:3px;"><%=langMD[2]%></td>
                                                                                            <td class="fontarial">:</td>
                                                                                            <td >
                                                                                                <select name ="src_bank" class="fontarial">
                                                                                                    <option value="0" <%if (bankId == 0) {%> selected <%}%> >- All Bank -</option>
                                                                                                    <%
            if (listBank != null && listBank.size() > 0) {
                for (int i = 0; i < listBank.size(); i++) {
                    Bank objBank = (Bank) listBank.get(i);
                    hashBank.put(String.valueOf(objBank.getOID()), objBank.getName());
                                                                                                    %>
                                                                                                    <option value="<%=objBank.getOID()%>" <%if (bankId == objBank.getOID()) {%> selected <%}%> ><%=objBank.getName()%></option>                                                                                                            
                                                                                                    <%
                }
            }%>
                                                                                                </select>
                                                                                            </td>  
                                                                                        </tr>
                                                                                        <tr>
                                                                                            <td class="tablecell" style="padding-left:3px;"><%=langMD[3]%></td>
                                                                                            <td class="fontarial">:</td>
                                                                                            <td >
                                                                                                <select name="src_payment_type" class="fontarial">
                                                                                                    <option value="-1" <%if (paymentType == -1) {%> selected <%}%> >- All <%=langMD[3]%> -</option>
                                                                                                    <%for (int x = 0; x < DbVendor.valuePayment.length; x++) {%>                                                                                                    
                                                                                                    <option value="<%=DbVendor.valuePayment[x]%>" <%if (paymentType == Integer.parseInt(DbVendor.valuePayment[x])) {%> selected<%}%> ><%=DbVendor.keyPayment[x]%></option>                                                                                                    
                                                                                                    <%}%>
                                                                                                </select>
                                                                                            </td>
                                                                                            <td class="tablecell" style="padding-left:3px;"><%=langMD[4]%></td>
                                                                                            <td class="fontarial">:</td>
                                                                                            <td ><input type="text" name="src_contact" value="<%=srcContact%>" class="fontarial" size="20"></td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                            <tr align="left" > 
                                                                                <td colspan="3">
                                                                                    <table width="800">
                                                                                        <tr>
                                                                                            <td height="3" background="<%=approot%>/images/line1.gif" ></td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </td>
                                                                            </tr> 
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="14" valign="middle" colspan="3" class="comment">
                                                                                <a href="javascript:cmdSearch()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('sr21','','../images/search2.gif',1)"><img src="../images/search.gif" name="sr21" border="0"></a></td>
                                                                                
                                                                            </tr>
                                                                            <tr align="left" height="25"> 
                                                                                <td colspan="3">&nbsp;</td>
                                                                            </tr> 
                                                                            <%
            try {
                                                                            %>
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="22" valign="middle" colspan="3">                                         
                                                                                    <table width="1050" border="0" cellpadding="0" cellspacing="1">
                                                                                        <tr height="25">
                                                                                            <td class="tablehdr" width="25">No</td>
                                                                                            <td class="tablehdr" width="80"><%=langMD[0]%></td>
                                                                                            <td class="tablehdr"><%=langMD[1]%></td>
                                                                                            <td class="tablehdr" width="130"><%=langMD[2]%></td>
                                                                                            <td class="tablehdr" width="130"><%=langMD[6]%></td>
                                                                                            <td class="tablehdr" width="100"><%=langMD[3]%></td>
                                                                                            <td class="tablehdr" width="250"><%=langMD[4]%></td>
                                                                                        </tr>
                                                                                        <%
                                                                                if (listVendor != null && listVendor.size() > 0) {
                                                                                    for (int i = 0; i < listVendor.size(); i++) {
                                                                                        Vendor v = (Vendor) listVendor.get(i);

                                                                                        String strStyle = "";

                                                                                        if (i % 2 == 0) {
                                                                                            strStyle = "tablecell";
                                                                                        } else {
                                                                                            strStyle = "tablecell1";
                                                                                        }

                                                                                        String strBank = "";
                                                                                        String strPaymentType = "";
                                                                                        String strKontak = "";
                                                                                        String noRek = "";

                                                                                        try {
                                                                                            if (v.getBankId() != 0) {
                                                                                                strBank = String.valueOf(hashBank.get(String.valueOf(v.getBankId())));
                                                                                            }
                                                                                        } catch (Exception e) {
                                                                                        }

                                                                                        try {
                                                                                            strPaymentType = DbVendor.keyPayment[v.getPaymentType()];
                                                                                        } catch (Exception e) {
                                                                                        }

                                                                                        if (v.getContact() != null && v.getContact().length() > 0 && v.getContact().compareTo("null")!=0) {
                                                                                            strKontak = v.getContact();
                                                                                        }
                                                                                        
                                                                                        if (v.getNoRek() != null && v.getNoRek().length() > 0 && v.getNoRek().compareTo("null")!=0) {
                                                                                            noRek = v.getNoRek();
                                                                                        }

                                                                                        if (oidVendor == v.getOID() && (iJSPCommand == JSPCommand.EDIT || iJSPCommand == JSPCommand.ASK)) {
                                                                                        %>
                                                                                        <input type="hidden" name="<%=jspVendorFinance.colNames[JspVendorFinance.JSP_CODE]%>" value="<%=v.getCode()%>">    
                                                                                        <input type="hidden" name="<%=jspVendorFinance.colNames[JspVendorFinance.JSP_NAME]%>" value="<%=v.getName()%>">    
                                                                                        <tr>
                                                                                            <td class="<%=strStyle%>" align="center"><%=(start + i + 1)%></td>
                                                                                            <td class="<%=strStyle%>" style="padding:3px;"><%=v.getCode()%></td>
                                                                                            <td class="<%=strStyle%>" style="padding:3px;"><%=v.getName()%></td>
                                                                                            <td class="<%=strStyle%>" style="padding:3px;"><%=JSPCombo.draw(jspVendorFinance.colNames[JspVendorFinance.JSP_BANK_ID], null, "" + v.getBankId(), valueBank, keyBank, "formElemen", "") %></td>
                                                                                            <td class="<%=strStyle%>" style="padding:3px;"><input type="text" name="<%=jspVendorFinance.colNames[JspVendorFinance.JSP_NO_REK]%>" size="20" value="<%=v.getNoRek()%>" class="fontarial"></td>
                                                                                            <td class="<%=strStyle%>" style="padding:3px;"><%=JSPCombo.draw(jspVendorFinance.colNames[JspVendorFinance.JSP_PAYMENT_TYPE], null, "" + v.getPaymentType(), valueType, keyType, "formElemen", "") %></td>
                                                                                            <td class="<%=strStyle%>" style="padding:3px;"><input type="text" name="<%=jspVendorFinance.colNames[JspVendorFinance.JSP_CONTACT]%>" size="30" value="<%=v.getContact()%>" class="fontarial"></td>
                                                                                        </tr>                                            
                                                                                        <%} else {%>
                                                                                        <tr>
                                                                                            <td class="<%=strStyle%>" align="center"><%=(start + i + 1)%></td>
                                                                                            <td class="<%=strStyle%>" style="padding:3px;"><a href="javascript:cmdEdit('<%=String.valueOf(v.getOID())%>') "> <%=v.getCode()%></a></td>
                                                                                            <td class="<%=strStyle%>" style="padding:3px;"><%=v.getName()%></td>
                                                                                            <td class="<%=strStyle%>" style="padding:3px;"><%=strBank%></td>
                                                                                            <td class="<%=strStyle%>" style="padding:3px;"><%=noRek%></td>
                                                                                            <td class="<%=strStyle%>" style="padding:3px;"><%=strPaymentType%></td>
                                                                                            <td class="<%=strStyle%>" style="padding:3px;"><%=strKontak%></td>
                                                                                        </tr>
                                                                                        <%
                                                                                        }
                                                                                    }
                                                                                }else{
                                                                                        %>
                                                                                        <tr height="25">
                                                                                            <td bgcolor="#F3F3F3" align="left" class="fontarial" colspan="6"><i>&nbsp;Data tidak ditemukan ..<i></td>
                                                                                            </tr>    
                                                                                        <%}%>
                                                                                        
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
                                                                                        %>
                                                                                <%=ctrLine.drawImageListLimit(cmd, vectSize, start, recordToGet)%> </span> </td>
                                                                            </tr>                               
                                                                        </table>
                                                                    </td>
                                                                </tr>
                                                                <tr align="left" valign="top"> 
                                                                    <td height="8" valign="middle" width="17%">&nbsp;</td>
                                                                    <td height="8" colspan="2" width="83%">&nbsp; </td>
                                                                </tr>
                                                                <%if ((iJSPCommand == JSPCommand.ADD) || (iJSPCommand == JSPCommand.SAVE) && (jspVendorFinance.errorSize() > 0) || (iJSPCommand == JSPCommand.EDIT) || (iJSPCommand == JSPCommand.ASK)) {%>
                                                                <tr align="left" valign="top" > 
                                                                    <td colspan="3" class="container"> 
                                                                        <%
    ctrLine.setLocationImg(approot + "/images/ctr_line");
    ctrLine.initDefault();
    ctrLine.setTableWidth("80%");
    String scomDel = "javascript:cmdAsk('" + oidVendor + "')";
    String sconDelCom = "javascript:cmdConfirmDelete('" + oidVendor + "')";
    String scancel = "javascript:cmdEdit('" + oidVendor + "')";
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
    ctrLine.setDeleteCaption("");

    if (privAdd == false) {
        ctrLine.setAddCaption("");
    }
                                                                        %>
                                                                    <%= ctrLine.drawImage(iJSPCommand, iErrCode, msgString)%> </td>
                                                                </tr>
                                                                <%}%>
                                                                <tr>
                                                                    <td colspan="3">&nbsp;</td>
                                                                </tr>    
                                                                <tr>
                                                                    <td class="container">
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
            int countx = DbHistoryUser.getCount(DbHistoryUser.colNames[DbHistoryUser.COL_TYPE] + " = " + DbHistoryUser.TYPE_VENDOR_FINANCE);
            Vector historys = DbHistoryUser.list(0, max, DbHistoryUser.colNames[DbHistoryUser.COL_TYPE] + " = " + DbHistoryUser.TYPE_VENDOR_FINANCE, DbHistoryUser.colNames[DbHistoryUser.COL_DATE] + " desc");
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

                    Vendor sdx = new Vendor();
                    try {
                        sdx = DbVendor.fetchExc(hu.getRefId());
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
                                                                <tr>
                                                                    <td colspan="3" height="40">&nbsp;</td>
                                                                </tr>
                                                            </table>
                                                        </form>
                                                    <!-- #EndEditable --> </td>
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

