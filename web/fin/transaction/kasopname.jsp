
<%-- 
    Document   : kasopname
    Created on : Dec 14, 2011, 2:56:11 PM
    Author     : Roy Andika
--%>

<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.main.entity.*" %>
<%@ page import = "com.project.admin.*" %>
<%@ page import = "com.project.general.*" %>
<%@ page import = "com.project.fms.transaction.*" %>
<%@ page import = "com.project.fms.session.*" %>
<%@ include file = "../main/javainit.jsp" %>
<% int appObjCode = 1;%>
<%@ include file = "../main/check.jsp" %>
<%@ include file="../calendar/calendarframe.jsp"%>
<%
            boolean priv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MN_CASH, AppMenu.M2_MN_CASH_OPNAME);
            boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_CASH, AppMenu.M2_MN_CASH_OPNAME, AppMenu.PRIV_VIEW);
            boolean privUpdate = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_CASH, AppMenu.M2_MN_CASH_OPNAME, AppMenu.PRIV_UPDATE);
            boolean privAdd = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_CASH, AppMenu.M2_MN_CASH_OPNAME, AppMenu.PRIV_ADD);
            boolean privDelete = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_CASH, AppMenu.M2_MN_CASH_OPNAME, AppMenu.PRIV_DELETE);
%>

