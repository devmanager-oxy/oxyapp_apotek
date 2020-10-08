/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.fms.report;

import java.io.PrintWriter;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.util.zip.GZIPOutputStream;
import java.util.Vector;
import java.net.URLEncoder;
import java.util.Date;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.project.util.JSPFormater;
import com.project.util.jsp.*;
import com.project.fms.ar.*;
import com.project.fms.master.*;
import com.project.crm.project.*;
import com.project.fms.session.ReportKonsumen;
import com.project.general.Company;
import com.project.general.DbCompany;

/**
 *
 * @author Roy Andika
 */
public class RptReceivableMemberXLS extends HttpServlet {

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

        response.setContentType("application/x-msexcel");
        long compId = JSPRequestValue.requestLong(request, "comp_id");
        int lang = JSPRequestValue.requestInt(request, "lang");
        String formNumbComp = "";

        final int LANG_ID = 2;
        Vector vectorList = new Vector(1, 1);
        try {
            HttpSession session = request.getSession();
            vectorList = (Vector) session.getValue("MEMBER_REPORT");
            formNumbComp = (String)session.getValue("MEMBER_REPORT_FORMAT");            
        } catch (Exception e) {
            System.out.println(e);
        }

        Company company = new Company();
        try {
            company = DbCompany.fetchExc(compId);
        } catch (Exception e) {
        }

        String[] langAR = {"Customer", "Status", "Code", "Payment", "Current", //0-4
            "Searching Form :", "Click serach button to searching the data", "To", "Ignore", "Name", "Invoice Number", "Date", "Due Date", "Credit Total"}; //5-13

