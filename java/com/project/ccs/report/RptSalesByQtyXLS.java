/*
 * Report Donor to IFC by Group XLS.java
 *
 * Created on March 30, 2008, 1:33 AM
 */

package com.project.ccs.report;


import com.project.ccs.posmaster.DbItemCategory;
import com.project.ccs.posmaster.DbItemGroup;
import com.project.ccs.posmaster.DbItemMaster;
import com.project.ccs.posmaster.ItemCategory;
import com.project.ccs.posmaster.ItemGroup;
import com.project.ccs.posmaster.ItemMaster;
import com.project.ccs.session.ReportParameter;
import com.project.ccs.session.SessReportSales;
import java.io.PrintWriter;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.util.zip.GZIPOutputStream;
import java.util.Vector;
import java.net.URLEncoder;

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

public class RptSalesByQtyXLS extends HttpServlet {
    
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
        
        
        ReportParameter rp = new ReportParameter();
        String wherClause="";
        try{
            HttpSession session = request.getSession();
            rp = (ReportParameter)session.getValue("REPORT_SALES_QTY");
            wherClause = (String)session.getValue("REPORT_SALES_QTY_DETAIL");
        }catch(Exception ex){
            System.out.println(ex.toString());
        }
        
        Vector vDetail = new Vector();
        vDetail = DbItemMaster.list(0, 0, wherClause, "item_category_id");
           
        
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
        wb.println("<LastAuthor>Victor</LastAuthor>");
        wb.println("<LastPrinted>2009-07-21T06:26:34Z</LastPrinted>");
        wb.println("<Created>1996-10-14T23:33:28Z</Created>");
        wb.println("<LastSaved>2009-07-21T06:27:07Z</LastSaved>");
        wb.println("<Version>11.5606</Version>");
        wb.println("</DocumentProperties>");
        wb.println("<ExcelWorkbook xmlns=\"urn:schemas-microsoft-com:office:excel\">");
        wb.println("<WindowHeight>9300</WindowHeight>");
        wb.println("<WindowWidth>15135</WindowWidth>");
        wb.println("<WindowTopX>120</WindowTopX>");
        wb.println("<WindowTopY>120</WindowTopY>");
        wb.println("<AcceptLabelsInFormulas/>");
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
        wb.println("<Style ss:ID=\"m25175768\">");
        wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font x:Family=\"Swiss\" ss:Size=\"8\" ss:Bold=\"1\"/>");
        wb.println("<Interior ss:Color=\"#FFFF99\" ss:Pattern=\"Solid\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s21\">");
        wb.println("<Borders/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s22\">");
        wb.println("<Alignment ss:Vertical=\"Bottom\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s23\">");
        wb.println("<Alignment ss:Vertical=\"Center\" ss:WrapText=\"1\"/>");
        wb.println("<Font x:Family=\"Swiss\" ss:Size=\"8\" ss:Bold=\"1\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s24\">");
        wb.println("<Alignment ss:Vertical=\"Bottom\"/>");
        wb.println("<Font x:Family=\"Swiss\" ss:Size=\"8\" ss:Bold=\"1\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s25\">");
        wb.println("<Font x:Family=\"Swiss\" ss:Size=\"8\" ss:Bold=\"1\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s26\">");
        wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font x:Family=\"Swiss\" ss:Size=\"8\" ss:Bold=\"1\"/>");
        wb.println("<Interior ss:Color=\"#CCFFCC\" ss:Pattern=\"Solid\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s27\">");
        wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("<Font x:Family=\"Swiss\" ss:Size=\"8\" ss:Bold=\"1\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s28\">");
        wb.println("<Alignment ss:Vertical=\"Bottom\"/>");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font x:Family=\"Swiss\" ss:Size=\"8\"/>");
        wb.println("</Style>");
        
        wb.println("<Style ss:ID=\"s87\">");
        wb.println("<Alignment ss:Horizontal=\"Right\" ss:Vertical=\"Bottom\"/>");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font x:Family=\"Swiss\" ss:Size=\"8\"/>");
        wb.println("</Style>");
        
        wb.println("<Style ss:ID=\"s29\">");
        wb.println("<Alignment ss:Vertical=\"Bottom\"/>");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font x:Family=\"Swiss\" ss:Size=\"8\"/>");
        wb.println("<NumberFormat ss:Format=\"#,##0\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s30\">");
        wb.println("<Alignment ss:Vertical=\"Bottom\"/>");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font x:Family=\"Swiss\" ss:Size=\"8\" ss:Bold=\"1\"/>");
        wb.println("<Interior ss:Color=\"#FFFF99\" ss:Pattern=\"Solid\"/>");
        wb.println("<NumberFormat ss:Format=\"#,##0\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s40\">");
        wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("<Font x:Family=\"Swiss\" ss:Bold=\"1\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s41\">");
        wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("<Font x:Family=\"Swiss\" ss:Size=\"9\" ss:Bold=\"1\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s42\">");
        wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\" ss:WrapText=\"1\"/>");
        wb.println("<Font x:Family=\"Swiss\" ss:Size=\"8\" ss:Bold=\"1\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s43\">");
        wb.println("<Alignment ss:Vertical=\"Bottom\"/>");
        wb.println("<Font x:Family=\"Swiss\" ss:Size=\"8\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s50\">");
        wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font x:Family=\"Swiss\" ss:Size=\"8\"/>");
        wb.println("</Style>");
        wb.println("</Styles>");
        wb.println("<Worksheet ss:Name=\"Sheet1\">");
        
        wb.println("<Table ss:ExpandedColumnCount=\"35\"  x:FullColumns=\"1\"");
        wb.println("x:FullRows=\"1\">");
        wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"24.75\"/>");
        wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"20\"/>");//no
        wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"80\"/>");//group
        wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"80\"/>");//category
        wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"50\"/>");//code
        wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"70\"/>");//barcode
        wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"150\"/>");// name
        wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"140\"/>");// supplier
        wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"140\"/>");// qty
        wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"140\"/>");// qty
        wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"140\"/>");// total
        wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"140\"/>");// total
        wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"140\"/>");// total
        wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"140\"/>");// total
        wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"140\"/>");// total
        wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"140\"/>");// total
        wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"140\"/>");// total
        wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"140\"/>");// total
        wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"140\"/>");// total
        wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"140\"/>");// total
        wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"140\"/>");// total
        wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"140\"/>");// total
        wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"140\"/>");// total
        wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"140\"/>");// total
        wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"140\"/>");// total
        wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"140\"/>");// total
        wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"140\"/>");// total
        
        
        wb.println("<Row ss:Index=\"2\">");
        wb.println("<Cell ss:Index=\"2\" ss:MergeAcross=\"8\" ss:StyleID=\"s40\"><Data ss:Type=\"String\">REPORT SALES SUMMARY</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s22\"/>");
        wb.println("<Cell ss:StyleID=\"s22\"/>");
        wb.println("<Cell ss:StyleID=\"s22\"/>");
        wb.println("</Row>");
        wb.println("<Row>");
        wb.println("<Cell ss:Index=\"2\" ss:MergeAcross=\"8\" ss:StyleID=\"s41\"><Data ss:Type=\"String\">"+cmp.getName()+"</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s22\"/>");
        wb.println("<Cell ss:StyleID=\"s22\"/>");
        wb.println("<Cell ss:StyleID=\"s22\"/>");
        wb.println("</Row>");
        wb.println("<Row ss:AutoFitHeight=\"0\">");
        wb.println("<Cell ss:Index=\"2\" ss:MergeAcross=\"8\" ss:StyleID=\"s42\"><Data ss:Type=\"String\">"+cmp.getAddress()+"</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s23\"/>");
        wb.println("<Cell ss:StyleID=\"s23\"/>");
        wb.println("<Cell ss:StyleID=\"s23\"/>");
        wb.println("</Row>");
        
        wb.println("<Row ss:AutoFitHeight=\"0\" ss:Height=\"5.25\">");
        wb.println("<Cell ss:Index=\"2\" ss:StyleID=\"s25\"/>");
        wb.println("<Cell ss:StyleID=\"s25\"/>");
        wb.println("<Cell ss:StyleID=\"s25\"/>");
        wb.println("<Cell ss:StyleID=\"s25\"/>");
        wb.println("<Cell ss:StyleID=\"s25\"/>");
        wb.println("<Cell ss:StyleID=\"s25\"/>");
        wb.println("</Row>");
        wb.println("<Row>");
        wb.println("<Cell ss:Index=\"2\" ss:MergeAcross=\"1\" ss:StyleID=\"s24\"><Data ss:Type=\"String\">Periode</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s24\" ss:MergeAcross=\"1\"><Data ss:Type=\"String\">: "+JSPFormater.formatDate(rp.getDateFrom(), "dd/MMM/yyyy")+" - " + JSPFormater.formatDate(rp.getDateTo(), "dd/MMM/yyyy")+"</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s24\"><Data ss:Type=\"String\"></Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s24\"><Data ss:Type=\"String\"></Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s25\"/>");
        wb.println("</Row>");
        
        
        
        wb.println("<Row ss:AutoFitHeight=\"0\" ss:Height=\"6.75\"/>");
        wb.println("<Row ss:Index=\"8\">");
        wb.println("<Cell ss:Index=\"2\" ss:StyleID=\"s26\"><Data ss:Type=\"String\">No</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s26\"><Data ss:Type=\"String\">Category</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s26\"><Data ss:Type=\"String\">Sub Category</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s26\"><Data ss:Type=\"String\">Code</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s26\"><Data ss:Type=\"String\">Barcode</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s26\"><Data ss:Type=\"String\">Name</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s26\"><Data ss:Type=\"String\">Supplier</Data></Cell>");
        
        Vector vloc = new Vector();
        
        if(rp.getLocationId()==0){
            vloc = DbLocation.list(0, 0, "type='Store'", "");
        }
        if(vloc !=null && vloc.size()>0){
            for(int b=0;b<vloc.size();b++ ){
                Location loc = new Location();
                loc = (Location) vloc.get(b);
                wb.println("<Cell ss:StyleID=\"s26\"><Data ss:Type=\"String\">"+ loc.getName()+"</Data></Cell>");
                                
            }
        }else{
            Location loc = new Location();
            try{
                loc= DbLocation.fetchExc(rp.getLocationId());
                wb.println("<Cell ss:StyleID=\"s26\"><Data ss:Type=\"String\">"+ loc.getName()+"</Data></Cell>");
            }catch(Exception ex){
                
            }
        }
        
        
        wb.println("</Row>");
                
        if(vDetail!=null && vDetail.size()>0){
            for(int i=0;i<vDetail.size();i++){
                ItemMaster im = new ItemMaster();
                ItemGroup ig = new ItemGroup();
                ItemCategory ic = new ItemCategory();
                Vendor ven = new Vendor();
                
                try{
                    im = (ItemMaster)vDetail.get(i);
                    ig = DbItemGroup.fetchExc(im.getItemGroupId());
                    ic = DbItemCategory.fetchExc(im.getItemCategoryId());
                    ven = DbVendor.fetchExc(im.getDefaultVendorId());
                }catch(Exception ex){
                    
                }
                //double harga = Double.parseDouble(vdt.get(6).toString());// ;      
                //double qty = Double.parseDouble(vdt.get(4).toString());    
                //double GrandTotal= harga * qty;      
                
                wb.println("<Row>");
                wb.println("<Cell ss:Index=\"2\" ss:StyleID=\"s50\"><Data ss:Type=\"Number\">"+(1+i)+"</Data></Cell>");
                wb.println("<Cell ss:StyleID=\"s28\"><Data ss:Type=\"String\">"+ ig.getName()+"</Data></Cell>");
                wb.println("<Cell ss:StyleID=\"s28\"><Data ss:Type=\"String\">"+ ic.getName()+"</Data></Cell>");
                wb.println("<Cell ss:StyleID=\"s28\"><Data ss:Type=\"String\">"+ im.getCode()+"</Data></Cell>");
                wb.println("<Cell ss:StyleID=\"s28\"><Data ss:Type=\"String\">"+ im.getBarcode()+"</Data></Cell>");
                wb.println("<Cell ss:StyleID=\"s28\"><Data ss:Type=\"String\">"+ im.getName()+"</Data></Cell>");
                wb.println("<Cell ss:StyleID=\"s28\"><Data ss:Type=\"String\">"+ven.getName()+"</Data></Cell>");
                              
                
                Vector vtotloc = new Vector();
                vtotloc = SessReportSales.getTotalQtySales(rp.getDateFrom(), rp.getDateTo(), rp.getLocationId() , im.getOID());
                    for(int j=1;j<vtotloc.size();j++){
                        try{
                            wb.println("<Cell ss:StyleID=\"s28\"><Data ss:Type=\"String\">"+vtotloc.get(j).toString()+"</Data></Cell>");
                        }catch(Exception ex){
                                System.out.print(ex);
                        }
                            
                            
                    }
                        if(vtotloc.size()==0){
                            if(rp.getLocationId()==0){
                                for(int j=0;j<vloc.size();j++){
                                    try{
                                        wb.println("<Cell ss:StyleID=\"s28\"><Data ss:Type=\"String\">0</Data></Cell>");
                                    }catch(Exception ex){
                                        System.out.print(ex);
                                    }


                                }
                            }else{
                                wb.println("<Cell ss:StyleID=\"s28\"><Data ss:Type=\"String\">0</Data></Cell>");
                            }
                        }
                    
                     wb.println("</Row>");
                        
                
            }
        }
        
        wb.println("<Row ss:AutoFitHeight=\"0\" ss:Height=\"3.75\">");
        wb.println("<Cell ss:Index=\"2\" ss:StyleID=\"s21\"/>");
        wb.println("<Cell ss:StyleID=\"s21\"/>");
        wb.println("<Cell ss:StyleID=\"s21\"/>");
        wb.println("<Cell ss:StyleID=\"s21\"/>");
        wb.println("<Cell ss:StyleID=\"s21\"/>");
        wb.println("<Cell ss:StyleID=\"s21\"/>");
        wb.println("</Row>");
        
      
        
        //=======penambahan batas
        wb.println("<Row>");
        wb.println("<Cell ss:Index=\"2\" ss:StyleID=\"s25\"/>");
        wb.println("<Cell ss:StyleID=\"s25\"/>");
        wb.println("<Cell ss:StyleID=\"s25\"/>");
        wb.println("<Cell ss:StyleID=\"s25\"/>");
        wb.println("<Cell ss:StyleID=\"s25\"/>");
        wb.println("<Cell ss:StyleID=\"s25\"/>");
        wb.println("</Row>");
        //=======end batas
        
        
        
      
        wb.println("<Row>");
        wb.println("<Cell ss:Index=\"2\" ss:StyleID=\"s25\"/>");
        wb.println("<Cell ss:StyleID=\"s25\"/>");
        wb.println("<Cell ss:StyleID=\"s25\"/>");
        wb.println("<Cell ss:StyleID=\"s25\"/>");
        wb.println("<Cell ss:StyleID=\"s25\"/>");
        wb.println("<Cell ss:StyleID=\"s25\"/>");
        wb.println("</Row>");
        
                
        wb.println("<Row>");
        wb.println("<Cell ss:Index=\"2\" ss:StyleID=\"s25\"/>");
        wb.println("<Cell ss:StyleID=\"s25\"/>");
        wb.println("<Cell ss:StyleID=\"s25\"/>");
        wb.println("<Cell ss:StyleID=\"s25\"/>");
        wb.println("<Cell ss:StyleID=\"s25\"/>");
        wb.println("<Cell ss:StyleID=\"s25\"/>");
        wb.println("</Row>");
        
        wb.println("<Row>");
        wb.println("<Cell ss:Index=\"2\" ss:StyleID=\"s25\"/>");
        wb.println("<Cell ss:StyleID=\"s25\"/>");
        wb.println("<Cell ss:StyleID=\"s25\"/>");
        wb.println("<Cell ss:StyleID=\"s25\"/>");
        wb.println("<Cell ss:StyleID=\"s25\"/>");
        wb.println("<Cell ss:StyleID=\"s25\"/>");
        wb.println("</Row>");
        
        wb.println("<Row>");
        wb.println("<Cell ss:Index=\"2\" ss:StyleID=\"s25\"/>");
        wb.println("<Cell ss:StyleID=\"s25\"/>");
        wb.println("<Cell ss:StyleID=\"s25\"/>");
        wb.println("<Cell ss:StyleID=\"s25\"/>");
        wb.println("<Cell ss:StyleID=\"s25\"/>");
        wb.println("<Cell ss:StyleID=\"s25\"/>");
        wb.println("</Row>");
        
        wb.println("<Row>");
        wb.println("<Cell ss:Index=\"2\" ss:StyleID=\"s25\"/>");
        wb.println("<Cell ss:StyleID=\"s25\"/>");
        wb.println("<Cell ss:StyleID=\"s25\"/>");
        wb.println("<Cell ss:StyleID=\"s25\"/>");
        wb.println("<Cell ss:StyleID=\"s25\"/>");
        wb.println("<Cell ss:StyleID=\"s25\"/>");
        wb.println("</Row>");
        
      
        
        wb.println("</Table>");
        wb.println("<WorksheetOptions xmlns=\"urn:schemas-microsoft-com:office:excel\">");
        wb.println("<DisplayPageBreak/>");
        wb.println("<Print>");
        wb.println("<ValidPrinterInfo/>");
        wb.println("<PaperSizeIndex>9</PaperSizeIndex>");
        wb.println("<HorizontalResolution>600</HorizontalResolution>");
        wb.println("<VerticalResolution>600</VerticalResolution>");
        wb.println("</Print>");
        wb.println("<Selected/>");
        wb.println("<DoNotDisplayGridlines/>");
        wb.println("<Panes>");
        wb.println("<Pane>");
        wb.println("<Number>3</Number>");
        wb.println("<ActiveRow>12</ActiveRow>");
        wb.println("<ActiveCol>6</ActiveCol>");
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
