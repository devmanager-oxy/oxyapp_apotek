/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.ccs.report;

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
import com.project.crm.project.*;
import com.project.I_Project;

import com.project.admin.DbUser;
import com.project.admin.User;
import com.project.ccs.session.ReportKomisi;
import com.project.ccs.session.ReportParameter;
import com.project.ccs.session.SessReportSales;
import com.project.crm.master.Approval;
import com.project.crm.master.DbApproval;
import com.project.fms.session.SessReportBudgetSuplier;
import com.project.fms.transaction.DbBankpoPayment;
import com.project.general.Company;
import com.project.general.DbCompany;
import com.project.general.Customer;
import com.project.general.DbCustomer;
import com.project.general.Currency;
import com.project.general.DbCurrency;

import com.project.general.BankAccount;
import com.project.general.DbBankAccount;
import com.project.general.DbLocation;
import com.project.general.DbVendor;
import com.project.general.Location;
import com.project.general.Vendor;
import com.project.payroll.DbEmployee;
import com.project.payroll.Employee;
//import com.project.simprop.property.DbSalesData;
//import com.project.simprop.session.RptCustomer;
//import com.project.simprop.session.RptPayment;
import com.project.util.NumberSpeller;

/**
/**
 *
 * @author Roy Andika
 */
public class RptSalesKomisiXLS extends HttpServlet {

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
        System.out.println("===| Report Komisi |===");
        int lang = 0;
        Vector result = new Vector();

        long userId = 0;
        User user = new User();
        ReportParameter rp = new ReportParameter();
        Vendor vendor = new Vendor();
        Location location = new Location();

        try {
            HttpSession session = request.getSession();
            rp = (ReportParameter) session.getValue("REPORT_KOMISI");
        } catch (Exception e) {
        }

