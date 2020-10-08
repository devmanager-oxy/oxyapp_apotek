
<%-- 
    Document   : adjustment_ga
    Created on : Mar 26, 2015, 4:04:25 PM
    Author     : Roy
--%>

<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.main.db.*" %>
<%@ page import = "com.project.general.*" %>
<%@ page import = "com.project.ccs.report.*" %>
<%@ page import = "com.project.ccs.postransaction.costing.* " %>
<%@ page import = "java.sql.ResultSet" %> 
<%@ page import = "com.project.ccs.posmaster.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "java.util.Date" %>
<%@ include file = "../main/javainit.jsp" %>
<%@ include file = "../main/check.jsp" %>
<%
            boolean priv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_RETAIL_REPORT, AppMenu.M2_AJUSTMENT_GA);
            boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_RETAIL_REPORT, AppMenu.M2_AJUSTMENT_GA, AppMenu.PRIV_VIEW);
            boolean privPrint = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_RETAIL_REPORT, AppMenu.M2_AJUSTMENT_GA, AppMenu.PRIV_PRINT);
%>
<!-- Jsp Block -->
<%
            if (session.getValue("REPORT_ADJ_GA") != null) {
                session.removeValue("REPORT_ADJ_GA");
            }

            if (session.getValue("REPORT_ADJ_GA_PARAMETER") != null) {
                session.removeValue("REPORT_ADJ_GA_PARAMETER");
            }

            int iJSPCommand = JSPRequestValue.requestCommand(request);
            long srcLocationId = JSPRequestValue.requestLong(request, "src_location_id");
            long srcCostId = JSPRequestValue.requestLong(request, "src_cost_id");
            String srcStatus = JSPRequestValue.requestString(request, "src_status");
            String srcStart = JSPRequestValue.requestString(request, "src_start_date");
            String srcEnd = JSPRequestValue.requestString(request, "src_end_date");

            Date srcStartDate = JSPFormater.formatDate(srcStart, "dd/MM/yyyy");
            Date srcEndDate = JSPFormater.formatDate(srcEnd, "dd/MM/yyyy");

            String srcCode = JSPRequestValue.requestString(request, "src_code");
            String srcName = JSPRequestValue.requestString(request, "src_name");

            Vector vpar = new Vector();
            vpar.add("" + srcLocationId);
            vpar.add("" + srcCostId);
            vpar.add("" + JSPFormater.formatDate(srcStartDate, "dd/MM/yyyy"));
            vpar.add("" + JSPFormater.formatDate(srcEndDate, "dd/MM/yyyy"));
            vpar.add("" + srcStatus);
            vpar.add("" + srcCode);
            vpar.add("" + srcName);
            vpar.add("" + user.getFullName());

            Vector print = new Vector();

            Vector uoms = new Vector();
            Hashtable hUom = new Hashtable();
            uoms = DbUom.list(0, 0, "", "");
            if (uoms != null && uoms.size() > 0) {
                for (int i = 0; i < uoms.size(); i++) {
                    Uom uom = (Uom) uoms.get(i);
                    hUom.put("" + uom.getOID(), uom.getUnit());
                }
            }

            Vector report = new Vector();
            Vector reportParameter = new Vector();
            reportParameter.add("" + srcLocationId);
            reportParameter.add("" + JSPFormater.formatDate(srcStartDate, "dd/MM/yyyy"));
            reportParameter.add("" + JSPFormater.formatDate(srcEndDate, "dd/MM/yyyy"));

            session.putValue("REPORT_ADJ_GA_PARAMETER", reportParameter);