<%
            String[] langCT = {"Date"};
            
            String[] langNav = {"CASH", "KAS OPNAME LIST","TOTAL CASH REGISTER","KAS OPNAME","Date","Check / Bilyet Giro","Total Check","Total","Total", "Diferent"};

            if (lang == LANG_ID) {
                String[] langID = {"Tanggal"};
                langCT = langID;
                String[] navID = {"TUNAI", "DATA KAS OPNAME","TOTAL KAS REGISTER","KAS OPNAME","Tanggal","Check / Bilyet Giro","Total Check/uang muka","Saldo Uang dalam kas","Saldo menurut buku","Perbedaan"};
                langNav = navID;
            }

            int iJSPCommand = JSPRequestValue.requestCommand(request);
            int start = JSPRequestValue.requestInt(request, "start");
            int previJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
            long oidKasOpname = JSPRequestValue.requestLong(request, "hidden_kas_opname_id");
            int hidden_type = JSPRequestValue.requestInt(request, "hidden_type");
            int del_idx = JSPRequestValue.requestInt(request, "del_idx");

            if (iJSPCommand == JSPCommand.NONE) { 
                session.removeValue("KAS_OPNAME_RP"); 
                session.removeValue("KAS_OPNAME_DOLLAR"); 
                session.removeValue("KAS_OPNAME_CHECK"); 
            }
            
            Date dtKas = new Date();
            int recordToGet = 0;
            String msgString = "";
            int iErrCode = JSPMessage.NONE;
            String msgPeriod = "";
            long oidCurRp = 0;
            long oidCurDollar = 0;

            if (iJSPCommand == JSPCommand.SEARCH || iJSPCommand == JSPCommand.SUBMIT || iJSPCommand == JSPCommand.SAVE || iJSPCommand == JSPCommand.ADD || iJSPCommand == JSPCommand.CANCEL) {
                dtKas = JSPFormater.formatDate(JSPRequestValue.requestString(request, "DATE_KAS"), "dd/MM/yyyy");
            }

            String currRp = "";
            String currDollar = "";

            try {
                oidCurRp = Long.parseLong(DbSystemProperty.getValueByName("OID_CURRENCY_RP"));
                Currency currx = new Currency();
                try {
                    currx = DbCurrency.fetchExc(oidCurRp);
                    currRp = currx.getCurrencyCode();
                } catch (Exception e){ System.out.println("[exception] " + e.toString()); }
            } catch (Exception e) { System.out.println("[exception] " + e.toString()); }

            try {
                oidCurDollar = Long.parseLong(DbSystemProperty.getValueByName("OID_CURR_DOLLAR"));
                Currency currx = new Currency();
                try {
                    currx = DbCurrency.fetchExc(oidCurDollar);
                    currDollar = currx.getCurrencyCode();
                } catch (Exception e) { System.out.println("[exception] " + e.toString()); }
            } catch (Exception e) { System.out.println("[exception] " + e.toString()); }
            
            KasOpname objKasOpname = new KasOpname();

            String whereClauseRp = DbKasOpname.colNames[DbKasOpname.COL_CURRENCY_ID] + " = " + oidCurRp + " AND " + DbKasOpname.colNames[DbKasOpname.COL_TYPE] + " = " + DbKasOpname.TYPE_NON_CHECK + " AND " + DbKasOpname.colNames[DbKasOpname.COL_DATE_TRANSACTION] + " = '" + JSPFormater.formatDate(dtKas, "yyyy-MM-dd") + "'";
            String whereClauseDollar = DbKasOpname.colNames[DbKasOpname.COL_CURRENCY_ID] + " = " + oidCurDollar + " AND " + DbKasOpname.colNames[DbKasOpname.COL_TYPE] + " = " + DbKasOpname.TYPE_NON_CHECK + " AND " + DbKasOpname.colNames[DbKasOpname.COL_DATE_TRANSACTION] + " = '" + JSPFormater.formatDate(dtKas, "yyyy-MM-dd") + "'";
            String whereClauseCheck = DbKasOpname.colNames[DbKasOpname.COL_TYPE] + " = " + DbKasOpname.TYPE_CHECK + " AND " + DbKasOpname.colNames[DbKasOpname.COL_DATE_TRANSACTION] + " = '" + JSPFormater.formatDate(dtKas, "yyyy-MM-dd") + "'";

            String orderClause = DbKasOpname.colNames[DbKasOpname.COL_AMOUNT] + " DESC ";

            CmdKasOpname ctrlKasOpname = new CmdKasOpname(request);
            
            Vector listKasOpnameRupiah = new Vector(1, 1); Vector listKasOpnameDollar = new Vector(1, 1); Vector listKasOpnameCheck = new Vector(1, 1);

            boolean isAmount = true; boolean isQty = true; boolean isMemo = true;
            
            msgString = ctrlKasOpname.getMessage();
            Date dtLastOpname = dtKas;
            Vector result = new Vector();
            if(iJSPCommand == JSPCommand.SEARCH){  
                hidden_type = 0;             
                listKasOpnameRupiah = DbKasOpname.list(start, recordToGet, whereClauseRp, orderClause);
                listKasOpnameDollar = DbKasOpname.list(start, recordToGet, whereClauseDollar, orderClause);
                listKasOpnameCheck = DbKasOpname.list(start, recordToGet, whereClauseCheck, orderClause);
                result = DbKasOpname.list(start, recordToGet, whereClauseRp, orderClause);
                if ((listKasOpnameRupiah == null || listKasOpnameRupiah.size() <= 0) && (listKasOpnameDollar == null || listKasOpnameDollar.size() <= 0) && (listKasOpnameCheck == null || listKasOpnameCheck.size() <= 0)){

                    dtLastOpname = dtKas;
                    try {
                        dtLastOpname = DbKasOpname.transactionDate(dtKas);
                        if (dtLastOpname == null){
                            dtLastOpname = dtKas;
                        } else {
                            msgPeriod = "Karena kas opname tanggal " + JSPFormater.formatDate(dtKas, "yyyy-MM-dd") + " masih kosong, maka ditampilkan kas opname sebelumnya yaitu tanggal " + JSPFormater.formatDate(dtLastOpname, "yyyy-MM-dd");
                        }
                    } catch (Exception e){}

                    whereClauseRp = DbKasOpname.colNames[DbKasOpname.COL_CURRENCY_ID] + " = " + oidCurRp + " AND " + DbKasOpname.colNames[DbKasOpname.COL_TYPE] + " = " + DbKasOpname.TYPE_NON_CHECK + " AND " + DbKasOpname.colNames[DbKasOpname.COL_DATE_TRANSACTION] + " = '" + JSPFormater.formatDate(dtLastOpname, "yyyy-MM-dd") + "'";
                    whereClauseDollar = DbKasOpname.colNames[DbKasOpname.COL_CURRENCY_ID] + " = " + oidCurDollar + " AND " + DbKasOpname.colNames[DbKasOpname.COL_TYPE] + " = " + DbKasOpname.TYPE_NON_CHECK + " AND " + DbKasOpname.colNames[DbKasOpname.COL_DATE_TRANSACTION] + " = '" + JSPFormater.formatDate(dtLastOpname, "yyyy-MM-dd") + "'";
                    whereClauseCheck = DbKasOpname.colNames[DbKasOpname.COL_TYPE] + " = " + DbKasOpname.TYPE_CHECK + " AND " + DbKasOpname.colNames[DbKasOpname.COL_DATE_TRANSACTION] + " = '" + JSPFormater.formatDate(dtLastOpname, "yyyy-MM-dd") + "'";

                    listKasOpnameRupiah = DbKasOpname.listPeriodeNotExist(start, recordToGet, whereClauseRp, orderClause);
                    listKasOpnameDollar = DbKasOpname.listPeriodeNotExist(start, recordToGet, whereClauseDollar, orderClause);
                    listKasOpnameCheck = DbKasOpname.listPeriodeNotExist(start, recordToGet, whereClauseCheck, orderClause);
                    result = DbKasOpname.listPeriodeNotExist(start, recordToGet, whereClauseRp, orderClause);
                    session.putValue("KAS_OPNAME_RP", result); 
                    session.putValue("KAS_OPNAME_DOLLAR", listKasOpnameDollar); 
                    session.putValue("KAS_OPNAME_CHECK", listKasOpnameCheck);                    
                }else{
                    session.putValue("KAS_OPNAME_RP", result); session.putValue("KAS_OPNAME_DOLLAR", listKasOpnameDollar); session.putValue("KAS_OPNAME_CHECK", listKasOpnameCheck);
                } 
            }

            Vector groupRp = new Vector();
            if(iJSPCommand != JSPCommand.NONE){
                if (listKasOpnameRupiah == null || listKasOpnameRupiah.size() <= 0){
                    for (int iamount = 0; iamount < DbKasOpname.valueRp.length; iamount++) {
                        groupRp.add("" + DbKasOpname.valueRp[iamount]);
                    }
                } else {
                    groupRp = DbKasOpname.groupRp(listKasOpnameRupiah);
                }
            }
            
            if(iJSPCommand == JSPCommand.ADD || iJSPCommand == JSPCommand.SUBMIT){
                if((listKasOpnameRupiah == null || listKasOpnameRupiah.size() <= 0) && (listKasOpnameDollar == null || listKasOpnameDollar.size() <= 0) && (listKasOpnameCheck == null || listKasOpnameCheck.size() <= 0)){

                    dtLastOpname = dtKas;
                    try {
                        dtLastOpname = DbKasOpname.transactionDate(dtKas);
                        if (dtLastOpname == null){
                            dtLastOpname = dtKas;
                        }
                    } catch (Exception e){}
                }
            }
            
            if(iJSPCommand == JSPCommand.ADD){  
                listKasOpnameRupiah = (Vector) session.getValue("KAS_OPNAME_RP");   
                result = new Vector();
                if(listKasOpnameRupiah != null && listKasOpnameRupiah.size() > 0){
                    for(int r = 0; r < listKasOpnameRupiah.size() ; r++){                    
                        KasOpname objKp = (KasOpname)listKasOpnameRupiah.get(r);
                        result.add(objKp);
                    }
                }                
                listKasOpnameDollar = (Vector) session.getValue("KAS_OPNAME_DOLLAR");
                listKasOpnameCheck = (Vector) session.getValue("KAS_OPNAME_CHECK");
                
                session.putValue("KAS_OPNAME_RP", result); 
                session.putValue("KAS_OPNAME_DOLLAR", listKasOpnameDollar); 
                session.putValue("KAS_OPNAME_CHECK", listKasOpnameCheck);
                
            }
            
            
            if (iJSPCommand == JSPCommand.CANCEL){
                listKasOpnameRupiah = (Vector) session.getValue("KAS_OPNAME_RP");   
                result = new Vector();
                if(listKasOpnameRupiah != null && listKasOpnameRupiah.size() > 0){
                    for(int r = 0; r < listKasOpnameRupiah.size() ; r++){                    
                        KasOpname objKp = (KasOpname)listKasOpnameRupiah.get(r);
                        result.add(objKp);
                    }
                }                
                listKasOpnameDollar = (Vector) session.getValue("KAS_OPNAME_DOLLAR");
                listKasOpnameCheck = (Vector) session.getValue("KAS_OPNAME_CHECK");
                
                session.putValue("KAS_OPNAME_RP", result); 
                session.putValue("KAS_OPNAME_DOLLAR", listKasOpnameDollar); 
                session.putValue("KAS_OPNAME_CHECK", listKasOpnameCheck);
            }
            
            
            if (iJSPCommand == JSPCommand.DELETE){
                
                listKasOpnameRupiah = (Vector) session.getValue("KAS_OPNAME_RP");   
                
                result = new Vector();
                if(listKasOpnameRupiah != null && listKasOpnameRupiah.size() > 0){
                    for(int r = 0; r < listKasOpnameRupiah.size() ; r++){                    
                        KasOpname objKp = (KasOpname)listKasOpnameRupiah.get(r);
                        result.add(objKp);
                    }
                }                
                listKasOpnameDollar = (Vector) session.getValue("KAS_OPNAME_DOLLAR");
                listKasOpnameCheck = (Vector) session.getValue("KAS_OPNAME_CHECK");
                
                if (hidden_type == 1){
                    
                    for(int z = 0 ; z < listKasOpnameRupiah.size() ; z++){
                        
                        KasOpname objKp = (KasOpname)listKasOpnameRupiah.get(z);
                        
                        if(z == del_idx){
                            
                            if(objKp.getOID() != 0){
                                try{
                                    DbKasOpname.deleteExc(objKp.getOID());
                                }catch(Exception e){}
                            }                            
                        }       
                                
                    }
                    
                }else if(hidden_type == 2){
                    
                }else if(hidden_type == 3){
                    
                }
                
                session.putValue("KAS_OPNAME_RP", result); 
                session.putValue("KAS_OPNAME_DOLLAR", listKasOpnameDollar); 
                session.putValue("KAS_OPNAME_CHECK", listKasOpnameCheck);
            }
            
            if (iJSPCommand == JSPCommand.SUBMIT){
                
                listKasOpnameRupiah = (Vector) session.getValue("KAS_OPNAME_RP");
                listKasOpnameDollar = (Vector) session.getValue("KAS_OPNAME_DOLLAR");
                listKasOpnameCheck = (Vector) session.getValue("KAS_OPNAME_CHECK");
                
                Vector resultRp = new Vector();Vector tmpResultRp = new Vector();
                Vector resultD = new Vector();
                Vector resultCheck = new Vector();
                                                                                           
                if (listKasOpnameRupiah == null || listKasOpnameRupiah.size() <= 0){
                    for (int xRp = 0; xRp < groupRp.size(); xRp++){
                        long kasOpnameId = JSPRequestValue.requestLong(request, JspKasOpname.colNames[JspKasOpname.JSP_KAS_OPNAME_ID] + "_" + xRp);
                        long currencyId = JSPRequestValue.requestLong(request, JspKasOpname.colNames[JspKasOpname.JSP_CURRENCY_ID] + "_" + xRp);
                        int type = JSPRequestValue.requestInt(request, JspKasOpname.colNames[JspKasOpname.JSP_TYPE] + "_" + xRp);
                        String memo = JSPRequestValue.requestString(request, JspKasOpname.colNames[JspKasOpname.JSP_MEMO] + "_" + xRp);
                        double amount = JSPRequestValue.requestDouble(request, JspKasOpname.colNames[JspKasOpname.JSP_AMOUNT] + "_" + xRp);
                        int qty = JSPRequestValue.requestInt(request, JspKasOpname.colNames[JspKasOpname.JSP_QTY] + "_" + xRp);

                        KasOpname kasOp = new KasOpname();
                        kasOp.setCurrencyId(currencyId);
                        kasOp.setType(type);
                        kasOp.setMemo(memo);
                        kasOp.setAmount(amount);
                        kasOp.setQty(qty);
                        kasOp.setDateTransaction(dtKas);

                        if (kasOpnameId != 0){
                            kasOp.setOID(kasOpnameId);
                            resultRp.add(kasOp);tmpResultRp.add(kasOp);result.add(kasOp);                           
                        } else {
                            resultRp.add(kasOp);tmpResultRp.add(kasOp);result.add(kasOp);                            
                        }
                    }

                } else {

                    for (int xRp = 0; xRp < listKasOpnameRupiah.size(); xRp++){

                        long kasOpnameId = JSPRequestValue.requestLong(request, JspKasOpname.colNames[JspKasOpname.JSP_KAS_OPNAME_ID] + "_" + xRp);
                        long currencyId = JSPRequestValue.requestLong(request, JspKasOpname.colNames[JspKasOpname.JSP_CURRENCY_ID] + "_" + xRp);
                        int type = JSPRequestValue.requestInt(request, JspKasOpname.colNames[JspKasOpname.JSP_TYPE] + "_" + xRp);
                        String memo = JSPRequestValue.requestString(request, JspKasOpname.colNames[JspKasOpname.JSP_MEMO] + "_" + xRp);
                        double amount = JSPRequestValue.requestDouble(request, JspKasOpname.colNames[JspKasOpname.JSP_AMOUNT] + "_" + xRp);
                        int qty = JSPRequestValue.requestInt(request, JspKasOpname.colNames[JspKasOpname.JSP_QTY] + "_" + xRp);

                        KasOpname kasOp = new KasOpname();
                        kasOp.setCurrencyId(currencyId);
                        kasOp.setType(type);
                        kasOp.setMemo(memo);
                        kasOp.setAmount(amount);
                        kasOp.setQty(qty);
                        kasOp.setDateTransaction(dtKas);

                        if(kasOpnameId != 0){
                            kasOp.setOID(kasOpnameId);
                            resultRp.add(kasOp);tmpResultRp.add(kasOp);result.add(kasOp);
                        }else{
                            resultRp.add(kasOp);tmpResultRp.add(kasOp);result.add(kasOp);
                        }
                    }
                }
                
                for (int xD = 0; xD < listKasOpnameDollar.size(); xD++) {
                    long kasOpnameId = JSPRequestValue.requestLong(request, JspKasOpname.colNames[JspKasOpname.JSP_KAS_OPNAME_ID] + "D_" + xD);
                    long currencyId = JSPRequestValue.requestLong(request, JspKasOpname.colNames[JspKasOpname.JSP_CURRENCY_ID] + "D_" + xD);
                    int type = JSPRequestValue.requestInt(request, JspKasOpname.colNames[JspKasOpname.JSP_TYPE] + "D_" + xD);
                    String memo = JSPRequestValue.requestString(request, JspKasOpname.colNames[JspKasOpname.JSP_MEMO] + "D_" + xD);
                    double amount = JSPRequestValue.requestDouble(request, JspKasOpname.colNames[JspKasOpname.JSP_AMOUNT] + "D_" + xD);
                    int qty = JSPRequestValue.requestInt(request, JspKasOpname.colNames[JspKasOpname.JSP_QTY] + "D_" + xD);

                    KasOpname kasOp = new KasOpname();
                    kasOp.setCurrencyId(currencyId);
                    kasOp.setType(type);
                    kasOp.setMemo(memo);
                    kasOp.setAmount(amount);
                    kasOp.setQty(qty);
                    kasOp.setDateTransaction(dtKas);

                    if (kasOpnameId != 0) {
                        kasOp.setOID(kasOpnameId);
                        resultD.add(kasOp);

                    } else {
                        resultD.add(kasOp);
                    }
                }
                
                 for (int xC = 0; xC < listKasOpnameCheck.size(); xC++){

                    long kasOpnameId = JSPRequestValue.requestLong(request, JspKasOpname.colNames[JspKasOpname.JSP_KAS_OPNAME_ID] + "C_" + xC);
                    long currencyId = JSPRequestValue.requestLong(request, JspKasOpname.colNames[JspKasOpname.JSP_CURRENCY_ID] + "C_" + xC);
                    int type = JSPRequestValue.requestInt(request, JspKasOpname.colNames[JspKasOpname.JSP_TYPE] + "C_" + xC);
                    String memo = JSPRequestValue.requestString(request, JspKasOpname.colNames[JspKasOpname.JSP_MEMO] + "C_" + xC);
                    double amount = JSPRequestValue.requestDouble(request, JspKasOpname.colNames[JspKasOpname.JSP_AMOUNT] + "C_" + xC);
                    int qty = JSPRequestValue.requestInt(request, JspKasOpname.colNames[JspKasOpname.JSP_QTY] + "C_" + xC);

                    KasOpname kasOp = new KasOpname();
                    kasOp.setCurrencyId(currencyId);
                    kasOp.setType(type);
                    kasOp.setMemo(memo);
                    kasOp.setAmount(amount);
                    kasOp.setQty(qty);
                    kasOp.setDateTransaction(dtKas);

                    if (kasOpnameId != 0) {
                        kasOp.setOID(kasOpnameId);
                        resultCheck.add(kasOp);
                    } else {
                        resultCheck.add(kasOp);
                    }
                }

                if (hidden_type == 1 || hidden_type == 2 || hidden_type == 3){ // jika ada penambahan di data di komom rupiah

                    long currencyId = JSPRequestValue.requestLong(request, JspKasOpname.colNames[JspKasOpname.JSP_CURRENCY_ID] + "ADD_0");
                    int type = JSPRequestValue.requestInt(request, JspKasOpname.colNames[JspKasOpname.JSP_TYPE] + "ADD_0");
                    String memo = JSPRequestValue.requestString(request, JspKasOpname.colNames[JspKasOpname.JSP_MEMO] + "ADD_0");
                    double amount = JSPRequestValue.requestDouble(request, JspKasOpname.colNames[JspKasOpname.JSP_AMOUNT] + "ADD_0");
                    int qty = JSPRequestValue.requestInt(request, JspKasOpname.colNames[JspKasOpname.JSP_QTY] + "ADD_0");

                    if (hidden_type == 1 || hidden_type == 2){

                        if (amount == 0){
                            iErrCode = 1;
                            if (amount == 0) {
                                isAmount = false;
                            }
                            
                        }
                    } else if (hidden_type == 3) {

                        if (memo.length() <= 0) {
                            iErrCode = 1;
                          
                            if (memo.length() <= 0) {
                                isMemo = false;
                            }
                        }
                    }
                    objKasOpname.setCurrencyId(currencyId);
                    objKasOpname.setType(type);
                    objKasOpname.setMemo(memo);
                    objKasOpname.setAmount(amount);
                    objKasOpname.setQty(qty);
                    objKasOpname.setDateTransaction(dtKas);

                    if (iErrCode == 0) {                    
                        if(hidden_type == 1){
                            resultRp.add(objKasOpname);tmpResultRp.add(objKasOpname);result.add(objKasOpname);
                        }else if(hidden_type == 2){
                            resultD.add(objKasOpname);
                        }else if(hidden_type == 3){
                            resultCheck.add(objKasOpname);
                        }   
                    }
                }
                msgPeriod = "";
                session.removeValue("KAS_OPNAME_RP"); session.removeValue("KAS_OPNAME_DOLLAR"); session.removeValue("KAS_OPNAME_CHECK");
                session.putValue("KAS_OPNAME_RP", tmpResultRp); session.putValue("KAS_OPNAME_DOLLAR", resultD); session.putValue("KAS_OPNAME_CHECK", resultCheck);
                listKasOpnameRupiah = resultRp;
                listKasOpnameDollar = resultD;
                listKasOpnameCheck = resultCheck;
                
                if(iErrCode == 0){
                    hidden_type = 0;
                }
            }            

            if (iJSPCommand == JSPCommand.SAVE){
                listKasOpnameRupiah = (Vector) session.getValue("KAS_OPNAME_RP");
                listKasOpnameDollar = (Vector) session.getValue("KAS_OPNAME_DOLLAR");
                listKasOpnameCheck = (Vector) session.getValue("KAS_OPNAME_CHECK");
                
                if(listKasOpnameRupiah != null && listKasOpnameRupiah.size() > 0){
                    
                    for(int x = 0 ; x < listKasOpnameRupiah.size() ; x++){
                        KasOpname xKp = (KasOpname)listKasOpnameRupiah.get(x);
                        try{
                            if(xKp.getOID() == 0){
                                DbKasOpname.insertExc(xKp);
                            }else{
                                DbKasOpname.updateExc(xKp);
                            }
                        }catch(Exception e){}
                    }
                    
                    
                    for(int x = 0 ; x < listKasOpnameDollar.size() ; x++){
                        KasOpname xKp = (KasOpname)listKasOpnameDollar.get(x);
                        try{
                            if(xKp.getOID() == 0){
                                DbKasOpname.insertExc(xKp);
                            }else{
                                DbKasOpname.updateExc(xKp);
                            }
                        }catch(Exception e){}
                    }
                    
                    for(int x = 0 ; x < listKasOpnameCheck.size() ; x++){
                        KasOpname xKp = (KasOpname)listKasOpnameCheck.get(x);
                        try{
                            if(xKp.getOID() == 0){
                                DbKasOpname.insertExc(xKp);
                            }else{
                                DbKasOpname.updateExc(xKp);
                            }
                        }catch(Exception e){}
                    }
                }
                    result = new Vector();
                    whereClauseRp = DbKasOpname.colNames[DbKasOpname.COL_CURRENCY_ID] + " = " + oidCurRp + " AND " + DbKasOpname.colNames[DbKasOpname.COL_TYPE] + " = " + DbKasOpname.TYPE_NON_CHECK + " AND " + DbKasOpname.colNames[DbKasOpname.COL_DATE_TRANSACTION] + " = '" + JSPFormater.formatDate(dtLastOpname, "yyyy-MM-dd") + "'";
                    whereClauseDollar = DbKasOpname.colNames[DbKasOpname.COL_CURRENCY_ID] + " = " + oidCurDollar + " AND " + DbKasOpname.colNames[DbKasOpname.COL_TYPE] + " = " + DbKasOpname.TYPE_NON_CHECK + " AND " + DbKasOpname.colNames[DbKasOpname.COL_DATE_TRANSACTION] + " = '" + JSPFormater.formatDate(dtLastOpname, "yyyy-MM-dd") + "'";
                    whereClauseCheck = DbKasOpname.colNames[DbKasOpname.COL_TYPE] + " = " + DbKasOpname.TYPE_CHECK + " AND " + DbKasOpname.colNames[DbKasOpname.COL_DATE_TRANSACTION] + " = '" + JSPFormater.formatDate(dtLastOpname, "yyyy-MM-dd") + "'";
                    result = DbKasOpname.list(start, recordToGet, whereClauseRp, orderClause);        
                    listKasOpnameRupiah = DbKasOpname.list(start, recordToGet, whereClauseRp, orderClause);
                    listKasOpnameDollar = DbKasOpname.list(start, recordToGet, whereClauseDollar, orderClause);
                    listKasOpnameCheck = DbKasOpname.list(start, recordToGet, whereClauseCheck, orderClause);
                
            }
            
            groupRp = new Vector();
            
            if(iJSPCommand != JSPCommand.NONE){
                if (listKasOpnameRupiah == null || listKasOpnameRupiah.size() <= 0) {
                    for (int iamount = 0; iamount < DbKasOpname.valueRp.length; iamount++) {
                        groupRp.add("" + DbKasOpname.valueRp[iamount]);
                    }
                } else {
                    groupRp = DbKasOpname.groupRp(listKasOpnameRupiah);//groupRp = DbKasOpname.groupRp(dtLastOpname);
                }
            }
