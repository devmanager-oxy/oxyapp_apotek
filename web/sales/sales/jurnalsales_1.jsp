
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.admin.*" %>
<%@ page import = "com.project.ccs.postransaction.sales.*" %>
<%@ page import = "com.project.ccs.sql.*" %>
<%@ page import = "com.project.ccs.posmaster.Shift" %>
<%@ page import = "com.project.fms.master.*" %>
<%@ include file = "../main/javainit.jsp" %>
<%@ include file = "../main/checksl.jsp" %>
<%@ include file="../calendar/calendarframe.jsp"%>
<%
            boolean privAdd = true;
            boolean privUpdate = true;
            boolean privDelete = true;
%>
<!-- Jsp Block -->
<%

            Date tanggal = JSPFormater.formatDate(JSPRequestValue.requestString(request, "invStartDate"), "dd/MM/yyyy");
            long locationId = JSPRequestValue.requestLong(request, "src_location_id");
            long cashCashierId = JSPRequestValue.requestLong(request, "shift_name");
            int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
            long periodId = JSPRequestValue.requestLong(request, "period");
            int iJSPCommand = JSPRequestValue.requestCommand(request);
            int start = JSPRequestValue.requestInt(request, "start");

            if (tanggal == null) {
                tanggal = new Date();
            }

            Vector vLoc = DbSales.getLocationJournal();

            Vector list = new Vector();
            Vector listG = new Vector();

            if (iJSPCommand == JSPCommand.SUBMIT || iJSPCommand == JSPCommand.POST) {
                //list = DbSales.getDataClosingJournal(tanggal, locationId, cashCashierId, 0);
                list = DbSales.getDataJournal(tanggal, locationId, cashCashierId, 0);
                //listG = DbSales.getDataClosingJournal(tanggal, locationId, cashCashierId, 1);
                listG = DbSales.getDataJournal(tanggal, locationId, cashCashierId, 1);
            }

            if (iJSPCommand == JSPCommand.POST && periodId != 0) {

                Vector result = new Vector();
                Vector resultR = new Vector();
                Hashtable hResult = new Hashtable();
                Hashtable hResultR = new Hashtable();

                if (list != null && list.size() > 0) {
                    for (int t = 0; t < list.size(); t++) {
                        SalesClosingJournal sc = (SalesClosingJournal) list.get(t);
                        int xxx = JSPRequestValue.requestInt(request, "sale_" + sc.getSalesId());
                        if (xxx == 1) {
                            Sales sales = new Sales();
                            try {
                                sales = DbSales.fetchExc(sc.getSalesId());
                            } catch (Exception e) {
                            }

                            if (sales.getOID() != 0) {
                                if (sales.getType() == DbSales.TYPE_RETUR_CASH || sales.getType() == DbSales.TYPE_RETUR_CREDIT) {
                                    if (hResultR.get("" + sales.getOID()) == null) {
                                        hResultR.put("" + sales.getOID(), "" + sales.getOID());
                                        resultR.add(sales);
                                    }
                                } else {
                                    if (hResult.get("" + sales.getOID()) == null) {
                                        hResult.put("" + sales.getOID(), "" + sales.getOID());
                                        result.add(sales);
                                    }
                                }
                            }
                        }
                    }
                }

                if (listG != null && listG.size() > 0) {
                    for (int t = 0; t < listG.size(); t++) {
                        SalesClosingJournal sc = (SalesClosingJournal) listG.get(t);
                        int xxx = JSPRequestValue.requestInt(request, "saleg_" + sc.getSalesId());
                        if (xxx == 1) {
                            Sales sales = new Sales();
                            try {
                                sales = DbSales.fetchExc(sc.getSalesId());
                            } catch (Exception e) {
                            }

                            if (sales.getOID() != 0) {
                                if (sales.getType() == DbSales.TYPE_RETUR_CASH || sales.getType() == DbSales.TYPE_RETUR_CREDIT) {
                                    if (hResultR.get("" + sales.getOID()) == null) {
                                        hResultR.put("" + sales.getOID(), "" + sales.getOID());
                                        resultR.add(sales);
                                    }
                                } else {
                                    if (hResult.get("" + sales.getOID()) == null) {
                                        hResult.put("" + sales.getOID(), "" + sales.getOID());
                                        result.add(sales);
                                    }
                                }
                            }
                        }
                    }
                }

                if (result != null && result.size() > 0) {
                    DbSales.postJournal(result, user.getOID(), periodId);
                }

                if (resultR != null && resultR.size() > 0) {
                    DbSales.postJourRetur(resultR, user.getOID(), periodId);                    
                }

                list = DbSales.getDataClosingJournal(tanggal, locationId, cashCashierId, 0);
                listG = DbSales.getDataClosingJournal(tanggal, locationId, cashCashierId, 1);
            }
