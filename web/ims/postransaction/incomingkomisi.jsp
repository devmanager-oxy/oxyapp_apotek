
<%@ page language = "java" %>
<%@ page import = "com.project.interfaces.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.Date" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "com.project.ccs.posmaster.*" %>
<%@ page import = "com.project.ccs.*" %>
<%@ page import = "com.project.ccs.postransaction.sales.*" %>
<%@ page import = "com.project.ccs.postransaction.receiving.*" %>
<%@ page import = "com.project.system.*" %>
<%@ include file = "../main/javainit.jsp" %>
<%@ include file = "../main/check.jsp" %>
<%
            boolean priv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_INCOMING, AppMenu.M2_INCOMING_KOMISI);
            boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_INCOMING, AppMenu.M2_INCOMING_KOMISI, AppMenu.PRIV_VIEW);
            boolean privUpdate = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_INCOMING, AppMenu.M2_INCOMING_KOMISI, AppMenu.PRIV_UPDATE);
            boolean privAdd = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_INCOMING, AppMenu.M2_INCOMING_KOMISI, AppMenu.PRIV_ADD);
            boolean privDelete = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_INCOMING, AppMenu.M2_INCOMING_KOMISI, AppMenu.PRIV_DELETE);
            boolean privPrint = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_INCOMING, AppMenu.M2_INCOMING_KOMISI, AppMenu.PRIV_PRINT);
