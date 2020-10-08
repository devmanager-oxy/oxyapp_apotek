
<%-- 
    Document   : customeredtnonreguler
    Created on : May 20, 2015, 3:34:40 PM
    Author     : Roy
--%>

<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.main.entity.*" %>
<%@ page import = "com.project.admin.*" %>
<%@ page import = "com.project.ccs.posmaster.*" %>
<%@ page import = "com.project.general.*" %>
<%@ page import = "com.project.*" %>
<%@ include file = "../main/javainit.jsp" %>
<%@ include file = "../main/check.jsp" %>
<%
            boolean priv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MASTER_MAINTENANCE, AppMenu.M2_MEMBER_NON_REGULER);
            boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MASTER_MAINTENANCE, AppMenu.M2_MEMBER_NON_REGULER, AppMenu.PRIV_VIEW);
            boolean privUpdate = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MASTER_MAINTENANCE, AppMenu.M2_MEMBER_NON_REGULER, AppMenu.PRIV_UPDATE);
            boolean privAdd = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MASTER_MAINTENANCE, AppMenu.M2_MEMBER_NON_REGULER, AppMenu.PRIV_ADD);
            boolean privDelete = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MASTER_MAINTENANCE, AppMenu.M2_MEMBER_NON_REGULER, AppMenu.PRIV_DELETE);
%>
<!-- Jsp Block -->
<%
            int iJSPCommand = JSPRequestValue.requestCommand(request);
            int start = JSPRequestValue.requestInt(request, "start");
            int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
            long oidCustomer = JSPRequestValue.requestLong(request, "hidden_customer_id");
            int isSearch = JSPRequestValue.requestInt(request, "hidden_search");

            /*variable declaration*/
            String msgString = "";
            int iErrCode = JSPMessage.NONE;
            String whereClause = "";

            String genCodeMember = "N";
            try {
                genCodeMember = DbSystemProperty.getValueByName("GENERATE_CODE_MEMBER_AUTOMATIC");
            } catch (Exception e) {
            }

            CmdCustomerOpr cmdCustomer = new CmdCustomerOpr(request);
            JSPLine ctrLine = new JSPLine();

            /*switch statement */
            iErrCode = cmdCustomer.action(iJSPCommand, oidCustomer);
            /* end switch*/
            JspCustomerOpr jspCustomer = cmdCustomer.getForm();

            /*count list All Customer*/
            int vectSize = DbCustomer.getCount(whereClause);

            Customer customer = cmdCustomer.getCustomer();
            msgString = cmdCustomer.getMessage();

            Vector listIndukCustomer = DbIndukCustomer.list(0, 0, "", DbIndukCustomer.colNames[DbIndukCustomer.COL_NAME]);
            Vector locations = DbLocation.list(0, 0, "", DbLocation.colNames[DbLocation.COL_NAME]);

