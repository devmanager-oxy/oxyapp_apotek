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
//import com.project.fms.master.*;
import com.project.payroll.*;
import com.project.util.jsp.*;
import com.project.fms.session.*;
import com.project.fms.activity.*;
import com.project.general.*;

/**
 *
 * @author Roy
 */
public class ReportGaXLS extends HttpServlet {

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
        Company cmp = new Company();
        try {
            Vector listCompany = DbCompany.list(0, 0, "", "");
            if (listCompany != null && listCompany.size() > 0) {
                cmp = (Company) listCompany.get(0);
            }
        } catch (Exception ext) {
            System.out.println(ext.toString());
        }

        Vector vpar = new Vector();
        try {
            HttpSession session = request.getSession();
            vpar = (Vector) session.getValue("KONSTAN_GENERAL_AFFAIR");
        } catch (Exception ex) {
            System.out.println(ex.toString());
        }

        String number = String.valueOf(vpar.get(0));
        long locationId = Long.parseLong("" + vpar.get(1));
        long locationPostId = Long.parseLong("" + vpar.get(2));
        Date transactionDate = JSPFormater.formatDate("" + vpar.get(3), "dd/MM/yyyy");
        String status = String.valueOf(vpar.get(4));
        String note = String.valueOf(vpar.get(5));
        String create = String.valueOf(vpar.get(6));

        Location l = new Location();
        Location lPost = new Location();
        try {
            l = DbLocation.fetchExc(locationId);
        } catch (Exception e) {
        }

        try {
            lPost = DbLocation.fetchExc(locationPostId);
        } catch (Exception e) {
        }

