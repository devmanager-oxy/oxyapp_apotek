
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "com.project.fms.master.*" %>
<%@ page import = "com.project.fms.activity.*" %>
<%@ page import = "com.project.fms.reportform.*" %>
<%@ page import = "com.project.system.*" %>
<%@ include file = "../main/javainit.jsp" %>
<% int appObjCode = 1;%>
<%@ include file = "../main/check.jsp" %>
<%
            boolean priv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MN_FIN_REP, AppMenu.M2_MN_SETUP_REPORT);
            boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_FIN_REP, AppMenu.M2_MN_SETUP_REPORT, AppMenu.PRIV_VIEW);
            boolean privUpdate = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_FIN_REP, AppMenu.M2_MN_SETUP_REPORT, AppMenu.PRIV_UPDATE);
            boolean privAdd = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_FIN_REP, AppMenu.M2_MN_SETUP_REPORT, AppMenu.PRIV_ADD);
            boolean privDelete = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_FIN_REP, AppMenu.M2_MN_SETUP_REPORT, AppMenu.PRIV_DELETE);
%>
<!-- Jsp Block -->
<%!
    public String drawList(int iJSPCommand, JspRptFormatDetail jspObject, RptFormatDetail objEntity, Vector objectClass, long rptFormatDetailId) {
        JSPList ctrlist = new JSPList();
        ctrlist.setAreaWidth("100%");
        ctrlist.setListStyle("listgen");
        ctrlist.setTitleStyle("tablehdr");
        ctrlist.setCellStyle("tablecell");
        ctrlist.setHeaderStyle("tablehdr");
        ctrlist.addHeader("Uraian", "30%");
        //ctrlist.addHeader("Level","25%");
        ctrlist.addHeader("Urutan", "5%");
        ctrlist.addHeader("Induk", "20%");
        ctrlist.addHeader("Type", "10%");
        ctrlist.addHeader("List Perkiraan", "35%");

        ctrlist.setLinkRow(0);
        ctrlist.setLinkSufix("");
        Vector lstData = ctrlist.getData();
        Vector lstLinkData = ctrlist.getLinkData();
        Vector rowx = new Vector(1, 1);
        ctrlist.reset();
        int index = -1;
        String whereCls = "";
        String orderCls = "";

        /* selected Level*/
        Vector level_value = new Vector(1, 1);
        Vector level_key = new Vector(1, 1);
        level_value.add("");
        level_key.add("---select---");

        /* selected Type*/
        Vector type_value = new Vector(1, 1);
        Vector type_key = new Vector(1, 1);
        type_value.add("");
        type_key.add("---select---");

        for (int i = 0; i < objectClass.size(); i++) {
            RptFormatDetail rptFormatDetail = (RptFormatDetail) objectClass.get(i);

            String level = "";
            if (rptFormatDetail.getLevel() == 1) {
                level = "&nbsp;&nbsp;&nbsp;&nbsp;";
            } else if (rptFormatDetail.getLevel() == 2) {
                level = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
            } else if (rptFormatDetail.getLevel() == 3) {
                level = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
            } else if (rptFormatDetail.getLevel() == 4) {
                level = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
            }

            rowx = new Vector();
            if (rptFormatDetailId == rptFormatDetail.getOID()) {
                index = i;
            }


            rowx.add(level + "<a href=\"javascript:cmdEdit('" + String.valueOf(rptFormatDetail.getOID()) + "')\">" + rptFormatDetail.getDescription() + "</a>");
            //rowx.add(String.valueOf(rptFormatDetail.getLevel()));
            rowx.add("<div align=\"center\">" + String.valueOf(rptFormatDetail.getSquence()) + "</div>");

            RptFormatDetail rfd = new RptFormatDetail();
            try {
                rfd = DbRptFormatDetail.fetchExc(rptFormatDetail.getRefId());
            } catch (Exception e) {
            }

            rowx.add((rfd.getDescription() == null) ? "" : rfd.getDescription());

            String typeStr = "-";
            switch (rptFormatDetail.getType()) {
                case 1:
                    typeStr = "Total";
                    break;
                case 2:
                    typeStr = "Laba Tahun Berjalan";
                    break;
                case 3:
                    typeStr = "Laba Tahun Lalu";
                    break;
                case 4:
                    typeStr = "Modal";
                    break;
            }

            rowx.add("<div align=\"center\">" + typeStr + "</div>");

            Vector temp = DbRptFormatDetailCoa.list(0, 0, DbRptFormatDetailCoa.colNames[DbRptFormatDetailCoa.COL_RPT_FORMAT_DETAIL_ID] + "=" + rptFormatDetail.getOID(), "");
            String strCoa = "";
            int maxLevel = 0;
            String accGroup = "";
            if (temp != null && temp.size() > 0) {
                for (int x = 0; x < temp.size(); x++) {
                    RptFormatDetailCoa cd = (RptFormatDetailCoa) temp.get(x);
                    Department dep = new Department();
                    try {
                        dep = DbDepartment.fetchExc(cd.getDepId());
                    } catch (Exception e) {
						System.out.println("\n\nexception ex : "+e.toString());
                    }
                    try {
                        Coa coa = DbCoa.fetchExc(cd.getCoaId());
                        accGroup = coa.getAccountGroup();
                        strCoa = strCoa + ((cd.getIsMinus() == 0) ? "(+)" : "(-)") + coa.getCode() + " - " + coa.getName() + ((dep.getOID() != 0) ? "<font color=\"blue\">[" + dep.getName() + "]</font>" : "") + ", ";//+ "<br>";
                        if (coa.getLevel() > maxLevel) {
                            maxLevel = coa.getLevel();
                        }
                    } catch (Exception e) {
						System.out.println("\n\nexception ex : "+e.toString());
                    }

                }
                
                if(strCoa!=null && strCoa.length()>0) strCoa = strCoa.substring(0, strCoa.length() - 2);
            }
            //rowx.add("<div align=\"center\">"+((strCoa.length()>0) ? strCoa+"<br>" : "")+"<a href=\"javascript:cmdAddX('"+rptFormatDetail.getOID()+"')\">Edit</a></div>");
            rowx.add(((strCoa.length() > 0) ? strCoa + "&nbsp;" : "") + "<a href=\"javascript:cmdAddX('" + rptFormatDetail.getOID() + "','" + maxLevel + "','" + accGroup + "')\"><font color=\"red\">..Edit</font></a>");

            lstData.add(rowx);
        }



        return ctrlist.draw(index);
    }

