
<%-- 
    Document   : glkasbon
    Created on : Jul 29, 2011, 11:39:17 AM
    Author     : Roy Andika
--%>

<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.main.entity.*" %>
<%@ page import = "com.project.fms.master.*" %>
<%@ page import = "com.project.fms.transaction.*" %>
<%@ page import = "com.project.admin.*" %>
<%@ page import = "com.project.general.*" %>
<%@ page import = "com.project.general.Currency" %>
<%@ page import = "com.project.general.DbCurrency" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ include file = "../main/javainit.jsp" %>
<% int appObjCode = 1;// AppObjInfo.composeObjCode(AppObjInfo.--, AppObjInfo.--, AppObjInfo.--); %>
<%@ include file = "../main/check.jsp" %>
<%
            /* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
            boolean privAdd = true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ADD));
            boolean privUpdate = true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_UPDATE));
            boolean privDelete = true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_DELETE));
%>
<%
            boolean glPriv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MENU_GENERALLEDGER, AppMenu.M2_MENU_GENERALLEDGER_NEWGL);
%>
<!-- Jsp Block -->
<%!
    public Vector addNewDetail(Vector listGlDetail, GlDetail glDetail) {
        boolean found = false;
        if (listGlDetail != null && listGlDetail.size() > 0) {
            for (int i = 0; i < listGlDetail.size(); i++) {
                GlDetail cr = (GlDetail) listGlDetail.get(i);
                if (cr.getCoaId() == glDetail.getCoaId() && cr.getForeignCurrencyId() == glDetail.getForeignCurrencyId()) {
                    //jika coa sama dan currency sama lakukan penggabungan
                    cr.setForeignCurrencyAmount(cr.getForeignCurrencyAmount() + glDetail.getForeignCurrencyAmount());
                    if (cr.getDebet() > 0 && glDetail.getDebet() > 0) {
                        cr.setDebet(cr.getDebet() + glDetail.getDebet());
                        found = true;
                    } else {

                        if (cr.getCredit() > 0 && glDetail.getCredit() > 0) {
                            cr.setCredit(cr.getCredit() + glDetail.getCredit());
                            found = true;
                        }
                    }

                }
            }
        }

        if (!found) {
            listGlDetail.add(glDetail);
        }

        return listGlDetail;
    }

    public double getTotalDetail(Vector listx, int typex) {
        double result = 0;
        if (listx != null && listx.size() > 0) {
            for (int i = 0; i < listx.size(); i++) {
                GlDetail crd = (GlDetail) listx.get(i);
                //debet
                if (typex == 0) {
                    result = result + crd.getDebet();
                } //credit
                else {
                    result = result + crd.getCredit();
                }
            }
        }
        return result;
    }

%>

<%
            int iJSPCommand = JSPRequestValue.requestCommand(request);
            int start = JSPRequestValue.requestInt(request, "start");
            int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
            long oidGl = JSPRequestValue.requestLong(request, "hidden_gl_id");
            long oidGlDetail = JSPRequestValue.requestLong(request, "hidden_gl_detail_id");
            int recIdx = JSPRequestValue.requestInt(request, "select_idx");
            int nonAct = JSPRequestValue.requestInt(request, "set_non_act");
            long referensi_id = JSPRequestValue.requestLong(request, "hidden_referensi_id");
            String referensi_no = JSPRequestValue.requestString(request, "hidden_referensi_no");
            
            if (iJSPCommand == JSPCommand.NONE){
                session.removeValue("GL_KASBON");
                oidGl = 0;
                recIdx = -1;
            }

            /*variable declaration*/
            int recordToGet = 10;
            String msgString = "";
            int iErrCode = JSPMessage.NONE;
            String whereClause = "";
            String orderClause = "";

            boolean isLoad = false;

            
            //long tmp_pettycashPaymentId = 0;
            PettycashPayment pettycashPayment = new PettycashPayment();

            if(iJSPCommand == JSPCommand.LOAD){

                //oidGl = JSPRequestValue.requestLong(request, "gl_id");
                session.removeValue("GL_KASBON");                
                referensi_id = JSPRequestValue.requestLong(request, "referensi_id");
                referensi_no = JSPRequestValue.requestString(request, "referensi_number");

                recIdx = -1;
                isLoad = true;

            }
            
            if(referensi_id != 0){
                
                try {
                    pettycashPayment = DbPettycashPayment.fetchExc(referensi_id);
                } catch (Exception e) {
                    System.out.println("[exception] " + e.toString());
                }
                
            }

            CmdGl ctrlGl = new CmdGl(request);
            JSPLine ctrLine = new JSPLine();
            Vector listGl = new Vector(1, 1);

            /*switch statement */
            int iErrCodeMain = ctrlGl.action(iJSPCommand, oidGl);
            /* end switch*/
            JspGl jspGl = ctrlGl.getForm();

            /*count list All Gl*/
            int vectSize = DbGl.getCount(whereClause);

            Gl gl = ctrlGl.getGl();
            String msgStringMain = ctrlGl.getMessage();

            if (oidGl == 0) {
                oidGl = gl.getOID();
            }

            if (oidGl != 0) {
                gl = DbGl.fetchExc(oidGl);
            }

            if ((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV) ||
                    (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)) {
                start = ctrlGl.actionList(iJSPCommand, start, vectSize, recordToGet);
            }
            /* end switch list*/

            /* get record to display */
            listGl = DbGl.list(start, recordToGet, whereClause, orderClause);

            /*handle condition if size of record to display = 0 and start > 0 	after delete*/
            if (listGl.size() < 1 && start > 0) {
                if (vectSize - recordToGet > recordToGet) {
                    start = start - recordToGet;
                } //go to JSPCommand.PREV
                else {
                    start = 0;
                    iJSPCommand = JSPCommand.FIRST;
                    prevJSPCommand = JSPCommand.FIRST; //go to JSPCommand.FIRST
                }
                listGl = DbGl.list(start, recordToGet, whereClause, orderClause);
            }