        Vector vDetail = new Vector();
        try {
            HttpSession session = request.getSession();
            vDetail = (Vector) session.getValue("DETAIL_GENERAL_AFFAIR");
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
        wb.println("      <Author>Roy</Author>");
        wb.println("      <LastAuthor>Roy</LastAuthor>");
        wb.println("      <LastPrinted>2015-05-25T18:55:11Z</LastPrinted>");
        wb.println("      <Created>2015-05-25T18:48:28Z</Created>");
        wb.println("      <LastSaved>2015-05-25T18:57:19Z</LastSaved>");
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
        wb.println("      <Style ss:ID=\"s76\">");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"8\" ss:Color=\"#000000\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s88\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Color=\"#000000\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s90\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Color=\"#000000\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s91\">");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Color=\"#000000\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s92\" ss:Parent=\"s16\">");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Color=\"#000000\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s113\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\"/>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Color=\"#000000\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s114\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\"/>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Color=\"#000000\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s115\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Color=\"#000000\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s132\">");
        wb.println("      <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders/>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s133\">");
        wb.println("      <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Center\" ss:WrapText=\"1\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Double\" ss:Weight=\"3\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s135\">");
        wb.println("      <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Color=\"#000000\"/>");
        wb.println("      </Style>");
        wb.println("      </Styles>");
        wb.println("      <Worksheet ss:Name=\"Sheet1\">");
        wb.println("      <Table >");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"27\"/>");
        wb.println("      <Column ss:Width=\"52.5\"/>");
        wb.println("      <Column ss:Width=\"80.25\"/>");
        wb.println("      <Column ss:Width=\"95.25\"/>");
        wb.println("      <Column ss:Index=\"6\" ss:Width=\"48.75\"/>");
        wb.println("      <Column ss:Width=\"52.5\"/>");
        wb.println("      <Column ss:Width=\"57.75\"/>");
        wb.println("      <Row>");
        wb.println("      <Cell ss:MergeAcross=\"7\" ss:StyleID=\"s132\"><Data ss:Type=\"String\">" + cmp.getName().toUpperCase() + "</Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"15.75\">");
        wb.println("      <Cell ss:MergeAcross=\"7\" ss:StyleID=\"s133\"><Data ss:Type=\"String\">" + cmp.getAddress().toUpperCase() + "</Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row ss:Height=\"15.75\"/>");
        wb.println("      <Row>");
        wb.println("      <Cell ss:MergeAcross=\"7\" ss:StyleID=\"s135\"><Data ss:Type=\"String\">Printed : " + create + ", date : " + JSPFormater.formatDate(new Date(), "dd-MMM-yyyy HH:mm:ss") + "</Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row>");
        wb.println("      <Cell ss:MergeAcross=\"7\" ss:StyleID=\"s135\"><Data ss:Type=\"String\">Number :" + number + "</Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row>");
        wb.println("      <Cell ss:MergeAcross=\"7\" ss:StyleID=\"s135\"><Data ss:Type=\"String\">Status :" + status + "</Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row>");
        wb.println("      <Cell ss:MergeAcross=\"7\" ss:StyleID=\"s135\"><Data ss:Type=\"String\">Date :" + JSPFormater.formatDate(transactionDate, "dd-MMM-yyyy") + "</Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row>");
        wb.println("      <Cell ss:MergeAcross=\"7\" ss:StyleID=\"s135\"><Data ss:Type=\"String\">Location :" + l.getName() + "</Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row>");
        wb.println("      <Cell ss:MergeAcross=\"7\" ss:StyleID=\"s135\"><Data ss:Type=\"String\">Cost Location :" + lPost.getName() + "</Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row>");
        wb.println("      <Cell ss:StyleID=\"s76\"/>");
        wb.println("      <Cell ss:StyleID=\"s76\"/>");
        wb.println("      <Cell ss:StyleID=\"s76\"/>");
        wb.println("      <Cell ss:StyleID=\"s76\"/>");
        wb.println("      <Cell ss:StyleID=\"s76\"/>");
        wb.println("      <Cell ss:StyleID=\"s76\"/>");
        wb.println("      <Cell ss:StyleID=\"s76\"/>");
        wb.println("      <Cell ss:StyleID=\"s76\"/>");
        wb.println("      </Row>");

        if (vDetail != null && vDetail.size() > 0) {
            wb.println("      <Row>");
            wb.println("      <Cell ss:StyleID=\"s115\"><Data ss:Type=\"String\">No</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s115\"><Data ss:Type=\"String\">SKU</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s115\"><Data ss:Type=\"String\">Barcode</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s115\"><Data ss:Type=\"String\">Name</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s115\"><Data ss:Type=\"String\">Unit</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s115\"><Data ss:Type=\"String\">Qty</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s115\"><Data ss:Type=\"String\">Price</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s115\"><Data ss:Type=\"String\">Total</Data></Cell>");
            wb.println("      </Row>");
            double totQty = 0;
            double totAmount = 0;
            for (int i = 0; i < vDetail.size(); i++) {
                
                Vector value = (Vector)vDetail.get(i);
                
                String code = String.valueOf(value.get(0));
                String barcode = String.valueOf(value.get(1));
                String name = String.valueOf(value.get(2));
                String unit = String.valueOf(value.get(3));
                
                double qty = 0;
                double price = 0;                
                double total = 0;   
                
                try{
                    qty = Double.parseDouble(String.valueOf(value.get(4)));
                }catch(Exception e){}
                
                try{
                    price = Double.parseDouble(String.valueOf(value.get(5)));
                }catch(Exception e){}
                
                try{
                    total = Double.parseDouble(String.valueOf(value.get(6)));
                }catch(Exception e){}
                
                totQty = totQty + qty;
                totAmount = totAmount + total;
                
                wb.println("      <Row>");
                wb.println("      <Cell ss:StyleID=\"s90\"><Data ss:Type=\"Number\">" + (i + 1) + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s91\"><Data ss:Type=\"String\">"+code+"</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s91\"><Data ss:Type=\"String\">"+barcode+"</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s91\"><Data ss:Type=\"String\">"+name+"</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s91\"><Data ss:Type=\"String\">"+unit+"</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s92\"><Data ss:Type=\"Number\">"+qty+"</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s92\"><Data ss:Type=\"Number\">"+price+"</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s92\"><Data ss:Type=\"Number\">"+total+"</Data></Cell>");
                wb.println("      </Row>");
            }
            wb.println("      <Row>");
            wb.println("      <Cell ss:MergeAcross=\"4\" ss:StyleID=\"s90\"><Data ss:Type=\"String\">Grand Total</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s92\"><Data ss:Type=\"Number\">"+totQty+"</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s92\"><Data ss:Type=\"String\"></Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s92\"><Data ss:Type=\"Number\">"+totAmount+"</Data></Cell>");
            wb.println("      </Row>");

        }
        
        wb.println("      <Row>");
        wb.println("      <Cell ss:MergeAcross=\"7\" ss:StyleID=\"s135\"><Data ss:Type=\"String\"></Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row>");
        wb.println("      <Cell ss:MergeAcross=\"7\" ss:StyleID=\"s135\"><Data ss:Type=\"String\">note :" + note + "</Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row>");
        wb.println("      <Cell ss:MergeAcross=\"7\" ss:StyleID=\"s135\"><Data ss:Type=\"String\"></Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row >");
        wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s113\"><Data ss:Type=\"String\">Create By</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s114\"/>");
        wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s113\"><Data ss:Type=\"String\">Accounting</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s114\"/>");
        wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s113\"><Data ss:Type=\"String\">Supervisor</Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row>");
        wb.println("      <Cell ss:MergeAcross=\"7\" ss:StyleID=\"s135\"><Data ss:Type=\"String\"></Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row>");
        wb.println("      <Cell ss:MergeAcross=\"7\" ss:StyleID=\"s135\"><Data ss:Type=\"String\"></Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row >");
        wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s88\"><Data ss:Type=\"String\">( "+create+" )</Data></Cell>");
        wb.println("      <Cell ss:Index=\"4\" ss:MergeAcross=\"1\" ss:StyleID=\"s88\"><Data ss:Type=\"String\">(…………………………..…...)</Data></Cell>");
        wb.println("      <Cell ss:Index=\"7\" ss:MergeAcross=\"1\" ss:StyleID=\"s88\"><Data ss:Type=\"String\">(…………………………..…...)</Data></Cell>");
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
        wb.println("      <PaperSizeIndex>9</PaperSizeIndex>");
        wb.println("      <HorizontalResolution>120</HorizontalResolution>");
        wb.println("      <VerticalResolution>72</VerticalResolution>");
        wb.println("      </Print>");
        wb.println("      <Selected/>");
        wb.println("      <DoNotDisplayGridlines/>");
        wb.println("      <Panes>");
        wb.println("      <Pane>");
        wb.println("      <Number>3</Number>");
        wb.println("      <ActiveRow>3</ActiveRow>");
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
            String str = "";
        } catch (Exception e) {
            System.out.println(e.toString());
        }
    }
}