%>
<!-- Jsp Block -->
<%!
    public Vector drawList(Vector objectClass) {

        JSPList jsplist = new JSPList();
        jsplist.setAreaWidth("100%");
        jsplist.setListStyle("listgen");
        jsplist.setTitleStyle("tablearialhdr");
        jsplist.setCellStyle("tablearialcell1");
        jsplist.setCellStyle1("tablearialcell");
        jsplist.setHeaderStyle("tablearialhdr");

        jsplist.addHeader("No", "3%");
        jsplist.addHeader("Vendor Code", "6%");
        jsplist.addHeader("Vendor Name", "18%");
        jsplist.addHeader("Item Code", "7%");
        jsplist.addHeader("Item Name", "18%");
        jsplist.addHeader("Total Qty", "5%");
        jsplist.addHeader("Average Price", "8%");
        jsplist.addHeader("Total Sales", "9%");
        jsplist.addHeader("Margin(%)", "5%");
        jsplist.addHeader("Margin Total", "9%");
        jsplist.addHeader("Total AP", "9%");
        jsplist.addHeader("Select", "3%");

        Vector lstData = jsplist.getData();
        Vector lstLinkData = jsplist.getLinkData();
        jsplist.reset();
        int index = -1;
        int jum = 0;

        long oidKonsinyasi = 0;
        try {
            oidKonsinyasi = Long.parseLong(DbSystemProperty.getValueByName("OID_CATEGORY_SIMPATINDO_PULSA"));
        } catch (Exception e) {
            oidKonsinyasi = 0;
        }

        for (int i = 0; i < objectClass.size(); i++) {

            Vector vdet = new Vector();
            vdet = (Vector) objectClass.get(i);

            jum = jum + 1;
            Vector rowx = new Vector();
            rowx.add("<div align=\"center\">" + "" + jum + "</div>");
            rowx.add((String) vdet.get(1)); //code
            rowx.add((String) vdet.get(2)); //name
            rowx.add((String) vdet.get(5)); //code
            rowx.add((String) vdet.get(6)); //name

            long vid = Long.parseLong((String) vdet.get(0));
            long itemId = Long.parseLong((String) vdet.get(4));
            double qty = Double.parseDouble((String) vdet.get(7));
            double totalSales = Double.parseDouble((String) vdet.get(8));
            double margin = Double.parseDouble((String) vdet.get(3));
            //kondisi konsinyasi
            double marginKonsinyasi = Double.parseDouble((String) vdet.get(9));
            long itemCategoryId = Long.parseLong((String) vdet.get(10));
            if (oidKonsinyasi == itemCategoryId) { // jika item konsinyasi, maka yang dipakai adalah margin konsinyasi
                margin = marginKonsinyasi;
            }

            double totalMargin = (totalSales * margin) / 100;

            rowx.add("<div align=\"right\">" + qty + "</div>"); //qty
            rowx.add("<div align=\"right\">" + JSPFormater.formatNumber(totalSales / qty, "#,###.##") + "</div>"); //price
            rowx.add("<div align=\"right\">" + JSPFormater.formatNumber(totalSales, "#,###.##") + "</div>"); //total sales
            rowx.add("<div align=\"right\">" + margin + "</div>"); //margin
            rowx.add("<div align=\"right\">" + JSPFormater.formatNumber(totalMargin, "#,###.##") + "</div>"); //total margin
            rowx.add("<div align=\"right\">" + JSPFormater.formatNumber(totalSales - totalMargin, "#,###.##") + "</div>"); //ap
            rowx.add("<div align=\"center\">" + "<input type=\"checkbox\" name=\"chk_" + vid + "" + itemId + "\" value=\"1\">" + "</div>");

            lstData.add(rowx);
        }

        Vector v = new Vector();
        v.add(jsplist.draw(index));
        return v;

    }

    public Vector getKomisiSales(long locationId, Date startDate, Date endDate) {

        String or = "";
        try {
            or = DbSystemProperty.getValueByName("OID_CATEGORY_SIMPATINDO_PULSA");
        } catch (Exception e) {
        }

        if (or.equals("Not initialized")) {
            or = "";
        } else {
            or = " or m.item_category_id = " + or;
        }

        String sql = "select vid, vcode, vname, vkomisi, mitem_id, " +
                " mcode, mname, sum(qty) as xqty, " +
                " sum(amount) as xamount,vkonsinyasi_margin,mcategory_id from ( " +
                " select 0 as idxx,v.vendor_id as vid, v.code as vcode, v.name as vname, v.komisi_margin as vkomisi, m.item_master_id as mitem_id,v.percent_margin as vkonsinyasi_margin,m.item_category_id as mcategory_id, " +
                " m.code as mcode, m.name as mname, sum(psd.qty) as qty, " +
                " (sum(psd.qty * psd.selling_price)-sum(psd.discount_amount)) as amount from pos_sales ps " +
                " inner join pos_sales_detail psd on ps.sales_id = psd.sales_id " +
                " inner join pos_item_master m on psd.product_master_id = item_master_id " +
                " inner join vendor v on v.vendor_id=m.default_vendor_id " +
                " where  ps.location_id = " + locationId +
                " and  to_days(ps.date) >= to_days('" + JSPFormater.formatDate(startDate, "yyyy-MM-dd") + "') " +
                " and to_days(ps.date) <= to_days('" + JSPFormater.formatDate(endDate, "yyyy-MM-dd") + "') " +
                " and  psd.status_komisi=0 and (m.type_item=2 " + or + ") and ps.type in (0,1) " +
                " group by m.item_master_id, v.vendor_id " +
                " union " +
                " select 1 as idxx,v.vendor_id as vid, v.code as vcode, v.name as vname, v.komisi_margin as vkomisi, m.item_master_id as mitem_id,v.percent_margin as vkonsinyasi_margin,m.item_category_id as mcategory_id," +
                " m.code as mcode, m.name as mname, sum(psd.qty)*-1 as qty, " +
                " (sum(psd.qty * psd.selling_price)-sum(psd.discount_amount))*-1 as amount from pos_sales ps " +
                " inner join pos_sales_detail psd on ps.sales_id = psd.sales_id " +
                " inner join pos_item_master m on psd.product_master_id = item_master_id " +
                " inner join vendor v on v.vendor_id=m.default_vendor_id " +
                " where  ps.location_id = " + locationId +
                " and  to_days(ps.date) >= to_days('" + JSPFormater.formatDate(startDate, "yyyy-MM-dd") + "') " +
                " and to_days(ps.date) <= to_days('" + JSPFormater.formatDate(endDate, "yyyy-MM-dd") + "') " +
                " and  psd.status_komisi=0 and (m.type_item=2 " + or + ") and ps.type in (2,3) " +
                " group by m.item_master_id, v.vendor_id " +
                " ) as x group by mitem_id, vid " +
                " order by vname, mname ";


        CONResultSet dbrs = null;
        Vector result = new Vector();

        try {

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                long vid = rs.getLong("vid");
                String vcode = rs.getString("vcode");
                String vname = rs.getString("vname");
                double vkomisi = rs.getDouble("vkomisi");
                long im = rs.getLong("mitem_id");
                String icode = rs.getString("mcode");
                String iname = rs.getString("mname");
                double qty = rs.getDouble("xqty");
                double amount = rs.getDouble("xamount");
                double vkonsinyasi = rs.getDouble("vkonsinyasi_margin");
                long imCategory = rs.getLong("mcategory_id");
                
                if(qty != 0){ //jika total sales tidak sama dengan 0

                    Vector temp = new Vector();
                    temp.add("" + vid);//0
                    temp.add("" + vcode);//1
                    temp.add("" + vname);//2
                    temp.add("" + vkomisi);//3
                    temp.add("" + im);//4
                    temp.add("" + icode);//5
                    temp.add("" + iname);//6
                    temp.add("" + qty);//7
                    temp.add("" + amount);//8
                    temp.add("" + vkonsinyasi);//9
                    temp.add("" + imCategory);//10

                    result.add(temp);
                }

            }

            rs.close();
            return result;

        } catch (Exception e) {
            return result;
        } finally {
            CONResultSet.close(dbrs);
        }

    }


