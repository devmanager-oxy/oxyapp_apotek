/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.fms.report;

import com.project.I_Project;
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
import com.project.fms.master.*;
import com.project.payroll.*;
import com.project.util.jsp.*;
import com.project.fms.session.*;

import com.project.general.Company;
import com.project.general.DbCompany;
import com.project.general.DbVendor;
import com.project.general.Vendor;

/**
 *
 * @author Roy
 */
public class RptInvoiceXLS extends HttpServlet {

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
        long vendorId = 0;
        Vendor v = new Vendor();

        try {
            vendorId = JSPRequestValue.requestLong(request, "vendorId");
            if (vendorId != 0) {
                v = DbVendor.fetchExc(vendorId);
            }
        } catch (Exception e) {
        }

        // Load Company
        Company company = DbCompany.getCompany();

        Vector list = new Vector(1, 1);
        try {
            HttpSession session = request.getSession();
            list = (Vector) session.getValue("REPORT_PRINT_INVOICE_ARCHIVE");
        } catch (Exception e) {
            System.out.println(e);
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
        wb.println("      <Author>Roy</Author>");
        wb.println("      <LastAuthor>Roy</LastAuthor>");
        wb.println("      <Created>2014-07-22T18:04:28Z</Created>");
        wb.println("      <LastSaved>2014-07-22T18:14:53Z</LastSaved>");
        wb.println("      <Version>12.00</Version>");
        wb.println("      </DocumentProperties>");
        wb.println("      <ExcelWorkbook xmlns=\"urn:schemas-microsoft-com:office:excel\">");
        wb.println("      <WindowHeight>7935</WindowHeight>");
        wb.println("      <WindowWidth>20055</WindowWidth>");
        wb.println("      <WindowTopX>240</WindowTopX>");
        wb.println("      <WindowTopY>75</WindowTopY>");
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
        wb.println("      <Style ss:ID=\"s68\">");
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
        wb.println("      <Style ss:ID=\"s69\">");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s71\">");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <NumberFormat ss:Format=\"Standard\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s73\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s75\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <NumberFormat ss:Format=\"@\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s76\">");
        wb.println("      <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Bottom\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s81\">");
        wb.println("      <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Top\"/>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"14\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s83\">");
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
        wb.println("      <Table>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"29.25\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"86.25\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"91.5\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"99\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"99.75\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"183.75\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"106.5\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"94.5\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"105\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"87\"/>");
        wb.println("      <Row ss:Index=\"2\" ss:Height=\"18.75\">");
        wb.println("      <Cell ss:MergeAcross=\"9\" ss:StyleID=\"s81\"><Data ss:Type=\"String\">" + company.getName().toUpperCase() + "</Data></Cell>");
        wb.println("      </Row>");
        if (v.getOID() != 0) {
            wb.println("      <Row>");
            wb.println("      <Cell ss:MergeAcross=\"9\" ss:StyleID=\"s76\"><Data ss:Type=\"String\">Suplier : " + v.getName() + "</Data></Cell>");
            wb.println("      </Row>");
        }

        wb.println("      <Row>");
        wb.println("      <Cell ss:MergeAcross=\"9\" ss:StyleID=\"s76\"><Data ss:Type=\"String\"></Data></Cell>");
        wb.println("      </Row>");

        wb.println("      <Row >");
        wb.println("      <Cell ss:StyleID=\"s68\"><Data ss:Type=\"String\">No </Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s68\"><Data ss:Type=\"String\">Nomor Faktur </Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s68\"><Data ss:Type=\"String\">Faktur/DO </Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s68\"><Data ss:Type=\"String\">Tanggal </Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s68\"><Data ss:Type=\"String\">Batas Pembayaran </Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s68\"><Data ss:Type=\"String\">Suplier </Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s68\"><Data ss:Type=\"String\">Jumlah Hutang </Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s68\"><Data ss:Type=\"String\">Terbayar </Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s68\"><Data ss:Type=\"String\">Sisa Hutang </Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s68\"><Data ss:Type=\"String\">Status</Data></Cell>");
        wb.println("      </Row>");

        if (list != null && list.size() > 0) {
            double totHutang = 0;
            double totTerbayar = 0;
            double totBalance = 0;
            for (int i = 0; i < list.size(); i++) {
                InvoiceArchive ia = (InvoiceArchive)list.get(i);
                totHutang = totHutang + ia.getHutang();
                totTerbayar = totTerbayar + ia.getTerbayar();
                double balance = ia.getHutang() - ia.getTerbayar();
                totBalance = totBalance + balance;

                wb.println("      <Row>");
                wb.println("      <Cell ss:StyleID=\"s73\"><Data ss:Type=\"Number\">" + (i + 1) + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s73\"><Data ss:Type=\"String\">" + ia.getNomorInoice() + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s69\"><Data ss:Type=\"String\">" + ia.getNomorDo() + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s75\"><Data ss:Type=\"String\">" + JSPFormater.formatDate(ia.getTanggal(), "dd MMMM yyyy") + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s75\"><Data ss:Type=\"String\">" + JSPFormater.formatDate(ia.getBatasPembayaran(), "dd MMMM yyyy") + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s69\"><Data ss:Type=\"String\">" + ia.getVendor() + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s71\"><Data ss:Type=\"Number\">" + ia.getHutang() + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s71\"><Data ss:Type=\"Number\">" + ia.getTerbayar() + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s71\"><Data ss:Type=\"Number\">" + balance + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s73\"><Data ss:Type=\"String\">" + I_Project.invStatusStr[ia.getStatus()] +"</Data></Cell>");
                wb.println("      </Row>");
            }

            wb.println("      <Row>");
            wb.println("      <Cell ss:MergeAcross=\"5\" ss:StyleID=\"s68\"><Data ss:Type=\"String\">T O T A L</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s83\"><Data ss:Type=\"Number\">" + totHutang + "</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s83\"><Data ss:Type=\"Number\">" + totTerbayar + "</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s83\"><Data ss:Type=\"Number\">" + totBalance + "</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s69\"/>");
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
        wb.println("      <ActiveRow>16</ActiveRow>");
        wb.println("      <ActiveCol>6</ActiveCol>");
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
