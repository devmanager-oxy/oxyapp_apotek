
package com.project.ccs.report;

import com.project.ccs.posmaster.DbItemCategory;
import com.project.ccs.posmaster.DbItemGroup;
import com.project.ccs.posmaster.ItemCategory;
import com.project.ccs.posmaster.ItemGroup;
import com.project.ccs.session.SessCogsBySection;
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

import com.project.payroll.*;
import com.project.util.jsp.*;
import com.project.fms.session.*;
import com.project.fms.activity.*;
import com.project.general.*;
import com.project.util.DateCalc;
import com.project.util.JSPFormater;
import java.util.StringTokenizer;

public class RptSalesPromotionByGolPriceXLS extends HttpServlet {
    
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
        Vector rptParam = new Vector();
        String userName = "";
        String filter = "";
        
        
        Date startDate = new Date();
	Date endDate = new Date();
	String golPrice = "";
	String srcGroupCat = "";
	int sortBy = 0;
	int sortType = 0;
        long locationId = 0;
        
        String group = "";
        String category = "";
        String location = "";
        
        try{
            HttpSession session = request.getSession();
            rptParam = (Vector)session.getValue("REPORT_PROMO_GOL_PRICE");
            startDate = (Date)rptParam.get(0);
            endDate = (Date)rptParam.get(1);
            golPrice = (String)rptParam.get(2);
            srcGroupCat = (String)rptParam.get(3);
            sortBy = Integer.parseInt((String)rptParam.get(4));
            sortType = Integer.parseInt((String)rptParam.get(5));
            locationId = Long.parseLong((String)rptParam.get(6));
            
            result = SessCogsBySection.getSalesPromotionReport(0, 0, startDate, endDate, srcGroupCat, golPrice, locationId, sortBy, sortType);
            
            userName = (String)session.getValue("REPORT_PROMO_GOL_PRICE_USER");
            filter = (String)session.getValue("REPORT_PROMO_GOL_PRICE_FILTER");
            
            if(locationId!=0){
                Location loc = DbLocation.fetchExc(locationId);
                location = loc.getName();
            }
            else{
                location = "All Location";
            }
            
            if(srcGroupCat!=null && srcGroupCat.length()>0){
                StringTokenizer strTok = new StringTokenizer(srcGroupCat, ",");
                Vector temp = new Vector();
                while(strTok.hasMoreElements()){
                    temp.add((String)strTok.nextToken());
                }
                String grId = (String)temp.get(0);
                String ctId = (String)temp.get(1);

                if(!grId.equals("0")){
                    try{
                        ItemGroup ig = DbItemGroup.fetchExc(Long.parseLong(grId));
                        group = ig.getName();
                    }
                    catch(Exception e){
                        group = "Unidetified";
                    }
                }
                else{
                    group = "All Group";
                }

                if(!ctId.equals("0")){
                    try{
                        ItemCategory ic = DbItemCategory.fetchExc(Long.parseLong(ctId));
                        category = ic.getName();
                    }
                    catch(Exception e){
                        category = "Unidetified";
                    }
                }
                else{
                    category = "All Category";
                }

            }
        
        }catch(Exception e){
            System.out.println(e.toString());
        }
        
        boolean gzip = false ;
        
