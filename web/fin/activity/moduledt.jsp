
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.main.entity.*" %>
<%@ page import = "com.project.fms.activity.*" %>
<%@ page import = "com.project.*" %>
<%@ include file = "../main/javainit.jsp" %>
<% int appObjCode = 1;%>
<%@ include file = "../main/check.jsp" %>
<%
            boolean privAdd = true;
            boolean privUpdate = true;
            boolean privDelete = true;
            boolean masterPriv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_WORKPLAN);
            boolean masterPrivView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_WORKPLAN, AppMenu.PRIV_VIEW);
            boolean masterPrivUpdate = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_WORKPLAN, AppMenu.PRIV_UPDATE);
            boolean useGereja = DbSystemProperty.getModSysPropGereja();
%>
<!-- Jsp Block -->
<%!
    public static String getAccountRecursif(Coa coa, long oid, boolean isPostableOnly) {

        String result = "";
        if (!coa.getStatus().equals(I_Project.ACCOUNT_LEVEL_POSTABLE)) {

            Vector coas = DbCoa.list(0, 0, "acc_ref_id=" + coa.getOID(), "code");

            if (coas != null && coas.size() > 0) {
                for (int i = 0; i < coas.size(); i++) {

                    Coa coax = (Coa) coas.get(i);
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

                    result = result + "<option value=\"" + coax.getOID() + "\"" + ((oid == coax.getOID()) ? "selected" : "") + ">" + str + coax.getCode() + " - " + coax.getName() + "</option>";

                    if (!coax.getStatus().equals(I_Project.ACCOUNT_LEVEL_POSTABLE)) {
                        result = result + getAccountRecursif(coax, oid, isPostableOnly);
                    }
                }
            }
        }
        return result;
    }

    public String getSubstring(String s) {
        if (s.length() > 65) {
            s = s.substring(0, 65) + "...";
        }
        return s;
    }

%>
<%
            int iJSPCommand = JSPRequestValue.requestCommand(request);
            int start = JSPRequestValue.requestInt(request, "start");
            int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
            long oidModule = JSPRequestValue.requestLong(request, "hidden_module_id");
            int code = JSPRequestValue.requestInt(request, "hidden_code");
            long oidModuleBudget = JSPRequestValue.requestLong(request, "hidden_module_budget_id");
            String var = JSPRequestValue.requestStringExcTitikKoma(request, "hidden_var");
            int index = JSPRequestValue.requestInt(request, "index");
            String strz = JSPRequestValue.requestString(request, "x_output_deliver");

            /*variable declaration*/
            int recordToGet = 0;
            String msgString = "";
            String msgStringBudget = "";
            int iErrCode = JSPMessage.NONE;
            int iErrCodeBudget = JSPMessage.NONE;
            String whereClause = "";
            String orderClause = "";

            ActivityPeriod apOpen = DbActivityPeriod.getOpenPeriod();

            CmdModule cmdModule = new CmdModule(request);
            JSPLine ctrLine = new JSPLine();
            Vector listModule = new Vector(1, 1);

            /*switch statement */
            iErrCode = cmdModule.action(iJSPCommand, oidModule);
            /* end switch*/
            JspModule jspModule = cmdModule.getForm();

            /*count list All Module*/
            int vectSize = DbModule.getCount(whereClause);

            Module module = cmdModule.getModule();
            msgString = cmdModule.getMessage();

            if ((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV) ||
                    (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)) {
                start = cmdModule.actionList(iJSPCommand, start, vectSize, recordToGet);
            }
            /* end switch list*/

            /* get record to display */
            listModule = DbModule.list(start, recordToGet, whereClause, orderClause);

            /*handle condition if size of record to display = 0 and start > 0 	after delete*/
            if (listModule.size() < 1 && start > 0) {
                if (vectSize - recordToGet > recordToGet) {
                    start = start - recordToGet;
                } //go to JSPCommand.PREV
                else {
                    start = 0;
                    iJSPCommand = JSPCommand.FIRST;
                    prevJSPCommand = JSPCommand.FIRST; //go to JSPCommand.FIRST
                }
                listModule = DbModule.list(start, recordToGet, whereClause, orderClause);
            }

            CmdModuleBudget cmdModuleBudget = new CmdModuleBudget(request);

            Vector listModuleBudget = new Vector(1, 1);
            String whereBud = "" + DbModuleBudget.colNames[DbModuleBudget.COL_MODULE_ID] + "=" + module.getOID() + " and " + DbModuleBudget.colNames[DbModuleBudget.COL_STATUS] + " = " + DbModuleBudget.DOC_NOT_HISTORY;
            String whereBudHistory = "" + DbModuleBudget.colNames[DbModuleBudget.COL_MODULE_ID] + "=" + module.getOID() + " and " + DbModuleBudget.colNames[DbModuleBudget.COL_STATUS] + " = " + DbModuleBudget.DOC_HISTORY;
            Vector listModuleBudgetHistory = DbModuleBudget.list(start, recordToGet, whereBudHistory, orderClause);


            /*switch statement */
            iErrCodeBudget = cmdModuleBudget.action(iJSPCommand, oidModuleBudget);
            /* end switch*/
            JspModuleBudget jspModuleBudget = cmdModuleBudget.getForm();

            /*count list All Module*/
            ModuleBudget moduleBudget = cmdModuleBudget.getModuleBudget();
            msgStringBudget = cmdModule.getMessage();

            if (oidModuleBudget == 0) {
                oidModuleBudget = moduleBudget.getOID();
            }

            if ((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV) ||
                    (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)) {
                start = cmdModuleBudget.actionList(iJSPCommand, start, vectSize, recordToGet);
            }
            /* end switch list*/

            /* get record to display */
            listModuleBudget = DbModuleBudget.list(start, recordToGet, whereBud, orderClause);

            /*** LANG ***/
            String[] langCT = {"Activity Period", "Initial", "Code", "Description", "Output & Deliverable", "Performance Indikator", "Assumtion and Risk", //0-6
                "Cost Implication", "Level", "Parent", "Postable", "Type", "Status", "Nomor", "Memo", "Coa", "Budget", "Days", "Date", "Time", "Note", ""}; //7-20


            String[] langNav = {"Activity", "Activity List", "Budget List", "Data Saved", "Error, Data Incomplete", "Delete budget sucsses", "Note", "Use ' ; ' character for new line"};//0-8

            String[] langApp = {"Approval Status", "Squence", "Position/Level", "Approved by", "Approval Date", "Status", "Notes", "Action"};

            if (lang == LANG_ID) {
                String[] langID = {"Periode", "Inisial", "Kode", "Kegiatan", "Sasaran", "Indikator Performance", "Asumsi dan Resiko", //0-6
                    "Implikasi Biaya", "Level", "Induk", "Postable", "Type", "Status", "No", "keterangan", "Akun Perkiraan", "Anggaran", "Hari", "Tanggal", "Waktu", "Keterangan"}; //7-20

                langCT = langID;

                String[] navID = {"Kegiatan", "Data Kerja", "Daftar Anggaran", "Data Sudah Tersimpan", "Error, Data Belum Lengkap", "Delete data anggaran berhasil", "catatan", "Gunakan karakter ' ; ' untuk membuat baris baru"}; //0-8
                langNav = navID;
                String[] langAppID = {"Status Persetujuan", "Urutan", "Posisi/Level", "Oleh", "Tgl. Disetujui", "Status", "Catatan", "Tindakan"};
                langApp = langAppID;
            }

            if (iJSPCommand == JSPCommand.SUBMIT && iErrCodeBudget == 0) {
                moduleBudget = new ModuleBudget();
            }

            Vector sds = DbSegmentDetail.list(0, 0, "", "");
            ActivityPeriod openPeriod = DbActivityPeriod.getOpenPeriod();


