
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.util.*" %> 
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "com.project.ccs.posmaster.*" %>   
<%@ page import = "com.project.ccs.*" %>
<%@ page import = "com.project.ccs.report.*" %>
<%@ page import = "com.project.system.*" %>
<%@ include file = "../main/javainit.jsp" %> 
<%@ include file = "../main/check.jsp" %>
<%
            boolean privAdd = true;
            boolean privUpdate = true;
            boolean privDelete = true;
%>
<!-- Jsp Block -->

<%
            int iJSPCommand = JSPRequestValue.requestCommand(request);
            int xJSPCommand = JSPRequestValue.requestInt(request, "xcommand");
            int start = JSPRequestValue.requestInt(request, "start");
            int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
            long oidItemMaster = JSPRequestValue.requestLong(request, "hidden_item_master_id");

//--------------- search ------------------------------------------------------
            long srcGroupId = JSPRequestValue.requestLong(request, "src_group");
            long srcCategoryId = JSPRequestValue.requestLong(request, "src_category");
            String srcCode = JSPRequestValue.requestString(request, "src_code");
            String srcBarCode = JSPRequestValue.requestString(request, "src_barcode");
            String srcName = JSPRequestValue.requestString(request, "src_name");
            int orderBy = JSPRequestValue.requestInt(request, "order_by");
            long srcMerkId = JSPRequestValue.requestLong(request, "src_merk");
            long srcVendorId = JSPRequestValue.requestLong(request, "src_vendor_id");
            long srcStatus = JSPRequestValue.requestInt(request, "src_status");
            long ignoreDate = JSPRequestValue.requestInt(request, "ignore_date");
            String refNumber = JSPRequestValue.requestString(request, "ref_number");
            String srcRefNumber = JSPRequestValue.requestString(request, "src_ref_number");

            Date startDate = new Date();
            Date endDate = new Date();
            Date activeDate = new Date();

            String strStartDate = JSPRequestValue.requestString(request, "start_date");
            String strEndDate = JSPRequestValue.requestString(request, "end_date");
            String strActiveDate = JSPRequestValue.requestString(request, "active_date");
            if (strStartDate != null && strStartDate.length() > 0) {
                startDate = JSPFormater.formatDate(strStartDate, "dd/MM/yyyy");
            }
            if (strEndDate != null && strEndDate.length() > 0) {
                endDate = JSPFormater.formatDate(strEndDate, "dd/MM/yyyy");
            }
            if (strActiveDate != null && strActiveDate.length() > 0) {
                activeDate = JSPFormater.formatDate(strActiveDate, "dd/MM/yyyy");
            }

//-----------------------------------------------------------------------------
            int totGol = Integer.parseInt(DbSystemProperty.getValueByName("jum_gol"));
            /*variable declaration*/
            int recordToGet = 20;

            String msgString = "";
            int iErrCode = JSPMessage.NONE;
            String whereClause = "";
            String orderClause = "";
            
            if (orderBy == 0) {
                orderClause = "item_group_id";
            } else if (orderBy == 1) {
                orderClause = "item_category_id";
            } else if (orderBy == 2) {
                orderClause = "code";
            } else if (orderBy == 3) {
                orderClause = "name";
            } else if (orderBy == 4) {
                orderClause = "merk_id";
            }

            if (iJSPCommand == JSPCommand.NONE) {
                ignoreDate = 1;
                srcStatus = -1;
            }

            if (srcGroupId != 0) {
                whereClause = DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID] + "=" + srcGroupId;
            }
            if (srcCategoryId != 0) {
                if (whereClause.length() > 0) {
                    whereClause = whereClause + " and ";
                }
                whereClause = whereClause + DbItemMaster.colNames[DbItemMaster.COL_ITEM_CATEGORY_ID] + "=" + srcCategoryId;
            }
            if (srcCode != null && srcCode.length() > 0) {
                if (whereClause.length() > 0) {
                    whereClause = whereClause + " and ";
                }
                whereClause = whereClause + DbItemMaster.colNames[DbItemMaster.COL_CODE] + " like '%" + srcCode + "%'";
            }
            if (srcName != null && srcName.length() > 0) {
                if (whereClause.length() > 0) {
                    whereClause = whereClause + " and ";
                }
                whereClause = whereClause + DbItemMaster.colNames[DbItemMaster.COL_NAME] + " like '%" + srcName + "%'";
            }
            if (srcBarCode != null && srcBarCode.length() > 0) {
                if (whereClause.length() > 0) {
                    whereClause = whereClause + " and ";
                }
                whereClause = whereClause + "(" + DbItemMaster.colNames[DbItemMaster.COL_BARCODE] + " like '%" + srcBarCode + "%' or " + DbItemMaster.colNames[DbItemMaster.COL_BARCODE_2] + " like '%" + srcBarCode + "%' or " + DbItemMaster.colNames[DbItemMaster.COL_BARCODE_3] + " like '%" + srcBarCode + "%')";
            }
            if (srcVendorId != 0) {
                if (whereClause.length() > 0) {
                    whereClause = whereClause + " and ";
                }
                whereClause = whereClause + " pos_vendor_item.vendor_id=" + srcVendorId;
            }

            if (whereClause != null && whereClause.length() > 0) {
                whereClause = whereClause + " and ";
            }
            whereClause = whereClause + " is_active=1 ";

//jika searching
            if (iJSPCommand == JSPCommand.SEARCH) {
                if (ignoreDate == 0 || srcStatus != -1 || (srcRefNumber != null && srcRefNumber.length() > 0)) {
                    String st = "";
                    String stx = "select pt.item_master_id from pos_vendor_item_change pt where ";

                    if (ignoreDate == 0) {
                        st = "(to_days(active_date) >= to_days('" + JSPFormater.formatDate(startDate, "yyyy-MM-dd") + "') and " +
                                "to_days(active_date) <= to_days('" + JSPFormater.formatDate(endDate, "yyyy-MM-dd") + "'))";
                    }

                    if (srcStatus != -1) {
                        if (st.length() > 0) {
                            st = st + " and ";
                        }
                        st = st + "status=" + srcStatus;
                    }

                    if (srcRefNumber != null && srcRefNumber.length() > 0) {
                        if (st.length() > 0) {
                            st = st + " and ";
                        }
                        st = st + "ref_number='" + srcRefNumber + "'";

                        //get vendor id and active date
                        Vector tempx = DbVendorItemChange.list(0, 1, "ref_number='" + srcRefNumber + "'", "");
                        if (tempx != null && tempx.size() > 0) {
                            VendorItemChange vcx = (VendorItemChange) tempx.get(0);
                            srcVendorId = vcx.getVendorId();
                            activeDate = vcx.getActiveDate();
                            refNumber = vcx.getRefNumber();
                        }

                    }

                    stx = stx + st;

                    if (stx.length() > 0) {
                        whereClause = whereClause + "  and (pos_item_master.item_master_id in (" + stx + "))";
                    }
                }
            }


            int vectSize = 0;
            if (srcVendorId != 0) {
                vectSize = DbItemMaster.getCountBySupplier(whereClause);
            } else {
                vectSize = DbItemMaster.getCount(whereClause);
            }

