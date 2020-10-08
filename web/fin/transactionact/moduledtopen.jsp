
<%-- 
    Document   : moduledtopen
    Created on : Sep 19, 2011, 4:12:17 PM
    Author     : Roy Andika
--%>

<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.main.entity.*" %>
<%@ page import = "com.project.fms.activity.*" %>
<%@ page import = "com.project.fms.transaction.*" %>
<%@ page import = "com.project.*" %>
<%@ include file = "../main/javainit.jsp" %>
<% int appObjCode = 1;%>
<%@ include file = "../main/check.jsp" %>

<%
            String sourcePage = JSPRequestValue.requestString(request, "source_name");
            if (sourcePage == null || sourcePage.length() == 0) {
                sourcePage = "frmgl";
            }

            String where = JSPRequestValue.requestString(request, "where");
            int iJSPCommand = JSPRequestValue.requestCommand(request);
            String val = JSPRequestValue.requestString(request, "val");
            String formName = JSPRequestValue.requestString(request, "formName");
            String idx = JSPRequestValue.requestString(request, "id");
            String desc = JSPRequestValue.requestString(request, "desc");
            StringTokenizer strTokenizer = new StringTokenizer(val, ",");

            Vector listMd = new Vector();

            if (iJSPCommand == JSPCommand.SUBMIT) {

                int count = DbSegment.getCount("");

                switch (count) {
                    case 0:
                        break;
                    case 1:
                        String var1 = JSPRequestValue.requestString(request, "JSP_SEGMENT1_ID");
                        where = "segment1_id=" + var1;
                        break;
                    case 2:
                        var1 = JSPRequestValue.requestString(request, "JSP_SEGMENT1_ID");
                        String var2 = JSPRequestValue.requestString(request, "JSP_SEGMENT2_ID");
                        where = "segment1_id=" + var1 + " and segment2_id=" + var2;
                        break;
                    case 3:
                        var1 = JSPRequestValue.requestString(request, "JSP_SEGMENT1_ID");
                        var2 = JSPRequestValue.requestString(request, "JSP_SEGMENT2_ID");
                        String var3 = JSPRequestValue.requestString(request, "JSP_SEGMENT3_ID");
                        where = "segment1_id=" + var1 + " and segment2_id=" + var2 + " and segment3_id=" + var3;
                        break;
                    case 4:
                        var1 = JSPRequestValue.requestString(request, "JSP_SEGMENT1_ID");
                        var2 = JSPRequestValue.requestString(request, "JSP_SEGMENT2_ID");
                        var3 = JSPRequestValue.requestString(request, "JSP_SEGMENT3_ID");
                        String var4 = JSPRequestValue.requestString(request, "JSP_SEGMENT4_ID");
                        where = "segment1_id=" + var1 + " and segment2_id=" + var2 + " and segment3_id=" + var3 +
                                " and segment4_id=" + var4;
                        break;
                    case 5:
                        var1 = JSPRequestValue.requestString(request, "JSP_SEGMENT1_ID");
                        var2 = JSPRequestValue.requestString(request, "JSP_SEGMENT2_ID");
                        var3 = JSPRequestValue.requestString(request, "JSP_SEGMENT3_ID");
                        var4 = JSPRequestValue.requestString(request, "JSP_SEGMENT4_ID");
                        String var5 = JSPRequestValue.requestString(request, "JSP_SEGMENT5_ID");
                        where = "segment1_id=" + var1 + " and segment2_id=" + var2 + " and segment3_id=" + var3 +
                                " and segment4_id=" + var4 + " and segment5_id=" + var5;
                        break;
                    case 6:
                        var1 = JSPRequestValue.requestString(request, "JSP_SEGMENT1_ID");
                        var2 = JSPRequestValue.requestString(request, "JSP_SEGMENT2_ID");
                        var3 = JSPRequestValue.requestString(request, "JSP_SEGMENT3_ID");
                        var4 = JSPRequestValue.requestString(request, "JSP_SEGMENT4_ID");
                        var5 = JSPRequestValue.requestString(request, "JSP_SEGMENT5_ID");
                        String var6 = JSPRequestValue.requestString(request, "JSP_SEGMENT6_ID");
                        where = "segment1_id=" + var1 + " and segment2_id=" + var2 + " and segment3_id=" + var3 +
                                " and segment4_id=" + var4 + " and segment5_id=" + var5 + " and segment6_id=" + var6;
                    case 7:
                        var1 = JSPRequestValue.requestString(request, "JSP_SEGMENT1_ID");
                        var2 = JSPRequestValue.requestString(request, "JSP_SEGMENT2_ID");
                        var3 = JSPRequestValue.requestString(request, "JSP_SEGMENT3_ID");
                        var4 = JSPRequestValue.requestString(request, "JSP_SEGMENT4_ID");
                        var5 = JSPRequestValue.requestString(request, "JSP_SEGMENT5_ID");
                        var6 = JSPRequestValue.requestString(request, "JSP_SEGMENT6_ID");
                        String var7 = JSPRequestValue.requestString(request, "JSP_SEGMENT7_ID");
                        where = "segment1_id=" + var1 + " and segment2_id=" + var2 + " and segment3_id=" + var3 +
                                " and segment4_id=" + var4 + " and segment5_id=" + var5 + " and segment6_id=" + var6 +
                                " and segment7_id=" + var7;
                    case 8:
                        var1 = JSPRequestValue.requestString(request, "JSP_SEGMENT1_ID");
                        var2 = JSPRequestValue.requestString(request, "JSP_SEGMENT2_ID");
                        var3 = JSPRequestValue.requestString(request, "JSP_SEGMENT3_ID");
                        var4 = JSPRequestValue.requestString(request, "JSP_SEGMENT4_ID");
                        var5 = JSPRequestValue.requestString(request, "JSP_SEGMENT5_ID");
                        var6 = JSPRequestValue.requestString(request, "JSP_SEGMENT6_ID");
                        var7 = JSPRequestValue.requestString(request, "JSP_SEGMENT7_ID");
                        String var8 = JSPRequestValue.requestString(request, "JSP_SEGMENT8_ID");
                        where = "segment1_id=" + var1 + " and segment2_id=" + var2 + " and segment3_id=" + var3 +
                                " and segment4_id=" + var4 + " and segment5_id=" + var5 + " and segment6_id=" + var6 +
                                " and segment7_id=" + var7 + " and segment8_id=" + var8;
                    case 9:
                        var1 = JSPRequestValue.requestString(request, "JSP_SEGMENT1_ID");
                        var2 = JSPRequestValue.requestString(request, "JSP_SEGMENT2_ID");
                        var3 = JSPRequestValue.requestString(request, "JSP_SEGMENT3_ID");
                        var4 = JSPRequestValue.requestString(request, "JSP_SEGMENT4_ID");
                        var5 = JSPRequestValue.requestString(request, "JSP_SEGMENT5_ID");
                        var6 = JSPRequestValue.requestString(request, "JSP_SEGMENT6_ID");
                        var7 = JSPRequestValue.requestString(request, "JSP_SEGMENT7_ID");
                        var8 = JSPRequestValue.requestString(request, "JSP_SEGMENT8_ID");
                        String var9 = JSPRequestValue.requestString(request, "JSP_SEGMENT9_ID");
                        where = "segment1_id=" + var1 + " and segment2_id=" + var2 + " and segment3_id=" + var3 +
                                " and segment4_id=" + var4 + " and segment5_id=" + var5 + " and segment6_id=" + var6 +
                                " and segment7_id=" + var7 + " and segment8_id=" + var8 + " and segment9_id=" + var9;
                    case 10:
                        var1 = JSPRequestValue.requestString(request, "JSP_SEGMENT1_ID");
                        var2 = JSPRequestValue.requestString(request, "JSP_SEGMENT2_ID");
                        var3 = JSPRequestValue.requestString(request, "JSP_SEGMENT3_ID");
                        var4 = JSPRequestValue.requestString(request, "JSP_SEGMENT4_ID");
                        var5 = JSPRequestValue.requestString(request, "JSP_SEGMENT5_ID");
                        var6 = JSPRequestValue.requestString(request, "JSP_SEGMENT6_ID");
                        var7 = JSPRequestValue.requestString(request, "JSP_SEGMENT7_ID");
                        var8 = JSPRequestValue.requestString(request, "JSP_SEGMENT8_ID");
                        var9 = JSPRequestValue.requestString(request, "JSP_SEGMENT9_ID");
                        String var10 = JSPRequestValue.requestString(request, "JSP_SEGMENT10_ID");
                        where = "segment1_id=" + var1 + " and segment2_id=" + var2 + " and segment3_id=" + var3 +
                                " and segment4_id=" + var4 + " and segment5_id=" + var5 + " and segment6_id=" + var6 +
                                " and segment7_id=" + var7 + " and segment8_id=" + var8 + " and segment9_id=" + var9 +
                                " and segment10_id=" + var10;
                    case 11:
                        var1 = JSPRequestValue.requestString(request, "JSP_SEGMENT1_ID");
                        var2 = JSPRequestValue.requestString(request, "JSP_SEGMENT2_ID");
                        var3 = JSPRequestValue.requestString(request, "JSP_SEGMENT3_ID");
                        var4 = JSPRequestValue.requestString(request, "JSP_SEGMENT4_ID");
                        var5 = JSPRequestValue.requestString(request, "JSP_SEGMENT5_ID");
                        var6 = JSPRequestValue.requestString(request, "JSP_SEGMENT6_ID");
                        var7 = JSPRequestValue.requestString(request, "JSP_SEGMENT7_ID");
                        var8 = JSPRequestValue.requestString(request, "JSP_SEGMENT8_ID");
                        var9 = JSPRequestValue.requestString(request, "JSP_SEGMENT9_ID");
                        var10 = JSPRequestValue.requestString(request, "JSP_SEGMENT10_ID");
                        String var11 = JSPRequestValue.requestString(request, "JSP_SEGMENT11_ID");
                        where = "segment1_id=" + var1 + " and segment2_id=" + var2 + " and segment3_id=" + var3 +
                                " and segment4_id=" + var4 + " and segment5_id=" + var5 + " and segment6_id=" + var6 +
                                " and segment7_id=" + var7 + " and segment8_id=" + var8 + " and segment9_id=" + var9 +
                                " and segment10_id=" + var10 + " and segment11_id=" + var11;
                    case 12:
                        var1 = JSPRequestValue.requestString(request, "JSP_SEGMENT1_ID");
                        var2 = JSPRequestValue.requestString(request, "JSP_SEGMENT2_ID");
                        var3 = JSPRequestValue.requestString(request, "JSP_SEGMENT3_ID");
                        var4 = JSPRequestValue.requestString(request, "JSP_SEGMENT4_ID");
                        var5 = JSPRequestValue.requestString(request, "JSP_SEGMENT5_ID");
                        var6 = JSPRequestValue.requestString(request, "JSP_SEGMENT6_ID");
                        var7 = JSPRequestValue.requestString(request, "JSP_SEGMENT7_ID");
                        var8 = JSPRequestValue.requestString(request, "JSP_SEGMENT8_ID");
                        var9 = JSPRequestValue.requestString(request, "JSP_SEGMENT9_ID");
                        var10 = JSPRequestValue.requestString(request, "JSP_SEGMENT10_ID");
                        var11 = JSPRequestValue.requestString(request, "JSP_SEGMENT11_ID");
                        String var12 = JSPRequestValue.requestString(request, "JSP_SEGMENT12_ID");
                        where = "segment1_id=" + var1 + " and segment2_id=" + var2 + " and segment3_id=" + var3 +
                                " and segment4_id=" + var4 + " and segment5_id=" + var5 + " and segment6_id=" + var6 +
                                " and segment7_id=" + var7 + " and segment8_id=" + var8 + " and segment9_id=" + var9 +
                                " and segment10_id=" + var10 + " and segment11_id=" + var11 + " and segment12_id=" + var12;
                    case 13:
                        var1 = JSPRequestValue.requestString(request, "JSP_SEGMENT1_ID");
                        var2 = JSPRequestValue.requestString(request, "JSP_SEGMENT2_ID");
                        var3 = JSPRequestValue.requestString(request, "JSP_SEGMENT3_ID");
                        var4 = JSPRequestValue.requestString(request, "JSP_SEGMENT4_ID");
                        var5 = JSPRequestValue.requestString(request, "JSP_SEGMENT5_ID");
                        var6 = JSPRequestValue.requestString(request, "JSP_SEGMENT6_ID");
                        var7 = JSPRequestValue.requestString(request, "JSP_SEGMENT7_ID");
                        var8 = JSPRequestValue.requestString(request, "JSP_SEGMENT8_ID");
                        var9 = JSPRequestValue.requestString(request, "JSP_SEGMENT9_ID");
                        var10 = JSPRequestValue.requestString(request, "JSP_SEGMENT10_ID");
                        var11 = JSPRequestValue.requestString(request, "JSP_SEGMENT11_ID");
                        var12 = JSPRequestValue.requestString(request, "JSP_SEGMENT12_ID");
                        String var13 = JSPRequestValue.requestString(request, "JSP_SEGMENT13_ID");
                        where = "segment1_id=" + var1 + " and segment2_id=" + var2 + " and segment3_id=" + var3 +
                                " and segment4_id=" + var4 + " and segment5_id=" + var5 + " and segment6_id=" + var6 +
                                " and segment7_id=" + var7 + " and segment8_id=" + var8 + " and segment9_id=" + var9 +
                                " and segment10_id=" + var10 + " and segment11_id=" + var11 + " and segment12_id=" + var12 +
                                " and segment13_id=" + var13;
                    case 14:
                        var1 = JSPRequestValue.requestString(request, "JSP_SEGMENT1_ID");
                        var2 = JSPRequestValue.requestString(request, "JSP_SEGMENT2_ID");
                        var3 = JSPRequestValue.requestString(request, "JSP_SEGMENT3_ID");
                        var4 = JSPRequestValue.requestString(request, "JSP_SEGMENT4_ID");
                        var5 = JSPRequestValue.requestString(request, "JSP_SEGMENT5_ID");
                        var6 = JSPRequestValue.requestString(request, "JSP_SEGMENT6_ID");
                        var7 = JSPRequestValue.requestString(request, "JSP_SEGMENT7_ID");
                        var8 = JSPRequestValue.requestString(request, "JSP_SEGMENT8_ID");
                        var9 = JSPRequestValue.requestString(request, "JSP_SEGMENT9_ID");
                        var10 = JSPRequestValue.requestString(request, "JSP_SEGMENT10_ID");
                        var11 = JSPRequestValue.requestString(request, "JSP_SEGMENT11_ID");
                        var12 = JSPRequestValue.requestString(request, "JSP_SEGMENT12_ID");
                        var13 = JSPRequestValue.requestString(request, "JSP_SEGMENT13_ID");
                        String var14 = JSPRequestValue.requestString(request, "JSP_SEGMENT14_ID");
                        where = "segment1_id=" + var1 + " and segment2_id=" + var2 + " and segment3_id=" + var3 +
                                " and segment4_id=" + var4 + " and segment5_id=" + var5 + " and segment6_id=" + var6 +
                                " and segment7_id=" + var7 + " and segment8_id=" + var8 + " and segment9_id=" + var9 +
                                " and segment10_id=" + var10 + " and segment11_id=" + var11 + " and segment12_id=" + var12 +
                                " and segment13_id=" + var13 + " and segment14_id=" + var14;
                    case 15:
                        var1 = JSPRequestValue.requestString(request, "JSP_SEGMENT1_ID");
                        var2 = JSPRequestValue.requestString(request, "JSP_SEGMENT2_ID");
                        var3 = JSPRequestValue.requestString(request, "JSP_SEGMENT3_ID");
                        var4 = JSPRequestValue.requestString(request, "JSP_SEGMENT4_ID");
                        var5 = JSPRequestValue.requestString(request, "JSP_SEGMENT5_ID");
                        var6 = JSPRequestValue.requestString(request, "JSP_SEGMENT6_ID");
                        var7 = JSPRequestValue.requestString(request, "JSP_SEGMENT7_ID");
                        var8 = JSPRequestValue.requestString(request, "JSP_SEGMENT8_ID");
                        var9 = JSPRequestValue.requestString(request, "JSP_SEGMENT9_ID");
                        var10 = JSPRequestValue.requestString(request, "JSP_SEGMENT10_ID");
                        var11 = JSPRequestValue.requestString(request, "JSP_SEGMENT11_ID");
                        var12 = JSPRequestValue.requestString(request, "JSP_SEGMENT12_ID");
                        var13 = JSPRequestValue.requestString(request, "JSP_SEGMENT13_ID");
                        var14 = JSPRequestValue.requestString(request, "JSP_SEGMENT14_ID");
                        String var15 = JSPRequestValue.requestString(request, "JSP_SEGMENT15_ID");
                        where = "segment1_id=" + var1 + " and segment2_id=" + var2 + " and segment3_id=" + var3 +
                                " and segment4_id=" + var4 + " and segment5_id=" + var5 + " and segment6_id=" + var6 +
                                " and segment7_id=" + var7 + " and segment8_id=" + var8 + " and segment9_id=" + var9 +
                                " and segment10_id=" + var10 + " and segment11_id=" + var11 + " and segment12_id=" + var12 +
                                " and segment13_id=" + var13 + " and segment14_id=" + var14 + " and segment15_id=" + var15;
                }

                listMd = DbModule.list(0, 0, where, DbModule.colNames[DbModule.COL_CODE]);

            }

            /*** LANG ***/
            String[] langCT = {"Number", "Code", "Activity", "Target", "Total Budget", "Total", "Saldo"}; //0-6


            String[] langNav = {"Activity", "Activity List", "Data not found"};

            if (lang == LANG_ID) {

                String[] langID = {"No", "Kode", "Kegiatan", "Sasaran", "Total Anggaran", "Total Pemakaian", "Saldo"}; //0-6

                langCT = langID;

                String[] navID = {"Kegiatan", "Data Kerja", "Data tidak ditemukan"};
                langNav = navID;
            }