%>
<html >
    <!-- #BeginTemplate "/Templates/index.dwt" --> 
    <head>
        <!-- #BeginEditable "javascript" --> 
        <title><%=systemTitle%></title>
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
        <link href="../css/default.css" rel="stylesheet" type="text/css" />
        <link href="../css/css.css" rel="stylesheet" type="text/css" />
        <script language="JavaScript"> 
            <%if (iJSPCommand == JSPCommand.DETAIL || iJSPCommand == JSPCommand.SUBMIT || iJSPCommand == JSPCommand.EDIT || iJSPCommand == JSPCommand.YES) {%>
            window.location="#go";
            <%}%>
            
            
            <%if (!masterPriv || !masterPrivView || !masterPrivUpdate) {%>
            window.location="<%=approot%>/nopriv.jsp";
            <%}%>
            
            <%if ((iJSPCommand == JSPCommand.DELETE) && iErrCode == 0) {%>
            <%if (useGereja) {%>
            window.location="moduledel.jsp";
            <%} else {%>
            window.location="moduledel.jsp";
            <%}%>  
            <%}%>
            
            function cmdGetCode(){
                var seg1 = document.frmmodule.JSP_SEGMENT1_ID.value;
                
                                 <%
            Date dtNow = openPeriod.getEndDate();
                                 %>				
                                     document.frmmodule.<%=jspModule.colNames[JspModule.JSP_CODE]%>.value="<%=JSPFormater.formatDate(dtNow, "yy")%>";
                                 <%

            if (sds != null && sds.size() > 0) {
                for (int i = 0; i < sds.size(); i++) {
                    SegmentDetail sd = (SegmentDetail) sds.get(i);
                                 %>
                                     if(seg1=='<%=sd.getOID()%>'){
                                         var cd = document.frmmodule.<%=jspModule.colNames[JspModule.JSP_CODE]%>.value;
                                         document.frmmodule.<%=jspModule.colNames[JspModule.JSP_CODE]%>.value=cd+".<%=sd.getCode()%>";
                                     }
                                     
                                 <%}
            }%>
            
            var seg2 = document.frmmodule.JSP_SEGMENT2_ID.value;            
                                 <%
            if (sds != null && sds.size() > 0) {
                for (int i = 0; i < sds.size(); i++) {
                    SegmentDetail sd = (SegmentDetail) sds.get(i);
                                 %>
                                     if(seg2=='<%=sd.getOID()%>'){
                                         var cd = document.frmmodule.<%=jspModule.colNames[JspModule.JSP_CODE]%>.value;
                                         document.frmmodule.<%=jspModule.colNames[JspModule.JSP_CODE]%>.value=cd+".<%=sd.getCode()%>";
                                     }
                                     
                                 <%}
            }%>
            
            var seg3 = document.frmmodule.JSP_SEGMENT3_ID.value;
            
                                 <%
            if (sds != null && sds.size() > 0) {
                for (int i = 0; i < sds.size(); i++) {
                    SegmentDetail sd = (SegmentDetail) sds.get(i);
                                 %>
                                     if(seg3=='<%=sd.getOID()%>'){
                                         var cd = document.frmmodule.<%=jspModule.colNames[JspModule.JSP_CODE]%>.value;
                                         document.frmmodule.<%=jspModule.colNames[JspModule.JSP_CODE]%>.value=cd+".<%=sd.getCode()%>";
                                     }
                                     
                                 <%}
            }%>
            
            var seg4 = document.frmmodule.JSP_SEGMENT4_ID.value;
            //alert(seg1);
                                 <%
            if (sds != null && sds.size() > 0) {
                for (int i = 0; i < sds.size(); i++) {
                    SegmentDetail sd = (SegmentDetail) sds.get(i);
                                 %>
                                     if(seg4=='<%=sd.getOID()%>'){
                                         var cd = document.frmmodule.<%=jspModule.colNames[JspModule.JSP_CODE]%>.value;
                                         document.frmmodule.<%=jspModule.colNames[JspModule.JSP_CODE]%>.value=cd+".<%=sd.getCode()%>.XXX";
                                     }
                                     
                                 <%}
            }%>
        }
        
        function cmdKegiatanOpen(count,moduleId){
            
            var where = "";  
            var val = "";
            switch(count){
                case '1' :
                var seg1 = document.frmmodule.JSP_SEGMENT1_ID.value;
                where = "segment1_id = " +seg1;                        
                val = seg1;
                break;
                case '2' :
                var seg1 = document.frmmodule.JSP_SEGMENT1_ID.value;
                var seg2 = document.frmmodule.JSP_SEGMENT2_ID.value;
                where = "segment1_id = " +seg1+" and segment2_id = "+seg2;
                val = seg1+","+seg2;
                break;
                case '3' :
                var seg1 = document.frmmodule.JSP_SEGMENT1_ID.value;
                var seg2 = document.frmmodule.JSP_SEGMENT2_ID.value;
                var seg3 = document.frmmodule.JSP_SEGMENT3_ID.value;
                where = "segment1_id = " +seg1+" and segment2_id = "+seg2+" and segment3_id = "+seg3;
                val = seg1+","+seg2+","+seg3;
                break;
                case '4' :
                var seg1 = document.frmmodule.JSP_SEGMENT1_ID.value;
                var seg2 = document.frmmodule.JSP_SEGMENT2_ID.value;
                var seg3 = document.frmmodule.JSP_SEGMENT3_ID.value;
                var seg4 = document.frmmodule.JSP_SEGMENT4_ID.value;
                where = "segment1_id = " +seg1+" and segment2_id = "+seg2+" and segment3_id = "+seg3+" and segment4_id = "+seg4;
                val = seg1+","+seg2+","+seg3+","+seg4;
                break; 
                case '5' :
                var seg1 = document.frmmodule.JSP_SEGMENT1_ID.value;
                var seg2 = document.frmmodule.JSP_SEGMENT2_ID.value;
                var seg3 = document.frmmodule.JSP_SEGMENT3_ID.value;
                var seg4 = document.frmmodule.JSP_SEGMENT4_ID.value;
                var seg5 = document.frmmodule.JSP_SEGMENT5_ID.value;
                where = "segment1_id = " +seg1+" and segment2_id = "+seg2+" and segment3_id = "+seg3+" and segment4_id = "+seg4+" and segment5_id = "+seg5;  
                val = seg1+","+seg2+","+seg3+","+seg4+","+seg5;
                break;
                case '6' :
                var seg1 = document.frmmodule.JSP_SEGMENT1_ID.value;
                var seg2 = document.frmmodule.JSP_SEGMENT2_ID.value;
                var seg3 = document.frmmodule.JSP_SEGMENT3_ID.value;
                var seg4 = document.frmmodule.JSP_SEGMENT4_ID.value;
                var seg5 = document.frmmodule.JSP_SEGMENT5_ID.value;
                var seg6 = document.frmmodule.JSP_SEGMENT6_ID.value;
                where = "segment1_id = " +seg1+" and segment2_id = "+seg2+" and segment3_id = "+seg3+" and segment4_id = "+seg4+" and segment5_id = "+seg5+" and segment6_id = "+seg6;  
                val = seg1+","+seg2+","+seg3+","+seg4+","+seg5+","+seg6;
                break;  
                case '7' :
                var seg1 = document.frmmodule.JSP_SEGMENT1_ID.value;
                var seg2 = document.frmmodule.JSP_SEGMENT2_ID.value;
                var seg3 = document.frmmodule.JSP_SEGMENT3_ID.value;
                var seg4 = document.frmmodule.JSP_SEGMENT4_ID.value;
                var seg5 = document.frmmodule.JSP_SEGMENT5_ID.value;
                var seg6 = document.frmmodule.JSP_SEGMENT6_ID.value;
                var seg7 = document.frmmodule.JSP_SEGMENT7_ID.value;
                where = "segment1_id = " +seg1+" and segment2_id = "+seg2+" and segment3_id = "+seg3+" and segment4_id = "+seg4+" and segment5_id = "+seg5+" and segment6_id = "+seg6+" and segment7_id = "+seg7;  
                val = seg1+","+seg2+","+seg3+","+seg4+","+seg5+","+seg6+","+seg7;
                break; 
                case '8' :
                var seg1 = document.frmmodule.JSP_SEGMENT1_ID.value;
                var seg2 = document.frmmodule.JSP_SEGMENT2_ID.value;
                var seg3 = document.frmmodule.JSP_SEGMENT3_ID.value;
                var seg4 = document.frmmodule.JSP_SEGMENT4_ID.value;
                var seg5 = document.frmmodule.JSP_SEGMENT5_ID.value;
                var seg6 = document.frmmodule.JSP_SEGMENT6_ID.value;
                var seg7 = document.frmmodule.JSP_SEGMENT7_ID.value;
                var seg8 = document.frmmodule.JSP_SEGMENT8_ID.value;
                where = "segment1_id = " +seg1+" and segment2_id = "+seg2+" and segment3_id = "+seg3+" and segment4_id = "+seg4+" and segment5_id = "+seg5+" and segment6_id = "+seg6+" and segment7_id = "+seg7+" and segment8_id = "+seg8;  
                val = seg1+","+seg2+","+seg3+","+seg4+","+seg5+","+seg6+","+seg7+","+seg8;
                break;
                case '9' :
                var seg1 = document.frmmodule.JSP_SEGMENT1_ID.value;
                var seg2 = document.frmmodule.JSP_SEGMENT2_ID.value;
                var seg3 = document.frmmodule.JSP_SEGMENT3_ID.value;
                var seg4 = document.frmmodule.JSP_SEGMENT4_ID.value;
                var seg5 = document.frmmodule.JSP_SEGMENT5_ID.value;
                var seg6 = document.frmmodule.JSP_SEGMENT6_ID.value;
                var seg7 = document.frmmodule.JSP_SEGMENT7_ID.value;
                var seg8 = document.frmmodule.JSP_SEGMENT8_ID.value;
                var seg9 = document.frmmodule.JSP_SEGMENT9_ID.value;
                where = "segment1_id = " +seg1+" and segment2_id = "+seg2+" and segment3_id = "+seg3+" and segment4_id = "+seg4+" and segment5_id = "+seg5+" and segment6_id = "+seg6+" and segment7_id = "+seg7+" and segment8_id = "+seg8+" and segment9_id = "+seg9;  
                val = seg1+","+seg2+","+seg3+","+seg4+","+seg5+","+seg6+","+seg7+","+seg8+","+seg9;
                break; 
                case '10' :
                var seg1 = document.frmmodule.JSP_SEGMENT1_ID.value;
                var seg2 = document.frmmodule.JSP_SEGMENT2_ID.value;
                var seg3 = document.frmmodule.JSP_SEGMENT3_ID.value;
                var seg4 = document.frmmodule.JSP_SEGMENT4_ID.value;
                var seg5 = document.frmmodule.JSP_SEGMENT5_ID.value;
                var seg6 = document.frmmodule.JSP_SEGMENT6_ID.value;
                var seg7 = document.frmmodule.JSP_SEGMENT7_ID.value;
                var seg8 = document.frmmodule.JSP_SEGMENT8_ID.value;
                var seg9 = document.frmmodule.JSP_SEGMENT9_ID.value;
                var seg10 = document.frmmodule.JSP_SEGMENT10_ID.value;
                where = "segment1_id = " +seg1+" and segment2_id = "+seg2+" and segment3_id = "+seg3+" and segment4_id = "+seg4+" and segment5_id = "+seg5+" and segment6_id = "+seg6+" and segment7_id = "+seg7+" and segment8_id = "+seg8+" and segment9_id = "+seg9+" and segment10_id = "+seg10;  
                val = seg1+","+seg2+","+seg3+","+seg4+","+seg5+","+seg6+","+seg7+","+seg8+","+seg9+","+seg10;
                break;
                case '11' :
                var seg1 = document.frmmodule.JSP_SEGMENT1_ID.value;
                var seg2 = document.frmmodule.JSP_SEGMENT2_ID.value;
                var seg3 = document.frmmodule.JSP_SEGMENT3_ID.value;
                var seg4 = document.frmmodule.JSP_SEGMENT4_ID.value;
                var seg5 = document.frmmodule.JSP_SEGMENT5_ID.value;
                var seg6 = document.frmmodule.JSP_SEGMENT6_ID.value;
                var seg7 = document.frmmodule.JSP_SEGMENT7_ID.value;
                var seg8 = document.frmmodule.JSP_SEGMENT8_ID.value;
                var seg9 = document.frmmodule.JSP_SEGMENT9_ID.value;
                var seg10 = document.frmmodule.JSP_SEGMENT10_ID.value;
                var seg11 = document.frmmodule.JSP_SEGMENT11_ID.value;
                where = "segment1_id = " +seg1+" and segment2_id = "+seg2+" and segment3_id = "+seg3+" and segment4_id = "+seg4+" and segment5_id = "+seg5+" and segment6_id = "+seg6+" and segment7_id = "+seg7+" and segment8_id = "+seg8+" and segment9_id = "+seg9+" and segment10_id = "+seg10+" and segment11_id = "+seg11;  
                val = seg1+","+seg2+","+seg3+","+seg4+","+seg5+","+seg6+","+seg7+","+seg8+","+seg9+","+seg10+","+seg11;
                break;
                case '12' :
                var seg1 = document.frmmodule.JSP_SEGMENT1_ID.value;
                var seg2 = document.frmmodule.JSP_SEGMENT2_ID.value;
                var seg3 = document.frmmodule.JSP_SEGMENT3_ID.value;
                var seg4 = document.frmmodule.JSP_SEGMENT4_ID.value;
                var seg5 = document.frmmodule.JSP_SEGMENT5_ID.value;
                var seg6 = document.frmmodule.JSP_SEGMENT6_ID.value;
                var seg7 = document.frmmodule.JSP_SEGMENT7_ID.value;
                var seg8 = document.frmmodule.JSP_SEGMENT8_ID.value;
                var seg9 = document.frmmodule.JSP_SEGMENT9_ID.value;
                var seg10 = document.frmmodule.JSP_SEGMENT10_ID.value;
                var seg11 = document.frmmodule.JSP_SEGMENT11_ID.value;
                var seg12 = document.frmmodule.JSP_SEGMENT12_ID.value;
                where = "segment1_id = " +seg1+" and segment2_id = "+seg2+" and segment3_id = "+seg3+" and segment4_id = "+seg4+" and segment5_id = "+seg5+" and segment6_id = "+seg6+" and segment7_id = "+seg7+" and segment8_id = "+seg8+" and segment9_id = "+seg9+" and segment10_id = "+seg10+" and segment11_id = "+seg11+" and segment12_id = "+seg12;  
                val = seg1+","+seg2+","+seg3+","+seg4+","+seg5+","+seg6+","+seg7+","+seg8+","+seg9+","+seg10+","+seg11+","+seg12;
                break;
                case '13' :
                var seg1 = document.frmmodule.JSP_SEGMENT1_ID.value;
                var seg2 = document.frmmodule.JSP_SEGMENT2_ID.value;
                var seg3 = document.frmmodule.JSP_SEGMENT3_ID.value;
                var seg4 = document.frmmodule.JSP_SEGMENT4_ID.value;
                var seg5 = document.frmmodule.JSP_SEGMENT5_ID.value;
                var seg6 = document.frmmodule.JSP_SEGMENT6_ID.value;
                var seg7 = document.frmmodule.JSP_SEGMENT7_ID.value;
                var seg8 = document.frmmodule.JSP_SEGMENT8_ID.value;
                var seg9 = document.frmmodule.JSP_SEGMENT9_ID.value;
                var seg10 = document.frmmodule.JSP_SEGMENT10_ID.value;
                var seg11 = document.frmmodule.JSP_SEGMENT11_ID.value;
                var seg12 = document.frmmodule.JSP_SEGMENT12_ID.value;
                var seg13 = document.frmmodule.JSP_SEGMENT13_ID.value;
                where = "segment1_id = " +seg1+" and segment2_id = "+seg2+" and segment3_id = "+seg3+" and segment4_id = "+seg4+" and segment5_id = "+seg5+" and segment6_id = "+seg6+" and segment7_id = "+seg7+" and segment8_id = "+seg8+" and segment9_id = "+seg9+" and segment10_id = "+seg10+" and segment11_id = "+seg11+" and segment12_id = "+seg12+" and segment13_id = "+seg13;  
                val = seg1+","+seg2+","+seg3+","+seg4+","+seg5+","+seg6+","+seg7+","+seg8+","+seg9+","+seg10+","+seg11+","+seg12+","+seg13;
                break;  
                case '14' :
                var seg1 = document.frmmodule.JSP_SEGMENT1_ID.value;
                var seg2 = document.frmmodule.JSP_SEGMENT2_ID.value;
                var seg3 = document.frmmodule.JSP_SEGMENT3_ID.value;
                var seg4 = document.frmmodule.JSP_SEGMENT4_ID.value;
                var seg5 = document.frmmodule.JSP_SEGMENT5_ID.value;
                var seg6 = document.frmmodule.JSP_SEGMENT6_ID.value;
                var seg7 = document.frmmodule.JSP_SEGMENT7_ID.value;
                var seg8 = document.frmmodule.JSP_SEGMENT8_ID.value;
                var seg9 = document.frmmodule.JSP_SEGMENT9_ID.value;
                var seg10 = document.frmmodule.JSP_SEGMENT10_ID.value;
                var seg11 = document.frmmodule.JSP_SEGMENT11_ID.value;
                var seg12 = document.frmmodule.JSP_SEGMENT12_ID.value;
                var seg13 = document.frmmodule.JSP_SEGMENT13_ID.value;
                var seg14 = document.frmmodule.JSP_SEGMENT14_ID.value;
                where = "segment1_id = " +seg1+" and segment2_id = "+seg2+" and segment3_id = "+seg3+" and segment4_id = "+seg4+" and segment5_id = "+seg5+" and segment6_id = "+seg6+" and segment7_id = "+seg7+" and segment8_id = "+seg8+" and segment9_id = "+seg9+" and segment10_id = "+seg10+" and segment11_id = "+seg11+" and segment12_id = "+seg12+" and segment13_id = "+seg13+" and segment14_id = "+seg14;  
                val = seg1+","+seg2+","+seg3+","+seg4+","+seg5+","+seg6+","+seg7+","+seg8+","+seg9+","+seg10+","+seg11+","+seg12+","+seg13+","+seg14;
                break;
                case '15' :
                var seg1 = document.frmmodule.JSP_SEGMENT1_ID.value;
                var seg2 = document.frmmodule.JSP_SEGMENT2_ID.value;
                var seg3 = document.frmmodule.JSP_SEGMENT3_ID.value;
                var seg4 = document.frmmodule.JSP_SEGMENT4_ID.value;
                var seg5 = document.frmmodule.JSP_SEGMENT5_ID.value;
                var seg6 = document.frmmodule.JSP_SEGMENT6_ID.value;
                var seg7 = document.frmmodule.JSP_SEGMENT7_ID.value;
                var seg8 = document.frmmodule.JSP_SEGMENT8_ID.value;
                var seg9 = document.frmmodule.JSP_SEGMENT9_ID.value;
                var seg10 = document.frmmodule.JSP_SEGMENT10_ID.value;
                var seg11 = document.frmmodule.JSP_SEGMENT11_ID.value;
                var seg12 = document.frmmodule.JSP_SEGMENT12_ID.value;
                var seg13 = document.frmmodule.JSP_SEGMENT13_ID.value;
                var seg14 = document.frmmodule.JSP_SEGMENT14_ID.value;
                var seg15 = document.frmmodule.JSP_SEGMENT15_ID.value;
                where = "segment1_id = " +seg1+" and segment2_id = "+seg2+" and segment3_id = "+seg3+" and segment4_id = "+seg4+" and segment5_id = "+seg5+" and segment6_id = "+seg6+" and segment7_id = "+seg7+" and segment8_id = "+seg8+" and segment9_id = "+seg9+" and segment10_id = "+seg10+" and segment11_id = "+seg11+" and segment12_id = "+seg12+" and segment13_id = "+seg13+" and segment14_id = "+seg14+" and segment15_id = "+seg15;  
                val = seg1+","+seg2+","+seg3+","+seg4+","+seg5+","+seg6+","+seg7+","+seg8+","+seg9+","+seg10+","+seg11+","+seg12+","+seg13+","+seg14+","+seg15;
                break;    
            } 
            
            window.open("<%=approot%>/activity/moduledtopen.jsp?formName=frmmodule&where="+where+"&val="+val+"&id=x_parent_id&desc=JSP_PARENT_DESCRIPTION&moduleId="+moduleId, null, "height=400,width=800, status=yes,toolbar=no,menubar=no,location=no, scrollbars=yes");
            }              
            
            var sysDecSymbol = "<%=sSystemDecimalSymbol%>";
            var usrDigitGroup = "<%=sUserDigitGroup%>";
            var usrDecSymbol = "<%=sUserDecimalSymbol%>";              
            
            function cmdReset(){
                document.frmmodule.<%=jspModule.colNames[JspModule.JSP_PARENT_ID]%>.value="0";
                document.frmmodule.<%=jspModule.colNames[JspModule.JSP_MODULE_LEVEL]%>.value="1";                    
                document.frmmodule.JSP_PARENT_DESCRIPTION.value="";                    
            }                
            
            function cmdAdd(){
                document.frmmodule.hidden_module_id.value="0";
                document.frmmodule.command.value="<%=JSPCommand.ADD%>";
                document.frmmodule.prev_command.value="<%=prevJSPCommand%>";
                document.frmmodule.action="moduledt.jsp";
                document.frmmodule.submit();
            }
            
            function cmdAddDetail(moduleId){
                document.frmmodule.hidden_module_budget_id.value="0";
                document.frmmodule.hidden_module_id.value=moduleId;
                document.frmmodule.index.value=0;
                document.frmmodule.command.value="<%=JSPCommand.DETAIL%>";                    
                document.frmmodule.action="moduledt.jsp";
                document.frmmodule.submit();
            }
            
            function cmdActPerBudget(){
                document.frmmodule.command.value="<%=JSPCommand.LIST%>";
                document.frmmodule.action="activityperiodbudget.jsp";
                document.frmmodule.submit();
            }                
            
            function cmdAsk(oidModule){
                var cfrm = confirm('Hapus data ?');
                
                if( cfrm==true){
                    document.frmmodule.hidden_module_id.value=oidModule;
                    document.frmmodule.command.value="<%=JSPCommand.DELETE%>";
                    document.frmmodule.action="moduledt.jsp";
                    document.frmmodule.submit();
                }
            }
            
            function cmdConfirmDelete(oidModule){
                document.frmmodule.hidden_module_id.value=oidModule;
                document.frmmodule.command.value="<%=JSPCommand.DELETE%>";
                document.frmmodule.prev_command.value="<%=prevJSPCommand%>";
                document.frmmodule.action="moduledt.jsp";
                document.frmmodule.submit();
            }
            function cmdSave(){
                document.frmmodule.command.value="<%=JSPCommand.SAVE%>";
                document.frmmodule.prev_command.value="<%=prevJSPCommand%>";
                document.frmmodule.action="moduledt.jsp";
                document.frmmodule.submit();
            }
            
            function cmdSaveDetail(oidModule){
                document.frmmodule.hidden_module_id.value=oidModule;
                document.frmmodule.command.value="<%=JSPCommand.SUBMIT %>";
                document.frmmodule.prev_command.value="<%=prevJSPCommand%>";
                document.frmmodule.action="moduledt.jsp";
                document.frmmodule.submit();
            }
            
            function cmdDelete(oidModule){     
                var cfrm = confirm('Hapus data kerja sekaligus data anggarannya ?');                    
                if( cfrm==true){
                    document.frmmodule.hidden_module_id.value=oidModule;                        
                    document.frmmodule.command.value="<%=JSPCommand.DELETE%>";
                    document.frmmodule.action="moduledt.jsp";                        
                    document.frmmodule.submit();
                }
            }
            
            function cmdDeleteBudget(oidModule, oidBudget){     
                var cfrm = confirm('Hapus data anggaran ?');
                
                if( cfrm==true){
                    document.frmmodule.hidden_module_id.value=oidModule;
                    document.frmmodule.hidden_module_budget_id.value=oidBudget;
                    document.frmmodule.command.value="<%=JSPCommand.YES%>";
                    document.frmmodule.index.value=0;
                    document.frmmodule.action="moduledt.jsp";
                    document.frmmodule.submit();
                }
            }
            
            
            function cmdEdit(oidModule){
                document.frmmodule.hidden_module_id.value=oidModule;
                document.frmmodule.command.value="<%=JSPCommand.EDIT%>";
                document.frmmodule.prev_command.value="<%=prevJSPCommand%>";
                document.frmmodule.action="moduledt.jsp";
                
                document.frmmodule.submit();
            }
            
            function cmdCancel(oidModule){
                document.frmmodule.hidden_module_id.value=oidModule;
                document.frmmodule.command.value="<%=JSPCommand.EDIT%>";
                document.frmmodule.prev_command.value="<%=prevJSPCommand%>";
                document.frmmodule.action="moduledt.jsp";
                document.frmmodule.submit();
            }
            
            function cmdBackBudget(oidModule,oidBudget){
                document.frmmodule.hidden_module_id.value=oidModule;
                document.frmmodule.hidden_module_budget_id.value=oidBudget;
                document.frmmodule.command.value="<%=JSPCommand.LOCK%>";   
                document.frmmodule.index.value=0;
                document.frmmodule.action="moduledt.jsp";
                document.frmmodule.submit();
            }
            
            
            function cmdEditBudget(oid,oidBudget,index){
                document.frmmodule.hidden_module_id.value=oid;
                document.frmmodule.hidden_module_budget_id.value=oidBudget;
                document.frmmodule.command.value="<%=JSPCommand.EDIT%>";
                document.frmmodule.index.value=index;
                document.frmmodule.action="moduledt.jsp";
                document.frmmodule.submit();
            }    
            
            function cmdBack(variable){
                document.frmmodule.command.value="<%=JSPCommand.YES%>";
                document.frmmodule.hidden_var.value=variable;
                <%if (useGereja) {%>
                document.frmmodule.action="moduleg.jsp";
                <%} else {%>
                document.frmmodule.action="module.jsp";
                <%}%>
                document.frmmodule.submit();
            }
            
            function cmdListFirst(){
                document.frmmodule.command.value="<%=JSPCommand.FIRST%>";
                document.frmmodule.prev_command.value="<%=JSPCommand.FIRST%>";
                document.frmmodule.action="moduledt.jsp";
                document.frmmodule.submit();
            }
            
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
            
            function checkNumber(){
                var st = document.frmmodule.<%=JspModuleBudget.colNames[JspModuleBudget.JSP_AMOUNT]%>.value;		
                
                result = removeChar(st);
                
                result = cleanNumberFloat(result, sysDecSymbol, usrDigitGroup, usrDecSymbol);
                document.frmmodule.<%=JspModuleBudget.colNames[JspModuleBudget.JSP_AMOUNT]%>.value = formatFloat(result, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 
            }
            
            function cmdListPrev(){
                document.frmmodule.command.value="<%=JSPCommand.PREV%>";
                document.frmmodule.prev_command.value="<%=JSPCommand.PREV%>";
                document.frmmodule.action="moduledt.jsp";
                document.frmmodule.submit();
            }
            
            function cmdListNext(){
                document.frmmodule.command.value="<%=JSPCommand.NEXT%>";
                document.frmmodule.prev_command.value="<%=JSPCommand.NEXT%>";
                document.frmmodule.action="moduledt.jsp";
                document.frmmodule.submit();
            }
            
            function cmdListLast(){
                document.frmmodule.command.value="<%=JSPCommand.LAST%>";
                document.frmmodule.prev_command.value="<%=JSPCommand.LAST%>";
                document.frmmodule.action="moduledt.jsp";
                document.frmmodule.submit();
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
                  <%@ include file="../calendar/calendarframe.jsp"%>
                                        <!-- #EndEditable --> </td>
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
                                                        <form name="frmmodule" method ="post" action="">
                                                            <input type="hidden" name="command" value="<%=iJSPCommand%>">
                                                            <input type="hidden" name="vectSize" value="<%=vectSize%>">
                                                            <input type="hidden" name="start" value="<%=start%>">
                                                            <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                                                            <input type="hidden" name="hidden_module_id" value="<%=oidModule%>">
                                                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                            <input type="hidden" name="hidden_module_budget_id" value="<%=oidModuleBudget%>">
                                                            <input type="hidden" name="hidden_var" value="<%=var%>">
                                                            <input type="hidden" name="index" value="<%=index%>">
                                                            <input type="hidden" name="<%=jspModule.colNames[JspModule.JSP_CREATE_ID]%>"  value="<%=user.getEmployeeId()%>">
                                                            <input type="hidden" name="<%=jspModule.colNames[JspModule.JSP_DOC_STATUS]%>"  value="<%=DbModule.DOC_STATUS_DRAFT%>">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr> 
                                                                    <td class="container"> 
                                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="8" valign="middle" colspan="3" class="page"> 
                                                                                    <table width="100%" border="0" cellspacing="1" cellpadding="0">
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="6" valign="middle" colspan="3"></td>
                                                                                        </tr>
                                                                                        <tr align="left"> 
                                                                                        <td height="21" colspan="3"> 
                                                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                                <tr> 
                                                                                                    <td width="20%" valign="top"> 
                                                                                                        <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                                                                                            <tr > 
                                                                                                                <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="17" height="10"></td>
                                                                                                                <td class="tabin"> 
                                                                                                                    <%if (useGereja) {%>
                                                                                                                    <div align="center">&nbsp;&nbsp;<a href="moduleg.jsp?menu_idx=<%=menuIdx%>" class="tablink">Records</a>&nbsp;&nbsp;</div>
                                                                                                                    <%} else {%>
                                                                                                                    <div align="center">&nbsp;&nbsp;<a href="module.jsp?menu_idx=<%=menuIdx%>" class="tablink">Records</a>&nbsp;&nbsp;</div>
                                                                                                                    <%}%>
                                                                                                                </td>
                                                                                                                <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                                                                                                <td class="tab"> 
                                                                                                                    <div align="center">&nbsp;&nbsp;Editor&nbsp;&nbsp;</div>
                                                                                                                </td>
                                                                                                                <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                                                                                                <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                                                                                                <td width="100%" class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="10" height="10"></td>
                                                                                                            </tr>
                                                                                                        </table>
                                                                                                    </td>
                                                                                                </tr>
                                                                                            </table>
                                                                                        </td>
                                                                                        <tr align="left"> 
                                                                                        <td height="21" width="12%">&nbsp;</td>
                                                                                        <td height="21" colspan="2" width="88%">&nbsp; 
                                                                                        <tr align="left"> 
                                                                                        <td height="21" width="12%">&nbsp;<%=langCT[0]%> </td>
                                                                                        <td height="21" colspan="2" width="88%"> 
                                                                                        <%
            Vector actPeriods = DbActivityPeriod.list(0, 0, "", "");
                                                                                        %>
                                                                                        <select name="<%=jspModule.colNames[JspModule.JSP_ACTIVITY_PERIOD_ID] %>">
                                                                                            <%if (actPeriods != null && actPeriods.size() > 0) {
                for (int i = 0; i < actPeriods.size(); i++) {
                    ActivityPeriod ap = (ActivityPeriod) actPeriods.get(i);
                    if (ap.getOID() == apOpen.getOID()) {
                                                                                            %>
                                                                                            <option value="<%=ap.getOID()%>" <%if (ap.getOID() == module.getActivityPeriodId()) {%>selected<%}%>><%=ap.getName()%></option>
                                                                                            <%}
                }
            }%>
                                                                                        </select>
                                                                                        <%
            Vector segments = DbSegment.list(0, 0, "", "count");
            int sizeSegment = 0;
            if (segments != null && segments.size() > 0) {
                User usr = new User();
                try {
                    usr = DbUser.fetch(appSessUser.getUserOID());
                } catch (Exception e) {
                }

                sizeSegment = segments.size();

                for (int i = 0; i < segments.size(); i++) {

                    Segment seg = (Segment) segments.get(i);

                    String wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_ID] + " = " + seg.getOID();

                    switch (i + 1) {
                        case 1:
                            //Jika sama dengan 0 maka akan ditampilkan smua detail segment, tetapi jika tidak
                            //maka akan di tampikan sesuai dengan segment yang ditentukan
                            if (usr.getSegment1Id() != 0) {
                                wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + usr.getSegment1Id();
                            }
                            break;
                        case 2:
                            if (usr.getSegment2Id() != 0) {
                                wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + usr.getSegment2Id();
                            }
                            break;
                        case 3:
                            if (usr.getSegment3Id() != 0) {
                                wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + usr.getSegment3Id();
                            }
                            break;
                        case 4:
                            if (usr.getSegment4Id() != 0) {
                                wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + usr.getSegment4Id();
                            }
                            break;
                        case 5:
                            if (usr.getSegment5Id() != 0) {
                                wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + usr.getSegment5Id();
                            }
                            break;
                        case 6:
                            if (usr.getSegment6Id() != 0) {
                                wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + usr.getSegment6Id();
                            }
                            break;
                        case 7:
                            if (usr.getSegment7Id() != 0) {
                                wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + usr.getSegment7Id();
                            }
                            break;
                        case 8:
                            if (usr.getSegment8Id() != 0) {
                                wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + usr.getSegment8Id();
                            }
                            break;
                        case 9:
                            if (usr.getSegment9Id() != 0) {
                                wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + usr.getSegment9Id();
                            }
                            break;
                        case 10:
                            if (usr.getSegment10Id() != 0) {
                                wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + usr.getSegment10Id();
                            }
                            break;
                        case 11:
                            if (usr.getSegment11Id() != 0) {
                                wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + usr.getSegment11Id();
                            }
                            break;
                        case 12:
                            if (usr.getSegment12Id() != 0) {
                                wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + usr.getSegment12Id();
                            }
                            break;
                        case 13:
                            if (usr.getSegment13Id() != 0) {
                                wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + usr.getSegment13Id();
                            }
                            break;
                        case 14:
                            if (usr.getSegment14Id() != 0) {
                                wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + usr.getSegment14Id();
                            }
                            break;
                        case 15:
                            if (usr.getSegment15Id() != 0) {
                                wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + usr.getSegment15Id();
                            }
                            break;
                    }

                    Vector sgDetails = DbSegmentDetail.list(0, 0, wh, "");
                                                                                        %>
                                                                                        <tr align="left"> 
                                                                                            <td height="21" width="12%">&nbsp;<%=seg.getName()%></td>
                                                                                            <td height="21" colspan="2" width="88%"> 
                                                                                                <select name="JSP_SEGMENT<%=i + 1%>_ID">
                                                                                                    <%if (sgDetails != null && sgDetails.size() > 0) {
                                                                                                    for (int x = 0; x < sgDetails.size(); x++) {
                                                                                                        SegmentDetail sd = (SegmentDetail) sgDetails.get(x);
                                                                                                        String selected = "";
                                                                                                        switch (i + 1) {
                                                                                                            case 1:
                                                                                                                if (module.getSegment1Id() == sd.getOID()) {
                                                                                                                    selected = "selected";
                                                                                                                }
                                                                                                                break;
                                                                                                            case 2:
                                                                                                                if (module.getSegment2Id() == sd.getOID()) {
                                                                                                                    selected = "selected";
                                                                                                                }
                                                                                                                break;
                                                                                                            case 3:
                                                                                                                if (module.getSegment3Id() == sd.getOID()) {
                                                                                                                    selected = "selected";
                                                                                                                }
                                                                                                                break;
                                                                                                            case 4:
                                                                                                                if (module.getSegment4Id() == sd.getOID()) {
                                                                                                                    selected = "selected";
                                                                                                                }
                                                                                                                break;
                                                                                                            case 5:
                                                                                                                if (module.getSegment5Id() == sd.getOID()) {
                                                                                                                    selected = "selected";
                                                                                                                }
                                                                                                                break;
                                                                                                            case 6:
                                                                                                                if (module.getSegment6Id() == sd.getOID()) {
                                                                                                                    selected = "selected";
                                                                                                                }
                                                                                                                break;
                                                                                                            case 7:
                                                                                                                if (module.getSegment7Id() == sd.getOID()) {
                                                                                                                    selected = "selected";
                                                                                                                }
                                                                                                                break;
                                                                                                            case 8:
                                                                                                                if (module.getSegment8Id() == sd.getOID()) {
                                                                                                                    selected = "selected";
                                                                                                                }
                                                                                                                break;
                                                                                                            case 9:
                                                                                                                if (module.getSegment9Id() == sd.getOID()) {
                                                                                                                    selected = "selected";
                                                                                                                }
                                                                                                                break;
                                                                                                            case 10:
                                                                                                                if (module.getSegment10Id() == sd.getOID()) {
                                                                                                                    selected = "selected";
                                                                                                                }
                                                                                                                break;
                                                                                                            case 11:
                                                                                                                if (module.getSegment11Id() == sd.getOID()) {
                                                                                                                    selected = "selected";
                                                                                                                }
                                                                                                                break;
                                                                                                            case 12:
                                                                                                                if (module.getSegment12Id() == sd.getOID()) {
                                                                                                                    selected = "selected";
                                                                                                                }
                                                                                                                break;
                                                                                                            case 13:
                                                                                                                if (module.getSegment13Id() == sd.getOID()) {
                                                                                                                    selected = "selected";
                                                                                                                }
                                                                                                                break;
                                                                                                            case 14:
                                                                                                                if (module.getSegment14Id() == sd.getOID()) {
                                                                                                                    selected = "selected";
                                                                                                                }
                                                                                                                break;
                                                                                                            case 15:
                                                                                                                if (module.getSegment5Id() == sd.getOID()) {
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
                                                                                        <%if (!useGereja) {%>
                                                                                        <tr align="left"> 
                                                                                        <td height="21" width="12%">&nbsp;<%=langCT[1]%></td>
                                                                                        <td height="21" colspan="2" width="88%"> 
                                                                                        <input type="text" name="<%=jspModule.colNames[JspModule.JSP_INITIAL] %>"  value="<%= module.getInitial() %>" class="formElemen" size="15">
                                                                                        <%}%>
                                                                                        <tr align="left"> 
                                                                                            <td height="21" width="12%">&nbsp;<%=langCT[2]%></td>
                                                                                            <td height="21" colspan="2" width="88%"> 
                                                                                                <input type="text" name="<%=jspModule.colNames[JspModule.JSP_CODE]%>"  value="<%= module.getCode() %>" class="formElemen" size="33" readonly>
                                                                                            * <%= jspModule.getErrorMsg(JspModule.JSP_CODE) %> </td>
                                                                                        </tr>
                                                                                        <tr> 
                                                                                            <td colspan="2">&nbsp;</td>
                                                                                        </tr>
                                                                                        <tr> 
                                                                                            <td colspan="2"><font color="#238836">&nbsp;<%=langNav[7]%></font></td>
                                                                                        </tr>
                                                                                        <tr> 
                                                                                            <td colspan=2>&nbsp;</td>
                                                                                        </tr>
                                                                                        <tr align="left"> 
                                                                                        <td height="21" width="12%" valign="top">&nbsp;<%=langCT[3]%></td>
                                                                                        <td height="21" colspan="2" width="88%" valign="top"> 
                                                                                        <table width="100%" cellpadding="0" cellspacing="0">
                                                                                            <tr> 
                                                                                                <td width="200"> 
                                                                                                    <textarea name="<%=jspModule.colNames[JspModule.JSP_DESCRIPTION] %>" class="formElemen" cols="100" rows="3"><%= module.getDescription() %></textarea>
                                                                                                </td>
                                                                                                <td valign="top">&nbsp;* <%= jspModule.getErrorMsg(JspModule.JSP_DESCRIPTION) %></td>
                                                                                            </tr>
                                                                                        </table>
                                                                                        <tr align="left"> 
                                                                                        <td height="21" width="12%" valign="top">&nbsp;<%=langCT[4]%></td>
                                                                                        <td height="21" colspan="2" width="88%"> 
                                                                                        <textarea name="<%=jspModule.colNames[JspModule.JSP_OUTPUT_DELIVER] %>" class="formElemen" cols="100" rows="3"><%= module.getOutputDeliver() %></textarea>
                                                                                        <tr align="left"> 
                                                                                        <td height="21" width="12%" valign="top">&nbsp;<%=langCT[17]%></td>
                                                                                        <td height="21" colspan="2" width="88%"> 
                                                                                        <textarea name="<%=jspModule.colNames[JspModule.JSP_ACT_DAY] %>" class="formElemen" cols="100" rows="3"><%= module.getActDay() %></textarea>
                                                                                        <tr align="left"> 
                                                                                        <td height="21" width="12%" valign="top">&nbsp;<%=langCT[18]%></td>
                                                                                        <td height="21" colspan="2" width="88%"> 
                                                                                        <textarea name="<%=jspModule.colNames[JspModule.JSP_ACT_DATE] %>" class="formElemen" cols="100" rows="3"><%= module.getActDate() %></textarea>
                                                                                        <tr align="left"> 
                                                                                        <td height="21" width="12%" valign="top">&nbsp;<%=langCT[19]%></td>
                                                                                        <td height="21" colspan="2" width="88%"> 
                                                                                        <textarea name="<%=jspModule.colNames[JspModule.JSP_ACT_TIME] %>" class="formElemen" cols="100" rows="3"><%= module.getActTime() %></textarea>
                                                                                        <tr align="left"> 
                                                                                        <td height="21" width="12%" valign="top">&nbsp;<%=langCT[20]%></td>
                                                                                        <td height="21" colspan="2" width="88%"> 
                                                                                        <textarea name="<%=jspModule.colNames[JspModule.JSP_NOTE] %>" class="formElemen" cols="100" rows="3"><%= module.getNote() %></textarea>
                                                                                        <%if (!useGereja) {%>
                                                                                        <tr align="left"> 
                                                                                        <td height="21" width="12%" valign="top">&nbsp;<%=langCT[5]%></td>
                                                                                        <td height="21" colspan="2" width="88%"> 
                                                                                        <textarea name="<%=jspModule.colNames[JspModule.JSP_PERFORM_INDICATOR] %>" class="formElemen" cols="100" rows="3"><%= module.getPerformIndicator() %></textarea>
                                                                                        <tr align="left"> 
                                                                                        <td height="21" width="12%" valign="top">&nbsp;<%=langCT[6]%></td>
                                                                                        <td height="21" colspan="2" width="88%"> 
                                                                                        <textarea name="<%=jspModule.colNames[JspModule.JSP_ASSUM_RISK] %>" class="formElemen" cols="100" rows="3"><%= module.getAssumRisk() %></textarea>
                                                                                        <tr align="left"> 
                                                                                        <td height="21" width="12%" valign="top">&nbsp;<%=langCT[7]%></td>
                                                                                        <td height="21" colspan="2" width="88%"> 
                                                                                        <textarea name="<%=jspModule.colNames[JspModule.JSP_COST_IMPLICATION]%>" class="formElemen" cols="100" rows="3"><%= module.getCostImplication() %></textarea>
                                                                                        <%}%>
                                                                                        <%if (true) {%>
                                                                                        <tr align="left"> 
                                                                                        <td height="21" width="12%">&nbsp;<%=langCT[8]%></td>
                                                                                        <td height="21" colspan="2" width="88%"> 
                                                                                        <input type="text" name="<%=jspModule.colNames[JspModule.JSP_MODULE_LEVEL]%>" class="formElemen" size="3" value="<%= module.getModuleLevel()%>" readonly>
                                                                                        <tr> 
                                                                                            <td height="21" width="12%">&nbsp;<%=langCT[9]%> </td>
                                                                                            <td height="21" colspan="2" width="88%"> 
                                                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                                <tr> 
                                                                                                    <td width="56%" nowrap> 
                                                                                                        <%
    Module mInduk = new Module();
    if (module.getParentId() != 0) {
        mInduk = DbModule.fetchExc(module.getParentId());
    }
                                                                                                        %>
                                                                                                        <input type="hidden" name="<%=jspModule.colNames[JspModule.JSP_PARENT_ID]%>" class="formElemen" size="100" value="<%= module.getParentId()%>">
                                                                                                        <input type="text" name="JSP_PARENT_DESCRIPTION" class="formElemen" size="100" value="<%=mInduk.getDescription()%>">
                                                                                                    </td>
                                                                                                    <td width="3%"><a href="javascript:cmdKegiatanOpen('<%=sizeSegment%>','<%=module.getOID()%>')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('open','','../images/search.jpg',1)"><img src="../images/search2.jpg" name="open" height="17" border="0" style="padding:0px"></a> 
                                                                                                    </td>
                                                                                                    <td width="41%">&nbsp;<a href="javascript:cmdReset()">Reset</a></td>
                                                                                                </tr>
                                                                                            </table>
                                                                                            <input type="hidden" name="<%=jspModule.colNames[JspModule.JSP_STATUS_POST]%>" value="<%=I_Project.ACCOUNT_LEVEL_POSTABLE%>" size="15" readOnly>
                                                                                        </tr>
                                                                                        <%}%>
                                                                                        <%if (!useGereja) {%>
                                                                                        <tr align="left"> 
                                                                                        <td height="21" width="12%">&nbsp;<%=langCT[11]%></td>
                                                                                        <td height="21" colspan="2" width="88%"> 
                                                                                        <% Vector type_value = new Vector(1, 1);
    Vector type_key = new Vector(1, 1);

    String sel_type = "" + module.getType();
    for (int i = 0; i < I_Project.actTypes.length; i++) {
        type_key.add(I_Project.actTypes[i]);
        type_value.add(I_Project.actTypes[i]);
    }
                                                                                        %>
                                                                                        <%= JSPCombo.draw(jspModule.colNames[JspModule.JSP_TYPE], null, sel_type, type_key, type_value, "", "formElemen") %> 
                                                                                        <%}%>
                                                                                        <tr align="left"> 
                                                                                            <td height="8" valign="middle" width="12%">&nbsp;<%=langCT[12]%></td>
                                                                                            <td height="8" colspan="2" width="88%" valign="top"> 
                                                                                                <select name="<%=jspModule.colNames[JspModule.JSP_STATUS]%>">
                                                                                                    <%for (int i = 0; i < I_Project.statusArray1.length; i++) {%>
                                                                                                    <option value="<%=I_Project.statusArray1[i]%>" <%if ((I_Project.statusArray1[i]).equals(module.getStatus())) {%>selected<%}%>><%=I_Project.statusArray1[i]%></option>
                                                                                                    <%}%>
                                                                                                </select>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr align="left"> 
                                                                                            <td height="8" valign="middle" width="12%">&nbsp;</td>
                                                                                            <td height="8" colspan="2" width="88%" valign="top">&nbsp;</td>
                                                                                        </tr>
                                                                                        <%if (iErrCode != JSPMessage.NONE && iJSPCommand == JSPCommand.SAVE) {%>
                                                                                        <tr> 
                                                                                            <td colspan="3"> 
                                                                                                <table border="0" cellpadding="5" cellspacing="0" class="warning">
                                                                                                    <tr> 
                                                                                                        <td width="20"><img src="../images/error.gif" width="20" height="20"></td>
                                                                                                        <td width="300" nowrap>Error, 
                                                                                                        data belum lengkap</td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr align="left"> 
                                                                                            <td height="8" valign="middle" width="12%">&nbsp;</td>
                                                                                            <td height="8" colspan="2" width="88%" valign="top">&nbsp;</td>
                                                                                        </tr>
                                                                                        <%}%>
                                                                                        <%if (iJSPCommand == JSPCommand.SAVE && iErrCode == 0) {%>
                                                                                        <tr> 
                                                                                            <td colspan="4"> 
                                                                                                <table border="0" cellpadding="5" cellspacing="0" class="success">
                                                                                                    <tr> 
                                                                                                        <td width="20"><img src="../images/success.gif" width="20" height="20"></td>
                                                                                                        <td width="200" nowrap><%=langNav[3]%></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <%}%>
                                                                                        <tr> 
                                                                                            <td colspan="3"> 
                                                                                                <table>
                                                                                                    <tr> 
                                                                                                        <td width="80"> <a href="javascript:cmdSave()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('news','','../images/save2.gif',1)"><img src="../images/save.gif" name="news" border="0"></a> 
                                                                                                        </td>
                                                                                                        <%if (module.getOID() != 0) {%>
                                                                                                        <td width="80"> <a href="javascript:cmdDelete('<%=module.getOID()%>')"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('news1','','../images/delete2.gif',1)"><img src="../images/delete.gif" name="news1" border="0"></a> 
                                                                                                        </td>
                                                                                                        <%}%>
                                                                                                        <td width="80"> <a href="javascript:cmdBack('<%=var%>')"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('newc1','','../images/back2.gif',1)"><img src="../images/back.gif" name="newc1" border="0"></a> 
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr align="left" > 
                                                                                            <td colspan="3" valign="top">&nbsp;</td>
                                                                                        </tr>
                                                                                        <tr align="left" bgcolor="#CCCCCC" > 
                                                                                            <td colspan="3" valign="top" height="2"></td>
                                                                                        </tr>
                                                                                        <tr align="left" > 
                                                                                            <td colspan="3" valign="top">&nbsp;</td>
                                                                                        </tr>
                                                                                        <%
            if (module.getOID() != 0) {
                long IDR = 0;
                try {
                    IDR = Long.parseLong(DbSystemProperty.getValueByName("OID_CURRENCY_RP"));
                } catch (Exception e) {
                }
                                                                                        %>
                                                                                        <tr align="left" > 
                                                                                            <td colspan="3" valign="top"><a name="go"></a></td>
                                                                                        </tr>
                                                                                        <tr align="left" > 
                                                                                            <td colspan="3" valign="top" align="left"><b>&nbsp;<u><%=langNav[2]%></u></b></td>
                                                                                        </tr>
                                                                                        <tr align="left" > 
                                                                                            <td height = "4px" colspan="3" valign="top"></td>
                                                                                        </tr>
                                                                                        <tr> 
                                                                                            <td colspan="3"> 
                                                                                                <table width="50%" cellpadding="0" cellspacing="1">
                                                                                                    <tr> 
                                                                                                        <td class="tablehdr" align="center"><%=langCT[13]%></td>
                                                                                                        <td class="tablehdr"><%=langCT[14]%></td>
                                                                                                        <td class="tablehdr"><%=langCT[15]%></td>
                                                                                                        <td class="tablehdr"><%=langCT[16]%></td>
                                                                                                    </tr>
                                                                                                    <%
                                                                                            int pg = 1;
                                                                                            if (listModuleBudget != null && listModuleBudget.size() > 0) {
                                                                                                for (int ixMb = 0; ixMb < listModuleBudget.size(); ixMb++) {
                                                                                                    ModuleBudget modBudget = (ModuleBudget) listModuleBudget.get(ixMb);
                                                                                                    String namaCoa = "";
                                                                                                    try {
                                                                                                        Coa coa = DbCoa.fetchExc(modBudget.getCoaId());
                                                                                                        namaCoa = coa.getName();
                                                                                                    } catch (Exception e) {
                                                                                                    }

                                                                                                    %>
                                                                                                    <%if (index != pg || (iJSPCommand == JSPCommand.SUBMIT && iErrCodeBudget == 0)) {%>
                                                                                                    <tr> 
                                                                                                        <td class="tablecell" align="center"><%=pg%></td>
                                                                                                        <td class="tablecell" align="left"><a href="javascript:cmdEditBudget('<%=module.getOID()%>','<%=modBudget.getOID()%>','<%=pg%>')"><%=modBudget.getDescription()%></a></td>
                                                                                                        <td class="tablecell" align="left"><%=namaCoa%></td>
                                                                                                        <td class="tablecell" align="right"><%=JSPFormater.formatNumber(modBudget.getAmount(), "#,###.##")%></td>
                                                                                                    </tr>
                                                                                                    <%} else {%>
                                                                                                    <input type="hidden" name="<%=jspModuleBudget.colNames[jspModuleBudget.JSP_USER_UPDATE_ID]%>"  value="<%=user.getEmployeeId()%>">
                                                                                                    <input type="hidden" name="<%=jspModuleBudget.colNames[JspModuleBudget.JSP_CURRENCY_ID]%>" value ="<%=IDR%>">
                                                                                                    <input type="hidden" name="<%=jspModuleBudget.colNames[JspModuleBudget.JSP_MODULE_ID]%>" value ="<%=module.getOID()%>">
                                                                                                    <tr> 
                                                                                                        <td align="center" class="tablecell"><%=pg%></td>
                                                                                                        <td class="tablecell"> 
                                                                                                            <input type="text" style="text-align:left;" name="<%=jspModuleBudget.colNames[JspModuleBudget.JSP_DESCRIPTION]%>" value ="<%=modBudget.getDescription()%>" size="50">
                                                                                                        <%= jspModuleBudget.getErrorMsg(JspModuleBudget.JSP_DESCRIPTION) %></td>
                                                                                                        <td class="tablecell"> 
                                                                                                            <select name="<%=jspModuleBudget.colNames[JspModuleBudget.JSP_COA_ID]%>">
                                                                                                                <option value="0">select..</option>
                                                                                                                <%
    Vector vCoa = new Vector();

    vCoa = DbCoa.list(0, 0, "account_group='Expense'", "code");

    if (vCoa != null && vCoa.size() > 0) {
        for (int ix = 0; ix < vCoa.size(); ix++) {
            Coa objCoas = (Coa) vCoa.get(ix);

            String str = "";
            switch (objCoas.getLevel()) {

                case 1:
                    break;
                case 2:
                    str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                    break;
                case 3:
                    str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                    break;
                case 4:
                    str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                    break;
                case 5:
                    str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                    break;
            }
                                                                                                                %>
                                                                                                                <option <%if (modBudget.getCoaId() == objCoas.getOID()) {%>selected<%}%> value="<%=objCoas.getOID()%>"><%=str + objCoas.getCode() + " - " + objCoas.getName()%></option>
                                                                                                                <%}
    }%>
                                                                                                            </select>
                                                                                                        <%= jspModuleBudget.getErrorMsg(JspModuleBudget.JSP_COA_ID) %> </td>
                                                                                                        <td class="tablecell"> 
                                                                                                            <input type="text" style="text-align:right;" name="<%=jspModuleBudget.colNames[JspModuleBudget.JSP_AMOUNT]%>" value ="<%=JSPFormater.formatNumber(modBudget.getAmount(), "#,###.##")%>" class="formElemen" onBlur="javascript:checkNumber()" size="25" onClick="this.select()">
                                                                                                        <%= jspModuleBudget.getErrorMsg(JspModuleBudget.JSP_AMOUNT) %></td>
                                                                                                    </tr>
                                                                                                    <%}%>
                                                                                                    <%
                                                                                                    pg++;
                                                                                                }
                                                                                            }
                                                                                            boolean isShow = false;
                                                                                            if (iJSPCommand == JSPCommand.DETAIL || (iJSPCommand == JSPCommand.SUBMIT && iErrCodeBudget > 0)) {
                                                                                                isShow = true;
                                                                                            }

                                                                                            if (index == 0 && iJSPCommand != JSPCommand.LOCK && iJSPCommand != JSPCommand.EDIT && iJSPCommand != JSPCommand.SAVE && iJSPCommand != JSPCommand.YES && isShow) {
                                                                                                    %>
                                                                                                    <input type="hidden" name="<%=jspModuleBudget.colNames[jspModuleBudget.JSP_USER_UPDATE_ID]%>"  value="<%=user.getEmployeeId()%>">
                                                                                                    <input type="hidden" name="<%=jspModuleBudget.colNames[JspModuleBudget.JSP_CURRENCY_ID]%>" value ="<%=IDR%>">
                                                                                                    <input type="hidden" name="<%=jspModuleBudget.colNames[JspModuleBudget.JSP_MODULE_ID]%>" value ="<%=module.getOID()%>">
                                                                                                    <tr> 
                                                                                                        <td align="center" class="tablecell"><%=pg%></td>
                                                                                                        <td class="tablecell"> 
                                                                                                            <input type="text" style="text-align:left;" name="<%=jspModuleBudget.colNames[JspModuleBudget.JSP_DESCRIPTION]%>" value ="<%=moduleBudget.getDescription()%>" size="50">
                                                                                                        <%= jspModuleBudget.getErrorMsg(JspModuleBudget.JSP_DESCRIPTION) %></td>
                                                                                                        <td class="tablecell"> 
                                                                                                            <select name="<%=jspModuleBudget.colNames[JspModuleBudget.JSP_COA_ID]%>">
                                                                                                                <option  value="0">select...</option>
                                                                                                                <%
                                                                                                Vector vCoa = new Vector();

                                                                                                vCoa = DbCoa.list(0, 0, "account_group='Expense'", "code");

                                                                                                if (vCoa != null && vCoa.size() > 0) {
                                                                                                    for (int ix = 0; ix < vCoa.size(); ix++) {
                                                                                                        Coa objCoas = (Coa) vCoa.get(ix);

                                                                                                        String str = "";
                                                                                                        switch (objCoas.getLevel()) {

                                                                                                            case 1:
                                                                                                                break;
                                                                                                            case 2:
                                                                                                                str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                                                                                                                break;
                                                                                                            case 3:
                                                                                                                str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                                                                                                                break;
                                                                                                            case 4:
                                                                                                                str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                                                                                                                break;
                                                                                                            case 5:
                                                                                                                str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                                                                                                                break;
                                                                                                        }

                                                                                                                %>
                                                                                                                <option <%if (moduleBudget.getCoaId() == objCoas.getOID()) {%>selected<%}%> value="<%=objCoas.getOID()%>"><%=str + objCoas.getCode() + " - " + objCoas.getName()%></option>
                                                                                                                <%}
                                                                                                }%>
                                                                                                            </select>
                                                                                                        <%= jspModuleBudget.getErrorMsg(JspModuleBudget.JSP_COA_ID) %> </td>
                                                                                                        <td class="tablecell"> 
                                                                                                            <input type="text" style="text-align:right;" name="<%=jspModuleBudget.colNames[JspModuleBudget.JSP_AMOUNT]%>" value ="<%=JSPFormater.formatNumber(moduleBudget.getAmount(), "#,###.##")%>" class="formElemen" onBlur="javascript:checkNumber()" size="25" onClick="this.select()">
                                                                                                        <%= jspModuleBudget.getErrorMsg(JspModuleBudget.JSP_AMOUNT) %></td>
                                                                                                    </tr>
                                                                                                    <%}%>
                                                                                                    <tr> 
                                                                                                        <td colspan="4">&nbsp;</td>
                                                                                                    </tr>
                                                                                                    <%if (iJSPCommand == JSPCommand.SUBMIT && iErrCodeBudget == 0) {%>
                                                                                                    <tr> 
                                                                                                        <td colspan="4"> 
                                                                                                            <table border="0" cellpadding="5" cellspacing="0" class="success">
                                                                                                                <tr> 
                                                                                                                    <td width="20"><img src="../images/success.gif" width="20" height="20"></td>
                                                                                                                    <td width="200" nowrap><%=langNav[3]%></td>
                                                                                                                </tr>
                                                                                                            </table>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <%}%>
                                                                                                    <%if (iJSPCommand == JSPCommand.SUBMIT && iErrCodeBudget != 0) {%>
                                                                                                    <tr> 
                                                                                                        <td colspan="4"> 
                                                                                                            <table border="0" cellpadding="5" cellspacing="0" class="warning">
                                                                                                                <tr> 
                                                                                                                    <td width="20"><img src="../images/error.gif" width="20" height="20"></td>
                                                                                                                    <td width="300" nowrap><%=langNav[4]%></td>
                                                                                                                </tr>
                                                                                                            </table>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <%}%>
                                                                                                    <%if (iJSPCommand == JSPCommand.YES && iErrCodeBudget == 0) {%>
                                                                                                    <tr> 
                                                                                                        <td colspan="4"> 
                                                                                                            <table border="0" cellpadding="5" cellspacing="0" class="success">
                                                                                                                <tr> 
                                                                                                                    <td width="20"><img src="../images/success.gif" width="20" height="20"></td>
                                                                                                                    <td width="200" nowrap><%=langNav[5]%></td>
                                                                                                                </tr>
                                                                                                            </table>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <%}%>
                                                                                                    <tr> 
                                                                                                        <td colspan="4"> 
                                                                                                            <table>
                                                                                                                <tr> 
                                                                                                                    <%if (!(iJSPCommand == JSPCommand.SUBMIT && iErrCodeBudget > 0)) {%>
                                                                                                                    <%if (code == 1 || !(iJSPCommand == JSPCommand.DETAIL || iJSPCommand == JSPCommand.EDIT)) {%>
                                                                                                                    <td width="80"><a href="javascript:cmdAddDetail('<%=module.getOID()%>')"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new31','','../images/new2.gif',1)"><img src="../images/new.gif" name="new31" border="0"></a> 
                                                                                                                    </td>
                                                                                                                    <%}%>
                                                                                                                    <%}%>
                                                                                                                    <%if (iJSPCommand == JSPCommand.SUBMIT && iErrCodeBudget > 0) {%>
                                                                                                                    <td width="80"><a href="javascript:cmdSaveDetail('<%=module.getOID()%>')"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new21','','../images/save2.gif',1)"><img src="../images/save.gif" name="new21" border="0"></a> 
                                                                                                                    <%} else {%>
                                                                                                                    <%if (iJSPCommand != JSPCommand.LOCK && code == 0 && iJSPCommand != JSPCommand.SUBMIT && iJSPCommand != JSPCommand.SAVE && iJSPCommand != JSPCommand.YES) {%>
                                                                                                                    <td width="80"><a href="javascript:cmdSaveDetail('<%=module.getOID()%>')"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new21','','../images/save2.gif',1)"><img src="../images/save.gif" name="new21" border="0"></a> 
                                                                                                                    </td>
                                                                                                                    <%}%>
                                                                                                                    <%}%>
                                                                                                                    <%if (moduleBudget.getOID() != 0 && index != 0) {%>
                                                                                                                    <td width="80"> <a href="javascript:cmdDeleteBudget('<%=module.getOID()%>','<%=moduleBudget.getOID()%>')"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('newd1','','../images/delete2.gif',1)"><img src="../images/delete.gif" name="newd1" border="0"></a> 
                                                                                                                    </td>
                                                                                                                    <%}%>
                                                                                                                    <%if (iJSPCommand == JSPCommand.SUBMIT && iErrCodeBudget > 0) {%>
                                                                                                                    <td width="80"> <a href="javascript:cmdBackBudget('<%=module.getOID()%>','<%=moduleBudget.getOID()%>')"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('can','','../images/cancel2.gif',1)"><img src="../images/cancel.gif" name="can" border="0"></a></td>
                                                                                                                    <%} else {%>
                                                                                                                    <%if (iJSPCommand != JSPCommand.LOCK && code == 0 && iJSPCommand != JSPCommand.SUBMIT && iJSPCommand != JSPCommand.SAVE && iJSPCommand != JSPCommand.YES) {%>
                                                                                                                    <td width="80"> <a href="javascript:cmdBackBudget('<%=module.getOID()%>','<%=moduleBudget.getOID()%>')"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('can','','../images/cancel2.gif',1)"><img src="../images/cancel.gif" name="can" border="0"></a></td>
                                                                                                                    <%}%>
                                                                                                                    <%}%>
                                                                                                                </tr>
                                                                                                            </table>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <tr>
                                                                                                        <td colspan="4">&nbsp;</td>
                                                                                                    </tr> 
                                                                                                    <%if (listModuleBudgetHistory != null && listModuleBudgetHistory.size() > 0) {%>
                                                                                                    <tr>
                                                                                                        <td colspan="4">
                                                                                                            <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                                                                                                <tr>
                                                                                                                    <td colspan="4">&nbsp;<b><i>History Anggaran</i></b></td>
                                                                                                                </tr> 
                                                                                                                <tr> 
                                                                                                                    <td class="tablehdr" align="center"><%=langCT[13]%></td>
                                                                                                                    <td class="tablehdr"><%=langCT[14]%></td>
                                                                                                                    <td class="tablehdr"><%=langCT[15]%></td>
                                                                                                                    <td class="tablehdr"><%=langCT[16]%></td>                                                                                                                    
                                                                                                                </tr>
                                                                                                                <%
    for (int ixMb = 0; ixMb < listModuleBudgetHistory.size(); ixMb++) {
        ModuleBudget modBudget = (ModuleBudget) listModuleBudgetHistory.get(ixMb);
        String namaCoa = "";
        try {
            Coa coa = DbCoa.fetchExc(modBudget.getCoaId());
            namaCoa = coa.getName();
        } catch (Exception e) {
        }

                                                                                                                %>
                                                                                                                
                                                                                                                <tr> 
                                                                                                                    <td class="tablecell" align="center"><%=(ixMb + 1)%></td>
                                                                                                                    <td class="tablecell" align="left"><%=modBudget.getDescription()%></td>
                                                                                                                    <td class="tablecell" align="left"><%=namaCoa%></td>
                                                                                                                    <td class="tablecell" align="right"><%=JSPFormater.formatNumber(modBudget.getAmount(), "#,###.##")%></td>                                                                                                                    
                                                                                                                </tr>                                                                                                            
                                                                                                            <%}%>
                                                                                                            </table>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <%}%>
                                                                                                    
                                                                                                    <tr>
                                                                                                        <td colspan="4">&nbsp;</td>
                                                                                                    </tr> 
                                                                                                    <tr>
                                                                                                        <td colspan="4">
                                                                                                            <table width="550" border="0" cellspacing="1" cellpadding="1">
                                                                                                                <tr> 
                                                                                                                    <td colspan="5" height="20"><b><%=langApp[0].toUpperCase()%></b> </td>
                                                                                                                </tr>
                                                                                                                <tr> 
                                                                                                                    <td width="12%" height="20" bgcolor="#F3F3F3" align="center"><b><font size="1"><%=langApp[1]%> </font></b></td>
                                                                                                                    <td width="25%" height="20" bgcolor="#F3F3F3" align="center"><b><font size="1"><%=langApp[3]%></font></b></td>
                                                                                                                    <td width="28%" height="20" bgcolor="#F3F3F3" nowrap align="center"><b><font size="1"><%=langApp[4]%></font></b></td>
                                                                                                                    <td height="20" bgcolor="#F3F3F3" align="center"><b><font size="1"><%=langApp[5]%></font></b></td>                                                                                                                                                                                                                                        
                                                                                                                </tr>
                                                                                                                <tr><td colspan="4" height="1" bgcolor="#CCCCCC"></td></tr>
                                                                                                                <%
                                                                                            String createName = "";
                                                                                            String createDate = "";

                                                                                            try {
                                                                                                if (module.getCreateDate() != null) {
                                                                                                    createDate = JSPFormater.formatDate(module.getCreateDate(), "dd MMM yyyy hh:mm:ss");
                                                                                                }
                                                                                            } catch (Exception e) {
                                                                                            }

                                                                                            try {
                                                                                                Employee employee = new Employee();
                                                                                                if (module.getCreateId() != 0) {
                                                                                                    employee = DbEmployee.fetchExc(module.getCreateId());
                                                                                                }
                                                                                                createName = employee.getName();
                                                                                            } catch (Exception e) {
                                                                                            }

                                                                                            String approvalName = "";
                                                                                            String approvalDate = "";

                                                                                            try {
                                                                                                if (module.getCreateDate() != null) {
                                                                                                    approvalDate = JSPFormater.formatDate(module.getApproval1Date(), "dd MMM yyyy hh:mm:ss");
                                                                                                }
                                                                                            } catch (Exception e) {
                                                                                            }

                                                                                            try {
                                                                                                Employee employee = new Employee();
                                                                                                if (module.getApproval1Id() != 0) {
                                                                                                    employee = DbEmployee.fetchExc(module.getApproval1Id());
                                                                                                }
                                                                                                approvalName = employee.getName();
                                                                                            } catch (Exception e) {
                                                                                            }

                                                                                            int i = 0;

                                                                                            i = i + 1;
                                                                                                                %>
                                                                                                                <tr> 
                                                                                                                    <td align="center"><%=i%></td>
                                                                                                                    <td ><%=createName%></td>
                                                                                                                    <td align="center"><%=createDate%></td>
                                                                                                                    <td align="center">Create By.</td>                                                                                                                                                                                                                                        
                                                                                                                </tr>
                                                                                                                
                                                                                                                <%if (module.getApproval1Id() != 0) {
                                                                                                i = i + 1;
                                                                                                                %>
                                                                                                                <tr> 
                                                                                                                    <td align="center"><%=i%></td>
                                                                                                                    <td ><%=approvalName%></td>
                                                                                                                    <td align="center"><%=approvalDate%></td>
                                                                                                                    <td align="center">Approved</td>                                                                                                                                                                                                                                        
                                                                                                                </tr>
                                                                                                                <%}%>
                                                                                                            </table>     
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    
                                                                                                    
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <%}%>
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                            <script language="JavaScript">
                                                                <%if (module.getCode() == null || module.getCode().length() == 0) {%>
                                                                cmdGetCode();
                                                                <%}%>
                                                            </script>
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