//out.println("whereClause : "+whereClause);

            CmdItemMaster ctrlItemMaster = new CmdItemMaster(request);
            JSPLine jspLine = new JSPLine();
            Vector listItemMaster = new Vector(1, 1);

            /*switch statement */
            iErrCode = ctrlItemMaster.action(iJSPCommand, oidItemMaster);
            /* end switch*/
            JspItemMaster jspItemMaster = ctrlItemMaster.getForm();

            ItemMaster itemMaster = ctrlItemMaster.getItemMaster();
            msgString = ctrlItemMaster.getMessage();

            if (oidItemMaster == 0) {
                oidItemMaster = itemMaster.getOID();
            }

            int procNum = 0;

            if (iJSPCommand == JSPCommand.SAVE) {

                if (srcVendorId != 0) {
                    listItemMaster = DbItemMaster.listByVendor(start, recordToGet, whereClause, orderClause);
                } else {
                    listItemMaster = DbItemMaster.list(start, recordToGet, whereClause, orderClause);
                }

                if (listItemMaster.size() > 0) {
                    for (int i = 0; i < listItemMaster.size(); i++) {
                        ItemMaster im = (ItemMaster) listItemMaster.get(i);

                        //ambil prce type semua
                        Vector pts = DbVendorItem.list(0, 0, "item_master_id=" + im.getOID(), "");

                        if (pts != null && pts.size() > 0) {
                            for (int ix = 0; ix < pts.size(); ix++) {

                                VendorItem pt = (VendorItem) pts.get(ix);

                                VendorItemChange ptc = new VendorItemChange();
                                try {
                                    String where = "vendor_item_id=" + pt.getOID() + " and ref_number='" + refNumber + "'";// and status=0";//to_days(active_date)=to_days('"+JSPFormater.formatDate(activeDate, "yyyy-MM-dd")+"')";
                                    Vector tempx = DbVendorItemChange.list(0, 1, where, "");
                                    if (tempx != null && tempx.size() > 0) {
                                        ptc = (VendorItemChange) tempx.get(0);
                                    }
                                } catch (Exception ex) {

                                }

                                //hanya proses yg statusnya open
                                if (ptc.getStatus() == 0) {

                                    ptc.setActiveDate(activeDate);
                                    ptc.setVendorItemId(pt.getOID());
                                    ptc.setDate(new Date());
                                    ptc.setUserId(user.getOID());
                                    ptc.setItemMasterId(pt.getItemMasterId());
                                    ptc.setVendorId(pt.getVendorId());
                                    ptc.setRefNumber(refNumber);

                                    double newprice = JSPRequestValue.requestDouble(request, "newprice_" + pt.getOID());


                                    boolean process = false;
                                    if (newprice == 0) {
                                        //delete jika harga di set 0
                                        if (ptc.getOID() != 0) {
                                            DbVendorItemChange.deleteExc(ptc.getOID());
                                        }
                                        process = false;//jika tidak ada perubahan ga usah diproses
                                    } else {
                                        process = true;
                                    }

                                    if (process) {

                                        procNum = procNum + 1;

                                        ptc.setLastPrice(newprice);
                                        ptc.setLastPriceOri(pt.getLastPrice());
                                        
                                        long oid1 = 0;
                                        try {
                                            if (ptc.getOID() != 0) {
                                                oid1 = DbVendorItemChange.updateExc(ptc);
                                            } else {
                                                oid1 = DbVendorItemChange.insertExc(ptc);
                                            }
                                        } catch (Exception e) {
                                            System.out.println(e.toString());
                                        }


                                        //jika hari ini activenya
                                        //======================================================
                                        if (oid1 != 0) {
                                            Date curDate = new Date();
                                            //jika tanggal sama
                                            if (curDate.getDate() == activeDate.getDate() && curDate.getMonth() == activeDate.getMonth() && curDate.getYear() == activeDate.getYear()) {

                                                VendorItem ptold = new VendorItem();
                                                VendorItem ptnew = new VendorItem();
                                                try {
                                                    ptnew = DbVendorItem.fetchExc(ptc.getVendorItemId());
                                                    ptold = DbVendorItem.fetchExc(ptc.getVendorItemId());
                                                    ptnew.setLastPrice(ptc.getLastPrice());
                                                    ptnew.setUpdateDate(new Date());

                                                    long oid = DbVendorItem.updateExc(ptnew);
                                                    if (oid != 0) {
                                                        ptc.setStatus(1);
                                                        DbVendorItemChange.updateExc(ptc);
                                                    //User u = DbUser.fetch(ptc.getUserId());
                                                    //DbVendorItem.insertOperationLog(0, ptc.getUserId(), u.getFullName()+"-Autoupdate", ptold, ptnew);
                                                    }

                                                } catch (Exception e) {
                                                    System.out.println(e.toString());
                                                }
                                            }

                                        }


                                    }
                                }
                            }
                        }

                    }
                }

            //iJSPCommand=JSPCommand.SEARCH;

            }

            if ((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV) ||
                    (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)) {
                start = ctrlItemMaster.actionList(iJSPCommand, start, vectSize, recordToGet);
            }

//if(iJSPCommand==JSPCommand.SEARCH || iJSPCommand==JSPCommand.EDIT  || iJSPCommand==JSPCommand.SAVE){
            if (srcVendorId != 0) {
                listItemMaster = DbItemMaster.listByVendor(start, recordToGet, whereClause, orderClause);
            } else {
                listItemMaster = DbItemMaster.list(start, recordToGet, whereClause, orderClause);
            }

//}



            Vector categories = DbItemCategory.list(0, 0, "", DbItemCategory.colNames[DbItemCategory.COL_ITEM_GROUP_ID] + "," + DbItemCategory.colNames[DbItemCategory.COL_NAME]);
            Vector units = DbUom.list(0, 0, "", "");

            if (iJSPCommand == JSPCommand.ADD) {
                itemMaster.setForSale(1);
                itemMaster.setForBuy(1);
                itemMaster.setIsActive(1);
                itemMaster.setRecipeItem(1);
            }

