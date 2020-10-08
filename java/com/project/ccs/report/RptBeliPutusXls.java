/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.ccs.report;

import com.project.ccs.posmaster.DbItemGroup;
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
import com.project.ccs.posmaster.ItemGroup;
import com.project.ccs.session.ReportParameter;
import com.project.ccs.session.RptBeliPutus;
import com.project.general.Company;
import com.project.general.DbCompany;
import com.project.general.DbLocation;
import com.project.general.DbVendor;
import com.project.general.Location;
import com.project.general.Vendor;
/**
 *
 * @author Roy Andika
 */
public class RptBeliPutusXls extends HttpServlet {

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
        ItemGroup ig = new ItemGroup();
        Location location = new Location();
        ReportParameter rp = new ReportParameter();
        Vector result = new Vector();
        HttpSession session = request.getSession();
        
        try {
            rp = (ReportParameter) session.getValue("REPORT_BELI_PUTUS");
        } catch (Exception e) {}

        Vendor vndx = new Vendor();
        try {
            vndx = DbVendor.fetchExc(rp.getVendorId());
        } catch (Exception e) {}

        try {
            location = DbLocation.fetchExc(rp.getLocationId());
        } catch (Exception e) {}

        try {
            ig = DbItemGroup.fetchExc(rp.getCategoryId());
        } catch (Exception e) {}
        
