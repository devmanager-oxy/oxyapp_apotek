
<%-- 
    Document   : rptvoidsales
    Created on : Aug 14, 2015, 3:28:26 PM
    Author     : Roy
--%>

<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.ResultSet" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.main.db.*" %>
<%@ page import = "com.project.admin.*" %>
<%@ page import = "com.project.ccs.postransaction.sales.*" %>
<%@ page import = "com.project.ccs.sql.*" %>
<%@ page import = "com.project.ccs.session.*" %>
<%@ page import = "com.project.ccs.posmaster.Shift" %>
<%@ page import = "com.project.fms.transaction.DbGl" %>
<%@ page import = "com.project.fms.transaction.Gl" %>
<%@ page import = "com.project.fms.transaction.DbGlDetail" %>
<%@ page import = "com.project.fms.transaction.GlDetail" %>
<%@ page import = "com.project.ccs.posmaster.*" %>
<%@ page import = "com.project.fms.master.*" %>
<%@ include file = "../main/javainit.jsp" %>
<%@ include file = "../main/checksl.jsp" %>
<%@ include file="../calendar/calendarframe.jsp"%>
<%
            boolean priv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_SALES_REPORT, AppMenu.M2_SAL_VOID_REPORT);
            boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_SALES_REPORT, AppMenu.M2_SAL_VOID_REPORT, AppMenu.PRIV_VIEW);
            boolean privPrint = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_SALES_REPORT, AppMenu.M2_SAL_VOID_REPORT, AppMenu.PRIV_PRINT);
