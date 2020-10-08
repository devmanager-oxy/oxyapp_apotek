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
import com.project.general.Company;
import com.project.general.Customer;
import com.project.general.DbCompany;

import com.project.general.DbCustomer;
import com.project.general.DbIndukCustomer;
import com.project.general.DbLocation;
import com.project.general.IndukCustomer;
import com.project.general.Location;
import com.project.general.Vendor;
import java.util.Date;

/**
 *
 * @author Roy
 */
public class RptSalesPromotionXLS extends HttpServlet {

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

        long userId = 0;
        User user = new User();
        Vector vresult = new Vector();
        Vector vlocselectted = new Vector();
        Vector result = new Vector();
        Vector resultParameter = new Vector();
        Location location = new Location();
        int allLocation=0;
        HttpSession session = request.getSession();
        try {
            vresult = (Vector) session.getValue("REPORT_SALES_PROMOTION");
            vlocselectted = (Vector) session.getValue("REPORT_SALES_PROMOTION_LOCATION");
            allLocation = Integer.valueOf(session.getValue("REPORT_SALES_ALL_LOCATION").toString());
        } catch (Exception e) {
        }

       
        long locationId = 0;
        try {
           
        } catch (Exception e) {
        }

        try {
            location = DbLocation.fetchExc(locationId);
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
        wb.println("      <Author>Roy</Author>");
        wb.println("      <LastAuthor>Roy</LastAuthor>");
        wb.println("      <LastPrinted>2015-03-02T03:54:07Z</LastPrinted>");
        wb.println("      <Created>2015-03-02T03:41:47Z</Created>");
        wb.println("      <Version>12.00</Version>");
        wb.println("      </DocumentProperties>");
        wb.println("      <ExcelWorkbook xmlns=\"urn:schemas-microsoft-com:office:excel\">");
        wb.println("      <WindowHeight>3345</WindowHeight>");
        wb.println("      <WindowWidth>11415</WindowWidth>");
        wb.println("      <WindowTopX>0</WindowTopX>");
        wb.println("      <WindowTopY>90</WindowTopY>");
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
        wb.println("      <Style ss:ID=\"s74\">");
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
        wb.println("      <Alignment ss:Horizontal=\"Right\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <NumberFormat ss:Format=\"Standard\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s85\">");
        wb.println("      <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Top\"/>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"14\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s88\">");
        wb.println("      <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Top\"/>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s89\">");
        wb.println("      <Alignment ss:Vertical=\"Center\"/>");
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
        wb.println("      <Table ss:DefaultRowHeight=\"15\">");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"54.75\"/>");
        wb.println("      <Column ss:Width=\"72.75\" ss:Span=\"2\"/>");
        wb.println("      <Column ss:Index=\"5\" ss:Width=\"78\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"69\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"100\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"100\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"80\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"90\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"90\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"90\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"90\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"90\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"90\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"90\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"90\"/>");
        wb.println("      <Row ss:Height=\"18.75\">");
        wb.println("      <Cell ss:MergeAcross=\"6\" ss:StyleID=\"s85\"><Data ss:Type=\"String\">" + cmp.getName().toUpperCase() + "</Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row>");
        wb.println("      <Cell ss:MergeAcross=\"6\" ss:StyleID=\"s88\"><Data ss:Type=\"String\">Sales Promotion</Data></Cell>");
        wb.println("      </Row>");
       
