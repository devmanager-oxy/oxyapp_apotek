/*
 * Report Donor to IFC by Group XLS.java
 *
 * Created on March 30, 2008, 1:33 AM
 */

package com.project.ccs.report;

import com.project.admin.DbUser;
import com.project.admin.User;
import com.project.ccs.posmaster.DbItemMaster;
import com.project.ccs.posmaster.ItemMaster;
import com.project.ccs.postransaction.purchase.DbPurchase;
import com.project.ccs.postransaction.purchase.Purchase;
import com.project.ccs.postransaction.receiving.DbReceive;
import com.project.ccs.postransaction.receiving.DbReceiveItem;
import com.project.ccs.postransaction.receiving.Receive;
import com.project.ccs.postransaction.receiving.ReceiveItem;
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
//import com.project.fms.master.*;
import com.project.payroll.*;
import com.project.util.jsp.*;
import com.project.fms.session.*;
import com.project.fms.activity.*;
import com.project.general.*;

public class RptIncomingGoodsXLSx extends HttpServlet {
    
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
        long receiveId = Long.parseLong(request.getParameter("receive_id"));
        //SessIncomingGoods ig = new SessIncomingGoods(); 
        Receive rec= new Receive();
        try{
            //HttpSession session = request.getSession();
            rec =  DbReceive.fetchExc(receiveId);
           //ig = (SessIncomingGoods)session.getValue("PURCHASE_TITTLE");
        }catch(Exception e){
            System.out.println(e.toString());
        }
        
        Vector vectorList = new Vector();
        try{
            //HttpSession session = request.getSession();
            vectorList = DbReceiveItem.list(0, 0, "receive_id="+receiveId, "");
        }catch(Exception e){
            System.out.println(e.toString());
        }
        
        Company cmp = new Company();
        try{
            Vector listCompany = DbCompany.list(0,0, "", "");
            if(listCompany!=null && listCompany.size()>0){
                cmp = (Company)listCompany.get(0);
            }
        }catch(Exception ext){
            System.out.println(ext.toString());
        }
             
        
        
        
        
       
        
        /*RptTranfer rptKonstan = new RptTranfer();
        try{
            HttpSession session = request.getSession();
            rptKonstan = (RptTranfer)session.getValue("KONSTAN");
        }catch(Exception ex){
            System.out.println(ex.toString());
        }
        
        Vector vDetail = new Vector();
        try{
            HttpSession session = request.getSession();
            vDetail = (Vector)session.getValue("DETAIL");
        }catch(Exception e){
            System.out.println(e.toString());
        }*/
        
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
        wb.println("<LastPrinted>2009-07-19T04:36:43Z</LastPrinted>");
        wb.println("<Created>1996-10-14T23:33:28Z</Created>");
        wb.println("<LastSaved>2009-07-19T04:37:48Z</LastSaved>");
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
        
