/*
 * Report Donor to IFC by Group XLS.java
 *
 * Created on March 30, 2008, 1:33 AM
 */

package com.project.ccs.report;

import com.project.ccs.posmaster.ItemMaster;
import com.project.ccs.session.SessStockReportView;
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
//import com.project.fms.master.*;
import com.project.payroll.*;
import com.project.util.jsp.*;
import com.project.fms.session.*;
import com.project.fms.activity.*;
import com.project.general.*;
import java.util.Hashtable;

public class RptStockTotalLocationXLS extends HttpServlet {
    
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
        
        Company cmp = new Company();
        try{
            Vector listCompany = DbCompany.list(0,0, "", "");
            if(listCompany!=null && listCompany.size()>0){
                cmp = (Company)listCompany.get(0);
            }
        }catch(Exception ext){
            System.out.println(ext.toString());
        }
        
        Vector result = new Vector();
        String userName = "";
        String filter = "";
        Vector temp = new Vector();
        Vector locations = DbLocation.list(0,0, "", "name");
        
        try{
            HttpSession session = request.getSession();
            
            temp = (Vector)session.getValue("REPORT_STOCK");
            userName = (String)session.getValue("REPORT_STOCK_USER");
            filter = (String)session.getValue("REPORT_STOCK_FILTER");
            
            String srcCode = (String)temp.get(0);
            String srcName = (String)temp.get(1);
            int orderBy = Integer.parseInt((String)temp.get(2));
            int orderType = Integer.parseInt((String)temp.get(3));
            int supZero = Integer.parseInt((String)temp.get(4));
            
            String whereClause = "";
            String orderClause = "";

            if(srcCode!=null && srcCode.length()>0){
                    whereClause = " code like '%"+srcCode+"%'"; 
            }
            if(srcName!=null && srcName.length()>0){
                    if(whereClause!=null && whereClause.length()>0){
                            whereClause = whereClause + " and ";		
                    }
                    whereClause = whereClause + " name like '%"+srcName+"%'";
            }

            if(supZero==1){
                    if(whereClause!=null && whereClause.length()>0){
                            whereClause = whereClause + " and ";		
                    }
                    whereClause = whereClause + " qtystock <> 0";
            }

            if(orderBy==0){
                    orderClause = " name";
            }
            else if(orderBy==1){
                    orderClause = " code";
            }
            else{
                    orderClause = " qtystock";
            }

            if(orderType==1){
                    orderClause = orderClause + " desc";
            }
            
            
            result = SessStockReportView.getStockItemList(0, 0, whereClause, orderClause);

            
        }catch(Exception e){
            System.out.println(e.toString());
        }
        
        boolean gzip = false ;
        
