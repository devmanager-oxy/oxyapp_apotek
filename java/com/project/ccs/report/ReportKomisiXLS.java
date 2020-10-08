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
 * @author Roy
 */
public class ReportKomisiXLS extends HttpServlet {

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
        //Vector result = new Vector();

        long userId = 0;
        User user = new User();
        ReportParameter rp = new ReportParameter();
        Vendor vendor = new Vendor();
        Location location = new Location();
        Vector resultDeduction = new Vector();
        Vector resultDetail = new Vector();

        HttpSession session = request.getSession();

        try {
            rp = (ReportParameter) session.getValue("REPORT_KOMISI");
        } catch (Exception e) {
        }

        try {
            resultDetail = (Vector) session.getValue("REPORT_KOMISI_DETAIL");
        } catch (Exception e) {
        }

        try {
            resultDeduction = (Vector) session.getValue("REPORT_KOMISI_DEDUCTION");
        } catch (Exception e) {
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
        wb.println("      <Author>Roy</Author>");
        wb.println("      <LastAuthor>Roy</LastAuthor>");
        wb.println("      <LastPrinted>2015-02-20T19:16:05Z</LastPrinted>");
        wb.println("      <Created>2015-02-20T18:42:50Z</Created>");
        wb.println("      <LastSaved>2015-02-20T19:05:09Z</LastSaved>");
        wb.println("      <Version>12.00</Version>");
        wb.println("      </DocumentProperties>");
        wb.println("      <ExcelWorkbook xmlns=\"urn:schemas-microsoft-com:office:excel\">");
        wb.println("      <WindowHeight>8445</WindowHeight>");
        wb.println("      <WindowWidth>20055</WindowWidth>");
        wb.println("      <WindowTopX>240</WindowTopX>");
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
        wb.println("      <Style ss:ID=\"s16\" ss:Name=\"Comma\">");
        wb.println("      <NumberFormat ss:Format=\"_(* #,##0.00_);_(* \\(#,##0.00\\);_(* &quot;-&quot;??_);_(@_)\"/>");
        wb.println("      </Style>");
        
        wb.println("      <Style ss:ID=\"s67\">");
        wb.println("      <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Top\"/>");
        wb.println("      </Style>");
        
        wb.println("      <Style ss:ID=\"s67i\">");
        wb.println("      <Alignment ss:Horizontal=\"Right\" ss:Vertical=\"Top\"/>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"");
        wb.println("      />");
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
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s73\">");
        wb.println("      <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Top\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s78\">");
        wb.println("      <Alignment ss:Horizontal=\"Right\" ss:Vertical=\"Bottom\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s79\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <NumberFormat ss:Format=\"@\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s80\">");
        wb.println("      <NumberFormat ss:Format=\"@\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s81\" ss:Parent=\"s16\">");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s82\" ss:Parent=\"s16\">");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s83\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        
        wb.println("      <Style ss:ID=\"s85\">");
        wb.println("      <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Center\"/>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      </Style>");
        