%>
<html >
    <head>
        <title><%=systemTitle%></title>
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
        <link href="../css/default.css" rel="stylesheet" type="text/css" />
        <link href="../css/css.css" rel="stylesheet" type="text/css" />
        <script language="JavaScript">
            <!--
            function cmdSelect(moduleid,modulename,coaid, coaname){                
                self.opener.document.<%=sourcePage%>.module_txt.value = modulename;
                self.opener.document.<%=sourcePage%>.<%=JspGlDetail.colNames[JspGlDetail.JSP_MODULE_ID]%>.value = moduleid;           
                self.opener.document.<%=sourcePage%>.coa_txt.value = coaname;
                self.opener.document.<%=sourcePage%>.<%=JspGlDetail.colNames[JspGlDetail.JSP_COA_ID]%>.value = coaid;           
                self.close();
            }
            
            function cmdGetData(){
                document.form1.command.value="<%=JSPCommand.SUBMIT%>";
                document.form1.action="moduledtopen.jsp";
                document.form1.submit();
            }
            
            function MM_swapImgRestore() { //v3.0
                var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
            }
            //-->
        </script>
    </head>
    <body>
        <form name="form1" method="post" action="">
            <input type="hidden" name="command">
            <input type="hidden" name="source_name" value="<%=sourcePage%>">  
            <table width="100%">
                <tr> 
                    <td align="center"> 
                        <table width="98%" cellpadding="0" cellspacing="1">
                            <tr> 
                                <td colspan="3"> 
                                    <%
            Vector vSegment = new Vector();

            try {
                vSegment = DbSegment.list(0, 0, "", DbSegment.colNames[DbSegment.COL_COUNT]);
            } catch (Exception e) {}

            if (vSegment != null && vSegment.size() > 0) {%>
                                    <table width="625">
                                        <tr> 
                                            <td width="102">&nbsp;</td>
                                            <td width="511">&nbsp;</td>
                                        </tr>
                                        <%
                                        if (vSegment != null && vSegment.size() > 0) {
                                            
                                            for (int i = 0; i < vSegment.size(); i++) {
                                                
                                                Segment seg = (Segment) vSegment.get(i);
                                                Vector sgDetails = DbSegmentDetail.list(0, 0, "segment_id=" + seg.getOID(), "");
                                                int pgs = i + 1;
                                                long seg_id = JSPRequestValue.requestLong(request, "JSP_SEGMENT" + pgs + "_ID");
                                        %>
                                        <tr align="left"> 
                                            <td height="21" width="102">&nbsp;<%=seg.getName()%></td>
                                            <td height="21" colspan="2" width="511"> 
                                                <select name="JSP_SEGMENT<%=i + 1%>_ID">
                                                    <%if (sgDetails != null && sgDetails.size() > 0) {
                                                        for (int x = 0; x < sgDetails.size(); x++) {
                                                            SegmentDetail sd = (SegmentDetail) sgDetails.get(x);

                                                    %>
                                                    <option value="<%=sd.getOID()%>"  <%if (sd.getOID() == seg_id) {%>selected<%}%>><%=sd.getName()%></option>
                                                    <%}
                                                    }%>
                                                </select>
                                            </td>
                                        </tr>
                                        <%}
                                        }%>
                                        <tr> 
                                            <td width="102">&nbsp;</td>
                                            <td width="511"> 
                                                <table width="100%" border="0" cellspacing="0" cellpadding="0" height="29">
                                                    <tr> 
                                                        <td width="5%"><a href="javascript:cmdGetData()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new21','','../images/search.jpg',1)"><img src="../images/search2.jpg" name="new211" height="20" border="0" style="padding:0px"></a></td>
                                                        <td width="95%">&nbsp;<a href="javascript:cmdGetData()">Get Data</a></td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                    </table>
                                    <%}%>
                                </td>
                            </tr>
                            <%
            if (iJSPCommand == JSPCommand.SUBMIT) {
                if (listMd != null && listMd.size() > 0) {%>
                            <tr> 
                                <td class="tablehdr" width="10%"><%=langCT[0]%></td>
                                <td class="tablehdr" width="30%"><%=langCT[2]%></td>
                                <td class="tablehdr" width="43%">Budget</td>
                            </tr>
                            <%
                                        for (int i = 0; i < listMd.size(); i++) {
                                            
                                            Module mod = (Module) listMd.get(i);
                                            
                                            String descx = "";
                                            StringTokenizer strTok = new StringTokenizer(mod.getDescription(), ";");

                                            int countOut = 0;

                                            while (strTok.hasMoreTokens()) {

                                                if (countOut != 0) {
                                                    descx = descx + "<BR>";
                                                }

                                                descx = descx + strTok.nextToken();
                                                countOut++;
                                            }

                                            if (i % 2 == 0) {

                            %>
                            <tr> 
                                <td class="tablecell" align="center" valign="top" width="10%"><%=i + 1%></td>
                                <td class="tablecell" align="left" valign="top" width="30%">&nbsp;<%=descx%></td>
                                <td class="tablecell" align="right" valign="top" width="43%"> 
                                    <div align="left"> 
                                        <%
                                        Vector temp = DbModuleBudget.list(0, 0, "module_id=" + mod.getOID(), "");
                                        %>
                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                            <tr> 
                                                <td height="17"><b>Perkiraan</b></td>
                                                <td height="17"><b>Saldo</b></td>
                                            </tr>
                                            <tr> 
                                                <td colspan="2" height="1" bgcolor="#CCCCCC"></td>
                                            </tr>
                                            <%if (temp != null && temp.size() > 0) {
                                            for (int x = 0; x < temp.size(); x++) {
                                                ModuleBudget mbg = (ModuleBudget) temp.get(x);
                                                Coa coa = new Coa();
                                                try {
                                                    coa = DbCoa.fetchExc(mbg.getCoaId());
                                                } catch (Exception e) {
                                                }
                                            %>
                                            <tr> 
                                                <td><a href="javascript:cmdSelect('<%=mod.getOID()%>','<%=mod.getDescription()%>','<%=mbg.getCoaId()%>', '<%=coa.getName()%>')"><%=coa.getCode() + " - " + coa.getName()%></a></td>
                                                <td><%=JSPFormater.formatNumber(mbg.getAmount() - mbg.getAmountUsed(), "#,###.##")%></td>
                                            </tr>
                                            <%}
                                        }%>
                                        </table>
                                    </div>
                                </td>
                            </tr>
                            <%} else {%>
                            <tr> 
                                <td class="tablecelll" align="center" valign="top" width="10%"><%=i + 1%></td>
                                <td class="tablecelll" align="left" valign="top" width="30%">&nbsp;<%=descx%></td>
                                <td class="tablecelll" align="right" valign="top" width="43%"> 
                                    <div align="left"> 
                                        <%
                                        Vector temp = DbModuleBudget.list(0, 0, "module_id=" + mod.getOID(), "");
                                        %>
                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                            <tr> 
                                                <td height="17"><b>Perkiraan</b></td>
                                                <td height="17"><b>Saldo</b></td>
                                            </tr>
                                            <%if (temp != null && temp.size() > 0) {
                                            for (int x = 0; x < temp.size(); x++) {
                                                ModuleBudget mbg = (ModuleBudget) temp.get(x);
                                                Coa coa = new Coa();
                                                try {
                                                    coa = DbCoa.fetchExc(mbg.getCoaId());
                                                } catch (Exception e) {
                                                }
                                            %>
                                            <tr> 
                                                <td><a href="javascript:cmdSelect('<%=mod.getOID()%>','<%=mod.getDescription()%>','<%=mbg.getCoaId()%>', '<%=coa.getName()%>')"><%=coa.getCode() + " - " + coa.getName()%></a></td>
                                                <td><%=JSPFormater.formatNumber(mbg.getAmount() - mbg.getAmountUsed(), "#,###.##")%></td>
                                            </tr>
                                            <%}
                                        }%>
                                        </table>
                                    </div>
                                </td>
                            </tr>
                            <%}%>
                            <%}%>
                            <%} else {%>
                            <tr> 
                                <td colspan="3" class="tablecell" align="center"><%=langNav[2]%></td>
                            </tr>
                            <%}
                            } else {%>
                            <tr> 
                                <td colspan="3" class="tablecell" align="center">Klik "Get Data" untuk 
                                menampilkan daftar kegiatan</td>
                            </tr>
                            <%}%>
                        </table>
                    </td>
                </tr>
            </table>
            <script language="JavaScript">
                window.focus();
            </script>
        </form>
    </body>
</html>



