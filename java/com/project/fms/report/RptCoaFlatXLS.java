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
import com.project.fms.master.*;
import com.project.payroll.*;

import com.project.general.Company;
import com.project.general.DbCompany;


public class RptCoaFlatXLS extends HttpServlet {
    
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
        wb.println(" </Styles>");
        wb.flush() ;
        
        
        // Detail Region
        wb.println(" <Worksheet ss:Name=\"coa\">");
        wb.println("  <Names>");
        wb.println("   <NamedRange ss:Name=\"Print_Area\" ss:RefersTo=\"=Sheet1!C1:C7\"/>");
        wb.println("  </Names>");
        wb.println("  <Table>");
        wb.println("   <Column ss:AutoFitWidth=\"0\" ss:Width=\"108.75\"/>");
        wb.println("   <Column ss:AutoFitWidth=\"0\" ss:Width=\"161.25\"/>");
        wb.println("   <Column ss:AutoFitWidth=\"0\" ss:Width=\"135\" ss:Span=\"2\"/>");
        wb.println("   <Column ss:Index=\"6\" ss:AutoFitWidth=\"0\" ss:Width=\"108.75\" ss:Span=\"2\"/>");
        wb.println("   <Row ss:AutoFitHeight=\"0\" ss:Height=\"23.25\">");
        wb.println("    <Cell ss:StyleID=\"sTitle\"><Data ss:Type=\"String\" x:Ticked=\"1\">Chart Of Account</Data><NamedCell");
        wb.println("      ss:Name=\"Print_Area\"/></Cell>");
        wb.println("   </Row>");
        
        wb.println("   <Row ss:Index=\"3\" ss:AutoFitHeight=\"0\" ss:Height=\"22.5\">");
        wb.println("    <Cell ss:StyleID=\"sHeader\"><Data ss:Type=\"String\" x:Ticked=\"1\">Account Code</Data><NamedCell");
        wb.println("      ss:Name=\"Print_Area\"/></Cell>");
        wb.println("    <Cell ss:StyleID=\"sHeader\"><Data ss:Type=\"String\">Account Name</Data><NamedCell");
        wb.println("      ss:Name=\"Print_Area\"/></Cell>");
        wb.println("    <Cell ss:StyleID=\"sHeader\"><Data ss:Type=\"String\">Account Group</Data><NamedCell");
        wb.println("      ss:Name=\"Print_Area\"/></Cell>");
        wb.println("    <Cell ss:StyleID=\"sHeader\"><Data ss:Type=\"String\">Department</Data><NamedCell");
        wb.println("      ss:Name=\"Print_Area\"/></Cell>");
        wb.println("    <Cell ss:StyleID=\"sHeader\"><Data ss:Type=\"String\">Section</Data><NamedCell");
        wb.println("      ss:Name=\"Print_Area\"/></Cell>");
        wb.println("    <Cell ss:StyleID=\"sHeader\"><Data ss:Type=\"String\">Balance Total</Data><NamedCell");
        wb.println("      ss:Name=\"Print_Area\"/></Cell>");
        wb.println("    <Cell ss:StyleID=\"sHeader\"><Data ss:Type=\"String\">Acc. Type</Data><NamedCell");
        wb.println("      ss:Name=\"Print_Area\"/></Cell>");
        wb.println("    <Cell ss:StyleID=\"sHeader\"><Data ss:Type=\"String\">Account Number</Data><NamedCell");
        wb.println("      ss:Name=\"Print_Area\"/></Cell>");
        wb.println("   </Row>");
       
        
        // Load COA list
        int recordToGet = 10;
        String whereClause = "";
        String orderClause = "code";
        Vector listCoa = new Vector(1,1);
        int vectSize = DbCoa.getCount(whereClause);
        recordToGet = vectSize;

        // get record to display 
        listCoa = DbCoa.list(0,recordToGet, whereClause , orderClause);       
        
        if(listCoa!=null && listCoa.size()>0)
        {
            for(int i=0; i<listCoa.size(); i++)
            {
                Coa coa = (Coa)listCoa.get(i);
                String str = "";
                switch(coa.getLevel())
                {
                    case 1 : 											
                        break;
                    case 2 : 
                        str = "       ";
                        break;
                    case 3 :
                        str = "              ";
                        break;
                    case 4 :
                        str = "                     ";
                        break;
                    case 5 :
                        str = "                            ";
                        break;				
                }
                
                wb.println("   <Row>");
                if (coa.getStatus().trim().equalsIgnoreCase("Header"))
                {
                    wb.println("    <Cell ss:StyleID=\"sRowBold\"><Data ss:Type=\"String\">" + str + coa.getCode() + "</Data></Cell>");
                }
                else
                {
                    wb.println("    <Cell ss:StyleID=\"sRow\"><Data ss:Type=\"String\">" + str + coa.getCode() + "</Data></Cell>");
                }
                wb.println("    <Cell ss:StyleID=\"sRow\"><Data ss:Type=\"String\">" + coa.getName() + "</Data></Cell>");
                wb.println("    <Cell ss:StyleID=\"sRow\"><Data ss:Type=\"String\">" + coa.getAccountGroup() +"</Data></Cell>");
                    Department d = new Department();
                    try{	
                        d = DbDepartment.fetchExc(coa.getDepartmentId());
                    }
                    catch(Exception e){}
                wb.println("    <Cell ss:StyleID=\"sRow\"><Data ss:Type=\"String\">" + d.getName() +"</Data></Cell>");
                    Section s = new Section();
                    try{	
                        s = DbSection.fetchExc(coa.getSectionId());
                    }
                    catch(Exception e){}                    
                wb.println("    <Cell ss:StyleID=\"sRow\"><Data ss:Type=\"String\">" + s.getName() +"</Data></Cell>");
                wb.println("    <Cell ss:StyleID=\"sRow\"><Data ss:Type=\"String\"></Data></Cell>");
                wb.println("    <Cell ss:StyleID=\"sRow\"><Data ss:Type=\"String\">" + coa.getStatus() +"</Data></Cell>");
                wb.println("    <Cell ss:StyleID=\"sRow\"><Data ss:Type=\"String\">" + coa.getCode() +"</Data></Cell>");                
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
        wb.println("    <Scale>75</Scale>");
        wb.println("    <HorizontalResolution>-4</HorizontalResolution>");
        wb.println("    <VerticalResolution>0</VerticalResolution>");
        wb.println("   </Print>");
        wb.println("   <Zoom>90</Zoom>");
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
