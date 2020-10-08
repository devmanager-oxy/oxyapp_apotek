<%-- 
    Document   : stockbalance
    Created on : Jan 24, 2013, 9:10:40 AM
    Author     : Ngurah Wirata
--%>
<%@ page import = "com.project.ccs.postransaction.transfer.*" %>
<%@ page import = "com.project.ccs.postransaction.receiving.*" %>
<%@ page import = "com.project.ccs.postransaction.repack.*" %>
<%@ page import = "com.project.ccs.postransaction.costing.*" %>
<%@ page import = "com.project.ccs.postransaction.sales.*" %>
<%@ page import = "com.project.ccs.postransaction.stock.*" %>
<%@ page import = "com.project.ccs.postransaction.adjusment.*" %>
<%@ page import = "com.project.ccs.postransaction.opname.*" %>
<%@ page import = "com.project.ccs.posmaster.*" %>
<%@ page import = "com.project.general.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.util.*" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<%
            String approot = "/oxyapp/ims/";
            Date srcStartDate = new Date();
            Date srcStartDateKolom = new Date();
            Date srcStartDateTemp = new Date();
            Date srcEndDate = new Date();
            int iJSPCommand = JSPRequestValue.requestCommand(request);
            String startDate = JSPRequestValue.requestString(request, "src_start_date");
            String endDate = JSPRequestValue.requestString(request, "src_end_date");
            long srcType = JSPRequestValue.requestLong(request, "src_type");
            String srcStatus = JSPRequestValue.requestString(request, "src_status");
            if (startDate != "") {
                srcStartDate = JSPFormater.formatDate(startDate, "dd/MM/yyyy");
                srcStartDateKolom = JSPFormater.formatDate(startDate, "dd/MM/yyyy");
                srcStartDateTemp = JSPFormater.formatDate(startDate, "dd/MM/yyyy");
                srcEndDate = JSPFormater.formatDate(endDate, "dd/MM/yyyy");
            }

            long start = srcStartDate.getTime();
            long end = srcEndDate.getTime();
            long lama = (end - start) / (24 * 60 * 60 * 1000);


