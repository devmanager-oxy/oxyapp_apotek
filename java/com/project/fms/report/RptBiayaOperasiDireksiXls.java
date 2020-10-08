package com.project.fms.report;

import com.project.general.Company;
import com.project.general.DbCompany;
import com.project.util.JSPFormater;
import com.project.util.jsp.JSPRequestValue;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.net.URLEncoder;
import java.util.Vector;
import java.util.zip.GZIPOutputStream;
import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author gwawan
 */
public class RptBiayaOperasiDireksiXls extends HttpServlet {

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

        // Load User Login
        String loginId = JSPRequestValue.requestString(request, "oid");
        System.out.println("UserId : " + loginId);

        //Load Title Header
        String strTitle = JSPRequestValue.requestString(request, "reportexpensetitle");

        // Load Company
        Company company = DbCompany.getCompany();
        long oidCompany = company.getOID();
        System.out.println("oidCompany : " + oidCompany);

        //Load Invoice Item
        Vector vectorList = new Vector(1, 1);
        try {
            HttpSession session = request.getSession();
            vectorList = (Vector) session.getValue("BIAYAOPERASIDIREKSI");
        } catch (Exception e) {
            System.out.println(e);
        }

        //Count total Column
        int colSpan = 0;
        boolean gzip = false;
        OutputStream objOutputStream;

        if (gzip) {
            response.setHeader("Content-Encoding", "gzip");
            objOutputStream = new GZIPOutputStream(response.getOutputStream());
        } else {
            objOutputStream = response.getOutputStream();
        }

        PrintWriter wb = new PrintWriter(new OutputStreamWriter(objOutputStream, "UTF-8"));

