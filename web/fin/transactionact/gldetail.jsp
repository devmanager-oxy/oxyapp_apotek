
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
<% int appObjCode = 1;%>
<%@ include file = "../main/check.jsp" %>
<%
            boolean priv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MN_GL, AppMenu.M2_MN_GL);
            boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_GL, AppMenu.M2_MN_GL, AppMenu.PRIV_VIEW);
            boolean privUpdate = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_GL, AppMenu.M2_MN_GL, AppMenu.PRIV_UPDATE);
            boolean privAdd = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_GL, AppMenu.M2_MN_GL, AppMenu.PRIV_ADD);
            boolean privDelete = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_GL, AppMenu.M2_MN_GL, AppMenu.PRIV_DELETE);
%>
<%!
    public String getStrLevel(int level) {
        String str = "";
        switch (level) {
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
        return str;
    }

    public static String getAccountRecursif(int minus, Coa coa, long oid, boolean isPostableOnly) {

        int level = 0;

        String result = "";

        if (!coa.getStatus().equals(I_Project.ACCOUNT_LEVEL_POSTABLE)) {

            Vector coas = DbCoa.list(0, 0, "acc_ref_id=" + coa.getOID(), "code");

            if (coas != null && coas.size() > 0) {
                for (int i = 0; i < coas.size(); i++) {

                    Coa coax = (Coa) coas.get(i);
                    String str = "";

                    if (!isPostableOnly) {

                        level = coax.getLevel() + minus;

                        switch (level) {
                            case 0:
                                break;
                            case 1:
                                str = str + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                                break;
                            case 2:
                                str = str + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                                break;
                            case 3:
                                str = str + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                                break;
                            case 4:
                                str = str + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                                break;
                            case 5:
                                str = str + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                                break;
                        }
                    }
                    result = result + "<option value=\"" + coax.getOID() + "\"" + ((oid == coax.getOID()) ? "selected" : "") + ">" + str + coax.getCode() + " - " + coax.getName() + "</option>";
                    if (!coax.getStatus().equals(I_Project.ACCOUNT_LEVEL_POSTABLE)) {
                        result = result + getAccountRecursif(minus, coax, oid, isPostableOnly);
                    }
                }
            }
        }
        return result;
    }
%>

<%!    public Vector addNewDetail(Vector listGlDetail, GlDetail glDetail) {
        boolean found = false;
        if (listGlDetail != null && listGlDetail.size() > 0) {
            for (int i = 0; i < listGlDetail.size(); i++) {
                GlDetail cr = (GlDetail) listGlDetail.get(i);
                if (cr.getCoaId() == glDetail.getCoaId() && cr.getForeignCurrencyId() == glDetail.getForeignCurrencyId()) {
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
            boolean isApplyModBudget = true;
            try {
                String applyModBudget = DbSystemProperty.getValueByName("APPLY_MOD_BUDGET");
                if (applyModBudget.compareTo("Y") == 0) {
                    isApplyModBudget = true;
                } else {
                    isApplyModBudget = false;
                }
            } catch (Exception e) {
                isApplyModBudget = false;
            }

            if (iJSPCommand == JSPCommand.NONE) {
                session.removeValue("GL_DETAIL");
                oidGl = 0;
                recIdx = -1;
            }
            /*variable declaration*/
            int recordToGet = 0;
            String msgString = "";
            int iErrCode = JSPMessage.NONE;

            boolean isLoad = false;
            if (iJSPCommand == JSPCommand.LOAD) {
                session.removeValue("GL_DETAIL");
                oidGl = JSPRequestValue.requestLong(request, "gl_id");
                recIdx = -1;
                isLoad = true;
            }

            CmdGl ctrlGl = new CmdGl(request);
            JSPLine ctrLine = new JSPLine();

            int iErrCodeMain = ctrlGl.action(iJSPCommand, oidGl);
            JspGl jspGl = ctrlGl.getForm();
            int vectSize = 0;
            Gl gl = ctrlGl.getGl();
            String msgStringMain = ctrlGl.getMessage();
            if (oidGl == 0) {
                oidGl = gl.getOID();
            }
            if (iJSPCommand == JSPCommand.LOAD) {
                try {
                    gl = DbGl.fetchExc(oidGl);
                } catch (Exception e) {
                }
            }
%>
<%
            boolean load = false;
            if (iJSPCommand == JSPCommand.LOAD) {
                load = true;
            }
            if (iJSPCommand == JSPCommand.NONE || iJSPCommand == JSPCommand.LOAD) {
                iJSPCommand = JSPCommand.ADD;
            }
            CmdGlDetail ctrlGlDetail = new CmdGlDetail(request);
            Vector listGlDetail = new Vector(1, 1);
            if (load) {

                int unix = 1;
                while (unix != 0) {
                    Vector listGlDetailx = DbGlDetail.list(0, 0, DbGlDetail.colNames[DbGlDetail.COL_GL_ID] + "=" + gl.getOID(), null);
                    Vector listGlDetailCheck = DbGlDetail.list(0, 0, DbGlDetail.colNames[DbGlDetail.COL_GL_ID] + "=" + gl.getOID(), null);
                    unix = 0;
                    for (int t = 0; t < listGlDetailCheck.size(); t++) {
                        GlDetail gdx = (GlDetail) listGlDetailCheck.get(t);
                        for (int d = 0; d < listGlDetailx.size(); d++) {
                            GlDetail gdCheck = (GlDetail) listGlDetailx.get(d);
                            if (gdx.getOID() != gdCheck.getOID()) {
                                if (gdx.getOID() != gdCheck.getOID()) {
                                    if (gdCheck.getSegment1Id() == gdx.getSegment1Id() &&
                                            gdCheck.getSegment2Id() == gdx.getSegment2Id() &&
                                            gdCheck.getGlId() == gdx.getGlId() &&
                                            gdCheck.getCoaId() == gdx.getCoaId() &&
                                            gdCheck.getBookedRate() == gdx.getBookedRate() &&
                                            gdCheck.getDebet() == gdx.getDebet() &&
                                            gdCheck.getCredit() == gdx.getCredit() &&
                                            gdCheck.getMemo().equals(gdx.getMemo())) {
                                        unix++;
                                        gdx.setMemo(gdx.getMemo() + "-");
                                        try {
                                            DbGlDetail.updateExc(gdx);
                                        } catch (Exception e) {
                                        }
                                        break;
                                    }
                                }
                            }
                        }
                        if (unix != 0) {
                            break;
                        }
                    }
                }
                listGlDetail = DbGlDetail.list(0, 0, DbGlDetail.colNames[DbGlDetail.COL_GL_ID] + "=" + gl.getOID(), null);
            }
            /*switch statement */
            iErrCode = ctrlGlDetail.action(iJSPCommand, DbPeriode.getOpenPeriod(), oidGlDetail);
            /* end switch*/
            JspGlDetail jspGlDetail = ctrlGlDetail.getForm();

            /*count list All GlDetail*/
            vectSize = 0;
            /*switch list GlDetail*/
            if ((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV) ||
                    (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)) {
                start = ctrlGlDetail.actionList(iJSPCommand, start, vectSize, recordToGet);
            }
            /* end switch list*/

            GlDetail glDetail = ctrlGlDetail.getGlDetail();
            msgString = ctrlGlDetail.getMessage();

            if (session.getValue("GL_DETAIL") != null) {
                listGlDetail = (Vector) session.getValue("GL_DETAIL");
            }

            boolean available = false;
            if (iJSPCommand == JSPCommand.SUBMIT || iJSPCommand == JSPCommand.POST) {
                if (iErrCode == 0 && iErrCodeMain == 0) {
                    if (recIdx == -1) {
                        if (listGlDetail != null && listGlDetail.size() > 0) {
                            for (int d = 0; d < listGlDetail.size(); d++) {
                                GlDetail gdCheck = (GlDetail) listGlDetail.get(d);
                                if (gdCheck.getSegment1Id() == glDetail.getSegment1Id() &&
                                        gdCheck.getSegment2Id() == glDetail.getSegment2Id() &&
                                        gdCheck.getGlId() == glDetail.getGlId() &&
                                        gdCheck.getCoaId() == glDetail.getCoaId() &&
                                        gdCheck.getBookedRate() == glDetail.getBookedRate() &&
                                        gdCheck.getDebet() == glDetail.getDebet() &&
                                        gdCheck.getCredit() == glDetail.getCredit() &&
                                        gdCheck.getMemo().equals(glDetail.getMemo())) {

                                    available = true;
                                    iErrCode = 1;
                                    jspGlDetail.addError(jspGlDetail.JSP_MEMO, "Keterangan harus uniq");
                                    msgString = "Keterangan harus uniq";
                                    break;
                                }
                            }
                        }
                        if (available == false) {
                            listGlDetail.add(glDetail);
                        }


                    } else {
                        GlDetail gld = (GlDetail) listGlDetail.get(recIdx);
                        glDetail.setOID(gld.getOID());

                        if (listGlDetail != null && listGlDetail.size() > 0) {
                            for (int d = 0; d < listGlDetail.size(); d++) {
                                GlDetail gdCheck = (GlDetail) listGlDetail.get(d);
                                if (gdCheck.getSegment1Id() == glDetail.getSegment1Id() &&
                                        gdCheck.getSegment2Id() == glDetail.getSegment2Id() &&
                                        gdCheck.getGlId() == glDetail.getGlId() &&
                                        gdCheck.getCoaId() == glDetail.getCoaId() &&
                                        gdCheck.getBookedRate() == glDetail.getBookedRate() &&
                                        gdCheck.getDebet() == glDetail.getDebet() &&
                                        gdCheck.getCredit() == glDetail.getCredit() &&
                                        gdCheck.getMemo().equals(glDetail.getMemo())) {

                                    available = true;
                                    iErrCode = 1;
                                    jspGlDetail.addError(jspGlDetail.JSP_MEMO, "Keterangan harus uniq");
                                    msgString = "Keterangan harus uniq";
                                    break;
                                }

                            }
                        }
                        listGlDetail.set(recIdx, glDetail);
                    }
                }
            }
            if (iJSPCommand == JSPCommand.DELETE) {
                listGlDetail.remove(recIdx);
            }

            boolean isSave = false;
            if (iJSPCommand == JSPCommand.SAVE) {
                if (gl.getOID() != 0) {
                    isSave = true;
                    DbGlDetail.saveAllDetail(gl, listGlDetail);

                    listGlDetail = DbGlDetail.list(0, 0, "gl_id=" + gl.getOID(), "");
                    try {
                        gl = DbGl.fetchExc(gl.getOID());
                    } catch (Exception e) {
                    }
                }
            }

            session.putValue("GL_DETAIL", listGlDetail);
            Vector currencies = DbCurrency.list(0, 0, "", "");
            ExchangeRate eRate = DbExchangeRate.getStandardRate();
            double totalDebet = getTotalDetail(listGlDetail, 0);
            double totalCredit = getTotalDetail(listGlDetail, 1);

            double balance = totalDebet - totalCredit;
            if (JSPFormater.formatNumber(totalDebet, "#,###.##").equals(JSPFormater.formatNumber(totalCredit, "#,###.##"))) {
                balance = 0;
            }

            if (iJSPCommand == JSPCommand.RESET && iErrCodeMain == 0) {
                totalDebet = 0;
                totalCredit = 0;
                gl = new Gl();
                listGlDetail = new Vector();
                session.removeValue("GL_DETAIL");
            }
            if (iJSPCommand == JSPCommand.SUBMIT && iErrCode == 0 && iErrCodeMain == 0) {
                iJSPCommand = JSPCommand.ADD;
                glDetail = new GlDetail();
                recIdx = -1;
            }

            boolean diffCoaClass = false;

            /*** LANG ***/
            String[] langGL = {"Journal Number", "Transaction Date", "Reference Number", "Journal Detail", //0-3
                "Account - Description", "Department", "Currency", "Code", "Amount", "Booked Rate", "Debet", "Credit", "Description", //4-12
                "Error, can't posting journal when details mixed between SP and NSP", "Journal has been saved successfully.", "Searching", "Journal is ready to be saved", "Memo", "Period", "Activity"};//13-19
            String[] langNav = {"General Journal", "New Journal", "Date", "SEARCHING", "EDITOR JOURNAL"};
            String[] langApp = {"Approval Status", "Squence", "Position/Level", "Approved by", "Approval Date", "Status", "Notes", "Action"};
            if (lang == LANG_ID) {
                String[] langID = {"Nomor Jurnal", "Tanggal Transaksi", "Nomor Referensi", "Detail Jurnal", //0-3
                    "Perkiraan", "Departemen", "Mata Uang", "Kode", "Jumlah", "Kurs Transaksi", "Debet", "Credit", "Keterangan", //4-12
                    "Error, tidak bisa posting journal dengan detail gabungan SP dan NSP.", "Jurnal sukses disimpan.", "Pencarian", "Jurnal siap untuk disimpan", "Memo", "Periode", "Kegiatan"}; //13-19

                langGL = langID;

                String[] navID = {"Jurnal Umum", "Jurnal Baru", "Tanggal", "PENCARIAN", "EDITOR JURNAL"};
                langNav = navID;
                String[] langAppID = {"Status Persetujuan", "Urutan", "Posisi/Level", "Oleh", "Tgl. Disetujui", "Status", "Catatan", "Tindakan"};
                langApp = langAppID;
            }
            Vector segments = DbSegment.list(0, 0, "", "count");
            Vector coas = DbCoa.list(0, 0, "", DbCoa.colNames[DbCoa.COL_CODE]);
%>
<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
    <head>
        <!-- #BeginEditable "javascript" --> 
        <title><%=systemTitle%></title>
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
        <link href="../css/default.css" rel="stylesheet" type="text/css" />
        <link href="../css/css.css" rel="stylesheet" type="text/css" />
        <script type="text/javascript" src="../highslide/highslide-with-html.js"></script>
        <link rel="stylesheet" type="text/css" href="../highslide/highslide.css" />
        <script type="text/javascript" src="<%=approot%>/main/jquery.min.js"></script>
        <script type="text/javascript" src="<%=approot%>/main/jquery.searchabledropdown.js"></script>
        <script type="text/javascript">
            $(document).ready(function() {
                $("select").searchable();
            });
            
            $(document).ready(function() {
                $("#value").html($("#searchabledropdown :selected").text() + " (VALUE: " + $("#searchabledropdown").val() + ")");
                $("select").change(function(){
                    $("#value").html(this.options[this.selectedIndex].text + " (VALUE: " + this.value + ")");
                });
            });
        </script>
        <script type="text/javascript">    
            hs.graphicsDir = '../highslide/graphics/';
            hs.outlineType = 'rounded-white';
            hs.outlineWhileAnimating = true;
        </script>
        <script type="text/javascript">
            hs.graphicsDir = '../highslide/graphics/';        
            
            hs.captionId = 'the-caption';
            
            hs.outlineType = 'rounded-white';
        </script>   
        <script language="JavaScript">
            <%if (!priv || !privView) {%>
            window.location="<%=approot%>/nopriv.jsp";
            <%}%>
            
            function cmdOpenModule(){
                window.open("<%=approot%>/transactionact/moduledtopen.jsp", null, "height=400,width=800, status=yes,toolbar=no,menubar=no,location=no, scrollbars=yes");
                }
                
                function cmdOpenCoa(){
                    var y = document.frmgl.coa_txt.value;	                    
                    window.open("<%=approot%>/transactionact/coalist.jsp?coa_select="+y, null, "height=400,width=800, status=yes,toolbar=no,menubar=no,location=no, scrollbars=yes");
                    }
                    
                    
                    
                    function cmdPrintJournal(){	 
                        window.open("<%=printroot%>.report.RptGLPDF?oid=<%=appSessUser.getLoginId()%>&gl_id=<%=gl.getOID()%>");
                        }
                        
                        function cmdClickMe(){
                            var x = document.frmgl.<%=JspGlDetail.colNames[JspGlDetail.JSP_FOREIGN_CURRENCY_AMOUNT]%>.value;	
                            document.frmgl.<%=JspGlDetail.colNames[JspGlDetail.JSP_FOREIGN_CURRENCY_AMOUNT]%>.select();
                        }
                        
                        
                        function cmdClickMe2(){
                            var x = document.frmgl.<%=JspGlDetail.colNames[JspGlDetail.JSP_BOOKED_RATE]%>.value;	
                            document.frmgl.<%=JspGlDetail.colNames[JspGlDetail.JSP_BOOKED_RATE]%>.select();                
                        }
                        
                        function cmdNewJournal(){	
                            document.frmgl.hidden_gl_id.value=0;
                            document.frmgl.hidden_gl_detail_id.value=0;
                            document.frmgl.command.value="<%=JSPCommand.NONE%>";
                            document.frmgl.action="gldetail.jsp";
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
                        
                        function updateDebetCredit(){                        
                            var dbt = document.frmgl.<%=JspGlDetail.colNames[JspGlDetail.JSP_IS_DEBET]%>.value;
                            var amount = document.frmgl.<%=JspGlDetail.colNames[JspGlDetail.JSP_FOREIGN_CURRENCY_AMOUNT]%>.value;
                            var erate = document.frmgl.<%=JspGlDetail.colNames[JspGlDetail.JSP_BOOKED_RATE]%>.value;
                            amount = removeChar(amount);
                            amount = cleanNumberFloat(amount, sysDecSymbol, usrDigitGroup, usrDecSymbol);
                            erate = removeChar(erate);
                            erate = cleanNumberFloat(erate, sysDecSymbol, usrDigitGroup, usrDecSymbol);   
                            
                            if(parseInt(dbt)==0){
                                document.frmgl.<%=jspGlDetail.colNames[jspGlDetail.JSP_DEBET]%>.value = formatFloat(parseFloat(amount) * parseFloat(erate), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);                 
                                document.frmgl.<%=jspGlDetail.colNames[jspGlDetail.JSP_CREDIT]%>.value = "0";
                            }else{
                            document.frmgl.<%=jspGlDetail.colNames[jspGlDetail.JSP_CREDIT]%>.value = formatFloat(parseFloat(amount) * parseFloat(erate), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);                 
                            document.frmgl.<%=jspGlDetail.colNames[jspGlDetail.JSP_DEBET]%>.value = "0";
                        }       
                    }
                    
                    function cmdAsking(oidGl){            
                        var cfrm = confirm('Are you sure you want to delete ?');            
                        if( cfrm==true){
                            document.frmgl.select_idx.value=-1;
                            document.frmgl.hidden_gl_id.value=oidGl;
                            document.frmgl.hidden_gl_detail_id.value=0;
                            document.frmgl.command.value="<%=JSPCommand.RESET%>";
                            document.frmgl.prev_command.value="<%=prevJSPCommand%>";
                            document.frmgl.action="gldetail13.jsp";
                            document.frmgl.submit();
                        }
                    }     
                    
                    function cmdUpdateExchange(){
                        
                        <%if (iJSPCommand != JSPCommand.BACK && !((iJSPCommand == JSPCommand.SUBMIT || iJSPCommand == JSPCommand.SAVE) && iErrCode == 0)) {%>	
                        
                        var isDebet = 0;
                        
                        isDebet = document.frmgl.<%=JspGlDetail.colNames[JspGlDetail.JSP_IS_DEBET]%>.value; 
                        
                        var idCurr = document.frmgl.<%=JspGlDetail.colNames[JspGlDetail.JSP_FOREIGN_CURRENCY_ID]%>.value;
                        
                 <%if (currencies != null && currencies.size() > 0) {
        for (int i = 0; i < currencies.size(); i++) {

            Currency cx = (Currency) currencies.get(i);
                 %>
                     if(idCurr=='<%=cx.getOID()%>'){
                         <%if (cx.getCurrencyCode().equals(IDRCODE)) {%>
                         document.frmgl.<%=JspGlDetail.colNames[JspGlDetail.JSP_BOOKED_RATE]%>.value="<%=eRate.getValueIdr()%>";
                         <%} else if (cx.getCurrencyCode().equals(USDCODE)) {%>
                         document.frmgl.<%=JspGlDetail.colNames[JspGlDetail.JSP_BOOKED_RATE]%>.value = formatFloat(<%=eRate.getValueUsd()%>, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 
                         <%} else if (cx.getCurrencyCode().equals(EURCODE)) {%>
                         document.frmgl.<%=JspGlDetail.colNames[JspGlDetail.JSP_BOOKED_RATE]%>.value= formatFloat(<%=eRate.getValueEuro()%>, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 
                         <%}%>
                     }	
                 <%}
    }%>
    
    var famount = document.frmgl.<%=JspGlDetail.colNames[JspGlDetail.JSP_FOREIGN_CURRENCY_AMOUNT]%>.value;
    
    famount = removeChar(famount);
    famount = cleanNumberFloat(famount, sysDecSymbol, usrDigitGroup, usrDecSymbol);
    
    var fbooked = document.frmgl.<%=JspGlDetail.colNames[JspGlDetail.JSP_BOOKED_RATE]%>.value;
    fbooked = cleanNumberFloat(fbooked, sysDecSymbol, usrDigitGroup, usrDecSymbol);
    
    if(!isNaN(famount)){
        
        if(parseInt(isDebet)==0){
            
            var defaultDebet = document.frmgl.<%=JspGlDetail.colNames[JspGlDetail.JSP_DEBET]%>.value;
            defaultDebet = cleanNumberFloat(defaultDebet, sysDecSymbol, usrDigitGroup, usrDecSymbol);
            
            document.frmgl.<%=JspGlDetail.colNames[JspGlDetail.JSP_DEBET]%>.value= formatFloat(parseFloat(famount) * parseFloat(fbooked), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); //;
            
            var credit = document.frmgl.<%=JspGlDetail.colNames[JspGlDetail.JSP_CREDIT]%>.value;
            credit = cleanNumberFloat(credit, sysDecSymbol, usrDigitGroup, usrDecSymbol);
            var totalCredit = document.frmgl.total_credit.value;
            totalCredit = cleanNumberFloat(totalCredit, sysDecSymbol, usrDigitGroup, usrDecSymbol);
            document.frmgl.total_credit.value= formatFloat(parseFloat(totalCredit) - parseFloat(credit), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);		
            
            var debet = document.frmgl.<%=JspGlDetail.colNames[JspGlDetail.JSP_DEBET]%>.value;
            debet = cleanNumberFloat(debet, sysDecSymbol, usrDigitGroup, usrDecSymbol);
            var totalDebet = document.frmgl.total_debet.value;
            totalDebet = cleanNumberFloat(totalDebet, sysDecSymbol, usrDigitGroup, usrDecSymbol);
            document.frmgl.total_debet.value= formatFloat(parseFloat(totalDebet) - parseFloat(defaultDebet) + parseFloat(debet), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);		
            
            document.frmgl.<%=JspGlDetail.colNames[JspGlDetail.JSP_CREDIT]%>.value= "0.00";
            
        }else{			
        
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
        
        document.frmgl.<%=JspGlDetail.colNames[JspGlDetail.JSP_DEBET]%>.value= "0.00";
    }
    document.frmgl.<%=JspGlDetail.colNames[JspGlDetail.JSP_FOREIGN_CURRENCY_AMOUNT]%>.value= formatFloat(famount, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);
    
}
<%}%>	

var totalDebetx = document.frmgl.total_debet.value;
totalDebetx = cleanNumberFloat(totalDebetx, sysDecSymbol, usrDigitGroup, usrDecSymbol);
var totalCreditx = document.frmgl.total_credit.value;
totalCreditx = cleanNumberFloat(totalCreditx, sysDecSymbol, usrDigitGroup, usrDecSymbol);
if(parseFloat(totalDebetx)==parseFloat(totalCreditx)){
    document.all.tot_balance.innerHTML = "-";
}
else{	
    document.all.tot_balance.innerHTML = formatFloat(parseFloat(totalDebetx)-parseFloat(totalCreditx), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);
}
}


function cmdUpdateExchange2(){
    
    <%if (iJSPCommand != JSPCommand.BACK && !((iJSPCommand == JSPCommand.SUBMIT || iJSPCommand == JSPCommand.SAVE) && iErrCode == 0)) {%>	    
    var isDebet = 0;    
    isDebet = document.frmgl.<%=JspGlDetail.colNames[JspGlDetail.JSP_IS_DEBET]%>.value;     
    var idCurr = document.frmgl.<%=JspGlDetail.colNames[JspGlDetail.JSP_FOREIGN_CURRENCY_ID]%>.value;    
    var famount = document.frmgl.<%=JspGlDetail.colNames[JspGlDetail.JSP_FOREIGN_CURRENCY_AMOUNT]%>.value;    
    famount = removeChar(famount);
    famount = cleanNumberFloat(famount, sysDecSymbol, usrDigitGroup, usrDecSymbol);    
    var fbooked = document.frmgl.<%=JspGlDetail.colNames[JspGlDetail.JSP_BOOKED_RATE]%>.value;
    fbooked = cleanNumberFloat(fbooked, sysDecSymbol, usrDigitGroup, usrDecSymbol);    
    if(!isNaN(famount)){        
        if(parseInt(isDebet)==0){            
            var defaultDebet = document.frmgl.<%=JspGlDetail.colNames[JspGlDetail.JSP_DEBET]%>.value;
            defaultDebet = cleanNumberFloat(defaultDebet, sysDecSymbol, usrDigitGroup, usrDecSymbol);
            
            document.frmgl.<%=JspGlDetail.colNames[JspGlDetail.JSP_DEBET]%>.value= formatFloat(parseFloat(famount) * parseFloat(fbooked), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); //;
            
            var credit = document.frmgl.<%=JspGlDetail.colNames[JspGlDetail.JSP_CREDIT]%>.value;
            credit = cleanNumberFloat(credit, sysDecSymbol, usrDigitGroup, usrDecSymbol);
            var totalCredit = document.frmgl.total_credit.value;
            totalCredit = cleanNumberFloat(totalCredit, sysDecSymbol, usrDigitGroup, usrDecSymbol);
            document.frmgl.total_credit.value= formatFloat(parseFloat(totalCredit) - parseFloat(credit), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);	
            
            var debet = document.frmgl.<%=JspGlDetail.colNames[JspGlDetail.JSP_DEBET]%>.value;
            debet = cleanNumberFloat(debet, sysDecSymbol, usrDigitGroup, usrDecSymbol);
            var totalDebet = document.frmgl.total_debet.value;
            totalDebet = cleanNumberFloat(totalDebet, sysDecSymbol, usrDigitGroup, usrDecSymbol);
            document.frmgl.total_debet.value= formatFloat(parseFloat(totalDebet) - parseFloat(defaultDebet) + parseFloat(debet), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 		
            
            document.frmgl.<%=JspGlDetail.colNames[JspGlDetail.JSP_CREDIT]%>.value= "0.00";
            
        }else{			
        
        var defaultCredit = document.frmgl.<%=JspGlDetail.colNames[JspGlDetail.JSP_CREDIT]%>.value;
        defaultCredit = cleanNumberFloat(defaultCredit, sysDecSymbol, usrDigitGroup, usrDecSymbol);
        
        document.frmgl.<%=JspGlDetail.colNames[JspGlDetail.JSP_CREDIT]%>.value= formatFloat(parseFloat(famount) * parseFloat(fbooked), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);
        
        var debet = document.frmgl.<%=JspGlDetail.colNames[JspGlDetail.JSP_DEBET]%>.value;
        debet = cleanNumberFloat(debet, sysDecSymbol, usrDigitGroup, usrDecSymbol);
        var totalDebet = document.frmgl.total_debet.value;
        totalDebet = cleanNumberFloat(totalDebet, sysDecSymbol, usrDigitGroup, usrDecSymbol);
        document.frmgl.total_debet.value= formatFloat(parseFloat(totalDebet) - parseFloat(debet), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);		
        
        var credit = document.frmgl.<%=JspGlDetail.colNames[JspGlDetail.JSP_CREDIT]%>.value;
        credit = cleanNumberFloat(credit, sysDecSymbol, usrDigitGroup, usrDecSymbol);
        var totalCredit = document.frmgl.total_credit.value;
        totalCredit = cleanNumberFloat(totalCredit, sysDecSymbol, usrDigitGroup, usrDecSymbol);
        document.frmgl.total_credit.value= formatFloat(parseFloat(totalCredit) -parseFloat(defaultCredit) + parseFloat(credit), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);		
        
        document.frmgl.<%=JspGlDetail.colNames[JspGlDetail.JSP_DEBET]%>.value= "0.00";
    }
    
    document.frmgl.<%=JspGlDetail.colNames[JspGlDetail.JSP_FOREIGN_CURRENCY_AMOUNT]%>.value= formatFloat(famount, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);
}
<%}%>	

var totalDebetx = document.frmgl.total_debet.value;
totalDebetx = cleanNumberFloat(totalDebetx, sysDecSymbol, usrDigitGroup, usrDecSymbol);
var totalCreditx = document.frmgl.total_credit.value;
totalCreditx = cleanNumberFloat(totalCreditx, sysDecSymbol, usrDigitGroup, usrDecSymbol);
if(parseFloat(totalDebetx)==parseFloat(totalCreditx)){
    document.all.tot_balance.innerHTML = "-";
}else{	
document.all.tot_balance.innerHTML = formatFloat(parseFloat(totalDebetx)-parseFloat(totalCreditx), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);
}

}

function cmdUpdateExchange3(){
    
    <%if (iJSPCommand != JSPCommand.BACK && !((iJSPCommand == JSPCommand.SUBMIT || iJSPCommand == JSPCommand.SAVE) && iErrCode == 0)) {%>	
    
    var isDebet = 0;    
    isDebet = document.frmgl.<%=JspGlDetail.colNames[JspGlDetail.JSP_IS_DEBET]%>.value;     
    var idCurr = document.frmgl.<%=JspGlDetail.colNames[JspGlDetail.JSP_FOREIGN_CURRENCY_ID]%>.value;    
    var famount = document.frmgl.<%=JspGlDetail.colNames[JspGlDetail.JSP_FOREIGN_CURRENCY_AMOUNT]%>.value;    
    famount = removeChar(famount);
    famount = cleanNumberFloat(famount, sysDecSymbol, usrDigitGroup, usrDecSymbol);    
    var fbooked = document.frmgl.<%=JspGlDetail.colNames[JspGlDetail.JSP_BOOKED_RATE]%>.value;
    fbooked = cleanNumberFloat(fbooked, sysDecSymbol, usrDigitGroup, usrDecSymbol);    
    if(!isNaN(famount)){
        
        if(parseInt(isDebet)==0){
            
            var defaultDebet = document.frmgl.<%=JspGlDetail.colNames[JspGlDetail.JSP_DEBET]%>.value;
            defaultDebet = cleanNumberFloat(defaultDebet, sysDecSymbol, usrDigitGroup, usrDecSymbol);
            
            document.frmgl.<%=JspGlDetail.colNames[JspGlDetail.JSP_DEBET]%>.value= formatFloat(parseFloat(famount) * parseFloat(fbooked), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); //;
            
            var credit = document.frmgl.<%=JspGlDetail.colNames[JspGlDetail.JSP_CREDIT]%>.value;
            credit = cleanNumberFloat(credit, sysDecSymbol, usrDigitGroup, usrDecSymbol);
            var totalCredit = document.frmgl.total_credit.value;
            totalCredit = cleanNumberFloat(totalCredit, sysDecSymbol, usrDigitGroup, usrDecSymbol);
            document.frmgl.total_credit.value= formatFloat(parseFloat(totalCredit) - parseFloat(credit), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);	
            
            var debet = document.frmgl.<%=JspGlDetail.colNames[JspGlDetail.JSP_DEBET]%>.value;
            debet = cleanNumberFloat(debet, sysDecSymbol, usrDigitGroup, usrDecSymbol);
            var totalDebet = document.frmgl.total_debet.value;
            totalDebet = cleanNumberFloat(totalDebet, sysDecSymbol, usrDigitGroup, usrDecSymbol);
            document.frmgl.total_debet.value= formatFloat(parseFloat(totalDebet) - parseFloat(defaultDebet) + parseFloat(debet), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 		
            
            document.frmgl.<%=JspGlDetail.colNames[JspGlDetail.JSP_CREDIT]%>.value= "0.00";
            
        }else{			
        
        var defaultCredit = document.frmgl.<%=JspGlDetail.colNames[JspGlDetail.JSP_CREDIT]%>.value;
        defaultCredit = cleanNumberFloat(defaultCredit, sysDecSymbol, usrDigitGroup, usrDecSymbol);
        
        document.frmgl.<%=JspGlDetail.colNames[JspGlDetail.JSP_CREDIT]%>.value= formatFloat(parseFloat(famount) * parseFloat(fbooked), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);
        
        var debet = document.frmgl.<%=JspGlDetail.colNames[JspGlDetail.JSP_DEBET]%>.value;
        debet = cleanNumberFloat(debet, sysDecSymbol, usrDigitGroup, usrDecSymbol);
        var totalDebet = document.frmgl.total_debet.value;
        totalDebet = cleanNumberFloat(totalDebet, sysDecSymbol, usrDigitGroup, usrDecSymbol);
        document.frmgl.total_debet.value= formatFloat(parseFloat(totalDebet) - parseFloat(debet), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);		
        
        var credit = document.frmgl.<%=JspGlDetail.colNames[JspGlDetail.JSP_CREDIT]%>.value;
        credit = cleanNumberFloat(credit, sysDecSymbol, usrDigitGroup, usrDecSymbol);
        var totalCredit = document.frmgl.total_credit.value;
        totalCredit = cleanNumberFloat(totalCredit, sysDecSymbol, usrDigitGroup, usrDecSymbol);
        document.frmgl.total_credit.value= formatFloat(parseFloat(totalCredit) -parseFloat(defaultCredit) + parseFloat(credit), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);		
        
        document.frmgl.<%=JspGlDetail.colNames[JspGlDetail.JSP_DEBET]%>.value= "0.00";
    }
    
    document.frmgl.<%=JspGlDetail.colNames[JspGlDetail.JSP_FOREIGN_CURRENCY_AMOUNT]%>.value= formatFloat(famount, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);
}
<%}%>	

var totalDebetx = document.frmgl.total_debet.value;
totalDebetx = cleanNumberFloat(totalDebetx, sysDecSymbol, usrDigitGroup, usrDecSymbol);
var totalCreditx = document.frmgl.total_credit.value;
totalCreditx = cleanNumberFloat(totalCreditx, sysDecSymbol, usrDigitGroup, usrDecSymbol);
if(parseFloat(totalDebetx)==parseFloat(totalCreditx)){
    document.all.tot_balance.innerHTML = "-";
}else{	
document.all.tot_balance.innerHTML = formatFloat(parseFloat(totalDebetx)-parseFloat(totalCreditx), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);
}

var xbook = document.frmgl.<%=JspGlDetail.colNames[JspGlDetail.JSP_BOOKED_RATE]%>.value;	
document.frmgl.<%=JspGlDetail.colNames[JspGlDetail.JSP_BOOKED_RATE]%>.value= formatFloat(xbook, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);
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
    var numb = document.frmgl.jurnal_number.value;  
    window.open("<%=approot%>/transactionact/s_gl.jsp?formName=frmgl&txt_Id=gl_id&txt_Name=jurnal_number&txt_jurnal=\'"+numb+"'&command=<%=JSPCommand.SEARCH%>", null, "height=400,width=600, status=yes,toolbar=no,menubar=no,location=no, scrollbars=yes");
    }
    
    function cmdAdd(){	
        document.frmgl.select_idx.value="-1";
        document.frmgl.hidden_gl_detail_id.value="0";
        document.frmgl.command.value="<%=JSPCommand.ADD%>";
        document.frmgl.prev_command.value="<%=prevJSPCommand%>";
        document.frmgl.action="gldetail.jsp";
        document.frmgl.submit();
    }
    
    function cmdAsk(oidGlDetail){
        document.frmgl.select_idx.value=oidGlDetail;
        document.frmgl.hidden_gl_detail_id.value=oidGlDetail;
        document.frmgl.command.value="<%=JSPCommand.ASK%>";
        document.frmgl.prev_command.value="<%=prevJSPCommand%>";
        document.frmgl.action="gldetail.jsp";
        document.frmgl.submit();
    }
    
    function cmdConfirmDelete(oidGlDetail){
        document.frmgl.hidden_gl_detail_id.value=oidGlDetail;
        document.frmgl.command.value="<%=JSPCommand.DELETE%>";
        document.frmgl.prev_command.value="<%=prevJSPCommand%>";
        document.frmgl.action="gldetail.jsp";
        document.frmgl.submit();
    }
    
    function cmdSave(){
        document.frmgl.command.value="<%=JSPCommand.SUBMIT%>";
        document.frmgl.prev_command.value="<%=prevJSPCommand%>";
        document.frmgl.action="gldetail.jsp";
        document.frmgl.submit();
    }
    
    function cmdSubmitCommand(){
        document.frmgl.command.value="<%=JSPCommand.SAVE%>";
        document.frmgl.prev_command.value="<%=prevJSPCommand%>";
        document.frmgl.action="gldetail.jsp";
        document.frmgl.submit();
    }
    
    function cmdBack(){
        document.frmgl.command.value="<%=JSPCommand.BACK%>";
        document.frmgl.action="gldetail.jsp";
        document.frmgl.submit();
    }
    
    function cmdEdit(oidGlDetail){
        <%if (privUpdate) {%>
        document.frmgl.select_idx.value=oidGlDetail;
        document.frmgl.hidden_gl_detail_id.value=oidGlDetail;
        document.frmgl.command.value="<%=JSPCommand.EDIT%>";
        document.frmgl.prev_command.value="<%=prevJSPCommand%>";
        document.frmgl.action="gldetail.jsp";
        document.frmgl.submit();
        <%}%>
    }
    
    function cmdDelPict(oidGlDetail){
        document.frmimage.hidden_gl_detail_id.value=oidGlDetail;
        document.frmimage.command.value="<%=JSPCommand.POST%>";
        document.frmimage.action="gldetail.jsp";
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
                                                <tr> 
                                                    <td><!-- #BeginEditable "content" --> 
                                                        <form name="frmgl" method ="post" action="">
                                                            <input type="hidden" name="command" value="<%=iJSPCommand%>">
                                                            <input type="hidden" name="vectSize" value="<%=vectSize%>">
                                                            <input type="hidden" name="start" value="<%=start%>">
                                                            <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                                                            <input type="hidden" name="hidden_gl_detail_id" value="<%=oidGlDetail%>">
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
                                                                                                        <td width="31">&nbsp;</td>
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
                                                                                                <table width="100%" border="0" cellspacing="1" cellpadding="0">
                                                                                                    <tr> 
                                                                                                        <td colspan="5" height="6">
                                                                                                            <table border="0" cellspacing="3" cellpadding="3" bgcolor="#F3F3F3">                                                                                                            
                                                                                                                <%
            String jur_number = "";
            long glId = 0;

            if (isLoad) {
                jur_number = gl.getJournalNumber();
                glId = gl.getOID();
            }
                                                                                                                %>
                                                                                                                <tr>
                                                                                                                    <td><font face="arial"><b><%=langGL[15]%></b></font></td>
                                                                                                                    <td>&nbsp;</td>
                                                                                                                    <td>&nbsp;</td>
                                                                                                                </tr>
                                                                                                                <tr>
                                                                                                                    <td class="fontarial"><%=langGL[0]%></td>
                                                                                                                    <td><input size="20" type="text" name="jurnal_number" value="<%=jur_number%>"></td>
                                                                                                                    <td><input type="hidden" name="gl_id" value="<%=glId%>">
                                                                                                                        <a href="javascript:cmdSearchJurnal()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new21','','../images/search.jpg',1)"><img src="../images/search2.jpg" name="new211" height="17" border="0" style="padding:0px"></a> 
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                                <tr height="5">
                                                                                                                    <td colspan="4"></td>
                                                                                                                </tr>
                                                                                                            </table>
                                                                                                        </td>
                                                                                                    </tr>  
                                                                                                    <tr> 
                                                                                                        <td colspan = "5">&nbsp;</td>
                                                                                                    </tr>
                                                                                                    <tr> 
                                                                                                        <td colspan="5" width="100%"> 
                                                                                                            <table width="70%" border="0" cellspacing="0" cellpadding="0">                                                                                                                
                                                                                                                <tr> 
                                                                                                                    <td height="2" background="../images/line.gif" ><img src="../images/line.gif"></td>
                                                                                                                </tr>
                                                                                                            </table>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <tr> 
                                                                                                        <td colspan="5" height="6"></td>
                                                                                                    </tr>
                                                                                                    <tr> 
                                                                                                        <td colspan="5" >
                                                                                                            <table width="700" border="0" cellspacing="0" cellpadding="0">
                                                                                                                <tr>                                                                                                                                            
                                                                                                                    <td class="tablecell1" > 
                                                                                                                        <table width="100%" border="0" style="border:1px solid #ABA8A8" cellspacing="2" cellpadding="1">
                                                                                                                            <tr> 
                                                                                                                                <td height="6" width="5"></td>
                                                                                                                                <td colspan="5" height="6"></td>
                                                                                                                            </tr>                                                                                                                           
                                                                                                                            <tr> 
                                                                                                                                <td width="5"></td>
                                                                                                                                <td width="80"><%=langGL[0]%></td>
                                                                                                                                <td width="5">&nbsp;</td>
                                                                                                                                <td width="300"> 
                                                                                                                                    <%
            Periode open = new Periode();

            Vector periods = DbPeriode.list(0, 0, DbPeriode.colNames[DbPeriode.COL_STATUS] + "='" + I_Project.STATUS_PERIOD_PRE_CLOSED + "' or " + DbPeriode.colNames[DbPeriode.COL_STATUS] + "='" + I_Project.STATUS_PERIOD_OPEN + "'", "" + DbPeriode.colNames[DbPeriode.COL_START_DATE] + " desc ");
            if (periods != null && periods.size() > 0) {
                for (int i = 0; i < periods.size(); i++) {
                    Periode p = (Periode) periods.get(i);
                    if (i == 0) {
                        open = p;
                        break;
                    }
                }
            }

            if (gl.getPeriodId() != 0) {
                try {
                    open = DbPeriode.fetchExc(gl.getPeriodId());
                } catch (Exception e) {
                }
            }

            int counter = DbSystemDocNumber.getNextCounterGl(open.getOID());
            String strNumber = DbSystemDocNumber.getNextNumberGl(counter, open.getOID());

            if (gl.getOID() != 0) {
                strNumber = gl.getJournalNumber();
            }
                                                                                                                                    %>
                                                                                                                                    <%=strNumber%> 
                                                                                                                                    <input type="hidden" name="<%=JspGl.colNames[JspGl.JSP_JOURNAL_NUMBER]%>">
                                                                                                                                    <input type="hidden" name="<%=JspGl.colNames[JspGl.JSP_JOURNAL_COUNTER]%>">
                                                                                                                                    <input type="hidden" name="<%=JspGl.colNames[JspGl.JSP_JOURNAL_PREFIX]%>">
                                                                                                                                </td>
                                                                                                                                <td width="17%">
                                                                                                                                    <%if (periods != null && periods.size() > 1) {%>
                                                                                                                                    <%=langGL[18]%>
                                                                                                                                    <%} else {%>
                                                                                                                                    &nbsp;
                                                                                                                                    <%}%>
                                                                                                                                </td>
                                                                                                                                <td >
                                                                                                                                    <%if (open.getStatus().equals("Closed") || gl.getOID() != 0) {%>
                                                                                                                                    <%=open.getName()%>
                                                                                                                                    <input type="hidden" name="<%=JspGl.colNames[JspGl.JSP_PERIOD_ID]%>" value="<%=open.getOID()%>">
                                                                                                                                    <%} else {%>
                                                                                                                                    <%if (periods != null && periods.size() > 1) {%>
                                                                                                                                    <select name="<%=JspGl.colNames[JspGl.JSP_PERIOD_ID]%>">
                                                                                                                                        <%
    if (periods != null && periods.size() > 0) {
        for (int t = 0; t < periods.size(); t++) {
            Periode objPeriod = (Periode) periods.get(t);
                                                                                                                                        %>
                                                                                                                                        <option value ="<%=objPeriod.getOID()%>" <%if (objPeriod.getOID() == gl.getPeriodId()) {%>selected<%}%> ><%=objPeriod.getName()%></option>
                                                                                                                                        <%}%>
                                                                                                                                        <%}%>
                                                                                                                                    </select>
                                                                                                                                    <%} else {%>
                                                                                                                                    <input type="hidden" name="<%=JspGl.colNames[JspGl.JSP_PERIOD_ID]%>" value="<%=open.getOID()%>">
                                                                                                                                    <%}%>
                                                                                                                                    <%}%>
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                            <tr> 
                                                                                                                                <td width="5"></td>
                                                                                                                                <td ><%=langGL[2]%></td>
                                                                                                                                <td >&nbsp;</td>
                                                                                                                                <td > 
                                                                                                                                    <input type="text" name="<%=JspGl.colNames[JspGl.JSP_REF_NUMBER]%>" size="36" value="<%=gl.getRefNumber()%>">
                                                                                                                                <%= jspGl.getErrorMsg(jspGl.JSP_REF_NUMBER) %> </td>
                                                                                                                                <td ><%=langGL[1]%></td>
                                                                                                                                <td >
                                                                                                                                    <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                                        <tr>
                                                                                                                                            <td>
                                                                                                                                                <input name="<%=JspGl.colNames[JspGl.JSP_TRANS_DATE] %>" value="<%=JSPFormater.formatDate((gl.getTransDate() == null) ? new Date() : gl.getTransDate(), "dd/MM/yyyy")%>" size="11">
                                                                                                                                            </td>    
                                                                                                                                            <td>
                                                                                                                                                <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmgl.<%=JspGl.colNames[JspGl.JSP_TRANS_DATE] %>);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> 
                                                                                                                                            </td>
                                                                                                                                            <td>
                                                                                                                                                <%= jspGl.getErrorMsg(jspGl.JSP_TRANS_DATE) %> 
                                                                                                                                            </td>                                                                                                                                    
                                                                                                                                        </tr>
                                                                                                                                    </table>
                                                                                                                                </td>
                                                                                                                            </tr>   
                                                                                                                            <tr> 
                                                                                                                                <td width="5"></td>
                                                                                                                                <td valign="top"><%=langGL[17]%></td>
                                                                                                                                <td >&nbsp;</td>
                                                                                                                                <td valign="top">
                                                                                                                                    <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                                        <tr>
                                                                                                                                            <td>
                                                                                                                                                <textarea name="<%=JspGl.colNames[JspGl.JSP_MEMO]%>" cols="33" rows="3"><%=gl.getMemo()%></textarea>
                                                                                                                                            </td>
                                                                                                                                            <td valign="top">
                                                                                                                                                &nbsp;<%= jspGl.getErrorMsg(JspGl.JSP_MEMO) %> 
                                                                                                                                            </td>
                                                                                                                                        </tr>   
                                                                                                                                    </table>   
                                                                                                                                </td>
                                                                                                                                <td colspan="2">&nbsp;</td>                                                                                                                                
                                                                                                                            </tr> 
                                                                                                                            <tr>
                                                                                                                                <td colspan="6" height="10"></td>
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
                                                                                </td>
                                                                            </tr>
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="14" valign="middle" colspan="3" class="comment"> 
                                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">                                                                                                                                                                          
                                                                                        <tr> 
                                                                                            <td> 
                                                                                                <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                                                                                    <tr> 
                                                                                                        <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="100%" height="10"></td>                                                                                                       
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
                                                                                                                <tr>
                                                                                                                    <td rowspan="2" class="tablehdr" nowrap width="15%"></td>
                                                                                                                    <td rowspan="2" class="tablehdr" nowrap width="21%"><%=langGL[4]%></td>                                                                                                                    
                                                                                                                    <td colspan="2" class="tablehdr"><%=langGL[6]%></td>
                                                                                                                    <td rowspan="2" class="tablehdr" width="7%"><%=langGL[9]%></td>
                                                                                                                    <td rowspan="2" class="tablehdr" width="12%"><%=langGL[10]%> <%=baseCurrency.getCurrencyCode()%></td>
                                                                                                                    <td rowspan="2" class="tablehdr" width="12%"><%=langGL[11]%> <%=baseCurrency.getCurrencyCode()%> </td>
                                                                                                                    <td rowspan="2" class="tablehdr" ><%=langGL[12]%></td>
                                                                                                                </tr>
                                                                                                                <tr> 
                                                                                                                    <td width="4%" class="tablehdr"><%=langGL[7]%></td>
                                                                                                                    <td width="10%" class="tablehdr"><%=langGL[8]%></td>
                                                                                                                </tr>
                                                                                                                <%

            long selectModuleId = 0;
            if (listGlDetail != null && listGlDetail.size() > 0) {
                int ct = 0;
                for (int i = 0; i < listGlDetail.size(); i++) {
                    GlDetail crd = (GlDetail) listGlDetail.get(i);

                    if (crd.getDebet() > 0) {
                        crd.setIsDebet(0);
                    } else {
                        crd.setIsDebet(1);
                    }

                    Coa c = new Coa();
                    try {
                        c = DbCoa.fetchExc(crd.getCoaId());
                        if (i == 0) {
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



                    if (((iJSPCommand == JSPCommand.EDIT || iJSPCommand == JSPCommand.ASK) || (iJSPCommand == JSPCommand.SUBMIT && iErrCode != 0)) && i == recIdx) {%>
                                                                                                                <tr>
                                                                                                                    <td class="tablecell" width="21%"> 
                                                                                                                        <div align="center"> 
                                                                                                                            <table width="49%" border="0" cellspacing="0" cellpadding="0">                                                                                                                                
                                                                                                                                <tr > 
                                                                                                                                    <td width="62%" nowrap> 
                                                                                                                                        <div align="center"> 
                                                                                                                                            <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                                                                                                <%

                                                                                                                                        if (segments != null && segments.size() > 0) {
                                                                                                                                            for (int xx = 0; xx < segments.size(); xx++) {
                                                                                                                                                Segment seg = (Segment) segments.get(xx);
                                                                                                                                                Vector sgDetails = DbSegmentDetail.list(0, 0, "segment_id=" + seg.getOID(), DbSegmentDetail.colNames[DbSegmentDetail.COL_CODE]);

                                                                                                                                                %>
                                                                                                                                                <tr> 
                                                                                                                                                    <td width="54%" nowrap><%=seg.getName()%></td>
                                                                                                                                                    <td width="46%">                                                                                                                                                         
                                                                                                                                                        <select name="JSP_SEGMENT<%=xx + 1%>_ID">
                                                                                                                                                            <%if (sgDetails != null && sgDetails.size() > 0) {
                                                                                                                                                                                                                                                                                                    for (int x = 0; x < sgDetails.size(); x++) {
                                                                                                                                                                                                                                                                                                        SegmentDetail sd = (SegmentDetail) sgDetails.get(x);
                                                                                                                                                                                                                                                                                                        String selected = "";
                                                                                                                                                                                                                                                                                                        switch (xx + 1) {
                                                                                                                                                                                                                                                                                                            case 1:
                                                                                                                                                                                                                                                                                                                if (crd.getSegment1Id() == sd.getOID()) {
                                                                                                                                                                                                                                                                                                                    selected = "selected";
                                                                                                                                                                                                                                                                                                                }
                                                                                                                                                                                                                                                                                                                break;
                                                                                                                                                                                                                                                                                                            case 2:
                                                                                                                                                                                                                                                                                                                if (crd.getSegment2Id() == sd.getOID()) {
                                                                                                                                                                                                                                                                                                                    selected = "selected";
                                                                                                                                                                                                                                                                                                                }
                                                                                                                                                                                                                                                                                                                break;
                                                                                                                                                                                                                                                                                                            case 3:
                                                                                                                                                                                                                                                                                                                if (crd.getSegment3Id() == sd.getOID()) {
                                                                                                                                                                                                                                                                                                                    selected = "selected";
                                                                                                                                                                                                                                                                                                                }
                                                                                                                                                                                                                                                                                                                break;
                                                                                                                                                                                                                                                                                                            case 4:
                                                                                                                                                                                                                                                                                                                if (crd.getSegment4Id() == sd.getOID()) {
                                                                                                                                                                                                                                                                                                                    selected = "selected";
                                                                                                                                                                                                                                                                                                                }
                                                                                                                                                                                                                                                                                                                break;
                                                                                                                                                                                                                                                                                                            case 5:
                                                                                                                                                                                                                                                                                                                if (crd.getSegment5Id() == sd.getOID()) {
                                                                                                                                                                                                                                                                                                                    selected = "selected";
                                                                                                                                                                                                                                                                                                                }
                                                                                                                                                                                                                                                                                                                break;
                                                                                                                                                                                                                                                                                                            case 6:
                                                                                                                                                                                                                                                                                                                if (crd.getSegment6Id() == sd.getOID()) {
                                                                                                                                                                                                                                                                                                                    selected = "selected";
                                                                                                                                                                                                                                                                                                                }
                                                                                                                                                                                                                                                                                                                break;
                                                                                                                                                                                                                                                                                                            case 7:
                                                                                                                                                                                                                                                                                                                if (crd.getSegment7Id() == sd.getOID()) {
                                                                                                                                                                                                                                                                                                                    selected = "selected";
                                                                                                                                                                                                                                                                                                                }
                                                                                                                                                                                                                                                                                                                break;
                                                                                                                                                                                                                                                                                                            case 8:
                                                                                                                                                                                                                                                                                                                if (crd.getSegment8Id() == sd.getOID()) {
                                                                                                                                                                                                                                                                                                                    selected = "selected";
                                                                                                                                                                                                                                                                                                                }
                                                                                                                                                                                                                                                                                                                break;
                                                                                                                                                                                                                                                                                                            case 9:
                                                                                                                                                                                                                                                                                                                if (crd.getSegment9Id() == sd.getOID()) {
                                                                                                                                                                                                                                                                                                                    selected = "selected";
                                                                                                                                                                                                                                                                                                                }
                                                                                                                                                                                                                                                                                                                break;
                                                                                                                                                                                                                                                                                                            case 10:
                                                                                                                                                                                                                                                                                                                if (crd.getSegment10Id() == sd.getOID()) {
                                                                                                                                                                                                                                                                                                                    selected = "selected";
                                                                                                                                                                                                                                                                                                                }
                                                                                                                                                                                                                                                                                                                break;
                                                                                                                                                                                                                                                                                                            case 11:
                                                                                                                                                                                                                                                                                                                if (crd.getSegment11Id() == sd.getOID()) {
                                                                                                                                                                                                                                                                                                                    selected = "selected";
                                                                                                                                                                                                                                                                                                                }
                                                                                                                                                                                                                                                                                                                break;
                                                                                                                                                                                                                                                                                                            case 12:
                                                                                                                                                                                                                                                                                                                if (crd.getSegment12Id() == sd.getOID()) {
                                                                                                                                                                                                                                                                                                                    selected = "selected";
                                                                                                                                                                                                                                                                                                                }
                                                                                                                                                                                                                                                                                                                break;
                                                                                                                                                                                                                                                                                                            case 13:
                                                                                                                                                                                                                                                                                                                if (crd.getSegment13Id() == sd.getOID()) {
                                                                                                                                                                                                                                                                                                                    selected = "selected";
                                                                                                                                                                                                                                                                                                                }
                                                                                                                                                                                                                                                                                                                break;
                                                                                                                                                                                                                                                                                                            case 14:
                                                                                                                                                                                                                                                                                                                if (crd.getSegment14Id() == sd.getOID()) {
                                                                                                                                                                                                                                                                                                                    selected = "selected";
                                                                                                                                                                                                                                                                                                                }
                                                                                                                                                                                                                                                                                                                break;
                                                                                                                                                                                                                                                                                                            case 15:
                                                                                                                                                                                                                                                                                                                if (crd.getSegment15Id() == sd.getOID()) {
                                                                                                                                                                                                                                                                                                                    selected = "selected";
                                                                                                                                                                                                                                                                                                                }
                                                                                                                                                                                                                                                                                                                break;

                                                                                                                                                                                                                                                                                                            //.... lanjut

                                                                                                                                                                                                                                                                                                        }
                                                                                                                                                            %>
                                                                                                                                                            <option value="<%=sd.getOID()%>" <%=selected%>><%=sd.getName()%></option>
                                                                                                                                                            <%}
                                                                                                                                                                                                                                                                                                }%>
                                                                                                                                                        </select>
                                                                                                                                                    </td>
                                                                                                                                                </tr>
                                                                                                                                                <%}
                                                                                                                                        }%>
                                                                                                                                            </table>
                                                                                                                                        </div>
                                                                                                                                    </td>                                                                                                                                    
                                                                                                                                </tr>
                                                                                                                            </table>
                                                                                                                        </div>
                                                                                                                    </td>
                                                                                                                    <td class="tablecell" width="21%"> 
                                                                                                                        <div align="center"> 
                                                                                                                            <select name="<%=JspGlDetail.colNames[JspGlDetail.JSP_COA_ID]%>">
                                                                                                                                <%if (coas != null && coas.size() > 0) {
                                                                                                                                            for (int x = 0; x < coas.size(); x++) {
                                                                                                                                                Coa coax = (Coa) coas.get(x);
                                                                                                                                                String str = "";

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

                                                                                                                                %>
                                                                                                                                <option value="<%=coax.getOID()%>" <%if (crd.getCoaId() == coax.getOID()) {%>selected<%}%>><%=str + coax.getCode() + " - " + coax.getName()%></option>
                                                                                                                                 
                                                                                                                                <%}
                                                                                                                                        }%>
                                                                                                                            </select>  
                                                                                                                        <%= jspGlDetail.getErrorMsg(JspGlDetail.JSP_COA_ID) %> </div>
                                                                                                                    </td>                                                                                                               
                                                                                                                    <td width="4%" class="tablecell"> 
                                                                                                                        <div align="center"> 
                                                                                                                            <select name="<%=JspGlDetail.colNames[JspGlDetail.JSP_FOREIGN_CURRENCY_ID]%>" onChange="javascript:cmdUpdateExchange()">
                                                                                                                                <%
                                                                                                                                        if (currencies != null && currencies.size() > 0) {
                                                                                                                                            for (int x = 0; x < currencies.size(); x++) {
                                                                                                                                                Currency cx = (Currency) currencies.get(x);
                                                                                                                                %>
                                                                                                                                <option value="<%=cx.getOID()%>" <%if (crd.getForeignCurrencyId() == cx.getOID()) {%>selected<%}%>><%=cx.getCurrencyCode()%></option>
                                                                                                                                <%}
                                                                                                                                        }%>
                                                                                                                            </select>
                                                                                                                        </div>                                                      
                                                                                                                    </td>
                                                                                                                    <td width="19%" class="tablecell" nowrap> 
                                                                                                                        <div align="center"> 
                                                                                                                            <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                                <tr>
                                                                                                                                    <td>
                                                                                                                                        <select name="<%=JspGlDetail.colNames[JspGlDetail.JSP_IS_DEBET]%>" onChange="javascript:updateDebetCredit()">
                                                                                                                                            <option value="0" <%if (crd.getIsDebet() == 0) {%>selected<%}%>>DEBET</option>
                                                                                                                                            <option value="1" <%if (crd.getIsDebet() == 1) {%>selected<%}%>>CREDIT</option>
                                                                                                                                        </select>
                                                                                                                                    </td>
                                                                                                                                    <td>
                                                                                                                                        <input type="text" name="<%=JspGlDetail.colNames[JspGlDetail.JSP_FOREIGN_CURRENCY_AMOUNT]%>" size="15" value="<%=JSPFormater.formatNumber(crd.getForeignCurrencyAmount(), "#,###.##")%>" style="text-align:right" onBlur="javascript:cmdUpdateExchange2()" onClick="javascript:cmdClickMe()">
                                                                                                                                    </td>
                                                                                                                                    <td>
                                                                                                                                        <%= jspGlDetail.getErrorMsg(jspGlDetail.JSP_FOREIGN_CURRENCY_AMOUNT) %>
                                                                                                                                    </td>
                                                                                                                                </tr>
                                                                                                                            </table>
                                                                                                                    </div></td>
                                                                                                                    <td width="7%" class="tablecell"> 
                                                                                                                        <div align="center"> 
                                                                                                                            <input type="text" name="<%=JspGlDetail.colNames[JspGlDetail.JSP_BOOKED_RATE]%>" size="7" value="<%=JSPFormater.formatNumber(crd.getBookedRate(), "#,###.##")%>" style="text-align:right" onBlur="javascript:cmdUpdateExchange3()" onClick="javascript:cmdClickMe2()">
                                                                                                                        </div>                                                      
                                                                                                                    </td>
                                                                                                                    <td width="15%" class="tablecell"> 
                                                                                                                        <div align="right"> 
                                                                                                                            <input type="hidden" name="edit_amount" value="<%=crd.getDebet()%>">
                                                                                                                            <input type="text" name="<%=JspGlDetail.colNames[JspGlDetail.JSP_DEBET]%>" value="<%=JSPFormater.formatNumber(crd.getDebet(), "#,###.##")%>" style="text-align:right" size="15" readOnly class="readonly">
                                                                                                                            <input type="hidden" name="default_debet">
                                                                                                                        <%= jspGlDetail.getErrorMsg(JspGlDetail.JSP_DEBET) %> </div>                                                      
                                                                                                                    </td>
                                                                                                                    <td width="15%" class="tablecell"> 
                                                                                                                        <div align="right"> 
                                                                                                                            <input type="text" name="<%=JspGlDetail.colNames[JspGlDetail.JSP_CREDIT]%>" value="<%=JSPFormater.formatNumber(crd.getCredit(), "#,###.##")%>" style="text-align:right" size="15" readOnly class="readonly">
                                                                                                                            <input type="hidden" name="default_credit">
                                                                                                                        <%= jspGlDetail.getErrorMsg(JspGlDetail.JSP_DEBET) %> </div>                                                      
                                                                                                                    </td>
                                                                                                                    <td width="15%" class="tablecell"> 
                                                                                                                        <div align="center"> 
                                                                                                                            <input type="text" name="<%=JspGlDetail.colNames[JspGlDetail.JSP_MEMO]%>" value="<%=crd.getMemo()%>">
                                                                                                                            <%= jspGlDetail.getErrorMsg(jspGlDetail.JSP_MEMO) %>
                                                                                                                        </div>                                                      
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                                <%} else {%>
                                                                                                                <tr> 
                                                                                                                    <td class="tablecell" height="17"> 
                                                                                                                        <%

                                                                                                                                        String outStr = "";

                                                                                                                                        if (crd.getModuleId() != 0) {
                                                                                                                                            Module module = new Module();
                                                                                                                                            try {
                                                                                                                                                module = DbModule.fetchExc(crd.getModuleId());
                                                                                                                                            } catch (Exception e) {
                                                                                                                                            }

                                                                                                                                            StringTokenizer strTok = new StringTokenizer(module.getDescription(), ";");

                                                                                                                                            int countOut = 0;

                                                                                                                                            while (strTok.hasMoreTokens()) {

                                                                                                                                                if (countOut != 0) {
                                                                                                                                                    outStr = "(" + (countOut + 1) + ") " + outStr + " ";
                                                                                                                                                }

                                                                                                                                                outStr = outStr + strTok.nextToken();
                                                                                                                                                countOut++;
                                                                                                                                            }
                                                                                                                                        } else {
                                                                                                                        %>
                                                                                                                        <table border="0" cellpadding="1" cellspacing="1" >
                                                                                                                            <%
                                                                                                                                                                                                                                                                    for (int is = 0; is < segments.size(); is++) {
                                                                                                                                                                                                                                                                        Segment objSeg = (Segment) segments.get(is);

                                                                                                                            %>
                                                                                                                            <tr>
                                                                                                                                <td >&nbsp;&nbsp;&nbsp;<%=objSeg.getName()%></td>
                                                                                                                                <%
                                                                                                                                String nameSeg = "";
                                                                                                                                switch (is + 1) {
                                                                                                                                    case 1:
                                                                                                                                        try {
                                                                                                                                            SegmentDetail sdet = DbSegmentDetail.fetchExc(crd.getSegment1Id());
                                                                                                                                            nameSeg = sdet.getName();
                                                                                                                                        } catch (Exception e) {
                                                                                                                                        }
                                                                                                                                    case 2:
                                                                                                                                        try {
                                                                                                                                            SegmentDetail sdet = DbSegmentDetail.fetchExc(crd.getSegment2Id());
                                                                                                                                            nameSeg = sdet.getName();
                                                                                                                                        } catch (Exception e) {
                                                                                                                                        }

                                                                                                                                    case 3:
                                                                                                                                        try {
                                                                                                                                            SegmentDetail sdet = DbSegmentDetail.fetchExc(crd.getSegment3Id());
                                                                                                                                            nameSeg = sdet.getName();
                                                                                                                                        } catch (Exception e) {
                                                                                                                                        }

                                                                                                                                    case 4:
                                                                                                                                        try {
                                                                                                                                            SegmentDetail sdet = DbSegmentDetail.fetchExc(crd.getSegment4Id());
                                                                                                                                            nameSeg = sdet.getName();
                                                                                                                                        } catch (Exception e) {
                                                                                                                                        }

                                                                                                                                    case 5:
                                                                                                                                        try {
                                                                                                                                            SegmentDetail sdet = DbSegmentDetail.fetchExc(crd.getSegment5Id());
                                                                                                                                            nameSeg = sdet.getName();
                                                                                                                                        } catch (Exception e) {
                                                                                                                                        }

                                                                                                                                    case 6:
                                                                                                                                        try {
                                                                                                                                            SegmentDetail sdet = DbSegmentDetail.fetchExc(crd.getSegment6Id());
                                                                                                                                            nameSeg = sdet.getName();
                                                                                                                                        } catch (Exception e) {
                                                                                                                                        }

                                                                                                                                    case 7:
                                                                                                                                        try {
                                                                                                                                            SegmentDetail sdet = DbSegmentDetail.fetchExc(crd.getSegment7Id());
                                                                                                                                            nameSeg = sdet.getName();
                                                                                                                                        } catch (Exception e) {
                                                                                                                                        }

                                                                                                                                    case 8:
                                                                                                                                        try {
                                                                                                                                            SegmentDetail sdet = DbSegmentDetail.fetchExc(crd.getSegment8Id());
                                                                                                                                            nameSeg = sdet.getName();
                                                                                                                                        } catch (Exception e) {
                                                                                                                                        }

                                                                                                                                    case 9:
                                                                                                                                        try {
                                                                                                                                            SegmentDetail sdet = DbSegmentDetail.fetchExc(crd.getSegment9Id());
                                                                                                                                            nameSeg = sdet.getName();
                                                                                                                                        } catch (Exception e) {
                                                                                                                                        }

                                                                                                                                    case 10:
                                                                                                                                        try {
                                                                                                                                            SegmentDetail sdet = DbSegmentDetail.fetchExc(crd.getSegment10Id());
                                                                                                                                            nameSeg = sdet.getName();
                                                                                                                                        } catch (Exception e) {
                                                                                                                                        }

                                                                                                                                    case 11:
                                                                                                                                        try {
                                                                                                                                            SegmentDetail sdet = DbSegmentDetail.fetchExc(crd.getSegment11Id());
                                                                                                                                            nameSeg = sdet.getName();
                                                                                                                                        } catch (Exception e) {
                                                                                                                                        }

                                                                                                                                    case 12:
                                                                                                                                        try {
                                                                                                                                            SegmentDetail sdet = DbSegmentDetail.fetchExc(crd.getSegment12Id());
                                                                                                                                            nameSeg = sdet.getName();
                                                                                                                                        } catch (Exception e) {
                                                                                                                                        }

                                                                                                                                    case 13:
                                                                                                                                        try {
                                                                                                                                            SegmentDetail sdet = DbSegmentDetail.fetchExc(crd.getSegment13Id());
                                                                                                                                            nameSeg = sdet.getName();
                                                                                                                                        } catch (Exception e) {
                                                                                                                                        }

                                                                                                                                    case 14:
                                                                                                                                        try {
                                                                                                                                            SegmentDetail sdet = DbSegmentDetail.fetchExc(crd.getSegment14Id());
                                                                                                                                            nameSeg = sdet.getName();
                                                                                                                                        } catch (Exception e) {
                                                                                                                                        }

                                                                                                                                    case 15:
                                                                                                                                        try {
                                                                                                                                            SegmentDetail sdet = DbSegmentDetail.fetchExc(crd.getSegment15Id());
                                                                                                                                            nameSeg = sdet.getName();
                                                                                                                                        } catch (Exception e) {
                                                                                                                                        }
                                                                                                                                        break;
                                                                                                                                }
                                                                                                                                %>
                                                                                                                                <td >&nbsp;:&nbsp;&nbsp;<%=nameSeg%></td>
                                                                                                                            </tr>                                                                                                                                                
                                                                                                                            <%
                                                                                                                                                                                                                                                                    }
                                                                                                                            %>    
                                                                                                                        </table>
                                                                                                                        <%
                                                                                                                                        }

                                                                                                                                        out.println(outStr);
                                                                                                                        %>
                                                                                                                    </td>
                                                                                                                    <td class="tablecell" nowrap height="17"> 
                                                                                                                        <%if (gl.getPostedStatus() == 1) {%>
                                                                                                                        <%=c.getCode() + " - " + c.getName()%> 
                                                                                                                        <%} else {%>
                                                                                                                        <a href="javascript:cmdEdit('<%=i%>')"> 
                                                                                                                            <%if (gl.getOID() == 0) {%>
                                                                                                                            <%=c.getCode()%> 
                                                                                                                            <%} else {%>
                                                                                                                            <%=c.getCode()%> 
                                                                                                                            <%}%>
                                                                                                                        &nbsp;-&nbsp; <%=c.getName()%></a>
                                                                                                                        <%}%>
                                                                                                                    </td>                                                                                                                    
                                                                                                                    <td class="tablecell" height="17"> 
                                                                                                                        <div align="center"> 
                                                                                                                            <%
                                                                                                                                        Currency xc = new Currency();
                                                                                                                                        try {
                                                                                                                                            xc = DbCurrency.fetchExc(crd.getForeignCurrencyId());
                                                                                                                                        } catch (Exception e) {
                                                                                                                                        }
                                                                                                                            %>
                                                                                                                        <%=xc.getCurrencyCode()%> </div>                                                      
                                                                                                                    </td>
                                                                                                                    <td class="tablecell" height="17"> 
                                                                                                                    <div align="right"> <%=JSPFormater.formatNumber(crd.getForeignCurrencyAmount(), "#,###.##")%> </div>                                                      </td>
                                                                                                                    <td class="tablecell" height="17"> 
                                                                                                                    <div align="right"> <%=JSPFormater.formatNumber(crd.getBookedRate(), "#,###.##")%> </div>                                                      </td>
                                                                                                                    <td class="tablecell" height="17"> 
                                                                                                                    <div align="right"><%=JSPFormater.formatNumber(crd.getDebet(), "#,###.##")%></div>                                                      </td>
                                                                                                                    <td class="tablecell" height="17"> 
                                                                                                                    <div align="right"><%=JSPFormater.formatNumber(crd.getCredit(), "#,###.##")%></div>                                                      </td>
                                                                                                                    <td class="tablecell" height="17"><%=crd.getMemo()%></td>
                                                                                                                </tr>
                                                                                                                <%}%>
                                                                                                                <%}
            }%>
                                                                                                                <%
            if ((iJSPCommand == JSPCommand.ADD || (iJSPCommand == JSPCommand.SUBMIT && (iErrCode != 0 || iErrCodeMain != 0))) && recIdx == -1 && gl.getPostedStatus() != 1) {
                                                                                                                %>                                                                                                                
                                                                                                                <tr> 
                                                                                                                    <td class ="tablecell" width="21%">                                                                                                                        
                                                                                                                        <div align="center"> 
                                                                                                                            <table width="49%" border="0" cellspacing="0" cellpadding="0">
                                                                                                                                <tr> 
                                                                                                                                    <td width="62%" nowrap> 
                                                                                                                                        <div align="center"> 
                                                                                                                                            <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                                                                                                <%

                                                                                                                    if (segments != null && segments.size() > 0) {
                                                                                                                        for (int i = 0; i < segments.size(); i++) {
                                                                                                                            Segment seg = (Segment) segments.get(i);
                                                                                                                            Vector sgDetails = DbSegmentDetail.list(0, 0, "segment_id=" + seg.getOID(), DbSegmentDetail.colNames[DbSegmentDetail.COL_CODE]);

                                                                                                                                                %>
                                                                                                                                                <tr> 
                                                                                                                                                    <td width="54%" nowrap><%=seg.getName()%></td>
                                                                                                                                                    <td width="46%"> 
                                                                                                                                                        <select name="JSP_SEGMENT<%=i + 1%>_ID">
                                                                                                                                                            <%if (sgDetails != null && sgDetails.size() > 0) {
                                                                                                                                                                                                                                                                                for (int x = 0; x < sgDetails.size(); x++) {
                                                                                                                                                                                                                                                                                    SegmentDetail sd = (SegmentDetail) sgDetails.get(x);
                                                                                                                                                                                                                                                                                    String selected = "";
                                                                                                                                                                                                                                                                                    switch (i + 1) {
                                                                                                                                                                                                                                                                                        case 1:
                                                                                                                                                                                                                                                                                            if (glDetail.getSegment1Id() == sd.getOID()) {
                                                                                                                                                                                                                                                                                                selected = "selected";
                                                                                                                                                                                                                                                                                            }
                                                                                                                                                                                                                                                                                            break;
                                                                                                                                                                                                                                                                                        case 2:
                                                                                                                                                                                                                                                                                            if (glDetail.getSegment2Id() == sd.getOID()) {
                                                                                                                                                                                                                                                                                                selected = "selected";
                                                                                                                                                                                                                                                                                            }
                                                                                                                                                                                                                                                                                            break;
                                                                                                                                                                                                                                                                                        case 3:
                                                                                                                                                                                                                                                                                            if (glDetail.getSegment3Id() == sd.getOID()) {
                                                                                                                                                                                                                                                                                                selected = "selected";
                                                                                                                                                                                                                                                                                            }
                                                                                                                                                                                                                                                                                            break;
                                                                                                                                                                                                                                                                                        case 4:
                                                                                                                                                                                                                                                                                            if (glDetail.getSegment4Id() == sd.getOID()) {
                                                                                                                                                                                                                                                                                                selected = "selected";
                                                                                                                                                                                                                                                                                            }
                                                                                                                                                                                                                                                                                            break;
                                                                                                                                                                                                                                                                                        case 5:
                                                                                                                                                                                                                                                                                            if (glDetail.getSegment5Id() == sd.getOID()) {
                                                                                                                                                                                                                                                                                                selected = "selected";
                                                                                                                                                                                                                                                                                            }
                                                                                                                                                                                                                                                                                            break;
                                                                                                                                                                                                                                                                                        case 6:
                                                                                                                                                                                                                                                                                            if (glDetail.getSegment6Id() == sd.getOID()) {
                                                                                                                                                                                                                                                                                                selected = "selected";
                                                                                                                                                                                                                                                                                            }
                                                                                                                                                                                                                                                                                            break;
                                                                                                                                                                                                                                                                                        case 7:
                                                                                                                                                                                                                                                                                            if (glDetail.getSegment7Id() == sd.getOID()) {
                                                                                                                                                                                                                                                                                                selected = "selected";
                                                                                                                                                                                                                                                                                            }
                                                                                                                                                                                                                                                                                            break;
                                                                                                                                                                                                                                                                                        case 8:
                                                                                                                                                                                                                                                                                            if (glDetail.getSegment8Id() == sd.getOID()) {
                                                                                                                                                                                                                                                                                                selected = "selected";
                                                                                                                                                                                                                                                                                            }
                                                                                                                                                                                                                                                                                            break;
                                                                                                                                                                                                                                                                                        case 9:
                                                                                                                                                                                                                                                                                            if (glDetail.getSegment9Id() == sd.getOID()) {
                                                                                                                                                                                                                                                                                                selected = "selected";
                                                                                                                                                                                                                                                                                            }
                                                                                                                                                                                                                                                                                            break;
                                                                                                                                                                                                                                                                                        case 10:
                                                                                                                                                                                                                                                                                            if (glDetail.getSegment10Id() == sd.getOID()) {
                                                                                                                                                                                                                                                                                                selected = "selected";
                                                                                                                                                                                                                                                                                            }
                                                                                                                                                                                                                                                                                            break;
                                                                                                                                                                                                                                                                                        case 11:
                                                                                                                                                                                                                                                                                            if (glDetail.getSegment11Id() == sd.getOID()) {
                                                                                                                                                                                                                                                                                                selected = "selected";
                                                                                                                                                                                                                                                                                            }
                                                                                                                                                                                                                                                                                            break;
                                                                                                                                                                                                                                                                                        case 12:
                                                                                                                                                                                                                                                                                            if (glDetail.getSegment12Id() == sd.getOID()) {
                                                                                                                                                                                                                                                                                                selected = "selected";
                                                                                                                                                                                                                                                                                            }
                                                                                                                                                                                                                                                                                            break;
                                                                                                                                                                                                                                                                                        case 13:
                                                                                                                                                                                                                                                                                            if (glDetail.getSegment13Id() == sd.getOID()) {
                                                                                                                                                                                                                                                                                                selected = "selected";
                                                                                                                                                                                                                                                                                            }
                                                                                                                                                                                                                                                                                            break;
                                                                                                                                                                                                                                                                                        case 14:
                                                                                                                                                                                                                                                                                            if (glDetail.getSegment14Id() == sd.getOID()) {
                                                                                                                                                                                                                                                                                                selected = "selected";
                                                                                                                                                                                                                                                                                            }
                                                                                                                                                                                                                                                                                            break;
                                                                                                                                                                                                                                                                                        case 15:
                                                                                                                                                                                                                                                                                            if (glDetail.getSegment15Id() == sd.getOID()) {
                                                                                                                                                                                                                                                                                                selected = "selected";
                                                                                                                                                                                                                                                                                            }
                                                                                                                                                                                                                                                                                            break;
                                                                                                                                                                                                                                                                                    }
                                                                                                                                                            %>
                                                                                                                                                            <option value="<%=sd.getOID()%>" <%=selected%>><%=sd.getName()%></option>
                                                                                                                                                            <%}
                                                                                                                                                                                                                                                                            }%>
                                                                                                                                                        </select>
                                                                                                                                                    </td>
                                                                                                                                                </tr>
                                                                                                                                                <%}
                                                                                                                    }%>
                                                                                                                                            </table>
                                                                                                                                        </div>
                                                                                                                                    </td>                                                                                                                                    
                                                                                                                                </tr>
                                                                                                                            </table>
                                                                                                                        </div>
                                                                                                                    </td>    
                                                                                                                    <td class="tablecell" width="21%"> 
                                                                                                                        <div align="center"> 
                                                                                                                            <select name="<%=JspGlDetail.colNames[JspGlDetail.JSP_COA_ID]%>">
                                                                                                                                <%if (coas != null && coas.size() > 0) {
                                                                                                                        for (int x = 0; x < coas.size(); x++) {
                                                                                                                            Coa coax = (Coa) coas.get(x);
                                                                                                                            String str = "";

                                                                                                                            switch (coax.getLevel()) {
                                                                                                                                case 0:
                                                                                                                                    break;
                                                                                                                                case 1:
                                                                                                                                    str = str + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                                                                                                                                    break;
                                                                                                                                case 2:
                                                                                                                                    str = str + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                                                                                                                                    break;
                                                                                                                                case 3:
                                                                                                                                    str = str + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                                                                                                                                    break;
                                                                                                                                case 4:
                                                                                                                                    str = str + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                                                                                                                                    break;
                                                                                                                                case 5:
                                                                                                                                    str = str + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                                                                                                                                    break;
                                                                                                                            }


                                                                                                                                %>
                                                                                                                                <option value="<%=coax.getOID()%>" <%if (glDetail.getCoaId() == coax.getOID()) {%>selected<%}%>><%=str + coax.getCode() + " - " + coax.getName()%></option>                                                                                                                                
                                                                                                                                <%}
                                                                                                                    }%>
                                                                                                                            </select>
                                                                                                                        <%= jspGlDetail.getErrorMsg(JspGlDetail.JSP_COA_ID) %> </div>
                                                                                                                    </td>
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
                                                                                                                            <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                                <tr>
                                                                                                                                    <td>
                                                                                                                                        <select name="<%=JspGlDetail.colNames[JspGlDetail.JSP_IS_DEBET]%>" onChange="javascript:updateDebetCredit()">
                                                                                                                                            <option value="0" <%if (glDetail.getIsDebet() == 0) {%>selected<%}%>>DEBET</option>
                                                                                                                                            <option value="1" <%if (glDetail.getIsDebet() == 1) {%>selected<%}%>>CREDIT</option>
                                                                                                                                        </select>
                                                                                                                                    </td>
                                                                                                                                    <td>&nbsp;</td>
                                                                                                                                    <td>
                                                                                                                                        <input type="text" name="<%=JspGlDetail.colNames[JspGlDetail.JSP_FOREIGN_CURRENCY_AMOUNT]%>" size="15" value="<%=JSPFormater.formatNumber(glDetail.getForeignCurrencyAmount(), "#,###.##")%>" style="text-align:right" onBlur="javascript:cmdUpdateExchange2()" onClick="javascript:cmdClickMe()">
                                                                                                                                    </td>
                                                                                                                                    <td>
                                                                                                                                        <%= jspGlDetail.getErrorMsg(jspGlDetail.JSP_FOREIGN_CURRENCY_AMOUNT) %>
                                                                                                                                    </td>
                                                                                                                                </tr>
                                                                                                                            </table>
                                                                                                                        </div>                                                      
                                                                                                                    </td>
                                                                                                                    <td width="7%" class="tablecell"> 
                                                                                                                        <div align="center"> 
                                                                                                                            <input type="text" name="<%=JspGlDetail.colNames[JspGlDetail.JSP_BOOKED_RATE]%>" size="7" value="<%=JSPFormater.formatNumber(glDetail.getBookedRate(), "#,###.##")%>" style="text-align:right" onBlur="javascript:cmdUpdateExchange3()" onClick="javascript:cmdClickMe2()">
                                                                                                                        </div>                                                      
                                                                                                                    </td>
                                                                                                                    <td width="15%" class="tablecell"> 
                                                                                                                        <div align="center"> 
                                                                                                                            <input type="text" name="<%=JspGlDetail.colNames[JspGlDetail.JSP_DEBET]%>" value="<%=JSPFormater.formatNumber(glDetail.getDebet(), "#,###.##")%>" style="text-align:right" size="15" readOnly class="readonly">
                                                                                                                        <%= jspGlDetail.getErrorMsg(JspGlDetail.JSP_DEBET) %></div>                                                      
                                                                                                                    </td>
                                                                                                                    <td width="15%" class="tablecell"> 
                                                                                                                        <div align="center"> 
                                                                                                                            <input type="text" name="<%=JspGlDetail.colNames[JspGlDetail.JSP_CREDIT]%>" value="<%=JSPFormater.formatNumber(glDetail.getCredit(), "#,###.##")%>" style="text-align:right" size="15" readOnly class="readonly">
                                                                                                                        <%= jspGlDetail.getErrorMsg(JspGlDetail.JSP_DEBET) %></div>                                                      
                                                                                                                    </td>
                                                                                                                    <td width="15%" class="tablecell"> 
                                                                                                                        <div align="center"> 
                                                                                                                            <input type="text" name="<%=JspGlDetail.colNames[JspGlDetail.JSP_MEMO]%>" value="<%=glDetail.getMemo()%>">
                                                                                                                            <%= jspGlDetail.getErrorMsg(jspGlDetail.JSP_MEMO) %>
                                                                                                                        </div>                                                      
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                                <%}%>
                                                                                                                <tr> 
                                                                                                                    <td class="tablecell" colspan="8" height="1">&nbsp</td>
                                                                                                                </tr>
                                                                                                                <tr> 
                                                                                                                    <td colspan="5"> 
                                                                                                                    <div align="right"><b>TOTAL : </b></div></td>
                                                                                                                    <td class="tablecell"> 
                                                                                                                        <div align="center"> 
                                                                                                                            <input type="text" name="total_debet" value="<%=JSPFormater.formatNumber(totalDebet, "#,###.##")%>" style="text-align:right" size="15" readOnly class="readonly">
                                                                                                                        </div>                                                      
                                                                                                                    </td>
                                                                                                                    <td class="tablecell"> 
                                                                                                                        <div align="center"> 
                                                                                                                            <input type="text" name="total_credit" value="<%=JSPFormater.formatNumber(totalCredit, "#,###.##")%>" style="text-align:right" size="15" readOnly class="readonly">
                                                                                                                        </div>                                                      
                                                                                                                    </td>
                                                                                                                    <td class="tablecell">&nbsp;</td>
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
                                                                                            <td colspan="3">&nbsp;</td>
                                                                                        </tr>
                                                                                        <tr> 
                                                                                            <td width="25%"> 
                                                                                                <%
                                                                                if (iJSPCommand != JSPCommand.ADD && iJSPCommand != JSPCommand.EDIT && iJSPCommand != JSPCommand.ASK && iErrCode == 0 && iErrCodeMain == 0) {

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
                                                                                                
                                                                                                <%if (gl.getPostedStatus() != 1) {%>                                                                                             
                                                                                                <%= ctrLine.drawImageOnly(iJSPCommand, iErrCode, msgString)%> 
                                                                                                <%} else {%>                                                                                               
                                                                                                <a href="javascript:cmdBack()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('bcx','','../images/back2.gif',1)"><img src="../images/back.gif" name="bcx" height="22" border="0"></a> 
                                                                                                &nbsp;<a href="javascript:cmdNewJournal()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new1','','../images/newdoc2.gif',1)"><img src="../images/newdoc.gif" name="new1" height="22" border="0"></a>
                                                                                                <%}%>
                                                                                                
                                                                                                <%}%>
                                                                                            </td>
                                                                                            <td width="52%"> 
                                                                                                <div align="right"></div>
                                                                                            </td>
                                                                                            <td width="23%" class="boxed1"> 
                                                                                                <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                                                    <tr> 
                                                                                                        <td width="41%" nowrap><b>Out 
                                                                                                        of Balance <%=baseCurrency.getCurrencyCode()%> :</b></td>
                                                                                                        <td width="59%"> 
                                                                                                            <div align="right"><b><a id="tot_balance"></a></b></div>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                            <%
            } catch (Exception exc) {
                System.out.println("[exception] " + exc.toString());
            }%>
                                                                            <%if (totalDebet > 0 && iErrCode == 0 && iErrCode == 0 && balance == 0 && gl.getPostedStatus() == 0) {%>
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
                                                                                            <td width="8%"><a href="javascript:cmdSubmitCommand()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('post','','../images/savedoc2.gif',1)"><img src="../images/savedoc.gif" name="post" height="22" border="0"></a></td>
                                                                                            <td width="59%">&nbsp;<a href="javascript:cmdNewJournal()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new1','','../images/newdoc2.gif',1)"><img src="../images/newdoc.gif" name="new1" height="22" border="0"></a></td>
                                                                                            <td width="33%">&nbsp;</td>
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
                                                                            <%if (gl.getOID() != 0) {%>
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
                                                                                            <td width="9%"></td>
                                                                                            <td width="47%">&nbsp;</td>
                                                                                            <td width="38%"> 
                                                                                                <%if (isSave) {%>
                                                                                                <div align="right" class="msgnextaction"> 
                                                                                                    <table border="0" cellpadding="5" cellspacing="0" class="success" align="right">
                                                                                                        <tr> 
                                                                                                            <td width="20"><img src="../images/success.gif" width="20" height="20"></td>
                                                                                                            <td width="220"><%=langGL[14]%></td>
                                                                                                        </tr>
                                                                                                    </table>
                                                                                                </div>
                                                                                                <%}%>
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
                                                                                                <td width="20"><img src="../images/success.gif" width="20"></td>
                                                                                                <td width="150">Posted</td>
                                                                                            </tr>
                                                                                        </table>
                                                                                    </div>
                                                                                </td>
                                                                            </tr>
                                                                            <%}%>
                                                                            <%if (gl.getOID() != 0) {
                String name = "-";
                String date = "";
                try {
                    User u = DbUser.fetch(gl.getOperatorId());
                    Employee e = DbEmployee.fetchExc(u.getEmployeeId());
                    name = e.getName();
                } catch (Exception e) {
                }
                try {
                    date = JSPFormater.formatDate(gl.getDate(), "dd MMM yyyy");
                } catch (Exception e) {
                }


                String postedName = "";
                String postedDate = "";
                try {
                    User u = DbUser.fetch(gl.getPostedById());
                    Employee e = DbEmployee.fetchExc(u.getEmployeeId());
                    postedName = e.getName();
                } catch (Exception e) {
                }
                try {
                    if (gl.getPostedDate() != null) {
                        postedDate = JSPFormater.formatDate(gl.getPostedDate(), "dd MMM yyyy");
                    }
                } catch (Exception e) {
                    postedDate = "";
                }
                                                                            %>
                                                                            <tr>
                                                                                <td height="30">&nbsp;</td>
                                                                            </tr>    
                                                                            <tr align="left" valign="top"> 
                                                                                <td valign="middle" colspan="3"> 
                                                                                    <table width="400" border="0" cellspacing="1" cellpadding="1">
                                                                                        <tr> 
                                                                                            <td colspan="3" height="20"><b><i><%=langApp[0]%></i></b> </td>
                                                                                        </tr>
                                                                                        <tr> 
                                                                                            <td width="100" height="20" bgcolor="#F3F3F3"><b><font size="1"><%=langApp[5]%></font></b></td>                                                                                              
                                                                                            <td height="20" bgcolor="#F3F3F3"><b><font size="1"><%=langApp[3]%></font></b></td>
                                                                                            <td width="100" height="20" bgcolor="#F3F3F3" nowrap><b><font size="1"><%=langApp[4]%></font></b></td>
                                                                                        </tr>
                                                                                        <tr>
                                                                                            <td colspan="3" height="1" bgcolor="#CCCCCC"></td>
                                                                                        </tr>
                                                                                        <tr> 
                                                                                            <td height="20" ><font size="1">Create By</font></td>                                                                                              
                                                                                            <td height="20" ><font size="1"><%=name%></font></td>
                                                                                            <td height="20" nowrap><font size="1"><%=date%></font></td>
                                                                                        </tr> 
                                                                                        <tr>
                                                                                            <td colspan="3" height="1" bgcolor="#CCCCCC"></td>
                                                                                        </tr>
                                                                                        <tr> 
                                                                                            <td height="20" ><font size="1">Posted By</font></td>                                                                                              
                                                                                            <td height="20" ><font size="1"><%=postedName%></font></td>
                                                                                            <td height="20" nowrap><font size="1"><%=postedDate%></font></td>
                                                                                        </tr> 
                                                                                        <tr>
                                                                                            <td colspan="3" height="1" bgcolor="#CCCCCC"></td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                            <%}%>
                                                                            <tr>
                                                                                <td height="30">&nbsp;</td>
                                                                            </tr> 
                                                                        </table>
                                                                    </td>
                                                                </tr>                                                                
                                                            </table>
                                                            <script language="JavaScript">
                                                                <%if (iJSPCommand == JSPCommand.ADD || iErrCode != 0 || iJSPCommand == JSPCommand.ASK) {%>
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