%>
<html >
    <!-- #BeginTemplate "/Templates/index.dwt" --> 
    <head>
        <!-- #BeginEditable "javascript" --> 
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <link href="../css/default.css" rel="stylesheet" type="text/css" />
        <link href="../css/css.css" rel="stylesheet" type="text/css" />   
        <script type="text/javascript" src="../highslide/highslide-with-html.js"></script>
        <link rel="stylesheet" type="text/css" href="../highslide/highslide.css" />
        <script type="text/javascript">    
            hs.graphicsDir = '../highslide/graphics/';
            hs.outlineType = 'rounded-white';
            hs.outlineWhileAnimating = true;
        </script>
        <script type="text/javascript">
            hs.graphicsDir = '../highslide/graphics/';
            
            // Identify a caption for all images. This can also be set inline for each image.
            hs.captionId = 'the-caption';
            
            hs.outlineType = 'rounded-white';
        </script>
        <title><%=systemTitle%></title>
        <script language="JavaScript">
            <%if (!priv || !privView) {%>
            window.location="<%=approot%>/nopriv.jsp";
            <%}%>
            
            var sysDecSymbol = "<%=sSystemDecimalSymbol%>";
            var usrDigitGroup = "<%=sUserDigitGroup%>";
            var usrDecSymbol = "<%=sUserDecimalSymbol%>";
            
            function cmdReloadRp(index){
                <%
            for (int idx = 0; idx < listKasOpnameRupiah.size(); idx++) {
                %>
                    if(index == '<%=idx%>'){                        
                        var y = cleanNumberFloat(document.frmkasopname.<%=JspKasOpname.colNames[JspKasOpname.JSP_AMOUNT] + "_" + idx%>.value, sysDecSymbol, usrDigitGroup, usrDecSymbol);
                            var x = cleanNumberFloat(document.frmkasopname.<%=JspKasOpname.colNames[JspKasOpname.JSP_QTY] + "_" + idx%>.value, sysDecSymbol, usrDigitGroup, usrDecSymbol);
                                
                                var z = y * x;                        
                                document.frmkasopname.<%=JspKasOpname.colNames[JspKasOpname.JSP_AMOUNT] + "_" + idx%>.value = formatFloat(y, '', sysDecSymbol, usrDigitGroup, '', 0);                                
                                document.frmkasopname.<%="JSP_SUM_" + idx%>.value = formatFloat(z, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);
                                
                            }
                            <%}%>
                        } 
                        
                        
                        function cmdReloadGRp(index){
                <%
            for (int idx = 0; idx < groupRp.size(); idx++) {
                %>
                    if(index == '<%=idx%>'){                        
                        var y = cleanNumberFloat(document.frmkasopname.<%=JspKasOpname.colNames[JspKasOpname.JSP_AMOUNT] + "_" + idx%>.value, sysDecSymbol, usrDigitGroup, usrDecSymbol);
                            var x = cleanNumberFloat(document.frmkasopname.<%=JspKasOpname.colNames[JspKasOpname.JSP_QTY] + "_" + idx%>.value, sysDecSymbol, usrDigitGroup, usrDecSymbol);
                                
                                var z = y * x;                        
                                document.frmkasopname.<%=JspKasOpname.colNames[JspKasOpname.JSP_AMOUNT] + "_" + idx%>.value = formatFloat(y, '', sysDecSymbol, usrDigitGroup, '', 0);                                
                                document.frmkasopname.<%="JSP_SUM_" + idx%>.value = formatFloat(z, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);
                                
                            }
                            <%}%>
                        } 
                        
                        function cmdReloadRpAdd(){                                    
                            var y = cleanNumberFloat(document.frmkasopname.<%=JspKasOpname.colNames[JspKasOpname.JSP_AMOUNT] + "ADD_0"%>.value, sysDecSymbol, usrDigitGroup, usrDecSymbol);
                                var x = cleanNumberFloat(document.frmkasopname.<%=JspKasOpname.colNames[JspKasOpname.JSP_QTY] + "ADD_0"%>.value, sysDecSymbol, usrDigitGroup, usrDecSymbol);
                                    
                                    var z = y * x;                        
                                    document.frmkasopname.<%=JspKasOpname.colNames[JspKasOpname.JSP_AMOUNT] + "ADD_0"%>.value = formatFloat(y, '', sysDecSymbol, usrDigitGroup, '', 0);                                    
                                    document.frmkasopname.<%="JSP_SUMADD_0"%>.value = formatFloat(z, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);
                                } 
                                
                                function cmdReloadDollarAdd(){                                    
                                    var y = cleanNumberFloat(document.frmkasopname.<%=JspKasOpname.colNames[JspKasOpname.JSP_AMOUNT] + "ADD_0"%>.value, sysDecSymbol, usrDigitGroup, usrDecSymbol);
                                        var x = cleanNumberFloat(document.frmkasopname.<%=JspKasOpname.colNames[JspKasOpname.JSP_QTY] + "ADD_0"%>.value, sysDecSymbol, usrDigitGroup, usrDecSymbol);
                                            
                                            var z = y * x;                        
                                            document.frmkasopname.<%=JspKasOpname.colNames[JspKasOpname.JSP_AMOUNT] + "ADD_0"%>.value = formatFloat(y, '', sysDecSymbol, usrDigitGroup, '', 0);                                            
                                            document.frmkasopname.<%="JSP_SUMADD_0"%>.value = formatFloat(z, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);
                                        } 
                                        
                                        function cmdReloadDollarAddQty(){                                    
                                            var y = cleanNumberFloat(document.frmkasopname.<%=JspKasOpname.colNames[JspKasOpname.JSP_AMOUNT] + "ADD_0"%>.value, sysDecSymbol, usrDigitGroup, usrDecSymbol);
                                                var x = cleanNumberFloat(document.frmkasopname.<%=JspKasOpname.colNames[JspKasOpname.JSP_QTY] + "ADD_0"%>.value, sysDecSymbol, usrDigitGroup, usrDecSymbol);
                                                    
                                                    var z = y * x;                        
                                                    document.frmkasopname.<%=JspKasOpname.colNames[JspKasOpname.JSP_AMOUNT] + "ADD_0"%>.value = formatFloat(y, '', sysDecSymbol, usrDigitGroup, '', 0);
                                                    document.frmkasopname.<%="JSP_SUMADD_0"%>.value = formatFloat(z, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);
                                                } 
                                                
                                                function cmdReloadD(index){
                <%
            for (int idx = 0; idx < listKasOpnameDollar.size(); idx++) {
                %>
                    if(index == '<%=idx%>'){                        
                        var y = cleanNumberFloat(document.frmkasopname.<%=JspKasOpname.colNames[JspKasOpname.JSP_AMOUNT] + "D_" + idx%>.value, sysDecSymbol, usrDigitGroup, usrDecSymbol);
                            var x = cleanNumberFloat(document.frmkasopname.<%=JspKasOpname.colNames[JspKasOpname.JSP_QTY] + "D_" + idx%>.value, sysDecSymbol, usrDigitGroup, usrDecSymbol);
                                
                                var z = y * x;                        
                                document.frmkasopname.<%=JspKasOpname.colNames[JspKasOpname.JSP_AMOUNT] + "D_" + idx%>.value = formatFloat(y, '', sysDecSymbol, usrDigitGroup, '', 0);                                
                                document.frmkasopname.<%="JSP_SUMD_" + idx%>.value = formatFloat(z, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);
                                
                            }
                            <%}%>
                        }  
                        
                        function cmdReloadCheck(index){
                <%
            for (int idx = 0; idx < listKasOpnameCheck.size(); idx++) {
                %>
                    if(index == '<%=idx%>'){                        
                        var y = cleanNumberFloat(document.frmkasopname.<%=JspKasOpname.colNames[JspKasOpname.JSP_AMOUNT] + "C_" + idx%>.value, sysDecSymbol, usrDigitGroup, usrDecSymbol);
                            
                            document.frmkasopname.<%=JspKasOpname.colNames[JspKasOpname.JSP_AMOUNT] + "C_" + idx%>.value = formatFloat(y, '', sysDecSymbol, usrDigitGroup,usrDecSymbol, decPlace);
                            
                        }
                        <%}%>
                    }   
                    
                    function cmdAdd(){
                        document.frmkasopname.hidden_kasOpname_id.value="0";
                        document.frmkasopname.command.value="<%=JSPCommand.ADD%>";
                        document.frmkasopname.prev_command.value="<%=previJSPCommand%>";
                        document.frmkasopname.action="kasopname.jsp";
                        document.frmkasopname.submit();
                    }
                    
                    function cmdAddRp(){
                        document.frmkasopname.hidden_type.value="1";
                        document.frmkasopname.hidden_kasOpname_id.value="0";
                        document.frmkasopname.command.value="<%=JSPCommand.ADD%>";
                        document.frmkasopname.prev_command.value="<%=previJSPCommand%>";
                        document.frmkasopname.action="kasopname.jsp";
                        document.frmkasopname.submit();
                    }
                    
                    function cmdCancel(){
                        document.frmkasopname.hidden_type.value="0";
                        document.frmkasopname.hidden_kasOpname_id.value="0";
                        document.frmkasopname.command.value="<%=JSPCommand.CANCEL%>";
                        document.frmkasopname.prev_command.value="<%=previJSPCommand%>";
                        document.frmkasopname.action="kasopname.jsp";
                        document.frmkasopname.submit();
                    }
                    
                    function cmdAddDollar(){
                        document.frmkasopname.hidden_type.value="2";
                        document.frmkasopname.hidden_kasOpname_id.value="0";
                        document.frmkasopname.command.value="<%=JSPCommand.ADD%>";
                        document.frmkasopname.prev_command.value="<%=previJSPCommand%>";
                        document.frmkasopname.action="kasopname.jsp";
                        document.frmkasopname.submit();
                    }
                    
                    function cmdAddCheck(){
                        document.frmkasopname.hidden_type.value="3";
                        document.frmkasopname.hidden_kasOpname_id.value="0";
                        document.frmkasopname.command.value="<%=JSPCommand.ADD%>";
                        document.frmkasopname.prev_command.value="<%=previJSPCommand%>";
                        document.frmkasopname.action="kasopname.jsp";
                        document.frmkasopname.submit();
                    }
                    
                    function cmdAsk(oidKasOpname){
                        document.frmkasopname.hidden_kasOpname_id.value=oidKasOpname;
                        document.frmkasopname.command.value="<%=JSPCommand.ASK%>";
                        document.frmkasopname.prev_command.value="<%=previJSPCommand%>";
                        document.frmkasopname.action="kasopname.jsp";
                        document.frmkasopname.submit();
                    }
                    
                    function cmdConfirmDelete(oidKasOpname){
                        document.frmkasopname.hidden_kasOpname_id.value=oidKasOpname;
                        document.frmkasopname.command.value="<%=JSPCommand.DELETE%>";
                        document.frmkasopname.prev_command.value="<%=previJSPCommand%>";
                        document.frmkasopname.action="kasopname.jsp";
                        document.frmkasopname.submit();
                    }
                    
                    function cmdSave(){
                        document.frmkasopname.command.value="<%=JSPCommand.SAVE%>";
                        document.frmkasopname.prev_command.value="<%=previJSPCommand%>";
                        document.frmkasopname.action="kasopname.jsp";
                        document.frmkasopname.submit();
                    }
                    
                    function cmdSubmit(){
                        document.frmkasopname.command.value="<%=JSPCommand.SUBMIT%>";
                        document.frmkasopname.prev_command.value="<%=previJSPCommand%>";
                        document.frmkasopname.action="kasopname.jsp";
                        document.frmkasopname.submit();
                    }
                    
                    function cmdSearch(){
                        document.frmkasopname.command.value="<%=JSPCommand.SEARCH%>";
                        document.frmkasopname.prev_command.value="<%=previJSPCommand%>";
                        document.frmkasopname.action="kasopname.jsp";
                        document.frmkasopname.submit();
                    }
                    
                    function cmdListLast(){
                        document.frmkasopname.command.value="<%=JSPCommand.LAST%>";
                        document.frmkasopname.prev_command.value="<%=JSPCommand.LAST%>";
                        document.frmkasopname.action="kasopname.jsp";
                        document.frmkasopname.submit();
                    }
                    
                    function cmdDelPict(oidKasOpname){
                        document.frmimage.hidden_kasOpname_id.value=oidKasOpname;
                        document.frmimage.command.value="<%=JSPCommand.POST%>";
                        document.frmimage.action="kasopname.jsp";
                        document.frmimage.submit();
                    }
                    
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
    <body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif')">
        <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
            <tr> 
                <td valign="top"> 
                    <table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
                        <tr> 
                            <td height="96"> <!-- #BeginEditable "header" --> 
            <%@ include file="../main/hmenu.jsp"%>
                            <!-- #EndEditable --> </td>
                        </tr>
                        <tr> 
                            <td valign="top"> 
                                <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
                                    <!--DWLayoutTable-->
                                    <tr> 
                                        <td width="165" height="100%" valign="top" style="background:url(<%=approot%>/images/leftmenu-bg.gif) repeat-y"> 
                                            <!-- #BeginEditable "menu" --> 
                  <%@ include file="../main/menu.jsp"%>
                                        <!-- #EndEditable --> </td>
                                        <td width="100%" valign="top"> 
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                <tr> 
                                                    <td class="title"><!-- #BeginEditable "title" -->
                                           <%
            String navigator = "<font class=\"lvl1\">" + langNav[0] + "</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">" + langNav[1] + "</span></font>";
                                           %>
                                           <%@ include file="../main/navigator.jsp" %>
                                                    <!-- #EndEditable --></td>
                                                </tr>
                                                <!--tr> 
                      <td><img src="<%=approot%>/images/title-sp.gif" width="584" height="1"></td> 
                                                </tr-->
                                                <tr> 
                                                    <td><!-- #BeginEditable "content" --> 
                                                        <form name="frmkasopname" method ="post" action="">
                                                            <input type="hidden" name="command" value="<%=iJSPCommand%>">                                                            
                                                            <input type="hidden" name="start" value="<%=start%>">
                                                            <input type="hidden" name="prev_command" value="<%=previJSPCommand%>">
                                                            <input type="hidden" name="hidden_kasOpname_id" value="<%=oidKasOpname%>">
                                                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                            <input type="hidden" name="hidden_type" value="<%=hidden_type%>">
                                                            <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                <tr>
                                                                    <td class="container">
                                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="8"> 
                                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td colspan="3">&nbsp;</td>
                                                                                        </tr>    
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="8" valign="middle" colspan="3">
                                                                                                <table>
                                                                                                    <tr>
                                                                                                        <td><%=langCT[0]%>&nbsp;:&nbsp;</td>
                                                                                                        <td>
                                                                                                            <input name="DATE_KAS" value="<%=JSPFormater.formatDate((dtKas == null) ? new Date() : dtKas, "dd/MM/yyyy")%>" size="11" readonly>
                                                                                                            <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmkasopname.DATE_KAS);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a>
                                                                                                        </td>
                                                                                                    </tr>    
                                                                                                </table>              
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td colspan="3">&nbsp;</td>
                                                                                        </tr>    
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td colspan="3">
                                                                                                <a href="javascript:cmdSearch()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new11112','','../images/search2.gif',1)"><img src="../images/search.gif" name="new11112"  border="0" width="59" height="21"></a>                  
                                                                                            </td>
                                                                                        </tr>    
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td colspan="3">&nbsp;</td>
                                                                                        </tr>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td colspan="3">
                                                                                                <table width="98%" border="0" cellspacing="0" cellpadding="0">
                                                                                                    <tr> 
                                                                                                        <td height="2" background="../images/line.gif" ><img src="../images/line.gif"></td>
                                                                                                    </tr>
                                                                                                </table> 
                                                                                            </td>
                                                                                        </tr>
                                                                                        <%
            if (msgPeriod.length() > 0) {
                                                                                        %>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td colspan="3" height="7"></td>
                                                                                        </tr>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td colspan="3"><font color="FF0000"><%=msgPeriod%></font></td>
                                                                                        </tr>
                                                                                        <%}%>
                                                                                        <%
            if (iJSPCommand == JSPCommand.SEARCH || iJSPCommand == JSPCommand.SAVE || iJSPCommand == JSPCommand.ADD || iJSPCommand == JSPCommand.SUBMIT || iJSPCommand == JSPCommand.CANCEL){
                                                                                        %>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td colspan="3" height="7"></td>
                                                                                        </tr>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td colspan="3" align="left">
                                                                                                <table width="700px" border="0" cellpadding="0" cellspacing="1">
                                                                                                    <tr>
                                                                                                        <td align="center"><u><B><%=langNav[3]%></B></u></td>
                                                                                                    </tr>
                                                                                                    <tr>
                                                                                                        <td height="5"></td>
                                                                                                    </tr>
                                                                                                    <tr>
                                                                                                        <td align="center"><u><%=langNav[4]%> : <%=JSPFormater.formatDate(dtLastOpname, "yyyy-MM-dd")%></u></td>
                                                                                                    </tr>
                                                                                                </table>    
                                                                                            </td>    
                                                                                        </tr> 
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td colspan="3" height="5"></td>
                                                                                        </tr>                                                                                        
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td colspan="3">&nbsp;</td>
                                                                                        </tr>
                                                                                        <%}%>
                                                                                        <%

            String style = "tablecell";
            int pgIdx = 0;
            double totRp = 0;
            double totDollar = 0;
            double totCheck = 0;

            if (groupRp != null && groupRp.size() > 0){
                                                                                        %>     
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="22" valign="middle" colspan="3"> 
                                                                                                <table width="700px" border="0" cellpadding="0" cellspacing="1">
                                                                                                    <tr>
                                                                                                        <td colspan="9" class="tablehdr"><%=DbKasOpname.satCurrency[0]%></td>
                                                                                                    </tr>    
                                                                                                    <%
                                                                                                        style = "tablecell";

                                                                                                        for (int i = 0; i < groupRp.size(); i++) {

                                                                                                            double amount = 0;

                                                                                                            try {
                                                                                                                amount = Double.parseDouble("" + groupRp.get(i));
                                                                                                            } catch (Exception e) {
                                                                                                                System.out.print("[exc] when parsing double " + e.toString());
                                                                                                            }

                                                                                                            if (listKasOpnameRupiah == null || listKasOpnameRupiah.size() <= 0) {

                                                                                                    %>
                                                                                                    <input type="hidden" name = "<%=JspKasOpname.colNames[JspKasOpname.JSP_KAS_OPNAME_ID] + "_" + pgIdx%>" value = "<%=0%>">
                                                                                                    <input type="hidden" name = "<%=JspKasOpname.colNames[JspKasOpname.JSP_CURRENCY_ID] + "_" + pgIdx%>" value = "<%=oidCurRp%>">
                                                                                                    <input type="hidden" name = "<%=JspKasOpname.colNames[JspKasOpname.JSP_TYPE] + "_" + pgIdx%>" value = "<%=DbKasOpname.TYPE_NON_CHECK%>">
                                                                                                    <input type="hidden" name = "<%=JspKasOpname.colNames[JspKasOpname.JSP_MEMO] + "_" + pgIdx%>" value = "">                                                                                                    
                                                                                                    <tr>
                                                                                                        <td class="<%=style%>" width="5%" align="right"><%=pgIdx + 1%>&nbsp;&nbsp;&nbsp;</td>
                                                                                                        <td class="<%=style%>" width="15%" align="center"><%=DbKasOpname.satMoney[0]%></td>
                                                                                                        <td class="<%=style%>" width="5%" align="center"><%=DbKasOpname.satCurrency[0]%></td>
                                                                                                        <td class="<%=style%>" width="15%" align="right">
                                                                                                            <input type="text" style="text-align:right" name = "<%=JspKasOpname.colNames[JspKasOpname.JSP_AMOUNT] + "_" + pgIdx%>" value = "<%=JSPFormater.formatNumber(Double.parseDouble("" + groupRp.get(i)), "#,###")%>" size="15" onChange="javascript:cmdReloadGRp('<%=pgIdx%>')" >
                                                                                                        </td>
                                                                                                        <td class="<%=style%>" width="15%" align="center">sebanyak</td>
                                                                                                        <td class="<%=style%>" width="10%" align="right">
                                                                                                            <input type="text" style="text-align:right" name ="<%=JspKasOpname.colNames[JspKasOpname.JSP_QTY] + "_" + pgIdx%>" value = "<%=0%>"  size="15" onChange="javascript:cmdReloadGRp('<%=pgIdx%>')" >
                                                                                                        </td>
                                                                                                        <td class="<%=style%>" width="10%" align="center"><%=DbKasOpname.satQty[0]%></td>
                                                                                                        <td class="<%=style%>" width="5%" align="center"><%=currRp%></td>                                                                                                         
                                                                                                        <td class="<%=style%>" width="20%" align="right">                                                                                                        
                                                                                                            <input type="text" style="text-align:right" name = "JSP_SUM_<%=pgIdx%>" value ="<%=JSPFormater.formatNumber(0, "#,###.##")%>" size="20" readonly>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <%pgIdx++;
                                                                                                        } else {

                                                                                                            for (int ik = 0; ik < listKasOpnameRupiah.size(); ik++) {

                                                                                                                KasOpname kop = (KasOpname) listKasOpnameRupiah.get(ik);

                                                                                                                if (kop.getAmount() == amount) {

                                                                                                                    if (pgIdx % 2 == 0) {
                                                                                                                        style = "tablecell1";
                                                                                                                    } else {
                                                                                                                        style = "tablecell";
                                                                                                                    }

                                                                                                                    Currency curr = new Currency();

                                                                                                                    try {
                                                                                                                        curr = DbCurrency.fetchExc(kop.getCurrencyId());
                                                                                                                    } catch (Exception e) {
                                                                                                                        System.out.println("[exception] " + e.toString());
                                                                                                                    }

                                                                                                                    double sum = 0;

                                                                                                                    try {
                                                                                                                        sum = kop.getAmount() * kop.getQty();
                                                                                                                    } catch (Exception e) {
                                                                                                                        System.out.println("[exception] " + e.toString());
                                                                                                                    }

                                                                                                    %>
                                                                                                    <input type="hidden" name = "<%=JspKasOpname.colNames[JspKasOpname.JSP_KAS_OPNAME_ID] + "_" + pgIdx%>" value = "<%=kop.getOID()%>">
                                                                                                    <input type="hidden" name = "<%=JspKasOpname.colNames[JspKasOpname.JSP_CURRENCY_ID] + "_" + pgIdx%>" value = "<%=kop.getCurrencyId()%>">
                                                                                                    <input type="hidden" name = "<%=JspKasOpname.colNames[JspKasOpname.JSP_TYPE] + "_" + pgIdx%>" value = "<%=DbKasOpname.TYPE_NON_CHECK%>">
                                                                                                    <input type="hidden" name = "<%=JspKasOpname.colNames[JspKasOpname.JSP_MEMO] + "_" + pgIdx%>" value = "">                                                                                                    
                                                                                                    <tr>
                                                                                                        <td class="<%=style%>" width="5%" align="right"><%=pgIdx + 1%>&nbsp;&nbsp;&nbsp;</td>
                                                                                                        <td class="<%=style%>" width="15%" align="center"><%=DbKasOpname.satMoney[0]%></td>
                                                                                                        <td class="<%=style%>" width="5%" align="center"><%=DbKasOpname.satCurrency[0]%></td>
                                                                                                        <td class="<%=style%>" width="15%" align="right">
                                                                                                            <input type="text" style="text-align:right" name = "<%=JspKasOpname.colNames[JspKasOpname.JSP_AMOUNT] + "_" + pgIdx%>" value = "<%=JSPFormater.formatNumber(kop.getAmount(), "#,###")%>" size="15" onChange="javascript:cmdReloadRp('<%=pgIdx%>')" >
                                                                                                        </td>
                                                                                                        <td class="<%=style%>" width="15%" align="center">sebanyak</td>
                                                                                                        <td class="<%=style%>" width="10%" align="right">
                                                                                                            <input type="text" style="text-align:right" name ="<%=JspKasOpname.colNames[JspKasOpname.JSP_QTY] + "_" + pgIdx%>" value = "<%=kop.getQty()%>"  size="15" onChange="javascript:cmdReloadRp('<%=pgIdx%>')" >
                                                                                                        </td>
                                                                                                        <td class="<%=style%>" width="10%" align="center"><%=DbKasOpname.satQty[0]%></td>
                                                                                                        <td class="<%=style%>" width="5%" align="center"><%=curr.getCurrencyCode()%></td>                                                                                                         
                                                                                                        <td class="<%=style%>" width="20%" align="right">                                                                                                        
                                                                                                            <input type="text" style="text-align:right" name = "JSP_SUM_<%=pgIdx%>" value ="<%=JSPFormater.formatNumber(sum, "#,###.##")%>" size="20" readonly>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <%
                                                                                                                        totRp = totRp + sum;
                                                                                                                        pgIdx++;
                                                                                                                        listKasOpnameRupiah.remove(ik);
                                                                                                                        break;
                                                                                                                    }
                                                                                                                }
                                                                                                            }
                                                                                                        }


                                                                                                        if (listKasOpnameRupiah != null && listKasOpnameRupiah.size() > 0) {

                                                                                                            for (int iko = 0; iko < listKasOpnameRupiah.size(); iko++) {
                                                                                                                KasOpname kop = (KasOpname) listKasOpnameRupiah.get(iko);
                                                                                                                Currency curr = new Currency();
                                                                                                                try {
                                                                                                                    curr = DbCurrency.fetchExc(kop.getCurrencyId());
                                                                                                                } catch (Exception e) { System.out.println("[exception] " + e.toString());}

                                                                                                                if (pgIdx % 2 == 0) { style = "tablecell1"; } else {
                                                                                                                    style = "tablecell";
                                                                                                                }

                                                                                                                double sum = 0;

                                                                                                                try {
                                                                                                                    sum = kop.getAmount() * kop.getQty();
                                                                                                                } catch (Exception e) { System.out.println("[exception] " + e.toString()); }


                                                                                                    %>
                                                                                                    <input type="hidden" name = "<%=JspKasOpname.colNames[JspKasOpname.JSP_KAS_OPNAME_ID] + "_" + pgIdx%>" value = "<%=kop.getOID()%>">
                                                                                                    <input type="hidden" name = "<%=JspKasOpname.colNames[JspKasOpname.JSP_CURRENCY_ID] + "_" + pgIdx%>" value = "<%=kop.getCurrencyId()%>">
                                                                                                    <input type="hidden" name = "<%=JspKasOpname.colNames[JspKasOpname.JSP_TYPE] + "_" + pgIdx%>" value = "<%=DbKasOpname.TYPE_NON_CHECK%>">
                                                                                                    <input type="hidden" name = "<%=JspKasOpname.colNames[JspKasOpname.JSP_MEMO] + "_" + pgIdx%>" value = "">                                                                                                    
                                                                                                    <tr>
                                                                                                        <td class="<%=style%>" width="5%" align="right"><%=pgIdx + 1%>&nbsp;&nbsp;&nbsp;</td>
                                                                                                        <td class="<%=style%>" width="15%" align="center"><%=DbKasOpname.satMoney[0]%></td>
                                                                                                        <td class="<%=style%>" width="5%" align="center"><%=DbKasOpname.satCurrency[0]%></td>
                                                                                                        <td class="<%=style%>" width="15%" align="right">
                                                                                                            <input type="text" style="text-align:right" name = "<%=JspKasOpname.colNames[JspKasOpname.JSP_AMOUNT] + "_" + pgIdx%>" value = "<%=JSPFormater.formatNumber(kop.getAmount(), "#,###")%>" size="15" onChange="javascript:cmdReloadRp('<%=pgIdx%>')">
                                                                                                        </td>
                                                                                                        <td class="<%=style%>" width="15%" align="center">sebanyak</td>
                                                                                                        <td class="<%=style%>" width="10%" align="right">
                                                                                                            <input type="text" style="text-align:right" name ="<%=JspKasOpname.colNames[JspKasOpname.JSP_QTY] + "_" + pgIdx%>" value = "<%=JSPFormater.formatNumber(kop.getQty(), "#,###")%>" size="15" onChange="javascript:cmdReloadRp('<%=pgIdx%>')">
                                                                                                        </td>
                                                                                                        <td class="<%=style%>" width="10%" align="center"><%=DbKasOpname.satQty[0]%></td>
                                                                                                        <td class="<%=style%>" width="5%" align="center"><%=curr.getCurrencyCode()%></td>                                                                                                         
                                                                                                        <td class="<%=style%>" width="20%" align="right">                                                                                                        
                                                                                                            <input type="text" style="text-align:right" name = "JSP_SUM_<%=pgIdx%>" value ="<%=JSPFormater.formatNumber(sum, "#,###.##")%>" size="20" readonly>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <%
                                                                                                                totRp = totRp + sum;
                                                                                                                pgIdx++;
                                                                                                            }
                                                                                                        }
                                                                                                    %>
                                                                                                </table>    
                                                                                            </td>
                                                                                        </tr>
                                                                                        <%}%>
                                                                                        <%
            if ((iJSPCommand == JSPCommand.ADD || iErrCode != 0) && hidden_type == 1) {

                double sumRp = objKasOpname.getAmount() * objKasOpname.getQty();
                                                                                        %>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="22" valign="middle" colspan="3"> 
                                                                                                <table width="700px" border="0" cellpadding="0" cellspacing="1">
                                                                                                    <input type="hidden" name = "<%=JspKasOpname.colNames[JspKasOpname.JSP_KAS_OPNAME_ID] + "ADD_0"%>" value = "<%=0%>">
                                                                                                    <input type="hidden" name = "<%=JspKasOpname.colNames[JspKasOpname.JSP_CURRENCY_ID] + "ADD_0"%>" value = "<%=oidCurRp%>">
                                                                                                    <input type="hidden" name = "<%=JspKasOpname.colNames[JspKasOpname.JSP_TYPE] + "ADD_0"%>" value = "<%=DbKasOpname.TYPE_NON_CHECK%>">
                                                                                                    <input type="hidden" name = "<%=JspKasOpname.colNames[JspKasOpname.JSP_MEMO] + "ADD_0"%>" value = "">                                                                                                    
                                                                                                    <tr>
                                                                                                        <td bgcolor="#EE985A" width="5%" align="right"><%=pgIdx + 1%>&nbsp;&nbsp;&nbsp;</td>
                                                                                                        <td bgcolor="#EE985A" width="15%" align="center"><%=DbKasOpname.satMoney[0]%></td>
                                                                                                        <td bgcolor="#EE985A" width="5%" align="center"><%=DbKasOpname.satCurrency[0]%></td>
                                                                                                        <td bgcolor="#EE985A" width="15%" align="right">
                                                                                                            <input type="text" style="text-align:right" name = "<%=JspKasOpname.colNames[JspKasOpname.JSP_AMOUNT] + "ADD_0"%>" value = "<%=JSPFormater.formatNumber(objKasOpname.getAmount(), "#,###")%>" size="15" onChange="javascript:cmdReloadRpAdd()">
                                                                                                            <%if (isAmount == false) {%><font color = "FF0000">required</font><%}%>
                                                                                                        </td>
                                                                                                        <td bgcolor="#EE985A" width="15%" align="center">sebanyak</td>
                                                                                                        <td bgcolor="#EE985A" width="10%" align="right">
                                                                                                            <input type="text" style="text-align:right" name ="<%=JspKasOpname.colNames[JspKasOpname.JSP_QTY] + "ADD_0"%>" value = "<%=JSPFormater.formatNumber(objKasOpname.getQty(), "#,###")%>" size="15" onChange="javascript:cmdReloadRpAdd()">
                                                                                                            <%if (isQty == false) {%><font color = "FF0000">required</font><%}%>
                                                                                                        </td>
                                                                                                        <td bgcolor="#EE985A" width="10%" align="center"><%=DbKasOpname.satQty[0]%></td>
                                                                                                        <td bgcolor="#EE985A" width="5%" align="center"><%=currRp%></td>                                                                                                         
                                                                                                        <td bgcolor="#EE985A" width="20%" align="right">                                                                                                        
                                                                                                            <input type="text" style="text-align:right" name = "JSP_SUMADD_0" value ="<%=JSPFormater.formatNumber(sumRp, "#,###.##")%>" size="20" readonly>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>   
                                                                                        </tr>    
                                                                                        <%}%>
                                                                                        <%if(iJSPCommand != JSPCommand.NONE){%>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="22" valign="middle" colspan="3"> 
                                                                                                <table width="700px" border="0" cellpadding="0" cellspacing="1">
                                                                                                    <tr>
                                                                                                        <td class="<%=style%>" colspan="8" align="right"><B>Total : </B>&nbsp;</td>
                                                                                                        <td class="<%=style%>" width="20%" align="right"><%=currRp%></td>
                                                                                                        <td class="<%=style%>" width="20%" align="right"><%=JSPFormater.formatNumber(totRp, "#,###.##")%></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>   
                                                                                        </tr>    
                                                                                        <%}%>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="6" valign="middle" colspan="3"></td>
                                                                                        </tr>
                                                                                        <%if(msgPeriod.length() <= 0){ %>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="10" valign="middle" colspan="3">
                                                                                                <%if (privAdd && iJSPCommand != JSPCommand.NONE) {%>
                                                                                                <a href="javascript:cmdAddRp()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('newrp','','../images/add2.gif',1)"><img src="../images/add.gif" name="newrp" height="22" border="0"></a> 
                                                                                                <%if(iJSPCommand == JSPCommand.ADD && hidden_type == 1){%>
                                                                                                <a href="javascript:cmdCancel()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('cancel','','../images/cancel2.gif',1)"><img src="../images/cancel.gif" name="cancel" height="22" border="0"></a> 
                                                                                                <%}%>
                                                                                                <%}%>
                                                                                            </td>
                                                                                        </tr>                    
                                                                                        <%}%>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="10" valign="middle" colspan="3">&nbsp;</td>
                                                                                        </tr>                                                                                        
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="10" valign="middle" colspan="3">&nbsp;</td>
                                                                                        </tr>
                                                                                        <%if(iJSPCommand != JSPCommand.NONE){%>
                                                                                       <tr align="left" valign="top"> 
                                                                                            <td height="22" valign="middle" colspan="3"> 
                                                                                                <table width="700px" border="0" cellpadding="0" cellspacing="1">
                                                                                                    <tr>
                                                                                                        <td class="tablehdr"><%=DbKasOpname.satCurrency[1]%></td>
                                                                                                    </tr>  
                                                                                                </table>    
                                                                                            </td>    
                                                                                        </tr>   
                                                                                        <%}%>
                                                                                        <%
            int pgD = 0;
            style = "tablecell";
            if (listKasOpnameDollar != null && listKasOpnameDollar.size() > 0) {
                                                                                        %>                                                                                        
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="22" valign="middle" colspan="3"> 
                                                                                                <table width="700px" border="0" cellpadding="0" cellspacing="1">
                                                                                                     
                                                                                                    <%
                                                                                            for (int i = 0; i < listKasOpnameDollar.size(); i++) {

                                                                                                KasOpname kasOpnameDollar = (KasOpname) listKasOpnameDollar.get(i);
                                                                                                Currency currD = new Currency();

                                                                                                try {
                                                                                                    currD = DbCurrency.fetchExc(kasOpnameDollar.getCurrencyId());
                                                                                                } catch (Exception e) { System.out.println("[exception] " + e.toString()); }

                                                                                                if (i % 2 == 0) {
                                                                                                    style = "tablecell1";
                                                                                                } else {
                                                                                                    style = "tablecell";
                                                                                                }
                                                                                                double sum = 0;

                                                                                                try {
                                                                                                    sum = kasOpnameDollar.getAmount() * kasOpnameDollar.getQty();
                                                                                                } catch (Exception e) {
                                                                                                    System.out.println("[exception] " + e.toString());
                                                                                                }

                                                                                                    %>
                                                                                                    <input type="hidden" name = "<%=JspKasOpname.colNames[JspKasOpname.JSP_KAS_OPNAME_ID] + "D_" + i%>" value = "<%=kasOpnameDollar.getOID()%>">
                                                                                                    <input type="hidden" name = "<%=JspKasOpname.colNames[JspKasOpname.JSP_CURRENCY_ID] + "D_" + i%>" value = "<%=kasOpnameDollar.getCurrencyId()%>">
                                                                                                    <input type="hidden" name = "<%=JspKasOpname.colNames[JspKasOpname.JSP_TYPE] + "D_" + i%>" value = "<%=DbKasOpname.TYPE_NON_CHECK%>">
                                                                                                    <input type="hidden" name = "<%=JspKasOpname.colNames[JspKasOpname.JSP_MEMO] + "D_" + i%>" value = "">           
                                                                                                    <tr>
                                                                                                        <td class="<%=style%>" width="5%" align="right"><%=i + 1%>&nbsp;&nbsp;&nbsp;</td>
                                                                                                        <td class="<%=style%>" width="15%" align="center"><%=DbKasOpname.satMoney[1]%></td>
                                                                                                        <td class="<%=style%>" width="5%" align="center"><%=DbKasOpname.satCurrency[1]%></td>
                                                                                                        <td class="<%=style%>" width="15%" align="right">
                                                                                                            <input type="text" style="text-align:right" name = "<%=JspKasOpname.colNames[JspKasOpname.JSP_AMOUNT] + "D_" + i%>" value = "<%=JSPFormater.formatNumber(kasOpnameDollar.getAmount(), "#,###")%>" size="15" onChange="javascript:cmdReloadD('<%=i%>')">
                                                                                                        </td>
                                                                                                        <td class="<%=style%>" width="15%" align="center">sebanyak</td>
                                                                                                        <td class="<%=style%>" width="10%" align="right">
                                                                                                            <input type="text" style="text-align:right" name = "<%=JspKasOpname.colNames[JspKasOpname.JSP_QTY] + "D_" + i%>" value = "<%=kasOpnameDollar.getQty()%>" size="15" onChange="javascript:cmdReloadD('<%=i%>')">
                                                                                                        </td>
                                                                                                        <td class="<%=style%>" width="10%" align="center"><%=DbKasOpname.satQty[1]%></td>
                                                                                                        <td class="<%=style%>" width="5%" align="center"><%=currD.getCurrencyCode()%></td>
                                                                                                        <td class="<%=style%>" width="20%" align="right">
                                                                                                            <input type="text" style="text-align:right" name = "JSP_SUMD_<%=i%>" value = "<%=JSPFormater.formatNumber(sum, "#,###.##")%>" size="20" readonly>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <%
                                                                                                    totDollar = totDollar + sum;                                                                                                    
                                                                                                    pgD++;
                                                                                            }
                                                                                                    %>
                                                                                                </table>    
                                                                                            </td>
                                                                                        </tr>
                                                                                        <%}%>      
                                                                                        <%
            if ((iJSPCommand == JSPCommand.ADD || iErrCode != 0) && hidden_type == 2) {

                double sumx = objKasOpname.getQty() * objKasOpname.getAmount();

                                                                                        %>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="22" valign="middle" colspan="3"> 
                                                                                                <table width="700px" border="0" cellpadding="0" cellspacing="1">
                                                                                                    <input type="hidden" name = "<%=JspKasOpname.colNames[JspKasOpname.JSP_KAS_OPNAME_ID] + "ADD_0"%>" value = "<%=0%>">
                                                                                                    <input type="hidden" name = "<%=JspKasOpname.colNames[JspKasOpname.JSP_CURRENCY_ID] + "ADD_0"%>" value = "<%=oidCurDollar%>">
                                                                                                    <input type="hidden" name = "<%=JspKasOpname.colNames[JspKasOpname.JSP_TYPE] + "ADD_0"%>" value = "<%=DbKasOpname.TYPE_NON_CHECK%>">
                                                                                                    <input type="hidden" name = "<%=JspKasOpname.colNames[JspKasOpname.JSP_MEMO] + "ADD_0"%>" value = "">                                                                                                    
                                                                                                    <tr>
                                                                                                        <td bgcolor="#EE985A" width="5%" align="right"><%=pgD + 1%>&nbsp;&nbsp;&nbsp;</td>
                                                                                                        <td bgcolor="#EE985A" width="15%" align="center"><%=DbKasOpname.satMoney[1]%></td>
                                                                                                        <td bgcolor="#EE985A" width="5%" align="center"><%=DbKasOpname.satCurrency[1]%></td>
                                                                                                        <td bgcolor="#EE985A" width="15%" align="right">
                                                                                                            <input type="text" style="text-align:right" name = "<%=JspKasOpname.colNames[JspKasOpname.JSP_AMOUNT] + "ADD_0"%>" value = "<%=JSPFormater.formatNumber(objKasOpname.getAmount(), "#,###")%>" size="15" onChange="javascript:cmdReloadDollarAdd()">
                                                                                                            <%if (isAmount == false) {%><font color = "FF0000">required</font><%}%>
                                                                                                        </td>
                                                                                                        <td bgcolor="#EE985A" width="15%" align="center">sebanyak</td>
                                                                                                        <td bgcolor="#EE985A" width="10%" align="right"> 
                                                                                                            <input type="text" style="text-align:right" name="<%=JspKasOpname.colNames[JspKasOpname.JSP_QTY] + "ADD_0"%>" value = "<%=objKasOpname.getQty()%>" size="15" onChange="javascript:cmdReloadDollarAddQty()">
                                                                                                            <%if (isQty == false) {%><font color = "FF0000">required</font><%}%>
                                                                                                        </td>
                                                                                                        <td bgcolor="#EE985A" width="10%" align="center"><%=DbKasOpname.satQty[1]%></td>
                                                                                                        <td bgcolor="#EE985A" width="5%" align="center"><%=currDollar%></td>                                                                                                         
                                                                                                        <td bgcolor="#EE985A" width="20%" align="right">                                                                                                        
                                                                                                            <input type="text" style="text-align:right" name = "JSP_SUMADD_0" value ="<%=JSPFormater.formatNumber(sumx, "#,###.##")%>" size="20" readonly>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                </table>    
                                                                                            </td>
                                                                                        </tr>
                                                                                        <%}%>                        
                                                                                        <% if (iJSPCommand != JSPCommand.NONE) {%>                   
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="22" valign="middle" colspan="3"> 
                                                                                                <table width="700px" border="0" cellpadding="0" cellspacing="1">                                                                                                                                                                                                   
                                                                                                    <tr>
                                                                                                        <td class="<%=style%>" align="right"><B>Total :</B>&nbsp;</td>   
                                                                                                        <td class="<%=style%>" width="20%" align="right"><%=currRp%></td>
                                                                                                        <td class="<%=style%>" width="20%" align="right"><%=JSPFormater.formatNumber(totDollar, "#,###.##")%></td>
                                                                                                    </tr>
                                                                                                </table>    
                                                                                            </td>
                                                                                        </tr>                                                                                        
                                                                                        <%}%>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="6" valign="middle" colspan="3"></td>
                                                                                        </tr>
                                                                                        <%if(msgPeriod.length() <= 0){ %>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="10" valign="middle" colspan="3">
                                                                                                <%if (privAdd && iJSPCommand != JSPCommand.NONE) {%>
                                                                                                <a href="javascript:cmdAddDollar()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('newd','','../images/add2.gif',1)"><img src="../images/add.gif" name="newd" height="22" border="0"></a> 
                                                                                                <%if(iJSPCommand == JSPCommand.ADD && hidden_type == 2){%>
                                                                                                <a href="javascript:cmdCancel()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('cancel2','','../images/cancel2.gif',1)"><img src="../images/cancel.gif" name="cancel2" height="22" border="0"></a> 
                                                                                                <%}%>
                                                                                                <%}%>
                                                                                            </td>
                                                                                        </tr> 
                                                                                        <%}%>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="10" valign="middle" colspan="3">&nbsp;</td>
                                                                                        </tr>                                                                                        
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="10" valign="middle" colspan="3">&nbsp;</td>
                                                                                        </tr>
                                                                                        <%if(iJSPCommand != JSPCommand.NONE){%>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="22" valign="middle" colspan="3"> 
                                                                                                <table width="700px" border="0" cellpadding="0" cellspacing="1">
                                                                                                    <tr>
                                                                                                        <td class="tablehdr"><%=langNav[5]%></td>
                                                                                                    </tr>  
                                                                                                </table>    
                                                                                            </td>    
                                                                                        </tr> 
                                                                                        <%}%>
                                                                                        <%
            int pgc = 0;
            if (listKasOpnameCheck != null && listKasOpnameCheck.size() > 0){
                                                                                        %>                                                                                        
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="22" valign="middle" colspan="3"> 
                                                                                                <table width="700px" border="0" cellpadding="0" cellspacing="1">
                                                                                                    <%
                                                                                            style = "tablecell";
                                                                                            for (int i = 0; i < listKasOpnameCheck.size(); i++) {

                                                                                                KasOpname kasOpnameCheck = (KasOpname) listKasOpnameCheck.get(i);
                                                                                                Currency currD = new Currency();

                                                                                                try {
                                                                                                    currD = DbCurrency.fetchExc(kasOpnameCheck.getCurrencyId());
                                                                                                } catch (Exception e) { System.out.println("[exception] " + e.toString());}

                                                                                                if (i % 2 == 0) {
                                                                                                    style = "tablecell1";
                                                                                                } else {
                                                                                                    style = "tablecell";
                                                                                                }

                                                                                                    %>
                                                                                                    <input type="hidden" name = "<%=JspKasOpname.colNames[JspKasOpname.JSP_KAS_OPNAME_ID] + "C_" + i%>" value = "<%=kasOpnameCheck.getOID()%>">
                                                                                                    <input type="hidden" name = "<%=JspKasOpname.colNames[JspKasOpname.JSP_CURRENCY_ID] + "C_" + i%>" value = "<%=kasOpnameCheck.getCurrencyId()%>">
                                                                                                    <input type="hidden" name = "<%=JspKasOpname.colNames[JspKasOpname.JSP_TYPE] + "C_" + i%>" value = "<%=DbKasOpname.TYPE_CHECK%>">
                                                                                                    <input type="hidden" name = "<%=JspKasOpname.colNames[JspKasOpname.JSP_QTY] + "C_" + i%>" value = "<%=1%>">
                                                                                                    <tr>
                                                                                                        <td class="<%=style%>" width="5%" align="right"><%=i + 1%>&nbsp;&nbsp;&nbsp;</td>
                                                                                                        <td class="<%=style%>" width="70%" align="left">&nbsp;
                                                                                                            <input type="text" style="text-align:left" name = "<%=JspKasOpname.colNames[JspKasOpname.JSP_MEMO] + "C_" + i%>" value = "<%=kasOpnameCheck.getMemo()%>" size="90">
                                                                                                        </td>
                                                                                                        <td class="<%=style%>" width="5%" align="center"><%=currD.getCurrencyCode()%></td>
                                                                                                        <td class="<%=style%>" width="20%" align="right">
                                                                                                            <input type="text" style="text-align:right" name = "<%=JspKasOpname.colNames[JspKasOpname.JSP_AMOUNT] + "C_" + i%>" value = "<%=JSPFormater.formatNumber(kasOpnameCheck.getAmount(), "#,###.##")%> " size="20" onChange="javascript:cmdReloadCheck('<%=i%>')">     
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <%
                                                                                                totCheck = totCheck + kasOpnameCheck.getAmount();    
                                                                                                pgc++;
                                                                                            }
                                                                                                    %>
                                                                                                </table>    
                                                                                            </td>
                                                                                        </tr>
                                                                                        <%}%>
                                                                                        <%
            if ((iJSPCommand == JSPCommand.ADD || iErrCode != 0) && hidden_type == 3){
                                                                                        %>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="22" valign="middle" colspan="3"> 
                                                                                                <table width="700px" border="0" cellpadding="0" cellspacing="1">
                                                                                                    <input type="hidden" name = "<%=JspKasOpname.colNames[JspKasOpname.JSP_KAS_OPNAME_ID] + "ADD_0"%>" value = "<%=0%>">
                                                                                                    <input type="hidden" name = "<%=JspKasOpname.colNames[JspKasOpname.JSP_CURRENCY_ID] + "ADD_0"%>" value = "<%=oidCurRp%>">
                                                                                                    <input type="hidden" name = "<%=JspKasOpname.colNames[JspKasOpname.JSP_TYPE] + "ADD_0"%>" value = "<%=DbKasOpname.TYPE_CHECK%>">
                                                                                                    <input type="hidden" name = "<%=JspKasOpname.colNames[JspKasOpname.JSP_QTY] + "ADD_0"%>" value = "<%=1%>">
                                                                                                    <tr>
                                                                                                        <td bgcolor="#EE985A" width="5%" align="right"><%=pgc + 1%>&nbsp;&nbsp;&nbsp;</td>
                                                                                                        <td bgcolor="#EE985A" width="70%" align="left">&nbsp;
                                                                                                            <input type="text" style="text-align:left" name = "<%=JspKasOpname.colNames[JspKasOpname.JSP_MEMO] + "ADD_0"%>" value = "<%=objKasOpname.getMemo()%>" size="90">
                                                                                                            <%if (isMemo == false) {%><font color = "FF0000">required</font><%}%>
                                                                                                        </td>
                                                                                                        <td bgcolor="#EE985A" width="5%" align="center"><%=currRp%></td>
                                                                                                        <td bgcolor="#EE985A" width="20%" align="right">
                                                                                                            <input type="text" style="text-align:right" name = "<%=JspKasOpname.colNames[JspKasOpname.JSP_AMOUNT] + "ADD_0"%>" value = "<%=JSPFormater.formatNumber(objKasOpname.getAmount(), "#,###.##")%> " size="20" >
                                                                                                            <%if (isAmount == false) {%><font color = "FF0000">required</font><%}%>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                </table>    
                                                                                            </td>
                                                                                        </tr>
                                                                                        <%}
                                                                                        double totCashRegister = 0;
                                                                                        %>
                                                                                        <%if(iJSPCommand != JSPCommand.NONE){%>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="22" valign="middle" colspan="3"> 
                                                                                                <table width="700px" border="0" cellpadding="0" cellspacing="1">
                                                                                                    <tr>
                                                                                                        <td class="<%=style%>" align="right"><B><%=langNav[6]%> : </B>&nbsp;</td>
                                                                                                        <td class="<%=style%>" width="20%" align="right"><%=JSPFormater.formatNumber(totCheck, "#,###.##")%></td>
                                                                                                    </tr>
                                                                                                </table>    
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="6" valign="middle" colspan="3"></td>
                                                                                        </tr>
                                                                                        <%if(msgPeriod.length() <= 0){ %>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="10" valign="middle" colspan="3">
                                                                                                <%if (privAdd && iJSPCommand != JSPCommand.NONE){%>
                                                                                                <a href="javascript:cmdAddCheck()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('newc','','../images/add2.gif',1)"><img src="../images/add.gif" name="newc" height="22" border="0"></a> 
                                                                                                <%if(iJSPCommand == JSPCommand.ADD && hidden_type == 3){%>
                                                                                                <a href="javascript:cmdCancel()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('cancel3','','../images/cancel2.gif',1)"><img src="../images/cancel.gif" name="cancel3" height="22" border="0"></a> 
                                                                                                <%}%>
                                                                                                <%}%>
                                                                                            </td>
                                                                                        </tr> 
                                                                                        <%}%>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td colspan="3" height="6"></td>
                                                                                        </tr>
                                                                                        <% 
                                                                                            double tot = totDollar + totRp + totCheck; 
                                                                                            double perbedaan = 0;
                                                                                        %>
                                                                                         <tr align="left" valign="top"> 
                                                                                            <td height="22" valign="middle" colspan="3"> 
                                                                                                <table width="700px" border="0" cellpadding="0" cellspacing="1">
                                                                                                    <tr>
                                                                                                        <td class="<%=style%>" align="right"><B><%=langNav[7]%> : </B>&nbsp;</td>
                                                                                                        <td class="<%=style%>" width="20%" align="right"><%=currRp%></td>
                                                                                                        <td class="<%=style%>" width="20%" align="right"><%=JSPFormater.formatNumber(tot, "#,###.##")%></td>
                                                                                                    </tr>
                                                                                                </table>    
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td colspan="3" height="6"></td>
                                                                                        </tr>
                                                                                        <%  
                                                                                        
                                                                                        
                                                                                        try{
                                                                                            totCashRegister = SessCashTransaction.getTotalCashRegister(dtKas, sysLocation.getOID());
                                                                                        }catch(Exception e){}
                                                                                        perbedaan = tot - totCashRegister;
                                                                                        %>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="22" valign="middle" colspan="3"> 
                                                                                                <table width="700px" border="0" cellpadding="0" cellspacing="1">
                                                                                                    <tr>
                                                                                                        <td class="<%=style%>" align="right"><B><%=langNav[8]%> : </B>&nbsp;</td>
                                                                                                        <td class="<%=style%>" width="20%" align="right"><%=currRp%></td>
                                                                                                        <td class="<%=style%>" width="20%" align="right"><%=JSPFormater.formatNumber(totCashRegister, "#,###.##")%></td>
                                                                                                    </tr>
                                                                                                    <tr>
                                                                                                        <td height="5"></td>
                                                                                                    </tr>
                                                                                                    <tr>
                                                                                                        <td class="<%=style%>" align="right"><B><%=langNav[9]%> : </B>&nbsp;</td>
                                                                                                        <td class="<%=style%>" width="20%" align="right"><%=currRp%></td>
                                                                                                        <td class="<%=style%>" width="20%" align="right"><%=JSPFormater.formatNumber(perbedaan, "#,###.##")%></td>
                                                                                                    </tr>
                                                                                                </table>    
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td colspan="3" height="6"></td>
                                                                                        </tr>
                                                                                        <%  
                                                                                        }
                                                                                        %>
                                                                                    </table>
                                                                                </td>
                                                                            </tr>  
                                                                            <%if (iJSPCommand == JSPCommand.SEARCH || iJSPCommand == JSPCommand.SAVE || iJSPCommand == JSPCommand.SUBMIT || iJSPCommand == JSPCommand.ADD || iJSPCommand == JSPCommand.CANCEL) {%>
                                                                            <tr align="left" valign="top"> 
                                                                                <td colspan="3" height="6" ></td> 
                                                                            </tr>    
                                                                            <tr align="left" valign="top"> 
                                                                                <td colspan="3">
                                                                                    <table width="98%" border="0" cellspacing="0" cellpadding="0">
                                                                                        <tr> 
                                                                                            <td height="2" background="../images/line.gif" ><img src="../images/line.gif"></td>
                                                                                        </tr>
                                                                                    </table> 
                                                                                </td>
                                                                            </tr>
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="8" valign="middle" width="17%">&nbsp;</td>
                                                                            </tr>
                                                                            <%if (privAdd) {%>
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="8" valign="middle" width="17%">                                                                                    
                                                                                    <a href="javascript:cmdSubmit()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new21','','../images/save2.gif',1)"><img src="../images/save.gif" name="new21" height="22" border="0"></a>                                                                                    
                                                                                </td>
                                                                            </tr>                                                                            
                                                                            <%}%>
                                                                            <%if((result != null && result.size() > 0 ) || (listKasOpnameDollar != null && listKasOpnameDollar.size() > 0 ) || (listKasOpnameCheck != null && listKasOpnameCheck.size() > 0)){%>
                                                                            <%if(msgPeriod.length() <= 0){ %>
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="8" valign="middle" width="17%"></td>
                                                                            </tr>
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="8" valign="middle" width="17%"><B>Bila ingin menyimpan ke database, klik save document</B></td>
                                                                            </tr>
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="8" valign="middle" width="17%"></td>
                                                                            </tr>
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="8" valign="middle" width="17%">
                                                                                    <a href="javascript:cmdSave()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new22','','../images/savedoc2.gif',1)"><img src="../images/savedoc.gif" name="new22" height="22" border="0"></a> 
                                                                                    <%
    out.print("<a href=\"../freport/kasoppriview.jsp?DATE_KAS='" + JSPFormater.formatDate(dtKas, "yyyy-MM-dd") + "'&tot="+totCashRegister+"\" onMouseOut=\"MM_swapImgRestore()\" onMouseOver=\"MM_swapImage('prt','','../images/printdoc2.gif',1)\" onclick=\"return hs.htmlExpand(this,{objectType: 'ajax'})\"><img src=\"../images/printdoc.gif\" name=\"prt\" height=\"22\" border=\"0\"></a></div>");
                                                                                                %>
                                                                                    </td>
                                                                            </tr>
                                                                            <%}%>
                                                                                    <%}%>
                                                                                    <%}%>
                                                                        </table>
                                                                    </td>
                                                                </tr>
                                                            </table>                                                            
                                                        </form>
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
            <%@ include file="../main/footer.jsp"%>
                            <!-- #EndEditable --> </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </body>
    <!-- #EndTemplate -->
</html>

