
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.Date" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.main.db.*" %>
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
            boolean priv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MASTER_MAINTENANCE, AppMenu.M2_MASTER_PRICE_CHANGE);
            boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MASTER_MAINTENANCE, AppMenu.M2_MASTER_PRICE_CHANGE, AppMenu.PRIV_VIEW);
            boolean privUpdate = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MASTER_MAINTENANCE, AppMenu.M2_MASTER_PRICE_CHANGE, AppMenu.PRIV_UPDATE);
            boolean privAdd = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MASTER_MAINTENANCE, AppMenu.M2_MASTER_PRICE_CHANGE, AppMenu.PRIV_ADD);
            boolean privDelete = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MASTER_MAINTENANCE, AppMenu.M2_MASTER_PRICE_CHANGE, AppMenu.PRIV_DELETE);
%>
<%!
    public Vector getRefNum(long vendorId) {
        Vector result = new Vector();

        String sql = "select distinct ref_number from pos_vendor_item_change where vendor_id=" + vendorId;
        CONResultSet crs = null;
        try {
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while (rs.next()) {
                result.add((String) rs.getString("ref_number"));
            }
        } catch (Exception e) {
            System.out.println(e.toString());
        } finally {
            CONResultSet.close(crs);
        }
        sql = "select distinct ref_number from pos_price_type_change where vendor_id=" + vendorId;
        crs = null;
        try {
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while (rs.next()) {
                String stx = (String) rs.getString("ref_number");
                boolean found = false;
                if (result != null && result.size() > 0) {
                    for (int x = 0; x < result.size(); x++) {
                        String xst = (String) result.get(x);
                        if (xst.equals(stx)) {
                            found = true;
                            break;
                        }
                    }
                }
                if (!found) {
                    result.add(stx);
                }
            }
        } catch (Exception e) {
            System.out.println(e.toString());
        } finally {
            CONResultSet.close(crs);
        }
        //}	
        return result;
    }

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
            int cmdType = JSPRequestValue.requestInt(request, "cmd_type");
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

            int totGol = Integer.parseInt(DbSystemProperty.getValueByName("jum_gol"));
            /*variable declaration*/
            int recordToGet = 10;

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
            if (iJSPCommand == JSPCommand.SEARCH || iJSPCommand == JSPCommand.START || iJSPCommand == JSPCommand.ADD) {

                if (iJSPCommand == JSPCommand.SEARCH || iJSPCommand == JSPCommand.START) {

                    if (ignoreDate == 0 || srcStatus != -1 || (srcRefNumber != null && srcRefNumber.length() > 0)) {

                        String stx = "select pt.item_master_id from pos_price_type_change pt where ";

                        String st = "";

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

                            //jika search by ref number - cari historynya, lalu cari vendornya
                            Vector tempx = DbPriceTypeChange.list(0, 0, "ref_number='" + srcRefNumber + "'", "");
                            if (tempx != null && tempx.size() > 0) {
                                PriceTypeChange v = (PriceTypeChange) tempx.get(0);
                                refNumber = v.getRefNumber();
                                activeDate = v.getActiveDate();
                                srcVendorId = v.getVendorId();
                            } //jika tidak ada history maka reset semuanya
                            else {
                                refNumber = "";
                                activeDate = new Date();
                            }
                        }

                        stx = stx + st;

                        if (stx.length() > 0) {
                            whereClause = whereClause + "  and (pos_item_master.item_master_id in (" + stx + "))";
                        }
                    }
                } //search vendor change
                else if (iJSPCommand == JSPCommand.ADD) {
                    String stx = "select pt.item_master_id from pos_vendor_item_change pt where ";

                    String st = "";

                    if (refNumber != null && refNumber.length() > 0) {
                        st = st + "ref_number='" + refNumber + "'";
                        Vector tempx = DbVendorItemChange.list(0, 0, "ref_number='" + refNumber + "'", "");
                        if (tempx != null && tempx.size() > 0) {
                            VendorItemChange v = (VendorItemChange) tempx.get(0);
                            srcVendorId = v.getVendorId();
                        }
                    }

                    stx = stx + st;

                    if (stx.length() > 0) {
                        whereClause = whereClause + "  and (pos_item_master.item_master_id in (" + stx + "))";
                    }

                }
            }


            int vectSize = 0;
            if (refNumber.length() > 0 && refNumber != null) {
                //RoyvectSize = DbPriceTypeChange.getCountByRefCost(refNumber);
            } else {
                if (srcVendorId != 0) {
                    vectSize = DbItemMaster.getCountBySupplier(whereClause);
                } else {
                    vectSize = DbItemMaster.getCount(whereClause);
                }
            }


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

            if (iJSPCommand == JSPCommand.SAVE) {

                //if(cmdType==0){

                if (refNumber.length() > 0 && refNumber != null) {
                    //RoylistItemMaster = DbPriceTypeChange.listByRefCost(start, recordToGet, refNumber, orderClause);
                } else {
                    if (srcVendorId != 0) {
                        listItemMaster = DbItemMaster.listByVendor(start, recordToGet, whereClause, orderClause);
                    } else {
                        listItemMaster = DbItemMaster.list(start, recordToGet, whereClause, orderClause);
                    }
                }

                if (listItemMaster.size() > 0) {
                    for (int i = 0; i < listItemMaster.size(); i++) {

                        ItemMaster im = (ItemMaster) listItemMaster.get(i);

                        //ambil prce type semua
                        Vector pts = DbPriceType.list(0, 0, "item_master_id=" + im.getOID(), "");

                        if (pts != null && pts.size() > 0) {

                            String genRefNum = JSPFormater.formatDate(new Date(), "ddMMyyHHmmss");

                            for (int ix = 0; ix < pts.size(); ix++) {

                                PriceType pt = (PriceType) pts.get(ix);

                                PriceTypeChange ptc = new PriceTypeChange();
                                try {
                                    String where = "price_type_id=" + pt.getOID() + " and ref_number='" + refNumber + "' and to_days(active_date)=to_days('" + JSPFormater.formatDate(activeDate, "yyyy-MM-dd") + "')";
                                    Vector tempx = DbPriceTypeChange.list(0, 1, where, "");
                                    if (tempx != null && tempx.size() > 0) {
                                        ptc = (PriceTypeChange) tempx.get(0);
                                    }
                                } catch (Exception ex) {

                                }

                                //hanya proses yg statusnya open
                                if (ptc.getStatus() == 0) {

                                    ptc.setActiveDate(activeDate);
                                    ptc.setPriceTypeId(pt.getOID());
                                    ptc.setDate(new Date());
                                    ptc.setUserId(user.getOID());
                                    ptc.setItemMasterId(pt.getItemMasterId());
                                    ptc.setQtyFrom(pt.getQtyFrom());
                                    ptc.setQtyTo(pt.getQtyTo());
                                    ptc.setRefNumber(refNumber);
                                    ptc.setVendorId(srcVendorId);
                                    ptc.setType(cmdType);

                                    double gol1 = JSPRequestValue.requestDouble(request, "gol1_" + pt.getOID());
                                    double gol2 = JSPRequestValue.requestDouble(request, "gol2_" + pt.getOID());
                                    double gol3 = JSPRequestValue.requestDouble(request, "gol3_" + pt.getOID());
                                    double gol4 = JSPRequestValue.requestDouble(request, "gol4_" + pt.getOID());
                                    double gol5 = JSPRequestValue.requestDouble(request, "gol5_" + pt.getOID());
                                    double gol6 = JSPRequestValue.requestDouble(request, "gol6_" + pt.getOID());
                                    double gol7 = JSPRequestValue.requestDouble(request, "gol7_" + pt.getOID());
                                    double gol8 = JSPRequestValue.requestDouble(request, "gol8_" + pt.getOID());
                                    double gol9 = JSPRequestValue.requestDouble(request, "gol9_" + pt.getOID());
                                    double gol10 = JSPRequestValue.requestDouble(request, "gol10_" + pt.getOID());
                                    double gol1ori = JSPRequestValue.requestDouble(request, "gol1ori_" + pt.getOID());
                                    double gol2ori = JSPRequestValue.requestDouble(request, "gol2ori_" + pt.getOID());
                                    double gol3ori = JSPRequestValue.requestDouble(request, "gol3ori_" + pt.getOID());
                                    double gol4ori = JSPRequestValue.requestDouble(request, "gol4ori_" + pt.getOID());
                                    double gol5ori = JSPRequestValue.requestDouble(request, "gol5ori_" + pt.getOID());
                                    double gol6ori = JSPRequestValue.requestDouble(request, "gol6ori_" + pt.getOID());
                                    double gol7ori = JSPRequestValue.requestDouble(request, "gol7ori_" + pt.getOID());
                                    double gol8ori = JSPRequestValue.requestDouble(request, "gol8ori_" + pt.getOID());
                                    double gol9ori = JSPRequestValue.requestDouble(request, "gol9ori_" + pt.getOID());
                                    double gol10ori = JSPRequestValue.requestDouble(request, "gol10ori_" + pt.getOID());

                                    double m1 = JSPRequestValue.requestDouble(request, "m1_" + pt.getOID());
                                    double m2 = JSPRequestValue.requestDouble(request, "m2_" + pt.getOID());
                                    double m3 = JSPRequestValue.requestDouble(request, "m3_" + pt.getOID());
                                    double m4 = JSPRequestValue.requestDouble(request, "m4_" + pt.getOID());
                                    double m5 = JSPRequestValue.requestDouble(request, "m5_" + pt.getOID());
                                    double m6 = JSPRequestValue.requestDouble(request, "m6_" + pt.getOID());
                                    double m7 = JSPRequestValue.requestDouble(request, "m7_" + pt.getOID());
                                    double m8 = JSPRequestValue.requestDouble(request, "m8_" + pt.getOID());
                                    double m9 = JSPRequestValue.requestDouble(request, "m9_" + pt.getOID());
                                    double m10 = JSPRequestValue.requestDouble(request, "m10_" + pt.getOID());

                                    boolean process = false;
                                    if ((gol1 == gol1ori) && (gol2 == gol2ori) && (gol3 == gol3ori) && (gol4 == gol4ori) && (gol5 == gol5ori) && (gol6 == gol6ori) && (gol7 == gol7ori) && (gol8 == gol8ori) && (gol9 == gol9ori) && (gol10 == gol10ori)) {

                                        //delete jika ada
                                        if (ptc.getOID() != 0) {
                                            DbPriceTypeChange.deleteExc(ptc.getOID());
                                        }

                                        process = false;//jika tidak ada perubahan ga usah diproses
                                    } else {
                                        process = true;
                                    }

                                    if (process) {

                                        ptc.setGol1(gol1);
                                        ptc.setGol2(gol2);
                                        ptc.setGol3(gol3);
                                        ptc.setGol4(gol4);
                                        ptc.setGol5(gol5);
                                        ptc.setGol6(gol6);
                                        ptc.setGol7(gol7);
                                        ptc.setGol8(gol8);
                                        ptc.setGol9(gol9);
                                        ptc.setGol10(gol10);
                                        ptc.setGol1ori(gol1ori);
                                        ptc.setGol2ori(gol2ori);
                                        ptc.setGol3ori(gol3ori);
                                        ptc.setGol4ori(gol4ori);
                                        ptc.setGol5ori(gol5ori);
                                        ptc.setGol6ori(gol6ori);
                                        ptc.setGol7ori(gol7ori);
                                        ptc.setGol8ori(gol8ori);
                                        ptc.setGol9ori(gol9ori);
                                        ptc.setGol10ori(gol10ori);

                                        ptc.setGol1_margin(m1);
                                        ptc.setGol2_margin(m2);
                                        ptc.setGol3_margin(m3);
                                        ptc.setGol4_margin(m4);
                                        ptc.setGol5_margin(m5);
                                        ptc.setGol6_margin(m6);
                                        ptc.setGol7_margin(m7);
                                        ptc.setGol8_margin(m8);
                                        ptc.setGol9_margin(m9);
                                        ptc.setGol10_margin(m10);

                                        //out.println("ptc.getOID() : "+ptc.getOID());
                                        long oid1 = 0;
                                        try {
                                            if (ptc.getOID() != 0) {
                                                oid1 = DbPriceTypeChange.updateExc(ptc);
                                            } else {
                                                if (ptc.getType() == 0) {
                                                    ptc.setRefNumber(genRefNum);
                                                }
                                                oid1 = DbPriceTypeChange.insertExc(ptc);
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

                                                //PriceTypeChange ptc = (PriceTypeChange)tempx.get(i);
                                                PriceType ptold = new PriceType();
                                                PriceType ptnew = new PriceType();
                                                try {
                                                    ptnew = DbPriceType.fetchExc(ptc.getPriceTypeId());
                                                    ptold = DbPriceType.fetchExc(ptc.getPriceTypeId());
                                                    ptnew.setGol1(ptc.getGol1());
                                                    ptnew.setGol2(ptc.getGol2());
                                                    ptnew.setGol3(ptc.getGol3());
                                                    ptnew.setGol4(ptc.getGol4());
                                                    ptnew.setGol5(ptc.getGol5());
                                                    ptnew.setGol6(ptc.getGol6());
                                                    ptnew.setGol7(ptc.getGol7());
                                                    ptnew.setGol8(ptc.getGol8());
                                                    ptnew.setGol9(ptc.getGol9());
                                                    ptnew.setGol10(ptc.getGol10());
                                                    ptnew.setGol1_margin(ptc.getGol1_margin());
                                                    ptnew.setGol2_margin(ptc.getGol2_margin());
                                                    ptnew.setGol3_margin(ptc.getGol3_margin());
                                                    ptnew.setGol4_margin(ptc.getGol4_margin());
                                                    ptnew.setGol5_margin(ptc.getGol5_margin());
                                                    ptnew.setGol6_margin(ptc.getGol6_margin());
                                                    ptnew.setGol7_margin(ptc.getGol7_margin());
                                                    ptnew.setGol8_margin(ptc.getGol8_margin());
                                                    ptnew.setGol9_margin(ptc.getGol9_margin());
                                                    ptnew.setGol10_margin(ptc.getGol10_margin());
                                                    ptnew.setChangeDate(new Date());

                                                    long oid = DbPriceType.updateExc(ptnew);
                                                    if (oid != 0) {
                                                        ptc.setStatus(1);
                                                        DbPriceTypeChange.updateExc(ptc);
                                                        User u = DbUser.fetch(ptc.getUserId());

                                                        DbPriceType.insertOperationLog(0, ptc.getUserId(), u.getFullName() + "-Autoupdate", ptold, ptnew);
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


            if (refNumber.length() > 0 && refNumber != null) {
                //RoylistItemMaster = DbPriceTypeChange.listByRefCost(start, recordToGet, refNumber, orderClause);
            } else {
                if (srcVendorId != 0) {
                    listItemMaster = DbItemMaster.listByVendor(start, recordToGet, whereClause, orderClause);
                } else {
                    listItemMaster = DbItemMaster.list(start, recordToGet, whereClause, orderClause);
                }
            }

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
            <%if (!priv || !privView) {%>
            window.location="<%=approot%>/nopriv.jsp";
            <%}%>
            function cmdChangeMe1(){
                var cmdType = document.frmitemmaster.cmd_type.value;
                if(parseFloat(cmdType)==0){
                    if(confirm("Selecting vendor will update mode to SETUP BY COST, proceed ?")){
                        document.frmitemmaster.cmd_type.value="1";
                        document.frmitemmaster.command.value="<%=JSPCommand.START%>"; 
                        document.frmitemmaster.action="sellingpricechange.jsp";  
                        document.frmitemmaster.submit();    
                    }
                } 
                else{
                    document.frmitemmaster.cmd_type.value="1";
                    document.frmitemmaster.command.value="<%=JSPCommand.START%>";
                    document.frmitemmaster.action="sellingpricechange.jsp";  
                    document.frmitemmaster.submit();    
                }
                
            }
            
            function cmdChangeMe(){
                document.frmitemmaster.ref_number.value="";
                document.frmitemmaster.src_ref_number.value="";
                document.frmitemmaster.cmd_type.value="<%=cmdType%>";
                document.frmitemmaster.command.value="<%=JSPCommand.START%>";
                document.frmitemmaster.action="sellingpricechange.jsp";
                document.frmitemmaster.submit();    
                
            }
            
            function cmdByCost(){
                var rn = document.frmitemmaster.ref_number.value;
                
                if(rn==""){
                    alert("Please enter vendor reference number");
                    document.frmitemmaster.ref_number.focus();
                }
                else{
                    
                    document.frmitemmaster.src_group.value="0";
                    document.frmitemmaster.src_category.value="0";
                    document.frmitemmaster.src_code.value="";
                    document.frmitemmaster.src_barcode.value="";
                    document.frmitemmaster.src_name.value="";
                    
                    document.frmitemmaster.cmd_type.value="1";
                    document.frmitemmaster.command.value="<%=JSPCommand.ADD%>";
                    document.frmitemmaster.action="sellingpricechange.jsp";
                    document.frmitemmaster.submit();
                }
            }
            
            function cmdNewPrice(){
                //document.frmitemmaster.hidden_item_master_id.value="0";
                document.frmitemmaster.src_vendor_id.value="0";
                document.frmitemmaster.ref_number.value="";
                document.frmitemmaster.src_ref_number.value="";
                document.frmitemmaster.cmd_type.value="0";
                document.frmitemmaster.command.value="<%=JSPCommand.SEARCH%>";
                document.frmitemmaster.prev_command.value="<%=prevJSPCommand%>";
                document.frmitemmaster.action="sellingpricechange.jsp";
                document.frmitemmaster.submit();
            }
            
            function cmdPrintXLS(){	 
                window.open("<%=printroot%>.report.RptItemMasterXLS?idx=<%=System.currentTimeMillis()%>");
                }    
                
                function cmdSearch(){
                    
                    document.frmitemmaster.cmd_type.value="0"; 
                    document.frmitemmaster.ref_number.value="";
                    document.frmitemmaster.command.value="<%=JSPCommand.SEARCH%>";         
                    document.frmitemmaster.xcommand.value="<%=JSPCommand.SEARCH%>";         
                    document.frmitemmaster.start.value="0";
                    document.frmitemmaster.prev_command.value="<%=prevJSPCommand%>";
                    document.frmitemmaster.action="sellingpricechange.jsp";
                    document.frmitemmaster.submit();
                }
                
                
                function cmdSave(){
                    document.frmitemmaster.command.value="<%=JSPCommand.SAVE%>";
                    document.frmitemmaster.prev_command.value="<%=prevJSPCommand%>";
                    document.frmitemmaster.action="sellingpricechange.jsp";
                    document.frmitemmaster.submit();
                }
                
                function cmdListFirst(){
                    if(confirm("Warning, process this action will save your update to database, process anyway ?")){
                        document.frmitemmaster.command.value="<%=JSPCommand.FIRST%>";
                        document.frmitemmaster.prev_command.value="<%=JSPCommand.FIRST%>";
                        document.frmitemmaster.action="sellingpricechange.jsp";
                        document.frmitemmaster.submit();
                    }
                }
                
                function cmdListPrev(){
                    
                    if(confirm("Warning, process this action will save your update to database, process anyway ?")){
                        document.frmitemmaster.command.value="<%=JSPCommand.PREV%>";
                        document.frmitemmaster.prev_command.value="<%=JSPCommand.PREV%>";
                        document.frmitemmaster.action="sellingpricechange.jsp";
                        document.frmitemmaster.submit();
                    }
                }
                
                function cmdListNext(){
                    if(confirm("Warning, process this action will save your update to database, process anyway ?")){     
                        document.frmitemmaster.command.value="<%=JSPCommand.NEXT%>";
                        document.frmitemmaster.prev_command.value="<%=JSPCommand.NEXT%>";
                        document.frmitemmaster.action="sellingpricechange.jsp";
                        document.frmitemmaster.submit();
                    }
                }
                
                function cmdListLast(){
                    if(confirm("Warning, process this action will save your update to database, process anyway ?")){
                        document.frmitemmaster.command.value="<%=JSPCommand.LAST%>";
                        document.frmitemmaster.prev_command.value="<%=JSPCommand.LAST%>";
                        document.frmitemmaster.action="sellingpricechange.jsp";
                        document.frmitemmaster.submit();
                    }
                }
                
                
                
                function cmdEdit(oidItemMaster){
                    document.frmitemmaster.hidden_item_master_id.value=oidItemMaster;  
                    document.frmitemmaster.command.value="<%=JSPCommand.EDIT%>";
                    document.frmitemmaster.prev_command.value="<%=prevJSPCommand%>";
                    document.frmitemmaster.action="sellingpricechange.jsp";
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
                
                
                function checkGol1(oid,oidpt){
                    <%if (listItemMaster.size() > 0) {%> 
                    <%for (int i = 0; i < listItemMaster.size(); i++) {%>
                    <%ItemMaster im = (ItemMaster) listItemMaster.get(i);%>  
                    if(oid==<%=im.getOID()%>){
                         <%
    //ambil prce type semua
    Vector pts = DbPriceType.list(0, 0, "item_master_id=" + im.getOID(), "");

    if (pts != null && pts.size() > 0) {

        for (int ix = 0; ix < pts.size(); ix++) {

            PriceType pt = (PriceType) pts.get(ix);
                                 %>
                                     if(oidpt ==<%=pt.getOID()%>){
                                         
                                         var st = document.frmitemmaster.gol1_<%=pt.getOID()%>.value;	
                                         var cog = document.frmitemmaster.hpp_<%=im.getOID()%>.value;
                                         var mar = document.frmitemmaster.m1_<%=pt.getOID()%>.value;
                                         var cost = document.frmitemmaster.cost_<%=im.getOID()%>.value;
                                         var ppn_val=document.frmitemmaster.ppn_<%=im.getOID()%>.value;
                                         
                                         
                                         if(parseFloat(cost) > parseFloat(cog)){
                                             cog = cost;
                                             document.frmitemmaster.hpp_<%=im.getOID()%>.value =cog; 
                                         }
                                         if (parseFloat(ppn_val)>0){
                                             ppn_val = cog/10
                                         }
                                         
                                         mar=((((parseFloat(st)/(parseFloat(cog)+parseFloat(ppn_val)))*100)-100)/((parseFloat(st)/(parseFloat(cog)+parseFloat(ppn_val)))*100)) * 100;
                                         if(mar > 0){
                                             
                                         }else{
                                         var mar =0;
                                     }
                                     
                                     document.frmitemmaster.m1_<%=pt.getOID()%>.value =mar; 
                                 } }   
                 <%}
        }
    }%>
    
    <%}%>
    
}

function checkMargin1(oid, oidpt){  
    
    <%if (listItemMaster.size() > 0) {%>
    <%for (int i = 0; i < listItemMaster.size(); i++) {%>
                                 <%
    ItemMaster im = (ItemMaster) listItemMaster.get(i);%>
        if(oid==<%=im.getOID()%>){
                                 <%
    //ambil prce type semua
    Vector pts = DbPriceType.list(0, 0, "item_master_id=" + im.getOID(), "");

    if (pts != null && pts.size() > 0) {

        for (int ix = 0; ix < pts.size(); ix++) {

            PriceType pt = (PriceType) pts.get(ix);

                                 %>
                                     if(oidpt ==<%=pt.getOID()%>){
                                         
                                         var st = document.frmitemmaster.gol1_<%=pt.getOID()%>.value;	
                                         var cog = document.frmitemmaster.hpp_<%=im.getOID()%>.value;
                                         var mar = document.frmitemmaster.m1_<%=pt.getOID()%>.value;
                                         var cost = document.frmitemmaster.cost_<%=im.getOID()%>.value;
                                         var ppn_val=document.frmitemmaster.ppn_<%=im.getOID()%>.value;
                                         
                                         if(parseFloat(cost) > parseFloat(cog)){
                                             cog = cost;
                                             document.frmitemmaster.hpp_<%=im.getOID()%>.value =cog; 
                                         }
                                         //cog = cleanNumberFloat(cog, sysDecSymbol, usrDigitGroup, usrDecSymbol);	
                                         //st=parseFloat(mar)/100 * parseFloat(cog) + parseFloat(cog) + parseFloat(ppn_val);
                                         if (parseFloat(ppn_val)>0){
                                             ppn_val = cog/10
                                         }
                                         st=((100/(100-parseFloat(mar)))* (parseFloat(cog)+parseFloat(ppn_val)));
                                         
                                         
                                         
                                         document.frmitemmaster.gol1_<%=pt.getOID()%>.value =st; 
                                     } }   
                         <%}
        }
    }%>
    
    <%}%>
    
}

function checkGol2(oid,oidpt){
    <%if (listItemMaster.size() > 0) {%> 
    <%for (int i = 0; i < listItemMaster.size(); i++) {%>
    <%ItemMaster im = (ItemMaster) listItemMaster.get(i);%>  
    if(oid==<%=im.getOID()%>){
                         <%
    //ambil prce type semua
    Vector pts = DbPriceType.list(0, 0, "item_master_id=" + im.getOID(), "");

    if (pts != null && pts.size() > 0) {

        for (int ix = 0; ix < pts.size(); ix++) {

            PriceType pt = (PriceType) pts.get(ix);
                                 %>
                                     if(oidpt ==<%=pt.getOID()%>){
                                         
                                         var st = document.frmitemmaster.gol2_<%=pt.getOID()%>.value;	
                                         var cog = document.frmitemmaster.hpp_<%=im.getOID()%>.value;
                                         var mar = document.frmitemmaster.m2_<%=pt.getOID()%>.value;
                                         var cost = document.frmitemmaster.cost_<%=im.getOID()%>.value;
                                         var ppn_val=document.frmitemmaster.ppn_<%=im.getOID()%>.value;
                                         
                                         
                                         if(parseFloat(cost) > parseFloat(cog)){
                                             cog = cost;
                                             document.frmitemmaster.hpp_<%=im.getOID()%>.value =cog; 
                                         }
                                         if (parseFloat(ppn_val)>0){
                                             ppn_val = cog/10
                                         }         
                                         //var ppn_val=0;
                                         //cog = cleanNumberFloat(cog, sysDecSymbol, usrDigitGroup, usrDecSymbol);	                              
                                         //mar=((parseFloat(st)-parseFloat(cog)-parseFloat(ppn_val)) / parseFloat(cog)) * 100;
                                         mar=((((parseFloat(st)/(parseFloat(cog)+parseFloat(ppn_val)))*100)-100)/((parseFloat(st)/(parseFloat(cog)+parseFloat(ppn_val)))*100)) * 100;
                                         if(mar > 0){
                                             
                                         }else{
                                         var mar =0;
                                     }
                                     
                                     document.frmitemmaster.m2_<%=pt.getOID()%>.value =mar; 
                                 } }   
                 <%}
        }
    }%>
    
    <%}%>
    
}

function checkMargin2(oid, oidpt){  
    
    <%if (listItemMaster.size() > 0) {%>
    <%for (int i = 0; i < listItemMaster.size(); i++) {%>
                                 <%
    ItemMaster im = (ItemMaster) listItemMaster.get(i);%>
        if(oid==<%=im.getOID()%>){
                                 <%
    //ambil prce type semua
    Vector pts = DbPriceType.list(0, 0, "item_master_id=" + im.getOID(), "");

    if (pts != null && pts.size() > 0) {

        for (int ix = 0; ix < pts.size(); ix++) {

            PriceType pt = (PriceType) pts.get(ix);

                                 %>
                                     if(oidpt ==<%=pt.getOID()%>){
                                         
                                         var st = document.frmitemmaster.gol2_<%=pt.getOID()%>.value;	
                                         var cog = document.frmitemmaster.hpp_<%=im.getOID()%>.value;
                                         var mar = document.frmitemmaster.m2_<%=pt.getOID()%>.value;
                                         var cost = document.frmitemmaster.cost_<%=im.getOID()%>.value;
                                         var ppn_val=document.frmitemmaster.ppn_<%=im.getOID()%>.value;
                                         
                                         if(parseFloat(cost) > parseFloat(cog)){
                                             cog = cost;
                                             document.frmitemmaster.hpp_<%=im.getOID()%>.value =cog; 
                                         }
                                         if (parseFloat(ppn_val)>0){
                                             ppn_val = cog/10
                                         }
                                         //cog = cleanNumberFloat(cog, sysDecSymbol, usrDigitGroup, usrDecSymbol);	
                                         //st=parseFloat(mar)/100 * parseFloat(cog) + parseFloat(cog) + parseFloat(ppn_val);
                                         st=((100/(100-parseFloat(mar)))* (parseFloat(cog)+parseFloat(ppn_val)));
                                         
                                         
                                         document.frmitemmaster.gol2_<%=pt.getOID()%>.value =st; 
                                     } }   
                         <%}
        }
    }%>
    
    <%}%>
    
}

function checkGol3(oid,oidpt){
    <%if (listItemMaster.size() > 0) {%> 
    <%for (int i = 0; i < listItemMaster.size(); i++) {%>
    <%ItemMaster im = (ItemMaster) listItemMaster.get(i);%>  
    if(oid==<%=im.getOID()%>){
                         <%
    //ambil prce type semua
    Vector pts = DbPriceType.list(0, 0, "item_master_id=" + im.getOID(), "");

    if (pts != null && pts.size() > 0) {

        for (int ix = 0; ix < pts.size(); ix++) {

            PriceType pt = (PriceType) pts.get(ix);
                                 %>
                                     if(oidpt ==<%=pt.getOID()%>){
                                         
                                         var st = document.frmitemmaster.gol3_<%=pt.getOID()%>.value;	
                                         var cog = document.frmitemmaster.hpp_<%=im.getOID()%>.value;
                                         var mar = document.frmitemmaster.m3_<%=pt.getOID()%>.value;
                                         var cost = document.frmitemmaster.cost_<%=im.getOID()%>.value;
                                         var ppn_val=document.frmitemmaster.ppn_<%=im.getOID()%>.value;
                                         
                                         
                                         if(parseFloat(cost) > parseFloat(cog)){
                                             cog = cost;
                                             document.frmitemmaster.hpp_<%=im.getOID()%>.value =cog; 
                                         }
                                         if (parseFloat(ppn_val)>0){
                                             ppn_val = cog/10
                                         }
                                         //var ppn_val=0;
                                         //cog = cleanNumberFloat(cog, sysDecSymbol, usrDigitGroup, usrDecSymbol);	                              
                                         //mar=((parseFloat(st)-parseFloat(cog)-parseFloat(ppn_val)) / parseFloat(cog)) * 100;
                                         mar=((((parseFloat(st)/(parseFloat(cog)+parseFloat(ppn_val)))*100)-100)/((parseFloat(st)/(parseFloat(cog)+parseFloat(ppn_val)))*100)) * 100;
                                         if(mar > 0){
                                             
                                         }else{
                                         var mar =0;
                                     }
                                     
                                     document.frmitemmaster.m3_<%=pt.getOID()%>.value =mar; 
                                 } }   
                 <%}
        }
    }%>
    
    <%}%>
    
}

function checkMargin3(oid, oidpt){  
    
    <%if (listItemMaster.size() > 0) {%>
    <%for (int i = 0; i < listItemMaster.size(); i++) {%>
                                 <%
    ItemMaster im = (ItemMaster) listItemMaster.get(i);%>
        if(oid==<%=im.getOID()%>){
                                 <%
    //ambil prce type semua
    Vector pts = DbPriceType.list(0, 0, "item_master_id=" + im.getOID(), "");

    if (pts != null && pts.size() > 0) {

        for (int ix = 0; ix < pts.size(); ix++) {

            PriceType pt = (PriceType) pts.get(ix);

                                 %>
                                     if(oidpt ==<%=pt.getOID()%>){
                                         
                                         var st = document.frmitemmaster.gol3_<%=pt.getOID()%>.value;	
                                         var cog = document.frmitemmaster.hpp_<%=im.getOID()%>.value;
                                         var mar = document.frmitemmaster.m3_<%=pt.getOID()%>.value;
                                         var cost = document.frmitemmaster.cost_<%=im.getOID()%>.value;
                                         var ppn_val=document.frmitemmaster.ppn_<%=im.getOID()%>.value;
                                         
                                         if(parseFloat(cost) > parseFloat(cog)){
                                             cog = cost;
                                             document.frmitemmaster.hpp_<%=im.getOID()%>.value =cog; 
                                         }
                                         if (parseFloat(ppn_val)>0){
                                             ppn_val = cog/10
                                         }
                                         //cog = cleanNumberFloat(cog, sysDecSymbol, usrDigitGroup, usrDecSymbol);	
                                         //st=parseFloat(mar)/100 * parseFloat(cog) + parseFloat(cog) + parseFloat(ppn_val);
                                         st=((100/(100-parseFloat(mar)))* (parseFloat(cog)+parseFloat(ppn_val)));
                                         
                                         
                                         document.frmitemmaster.gol3_<%=pt.getOID()%>.value =st; 
                                     } }   
                         <%}
        }
    }%>
    
    <%}%>
    
}

function checkGol4(oid,oidpt){
    <%if (listItemMaster.size() > 0) {%> 
    <%for (int i = 0; i < listItemMaster.size(); i++) {%>
    <%ItemMaster im = (ItemMaster) listItemMaster.get(i);%>  
    if(oid==<%=im.getOID()%>){
                         <%
    //ambil prce type semua
    Vector pts = DbPriceType.list(0, 0, "item_master_id=" + im.getOID(), "");

    if (pts != null && pts.size() > 0) {

        for (int ix = 0; ix < pts.size(); ix++) {

            PriceType pt = (PriceType) pts.get(ix);
                                 %>
                                     if(oidpt ==<%=pt.getOID()%>){
                                         
                                         var st = document.frmitemmaster.gol4_<%=pt.getOID()%>.value;	
                                         var cog = document.frmitemmaster.hpp_<%=im.getOID()%>.value;
                                         var mar = document.frmitemmaster.m4_<%=pt.getOID()%>.value;
                                         var cost = document.frmitemmaster.cost_<%=im.getOID()%>.value;
                                         var ppn_val=document.frmitemmaster.ppn_<%=im.getOID()%>.value;
                                         
                                         
                                         if(parseFloat(cost) > parseFloat(cog)){
                                             cog = cost;
                                             document.frmitemmaster.hpp_<%=im.getOID()%>.value =cog; 
                                         }
                                         if (parseFloat(ppn_val)>0){
                                             ppn_val = cog/10
                                         }
                                         //var ppn_val=0;
                                         //cog = cleanNumberFloat(cog, sysDecSymbol, usrDigitGroup, usrDecSymbol);	                              
                                         //mar=((parseFloat(st)-parseFloat(cog)-parseFloat(ppn_val)) / parseFloat(cog)) * 100;
                                         mar=((((parseFloat(st)/(parseFloat(cog)+parseFloat(ppn_val)))*100)-100)/((parseFloat(st)/(parseFloat(cog)+parseFloat(ppn_val)))*100)) * 100;
                                         if(mar > 0){
                                             
                                         }else{
                                         var mar =0;
                                     }
                                     
                                     document.frmitemmaster.m4_<%=pt.getOID()%>.value =mar; 
                                 } }   
                 <%}
        }
    }%>
    
    <%}%>
    
}

function checkMargin4(oid, oidpt){  
    
    <%if (listItemMaster.size() > 0) {%>
    <%for (int i = 0; i < listItemMaster.size(); i++) {%>
                                 <%
    ItemMaster im = (ItemMaster) listItemMaster.get(i);%>
        if(oid==<%=im.getOID()%>){
                                 <%
    //ambil prce type semua
    Vector pts = DbPriceType.list(0, 0, "item_master_id=" + im.getOID(), "");

    if (pts != null && pts.size() > 0) {

        for (int ix = 0; ix < pts.size(); ix++) {

            PriceType pt = (PriceType) pts.get(ix);

                                 %>
                                     if(oidpt ==<%=pt.getOID()%>){
                                         
                                         var st = document.frmitemmaster.gol4_<%=pt.getOID()%>.value;	
                                         var cog = document.frmitemmaster.hpp_<%=im.getOID()%>.value;
                                         var mar = document.frmitemmaster.m4_<%=pt.getOID()%>.value;
                                         var cost = document.frmitemmaster.cost_<%=im.getOID()%>.value;
                                         var ppn_val=document.frmitemmaster.ppn_<%=im.getOID()%>.value;
                                         
                                         if(parseFloat(cost) > parseFloat(cog)){
                                             cog = cost;
                                             document.frmitemmaster.hpp_<%=im.getOID()%>.value =cog; 
                                         }
                                         if (parseFloat(ppn_val)>0){
                                             ppn_val = cog/10
                                         }
                                         //cog = cleanNumberFloat(cog, sysDecSymbol, usrDigitGroup, usrDecSymbol);	
                                         //st=parseFloat(mar)/100 * parseFloat(cog) + parseFloat(cog) + parseFloat(ppn_val);
                                         st=((100/(100-parseFloat(mar)))* (parseFloat(cog)+parseFloat(ppn_val)));
                                         
                                         
                                         document.frmitemmaster.gol4_<%=pt.getOID()%>.value =st; 
                                     } }   
                         <%}
        }
    }%>
    
    <%}%>
    
}

function checkGol5(oid,oidpt){
    <%if (listItemMaster.size() > 0) {%> 
    <%for (int i = 0; i < listItemMaster.size(); i++) {%>
    <%ItemMaster im = (ItemMaster) listItemMaster.get(i);%>  
    if(oid==<%=im.getOID()%>){
                         <%
    //ambil prce type semua
    Vector pts = DbPriceType.list(0, 0, "item_master_id=" + im.getOID(), "");

    if (pts != null && pts.size() > 0) {

        for (int ix = 0; ix < pts.size(); ix++) {

            PriceType pt = (PriceType) pts.get(ix);
                                 %>
                                     if(oidpt ==<%=pt.getOID()%>){
                                         
                                         var st = document.frmitemmaster.gol5_<%=pt.getOID()%>.value;	
                                         var cog = document.frmitemmaster.hpp_<%=im.getOID()%>.value;
                                         var mar = document.frmitemmaster.m5_<%=pt.getOID()%>.value;
                                         var cost = document.frmitemmaster.cost_<%=im.getOID()%>.value;
                                         var ppn_val=document.frmitemmaster.ppn_<%=im.getOID()%>.value;
                                         
                                         
                                         if(parseFloat(cost) > parseFloat(cog)){
                                             cog = cost;
                                             document.frmitemmaster.hpp_<%=im.getOID()%>.value =cog; 
                                         }
                                         if (parseFloat(ppn_val)>0){
                                             ppn_val = cog/10
                                         }
                                         //var ppn_val=0;
                                         //cog = cleanNumberFloat(cog, sysDecSymbol, usrDigitGroup, usrDecSymbol);	                              
                                         //mar=((parseFloat(st)-parseFloat(cog)-parseFloat(ppn_val)) / parseFloat(cog)) * 100;
                                         mar=((((parseFloat(st)/(parseFloat(cog)+parseFloat(ppn_val)))*100)-100)/((parseFloat(st)/(parseFloat(cog)+parseFloat(ppn_val)))*100)) * 100;
                                         if(mar > 0){
                                             
                                         }else{
                                         var mar =0;
                                     }
                                     
                                     document.frmitemmaster.m5_<%=pt.getOID()%>.value =mar; 
                                 } }   
                 <%}
        }
    }%>
    
    <%}%>
    
}

function checkMargin5(oid, oidpt){  
    
    <%if (listItemMaster.size() > 0) {%>
    <%for (int i = 0; i < listItemMaster.size(); i++) {%>
                                 <%
    ItemMaster im = (ItemMaster) listItemMaster.get(i);%>
        if(oid==<%=im.getOID()%>){
                                 <%
    //ambil prce type semua
    Vector pts = DbPriceType.list(0, 0, "item_master_id=" + im.getOID(), "");

    if (pts != null && pts.size() > 0) {

        for (int ix = 0; ix < pts.size(); ix++) {

            PriceType pt = (PriceType) pts.get(ix);

                                 %>
                                     if(oidpt ==<%=pt.getOID()%>){
                                         
                                         var st = document.frmitemmaster.gol5_<%=pt.getOID()%>.value;	
                                         var cog = document.frmitemmaster.hpp_<%=im.getOID()%>.value;
                                         var mar = document.frmitemmaster.m5_<%=pt.getOID()%>.value;
                                         var cost = document.frmitemmaster.cost_<%=im.getOID()%>.value;
                                         var ppn_val=document.frmitemmaster.ppn_<%=im.getOID()%>.value;
                                         
                                         if(parseFloat(cost) > parseFloat(cog)){
                                             cog = cost;
                                             document.frmitemmaster.hpp_<%=im.getOID()%>.value =cog; 
                                         }
                                         if (parseFloat(ppn_val)>0){
                                             ppn_val = cog/10
                                         }
                                         //cog = cleanNumberFloat(cog, sysDecSymbol, usrDigitGroup, usrDecSymbol);	
                                         //st=parseFloat(mar)/100 * parseFloat(cog) + parseFloat(cog) + parseFloat(ppn_val);
                                         st=((100/(100-parseFloat(mar)))* (parseFloat(cog)+parseFloat(ppn_val)));
                                         
                                         
                                         document.frmitemmaster.gol5_<%=pt.getOID()%>.value =st; 
                                     } }   
                         <%}
        }
    }%>
    
    <%}%>
    
}


function checkGol6(oid,oidpt){
    <%if (listItemMaster.size() > 0) {%> 
    <%for (int i = 0; i < listItemMaster.size(); i++) {%>
    <%ItemMaster im = (ItemMaster) listItemMaster.get(i);%>  
    if(oid==<%=im.getOID()%>){
                         <%
    //ambil prce type semua
    Vector pts = DbPriceType.list(0, 0, "item_master_id=" + im.getOID(), "");

    if (pts != null && pts.size() > 0) {

        for (int ix = 0; ix < pts.size(); ix++) {

            PriceType pt = (PriceType) pts.get(ix);
                                 %>
                                     if(oidpt ==<%=pt.getOID()%>){
                                         
                                         var st = document.frmitemmaster.gol6_<%=pt.getOID()%>.value;	
                                         var cog = document.frmitemmaster.hpp_<%=im.getOID()%>.value;
                                         var mar = document.frmitemmaster.m6_<%=pt.getOID()%>.value;
                                         var cost = document.frmitemmaster.cost_<%=im.getOID()%>.value;
                                         var ppn_val=document.frmitemmaster.ppn_<%=im.getOID()%>.value;
                                         
                                         
                                         if(parseFloat(cost) > parseFloat(cog)){
                                             cog = cost;
                                             document.frmitemmaster.hpp_<%=im.getOID()%>.value =cog; 
                                         }
                                         if (parseFloat(ppn_val)>0){
                                             ppn_val = cog/10
                                         }
                                         //var ppn_val=0;
                                         //cog = cleanNumberFloat(cog, sysDecSymbol, usrDigitGroup, usrDecSymbol);	                              
                                         //mar=((parseFloat(st)-parseFloat(cog)-parseFloat(ppn_val)) / parseFloat(cog)) * 100;
                                         mar=((((parseFloat(st)/(parseFloat(cog)+parseFloat(ppn_val)))*100)-100)/((parseFloat(st)/(parseFloat(cog)+parseFloat(ppn_val)))*100)) * 100;
                                         if(mar > 0){
                                             
                                         }else{
                                         var mar =0;
                                     }
                                     
                                     document.frmitemmaster.m6_<%=pt.getOID()%>.value =mar; 
                                 } }   
                 <%}
        }
    }%>
    
    <%}%>
    
}

function checkMargin6(oid, oidpt){  
    
    <%if (listItemMaster.size() > 0) {%>
    <%for (int i = 0; i < listItemMaster.size(); i++) {%>
                                 <%
    ItemMaster im = (ItemMaster) listItemMaster.get(i);%>
        if(oid==<%=im.getOID()%>){
                                 <%
    //ambil prce type semua
    Vector pts = DbPriceType.list(0, 0, "item_master_id=" + im.getOID(), "");

    if (pts != null && pts.size() > 0) {

        for (int ix = 0; ix < pts.size(); ix++) {

            PriceType pt = (PriceType) pts.get(ix);

                                 %>
                                     if(oidpt ==<%=pt.getOID()%>){
                                         
                                         var st = document.frmitemmaster.gol6_<%=pt.getOID()%>.value;	
                                         var cog = document.frmitemmaster.hpp_<%=im.getOID()%>.value;
                                         var mar = document.frmitemmaster.m6_<%=pt.getOID()%>.value;
                                         var cost = document.frmitemmaster.cost_<%=im.getOID()%>.value;
                                         var ppn_val=document.frmitemmaster.ppn_<%=im.getOID()%>.value;
                                         
                                         if(parseFloat(cost) > parseFloat(cog)){
                                             cog = cost;
                                             document.frmitemmaster.hpp_<%=im.getOID()%>.value =cog; 
                                         }
                                         if (parseFloat(ppn_val)>0){
                                             ppn_val = cog/10
                                         }
                                         //cog = cleanNumberFloat(cog, sysDecSymbol, usrDigitGroup, usrDecSymbol);	
                                         //st=parseFloat(mar)/100 * parseFloat(cog) + parseFloat(cog) + parseFloat(ppn_val);
                                         st=((100/(100-parseFloat(mar)))* (parseFloat(cog)+parseFloat(ppn_val)));
                                         
                                         
                                         document.frmitemmaster.gol6_<%=pt.getOID()%>.value =st; 
                                     } }   
                         <%}
        }
    }%>
    
    <%}%>
    
}

function checkGol7(oid,oidpt){
    <%if (listItemMaster.size() > 0) {%> 
    <%for (int i = 0; i < listItemMaster.size(); i++) {%>
    <%ItemMaster im = (ItemMaster) listItemMaster.get(i);%>  
    if(oid==<%=im.getOID()%>){
                         <%
    //ambil prce type semua
    Vector pts = DbPriceType.list(0, 0, "item_master_id=" + im.getOID(), "");

    if (pts != null && pts.size() > 0) {

        for (int ix = 0; ix < pts.size(); ix++) {

            PriceType pt = (PriceType) pts.get(ix);
                                 %>
                                     if(oidpt ==<%=pt.getOID()%>){
                                         
                                         var st = document.frmitemmaster.gol7_<%=pt.getOID()%>.value;	
                                         var cog = document.frmitemmaster.hpp_<%=im.getOID()%>.value;
                                         var mar = document.frmitemmaster.m7_<%=pt.getOID()%>.value;
                                         var cost = document.frmitemmaster.cost_<%=im.getOID()%>.value;
                                         var ppn_val=document.frmitemmaster.ppn_<%=im.getOID()%>.value;
                                         
                                         
                                         if(parseFloat(cost) > parseFloat(cog)){
                                             cog = cost;
                                             document.frmitemmaster.hpp_<%=im.getOID()%>.value =cog; 
                                         }
                                         if (parseFloat(ppn_val)>0){
                                             ppn_val = cog/10
                                         }
                                         //var ppn_val=0;
                                         //cog = cleanNumberFloat(cog, sysDecSymbol, usrDigitGroup, usrDecSymbol);	                              
                                         //mar=((parseFloat(st)-parseFloat(cog)-parseFloat(ppn_val)) / parseFloat(cog)) * 100;
                                         mar=((((parseFloat(st)/(parseFloat(cog)+parseFloat(ppn_val)))*100)-100)/((parseFloat(st)/(parseFloat(cog)+parseFloat(ppn_val)))*100)) * 100;
                                         if(mar > 0){
                                             
                                         }else{
                                         var mar =0;
                                     }
                                     
                                     document.frmitemmaster.m7_<%=pt.getOID()%>.value =mar; 
                                 } }   
                 <%}
        }
    }%>
    
    <%}%>
    
}

function checkMargin7(oid, oidpt){  
    
    <%if (listItemMaster.size() > 0) {%>
    <%for (int i = 0; i < listItemMaster.size(); i++) {%>
                                 <%
    ItemMaster im = (ItemMaster) listItemMaster.get(i);%>
        if(oid==<%=im.getOID()%>){
                                 <%
    //ambil prce type semua
    Vector pts = DbPriceType.list(0, 0, "item_master_id=" + im.getOID(), "");

    if (pts != null && pts.size() > 0) {

        for (int ix = 0; ix < pts.size(); ix++) {

            PriceType pt = (PriceType) pts.get(ix);

                                 %>
                                     if(oidpt ==<%=pt.getOID()%>){
                                         
                                         var st = document.frmitemmaster.gol7_<%=pt.getOID()%>.value;	
                                         var cog = document.frmitemmaster.hpp_<%=im.getOID()%>.value;
                                         var mar = document.frmitemmaster.m7_<%=pt.getOID()%>.value;
                                         var cost = document.frmitemmaster.cost_<%=im.getOID()%>.value;
                                         var ppn_val=document.frmitemmaster.ppn_<%=im.getOID()%>.value;
                                         
                                         if(parseFloat(cost) > parseFloat(cog)){
                                             cog = cost;
                                             document.frmitemmaster.hpp_<%=im.getOID()%>.value =cog; 
                                         }
                                         if (parseFloat(ppn_val)>0){
                                             ppn_val = cog/10
                                         }
                                         //cog = cleanNumberFloat(cog, sysDecSymbol, usrDigitGroup, usrDecSymbol);	
                                         //st=parseFloat(mar)/100 * parseFloat(cog) + parseFloat(cog) + parseFloat(ppn_val);
                                         st=((100/(100-parseFloat(mar)))* (parseFloat(cog)+parseFloat(ppn_val)));
                                         
                                         
                                         document.frmitemmaster.gol7_<%=pt.getOID()%>.value =st; 
                                     } }   
                         <%}
        }
    }%>
    
    <%}%>
    
}

function checkGol8(oid,oidpt){
    <%if (listItemMaster.size() > 0) {%> 
    <%for (int i = 0; i < listItemMaster.size(); i++) {%>
    <%ItemMaster im = (ItemMaster) listItemMaster.get(i);%>  
    if(oid==<%=im.getOID()%>){
                         <%
    //ambil prce type semua
    Vector pts = DbPriceType.list(0, 0, "item_master_id=" + im.getOID(), "");

    if (pts != null && pts.size() > 0) {

        for (int ix = 0; ix < pts.size(); ix++) {

            PriceType pt = (PriceType) pts.get(ix);
                                 %>
                                     if(oidpt ==<%=pt.getOID()%>){
                                         
                                         var st = document.frmitemmaster.gol8_<%=pt.getOID()%>.value;	
                                         var cog = document.frmitemmaster.hpp_<%=im.getOID()%>.value;
                                         var mar = document.frmitemmaster.m8_<%=pt.getOID()%>.value;
                                         var cost = document.frmitemmaster.cost_<%=im.getOID()%>.value;
                                         var ppn_val=document.frmitemmaster.ppn_<%=im.getOID()%>.value;
                                         
                                         
                                         if(parseFloat(cost) > parseFloat(cog)){
                                             cog = cost;
                                             document.frmitemmaster.hpp_<%=im.getOID()%>.value =cog; 
                                         }
                                         if (parseFloat(ppn_val)>0){
                                             ppn_val = cog/10
                                         } 
                                         //var ppn_val=0;
                                         //cog = cleanNumberFloat(cog, sysDecSymbol, usrDigitGroup, usrDecSymbol);	                              
                                         //mar=((parseFloat(st)-parseFloat(cog)-parseFloat(ppn_val)) / parseFloat(cog)) * 100;
                                         mar=((((parseFloat(st)/(parseFloat(cog)+parseFloat(ppn_val)))*100)-100)/((parseFloat(st)/(parseFloat(cog)+parseFloat(ppn_val)))*100)) * 100;
                                         if(mar > 0){
                                             
                                         }else{
                                         var mar =0;
                                     }
                                     
                                     document.frmitemmaster.m8_<%=pt.getOID()%>.value =mar; 
                                 } }   
                 <%}
        }
    }%>
    
    <%}%>
    
}

function checkMargin8(oid, oidpt){  
    
    <%if (listItemMaster.size() > 0) {%>
    <%for (int i = 0; i < listItemMaster.size(); i++) {%>
                                 <%
    ItemMaster im = (ItemMaster) listItemMaster.get(i);%>
        if(oid==<%=im.getOID()%>){
                                 <%
    //ambil prce type semua
    Vector pts = DbPriceType.list(0, 0, "item_master_id=" + im.getOID(), "");

    if (pts != null && pts.size() > 0) {

        for (int ix = 0; ix < pts.size(); ix++) {

            PriceType pt = (PriceType) pts.get(ix);

                                 %>
                                     if(oidpt ==<%=pt.getOID()%>){
                                         
                                         var st = document.frmitemmaster.gol8_<%=pt.getOID()%>.value;	
                                         var cog = document.frmitemmaster.hpp_<%=im.getOID()%>.value;
                                         var mar = document.frmitemmaster.m8_<%=pt.getOID()%>.value;
                                         var cost = document.frmitemmaster.cost_<%=im.getOID()%>.value;
                                         var ppn_val=document.frmitemmaster.ppn_<%=im.getOID()%>.value;
                                         
                                         if(parseFloat(cost) > parseFloat(cog)){
                                             cog = cost;
                                             document.frmitemmaster.hpp_<%=im.getOID()%>.value =cog; 
                                         }
                                         if (parseFloat(ppn_val)>0){
                                             ppn_val = cog/10
                                         }
                                         //cog = cleanNumberFloat(cog, sysDecSymbol, usrDigitGroup, usrDecSymbol);	
                                         //st=parseFloat(mar)/100 * parseFloat(cog) + parseFloat(cog) + parseFloat(ppn_val);
                                         st=((100/(100-parseFloat(mar)))* (parseFloat(cog)+parseFloat(ppn_val)));
                                         
                                         
                                         document.frmitemmaster.gol8_<%=pt.getOID()%>.value =st; 
                                     } }   
                         <%}
        }
    }%>
    
    <%}%>
    
}

function checkGol9(oid,oidpt){
    <%if (listItemMaster.size() > 0) {%> 
    <%for (int i = 0; i < listItemMaster.size(); i++) {%>
    <%ItemMaster im = (ItemMaster) listItemMaster.get(i);%>  
    if(oid==<%=im.getOID()%>){
                         <%
    //ambil prce type semua
    Vector pts = DbPriceType.list(0, 0, "item_master_id=" + im.getOID(), "");

    if (pts != null && pts.size() > 0) {

        for (int ix = 0; ix < pts.size(); ix++) {

            PriceType pt = (PriceType) pts.get(ix);
                                 %>
                                     if(oidpt ==<%=pt.getOID()%>){
                                         
                                         var st = document.frmitemmaster.gol9_<%=pt.getOID()%>.value;	
                                         var cog = document.frmitemmaster.hpp_<%=im.getOID()%>.value;
                                         var mar = document.frmitemmaster.m9_<%=pt.getOID()%>.value;
                                         var cost = document.frmitemmaster.cost_<%=im.getOID()%>.value;
                                         var ppn_val=document.frmitemmaster.ppn_<%=im.getOID()%>.value;
                                         
                                         
                                         if(parseFloat(cost) > parseFloat(cog)){
                                             cog = cost;
                                             document.frmitemmaster.hpp_<%=im.getOID()%>.value =cog; 
                                         }
                                         if (parseFloat(ppn_val)>0){
                                             ppn_val = cog/10
                                         }
                                         //var ppn_val=0;
                                         //cog = cleanNumberFloat(cog, sysDecSymbol, usrDigitGroup, usrDecSymbol);	                              
                                         //mar=((parseFloat(st)-parseFloat(cog)-parseFloat(ppn_val)) / parseFloat(cog)) * 100;
                                         mar=((((parseFloat(st)/(parseFloat(cog)+parseFloat(ppn_val)))*100)-100)/((parseFloat(st)/(parseFloat(cog)+parseFloat(ppn_val)))*100)) * 100;
                                         if(mar > 0){
                                             
                                         }else{
                                         var mar =0;
                                     }
                                     
                                     document.frmitemmaster.m9_<%=pt.getOID()%>.value =mar; 
                                 } }   
                 <%}
        }
    }%>
    
    <%}%>
    
}

function checkMargin9(oid, oidpt){  
    
    <%if (listItemMaster.size() > 0) {%>
    <%for (int i = 0; i < listItemMaster.size(); i++) {%>
                                 <%
    ItemMaster im = (ItemMaster) listItemMaster.get(i);%>
        if(oid==<%=im.getOID()%>){
                                 <%
    //ambil prce type semua
    Vector pts = DbPriceType.list(0, 0, "item_master_id=" + im.getOID(), "");

    if (pts != null && pts.size() > 0) {

        for (int ix = 0; ix < pts.size(); ix++) {

            PriceType pt = (PriceType) pts.get(ix);

                                 %>
                                     if(oidpt ==<%=pt.getOID()%>){
                                         
                                         var st = document.frmitemmaster.gol9_<%=pt.getOID()%>.value;	
                                         var cog = document.frmitemmaster.hpp_<%=im.getOID()%>.value;
                                         var mar = document.frmitemmaster.m9_<%=pt.getOID()%>.value;
                                         var cost = document.frmitemmaster.cost_<%=im.getOID()%>.value;
                                         var ppn_val=document.frmitemmaster.ppn_<%=im.getOID()%>.value;
                                         
                                         if(parseFloat(cost) > parseFloat(cog)){
                                             cog = cost;
                                             document.frmitemmaster.hpp_<%=im.getOID()%>.value =cog; 
                                         }
                                         if (parseFloat(ppn_val)>0){
                                             ppn_val = cog/10
                                         }
                                         //cog = cleanNumberFloat(cog, sysDecSymbol, usrDigitGroup, usrDecSymbol);	
                                         //st=parseFloat(mar)/100 * parseFloat(cog) + parseFloat(cog) + parseFloat(ppn_val);
                                         st=((100/(100-parseFloat(mar)))* (parseFloat(cog)+parseFloat(ppn_val)));
                                         
                                         
                                         document.frmitemmaster.gol9_<%=pt.getOID()%>.value =st; 
                                     } }   
                         <%}
        }
    }%>
    
    <%}%>
    
}            

function checkGol10(oid,oidpt){
    <%if (listItemMaster.size() > 0) {%> 
    <%for (int i = 0; i < listItemMaster.size(); i++) {%>
    <%ItemMaster im = (ItemMaster) listItemMaster.get(i);%>  
    if(oid==<%=im.getOID()%>){
                         <%
    //ambil prce type semua
    Vector pts = DbPriceType.list(0, 0, "item_master_id=" + im.getOID(), "");

    if (pts != null && pts.size() > 0) {

        for (int ix = 0; ix < pts.size(); ix++) {

            PriceType pt = (PriceType) pts.get(ix);
                                 %>
                                     if(oidpt ==<%=pt.getOID()%>){
                                         
                                         var st = document.frmitemmaster.gol10_<%=pt.getOID()%>.value;	
                                         var cog = document.frmitemmaster.hpp_<%=im.getOID()%>.value;
                                         var mar = document.frmitemmaster.m10_<%=pt.getOID()%>.value;
                                         var cost = document.frmitemmaster.cost_<%=im.getOID()%>.value;
                                         var ppn_val=document.frmitemmaster.ppn_<%=im.getOID()%>.value;
                                         
                                         
                                         if(parseFloat(cost) > parseFloat(cog)){
                                             cog = cost;
                                             document.frmitemmaster.hpp_<%=im.getOID()%>.value =cog; 
                                         }
                                         if (parseFloat(ppn_val)>0){
                                             ppn_val = cog/10
                                         }
                                         //var ppn_val=0;
                                         //cog = cleanNumberFloat(cog, sysDecSymbol, usrDigitGroup, usrDecSymbol);	                              
                                         //mar=((parseFloat(st)-parseFloat(cog)-parseFloat(ppn_val)) / parseFloat(cog)) * 100;
                                         mar=((((parseFloat(st)/(parseFloat(cog)+parseFloat(ppn_val)))*100)-100)/((parseFloat(st)/(parseFloat(cog)+parseFloat(ppn_val)))*100)) * 100;
                                         if(mar > 0){
                                             
                                         }else{
                                         var mar =0;
                                     }
                                     
                                     document.frmitemmaster.m10_<%=pt.getOID()%>.value =mar; 
                                 } }   
                 <%}
        }
    }%>
    
    <%}%>
    
}

function checkMargin10(oid, oidpt){    
    
    <%if (listItemMaster.size() > 0) {%>
    <%for (int i = 0; i < listItemMaster.size(); i++) {%>
                                 <%
    ItemMaster im = (ItemMaster) listItemMaster.get(i);%>
        if(oid==<%=im.getOID()%>){
                                 <%
    //ambil prce type semua
    Vector pts = DbPriceType.list(0, 0, "item_master_id=" + im.getOID(), "");

    if (pts != null && pts.size() > 0) {

        for (int ix = 0; ix < pts.size(); ix++) {

            PriceType pt = (PriceType) pts.get(ix);

                                 %>
                                     if(oidpt ==<%=pt.getOID()%>){
                                         
                                         var st = document.frmitemmaster.gol10_<%=pt.getOID()%>.value;	
                                         var cog = document.frmitemmaster.hpp_<%=im.getOID()%>.value;
                                         var mar = document.frmitemmaster.m10_<%=pt.getOID()%>.value;
                                         var cost = document.frmitemmaster.cost_<%=im.getOID()%>.value;
                                         var ppn_val=document.frmitemmaster.ppn_<%=im.getOID()%>.value;
                                         
                                         if(parseFloat(cost) > parseFloat(cog)){
                                             cog = cost;
                                             document.frmitemmaster.hpp_<%=im.getOID()%>.value =cog; 
                                         }
                                         if (parseFloat(ppn_val)>0){
                                             ppn_val = cog/10
                                         }
                                         //cog = cleanNumberFloat(cog, sysDecSymbol, usrDigitGroup, usrDecSymbol);	
                                         //st=parseFloat(mar)/100 * parseFloat(cog) + parseFloat(cog) + parseFloat(ppn_val);
                                         st=((100/(100-parseFloat(mar)))* (parseFloat(cog)+parseFloat(ppn_val)));
                                         
                                         
                                         document.frmitemmaster.gol10_<%=pt.getOID()%>.value =st; 
                                     } }   
                         <%}
        }
    }%>
    
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
                                                            <input type="hidden" name="cmd_type" value="<%=cmdType%>">						  
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
                                                                                                        </span>&raquo; <span class="lvl2">Price 
                                                                                            Change List</span></font></b></td>
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
                                                                                                                    <td width="7%">&nbsp;</td><td width="10%">&nbsp;</td><td width="4%">&nbsp;</td><td width="15%">&nbsp;</td><td width="6%">&nbsp;</td><td width="10%">&nbsp;</td><td width="48%">&nbsp;</td>
                                                                                                                </tr>
                                                                                                                <tr> 
                                                                                                                    <td colspan="7" nowrap><b><u>Search 
                                                                                                                    Option</u></b></td>
                                                                                                                </tr>
                                                                                                                <tr> 
                                                                                                                    <td width="7%">&nbsp;</td><td width="10%">&nbsp;</td><td width="4%">&nbsp;</td><td width="15%">&nbsp;</td><td width="6%">&nbsp;</td><td width="10%">&nbsp;</td><td width="48%">&nbsp;</td>
                                                                                                                </tr>
                                                                                                                <tr> 
                                                                                                                    <td width="7%" height="22">Group</td>
                                                                                                                    <td width="10%" height="22"> 
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
                                                                                                                    <td width="4%" height="22">&nbsp;SKU</td>
                                                                                                                    <td width="15%" height="22"> 
                                                                                                                        <input type="text" name="src_code" size="15" value="<%=srcCode%>">
                                                                                                                    </td>
                                                                                                                    <td width="6%" height="22">Barcode</td>
                                                                                                                    <td width="10%" height="22"> 
                                                                                                                        <input type="text" name="src_barcode" size="15" value="<%=srcBarCode%>">
                                                                                                                    </td>
                                                                                                                    <td width="48%" height="22">&nbsp;</td>
                                                                                                                </tr>
                                                                                                                <tr> 
                                                                                                                    <td width="7%" height="22">Category</td>
                                                                                                                    <td width="10%" height="22"> 
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
                                                                                                                    <td width="4%" height="22">&nbsp;Name</td>
                                                                                                                    <td width="15%" height="22"> 
                                                                                                                        <input type="text" name="src_name" value="<%=srcName%>">
                                                                                                                    </td>
                                                                                                                    <td width="6%" height="22">Order 
                                                                                                                    By</td>
                                                                                                                    <td width="10%" height="22"> 
                                                                                                                        <select name="order_by">
                                                                                                                            <option value="0" <%if (orderBy == 0) {%>selected<%}%>>GROUP</option>
                                                                                                                            <option value="1" <%if (orderBy == 1) {%>selected<%}%>>CATEGORY</option>
                                                                                                                            <option value="2" <%if (orderBy == 2) {%>selected<%}%>>CODE</option>
                                                                                                                            <option value="3" <%if (orderBy == 3) {%>selected<%}%>>NAME</option>
                                                                                                                            <option value="4" <%if (orderBy == 4) {%>selected<%}%>>MERK</option>
                                                                                                                        </select>
                                                                                                                    </td>
                                                                                                                    <td width="48%" height="22"> 
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                                <tr> 
                                                                                                                    <td width="7%" height="22">Vendor</td>
                                                                                                                    <td width="10%" nowrap height="22"> 
                                                                                                                        <select name="src_vendor_id" onChange="javascript:cmdChangeMe()">
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
                                                                                                                    <td width="4%" nowrap height="22">&nbsp;Status&nbsp;</td>
                                                                                                                    <td width="15%" height="22"> 
                                                                                                                        <select name="src_status">
                                                                                                                            <option value="-1" <%if (srcStatus == -1) {%>selected<%}%>>All</option>
                                                                                                                            <option value="0" <%if (srcStatus == 0) {%>selected<%}%>>-</option>
                                                                                                                            <option value="1" <%if (srcStatus == 0) {%>selected<%}%>>PROCEED</option>
                                                                                                                        </select>
                                                                                                                    </td>
                                                                                                                    <td width="6%" height="22" nowrap>Ref.Number</td>
                                                                                                                    <td colspan="2" height="22">
                                                                                                                        <input type="text" name="src_ref_number" value="<%=srcRefNumber%>" size="20">
                                                                                                                    </td>
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
                                                                                                                    <td width="6%" height="22"><a href="javascript:cmdSearch()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('search','','../images/search2.gif',1)"><img src="../images/search.gif" name="search"  border="0"></a></td>
                                                                                                                    <td width="10%" height="22">&nbsp;</td>
                                                                                                                    <td width="48%" height="22">&nbsp;</td>
                                                                                                                </tr>
                                                                                                                <tr> 
                                                                                                                    <td colspan="7">&nbsp;</td>
                                                                                                                </tr>
                                                                                                                <tr> 
                                                                                                                    <td colspan="7" background="../images/line1.gif"><img src="../images/line1.gif" width="47" height="3"></td>
                                                                                                                </tr>
                                                                                                                <tr><td width="7%">&nbsp;</td><td width="10%">&nbsp;</td><td width="4%">&nbsp;</td><td width="15%">&nbsp;</td><td width="6%">&nbsp;</td><td width="10%">&nbsp;</td><td width="48%">&nbsp;</td></tr>
                                                                                                                <tr> 
                                                                                                                    <td width="7%" height="70">Set 
                                                                                                                    Active Date</td>
                                                                                                                    <td width="10%" nowrap height="70"> 
                                                                                                                        <input type="text" name="active_date" value="<%=JSPFormater.formatDate((activeDate == null) ? new Date() : activeDate, "dd/MM/yyyy")%>" size="11" onBlur="javascript:cmdNewPrice()"/>
                                                                                                                        <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmitemmaster.active_date);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> 
                                                                                                                    &nbsp; </td>
                                                                                                                    <td colspan="4" height="70"> 
                                                                                                                        <table width="90%" border="0" cellspacing="1" cellpadding="1" height="63">
                                                                                                                            <tr> 
                                                                                                                                <td width="28%" bgcolor="<%=(cmdType == 0) ? "#00CCFF" : "#FFCC66"%>"> 
                                                                                                                                    <div align="center"><a href="javascript:cmdNewPrice()">SETUP 
                                                                                                                                    MANUAL</a></div>
                                                                                                                                </td>
                                                                                                                                <td width="3%"><b></b></td>
                                                                                                                                <td width="69%" bgcolor="<%=(cmdType == 1) ? "#00CCFF" : "#FFCC66"%>"> 
                                                                                                                                    <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                                                                                        <tr> 
                                                                                                                                            <td valign="top"> 
                                                                                                                                                <div align="center">REF 
                                                                                                                                                    NUMBER 
                                                                                                                                                    <input type="text" name="ref_number" value="<%=refNumber%>" size="20">
                                                                                                                                                <a href="javascript:cmdByCost()"></a></div>
                                                                                                                                            </td>
                                                                                                                                        </tr>
                                                                                                                                        <tr> 
                                                                                                                                            <td height="21" valign="bottom"> 
                                                                                                                                                <div align="center"><a href="javascript:cmdByCost()">SETUP 
                                                                                                                                                        BY COST 
                                                                                                                                                CHANGE</a></div>
                                                                                                                                            </td>
                                                                                                                                        </tr>
                                                                                                                                    </table>
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                        </table>
                                                                                                                    </td>
                                                                                                                    <td width="48%" height="70">&nbsp;</td>
                                                                                                                </tr>
                                                                                                                <tr><td width="7%">&nbsp;</td><td width="10%">&nbsp;</td><td width="4%">&nbsp;</td><td width="15%">&nbsp;</td><td width="6%">&nbsp;</td><td width="10%">&nbsp;</td><td width="48%">&nbsp;</td></tr>
                                                                                                                
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
                                                                                                                    <td class="tablehdr" rowspan="2"><font>No</font></td><td class="tablehdr" rowspan="2"><font>Barcode</font></td><td class="tablehdr" rowspan="2"><font>SKU</font></td><td class="tablehdr" rowspan="2"><font>Name</font></td>
                                                                                                                    <td class="tablehdr" rowspan="2"><font>Base<br>Price</font><br><font size="1">(COGS)</font></td><td class="tablehdr" rowspan="2"><font>Unit Cost</font></td>
                                                                                                                    <td class="tablehdr" rowspan="2"><font>Qty</font></td><td class="tablehdr" colspan="2"><font>Gol1</font></td><td class="tablehdr" colspan="2"><font>Gol2</font></td>
                                                                                                                    <td class="tablehdr" colspan="2"><font>Gol3</font></td><td class="tablehdr" colspan="2"><font>Gol4</font></td><td class="tablehdr" colspan="2"><font>Gol5</font></td>
                                                                                                                    <td class="tablehdr" colspan="2"><font>Gol6</font></td>
                                                                                                                    <td class="tablehdr" colspan="2"><font>Gol7</font></td>
                                                                                                                    <td class="tablehdr" colspan="2"><font>Gol8</font></td>
                                                                                                                    <td class="tablehdr" colspan="2"><font>Gol9</font></td>
                                                                                                                    <td class="tablehdr" colspan="2"><font>Gol10</font></td>
                                                                                                                    <td class="tablehdr" rowspan="2"><font>Ref 
                                                                                                                    Num </font></td>
                                                                                                                    <td class="tablehdr" rowspan="2"><font>Active 
                                                                                                                    Date </font></td>
                                                                                                                    <td class="tablehdr" rowspan="2"><font>Status</font></td>
                                                                                                                    <td class="tablehdr" rowspan="2"><font>User</font></td>
                                                                                                                </tr>
                                                                                                                <tr> 
                                                                                                                    <td class="tablehdr"><font>Rp.</font></td>
                                                                                                                    <td class="tablehdr"><font>M%</font></td>
                                                                                                                    <td class="tablehdr"><font>Rp.</font></td>
                                                                                                                    <td class="tablehdr"><font>M%</font></td>
                                                                                                                    <td class="tablehdr"><font>Rp.</font></td>
                                                                                                                    <td class="tablehdr"><font>M%</font></td>
                                                                                                                    <td class="tablehdr"><font>Rp.</font></td>
                                                                                                                    <td class="tablehdr"><font>M%</font></td>
                                                                                                                    <td class="tablehdr"><font>Rp.</font></td>
                                                                                                                    <td class="tablehdr"><font>M%</font></td>
                                                                                                                    <td class="tablehdr"><font>Rp.</font></td>
                                                                                                                    <td class="tablehdr"><font>M%</font></td>
                                                                                                                    <td class="tablehdr"><font>Rp.</font></td>
                                                                                                                    <td class="tablehdr"><font>M%</font></td>
                                                                                                                    <td class="tablehdr"><font>Rp.</font></td>
                                                                                                                    <td class="tablehdr"><font>M%</font></td>
                                                                                                                    <td class="tablehdr"><font>Rp.</font></td>
                                                                                                                    <td class="tablehdr"><font>M%</font></td>
                                                                                                                    <td class="tablehdr"><font>Rp.</font></td>
                                                                                                                    <td class="tablehdr"><font>M%</font></td>
                                                                                                                </tr> 
                                                                                                                <%for (int i = 0; i < listItemMaster.size(); i++) {

                                                                                                                ItemMaster im = (ItemMaster) listItemMaster.get(i);

                                                                                                                Vector vvi = new Vector();
                                                                                                                if (srcVendorId == 0) {
                                                                                                                    vvi = DbVendorItem.list(0, 0, "item_master_id=" + im.getOID() + " and  vendor_id=" + im.getDefaultVendorId(), "");
                                                                                                                } else {
                                                                                                                    if (cmdType == 0) {
                                                                                                                        vvi = DbVendorItem.list(0, 0, "item_master_id=" + im.getOID() + " and vendor_id=" + srcVendorId, "");
                                                                                                                    } else {
                                                                                                                        vvi = DbVendorItemChange.list(0, 0, "item_master_id=" + im.getOID() + " and vendor_id=" + srcVendorId + " and ref_number='" + refNumber + "'", "");
                                                                                                                    }
                                                                                                                }

                                                                                                                VendorItem vi = new VendorItem();
                                                                                                                VendorItemChange vic = new VendorItemChange();
                                                                                                                if (vvi.size() > 0) {
                                                                                                                    try {
                                                                                                                        if (cmdType == 0) {
                                                                                                                            vi = (VendorItem) vvi.get(0);
                                                                                                                        } else {
                                                                                                                            vic = (VendorItemChange) vvi.get(0);
                                                                                                                        }
                                                                                                                    } catch (Exception ex) {

                                                                                                                    }
                                                                                                                }

                                                                                                                //ambil prce type semua
                                                                                                                Vector pts = DbPriceType.list(0, 0, "item_master_id=" + im.getOID(), "");

                                                                                                                if (pts != null && pts.size() > 0) {
                                                                                                                    for (int ix = 0; ix < pts.size(); ix++) {

                                                                                                                        PriceType pt = (PriceType) pts.get(ix);

                                                                                                                        PriceTypeChange ptc = new PriceTypeChange();
                                                                                                                        try {
                                                                                                                            String where = "price_type_id=" + pt.getOID();
                                                                                                                            if (iJSPCommand == JSPCommand.SEARCH) {
                                                                                                                                where = where + " and (to_days(active_date) between to_days('" + JSPFormater.formatDate(startDate, "yyyy-MM-dd") + "')" +
                                                                                                                                        " and to_days('" + JSPFormater.formatDate(endDate, "yyyy-MM-dd") + "'))";
                                                                                                                            } else if (ignoreDate == 0) {
                                                                                                                                where = where + " and to_days(active_date)=to_days('" + JSPFormater.formatDate(activeDate, "yyyy-MM-dd") + "')";
                                                                                                                            }

                                                                                                                            if (cmdType == 1) {
                                                                                                                                where = "ref_number='" + refNumber + "' and  " + where;
                                                                                                                            }

                                                                                                                            //out.println(where);

                                                                                                                            Vector tempx = DbPriceTypeChange.list(0, 1, where, "active_date desc");
                                                                                                                            if (tempx != null && tempx.size() > 0) {
                                                                                                                                ptc = (PriceTypeChange) tempx.get(0);
                                                                                                                            }

                                                                                                                        } catch (Exception ex) {

                                                                                                                        }

                                                                                                                        if (i % 2 == 0) {%>
                                                                                                                <tr> 
                                                                                                                    <td class="tablecell"><font><%=start + i + 1%></font></td>
                                                                                                                    <td class="tablecell"><font><%=im.getBarcode()%></font></td>
                                                                                                                    <td class="tablecell"><font><%=im.getCode()%></font></td>
                                                                                                                    <td class="tablecell" nowrap><font><%=im.getName()%></font></td>
                                                                                                                    <td class="tablecell"> 
                                                                                                                        <div align="right"><font>
                                                                                                                                <input type="hidden" name="hpp_<%=im.getOID()%>" value="<%=im.getCogs()%>">
                                                                                                                                <%if (im.getIs_bkp() == 1) {%>
                                                                                                                                <%=JSPFormater.formatNumber(im.getCogs() + ((im.getCogs() * 10) / 100), "#,###.#")%>
                                                                                                                                <input type="hidden" name="ppn_<%=im.getOID()%>" value="<%=im.getCogs() / 10%>">
                                                                                                                                <%} else {%>
                                                                                                                                <%=JSPFormater.formatNumber(im.getCogs(), "#,###.#")%>
                                                                                                                                <input type="hidden" name="ppn_<%=im.getOID()%>" value="0">
                                                                                                                                <%}%>
                                                                                                                        </font></div>
                                                                                                                    </td>
                                                                                                                    <td class="tablecell"> 
                                                                                                                        <div align="right"><font><%=JSPFormater.formatNumber((cmdType == 0) ? vi.getLastPrice() : vic.getLastPrice(), "#,###.#")%>
                                                                                                                                <input type="hidden" name="cost_<%=im.getOID()%>" value="<%=(cmdType == 0) ? vi.getLastPrice() : vic.getLastPrice()%>">
                                                                                                                        </font></div>
                                                                                                                    </td>
                                                                                                                    <td class="tablecell"><font><%=pt.getQtyFrom() + "-" + pt.getQtyTo()%> 
                                                                                                                            <input type="hidden" name="ptqtyfrom_<%=pt.getOID()%>" value="<%=pt.getQtyFrom()%>">
                                                                                                                            <input type="hidden" name="ptqtyto_<%=pt.getOID()%>" value="<%=pt.getQtyTo()%>">
                                                                                                                    </font></td>
                                                                                                                    <td class="tablecell"> 
                                                                                                                        <div align="right"><font> 
                                                                                                                                <input type="hidden" name="gol1ori_<%=pt.getOID()%>" size="5" value="<%=((ptc.getOID() == 0 || ptc.getStatus() == 1)) ? pt.getGol1() : ptc.getGol1ori()%>">
                                                                                                                        <%=(ptc.getOID() == 0 || ptc.getStatus() == 1) ? pt.getGol1() : ptc.getGol1ori()%> </font></div>
                                                                                                                    </td>
                                                                                                                    <td class="tablecell"> 
                                                                                                                        <div align="right"><font><%=JSPFormater.formatNumber(pt.getGol1_margin(), "###.#")%></font></div>
                                                                                                                    </td>
                                                                                                                    <td class="tablecell"> 
                                                                                                                        <div align="right"><font> 
                                                                                                                                <input type="hidden" name="gol2ori_<%=pt.getOID()%>" size="5" value="<%=(ptc.getOID() == 0 || ptc.getStatus() == 1) ? pt.getGol2() : ptc.getGol2ori()%>">
                                                                                                                        <%=(ptc.getOID() == 0 || ptc.getStatus() == 1) ? pt.getGol2() : ptc.getGol2ori()%> </font></div>
                                                                                                                    </td>
                                                                                                                    <td class="tablecell"> 
                                                                                                                        <div align="right"><font><%=JSPFormater.formatNumber(pt.getGol2_margin(), "###.#")%></font></div>
                                                                                                                    </td>
                                                                                                                    <td class="tablecell"> 
                                                                                                                        <div align="right"><font> 
                                                                                                                                <input type="hidden" name="gol3ori_<%=pt.getOID()%>" size="5" value="<%=(ptc.getOID() == 0 || ptc.getStatus() == 1) ? pt.getGol3() : ptc.getGol3ori()%>">
                                                                                                                        <%=(ptc.getOID() == 0 || ptc.getStatus() == 1) ? pt.getGol3() : ptc.getGol3ori()%> </font></div>
                                                                                                                    </td>
                                                                                                                    <td class="tablecell"> 
                                                                                                                        <div align="right"><font><%=JSPFormater.formatNumber(pt.getGol3_margin(), "###.#")%></font></div>
                                                                                                                    </td>
                                                                                                                    <td class="tablecell"> 
                                                                                                                        <div align="right"><font> 
                                                                                                                                <input type="hidden" name="gol4ori_<%=pt.getOID()%>" size="5" value="<%=(ptc.getOID() == 0 || ptc.getStatus() == 1) ? pt.getGol4() : ptc.getGol4ori()%>">
                                                                                                                        <%=(ptc.getOID() == 0 || ptc.getStatus() == 1) ? pt.getGol4() : ptc.getGol4ori()%> </font></div>
                                                                                                                    </td>
                                                                                                                    <td class="tablecell"> 
                                                                                                                        <div align="right"><font><%=JSPFormater.formatNumber(pt.getGol4_margin(), "###.#")%></font></div>
                                                                                                                    </td>
                                                                                                                    <td class="tablecell"> 
                                                                                                                        <div align="right"><font> 
                                                                                                                                <input type="hidden" name="gol5ori_<%=pt.getOID()%>" size="5" value="<%=(ptc.getOID() == 0 || ptc.getStatus() == 1) ? pt.getGol5() : ptc.getGol5ori()%>">
                                                                                                                        <%=(ptc.getOID() == 0 || ptc.getStatus() == 1) ? pt.getGol5() : ptc.getGol5ori()%> </font></div>
                                                                                                                    </td>
                                                                                                                    <td class="tablecell"> 
                                                                                                                        <div align="right"><font><%=JSPFormater.formatNumber(pt.getGol5_margin(), "###.#")%></font></div>
                                                                                                                    </td>
                                                                                                                    <td class="tablecell"> 
                                                                                                                        <div align="right"><font> 
                                                                                                                                <input type="hidden" name="gol6ori_<%=pt.getOID()%>" size="5" value="<%=(ptc.getOID() == 0 || ptc.getStatus() == 1) ? pt.getGol6() : ptc.getGol6ori()%>">
                                                                                                                        <%=(ptc.getOID() == 0 || ptc.getStatus() == 1) ? pt.getGol6() : ptc.getGol6ori()%> </font></div>
                                                                                                                    </td>
                                                                                                                    <td class="tablecell"> 
                                                                                                                        <div align="right"><font><%=JSPFormater.formatNumber(pt.getGol6_margin(), "###.#")%></font></div>
                                                                                                                    </td>
                                                                                                                    <td class="tablecell"> 
                                                                                                                        <div align="right"><font> 
                                                                                                                                <input type="hidden" name="gol7ori_<%=pt.getOID()%>" size="5" value="<%=(ptc.getOID() == 0 || ptc.getStatus() == 1) ? pt.getGol7() : ptc.getGol7ori()%>">
                                                                                                                        <%=(ptc.getOID() == 0 || ptc.getStatus() == 1) ? pt.getGol7() : ptc.getGol7ori()%> </font></div>
                                                                                                                    </td>
                                                                                                                    <td class="tablecell"> 
                                                                                                                        <div align="right"><font><%=JSPFormater.formatNumber(pt.getGol7_margin(), "###.#")%></font></div>
                                                                                                                    </td>
                                                                                                                    <td class="tablecell"> 
                                                                                                                        <div align="right"><font> 
                                                                                                                                <input type="hidden" name="gol8ori_<%=pt.getOID()%>" size="5" value="<%=(ptc.getOID() == 0 || ptc.getStatus() == 1) ? pt.getGol8() : ptc.getGol8ori()%>">
                                                                                                                        <%=(ptc.getOID() == 0 || ptc.getStatus() == 1) ? pt.getGol8() : ptc.getGol8ori()%> </font></div>
                                                                                                                    </td>
                                                                                                                    <td class="tablecell"> 
                                                                                                                        <div align="right"><font><%=JSPFormater.formatNumber(pt.getGol8_margin(), "###.#")%></font></div>
                                                                                                                    </td>
                                                                                                                    <td class="tablecell"> 
                                                                                                                        <div align="right"><font> 
                                                                                                                                <input type="hidden" name="gol9ori_<%=pt.getOID()%>" size="5" value="<%=(ptc.getOID() == 0 || ptc.getStatus() == 1) ? pt.getGol9() : ptc.getGol9ori()%>">
                                                                                                                        <%=(ptc.getOID() == 0 || ptc.getStatus() == 1) ? pt.getGol9() : ptc.getGol9ori()%> </font></div>
                                                                                                                    </td>
                                                                                                                    <td class="tablecell"> 
                                                                                                                        <div align="right"><font><%=JSPFormater.formatNumber(pt.getGol9_margin(), "###.#")%></font></div>
                                                                                                                    </td>
                                                                                                                    <td class="tablecell"> 
                                                                                                                        <div align="right"><font> 
                                                                                                                                <input type="hidden" name="gol10ori_<%=pt.getOID()%>" size="5" value="<%=(ptc.getOID() == 0 || ptc.getStatus() == 1) ? pt.getGol10() : ptc.getGol10ori()%>">
                                                                                                                        <%=(ptc.getOID() == 0 || ptc.getStatus() == 1) ? pt.getGol10() : ptc.getGol10ori()%> </font></div>
                                                                                                                    </td>
                                                                                                                    <td class="tablecell"> 
                                                                                                                        <div align="right"><font><%=JSPFormater.formatNumber(pt.getGol10_margin(), "###.#")%></font></div>
                                                                                                                    </td>
                                                                                                                    <td class="tablecell"><font></font></td>
                                                                                                                    <td class="tablecell"> 
                                                                                                                        <div align="center"><font></font></div>
                                                                                                                    </td>
                                                                                                                    <td class="tablecell"> 
                                                                                                                        <div align="center"><font></font></div>
                                                                                                                    </td>
                                                                                                                    <td class="tablecell"><font></font></td>
                                                                                                                </tr>
                                                                                                                <tr> 
                                                                                                                    <td class="tablecell"><font></font></td>
                                                                                                                    <td class="tablecell"><font></font></td>
                                                                                                                    <td class="tablecell"><font></font></td>
                                                                                                                    <td class="tablecell" nowrap><font></font></td>
                                                                                                                    <td class="tablecell">&nbsp;</td>
                                                                                                                    <td class="tablecell">&nbsp;</td>
                                                                                                                    <td class="tablecell"><font></font></td>
                                                                                                                    <td class="tablecell"> 
                                                                                                                        <div align="right"><font> 
                                                                                                                                <input type="text" name="gol1_<%=pt.getOID()%>" size="5" value="<%=(ptc.getOID() == 0) ? pt.getGol1() : ptc.getGol1()%>" onClick="this.select()" onChange="javascript:checkGol1('<%=im.getOID()%>','<%=pt.getOID()%>')" style="text-align: right"/>
                                                                                                                        </font></div>  
                                                                                                                    </td>
                                                                                                                    <td class="tablecell"> 
                                                                                                                        <div align="right"><font> 
                                                                                                                                <input type="text" name="m1_<%=pt.getOID()%>" size="3" value="<%=JSPFormater.formatNumber((ptc.getOID() == 0) ? pt.getGol1_margin() : ptc.getGol1_margin(), "###.#")%>" onClick="this.select()" onChange="javascript:checkMargin1('<%=im.getOID()%>','<%=pt.getOID()%>')" style="text-align: right"/>
                                                                                                                        </font></div>
                                                                                                                    </td>
                                                                                                                    <td class="tablecell"> 
                                                                                                                        <div align="right"><font> 
                                                                                                                                <input type="text" name="gol2_<%=pt.getOID()%>" size="5" value="<%=(ptc.getOID() == 0) ? pt.getGol2() : ptc.getGol2()%>" onClick="this.select()" onChange="javascript:checkGol2('<%=im.getOID()%>','<%=pt.getOID()%>')" style="text-align: right"/>
                                                                                                                        </font></div>
                                                                                                                    </td>
                                                                                                                    <td class="tablecell"> 
                                                                                                                        <div align="right"><font> 
                                                                                                                                <input type="text" name="m2_<%=pt.getOID()%>" size="3" value="<%=JSPFormater.formatNumber((ptc.getOID() == 0) ? pt.getGol2_margin() : ptc.getGol2_margin(), "###.#")%>" onClick="this.select()" onChange="javascript:checkMargin2('<%=im.getOID()%>','<%=pt.getOID()%>')" style="text-align: right"/>
                                                                                                                        </font></div>
                                                                                                                    </td>
                                                                                                                    <td class="tablecell"> 
                                                                                                                        <div align="right"><font> 
                                                                                                                                <input type="text" name="gol3_<%=pt.getOID()%>" size="5" value="<%=(ptc.getOID() == 0) ? pt.getGol3() : ptc.getGol3()%>" onClick="this.select()" onChange="javascript:checkGol3('<%=im.getOID()%>','<%=pt.getOID()%>')" style="text-align: right"/>
                                                                                                                        </font></div>
                                                                                                                    </td>
                                                                                                                    <td class="tablecell"> 
                                                                                                                        <div align="right"><font> 
                                                                                                                                <input type="text" name="m3_<%=pt.getOID()%>" size="3" value="<%=JSPFormater.formatNumber((ptc.getOID() == 0) ? pt.getGol3_margin() : ptc.getGol3_margin(), "###.#")%>" onClick="this.select()" onChange="javascript:checkMargin3('<%=im.getOID()%>','<%=pt.getOID()%>')" style="text-align: right"/>
                                                                                                                        </font></div>
                                                                                                                    </td>
                                                                                                                    <td class="tablecell"> 
                                                                                                                        <div align="right"><font> 
                                                                                                                                <input type="text" name="gol4_<%=pt.getOID()%>" size="5" value="<%=(ptc.getOID() == 0) ? pt.getGol4() : ptc.getGol4()%>" onClick="this.select()" onChange="javascript:checkGol4('<%=im.getOID()%>','<%=pt.getOID()%>')" style="text-align: right"/>
                                                                                                                        </font></div>
                                                                                                                    </td>
                                                                                                                    <td class="tablecell"> 
                                                                                                                        <div align="right"><font> 
                                                                                                                                <input type="text" name="m4_<%=pt.getOID()%>" size="3" value="<%=JSPFormater.formatNumber((ptc.getOID() == 0) ? pt.getGol4_margin() : ptc.getGol4_margin(), "###.#")%>" onClick="this.select()" onChange="javascript:checkMargin4('<%=im.getOID()%>','<%=pt.getOID()%>')" style="text-align: right"/>
                                                                                                                        </font></div>
                                                                                                                    </td>
                                                                                                                    <td class="tablecell"> 
                                                                                                                        <div align="right"><font> 
                                                                                                                                <input type="text" name="gol5_<%=pt.getOID()%>" size="5" value="<%=(ptc.getOID() == 0) ? pt.getGol5() : ptc.getGol5()%>" onClick="this.select()" onChange="javascript:checkGol5('<%=im.getOID()%>','<%=pt.getOID()%>')" style="text-align: right"/>
                                                                                                                        </font></div>
                                                                                                                    </td>
                                                                                                                    <td class="tablecell"> 
                                                                                                                        <div align="right"><font> 
                                                                                                                                <input type="text" name="m5_<%=pt.getOID()%>" size="3" value="<%=JSPFormater.formatNumber((ptc.getOID() == 0) ? pt.getGol5_margin() : ptc.getGol5_margin(), "###.#")%>" onClick="this.select()" onChange="javascript:checkMargin5('<%=im.getOID()%>','<%=pt.getOID()%>')" style="text-align: right"/>
                                                                                                                        </font></div>
                                                                                                                    </td>
                                                                                                                    <td class="tablecell"> 
                                                                                                                        <div align="right"><font> 
                                                                                                                                <input type="text" name="gol6_<%=pt.getOID()%>" size="5" value="<%=(ptc.getOID() == 0) ? pt.getGol6() : ptc.getGol6()%>" onClick="this.select()" onChange="javascript:checkGol6('<%=im.getOID()%>','<%=pt.getOID()%>')" style="text-align: right"/>
                                                                                                                        </font></div>
                                                                                                                    </td>
                                                                                                                    <td class="tablecell"> 
                                                                                                                        <div align="right"><font> 
                                                                                                                                <input type="text" name="m6_<%=pt.getOID()%>" size="3" value="<%=JSPFormater.formatNumber((ptc.getOID() == 0) ? pt.getGol6_margin() : ptc.getGol6_margin(), "###.#")%>" onClick="this.select()" onChange="javascript:checkMargin6('<%=im.getOID()%>','<%=pt.getOID()%>')" style="text-align: right"/>
                                                                                                                        </font></div>
                                                                                                                    </td>
                                                                                                                    <td class="tablecell"> 
                                                                                                                        <div align="right"><font> 
                                                                                                                                <input type="text" name="gol7_<%=pt.getOID()%>" size="5" value="<%=(ptc.getOID() == 0) ? pt.getGol7() : ptc.getGol7()%>" onClick="this.select()" onChange="javascript:checkGol7('<%=im.getOID()%>','<%=pt.getOID()%>')" style="text-align: right"/>
                                                                                                                        </font></div>
                                                                                                                    </td>
                                                                                                                    <td class="tablecell"> 
                                                                                                                        <div align="right"><font> 
                                                                                                                                <input type="text" name="m7_<%=pt.getOID()%>" size="3" value="<%=JSPFormater.formatNumber((ptc.getOID() == 0) ? pt.getGol7_margin() : ptc.getGol7_margin(), "###.#")%>" onClick="this.select()" onChange="javascript:checkMargin7('<%=im.getOID()%>','<%=pt.getOID()%>')" style="text-align: right"/>
                                                                                                                        </font></div>
                                                                                                                    </td>
                                                                                                                    <td class="tablecell"> 
                                                                                                                        <div align="right"><font> 
                                                                                                                                <input type="text" name="gol8_<%=pt.getOID()%>" size="5" value="<%=(ptc.getOID() == 0) ? pt.getGol8() : ptc.getGol8()%>" onClick="this.select()" onChange="javascript:checkGol8('<%=im.getOID()%>','<%=pt.getOID()%>')" style="text-align: right"/>
                                                                                                                        </font></div>
                                                                                                                    </td>
                                                                                                                    <td class="tablecell"> 
                                                                                                                        <div align="right"><font> 
                                                                                                                                <input type="text" name="m8_<%=pt.getOID()%>" size="3" value="<%=JSPFormater.formatNumber((ptc.getOID() == 0) ? pt.getGol8_margin() : ptc.getGol8_margin(), "###.#")%>" onClick="this.select()" onChange="javascript:checkMargin8('<%=im.getOID()%>','<%=pt.getOID()%>')" style="text-align: right"/>
                                                                                                                        </font></div>
                                                                                                                    </td>
                                                                                                                    <td class="tablecell"> 
                                                                                                                        <div align="right"><font> 
                                                                                                                                <input type="text" name="gol9_<%=pt.getOID()%>" size="5" value="<%=(ptc.getOID() == 0) ? pt.getGol9() : ptc.getGol9()%>" onClick="this.select()" onChange="javascript:checkGol9('<%=im.getOID()%>','<%=pt.getOID()%>')" style="text-align: right"/>
                                                                                                                        </font></div>
                                                                                                                    </td>
                                                                                                                    <td class="tablecell"> 
                                                                                                                        <div align="right"><font> 
                                                                                                                                <input type="text" name="m9_<%=pt.getOID()%>" size="3" value="<%=JSPFormater.formatNumber((ptc.getOID() == 0) ? pt.getGol9_margin() : ptc.getGol9_margin(), "###.#")%>" onClick="this.select()" onChange="javascript:checkMargin9('<%=im.getOID()%>','<%=pt.getOID()%>')" style="text-align: right"/>
                                                                                                                        </font></div>
                                                                                                                    </td>
                                                                                                                    <td class="tablecell"> 
                                                                                                                        <div align="right"><font> 
                                                                                                                                <input type="text" name="gol10_<%=pt.getOID()%>" size="5" value="<%=(ptc.getOID() == 0) ? pt.getGol10() : ptc.getGol10()%>" onClick="this.select()" onChange="javascript:checkGol10('<%=im.getOID()%>','<%=pt.getOID()%>')" style="text-align: right"/>
                                                                                                                        </font></div>
                                                                                                                    </td>
                                                                                                                    <td class="tablecell"> 
                                                                                                                        <div align="right"><font> 
                                                                                                                                <input type="text" name="m10_<%=pt.getOID()%>" size="3" value="<%=JSPFormater.formatNumber((ptc.getOID() == 0) ? pt.getGol10_margin() : ptc.getGol10_margin(), "###.#")%>" onClick="this.select()" onChange="javascript:checkMargin10('<%=im.getOID()%>','<%=pt.getOID()%>')" style="text-align: right"/>
                                                                                                                        </font></div>
                                                                                                                    </td>
                                                                                                                    <td class="tablecell" nowrap> 
                                                                                                                        <div align="center"><font><%=(ptc.getOID() == 0) ? "" : ptc.getRefNumber()%></font></div>
                                                                                                                    </td>
                                                                                                                    <td class="tablecell" nowrap> 
                                                                                                                        <div align="center"><font><%=(ptc.getOID() == 0) ? "" : JSPFormater.formatDate(ptc.getActiveDate(), "dd-MM-yyyy")%></font></div>
                                                                                                                    </td>
                                                                                                                    <td class="tablecell"> 
                                                                                                                        <div align="center"><font><%=(ptc.getOID() == 0) ? "" : ((ptc.getStatus() == 0) ? "-" : "PROCEED")%></font></div>
                                                                                                                    </td>
                                                                                                                    <td class="tablecell"><font> 
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
                                                                                                                    </font></td>
                                                                                                                </tr>
                                                                                                                <%} else {%>
                                                                                                                <tr> 
                                                                                                                    <td class="tablecell1"><font><%=start + i + 1%></font></td>
                                                                                                                    <td class="tablecell1"><font><%=im.getBarcode()%></font></td>
                                                                                                                    <td class="tablecell1"><font><%=im.getCode()%></font></td>
                                                                                                                    <td class="tablecell1" nowrap><font><%=im.getName()%></font></td>
                                                                                                                    <td class="tablecell1"> 
                                                                                                                        <div align="right"><font> 
                                                                                                                                <input type="hidden" name="hpp_<%=im.getOID()%>" value="<%=im.getCogs()%>">
                                                                                                                                <%if (im.getIs_bkp() == 1) {%>
                                                                                                                                <%=JSPFormater.formatNumber(im.getCogs() + ((im.getCogs() * 10) / 100), "#,###.#")%>
                                                                                                                                <input type="hidden" name="ppn_<%=im.getOID()%>" value="<%=im.getCogs() / 10%>">
                                                                                                                                <%} else {%>
                                                                                                                                <%=JSPFormater.formatNumber(im.getCogs(), "#,###.#")%>	
                                                                                                                                <input type="hidden" name="ppn_<%=im.getOID()%>" value="0">
                                                                                                                                <%}%>
                                                                                                                        </font></div>
                                                                                                                    </td>
                                                                                                                    <td class="tablecell1"> 
                                                                                                                        <div align="right"><font><%=JSPFormater.formatNumber((cmdType == 0) ? vi.getLastPrice() : vic.getLastPrice(), "#,###.#")%>
                                                                                                                                <input type="hidden" name="cost_<%=im.getOID()%>" value="<%=(cmdType == 0) ? vi.getLastPrice() : vic.getLastPrice()%>">
                                                                                                                        </font></div>
                                                                                                                    </td>
                                                                                                                    <td class="tablecell1"><font><%=pt.getQtyFrom() + "-" + pt.getQtyTo()%> 
                                                                                                                            <input type="hidden" name="ptqtyfrom_<%=pt.getOID()%>" value="<%=pt.getQtyFrom()%>">
                                                                                                                            <input type="hidden" name="ptqtyto_<%=pt.getOID()%>" value="<%=pt.getQtyTo()%>">
                                                                                                                    </font></td>
                                                                                                                    <td class="tablecell1"> 
                                                                                                                        <div align="right"><font> 
                                                                                                                                <input type="hidden" name="gol1ori_<%=pt.getOID()%>" size="5" value="<%=(ptc.getOID() == 0 || ptc.getStatus() == 1) ? pt.getGol1() : ptc.getGol1ori()%>">
                                                                                                                        <%=(ptc.getOID() == 0 || ptc.getStatus() == 1) ? pt.getGol1() : ptc.getGol1ori()%> </font></div>
                                                                                                                    </td>
                                                                                                                    <td class="tablecell1"> 
                                                                                                                        <div align="right"><font><%=JSPFormater.formatNumber(pt.getGol1_margin(), "###.#")%></font></div>
                                                                                                                    </td>
                                                                                                                    <td class="tablecell1"> 
                                                                                                                        <div align="right"><font> 
                                                                                                                                <input type="hidden" name="gol2ori_<%=pt.getOID()%>" size="5" value="<%=(ptc.getOID() == 0 || ptc.getStatus() == 1) ? pt.getGol2() : ptc.getGol2ori()%>">
                                                                                                                        <%=(ptc.getOID() == 0 || ptc.getStatus() == 1) ? pt.getGol2() : ptc.getGol2ori()%> </font></div>
                                                                                                                    </td>
                                                                                                                    <td class="tablecell1"> 
                                                                                                                        <div align="right"><font><%=JSPFormater.formatNumber(pt.getGol2_margin(), "###.#")%></font></div>
                                                                                                                    </td>
                                                                                                                    <td class="tablecell1"> 
                                                                                                                        <div align="right"><font> 
                                                                                                                                <input type="hidden" name="gol3ori_<%=pt.getOID()%>" size="5" value="<%=(ptc.getOID() == 0 || ptc.getStatus() == 1) ? pt.getGol3() : ptc.getGol3ori()%>">
                                                                                                                        <%=(ptc.getOID() == 0 || ptc.getStatus() == 1) ? pt.getGol3() : ptc.getGol3ori()%> </font></div>
                                                                                                                    </td>
                                                                                                                    <td class="tablecell1"> 
                                                                                                                        <div align="right"><font><%=JSPFormater.formatNumber(pt.getGol3_margin(), "###.#")%></font></div>
                                                                                                                    </td>
                                                                                                                    <td class="tablecell1"> 
                                                                                                                        <div align="right"><font> 
                                                                                                                                <input type="hidden" name="gol4ori_<%=pt.getOID()%>" size="5" value="<%=(ptc.getOID() == 0 || ptc.getStatus() == 1) ? pt.getGol4() : ptc.getGol4ori()%>">
                                                                                                                        <%=(ptc.getOID() == 0 || ptc.getStatus() == 1) ? pt.getGol4() : ptc.getGol4ori()%> </font></div>
                                                                                                                    </td>
                                                                                                                    <td class="tablecell1"> 
                                                                                                                        <div align="right"><font><%=JSPFormater.formatNumber(pt.getGol4_margin(), "###.#")%></font></div>
                                                                                                                    </td>
                                                                                                                    <td class="tablecell1"> 
                                                                                                                        <div align="right"><font> 
                                                                                                                                <input type="hidden" name="gol5ori_<%=pt.getOID()%>" size="5" value="<%=(ptc.getOID() == 0 || ptc.getStatus() == 1) ? pt.getGol5() : ptc.getGol5ori()%>">
                                                                                                                        <%=(ptc.getOID() == 0 || ptc.getStatus() == 1) ? pt.getGol5() : ptc.getGol5ori()%> </font></div>
                                                                                                                    </td>
                                                                                                                    <td class="tablecell1"> 
                                                                                                                        <div align="right"><font><%=JSPFormater.formatNumber(pt.getGol5_margin(), "###.#")%></font></div>
                                                                                                                    </td>
                                                                                                                    <td class="tablecell1"> 
                                                                                                                        <div align="right"><font> 
                                                                                                                                <input type="hidden" name="gol6ori_<%=pt.getOID()%>" size="5" value="<%=(ptc.getOID() == 0 || ptc.getStatus() == 1) ? pt.getGol6() : ptc.getGol6ori()%>">
                                                                                                                        <%=(ptc.getOID() == 0 || ptc.getStatus() == 1) ? pt.getGol6() : ptc.getGol6ori()%> </font></div>
                                                                                                                    </td>
                                                                                                                    <td class="tablecell1"> 
                                                                                                                        <div align="right"><font><%=JSPFormater.formatNumber(pt.getGol6_margin(), "###.#")%></font></div>
                                                                                                                    </td>
                                                                                                                    <td class="tablecell1"> 
                                                                                                                        <div align="right"><font> 
                                                                                                                                <input type="hidden" name="gol7ori_<%=pt.getOID()%>" size="5" value="<%=(ptc.getOID() == 0 || ptc.getStatus() == 1) ? pt.getGol7() : ptc.getGol7ori()%>">
                                                                                                                        <%=(ptc.getOID() == 0 || ptc.getStatus() == 1) ? pt.getGol7() : ptc.getGol7ori()%> </font></div>
                                                                                                                    </td>
                                                                                                                    <td class="tablecell1"> 
                                                                                                                        <div align="right"><font><%=JSPFormater.formatNumber(pt.getGol7_margin(), "###.#")%></font></div>
                                                                                                                    </td>
                                                                                                                    <td class="tablecell1"> 
                                                                                                                        <div align="right"><font> 
                                                                                                                                <input type="hidden" name="gol8ori_<%=pt.getOID()%>" size="5" value="<%=(ptc.getOID() == 0 || ptc.getStatus() == 1) ? pt.getGol8() : ptc.getGol8ori()%>">
                                                                                                                        <%=(ptc.getOID() == 0 || ptc.getStatus() == 1) ? pt.getGol8() : ptc.getGol8ori()%> </font></div>
                                                                                                                    </td>
                                                                                                                    <td class="tablecell1"> 
                                                                                                                        <div align="right"><font><%=JSPFormater.formatNumber(pt.getGol8_margin(), "###.#")%></font></div>
                                                                                                                    </td>
                                                                                                                    <td class="tablecell1"> 
                                                                                                                        <div align="right"><font> 
                                                                                                                                <input type="hidden" name="gol9ori_<%=pt.getOID()%>" size="5" value="<%=(ptc.getOID() == 0 || ptc.getStatus() == 1) ? pt.getGol9() : ptc.getGol9ori()%>">
                                                                                                                        <%=(ptc.getOID() == 0 || ptc.getStatus() == 1) ? pt.getGol9() : ptc.getGol9ori()%> </font></div>
                                                                                                                    </td>
                                                                                                                    <td class="tablecell1"> 
                                                                                                                        <div align="right"><font><%=JSPFormater.formatNumber(pt.getGol9_margin(), "###.#")%></font></div>
                                                                                                                    </td>
                                                                                                                    <td class="tablecell1"> 
                                                                                                                        <div align="right"><font> 
                                                                                                                                <input type="hidden" name="gol10ori_<%=pt.getOID()%>" size="5" value="<%=(ptc.getOID() == 0 || ptc.getStatus() == 1) ? pt.getGol10() : ptc.getGol10ori()%>">
                                                                                                                        <%=(ptc.getOID() == 0 || ptc.getStatus() == 1) ? pt.getGol10() : ptc.getGol10ori()%> </font></div>
                                                                                                                    </td>
                                                                                                                    <td class="tablecell1"> 
                                                                                                                        <div align="right"><font><%=JSPFormater.formatNumber(pt.getGol10_margin(), "###.#")%></font></div>
                                                                                                                    </td>
                                                                                                                    <td class="tablecell1"> 
                                                                                                                        <div align="center"><font></font></div>
                                                                                                                    </td>
                                                                                                                    <td class="tablecell1"> 
                                                                                                                        <div align="center"><font></font></div>
                                                                                                                    </td>
                                                                                                                    <td class="tablecell1"> 
                                                                                                                        <div align="center"><font></font></div>
                                                                                                                    </td>
                                                                                                                    <td class="tablecell1"><font></font></td>
                                                                                                                </tr>
                                                                                                                <tr> 
                                                                                                                    <td class="tablecell1"><font></font></td>
                                                                                                                    <td class="tablecell1"><font></font></td>
                                                                                                                    <td class="tablecell1"><font></font></td>
                                                                                                                    <td class="tablecell1" nowrap><font></font></td>
                                                                                                                    <td class="tablecell1">&nbsp;</td>
                                                                                                                    <td class="tablecell1">&nbsp;</td>
                                                                                                                    <td class="tablecell1"><font></font></td>
                                                                                                                    <td class="tablecell1"> 
                                                                                                                        <div align="right"><font> 
                                                                                                                                <input type="text" name="gol1_<%=pt.getOID()%>" size="5" value="<%=(ptc.getOID() == 0) ? pt.getGol1() : ptc.getGol1()%>" onClick="this.select()" onChange="javascript:checkGol1('<%=im.getOID()%>','<%=pt.getOID()%>')" style="text-align:right"/>
                                                                                                                        </font></div>
                                                                                                                    </td>
                                                                                                                    <td class="tablecell1"> 
                                                                                                                        <div align="right"><font> 
                                                                                                                                <input type="text" name="m1_<%=pt.getOID()%>" size="3" value="<%=JSPFormater.formatNumber((ptc.getOID() == 0) ? pt.getGol1_margin() : ptc.getGol1_margin(), "###.#")%>" onClick="this.select()" onChange="javascript:checkMargin1('<%=im.getOID()%>','<%=pt.getOID()%>')" style="text-align: right"/>
                                                                                                                        </font></div>
                                                                                                                    </td>
                                                                                                                    <td class="tablecell1"> 
                                                                                                                        <div align="right"><font> 
                                                                                                                                <input type="text" name="gol2_<%=pt.getOID()%>" size="5" value="<%=(ptc.getOID() == 0) ? pt.getGol2() : ptc.getGol2()%>" onClick="this.select()" onChange="javascript:checkGol2('<%=im.getOID()%>','<%=pt.getOID()%>')" style="text-align: right"/>
                                                                                                                        </font></div>
                                                                                                                    </td>
                                                                                                                    <td class="tablecell1"> 
                                                                                                                        <div align="right"><font> 
                                                                                                                                <input type="text" name="m2_<%=pt.getOID()%>" size="3" value="<%=JSPFormater.formatNumber((ptc.getOID() == 0) ? pt.getGol2_margin() : ptc.getGol2_margin(), "###.#")%>" onClick="this.select()" onChange="javascript:checkMargin2('<%=im.getOID()%>','<%=pt.getOID()%>')" style="text-align: right"/>
                                                                                                                        </font></div>
                                                                                                                    </td>
                                                                                                                    <td class="tablecell1"> 
                                                                                                                        <div align="right"><font> 
                                                                                                                                <input type="text" name="gol3_<%=pt.getOID()%>" size="5" value="<%=(ptc.getOID() == 0) ? pt.getGol3() : ptc.getGol3()%>" onClick="this.select()" onChange="javascript:checkGol3('<%=im.getOID()%>','<%=pt.getOID()%>')" style="text-align: right"/>
                                                                                                                        </font></div>
                                                                                                                    </td>
                                                                                                                    <td class="tablecell1"> 
                                                                                                                        <div align="right"><font> 
                                                                                                                                <input type="text" name="m3_<%=pt.getOID()%>" size="3" value="<%=JSPFormater.formatNumber((ptc.getOID() == 0) ? pt.getGol3_margin() : ptc.getGol3_margin(), "###.#")%>" onClick="this.select()" onChange="javascript:checkMargin3('<%=im.getOID()%>','<%=pt.getOID()%>')" style="text-align: right"/>
                                                                                                                        </font></div>
                                                                                                                    </td>
                                                                                                                    <td class="tablecell1"> 
                                                                                                                        <div align="right"><font> 
                                                                                                                                <input type="text" name="gol4_<%=pt.getOID()%>" size="5" value="<%=(ptc.getOID() == 0) ? pt.getGol4() : ptc.getGol4()%>" onClick="this.select()" onChange="javascript:checkGol4('<%=im.getOID()%>','<%=pt.getOID()%>')" style="text-align: right"/>
                                                                                                                        </font></div>
                                                                                                                    </td>
                                                                                                                    <td class="tablecell1"> 
                                                                                                                        <div align="right"><font> 
                                                                                                                                <input type="text" name="m4_<%=pt.getOID()%>" size="3" value="<%=JSPFormater.formatNumber((ptc.getOID() == 0) ? pt.getGol4_margin() : ptc.getGol4_margin(), "###.#")%>" onClick="this.select()" onChange="javascript:checkMargin4('<%=im.getOID()%>','<%=pt.getOID()%>')" style="text-align: right"/>
                                                                                                                        </font></div>
                                                                                                                    </td>
                                                                                                                    <td class="tablecell1"> 
                                                                                                                        <div align="right"><font> 
                                                                                                                                <input type="text" name="gol5_<%=pt.getOID()%>" size="5" value="<%=(ptc.getOID() == 0) ? pt.getGol5() : ptc.getGol5()%>" onClick="this.select()" onChange="javascript:checkGol5('<%=im.getOID()%>','<%=pt.getOID()%>')" style="text-align: right"/>
                                                                                                                        </font></div>
                                                                                                                    </td>
                                                                                                                    <td class="tablecell1"> 
                                                                                                                        <div align="right"><font> 
                                                                                                                                <input type="text" name="m5_<%=pt.getOID()%>" size="3" value="<%=JSPFormater.formatNumber((ptc.getOID() == 0) ? pt.getGol5_margin() : ptc.getGol5_margin(), "###.#")%>" onClick="this.select()" onChange="javascript:checkMargin5('<%=im.getOID()%>','<%=pt.getOID()%>')" style="text-align: right"/>
                                                                                                                        </font></div>
                                                                                                                    </td>
                                                                                                                    <td class="tablecell1"> 
                                                                                                                        <div align="right"><font> 
                                                                                                                                <input type="text" name="gol6_<%=pt.getOID()%>" size="5" value="<%=(ptc.getOID() == 0) ? pt.getGol6() : ptc.getGol6()%>" onClick="this.select()" onChange="javascript:checkGol6('<%=im.getOID()%>','<%=pt.getOID()%>')" style="text-align: right"/>
                                                                                                                        </font></div>
                                                                                                                    </td>
                                                                                                                    <td class="tablecell1"> 
                                                                                                                        <div align="right"><font> 
                                                                                                                                <input type="text" name="m6_<%=pt.getOID()%>" size="3" value="<%=JSPFormater.formatNumber((ptc.getOID() == 0) ? pt.getGol6_margin() : ptc.getGol6_margin(), "###.#")%>" onClick="this.select()" onChange="javascript:checkMargin6('<%=im.getOID()%>','<%=pt.getOID()%>')" style="text-align: right"/>
                                                                                                                        </font></div>
                                                                                                                    </td>
                                                                                                                    <td class="tablecell1"> 
                                                                                                                        <div align="right"><font> 
                                                                                                                                <input type="text" name="gol7_<%=pt.getOID()%>" size="5" value="<%=(ptc.getOID() == 0) ? pt.getGol7() : ptc.getGol7()%>" onClick="this.select()" onChange="javascript:checkGol7('<%=im.getOID()%>','<%=pt.getOID()%>')" style="text-align: right"/>
                                                                                                                        </font></div>
                                                                                                                    </td>
                                                                                                                    <td class="tablecell1"> 
                                                                                                                        <div align="right"><font> 
                                                                                                                                <input type="text" name="m7_<%=pt.getOID()%>" size="3" value="<%=JSPFormater.formatNumber((ptc.getOID() == 0) ? pt.getGol7_margin() : ptc.getGol7_margin(), "###.#")%>" onClick="this.select()" onChange="javascript:checkMargin7('<%=im.getOID()%>','<%=pt.getOID()%>')" style="text-align: right"/>
                                                                                                                        </font></div>
                                                                                                                    </td>
                                                                                                                    <td class="tablecell1"> 
                                                                                                                        <div align="right"><font> 
                                                                                                                                <input type="text" name="gol8_<%=pt.getOID()%>" size="5" value="<%=(ptc.getOID() == 0) ? pt.getGol8() : ptc.getGol8()%>" onClick="this.select()" onChange="javascript:checkGol8('<%=im.getOID()%>','<%=pt.getOID()%>')" style="text-align: right"/>
                                                                                                                        </font></div>
                                                                                                                    </td>
                                                                                                                    <td class="tablecell1"> 
                                                                                                                        <div align="right"><font> 
                                                                                                                                <input type="text" name="m8_<%=pt.getOID()%>" size="3" value="<%=JSPFormater.formatNumber((ptc.getOID() == 0) ? pt.getGol8_margin() : ptc.getGol8_margin(), "###.#")%>" onClick="this.select()" onChange="javascript:checkMargin8('<%=im.getOID()%>','<%=pt.getOID()%>')" style="text-align: right"/>
                                                                                                                        </font></div>
                                                                                                                    </td>
                                                                                                                    <td class="tablecell1"> 
                                                                                                                        <div align="right"><font> 
                                                                                                                                <input type="text" name="gol9_<%=pt.getOID()%>" size="5" value="<%=(ptc.getOID() == 0) ? pt.getGol9() : ptc.getGol9()%>" onClick="this.select()" onChange="javascript:checkGol9('<%=im.getOID()%>','<%=pt.getOID()%>')" style="text-align: right"/>
                                                                                                                        </font></div>
                                                                                                                    </td>
                                                                                                                    <td class="tablecell1"> 
                                                                                                                        <div align="right"><font> 
                                                                                                                                <input type="text" name="m9_<%=pt.getOID()%>" size="3" value="<%=JSPFormater.formatNumber((ptc.getOID() == 0) ? pt.getGol9_margin() : ptc.getGol9_margin(), "###.#")%>" onClick="this.select()" onChange="javascript:checkMargin9('<%=im.getOID()%>','<%=pt.getOID()%>')" style="text-align: right"/>
                                                                                                                        </font></div>
                                                                                                                    </td>
                                                                                                                    <td class="tablecell1"> 
                                                                                                                        <div align="right"><font> 
                                                                                                                                <input type="text" name="gol10_<%=pt.getOID()%>" size="5" value="<%=(ptc.getOID() == 0) ? pt.getGol10() : ptc.getGol10()%>" onClick="this.select()" onChange="javascript:checkGol10('<%=im.getOID()%>','<%=pt.getOID()%>')" style="text-align: right"/>
                                                                                                                        </font></div>
                                                                                                                    </td>
                                                                                                                    <td class="tablecell1"> 
                                                                                                                        <div align="center"><font> 
                                                                                                                                <input type="text" name="m10_<%=pt.getOID()%>" size="3" value="<%=JSPFormater.formatNumber((ptc.getOID() == 0) ? pt.getGol10_margin() : ptc.getGol10_margin(), "###.#")%>" onClick="this.select()" onChange="javascript:checkMargin10('<%=im.getOID()%>','<%=pt.getOID()%>')" style="text-align: right"/>
                                                                                                                        </font></div>
                                                                                                                    </td>
                                                                                                                    <td class="tablecell1" nowrap> 
                                                                                                                        <div align="center"><font><%=(ptc.getOID() == 0) ? "" : ptc.getRefNumber()%></font></div>
                                                                                                                    </td>
                                                                                                                    <td class="tablecell1" nowrap> 
                                                                                                                        <div align="center"><font><%=(ptc.getOID() == 0) ? "" : JSPFormater.formatDate(ptc.getActiveDate(), "dd-MM-yyyy")%></font></div>
                                                                                                                    </td>
                                                                                                                    <td class="tablecell1"> 
                                                                                                                        <div align="center"><font><%=(ptc.getOID() == 0) ? "" : ((ptc.getStatus() == 0) ? "-" : "PROCEED")%></font></div>
                                                                                                                    </td>
                                                                                                                    <td class="tablecell1"><font> 
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
                                                                                                                    </font></td>
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
                                                                                                    <%if (privUpdate || privAdd) {%>
                                                                                                    <tr align="left" valign="top"> 
                                                                                                        <td>
                                                                                                            <table width="20%" border="0" cellspacing="0" cellpadding="0">
                                                                                                                <tr>
                                                                                                                    <td><a href="javascript:cmdSave()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('save21','','../images/save2.gif',1)"><img src="../images/save.gif" name="save21" height="22" border="0"></a></td>
                                                                                                                    
                                                                                                                </tr>
                                                                                                            </table>
                                                                                                        </td>    
                                                                                                        
                                                                                                    </tr>
                                                                                                    <%}%>
                                                                                                    
                                                                                                    <%  }
            } catch (Exception exc) {
            }%>
                                                                                                                                                                                      
                                                                                                                                                                                            
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