        try {
            result = SessReportSales.listSalesReportKomisi(rp.getDateFrom(), rp.getDateTo(), rp.getLocationId(), rp.getVendorId());
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

        Employee emp = new Employee();
        try {
            emp = DbEmployee.fetchExc(user.getEmployeeId());
        } catch (Exception e) {
        }

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
        if (lang == 0) {
            title = "REKAP PENJUALAN";
        } else {
            title = "SALES RECAP";
        }

        String title2 = "";
        if (lang == 0) {
            title2 = "BERDASARKAN TOTAL JUAL";
        } else {
            title2 = "BASED ON TOTAL SALES";
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
        wb.println("      <LastPrinted>2013-01-17T08:55:25Z</LastPrinted>");
        wb.println("      <Created>2013-01-17T08:44:40Z</Created>");
        wb.println("      <LastSaved>2013-01-17T08:56:20Z</LastSaved>");
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
        wb.println("      <Style ss:ID=\"s62\" ss:Name=\"Normal 2\">");
        wb.println("      <Alignment ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders/>");
        wb.println("      <Font ss:FontName=\"Arial\"/>");
        wb.println("      <Interior/>");
        wb.println("      <NumberFormat/>");
        wb.println("      <Protection/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s63\" ss:Name=\"Normal 3\">");
        wb.println("      <Alignment ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders/>");
        wb.println("      <Font ss:FontName=\"Arial\"/>");
        wb.println("      <Interior/>");
        wb.println("      <NumberFormat/>");
        wb.println("      <Protection/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"m36970720\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s66\" ss:Parent=\"s62\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Font ss:FontName=\"Arial\" x:Family=\"Swiss\" ss:Size=\"12\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      <Interior/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s69\" ss:Parent=\"s62\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders/>");
        wb.println("      <Font ss:FontName=\"Arial\" x:Family=\"Swiss\" ss:Size=\"12\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      <Interior/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s70\" ss:Parent=\"s62\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"3\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"12\" ss:Bold=\"1\"/>");
        wb.println("      <Interior/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s71\" ss:Parent=\"s62\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\"/>");
        wb.println("      <Borders/>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"12\" ss:Bold=\"1\"/>");
        wb.println("      <Interior/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s73\" ss:Parent=\"s62\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\"/>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"12\"/>");
        wb.println("      <Interior/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s75\" ss:Parent=\"s62\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\"/>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"12\" ss:Bold=\"1\"/>");
        wb.println("      <Interior/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s76\" ss:Parent=\"s62\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\"/>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Bold=\"1\"/>");
        wb.println("      <Interior/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s77\" ss:Parent=\"s62\">");
        wb.println("      <Alignment ss:Vertical=\"Center\"/>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"12\" ss:Bold=\"1\"/>");
        wb.println("      <Interior/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s78\" ss:Parent=\"s62\">");
        wb.println("      <Alignment ss:Vertical=\"Center\"/>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"12\"/>");
        wb.println("      <Interior/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s79\" ss:Parent=\"s62\">");
        wb.println("      <Alignment ss:Vertical=\"Center\"/>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\"/>");
        wb.println("      <Interior/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s80\" ss:Parent=\"s62\">");
        wb.println("      <Alignment ss:Vertical=\"Center\"/>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Bold=\"1\"/>");
        wb.println("      <Interior/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s81\" ss:Parent=\"s62\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Bold=\"1\"/>");
        wb.println("      <Interior/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s82\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Top\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s83\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Top\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <NumberFormat ss:Format=\"@\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s84\">");
        wb.println("      <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Top\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s85\">");
        wb.println("      <Alignment ss:Horizontal=\"Right\" ss:Vertical=\"Top\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <NumberFormat ss:Format=\"#,##0\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s86\">");
        wb.println("      <Alignment ss:Horizontal=\"Right\" ss:Vertical=\"Top\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <NumberFormat ss:Format=\"Standard\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s87\">");
        wb.println("      <Alignment ss:Vertical=\"Center\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s88\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s94\">");
        wb.println("      <Alignment ss:Horizontal=\"Right\" ss:Vertical=\"Center\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      <NumberFormat ss:Format=\"#,##0\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s95\">");
        wb.println("      <Alignment ss:Horizontal=\"Right\" ss:Vertical=\"Center\"/>");
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
        wb.println("      <Style ss:ID=\"s97\" ss:Parent=\"s63\">");
        wb.println("      <Alignment ss:Vertical=\"Center\"/>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"12\" ss:Bold=\"1\"/>");
        wb.println("      <Interior/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s98\" ss:Parent=\"s63\">");
        wb.println("      <Alignment ss:Vertical=\"Center\"/>");
        wb.println("      <Borders/>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"12\"/>");
        wb.println("      <Interior/>");
        wb.println("      <NumberFormat ss:Format=\"_(* #,##0_);_(* \\(#,##0\\);_(* &quot;-&quot;??_);_(@_)\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s99\" ss:Parent=\"s63\">");
        wb.println("      <Alignment ss:Vertical=\"Center\"/>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"12\"/>");
        wb.println("      <Interior/>");
        wb.println("      <NumberFormat ss:Format=\"_(* #,##0_);_(* \\(#,##0\\);_(* &quot;-&quot;??_);_(@_)\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s100\" ss:Parent=\"s63\">");
        wb.println("      <Alignment ss:Vertical=\"Center\"/>");
        wb.println("      <Borders/>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"12\"/>");
        wb.println("      <Interior/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s101\" ss:Parent=\"s63\">");
        wb.println("      <Alignment ss:Vertical=\"Center\"/>");
        wb.println("      <Borders/>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"12\"/>");
        wb.println("      <Interior/>");
        wb.println("      <NumberFormat");
        wb.println("      ss:Format=\"_([$Rp-421]* #,##0_);_([$Rp-421]* \\(#,##0\\);_([$Rp-421]* &quot;-&quot;_);_(@_)\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s102\" ss:Parent=\"s63\">");
        wb.println("      <Alignment ss:Vertical=\"Center\"/>");
        wb.println("      <Borders/>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"13\"/>");
        wb.println("      <Interior/>");
        wb.println("      <NumberFormat");
        wb.println("      ss:Format=\"_([$Rp-421]* #,##0_);_([$Rp-421]* \\(#,##0\\);_([$Rp-421]* &quot;-&quot;_);_(@_)\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s103\" ss:Parent=\"s63\">");
        wb.println("      <Alignment ss:Vertical=\"Center\"/>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"12\" ss:Underline=\"Single\"/>");
        wb.println("      <Interior/>");
        wb.println("      <NumberFormat ss:Format=\"_(* #,##0_);_(* \\(#,##0\\);_(* &quot;-&quot;??_);_(@_)\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s104\" ss:Parent=\"s63\">");
        wb.println("      <Alignment ss:Vertical=\"Center\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"2\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"13\"/>");
        wb.println("      <Interior/>");
        wb.println("      <NumberFormat");
        wb.println("      ss:Format=\"_([$Rp-421]* #,##0_);_([$Rp-421]* \\(#,##0\\);_([$Rp-421]* &quot;-&quot;_);_(@_)\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s105\" ss:Parent=\"s63\">");
        wb.println("      <Alignment ss:Vertical=\"Center\"/>");
        wb.println("      <Borders/>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"12\" ss:Bold=\"1\"/>");
        wb.println("      <Interior/>");
        wb.println("      <NumberFormat ss:Format=\"_(* #,##0_);_(* \\(#,##0\\);_(* &quot;-&quot;??_);_(@_)\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s106\" ss:Parent=\"s63\">");
        wb.println("      <Alignment ss:Vertical=\"Center\"/>");
        wb.println("      <Borders/>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"13\" ss:Bold=\"1\"/>");
        wb.println("      <Interior/>");
        wb.println("      <NumberFormat");
        wb.println("      ss:Format=\"_([$Rp-421]* #,##0_);_([$Rp-421]* \\(#,##0\\);_([$Rp-421]* &quot;-&quot;_);_(@_)\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s108\" ss:Parent=\"s63\">");
        wb.println("      <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Center\"/>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"12\" ss:Bold=\"1\"/>");
        wb.println("      <Interior/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s110\" ss:Parent=\"s63\">");
        wb.println("      <Alignment ss:Vertical=\"Center\"/>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"12\" ss:Bold=\"1\"/>");
        wb.println("      <Interior/>");
        wb.println("      <NumberFormat ss:Format=\"_(* #,##0_);_(* \\(#,##0\\);_(* &quot;-&quot;??_);_(@_)\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s112\" ss:Parent=\"s63\">");
        wb.println("      <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Center\"/>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"12\" ss:Bold=\"1\"/>");
        wb.println("      <Interior/>");
        wb.println("      <NumberFormat ss:Format=\"_(* #,##0_);_(* \\(#,##0\\);_(* &quot;-&quot;??_);_(@_)\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s113\" ss:Parent=\"s63\">");
        wb.println("      <Font ss:FontName=\"Arial\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Bold=\"1\"/>");
        wb.println("      <Interior/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s114\" ss:Parent=\"s63\">");
        wb.println("      <Alignment ss:Vertical=\"Center\"/>");
        wb.println("      <Borders/>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"14\" ss:Bold=\"1\"/>");
        wb.println("      <Interior/>");
        wb.println("      <NumberFormat");
        wb.println("      ss:Format=\"_([$Rp-421]* #,##0_);_([$Rp-421]* \\(#,##0\\);_([$Rp-421]* &quot;-&quot;_);_(@_)\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s115\" ss:Parent=\"s63\">");
        wb.println("      <Alignment ss:Vertical=\"Center\"/>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Bold=\"1\"/>");
        wb.println("      <Interior/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s116\" ss:Parent=\"s63\">");
        wb.println("      <Alignment ss:Vertical=\"Center\"/>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\"/>");
        wb.println("      <Interior/>");
        wb.println("      <NumberFormat ss:Format=\"_(* #,##0_);_(* \\(#,##0\\);_(* &quot;-&quot;??_);_(@_)\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s117\" ss:Parent=\"s63\">");
        wb.println("      <Alignment ss:Vertical=\"Center\" ss:WrapText=\"1\"/>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Bold=\"1\"");
        wb.println("      ss:Italic=\"1\"/>");
        wb.println("      <Interior/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s118\" ss:Parent=\"s63\">");
        wb.println("      <Alignment ss:Vertical=\"Center\"/>");
        wb.println("      <Borders/>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\"/>");
        wb.println("      <Interior/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s119\" ss:Parent=\"s63\">");
        wb.println("      <Alignment ss:Vertical=\"Center\"/>");
        wb.println("      <Borders/>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\"/>");
        wb.println("      <Interior/>");
        wb.println("      <NumberFormat ss:Format=\"_(* #,##0_);_(* \\(#,##0\\);_(* &quot;-&quot;??_);_(@_)\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s120\" ss:Parent=\"s63\">");
        wb.println("      <Alignment ss:Vertical=\"Center\"/>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\"/>");
        wb.println("      <Interior/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s122\" ss:Parent=\"s63\">");
        wb.println("      <Alignment ss:Vertical=\"Center\"/>");
        wb.println("      <Borders/>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"12\" ss:Bold=\"1\"/>");
        wb.println("      <Interior/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s123\" ss:Parent=\"s63\">");
        wb.println("      <Alignment ss:Vertical=\"Center\"/>");
        wb.println("      <Borders/>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Bold=\"1\"/>");
        wb.println("      <Interior/>");
        wb.println("      <NumberFormat ss:Format=\"_(* #,##0_);_(* \\(#,##0\\);_(* &quot;-&quot;??_);_(@_)\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s124\" ss:Parent=\"s63\">");
        wb.println("      <Alignment ss:Vertical=\"Center\"/>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"12\"/>");
        wb.println("      <Interior/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s127\" ss:Parent=\"s63\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\"/>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Bold=\"1\"/>");
        wb.println("      <Interior/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s129\" ss:Parent=\"s63\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\"/>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"12\" ss:Bold=\"1\"/>");
        wb.println("      <Interior/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s130\" ss:Parent=\"s63\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\"/>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"12\" ss:Bold=\"1\"");
        wb.println("      ss:Underline=\"Single\"/>");
        wb.println("      <Interior/>");
        wb.println("      </Style>");
        wb.println("      </Styles>");
        wb.println("      <Worksheet ss:Name=\"Sheet1\">");

        wb.println("      <Table >");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"34.5\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"92.25\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"152.25\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"51\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"51.75\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"90.75\"/>");
        wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"15.75\">");
        wb.println("      <Cell ss:MergeAcross=\"5\" ss:StyleID=\"s66\"><Data ss:Type=\"String\">" + location.getName().toUpperCase() + "</Data></Cell>");
        wb.println("      </Row>");
        if (location.getAddressStreet().length() > 0) {
            wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"15.75\">");
            wb.println("      <Cell ss:MergeAcross=\"5\" ss:StyleID=\"s66\"><Data ss:Type=\"String\">" + location.getAddressStreet().toUpperCase() + "</Data></Cell>");
            wb.println("      </Row>");
        }
        if (location.getTelp().length() > 0) {
            wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"15.75\">");
            wb.println("      <Cell ss:MergeAcross=\"5\" ss:StyleID=\"s69\"><Data ss:Type=\"String\">" + location.getTelp().toUpperCase() + "</Data></Cell>");
            wb.println("      </Row>");
        }
        wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"16.5\">");
        wb.println("      <Cell ss:StyleID=\"s70\"/>");
        wb.println("      <Cell ss:StyleID=\"s70\"/>");
        wb.println("      <Cell ss:StyleID=\"s70\"/>");
        wb.println("      <Cell ss:StyleID=\"s70\"/>");
        wb.println("      <Cell ss:StyleID=\"s70\"/>");
        wb.println("      <Cell ss:StyleID=\"s70\"/>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"16.5\">");
        wb.println("      <Cell ss:StyleID=\"s71\"/>");
        wb.println("      <Cell ss:StyleID=\"s71\"/>");
        wb.println("      <Cell ss:StyleID=\"s71\"/>");
        wb.println("      <Cell ss:StyleID=\"s71\"/>");
        wb.println("      <Cell ss:StyleID=\"s71\"/>");
        wb.println("      <Cell ss:StyleID=\"s71\"/>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"15.75\">");
        wb.println("      <Cell ss:MergeAcross=\"5\" ss:StyleID=\"s73\"><Data ss:Type=\"String\">" + title + "</Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"15.75\">");
        wb.println("      <Cell ss:MergeAcross=\"5\" ss:StyleID=\"s73\"><Data ss:Type=\"String\">( " + title2 + " )</Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"15.75\">");
        wb.println("      <Cell ss:MergeAcross=\"5\" ss:StyleID=\"s75\"><Data ss:Type=\"String\">PERIODE : " + JSPFormater.formatDate(rp.getDateFrom(), "dd MMM yyyy") + " ~ " + JSPFormater.formatDate(rp.getDateTo(), "dd MMM yyyy") + "</Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\">");
        wb.println("      <Cell ss:StyleID=\"s76\"/>");
        wb.println("      <Cell ss:StyleID=\"s76\"/>");
        wb.println("      <Cell ss:StyleID=\"s76\"/>");
        wb.println("      <Cell ss:StyleID=\"s76\"/>");
        wb.println("      <Cell ss:StyleID=\"s76\"/>");
        wb.println("      <Cell ss:StyleID=\"s76\"/>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"15.75\">");
        wb.println("      <Cell ss:StyleID=\"s77\"><Data ss:Type=\"String\">Supplier : " + vendor.getName().toUpperCase() + "</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s77\"/>");
        wb.println("      <Cell ss:StyleID=\"s78\"/>");
        wb.println("      <Cell ss:StyleID=\"s79\"/>");
        wb.println("      <Cell ss:StyleID=\"s80\"/>");
        wb.println("      <Cell ss:StyleID=\"s80\"/>");
        wb.println("      </Row>");
        
        int idx = 14;
        double totTotal = 0;
        
        if (result != null && result.size() > 0) {

            double totQty = 0;

            wb.println("      <Row ss:AutoFitHeight=\"0\">");
            wb.println("      <Cell ss:StyleID=\"s81\"><Data ss:Type=\"String\">NO</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s81\"><Data ss:Type=\"String\">TANGGAL</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s81\"><Data ss:Type=\"String\">NAMA BARANG</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s81\"><Data ss:Type=\"String\">QTY</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s81\"><Data ss:Type=\"String\">STN</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s81\"><Data ss:Type=\"String\">TOTAL  JUAL</Data></Cell>");
            wb.println("      </Row>");
            int counter = 0;
            int number = 1;

            for (int i = 0; i < result.size(); i++) {

                ReportKomisi rk = (ReportKomisi) result.get(i);
                totQty = totQty + rk.getQty();
                totTotal = totTotal + rk.getTotJual();

                wb.println("      <Row ss:AutoFitHeight=\"0\">");
                if(counter != rk.getCounter()){
                    wb.println("      <Cell ss:StyleID=\"s82\"><Data ss:Type=\"Number\">"+number+"</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s83\"><Data ss:Type=\"String\">"+JSPFormater.formatDate(rk.getTanggal(),"dd-MMM-yyyy")+"</Data></Cell>");
                    number++;
                    counter = rk.getCounter();
                }else{
                    wb.println("      <Cell ss:StyleID=\"s83\"><Data ss:Type=\"String\"></Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s83\"><Data ss:Type=\"String\"></Data></Cell>");
                }
                wb.println("      <Cell ss:StyleID=\"s84\"><Data ss:Type=\"String\">"+rk.getName()+"</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s85\"><Data ss:Type=\"Number\">"+JSPFormater.formatNumber(rk.getQty(),"###,###")+"</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s82\"><Data ss:Type=\"String\">"+rk.getStn()+"</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s86\"><Data ss:Type=\"Number\">"+JSPFormater.formatNumber(rk.getTotJual(),"###,###.##")+"</Data></Cell>");
                wb.println("      </Row>");
                
                idx ++;
            }

            wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"16.5\">");
            wb.println("      <Cell ss:StyleID=\"s87\"/>");
            wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"m36970720\"><Data ss:Type=\"String\">GRAND TOTAL</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s94\"><Data ss:Type=\"Number\">"+JSPFormater.formatNumber(totQty,"###,###")+"</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s88\"><Data ss:Type=\"String\">-</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s95\"><Data ss:Type=\"Number\">"+totTotal+"</Data></Cell>");
            wb.println("      </Row>");
            idx++;

        }

        wb.println("      <Row ss:Index=\""+idx+"\" ss:AutoFitHeight=\"0\" ss:Height=\"17.25\">");
        wb.println("      <Cell ss:StyleID=\"s97\"><Data ss:Type=\"String\">Total Nilai Jual</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s98\"/>");
        wb.println("      <Cell ss:StyleID=\"s99\"/>");
        wb.println("      <Cell ss:StyleID=\"s100\"/>");
        wb.println("      <Cell ss:StyleID=\"s101\"/>");
        wb.println("      <Cell ss:StyleID=\"s102\"><Data ss:Type=\"Number\">"+totTotal+"</Data></Cell>");
        wb.println("      </Row>");
        
        double komMargin = 0;
        if(vendor.getKomisiMargin() > 0){
             komMargin = (vendor.getKomisiMargin()/100)* totTotal;
            wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"18\">");
            wb.println("      <Cell ss:StyleID=\"s97\"><Data ss:Type=\"String\">Margin "+JSPFormater.formatNumber(vendor.getKomisiMargin(),"###,###,##")+" %</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s103\"/>");
            wb.println("      <Cell ss:StyleID=\"s98\"/>");
            wb.println("      <Cell ss:StyleID=\"s100\"/>");
            wb.println("      <Cell ss:StyleID=\"s101\"/>");
            wb.println("      <Cell ss:StyleID=\"s104\"><Data ss:Type=\"Number\">"+komMargin+"</Data></Cell>");
            wb.println("      </Row>");
        }
        
        double tot = totTotal - komMargin;
        
        wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"17.25\">");
        wb.println("      <Cell ss:StyleID=\"s97\"><Data ss:Type=\"String\">Total</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s99\"/>");
        wb.println("      <Cell ss:StyleID=\"s105\"/>");
        wb.println("      <Cell ss:StyleID=\"s100\"/>");
        wb.println("      <Cell ss:StyleID=\"s101\"/>");
        wb.println("      <Cell ss:StyleID=\"s106\"><Data ss:Type=\"Number\">"+tot+"</Data></Cell>");
        wb.println("      </Row>");
        
        wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"17.25\">");
        wb.println("      <Cell ss:StyleID=\"s97\"/>");
        wb.println("      <Cell ss:StyleID=\"s99\"/>");
        wb.println("      <Cell ss:StyleID=\"s105\"/>");
        wb.println("      <Cell ss:StyleID=\"s100\"/>");
        wb.println("      <Cell ss:StyleID=\"s101\"/>");
        wb.println("      <Cell ss:StyleID=\"s102\"/>");
        wb.println("      </Row>");
        
        wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"17.25\">");
        wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s108\"><Data ss:Type=\"String\">Potongan        :</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s110\"/>");
        wb.println("      <Cell ss:StyleID=\"s100\"/>");
        wb.println("      <Cell ss:StyleID=\"s101\"/>");
        wb.println("      <Cell ss:StyleID=\"s102\"/>");
        wb.println("      </Row>");
        
        if(vendor.getKomisiBarcode() > 0){
            wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"18\">");
            wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s112\"/>");
            wb.println("      <Cell ss:StyleID=\"s113\"><Data ss:Type=\"String\">Barcode      :</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s100\"/>");
            wb.println("      <Cell ss:StyleID=\"s101\"/>");
            wb.println("      <Cell ss:StyleID=\"s102\"><Data ss:Type=\"Number\">"+vendor.getKomisiBarcode()+"</Data></Cell>");
            wb.println("      </Row>");
        }
        
        double komPromosi = 0;
        
        if(vendor.getKomisiPromosi() > 0){        
            komPromosi = (vendor.getKomisiPromosi()/100)* totTotal;
            wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"18\">");
            wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s112\"/>");
            wb.println("      <Cell ss:StyleID=\"s113\"><Data ss:Type=\"String\">Promosi      :</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s100\"/>");
            wb.println("      <Cell ss:StyleID=\"s101\"/>");
            wb.println("      <Cell ss:StyleID=\"s104\"><Data ss:Type=\"Number\">"+komPromosi+"</Data></Cell>");
            wb.println("      </Row>");
        }
        
        double totYgDiBayar = tot - vendor.getKomisiBarcode() - komPromosi;
        
        wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"18.75\">");
        wb.println("      <Cell ss:StyleID=\"s97\"><Data ss:Type=\"String\">Total Yang Harus Dibayar</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s99\"/>");
        wb.println("      <Cell ss:StyleID=\"s110\"/>");
        wb.println("      <Cell ss:StyleID=\"s100\"/>");
        wb.println("      <Cell ss:StyleID=\"s101\"/>");
        wb.println("      <Cell ss:StyleID=\"s114\"><Data ss:Type=\"Number\">"+totYgDiBayar+"</Data></Cell>");
        wb.println("      </Row>");        
        
        String a = JSPFormater.formatNumber(totYgDiBayar, "#,###");
        NumberSpeller numberSpeller = new NumberSpeller();
        String u = a.replaceAll(",", "");
        
        wb.println("      <Row ss:AutoFitHeight=\"0\">");
        wb.println("      <Cell ss:StyleID=\"s115\"><Data ss:Type=\"String\">Terbilang      : "+numberSpeller.spellNumberToIna(Double.parseDouble(u))+" Rupiah</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s116\"/>");
        wb.println("      <Cell ss:StyleID=\"s117\"/>");
        wb.println("      <Cell ss:StyleID=\"s117\"/>");
        wb.println("      <Cell ss:StyleID=\"s117\"/>");
        wb.println("      <Cell ss:StyleID=\"s117\"/>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\">");
        wb.println("      <Cell ss:StyleID=\"s115\"/>");
        wb.println("      <Cell ss:StyleID=\"s116\"/>");
        wb.println("      <Cell ss:StyleID=\"s115\"/>");
        wb.println("      <Cell ss:StyleID=\"s118\"/>");
        wb.println("      <Cell ss:StyleID=\"s119\"/>");
        wb.println("      <Cell ss:StyleID=\"s119\"/>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"15.75\">");
        wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s127\"><Data ss:Type=\"String\">......, "+JSPFormater.formatDate(new Date(),"dd MMM yyyy")+"</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s120\"/>");
        wb.println("      <Cell ss:StyleID=\"s100\"/>");
        wb.println("      <Cell ss:StyleID=\"s119\"/>");
        wb.println("      <Cell ss:StyleID=\"s119\"/>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"15.75\">");
        wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s127\"><Data ss:Type=\"String\">Dibuat oleh,</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s120\"/>");
        wb.println("      <Cell ss:StyleID=\"s122\"/>");
        wb.println("      <Cell ss:StyleID=\"s123\"/>");
        wb.println("      <Cell ss:StyleID=\"s119\"/>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"15.75\">");
        wb.println("      <Cell ss:StyleID=\"s97\"/>");
        wb.println("      <Cell ss:StyleID=\"s110\"/>");
        wb.println("      <Cell ss:StyleID=\"s124\"/>");
        wb.println("      <Cell ss:StyleID=\"s122\"/>");
        wb.println("      <Cell ss:StyleID=\"s123\"/>");
        wb.println("      <Cell ss:StyleID=\"s119\"/>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"15.75\">");
        wb.println("      <Cell ss:StyleID=\"s124\"/>");
        wb.println("      <Cell ss:StyleID=\"s124\"/>");
        wb.println("      <Cell ss:StyleID=\"s124\"/>");
        wb.println("      <Cell ss:StyleID=\"s100\"/>");
        wb.println("      <Cell ss:StyleID=\"s119\"/>");
        wb.println("      <Cell ss:StyleID=\"s119\"/>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"15.75\">");
        wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s130\"><Data ss:Type=\"String\">"+emp.getName()+"</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s97\"/>");
        wb.println("      <Cell ss:StyleID=\"s100\"/>");
        wb.println("      <Cell ss:StyleID=\"s119\"/>");
        wb.println("      <Cell ss:StyleID=\"s119\"/>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"15.75\">");
        wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s129\"><Data ss:Type=\"String\">"+emp.getPosition()+"</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s124\"/>");
        wb.println("      <Cell ss:StyleID=\"s100\"/>");
        wb.println("      <Cell ss:StyleID=\"s119\"/>");
        wb.println("      <Cell ss:StyleID=\"s119\"/>");
        wb.println("      </Row>");
        wb.println("      </Table>");
        wb.println("      <WorksheetOptions xmlns=\"urn:schemas-microsoft-com:office:excel\">");
        wb.println("      <PageSetup>");
        wb.println("      <Header x:Margin=\"0.3\"/>");
        wb.println("      <Footer x:Margin=\"0.3\"/>");
        wb.println("      <PageMargins x:Bottom=\"0.75\" x:Left=\"0.7\" x:Right=\"0.7\" x:Top=\"0.75\"/>");
        wb.println("      </PageSetup>");
        wb.println("      <Unsynced/>");
        wb.println("      <Print>");
        wb.println("      <ValidPrinterInfo/>");
        wb.println("      <PaperSizeIndex>9</PaperSizeIndex>");
        wb.println("      <HorizontalResolution>300</HorizontalResolution>");
        wb.println("      <VerticalResolution>300</VerticalResolution>");
        wb.println("      </Print>");
        wb.println("      <Zoom>90</Zoom>");
        wb.println("      <Selected/>");
        wb.println("      <TopRowVisible>3</TopRowVisible>");
        wb.println("      <Panes>");
        wb.println("      <Pane>");
        wb.println("      <Number>3</Number>");
        wb.println("      <ActiveRow>18</ActiveRow>");
        wb.println("      <ActiveCol>5</ActiveCol>");
        wb.println("      </Pane>");
        wb.println("      </Panes>");
        wb.println("      <ProtectObjects>False</ProtectObjects>");
        wb.println("      <ProtectScenarios>False</ProtectScenarios>");
        wb.println("      </WorksheetOptions>");
        wb.println("      </Worksheet>");
        wb.println("      <Worksheet ss:Name=\"Sheet2\">");
        wb.println("      <Table >");
        wb.println("      <Row ss:AutoFitHeight=\"0\"/>");
        wb.println("      </Table>");
        wb.println("      <WorksheetOptions xmlns=\"urn:schemas-microsoft-com:office:excel\">");
        wb.println("      <PageSetup>");
        wb.println("      <Header x:Margin=\"0.3\"/>");
        wb.println("      <Footer x:Margin=\"0.3\"/>");
        wb.println("      <PageMargins x:Bottom=\"0.75\" x:Left=\"0.7\" x:Right=\"0.7\" x:Top=\"0.75\"/>");
        wb.println("      </PageSetup>");
        wb.println("      <Unsynced/>");
        wb.println("      <ProtectObjects>False</ProtectObjects>");
        wb.println("      <ProtectScenarios>False</ProtectScenarios>");
        wb.println("      </WorksheetOptions>");
        wb.println("      </Worksheet>");
        wb.println("      <Worksheet ss:Name=\"Sheet3\">");
        wb.println("      <Table >");
        wb.println("      <Row ss:AutoFitHeight=\"0\"/>");
        wb.println("      </Table>");
        wb.println("      <WorksheetOptions xmlns=\"urn:schemas-microsoft-com:office:excel\">");
        wb.println("      <PageSetup>");
        wb.println("      <Header x:Margin=\"0.3\"/>");
        wb.println("      <Footer x:Margin=\"0.3\"/>");
        wb.println("      <PageMargins x:Bottom=\"0.75\" x:Left=\"0.7\" x:Right=\"0.7\" x:Top=\"0.75\"/>");
        wb.println("      </PageSetup>");
        wb.println("      <Unsynced/>");
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