%>
<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
    <head>
        <!-- #BeginEditable "javascript" --> 
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <title><%=titleIS%></title>
        <link href="../css/css.css" rel="stylesheet" type="text/css" />
        
        <script language="JavaScript">
            
            function cmdNewPrice(){
                //document.frmitemmaster.hidden_item_master_id.value="0";
                document.frmitemmaster.xcommand.value="<%=JSPCommand.ADD%>"; 
                document.frmitemmaster.command.value="<%=JSPCommand.LIST%>";
                document.frmitemmaster.prev_command.value="<%=prevJSPCommand%>"; 
                document.frmitemmaster.action="costpricechange.jsp";
                document.frmitemmaster.submit();
            }
            
            function cmdPrintXLS(){	 
                window.open("<%=printroot%>.report.RptItemMasterXLS?idx=<%=System.currentTimeMillis()%>");
                }    
                
                function cmdSearch(){
                    //document.frmitemmaster.hidden_item_master_id.value="0";
                    document.frmitemmaster.command.value="<%=JSPCommand.SEARCH%>";
                    document.frmitemmaster.start.value="0";
                    document.frmitemmaster.prev_command.value="<%=prevJSPCommand%>";
                    document.frmitemmaster.action="costpricechange.jsp";
                    document.frmitemmaster.submit();
                }
                
                
                function cmdSave(){
                    var rn = document.frmitemmaster.ref_number.value; 
                    if(rn==""){
                        alert("Please enter vendor reference number");
                        document.frmitemmaster.ref_number.focus();
                    }else{
                    var curDate = document.frmitemmaster.curr_date.value; 
                    var actDate = document.frmitemmaster.active_date.value; 
                    
                    //alert("curDate : "+curDate);
                    //alert("actDate : "+actDate); 
                    
                    if(curDate==actDate){
                        //alert("sama ");
                        if(confirm("Selected active date is today, this price will be activated now and locked. Are your sure to proceed ?")){
                            document.frmitemmaster.command.value="<%=JSPCommand.SAVE%>"; 
                            document.frmitemmaster.prev_command.value="<%=prevJSPCommand%>";
                            document.frmitemmaster.action="costpricechange.jsp";
                            document.frmitemmaster.submit();
                        }
                        
                    }
                    else{          
                        document.frmitemmaster.command.value="<%=JSPCommand.SAVE%>";
                        document.frmitemmaster.prev_command.value="<%=prevJSPCommand%>";
                        document.frmitemmaster.action="costpricechange.jsp";
                        document.frmitemmaster.submit();
                    }
                }
            }
            
            function cmdListFirst(){
                
                if(confirm("Warning !!\nmake sure you have save your update, otherways you will lost the data, proceed anyway ?")){
                    document.frmitemmaster.command.value="<%=JSPCommand.FIRST%>";
                    document.frmitemmaster.prev_command.value="<%=JSPCommand.FIRST%>";
                    document.frmitemmaster.prev_command.value="<%=prevJSPCommand%>";
                    document.frmitemmaster.action="costpricechange.jsp";
                    document.frmitemmaster.submit();
                }
            }
            
            function cmdListPrev(){
                
                if(confirm("Warning !!\nmake sure you have save your update, otherways you will lost the data, proceed anyway ?")){          
                    document.frmitemmaster.command.value="<%=JSPCommand.PREV%>";
                    document.frmitemmaster.prev_command.value="<%=JSPCommand.PREV%>";
                    document.frmitemmaster.prev_command.value="<%=prevJSPCommand%>";
                    document.frmitemmaster.action="costpricechange.jsp";
                    document.frmitemmaster.submit();          
                }
            }
            
            function cmdListNext(){
                
                if(confirm("Warning !!\nmake sure you have save your update, otherways you will lost the data, proceed anyway ?")){                           
                    document.frmitemmaster.command.value="<%=JSPCommand.NEXT%>";
                    document.frmitemmaster.prev_command.value="<%=JSPCommand.NEXT%>";
                    document.frmitemmaster.prev_command.value="<%=prevJSPCommand%>";
                    document.frmitemmaster.action="costpricechange.jsp";
                    document.frmitemmaster.submit();          
                }
            }
            
            function cmdListLast(){
                
                if(confirm("Warning !!\nmake sure you have save your update, otherways you will lost the data, proceed anyway ?")){                                                              
                    document.frmitemmaster.command.value="<%=JSPCommand.LAST%>";
                    document.frmitemmaster.prev_command.value="<%=JSPCommand.LAST%>";
                    document.frmitemmaster.prev_command.value="<%=prevJSPCommand%>";
                    document.frmitemmaster.action="costpricechange.jsp";
                    document.frmitemmaster.submit();                    
                }
            }
            
            
            
            function cmdEdit(oidItemMaster){
                document.frmitemmaster.hidden_item_master_id.value=oidItemMaster;
                document.frmitemmaster.command.value="<%=JSPCommand.EDIT%>";
                document.frmitemmaster.prev_command.value="<%=prevJSPCommand%>";
                document.frmitemmaster.action="costpricechange.jsp";
                document.frmitemmaster.submit();
            }
            function checkCost(oid){  
                
                <%if (listItemMaster.size() > 0) {%>
                <%for (int i = 0; i < listItemMaster.size(); i++) {%>
                <%ItemMaster im = (ItemMaster) listItemMaster.get(i);%>
                if(oid==<%=im.getOID()%>){
                    
                    var st = document.frmitemmaster.gol1_<%=im.getOID()%>.value;	
                    var cog = document.frmitemmaster.hpp_<%=im.getOID()%>.value;
                    var mar = document.frmitemmaster.m1_<%=im.getOID()%>.value; 
                    var cost = document.frmitemmaster.cost_<%=im.getOID()%>.value;
                    var ppn_val=document.frmitemmaster.ppn_<%=im.getOID()%>.value;
                    
                    if(parseFloat(cost) > parseFloat(cog)){
                        cog = cost;
                        
                        document.frmitemmaster.hpp_<%=im.getOID()%>.value =cog; 
                    }
                    <%if (totGol >= 1) {%>
                    
                    <%}%>
                    <%if (totGol >= 2) {%>
                    checkGol2(oid);
                    <%}%>
                    <%if (totGol >= 3) {%>
                    checkGol3(oid);
                    <%}%>
                    <%if (totGol >= 4) {%>
                    checkGol4(oid);
                    <%}%>
                    <%if (totGol >= 5) {%>
                    checkGol5(oid);
                    <%}%>
                    <%if (totGol >= 1) {%>
                    checkMargin1(oid);
                    <%}%>    
                    <%if (totGol >= 2) {%>
                    checkMargin2(oid);
                    <%}%>    
                    <%if (totGol >= 3) {%>
                    checkMargin3(oid);
                    <%}%>    
                    <%if (totGol >= 4) {%>
                    checkMargin4(oid);
                    <%}%>    
                    <%if (totGol >= 5) {%>                               
                    checkMargin5(oid);
                    <%}%>    
                    
                    
                }    
                <%}%>
                
                <%}%>
                
            }
            
            
            function checkGol1(oid){
                <%if (listItemMaster.size() > 0) {%>
                <%for (int i = 0; i < listItemMaster.size(); i++) {%>
                <%ItemMaster im = (ItemMaster) listItemMaster.get(i);%>
                if(oid==<%=im.getOID()%>){
                    
                    var st = document.frmitemmaster.gol1_<%=im.getOID()%>.value;	
                    var cog = document.frmitemmaster.hpp_<%=im.getOID()%>.value;
                    var mar = document.frmitemmaster.m1_<%=im.getOID()%>.value;
                    var cost = document.frmitemmaster.cost_<%=im.getOID()%>.value;
                    var ppn_val=document.frmitemmaster.ppn_<%=im.getOID()%>.value;
                    
                    
                    if(parseFloat(cost) > parseFloat(cog)){
                        cog = cost;
                        document.frmitemmaster.hpp_<%=im.getOID()%>.value =cog; 
                    }
                    //var ppn_val=0;
                    //cog = cleanNumberFloat(cog, sysDecSymbol, usrDigitGroup, usrDecSymbol);	                              
                    //mar=((parseFloat(st)-parseFloat(cog)-parseFloat(ppn_val)) / parseFloat(cog)) * 100;
                    mar=((((parseFloat(st)/(parseFloat(cog)+parseFloat(ppn_val)))*100)-100)/((parseFloat(st)/(parseFloat(cog)+parseFloat(ppn_val)))*100)) * 100;
                    
                    
                    document.frmitemmaster.m1_<%=im.getOID()%>.value =mar; 
                }    
                <%}%>
                
                <%}%>
                
            }
            function checkMargin1(oid){
                
                <%if (listItemMaster.size() > 0) {%>
                <%for (int i = 0; i < listItemMaster.size(); i++) {%>
                <%ItemMaster im = (ItemMaster) listItemMaster.get(i);%>
                if(oid==<%=im.getOID()%>){
                    var st = document.frmitemmaster.gol1_<%=im.getOID()%>.value;	
                    var cog = document.frmitemmaster.hpp_<%=im.getOID()%>.value;
                    var mar = document.frmitemmaster.m1_<%=im.getOID()%>.value;
                    var cost = document.frmitemmaster.cost_<%=im.getOID()%>.value;
                    var ppn_val=document.frmitemmaster.ppn_<%=im.getOID()%>.value;
                    if(parseFloat(cost) > parseFloat(cog)){
                        cog = cost;
                        document.frmitemmaster.hpp_<%=im.getOID()%>.value =cog; 
                    }
                    //cog = cleanNumberFloat(cog, sysDecSymbol, usrDigitGroup, usrDecSymbol);	
                    //st=parseFloat(mar)/100 * parseFloat(cog) + parseFloat(cog) + parseFloat(ppn_val);
                    st=((100/(100-parseFloat(mar)))* (parseFloat(cog)+parseFloat(ppn_val)));
                    
                    
                    document.frmitemmaster.gol1_<%=im.getOID()%>.value =st; 
                }    
                <%}%>
                
                <%}%>
                
            }
            
            
            function checkGol2(oid){
                <%if (listItemMaster.size() > 0) {%>
                <%for (int i = 0; i < listItemMaster.size(); i++) {%>
                <%ItemMaster im = (ItemMaster) listItemMaster.get(i);%>
                if(oid==<%=im.getOID()%>){
                    var st = document.frmitemmaster.gol2_<%=im.getOID()%>.value;	
                    var cog = document.frmitemmaster.hpp_<%=im.getOID()%>.value;
                    var mar = document.frmitemmaster.m2_<%=im.getOID()%>.value;
                    var cost = document.frmitemmaster.cost_<%=im.getOID()%>.value;
                    var ppn_val=document.frmitemmaster.ppn_<%=im.getOID()%>.value;
                    if(parseFloat(cost) > parseFloat(cog)){
                        cog = cost;
                        document.frmitemmaster.hpp_<%=im.getOID()%>.value =cog; 
                    }
                    //cog = cleanNumberFloat(cog, sysDecSymbol, usrDigitGroup, usrDecSymbol);	                              
                    //mar=((parseFloat(st)-parseFloat(cog)-parseFloat(ppn_val)) / parseFloat(cog)) * 100;
                    mar=((((parseFloat(st)/(parseFloat(cog)+parseFloat(ppn_val)))*100)-100)/((parseFloat(st)/(parseFloat(cog)+parseFloat(ppn_val)))*100)) * 100;
                    if(mar > 0){
                        
                    }else{
                    var mar =0;
                }
                
                document.frmitemmaster.m2_<%=im.getOID()%>.value =mar; 
            }    
            <%}%>
            
            <%}%>
            
        }
        function checkMargin2(oid){
            
            <%if (listItemMaster.size() > 0) {%>
            <%for (int i = 0; i < listItemMaster.size(); i++) {%>
            <%ItemMaster im = (ItemMaster) listItemMaster.get(i);%>
            if(oid==<%=im.getOID()%>){
                var st = document.frmitemmaster.gol2_<%=im.getOID()%>.value;	
                var cog = document.frmitemmaster.hpp_<%=im.getOID()%>.value;
                var mar = document.frmitemmaster.m2_<%=im.getOID()%>.value;
                var cost = document.frmitemmaster.cost_<%=im.getOID()%>.value;
                var ppn_val=document.frmitemmaster.ppn_<%=im.getOID()%>.value;
                if(parseFloat(cost) > parseFloat(cog)){
                    cog = cost;
                    document.frmitemmaster.hpp_<%=im.getOID()%>.value =cog; 
                }
                //cog = cleanNumberFloat(cog, sysDecSymbol, usrDigitGroup, usrDecSymbol);	
                //st=parseFloat(mar)/100 * parseFloat(cog) + parseFloat(cog) + parseFloat(ppn_val);
                st=((100/(100-parseFloat(mar)))* (parseFloat(cog)+parseFloat(ppn_val)));
                
                
                document.frmitemmaster.gol2_<%=im.getOID()%>.value =st; 
            }    
            <%}%>
            
            <%}%>
            
        }
        
        function checkGol3(oid){
            <%if (listItemMaster.size() > 0) {%>
            <%for (int i = 0; i < listItemMaster.size(); i++) {%>
            <%ItemMaster im = (ItemMaster) listItemMaster.get(i);%>
            if(oid==<%=im.getOID()%>){
                var st = document.frmitemmaster.gol3_<%=im.getOID()%>.value;	
                var cog = document.frmitemmaster.hpp_<%=im.getOID()%>.value;
                var mar = document.frmitemmaster.m3_<%=im.getOID()%>.value;
                var cost = document.frmitemmaster.cost_<%=im.getOID()%>.value;
                var ppn_val=document.frmitemmaster.ppn_<%=im.getOID()%>.value;
                if(parseFloat(cost) > parseFloat(cog)){
                    cog = cost;
                    document.frmitemmaster.hpp_<%=im.getOID()%>.value =cog; 
                }
                //cog = cleanNumberFloat(cog, sysDecSymbol, usrDigitGroup, usrDecSymbol);	                              
                //mar=((parseFloat(st)-parseFloat(cog)-parseFloat(ppn_val)) / parseFloat(cog)) * 100;
                mar=((((parseFloat(st)/(parseFloat(cog)+parseFloat(ppn_val)))*100)-100)/((parseFloat(st)/(parseFloat(cog)+parseFloat(ppn_val)))*100)) * 100;
                if(mar > 0){
                    
                }else{
                var mar =0;
            }
            
            document.frmitemmaster.m3_<%=im.getOID()%>.value =mar; 
        }    
        <%}%>
        
        <%}%>
        
    }
    function checkMargin3(oid){
        
        <%if (listItemMaster.size() > 0) {%>
        <%for (int i = 0; i < listItemMaster.size(); i++) {%>
        <%ItemMaster im = (ItemMaster) listItemMaster.get(i);%>
        if(oid==<%=im.getOID()%>){
            var st = document.frmitemmaster.gol3_<%=im.getOID()%>.value;	
            var cog = document.frmitemmaster.hpp_<%=im.getOID()%>.value;
            var mar = document.frmitemmaster.m3_<%=im.getOID()%>.value;
            var cost = document.frmitemmaster.cost_<%=im.getOID()%>.value;
            var ppn_val=document.frmitemmaster.ppn_<%=im.getOID()%>.value;
            if(parseFloat(cost) > parseFloat(cog)){
                cog = cost;
                document.frmitemmaster.hpp_<%=im.getOID()%>.value =cog; 
            }
            //cog = cleanNumberFloat(cog, sysDecSymbol, usrDigitGroup, usrDecSymbol);	
            //st=parseFloat(mar)/100 * parseFloat(cog) + parseFloat(cog) + parseFloat(ppn_val);
            st=((100/(100-parseFloat(mar)))* (parseFloat(cog)+parseFloat(ppn_val)));
            
            
            document.frmitemmaster.gol3_<%=im.getOID()%>.value =st; 
        }    
        <%}%>
        
        <%}%>
        
    }
    
    function checkGol4(oid){
        <%if (listItemMaster.size() > 0) {%>
        <%for (int i = 0; i < listItemMaster.size(); i++) {%>
        <%ItemMaster im = (ItemMaster) listItemMaster.get(i);%>
        if(oid==<%=im.getOID()%>){
            var st = document.frmitemmaster.gol4_<%=im.getOID()%>.value;	
            var cog = document.frmitemmaster.hpp_<%=im.getOID()%>.value;
            var mar = document.frmitemmaster.m4_<%=im.getOID()%>.value;
            var cost = document.frmitemmaster.cost_<%=im.getOID()%>.value;
            var ppn_val=document.frmitemmaster.ppn_<%=im.getOID()%>.value;
            if(parseFloat(cost) > parseFloat(cog)){
                cog = cost;
                document.frmitemmaster.hpp_<%=im.getOID()%>.value =cog; 
            }
            //cog = cleanNumberFloat(cog, sysDecSymbol, usrDigitGroup, usrDecSymbol);	                              
            //mar=((parseFloat(st)-parseFloat(cog)-parseFloat(ppn_val)) / parseFloat(cog)) * 100;
            mar=((((parseFloat(st)/(parseFloat(cog)+parseFloat(ppn_val)))*100)-100)/((parseFloat(st)/(parseFloat(cog)+parseFloat(ppn_val)))*100)) * 100;
            if(mar > 0){
                
            }else{
            var mar =0;
        }
        
        document.frmitemmaster.m4_<%=im.getOID()%>.value =mar; 
    }    
    <%}%>
    
    <%}%>
    
}
function checkMargin4(oid){
    
    <%if (listItemMaster.size() > 0) {%>
    <%for (int i = 0; i < listItemMaster.size(); i++) {%>
    <%ItemMaster im = (ItemMaster) listItemMaster.get(i);%>
    if(oid==<%=im.getOID()%>){
        var st = document.frmitemmaster.gol4_<%=im.getOID()%>.value;	
        var cog = document.frmitemmaster.hpp_<%=im.getOID()%>.value;
        var mar = document.frmitemmaster.m4_<%=im.getOID()%>.value;
        var cost = document.frmitemmaster.cost_<%=im.getOID()%>.value;
        var ppn_val=document.frmitemmaster.ppn_<%=im.getOID()%>.value;
        if(parseFloat(cost) > parseFloat(cog)){
            cog = cost;
            document.frmitemmaster.hpp_<%=im.getOID()%>.value =cog; 
        }
        //cog = cleanNumberFloat(cog, sysDecSymbol, usrDigitGroup, usrDecSymbol);	
        //st=parseFloat(mar)/100 * parseFloat(cog) + parseFloat(cog) + parseFloat(ppn_val);
        st=((100/(100-parseFloat(mar)))* (parseFloat(cog)+parseFloat(ppn_val)));
        
        
        document.frmitemmaster.gol4_<%=im.getOID()%>.value =st; 
    }    
    <%}%>
    
    <%}%>
    
}

