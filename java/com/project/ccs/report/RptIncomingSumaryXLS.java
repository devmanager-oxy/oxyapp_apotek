/*
 * Report Donor to IFC by Group XLS.java
 *
 * Created on March 30, 2008, 1:33 AM
 */

package com.project.ccs.report;

import com.project.admin.DbUser;
import com.project.admin.User;
import com.project.ccs.postransaction.receiving.DbReceive;
import com.project.ccs.postransaction.receiving.Receive;
import com.project.ccs.postransaction.transfer.DbTransfer;
import com.project.ccs.postransaction.transfer.Transfer;
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

import com.project.payroll.*;
import com.project.util.jsp.*;
import com.project.fms.session.*;
import com.project.fms.activity.*;
import com.project.general.*;
import com.project.util.JSPFormater;

public class RptIncomingSumaryXLS extends HttpServlet {
    
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

    String XMLSafe ( String in )
    {
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
        System.out.println("---===| Excel Report |===---");
        response.setContentType("application/x-msexcel");
        
        Company cmp = new Company();
        try{
            Vector listCompany = DbCompany.list(0,0, "", "");
            if(listCompany!=null && listCompany.size()>0){
                cmp = (Company)listCompany.get(0);
            }
        }catch(Exception ext){
            System.out.println(ext.toString());
        }
        
        /*RptITLocation rptKonstan = new RptITLocation();
        try{
            HttpSession session = request.getSession();
            rptKonstan = (RptITLocation)session.getValue("KONSTAN");
        }catch(Exception ex){
            System.out.println(ex.toString());
        }*/
        
        Vector listReport = new Vector();
        String userName = "";
        String srcParam = "";
        try{
            HttpSession session = request.getSession();
            SrcReceiveReport srcReceiveReport = (SrcReceiveReport)session.getValue("KONSTAN");
            listReport = SessReceiveReport.getReceiveReport(srcReceiveReport, 0, 0, 0);
            userName = (String)session.getValue("USER_NAME");
            srcParam = (String)session.getValue("SRC_PARAM");
        }catch(Exception e){
            System.out.println(e.toString());
        }
        
        
        
        System.out.println("------------- vDetail : "+listReport.size());
        
        boolean gzip = false ;
        
        //response.setCharacterEncoding( "UTF-8" ) ;
        OutputStream gzo ;
        if ( gzip ) {
            response.setHeader( "Content-Encoding", "gzip" ) ;
            gzo = new GZIPOutputStream( response.getOutputStream() ) ;
        } else {
            gzo = response.getOutputStream() ;
        }
        PrintWriter wb = new PrintWriter( new OutputStreamWriter( gzo, "UTF-8" ) ) ;

        wb.println("<?xml version=\"1.0\"?>");
        wb.println("<?mso-application progid=\"Excel.Sheet\"?>");
        wb.println("<Workbook xmlns=\"urn:schemas-microsoft-com:office:spreadsheet\"");
        wb.println(" xmlns:o=\"urn:schemas-microsoft-com:office:office\"");
        wb.println(" xmlns:x=\"urn:schemas-microsoft-com:office:excel\"");
        wb.println(" xmlns:ss=\"urn:schemas-microsoft-com:office:spreadsheet\"");
        wb.println(" xmlns:html=\"http://www.w3.org/TR/REC-html40\">");
        wb.println(" <DocumentProperties xmlns=\"urn:schemas-microsoft-com:office:office\">");
        wb.println("  <Author>OxySystem</Author>");
        wb.println("  <LastAuthor>Eka D</LastAuthor>");
        wb.println("  <LastPrinted>2015-01-26T14:41:54Z</LastPrinted>");
        wb.println("  <Created>2015-01-26T08:26:29Z</Created>");
        wb.println("  <LastSaved>2015-01-26T13:56:55Z</LastSaved>");
        wb.println("  <Company>Toshiba</Company>");
        wb.println("  <Version>14.00</Version>");
        wb.println(" </DocumentProperties>");
        wb.println(" <OfficeDocumentSettings xmlns=\"urn:schemas-microsoft-com:office:office\">");
        wb.println("  <AllowPNG/>");
        wb.println(" </OfficeDocumentSettings>");
        wb.println(" <ExcelWorkbook xmlns=\"urn:schemas-microsoft-com:office:excel\">");
        wb.println("  <WindowHeight>8505</WindowHeight>");
        wb.println("  <WindowWidth>20115</WindowWidth>");
        wb.println("  <WindowTopX>240</WindowTopX>");
        wb.println("  <WindowTopY>105</WindowTopY>");
        wb.println("  <ProtectStructure>False</ProtectStructure>");
        wb.println("  <ProtectWindows>False</ProtectWindows>");
        wb.println(" </ExcelWorkbook>");
         wb.println("<Styles>");
          wb.println("<Style ss:ID=\"Default\" ss:Name=\"Normal\">");
           wb.println("<Alignment ss:Vertical=\"Bottom\"/>");
           wb.println("<Borders/>");
           wb.println("<Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"/>");
           wb.println("<Interior/>");
           wb.println("<NumberFormat/>");
           wb.println("<Protection/>");
          wb.println("</Style>");
          wb.println("<Style ss:ID=\"s16\" ss:Name=\"Comma\">");
           wb.println("<NumberFormat ss:Format=\"_(* #,##0.00_);_(* \\(#,##0.00\\);_(* &quot;-&quot;??_);_(@_)\"/>");
          wb.println("</Style>");
          wb.println("<Style ss:ID=\"s63\">");
           wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
           wb.println("<Borders>");
            wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
            wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
            wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
            wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
           wb.println("</Borders>");
          wb.println("</Style>");
          wb.println("<Style ss:ID=\"s72\">");
           wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
           wb.println("<Borders>");
            wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
            wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
            wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
            wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
           wb.println("</Borders>");
           wb.println("<Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"");
           wb.println(" ss:Bold=\"1\"/>");
           wb.println("<Interior ss:Color=\"#DAEEF3\" ss:Pattern=\"Solid\"/>");
          wb.println("</Style>");
          wb.println("<Style ss:ID=\"s73\">");
           wb.println("<Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"");
           wb.println(" ss:Bold=\"1\"/>");
          wb.println("</Style>");
          wb.println("<Style ss:ID=\"s75\">");
           wb.println("<Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"12\" ss:Color=\"#000000\"");
           wb.println(" ss:Bold=\"1\"/>");
          wb.println("</Style>");
          wb.println("<Style ss:ID=\"s77\">");
           wb.println("<Borders>");
            wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
            wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
            wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
            wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
           wb.println("</Borders>");
          wb.println("</Style>");
          wb.println("<Style ss:ID=\"s78\">");
           wb.println("<Alignment ss:Horizontal=\"Right\" ss:Vertical=\"Bottom\"/>");
          wb.println("</Style>");
          wb.println("<Style ss:ID=\"s83\" ss:Parent=\"s16\">");
           wb.println("<Borders>");
            wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
            wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
            wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
            wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
           wb.println("</Borders>");
           wb.println("<Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"/>");
          wb.println("</Style>");
          wb.println("<Style ss:ID=\"s87\">");
           wb.println("<Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Center\"/>");
           wb.println("<Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"");
           wb.println(" ss:Bold=\"1\" ss:Italic=\"1\"/>");
          wb.println("</Style>");
          wb.println("<Style ss:ID=\"s90\">");
           wb.println("<Borders>");
            wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Double\" ss:Weight=\"3\"/>");
            wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
           wb.println("</Borders>");
           wb.println("<Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"");
           wb.println(" ss:Bold=\"1\"/>");
          wb.println("</Style>");
          wb.println("<Style ss:ID=\"s91\" ss:Parent=\"s16\">");
           wb.println("<Borders>");
            wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Double\" ss:Weight=\"3\"/>");
            wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
           wb.println("</Borders>");
           wb.println("<Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"");
           wb.println(" ss:Bold=\"1\"/>");
          wb.println("</Style>");
          wb.println("<Style ss:ID=\"s92\">");
           wb.println("<Alignment ss:Horizontal=\"Right\" ss:Vertical=\"Bottom\"/>");
           wb.println("<Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"");
           wb.println(" ss:Italic=\"1\"/>");
          wb.println("</Style>");
          wb.println("<Style ss:ID=\"s93\">");
           wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
           wb.println("<Borders>");
            wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
            wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
            wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
            wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
           wb.println("</Borders>");
           wb.println("<NumberFormat ss:Format=\"Short Date\"/>");
          wb.println("</Style>");
         wb.println("</Styles>");
         wb.println("<Worksheet ss:Name=\"Sheet1\">");
          wb.println("<Table ss:ExpandedColumnCount=\"10\" x:FullColumns=\"1\"");
          wb.println(" x:FullRows=\"1\" ss:DefaultRowHeight=\"15\">");
           wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"21.75\"/>");
           wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"75.75\"/>");
           wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"81.75\"/>");
           wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"78\"/>");
           wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"121.5\"/>");
           wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"80.5\"/>");
           wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"61.5\"/>");
           wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"93\"/>");
           wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"67.5\"/>");
           wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"196.5\"/>");
           wb.println("<Row ss:Height=\"15.75\">");
            wb.println("<Cell ss:StyleID=\"s75\"><Data ss:Type=\"String\">INCOMING REPORT</Data></Cell>");
            wb.println("<Cell ss:Index=\"10\" ss:StyleID=\"s92\"><Data ss:Type=\"String\">Printed by : "+userName+", "+JSPFormater.formatDate(new java.util.Date(), "dd-MM-yyyy")+"</Data></Cell>");
           wb.println("</Row>");
           wb.println("<Row>");
            wb.println("<Cell ss:StyleID=\"s73\"><Data ss:Type=\"String\">"+cmp.getName()+"</Data></Cell>");
            wb.println("<Cell ss:Index=\"10\" ss:StyleID=\"s78\"/>");
           wb.println("</Row>");
           wb.println("<Row>");
            wb.println("<Cell><Data ss:Type=\"String\">"+cmp.getAddress()+"</Data></Cell>");
           wb.println("</Row>");
           wb.println("<Row ss:AutoFitHeight=\"0\" ss:Height=\"9\"/>");
           wb.println("<Row ss:AutoFitHeight=\"0\" ss:Height=\"18.75\">");
            wb.println("<Cell ss:StyleID=\"s87\"><Data ss:Type=\"String\">"+srcParam+"</Data></Cell>");
           wb.println("</Row>");
           wb.println("<Row>");
            wb.println("<Cell ss:StyleID=\"s72\"><Data ss:Type=\"String\">No</Data></Cell>");
            wb.println("<Cell ss:StyleID=\"s72\"><Data ss:Type=\"String\">Location</Data></Cell>");
            wb.println("<Cell ss:StyleID=\"s72\"><Data ss:Type=\"String\">Supplier</Data></Cell>");
            wb.println("<Cell ss:StyleID=\"s72\"><Data ss:Type=\"String\">Number</Data></Cell>");
            wb.println("<Cell ss:StyleID=\"s72\"><Data ss:Type=\"String\">Date</Data></Cell>");
            wb.println("<Cell ss:StyleID=\"s72\"><Data ss:Type=\"String\">User</Data></Cell>");
            wb.println("<Cell ss:StyleID=\"s72\"><Data ss:Type=\"String\">Tot Qty</Data></Cell>");
            wb.println("<Cell ss:StyleID=\"s72\"><Data ss:Type=\"String\">Amount</Data></Cell>");
            wb.println("<Cell ss:StyleID=\"s72\"><Data ss:Type=\"String\">Status</Data></Cell>");
            wb.println("<Cell ss:StyleID=\"s72\"><Data ss:Type=\"String\">Notes</Data></Cell>");
           wb.println("</Row>");
           
           double totQty = 0;
           double totAmount = 0;
           
           if(listReport!=null && listReport.size()>0){
                          
               for(int i=0; i<listReport.size(); i++){

                    ReceiveReport receiveReport = (ReceiveReport)listReport.get(i);

                    Receive receive = new Receive();
                    User ux = new User();
                    try{
                            receive = DbReceive.fetchExc(receiveReport.getOID());
                            ux = DbUser.fetch(receive.getUserId());
                    }
                    catch(Exception e){
                    }
                    
                    totQty = totQty + receiveReport.getTotalQty();
                    totAmount = totAmount + receiveReport.getPurchAmount();
               
                   wb.println("<Row>");
                    wb.println("<Cell ss:StyleID=\"s77\"><Data ss:Type=\"Number\">"+(i+1)+"</Data></Cell>");
                    wb.println("<Cell ss:StyleID=\"s77\"><Data ss:Type=\"String\">"+receiveReport.getLocationName()+"</Data></Cell>");
                    wb.println("<Cell ss:StyleID=\"s77\"><Data ss:Type=\"String\">"+receiveReport.getVendorName()+"</Data></Cell>");
                    wb.println("<Cell ss:StyleID=\"s63\"><Data ss:Type=\"String\">"+receiveReport.getPurchNumber()+"</Data></Cell>");
                    wb.println("<Cell ss:StyleID=\"s93\"><Data ss:Type=\"String\" x:Ticked=\"1\">"+JSPFormater.formatDate(receiveReport.getDate(),"dd-MM-yyyy")+"</Data></Cell>");
                    wb.println("<Cell ss:StyleID=\"s77\"><Data ss:Type=\"String\">"+ux.getLoginId()+"</Data></Cell>");
                    wb.println("<Cell ss:StyleID=\"s77\"><Data ss:Type=\"Number\">"+receiveReport.getTotalQty()+"</Data></Cell>");
                    wb.println("<Cell ss:StyleID=\"s83\"><Data ss:Type=\"Number\">"+receiveReport.getPurchAmount()+"</Data></Cell>");
                    wb.println("<Cell ss:StyleID=\"s63\"><Data ss:Type=\"String\">"+receive.getStatus()+"</Data></Cell>");
                    wb.println("<Cell ss:StyleID=\"s77\"><Data ss:Type=\"String\">"+receive.getNote().toLowerCase()+"</Data></Cell>");
                   wb.println("</Row>");
                   
                }
           
           //total
           wb.println("<Row ss:Height=\"15.75\">");
            wb.println("<Cell ss:Index=\"6\" ss:StyleID=\"s90\"><Data ss:Type=\"String\">TOTAL</Data></Cell>");
            wb.println("<Cell ss:StyleID=\"s90\"><Data ss:Type=\"Number\">"+totQty+"</Data></Cell>");
            wb.println("<Cell ss:StyleID=\"s91\"><Data ss:Type=\"Number\">"+totAmount+"</Data></Cell>");
           wb.println("</Row>");
           
         }
           
           wb.println("<Row ss:Height=\"15.75\"/>");
         wb.println(" </Table>");
          wb.println("<WorksheetOptions xmlns=\"urn:schemas-microsoft-com:office:excel\">");
          wb.println(" <PageSetup>");
            wb.println("<Layout x:Orientation=\"Landscape\"/>");
            wb.println("<Header x:Margin=\"0.3\"/>");
            wb.println("<Footer x:Margin=\"0.3\"/>");
          wb.println("  <PageMargins x:Bottom=\"0.75\" x:Left=\"0.7\" x:Right=\"0.7\" x:Top=\"0.75\"/>");
          wb.println(" </PageSetup>");
          wb.println(" <Print>");
          wb.println("  <ValidPrinterInfo/>");
          wb.println("  <PaperSizeIndex>9</PaperSizeIndex>");
          wb.println("  <VerticalResolution>0</VerticalResolution>");
          wb.println(" </Print>");
          wb.println(" <Selected/>");
          wb.println(" <DoNotDisplayGridlines/>");
          wb.println(" <Panes>");
          wb.println("  <Pane>");
          wb.println("   <Number>3</Number>");
          wb.println("   <ActiveRow>13</ActiveRow>");
          wb.println("   <ActiveCol>4</ActiveCol>");
          wb.println("  </Pane>");
          wb.println(" </Panes>");
          wb.println(" <ProtectObjects>False</ProtectObjects>");
          wb.println(" <ProtectScenarios>False</ProtectScenarios>");
          wb.println("</WorksheetOptions>");
         wb.println("</Worksheet>");
        wb.println("</Workbook>");
        
        wb.flush() ;
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
    
    public static void main(String[] arg){
        try{
            String str = "aku anak cerdas > pandai & rajin";

            System.out.println(URLEncoder.encode(str, "UTF-8"));
        }
        catch(Exception e){
            System.out.println(e.toString());
        }
    }

    
}
