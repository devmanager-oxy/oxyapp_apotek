
<%-- 
    Document   : module_rpt_priview
    Created on : Sep 22, 2011, 10:47:45 AM
    Author     : Roy Andika
--%>

<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.main.db.*" %>
<%@ page import = "com.project.general.*" %>
<%@ page import = "com.project.crm.transaction.*" %>
<%@ page import = "com.project.crm.*" %>
<%@ page import = "com.project.crm.session.*" %>
<%@ page import = "com.project.crm.master.*" %>
<%@ page import = "com.project.crm.report.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "com.project.fms.master.*" %>
<%@ page import = "com.project.fms.transaction.*" %>
<%@ page import = "java.util.Date" %>
<%@ page import = "com.project.crm.transaction.*" %>
<%@ include file = "../main/javainit.jsp" %>
<%@ include file = "../main/check.jsp" %>

<style>
    #title{
        font-family:Arial;        
        font-size: 11px;
    }
    
    #title2{
        font-family:Arial;        
        font-size: 11px;
    }
    
    #text-left{
        font-family:Arial;
        border-left : solid 1px;         
        border-top : solid 1px;        
        font-size: 14px;
    }
    
    #text-right{
        font-family:Arial;
        border-left : solid 1px;         
        border-top : solid 1px;        
        border-right : solid 1px;        
        font-size: 14px;
    }
    #list-left{
        font-family:Arial;
        border-left : solid 1px;         
        border-top : solid 1px;        
        font-size: 12px;
        vertical-align:top;
        padding-left:3px;
        padding-right:3px;
        
    }
    
    #list-right{
        font-family:Arial;
        border-left : solid 1px;         
        border-top : solid 1px;        
        border-right : solid 1px;        
        font-size: 12px;
        vertical-align:top;
        padding-left:3px;
        padding-right:3px;
    }
    
    #list-left-last{        
        border-left : solid 1px;         
        border-bottom : solid 1px;        
    }
    
    #list-right-last{        
        border-left : solid 1px;         
        border-bottom : solid 1px;        
        border-right : solid 1px;        
    }
    
    #list-left-last-tot{        
        border-left : solid 1px;         
        border-bottom : solid 1px;        
    }
    
    #list-right-last-tot{        
        border-left : solid 1px;         
        border-bottom : solid 1px;        
        border-right : solid 1px; 
        padding-right : 3px;
    }
    </style>
<%

            Vector vModule = new Vector();
            long activityPeriodId = JSPRequestValue.requestLong(request, "activity_period_id");
            String strSegment = JSPRequestValue.requestStringExcTitikKoma(request, "jenAkt");

            String[] condition;
            StringTokenizer strTokenizerCondition = new StringTokenizer(strSegment, ";");
            condition = new String[strTokenizerCondition.countTokens()];

            String name_periode = "";
            try {
                ActivityPeriod periode = DbActivityPeriod.fetchExc(activityPeriodId);
                name_periode = periode.getName();
            } catch (Exception e) {
            }

            if (session.getValue("MODULE_GEREJA") != null) {
                vModule = (Vector) session.getValue("MODULE_GEREJA");
            }

            String header = "";

            try {
                header = DbSystemProperty.getValueByName("HEADER_DATA_KERJA");
            } catch (Exception e) {
            }

            String[] langMD = {"Number", "Activity", "Target", "Days", "Date",
                "Time", "Memo", "Budget"
            };

            String[] langNav = {"Activity", "Activity List", "Period", "Data not found", "Please click search button to show activity datas"};

            if (lang == LANG_ID) {
                String[] langID = {"No", "Kegiatan", "Sasaran", "Hari", "Tanggal",
                    "Waktu", "Keterangan", "Anggaran"
                };

                langMD = langID;
                String[] navID = {"Kegiatan", "Data Kerja", "Periode", "Data tidak ditemukan", "Click tombol search untuk menampilkan data kerja"};
                langNav = navID;
            }
