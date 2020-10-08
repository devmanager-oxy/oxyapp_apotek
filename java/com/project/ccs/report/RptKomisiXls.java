/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.ccs.report;

import java.io.PrintWriter;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.util.zip.GZIPOutputStream;
import java.util.Vector;
import java.net.URLEncoder;

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

import com.project.admin.DbUser;
import com.project.admin.User;
import com.project.ccs.session.ReportKomisi;
import com.project.ccs.session.ReportParameter;
import com.project.ccs.session.SessReportSales;
import com.project.general.Company;
import com.project.general.DbCompany;

import com.project.general.DbLocation;
import com.project.general.DbVendor;
import com.project.general.Location;
import com.project.general.Vendor;
import java.util.Date;

/**
 *
 * @author Roy Andika
 */
public class RptKomisiXls extends HttpServlet {

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

        // Company Id        
        int lang = 0;
        Vector result = new Vector();

        long userId = 0;
        User user = new User();
        ReportParameter rp = new ReportParameter();
        Vendor vendor = new Vendor();
        Location location = new Location();
        Vector resultDeduction = new Vector();

        HttpSession session = request.getSession();
        try {
            rp = (ReportParameter) session.getValue("REPORT_KOMISI");
        } catch (Exception e) {
        }

        try {
            resultDeduction = (Vector) session.getValue("REPORT_KOMISI_DEDUCTION");
        } catch (Exception e) {
        }

        try {
            result = SessReportSales.reportKomisi(rp.getLocationId(), rp.getVendorId(), rp.getDateFrom(), rp.getDateTo());
        } catch (Exception e) {
            System.out.println(e.toString());
        }

        try {
            vendor = DbVendor.fetchExc(rp.getVendorId());
        } catch (Exception e) {
        }

        try {
            location = DbLocation.fetchExc(rp.getLocationId());
        } catch (Exception e) {
        }

        try {
            userId = JSPRequestValue.requestLong(request, "user_id");
            user = DbUser.fetch(userId);
        } catch (Exception e) {
        }

        String strPeriode = "" + JSPFormater.formatDate(rp.getDateFrom(), "dd MMM yyyy") + " S/D " + JSPFormater.formatDate(rp.getDateTo(), "dd MMM yyyy");
        Company cmp = new Company();
        try {
            Vector listCompany = DbCompany.list(0, 0, "", "");
            if (listCompany != null && listCompany.size() > 0) {
                cmp = (Company) listCompany.get(0);
            }
        } catch (Exception ext) {
            System.out.println(ext.toString());
        }

        String title = "";
        String[] langCT;

