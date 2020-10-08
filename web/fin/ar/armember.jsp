
<%-- 
    Document   : armember
    Created on : Dec 11, 2013, 9:30:34 PM
    Author     : Roy Andika
--%>

<%@ page language="java"%>
<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.system.*" %>
<%@ page import = "com.project.crm.project.*" %>
<%@ page import = "com.project.crm.*" %>
<%@ page import = "com.project.fms.master.*" %>
<%@ page import = "com.project.fms.ar.*" %>
<%@ page import = "com.project.fms.session.*" %>
<%@ page import = "com.project.general.*" %>
<%@ page import = "com.project.main.db.*" %>
<%@ page import = "java.util.Date" %>
<%@ include file="../main/javainit.jsp"%>
<%@ include file="../main/check.jsp"%>
<%@ include file="../calendar/calendarframe.jsp"%>
<%@ page import = "com.project.I_Project" %>
<%
            boolean priv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MENU_AP, AppMenu.M2_MENU_AA);
            boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_AP, AppMenu.M2_MENU_AA, AppMenu.PRIV_VIEW);
            boolean privUpdate = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_AP, AppMenu.M2_MENU_AA, AppMenu.PRIV_UPDATE);
            boolean privAdd = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_AP, AppMenu.M2_MENU_AA, AppMenu.PRIV_ADD);
            boolean privDelete = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_AP, AppMenu.M2_MENU_AA, AppMenu.PRIV_DELETE);
%>
<%
            if (session.getValue("MEMBER_REPORT") != null) {
                session.removeValue("MEMBER_REPORT");
            }
            
            if (session.getValue("MEMBER_REPORT_FORMAT") != null) {
                session.removeValue("MEMBER_REPORT_FORMAT");
            }

            int iJSPCommand = JSPRequestValue.requestCommand(request);
            long oidCustomer = JSPRequestValue.requestLong(request, "customer_id");
            int status = JSPRequestValue.requestInt(request, "status");
            String srcStart = JSPRequestValue.requestString(request, "src_start_date");
            String srcEnd = JSPRequestValue.requestString(request, "src_end_date");
            int srcIgnore = JSPRequestValue.requestInt(request, "src_ignore");
            Date srcStartDate = new Date();
            Date srcEndDate = new Date();
            
            if(iJSPCommand == JSPCommand.NONE){
                srcIgnore = 1;
            }

            if (srcIgnore == 0) {
                srcStartDate = JSPFormater.formatDate(srcStart, "dd/MM/yyyy");
                srcEndDate = JSPFormater.formatDate(srcEnd, "dd/MM/yyyy");
            }

            String cstName = JSPRequestValue.requestString(request, "cst_name");
            Vector vArInvoice = new Vector();

            /*** LANG ***/
            String[] langAR = {"Customer", "Status", "Code", "Payment", "Current", //0-4
                "Searching Form :", "Click serach button to searching the data", "To", "Ignore", "Name", "Invoice Number", "Date", "Due Date", "Credit Total"}; //5-13

            String[] langNav = {"Account Receiveable", "Customer Receiveable Report", "Data not found"};

            if (lang == LANG_ID) {
                String[] langID = {"Konsumen", "Status", "Kode", "Pembayaran", "Terkini", //0-4
                    "Form Pencarian :", "Klik tombol search untuk melakukan pencarian", "Sampai", "Abaikan", "Nama", "Nomor Invoice", "Tanggal", "Jatuh Tempo", "Total Kredit"}; //5-13
                langAR = langID;

                String[] navID = {"Piutang", "Laporan Piutang Konsumen", "Data tidak ditemukan"};
                langNav = navID;
            }
