/*
 * RptAccReceivableAgingXLS.java
 *
 * Created on October 30, 2008, 8:26 AM
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

/**
 *
 * @author  Suarjaya
 */
public class RptAccReceivableAgingXLS extends HttpServlet {
    
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
        
        // Company Id
        long compId = JSPRequestValue.requestLong(request, "oid");
        System.out.println("CompanyId : "+compId);
        Company company = new Company();
        try{
            company = DbCompany.fetchExc(compId);
        }catch (Exception e){
            System.out.println(e);
        }

        //Aged by
        int agedBy = JSPRequestValue.requestInt(request, "age");
        
        // Load Vector Data Aging
        Vector vectorList = new Vector(1,1);
        long oidUnitUsaha = 0;
        UnitUsaha unitUsaha = new UnitUsaha();
        try{
            HttpSession session = request.getSession();
            vectorList = (Vector)session.getValue("AGE_ANALYSIS");
            String str = (String)session.getValue("AGE_ANALYSIS_UNIT_USAHA");
            if(str!=null && str.length()>0){
                oidUnitUsaha = Long.parseLong(str);
                unitUsaha = DbUnitUsaha.fetchExc(oidUnitUsaha);
            }
        } catch (Exception e) { 
            System.out.println(e); 
        }

                      
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
        wb.println("   <?xml version=\"1.0\"?>");
        wb.println("   <?mso-application progid=\"Excel.Sheet\"?>");
        wb.println("   <Workbook xmlns=\"urn:schemas-microsoft-com:office:spreadsheet\"");
        wb.println("    xmlns:o=\"urn:schemas-microsoft-com:office:office\"");
        wb.println("    xmlns:x=\"urn:schemas-microsoft-com:office:excel\"");
        wb.println("    xmlns:ss=\"urn:schemas-microsoft-com:office:spreadsheet\"");
        wb.println("    xmlns:html=\"http://www.w3.org/TR/REC-html40\">");
        wb.println("    <DocumentProperties xmlns=\"urn:schemas-microsoft-com:office:office\">");
        wb.println("     <Author>Suarjaya_Laptop</Author>");
        wb.println("     <LastAuthor>Suarjaya_Laptop</LastAuthor>");
        wb.println("     <LastPrinted>2008-10-30T00:22:20Z</LastPrinted>");
        wb.println("     <Created>2008-10-13T06:41:38Z</Created>");
        wb.println("     <LastSaved>2008-10-28T01:16:14Z</LastSaved>");
        wb.println("     <Company>SUARJAYA</Company>");
        wb.println("     <Version>11.9999</Version>");
        wb.println("    </DocumentProperties>");
        wb.println("    <ExcelWorkbook xmlns=\"urn:schemas-microsoft-com:office:excel\">");
        wb.println("     <WindowHeight>9840</WindowHeight>");
        wb.println("     <WindowWidth>19200</WindowWidth>");
        wb.println("     <WindowTopX>0</WindowTopX>");
        wb.println("     <WindowTopY>255</WindowTopY>");
        wb.println("     <ProtectStructure>False</ProtectStructure>");
        wb.println("     <ProtectWindows>False</ProtectWindows>");
        wb.println("    </ExcelWorkbook>");
        wb.println("    <Styles>");
        wb.println("     <Style ss:ID=\"Default\" ss:Name=\"Normal\">");
        wb.println("      <Alignment ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders/>");
        wb.println("      <Font/>");
        wb.println("      <Interior/>");
        wb.println("      <NumberFormat/>");
        wb.println("      <Protection/>");
        wb.println("     </Style>");
        wb.println("     <Style ss:ID=\"m15965436\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\"/>");
        wb.println("      <Borders>");
        wb.println("       <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("       <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("       <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("       <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:Bold=\"1\"/>");
        wb.println("      <Interior ss:Color=\"#C0C0C0\" ss:Pattern=\"Solid\"/>");
        wb.println("     </Style>");
        wb.println("     <Style ss:ID=\"m15965446\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\"/>");
        wb.println("      <Borders>");
        wb.println("       <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("       <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("       <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("       <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:Bold=\"1\"/>");
        wb.println("      <Interior ss:Color=\"#C0C0C0\" ss:Pattern=\"Solid\"/>");
        wb.println("     </Style>");
        wb.println("     <Style ss:ID=\"m15965284\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\"/>");
        wb.println("      <Borders>");
        wb.println("       <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("       <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("       <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("       <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:Bold=\"1\"/>");
        wb.println("      <Interior ss:Color=\"#C0C0C0\" ss:Pattern=\"Solid\"/>");
        wb.println("     </Style>");
        wb.println("     <Style ss:ID=\"m15965294\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\"/>");
        wb.println("      <Borders>");
        wb.println("       <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("       <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("       <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("       <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:Bold=\"1\"/>");
        wb.println("      <Interior ss:Color=\"#C0C0C0\" ss:Pattern=\"Solid\"/>");
        wb.println("     </Style>");
        wb.println("     <Style ss:ID=\"m15965304\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\"/>");
        wb.println("      <Borders>");
        wb.println("       <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("       <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("       <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("       <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:Bold=\"1\"/>");
        wb.println("      <Interior ss:Color=\"#C0C0C0\" ss:Pattern=\"Solid\"/>");
        wb.println("     </Style>");
        wb.println("     <Style ss:ID=\"m15965314\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\"/>");
        wb.println("      <Borders>");
        wb.println("       <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("       <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("       <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("       <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:Bold=\"1\"/>");
        wb.println("      <Interior ss:Color=\"#C0C0C0\" ss:Pattern=\"Solid\"/>");
        wb.println("     </Style>");
        wb.println("     <Style ss:ID=\"m15979044\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\"/>");
        wb.println("      <Borders>");
        wb.println("       <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("       <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("       <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("       <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:Bold=\"1\"/>");
        wb.println("      <Interior ss:Color=\"#C0C0C0\" ss:Pattern=\"Solid\"/>");
        wb.println("     </Style>");
        wb.println("     <Style ss:ID=\"m15979054\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\"/>");
        wb.println("      <Borders>");
        wb.println("       <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("       <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("       <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("       <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:Bold=\"1\"/>");
        wb.println("      <Interior ss:Color=\"#C0C0C0\" ss:Pattern=\"Solid\"/>");
        wb.println("     </Style>");
        wb.println("     <Style ss:ID=\"m15979064\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\"/>");
        wb.println("      <Borders>");
        wb.println("       <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("       <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("       <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("       <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:Bold=\"1\"/>");
        wb.println("      <Interior ss:Color=\"#C0C0C0\" ss:Pattern=\"Solid\"/>");
        wb.println("     </Style>");
        wb.println("     <Style ss:ID=\"m15979074\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\"/>");
        wb.println("      <Borders>");
        wb.println("       <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("       <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("       <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("       <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:Bold=\"1\"/>");
        wb.println("      <Interior ss:Color=\"#C0C0C0\" ss:Pattern=\"Solid\"/>");
        wb.println("     </Style>");
        wb.println("     <Style ss:ID=\"s21\">");
        wb.println("      <Font/>");
        wb.println("     </Style>");
        wb.println("     <Style ss:ID=\"s22\">");
        wb.println("      <Font x:Family=\"Swiss\" ss:Size=\"16\" ss:Bold=\"1\"/>");
        wb.println("     </Style>");
        wb.println("     <Style ss:ID=\"s23\">");
        wb.println("      <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Font/>");
        wb.println("     </Style>");
        wb.println("     <Style ss:ID=\"s25\">");
        wb.println("      <Borders>");
        wb.println("       <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"3\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font/>");
        wb.println("     </Style>");
        wb.println("     <Style ss:ID=\"s26\">");
        wb.println("      <Borders/>");
        wb.println("      <Font/>");
        wb.println("      <Interior/>");
        wb.println("     </Style>");
        wb.println("     <Style ss:ID=\"s28\">");
        wb.println("      <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Font x:Family=\"Swiss\" ss:Bold=\"1\"/>");
        wb.println("     </Style>");
        wb.println("     <Style ss:ID=\"s29\">");
        wb.println("      <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Bottom\" ss:Indent=\"2\"/>");
        wb.println("      <Font x:Family=\"Swiss\" ss:Bold=\"1\"/>");
        wb.println("     </Style>");
        wb.println("     <Style ss:ID=\"s30\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\"/>");
        wb.println("      <Font ss:Bold=\"1\"/>");
        wb.println("     </Style>");
        wb.println("     <Style ss:ID=\"s31\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\"/>");
        wb.println("      <Borders>");
        wb.println("       <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("       <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("       <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("       <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font ss:Bold=\"1\"/>");
        wb.println("      <Interior ss:Color=\"#C0C0C0\" ss:Pattern=\"Solid\"/>");
        wb.println("     </Style>");
        wb.println("     <Style ss:ID=\"s47\">");
        wb.println("      <Alignment ss:Vertical=\"Top\"/>");
        wb.println("      <Font/>");
        wb.println("     </Style>");
        wb.println("     <Style ss:ID=\"s48\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Top\"/>");
        wb.println("      <Borders>");
        wb.println("       <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("       <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("       <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("       <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font/>");
        wb.println("     </Style>");
        wb.println("     <Style ss:ID=\"s49\">");
        wb.println("      <Alignment ss:Vertical=\"Top\" ss:WrapText=\"1\"/>");
        wb.println("      <Borders>");
        wb.println("       <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("       <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("       <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("       <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font/>");
        wb.println("     </Style>");
        wb.println("     <Style ss:ID=\"s50\">");
        wb.println("      <Alignment ss:Vertical=\"Top\"/>");
        wb.println("      <Borders>");
        wb.println("       <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("       <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("       <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("       <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font/>");
        wb.println("      <NumberFormat ss:Format=\"Standard\"/>");
        wb.println("     </Style>");
        wb.println("     <Style ss:ID=\"s51\">");
        wb.println("      <Alignment ss:Horizontal=\"Right\" ss:Vertical=\"Top\"/>");
        wb.println("      <Borders>");
        wb.println("       <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("       <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("       <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("       <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font/>");
        wb.println("      <NumberFormat ss:Format=\"@\"/>");
        wb.println("     </Style>");
        wb.println("     <Style ss:ID=\"s52\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("       <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("       <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("       <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("       <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font/>");
        wb.println("     </Style>");
        wb.println("     <Style ss:ID=\"s53\">");
        wb.println("      <Alignment ss:Vertical=\"Bottom\"/>");
        wb.println("      <Borders>");
        wb.println("       <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("       <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("       <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("       <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font/>");
        wb.println("     </Style>");
        wb.println("     <Style ss:ID=\"s54\">");
        wb.println("      <Borders>");
        wb.println("       <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("       <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("       <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("       <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font/>");
        wb.println("     </Style>");
        wb.println("     <Style ss:ID=\"s55\">");
        wb.println("      <Alignment ss:Horizontal=\"Right\" ss:Vertical=\"Bottom\" ss:Indent=\"1\"/>");
        wb.println("      <Borders>");
        wb.println("       <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("       <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("       <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("       <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font/>");
        wb.println("      <NumberFormat ss:Format=\"Standard\"/>");
        wb.println("     </Style>");
        wb.println("     <Style ss:ID=\"s60\">");
        wb.println("      <Alignment ss:Vertical=\"Bottom\"/>");
        wb.println("      <Font x:Family=\"Swiss\"/>");
        wb.println("     </Style>");
        wb.println("     <Style ss:ID=\"s62\">");
        wb.println("      <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Bottom\" ss:Indent=\"9\"/>");
        wb.println("      <Font/>");
        wb.println("     </Style>");
        wb.println("     <Style ss:ID=\"s63\">");
        wb.println("      <Alignment ss:Vertical=\"Bottom\"/>");
        wb.println("      <Font/>");
        wb.println("     </Style>");
        wb.println("     <Style ss:ID=\"s66\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Font/>");
        wb.println("     </Style>");
        wb.println("     <Style ss:ID=\"s67\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Font/>");
        wb.println("     </Style>");
        wb.println("     <Style ss:ID=\"s69\">");
        wb.println("      <Alignment ss:Horizontal=\"Right\" ss:Vertical=\"Bottom\" ss:Indent=\"9\"/>");
        wb.println("      <Font/>");
        wb.println("     </Style>");
        wb.println("     <Style ss:ID=\"s70\">");
        wb.println("      <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Bottom\" ss:Indent=\"11\"/>");
        wb.println("      <Font/>");
        wb.println("     </Style>");
        wb.println("     <Style ss:ID=\"s72\">");
        wb.println("      <Alignment ss:Horizontal=\"Right\" ss:Vertical=\"Bottom\"/>");
        wb.println("      <Font/>");
        wb.println("     </Style>");
        wb.println("     <Style ss:ID=\"s74\">");
        wb.println("      <Alignment ss:Horizontal=\"Right\" ss:Vertical=\"Bottom\" ss:Indent=\"7\"/>");
        wb.println("      <Font/>");
        wb.println("     </Style>");
        wb.println("     <Style ss:ID=\"s77\">");
        wb.println("      <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\"/>");
        wb.println("      <Borders>");
        wb.println("       <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("       <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("       <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font x:Family=\"Swiss\" ss:Bold=\"1\"/>");
        wb.println("     </Style>");
        wb.println("     <Style ss:ID=\"s79\">");
        wb.println("      <Alignment ss:Vertical=\"Center\"/>");
        wb.println("      <Borders>");
        wb.println("       <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("       <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("       <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("       <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font x:Family=\"Swiss\" ss:Bold=\"1\"/>");
        wb.println("     </Style>");
        wb.println("     <Style ss:ID=\"s81\">");
        wb.println("      <Alignment ss:Vertical=\"Center\"/>");
        wb.println("      <Borders>");
        wb.println("       <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("       <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("       <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("       <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("      </Borders>");
        wb.println("      <Font x:Family=\"Swiss\" ss:Bold=\"1\"/>");
        wb.println("      <NumberFormat ss:Format=\"Standard\"/>");
        wb.println("     </Style>");
        wb.println("     <Style ss:ID=\"s83\">");
        wb.println("      <Alignment ss:Vertical=\"Center\"/>");
        wb.println("      <Font/>");
        wb.println("     </Style>");
        wb.println("    </Styles>");
        wb.println("    <Worksheet ss:Name=\"aging\">");
        wb.println("     <Table>");
        wb.println("      <Column ss:StyleID=\"s21\" ss:AutoFitWidth=\"0\" ss:Width=\"9\"/>");
        wb.println("      <Column ss:StyleID=\"s21\" ss:AutoFitWidth=\"0\" ss:Width=\"24.75\"/>");
        wb.println("      <Column ss:StyleID=\"s21\" ss:AutoFitWidth=\"0\" ss:Width=\"45.75\"/>");
        wb.println("      <Column ss:StyleID=\"s21\" ss:AutoFitWidth=\"0\" ss:Width=\"213.75\"/>");
        wb.println("      <Column ss:StyleID=\"s21\" ss:AutoFitWidth=\"0\" ss:Width=\"82.5\" ss:Span=\"6\"/>");
        wb.println("      <Column ss:Index=\"12\" ss:StyleID=\"s21\" ss:AutoFitWidth=\"0\" ss:Width=\"108.75\"/>");
        wb.println("      <Column ss:StyleID=\"s21\" ss:AutoFitWidth=\"0\" ss:Width=\"9\"/>");
        wb.println("      <Column ss:StyleID=\"s21\" ss:Hidden=\"1\" ss:AutoFitWidth=\"0\" ss:Span=\"242\"/>");
        wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"20.25\">");
        wb.println("       <Cell ss:Index=\"2\" ss:StyleID=\"s22\"><Data ss:Type=\"String\">"+company.getName().toUpperCase()+"</Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"12.75\">");
        wb.println("       <Cell ss:Index=\"2\" ss:StyleID=\"s23\"><Data ss:Type=\"String\" x:Ticked=\"1\">"+company.getAddress()+"</Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"12.75\">");
        wb.println("       <Cell ss:Index=\"2\" ss:StyleID=\"s23\"><Data ss:Type=\"String\" x:Ticked=\"1\">"+company.getAddress2()+"</Data></Cell>");
        wb.println("       <Cell ss:Index=\"5\" ss:StyleID=\"s23\"/>");
        wb.println("      </Row>");
        
        /*
        wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"12.75\">");
        wb.println("       <Cell ss:Index=\"2\" ss:StyleID=\"s23\"><Data ss:Type=\"String\" x:Ticked=\"1\">Contact : "+company.getContact()+"</Data></Cell>");
        wb.println("       <Cell ss:Index=\"5\" ss:StyleID=\"s23\"/>");
        wb.println("      </Row>");
         */
        
        wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"5.0625\">");
        wb.println("       <Cell ss:Index=\"2\" ss:StyleID=\"s25\"/>");
        wb.println("       <Cell ss:StyleID=\"s25\"/>");
        wb.println("       <Cell ss:StyleID=\"s25\"/>");
        wb.println("       <Cell ss:StyleID=\"s25\"/>");
        wb.println("       <Cell ss:StyleID=\"s25\"/>");
        wb.println("       <Cell ss:StyleID=\"s25\"/>");
        wb.println("       <Cell ss:StyleID=\"s25\"/>");
        wb.println("       <Cell ss:StyleID=\"s25\"/>");
        wb.println("       <Cell ss:StyleID=\"s25\"/>");
        wb.println("       <Cell ss:StyleID=\"s25\"/>");
        wb.println("       <Cell ss:StyleID=\"s25\"/>");
        wb.println("       <Cell ss:StyleID=\"s26\"/>");
        wb.println("      </Row>");
        
        wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"9.9375\"/>");
        wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"12.75\">");
        wb.println("       <Cell ss:Index=\"2\" ss:StyleID=\"s28\"><Data ss:Type=\"String\" x:Ticked=\"1\">ACCOUNT RECEIVABLE</Data></Cell>");
        //wb.println("       <Cell ss:Index=\"4\"><Data ss:Type=\"String\">"+ I_Project.ageDateStr[agedBy]+"</Data></Cell>");
        wb.println("       <Cell ss:Index=\"4\" ss:StyleID=\"s29\"/>");
        wb.println("       <Cell ss:Index=\"6\" ss:StyleID=\"s29\"/>");
        wb.println("       <Cell ss:StyleID=\"s29\"/>");
        wb.println("       <Cell ss:StyleID=\"s29\"/>");
        wb.println("       <Cell ss:StyleID=\"s29\"/>");
        wb.println("       <Cell ss:StyleID=\"s29\"/>");
        wb.println("       <Cell ss:StyleID=\"s29\"/>");
        wb.println("      </Row>");
        
        //===========================================
        if(unitUsaha.getOID()!=0){
            //wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"9.9375\"/>");
            wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"12.75\">");
            wb.println("       <Cell ss:Index=\"2\" ss:StyleID=\"s28\"><Data ss:Type=\"String\" x:Ticked=\"1\">"+unitUsaha.getName().toUpperCase()+"</Data></Cell>");
            //wb.println("       <Cell ss:Index=\"4\"><Data ss:Type=\"String\">"+ I_Project.ageDateStr[agedBy]+"</Data></Cell>");
            wb.println("       <Cell ss:Index=\"4\" ss:StyleID=\"s29\"/>");
            wb.println("       <Cell ss:Index=\"6\" ss:StyleID=\"s29\"/>");
            wb.println("       <Cell ss:StyleID=\"s29\"/>");
            wb.println("       <Cell ss:StyleID=\"s29\"/>");
            wb.println("       <Cell ss:StyleID=\"s29\"/>");
            wb.println("       <Cell ss:StyleID=\"s29\"/>");
            wb.println("       <Cell ss:StyleID=\"s29\"/>");
            wb.println("      </Row>");
        }
        
        //wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"9.9375\"/>");
        wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"12.75\">");
        wb.println("       <Cell ss:Index=\"2\" ss:StyleID=\"s28\"><Data ss:Type=\"String\" x:Ticked=\"1\">Aged by "+I_Project.ageDateStr[agedBy]+", Per "+JSPFormater.formatDate(new Date(), "dd MMMM yyyy")+"</Data></Cell>");
        //wb.println("       <Cell ss:Index=\"4\"><Data ss:Type=\"String\">"+ I_Project.ageDateStr[agedBy]+"</Data></Cell>");
        wb.println("       <Cell ss:Index=\"4\" ss:StyleID=\"s29\"/>");
        wb.println("       <Cell ss:Index=\"6\" ss:StyleID=\"s29\"/>");
        wb.println("       <Cell ss:StyleID=\"s29\"/>");
        wb.println("       <Cell ss:StyleID=\"s29\"/>");
        wb.println("       <Cell ss:StyleID=\"s29\"/>");
        wb.println("       <Cell ss:StyleID=\"s29\"/>");
        wb.println("       <Cell ss:StyleID=\"s29\"/>");
        wb.println("      </Row>");
        
        
        
        //===========================================
        
        wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"12.75\"/>");
        wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"20.0625\" ss:StyleID=\"s30\">");
        wb.println("       <Cell ss:Index=\"2\" ss:MergeDown=\"1\" ss:StyleID=\"m15979044\"><Data");
        wb.println("         ss:Type=\"String\">No</Data></Cell>");
        wb.println("       <Cell ss:MergeDown=\"1\" ss:StyleID=\"m15979054\"><Data ss:Type=\"String\">Code</Data></Cell>");
        wb.println("       <Cell ss:MergeDown=\"1\" ss:StyleID=\"m15979064\"><Data ss:Type=\"String\">Customer</Data></Cell>");
        wb.println("       <Cell ss:MergeAcross=\"1\" ss:StyleID=\"m15979074\"><Data ss:Type=\"String\">Last Payment</Data></Cell>");
        wb.println("       <Cell ss:MergeDown=\"1\" ss:StyleID=\"m15965284\"><Data ss:Type=\"String\">"+I_Project.ageRangeStr[I_Project.AGE_RANGE_CURRENT]+"</Data></Cell>");
        wb.println("       <Cell ss:MergeDown=\"1\" ss:StyleID=\"m15965294\"><Data ss:Type=\"String\">"+I_Project.ageRangeStr[I_Project.AGE_RANGE_OVER_30]+"</Data></Cell>");
        wb.println("       <Cell ss:MergeDown=\"1\" ss:StyleID=\"m15965304\"><Data ss:Type=\"String\"");
        wb.println("         x:Ticked=\"1\">"+I_Project.ageRangeStr[I_Project.AGE_RANGE_OVER_60]+"</Data></Cell>");
        wb.println("       <Cell ss:MergeDown=\"1\" ss:StyleID=\"m15965314\"><Data ss:Type=\"String\"");
        wb.println("         x:Ticked=\"1\">"+I_Project.ageRangeStr[I_Project.AGE_RANGE_OVER_90]+"</Data></Cell>");
        wb.println("       <Cell ss:MergeDown=\"1\" ss:StyleID=\"m15965436\"><Data ss:Type=\"String\"");
        wb.println("         x:Ticked=\"1\">"+I_Project.ageRangeStr[I_Project.AGE_RANGE_OVER_120]+"</Data></Cell>");
        wb.println("       <Cell ss:MergeDown=\"1\" ss:StyleID=\"m15965446\"><Data ss:Type=\"String\">Balance</Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"20.0625\" ss:StyleID=\"s30\">");
        wb.println("       <Cell ss:Index=\"5\" ss:StyleID=\"s31\"><Data ss:Type=\"String\">Amount</Data></Cell>");
        wb.println("       <Cell ss:StyleID=\"s31\"><Data ss:Type=\"String\">Date</Data></Cell>");
        wb.println("      </Row>");

double totalAmount = 0;
double totalCurrent = 0;
double totalOver30 = 0;
double totalOver60 = 0;
double totalOver90 = 0;
double totalOver120 = 0;

if (vectorList!=null && vectorList.size()>0){
    for(int i=0; i<vectorList.size(); i++){
        SesAgingAnalysis ageAnalysis = (SesAgingAnalysis)vectorList.get(i);          
        
        wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"15\" ss:StyleID=\"s47\">");
        wb.println("       <Cell ss:Index=\"2\" ss:StyleID=\"s48\"");
        wb.println("        ss:Formula=\"=IF(ISNUMBER(R[-1]C),R[-1]C+1,1)\"><Data ss:Type=\"Number\">1</Data></Cell>");
        wb.println("       <Cell ss:StyleID=\"s49\"><Data ss:Type=\"String\">"+ageAnalysis.getCustomerCode()+"</Data></Cell>");
        wb.println("       <Cell ss:StyleID=\"s49\"><Data ss:Type=\"String\">"+ageAnalysis.getCustomerName()+"</Data></Cell>");
        if (ageAnalysis.getLastPaymentAmount()==0){      
            wb.println("       <Cell ss:StyleID=\"s50\"><Data ss:Type=\"String\"></Data></Cell>");
        }else{
            wb.println("       <Cell ss:StyleID=\"s50\"><Data ss:Type=\"Number\">"+ageAnalysis.getLastPaymentAmount()+"</Data></Cell>");
        }
        if (ageAnalysis.getLastPaymentDate()==null){        
            wb.println("       <Cell ss:StyleID=\"s51\"><Data ss:Type=\"String\"></Data></Cell>");
        }else{
            wb.println("       <Cell ss:StyleID=\"s51\"><Data ss:Type=\"String\">"+JSPFormater.formatDate(ageAnalysis.getLastPaymentDate(),"dd MMM yyyy")+"</Data></Cell>");
        }
        if (ageAnalysis.getAgeCurrent()==0){      
            wb.println("       <Cell ss:StyleID=\"s50\"><Data ss:Type=\"String\"></Data></Cell>");
        }else{
            wb.println("       <Cell ss:StyleID=\"s50\"><Data ss:Type=\"Number\">"+ageAnalysis.getAgeCurrent()+"</Data></Cell>");
        }
        if (ageAnalysis.getAgeOver30()==0){      
            wb.println("       <Cell ss:StyleID=\"s50\"><Data ss:Type=\"String\"></Data></Cell>");
        }else{
            wb.println("       <Cell ss:StyleID=\"s50\"><Data ss:Type=\"Number\">"+ageAnalysis.getAgeOver30()+"</Data></Cell>");
        }
        if (ageAnalysis.getAgeOver60()==0){      
            wb.println("       <Cell ss:StyleID=\"s50\"><Data ss:Type=\"String\"></Data></Cell>");
        }else{
            wb.println("       <Cell ss:StyleID=\"s50\"><Data ss:Type=\"Number\">"+ageAnalysis.getAgeOver60()+"</Data></Cell>");
        }
        if (ageAnalysis.getAgeOver90()==0){      
            wb.println("       <Cell ss:StyleID=\"s50\"><Data ss:Type=\"String\"></Data></Cell>");
        }else{
            wb.println("       <Cell ss:StyleID=\"s50\"><Data ss:Type=\"Number\">"+ageAnalysis.getAgeOver90()+"</Data></Cell>");
        }
        if (ageAnalysis.getAgeOver120()==0){      
            wb.println("       <Cell ss:StyleID=\"s50\"><Data ss:Type=\"String\"></Data></Cell>");
        }else{
            wb.println("       <Cell ss:StyleID=\"s50\"><Data ss:Type=\"Number\">"+ageAnalysis.getAgeOver120()+"</Data></Cell>");
        }
        double total = ageAnalysis.getAgeCurrent() + ageAnalysis.getAgeOver30() + ageAnalysis.getAgeOver60() + ageAnalysis.getAgeOver90() + ageAnalysis.getAgeOver120();
        if (total==0){      
            wb.println("       <Cell ss:StyleID=\"s50\"><Data ss:Type=\"String\"></Data></Cell>");
        }else{
            wb.println("       <Cell ss:StyleID=\"s50\"><Data ss:Type=\"Number\">"+total+"</Data></Cell>");
        }
        wb.println("      </Row>");   
        
        //Load Total
        totalAmount = totalAmount + ageAnalysis.getLastPaymentAmount();
        totalCurrent = totalCurrent + ageAnalysis.getAgeCurrent();
        totalOver30 = totalOver30 + ageAnalysis.getAgeOver30();
        totalOver60 = totalOver60 + ageAnalysis.getAgeOver60();
        totalOver90 = totalOver90 + ageAnalysis.getAgeOver90();
        totalOver120 = totalOver120 + ageAnalysis.getAgeOver120();
    }
}
        
        wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"15\">");
        wb.println("       <Cell ss:Index=\"2\" ss:StyleID=\"s52\"/>");
        wb.println("       <Cell ss:StyleID=\"s53\"/>");
        wb.println("       <Cell ss:StyleID=\"s53\"/>");
        wb.println("       <Cell ss:StyleID=\"s54\"/>");
        wb.println("       <Cell ss:StyleID=\"s54\"/>");
        wb.println("       <Cell ss:StyleID=\"s54\"/>");
        wb.println("       <Cell ss:StyleID=\"s54\"/>");
        wb.println("       <Cell ss:StyleID=\"s54\"/>");
        wb.println("       <Cell ss:StyleID=\"s54\"/>");
        wb.println("       <Cell ss:StyleID=\"s54\"/>");
        wb.println("       <Cell ss:StyleID=\"s55\"/>");
        wb.println("      </Row>");

        wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"20.0625\" ss:StyleID=\"s83\">");
        wb.println("       <Cell ss:Index=\"2\" ss:MergeAcross=\"2\" ss:StyleID=\"s77\"><Data ss:Type=\"String\">Total</Data></Cell>");
        wb.println("       <Cell ss:StyleID=\"s81\"/>");
        wb.println("       <Cell ss:StyleID=\"s79\"/>");
        if(totalCurrent==0){
            wb.println("       <Cell ss:StyleID=\"s81\"><Data ss:Type=\"String\"></Data></Cell>");
        }else{
            wb.println("       <Cell ss:StyleID=\"s81\"><Data ss:Type=\"Number\">"+totalCurrent+"</Data></Cell>");
        }
        if(totalOver30==0){
            wb.println("       <Cell ss:StyleID=\"s81\"><Data ss:Type=\"String\"></Data></Cell>");
        }else{
            wb.println("       <Cell ss:StyleID=\"s81\"><Data ss:Type=\"Number\">"+totalOver30+"</Data></Cell>");
        }
        if(totalOver60==0){
            wb.println("       <Cell ss:StyleID=\"s81\"><Data ss:Type=\"String\"></Data></Cell>");
        }else{
            wb.println("       <Cell ss:StyleID=\"s81\"><Data ss:Type=\"Number\">"+totalOver60+"</Data></Cell>");
        }
        if(totalOver90==0){
            wb.println("       <Cell ss:StyleID=\"s81\"><Data ss:Type=\"String\"></Data></Cell>");
        }else{       
            wb.println("       <Cell ss:StyleID=\"s81\"><Data ss:Type=\"Number\">"+totalOver90+"</Data></Cell>");
        }
        if(totalOver120==0){
            wb.println("       <Cell ss:StyleID=\"s81\"><Data ss:Type=\"String\"></Data></Cell>");
        }else{       
            wb.println("       <Cell ss:StyleID=\"s81\"><Data ss:Type=\"Number\">"+totalOver120+"</Data></Cell>");
        }
        
        double grandTotal = 0;
        grandTotal = totalCurrent + totalOver30 + totalOver60 + totalOver90 + totalOver120;

        if(grandTotal==0){
            wb.println("       <Cell ss:StyleID=\"s81\"><Data ss:Type=\"String\"></Data></Cell>");
        }else{               
            wb.println("       <Cell ss:StyleID=\"s81\"><Data ss:Type=\"Number\">"+grandTotal+"</Data></Cell>");
        }
        wb.println("      </Row>");

        wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"12.75\"/>");
        wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"12.75\">");
        wb.println("       <Cell ss:Index=\"2\" ss:StyleID=\"s60\"/>");
        wb.println("       <Cell ss:StyleID=\"s60\"/>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"12.75\">");
        wb.println("       <Cell ss:Index=\"2\" ss:MergeAcross=\"2\" ss:StyleID=\"s62\"><Data ss:Type=\"String\"></Data></Cell>");
        wb.println("       <Cell ss:Index=\"7\" ss:StyleID=\"s63\"/>");
        wb.println("       <Cell ss:StyleID=\"s63\"/>");
        wb.println("       <Cell ss:StyleID=\"s63\"/>");
        wb.println("       <Cell ss:StyleID=\"s63\"/>");
        wb.println("       <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s66\"><Data ss:Type=\"String\" x:Ticked=\"1\">Date:___________________</Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"12.75\">");
        wb.println("       <Cell ss:Index=\"2\" ss:MergeAcross=\"1\" ss:StyleID=\"s67\"/>");
        wb.println("       <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s69\"/>");
        wb.println("       <Cell ss:Index=\"7\" ss:StyleID=\"s63\"/>");
        wb.println("       <Cell ss:StyleID=\"s63\"/>");
        wb.println("       <Cell ss:StyleID=\"s63\"/>");
        wb.println("       <Cell ss:StyleID=\"s63\"/>");
        wb.println("       <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s66\"><Data ss:Type=\"String\" x:Ticked=\"1\">Prepare by</Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"12.75\">");
        wb.println("       <Cell ss:Index=\"3\" ss:StyleID=\"s60\"/>");
        wb.println("       <Cell ss:Index=\"5\" ss:StyleID=\"s60\"/>");
        wb.println("       <Cell ss:Index=\"7\" ss:StyleID=\"s70\"/>");
        wb.println("       <Cell ss:StyleID=\"s70\"/>");
        wb.println("       <Cell ss:StyleID=\"s70\"/>");
        wb.println("       <Cell ss:StyleID=\"s70\"/>");
        wb.println("       <Cell ss:StyleID=\"s70\"/>");
        wb.println("       <Cell ss:StyleID=\"s70\"/>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"12.75\">");
        wb.println("       <Cell ss:Index=\"3\" ss:StyleID=\"s60\"/>");
        wb.println("       <Cell ss:Index=\"5\" ss:StyleID=\"s60\"/>");
        wb.println("       <Cell ss:Index=\"7\" ss:StyleID=\"s70\"/>");
        wb.println("       <Cell ss:StyleID=\"s70\"/>");
        wb.println("       <Cell ss:StyleID=\"s70\"/>");
        wb.println("       <Cell ss:StyleID=\"s70\"/>");
        wb.println("       <Cell ss:StyleID=\"s70\"/>");
        wb.println("       <Cell ss:StyleID=\"s70\"/>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"12.75\">");
        wb.println("       <Cell ss:Index=\"3\" ss:StyleID=\"s60\"/>");
        wb.println("       <Cell ss:Index=\"5\" ss:StyleID=\"s60\"/>");
        wb.println("       <Cell ss:Index=\"7\" ss:StyleID=\"s70\"/>");
        wb.println("       <Cell ss:StyleID=\"s70\"/>");
        wb.println("       <Cell ss:StyleID=\"s70\"/>");
        wb.println("       <Cell ss:StyleID=\"s70\"/>");
        wb.println("       <Cell ss:StyleID=\"s70\"/>");
        wb.println("       <Cell ss:StyleID=\"s70\"/>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"12.75\">");
        wb.println("       <Cell ss:Index=\"3\" ss:StyleID=\"s60\"/>");
        wb.println("       <Cell ss:Index=\"5\" ss:StyleID=\"s60\"/>");
        wb.println("       <Cell ss:Index=\"7\" ss:StyleID=\"s70\"/>");
        wb.println("       <Cell ss:StyleID=\"s70\"/>");
        wb.println("       <Cell ss:StyleID=\"s70\"/>");
        wb.println("       <Cell ss:StyleID=\"s70\"/>");
        wb.println("       <Cell ss:StyleID=\"s70\"/>");
        wb.println("       <Cell ss:StyleID=\"s70\"/>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"12.75\">");
        wb.println("       <Cell ss:Index=\"2\" ss:MergeAcross=\"1\" ss:StyleID=\"s72\"/>");
        wb.println("       <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s74\"/>");
        wb.println("       <Cell ss:Index=\"7\" ss:StyleID=\"s63\"/>");
        wb.println("       <Cell ss:StyleID=\"s63\"/>");
        wb.println("       <Cell ss:StyleID=\"s63\"/>");
        wb.println("       <Cell ss:StyleID=\"s63\"/>");
        wb.println("       <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s67\"><Data ss:Type=\"String\">( Management )</Data></Cell>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"12.75\">");
        wb.println("       <Cell ss:Index=\"2\" ss:StyleID=\"s60\"/>");
        wb.println("       <Cell ss:StyleID=\"s60\"/>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"12.75\" ss:Hidden=\"1\">");
        wb.println("       <Cell ss:Index=\"2\" ss:StyleID=\"s60\"/>");
        wb.println("       <Cell ss:StyleID=\"s60\"/>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"12.75\" ss:Hidden=\"1\">");
        wb.println("       <Cell ss:Index=\"2\" ss:StyleID=\"s60\"/>");
        wb.println("       <Cell ss:StyleID=\"s60\"/>");
        wb.println("      </Row>");
        wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"12.75\" ss:Hidden=\"1\" ss:Span=\"7\"/>");
        wb.println("     </Table>");
        wb.println("     <WorksheetOptions xmlns=\"urn:schemas-microsoft-com:office:excel\">");
        wb.println("      <PageSetup>");
        wb.println("       <Layout x:Orientation=\"Landscape\" x:CenterHorizontal=\"1\"/>");
        wb.println("       <PageMargins x:Bottom=\"0.25\" x:Left=\"0\" x:Right=\"0\" x:Top=\"0.5\"/>");
        wb.println("      </PageSetup>");
        wb.println("      <ZeroHeight/>");
        wb.println("      <Print>");
        wb.println("       <ValidPrinterInfo/>");
        wb.println("       <PaperSizeIndex>9</PaperSizeIndex>");
        wb.println("       <Scale>75</Scale>");
        wb.println("       <HorizontalResolution>-3</HorizontalResolution>");
        wb.println("       <VerticalResolution>600</VerticalResolution>");
        wb.println("      </Print>");
        wb.println("      <Selected/>");
        wb.println("      <DoNotDisplayGridlines/>");
        wb.println("      <Panes>");
        wb.println("       <Pane>");
        wb.println("        <Number>3</Number>");
        wb.println("        <ActiveRow>12</ActiveRow>");
        wb.println("       </Pane>");
        wb.println("      </Panes>");
        wb.println("      <ProtectObjects>False</ProtectObjects>");
        wb.println("      <ProtectScenarios>False</ProtectScenarios>");
        wb.println("     </WorksheetOptions>");
        wb.println("    </Worksheet>");
        wb.println("   </Workbook>");
        
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

