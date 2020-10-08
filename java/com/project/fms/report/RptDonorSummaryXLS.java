/*
 * Report Donor Summary XLS.java
 *
 * Created on March 27, 2008, 1:33 AM
 */

package com.project.fms.report;

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
import com.project.fms.master.*;
import com.project.payroll.*;
import com.project.util.jsp.*;
import com.project.fms.session.*;
import com.project.fms.activity.*;

import com.project.general.Company;
import com.project.general.DbCompany;


public class RptDonorSummaryXLS extends HttpServlet {
    
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
        
        // Load User Login
        String loginId = JSPRequestValue.requestString(request, "oid");
        System.out.println("UserId : "+loginId);
        
        // Load Company
        Company company = DbCompany.getCompany();
        long oidCompany = company.getOID();           
        System.out.println("oidCompany : "+oidCompany);
        
        // Report Type
        int reportType = JSPRequestValue.requestInt(request, "reportType");
        // AmountType
        int amountType = JSPRequestValue.requestInt(request, "amountType");        
        // Activity Period
        long actPeriod = JSPRequestValue.requestLong(request, "act");        

        // Load Invoice Item
        Vector vectorList = new Vector(1,1);
        try{
            HttpSession session = request.getSession();
            vectorList = (Vector)session.getValue("DONOR_SUMMARY");
        } catch (Exception e) { System.out.println(e); }
        //System.out.println(vectorList);       
        
	//Count total Column
	int colSpan = 0;
        System.out.println(colSpan);
        
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

        //PrintWriter wb = response.getWriter() ;

        wb.println("<?xml version=\"1.0\" encoding=\"UTF-8\"?>" ) ;        
        //open if you want to open this xml file by excel
        wb.println("<?mso-application progid=\"Excel.Sheet\"?>");
        
        wb.println("<Workbook xmlns=\"urn:schemas-microsoft-com:office:spreadsheet\"");
        wb.println(" xmlns:o=\"urn:schemas-microsoft-com:office:office\"");
        wb.println(" xmlns:x=\"urn:schemas-microsoft-com:office:excel\"");
        wb.println(" xmlns:ss=\"urn:schemas-microsoft-com:office:spreadsheet\"");
        wb.println(" xmlns:html=\"http://www.w3.org/TR/REC-html40\">");
        
        wb.println(" <DocumentProperties xmlns=\"urn:schemas-microsoft-com:office:office\">");
        wb.println("  <Version>11.5606</Version>");
        wb.println(" </DocumentProperties>");
        
        wb.println(" <OfficeDocumentSettings xmlns=\"urn:schemas-microsoft-com:office:office\">");
        wb.println("  <Colors>");
        wb.println("   <Color>");
        wb.println("    <Index>16</Index>");
        wb.println("    <RGB>#C6DCBE</RGB>");
        wb.println("   </Color>");
        wb.println("   <Color>");
        wb.println("    <Index>24</Index>");
        wb.println("    <RGB>#6CA35A</RGB>");
        wb.println("   </Color>");
        wb.println("  </Colors>");
        wb.println(" </OfficeDocumentSettings>");
        
        wb.println(" <ExcelWorkbook xmlns=\"urn:schemas-microsoft-com:office:excel\">");
        wb.println("  <WindowHeight>10005</WindowHeight>");
        wb.println("  <WindowWidth>10005</WindowWidth>");
        wb.println("  <WindowTopX>120</WindowTopX>");
        wb.println("  <WindowTopY>135</WindowTopY>");
        wb.println("  <ProtectStructure>False</ProtectStructure>");
        wb.println("  <ProtectWindows>False</ProtectWindows>");
        wb.println(" </ExcelWorkbook>");
        
        // Style region
        wb.println("    <Styles>");
        wb.println("     <Style ss:ID=\"Default\" ss:Name=\"Normal\">");
        wb.println("      <Alignment ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders/>");
        wb.println("      <Font/>");
        wb.println("      <Interior/>");
        wb.println("      <NumberFormat/>");
        wb.println("      <Protection/>");
        wb.println("     </Style>");
        