%>
<html >
    <!-- #BeginTemplate "/Templates/indexpg.dwt" --> 
    <head>
        <!-- #BeginEditable "javascript" --> 
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <title><%=titleIS%></title>
        <link href="../css/default.css" rel="stylesheet" type="text/css" />
        <link href="../css/css.css" rel="stylesheet" type="text/css" />
        <script language="JavaScript">
            
            function cmdChange(){          
                document.frmcustomer.action="customeredtnonreguler.jsp";
                document.frmcustomer.submit();
            }
            
            <%if (!priv || !privView) {%>
            window.location="<%=approot%>/nopriv.jsp";
            <%}%>
            
            function cmdAdd(){
                document.frmcustomer.hidden_customer_id.value="0";
                document.frmcustomer.command.value="<%=JSPCommand.ADD%>";
                document.frmcustomer.prev_command.value="<%=prevJSPCommand%>";
                document.frmcustomer.action="customeredtnonreguler.jsp";
                document.frmcustomer.submit();
            }
            
            function cmdAsk(oidCustomer){
                document.frmcustomer.hidden_customer_id.value=oidCustomer;
                document.frmcustomer.command.value="<%=JSPCommand.ASK%>";
                document.frmcustomer.prev_command.value="<%=prevJSPCommand%>";
                document.frmcustomer.action="customeredtnonreguler.jsp";
                document.frmcustomer.submit();
            }
            
            function cmdConfirmDelete(oidCustomer){
                document.frmcustomer.hidden_customer_id.value=oidCustomer;
                document.frmcustomer.command.value="<%=JSPCommand.DELETE%>";
                document.frmcustomer.prev_command.value="<%=prevJSPCommand%>";
                document.frmcustomer.action="customeredtnonreguler.jsp";
                document.frmcustomer.submit();
            }
            function cmdSave(){
                document.frmcustomer.command.value="<%=JSPCommand.SAVE%>";
                document.frmcustomer.prev_command.value="<%=prevJSPCommand%>";
                document.frmcustomer.action="customeredtnonreguler.jsp";
                document.frmcustomer.submit();
            }
            
            function cmdEdit(oidCustomer){
                document.frmcustomer.hidden_customer_id.value=oidCustomer;
                document.frmcustomer.command.value="<%=JSPCommand.EDIT%>";
                document.frmcustomer.prev_command.value="<%=prevJSPCommand%>";
                document.frmcustomer.action="customeredtnonreguler.jsp";
                document.frmcustomer.submit();
            }
            
            function cmdCancel(oidCustomer){
                document.frmcustomer.hidden_customer_id.value=oidCustomer;
                document.frmcustomer.command.value="<%=JSPCommand.EDIT%>";
                document.frmcustomer.prev_command.value="<%=prevJSPCommand%>";
                document.frmcustomer.action="customeredtnonreguler.jsp";
                document.frmcustomer.submit();
            }
            
            function cmdBack(){
                document.frmcustomer.command.value="<%=JSPCommand.BACK%>";
                document.frmcustomer.action="customernonreguler.jsp";
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
                                        <td width="165" height="100%" valign="top" background="<%=approot%>/images/leftbg.gif"> 
                                            <!-- #BeginEditable "menu" --> 
                  <%@ include file="../main/menu.jsp"%>
                  <%@ include file="../calendar/calendarframe.jsp"%>
                                        <!-- #EndEditable --> </td>
                                        <td width="100%" valign="top"> 
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                <tr> 
                                                    <td><!-- #BeginEditable "content" --> 
                                                        <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
                                                            <tr> 
                                                                <td valign="top"> 
                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
                                                                        <tr> 
                                                                            <td valign="top"> 
                                                                                <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
                                                                                    <!--DWLayoutTable-->
                                                                                    <tr> 
                                                                                        <td width="100%" valign="top"> 
                                                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                                <tr> 
                                                                                                    <td> 
                                                                                                        <form name="frmcustomer" method ="post" action="">
                                                                                                            <input type="hidden" name="command" value="<%=iJSPCommand%>">
                                                                                                            <input type="hidden" name="vectSize" value="<%=vectSize%>">
                                                                                                            <input type="hidden" name="start" value="<%=start%>">
                                                                                                            <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                                                                                                            <input type="hidden" name="hidden_customer_id" value="<%=oidCustomer%>">
                                                                                                            <input type="hidden" name="hidden_search" value="<%=isSearch%>">
                                                                                                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>">                                                                                                            
                                                                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                                                <tr> 
                                                                                                                    <td valign="top"> 
                                                                                                                        <table width="100%" border="0" cellspacing="1" cellpadding="1" height="17">
                                                                                                                            <tr valign="bottom"> 
                                                                                                                                <td width="60%" height="23"><b><font color="#990000" class="lvl1">Member (Operational)</font><font class="tit1"> 
                                                                                                                                    &raquo; </font></b><b><font class="tit1"><span class="lvl2">Editor<br>
                                                                                                                                </span></font></b></td>
                                                                                                                                <td width="40%" height="23"> 
                                                                                                                                    <%@ include file = "../main/userpreview.jsp" %>
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                            <tr > 
                                                                                                                                <td colspan="2" height="3" background="<%=approot%>/images/line1.gif" ></td>
                                                                                                                            </tr>
                                                                                                                        </table>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                                <tr>
                                                                                                                    <td>&nbsp;</td>
                                                                                                                </tr>    
                                                                                                                <tr align="left" valign="top"> 
                                                                                                                    <td height="8" valign="middle" colspan="3" class="container"> 
                                                                                                                        <table width="1000" border="0" cellspacing="1" cellpadding="0">
                                                                                                                            <tr align="left"> 
                                                                                                                                <td width="100">&nbsp;</td>
                                                                                                                                <td width="1"></td>
                                                                                                                                <td class="fontarial"><i>*)= required</i></td>
                                                                                                                                <td width="110">&nbsp;</td>
                                                                                                                                <td width="1"></td>
                                                                                                                                <td >&nbsp;</td>
                                                                                                                            </tr>
                                                                                                                            <tr align="left" height="23"> 
                                                                                                                                <td class="tablearialcell1">&nbsp;&nbsp;Type</td>
                                                                                                                                <td width="1" class="fontarial">:</td>
                                                                                                                                <td > 
                                                                                                                                    <select name="<%=jspCustomer.colNames[JspCustomer.JSP_TYPE] %>" class="fontarial">                                                                                                                                        
                                                                                                                                        <option value="<%=DbCustomer.CUSTOMER_TYPE_REGULAR%>" <%if (customer.getType() == DbCustomer.CUSTOMER_TYPE_REGULAR) {%>selected<%}%>><%=DbCustomer.customerType[DbCustomer.CUSTOMER_TYPE_REGULAR]%></option>                                                                                                                                        
                                                                                                                                        <option value="<%=DbCustomer.CUSTOMER_TYPE_COMPANY%>" <%if (customer.getType() == DbCustomer.CUSTOMER_TYPE_COMPANY) {%>selected<%}%>><%=DbCustomer.customerType[DbCustomer.CUSTOMER_TYPE_COMPANY]%></option>                                                                                                                                        
                                                                                                                                    </select>
                                                                                                                                </td>
                                                                                                                                <td class="tablearialcell1">&nbsp;&nbsp;Group</td>
                                                                                                                                <td width="1" class="fontarial">:</td>
                                                                                                                                <td class="fontarial">
                                                                                                                                    <select name="<%=jspCustomer.colNames[JspCustomer.JSP_INDUK_CUSTOMER_ID] %>" class="fontarial">     
                                                                                                                                        <option value="0" <%if (customer.getIndukCustomerId() == 0) {%>selected<%}%>>- non group -</option>
                                                                                                                                        <%
            if (listIndukCustomer != null && listIndukCustomer.size() > 0) {
                for (int x = 0; x < listIndukCustomer.size(); x++) {
                    IndukCustomer ic = (IndukCustomer) listIndukCustomer.get(x);
                                                                                                                                        %>
                                                                                                                                        <option value="<%=ic.getOID()%>" <%if (customer.getIndukCustomerId() == ic.getOID()) {%>selected<%}%>><%=ic.getName()%></option>                                                                                                                                        
                                                                                                                                        <%}
            }%>    
                                                                                                                                    </select>
                                                                                                                                </td>
                                                                                                                            </tr>                                
                                                                                                                            <tr height="23"> 
                                                                                                                                <td class="tablearialcell">&nbsp;&nbsp;Name</td>
                                                                                                                                <td width="1" class="fontarial">:</td>
                                                                                                                                <td >
                                                                                                                                    <input type="text" name="<%=jspCustomer.colNames[JspCustomer.JSP_NAME] %>"  value="<%= customer.getName() %>" class="formElemen" size="31">
                                                                                                                                    <%=jspCustomer.getErrorMsg(jspCustomer.JSP_NAME)%> *
                                                                                                                                </td>
                                                                                                                                <%if (genCodeMember.equalsIgnoreCase("Y")) {%>
                                                                                                                                <%if (customer.getOID() != 0) {%>
                                                                                                                                <td class="tablearialcell">&nbsp;&nbsp;Barcode</td>
                                                                                                                                <td width="1" class="fontarial">:</td>
                                                                                                                                <td class="fontarial"><input type="text" name="<%=jspCustomer.colNames[JspCustomer.JSP_CODE] %>"  value="<%= customer.getCode() %>" class="formElemen" size="31"></td>
                                                                                                                                <%} else {%>
                                                                                                                                <input type="hidden" name="<%=jspCustomer.colNames[JspCustomer.JSP_CODE] %>"  value="">
                                                                                                                                <%
    }
} else {%>                                                                                                                                                                                                                                                                
                                                                                                                                <td class="tablearialcell">&nbsp;&nbsp;Barcode</td>
                                                                                                                                <td width="1" class="fontarial">:</td>
                                                                                                                                <td class="fontarial"><input type="text" name="<%=jspCustomer.colNames[JspCustomer.JSP_CODE] %>"  value="<%= customer.getCode() %>" class="formElemen" size="31">
                                                                                                                                    <%=jspCustomer.getErrorMsg(jspCustomer.JSP_CODE)%> *
                                                                                                                                </td>
                                                                                                                                <%}%>
                                                                                                                            </tr>                                
                                                                                                                            <tr height="23"> 
                                                                                                                                <td class="tablearialcell1">&nbsp;&nbsp;Address</td>
                                                                                                                                <td width="1" class="fontarial">:</td>
                                                                                                                                <td ><input type="text" name="<%=jspCustomer.colNames[JspCustomer.JSP_ADDRESS_1] %>"  value="<%= customer.getAddress1() %>" class="formElemen" size="31"></td>                                                                                                                                
                                                                                                                                <td class="tablearialcell1">&nbsp;&nbsp;Country</td>
                                                                                                                                <td width="1" class="fontarial">:</td>
                                                                                                                                <td > 
                                                                                                                                    <%
            Vector vctCtr = DbCountry.list(0, 0, "", "name");

            Vector countryid_value = new Vector(1, 1);
            Vector countryid_key = new Vector(1, 1);
            String sel_countryid = "" + customer.getCountryId();

            countryid_key.add("0");
            countryid_value.add("- select - ");

            if (vctCtr != null && vctCtr.size() > 0) {
                for (int i = 0; i < vctCtr.size(); i++) {
                    Country ctr = (Country) vctCtr.get(i);
                    countryid_key.add("" + ctr.getOID());
                    countryid_value.add("" + ctr.getName());
                }
            }
                                                                                                                                    %>
                                                                                                                                <%= JSPCombo.draw(jspCustomer.colNames[JspCustomer.JSP_COUNTRY_ID], null, sel_countryid, countryid_key, countryid_value, "", "formElemen") %></td> 
                                                                                                                            </tr>
                                                                                                                            <tr height="23"> 
                                                                                                                                <td class="tablearialcell">&nbsp;&nbsp;Date of birth</td>
                                                                                                                                <td width="1" class="fontarial">:</td>
                                                                                                                                <td >
                                                                                                                                    <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                                        <tr>
                                                                                                                                            <td><input name="<%=jspCustomer.colNames[JspCustomer.JSP_DOB]%>" value="<%=JSPFormater.formatDate((customer.getDob() == null) ? new Date() : customer.getDob(), "dd/MM/yyyy")%>" size="11" readonly></td>
                                                                                                                                            <td><a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmcustomer.<%=jspCustomer.colNames[JspCustomer.JSP_DOB]%>);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a></td>
                                                                                                                                            <td>&nbsp;<input type="checkbox"  name="<%=jspCustomer.colNames[JspCustomer.JSP_DOB_IGNORE]%>" value="1" <%if (customer.getDobIgnore() == 1 || customer.getDob() == null) {%> checked<%}%> ></td>
                                                                                                                                            <td>&nbsp;Ignore</td>
                                                                                                                                        </tr>    
                                                                                                                                    </table>
                                                                                                                                </td>
                                                                                                                                <%if (false) {%>
                                                                                                                                <td class="tablearialcell">&nbsp;&nbsp;Price Type</td> 
                                                                                                                                <td class="fontarial">:</td>
                                                                                                                                <%
    Customer cus = new Customer();
    if (oidCustomer != 0) {
        try {
            cus = DbCustomer.fetchExc(oidCustomer);
        } catch (Exception e) {
        }
    }
                                                                                                                                %>   
                                                                                                                                <td > 
                                                                                                                                    <select name="<%=JspCustomer.colNames[JspCustomer.JSP_GOL_PRICE] %>" class="formElemen">
                                                                                                                                        <%for (int i = 0; i < DbCustomer.golPrice.length; i++) {%>                                                                                                                                               
                                                                                                                                        <option <%if (cus.getGolPrice().equalsIgnoreCase(DbCustomer.golPrice[i])) {%>selected<%}%> value="<%=DbCustomer.golPrice[i]%>"><%=DbCustomer.golPrice[i]%></option>
                                                                                                                                        <%}%>
                                                                                                                                    </select>
                                                                                                                                </td>
                                                                                                                                <%}%>
                                                                                                                            </tr>  
                                                                                                                            <%
            if (customer.getIdType() == null) {
                customer.setIdType("");
            }
                                                                                                                            %>
                                                                                                                            <tr height="23"> 
                                                                                                                                <td class="tablearialcell1">&nbsp;&nbsp;Hp 1</td>
                                                                                                                                <td width="1" class="fontarial">:</td>
                                                                                                                                <td >                                                                                                                                     
                                                                                                                                    <input type="text" name="<%=jspCustomer.colNames[JspCustomer.JSP_PHONE] %>"  value="<%= (customer.getPhone() == null) ? "" : customer.getPhone() %>" class="formElemen" size="20">
                                                                                                                                </td>
                                                                                                                                <td class="tablearialcell1">&nbsp;&nbsp;Type ID/Number</td>
                                                                                                                                <td class="fontarial">:</td>
                                                                                                                                <td >
                                                                                                                                    <table cellpadding="0" cellspacing="0" border="0">
                                                                                                                                        <tr>
                                                                                                                                            <td>
                                                                                                                                                <select name="<%=jspCustomer.colNames[JspCustomer.JSP_ID_TYPE]%>">
                                                                                                                                                    <option value="" <%if (customer.getIdType().equalsIgnoreCase("")) {%> selected<%}%> >-none-</option>
                                                                                                                                                    <option value="<%=I_Project.ID_TYPE_KTP%>" <%if (customer.getIdType().equalsIgnoreCase(I_Project.ID_TYPE_KTP)) {%> selected<%}%> ><%=I_Project.ID_TYPE_KTP%></option>
                                                                                                                                                    <option value="<%=I_Project.ID_TYPE_SIM%>" <%if (customer.getIdType().equalsIgnoreCase(I_Project.ID_TYPE_SIM)) {%> selected<%}%> ><%=I_Project.ID_TYPE_SIM%></option>
                                                                                                                                                    <option value="Other" <%if (customer.getIdType().equalsIgnoreCase("Other")) {%> selected<%}%> >Other</option>
                                                                                                                                                </select>
                                                                                                                                            </td>
                                                                                                                                            <td>&nbsp;</td>
                                                                                                                                            <td><input type="text" name="<%=jspCustomer.colNames[JspCustomer.JSP_ID_NUMBER] %>"  value="<%= customer.getIdNumber()%>" class="formElemen" size="25"></td>                                                                                                                                            
                                                                                                                                        </tr>
                                                                                                                                    </table>
                                                                                                                                </td>
                                                                                                                                <%if (false) {%>
                                                                                                                                <td class="tablearialcell1">&nbsp;&nbsp;Personal Discount</td>
                                                                                                                                <td class="fontarial">:</td>
                                                                                                                                <td > 
                                                                                                                                    <input type="text" name="<%=jspCustomer.colNames[JspCustomer.JSP_PERSONAL_DISCOUNT] %>"  value="<%= customer.getPersonalDiscount() %>" class="formElemen" size="5">%
                                                                                                                                </td>
                                                                                                                                <%}%>
                                                                                                                            </tr>
                                                                                                                            <tr align="left" height="23"> 
                                                                                                                                <td class="tablearialcell">&nbsp;&nbsp;Hp 2</td>
                                                                                                                                <td class="fontarial">:</td>
                                                                                                                                <td ><input type="text" name="<%=jspCustomer.colNames[JspCustomer.JSP_HP] %>"  value="<%= (customer.getHp() == null) ? "" : customer.getHp() %>" class="formElemen" size="31"></td>
                                                                                                                                <td class="tablearialcell">&nbsp;&nbsp;Tax ID/NPWP&nbsp;&nbsp;</td>
                                                                                                                                <td class="fontarial">:</td>
                                                                                                                                <td > 
                                                                                                                                    <% Vector idtype_value = new Vector(1, 1);
            Vector idtype_key = new Vector(1, 1);
            String sel_idtype = "" + customer.getIdType();
            for (int i = 0; i < I_Project.idTypeArray.length; i++) {
                idtype_key.add(I_Project.idTypeArray[i]);
                idtype_value.add(I_Project.idTypeArray[i]);
            }
                                                                                                                                    %>                                    
                                                                                                                                    <input type="text" name="<%=jspCustomer.colNames[JspCustomer.JSP_NPWP] %>"  value="<%= customer.getNpwp() %>" class="formElemen" size="31">
                                                                                                                                </td>  
                                                                                                                            </tr>
                                                                                                                            <tr align="left" height="23"> 
                                                                                                                                <td class="tablearialcell1">&nbsp;&nbsp;Email</td>
                                                                                                                                <td class="fontarial">:</td>
                                                                                                                                <td ><input type="text" name="<%=jspCustomer.colNames[JspCustomer.JSP_EMAIL] %>"  value="<%= (customer.getEmail() == null) ? "" : customer.getEmail() %>" class="formElemen" size="31"></td>
                                                                                                                                <td class="tablearialcell1">&nbsp;&nbsp;Location Register&nbsp;&nbsp;</td>
                                                                                                                                <td class="fontarial">:</td>
                                                                                                                                <td > 
                                                                                                                                    <select name="<%=jspCustomer.colNames[JspCustomer.JSP_KECAMATAN_ID]%>" class="fontarial">
                                                                                                                                        <option value="0">- none -</option>
                                                                                                                                        <%
            if (locations != null && locations.size() > 0) {
                for (int z = 0; z < locations.size(); z++) {
                    Location l = (Location) locations.get(z);
                                                                                                                                        %>
                                                                                                                                        <option value="<%=l.getOID()%>" <%if (l.getOID() == customer.getKecamatanId()) {%> selected<%}%> ><%=l.getName()%></option>
                                                                                                                                        <%
                }
            }
                                                                                                                                        %>
                                                                                                                                    </select>    
                                                                                                                                </td>  
                                                                                                                            </tr>
                                                                                                                            <tr align="left" height="23"> 
                                                                                                                                <%if (false) {%>
                                                                                                                                <td class="tablearialcell">&nbsp;&nbsp;Credit Limit</td>
                                                                                                                                <td class="fontarial">:</td>
                                                                                                                                <td ><input type="text" name="<%=jspCustomer.colNames[JspCustomer.JSP_CREDIT_LIMIT] %>"  value="<%=JSPFormater.formatNumber(customer.getCreditLimit(), "###,###.##")%>" style="text-align:right" readonly class="readOnly" size="20"></td>                                                                                                                                
                                                                                                                                <%}%>
                                                                                                                                <td class="tablearialcell">&nbsp;&nbsp;Status&nbsp;&nbsp;</td>
                                                                                                                                <td class="fontarial">:</td>
                                                                                                                                <td > 
                                                                                                                                    <select name="<%=JspCustomer.colNames[JspCustomer.JSP_STATUS] %>" class="fontarial">
                                                                                                                                        <option value="<%=I_Project.DOC_STATUS_DRAFT%>"  <%if (customer.getStatus().equalsIgnoreCase(I_Project.DOC_STATUS_DRAFT)) {%>selected<%}%>  > <%=I_Project.DOC_STATUS_DRAFT%></option>
                                                                                                                                        <option value="<%=I_Project.DOC_STATUS_APPROVED%>"  <%if (customer.getStatus().equalsIgnoreCase(I_Project.DOC_STATUS_APPROVED)) {%>selected<%}%>  > <%=I_Project.DOC_STATUS_APPROVED %></option>
                                                                                                                                        <option value="<%=I_Project.DOC_STATUS_EXPIRED%>"  <%if (customer.getStatus().equalsIgnoreCase(I_Project.DOC_STATUS_EXPIRED)) {%>selected<%}%>  > <%=I_Project.DOC_STATUS_EXPIRED %></option>
                                                                                                                                    </select>
                                                                                                                                </td>  
                                                                                                                            </tr>
                                                                                                                            <%if (false) {%>
                                                                                                                            <tr align="left" height="23"> 
                                                                                                                                <td class="tablearialcell1">&nbsp;&nbsp;Term of Payment</td>
                                                                                                                                <td class="fontarial">:</td>
                                                                                                                                <td ><input type="text" name="<%=jspCustomer.colNames[JspCustomer.JSP_DEF_DUE_DATE_DAY] %>"  value="<%=customer.getDefDueDateDay()%>" style="text-align:right" class="fontarial" size="20"> Day(s)</td>                                                                                                                               
                                                                                                                                <td ></td>
                                                                                                                                <td ></td>
                                                                                                                                <td ></td>  
                                                                                                                            </tr>
                                                                                                                            <%}%>
                                                                                                                            <tr> 
                                                                                                                                <td colspan="6" height="2"> 
                                                                                                                                    <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                                                                                        <tr > 
                                                                                                                                            <td height="3" background="../images/line1.gif" ></td>
                                                                                                                                        </tr>
                                                                                                                                    </table>
                                                                                                                                </td>
                                                                                                                            </tr>                                                                                                                            
                                                                                                                            <tr align="left"> 
                                                                                                                                <td height="8" valign="middle" colspan="4"> 
                                                                                                                                    <%
            ctrLine.setLocationImg(approot + "/images/ctr_line");
            ctrLine.initDefault();
            ctrLine.setTableWidth("60%");
            String scomDel = "javascript:cmdAsk('" + oidCustomer + "')";
            String sconDelCom = "javascript:cmdConfirmDelete('" + oidCustomer + "')";
            String scancel = "javascript:cmdEdit('" + oidCustomer + "')";
            ctrLine.setBackCaption("Back to List");
            ctrLine.setJSPCommandStyle("buttonlink");
            ctrLine.setDeleteCaption("Delete");
            ctrLine.setSaveCaption("Save");
            ctrLine.setAddCaption("");

            ctrLine.setOnMouseOut("MM_swapImgRestore()");
            ctrLine.setOnMouseOverSave("MM_swapImage('save','','" + approot + "/images/save2.gif',1)");
            ctrLine.setSaveImage("<img src=\"" + approot + "/images/save.gif\" name=\"save\" height=\"22\" border=\"0\">");
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
                                                                                                                            <tr align="left" > 
                                                                                                                                <td colspan="4" valign="top"> 
                                                                                                                                    <div align="left"></div>
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                        </table>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                            </table>                                                                    
                                                                                                        </form>
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
                                                                    </table>
                                                                </td>
                                                            </tr>
                                                        </table>
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