        if (lang == 0) {
            title = "REKAP PENJUALAN (KOMISI)";
            String[] langLANG = {"Lokasi", "Periode", "Suplier", "Tanggal", "No. Penjualan", "Deskripsi", "Jumlah", "Harga", "Total", "Total", "Total Nilai Jual (Bruto)", "Total Nilai Jual (Netto)", "Total yang harus di bayar", "Potongan"};
            langCT = langLANG;
        } else {
            title = "SALES RECAP (KOMISI)";
            String[] langLANG = {"Location", "Period", "Suplier", "Date", "Sales No.", "Description", "Qty", "Price", "Total", "Total", "Total Selling Value (Bruto)", "Total Selling Value (Netto)", "Total to be paid", "Discount"};
            langCT = langLANG;
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
        wb.println("      <LastPrinted>2013-02-11T06:49:14Z</LastPrinted>");
        wb.println("      <Created>2013-02-11T06:30:28Z</Created>");
        wb.println("      <LastSaved>2013-02-11T06:54:09Z</LastSaved>");
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

        wb.println("      <Style ss:ID=\"s19\">");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");

        wb.println("      <Style ss:ID=\"s16\" ss:Name=\"Comma\">");
        wb.println("      <NumberFormat ss:Format=\"_(* #,##0.00_);_(* \\(#,##0.00\\);_(* &quot;-&quot;??_);_(@_)\"/>");
        wb.println("      </Style>");

        wb.println("      <Style ss:ID=\"s20\">");
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

        wb.println("      <Style ss:ID=\"s21\">");
        wb.println("      <Alignment ss:Horizontal=\"Right\" ss:Vertical=\"Bottom\" ss:WrapText=\"1\"/>");
        wb.println("      <Borders/>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"/>");
        wb.println("      <Interior/>");
        wb.println("      </Style>");

        wb.println("      <Style ss:ID=\"s22\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\" ss:WrapText=\"1\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      <Interior/>");
        wb.println("      </Style>");

        wb.println("      <Style ss:ID=\"s23\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      <Interior/>");
        wb.println("      </Style>");

        wb.println("      <Style ss:ID=\"s24\">");
        wb.println("      <Alignment ss:Horizontal=\"Right\" ss:Vertical=\"Bottom\" ss:WrapText=\"1\"/>");
        wb.println("      <Borders/>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"/>");
        wb.println("      <Interior/>");
        wb.println("      <NumberFormat ss:Format=\"#,##0\"/>");
        wb.println("      </Style>");

        wb.println("      <Style ss:ID=\"s25\">");
        wb.println("      <Alignment ss:Vertical=\"Bottom\" ss:WrapText=\"1\"/>");
        wb.println("      <Borders/>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"/>");
        wb.println("      <Interior/>");
        wb.println("      </Style>");

        wb.println("      <Style ss:ID=\"s27\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Top\" ss:WrapText=\"1\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"/>");
        wb.println("      <Interior/>");
        wb.println("      <NumberFormat ss:Format=\"dd/mm/yyyy;@\"/>");
        wb.println("      </Style>");

        wb.println("      <Style ss:ID=\"s28\">");
        wb.println("      <Alignment ss:Vertical=\"Top\" ss:WrapText=\"1\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"/>");
        wb.println("      <Interior/>");
        wb.println("      </Style>");

        wb.println("      <Style ss:ID=\"s29\">");
        wb.println("      <Alignment ss:Horizontal=\"Right\" ss:Vertical=\"Top\" ss:WrapText=\"1\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"/>");
        wb.println("      <Interior/>");
        wb.println("      <NumberFormat ss:Format=\"#,##0\"/>");
        wb.println("      </Style>");

        wb.println("      <Style ss:ID=\"s30\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\" ss:WrapText=\"1\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"/>");
        wb.println("      <Interior/>");
        wb.println("      <NumberFormat ss:Format=\"dd/mm/yyyy;@\"/>");
        wb.println("      </Style>");

        wb.println("      <Style ss:ID=\"s31\">");
        wb.println("      <Alignment ss:Vertical=\"Bottom\" ss:WrapText=\"1\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"/>");
        wb.println("      <Interior/>");
        wb.println("      </Style>");

        wb.println("      <Style ss:ID=\"s32\">");
        wb.println("      <Alignment ss:Horizontal=\"Right\" ss:Vertical=\"Bottom\" ss:WrapText=\"1\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"/>");
        wb.println("      <Interior/>");
        wb.println("      </Style>");

        wb.println("      <Style ss:ID=\"s33\">");
        wb.println("      <Alignment ss:Horizontal=\"Right\" ss:Vertical=\"Bottom\" ss:WrapText=\"1\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"/>");
        wb.println("      <Interior/>");
        wb.println("      <NumberFormat ss:Format=\"#,##0\"/>");
        wb.println("      </Style>");

        wb.println("      <Style ss:ID=\"s34\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Top\" ss:WrapText=\"1\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"/>");
        wb.println("      <Interior/>");
        wb.println("      </Style>");

        wb.println("      <Style ss:ID=\"s35\">");
        wb.println("      <Alignment ss:Vertical=\"Top\" ss:WrapText=\"1\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"/>");
        wb.println("      <Interior/>");
        wb.println("      <NumberFormat ss:Format=\"#,##0\"/>");
        wb.println("      </Style>");

        wb.println("      <Style ss:ID=\"s36\">");
        wb.println("      <Alignment ss:Vertical=\"Bottom\" ss:WrapText=\"1\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"/>");
        wb.println("      <Interior/>");
        wb.println("      <NumberFormat ss:Format=\"#,##0\"/>");
        wb.println("      </Style>");

        wb.println("      <Style ss:ID=\"s37\">");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <NumberFormat ss:Format=\"#,##0\"/>");
        wb.println("      </Style>");

        wb.println("      <Style ss:ID=\"s38\">");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"12\" ss:Color=\"#000000\"/>");
        wb.println("      <Interior/>");
        wb.println("      </Style>");

        wb.println("      <Style ss:ID=\"s39\">");
        wb.println("      <Borders/>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"12\" ss:Color=\"#000000\"/>");
        wb.println("      <Interior/>");
        wb.println("      </Style>");

        wb.println("      <Style ss:ID=\"s40\">");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"12\" ss:Color=\"#000000\"/>");
        wb.println("      <Interior/>");
        wb.println("      <NumberFormat");
        wb.println("      ss:Format=\"_([$Rp-421]* #,##0_);_([$Rp-421]* \\(#,##0\\);_([$Rp-421]* &quot;-&quot;_);_(@_)\"/>");
        wb.println("      </Style>");

        wb.println("      <Style ss:ID=\"s69\">");
        wb.println("      <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"/>");
        wb.println("      <NumberFormat ss:Format=\"_(* #,##0.00_);_(* \\(#,##0.00\\);_(* &quot;-&quot;??_);_(@_)\"/>");
        wb.println("      </Style>");

        wb.println("      <Style ss:ID=\"s95\">");
        wb.println("      <Alignment ss:Horizontal=\"Right\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"/>");
        wb.println("      <NumberFormat ss:Format=\"_(* #,##0.00_);_(* \\(#,##0.00\\);_(* &quot;-&quot;??_);_(@_)\"/>");
        wb.println("      </Style>");

        wb.println("      <Style ss:ID=\"s96\">");
        wb.println("      <Alignment ss:Horizontal=\"Right\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"/>");
        wb.println("      <NumberFormat ss:Format=\"#,##0\"/>");
        wb.println("      </Style>");

        wb.println("      <Style ss:ID=\"s102\" ss:Parent=\"s16\">");
        wb.println("      <Alignment ss:Vertical=\"Bottom\"/>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"/>");
        wb.println("      </Style>");

        wb.println("      <Style ss:ID=\"s105\">");
        wb.println("      <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      </Style>");

        wb.println("      <Style ss:ID=\"s109\">");
        wb.println("      <Alignment ss:Horizontal=\"Right\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      </Style>");

        wb.println("      <Style ss:ID=\"s41\">");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"12\" ss:Color=\"#000000\"/>");
        wb.println("      <Interior/>");
        wb.println("      <NumberFormat");
        wb.println("      ss:Format=\"_([$Rp-421]* #,##0_);_([$Rp-421]* \\(#,##0\\);_([$Rp-421]* &quot;-&quot;_);_(@_)\"/>");
        wb.println("      </Style>");

        wb.println("      <Style ss:ID=\"s42\">");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"12\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      <Interior/>");
        wb.println("      <NumberFormat");
        wb.println("      ss:Format=\"_([$Rp-421]* #,##0_);_([$Rp-421]* \\(#,##0\\);_([$Rp-421]* &quot;-&quot;_);_(@_)\"/>");
        wb.println("      </Style>");
        
        wb.println("      <Style ss:ID=\"s98\">");
        wb.println("      <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      </Style>");

        wb.println("      <Style ss:ID=\"s98i\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"12\" ss:Color=\"#000000\"/>");
        wb.println("      </Style>");

        wb.println("      <Style ss:ID=\"s113\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"12\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      <Interior/>");
        wb.println("      <NumberFormat ss:Format=\"dd/mm/yyyy;@\"/>");
        wb.println("      </Style>");

        wb.println("      <Style ss:ID=\"s116\">");
        wb.println("      <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Interior/>");
        wb.println("      <NumberFormat ss:Format=\"dd/mm/yyyy;@\"/>");
        wb.println("      </Style>");

        wb.println("      <Style ss:ID=\"s117\">");
        wb.println("      <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Bottom\"/>");
        wb.println("      </Style>");

        wb.println("      <Style ss:ID=\"s118\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"12\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      <Interior/>");
        wb.println("      <NumberFormat ss:Format=\"dd/mm/yyyy;@\"/>");
        wb.println("      </Style>");

        wb.println("      <Style ss:ID=\"s119\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"12\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      </Style>");

        wb.println("      <Style ss:ID=\"s110\" ss:Parent=\"s16\">");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      </Style>");

        wb.println("      <Style ss:ID=\"s121\">");
        wb.println("      <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"12\" ss:Color=\"#000000\"/>");
        wb.println("      <Interior/>");
        wb.println("      </Style>");

        wb.println("      </Styles>");
        wb.println("      <Worksheet ss:Name=\"Sheet1\">");

        wb.println("      <Table>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"66.75\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"78.75\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"158.25\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"38.25\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"63\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"63\"/>");

        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"57\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"88.5\"/>");
        
        wb.println("      <Row ss:Index=\"2\" ss:Height=\"18.75\">");
        wb.println("      <Cell ss:MergeAcross=\"6\" ss:StyleID=\"s98\"><Data ss:Type=\"String\">" + cmp.getName().toUpperCase() + "</Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row ss:Index=\"3\" ss:Height=\"18.75\">");
        wb.println("      <Cell ss:MergeAcross=\"6\" ss:StyleID=\"s98\"><Data ss:Type=\"String\">" + cmp.getAddress().toUpperCase() + "</Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row ss:Height=\"15.75\">");
        wb.println("      <Cell ss:MergeAcross=\"6\" ss:StyleID=\"s113\"><Data ss:Type=\"String\">" + title.toUpperCase() + "</Data></Cell>");
        wb.println("      </Row>");

        wb.println("      <Row ss:Height=\"15.75\">");
        wb.println("      <Cell ss:StyleID=\"s118\"/>");
        wb.println("      <Cell ss:StyleID=\"s119\"/>");
        wb.println("      <Cell ss:StyleID=\"s119\"/>");
        wb.println("      <Cell ss:StyleID=\"s119\"/>");
        wb.println("      <Cell ss:StyleID=\"s119\"/>");
        wb.println("      <Cell ss:StyleID=\"s119\"/>");
        wb.println("      <Cell ss:StyleID=\"s119\"/>");
        wb.println("      <Cell ss:StyleID=\"s119\"/>");
        wb.println("      </Row>");

        wb.println("      <Row ss:Height=\"15.75\">");
        wb.println("      <Cell ss:StyleID=\"s121\"><Data ss:Type=\"String\">Printed By</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s121\"><Data ss:Type=\"String\">: " + user.getFullName() + ",Date : " + JSPFormater.formatDate(new Date(), "dd MMM yyyy hh:mm:ss") + "</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s121\"/>");
        wb.println("      <Cell ss:StyleID=\"s121\"/>");
        wb.println("      <Cell ss:StyleID=\"s121\"/>");
        wb.println("      <Cell ss:StyleID=\"s121\"/>");
        wb.println("      <Cell ss:StyleID=\"s121\"/>");
        wb.println("      <Cell ss:StyleID=\"s121\"/>");
        wb.println("      </Row>");
        wb.println("      <Row ss:Height=\"15.75\">");
        wb.println("      <Cell ss:StyleID=\"s121\"><Data ss:Type=\"String\">" + langCT[0] + "</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s121\"><Data ss:Type=\"String\">: " + location.getName().toUpperCase() + "</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s121\"/>");
        wb.println("      <Cell ss:StyleID=\"s121\"/>");
        wb.println("      <Cell ss:StyleID=\"s121\"/>");
        wb.println("      <Cell ss:StyleID=\"s121\"/>");
        wb.println("      <Cell ss:StyleID=\"s121\"/>");
        wb.println("      <Cell ss:StyleID=\"s121\"/>");
        wb.println("      </Row>");
        wb.println("      <Row>");
        wb.println("      <Cell ss:StyleID=\"s116\"><Data ss:Type=\"String\">" + langCT[1] + "</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s117\"><Data ss:Type=\"String\">: " + strPeriode.toUpperCase() + "</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s117\"/>");
        wb.println("      <Cell ss:StyleID=\"s117\"/>");
        wb.println("      <Cell ss:StyleID=\"s117\"/>");
        wb.println("      <Cell ss:StyleID=\"s117\"/>");
        wb.println("      <Cell ss:StyleID=\"s117\"/>");
        wb.println("      <Cell ss:StyleID=\"s117\"/>");
        wb.println("      </Row>");
        wb.println("      <Row>");
        wb.println("      <Cell><Data ss:Type=\"String\">" + langCT[2] + "</Data></Cell>");
        wb.println("      <Cell><Data ss:Type=\"String\">: " + vendor.getName().toUpperCase() + "</Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row>");
        wb.println("      <Cell><Data ss:Type=\"String\"></Data></Cell>");
        wb.println("      <Cell><Data ss:Type=\"String\"></Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row >");
        wb.println("      <Cell ss:StyleID=\"s20\"><Data ss:Type=\"String\">" + langCT[3] + "</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s22\"><Data ss:Type=\"String\">" + langCT[4] + "</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s20\"><Data ss:Type=\"String\">" + langCT[5] + "</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s20\"><Data ss:Type=\"String\">" + langCT[6] + "</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s23\"><Data ss:Type=\"String\">" + langCT[7] + "</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s23\"><Data ss:Type=\"String\">Discount</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s23\"><Data ss:Type=\"String\">" + langCT[8] + "</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s23\"><Data ss:Type=\"String\">" + langCT[9] + "</Data></Cell>");
        wb.println("      </Row>");

        if (result != null && result.size() > 0) {

            double totTotal = 0;
            long salesId = 0;
            double total = 0;
            double totQty = 0;
            double gTotQty = 0;

            for (int i = 0; i < result.size(); i++) {
                ReportKomisi rk = (ReportKomisi) result.get(i);
                double totPrice = (rk.getQty() * rk.getSellingPrice()) - rk.getDiscount();

                if (salesId != rk.getSalesId() && i != 0) {
                    totTotal = totTotal + total;
                    gTotQty = gTotQty + totQty;

                    wb.println("      <Row>");
                    wb.println("      <Cell ss:StyleID=\"s30\"/>");
                    wb.println("      <Cell ss:StyleID=\"s31\"/>");
                    wb.println("      <Cell ss:StyleID=\"s31\"/>");
                    wb.println("      <Cell ss:StyleID=\"s36\"><Data ss:Type=\"Number\">" + totQty + "</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s32\"/>");
                    wb.println("      <Cell ss:StyleID=\"s33\"/>");
                    wb.println("      <Cell ss:StyleID=\"s33\"/>");
                    wb.println("      <Cell ss:StyleID=\"s36\"><Data ss:Type=\"Number\">" + total + "</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s21\"/>");
                    wb.println("      <Cell ss:StyleID=\"s21\"/>");
                    wb.println("      <Cell ss:StyleID=\"s21\"/>");
                    wb.println("      </Row>");

                    total = 0;
                    totQty = 0;
                }
                total = total + totPrice;
                totQty = totQty + rk.getQty();

                wb.println("      <Row>");

                if (salesId != rk.getSalesId()) {
                    wb.println("      <Cell ss:StyleID=\"s34\"><Data ss:Type=\"String\">" + JSPFormater.formatDate(rk.getTanggal(), "dd-MMM-yyyy") + "</Data></Cell>");
                } else {
                    wb.println("      <Cell ss:StyleID=\"s34\"><Data ss:Type=\"String\"></Data></Cell>");
                }

                wb.println("      <Cell ss:StyleID=\"s34\"><Data ss:Type=\"String\">" + rk.getSalesNumber() + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s28\"><Data ss:Type=\"String\">" + rk.getName() + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s28\"><Data ss:Type=\"Number\">" + rk.getQty() + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s29\"><Data ss:Type=\"Number\">" + rk.getSellingPrice() + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s29\"><Data ss:Type=\"Number\">" + rk.getDiscount() + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s29\"><Data ss:Type=\"Number\">" + totPrice + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s35\"/>");
                wb.println("      <Cell ss:StyleID=\"s21\"/>");
                wb.println("      <Cell ss:StyleID=\"s21\"/>");
                wb.println("      <Cell ss:StyleID=\"s21\"/>");
                wb.println("      <Cell ss:StyleID=\"s24\"/>");
                wb.println("      <Cell ss:StyleID=\"s24\"/>");
                wb.println("      <Cell ss:StyleID=\"s24\"/>");
                wb.println("      <Cell ss:StyleID=\"s25\"/>");
                wb.println("      <Cell ss:StyleID=\"s25\"/>");
                wb.println("      <Cell ss:StyleID=\"s25\"/>");
                wb.println("      </Row>");

                salesId = rk.getSalesId();
            }

            wb.println("      <Row>");
            wb.println("      <Cell ss:StyleID=\"s30\"/>");
            wb.println("      <Cell ss:StyleID=\"s31\"/>");
            wb.println("      <Cell ss:StyleID=\"s31\"/>");
            wb.println("      <Cell ss:StyleID=\"s36\"><Data ss:Type=\"Number\">" + totQty + "</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s32\"/>");
            wb.println("      <Cell ss:StyleID=\"s33\"/>");
            wb.println("      <Cell ss:StyleID=\"s33\"/>");
            wb.println("      <Cell ss:StyleID=\"s36\"><Data ss:Type=\"Number\">" + total + "</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s21\"/>");
            wb.println("      <Cell ss:StyleID=\"s21\"/>");
            wb.println("      <Cell ss:StyleID=\"s21\"/>");
            wb.println("      </Row>");

            totTotal = totTotal + total;
            gTotQty = gTotQty + totQty;

            wb.println("      <Row>");
            wb.println("      <Cell ss:StyleID=\"s19\"/>");
            wb.println("      <Cell ss:StyleID=\"s19\"/>");
            wb.println("      <Cell ss:StyleID=\"s20\"><Data ss:Type=\"String\">GRAND TOTAL</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s37\"><Data ss:Type=\"Number\">" + gTotQty + "</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s19\"/>");
            wb.println("      <Cell ss:StyleID=\"s19\"/>");
            wb.println("      <Cell ss:StyleID=\"s19\"/>");
            wb.println("      <Cell ss:StyleID=\"s37\"><Data ss:Type=\"Number\">" + totTotal + "</Data></Cell>");
            wb.println("      </Row>");

            wb.println("      <Row ss:Height=\"15.75\">");
            wb.println("      <Cell ss:Index=\"3\" ss:StyleID=\"s38\"><Data ss:Type=\"String\"></Data></Cell>");
            wb.println("      <Cell ss:Index=\"7\" ss:StyleID=\"s38\"><Data ss:Type=\"String\"></Data></Cell>");
            wb.println("      </Row>");

            wb.println("      <Row >");
            wb.println("      <Cell ss:MergeAcross=\"5\" ss:StyleID=\"s69\"><Data ss:Type=\"String\">Total Sales</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s95\"><Data ss:Type=\"String\">Rp</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s96\"><Data ss:Type=\"Number\">" + totTotal + "</Data></Cell>");
            wb.println("      </Row>");

            double vatOut = 0;
            if (vendor.getIsPKP() == 1) {
                vatOut = totTotal - (100 * totTotal / 110);
            }

            double margin = (vendor.getKomisiMargin() / 100) * (totTotal - vatOut);
            double net = totTotal - margin - vatOut;
            double vatIn = 0;
            if (vendor.getIsPKP() == 1) {
                vatIn = net * 10 / 100;
            }
            double subTotal2 = net + vatIn;

            wb.println("      <Row >");
            wb.println("      <Cell ss:MergeAcross=\"5\" ss:StyleID=\"s69\"><Data ss:Type=\"String\">VAT Out</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s95\"><Data ss:Type=\"String\">Rp</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s96\"><Data ss:Type=\"Number\">" + vatOut + "</Data></Cell>");
            wb.println("      </Row>");

            wb.println("      <Row >");
            wb.println("      <Cell ss:MergeAcross=\"5\" ss:StyleID=\"s69\"><Data ss:Type=\"String\">Commision " + vendor.getKomisiMargin() + "%</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s95\"><Data ss:Type=\"String\">Rp</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s96\"><Data ss:Type=\"Number\">" + margin + "</Data></Cell>");
            wb.println("      </Row>");

            wb.println("      <Row >");
            wb.println("      <Cell ss:MergeAcross=\"5\" ss:StyleID=\"s69\"><Data ss:Type=\"String\">Subtotal 1</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s95\"><Data ss:Type=\"String\">Rp</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s96\"><Data ss:Type=\"Number\">" + net + "</Data></Cell>");
            wb.println("      </Row>");

            wb.println("      <Row >");
            wb.println("      <Cell ss:MergeAcross=\"5\" ss:StyleID=\"s69\"><Data ss:Type=\"String\">VAT In</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s95\"><Data ss:Type=\"String\">Rp</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s96\"><Data ss:Type=\"Number\">" + vatIn + "</Data></Cell>");
            wb.println("      </Row>");

            wb.println("      <Row >");
            wb.println("      <Cell ss:MergeAcross=\"5\" ss:StyleID=\"s69\"><Data ss:Type=\"String\">Subtotal 2</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s95\"><Data ss:Type=\"String\">Rp</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s96\"><Data ss:Type=\"Number\">" + subTotal2 + "</Data></Cell>");
            wb.println("      </Row>");

            double totalDeduction = 0;

            if (resultDeduction != null && resultDeduction.size() > 0) {
                wb.println("      <Row>");
                wb.println("      <Cell ss:MergeAcross=\"5\" ss:StyleID=\"s69\"><Data ss:Type=\"String\">Deduction</Data></Cell>");
                wb.println("      </Row>");

                for (int t = 0; t < resultDeduction.size(); t++) {
                    ReportKomisi rDeduction = (ReportKomisi) resultDeduction.get(t);
                    wb.println("      <Row>");
                    wb.println("      <Cell ss:Index=\"2\"><Data ss:Type=\"String\">" + rDeduction.getName() + "</Data></Cell>");
                    if (rDeduction.getName().compareToIgnoreCase("Promotion") == 0) {
                        wb.println("      <Cell><Data ss:Type=\"String\">" + rDeduction.getQty() + " % x Rp " + JSPFormater.formatNumber(rDeduction.getSellingPrice(), "###,###.##") + "</Data></Cell>");
                        wb.println("      <Cell ss:StyleID=\"s98i\"><Data ss:Type=\"String\">= Rp</Data></Cell>");
                        wb.println("      <Cell ss:StyleID=\"s96\"><Data ss:Type=\"Number\">" + ((rDeduction.getQty() / 100) * rDeduction.getSellingPrice()) + "</Data></Cell>");
                        wb.println("      <Cell ss:StyleID=\"s102\"/>");
                        wb.println("      </Row>");
                        totalDeduction = totalDeduction + ((rDeduction.getQty() / 100) * rDeduction.getSellingPrice());
                    } else {
                        wb.println("      <Cell><Data ss:Type=\"String\">" + JSPFormater.formatNumber(rDeduction.getQty(), "###,###.##") + " x Rp " + JSPFormater.formatNumber(rDeduction.getSellingPrice(), "###,###.##") + "</Data></Cell>");
                        wb.println("      <Cell ss:StyleID=\"s98i\"><Data ss:Type=\"String\">= Rp</Data></Cell>");
                        wb.println("      <Cell ss:StyleID=\"s96\"><Data ss:Type=\"Number\">" + (rDeduction.getQty() * rDeduction.getSellingPrice()) + "</Data></Cell>");
                        wb.println("      <Cell ss:StyleID=\"s102\"/>");
                        wb.println("      </Row>");
                        totalDeduction = totalDeduction + (rDeduction.getQty() * rDeduction.getSellingPrice());
                    }

                }
                wb.println("      <Row >");
                wb.println("      <Cell ss:MergeAcross=\"5\" ss:StyleID=\"s69\"><Data ss:Type=\"String\">Total Deduction</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s95\"><Data ss:Type=\"String\">Rp</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s96\"><Data ss:Type=\"Number\">" + totalDeduction + "</Data></Cell>");
                wb.println("      </Row>");
            }

            wb.println("      <Row>");
            wb.println("      <Cell ss:MergeAcross=\"5\" ss:StyleID=\"s69\"><Data ss:Type=\"String\">Grand Total </Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s95\"><Data ss:Type=\"String\">Rp</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s96\"><Data ss:Type=\"Number\">" + (subTotal2 - totalDeduction) + "</Data></Cell>");
            wb.println("      </Row>");
        }

        wb.println("      </Table>");
        wb.println("      <WorksheetOptions xmlns=\"urn:schemas-microsoft-com:office:excel\">");
        wb.println("      <PageSetup>");
        wb.println("      <Header x:Margin=\"0.3\"/>");
        wb.println("      <Footer x:Margin=\"0.3\"/>");
        wb.println("      <PageMargins x:Bottom=\"0.75\" x:Left=\"0.2\" x:Right=\"0.2\" x:Top=\"0.25\"/>");
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
        wb.println("      <ActiveRow>7</ActiveRow>");
        wb.println("      <ActiveCol>11</ActiveCol>");
        wb.println("      </Pane>");
        wb.println("      </Panes>");
        wb.println("      <ProtectObjects>False</ProtectObjects>");
        wb.println("      <ProtectScenarios>False</ProtectScenarios>");
        wb.println("      </WorksheetOptions>");
        wb.println("      </Worksheet>");
        wb.println("      <Worksheet ss:Name=\"Sheet2\">");
        wb.println("      <Table>");
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
        wb.println("      <Table>");
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