%>
<%

            int iJSPCommand = JSPRequestValue.requestCommand(request);
            int start = JSPRequestValue.requestInt(request, "start");
            int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
            long srcLocationId = JSPRequestValue.requestLong(request, "src_location_id");
            String srcStart = JSPRequestValue.requestString(request, "src_start_date");
            String srcEnd = JSPRequestValue.requestString(request, "src_end_date");
            Date srcStartDate = new Date();
            Date srcEndDate = new Date();
            srcStartDate = JSPFormater.formatDate(srcStart, "dd/MM/yyyy");
            srcEndDate = JSPFormater.formatDate(srcEnd, "dd/MM/yyyy");
            Vector listKomisiItem = new Vector(1, 1);
            if (iJSPCommand == JSPCommand.SEARCH || iJSPCommand == JSPCommand.SAVE) {
                //listKomisiItem = getKomisiSales(srcLocationId, srcStartDate, srcEndDate);
                listKomisiItem = InterfaceSales.getKomisiSales(srcLocationId, srcStartDate, srcEndDate);
            }

            int vectSize = 0;
            long oidRec = 0;

            if (iJSPCommand == JSPCommand.SAVE) {

                long oidKonsinyasi = 0;
                try {
                    oidKonsinyasi = Long.parseLong(DbSystemProperty.getValueByName("OID_CATEGORY_SIMPATINDO_PULSA"));
                } catch (Exception e) {
                    oidKonsinyasi = 0;
                }

                for (int i = 0; i < listKomisiItem.size(); i++) {

                    Vector vdet = new Vector();
                    vdet = (Vector) listKomisiItem.get(i);

                    long vid = Long.parseLong((String) vdet.get(0));
                    long imid = Long.parseLong((String) vdet.get(4));
                    double qty = Double.parseDouble((String) vdet.get(7));
                    double totalSales = Double.parseDouble((String) vdet.get(8));
                    double margin = Double.parseDouble((String) vdet.get(3));

                    double marginKonsinyasi = Double.parseDouble((String) vdet.get(9));
                    long itemCategoryId = Long.parseLong((String) vdet.get(10));
                    if (oidKonsinyasi == itemCategoryId) { // jika item konsinyasi, maka yang dipakai adalah margin konsinyasi
                        margin = marginKonsinyasi;
                    }

                    double totalMargin = (totalSales * margin) / 100;
                    double price = (totalSales - totalMargin) / qty; //harga incoming satuan

                    int chk = JSPRequestValue.requestInt(request, "chk_" + vid + "" + imid);

                    //jika dicentang, buatkan incoming
                    if (chk == 1) {

                        Receive rec = new Receive();
                        rec.setLocationId(srcLocationId);
                        int counter = DbReceive.getNextCounter() + 1;
                        rec.setNumber(DbReceive.getNextNumber(counter));
                        rec.setCounter(counter);
                        rec.setDate(new Date());
                        rec.setPrefixNumber(DbReceive.getNumberPrefix());
                        rec.setStatus("APPROVED");
                        rec.setUserId(user.getOID());
                        rec.setDueDate(new Date());
                        rec.setApproval1(user.getOID());                        
                        rec.setApproval1Date(srcEndDate);
                        rec.setVendorId(vid);
                        rec.setTotalAmount(totalSales - totalMargin);
                        rec.setPaymentType("Credit");
                        rec.setCurrencyId(504404384818397770l);//rp
                        rec.setNote("AUTO GENERATED - Incoming Komisi Periode : " + JSPFormater.formatDate(srcStartDate, "dd/MM/yyyy") + " sampai " + JSPFormater.formatDate(srcEndDate, "dd/MM/yyyy"));

                        try {
                            long oidx = DbReceive.insertExc(rec);
                            if (oidx != 0) {

                                ItemMaster im = new ItemMaster();
                                try {
                                    im = DbItemMaster.fetchExc(imid);
                                } catch (Exception ex1) {
                                }

                                ReceiveItem ri = new ReceiveItem();
                                ri.setReceiveId(oidx);
                                ri.setItemMasterId(imid);
                                ri.setQty(qty);
                                ri.setAmount(price);
                                ri.setTotalAmount(qty * price);
                                ri.setUomId(im.getUomStockId());

                                try {
                                    long oid = DbReceiveItem.insertExc(ri);
                                    if (oid != 0) {
                                        try {
                                            //proses stock
                                            DbReceiveItem.proceedStock(rec);
                                        } catch (Exception e) {
                                        }

                                        try {
                                            //update status sales
                                            //DbReceiveItem.updateKomisi(srcStartDate,srcEndDate,srcLocationId, ri.getItemMasterId());
                                            InterfaceSales.updateKomisi(srcStartDate, srcEndDate, srcLocationId, ri.getItemMasterId());
                                        } catch (Exception e) {
                                        }
                                    }
                                } catch (Exception ex) {
                                }
                            }
                        } catch (Exception ex) {
                        }
                    }
                }
            }
