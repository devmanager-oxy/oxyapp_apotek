
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.main.entity.*" %>
<%@ page import = "com.project.admin.*" %>
<%@ page import = "com.project.general.*" %>
<%@ page import = "com.project.fms.master.*" %>
<%@ page import = "com.project.*" %>
<%@ include file = "../main/javainit.jsp" %> 
<% int appObjCode = 1;%>
<%@ include file = "../main/check.jsp" %>
<%
            /* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
            boolean privAdd = true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ADD));
            boolean privUpdate = true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_UPDATE));
            boolean privDelete = true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_DELETE));
%>
<!-- Jsp Block -->
<%
            int iJSPCommand = JSPRequestValue.requestCommand(request);
            int start = JSPRequestValue.requestInt(request, "start");
            int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
            long oidCustomer = JSPRequestValue.requestLong(request, "hidden_customer_id");
            int isSearch = JSPRequestValue.requestInt(request, "hidden_search");

            /*variable declaration*/
            int recordToGet = 10;
            String msgString = "";
            int iErrCode = JSPMessage.NONE;
            String whereClause = "";
            String orderClause = "";

            CmdCustomer cmdCustomer = new CmdCustomer(request);
            JSPLine ctrLine = new JSPLine();
            Vector listCustomer = new Vector(1, 1);

            /*switch statement */
            iErrCode = cmdCustomer.action(iJSPCommand, oidCustomer);
            /* end switch*/
            JspCustomer jspCustomer = cmdCustomer.getForm();

            /*count list All Customer*/
            int vectSize = DbCustomer.getCount(whereClause);

            Customer customer = cmdCustomer.getCustomer();
            msgString = cmdCustomer.getMessage();

            System.out.println("ERR >>>> : " + customer.getIndukCustomerId());

            Vector listCoas = DbCoa.list(0, 0, "status='POSTABLE'", "code");

