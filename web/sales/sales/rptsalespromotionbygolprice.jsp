
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
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.Date" %>

<%@ page import = "com.project.ccs.session.*" %>
<%@ include file = "../main/javainit.jsp" %>
<% int appObjCode = 1;%>
<%@ include file = "../main/checksl.jsp" %>
<%@ include file="../calendar/calendarframe.jsp"%>
<%
boolean privAdd = true; 
boolean privUpdate = true;
boolean privDelete = true;
boolean masterPriv = true;
boolean masterPrivView = true;
boolean masterPrivUpdate = true; 
%>
<!-- Jsp Block -->

<%!
    
    public static double getStockByStatus(long locationId, long oidItemMaster, String status, String gol_price ){
        double result=0;
        String sql="";
        CONResultSet crs = null;
        try{
            
           sql =" select sum(qty * in_out) from pos_stock where status='" + status + "' and item_master_id=" + oidItemMaster ;
                
           if(locationId !=0){
               sql = sql + " and location_id=" + locationId ;
           }else{
               sql=sql+" and location_id in (select location_id from pos_location where gol_price='"+gol_price+ "')";
           }
           
           try{
               crs = CONHandler.execQueryResult(sql);
               ResultSet rs = crs.getResultSet();
               while(rs.next()){
                     result = rs.getDouble(1);
               }
           } catch(Exception ex){
               
           }
        }catch(Exception ex){
            
        }
        return result;
    } 
    public static Vector getSalesPromotionReportPerLocation(int start, int recordToGet, Date startDate, Date endDate, 
            String golPrice, long locationId, String code, String barcode, String nama){
            String sql = 
                " select tb1.golPrice, tb1.sku, tb1.barcode, tb1.namaItem, tb1.startDatePromo, tb1.endDatePromo,tb1.last_price as lastPrice, tb2.hargaJual as harga_reguler,(tb2.hargaJual- tb1.diskon) as harga_promo, tb2.totqty, (tb2.totqty * tb2.hargaJual) as total_reguler, ((tb2.hargaJual- tb1.diskon) * tb2.totqty) as total_promo,  ((tb2.totqty * tb2.hargaJual) - ((tb2.hargaJual- tb1.diskon) * tb2.totqty)) as refaksi, tb1.itemIdpromo as itemId from (( select loc.gol_price as golPrice, im.code as sku,im.barcode as barcode, im.name as namaItem, p.promotion_id as promoId,pi.item_master_id as itemIdpromo " +
                " , p.start_date as startDatePromo, p.end_date as endDatePromo, loc.location_id, pi.discount_value as diskon, tbv.last_price as last_price from pos_promotion p " +
                " inner join pos_promotion_location pl on p.promotion_id=pl.promotion_id inner join pos_promotion_item pi " +
                " on p.promotion_id=pi.promotion_id inner join pos_location loc on pl.location_id=loc.location_id " +
                " inner join pos_item_master im on pi.item_master_id=im.item_master_id inner join ((select item_master_id,vendor_id,last_price from pos_vendor_item group by item_master_id,vendor_id )) as tbv on (im.default_vendor_id=tbv.vendor_id and im.item_master_id=tbv.item_master_id) " +
                " where to_days(p.start_date) = to_days('" + JSPFormater.formatDate(startDate, "yyyy-MM-dd")+"') and " + 
                " to_days(p.end_date) = to_days('"+JSPFormater.formatDate(endDate, "yyyy-MM-dd")+"') " ;
                if(locationId !=0){
                    sql=sql+ " and loc.location_id=" + locationId + " and pl.location_id=" + locationId;
                    
                }
                               
                if(golPrice!= null && golPrice.length()>0){
                    sql=sql+ " and loc.gol_price='" + golPrice + "' " ;
                }
                if(code!= null && code.length()>0 && !code.equalsIgnoreCase("")){
                    sql=sql+ " and im.code='" + code + "' " ;
                }
                if(barcode!= null && barcode.length()>0 && !barcode.equalsIgnoreCase("")){
                    sql=sql+ " and im.barcode='" + barcode + "' " ;
                }
                if(nama!= null && nama.length()>0 && !nama.equalsIgnoreCase("")){
                    sql=sql+ " and im.name like '%" + nama + "%' " ;
                }
                sql=sql + " group by p.promotion_id,pi.item_master_id,loc.gol_price)) as tb1 inner join ";           
                
         
                String sqlgen="";
                String sql1 = 
                " (select sum(sd.qty) as qtySales, sd.selling_price as hargaJual, sd.discount_amount as diskonTotal, sd.product_master_id as itemId " +
                " from pos_sales_detail sd inner join pos_sales s on sd.sales_id=s.sales_id " +
                " where (s.type=0 or s.type=1) and (to_days(s.date) between to_days('"+JSPFormater.formatDate(startDate, "yyyy-MM-dd") +"') and to_days('"+JSPFormater.formatDate(endDate, "yyyy-MM-dd") +"')) " +
                " and sd.discount_amount <> 0 ";
                if(locationId !=0){
                    sql1=sql1 + " and s.location_id="+locationId ;
                }
                //if(golPrice.length()>0 && golPrice != null){
                 //   sql1=sql1+" and loc.gol_price='"+golPrice+"' " ;
               // }
                sql1 = sql1 + " group by sd.product_master_id) ";
                             
        String sql2=
                " (select (sum(sd.qty)*(-1)) as qtySales, sd.selling_price as hargaJual, sd.discount_amount as diskonTotal, sd.product_master_id as itemId " +
                " from pos_sales_detail sd inner join pos_sales s on sd.sales_id=s.sales_id " +
                " where (s.type=2 or s.type=3) and (to_days(s.date) between to_days('"+JSPFormater.formatDate(startDate, "yyyy-MM-dd") +"') and to_days('"+JSPFormater.formatDate(endDate, "yyyy-MM-dd") +"')) " +
                " and sd.discount_amount <> 0 ";
                if(locationId !=0){
                    sql2 = sql2 + " and s.location_id="+locationId ;
                }
                //if(golPrice.length()>0 && golPrice != null){
                 //   sql2 = sql2+" and loc.gol_price='"+golPrice+"' " ;
               // }
                sql2 = sql2 + " group by sd.product_master_id) ";
                
        sqlgen = " ((select itemId, sum(qtySales) as totqty, hargaJual, diskonTotal from (" + sql1 + " union " + sql2 + ") as tabel group by itemId )) as tb2 "; 

        sql=sql+sqlgen+" on tb1.itemIdpromo=tb2.itemId "  ;   
        //String sqlstock=""        ;
        //sqlstock="((select item_master_id, sum(qty*in_out) as stock from pos_stock where status='APPROVED' and to_days(date) < to_days('"+JSPFormater.formatDate(endDate, "yyyy-MM-dd")+"') ";
              //   if(locationId !=0){
               //      sqlstock=sqlstock + " and location_id="+locationId;
               //  }
               // sqlstock= sqlstock + " group by item_master_id )) as tb3";
        //sql=sql+" inner join "+ sqlstock + " on tb1.itemIdpromo=tb3.item_master_id ";
        CONResultSet crs = null;
        Vector result=new Vector();
        try{
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            
            while (rs.next()) {
                try{
               Vector temp = new Vector();
     
               //long itemId = rs.getLong("itemIdpromo");
               temp.add(rs.getString(1));//golongan
               temp.add(rs.getString(2));//sku
               temp.add(rs.getString(3));//barcode
               temp.add(rs.getString(4));//name
               
               temp.add(""+JSPFormater.formatDate(rs.getDate("startDatePromo"),"dd-MM-yyyy"));
               temp.add(""+JSPFormater.formatDate(rs.getDate("endDatePromo"),"dd-MM-yyyy"));
               temp.add(""+rs.getDouble("lastPrice"));
               temp.add(""+rs.getDouble("harga_reguler"));//harga jual
               temp.add(""+rs.getDouble("harga_promo"));//diskon
               temp.add(""+rs.getDouble("totqty"));//total qty sales
               temp.add(""+rs.getDouble("total_reguler"));//diskon
               temp.add(""+rs.getDouble("total_promo"));//diskon
               temp.add(""+rs.getDouble("refaksi"));//diskon
               double soh = 0;
               soh = getStockByStatus(locationId,rs.getLong("itemId"),"APPROVED",golPrice);
               temp.add(""+soh);
               result.add(temp);
               
               }catch(Exception ex){
                   
               }
           }
        }catch(Exception e){
            System.out.println(e.toString());
        }
        finally{
            CONResultSet.close(crs);
        }
        
        return result;
        
    }
    public static Vector getSalesPromotionReportAllLocation(int start, int recordToGet, Date startDate, Date endDate, 
            String golPrice, long locationId, String code, String barcode, String nama){
            String sql = 
                 " select tba.golPrice, tba.sku, tba.barcode, tba.namaItem, tba.startDatePromo, tba.endDatePromo,tba.last_price as lastPrice, tb2.hargaJual as harga_reguler,(tb2.hargaJual- tba.diskon) as harga_promo, tb2.totqty, (tb2.totqty * tb2.hargaJual) as total_reguler, ((tb2.hargaJual- tba.diskon) * tb2.totqty) as total_promo,  ((tb2.totqty * tb2.hargaJual) - ((tb2.hargaJual- tba.diskon) * tb2.totqty)) as refaksi, tba.itemIdpromo as itemId from (( select tb1.golPrice, tb1.sku, tb1.barcode, tb1.namaItem, tb1.promoId,tb1.itemIdpromo " +
                " , tb1.startDatePromo, tb1.endDatePromo, tb1.location_id, tb1.diskon, vi.last_price as last_price from ((" +
                " select im.default_vendor_id, loc.gol_price as golPrice, im.code as sku,im.barcode as barcode, im.name as namaItem, p.promotion_id as promoId,pi.item_master_id as itemIdpromo " +
                " , p.start_date as startDatePromo, p.end_date as endDatePromo, loc.location_id, pi.discount_value as diskon from pos_promotion p " +
                " inner join pos_promotion_location pl on p.promotion_id=pl.promotion_id inner join pos_promotion_item pi " +
                " on p.promotion_id=pi.promotion_id inner join pos_location loc on pl.location_id=loc.location_id " +
                " inner join pos_item_master im on pi.item_master_id=im.item_master_id " +
                " where to_days(p.start_date) = to_days('" + JSPFormater.formatDate(startDate, "yyyy-MM-dd")+"') and " + 
                " to_days(p.end_date) = to_days('"+JSPFormater.formatDate(endDate, "yyyy-MM-dd")+"') " ;
                
                               
                if(golPrice!= null && golPrice.length()>0){
                    sql=sql+ " and loc.gol_price='" + golPrice + "' " ;
                }
                if(code!= null && code.length()>0 && !code.equalsIgnoreCase("")){
                    sql=sql+ " and im.code='" + code + "' " ;
                }
                if(barcode!= null && barcode.length()>0 && !barcode.equalsIgnoreCase("")){
                    sql=sql+ " and im.barcode='" + barcode + "' " ;
                }
                if(nama!= null && nama.length()>0 && !nama.equalsIgnoreCase("")){
                    sql=sql+ " and im.name like '%" + nama + "%' " ;
                }
                sql=sql + " group by p.promotion_id,pi.item_master_id,loc.gol_price)) as tb1 inner join ((select item_master_id, vendor_id,last_price from pos_vendor_item group by item_master_id,vendor_id)) as vi on (tb1.default_vendor_id=vi.vendor_id and tb1.itemIdpromo=vi.item_master_id)  )) as tba inner join ";           
                //sql=sql + " group by p.promotion_id,pi.item_master_id,loc.gol_price))    as tb1 inner join ";     
         
                String sqlgen="";
                String sql1 = 
                " (select sum(sd.qty) as qtySales, sd.selling_price as hargaJual, sd.discount_amount as diskonTotal, sd.product_master_id as itemId " +
                " from pos_sales_detail sd inner join pos_sales s on sd.sales_id=s.sales_id inner join pos_location loc on s.location_id=loc.location_id " +
                " where (s.type=0 or s.type=1) and (to_days(s.date) between to_days('"+JSPFormater.formatDate(startDate, "yyyy-MM-dd") +"') and to_days('"+JSPFormater.formatDate(endDate, "yyyy-MM-dd") +"')) " +
                " and sd.discount_amount <> 0 ";
                if(locationId !=0){
                    sql1=sql1 + " and s.location_id="+locationId ;
                }
                if(golPrice.length()>0 && golPrice != null){
                    sql1=sql1+" and loc.gol_price='"+golPrice+"' " ;
                }
                sql1 = sql1 + " group by sd.product_master_id) ";
                             
        String sql2=
                " (select (sum(sd.qty)*(-1)) as qtySales, sd.selling_price as hargaJual, sd.discount_amount as diskonTotal, sd.product_master_id as itemId " +
                " from pos_sales_detail sd inner join pos_sales s on sd.sales_id=s.sales_id inner join pos_location loc on s.location_id=loc.location_id " +
                " where (s.type=2 or s.type=3) and (to_days(s.date) between to_days('"+JSPFormater.formatDate(startDate, "yyyy-MM-dd") +"') and to_days('"+JSPFormater.formatDate(endDate, "yyyy-MM-dd") +"')) " +
                " and sd.discount_amount <> 0 ";
                if(locationId !=0){
                    sql2 = sql2 + " and s.location_id="+locationId ;
                }
                if(golPrice.length()>0 && golPrice != null){
                    sql2 = sql2+" and loc.gol_price='"+golPrice+"' " ;
                }
                sql2 = sql2 + " group by sd.product_master_id) ";
                
        sqlgen = " ((select itemId, sum(qtySales) as totqty, hargaJual, diskonTotal from (" + sql1 + " union " + sql2 + ") as tabel group by itemId )) as tb2 "; 

        sql=sql+sqlgen+" on tba.itemIdpromo=tb2.itemId "  ;      
        
        
        CONResultSet crs = null;
        Vector result=new Vector();
        try{
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            
            while (rs.next()){
                try{
               Vector temp = new Vector();
     
               //long itemId = rs.getLong("itemIdpromo");
               temp.add(rs.getString(1));//golongan
               temp.add(rs.getString(2));//sku
               temp.add(rs.getString(3));//barcode
               temp.add(rs.getString(4));//name
               
               temp.add(""+JSPFormater.formatDate(rs.getDate("startDatePromo"),"dd-MM-yyyy"));
               temp.add(""+JSPFormater.formatDate(rs.getDate("endDatePromo"),"dd-MM-yyyy"));
               temp.add(""+rs.getDouble("lastPrice"));           
               temp.add(""+rs.getDouble("harga_reguler"));//harga jual
               temp.add(""+rs.getDouble("harga_promo"));//diskon
               temp.add(""+rs.getDouble("totqty"));//total qty sales
               temp.add(""+rs.getDouble("total_reguler"));//diskon
               temp.add(""+rs.getDouble("total_promo"));//diskon
               temp.add(""+rs.getDouble("refaksi"));//diskon
               double soh = 0;
               soh = getStockByStatus(0,rs.getLong("itemId"),"APPROVED",golPrice);
               temp.add(""+soh);
               result.add(temp);
               
               }catch(Exception ex){
                   
               }
           }
        }catch(Exception e){
            System.out.println(e.toString());
        }
        finally{
            CONResultSet.close(crs);
        }
        
        return result;
        
    }
    
   