%>
<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
    <head>
        <!-- #BeginEditable "javascript" --> 
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <title><%=titleIS%></title>
        <link href="../css/css.css" rel="stylesheet" type="text/css" />
        <script language="JavaScript">
            <%if (!priv || !privView) {%>
            window.location="<%=approot%>/nopriv.jsp";
            <%}%>
            
            function checkMe(idx){
                //released all
                if(parseInt(idx)==0){
        <% if (listKomisiItem != null && listKomisiItem.size() > 0) {
                for (int i = 0; i < listKomisiItem.size(); i++) {
                    Vector temp = (Vector) listKomisiItem.get(i);
                    long vid = Long.parseLong((String) temp.get(0));
                %>
                    document.frmorder.chk_<%=vid%>.checked=false;     
                    
            <%}
            }%>
        }
        //checked all
        else{
        <% if (listKomisiItem != null && listKomisiItem.size() > 0) {
                for (int i = 0; i < listKomisiItem.size(); i++) {
                    Vector temp = (Vector) listKomisiItem.get(i);
                    long vid = Long.parseLong((String) temp.get(0));
                %>
                    document.frmorder.chk_<%=vid%>.checked=true;     
                    
            <%}
            }%>
        }
    }
    
    
    
    function cmdSearch(){
        document.frmorder.command.value="<%=JSPCommand.SEARCH%>";
        document.frmorder.prev_command.value="<%=prevJSPCommand%>";
        document.frmorder.action="incomingkomisi.jsp";
        document.frmorder.submit();
    }
    
    
    function cmdReceive(oidReceive){
        document.frmorder.hidden_receive_id.value=oidReceive;
        document.frmorder.command.value="<%=JSPCommand.EDIT%>";
        document.frmorder.prev_command.value="<%=prevJSPCommand%>";
        document.frmorder.action="receiveitem.jsp";
        document.frmorder.submit();
    }
    
    function cmdAsk(oidItemMaster){
        document.frmorder.hidden_item_master_id.value=oidItemMaster;
        document.frmorder.command.value="<%=JSPCommand.ASK%>";
        document.frmorder.prev_command.value="<%=prevJSPCommand%>";
        document.frmorder.action="incomingkomisi.jsp";
        document.frmorder.submit();
    }
    
    
    function cmdSave(){
        if(confirm("Warning, this command will create APPROVED incoming for each selected vendor, and also generate stock.\nProceed action ?")){
            
            document.all.cmdsave.style.display="none";
            document.all.cmdsavecomment.style.display="";
            
            document.frmorder.command.value="<%=JSPCommand.SAVE%>";
            document.frmorder.prev_command.value="<%=prevJSPCommand%>";
            document.frmorder.action="incomingkomisi.jsp";
            document.frmorder.submit();
        }
    }
    
    
    
    function cmdCancel(oidItemMaster){
        document.frmorder.hidden_item_master_id.value=oidItemMaster;
        document.frmorder.command.value="<%=JSPCommand.EDIT%>";
        document.frmorder.prev_command.value="<%=prevJSPCommand%>";
        document.frmorder.action="incomingkomisi.jsp";
        document.frmorder.submit();
    }
    
    function cmdBack(){
        document.frmorder.command.value="<%=JSPCommand.BACK%>";
        document.frmorder.action="incomingkomisi.jsp";
        document.frmorder.submit();
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
    <body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','../images/search2.gif','../images/new2.gif')">
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
                                <!-- #EndEditable -->
                            </td>
                            <td width="100%" valign="top"> 
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                    
                                    <tr> 
                                        <td><!-- #BeginEditable "content" --> 
                                            <form name="frmorder" method ="post" action="">
                                                <input type="hidden" name="command" value="<%=iJSPCommand%>">
                                                <input type="hidden" name="vectSize" value="<%=vectSize%>">
                                                <input type="hidden" name="start" value="<%=start%>">
                                                <input type="hidden" name="hidden_receive_id" value="<%=oidRec%>">
                                                <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                                                <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                    <tr> 
                                                        <td class="container" valign="top"> 
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr> 
                                                                    <td> 
                                                                        <table width="100%" border="0" cellspacing="1" cellpadding="1" height="17">
                                                                            <tr valign="bottom"> 
                                                                                <td width="60%" height="23"><b><font color="#990000" class="lvl1">Incoming Goods 
                                                                                        </font><font class="tit1">&raquo; 
                                                                                        </font><font class="tit1"><span class="lvl2">Incoming Komisi
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
                                                                    <td class="page"> 
                                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="8"  colspan="3"> 
                                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="8" valign="middle" colspan="3"> 
                                                                                                <table width="600" border="0" cellspacing="1" cellpadding="0">
                                                                                                    <tr> 
                                                                                                        <td colspan="3">&nbsp;</td>
                                                                                                    </tr>
                                                                                                    <tr> 
                                                                                                        <td colspan="3" class="fontarial" nowrap ><b><i>Search Option :</i></b></td>
                                                                                                    </tr>                                                                                                    
                                                                                                    <tr height="22"> 
                                                                                                        <td width="80" class="tablearialcell1">&nbsp;&nbsp;Location</td>
                                                                                                        <td width="1" class="fontarial">:</td>
                                                                                                        <td >
                                                                                                            <select name="src_location_id" class="fontarial">
                                                                                                                <%

            Vector vloc = userLocations;

            if (vloc != null && vloc.size() > 0) {
                for (int i = 0; i < vloc.size(); i++) {
                    Location loc = (Location) vloc.get(i);

                                                                                                                %>
                                                                                                                <option value="<%=loc.getOID()%>" <%if (srcLocationId == loc.getOID()) {%>selected<%}%>><%=loc.getName()%></option>
                                                                                                                <%}
            }%>
                                                                                                            </select>
                                                                                                        </td>                                                                                                          
                                                                                                    </tr>
                                                                                                    <tr height="22"> 
                                                                                                        <td class="tablearialcell1">&nbsp;&nbsp;Period</td>
                                                                                                        <td width="1" class="fontarial">:</td>
                                                                                                        <td >
                                                                                                            <table border="0" cellpadding="0" cellspacing="">
                                                                                                                <tr>
                                                                                                                    <td>
                                                                                                                        <input name="src_start_date" value="<%=JSPFormater.formatDate((srcStartDate == null) ? new Date() : srcStartDate, "dd/MM/yyyy")%>" size="11" readonly>
                                                                                                                    </td>
                                                                                                                    <td>
                                                                                                                        <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmorder.src_start_date);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> 
                                                                                                                    </td>
                                                                                                                    <td>&nbsp;&nbsp;and&nbsp;&nbsp;</td> 
                                                                                                                    <td><input name="src_end_date" value="<%=JSPFormater.formatDate((srcEndDate == null) ? new Date() : srcEndDate, "dd/MM/yyyy")%>" size="11" readonly></td>
                                                                                                                    <td><a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmorder.src_end_date);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a></td> 
                                                                                                                </tr>
                                                                                                            </table>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <tr> 
                                                                                                        <td colspan="3" background="../images/line1.gif"><img src="../images/line1.gif" width="47" height="3"></td>
                                                                                                    </tr> 
                                                                                                    <tr>
                                                                                                        <td colspan="3"><a href="javascript:cmdSearch()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('search','','../images/search2.gif',1)"><img src="../images/search.gif" name="search"  border="0"></a></td>
                                                                                                    </tr>                                                                                             
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <%
            try {
                if (listKomisiItem.size() > 0 && iJSPCommand == JSPCommand.SEARCH) {
                                                                                        %>
                                                                                        
                                                                                        <tr> 
                                                                                            <td colspan="7" height="22" align="right"><a href="javascript:checkMe('1')">Select All</a> | <a href="javascript:checkMe('0')">Release All</a></td>
                                                                                        </tr>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="22" valign="middle" colspan="7"> 
                                                                                                <%
                                                                                                Vector x = drawList(listKomisiItem);
                                                                                                String strString = (String) x.get(0);



                                                                                                %>
                                                                                                
                                                                                            <%=strString%> </td>
                                                                                            
                                                                                        </tr>
                                                                                        <%  } else if (iJSPCommand == JSPCommand.SEARCH) {%>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="22" valign="middle" colspan="7"> 
                                                                                            <h3><font color="red">&nbsp;List is empty - no sales available</font></h3>
                                                                                        </tr>                
                                                                                        <%} else if (iJSPCommand == JSPCommand.SAVE) {%>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="22" valign="middle" colspan="7"> 
                                                                                            &nbsp;</td>
                                                                                        </tr> 
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="22" valign="middle" colspan="7"> 
                                                                                            <h3>&nbsp;Saving incoming completed</h3>
                                                                                        </tr> 
                                                                                        <%}
            } catch (Exception exc) {
            }%>                                                                                                             
                                                                                    </table>
                                                                                </td>
                                                                            </tr> 
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="10" valign="middle" colspan="3">&nbsp;</td>
                                                                            </tr>
                                                                            <% if (oidRec != 0) {%>
                                                                            <script language="JavaScript">
                                                                                cmdReceive('<%=oidRec%>')
                                                                            </script>
                                                                            <%}%>
                                                                        </table>
                                                                    </td>
                                                                </tr>
                                                                
                                                                <%if (listKomisiItem.size() > 0 && iJSPCommand == JSPCommand.SEARCH) {%>
                                                                <tr> 
                                                                    <td>
                                                                        <table>
                                                                            <tr id="cmdsave">
                                                                                <td>
                                                                                    <a href="javascript:cmdSave()">Create Incoming Komisi</a>
                                                                                </td>
                                                                                <td>
                                                                                    &nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                                                                </td>
                                                                            </tr>
                                                                            <tr id="cmdsavecomment">
                                                                                <td>
                                                                                    &nbsp;<font color="red">Saving in progress, please wait ...</font>
                                                                                </td>
                                                                                <td>
                                                                                    &nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                                                                </td>
                                                                            </tr>   
                                                                        </table>
                                                                    </td>
                                                                </tr>
                                                                <%}%> 
                                                            </table>
                                                            <script language="JavaScript">
                                                                document.all.cmdsave.style.display="";
                                                                document.all.cmdsavecomment.style.display="none";
                                                            </script>
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
            <tr> 
                <td height="25"> 
                    <!-- #BeginEditable "footer" --> 
            <%@ include file="../main/footer.jsp"%>
                    <!-- #EndEditable -->
                </td>
            </tr>
        </table>
    </body>
<!-- #EndTemplate --></html>