        wb.println("      <Style ss:ID=\"s86\">");
        wb.println("      <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Top\"/>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s87\">");
        wb.println("      <Alignment ss:Horizontal=\"Right\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s88\" ss:Parent=\"s16\">");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      </Styles>");
        wb.println("      <Worksheet ss:Name=\"Sheet1\">");
        wb.println("      <Table ss:DefaultRowHeight=\"15\">");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"24.75\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"65.25\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"142.5\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"33\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"84.75\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"54.75\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"85.5\"/>");
        wb.println("      <Row >");
        wb.println("      <Cell ss:MergeAcross=\"6\" ss:StyleID=\"s67i\"><Data ss:Type=\"String\">Printed by : " + user.getFullName() + ",Date : " + JSPFormater.formatDate(new Date(), "dd MMM yyyy HH:mm:ss") + "</Data></Cell>");
        wb.println("      </Row>");        
        wb.println("      <Row>");
        wb.println("      <Cell ss:MergeAcross=\"6\" ss:StyleID=\"s85\"><Data ss:Type=\"String\">" + cmp.getName().toUpperCase() + "</Data></Cell>");
        wb.println("      </Row>");
        if(cmp.getAddress() != null && cmp.getAddress().length() > 0){
        wb.println("      <Row>");
        wb.println("      <Cell ss:MergeAcross=\"6\" ss:StyleID=\"s85\"><Data ss:Type=\"String\">" + cmp.getAddress().toUpperCase() + "</Data></Cell>");
        wb.println("      </Row>");
        }        
        wb.println("      <Row>");
        wb.println("      <Cell ss:MergeAcross=\"6\" ss:StyleID=\"s85\"><Data ss:Type=\"String\">" + title.toUpperCase() + "</Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row >");
        wb.println("      <Cell ss:MergeAcross=\"6\" ss:StyleID=\"s67\"><Data ss:Type=\"String\"></Data></Cell>");
        wb.println("      </Row>");
        
        wb.println("      <Row >");
        wb.println("      <Cell ss:MergeAcross=\"6\" ss:StyleID=\"s85\"><Data ss:Type=\"String\">" + langCT[2] + " : " + vendor.getName().toUpperCase() + "</Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row >");
        wb.println("      <Cell ss:MergeAcross=\"6\" ss:StyleID=\"s85\"><Data ss:Type=\"String\">" + langCT[1] + " : " + strPeriode.toUpperCase() + "</Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row >");
        wb.println("      <Cell ss:MergeAcross=\"6\" ss:StyleID=\"s85\"><Data ss:Type=\"String\">" + langCT[0] + " : " + location.getName().toUpperCase() + "</Data></Cell>");
        wb.println("      </Row>");
        
        wb.println("      <Row >");
        wb.println("      <Cell ss:MergeAcross=\"6\" ss:StyleID=\"s67\"><Data ss:Type=\"String\"></Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row >");
        wb.println("      <Cell ss:StyleID=\"s83\"><Data ss:Type=\"String\">No</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s83\"><Data ss:Type=\"String\">Date</Data></Cell>");
        wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s83\"><Data ss:Type=\"String\">Item Name</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s83\"><Data ss:Type=\"String\">Qty</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s83\"><Data ss:Type=\"String\">UoM</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s83\"><Data ss:Type=\"String\">Amount</Data></Cell>");
        wb.println("      </Row>");
        if (resultDetail != null && resultDetail.size() > 0) {
            double tot = 0;
            for (int i = 0; i < resultDetail.size(); i++) {
                ReportKomisi rKom = (ReportKomisi) resultDetail.get(i);

                wb.println("      <Row>");
                wb.println("      <Cell ss:StyleID=\"s71\"><Data ss:Type=\"Number\">" + (i + 1) + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s79\"><Data ss:Type=\"String\">" + JSPFormater.formatDate(rKom.getTanggal(), "yyyy-MM-dd") + "</Data></Cell>");
                wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s73\"><Data ss:Type=\"String\">" + rKom.getName() + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s82\"><Data ss:Type=\"Number\">" + rKom.getQty() + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s69\"><Data ss:Type=\"String\">" + rKom.getStn() + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s82\"><Data ss:Type=\"Number\">" + rKom.getSellingPrice() + "</Data></Cell>");
                wb.println("      </Row>");
                tot = tot + rKom.getSellingPrice();
            }
            wb.println("      <Row >");
            wb.println("      <Cell ss:MergeAcross=\"6\" ss:StyleID=\"s67\"><Data ss:Type=\"String\"></Data></Cell>");
            wb.println("      </Row>");
            wb.println("      <Row >");
            wb.println("      <Cell ss:MergeAcross=\"4\" ss:StyleID=\"s67\"><Data ss:Type=\"String\">Total Sales</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s78\"><Data ss:Type=\"String\">Rp.</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s81\"><Data ss:Type=\"Number\">" + tot + "</Data></Cell>");
            wb.println("      </Row>");
            double vatOut = 0;
            if (vendor.getIsPKP() == 1) {
                vatOut = tot - (100 * tot / 110);
            }

            double margin = (vendor.getKomisiMargin() / 100) * (tot - vatOut);
            double net = tot - margin - vatOut;
            double vatIn = 0;
            if (vendor.getIsPKP() == 1) {
                vatIn = net * 10 / 100;
            }
            double subTotal2 = net + vatIn;
            wb.println("      <Row >");
            wb.println("      <Cell ss:MergeAcross=\"4\" ss:StyleID=\"s67\"><Data ss:Type=\"String\">VAT Out</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s78\"><Data ss:Type=\"String\">Rp.</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s81\"><Data ss:Type=\"Number\">" + vatOut + "</Data></Cell>");
            wb.println("      </Row>");
            wb.println("      <Row >");
            wb.println("      <Cell ss:MergeAcross=\"4\" ss:StyleID=\"s67\"><Data ss:Type=\"String\">Commision " + vendor.getKomisiMargin() + "%</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s78\"><Data ss:Type=\"String\">Rp.</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s81\"><Data ss:Type=\"Number\">" + margin + "</Data></Cell>");
            wb.println("      </Row>");
            wb.println("      <Row >");
            wb.println("      <Cell ss:MergeAcross=\"4\" ss:StyleID=\"s67\"><Data ss:Type=\"String\">Subtotal 1</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s78\"><Data ss:Type=\"String\">Rp.</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s81\"><Data ss:Type=\"Number\">" + net + "</Data></Cell>");
            wb.println("      </Row>");
            wb.println("      <Row >");
            wb.println("      <Cell ss:MergeAcross=\"4\" ss:StyleID=\"s67\"><Data ss:Type=\"String\">VAT In</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s78\"><Data ss:Type=\"String\">Rp.</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s81\"><Data ss:Type=\"Number\">" + vatIn + "</Data></Cell>");
            wb.println("      </Row>");
            wb.println("      <Row >");
            wb.println("      <Cell ss:MergeAcross=\"4\" ss:StyleID=\"s67\"><Data ss:Type=\"String\">Subtotal 2</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s78\"><Data ss:Type=\"String\">Rp.</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s81\"><Data ss:Type=\"Number\">" + subTotal2 + "</Data></Cell>");
            wb.println("      </Row>");

            double totalDeduction = 0;

            if (resultDeduction != null && resultDeduction.size() > 0) {
                wb.println("      <Row>");
                wb.println("      <Cell ss:MergeAcross=\"4\" ss:StyleID=\"s67\"><Data ss:Type=\"String\">Deduction</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s78\"><Data ss:Type=\"String\"></Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s81\"><Data ss:Type=\"String\"></Data></Cell>");
                wb.println("      </Row>");
                for (int t = 0; t < resultDeduction.size(); t++) {
                    ReportKomisi rDeduction = (ReportKomisi) resultDeduction.get(t);

                    wb.println("      <Row>");
                    wb.println("      <Cell ss:Index=\"2\"><Data ss:Type=\"String\">" + rDeduction.getName() + "</Data></Cell>");
                    if (rDeduction.getName().compareToIgnoreCase("Promotion") == 0) {
                        wb.println("      <Cell><Data ss:Type=\"String\">" + rDeduction.getQty() + " % x Rp " + JSPFormater.formatNumber(rDeduction.getSellingPrice(), "###,###.##") + "</Data></Cell>");
                        wb.println("      <Cell ss:StyleID=\"s80\"><Data ss:Type=\"String\">= Rp.</Data></Cell>");
                        wb.println("      <Cell ss:StyleID=\"s81\"><Data ss:Type=\"Number\">" + ((rDeduction.getQty() / 100) * rDeduction.getSellingPrice()) + "</Data></Cell>");
                        wb.println("      </Row>");
                        totalDeduction = totalDeduction + ((rDeduction.getQty() / 100) * rDeduction.getSellingPrice());
                    } else {
                        wb.println("      <Cell><Data ss:Type=\"String\">" + JSPFormater.formatNumber(rDeduction.getQty(), "###,###.##") + " x Rp " + JSPFormater.formatNumber(rDeduction.getSellingPrice(), "###,###.##") + "</Data></Cell>");
                        wb.println("      <Cell ss:StyleID=\"s80\"><Data ss:Type=\"String\">= Rp.</Data></Cell>");
                        wb.println("      <Cell ss:StyleID=\"s81\"><Data ss:Type=\"Number\">" + (rDeduction.getQty() * rDeduction.getSellingPrice()) + "</Data></Cell>");
                        wb.println("      </Row>");
                        totalDeduction = totalDeduction + (rDeduction.getQty() * rDeduction.getSellingPrice());
                    }


                }
                wb.println("      <Row >");
                wb.println("      <Cell ss:MergeAcross=\"4\" ss:StyleID=\"s67\"><Data ss:Type=\"String\">Total Deduction</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s78\"><Data ss:Type=\"String\">Rp.</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s81\"><Data ss:Type=\"Number\">" + totalDeduction + "</Data></Cell>");
                wb.println("      </Row>");
            }

            wb.println("      <Row>");
            wb.println("      <Cell ss:MergeAcross=\"4\" ss:StyleID=\"s86\"><Data ss:Type=\"String\">Grand Total</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s87\"><Data ss:Type=\"String\">Rp.</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s88\"><Data ss:Type=\"Number\">" + (subTotal2 - totalDeduction) + "</Data></Cell>");
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
        wb.println("      <HorizontalResolution>120</HorizontalResolution>");
        wb.println("      <VerticalResolution>72</VerticalResolution>");
        wb.println("      </Print>");
        wb.println("      <Selected/>");
        wb.println("      <DoNotDisplayGridlines/>");
        wb.println("      <Panes>");
        wb.println("      <Pane>");
        wb.println("      <Number>3</Number>");
        wb.println("      <ActiveRow>12</ActiveRow>");
        wb.println("      <ActiveCol>10</ActiveCol>");
        wb.println("      </Pane>");
        wb.println("      </Panes>");
        wb.println("      <ProtectObjects>False</ProtectObjects>");
        wb.println("      <ProtectScenarios>False</ProtectScenarios>");
        wb.println("      </WorksheetOptions>");
        wb.println("      </Worksheet>");
        wb.println("      <Worksheet ss:Name=\"Sheet2\">");
        wb.println("      <Table ss:DefaultRowHeight=\"15\">");
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
        wb.println("      <Table ss:DefaultRowHeight=\"15\">");
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
        } catch (Exception e) {
            System.out.println(e.toString());
        }
    }
}
