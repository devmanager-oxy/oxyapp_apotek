/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.simprop.report;
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
//import com.project.general.*;
import com.project.crm.project.*;
import com.project.I_Project;

import com.project.general.Company;
import com.project.general.DbCompany;
import com.project.general.Customer;
import com.project.general.DbCustomer;
import com.project.general.Currency;
import com.project.general.DbCurrency;

import com.project.general.BankAccount;
import com.project.general.DbBankAccount;
import com.project.simprop.property.DbSalesData;
import com.project.simprop.session.RptCustomer;
import com.project.simprop.session.RptPayment;
/**
 *
 * @author Roy Andika
 */
public class RptAvailableUnitXLS extends HttpServlet {
    
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
        long compId = JSPRequestValue.requestLong(request, "oid");
        int lang = 0;
        
        Vector vCompany = DbCompany.listAll();
        Company company = new Company();
        
        try {
            company = (Company)vCompany.get(0);
        } catch (Exception e) {
            System.out.println(e);
        }
        
        Vector result = new Vector();
        try {
            HttpSession session = request.getSession();
            result = (Vector) session.getValue("RPT_PAYMENT");
            lang = JSPRequestValue.requestInt(request, "lang"); 
        } catch (Exception e) {
            System.out.println(e.toString());
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
	wb.println("      <Created>2013-04-02T02:12:49Z</Created>");
	wb.println("      <LastSaved>2013-04-02T02:33:24Z</LastSaved>");
	wb.println("      <Version>12.00</Version>");
	wb.println("      </DocumentProperties>");
	wb.println("      <ExcelWorkbook xmlns=\"urn:schemas-microsoft-com:office:excel\">");
	wb.println("      <WindowHeight>8190</WindowHeight>");
	wb.println("      <WindowWidth>19320</WindowWidth>");
	wb.println("      <WindowTopX>240</WindowTopX>");
	wb.println("      <WindowTopY>45</WindowTopY>");
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
	wb.println("      <Style ss:ID=\"s16\">");
	wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
	wb.println("      </Style>");
	wb.println("      <Style ss:ID=\"s17\">");
	wb.println("      <NumberFormat ss:Format=\"#,##0.00;[Red]#,##0.00\"/>");
	wb.println("      </Style>");
	wb.println("      <Style ss:ID=\"s19\">");
	wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
	wb.println("      <Borders>");
	wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
	wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
	wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
	wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
	wb.println("      </Borders>");
	wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"/>");
	wb.println("      <Interior/>");
	wb.println("      </Style>");
	wb.println("      <Style ss:ID=\"s20\">");
	wb.println("      <Borders>");
	wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
	wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
	wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
	wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
	wb.println("      </Borders>");
	wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"/>");
	wb.println("      <Interior/>");
	wb.println("      </Style>");
	wb.println("      <Style ss:ID=\"s21\">");
	wb.println("      <Borders>");
	wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
	wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
	wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
	wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
	wb.println("      </Borders>");
	wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"/>");
	wb.println("      <Interior/>");
	wb.println("      <NumberFormat ss:Format=\"#,##0.00;[Red]#,##0.00\"/>");
	wb.println("      </Style>");
	wb.println("      <Style ss:ID=\"s22\">");
	wb.println("      <Borders>");
	wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
	wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
	wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
	wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
	wb.println("      </Borders>");
	wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"");
	wb.println("      ss:Bold=\"1\"/>");
	wb.println("      <Interior/>");
	wb.println("      <NumberFormat ss:Format=\"#,##0.00;[Red]#,##0.00\"/>");
	wb.println("      </Style>");
	wb.println("      <Style ss:ID=\"s24\">");
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
	wb.println("      <Style ss:ID=\"s25\">");
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
	wb.println("      <Style ss:ID=\"s26\">");
	wb.println("      <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Bottom\"/>");
	wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"");
	wb.println("      ss:Bold=\"1\"/>");
	wb.println("      </Style>");
	wb.println("      </Styles>");
	wb.println("      <Worksheet ss:Name=\"Sheet1\">");
	wb.println("      <Table >");
	wb.println("      <Column ss:StyleID=\"s16\" ss:AutoFitWidth=\"0\"/>");
	wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"165.75\"/>");
	wb.println("      <Column ss:StyleID=\"s17\" ss:AutoFitWidth=\"0\" ss:Width=\"104.25\"/>");
	wb.println("      <Column ss:StyleID=\"s17\" ss:AutoFitWidth=\"0\" ss:Width=\"101.25\"/>");
	wb.println("      <Column ss:StyleID=\"s17\" ss:AutoFitWidth=\"0\" ss:Width=\"125.25\"/>");
	wb.println("      <Column ss:StyleID=\"s17\" ss:AutoFitWidth=\"0\" ss:Width=\"114.75\"/>");
	wb.println("      <Column ss:StyleID=\"s16\" ss:AutoFitWidth=\"0\" ss:Width=\"102.75\"/>");
	wb.println("      <Row ss:Index=\"2\">");
	wb.println("      <Cell ss:MergeAcross=\"6\" ss:StyleID=\"s26\"><Data ss:Type=\"String\">REPORT AVALIBALE LOT</Data></Cell>");
	wb.println("      </Row>");
	wb.println("      <Row ss:Index=\"4\">");
	wb.println("      <Cell ss:MergeAcross=\"6\" ss:StyleID=\"s25\"><Data ss:Type=\"String\">PROPERTY : GRANDADAP CITY</Data></Cell>");
	wb.println("      </Row>");
	wb.println("      <Row>");
	wb.println("      <Cell ss:MergeAcross=\"6\" ss:StyleID=\"s25\"><Data ss:Type=\"String\">&#160;   BUILDING : ANGGREK, &#160;&#160;&#160;FLOOR : 1, &#160;&#160;&#160; LOT TYPE : ANGGREK 2 BR</Data></Cell>");
	wb.println("      </Row>");
	wb.println("      <Row>");
	wb.println("      <Cell ss:StyleID=\"s19\"><Data ss:Type=\"Number\">1</Data></Cell>");
	wb.println("      <Cell ss:StyleID=\"s20\"><Data ss:Type=\"String\">ANGGREK 2 BR, # 2</Data></Cell>");
	wb.println("      <Cell ss:StyleID=\"s21\"><Data ss:Type=\"Number\">362500000</Data></Cell>");
	wb.println("      <Cell ss:StyleID=\"s21\"><Data ss:Type=\"Number\">397500000</Data></Cell>");
	wb.println("      <Cell ss:StyleID=\"s21\"><Data ss:Type=\"Number\">382500000</Data></Cell>");
	wb.println("      <Cell ss:StyleID=\"s21\"><Data ss:Type=\"Number\">0</Data></Cell>");
	wb.println("      <Cell ss:StyleID=\"s19\"><Data ss:Type=\"String\">AVAILABLE</Data></Cell>");
	wb.println("      </Row>");
	wb.println("      <Row>");
	wb.println("      <Cell ss:StyleID=\"s19\"><Data ss:Type=\"Number\">2</Data></Cell>");
	wb.println("      <Cell ss:StyleID=\"s20\"><Data ss:Type=\"String\">ANGGREK 2 BR, # 5</Data></Cell>");
	wb.println("      <Cell ss:StyleID=\"s21\"><Data ss:Type=\"Number\">362500000</Data></Cell>");
	wb.println("      <Cell ss:StyleID=\"s21\"><Data ss:Type=\"Number\">397500000</Data></Cell>");
	wb.println("      <Cell ss:StyleID=\"s21\"><Data ss:Type=\"Number\">382500000</Data></Cell>");
	wb.println("      <Cell ss:StyleID=\"s21\"><Data ss:Type=\"Number\">0</Data></Cell>");
	wb.println("      <Cell ss:StyleID=\"s19\"><Data ss:Type=\"String\">AVAILABLE</Data></Cell>");
	wb.println("      </Row>");
	wb.println("      <Row>");
	wb.println("      <Cell ss:StyleID=\"s19\"/>");
	wb.println("      <Cell ss:StyleID=\"s24\"><Data ss:Type=\"String\">TOTAL</Data></Cell>");
	wb.println("      <Cell ss:StyleID=\"s22\"><Data ss:Type=\"Number\">222841322864</Data></Cell>");
	wb.println("      <Cell ss:StyleID=\"s22\"><Data ss:Type=\"Number\">228863484239</Data></Cell>");
	wb.println("      <Cell ss:StyleID=\"s22\"><Data ss:Type=\"Number\">128978958164</Data></Cell>");
	wb.println("      <Cell ss:StyleID=\"s22\"><Data ss:Type=\"Number\">0</Data></Cell>");
	wb.println("      <Cell ss:StyleID=\"s19\"/>");
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
	wb.println("      <HorizontalResolution>600</HorizontalResolution>");
	wb.println("      <VerticalResolution>600</VerticalResolution>");
	wb.println("      </Print>");
	wb.println("      <Selected/>");
	wb.println("      <Panes>");
	wb.println("      <Pane>");
	wb.println("      <Number>3</Number>");
	wb.println("      <ActiveRow>12</ActiveRow>");
	wb.println("      <ActiveCol>4</ActiveCol>");
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