       // response.setCharacterEncoding( "UTF-8\\" ) ;
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
        wb.println("xmlns:o=\"urn:schemas-microsoft-com:office:office\" ");
        wb.println("xmlns:x=\"urn:schemas-microsoft-com:office:excel\" ");
        wb.println("xmlns:ss=\"urn:schemas-microsoft-com:office:spreadsheet\" ");
        wb.println("xmlns:html=\"http://www.w3.org/TR/REC-html40\">");
        wb.println("<DocumentProperties xmlns=\"urn:schemas-microsoft-com:office:office\">");
        wb.println("<Author>Eka D</Author>");
        wb.println("<LastAuthor>Eka D</LastAuthor>");
        wb.println("<Created>2014-09-05T08:01:06Z</Created>");
        wb.println("<LastSaved>2014-09-05T08:16:00Z</LastSaved>");
        wb.println("<Company>Toshiba</Company>");
        wb.println("<Version>14.00</Version>");
        wb.println("</DocumentProperties>");
        wb.println("<OfficeDocumentSettings xmlns=\"urn:schemas-microsoft-com:office:office\">");
        wb.println("<AllowPNG/>");
        wb.println("</OfficeDocumentSettings>");
        wb.println("<ExcelWorkbook xmlns=\"urn:schemas-microsoft-com:office:excel\">");
        wb.println("<WindowHeight>7995</WindowHeight>");
        wb.println("<WindowWidth>20115</WindowWidth>");
        wb.println("<WindowTopX>240</WindowTopX>");
        wb.println("<WindowTopY>75</WindowTopY>");
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
        wb.println("<Style ss:ID=\"m39768288\">");
        wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"9\" ss:Color=\"#000000\" "); 
        wb.println("ss:Bold=\"1\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"m99128008\">");
        wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Color=\"#000000\" ss:Bold=\"1\"/>");
        wb.println("<Interior ss:Color=\"#C5D9F1\" ss:Pattern=\"Solid\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"m99128028\">");
        wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Color=\"#000000\" ss:Bold=\"1\"/>");
        wb.println("<Interior ss:Color=\"#C5D9F1\" ss:Pattern=\"Solid\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s62\">");
        wb.println("<Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Color=\"#000000\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s80\">");
        wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Color=\"#000000\" ss:Bold=\"1\"/>");
        wb.println("<Interior ss:Color=\"#C5D9F1\" ss:Pattern=\"Solid\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s91\">");
        wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("<Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Color=\"#000000\" ss:Bold=\"1\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s92\">");
        wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Color=\"#000000\" ss:Bold=\"1\"/>");
        wb.println("<Interior ss:Color=\"#C5D9F1\" ss:Pattern=\"Solid\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s109\">");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"9\" ss:Color=\"#000000\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s110\">");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"9\" ss:Color=\"#000000\"/>");
        wb.println("<NumberFormat ss:Format=\"Short Date\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s111\" ss:Parent=\"s16\">");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"9\" ss:Color=\"#000000\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s112\">");
        wb.println("<Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"9\" ss:Color=\"#000000\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s116\" ss:Parent=\"s16\">");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"9\" ss:Color=\"#000000\" ");
        wb.println("ss:Bold=\"1\"/>");
        wb.println("</Style>");
        wb.println("</Styles>");
        wb.println("<Worksheet ss:Name=\"Sheet1\">");
        wb.println("<Table ss:ExpandedColumnCount=\"12\" x:FullColumns=\"1\" ");
        wb.println("x:FullRows=\"1\" ss:StyleID=\"s62\">");
        wb.println("<Column ss:StyleID=\"s62\" ss:AutoFitWidth=\"0\" ss:Width=\"42.75\"/>");
        wb.println("<Column ss:StyleID=\"s62\" ss:AutoFitWidth=\"0\" ss:Width=\"139.5\"/>");
        wb.println("<Column ss:StyleID=\"s62\" ss:AutoFitWidth=\"0\" ss:Width=\"69\"/>");
        wb.println("<Column ss:StyleID=\"s62\" ss:AutoFitWidth=\"0\" ss:Width=\"62.25\"/>");
        wb.println("<Column ss:StyleID=\"s62\" ss:AutoFitWidth=\"0\" ss:Width=\"57\"/>");
        wb.println("<Column ss:StyleID=\"s62\" ss:AutoFitWidth=\"0\" ss:Width=\"78.75\" ss:Span=\"1\"/>");
        wb.println("<Column ss:Index=\"8\" ss:StyleID=\"s62\" ss:AutoFitWidth=\"0\" ss:Width=\"54.75\"/>");
        wb.println("<Column ss:StyleID=\"s62\" ss:AutoFitWidth=\"0\" ss:Width=\"78.75\" ss:Span=\"1\"/>");
        wb.println("<Column ss:Index=\"11\" ss:StyleID=\"s62\" ss:AutoFitWidth=\"0\" ss:Width=\"40.5\"/>");
        wb.println("<Column ss:StyleID=\"s62\" ss:AutoFitWidth=\"0\" ss:Width=\"78.75\"/>");
        wb.println("<Row>");
        wb.println("<Cell ss:MergeAcross=\"11\" ss:StyleID=\"s91\"><Data ss:Type=\"String\">"+cmp.getName().toUpperCase()+"</Data></Cell>");
        wb.println("</Row>");
        wb.println("<Row>");
        wb.println("<Cell ss:MergeAcross=\"11\" ss:StyleID=\"s91\"><Data ss:Type=\"String\">PROMOTION SALES REPORT</Data></Cell>");
        wb.println("</Row>");
        wb.println("<Row>");
        wb.println("<Cell ss:MergeAcross=\"11\" ss:StyleID=\"s91\"><Data ss:Type=\"String\">Promotion Period "+JSPFormater.formatDate(startDate, "dd-MM-yyyy")+" / "+JSPFormater.formatDate(endDate, "dd-MM-yyyy")+"</Data></Cell>");
        wb.println("</Row>");
        wb.println("<Row>");
        wb.println("<Cell><Data ss:Type=\"String\">Print date : "+JSPFormater.formatDate(new Date(), "dd-MM-yyyy")+", by : "+userName+"</Data></Cell>");
        wb.println("</Row>");
        wb.println("<Row>");
        wb.println("<Cell><Data ss:Type=\"String\">"+location+" / "+golPrice+" / "+group+" / "+category+"</Data></Cell>");
        wb.println("</Row>");
        wb.println("<Row ss:StyleID=\"s91\">");
        wb.println("<Cell ss:Index=\"3\" ss:MergeAcross=\"1\" ss:StyleID=\"s80\"><Data ss:Type=\"String\">Promotion Period</Data></Cell>");
        wb.println("<Cell ss:MergeAcross=\"1\" ss:StyleID=\"s80\"><Data ss:Type=\"String\">Promotion</Data></Cell>");
        wb.println("<Cell ss:Index=\"8\" ss:MergeAcross=\"1\" ss:StyleID=\"m99128008\"><Data ss:Type=\"String\">Sales Promotion</Data></Cell>");
        wb.println("<Cell ss:Index=\"11\" ss:MergeAcross=\"1\" ss:StyleID=\"m99128028\"><Data ss:Type=\"String\">Stock</Data></Cell>");
        wb.println("</Row>");
        wb.println("<Row ss:StyleID=\"s91\">");
        wb.println("<Cell ss:StyleID=\"s92\"><Data ss:Type=\"String\">SKU</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s92\"><Data ss:Type=\"String\">Item</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s92\"><Data ss:Type=\"String\">Start Date</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s92\"><Data ss:Type=\"String\">End Date</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s92\"><Data ss:Type=\"String\">Cogs</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s92\"><Data ss:Type=\"String\">Selling Price</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s92\"><Data ss:Type=\"String\">Margin</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s92\"><Data ss:Type=\"String\">Qty</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s92\"><Data ss:Type=\"String\">Amount</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s92\"><Data ss:Type=\"String\">Profit</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s92\"><Data ss:Type=\"String\">Qty</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s92\"><Data ss:Type=\"String\">Amount</Data></Cell>");
        wb.println("</Row>");
        
        if(result!=null && result.size()>0){
        
            for(int i=0; i<result.size(); i++){ 
            
                Vector v = (Vector)result.get(i);
                String sku = (String)v.get(1);
                String itemName = (String)v.get(3);
                double cogs = Double.parseDouble((String)v.get(4));
                double lastPrice = Double.parseDouble((String)v.get(11));
                double selingPrice = Double.parseDouble((String)v.get(12));
                double margin = (lastPrice>0) ? ((selingPrice-cogs)/cogs)*100 : 0;
                double stock = Double.parseDouble((String)v.get(14));
                double stockAmount = stock * cogs;
                Date stDate = JSPFormater.formatDate((String)v.get(7),"yyyy-MM-dd");
                Date enDate = JSPFormater.formatDate((String)v.get(8),"yyyy-MM-dd");
                double qty = Double.parseDouble((String)v.get(5));
                double omset = Double.parseDouble((String)v.get(6));
                double hpp = Double.parseDouble((String)v.get(16));

                selingPrice = omset/qty;
            
                wb.println("<Row ss:Height=\"12\" ss:StyleID=\"s112\">");
                wb.println("<Cell ss:StyleID=\"s109\"><Data ss:Type=\"String\">"+sku+"</Data></Cell>");
                wb.println("<Cell ss:StyleID=\"s109\"><Data ss:Type=\"String\">"+itemName+"</Data></Cell>");
                wb.println("<Cell ss:StyleID=\"s110\"><Data ss:Type=\"String\">"+JSPFormater.formatDate(stDate,"dd-MM-yyyy")+"</Data></Cell>");
                wb.println("<Cell ss:StyleID=\"s110\"><Data ss:Type=\"String\">"+JSPFormater.formatDate(enDate,"dd-MM-yyyy")+"</Data></Cell>");
                wb.println("<Cell ss:StyleID=\"s111\"><Data ss:Type=\"Number\">"+cogs+"</Data></Cell>");
                wb.println("<Cell ss:StyleID=\"s111\"><Data ss:Type=\"Number\">"+selingPrice+"</Data></Cell>");
                wb.println("<Cell ss:StyleID=\"s111\"><Data ss:Type=\"Number\">"+(((selingPrice-cogs)/cogs)*100)+"</Data></Cell>");
                wb.println("<Cell ss:StyleID=\"s111\"><Data ss:Type=\"Number\">"+qty+"</Data></Cell>");
                wb.println("<Cell ss:StyleID=\"s111\"><Data ss:Type=\"Number\">"+omset+"</Data></Cell>");
                wb.println("<Cell ss:StyleID=\"s111\"><Data ss:Type=\"Number\">"+(omset-(hpp))+"</Data></Cell>");
                wb.println("<Cell ss:StyleID=\"s111\"><Data ss:Type=\"Number\">"+stock+"</Data></Cell>");
                wb.println("<Cell ss:StyleID=\"s111\"><Data ss:Type=\"Number\">"+stockAmount+"</Data></Cell>");
                wb.println("</Row>");
                
            }
        }
        
        //wb.println("<Row ss:Height=\"12\" ss:StyleID=\"s112\">");
        //wb.println("<Cell ss:MergeAcross=\"3\" ss:StyleID=\"m39768288\"><Data ss:Type=\"String\">T O T A L</Data></Cell>");
        //wb.println("<Cell ss:StyleID=\"s116\"><Data ss:Type=\"Number\">10</Data></Cell>");
        //wb.println("<Cell ss:StyleID=\"s116\"><Data ss:Type=\"Number\">10</Data></Cell>");
        //wb.println("<Cell ss:StyleID=\"s116\"><Data ss:Type=\"Number\">10</Data></Cell>");
        //wb.println("<Cell ss:StyleID=\"s116\"><Data ss:Type=\"Number\">10</Data></Cell>");
        //wb.println("<Cell ss:StyleID=\"s116\"><Data ss:Type=\"Number\">10</Data></Cell>");
        //wb.println("<Cell ss:StyleID=\"s116\"><Data ss:Type=\"Number\">10</Data></Cell>");
        //wb.println("<Cell ss:StyleID=\"s116\"><Data ss:Type=\"Number\">10</Data></Cell>");
        //wb.println("<Cell ss:StyleID=\"s116\"><Data ss:Type=\"Number\">10</Data></Cell>");
        //wb.println("</Row>");
        wb.println("</Table>");
        wb.println("<WorksheetOptions xmlns=\"urn:schemas-microsoft-com:office:excel\">");
        wb.println("<PageSetup>");
        wb.println("<Header x:Margin=\"0.3\"/>");
        wb.println("<Footer x:Margin=\"0.3\"/>");
        wb.println("<PageMargins x:Bottom=\"0.75\" x:Left=\"0.7\" x:Right=\"0.7\" x:Top=\"0.75\"/>");
        wb.println("</PageSetup>");
        wb.println("<Print>");
        wb.println("<ValidPrinterInfo/>");
        wb.println("<PaperSizeIndex>9</PaperSizeIndex>");
        wb.println("<VerticalResolution>0</VerticalResolution>");
        wb.println("</Print>");
        wb.println("<Selected/>");
        wb.println("<Panes>");
        wb.println("<Pane>");
        wb.println("<Number>3</Number>");
        wb.println("<ActiveRow>15</ActiveRow>");
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
