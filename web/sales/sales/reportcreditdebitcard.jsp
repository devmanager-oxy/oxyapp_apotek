
<%-- 
    Document   : reportcreditdebitcard
    Created on : Jun 13, 2013, 3:07:57 PM
    Author     : Roy Andika
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
            
            if(session.getValue("REPORT_SALES_CB_CARD")!=null){
		session.removeValue("REPORT_SALES_CB_CARD");
            }  
                           
            String strdate1 = JSPRequestValue.requestString(request, "invStartDate");
            String strdate2 = JSPRequestValue.requestString(request, "invEndDate");                           
            Date invStartDate = (JSPRequestValue.requestString(request, "invStartDate") == null) ? new Date() : JSPFormater.formatDate(strdate1, "dd/MM/yyyy");
            Date invEndDate = (JSPRequestValue.requestString(request, "invEndDate") == null) ? new Date() : JSPFormater.formatDate(strdate2, "dd/MM/yyyy");            
            long locationId = JSPRequestValue.requestLong(request, "src_location_id");
            long typePayment = JSPRequestValue.requestLong(request, "type_payment");
            int iJSPCommand = JSPRequestValue.requestCommand(request);
          
            Vector result = new Vector();              
                                
            if(iJSPCommand == JSPCommand.SEARCH){
                ReportParameter rp = new ReportParameter();
                rp.setLocationId(locationId);
                rp.setDateFrom(invStartDate);
                rp.setDateTo(invEndDate);
                
                session.putValue("REPORT_SALES_CB_CARD", rp);                
                try{                                                                                                                                                               
                    result = SessReportSales.listSalesReportByCategory(invStartDate, invEndDate,locationId,groupId,vendorId);                                                                                                                                             
                }catch(Exception e){}
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
            
            function cmdPrintJournal(){	                       
                window.open("<%=printroot%>.report.RptSalesCategoryPDF?user_id=<%=appSessUser.getUserOID()%>&lang=<%=lang%>","",'scrollbars=yes,status=yes,width=750,height=600,resizable=yes');
            }
            
            function cmdPrintJournalXls(){	                       
                window.open("<%=printroot%>.report.RptSalesCategoryXLS?user_id=<%=appSessUser.getUserOID()%>&lang=<%=lang%>","",'scrollbars=yes,status=yes,width=750,height=600,resizable=yes');
            }
            
            function cmdSearch(){
                document.frmsalescategory.command.value="<%=JSPCommand.SEARCH%>";
                document.frmsalescategory.action="rptsalesbycategory.jsp?menu_idx=<%=menuIdx%>";
                document.frmsalescategory.submit();
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
                                                                                                        <form name="frmsalescategory" method ="post" action="">
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
                                                                                                                                <span class="lvl2">Report By Category<br></span></font></b></td>
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
                                                                                                                                            <td width="8%" height="14" nowrap>&nbsp;</td>
                                                                                                                                            <td colspan="2" height="14">&nbsp;</td>
                                                                                                                                        </tr>
                                                                                                                                        <tr> 
                                                                                                                                            <td width="10%" height="14">Date Between</td>
                                                                                                                                            <td colspan="3">
                                                                                                                                                <table cellpadding="0" cellspacing="0">
                                                                                                                                                    <tr>
                                                                                                                                                        <td > 
                                                                                                                                                            <input name="invStartDate" value="<%=JSPFormater.formatDate((invStartDate == null) ? new Date() : invStartDate, "dd/MM/yyyy")%>" size="11" style="text-align:center" readOnly>
                                                                                                                                                        </td>
                                                                                                                                                        <td>
                                                                                                                                                            <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmsalescategory.invStartDate);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt="visit date"></a> 
                                                                                                                                                        </td>
                                                                                                                                                        <td>&nbsp;&nbsp;and&nbsp;&nbsp;</td>
                                                                                                                                                        <td>
                                                                                                                                                            <input name="invEndDate" value="<%=JSPFormater.formatDate((invEndDate == null) ? new Date() : invEndDate, "dd/MM/yyyy")%>" size="11" style="text-align:center" readOnly>
                                                                                                                                                        </td>
                                                                                                                                                        <td>
                                                                                                                                                            <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmsalescategory.invEndDate);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt="visit date"></a> 
                                                                                                                                                        </td>                                                                                                                                                        
                                                                                                                                                    </tr>
                                                                                                                                                </table>
                                                                                                                                            </td>
                                                                                                                                        </tr>                                                                                                                                        
                                                                                                                                        <tr> 
                                                                                                                                            <td width="8%" height="14">Location</td>
                                                                                                                                            <td width="38%" height="14"> 
                                                                                                                                                <%
            Vector vLoc = DbLocation.list(0, 0, "", "name");
                                                                                                                                                %>
                                                                                                                                                <select name="src_location_id">                                                                                                                                                    
                                                                                                                                                    <%if (vLoc != null && vLoc.size() > 0) {
                for (int i = 0; i < vLoc.size(); i++) {
                    Location us = (Location) vLoc.get(i);
                                                                                                                                                    %>
                                                                                                                                                    <option value="<%=us.getOID()%>" <%if (us.getOID() == locationId) {%>selected<%}%>><%=us.getName().toUpperCase()%></option>
                                                                                                                                                    <%}
            }%>
                                                                                                                                                </select>
                                                                                                                                            </td>
                                                                                                                                            <td width="54%" height="14">&nbsp;</td>
                                                                                                                                        </tr>
                                                                                                                                        <tr> 
                                                                                                                                            <td width="8%" height="14">Category</td>
                                                                                                                                            <td width="38%" height="14"> 
                                                                                                                                                <%
            Vector vCategory = DbItemGroup.list(0, 0, "", ""+DbItemGroup.colNames[DbItemGroup.COL_NAME]);
                                                                                                                                                %>
                                                                                                                                                <select name="src_category_id">    
                                                                                                                                                    <option value="0">--All --</option>
                                                                                                                                                    <%if (vCategory != null && vCategory.size() > 0) {
                for (int i = 0; i < vCategory.size(); i++) {
                    ItemGroup ic = (ItemGroup) vCategory.get(i);
                                                                                                                                                    %>
                                                                                                                                                    <option value="<%=ic.getOID()%>" <%if (ic.getOID() == groupId) {%>selected<%}%>><%=ic.getName().toUpperCase()%></option>
                                                                                                                                                    <%}
            }%>
                                                                                                                                                </select>
                                                                                                                                            </td>
                                                                                                                                            <td width="54%" height="14">&nbsp;</td>
                                                                                                                                        </tr>
                                                                                                                                         <tr> 
                                                                                                                                            <td width="8%" height="14">Suplier</td>
                                                                                                                                            <td width="38%" height="14"> 
                                                                                                                                                <%
            Vector vVendor = DbVendor.list(0, 0, "", ""+DbVendor.colNames[DbVendor.COL_NAME]);
                                                                                                                                                %>
                                                                                                                                                <select name="src_vendor_id">    
                                                                                                                                                    <option value="0">--All --</option>
                                                                                                                                                    <%if (vVendor != null && vVendor.size() > 0) {
                for (int i = 0; i < vVendor.size(); i++) {
                    Vendor vnd = (Vendor) vVendor.get(i);
                                                                                                                                                    %>
                                                                                                                                                    <option value="<%=vnd.getOID()%>" <%if (vnd.getOID() == vendorId) {%>selected<%}%>><%=vnd.getName().toUpperCase()%></option>
                                                                                                                                                    <%}
            }%>
                                                                                                                                                </select>
                                                                                                                                            </td>
                                                                                                                                            <td width="54%" height="14">&nbsp;</td>
                                                                                                                                        </tr>
                                                                                                                                        <tr> 
                                                                                                                                            <td width="8%" height="33">&nbsp;</td>
                                                                                                                                            <td width="38%" height="33"><a href="javascript:cmdSearch()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new2','','../images/search2.gif',1)"><img src="../images/search.gif" name="new2" border="0"></a></td>
                                                                                                                                            <td width="54%" height="33">&nbsp;</td>
                                                                                                                                        </tr>
                                                                                                                                        <tr> 
                                                                                                                                            <td width="8%" height="15">&nbsp;</td>
                                                                                                                                            <td width="38%" height="15">&nbsp;</td>
                                                                                                                                            <td width="54%" height="15">&nbsp;</td>
                                                                                                                                        </tr>
                                                                                                                                    </table>
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                            <%
            try {
                if (result != null && result.size() >0 ){
                    long itemCategoryId = 0;
                    double jum = 0;
                    double prc = 0;
                    
                    double gJum = 0;
                    double gPrc = 0;
%>
                                                                                                                            <tr align="left" valign="top"> 
                                                                                                                                <td height="22" valign="middle" colspan="4"> 
                                                                                                                                    <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                                                                                        <tr height="20"> 
                                                                                                                                            <td class="tablehdr"width="5%" >CODE</td>
                                                                                                                                            <td class="tablehdr" width="10%">CATEGORY</td>
                                                                                                                                            <td class="tablehdr" width="10%">SKU</td>
                                                                                                                                            <td class="tablehdr" width="18%">ITEM NAME</td>
                                                                                                                                            <td class="tablehdr" width="17%">VENDOR</td>
                                                                                                                                            <td class="tablehdr" width="10%">QTY</td>
                                                                                                                                            <td class="tablehdr" width="10%">PRICE</td>
                                                                                                                                            <td class="tablehdr" width="10%">TOTAL</td>                                                                                                                                            
                                                                                                                                            <td class="tablehdr" width="10%">TOTAL</td>                                                                                                                                            
                                                                                                                                        </tr>   
                                                                                                                                        <%
                                                                                                                                        for(int i = 0 ; i < result.size() ; i++){ 
                                                                                                                                            
                                                                                                                                         RptSalesCategory rsc = (RptSalesCategory)result.get(i);
                                                                                                                                         double jumlah = rsc.getJumlah();      
                                                                                                                                         double total = jumlah * rsc.getSelling();                                                                                                                                         
                                                                                                                                         
                                                                                                                                        %>
                                                                                                                                        <%if(itemCategoryId != rsc.getCategoriId() && itemCategoryId != 0){%> 
                                                                                                                                        <tr height="20"> 
                                                                                                                                            <td class="tablecell1" align="center" colspan="5">&nbsp;</td>
                                                                                                                                            <td class="tablecell1" align="center" ><%=JSPFormater.formatNumber(jum,"#,###")%></td>
                                                                                                                                            <td class="tablecell1" align="center" colspan="2">&nbsp;</td>
                                                                                                                                            <td class="tablecell1" align="center">
                                                                                                                                                <table width="100%" cellpadding="0" cellspacing="0">
                                                                                                                                                    <tr>
                                                                                                                                                        <td align="left" width="50%">Rp.<td>
                                                                                                                                                        <td align="right" width="50%"><%=JSPFormater.formatNumber(prc,"#,###")%><td>
                                                                                                                                                    </tr>         
                                                                                                                                                </table>    
                                                                                                                                            </td>
                                                                                                                                        </tr>                                                                                                                                        
                                                                                                                                        <%
                                                                                                                                        jum = 0;
                                                                                                                                        prc = 0;
                                                                                                                                        }
                                                                                                                                         jum = jum + jumlah;
                                                                                                                                         prc = prc + total;
                                                                                                                                         gJum = gJum + jumlah;
                                                                                                                                         gPrc = gPrc + total;
                                                                                                                                         String vendor = "-";
                                                                                                                                         if(rsc.getVendor() != null && rsc.getVendor().length() > 0){
                                                                                                                                             vendor = rsc.getVendor();
                                                                                                                                         }
                                                                                                                                        %>
                                                                                                                                        <tr height="20"> 
                                                                                                                                            <td class="tablecell" align="center">
                                                                                                                                                <%if(itemCategoryId != rsc.getCategoriId()){%>
                                                                                                                                                <%=rsc.getCode()%>
                                                                                                                                                <%}%>
                                                                                                                                            </td>
                                                                                                                                            <td class="tablecell">
                                                                                                                                                <%if(itemCategoryId != rsc.getCategoriId()){%>
                                                                                                                                                <%=rsc.getCategory() %>
                                                                                                                                                <%}%>
                                                                                                                                                </td>
                                                                                                                                            <td class="tablecell" align="center"><%=rsc.getSku()%></td>
                                                                                                                                            <td class="tablecell"><%=rsc.getName()%></td>
                                                                                                                                            <td class="tablecell"><%=vendor%></td>
                                                                                                                                            <td class="tablecell" align="center"><%=JSPFormater.formatNumber(jumlah,"#,###")%></td>
                                                                                                                                            <td class="tablecell" align="right"><%=JSPFormater.formatNumber(rsc.getSelling(),"#,###")%></td>
                                                                                                                                            <td class="tablecell" align="right"><%=JSPFormater.formatNumber(total,"#,###")%></td>
                                                                                                                                            <td class="tablecell" align="right">&nbsp;</td>
                                                                                                                                        </tr>                                                                                                                                        
                                                                                                                                        <%
                                                                                                                                        itemCategoryId = rsc.getCategoriId();
                                                                                                                                        }
                                                                                                                                        %>
                                                                                                                                        <tr height="20"> 
                                                                                                                                            <td class="tablecell1" align="center" colspan="5">&nbsp;</td>
                                                                                                                                            <td class="tablecell1" align="center" ><%=JSPFormater.formatNumber(jum,"#,###")%></td>
                                                                                                                                            <td class="tablecell1" align="center" colspan="2">&nbsp;</td>
                                                                                                                                            <td class="tablecell1" align="center">
                                                                                                                                                <table width="100%" cellpadding="0" cellspacing="0">
                                                                                                                                                    <tr>
                                                                                                                                                        <td align="left" width="50%">Rp.<td>
                                                                                                                                                        <td align="right" width="50%"><%=JSPFormater.formatNumber(prc,"#,###")%><td>
                                                                                                                                                    </tr>         
                                                                                                                                                </table>    
                                                                                                                                            </td>
                                                                                                                                        </tr> 
                                                                                                                                        <tr height="10"> 
                                                                                                                                            <td align="center" colspan="9">&nbsp;</td>
                                                                                                                                        </tr> 
                                                                                                                                        <tr height="20"> 
                                                                                                                                            <td class="tablecell1" align="center" colspan="5" align="center"><B>GRAND TOTAL</B></td>
                                                                                                                                            <td class="tablecell1" align="center" ><%=JSPFormater.formatNumber(gJum,"#,###")%></td>
                                                                                                                                            <td class="tablecell1" align="center" colspan="2">&nbsp;</td>
                                                                                                                                            <td class="tablecell1" align="center">
                                                                                                                                                <table width="100%" cellpadding="0" cellspacing="0">
                                                                                                                                                    <tr>
                                                                                                                                                        <td align="left" width="50%">Rp.<td>
                                                                                                                                                        <td align="right" width="50%"><%=JSPFormater.formatNumber(gPrc,"#,###")%><td>
                                                                                                                                                    </tr>         
                                                                                                                                                </table>    
                                                                                                                                            </td>
                                                                                                                                        </tr> 
                                                                                                                                    </table>
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                            <tr align="left" valign="top"> 
                                                                                                                                <td height="22" valign="middle" colspan="4"> 
                                                                                                                                    <a href="javascript:cmdPrintJournal()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('print','','../images/print2.gif',1)"><img src="../images/print.gif" name="print" width="53" height="22" border="0"></a>
                                                                                                                                    &nbsp;&nbsp;
                                                                                                                                    <a href="javascript:cmdPrintJournalXls()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('print1','','../images/printxls2.gif',1)"><img src="../images/printxls.gif" name="print1" height="22" border="0"></a>
                                                                                                                                </td>     
                                                                                                                            </tr>    
                                                                                                                            <%  } 
            } catch (Exception exc) {
            }%>                                                                                                             
                                                                                                                        </table>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                                <tr align="left" valign="top"> 
                                                                                                                    <td height="8" valign="middle" colspan="3">
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