        if(vlocselectted.size()>0 && vlocselectted != null){
        
            for(int b=0;b<vlocselectted.size();b++){
                 result = new Vector();
                 Location lok = new Location();
                 lok = (Location) vlocselectted.get(b);
                 result = (Vector)vresult.get(b);
           wb.println("      <Row>");
           if(allLocation==1){
            wb.println("      <Cell  ss:StyleID=\"s88\"><Data ss:Type=\"String\">Location : All Location</Data></Cell>");
           }else{
            wb.println("      <Cell  ss:StyleID=\"s88\"><Data ss:Type=\"String\">Location : "+lok.getName()+"</Data></Cell>");   
           }
        wb.println("      </Row>");
        
        wb.println("      <Row  ss:AutoFitHeight=\"0\" ss:Height=\"23.25\">");
        wb.println("      <Cell ss:StyleID=\"s74\"><Data ss:Type=\"String\">Golongan</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s74\"><Data ss:Type=\"String\">SKU</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s74\"><Data ss:Type=\"String\">Barcode</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s74\"><Data ss:Type=\"String\">Item</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s74\"><Data ss:Type=\"String\">Start Date</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s74\"><Data ss:Type=\"String\">End Date</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s74\"><Data ss:Type=\"String\">Harga Reguler</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s74\"><Data ss:Type=\"String\">Harga Promo</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s74\"><Data ss:Type=\"String\">Qty</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s74\"><Data ss:Type=\"String\">Total Reguler</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s74\"><Data ss:Type=\"String\">Total Promo</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s74\"><Data ss:Type=\"String\">Total Refaksi</Data></Cell>");
        wb.println("      </Row>");

        
        if (result != null && result.size() > 0) {
            double grandTotalPromo = 0;
            double grandTotalRegular = 0;
            double grandTotalRefaksi = 0;
           

            for (int i = 0; i < result.size(); i++){
                Vector v = (Vector)result.get(i);
                
                String gol = (String)v.get(0);
                String sku = (String)v.get(1);
                String barcode = (String)v.get(2);
                String itemName = (String)v.get(3);
                String stDate = (String)v.get(4);
                String enDate = (String)v.get(5);
                //double diskon = Double.parseDouble((String)v.get(8));
                double hargaReg = Double.parseDouble((String)v.get(6));
                double hargaPromo = Double.parseDouble((String)v.get(7));
                double qty = Double.parseDouble((String)v.get(8));
                double totalReguler = Double.parseDouble((String)v.get(9));
                double totalPromo = Double.parseDouble((String)v.get(10));
                double totalRefaksi = Double.parseDouble((String)v.get(11));
                wb.println("<Row>");
                wb.println("<Cell ss:StyleID=\"s75\"><Data ss:Type=\"String\">" + gol + "</Data></Cell>");
                wb.println("<Cell ss:StyleID=\"s75\"><Data ss:Type=\"String\">" + sku + "</Data></Cell>");
                wb.println("<Cell ss:StyleID=\"s75\"><Data ss:Type=\"String\">" + barcode + "</Data></Cell>");
                wb.println("<Cell ss:StyleID=\"s75\"><Data ss:Type=\"String\">" + itemName + "</Data></Cell>");
                wb.println("<Cell ss:StyleID=\"s75\"><Data ss:Type=\"String\">" + stDate + "</Data></Cell>");
                wb.println("<Cell ss:StyleID=\"s75\"><Data ss:Type=\"String\">" + enDate + "</Data></Cell>");
                wb.println("<Cell ss:StyleID=\"s76\"><Data ss:Type=\"String\">" + JSPFormater.formatNumber(hargaReg, "###,###.00") + "</Data></Cell>");
                wb.println("<Cell ss:StyleID=\"s76\"><Data ss:Type=\"String\">" + JSPFormater.formatNumber(hargaPromo, "###,###.00") + "</Data></Cell>");
                wb.println("<Cell ss:StyleID=\"s76\"><Data ss:Type=\"String\">" + JSPFormater.formatNumber(qty, "###,###.00")   + "</Data></Cell>");
                wb.println("<Cell ss:StyleID=\"s76\"><Data ss:Type=\"String\">" + JSPFormater.formatNumber(totalReguler, "###,###.00") + "</Data></Cell>");
                wb.println("<Cell ss:StyleID=\"s76\"><Data ss:Type=\"String\">" + JSPFormater.formatNumber(totalPromo, "###,###.00") + "</Data></Cell>");
                wb.println("<Cell ss:StyleID=\"s76\"><Data ss:Type=\"String\">" + JSPFormater.formatNumber(totalRefaksi, "###,###.00") + "</Data></Cell>");
                wb.println("</Row>");
                grandTotalRegular =  grandTotalRegular + totalReguler;
                grandTotalPromo = grandTotalPromo + totalPromo;
                grandTotalRefaksi = grandTotalRefaksi + totalRefaksi;
            }
            wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"20.25\">");
            wb.println("      <Cell ss:MergeAcross=\"8\" ss:StyleID=\"s76\"><Data ss:Type=\"String\">TOTAL</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s76\"><Data ss:Type=\"String\">"+JSPFormater.formatNumber(grandTotalRegular, "###,###.00") +"</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s76\"><Data ss:Type=\"String\">"+JSPFormater.formatNumber(grandTotalPromo, "###,###.00") +"</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s76\"><Data ss:Type=\"String\">"+JSPFormater.formatNumber(grandTotalRefaksi, "###,###.00") +"</Data></Cell>");
            
                        
            wb.println("      </Row>");
            
        
        }
        if(allLocation==1){
            break;
        }
         }
        }
        wb.println("      <Row >");
        wb.println("      <Cell><Data ss:Type=\"String\"></Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row >");
        wb.println("      <Cell><Data ss:Type=\"String\">Jimbaran, "+JSPFormater.formatDate(new Date(), "dd MMMM yyyy")+"</Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row>");
        wb.println("      <Cell><Data ss:Type=\"String\">Dibuat Oleh,</Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row >");
        wb.println("      <Cell><Data ss:Type=\"String\"></Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row >");
        wb.println("      <Cell><Data ss:Type=\"String\"></Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row >");
        wb.println("      <Cell><Data ss:Type=\"String\"></Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row >");
        wb.println("      <Cell><Data ss:Type=\"String\">"+user.getFullName()+"</Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row>");
        wb.println("      <Cell><Data ss:Type=\"String\"></Data></Cell>");
        wb.println("      </Row>");
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
        wb.println("      <DoNotDisplayGridlines/>");
        wb.println("      <Panes>");
        wb.println("      <Pane>");
        wb.println("      <Number>3</Number>");
        wb.println("      <ActiveRow>4</ActiveRow>");
        wb.println("      <ActiveCol>9</ActiveCol>");
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

            System.out.println(URLEncoder.encode(str, "UTF-8"));
        } catch (Exception e) {
            System.out.println(e.toString());
        }
    }
}