%>
<html >
<!-- #BeginTemplate "/Templates/indexsl.dwt" --> 
<head>
    <!-- #BeginEditable "javascript" --> 
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title><%=salesSt%></title>
    <link href="../css/csssl.css" rel="stylesheet" type="text/css" />
    <script language="JavaScript">
        
        function cmdPostJournal(){
            document.all.closecmd.style.display="none";
            document.all.closemsg.style.display="";
            document.frmsales.command.value="<%=JSPCommand.POST%>";
            document.frmsales.action="jurnalsales.jsp?menu_idx=<%=menuIdx%>";
            document.frmsales.submit();
        }
        
        function cmdSearch(){
            document.frmsales.command.value="<%=JSPCommand.SUBMIT%>";
            document.frmsales.action="jurnalsales.jsp?menu_idx=<%=menuIdx%>";
            document.frmsales.submit();
        }
        
        function setChecked(val){
                 <%
            for (int k = 0; k < list.size(); k++) {
                SalesClosingJournal osl = (SalesClosingJournal) list.get(k);
                if (osl.getType() == 2 || osl.getType() == 3) {
                    if (osl.getSalesReturId() != 0) {
                 %>
                     document.frmsales.sale_<%=osl.getSalesId()%>.checked=val.checked;
                 <%
                    }
                } else {
                 %>
                     document.frmsales.sale_<%=osl.getSalesId()%>.checked=val.checked;
                     
                     <%}
            }%>
            
                     <%
            for (int z = 0; z < listG.size(); z++) {
                SalesClosingJournal osl = (SalesClosingJournal) listG.get(z);
                if (osl.getType() == 2 || osl.getType() == 3) {
                    if (osl.getSalesReturId() != 0) {
                 %>
                     document.frmsales.sale_<%=osl.getSalesId()%>.checked=val.checked;
                 <%
                    }
                } else {
                     %>
                         document.frmsales.saleg_<%=osl.getSalesId()%>.checked=val.checked;
                     <%}
            }%>                     
        }
        
        function cmdchange(){
            document.frmsales.command.value="<%=JSPCommand.SUBMIT%>";
            document.frmsales.action="jurnalsales.jsp?menu_idx=<%=menuIdx%>";
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
                                                                <td width="60%" height="23"><b><font color="#990000" class="lvl1">Accounting 
                                                                        </font><font class="tit1">&raquo; 
                                                                            <span class="lvl2">Process Journal <br>
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
                                                <tr align="left" valign="top"> 
                                                    <td height="8"  colspan="3" class="container"> 
                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                            <tr align="left" valign="top"> 
                                                                <td height="8" valign="middle" colspan="3"> 
                                                                    <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                        <tr> 
                                                                            <td colspan="2">
                                                                                <table border="0" cellpadding="1" cellspacing="1" width="500">                                                                                                                                        
                                                                                    <tr>                                                                                                                                            
                                                                                        <td class="tablecell1" >                                                                                                                                                
                                                                                            <table width="100%" style="border:1px solid #ABA8A8" cellpadding="0" cellspacing="1">  
                                                                                                <tr>
                                                                                                    <td colspan="4" height="10"></td>
                                                                                                </tr>   
                                                                                                <tr>
                                                                                                    <td width="10"></td>
                                                                                                    <td width="50">Date</td>
                                                                                                    <td>
                                                                                                        <table border="0" cellpadding="0" cellspacing="0">
                                                                                                            <tr>
                                                                                                                <td><input name="invStartDate" value="<%=JSPFormater.formatDate((tanggal == null) ? new Date() : tanggal, "dd/MM/yyyy")%>" size="11" style="text-align:center" readOnly></td>
                                                                                                                <td><a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmsales.invStartDate);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt="visit date"></a></td>
                                                                                                            </tr>
                                                                                                        </table>    
                                                                                                    </td>
                                                                                                    <td width="7"></td>
                                                                                                    <td width="50">Periode</td>
                                                                                                    <td>
                                                                                                        <%
            Vector periods = new Vector();
            Periode preClosedPeriod = new Periode();
            Periode openPeriod = new Periode();

            Vector vPreClosed = DbPeriode.list(0, 0, DbPeriode.colNames[DbPeriode.COL_STATUS] + "='" + I_Project.STATUS_PERIOD_PRE_CLOSED + "'", "" + DbPeriode.colNames[DbPeriode.COL_START_DATE]);

            openPeriod = DbPeriode.getOpenPeriod();

            if (vPreClosed != null && vPreClosed.size() > 0) {
                for (int i = 0; i < vPreClosed.size(); i++) {
                    Periode prClosed = (Periode) vPreClosed.get(i);
                    if (i == 0) {
                        preClosedPeriod = prClosed;
                    }
                    periods.add(prClosed);
                }
            }

            if (openPeriod.getOID() != 0) {
                periods.add(openPeriod);
            }

                                                                                                        %>   
                                                                                                        &nbsp;&nbsp;<select name="period">
                                                                                                            <%
            if (periods != null && periods.size() > 0) {
                for (int t = 0; t < periods.size(); t++) {
                    Periode objPeriod = (Periode) periods.get(t);
                                                                                                            %>
                                                                                                            <option value ="<%=objPeriod.getOID()%>" <%if (objPeriod.getOID() == periodId) {%>selected<%}%> ><%=objPeriod.getName()%></option>
                                                                                                            <%}%><%}%>
                                                                                                        </select>                                                                                                        
                                                                                                    </td>
                                                                                                </tr> 
                                                                                                <tr>
                                                                                                    <td></td>
                                                                                                    <td>Location</td>
                                                                                                    <td colspan="3">
                                                                                                        <%

                                                                                                        %>
                                                                                                        <select name="src_location_id">
                                                                                                            <option onClick="javascript:cmdchange()" value="<%=0%>" <%if (0 == locationId) {%>selected<%}%>>select....</option>
                                                                                                            <%if (vLoc != null && vLoc.size() > 0) {
                for (int i = 0; i < vLoc.size(); i++) {
                    Location us = (Location) vLoc.get(i);
                                                                                                            %>
                                                                                                            <option onClick="javascript:cmdchange()" value="<%=us.getOID()%>" <%if (us.getOID() == locationId) {%>selected<%}%>><%=us.getName().toUpperCase()%></option>
                                                                                                            <%}
            }%>
                                                                                                        </select>           
                                                                                                    </td>
                                                                                                </tr>    
                                                                                                <tr>
                                                                                                    <td></td>
                                                                                                    <td>Shift</td>
                                                                                                    <td colspan="3">
                                                                                                        <%
            Vector vShift = DbSales.getShift(locationId, tanggal);
                                                                                                        %>
                                                                                                        <select name="shift_name">
                                                                                                            <option value="0">ALL SHIFT</option>
                                                                                                            <%if (vShift != null && vShift.size() > 0) {
                for (int i = 0; i < vShift.size(); i++) {
                    Shift shift = (Shift) vShift.get(i);
                                                                                                            %>
                                                                                                            <option value="<%=shift.getOID()%>" <%if (shift.getOID() == cashCashierId) {%>selected<%}%>><%=shift.getName()%></option>
                                                                                                            <%}
            }%>
                                                                                                        </select>
                                                                                                    </td>
                                                                                                </tr>   
                                                                                                <tr>
                                                                                                    <td colspan="4" height="10"></td>
                                                                                                </tr>   
                                                                                            </table>     
                                                                                        </td>
                                                                                    </tr>
                                                                                </table>
                                                                            </td>
                                                                        </tr>                                                                       
                                                                        <tr>
                                                                            <td colspan="4"></td>
                                                                        </tr>
                                                                        <tr> 
                                                                            <td width="10%" height="33">&nbsp;&nbsp;&nbsp;<a href="javascript:cmdSearch()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new2','','../images/search2.gif',1)"><img src="../images/search.gif" name="new2" border="0"></a></td>
                                                                            <td height="33" colspan="3"></td>
                                                                        </tr>
                                                                        <tr> 
                                                                            <td colspan="4" height="15">&nbsp;</td>
                                                                        </tr>
                                                                        <tr>
                                                                            <td height="15" colspan="4">
                                                                                <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                                    <%if ((list != null && list.size() > 0) || (listG != null && listG.size() > 0)) {%>                                                                                                                                                    
                                                                                    <tr>
                                                                                        <td align="center" class="tablehdr">NO</td>
                                                                                        <td align="center" class="tablehdr">INVOICE</td>
                                                                                        <td align="center" class="tablehdr">DATE</td>
                                                                                        <td align="center" class="tablehdr">MEMBER</td>
                                                                                        <td align="center" class="tablehdr">CASH</td>
                                                                                        <td align="center" class="tablehdr">CREDIT CARD </td>
                                                                                        <td align="center" class="tablehdr">DEBIT CARD </td>
                                                                                        <td align="center" class="tablehdr">CREDIT(BON)</td>
                                                                                        <td align="center" class="tablehdr">DISCOUNT</td>
                                                                                        <td align="center" class="tablehdr">RETUR</td>
                                                                                        <td align="center" class="tablehdr">AMOUNT</td>
                                                                                        <td align="center" class="tablehdr"><input type="checkbox" name="chkbox" onClick="setChecked(this)"></td>
                                                                                    </tr>
                                                                                    <%}%>
                                                                                    <%if (list != null && list.size() > 0) {%>
                                                                                    <tr>
                                                                                        <td colspan="11"><strong>SALES DATA</strong> </td>
                                                                                    </tr>
                                                                                    <%}%>
                                                                                    <%
            // tootal       
            double totSubCash = 0;
            double totSubCard = 0;
            double totSubDebit = 0;
            double totSubBon = 0;
            double totSubDiscount = 0;
            double totSubRetur = 0;
            double totSubAmount = 0;

            // sub total
            double subCash = 0;
            double subCard = 0;
            double subDebit = 0;
            double subBon = 0;
            double subDiscount = 0;
            double subRetur = 0;
            double subAmount = 0;
            boolean isNotComplete = false;

            if (list != null && list.size() > 0) {
                for (int k = 0; k < list.size(); k++) {

                    SalesClosingJournal salesClosing = (SalesClosingJournal) list.get(k);

                    // simpan total transaksi
                    subCash = subCash + salesClosing.getCash();
                    subCard = subCard + salesClosing.getCCard();
                    subDebit = subDebit + salesClosing.getDCard();
                    subBon = subBon + salesClosing.getBon();
                    subDiscount = subDiscount + salesClosing.getDiscount();
                    subRetur = subRetur + salesClosing.getRetur();
                    subAmount = subAmount + salesClosing.getAmount();

                                                                                    %>
                                                                                    <tr>
                                                                                        <td align="center" class="tablecell"><%=(k + 1)%></td>
                                                                                        <%if (salesClosing.getInvoiceNumber().length() <= 0) {%>
                                                                                        <td align="left" bgcolor="FF0000"><%=salesClosing.getInvoiceNumber()%></td>
                                                                                        <%} else {%>
                                                                                        <%if (salesClosing.getType() == 2 || salesClosing.getType() == 3) {%>
                                                                                        <%
    if (salesClosing.getSalesReturId() == 0) {
        isNotComplete = true;
                                                                                        %>
                                                                                        <td align="left" bgcolor="FF0000"><%=salesClosing.getInvoiceNumber()%></td>
                                                                                        <%} else {%>
                                                                                        <td align="left" class="tablecell"><%=salesClosing.getInvoiceNumber()%></td>
                                                                                        <%}%>
                                                                                        <%} else {%>    
                                                                                        <td align="left" class="tablecell"><%=salesClosing.getInvoiceNumber()%></td>
                                                                                        <%}%>    
                                                                                        <%}%>   
                                                                                        <td align="left" class="tablecell"><%=salesClosing.getTglJam()%></td>
                                                                                        <td align="left" class="tablecell"><%=salesClosing.getMember()%></td>
                                                                                        <td align="right" class="tablecell"><%=JSPFormater.formatNumber(salesClosing.getCash(), "#,##0")%></td>
                                                                                        <td align="right" class="tablecell">
                                                                                            <%=JSPFormater.formatNumber(salesClosing.getCCard(), "#,##0")%>
                                                                                        </td>
                                                                                        <td align="right" class="tablecell">
                                                                                            <%=JSPFormater.formatNumber(salesClosing.getDCard(), "#,##0")%>
                                                                                        </td>
                                                                                        <td align="right" class="tablecell"><%=JSPFormater.formatNumber(salesClosing.getBon(), "#,##0")%></td>
                                                                                        <td align="right" class="tablecell"><%=JSPFormater.formatNumber(salesClosing.getDiscount(), "#,##0")%></td>
                                                                                        <td align="right" class="tablecell"><%=JSPFormater.formatNumber(salesClosing.getRetur(), "#,##0")%></td>
                                                                                        <td align="right" class="tablecell"><%=JSPFormater.formatNumber(salesClosing.getAmount(), "#,##0")%></td>                                                                                                                                                        
                                                                                        <%if (salesClosing.getType() == 2 || salesClosing.getType() == 3) {%>
                                                                                        <%if (salesClosing.getSalesReturId() == 0) {%>
                                                                                        <td align="center" class="tablecell"><input type="checkbox" name="sale_<%=salesClosing.getSalesId()%>" value="1"></td>
                                                                                        <%} else {%>
                                                                                        <td align="center" class="tablecell"><input type="checkbox" name="sale_<%=salesClosing.getSalesId()%>" value="1"></td>
                                                                                        <%}%>
                                                                                        <%} else {%>
                                                                                        <td align="center" class="tablecell"><input type="checkbox" name="sale_<%=salesClosing.getSalesId()%>" value="1"></td>
                                                                                        <%}%>                                                                                                                                                        
                                                                                    </tr>
                                                                                    <%}
            }
            totSubCash = subCash;
            totSubCard = subCard;
            totSubDebit = subDebit;
            totSubBon = subBon;
            totSubDiscount = subDiscount;
            totSubRetur = subRetur;
            totSubAmount = subAmount;
                                                                                    %>
                                                                                    <%if (list != null && list.size() > 0) {%>
                                                                                    <tr>
                                                                                        <td colspan="11"></td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td class="tablecell">&nbsp;</td>
                                                                                        <td class="tablecell">&nbsp;</td>
                                                                                        <td class="tablecell">&nbsp;</td>
                                                                                        <td class="tablecell"><b>SUB TOTAL</b></td>
                                                                                        <td align="right" class="tablecell"><b><%=JSPFormater.formatNumber(subCash, "#,##0")%></b></td>
                                                                                        <td align="right" class="tablecell"><b><%=JSPFormater.formatNumber(subCard, "#,##0")%></b></td>
                                                                                        <td align="right" class="tablecell"><b><%=JSPFormater.formatNumber(subDebit, "#,##0")%></b></td>
                                                                                        <td align="right" class="tablecell"><b><%=JSPFormater.formatNumber(subBon, "#,##0")%></b></td>
                                                                                        <td align="right" class="tablecell"><b><%=JSPFormater.formatNumber(subDiscount, "#,##0")%></b></td>
                                                                                        <td align="right" class="tablecell"><b><%=JSPFormater.formatNumber(subRetur, "#,##0")%></b></td>
                                                                                        <td align="right" class="tablecell"><b><%=JSPFormater.formatNumber(subAmount, "#,##0")%></b></td>
                                                                                        <td></td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td colspan="10">&nbsp;</td>
                                                                                    </tr>
                                                                                    <%}%>
                                                                                    <%if (listG != null && listG.size() > 0){%>
                                                                                    <tr>
                                                                                        <td colspan="10"><strong>GROOMING DATA</strong> </td>
                                                                                    </tr>
                                                                                    <%}%>
                                                                                    <%
            subCash = 0;
            subCard = 0;
            subBon = 0;
            subDiscount = 0;
            subRetur = 0;
            subAmount = 0;

            if (listG.size() > 0) {
                for (int k = 0; k < listG.size(); k++) {
                    SalesClosingJournal salesClosing = (SalesClosingJournal) listG.get(k);

                    // simpan total transaksi
                    subCash = subCash + salesClosing.getCash();
                    subCard = subCard + salesClosing.getCCard();
                    subBon = subBon + salesClosing.getBon();
                    subDiscount = subDiscount + salesClosing.getDiscount();
                    subRetur = subRetur + salesClosing.getRetur();
                    subAmount = subAmount + salesClosing.getAmount();
                                                                                    %>
                                                                                    <tr>
                                                                                        <td align="center" class="tablecell"><%=(k + 1)%></td>
                                                                                        <%if (salesClosing.getType() == 2 || salesClosing.getType() == 3) {%>
                                                                                        <%
    if (salesClosing.getSalesReturId() == 0) {
        isNotComplete = true;
                                                                                        %>
                                                                                        <td align="left" bgcolor="FF0000"><%=salesClosing.getInvoiceNumber()%></td>
                                                                                        <%} else {%>
                                                                                        <td align="left" class="tablecell"><%=salesClosing.getInvoiceNumber()%></td>
                                                                                        <%}%>
                                                                                        <%} else {%>    
                                                                                        <td align="left" class="tablecell"><%=salesClosing.getInvoiceNumber()%></td>
                                                                                        <%}%>    
                                                                                        <td align="left" class="tablecell"><%=salesClosing.getTglJam()%></td>
                                                                                        <td align="left" class="tablecell"><%=salesClosing.getMember()%></td>
                                                                                        <td align="right" class="tablecell"><%=JSPFormater.formatNumber(salesClosing.getCash(), "#,##0")%></td>
                                                                                        <td align="right" class="tablecell"><%=JSPFormater.formatNumber(salesClosing.getCCard(), "#,##0")%></td>
                                                                                        <td align="right" class="tablecell"><%=JSPFormater.formatNumber(salesClosing.getBon(), "#,##0")%></td>
                                                                                        <td align="right" class="tablecell"><%=JSPFormater.formatNumber(salesClosing.getDiscount(), "#,##0")%></td>
                                                                                        <td align="right" class="tablecell"><%=JSPFormater.formatNumber(salesClosing.getRetur(), "#,##0")%></td>
                                                                                        <td align="right" class="tablecell"><%=JSPFormater.formatNumber(salesClosing.getAmount(), "#,##0")%></td>
                                                                                        <%if (salesClosing.getType() == 2 || salesClosing.getType() == 3) {%>
                                                                                        <%if (salesClosing.getSalesReturId() == 0) {%>
                                                                                        <td align="center" class="tablecell"></td>
                                                                                        <%} else {%>
                                                                                        <td align="center" class="tablecell"><input type="checkbox" name="saleg_<%=salesClosing.getSalesId()%>" value="1"></td>
                                                                                        <%}%>
                                                                                        <%} else {%>
                                                                                        <td align="center" class="tablecell"><input type="checkbox" name="saleg_<%=salesClosing.getSalesId()%>" value="1"></td>
                                                                                        <%}%>
                                                                                    </tr>
                                                                                    <%}
            }

            totSubCash = totSubCash + subCash;
            totSubCard = totSubCard + subCard;
            totSubBon = totSubBon + subBon;
            totSubDiscount = totSubDiscount + subDiscount;
            totSubRetur = totSubRetur + subRetur;
            totSubAmount = totSubAmount + subAmount;

                                                                                    %>
                                                                                    <%if (listG != null && listG.size() > 0) {%>
                                                                                    <tr>
                                                                                        <td></td>
                                                                                        <td></td>
                                                                                        <td></td>
                                                                                        <td></td>
                                                                                        <td></td>
                                                                                        <td></td>
                                                                                        <td></td>
                                                                                        <td></td>
                                                                                        <td></td>
                                                                                        <td></td>
                                                                                        <td></td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td class="tablecell">&nbsp;</td>
                                                                                        <td class="tablecell">&nbsp;</td>
                                                                                        <td class="tablecell">&nbsp;</td>
                                                                                        <td class="tablecell"><b>SUB TOTAL</b></td>
                                                                                        <td align="right" class="tablecell"><b><%=JSPFormater.formatNumber(subCash, "#,##0")%></b></td>
                                                                                        <td align="right" class="tablecell"><b><%=JSPFormater.formatNumber(subCard, "#,##0")%></b></td>
                                                                                        <td align="right" class="tablecell"><b><%=JSPFormater.formatNumber(subBon, "#,##0")%></b></td>
                                                                                        <td align="right" class="tablecell"><b><%=JSPFormater.formatNumber(subDiscount, "#,##0")%></b></td>
                                                                                        <td align="right" class="tablecell"><b><%=JSPFormater.formatNumber(subRetur, "#,##0")%></b></td>
                                                                                        <td align="right" class="tablecell"><b><%=JSPFormater.formatNumber(subAmount, "#,##0")%></b></td>
                                                                                        <td></td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td></td>
                                                                                        <td></td>
                                                                                        <td></td>
                                                                                        <td></td>
                                                                                        <td></td>
                                                                                        <td></td>
                                                                                        <td></td>
                                                                                        <td></td>
                                                                                        <td></td>
                                                                                        <td></td>
                                                                                    </tr>
                                                                                    <%}%>
                                                                                    <%if ((list != null && list.size() > 0) || (listG != null && listG.size() > 0)) {%>
                                                                                    <tr>
                                                                                        <td class="tablecell">&nbsp;</td>
                                                                                        <td class="tablecell">&nbsp;</td>
                                                                                        <td class="tablecell">&nbsp;</td>
                                                                                        <td class="tablecell"><b>TOTAL</b></td>
                                                                                        <td align="right" class="tablecell"><b><%=JSPFormater.formatNumber(totSubCash, "#,##0")%></b></td>
                                                                                        <td align="right" class="tablecell"><b><%=JSPFormater.formatNumber(totSubCard, "#,##0")%></b></td>
                                                                                        <td align="right" class="tablecell"><b><%=JSPFormater.formatNumber(totSubBon, "#,##0")%></b></td>
                                                                                        <td align="right" class="tablecell"><b><%=JSPFormater.formatNumber(totSubDiscount, "#,##0")%></b></td>
                                                                                        <td align="right" class="tablecell"><b><%=JSPFormater.formatNumber(totSubRetur, "#,##0")%></b></td>
                                                                                        <td align="right" class="tablecell"><b><%=JSPFormater.formatNumber(totSubAmount, "#,##0")%></b></td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td colspan="10" height="15"></td>
                                                                                    </tr>
                                                                                    <tr id="closecmd"> 
                                                                                        <td colspan="10" align="left">
                                                                                            <a href="javascript:cmdPostJournal()"><img src="../images/post_journal.gif" width="92" height="22" border="0"></a></div>
                                                                                        </td>
                                                                                    </tr>
                                                                                    <tr id="closemsg" align="left" valign="top"> 
                                                                                        <td height="22" valign="middle" colspan="10"> 
                                                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                                <tr> 
                                                                                                    <td> <font color="#006600">Posting sales in progress, please wait .... </font> </td>
                                                                                                </tr>
                                                                                                <tr> 
                                                                                                    <td height="1">&nbsp; </td>
                                                                                                </tr>
                                                                                                <tr> 
                                                                                                    <td> <img src="../images/progress_bar.gif" border="0"> 
                                                                                                    </td>
                                                                                                </tr>
                                                                                            </table>
                                                                                        </td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td colspan="10" height="15"></td>
                                                                                    </tr>
                                                                                    <%if (isNotComplete) {%>
                                                                                    <tr height="20">
                                                                                        <td colspan="10" height="15" class="tablecell">
                                                                                            <table>
                                                                                                <tr>
                                                                                                    <td colspan="3">Note :</td>
                                                                                                </tr>    
                                                                                                <tr>
                                                                                                    <td bgcolor="FF0000" width="10">&nbsp;</td>
                                                                                                    <td width="5" align="center">:</td>
                                                                                                    <td >Data incomplete</td>
                                                                                                </tr>    
                                                                                            </table>    
                                                                                        </td>
                                                                                    </tr>
                                                                                    <%}%>
                                                                                    <%} else {%>
                                                                                    <%if (iJSPCommand != JSPCommand.NONE) {%>
                                                                                    <tr height="17">
                                                                                        <td colspan="10" height="15" class="tablecell">&nbsp;<i>Data not found</i></td>
                                                                                    </tr>
                                                                                    <tr > 
                                                                                        <td colspan="10" background="<%=approot%>/images/line1.gif" ></td>
                                                                                    </tr>
                                                                                    <%}%>
                                                                                    <%}%>
                                                                                    <%if (iJSPCommand == JSPCommand.NONE) {%>
                                                                                    <tr height="17">
                                                                                        <td colspan="10" class="tablecell1">&nbsp;<i>Click Search button, to searching the data</i></td>
                                                                                    </tr>
                                                                                    <tr > 
                                                                                        <td colspan="10" background="<%=approot%>/images/line1.gif" ></td>
                                                                                    </tr>
                                                                                    <%}%>    
                                                                                </table>
                                                                            </td>
                                                                        </tr>
                                                                        <tr>
                                                                            <td height="15" colspan="4">&nbsp;</td>
                                                                        </tr>                                                                   
                                                                    </table>
                                                                </td>
                                                            </tr>
                                                            <tr align="left" valign="top"> 
                                                                <td height="22" valign="middle" colspan="4"> 
                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                        <tr>
                                                                            <td class="boxed1"></td>
                                                                        </tr>
                                                                    </table>
                                                                </td>
                                                            </tr>
                                                            <tr align="left" valign="top"> 
                                                                <td height="8" align="left" colspan="3" class="command"> 
                                                                    <span class="command"> 
                                                                </span> </td>
                                                            </tr>
                                                            <tr align="left" valign="top"> 
                                                                <td height="22" valign="middle" colspan="4"> 
                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                        <tr> 
                                                                            <td width="97%">&nbsp;</td>
                                                                        </tr>
                                                                    </table>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                                <tr align="left" valign="top"> 
                                                    <td height="8" valign="middle" colspan="3">&nbsp; 
                                                    </td>
                                                </tr>
                                            </table>
                                            <script language="JavaScript">
                                                document.all.closecmd.style.display="";
                                                document.all.closemsg.style.display="none";
                                            </script>    
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