%>
<%
  
            if (iJSPCommand == JSPCommand.NONE || iJSPCommand == JSPCommand.LOAD){
                iJSPCommand = JSPCommand.ADD;
            }

            CmdGlDetail ctrlGlDetail = new CmdGlDetail(request);

            Vector listGlDetail = new Vector(1, 1);

            Vector listPettycashPaymentDetail = new Vector();

            ExchangeRate exchangerate = new ExchangeRate();

            try {

                Vector listExchangeRate = DbExchangeRate.listAll();
                if (listExchangeRate != null && listExchangeRate.size() > 0) {
                    exchangerate = (ExchangeRate) listExchangeRate.get(0);
                }

            } catch (Exception e) {
                System.out.println("[exception] " + e.toString());
            }
            
            if (pettycashPayment.getOID() != 0){

                String whereDetail = DbPettycashPaymentDetail.colNames[DbPettycashPaymentDetail.COL_PETTYCASH_PAYMENT_ID] + "=" + pettycashPayment.getOID();
                
                listPettycashPaymentDetail = DbPettycashPaymentDetail.list(0, 0, whereDetail, null);

                for (int ix = 0; ix < listPettycashPaymentDetail.size(); ix++) {

                    PettycashPaymentDetail tmpPettycashPaymentDetail = (PettycashPaymentDetail) listPettycashPaymentDetail.get(ix);

                    GlDetail tmpGlDetail = new GlDetail();

                    tmpGlDetail.setCoaId(tmpPettycashPaymentDetail.getCoaId());
                    tmpGlDetail.setCredit(tmpPettycashPaymentDetail.getAmount());
                    tmpGlDetail.setMemo(tmpPettycashPaymentDetail.getMemo());
                    tmpGlDetail.setDepartmentId(tmpPettycashPaymentDetail.getDepartmentId());
                    tmpGlDetail.setForeignCurrencyAmount(tmpPettycashPaymentDetail.getAmount());
                    tmpGlDetail.setForeignCurrencyId(exchangerate.getCurrencyIdrId());
                    tmpGlDetail.setBookedRate(exchangerate.getValueIdr());
                    tmpGlDetail.setIsDebet(1);
                    listGlDetail.add(tmpGlDetail);

                }
            }
            
            boolean isSaveDetail = true;
            
            JspGlDetail jspGlDetail = ctrlGlDetail.getForm();
            
            if(iJSPCommand == JSPCommand.START && iErrCodeMain == 0){// jika tidak ada kesalahan pada proses penyimpanan data GL 
                
                if(listPettycashPaymentDetail != null && listPettycashPaymentDetail.size() > 0){
                    
                    Vector glDetail = new Vector();
                    
                    for(int iPt = 0; iPt < listPettycashPaymentDetail.size() ; iPt++){
                        
                        PettycashPaymentDetail objPettycashDetail = (PettycashPaymentDetail) listPettycashPaymentDetail.get(iPt);

                        GlDetail tmpGlDetail = new GlDetail();

                        tmpGlDetail.setCoaId(objPettycashDetail.getCoaId());
                        tmpGlDetail.setCredit(objPettycashDetail.getAmount());
                        tmpGlDetail.setMemo(objPettycashDetail.getMemo());
                        tmpGlDetail.setDepartmentId(objPettycashDetail.getDepartmentId());
                        tmpGlDetail.setForeignCurrencyAmount(objPettycashDetail.getAmount());
                        tmpGlDetail.setForeignCurrencyId(exchangerate.getCurrencyIdrId());
                        tmpGlDetail.setBookedRate(exchangerate.getValueIdr());
                        tmpGlDetail.setGlId(gl.getOID());
                        tmpGlDetail.setIsDebet(1);
                        long depOid = 0;
                        
                        try{
                            depOid = JSPRequestValue.requestLong(request,JspGlDetail.colNames[JspGlDetail.JSP_DEPARTMENT_ID]+"_"+iPt);
                        }catch(Exception e){}
                        
                        if(depOid == 0){ // jika departmentnya oid nya masih 0, maka tidak dapat disimpan
                            isSaveDetail = false;
                            
                            break;
                        }
                        
                        glDetail.add(tmpGlDetail);
                        
                    }
                    
                    if(isSaveDetail == true){  // jika data2 dari gl detail sudah complete dan siap di simpan
                        
                        DbGlDetail.procesInsertGlDetail(glDetail);
                        
                    }
                                       
                }
                
            }else{                
                
                /*switch statement */
               
                /* end switch*/
                
                
                if(iJSPCommand == JSPCommand.SAVE){

                    if(gl.getOID() != 0) {

                        DbGlDetail.saveAllDetail(gl, listGlDetail);
                        listGlDetail = DbGlDetail.list(0, 0, "gl_id=" + gl.getOID(), "");
                        
                        try {
                            gl = DbGl.fetchExc(gl.getOID());
                        } catch (Exception e) {
                            System.out.println("[Exception] " + e.toString());
                        }
                    }
                }
            }

            iErrCode = ctrlGlDetail.action(iJSPCommand, oidGlDetail);

            /*count list All GlDetail*/
            vectSize = DbGlDetail.getCount(whereClause);

            /*switch list GlDetail*/
            if ((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV) ||
                    (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)) {
                start = ctrlGlDetail.actionList(iJSPCommand, start, vectSize, recordToGet);
            }
            /* end switch list*/

            GlDetail glDetail = ctrlGlDetail.getGlDetail();
            msgString = ctrlGlDetail.getMessage();

            /* get record to display */

            if (session.getValue("GL_KASBON") != null) {
                listGlDetail = (Vector) session.getValue("GL_KASBON");
            }

            if (iJSPCommand == JSPCommand.SUBMIT || iJSPCommand == JSPCommand.POST) {
                if (iErrCode == 0 && iErrCodeMain == 0) {
                    if (recIdx == -1) {
                        listGlDetail.add(glDetail);
                    } else {
                        listGlDetail.set(recIdx, glDetail);
                    }
                }
            }
            
            if(iJSPCommand == JSPCommand.DELETE) {
                listGlDetail.remove(recIdx);
            }

            session.putValue("GL_KASBON", listGlDetail);

            String wherex = "(location_id=" + sysLocation.getOID() + " or location_id=0)";

            if (isPostableOnly) {
                wherex = wherex + " and status='" + I_Project.ACCOUNT_LEVEL_POSTABLE + "'";
            }

            Vector incomeCoas = DbCoa.list(0, 0, wherex, "code");

            Vector currencies = DbCurrency.list(0, 0, "", "");

            ExchangeRate eRate = DbExchangeRate.getStandardRate();

            double totalDebet = getTotalDetail(listGlDetail, 0);
            double totalCredit = getTotalDetail(listGlDetail, 1);

            double balance = totalDebet - totalCredit;
            
            if (JSPFormater.formatNumber(totalDebet, "#,###.##").equals(JSPFormater.formatNumber(totalCredit, "#,###.##"))) {
                balance = 0;
            }

            if (iJSPCommand == JSPCommand.SUBMIT && iErrCode == 0 && iErrCodeMain == 0) {
                iJSPCommand = JSPCommand.ADD;
                glDetail = new GlDetail();
                recIdx = -1;
            }
            
            String whereDep = "";

            Vector deps = DbDepartment.list(0, 0, whereDep, "code");

            boolean diffCoaClass = false;

            /*** LANG ***/
            String[] langGL = {"Journal Number", "Transaction Date", "Reference Number", "Journal Detail", //0-3
                "Account - Description", "Department", "Currency", "Code", "Amount", "Booked Rate", "Debet", "Credit", "Description", //4-12
                "Error, can't posting journal when details mixed between SP and NSP", "Journal has been saved successfully.", "Search Advance", "Advance Number"};//

            String[] langNav = {"General Journal", "Advance Journal", "Date"};

            if (lang == LANG_ID) {
                String[] langID = {"Nomor Jurnal", "Tanggal Transaksi", "Nomor Referensi", "Detail Jurnal", //0-3
                    "Perkiraan", "Departemen", "Mata Uang", "Kode", "Jumlah", "Kurs Transaksi", "Debet", "Credit", "Keterangan", //4-12
                    "Error, tidak bisa posting journal dengan detail gabungan SP dan NSP.", "Jurnal berhasil disimpan.", "Cari Kasbon", "Nomor Kasbon"};//13 - 16

                langGL = langID;

                String[] navID = {"Jurnal Umum", "Jurnal Kasbon", "Tanggal"};
                langNav = navID;
            }
            
            int colspan = 6;
