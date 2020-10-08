/*
 * RptSiteProfilingXLS.java
 *
 * Created on May 28, 2006, 1:33 AM
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

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.project.util.JSPFormater;
import com.project.fms.activity.*;
import com.project.payroll.*;
import com.project.util.jsp.*;

import com.project.general.Company;
import com.project.general.DbCompany;


public class RptModuleFlatXLS extends HttpServlet {
    
    /** Initializes the servlet.
    */  
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
        //response.setContentType("text/html");
        //response.setContentType("application/vnd.ms-excel");
        response.setContentType("application/x-msexcel");
        //response.setContentType("application/msoxmlviewer");

        long oidProj = 0;//FRMQueryString.requestLong(request, "project_id");
        String period = JSPRequestValue.requestString(request, "period");
        long periodX = Long.parseLong(period);


        System.out.println("\n\noidProj : "+oidProj+"\n\n");
        
        /*
        File tmpfile = File.createTempFile( "rptct", ".xml" ) ;
        PrintWriter wb = new PrintWriter( new FileWriter( tmpfile ) ) ;
        */
        
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

        wb.println("  <Style ss:ID=\"Default\" ss:Name=\"Normal\">");
        wb.println("   <Alignment ss:Vertical=\"Bottom\"/>");
        wb.println("   <Borders/>");
        wb.println("   <Font/>");
        wb.println("   <Interior/>");
        wb.println("   <NumberFormat/>");
        wb.println("   <Protection/>");
        wb.println("  </Style>");

        wb.println(" <Style ss:ID=\"sTitle\">");
        wb.println("   <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Bottom\"/>");
        wb.println("   <Font x:Family=\"Swiss\" ss:Size=\"18\" ss:Bold=\"1\"/>");
        wb.println("  </Style>");

        wb.println(" <Style ss:ID=\"sHeader\">");
        wb.println("   <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\"/>");
        wb.println("   <Borders>");
        wb.println("    <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\" />");
        wb.println("    <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\" />");
        wb.println("    <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\" />");
        wb.println("    <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\" />");
        wb.println("   </Borders>");
        wb.println("   <Font x:Family=\"Swiss\" ss:Bold=\"1\" />");
        wb.println("   <Interior ss:Color=\"#C0C0C0\" ss:Pattern=\"Solid\"/>");
        wb.println("  </Style>");
        
        wb.println("  <Style ss:ID=\"sRow\">");
        wb.println("   <Borders>");
        wb.println("    <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\" />");
        wb.println("    <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\" />");
        wb.println("    <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\" />");
        wb.println("    <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\" />");
        wb.println("   </Borders>");
        //wb.println("   <Interior ss:Color=\"#C6DCBE\" ss:Pattern=\"Solid\"/>");
        wb.println("  </Style>");

        wb.println("  <Style ss:ID=\"sRowBold\">");
        wb.println("   <Borders>");
        wb.println("    <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\" />");
        wb.println("    <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\" />");
        wb.println("    <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\" />");
        wb.println("    <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\" />");
        wb.println("   </Borders>");
        wb.println("   <Font x:Family=\"Swiss\" ss:Bold=\"1\"/>");
        //wb.println("   <Interior ss:Color=\"#C6DCBE\" ss:Pattern=\"Solid\"/>");
        wb.println("  </Style>");                

        wb.println("  <Style ss:ID=\"sRowCenter\">");
        wb.println("   <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("   <Borders>");
        wb.println("    <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\" />");
        wb.println("    <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\" />");
        wb.println("    <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\" />");
        wb.println("    <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\" />");
        wb.println("   </Borders>");
        //wb.println("   <Interior ss:Color=\"#C6DCBE\" ss:Pattern=\"Solid\"/>");
        wb.println("  </Style>");                
        wb.println(" </Styles>");
        wb.flush() ;
        
        
        // Detail Region
        wb.println(" <Worksheet ss:Name=\"module\">");
        wb.println("  <Names>");
        wb.println("   <NamedRange ss:Name=\"Print_Area\" ss:RefersTo=\"=Sheet1!C1:C7\"/>");
        wb.println("  </Names>");
        wb.println("  <Table>");
        wb.println("   <Column ss:AutoFitWidth=\"0\" ss:Width=\"108.75\"/>");
        wb.println("   <Column ss:AutoFitWidth=\"0\" ss:Width=\"143.25\"/>");
        wb.println("   <Column ss:Width=\"31.5\"/>");
        wb.println("   <Column ss:AutoFitWidth=\"0\" ss:Width=\"143.25\" ss:Span=\"3\"/>");
        wb.println("   <Column ss:Index=\"8\" ss:AutoFitWidth=\"0\" ss:Width=\"76.5\"/>");
        wb.println("   <Column ss:AutoFitWidth=\"0\" ss:Width=\"93\" ss:Span=\"1\"/>");
        wb.println("   <Row ss:AutoFitHeight=\"0\" ss:Height=\"23.25\">");
        
        ActivityPeriod ap = new ActivityPeriod();
        try{
            ap = DbActivityPeriod.fetchExc(periodX);
        }catch(Exception e){
            
        }
        
        wb.println("    <Cell ss:StyleID=\"sTitle\"><Data ss:Type=\"String\" x:Ticked=\"1\">Activity Data ("+ap.getName()+")</Data><NamedCell");
        wb.println("      ss:Name=\"Print_Area\"/></Cell>");
        wb.println("   </Row>");
        wb.println("   <Row ss:Index=\"3\" ss:AutoFitHeight=\"0\" ss:Height=\"22.5\">");
        wb.println("    <Cell ss:StyleID=\"sHeader\"><Data ss:Type=\"String\">Code</Data><NamedCell");
        wb.println("      ss:Name=\"Print_Area\"/></Cell>");
        wb.println("    <Cell ss:StyleID=\"sHeader\"><Data ss:Type=\"String\">Description</Data><NamedCell");
        wb.println("      ss:Name=\"Print_Area\"/></Cell>");
        wb.println("    <Cell ss:StyleID=\"sHeader\"><Data ss:Type=\"String\">Level</Data><NamedCell");
        wb.println("      ss:Name=\"Print_Area\"/></Cell>");       
        wb.println("    <Cell ss:StyleID=\"sHeader\"><Data ss:Type=\"String\">Parent</Data><NamedCell");
        wb.println("      ss:Name=\"Print_Area\"/></Cell>");
        wb.println("    <Cell ss:StyleID=\"sHeader\"><Data ss:Type=\"String\" x:Ticked=\"1\">Output and Deliverable</Data><NamedCell");
        wb.println("      ss:Name=\"Print_Area\"/></Cell>");
        wb.println("    <Cell ss:StyleID=\"sHeader\"><Data ss:Type=\"String\">Performance Indicator</Data><NamedCell");
        wb.println("      ss:Name=\"Print_Area\"/></Cell>");
        wb.println("    <Cell ss:StyleID=\"sHeader\"><Data ss:Type=\"String\">Assumtion and Risk</Data><NamedCell");
        wb.println("      ss:Name=\"Print_Area\"/></Cell>");
        wb.println("    <Cell ss:StyleID=\"sHeader\"><Data ss:Type=\"String\">Status</Data><NamedCell");
        wb.println("      ss:Name=\"Print_Area\"/></Cell>");
        wb.println("    <Cell ss:StyleID=\"sHeader\"><Data ss:Type=\"String\">Type</Data><NamedCell");
        wb.println("      ss:Name=\"Print_Area\"/></Cell>");
        wb.println("    <Cell ss:StyleID=\"sHeader\"><Data ss:Type=\"String\">Activity Code</Data><NamedCell");
        wb.println("      ss:Name=\"Print_Area\"/></Cell>");        
        wb.println("   </Row>");
      
        
        // Load MODULE list
        int recordToGet = 10;
        String whereClause = " activity_period_id="+periodX;
        String orderClause = "code";
        Vector listModule = new Vector(1,1);
        int vectSize = DbModule.getCount(whereClause);
        recordToGet = vectSize;

        // get record to display 
        listModule = DbModule.list(0,recordToGet, whereClause , orderClause);       
        
        if(listModule!=null && listModule.size()>0)
        {
            for(int i=0; i<listModule.size(); i++)
            {
                Module module = (Module)listModule.get(i);
                String str = "";
                if(module.getLevel().equals("S")){
                    str = "       ";
                }
                else if(module.getLevel().equals("H")){
                    str = "              ";
                }
                else if(module.getLevel().equals("A")){
                    str = "                     ";                
                }
                else if(module.getLevel().equals("SA")){
                    str = "                            ";
                }
                                
                wb.println("   <Row>");
                if (module.getStatus().trim().equalsIgnoreCase("Header"))
                {
                    wb.println("    <Cell ss:StyleID=\"sRowBold\"><Data ss:Type=\"String\">" + str+((module.getLevel().equals("M")) ? ""+module.getCode()+"" : module.getCode()) + "</Data></Cell>");
                }else
                {
                    wb.println("    <Cell ss:StyleID=\"sRow\"><Data ss:Type=\"String\">" + str+((module.getLevel().equals("M")) ? ""+module.getCode()+"" : module.getCode()) + "</Data></Cell>");
                }
                wb.println("    <Cell ss:StyleID=\"sRow\"><Data ss:Type=\"String\">" + ((module.getLevel().equals("M")) ? ""+module.getDescription()+"" : module.getDescription()) +"</Data></Cell>");
                wb.println("    <Cell ss:StyleID=\"sRowCenter\"><Data ss:Type=\"String\">" + ((module.getLevel().equals("M")) ? ""+module.getLevel()+"" : module.getLevel()) +"</Data></Cell>");
                    Module m = new Module();
                    m.setDescription("-");
                    if(module.getParentId()!=0){
                        try{
                            m = DbModule.fetchExc(module.getParentId());
                        }
                        catch(Exception e){}
                    }
                wb.println("    <Cell ss:StyleID=\"sRow\"><Data ss:Type=\"String\">" + ((module.getLevel().equals("M")) ? ""+ m.getDescription()+"" : module.getDescription()) +"</Data></Cell>");
                wb.println("    <Cell ss:StyleID=\"sRow\"><Data ss:Type=\"String\">" + ((module.getLevel().equals("M")) ? ""+module.getOutputDeliver()+"" : module.getOutputDeliver()) + "</Data></Cell>");
                wb.println("    <Cell ss:StyleID=\"sRow\"><Data ss:Type=\"String\">" + ((module.getLevel().equals("M")) ? ""+module.getPerformIndicator()+"" : module.getPerformIndicator()) +"</Data></Cell>");
                wb.println("    <Cell ss:StyleID=\"sRow\"><Data ss:Type=\"String\">" + ((module.getLevel().equals("M")) ? ""+module.getAssumRisk()+"" : module.getAssumRisk()) +"</Data></Cell>");                
                wb.println("    <Cell ss:StyleID=\"sRow\"><Data ss:Type=\"String\">" + ((module.getLevel().equals("M")) ? ""+module.getStatus()+"" : module.getStatus()) +"</Data></Cell>");                
                wb.println("    <Cell ss:StyleID=\"sRow\"><Data ss:Type=\"String\">" + ((module.getLevel().equals("M")) ? ""+module.getType()+"" : module.getType()) +"</Data></Cell>");                                
                wb.println("    <Cell ss:StyleID=\"sRow\"><Data ss:Type=\"String\">" + ((module.getLevel().equals("M")) ? ""+module.getCode()+"" : module.getCode()) +"</Data></Cell>");
                wb.println("   </Row>");
            }
        }        
        
        wb.println("  </Table>");
        wb.println("  <WorksheetOptions xmlns=\"urn:schemas-microsoft-com:office:excel\">");
        wb.println("   <PageSetup>");
        wb.println("    <Layout x:Orientation=\"Landscape\" x:CenterHorizontal=\"1\"/>");
        wb.println("    <PageMargins x:Bottom=\"0.5\" x:Left=\"0.25\" x:Right=\"0.25\" x:Top=\"0.5\"/>");
        wb.println("   </PageSetup>");
        wb.println("   <Print>");
        wb.println("    <ValidPrinterInfo/>");
        wb.println("    <PaperSizeIndex>9</PaperSizeIndex>");
        wb.println("    <Scale>65</Scale>");
        wb.println("    <HorizontalResolution>-4</HorizontalResolution>");
        wb.println("    <VerticalResolution>0</VerticalResolution>");
        wb.println("   </Print>");
        wb.println("   <Zoom>80</Zoom>");
        wb.println("   <Selected/>");
        wb.println("   <DoNotDisplayGridlines/>");
        wb.println("   <FreezePanes/>");
        wb.println("   <FrozenNoSplit/>");
        wb.println("   <SplitHorizontal>3</SplitHorizontal>");
        wb.println("   <TopRowBottomPane>3</TopRowBottomPane>");
        wb.println("   <ActivePane>2</ActivePane>");
        wb.println("   <Panes>");
        wb.println("    <Pane>");
        wb.println("     <Number>3</Number>");
        wb.println("    </Pane>");
        wb.println("    <Pane>");
        wb.println("     <Number>2</Number>");
        wb.println("     <ActiveRow>1</ActiveRow>");
        wb.println("    </Pane>");
        wb.println("   </Panes>");
        wb.println("   <ProtectObjects>False</ProtectObjects>");
        wb.println("   <ProtectScenarios>False</ProtectScenarios>");
        wb.println("  </WorksheetOptions>");


        wb.println(" </Worksheet>");
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