%>
<%

if(session.getValue("REPORT_SALES_PROMOTION")!=null){ 
	session.removeValue("REPORT_SALES_PROMOTION");
}  
if(session.getValue("REPORT_SALES_PROMOTION_LOCATION")!=null){ 
	session.removeValue("REPORT_SALES_PROMOTION_LOCATION");
}           
if(session.getValue("REPORT_SALES_ALL_LOCATION")!=null){ 
	session.removeValue("REPORT_SALES_ALL_LOCATION");
} 
JSPLine jspLine = new JSPLine();
int start = JSPRequestValue.requestInt(request, "start");            
int recordToGet = JSPRequestValue.requestInt(request, "src_diplay_limit");
String strdate1 = JSPRequestValue.requestString(request, "start_date");
String strdate2 = JSPRequestValue.requestString(request, "end_date");                           
Date startDate = (strdate1 == null) ? new Date() : JSPFormater.formatDate(strdate1, "dd/MM/yyyy");
Date endDate = (strdate2 == null) ? new Date() : JSPFormater.formatDate(strdate2, "dd/MM/yyyy");
int chkInvDate = 0;            
String golPrice = JSPRequestValue.requestString(request, "src_gol_price"); 
int sortBy = JSPRequestValue.requestInt(request, "src_sort_by");
String srcGroupCat = JSPRequestValue.requestString(request, "src_group_cat"); 
int iJSPCommand = JSPRequestValue.requestCommand(request);
int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
int sortType = JSPRequestValue.requestInt(request, "src_sort_type");
long locationId = JSPRequestValue.requestLong(request, "src_location_id");
String srcnama = JSPRequestValue.requestString(request, "src_nama");
String srccode = JSPRequestValue.requestString(request, "src_code");
String srcbarcode = JSPRequestValue.requestString(request, "src_barcode");
int allLocation = JSPRequestValue.requestInt(request, "all_location");
Vector vLocGolPrice= new Vector();
if (userLocations != null && userLocations.size() > 0) {
if(golPrice.equalsIgnoreCase("") || golPrice ==null){
    golPrice="gol_1";
}
    for(int i=0;i<userLocations.size();i++){
        Location loc = new Location();
        loc =  (Location)userLocations.get(i);
        try{
            loc =  DbLocation.fetchExc(loc.getOID());
        }catch(Exception ex){
            
        }
        if(loc.getGol_price().equalsIgnoreCase(golPrice)){
            vLocGolPrice.add(loc);
        }
        
    }
}
String whereLoc="";
            Vector vLocSelected= new Vector();
             if (vLocGolPrice != null && vLocGolPrice.size() > 0) {
                    for (int i = 0; i < vLocGolPrice.size(); i++) {
                        Location ic = (Location) vLocGolPrice.get(i);
                        
                        
                        int ok = JSPRequestValue.requestInt(request, "location_id" + ic.getOID());
                        if (ok == 1){
                            vLocSelected.add(ic);
                            if (whereLoc != null && whereLoc.length() > 0) {
                                whereLoc = whereLoc + ",";
                            }
                            whereLoc = whereLoc + ic.getOID();
                        }
                    }
                    

                }