%>
<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
    <head>
        <!-- #BeginEditable "javascript" --> 
        <title><%=titleIS%></title>
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
        <link href="../css/default.css" rel="stylesheet" type="text/css" />
        <link href="../css/css.css" rel="stylesheet" type="text/css" />
        <script language="JavaScript">
            <%if (!priv || !privView) {%>
            window.location="<%=approot%>/nopriv.jsp";
            <%}%>
            
            function cmdPrintXLS(){	 
                window.open("<%=printroot%>.report.ReportAdjGaXLS?user_id=<%=appSessUser.getUserOID()%>");
                }
                
                function cmdSearch(){
                    document.frmadjusment.command.value="<%=JSPCommand.LIST%>";                    
                    document.frmadjusment.action="adjustment_ga.jsp";
                    document.frmadjusment.submit();
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
    <body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','../images/search2.gif','../images/new2.gif','../images/print2.gif')">
        <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
            <tr> 
                <td valign="top"> 
                    <table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
                        <tr> 
                            <td height="96"> 
                                <!-- #BeginEditable "header" --> 
            <%@ include file="../main/hmenu.jsp"%>
                                <!-- #EndEditable -->
                            </td>
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
                                                        <form name="frmadjusment" method ="post" action="">
                                                            <input type="hidden" name="command" value="<%=iJSPCommand%>">                                                            
                                                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr> 
                                                                    <td valign="top"> 
                                                                        <table width="100%" border="0" cellspacing="1" cellpadding="1" height="17">
                                                                            <tr valign="bottom"> 
                                                                                <td width="60%" height="23"><b><font color="#990000" class="lvl1">Report 
                                                                                        </font><font class="tit1">&raquo; 
                                                                                <span class="lvl2">Adjusment Report</span></font></b></td>
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
                                                                    <td valign="top" class="container"> 
                                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="5"  colspan="3"></td>
                                                                            </tr>
                                                                            
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="8"  colspan="3"> 
                                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="8" valign="middle" colspan="3"></td>
                                                                                        </tr>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="22" valign="middle" colspan="3"> 
                                                                                                <table width="100%" border="0" cellspacing="2" cellpadding="1">
                                                                                                    <tr> 
                                                                                                        <td  class="fontarial" colspan="4"><b><i>Search Parameters :</i></b></td>                                                                                                        
                                                                                                    </tr>
                                                                                                    <%
            Vector locations = userLocations;
                                                                                                    %>
                                                                                                    <tr height="23"> 
                                                                                                        <td width="100" class="tablearialcell1">&nbsp;&nbsp;Location</td>
                                                                                                        <td width="1" class="fontarial">:</td>
                                                                                                        <td width="300"> 
                                                                                                            <select name="src_location_id">
                                                                                                                <%if (locations.size() == totLocationxAll) {%>
                                                                                                                <option value="0" <%if (srcLocationId == 0) {%>selected<%}%>>- All Location -</option>
                                                                                                                <%}%>
                                                                                                                <%


            if (locations != null && locations.size() > 0) {
                for (int i = 0; i < locations.size(); i++) {
                    Location d = (Location) locations.get(i);
                                                                                                                %>
                                                                                                                <option value="<%=d.getOID()%>" <%if (srcLocationId == d.getOID()) {%>selected<%}%>><%=d.getName()%></option>
                                                                                                                <%}
            }%>
                                                                                                            </select>
                                                                                                        </td>
                                                                                                        <td width="100" ></td>
                                                                                                        <td width="1" class="fontarial"></td>
                                                                                                        <td ></td>
                                                                                                    </tr>
                                                                                                    <tr height="23"> 
                                                                                                        <td class="tablearialcell1">&nbsp;&nbsp;Document Status </td>
                                                                                                        <td width="1" class="fontarial">:</td>
                                                                                                        <td > 
                                                                                                            <select name="src_status" class="fontarial">                                                                                                                
                                                                                                                <option value="" >- All -</option>                                                                                                               
                                                                                                                <option value="<%=I_Project.DOC_STATUS_DRAFT%>" <%if (srcStatus.equals(I_Project.DOC_STATUS_DRAFT)) {%>selected<%}%>><%=I_Project.DOC_STATUS_DRAFT%></option>                                                                                                                
                                                                                                                <option value="<%=I_Project.DOC_STATUS_APPROVED%>" <%if (srcStatus.equals(I_Project.DOC_STATUS_APPROVED)) {%>selected<%}%>><%=I_Project.DOC_STATUS_APPROVED%></option>                                                                                                                
                                                                                                                <option value="<%=I_Project.DOC_STATUS_POSTED%>" <%if (srcStatus.equals(I_Project.DOC_STATUS_POSTED)) {%>selected<%}%>><%=I_Project.DOC_STATUS_POSTED%></option>                                                                                                                
                                                                                                            </select>
                                                                                                        </td>
                                                                                                        <td class="tablearialcell1">&nbsp;&nbsp;Date Between</td>
                                                                                                        <td width="1" class="fontarial">:</td>
                                                                                                        <td >
                                                                                                            <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                <tr>
                                                                                                                    <td><input name="src_start_date" value="<%=JSPFormater.formatDate((srcStartDate == null) ? new Date() : srcStartDate, "dd/MM/yyyy")%>" size="11" readonly></td>
                                                                                                                    <td><a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmadjusment.src_start_date);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a></td>
                                                                                                                    <td >&nbsp;&nbsp;and&nbsp;&nbsp;</td>
                                                                                                                    <td ><input name="src_end_date" value="<%=JSPFormater.formatDate((srcEndDate == null) ? new Date() : srcEndDate, "dd/MM/yyyy")%>" size="11" readonly></td>
                                                                                                                    <td><a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmadjusment.src_end_date);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a></td>                                                                                                                    
                                                                                                                </tr>
                                                                                                            </table>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <tr height="23"> 
                                                                                                        <td class="tablearialcell1">&nbsp;&nbsp;SKU</td>
                                                                                                        <td width="1" class="fontarial">:</td>
                                                                                                        <td > 
                                                                                                            <input type="text" name="src_code" value="<%=srcCode%>" class="fontarial">
                                                                                                        </td>
                                                                                                        <td class="tablearialcell1">&nbsp;&nbsp;Item Name</td>
                                                                                                        <td width="1" class="fontarial">:</td>
                                                                                                        <td > 
                                                                                                            <input type="text" name="src_name" size="20" value="<%=srcName%>" class="fontarial">
                                                                                                        </td>
                                                                                                    </tr>                                                                                                    
                                                                                                    <tr>
                                                                                                        <td colspan="6">
                                                                                                            <table width="80%" border="0" cellspacing="0" cellpadding="0">                                                                                                                
                                                                                                                <tr> 
                                                                                                                    <td height="2" background="../images/line1.gif" ><img src="../images/line1.gif"></td>
                                                                                                                </tr>
                                                                                                            </table>
                                                                                                            
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <tr> 
                                                                                                        <td ><a href="javascript:cmdSearch()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('sr21','','../images/search2.gif',1)"><img src="../images/search.gif" name="sr21" border="0"></a></td>
                                                                                                        <td colspan="3">&nbsp;</td>
                                                                                                    </tr>
                                                                                                    <tr height="40">
                                                                                                        <td colspan="6">&nbsp;</td>
                                                                                                    </tr>
                                                                                                    <tr height="40">
                                                                                                        <td colspan="6">
                                                                                                            <table width="100%" border="0" cellspacing="2" cellpadding="1">
                                                                                                                <tr height="23">
                                                                                                                    <td width="25" class="tablearialhdr">NO</td>
                                                                                                                    <td width="100" class="tablearialhdr">KODE BARANG</td>
                                                                                                                    <td class="tablearialhdr">NAMA BARANG</td>
                                                                                                                    <td width="80" class="tablearialhdr">SATUAN</td>
                                                                                                                    <td width="100" class="tablearialhdr">QTY</td>
                                                                                                                    <td width="150" class="tablearialhdr">HARGA</td>
                                                                                                                    <td width="150" class="tablearialhdr">JUMLAH</td>
                                                                                                                </tr>    
                                                                                                                <%
            try {
                CONResultSet crs = null;
                
                String strSql = "";
                
                if (srcLocationId != 0) {
                    strSql = strSql + " and s.location_id = " + srcLocationId;
                }

                if (srcCode != null && srcCode.length() > 0) {
                    strSql = strSql + " and m.code like '" + srcCode.trim() + "' ";
                }

                if (srcName != null && srcName.length() > 0) {
                    strSql = strSql + " and m.name like '" + srcName.trim() + "' ";
                }

                if (srcStatus != null && srcStatus.length() > 0) {
                    strSql = strSql + " and s.status = '" + srcStatus.trim() + "' ";
                }
                
                
                String strSqlGa = "";
                
                if (srcLocationId != 0) {
                    strSqlGa = strSqlGa + " and s.location_post_id = " + srcLocationId;
                }

                if (srcCode != null && srcCode.length() > 0) {
                    strSqlGa = strSqlGa + " and m.code like '" + srcCode.trim() + "' ";
                }

                if (srcName != null && srcName.length() > 0) {
                    strSqlGa = strSqlGa + " and m.name like '" + srcName.trim() + "' ";
                }

                if (srcStatus != null && srcStatus.length() > 0) {
                    strSqlGa = strSqlGa + " and s.status = '" + srcStatus.trim() + "' ";
                }
                

                String sql = "select group_id,gcode,gname,item_master_id,satuan,item_code,item_name,sum(qty) as qty,sum(total) as total from ( "+
                        " select g.item_group_id as group_id,g.code as gcode,g.name as gname,m.item_master_id,m.uom_sales_id as satuan,m.code as item_code,m.name as item_name,sum(sd.qty_balance)*-1 as qty,sum(sd.qty_balance * sd.price)*-1 as total from pos_adjusment s inner join pos_adjusment_item sd on s.adjusment_id = sd.adjusment_id inner join pos_item_master m on sd.item_master_id = m.item_master_id inner join vendor v on m.default_vendor_id = v.vendor_id inner join pos_item_group g on m.item_group_id = g.item_group_id where v.type = 4 and s.date between '" + JSPFormater.formatDate(srcStartDate, "yyyy-MM-dd") + " 00:00:00' and '" + JSPFormater.formatDate(srcEndDate, "yyyy-MM-dd") + " 23:59:59' "+strSql+" group by m.item_master_id union "+
                        " select g.item_group_id as group_id,g.code as gcode,g.name as gname,m.item_master_id,m.uom_sales_id as satuan,m.code as item_code,m.name as item_name,sum(sd.qty) as qty,sum(sd.qty * sd.price) as total from pos_general_affair s inner join pos_general_affair_detail sd on s.general_affair_id = sd.general_affair_id inner join pos_item_master m on sd.item_master_id = m.item_master_id inner join vendor v on m.default_vendor_id = v.vendor_id inner join pos_item_group g on m.item_group_id = g.item_group_id where v.type = 4 and s.date between '" + JSPFormater.formatDate(srcStartDate, "yyyy-MM-dd") + " 00:00:00' and '" + JSPFormater.formatDate(srcEndDate, "yyyy-MM-dd") + " 23:59:59' "+strSqlGa+" group by m.item_master_id ) as x group by item_master_id";                

                sql = sql + " order by gcode,item_code ";

                crs = CONHandler.execQueryResult(sql);
                ResultSet rs = crs.getResultSet();

                String style = "";
                int nomor = 1;
                String grpName = "";

                long tmpGid = 0;
                double subTotal = 0;
                double grandTotal = 0;
                boolean data = false;

                while (rs.next()) {

                    double qty = rs.getDouble("qty");

                    if (qty != 0) {

                        data = true;

                        if (nomor % 2 == 0) {
                            style = "tablearialcell";
                        } else {
                            style = "tablearialcell1";
                        }

                        long gId = rs.getLong("group_id");
                        String groupCode = rs.getString("gcode");
                        String gname = rs.getString("gname");
                        String itemKode = rs.getString("item_code");
                        String itemName = rs.getString("item_name");
                        long uom = rs.getLong("satuan");

                        String unit = "";
                        try {
                            unit = String.valueOf(hUom.get("" + uom));
                        } catch (Exception e) {
                            unit = "";
                        }

                        double amount = rs.getDouble("total");
                        double price = 0;

                        if (qty == 0 && amount == 0) {
                            price = 0;
                        } else if (qty == 0) {
                            price = 0;
                        } else {
                            price = amount / qty;
                        }

                        Vector tmpReport = new Vector();
                        tmpReport.add("" + gId);
                        tmpReport.add("" + groupCode);
                        tmpReport.add("" + itemKode);
                        tmpReport.add("" + itemName);
                        tmpReport.add("" + unit);
                        tmpReport.add("" + qty);
                        tmpReport.add("" + price);
                        tmpReport.add("" + amount);
                        tmpReport.add("" + gname);
                        report.add(tmpReport);
                                                                                                                %>
                                                                                                                <%if (tmpGid != 0 && tmpGid != gId) {%>
                                                                                                                <tr height="22"  bgcolor="#cccccc">                                                                                                                                                                                                 
                                                                                                                    <td class="fontarial" colspan="3" align="center"><i>TOTAL PEMAKAIAN <%=grpName%></i></td>                                                                                                                                
                                                                                                                    <td class="fontarial" colspan="3"  align="left" style="padding:3px;">&nbsp;</td>                                                                                                                                                                                                                                                                
                                                                                                                    <td class="fontarial" align="right" style="padding:3px;"><i><%=JSPFormater.formatNumber(subTotal, "###,###.##")%></i></td>                                                                                                                                                                                                                                                                
                                                                                                                </tr>
                                                                                                                <%
                                                                                                                                subTotal = 0;
                                                                                                                            }%>
                                                                                                                <%
                                                                                                                            if (tmpGid != gId) {
                                                                                                                                grpName = gname;
                                                                                                                %>
                                                                                                                <tr height="22" bgcolor="#BFD8AF">                                                                                                                                                                                                 
                                                                                                                    <td class="fontarial" align="center"><i><%=groupCode%></i></td>                                                                                                                                
                                                                                                                    <td class="fontarial" colspan="6" align="left" style="padding:3px;"><i><%=gname%></i></td>                                                                                                                                                                                                                                                                
                                                                                                                </tr>
                                                                                                                <%
                                                                                                                                nomor = 1;
                                                                                                                            }
                                                                                                                            tmpGid = gId;
                                                                                                                %>                                                                                                                
                                                                                                                
                                                                                                                <tr height="22">                                                                                                                                                                                                 
                                                                                                                    <td class="<%=style%>" align="center"><%=nomor%>.</td>
                                                                                                                    <%
                                                                                                                            nomor++;
                                                                                                                    %>
                                                                                                                    <td class="<%=style%>" style="padding:3px;" align="left"><%=itemKode%></td>
                                                                                                                    <td class="<%=style%>" style="padding:3px;" align="left"><%=itemName%></td>
                                                                                                                    <td class="<%=style%>" style="padding:3px;" align="left"><%=unit.toUpperCase()%></td>
                                                                                                                    <td class="<%=style%>" style="padding:3px;" align="right"><%=JSPFormater.formatNumber(qty, "###,###.##")%></td>
                                                                                                                    <td class="<%=style%>" style="padding:3px;" align="right"><%=JSPFormater.formatNumber(price, "###,###.##")%></td>
                                                                                                                    <td class="<%=style%>" align="right" style="padding:3px;"><%=JSPFormater.formatNumber(amount, "###,###.##")%></td> 
                                                                                                                </tr>
                                                                                                                <%

                                                                                                                            subTotal = subTotal + amount;
                                                                                                                            grandTotal = grandTotal + amount;
                                                                                                                        }
                                                                                                                    }

                                                                                                                    if (data) {
                                                                                                                        session.putValue("REPORT_ADJ_GA", report);
                                                                                                                %>
                                                                                                                <tr height="22"  bgcolor="#cccccc">                                                                                                                                                                                                 
                                                                                                                    <td class="fontarial" colspan="3" align="center"><i>TOTAL PEMAKAIAN <%=grpName%></i></td>                                                                                                                                
                                                                                                                    <td class="fontarial" colspan="3"  align="left" style="padding:3px;">&nbsp;</td>                                                                                                                                                                                                                                                                
                                                                                                                    <td class="fontarial" align="right" style="padding:3px;"><i><%=JSPFormater.formatNumber(subTotal, "###,###.##")%></i></td>                                                                                                                                                                                                                                                                
                                                                                                                </tr>
                                                                                                                <tr height="22"  bgcolor="#cccccc">                                                                                                                                                                                                 
                                                                                                                    <td class="fontarial" colspan="3" align="center"><b><i>GRAND TOTAL</i></b></td>                                                                                                                                
                                                                                                                    <td class="fontarial" colspan="3"  align="left" style="padding:3px;">&nbsp;</td>                                                                                                                                                                                                                                                                
                                                                                                                    <td class="fontarial" align="right" style="padding:3px;"><b><i><%=JSPFormater.formatNumber(grandTotal, "###,###.##")%></i></b></td>                                                                                                                                                                                                                                                                
                                                                                                                </tr>
                                                                                                                <%if (privPrint) {%>
                                                                                                                <tr> 
                                                                                                                    <td colspan="6">&nbsp;</td>                                                                                                                                                                                                                                                                                        
                                                                                                                </tr>
                                                                                                                <tr> 
                                                                                                                    <td colspan="6"><a href="javascript:cmdPrintXLS()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('print1','','../images/printxls2.gif',1)"><img src="../images/printxls.gif" name="print1" height="22" border="0"></a></td>                                                                                                                                                                                                                                                                                        
                                                                                                                </tr>
                                                                                                                <tr> 
                                                                                                                    <td height="25" colspan="6">&nbsp;</td>                                                                                                                                                                                                                                                                                        
                                                                                                                </tr>
                                                                                                                <%
                    }
                }

            } catch (Exception e) {
            }
                                                                                                                
                                                                                                                
                                                                                                                
                                                                                                                %>
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
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </form>                                                        
                                                        <!-- #EndEditable -->
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr> 
                            <td height="25"> 
                                <!-- #BeginEditable "footer" --> 
            <%@ include file="../main/footer.jsp"%>
                                <!-- #EndEditable -->
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </body>
<!-- #EndTemplate --></html>