%>
<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
<head>
    <!-- #BeginEditable "javascript" --> 
    <title><%=systemTitle%></title>
    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
    <link href="../css/default.css" rel="stylesheet" type="text/css" />
    <link href="../css/css.css" rel="stylesheet" type="text/css" />
    <script language="JavaScript">        
        <%if (!glPriv) {%>
        window.location="<%=approot%>/nopriv.jsp";
        <%}%>s
        
        function cmdDepartment(){
            var oid = document.frmgl.<%=JspGlDetail.colNames[JspGlDetail.JSP_DEPARTMENT_ID]%>.value;
         <%if (deps != null && deps.size() > 0) {
                for (int i = 0; i < deps.size(); i++) {
                    Department d = (Department) deps.get(i);
         %>
             if(oid=='<%=d.getOID()%>'){
                                 <%if (d.getType().equals(I_Project.ACCOUNT_LEVEL_HEADER)) {
                        Department d0 = (Department) deps.get(0);
                                 %>
                                     alert("Non postable department\nplease select another department");
                                     document.frmgl.<%=JspGlDetail.colNames[JspGlDetail.JSP_DEPARTMENT_ID]%>.value="<%=d0.getOID()%>";
                                     <%}%>
                                 }
         <%}
            }%>
        }
        
        function cmdPrintJournal(){	 
            window.open("<%=printroot%>.report.RptGLPDF?oid=<%=appSessUser.getLoginId()%>&gl_id=<%=gl.getOID()%>");
            }
            
            function cmdClickMe(){
                var x = document.frmgl.<%=JspGlDetail.colNames[JspGlDetail.JSP_FOREIGN_CURRENCY_AMOUNT]%>.value;	
                document.frmgl.<%=JspGlDetail.colNames[JspGlDetail.JSP_FOREIGN_CURRENCY_AMOUNT]%>.select();
            }
            
            function cmdFixing(){	
                document.frmgl.command.value="<%=JSPCommand.POST%>";
                document.frmgl.action="glkasbon.jsp";
                document.frmgl.submit();	
            }
            
            function cmdNewJournal(){	
                document.frmgl.command.value="<%=JSPCommand.NONE%>";
                document.frmgl.action="glkasbon.jsp";
                document.frmgl.submit();	
            }
            
            var sysDecSymbol = "<%=sSystemDecimalSymbol%>";
            var usrDigitGroup = "<%=sUserDigitGroup%>";
            var usrDecSymbol = "<%=sUserDecimalSymbol%>";
            
            function removeChar(number){
                
                var ix;
                var result = "";
                for(ix=0; ix<number.length; ix++){
                    var xx = number.charAt(ix);
                    //alert(xx);
                    if(!isNaN(xx)){
                        result = result + xx;
                    }
                    else{
                        if(xx==',' || xx=='.'){
                            result = result + xx;
                        }
                    }
                }
                
                return result;
            }
            
            function checkNumber(){
                var st = document.frmgl.<%=JspGlDetail.colNames[JspGlDetail.JSP_DEBET]%>.value;		
                
                result = removeChar(st);
                
                result = cleanNumberFloat(result, sysDecSymbol, usrDigitGroup, usrDecSymbol);
                document.frmgl.<%=JspGlDetail.colNames[JspGlDetail.JSP_DEBET]%>.value = formatFloat(result, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 
            }
            
            function checkNumber2(){
                
                var main = document.frmgl.<%=jspGlDetail.colNames[jspGlDetail.JSP_DEBET]%>.value;		
                main = cleanNumberFloat(main, sysDecSymbol, usrDigitGroup, usrDecSymbol);
                var currTotal = document.frmgl.total_detail.value;
                currTotal = cleanNumberFloat(currTotal, sysDecSymbol, usrDigitGroup, usrDecSymbol);				
                var idx = document.frmgl.select_idx.value;		
                var booked = document.frmgl.<%=jspGlDetail.colNames[jspGlDetail.JSP_BOOKED_RATE]%>.value;		
                booked = cleanNumberFloat(booked, sysDecSymbol, usrDigitGroup, usrDecSymbol);
                
                var st = document.frmgl.<%=jspGlDetail.colNames[jspGlDetail.JSP_DEBET]%>.value;		
                result = removeChar(st);	
                result = cleanNumberFloat(result, sysDecSymbol, usrDigitGroup, usrDecSymbol);
                var result2 = 0;
                
                //add
                if(parseFloat(idx)<0){
                    
                    var amount = parseFloat(currTotal) + parseFloat(result);
                    document.frmgl.<%=jspGlDetail.colNames[jspGlDetail.JSP_DEBET]%>.value=formatFloat(amount, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 
                    
                    /*alert("amount : "+amount+", main : "+main+", idx  xxx ");
                    
                    if(amount>parseFloat(main)){
                        alert("Amount over the maximum allowed, \nsystem will reset the data");
                        result = parseFloat(main)-parseFloat(currTotal);
                        result2 = result/parseFloat(booked);			
                        document.frmgl.<%=jspGlDetail.colNames[jspGlDetail.JSP_FOREIGN_CURRENCY_AMOUNT]%>.value = formatFloat(result2, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 
                        result2 = document.frmgl.<%=jspGlDetail.colNames[jspGlDetail.JSP_FOREIGN_CURRENCY_AMOUNT]%>.value;
                        result2 = cleanNumberFloat(result2, sysDecSymbol, usrDigitGroup, usrDecSymbol);
                        
                        alert("result2 : "+result2);
                        
                        document.frmgl.<%=jspGlDetail.colNames[jspGlDetail.JSP_DEBET]%>.value = formatFloat(parseFloat(result2) * parseFloat(booked), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 
                    }*/
                }
                //edit
                else{
                    var editAmount =  document.frmgl.edit_amount.value;
                    var amount = parseFloat(currTotal) - parseFloat(editAmount) + parseFloat(result);
                    document.frmgl.<%=jspGlDetail.colNames[jspGlDetail.JSP_DEBET]%>.value=formatFloat(amount, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 
                    
                    /*if(amount>parseFloat(main)){
                        alert("Amount over the maximum allowed, \nsystem will reset the data");
                        result = parseFloat(main)-(parseFloat(currTotal)-parseFloat(editAmount));
                        result2 = result/parseFloat(booked);
                        document.frmgl.<%=jspGlDetail.colNames[jspGlDetail.JSP_FOREIGN_CURRENCY_AMOUNT]%>.value = formatFloat(result2, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 
                        result2 = document.frmgl.<%=jspGlDetail.colNames[jspGlDetail.JSP_FOREIGN_CURRENCY_AMOUNT]%>.value;
                        result2 = cleanNumberFloat(result2, sysDecSymbol, usrDigitGroup, usrDecSymbol);
                        alert("result2 : "+result2);
                        document.frmgl.<%=jspGlDetail.colNames[jspGlDetail.JSP_DEBET]%>.value = formatFloat(parseFloat(result2) * parseFloat(booked), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 
                    }*/
                }
                
                
            }
            
            function updateDebetCredit(){
                var dbt = document.frmgl.<%=JspGlDetail.colNames[JspGlDetail.JSP_IS_DEBET]%>.value;
                var amount = document.frmgl.<%=JspGlDetail.colNames[JspGlDetail.JSP_FOREIGN_CURRENCY_AMOUNT]%>.value;
                var erate = document.frmgl.<%=JspGlDetail.colNames[JspGlDetail.JSP_BOOKED_RATE]%>.value;
                amount = removeChar(amount);
                amount = cleanNumberFloat(amount, sysDecSymbol, usrDigitGroup, usrDecSymbol);
                erate = removeChar(erate);
                erate = cleanNumberFloat(erate, sysDecSymbol, usrDigitGroup, usrDecSymbol);
                //alert(dbt+", amount : "+amount+", erate : "+erate);
                //debet
                if(parseInt(dbt)==0){
                    document.frmgl.<%=jspGlDetail.colNames[jspGlDetail.JSP_DEBET]%>.value = formatFloat(parseFloat(amount) * parseFloat(erate), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 
                    document.frmgl.<%=jspGlDetail.colNames[jspGlDetail.JSP_CREDIT]%>.value = "0";
                }
                //credit
                else{
                    document.frmgl.<%=jspGlDetail.colNames[jspGlDetail.JSP_CREDIT]%>.value = formatFloat(parseFloat(amount) * parseFloat(erate), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 
                    document.frmgl.<%=jspGlDetail.colNames[jspGlDetail.JSP_DEBET]%>.value = "0";
                }
            }
            
            function cmdUpdateExchange(){
                
                <%if (iJSPCommand != JSPCommand.BACK && !((iJSPCommand == JSPCommand.SUBMIT || iJSPCommand == JSPCommand.SAVE) && iErrCode == 0)) {%>	
                
                var isDebet = 0;
                
                isDebet = document.frmgl.<%=JspGlDetail.colNames[JspGlDetail.JSP_IS_DEBET]%>.value; 
                
                var idCurr = document.frmgl.<%=JspGlDetail.colNames[JspGlDetail.JSP_FOREIGN_CURRENCY_ID]%>.value;
                
                 <%if (currencies != null && currencies.size() > 0) {
        for (int i = 0; i < currencies.size(); i++){
            Currency cx = (Currency) currencies.get(i);
                 %>
                     if(idCurr=='<%=cx.getOID()%>'){
                         <%if (cx.getCurrencyCode().equals(IDRCODE)) {%>
                         document.frmgl.<%=JspGlDetail.colNames[JspGlDetail.JSP_BOOKED_RATE]%>.value="<%=eRate.getValueIdr()%>";
                         <%} else if (cx.getCurrencyCode().equals(USDCODE)) {%>
                         document.frmgl.<%=JspGlDetail.colNames[JspGlDetail.JSP_BOOKED_RATE]%>.value = formatFloat(<%=eRate.getValueUsd()%>, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); //"<%=eRate.getValueUsd()%>";
                         <%} else if (cx.getCurrencyCode().equals(EURCODE)) {%>
                         document.frmgl.<%=JspGlDetail.colNames[JspGlDetail.JSP_BOOKED_RATE]%>.value= formatFloat(<%=eRate.getValueEuro()%>, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); //"<%=eRate.getValueEuro()%>";
                         <%}%>
                     }	
                 <%}
    }%>
    
    var famount = document.frmgl.<%=JspGlDetail.colNames[JspGlDetail.JSP_FOREIGN_CURRENCY_AMOUNT]%>.value;
    
    famount = removeChar(famount);
    famount = cleanNumberFloat(famount, sysDecSymbol, usrDigitGroup, usrDecSymbol);
    
    //alert(famount);
    
    var fbooked = document.frmgl.<%=JspGlDetail.colNames[JspGlDetail.JSP_BOOKED_RATE]%>.value;
    fbooked = cleanNumberFloat(fbooked, sysDecSymbol, usrDigitGroup, usrDecSymbol);
    
    //alert(fbooked);
    
    if(!isNaN(famount)){
        if(parseInt(isDebet)==0){
            alert('atas');
            var defaultDebet = document.frmgl.<%=JspGlDetail.colNames[JspGlDetail.JSP_DEBET]%>.value;
            defaultDebet = cleanNumberFloat(defaultDebet, sysDecSymbol, usrDigitGroup, usrDecSymbol);
            alert('defaultDebet : '+defaultDebet);
            document.frmgl.<%=JspGlDetail.colNames[JspGlDetail.JSP_DEBET]%>.value= formatFloat(parseFloat(famount) * parseFloat(fbooked), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); //;
            
            var credit = document.frmgl.<%=JspGlDetail.colNames[JspGlDetail.JSP_CREDIT]%>.value;
            credit = cleanNumberFloat(credit, sysDecSymbol, usrDigitGroup, usrDecSymbol);
            var totalCredit = document.frmgl.total_credit.value;
            totalCredit = cleanNumberFloat(totalCredit, sysDecSymbol, usrDigitGroup, usrDecSymbol);
            document.frmgl.total_credit.value= formatFloat(parseFloat(totalCredit) - parseFloat(credit), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); //;		
            
            var debet = document.frmgl.<%=JspGlDetail.colNames[JspGlDetail.JSP_DEBET]%>.value;
            alert('debet : '+debet);
            debet = cleanNumberFloat(debet, sysDecSymbol, usrDigitGroup, usrDecSymbol);
            alert('debetClean : '+debet);
            var totalDebet = document.frmgl.total_debet.value;
            totalDebet = cleanNumberFloat(totalDebet, sysDecSymbol, usrDigitGroup, usrDecSymbol);
            document.frmgl.total_debet.value= formatFloat(parseFloat(totalDebet) - parseFloat(defaultDebet) + parseFloat(debet), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); //;		
            
            document.frmgl.<%=JspGlDetail.colNames[JspGlDetail.JSP_CREDIT]%>.value= "0.00";//formatFloat(parseFloat(famount) * parseFloat(fbooked), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); //;
        }
        else{			
            alert('bawah');
            var defaultCredit = document.frmgl.<%=JspGlDetail.colNames[JspGlDetail.JSP_CREDIT]%>.value;
            defaultCredit = cleanNumberFloat(defaultCredit, sysDecSymbol, usrDigitGroup, usrDecSymbol);
            
            document.frmgl.<%=JspGlDetail.colNames[JspGlDetail.JSP_CREDIT]%>.value= formatFloat(parseFloat(famount) * parseFloat(fbooked), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); //;
            
            var debet = document.frmgl.<%=JspGlDetail.colNames[JspGlDetail.JSP_DEBET]%>.value;
            debet = cleanNumberFloat(debet, sysDecSymbol, usrDigitGroup, usrDecSymbol);
            var totalDebet = document.frmgl.total_debet.value;
            totalDebet = cleanNumberFloat(totalDebet, sysDecSymbol, usrDigitGroup, usrDecSymbol);
            document.frmgl.total_debet.value= formatFloat(parseFloat(totalDebet) - parseFloat(debet), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); //;		
            
            var credit = document.frmgl.<%=JspGlDetail.colNames[JspGlDetail.JSP_CREDIT]%>.value;
            credit = cleanNumberFloat(credit, sysDecSymbol, usrDigitGroup, usrDecSymbol);
            var totalCredit = document.frmgl.total_credit.value;
            totalCredit = cleanNumberFloat(totalCredit, sysDecSymbol, usrDigitGroup, usrDecSymbol);
            document.frmgl.total_credit.value= formatFloat(parseFloat(totalCredit) -parseFloat(defaultCredit) + parseFloat(credit), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); //;		
            
            document.frmgl.<%=JspGlDetail.colNames[JspGlDetail.JSP_DEBET]%>.value= "0.00";//formatFloat(parseFloat(famount) * parseFloat(fbooked), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); //;
        }
        document.frmgl.<%=JspGlDetail.colNames[JspGlDetail.JSP_FOREIGN_CURRENCY_AMOUNT]%>.value= formatFloat(famount, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);
        //alert('!isNaN');		
    }
    <%}%>	
    
    var totalDebetx = document.frmgl.total_debet.value;
    totalDebetx = cleanNumberFloat(totalDebetx, sysDecSymbol, usrDigitGroup, usrDecSymbol);
    var totalCreditx = document.frmgl.total_credit.value;
    totalCreditx = cleanNumberFloat(totalCreditx, sysDecSymbol, usrDigitGroup, usrDecSymbol);
    if(parseFloat(totalDebetx)==parseFloat(totalCreditx)){
        document.all.tot_balance.innerHTML = "-";//formatFloat(parseFloat(totalDebetx)-parseFloat(totalCreditx), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);
    }
    else{	
        document.all.tot_balance.innerHTML = formatFloat(parseFloat(totalDebetx)-parseFloat(totalCreditx), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);
    }
    
    //checkNumber2();
}

function cmdActivity(oid){
    <%if (oidGl != 0) {%>
    document.frmgl.hidden_gl_id.value=oid;
    document.frmgl.command.value="<%=JSPCommand.NONE%>";
    document.frmgl.prev_command.value="<%=prevJSPCommand%>";
    document.frmgl.action="glactivity.jsp";
    document.frmgl.submit();
    <%} else {%>
    alert('Please finish and post this journal before continue to activity data.');
    <%}%>
    
}

function cmdSearchJurnal(){
    window.open("<%=approot%>/transaction/s_glkasbon.jsp?formName=frmgl&txt_Id=referensi_id&txt_Name=referensi_number", null, "height=400,width=600, status=yes,toolbar=no,menubar=no,location=no, scrollbars=yes");
    }    
    
    function cmdAdd(){	
        document.frmgl.select_idx.value="-1";
        document.frmgl.hidden_gl_id.value="0";
        document.frmgl.hidden_gl_detail_id.value="0";
        document.frmgl.command.value="<%=JSPCommand.ADD%>";
        document.frmgl.prev_command.value="<%=prevJSPCommand%>";
        document.frmgl.action="glkasbon.jsp";
        document.frmgl.submit();
    }
    
    function cmdNone(){	
        document.frmgl.hidden_gl_id.value="0";
        document.frmgl.hidden_gl_detail_id.value="0";
        document.frmgl.command.value="<%=JSPCommand.NONE%>";
        document.frmgl.action="glkasbon.jsp";
        document.frmgl.submit();
    }
    
    
    function cmdAsk(oidGlDetail){
        document.frmgl.select_idx.value=oidGlDetail;
        document.frmgl.hidden_gl_detail_id.value=oidGlDetail;
        document.frmgl.command.value="<%=JSPCommand.ASK%>";
        document.frmgl.prev_command.value="<%=prevJSPCommand%>";
        document.frmgl.action="glkasbon.jsp";
        document.frmgl.submit();
    }
    
    function cmdConfirmDelete(oidGlDetail){
        document.frmgl.hidden_gl_detail_id.value=oidGlDetail;
        document.frmgl.command.value="<%=JSPCommand.DELETE%>";
        document.frmgl.prev_command.value="<%=prevJSPCommand%>";
        document.frmgl.action="glkasbon.jsp";
        document.frmgl.submit();
    }
    
    function cmdSave(){
        document.frmgl.command.value="<%=JSPCommand.SAVE%>";
        document.frmgl.prev_command.value="<%=prevJSPCommand%>";
        document.frmgl.action="glkasbon.jsp";
        document.frmgl.submit();
    }
    
    function cmdProcesFirst(){
        document.frmgl.command.value="<%=JSPCommand.START%>";
        document.frmgl.prev_command.value="<%=prevJSPCommand%>";
        document.frmgl.action="glkasbon.jsp";
        document.frmgl.submit();
    }
    
    
    function cmdSubmitCommand(){
        document.frmgl.command.value="<%=JSPCommand.SAVE%>";
        document.frmgl.prev_command.value="<%=prevJSPCommand%>";
        document.frmgl.action="glkasbon.jsp";
        document.frmgl.submit();
    }
    
    function cmdEdit(oidGlDetail){
        document.frmgl.select_idx.value=oidGlDetail;
        document.frmgl.hidden_gl_detail_id.value=oidGlDetail;
        document.frmgl.command.value="<%=JSPCommand.EDIT%>";
        document.frmgl.prev_command.value="<%=prevJSPCommand%>";
        document.frmgl.action="glkasbon.jsp";
        document.frmgl.submit();
    }
    
    function cmdCancel(oidGlDetail){
        document.frmgl.hidden_gl_detail_id.value=oidGlDetail;
        document.frmgl.command.value="<%=JSPCommand.EDIT%>";
        document.frmgl.prev_command.value="<%=prevJSPCommand%>";
        document.frmgl.action="glkasbon.jsp";
        document.frmgl.submit();
    }
    
    function cmdBack(){
        document.frmgl.command.value="<%=JSPCommand.BACK%>";
        document.frmgl.action="glkasbon.jsp";
        document.frmgl.submit();
    }
    
    function cmdListFirst(){
        document.frmgl.command.value="<%=JSPCommand.FIRST%>";
        document.frmgl.prev_command.value="<%=JSPCommand.FIRST%>";
        document.frmgl.action="glkasbon.jsp";
        document.frmgl.submit();
    }
    
    function cmdListPrev(){
        document.frmgl.command.value="<%=JSPCommand.PREV%>";
        document.frmgl.prev_command.value="<%=JSPCommand.PREV%>";
        document.frmgl.action="glkasbon.jsp";
        document.frmgl.submit();
    }
    
    function cmdListNext(){
        document.frmgl.command.value="<%=JSPCommand.NEXT%>";
        document.frmgl.prev_command.value="<%=JSPCommand.NEXT%>";
        document.frmgl.action="glkasbon.jsp";
        document.frmgl.submit();
    }
    
    function cmdListLast(){
        document.frmgl.command.value="<%=JSPCommand.LAST%>";
        document.frmgl.prev_command.value="<%=JSPCommand.LAST%>";
        document.frmgl.action="glkasbon.jsp";
        document.frmgl.submit();
    }
    
    //-------------- script form image -------------------
    
    function cmdDelPict(oidGlDetail){
        document.frmimage.hidden_gl_detail_id.value=oidGlDetail;
        document.frmimage.command.value="<%=JSPCommand.POST%>";
        document.frmimage.action="glkasbon.jsp";
        document.frmimage.submit();
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
<body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','../images/new2.gif','../images/post_journal2.gif','../images/print2.gif')">
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
            <td width="165" height="100%" valign="top" style="background:url(<%=approot%>/images/leftmenu-bg.gif) repeat-y"> 
                <!-- #BeginEditable "menu" --> 
                  <%@ include file="../main/menu.jsp"%>
                  <%@ include file="../calendar/calendarframe.jsp"%>
                <!-- #EndEditable -->
            </td>
            <td width="100%" valign="top"> 
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr> 
                    <td class="title"><!-- #BeginEditable "title" -->
                                           <%
            String navigator = "<font class=\"lvl1\">" + langNav[0] + "</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">" + langNav[1] + "</span></font>";
                                           %>
                                           <%@ include file="../main/navigator.jsp"%>
                    <!-- #EndEditable --></td>
                </tr>
                <!--tr> 
                      <td><img src="<%=approot%>/images/title-sp.gif" width="584" height="1"></td> 
                </tr-->
                <tr> 
                <td><!-- #BeginEditable "content" --> 
                    <form name="frmgl" method ="post" action="">
                    <input type="hidden" name="command" value="<%=iJSPCommand%>">
                    <input type="hidden" name="vectSize" value="<%=vectSize%>">
                    <input type="hidden" name="start" value="<%=start%>">
                    <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                    <input type="hidden" name="hidden_gl_detail_id" value="<%=oidGlDetail%>">
                    <input type="hidden" name="hidden_referensi_id" value="<%=referensi_id%>">
                    <input type="hidden" name="hidden_referensi_no" value="<%=referensi_no%>">
                    <input type="hidden" name="hidden_gl_id" value="<%=oidGl%>">
                    <input type="hidden" name="<%=JspGl.colNames[JspGl.JSP_OPERATOR_ID]%>" value="<%=appSessUser.getUserOID()%>">
                    <input type="hidden" name="select_idx" value="<%=recIdx%>">
                    <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                    <input type="hidden" name="<%=JspGl.colNames[JspGl.JSP_JOURNAL_TYPE]%>" value="<%=I_Project.JOURNAL_TYPE_GENERAL_LEDGER%>">
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr align="left" valign="top"> 
                        <td height="8"  colspan="3" class="container"> 
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr align="left" valign="top"> 
                                <td height="8" valign="top" colspan="3"> 
                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                        <tr> 
                                            <td colspan="4"> 
                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                    <tr> 
                                                        <td width="31%">&nbsp;</td>
                                                        <td width="32%">&nbsp;</td>
                                                        <td width="37%"> 
                                                            <div align="right"><%=langNav[2]%> : <%=JSPFormater.formatDate(new Date(), "dd MMMM yyyy")%>&nbsp;, &nbsp;Operator 
                                                            : <%=appSessUser.getLoginId()%>&nbsp;&nbsp;<%= jspGl.getErrorMsg(JspGl.JSP_OPERATOR_ID) %>&nbsp;</div>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                        <tr> 
                                            <td colspan="4" valign="top"> 
                                                <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                    <tr> 
                                                        <td width="10%">&nbsp;</td>
                                                        <td width="3%">&nbsp;</td>
                                                        <td width="23%">&nbsp;</td>
                                                        <td width="9%">&nbsp;</td>
                                                        <td width="55%">&nbsp;</td>
                                                    </tr>  
                                                    <tr> 
                                                        <td width="10%"><%=langGL[15]%></td>
                                                        <td width="3%">&nbsp;</td>
                                                        <td width="23%">
                                                            <%
            String ref_number = "";
            long ref_id = 0;

            if (isLoad) {
                ref_number = referensi_no;
                ref_id = referensi_id;
            }
                                                            %>  
                                                            <input size="25" readonly type="text" name="referensi_number" value="<%=ref_number%>">
                                                            <input type="hidden" name="referensi_id" value="<%=ref_id%>">                                                                    
                                                            <a href="javascript:cmdSearchJurnal()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new21','','../images/search.jpg',1)"><img src="../images/search2.jpg" name="new211" height="17" border="0" style="padding:0px"></a>                                                                
                                                        </td>
                                                        <td width="9%">&nbsp;</td>
                                                        <td width="55%">&nbsp;</td>
                                                    </tr>
                                                    <tr> 
                                                        <td colspan = "5">&nbsp;</td>
                                                    </tr>
                                                    <tr> 
                                                        <td colspan="5" width="100%"> 
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr> 
                                                                    <td height="2">&nbsp;</td>
                                                                </tr>
                                                                <tr> 
                                                                    <td height="2" background="../images/line.gif" ><img src="../images/line.gif"></td>
                                                                </tr>
                                                            </table>
                                                        </td>
                                                    </tr>
                                                    <tr> 
                                                        <td width="10%">&nbsp;</td>
                                                        <td width="3%">&nbsp;</td>
                                                        <td width="23%">&nbsp;</td>
                                                        <td width="9%">&nbsp;</td>
                                                        <td width="55%">&nbsp;</td>
                                                    </tr>
                                                    <tr> 
                                                        <td width="10%"><%=langGL[0]%></td>
                                                        <td width="3%">&nbsp;</td>
                                                        <td width="23%">                                                                
                                                            <%
            int counter = DbGl.getNextCounter();
            String strNumber = DbGl.getNextNumber(counter);

            if (gl.getOID() != 0) {
                strNumber = gl.getJournalNumber();
            }

                                                            %>
                                                            <%=strNumber%> 
                                                            <input type="hidden" name="<%=JspGl.colNames[JspGl.JSP_JOURNAL_NUMBER]%>">
                                                            <input type="hidden" name="<%=JspGl.colNames[JspGl.JSP_JOURNAL_COUNTER]%>">
                                                            <input type="hidden" name="<%=JspGl.colNames[JspGl.JSP_JOURNAL_PREFIX]%>">
                                                        </td>
                                                        <td width="9%"><%=langGL[1]%></td>
                                                        <td width="55%"> 
                                                            <input name="<%=JspGl.colNames[JspGl.JSP_TRANS_DATE] %>" value="<%=JSPFormater.formatDate((gl.getTransDate() == null) ? new Date() : gl.getTransDate(), "dd/MM/yyyy")%>" size="11">
                                                            <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmgl.<%=JspGl.colNames[JspGl.JSP_TRANS_DATE] %>);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> 
                                                        <%= jspGl.getErrorMsg(jspGl.JSP_TRANS_DATE) %> </td>
                                                    </tr>
                                                    <tr> 
                                                        <td width="10%"><%=langGL[2]%></td>
                                                        <td width="3%">&nbsp;</td>
                                                        <td width="23%"> 
                                                            <input type="text" name="<%=JspGl.colNames[JspGl.JSP_REF_NUMBER]%>" size="35" value="<%=gl.getRefNumber()%>">
                                                        <%= jspGl.getErrorMsg(jspGl.JSP_REF_NUMBER) %> </td>
                                                        <td width="9%">
                                                            <input type="hidden" name="<%=JspGl.colNames[JspGl.JSP_REFERENSI_ID]%>" size="35" value="<%=referensi_id%>">
                                                            <%if (referensi_no.length() > 0) {%>
                                                            <%=langGL[16]%>
                                                            <%} else {%>
                                                            &nbsp;
                                                            <%}%>
                                                        </td>
                                                        <td width="55%">
                                                            <%if (referensi_no.length() > 0) {%>
                                                            <%=referensi_no%>
                                                            <%} else {%>
                                                            &nbsp;
                                                            <%}%>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr align="left" valign="top"> 
                            <td height="14" valign="middle" colspan="3" class="comment"> 
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                <tr> 
                                    <td>&nbsp;</td>
                                </tr>
                                <tr> 
                                    <td>&nbsp; </td>
                                </tr>
                                <tr> 
                                    <td> 
                                        <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                            <tr > 
                                                <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="15" height="10"></td>
                                                <td class="tab" nowrap><%=langGL[3]%></td>
                                                <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"> 
                                                    <%if (applyActivity) {%>
                                                </td>
                                                <%if (gl.getNotActivityBase() == 0) {%>
                                                <td class="tabin"> 
                                                    <%if (true) {%>
                                                    <a href="javascript:cmdActivity('<%=oidGl%>')" class="tablink">Activity</a> 
                                                    <%} else {%>
                                                    <a href="#" class="tablink" title="petty cash payment required">Activity</a> 
                                                    <%}%>
                                                </td>
                                                <%} else {%>
                                                <td nowrap class="tabheader"><font color="#FF0000">&nbsp;GL 
                                                with no expense account, ( Non activity transaction )</font></td>
                                                <%}%>
                                                <%}%>
                                                <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                                <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                                <td width="100%" class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="10" height="10"><font color="#FF0000"> 
                                                </font></td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr> 
                                    <td> 
                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                        <tr> 
                                        <td width="100%" class="page"> 
                                            <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                            <%
            if (referensi_id == 0) {
                                            %>
                                            <tr> 
                                                <td rowspan="2" class="tablehdr" nowrap width="21%"><%=langGL[4]%></td>
                                                <td rowspan="2" class="tablehdr"><%=langGL[5]%></td>
                                                <td rowspan="2" class="tablehdr">&nbsp;</td>
                                                <td colspan="2" class="tablehdr"><%=langGL[6]%></td>
                                                <td rowspan="2" class="tablehdr" width="7%"><%=langGL[9]%></td>
                                                <td rowspan="2" class="tablehdr" width="15%"><%=langGL[10]%> <%=baseCurrency.getCurrencyCode()%></td>
                                                <td rowspan="2" class="tablehdr" width="15%"><%=langGL[11]%> <%=baseCurrency.getCurrencyCode()%> </td>
                                                <td rowspan="2" class="tablehdr" width="15%"><%=langGL[12]%></td>
                                            </tr>
                                            <tr> 
                                                <td width="4%" class="tablehdr"><%=langGL[7]%></td>
                                                <td width="19%" class="tablehdr"><%=langGL[8]%></td>
                                            </tr>
                                            <%
                                            } else {
                                            %>
                                            
                                            <%if (referensi_id != 0 && gl.getOID() == 0){%>
                                            
                                            <tr> 
                                                <td rowspan="2" class="tablehdr" nowrap width="21%"><%=langGL[4]%></td>
                                                <td rowspan="2" class="tablehdr"><%=langGL[5]%></td>
                                                <td rowspan="2" class="tablehdr">&nbsp;</td>
                                                <td colspan="2" class="tablehdr"><%=langGL[6]%></td>
                                                <td rowspan="2" class="tablehdr" width="7%"><%=langGL[9]%></td>
                                                <td rowspan="2" class="tablehdr" width="15%"><%=langGL[10]%> <%=baseCurrency.getCurrencyCode()%></td>
                                                <td rowspan="2" class="tablehdr" width="15%"><%=langGL[11]%> <%=baseCurrency.getCurrencyCode()%> </td>
                                                <td rowspan="2" class="tablehdr" width="15%"><%=langGL[12]%></td>
                                            </tr>
                                            <tr> 
                                                <td width="4%" class="tablehdr"><%=langGL[7]%></td>
                                                <td width="19%" class="tablehdr"><%=langGL[8]%></td>
                                            </tr>
                                            
                                            <%if (listGlDetail != null && listGlDetail.size() > 0){%>
                                            
                                            <%

    int ct = 0;
    colspan = 6;

    for (int iGl = 0; iGl < listGlDetail.size(); iGl++) {

        GlDetail crd = (GlDetail) listGlDetail.get(iGl);

        if (crd.getDebet() > 0) {
            crd.setIsDebet(0);
        } else {
            crd.setIsDebet(1);
        }

        Coa c = new Coa();

        try {
            c = DbCoa.fetchExc(crd.getCoaId());
            if (iGl == 0) {
                ct = c.getAccountClass();
            } else {
                if (!diffCoaClass && ct != c.getAccountClass()) {
                    if (ct == 2) {
                        if (c.getAccountClass() != 2) {
                            diffCoaClass = true;
                        }
                    } else {
                        if (c.getAccountClass() == 2) {
                            diffCoaClass = true;
                        }
                    }
                }
            }
        } catch (Exception e) {
            System.out.println("[exception] " + e.toString());
        }
                                            %>   
                                            <tr> 
                                                <td class="tablecell" nowrap width="21%" height="17"> 
                                                    <%
                                                    if (crd.getCoaId() != 0) {
                                                    %>
                                                    <%=c.getCode() + " - " + c.getName()%>
                                                    
                                                    <%
                                                    } else {
                                                    %>
                                                    -
                                                    <%}%>
                                                </td>
                                                <td width="4%" class="tablecell">                                                                                                                                                         
                                                    <select name="<%=JspGlDetail.colNames[JspGlDetail.JSP_DEPARTMENT_ID]%>_<%=iGl%>" onChange="javascript:cmdUpdateExchange()">
                                                        <%
                                                    Vector vlistDepartment = DbDepartment.list(0, 0, "", "");
                                                    if (vlistDepartment.size() > 0) {
                                                        for (int k = 0; k < vlistDepartment.size(); k++) {
                                                            Department department = (Department) vlistDepartment.get(k);
                                                        %>
                                                        <option value="<%=department.getOID()%>"><%=department.getName()%></option>																
                                                        <%
                                                        }
                                                    }
                                                        %>
                                                    </select>
                                                </td>
                                                <td width="4%" class="tablecell" height="17"> 
                                                    <div align="center"> 
                                                        <%
                                                    if (c.getAccountClass() == DbCoa.ACCOUNT_CLASS_SP){
                                                        out.println("SP");
                                                    } else {
                                                        out.println("NSP");
                                                    }
                                                        %>
                                                    </div>                                                      
                                                </td>
                                                <td width="4%" class="tablecell" height="17"> 
                                                    <div align="center"> 
                                                        <%
                                                    Currency xc = new Currency();
                                                    try {
                                                        xc = DbCurrency.fetchExc(crd.getForeignCurrencyId());
                                                    } catch (Exception e) {
                                                        System.out.println("[exception] " + e.toString());
                                                    }
                                                        %>
                                                        <%=xc.getCurrencyCode()%>
                                                    </div>                                                      
                                                </td>
                                                <td width="19%" class="tablecell" height="17"> 
                                                    <div align="right">
                                                        <%=JSPFormater.formatNumber(crd.getForeignCurrencyAmount(), "#,###.##")%> 
                                                    </div>                                                      
                                                </td>
                                                <td width="7%" class="tablecell" height="17"> 
                                                    <div align="right"> <%=JSPFormater.formatNumber(crd.getBookedRate(), "#,###.##")%> </div>                                                      
                                                </td>
                                                <td width="15%" class="tablecell" height="17"> 
                                                    <div align="right"><%=JSPFormater.formatNumber(crd.getDebet(), "#,###.##")%></div>                                                      
                                                </td>
                                                <td width="15%" class="tablecell" height="17"> 
                                                    <div align="right"><%=JSPFormater.formatNumber(crd.getCredit(), "#,###.##")%></div>                                                      
                                                </td>
                                                <td width="15%" class="tablecell" height="17">
                                                <%=crd.getMemo()%></td>
                                            </tr>                                            
                                            <%
    }
                                            %>
                                            <%}%>
                                            
                                            <%} else if (referensi_id != 0 && gl.getOID() != 0){%>
                                            
                                               <tr> 
                                                <td rowspan="2" class="tablehdr" nowrap width="21%"><%=langGL[4]%></td>
                                                <td rowspan="2" class="tablehdr"><%=langGL[5]%></td>
                                                <td rowspan="2" class="tablehdr">&nbsp;</td>
                                                <td colspan="2" class="tablehdr"><%=langGL[6]%></td>
                                                <td rowspan="2" class="tablehdr" width="7%"><%=langGL[9]%></td>
                                                <td rowspan="2" class="tablehdr" width="15%"><%=langGL[10]%> <%=baseCurrency.getCurrencyCode()%></td>
                                                <td rowspan="2" class="tablehdr" width="15%"><%=langGL[11]%> <%=baseCurrency.getCurrencyCode()%> </td>
                                                <td rowspan="2" class="tablehdr" width="15%"><%=langGL[12]%></td>
                                            </tr>
                                            <tr> 
                                                <td width="4%" class="tablehdr"><%=langGL[7]%></td>
                                                <td width="19%" class="tablehdr"><%=langGL[8]%></td>
                                            </tr>
                                            
                                            <%if (listGlDetail != null && listGlDetail.size() > 0){%>
                                            
                                            <%

    int ct = 0;
    colspan = 6;

    for (int iGl = 0; iGl < listGlDetail.size(); iGl++) {

        GlDetail crd = (GlDetail) listGlDetail.get(iGl);

        if (crd.getDebet() > 0) {
            crd.setIsDebet(0);
        } else {
            crd.setIsDebet(1);
        }

        Coa c = new Coa();

        try {
            c = DbCoa.fetchExc(crd.getCoaId());
            if (iGl == 0) {
                ct = c.getAccountClass();
            } else {
                if (!diffCoaClass && ct != c.getAccountClass()) {
                    if (ct == 2) {
                        if (c.getAccountClass() != 2) {
                            diffCoaClass = true;
                        }
                    } else {
                        if (c.getAccountClass() == 2) {
                            diffCoaClass = true;
                        }
                    }
                }
            }
        } catch (Exception e) {
            System.out.println("[exception] " + e.toString());
        }
                                            %>   
                                            <tr> 
                                                <td class="tablecell" nowrap width="21%" height="17"> 
                                                    <%
                                                    if (crd.getCoaId() != 0) {
                                                    %>
                                                    <%=c.getCode() + " - " + c.getName()%>
                                                    
                                                    <%
                                                    } else {
                                                    %>
                                                    -
                                                    <%}%>
                                                </td>
                                                <td width="4%" class="tablecell">                                                                                                                                                         
                                                    <select name="<%=JspGlDetail.colNames[JspGlDetail.JSP_DEPARTMENT_ID]%>_<%=iGl%>" onChange="javascript:cmdUpdateExchange()">
                                                        <%
                                                    Vector vlistDepartment = DbDepartment.list(0, 0, "", "");
                                                    if (vlistDepartment.size() > 0) {
                                                        for (int k = 0; k < vlistDepartment.size(); k++) {
                                                            Department department = (Department) vlistDepartment.get(k);
                                                        %>
                                                        <option value="<%=department.getOID()%>"><%=department.getName()%></option>																
                                                        <%
                                                        }
                                                    }
                                                        %>
                                                    </select>
                                                </td>
                                                <td width="4%" class="tablecell" height="17"> 
                                                    <div align="center"> 
                                                        <%
                                                    if (c.getAccountClass() == DbCoa.ACCOUNT_CLASS_SP){
                                                        out.println("SP");
                                                    } else {
                                                        out.println("NSP");
                                                    }
                                                        %>
                                                    </div>                                                      
                                                </td>
                                                <td width="4%" class="tablecell" height="17"> 
                                                    <div align="center"> 
                                                        <%
                                                    Currency xc = new Currency();
                                                    try {
                                                        xc = DbCurrency.fetchExc(crd.getForeignCurrencyId());
                                                    } catch (Exception e) {
                                                        System.out.println("[exception] " + e.toString());
                                                    }
                                                        %>
                                                        <%=xc.getCurrencyCode()%>
                                                    </div>                                                      
                                                </td>
                                                <td width="19%" class="tablecell" height="17"> 
                                                    <div align="right">
                                                        <%=JSPFormater.formatNumber(crd.getForeignCurrencyAmount(), "#,###.##")%> 
                                                    </div>                                                      
                                                </td>
                                                <td width="7%" class="tablecell" height="17"> 
                                                    <div align="right"> <%=JSPFormater.formatNumber(crd.getBookedRate(), "#,###.##")%> </div>                                                      
                                                </td>
                                                <td width="15%" class="tablecell" height="17"> 
                                                    <div align="right"><%=JSPFormater.formatNumber(crd.getDebet(), "#,###.##")%></div>                                                      
                                                </td>
                                                <td width="15%" class="tablecell" height="17"> 
                                                    <div align="right"><%=JSPFormater.formatNumber(crd.getCredit(), "#,###.##")%></div>                                                      
                                                </td>
                                                <td width="15%" class="tablecell" height="17">
                                                <%=crd.getMemo()%></td>
                                            </tr>                                            
                                            <%
    }
                                            %>
                                            <%}%> 
                                 
                                            
                                            <%
                }
            }
                                            %>
                                            
                                                       
            <%//if ((iJSPCommand == JSPCommand.ADD || (iJSPCommand == JSPCommand.SUBMIT && (iErrCode != 0 || iErrCodeMain != 0))) && recIdx == -1 && gl.getOID() != 0) {%>
            <%if(true) {
                colspan = 5;
                                                       %>
                                                       <tr> 
                                                <td rowspan="2"  class="tablehdr" nowrap width="21%"><%=langGL[4]%></td>
                                                <td rowspan="2" class="tablehdr"><%=langGL[5]%></td>
                                                <td rowspan="2" class="tablehdr">&nbsp;</td>
                                                <td colspan="2" class="tablehdr"><%=langGL[6]%></td>
                                                <td rowspan="2" class="tablehdr" width="7%"><%=langGL[9]%></td>
                                                <td rowspan="2" class="tablehdr" width="15%"><%=langGL[10]%> <%=baseCurrency.getCurrencyCode()%></td>
                                                <td rowspan="2" class="tablehdr" width="15%"><%=langGL[11]%> <%=baseCurrency.getCurrencyCode()%> </td>
                                                <td rowspan="2" class="tablehdr" width="15%"><%=langGL[12]%></td>
                                            </tr>
                                            <tr> 
                                                <td width="4%" class="tablehdr"><%=langGL[7]%></td>
                                                <td width="19%" class="tablehdr"><%=langGL[8]%></td>
                                            </tr>
                                            <tr> 
                                                <td class="tablecell" width="21%"> 
                                                    <select name="<%=JspGlDetail.colNames[JspGlDetail.JSP_COA_ID]%>">
                                                        <%if (incomeCoas != null && incomeCoas.size() > 0) {
                                                               for (int x = 0; x < incomeCoas.size(); x++) {
                                                                   Coa coax = (Coa) incomeCoas.get(x);

                                                                   String str = "";
                                                                   if (!isPostableOnly) {
                                                                       switch (coax.getLevel()) {
                                                                           case 1:
                                                                               break;
                                                                           case 2:
                                                                               str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                                                                               break;
                                                                           case 3:
                                                                               str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                                                                               break;
                                                                           case 4:
                                                                               str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                                                                               break;
                                                                           case 5:
                                                                               str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                                                                               break;
                                                                       }
                                                                   }
                                                        %>
                                                        <option value="<%=coax.getOID()%>" <%if (glDetail.getCoaId() == coax.getOID()) {%>selected<%}%>><%=str + coax.getCode() + " - " + coax.getName()%></option>
                                                        <%}
                                                           }%>
                                                    </select>
                                                <%= jspGlDetail.getErrorMsg(JspGlDetail.JSP_COA_ID) %> </td>
                                                <td width="4%" class="tablecell">
                                                    <select name="<%=JspGlDetail.colNames[JspGlDetail.JSP_DEPARTMENT_ID]%>" onChange="javascript:cmdUpdateExchange()">													  
                                                        <%
                                                           Vector vlistDepartment = DbDepartment.list(0, 0, "", "");
                                                           if (vlistDepartment.size() > 0) {
                                                               for (int k = 0; k < vlistDepartment.size(); k++) {
                                                                   Department department = (Department) vlistDepartment.get(k);
                                                        %>
                                                        <option value="<%=department.getOID()%>"><%=department.getName()%></option>																
                                                        <%
                                                               }
                                                           }
                                                        %>
                                                </select></td>
                                                <td width="4%" class="tablecell">&nbsp;</td>
                                                <td width="4%" class="tablecell"> 
                                                    <div align="center"> 
                                                        <select name="<%=JspGlDetail.colNames[JspGlDetail.JSP_FOREIGN_CURRENCY_ID]%>" onChange="javascript:cmdUpdateExchange()">
                                                            <%if (currencies != null && currencies.size() > 0) {
                                                               for (int x = 0; x < currencies.size(); x++) {
                                                                   Currency c = (Currency) currencies.get(x);
                                                            %>
                                                            <option value="<%=c.getOID()%>" <%if (glDetail.getForeignCurrencyId() == c.getOID()) {%>selected<%}%>><%=c.getCurrencyCode()%></option>
                                                            <%}
                                                           }%>
                                                        </select>
                                                    </div>
                                                </td>
                                                <td width="19%" class="tablecell" nowrap> 
                                                    <div align="center"> 
                                                        <select name="<%=JspGlDetail.colNames[JspGlDetail.JSP_IS_DEBET]%>" onChange="javascript:updateDebetCredit()">
                                                            <option value="0" <%if (glDetail.getIsDebet() == 0) {%>selected<%}%>>DEBET</option>
                                                            <option value="1" <%if (glDetail.getIsDebet() == 1) {%>selected<%}%>>CREDIT</option>
                                                        </select>
                                                        <input type="text" name="<%=JspGlDetail.colNames[JspGlDetail.JSP_FOREIGN_CURRENCY_AMOUNT]%>" size="15" value="<%=JSPFormater.formatNumber(glDetail.getForeignCurrencyAmount(), "#,###.##")%>" style="text-align:right" onBlur="javascript:cmdUpdateExchange()" onClick="javascript:cmdClickMe()">
                                                <%= jspGlDetail.getErrorMsg(jspGlDetail.JSP_FOREIGN_CURRENCY_AMOUNT) %></div>                                                      </td>
                                                <td width="7%" class="tablecell"> 
                                                    <div align="center"> 
                                                        <input type="text" name="<%=JspGlDetail.colNames[JspGlDetail.JSP_BOOKED_RATE]%>" size="7" value="<%=JSPFormater.formatNumber(glDetail.getBookedRate(), "#,###.##")%>" style="text-align:right" readOnly class="readonly">
                                                </div>                                                      </td>
                                                <td width="15%" class="tablecell"> 
                                                    <div align="center"> 
                                                        <input type="text" name="<%=JspGlDetail.colNames[JspGlDetail.JSP_DEBET]%>" value="<%=JSPFormater.formatNumber(glDetail.getDebet(), "#,###.##")%>" style="text-align:right" size="15" readOnly class="readonly">
                                                <%= jspGlDetail.getErrorMsg(JspGlDetail.JSP_DEBET) %></div>                                                      </td>
                                                <td width="15%" class="tablecell"> 
                                                    <div align="center"> 
                                                        <input type="text" name="<%=JspGlDetail.colNames[JspGlDetail.JSP_CREDIT]%>" value="<%=JSPFormater.formatNumber(glDetail.getCredit(), "#,###.##")%>" style="text-align:right" size="15" readOnly class="readonly">
                                                <%= jspGlDetail.getErrorMsg(JspGlDetail.JSP_DEBET) %></div>                                                      </td>
                                                <td width="15%" class="tablecell"> 
                                                    <div align="center"> 
                                                        <input type="text" name="<%=JspGlDetail.colNames[JspGlDetail.JSP_MEMO]%>" value="<%=glDetail.getMemo()%>">
                                                </div>                                                      </td>
                                            </tr>
                                            <%}%>
                                            <tr> 
                                                <td class="tablecell" colspan="9" height="1">&nbsp</td>
                                            </tr>
                                            <tr> 
                                                <td colspan="<%=colspan%>"> 
                                                <div align="right"><b>TOTAL : </b></div></td>
                                                <td width="15%" class="tablecell"> 
                                                    <div align="center"> 
                                                        <input type="text" name="total_debet" value="<%=JSPFormater.formatNumber(totalDebet, "#,###.##")%>" style="text-align:right" size="15" readOnly class="readonly">
                                                </div>                                                      </td>
                                                <td width="15%" class="tablecell"> 
                                                    <div align="center">
                                                        <input type="text" name="total_credit" value="<%=JSPFormater.formatNumber(totalCredit, "#,###.##")%>" style="text-align:right" size="15" readOnly class="readonly">
                                                </div>                                                      </td>
                                                <td width="15%" class="tablecell">&nbsp;</td>
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
        <%
            try {
        %>
        
        <tr align="left" valign="top"> 
            <td height="22" valign="middle" colspan="3"> 
                <table width="100%" border="0" cellspacing="0" cellpadding="0">                    
                    <tr> 
                        <td width="25%">&nbsp;</td>
                        <td width="52%">&nbsp;</td>
                        <td width="23%">&nbsp;</td>
                    </tr>
                    <tr> 
                        <td width="25%">                                                     
                            <%

            if (iJSPCommand != JSPCommand.ADD && iJSPCommand != JSPCommand.EDIT && iJSPCommand != JSPCommand.ASK && iErrCode == 0 && iErrCodeMain == 0 && false) {

                            %>
                            <a href="javascript:cmdAdd()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new','','../images/new2.gif',1)"><img src="../images/new.gif" name="new" width="71" height="22" border="0"></a> 
                            <%
                                                                } else {


                            %>
                            <%

                                                                    if ((iJSPCommand == JSPCommand.SUBMIT || iJSPCommand == JSPCommand.POST) && (iErrCode != 0 || iErrCodeMain != 0)) {
                                                                        iJSPCommand = JSPCommand.SAVE;
                                                                    }

                                                                    ctrLine.setLocationImg(approot + "/images/ctr_line");
                                                                    ctrLine.initDefault();
                                                                    ctrLine.setTableWidth("90%");
                                                                    String scomDel = "javascript:cmdAsk('" + oidGlDetail + "')";
                                                                    String sconDelCom = "javascript:cmdConfirmDelete('" + oidGlDetail + "')";
                                                                    String scancel = "javascript:cmdEdit('" + oidGlDetail + "')";
                                                                    if (listGlDetail != null && listGlDetail.size() > 0) {
                                                                        ctrLine.setBackCaption("Cancel");
                                                                    } else {
                                                                        ctrLine.setBackCaption("");
                                                                    }
                                                                    ctrLine.setJSPCommandStyle("command");
                                                                    ctrLine.setDeleteCaption("Delete");

                                                                    ctrLine.setOnMouseOut("MM_swapImgRestore()");
                                                                    ctrLine.setOnMouseOverSave("MM_swapImage('save','','" + approot + "/images/savenew2.gif',1)");
                                                                    ctrLine.setSaveImage("<img src=\"" + approot + "/images/savenew.gif\" name=\"save\" height=\"22\" border=\"0\">");


                                                                    ctrLine.setOnMouseOverBack("MM_swapImage('back','','" + approot + "/images/cancel2.gif',1)");
                                                                    ctrLine.setBackImage("<img src=\"" + approot + "/images/cancel.gif\" name=\"back\" height=\"22\" border=\"0\">");

                                                                    ctrLine.setOnMouseOverDelete("MM_swapImage('delete','','" + approot + "/images/delete2.gif',1)");
                                                                    ctrLine.setDeleteImage("<img src=\"" + approot + "/images/delete.gif\" name=\"delete\" height=\"22\" border=\"0\">");

                                                                    ctrLine.setOnMouseOverEdit("MM_swapImage('edit','','" + approot + "/images/cancel2.gif',1)");
                                                                    ctrLine.setEditImage("<img src=\"" + approot + "/images/cancel.gif\" name=\"edit\" height=\"22\" border=\"0\">");


                                                                    ctrLine.setWidthAllJSPCommand("70");
                                                                    ctrLine.setErrorStyle("warning");
                                                                    ctrLine.setErrorImage(approot + "/images/error.gif\" width=\"20\" height=\"20");
                                                                    ctrLine.setQuestionStyle("warning");
                                                                    ctrLine.setQuestionImage(approot + "/images/error.gif\" width=\"20\" height=\"20");
                                                                    ctrLine.setInfoStyle("success");
                                                                    ctrLine.setSuccessImage(approot + "/images/success.gif\" width=\"20\" height=\"20");

                                                                    if (iErrCode == 0 && iErrCodeMain != 0) {
                                                                        ctrLine.setSaveJSPCommand("javascript:cmdFixing()");
                                                                    }

                                                                    if (privDelete) {
                                                                        ctrLine.setConfirmDelJSPCommand(sconDelCom);
                                                                        ctrLine.setDeleteJSPCommand(scomDel);
                                                                        ctrLine.setEditJSPCommand(scancel);
                                                                    } else {
                                                                        ctrLine.setConfirmDelCaption("");
                                                                        ctrLine.setDeleteCaption("");
                                                                        ctrLine.setEditCaption("");
                                                                    }

                                                                    if (privAdd == false && privUpdate == false) {
                                                                        ctrLine.setSaveCaption("");
                                                                    }

                                                                    if (privAdd == false) {
                                                                        ctrLine.setAddCaption("");
                                                                    }

                                                                    if (msgStringMain.length() > 0) {
                                                                        iErrCode = iErrCodeMain;
                                                                        msgString = msgStringMain;
                                                                    }

                            %>     
                           
                            <%}%>
                        </td>
                        <td width="52%"> 
                            <div align="right"></div>
                        </td>
                        <td width="23%" class="boxed1"> 
                            <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                <tr> 
                                    <td width="41%" nowrap><b>Out of Balance <%=baseCurrency.getCurrencyCode()%> :</b></td>
                                    <td width="59%"> 
                                        <div align="right"><b><a id="tot_balance"></a></b></div>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <%if(referensi_id != 0){%>
                    <tr> 
                        <td width="100%" colspan=3>
                            <a href="javascript:cmdProcesFirst()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('savedoc21','','../images/savenew2.gif',1)"><img src="../images/savenew.gif" name="savedoc21" height="22" border="0" width="116"></a>
                        </td>
                    </tr>
                    <%}%>
                </table>
            </td>
        </tr>
        <%
            } catch (Exception exc) {
                System.out.println("[exception] " + exc.toString());
            }%>
        <%if (totalDebet > 0 && iErrCode == 0 && iErrCode == 0 && balance == 0 && gl.getOID() == 0) {%>
        <tr align="left" valign="top"> 
            <td height="1" valign="middle" colspan="3"> 
                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr> 
                        <td height="2">&nbsp;</td>
                    </tr>
                    <tr> 
                        <td height="2" background="../images/line.gif" ><img src="../images/line.gif"></td>
                    </tr>
                </table>
            </td>
        </tr>
        <%if (!diffCoaClass) {%>
        <tr align="left" valign="top"> 
            <td valign="middle" colspan="3"> 
                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr> 
                        <td width="8%"><a href="javascript:cmdSubmitCommand()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('post','','../images/post_journal2.gif',1)"><img src="../images/post_journal.gif" name="post" width="92" height="22" border="0"></a></td>
                        <td width="59%">&nbsp;</td>
                        <td width="33%"> 
                            <div align="right" class="msgnextaction"> 
                                <table border="0" cellpadding="5" cellspacing="0" class="info" width="222" align="right">
                                    <tr> 
                                        <td width="19"><img src="../images/inform.gif" width="20" height="20"></td>
                                        <td width="183" nowrap>Journal is ready to be posted</td>
                                    </tr>
                                </table>
                            </div>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <%} else {%>
        <tr align="left" valign="top"> 
            <td valign="middle" colspan="3"> <font color="#FF0000"><%=langGL[13]%></font></td>
        </tr>
        <%}
            }%>
        <%if (gl.getOID() != 0 && !isLoad) {%>
        <tr align="left" valign="top"> 
            <td height="1" valign="middle" colspan="3"> 
                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr> 
                        <td height="2">&nbsp;</td>
                    </tr>
                    <tr> 
                        <td height="2" background="../images/line.gif" ><img src="../images/line.gif"></td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr align="left" valign="top"> 
            <td valign="middle" colspan="3"> 
                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr> 
                        <td width="3%"><a href="javascript:cmdPrintJournal()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('print','','../images/print2.gif',1)"><img src="../images/print.gif" name="print" width="53" height="22" border="0"></a></td>
                        <td width="3%">&nbsp;</td>
                        <td width="9%"><a href="javascript:cmdNewJournal()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new1','','../images/new2.gif',1)"><img src="../images/new.gif" name="new1" width="71" height="22" border="0"></a></td>
                        <td width="47%">&nbsp;</td>
                        <td width="38%"> 
                            <div align="right" class="msgnextaction"> 
                                <table border="0" cellpadding="5" cellspacing="0" class="success" align="right">
                                    <tr> 
                                        <td width="20"><img src="../images/success.gif" width="20" height="20"></td>
                                        <td width="220"><%=langGL[14]%></td>
                                    </tr>
                                </table>
                            </div>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <%}%>
        <%if (gl.getOID() != 0 && gl.getPostedStatus() == 1) {%>
        <tr>
            <td>&nbsp;</td>
        </tr>    
        <tr align="left" valign="top"> 
            <td valign="middle" colspan="3"> 
                <div align="left" class="msgnextaction"> 
                    <table border="0" cellpadding="5" cellspacing="0" class="success" align="left">
                        <tr> 
                            <td width="20"><img src="../images/success.gif" width="20" height="20"></td>
                            <td width="150">Posted</td>
                        </tr>
                    </table>
                </div>
            </td>
        </tr>
        <%}%>
        </table>
    </td>
    </tr>
    <tr align="left" valign="top"> 
        <td height="8" valign="middle" width="17%">&nbsp;</td>
        <td height="8" colspan="2" width="83%">&nbsp;</td>
    </tr>
    <tr align="left" valign="top" > 
        <td colspan="3" class="command">&nbsp; </td>
    </tr>
    </table>
    <script language="JavaScript">
        //document.frmgl.<%=JspGlDetail.colNames[JspGlDetail.JSP_DEBET]%>.value="<%=JSPFormater.formatNumber(totalDebet, "#,###.##")%>";
        <%if (iJSPCommand == JSPCommand.ADD || iJSPCommand == JSPCommand.EDIT || iErrCode != 0) {%>
        cmdUpdateExchange();
        <%}%>
    </script>
    </form>
    <!-- #EndEditable -->
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