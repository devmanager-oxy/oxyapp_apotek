
<%@ page language="java"%>
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
<% int appObjCode = 1; %>
<%@ include file = "../main/check.jsp" %>
<%
            boolean priv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MN_GL, AppMenu.M2_MN_GL);
            boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_GL, AppMenu.M2_MN_GL, AppMenu.PRIV_VIEW);
            boolean privUpdate = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_GL, AppMenu.M2_MN_GL, AppMenu.PRIV_UPDATE);
            boolean privAdd = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_GL, AppMenu.M2_MN_GL, AppMenu.PRIV_ADD);
            boolean privDelete = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_GL, AppMenu.M2_MN_GL, AppMenu.PRIV_DELETE);
%>
<!-- Jsp Block -->
<%!
    public String drawList(int iJSPCommand, JspAkrualSetup frmObject, AkrualSetup objEntity, Vector objectClass, long akrualSetupId, boolean isPostableOnly) {
        JSPList ctrlist = new JSPList();
        ctrlist.setAreaWidth("100%");
        ctrlist.setListStyle("listgen");
        ctrlist.setTitleStyle("tablehdr");
        ctrlist.setCellStyle("tablecell");
        ctrlist.setHeaderStyle("tablehdr");
        ctrlist.addHeader("Reg. Date", "10%");
        ctrlist.addHeader("Nama", "12%");
        ctrlist.addHeader("Anggaran", "6%");
        ctrlist.addHeader("Periode", "5%");
        ctrlist.addHeader("Debet Akun", "14%");
        ctrlist.addHeader("Kredit Akun", "14%");
        ctrlist.addHeader("Update Terakhir", "9%");
        ctrlist.addHeader("Oleh", "10%");
        ctrlist.addHeader("Aktif", "5%");

        ctrlist.setLinkRow(0);
        ctrlist.setLinkSufix("");
        Vector lstData = ctrlist.getData();
        Vector lstLinkData = ctrlist.getLinkData();
        Vector rowx = new Vector(1, 1);
        ctrlist.reset();
        int index = -1;
        String whereCls = "";
        String orderCls = "";

        String wherex = "";
        if (isPostableOnly) {
            wherex = "status='" + I_Project.ACCOUNT_LEVEL_POSTABLE + "'";
        }

        Vector coas = DbCoa.list(0, 0, wherex, "code");

        /* selected CreditCoaId*/

        Vector creditcoaid_value = new Vector(1, 1);
        Vector creditcoaid_key = new Vector(1, 1);
        if (coas != null && coas.size() > 0) {
            for (int x = 0; x < coas.size(); x++) {
                Coa coa = (Coa) coas.get(x);
                String str = "";
                if (!isPostableOnly) {
                    switch (coa.getLevel()) {
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
                creditcoaid_value.add("" + coa.getOID());
                creditcoaid_key.add(str + coa.getCode() + "-" + coa.getName());
            }
        }

        /* selected DebetCoaId*/
        Vector debetcoaid_value = new Vector(1, 1);
        Vector debetcoaid_key = new Vector(1, 1);

        if (coas != null && coas.size() > 0) {
            for (int x = 0; x < coas.size(); x++) {
                Coa coa = (Coa) coas.get(x);
                String str = "";
                if (!isPostableOnly) {
                    switch (coa.getLevel()) {
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
                debetcoaid_value.add("" + coa.getOID());
                debetcoaid_key.add(str + coa.getCode() + "-" + coa.getName());
            }
        }

        for (int i = 0; i < objectClass.size(); i++) {
            AkrualSetup akrualSetup = (AkrualSetup) objectClass.get(i);
            rowx = new Vector();
            if (akrualSetupId == akrualSetup.getOID()) {
                index = i;
            }

            if (index == i && (iJSPCommand == JSPCommand.EDIT || iJSPCommand == JSPCommand.ASK)) {
                String str_dt_RegDate = "";
                try {
                    Date dt_RegDate = akrualSetup.getRegDate();
                    if (dt_RegDate == null) {
                        dt_RegDate = new Date();
                    }
                    str_dt_RegDate = JSPFormater.formatDate(dt_RegDate, "dd MMMM yyyy");
                } catch (Exception e) {
                    str_dt_RegDate = "";
                }
                rowx.add(str_dt_RegDate);
                rowx.add("<input type=\"text\" name=\"" + frmObject.colNames[JspAkrualSetup.JSP_FIELD_NAMA] + "\" value=\"" + akrualSetup.getNama() + "\" class=\"formElemen\" size=\"25\">");
                rowx.add("<input type=\"text\" name=\"" + frmObject.colNames[JspAkrualSetup.JSP_FIELD_ANGGARAN] + "\" value=\"" + akrualSetup.getAnggaran() + "\" class=\"formElemen\" size=\"15\">");
                rowx.add("<input type=\"text\" name=\"" + frmObject.colNames[JspAkrualSetup.JSP_FIELD_PEMBAGI] + "\" value=\"" + akrualSetup.getPembagi() + "\" class=\"formElemen\" size=\"5\">");
                rowx.add(JSPCombo.draw(frmObject.colNames[JspAkrualSetup.JSP_FIELD_DEBET_COA_ID], null, "" + akrualSetup.getDebetCoaId(), debetcoaid_value, debetcoaid_key, "formElemen", ""));
                rowx.add(JSPCombo.draw(frmObject.colNames[JspAkrualSetup.JSP_FIELD_CREDIT_COA_ID], null, "" + akrualSetup.getCreditCoaId(), creditcoaid_value, creditcoaid_key, "formElemen", ""));

                String str_dt_LastUpdate = "";
                try {
                    Date dt_LastUpdate = akrualSetup.getLastUpdate();
                    if (dt_LastUpdate == null) {
                        dt_LastUpdate = new Date();
                    }

                    str_dt_LastUpdate = JSPFormater.formatDate(dt_LastUpdate, "dd MMMM yyyy");
                } catch (Exception e) {
                    str_dt_LastUpdate = "";
                }
                rowx.add(str_dt_LastUpdate);

                User u = new User();
                try {
                    u = DbUser.fetch(akrualSetup.getUserId());
                } catch (Exception e) {
                }
                rowx.add(u.getLoginId());
                rowx.add("<input type=\"checkbox\" name=\"" + frmObject.colNames[JspAkrualSetup.JSP_FIELD_STATUS] + "\" value=\"1\" class=\"formElemen\" " + ((akrualSetup.getStatus() == 1) ? "checked" : "") + ">");

            } else {
                String str_dt_RegDate = "";
                try {
                    Date dt_RegDate = akrualSetup.getRegDate();
                    if (dt_RegDate == null) {
                        dt_RegDate = new Date();
                    }

                    str_dt_RegDate = JSPFormater.formatDate(dt_RegDate, "dd MMMM yyyy");
                } catch (Exception e) {
                    str_dt_RegDate = "";
                }
                rowx.add("<a href=\"javascript:cmdEdit('" + String.valueOf(akrualSetup.getOID()) + "')\">" + str_dt_RegDate + "</a>");

                rowx.add(akrualSetup.getNama());
                rowx.add(JSPFormater.formatNumber(akrualSetup.getAnggaran(), "#,###.##"));
                rowx.add("<div align=\"center\">" + String.valueOf(akrualSetup.getPembagi()) + "</div>");

                Coa c = new Coa();
                try {
                    c = DbCoa.fetchExc(akrualSetup.getDebetCoaId());
                } catch (Exception e) {
                }
                rowx.add(c.getCode() + "-" + c.getName());

                try {
                    c = DbCoa.fetchExc(akrualSetup.getCreditCoaId());
                } catch (Exception e) {
                }
                rowx.add(c.getCode() + "-" + c.getName());

                String str_dt_LastUpdate = "";
                try {
                    Date dt_LastUpdate = akrualSetup.getLastUpdate();
                    if (dt_LastUpdate == null) {
                        dt_LastUpdate = new Date();
                    }

                    str_dt_LastUpdate = JSPFormater.formatDate(dt_LastUpdate, "dd MMMM yyyy");
                } catch (Exception e) {
                    str_dt_LastUpdate = "";
                }
                rowx.add(str_dt_LastUpdate);

                User u = new User();
                try {
                    u = DbUser.fetch(akrualSetup.getUserId());
                } catch (Exception e) {
                }
                rowx.add(u.getLoginId());
                rowx.add((akrualSetup.getStatus() == 1) ? "Aktif" : "-");
            }

            lstData.add(rowx);
        }

        rowx = new Vector();

        if (iJSPCommand == JSPCommand.ADD || (iJSPCommand == JSPCommand.SAVE && frmObject.errorSize() > 0)) {
            rowx.add("");//<input type=\"text\" name=\""+frmObject.colNames[JspAkrualSetup.JSP_FIELD_REG_DATE] +"\" value=\""+objEntity.getRegDate()+"\" class=\"formElemen\">");
            rowx.add("<input type=\"text\" name=\"" + frmObject.colNames[JspAkrualSetup.JSP_FIELD_NAMA] + "\" value=\"" + objEntity.getNama() + "\" class=\"formElemen\" size=\"25\">");
            rowx.add("<input type=\"text\" name=\"" + frmObject.colNames[JspAkrualSetup.JSP_FIELD_ANGGARAN] + "\" value=\"" + objEntity.getAnggaran() + "\" class=\"formElemen\" size=\"15\">");
            rowx.add("<input type=\"text\" name=\"" + frmObject.colNames[JspAkrualSetup.JSP_FIELD_PEMBAGI] + "\" value=\"" + objEntity.getPembagi() + "\" class=\"formElemen\" size=\"5\">");
            rowx.add(JSPCombo.draw(frmObject.colNames[JspAkrualSetup.JSP_FIELD_DEBET_COA_ID], null, "" + objEntity.getDebetCoaId(), debetcoaid_value, debetcoaid_key, "formElemen", ""));
            rowx.add(JSPCombo.draw(frmObject.colNames[JspAkrualSetup.JSP_FIELD_CREDIT_COA_ID], null, "" + objEntity.getCreditCoaId(), creditcoaid_value, creditcoaid_key, "formElemen", ""));
            rowx.add("");//<input type=\"text\" name=\""+frmObject.colNames[JspAkrualSetup.JSP_FIELD_LAST_UPDATE] +"\" value=\""+objEntity.getLastUpdate()+"\" class=\"formElemen\">");
            rowx.add("");//<input type=\"text\" name=\""+frmObject.colNames[JspAkrualSetup.JSP_FIELD_USER_ID] +"\" value=\""+objEntity.getUserId()+"\" class=\"formElemen\">");
            rowx.add("<input type=\"checkbox\" name=\"" + frmObject.colNames[JspAkrualSetup.JSP_FIELD_STATUS] + "\" value=\"1\" class=\"formElemen\" " + ((objEntity.getStatus() == 1) ? "checked" : "") + ">");

        }

        lstData.add(rowx);

        return ctrlist.draw(index);
    }

%>

<%

            int iJSPCommand = JSPRequestValue.requestCommand(request);
            int start = JSPRequestValue.requestInt(request, "start");
            int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
            long oidAkrualSetup = JSPRequestValue.requestLong(request, "hidden_akrual_setup_id");

            /*variable declaration*/
            int recordToGet = 1000;
            String msgString = "";
            int iErrCode = JSPMessage.NONE;
            String whereClause = "status=1";
            String orderClause = "";

            CmdAkrualSetup ctrlAkrualSetup = new CmdAkrualSetup(request);
            JSPLine ctrLine = new JSPLine();
            Vector listAkrualSetup = new Vector(1, 1);

/*switch statement */
//iErrCode = ctrlAkrualSetup.action(iJSPCommand , oidAkrualSetup);
/* end switch*/
            JspAkrualSetup jspAkrualSetup = ctrlAkrualSetup.getForm();

            /*count list All AkrualSetup*/
            int vectSize = DbAkrualSetup.getCount(whereClause);

            /*switch list AkrualSetup*/
            if ((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV) ||
                    (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)) {
                start = ctrlAkrualSetup.actionList(iJSPCommand, start, vectSize, recordToGet);
            }
            /* end switch list*/

            AkrualSetup akrualSet = ctrlAkrualSetup.getAkrualSetup();
            msgString = ctrlAkrualSetup.getMessage();

            /* get record to display */
            listAkrualSetup = DbAkrualSetup.list(start, recordToGet, whereClause, orderClause);

            if (listAkrualSetup != null && listAkrualSetup.size() > 0 && iJSPCommand == JSPCommand.SUBMIT) {

                Periode periode123 = DbPeriode.getOpenPeriod();

                for (int i = 0; i < listAkrualSetup.size(); i++) {
                    
                    AkrualSetup as = (AkrualSetup) listAkrualSetup.get(i);
                    
                    int chk = JSPRequestValue.requestInt(request, "chk_" + as.getOID());
                    double amn = JSPRequestValue.requestDouble(request, "amount_" + as.getOID());

                    Vector v = DbAkrualProses.list(0, 0, "periode_id=" + periode123.getOID() + " and akrual_setup_id=" + as.getOID(), "");
                    if (v != null && v.size() > 0) {
                    /*AkrualProses ap = (AkrualProses)v.get(0);
                    try{
                    ap = DbAkrualProses.fetchExc(ap.getOID());
                    ap.setPeriodeId(periode123.getOID());
                    ap.setRegDate(new Date());
                    ap.setJumlah(amn);
                    ap.setAkrualSetupId(as.getOID());
                    ap.setUserId(user.getOID());
                    ap.setDebetCoaId(as.getDebetCoaId());
                    ap.setCreditCoaId(as.getCreditCoaId());
                    DbAkrualProses.updateExc(ap);
                    }
                    catch(Exception e){
                    }
                     */

                    } else {
                        try {
                            AkrualProses ap = new AkrualProses();
                            ap.setPeriodeId(periode123.getOID());
                            ap.setRegDate(new Date());
                            ap.setJumlah(amn);
                            ap.setAkrualSetupId(as.getOID());
                            ap.setUserId(user.getOID());
                            ap.setDebetCoaId(as.getDebetCoaId());
                            ap.setCreditCoaId(as.getCreditCoaId());

                            long oid = DbAkrualProses.insertExc(ap);

                            if (oid != 0) {
                                DbAkrualProses.postJournal(ap);
                            }

                        } catch (Exception e) {
                        }

                    }

                }
            }

            /*** LANG ***/
            String[] langAT = {"Date", "Period", //0-1
                "Name", "Budget", "Period", "Accrual Amount", "Debet Account", "Credit Account", "Accrual Status", "Process", //2-9
                "Accrual Process Finished", "Go to Archives"}; //10-11

            String[] langNav = {"Recurring Journal", "Process"};

            if (lang == LANG_ID) {
                String[] langID = {"Tanggal", "Periode",
                    "Nama", "Anggaran", "Periode", "Jumlah Akrual", "Perkiraan Debet", "Perkiraan Credit", "Status Akrual", "Proses",
                    "Proses Akrual Selesai", "Lihat Arsip"
                };
                langAT = langID;

                String[] navID = {"Jurnal Berulang", "Proses"};
                langNav = navID;
            }

%>
<html >
    <!-- #BeginTemplate "/Templates/index.dwt" --> 
    <head>
        <!-- #BeginEditable "javascript" --> 
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <title><%=systemTitle%></title>
        <link href="../css/css.css" rel="stylesheet" type="text/css" />
        <script language="JavaScript">            
            <%if(!priv || !privView) {%>
                window.location="<%=approot%>/nopriv.jsp";
            <%}%>
            
            function cmdSubmit(){
                document.frmakrualsetup.command.value="<%=JSPCommand.SUBMIT%>";
                document.frmakrualsetup.prev_command.value="<%=prevJSPCommand%>";
                document.frmakrualsetup.action="akrualproses.jsp";
                document.frmakrualsetup.submit();
            }
            
            function cmdAdd(){
                document.frmakrualsetup.hidden_akrual_setup_id.value="0";
                document.frmakrualsetup.command.value="<%=JSPCommand.ADD%>";
                document.frmakrualsetup.prev_command.value="<%=prevJSPCommand%>";
                document.frmakrualsetup.action="akrualproses.jsp";
                document.frmakrualsetup.submit();
            }
            
            function cmdAsk(oidAkrualSetup){
                document.frmakrualsetup.hidden_akrual_setup_id.value=oidAkrualSetup;
                document.frmakrualsetup.command.value="<%=JSPCommand.ASK%>";
                document.frmakrualsetup.prev_command.value="<%=prevJSPCommand%>";
                document.frmakrualsetup.action="akrualproses.jsp";
                document.frmakrualsetup.submit();
            }
            
            function cmdConfirmDelete(oidAkrualSetup){
                document.frmakrualsetup.hidden_akrual_setup_id.value=oidAkrualSetup;
                document.frmakrualsetup.command.value="<%=JSPCommand.DELETE%>";
                document.frmakrualsetup.prev_command.value="<%=prevJSPCommand%>";
                document.frmakrualsetup.action="akrualproses.jsp";
                document.frmakrualsetup.submit();
            }
            
            function cmdSave(){
                document.frmakrualsetup.command.value="<%=JSPCommand.SAVE%>";
                document.frmakrualsetup.prev_command.value="<%=prevJSPCommand%>";
                document.frmakrualsetup.action="akrualproses.jsp";
                document.frmakrualsetup.submit();
            }
            
            function cmdEdit(oidAkrualSetup){
                document.frmakrualsetup.hidden_akrual_setup_id.value=oidAkrualSetup;
                document.frmakrualsetup.command.value="<%=JSPCommand.EDIT%>";
                document.frmakrualsetup.prev_command.value="<%=prevJSPCommand%>";
                document.frmakrualsetup.action="akrualproses.jsp";
                document.frmakrualsetup.submit();
            }
            
            function cmdCancel(oidAkrualSetup){
                document.frmakrualsetup.hidden_akrual_setup_id.value=oidAkrualSetup;
                document.frmakrualsetup.command.value="<%=JSPCommand.EDIT%>";
                document.frmakrualsetup.prev_command.value="<%=prevJSPCommand%>";
                document.frmakrualsetup.action="akrualproses.jsp";
                document.frmakrualsetup.submit();
            }
            
            function cmdBack(){
                document.frmakrualsetup.command.value="<%=JSPCommand.BACK%>";
                document.frmakrualsetup.action="akrualproses.jsp";
                document.frmakrualsetup.submit();
            }
            
            function cmdListFirst(){
                document.frmakrualsetup.command.value="<%=JSPCommand.FIRST%>";
                document.frmakrualsetup.prev_command.value="<%=JSPCommand.FIRST%>";
                document.frmakrualsetup.action="akrualproses.jsp";
                document.frmakrualsetup.submit();
            }
            
            function cmdListPrev(){
                document.frmakrualsetup.command.value="<%=JSPCommand.PREV%>";
                document.frmakrualsetup.prev_command.value="<%=JSPCommand.PREV%>";
                document.frmakrualsetup.action="akrualproses.jsp";
                document.frmakrualsetup.submit();
            }
            
            function cmdListNext(){
                document.frmakrualsetup.command.value="<%=JSPCommand.NEXT%>";
                document.frmakrualsetup.prev_command.value="<%=JSPCommand.NEXT%>";
                document.frmakrualsetup.action="akrualproses.jsp";
                document.frmakrualsetup.submit();
            }
            
            function cmdListLast(){
                document.frmakrualsetup.command.value="<%=JSPCommand.LAST%>";
                document.frmakrualsetup.prev_command.value="<%=JSPCommand.LAST%>";
                document.frmakrualsetup.action="akrualproses.jsp";
                document.frmakrualsetup.submit();
            }
            
            //-------------- script form image -------------------            
            function cmdDelPict(oidAkrualSetup){
                document.frmimage.hidden_akrual_setup_id.value=oidAkrualSetup;
                document.frmimage.command.value="<%=JSPCommand.POST%>";
                document.frmimage.action="akrualproses.jsp";
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
                                                    <td class="title"><!-- #BeginEditable "title" --><%
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
                                                        <form name="frmakrualsetup" method ="post" action="">
                                                            <input type="hidden" name="command" value="<%=iJSPCommand%>">
                                                            <input type="hidden" name="vectSize" value="<%=vectSize%>">
                                                            <input type="hidden" name="start" value="<%=start%>">
                                                            <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                                                            <input type="hidden" name="hidden_akrual_setup_id" value="<%=oidAkrualSetup%>">
                                                            <input type="hidden" name="<%=JspAkrualProses.colNames[JspAkrualProses.JSP_FIELD_USER_ID]%>" value="<%=user.getOID()%>">
                                                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                            <input type="hidden" name="<%=JspAkrualProses.colNames[JspAkrualProses.JSP_FIELD_PERIODE_ID]%>" value="<%=periodeXXX.getOID()%>">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr align="left" valign="top"> 
                                                                    <td height="8"  colspan="3" class="container"> 
                                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                            <tr>
                                                                                <td>
                                                                                    <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                                        <tr>
                                                                                            <td width="6%">&nbsp;</td>
                                                                                            <td width="94%">&nbsp;</td>
                                                                                        </tr>
                                                                                        <tr> 
                                                                                            <td width="6%"><%=langAT[0]%></td>
                                                                                            <td width="94%">: <%=JSPFormater.formatDate(new Date(), "dd MMMM yyyy")%></td>
                                                                                        </tr>
                                                                                        <tr> 
                                                                                            <td width="6%"><%=langAT[1]%></td>
                                                                                            <td width="94%">: <%=openPeriodXXX%></td>
                                                                                        </tr>
                                                                                        <tr> 
                                                                                            <td width="6%">&nbsp;</td>
                                                                                            <td width="94%">&nbsp;</td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                            <%if (iJSPCommand != JSPCommand.SUBMIT) {%>
                                                                            <tr>
                                                                                <td>
                                                                                    <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                                        <tr> 
                                                                                            <td width="2%" class="tablehdr">No</td>
                                                                                            <td width="14%" class="tablehdr"><%=langAT[2]%></td>
                                                                                            <td width="9%" class="tablehdr"><%=langAT[3]%></td>
                                                                                            <td width="8%" class="tablehdr"><%=langAT[4]%></td>
                                                                                            <td width="15%" class="tablehdr"><%=langAT[5]%></td>
                                                                                            <td width="17%" class="tablehdr"><%=langAT[6]%></td>
                                                                                            <td width="18%" class="tablehdr"><%=langAT[7]%></td>
                                                                                            <td width="8%" class="tablehdr"><%=langAT[8]%></td>
                                                                                            <td width="9%" class="tablehdr"><%=langAT[9]%></td>
                                                                                        </tr>
                                                                                        <%if (listAkrualSetup != null && listAkrualSetup.size() > 0) {
        for (int i = 0; i < listAkrualSetup.size(); i++) {
            AkrualSetup as = (AkrualSetup) listAkrualSetup.get(i);

            Coa c = new Coa();
            try {
                c = DbCoa.fetchExc(as.getDebetCoaId());
            } catch (Exception e) {
            }
            Coa c1 = new Coa();
            try {
                c1 = DbCoa.fetchExc(as.getCreditCoaId());
            } catch (Exception e) {
            }

            int cnt = DbAkrualProses.getCount("periode_id=" + periodeXXX.getOID() + " and akrual_setup_id=" + as.getOID());

            if (i % 2 == 0) {
                                                                                        %>
                                                                                        <tr> 
                                                                                            <td width="2%" class="tablecell1"><%=i + 1%></td>
                                                                                            <td width="14%" class="tablecell1"><%=as.getNama()%></td>
                                                                                            <td width="9%" class="tablecell1"> 
                                                                                                <div align="right"><%=JSPFormater.formatNumber(as.getAnggaran(), "#,###.##")%></div>
                                                                                            </td>
                                                                                            <td width="8%" class="tablecell1"> 
                                                                                                <div align="center"><%=as.getPembagi()%></div>
                                                                                            </td>
                                                                                            <td width="15%" class="tablecell1"> 
                                                                                                <div align="center"> 
                                                                                                    <input type="text" name="amount_<%=as.getOID()%>" value="<%=JSPFormater.formatNumber((as.getAnggaran() / as.getPembagi()), "#,###.##")%>">
                                                                                                </div>
                                                                                            </td>
                                                                                            <td width="17%" class="tablecell1"><%=c.getCode() + "-" + c.getName()%></td>
                                                                                            <td width="18%" class="tablecell1"><%=c1.getCode() + "-" + c1.getName()%></td>
                                                                                            <td width="8%" class="tablecell1"> 
                                                                                                <div align="center"><%=(cnt > 0) ? "Sudah" : "-"%></div>
                                                                                            </td>
                                                                                            <td width="9%" class="tablecell1"> 
                                                                                                <div align="center"> 
                                                                                                    <%if (cnt == 0) {%>
                                                                                                    <input type="checkbox" name="chk_<%=as.getOID()%>" value="checkbox" checked>
                                                                                                    <%} else {%>
                                                                                                    - 
                                                                                                    <%}%>
                                                                                                </div>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <%} else {%>
                                                                                        <tr> 
                                                                                            <td width="2%" class="tablecell"><%=i + 1%></td>
                                                                                            <td width="14%" class="tablecell"><%=as.getNama()%></td>
                                                                                            <td width="9%" class="tablecell"> 
                                                                                                <div align="right"><%=JSPFormater.formatNumber(as.getAnggaran(), "#,###.##")%></div>
                                                                                            </td>
                                                                                            <td width="8%" class="tablecell"> 
                                                                                                <div align="center"><%=as.getPembagi()%></div>
                                                                                            </td>
                                                                                            <td width="15%" class="tablecell"> 
                                                                                                <div align="center"> 
                                                                                                    <input type="text" name="amount_<%=as.getOID()%>" value="<%=JSPFormater.formatNumber((as.getAnggaran() / as.getPembagi()), "#,###.##")%>">
                                                                                                </div>
                                                                                            </td>
                                                                                            <td width="17%" class="tablecell"><%=c.getCode() + "-" + c.getName()%></td>
                                                                                            <td width="18%" class="tablecell"><%=c1.getCode() + "-" + c1.getName()%></td>
                                                                                            <td width="8%" class="tablecell"> 
                                                                                                <div align="center"><%=(cnt > 0) ? "Sudah" : "-"%></div>
                                                                                            </td>
                                                                                            <td width="9%" class="tablecell"> 
                                                                                                <div align="center"> 
                                                                                                    <%if (cnt == 0) {%>
                                                                                                    <input type="checkbox" name="chk_<%=as.getOID()%>" value="checkbox" checked>
                                                                                                    <%} else {%>
                                                                                                    - 
                                                                                                    <%}%>
                                                                                                </div>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <%}
        }
    }%>
                                                                                        <tr> 
                                                                                            <td width="2%">&nbsp;</td>
                                                                                            <td width="14%">&nbsp;</td>
                                                                                            <td width="9%">&nbsp;</td>
                                                                                            <td width="8%">&nbsp;</td>
                                                                                            <td width="15%">&nbsp;</td>
                                                                                            <td width="17%">&nbsp;</td>
                                                                                            <td width="18%">&nbsp;</td>
                                                                                            <td width="8%">&nbsp;</td>
                                                                                            <td width="9%">&nbsp;</td>
                                                                                        </tr>
                                                                                        <tr> 
                                                                                            <td colspan="9"> 
                                                                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                                    <tr> 
                                                                                                        <td width="3%">
                                                                                                            <%if(privAdd || privUpdate){%>
                                                                                                            <a href="javascript:cmdSubmit()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new21','','../images/save2.gif',1)"><img src="../images/save.gif" name="new21" width="55" height="22" border="0"></a>
                                                                                                            <%}%>
                                                                                                            </td>
                                                                                                        <td width="97%">&nbsp;</td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                            <%} else {%>
                                                                            <tr>
                                                                                <td>&nbsp;<font color="#0000FF"><%=langAT[10]%></font>, <a href="#"><%=langAT[11]%></a></td>
                                                                            </tr>
                                                                            <%}%>
                                                                        </table>
                                                                        
                                                                    </td>
                                                                </tr>
                                                                <tr align="left" valign="top"> 
                                                                    <td height="8" valign="middle" width="17%">&nbsp;</td>
                                                                    <td height="8" colspan="2" width="83%">&nbsp; </td>
                                                                </tr>
                                                                <tr align="left" valign="top" > 
                                                                    <td colspan="3" class="command">&nbsp; </td>
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