%>
<table align="center" border="0" width="95%" cellpadding="0" cellspacing="0">
    <tr>
        <td colspan="8">&nbsp;</td>                                                                                                        
    </tr>
    <tr>
        <td colspan="8" class id="title" align="left"><B><%=header.toUpperCase()%> <%=name_periode.toUpperCase()%><B></td>                                                                                                        
    </tr>     
    <%
            int count = 0;

            while (strTokenizerCondition.hasMoreTokens()) {

                condition[count] = strTokenizerCondition.nextToken();

                long segmentId = Long.parseLong(condition[count]);

                String nama = "";
                String value = "";

                try {
                    SegmentDetail segmentDetail = DbSegmentDetail.fetchExc(segmentId);
                    value = segmentDetail.getName();

                    if (segmentDetail.getSegmentId() != 0) {
                        Segment segment = DbSegment.fetchExc(segmentDetail.getSegmentId());
                        nama = segment.getName();
                    }

                } catch (Exception e) {
                }

    %>
    <tr>
        <td colspan="8" >
            <table cellpadding="0" cellspacing="0">
                <tr>
                    <td width="140" class id="title" align="left"><B><%=nama.toUpperCase()%></B></td>
                    <td width="500" class id="title" align="left">:&nbsp;<B><%=value.toUpperCase()%></B></td>
                </tr>
            </table>    
        </td>                                                                                                        
    </tr>
    <%
                count++;
            }
    %>
    <tr>
        <td colspan="8" height="8"></td>                                                                                                        
    </tr>
    <tr height="30">
        <td width="5%" class id="text-left" align="center"><%=langMD[0]%></td>                                                                                                        
        <td width="18%" class id="text-left" align="center"><%=langMD[1]%></td>
        <td width="15%" class id="text-left" align="center"><%=langMD[2]%></td>
        <td width="10%" class id="text-left" align="center"><%=langMD[3]%></td>
        <td width="15%" class id="text-left" align="center"><%=langMD[4]%></td>
        <td width="10%" class id="text-left" align="center"><%=langMD[5]%></td>
        <td width="10%" class id="text-left" align="center"><%=langMD[6]%></td>
        <td width="17%" class id="text-right" align="center"><%=langMD[7]%></td>
    </tr> 
    <%
            double totAllBudget = 0;

            String idr = "Rp.";
            try {
                idr = DbSystemProperty.getValueByName("CURRENCY_CODE_IDR");
            } catch (Exception e) {
            }

            if (vModule != null && vModule.size() > 0) {

                for (int i = 0; i < vModule.size(); i++) {

                    Module module = (Module) vModule.get(i);

                    String mdBudget = "";
                    double totalBud = 0;

                    Vector vMb = DbModuleBudget.list(0, 0, DbModuleBudget.colNames[DbModuleBudget.COL_MODULE_ID] + "=" + module.getOID(), null);

                    if (vMb != null && vMb.size() > 0) {

                        for (int x = 0; x < vMb.size(); x++) {

                            ModuleBudget mb = (ModuleBudget) vMb.get(x);

                            String currency = "";
                            try {
                                Currency objCur = DbCurrency.fetchExc(mb.getCurrencyId());
                                currency = objCur.getCurrencyCode();
                            } catch (Exception e) {
                            }

                            totalBud = totalBud + mb.getAmount();
                            if (x != 0) {
                                mdBudget = mdBudget + " <BR> ";
                            }
                            mdBudget = mdBudget + mb.getDescription() + " = " + currency + "" + JSPFormater.formatNumber(mb.getAmount(), "#,###.##");

                        }

                        mdBudget = mdBudget + "<BR><BR> <B>TOTAL = " + idr + "" + JSPFormater.formatNumber(totalBud, "#,###.##") + "</B>";

                    }

                    totAllBudget = totAllBudget + totalBud;

                    //Tokenizer untuk Sasaran
                    String outputDeliver = "";
                    StringTokenizer strTokenizerOutputDeliver = new StringTokenizer(module.getOutputDeliver(), ";");

                    int countOut = 0;

                    while (strTokenizerOutputDeliver.hasMoreTokens()) {

                        if (countOut != 0) {
                            outputDeliver = outputDeliver + "<BR>";
                        }

                        outputDeliver = outputDeliver + strTokenizerOutputDeliver.nextToken();
                        countOut++;
                    }
                    //=== END Tokenizer untuk Sasaran ===

                    //Tokenizer untuk action Day
                    String actDays = "";
                    StringTokenizer strTokenizerDays = new StringTokenizer(module.getActDay(), ";");

                    int countDays = 0;

                    while (strTokenizerDays.hasMoreTokens()) {

                        if (countDays != 0) {
                            actDays = actDays + "<BR>";
                        }

                        actDays = actDays + strTokenizerDays.nextToken();
                        countDays++;
                    }
                    //=== END Tokenizer untuk act day ===

                    //Tokenizer untuk Date
                    String date = "";
                    StringTokenizer strTokenizerDate = new StringTokenizer(module.getActDate(), ";");

                    int countDate = 0;

                    while (strTokenizerDate.hasMoreTokens()) {

                        if (countDate != 0) {
                            date = date + "<BR>";
                        }

                        date = date + strTokenizerDate.nextToken();
                        countDate++;
                    }
                    //=== END Tokenizer untuk date

                    //Tokenizer untuk Time
                    String time = "";
                    StringTokenizer strTokenizerTime = new StringTokenizer(module.getActTime(), ";");

                    int countTime = 0;

                    while (strTokenizerTime.hasMoreTokens()) {

                        if (countTime != 0) {
                            time = time + "<BR>";
                        }

                        time = time + strTokenizerTime.nextToken();
                        countTime++;
                    }
                    //=== END Tokenizer untuk time

                    //Tokenizer untuk Keterangan
                    String note = "";
                    StringTokenizer strTokenizerNote = new StringTokenizer(module.getNote(), ";");

                    int countNote = 0;

                    while (strTokenizerNote.hasMoreTokens()) {

                        if (countNote != 0) {
                            note = note + "<BR>";
                        }

                        note = note + strTokenizerNote.nextToken();
                        countNote++;
                    }
                    //=== END Tokenizer untuk keterangan

    %>    
    <tr>
        <td class id="list-left" align="center"><%=i + 1%></td>                                                                                                        
        <td class id="list-left" align="left"><%=module.getCode().length() > 0 ? module.getCode()+" - "+module.getDescription() : module.getDescription() %></td>
        <td class id="list-left" align="left"><%=outputDeliver.length() > 0 ? outputDeliver : "&nbsp;" %></td>
        <td class id="list-left" align="left"><%=actDays.length() > 0 ? actDays : "&nbsp;"%></td>
        <td class id="list-left" align="left"><%=date.length() > 0 ? date : "&nbsp;"%></td>
        <td class id="list-left" align="left"><%=time.length() > 0 ? time : "&nbsp;"%></td>
        <td class id="list-left" align="left"><%=note.length() > 0 ? note : "&nbsp;"%></td>
        <td class id="list-right" align="left"><%=mdBudget.length() > 0 ? mdBudget : "&nbsp;"%></td>
    </tr> 
    <%
                }
            }
    %>    
    <tr>
        <td class id="list-left-last">&nbsp;</td>                                                                                                        
        <td class id="list-left-last">&nbsp;</td>
        <td class id="list-left-last">&nbsp;</td>
        <td class id="list-left-last">&nbsp;</td>
        <td class id="list-left-last">&nbsp;</td>
        <td class id="list-left-last">&nbsp;</td>
        <td class id="list-left-last">&nbsp;</td>
        <td class id="list-right-last">&nbsp;</td>
    </tr> 
    <tr height="20">
        <td colspan="7" class id="list-left-last-tot" align="center"><B>TOTAL</B></td>   
        <td class id="list-right-last-tot" align="right"><%=idr%><%=JSPFormater.formatNumber(totAllBudget, "#,###.##")%></td>
    </tr>
    <tr>
        <td colspan="8" height="30">&nbsp;</td>                                            
    </tr>
    <tr>
        <td colspan="8" align="center">
            <%
            out.print("<a href=\"../freport/module_rpt_print.jsp?activity_period_id=" + activityPeriodId + "&jenAkt=" + strSegment + "\" target='_blank'><img src=\"../images/print.gif\" name=\"delete\" height=\"22\" border=\"0\"></a></td>");
            %>
        </td>                                            
    </tr>
    <tr>
        <td colspan="8" height="10">&nbsp;</td>                                            
    </tr>
</table>
