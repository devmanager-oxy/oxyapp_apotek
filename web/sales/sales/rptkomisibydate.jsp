
<%-- 
    Document   : rptkomisibydate
    Created on : Feb 17, 2015, 2:32:29 PM
    Author     : Roy
--%>


<%@ page language = "java" %> 
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.main.db.*" %>
<%@ page import = "com.project.main.entity.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "com.project.admin.*" %>
<%@ page import = "com.project.fms.master.*" %>
<%@ page import = "com.project.ccs.postransaction.sales.*" %>
<%@ page import = "com.project.ccs.posmaster.*" %>
<%@ page import = "com.project.ccs.postransaction.stock.*" %>
<%@ page import = "com.project.ccs.session.*" %>
<%@ include file = "../main/javainit.jsp" %>
<%@ include file = "../main/checksl.jsp" %>
<%@ include file="../calendar/calendarframe.jsp"%>
<%
            boolean priv = true;
            boolean privView = true;
            boolean privPrint = true;            
%>
<!-- Jsp Block -->
<%

            if (session.getValue("REPORT_KOMISI") != null) {
                session.removeValue("REPORT_KOMISI");
            }
            String strdate1 = JSPRequestValue.requestString(request, "invStartDate");
            String strdate2 = JSPRequestValue.requestString(request, "invEndDate");
            Date invStartDate = (JSPRequestValue.requestString(request, "invStartDate") == null) ? new Date() : JSPFormater.formatDate(strdate1, "dd/MM/yyyy");
            Date invEndDate = (JSPRequestValue.requestString(request, "invEndDate") == null) ? new Date() : JSPFormater.formatDate(strdate2, "dd/MM/yyyy");
            long locationId = JSPRequestValue.requestLong(request, "src_location_id");
            long vendorId = JSPRequestValue.requestLong(request, "src_vendor_id");
            int iJSPCommand = JSPRequestValue.requestCommand(request);
            int start = JSPRequestValue.requestInt(request, "start");
            int groupByDate = JSPRequestValue.requestInt(request, "group_by_date");
            int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");

            Vector result = new Vector();

            if (iJSPCommand == JSPCommand.SEARCH) {
                ReportParameter rp = new ReportParameter();

                rp.setLocationId(locationId);
                rp.setDateFrom(invStartDate);
                rp.setDateTo(invEndDate);
                rp.setVendorId(vendorId);
                session.putValue("REPORT_KOMISI", rp);

                result = SessReportSales.reportKomisi(locationId, vendorId, invStartDate, invEndDate);

            }

            String parameter = "Date Between : " + JSPFormater.formatDate(invStartDate, "dd/MM/yyyy") + " to " + JSPFormater.formatDate(invEndDate, "dd/MM/yyyy");
            if (locationId != 0) {
                try {
                    Location l = DbLocation.fetchExc(locationId);
                    parameter = parameter + " , Location :" + l.getName();
                } catch (Exception e) {
                }
            }

            if (locationId != 0) {
                try {
                    Location l = DbLocation.fetchExc(locationId);
                    parameter = parameter + " , Location :" + l.getName();
                } catch (Exception e) {
                }
            }

            if (vendorId != 0) {
                try {
                    Vendor v = DbVendor.fetchExc(vendorId);
                    parameter = parameter + " , Vendor :" + v.getName();
                } catch (Exception e) {
                }
            }
            
            if(groupByDate==0){
                
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
            <%if (!priv || !privView) {%>
            window.location="<%=approot%>/nopriv.jsp";
            <%}%>
            
            function cmdPrintJournalXLS(){	                       
                window.open("<%=printroot%>.report.RptKomisiXls?user_id=<%=appSessUser.getUserOID()%>&lang=<%=lang%>","",'scrollbars=yes,status=yes,width=750,height=600,resizable=yes');
                }
                
                function cmdSearch(){
                    document.frmsales.command.value="<%=JSPCommand.SEARCH%>";
                    document.frmsales.action="rptkomisi.jsp?menu_idx=<%=menuIdx%>";
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
                                                                                                                                <td width="60%" height="23"><b><font color="#990000" class="lvl1">Sales Report 
                                                                                                                                        </font><font class="tit1">&raquo; 
                                                                                                                                <span class="lvl2">Komisi Report<br></span></font></b></td>
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
                                                                                                                                <td height="8" valign="middle" colspan="3" >   
                                                                                                                                    <table width="100%" border="0" cellspacing="1" cellpadding="1" width="400" >
                                                                                                                                        <tr> 
                                                                                                                                            <td width="100" height="14" width="10"></td>
                                                                                                                                            <td width="2" height="14" nowrap>&nbsp;</td>
                                                                                                                                            <td colspan="2" height="14">&nbsp;</td>
                                                                                                                                        </tr>
                                                                                                                                        <tr> 
                                                                                                                                            <td height="14" class="tablearialcell">&nbsp;&nbsp;Date Between</td>
                                                                                                                                            <td height="14" class="fontarial">:</td>
                                                                                                                                            <td colspan="3">
                                                                                                                                                <table cellpadding="0" cellspacing="0">
                                                                                                                                                    <tr>
                                                                                                                                                        <td > 
                                                                                                                                                            <input name="invStartDate" value="<%=JSPFormater.formatDate((invStartDate == null) ? new Date() : invStartDate, "dd/MM/yyyy")%>" size="11" style="text-align:center" readOnly>
                                                                                                                                                        </td>
                                                                                                                                                        <td>
                                                                                                                                                            <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmsales.invStartDate);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt="visit date"></a> 
                                                                                                                                                        </td>
                                                                                                                                                        <td class="fontarial">    
                                                                                                                                                            &nbsp;&nbsp;and&nbsp;&nbsp;
                                                                                                                                                        </td>
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
                                                                                                                                            <td height="14" nowrap class="tablearialcell">&nbsp;&nbsp;Suplier</td>
                                                                                                                                            <td height="14" class="fontarial">:</td>
                                                                                                                                            <td height="14"> 
                                                                                                                                                <%
            String whereKom = DbVendor.colNames[DbVendor.COL_IS_KOMISI] + " = 1";
            Vector vVendor = DbVendor.list(0, 0, whereKom, DbVendor.colNames[DbVendor.COL_NAME]);

                                                                                                                                                %>
                                                                                                                                                <select name="src_vendor_id" class="fontarial">                                                                                                                                                    
                                                                                                                                                    <%if (vVendor != null && vVendor.size() > 0) {
                for (int i = 0; i < vVendor.size(); i++) {
                    Vendor v = (Vendor) vVendor.get(i);
                                                                                                                                                    %>
                                                                                                                                                    <option value="<%=v.getOID()%>" <%if (v.getOID() == vendorId) {%>selected<%}%>><%=v.getName().toUpperCase()%></option>
                                                                                                                                                    <%}
            }%>
                                                                                                                                                </select>
                                                                                                                                            </td>
                                                                                                                                            <td height="15">&nbsp;</td>
                                                                                                                                        </tr>
                                                                                                                                        <tr>
                                                                                                                                            <td height="14" class="tablearialcell">&nbsp;&nbsp;Location</td>
                                                                                                                                            <td height="14" class="fontarial">:</td>
                                                                                                                                            <td height="14"> 
                                                                                                                                                <%
            Vector vLoc = userLocations;
                                                                                                                                                %>
                                                                                                                                                <select name="src_location_id" class="fontarial">                                                                                                                                                    
                                                                                                                                                    <%if (vLoc != null && vLoc.size() > 0) {
                for (int i = 0; i < vLoc.size(); i++) {
                    Location us = (Location) vLoc.get(i);
                                                                                                                                                    %>
                                                                                                                                                    <option value="<%=us.getOID()%>" <%if (us.getOID() == locationId) {%>selected<%}%>><%=us.getName().toUpperCase()%></option>
                                                                                                                                                    <%}
            }%>
                                                                                                                                                </select>
                                                                                                                                            </td>
                                                                                                                                            <td height="14">&nbsp;</td>
                                                                                                                                        </tr>  
                                                                                                                                        <tr>
                                                                                                                                            <td height="14" class="tablearialcell">&nbsp;&nbsp;Group</td>
                                                                                                                                            <td height="14" class="fontarial">:</td>
                                                                                                                                            <td height="14" class="fontarial"><table border="0" cellpadding="0" cellspacing="0"><tr><td><input type="checkbox" name="group_by_date" <%if (groupByDate == 1) {%> checked <%}%> ></td><td class="fontarial">&nbsp;&nbsp;By Date</td></tr></table></td>
                                                                                                                                            <td height="14"></td>
                                                                                                                                        </tr>                                                                                                                                                      
                                                                                                                                    </table>
                                                                                                                                    
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                            <tr align="left" valign="top"> 
                                                                                                                                <td >
                                                                                                                                    <table width="80%" border="0" cellspacing="1" cellpadding="1" height="3">
                                                                                                                                        <tr > 
                                                                                                                                            <td height="3" background="<%=approot%>/images/line1.gif" ></td>
                                                                                                                                        </tr>
                                                                                                                                    </table> 
                                                                                                                                </td>
                                                                                                                            </tr> 
                                                                                                                            <tr align="left" valign="top"> 
                                                                                                                                <td height="22" valign="middle" colspan="4">&nbsp;<a href="javascript:cmdSearch()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new2','','../images/search2.gif',1)"><img src="../images/search.gif" name="new2" border="0"></a></td>
                                                                                                                            </tr> 
                                                                                                                            <tr align="left" valign="top"> 
                                                                                                                                <td height="22" valign="middle" colspan="4">&nbsp;</td>
                                                                                                                            </tr> 
                                                                                                                            <%
            if (result != null && result.size() > 0) {
                double totTotal = 0;
                                                                                                                            %>
                                                                                                                            
                                                                                                                            <tr align="left" valign="top"> 
                                                                                                                                <td height="22" valign="middle" colspan="4">    
                                                                                                                                    <table width="1000" border="0" cellspacing="1" cellpadding="2">
                                                                                                                                        <tr>
                                                                                                                                            <td colspan="9" class="fontarial" bgcolor="#BFD8AF"><i>&nbsp;<%=parameter%></i></td>
                                                                                                                                        </tr>   
                                                                                                                                        <tr height="20"> 
                                                                                                                                            <td class="tablehdr" width="6%">No</td>                                                                                                                                            
                                                                                                                                            <td class="tablehdr" width="15%">Date</td>
                                                                                                                                            <td class="tablehdr" width="15%">Sales Number</td>
                                                                                                                                            <td class="tablehdr" >Description</td>
                                                                                                                                            <td class="tablehdr" width="10%">Qty</td>
                                                                                                                                            <td class="tablehdr" width="10%">Price</td>
                                                                                                                                            <td class="tablehdr" width="10%">Discount</td>
                                                                                                                                            <td class="tablehdr" width="10%">Total</td>
                                                                                                                                            <td class="tablehdr" width="10%">Total</td>
                                                                                                                                        </tr>   
                                                                                                                                        <%
                                                                                                                                int number = 1;
                                                                                                                                long salesId = 0;
                                                                                                                                double total = 0;
                                                                                                                                double totQty = 0;
                                                                                                                                double gTotQty = 0;

                                                                                                                                for (int i = 0; i < result.size(); i++) {

                                                                                                                                    ReportKomisi rk = (ReportKomisi) result.get(i);
                                                                                                                                    double totPrice = (rk.getQty() * rk.getSellingPrice()) - rk.getDiscount();

                                                                                                                                    if (salesId != rk.getSalesId() && i != 0) {
                                                                                                                                        totTotal = totTotal + total;
                                                                                                                                        gTotQty = gTotQty + totQty;
                                                                                                                                        %>
                                                                                                                                        <tr height="20"> 
                                                                                                                                            <td class="tablecell1" colspan="4" align="right">&nbsp;</td>  
                                                                                                                                            <td class="tablecell1" align="right"><%=JSPFormater.formatNumber(totQty, "###,###")%></td>  
                                                                                                                                            <td class="tablecell1" colspan="3" align="right">&nbsp;</td>                                                                                                                                              
                                                                                                                                            <td class="tablecell1" align="right"><B><%=JSPFormater.formatNumber(total, "###,###.##")%></B></td>  
                                                                                                                                        </tr>  
                                                                                                                                        <%
                                                                                                                                                total = 0;
                                                                                                                                                totQty = 0;
                                                                                                                                            }
                                                                                                                                            total = total + totPrice;
                                                                                                                                            totQty = totQty + rk.getQty();
                                                                                                                                        %>
                                                                                                                                        <tr height="20"> 
                                                                                                                                            <%if (salesId != rk.getSalesId()) {%>
                                                                                                                                            <td class="tablecell" align="center"><%=number%></td>  
                                                                                                                                            <td class="tablecell" align="center"><%=JSPFormater.formatDate(rk.getTanggal(), "dd-MMM-yyyy")%></td>  
                                                                                                                                            <%
    number++;
} else {
                                                                                                                                            %>
                                                                                                                                            <td class="tablecell" align="center">&nbsp;</td>  
                                                                                                                                            <td class="tablecell" align="center">&nbsp;</td>                                                                                                                                              
                                                                                                                                            <%}%> 
                                                                                                                                            <td class="tablecell" align="left"><%=rk.getSalesNumber()%></td>  
                                                                                                                                            <td class="tablecell" align="left"><%=rk.getName()%></td>  
                                                                                                                                            <td class="tablecell" align="right"><%=JSPFormater.formatNumber(rk.getQty(), "###,###")%></td>                                                                                                                                              
                                                                                                                                            <td class="tablecell" align="right"><%=JSPFormater.formatNumber(rk.getSellingPrice(), "###,###")%></td>  
                                                                                                                                            <td class="tablecell" align="right"><%=JSPFormater.formatNumber(rk.getDiscount(), "###,###")%></td>  
                                                                                                                                            <td class="tablecell" align="right"><%=JSPFormater.formatNumber(totPrice, "###,###")%></td>                                                                                                                                              
                                                                                                                                            <td class="tablecell" align="right">&nbsp;</td>  
                                                                                                                                        </tr>    
                                                                                                                                        <%
                                                                                                                                    salesId = rk.getSalesId();
                                                                                                                                }
                                                                                                                                        %>
                                                                                                                                        <tr height="20"> 
                                                                                                                                            <td class="tablecell1" colspan="4" align="right">&nbsp;</td>  
                                                                                                                                            <td class="tablecell1" align="right"><%=JSPFormater.formatNumber(totQty, "###,###")%></td>  
                                                                                                                                            <td class="tablecell1" colspan="3" align="right">&nbsp;</td>                                                                                                                                            
                                                                                                                                            <td class="tablecell1" align="right"><B><%=JSPFormater.formatNumber(total, "###,###.##")%></B></td>  
                                                                                                                                        </tr>  
                                                                                                                                        <%totTotal = totTotal + total;%>
                                                                                                                                        <%gTotQty = gTotQty + totQty;%>
                                                                                                                                        <tr height="20"> 
                                                                                                                                            <td class="tablecell1" colspan="4" align="center"><B>GRAND TOTAL</B></td>    
                                                                                                                                            <td class="tablecell1" align="right"><%=JSPFormater.formatNumber(gTotQty, "###,###")%></td>  
                                                                                                                                            <td class="tablecell1" colspan="3" align="right">&nbsp;</td> 
                                                                                                                                            <td class="tablecell1" align="right"><B><%=JSPFormater.formatNumber(totTotal, "###,###.##")%></B></td>                                                                                                                                                                                                                                                                                        
                                                                                                                                        </tr>  
                                                                                                                                        <tr height="40"> 
                                                                                                                                            <td colspan="8" align="center">&nbsp;</td>                                                                                                                                                                                                                                                                                       
                                                                                                                                        </tr>  
                                                                                                                                        <tr> 
                                                                                                                                            <td colspan="5">&nbsp;</td>                                                                                                                                               
                                                                                                                                            <td align="left" colspan="2"><B>Total Selling Value (bruto)</B></td>                                                                                                                                            
                                                                                                                                            <td align="right"><B>Rp.</B></td>
                                                                                                                                            <td align="right"><B><%=JSPFormater.formatNumber(totTotal, "###,###.##")%></B></td>
                                                                                                                                        </tr> 
                                                                                                                                        <%
                                                                                                                                Vendor v = new Vendor();
                                                                                                                                try {
                                                                                                                                    v = DbVendor.fetchExc(vendorId);
                                                                                                                                } catch (Exception e) {
                                                                                                                                }
                                                                                                                                double margin = (v.getKomisiMargin() / 100) * totTotal;
                                                                                                                                double net = totTotal - margin;
                                                                                                                                        %>
                                                                                                                                        <tr> 
                                                                                                                                            <td colspan="5">&nbsp;</td>                                                                                                                                               
                                                                                                                                            <td align="left" colspan="2"><B>Margin <%=v.getKomisiMargin()%> %</B></td>                                                                                                                                            
                                                                                                                                            <td align="right"><B>Rp.</B></td>
                                                                                                                                            <td align="right" ><B><%=JSPFormater.formatNumber(margin, "###,###.##")%></B></td>
                                                                                                                                        </tr> 
                                                                                                                                        <tr height="3"> 
                                                                                                                                            <td colspan="5"></td>                                                                                                                                               
                                                                                                                                            <td align="left" colspan="2"></td>                                                                                                                                            
                                                                                                                                            <td align="right"></td>
                                                                                                                                            <td background="<%=approot%>/images/line1.gif"></td>
                                                                                                                                        </tr> 
                                                                                                                                        <tr> 
                                                                                                                                            <td colspan="5">&nbsp;</td>                                                                                                                                               
                                                                                                                                            <td align="left" colspan="2"><B>Total Selling Value (netto)</B></td>                                                                                                                                            
                                                                                                                                            <td align="right"><B>Rp.</B></td>
                                                                                                                                            <td align="right"><B><%=JSPFormater.formatNumber(net, "###,###.##")%></B></td>
                                                                                                                                        </tr> 
                                                                                                                                        <tr> 
                                                                                                                                            <td colspan="8">&nbsp;</td>                                                                                                                                                                                                                                                                                           
                                                                                                                                        </tr> 
                                                                                                                                        <tr> 
                                                                                                                                            <td colspan="5">&nbsp;</td>                                                                                                                                               
                                                                                                                                            <td align="left" colspan="2"><B>Discount :</B></td>                                                                                                                                            
                                                                                                                                            <td align="right">&nbsp;</td>
                                                                                                                                            <td align="right">&nbsp;</td>
                                                                                                                                        </tr> 
                                                                                                                                        <%
                                                                                                                                double promosi = 0;
                                                                                                                                if (v.getKomisiPromosi() > 0) {
                                                                                                                                    promosi = (v.getKomisiPromosi() / 100) * totTotal;
                                                                                                                                        %>
                                                                                                                                        <tr> 
                                                                                                                                            <td colspan="5">&nbsp;</td>                                                                                                                                               
                                                                                                                                            <td align="left" colspan="2">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<B>Promosi <%=v.getKomisiPromosi()%> % x Rp.<%=JSPFormater.formatNumber(totTotal, "###,###.##")%></B></td>                                                                                                                                            
                                                                                                                                            <td align="right"><B>Rp.</B></td>
                                                                                                                                            <td align="right"><B><%=JSPFormater.formatNumber(promosi, "###,###.##")%></B></td>
                                                                                                                                        </tr> 
                                                                                                                                        <%
                                                                                                                                }
                                                                                                                                double totPayment = net - promosi;
                                                                                                                                        %>
                                                                                                                                        <tr height="3"> 
                                                                                                                                            <td colspan="5"></td>                                                                                                                                               
                                                                                                                                            <td align="left" colspan="2"></td>                                                                                                                                            
                                                                                                                                            <td align="right"></td>
                                                                                                                                            <td background="<%=approot%>/images/line1.gif"></td>
                                                                                                                                        </tr> 
                                                                                                                                        <tr> 
                                                                                                                                            <td colspan="5">&nbsp;</td>                                                                                                                                               
                                                                                                                                            <td align="left" colspan="2"><B>Total Payment</B></td>                                                                                                                                            
                                                                                                                                            <td align="right"><B>Rp.</B></td>
                                                                                                                                            <td align="right"><B><%=JSPFormater.formatNumber(totPayment, "###,###.##")%></B></td>
                                                                                                                                        </tr> 
                                                                                                                                    </table>
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                            <tr align="left" valign="top"> 
                                                                                                                                <td height="22" valign="middle" colspan="4">&nbsp;</td>     
                                                                                                                            </tr> 
                                                                                                                            <tr align="left" valign="top"> 
                                                                                                                                <td height="22" valign="middle" colspan="4"> 
                                                                                                                                    <a href="javascript:cmdPrintJournalXLS()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('print','','../images/printxls2.gif',1)"><img src="../images/printxls.gif" name="print" height="22" border="0"></a>
                                                                                                                                </td>     
                                                                                                                            </tr>     
                                                                                                                            <%} else {%>
                                                                                                                            <%if (iJSPCommand != JSPCommand.NONE) {%>
                                                                                                                            <tr align="left" valign="middle"> 
                                                                                                                                <td height="17" class="tablecell1" colspan="4"><i>&nbsp;Data not found</i></td> 
                                                                                                                            </tr>  
                                                                                                                            <%}%>
                                                                                                                            <%}%>
                                                                                                                            <%if (iJSPCommand == JSPCommand.NONE) {%>
                                                                                                                            <tr align="left" valign="middle"> 
                                                                                                                                <td height="17" colspan="4" class="fontarial"><b><i>&nbsp;Click search button to searching the data...</i></b></td> 
                                                                                                                            </tr>    
                                                                                                                            <%}%>
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