function checkGol5(oid){
    <%if (listItemMaster.size() > 0) {%>
    <%for (int i = 0; i < listItemMaster.size(); i++) {%>
    <%ItemMaster im = (ItemMaster) listItemMaster.get(i);%>
    if(oid==<%=im.getOID()%>){
        var st = document.frmitemmaster.gol5_<%=im.getOID()%>.value;	
        var cog = document.frmitemmaster.hpp_<%=im.getOID()%>.value;
        var mar = document.frmitemmaster.m5_<%=im.getOID()%>.value;
        var cost = document.frmitemmaster.cost_<%=im.getOID()%>.value;
        var ppn_val=document.frmitemmaster.ppn_<%=im.getOID()%>.value;
        if(parseFloat(cost) > parseFloat(cog)){
            cog = cost;
            document.frmitemmaster.hpp_<%=im.getOID()%>.value =cog; 
        }
        //cog = cleanNumberFloat(cog, sysDecSymbol, usrDigitGroup, usrDecSymbol);	                              
        //mar=((parseFloat(st)-parseFloat(cog)-parseFloat(ppn_val)) / parseFloat(cog)) * 100;
        mar=((((parseFloat(st)/(parseFloat(cog)+parseFloat(ppn_val)))*100)-100)/((parseFloat(st)/(parseFloat(cog)+parseFloat(ppn_val)))*100)) * 100;
        if(mar > 0){
            
        }else{
        var mar =0;
    }
    
    document.frmitemmaster.m5_<%=im.getOID()%>.value =mar; 
}    
<%}%>

<%}%>

}
function checkMargin5(oid){
    
    <%if (listItemMaster.size() > 0) {%>
    <%for (int i = 0; i < listItemMaster.size(); i++) {%>
    <%ItemMaster im = (ItemMaster) listItemMaster.get(i);%>
    if(oid==<%=im.getOID()%>){
        var st = document.frmitemmaster.gol5_<%=im.getOID()%>.value;	
        var cog = document.frmitemmaster.hpp_<%=im.getOID()%>.value;
        var mar = document.frmitemmaster.m5_<%=im.getOID()%>.value;
        var cost = document.frmitemmaster.cost_<%=im.getOID()%>.value;
        var ppn_val=document.frmitemmaster.ppn_<%=im.getOID()%>.value;
        if(parseFloat(cost) > parseFloat(cog)){
            cog = cost;
            document.frmitemmaster.hpp_<%=im.getOID()%>.value =cog; 
        }
        //cog = cleanNumberFloat(cog, sysDecSymbol, usrDigitGroup, usrDecSymbol);	
        //st=parseFloat(mar)/100 * parseFloat(cog) + parseFloat(cog) + parseFloat(ppn_val);
        st=((100/(100-parseFloat(mar)))* (parseFloat(cog)+parseFloat(ppn_val)));
        
        
        document.frmitemmaster.gol5_<%=im.getOID()%>.value =st; 
    }    
    <%}%>
    
    <%}%>
    
}


