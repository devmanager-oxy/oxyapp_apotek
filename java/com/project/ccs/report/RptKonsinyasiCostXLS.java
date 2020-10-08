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
import com.project.ccs.session.ReportParameter;
import com.project.ccs.session.RptKonsinyasiBeli;
import com.project.general.Company;
import com.project.general.DbCompany;
import com.project.general.DbLocation;
import com.project.general.DbVendor;
import com.project.general.Location;
import com.project.general.Vendor;
import com.project.system.DbSystemProperty;
import java.util.Date;
import java.util.Date;

/**
 *
 * @author Roy Andika
 */
public class RptKonsinyasiCostXLS extends HttpServlet {

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
        ReportParameter rp = new ReportParameter();
        long userId = 0;
        User user = new User();
        HttpSession session = request.getSession();

        Vector result = new Vector();
        try {
            result = (Vector) session.getValue("REPORT_KONSINYASI BELI");
        } catch (Exception e) {
        }

        try {
            rp = (ReportParameter) session.getValue("REPORT_KONSINYASI_COST");
        } catch (Exception e) {
        }

        Vendor vendor = new Vendor();
        try {
            vendor = DbVendor.fetchExc(rp.getVendorId());
        } catch (Exception e) {
        }

        Location loc = new Location();
        try {
            loc = DbLocation.fetchExc(rp.getLocationId());
        } catch (Exception e) {
        }

        String titleRpt = "";
        try {
            titleRpt = DbSystemProperty.getValueByName("TITLE_REPORT_KOSNINYASI_HARGA_BELI");
        } catch (Exception e) {
        }

