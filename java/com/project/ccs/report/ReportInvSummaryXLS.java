/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.ccs.report;

import com.project.admin.DbUser;
import com.project.admin.User;
import com.project.ccs.session.InvReport;
import com.project.ccs.session.ReportParameter;
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
import com.project.general.Company;
import com.project.general.DbCompany;
import com.project.general.*;
import com.project.util.JSPFormater;
import java.util.Date;

/**
 *
 * @author Roy Andika
 */
public class ReportInvSummaryXLS extends HttpServlet {

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
        Vector resultXLS = new Vector();
        Location location = new Location();

        long userId = JSPRequestValue.requestLong(request, "user_id");
        int type =  JSPRequestValue.requestInt(request, "type");
        int invType =  JSPRequestValue.requestInt(request, "inv_type");
        
        User u = new User();
        try {
            u = DbUser.fetch(userId);
        } catch (Exception e) {
        }

        Vector result = new Vector();
        ReportParameter rp = new ReportParameter();
        try {
            HttpSession session = request.getSession();
            resultXLS = (Vector) session.getValue("REPORT_INVENTORY_STOCK_SUMMARY");
            result = (Vector) resultXLS.get(0);
            rp = (ReportParameter) resultXLS.get(1);
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

        if (rp.getLocationId() != 0) {
            try {
                location = DbLocation.fetchExc(rp.getLocationId());
            } catch (Exception e) {
            }
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
        
        String title = "";
        if(invType==0){
            title = "INVENTORY REPORT (VALUE)";
        }else{
            title = "INVENTORY REPORT (QUANTITY)";
        }

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
        wb.println("      <Created>2015-01-25T05:27:31Z</Created>");
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
        
        wb.println("      <Style ss:ID=\"s70\">");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      </Style>");
        
        wb.println("      <Style ss:ID=\"s70i\">");
        wb.println("      <Alignment ss:Horizontal=\"Right\" ss:Vertical=\"Center\"/>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"");
        wb.println("      />");
        wb.println("      </Style>");
        
        wb.println("      <Style ss:ID=\"s81\">");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s82\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s83\">");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <NumberFormat ss:Format=\"Standard\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s84\">");
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
        wb.println("      <Style ss:ID=\"s85\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\" ss:WrapText=\"1\"/>");
        wb.println("      <Borders>");
        wb.println("      <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      <Style ss:ID=\"s86\">");
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
        wb.println("      <Style ss:ID=\"s87\">");
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
        wb.println("      <Style ss:ID=\"s92\">");
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
        wb.println("      <Style ss:ID=\"s94\">");
        wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"12\" ss:Color=\"#000000\"");
        wb.println("      ss:Bold=\"1\"/>");
        wb.println("      </Style>");
        wb.println("      </Styles>");
        wb.println("      <Worksheet ss:Name=\"Sheet1\">");
        wb.println("      <Table>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"39.75\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"123\"/>");
        if(type == 1){
            wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"123\"/>");
            wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"80\"/>");
            wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"123\"/>");
        }
        
        wb.println("      <Column ss:Width=\"84.75\" ss:Span=\"13\"/>");
        wb.println("      <Row>");
        if(type == 0){
        wb.println("      <Cell ss:MergeAcross=\"15\" ss:StyleID=\"s70i\"><Data ss:Type=\"String\">Print date : " + JSPFormater.formatDate(new Date(), "dd-MM-yyyy HH:mm:ss") + ", by " + u.getFullName() + "</Data></Cell>");
        }else{
        wb.println("      <Cell ss:MergeAcross=\"18\" ss:StyleID=\"s70i\"><Data ss:Type=\"String\">Print date : " + JSPFormater.formatDate(new Date(), "dd-MM-yyyy HH:mm:ss") + ", by " + u.getFullName() + "</Data></Cell>");    
        }
        wb.println("      </Row>");
        wb.println("      <Row ss:Height=\"18.75\">");
        wb.println("      <Cell ss:StyleID=\"s94\"><Data ss:Type=\"String\">" + cmp.getName() + "</Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row ss:Height=\"18.75\">");
        wb.println("      <Cell ss:StyleID=\"s94\"><Data ss:Type=\"String\">" + cmp.getAddress() + "</Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row>");
        wb.println("      <Cell ss:StyleID=\"s70\"><Data ss:Type=\"String\"></Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row>");
        wb.println("      <Cell ss:StyleID=\"s70\"><Data ss:Type=\"String\">"+title+"</Data></Cell>");
        wb.println("      </Row>");
        if (rp.getLocationId() != 0) {
            wb.println("      <Row>");
            wb.println("      <Cell ss:StyleID=\"s70\"><Data ss:Type=\"String\">Location : " + location.getName() + "</Data></Cell>");
            wb.println("      </Row>");
        }else{
            wb.println("      <Row>");
            wb.println("      <Cell ss:StyleID=\"s70\"><Data ss:Type=\"String\">Location : All Location</Data></Cell>");
            wb.println("      </Row>");
        }
        
        wb.println("      <Row>");
        wb.println("      <Cell ss:StyleID=\"s70\"><Data ss:Type=\"String\">Period : " + JSPFormater.formatDate(rp.getDateFrom(), "dd MMM yyyy") + " - " + JSPFormater.formatDate(rp.getDateTo(), "dd MMM yyyy") + "</Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row>");
        wb.println("      <Cell ss:StyleID=\"s70\"><Data ss:Type=\"String\"></Data></Cell>");
        wb.println("      </Row>");
        
        wb.println("      <Row >");
        wb.println("      <Cell ss:MergeDown=\"1\" ss:StyleID=\"s84\"><Data ss:Type=\"String\">Code </Data></Cell>");
        wb.println("      <Cell ss:MergeDown=\"1\" ss:StyleID=\"s84\"><Data ss:Type=\"String\">Category</Data></Cell>");
        
        if(type == 1){
            wb.println("      <Cell ss:MergeDown=\"1\" ss:StyleID=\"s84\"><Data ss:Type=\"String\">Sub Category</Data></Cell>");
            wb.println("      <Cell ss:MergeDown=\"1\" ss:StyleID=\"s84\"><Data ss:Type=\"String\">Sku </Data></Cell>");
            wb.println("      <Cell ss:MergeDown=\"1\" ss:StyleID=\"s84\"><Data ss:Type=\"String\">Item Name</Data></Cell>");
        }
        
        wb.println("      <Cell ss:MergeDown=\"1\" ss:StyleID=\"s84\"><Data ss:Type=\"String\">Begining </Data></Cell>");
        wb.println("      <Cell ss:MergeDown=\"1\" ss:StyleID=\"s84\"><Data ss:Type=\"String\">Incoming </Data></Cell>");
        wb.println("      <Cell ss:MergeDown=\"1\" ss:StyleID=\"s85\"><Data ss:Type=\"String\">Incoming &#10;Ajustment</Data></Cell>");
        wb.println("      <Cell ss:MergeDown=\"1\" ss:StyleID=\"s84\"><Data ss:Type=\"String\">RTV </Data></Cell>");
        wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s86\"><Data ss:Type=\"String\">Transfer </Data></Cell>");
        wb.println("      <Cell ss:MergeDown=\"1\" ss:StyleID=\"s84\"><Data ss:Type=\"String\">Costing </Data></Cell>");
        wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s86\"><Data ss:Type=\"String\">Repack </Data></Cell>");
        wb.println("      <Cell ss:MergeDown=\"1\" ss:StyleID=\"s84\"><Data ss:Type=\"String\">Shringkage </Data></Cell>");
        wb.println("      <Cell ss:MergeDown=\"1\" ss:StyleID=\"s84\"><Data ss:Type=\"String\">COGS </Data></Cell>");
        wb.println("      <Cell ss:MergeDown=\"1\" ss:StyleID=\"s84\"><Data ss:Type=\"String\">Net Sales </Data></Cell>");
        wb.println("      <Cell ss:MergeDown=\"1\" ss:StyleID=\"s84\"><Data ss:Type=\"String\">Ending </Data></Cell>");
        wb.println("      <Cell ss:MergeDown=\"1\" ss:StyleID=\"s84\"><Data ss:Type=\"String\">Inv. Turn Over</Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row>");
        if(type == 1){
            wb.println("      <Cell ss:Index=\"10\" ss:StyleID=\"s87\"><Data ss:Type=\"String\">In </Data></Cell>");
        }else{
            wb.println("      <Cell ss:Index=\"7\" ss:StyleID=\"s87\"><Data ss:Type=\"String\">In </Data></Cell>");
        }
        wb.println("      <Cell ss:StyleID=\"s87\"><Data ss:Type=\"String\">Out </Data></Cell>");
        if(type == 1){
            wb.println("      <Cell ss:Index=\"13\" ss:StyleID=\"s87\"><Data ss:Type=\"String\">Stock Out </Data></Cell>");
        }else{
            wb.println("      <Cell ss:Index=\"10\" ss:StyleID=\"s87\"><Data ss:Type=\"String\">Stock Out </Data></Cell>");
        }
        wb.println("      <Cell ss:StyleID=\"s87\"><Data ss:Type=\"String\">Stock In</Data></Cell>");
        wb.println("      </Row>");

        if (result != null && result.size() > 0) {

            double totBegining = 0;
            double totReceiving = 0;
            double totRecAdj = 0;
            double totRtv = 0;
            double totTrafIn = 0;
            double totTrafOut = 0;
            double totCosting = 0;
            double totMutation = 0;
            double totRepackOut = 0;
            double totAdjustment = 0;
            double totCogs = 0;
            double totNetSales = 0;
            double totEnding = 0;
            double totTurnOver = 0;

            for (int i = 0; i < result.size(); i++) {

                InvReport iReport = (InvReport) result.get(i);
                wb.println("      <Row>");
                wb.println("      <Cell ss:StyleID=\"s82\"><Data ss:Type=\"String\">" + iReport.getCode() + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s81\"><Data ss:Type=\"String\">" + iReport.getSectionName() + "</Data></Cell>");
                if(type ==1){
                    wb.println("      <Cell ss:StyleID=\"s81\"><Data ss:Type=\"String\">" + iReport.getCodeClass() + "</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s81\"><Data ss:Type=\"String\">" + iReport.getSku() + "</Data></Cell>");
                    wb.println("      <Cell ss:StyleID=\"s81\"><Data ss:Type=\"String\">" + iReport.getDesription() + "</Data></Cell>");
                }
                wb.println("      <Cell ss:StyleID=\"s83\"><Data ss:Type=\"Number\">" + iReport.getBegining() + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s83\"><Data ss:Type=\"Number\">" + iReport.getReceiving() + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s83\"><Data ss:Type=\"Number\">" + iReport.getReceivingAdjustment() + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s83\"><Data ss:Type=\"Number\">" + iReport.getRtv() + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s83\"><Data ss:Type=\"Number\">" + iReport.getTransferIn() + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s83\"><Data ss:Type=\"Number\">" + iReport.getTransferOut() + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s83\"><Data ss:Type=\"Number\">" + iReport.getCosting() + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s83\"><Data ss:Type=\"Number\">" + iReport.getMutation() + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s83\"><Data ss:Type=\"Number\">" + iReport.getRepackOut() + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s83\"><Data ss:Type=\"Number\">" + iReport.getStockAdjustment() + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s83\"><Data ss:Type=\"Number\">" + iReport.getCogs() + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s83\"><Data ss:Type=\"Number\">" + iReport.getNetSales() + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s83\"><Data ss:Type=\"Number\">" + iReport.getEnding() + "</Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s83\"><Data ss:Type=\"Number\">" + iReport.getTurnOvr() + "</Data></Cell>");
                wb.println("      </Row>");
                
                totBegining = totBegining + iReport.getBegining();
                totReceiving = totReceiving + iReport.getReceiving();
                totRecAdj = totRecAdj + iReport.getReceivingAdjustment();
                totRtv = totRtv + iReport.getRtv();
                totTrafIn = totTrafIn + iReport.getTransferIn();
                totTrafOut = totTrafOut + iReport.getTransferOut();
                totCosting = totCosting + iReport.getCosting();
                totMutation = totMutation + iReport.getMutation();
                totRepackOut = totRepackOut + iReport.getRepackOut();
                totAdjustment = totAdjustment + iReport.getStockAdjustment();
                totCogs = totCogs + iReport.getCogs();
                totNetSales = totNetSales + iReport.getNetSales();
                totEnding = totEnding + iReport.getEnding();
                totTurnOver = totTurnOver + iReport.getTurnOvr();
            }
            
            wb.println("      <Row>");
            wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s86\"><Data ss:Type=\"String\">Total</Data></Cell>");
            if(type ==1){
                wb.println("      <Cell ss:StyleID=\"s92\"><Data ss:Type=\"String\"></Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s92\"><Data ss:Type=\"String\"></Data></Cell>");
                wb.println("      <Cell ss:StyleID=\"s92\"><Data ss:Type=\"String\"></Data></Cell>");
            }
            wb.println("      <Cell ss:StyleID=\"s92\"><Data ss:Type=\"Number\">" + totBegining + "</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s92\"><Data ss:Type=\"Number\">" + totReceiving + "</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s92\"><Data ss:Type=\"Number\">" + totRecAdj + "</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s92\"><Data ss:Type=\"Number\">" + totRtv + "</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s92\"><Data ss:Type=\"Number\">" + totTrafIn + "</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s92\"><Data ss:Type=\"Number\">" + totTrafOut + "</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s92\"><Data ss:Type=\"Number\">" + totCosting + "</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s92\"><Data ss:Type=\"Number\">" + totMutation + "</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s92\"><Data ss:Type=\"Number\">" + totRepackOut + "</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s92\"><Data ss:Type=\"Number\">" + totAdjustment + "</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s92\"><Data ss:Type=\"Number\">" + totCogs + "</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s92\"><Data ss:Type=\"Number\">" + totNetSales + "</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s92\"><Data ss:Type=\"Number\">" + totEnding + "</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\"s92\"><Data ss:Type=\"String\"></Data></Cell>");
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
        wb.println("      <DoNotDisplayGridlines/>");
        wb.println("      <Panes>");
        wb.println("      <Pane>");
        wb.println("      <Number>3</Number>");
        wb.println("      <ActiveRow>20</ActiveRow>");
        wb.println("      <ActiveCol>2</ActiveCol>");
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

