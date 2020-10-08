/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.fms.report;

import java.io.File;
import java.io.FileWriter;
import java.io.PrintWriter;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.util.zip.GZIPOutputStream;
import java.io.Writer;
import java.util.Vector;
import java.net.URLEncoder;
import java.util.Date;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.project.util.JSPFormater;
import com.project.util.jsp.*;
import com.project.fms.ar.*;
import com.project.fms.master.*;
//import com.project.general.*;
import com.project.crm.project.*;
import com.project.I_Project;

import com.project.fms.activity.ActivityPeriod;
import com.project.fms.activity.DbActivityPeriod;
import com.project.fms.activity.DbModuleBudget;
import com.project.fms.activity.Module;
import com.project.fms.activity.ModuleBudget;
import com.project.fms.reportform.DbRptFormat;
import com.project.fms.reportform.RptFormat;
import com.project.general.Company;
import com.project.general.DbCompany;
import com.project.general.Customer;
import com.project.general.DbCustomer;
import com.project.general.Currency;
import com.project.general.DbCurrency;

import com.project.general.BankAccount;
import com.project.general.DbBankAccount;
import com.project.system.DbSystemProperty;
import java.util.StringTokenizer;

/**
 *
 * @author Roy Andika
 */
public class RptModuleXLS extends HttpServlet {

    /** Initializes the servlet.
     */
    public static String formatDate = "dd MMMM yyyy";

    public void init(ServletConfig config) throws ServletException {
        super.init(config);

    }

    /** Destroys the servlet.
     */
    public void destroy() {

    }

    String XMLSafe(String in) {
        return in;
    //return HTMLEncoder.encode(in);
    }