        wb.println("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
        wb.println("<?mso-application progid=\"Excel.Sheet\"?>");

        wb.println("<Workbook xmlns=\"urn:schemas-microsoft-com:office:spreadsheet\"");
        wb.println(" xmlns:o=\"urn:schemas-microsoft-com:office:office\"");
        wb.println(" xmlns:x=\"urn:schemas-microsoft-com:office:excel\"");
        wb.println(" xmlns:ss=\"urn:schemas-microsoft-com:office:spreadsheet\"");
        wb.println(" xmlns:html=\"http://www.w3.org/TR/REC-html40\">");

        wb.println(" <DocumentProperties xmlns=\"urn:schemas-microsoft-com:office:office\">");
        wb.println("  <Version>11.5606</Version>");
        wb.println(" </DocumentProperties>");

        wb.println(" <OfficeDocumentSettings xmlns=\"urn:schemas-microsoft-com:office:office\">");
        wb.println("  <Colors>");
        wb.println("   <Color>");
        wb.println("    <Index>16</Index>");
        wb.println("    <RGB>#C6DCBE</RGB>");
        wb.println("   </Color>");
        wb.println("   <Color>");
        wb.println("    <Index>24</Index>");
        wb.println("    <RGB>#6CA35A</RGB>");
        wb.println("   </Color>");
        wb.println("  </Colors>");
        wb.println(" </OfficeDocumentSettings>");

        wb.println(" <ExcelWorkbook xmlns=\"urn:schemas-microsoft-com:office:excel\">");
        wb.println("  <WindowHeight>10005</WindowHeight>");
        wb.println("  <WindowWidth>10005</WindowWidth>");
        wb.println("  <WindowTopX>120</WindowTopX>");
        wb.println("  <WindowTopY>135</WindowTopY>");
        wb.println("  <ProtectStructure>False</ProtectStructure>");
        wb.println("  <ProtectWindows>False</ProtectWindows>");
        wb.println(" </ExcelWorkbook>");

        /** Styles */
        wb.println("<Styles>");

        wb.println("  <Style ss:ID=\"s1\">");
        wb.println("   <Alignment ss:Vertical=\"Bottom\" ss:WrapText=\"1\"/>");
        wb.println("  </Style>");

        wb.println("  <Style ss:ID=\"s2\">");
        wb.println("   <Alignment ss:Vertical=\"Bottom\" ss:WrapText=\"1\"/>");
        wb.println("   <Interior/>");
        wb.println("  </Style>");

        wb.println("  <Style ss:ID=\"s3\">");
        wb.println("   <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("   <Borders/>");
        wb.println("   <Font ss:FontName=\"Times New Roman\" x:Family=\"Roman\" ss:Size=\"12\" ss:Bold=\"1\"/>");
        wb.println("   <Protection/>");
        wb.println("  </Style>");

        wb.println("  <Style ss:ID=\"s4\">");
        wb.println("   <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("   <Borders>");
        wb.println("    <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("   </Borders>");
        wb.println("   <Font ss:FontName=\"Times New Roman\" x:Family=\"Roman\" ss:Size=\"12\" ss:Bold=\"1\"/>");
        wb.println("   <Protection/>");
        wb.println("  </Style>");

        wb.println("  <Style ss:ID=\"s5\">");
        wb.println("   <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\" ss:WrapText=\"1\"/>");
        wb.println("   <Borders>");
        wb.println("    <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("    <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("    <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("    <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("   </Borders>");
        wb.println("   <Font ss:FontName=\"Times New Roman\" x:Family=\"Roman\" ss:Size=\"12\" ss:Bold=\"1\"/>");
        wb.println("   <Interior/>");
        wb.println("   <NumberFormat/>");
        wb.println("   <Protection/>");
        wb.println("  </Style>");

        wb.println("  <Style ss:ID=\"s6\">");
        wb.println("   <Alignment ss:Horizontal=\"Right\" ss:Vertical=\"Bottom\"/>");
        wb.println("   <Borders>");
        wb.println("    <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("    <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("    <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("    <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("   </Borders>");
        wb.println("   <Font ss:FontName=\"Times New Roman\" x:Family=\"Roman\"/>");
        wb.println("   <Protection/>");
        wb.println("  </Style>");

        wb.println("  <Style ss:ID=\"s7\">");
        wb.println("   <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("   <Borders>");
        wb.println("    <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("    <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("    <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("    <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("   </Borders>");
        wb.println("   <Font ss:FontName=\"Times New Roman\" x:Family=\"Roman\" ss:Size=\"12\" ss:Bold=\"1\"/>");
        wb.println("  </Style>");

        wb.println("  <Style ss:ID=\"s8\">");
        wb.println("   <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\" ss:WrapText=\"1\"/>");
        wb.println("   <Borders>");
        wb.println("    <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("    <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("    <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("    <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("   </Borders>");
        wb.println("   <Font ss:FontName=\"Times New Roman\" x:Family=\"Roman\" ss:Size=\"12\" ss:Bold=\"1\"/>");
        wb.println("   <Interior/>");
        wb.println("  </Style>");

        wb.println("  <Style ss:ID=\"s9\">");
        wb.println("   <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\" ss:WrapText=\"1\"/>");
        wb.println("   <Borders>");
        wb.println("    <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("    <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("    <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("    <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("   </Borders>");
        wb.println("   <Font ss:FontName=\"Times New Roman\" x:Family=\"Roman\" ss:Size=\"12\" ss:Bold=\"1\"/>");
        wb.println("  </Style>");

        wb.println("  <Style ss:ID=\"s10\">");
        wb.println("   <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Bottom\"/>");
        wb.println("   <Borders>");
        wb.println("    <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("    <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("   </Borders>");
        wb.println("   <Font ss:FontName=\"Times New Roman\" x:Family=\"Roman\"/>");
        wb.println("   <Protection/>");
        wb.println("  </Style>");

        wb.println("  <Style ss:ID=\"s11\">");
        wb.println("   <Alignment ss:Horizontal=\"Right\" ss:Vertical=\"Bottom\"/>");
        wb.println("   <Borders>");
        wb.println("    <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("    <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("   </Borders>");
        wb.println("   <Font ss:FontName=\"Times New Roman\" x:Family=\"Roman\"/>");
        wb.println("   <Protection/>");
        wb.println("  </Style>");

        wb.println("</Styles>");
        /** End Styles */
        wb.println(" <Worksheet ss:Name=\"Sheet1\">");
        wb.println("  <Table ss:ExpandedColumnCount=\"5\" ss:ExpandedRowCount=\"41\" x:FullColumns=\"1\"");
        wb.println("   x:FullRows=\"1\">");
        wb.println("   <Column ss:Width=\"159\"/>");
        wb.println("   <Column ss:StyleID=\"s2\" ss:AutoFitWidth=\"0\" ss:Width=\"89.25\"/>");
        wb.println("   <Column ss:StyleID=\"s1\" ss:AutoFitWidth=\"0\" ss:Width=\"89.25\" ss:Span=\"2\"/>");

        wb.println("   <Row ss:Height=\"15.75\">");
        wb.println("    <Cell ss:MergeAcross=\"4\" ss:StyleID=\"s3\"><Data ss:Type=\"String\" x:Ticked=\"1\">BIAYA OPERASI  DIREKSI</Data></Cell>");
        wb.println("   </Row>");

        wb.println("   <Row ss:Height=\"15.75\">");
        wb.println("    <Cell ss:MergeAcross=\"4\" ss:StyleID=\"s4\"><Data ss:Type=\"String\">S/D DESEMBER 2010</Data></Cell>");
        wb.println("   </Row>");

        wb.println("   <Row ss:AutoFitHeight=\"0\" ss:Height=\"33.75\">");
        wb.println("    <Cell ss:StyleID=\"s7\"><Data ss:Type=\"String\">URAIAN</Data></Cell>");
        wb.println("    <Cell ss:StyleID=\"s8\"><Data ss:Type=\"String\">TOTAL</Data></Cell>");
        wb.println("    <Cell ss:StyleID=\"s9\"><Data ss:Type=\"String\">DIRUT masuk ke UMUM</Data></Cell>");
        wb.println("    <Cell ss:StyleID=\"s9\"><Data ss:Type=\"String\">DIR OP masuk ke PERENC.</Data></Cell>");
        wb.println("    <Cell ss:StyleID=\"s9\"><Data ss:Type=\"String\">DIR UK masuk ke KEUANGAN</Data></Cell>");
        wb.println("   </Row>");

        RptBiayaOperasiDireksi sesReport = new RptBiayaOperasiDireksi();
        String space = "";
        double totalBiaya = 0;
        double totalUmum = 0;
        double totalPerencanaan = 0;
        double totalKeuangan = 0;

        for (int i = 0; i < vectorList.size(); i++) {
            sesReport = (RptBiayaOperasiDireksi) vectorList.get(i);
            space = switchLevel(sesReport.getCoaLevel());

            wb.println("   <Row ss:Height=\"15\">");
            wb.println("    <Cell ss:StyleID=\"s10\"><Data ss:Type=\"String\">" + getContentDisplay(sesReport.getCoaStatus(), space + sesReport.getCoaCode() + " - " + sesReport.getCoaName()) + "</Data></Cell>");
            wb.println("    <Cell ss:StyleID=\"s11\"><Data ss:Type=\"String\">" + getContentDisplay(sesReport.getCoaStatus(), strDisplay(sesReport.getTotalBiaya(), sesReport.getCoaStatus())) + "</Data></Cell>");
            wb.println("    <Cell ss:StyleID=\"s11\"><Data ss:Type=\"String\">" + getContentDisplay(sesReport.getCoaStatus(), strDisplay(sesReport.getBiayaUmum(), sesReport.getCoaStatus())) + "</Data></Cell>");
            wb.println("    <Cell ss:StyleID=\"s11\"><Data ss:Type=\"String\">" + getContentDisplay(sesReport.getCoaStatus(), strDisplay(sesReport.getBiayaPerencanaan(), sesReport.getCoaStatus())) + "</Data></Cell>");
            wb.println("    <Cell ss:StyleID=\"s11\"><Data ss:Type=\"String\">" + getContentDisplay(sesReport.getCoaStatus(), strDisplay(sesReport.getBiayaKeuangan(), sesReport.getCoaStatus())) + "</Data></Cell>");
            wb.println("   </Row>");

            totalBiaya += sesReport.getTotalBiaya();
            totalUmum += sesReport.getBiayaUmum();
            totalPerencanaan += sesReport.getBiayaPerencanaan();
            totalKeuangan += sesReport.getBiayaKeuangan();
        }

        wb.println("   <Row ss:Height=\"15\">");
        wb.println("    <Cell ss:StyleID=\"s5\"><Data ss:Type=\"String\">TOTAL</Data></Cell>");
        wb.println("    <Cell ss:StyleID=\"s6\"><Data ss:Type=\"String\">" + strDisplay(totalBiaya, "") + "</Data></Cell>");
        wb.println("    <Cell ss:StyleID=\"s6\"><Data ss:Type=\"String\">" + strDisplay(totalUmum, "") + "</Data></Cell>");
        wb.println("    <Cell ss:StyleID=\"s6\"><Data ss:Type=\"String\">" + strDisplay(totalPerencanaan, "") + "</Data></Cell>");
        wb.println("    <Cell ss:StyleID=\"s6\"><Data ss:Type=\"String\">" + strDisplay(totalKeuangan, "") + "</Data></Cell>");
        wb.println("   </Row>");

        wb.println("  </Table>");
        wb.println("  <WorksheetOptions xmlns=\"urn:schemas-microsoft-com:office:excel\">");
        wb.println("   <Selected/>");
        wb.println("   <Panes>");
        wb.println("    <Pane>");
        wb.println("     <Number>3</Number>");
        wb.println("     <ActiveRow>47</ActiveRow>");
        wb.println("     <ActiveCol>9</ActiveCol>");
        wb.println("    </Pane>");
        wb.println("   </Panes>");
        wb.println("   <ProtectObjects>False</ProtectObjects>");
        wb.println("   <ProtectScenarios>False</ProtectScenarios>");
        wb.println("  </WorksheetOptions>");
        wb.println(" </Worksheet>");
        wb.println("</Workbook>");

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
            String str = "fungsi hasil copas hehe... :p";
            System.out.println(URLEncoder.encode(str, "UTF-8"));
        } catch (Exception e) {
            System.out.println(e.toString());
        }
    }

    public String switchLevel(int level) {
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

    public String strDisplay(double amount, String coaStatus) {
        String displayStr = "";
        if (amount < 0) {
            displayStr = "(" + JSPFormater.formatNumber(amount * -1, "#,###") + ")";
        } else if (amount > 0) {
            displayStr = JSPFormater.formatNumber(amount, "#,###");
        } else if (amount == 0) {
            displayStr = "";
        }
        if (coaStatus.equals("HEADER")) {
            displayStr = "<b>" + displayStr + "</b>";
        }
        return displayStr;
    }

    public String getContentDisplay(String stt, String str) {
        String result = "";
        if (stt.equals("HEADER")) {
            result = "<b>";
        }
        result = result + str;
        if (stt.equals("HEADER")) {
            result = result + "</b>";
        }
        return result;
    }
}