%>
<html >
    <!-- #BeginTemplate "/Templates/index.dwt" --> 
    <head>
        <!-- #BeginEditable "javascript" --> 
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <title><%=systemTitle%></title>
        <link href="../css/css.css" rel="stylesheet" type="text/css" />
        <script type="text/javascript">
            <%if (!priv || !privView) {%>
            window.location="<%=approot%>/nopriv.jsp";
            <%}%>
            
            function cmdSearchCustomer(){
                var cstName = document.frmaging.cst_name.value;  
                window.open("srckonsumen.jsp?cst_name=\'"+cstName+"'&command=<%=JSPCommand.SEARCH%>&frm_cst_id=customer_id&form_name=frmaging", null, "height=400,width=700, status=yes,toolbar=no,menubar=no,location=no, scrollbars=yes");
                }  
                
                function cmdPrintJournalXls(){	                       
                    window.open("<%=printroot%>.report.RptReceivableMemberXLS?user_id=<%=appSessUser.getUserOID()%>&lang=<%=lang%>&comp_id=<%=sysCompany.getOID()%>" ,'scrollbars=yes,status=yes,width=750,height=600,resizable=yes');
                    }
                
                function cmdSearch(){
                    document.frmaging.command.value="<%=JSPCommand.SUBMIT%>";
                    document.frmaging.action="armember.jsp";
                    document.frmaging.submit();
                }
                
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
    <body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','../images/search2.gif')">
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
                    <%@ include file="../calendar/calendarframe.jsp"%>
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
                                                                                                        <form id="form1" name="frmaging" method="post" action="">
                                                                                                            <input type="hidden" name="command">
                                                                                                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">                                                                                                               
                                                                                                                <tr> 
                                                                                                                    <td class="container"> 
                                                                                                                        <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                                                                            <tr> 
                                                                                                                                <td> 
                                                                                                                                    <table border="0" cellpadding="1" cellspacing="1" width="700">                                                                                                                                        
                                                                                                                                        <tr>                                                                                                                                            
                                                                                                                                            <td class="tablecell1" > 
                                                                                                                                                <table width="100%" border="0" style="border:1px solid #ABA8A8" cellspacing="2" cellpadding="1"> 
                                                                                                                                                    <tr> 
                                                                                                                                                        <td ></td>
                                                                                                                                                        <td class="fontarial" colspan="4"><b><i><%=langAR[5]%></i></b></td>                                                                                                                                                        
                                                                                                                                                    </tr>
                                                                                                                                                    <tr> 
                                                                                                                                                        <td width="5"></td>
                                                                                                                                                        <td width="80" class="fontarial" ><%=langAR[0]%></td>
                                                                                                                                                        <td width="200"> 
                                                                                                                                                            <input type="hidden" name="customer_id" value="<%=oidCustomer%>">
                                                                                                                                                            <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                                                                <tr>
                                                                                                                                                                    <td>
                                                                                                                                                                        <input type="text" name="cst_name" size="20" value="<%=cstName%>">
                                                                                                                                                                    </td>
                                                                                                                                                                    <td>
                                                                                                                                                                        &nbsp;<a href="javascript:cmdSearchCustomer()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new21','','../images/search.jpg',1)"><img src="../images/search2.jpg" name="new211" height="17" border="0" style="padding:0px"></a> 
                                                                                                                                                                    </td>
                                                                                                                                                                </tr>
                                                                                                                                                            </table>                                                                 
                                                                                                                                                        </td>
                                                                                                                                                        <td class="fontarial" ><%=langAR[11]%></td>
                                                                                                                                                        <td >                                                                                              
                                                                                                                                                            <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                                                                <tr>
                                                                                                                                                                    <td><input name="src_start_date" value="<%=JSPFormater.formatDate((srcStartDate == null) ? new Date() : srcStartDate, "dd/MM/yyyy")%>" size="11" readonly></td>
                                                                                                                                                                    <td><a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmaging.src_start_date);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a></td>
                                                                                                                                                                    <td>&nbsp;&nbsp;<%=langAR[7]%>&nbsp;&nbsp;</td>
                                                                                                                                                                    <td><input name="src_end_date" value="<%=JSPFormater.formatDate((srcEndDate == null) ? new Date() : srcEndDate, "dd/MM/yyyy")%>" size="11" readonly></td>
                                                                                                                                                                    <td><a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmaging.src_end_date);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a></td>
                                                                                                                                                                    <td><input type="checkbox" name="src_ignore" value="1" <%if (srcIgnore == 1) {%>checked<%}%>></td>
                                                                                                                                                                    <td><%=langAR[8]%></td>
                                                                                                                                                                </tr>
                                                                                                                                                            </table>  
                                                                                                                                                        </td>
                                                                                                                                                    </tr>
                                                                                                                                                    <tr> 
                                                                                                                                                        <td ></td>
                                                                                                                                                        <td class="fontarial"><%=langAR[1]%></td>
                                                                                                                                                        <td colspan="3">
                                                                                                                                                            <select name="status">                                                                                                                                                                
                                                                                                                                                                <option value="-1" <%if (status == -1) {%>selected<%}%>>ALL STATUS</option>
                                                                                                                                                                <option value="2" <%if (status == 2) {%>selected<%}%>>FULLY PAID</option>                                                                                                                                                                
                                                                                                                                                                <option value="0" <%if (status == 0) {%>selected<%}%>>NOT FULLY PAID</option>
                                                                                                                                                            </select>
                                                                                                                                                        </td>
                                                                                                                                                    </tr>
                                                                                                                                                    <tr> 
                                                                                                                                                        <td colspan="5" height="5"></td>
                                                                                                                                                    </tr>    
                                                                                                                                                </table>
                                                                                                                                            </td>
                                                                                                                                        </tr>
                                                                                                                                    </table>
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                            <tr> 
                                                                                                                                <td class="boxed1">
                                                                                                                                    <a href="javascript:cmdSearch()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new2','','../images/search2.gif',1)"><img src="../images/search.gif" name="new2" border="0"></a> 
                                                                                                                                </td> 
                                                                                                                            </tr>  
                                                                                                                            <tr> 
                                                                                                                                <td class="boxed1" height="30">&nbsp;</td> 
                                                                                                                            </tr> 
                                                                                                                            <tr> 
                                                                                                                                <td class="boxed1"> 
                                                                                                                                    <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                                                                                        <tr height="28"> 
                                                                                                                                            <td class="tablehdr" width="4%">No</td>
                                                                                                                                            <td class="tablehdr" ><%=langAR[9]%></td>
                                                                                                                                            <td class="tablehdr" width="15%"><%=langAR[10]%></td>
                                                                                                                                            <td class="tablehdr" width="10%"><%=langAR[11]%></td>
                                                                                                                                            <td class="tablehdr" width="10%"><%=langAR[12]%></td>
                                                                                                                                            <td class="tablehdr" width="12%"><%=langAR[13]%></td>                                                                                                                                            
                                                                                                                                            <td class="tablehdr" width="12%"><%=langAR[3]%></td>   
                                                                                                                                            <td class="tablehdr" width="12%"><%=langAR[4]%></td>   
                                                                                                                                        </tr>
                                                                                                                                        <%
            if (iJSPCommand == JSPCommand.SUBMIT) {

                CONResultSet crs = null;

                String sql = "select c." + DbCustomer.colNames[DbCustomer.COL_NAME] + " as name" +
                        ",c." + DbCustomer.colNames[DbCustomer.COL_CUSTOMER_ID] + " as customer_id" +
                        ",ar." + DbARInvoice.colNames[DbARInvoice.COL_INVOICE_NUMBER] + " as inv_number" +
                        ",ar." + DbARInvoice.colNames[DbARInvoice.COL_DATE] + " as date " +
                        ",ar." + DbARInvoice.colNames[DbARInvoice.COL_DUE_DATE] + " as due_date " +
                        ",sum(ad." + DbARInvoiceDetail.colNames[DbARInvoiceDetail.COL_TOTAL_AMOUNT] + ") as total" +
                        ",sum(ap." + DbArPayment.colNames[DbArPayment.COL_AMOUNT] + ") as total_pay from " + DbARInvoice.DB_AR_INVOICE + " ar inner join " + DbCustomer.DB_CUSTOMER + " c on ar." + DbARInvoice.colNames[DbARInvoice.COL_CUSTOMER_ID] +
                        " = c." + DbCustomer.colNames[DbCustomer.COL_CUSTOMER_ID] + " inner join " + DbARInvoiceDetail.TBL_AR_INVOICE_DETAIL + " ad on ar." + DbARInvoice.colNames[DbARInvoice.COL_AR_INVOICE_ID] + " = ad." + DbARInvoiceDetail.colNames[DbARInvoiceDetail.COL_AR_INVOICE_ID] + " left join " + DbArPayment.DB_AR_PAYMENT + " ap on ar." + DbARInvoice.colNames[DbARInvoice.COL_AR_INVOICE_ID] + " = ap." + DbArPayment.colNames[DbArPayment.COL_AR_INVOICE_ID];

                String where = "";

                if (oidCustomer != 0) {
                    if (where.length() > 0) {
                        where = where + " and ";
                    }
                    where = where + " ar." + DbARInvoice.colNames[DbARInvoice.COL_CUSTOMER_ID] + " = " + oidCustomer;
                }

                if (status != -1) {
                    if (where.length() > 0) {
                        where = where + " and ";
                    }
                    if(status == 2){
                        where = where + " ar." + DbARInvoice.colNames[DbARInvoice.COL_STATUS] + " = " + status;
                    }else{
                        where = where + " ar." + DbARInvoice.colNames[DbARInvoice.COL_STATUS] + " != " + 2;
                    }
                }

                if (srcIgnore == 0) {
                    if (where.length() > 0) {
                        where = where + " and ";
                    }
                    where = where + " to_days(ar." + DbARInvoice.colNames[DbARInvoice.COL_DATE] + ") >= to_days('" + JSPFormater.formatDate(srcStartDate, "yyyy-MM-dd") + "') and to_days(ar." + DbARInvoice.colNames[DbARInvoice.COL_DATE] + ") <= to_days('" + JSPFormater.formatDate(srcEndDate, "yyyy-MM-dd") + "') ";
                }

                if (where.length() > 0) {
                    sql = sql + " where " + where;
                }

                sql = sql + " group by ar." + DbARInvoice.colNames[DbARInvoice.COL_AR_INVOICE_ID] + " order by c." + DbCustomer.colNames[DbCustomer.COL_NAME];
                
                crs = CONHandler.execQueryResult(sql);
                ResultSet rs = crs.getResultSet();


                int sequence = 1;
                long check = 0;
                double subTotal = 0;
                double subPaid = 0;
                double subTerkini = 0;

                double grandTotal = 0;
                double grandPaid = 0;
                double grandTerkini = 0;

                while (rs.next()) {
                    
                    long customerId = rs.getLong("customer_id");
                    String name = rs.getString("name");
                    String invoiceNumber = rs.getString("inv_number");
                    Date tanggal = rs.getDate("date");
                    Date dueDate = rs.getDate("due_date");
                    double total = rs.getDouble("total");
                    
                    double totalPaid = rs.getDouble("total_pay");
                    double balance = 0;
                    
                    ReportKonsumen reportKonsumen = new ReportKonsumen();
                    
                    reportKonsumen.setCustomerId(customerId);
                    reportKonsumen.setName(name);
                    reportKonsumen.setInvoiceNumber(invoiceNumber);
                    reportKonsumen.setTanggal(tanggal);
                    reportKonsumen.setDueDate(dueDate);
                    reportKonsumen.setTotCredit(total);
                    reportKonsumen.setTotalPaid(totalPaid);
                    vArInvoice.add(reportKonsumen);
                    String tableClass = "tablecell1";

                                                                                                                                        %>
                                                                                                                                        <%if (sequence != 1 && check != customerId) {%>                                                                                                                                        
                                                                                                                                        <tr height="22" >    
                                                                                                                                            <td align="center" colspan="5" class="tablecell">&nbsp;</td>                                                                                                                                            
                                                                                                                                            <td align="right" bgcolor="#CCCCCC" class="fontarial"><b><%=JSPFormater.formatNumber(subTotal, formNumbComp)%></b>&nbsp;</td>                                                                                                                                            
                                                                                                                                            <td align="right" bgcolor="#CCCCCC" class="fontarial"><b><%=JSPFormater.formatNumber(subPaid, formNumbComp)%></b>&nbsp;</td>   
                                                                                                                                            <td align="right" bgcolor="#CCCCCC" class="fontarial"><b><%=JSPFormater.formatNumber(subTerkini, formNumbComp)%></b>&nbsp;</td>   
                                                                                                                                        </tr>
                                                                                                                                        <tr> 
                                                                                                                                            <td colspan="8" height="3" background="<%=approot%>/images/line1.gif" ></td>
                                                                                                                                        </tr>
                                                                                                                                        <tr> 
                                                                                                                                            <td colspan="8" height="3" ></td>
                                                                                                                                        </tr>
                                                                                                                                        <%
                                                                                                                                                                                                                                                                    subTotal = 0;
                                                                                                                                                                                                                                                                    subPaid = 0;
                                                                                                                                                                                                                                                                    subTerkini = 0;
                                                                                                                                                                                                                                                                }

                                                                                                                                                                                                                                                                if (formNumbComp.equals("#,##0")) {
                                                                                                                                                                                                                                                                    subTotal = subTotal + Double.parseDouble("" + JSPFormater.formatNumber(Math.round(total), "###0"));
                                                                                                                                                                                                                                                                    grandTotal = grandTotal + Double.parseDouble("" + JSPFormater.formatNumber(Math.round(total), "###0"));
                                                                                                                                                                                                                                                                    subPaid = subPaid + Double.parseDouble("" + JSPFormater.formatNumber(Math.round(totalPaid), "###0"));
                                                                                                                                                                                                                                                                    grandPaid = grandPaid + Double.parseDouble("" + JSPFormater.formatNumber(Math.round(totalPaid), "###0"));
                                                                                                                                                                                                                                                                    balance = Double.parseDouble("" + JSPFormater.formatNumber(Math.round(total), "###0")) - Double.parseDouble("" + JSPFormater.formatNumber(Math.round(totalPaid), "###0"));
                                                                                                                                                                                                                                                                    grandTerkini = grandTerkini + balance;
                                                                                                                                                                                                                                                                    subTerkini = subTerkini + balance;
                                                                                                                                                                                                                                                                } else {
                                                                                                                                                                                                                                                                    subTotal = subTotal + total;
                                                                                                                                                                                                                                                                    grandTotal = grandTotal + total;
                                                                                                                                                                                                                                                                    subPaid = subPaid + totalPaid;
                                                                                                                                                                                                                                                                    grandPaid = grandPaid + totalPaid;
                                                                                                                                                                                                                                                                    balance = total - totalPaid;
                                                                                                                                                                                                                                                                    subTerkini = subTerkini + balance;
                                                                                                                                                                                                                                                                    grandTerkini = grandTerkini + balance;
                                                                                                                                                                                                                                                                }

                                                                                                                                        %>
                                                                                                                                        <tr height="22">    
                                                                                                                                            <%if (check != customerId) {%>
                                                                                                                                            <td class="<%=tableClass%>" align="center"><%=sequence%>.</td>
                                                                                                                                            <td class="<%=tableClass%>" ><%=name%></td>
                                                                                                                                            <%
    sequence++;
} else {%>
                                                                                                                                            <td class="<%=tableClass%>" align="center">&nbsp;</td>
                                                                                                                                            <td class="<%=tableClass%>" >&nbsp;</td>
                                                                                                                                            
                                                                                                                                            <%}%>
                                                                                                                                            <td class="<%=tableClass%>"><%=invoiceNumber%></td>
                                                                                                                                            <td class="<%=tableClass%>" align="center"><%=JSPFormater.formatDate(tanggal, "dd MMM yyy") %></td>
                                                                                                                                            <td class="<%=tableClass%>" align="center"><%=JSPFormater.formatDate(dueDate, "dd MMM yyy") %></td>
                                                                                                                                            <td class="<%=tableClass%>" align="right"><%=JSPFormater.formatNumber(Math.round(total), formNumbComp)%>&nbsp;</td>                                                                                                                                            
                                                                                                                                            <td class="<%=tableClass%>" align="right"><%=JSPFormater.formatNumber(Math.round(totalPaid), formNumbComp)%>&nbsp;</td>   
                                                                                                                                            <td class="<%=tableClass%>" align="right"><%=JSPFormater.formatNumber(balance, formNumbComp)%>&nbsp;</td>   
                                                                                                                                        </tr>                                                                                                                                        
                                                                                                                                        <%
                                                                                                                                                check = customerId;
                                                                                                                                            }%>
                                                                                                                                        <%
                                                                                                                                            if (sequence > 1) {
                                                                                                                                        %>
                                                                                                                                        <tr height="22" >    
                                                                                                                                            <td align="center" colspan="5" class="tablecell">&nbsp;</td>                                                                                                                                            
                                                                                                                                            <td align="right" bgcolor="#CCCCCC" class="fontarial"><b><%=JSPFormater.formatNumber(subTotal, formNumbComp)%></b>&nbsp;</td>                                                                                                                                            
                                                                                                                                            <td align="right" bgcolor="#CCCCCC" class="fontarial"><b><%=JSPFormater.formatNumber(subPaid, formNumbComp)%></b>&nbsp;</td>   
                                                                                                                                            <td align="right" bgcolor="#CCCCCC" class="fontarial"><b><%=JSPFormater.formatNumber(subTerkini, formNumbComp)%></b>&nbsp;</td>   
                                                                                                                                        </tr>
                                                                                                                                        <tr > 
                                                                                                                                            <td colspan="8" height="3" background="<%=approot%>/images/line1.gif" ></td>
                                                                                                                                        </tr>
                                                                                                                                        <tr height="22" >    
                                                                                                                                            <td align="center" colspan="5" bgcolor="#CCCCCC" class="fontarial"><b>GRAND TOTAL</b></td>                                                                                                                                            
                                                                                                                                            <td align="right" bgcolor="#CCCCCC" class="fontarial"><b><%=JSPFormater.formatNumber(grandTotal, formNumbComp)%></b>&nbsp;</td>                                                                                                                                            
                                                                                                                                            <td align="right" bgcolor="#CCCCCC" class="fontarial"><b><%=JSPFormater.formatNumber(grandPaid, formNumbComp)%></b>&nbsp;</td>   
                                                                                                                                            <td align="right" bgcolor="#CCCCCC" class="fontarial"><b><%=JSPFormater.formatNumber(grandTerkini, formNumbComp)%></b>&nbsp;</td>   
                                                                                                                                        </tr>
                                                                                                                                        <tr > 
                                                                                                                                            <td colspan="8" height="3" background="<%=approot%>/images/line1.gif" ></td>
                                                                                                                                        </tr>
                                                                                                                                        <% 
                                                                                                                                        session.putValue("MEMBER_REPORT", vArInvoice);
                                                                                                                                        session.putValue("MEMBER_REPORT_FORMAT", formNumbComp);
                                                                                                                                        
                                                                                                                                        %>
                                                                                                                                        <tr > 
                                                                                                                                            <td colspan="8" height="3" >&nbsp;</td>
                                                                                                                                        </tr>
                                                                                                                                        <tr > 
                                                                                                                                            <td colspan="8" height="3">
                                                                                                                                                <a href="javascript:cmdPrintJournalXls()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('print2','','../images/printxls2.gif',1)"><img src="../images/printxls.gif" name="print2" height="22" border="0"></a>
                                                                                                                                            </td>
                                                                                                                                        </tr>
                                                                                                                                        <%} else {%>
                                                                                                                                        <tr > 
                                                                                                                                            <td colspan="8" height="3" class="tablecell1" ><i><b>&nbsp;<%=langNav[2]%>...</b></i></td>
                                                                                                                                        </tr>
                                                                                                                                        <tr > 
                                                                                                                                            <td colspan="8" height="3" background="<%=approot%>/images/line1.gif" ></td>
                                                                                                                                        </tr>
                                                                                                                                        <%}%>
                                                                                                                                        <%} else {%>
                                                                                                                                        <tr > 
                                                                                                                                            <td colspan="8" height="3" class="tablecell1" ><i><b>&nbsp;<%=langAR[6]%>...</b></i></td>
                                                                                                                                        </tr>
                                                                                                                                        <tr > 
                                                                                                                                            <td colspan="8" height="3" background="<%=approot%>/images/line1.gif" ></td>
                                                                                                                                        </tr>
                                                                                                                                        <%}%>
                                                                                                                                    </table>
                                                                                                                                </td>
                                                                                                                            </tr>                                                                                                                                                                                                                                                    
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