    /** Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     * 
     * Why not use a DOM? Because we want to be able to create the spreadsheet on-the-fly, without
     * having to use up a lot of memory before hand
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, java.io.IOException {

        System.out.println("---===| Excel Report |===---");
        response.setContentType("application/x-msexcel");

        Vector vModule = new Vector();
        long activityPeriodId = JSPRequestValue.requestLong(request, "activity_period_id");
        long jenisAct = JSPRequestValue.requestLong(request, "jenisAct");
        String strSegment = JSPRequestValue.requestStringExcTitikKoma(request, "segment");

        String[] condition;
        StringTokenizer strTokenizerCondition = new StringTokenizer(strSegment, ";");
        condition = new String[strTokenizerCondition.countTokens()];

        String namaJenisAktivity = "";

        if (jenisAct != 0) {
            try {
                SegmentDetail segmentDetail = DbSegmentDetail.fetchExc(jenisAct);
                namaJenisAktivity = segmentDetail.getName();
            } catch (Exception e) {

            }
        }

        String name_periode = "";
        try {
            ActivityPeriod periode = DbActivityPeriod.fetchExc(activityPeriodId);
            name_periode = periode.getName();
        } catch (Exception e) {
        }

        HttpSession session = request.getSession();
        if (session.getValue("MODULE_GEREJA") != null) {
            vModule = (Vector) session.getValue("MODULE_GEREJA");
        }

        String header = "";

        try {
            header = DbSystemProperty.getValueByName("HEADER_DATA_KERJA");
        } catch (Exception e) {
        }

        boolean gzip = false;

        OutputStream gzo;
        if (gzip) {
            response.setHeader("Content-Encoding", "gzip");
            gzo = new GZIPOutputStream(response.getOutputStream());
        } else {
            gzo = response.getOutputStream();
        }

        PrintWriter wb = new PrintWriter(new OutputStreamWriter(gzo, "UTF-8"));

        wb.println("    <?xml version=\"1.0\"?>");
        wb.println("    <?mso-application progid=\"Excel.Sheet\"?>");
        wb.println("    <Workbook xmlns=\"urn:schemas-microsoft-com:office:spreadsheet\"");
        wb.println("    xmlns:o=\"urn:schemas-microsoft-com:office:office\"");
        wb.println("    xmlns:x=\"urn:schemas-microsoft-com:office:excel\"");
        wb.println("    xmlns:ss=\"urn:schemas-microsoft-com:office:spreadsheet\"");
        wb.println("    xmlns:html=\"http://www.w3.org/TR/REC-html40\">");
        wb.println("    <DocumentProperties xmlns=\"urn:schemas-microsoft-com:office:office\">");
        wb.println("    <Author>IT</Author>");
        wb.println("    <LastAuthor>IT</LastAuthor>");
        wb.println("    <Created>2011-09-23T02:03:07Z</Created>");
        wb.println("    <Company>DEVELOPMENT</Company>");
        wb.println("    <Version>12.00</Version>");
        wb.println("    </DocumentProperties>");
        wb.println("    <ExcelWorkbook xmlns=\"urn:schemas-microsoft-com:office:excel\">");
        wb.println("    <WindowHeight>8385</WindowHeight>");
        wb.println("    <WindowWidth>18735</WindowWidth>");
        wb.println("    <WindowTopX>360</WindowTopX>");
        wb.println("    <WindowTopY>285</WindowTopY>");
        wb.println("    <ProtectStructure>False</ProtectStructure>");
        wb.println("    <ProtectWindows>False</ProtectWindows>");
        wb.println("    </ExcelWorkbook>");
        wb.println("    <Styles>");
        wb.println("    <Style ss:ID=\"Default\" ss:Name=\"Normal\">");
        wb.println("    <Alignment ss:Vertical=\"Bottom\"/>");
        wb.println("    <Borders/>");
        wb.println("    <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"/>");
        wb.println("    <Interior/>");
        wb.println("    <NumberFormat/>");
        wb.println("    <Protection/>");
        wb.println("    </Style>");
        wb.println("    <Style ss:ID=\"m76766720\">");
        wb.println("    <Alignment ss:Horizontal=\"Right\" ss:Vertical=\"Center\"/>");
        wb.println("    <Borders>");
        wb.println("    <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("    <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("    <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("    <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("    </Borders>");
        wb.println("    <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"");
        wb.println("    ss:Bold=\"1\"/>");
        wb.println("    </Style>");
        wb.println("    <Style ss:ID=\"s72\">");
        wb.println("    <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\"/>");
        wb.println("    <Borders>");
        wb.println("    <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("    <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("    <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("    </Borders>");
        wb.println("    <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"");
        wb.println("    ss:Bold=\"1\"/>");
        wb.println("    </Style>");
        wb.println("    <Style ss:ID=\"s73\">");
        wb.println("    <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Top\"/>");
        wb.println("    <Borders>");
        wb.println("    <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("    <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("    <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("    <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("    </Borders>");
        wb.println("    </Style>");
        wb.println("    <Style ss:ID=\"s76\">");
        wb.println("    <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Top\" ss:WrapText=\"1\"/>");
        wb.println("    <Borders>");
        wb.println("    <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("    <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("    <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("    <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("    </Borders>");
        wb.println("    </Style>");
        wb.println("    <Style ss:ID=\"s82\">");
        wb.println("    <Alignment ss:Horizontal=\"Right\" ss:Vertical=\"Top\"/>");
        wb.println("    <Borders>");
        wb.println("    <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("    <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("    <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("    <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("    </Borders>");
        wb.println("    <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"");
        wb.println("    ss:Bold=\"1\"/>");
        wb.println("    </Style>");
        wb.println("    </Styles>");
        wb.println("    <Worksheet ss:Name=\"Sheet1\">");
        wb.println("    <Table x:FullColumns=\"1\"");
        wb.println("    x:FullRows=\"1\" ss:DefaultRowHeight=\"15\">");
        wb.println("    <Column ss:AutoFitWidth=\"0\" ss:Width=\"41.25\"/>");
        wb.println("    <Column ss:AutoFitWidth=\"0\" ss:Width=\"188.25\"/>");
        wb.println("    <Column ss:AutoFitWidth=\"0\" ss:Width=\"156\"/>");
        wb.println("    <Column ss:AutoFitWidth=\"0\" ss:Width=\"99.75\"/>");
        wb.println("    <Column ss:AutoFitWidth=\"0\" ss:Width=\"98.25\"/>");
        wb.println("    <Column ss:AutoFitWidth=\"0\" ss:Width=\"90\"/>");
        wb.println("    <Column ss:AutoFitWidth=\"0\" ss:Width=\"117\"/>");
        wb.println("    <Column ss:AutoFitWidth=\"0\" ss:Width=\"133.5\"/>");
        wb.println("    <Row ss:Index=\"2\">");
        wb.println("    <Cell><Data ss:Type=\"String\">" + header.toUpperCase() + " " + name_periode.toUpperCase() + "</Data></Cell>");
        wb.println("    </Row>");
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
            wb.println("    <Row>");
            wb.println("    <Cell><Data ss:Type=\"String\">" + nama + "  :  " + value + "</Data></Cell>");
            wb.println("    </Row>");
        }

        wb.println("    <Row>");
        wb.println("    <Cell ss:StyleID=\"s72\"><Data ss:Type=\"String\">NO</Data></Cell>");
        wb.println("    <Cell ss:StyleID=\"s72\"><Data ss:Type=\"String\">KEGIATAN</Data></Cell>");
        wb.println("    <Cell ss:StyleID=\"s72\"><Data ss:Type=\"String\">SASARAN</Data></Cell>");
        wb.println("    <Cell ss:StyleID=\"s72\"><Data ss:Type=\"String\">HARI</Data></Cell>");
        wb.println("    <Cell ss:StyleID=\"s72\"><Data ss:Type=\"String\">TANGGAL</Data></Cell>");
        wb.println("    <Cell ss:StyleID=\"s72\"><Data ss:Type=\"String\">WAKTU</Data></Cell>");
        wb.println("    <Cell ss:StyleID=\"s72\"><Data ss:Type=\"String\">KETERANGAN</Data></Cell>");
        wb.println("    <Cell ss:StyleID=\"s72\"><Data ss:Type=\"String\">ANGGARAN</Data></Cell>");
        wb.println("    </Row>");
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
                int page = i + 1;
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
                            mdBudget = mdBudget + "&#10;";
                        }
                        mdBudget = mdBudget + mb.getDescription() + " = " + currency + " " + JSPFormater.formatNumber(mb.getAmount(), "#,###.##");

                    }

                    mdBudget = mdBudget + "&#10;&#10; TOTAL = " + idr + "" + JSPFormater.formatNumber(totalBud, "#,###.##");

                }

                totAllBudget = totAllBudget + totalBud;

                //Tokenizer untuk Description
                String description = "";
                StringTokenizer strTokenizerDescription = new StringTokenizer(module.getDescription(), ";");

                int countDesc = 0;

                while (strTokenizerDescription.hasMoreTokens()) {

                    if (countDesc != 0) {
                        description = description + "&#10;";
                    }

                    description = description + strTokenizerDescription.nextToken();
                    countDesc++;
                }
                //=== END Tokenizer untuk Description ===                
                
                //Tokenizer untuk Sasaran
                String outputDeliver = "";
                StringTokenizer strTokenizerOutputDeliver = new StringTokenizer(module.getOutputDeliver(), ";");

                int countOut = 0;

                while (strTokenizerOutputDeliver.hasMoreTokens()) {

                    if (countOut != 0) {
                        outputDeliver = outputDeliver + "&#10;";
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
                        actDays = actDays + "&#10;";
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
                        date = date + "&#10;";
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
                        time = time + "&#10;";
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
                        note = note + "&#10;";
                    }

                    note = note + strTokenizerNote.nextToken();
                    countNote++;
                }
                //=== END Tokenizer untuk keterangan
                String kegiatan = module.getCode().length() > 0 ? module.getCode()+" - "+module.getDescription() : module.getDescription();
                wb.println("    <Row ss:Height=\"20\">");
                wb.println("    <Cell ss:StyleID=\"s73\"><Data ss:Type=\"Number\">" + page + "</Data></Cell>");
                wb.println("    <Cell ss:StyleID=\"s76\"><Data ss:Type=\"String\">" + kegiatan + "</Data></Cell>");
                wb.println("    <Cell ss:StyleID=\"s76\"><Data ss:Type=\"String\">" + outputDeliver + "</Data></Cell>");
                wb.println("    <Cell ss:StyleID=\"s76\"><Data ss:Type=\"String\">" + actDays + "</Data></Cell>");
                wb.println("    <Cell ss:StyleID=\"s76\"><Data ss:Type=\"String\">" + date + "</Data></Cell>");
                wb.println("    <Cell ss:StyleID=\"s76\"><Data ss:Type=\"String\">" + time + "</Data></Cell>");
                wb.println("    <Cell ss:StyleID=\"s76\"><Data ss:Type=\"String\">" + note + "</Data></Cell>");
                wb.println("    <Cell ss:StyleID=\"s76\"><Data ss:Type=\"String\">" + mdBudget + "</Data></Cell>");
                wb.println("    </Row>");

            }
        }

        wb.println("    <Row>");
        wb.println("    <Cell ss:MergeAcross=\"6\" ss:StyleID=\"m76766720\"><Data ss:Type=\"String\">TOTAL</Data></Cell>");
        wb.println("    <Cell ss:StyleID=\"s82\"><Data ss:Type=\"String\">" + idr + " " + JSPFormater.formatNumber(totAllBudget, "#,###.##") + "</Data></Cell>");
        wb.println("    </Row>");
        wb.println("    </Table>");
        wb.println("    <WorksheetOptions xmlns=\"urn:schemas-microsoft-com:office:excel\">");
        wb.println("    <PageSetup>");
        wb.println("    <Header x:Margin=\"0.3\"/>");
        wb.println("    <Footer x:Margin=\"0.3\"/>");
        wb.println("    <PageMargins x:Bottom=\"0.75\" x:Left=\"0.7\" x:Right=\"0.7\" x:Top=\"0.75\"/>");
        wb.println("    </PageSetup>");
        wb.println("    <Selected/>");
        wb.println("    <Panes>");
        wb.println("    <Pane>");
        wb.println("    <Number>3</Number>");
        wb.println("    <ActiveRow>12</ActiveRow>");
        wb.println("    <ActiveCol>6</ActiveCol>");
        wb.println("    </Pane>");
        wb.println("    </Panes>");
        wb.println("    <ProtectObjects>False</ProtectObjects>");
        wb.println("    <ProtectScenarios>False</ProtectScenarios>");
        wb.println("    </WorksheetOptions>");
        wb.println("    </Worksheet>");
        wb.println("    <Worksheet ss:Name=\"Sheet2\">");
        wb.println("    <Table ss:ExpandedColumnCount=\"1\" ss:ExpandedRowCount=\"1\" x:FullColumns=\"1\"");
        wb.println("    x:FullRows=\"1\" ss:DefaultRowHeight=\"15\">");
        wb.println("    </Table>");
        wb.println("    <WorksheetOptions xmlns=\"urn:schemas-microsoft-com:office:excel\">");
        wb.println("    <PageSetup>");
        wb.println("    <Header x:Margin=\"0.3\"/>");
        wb.println("    <Footer x:Margin=\"0.3\"/>");
        wb.println("    <PageMargins x:Bottom=\"0.75\" x:Left=\"0.7\" x:Right=\"0.7\" x:Top=\"0.75\"/>");
        wb.println("    </PageSetup>");
        wb.println("    <ProtectObjects>False</ProtectObjects>");
        wb.println("    <ProtectScenarios>False</ProtectScenarios>");
        wb.println("    </WorksheetOptions>");
        wb.println("    </Worksheet>");
        wb.println("    <Worksheet ss:Name=\"Sheet3\">");
        wb.println("    <Table ss:ExpandedColumnCount=\"1\" ss:ExpandedRowCount=\"1\" x:FullColumns=\"1\"");
        wb.println("    x:FullRows=\"1\" ss:DefaultRowHeight=\"15\">");
        wb.println("    </Table>");
        wb.println("    <WorksheetOptions xmlns=\"urn:schemas-microsoft-com:office:excel\">");
        wb.println("    <PageSetup>");
        wb.println("    <Header x:Margin=\"0.3\"/>");
        wb.println("    <Footer x:Margin=\"0.3\"/>");
        wb.println("    <PageMargins x:Bottom=\"0.75\" x:Left=\"0.7\" x:Right=\"0.7\" x:Top=\"0.75\"/>");
        wb.println("    </PageSetup>");
        wb.println("    <ProtectObjects>False</ProtectObjects>");
        wb.println("    <ProtectScenarios>False</ProtectScenarios>");
        wb.println("    </WorksheetOptions>");
        wb.println("    </Worksheet>");
        wb.println("    </Workbook>");

        wb.flush();
    }

    /** Handles the HTTP <code>GET</code> method.
     * @param request servlet request
     * @param response servlet response
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, java.io.IOException {
        processRequest(request, response);
    }

    /** Handles the HTTP <code>POST</code> method.
     * @param request servlet request
     * @param response servlet response
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, java.io.IOException {
        processRequest(request, response);
    }

    /** Returns a short description of the servlet.
     */
    public String getServletInfo() {
        return "Short description";
    }

    public static void main(String[] arg) {
        try {
            String str = "";

            System.out.println(URLEncoder.encode(str, "UTF-8"));
        } catch (Exception e) {
            System.out.println(e.toString());
        }
    }
}
