/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.crm.report;

import com.project.crm.I_Crm;
import com.project.crm.master.Approval;
import com.project.crm.master.DbApproval;
import com.project.crm.sewa.DbSewaTanah;
import com.project.crm.sewa.DbSewaTanahBenefit;
import com.project.crm.sewa.DbSewaTanahBenefitDetail;
import com.project.crm.sewa.DbSewaTanahInvoice;
import com.project.crm.sewa.DbSewaTanahRincianPiutang;
import com.project.crm.sewa.SewaTanah;
import com.project.crm.sewa.SewaTanahBenefit;
import com.project.crm.sewa.SewaTanahBenefitDetail;
import com.project.crm.sewa.SewaTanahInvoice;
import com.project.crm.sewa.SewaTanahKomper;
import com.project.crm.sewa.SewaTanahRincianPiutang;
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
public class InvoiceSewaTanahDetail extends HttpServlet {

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

        String[] monthList = {"Januari", "Februari", "Maret", "April", "Mei", "Juni", "Juli", "Agustus", "September", "Oktober", "November", "Desember"};

        // Load User Login
        String loginId = JSPRequestValue.requestString(request, "oid");
        System.out.println("UserId : " + loginId);

        long invoice_oid = JSPRequestValue.requestLong(request, "hidden_oid_invoice");

        int typeInvoice = JSPRequestValue.requestInt(request, "status");

        IndukCustomer ic = new IndukCustomer();
        SewaTanahInvoice sewaTanahInvoice = new SewaTanahInvoice();
        SewaTanah st = new SewaTanah();
        Currency curr = new Currency();

        try {
            sewaTanahInvoice = DbSewaTanahInvoice.fetchExc(invoice_oid);
        } catch (Exception e) {
        }

        Customer cus = new Customer();

        try {
            st = DbSewaTanah.fetchExc(sewaTanahInvoice.getSewaTanahId());
            cus = DbCustomer.fetchExc(st.getCustomerId());

        } catch (Exception e) {
        }


        try {
            ic = DbIndukCustomer.fetch(st.getInvestorId());
        } catch (Exception e) {
        }


        try {
            curr = DbCurrency.fetchExc(sewaTanahInvoice.getCurrencyId());
        } catch (Exception e) {
        }

        Vector tempx = DbSewaTanahBenefit.list(0, 1, "sewa_tanah_invoice_id=" + invoice_oid, "");

        long oidSewaTanahBenefit = 0;

        if (tempx != null && tempx.size() > 0) {
            SewaTanahBenefit stb = (SewaTanahBenefit) tempx.get(0);
            oidSewaTanahBenefit = stb.getOID();
        }

        // Load Company
        Company company = DbCompany.getCompany();
        long oidCompany = company.getOID();
        System.out.println("oidCompany : " + oidCompany);

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

        int year = sewaTanahInvoice.getTanggal().getYear() + 1900;
        SewaTanahRincianPiutang sewaTanahRincianPiutang = new SewaTanahRincianPiutang();
        String wherePiutang = DbSewaTanahRincianPiutang.colNames[DbSewaTanahRincianPiutang.COL_SEWA_TANAH_ID] + "=" + st.getOID() + " AND " +
                DbSewaTanahRincianPiutang.colNames[DbSewaTanahRincianPiutang.COL_PERIODE_TAHUN] + "=" + year;

        Vector rincian = DbSewaTanahRincianPiutang.list(0, 0, wherePiutang, "");

        if (rincian != null && rincian.size() > 0) {
            sewaTanahRincianPiutang = (SewaTanahRincianPiutang) rincian.get(0);
        }
        int curent_year = new Date().getYear() + 1900;
        PrintWriter wb = new PrintWriter(new OutputStreamWriter(gzo, "UTF-8"));