//hanya untuk start   
int vectSize = 0; 
  
Vector result = new Vector();  
Vector vresult = new Vector();
Vector utama = new Vector();
if(iJSPCommand == JSPCommand.SEARCH || iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV ||
	iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST){ 
	
	//vectSize = SessCogsBySection.getCountSalesPromotionReport(startDate, endDate, srcGroupCat, golPrice, locationId);

	CmdItemMaster ctrlItemMaster = new CmdItemMaster(request); 
	start = ctrlItemMaster.actionList(iJSPCommand, start, vectSize, recordToGet);
	if(vLocSelected.size()>0){
            for(int i=0;i<vLocSelected.size();i++){
                Location loc = new Location();
                loc = (Location) vLocSelected.get(i);
            result = new Vector();  
            if(allLocation==1)             {
                result = getSalesPromotionReportAllLocation(start, recordToGet, startDate, endDate, golPrice, 0, srccode,srcbarcode,srcnama );
                
            }else{
                result = getSalesPromotionReportPerLocation(start, recordToGet, startDate, endDate, golPrice, loc.getOID(), srccode,srcbarcode,srcnama );
            }
            

            Vector rptParam = new Vector(); 
            rptParam.add(startDate); 
            rptParam.add(endDate);
            rptParam.add(golPrice);
            rptParam.add(srcGroupCat);
            rptParam.add(""+sortBy);
            rptParam.add(""+sortType);
            rptParam.add(""+locationId);
            //session.putValue("REPORT_PROMO_GOL_PRICE", rptParam);
            //vresult.add(loc.getName());
            vresult.add(result);
            //utama.add(vresult);
            if(allLocation==1){
                break;
            }
            }
            session.putValue("REPORT_SALES_PROMOTION", vresult);  
            session.putValue("REPORT_SALES_PROMOTION_LOCATION", vLocSelected); 
            session.putValue("REPORT_SALES_ALL_LOCATION", ""+allLocation); 
	}
}  

