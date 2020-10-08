/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.crm.report;

import com.project.crm.master.DbLot;
import com.project.crm.master.DbUnitContract;
import com.project.crm.master.Lot;
import com.project.crm.master.UnitContract;
import com.project.crm.sewa.DbSewaTanah;
import com.project.crm.sewa.DbSewaTanahInvoice;
import com.project.crm.sewa.SewaTanah;
import com.project.crm.sewa.SewaTanahInvoice;
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
import com.project.fms.master.*;
import com.project.payroll.*;
import com.project.util.jsp.*;
import com.project.fms.session.*;

import com.project.general.Company;
import com.project.general.Customer;
import com.project.general.DbCompany;
import com.project.general.DbCurrency;
import com.project.general.DbCustomer;
import com.project.general.DbIndukCustomer;
import com.project.general.IndukCustomer;
import com.project.general.Currency;

/**
 *
 * @author Roy Andika
 */
public class RptInvoiceKominExcel extends HttpServlet {

    /** Initializes the servlet.
     */
    public static String formatDate = "dd MMMM yyyy";

    public void init(ServletConfig config) throws ServletException {
        super.init(config);

    }

    /** 
     * Destroys the servlet.
     */
    public void destroy() {

    }

    String XMLSafe(String in) {
        return in;
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

        // Load Company
        Company company = DbCompany.getCompany();
        long oidCompany = company.getOID();
        System.out.println("oidCompany : " + oidCompany);

        String[] monthList = {"Januari", "Februari", "Maret", "April", "Mei", "Juni", "Juli", "Agustus", "September", "Oktober", "November", "Desember"};
        
        // Load Invoice Item
        Vector vectorList = new Vector(1, 1);

        try {
            HttpSession session = request.getSession();
            vectorList = (Vector) session.getValue("RPT_INVOICE_SEWA_TANAH");
        } catch (Exception e) {
            System.out.println(e);
        }

        //Count total Column
        int colSpan = 0;
        System.out.println(colSpan);

        boolean gzip = false;

        OutputStream gzo;

        if (gzip) {
            response.setHeader("Content-Encoding", "gzip");
            gzo = new GZIPOutputStream(response.getOutputStream());
        } else {
            gzo = response.getOutputStream();
        }

        PrintWriter wb = new PrintWriter(new OutputStreamWriter(gzo, "UTF-8"));

        wb.println("<?xml version=\"1.0\"?>");
        wb.println("<?mso-application progid=\"Excel.Sheet\"?>");
        wb.println("<Workbook xmlns=\"urn:schemas-microsoft-com:office:spreadsheet\"");
        wb.println("xmlns:o=\"urn:schemas-microsoft-com:office:office\"");
        wb.println("xmlns:x=\"urn:schemas-microsoft-com:office:excel\"");
        wb.println("xmlns:ss=\"urn:schemas-microsoft-com:office:spreadsheet\"");
        wb.println("xmlns:html=\"http://www.w3.org/TR/REC-html40\">");
        wb.println("<DocumentProperties xmlns=\"urn:schemas-microsoft-com:office:office\">");
        wb.println("<Author>PNCI</Author>");
        wb.println("<LastAuthor>PNCI</LastAuthor>");
        wb.println("<Created>2011-03-25T19:27:49Z</Created>");
        wb.println("<Company>Development</Company>");
        wb.println("<Version>12.00</Version>");
        wb.println("</DocumentProperties>");
        wb.println("<ExcelWorkbook xmlns=\"urn:schemas-microsoft-com:office:excel\">");
        wb.println("<WindowHeight>8640</WindowHeight>");
        wb.println("<WindowWidth>18975</WindowWidth>");
        wb.println("<WindowTopX>120</WindowTopX>");
        wb.println("<WindowTopY>30</WindowTopY>");
        wb.println("<ProtectStructure>False</ProtectStructure>");
        wb.println("<ProtectWindows>False</ProtectWindows>");
        wb.println("</ExcelWorkbook>");
        wb.println("<Styles>");
        wb.println("<Style ss:ID=\"Default\" ss:Name=\"Normal\">");
        wb.println("<Alignment ss:Vertical=\"Bottom\"/>");
        wb.println("<Borders/>");
        wb.println("<Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"/>");
        wb.println("<Interior/>");
        wb.println("<NumberFormat/>");
        wb.println("<Protection/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s64\">");
        wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("<Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\" ");
        wb.println(" ss:Bold=\"1\"/>");
        wb.println(" </Style>");
        wb.println(" <Style ss:ID=\"s116\">");
        wb.println(" <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Top\"/>");
        wb.println(" <Borders>");
        wb.println(" <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println(" <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println(" <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println(" <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println(" </Borders>");
        wb.println(" <NumberFormat ss:Format=\"d/m/yyyy\"/>");
        wb.println(" </Style>");
        wb.println(" <Style ss:ID=\"s117\">");
        wb.println(" <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Top\"/>");
        wb.println(" <Borders>");
        wb.println(" <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println(" <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println(" <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println(" <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println(" </Borders>");
        wb.println(" </Style>");
        wb.println(" <Style ss:ID=\"s123\">");
        wb.println(" <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Top\" ss:WrapText=\"1\"/>");
        wb.println(" <Borders>");
        wb.println(" <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println(" <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println(" <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println(" <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println(" </Borders>");
        wb.println(" </Style>");
        wb.println(" <Style ss:ID=\"s134\">");
        wb.println(" <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Top\"/>");
        wb.println(" <Borders>");
        wb.println(" <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println(" <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println(" <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println(" <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println(" </Borders>");
        wb.println(" <NumberFormat ss:Format=\"Standard\"/>");
        wb.println(" </Style>");
        wb.println(" <Style ss:ID=\"s137\">");
        wb.println(" <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\"/>");
        wb.println(" <Borders>");
        wb.println(" <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println(" <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println(" <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println(" <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println(" </Borders>");
        wb.println(" <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\" ");
        wb.println(" ss:Bold=\"1\"/>");
        wb.println(" <Interior ss:Color=\"#D7E4BC\" ss:Pattern=\"Solid\"/>");
        wb.println(" </Style>");
        wb.println(" </Styles>");
        wb.println(" <Worksheet ss:Name=\"Sheet1\">");

        wb.println(" <Table ss:ExpandedColumnCount=\"11\" x:FullColumns=\"1\" ");
        wb.println(" x:FullRows=\"1\">");

        wb.println(" <Column ss:AutoFitWidth=\"0\" ss:Width=\"63.75\"/>");
        wb.println(" <Column ss:AutoFitWidth=\"0\" ss:Width=\"78\"/>");
        wb.println(" <Column ss:Index=\"4\" ss:AutoFitWidth=\"0\" ss:Width=\"101.25\"/>");
        wb.println(" <Column ss:AutoFitWidth=\"0\" ss:Width=\"80.25\"/>");
        wb.println(" <Column ss:AutoFitWidth=\"0\" ss:Width=\"94.5\"/>");
        wb.println(" <Column ss:AutoFitWidth=\"0\" ss:Width=\"81\"/>");
        wb.println(" <Column ss:AutoFitWidth=\"0\" ss:Width=\"81.75\" ss:Span=\"1\"/>");
        wb.println(" <Column ss:Index=\"10\" ss:AutoFitWidth=\"0\" ss:Width=\"200.25\"/>");
        wb.println(" <Column ss:AutoFitWidth=\"0\" ss:Width=\"62.25\"/>");
        wb.println(" <Row ss:Index=\"2\">");
        
        int mnth = Integer.parseInt(""+vectorList.get(0));
        
        wb.println(" <Cell ss:MergeAcross=\"10\" ss:StyleID=\"s64\"><Data ss:Type=\"String\">DAFTAR INVOICE BULAN "+monthList[mnth - 1].toUpperCase()+" "+vectorList.get(1)+"</Data></Cell>");
        wb.println(" </Row>");
        wb.println(" <Row ss:Index=\"4\" ss:AutoFitHeight=\"0\" ss:Height=\"21.75\">");
        wb.println(" <Cell ss:StyleID=\"s137\"><Data ss:Type=\"String\">TANGGAL</Data></Cell>");
        wb.println(" <Cell ss:StyleID=\"s137\"><Data ss:Type=\"String\">NOMOR</Data></Cell>");
        wb.println(" <Cell ss:StyleID=\"s137\"><Data ss:Type=\"String\">LOT</Data></Cell>");
        wb.println(" <Cell ss:StyleID=\"s137\"><Data ss:Type=\"String\">INVESTOR</Data></Cell>");
        wb.println(" <Cell ss:StyleID=\"s137\"><Data ss:Type=\"String\">SARANA</Data></Cell>");
        wb.println(" <Cell ss:StyleID=\"s137\"><Data ss:Type=\"String\">JATUH TEMPO</Data></Cell>");
        wb.println(" <Cell ss:StyleID=\"s137\"><Data ss:Type=\"String\">MATA UANG</Data></Cell>");
        wb.println(" <Cell ss:StyleID=\"s137\"><Data ss:Type=\"String\">JUMLAH</Data></Cell>");
        wb.println(" <Cell ss:StyleID=\"s137\"><Data ss:Type=\"String\">PERIODE</Data></Cell>");
        wb.println(" <Cell ss:StyleID=\"s137\"><Data ss:Type=\"String\">KETERANGAN</Data></Cell>");
        wb.println(" <Cell ss:StyleID=\"s137\"><Data ss:Type=\"String\">STATUS</Data></Cell>");
        wb.println(" </Row>");


        if (vectorList != null && vectorList.size() > 0) {

            Vector temp = (Vector) vectorList.get(2);

            if (temp != null && temp.size() > 0) {

                for (int i = 0; i < temp.size(); i++) {


                    SewaTanahInvoice sti = (SewaTanahInvoice) temp.get(i);

                    SewaTanah st = new SewaTanah();
                    Lot lot = new Lot();
                    IndukCustomer ic = new IndukCustomer();
                    Customer cus = new Customer();
                    Currency curr = new Currency();
                    UnitContract uc = new UnitContract();

                    try {
                        st = DbSewaTanah.fetchExc(sti.getSewaTanahId());
                        lot = DbLot.fetchExc(st.getLotId());
                        ic = DbIndukCustomer.fetch(st.getInvestorId());
                        cus = DbCustomer.fetchExc(st.getCustomerId());
                        curr = DbCurrency.fetchExc(sti.getCurrencyId());
                        uc = DbUnitContract.fetchExc(sti.getMasaInvoiceId());
                    } catch (Exception e) {
                    }

                    wb.println(" <Row ss:Height=\"30\">");
                    wb.println(" <Cell ss:StyleID=\"s116\"><Data ss:Type=\"DateTime\">" + JSPFormater.formatDate(sti.getTanggal(), "yyyy-MM-dd") + "</Data></Cell>");
                    wb.println(" <Cell ss:StyleID=\"s117\"><Data ss:Type=\"String\">" + sti.getNumber() + "</Data></Cell>");
                    wb.println(" <Cell ss:StyleID=\"s117\"><Data ss:Type=\"String\">" + lot.getNama() + "</Data></Cell>");
                    wb.println(" <Cell ss:StyleID=\"s123\"><Data ss:Type=\"String\">" + ic.getName() + "</Data></Cell>");
                    wb.println(" <Cell ss:StyleID=\"s123\"><Data ss:Type=\"String\">" + cus.getName() + "</Data></Cell>");
                    wb.println(" <Cell ss:StyleID=\"s116\"><Data ss:Type=\"DateTime\">" + JSPFormater.formatDate(sti.getJatuhTempo(), "yyyy-MM-dd") + "</Data></Cell>");
                    wb.println(" <Cell ss:StyleID=\"s117\"><Data ss:Type=\"String\">" + curr.getCurrencyCode() + "</Data></Cell>");
                    wb.println(" <Cell ss:StyleID=\"s134\"><Data ss:Type=\"Number\">" + JSPFormater.formatNumber(sti.getJumlah(), "#,###.##") + "</Data></Cell>");
                    wb.println(" <Cell ss:StyleID=\"s117\"><Data ss:Type=\"String\">" + uc.getKode() + "</Data></Cell>");
                    wb.println(" <Cell ss:StyleID=\"s123\"><Data ss:Type=\"String\">" + sti.getKeterangan() + "</Data></Cell>");
                    wb.println(" <Cell ss:StyleID=\"s117\"><Data ss:Type=\"String\">" + DbSewaTanahInvoice.statusStr[sti.getStatus()].toUpperCase() + "</Data></Cell>");
                    wb.println(" </Row>");

                }
            }
        }

        wb.println(" </Table>");
        wb.println(" <WorksheetOptions xmlns=\"urn:schemas-microsoft-com:office:excel\">");
        wb.println(" <PageSetup>");
        wb.println(" <Header x:Margin=\"0.3\"/>");
        wb.println(" <Footer x:Margin=\"0.3\"/>");
        wb.println(" <PageMargins x:Bottom=\"0.75\" x:Left=\"0.7\" x:Right=\"0.7\" x:Top=\"0.75\"/>");
        wb.println(" </PageSetup>");
        wb.println(" <Print>");
        wb.println(" <ValidPrinterInfo/>");
        wb.println(" <HorizontalResolution>600</HorizontalResolution>");
        wb.println(" <VerticalResolution>600</VerticalResolution>");
        wb.println(" </Print>");
        wb.println(" <Selected/>");
        wb.println(" <DoNotDisplayGridlines/>");
        wb.println(" <LeftColumnVisible>2</LeftColumnVisible>");
        wb.println(" <Panes>");
        wb.println(" <Pane>");
        wb.println(" <Number>3</Number>");
        wb.println(" <ActiveRow>16</ActiveRow>");
        wb.println(" <ActiveCol>6</ActiveCol>");
        wb.println(" </Pane>");
        wb.println(" </Panes>");
        wb.println(" <ProtectObjects>False</ProtectObjects>");
        wb.println(" <ProtectScenarios>False</ProtectScenarios>");
        wb.println(" </WorksheetOptions>");
        wb.println(" </Worksheet>");
        wb.println(" <Worksheet ss:Name=\"Sheet2\">");
        wb.println(" <Table ss:ExpandedColumnCount=\"1\" ss:ExpandedRowCount=\"1\" x:FullColumns=\"1\"");
        wb.println(" x:FullRows=\"1\">");
        wb.println(" </Table>");
        wb.println(" <WorksheetOptions xmlns=\"urn:schemas-microsoft-com:office:excel\">");
        wb.println(" <PageSetup>");
        wb.println(" <Header x:Margin=\"0.3\"/>");
        wb.println(" <Footer x:Margin=\"0.3\"/>");
        wb.println(" <PageMargins x:Bottom=\"0.75\" x:Left=\"0.7\" x:Right=\"0.7\" x:Top=\"0.75\"/>");
        wb.println(" </PageSetup>");
        wb.println(" <ProtectObjects>False</ProtectObjects>");
        wb.println(" <ProtectScenarios>False</ProtectScenarios>");
        wb.println(" </WorksheetOptions>");
        wb.println(" </Worksheet>");
        wb.println(" <Worksheet ss:Name=\"Sheet3\">");
        wb.println(" <Table ss:ExpandedColumnCount=\"1\" ss:ExpandedRowCount=\"1\" x:FullColumns=\"1\"");
        wb.println(" x:FullRows=\"1\" >");
        wb.println(" </Table>");
        wb.println(" <WorksheetOptions xmlns=\"urn:schemas-microsoft-com:office:excel\">");
        wb.println(" <PageSetup>");
        wb.println(" <Header x:Margin=\"0.3\"/>");
        wb.println(" <Footer x:Margin=\"0.3\"/>");
        wb.println(" <PageMargins x:Bottom=\"0.75\" x:Left=\"0.7\" x:Right=\"0.7\" x:Top=\"0.75\"/>");
        wb.println(" </PageSetup>");
        wb.println(" <ProtectObjects>False</ProtectObjects>");
        wb.println(" <ProtectScenarios>False</ProtectScenarios>");
        wb.println(" </WorksheetOptions>");
        wb.println(" </Worksheet>");
        wb.println(" </Workbook>");

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
