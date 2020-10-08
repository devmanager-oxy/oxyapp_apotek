/*
 * Report BS Standard XLS.java
 *
 * Created on March 25, 2008, 1:33 AM
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

import com.project.general.Company;
import com.project.general.DbCompany;



public class RptBSStandardXLS extends HttpServlet {
    
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
        
        // Load Invoice Item
        Vector vectorList = new Vector(1,1);
        try{
            HttpSession session = request.getSession();
            vectorList = (Vector)session.getValue("BS_STANDARD");
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
         wb.println(" <Styles>");
        wb.println("   <Style ss:ID=\"Default\" ss:Name=\"Normal\">");
        wb.println("    <Alignment ss:Vertical=\"Bottom\"/>");
        wb.println("    <Borders/>");
        wb.println("    <Font/>");
        wb.println("    <Interior/>");
        wb.println("    <NumberFormat/>");
        wb.println("    <Protection/>");
        wb.println("   </Style>");
        
        wb.println("   <Style ss:ID=\"s40\">");
        wb.println("    <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("    <Font x:Family=\"Swiss\" ss:Size=\"18\" ss:Bold=\"1\"/>");
        wb.println("   </Style>");
        
        wb.println("   <Style ss:ID=\"s42\">");
        wb.println("    <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("    <Font x:Family=\"Swiss\" ss:Size=\"16\" ss:Bold=\"1\"/>");
        wb.println("   </Style>");
        
        wb.println("   <Style ss:ID=\"s43\">");
        wb.println("    <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("    <Font ss:Size=\"12\"/>");
        wb.println("    <Borders>");
        wb.println("     <Border ss:Position=\"Bottom\" ss:LineStyle=\"Double\" ss:Weight=\"3\"/>");
        wb.println("    </Borders>");
        wb.println("   </Style>");
        
        wb.println("   <Style ss:ID=\"s28\">");
        wb.println("    <Alignment ss:Horizontal=\"Right\" ss:Vertical=\"Bottom\"/>");
        wb.println("   </Style>");
        
        wb.println("   <Style ss:ID=\"s41\">");
        wb.println("    <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\" ss:WrapText=\"1\"/>");
        //wb.println("    <Borders>");
        //wb.println("     <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        //wb.println("     <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        //wb.println("     <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        //wb.println("     <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        //wb.println("    </Borders>");
        wb.println("    <Font x:Family=\"Swiss\" ss:Bold=\"1\"/>");
        wb.println("    <Interior ss:Color=\"#C0C0C0\" ss:Pattern=\"Solid\"/>");
        wb.println("   </Style>");
        
        wb.println("   <Style ss:ID=\"s44\">");
        wb.println("    <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Center\"/>");
        //wb.println("    <Borders>");
        //wb.println("     <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        //wb.println("     <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        //wb.println("     <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        //wb.println("     <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        //wb.println("    </Borders>");
        wb.println("   </Style>");

        wb.println("   <Style ss:ID=\"s44b\">");
        wb.println("    <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Center\"/>");
        //wb.println("    <Borders>");
        //wb.println("     <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        //wb.println("     <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        //wb.println("     <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        //wb.println("     <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        //wb.println("    </Borders>");
        wb.println("    <Font x:Family=\"Swiss\" ss:Bold=\"1\"/>");
        wb.println("   </Style>");
        
        wb.println("   <Style ss:ID=\"s45\">");
        wb.println("    <Alignment ss:Horizontal=\"Right\" ss:Vertical=\"Center\" ss:Indent=\"1\"/>");
        //wb.println("    <Borders>");
        //wb.println("     <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        //wb.println("     <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        //wb.println("     <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        //wb.println("     <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        //wb.println("    </Borders>");
        wb.println("    <NumberFormat ss:Format=\"#,##0.00_);\\(#,##0.00\\)\"/>");              
        wb.println("   </Style>");
  
        wb.println("   <Style ss:ID=\"s45b\">");
        wb.println("    <Alignment ss:Horizontal=\"Right\" ss:Vertical=\"Center\" ss:Indent=\"1\"/>");
        //wb.println("    <Borders>");
        //wb.println("     <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        //wb.println("     <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        //wb.println("     <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        //wb.println("     <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        //wb.println("    </Borders>");
        wb.println("    <Font x:Family=\"Swiss\" ss:Bold=\"1\"/>");        
        wb.println("    <NumberFormat ss:Format=\"#,##0.00_);\\(#,##0.00\\)\"/>");        
        wb.println("   </Style>");

        wb.println("   <Style ss:ID=\"s47\">");
        wb.println("    <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("    <NumberFormat/>");
        wb.println("   </Style>");
        
        wb.println("  </Styles>");
        wb.flush() ;       
        
        wb.println("  <Worksheet ss:Name=\"ProfitLoss\">");
        wb.println("    <Table>");
        wb.println("    <Column ss:AutoFitWidth=\"0\" ss:Width=\"14.25\"/>");
        wb.println("    <Column ss:AutoFitWidth=\"0\" ss:Width=\"304.25\"/>");
        wb.println("    <Column ss:AutoFitWidth=\"0\" ss:Width=\"159\" ss:Span=\""+(colSpan+1)+"\"/>");
        wb.println("    <Column ss:Index=\""+(colSpan+5)+"\" ss:AutoFitWidth=\"0\" ss:Width=\"14.25\"/>");
        wb.println("    <Column ss:Hidden=\"1\" ss:AutoFitWidth=\"0\" ss:Span=\""+(256-colSpan-6)+"\"/>");
                
        //Top Header
        company = new Company();
        try{
            company = DbCompany.fetchExc(oidCompany);
        }
        catch(Exception e){
        }                
        wb.println("     <Row>"); 
        wb.println("      <Cell ss:Index=\""+(colSpan+4)+"\" ss:StyleID=\"s28\"><Data ss:Type=\"String\">Printed : "+JSPFormater.formatDate(new Date(),formatDate)+"</Data></Cell>");
        wb.println("     </Row>");
        
        wb.println("     <Row ss:Height=\"23.25\">");
        wb.println("      <Cell ss:Index=\"2\" ss:MergeAcross=\""+(colSpan+2)+"\" ss:StyleID=\"s40\"><Data ss:Type=\"String\" x:Ticked=\"1\">"+company.getName().toUpperCase()+"</Data></Cell>");
        wb.println("     </Row>");
        
        wb.println("     <Row ss:Height=\"20.25\">");
        wb.println("      <Cell ss:Index=\"2\" ss:MergeAcross=\""+(colSpan+2)+"\" ss:StyleID=\"s42\"><Data ss:Type=\"String\">NERACA AKHIR</Data></Cell>");
        wb.println("     </Row>");
        wb.println("     <Row ss:Height=\"18\">");
        
        Periode periode = DbPeriode.getOpenPeriod();
        Date dtx = (Date)periode.getStartDate().clone();
        dtx.setYear(dtx.getYear()-1);
        //String openPeriod = JSPFormater.formatDate(periode.getStartDate(), "dd MMM yyyy")+ " - " + JSPFormater.formatDate(periode.getEndDate(), "dd MMM yyyy");
        String openPeriod = JSPFormater.formatDate(dtx, "MMM yyyy")+ " DAN " + JSPFormater.formatDate(periode.getStartDate(), "MMM yyyy");
        
        wb.println("      <Cell ss:Index=\"2\" ss:MergeAcross=\""+(colSpan+2)+"\" ss:StyleID=\"s43\"><Data ss:Type=\"String\">PERIOD "+ openPeriod.toUpperCase()+"</Data></Cell>");
        wb.println("     </Row>");
        
          Date xDatex = periode.getStartDate();
          Date abcDate = (Date)xDatex.clone();
          abcDate.setYear(abcDate.getYear()-1);
        
        //Content Header
        wb.println("     <Row ss:Height=\"15\"/>");
        wb.println("     <Row>");
        wb.println("      <Cell ss:Index=\"2\" ss:MergeDown=\"0\" ss:StyleID=\"s41\"><Data ss:Type=\"String\">Description</Data></Cell>");
        wb.println("      <Cell ss:MergeDown=\"0\" ss:StyleID=\"s41\"><Data ss:Type=\"String\">Tahun "+JSPFormater.formatDate(abcDate, "yyyy")+"</Data></Cell>");
        wb.println("      <Cell ss:MergeDown=\"0\" ss:StyleID=\"s41\"><Data ss:Type=\"String\">Tahun "+JSPFormater.formatDate(periode.getStartDate(), "yyyy")+"</Data></Cell>");
        wb.println("     </Row>");

        //content
        for(int i=0; i<vectorList.size(); i++){
            SesReportBs srb = (SesReportBs)vectorList.get(i);
            String xFont = "s44";
            String xFont1 = "s45";
            if (srb.getFont()==1){
                xFont = "s44b";   
                xFont1 = "s45b";
            }
            wb.println("     <Row>");        
            wb.println("      <Cell ss:Index=\"2\" ss:StyleID=\""+xFont+"\"><Data ss:Type=\"String\">"+srb.getDescription()+"</Data></Cell>");

            String strAmount = srb.getStrAmount();
            String strAmountPrev = srb.getStrAmountPrevYear();
            
            double dblAmount = 0;
            double dblAmountPrev = 0;
            try{
                dblAmount = Double.parseDouble(strAmount);
                dblAmountPrev = Double.parseDouble(strAmountPrev);
            }catch(Exception e){
                System.out.println(e);
            }
            //System.out.println("Amount = "+dblAmount);            
            wb.println("      <Cell ss:StyleID=\""+xFont1+"\"><Data ss:Type=\"Number\">"+JSPFormater.formatNumber(dblAmountPrev, "###")+"</Data></Cell>");
            wb.println("      <Cell ss:StyleID=\""+xFont1+"\"><Data ss:Type=\"Number\">"+JSPFormater.formatNumber(dblAmount,"###")+"</Data></Cell>");
            wb.println("     </Row>");       
        }
        
        //footer
        wb.println("     <Row>");
        wb.println("      <Cell ss:Index=\"2\" ss:MergeAcross=\""+(colSpan+2)+"\" ss:StyleID=\"s47\"><Data ss:Type=\"String\"></Data></Cell>");
        wb.println("     </Row>");
        wb.println("     <Row>");
        wb.println("      <Cell ss:Index=\"2\" ss:MergeAcross=\""+(colSpan+2)+"\" ss:StyleID=\"s47\"><Data ss:Type=\"String\"></Data></Cell>");
        wb.println("     </Row>");
        wb.println("     <Row>");
        wb.println("      <Cell ss:Index=\"2\" ss:MergeAcross=\""+(colSpan+2)+"\" ss:StyleID=\"s47\"><Data ss:Type=\"String\">Date : _________________                Date : _________________                Date : _________________</Data></Cell>");
        wb.println("     </Row>");
        wb.println("     <Row>");
        wb.println("      <Cell ss:Index=\"2\" ss:MergeAcross=\""+(colSpan+2)+"\" ss:StyleID=\"s47\"><Data ss:Type=\"String\">Approve by                                            Review by                                            Prepare by</Data></Cell>");
        wb.println("     </Row>");
        wb.println("     <Row>");
        wb.println("      <Cell ss:Index=\"2\" ss:MergeAcross=\""+(colSpan+2)+"\" ss:StyleID=\"s47\"><Data ss:Type=\"String\"></Data></Cell>");
        wb.println("     </Row>");
        wb.println("     <Row>");
        wb.println("      <Cell ss:Index=\"2\" ss:MergeAcross=\""+(colSpan+2)+"\" ss:StyleID=\"s47\"><Data ss:Type=\"String\"></Data></Cell>");
        wb.println("     </Row>");
        wb.println("     <Row>");
        wb.println("      <Cell ss:Index=\"2\" ss:MergeAcross=\""+(colSpan+2)+"\" ss:StyleID=\"s47\"><Data ss:Type=\"String\"></Data></Cell>");
        wb.println("     </Row>");
        wb.println("     <Row>");
        wb.println("      <Cell ss:Index=\"2\" ss:MergeAcross=\""+(colSpan+2)+"\" ss:StyleID=\"s47\"><Data ss:Type=\"String\"></Data></Cell>");
        wb.println("     </Row>");
        wb.println("     <Row>");
        wb.println("      <Cell ss:Index=\"2\" ss:MergeAcross=\""+(colSpan+2)+"\" ss:StyleID=\"s47\"><Data ss:Type=\"String\">______________________                ______________________                ______________________</Data></Cell>");
        wb.println("     </Row>");       
        
        
        wb.println("    </Table>");
        wb.println("    <WorksheetOptions xmlns=\"urn:schemas-microsoft-com:office:excel\">");
        wb.println("     <Print>");
        wb.println("      <ValidPrinterInfo/>");
        wb.println("      <PaperSizeIndex>9</PaperSizeIndex>");
        wb.println("      <HorizontalResolution>-4</HorizontalResolution>");
        wb.println("      <VerticalResolution>0</VerticalResolution>");
        wb.println("     </Print>");
        wb.println("     <Selected/>");
        wb.println("     <DoNotDisplayGridlines/>");
        wb.println("     <DoNotDisplayZeros/>");
        wb.println("     <FreezePanes/>");
        wb.println("     <FrozenNoSplit/>");
        wb.println("     <SplitHorizontal>6</SplitHorizontal>");
        wb.println("     <TopRowBottomPane>6</TopRowBottomPane>");
        //wb.println("     <SplitVertical>1</SplitVertical>");
        //wb.println("     <LeftColumnRightPane>1</LeftColumnRightPane>");
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