%>
<!-- Jsp Block -->
<%
            int iJSPCommand = JSPRequestValue.requestCommand(request);
            int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
            int start = JSPRequestValue.requestInt(request, "start");

            int type = JSPRequestValue.requestInt(request, "src_type");
            Date invStartDate = JSPFormater.formatDate(JSPRequestValue.requestString(request, "invStartDate"), "dd/MM/yyyy");
            Date invEndDate = JSPFormater.formatDate(JSPRequestValue.requestString(request, "invEndDate"), "dd/MM/yyyy");
            long locationId = JSPRequestValue.requestLong(request, "src_location_id");
            String num = JSPRequestValue.requestString(request, "number");
            int allLocation = JSPRequestValue.requestInt(request, "all_location");

            if (session.getValue("REPORT_SALES_VOID") != null) {
                session.removeValue("REPORT_SALES_VOID");
            }
            
            if (session.getValue("VECTOR_VOIDLOCATION") != null) {
                session.removeValue("VECTOR_VOIDLOCATION");
            }

            if (invStartDate == null) {
                invStartDate = new Date();
            }

            if (invEndDate == null) {
                invEndDate = new Date();
            }

            String memo = "";

            if (type == 0) {
                if (memo.length() > 0) {
                    memo = memo + " // ";
                }
                memo = memo + "Void Type : All Type";
            } else if (type == 1) {
                if (memo.length() > 0) {
                    memo = memo + " // ";
                }
                memo = memo + "Void Type : Type Non Retur";
            } else {
                if (memo.length() > 0) {
                    memo = memo + " // ";
                }
                memo = memo + "Void Type : Type Retur";
            }

            if (memo.length() > 0) {
                memo = memo + " // ";
            }
            memo = memo + " Period : " + JSPFormater.formatDate(invStartDate, "dd MMM yyyy") + " to " + JSPFormater.formatDate(invEndDate, "dd MMM yyyy");

            ReportParameterLocation rp = new ReportParameterLocation();
            rp.setLocationId(locationId);
            rp.setStartDate(invStartDate);
            rp.setEndDate(invEndDate);
            rp.setSalesType(type);
            rp.setNumber(num);

            String whereLoc = "";
            Vector vLocSelected = new Vector();
            if (userLocations != null && userLocations.size() > 0) {
                for (int i = 0; i < userLocations.size(); i++) {
                    Location ic = (Location) userLocations.get(i);

                    int ok = JSPRequestValue.requestInt(request, "location_id" + ic.getOID());
                    if (ok == 1) {
                        vLocSelected.add(ic);
                        if (whereLoc != null && whereLoc.length() > 0) {
                            whereLoc = whereLoc + ",";
                        }
                        whereLoc = whereLoc + ic.getOID();
                    }
                }
            }

            Vector users = DbUser.listFullObj(0, 0, "", "", "");
            Hashtable hashUser = new Hashtable();
            if (users != null && users.size() > 0) {
                for (int i = 0; i < users.size(); i++) {
                    User u = (User) users.get(i);
                    hashUser.put(String.valueOf(u.getOID()), u.getFullName());
                }
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
            
            function cmdSearch(){
                document.frmsales.command.value="<%=JSPCommand.LIST%>";                
                document.frmsales.action="rptvoidsales.jsp?menu_idx=<%=menuIdx%>";
                document.frmsales.submit();
            }
            
             function setCheckedLocation(val){
                     <%
                    for (int k = 0; k < userLocations.size(); k++) {
                    Location ic = (Location) userLocations.get(k);
                    %>
                        document.frmsales.location_id<%=ic.getOID()%>.checked=val.checked;

                    <%}%>
                } 
            
            function cmdPrintXls(){	                       
                window.open("<%=printroot%>.report.ReportReturXLS?user_id=<%=appSessUser.getUserOID()%>&lang=<%=lang%>","",'scrollbars=yes,status=yes,width=750,height=600,resizable=yes');
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
                                                                                                                                            <span class="lvl2">Void Sales Report<br>
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
                                                                                                                        <table border="0" cellpadding="0" cellspacing="1">
                                                                                                                            <tr>
                                                                                                                                <td colspan="2" height="10"></td>
                                                                                                                            </tr>    
                                                                                                                            <tr height="23">
                                                                                                                                <td width="100" class="tablearialcell" style="padding:3px">Void Type</td>
                                                                                                                                <td width="1" class="fontarial">:</td>
                                                                                                                                <td width="350">                                                                                                                                    
                                                                                                                                    <select name="src_type" class="fontarial">
                                                                                                                                        <option value="0" <%if (type == 0) {%> selected <%}%> >- All Type -</option>
                                                                                                                                        <option value="1" <%if (type == 1) {%> selected <%}%> >- Type Non Retur -</option>
                                                                                                                                        <option value="2" <%if (type == 2) {%> selected <%}%> >- Type Retur -</option>
                                                                                                                                    </select>    
                                                                                                                                </td>
                                                                                                                                <td width="100" class="tablearialcell" style="padding:3px">Period</td>
                                                                                                                                <td width="1" class="fontarial">:</td>
                                                                                                                                <td>
                                                                                                                                    <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                                        <tr>
                                                                                                                                            <td>
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
                                                                                                                            <tr height="23">
                                                                                                                                <td class="tablearialcell" style="padding:3px">Location</td>
                                                                                                                                <td class="fontarial">:</td>
                                                                                                                                <td colspan="4">
                                                                                                                                    <%
            if (userLocations != null && userLocations.size() > 0) {
                                                                                                                                    %>
                                                                                                                                    <table width="500" border="0" cellpadding="0" cellspacing="0">
                                                                                                                                        <%
                                                                                                                                        int x = 0;
                                                                                                                                        boolean ok = true;
                                                                                                                                        while (ok) {

                                                                                                                                            for (int t = 0; t < 3; t++) {
                                                                                                                                                Location ic = new Location();
                                                                                                                                                try {
                                                                                                                                                    ic = (Location) userLocations.get(x);
                                                                                                                                                } catch (Exception e) {
                                                                                                                                                    ok = false;
                                                                                                                                                    ic = new Location();
                                                                                                                                                    break;
                                                                                                                                                }
                                                                                                                                                int o = JSPRequestValue.requestInt(request, "location_id" + ic.getOID());
                                                                                                                                                if (t == 0) {
                                                                                                                                        %>
                                                                                                                                        <tr>
                                                                                                                                            <%}%>
                                                                                                                                            <td width="5"><input type="checkbox" name="location_id<%=ic.getOID()%>" value="1" <%if (o == 1) {%> checked<%}%> ></td>
                                                                                                                                            <td class="fontarial"><%=ic.getName()%></td>                                                                                                                                                                    
                                                                                                                                            <%if (t == 2) {
                                                                                                                                            %>
                                                                                                                                        </tr>
                                                                                                                                        <%}%>
                                                                                                                                        <%
                                                                                                                                                x++;
                                                                                                                                            }
                                                                                                                                        }%>                                                                                                                                                                
                                                                                                                                        <tr>
                                                                                                                                            <td><input type="checkbox" name="all_location" value="1" <%if (allLocation == 1) {%> checked <%}%>   onClick="setCheckedLocation(this)"></td>
                                                                                                                                            <td class="fontarial">ALL LOCATION</td>
                                                                                                                                        </tr>                                                                                                                                                                   
                                                                                                                                    </table>
                                                                                                                                    <%}%>   
                                                                                                                                </td>
                                                                                                                            </tr> 
                                                                                                                            <tr height="23">
                                                                                                                                <td class="tablearialcell" style="padding:3px">Number</td>
                                                                                                                                <td class="fontarial">:</td>
                                                                                                                                <td colspan="3"><input type="text" name="number" size="20" value="<%=num%>"></td>
                                                                                                                            </tr> 
                                                                                                                            <tr>
                                                                                                                                <td colspan="6">
                                                                                                                                    <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                                                                                                                        <tr>
                                                                                                                                            <td height="3" background="<%=approot%>/images/line1.gif" ></td>
                                                                                                                                        </tr>
                                                                                                                                    </table>
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                            <tr align="left" valign="top"> 
                                                                                                                                <td height="22" valign="middle" colspan="6">
                                                                                                                                    <a href="javascript:cmdSearch()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new2','','../images/search2.gif',1)"><img src="../images/search.gif" name="new2" border="0"></a>
                                                                                                                                </td> 
                                                                                                                            </tr>  
                                                                                                                        </table> 
                                                                                                                    </td>
                                                                                                                </tr>                                                                                                                
                                                                                                                <tr>
                                                                                                                    <td height="8"  colspan="3">&nbsp;</td> 
                                                                                                                </tr>    
                                                                                                                <tr>
                                                                                                                    <td height="8"  colspan="3" class="container"> 
                                                                                                                        <table width="1100" cellpadding="0" cellspacing="1">
                                                                                                                            <%
            if (iJSPCommand == JSPCommand.LIST) {
                
                double gQty = 0;
                double gPrice = 0;
                double gDiscount = 0;
                double gAmount = 0;
                
                session.putValue("VECTOR_VOIDLOCATION", vLocSelected);
                
                for (int a = 0; a < vLocSelected.size(); a++) {

                    Location loc = new Location();
                    loc = (Location) vLocSelected.get(a);
                                                                                                                            %>
                                                                                                                            <tr height="20">
                                                                                                                                <td colspan="10" class="fontarial"><b><i><%=loc.getName()%> - <%=memo%></i></b></td>
                                                                                                                            </tr>  
                                                                                                                            <tr height="23">
                                                                                                                                <td class="tablearialhdr" width="60">Date</td>
                                                                                                                                <td class="tablearialhdr" width="80">Number</td>
                                                                                                                                <td class="tablearialhdr" width="140">User</td>
                                                                                                                                <td class="tablearialhdr" width="60">SKU</td>
                                                                                                                                <td class="tablearialhdr">Name</td>
                                                                                                                                <td class="tablearialhdr" width="140">Approved By</td>
                                                                                                                                <td class="tablearialhdr" width="40">Qty</td>
                                                                                                                                <td class="tablearialhdr" width="70">Selling Price</td>
                                                                                                                                <td class="tablearialhdr" width="70">Discount</td>
                                                                                                                                <td class="tablearialhdr" width="80">Amount</td>
                                                                                                                            </tr> 
                                                                                                                            <%
                    
                    try {
                        CONResultSet crs = null;

                        String where = "";

                        where = where + " and s.location_id = " + loc.getOID();

                        if (num != null && num.length() > 0) {
                            where = where + " and s.number like '%" + num + "%' ";
                        }

                        String sqlVoid = "select s.type as type,s.date as date,s.number as number,s.user_id as user_id,sd.sales_detail_id as sales_detail_id,m.code as code,m.name as name,sd.qty as qty,sd.selling_price as selling_price,sd.discount_amount as discount,sd.cancelled_by as cancelled_by from pos_sales s inner join pos_sales_detail sd on s.sales_id = sd.sales_id inner join pos_item_master m on sd.product_master_id = m.item_master_id where s.type in (0,1) and (s.date between '" + JSPFormater.formatDate(invStartDate, "yyyy-MM-dd") + " 00:00:00' and '" + JSPFormater.formatDate(invEndDate, "yyyy-MM-dd") + " 23:59:59') and sd.qty < 0 " + where;
                        String sqlRetur = "select s.type as type,s.date as date,s.number as number,s.user_id as user_id,sd.sales_detail_id as sales_detail_id,m.code as code,m.name as name,sd.qty*-1 as qty,sd.selling_price as selling_price,sd.discount_amount*-1 as discount,sd.cancelled_by as cancelled_by from pos_sales s inner join pos_sales_detail sd on s.sales_id = sd.sales_id inner join pos_item_master m on sd.product_master_id = m.item_master_id where s.type in (2,3) and (s.date between '" + JSPFormater.formatDate(invStartDate, "yyyy-MM-dd") + " 00:00:00' and '" + JSPFormater.formatDate(invEndDate, "yyyy-MM-dd") + " 23:59:59') and sd.qty > 0 " + where;

                        String sqlUnion = "";

                        if (type == 0) {
                            sqlUnion = sqlVoid + " union " + sqlRetur;
                        } else if (type == 1) {
                            sqlUnion = sqlVoid;
                        } else if (type == 2) {
                            sqlUnion = sqlRetur;
                        }

                        String sql = "select type,date,number,user_id,sales_detail_id,code,name,qty,selling_price,discount,cancelled_by from ( " + sqlUnion + ") as x order by date";

                        crs = CONHandler.execQueryResult(sql);
                        ResultSet rs = crs.getResultSet();
                        int no = 0;
                        String tmpDate = "";

                        double subQty = 0;
                        double subPrice = 0;
                        double subDiscount = 0;
                        double subAmount = 0;

                        double grandQty = 0;
                        double grandPrice = 0;
                        double grandDiscount = 0;
                        double grandAmount = 0;

                        while (rs.next()) {

                            Date date = rs.getDate("date");
                            String number = rs.getString("number");

                            String sku = rs.getString("code");
                            String name = rs.getString("name");

                            double qty = rs.getDouble("qty");
                            double sellingPrice = rs.getDouble("selling_price");
                            double discount = rs.getDouble("discount");
                            if (qty == -0) {
                                qty = 0;
                            }
                            if (sellingPrice == -0) {
                                sellingPrice = 0;
                            }
                            if (discount == -0) {
                                discount = 0;
                            }
                            double amount = (qty * sellingPrice) - discount;

                            long userId = 0;
                            long appId = 0;

                            try {
                                userId = rs.getLong("user_id");
                            } catch (Exception e) {
                            }

                            try {
                                appId = rs.getLong("cancelled_by");
                            } catch (Exception e) {
                            }

                            String strUser = "";
                            String strApp = "";

                            if (userId != 0) {
                                try {
                                    strUser = String.valueOf(hashUser.get(String.valueOf(userId)));
                                } catch (Exception e) {
                                    strUser = "";
                                }
                            }

                            if (appId != 0) {
                                try {
                                    strApp = String.valueOf(hashUser.get(String.valueOf(appId)));
                                } catch (Exception e) {
                                    strUser = "";
                                }
                            }


                            String strDate = "";
                            if (tmpDate == null || tmpDate.length() <= 0) {
                                strDate = JSPFormater.formatDate(date, "dd MMM yyyy");
                            } else {
                                if (tmpDate.compareTo(JSPFormater.formatDate(date, "dd MMM yyyy")) != 0) {
                                    no = 0;
                                    strDate = JSPFormater.formatDate(date, "dd MMM yyyy");
                                                                                                                            %>
                                                                                                                            <tr >
                                                                                                                                <td  colspan="6"></td>                                                                                                                                
                                                                                                                                <td colspan="4">
                                                                                                                                    <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                                                                                                                        <tr>
                                                                                                                                            <td height="3" background="<%=approot%>/images/line1.gif" ></td>
                                                                                                                                        </tr>
                                                                                                                                    </table>
                                                                                                                                </td>                                                                                                                                
                                                                                                                            </tr>
                                                                                                                            <tr height="21">
                                                                                                                                <td bgcolor="#FFFFFF" class="fontarial" align="right" colspan="6"><i><b>Total By Date :</b></i></td>                                                                                                                                
                                                                                                                                <td bgcolor="#E0FCC2" class="fontarial" align="right" style="padding:3px"><i><b><%=JSPFormater.formatNumber(subQty, "###,###.##") %></b></i></td>
                                                                                                                                <td bgcolor="#E0FCC2" class="fontarial" align="right" style="padding:3px"><i><b><%=JSPFormater.formatNumber(subPrice, "###,###.##") %></b></i></td>
                                                                                                                                <td bgcolor="#E0FCC2" class="fontarial" align="right" style="padding:3px"><i><b><%=JSPFormater.formatNumber(subDiscount, "###,###.##") %></b></i></td>
                                                                                                                                <td bgcolor="#E0FCC2" class="fontarial" align="right" style="padding:3px"><i><b><%=JSPFormater.formatNumber(subAmount, "###,###.##") %></b></i></td>
                                                                                                                            </tr>
                                                                                                                            <%
                                                                                                                                                                                                                                                                                            subQty = 0;
                                                                                                                                                                                                                                                                                            subPrice = 0;
                                                                                                                                                                                                                                                                                            subDiscount = 0;
                                                                                                                                                                                                                                                                                            subAmount = 0;
                                                                                                                                                                                                                                                                                        }
                                                                                                                                                                                                                                                                                    }

                                                                                                                                                                                                                                                                                    String str = "";
                                                                                                                                                                                                                                                                                    if (no % 2 == 0) {
                                                                                                                                                                                                                                                                                        str = "tablearialcell1";
                                                                                                                                                                                                                                                                                    } else {
                                                                                                                                                                                                                                                                                        str = "tablearialcell";
                                                                                                                                                                                                                                                                                    }

                                                                                                                            %>
                                                                                                                            <tr height="21">
                                                                                                                                <td class="<%=str%>" align="center"><%=strDate%></td>
                                                                                                                                <td class="<%=str%>" align="left" style="padding:3px"><%=number%></td>
                                                                                                                                <td class="<%=str%>" align="left" style="padding:3px"><%=strUser%></td>
                                                                                                                                <td class="<%=str%>" align="left" style="padding:3px"><%=sku%></td>
                                                                                                                                <td class="<%=str%>" align="left" style="padding:3px"><%=name%></td>
                                                                                                                                <td class="<%=str%>" align="left" style="padding:3px"><%=strApp%></td>
                                                                                                                                <td class="<%=str%>" align="right" style="padding:3px"><%=JSPFormater.formatNumber(qty, "###,###.##") %></td>
                                                                                                                                <td class="<%=str%>" align="right" style="padding:3px"><%=JSPFormater.formatNumber(sellingPrice, "###,###.##") %></td>
                                                                                                                                <td class="<%=str%>" align="right" style="padding:3px"><%=JSPFormater.formatNumber(discount, "###,###.##") %></td>
                                                                                                                                <td class="<%=str%>" align="right" style="padding:3px"><%=JSPFormater.formatNumber(amount, "###,###.##") %></td>
                                                                                                                            </tr>
                                                                                                                            <%

                                                                                                                                                                                                                                                                                    subQty = subQty + qty;
                                                                                                                                                                                                                                                                                    subPrice = subPrice + sellingPrice;
                                                                                                                                                                                                                                                                                    subDiscount = subDiscount + discount;
                                                                                                                                                                                                                                                                                    subAmount = subAmount + amount;

                                                                                                                                                                                                                                                                                    grandQty = grandQty + qty;
                                                                                                                                                                                                                                                                                    grandPrice = grandPrice + sellingPrice;
                                                                                                                                                                                                                                                                                    grandDiscount = grandDiscount + discount;
                                                                                                                                                                                                                                                                                    grandAmount = grandAmount + amount;
                                                                                                                                                                                                                                                                                    no++;
                                                                                                                                                                                                                                                                                    tmpDate = JSPFormater.formatDate(date, "dd MMM yyyy");
                                                                                                                                                                                                                                                                                }

                                                                                                                                                                                                                                                                                

                                                                                                                            %>
                                                                                                                            <tr >
                                                                                                                                <td  colspan="6"></td>                                                                                                                                
                                                                                                                                <td colspan="4">
                                                                                                                                    <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                                                                                                                        <tr>
                                                                                                                                            <td height="3" background="<%=approot%>/images/line1.gif" ></td>
                                                                                                                                        </tr>
                                                                                                                                    </table>
                                                                                                                                </td>                                                                                                                                
                                                                                                                            </tr>
                                                                                                                            <tr height="21">
                                                                                                                                <td bgcolor="#FFFFFF" class="fontarial" align="right" colspan="6"><i><b>Total By Date :</b></i></td>                                                                                                                                
                                                                                                                                <td bgcolor="#E0FCC2" class="fontarial" align="right" style="padding:3px"><i><b><%=JSPFormater.formatNumber(subQty, "###,###.##") %></b></i></td>
                                                                                                                                <td bgcolor="#E0FCC2" class="fontarial" align="right" style="padding:3px"><i><b><%=JSPFormater.formatNumber(subPrice, "###,###.##") %></b></i></td>
                                                                                                                                <td bgcolor="#E0FCC2" class="fontarial" align="right" style="padding:3px"><i><b><%=JSPFormater.formatNumber(subDiscount, "###,###.##") %></b></i></td>
                                                                                                                                <td bgcolor="#E0FCC2" class="fontarial" align="right" style="padding:3px"><i><b><%=JSPFormater.formatNumber(subAmount, "###,###.##") %></b></i></td>
                                                                                                                            </tr>                                                                                                                            
                                                                                                                            <tr >
                                                                                                                                <td  colspan="10" height="10"></td>                                                                                                                                                                                                                                                                
                                                                                                                            </tr>
                                                                                                                            <% 
                                                                                                                            gQty = gQty + grandQty;
                                                                                                                            gPrice = gPrice + grandPrice;
                                                                                                                            gDiscount = gDiscount + grandDiscount;
                                                                                                                            gAmount = gAmount + grandAmount;
                                                                                                                            
                                                                                                                            %>
                                                                                                                            <tr height="21">
                                                                                                                                <td bgcolor="#FFFFFF" class="fontarial" align="right" colspan="6"><i><b>Sub Total :</b></i></td>                                                                                                                                
                                                                                                                                <td bgcolor="#E0FCC2" class="fontarial" align="right" style="padding:3px"><i><b><%=JSPFormater.formatNumber(grandQty, "###,###.##") %></b></i></td>
                                                                                                                                <td bgcolor="#E0FCC2" class="fontarial" align="right" style="padding:3px"><i><b><%=JSPFormater.formatNumber(grandPrice, "###,###.##") %></b></i></td>
                                                                                                                                <td bgcolor="#E0FCC2" class="fontarial" align="right" style="padding:3px"><i><b><%=JSPFormater.formatNumber(grandDiscount, "###,###.##") %></b></i></td>
                                                                                                                                <td bgcolor="#E0FCC2" class="fontarial" align="right" style="padding:3px"><i><b><%=JSPFormater.formatNumber(grandAmount, "###,###.##") %></b></i></td>
                                                                                                                            </tr>
                                                                                                                            <%
                    
                } catch (Exception e) {
                }

            }
                                                                                                                            %>
                                                                                                                            <tr >
                                                                                                                                <td  colspan="10" height="10"></td>                                                                                                                                                                                                                                                                
                                                                                                                            </tr>
                                                                                                                            <tr height="21">
                                                                                                                                <td bgcolor="#FFFFFF" class="fontarial" align="right" colspan="6"><i><b>Grand Total :</b></i></td>                                                                                                                                
                                                                                                                                <td bgcolor="#E0FCC2" class="fontarial" align="right" style="padding:3px"><i><b><%=JSPFormater.formatNumber(gQty, "###,###.##") %></b></i></td>
                                                                                                                                <td bgcolor="#E0FCC2" class="fontarial" align="right" style="padding:3px"><i><b><%=JSPFormater.formatNumber(gPrice, "###,###.##") %></b></i></td>
                                                                                                                                <td bgcolor="#E0FCC2" class="fontarial" align="right" style="padding:3px"><i><b><%=JSPFormater.formatNumber(gDiscount, "###,###.##") %></b></i></td>
                                                                                                                                <td bgcolor="#E0FCC2" class="fontarial" align="right" style="padding:3px"><i><b><%=JSPFormater.formatNumber(gAmount, "###,###.##") %></b></i></td>
                                                                                                                            </tr>
                                                                                                                            <tr >
                                                                                                                                <td  colspan="10" height="20"></td>                                                                                                                                                                                                                                                                
                                                                                                                            </tr>
                                                                                                                            <%if (privPrint) {
                session.putValue("REPORT_SALES_VOID", rp);
                                                                                                                            %>                                                                                                                            
                                                                                                                            <tr >
                                                                                                                                <td  colspan="10" height="10">
                                                                                                                                    <a href="javascript:cmdPrintXls()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('print1','','../images/printxls2.gif',1)"><img src="../images/printxls.gif" name="print1" height="22" border="0"></a>
                                                                                                                                </td>                                                                                                                                                                                                                                                                
                                                                                                                            </tr>
                                                                                                                            <%}
            }%>
                                                                                                                            <%



            if (false) {%>
                                                                                                                            <tr >
                                                                                                                                <td  colspan="10" height="10" class="fontarial"><font color="FF0000"><i>Data transaction not found</i><font></td>                                                                                                                                                                                                                                                                
                                                                                                                            </tr>
                                                                                                                            <%}%>
                                                                                                                            
                                                                                                                        </table>
                                                                                                                    </td>    
                                                                                                                </tr>
                                                                                                                <tr>
                                                                                                                    <td height="30" colspan="3">&nbsp;</td> 
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
