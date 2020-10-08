/*
 * Report Profit & Loss XLS.java
 *
 * Created on March 15, 2008, 1:33 AM
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
import com.project.general.DbCompany;
import com.project.general.Company;


public class RptProfitLossXLS extends HttpServlet {
    
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
        
        //Load Title Header
        int pnlType = JSPRequestValue.requestInt(request, "pnl_type");
        String strTitle = "";
        if(pnlType==0){
            strTitle = "REALISASI PENYERAPAN BIAYA";
        }else{
            strTitle = "REALISASI PENYERAPAN PENDAPATAN";
        }
        
        // Load Company
        Company company = DbCompany.getCompany();
        long oidCompany = company.getOID();           
        System.out.println("oidCompany : "+oidCompany);        

        // Load Invoice Item
        Vector vectorList = new Vector(1,1);
        try{
            HttpSession session = request.getSession();
            vectorList = (Vector)session.getValue("PROFIT");
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
        
        wb.println("<Style ss:ID=\"s20\" ss:Name=\"Percent\">");
        wb.println("<NumberFormat ss:Format=\"0%\"/>");
        wb.println("</Style>");
        
        wb.println("   <Style ss:ID=\"s41\">");
        wb.println("    <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\" ss:WrapText=\"1\"/>");
        wb.println("    <Borders>");
        wb.println("     <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("     <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("     <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("     <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("    </Borders>");
        wb.println("    <Font x:Family=\"Swiss\" ss:Bold=\"1\"/>");
        wb.println("    <Interior ss:Color=\"#C0C0C0\" ss:Pattern=\"Solid\"/>");
        wb.println("   </Style>");
        
        /*
        wb.println("   <Style ss:ID=\"s47\">");
        wb.println("    <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("    <NumberFormat/>");
        wb.println("   </Style>");
         */
        
        //==================== new style =====================
        /*
        wb.println("<Style ss:ID=\"m17580806\">");
        wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\" ss:WrapText=\"1\"/>");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font x:Family=\"Swiss\" ss:Bold=\"1\"/>");
        wb.println("<Interior ss:Color=\"#C0C0C0\" ss:Pattern=\"Solid\"/>");
        wb.println("</Style>");
        
        wb.println("<Style ss:ID=\"m17580816\">");
        wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\" ss:WrapText=\"1\"/>");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font x:Family=\"Swiss\" ss:Bold=\"1\"/>");
        wb.println("<Interior ss:Color=\"#C0C0C0\" ss:Pattern=\"Solid\"/>");
        wb.println("</Style>");

        wb.println("<Style ss:ID=\"m17580826\">");
        wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\" ss:WrapText=\"1\"/>");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font x:Family=\"Swiss\" ss:Bold=\"1\"/>");
        wb.println("<Interior ss:Color=\"#C0C0C0\" ss:Pattern=\"Solid\"/>");
        wb.println("</Style>");
         */
                
        wb.println("<Style ss:ID=\"m17253318\">");
        wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\" ss:WrapText=\"1\"/>");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font x:Family=\"Swiss\" ss:Bold=\"1\"/>");
        wb.println("<Interior ss:Color=\"#C0C0C0\" ss:Pattern=\"Solid\"/>");
        wb.println("</Style>");
        
        wb.println("<Style ss:ID=\"m17253328\">");
        wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\" ss:WrapText=\"1\"/>");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font x:Family=\"Swiss\" ss:Bold=\"1\"/>");
        wb.println("<Interior ss:Color=\"#C0C0C0\" ss:Pattern=\"Solid\"/>");
        wb.println("</Style>");
        
        wb.println("<Style ss:ID=\"m17253338\">");
        wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\" ss:WrapText=\"1\"/>");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font x:Family=\"Swiss\" ss:Bold=\"1\"/>");
        wb.println("<Interior ss:Color=\"#C0C0C0\" ss:Pattern=\"Solid\"/>");
        wb.println("</Style>");
        
        wb.println("<Style ss:ID=\"m17253348\">");
        wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\" ss:WrapText=\"1\"/>");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font x:Family=\"Swiss\" ss:Bold=\"1\"/>");
        wb.println("<Interior ss:Color=\"#C0C0C0\" ss:Pattern=\"Solid\"/>");
        wb.println("</Style>");
        
        wb.println("<Style ss:ID=\"m17253358\">");
        wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\" ss:WrapText=\"1\"/>");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font x:Family=\"Swiss\" ss:Bold=\"1\"/>");
        wb.println("<Interior ss:Color=\"#C0C0C0\" ss:Pattern=\"Solid\"/>");
        wb.println("</Style>");
        
        //=============================================== end ========================================
        
        
        wb.println("<Style ss:ID=\"s52\">");
        wb.println("<Alignment ss:Horizontal=\"Right\" ss:Vertical=\"Center\" ss:Indent=\"1\"/>");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font x:Family=\"Swiss\" ss:Bold=\"1\"/>");
        wb.println("<Interior ss:Color=\"#FFFF99\" ss:Pattern=\"Solid\"/>");
        wb.println("<NumberFormat ss:Format=\"#,##0.00_);\\(#,##0.00\\)\"/>");
        wb.println("</Style>");
        
        wb.println("<Style ss:ID=\"s50\">");
        wb.println("<Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Center\"/>");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font x:Family=\"Swiss\" ss:Bold=\"1\"/>");
        wb.println("<Interior ss:Color=\"#FFFF99\" ss:Pattern=\"Solid\"/>");
        wb.println("</Style>");
        
        wb.println("<Style ss:ID=\"s47\">");
        wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<NumberFormat/>");
        wb.println("</Style>");

        wb.println("<Style ss:ID=\"s49\">");
        wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("<NumberFormat/>");
        wb.println("</Style>");
        
        wb.println("<Style ss:ID=\"s72\">");
        wb.println("<Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Center\"/>");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font x:Family=\"Swiss\" ss:Bold=\"1\"/>");
        wb.println("<Interior/>");
        wb.println("</Style>");

        wb.println("<Style ss:ID=\"s70\">");
        wb.println("<Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Center\"/>");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font x:Family=\"Swiss\" ss:Bold=\"1\"/>");
        wb.println("<Interior ss:Color=\"#00CCFF\" ss:Pattern=\"Solid\"/>");
        wb.println("</Style>");
        
        //======================================================================================================
        
                                wb.println("   <Style ss:ID=\"s44\">");
                                wb.println("    <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Center\"/>");
                                wb.println("    <Borders>");
                                wb.println("     <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
                                wb.println("     <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
                                wb.println("     <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
                                wb.println("     <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
                                wb.println("    </Borders>");
                                wb.println("   </Style>");

                                wb.println("   <Style ss:ID=\"s44b\">");
                                wb.println("    <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Center\"/>");
                                wb.println("    <Borders>");
                                wb.println("     <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
                                wb.println("     <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
                                wb.println("     <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
                                wb.println("     <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
                                wb.println("    </Borders>");
                                wb.println("    <Font x:Family=\"Swiss\" ss:Bold=\"1\"/>");
                                wb.println("   </Style>");

                                wb.println("   <Style ss:ID=\"s45\">");
                                wb.println("    <Alignment ss:Horizontal=\"Right\" ss:Vertical=\"Center\" ss:Indent=\"1\"/>");
                                wb.println("    <Borders>");
                                wb.println("     <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
                                wb.println("     <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
                                wb.println("     <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
                                wb.println("     <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
                                wb.println("    </Borders>");
                                wb.println("    <NumberFormat ss:Format=\"#,##0.00_);\\(#,##0.00\\)\"/>");              
                                wb.println("   </Style>");

                                wb.println("   <Style ss:ID=\"s45b\">");
                                wb.println("    <Alignment ss:Horizontal=\"Right\" ss:Vertical=\"Center\" ss:Indent=\"1\"/>");
                                wb.println("    <Borders>");
                                wb.println("     <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
                                wb.println("     <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
                                wb.println("     <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
                                wb.println("     <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
                                wb.println("    </Borders>");
                                wb.println("    <Font x:Family=\"Swiss\" ss:Bold=\"1\"/>");        
                                wb.println("    <NumberFormat ss:Format=\"#,##0.00_);\\(#,##0.00\\)\"/>");        
                                wb.println("   </Style>");
                                
                                wb.println("<Style ss:ID=\"s55\" ss:Parent=\"s20\">");
                                wb.println("<Alignment ss:Horizontal=\"Right\" ss:Vertical=\"Center\" ss:Indent=\"1\"/>");
                                wb.println("<Borders>");
                                wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
                                wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
                                wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
                                wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
                                wb.println("</Borders>");
                                //wb.println("<Font x:Family=\"Swiss\" ss:Bold=\"1\"/>");
                                //wb.println("<Interior ss:Color=\"#FFFF00\" ss:Pattern=\"Solid\"/>");
                                //wb.println("<NumberFormat");
                                //wb.println("ss:Format=\"_ * #,##0.00_)\\ [$%-1]_ ;_ * \\(#,##0.00\\)\\ [$%-1]_ ;_ * &quot;-&quot;??_)\\ [$%-1]_ ;_ @_ \"/>");
                                wb.println("<NumberFormat ss:Format=\"#,##0\\ [$%-1]_);[Red]\\(#,##0\\ [$%-1]\\)\"/>");
                                wb.println("</Style>");
                                
                                wb.println("<Style ss:ID=\"s55b\" ss:Parent=\"s20\">");
                                wb.println("<Alignment ss:Horizontal=\"Right\" ss:Vertical=\"Center\" ss:Indent=\"1\"/>");
                                wb.println("<Borders>");
                                wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
                                wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
                                wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
                                wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
                                wb.println("</Borders>");
                                wb.println("<Font x:Family=\"Swiss\" ss:Bold=\"1\"/>");
                                //wb.println("<Interior ss:Color=\"#FFFF00\" ss:Pattern=\"Solid\"/>");
                                //wb.println("<NumberFormat");
                                //wb.println("ss:Format=\"_ * #,##0.00_)\\ [$%-1]_ ;_ * \\(#,##0.00\\)\\ [$%-1]_ ;_ * &quot;-&quot;??_)\\ [$%-1]_ ;_ @_ \"/>");
                                wb.println("<NumberFormat ss:Format=\"#,##0\\ [$%-1]_);[Red]\\(#,##0\\ [$%-1]\\)\"/>");
                                wb.println("</Style>");
                                        
        //======================================================================================================
        
                         // =============== for string ========================
                        wb.println("   <Style ss:ID=\"s44Kb\">");
                        wb.println("    <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Center\" ss:WrapText=\"1\"/>");
                        wb.println("    <Borders>");
                        wb.println("     <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
                        wb.println("     <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
                        wb.println("     <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
                        wb.println("     <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
                        wb.println("    </Borders>");
                        wb.println("    <Font x:Family=\"Swiss\" ss:Bold=\"1\"/>");
                        wb.println("    <Interior ss:Color=\"#FFFF00\" ss:Pattern=\"Solid\"/>");
                        wb.println("   </Style>");

                        wb.println("   <Style ss:ID=\"s44Mb\">");
                        wb.println("    <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Center\" ss:WrapText=\"1\"/>");
                        wb.println("    <Borders>");
                        wb.println("     <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
                        wb.println("     <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
                        wb.println("     <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
                        wb.println("     <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
                        wb.println("    </Borders>");
                        wb.println("    <Font x:Family=\"Swiss\" ss:Bold=\"1\"/>");
                        wb.println("    <Interior ss:Color=\"#FF99CC\" ss:Pattern=\"Solid\"/>");
                        wb.println("   </Style>");

                        wb.println("   <Style ss:ID=\"s44Hb\">");
                        wb.println("    <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Center\" ss:WrapText=\"1\"/>");
                        wb.println("    <Borders>");
                        wb.println("     <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
                        wb.println("     <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
                        wb.println("     <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
                        wb.println("     <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
                        wb.println("    </Borders>");
                        wb.println("    <Font x:Family=\"Swiss\" ss:Bold=\"1\"/>");
                        wb.println("    <Interior ss:Color=\"#00FFFF\" ss:Pattern=\"Solid\"/>");
                        wb.println("   </Style>");

                        wb.println("   <Style ss:ID=\"s44HTb\">");
                        wb.println("    <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Center\" ss:WrapText=\"1\"/>");
                        wb.println("    <Borders>");
                        wb.println("     <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
                        wb.println("     <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
                        wb.println("     <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
                        wb.println("     <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
                        wb.println("    </Borders>");
                        wb.println("    <Font x:Family=\"Swiss\" ss:Bold=\"1\"/>");
                        //wb.println("    <Interior ss:Color=\"#CCFFCC\" ss:Pattern=\"Solid\"/>");
                        wb.println("    <Interior ss:Pattern=\"Solid\"/>");
                        wb.println("   </Style>");

                        wb.println("   <Style ss:ID=\"s44Bb\">");
                        wb.println("    <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Center\" ss:WrapText=\"1\"/>");
                        wb.println("    <Borders>");
                        wb.println("     <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
                        wb.println("     <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
                        wb.println("     <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
                        wb.println("     <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
                        wb.println("    </Borders>");
                        wb.println("    <Font x:Family=\"Swiss\" ss:Bold=\"1\"/>");
                        wb.println("    <Interior ss:Color=\"#00CCFF\" ss:Pattern=\"Solid\"/>");
                        wb.println("   </Style>");

                        //===================== end string ==================
        
                //===================== for value ====================

                wb.println("<Style ss:ID=\"s45Kb\">");
                wb.println("<Alignment ss:Horizontal=\"Right\" ss:Vertical=\"Center\" ss:Indent=\"1\"/>");
                wb.println("<Borders>");
                wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
                wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
                wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
                wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
                wb.println("</Borders>");
                wb.println("<Font x:Family=\"Swiss\" ss:Bold=\"1\"/>");
                wb.println("<Interior ss:Color=\"#FFFF00\" ss:Pattern=\"Solid\"/>");
                wb.println("<NumberFormat ss:Format=\"#,##0.00_);\\(#,##0.00\\)\"/>");
                wb.println("</Style>");

                wb.println("<Style ss:ID=\"s45Mb\">");
                wb.println("<Alignment ss:Horizontal=\"Right\" ss:Vertical=\"Center\" ss:Indent=\"1\"/>");
                wb.println("<Borders>");
                wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
                wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
                wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
                wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
                wb.println("</Borders>");
                wb.println("<Font x:Family=\"Swiss\" ss:Bold=\"1\"/>");
                wb.println("<Interior ss:Color=\"#FF99CC\" ss:Pattern=\"Solid\"/>");
                wb.println("<NumberFormat ss:Format=\"#,##0.00_);\\(#,##0.00\\)\"/>");
                wb.println("</Style>");

                wb.println("<Style ss:ID=\"s45Hb\">");
                wb.println("<Alignment ss:Horizontal=\"Right\" ss:Vertical=\"Center\" ss:Indent=\"1\"/>");
                wb.println("<Borders>");
                wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
                wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
                wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
                wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
                wb.println("</Borders>");
                wb.println("<Font x:Family=\"Swiss\" ss:Bold=\"1\"/>");
                wb.println("<Interior ss:Color=\"#00FFFF\" ss:Pattern=\"Solid\"/>");
                wb.println("<NumberFormat ss:Format=\"#,##0.00_);\\(#,##0.00\\)\"/>");
                wb.println("</Style>");

                wb.println("<Style ss:ID=\"s45HTb\">");
                wb.println("<Alignment ss:Horizontal=\"Right\" ss:Vertical=\"Center\" ss:Indent=\"1\"/>");
                wb.println("<Borders>");
                wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
                wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
                wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
                wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
                wb.println("</Borders>");
                wb.println("<Font x:Family=\"Swiss\" ss:Bold=\"1\"/>");
                //wb.println("<Interior ss:Color=\"#CCFFCC\" ss:Pattern=\"Solid\"/>");
                wb.println("<Interior ss:Pattern=\"Solid\"/>");
                wb.println("<NumberFormat ss:Format=\"#,##0.00_);\\(#,##0.00\\)\"/>");
                wb.println("</Style>");

                wb.println("<Style ss:ID=\"s45Bb\">");
                wb.println("<Alignment ss:Horizontal=\"Right\" ss:Vertical=\"Center\" ss:Indent=\"1\"/>");
                wb.println("<Borders>");
                wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
                wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
                wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
                wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
                wb.println("</Borders>");
                wb.println("<Font x:Family=\"Swiss\" ss:Bold=\"1\"/>");
                wb.println("<Interior ss:Color=\"#00CCFF\" ss:Pattern=\"Solid\"/>");
                wb.println("<NumberFormat ss:Format=\"#,##0.00_);\\(#,##0.00\\)\"/>");
                wb.println("</Style>");
                
                //===============//=================//===================//==================

                        wb.println("<Style ss:ID=\"s55Kb\" ss:Parent=\"s20\">");
                        wb.println("<Alignment ss:Horizontal=\"Right\" ss:Vertical=\"Center\" ss:Indent=\"1\"/>");
                        wb.println("<Borders>");
                        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
                        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
                        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
                        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
                        wb.println("</Borders>");
                        wb.println("<Font x:Family=\"Swiss\" ss:Bold=\"1\"/>");
                        wb.println("<Interior ss:Color=\"#FFFF00\" ss:Pattern=\"Solid\"/>");
                        //wb.println("<NumberFormat");
                        //wb.println("ss:Format=\"_ * #,##0.00_)\\ [$%-1]_ ;_ * \\(#,##0.00\\)\\ [$%-1]_ ;_ * &quot;-&quot;??_)\\ [$%-1]_ ;_ @_ \"/>");
                        wb.println("<NumberFormat ss:Format=\"#,##0\\ [$%-1]_);[Red]\\(#,##0\\ [$%-1]\\)\"/>");
                        wb.println("</Style>");
                        
                        wb.println("<Style ss:ID=\"s55Mb\" ss:Parent=\"s20\">");
                        wb.println("<Alignment ss:Horizontal=\"Right\" ss:Vertical=\"Center\" ss:Indent=\"1\"/>");
                        wb.println("<Borders>");
                        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
                        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
                        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
                        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
                        wb.println("</Borders>");
                        wb.println("<Font x:Family=\"Swiss\" ss:Bold=\"1\"/>");
                        wb.println("<Interior ss:Color=\"#FF99CC\" ss:Pattern=\"Solid\"/>");
                        //wb.println("<NumberFormat");
                        //wb.println("ss:Format=\"_ * #,##0.00_)\\ [$%-1]_ ;_ * \\(#,##0.00\\)\\ [$%-1]_ ;_ * &quot;-&quot;??_)\\ [$%-1]_ ;_ @_ \"/>");
                        wb.println("<NumberFormat ss:Format=\"#,##0\\ [$%-1]_);[Red]\\(#,##0\\ [$%-1]\\)\"/>");
                        wb.println("</Style>");
                        
                        wb.println("<Style ss:ID=\"s55Hb\" ss:Parent=\"s20\">");
                        wb.println("<Alignment ss:Horizontal=\"Right\" ss:Vertical=\"Center\" ss:Indent=\"1\"/>");
                        wb.println("<Borders>");
                        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
                        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
                        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
                        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
                        wb.println("</Borders>");
                        wb.println("<Font x:Family=\"Swiss\" ss:Bold=\"1\"/>");
                        wb.println("<Interior ss:Color=\"#00FFFF\" ss:Pattern=\"Solid\"/>");
                        //wb.println("<NumberFormat");
                        //wb.println("ss:Format=\"_ * #,##0.00_)\\ [$%-1]_ ;_ * \\(#,##0.00\\)\\ [$%-1]_ ;_ * &quot;-&quot;??_)\\ [$%-1]_ ;_ @_ \"/>");
                        wb.println("<NumberFormat ss:Format=\"#,##0\\ [$%-1]_);[Red]\\(#,##0\\ [$%-1]\\)\"/>");
                        wb.println("</Style>");
                        
                        wb.println("<Style ss:ID=\"s55HTb\" ss:Parent=\"s20\">");
                        wb.println("<Alignment ss:Horizontal=\"Right\" ss:Vertical=\"Center\" ss:Indent=\"1\"/>");
                        wb.println("<Borders>");
                        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
                        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
                        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
                        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
                        wb.println("</Borders>");
                        wb.println("<Font x:Family=\"Swiss\" ss:Bold=\"1\"/>");
                        //wb.println("<Interior ss:Color=\"#FFFF99\" ss:Pattern=\"Solid\"/>");
                        //wb.println("<NumberFormat");
                        //wb.println("ss:Format=\"_ * #,##0.00_)\\ [$%-1]_ ;_ * \\(#,##0.00\\)\\ [$%-1]_ ;_ * &quot;-&quot;??_)\\ [$%-1]_ ;_ @_ \"/>");
                        wb.println("<NumberFormat ss:Format=\"#,##0\\ [$%-1]_);[Red]\\(#,##0\\ [$%-1]\\)\"/>");
                        wb.println("</Style>");
                        
                        wb.println("<Style ss:ID=\"s55Bb\" ss:Parent=\"s20\">");
                        wb.println("<Alignment ss:Horizontal=\"Right\" ss:Vertical=\"Center\" ss:Indent=\"1\"/>");
                        wb.println("<Borders>");
                        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
                        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
                        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
                        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
                        wb.println("</Borders>");
                        wb.println("<Font x:Family=\"Swiss\" ss:Bold=\"1\"/>");
                        wb.println("<Interior ss:Color=\"#00CCFF\" ss:Pattern=\"Solid\"/>");
                        //wb.println("<NumberFormat");
                        //wb.println("ss:Format=\"_ * #,##0.00_)\\ [$%-1]_ ;_ * \\(#,##0.00\\)\\ [$%-1]_ ;_ * &quot;-&quot;??_)\\ [$%-1]_ ;_ @_ \"/>");
                        wb.println("<NumberFormat ss:Format=\"#,##0\\ [$%-1]_);[Red]\\(#,##0\\ [$%-1]\\)\"/>");
                        wb.println("</Style>");
                        
                        

                //===================== end value ====================
        
        //========================= end style ================
        
        wb.println("  </Styles>");
        //wb.flush() ;       
        
        wb.println("  <Worksheet ss:Name=\"ProfitLoss\">");
        //wb.println("    <Table>");
        wb.println("<Table ss:ExpandedColumnCount=\"256\"  x:FullColumns=\"1\"");
        wb.println("x:FullRows=\"1\">");
        
        wb.println("    <Column ss:AutoFitWidth=\"0\" ss:Width=\"14.25\"/>");
        wb.println("    <Column ss:AutoFitWidth=\"0\" ss:Width=\"69\"/>");
        wb.println("    <Column ss:AutoFitWidth=\"0\" ss:Width=\"314.25\"/>");
        wb.println("    <Column ss:AutoFitWidth=\"0\" ss:Width=\"93.75\" ss:Span=\""+(colSpan+5)+"\"/>");
        
        wb.println("    <Column ss:Index=\""+(colSpan+10)+"\" ss:AutoFitWidth=\"0\" ss:Width=\"65.25\" ss:Span=\""+(colSpan+1)+"\"/>");
        wb.println("    <Column ss:Index=\""+(colSpan+12)+"\" ss:AutoFitWidth=\"0\" ss:Width=\"14.25\"/>");
        wb.println("    <Column ss:Hidden=\"1\" ss:AutoFitWidth=\"0\" ss:Span=\""+(256-colSpan-13)+"\"/>");
        
        //Top Header
        company = new Company();
        try{
            company = DbCompany.fetchExc(oidCompany);
        }
        catch(Exception e){
        }  
        
        wb.println("     <Row>"); 
        wb.println("      <Cell ss:Index=\""+(colSpan+11)+"\" ss:StyleID=\"s28\"><Data ss:Type=\"String\">Printed : "+JSPFormater.formatDate(new Date(),formatDate)+"</Data></Cell>");
        wb.println("     </Row>");
        
        wb.println("     <Row ss:Height=\"23.25\">");
        wb.println("      <Cell ss:Index=\"2\" ss:MergeAcross=\""+(colSpan+9)+"\" ss:StyleID=\"s40\"><Data ss:Type=\"String\" x:Ticked=\"1\">"+company.getName().toUpperCase()+"</Data></Cell>");
        wb.println("     </Row>");
        
        wb.println("     <Row ss:Height=\"20.25\">");
        wb.println("      <Cell ss:Index=\"2\" ss:MergeAcross=\""+(colSpan+9)+"\" ss:StyleID=\"s42\"><Data ss:Type=\"String\">"+strTitle+"</Data></Cell>");
        wb.println("     </Row>");
        
        wb.println("     <Row ss:Height=\"18\">");
        Periode periode = DbPeriode.getOpenPeriod();
        String openPeriod = JSPFormater.formatDate(periode.getStartDate(), "MMMM yyyy");
        wb.println("      <Cell ss:Index=\"2\" ss:MergeAcross=\""+(colSpan+9)+"\" ss:StyleID=\"s43\"><Data ss:Type=\"String\">PERIOD "+ openPeriod.toUpperCase()+"</Data></Cell>");
        wb.println("     </Row>");
                
        //Content Header
        /*
        wb.println("     <Row ss:Height=\"15\"/>");
        wb.println("     <Row ss:Height=\"15\">"); 
        wb.println("      <Cell ss:Index=\"2\" ss:MergeDown=\"0\" ss:StyleID=\"s41\"><Data ss:Type=\"String\"></Data></Cell>");
        wb.println("      <Cell ss:MergeDown=\"0\" ss:StyleID=\"s41\"><Data ss:Type=\"String\">Target</Data></Cell>");
        wb.println("      <Cell ss:MergeAcross=\""+(colSpan+1)+"\" ss:StyleID=\"s41\"><Data ss:Type=\"String\">REALISASI</Data></Cell>");
        wb.println("     </Row>");
        
        wb.println("<Row ss:Height=\"15\"/>");
        wb.println("<Row ss:Height=\"15\">");
        wb.println("<Cell ss:Index=\"2\" ss:MergeDown=\"1\" ss:StyleID=\"m17580806\"><Data ss:Type=\"String\">KD_PER</Data></Cell>");
        wb.println("<Cell ss:MergeDown=\"1\" ss:StyleID=\"m17580816\"><Data ss:Type=\"String\">NAMA PERKIRAAN</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s41\"><Data ss:Type=\"String\">TARGET</Data></Cell>");
        wb.println("<Cell ss:MergeAcross=\"1\" ss:StyleID=\"m17580826\"><Data ss:Type=\"String\">REALISASI</Data></Cell>");
        wb.println("</Row>");
         */
    
    wb.println("<Row ss:Height=\"15\"/>");
    wb.println("<Row ss:Height=\"15\">");
    wb.println("<Cell ss:Index=\"2\" ss:MergeDown=\"1\" ss:StyleID=\"m17253318\"><Data ss:Type=\"String\">KD_PER</Data></Cell>");
    wb.println("<Cell ss:MergeDown=\"1\" ss:StyleID=\"m17253328\"><Data ss:Type=\"String\">NAMA PERKIRAAN</Data></Cell>");
    wb.println("<Cell ss:MergeAcross=\"2\" ss:StyleID=\"m17253338\"><Data ss:Type=\"String\">TARGET</Data></Cell>");
    wb.println("<Cell ss:MergeAcross=\"2\" ss:StyleID=\"m17253348\"><Data ss:Type=\"String\">REALISASI</Data></Cell>");
    wb.println("<Cell ss:MergeAcross=\"1\" ss:StyleID=\"m17253358\"><Data ss:Type=\"String\">% PENCAPAIAN</Data></Cell>");
    wb.println("</Row>");

        /*
        wb.println("     <Row>"); 
        //wb.println("      <Cell ss:Index=\"2\" ss:MergeDown=\"0\" ss:StyleID=\"s41\"><Data ss:Type=\"String\">Description</Data></Cell>");
        wb.println("      <Cell ss:Index=\"4\" ss:StyleID=\"s41\"><Data ss:Type=\"String\">BLN INI</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s41\"><Data ss:Type=\"String\">BLN INI</Data></Cell>");
        wb.println("      <Cell ss:StyleID=\"s41\"><Data ss:Type=\"String\">SD BLN INI</Data></Cell>");
        wb.println("     </Row>");
         */
        
        wb.println("<Row>");
        wb.println("<Cell ss:Index=\"4\" ss:StyleID=\"s41\"><Data ss:Type=\"String\">TAHUN 2009 </Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s41\"><Data ss:Type=\"String\">S/D BLN INI   </Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s41\"><Data ss:Type=\"String\">BLN INI </Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s41\"><Data ss:Type=\"String\">S/D BLN LALU   </Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s41\"><Data ss:Type=\"String\">BLN INI </Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s41\"><Data ss:Type=\"String\">SD BLN INI</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s41\"><Data ss:Type=\"String\">S/D BLN INI</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s41\"><Data ss:Type=\"String\">BLN INI </Data></Cell>");
        wb.println("</Row>");

        //content
        int prevLevel = 0;
        for(int i=0; i<vectorList.size(); i++){
            SesReportBs srb = (SesReportBs)vectorList.get(i);
            
            String xCodNama = "s44";
            String xNum = "s45";
            String xNum2 = "s55";
            
            // total
            if (srb.getLevel()==99){
                xCodNama = "s44Bb";   
                xNum = "s45Bb";
                xNum2 = "s55Bb";
            }
            // header 
            else if(srb.getLevel()==9){
                xCodNama = "s44b";
                xNum = "s45b";
                xNum2 = "s55b";
            }
            // level 1 kuning
            else if(srb.getLevel()==1 && srb.getType().equals("HEADER")){
                xCodNama = "s44Kb";
                xNum = "s45Kb";
                xNum2 = "s55Kb";
            }
            // level 2 merah muda
            else if(srb.getLevel()==2 && srb.getType().equals("HEADER")){
                xCodNama = "s44Mb";
                xNum = "s45Mb";
                xNum2 = "s55Mb";
            }
            // level 3 hijau
            else if(srb.getLevel()==3 && srb.getType().equals("HEADER")){
                xCodNama = "s44Hb";
                xNum = "s45Hb";
                xNum2 = "s55Hb";
            }
            // level 4 hijau tua
            else if(srb.getLevel()==4 && srb.getType().equals("HEADER")){
                xCodNama = "s44HTb";
                xNum = "s45HTb";
                xNum2 = "s55HTb";
            }
            
            //space
            if((prevLevel!=9 && prevLevel>=4) && (srb.getLevel()==1 || (srb.getLevel()==2 && srb.getType().equals("HEADER")) || (srb.getLevel()==3 && srb.getType().equals("HEADER")))){
                
                /*
                wb.println("<Row>");        
                wb.println("<Cell ss:Index=\"2\" ss:StyleID=\"s44\"><Data ss:Type=\"String\" x:Ticked=\"1\"></Data></Cell>");
                wb.println("<Cell ss:StyleID=\"s44\"><Data ss:Type=\"String\"></Data></Cell>");
                wb.println("<Cell ss:StyleID=\"s44\"><Data ss:Type=\"String\"></Data></Cell>");
                wb.println("<Cell ss:StyleID=\"s44\"><Data ss:Type=\"String\"></Data></Cell>");
                wb.println("<Cell ss:StyleID=\"s44\" ><Data ss:Type=\"String\"></Data></Cell>");   
                wb.println("</Row>"); 
                */ 
                
                wb.println("<Row>");
                wb.println("<Cell ss:Index=\"2\" ss:StyleID=\"s44\"><Data ss:Type=\"String\" x:Ticked=\"1\"></Data></Cell>");
                wb.println("<Cell ss:StyleID=\"s44\"><Data ss:Type=\"String\"></Data></Cell>");
                wb.println("<Cell ss:StyleID=\"s44\"><Data ss:Type=\"String\"></Data></Cell>");
                wb.println("<Cell ss:StyleID=\"s44\"><Data ss:Type=\"String\"></Data></Cell>");
                wb.println("<Cell ss:StyleID=\"s44\"><Data ss:Type=\"String\"></Data></Cell>");
                wb.println("<Cell ss:StyleID=\"s44\"><Data ss:Type=\"String\"></Data></Cell>");
                wb.println("<Cell ss:StyleID=\"s44\"><Data ss:Type=\"String\"></Data></Cell>");
                wb.println("<Cell ss:StyleID=\"s44\"><Data ss:Type=\"String\"></Data></Cell>");
                wb.println("<Cell ss:StyleID=\"s44\"><Data ss:Type=\"String\"></Data></Cell>");
                wb.println("<Cell ss:StyleID=\"s44\"><Data ss:Type=\"String\"></Data></Cell>");
                wb.println("</Row>");
                
            }
            
            prevLevel = srb.getLevel();
            if(!srb.getType().equals("HEADER")){
                prevLevel = 5;
            }
            if(srb.getLevel()==9){
                prevLevel = 9;
            }
            
            /*
            wb.println("<Row>");
            wb.println("<Cell ss:Index=\"2\" ss:StyleID=\""+xCodNama+"\"><Data ss:Type=\"String\" x:Ticked=\"1\">"+srb.getCode()+"</Data></Cell>");
            wb.println("<Cell ss:StyleID=\""+xCodNama+"\"><Data ss:Type=\"String\">"+srb.getDescription()+"</Data></Cell>");
            */
            
            wb.println("<Row>");
            wb.println("<Cell ss:Index=\"2\" ss:StyleID=\""+xCodNama+"\"><Data ss:Type=\"String\" x:Ticked=\"1\">"+srb.getCode()+"</Data></Cell>");
            wb.println("<Cell ss:StyleID=\""+xCodNama+"\"><Data ss:Type=\"String\">"+srb.getDescription()+"</Data></Cell>");
            
            
                   
                String strAmount = srb.getStrAmount();
                String strAmountMth = srb.getStrAmountMth();
                String strAmountBudget = srb.getStrAmountBudget();
                
                String strBudgetYr = srb.getStrBudgetYr();
                String strBudgetSd = srb.getStrBudgetSd();
                String strBudgetLmth = srb.getStrBudgetLmth();
                
                String strPenSd = srb.getPencapaianSd();
                String strPenIni = srb.getPencapaianIni();

                double dblAmount = 0;
                double dblAmountMth = 0;
                double dblAmountBudget = 0;
                
                double dbBudgetYr = 0;
                double dbBudgetSd = 0;
                double dbBudgetLmth = 0;
                
                double dbPenSd = 0;
                double dbPenIni = 0;

                try{
                    dblAmount = Double.parseDouble(strAmount);
                    dblAmountMth = Double.parseDouble(strAmountMth);
                    dblAmountBudget = Double.parseDouble(strAmountBudget);
                    
                    dbBudgetYr = Double.parseDouble(strBudgetYr);
                    dbBudgetSd = Double.parseDouble(strBudgetSd);
                    dbBudgetLmth = Double.parseDouble(strBudgetLmth);
                    
                    dbPenSd = Double.parseDouble(strPenSd);
                    dbPenIni = Double.parseDouble(strPenIni);
                    
                }catch(Exception e){
                    System.out.println(e);
                }
                 
            
            /*
            wb.println("<Cell ss:StyleID=\""+xNum+"\"><Data ss:Type=\"Number\">"+dblAmountBudget+"</Data></Cell>");
            wb.println("<Cell ss:StyleID=\""+xNum+"\"><Data ss:Type=\"Number\">"+dblAmountMth+"</Data></Cell>");
            wb.println("<Cell ss:StyleID=\""+xNum+"\"><Data ss:Type=\"Number\">"+dblAmount+"</Data></Cell>");
            wb.println("</Row>");
             */
            
            wb.println("<Cell ss:StyleID=\""+xNum+"\"><Data ss:Type=\"Number\">"+dbBudgetYr+"</Data></Cell>");
            wb.println("<Cell ss:StyleID=\""+xNum+"\"><Data ss:Type=\"Number\">"+dbBudgetSd+"</Data></Cell>");
            wb.println("<Cell ss:StyleID=\""+xNum+"\"><Data ss:Type=\"Number\">"+dblAmountBudget+"</Data></Cell>");
            wb.println("<Cell ss:StyleID=\""+xNum+"\"><Data ss:Type=\"Number\">"+dbBudgetLmth+"</Data></Cell>");
            wb.println("<Cell ss:StyleID=\""+xNum+"\"><Data ss:Type=\"Number\">"+dblAmountMth+"</Data></Cell>");
            wb.println("<Cell ss:StyleID=\""+xNum+"\"><Data ss:Type=\"Number\">"+dblAmount+"</Data></Cell>");
            
            /*
            wb.println("<Cell ss:StyleID=\""+xNum2+"\" ss:Formula=\"=(RC[-1]/RC[-5])*100\"><Data ss:Type=\"Number\">288.74172185430467</Data></Cell>");
            wb.println("<Cell ss:StyleID=\""+xNum2+"\" ss:Formula=\"=(RC[-3]/RC[-5])*100\"><Data ss:Type=\"Number\">2.5197478988942943</Data></Cell>");
            */
            wb.println("<Cell ss:StyleID=\""+xNum2+"\"><Data ss:Type=\"Number\">"+dbPenSd+"</Data></Cell>");
            wb.println("<Cell ss:StyleID=\""+xNum2+"\"><Data ss:Type=\"Number\">"+dbPenIni+"</Data></Cell>");
            
            wb.println("</Row>");
            
        }
        
        //footer
        wb.println("     <Row>");
        wb.println("      <Cell ss:Index=\"2\" ss:MergeAcross=\""+(colSpan+9)+"\" ss:StyleID=\"s47\"><Data ss:Type=\"String\"></Data></Cell>");
        wb.println("     </Row>");
        wb.println("     <Row>");
        wb.println("      <Cell ss:Index=\"2\" ss:MergeAcross=\""+(colSpan+9)+"\" ss:StyleID=\"s49\"><Data ss:Type=\"String\"></Data></Cell>");
        wb.println("     </Row>");
        wb.println("     <Row>");
        wb.println("      <Cell ss:Index=\"2\" ss:MergeAcross=\""+(colSpan+9)+"\" ss:StyleID=\"s49\"><Data ss:Type=\"String\">Date : _________________                Date : _________________                Date : _________________</Data></Cell>");
        wb.println("     </Row>");
        wb.println("     <Row>");
        wb.println("      <Cell ss:Index=\"2\" ss:MergeAcross=\""+(colSpan+9)+"\" ss:StyleID=\"s49\"><Data ss:Type=\"String\">Approve by                                            Review by                                            Prepare by</Data></Cell>");
        wb.println("     </Row>");
        wb.println("     <Row>");
        wb.println("      <Cell ss:Index=\"2\" ss:MergeAcross=\""+(colSpan+9)+"\" ss:StyleID=\"s49\"><Data ss:Type=\"String\"></Data></Cell>");
        wb.println("     </Row>");
        wb.println("     <Row>");
        wb.println("      <Cell ss:Index=\"2\" ss:MergeAcross=\""+(colSpan+9)+"\" ss:StyleID=\"s49\"><Data ss:Type=\"String\"></Data></Cell>");
        wb.println("     </Row>");
        wb.println("     <Row>");
        wb.println("      <Cell ss:Index=\"2\" ss:MergeAcross=\""+(colSpan+9)+"\" ss:StyleID=\"s49\"><Data ss:Type=\"String\"></Data></Cell>");
        wb.println("     </Row>");
        wb.println("     <Row>");
        wb.println("      <Cell ss:Index=\"2\" ss:MergeAcross=\""+(colSpan+9)+"\" ss:StyleID=\"s49\"><Data ss:Type=\"String\"></Data></Cell>");
        wb.println("     </Row>");
        wb.println("     <Row>");
        wb.println("      <Cell ss:Index=\"2\" ss:MergeAcross=\""+(colSpan+9)+"\" ss:StyleID=\"s49\"><Data ss:Type=\"String\">______________________                ______________________                ______________________</Data></Cell>");
        wb.println("     </Row>");       
        
        
        wb.println("    </Table>");
        
        wb.println("<WorksheetOptions xmlns=\"urn:schemas-microsoft-com:office:excel\">");
        wb.println("<Print>");
        wb.println("<ValidPrinterInfo/>");
        wb.println("<PaperSizeIndex>9</PaperSizeIndex>");
        wb.println("<HorizontalResolution>-4</HorizontalResolution>");
        wb.println("<VerticalResolution>600</VerticalResolution>");
        wb.println("</Print>");
        wb.println("<Selected/>");
        wb.println("<DoNotDisplayGridlines/>");
        wb.println("<DoNotDisplayZeros/>");
        wb.println("<FreezePanes/>");
        wb.println("<FrozenNoSplit/>");
        wb.println("<SplitHorizontal>7</SplitHorizontal>");
        wb.println("<TopRowBottomPane>7</TopRowBottomPane>");
        wb.println("<ActivePane>2</ActivePane>");
        wb.println("<Panes>");
        wb.println("<Pane>");
        wb.println("<Number>3</Number>");
        wb.println("<ActiveCol>13</ActiveCol>");
        wb.println("</Pane>");

        wb.println("<Pane>");
        wb.println("<Number>2</Number>");
        wb.println("<ActiveRow>16</ActiveRow>");
        wb.println("<ActiveCol>1</ActiveCol>");
        wb.println("</Pane>");

        wb.println("</Panes>");
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