function checkGol6(oid){
    <%if (listItemMaster.size() > 0) {%>
    <%for (int i = 0; i < listItemMaster.size(); i++) {%>
    <%ItemMaster im = (ItemMaster) listItemMaster.get(i);%>
    if(oid==<%=im.getOID()%>){
        var st = document.frmitemmaster.gol6_<%=im.getOID()%>.value;	
        var cog = document.frmitemmaster.hpp_<%=im.getOID()%>.value;
        var mar = document.frmitemmaster.m6_<%=im.getOID()%>.value;
        var cost = document.frmitemmaster.cost_<%=im.getOID()%>.value;
        var ppn_val=document.frmitemmaster.ppn_<%=im.getOID()%>.value;
        if(parseFloat(cost) > parseFloat(cog)){
            cog = cost;
            document.frmitemmaster.hpp_<%=im.getOID()%>.value =cog; 
        }
        //cog = cleanNumberFloat(cog, sysDecSymbol, usrDigitGroup, usrDecSymbol);	                              
        //mar=((parseFloat(st)-parseFloat(cog)-parseFloat(ppn_val)) / parseFloat(cog)) * 100;
        mar=((((parseFloat(st)/(parseFloat(cog)+parseFloat(ppn_val)))*100)-100)/((parseFloat(st)/(parseFloat(cog)+parseFloat(ppn_val)))*100)) * 100;
        if(mar > 0){
            
        }else{
        var mar =0;
    }
    
    document.frmitemmaster.m6_<%=im.getOID()%>.value =mar; 
}    
<%}%>

<%}%>

}
function checkMargin6(oid){
    
    <%if (listItemMaster.size() > 0) {%>
    <%for (int i = 0; i < listItemMaster.size(); i++) {%>
    <%ItemMaster im = (ItemMaster) listItemMaster.get(i);%>
    if(oid==<%=im.getOID()%>){
        var st = document.frmitemmaster.gol6_<%=im.getOID()%>.value;	
        var cog = document.frmitemmaster.hpp_<%=im.getOID()%>.value;
        var mar = document.frmitemmaster.m6_<%=im.getOID()%>.value;
        var cost = document.frmitemmaster.cost_<%=im.getOID()%>.value;
        var ppn_val=document.frmitemmaster.ppn_<%=im.getOID()%>.value;
        if(parseFloat(cost) > parseFloat(cog)){
            cog = cost;
            document.frmitemmaster.hpp_<%=im.getOID()%>.value =cog; 
        }
        //cog = cleanNumberFloat(cog, sysDecSymbol, usrDigitGroup, usrDecSymbol);	
        //st=parseFloat(mar)/100 * parseFloat(cog) + parseFloat(cog) + parseFloat(ppn_val);
        st=((100/(100-parseFloat(mar)))* (parseFloat(cog)+parseFloat(ppn_val)));
        
        
        document.frmitemmaster.gol6_<%=im.getOID()%>.value =st; 
    }    
    <%}%>
    
    <%}%>
    
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
                                                        <form name="frmitemmaster" method ="post" action="">
                                                            <input type="hidden" name="command" value="<%=iJSPCommand%>">
                                                            <input type="hidden" name="xcommand" value="<%=xJSPCommand%>">
                                                            <input type="hidden" name="start" value="<%=start%>">
                                                            <input type="hidden" name="vectSize" value="<%=vectSize%>">
                                                            <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                                                            <input type="hidden" name="hidden_item_master_id" value="<%=oidItemMaster%>">
                                                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr> 
                                                                    <td class="container" valign="top"> 
                                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                            <tr> 
                                                                                <td> 
                                                                                    <table width="100%" border="0" cellspacing="1" cellpadding="1" height="17">
                                                                                        <tr valign="bottom"> 
                                                                                            <td width="60%" height="23"><b><font color="#990000" class="lvl1">Master 
                                                                                                    Maintenance </font><font class="tit1">&raquo; 
                                                                                                    </font><font class="tit1"><span class="lvl2">POS 
                                                                                                        </span>&raquo; <span class="lvl2">Cost 
                                                                                            Price Change</span></font></b></td>
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
                                                                                <td height="5"></td>
                                                                            </tr>
                                                                            
                                                                            <tr> 
                                                                                <td class="page"> 
                                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="8"  colspan="3"> 
                                                                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                                    <tr align="left" valign="top"> 
                                                                                                        <td height="8" valign="middle" colspan="3"> 
                                                                                                            <table width="100%" border="0" cellspacing="1" cellpadding="0">
                                                                                                                <tr> 
                                                                                                                    <td width="7%">&nbsp;</td>
                                                                                                                    <td width="12%">&nbsp;</td>
                                                                                                                    <td width="6%">&nbsp;</td>
                                                                                                                    <td width="15%">&nbsp;</td>
                                                                                                                    <td width="4%">&nbsp;</td>
                                                                                                                    <td width="11%">&nbsp;</td>
                                                                                                                    <td width="45%">&nbsp;</td>
                                                                                                                </tr>
                                                                                                                <tr> 
                                                                                                                    <td colspan="7" nowrap><b><u>Search 
                                                                                                                    Option</u></b></td>
                                                                                                                </tr>
                                                                                                                <tr> 
                                                                                                                    <td width="7%">&nbsp;</td>
                                                                                                                    <td width="12%">&nbsp;</td>
                                                                                                                    <td width="6%">&nbsp;</td>
                                                                                                                    <td width="15%">&nbsp;</td>
                                                                                                                    <td width="4%">&nbsp;</td>
                                                                                                                    <td width="11%">&nbsp;</td>
                                                                                                                    <td width="45%">&nbsp;</td>
                                                                                                                </tr>
                                                                                                                <tr> 
                                                                                                                    <td width="7%" height="22">Group</td>
                                                                                                                    <td width="12%" height="22"> 
                                                                                                                        <%
            Vector groupsx = DbItemGroup.list(0, 0, "", "name");
                                                                                                                        %>
                                                                                                                        <select name="src_group">
                                                                                                                            <option value="0" <%if (srcGroupId == 0) {%>selected<%}%>>All 
                                                                                                                                    ..</option>
                                                                                                                            <%if (groupsx != null && groupsx.size() > 0) {
                for (int i = 0; i < groupsx.size(); i++) {
                    ItemGroup ig = (ItemGroup) groupsx.get(i);
                                                                                                                            %>
                                                                                                                            <option value="<%=ig.getOID()%>" <%if (srcGroupId == ig.getOID()) {%>selected<%}%>><%=ig.getName()%></option>
                                                                                                                            <%}
            }%>
                                                                                                                        </select>
                                                                                                                    </td>
                                                                                                                    <td width="6%" height="22">&nbsp;SKU</td>
                                                                                                                    <td width="15%" height="22"> 
                                                                                                                        <input type="text" name="src_code" size="15" value="<%=srcCode%>" onchange="javascript:cmdSearch()">
                                                                                                                    </td>
                                                                                                                    <td width="4%" height="22">Barcode</td>
                                                                                                                    <td width="11%" height="22"> 
                                                                                                                        <input type="text" name="src_barcode" size="15" value="<%=srcBarCode%>" onchange="javascript:cmdSearch()">
                                                                                                                    </td>
                                                                                                                    <td width="45%" height="22">&nbsp;</td>
                                                                                                                </tr>
                                                                                                                <tr> 
                                                                                                                    <td width="7%" height="22">Category</td>
                                                                                                                    <td width="12%" height="22"> 
                                                                                                                        <%
            Vector categoryx = DbItemCategory.list(0, 0, "", "name");
                                                                                                                        %>
                                                                                                                        <select name="src_category">
                                                                                                                            <option value="0" <%if (srcCategoryId == 0) {%>selected<%}%>>All 
                                                                                                                                    ..</option>
                                                                                                                            <%if (categoryx != null && categoryx.size() > 0) {
                for (int i = 0; i < categoryx.size(); i++) {
                    ItemCategory ic = (ItemCategory) categoryx.get(i);
                                                                                                                            %>
                                                                                                                            <option value="<%=ic.getOID()%>" <%if (srcCategoryId == ic.getOID()) {%>selected<%}%>><%=ic.getName().toUpperCase()%></option>
                                                                                                                            <%}
            }%>
                                                                                                                        </select>
                                                                                                                    </td>
                                                                                                                    <td width="6%" height="22">&nbsp;Name</td>
                                                                                                                    <td width="15%" height="22"> 
                                                                                                                        <input type="text" name="src_name" value="<%=srcName%>" onchange="javascript:cmdSearch()">
                                                                                                                    </td>
                                                                                                                    <td width="4%" height="22">Order 
                                                                                                                    By</td>
                                                                                                                    <td width="11%" height="22"> 
                                                                                                                        <select name="order_by">
                                                                                                                            <option value="0" <%if (orderBy == 0) {%>selected<%}%>>GROUP</option>
                                                                                                                            <option value="1" <%if (orderBy == 1) {%>selected<%}%>>CATEGORY</option>
                                                                                                                            <option value="2" <%if (orderBy == 2) {%>selected<%}%>>CODE</option>
                                                                                                                            <option value="3" <%if (orderBy == 3) {%>selected<%}%>>NAME</option>
                                                                                                                            <option value="4" <%if (orderBy == 4) {%>selected<%}%>>MERK</option>
                                                                                                                        </select>
                                                                                                                    </td>
                                                                                                                    <td width="45%" height="22"> 
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                                <tr> 
                                                                                                                    <td width="7%" height="22">Vendor</td>
                                                                                                                    <td width="12%" nowrap height="22"> 
                                                                                                                        <select name="src_vendor_id">
                                                                                                                            <option value="0" <%if (srcVendorId == 0) {%>selected<%}%>>- 
                                                                                                                                    All -</option>
                                                                                                                            <%

            Vector vendors = DbVendor.list(0, 0, "", "name");

            if (vendors != null && vendors.size() > 0) {
                for (int i = 0; i < vendors.size(); i++) {
                    Vendor d = (Vendor) vendors.get(i);
                    String str = "";
                                                                                                                            %>
                                                                                                                            <option value="<%=d.getOID()%>" <%if (srcVendorId == d.getOID()) {%>selected<%}%>><%=d.getName()%></option>
                                                                                                                            <%}
            }%>
                                                                                                                        </select>
                                                                                                                    &nbsp;&nbsp; </td>
                                                                                                                    <td width="6%" nowrap height="22">&nbsp;Status&nbsp;</td>
                                                                                                                    <td width="15%" height="22"> 
                                                                                                                        <select name="src_status">
                                                                                                                            <option value="-1" <%if (srcStatus == -1) {%>selected<%}%>>All</option>
                                                                                                                            <option value="0" <%if (srcStatus == 0) {%>selected<%}%>>-</option>
                                                                                                                            <option value="1" <%if (srcStatus == 0) {%>selected<%}%>>PROCEED</option>
                                                                                                                        </select>
                                                                                                                    </td>
                                                                                                                    <td width="4%" height="22" nowrap>Ref. 
                                                                                                                    Number </td>
                                                                                                                    <td width="11%" height="22"> 
                                                                                                                        <input type="text" name="src_ref_number" value="<%=srcRefNumber%>" size="20">
                                                                                                                    </td>
                                                                                                                    <td width="45%" height="22">&nbsp;</td>
                                                                                                                </tr>
                                                                                                                <tr> 
                                                                                                                    <td nowrap width="7%" height="22">Active 
                                                                                                                    Date Between</td>
                                                                                                                    <td colspan="3" height="22"> 
                                                                                                                        <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                                                                            <tr> 
                                                                                                                                <td width="26%" nowrap> 
                                                                                                                                    <input name="start_date" value="<%=JSPFormater.formatDate((startDate == null) ? new Date() : startDate, "dd/MM/yyyy")%>" size="11" readonly>
                                                                                                                                    <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmitemmaster.start_date);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> 
                                                                                                                                </td>
                                                                                                                                <td width="7%"> 
                                                                                                                                    <div align="center">And</div>
                                                                                                                                </td>
                                                                                                                                <td width="26%" nowrap> 
                                                                                                                                    <input name="end_date" value="<%=JSPFormater.formatDate((endDate == null) ? new Date() : endDate, "dd/MM/yyyy")%>" size="11" readonly>
                                                                                                                                    <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmitemmaster.end_date);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> 
                                                                                                                                </td>
                                                                                                                                <td width="41%"> 
                                                                                                                                <input type="checkbox" name="ignore_date" value="1" <%if (ignoreDate == 1) {%>checked<%}%>>
                                                                                                                                       Ignore</td>
                                                                                                                            </tr>
                                                                                                                        </table>
                                                                                                                    </td>
                                                                                                                    <td width="4%" height="22"><a href="javascript:cmdSearch()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('search','','../images/search2.gif',1)"><img src="../images/search.gif" name="search"  border="0"></a></td>
                                                                                                                    <td width="11%" height="22">&nbsp;</td>
                                                                                                                    <td width="45%" height="22">&nbsp;</td>
                                                                                                                </tr>
                                                                                                                <tr> 
                                                                                                                    <td colspan="7">&nbsp;</td>
                                                                                                                </tr>
                                                                                                                <tr> 
                                                                                                                    <td colspan="7" background="../images/line1.gif"><img src="../images/line1.gif" width="47" height="3"></td>
                                                                                                                </tr>
                                                                                                                <tr> 
                                                                                                                    <td width="7%">&nbsp;</td>
                                                                                                                    <td width="12%">&nbsp;</td>
                                                                                                                    <td width="6%">&nbsp;</td>
                                                                                                                    <td width="15%">&nbsp;</td>
                                                                                                                    <td width="4%">&nbsp;</td>
                                                                                                                    <td width="11%">&nbsp;</td>
                                                                                                                    <td width="45%">&nbsp;</td>
                                                                                                                </tr>
                                                                                                                <tr> 
                                                                                                                    <td width="7%">Set Active 
                                                                                                                    Date</td>
                                                                                                                    <td width="12%" nowrap> 
                                                                                                                        <input type="text" name="active_date" value="<%=JSPFormater.formatDate((activeDate == null) ? new Date() : activeDate, "dd/MM/yyyy")%>" size="11" onBlur="javascript:cmdNewPrice()"/>
                                                                                                                        <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmitemmaster.active_date);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> 
                                                                                                                    &nbsp; </td>
                                                                                                                    <td nowrap>Ref. Number&nbsp;</td>
                                                                                                                    <td>
                                                                                                                        <input type="text" name="ref_number" value="<%=refNumber%>">
                                                                                                                    </td>
                                                                                                                    <td width="4%">&nbsp;</td>
                                                                                                                    <td width="11%"><a href="javascript:cmdNewPrice()">SETUP 
                                                                                                                    NEW COST</a></td>
                                                                                                                    <td width="45%"><font color="#FF0000"><%=(procNum == 0 && iJSPCommand == JSPCommand.SAVE) ? "No cost changed from list" : ""%></font></td>
                                                                                                                </tr>
                                                                                                                <tr> 
                                                                                                                    <td width="7%">&nbsp;</td>
                                                                                                                    <td width="12%">
                                                                                                                        <input type="hidden" name="curr_date" value="<%=JSPFormater.formatDate(new Date(), "dd/MM/yyyy")%>">
                                                                                                                    </td>
                                                                                                                    <td width="6%">&nbsp;</td>
                                                                                                                    <td width="15%">&nbsp;</td>
                                                                                                                    <td width="4%">&nbsp;</td>
                                                                                                                    <td width="11%">&nbsp;</td>
                                                                                                                    <td width="45%">&nbsp;</td>
                                                                                                                </tr>
                                                                                                                <tr> 
                                                                                                                    <td width="7%">&nbsp;</td>
                                                                                                                    <td width="12%">&nbsp;</td>
                                                                                                                    <td width="6%">&nbsp;</td>
                                                                                                                    <td width="15%">&nbsp;</td>
                                                                                                                    <td width="4%">&nbsp;</td>
                                                                                                                    <td width="11%">&nbsp;</td>
                                                                                                                    <td width="45%">&nbsp;</td>
                                                                                                                </tr>
                                                                                                            </table>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <%
            try {
                if (listItemMaster.size() > 0) {
                                                                                                    %>
                                                                                                    <tr align="left" valign="top"> 
                                                                                                        <td height="22" valign="middle" colspan="3"> 
                                                                                                            <table width="100%" border="0" cellspacing="1" cellpadding="1" class="tablecell1">
                                                                                                                <tr> 
                                                                                                                    <td class="tablehdr">No</td>
                                                                                                                    <td class="tablehdr">Vendor</td>
                                                                                                                    <td class="tablehdr">Barcode</td>
                                                                                                                    <td class="tablehdr">SKU</td>
                                                                                                                    <td class="tablehdr">Name</td>
                                                                                                                    <td class="tablehdr">Last 
                                                                                                                    Price </td>
                                                                                                                    <td class="tablehdr">Unit 
                                                                                                                    Cost</td>
                                                                                                                    <td class="tablehdr">New 
                                                                                                                    Price </td>
                                                                                                                    <td class="tablehdr">Ref 
                                                                                                                    Number </td>
                                                                                                                    <td class="tablehdr">Active 
                                                                                                                    Date </td>
                                                                                                                    <td class="tablehdr">Status</td>
                                                                                                                    <td class="tablehdr">User</td>
                                                                                                                </tr>
                                                                                                                <%for (int i = 0; i < listItemMaster.size(); i++) {

                                                                                                                    ItemMaster im = (ItemMaster) listItemMaster.get(i);

                                                                                                                    String wherex = "item_master_id=" + im.getOID();
                                                                                                                    if (srcVendorId != 0) {
                                                                                                                        wherex = wherex + " and vendor_id=" + srcVendorId;
                                                                                                                    }
                                                                                                                    if (iJSPCommand == JSPCommand.SEARCH) {

                                                                                                                        String st = "";
                                                                                                                        String stx = "select pt.item_master_id from pos_vendor_item_change pt where ";
                                                                                                                       
                                                                                                                        if (ignoreDate == 0) {
                                                                                                                            st = "(to_days(active_date) >= to_days('" + JSPFormater.formatDate(startDate, "yyyy-MM-dd") + "') and " +
                                                                                                                                    "to_days(active_date) <= to_days('" + JSPFormater.formatDate(endDate, "yyyy-MM-dd") + "'))";
                                                                                                                        }

                                                                                                                        if (srcStatus != -1) {
                                                                                                                            if (st.length() > 0) {
                                                                                                                                st = st + " and ";
                                                                                                                            }
                                                                                                                            st = st + "status=" + srcStatus;
                                                                                                                        }

                                                                                                                        if (srcRefNumber != null && srcRefNumber.length() > 0) {
                                                                                                                            if (st.length() > 0) {
                                                                                                                                st = st + " and ";
                                                                                                                            }
                                                                                                                            st = st + "ref_number='" + srcRefNumber + "'";
                                                                                                                        }

                                                                                                                        stx = stx + st;

                                                                                                                        if (stx.length() > 0) {
                                                                                                                            whereClause = whereClause + "  and (pos_item_master.item_master_id in (" + stx + "))";
                                                                                                                        }
                                                                                                                    }

                                                                                                                    //out.println("wherex : "+wherex);

                                                                                                                    Vector vvi = DbVendorItem.list(0, 0, wherex, "");


                                                                                                                    VendorItem vi = new VendorItem();
                                                                                                                    if (vvi.size() > 0) {
                                                                                                                        try {
                                                                                                                            vi = (VendorItem) vvi.get(0);
                                                                                                                        } catch (Exception ex) {

                                                                                                                        }
                                                                                                                    }

                                                                                                                    //ambil vendor item
                                                                                                                    Vector pts = vvi;//DbVendorItem.list(0,0, "item_master_id="+im.getOID(), "");

                                                                                                                    if (pts != null && pts.size() > 0) {
                                                                                                                        for (int ix = 0; ix < pts.size(); ix++) {

                                                                                                                            VendorItem pt = (VendorItem) pts.get(ix);

                                                                                                                            VendorItemChange ptc = new VendorItemChange();
                                                                                                                            Vendor vendor = new Vendor();
                                                                                                                            try {
                                                                                                                                vendor = DbVendor.fetchExc(pt.getVendorId());

                                                                                                                                String where = "vendor_item_id=" + pt.getOID() + " and ref_number='" + refNumber + "'";//" and to_days(active_date)=to_days('"+JSPFormater.formatDate(activeDate, "yyyy-MM-dd")+"')";
                                                                                                                                Vector tempx = DbVendorItemChange.list(0, 1, where, "");
                                                                                                                                if (tempx != null && tempx.size() > 0) {
                                                                                                                                    ptc = (VendorItemChange) tempx.get(0);
                                                                                                                                }
                                                                                                                            } catch (Exception ex) {

                                                                                                                            }

                                                                                                                            if (i % 2 == 0) {%>
                                                                                                                <tr> 
                                                                                                                    <td class="tablecell"><%=start + i + 1%></td>
                                                                                                                    <td class="tablecell"><%=vendor.getName()%></td>
                                                                                                                    <td class="tablecell"><%=im.getBarcode()%></td>
                                                                                                                    <td class="tablecell"><%=im.getCode()%></td>
                                                                                                                    <td class="tablecell" nowrap><%=im.getName()%></td>
                                                                                                                    <td class="tablecell"> 
                                                                                                                        <div align="right"><%=(ptc.getOID() == 0) ? pt.getLastPrice() : ptc.getLastPriceOri()%></div>
                                                                                                                    </td>
                                                                                                                    <td class="tablecell"> 
                                                                                                                        <div align="right"><%=im.getCogs()%></div>
                                                                                                                    </td>
                                                                                                                    <td class="tablecell"> 
                                                                                                                        <div align="center"> 
                                                                                                                            <input type="text" name="newprice_<%=pt.getOID()%>" size="10" value="<%=(ptc.getOID() == 0) ? 0 : ptc.getLastPrice()%>" onClick="this.select()" style="text-align: right"/>
                                                                                                                        </div>
                                                                                                                    </td>
                                                                                                                    <td class="tablecell"> 
                                                                                                                        <div align="center"><%=(ptc.getOID() == 0) ? "" : ptc.getRefNumber()%></div>
                                                                                                                    </td>
                                                                                                                    <td class="tablecell"> 
                                                                                                                        <div align="center"><%=(ptc.getOID() == 0) ? "" : JSPFormater.formatDate(ptc.getActiveDate(), "dd-MM-yyyy")%></div>
                                                                                                                    </td>
                                                                                                                    <td class="tablecell"> 
                                                                                                                        <div align="center"><%=(ptc.getOID() == 0) ? "" : ((ptc.getStatus() == 0) ? "-" : "PROCEED")%></div>
                                                                                                                    </td>
                                                                                                                    <td class="tablecell"> 
                                                                                                                        <%
                                                                                                                            if (ptc.getOID() != 0) {
                                                                                                                                User u = new User();
                                                                                                                                try {
                                                                                                                                    u = DbUser.fetch(ptc.getUserId());
                                                                                                                                    out.println(u.getLoginId());
                                                                                                                                } catch (Exception e) {
                                                                                                                                }
                                                                                                                            }
                                                                                                                        %>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                                <%} else {%>
                                                                                                                <tr> 
                                                                                                                    <td class="tablecell1"><%=start + i + 1%></td>
                                                                                                                    <td class="tablecell1"><%=vendor.getName()%></td>
                                                                                                                    <td class="tablecell1"><%=im.getBarcode()%></td>
                                                                                                                    <td class="tablecell1"><%=im.getCode()%></td>
                                                                                                                    <td class="tablecell1" nowrap><%=im.getName()%></td>
                                                                                                                    <td class="tablecell1"> 
                                                                                                                        <div align="right"><%=im.getCogs()%></div>
                                                                                                                    </td>
                                                                                                                    <td class="tablecell1"> 
                                                                                                                        <div align="right"><%=(ptc.getOID() == 0) ? pt.getLastPrice() : ptc.getLastPriceOri()%></div>
                                                                                                                    </td>
                                                                                                                    <td class="tablecell1"> 
                                                                                                                        <div align="center"> 
                                                                                                                            <input type="text" name="newprice_<%=pt.getOID()%>" size="10" value="<%=(ptc.getOID() == 0) ? 0 : ptc.getLastPrice()%>" onClick="this.select()" style="text-align: right"/>
                                                                                                                        </div>
                                                                                                                    </td>
                                                                                                                    <td class="tablecell1"> 
                                                                                                                        <div align="center"><%=(ptc.getOID() == 0) ? "" : ptc.getRefNumber()%></div>
                                                                                                                    </td>
                                                                                                                    <td class="tablecell1"> 
                                                                                                                        <div align="center"><%=(ptc.getOID() == 0) ? "" : JSPFormater.formatDate(ptc.getActiveDate(), "dd-MM-yyyy")%></div>
                                                                                                                    </td>
                                                                                                                    <td class="tablecell1"> 
                                                                                                                        <div align="center"><%=(ptc.getOID() == 0) ? "" : ((ptc.getStatus() == 0) ? "-" : "PROCEED")%></div>
                                                                                                                    </td>
                                                                                                                    <td class="tablecell1"> 
                                                                                                                        <%
                                                                                                                            if (ptc.getOID() != 0) {
                                                                                                                                User u = new User();
                                                                                                                                try {
                                                                                                                                    u = DbUser.fetch(ptc.getUserId());
                                                                                                                                    out.println(u.getLoginId());
                                                                                                                                } catch (Exception e) {
                                                                                                                                }
                                                                                                                            }
                                                                                                                        %>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                                <%}
                                                                                                                        }
                                                                                                                    }
                                                                                                                }
                                                                                                                %>
                                                                                                            </table>
                                                                                                            
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <tr align="left" valign="top"> 
                                                                                                        <td height="8" align="left" colspan="3" class="command"> 
                                                                                                            <span class="command"> 
                                                                                                                <%
                                                                                                                int cmd = 0;
                                                                                                                if ((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV) ||
                                                                                                                        (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)) {
                                                                                                                    cmd = iJSPCommand;
                                                                                                                } else {
                                                                                                                    if (iJSPCommand == JSPCommand.NONE || prevJSPCommand == JSPCommand.NONE) {
                                                                                                                        cmd = JSPCommand.FIRST;
                                                                                                                    } else {
                                                                                                                        cmd = prevJSPCommand;
                                                                                                                    }
                                                                                                                }
                                                                                                                %>
                                                                                                                <% jspLine.setLocationImg(approot + "/images/ctr_line");
                                                                                                                jspLine.initDefault();
                                                                                                                jspLine.setFirstImage("<img name=\"Image23x\" border=\"0\" src=\"" + approot + "/images/first.gif\" alt=\"First\">");
                                                                                                                jspLine.setPrevImage("<img name=\"Image24x\" border=\"0\" src=\"" + approot + "/images/prev.gif\" alt=\"Prev\">");
                                                                                                                jspLine.setNextImage("<img name=\"Image25x\" border=\"0\" src=\"" + approot + "/images/next.gif\" alt=\"Next\">");
                                                                                                                jspLine.setLastImage("<img name=\"Image26x\" border=\"0\" src=\"" + approot + "/images/last.gif\" alt=\"Last\">");

                                                                                                                jspLine.setFirstOnMouseOver("MM_swapImage('Image23x','','" + approot + "/images/first2.gif',1)");
                                                                                                                jspLine.setPrevOnMouseOver("MM_swapImage('Image24x','','" + approot + "/images/prev2.gif',1)");
                                                                                                                jspLine.setNextOnMouseOver("MM_swapImage('Image25x','','" + approot + "/images/next2.gif',1)");
                                                                                                                jspLine.setLastOnMouseOver("MM_swapImage('Image26x','','" + approot + "/images/last2.gif',1)");
                                                                                                                %>
                                                                                                        <%=jspLine.drawImageListLimit(cmd, vectSize, start, recordToGet)%> </span> </td>
                                                                                                    </tr>
                                                                                                    
                                                                                                    <tr align="left" valign="top"> 
                                                                                                        <td height="10" valign="middle" colspan="3">&nbsp;</td>
                                                                                                    </tr>
                                                                                                    <tr align="left" valign="top"> 
                                                                                                        <td>
                                                                                                            <table width="20%" border="0" cellspacing="0" cellpadding="0">
                                                                                                                <tr>
                                                                                                                    
                                                                                                                    <td><a href="javascript:cmdSave()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('save21','','../images/save2.gif',1)"><img src="../images/save.gif" name="save21" height="22" border="0"></a></td>
                                                                                                                    
                                                                                                                    
                                                                                                                </tr>
                                                                                                            </table>
                                                                                                        </td>    
                                                                                                        
                                                                                                    </tr>
                                                                                                    
                                                                                                    
                                                                                                    <%  }
            } catch (Exception exc) {
            }%>
                                                                                              
                                                                                                    <tr align="left" valign="top"> 
                                                                                                        <td height="10" valign="middle" colspan="3">&nbsp;</td>
                                                                                                    </tr>
                                                                                                    
                                                                                                    
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="8" valign="middle" colspan="3">&nbsp;</td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td>&nbsp;</td>
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </form>
                                                        <span class="level2"><br>
                                                        </span><!-- #EndEditable -->
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
                </td>
            </tr>
        </table>
    </body>
<!-- #EndTemplate --></html>
