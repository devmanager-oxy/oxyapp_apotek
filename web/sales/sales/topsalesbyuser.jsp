
<%-- 
    Document   : topsalesbyuser
    Created on : Jun 3, 2014, 7:43:22 AM
    Author     : Roy Andika
--%>


<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.admin.*" %>
<%@ page import = "com.project.ccs.postransaction.sales.*" %>
<%@ page import = "com.project.ccs.sql.*" %>
<%@ page import = "com.project.ccs.session.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "com.project.ccs.posmaster.Shift" %>
<%@ page import = "com.project.ccs.posmaster.ItemGroup" %>
<%@ page import = "java.sql.ResultSet" %>
<%@ include file = "../main/javainit.jsp" %>
<%@ include file = "../main/checksl.jsp" %>
<%@ include file="../calendar/calendarframe.jsp"%>
<%
            boolean priv = true;
            boolean privAdd = true;
            boolean privUpdate = true;
            boolean privDelete = true;
            boolean privPrint = true;
%>
<!-- Jsp Block -->
<%
            if (session.getValue("REPORT_TOP_USER_SALES") != null) {
                session.removeValue("REPORT_TOP_USER_SALES");
            }

            Date tanggal = JSPFormater.formatDate(JSPRequestValue.requestString(request, "invStartDate"), "dd/MM/yyyy");
            Date tanggalEnd = JSPFormater.formatDate(JSPRequestValue.requestString(request, "invEndDate"), "dd/MM/yyyy");
            long locationId = JSPRequestValue.requestLong(request, "src_location_id");
            long employeeId = JSPRequestValue.requestLong(request, "select_employee");
            long produkId = JSPRequestValue.requestLong(request, "produk_id");
            String produkName = JSPRequestValue.requestString(request, "produk_name");

            int iJSPCommand = JSPRequestValue.requestCommand(request);
            int start = JSPRequestValue.requestInt(request, "start");
            int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");

            if (tanggal == null) {
                tanggal = new Date();
            }

            if (tanggalEnd == null) {
                tanggalEnd = new Date();
            }


            Vector vEmployee = new Vector();
            vEmployee = DbEmployee.list(0, 0, "", DbEmployee.colNames[DbEmployee.COL_NAME]);
