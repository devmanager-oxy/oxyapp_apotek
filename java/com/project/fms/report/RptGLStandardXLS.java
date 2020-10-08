/*
 * Report RptGLStandardXLS.java
 *
 * Created on May 6, 2008, 3:33 AM
 */

package com.project.fms.report;

import java.io.PrintWriter;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.util.zip.GZIPOutputStream;
import java.util.Vector;
import java.net.URLEncoder;
import java.util.Date;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
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


public class RptGLStandardXLS extends HttpServlet {
    
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
        response.setContentType("application/x-msexcel");
        
        // Load User Login
        String loginId = JSPRequestValue.requestString(request, "oid");
        // Load Date
        String strPeriod = JSPRequestValue.requestString(request, "period");
        long segmentId = 0;
        String locationName = "";
        try{
            segmentId = JSPRequestValue.requestLong(request, "segmentId");
            SegmentDetail sd = DbSegmentDetail.fetchExc(segmentId);
            locationName = sd.getName();
        }catch(Exception e){}
        
        // Load Company
        Company company = DbCompany.getCompany();
        long oidCompany = company.getOID();           

        Vector tmpXls = new Vector();
        String[] langFR = {""};
        // Load Invoice Item
        Vector vectorList = new Vector(1,1);
        try{
            HttpSession session = request.getSession();
            tmpXls = (Vector)session.getValue("GL_REPORT");
            langFR = (String[])tmpXls.get(0);
            vectorList = (Vector)tmpXls.get(1);
        } catch (Exception e) { System.out.println(e); }
        
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
        wb.println("    <RGB>#EBECED</RGB>");
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
        wb.println(" <Styles>");
        wb.println("  <Style ss:ID=\"Default\" ss:Name=\"Normal\">");
        wb.println("   <Alignment ss:Vertical=\"Bottom\"/>");
        wb.println("   <Borders/>");
        wb.println("   <Font ss:FontName=\"Arial\"/>");
        wb.println("   <Interior/>");
        wb.println("   <NumberFormat/>");
        wb.println("   <Protection/>");
        wb.println("  </Style>");
        wb.println("  <Style ss:ID=\"m53264444\">");
        wb.println("   <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Center\"/>");
        wb.println("   <Borders>");
        wb.println("    <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("    <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("    <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("   </Borders>");
        wb.println("   <Font ss:FontName=\"Arial\" x:Family=\"Swiss\" ss:Bold=\"1\"/>");
        wb.println("   <Interior ss:Color=\"#C0C0C0\" ss:Pattern=\"Solid\"/>");
        wb.println("  </Style>");
        wb.println("  <Style ss:ID=\"m53264464\">");
        wb.println("   <Alignment ss:Horizontal=\"Right\" ss:Vertical=\"Center\"/>");
        wb.println("   <Borders>");
        wb.println("    <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("    <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("    <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("   </Borders>");
        wb.println("   <Font ss:FontName=\"Arial\" x:Family=\"Swiss\" ss:Bold=\"1\"/>");
        wb.println("   <Interior ss:Color=\"#C0C0C0\" ss:Pattern=\"Solid\"/>");
        wb.println("   <NumberFormat ss:Format=\"#,##0;\\(#,##0\\)\"/>");
        wb.println("  </Style>");
        wb.println("  <Style ss:ID=\"m53264484\">");
        wb.println("   <Alignment ss:Horizontal=\"Right\" ss:Vertical=\"Center\" ss:Indent=\"1\"/>");
        wb.println("   <Borders>");
        wb.println("    <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("    <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("    <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("    <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("   </Borders>");
        wb.println("   <Font ss:FontName=\"Arial\" x:Family=\"Swiss\" ss:Bold=\"1\"/>");
        wb.println("   <Interior ss:Color=\"#EBECED\" ss:Pattern=\"Solid\"/>");
        wb.println("   <NumberFormat/>");
        wb.println("  </Style>");
        wb.println("  <Style ss:ID=\"s65\">");
        wb.println("   <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("   <Font ss:FontName=\"Arial\" x:Family=\"Swiss\" ss:Size=\"18\" ss:Bold=\"1\"/>");
        wb.println("  </Style>");
        wb.println("  <Style ss:ID=\"s67\">");
        wb.println("   <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("   <Font ss:FontName=\"Arial\" x:Family=\"Swiss\" ss:Size=\"16\" ss:Bold=\"1\"/>");
        wb.println("  </Style>");
        wb.println("  <Style ss:ID=\"s69\">");
        wb.println("   <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("   <Borders>");
        wb.println("    <Border ss:Position=\"Bottom\" ss:LineStyle=\"Double\" ss:Weight=\"3\"/>");
        wb.println("   </Borders>");
        wb.println("   <Font ss:FontName=\"Arial\" ss:Size=\"12\"/>");
        wb.println("  </Style>");
        wb.println("  <Style ss:ID=\"s84\">");
        wb.println("   <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("  </Style>");
        wb.println("  <Style ss:ID=\"s85\">");
        wb.println("   <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\"/>");
        wb.println("   <Borders/>");
        wb.println("   <Font ss:FontName=\"Arial\" x:Family=\"Swiss\" ss:Bold=\"1\"/>");
        wb.println("  </Style>");
        wb.println("  <Style ss:ID=\"s86\">");
        wb.println("   <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\"/>");
        wb.println("   <Borders>");
        wb.println("    <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("    <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("    <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("    <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("   </Borders>");
        wb.println("   <Font ss:FontName=\"Arial\" x:Family=\"Swiss\" ss:Bold=\"1\"/>");
        wb.println("   <Interior ss:Color=\"#EBECED\" ss:Pattern=\"Solid\"/>");
        wb.println("   <NumberFormat/>");
        wb.println("  </Style>");
        wb.println("  <Style ss:ID=\"s87\">");
        wb.println("   <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Center\"/>");
        wb.println("   <Borders/>");
        wb.println("   <Font ss:FontName=\"Arial\" x:Family=\"Swiss\" ss:Bold=\"1\"/>");
        wb.println("  </Style>");
        wb.println("  <Style ss:ID=\"s89\">");
        wb.println("   <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\"/>");
        wb.println("   <Borders>");
        wb.println("    <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("    <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("    <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("    <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("   </Borders>");
        wb.println("   <Font ss:FontName=\"Arial\" x:Family=\"Swiss\"/>");
        wb.println("   <NumberFormat/>");
        wb.println("  </Style>");
        wb.println("  <Style ss:ID=\"s90\">");
        wb.println("   <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Center\" ss:WrapText=\"1\"/>");
        wb.println("   <Borders>");
        wb.println("    <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("    <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("    <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("    <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("   </Borders>");
        wb.println("   <Font ss:FontName=\"Arial\" x:Family=\"Swiss\"/>");
        wb.println("   <NumberFormat/>");
        wb.println("  </Style>");
        wb.println("  <Style ss:ID=\"s100\">");
        wb.println("   <Interior/>");
        wb.println("  </Style>");
        wb.println("  <Style ss:ID=\"s101\">");
        wb.println("   <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Center\"/>");
        wb.println("   <Borders/>");
        wb.println("   <Font ss:FontName=\"Arial\" x:Family=\"Swiss\" ss:Bold=\"1\"/>");
        wb.println("   <Interior/>");
        wb.println("  </Style>");
        wb.println("  <Style ss:ID=\"s102\">");
        wb.println("   <Alignment ss:Horizontal=\"Right\" ss:Vertical=\"Center\" ss:Indent=\"1\"/>");
        wb.println("   <Borders>");
        wb.println("    <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("   </Borders>");
        wb.println("   <Font ss:FontName=\"Arial\" x:Family=\"Swiss\" ss:Bold=\"1\"/>");
        wb.println("   <Interior/>");
        wb.println("   <NumberFormat/>");
        wb.println("  </Style>");
        wb.println("  <Style ss:ID=\"s105\">");
        wb.println("   <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("   <Borders/>");
        wb.println("   <NumberFormat/>");
        wb.println("  </Style>");
        wb.println("  <Style ss:ID=\"s107\">");
        wb.println("   <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("   <NumberFormat/>");
        wb.println("  </Style>");
        wb.println("  <Style ss:ID=\"s111\">");
        wb.println("   <Alignment ss:Vertical=\"Center\"/>");
        wb.println("  </Style>");
        wb.println("  <Style ss:ID=\"s114\">");
        wb.println("   <Alignment ss:Vertical=\"Center\"/>");
        wb.println("   <Borders>");
        wb.println("    <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("    <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("    <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("   </Borders>");
        wb.println("   <Font ss:FontName=\"Arial\" x:Family=\"Swiss\" ss:Bold=\"1\"/>");
        wb.println("   <Interior ss:Color=\"#EBECED\" ss:Pattern=\"Solid\"/>");
        wb.println("   <NumberFormat/>");
        wb.println("  </Style>");
        wb.println("  <Style ss:ID=\"s115\">");
        wb.println("   <Alignment ss:Vertical=\"Center\"/>");
        wb.println("   <Borders>");
        wb.println("    <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("    <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("    <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("    <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("   </Borders>");
        wb.println("   <Font ss:FontName=\"Arial\" x:Family=\"Swiss\"/>");
        wb.println("   <NumberFormat ss:Format=\"#,##0;\\(#,##0\\)\"/>");
        wb.println("  </Style>");
        wb.println("  <Style ss:ID=\"s116\">");
        wb.println("   <Alignment ss:Vertical=\"Center\"/>");
        wb.println("   <Borders>");
        wb.println("    <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("    <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("    <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("    <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("   </Borders>");
        wb.println("   <Font ss:FontName=\"Arial\" x:Family=\"Swiss\" ss:Bold=\"1\"/>");
        wb.println("   <Interior ss:Color=\"#EBECED\" ss:Pattern=\"Solid\"/>");
        wb.println("   <NumberFormat ss:Format=\"#,##0;\\(#,##0\\)\"/>");
        wb.println("  </Style>");
        wb.println("  <Style ss:ID=\"s117\">");
        wb.println("   <Alignment ss:Vertical=\"Center\"/>");
        wb.println("   <Borders/>");
        wb.println("   <Font ss:FontName=\"Arial\" x:Family=\"Swiss\" ss:Bold=\"1\"/>");
        wb.println("   <Interior/>");
        wb.println("   <NumberFormat ss:Format=\"#,##0;\\(#,##0\\)\"/>");
        wb.println("  </Style>");
        wb.println("  <Style ss:ID=\"s118\">");
        wb.println("   <Alignment ss:Horizontal=\"Right\" ss:Vertical=\"Center\"/>");
        wb.println("  </Style>");
        wb.println(" </Styles>");
        wb.flush();
        
        //Top Header
        company = new Company();
        try{
            company = DbCompany.fetchExc(oidCompany);
        }catch(Exception e){}
        
        wb.println(" <Worksheet ss:Name=\""+langFR[0]+"\">");
        wb.println("<Names>");
        wb.println("<NamedRange ss:Name=\"Print_Titles\" ss:RefersTo=\"='"+langFR[0]+"'!R8\"/>");
        wb.println("</Names>");
        wb.println("  <Table>");
        wb.println("   <Column ss:AutoFitWidth=\"0\" ss:Width=\"9\"/>");
        wb.println("   <Column ss:AutoFitWidth=\"0\" ss:Width=\"20\"/>");
        wb.println("   <Column ss:AutoFitWidth=\"0\" ss:Width=\"59.25\"/>");
        wb.println("   <Column ss:AutoFitWidth=\"0\" ss:Width=\"89.25\"/>");
        wb.println("   <Column ss:AutoFitWidth=\"0\" ss:Width=\"185\"/>");
        wb.println("   <Column ss:StyleID=\"s111\" ss:AutoFitWidth=\"0\" ss:Width=\"93\" ss:Span=\"2\"/>");
        wb.println("   <Row>");
        wb.println("    <Cell ss:Index=\"4\" ss:StyleID=\"s111\"/>");
        wb.println("    <Cell ss:Index=\"8\" ss:StyleID=\"s118\"><Data ss:Type=\"String\">"+langFR[9]+" : "+JSPFormater.formatDate(new Date(),formatDate)+"</Data></Cell>");
        wb.println("   </Row>");
        wb.println("   <Row>");
        wb.println("    <Cell ss:StyleID=\"s85\"><Data ss:Type=\"String\"></Data></Cell>");
        wb.println("   </Row>");
        wb.println("   <Row ss:AutoFitHeight=\"0\" ss:Height=\"23.25\">");
        wb.println("    <Cell ss:MergeAcross=\"7\" ss:StyleID=\"s65\"><Data ss:Type=\"String\" x:Ticked=\"1\">"+company.getName().toUpperCase()+"</Data></Cell>");
        wb.println("   </Row>");
        
        if(locationName.length() > 0){
            wb.println("   <Row ss:AutoFitHeight=\"0\" ss:Height=\"23.25\">");
            wb.println("    <Cell ss:MergeAcross=\"7\" ss:StyleID=\"s65\"><Data ss:Type=\"String\" x:Ticked=\"1\">"+locationName.toUpperCase()+"</Data></Cell>");
            wb.println("   </Row>");
        }
        
        wb.println("   <Row ss:AutoFitHeight=\"0\" ss:Height=\"20.25\">");
        wb.println("    <Cell ss:MergeAcross=\"7\" ss:StyleID=\"s67\"><Data ss:Type=\"String\">"+langFR[0]+"</Data></Cell>");
        wb.println("   </Row>");
        wb.println("   <Row ss:AutoFitHeight=\"0\" ss:Height=\"18\">");
        wb.println("    <Cell ss:MergeAcross=\"7\" ss:StyleID=\"s69\"><Data ss:Type=\"String\">"+ strPeriod +"</Data></Cell>");
        wb.println("   </Row>");
       
        //Content Header        
        wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"15\"/>");
        
        //content
        if(vectorList!=null && vectorList.size()>0){
            for(int i=0; i<vectorList.size(); i++){
                SesReportBs srb = (SesReportBs)vectorList.get(i);
                int nomor = 1;
                
                wb.println("   <Row>");
                wb.println("    <Cell ss:MergeAcross=\"5\" ss:StyleID=\"m53264444\"><Data ss:Type=\"String\">"+srb.getDescription()+"</Data></Cell>");
                wb.println("    <Cell ss:MergeAcross=\"1\" ss:StyleID=\"m53264464\"><Data ss:Type=\"String\">"+srb.getStrAmount()+"</Data></Cell>");
                wb.println("   </Row>");
                
                wb.println("   <Row ss:StyleID=\"s84\">");
                wb.println("    <Cell ss:StyleID=\"s85\"><NamedCell ss:Name=\"Print_Titles\"/></Cell>");
                wb.println("    <Cell ss:StyleID=\"s86\"><Data ss:Type=\"String\">No.</Data><NamedCell ss:Name=\"Print_Titles\"/></Cell>");
                wb.println("    <Cell ss:StyleID=\"s86\"><Data ss:Type=\"String\">"+langFR[2]+"</Data><NamedCell ss:Name=\"Print_Titles\"/></Cell>");
                wb.println("    <Cell ss:StyleID=\"s86\"><Data ss:Type=\"String\">"+langFR[3]+"</Data><NamedCell ss:Name=\"Print_Titles\"/></Cell>");
                wb.println("    <Cell ss:StyleID=\"s86\"><Data ss:Type=\"String\">"+langFR[4]+"</Data><NamedCell ss:Name=\"Print_Titles\"/></Cell>");
                wb.println("    <Cell ss:StyleID=\"s86\"><Data ss:Type=\"String\">"+langFR[5]+"</Data><NamedCell ss:Name=\"Print_Titles\"/></Cell>");
                wb.println("    <Cell ss:StyleID=\"s86\"><Data ss:Type=\"String\">"+langFR[6]+"</Data><NamedCell ss:Name=\"Print_Titles\"/></Cell>");
                wb.println("    <Cell ss:StyleID=\"s86\"><Data ss:Type=\"String\">"+langFR[7]+"</Data><NamedCell ss:Name=\"Print_Titles\"/></Cell>");
                wb.println("   </Row>");


                Vector listDetail = new Vector();
                listDetail = srb.getDepartment();
                if(listDetail!=null && listDetail.size()>0){
                    for(int i2=0; i2<listDetail.size(); i2++){
                        SesReportGl gld = (SesReportGl)listDetail.get(i2);
                        
                        if(!gld.getMemo().equals("Total")){
                            wb.println("   <Row>");
                            wb.println("    <Cell ss:StyleID=\"s87\"/>");
                            wb.println("    <Cell ss:StyleID=\"s89\"><Data ss:Type=\"String\" x:Ticked=\"1\">"+nomor+"</Data></Cell>");
                            wb.println("    <Cell ss:StyleID=\"s89\"><Data ss:Type=\"String\" x:Ticked=\"1\">"+gld.getStrTransDate()+"</Data></Cell>");
                            wb.println("    <Cell ss:StyleID=\"s89\"><Data ss:Type=\"String\" x:Ticked=\"1\">"+gld.getJournalNumber()+"</Data></Cell>");
                            wb.println("    <Cell ss:StyleID=\"s90\"><Data ss:Type=\"String\">"+gld.getMemo()+"</Data></Cell>");
                            wb.println("    <Cell ss:StyleID=\"s115\"><Data ss:Type=\"Number\">"+gld.getDebet()+"</Data></Cell>");
                            wb.println("    <Cell ss:StyleID=\"s115\"><Data ss:Type=\"Number\">"+gld.getCredit()+"</Data></Cell>");
                            wb.println("    <Cell ss:StyleID=\"s115\"><Data ss:Type=\"Number\">"+gld.getBalance()+"</Data></Cell>");
                            wb.println("   </Row>");
                            nomor++;
                        }                        
                        if(gld.getMemo().equals("Total")){
                            wb.println("   <Row>");
                            wb.println("    <Cell ss:StyleID=\"s87\"/>");
                            wb.println("    <Cell ss:MergeAcross=\"3\" ss:StyleID=\"m53264484\"><Data ss:Type=\"String\">Total</Data></Cell>");
                            wb.println("    <Cell ss:StyleID=\"s116\"><Data ss:Type=\"Number\">"+gld.getDebet()+"</Data></Cell>");
                            wb.println("    <Cell ss:StyleID=\"s116\"><Data ss:Type=\"Number\">"+gld.getCredit()+"</Data></Cell>");
                            wb.println("    <Cell ss:StyleID=\"s116\"><Data ss:Type=\"Number\">"+gld.getBalance()+"</Data></Cell>");
                            wb.println("   </Row>");

                        }
                    }
                }

            }
        }
        
        wb.println("   <Row>");
        wb.println("    <Cell ss:StyleID=\"s85\"><Data ss:Type=\"String\"></Data></Cell>");
        wb.println("   </Row>");
        wb.println("   <Row>");
        wb.println("    <Cell ss:StyleID=\"s85\"><Data ss:Type=\"String\"></Data></Cell>");
        wb.println("   </Row>");
        wb.println("   <Row>");
        wb.println("    <Cell ss:Index=\"3\" ss:MergeAcross=\"1\" ss:StyleID=\"s85\"><Data ss:Type=\"String\">"+langFR[2]+": ________________</Data></Cell>");
        wb.println("    <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s85\"><Data ss:Type=\"String\">"+langFR[2]+": ________________</Data></Cell>");
        wb.println("    <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s85\"><Data ss:Type=\"String\">"+langFR[2]+": ________________</Data></Cell>");
        wb.println("   </Row>");
        wb.println("   <Row>");
        wb.println("    <Cell ss:Index=\"3\" ss:MergeAcross=\"1\" ss:StyleID=\"s85\"><Data ss:Type=\"String\">"+langFR[10]+"</Data></Cell>");
        wb.println("    <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s85\"><Data ss:Type=\"String\">"+langFR[11]+"</Data></Cell>");
        wb.println("    <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s85\"><Data ss:Type=\"String\">"+langFR[12]+"</Data></Cell>");
        wb.println("   </Row>");
        wb.println("   <Row>");
        wb.println("    <Cell ss:StyleID=\"s85\"><Data ss:Type=\"String\"></Data></Cell>");
        wb.println("   </Row>");
        wb.println("   <Row>");
        wb.println("    <Cell ss:StyleID=\"s85\"><Data ss:Type=\"String\"></Data></Cell>");
        wb.println("   </Row>");
        wb.println("   <Row>");
        wb.println("    <Cell ss:StyleID=\"s85\"><Data ss:Type=\"String\"></Data></Cell>");
        wb.println("   </Row>");
        wb.println("   <Row>");
        wb.println("    <Cell ss:Index=\"3\" ss:MergeAcross=\"1\" ss:StyleID=\"s85\"><Data ss:Type=\"String\">________________________</Data></Cell>");
        wb.println("    <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s85\"><Data ss:Type=\"String\">________________________</Data></Cell>");
        wb.println("    <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s85\"><Data ss:Type=\"String\">________________________</Data></Cell>");
        wb.println("   </Row>");

        
        wb.println("  </Table>");
        wb.println("  <WorksheetOptions xmlns=\"urn:schemas-microsoft-com:office:excel\">");
        wb.println("   <PageSetup>");
        wb.println("    <Footer x:Data=\"&amp;CHalaman &amp;P dari &amp;N\"/>");
        wb.println("    <PageMargins x:Bottom=\"0.75\" x:Left=\"0.25\" x:Right=\"0.25\" x:Top=\"0.5\"/>");
        wb.println("   </PageSetup>");
        wb.println("   <Print>");
        wb.println("    <ValidPrinterInfo/>");
        wb.println("    <Scale>85</Scale>");
        wb.println("    <HorizontalResolution>-4</HorizontalResolution>");
        wb.println("    <VerticalResolution>600</VerticalResolution>");
        wb.println("   </Print>");
        wb.println("   <Selected/>");
        wb.println("   <DoNotDisplayGridlines/>");
        wb.println("   <DoNotDisplayZeros/>");
        wb.println("   <FreezePanes/>");
        wb.println("   <FrozenNoSplit/>");
        wb.println("   <SplitHorizontal>5</SplitHorizontal>");
        wb.println("   <TopRowBottomPane>5</TopRowBottomPane>");
        wb.println("   <ActivePane>2</ActivePane>");
        wb.println("   <Panes>");
        wb.println("    <Pane>");
        wb.println("     <Number>3</Number>");
        wb.println("    </Pane>");
        wb.println("    <Pane>");
        wb.println("     <Number>2</Number>");
        wb.println("     <ActiveRow>1</ActiveRow>");
        wb.println("     <ActiveCol>8</ActiveCol>");
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
