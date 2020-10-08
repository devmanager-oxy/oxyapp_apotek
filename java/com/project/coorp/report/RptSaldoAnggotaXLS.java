/*
 * RptAccReceivableAgingXLS.java
 *
 * Created on October 30, 2008, 8:26 AM
 */

package com.project.coorp.report;

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
import com.project.coorp.member.*;

/**
 *
 * @author  Suarjaya
 */
public class RptSaldoAnggotaXLS extends HttpServlet {
    
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
        Company company = new Company();
        try{
            company = DbCompany.getCompany();
        }catch (Exception e){
            System.out.println(e);
        }

        // Load Vector Data Aging
        Vector vectorList = new Vector(1,1);
        try{
            HttpSession session = request.getSession();
            vectorList = (Vector)session.getValue("SALDO_ANGGOTA");
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

        wb.println("   <?xml version=\"1.0\"?>");
        wb.println("   <?mso-application progid=\"Excel.Sheet\"?>");
        wb.println("   <Workbook xmlns=\"urn:schemas-microsoft-com:office:spreadsheet\"");
        wb.println("    xmlns:o=\"urn:schemas-microsoft-com:office:office\"");
        wb.println("    xmlns:x=\"urn:schemas-microsoft-com:office:excel\"");
        wb.println("    xmlns:ss=\"urn:schemas-microsoft-com:office:spreadsheet\"");
        wb.println("    xmlns:html=\"http://www.w3.org/TR/REC-html40\">");
        wb.println("    <DocumentProperties xmlns=\"urn:schemas-microsoft-com:office:office\">");
        wb.println("     <Author>edarmasusila</Author>");
        wb.println("     <LastAuthor>edarmasusila</LastAuthor>");
        wb.println("     <Created>2009-10-27T16:51:12Z</Created>");
        wb.println("     <Company>eka</Company>");
        wb.println("     <Version>11.5606</Version>");
        wb.println("    </DocumentProperties>");
        wb.println("    <ExcelWorkbook xmlns=\"urn:schemas-microsoft-com:office:excel\">");
        wb.println("     <WindowHeight>8700</WindowHeight>");
        wb.println("     <WindowWidth>15195</WindowWidth>");
        wb.println("     <WindowTopX>480</WindowTopX>");
        wb.println("     <WindowTopY>135</WindowTopY>");
        wb.println("     <ProtectStructure>False</ProtectStructure>");
        wb.println("     <ProtectWindows>False</ProtectWindows>");
        wb.println("    </ExcelWorkbook>");
        wb.println("    <Styles>");
          wb.println("    <Style ss:ID=\"Default\" ss:Name=\"Normal\">");
           wb.println("    <Alignment ss:Vertical=\"Bottom\"/>");
           wb.println("    <Borders/>");
           wb.println("    <Font/>");
           wb.println("    <Interior/>");
           wb.println("    <NumberFormat/>");
           wb.println("    <Protection/>");
          wb.println("    </Style>");
          wb.println("    <Style ss:ID=\"s16\" ss:Name=\"Comma\">");
           wb.println("    <NumberFormat ss:Format=\"_(* #,##0.00_);_(* \\(#,##0.00\\);_(* &quot;-&quot;??_);_(@_)\"/>");
          wb.println("    </Style>");
          wb.println("    <Style ss:ID=\"m81144030\">");
           wb.println("    <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Bottom\"/>");
           wb.println("    <Borders>");
            wb.println("    <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\"/>");
            wb.println("    <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\"/>");
            wb.println("    <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\"/>");
            wb.println("    <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\"/>");
           wb.println("    </Borders>");
           wb.println("    <Font x:Family=\"Swiss\" ss:Size=\"9\" ss:Bold=\"1\"/>");
          wb.println("    </Style>");
          wb.println("    <Style ss:ID=\"s21\">");
           wb.println("    <Font x:Family=\"Swiss\" ss:Bold=\"1\"/>");
          wb.println("    </Style>");
          wb.println("    <Style ss:ID=\"s37\">");
           wb.println("    <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
          wb.println("    </Style>");
          wb.println("    <Style ss:ID=\"s85\">");
           wb.println("    <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\"/>");
           wb.println("    <Borders>");
            wb.println("    <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
            wb.println("    <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
            wb.println("    <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
            wb.println("    <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
           wb.println("    </Borders>");
           wb.println("    <Font x:Family=\"Swiss\" ss:Size=\"9\" ss:Bold=\"1\"/>");
          wb.println("    </Style>");
          wb.println("    <Style ss:ID=\"s86\">");
           wb.println("    <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\"/>");
           wb.println("    <Borders>");
            wb.println("    <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
            wb.println("    <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
            wb.println("    <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
            wb.println("    <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
           wb.println("    </Borders>");
           wb.println("    <Font x:Family=\"Swiss\" ss:Size=\"9\" ss:Bold=\"1\"/>");
          wb.println("    </Style>");
          wb.println("    <Style ss:ID=\"s87\">");
           wb.println("    <Borders>");
            wb.println("    <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\"/>");
            wb.println("    <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\"/>");
            wb.println("    <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\"/>");
           wb.println("    </Borders>");
           wb.println("    <Font x:Family=\"Swiss\" ss:Size=\"9\"/>");
          wb.println("    </Style>");
          wb.println("    <Style ss:ID=\"s88\">");
           wb.println("    <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
           wb.println("    <Borders>");
            wb.println("    <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\"/>");
            wb.println("    <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\"/>");
            wb.println("    <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\"/>");
           wb.println("    </Borders>");
           wb.println("    <Font x:Family=\"Swiss\" ss:Size=\"9\"/>");
          wb.println("    </Style>");
          wb.println("    <Style ss:ID=\"s89\" ss:Parent=\"s16\">");
           wb.println("    <Borders>");
            wb.println("    <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\"/>");
            wb.println("    <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\"/>");
            wb.println("    <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\"/>");
           wb.println("    </Borders>");
           wb.println("    <Font x:Family=\"Swiss\" ss:Size=\"9\"/>");
           wb.println("    <NumberFormat ss:Format=\"_(* #,##0_);_(* \\(#,##0\\);_(* &quot;-&quot;??_);_(@_)\"/>");
          wb.println("    </Style>");
          wb.println("    <Style ss:ID=\"s90\">");
           wb.println("    <Borders>");
            wb.println("    <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\"/>");
            wb.println("    <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\"/>");
            wb.println("    <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\"/>");
            wb.println("    <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\"/>");
           wb.println("    </Borders>");
           wb.println("    <Font x:Family=\"Swiss\" ss:Size=\"9\"/>");
          wb.println("    </Style>");
          wb.println("    <Style ss:ID=\"s91\">");
           wb.println("    <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
           wb.println("    <Borders>");
            wb.println("    <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\"/>");
            wb.println("    <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\"/>");
            wb.println("    <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\"/>");
            wb.println("    <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\"/>");
           wb.println("    </Borders>");
           wb.println("    <Font x:Family=\"Swiss\" ss:Size=\"9\"/>");
          wb.println("    </Style>");
          wb.println("    <Style ss:ID=\"s92\" ss:Parent=\"s16\">");
           wb.println("    <Borders>");
            wb.println("    <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\"/>");
            wb.println("    <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\"/>");
            wb.println("    <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\"/>");
            wb.println("    <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\"/>");
           wb.println("    </Borders>");
           wb.println("    <Font x:Family=\"Swiss\" ss:Size=\"9\"/>");
           wb.println("    <NumberFormat ss:Format=\"_(* #,##0_);_(* \\(#,##0\\);_(* &quot;-&quot;??_);_(@_)\"/>");
          wb.println("    </Style>");
          wb.println("    <Style ss:ID=\"s96\">");
           wb.println("    <Font x:Family=\"Swiss\" ss:Size=\"9\"/>");
          wb.println("    </Style>");
          wb.println("    <Style ss:ID=\"s97\">");
           wb.println("    <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
           wb.println("    <Font x:Family=\"Swiss\" ss:Size=\"9\"/>");
          wb.println("    </Style>");
          wb.println("    <Style ss:ID=\"s98\" ss:Parent=\"s16\">");
           wb.println("    <Alignment ss:Vertical=\"Center\"/>");
           wb.println("    <Borders>");
            wb.println("    <Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
            wb.println("    <Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
            wb.println("    <Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
            wb.println("    <Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
           wb.println("    </Borders>");
           wb.println("    <Font x:Family=\"Swiss\" ss:Size=\"9\" ss:Bold=\"1\"/>");
           wb.println("    <Interior/>");
           wb.println("    <NumberFormat ss:Format=\"_(* #,##0_);_(* \\(#,##0\\);_(* &quot;-&quot;??_);_(@_)\"/>");
          wb.println("    </Style>");
          wb.println("    <Style ss:ID=\"s101\">");
           wb.println("    <Font x:Family=\"Swiss\" ss:Size=\"12\" ss:Bold=\"1\"/>");
          wb.println("    </Style>");
         wb.println("    </Styles>");
         wb.println("   <Worksheet ss:Name=\"Rekap Saldo Anggota\">");
         wb.println("    <Table ss:ExpandedColumnCount=\"11\" x:FullColumns=\"1\"");
         wb.println("     x:FullRows=\"1\">");
         wb.println("     <Column ss:AutoFitWidth=\"0\" ss:Width=\"4.5\"/>");
         wb.println("     <Column ss:AutoFitWidth=\"0\" ss:Width=\"25.5\"/>");
         wb.println("     <Column ss:StyleID=\"s37\" ss:AutoFitWidth=\"0\" ss:Width=\"57.75\"/>");
         wb.println("     <Column ss:AutoFitWidth=\"0\" ss:Width=\"139.5\"/>");
         wb.println("     <Column ss:AutoFitWidth=\"0\" ss:Width=\"69\"/>");
         wb.println("     <Column ss:AutoFitWidth=\"0\" ss:Width=\"59.25\"/>");
         wb.println("     <Column ss:AutoFitWidth=\"0\" ss:Width=\"72.75\"/>");
         wb.println("     <Column ss:AutoFitWidth=\"0\" ss:Width=\"77.25\"/>");
         wb.println("     <Column ss:AutoFitWidth=\"0\" ss:Width=\"93\"/>");
         wb.println("     <Column ss:AutoFitWidth=\"0\" ss:Width=\"75\"/>");
         wb.println("     <Column ss:AutoFitWidth=\"0\" ss:Width=\"88.5\"/>");
           wb.println("   <Row ss:AutoFitHeight=\"0\" ss:Height=\"8.25\"/>");
           wb.println("   <Row ss:Height=\"15.75\">");
            wb.println("    <Cell ss:Index=\"2\" ss:StyleID=\"s101\"><Data ss:Type=\"String\">DAFTAR SALDO SIMPANAN ANGGOTA</Data></Cell>");
           wb.println("    </Row>");
           wb.println("   <Row ss:Height=\"15.75\">");
            wb.println("    <Cell ss:Index=\"2\" ss:StyleID=\"s101\"><Data ss:Type=\"String\">POSISI "+JSPFormater.formatDate(new Date(), "dd MMMM yyyy").toUpperCase()+"</Data></Cell>");
           wb.println("    </Row>");
           wb.println("    <Row>");
            wb.println("    <Cell ss:Index=\"2\" ss:StyleID=\"s21\"/>");
           wb.println("    </Row>");
           wb.println("   <Row ss:AutoFitHeight=\"0\" ss:Height=\"15.75\">");
            wb.println("    <Cell ss:Index=\"2\" ss:MergeDown=\"1\" ss:StyleID=\"s85\"><Data ss:Type=\"String\">NO</Data></Cell>");
            wb.println("    <Cell ss:MergeDown=\"1\" ss:StyleID=\"s85\"><Data ss:Type=\"String\">NIK</Data></Cell>");
            wb.println("    <Cell ss:MergeDown=\"1\" ss:StyleID=\"s85\"><Data ss:Type=\"String\">NAMA</Data></Cell>");
            wb.println("    <Cell ss:MergeDown=\"1\" ss:StyleID=\"s85\"><Data ss:Type=\"String\">DINAS</Data></Cell>");
            wb.println("    <Cell ss:MergeDown=\"1\" ss:StyleID=\"s85\"><Data ss:Type=\"String\">STATUS</Data></Cell>");
            wb.println("    <Cell ss:MergeAcross=\"3\" ss:StyleID=\"s85\"><Data ss:Type=\"String\">SALDO SIMPANAN</Data></Cell>");
            wb.println("    <Cell ss:MergeDown=\"1\" ss:StyleID=\"s85\"><Data ss:Type=\"String\">JUMLAH</Data></Cell>");
           wb.println("    </Row>");
           wb.println("   <Row ss:AutoFitHeight=\"0\" ss:Height=\"15\">");
            wb.println("    <Cell ss:Index=\"7\" ss:StyleID=\"s86\"><Data ss:Type=\"String\">POKOK</Data></Cell>");
            wb.println("    <Cell ss:StyleID=\"s86\"><Data ss:Type=\"String\">WAJIB</Data></Cell>");
            wb.println("    <Cell ss:StyleID=\"s86\"><Data ss:Type=\"String\">SHU/ALOKASI '08</Data></Cell>");
            wb.println("    <Cell ss:StyleID=\"s86\"><Data ss:Type=\"String\">SUKARELA</Data></Cell>");
           wb.println("    </Row>");
           
           if(vectorList!=null && vectorList.size()>0){
               for(int i=0; i<vectorList.size(); i++){
                   
                   ObjSaldoAnggota osa = (ObjSaldoAnggota)vectorList.get(i);
                   //header
                   if(osa.getType()==0){
                       wb.println("    <Row>");
                        wb.println("    <Cell ss:Index=\"2\" ss:MergeAcross=\"9\" ss:StyleID=\"m81144030\"><Data");
                        wb.println("      ss:Type=\"String\">"+osa.getNama()+"</Data></Cell>");
                       wb.println("    </Row>");
                   }
                   else if(osa.getType()==1){
                       wb.println("    <Row>");
                        wb.println("    <Cell ss:Index=\"2\" ss:StyleID=\"s87\"><Data ss:Type=\"Number\">"+osa.getNo()+"</Data></Cell>");
                        wb.println("    <Cell ss:StyleID=\"s88\"><Data ss:Type=\"Number\">"+osa.getNik()+"</Data></Cell>");
                        wb.println("    <Cell ss:StyleID=\"s87\"><Data ss:Type=\"String\">"+osa.getNama()+"</Data></Cell>");
                        wb.println("    <Cell ss:StyleID=\"s87\"><Data ss:Type=\"String\">"+osa.getDatel()+"</Data></Cell>");
                        wb.println("    <Cell ss:StyleID=\"s87\"><Data ss:Type=\"String\">"+DbMember.status[osa.getStatus()]+"</Data></Cell>");
                        wb.println("    <Cell ss:StyleID=\"s89\"><Data ss:Type=\"Number\">"+osa.getPokok()+"</Data></Cell>");
                        wb.println("    <Cell ss:StyleID=\"s89\"><Data ss:Type=\"Number\">"+osa.getWajib()+"</Data></Cell>");
                        wb.println("    <Cell ss:StyleID=\"s89\"><Data ss:Type=\"Number\">"+osa.getShu()+"</Data></Cell>");
                        wb.println("    <Cell ss:StyleID=\"s89\"><Data ss:Type=\"Number\">"+osa.getSukarela()+"</Data></Cell>");
                        wb.println("    <Cell ss:StyleID=\"s89\" ss:Formula=\"=RC[-4]+RC[-3]+RC[-2]+RC[-1]\"><Data");
                        wb.println("      ss:Type=\"Number\">0</Data></Cell>");
                       wb.println("    </Row>");
                   }
                   else{
                       wb.println("   <Row ss:AutoFitHeight=\"0\" ss:Height=\"18\">");
                        wb.println("    <Cell ss:Index=\"2\" ss:MergeAcross=\"4\" ss:StyleID=\"s86\"><Data ss:Type=\"String\"");
                        wb.println("      x:Ticked=\"1\">JUMLAH :</Data></Cell>");
                        wb.println("    <Cell ss:StyleID=\"s98\"><Data ss:Type=\"Number\">"+osa.getPokok()+"</Data></Cell>");
                        wb.println("    <Cell ss:StyleID=\"s98\"><Data ss:Type=\"Number\">"+osa.getWajib()+"</Data></Cell>");
                        wb.println("    <Cell ss:StyleID=\"s98\"><Data ss:Type=\"Number\">"+osa.getShu()+"</Data></Cell>");
                        wb.println("    <Cell ss:StyleID=\"s98\"><Data ss:Type=\"Number\">"+osa.getSukarela()+"</Data></Cell>");
                        wb.println("    <Cell ss:StyleID=\"s98\"><Data ss:Type=\"Number\">"+(osa.getPokok()+osa.getWajib()+osa.getShu()+osa.getSukarela())+"</Data></Cell>");
                       wb.println("    </Row>");
                   }
               }
           }
           
           /*wb.println("    <Row>");
            wb.println("    <Cell ss:Index=\"2\" ss:StyleID=\"s90\"><Data ss:Type=\"Number\">2</Data></Cell>");
            wb.println("    <Cell ss:StyleID=\"s91\"><Data ss:Type=\"Number\">800990</Data></Cell>");
            wb.println("    <Cell ss:StyleID=\"s90\"><Data ss:Type=\"String\">SSDF</Data></Cell>");
            wb.println("    <Cell ss:StyleID=\"s90\"><Data ss:Type=\"String\">DATEL</Data></Cell>");
            wb.println("    <Cell ss:StyleID=\"s90\"><Data ss:Type=\"String\">AFTIF</Data></Cell>");
            wb.println("    <Cell ss:StyleID=\"s92\"><Data ss:Type=\"Number\">10000</Data></Cell>");
            wb.println("    <Cell ss:StyleID=\"s92\"><Data ss:Type=\"Number\">100000</Data></Cell>");
            wb.println("    <Cell ss:StyleID=\"s92\"><Data ss:Type=\"Number\">100000</Data></Cell>");
            wb.println("    <Cell ss:StyleID=\"s92\"><Data ss:Type=\"Number\">100000</Data></Cell>");
            wb.println("    <Cell ss:StyleID=\"s92\" ss:Formula=\"=RC[-4]+RC[-3]+RC[-2]+RC[-1]\"><Data");
            wb.println("      ss:Type=\"Number\">310000</Data></Cell>");
           wb.println("    </Row>");
           
           wb.println("    <Row>");
            wb.println("    <Cell ss:Index=\"2\" ss:MergeAcross=\"9\" ss:StyleID=\"m81144030\"><Data");
            wb.println("      ss:Type=\"String\">DATEL</Data></Cell>");
           wb.println("    </Row>");
           wb.println("    <Row>");
            wb.println("    <Cell ss:Index=\"2\" ss:StyleID=\"s87\"><Data ss:Type=\"Number\">1</Data></Cell>");
            wb.println("    <Cell ss:StyleID=\"s88\"><Data ss:Type=\"Number\">800990</Data></Cell>");
            wb.println("    <Cell ss:StyleID=\"s87\"><Data ss:Type=\"String\">SSDF</Data></Cell>");
            wb.println("    <Cell ss:StyleID=\"s87\"><Data ss:Type=\"String\">DATEL</Data></Cell>");
            wb.println("    <Cell ss:StyleID=\"s87\"><Data ss:Type=\"String\">AFTIF</Data></Cell>");
            wb.println("    <Cell ss:StyleID=\"s89\"><Data ss:Type=\"Number\">10000</Data></Cell>");
            wb.println("    <Cell ss:StyleID=\"s89\"><Data ss:Type=\"Number\">100000</Data></Cell>");
            wb.println("    <Cell ss:StyleID=\"s89\"><Data ss:Type=\"Number\">100000</Data></Cell>");
            wb.println("    <Cell ss:StyleID=\"s89\"><Data ss:Type=\"Number\">100000</Data></Cell>");
            wb.println("    <Cell ss:StyleID=\"s89\" ss:Formula=\"=RC[-4]+RC[-3]+RC[-2]+RC[-1]\"><Data");
            wb.println("      ss:Type=\"Number\">310000</Data></Cell>");
           wb.println("    </Row>");
           wb.println("    <Row>");
            wb.println("    <Cell ss:Index=\"2\" ss:StyleID=\"s90\"><Data ss:Type=\"Number\">2</Data></Cell>");
            wb.println("    <Cell ss:StyleID=\"s91\"><Data ss:Type=\"Number\">800990</Data></Cell>");
            wb.println("    <Cell ss:StyleID=\"s90\"><Data ss:Type=\"String\">SSDF</Data></Cell>");
            wb.println("    <Cell ss:StyleID=\"s90\"><Data ss:Type=\"String\">DATEL</Data></Cell>");
            wb.println("    <Cell ss:StyleID=\"s90\"><Data ss:Type=\"String\">AFTIF</Data></Cell>");
            wb.println("    <Cell ss:StyleID=\"s92\"><Data ss:Type=\"Number\">10000</Data></Cell>");
            wb.println("    <Cell ss:StyleID=\"s92\"><Data ss:Type=\"Number\">100000</Data></Cell>");
            wb.println("    <Cell ss:StyleID=\"s92\"><Data ss:Type=\"Number\">100000</Data></Cell>");
            wb.println("    <Cell ss:StyleID=\"s92\"><Data ss:Type=\"Number\">100000</Data></Cell>");
            wb.println("    <Cell ss:StyleID=\"s92\" ss:Formula=\"=RC[-4]+RC[-3]+RC[-2]+RC[-1]\"><Data");
            wb.println("      ss:Type=\"Number\">310000</Data></Cell>");
           wb.println("    </Row>");
           wb.println("    <Row>");
            wb.println("    <Cell ss:Index=\"2\" ss:StyleID=\"s96\"/>");
            wb.println("    <Cell ss:StyleID=\"s97\"/>");
            wb.println("    <Cell ss:StyleID=\"s96\"/>");
            wb.println("    <Cell ss:StyleID=\"s96\"/>");
            wb.println("    <Cell ss:StyleID=\"s96\"/>");
            wb.println("    <Cell ss:StyleID=\"s96\"/>");
            wb.println("    <Cell ss:StyleID=\"s96\"/>");
            wb.println("    <Cell ss:StyleID=\"s96\"/>");
            wb.println("    <Cell ss:StyleID=\"s96\"/>");
            wb.println("    <Cell ss:StyleID=\"s96\"/>");
           wb.println("    </Row>");
           wb.println("   <Row ss:AutoFitHeight=\"0\" ss:Height=\"18\">");
            wb.println("    <Cell ss:Index=\"2\" ss:MergeAcross=\"4\" ss:StyleID=\"s86\"><Data ss:Type=\"String\"");
            wb.println("      x:Ticked=\"1\">JUMLAH :</Data></Cell>");
            wb.println("    <Cell ss:StyleID=\"s98\"><Data ss:Type=\"Number\">1000</Data></Cell>");
            wb.println("    <Cell ss:StyleID=\"s98\"><Data ss:Type=\"Number\">1000</Data></Cell>");
            wb.println("    <Cell ss:StyleID=\"s98\"><Data ss:Type=\"Number\">10000000</Data></Cell>");
            wb.println("    <Cell ss:StyleID=\"s98\"><Data ss:Type=\"Number\">1000000</Data></Cell>");
            wb.println("    <Cell ss:StyleID=\"s98\"><Data ss:Type=\"Number\">1000000</Data></Cell>");
           wb.println("    </Row>");
            */
          wb.println("    </Table>");
          wb.println("    <WorksheetOptions xmlns=\"urn:schemas-microsoft-com:office:excel\">");
          wb.println("     <Print>");
          wb.println("      <ValidPrinterInfo/>");
          wb.println("      <HorizontalResolution>600</HorizontalResolution>");
          wb.println("      <VerticalResolution>600</VerticalResolution>");
          wb.println("     </Print>");
          wb.println("     <Selected/>");
          wb.println("     <DoNotDisplayGridlines/>");
          wb.println("     <Panes>");
          wb.println("      <Pane>");
          wb.println("       <Number>3</Number>");
          wb.println("       <ActiveRow>24</ActiveRow>");
          wb.println("       <ActiveCol>8</ActiveCol>");
          wb.println("      </Pane>");
          wb.println("     </Panes>");
          wb.println("     <ProtectObjects>False</ProtectObjects>");
          wb.println("     <ProtectScenarios>False</ProtectScenarios>");
          wb.println("    </WorksheetOptions>");
         wb.println("    </Worksheet> ");        
        wb.println("    </Workbook>");

        
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