%>
<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
<head>
<!-- #BeginEditable "javascript" --> 
<title></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<script language="JavaScript">
    
    function cmdSearch(){
        
        document.frmadjusment.command.value="<%=JSPCommand.FIRST%>";
        document.frmadjusment.action="stockbalance1.jsp";
        document.frmadjusment.submit();
    }
    function cmdTransferBalance(){
        
        document.frmadjusment.command.value="<%=JSPCommand.NEXT%>";
        document.frmadjusment.action="stockbalance1.jsp";
        document.frmadjusment.submit();
        
    }
    function cmdIncomingBalance(){
        
        document.frmadjusment.command.value="<%=JSPCommand.PREV%>";
        document.frmadjusment.action="stockbalance1.jsp";
        document.frmadjusment.submit();
        
    }
    </script>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>STOCK BALANCE</title>
    </head>
    <body>
        <h2>STOCK BALANCING</h2>
        <tr>
            
            <td>
                
                <form name="frmadjusment" method ="post" action="">
                    <input type="hidden" name="command" value="<%=iJSPCommand%>">
                    <table border="1">       
                        
                        <tr>
                            <td width="6%">Transaction Type</td>
                            <td width="38%" colspan="3"> 
                            <select name="src_type">
                                
                                <option value="0" <%if (srcType == 0) {%>selected<%}%>>Incoming</option>
                                <option value="1" <%if (srcType == 1) {%>selected<%}%>>Transfer</option>
                                <option value="2" <%if (srcType == 2) {%>selected<%}%>>Retur</option>
                                <option value="3" <%if (srcType == 3) {%>selected<%}%>>Costing</option>
                                <option value="4" <%if (srcType == 4) {%>selected<%}%>>Repack</option>
                                <option value="5" <%if (srcType == 5) {%>selected<%}%>>Adjusment</option>
                            </select>
                            
                        </tr>
                        <tr>
                            <td width="6%">Status</td>
                            <td width="38%" colspan="3"> 
                            <select name="src_status">
                                <option value="DRAFT" <%if (srcStatus == "DRAFT") {%>selected<%}%>>DRAFT</option>
                                <option value="APPROVED" <%if (srcStatus == "APPROVED") {%>selected<%}%>>APPROVED</option>
                                <option value="POSTED" <%if (srcStatus == "POSTED") {%>selected<%}%>>POSTED</option>
                                <option value="CHECKED" <%if (srcStatus == "CHECKED") {%>selected<%}%>>CHECKED</option>
                            </select>
                        </tr>
                        <tr> 
                            <td width="6%">Periode</td>
                            <td width="38%"> 
                                <input name="src_start_date" value="<%=JSPFormater.formatDate((srcStartDate == null) ? new Date() : srcStartDate, "dd/MM/yyyy")%>" size="11">
                                <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmadjusment.src_start_date);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> 
                                &nbsp;&nbsp;and&nbsp;&nbsp; 
                                <input name="src_end_date" value="<%=JSPFormater.formatDate((srcEndDate == null) ? new Date() : srcEndDate, "dd/MM/yyyy")%>" size="11">
                                <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmadjusment.src_end_date);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> 
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <table>
                                    <tr>
                                        <td width="6%"><a href="javascript:cmdSearch()">Search</a></td>
                                        
                                    </tr>
                                </table>
                            </td>
                            
                        </tr>
                    </table>
                    <%if (iJSPCommand == JSPCommand.NEXT) {
            
            }

            if (iJSPCommand == JSPCommand.PREV) {

                Vector vop = DbOpname.list(0, 0, "status='POSTED'", "");
                for (int ii = 0; ii < vop.size(); ii++) {
                    Opname op = new Opname();
                    op = (Opname) vop.get(ii);
                    Vector vopi = new Vector();
                    vopi = DbOpnameItem.list(0, 1, "opname_id=" + op.getOID(), "");
                    OpnameItem opit = new OpnameItem();
                    opit = (OpnameItem) vopi.get(0);

                    ItemMaster ima = new ItemMaster();
                    try {
                        opit = DbOpnameItem.fetchExc(opit.getOID());
                        ima = DbItemMaster.fetchExc(opit.getItemMasterId());
                    } catch (Exception ex) {}

                    //proses add to opname item dan stock
                    Vector vst = DbItemMaster.list(0, 0, "item_group_id=" + ima.getItemGroupId() + " and item_master_id not in(select item_master_id from pos_opname_item)", "");
                    ItemMaster im = new ItemMaster();
                    for (int i = 0; i < vst.size(); i++) {
                        im = (ItemMaster) vst.get(i);

                        OpnameItem opi = new OpnameItem();
                        opi.setOpnameId(op.getOID());
                        opi.setDate(opit.getDate());
                        opi.setItemMasterId(im.getOID());
                        opi.setOpnameSubLocationId(opit.getOpnameSubLocationId());
                        opi.setSubLocationId(opit.getSubLocationId());
                        opi.setQtyReal(0);
                        opi.setType(0);

                        long oid1 = DbOpnameItem.insertExc(opi);

                        Stock st = new Stock();


                        st.setDate(opit.getDate());

                        st.setInOut(1);
                        st.setItemMasterId(im.getOID());
                        st.setLocationId(op.getLocationId());
                        st.setOpnameId(op.getOID());
                        st.setQty(0);
                        st.setStatus("APPROVED");
                        st.setType(5);
                        long oid = DbStock.insertExc(st);
                    }



                }



            /*  Vector vstock = DbStock.list(0, 0, "type=5 ", "");
            for(int i=0;i<vstock.size();i++){
            Stock st = (Stock) vstock.get(i);
            Stock sto = new Stock();
            try{
            sto= DbStock.fetchExc(st.getOID());
            }catch(Exception ex){
            }
            // DbStock.delete("item_master_id="+sto.getItemMasterId() + " and type!=5 and location_id="+ sto.getLocationId() + " and date < '"+ JSPFormater.formatDate(sto.getDate(),"yyyy-MM-dd HH:mm:ss") +"'" );
            DbStock.delete(" item_master_id="+sto.getItemMasterId() + " and type <> 5 and location_id="+ sto.getLocationId() + " and date < '"+ JSPFormater.formatDate(sto.getDate(),"yyyy-MM-dd HH:mm:ss") +"'" );
            }*/


            ///UNTUK MEMBALANCEKAN INCOMING
            //Vector vincom = new Vector();
            //vincom = DbReceive.list(0, 0, " status='CHECKED' and to_days(date) between to_days('" + JSPFormater.formatDate(srcStartDate,"yyyy-MM-dd") + "') and to_days('" + JSPFormater.formatDate(srcEndDate,"yyyy-MM-dd") +"')" , "");

            //for(int i=0;i< vincom.size();i++){
            //    Receive tr = new Receive();
            //    tr= (Receive) vincom.get(i);
            //if(DbStock.getCount("incoming_id="+ tr.getOID())==0){
            //        DbStock.delete(DbStock.colNames[DbStock.COL_INCOMING_ID]+"="+ tr.getOID());
            //        DbReceiveItem.proceedStock(tr);
            //}
            //}
            //iJSPCommand=JSPCommand.FIRST;
            }

                    %>
                    <%if (iJSPCommand == JSPCommand.FIRST) {%>
                    <tr>
                        <td>
                            <table border="1" width="100%">
                                <tr>
                                    <td>DATE</td>
                                    <td>NUMBER</td>
                                    <td>STATUS</td>
                                    <td>RECORD TRANS/RECORD STOCK</td>
                                    
                                </tr>
                                <%
    Vector vTrans = new Vector();
    if (srcType == 0) {
        vTrans = DbReceive.list(0, 0, "status='" + srcStatus + "' and type_ap=0 and to_days(date) between to_days('" + JSPFormater.formatDate(srcStartDate, "yyyy-MM-dd") + "') and to_days('" + JSPFormater.formatDate(srcEndDate, "yyyy-MM-dd") + "')", "");
        Receive rec = new Receive();
        if (vTrans.size() > 0) {
            for (int i = 0; i < vTrans.size(); i++) {
                rec = (Receive) vTrans.get(i);%>
                                <tr>
                                    <td><%= JSPFormater.formatDate(rec.getDate(), "dd-MM-yyyy")%></td>
                                    <td><%=rec.getNumber()%></td>
                                    <td><%=rec.getStatus()%></td>
                                    <%
                                            int stokTrans = 0;
                                            int stock = 0;
                                            stokTrans = DbReceiveItem.getCount(" receive_id=" + rec.getOID());
                                            stock = DbStock.getTotalStockByTransaksi(" incoming_id=" + rec.getOID() + " and location_id=" + rec.getLocationId());
                                    %>
                                    <%if (stock != stokTrans) {%>
                                    <td bgcolor="red"><%=stokTrans%>/<%=stock%></td> 
                                    <%} else {%>
                                    <td><%=stokTrans%>/<%=stock%></td> 
                                    
                                    <%}%>
                                </tr>
                                <%}
                                    }
                                
                                %>    
                                
                                
                                <%  } else if (srcType == 1) {

                                    vTrans = DbTransfer.list(0, 0, "status='" + srcStatus + "' and to_days(date) between to_days('" + JSPFormater.formatDate(srcStartDate, "yyyy-MM-dd") + "') and to_days('" + JSPFormater.formatDate(srcEndDate, "yyyy-MM-dd") + "')", "");

                                    Transfer rec = new Transfer();
                                    if (vTrans.size() > 0) {
                                        for (int i = 0; i < vTrans.size(); i++) {
                                            rec = (Transfer) vTrans.get(i);%>
                                <tr>
                                    <td><%= JSPFormater.formatDate(rec.getDate(), "dd-MM-yyyy")%></td>
                                    <td><%=rec.getNumber()%></td>
                                    <td><%=rec.getStatus()%></td>
                                    <%
                                        int stokTrans = 0;
                                        int stockTin = 0;
                                        int stockTout = 0;
                                        stokTrans = DbTransferItem.getCount(" transfer_id=" + rec.getOID());
                                        stockTout = DbStock.getTotalStockByTransaksi(" transfer_id=" + rec.getOID() + " and location_id=" + rec.getFromLocationId() + " and type=2");
                                        stockTin = DbStock.getTotalStockByTransaksi(" transfer_id=" + rec.getOID() + " and location_id=" + rec.getToLocationId() + " and type=3");


                                    %>
                                    <%if (rec.getStatus().equalsIgnoreCase("APPROVED")) {%>
                                    <%if (stockTin != stokTrans || stockTout != stokTrans) {%>
                                    <td bgcolor="red"><%=stokTrans%>/<%=stockTin%>/<%=stockTout%></td> 
                                    <%} else {%>
                                    <td><%=stokTrans%>/<%=stockTin%></td> 
                                    
                                    <%}%>
                                    <%} else {%>    
                                    <%if (stockTout != stokTrans) {%>
                                    <td bgcolor="red"><%=stokTrans%>/<%=stockTout%></td> 
                                    <%} else {%>
                                    <td><%=stokTrans%>/<%=stockTout%></td> 
                                    
                                    <%}%>
                                    <%}%>
                                </tr>
                                <%}
                                    }
                                
                                %>   
                                <% } else if (srcType == 2) {
                                    vTrans = DbRetur.list(0, 0, "status='" + srcStatus + "' and to_days(date) between to_days('" + JSPFormater.formatDate(srcStartDate, "yyyy-MM-dd") + "') and to_days('" + JSPFormater.formatDate(srcEndDate, "yyyy-MM-dd") + "')", "");
                                    Retur rec = new Retur();
                                    if (vTrans.size() > 0) {
                                        for (int i = 0; i < vTrans.size(); i++) {
                                            rec = (Retur) vTrans.get(i);%>
                                <tr>
                                    <td><%= JSPFormater.formatDate(rec.getDate(), "dd-MM-yyyy")%></td>
                                    <td><%=rec.getNumber()%></td>
                                    <td><%=rec.getStatus()%></td>
                                    <%
                                        int stokTrans = 0;
                                        int stock = 0;
                                        stokTrans = DbReturItem.getCount(" retur_id=" + rec.getOID());
                                        stock = DbStock.getTotalStockByTransaksi(" retur_id=" + rec.getOID() + " and location_id=" + rec.getLocationId());

                                    %>
                                    <%if (stock != stokTrans) {%>
                                    <td bgcolor="red"  ><%=stokTrans%>/<%=stock%></td> 
                                    <%} else {%>
                                    <td><%=stokTrans%>/<%=stock%></td> 
                                    
                                    <%}%>
                                </tr>
                                <%}
                                    }
                                
                                %>   
                                <%
                                } else if (srcType == 3) {
                                    vTrans = DbCosting.list(0, 0, "status='" + srcStatus + "' and  to_days(date) between to_days('" + JSPFormater.formatDate(srcStartDate, "yyyy-MM-dd") + "') and to_days('" + JSPFormater.formatDate(srcEndDate, "yyyy-MM-dd") + "')", "");
                                    Costing rec = new Costing();
                                    if (vTrans.size() > 0) {
                                        for (int i = 0; i < vTrans.size(); i++) {
                                            rec = (Costing) vTrans.get(i);%>
                                <tr>
                                    <td><%= JSPFormater.formatDate(rec.getDate(), "dd-MM-yyyy")%></td>
                                    <td><%=rec.getNumber()%></td>
                                    <td><%=rec.getStatus()%></td>
                                    <%
                                            int stokTrans = 0;
                                            int stock = 0;
                                            stokTrans = DbCostingItem.getCount(" costing_id=" + rec.getOID());
                                            stock = DbStock.getTotalStockByTransaksi(" costing_id=" + rec.getOID() + " and location_id=" + rec.getLocationId());

                                    %>
                                    <%if (stock != stokTrans) {%>
                                    <td bgcolor="red"><%=stokTrans%>/<%=stock%></td> 
                                    <%} else {%>
                                    <td><%=stokTrans%>/<%=stock%></td> 
                                    
                                    <%}%>
                                </tr>
                                <%}
                                    }
                                
                                %>   
                                <%
                                } else if (srcType == 4) {
                                    vTrans = DbRepack.list(0, 0, "status='" + srcStatus + "' and to_days(date) between to_days('" + JSPFormater.formatDate(srcStartDate, "yyyy-MM-dd") + "') and to_days('" + JSPFormater.formatDate(srcEndDate, "yyyy-MM-dd") + "')", "");
                                    Repack rec = new Repack();
                                    if (vTrans.size() > 0) {
                                        for (int i = 0; i < vTrans.size(); i++) {
                                            rec = (Repack) vTrans.get(i);%>
                                <tr>
                                    <td><%= JSPFormater.formatDate(rec.getDate(), "dd-MM-yyyy")%></td>
                                    <td><%=rec.getNumber()%></td>
                                    <td><%=rec.getStatus()%></td>
                                    <%
                                            int stokTrans = 0;
                                            int stock = 0;
                                            stokTrans = DbRepackItem.getCount(" repack_id=" + rec.getOID());
                                            stock = DbStock.getTotalStockByTransaksi(" repack_id=" + rec.getOID());

                                    %>
                                    <%if (stock != stokTrans) {%>
                                    <td bgcolor="red"><%=stokTrans%>/<%=stock%></td> 
                                    <%} else {%>
                                    <td><%=stokTrans%>/<%=stock%></td> 
                                    
                                    <%}%>
                                </tr>
                                <%}
                                    }
                                } else if (srcType == 5) {
                                    vTrans = DbAdjusment.list(0, 0, "status='" + srcStatus + "' and to_days(date) between to_days('" + JSPFormater.formatDate(srcStartDate, "yyyy-MM-dd") + "') and to_days('" + JSPFormater.formatDate(srcEndDate, "yyyy-MM-dd") + "')", "");
                                    Adjusment rec = new Adjusment();
                                    if (vTrans.size() > 0) {
                                        for (int i = 0; i < vTrans.size(); i++) {
                                            rec = (Adjusment) vTrans.get(i);%>
                                <tr>
                                    <td><%= JSPFormater.formatDate(rec.getDate(), "dd-MM-yyyy")%></td>
                                    <td><%=rec.getNumber()%></td>
                                    <td><%=rec.getStatus()%></td>
                                    <%
                                     int stokTrans = 0;
                                     int stock = 0;
                                     stokTrans = DbAdjusmentItem.getCount(" adjusment_id=" + rec.getOID());
                                     stock = DbStock.getTotalStockByTransaksi(" adjustment_id=" + rec.getOID());

                                    %>
                                    <%if (stock != stokTrans) {%>
                                    <td bgcolor="red"><%=stokTrans%>/<%=stock%></td> 
                                    <%} else {%>
                                    <td><%=stokTrans%>/<%=stock%></td> 
                                    
                                    <%}%>
                                </tr>
                                <%}
        }
    }
                                
                                %>
                            </table>
                        </td>
                    </tr>
                    <%}%> 
                </form>
            </td>
        </tr>
    </body>
</html>
