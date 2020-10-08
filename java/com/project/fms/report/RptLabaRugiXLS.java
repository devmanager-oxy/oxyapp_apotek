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


public class RptLabaRugiXLS extends HttpServlet {
    
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
        
        
        RptLabaRugi rptKonstan = new RptLabaRugi();
        try{
            HttpSession session = request.getSession();
            rptKonstan = (RptLabaRugi)session.getValue("KONSTAN");
        } catch (Exception ex) { System.out.println(ex); }
        
        // Load Laba Rugi
        Vector vectorList = new Vector(1,1);
        try{
            HttpSession session = request.getSession();
            vectorList = (Vector)session.getValue("DETAIL");
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
        wb.println("<?xml version=\"1.0\"?>");
        wb.println("<?mso-application progid=\"Excel.Sheet\"?>");
        wb.println("<Workbook xmlns=\"urn:schemas-microsoft-com:office:spreadsheet\"");
        wb.println("xmlns:o=\"urn:schemas-microsoft-com:office:office\"");
        wb.println("xmlns:x=\"urn:schemas-microsoft-com:office:excel\"");
        wb.println("xmlns:ss=\"urn:schemas-microsoft-com:office:spreadsheet\"");
        wb.println("xmlns:html=\"http://www.w3.org/TR/REC-html40\">");
        wb.println("<DocumentProperties xmlns=\"urn:schemas-microsoft-com:office:office\">");
        wb.println("<Author>Victor</Author>");
        wb.println("<LastAuthor>Victor</LastAuthor>");
        wb.println("<LastPrinted>2009-09-26T16:30:00Z</LastPrinted>");
        wb.println("<Created>2009-09-26T15:44:49Z</Created>");
        wb.println("<LastSaved>2009-09-26T16:33:22Z</LastSaved>");
        wb.println("<Company>Victory</Company>");
        wb.println("<Version>11.5606</Version>");
        wb.println("</DocumentProperties>");
        wb.println("<ExcelWorkbook xmlns=\"urn:schemas-microsoft-com:office:excel\">");
        wb.println("<WindowHeight>9210</WindowHeight>");
        wb.println("<WindowWidth>15195</WindowWidth>");
        wb.println("<WindowTopX>360</WindowTopX>");
        wb.println("<WindowTopY>15</WindowTopY>");
        wb.println("<ProtectStructure>False</ProtectStructure>");
        wb.println("<ProtectWindows>False</ProtectWindows>");
        wb.println("</ExcelWorkbook>");
 
        wb.println("<Styles>");
        wb.println("<Style ss:ID=\"Default\" ss:Name=\"Normal\">");
        wb.println("<Alignment ss:Vertical=\"Bottom\"/>");
        wb.println("<Borders/>");
        wb.println("<Font/>");
        wb.println("<Interior/>");
        wb.println("<NumberFormat/>");
        wb.println("<Protection/>");
        wb.println("</Style>");

        wb.println("<Style ss:ID=\"s16\" ss:Name=\"Comma\">");
        wb.println("<NumberFormat ss:Format=\"_(* #,##0.00_);_(* \\(#,##0.00\\);_(* &quot;-&quot;??_);_(@_)\"/>");
        wb.println("</Style>");

        wb.println("<Style ss:ID=\"s26\">");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s71\">");
        wb.println("<Alignment ss:Vertical=\"Center\"/>");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font ss:FontName=\"Tahoma\" x:Family=\"Swiss\" ss:Size=\"8\" ss:Bold=\"1\"/>");
        wb.println("<Interior ss:Color=\"#FF99CC\" ss:Pattern=\"Solid\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s72\">");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Interior ss:Color=\"#FF99CC\" ss:Pattern=\"Solid\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s73\">");
        wb.println("<Alignment ss:Vertical=\"Center\"/>");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font ss:FontName=\"Tahoma\" x:Family=\"Swiss\" ss:Size=\"9\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s95\">");
        wb.println("<Alignment ss:Vertical=\"Center\"/>");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font ss:FontName=\"Tahoma\" x:Family=\"Swiss\" ss:Size=\"8\" ss:Bold=\"1\"/>");
        wb.println("<Interior ss:Color=\"#FFFF99\" ss:Pattern=\"Solid\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s101\">");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font ss:FontName=\"Tahoma\" x:Family=\"Swiss\" ss:Size=\"9\" ss:Bold=\"1\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s102\">");
        wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\" ss:WrapText=\"1\"/>");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font ss:FontName=\"Tahoma\" x:Family=\"Swiss\" ss:Size=\"9\" ss:Bold=\"1\"/>");
        wb.println("<Interior ss:Color=\"#00FFFF\" ss:Pattern=\"Solid\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s110\">");
        wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\" ss:WrapText=\"1\"/>");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font ss:FontName=\"Tahoma\" x:Family=\"Swiss\" ss:Size=\"8\" ss:Bold=\"1\"/>");
        wb.println("<Interior ss:Color=\"#99CCFF\" ss:Pattern=\"Solid\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s126\">");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font ss:FontName=\"Tahoma\" x:Family=\"Swiss\" ss:Size=\"9\" ss:Bold=\"1\"/>");
        wb.println("<Interior ss:Color=\"#FF99CC\" ss:Pattern=\"Solid\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s127\">");
        wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\" ss:WrapText=\"1\"/>");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font ss:FontName=\"Tahoma\" x:Family=\"Swiss\" ss:Size=\"9\" ss:Bold=\"1\"/>");
        wb.println("<Interior ss:Color=\"#FF99CC\" ss:Pattern=\"Solid\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s130\">");
        wb.println("<Font ss:FontName=\"Tahoma\" x:Family=\"Swiss\" ss:Size=\"12\" ss:Bold=\"1\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s132\">");
        wb.println("<Font ss:FontName=\"Tahoma\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Bold=\"1\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s133\" ss:Parent=\"s16\">");
        wb.println("<Alignment ss:Vertical=\"Center\"/>");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font ss:FontName=\"Tahoma\" x:Family=\"Swiss\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s134\" ss:Parent=\"s16\">");
        wb.println("<Alignment ss:Vertical=\"Center\"/>");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s135\" ss:Parent=\"s16\">");
        wb.println("<Alignment ss:Vertical=\"Center\"/>");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font ss:FontName=\"Tahoma\" x:Family=\"Swiss\" ss:Size=\"8\" ss:Bold=\"1\"/>");
        wb.println("<Interior ss:Color=\"#FFFF99\" ss:Pattern=\"Solid\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s136\" ss:Parent=\"s16\">");
        wb.println("<Alignment ss:Vertical=\"Center\"/>");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font ss:FontName=\"Tahoma\" x:Family=\"Swiss\" ss:Size=\"9\" ss:Bold=\"1\"/>");
        wb.println("<Interior ss:Color=\"#00FFFF\" ss:Pattern=\"Solid\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s137\" ss:Parent=\"s16\">");
        wb.println("<Alignment ss:Vertical=\"Center\"/>");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font ss:FontName=\"Tahoma\" x:Family=\"Swiss\" ss:Size=\"9\" ss:Bold=\"1\"/>");
        wb.println("<Interior ss:Color=\"#FF99CC\" ss:Pattern=\"Solid\"/>");
        wb.println("</Style>");
        wb.println("</Styles>");

        wb.println("<Worksheet ss:Name=\"Sheet1\">");
        wb.println("<Table ss:ExpandedColumnCount=\"256\" x:FullColumns=\"1\"");
        wb.println("x:FullRows=\"1\">");
        wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"5.25\"/>");
        wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"59.25\"/>");
        wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"260.25\"/>");
        wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"107.25\" ss:Span=\"4\"/>");
        wb.println("<Column ss:Index=\"9\" ss:AutoFitWidth=\"0\" ss:Width=\"4.5\"/>");
        wb.println("<Column ss:Hidden=\"1\" ss:AutoFitWidth=\"0\" ss:Span=\"246\"/>");
        wb.println("<Row ss:Index=\"2\" ss:AutoFitHeight=\"0\" ss:Height=\"15\">");
        wb.println("<Cell ss:Index=\"2\" ss:StyleID=\"s130\"><Data ss:Type=\"String\">IKHTISAR LABA/RUGI "+company.getName()+"</Data></Cell>");
        wb.println("</Row>");
        wb.println("<Row ss:AutoFitHeight=\"0\" ss:Height=\"15\">");
        wb.println("<Cell ss:Index=\"2\" ss:StyleID=\"s132\"><Data ss:Type=\"String\">BULAN "+rptKonstan.getPeriode().toUpperCase()+"</Data></Cell>");
        wb.println("</Row>");

        wb.println("<Row ss:Index=\"5\" ss:AutoFitHeight=\"0\" ss:Height=\"26.25\">");
        wb.println("<Cell ss:Index=\"2\" ss:StyleID=\"s110\"><Data ss:Type=\"String\">KD_PER</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s110\"><Data ss:Type=\"String\">NAMA_PERKIRAAN</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s110\"><Data ss:Type=\"String\">TH "+rptKonstan.getTahun()+"</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s110\"><Data ss:Type=\"String\">TGT SD BLN INI</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s110\"><Data ss:Type=\"String\">TGT BL INI</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s110\"><Data ss:Type=\"String\">RLS SD BLN INI</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s110\"><Data ss:Type=\"String\">RLS BLN INI</Data></Cell>");
        wb.println("</Row>");

        wb.println("<Row>");
        wb.println("<Cell ss:Index=\"2\" ss:StyleID=\"s26\"/>");
        wb.println("<Cell ss:StyleID=\"s26\"/>");
        wb.println("<Cell ss:StyleID=\"s26\"/>");
        wb.println("<Cell ss:StyleID=\"s26\"/>");
        wb.println("<Cell ss:StyleID=\"s26\"/>");
        wb.println("<Cell ss:StyleID=\"s26\"/>");
        wb.println("<Cell ss:StyleID=\"s26\"/>");
        wb.println("</Row>");
        wb.println("<Row ss:AutoFitHeight=\"0\" ss:Height=\"15\">");
        wb.println("<Cell ss:Index=\"2\" ss:StyleID=\"s26\"/>");
        wb.println("<Cell ss:StyleID=\"s71\"><Data ss:Type=\"String\">PENDAPATAN</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s72\"/>");
        wb.println("<Cell ss:StyleID=\"s72\"/>");
        wb.println("<Cell ss:StyleID=\"s72\"/>");
        wb.println("<Cell ss:StyleID=\"s72\"/>");
        wb.println("<Cell ss:StyleID=\"s72\"/>");
        wb.println("</Row>");
        
        if(vectorList!=null && vectorList.size()>0){
            for(int i=0;i<vectorList.size();i++){
                RptLabaRugiL detail = (RptLabaRugiL)vectorList.get(i);
                
                    if(detail.getType()==1){
                        wb.println("<Row ss:AutoFitHeight=\"0\" ss:Height=\"15.9375\">");
                        wb.println("<Cell ss:Index=\"2\" ss:StyleID=\"s26\"/>");
                        wb.println("<Cell ss:StyleID=\"s73\"><Data ss:Type=\"String\">"+detail.getKeterangan()+"</Data></Cell>");
                        wb.println("<Cell ss:StyleID=\"s133\"><Data ss:Type=\"Number\">"+detail.getPertahun()+"</Data></Cell>");
                        wb.println("<Cell ss:StyleID=\"s133\"><Data ss:Type=\"Number\">"+detail.getTargetSd()+"</Data></Cell>");
                        wb.println("<Cell ss:StyleID=\"s133\"><Data ss:Type=\"Number\">"+detail.getTargetBulanIni()+"</Data></Cell>");
                        wb.println("<Cell ss:StyleID=\"s133\"><Data ss:Type=\"Number\">"+detail.getRealSd()+"</Data></Cell>");
                        wb.println("<Cell ss:StyleID=\"s133\"><Data ss:Type=\"Number\">"+detail.getRealBulanIni()+"</Data></Cell>");
                        wb.println("</Row>");
                    }else if(detail.getType()==2 || detail.getType()==4 || detail.getType()==6 || detail.getType()==8 || detail.getType()==10){
                        wb.println("<Row ss:AutoFitHeight=\"0\" ss:Height=\"16.5\">");
                        wb.println("<Cell ss:Index=\"2\" ss:StyleID=\"s95\"/>");
                        wb.println("<Cell ss:StyleID=\"s95\"><Data ss:Type=\"String\">"+detail.getKeterangan()+"</Data></Cell>");
                        wb.println("<Cell ss:StyleID=\"s135\"><Data ss:Type=\"Number\">"+detail.getPertahun()+"</Data></Cell>");
                        wb.println("<Cell ss:StyleID=\"s135\"><Data ss:Type=\"Number\">"+detail.getTargetSd()+"</Data></Cell>");
                        wb.println("<Cell ss:StyleID=\"s135\"><Data ss:Type=\"Number\">"+detail.getTargetBulanIni()+"</Data></Cell>");
                        wb.println("<Cell ss:StyleID=\"s135\"><Data ss:Type=\"Number\">"+detail.getRealSd()+"</Data></Cell>");
                        wb.println("<Cell ss:StyleID=\"s135\"><Data ss:Type=\"Number\">"+detail.getRealBulanIni()+"</Data></Cell>");
                        wb.println("</Row>");
                    }else if(detail.getType()==3 || detail.getType()==5 || detail.getType()==7 || detail.getType()==9){
                        wb.println("<Row ss:AutoFitHeight=\"0\" ss:Height=\"27.75\">");
                        wb.println("<Cell ss:Index=\"2\" ss:StyleID=\"s101\"/>");
                        wb.println("<Cell ss:StyleID=\"s102\"><Data ss:Type=\"String\">"+detail.getKeterangan()+"</Data></Cell>");
                        wb.println("<Cell ss:StyleID=\"s136\"><Data ss:Type=\"Number\">"+detail.getPertahun()+"</Data></Cell>");
                        wb.println("<Cell ss:StyleID=\"s136\"><Data ss:Type=\"Number\">"+detail.getTargetSd()+"</Data></Cell>");
                        wb.println("<Cell ss:StyleID=\"s136\"><Data ss:Type=\"Number\">"+detail.getTargetBulanIni()+"</Data></Cell>");
                        wb.println("<Cell ss:StyleID=\"s136\"><Data ss:Type=\"Number\">"+detail.getRealSd()+"</Data></Cell>");
                        wb.println("<Cell ss:StyleID=\"s136\"><Data ss:Type=\"Number\">"+detail.getRealBulanIni()+"</Data></Cell>");
                        wb.println("</Row>");
                    }else{
                        wb.println("<Row ss:AutoFitHeight=\"0\" ss:Height=\"31.5\">");
                        wb.println("<Cell ss:Index=\"2\" ss:StyleID=\"s126\"/>");
                        wb.println("<Cell ss:StyleID=\"s127\"><Data ss:Type=\"String\">"+detail.getKeterangan()+"</Data></Cell>");
                        wb.println("<Cell ss:StyleID=\"s137\"><Data ss:Type=\"Number\">"+detail.getPertahun()+"</Data></Cell>");
                        wb.println("<Cell ss:StyleID=\"s137\"><Data ss:Type=\"Number\">"+detail.getTargetSd()+"</Data></Cell>");
                        wb.println("<Cell ss:StyleID=\"s137\"><Data ss:Type=\"Number\">"+detail.getTargetBulanIni()+"</Data></Cell>");
                        wb.println("<Cell ss:StyleID=\"s137\"><Data ss:Type=\"Number\">"+detail.getRealSd()+"</Data></Cell>");
                        wb.println("<Cell ss:StyleID=\"s137\"><Data ss:Type=\"Number\">"+detail.getRealBulanIni()+"</Data></Cell>");
                        wb.println("</Row>");
                    }
            }
        }
        
        wb.println("</Table>"); 
        wb.println("<WorksheetOptions xmlns=\"urn:schemas-microsoft-com:office:excel\">");
        wb.println("<PageSetup>");
        wb.println("<Layout x:Orientation=\"Landscape\" x:CenterHorizontal=\"1\"/>");
        wb.println("<Header x:Margin=\"0.13\"/>");
        wb.println("<Footer x:Margin=\"0.19\"/>");
        wb.println("<PageMargins x:Bottom=\"0.22\" x:Left=\"0.13\" x:Right=\"0.49\" x:Top=\"0.17\"/>");
        wb.println("</PageSetup>");
        wb.println("<DisplayPageBreak/>");
        wb.println("<Print>");
        wb.println("<ValidPrinterInfo/>");
        wb.println("<PaperSizeIndex>9</PaperSizeIndex>");
        wb.println("<Scale>70</Scale>");
        wb.println("<HorizontalResolution>600</HorizontalResolution>");
        wb.println("<VerticalResolution>600</VerticalResolution>");
        wb.println("</Print>");
        wb.println("<Selected/>");
        wb.println("<DoNotDisplayGridlines/>");
        wb.println("<FreezePanes/>");
        wb.println("<FrozenNoSplit/>");
        wb.println("<SplitHorizontal>5</SplitHorizontal>");
        wb.println("<TopRowBottomPane>5</TopRowBottomPane>");
        wb.println("<SplitVertical>3</SplitVertical>");
        wb.println("<LeftColumnRightPane>3</LeftColumnRightPane>");
        wb.println("<ActivePane>0</ActivePane>");
        wb.println("<Panes>");
        wb.println("<Pane>");
        wb.println("<Number>3</Number>");
        wb.println("</Pane>");
        wb.println("<Pane>");
        wb.println("<Number>1</Number>");
        wb.println("<ActiveCol>2</ActiveCol>");
        wb.println("</Pane>");
        wb.println("<Pane>");
        wb.println("<Number>2</Number>");
        wb.println("<ActiveRow>7</ActiveRow>");
        wb.println("</Pane>");
        wb.println("<Pane>");
        wb.println("<Number>0</Number>");
        wb.println("<ActiveRow>0</ActiveRow>");
        wb.println("</Pane>");
        wb.println("</Panes>");
        wb.println("<ProtectObjects>False</ProtectObjects>");
        wb.println("<ProtectScenarios>False</ProtectScenarios>");
        wb.println("</WorksheetOptions>");
        wb.println("</Worksheet>");
        wb.println("<Worksheet ss:Name=\"Sheet2\">");
        wb.println("<WorksheetOptions xmlns=\"urn:schemas-microsoft-com:office:excel\">");
        wb.println("<ProtectObjects>False</ProtectObjects>");
        wb.println("<ProtectScenarios>False</ProtectScenarios>");
        wb.println("</WorksheetOptions>");
        wb.println("</Worksheet>");
        wb.println("<Worksheet ss:Name=\"Sheet3\">");
        wb.println("<WorksheetOptions xmlns=\"urn:schemas-microsoft-com:office:excel\">");
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
