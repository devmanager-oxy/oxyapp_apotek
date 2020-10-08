/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
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

/**
 *
 * @author Roy Andika
 */
public class RptPenjelasanXLS extends HttpServlet{
    
    /** Initializes the servlet.
    */  
    public static String formatDate = "dd MMMM yyyy";
    
    public void init(ServletConfig config) throws ServletException {
        super.init(config);

    }

    /** 
     * Destroys the servlet.
    */  
    public void destroy() {

    }

    String XMLSafe ( String in )
    {
        return in;    	
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
        
	//Count total Column
	int colSpan = 0;
        System.out.println(colSpan);
        
        boolean gzip = false ;
        
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
        wb.println("xmlns:o=\"urn:schemas-microsoft-com:office:office\"");
        wb.println("xmlns:x=\"urn:schemas-microsoft-com:office:excel\"");
        wb.println("xmlns:ss=\"urn:schemas-microsoft-com:office:spreadsheet\"");
        wb.println("xmlns:html=\"http://www.w3.org/TR/REC-html40\">");
        wb.println("<DocumentProperties xmlns=\"urn:schemas-microsoft-com:office:office\">");
        wb.println("<Author>PNCI</Author>");
        wb.println("<LastAuthor>PNCI</LastAuthor>");
        wb.println("<Created>2011-03-16T18:29:07Z</Created>");
        wb.println("<LastSaved>2011-03-16T18:39:57Z</LastSaved>");
        wb.println("<Company>Development</Company>");
        wb.println("<Version>12.00</Version>");
        wb.println("</DocumentProperties>");
        wb.println("<ExcelWorkbook xmlns=\"urn:schemas-microsoft-com:office:excel\">");
        wb.println("<WindowHeight>8640</WindowHeight>");
        wb.println("<WindowWidth>18975</WindowWidth>");
        wb.println("<WindowTopX>120</WindowTopX>");
        wb.println("<WindowTopY>30</WindowTopY>");
        wb.println("<ProtectStructure>False</ProtectStructure>");
        wb.println("<ProtectWindows>False</ProtectWindows>");
        wb.println("</ExcelWorkbook>");
        wb.println("<Styles>");
        wb.println("<Style ss:ID=\"Default\" ss:Name=\"Normal\">");
        wb.println("<Alignment ss:Vertical=\"Bottom\"/>");
        wb.println("<Borders/>");
        wb.println("<Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"/>");
        wb.println("<Interior/>");
        wb.println("<NumberFormat/>");
        wb.println("<Protection/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s62\">");
        wb.println("<Alignment ss:Horizontal=\"Right\" ss:Vertical=\"Bottom\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s63\">");
        wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("<Font ss:FontName=\"Arial\" x:Family=\"Swiss\" ss:Size=\"18\" ss:Bold=\"1\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s64\">");
        wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("<Font ss:FontName=\"Arial\" x:Family=\"Swiss\" ss:Size=\"16\" ss:Bold=\"1\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s86\">");
        wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Double\" ss:Weight=\"3\"/>");
        wb.println("</Borders>");
        wb.println("<Font ss:FontName=\"Arial\" ss:Size=\"12\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s96\">");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s107\">");
        wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Interior ss:Color=\"#A5A5A5\" ss:Pattern=\"Solid\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s109\">");
        wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("<NumberFormat/>");
        wb.println("</Style> ");
        wb.println("<Style ss:ID=\"s110\">");
        wb.println("<Alignment ss:Horizontal=\"Right\" ss:Vertical=\"Center\" ss:Indent=\"1\"/>");
        wb.println("<Font ss:FontName=\"Arial\" x:Family=\"Swiss\" ss:Bold=\"1\"/>");
        wb.println("<NumberFormat ss:Format=\"#,##0.00_);\\(#,##0.00\\)\"/>");
        wb.println("</Style> ");
        wb.println("<Style ss:ID=\"s111\">");
        wb.println("<Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Center\"/>");
        wb.println("<Font ss:FontName=\"Arial\" x:Family=\"Swiss\" ss:Bold=\"1\"/>");
        wb.println("</Style> ");
        wb.println("<Style ss:ID=\"s112\">");
        wb.println("<Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Center\"/>");
        wb.println("</Style> ");
        wb.println("<Style ss:ID=\"s113\">");
        wb.println("<Alignment ss:Horizontal=\"Right\" ss:Vertical=\"Center\" ss:Indent=\"1\"/>");
        wb.println("<NumberFormat ss:Format=\"#,##0.00_);\\(#,##0.00\\)\"/>");
        wb.println("</Style> ");
        wb.println("</Styles> ");
        
        
        /** ---- new -------*/
        wb.println("<Worksheet ss:Name=\"Sheet1\">");
        //wb.println("<Table>");
        wb.println("<Table ss:ExpandedColumnCount=\"4\" x:FullColumns=\"1\"");
        wb.println(" x:FullRows=\"1\" ss:DefaultRowHeight=\"15\">");
        wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"22.5\"/>");
        wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"317.25\"/>");
        wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"225.75\"/>");
        wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"216\"/>");
        wb.println("<Row>");
        wb.println("<Cell ss:Index=\"4\" ss:StyleID=\"s62\"><Data ss:Type=\"String\">Printed : 16 March 2011</Data></Cell>");
        wb.println("</Row>");
        
        //Top Header
        company = new Company();
        try{
            company = DbCompany.fetchExc(oidCompany);
        }
        catch(Exception e){}   
        
        Periode periode = DbPeriode.getOpenPeriod();
        String openPeriod = JSPFormater.formatDate(periode.getStartDate(), "MMMM yyyy");
        
        wb.println("<Row ss:Height=\"23.25\">");
        wb.println("<Cell ss:Index=\"2\" ss:MergeAcross=\"2\" ss:StyleID=\"s63\"><Data ss:Type=\"String\"");
        wb.println("x:Ticked=\"1\">"+company.getName().toUpperCase()+"</Data></Cell>");
        wb.println("</Row>");
        wb.println("<Row ss:Height=\"20.25\">");
        wb.println("<Cell ss:Index=\"2\" ss:MergeAcross=\"2\" ss:StyleID=\"s64\"><Data ss:Type=\"String\">PENJELASAN NERACA AKHIR</Data></Cell>");
        wb.println("</Row>");
        wb.println("<Row ss:Height=\"16.5\">");
        wb.println("<Cell ss:Index=\"2\" ss:MergeAcross=\"2\" ss:StyleID=\"s86\"><Data ss:Type=\"String\">BULAN "+openPeriod.toUpperCase()+"</Data></Cell>");
        wb.println("</Row>");
        
        Date openPeriodLastyear = DbPeriode.getOpenPeriodLastYear();
        String strOpenPeriod = JSPFormater.formatDate(openPeriodLastyear, "MMMM yyyy");
        
        wb.println("<Row ss:Height=\"15.75\"/>");
        wb.println("<Row ss:Index=\"7\" ss:StyleID=\"s96\">");
        wb.println("<Cell ss:Index=\"2\" ss:StyleID=\"s107\"><Data ss:Type=\"String\">Description</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s107\"><Data ss:Type=\"String\">"+openPeriod+"</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s107\"><Data ss:Type=\"String\">"+strOpenPeriod+"</Data></Cell>");
        wb.println("</Row>");
        
        for(int i=0; i<vectorList.size(); i++){
            
            SesReportBs srb = (SesReportBs)vectorList.get(i);
            
            wb.println("<Row>");
            wb.println("<Cell ss:Index=\"2\" ss:StyleID=\"s112\"><Data ss:Type=\"String\">"+srb.getDescription()+"</Data></Cell>");
           
            String strAmount = srb.getStrAmount();
            String strAmount_lastYear = srb.getStrAmountPrevYear();
            
            double dblAmount = 0;
            try{
                dblAmount = Double.parseDouble(strAmount);
            }catch(Exception e){
                System.out.println("[exception] "+e.toString());
            }
            
            double dblAmount_lastYear = 0;
            try{
                dblAmount_lastYear = Double.parseDouble(strAmount_lastYear);
            }catch(Exception e){
                System.out.println("[exception] "+e.toString());
            }
            
            wb.println("<Cell ss:StyleID=\"s113\"><Data ss:Type=\"Number\">"+dblAmount+"</Data></Cell>");
            wb.println("<Cell ss:StyleID=\"s113\"><Data ss:Type=\"Number\">"+dblAmount_lastYear+"</Data></Cell>");
            wb.println("</Row>");
        
        }
        
        wb.println("<Row>");
        wb.println("<Cell ss:Index=\"2\" ss:MergeAcross=\"1\" ss:StyleID=\"s109\"><Data ss:Type=\"String\"></Data></Cell>");
        wb.println("</Row>");
        wb.println("<Row>");
        wb.println("<Cell ss:Index=\"2\" ss:MergeAcross=\"1\" ss:StyleID=\"s109\"><Data ss:Type=\"String\">Date : _________________                Date : _________________                Date : _________________</Data></Cell>");
        wb.println("</Row>");
        wb.println("<Row>");
        wb.println("<Cell ss:Index=\"2\" ss:MergeAcross=\"1\" ss:StyleID=\"s109\"><Data ss:Type=\"String\">Approve by                                            Review by                                            Prepare by</Data></Cell>");
        wb.println("</Row>");
        wb.println("<Row>");
        wb.println("<Cell ss:Index=\"2\" ss:MergeAcross=\"1\" ss:StyleID=\"s109\"><Data ss:Type=\"String\"></Data></Cell>");
        wb.println("</Row>");
        wb.println("<Row>");
        wb.println("<Cell ss:Index=\"2\" ss:MergeAcross=\"1\" ss:StyleID=\"s109\"><Data ss:Type=\"String\"></Data></Cell>");
        wb.println("</Row>");
        wb.println("<Row>");
        wb.println("<Cell ss:Index=\"2\" ss:MergeAcross=\"1\" ss:StyleID=\"s109\"><Data ss:Type=\"String\"></Data></Cell>");
        wb.println("</Row>");
        wb.println("<Row>");
        wb.println("<Cell ss:Index=\"2\" ss:MergeAcross=\"1\" ss:StyleID=\"s109\"><Data ss:Type=\"String\"></Data></Cell>");
        wb.println("</Row>");
        wb.println("<Row>");
        wb.println("<Cell ss:Index=\"2\" ss:MergeAcross=\"1\" ss:StyleID=\"s109\"><Data ss:Type=\"String\">______________________                ______________________                ______________________</Data></Cell>");
        wb.println("</Row>");
        wb.println("</Table>");
        wb.println("<WorksheetOptions xmlns=\"urn:schemas-microsoft-com:office:excel\">");
        wb.println("<PageSetup>");
        wb.println("<Header x:Margin=\"0.3\"/>");
        wb.println("<Footer x:Margin=\"0.3\"/>");
        wb.println("<PageMargins x:Bottom=\"0.75\" x:Left=\"0.7\" x:Right=\"0.7\" x:Top=\"0.75\"/>");
        wb.println("</PageSetup>");
        wb.println("<Selected/>");
        wb.println("<DoNotDisplayGridlines/>");
        wb.println("<TopRowVisible>2</TopRowVisible>");
        wb.println("<Panes>");
        wb.println("<Pane>");
        wb.println("<Number>3</Number>");
        wb.println("<ActiveRow>8</ActiveRow>");
        wb.println("<ActiveCol>2</ActiveCol>");
        wb.println("</Pane>");
        wb.println("</Panes>");
        wb.println("<ProtectObjects>False</ProtectObjects>");
        wb.println("<ProtectScenarios>False</ProtectScenarios>");
        wb.println("</WorksheetOptions>");
        
        wb.println("</Worksheet>");
        wb.println("<Worksheet ss:Name=\"Sheet2\">");
        wb.println("<Table ss:ExpandedColumnCount=\"1\" ss:ExpandedRowCount=\"1\" x:FullColumns=\"1\" ");
        wb.println("x:FullRows=\"1\" ss:DefaultRowHeight=\"15\">");
        wb.println("</Table>");
        wb.println("<WorksheetOptions xmlns=\"urn:schemas-microsoft-com:office:excel\">");
        wb.println("<PageSetup>");
        wb.println("<Header x:Margin=\"0.3\"/>");
        wb.println("<Footer x:Margin=\"0.3\"/>");
        wb.println("<PageMargins x:Bottom=\"0.75\" x:Left=\"0.7\" x:Right=\"0.7\" x:Top=\"0.75\"/>");
        wb.println("</PageSetup>");
        wb.println("<ProtectObjects>False</ProtectObjects>");
        wb.println("<ProtectScenarios>False</ProtectScenarios>");
        wb.println("</WorksheetOptions>");
        wb.println("</Worksheet>");
        wb.println("<Worksheet ss:Name=\"Sheet3\">");
        wb.println("<Table ss:ExpandedColumnCount=\"1\" ss:ExpandedRowCount=\"1\" x:FullColumns=\"1\"");
        wb.println("x:FullRows=\"1\" ss:DefaultRowHeight=\"15\">");
        wb.println("</Table>");
        wb.println("<WorksheetOptions xmlns=\"urn:schemas-microsoft-com:office:excel\">");
        wb.println("<PageSetup>");
        wb.println("<Header x:Margin=\"0.3\"/>");
        wb.println("<Footer x:Margin=\"0.3\"/>");
        wb.println("<PageMargins x:Bottom=\"0.75\" x:Left=\"0.7\" x:Right=\"0.7\" x:Top=\"0.75\"/>");
        wb.println("</PageSetup>");
        wb.println("<ProtectObjects>False</ProtectObjects>");
        wb.println("<ProtectScenarios>False</ProtectScenarios>");
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
