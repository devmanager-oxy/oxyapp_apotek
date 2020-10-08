
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
<%@ page import = "com.project.*" %>
<%@ include file = "../main/javainit.jsp" %>
<% int appObjCode = 1;%>
<%@ include file = "../main/check.jsp" %>

<%

            String where = JSPRequestValue.requestString(request, "where");
            String val = JSPRequestValue.requestString(request, "val");
            String formName = JSPRequestValue.requestString(request, "formName");
            String idx = JSPRequestValue.requestString(request, "id");
            String desc = JSPRequestValue.requestString(request, "desc");
            long mdId = JSPRequestValue.requestLong(request, "moduleId");
            StringTokenizer strTokenizer = new StringTokenizer(val, ",");

            String[] vals;

            vals = new String[strTokenizer.countTokens()];
            int count = 0;

            while (strTokenizer.hasMoreTokens()) {
                vals[count] = strTokenizer.nextToken();
                count++;
            }

            Vector listMd = new Vector();

            try {
                listMd = DbModule.list(0, 0, where, DbModule.colNames[DbModule.COL_CODE]);
            } catch (Exception e) {
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
<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
    <head>
        <!-- #BeginEditable "javascript" --> 
        <title><%=systemTitle%></title>
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
        <link href="../css/default.css" rel="stylesheet" type="text/css" />
        <link href="../css/css.css" rel="stylesheet" type="text/css" />
        <script language="JavaScript">            
            function cmdSelect(id,desc,lev){                
                self.opener.document.<%=formName%>.<%=idx%>.value = id;
                self.opener.document.<%=formName%>.<%=desc%>.value = desc;           
                self.opener.document.<%=formName%>.JSP_MODULE_LEVEL.value = lev;
                self.close();
            }
        </script>
    </head>
    <body>
        <table width="100%">
            <tr>
                <td align="center">
                    <table width="98%" cellpadding="0" cellspacing="1">
                        <tr>
                            <td colspan="7">
                                <%
            Vector vSegment = new Vector();

            try {
                vSegment = DbSegment.list(0, 0, "", DbSegment.colNames[DbSegment.COL_COUNT]);
            } catch (Exception e) {
            }

            if (vSegment != null && vSegment.size() > 0) {%>
                                <table>
                                    <tr>
                                        <td width="100px">&nbsp;</td>
                                        <td width="300px">&nbsp</td>
                                    </tr>
                                    <%
                                    for (int idxSeg = 0; idxSeg < vSegment.size(); idxSeg++) {
                                        Segment segment = (Segment) vSegment.get(idxSeg);
                                        String value = "";
                                        
                                        try {
                                            SegmentDetail segDet = DbSegmentDetail.fetchExc(Long.parseLong(vals[idxSeg]));
                                            value = segDet.getName();                                            
                                        } catch (Exception e) {
                                        }
                                    %>                           
                                    <tr>
                                        <td width="100px"><%=segment.getName()%></td>
                                        <td width="300px">: &nbsp;<%=value%></td>
                                    </tr>
                                    <%
                                    }%>
                                    <tr>
                                        <td width="100px">&nbsp;</td>
                                        <td width="300px">&nbsp</td>
                                    </tr>
                                </table>
                                <%}%>  
                                
                            </td>
                        </tr>
                        <%if (listMd != null && listMd.size() > 0) {%>
                        <tr>
                            <td class="tablehdr" width="5%"><%=langCT[0]%></td>
                            <td class="tablehdr" width="10%"><%=langCT[1]%></td>
                            <td class="tablehdr" width="20%"><%=langCT[2]%></td>
                            <td class="tablehdr" width="35%"><%=langCT[3]%></td>
                            <td class="tablehdr" width="10%"><%=langCT[4]%></td>
                            <td class="tablehdr" width="10%"><%=langCT[5]%></td>
                            <td class="tablehdr" width="10%"><%=langCT[6]%></td>
                        </tr>
                        <%
    for (int i = 0; i < listMd.size(); i++){
        
        Module mod = (Module) listMd.get(i);
        double saldo = mod.getTotalBudget() - mod.getTotalBudgetUsed();
        int level = 0;
        
        level = mod.getModuleLevel()+1; 

                        %>
                        <%if (i % 2 == 0) {%>
                        <tr>
                            <td class="tablecell" align="center" valign="top"><%=i + 1%></td>
                            <td class="tablecell" align="center" valign="top">
                                <%
                                if(mdId == mod.getOID()){
                                %>
                                <%=mod.getCode()%>
                                <%
                                }else{                                
    out.println("<a style='color:blue' href=\"javascript:cmdSelect('"+mod.getOID()+"','"+ mod.getDescription() + "','"+level+"')\">" + mod.getCode() + "</a><br />");
                                }
                                %>
                            </td>
                            <td class="tablecell" align="left" valign="top">&nbsp;<%=mod.getDescription()%></td>
                            <td class="tablecell" align="left" valign="top">&nbsp;<%=mod.getOutputDeliver()%></td>
                            <td class="tablecell" align="right" valign="top"><%=JSPFormater.formatNumber(mod.getTotalBudget(), "#,###.##")%>&nbsp;</td>
                            <td class="tablecell" align="right" valign="top"><%=JSPFormater.formatNumber(mod.getTotalBudgetUsed(), "#,###.##")%>&nbsp;</td>
                            <td class="tablecell" align="right" valign="top"><%=JSPFormater.formatNumber(saldo, "#,###.##")%>&nbsp;</td>
                        </tr>
                        <%} else {%>
                        <tr>
                            <td class="tablecelll" align="center" valign="top"><%=i + 1%></td>
                            <td class="tablecelll" align="center" valign="top">
                                <%
                                if(mdId == mod.getOID()){
                                %>
                                <%=mod.getCode()%>
                                <%
                                }else{  
    out.println("<a style='color:blue' href=\"javascript:cmdSelect('"+mod.getOID()+"','"+ mod.getDescription() + "','"+level+"')\">" + mod.getCode() + "</a><br />");
                                }
                                %>
                            </td>
                            <td class="tablecelll" align="left" valign="top">&nbsp;<%=mod.getDescription()%></td>
                            <td class="tablecelll" align="left" valign="top">&nbsp;<%=mod.getOutputDeliver()%></td>
                            <td class="tablecelll" align="right" valign="top"><%=JSPFormater.formatNumber(mod.getTotalBudget(), "#,###.##")%>&nbsp;</td>
                            <td class="tablecelll" align="right" valign="top"><%=JSPFormater.formatNumber(mod.getTotalBudgetUsed(), "#,###.##")%>&nbsp;</td>
                            <td class="tablecelll" align="right" valign="top"><%=JSPFormater.formatNumber(saldo, "#,###.##")%>&nbsp;</td>
                        </tr>
                        <%}%>    
                        <%}%>
                        <%} else {%>
                        <tr>
                            <td colspan="7" class="tablecell" align="center"><%=langNav[2]%></td>
                        </tr>
                        <%}%>
                    </table>  
                </td>
            </tr>
        </table>
    </body>
</html>