        wb.println("<Style ss:ID=\"m25167260\">");
        wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font x:Family=\"Swiss\" ss:Size=\"10\" ss:Bold=\"1\"/>");
        wb.println("<Interior ss:Color=\"#CCFFCC\" ss:Pattern=\"Solid\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s22\">");
        wb.println("<Borders/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s26\">");
        wb.println("<Alignment ss:Vertical=\"Bottom\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s28\">");
        wb.println("<Alignment ss:Vertical=\"Center\" ss:WrapText=\"1\"/>");
        wb.println("<Font x:Family=\"Swiss\" ss:Size=\"10\" ss:Bold=\"1\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s31\">");
        wb.println("<Alignment ss:Vertical=\"Bottom\"/>");
        wb.println("<Font x:Family=\"Swiss\" ss:Size=\"10\" ss:Bold=\"1\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s32\">");
        wb.println("<Font x:Family=\"Swiss\" ss:Size=\"10\" ss:Bold=\"1\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s33\">");
        wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font x:Family=\"Swiss\" ss:Size=\"10\" ss:Bold=\"1\"/>");
        wb.println("<Interior ss:Color=\"#CCFFCC\" ss:Pattern=\"Solid\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s36\">");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font x:Family=\"Swiss\" ss:Size=\"10\"/>");
        wb.println("</Style>");
        
        wb.println("<Style ss:ID=\"y36\">");
        wb.println("<Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Bottom\"/>");
        wb.println("<Font x:Family=\"Swiss\" ss:Size=\"10\"/>");
        wb.println("<NumberFormat ss:Format=\"#,##0\"/>");
        wb.println("</Style>");
        
        
        wb.println("<Style ss:ID=\"s37\">");
        wb.println("<Alignment ss:Horizontal=\"Right\" ss:Vertical=\"Bottom\"/>");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font x:Family=\"Swiss\" ss:Size=\"10\"/>");
        wb.println("<NumberFormat ss:Format=\"#,##0\"/>");
        wb.println("</Style>");
        
        wb.println("<Style ss:ID=\"y37\">");
        wb.println("<Alignment ss:Horizontal=\"Right\" ss:Vertical=\"Bottom\"/>");
        wb.println("<Font x:Family=\"Swiss\" ss:Size=\"10\"/>");
        wb.println("<NumberFormat ss:Format=\"#,##0\"/>");
        wb.println("</Style>");
        
        
        wb.println("<Style ss:ID=\"s38\">");
        wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font x:Family=\"Swiss\" ss:Size=\"10\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s44\">");
        wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\" ss:WrapText=\"1\"/>");
        wb.println("<Font x:Family=\"Swiss\" ss:Size=\"10\" ss:Bold=\"1\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s45\">");
        wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("<Font x:Family=\"Swiss\" ss:Bold=\"1\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s46\">");
        wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("<Font x:Family=\"Swiss\" ss:Size=\"10\" ss:Bold=\"1\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s47\">");
        wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font x:Family=\"Swiss\" ss:Size=\"10\" ss:Bold=\"1\"/>");
        wb.println("<Interior ss:Color=\"#FFFF99\" ss:Pattern=\"Solid\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s48\">");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font x:Family=\"Swiss\" ss:Size=\"10\" ss:Bold=\"1\"/>");
        wb.println("<Interior ss:Color=\"#FFFF99\" ss:Pattern=\"Solid\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s49\">");
        wb.println("<Borders>");
        wb.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
        wb.println("</Borders>");
        wb.println("<Font x:Family=\"Swiss\" ss:Size=\"10\" ss:Bold=\"1\"/>");
        wb.println("<Interior ss:Color=\"#FFFF99\" ss:Pattern=\"Solid\"/>");
        wb.println("<NumberFormat ss:Format=\"#,##0\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s52\">");
        wb.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
        wb.println("<Font x:Family=\"Swiss\" ss:Size=\"10\" ss:Bold=\"1\"/>");
        wb.println("</Style>");
        wb.println("<Style ss:ID=\"s54\">");
        wb.println("<Alignment ss:Vertical=\"Bottom\"/>");
        wb.println("<Font x:Family=\"Swiss\" ss:Size=\"10\"/>");
        wb.println("</Style>");
        wb.println("</Styles>");
        wb.println("<Worksheet ss:Name=\"Sheet1\">");
        
        wb.println("<Table ss:ExpandedColumnCount=\"11\" x:FullColumns=\"1\"");
        wb.println("x:FullRows=\"1\">");
        wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"4.5\"/>");
        wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"20\"/>");//no
        wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"60\"/>");//barcode
        wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"200\"/>");//name
        wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"60\"/>");//price
        wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"25\"/>");//qty
        wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"20\"/>");//discount
        wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"80\"/>");//total
        
        //wb.println("<Column ss:AutoFitWidth=\"0\" ss:Width=\"90\"/>");
        wb.println("<Row ss:Index=\"2\">");
        wb.println("<Cell ss:Index=\"2\" ss:MergeAcross=\"6\" ss:StyleID=\"s45\"><Data ss:Type=\"String\">INCOMING GOODS</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s26\"/>");
        //wb.println("<Cell ss:StyleID=\"s26\"/>");
        //wb.println("<Cell ss:StyleID=\"s26\"/>");
        //wb.println("<Cell ss:StyleID=\"s26\"/>");
        //wb.println("<Cell ss:StyleID=\"s26\"/>");
        
        
        wb.println("</Row>");
        wb.println("<Row>");
        wb.println("<Cell ss:Index=\"2\" ss:MergeAcross=\"6\" ss:StyleID=\"s46\"><Data ss:Type=\"String\">"+cmp.getName()+"</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s26\"/>");
       // wb.println("<Cell ss:StyleID=\"s26\"/>");
       // wb.println("<Cell ss:StyleID=\"s26\"/>");
       // wb.println("<Cell ss:StyleID=\"s26\"/>");
        wb.println("</Row>");
        wb.println("<Row ss:AutoFitHeight=\"0\">");
        wb.println("<Cell ss:Index=\"2\" ss:MergeAcross=\"6\" ss:StyleID=\"s44\"><Data ss:Type=\"String\">"+cmp.getAddress()+"</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s28\"/>");
       // wb.println("<Cell ss:StyleID=\"s28\"/>");
       // wb.println("<Cell ss:StyleID=\"s28\"/>");
       // wb.println("<Cell ss:StyleID=\"s28\"/>");
        wb.println("</Row>");
        
        
        
        wb.println("<Row ss:AutoFitHeight=\"0\">");
        wb.println("<Cell ss:Index=\"2\" ss:MergeAcross=\"6\" ss:StyleID=\"s44\"><Data ss:Type=\"String\"></Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s28\"/>");
       // wb.println("<Cell ss:StyleID=\"s28\"/>");
       // wb.println("<Cell ss:StyleID=\"s28\"/>");
       // wb.println("<Cell ss:StyleID=\"s28\"/>");
        wb.println("</Row>");
        //po number
        if(rec.getPurchaseId()!=0){
            Purchase pur = new Purchase();
                    try{
                pur = DbPurchase.fetchExc(rec.getPurchaseId());
            }catch(Exception ex){
                
            }
            wb.println("<Row ss:Index=\"6\">");
            wb.println("<Cell ss:Index=\"2\" ss:MergeAcross=\"1\" ss:StyleID=\"y36\"><Data ss:Type=\"String\">PO number</Data></Cell>");
            wb.println("<Cell ss:StyleID=\"s31\"><Data ss:Type=\"String\">: "+pur.getNumber()+"</Data></Cell>");
            wb.println("<Cell ss:StyleID=\"s32\"/>");
            wb.println("<Cell ss:StyleID=\"s32\"/>");
            wb.println("<Cell ss:StyleID=\"s32\"/>");
            wb.println("</Row>");
            
        }
        //vendor
        Vendor ven = new Vendor();
        Location loc = new Location();
        try{
            ven = DbVendor.fetchExc(rec.getVendorId());
            loc = DbLocation.fetchExc(rec.getLocationId());
        }catch(Exception ex){
            
        }
        wb.println("<Row>");
        wb.println("<Cell ss:Index=\"2\" ss:MergeAcross=\"1\" ss:StyleID=\"y36\"><Data ss:Type=\"String\">Vendor</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s31\"><Data ss:Type=\"String\">: "+ven.getName()+"</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"y36\"><Data ss:Type=\"String\">Receive In</Data></Cell>");
        wb.println("<Cell ss:MergeAcross=\"2\" ss:StyleID=\"s31\"><Data ss:Type=\"String\">: " +loc.getName()+"</Data></Cell>");
        
        wb.println("</Row>");
        
        
             
        
        //address
        wb.println("<Row>");
        wb.println("<Cell ss:Index=\"2\" ss:MergeAcross=\"1\" ss:StyleID=\"y36\"><Data ss:Type=\"String\">Address</Data></Cell>");
        wb.println("<Cell  ss:StyleID=\"s31\"><Data ss:Type=\"String\">: "+loc.getAddressStreet()+"</Data></Cell>");
        wb.println("<Cell  ss:StyleID=\"y36\"><Data ss:Type=\"String\">Doc Number</Data></Cell>");
        wb.println("<Cell ss:MergeAcross=\"2\" ss:StyleID=\"s31\"><Data ss:Type=\"String\">: " +rec.getNumber()+"</Data></Cell>");
        
        wb.println("</Row>");
        
        //DO number
        wb.println("<Row>");
        wb.println("<Cell ss:Index=\"2\" ss:MergeAcross=\"1\" ss:StyleID=\"y36\"><Data ss:Type=\"String\">DO Number</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s31\"><Data ss:Type=\"String\">: "+rec.getDoNumber()+"</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s32\"/>");
        wb.println("<Cell ss:StyleID=\"s32\"/>");
        wb.println("<Cell ss:StyleID=\"s32\"/>");
        wb.println("</Row>");
        
        
        //Inv Number
        wb.println("<Row>");
        wb.println("<Cell ss:Index=\"2\" ss:MergeAcross=\"1\" ss:StyleID=\"y36\"><Data ss:Type=\"String\">Inv Number</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s31\"><Data ss:Type=\"String\">: "+rec.getInvoiceNumber()+"</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s32\"/>");
        wb.println("<Cell ss:StyleID=\"s32\"/>");
        wb.println("<Cell ss:StyleID=\"s32\"/>");
        wb.println("</Row>");
        
        //date
        wb.println("<Row>");
        wb.println("<Cell ss:Index=\"2\" ss:MergeAcross=\"1\" ss:StyleID=\"y36\"><Data ss:Type=\"String\">Date</Data></Cell>");
        wb.println("<Cell  ss:StyleID=\"s31\"><Data ss:Type=\"String\">: "+JSPFormater.formatDate(rec.getDate(), "dd/MM/yyyy")+"</Data></Cell>");
        String ApplayVat = "";
                if(rec.getIncluceTax()==0){
                    ApplayVat = "";
                }else{
                    ApplayVat = "Yes";
                    
                }
        
        if(rec.getIncluceTax()!=0){
            wb.println("<Cell ss:StyleID=\"y36\"><Data ss:Type=\"String\">Apply Vat</Data></Cell>");
            wb.println("<Cell ss:MergeAcross=\"1\" ss:StyleID=\"s31\"><Data ss:Type=\"String\">: " +ApplayVat+"</Data></Cell>");
        }
        wb.println("</Row>");
        
        //payment
        wb.println("<Row>");
        wb.println("<Cell ss:Index=\"2\" ss:MergeAcross=\"1\" ss:StyleID=\"y36\"><Data ss:Type=\"String\">Payment</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s31\"><Data ss:Type=\"String\">: "+rec.getPaymentType()+"</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"y36\"><Data ss:Type=\"String\">Term Of Payment</Data></Cell>");
        wb.println("<Cell ss:MergeAcross=\"1\" ss:StyleID=\"s31\"><Data ss:Type=\"String\">: " +JSPFormater.formatDate(rec.getDueDate(), "dd/MM/yyyy")+"</Data></Cell>");
        wb.println("</Row>");
        
        //note
        wb.println("<Row>");
        wb.println("<Cell ss:Index=\"2\" ss:MergeAcross=\"1\" ss:StyleID=\"y36\"><Data ss:Type=\"String\">Note</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s31\"><Data ss:Type=\"String\">: "+rec.getNote()+"</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s32\"/>");
        wb.println("<Cell ss:StyleID=\"s32\"/>");
        wb.println("<Cell ss:StyleID=\"s32\"/>");
        wb.println("</Row>");
        //wb.println("<Row ss:AutoFitHeight=\"0\" ss:Height=\"5.25\">");
        wb.println("<Row>");
        wb.println("<Cell ss:Index=\"2\" ss:StyleID=\"s32\"/>");
        wb.println("<Cell ss:StyleID=\"s32\"/>");
        wb.println("<Cell ss:StyleID=\"s32\"/>");
        wb.println("<Cell ss:StyleID=\"s32\"/>");
        wb.println("<Cell ss:StyleID=\"s32\"/>");
        wb.println("<Cell ss:StyleID=\"s32\"/>");
        wb.println("</Row>");
        
        
        //wb.println("<Row ss:AutoFitHeight=\"0\" ss:Height=\"5.25\">");
        wb.println("<Row>");
        wb.println("<Cell ss:Index=\"2\" ss:StyleID=\"s32\"/>");
        wb.println("<Cell ss:StyleID=\"s32\"/>");
        wb.println("<Cell ss:StyleID=\"s32\"/>");
        wb.println("<Cell ss:StyleID=\"s32\"/>");
        wb.println("<Cell ss:StyleID=\"s32\"/>");
        wb.println("<Cell ss:StyleID=\"s32\"/>");
        wb.println("</Row>");
        
       
        //wb.println("<Row ss:AutoFitHeight=\"0\" ss:Height=\"6.75\"/>");
        //wb.println("<Row ss:Index=\"13\">");
        wb.println("<Row>");
        //wb.println("<Row ss:AutoFitHeight=\"0\" ss:Height=\"6.75\"/>");
        //wb.println("<Row ss:Index=\"13\">");
        //wb.println("<Cell ss:Index=\"2\" ss:StyleID=\"s33\"><Data ss:Type=\"String\">No</Data></Cell>");
        //wb.println("<Cell ss:Index=\"2\" ss:StyleID=\"s33\"><Data ss:Type=\"String\">Code</Data></Cell>");
        wb.println("<Cell ss:Index=\"2\" ss:StyleID=\"s33\"><Data ss:Type=\"String\">No</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s33\"><Data ss:Type=\"String\">Barcode</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s33\"><Data ss:Type=\"String\">Item Name</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s33\"><Data ss:Type=\"String\">Price</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s33\"><Data ss:Type=\"String\">Qty</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s33\"><Data ss:Type=\"String\">Disc</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s33\"><Data ss:Type=\"String\">Total</Data></Cell>");
        //wb.println("<Cell ss:StyleID=\"s33\"><Data ss:Type=\"String\">Unit</Data></Cell>");
        //wb.println("<Cell ss:StyleID=\"s33\"><Data ss:Type=\"String\">Expired Date</Data></Cell>");
        wb.println("</Row>");
        
        if(vectorList!=null && vectorList.size()>0){
            for(int i=0;i<vectorList.size();i++){
                    ReceiveItem ri = (ReceiveItem)vectorList.get(i);
                    ItemMaster im = new ItemMaster();
                    try{
                        im =  DbItemMaster.fetchExc(ri.getItemMasterId());
                    }catch(  Exception ex){
                        
                    }
                wb.println("<Row>");
                wb.println("<Cell ss:Index=\"2\" ss:StyleID=\"s36\"><Data ss:Type=\"String\">"+(i+1)+"</Data></Cell>");
                wb.println("<Cell ss:StyleID=\"s36\"><Data ss:Type=\"String\">"+im.getBarcode()+"</Data></Cell>");
                wb.println("<Cell ss:StyleID=\"s36\"><Data ss:Type=\"String\">"+im.getName()+"</Data></Cell>");
                wb.println("<Cell ss:StyleID=\"s37\"><Data ss:Type=\"String\">"+JSPFormater.formatNumber(ri.getAmount(), "#,###.##") +"</Data></Cell>");
                wb.println("<Cell ss:StyleID=\"s36\"><Data ss:Type=\"String\">"+ri.getQty()+"</Data></Cell>");
                wb.println("<Cell ss:StyleID=\"s36\"><Data ss:Type=\"String\">"+ri.getTotalDiscount()+"</Data></Cell>");
                wb.println("<Cell ss:StyleID=\"s37\"><Data ss:Type=\"String\">"+JSPFormater.formatNumber(ri.getTotalAmount(), "#,###.##")+"</Data></Cell>");
                //wb.println("<Cell ss:StyleID=\"s36\"><Data ss:Type=\"String\">"+igL.getUnit()+"</Data></Cell>");
                //if(igL.getExpiredDate()!=null){
                //    wb.println("<Cell ss:StyleID=\"s36\"><Data ss:Type=\"String\">"+igL.getExpiredDate()+"</Data></Cell>");
                //}else{
                //    wb.println("<Cell ss:StyleID=\"s36\"><Data ss:Type=\"String\">-</Data></Cell>");
                //}
               wb.println("</Row>");
            }
        }
        /*wb.println("<Row ss:AutoFitHeight=\"0\" ss:Height=\"3.75\">");
        wb.println("<Cell ss:Index=\"2\" ss:StyleID=\"s22\"/>");
        wb.println("<Cell ss:StyleID=\"s22\"/>");
        wb.println("<Cell ss:StyleID=\"s22\"/>");
        wb.println("<Cell ss:StyleID=\"s22\"/>");
        wb.println("<Cell ss:StyleID=\"s22\"/>");
        wb.println("<Cell ss:StyleID=\"s22\"/>");
        wb.println("</Row>");
        */
        /*
        wb.println("<Row>");
        wb.println("<Cell ss:Index=\"5\" ss:StyleID=\"s47\"><Data ss:Type=\"String\">Total</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s48\"><Data ss:Type=\"Number\">2</Data></Cell>");
        wb.println("<Cell ss:StyleID=\"s49\"><Data ss:Type=\"Number\">200000</Data></Cell>");
        wb.println("</Row>");
        */
        
        wb.println("<Row>");
        wb.println("<Cell ss:Index=\"2\" ss:StyleID=\"s32\"/>");
        wb.println("<Cell ss:StyleID=\"s32\"/>");
        wb.println("<Cell ss:StyleID=\"s32\"/>");
        wb.println("<Cell ss:StyleID=\"s32\"/>");
        wb.println("<Cell ss:StyleID=\"s32\"/>");
        wb.println("<Cell ss:StyleID=\"s32\"/>");
        wb.println("</Row>");
        
        
        wb.println("<Row>");
        wb.println("<Cell ss:MergeAcross=\"5\" ss:StyleID=\"y37\"><Data ss:Type=\"String\">Sub Total</Data></Cell>");
        wb.println("<Cell ss:MergeAcross=\"1\" ss:StyleID=\"y37\"><Data ss:Type=\"String\">"+JSPFormater.formatNumber(rec.getTotalAmount(), "#,###.##")+"</Data></Cell>");
        wb.println("</Row>");
        
        if(rec.getDiscountTotal()!=0){
            wb.println("<Row>");
            wb.println("<Cell ss:MergeAcross=\"5\" ss:StyleID=\"y37\"><Data ss:Type=\"String\">Discount</Data></Cell>");
            wb.println("<Cell ss:MergeAcross=\"1\" ss:StyleID=\"y37\"><Data ss:Type=\"String\">"+JSPFormater.formatNumber(rec.getDiscountTotal(), "#,###.##")+"</Data></Cell>");
            wb.println("</Row>");
        }
        if(rec.getIncluceTax()!=0){
            wb.println("<Row>");
            wb.println("<Cell ss:MergeAcross=\"5\" ss:StyleID=\"y37\"><Data ss:Type=\"String\">VAT</Data></Cell>");
            wb.println("<Cell ss:MergeAcross=\"1\" ss:StyleID=\"y37\"><Data ss:Type=\"String\">"+JSPFormater.formatNumber(rec.getTotalTax(), "#,###.##")+"</Data></Cell>");
            wb.println("</Row>");
        }
        wb.println("<Row>");
        wb.println("<Cell ss:MergeAcross=\"5\" ss:StyleID=\"y37\"><Data ss:Type=\"String\">Grand Total</Data></Cell>");
        wb.println("<Cell ss:MergeAcross=\"1\" ss:StyleID=\"y37\"><Data ss:Type=\"String\">"+JSPFormater.formatNumber((rec.getTotalAmount()-rec.getDiscountTotal()+rec.getTotalTax()), "#,###.##")+"</Data></Cell>");
        wb.println("</Row>");
        
        
        wb.println("<Row>");
        wb.println("<Cell ss:Index=\"2\" ss:StyleID=\"s32\"/>");
        wb.println("<Cell ss:StyleID=\"s32\"/>");
        wb.println("<Cell ss:StyleID=\"s32\"/>");
        wb.println("<Cell ss:StyleID=\"s32\"/>");
        wb.println("<Cell ss:StyleID=\"s32\"/>");
        wb.println("<Cell ss:StyleID=\"s32\"/>");
        wb.println("</Row>");
        
        
        wb.println("<Row>");
        wb.println("<Cell ss:Index=\"2\" ss:StyleID=\"s32\"/>");
        wb.println("<Cell ss:StyleID=\"s32\"/>");
        wb.println("<Cell ss:StyleID=\"s32\"/>");
        wb.println("<Cell ss:StyleID=\"s32\"/>");
        wb.println("<Cell ss:StyleID=\"s32\"/>");
        wb.println("<Cell ss:StyleID=\"s32\"/>");
        wb.println("</Row>");
        wb.println("<Row>");
        wb.println("<Cell ss:Index=\"2\" ss:MergeAcross=\"1\" ss:StyleID=\"s31\"><Data ss:Type=\"String\">Prepared By,</Data></Cell>");
        wb.println("<Cell ss:MergeAcross=\"1\" ss:StyleID=\"s31\"><Data ss:Type=\"String\">                Approved By,              </Data></Cell>");
        wb.println("<Cell ss:MergeAcross=\"1\" ss:StyleID=\"s52\"><Data ss:Type=\"String\">Checked By,</Data></Cell>");
        wb.println("</Row>");
        wb.println("<Row>");
        wb.println("<Cell ss:Index=\"2\" ss:StyleID=\"s32\"/>");
        wb.println("<Cell ss:StyleID=\"s32\"/>");
        wb.println("<Cell ss:StyleID=\"s32\"/>");
        wb.println("<Cell ss:StyleID=\"s32\"/>");
        wb.println("<Cell ss:StyleID=\"s32\"/>");
        wb.println("<Cell ss:StyleID=\"s32\"/>");
        wb.println("</Row>");
        wb.println("<Row>");
        wb.println("<Cell ss:Index=\"2\" ss:StyleID=\"s32\"/>");
        wb.println("<Cell ss:StyleID=\"s32\"/>");
        wb.println("<Cell ss:StyleID=\"s32\"/>");
        wb.println("<Cell ss:StyleID=\"s32\"/>");
        wb.println("<Cell ss:StyleID=\"s32\"/>");
        wb.println("<Cell ss:StyleID=\"s32\"/>");
        wb.println("</Row>");
        wb.println("<Row>");
        wb.println("<Cell ss:Index=\"2\" ss:StyleID=\"s32\"/>");
        wb.println("<Cell ss:StyleID=\"s32\"/>");
        wb.println("<Cell ss:StyleID=\"s32\"/>");
        wb.println("<Cell ss:StyleID=\"s32\"/>");
        wb.println("<Cell ss:StyleID=\"s32\"/>");
        wb.println("<Cell ss:StyleID=\"s32\"/>");
        wb.println("</Row>");
        wb.println("<Row>");
        wb.println("<Cell ss:Index=\"2\" ss:StyleID=\"s32\"/>");
        wb.println("<Cell ss:StyleID=\"s32\"/>");
        wb.println("<Cell ss:StyleID=\"s32\"/>");
        wb.println("<Cell ss:StyleID=\"s32\"/>");
        wb.println("<Cell ss:StyleID=\"s32\"/>");
        wb.println("<Cell ss:StyleID=\"s32\"/>");
        wb.println("</Row>");
        wb.println("<Row>");
        User uses =  new User();
        try{
            uses = DbUser.fetch(rec.getUserId());
        }catch(Exception ex ){
            
        }
         wb.println("<Cell ss:Index=\"2\" ss:MergeAcross=\"1\" ss:StyleID=\"s31\"><Data ss:Type=\"String\">"+uses.getFullName()+"</Data></Cell>");
        wb.println("<Cell ss:MergeAcross=\"1\" ss:StyleID=\"s31\"><Data ss:Type=\"String\"></Data></Cell>");
        wb.println("<Cell ss:MergeAcross=\"2\" ss:StyleID=\"s31\"><Data ss:Type=\"String\"></Data></Cell>");
        wb.println("</Row>");
        wb.println("<Row>");
         wb.println("<Cell ss:Index=\"2\" ss:MergeAcross=\"1\" ss:StyleID=\"s31\"><Data ss:Type=\"String\">___________________</Data></Cell>");
         wb.println("<Cell ss:MergeAcross=\"1\" ss:StyleID=\"s31\"><Data ss:Type=\"String\">                ___________________             </Data></Cell>");
        wb.println("<Cell ss:MergeAcross=\"2\" ss:StyleID=\"s31\"><Data ss:Type=\"String\">___________________________________</Data></Cell>");
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