%>
<%
            int iJSPCommand = JSPRequestValue.requestCommand(request);
            int start = 0;//JSPRequestValue.requestInt(request, "start");
            int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
            long oidRptFormatDetail = JSPRequestValue.requestLong(request, "hidden_rpt_format_detail_id");

            long oidRptFormat = JSPRequestValue.requestLong(request, "hidden_rpt_format_id");

            RptFormat rformat = new RptFormat();
            try {
                rformat = DbRptFormat.fetchExc(oidRptFormat);
            } catch (Exception e) {
            }

            /*variable declaration*/
            int recordToGet = 0;
            String msgString = "";
            int iErrCode = JSPMessage.NONE;
            String whereClause = DbRptFormatDetail.colNames[DbRptFormatDetail.COL_RPT_FORMAT_ID] + "=" + oidRptFormat;
            String orderClause = DbRptFormatDetail.colNames[DbRptFormatDetail.COL_SQUENCE];

            CmdRptFormatDetail ctrlFormatDetail = new CmdRptFormatDetail(request);
            JSPLine ctrLine = new JSPLine();
            Vector listRptFormatDetail = new Vector(1, 1);

            /*switch statement */
            iErrCode = ctrlFormatDetail.action(iJSPCommand, oidRptFormatDetail);
            /* end switch*/
            JspRptFormatDetail jspRptFormatDetail = ctrlFormatDetail.getForm();

            /*count list All RptFormatDetail*/
            int vectSize = DbRptFormatDetail.getCount(whereClause);
            recordToGet = vectSize;
            /*switch list RptFormatDetail*/
            if ((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV) ||
                    (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)) {
                start = ctrlFormatDetail.actionList(iJSPCommand, start, vectSize, recordToGet);
            }
            /* end switch list*/

            RptFormatDetail rptFormatDetail = ctrlFormatDetail.getRptFormatDetail();
            msgString = ctrlFormatDetail.getMessage();

            /* get record to display */
            listRptFormatDetail = DbRptFormatDetail.list(start, recordToGet, whereClause, orderClause);

            /*handle condition if size of record to display = 0 and start > 0 	after delete*/
            if (listRptFormatDetail.size() < 1 && start > 0) {
                if (vectSize - recordToGet > recordToGet) {
                    start = start - recordToGet;
                } //go to JSPCommand.PREV
                else {
                    start = 0;
                    iJSPCommand = JSPCommand.FIRST;
                    prevJSPCommand = JSPCommand.FIRST; //go to JSPCommand.FIRST
                }
                listRptFormatDetail = DbRptFormatDetail.list(start, recordToGet, whereClause, orderClause);
            }


            /*** LANG ***/
            String[] langMD = {"Report Detail", "Description", "Parent", //0-2
                "Type", "required", "Squence", "Budget Balance", "Account Group", "Is SP", "Level", "Department", "Section"}; //3-11

            String[] langNav = {"Finance Report", "Report Setup", "All"};

            if (lang == LANG_ID) {
                String[] langID = {"Detail Laporan", "Uraian", "Induk Uraian",
                    "Tipe", "harap diisi", "No Urut Tampilan", "Saldo Anggaran", "Kelompok Perkiraan", "SP", "Level", "Departemen", "Bagian"
                };
                langMD = langID;

                String[] navID = {"Laporan Keuangan", "Setup Laporan", "Semua"};
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
            
            <%if (!priv || !privView) {%>
            window.location="<%=approot%>/nopriv.jsp";
            <%}%>
            
            function cmdUpdateLevel(level){
                alert(level);
                document.JSPformatdetail.<%=JspRptFormatDetail.colNames[JspRptFormatDetail.JSP_LEVEL]%>.value=(parseInt(level)+1);
                alert("level : "+document.JSPformatdetail.<%=JspRptFormatDetail.colNames[JspRptFormatDetail.JSP_LEVEL]%>.value);
                } 
                
                function cmdAddX(oidRptFormatDetail,level,accGrp){	
                    <%if(privAdd || privUpdate){%>                    
                    document.JSPformatdetail.acc_group.value=accGrp;
                    document.JSPformatdetail.hidden_rpt_format_detail_id.value=oidRptFormatDetail;
                    document.JSPformatdetail.select_until.value=level;
                    document.JSPformatdetail.command.value="<%=JSPCommand.ADD%>";
                    document.JSPformatdetail.prev_command.value="<%=prevJSPCommand%>";
                    document.JSPformatdetail.action="rptformatdetailcoa.jsp";
                    document.JSPformatdetail.submit();
                    <%}%>
                }
                
                function cmdEditX(oidRptFormatDetail, oidRptFormatDetailCoa){
                    document.JSPformatdetail.hidden_rpt_format_detail_id.value=oidRptFormatDetail;
                    document.JSPformatdetail.hidden_rpt_format_detail_coa_id.value=oidRptFormatDetailCoa;
                    document.JSPformatdetail.command.value="<%=JSPCommand.EDIT%>";
                    document.JSPformatdetail.prev_command.value="<%=prevJSPCommand%>";
                    document.JSPformatdetail.action="rptformatdetailcoa.jsp";
                    document.JSPformatdetail.submit();
                } 
                
                function cmdAdd(){
                    document.JSPformatdetail.hidden_rpt_format_detail_id.value="0";
                    document.JSPformatdetail.command.value="<%=JSPCommand.ADD%>";
                    document.JSPformatdetail.prev_command.value="<%=prevJSPCommand%>";
                    document.JSPformatdetail.action="rptformatdetail.jsp";
                    document.JSPformatdetail.submit();
                }
                
                function cmdAsk(oidRptFormatDetail){
                    document.JSPformatdetail.hidden_rpt_format_detail_id.value=oidRptFormatDetail;
                    document.JSPformatdetail.command.value="<%=JSPCommand.ASK%>";
                    document.JSPformatdetail.prev_command.value="<%=prevJSPCommand%>";
                    document.JSPformatdetail.action="rptformatdetail.jsp";
                    document.JSPformatdetail.submit();
                }
                
                function cmdConfirmDelete(oidRptFormatDetail){
                    document.JSPformatdetail.hidden_rpt_format_detail_id.value=oidRptFormatDetail;
                    document.JSPformatdetail.command.value="<%=JSPCommand.DELETE%>";
                    document.JSPformatdetail.prev_command.value="<%=prevJSPCommand%>";
                    document.JSPformatdetail.action="rptformatdetail.jsp";
                    document.JSPformatdetail.submit();
                }
                
                function cmdSave(){
                    document.JSPformatdetail.command.value="<%=JSPCommand.SAVE%>";
                    document.JSPformatdetail.prev_command.value="<%=prevJSPCommand%>";
                    document.JSPformatdetail.action="rptformatdetail.jsp";
                    document.JSPformatdetail.submit();
                }
                
                function cmdEdit(oidRptFormatDetail){
                    <%if(privUpdate){%>
                    document.JSPformatdetail.hidden_rpt_format_detail_id.value=oidRptFormatDetail;
                    document.JSPformatdetail.command.value="<%=JSPCommand.EDIT%>";
                    document.JSPformatdetail.prev_command.value="<%=prevJSPCommand%>";
                    document.JSPformatdetail.action="rptformatdetail.jsp";
                    document.JSPformatdetail.submit();
                    <%}%>
                }
                
                function cmdCancel(){
                    document.JSPformatdetail.command.value="<%=JSPCommand.LIST%>";
                    document.JSPformatdetail.prev_command.value="<%=prevJSPCommand%>";
                    document.JSPformatdetail.action="rptformat.jsp";
                    document.JSPformatdetail.submit();
                }
                
                function cmdBack(){
                    document.JSPformatdetail.command.value="<%=JSPCommand.BACK%>";
                    document.JSPformatdetail.action="rptformatdetail.jsp";
                    document.JSPformatdetail.submit();
                }
                
                function cmdListFirst(){
                    document.JSPformatdetail.command.value="<%=JSPCommand.FIRST%>";
                    document.JSPformatdetail.prev_command.value="<%=JSPCommand.FIRST%>";
                    document.JSPformatdetail.action="rptformatdetail.jsp";
                    document.JSPformatdetail.submit();
                }
                
                function cmdListPrev(){
                    document.JSPformatdetail.command.value="<%=JSPCommand.PREV%>";
                    document.JSPformatdetail.prev_command.value="<%=JSPCommand.PREV%>";
                    document.JSPformatdetail.action="rptformatdetail.jsp";
                    document.JSPformatdetail.submit();
                }
                
                function cmdListNext(){
                    document.JSPformatdetail.command.value="<%=JSPCommand.NEXT%>";
                    document.JSPformatdetail.prev_command.value="<%=JSPCommand.NEXT%>";
                    document.JSPformatdetail.action="rptformatdetail.jsp";
                    document.JSPformatdetail.submit();
                }
                
                function cmdListLast(){
                    document.JSPformatdetail.command.value="<%=JSPCommand.LAST%>";
                    document.JSPformatdetail.prev_command.value="<%=JSPCommand.LAST%>";
                    document.JSPformatdetail.action="rptformatdetail.jsp";
                    document.JSPformatdetail.submit();
                }
                
                //-------------- script form image -------------------
                
                function cmdDelPict(oidRptFormatDetail){
                    document.JSPimage.hidden_rpt_format_detail_id.value=oidRptFormatDetail;
                    document.JSPimage.command.value="<%=JSPCommand.POST%>";
                    document.JSPimage.action="rptformatdetail.jsp";
                    document.JSPimage.submit();
                }
                
                //-------------- script JSP line -------------------
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
    <body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','../images/new2.gif')">
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
                                                    <%@ include file="../main/navigator.jsp"%><!-- #EndEditable --></td>
                                                </tr>
                                                <!--tr> 
                      <td><img src="<%=approot%>/images/title-sp.gif" width="584" height="1"></td> 
                                                </tr-->
                                                <tr> 
                                                    <td><!-- #BeginEditable "content" --> 
                                                        <form name="JSPformatdetail" method ="post" action="">
                                                            <input type="hidden" name="command" value="<%=iJSPCommand%>">
                                                            <input type="hidden" name="vectSize" value="<%=vectSize%>">
                                                            <input type="hidden" name="start" value="<%=start%>">
                                                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                            <input type="hidden" name="select_until" value="">
                                                            <input type="hidden" name="acc_group" value="">						  
                                                            <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                                                            <input type="hidden" name="hidden_rpt_format_detail_id" value="<%=oidRptFormatDetail%>">
                                                            <input type="hidden" name="hidden_rpt_format_id" value="<%=oidRptFormat%>">
                                                            <input type="hidden" name="<%=JspRptFormatDetail.colNames[JspRptFormatDetail.JSP_RPT_FORMAT_ID]%>" value="<%=oidRptFormat%>">
                                                            <input type="hidden" name="<%=JspRptFormatDetail.colNames[JspRptFormatDetail.JSP_LEVEL]%>" value="<%=rptFormatDetail.getLevel()%>">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr>
                                                                    <td class="container">
                                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="8"> 
                                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="8" valign="middle" colspan="3">&nbsp; 
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="29" valign="middle" colspan="3" class="comment"><font color="#990000">&nbsp;<b>Nama 
                                                                                            Laporan :&nbsp;<%=rformat.getName()%> </b></font></td>
                                                                                        </tr>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="28" valign="middle" colspan="3" class="comment"><b>&nbsp;<%=langMD[0]%></b></td>
                                                                                        </tr>
                                                                                        <%
            try {
                                                                                        %>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="22" valign="middle" colspan="3"> 
                                                                                            <%= drawList(iJSPCommand, jspRptFormatDetail, rptFormatDetail, listRptFormatDetail, oidRptFormatDetail)%> </td>
                                                                                        </tr>
                                                                                        <tr align="left" valign="top">
                                                                                            <td height="8" align="left" colspan="3" class="command">&nbsp;</td>
                                                                                        </tr>
                                                                                        <%
            } catch (Exception exc) {
            }%>
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
                                                                                                    <% ctrLine.setLocationImg(approot + "/images/ctr_line");
            ctrLine.initDefault();
                                                                                                    %>
                                                                                            <%=ctrLine.drawImageListLimit(cmd, vectSize, start, recordToGet)%> </span> </td>
                                                                                        </tr>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="22" valign="middle" colspan="3">&nbsp;</td>
                                                                                        </tr>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="22" valign="middle" colspan="3">
                                                                                                <%if(privAdd){%><a href="javascript:cmdAdd()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new211','','../images/new2.gif',1)"><img src="../images/new.gif" name="new211" width="71" height="22" border="0"></a><%}%> 
                                                                                            &nbsp;&nbsp;<a href="javascript:cmdCancel()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('back211','','../images/back2.gif',1)"><img src="../images/back.gif" name="back21" height="22" border="0"></a></td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="8" valign="middle" width="17%"> 
                                                                                    <%if ((iJSPCommand == JSPCommand.ADD) || (iJSPCommand == JSPCommand.SAVE) && (jspRptFormatDetail.errorSize() > 0) || (iJSPCommand == JSPCommand.EDIT) || (iJSPCommand == JSPCommand.ASK)) {%>
                                                                                    <table width="100%" border="0" cellspacing="1" cellpadding="0">
                                                                                        <tr align="left"> 
                                                                                            <td height="21" valign="middle" width="11%">&nbsp;</td>
                                                                                            <td height="21" width="89%" class="comment" valign="top">&nbsp;</td>
                                                                                        </tr>
                                                                                        <tr align="left"> 
                                                                                            <td height="21" valign="middle" width="11%">&nbsp;</td>
                                                                                            <td height="21" width="89%" class="comment" valign="top">*)= 
                                                                                            <%=langMD[4]%></td>
                                                                                        </tr>
                                                                                        <tr align="left"> 
                                                                                            <td height="21" width="11%" nowrap>&nbsp;<b><%=langMD[1]%>&nbsp;</b></td>
                                                                                            <td height="21" width="89%"> 
                                                                                            <input type="text" name="<%=jspRptFormatDetail.colNames[jspRptFormatDetail.JSP_DESCRIPTION] %>"  value="<%=(rptFormatDetail.getDescription() == null) ? "" : rptFormatDetail.getDescription() %>" class="formElemen" size="50">
                                                                                            * <%= jspRptFormatDetail.getErrorMsg(jspRptFormatDetail.JSP_DESCRIPTION) %> 
                                                                                        </tr>
                                                                                        <tr> 
                                                                                            <td width="11%"><b>&nbsp;<b></b><%=langMD[2]%></b></td>
                                                                                            <td width="89%"> 
                                                                                                <%
    Vector temp = DbRptFormatDetail.list(0, 0, DbRptFormatDetail.colNames[DbRptFormatDetail.COL_RPT_FORMAT_ID] + "=" + oidRptFormat, DbRptFormatDetail.colNames[DbRptFormatDetail.COL_SQUENCE]);
                                                                                                %>
                                                                                                <select name="<%=jspRptFormatDetail.colNames[jspRptFormatDetail.JSP_REF_ID] %>">
                                                                                                    <option value="0">-</option>
                                                                                                    <%if (temp != null && temp.size() > 0) {
        for (int i = 0; i < temp.size(); i++) {
            RptFormatDetail rpd = (RptFormatDetail) temp.get(i);
            String level = "";
            if (rpd.getLevel() == 1) {
                level = "&nbsp;&nbsp;&nbsp;&nbsp;";
            } else if (rpd.getLevel() == 2) {
                level = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
            } else if (rpd.getLevel() == 3) {
                level = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
            } else if (rpd.getLevel() == 4) {
                level = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
            }
                                                                                                    %>
                                                                                                    <option value="<%=rpd.getOID()%>" <%if (rpd.getOID() == rptFormatDetail.getRefId()) {%>selected<%}%>><%=level + rpd.getDescription()%></option>
                                                                                                    <%}
    }%>
                                                                                                </select>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr align="left" > 
                                                                                            <td width="11%"> 
                                                                                                <div align="left"><b>&nbsp;<b></b><%=langMD[3]%></b></div>
                                                                                            </td>
                                                                                            <td width="89%"> 
                                                                                                <select name="<%=jspRptFormatDetail.colNames[jspRptFormatDetail.JSP_TYPE] %>">
                                                                                                    
                                                                                                    <option value="<%=DbRptFormatDetail.RPT_TYPE_DATA%>" <%if (rptFormatDetail.getType() == DbRptFormatDetail.RPT_TYPE_DATA) {%>selected<%}%>><%=DbRptFormatDetail.strDetailType[lang][DbRptFormatDetail.RPT_TYPE_DATA]%></option>
                                                                                                    <option value="<%=DbRptFormatDetail.RPT_TYPE_TOTAL%>" <%if (rptFormatDetail.getType() == DbRptFormatDetail.RPT_TYPE_TOTAL) {%>selected<%}%>><%=DbRptFormatDetail.strDetailType[lang][DbRptFormatDetail.RPT_TYPE_TOTAL]%></option>
                                                                                                    <option value="<%=DbRptFormatDetail.RPT_TYPE_LABA_TAHUN_BERJALAN%>" <%if (rptFormatDetail.getType() == DbRptFormatDetail.RPT_TYPE_LABA_TAHUN_BERJALAN) {%>selected<%}%>><%=DbRptFormatDetail.strDetailType[lang][DbRptFormatDetail.RPT_TYPE_LABA_TAHUN_BERJALAN]%></option>
                                                                                                    <option value="<%=DbRptFormatDetail.RPT_TYPE_LABA_TAHUN_LALU%>" <%if (rptFormatDetail.getType() == DbRptFormatDetail.RPT_TYPE_LABA_TAHUN_LALU) {%>selected<%}%>><%=DbRptFormatDetail.strDetailType[lang][DbRptFormatDetail.RPT_TYPE_LABA_TAHUN_LALU]%></option>
                                                                                                    <option value="<%=DbRptFormatDetail.RPT_TYPE_MODAL%>" <%if (rptFormatDetail.getType() == DbRptFormatDetail.RPT_TYPE_MODAL) {%>selected<%}%>><%=DbRptFormatDetail.strDetailType[lang][DbRptFormatDetail.RPT_TYPE_MODAL]%></option>
                                                                                                </select>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr align="left" > 
                                                                                            <td width="11%" nowrap> 
                                                                                                <div align="left"><b>&nbsp;<b></b><%=langMD[5]%>&nbsp;&nbsp;</b></div>
                                                                                            </td>
                                                                                            <td width="89%"> 
                                                                                                <select name="<%=jspRptFormatDetail.colNames[jspRptFormatDetail.JSP_SQUENCE] %>">
                                                                                                    <%for (int i = 0; i < 1500; i++) {%>
                                                                                                    <option value="<%=i + 1%>" <%if (rptFormatDetail.getSquence() == (i + 1)) {%>selected<%}%>><%=i + 1%></option>
                                                                                                    <%}%>
                                                                                                </select>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr align="left" > 
                                                                                            <td valign="top" width="11%">&nbsp;</td>
                                                                                            <td valign="top" width="89%">&nbsp;</td>
                                                                                        </tr>
                                                                                    </table>
                                                                                    <%
    ctrLine.setLocationImg(approot + "/images/ctr_line");
    ctrLine.initDefault();
    ctrLine.setTableWidth("80%");
    String scomDel = "javascript:cmdAsk('" + oidRptFormatDetail + "')";
    String sconDelCom = "javascript:cmdConfirmDelete('" + oidRptFormatDetail + "')";
    String scancel = "javascript:cmdEdit('" + oidRptFormatDetail + "')";
    ctrLine.setBackCaption("Back to List");
    ctrLine.setJSPCommandStyle("buttonlink");

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
                                                                                    %>
                                                                                    <%= ctrLine.drawImage(iJSPCommand, iErrCode, msgString)%> 
                                                                                    <%}%>
                                                                                </td>
                                                                            </tr>
                                                                            <tr align="left" valign="top" > 
                                                                                <td class="command">&nbsp; </td>
                                                                            </tr>
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