        wb.println("     <Style ss:ID=\"s21\">");
        wb.println("      <Alignment ss:Horizontal=\"Right\" ss:Vertical=\"Bottom\"/>");
        wb.println("     </Style>");
        
        wb.println("     <Style ss:ID=\"s24\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Font x:Family=\"Swiss\" ss:Size=\"18\" ss:Bold=\"1\"/>");
        wb.println("     </Style>");
        
        wb.println("     <Style ss:ID=\"s26\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Font x:Family=\"Swiss\" ss:Size=\"16\" ss:Bold=\"1\"/>");
        wb.println("     </Style>");
        
        wb.println("     <Style ss:ID=\"s28\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("       <Border ss:Position=\"Bottom\" ss:LineStyle=\"Double\" ss:Weight=\"3\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:Size=\"12\"/>");
        wb.println("     </Style>");
        
        wb.println("     <Style ss:ID=\"s30\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\" ss:WrapText=\"1\"/>");
        wb.println("      <Borders>");
        wb.println("       <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("       <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("       <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("       <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font x:Family=\"Swiss\" ss:Bold=\"1\"/>");
        wb.println("      <Interior ss:Color=\"#C0C0C0\" ss:Pattern=\"Solid\"/>");
        wb.println("     </Style>");
        
        wb.println("     <Style ss:ID=\"s32\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <NumberFormat/>");
        wb.println("     </Style>");
        
        wb.println("     <Style ss:ID=\"s33\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("       <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <NumberFormat/>");
        wb.println("     </Style>");
        
        wb.println("     <Style ss:ID=\"s47\">");
        wb.println("      <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Center\" ss:WrapText=\"1\"/>");
        wb.println("      <Borders>");
        wb.println("       <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("       <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("       <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("       <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Interior/>");
        wb.println("     </Style>");
        
        wb.println("     <Style ss:ID=\"s48\">");
        wb.println("      <Alignment ss:Horizontal=\"Right\" ss:Vertical=\"Center\" ss:WrapText=\"1\"/>");
        wb.println("      <Borders>");
        wb.println("       <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("       <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("       <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("       <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Interior/>");
        wb.println("      <NumberFormat ss:Format=\"#,##0_);\\(#,##0\\)\"/>");
        wb.println("     </Style>");

        wb.println("     <Style ss:ID=\"s47b\">");
        wb.println("      <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Center\" ss:WrapText=\"1\"/>");
        wb.println("      <Borders>");
        wb.println("       <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("       <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("       <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("       <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font x:Family=\"Swiss\" ss:Bold=\"1\"/>");
        wb.println("      <Interior/>");
        wb.println("     </Style>");
        
        wb.println("     <Style ss:ID=\"s48b\">");
        wb.println("      <Alignment ss:Horizontal=\"Right\" ss:Vertical=\"Center\" ss:WrapText=\"1\"/>");
        wb.println("      <Borders>");
        wb.println("       <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("       <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("       <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("       <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font x:Family=\"Swiss\" ss:Bold=\"1\"/>");
        wb.println("      <Interior/>");
        wb.println("      <NumberFormat ss:Format=\"#,##0_);\\(#,##0\\)\"/>");
        wb.println("     </Style>");
        
        wb.println("     <Style ss:ID=\"s42x\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders/>");
        wb.println("      <NumberFormat/>");
        wb.println("     </Style>");
        
        wb.println("     <Style ss:ID=\"s45x\">");
        wb.println("      <Alignment ss:Horizontal=\"Right\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders/>");
        wb.println("      <Font x:Family=\"Swiss\" ss:Bold=\"1\"/>");
        wb.println("      <NumberFormat/>");
        wb.println("     </Style>");
        
        wb.println("     <Style ss:ID=\"s47x\">");
        wb.println("      <Alignment ss:Horizontal=\"Right\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders/>");
        wb.println("      <Font x:Family=\"Swiss\" ss:Bold=\"1\"/>");
        wb.println("      <NumberFormat ss:Format=\"#,##0_);\\(#,##0\\)\"/>");
        wb.println("     </Style>");

        wb.println("     <Style ss:ID=\"s29\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders/>");
        wb.println("      <Font ss:Size=\"12\"/>");
        wb.println("     </Style>");
        
        wb.println("     <Style ss:ID=\"s31\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("       <Border ss:Position=\"Bottom\" ss:LineStyle=\"Double\" ss:Weight=\"3\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font/>");
        wb.println("     </Style>");

        wb.println("     <Style ss:ID=\"s52\">");
        wb.println("      <Alignment ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("       <Border ss:Position=\"Bottom\" ss:LineStyle=\"Double\" ss:Weight=\"3\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font x:Family=\"Swiss\" ss:Size=\"8\" ss:Italic=\"1\"/>");
        wb.println("     </Style>");
        
        wb.println("     <Style ss:ID=\"s54\">");
        wb.println("      <Alignment ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders/>");
        wb.println("      <Font x:Family=\"Swiss\" ss:Size=\"8\" ss:Italic=\"1\"/>");
        wb.println("     </Style>");

        wb.println("    </Styles>");
        wb.flush() ;       
        
        wb.println("  <Worksheet ss:Name=\"ProfitLoss\">");
        wb.println("    <Table>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"14.25\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"466.5\"/>");
        wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"126\" ss:Span=\"4\"/>");
        wb.println("      <Column ss:Index=\"8\" ss:AutoFitWidth=\"0\" ss:Width=\"14.25\"/>");
        wb.println("      <Column ss:Hidden=\"1\" ss:AutoFitWidth=\"0\" ss:Span=\"247\"/>");
        
        //Top Header
        company = new Company();
        try{
            company = DbCompany.fetchExc(oidCompany);
        }
        catch(Exception e){
        }                        
        wb.println("      <Row>");
        wb.println("       <Cell ss:Index=\"7\" ss:StyleID=\"s21\"><Data ss:Type=\"String\">Printed : "+JSPFormater.formatDate(new Date(),formatDate)+"</Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"23.25\">");
        wb.println("       <Cell ss:Index=\"2\" ss:MergeAcross=\"5\" ss:StyleID=\"s24\"><Data ss:Type=\"String\"");
        wb.println("         x:Ticked=\"1\">"+company.getName().toUpperCase()+"</Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"20.25\">");
        wb.println("       <Cell ss:Index=\"2\" ss:MergeAcross=\"5\" ss:StyleID=\"s26\"><Data ss:Type=\"String\">ACTIVITY SUMMARY REPORT</Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"18\">");
        ActivityPeriod periode = new ActivityPeriod();
        try{
            periode = DbActivityPeriod.fetchExc(actPeriod);
        }
        catch(Exception e){
        }
        String openPeriod = JSPFormater.formatDate(periode.getStartDate(), "dd MMM yyyy")+ " - " + JSPFormater.formatDate(periode.getEndDate(), "dd MMM yyyy");       
        wb.println("       <Cell ss:Index=\"2\" ss:MergeAcross=\"5\" ss:StyleID=\"s29\"><Data ss:Type=\"String\">PERIOD "+ openPeriod.toUpperCase()+"</Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row>");
        
        String strReport = "";
        if(reportType==0)
            strReport = "Base Line";
        else if(reportType==1)
            strReport = "Equaly Devided Among Component";
        
        wb.println("       <Cell ss:Index=\"2\" ss:StyleID=\"s54\"><Data ss:Type=\"String\">F&A And Logistic Allocation : "+strReport+"</Data></Cell>");
        wb.println("       <Cell ss:StyleID=\"s54\"/>");
        wb.println("       <Cell ss:StyleID=\"s54\"/>");
        wb.println("       <Cell ss:StyleID=\"s54\"/>");
        wb.println("       <Cell ss:StyleID=\"s54\"/>");
        wb.println("       <Cell ss:StyleID=\"s54\"/>");
        wb.println("      </Row>");

        if(amountType==0)
            strReport = "-";
        else if(amountType==1)
            strReport = "Thousand";
        else if(amountType==2)
            strReport = "Million";
        
        wb.println("      <Row ss:Height=\"13.5\">");
        wb.println("       <Cell ss:Index=\"2\" ss:StyleID=\"s52\"><Data ss:Type=\"String\">Amount IDR In : "+strReport+"</Data></Cell>");
        wb.println("       <Cell ss:StyleID=\"s52\"/>");
        wb.println("       <Cell ss:StyleID=\"s52\"/>");
        wb.println("       <Cell ss:StyleID=\"s52\"/>");
        wb.println("       <Cell ss:StyleID=\"s52\"/>");
        wb.println("       <Cell ss:StyleID=\"s52\"/>");
        wb.println("      </Row>");

        
        //Content Header
        wb.println("     <Row ss:Height=\"15\"/>");
        wb.println("      <Row>");
        wb.println("       <Cell ss:Index=\"2\" ss:StyleID=\"s30\"><Data ss:Type=\"String\">Description</Data></Cell>");
        wb.println("       <Cell ss:StyleID=\"s30\"><Data ss:Type=\"String\">Direct Expense</Data></Cell>");
        wb.println("       <Cell ss:StyleID=\"s30\"><Data ss:Type=\"String\">Compensation</Data></Cell>");
        wb.println("       <Cell ss:StyleID=\"s30\"><Data ss:Type=\"String\">FA Allocation</Data></Cell>");
        wb.println("       <Cell ss:StyleID=\"s30\"><Data ss:Type=\"String\">Logistic Allocation</Data></Cell>");
        wb.println("       <Cell ss:StyleID=\"s30\"><Data ss:Type=\"String\" x:Ticked=\"1\">Total</Data></Cell>");
        wb.println("      </Row>");

        //content
        for(int i=0; i<vectorList.size(); i++){
            SesReportDonor srb = (SesReportDonor)vectorList.get(i);
            String xFont = "s47";
            String xFont1 = "s48";
            if (srb.getFont()==1){
                xFont = "s47b";   
                xFont1 = "s48b";
            }
            if(srb.getTemp().equals("Detail")){                
                wb.println("      <Row>");
                wb.println("       <Cell ss:Index=\"2\" ss:StyleID=\""+xFont+"\"><Data ss:Type=\"String\">"+srb.getComponent()+"</Data></Cell>");
                wb.println("       <Cell ss:StyleID=\""+xFont1+"\"><Data ss:Type=\"Number\">"+srb.getExpenses()+"</Data></Cell>");
                wb.println("       <Cell ss:StyleID=\""+xFont1+"\"><Data ss:Type=\"Number\">"+srb.getConpensation()+"</Data></Cell>");
                wb.println("       <Cell ss:StyleID=\""+xFont1+"\"><Data ss:Type=\"Number\">"+srb.getFa()+"</Data></Cell>");
                wb.println("       <Cell ss:StyleID=\""+xFont1+"\"><Data ss:Type=\"Number\">"+srb.getLogistic()+"</Data></Cell>");
                wb.println("       <Cell ss:StyleID=\""+xFont1+"\"><Data ss:Type=\"Number\">"+srb.getTotal()+"</Data></Cell>");
                wb.println("      </Row>");
            }
                        
            if(srb.getTemp().equals("End")){                
                wb.println("      <Row>");
                wb.println("       <Cell ss:Index=\"2\" ss:StyleID=\"s42x\"/>");
                wb.println("       <Cell ss:StyleID=\"s42x\"/>");
                wb.println("       <Cell ss:StyleID=\"s42x\"/>");
                wb.println("       <Cell ss:StyleID=\"s42x\"/>");
                wb.println("       <Cell ss:StyleID=\"s42x\"/>");
                wb.println("       <Cell ss:StyleID=\"s42x\"/>");
                wb.println("      </Row>");
            }
            
            if(srb.getTemp().equals("Total")){                
                wb.println("      <Row>");
                wb.println("       <Cell ss:Index=\"2\" ss:StyleID=\"s45x\"><Data ss:Type=\"String\">"+srb.getComponent()+"</Data></Cell>");
                wb.println("       <Cell ss:StyleID=\"s47x\"><Data ss:Type=\"Number\">"+srb.getTotal()+"</Data></Cell>");
                wb.println("       <Cell ss:StyleID=\"s42x\"/>");
                wb.println("       <Cell ss:StyleID=\"s42x\"/>");
                wb.println("       <Cell ss:StyleID=\"s42x\"/>");
                wb.println("       <Cell ss:StyleID=\"s42x\"/>");
                wb.println("      </Row>");
            }
        }

        //footer
        wb.println("      <Row>");
        wb.println("       <Cell ss:Index=\"2\" ss:MergeAcross=\"5\" ss:StyleID=\"s32\"><Data ss:Type=\"String\"></Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row>");
        wb.println("       <Cell ss:Index=\"2\" ss:MergeAcross=\"5\" ss:StyleID=\"s32\"><Data ss:Type=\"String\"></Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row>");
        wb.println("       <Cell ss:Index=\"2\" ss:MergeAcross=\"5\" ss:StyleID=\"s32\"><Data ss:Type=\"String\">Date : _________________                                Date : _________________                                Date : _________________</Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row>");
        wb.println("       <Cell ss:Index=\"2\" ss:MergeAcross=\"5\" ss:StyleID=\"s32\"><Data ss:Type=\"String\">Approve by                                                            Review by                                                            Prepare by</Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row>");
        wb.println("       <Cell ss:Index=\"2\" ss:MergeAcross=\"5\" ss:StyleID=\"s32\"><Data ss:Type=\"String\"></Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row>");
        wb.println("       <Cell ss:Index=\"2\" ss:MergeAcross=\"5\" ss:StyleID=\"s32\"><Data ss:Type=\"String\"></Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row>");
        wb.println("       <Cell ss:Index=\"2\" ss:MergeAcross=\"5\" ss:StyleID=\"s32\"><Data ss:Type=\"String\"></Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row>");
        wb.println("       <Cell ss:Index=\"2\" ss:MergeAcross=\"5\" ss:StyleID=\"s32\"><Data ss:Type=\"String\"></Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row>");
        wb.println("       <Cell ss:Index=\"2\" ss:MergeAcross=\"5\" ss:StyleID=\"s32\"><Data ss:Type=\"String\">______________________                                ______________________                                ______________________</Data></Cell>");
        wb.println("      </Row>");
        
        
        wb.println("    </Table>");
        wb.println("    <WorksheetOptions xmlns=\"urn:schemas-microsoft-com:office:excel\">");
        wb.println("     <Print>");
        wb.println("      <ValidPrinterInfo/>");
        wb.println("      <PaperSizeIndex>9</PaperSizeIndex>");
        wb.println("      <HorizontalResolution>-4</HorizontalResolution>");
        wb.println("      <VerticalResolution>0</VerticalResolution>");
        wb.println("     </Print>");
        wb.println("     <Zoom>80</Zoom>");
        wb.println("     <Selected/>");
        wb.println("     <DoNotDisplayGridlines/>");
        wb.println("     <DoNotDisplayZeros/>");
        wb.println("     <FreezePanes/>");
        wb.println("     <FrozenNoSplit/>");
        wb.println("     <SplitHorizontal>8</SplitHorizontal>");
        wb.println("     <TopRowBottomPane>8</TopRowBottomPane>");
        //wb.println("     <SplitVertical>2</SplitVertical>");
        //wb.println("     <LeftColumnRightPane>2</LeftColumnRightPane>");
        wb.println("     <ActivePane>2</ActivePane>");        
        wb.println("     <Panes>");
        wb.println("      <Pane>");
        wb.println("       <Number>3</Number>");
        wb.println("       <ActiveCol>13</ActiveCol>");
        wb.println("      </Pane>");
        wb.println("     </Panes>");
        wb.println("     <ProtectObjects>False</ProtectObjects>");
        wb.println("     <ProtectScenarios>False</ProtectScenarios>");
        wb.println("    </WorksheetOptions>");
        wb.println("   </Worksheet>");
        
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
