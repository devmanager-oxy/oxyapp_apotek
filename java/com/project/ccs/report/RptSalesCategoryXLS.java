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

import com.project.util.jsp.*;
import com.project.fms.ar.*;
import com.project.fms.master.*;
import com.project.ccs.session.ReportParameter;
import com.project.ccs.session.RptSalesCategory;
import com.project.ccs.session.SessReportSales;
import com.project.general.Company;
import com.project.general.DbCompany;
import com.project.general.*;
import com.project.util.JSPFormater;
import com.project.ccs.posmaster.*;
import java.util.Hashtable;

/**
 *
 * @author Roy Andika
 */
public class RptSalesCategoryXLS extends HttpServlet {

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
        Vector result = new Vector();
        ReportParameter rp = new ReportParameter();
        Vector vresult =  new Vector();
        try {
            HttpSession session = request.getSession();
            vresult = (Vector) session.getValue("V_SALES_CATEGORY");
            rp = (ReportParameter) session.getValue("REPORT_SALES_CATEGORY");
            
        } catch (Exception e) {
        }

        int type = JSPRequestValue.requestInt(request, "type_sub");

        try {
            //result = SessReportSales.listSalesReportBySubCategory(rp.getDateFrom(), rp.getDateTo(), rp.getLocationId(), rp.getCategoryId(), rp.getVendorId());
        } catch (Exception e) {
            System.out.println(e.toString());
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
        wb.println("      <LastAuthor>PNCI</LastAuthor>");
        wb.println("      <Created>2013-03-23T13:47:19Z</Created>");
        wb.println("      <LastSaved>2013-03-23T13:59:24Z</LastSaved>");
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
        wb.println("      <Style ss:ID=\"m14971796\">");
        wb.println("      <Alignment ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"m14971816\">");
        wb.println("      <Alignment ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s67\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s69\">");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s70\">");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <NumberFormat ss:Format=\"#,##0\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s76\">");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s82\">");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <NumberFormat ss:Format=\"#,##0\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s87\">");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      </Styles>");
        wb.println("      <Worksheet ss:Name=\"Sheet1\">");

        wb.println("      <Table >");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"55.5\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"86.25\"/>");
        if (type == 1) {
            wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"70\"/>");
        }
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"64.5\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"165.75\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"165.75\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"45.75\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"63\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"58.5\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"58.5\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"26.25\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"75.75\"/>");
        wb.println("      <Row ss:Index=\"2\">");
        wb.println("      <Cell ss:StyleID=\"s87\"><Data ss:Type=\"String\">" + cmp.getName().toUpperCase() + "</Data></Cell>");
        wb.println("      </Row>");
        String period = JSPFormater.formatDate(rp.getDateFrom(), "dd-MMM-yyyy") + " To " + JSPFormater.formatDate(rp.getDateTo(), "dd-MMM-yyyy");
        wb.println("      <Row>");
        wb.println("      <Cell ss:StyleID=\"s87\"><Data ss:Type=\"String\">" + period.toUpperCase() + "</Data></Cell>");
        wb.println("      </Row>");
        for(int k=0;k<vresult.size();k++){
            String locName="";
                    Vector vvresult= new Vector();
                    vvresult = (Vector)vresult.get(k);
                    result = new Vector();    
                    result=(Vector) vvresult.get(1);
                    locName=vvresult.get(0).toString();
        if (locName.length() > 0) {
            wb.println("      <Row>");
            wb.println("      <Cell ss:StyleID=\"s87\"><Data ss:Type=\"String\">STORE : " + locName + "</Data></Cell>");
            wb.println("      </Row>   ");
        }
        wb.println("      <Row >");
        wb.println("      <Cell ss:StyleID=\"s67\"><Data ss:Type=\"String\">CODE  </Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s67\"><Data ss:Type=\"String\">CATEGORY  </Data></Cell>");
        if (type == 1) {
            wb.println("      <Cell ss:StyleID=\"s67\"><Data ss:Type=\"String\">SUB CATEGOORY</Data></Cell>");
        }
        wb.println("      <Cell ss:StyleID=\"s67\"><Data ss:Type=\"String\">SKU  </Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s67\"><Data ss:Type=\"String\">ITEM NAME  </Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s67\"><Data ss:Type=\"String\">VENDOR  </Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s67\"><Data ss:Type=\"String\">QTY  </Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s67\"><Data ss:Type=\"String\">PRICE  </Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s67\"><Data ss:Type=\"String\">DISKON  </Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s67\"><Data ss:Type=\"String\">TOTAL  </Data></Cell>");
        wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s67\"><Data ss:Type=\"String\">TOTAL</Data></Cell>");
        wb.println("      </Row>");

        long itemCategoryId = 0;
        double jum = 0;
        double prc = 0;

        double gJum = 0;
        double gPrc = 0;

        Vector subcategorys = DbItemCategory.list(0, 0, "", DbItemCategory.colNames[DbItemCategory.COL_NAME]);
        Hashtable hascategorys = new Hashtable();
        if (subcategorys != null && subcategorys.size() > 0) {
            for (int x = 0; x < subcategorys.size(); x++) {
                ItemCategory ic = (ItemCategory) subcategorys.get(x);
                hascategorys.put("" + ic.getOID(), "" + ic.getName());
            }
        }

        for (int i = 0; i < result.size(); i++) {

            RptSalesCategory rsc = (RptSalesCategory) result.get(i);
            double jumlah = rsc.getJumlah();

            double total = (jumlah * rsc.getSelling()) - rsc.getDiskon();

            if (itemCategoryId != rsc.getCategoriId() && itemCategoryId != 0) {

                wb.println("      <Row>");
                wb.println("      <Cell ss:StyleID=\"s67\"/>");
                wb.println("      <Cell ss:StyleID=\"s69\"/>");
                if (type == 1) {
                    wb.println("      <Cell ss:StyleID=\"s67\"/>");
                }
                wb.println("      <Cell ss:StyleID=\"s67\"/>");
                wb.println("      <Cell ss:StyleID=\"s69\"/>");
                wb.println("      <Cell ss:StyleID=\"s69\"/>");
                wb.println("      <Cell ss:StyleID=\"s67\"><Data ss:Type=\"Number\">" + jum + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s69\"/>");
                wb.println("      <Cell ss:StyleID=\"s76\"/>");
                wb.println("      <Cell ss:StyleID=\"s76\"/>");
                wb.println("      <Cell ss:StyleID=\"s76\"><Data ss:Type=\"String\">Rp.</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s82\"><Data ss:Type=\"Number\">" + prc + "</Data></Cell>");
                wb.println("      </Row>");

                jum = 0;
                prc = 0;

            }

            jum = jum + jumlah;
            prc = prc + total;
            gJum = gJum + jumlah;
            gPrc = gPrc + total;

            String strCategory = "";
            String strCode = "";
            if (itemCategoryId != rsc.getCategoriId()) {
                strCategory = rsc.getCategory();
                strCode = rsc.getCode();
            }

            String vendor = "-";
            if (rsc.getVendor() != null && rsc.getVendor().length() > 0) {
                vendor = rsc.getVendor();
            }

            wb.println("      <Row>");
            wb.println("      <Cell ss:StyleID=\"s67\"><Data ss:Type=\"String\">" + strCode + "</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s69\"><Data ss:Type=\"String\">" + strCategory + "</Data></Cell>");
            if (type == 1) {
                String sub = "";
                try {
                    sub = String.valueOf(hascategorys.get("" + rsc.getSubCategoryId()));
                } catch (Exception e) {
                }
                wb.println("      <Cell ss:StyleID=\"s69\"><Data ss:Type=\"String\">" + sub + "</Data></Cell>");
            }
            wb.println("      <Cell ss:StyleID=\"s67\"><Data ss:Type=\"String\">" + rsc.getSku() + "</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s69\"><Data ss:Type=\"String\">" + rsc.getName() + "</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s69\"><Data ss:Type=\"String\">" + vendor + "</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s67\"><Data ss:Type=\"Number\">" + jumlah + "</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s70\"><Data ss:Type=\"Number\">" + rsc.getSelling() + "</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s70\"><Data ss:Type=\"Number\">" + rsc.getDiskon() + "</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s70\"><Data ss:Type=\"Number\">" + total + "</Data></Cell>");
            wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"m14971796\"><Data ss:Type=\"String\"></Data></Cell>");
            wb.println("      </Row>");
            itemCategoryId = rsc.getCategoriId();

        }

        wb.println("      <Row>");
        wb.println("      <Cell ss:StyleID=\"s67\"/>");
        wb.println("      <Cell ss:StyleID=\"s69\"/>");
        if (type == 1) {
            wb.println("      <Cell ss:StyleID=\"s67\"/>");
        }
        wb.println("      <Cell ss:StyleID=\"s67\"/>");
        wb.println("      <Cell ss:StyleID=\"s69\"/>");
        wb.println("      <Cell ss:StyleID=\"s69\"/>");
        wb.println("      <Cell ss:StyleID=\"s67\"><Data ss:Type=\"Number\">" + jum + "</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s69\"/>");
        wb.println("      <Cell ss:StyleID=\"s76\"/>");
        wb.println("      <Cell ss:StyleID=\"s76\"/>");
        wb.println("      <Cell ss:StyleID=\"s76\"><Data ss:Type=\"String\">Rp.</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s82\"><Data ss:Type=\"Number\">" + prc + "</Data></Cell>");
        wb.println("      </Row>");

        wb.println("      <Row >");
        wb.println("      <Cell ss:MergeAcross=\"4\" ss:StyleID=\"s67\"><Data ss:Type=\"String\">GRAND TOTAL</Data></Cell>");
        if (type == 1) {
            wb.println("      <Cell ss:StyleID=\"s69\"/>");
        }
        wb.println("      <Cell ss:StyleID=\"s67\"><Data ss:Type=\"Number\">" + gJum + "</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s69\"/>");
        wb.println("      <Cell ss:StyleID=\"s76\"/>");
        wb.println("      <Cell ss:StyleID=\"s76\"/>");
        wb.println("      <Cell ss:StyleID=\"s76\"><Data ss:Type=\"String\">Rp.</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s82\"><Data ss:Type=\"Number\">" + gPrc + "</Data></Cell>");
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
        wb.println("      <Number>3</Number> ");
        wb.println("      <ActiveRow>18</ActiveRow>");
        wb.println("      <ActiveCol>4</ActiveCol>");
        wb.println("      <RangeSelection>R18C5:R19C5</RangeSelection>");
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