%>
<html >
<!-- #BeginTemplate "/Templates/index.dwt" --> 
<head>
    <!-- #BeginEditable "javascript" --> 
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title><%=systemTitle%></title>
    <link href="../css/css.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript">
        <%if ((iJSPCommand == JSPCommand.DELETE) && iErrCode == 0) {%>
        window.location="customer.jsp?command=<%=JSPCommand.LIST%>&customer_id=0";
        //cmdBack();
        <%}%>
        
        function unitusahalist(oidCustomer){
            document.frmcustomer.hidden_customer_id.value=0;
            document.frmcustomer.command.value="<%=JSPCommand.LIST%>";
            document.frmcustomer.prev_command.value="<%=prevJSPCommand%>";
            document.frmcustomer.action="customer.jsp";
            document.frmcustomer.submit();
        }
        
        function indukusaha(){
            document.frmcustomer.command.value="<%=JSPCommand.EDIT%>";
            document.frmcustomer.prev_command.value="<%=prevJSPCommand%>";
            document.frmcustomer.action="customerinduk.jsp";
            document.frmcustomer.submit();
        }
        
        function cmdAdd(){
            document.frmcustomer.hidden_customer_id.value="0";
            document.frmcustomer.command.value="<%=JSPCommand.ADD%>";
            document.frmcustomer.prev_command.value="<%=prevJSPCommand%>";
            document.frmcustomer.action="customeredt.jsp";
            document.frmcustomer.submit();
        }
        
        function cmdAsk(oidCustomer){
            document.frmcustomer.hidden_customer_id.value=oidCustomer;
            document.frmcustomer.command.value="<%=JSPCommand.ASK%>";
            document.frmcustomer.prev_command.value="<%=prevJSPCommand%>";
            document.frmcustomer.action="customeredt.jsp";
            document.frmcustomer.submit();
        }
        
        function cmdConfirmDelete(oidCustomer){
            document.frmcustomer.hidden_customer_id.value=oidCustomer;
            document.frmcustomer.command.value="<%=JSPCommand.DELETE%>";
            document.frmcustomer.prev_command.value="<%=prevJSPCommand%>";
            document.frmcustomer.action="customeredt.jsp";
            document.frmcustomer.submit();
        }
        function cmdSave(){
            document.frmcustomer.command.value="<%=JSPCommand.SAVE%>";
            document.frmcustomer.prev_command.value="<%=prevJSPCommand%>";
            document.frmcustomer.action="customeredt.jsp";
            document.frmcustomer.submit();
        }
        
        function cmdEdit(oidCustomer){
            document.frmcustomer.hidden_customer_id.value=oidCustomer;
            document.frmcustomer.command.value="<%=JSPCommand.EDIT%>";
            document.frmcustomer.prev_command.value="<%=prevJSPCommand%>";
            document.frmcustomer.action="customeredt.jsp";
            document.frmcustomer.submit();
        }
        
        function cmdCancel(oidCustomer){
            document.frmcustomer.hidden_customer_id.value=oidCustomer;
            document.frmcustomer.command.value="<%=JSPCommand.EDIT%>";
            document.frmcustomer.prev_command.value="<%=prevJSPCommand%>";
            document.frmcustomer.action="customeredt.jsp";
            document.frmcustomer.submit();
        }
        
        function cmdBack(){
            document.frmcustomer.command.value="<%=JSPCommand.BACK%>";
            document.frmcustomer.action="customer.jsp";
            document.frmcustomer.submit();
        }
        
        function cmdListFirst(){
            document.frmcustomer.command.value="<%=JSPCommand.FIRST%>";
            document.frmcustomer.prev_command.value="<%=JSPCommand.FIRST%>";
            document.frmcustomer.action="customeredt.jsp";
            document.frmcustomer.submit();
        }
        
        function cmdListPrev(){
            document.frmcustomer.command.value="<%=JSPCommand.PREV%>";
            document.frmcustomer.prev_command.value="<%=JSPCommand.PREV%>";
            document.frmcustomer.action="customeredt.jsp";
            document.frmcustomer.submit();
        }
        
        function cmdListNext(){
            document.frmcustomer.command.value="<%=JSPCommand.NEXT%>";
            document.frmcustomer.prev_command.value="<%=JSPCommand.NEXT%>";
            document.frmcustomer.action="customeredt.jsp";
            document.frmcustomer.submit();
        }
        
        function cmdListLast(){
            document.frmcustomer.command.value="<%=JSPCommand.LAST%>";
            document.frmcustomer.prev_command.value="<%=JSPCommand.LAST%>";
            document.frmcustomer.action="customeredt.jsp";
            document.frmcustomer.submit();
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
        
        function toirigasi(){
            document.frmcustomer.command.value="<%=JSPCommand.EDIT%>";
            document.frmcustomer.prev_command.value="<%=prevJSPCommand%>";
            document.frmcustomer.action="customeredt_accirigasi.jsp";
            document.frmcustomer.submit();
        }
        
        function tolimbah(){
            document.frmcustomer.command.value="<%=JSPCommand.EDIT%>";
            document.frmcustomer.prev_command.value="<%=prevJSPCommand%>";
            document.frmcustomer.action="customeredt_acclimbah.jsp";
            document.frmcustomer.submit();
        }
        
        function toassesment(){
            document.frmcustomer.command.value="<%=JSPCommand.EDIT%>";
            document.frmcustomer.prev_command.value="<%=prevJSPCommand%>";
            document.frmcustomer.action="customeredt_accassesment.jsp";
            document.frmcustomer.submit();
        }
        
        function tokompen(){
            document.frmcustomer.command.value="<%=JSPCommand.EDIT%>";
            document.frmcustomer.prev_command.value="<%=prevJSPCommand%>";
            document.frmcustomer.action="customeredt_acckompen.jsp";
            document.frmcustomer.submit();
        }
        
        function tokomin(){
            document.frmcustomer.command.value="<%=JSPCommand.EDIT%>";
            document.frmcustomer.prev_command.value="<%=prevJSPCommand%>";
            document.frmcustomer.action="customeredt_acckomin.jsp";
            document.frmcustomer.submit();
        }
        
        function todenda(){
            document.frmcustomer.command.value="<%=JSPCommand.EDIT%>";
            document.frmcustomer.prev_command.value="<%=prevJSPCommand%>";
            document.frmcustomer.action="customeredt_accdenda.jsp";
            document.frmcustomer.submit();
        }
        
        function cmdSeacrhCoa(accid, accname){
            window.open("<%=approot%>/general/s_coa.jsp?formName=frmcustomer&accId="+accid+"&accName="+accname, null, "height=400,width=600, status=yes,toolbar=no,menubar=no,location=no, scrollbars=yes");
            }
            
    </script>
    <style type="text/css">
        <!--
        .style1 {color: #FF0000}
        -->
    </style>
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
            String navigator = "<font class=\"lvl1\">Data Induk</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">Customer</span></font>";
                                           %>
                        <%@ include file="../main/navigator.jsp"%>
                        <!-- #EndEditable --></td>
                    </tr>
                    <!--tr> 
                      <td><img src="<%=approot%>/images/title-sp.gif" width="584" height="1"></td> 
                    </tr-->
                    <tr> 
                    <td><!-- #BeginEditable "content" --> 
                    <form name="frmcustomer" method ="post" action="">
                    <input type="hidden" name="command" value="<%=iJSPCommand%>">
                    <input type="hidden" name="vectSize" value="<%=vectSize%>">
                    <input type="hidden" name="start" value="<%=start%>">
                    <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                    <input type="hidden" name="hidden_customer_id" value="<%=oidCustomer%>">
                    <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                    <input type="hidden" name="hidden_search" value="<%=isSearch%>">
                    
                    <input type="hidden" name="<%=jspCustomer.colNames[JspCustomer.JSP_IRIGASI_FLAG] %>" value="<%=customer.getLimbahFlag()%>">
                    <input type="hidden" name="<%=jspCustomer.colNames[JspCustomer.JSP_IRIGASI_DEBET_ACCOUNT_ID] %>" value="<%=customer.getLimbahDebetAccountId()%>">
                    <input type="hidden" name="<%=jspCustomer.colNames[JspCustomer.JSP_IRIGASI_CREDIT_ACCOUNT_ID] %>" value="<%=customer.getLimbahCreditAccountId()%>">
                    <input type="hidden" name="<%=jspCustomer.colNames[JspCustomer.JSP_IRIGASI_PPN_ACCOUNT_ID] %>" value="<%=customer.getLimbahPpnAccauntId()%>">
                    <input type="hidden" name="<%=jspCustomer.colNames[JspCustomer.JSP_IRIGASI_PPH_ACCOUNT_ID] %>" value="<%=customer.getLimbahPphAccountId()%>">
                    
                    <input type="hidden" name="<%=jspCustomer.colNames[JspCustomer.JSP_LIMBAH_FLAG] %>" value="<%=customer.getLimbahFlag()%>">
                    <input type="hidden" name="<%=jspCustomer.colNames[JspCustomer.JSP_LIMBAH_DEBET_ACCOUNT_ID] %>" value="<%=customer.getLimbahDebetAccountId()%>">
                    <input type="hidden" name="<%=jspCustomer.colNames[JspCustomer.JSP_LIMBAH_CREDIT_ACCOUNT_ID] %>" value="<%=customer.getLimbahCreditAccountId()%>">
                    <input type="hidden" name="<%=jspCustomer.colNames[JspCustomer.JSP_LIMBAH_PPN_ACCOUNT_ID] %>" value="<%=customer.getLimbahPpnAccauntId()%>">
                    <input type="hidden" name="<%=jspCustomer.colNames[JspCustomer.JSP_LIMBAH_PPH_ACCOUNT_ID] %>" value="<%=customer.getLimbahPphAccountId()%>">
                    
                    <input type="hidden" name="<%=jspCustomer.colNames[JspCustomer.JSP_ASSESMENT_FLAG] %>" value="<%=customer.getAssesmentFlag()%>">
                    <input type="hidden" name="<%=jspCustomer.colNames[JspCustomer.JSP_ASSESMENT_DEBET_ACCOUNT_ID] %>" value="<%=customer.getAssesmentDebetAccountId()%>">
                    <input type="hidden" name="<%=jspCustomer.colNames[JspCustomer.JSP_ASSESMENT_CREDIT_ACCOUNT_ID] %>" value="<%=customer.getAssesmentCreditAccountId()%>">
                    <input type="hidden" name="<%=jspCustomer.colNames[JspCustomer.JSP_ASSESMENT_CREDIT_INCOME_ACCOUNT_ID] %>" value="<%=customer.getAssesmentCreditIncomeAccountId()%>">
                    <input type="hidden" name="<%=jspCustomer.colNames[JspCustomer.JSP_ASSESMENT_PPN_ACCOUNT_ID] %>" value="<%=customer.getAssesmentPpnAccountId()%>">
                    <input type="hidden" name="<%=jspCustomer.colNames[JspCustomer.JSP_ASSESMENT_PPH_ACCOUNT_ID] %>" value="<%=customer.getAssesmentPphAccountId()%>">
                    
                    <input type="hidden" name="<%=jspCustomer.colNames[JspCustomer.JSP_KOMPEN_FLAG] %>" value="<%=customer.getKompenFlag()%>">
                    <input type="hidden" name="<%=jspCustomer.colNames[JspCustomer.JSP_KOMPEN_DEBET_ACCOUNT_ID] %>" value="<%=customer.getKompenDebetAccountId()%>">
                    <input type="hidden" name="<%=jspCustomer.colNames[JspCustomer.JSP_KOMPEN_CREDIT_ACCOUNT_ID] %>" value="<%=customer.getKompenCreditAccountId()%>">
                    <input type="hidden" name="<%=jspCustomer.colNames[JspCustomer.JSP_KOMPEN_CREDIT_INCOME_ACCOUNT_ID] %>" value="<%=customer.getKompenCreditIncomeAccountId()%>">
                    <input type="hidden" name="<%=jspCustomer.colNames[JspCustomer.JSP_KOMPEN_PPN_ACCOUNT_ID] %>" value="<%=customer.getKompenPpnAccountId()%>">
                    <input type="hidden" name="<%=jspCustomer.colNames[JspCustomer.JSP_KOMPEN_PPH_ACCOUNT_ID] %>" value="<%=customer.getKompenPphAccountId()%>">
                    
                    <input type="hidden" name="<%=jspCustomer.colNames[JspCustomer.JSP_KOMIN_DEBET_ACCOUNT_ID] %>" value="<%=customer.getKominDebetAccountId()%>">
                    <input type="hidden" name="<%=jspCustomer.colNames[JspCustomer.JSP_KOMIN_CREDIT_ACCOUNT_ID] %>" value="<%=customer.getKominCreditAccountId()%>">
                    <input type="hidden" name="<%=jspCustomer.colNames[JspCustomer.JSP_KOMIN_CREDIT_INCOME_ACCOUNT_ID] %>" value="<%=customer.getKominCreditIncomeAccountId()%>">
                    <input type="hidden" name="<%=jspCustomer.colNames[JspCustomer.JSP_KOMIN_PPN_ACCOUNT_ID] %>" value="<%=customer.getKominPpnAccountId()%>">
                    <input type="hidden" name="<%=jspCustomer.colNames[JspCustomer.JSP_KOMIN_PPH_ACCOUNT_ID] %>" value="<%=customer.getKominPphAccountId()%>">
                    
                    <input type="hidden" name="<%=jspCustomer.colNames[JspCustomer.JSP_LIMBAH_PPH_POTONG_SARANA] %>" value="<%=customer.getLimbahPphPotongSarana()%>">
                    <input type="hidden" name="<%=jspCustomer.colNames[JspCustomer.JSP_IRIGASI_PPH_POTONG_SARANA] %>" value="<%=customer.getIrigasiPphPotongSarana()%>">
                    <input type="hidden" name="<%=jspCustomer.colNames[JspCustomer.JSP_DENDA_ACCOUNT_ID]%>" value="<%=customer.getDendaAccountId()%>"
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">                    
                    <tr align="left" valign="top"> 
                        <td height="8" valign="middle" colspan="3" class="container"> 
                            <table width="100%" border="0" cellspacing="1" cellpadding="0">                                 
                                <tr align="left"> 
                                    <td height="10" valign="middle" colspan="3"><b></b></td>
                                </tr>
                                <tr align="left"> 
                                    <td height="21" valign="middle" width="14%">&nbsp;</td>
                                    <td height="21" colspan="2" width="86%" class="comment" valign="top">*)= Harus diisi </td>
                                </tr>
                                <tr align="left"> 
                                    <td height="21" width="14%">&nbsp;Tipe</td>
                                    <td height="21" colspan="2" width="86%"> 
                                        <%
            Vector custype_value = new Vector(1, 1);
            Vector custype_key = new Vector(1, 1);
            String sel_custypeid = "" + customer.getType();

            custype_key.add("" + DbCustomer.CUSTOMER_TYPE_COMMON_AREA);
            custype_value.add("" + DbCustomer.customerType[DbCustomer.CUSTOMER_TYPE_COMMON_AREA]);

            custype_key.add("" + DbCustomer.CUSTOMER_TYPE_HOTEL);
            custype_value.add("" + DbCustomer.customerType[DbCustomer.CUSTOMER_TYPE_HOTEL]);

            custype_key.add("" + DbCustomer.CUSTOMER_TYPE_RESTAURANT);
            custype_value.add("" + DbCustomer.customerType[DbCustomer.CUSTOMER_TYPE_RESTAURANT]);


                                        %>
                                    <%= JSPCombo.draw(jspCustomer.colNames[JspCustomer.JSP_TYPE], null, sel_custypeid, custype_key, custype_value, "", "formElemen") %></td>
                                </tr> 
                                <tr align="left"> 
                                    <td height="21" width="14%">&nbsp;Investor</td>
                                    <td height="21" colspan="2" width="86%"> 
                                        <%
            Vector vctInduk = DbIndukCustomer.list(0, 0, "", "");

            Vector customerIndukid_value = new Vector(1, 1);
            Vector customerIndukid_key = new Vector(1, 1);
            String sel_customerIndukid = "" + customer.getIndukCustomerId();

            if (vctInduk != null && vctInduk.size() > 0) {
                for (int i = 0; i < vctInduk.size(); i++) {
                    IndukCustomer customerInduk = (IndukCustomer) vctInduk.get(i);
                    customerIndukid_key.add("" + customerInduk.getOID());
                    customerIndukid_value.add("" + customerInduk.getName());
                }
            }
                                        %>
                                    <%= JSPCombo.draw(jspCustomer.colNames[JspCustomer.JSP_INDUK_CUSTOMER_ID], null, sel_customerIndukid, customerIndukid_key, customerIndukid_value, "", "formElemen") %> *<span class="style1"> <%=jspCustomer.getErrorMsg(JspCustomer.JSP_INDUK_CUSTOMER_ID)%> </span> </td>
                                </tr>
                                <tr align="left"> 
                                    <td height="21" width="14%">&nbsp;Nama Sarana</td>
                                    <td height="21" colspan="2" width="86%"> 
                                        <input type="text" name="<%=jspCustomer.colNames[JspCustomer.JSP_NAME] %>"  value="<%= customer.getName() %>" class="formElemen" size="65">
                                    *<span class="style1"> <%=jspCustomer.getErrorMsg(JspCustomer.JSP_NAME)%> </span> </td>
                                </tr>
                                <tr align="left"> 
                                    <td height="21" width="14%">&nbsp;Alamat</td>
                                    <td height="21" colspan="2" width="86%"> 
                                        <input type="text" name="<%=jspCustomer.colNames[JspCustomer.JSP_ADDRESS_1] %>"  value="<%= customer.getAddress1() %>" class="formElemen" size="65">
                                    *<span class="style1"> <%=jspCustomer.getErrorMsg(JspCustomer.JSP_ADDRESS_1)%> </span> </td>
                                </tr>
                                <tr align="left"> 
                                    <td height="21" width="14%">&nbsp;Kota</td>
                                    <td height="21" colspan="2" width="86%"> 
                                        <input type="text" name="<%=jspCustomer.colNames[JspCustomer.JSP_CITY] %>"  value="<%= customer.getCity() %>" class="formElemen" size="65">
                                    *<span class="style1"> <%=jspCustomer.getErrorMsg(JspCustomer.JSP_CITY)%> </span> </td>
                                </tr>
                                <tr align="left"> 
                                    <td height="21" width="14%">&nbsp;Negara</td>
                                    <td height="21" colspan="2" width="86%"> 
                                        <%
            Vector vctCtr = DbCountry.list(0, 0, "", "name");

            Vector countryid_value = new Vector(1, 1);
            Vector countryid_key = new Vector(1, 1);
            String sel_countryid = "" + customer.getCountryId();

            if (vctCtr != null && vctCtr.size() > 0) {
                for (int i = 0; i < vctCtr.size(); i++) {
                    Country ctr = (Country) vctCtr.get(i);
                    countryid_key.add("" + ctr.getOID());
                    countryid_value.add("" + ctr.getName());
                }
            }
                                        %>
                                    <%= JSPCombo.draw(jspCustomer.colNames[JspCustomer.JSP_COUNTRY_ID], null, sel_countryid, countryid_key, countryid_value, "", "formElemen") %> *<span class="style1"> <%=jspCustomer.getErrorMsg(JspCustomer.JSP_COUNTRY_ID)%> </span> </td>
                                </tr>
                                <tr align="left"> 
                                    <td height="21" width="14%">&nbsp;Kode Pos</td>
                                    <td height="21" colspan="2" width="86%"> 
                                    <input type="text" name="<%=jspCustomer.colNames[JspCustomer.JSP_POSTAL_CODE] %>"  value="<%= customer.getPostalCode() %>" class="formElemen" size="65"></td>
                                </tr>
                                <tr align="left"> 
                                    <td height="21" width="14%" nowrap>&nbsp;Telephone</td>
                                    <td height="21" colspan="2" width="86%"> 
                                        <input name="<%=jspCustomer.colNames[JspCustomer.JSP_COUNTRY_CODE] %>" type="text" class="formElemen"  value="<%= customer.getCountryCode() %>" size="5" maxlength="3">
                                        - 
                                        <input name="<%=jspCustomer.colNames[JspCustomer.JSP_AREA_CODE] %>" type="text" class="formElemen"  value="<%= customer.getAreaCode() %>" size="5" maxlength="4">
                                        - 
                                        <input type="text" name="<%=jspCustomer.colNames[JspCustomer.JSP_PHONE] %>"  value="<%= customer.getPhone() %>" class="formElemen" size="42">
                                    *<span class="style1"> <%=jspCustomer.getErrorMsg(JspCustomer.JSP_PHONE)%> </span> </td>
                                </tr>
                                <tr align="left"> 
                                    <td height="21" width="14%">&nbsp;Fax</td>
                                    <td height="21" colspan="2" width="86%"> 
                                        <input name="<%=jspCustomer.colNames[JspCustomer.JSP_COUNTRY_CODE] %>2" type="text" class="formElemen"  value="<%= customer.getCountryCode() %>" size="5" maxlength="3">
                                        - 
                                        <input name="<%=jspCustomer.colNames[JspCustomer.JSP_AREA_CODE] %>2" type="text" class="formElemen"  value="<%= customer.getAreaCode() %>" size="5" maxlength="4">
                                        - 
                                    <input type="text" name="<%=jspCustomer.colNames[JspCustomer.JSP_FAX] %>"  value="<%= (customer.getFax() == null) ? "" : customer.getFax() %>" class="formElemen" size="42"></td>
                                </tr>
                                <tr align="left"> 
                                    <td height="21" width="14%">&nbsp;Kontak Person</td>
                                    <td height="21" colspan="2" width="86%"> 
                                        <input type="text" name="<%=jspCustomer.colNames[JspCustomer.JSP_CONTACT_PERSON] %>"  value="<%= customer.getContactPerson() %>" class="formElemen" size="65">
                                    *<span class="style1"> <%=jspCustomer.getErrorMsg(JspCustomer.JSP_CONTACT_PERSON)%> </span> </td>
                                </tr>
                                <tr align="left"> 
                                    <td height="21" width="14%" nowrap>&nbsp;Jabatan Kontak Person &nbsp;</td>
                                    <td height="21" colspan="2" width="86%"> 
                                    <input type="text" name="<%=jspCustomer.colNames[JspCustomer.JSP_POSISI_CONTACT_PERSON] %>"  value="<%= customer.getPosisiContactPerson() %>" class="formElemen" size="65"></td>
                                </tr>
                                <tr align="left"> 
                                    <td height="21" width="14%">&nbsp;Website</td>
                                    <td height="21" colspan="2" width="86%"> 
                                    <input type="text" name="<%=jspCustomer.colNames[JspCustomer.JSP_WEBSITE] %>"  value="<%= customer.getWebsite() %>" class="formElemen" size="65"></td>
                                </tr>
                                <tr align="left"> 
                                <td height="21" width="14%">&nbsp;Email</td>
                                <td height="21" colspan="2" width="86%"> 
                                <input type="text" name="<%=jspCustomer.colNames[JspCustomer.JSP_EMAIL] %>"  value="<%= customer.getEmail() %>" class="formElemen" size="65">
                                <tr align="left">
                                    <td height="21" valign="top">Jatuh tempo </td>
                                    <td height="21" colspan="2"><input type="text" name="<%=jspCustomer.colNames[JspCustomer.JSP_DEF_DUE_DATE_DAY] %>"  value="<%= customer.getDefDueDateDay() %>" class="formElemen" size="10">&nbsp;Hari</td>
                                </tr>
                                <tr align="left"> 
                                    <td height="21" width="14%">&nbsp;Status</td>
                                    <td height="21" colspan="2" width="86%"> 
                                        <%
            Vector cusstatus_value = new Vector(1, 1);
            Vector cusstatus_key = new Vector(1, 1);
            String sel_cusstatusid = "" + customer.getStatus();

            cusstatus_key.add("" + DbCustomer.POSTED_STATUS_ACTIVE);
            cusstatus_value.add("" + DbCustomer.statusKey[DbCustomer.POSTED_STATUS_ACTIVE]);

            cusstatus_key.add("" + DbCustomer.POSTED_STATUS_UNACTIVE);
            cusstatus_value.add("" + DbCustomer.statusKey[DbCustomer.POSTED_STATUS_UNACTIVE]);

                                        %>
                                    <%= JSPCombo.draw(jspCustomer.colNames[JspCustomer.JSP_STATUS], null, sel_cusstatusid, cusstatus_key, cusstatus_value, "", "formElemen") %> </td>
                                </tr>
                                <tr align="left"> 
                                    <td height="21" width="14%">&nbsp;</td>
                                    <td height="21" colspan="2" width="86%">&nbsp;</td>
                                </tr>
                                <tr align="left"> 
                                    <td height="8" valign="middle" colspan="3"> 
                                        <%
            ctrLine.setLocationImg(approot + "/images/ctr_line");
            //ctrLine.setLocationImg(approot+"/images");
            ctrLine.initDefault();
            ctrLine.setTableWidth("100%");
            String scomDel = "javascript:cmdAsk('" + oidCustomer + "')";
            String sconDelCom = "javascript:cmdConfirmDelete('" + oidCustomer + "')";
            String scancel = "javascript:cmdEdit('" + oidCustomer + "')";
            ctrLine.setBackCaption("Back to List");
            ctrLine.setJSPCommandStyle("buttonlink");
            ctrLine.setDeleteCaption("Delete");
            ctrLine.setSaveCaption("Save");
            ctrLine.setAddCaption("");

            ctrLine.setOnMouseOut("MM_swapImgRestore()");
            ctrLine.setOnMouseOverSave("MM_swapImage('save_item','','" + approot + "/images/save2.gif',1)");
            ctrLine.setSaveImage("<img src=\"" + approot + "/images/save.gif\" name=\"save_item\" height=\"22\" border=\"0\">");

            //ctrLine.setOnMouseOut("MM_swapImgRestore()");
            ctrLine.setOnMouseOverBack("MM_swapImage('back_item','','" + approot + "/images/cancel2.gif',1)");
            ctrLine.setBackImage("<img src=\"" + approot + "/images/cancel.gif\" name=\"back_item\" height=\"22\" border=\"0\">");

            ctrLine.setOnMouseOverDelete("MM_swapImage('delete_item','','" + approot + "/images/delete2.gif',1)");
            ctrLine.setDeleteImage("<img src=\"" + approot + "/images/delete.gif\" name=\"delete_item\" height=\"22\" border=\"0\">");

            ctrLine.setOnMouseOverEdit("MM_swapImage('edit_item','','" + approot + "/images/cancel2.gif',1)");
            ctrLine.setEditImage("<img src=\"" + approot + "/images/cancel.gif\" name=\"edit_item\" height=\"22\" border=\"0\">");


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
                                    <%= ctrLine.drawImageOnly(iJSPCommand, iErrCode, msgString)%> </td>
                                </tr>
                                <tr align="left" > 
                                    <td colspan="3" class="command" valign="top">&nbsp;</td>
                                </tr>
                                <tr> 
                                    <td width="14%">&nbsp;</td>
                                    <td width="86%">&nbsp;</td>
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