%>
<html >
    <!-- #BeginTemplate "/Templates/indexsl.dwt" --> 
    <head>
        <!-- #BeginEditable "javascript" --> 
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <title><%=salesSt%></title>
        <link href="../css/csssl.css" rel="stylesheet" type="text/css" />
        <script language="JavaScript">
            
            function cmdPrintXLS(){	 
                window.open("<%=printroot%>.report.ReportTopUserXLS?idx=<%=System.currentTimeMillis()%>");
                }                
                
                function cmdAddItemMaster(){  
                    var itemName =document.frmsales.produk_name.value;                                
                    window.open("itemproduk.jsp?item_name=" + itemName, null, "height=1000,width=1200, status=yes,toolbar=no,menubar=no,location=no, scrollbars=yes");
                    document.frmsales.command.value="<%=JSPCommand.SUBMIT%>";
                    document.frmsales.submit();    
                }
                
                function cmdSearch(){
                    document.frmsales.command.value="<%=JSPCommand.SUBMIT%>";
                    document.frmsales.action="topsalesbyuser.jsp?menu_idx=<%=menuIdx%>";
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
                                                                                                                                <td width="60%" height="23"><b><font color="#990000" class="lvl1">Sales 
                                                                                                                                        </font><font class="tit1">&raquo; 
                                                                                                                                            <span class="lvl2">Top User Sales Report<br>
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
                                                                                                                                            <td width="10%" height="14" nowrap>&nbsp;</td>
                                                                                                                                            <td colspan="3" height="14">&nbsp;</td>
                                                                                                                                        </tr>
                                                                                                                                        <tr> 
                                                                                                                                            <td colspan="4">
                                                                                                                                                <table border="0" cellpadding="1" cellspacing="1" width="700">                                                                                                                                        
                                                                                                                                                    <tr>                                                                                                                                            
                                                                                                                                                        <td class="tablecell1" >                                                                                                                                                
                                                                                                                                                            <table width="100%" border="0" cellspacing="1" cellpadding="1" style="border:1px solid #ABA8A8">
                                                                                                                                                                <tr>
                                                                                                                                                                    <td height="10" colspan="5"></td>
                                                                                                                                                                </tr>    
                                                                                                                                                                <tr>
                                                                                                                                                                    <td width="5"></td>
                                                                                                                                                                    <td width="90" height="14" nowrap class="fontarial">Employee</td>
                                                                                                                                                                    <td >&nbsp;<select name="select_employee" class="fontarial">
                                                                                                                                                                            <option value="0" selected>- All employee -</option>
                                                                                                                                                                            <%if (vEmployee != null && vEmployee.size() > 0) {
                for (int i = 0; i < vEmployee.size(); i++) {
                    Employee e = (Employee) vEmployee.get(i);
                                                                                                                                                                            %>
                                                                                                                                                                            <option value="<%=e.getOID()%>"  <%if (employeeId == e.getOID()) {%> selected <%}%> ><%=e.getName()%></option>
                                                                                                                                                                            <%}
            }%>
                                                                                                                                                                        </select>
                                                                                                                                                                    </td>
                                                                                                                                                                    <td width="70" class="fontarial">Period</td>
                                                                                                                                                                    <td width="250">
                                                                                                                                                                        <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                                                                            <tr>
                                                                                                                                                                                <td>
                                                                                                                                                                                    <input name="invStartDate" value="<%=JSPFormater.formatDate((tanggal == null) ? new Date() : tanggal, "dd/MM/yyyy")%>" size="11" style="text-align:center" readOnly>
                                                                                                                                                                                </td>
                                                                                                                                                                                <td>
                                                                                                                                                                                    <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmsales.invStartDate);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt="Start date"></a> 
                                                                                                                                                                                </td>
                                                                                                                                                                                <td>&nbsp;&nbsp;to&nbsp;&nbsp;
                                                                                                                                                                                </td>
                                                                                                                                                                                <td>
                                                                                                                                                                                    <input name="invEndDate" value="<%=JSPFormater.formatDate((tanggalEnd == null) ? new Date() : tanggalEnd, "dd/MM/yyyy")%>" size="11" style="text-align:center" readOnly>
                                                                                                                                                                                </td>
                                                                                                                                                                                <td>
                                                                                                                                                                                    <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmsales.invEndDate);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt="End date"></a>
                                                                                                                                                                                </td>
                                                                                                                                                                            </tr>
                                                                                                                                                                        </table>
                                                                                                                                                                        
                                                                                                                                                                    </td>
                                                                                                                                                                </tr>  
                                                                                                                                                                <tr>
                                                                                                                                                                    <td ></td>
                                                                                                                                                                    <td  nowrap class="fontarial">Produk Name</td>
                                                                                                                                                                    <td align="left"> 
                                                                                                                                                                        <table border="0" >
                                                                                                                                                                            <tr>
                                                                                                                                                                                <td>                                                                                                                                                                                                                                                                                                                                                               
                                                                                                                                                                                    <input type="text" name="produk_name" value = "<%=produkName%>" readonly class="readOnly">
                                                                                                                                                                                    <input type="hidden" name="produk_id" value="<%=produkId %>">     
                                                                                                                                                                                </td>
                                                                                                                                                                                <td><a href="javascript:cmdAddItemMaster()" height="20" border="0" style="padding:0px"> Search</a></td>
                                                                                                                                                                            </tr>
                                                                                                                                                                        </table>
                                                                                                                                                                    </td>
                                                                                                                                                                    <td class="fontarial">Location</td>  
                                                                                                                                                                    <td >
                                                                                                                                                                        <%
            Vector vLoc = DbLocation.list(0, 0, "", DbLocation.colNames[DbLocation.COL_NAME]);
                                                                                                                                                                        %>
                                                                                                                                                                        <select name="src_location_id" class="fontarial">
                                                                                                                                                                            <option value="0">- All Location -</option>
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
                                                                                                                                                                <tr>
                                                                                                                                                                    <td height="10" colspan="5"></td>
                                                                                                                                                                </tr> 
                                                                                                                                                            </table> 
                                                                                                                                                        </td>
                                                                                                                                                    </tr>                                                                                                                                                    
                                                                                                                                                </table> 
                                                                                                                                            </td>
                                                                                                                                        </tr>                                                                                                                                       
                                                                                                                                        <tr> 
                                                                                                                                            <td colspan="4">&nbsp;<a href="javascript:cmdSearch()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new2','','../images/search2.gif',1)"><img src="../images/search.gif" name="new2" border="0"></a></td>                                                                                                                                            
                                                                                                                                        </tr>
                                                                                                                                        <tr> 
                                                                                                                                            <td colspan="4" height="15"></td>                                                                                                                                          
                                                                                                                                        </tr>
                                                                                                                                        <%if (produkId == 0 && iJSPCommand == JSPCommand.SUBMIT) {%>
                                                                                                                                        <tr> 
                                                                                                                                            <td colspan="4" height="15"><font color="#FF0000" face="arial"><i><b>Product Name can't empty</b></i></font></td>                                                                                                                                          
                                                                                                                                        </tr> 
                                                                                                                                        <%
} else {
    if (iJSPCommand == JSPCommand.SUBMIT) {
        Vector resultXLS = new Vector();
        ParameterTopSales pts = new ParameterTopSales();
        pts.setStartDate(tanggal);
        pts.setEndDate(tanggalEnd);
        pts.setLocationid(locationId);
        pts.setEmployeeId(employeeId);
        pts.setPrdukName(produkName);
                                                                                                                                        %>
                                                                                                                                        <tr>
                                                                                                                                            <td>
                                                                                                                                                <table border="0" cellpadding="0" cellspacing="1" width="900">
                                                                                                                                                    <tr height="26">
                                                                                                                                                        <td class="tablehdr" width="25"><font face="arial">No</font></td>
                                                                                                                                                        <td class="tablehdr" width="200"><font face="arial">Employee</font></td>
                                                                                                                                                        <td class="tablehdr" width="120"><font face="arial">Code</font></td>
                                                                                                                                                        <td class="tablehdr"><font face="arial">Product Name</font></td>
                                                                                                                                                        <td class="tablehdr" width="50"><font face="arial">Unit</font></td>
                                                                                                                                                        <td class="tablehdr" width="100"><font face="arial">Qty</font></td>
                                                                                                                                                        <td class="tablehdr" width="100"><font face="arial">Selling Price</font></td>
                                                                                                                                                    </tr>   
                                                                                                                                                    <%
                                                                                                                                                try {
                                                                                                                                                    CONResultSet dbrs = null;

                                                                                                                                                    String sql = "select s.date,s.user_id,e.name as name,m.code as code,m.name as item_name,u.unit as unit,sum(sd.qty) as tot,sd.selling_price as selling_price from pos_sales s inner join pos_sales_detail sd on s.sales_id = sd.sales_id inner join pos_item_master m on  m.item_master_id = sd.product_master_id inner join sysuser sys on sys.user_id = s.user_id inner join employee e on e.employee_id = sys.employee_id inner join pos_unit u on u.uom_id = m.uom_sales_id " +
                                                                                                                                                            " where to_days(s.date) >= to_days('" + JSPFormater.formatDate(tanggal, "yyyy-MM-dd") + "') and to_days(s.date) <= to_days('" + JSPFormater.formatDate(tanggalEnd, "yyyy-MM-dd") + "') and sd.product_master_id = " + produkId;

                                                                                                                                                    if (locationId != 0) {
                                                                                                                                                        sql = sql + " and s.location_id = " + locationId;
                                                                                                                                                    }

                                                                                                                                                    if (employeeId != 0) {
                                                                                                                                                        sql = sql + " and e.employee_id = " + employeeId;
                                                                                                                                                    }

                                                                                                                                                    sql = sql + " group by user_id order by tot desc";


                                                                                                                                                    dbrs = CONHandler.execQueryResult(sql);
                                                                                                                                                    ResultSet rs = dbrs.getResultSet();

                                                                                                                                                    int nomor = 1;
                                                                                                                                                    String style = "";

                                                                                                                                                    double total = 0;
                                                                                                                                                    double totalPrice = 0;

                                                                                                                                                    while (rs.next()) {

                                                                                                                                                        String employee = rs.getString("name");
                                                                                                                                                        String code = rs.getString("code");
                                                                                                                                                        String itemName = rs.getString("item_name");
                                                                                                                                                        String unit = rs.getString("unit");
                                                                                                                                                        double tot = rs.getDouble("tot");
                                                                                                                                                        double price = rs.getDouble("selling_price");
                                                                                                                                                        total = total + tot;

                                                                                                                                                        RptTopProduk rtp = new RptTopProduk();
                                                                                                                                                        rtp.setEmployee(employee);
                                                                                                                                                        rtp.setCode(code);
                                                                                                                                                        rtp.setProductName(itemName);
                                                                                                                                                        rtp.setUnit(unit);
                                                                                                                                                        rtp.setQty(tot);
                                                                                                                                                        rtp.setSellingPrice(price);
                                                                                                                                                        resultXLS.add(rtp);
                                                                                                                                                        totalPrice = totalPrice + (tot * price);

                                                                                                                                                        if (nomor % 2 == 0) {
                                                                                                                                                            style = "tablecell1";
                                                                                                                                                        } else {
                                                                                                                                                            style = "tablecell";
                                                                                                                                                        }

                                                                                                                                                    %>
                                                                                                                                                    <tr height="22">
                                                                                                                                                        <td class="<%=style%>" align="center"><font face="arial"><%=nomor%>.</font></td>
                                                                                                                                                        <td class="<%=style%>">&nbsp;<font face="arial"><%=employee %></font></td>
                                                                                                                                                        <td class="<%=style%>" align="center"><font face="arial"><%=code%></font></td>
                                                                                                                                                        <td class="<%=style%>">&nbsp;<font face="arial"><%=itemName%></font></td>
                                                                                                                                                        <td class="<%=style%>" align="center"><font face="arial"><%=unit%></font></td>
                                                                                                                                                        <td class="<%=style%>" align="right"><font face="arial"><%=tot%>&nbsp;</font></td>
                                                                                                                                                        <td class="<%=style%>" align="right"><font face="arial"><%=JSPFormater.formatNumber(price, "###,###.##")%>&nbsp;</font></td>
                                                                                                                                                    </tr> 
                                                                                                                                                    <%
                                                                                                                                                            nomor++;
                                                                                                                                                        }
                                                                                                                                                        if (nomor > 1) {
                                                                                                                                                            Vector result = new Vector();
                                                                                                                                                            result.add(pts);
                                                                                                                                                            result.add(resultXLS);
                                                                                                                                                            session.putValue("REPORT_TOP_USER_SALES", result);
                                                                                                                                                    %>
                                                                                                                                                    <tr height="22">
                                                                                                                                                        <td class="tablecell1" colspan="5" align="center">&nbsp;<font face="arial"><b>T O T A L</b></font></td>
                                                                                                                                                        <td class="tablecell1" align="right">&nbsp;<font face="arial"><%=total%></font></td>
                                                                                                                                                        <td class="tablecell1" align="center">&nbsp;</td>                                                                                                                                            
                                                                                                                                                    </tr>
                                                                                                                                                    <tr height="22">
                                                                                                                                                        <td colspan="7" align="left">&nbsp;</td>                                                                                                                                            
                                                                                                                                                    </tr>
                                                                                                                                                    <%if (privPrint) {%>
                                                                                                                                                    <tr height="22">
                                                                                                                                                        <td colspan="7" align="left">
                                                                                                                                                            <a href="javascript:cmdPrintXLS()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('print2','','../images/printxls2.gif',1)"><img src="../images/printxls.gif" name="print2" height="22" border="0"></a>
                                                                                                                                                        </td>
                                                                                                                                                    </tr>
                                                                                                                                                    <%}%>
                                                                                                                                                    <%
                                                                                                                                                } else {%>
                                                                                                                                                    <tr height="22">
                                                                                                                                                        <td class="tablecell1" colspan="7" >&nbsp;<font face="arial"><i>data not found..</i></font></td>                                                                                                                                            
                                                                                                                                                    </tr> 
                                                                                                                                                    <%}
                                                                                                                                                } catch (Exception e) {
                                                                                                                                                }
                                                                                                                                                    
                                                                                                                                                    %>                                                                                                                                        
                                                                                                                                                    
                                                                                                                                                            
                                                                                                                                                </table>
                                                                                                                                            </td>
                                                                                                                                        </tr>                                                                                                                                        
                                                                                                                                        <%} else {%>
                                                                                                                                        <tr>
                                                                                                                                            <td height="15" colspan="4"><i>klik search button to seaching the data</i></td>
                                                                                                                                        </tr>
                                                                                                                                        <%}%>
                                                                                                                                        <%}%>
                                                                                                                                        <tr>
                                                                                                                                            <td height="15">&nbsp;</td>
                                                                                                                                            <td height="15">&nbsp;</td>
                                                                                                                                            <td height="15">&nbsp;</td>
                                                                                                                                            <td height="15">&nbsp;</td>
                                                                                                                                        </tr>                                                                                                                                                                                                                                                                              
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