       // response.setCharacterEncoding( "UTF-8" ) ;
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
        wb.println("<Workbook xmlns=\"urn:schemas-microsoft-com:office:spreadsheet\" ");
        wb.println(" xmlns:o=\"urn:schemas-microsoft-com:office:office\" ");
        wb.println(" xmlns:x=\"urn:schemas-microsoft-com:office:excel\" ");
        wb.println(" xmlns:ss=\"urn:schemas-microsoft-com:office:spreadsheet\" ");
        wb.println(" xmlns:html=\"http://www.w3.org/TR/REC-html40\">");
        wb.println("<DocumentProperties xmlns=\"urn:schemas-microsoft-com:office:office\">");
        wb.println(" <Author>Eka D</Author>");
        wb.println("<LastAuthor>Eka D</LastAuthor>");
        wb.println("<Created>2014-09-10T15:22:44Z</Created>");
        wb.println("<Company>Toshiba</Company>");
        wb.println("<Version>14.00</Version>");
        wb.println("</DocumentProperties>");
        wb.println("<OfficeDocumentSettings xmlns=\"urn:schemas-microsoft-com:office:office\">");
        wb.println("<AllowPNG/>");
        wb.println("</OfficeDocumentSettings>");
        wb.println("<ExcelWorkbook xmlns=\"urn:schemas-microsoft-com:office:excel\">");
        wb.println("<WindowHeight>5190</WindowHeight>");
        wb.println("<WindowWidth>13395</WindowWidth>");
        wb.println("<WindowTopX>0</WindowTopX>");
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
        wb.println("<Style ss:ID=\"s16\" ss:Name=\"Comma\">");
        wb.println("<NumberFormat ss:Format=\"_(* #,##0.00_);_(* \\(#,##0.00\\);_(* &quot;-&quot;??_);_(@_)\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s62\">");
        wb.println("<Interior/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s64\" ss:Parent=\"s16\">");
        wb.println("<Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"/>");
        wb.println("<Interior/>");
        wb.println("<NumberFormat ss:Format=\"_(* #,##0_);_(* \\(#,##0\\);_(* &quot;-&quot;??_);_(@_)\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s66\">");
        wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("<Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"12\" ss:Color=\"#000000\" ");
        wb.println(" ss:Bold=\"1\"/>");
        wb.println("<Interior/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s67\">");
        wb.println("<Borders/>");
        wb.println("<Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\"/>");
        wb.println("<Interior/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s69\">");
        wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\" ss:WrapText=\"1\"/>");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font ss:FontName=\"Tahoma\" x:Family=\"Swiss\" ss:Size=\"8\" ss:Bold=\"1\"/>");
        wb.println("<Interior/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s71\" ss:Parent=\"s16\">");
        wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\" ss:WrapText=\"1\"/>");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font ss:FontName=\"Tahoma\" x:Family=\"Swiss\" ss:Size=\"8\" ss:Bold=\"1\"/>");
        wb.println("<Interior/>");
        wb.println("<NumberFormat ss:Format=\"_(* #,##0_);_(* \\(#,##0\\);_(* &quot;-&quot;??_);_(@_)\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s72\" ss:Parent=\"s16\">");
        wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\" ss:WrapText=\"1\"/>");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font ss:FontName=\"Tahoma\" x:Family=\"Swiss\" ss:Size=\"7.5\" ss:Bold=\"1\"/>");
        wb.println("<Interior/>");
        wb.println("<NumberFormat ss:Format=\"_(* #,##0_);_(* \\(#,##0\\);_(* &quot;-&quot;??_);_(@_)\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s73\">");
        wb.println("<Borders/>");
        wb.println("<Interior/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s75\">");
        wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\" ss:WrapText=\"1\"/>");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font ss:FontName=\"Tahoma\" x:Family=\"Swiss\" ss:Size=\"7.5\" ss:Color=\"#333333\"/>");
        wb.println("<Interior/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s76\">");
        wb.println("<Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Center\" ss:Indent=\"1\"/>");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font ss:FontName=\"Tahoma\" x:Family=\"Swiss\" ss:Size=\"7.5\" ss:Color=\"#333333\"/>");
        wb.println("<Interior/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s77\" ss:Parent=\"s16\">");
        wb.println("<Alignment ss:Horizontal=\"Right\" ss:Vertical=\"Center\" ss:Indent=\"1\" ss:WrapText=\"1\"/>");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font ss:FontName=\"Tahoma\" x:Family=\"Swiss\" ss:Size=\"7.5\" ss:Color=\"#333333\"/>");
        wb.println("<Interior/>");
        wb.println("<NumberFormat ss:Format=\"_(* #,##0_);_(* \\(#,##0\\);_(* &quot;-&quot;??_);_(@_)\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s78\">");
        wb.println("<Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\" ss:Bold=\"1\"/>");
        wb.println("<Interior/>");
        wb.println("</Style>");
        wb.println("</Styles>");
        wb.println("<Worksheet ss:Name=\"Stock Total\">");
        wb.println("<Table x:FullColumns=\"1\" x:FullRows=\"1\" ss:StyleID=\"s62\" ss:DefaultRowHeight=\"15\">");
        wb.println("<Column ss:StyleID=\"s62\" ss:AutoFitWidth=\"0\" ss:Width=\"29.25\"/>");
        wb.println("<Column ss:StyleID=\"s62\" ss:AutoFitWidth=\"0\" ss:Width=\"63\"/>");
        wb.println("<Column ss:StyleID=\"s62\" ss:Width=\"180\"/>");
        wb.println("<Column ss:StyleID=\"s64\" ss:AutoFitWidth=\"0\" ss:Span=\"9\"/>");
        wb.println("<Column ss:Index=\"14\" ss:StyleID=\"s64\" ss:Width=\"49.5\"/>");
        wb.println("<Row ss:AutoFitHeight=\"0\" ss:Height=\"15.75\">");
        wb.println("<Cell ss:MergeAcross=\""+(((locations!=null && locations.size()>0) ? locations.size() : 0)+3)+"\" ss:StyleID=\"s66\"><Data ss:Type=\"String\">"+cmp.getName().toUpperCase()+"</Data></Cell>");
        wb.println("</Row>");
        wb.println("<Row ss:AutoFitHeight=\"0\" ss:Height=\"15.75\">");
        wb.println("<Cell ss:MergeAcross=\""+(((locations!=null && locations.size()>0) ? locations.size() : 0)+3)+"\" ss:StyleID=\"s66\"><Data ss:Type=\"String\">STOCK TOTAL BY LOCATION REPORT</Data></Cell>");
        wb.println("</Row>");
        wb.println("<Row ss:Index=\"4\" ss:AutoFitHeight=\"0\">");
        wb.println("<Cell ss:StyleID=\"s78\"><Data ss:Type=\"String\">Date : "+JSPFormater.formatDate(new Date(), "dd/MM/yyyy")+", by : "+userName+"</Data></Cell>");
        wb.println("</Row>");
        wb.println("<Row ss:AutoFitHeight=\"0\">");
        wb.println("<Cell ss:StyleID=\"s78\"><Data ss:Type=\"String\">"+filter+"</Data></Cell>");
        wb.println("</Row>");
        wb.println("<Row ss:AutoFitHeight=\"0\" ss:Height=\"42\" ss:StyleID=\"s67\">");
        wb.println("<Cell ss:StyleID=\"s69\"><Data ss:Type=\"String\">NO</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s69\"><Data ss:Type=\"String\">CODE</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s69\"><Data ss:Type=\"String\">ITEM NAME</Data></Cell>");
        if(locations!=null && locations.size()>0){
             for(int i=0; i<locations.size(); i++){
                 Location d = (Location)locations.get(i);
                 wb.println("<Cell ss:StyleID=\"s71\"><Data ss:Type=\"String\">"+d.getName()+"</Data></Cell>");
             }
        }
        //wb.println("<Cell ss:StyleID=\"s71\"><Data ss:Type=\"String\">Coco Mart Bandara R19</Data></Cell>");
        //wb.println("<Cell ss:StyleID=\"s71\"><Data ss:Type=\"String\">Coco Mart Bandara R22</Data></Cell>");
        //wb.println("<Cell ss:StyleID=\"s71\"><Data ss:Type=\"String\">Coco Mart Bandara R28</Data></Cell>");
        //wb.println("<Cell ss:StyleID=\"s71\"><Data ss:Type=\"String\">Coco Mart Blahkiuh</Data></Cell>");
        //wb.println("<Cell ss:StyleID=\"s71\"><Data ss:Type=\"String\">Coco Mart Mas Ubud</Data></Cell>");
        //wb.println("<Cell ss:StyleID=\"s71\"><Data ss:Type=\"String\">DC1</Data></Cell>");
        //wb.println("<Cell ss:StyleID=\"s71\"><Data ss:Type=\"String\">Gudang Costing</Data></Cell>");
        //wb.println("<Cell ss:StyleID=\"s71\"><Data ss:Type=\"String\">Gudang Retur</Data></Cell>");
        //wb.println("<Cell ss:StyleID=\"s71\"><Data ss:Type=\"String\">xxx</Data></Cell>");
        //wb.println("<Cell ss:StyleID=\"s71\"><Data ss:Type=\"String\">xxx</Data></Cell>");
        //wb.println("<Cell ss:StyleID=\"s71\"><Data ss:Type=\"String\">xxx</Data></Cell>");
        //wb.println("<Cell ss:StyleID=\"s71\"><Data ss:Type=\"String\">Office</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s72\"><Data ss:Type=\"String\">TOTAL</Data></Cell>");
        wb.println("</Row>");
        
        String wherex = "(";
        if(locations!=null && locations.size()>0){
             for(int i=0; i<locations.size(); i++){
                     Location d = (Location)locations.get(i);
                     wherex = wherex +" location_id="+d.getOID()+" or";
             }
             
             wherex = wherex.substring(0,wherex.length()-3)+")";
        }
        
        if(result!=null && result.size()>0){
            
            Hashtable hashQty = SessStockReportView.getStockByLocationByItem();//im.getOID(), wherex);    
            
            for(int x=0; x<result.size(); x++){
                
                System.out.println("- processing line : "+x);
                
                ItemMaster im = (ItemMaster)result.get(x);
                double totAv = 0;
                double totOtw = 0;
                double totSlp = 0;
                double tot = 0;
                wb.println("<Row ss:AutoFitHeight=\"0\" ss:StyleID=\"s73\">");
                wb.println("<Cell ss:StyleID=\"s75\"><Data ss:Type=\"Number\">"+(x+1)+"</Data></Cell>");
                wb.println("<Cell ss:StyleID=\"s76\"><Data ss:Type=\"String\">"+im.getCode()+"</Data></Cell>");
                wb.println("<Cell ss:StyleID=\"s76\"><Data ss:Type=\"String\">"+im.getName()+"</Data></Cell>");
                
                //Hashtable hashQty = SessStockReportView.getStockByLocationByItem();//im.getOID(), wherex);
                
                if(locations!=null && locations.size()>0){
                     for(int i=0; i<locations.size(); i++){
                             Location d = (Location)locations.get(i);
                             double qty = 0;
                             if((String)hashQty.get(im.getOID()+""+d.getOID())!=null && ((String)hashQty.get(im.getOID()+""+d.getOID())).length()>0){
                                 qty = Double.parseDouble((String)hashQty.get(im.getOID()+""+d.getOID()));
                             }
                             //SessStockReportView.getStockByLocationByItem(im.getOID(), d.getOID(), "APPROVED");
                             double qtyOtw = 0;//SessStockReportView.getStockByLocationByItem(im.getOID(), d.getOID(), "DRAFT");
                             double qtySlp = 0;
                             //if(displayPending){
                             //       qtySlp = 0;//SessStockReportView.getSalesPendingLocationByItem(im.getOID(), d.getOID());
                             //}

                             //if(qtyOtw < 0){
                             //       qtyOtw = qtyOtw * -1;
                             //}

                             //qty = qty - qtyOtw - qtySlp;

                             totAv = totAv + qty;
                             //totOtw = totOtw + qtyOtw;
                             //totSlp = totSlp + qtySlp;
                             //tot = tot + qty + qtyOtw + qtySlp;
                
                             wb.println("<Cell ss:StyleID=\"s77\"><Data ss:Type=\"Number\">"+qty+"</Data></Cell>");
                     }
                }
                
                /*wb.println("<Cell ss:StyleID=\"s77\"><Data ss:Type=\"Number\">0</Data></Cell>");
                wb.println("<Cell ss:StyleID=\"s77\"><Data ss:Type=\"Number\">0</Data></Cell>");
                wb.println("<Cell ss:StyleID=\"s77\"><Data ss:Type=\"Number\">0</Data></Cell>");
                wb.println("<Cell ss:StyleID=\"s77\"><Data ss:Type=\"Number\">0</Data></Cell>");
                wb.println("<Cell ss:StyleID=\"s77\"><Data ss:Type=\"Number\">12345</Data></Cell>");
                wb.println("<Cell ss:StyleID=\"s77\"><Data ss:Type=\"Number\">24</Data></Cell>");
                wb.println("<Cell ss:StyleID=\"s77\"><Data ss:Type=\"Number\">0</Data></Cell>");
                wb.println("<Cell ss:StyleID=\"s77\"><Data ss:Type=\"Number\">0</Data></Cell>");
                wb.println("<Cell ss:StyleID=\"s77\"><Data ss:Type=\"Number\">0</Data></Cell>");
                wb.println("<Cell ss:StyleID=\"s77\"><Data ss:Type=\"Number\">0</Data></Cell>");
                wb.println("<Cell ss:StyleID=\"s77\"><Data ss:Type=\"Number\">0</Data></Cell>");
                wb.println("<Cell ss:StyleID=\"s77\"><Data ss:Type=\"Number\">0</Data></Cell>");
                 */ 
                wb.println("<Cell ss:StyleID=\"s77\"><Data ss:Type=\"Number\">"+(totAv + totOtw +totSlp)+"</Data></Cell>");
                wb.println("</Row>");
                
                wb.flush() ;
            }
        }
        
        wb.println("</Table>");
        wb.println("<WorksheetOptions xmlns=\"urn:schemas-microsoft-com:office:excel\">");
        wb.println("<PageSetup>");
        wb.println("<Header x:Margin=\"0.3\"/>");
        wb.println("<Footer x:Margin=\"0.3\"/>");
        wb.println("<PageMargins x:Bottom=\"0.75\" x:Left=\"0.7\" x:Right=\"0.7\" x:Top=\"0.75\"/>");
        wb.println("</PageSetup>");
        wb.println("<Unsynced/>");
        wb.println("<Print>");
        wb.println("<ValidPrinterInfo/>");
        wb.println("<PaperSizeIndex>9</PaperSizeIndex>");
        wb.println("<VerticalResolution>0</VerticalResolution>");
        wb.println("</Print>");
        wb.println("<Selected/>");
        wb.println("<Panes>");
        wb.println("<Pane>");
        wb.println("<Number>3</Number>");
        wb.println("<ActiveRow>13</ActiveRow>");
        wb.println("<ActiveCol>2</ActiveCol>");
        wb.println("</Pane>");
        wb.println("</Panes>");
        wb.println("<ProtectObjects>False</ProtectObjects>");
        wb.println("<ProtectScenarios>False</ProtectScenarios>");
        wb.println("</WorksheetOptions>");
        wb.println("</Worksheet>");
        wb.println("<Worksheet ss:Name=\"Sheet2\">");
        wb.println("<Table ss:ExpandedColumnCount=\"1\" ss:ExpandedRowCount=\"1\" x:FullColumns=\"1\" ");
        wb.println(" x:FullRows=\"1\" ss:DefaultRowHeight=\"15\">");
        wb.println("<Row ss:AutoFitHeight=\"0\"/>");
        wb.println("</Table>");
        wb.println("<WorksheetOptions xmlns=\"urn:schemas-microsoft-com:office:excel\">");
        wb.println("<PageSetup>");
        wb.println("<Header x:Margin=\"0.3\"/>");
        wb.println("<Footer x:Margin=\"0.3\"/>");
        wb.println("<PageMargins x:Bottom=\"0.75\" x:Left=\"0.7\" x:Right=\"0.7\" x:Top=\"0.75\"/>");
        wb.println("</PageSetup>");
        wb.println("<Unsynced/>");
        wb.println("<ProtectObjects>False</ProtectObjects>");
        wb.println("<ProtectScenarios>False</ProtectScenarios>");
        wb.println("</WorksheetOptions>");
        wb.println("</Worksheet>");
        wb.println("<Worksheet ss:Name=\"Sheet3\">");
        wb.println("<Table ss:ExpandedColumnCount=\"1\" ss:ExpandedRowCount=\"1\" x:FullColumns=\"1\"");
        wb.println(" x:FullRows=\"1\" ss:DefaultRowHeight=\"15\">");
        wb.println("<Row ss:AutoFitHeight=\"0\"/>");
        wb.println("</Table>");
        wb.println("<WorksheetOptions xmlns=\"urn:schemas-microsoft-com:office:excel\">");
        wb.println("<PageSetup>");
        wb.println("<Header x:Margin=\"0.3\"/>");
        wb.println("<Footer x:Margin=\"0.3\"/>");
        wb.println("<PageMargins x:Bottom=\"0.75\" x:Left=\"0.7\" x:Right=\"0.7\" x:Top=\"0.75\"/>");
        wb.println("</PageSetup>");
        wb.println("<Unsynced/>");
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
