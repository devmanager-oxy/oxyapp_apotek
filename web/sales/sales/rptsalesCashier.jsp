
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %> 
<%@ page import = "com.project.main.db.*" %>
<%@ page import = "com.project.main.entity.*" %>
<%@ page import = "com.project.admin.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "com.project.fms.master.*" %>
<%@ page import = "com.project.ccs.postransaction.sales.*" %>
<%@ page import = "com.project.ccs.posmaster.*" %>
<%@ include file = "../main/javainit.jsp" %>
<%@ include file = "../main/checksl.jsp" %>
<%@ include file="../calendar/calendarframe.jsp"%>
<%    
            boolean priv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_SALES_REPORT, AppMenu.M2_SAL_REPORT_CASHIER);
            boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_SALES_REPORT, AppMenu.M2_SAL_REPORT_CASHIER, AppMenu.PRIV_VIEW);
            boolean privPrint = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_SALES_REPORT, AppMenu.M2_SAL_REPORT_CASHIER, AppMenu.PRIV_PRINT);
%>
<!-- Jsp Block -->
<%!
    public String drawList(Vector objectClass, long salesId) {
        JSPList ctrlist = new JSPList();
        ctrlist.setAreaWidth("100%");
        ctrlist.setListStyle("listgen");
        ctrlist.setTitleStyle("tablehdr");
        ctrlist.setCellStyle("tablecell");
        ctrlist.setCellStyle1("tablecell1");
        ctrlist.setHeaderStyle("tablehdr");

        ctrlist.addHeader("Date dd/MM/yy", "5%");
        ctrlist.addHeader("Sales Number", "13%");        
        ctrlist.addHeader("Amount", "10%");
        ctrlist.addHeader("Discount", "10%");
        ctrlist.addHeader("Vat", "10%");
        ctrlist.addHeader("Total Amount", "10%");        

        ctrlist.setLinkRow(0);
        ctrlist.setLinkSufix("");
        Vector lstData = ctrlist.getData();
        Vector lstLinkData = ctrlist.getLinkData();
        
        ctrlist.setLinkPrefix("javascript:targetPage('");
        ctrlist.setLinkSufix("')");
        ctrlist.reset();
        int index = -1;

        for (int i = 0; i < objectClass.size(); i++) {
            Sales sales = (Sales) objectClass.get(i);

            Vector rowx = new Vector();
            if (salesId == sales.getOID()) {
                index = i;
            }

            String str_dt_Date = "";
            try {
                Date dt_Date = sales.getDate();
                if (dt_Date == null) {
                    dt_Date = new Date();
                }

                str_dt_Date = JSPFormater.formatDate(dt_Date, "dd/MM/yy");
            } catch (Exception e) {
                str_dt_Date = "";
            }

            rowx.add(str_dt_Date);
            rowx.add(sales.getNumber());

            //rowx.add(sales.getName());

            Customer customer = new Customer();
            try {
                customer = DbCustomer.fetchExc(sales.getCustomerId());
            } catch (Exception e) {
            }

            rowx.add("<div align=\"right\">" + JSPFormater.formatNumber(sales.getAmount(), "#,###") + "</div>");
            rowx.add("<div align=\"right\">" + JSPFormater.formatNumber(sales.getDiscountAmount(), "#,###") + "</div>");
            rowx.add("<div align=\"right\">" + JSPFormater.formatNumber(sales.getVatAmount(), "#,###") + "</div>");
            rowx.add("<div align=\"right\">" + JSPFormater.formatNumber(sales.getAmount() - sales.getDiscountAmount() + sales.getVatAmount(), "#,###") + "</div>");

            String str_dt_StartDate = "";
            try {
                Date dt_StartDate = sales.getStartDate();
                if (dt_StartDate == null) {
                    dt_StartDate = new Date();
                }

                str_dt_StartDate = JSPFormater.formatDate(dt_StartDate, "dd/MM/yy");
            } catch (Exception e) {
                str_dt_StartDate = "";
            }

            String str_dt_EndDate = "";
            try {
                Date dt_EndDate = sales.getEndDate();
                if (dt_EndDate == null) {
                    dt_EndDate = new Date();
                }

                str_dt_EndDate = JSPFormater.formatDate(dt_EndDate, "dd/MM/yy");
            } catch (Exception e) {
                str_dt_EndDate = "";
            }

            Employee em = new Employee();
            try {
                em = DbEmployee.fetchExc(sales.getEmployeeId());
            } catch (Exception e) {
            }

            lstData.add(rowx);            
            lstLinkData.add(String.valueOf(sales.getOID()));
        }

        return ctrlist.draw(index);
    }

%>
<%

            int salesType = JSPRequestValue.requestInt(request, "sales_type");
            Date invStartDate = JSPFormater.formatDate(JSPRequestValue.requestString(request, "invStartDate"), "dd/MM/yyyy");
            Date invEndDate = JSPFormater.formatDate(JSPRequestValue.requestString(request, "invEndDate"), "dd/MM/yyyy");
            int chkInvDate = JSPRequestValue.requestInt(request, "chkInvDate");

            long locationId = JSPRequestValue.requestLong(request, "src_location_id");
            long shiftId = JSPRequestValue.requestLong(request, "JSP_SHIFT_ID");

            int iJSPCommand = JSPRequestValue.requestCommand(request);
            int start = JSPRequestValue.requestInt(request, "start");
            int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");

            int jumLocation = 0;
            int jumShift = 0;

            if (locationId == 0) {
                jumLocation = DbLocation.getCount("");
            } else {
                jumLocation = 1;
            }

            if (shiftId == 0) {
                jumShift = DbShift.getCount("");
            } else {
                jumShift = 1;
            }


            if (iJSPCommand == JSPCommand.NONE) {
                salesType = -1;
            }


            String whereClause = "";

            if (invStartDate == null) {
                invStartDate = new Date();
            }

            if (invEndDate == null) {
                invEndDate = new Date();
            }

            Vector listSales = new Vector();