        try {
            userId = JSPRequestValue.requestLong(request, "user_id");
            user = DbUser.fetch(userId);
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
        wb.println("      <LastAuthor>Roy</LastAuthor>");
        wb.println("      <LastPrinted>2015-11-23T22:47:30Z</LastPrinted>");
        wb.println("      <Created>2013-03-11T02:50:54Z</Created>");
        wb.println("      <LastSaved>2015-11-23T23:04:11Z</LastSaved>");
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
        wb.println("      <Style ss:ID=\"m54552584\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"8\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"m54552644\">");
        wb.println("      <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"8\" ss:Color=\"#000000\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"m54552664\">");
        wb.println("      <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"8\" ss:Color=\"#000000\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"m54552684\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"8\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s64\">");
        wb.println("      <Alignment ss:Vertical=\"Bottom\"/>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s77\">");
        wb.println("      <Alignment ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s85\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"8\" ss:Color=\"#000000\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s87\">");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"8\" ss:Color=\"#000000\"/>");
        wb.println("      <NumberFormat ss:Format=\"Standard\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s89\">");
        wb.println("      <Alignment ss:Horizontal=\"Right\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"8\" ss:Color=\"#000000\"/>");
        wb.println("      <NumberFormat ss:Format=\"Standard\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s94\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"8\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s125\">");
        wb.println("      <Alignment ss:Horizontal=\"Right\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"8\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      <NumberFormat ss:Format=\"Standard\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s130\">");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"8\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      <NumberFormat ss:Format=\"Standard\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s131\">");
        wb.println("      <Alignment ss:Vertical=\"Bottom\"/>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Color=\"#000000\" ss:Bold=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s134\">");
        wb.println("      <Alignment ss:Horizontal=\"Right\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"8\" ss:Color=\"#000000\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s142\">");
        wb.println("      <Alignment ss:Vertical=\"Bottom\"/>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"9\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s149\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"9\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s150\">");
        wb.println("      <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"9\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s156\">");
        wb.println("      <Alignment ss:Horizontal=\"Right\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"9\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      <NumberFormat ss:Format=\"Standard\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s162\">");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s163\">");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"9\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      <NumberFormat ss:Format=\"#,##0.0\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s164\">");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"9\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      <NumberFormat ss:Format=\"Standard\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"m36321428\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"8\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s131i\">");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"8\" ss:Color=\"#000000\"/>");
        wb.println("      <NumberFormat ss:Format=\"#,##0.00_);\\(#,##0.00\\)\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"m39954176\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"8\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      </Style>");

        wb.println("      <Style ss:ID=\"s173\">");
        wb.println("      <Alignment ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders/>");
        wb.println("      <Font ss:FontName=\"Times New Roman\" x:Family=\"Roman\" ss:Size=\"9\"");
        wb.println("      ss:Color=\"#000000\"/>");
        wb.println("      <Interior/>");
        wb.println("      <NumberFormat/>");
        wb.println("      <Protection/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s174\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\"/>");
        wb.println("      <Font ss:FontName=\"Times New Roman\" x:Family=\"Roman\" ss:Size=\"9\"");
        wb.println("      ss:Color=\"#000000\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s175\">");
        wb.println("      <Alignment ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders/>");
        wb.println("      <Font ss:FontName=\"Times New Roman\" x:Family=\"Roman\" ss:Color=\"#000000\"/>");
        wb.println("      <Interior/>");
        wb.println("      <NumberFormat ss:Format=\"_(* #,##0_);_(* \\(#,##0\\);_(* &quot;-&quot;_);_(@_)\"/>");
        wb.println("      <Protection/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s113\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"9\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      </Style>");

        wb.println("      <Style ss:ID=\"s110\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"8\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      </Style>");

        wb.println("      <Style ss:ID=\"s176\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders/>");
        wb.println("      <Font ss:FontName=\"Times New Roman\" x:Family=\"Roman\" ss:Size=\"9\"");
        wb.println("      ss:Color=\"#000000\" ss:Underline=\"Single\"/>");
        wb.println("      <Interior/>");
        wb.println("      <NumberFormat/>");
        wb.println("      <Protection/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s177\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders/>");
        wb.println("      <Font ss:FontName=\"Times New Roman\" x:Family=\"Roman\" ss:Size=\"9\"");
        wb.println("      ss:Color=\"#000000\"/>");
        wb.println("      <Interior/>");
        wb.println("      <NumberFormat/>");
        wb.println("      <Protection/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s178\">");
        wb.println("      <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"9\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s179\">");
        wb.println("      <Alignment ss:Horizontal=\"Right\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"9\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      <NumberFormat ss:Format=\"Standard\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s185\">");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"9\" ss:Color=\"#000000\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s187\">");
        wb.println("      <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"9\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      </Styles>");
        wb.println("      <Worksheet ss:Name=\"Sheet1\">");
        wb.println("      <Table >");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"47.25\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"50.25\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"39.75\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"51.75\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"51\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"48.75\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"45\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"42\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"43.5\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"45.75\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"50.25\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"43.5\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"65.25\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"72\"/>");
        wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"15.75\">");
        wb.println("      <Cell ss:MergeAcross=\"13\" ss:StyleID=\"s134\"><Data ss:Type=\"String\">Printed By : " + user.getFullName() + ",Date : " + JSPFormater.formatDate(new Date(), "dd-MMM-yyyy HH:mm:ss") + "</Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"15.75\">");
        wb.println("      <Cell ss:MergeAcross=\"13\" ss:StyleID=\"s131\"><Data ss:Type=\"String\">" + cmp.getName().toUpperCase() + "</Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"15.75\">");
        wb.println("      <Cell ss:MergeAcross=\"13\" ss:StyleID=\"s131\"><Data ss:Type=\"String\">" + cmp.getAddress().toUpperCase() + "</Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"15.75\">");
        wb.println("      <Cell ss:MergeAcross=\"13\" ss:StyleID=\"s131\"><Data ss:Type=\"String\">CONSIGNED INVENTORY REPORT (COST)</Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"15.75\">");
        wb.println("      <Cell ss:MergeAcross=\"13\" ss:StyleID=\"s131\"><Data ss:Type=\"String\"></Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"15.75\">");
        wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s150\"><Data ss:Type=\"String\">SUPLIER   </Data></Cell>");
        wb.println("      <Cell ss:MergeAcross=\"11\" ss:StyleID=\"s150\"><Data ss:Type=\"String\">: " + vendor.getName().toUpperCase() + "</Data></Cell>");
        wb.println("      </Row>");
        String period = JSPFormater.formatDate(rp.getDateFrom(), "dd-MMM-yyyy") + " To " + JSPFormater.formatDate(rp.getDateTo(), "dd-MMM-yyyy");
        wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"15.75\">");
        wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s150\"><Data ss:Type=\"String\">PERIOD   </Data></Cell>");
        wb.println("      <Cell ss:MergeAcross=\"11\" ss:StyleID=\"s150\"><Data ss:Type=\"String\">: " + period.toUpperCase() + "</Data></Cell>");
        wb.println("      </Row>");

        if (rp.getLocationId() != 0) {
            wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"15.75\">");
            wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s187\"><Data ss:Type=\"String\">LOCATION   </Data></Cell>");
            wb.println("      <Cell ss:MergeAcross=\"11\" ss:StyleID=\"s187\"><Data ss:Type=\"String\">: " + loc.getName().toUpperCase() + "</Data></Cell>");
            wb.println("      </Row>");
        }

        if (result != null && result.size() > 0) {

            wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"15.75\">");
            wb.println("      <Cell ss:MergeDown=\"1\" ss:StyleID=\"s94\"><Data ss:Type=\"String\">SKU </Data></Cell>");
            wb.println("      <Cell ss:MergeAcross=\"1\" ss:MergeDown=\"1\" ss:StyleID=\"s94\"><Data");
            wb.println("      ss:Type=\"String\">Description  </Data></Cell>");
            wb.println("      <Cell ss:MergeDown=\"1\" ss:StyleID=\"s94\"><Data ss:Type=\"String\">Cost  </Data></Cell>");
            wb.println("      <Cell ss:MergeDown=\"1\" ss:StyleID=\"s94\"><Data ss:Type=\"String\">Begining  </Data></Cell>");
            wb.println("      <Cell ss:MergeDown=\"1\" ss:StyleID=\"s94\"><Data ss:Type=\"String\">Receiving  </Data></Cell>");
            wb.println("      <Cell ss:MergeDown=\"1\" ss:StyleID=\"s94\"><Data ss:Type=\"String\">Sold  </Data></Cell>");
            wb.println("      <Cell ss:MergeDown=\"1\" ss:StyleID=\"s94\"><Data ss:Type=\"String\">Retur  </Data></Cell>");
            wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s113\"><Data ss:Type=\"String\">Transfer</Data></Cell>");
            wb.println("      <Cell ss:MergeDown=\"1\" ss:StyleID=\"s94\"><Data ss:Type=\"String\">Adjustment  </Data></Cell>");
            wb.println("      <Cell ss:MergeDown=\"1\" ss:StyleID=\"m36321428\"><Data ss:Type=\"String\">Ending  </Data></Cell>");
            wb.println("      <Cell ss:MergeDown=\"1\" ss:StyleID=\"m39954176\"><Data ss:Type=\"String\">Selling Value  </Data></Cell>");
            wb.println("      <Cell ss:MergeDown=\"1\" ss:StyleID=\"s125\"><Data ss:Type=\"String\">Stock Value</Data></Cell>");
            wb.println("      </Row>");
            wb.println("      <Row>");
            wb.println("      <Cell ss:Index=\"9\" ss:StyleID=\"s110\"><Data ss:Type=\"String\">In</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s110\"><Data ss:Type=\"String\">Out</Data></Cell>");
            wb.println("      </Row>");

            double tot1 = 0;
            double tot2 = 0;
            double tot3 = 0;
            double tot4 = 0;
            double tot5 = 0;
            double tot6 = 0;
            double tot7 = 0;
            double tot8 = 0;
            double tot9 = 0;
            double tot10 = 0;
            for (int i = 0; i < result.size(); i++) {
                RptKonsinyasiBeli rsm = (RptKonsinyasiBeli) result.get(i);
                double stock = rsm.getBegining() + rsm.getReceiving() - rsm.getSold() - rsm.getRetur() + rsm.getTransferIn() - rsm.getTransferOut() + rsm.getAdjustment();
                double sellingV = rsm.getSold() * rsm.getCost();                
                double vEnding = stock * rsm.getCost();
                
                tot1 = tot1 + rsm.getBegining();
                tot2 = tot2 + rsm.getReceiving();
                tot3 = tot3 + rsm.getSold();
                tot4 = tot4 + rsm.getRetur();
                tot5 = tot5 + rsm.getTransferIn();
                tot6 = tot6 + rsm.getTransferOut();
                tot7 = tot7 + rsm.getAdjustment();
                tot8 = tot8 + stock;
                tot9 = tot9 + sellingV;
                tot10 = tot10 + vEnding;

                wb.println("      <Row>");
                wb.println("      <Cell ss:StyleID=\"s85\"><Data ss:Type=\"Number\">" + rsm.getSku() + "</Data></Cell>");
                wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"m54552644\"><Data ss:Type=\"String\">" + rsm.getItemName() + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s87\"><Data ss:Type=\"Number\">" + rsm.getCost() + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s87\"><Data ss:Type=\"Number\">" + rsm.getBegining() + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s87\"><Data ss:Type=\"Number\">" + rsm.getReceiving() + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s87\"><Data ss:Type=\"Number\">" + rsm.getSold() + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s87\"><Data ss:Type=\"Number\">" + rsm.getRetur() + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s87\"><Data ss:Type=\"Number\">" + rsm.getTransferIn() + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s87\"><Data ss:Type=\"Number\">" + rsm.getTransferOut() + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s87\"><Data ss:Type=\"Number\">" + rsm.getAdjustment() + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s87\"><Data ss:Type=\"Number\">" + stock + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s131i\"><Data ss:Type=\"Number\">" + sellingV + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s131i\"><Data ss:Type=\"Number\">" + vEnding + "</Data></Cell>");
                wb.println("      </Row>");
            }
            wb.println("      <Row>");
            wb.println("      <Cell ss:MergeAcross=\"3\" ss:StyleID=\"m54552584\"><Data ss:Type=\"String\">GRAND TOTAL</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s130\"><Data ss:Type=\"Number\">" + tot1 + "</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s130\"><Data ss:Type=\"Number\">" + tot2 + "</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s130\"><Data ss:Type=\"Number\">" + tot3 + "</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s130\"><Data ss:Type=\"Number\">" + tot4 + "</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s130\"><Data ss:Type=\"Number\">" + tot5 + "</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s130\"><Data ss:Type=\"Number\">" + tot6 + "</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s130\"><Data ss:Type=\"Number\">" + tot7 + "</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s130\"><Data ss:Type=\"Number\">" + tot8 + "</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s131i\"><Data ss:Type=\"Number\">" + tot9 + "</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s131i\"><Data ss:Type=\"Number\">" + tot10 + "</Data></Cell>");
            wb.println("      </Row>");
            wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"15.75\">");
            wb.println("      <Cell ss:MergeAcross=\"13\" ss:StyleID=\"s77\"><Data ss:Type=\"String\"></Data></Cell>");
            wb.println("      </Row>");
            String addrReport = DbSystemProperty.getValueByName("ADDRESS_REPORT");
            String month = "";
            if (new Date().getMonth() == 0) {
                month = "Januari";
            } else if (new Date().getMonth() == 1) {
                month = "Februari";
            } else if (new Date().getMonth() == 2) {
                month = "Maret";
            } else if (new Date().getMonth() == 3) {
                month = "April";
            } else if (new Date().getMonth() == 4) {
                month = "Mei";
            } else if (new Date().getMonth() == 5) {
                month = "Juni";
            } else if (new Date().getMonth() == 6) {
                month = "Juli";
            } else if (new Date().getMonth() == 7) {
                month = "Agustus";
            } else if (new Date().getMonth() == 8) {
                month = "September";
            } else if (new Date().getMonth() == 9) {
                month = "Oktober";
            } else if (new Date().getMonth() == 10) {
                month = "November";
            } else if (new Date().getMonth() == 11) {
                month = "Desember";
            }
            wb.println("      <Row>");
            wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s150\"><Data ss:Type=\"String\">Subtotal</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s142\"><Data ss:Type=\"String\">: Rp</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s162\"/>");
            wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s156\"><Data ss:Type=\"Number\">" + tot9 + "</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s64\"><Data ss:Type=\"String\"></Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s64\"><Data ss:Type=\"String\"></Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s64\"><Data ss:Type=\"String\"></Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s64\"><Data ss:Type=\"String\"></Data></Cell>");
            wb.println("      <Cell ss:MergeAcross=\"2\" ss:StyleID=\"s149\"><Data ss:Type=\"String\">" + addrReport + ", " +new Date().getDate() + " " + month + " " + (new Date().getYear() + 1900) +"</Data></Cell>");
            wb.println("      </Row>");

            wb.println("      <Row>");
            wb.println("      <Cell ss:StyleID=\"s178\"/>");
            wb.println("      <Cell ss:StyleID=\"s178\"/>");
            wb.println("      <Cell ss:StyleID=\"s142\"/>");
            wb.println("      <Cell ss:StyleID=\"s162\"/>");
            wb.println("      <Cell ss:StyleID=\"s179\"/>");
            wb.println("      <Cell ss:StyleID=\"s179\"/>");
            wb.println("      <Cell ss:StyleID=\"s64\"/>");
            wb.println("      <Cell ss:StyleID=\"s64\"/>");
            wb.println("      <Cell ss:StyleID=\"s64\"/>");
            wb.println("      <Cell ss:StyleID=\"s64\"/>");
            wb.println("      <Cell ss:StyleID=\"s142\"/>");
            wb.println("      <Cell ss:StyleID=\"s142\"/>");
            wb.println("      <Cell ss:StyleID=\"s185\"/>");
            wb.println("      </Row>");
            double ppn = 0;
            if (vendor.getIsPKP() == 1) {
                ppn = (tot9 * 10) / 100;
            }
            wb.println("      <Row>");
            wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s150\"><Data ss:Type=\"String\">Tax</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s142\"><Data ss:Type=\"String\">: Rp</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s162\"/>");
            wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s156\"><Data ss:Type=\"Number\">" + ppn + "</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s64\"><Data ss:Type=\"String\"></Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s64\"><Data ss:Type=\"String\"></Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s64\"><Data ss:Type=\"String\"></Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s64\"><Data ss:Type=\"String\"></Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s142\"><Data ss:Type=\"String\"></Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s142\"><Data ss:Type=\"String\"></Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s185\"/>");
            wb.println("      <Cell ss:Index=\"17\" ss:StyleID=\"s173\"/>");
            wb.println("      <Cell ss:StyleID=\"s173\"/>");
            wb.println("      </Row>");
            double totalBill = tot9 + ppn;
            wb.println("      <Row>");
            wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s150\"><Data ss:Type=\"String\">Total Bill</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s142\"><Data ss:Type=\"String\">: Rp</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s162\"/>");
            wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s156\"><Data ss:Type=\"Number\">" + totalBill + "</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s64\"><Data ss:Type=\"String\"></Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s64\"><Data ss:Type=\"String\"></Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s64\"><Data ss:Type=\"String\"></Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s64\"><Data ss:Type=\"String\"></Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s142\"><Data ss:Type=\"String\"></Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s142\"><Data ss:Type=\"String\"></Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s185\"/>");
            wb.println("      <Cell ss:Index=\"17\" ss:MergeAcross=\"1\" ss:StyleID=\"s174\"/>");
            wb.println("      </Row>");
            double promot = (totalBill / 100) * vendor.getPercentPromosi();
            wb.println("      <Row>");
            wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s150\"><Data ss:Type=\"String\">Promosi " + JSPFormater.formatNumber(vendor.getPercentPromosi(), "#,###") + " %</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s142\"><Data ss:Type=\"String\">: Rp</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s164\"><Data ss:Type=\"Number\">" + promot + "</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s64\"><Data ss:Type=\"String\"></Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s64\"><Data ss:Type=\"String\"></Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s64\"/>");
            wb.println("      <Cell ss:StyleID=\"s64\"><Data ss:Type=\"String\"></Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s64\"><Data ss:Type=\"String\"></Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s64\"><Data ss:Type=\"String\"></Data></Cell>");
            wb.println("      <Cell ss:MergeAcross=\"2\" ss:StyleID=\"s149\"><Data ss:Type=\"String\">" + user.getFullName() + "</Data></Cell>");
            wb.println("      <Cell ss:Index=\"17\" ss:StyleID=\"s173\"/>");
            wb.println("      <Cell ss:StyleID=\"s175\"/>");
            wb.println("      </Row>");
            double barcode = vendor.getPercentBarcode() * (tot2 + tot5);
            wb.println("      <Row>");
            wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s150\"><Data ss:Type=\"String\">Barcode @Rp." + JSPFormater.formatNumber(vendor.getPercentBarcode(), "#,###") + "</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s142\"><Data ss:Type=\"String\">: Rp</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s164\"><Data ss:Type=\"Number\">" + barcode + "</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s64\"><Data ss:Type=\"String\"></Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s64\"><Data ss:Type=\"String\"></Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s64\"><Data ss:Type=\"String\"></Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s64\"><Data ss:Type=\"String\"></Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s64\"><Data ss:Type=\"String\"></Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s64\"><Data ss:Type=\"String\"></Data></Cell>");
            wb.println("      <Cell ss:MergeAcross=\"2\" ss:StyleID=\"s149\"><Data ss:Type=\"String\"></Data></Cell>");
            wb.println("      <Cell ss:Index=\"17\" ss:StyleID=\"s173\"/>");
            wb.println("      <Cell ss:StyleID=\"s175\"/>");
            wb.println("      </Row>");
            double grandTotal = totalBill - promot - barcode;
            wb.println("      <Row>");
            wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s150\"><Data ss:Type=\"String\">Total Bayar</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s142\"><Data ss:Type=\"String\">: Rp</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s163\"/>");
            wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s156\"><Data ss:Type=\"Number\">" + grandTotal + "</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s64\"><Data ss:Type=\"String\"></Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s64\"><Data ss:Type=\"String\"></Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s64\"><Data ss:Type=\"String\"></Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s64\"><Data ss:Type=\"String\"></Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s64\"><Data ss:Type=\"String\"></Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s64\"><Data ss:Type=\"String\"></Data></Cell>");
            wb.println("      <Cell ss:Index=\"17\" ss:MergeAcross=\"1\" ss:StyleID=\"s176\"/>");
            wb.println("      </Row>");

        }
        wb.println("      <Row>");
        wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s177\"/>");
        wb.println("      </Row>");
        wb.println("      </Table>");
        wb.println("      <WorksheetOptions xmlns=\"urn:schemas-microsoft-com:office:excel\">");
        wb.println("      <PageSetup>");
        wb.println("      <Layout x:Orientation=\"Landscape\"/>");
        wb.println("      <Header x:Margin=\"0.3\"/>");
        wb.println("      <Footer x:Margin=\"0.3\"/>");
        wb.println("      <PageMargins x:Bottom=\"0.75\" x:Left=\"0.45\" x:Right=\"0.2\" x:Top=\"0.75\"/>");
        wb.println("      </PageSetup>");
        wb.println("      <Print>");
        wb.println("      <ValidPrinterInfo/>");
        wb.println("      <HorizontalResolution>300</HorizontalResolution>");
        wb.println("      <VerticalResolution>300</VerticalResolution>");
        wb.println("      </Print>");
        wb.println("      <Selected/>");
        wb.println("      <DoNotDisplayGridlines/>");
        wb.println("      <Panes>");
        wb.println("      <Pane>");
        wb.println("      <Number>3</Number>");
        wb.println("      <ActiveRow>15</ActiveRow>");
        wb.println("      <ActiveCol>16</ActiveCol>");
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
            String str = "";

            System.out.println(URLEncoder.encode(str, "UTF-8"));
        } catch (Exception e) {
            System.out.println(e.toString());
        }
    }
}