        wb.println(" <?xml version=\"1.0\"?>");
        wb.println(" <?mso-application progid=\"Excel.Sheet\"?>");
        wb.println(" <Workbook xmlns=\"urn:schemas-microsoft-com:office:spreadsheet\"");
        wb.println(" xmlns:o=\"urn:schemas-microsoft-com:office:office\"");
        wb.println(" xmlns:x=\"urn:schemas-microsoft-com:office:excel\"");
        wb.println(" xmlns:ss=\"urn:schemas-microsoft-com:office:spreadsheet\"");
        wb.println(" xmlns:html=\"http://www.w3.org/TR/REC-html40\">");
        wb.println(" <DocumentProperties xmlns=\"urn:schemas-microsoft-com:office:office\">");
        wb.println(" <Author>PNCI</Author>");
        wb.println(" <LastAuthor>PNCI</LastAuthor>");
        wb.println(" <Created>2011-03-30T19:35:37Z</Created>");
        wb.println(" <LastSaved>2011-03-30T19:38:04Z</LastSaved>");
        wb.println(" <Company>Development</Company>");
        wb.println(" <Version>12.00</Version>");
        wb.println(" </DocumentProperties>");
        wb.println(" <ExcelWorkbook xmlns=\"urn:schemas-microsoft-com:office:excel\">");
        wb.println(" <WindowHeight>8130</WindowHeight>");
        wb.println(" <WindowWidth>16095</WindowWidth>");
        wb.println(" <WindowTopX>0</WindowTopX>");
        wb.println(" <WindowTopY>30</WindowTopY>");
        wb.println(" <ProtectStructure>False</ProtectStructure>");
        wb.println(" <ProtectWindows>False</ProtectWindows>");
        wb.println(" </ExcelWorkbook>");
        wb.println(" <Styles>");
        wb.println(" <Style ss:ID=\"Default\" ss:Name=\"Normal\">");
        wb.println(" <Alignment ss:Vertical=\"Bottom\"/>");
        wb.println(" <Borders/>");
        wb.println(" <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"/>");
        wb.println(" <Interior/>");
        wb.println(" <NumberFormat/>");
        wb.println(" <Protection/>");
        wb.println(" </Style>");
        wb.println(" <Style ss:ID=\"s17\" ss:Name=\"Comma [0] 2\">");
        wb.println(" <NumberFormat ss:Format=\"_(* #,##0_);_(* \\(#,##0\\);_(* &quot;-&quot;_);_(@_)\"/>");
        wb.println(" </Style>");
        wb.println(" <Style ss:ID=\"s16\" ss:Name=\"Normal 2\">");
        wb.println(" <Alignment ss:Vertical=\"Bottom\"/>");
        wb.println(" <Borders/>");
        wb.println(" <Font ss:FontName=\"Calibri\" x:CharSet=\"1\" x:Family=\"Swiss\" ss:Size=\"11\"");
        wb.println(" ss:Color=\"#000000\"/>");
        wb.println(" <Interior/>");
        wb.println(" <NumberFormat/>");
        wb.println(" <Protection/>");
        wb.println(" </Style>");
        wb.println(" <Style ss:ID=\"m44469456\" ss:Parent=\"s16\">");
        wb.println(" <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\"/>");
        wb.println(" <Borders>");
        wb.println(" <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println(" <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println(" <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println(" <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println(" </Borders>");
        wb.println(" <Font ss:FontName=\"Tahoma\" x:Family=\"Swiss\" ss:Bold=\"1\"/>");
        wb.println(" <Interior ss:Color=\"#FFFFFF\" ss:Pattern=\"Solid\"/>");
        wb.println(" </Style>");
        wb.println(" <Style ss:ID=\"m44469476\" ss:Parent=\"s16\">");
        wb.println(" <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\"/>");
        wb.println(" <Borders>");
        wb.println(" <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println(" <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println(" <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println(" <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println(" </Borders>");
        wb.println(" <Font ss:FontName=\"Tahoma\" x:Family=\"Swiss\" ss:Bold=\"1\"/>");
        wb.println(" <Interior ss:Color=\"#FFFFFF\" ss:Pattern=\"Solid\"/>");
        wb.println(" </Style>");
        wb.println(" <Style ss:ID=\"m44469496\" ss:Parent=\"s16\">");
        wb.println(" <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\"/>");
        wb.println(" <Borders>");
        wb.println(" <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println(" <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println(" <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println(" <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println(" </Borders>");
        wb.println(" <Font ss:FontName=\"Tahoma\" x:Family=\"Swiss\" ss:Bold=\"1\"/>");
        wb.println(" </Style>");
        wb.println(" <Style ss:ID=\"s18\" ss:Parent=\"s16\">");
        wb.println(" <Alignment ss:Vertical=\"Center\"/>");
        wb.println(" <Font ss:FontName=\"Tahoma\" x:Family=\"Swiss\"/>");
        wb.println(" </Style>");
        wb.println(" <Style ss:ID=\"s19\" ss:Parent=\"s16\">");
        wb.println(" <Alignment ss:Vertical=\"Center\"/>");
        wb.println(" <Borders>");
        wb.println(" <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println(" </Borders>");
        wb.println(" <Font ss:FontName=\"Tahoma\" x:Family=\"Swiss\"/>");
        wb.println(" </Style>");
        wb.println(" <Style ss:ID=\"s20\" ss:Parent=\"s16\">");
        wb.println(" <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\"/>");
        wb.println(" <Font ss:FontName=\"Tahoma\" x:Family=\"Swiss\"/>");
        wb.println(" </Style>");
        wb.println(" <Style ss:ID=\"s21\" ss:Parent=\"s16\">");
        wb.println(" <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\"/>");
        wb.println(" <Borders>");
        wb.println(" <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println(" </Borders>");
        wb.println(" <Font ss:FontName=\"Tahoma\" x:Family=\"Swiss\"/>");
        wb.println(" </Style>");
        wb.println(" <Style ss:ID=\"s22\" ss:Parent=\"s16\">");
        wb.println(" <Alignment ss:Vertical=\"Center\"/>");
        wb.println(" <Borders>");
        wb.println(" <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println(" </Borders>");
        wb.println(" <Font ss:FontName=\"Tahoma\" x:Family=\"Swiss\"/>");
        wb.println(" </Style>");
        wb.println(" <Style ss:ID=\"s23\" ss:Parent=\"s17\">");
        wb.println(" <Alignment ss:Vertical=\"Center\"/>");
        wb.println(" <Borders>");
        wb.println(" <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println(" </Borders>");
        wb.println(" <Font ss:FontName=\"Tahoma\" x:Family=\"Swiss\"/>");
        wb.println(" <NumberFormat ss:Format=\"_(* #,##0.00_);_(* \\(#,##0.00\\);_(* &quot;-&quot;_);_(@_)\"/>");
        wb.println(" </Style>");
        wb.println(" <Style ss:ID=\"s24\" ss:Parent=\"s16\">");
        wb.println(" <Alignment ss:Vertical=\"Center\"/>");
        wb.println(" <Borders/>");
        wb.println(" <Font ss:FontName=\"Tahoma\" x:Family=\"Swiss\"/>");
        wb.println(" </Style>");
        wb.println(" <Style ss:ID=\"s25\" ss:Parent=\"s16\">");
        wb.println(" <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\"/>");
        wb.println(" <Borders>");
        wb.println(" <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println(" <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println(" <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println(" </Borders>");
        wb.println(" <Font ss:FontName=\"Tahoma\" x:Family=\"Swiss\"/>");
        wb.println(" </Style>");
        wb.println(" <Style ss:ID=\"s26\" ss:Parent=\"s17\">");
        wb.println(" <Alignment ss:Vertical=\"Center\"/>");
        wb.println(" <Borders>");
        wb.println(" <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println(" <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println(" </Borders>");
        wb.println(" <Font ss:FontName=\"Tahoma\" x:Family=\"Swiss\"/>");
        wb.println(" <NumberFormat ss:Format=\"_(* #,##0.00_);_(* \\(#,##0.00\\);_(* &quot;-&quot;_);_(@_)\"/>");
        wb.println(" </Style>");
        wb.println(" <Style ss:ID=\"s27\" ss:Parent=\"s16\">");
        wb.println(" <Alignment ss:Vertical=\"Center\"/>");
        wb.println(" <Borders>");
        wb.println(" <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println(" </Borders>");
        wb.println(" <Font ss:FontName=\"Tahoma\" x:Family=\"Swiss\"/>");
        wb.println(" </Style>");
        wb.println(" <Style ss:ID=\"s28\" ss:Parent=\"s16\">");
        wb.println(" <Alignment ss:Vertical=\"Center\"/>");
        wb.println(" <Borders>");
        wb.println(" <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println(" <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println(" </Borders>");
        wb.println(" <Font ss:FontName=\"Tahoma\" x:Family=\"Swiss\"/>");
        wb.println(" </Style>");
        wb.println(" <Style ss:ID=\"s29\" ss:Parent=\"s16\">");
        wb.println(" <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\"/>");
        wb.println(" <Borders>");
        wb.println(" <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println(" <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println(" </Borders>");
        wb.println(" <Font ss:FontName=\"Tahoma\" x:Family=\"Swiss\"/>");
        wb.println(" </Style>");
        wb.println(" <Style ss:ID=\"s30\" ss:Parent=\"s16\">");
        wb.println(" <Alignment ss:Vertical=\"Center\"/>");
        wb.println(" <Borders>");
        wb.println(" <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println(" <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println(" </Borders>");
        wb.println(" <Font ss:FontName=\"Tahoma\" x:Family=\"Swiss\"/>");
        wb.println(" </Style>");
        wb.println(" <Style ss:ID=\"s31\" ss:Parent=\"s16\">");
        wb.println(" <Alignment ss:Vertical=\"Center\"/>");
        wb.println(" <Font ss:FontName=\"Tahoma\" x:Family=\"Swiss\" ss:Bold=\"1\"/>");
        wb.println(" </Style>");
        wb.println(" <Style ss:ID=\"s32\" ss:Parent=\"s16\">");
        wb.println(" <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\"/>");
        wb.println(" <Borders>");
        wb.println(" <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println(" <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println(" <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println(" </Borders>");
        wb.println(" <Font ss:FontName=\"Tahoma\" x:Family=\"Swiss\" ss:Bold=\"1\"/>");
        wb.println(" <Interior ss:Color=\"#FFFFFF\" ss:Pattern=\"Solid\"/>");
        wb.println(" </Style>");
        wb.println(" <Style ss:ID=\"s33\" ss:Parent=\"s16\">");
        wb.println(" <Alignment ss:Vertical=\"Center\"/>");
        wb.println(" <Borders>");
        wb.println(" <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println(" <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println(" <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println(" </Borders>");
        wb.println(" <Font ss:FontName=\"Tahoma\" x:Family=\"Swiss\" ss:Bold=\"1\"/>");
        wb.println(" </Style>");
        wb.println(" <Style ss:ID=\"s34\" ss:Parent=\"s16\">");
        wb.println(" <Alignment ss:Vertical=\"Center\"/>");
        wb.println(" <Borders>");
        wb.println(" <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println(" <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println(" <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println(" </Borders>");
        wb.println(" <Font ss:FontName=\"Tahoma\" x:Family=\"Swiss\" ss:Bold=\"1\"/>");
        wb.println(" <NumberFormat ss:Format=\"_(* #,##0.00_);_(* \\(#,##0.00\\);_(* &quot;-&quot;_);_(@_)\"/>");
        wb.println(" </Style>");
        wb.println(" <Style ss:ID=\"s35\" ss:Parent=\"s16\">");
        wb.println(" <Alignment ss:Vertical=\"Center\"/>");
        wb.println(" <Font ss:FontName=\"Tahoma\" x:Family=\"Swiss\"/>");
        wb.println(" <NumberFormat ss:Format=\"_(* #,##0.00_);_(* \\(#,##0.00\\);_(* &quot;-&quot;??_);_(@_)\"/>");
        wb.println(" </Style>");
        wb.println(" <Style ss:ID=\"s45\" ss:Parent=\"s16\">");
        wb.println(" <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\"/>");
        wb.println(" <Font ss:FontName=\"Tahoma\" x:Family=\"Swiss\" ss:Size=\"12\" ss:Bold=\"1\"/>");
        wb.println(" </Style>");
        wb.println(" </Styles>");
        wb.println(" <Worksheet ss:Name=\"Sheet1\">");
        wb.println(" <Table ss:ExpandedColumnCount=\"6\" ss:ExpandedRowCount=\"30\" x:FullColumns=\"1\"");
        wb.println(" x:FullRows=\"1\" ss:DefaultRowHeight=\"15\">");
        wb.println(" <Column ss:AutoFitWidth=\"0\" ss:Width=\"36.75\"/>");
        wb.println(" <Column ss:AutoFitWidth=\"0\" ss:Width=\"11.25\"/>");
        wb.println(" <Column ss:AutoFitWidth=\"0\" ss:Width=\"112.5\"/>");
        wb.println(" <Column ss:AutoFitWidth=\"0\" ss:Width=\"161.25\"/>");
        wb.println(" <Column ss:AutoFitWidth=\"0\" ss:Width=\"27.75\"/>");
        wb.println(" <Column ss:AutoFitWidth=\"0\" ss:Width=\"117.75\"/>");
        wb.println(" <Row>");
        wb.println(" <Cell ss:MergeAcross=\"5\" ss:StyleID=\"s45\"><Data ss:Type=\"String\">I N V O I C E </Data></Cell>");
        wb.println(" </Row>");
        wb.println(" <Row>");
        wb.println(" <Cell ss:StyleID=\"s31\"/>");
        wb.println(" <Cell ss:StyleID=\"s31\"/>");
        wb.println(" <Cell ss:StyleID=\"s31\"/>");
        wb.println(" <Cell ss:StyleID=\"s31\"/>");
        wb.println(" <Cell ss:StyleID=\"s31\"/>");
        wb.println(" <Cell ss:StyleID=\"s31\"/>");
        wb.println(" </Row>");
        wb.println(" <Row>");
        wb.println(" <Cell ss:StyleID=\"s31\"><Data ss:Type=\"String\">KLIEN</Data></Cell>");
        wb.println(" <Cell ss:StyleID=\"s31\"><Data ss:Type=\"String\">:</Data></Cell>");
        wb.println(" <Cell ss:StyleID=\"s31\"><Data ss:Type=\"String\">" + ic.getName().toUpperCase() + "</Data></Cell>");
        wb.println(" <Cell ss:StyleID=\"s31\"/>");
        wb.println(" <Cell ss:StyleID=\"s31\"/>");
        wb.println(" <Cell ss:StyleID=\"s31\"/>");
        wb.println(" </Row>");
        wb.println(" <Row>");
        wb.println(" <Cell ss:StyleID=\"s31\"/>");
        wb.println(" <Cell ss:StyleID=\"s31\"/>");
        wb.println(" <Cell ss:StyleID=\"s31\"><Data ss:Type=\"String\">(" + cus.getName() + ")</Data></Cell>");
        wb.println(" <Cell ss:StyleID=\"s31\"/>");
        wb.println(" <Cell ss:StyleID=\"s31\"/>");
        wb.println(" <Cell ss:StyleID=\"s31\"/>");
        wb.println(" </Row>");
        wb.println(" <Row>");
        wb.println(" <Cell ss:StyleID=\"s31\"/>");
        wb.println(" <Cell ss:StyleID=\"s31\"/>");
        wb.println(" <Cell ss:StyleID=\"s31\"/>");
        wb.println(" <Cell ss:StyleID=\"s31\"/>");
        wb.println(" <Cell ss:StyleID=\"s31\"/>");
        wb.println(" <Cell ss:StyleID=\"s31\"/>");
        wb.println(" </Row>");

        wb.println(" <Row>");
        wb.println(" <Cell ss:StyleID=\"s32\"><Data ss:Type=\"String\">NO</Data></Cell>");
        wb.println(" <Cell ss:MergeAcross=\"2\" ss:StyleID=\"m44469456\"><Data ss:Type=\"String\">U R A I A N</Data></Cell>");
        wb.println(" <Cell ss:MergeAcross=\"1\" ss:StyleID=\"m44469476\"><Data ss:Type=\"String\">JUMLAH</Data></Cell>");
        wb.println(" </Row>");
        wb.println(" <Row>");
        wb.println(" <Cell ss:StyleID=\"s21\"/>");
        wb.println(" <Cell ss:StyleID=\"s21\"/>");
        wb.println(" <Cell ss:StyleID=\"s24\"/>");
        wb.println(" <Cell ss:StyleID=\"s22\"/>");
        wb.println(" <Cell ss:StyleID=\"s27\"/>");
        wb.println(" <Cell ss:StyleID=\"s22\"/>");
        wb.println(" </Row>");

        double totalIncome = 0;
        double totalKomper = 0;

        for (int i = 0; i < I_Crm.kompenPersentase.length; i++) {

            SewaTanahBenefitDetail stbd = DbSewaTanahBenefitDetail.getDetail(oidSewaTanahBenefit, i);
            SewaTanahKomper stk = DbSewaTanahBenefitDetail.getKomper(sewaTanahInvoice.getSewaTanahId(), i);

            totalIncome = totalIncome + stbd.getJumlah();
            double komperJml = stbd.getJumlah() * stbd.getPersenKomper() / 100;
            totalKomper = totalKomper + komperJml;

        }

        wb.println(" <Row>");
        wb.println(" <Cell ss:StyleID=\"s21\"><Data ss:Type=\"Number\">1</Data></Cell>");
        wb.println(" <Cell ss:StyleID=\"s21\"/>");
        wb.println(" <Cell ss:StyleID=\"s24\"><Data ss:Type=\"String\">Kewajiban Kompensasi Persentasi Bulan " + monthList[sewaTanahInvoice.getTanggal().getMonth()] + " " + year + "</Data></Cell>");
        wb.println(" <Cell ss:StyleID=\"s22\"/>");
        wb.println(" <Cell ss:StyleID=\"s27\"><Data ss:Type=\"String\">" + curr.getCurrencyCode() + "</Data></Cell>");
        wb.println(" <Cell ss:StyleID=\"s23\"><Data ss:Type=\"Number\">" + totalKomper + "</Data></Cell>");
        wb.println(" </Row>");
        wb.println(" <Row>");
        wb.println(" <Cell ss:StyleID=\"s21\"/>");
        wb.println(" <Cell ss:StyleID=\"s21\"/>");
        wb.println(" <Cell ss:StyleID=\"s24\"/>");
        wb.println(" <Cell ss:StyleID=\"s22\"/>");
        wb.println(" <Cell ss:StyleID=\"s27\"/>");
        wb.println(" <Cell ss:StyleID=\"s23\"/>");
        wb.println(" </Row>");
        wb.println(" <Row>");
        wb.println(" <Cell ss:StyleID=\"s21\"><Data ss:Type=\"Number\">2</Data></Cell>");
        wb.println(" <Cell ss:StyleID=\"s21\"/>");
        wb.println(" <Cell ss:StyleID=\"s24\"><Data ss:Type=\"String\">Kompensasi Minimum Bulan " + monthList[sewaTanahInvoice.getTanggal().getMonth()] + " " + year + "</Data></Cell>");
        wb.println(" <Cell ss:StyleID=\"s22\"/>");
        wb.println(" <Cell ss:StyleID=\"s27\"><Data ss:Type=\"String\">" + curr.getCurrencyCode() + "</Data></Cell>");
        wb.println(" <Cell ss:StyleID=\"s23\"><Data ss:Type=\"Number\">-" + sewaTanahInvoice.getJumlah() + "</Data></Cell>");
        wb.println(" </Row>");
        wb.println(" <Row>");
        wb.println(" <Cell ss:StyleID=\"s21\"/>");
        wb.println(" <Cell ss:StyleID=\"s21\"/>");
        wb.println(" <Cell ss:StyleID=\"s24\"/>");
        wb.println(" <Cell ss:StyleID=\"s22\"/>");
        wb.println(" <Cell ss:StyleID=\"s28\"/>");
        wb.println(" <Cell ss:StyleID=\"s26\"/>");
        wb.println(" </Row>");
        double sisa = (totalKomper - sewaTanahInvoice.getJumlah() < 0) ? 0 : totalKomper - sewaTanahInvoice.getJumlah();
        wb.println(" <Row>");
        wb.println(" <Cell ss:StyleID=\"s21\"><Data ss:Type=\"Number\">3</Data></Cell>");
        wb.println(" <Cell ss:StyleID=\"s21\"/>");
        wb.println(" <Cell ss:StyleID=\"s24\"><Data ss:Type=\"String\">Sisa Kompensasi Persentasi Bulan " + monthList[sewaTanahInvoice.getTanggal().getMonth()] + " " + year + "</Data></Cell>");
        wb.println(" <Cell ss:StyleID=\"s22\"/>");
        wb.println(" <Cell ss:StyleID=\"s27\"><Data ss:Type=\"String\">" + curr.getCurrencyCode() + "</Data></Cell>");
        wb.println(" <Cell ss:StyleID=\"s23\"><Data ss:Type=\"Number\">" + sisa + "</Data></Cell>");
        wb.println(" </Row>");
        wb.println(" <Row>");
        wb.println(" <Cell ss:StyleID=\"s21\"/>");
        wb.println(" <Cell ss:StyleID=\"s21\"/>");
        wb.println(" <Cell ss:StyleID=\"s24\"/>");
        wb.println(" <Cell ss:StyleID=\"s22\"/>");
        wb.println(" <Cell ss:StyleID=\"s27\"/>");
        wb.println(" <Cell ss:StyleID=\"s23\"/>");
        wb.println(" </Row>");
        wb.println(" <Row>");
        wb.println(" <Cell ss:StyleID=\"s21\"><Data ss:Type=\"Number\">4</Data></Cell>");
        wb.println(" <Cell ss:StyleID=\"s21\"/>");
        wb.println(" <Cell ss:StyleID=\"s24\"><Data ss:Type=\"String\">PPN (10%) butir 3</Data></Cell>");
        wb.println(" <Cell ss:StyleID=\"s22\"/>");
        wb.println(" <Cell ss:StyleID=\"s27\"><Data ss:Type=\"String\">" + curr.getCurrencyCode() + "</Data></Cell>");
        wb.println(" <Cell ss:StyleID=\"s23\"><Data ss:Type=\"Number\">" + ((totalKomper - sewaTanahInvoice.getJumlah()) < 0 ? 0 : totalKomper - sewaTanahInvoice.getJumlah()) * 10 / 100 + "</Data></Cell>");
        wb.println(" </Row>");
        wb.println(" <Row>");
        wb.println(" <Cell ss:StyleID=\"s21\"/>");
        wb.println(" <Cell ss:StyleID=\"s21\"/>");
        wb.println(" <Cell ss:StyleID=\"s24\"/>");
        wb.println(" <Cell ss:StyleID=\"s22\"/>");
        wb.println(" <Cell ss:StyleID=\"s27\"/>");
        wb.println(" <Cell ss:StyleID=\"s23\"/>");
        wb.println(" </Row>");
        wb.println(" <Row>");
        wb.println(" <Cell ss:StyleID=\"s21\"><Data ss:Type=\"Number\">5</Data></Cell>");
        wb.println(" <Cell ss:StyleID=\"s21\"/>");
        wb.println(" <Cell ss:StyleID=\"s24\"><Data ss:Type=\"String\">PPh Pasal 4 ayat 2  (10%) butir 3</Data></Cell>");
        wb.println(" <Cell ss:StyleID=\"s22\"/>");
        wb.println(" <Cell ss:StyleID=\"s27\"><Data ss:Type=\"String\">" + curr.getCurrencyCode() + "</Data></Cell>");
        wb.println(" <Cell ss:StyleID=\"s23\"><Data ss:Type=\"Number\">-" + ((totalKomper - sewaTanahInvoice.getJumlah()) < 0 ? 0 : totalKomper - sewaTanahInvoice.getJumlah()) * 10 / 100 + "</Data></Cell>");
        wb.println(" </Row>");
        wb.println(" <Row>");
        wb.println(" <Cell ss:StyleID=\"s21\"/>");
        wb.println(" <Cell ss:StyleID=\"s21\"/>");
        wb.println(" <Cell ss:StyleID=\"s24\"/>");
        wb.println(" <Cell ss:StyleID=\"s22\"/>");
        wb.println(" <Cell ss:StyleID=\"s27\"/>");
        wb.println(" <Cell ss:StyleID=\"s23\"/>");
        wb.println(" </Row>");
        wb.println(" <Row>");
        wb.println("<Cell ss:StyleID=\"s21\"/>");
        wb.println(" <Cell ss:StyleID=\"s21\"/>");
        wb.println(" <Cell ss:StyleID=\"s24\"/>");
        wb.println(" <Cell ss:StyleID=\"s22\"/>");
        wb.println(" <Cell ss:StyleID=\"s27\"/>");
        wb.println(" <Cell ss:StyleID=\"s22\"/>");
        wb.println(" </Row>");
        wb.println(" <Row>");
        wb.println(" <Cell ss:StyleID=\"s25\"/>");
        wb.println(" <Cell ss:StyleID=\"s29\"/>");
        wb.println(" <Cell ss:StyleID=\"s19\"/>");
        wb.println(" <Cell ss:StyleID=\"s30\"/>");
        wb.println(" <Cell ss:StyleID=\"s28\"/>");
        wb.println(" <Cell ss:StyleID=\"s30\"/>");
        wb.println(" </Row>");
        double harusDibayar = (totalKomper - sewaTanahInvoice.getJumlah() < 0) ? 0 : totalKomper - sewaTanahInvoice.getJumlah();
        wb.println(" <Row>");
        wb.println(" <Cell ss:MergeAcross=\"3\" ss:StyleID=\"m44469496\"><Data ss:Type=\"String\">TOTAL</Data></Cell>");
        wb.println(" <Cell ss:StyleID=\"s33\"><Data ss:Type=\"String\">" + curr.getCurrencyCode() + "</Data></Cell>");
        wb.println(" <Cell ss:StyleID=\"s34\"><Data ss:Type=\"Number\">" + harusDibayar + "</Data></Cell>");
        wb.println(" </Row>");
        wb.println(" <Row>");
        wb.println(" <Cell ss:StyleID=\"s20\"/>");
        wb.println(" <Cell ss:StyleID=\"s20\"/>");
        wb.println(" <Cell ss:StyleID=\"s18\"/>");
        wb.println(" <Cell ss:StyleID=\"s18\"/>");
        wb.println(" <Cell ss:StyleID=\"s18\"/>");
        wb.println(" <Cell ss:StyleID=\"s18\"/>");
        wb.println(" </Row>");
        wb.println(" <Row>");
        wb.println(" <Cell ss:StyleID=\"s18\"/>");
        wb.println(" <Cell ss:StyleID=\"s18\"/>");
        wb.println(" <Cell ss:StyleID=\"s18\"/>");
        wb.println(" <Cell ss:StyleID=\"s18\"/>");
        wb.println(" <Cell ss:StyleID=\"s18\"/>");
        wb.println(" <Cell ss:StyleID=\"s18\"/>");
        wb.println(" </Row>");
        wb.println(" <Row>");
        wb.println(" <Cell ss:StyleID=\"s18\"/>");
        wb.println(" <Cell ss:StyleID=\"s18\"/>");
        wb.println(" <Cell ss:StyleID=\"s18\"/>");
        wb.println(" <Cell ss:MergeAcross=\"2\" ss:StyleID=\"s20\"><Data ss:Type=\"String\">Nusa Dua,        " + monthList[new Date().getMonth()] + " " + curent_year + "</Data></Cell>");
        wb.println(" </Row>");
        wb.println(" <Row>");
        wb.println(" <Cell ss:StyleID=\"s18\"/>");
        wb.println(" <Cell ss:StyleID=\"s18\"/>");
        wb.println(" <Cell ss:StyleID=\"s18\"/>");
        wb.println(" <Cell ss:MergeAcross=\"2\" ss:StyleID=\"s20\"><Data ss:Type=\"String\">PT (PERSERO) PENGEMBANGAN PARIWISATA BALI</Data></Cell>");
        wb.println(" </Row>");
        wb.println(" <Row>");
        wb.println(" <Cell ss:StyleID=\"s18\"/>");
        wb.println(" <Cell ss:StyleID=\"s18\"/>");
        wb.println(" <Cell ss:StyleID=\"s18\"/>");
        wb.println(" <Cell ss:MergeAcross=\"2\" ss:StyleID=\"s20\"><Data ss:Type=\"String\">D I R E K S I</Data></Cell>");
        wb.println(" </Row>");
        wb.println(" <Row>");
        wb.println(" <Cell ss:StyleID=\"s18\"/>");
        wb.println(" <Cell ss:StyleID=\"s18\"/>");
        wb.println(" <Cell ss:StyleID=\"s35\"/>");
        wb.println(" <Cell ss:StyleID=\"s18\"/>");
        wb.println(" <Cell ss:StyleID=\"s18\"/>");
        wb.println(" <Cell ss:StyleID=\"s18\"/>");
        wb.println(" </Row>");
        wb.println(" <Row>");
        wb.println(" <Cell ss:StyleID=\"s18\"/>");
        wb.println(" <Cell ss:StyleID=\"s18\"/>");
        wb.println(" <Cell ss:StyleID=\"s18\"/>");
        wb.println(" <Cell ss:StyleID=\"s18\"/>");
        wb.println(" <Cell ss:StyleID=\"s18\"/>");
        wb.println(" <Cell ss:StyleID=\"s18\"/>");
        wb.println(" </Row>");
        wb.println(" <Row>");
        wb.println(" <Cell ss:StyleID=\"s18\"/>");
        wb.println(" <Cell ss:StyleID=\"s18\"/>");
        wb.println(" <Cell ss:StyleID=\"s18\"/>");
        wb.println(" <Cell ss:StyleID=\"s18\"/>");
        wb.println(" <Cell ss:StyleID=\"s18\"/>");
        wb.println(" <Cell ss:StyleID=\"s18\"/>");
        wb.println(" </Row>");
        String nama_1 = "";
            String ket_1 = "";
            try {
                Approval approval_1 = DbApproval.getListApproval(I_Crm.TYPE_APPROVAL_INVOICE_DETAIL_SEWA_KOMPER, DbApproval.URUTAN_1);
                ket_1 = approval_1.getKeterangan();
                Employee employee = DbEmployee.fetchExc(approval_1.getEmployeeId());
                nama_1 = employee.getName();
            } catch (Exception e) {
                System.out.println("[exception] " + e.toString());
            }

        wb.println(" <Row>");
        wb.println(" <Cell ss:StyleID=\"s18\"/>");
        wb.println(" <Cell ss:StyleID=\"s18\"/>");
        wb.println(" <Cell ss:StyleID=\"s18\"/>");
        wb.println(" <Cell ss:MergeAcross=\"2\" ss:StyleID=\"s20\"><Data ss:Type=\"String\">"+nama_1+"</Data></Cell>");
        wb.println(" </Row>");
        wb.println(" <Row>");
        wb.println(" <Cell ss:StyleID=\"s18\"/>");
        wb.println(" <Cell ss:StyleID=\"s18\"/>");
        wb.println(" <Cell ss:StyleID=\"s18\"/>");
        wb.println(" <Cell ss:MergeAcross=\"2\" ss:StyleID=\"s20\"><Data ss:Type=\"String\">"+ket_1+"</Data></Cell>");
        wb.println(" </Row>");
        wb.println(" </Table>");
        wb.println(" <WorksheetOptions xmlns=\"urn:schemas-microsoft-com:office:excel\">");
        wb.println(" <PageSetup>");
        wb.println(" <Header x:Margin=\"0.3\"/>");
        wb.println(" <Footer x:Margin=\"0.3\"/>");
        wb.println(" <PageMargins x:Bottom=\"0.75\" x:Left=\"0.7\" x:Right=\"0.7\" x:Top=\"0.75\"/>");
        wb.println(" </PageSetup>");
        wb.println(" <Selected/>");
        wb.println(" <Panes>");
        wb.println(" <Pane>");
        wb.println(" <Number>3</Number>");
        wb.println(" <ActiveRow>15</ActiveRow>");
        wb.println(" <ActiveCol>5</ActiveCol>");
        wb.println(" </Pane>");
        wb.println(" </Panes>");
        wb.println(" <ProtectObjects>False</ProtectObjects>");
        wb.println(" <ProtectScenarios>False</ProtectScenarios>");
        wb.println(" </WorksheetOptions>");
        wb.println(" </Worksheet>");
        wb.println(" <Worksheet ss:Name=\"Sheet2\">");
        wb.println(" <Table ss:ExpandedColumnCount=\"1\" ss:ExpandedRowCount=\"1\" x:FullColumns=\"1\"");
        wb.println(" x:FullRows=\"1\" ss:DefaultRowHeight=\"15\">");
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
        wb.println(" x:FullRows=\"1\" ss:DefaultRowHeight=\"15\">");
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