//out.println(result); 

%>
<html >
    <!-- #BeginTemplate "/Templates/indexsl.dwt" --> 
    <head>
        <!-- #BeginEditable "javascript" --> 
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <title>Sales System</title>
        <link href="../css/csssl.css" rel="stylesheet" type="text/css" />
        <script language="JavaScript">            
            <%if (!masterPriv || !masterPrivView) {%>
                window.location="<%=approot%>/nopriv.jsp"; 
            <%}%>
            
            function cmdPrintJournal(){	                       
                window.open("<%=printroot%>.report.RptSalesPromotionXLS?user_id=<%=appSessUser.getUserOID()%>&lang=<%=lang%>","",'scrollbars=yes,status=yes,width=750,height=600,resizable=yes');
            }
            function cmdReloadLoc(){
                 document.frmsales.command.value="<%=JSPCommand.NONE%>";
                 document.frmsales.action="rptsalespromotionbygolprice.jsp";
                 document.frmsales.submit();
             }
            function cmdSearch(){
                document.frmsales.command.value="<%=JSPCommand.SEARCH%>";
                document.frmsales.action="rptsalespromotionbygolprice.jsp?menu_idx=<%=menuIdx%>";
                document.frmsales.submit();
            }
		 function setCheckedLocation(val){
                     <%
                    for (int k = 0; k < vLocGolPrice.size(); k++) {
                    Location ic = (Location) vLocGolPrice.get(k);
                    %>
                        document.frmsales.location_id<%=ic.getOID()%>.checked=val.checked;

                    <%}%>
                } 	
			function cmdListFirst(){
				document.frmsales.command.value="<%=JSPCommand.FIRST%>";
				document.frmsales.action="rptsalespromotionbygolprice.jsp";
				document.frmsales.submit();
			}
			
			function cmdListPrev(){
				document.frmsales.command.value="<%=JSPCommand.PREV%>";
				document.frmsales.action="rptsalespromotionbygolprice.jsp";
				document.frmsales.submit();
				}
			
			function cmdListNext(){
				document.frmsales.command.value="<%=JSPCommand.NEXT%>";
				document.frmsales.action="rptsalespromotionbygolprice.jsp";
				document.frmsales.submit();
			}
			
			function cmdListLast(){
				document.frmsales.command.value="<%=JSPCommand.LAST%>";
				document.frmsales.action="rptsalespromotionbygolprice.jsp";
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
																											<input type="hidden" name="vectSize" value="<%=vectSize%>">

                                                                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                                                <tr> 
                                                                                                                    <td valign="top"> 
                                                                                                                        <table width="100%" border="0" cellspacing="1" cellpadding="1" height="17">
                                                                                                                            <tr valign="bottom"> 
                                                                                                                                
                                                            <td width="60%" height="23"><b><font color="#990000" class="lvl1">Sales 
                                                              Report </font><font class="tit1">&raquo; 
                                                              <span class="lvl2">Sales 
                                                              Promotion by Gol 
                                                              Price<br>
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
                                                                  <td width="9%" height="14" nowrap>&nbsp;</td>
                                                                  <td colspan="2" height="14">&nbsp;</td>
                                                                </tr>
                                                                <tr> 
                                                                  <td width="9%" height="22" nowrap>Promotion 
                                                                    Between</td>
                                                                  <td colspan="3" height="22"> 
                                                                    <table cellpadding="0" cellspacing="0">
                                                                      <tr> 
                                                                        <td > 
                                                                          <input name="start_date" value="<%=JSPFormater.formatDate((startDate == null) ? new Date() : startDate, "dd/MM/yyyy")%>" size="11" style="text-align:center" readOnly>
                                                                        </td>
                                                                        <td> <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmsales.start_date);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt="visit date"></a> 
                                                                        </td>
                                                                        <td> &nbsp;&nbsp;and&nbsp;&nbsp; 
                                                                        </td>
                                                                        <td> 
                                                                          <input name="end_date" value="<%=JSPFormater.formatDate((endDate == null) ? new Date() : endDate, "dd/MM/yyyy")%>" size="11" style="text-align:center" readOnly>
                                                                        </td>
                                                                        <td> <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmsales.end_date);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt="visit date"></a> 
                                                                        </td>
                                                                      </tr>
                                                                    </table>
                                                                  </td>
                                                                </tr>
                                                                
                                                                <tr> 
                                                                  <td width="9%" height="22">Gol 
                                                                    Price </td>
                                                                  <td colspan="2" height="22"> 
                                                                    <%
																																		Vector golP = SessCogsBySection.getAvailableGolPrice();
																																																					%>
                                                                    <select name="src_gol_price" onchange="javascript:cmdReloadLoc()">
                                                                        
                                                                      <%if (golP != null && golP.size() > 0){
																																			for (int i = 0; i < golP.size(); i++) {
																																				String usx = (String) golP.get(i);
																																																						%>
                                                                      <option value="<%=usx%>" <%if (usx.equals(golPrice)) {%>selected<%}%>><%=usx.toUpperCase()%></option>
                                                                      <%}
																																		}%>
                                                                    </select>
                                                                  </td>
                                                                </tr>
                                                                  <tr height="24"> 
                                                                                                            <td valign="top">Location</td>
                                                                                                            
                                                                                                            <td colspan="6" >                                                                                                                                                             
                                                                                                                <%
                                                                                                    if (vLocGolPrice != null && vLocGolPrice.size() > 0) {
                                                                                                                %>
                                                                                                                <table width="800" border="0" cellpadding="0" cellspacing="0">
                                                                                                                    <%
                                                                                                                    int x = 0;
                                                                                                                    boolean ok = true;
                                                                                                                    while (ok) {

                                                                                                                        for (int t = 0; t < 5; t++) {
                                                                                                                            Location ic = new Location();
                                                                                                                            try {
                                                                                                                                ic = (Location) vLocGolPrice.get(x);
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
                                                                                                                        <%if (t == 4) {
                                                                                                                        %>
                                                                                                                    </tr>
                                                                                                                    <%}%>
                                                                                                                    <%
                                                                                                                            x++;
                                                                                                                        }
                                                                                                                    }%>
                                                                                                                    <%if(true){ //if(totLocationxAll==userLocations.size()){%>
                                                                                                                    <tr>
                                                                                                                        <td><input type="checkbox" name="all_location" value="1" <%if (allLocation == 1) {%> checked <%}%>   onClick="setCheckedLocation(this)"></td>
                                                                                                                        <td class="fontarial">ALL LOCATION</td>
                                                                                                                    </tr>   
                                                                                                                    <%}%>
                                                                                                                </table>
                                                                                                                <%}%>                                                                                                                                                       
                                                                                                            </td>                                                                                                                                                       
                                                                                                        </tr> 
                                                                
                                                                
                                                                <tr> 
                                                                  <td width="9%" height="22">Item Name</td>
                                                                  <td colspan="2" height="22"> 
                                                                    <input type="text" name="src_nama" values="<%=srcnama%>"></input>
                                                                  </td>
                                                                </tr>
                                                                <tr> 
                                                                  <td width="9%" height="22">Sku </td>
                                                                  <td width="30%" height="22"> 
                                                                      <input type="text" value="<%=srccode%>" name="src_code"></input>
                                                                  </td>
                                                                  
                                                                </tr>
                                                                <tr> 
                                                                  <td width="9%" height="22">Barcode</td>
                                                                  <td width="30%" height="22"> 
                                                                    <input type="text" value="<%= srcbarcode %>" name="src_barcode"></input>
                                                                  </td>
                                                                  <td width="61%" height="22">&nbsp;</td>
                                                                </tr>
                                                                <tr> 
                                                                  <td width="9%" height="33"><a href="javascript:cmdSearch()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new2','','../images/search2.gif',1)"><img src="../images/search.gif" name="new2" border="0"></a></td>
                                                                  <td width="30%" height="33">&nbsp;</td>
                                                                  <td width="61%" height="33">&nbsp;</td>
                                                                </tr>
                                                                <tr> 
                                                                  <td width="9%" height="15">&nbsp;</td>
                                                                  <td width="30%" height="15">&nbsp; 
                                                                  </td>
                                                                  <td width="61%" height="15">&nbsp;</td>
                                                                </tr>
                                                              </table>
																																																	</td>
																																																</tr>
																																<%
																																if (vLocSelected != null && vLocSelected.size() >0 ){
                                                                                                                                                                                                                                                                    for(int b=0;b<vLocSelected.size();b++){
                                                                                                                                                                                                                                                                        result = new Vector();
                                                                                                                                                                                                                                                                        Location lok = new Location();
                                                                                                                                                                                                                                                                        lok = (Location) vLocSelected.get(b);
                                                                                                                                                                                                                                                                        result = (Vector)vresult.get(b);
																																%>
                                                                                                                                                                                                                                                                 <%if(allLocation==1){%>
                                                                                                                                                                                                                                                                 <tr><td><b>Location : All location </b></td></tr>
                                                                                                                                                                                                                                                                 <%}else{%>
                                                                                                                                                                                                                                                                 <tr><td><b>Location : <%=lok.getName() %> </b></td></tr>
                                                                                                                                                                                                                                                                 <%}%>
																																<tr align="left" valign="top"> 
																																	<td height="22" valign="middle" colspan="4"> 
																																																		
																																  
                                                              <table width="100%" border="0" cellspacing="1" cellpadding="0">
                                                                
                                                                <tr height="20"> 
                                                                  <td class="tablehdr" width="6%" nowrap><font size="1">Golongan</font></td>
                                                                  <td class="tablehdr" width="18%" nowrap ><font size="1">SKU</font></td>
                                                                  <td class="tablehdr" width="18%" nowrap ><font size="1">Barcode</font></td>
                                                                  <td class="tablehdr" width="18%" nowrap ><font size="1">Item</font></td>
                                                                  <td class="tablehdr" width="8%" nowrap><font size="1">Start 
                                                                    Date </font></td>
                                                                  <td class="tablehdr" width="8%" nowrap><font size="1">End 
                                                                    Date </font></td>
                                                                  <td class="tablehdr" width="7%" nowrap><font size="1">Harga Beli</font></td>
                                                                  <td class="tablehdr" width="7%" nowrap><font size="1">Harga Reguler</font></td>
                                                                  <td class="tablehdr" width="8%" nowrap><font size="1">Harga Promo
                                                                    </font></td>
                                                                  
                                                                  <td class="tablehdr" width="5%" nowrap><font size="1">Qty</font></td>
                                                                  <td class="tablehdr" width="8%" nowrap><font size="1">Total Reguler</font></td>
                                                                  <td class="tablehdr" width="8%" nowrap><font size="1">Total Promo</font></td>
                                                                  <td class="tablehdr" width="4%" nowrap><font size="1">Total Refaksi</font></td>
                                                                  <td class="tablehdr" width="4%" nowrap><font size="1">SOH</font></td>
                                                                </tr>
                                                                <%
																																	Vector vDetail = new Vector();
																																	for(int i=0; i<result.size(); i++){ 
																																		Vector v = (Vector)result.get(i);
                                                                                                                                                                                                                                                                                Vector temp = new Vector();
																																		String gol = (String)v.get(0);
                                                                                                                                                                                                                                                                                String sku = (String)v.get(1);
                                                                                                                                                                                                                                                                                String barcode = (String)v.get(2);
																																		String itemName = (String)v.get(3);
                                                                                                                                                                                                                                                                                String stDate = (String)v.get(4);//JSPFormater.formatDate((Date)v.get(4),"yyyy-MM-dd");
																																		String enDate = (String)v.get(5);//JSPFormater.formatDate((Date)v.get(5),"yyyy-MM-dd");
                                                                                                                                                                                                                                                                                //double diskon = Double.parseDouble((String)v.get(8));
                                                                                                                                                                                                                                                                                double lastPrice = Double.parseDouble((String)v.get(6));
                                                                                                                                                                                                                                                                                double hargaReg = Double.parseDouble((String)v.get(7));
                                                                                                                                                                                                                                                                                double hargaPromo = Double.parseDouble((String)v.get(8));
                                                                                                                                                                                                                                                                                
                                                                                                                                                                                                                                                                                double qty = Double.parseDouble((String)v.get(9));
                                                                                                                                                                                                                                                                                double totalReguler = Double.parseDouble((String)v.get(10));
                                                                                                                                                                                                                                                                                double totalPromo = Double.parseDouble((String)v.get(11));
																																                double totalRefaksi = Double.parseDouble((String)v.get(12));                                                                                                                                                                                                                                                            
                                                                                                                                                                                                                                                                                double soh = Double.parseDouble((String)v.get(13));                   
																																		
																																		
																																		
																																		
																																																			
																																	%>
                                                                <tr height="20"> 
                                                                  <td class="tablecell" align="center" width="6%" nowrap><font size="1"><%=gol%></font></td>
                                                                  <%temp.add(""+gol);%>
                                                                  <td class="tablecell" align="left" width="18%" nowrap><font size="1"><%=sku%></font></td>
                                                                  <%temp.add(""+sku);%>
                                                                  <td class="tablecell" align="left" width="18%" nowrap><font size="1"><%=barcode%></font></td>
                                                                  <%temp.add(""+barcode);%>
                                                                  <td class="tablecell" align="left" width="18%" nowrap><font size="1"><%=itemName%></font></td>
                                                                  <%temp.add(""+itemName);%>
                                                                  <td class="tablecell" align="right" width="8%" nowrap> 
                                                                    <div align="center"><%=stDate%></div>
                                                                    <%temp.add(""+stDate);%>
                                                                  </td>
                                                                  <td class="tablecell" align="right" width="8%" nowrap> 
                                                                    <div align="center"><%=enDate%></div>
                                                                     <%temp.add(""+enDate);%>
                                                                  </td>
                                                                  <td class="tablecell" align="right" width="7%" nowrap><font size="1"><%=JSPFormater.formatNumber(lastPrice, "#,###.##")%></font></td>
                                                                  <td class="tablecell" align="right" width="7%" nowrap><font size="1"><%=JSPFormater.formatNumber(hargaReg, "#,###.##")%></font></td>
                                                                  <%temp.add(""+JSPFormater.formatNumber(hargaReg, "#,###.##"));%>
                                                                  <td class="tablecell" align="right" width="8%" nowrap><font size="1"><%=JSPFormater.formatNumber(hargaPromo, "#,###.##")%></font></td>
                                                                  <%temp.add(""+JSPFormater.formatNumber(hargaPromo, "#,###.##"));%>
                                                                  <td class="tablecell" align="right" width="4%" nowrap><font size="1"><%=JSPFormater.formatNumber(qty, "#,###.##")%></font></td>
                                                                  <%temp.add(""+JSPFormater.formatNumber(qty, "#,###.##"));%>
                                                                  <td class="tablecell" align="right" width="5%" nowrap><font size="1"><%=JSPFormater.formatNumber(totalReguler, "#,###.##")%></font></td>
                                                                  <%temp.add(""+JSPFormater.formatNumber(totalReguler, "#,###.##"));%>
                                                                  <td class="tablecell" align="right" width="8%" nowrap><font size="1"><%=JSPFormater.formatNumber(totalPromo, "#,###.##")%></font></td>
                                                                  <%temp.add(""+JSPFormater.formatNumber(totalPromo, "#,###.##"));%>
                                                                  <td class="tablecell" align="right" width="8%" nowrap><font size="1"><%=JSPFormater.formatNumber(totalRefaksi, "#,###.##")%></font></td>
                                                                  <%temp.add(""+JSPFormater.formatNumber(totalRefaksi, "#,###.##"));%>
                                                                  <td class="tablecell" align="right" width="8%" nowrap><font size="1"><%=JSPFormater.formatNumber(soh, "#,###.##")%></font></td>
                                                                  <% vDetail.add(temp);  %>
                                                                </tr>
                                                                <%}%>
                                                                
                                                               
                                                              </table>
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                           
                                                                                                                                
                                                                                                                            <%
                                                                                                                                if(allLocation==1)                                                                                                                                          {
                                                                                                                                break;
                                                                                                                                }
                                                                                                                                                                                                                                                                    }
                                                                                                                          
                                                                                                                          }%>
                                                                                                                        </table>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                                <tr align="left" valign="top"> 
                                                                                                                                <td height="22" valign="middle" colspan="4"> 
                                                                                                                                    <a href="javascript:cmdPrintJournal()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('print','','../images/print2.gif',1)"><img src="../images/print.gif" name="print" width="53" height="22" border="0"></a>
                                                                                                                                </td>     
                                                                                                                </tr> 
                                                                                                                 <tr> 
                                                                  <td colspan="12"><span class="command"> 
                                                                    <% 
								   int cmd = 0;
									   if ((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV )|| 
										(iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST))
											cmd =iJSPCommand; 
								   else{
									  if(iJSPCommand == JSPCommand.NONE || prevJSPCommand == JSPCommand.NONE)
										cmd = JSPCommand.FIRST;
									  else 
									  	cmd =prevJSPCommand; 
								   } 
							    %>
                                                                    <% jspLine.setLocationImg(approot+"/images/ctr_line");
							   	jspLine.initDefault();
								jspLine.setFirstImage("<img name=\"Image23x\" border=\"0\" src=\""+approot+"/images/first.gif\" alt=\"First\">");
								   jspLine.setPrevImage("<img name=\"Image24x\" border=\"0\" src=\""+approot+"/images/prev.gif\" alt=\"Prev\">");
								   jspLine.setNextImage("<img name=\"Image25x\" border=\"0\" src=\""+approot+"/images/next.gif\" alt=\"Next\">");
								   jspLine.setLastImage("<img name=\"Image26x\" border=\"0\" src=\""+approot+"/images/last.gif\" alt=\"Last\">");
								   
								   jspLine.setFirstOnMouseOver("MM_swapImage('Image23x','','"+approot+"/images/first2.gif',1)");
								   jspLine.setPrevOnMouseOver("MM_swapImage('Image24x','','"+approot+"/images/prev2.gif',1)");
								   jspLine.setNextOnMouseOver("MM_swapImage('Image25x','','"+approot+"/images/next2.gif',1)");
								   jspLine.setLastOnMouseOver("MM_swapImage('Image26x','','"+approot+"/images/last2.gif',1)");
								 %>
                                                                    <%=jspLine.drawImageListLimit(cmd,vectSize,start,recordToGet)%> 
                                                                    </span> </td>
                                                                </tr>
                                                                                                                
                                                                                                                <tr align="left" valign="top"> 
                                                                                                                    <td height="8" valign="middle" colspan="3">&nbsp; 
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

