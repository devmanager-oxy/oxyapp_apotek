
<%-- 
    Document   : rptsalesbycategory
    Created on : Jan 8, 2013, 4:12:09 PM
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
            boolean privAdd = true;
            boolean privUpdate = true;
            boolean privDelete = true;
            boolean privView = true;
            boolean privPrint = true;
%>
<!-- Jsp Block -->
<%

            if (session.getValue("REPORT_SALES_CATEGORY") != null) {
                session.removeValue("REPORT_SALES_CATEGORY");
            }

            String strdate1 = JSPRequestValue.requestString(request, "invStartDate");
            String strdate2 = JSPRequestValue.requestString(request, "invEndDate");
            Date invStartDate = (JSPRequestValue.requestString(request, "invStartDate") == null) ? new Date() : JSPFormater.formatDate(strdate1, "dd/MM/yyyy");
            Date invEndDate = (JSPRequestValue.requestString(request, "invEndDate") == null) ? new Date() : JSPFormater.formatDate(strdate2, "dd/MM/yyyy");
            int chkInvDate = 0;
            long locationId = JSPRequestValue.requestLong(request, "src_location_id");
            long vendorId = JSPRequestValue.requestLong(request, "src_vendor_id");
            long groupId = JSPRequestValue.requestLong(request, "src_category_id");

            int iJSPCommand = JSPRequestValue.requestCommand(request);
            int start = JSPRequestValue.requestInt(request, "start");
            int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
            int typeSub = JSPRequestValue.requestInt(request, "type_sub");

            Vector result = new Vector();

            if (iJSPCommand == JSPCommand.SEARCH) {
                ReportParameter rp = new ReportParameter();
                rp.setLocationId(locationId);
                rp.setDateFrom(invStartDate);
                rp.setDateTo(invEndDate);
                rp.setIgnore(chkInvDate);
                rp.setCategoryId(groupId);
                rp.setVendorId(vendorId);

                session.putValue("REPORT_SALES_CATEGORY", rp);
                try {
                    result = SessReportSales.listSalesReportBySubCategory(invStartDate, invEndDate, locationId, groupId, vendorId);
                } catch (Exception e) {
                }
            }
            
            Vector subcategorys = DbItemCategory.list(0, 0, "", DbItemCategory.colNames[DbItemCategory.COL_NAME]);
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
                window.open("<%=printroot%>.report.RptSalesCategoryPDF?user_id=<%=appSessUser.getUserOID()%>&lang=<%=lang%>&type_sub=<%=typeSub%>","",'scrollbars=yes,status=yes,width=750,height=600,resizable=yes');
                }
                
                function cmdPrintJournalXls(){	                       
                    window.open("<%=printroot%>.report.RptSalesCategoryXLS?user_id=<%=appSessUser.getUserOID()%>&lang=<%=lang%>&type_sub=<%=typeSub%>","",'scrollbars=yes,status=yes,width=750,height=600,resizable=yes');
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
                                                                                                                                    <span class="lvl2">Report By Category<br></span></font></b>
                                                                                                                                </td>
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
                                                                                                                                    <table border="0" cellspacing="1" cellpadding="1" >
                                                                                                                                        <tr> 
                                                                                                                                            <td height="5" nowrap>&nbsp;</td>
                                                                                                                                            <td height="14" nowrap>&nbsp;</td>
                                                                                                                                            <td height="14">&nbsp;</td>
                                                                                                                                        </tr>
                                                                                                                                        <tr height="23"> 
                                                                                                                                            <td width="120"  class="tablearialcell" >&nbsp;&nbsp;Date Between</td>
                                                                                                                                            <td height="5" class="fontarial" nowrap>:</td>
                                                                                                                                            <td >
                                                                                                                                                <table cellpadding="0" cellspacing="0">
                                                                                                                                                    <tr>
                                                                                                                                                        <td > 
                                                                                                                                                            <input name="invStartDate" value="<%=JSPFormater.formatDate((invStartDate == null) ? new Date() : invStartDate, "dd/MM/yyyy")%>" size="11" style="text-align:center" readOnly>
                                                                                                                                                        </td>
                                                                                                                                                        <td>
                                                                                                                                                            <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmsalescategory.invStartDate);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt="visit date"></a> 
                                                                                                                                                        </td>
                                                                                                                                                        <td class="fontarial">&nbsp;&nbsp;and&nbsp;&nbsp;</td>
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
                                                                                                                                        <tr height="23">
                                                                                                                                            <td height="14" class="tablearialcell" >&nbsp;&nbsp;Location</td>
                                                                                                                                            <td height="14" class="fontarial">:</td>
                                                                                                                                            <td height="14"> 
                                                                                                                                                <%
            Vector vLoc = userLocations;
                                                                                                                                                %>
                                                                                                                                                <select name="src_location_id" class="fontarial">  
                                                                                                                                                    <%if (vLoc.size() == totLocationxAll) {%>
                                                                                                                                                    <option value="0"> - All Location -</option>
                                                                                                                                                    <%}%>
                                                                                                                                                    <%if (vLoc != null && vLoc.size() > 0) {

                for (int i = 0; i < vLoc.size(); i++) {
                    Location us = (Location) vLoc.get(i);
                                                                                                                                                    %>
                                                                                                                                                    <option value="<%=us.getOID()%>" <%if (us.getOID() == locationId) {%>selected<%}%>><%=us.getName().toUpperCase()%></option>
                                                                                                                                                    <%}
            }%>
                                                                                                                                                </select>
                                                                                                                                            </td>
                                                                                                                                        </tr>
                                                                                                                                        <tr height="23"> 
                                                                                                                                            <td class="tablearialcell" >&nbsp;&nbsp;Category</td>
                                                                                                                                            <td class="fontarial" nowrap>:</td>
                                                                                                                                            <td > 
                                                                                                                                                <%
            Vector vCategory = DbItemGroup.list(0, 0, "", "" + DbItemGroup.colNames[DbItemGroup.COL_NAME]);
                                                                                                                                                %>
                                                                                                                                                <select name="src_category_id" class="fontarial">    
                                                                                                                                                    <option value="0">- All Category -</option>
                                                                                                                                                    <%if (vCategory != null && vCategory.size() > 0) {
                for (int i = 0; i < vCategory.size(); i++) {
                    ItemGroup ic = (ItemGroup) vCategory.get(i);
                                                                                                                                                    %>
                                                                                                                                                    <option value="<%=ic.getOID()%>" <%if (ic.getOID() == groupId) {%>selected<%}%>><%=ic.getName()%></option>
                                                                                                                                                    <%}
            }%>
                                                                                                                                                </select>
                                                                                                                                            </td>                                                                                                                                                        
                                                                                                                                        </tr>
                                                                                                                                        <tr height="23"> 
                                                                                                                                            <td class="tablearialcell" >&nbsp;&nbsp;Suplier</td>
                                                                                                                                            <td class="fontarial" nowrap>:</td>
                                                                                                                                            <td > 
                                                                                                                                                <%
            Vector vVendor = DbVendor.list(0, 0, "", "" + DbVendor.colNames[DbVendor.COL_NAME]);
                                                                                                                                                %>
                                                                                                                                                <select name="src_vendor_id" class="fontarial">    
                                                                                                                                                    <option value="0">- All Suplier -</option>
                                                                                                                                                    <%if (vVendor != null && vVendor.size() > 0) {
                for (int i = 0; i < vVendor.size(); i++) {
                    Vendor vnd = (Vendor) vVendor.get(i);
                                                                                                                                                    %>
                                                                                                                                                    <option value="<%=vnd.getOID()%>" <%if (vnd.getOID() == vendorId) {%>selected<%}%>><%=vnd.getName().toUpperCase()%></option>
                                                                                                                                                    <%}
            }%>
                                                                                                                                                </select>
                                                                                                                                            </td>                                                                                                                                                        
                                                                                                                                        </tr>
                                                                                                                                        <tr height="23"> 
                                                                                                                                            <td class="tablearialcell" >&nbsp;&nbsp;Show Sub Category</td>
                                                                                                                                            <td class="fontarial" nowrap>:</td>
                                                                                                                                            <td ><input type="checkbox" name="type_sub" value="1" <%if(typeSub == 1){%> checked<%}%> ></td>                                                                                                                                                        
                                                                                                                                        </tr>
                                                                                                                                    </table>
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                            <tr align="left" valign="top" colspan="4"> 
                                                                                                                                <td >
                                                                                                                                    <table width="80%" border="0" cellspacing="1" cellpadding="1" height="3">
                                                                                                                                        <tr > 
                                                                                                                                            <td height="3" background="<%=approot%>/images/line1.gif" ></td>
                                                                                                                                        </tr>
                                                                                                                                    </table> 
                                                                                                                                </td>
                                                                                                                            </tr> 
                                                                                                                            <tr>
                                                                                                                                <td colspan="4"><a href="javascript:cmdSearch()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new2','','../images/search2.gif',1)"><img src="../images/search.gif" name="new2" border="0"></a></td>
                                                                                                                            </tr>
                                                                                                                            <tr>
                                                                                                                                <td colspan="4">&nbsp;</td>
                                                                                                                            </tr>
                                                                                                                            <%


            try {
                if (result != null && result.size() > 0) {
                    long itemCategoryId = 0;
                    double jum = 0;
                    double prc = 0;

                    double gJum = 0;
                    double gPrc = 0;
                    
                    Hashtable hascategorys = new Hashtable();
                    if(subcategorys != null && subcategorys.size() > 0){
                        for(int x = 0 ; x < subcategorys.size() ; x++){
                            ItemCategory ic = (ItemCategory)subcategorys.get(x);
                            hascategorys.put(""+ic.getOID(),""+ic.getName());
                        }
                    }
                    
                                                                                                                            %>
                                                                                                                            <tr align="left" valign="top"> 
                                                                                                                                <td height="22" valign="middle" colspan="4"> 
                                                                                                                                    <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                                                                                        <tr height="20"> 
                                                                                                                                            <td class="tablearialhdr"width="5%" >CODE</td>
                                                                                                                                            <td class="tablearialhdr" >CATEGORY</td>
                                                                                                                                            <%if(typeSub == 1){%>
                                                                                                                                            <td class="tablearialhdr" width="120">SUB CATEGORY</td>
                                                                                                                                            <%}%>
                                                                                                                                            <td class="tablearialhdr" width="10%">SKU</td>
                                                                                                                                            <td class="tablearialhdr" width="18%">ITEM NAME</td>
                                                                                                                                            <td class="tablearialhdr" width="17%">VENDOR</td>
                                                                                                                                            <td class="tablearialhdr" width="7%">QTY</td>
                                                                                                                                            <td class="tablearialhdr" width="7%">PRICE</td>
                                                                                                                                            <td class="tablearialhdr" width="7%">DISKON</td>
                                                                                                                                            <td class="tablearialhdr" width="9%">TOTAL</td>                                                                                                                                            
                                                                                                                                            <td class="tablearialhdr" width="9%">TOTAL</td>                                                                                                                                            
                                                                                                                                        </tr>   
                                                                                                                                        <%
                                                                                                                                                for (int i = 0; i < result.size(); i++) {

                                                                                                                                                    RptSalesCategory rsc = (RptSalesCategory) result.get(i);
                                                                                                                                                    double jumlah = rsc.getJumlah();
                                                                                                                                                    double total = (jumlah * rsc.getSelling()) - rsc.getDiskon();
                                                                                                                                                    

                                                                                                                                        %>
                                                                                                                                        <%if (itemCategoryId != rsc.getCategoriId() && itemCategoryId != 0) {%> 
                                                                                                                                        <tr height="20"> 
                                                                                                                                            <td class="tablearialcell1" align="center" colspan="5">&nbsp;</td>
                                                                                                                                            <%if(typeSub == 1){%>
                                                                                                                                            <td class="tablearialcell1" align="center" >&nbsp;</td>
                                                                                                                                            <%}%>
                                                                                                                                            <td class="tablearialcell1" align="right" ><%=JSPFormater.formatNumber(jum, "#,###.##")%></td>
                                                                                                                                            <td class="tablearialcell1" align="center" colspan="3">&nbsp;</td>
                                                                                                                                            <td class="tablearialcell1" align="center">
                                                                                                                                                <table width="100%" cellpadding="0" cellspacing="0">
                                                                                                                                                    <tr>
                                                                                                                                                        <td align="left" width="50%">Rp.<td>
                                                                                                                                                        <td align="right" width="50%"><%=JSPFormater.formatNumber(prc, "#,###.##")%><td>
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
                                                                                                                                            if (rsc.getVendor() != null && rsc.getVendor().length() > 0) {
                                                                                                                                                vendor = rsc.getVendor();
                                                                                                                                            }
                                                                                                                                        %>
                                                                                                                                        <tr height="20"> 
                                                                                                                                            <td class="tablearialcell" align="center">
                                                                                                                                                <%if (itemCategoryId != rsc.getCategoriId()) {%>
                                                                                                                                                <%=rsc.getCode()%>
                                                                                                                                                <%}%>
                                                                                                                                            </td>
                                                                                                                                            <td class="tablearialcell">
                                                                                                                                                <%if (itemCategoryId != rsc.getCategoriId()) {%>
                                                                                                                                                <%=rsc.getCategory() %>
                                                                                                                                                <%}%>
                                                                                                                                            </td>
                                                                                                                                            <%
                                                                                                                                            if(typeSub == 1){
                                                                                                                                                String sub = "";
                                                                                                                                                try{
                                                                                                                                                    sub =String.valueOf(hascategorys.get(""+rsc.getSubCategoryId())); 
                                                                                                                                                }catch(Exception e){}
                                                                                                                                            %>
                                                                                                                                            <td class="tablearialcell" align="left"><%=sub%></td>
                                                                                                                                            <%}%>
                                                                                                                                            
                                                                                                                                            <td class="tablearialcell" align="left"><%=rsc.getSku()%></td>
                                                                                                                                            <td class="tablearialcell"><%=rsc.getName()%></td>
                                                                                                                                            <td class="tablearialcell"><%=vendor%></td>
                                                                                                                                            <td class="tablearialcell" align="right"><%=JSPFormater.formatNumber(jumlah, "#,###.###")%></td>
                                                                                                                                            <td class="tablearialcell" align="right"><%=JSPFormater.formatNumber(rsc.getSelling(), "#,###.##")%></td>
                                                                                                                                            <td class="tablearialcell" align="right"><%=JSPFormater.formatNumber(rsc.getDiskon(), "#,###.##")%></td>
                                                                                                                                            <td class="tablearialcell" align="right"><%=JSPFormater.formatNumber(total, "#,###.##")%></td>
                                                                                                                                            <td class="tablearialcell" align="right">&nbsp;</td>
                                                                                                                                        </tr>                                                                                                                                        
                                                                                                                                        <%
                                                                                                                                                    itemCategoryId = rsc.getCategoriId();
                                                                                                                                                }
                                                                                                                                        %>
                                                                                                                                        <tr height="20"> 
                                                                                                                                            <td class="tablearialcell1" align="center" colspan="5">&nbsp;</td>
                                                                                                                                            <%if(typeSub == 1){%>
                                                                                                                                            <td class="tablearialcell1" align="center" >&nbsp;</td>
                                                                                                                                            <%}%>
                                                                                                                                            <td class="tablearialcell1" align="right" ><%=JSPFormater.formatNumber(jum, "#,###.##")%></td>
                                                                                                                                            <td class="tablearialcell1" align="center" colspan="3">&nbsp;</td>
                                                                                                                                            <td class="tablearialcell1" align="center">
                                                                                                                                                <table width="100%" cellpadding="0" cellspacing="0">
                                                                                                                                                    <tr>
                                                                                                                                                        <td align="left" width="50%">Rp.<td>
                                                                                                                                                        <td align="right" width="50%"><%=JSPFormater.formatNumber(prc, "#,###.##")%><td>
                                                                                                                                                    </tr>         
                                                                                                                                                </table>    
                                                                                                                                            </td>
                                                                                                                                        </tr> 
                                                                                                                                        <tr height="10"> 
                                                                                                                                            <td align="center" colspan="9">&nbsp;</td>
                                                                                                                                        </tr> 
                                                                                                                                        <tr height="20"> 
                                                                                                                                            <td class="tablearialcell1" align="center" colspan="5" align="center"><B>GRAND TOTAL</B></td>
                                                                                                                                            <%if(typeSub == 1){%>
                                                                                                                                            <td class="tablearialcell1" align="center" >&nbsp;</td>
                                                                                                                                            <%}%>
                                                                                                                                            <td class="tablearialcell1" align="right" ><%=JSPFormater.formatNumber(gJum, "#,###.##")%></td>
                                                                                                                                            <td class="tablearialcell1" align="center" colspan="3">&nbsp;</td>
                                                                                                                                            <td class="tablearialcell1" align="center">
                                                                                                                                                <table width="100%" cellpadding="0" cellspacing="0">
                                                                                                                                                    <tr>
                                                                                                                                                        <td align="left" width="50%">Rp.<td>
                                                                                                                                                        <td align="right" width="50%"><%=JSPFormater.formatNumber(gPrc, "#,###.##")%><td>
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
                                                                                                                            <%  } else {%>
                                                                                                                            <tr align="left" valign="top">                                                                                                                                 
                                                                                                                                <td height="8" valign="middle" colspan="3" class="fontarial">&nbsp;</td>
                                                                                                                            </tr>    
                                                                                                                            <tr align="left" valign="top"> 
                                                                                                                                <%if (iJSPCommand == JSPCommand.SEARCH) {%>
                                                                                                                                <td height="8" valign="middle" colspan="3" class="fontarial"><i>Data not found..</i></td>
                                                                                                                                <%} else {%>
                                                                                                                                <td height="8" valign="middle" colspan="3" class="fontarial"><i>Click serach buton to seraching the data..</i></td>
                                                                                                                                <%}%>
                                                                                                                            </tr>
                                                                                                                            <%}
            } catch (Exception exc) {
            }%>                                                                                                             
                                                                                                                        </table>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                                <tr align="left" valign="top"> 
                                                                                                                    <td height="8" valign="middle" colspan="3"></td>
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