        try {
            result = (Vector) session.getValue("REPORT_BP");
        } catch (Exception e) {}

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
        if (lang == 0) {
            title = "LAPORAN BARANG BELI PUTUS";            
        } else {
            title = "LAPORAN BARANG BELI PUTUS";
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
        wb.println("      <Author>user</Author>");
        wb.println("      <LastAuthor>PNCI</LastAuthor>");
        wb.println("      <Created>2013-03-15T04:47:17Z</Created>");
        wb.println("      <LastSaved>2013-03-15T06:57:57Z</LastSaved>");
        wb.println("      <Version>12.00</Version>");
        wb.println("      </DocumentProperties>");
        wb.println("      <ExcelWorkbook xmlns=\"urn:schemas-microsoft-com:office:excel\">");
        wb.println("      <WindowHeight>8445</WindowHeight>");
        wb.println("      <WindowWidth>16215</WindowWidth>");
        wb.println("      <WindowTopX>360</WindowTopX>");
        wb.println("      <WindowTopY>105</WindowTopY>");
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
        wb.println("      <Style ss:ID=\"m40614080\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Top\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Double\" ss:Weight=\"3\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Dash\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Dash\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Double\" ss:Weight=\"3\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"m40614200\">");
        wb.println("      <Alignment ss:Vertical=\"Top\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Double\" ss:Weight=\"3\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Dash\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Dash\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Double\" ss:Weight=\"3\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"m40614220\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Top\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Double\" ss:Weight=\"3\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Dash\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Dash\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Double\" ss:Weight=\"3\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"m40614240\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Top\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Double\" ss:Weight=\"3\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Dash\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Dash\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Double\" ss:Weight=\"3\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s17\">");
        wb.println("      <NumberFormat ss:Format=\"Fixed\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s18\">");
        wb.println("      <NumberFormat ss:Format=\"#,##0\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s19\">");
        wb.println("      <Alignment ss:Horizontal=\"Right\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <NumberFormat ss:Format=\"Fixed\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s23\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Top\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Dash\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Dash\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Double\" ss:Weight=\"3\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s26\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Top\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Double\" ss:Weight=\"3\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Dash\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Dash\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <NumberFormat ss:Format=\"Fixed\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s27\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Top\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Double\" ss:Weight=\"3\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Dash\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Dash\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <NumberFormat ss:Format=\"#,##0\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s28\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Top\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Double\" ss:Weight=\"3\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Dash\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Dash\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s29\">");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Dash\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Dash\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Double\" ss:Weight=\"3\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s30\">");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Dash\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Dash\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Double\" ss:Weight=\"3\"/>");
        wb.println("      </Borders>");
        wb.println("      <NumberFormat ss:Format=\"Fixed\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s31\">");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Double\" ss:Weight=\"3\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Dash\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Dash\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s32\">");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Double\" ss:Weight=\"3\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Dash\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Dash\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <NumberFormat ss:Format=\"Fixed\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s33\">");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Double\" ss:Weight=\"3\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Dash\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Double\" ss:Weight=\"3\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s34\">");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Double\" ss:Weight=\"3\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Dash\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Dash\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Double\" ss:Weight=\"3\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s35\">");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Double\" ss:Weight=\"3\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Dash\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Dash\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Double\" ss:Weight=\"3\"/>");
        wb.println("      </Borders>");
        wb.println("      <NumberFormat ss:Format=\"Fixed\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s38\">");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Dash\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Dash\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s39\">");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Dash\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Dash\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <NumberFormat ss:Format=\"Fixed\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s40\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Dash\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Dash\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Double\" ss:Weight=\"3\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s41\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Dash\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Dash\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s42\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Double\" ss:Weight=\"3\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Dash\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Dash\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s100\">");
        wb.println("      <Alignment ss:Vertical=\"Bottom\"/>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s101\">");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Dash\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Dash\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Double\" ss:Weight=\"3\"/>");
        wb.println("      </Borders>");
        wb.println("      <NumberFormat ss:Format=\"#,##0.00_);\\(#,##0.00\\)\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s102\">");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Dash\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Dash\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <NumberFormat ss:Format=\"#,##0.00_);\\(#,##0.00\\)\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s103\">");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Double\" ss:Weight=\"3\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Dash\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Dash\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <NumberFormat ss:Format=\"#,##0.00_);\\(#,##0.00\\)\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s104\">");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Double\" ss:Weight=\"3\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Dash\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Dash\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Double\" ss:Weight=\"3\"/>");
        wb.println("      </Borders>");
        wb.println("      <NumberFormat ss:Format=\"#,##0.00_);\\(#,##0.00\\)\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s105\">");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Double\" ss:Weight=\"3\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Dash\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Double\" ss:Weight=\"3\"/>");
        wb.println("      </Borders>");
        wb.println("      <NumberFormat ss:Format=\"#,##0.00_);\\(#,##0.00\\)\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s110\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"12\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      </Styles>");
        wb.println("      <Worksheet ss:Name=\"Sheet1\">");
        wb.println("      <Table>");
        wb.println("      <Column ss:Index=\"2\" ss:AutoFitWidth=\"0\" ss:Width=\"75\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"117\"/>");
        wb.println("      <Column ss:StyleID=\"s17\" ss:AutoFitWidth=\"0\"/>");
        wb.println("      <Column ss:StyleID=\"s18\" ss:Width=\"53.25\" ss:Span=\"1\"/>");
        wb.println("      <Column ss:Index=\"7\" ss:StyleID=\"s17\" ss:AutoFitWidth=\"0\"/>");
        wb.println("      <Column ss:StyleID=\"s18\" ss:Width=\"54\"/>");
        wb.println("      <Column ss:Width=\"65.25\"/>");
        wb.println("      <Column ss:StyleID=\"s17\" ss:AutoFitWidth=\"0\"/>");
        wb.println("      <Column ss:StyleID=\"s18\" ss:Width=\"55.5\"/>");
        wb.println("      <Column ss:StyleID=\"s18\" ss:Width=\"65.25\"/>");
        wb.println("      <Column ss:Width=\"57\" ss:Span=\"1\"/>");
        wb.println("      <Column ss:Index=\"15\" ss:StyleID=\"s17\" ss:Width=\"48.75\"/>");
        wb.println("      <Column ss:StyleID=\"s17\" ss:AutoFitWidth=\"0\"/>");
        wb.println("      <Column ss:StyleID=\"s18\" ss:Width=\"53.25\" ss:Span=\"1\"/>");
        wb.println("      <Column ss:Index=\"19\" ss:StyleID=\"s17\" ss:AutoFitWidth=\"0\"/>");
        wb.println("      <Column ss:StyleID=\"s18\" ss:Width=\"54.75\"/>");
        wb.println("      <Column ss:StyleID=\"s18\" ss:Width=\"65.25\"/>");
        wb.println("      <Column ss:StyleID=\"s17\" ss:AutoFitWidth=\"0\" ss:Span=\"1\"/>");
        wb.println("      <Row ss:Height=\"15.75\">");
        wb.println("      <Cell ss:MergeAcross=\"22\" ss:StyleID=\"s100\"><Data ss:Type=\"String\">" + cmp.getName().toUpperCase() + "</Data></Cell>");
        wb.println("      </Row>");

        wb.println("      <Row ss:Index=\"3\">");
        wb.println("      <Cell ss:MergeAcross=\"22\" ss:StyleID=\"s100\"><Data ss:Type=\"String\">" + title.toUpperCase() + "</Data></Cell>");
        wb.println("      </Row>");

        if (location.getOID() > 0) {
            wb.println("      <Row>");
            wb.println("      <Cell ss:MergeAcross=\"22\" ss:StyleID=\"s100\"><Data ss:Type=\"String\"> LOCATION : " + location.getName().toUpperCase() + "</Data></Cell>");
            wb.println("      </Row>");
        }

        if (vndx.getOID() > 0) {
            wb.println("      <Row>");
            wb.println("      <Cell ss:MergeAcross=\"22\" ss:StyleID=\"s100\"><Data ss:Type=\"String\"> SUPLIER : " + vndx.getName().toUpperCase() + "</Data></Cell>");
            wb.println("      </Row>");
        }

        if (ig.getOID() > 0) {
            wb.println("      <Row>");
            wb.println("      <Cell ss:MergeAcross=\"22\" ss:StyleID=\"s100\"><Data ss:Type=\"String\"> GROUP : " + ig.getName().toUpperCase() + "</Data></Cell>");
            wb.println("      </Row>");
        }
        wb.println("      <Row>");
        wb.println("      <Cell ss:MergeAcross=\"22\" ss:StyleID=\"s100\"><Data ss:Type=\"String\"> PERIOD : " + strPeriode + "</Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row ss:Height=\"15.75\">");
        wb.println("      <Cell ss:Index=\"23\" ss:StyleID=\"s19\"/>");
        wb.println("      </Row>");

        if (result != null && result.size() > 0) {
            int nomor = 1;

            wb.println("      <Row ss:Height=\"15.75\">");
            wb.println("      <Cell ss:MergeDown=\"1\" ss:StyleID=\"m40614200\"><Data ss:Type=\"String\">No</Data></Cell>");
            wb.println("      <Cell ss:MergeDown=\"1\" ss:StyleID=\"m40614220\"><Data ss:Type=\"String\">Kode Inv</Data></Cell>");
            wb.println("      <Cell ss:MergeDown=\"1\" ss:StyleID=\"m40614240\"><Data ss:Type=\"String\">Nama Barang</Data></Cell>");
            wb.println("      <Cell ss:MergeAcross=\"2\" ss:StyleID=\"s23\"><Data ss:Type=\"String\">STOK AWAL</Data></Cell>");
            wb.println("      <Cell ss:MergeAcross=\"2\" ss:StyleID=\"s23\"><Data ss:Type=\"String\">PEMBELIAN</Data></Cell>");
            wb.println("      <Cell ss:MergeAcross=\"2\" ss:StyleID=\"s23\"><Data ss:Type=\"String\">PENJUALAN</Data></Cell>");
            wb.println("      <Cell ss:MergeDown=\"1\" ss:StyleID=\"m40614080\"><Data ss:Type=\"String\">COGS</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s23\"><Data ss:Type=\"String\">PROFIT</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s23\"><Data ss:Type=\"String\">%</Data></Cell>");
            wb.println("      <Cell ss:MergeAcross=\"2\" ss:StyleID=\"s23\"><Data ss:Type=\"String\">RETUR BELI</Data></Cell>");
            wb.println("      <Cell ss:MergeAcross=\"2\" ss:StyleID=\"s23\"><Data ss:Type=\"String\">SALDO AKHIR</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s23\"><Data ss:Type=\"String\">Koreksi</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s23\"><Data ss:Type=\"String\">S. Akhir</Data></Cell>");
            wb.println("      </Row>");


            wb.println("      <Row ss:Height=\"15.75\">");
            wb.println("      <Cell ss:Index=\"4\" ss:StyleID=\"s26\"><Data ss:Type=\"String\">QTY</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s27\"><Data ss:Type=\"String\">PRICE</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s27\"><Data ss:Type=\"String\">NILAI</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s26\"><Data ss:Type=\"String\">QTY</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s27\"><Data ss:Type=\"String\">PRICE</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s28\"><Data ss:Type=\"String\">NILAI</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s26\"><Data ss:Type=\"String\">QTY</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s27\"><Data ss:Type=\"String\">PRICE</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s27\"><Data ss:Type=\"String\">NILAI</Data></Cell>");
            wb.println("      <Cell ss:Index=\"14\" ss:StyleID=\"s28\"><Data ss:Type=\"String\">MARGIN</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s26\"><Data ss:Type=\"String\">Profit</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s26\"><Data ss:Type=\"String\">QTY</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s27\"><Data ss:Type=\"String\">PRICE</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s27\"><Data ss:Type=\"String\">NILAI</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s26\"><Data ss:Type=\"String\">QTY</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s27\"><Data ss:Type=\"String\">PRICE</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s27\"><Data ss:Type=\"String\">NILAI</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s26\"><Data ss:Type=\"String\">QTY</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s26\"><Data ss:Type=\"String\">REAL</Data></Cell>");
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

            double tot11 = 0;
            double tot12 = 0;
            double tot13 = 0;
            double tot14 = 0;
            double tot15 = 0;
            double tot16 = 0;
            double tot17 = 0;
            double tot18 = 0;
            double tot19 = 0;
            int max = result.size() - 1;

            for (int i = 0; i < result.size(); i++) {

                RptBeliPutus rptBeli = (RptBeliPutus)result.get(i);
                           
                tot1 = tot1 + rptBeli.getStockAwalQty();
                tot2 = tot2 + rptBeli.getStockAwalPrice();
                double tmpSA = 0;
                if(rptBeli.getStockAwalQty() == 0 ||  rptBeli.getStockAwalPrice() == 0){
                    tmpSA = 0;
                }else{
                    tmpSA = rptBeli.getStockAwalQty() * rptBeli.getStockAwalPrice();
                }
                tot3 = tot3 + tmpSA;

                tot4 = tot4 + rptBeli.getPembelianQty();
                tot5 = tot5 + rptBeli.getPembelianPrice();
                
                double tmpReceive = 0;
                if(rptBeli.getPembelianQty() == 0 || rptBeli.getPembelianPrice() == 0){
                    tmpReceive = 0;
                }else{
                    tmpReceive = rptBeli.getPembelianQty() * rptBeli.getPembelianPrice();
                }   
                tot6 = tot6 + tmpReceive;

                double soldx = rptBeli.getPenjualanQty() != 0 ? rptBeli.getPenjualanQty()*-1 : rptBeli.getPenjualanQty(); 
                
                tot7 = tot7 + soldx;
                tot8 = tot8 + rptBeli.getPenjualanPrice();
                
                double tmpPrice = 0;
                if(rptBeli.getPenjualanQty() == 0 || rptBeli.getPenjualanPrice() == 0){
                    tmpPrice = 0;
                }else{
                    tmpPrice = soldx * rptBeli.getPenjualanPrice();
                }
                
                tot9 = tot9 + tmpPrice;

                tot10 = tot10 + rptBeli.getCogs();
                double profit = tmpPrice - rptBeli.getCogs();
                
                tot11 = tot11 + profit;
                double persenProfit = 0;
                if(profit != 0 || tmpPrice != 0){
                    persenProfit = (profit/tmpPrice)*100;
                } 
                
                tot12 = tot12 + persenProfit;
                tot13 = tot13 + rptBeli.getReturQty();
                
                tot14 = tot14 + rptBeli.getReturPrice();
                double amountRetur = 0;
                if(rptBeli.getReturQty() != 0 && rptBeli.getReturPrice() != 0){
                    amountRetur = rptBeli.getReturQty()*rptBeli.getReturPrice();
                }   
                
                tot15 = tot15 + amountRetur;
                
                double saldoAkhir = rptBeli.getStockAwalQty() + rptBeli.getPembelianQty() + rptBeli.getPenjualanPrice() - rptBeli.getReturQty();
                
                tot16 = tot16 + saldoAkhir;
                tot17 = tot17 + rptBeli.getSaldoAkhirPrice();
                double amountSaldoAkhir = 0;
                if(saldoAkhir != 0 && rptBeli.getSaldoAkhirPrice() != 0 ){
                    amountSaldoAkhir = rptBeli.getSaldoAkhirPrice() * saldoAkhir;
                }
                
                tot18 = tot18 + amountSaldoAkhir;
                tot19 = tot19 + saldoAkhir;

                if (i == 0) {
                    wb.println("      <Row ss:Height=\"15.75\">");
                    wb.println("      <Cell ss:StyleID=\"s40\"><Data ss:Type=\"Number\">" + nomor + "</Data></Cell>");
                    nomor++;
                    wb.println("      <Cell ss:StyleID=\"s40\"><Data ss:Type=\"String\">" + rptBeli.getSku() + "</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s29\"><Data ss:Type=\"String\">" + rptBeli.getItemName() + "</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s30\"><Data ss:Type=\"Number\">" + rptBeli.getStockAwalQty() + "</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s101\"><Data ss:Type=\"Number\">" + rptBeli.getStockAwalPrice() + "</Data></Cell>");
                    
                    wb.println("      <Cell ss:StyleID=\"s101\"><Data ss:Type=\"Number\">" + tmpSA + "</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s30\"><Data ss:Type=\"Number\">" + rptBeli.getPembelianQty() + "</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s101\"><Data ss:Type=\"Number\">" + rptBeli.getPembelianPrice() + "</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s101\"><Data ss:Type=\"Number\">" + tmpReceive + "</Data></Cell>");
                    
                    wb.println("      <Cell ss:StyleID=\"s30\"><Data ss:Type=\"Number\">" + soldx + "</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s101\"><Data ss:Type=\"Number\">" + rptBeli.getPenjualanPrice() + "</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s101\"><Data ss:Type=\"Number\">" + tmpPrice + "</Data></Cell>");
                    
                    wb.println("      <Cell ss:StyleID=\"s101\"><Data ss:Type=\"Number\">" + rptBeli.getCogs() + "</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s101\"><Data ss:Type=\"Number\">" + profit + "</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s101\"><Data ss:Type=\"Number\">" + persenProfit + "</Data></Cell>");
                    
                    wb.println("      <Cell ss:StyleID=\"s30\"><Data ss:Type=\"Number\">" + rptBeli.getReturQty() + "</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s101\"><Data ss:Type=\"Number\">" + rptBeli.getReturPrice() + "</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s101\"><Data ss:Type=\"Number\">" + amountRetur + "</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s30\"><Data ss:Type=\"Number\">" + saldoAkhir + "</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s101\"><Data ss:Type=\"Number\">" + rptBeli.getSaldoAkhirPrice() + "</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s101\"><Data ss:Type=\"Number\">" + amountSaldoAkhir + "</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s30\"><Data ss:Type=\"String\"></Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s101\"><Data ss:Type=\"Number\">" + saldoAkhir + "</Data></Cell>");
                    wb.println("      </Row>");
                }

                if (i != 0 && i != max) {
                    wb.println("      <Row>");
                    wb.println("      <Cell ss:StyleID=\"s41\"><Data ss:Type=\"Number\">" + nomor + "</Data></Cell>");
                    nomor++;
                    wb.println("      <Cell ss:StyleID=\"s41\"><Data ss:Type=\"String\">" + rptBeli.getSku() + "</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s38\"><Data ss:Type=\"String\">" + rptBeli.getItemName() + "</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s39\"><Data ss:Type=\"Number\">" + rptBeli.getStockAwalQty() + "</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s102\"><Data ss:Type=\"Number\">" + rptBeli.getStockAwalPrice() + "</Data></Cell>");
                    
                    wb.println("      <Cell ss:StyleID=\"s102\"><Data ss:Type=\"Number\">" + tmpSA + "</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s39\"><Data ss:Type=\"Number\">" + rptBeli.getPembelianQty() + "</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s102\"><Data ss:Type=\"Number\">" + rptBeli.getPembelianPrice() + "</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s102\"><Data ss:Type=\"Number\">" + tmpReceive + "</Data></Cell>");
                    
                    wb.println("      <Cell ss:StyleID=\"s39\"><Data ss:Type=\"Number\">" + soldx + "</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s102\"><Data ss:Type=\"Number\">" + rptBeli.getPenjualanPrice() + "</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s102\"><Data ss:Type=\"Number\">" + tmpPrice + "</Data></Cell>");
                    
                    wb.println("      <Cell ss:StyleID=\"s102\"><Data ss:Type=\"Number\">" + rptBeli.getCogs() + "</Data></Cell>");
                    
                    wb.println("      <Cell ss:StyleID=\"s102\"><Data ss:Type=\"Number\">" + profit + "</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s102\"><Data ss:Type=\"Number\">" + persenProfit + "</Data></Cell>");
                    
                    wb.println("      <Cell ss:StyleID=\"s39\"><Data ss:Type=\"Number\">" + rptBeli.getReturQty() + "</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s102\"><Data ss:Type=\"Number\">" + rptBeli.getReturPrice() + "</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s102\"><Data ss:Type=\"Number\">" + amountRetur + "</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s39\"><Data ss:Type=\"Number\">" + saldoAkhir + "</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s102\"><Data ss:Type=\"Number\">" + rptBeli.getSaldoAkhirPrice() + "</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s102\"><Data ss:Type=\"Number\">" + amountSaldoAkhir + "</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s39\"><Data ss:Type=\"String\"></Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s102\"><Data ss:Type=\"Number\">" + saldoAkhir + "</Data></Cell>");
                    wb.println("      </Row>");
                }
                if (i == max) {
                    wb.println("      <Row ss:Height=\"15.75\">");
                    wb.println("      <Cell ss:StyleID=\"s42\"><Data ss:Type=\"Number\">" + nomor + "</Data></Cell>");
                    nomor++;
                    wb.println("      <Cell ss:StyleID=\"s42\"><Data ss:Type=\"String\">" + rptBeli.getSku() + "</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s31\"><Data ss:Type=\"String\">" + rptBeli.getItemName() + "</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s32\"><Data ss:Type=\"Number\">" + rptBeli.getStockAwalQty() + "</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s103\"><Data ss:Type=\"Number\">" + rptBeli.getStockAwalPrice() + "</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s103\"><Data ss:Type=\"Number\">" + tmpSA + "</Data></Cell>");
                    
                    wb.println("      <Cell ss:StyleID=\"s32\"><Data ss:Type=\"Number\">" + rptBeli.getPembelianQty() + "</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s103\"><Data ss:Type=\"Number\">" + rptBeli.getPembelianPrice() + "</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s103\"><Data ss:Type=\"Number\">" + tmpReceive + "</Data></Cell>");
                    
                    wb.println("      <Cell ss:StyleID=\"s32\"><Data ss:Type=\"Number\">" + soldx + "</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s103\"><Data ss:Type=\"Number\">" + rptBeli.getPenjualanPrice() + "</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s103\"><Data ss:Type=\"Number\">" + tmpPrice + "</Data></Cell>");
                    
                    wb.println("      <Cell ss:StyleID=\"s103\"><Data ss:Type=\"Number\">" + rptBeli.getCogs() + "</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s103\"><Data ss:Type=\"Number\">" + profit + "</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s103\"><Data ss:Type=\"Number\">" + persenProfit + "</Data></Cell>");
                    
                    wb.println("      <Cell ss:StyleID=\"s32\"><Data ss:Type=\"Number\">" + rptBeli.getReturQty() + "</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s103\"><Data ss:Type=\"Number\">" + rptBeli.getReturPrice() + "</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s103\"><Data ss:Type=\"Number\">" + amountRetur + "</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s32\"><Data ss:Type=\"Number\">" + saldoAkhir + "</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s103\"><Data ss:Type=\"Number\">" + rptBeli.getSaldoAkhirPrice() + "</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s103\"><Data ss:Type=\"Number\">" + amountSaldoAkhir + "</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s32\"><Data ss:Type=\"String\"></Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s103\"><Data ss:Type=\"Number\">" + saldoAkhir + "</Data></Cell>");
                    wb.println("      </Row>");
                }
            }
            wb.println("      <Row ss:Height=\"16.5\">");
            wb.println("      <Cell ss:StyleID=\"s33\"/>");
            wb.println("      <Cell ss:StyleID=\"s34\"/>");
            wb.println("      <Cell ss:StyleID=\"s34\"/>");
            wb.println("      <Cell ss:StyleID=\"s104\"><Data ss:Type=\"Number\">" + tot1 + "</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s104\"><Data ss:Type=\"Number\">" + tot2 + "</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s104\"><Data ss:Type=\"Number\">" + tot3 + "</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s104\"><Data ss:Type=\"Number\">" + tot4 + "</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s104\"><Data ss:Type=\"Number\">" + tot5 + "</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s103\"><Data ss:Type=\"Number\">" + tot6 + "</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s35\"><Data ss:Type=\"Number\">" + tot7 + "</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s104\"><Data ss:Type=\"Number\">" + tot8 + "</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s104\"><Data ss:Type=\"Number\">" + tot9 + "</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s103\"><Data ss:Type=\"Number\">" + tot10 + "</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s103\"><Data ss:Type=\"Number\">" + tot11 + "</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s104\"><Data ss:Type=\"Number\">" + tot12 + "</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s35\"><Data ss:Type=\"Number\">" + tot13 + "</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s104\"><Data ss:Type=\"Number\">" + tot14 + "</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s104\"><Data ss:Type=\"Number\">" + tot15 + "</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s35\"><Data ss:Type=\"Number\">" + tot16 + "</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s104\"><Data ss:Type=\"Number\">" + tot17 + "</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s104\"><Data ss:Type=\"Number\">" + tot18 + "</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s35\"><Data ss:Type=\"String\"></Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s105\"><Data ss:Type=\"Number\">" + tot19 + "</Data></Cell>");
            wb.println("      </Row>");
        }
        wb.println("      <Row ss:Height=\"15.75\"/>");
        wb.println("      </Table>");
        wb.println("      <WorksheetOptions xmlns=\"urn:schemas-microsoft-com:office:excel\">");
        wb.println("      <PageSetup>");
        wb.println("      <Header x:Margin=\"0.3\"/>");
        wb.println("      <Footer x:Margin=\"0.3\"/>");
        wb.println("      <PageMargins x:Bottom=\"0.75\" x:Left=\"0.7\" x:Right=\"0.7\" x:Top=\"0.75\"/>");
        wb.println("      </PageSetup>");
        wb.println("      <Print>");
        wb.println("      <ValidPrinterInfo/>");
        wb.println("      <HorizontalResolution>600</HorizontalResolution>");
        wb.println("      <VerticalResolution>600</VerticalResolution>");
        wb.println("      </Print>");
        wb.println("      <Selected/>");
        wb.println("      <Panes>");
        wb.println("      <Pane>");
        wb.println("      <Number>3</Number>");
        wb.println("      <ActiveRow>20</ActiveRow>");
        wb.println("      <ActiveCol>10</ActiveCol>");
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