%>
<html >
    <!-- #BeginTemplate "/Templates/indexsl.dwt" --> 
    <head>
        <!-- #BeginEditable "javascript" --> 
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <title><%=salesSt%></title>
        <link href="../css/csssl.css" rel="stylesheet" type="text/css" />
        <script language="JavaScript">        
            <%if (!priv || !privView) {%>
            window.location="<%=approot%>/nopriv.jsp";
            <%}%>            
            
            function cmdSearch(){
                document.frmsales.command.value="<%=JSPCommand.SUBMIT%>";
                document.frmsales.action="rptsalesCashier.jsp?menu_idx=<%=menuIdx%>";
                document.frmsales.submit();
            }
            
            function cmdLocation(){
                document.frmsales.command.value="<%=JSPCommand.LOAD%>";
                document.frmsales.action="rptsalesCashier.jsp";
                document.frmsales.submit();
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
    <body onLoad="MM_preloadImages('<%=approot%>/imagessl/home2.gif','<%=approot%>/imagessl/logout2.gif','../images/search2.gif')">
        <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
            <tr> 
                <td valign="top"> 
                    <table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
                        <tr> 
                            <td height="96"> <!-- #BeginEditable "header" --> 
            <%@ include file="../main/hmenusl.jsp"%>
                            <!-- #EndEditable --> </td>
                        </tr>
                        <tr> 
                            <td valign="top"> 
                                <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
                                    <!--DWLayoutTable-->
                                    <tr> 
                                        <td width="165" height="100%" valign="top" background="<%=approot%>/imagessl/leftbg.gif"> 
                                            <!-- #BeginEditable "menu" --> 
                  <%@ include file="../main/menusl.jsp"%>
                                        <!-- #EndEditable --> </td>
                                        <td width="100%" valign="top"> 
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                <tr> 
                                                    <td><!-- #BeginEditable "content" --> 
                                                        <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
                                                            <tr> 
                                                                <td valign="top"> 
                                                                    
                                                                    <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
                                                                        <!--DWLayoutTable-->
                                                                        <tr> 
                                                                            <td width="100%" valign="top"> 
                                                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                    <tr> 
                                                                                        <td> 
                                                                                            <form name="frmsales" method ="post" action="">
                                                                                                <input type="hidden" name="command" value="<%=iJSPCommand%>">
                                                                                                <input type="hidden" name="start" value="<%=start%>">
                                                                                                <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                                                                                                <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                                    <tr> 
                                                                                                        <td valign="top"> 
                                                                                                            <table width="100%" border="0" cellspacing="1" cellpadding="1" height="17">
                                                                                                                <tr valign="bottom"> 
                                                                                                                    <td width="60%" height="23"><b><font color="#990000" class="lvl1">Sales Report
                                                                                                                            </font><font class="tit1">&raquo; 
                                                                                                                    <span class="lvl2">Report Cashier </span></font></b></td>
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
                                                                                                    <tr align="left" valign="top"> 
                                                                                                        <td height="8"  colspan="3" class="container"> 
                                                                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                                                <tr align="left" valign="top"> 
                                                                                                                    <td height="8" valign="middle" colspan="3"> 
                                                                                                                        <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                                                                            <tr> 
                                                                                                                                <td width="100">&nbsp;</td>
                                                                                                                                <td width="2">&nbsp;</td>
                                                                                                                                <td >&nbsp;</td>
                                                                                                                            </tr>
                                                                                                                            <tr height="24"> 
                                                                                                                                <td class="tablearialcell" nowrap>&nbsp;&nbsp;Date Between</td>
                                                                                                                                <td class="fontarial">:</td>
                                                                                                                                <td > 
                                                                                                                                    <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                                        <tr>
                                                                                                                                            <td>
                                                                                                                                                <input name="invStartDate" value="<%=JSPFormater.formatDate((invStartDate == null) ? new Date() : invStartDate, "dd/MM/yyyy")%>" size="11" style="text-align:center" readOnly>
                                                                                                                                            </td>
                                                                                                                                            <td>
                                                                                                                                                <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmsales.invStartDate);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt="visit date"></a> 
                                                                                                                                            </td>
                                                                                                                                            <td class="fontarial">&nbsp;&nbsp;and&nbsp;&nbsp;</td>
                                                                                                                                            <td>
                                                                                                                                                <input name="invEndDate" value="<%=JSPFormater.formatDate((invEndDate == null) ? new Date() : invEndDate, "dd/MM/yyyy")%>" size="11" style="text-align:center" readOnly>
                                                                                                                                            </td>
                                                                                                                                            <td>
                                                                                                                                                <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmsales.invEndDate);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt="visit date"></a> 
                                                                                                                                            </td>    
                                                                                                                                        </tr>   
                                                                                                                                    </table>   
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                            <tr> 
                                                                                                                                <td class="tablearialcell">&nbsp;&nbsp;Location</td>
                                                                                                                                <td class="fontarial">:</td>
                                                                                                                                <td > 
                                                                                                                                    <%
            Vector vloc = userLocations;
                                                                                                                                    %>
                                                                                                                                    <select name="src_location_id" onChange="javascript:cmdLocation()" class="fontarial">
                                                                                                                                        <%if (vloc.size() == totLocationxAll) {%>
                                                                                                                                        <option value="0"> - All Location -</option>
                                                                                                                                        <%}%>
                                                                                                                                        <%if (vloc != null && vloc.size() > 0) {
                for (int i = 0; i < vloc.size(); i++) {
                    Location us = (Location) vloc.get(i);

                                                                                                                                        %>
                                                                                                                                        <option value="<%=us.getOID()%>" <%if (us.getOID() == locationId) {%>selected<%}%>><%=us.getName().toUpperCase()%></option>
                                                                                                                                        <%}
            }%>
                                                                                                                                    </select>
                                                                                                                                </td>                                                                            
                                                                                                                            </tr>                                                                        
                                                                                                                            <tr> 
                                                                                                                                <td class="tablearialcell">&nbsp;&nbsp;Shift</td>
                                                                                                                                <td class="fontarial">:</td>
                                                                                                                                <td > 
                                                                                                                                    <%
            Vector vShift = DbShift.list(0, 0, "", "");            
                                                                                                                                    %>
                                                                                                                                    <select name="<%=JspShift.colNames[JspShift.JSP_SHIFT_ID]%>" class="fontarial">
                                                                                                                                        <option value="0">- All Shift -</option>
                                                                                                                                        <%if (vShift != null && vShift.size() > 0) {
                for (int i = 0; i < vShift.size(); i++) {
                    Shift sf = (Shift) vShift.get(i);

                                                                                                                                        %>
                                                                                                                                        <option value="<%=sf.getOID()%>" <%if (sf.getOID() == shiftId) {%>selected<%}%>><%=sf.getName()%></option>
                                                                                                                                        <%}
            }%>
                                                                                                                                    </select>
                                                                                                                                </td>                                                                            
                                                                                                                            </tr>
                                                                                                                            <tr>
                                                                                                                                <td class="tablearialcell">&nbsp;&nbsp;Sales Type</td>
                                                                                                                                <td class="fontarial">:</td>
                                                                                                                                <td > 
                                                                                                                                    <select name="sales_type" class="fontarial">
                                                                                                                                        <option value="-1" <%if (salesType == -1) {%>selected<%}%>>- All Type -</option>	
                                                                                                                                        <option value="0" <%if (salesType == 0) {%>selected<%}%>>Cash</option>
                                                                                                                                        <option value="1" <%if (salesType == 1) {%>selected<%}%>>Credit</option>
                                                                                                                                        <option value="2" <%if (salesType == 2) {%>selected<%}%>>Retur Cash</option>
                                                                                                                                        <option value="3" <%if (salesType == 3) {%>selected<%}%>>Retur Credit</option>
                                                                                                                                    </select>
                                                                                                                                </td>                                                                            
                                                                                                                            </tr>
                                                                                                                            <tr>
                                                                                                                                <td colspan="3">
                                                                                                                                    <table width="80%" border="0" cellpadding="0" cellspacing="0">
                                                                                                                                        <tr>
                                                                                                                                            <td height="3" background="<%=approot%>/images/line1.gif" ></td>
                                                                                                                                        </tr>
                                                                                                                                    </table>
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                            <tr> 
                                                                                                                                <td colspan="3"><a href="javascript:cmdSearch()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new2','','../images/search2.gif',1)"><img src="../images/search.gif" name="new2" border="0"></a></td>
                                                                                                                            </tr>   
                                                                                                                        </table>
                                                                                                                    </td>
                                                                                                                </tr>                                                            
                                                                                                                <%
            if (iJSPCommand == JSPCommand.SUBMIT) {
                try {

                    Location loca = new Location();
                    Shift shif = new Shift();

                    for (int a = 0; a < jumLocation; a++) {
                        if (jumLocation > 1) {
                            loca = (Location) vloc.get(a);
                        } else {
                            try {
                                loca = DbLocation.fetchExc(locationId);
                            } catch (Exception ex) {
                            }
                        }

                        double totalQtyx = 0;
                        double totalVatx = 0;
                        double grandTotalx = 0;
                        double grandDiscountAmountx = 0;
                        double grandTotalKwitansix = 0;
                        double grandTotalHppx = 0;
                        double granTotalLabax = 0;                        
                        double grandTotalDiscountPercenx = 0;

                                                                                                                %>
                                                                                                                <tr>
                                                                                                                    <td height="20">&nbsp;</td>  
                                                                                                                </tr>  
                                                                                                                <tr align="left" valign="top"> 
                                                                                                                    <td height="22" valign="middle" colspan="4"> 
                                                                                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                                                            <tr>
                                                                                                                                <td class="boxed1">
                                                                                                                                    <table width="1500" border="0" cellspacing="1" cellpadding="1">
                                                                                                                                        <%

                                                                                                                            for (int c = 0; c < jumShift; c++) {

                                                                                                                                if (shiftId == 0) {
                                                                                                                                    shif = (Shift) vShift.get(c);
                                                                                                                                } else {
                                                                                                                                    try {
                                                                                                                                        shif = DbShift.fetchExc(shiftId);
                                                                                                                                    } catch (Exception e) {
                                                                                                                                    }
                                                                                                                                }

                                                                                                                                listSales = null;
                                                                                                                                whereClause = "";
                                                                                                                                locationId = loca.getOID();

                                                                                                                                if (chkInvDate == 0) {
                                                                                                                                    if (whereClause != "") {
                                                                                                                                        whereClause = whereClause + " and ";
                                                                                                                                    }
                                                                                                                                    whereClause = whereClause + "date >= '" + JSPFormater.formatDate(invStartDate, "yyyy-MM-dd 00:00:00") + "' and  date <='" + JSPFormater.formatDate(invEndDate, "yyyy-MM-dd 23:59:59") + "'";
                                                                                                                                }

                                                                                                                                if (locationId != 0) {
                                                                                                                                    if (whereClause != "") {
                                                                                                                                        whereClause = whereClause + " and ";
                                                                                                                                    }
                                                                                                                                    whereClause = whereClause + " location_id=" + locationId;
                                                                                                                                }

                                                                                                                                if (shiftId != 0) {
                                                                                                                                    if (whereClause != "") {
                                                                                                                                        whereClause = whereClause + " and ";
                                                                                                                                    }
                                                                                                                                    whereClause = whereClause + " shift_id=" + shiftId;
                                                                                                                                } else {
                                                                                                                                    if (whereClause != "") {
                                                                                                                                        whereClause = whereClause + " and ";
                                                                                                                                    }
                                                                                                                                    whereClause = whereClause + " shift_id=" + shif.getOID();
                                                                                                                                }

                                                                                                                                if (salesType != -1) {
                                                                                                                                    if (whereClause != "") {
                                                                                                                                        whereClause = whereClause + " and ";
                                                                                                                                    }
                                                                                                                                    whereClause = whereClause + " type=" + salesType;
                                                                                                                                }


                                                                                                                                if (whereClause != "") {
                                                                                                                                    whereClause = whereClause + " and ";
                                                                                                                                }
                                                                                                                                whereClause = whereClause + " sales_type=" + DbSales.TYPE_NON_CONSIGMENT;

                                                                                                                                listSales = DbSales.list(0, 0, whereClause, "date, number");

                                                                                                                                if (listSales != null && listSales.size() > 0) {

                                                                                                                                        %>
                                                                                                                                        <tr>
                                                                                                                                            <td colspan="5" ><font face="arial"><i><b>Location : <%=loca.getName().toLowerCase() %></b></i></font></td>                                                                                        
                                                                                                                                        </tr> 
                                                                                                                                        <tr>
                                                                                                                                            <td colspan="5" ><font face="arial"><i><b>Shift : <%=shif.getName().toLowerCase() %></b></i></font></td>                                                                                        
                                                                                                                                        </tr> 
                                                                                                                                        <tr>
                                                                                                                                            <td colspan="5" height="2"></td>                                                                                        
                                                                                                                                        </tr> 
                                                                                                                                        <tr> 
                                                                                                                                            <td class="tablearialhdr" rowspan="2" width="20">No</td>
                                                                                                                                            <td class="tablearialhdr" rowspan="2" width="60">Date</td>
                                                                                                                                            <td class="tablearialhdr" rowspan="2" width="80">Number</td>
                                                                                                                                            <td class="tablearialhdr" rowspan="2" width="100">Cashier</td>
                                                                                                                                            <td class="tablearialhdr" rowspan="2" >Description</td>
                                                                                                                                            <td class="tablearialhdr" rowspan="2" width="120">Group</td>
                                                                                                                                            <td class="tablearialhdr" rowspan="2" width="100">Customer</td>
                                                                                                                                            <td class="tablearialhdr" rowspan="2" width="50">Qty</td>
                                                                                                                                            <td class="tablearialhdr" rowspan="2" width="50">Price</td>
                                                                                                                                            <td class="tablearialhdr" rowspan="2" width="80">Amount</td>
                                                                                                                                            <td class="tablearialhdr" colspan="2" >Discount</td>                                                                                        
                                                                                                                                            <td class="tablearialhdr" rowspan="2" width="50">PPN</td>
                                                                                                                                            <td class="tablearialhdr" rowspan="2" width="80">Kwitansi</td>
                                                                                                                                            <td class="tablearialhdr" rowspan="2" width="80">HPP</td>
                                                                                                                                            <td class="tablearialhdr" rowspan="2" width="80">Profit</td>                                                                                                                                                        
                                                                                                                                        </tr>
                                                                                                                                        <tr>
                                                                                                                                            <td class="tablearialhdr" width="30">( % )</td>
                                                                                                                                            <td class="tablearialhdr" width="50">Amount</td>                                                                                                                                                        
                                                                                                                                        </tr>    
                                                                                                                                        <%
                                double totalQty = 0;
                                double totalAmount = 0;
                                double totalDiscountPercent = 0;

                                double totalVat = 0;
                                double grandTotal = 0;
                                double grandDiscountAmount = 0;
                                double grandTotalKwitansi = 0;
                                double grandTotalHpp = 0;
                                double granTotalLaba = 0;
                                double totallaba = 0;
                                double grandTotalDiscountPercen = 0;
                                double totalhpp = 0;
                                double totalKwitansi = 0;
                                double totalDiscount_invoice = 0;

                                if (listSales != null && listSales.size() > 0) {
                                    for (int i = 0; i < listSales.size(); i++) {

                                        Sales sales = (Sales) listSales.get(i);

                                        Vector temp = DbSalesDetail.list(0, 0, "sales_id=" + sales.getOID(), "");
                                        Customer cus = new Customer();
                                        try {
                                            cus = DbCustomer.fetchExc(sales.getCustomerId());
                                        } catch (Exception e) {
                                        }

                                        User usr = new User();
                                        try {
                                            usr = DbUser.fetch(sales.getUserId());
                                        } catch (Exception e) {
                                        }

                                        totalDiscount_invoice = 0;
                                        totalDiscountPercent = 0;
                                        totalhpp = 0;
                                        totallaba = 0;
                                        totalKwitansi = 0;

                                        if (temp != null && temp.size() > 0) {

                                            double dAmount = 0;
                                            double dQty = 0;
                                            double dDiscount = 0;
                                            double dDiscountAmount = 0;
                                            double dPpn = 0;

                                            for (int xx = 0; xx < temp.size(); xx++) {

                                                SalesDetail sd = (SalesDetail) temp.get(xx);

                                                ItemMaster im = new ItemMaster();
                                                try {
                                                    im = DbItemMaster.fetchExc(sd.getProductMasterId());
                                                } catch (Exception e) {
                                                }

                                                ItemGroup ig = new ItemGroup();
                                                try {
                                                    ig = DbItemGroup.fetchExc(im.getItemGroupId());
                                                } catch (Exception e) {
                                                }

                                                totalAmount = totalAmount + sd.getTotal();
                                                if (sales.getType() == DbSales.TYPE_RETUR_CASH || sales.getType() == DbSales.TYPE_RETUR_CREDIT) {
                                                    totalhpp = totalhpp - (sd.getCogs() * sd.getQty());
                                                    totallaba = totallaba - (((sd.getQty() * sd.getSellingPrice() - sd.getDiscountAmount())) - (sd.getCogs() * sd.getQty()));
                                                    totalQty = totalQty - sd.getQty();
                                                } else {
                                                    totalhpp = totalhpp + (sd.getCogs() * sd.getQty());
                                                    totallaba = totallaba + (((sd.getQty() * sd.getSellingPrice() - sd.getDiscountAmount())) - (sd.getCogs() * sd.getQty()));
                                                    totalQty = totalQty + sd.getQty();
                                                }

                                                if (sd.getDiscountPercent() == 0 && sd.getDiscountAmount() != 0) {
                                                    sd.setDiscountPercent(((sd.getDiscountAmount() / (sd.getTotal() + sd.getDiscountAmount())) * 100));
                                                }

                                                totalVat = totalVat + sales.getVatAmount();
                                                totalDiscountPercent = totalDiscountPercent + sd.getDiscountPercent();
                                                totalDiscount_invoice = totalDiscount_invoice + sd.getDiscountAmount();

                                                //untk total semua invoice
                                                if (sales.getType() == DbSales.TYPE_RETUR_CASH || sales.getType() == DbSales.TYPE_RETUR_CREDIT) {
                                                    grandTotal = grandTotal - (sd.getQty() * sd.getSellingPrice());
                                                } else {
                                                    grandTotal = grandTotal + (sd.getQty() * sd.getSellingPrice());
                                                }
                                                if (sales.getType() == DbSales.TYPE_RETUR_CASH || sales.getType() == DbSales.TYPE_RETUR_CREDIT) {
                                                    totalKwitansi = totalKwitansi - (sd.getQty() * sd.getSellingPrice() - sd.getDiscountAmount()) + sales.getVatAmount();
                                                } else {
                                                    totalKwitansi = totalKwitansi + (sd.getQty() * sd.getSellingPrice() - sd.getDiscountAmount()) + sales.getVatAmount();
                                                }

                                                                                                                                        %>
                                                                                                                                        <tr height="22"> 
                                                                                                                                            <td class="tablearialcell"> 
                                                                                                                                                <div align="center"><%=(xx == 0) ? "" + (i + 1) : ""%></div>
                                                                                                                                            </td>
                                                                                                                                            <td class="tablearialcell" align="center"><%=(xx == 0) ? JSPFormater.formatDate(sales.getDate(), "dd/MM/yyyy") : ""%></td>
                                                                                                                                            <td class="tablearialcell" align="center"><%=(xx == 0) ? sales.getNumber() : ""%></td>
                                                                                                                                            <td class="tablearialcell" ><%=(xx == 0) ? usr.getFullName() : ""%></td>
                                                                                                                                            <td class="tablearialcell" ><%=im.getName()%></td>
                                                                                                                                            <td class="tablearialcell" ><%=ig.getName()%></td>
                                                                                                                                            <td class="tablearialcell" ><%=(xx == 0 && cus.getOID() != 0) ? cus.getName() : ""%></td>
                                                                                                                                            <td class="tablearialcell" > 
                                                                                                                                                <%if (sales.getType() == DbSales.TYPE_RETUR_CASH || sales.getType() == DbSales.TYPE_RETUR_CREDIT) {
                                                                                                                                                            dQty = dQty + (sd.getQty() * -1);
                                                                                                                                                %>
                                                                                                                                                <div align="right"><%=JSPFormater.formatNumber(sd.getQty() * -1, "###,###.##") %></div>
                                                                                                                                                <%} else {
    dQty = dQty + (sd.getQty());
                                                                                                                                                %>
                                                                                                                                                <div align="right"><%=JSPFormater.formatNumber(sd.getQty(), "###,###.##")%></div>
                                                                                                                                                <%}%>
                                                                                                                                            </td>
                                                                                                                                            <td class="tablearialcell" > 
                                                                                                                                                <div align="right"> 
                                                                                                                                                    <%=JSPFormater.formatNumber(sd.getSellingPrice(), "#,###")%> 
                                                                                                                                                </div>
                                                                                                                                            </td>
                                                                                                                                            <td class="tablearialcell" align="right">                                                                                              
                                                                                                                                                <%if (sales.getType() == DbSales.TYPE_RETUR_CASH || sales.getType() == DbSales.TYPE_RETUR_CREDIT) {%>
                                                                                                                                                <%=JSPFormater.formatNumber((sd.getTotal() + sd.getDiscountAmount()) * -1, "#,###")%> 
                                                                                                                                                <%dAmount = dAmount + ((sd.getTotal() + sd.getDiscountAmount()) * -1);%>
                                                                                                                                                <%} else {%>
                                                                                                                                                <%=JSPFormater.formatNumber((sd.getTotal() + sd.getDiscountAmount()), "#,###")%> 
                                                                                                                                                <%dAmount = dAmount + (sd.getTotal() + sd.getDiscountAmount());%>
                                                                                                                                                <%}%>                                                                                            
                                                                                                                                            </td>
                                                                                                                                            <td class="tablearialcell" > 
                                                                                                                                                <div align="right">
                                                                                                                                                    <%=JSPFormater.formatNumber(sd.getDiscountPercent(), "#,###.##")%>
                                                                                                                                                    <%dDiscount = dDiscount + sd.getDiscountPercent();%>
                                                                                                                                                </div>
                                                                                                                                            </td>
                                                                                                                                            <td class="tablearialcell" > 
                                                                                                                                                <div align="right">                                                                                                 
                                                                                                                                                    <%=JSPFormater.formatNumber(sd.getDiscountAmount(), "#,###.##")%> 
                                                                                                                                                    <%dDiscountAmount = dDiscountAmount + sd.getDiscountAmount();%>
                                                                                                                                                </div>
                                                                                                                                            </td>
                                                                                                                                            <td class="tablearialcell" > 
                                                                                                                                                <div align="right"> 
                                                                                                                                                    
                                                                                                                                                    <%=JSPFormater.formatNumber(sales.getVatAmount(), "#,###.##")%> 
                                                                                                                                                    <%dPpn = dPpn + sales.getVatAmount();%>
                                                                                                                                                </div>
                                                                                                                                            </td>
                                                                                                                                            <td class="tablearialcell" > 
                                                                                                                                                <div align="right">
                                                                                                                                                    
                                                                                                                                                    <%if (sales.getType() == DbSales.TYPE_RETUR_CASH || sales.getType() == DbSales.TYPE_RETUR_CREDIT) {%>
                                                                                                                                                    <%=JSPFormater.formatNumber((((sd.getQty() * sd.getSellingPrice()) + sales.getVatAmount()) - sd.getDiscountAmount()) * -1, "#,###.##")%>                                                                                                 
                                                                                                                                                    <%} else {%>
                                                                                                                                                    <%=JSPFormater.formatNumber((((sd.getQty() * sd.getSellingPrice()) + sales.getVatAmount()) - sd.getDiscountAmount()), "#,###.##")%>                                                                                                 
                                                                                                                                                    <%}%>
                                                                                                                                                </div>
                                                                                                                                            </td>
                                                                                                                                            <td class="tablearialcell" > 
                                                                                                                                                <div align="right">                                                                                             
                                                                                                                                                    <%if (sales.getType() == DbSales.TYPE_RETUR_CASH || sales.getType() == DbSales.TYPE_RETUR_CREDIT) {%>
                                                                                                                                                    <%=JSPFormater.formatNumber((sd.getCogs() * sd.getQty()) * -1, "#,###.##")%> 
                                                                                                                                                    <%} else {%>    
                                                                                                                                                    <%=JSPFormater.formatNumber(sd.getCogs() * sd.getQty(), "#,###.##")%> 
                                                                                                                                                    <%}%>
                                                                                                                                                </div>
                                                                                                                                            </td>
                                                                                                                                            <td class="tablearialcell" > 
                                                                                                                                                <div align="right">                                                                                             
                                                                                                                                                    <%if (sales.getType() == DbSales.TYPE_RETUR_CASH || sales.getType() == DbSales.TYPE_RETUR_CREDIT) {%>
                                                                                                                                                    <%=JSPFormater.formatNumber((((((sd.getQty() * sd.getSellingPrice()) + sales.getVatAmount()) - sd.getDiscountAmount())) - (sd.getCogs() * sd.getQty())) * -1, "#,###.##")%> 
                                                                                                                                                    <%} else {%>
                                                                                                                                                    <%=JSPFormater.formatNumber(((((sd.getQty() * sd.getSellingPrice()) + sales.getVatAmount()) - sd.getDiscountAmount())) - (sd.getCogs() * sd.getQty()), "#,###.##")%> 
                                                                                                                                                    <%}%>
                                                                                                                                                </div>
                                                                                                                                            </td>                                                                                                                                                        
                                                                                                                                        </tr>
                                                                                                                                        <%}%>                                                                                    
                                                                                                                                        <%if (temp.size() > 1) {%>
                                                                                                                                        <tr height="22">
                                                                                                                                            <td height="2" colspan="7" class="tablearialcell1">&nbsp;</td>
                                                                                                                                            <td height="2" class="tablearialcell1">
                                                                                                                                                <div align="right"><b><%=JSPFormater.formatNumber(dQty, "#,###.##")%></b></div>
                                                                                                                                            </td>
                                                                                                                                            <td height="2" class="tablearialcell1">&nbsp;</td>
                                                                                                                                            <td height="2" class="tablearialcell1"> 
                                                                                                                                                <div align="right"><b><%=JSPFormater.formatNumber(dAmount, "#,###.##")%></b></div>
                                                                                                                                            </td>
                                                                                                                                            <td height="2" class="tablearialcell1"> 
                                                                                                                                                <div align="right"><b><%=JSPFormater.formatNumber(dDiscount, "#,###.##")%></b></div>
                                                                                                                                            </td>
                                                                                                                                            <td height="2" class="tablearialcell1"> 
                                                                                                                                                <div align="right"><b><%=JSPFormater.formatNumber(dDiscountAmount, "#,###.##")%></b></div>
                                                                                                                                            </td>
                                                                                                                                            <td height="2" class="tablearialcell1"> 
                                                                                                                                                <div align="right"><b><%=JSPFormater.formatNumber(sales.getVatAmount(), "#,###.##")%></b></div>
                                                                                                                                            </td>
                                                                                                                                            <td height="2" class="tablearialcell1"> 
                                                                                                                                                <div align="right"><b><%=JSPFormater.formatNumber(totalKwitansi, "#,###.##")%></b></div>
                                                                                                                                            </td>
                                                                                                                                            <td height="2" class="tablearialcell1">
                                                                                                                                                <div align="right"><b><%=JSPFormater.formatNumber(totalhpp, "#,###.##")%></b></div>                                                                      
                                                                                                                                            </td>
                                                                                                                                            <td height="2" class="tablearialcell1">
                                                                                                                                                <div align="right"><b><%=JSPFormater.formatNumber(totallaba, "#,###.##")%></b></div>
                                                                                                                                            </td>                                                                                                                                                        
                                                                                                                                        </tr>
                                                                                                                                        <%}%>                                                                                    
                                                                                                                                        <%}

                                        grandDiscountAmount = grandDiscountAmount + totalDiscount_invoice + sales.getDiscountAmount();
                                        grandTotalDiscountPercen = grandTotalDiscountPercen + totalDiscountPercent + sales.getDiscountPercent();
                                        grandTotalKwitansi = grandTotalKwitansi + totalKwitansi;
                                        grandTotalHpp = grandTotalHpp + totalhpp;
                                        granTotalLaba = granTotalLaba + totallaba;
                                    }
                                }

                                totalQtyx = totalQtyx + totalQty;
                                grandTotalx = grandTotalx + grandTotal;
                                grandTotalDiscountPercenx = grandTotalDiscountPercenx + grandTotalDiscountPercen;
                                grandDiscountAmountx = grandDiscountAmountx + grandDiscountAmount;
                                totalVatx = totalVatx + totalVat;
                                grandTotalKwitansix = grandTotalKwitansix + grandTotalKwitansi;
                                grandTotalHppx = grandTotalHppx + grandTotalHpp;
                                granTotalLabax = granTotalLabax + granTotalLaba;
                                                                                                                                        %>
                                                                                                                                        
                                                                                                                                        <tr height="25">  
                                                                                                                                            <td height="19" colspan="5"></td>  
                                                                                                                                            <td height="19" bgcolor="#3366CC" colspan="2"> 
                                                                                                                                                <div align="center"><font face="arial" color="#FFFFFF" ><b>T O T A L</b></font></div>
                                                                                                                                            </td>                                                                                        
                                                                                                                                            <td height="19" bgcolor="#3366CC"> 
                                                                                                                                                <div align="right"><b><font face="arial" color="#FFFFFF"><%=JSPFormater.formatNumber(totalQty, "#,###.##")%></font></b></div>
                                                                                                                                            </td>
                                                                                                                                            <td height="19" bgcolor="#3366CC"><font size="1"></font></td>
                                                                                                                                            <td height="19" bgcolor="#3366CC"> 
                                                                                                                                                <div align="right"><b><font face="arial" color="#FFFFFF"><%=JSPFormater.formatNumber(grandTotal, "#,###.##")%></font></b></div>
                                                                                                                                            </td>
                                                                                                                                            <td height="19" bgcolor="#3366CC"> 
                                                                                                                                                <div align="right"><b><font face="arial" color="#FFFFFF"><%=JSPFormater.formatNumber(grandTotalDiscountPercen, "#,###.##")%></font></b></div>
                                                                                                                                            </td>
                                                                                                                                            <td height="19" bgcolor="#3366CC"> 
                                                                                                                                                <div align="right"><b><font face="arial" color="#FFFFFF"><%=JSPFormater.formatNumber(grandDiscountAmount, "#,###.##")%></font></b></div>
                                                                                                                                            </td>
                                                                                                                                            <td height="19" bgcolor="#3366CC"> 
                                                                                                                                                <div align="right"><b><font face="arial" color="#FFFFFF"><%=JSPFormater.formatNumber(totalVat, "#,###.##")%></font></b></div>
                                                                                                                                            </td>
                                                                                                                                            <td height="19" bgcolor="#3366CC"> 
                                                                                                                                                <div align="right"><b><font face="arial" color="#FFFFFF"><%=JSPFormater.formatNumber(grandTotalKwitansi, "#,###.##")%></font></b></div>
                                                                                                                                            </td>
                                                                                                                                            <td height="19" bgcolor="#3366CC"> 
                                                                                                                                                <div align="right"><b><font face="arial" color="#FFFFFF"><%=JSPFormater.formatNumber(grandTotalHpp, "#,###.##")%></font></b></div>
                                                                                                                                            </td>
                                                                                                                                            <td height="19" bgcolor="#3366CC"> 
                                                                                                                                                <div align="right"><b><font face="arial" color="#FFFFFF"><%=JSPFormater.formatNumber(granTotalLaba, "#,###.##")%></font></b></div>
                                                                                                                                            </td>                                                                                                                                                        
                                                                                                                                        </tr>
                                                                                                                                        <tr> 
                                                                                                                                            <td coslpan="18">&nbsp;</td>                                                                                       
                                                                                                                                        </tr>
                                                                                                                                        <%
                                                                                                                                }
                                                                                                                            }%>
                                                                                                                                        <tr height="25">  
                                                                                                                                            <td height="19" colspan="5"></td>  
                                                                                                                                            <td height="19" bgcolor="#3366CC" colspan="2"> 
                                                                                                                                                <div align="center"><font face="arial" color="#FFFFFF" ><b>G R A N D &nbsp;  T O T A L</b></font></div>
                                                                                                                                            </td>                                                                                        
                                                                                                                                            <td height="19" bgcolor="#3366CC" > 
                                                                                                                                                <div align="right"><b><font face="arial" color="#FFFFFF"><%=JSPFormater.formatNumber(totalQtyx, "#,###.##")%></font></b></div>
                                                                                                                                            </td>
                                                                                                                                            <td height="19" bgcolor="#3366CC" ><font size="1"></font></td>
                                                                                                                                            <td height="19" bgcolor="#3366CC" > 
                                                                                                                                                <div align="right"><b><font face="arial" color="#FFFFFF"><%=JSPFormater.formatNumber(grandTotalx, "#,###.##")%></font></b></div>
                                                                                                                                            </td>
                                                                                                                                            <td height="19" bgcolor="#3366CC" > 
                                                                                                                                                <div align="right"><b><font face="arial" color="#FFFFFF"><%=JSPFormater.formatNumber(grandTotalDiscountPercenx, "#,###.##")%></font></b></div>
                                                                                                                                            </td>
                                                                                                                                            <td height="19" bgcolor="#3366CC" > 
                                                                                                                                                <div align="right"><b><font face="arial" color="#FFFFFF"><%=JSPFormater.formatNumber(grandDiscountAmountx, "#,###.##")%></font></b></div>
                                                                                                                                            </td>
                                                                                                                                            <td height="19" bgcolor="#3366CC" > 
                                                                                                                                                <div align="right"><b><font face="arial" color="#FFFFFF"><%=JSPFormater.formatNumber(totalVatx, "#,###.##")%></font></b></div>
                                                                                                                                            </td>
                                                                                                                                            <td height="19" bgcolor="#3366CC" > 
                                                                                                                                                <div align="right"><b><font face="arial" color="#FFFFFF"><%=JSPFormater.formatNumber(grandTotalKwitansix, "#,###.##")%></font></b></div>
                                                                                                                                            </td>
                                                                                                                                            <td height="19" bgcolor="#3366CC" > 
                                                                                                                                                <div align="right"><b><font face="arial" color="#FFFFFF"><%=JSPFormater.formatNumber(grandTotalHppx, "#,###.##")%></font></b></div>
                                                                                                                                            </td>
                                                                                                                                            <td height="19" bgcolor="#3366CC" > 
                                                                                                                                                <div align="right"><b><font face="arial" color="#FFFFFF"><%=JSPFormater.formatNumber(granTotalLabax, "#,###.##")%></font></b></div>
                                                                                                                                            </td>                                                                                                                                                        
                                                                                                                                        </tr>
                                                                                                                                    </table>
                                                                                                                                </td>
                                                                                                                            </tr>                                                                        
                                                                                                                        </table>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                                
                                                                                                                <tr>   
                                                                                                                    <td>
                                                                                                                        <table width="1500" border="0" cellspacing="1" cellpadding="1">
                                                                                                                            
                                                                                                                        </table>    
                                                                                                                        
                                                                                                                        
                                                                                                                    </td>
                                                                                                                </tr>   
                                                                                                                <%}
                } catch (Exception exc) {
                }
            }
                                                                                                                %>                                                                                                                            
                                                                                                            </table>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </form>                                                                                                    
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
                                            </table>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr> 
                            <td height="25"> <!-- #BeginEditable "footer" --> 
            <%@ include file="../main/footersl.jsp"%>
                            <!-- #EndEditable --> </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </body>
    <!-- #EndTemplate --> 
</html>