        if (lang == LANG_ID) {
            String[] langID = {"Konsumen", "Status", "Kode", "Pembayaran", "Terkini", //0-4
                "Form Pencarian :", "Klik tombol search untuk melakukan pencarian", "Sampai", "Abaikan", "Nama", "Nomor Invoice", "Tanggal", "Jatuh Tempo", "Total Kredit"}; //5-13
            langAR = langID;
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

        wb.println("      <?xml version=\"1.0\"?>");
        wb.println("      <?mso-application progid=\"Excel.Sheet\"?>");
        wb.println("      <Workbook xmlns=\"urn:schemas-microsoft-com:office:spreadsheet\"");
        wb.println("      xmlns:o=\"urn:schemas-microsoft-com:office:office\"");
        wb.println("      xmlns:x=\"urn:schemas-microsoft-com:office:excel\"");
        wb.println("      xmlns:ss=\"urn:schemas-microsoft-com:office:spreadsheet\"");
        wb.println("      xmlns:html=\"http://www.w3.org/TR/REC-html40\">");
        wb.println("      <DocumentProperties xmlns=\"urn:schemas-microsoft-com:office:office\">");
        wb.println("      <Author>PNCI</Author>");
        wb.println("      <LastAuthor>PNCI</LastAuthor>");
        wb.println("      <Created>2013-12-12T05:40:42Z</Created>");
        wb.println("      <Company>PNCI</Company>");
        wb.println("      <Version>12.00</Version>");
        wb.println("      </DocumentProperties>");
        wb.println("      <ExcelWorkbook xmlns=\"urn:schemas-microsoft-com:office:excel\">");
        wb.println("      <WindowHeight>8895</WindowHeight>");
        wb.println("      <WindowWidth>18975</WindowWidth>");
        wb.println("      <WindowTopX>120</WindowTopX>");
        wb.println("      <WindowTopY>120</WindowTopY>");
        wb.println("      <ProtectStructure>False</ProtectStructure>");
        wb.println("      <ProtectWindows>False</ProtectWindows>");
        wb.println("      </ExcelWorkbook>");
        wb.println("      <Styles>");
        wb.println("      <Style ss:ID=\"Default\" ss:Name=\"Normal\">");
        wb.println("      <Alignment ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders/>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"/>");
        wb.println("      <Interior/>");
        wb.println("      <NumberFormat/>");
        wb.println("      <Protection/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"m41953756\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s72\">");
        wb.println("      <Alignment ss:Vertical=\"Bottom\"/>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"14\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s75\">");
        wb.println("      <Alignment ss:Vertical=\"Bottom\"/>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"12\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s76\">");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s80\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s83\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <NumberFormat ss:Format=\"@\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s84\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s101\">");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <NumberFormat ss:Format=\"Standard\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s102\">");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      <NumberFormat ss:Format=\"Standard\"/>");
        wb.println("      </Style>");
        wb.println("      </Styles>");
        wb.println("      <Worksheet ss:Name=\"Sheet1\">");
        wb.println("      <Table >");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"32.25\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"120.75\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"111.75\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"78\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"89.25\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"93.75\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"88.5\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"92.25\"/>");
        wb.println("      <Row ss:Index=\"2\" ss:Height=\"18.75\">");
        wb.println("      <Cell ss:MergeAcross=\"7\" ss:StyleID=\"s72\"><Data ss:Type=\"String\">" + company.getName().toUpperCase() + "</Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row ss:Height=\"15.75\">");
        wb.println("      <Cell ss:MergeAcross=\"7\" ss:StyleID=\"s75\"><Data ss:Type=\"String\">" + company.getAddress().toUpperCase() + "</Data></Cell>");
        wb.println("      </Row>");

        wb.println("      <Row ss:Index=\"5\">");
        wb.println("      <Cell ss:StyleID=\"s80\"><Data ss:Type=\"String\">No</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s80\"><Data ss:Type=\"String\">" + langAR[9] + "</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s80\"><Data ss:Type=\"String\">" + langAR[10] + "</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s80\"><Data ss:Type=\"String\">" + langAR[11] + "</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s80\"><Data ss:Type=\"String\">" + langAR[12] + "</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s80\"><Data ss:Type=\"String\">" + langAR[13] + "</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s80\"><Data ss:Type=\"String\">" + langAR[3] + "</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s80\"><Data ss:Type=\"String\">" + langAR[4] + "</Data></Cell>");
        wb.println("      </Row>");

        if (vectorList != null && vectorList.size() > 0) {
            int sequence = 1;
            long check = 0;
            double subTotal = 0;
            double subPaid = 0;
            double subTerkini = 0;

            double grandTotal = 0;
            double grandPaid = 0;
            double grandTerkini = 0;

            for (int i = 0; i < vectorList.size(); i++) {

                ReportKonsumen rk = (ReportKonsumen) vectorList.get(i);

                long customerId = rk.getCustomerId();
                String name = rk.getName();
                String invoiceNumber = rk.getInvoiceNumber();
                Date tanggal = rk.getTanggal();
                Date dueDate = rk.getDueDate();
                double total = rk.getTotCredit();
                double totalPaid = rk.getTotalPaid();
                double balance = 0;

                if (sequence != 1 && check != customerId) {
                    wb.println("      <Row>");
                    wb.println("      <Cell ss:StyleID=\"s76\"><Data ss:Type=\"String\">  </Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s76\"/>");
                    wb.println("      <Cell ss:StyleID=\"s76\"/>");
                    wb.println("      <Cell ss:StyleID=\"s76\"/>");
                    wb.println("      <Cell ss:StyleID=\"s76\"/>");
                    wb.println("      <Cell ss:StyleID=\"s101\"><Data ss:Type=\"Number\">" + subTotal + "</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s101\"><Data ss:Type=\"Number\">" + subPaid + "</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s101\"><Data ss:Type=\"Number\">" + subTerkini + "</Data></Cell>");
                    wb.println("      </Row>");
                    subTotal = 0;
                    subPaid = 0;
                    subTerkini = 0;
                }

                if (formNumbComp.equals("#,##0")) {
                    total = Double.parseDouble("" + JSPFormater.formatNumber(total, "###0"));
                    totalPaid = Double.parseDouble("" + JSPFormater.formatNumber(totalPaid, "###0"));                    
                    subTotal = subTotal + Double.parseDouble("" + JSPFormater.formatNumber(total, "###0"));
                    grandTotal = grandTotal + Double.parseDouble("" + JSPFormater.formatNumber(total, "###0"));
                    subPaid = subPaid + Double.parseDouble("" + JSPFormater.formatNumber(totalPaid, "###0"));
                    grandPaid = grandPaid + Double.parseDouble("" + JSPFormater.formatNumber(totalPaid, "###0"));
                    balance = Double.parseDouble("" + JSPFormater.formatNumber(total, "###0")) - Double.parseDouble("" + JSPFormater.formatNumber(totalPaid, "###0"));
                    grandTerkini = grandTerkini + balance;
                    subTerkini = subTerkini + balance;
                } else {
                    subTotal = subTotal + total;
                    grandTotal = grandTotal + total;
                    subPaid = subPaid + totalPaid;
                    grandPaid = grandPaid + totalPaid;
                    balance = total - totalPaid;
                    subTerkini = subTerkini + balance;
                    grandTerkini = grandTerkini + balance;
                }

                wb.println("      <Row>");
                if (check != customerId) {
                    wb.println("      <Cell ss:StyleID=\"s84\"><Data ss:Type=\"Number\">" + sequence + ".</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s76\"><Data ss:Type=\"String\">" + name + "</Data></Cell>");
                    sequence++;
                } else {
                    wb.println("      <Cell ss:StyleID=\"s84\"><Data ss:Type=\"String\"></Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s76\"><Data ss:Type=\"String\"></Data></Cell>");
                }
                wb.println("      <Cell ss:StyleID=\"s76\"><Data ss:Type=\"String\">" + invoiceNumber + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s83\"><Data ss:Type=\"String\">" + JSPFormater.formatDate(tanggal, "dd MMM yyy") + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s83\"><Data ss:Type=\"String\">" + JSPFormater.formatDate(dueDate, "dd MMM yyy") + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s101\"><Data ss:Type=\"Number\">" + total + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s101\"><Data ss:Type=\"Number\">" + totalPaid + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s101\"><Data ss:Type=\"Number\">" + balance + "</Data></Cell>");
                wb.println("      </Row>");
                check = customerId;
            }
            wb.println("      <Row>");
            wb.println("      <Cell ss:StyleID=\"s76\"><Data ss:Type=\"String\">  </Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s76\"/>");
            wb.println("      <Cell ss:StyleID=\"s76\"/>");
            wb.println("      <Cell ss:StyleID=\"s76\"/>");
            wb.println("      <Cell ss:StyleID=\"s76\"/>");
            wb.println("      <Cell ss:StyleID=\"s101\"><Data ss:Type=\"Number\">" + subTotal + "</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s101\"><Data ss:Type=\"Number\">" + subPaid + "</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s101\"><Data ss:Type=\"Number\">" + subTerkini + "</Data></Cell>");
            wb.println("      </Row>");

            wb.println("      <Row >");
            wb.println("      <Cell ss:MergeAcross=\"4\" ss:StyleID=\"m41953756\"><Data ss:Type=\"String\">GRAND TOTAL</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s102\"><Data ss:Type=\"Number\">" + grandTotal + "</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s102\"><Data ss:Type=\"Number\">" + grandPaid + "</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s102\"><Data ss:Type=\"Number\">" + grandTerkini + "</Data></Cell>");
            wb.println("      </Row>");
        }

        wb.println("      </Table>");
        wb.println("      <WorksheetOptions xmlns=\"urn:schemas-microsoft-com:office:excel\">");
        wb.println("      <PageSetup>");
        wb.println("      <Header x:Margin=\"0.3\"/>");
        wb.println("      <Footer x:Margin=\"0.3\"/>");
        wb.println("      <PageMargins x:Bottom=\"0.75\" x:Left=\"0.7\" x:Right=\"0.7\" x:Top=\"0.75\"/>");
        wb.println("      </PageSetup>");
        wb.println("      <Print>");
        wb.println("      <ValidPrinterInfo/>");
        wb.println("      <HorizontalResolution>300</HorizontalResolution>");
        wb.println("      <VerticalResolution>300</VerticalResolution>");
        wb.println("      </Print>");
        wb.println("      <Selected/>");
        wb.println("      <Panes>");
        wb.println("      <Pane>");
        wb.println("      <Number>3</Number>");
        wb.println("      <ActiveRow>2</ActiveRow>");
        wb.println("      <RangeSelection>R3C1:R3C8</RangeSelection>");
        wb.println("      </Pane>");
        wb.println("      </Panes>");
        wb.println("      <ProtectObjects>False</ProtectObjects>");
        wb.println("      <ProtectScenarios>False</ProtectScenarios>");
        wb.println("      </WorksheetOptions>");
        wb.println("      </Worksheet>");
        wb.println("      <Worksheet ss:Name=\"Sheet2\">");
        wb.println("      <Table >");
        wb.println("      </Table>");
        wb.println("      <WorksheetOptions xmlns=\"urn:schemas-microsoft-com:office:excel\">");
        wb.println("      <PageSetup>");
        wb.println("      <Header x:Margin=\"0.3\"/>");
        wb.println("      <Footer x:Margin=\"0.3\"/>");
        wb.println("      <PageMargins x:Bottom=\"0.75\" x:Left=\"0.7\" x:Right=\"0.7\" x:Top=\"0.75\"/>");
        wb.println("      </PageSetup>");
        wb.println("      <ProtectObjects>False</ProtectObjects>");
        wb.println("      <ProtectScenarios>False</ProtectScenarios>");
        wb.println("      </WorksheetOptions>");
        wb.println("      </Worksheet>");
        wb.println("      <Worksheet ss:Name=\"Sheet3\">");
        wb.println("      <Table ss:ExpandedColumnCount=\"1\" ss:ExpandedRowCount=\"1\" x:FullColumns=\"1\"");
        wb.println("      x:FullRows=\"1\" ss:DefaultRowHeight=\"15\">");
        wb.println("      </Table>");
        wb.println("      <WorksheetOptions xmlns=\"urn:schemas-microsoft-com:office:excel\">");
        wb.println("      <PageSetup>");
        wb.println("      <Header x:Margin=\"0.3\"/>");
        wb.println("      <Footer x:Margin=\"0.3\"/>");
        wb.println("      <PageMargins x:Bottom=\"0.75\" x:Left=\"0.7\" x:Right=\"0.7\" x:Top=\"0.75\"/>");
        wb.println("      </PageSetup>");
        wb.println("      <ProtectObjects>False</ProtectObjects>");
        wb.println("      <ProtectScenarios>False</ProtectScenarios>");
        wb.println("      </WorksheetOptions>");
        wb.println("      </Worksheet>");
        wb.println("      </Workbook>");
        wb.println("      ");

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
            String str = "aku anak cerdas > pandai & rajin";

            System.out.println(URLEncoder.encode(str, "UTF-8"));
        } catch (Exception e) {
            System.out.println(e.toString());
        }
    }
}
