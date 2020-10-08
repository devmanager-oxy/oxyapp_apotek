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
import com.project.util.jsp.*;
import com.project.fms.ar.*;
import com.project.fms.master.*;
import com.project.crm.project.*;
import java.sql.ResultSet;
import com.project.fms.transaction.BankpoPayment;
import com.project.fms.transaction.BankpoPaymentDetail;
import com.project.fms.transaction.DbBankpoPayment;
import com.project.fms.transaction.DbBankpoPaymentDetail;

import com.project.general.DbVendor;
import com.project.general.Vendor;
import com.project.main.db.CONHandler;
import com.project.main.db.CONResultSet;
import com.project.system.DbSystemProperty;
import com.project.util.NumberSpeller;
import java.text.DateFormat;

/**
 *
 * @author Roy
 */
public class PrintBgVBudgetXLS extends HttpServlet {
    
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

    String XMLSafe(String in) {
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
        int stsMaterai = JSPRequestValue.requestInt(request, "materai");
        long vendorId = JSPRequestValue.requestLong(request, "vendorId");
        double totBG = JSPRequestValue.requestDouble(request, "tot");
        String datefrom = JSPRequestValue.requestString(request, "datefrom");
        String dateto = JSPRequestValue.requestString(request, "dateto");
        //String datePrint = JSPFormater.formatDate(new Date(),"dd-MM-yyyy");
        //if (datefrom=dateto){
            String datePrint = datefrom;
        //}
        
        String name="";
        String desc="";
        String nameVendor="";


        Vendor v = new Vendor();
        try{
            name = "Vendor Name";
            if (vendorId!=0){
                v = DbVendor.fetchExc(vendorId);
                if(v.getIsPKP() == 1){
                    desc = "SUP. PKP";
                }else{
                    desc = "SUP. NON PKP";
                }
                if(v.getContact() != null && v.getContact().length() > 0){
                    name = v.getContact();
                }else{
                    name = v.getName();
                }
                nameVendor= v.getName();
            }
        }catch(Exception e){}

        double jmlMaterai=0;

        if (stsMaterai==1){
            jmlMaterai=3000;
        }else{
            jmlMaterai=0;
        }


        //==========Pengambilan data TT untuk mendapatkan apa ada materainya

        boolean gzip = false;

        OutputStream gzo;
        if (gzip) {
            response.setHeader("Content-Encoding", "gzip");
            gzo = new GZIPOutputStream(response.getOutputStream());
        } else {
            gzo = response.getOutputStream();
        }

        PrintWriter wb = new PrintWriter(new OutputStreamWriter(gzo, "UTF-8"));

	wb.println("      <?xml version=\"1.0\"?>");
	wb.println("      <?mso-application progid=\"Excel.Sheet\"?>");
	wb.println("      <Workbook xmlns=\"urn:schemas-microsoft-com:office:spreadsheet\"");
	wb.println("      xmlns:o=\"urn:schemas-microsoft-com:office:office\"");
	wb.println("      xmlns:x=\"urn:schemas-microsoft-com:office:excel\"");
	wb.println("      xmlns:ss=\"urn:schemas-microsoft-com:office:spreadsheet\"");
	wb.println("      xmlns:html=\"http://www.w3.org/TR/REC-html40\">");
	wb.println("      <DocumentProperties xmlns=\"urn:schemas-microsoft-com:office:office\">");
	wb.println("      <Author>US3R</Author>");
	wb.println("      <LastAuthor>oxy-system</LastAuthor>");
	wb.println("      <LastPrinted>2015-07-08T07:18:47Z</LastPrinted>");
	wb.println("      <Created>2015-06-22T01:15:56Z</Created>");
	wb.println("      <LastSaved>2015-07-29T04:08:59Z</LastSaved>");
	wb.println("      <Version>12.00</Version>");
	wb.println("      </DocumentProperties>");
	wb.println("      <ExcelWorkbook xmlns=\"urn:schemas-microsoft-com:office:excel\">");
	wb.println("      <WindowHeight>7935</WindowHeight>");
	wb.println("      <WindowWidth>20055</WindowWidth>");
	wb.println("      <WindowTopX>240</WindowTopX>");
	wb.println("      <WindowTopY>150</WindowTopY>");
	wb.println("      <ProtectStructure>False</ProtectStructure>");
	wb.println("      <ProtectWindows>False</ProtectWindows>");
	wb.println("      </ExcelWorkbook>");
	wb.println("      <Styles>");
	wb.println("      <Style ss:ID=\"Default\" ss:Name=\"Normal\">");
	wb.println("      <Alignment ss:Vertical=\"Bottom\"/>");
	wb.println("      <Borders/>");
	wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"/>");
	wb.println("      <Interior/>");
	wb.println("      <NumberFormat/>");
	wb.println("      <Protection/>");
	wb.println("      </Style>");
	wb.println("      <Style ss:ID=\"s16\" ss:Name=\"Comma\">");
	wb.println("      </Style>");
	wb.println("      <Style ss:ID=\"s62\">");
	wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"/>");
	wb.println("      </Style>");
	wb.println("      <Style ss:ID=\"s63\">");
	wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Color=\"#000000\"/>");
	wb.println("      </Style>");
	wb.println("      <Style ss:ID=\"s64\">");
	wb.println("      <Font ss:FontName=\"Consolas\" x:Family=\"Modern\" ss:Size=\"12\" ss:Color=\"#000000\"");
	wb.println("      ss:Bold=\"1\"/>");
	wb.println("      </Style>");
	wb.println("      <Style ss:ID=\"s66\">");
	wb.println("      <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Center\"/>");
	wb.println("      <Borders/>");
	wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Color=\"#000000\"/>");
	wb.println("      </Style>");
	wb.println("      <Style ss:ID=\"s67\">");
	wb.println("      <Borders/>");
	wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Color=\"#000000\"/>");
	wb.println("      </Style>");
	wb.println("      <Style ss:ID=\"s68\">");
	wb.println("      <Borders/>");
	wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"/>");
	wb.println("      </Style>");
	wb.println("      <Style ss:ID=\"s69\">");
	wb.println("      <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Center\"/>");
	wb.println("      <Borders/>");
	wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Color=\"#000000\"/>");
	wb.println("      <NumberFormat ss:Format=\"Short Date\"/>");
	wb.println("      </Style>");
	wb.println("      <Style ss:ID=\"s71\">");
	wb.println("      <Alignment ss:Vertical=\"Bottom\"/>");
	wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Color=\"#000000\"/>");
	wb.println("      </Style>");
	wb.println("      <Style ss:ID=\"s72\">");
	wb.println("      <Alignment ss:Vertical=\"Center\"/>");
	wb.println("      <Borders/>");
	wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"8\" ss:Color=\"#000000\"/>");
	wb.println("      </Style>");
	wb.println("      <Style ss:ID=\"s73\">");
	wb.println("      <Alignment ss:Vertical=\"Bottom\"/>");
	wb.println("      <Borders/>");
	wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Color=\"#000000\"/>");
	wb.println("      </Style>");
	wb.println("      <Style ss:ID=\"s74\">");
	wb.println("      <Alignment ss:Vertical=\"Bottom\"/>");
	wb.println("      <Borders/>");
	wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"12\" ss:Color=\"#000000\"/>");
	wb.println("      </Style>");
	wb.println("      <Style ss:ID=\"s75\">");
	wb.println("      <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Center\"/>");
	wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"8\" ss:Color=\"#000000\"/>");
	wb.println("      </Style>");
	wb.println("      <Style ss:ID=\"s76\">");
	wb.println("      <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Bottom\"/>");
	wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"8\" ss:Color=\"#000000\"/>");
	wb.println("      </Style>");
	wb.println("      <Style ss:ID=\"s77\">");
	wb.println("      <Alignment ss:Vertical=\"Bottom\"/>");
	wb.println("      <Borders/>");
	wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"/>");
	wb.println("      </Style>");
	wb.println("      <Style ss:ID=\"s79\">");
	wb.println("      <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Top\"/>");
	wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"8\" ss:Color=\"#000000\"/>");
	wb.println("      </Style>");
	wb.println("      <Style ss:ID=\"s80\">");
	wb.println("      <Alignment ss:Vertical=\"Top\"/>");
	wb.println("      <Borders/>");
	wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"9\" ss:Color=\"#000000\"/>");
	wb.println("      </Style>");
	wb.println("      <Style ss:ID=\"s82\" ss:Parent=\"s16\">");
	wb.println("      <Alignment ss:Vertical=\"Top\"/>");
	wb.println("      <Borders/>");
	wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Color=\"#000000\"/>");
	wb.println("      </Style>");
	wb.println("      <Style ss:ID=\"s84\">");
	wb.println("      <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Center\"/>");
	wb.println("      <Borders/>");
	wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"9\" ss:Color=\"#000000\"/>");
	wb.println("      </Style>");
	wb.println("      <Style ss:ID=\"s85\" ss:Parent=\"s16\">");
	wb.println("      <Alignment ss:Vertical=\"Top\"/>");
	wb.println("      <Borders/>");
	wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Color=\"#000000\"/>");
	wb.println("      <NumberFormat ss:Format=\"#,##0\"/>");
	wb.println("      </Style>");
	wb.println("      <Style ss:ID=\"s87\">");
	wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"/>");
	wb.println("      <NumberFormat ss:Format=\"#,##0\"/>");
	wb.println("      </Style>");
	wb.println("      </Styles>");
	wb.println("      <Worksheet ss:Name=\"Sheet1\">");
	wb.println("      <Table ss:ExpandedColumnCount=\"20\" ss:ExpandedRowCount=\"16\" x:FullColumns=\"1\"");
	wb.println("      x:FullRows=\"1\" ss:StyleID=\"s62\" ss:DefaultRowHeight=\"15\">");
	wb.println("      <Column ss:StyleID=\"s62\" ss:AutoFitWidth=\"0\" ss:Width=\"40.5\"/>");
	wb.println("      <Column ss:StyleID=\"s62\" ss:AutoFitWidth=\"0\" ss:Width=\"58.5\"/>");
	wb.println("      <Column ss:StyleID=\"s62\" ss:AutoFitWidth=\"0\" ss:Width=\"28.5\" ss:Span=\"2\"/>");
	wb.println("      <Column ss:Index=\"6\" ss:StyleID=\"s62\" ss:AutoFitWidth=\"0\" ss:Width=\"51\"/>");
	wb.println("      <Column ss:StyleID=\"s62\" ss:AutoFitWidth=\"0\" ss:Width=\"22.5\"/>");
	wb.println("      <Column ss:StyleID=\"s62\" ss:AutoFitWidth=\"0\" ss:Width=\"69.75\"/>");
	wb.println("      <Column ss:StyleID=\"s62\" ss:AutoFitWidth=\"0\" ss:Width=\"12\"/>");
	wb.println("      <Column ss:StyleID=\"s62\" ss:AutoFitWidth=\"0\" ss:Width=\"16.5\"/>");
	wb.println("      <Column ss:StyleID=\"s62\" ss:AutoFitWidth=\"0\" ss:Width=\"3.75\"/>");
	wb.println("      <Column ss:StyleID=\"s62\" ss:AutoFitWidth=\"0\" ss:Width=\"36\"/>");
	wb.println("      <Column ss:StyleID=\"s62\" ss:AutoFitWidth=\"0\" ss:Width=\"24\"/>");
	wb.println("      <Column ss:StyleID=\"s62\" ss:AutoFitWidth=\"0\" ss:Width=\"71.25\"/>");
	wb.println("      <Column ss:StyleID=\"s62\" ss:AutoFitWidth=\"0\" ss:Width=\"6.75\"/>");
	wb.println("      <Column ss:StyleID=\"s62\" ss:AutoFitWidth=\"0\" ss:Width=\"37.5\"/>");
	wb.println("      <Column ss:StyleID=\"s62\" ss:AutoFitWidth=\"0\" ss:Width=\"71.25\"/>");
	wb.println("      <Column ss:StyleID=\"s62\" ss:AutoFitWidth=\"0\" ss:Width=\"11.25\"/>");
	wb.println("      <Column ss:Index=\"20\" ss:StyleID=\"s62\" ss:AutoFitWidth=\"0\" ss:Width=\"8.25\"/>");
	wb.println("      <Row ss:AutoFitHeight=\"0\"/>");
	wb.println("      <Row ss:Index=\"3\" ss:AutoFitHeight=\"0\">");
	wb.println("      <Cell ss:StyleID=\"s63\"/>");
	wb.println("      <Cell ss:StyleID=\"s63\"/>");
	wb.println("      <Cell ss:StyleID=\"s63\"/>");
	wb.println("      <Cell ss:StyleID=\"s63\"/>");
	wb.println("      <Cell ss:StyleID=\"s63\"/>");
	wb.println("      <Cell ss:StyleID=\"s63\"/>");
	wb.println("      <Cell ss:StyleID=\"s63\"/>");
	wb.println("      <Cell ss:StyleID=\"s63\"/>");
	wb.println("      <Cell ss:StyleID=\"s63\"/>");
	wb.println("      <Cell ss:StyleID=\"s63\"/>");
	wb.println("      <Cell ss:StyleID=\"s63\"/>");
	wb.println("      <Cell ss:StyleID=\"s63\"/>");
	wb.println("      <Cell ss:StyleID=\"s63\"/>");
	wb.println("      <Cell ss:StyleID=\"s63\"/>");
	wb.println("      </Row>");
	wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"19.5\">");
	wb.println("      <Cell ss:StyleID=\"s63\"/>");
	wb.println("      <Cell ss:StyleID=\"s63\"/>");
	wb.println("      <Cell ss:StyleID=\"s63\"/>");
	wb.println("      <Cell ss:StyleID=\"s63\"/>");
	wb.println("      <Cell ss:StyleID=\"s63\"/>");
	wb.println("      <Cell ss:StyleID=\"s63\"/>");
	wb.println("      <Cell ss:StyleID=\"s63\"/>");
	wb.println("      <Cell ss:StyleID=\"s63\"/>");
	wb.println("      <Cell ss:StyleID=\"s63\"/>");
	wb.println("      <Cell ss:StyleID=\"s63\"/>");
	wb.println("      <Cell ss:StyleID=\"s63\"/>");
	wb.println("      <Cell ss:StyleID=\"s63\"/>");
	wb.println("      <Cell ss:StyleID=\"s63\"/>");
	wb.println("      <Cell ss:StyleID=\"s63\"><Data ss:Type=\"String\"></Data></Cell>");
	wb.println("      <Cell ss:Index=\"16\" ss:StyleID=\"s64\"/>");
	wb.println("      </Row>");
	wb.println("      <Row ss:AutoFitHeight=\"0\">");
	wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s66\"><Data ss:Type=\"String\">"+desc+"</Data></Cell>");
	wb.println("      <Cell ss:StyleID=\"s67\"/>");
	wb.println("      <Cell ss:StyleID=\"s67\"/>");
	wb.println("      <Cell ss:StyleID=\"s63\"/>");
	wb.println("      <Cell ss:StyleID=\"s63\"/>");
	wb.println("      <Cell ss:StyleID=\"s63\"/>");
	wb.println("      <Cell ss:StyleID=\"s63\"/>");
	wb.println("      <Cell ss:StyleID=\"s63\"><Data ss:Type=\"String\"></Data></Cell>");
	wb.println("      <Cell ss:StyleID=\"s63\"/>");
	wb.println("      <Cell ss:StyleID=\"s63\"/>");
	wb.println("      <Cell ss:StyleID=\"s63\"/>");
	wb.println("      <Cell ss:StyleID=\"s63\"/>");
	wb.println("      <Cell ss:StyleID=\"s67\"/>");
	wb.println("      <Cell ss:Index=\"16\" ss:StyleID=\"s68\"/>");
	wb.println("      <Cell ss:StyleID=\"s68\"/>");
	wb.println("      <Cell ss:StyleID=\"s68\"/>");
	wb.println("      <Cell ss:StyleID=\"s68\"/>");
	wb.println("      <Cell ss:StyleID=\"s68\"/>");
	wb.println("      </Row>");
	wb.println("      <Row ss:AutoFitHeight=\"0\">");
	wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s69\"><Data ss:Type=\"String\">"+datePrint+"</Data></Cell>");
	wb.println("      <Cell ss:StyleID=\"s67\"/>");
	wb.println("      <Cell ss:StyleID=\"s67\"/>");
	wb.println("      <Cell ss:StyleID=\"s63\"/>");
	wb.println("      <Cell ss:StyleID=\"s63\"/>");
	wb.println("      <Cell ss:StyleID=\"s63\"/>");
	wb.println("      <Cell ss:StyleID=\"s63\"/>");
	wb.println("      <Cell ss:StyleID=\"s63\"/>");
	wb.println("      <Cell ss:StyleID=\"s67\"/>");
	wb.println("      <Cell ss:StyleID=\"s67\"/>");
	wb.println("      <Cell ss:StyleID=\"s67\"/>");
	wb.println("      <Cell ss:StyleID=\"s67\"/>");
	wb.println("      <Cell ss:StyleID=\"s67\"/>");
	wb.println("      <Cell ss:StyleID=\"s68\"/>");
	wb.println("      <Cell ss:StyleID=\"s68\"/>");
	wb.println("      <Cell ss:StyleID=\"s71\"/>");
	wb.println("      <Cell ss:StyleID=\"s71\"/>");
	wb.println("      <Cell ss:StyleID=\"s71\"/>");
	wb.println("      </Row>");
	wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"2.25\">");
	wb.println("      <Cell ss:StyleID=\"s69\"/>");
	wb.println("      <Cell ss:StyleID=\"s69\"/>");
	wb.println("      <Cell ss:StyleID=\"s67\"/>");
	wb.println("      <Cell ss:StyleID=\"s67\"/>");
	wb.println("      <Cell ss:StyleID=\"s63\"/>");
	wb.println("      <Cell ss:StyleID=\"s63\"/>");
	wb.println("      <Cell ss:StyleID=\"s63\"/>");
	wb.println("      <Cell ss:StyleID=\"s63\"/>");
	wb.println("      <Cell ss:StyleID=\"s63\"/>");
	wb.println("      <Cell ss:StyleID=\"s67\"/>");
	wb.println("      <Cell ss:StyleID=\"s67\"/>");
	wb.println("      <Cell ss:StyleID=\"s67\"/>");
	wb.println("      <Cell ss:StyleID=\"s67\"/>");
	wb.println("      <Cell ss:StyleID=\"s67\"/>");
	wb.println("      <Cell ss:StyleID=\"s68\"/>");
	wb.println("      <Cell ss:StyleID=\"s68\"/>");
	wb.println("      <Cell ss:StyleID=\"s71\"/>");
	wb.println("      <Cell ss:StyleID=\"s71\"/>");
	wb.println("      <Cell ss:StyleID=\"s71\"/>");
	wb.println("      </Row>");
	wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"15.75\">");
String vnamex = "";
String vnamex2="";
String vnameBong = "";
String vnameBong2="";
int posisix;
int posisiBong;
if(name != null && name.length() > 0){
    if(name.length() > 21){
        vnamex=name.substring(0, 21);
        posisix= name.lastIndexOf(" ");
        vnamex = name.substring(0, posisix);
        vnamex2 = name.substring(posisix+1, name.length());
    }else{
        vnamex = name;
    }
}
if(nameVendor != null && nameVendor.length() > 0){
    if(nameVendor.length() > 21){
        vnameBong=nameVendor.substring(0, 21);
        posisiBong= nameVendor.lastIndexOf(" ");
        vnameBong = nameVendor.substring(0, posisiBong);
        vnameBong2 = nameVendor.substring(posisiBong+1, nameVendor.length());
    }else{
        vnameBong = nameVendor;
    }
}
	wb.println("      <Cell ss:StyleID=\"s72\"><Data ss:Type=\"String\">"+ vnameBong +"</Data></Cell>");
	wb.println("      <Cell ss:StyleID=\"s72\"/>");
	wb.println("      <Cell ss:StyleID=\"s67\"/>");
	wb.println("      <Cell ss:StyleID=\"s67\"/>");
	wb.println("      <Cell ss:StyleID=\"s63\"/>");
	wb.println("      <Cell ss:StyleID=\"s63\"/>");
	wb.println("      <Cell ss:StyleID=\"s71\"><Data ss:Type=\"String\"> # "+JSPFormater.formatNumber((totBG - jmlMaterai), "###,###")+" #</Data></Cell>");
	wb.println("      <Cell ss:StyleID=\"s63\"/>");
	wb.println("      <Cell ss:StyleID=\"s63\"/>");
	wb.println("      <Cell ss:StyleID=\"s63\"/>");
	wb.println("      <Cell ss:StyleID=\"s71\"/>");
String speel = "";
try{
    String a = JSPFormater.formatNumber((totBG - jmlMaterai), "#,###");
    NumberSpeller numberSpeller = new NumberSpeller();
    String u = a.replaceAll(",", "");
    speel = numberSpeller.spellNumberToIna(Double.parseDouble(u));
}catch(Exception e){}

String desc1 = "";
String desc2 = "";
int posisi;

if(speel != null && speel.length() > 0){
    if(speel.length() > 45){
        desc1 = speel.substring(0, 45);
        posisi= desc1.lastIndexOf(" ");
        desc1= speel.substring(0, posisi);
        desc2 = speel.substring(posisi + 1, speel.length()) + " Rupiah";
    }else{
        desc1 = speel + " Rupiah";
    }
}
	wb.println("      <Cell ss:Index=\"13\" ss:StyleID=\"s73\"><Data ss:Type=\"String\"> "+ desc1 +"</Data></Cell>");
	wb.println("      <Cell ss:StyleID=\"s63\"/>");
	wb.println("      <Cell ss:StyleID=\"s74\"/>");
	wb.println("      <Cell ss:StyleID=\"s74\"/>");
	wb.println("      <Cell ss:StyleID=\"s74\"/>");
	wb.println("      <Cell ss:StyleID=\"s74\"/>");
	wb.println("      <Cell ss:StyleID=\"s74\"/>");
	wb.println("      <Cell ss:StyleID=\"s68\"/>");
	wb.println("      </Row>");
	wb.println("      <Row ss:AutoFitHeight=\"0\">");
	wb.println("      <Cell ss:StyleID=\"s75\"><Data ss:Type=\"String\">  "+ vnameBong2 +"</Data></Cell>");
	wb.println("      <Cell ss:StyleID=\"s76\"/>");
	wb.println("      <Cell ss:StyleID=\"s63\"/>");
	wb.println("      <Cell ss:StyleID=\"s73\"><Data ss:Type=\"String\">    "+ desc2 +"</Data></Cell>");
	wb.println("      <Cell ss:Index=\"6\" ss:StyleID=\"s73\"/>");
	wb.println("      <Cell ss:StyleID=\"s73\"/>");
	wb.println("      <Cell ss:StyleID=\"s63\"/>");
	wb.println("      <Cell ss:StyleID=\"s73\"/>");
	wb.println("      <Cell ss:StyleID=\"s73\"/>");
	wb.println("      <Cell ss:StyleID=\"s73\"/>");
	wb.println("      <Cell ss:StyleID=\"s73\"/>");
	wb.println("      <Cell ss:StyleID=\"s73\"/>");
	wb.println("      <Cell ss:StyleID=\"s73\"/>");
	wb.println("      <Cell ss:StyleID=\"s77\"/>");
	wb.println("      <Cell ss:StyleID=\"s77\"/>");
	wb.println("      <Cell ss:StyleID=\"s77\"/>");
	wb.println("      <Cell ss:StyleID=\"s77\"/>");
	wb.println("      <Cell ss:StyleID=\"s77\"/>");
	wb.println("      <Cell ss:StyleID=\"s68\"/>");
	wb.println("      </Row>");
	wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"4.5\">");
	wb.println("      <Cell ss:MergeDown=\"1\" ss:StyleID=\"s79\"/>");
	wb.println("      <Cell ss:StyleID=\"s76\"/>");
	wb.println("      <Cell ss:StyleID=\"s63\"/>");
	wb.println("      <Cell ss:StyleID=\"s73\"/>");
	wb.println("      <Cell ss:Index=\"6\" ss:StyleID=\"s73\"/>");
	wb.println("      <Cell ss:StyleID=\"s73\"/>");
	wb.println("      <Cell ss:StyleID=\"s63\"/>");
	wb.println("      <Cell ss:StyleID=\"s73\"/>");
	wb.println("      <Cell ss:StyleID=\"s73\"/>");
	wb.println("      <Cell ss:StyleID=\"s73\"/>");
	wb.println("      <Cell ss:StyleID=\"s73\"/>");
	wb.println("      <Cell ss:StyleID=\"s73\"/>");
	wb.println("      <Cell ss:StyleID=\"s73\"/>");
	wb.println("      <Cell ss:StyleID=\"s77\"/>");
	wb.println("      <Cell ss:StyleID=\"s77\"/>");
	wb.println("      <Cell ss:StyleID=\"s77\"/>");
	wb.println("      <Cell ss:StyleID=\"s77\"/>");
	wb.println("      <Cell ss:StyleID=\"s77\"/>");
	wb.println("      <Cell ss:StyleID=\"s68\"/>");
	wb.println("      </Row>");
	wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"12.75\">");
	wb.println("      <Cell ss:Index=\"2\" ss:StyleID=\"s76\"/>");
	wb.println("      <Cell ss:StyleID=\"s67\"/>");
	wb.println("      <Cell ss:StyleID=\"s67\"/>");
	wb.println("      <Cell ss:StyleID=\"s67\"/>");
	wb.println("      <Cell ss:StyleID=\"s67\"/>");
	wb.println("      <Cell ss:StyleID=\"s67\"/>");
	wb.println("      <Cell ss:StyleID=\"s67\"/>");
	wb.println("      <Cell ss:StyleID=\"s67\"/>");
	wb.println("      <Cell ss:StyleID=\"s67\"/>");
	wb.println("      <Cell ss:StyleID=\"s67\"/>");
	wb.println("      <Cell ss:StyleID=\"s80\"><Data ss:Type=\"String\">  "+ vnamex +" </Data></Cell>");
	wb.println("      <Cell ss:StyleID=\"s80\"/>");
	wb.println("      <Cell ss:StyleID=\"s80\"/>");
	wb.println("      <Cell ss:StyleID=\"s68\"/>");
	wb.println("      <Cell ss:StyleID=\"s68\"/>");
	wb.println("      <Cell ss:StyleID=\"s68\"/>");
	wb.println("      <Cell ss:StyleID=\"s68\"/>");
	wb.println("      <Cell ss:StyleID=\"s68\"/>");
	wb.println("      <Cell ss:StyleID=\"s68\"/>");
	wb.println("      </Row>");
	wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"12.75\">");
	wb.println("      <Cell ss:StyleID=\"s82\"><Data ss:Type=\"String\">Budget   :</Data></Cell>");
	wb.println("      <Cell ss:StyleID=\"s85\"><Data ss:Type=\"Number\">"+ JSPFormater.formatNumber(totBG, "###,###") +"</Data></Cell>");
	wb.println("      <Cell ss:StyleID=\"s67\"/>");
	wb.println("      <Cell ss:StyleID=\"s67\"/>");
	wb.println("      <Cell ss:StyleID=\"s63\"/>");
	wb.println("      <Cell ss:StyleID=\"s63\"/>");
	wb.println("      <Cell ss:StyleID=\"s63\"/>");
	wb.println("      <Cell ss:StyleID=\"s63\"/>");
	wb.println("      <Cell ss:StyleID=\"s63\"/>");
	wb.println("      <Cell ss:StyleID=\"s63\"/>");
	wb.println("      <Cell ss:StyleID=\"s63\"/>");
	wb.println("      <Cell ss:MergeAcross=\"2\" ss:StyleID=\"s84\"><Data ss:Type=\"String\">"+ vnamex2 +"</Data></Cell>");
	wb.println("      </Row>");
	wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"10.5\">");
	wb.println("      <Cell ss:StyleID=\"s63\"><Data ss:Type=\"String\">Materai : </Data></Cell>");
	wb.println("      <Cell ss:StyleID=\"s85\"><Data ss:Type=\"Number\">"+ JSPFormater.formatNumber(jmlMaterai, "#,###")+"</Data></Cell>");
	wb.println("      <Cell ss:StyleID=\"s68\"/>");
	wb.println("      <Cell ss:StyleID=\"s68\"/>");
	wb.println("      </Row>");
	wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"11.25\">");
	wb.println("      <Cell ss:StyleID=\"s63\"><Data ss:Type=\"String\">Total      :</Data></Cell>");
	wb.println("      <Cell ss:StyleID=\"s85\"><Data ss:Type=\"Number\">"+JSPFormater.formatNumber((totBG - jmlMaterai), "###,###")+"</Data></Cell>");
	wb.println("      <Cell ss:StyleID=\"s68\"/>");
	wb.println("      <Cell ss:StyleID=\"s68\"/>");
	wb.println("      <Cell ss:Index=\"14\" ss:StyleID=\"s68\"/>");
	wb.println("      <Cell ss:StyleID=\"s68\"/>");
	wb.println("      <Cell ss:StyleID=\"s68\"/>");
	wb.println("      <Cell ss:StyleID=\"s68\"/>");
	wb.println("      <Cell ss:StyleID=\"s68\"/>");
	wb.println("      <Cell ss:StyleID=\"s68\"/>");
	wb.println("      <Cell ss:StyleID=\"s68\"/>");
	wb.println("      </Row>");
	wb.println("      <Row ss:AutoFitHeight=\"0\">");
	wb.println("      <Cell ss:StyleID=\"s63\"/>");
	wb.println("      <Cell ss:Index=\"3\" ss:StyleID=\"s68\"/>");
	wb.println("      <Cell ss:StyleID=\"s68\"/>");
	wb.println("      <Cell ss:Index=\"14\" ss:StyleID=\"s67\"><Data ss:Type=\"String\"></Data></Cell>");
	wb.println("      <Cell ss:StyleID=\"s68\"/>");
	wb.println("      <Cell ss:StyleID=\"s68\"/>");
	wb.println("      <Cell ss:StyleID=\"s68\"/>");
	wb.println("      </Row>");
	wb.println("      <Row ss:AutoFitHeight=\"0\">");
	wb.println("      <Cell ss:StyleID=\"s67\"/>");
	wb.println("      <Cell ss:StyleID=\"s68\"/>");
	wb.println("      <Cell ss:StyleID=\"s68\"/>");
	wb.println("      <Cell ss:StyleID=\"s68\"/>");
	wb.println("      </Row>");
	wb.println("      </Table>");
	wb.println("      <WorksheetOptions xmlns=\"urn:schemas-microsoft-com:office:excel\">");
	wb.println("      <PageSetup>");
	wb.println("      <Layout x:Orientation=\"Landscape\"/>");
	wb.println("      <Header x:Margin=\"0.19685039370078741\"/>");
	wb.println("      <Footer x:Margin=\"0.19685039370078741\"/>");
	wb.println("      <PageMargins x:Bottom=\"0\" x:Left=\"0.51181102362204722\"");
	wb.println("      x:Right=\"0.70866141732283472\" x:Top=\"5.1181102362204731\"/>");
	wb.println("      </PageSetup>");
	wb.println("      <Unsynced/>");
	wb.println("      <Print>");
	wb.println("      <ValidPrinterInfo/>");
	wb.println("      <PaperSizeIndex>9</PaperSizeIndex>");
	wb.println("      <HorizontalResolution>-3</HorizontalResolution>");
	wb.println("      <VerticalResolution>0</VerticalResolution>");
	wb.println("      </Print>");
	wb.println("      <Selected/>");
	wb.println("      <DoNotDisplayGridlines/>");
	wb.println("      <Panes>");
	wb.println("      <Pane>");
	wb.println("      <Number>3</Number>");
	wb.println("      <ActiveRow>18</ActiveRow>");
	wb.println("      <ActiveCol>3</ActiveCol>");
	wb.println("      </Pane>");
	wb.println("      </Panes>");
	wb.println("      <ProtectObjects>False</ProtectObjects>");
	wb.println("      <ProtectScenarios>False</ProtectScenarios>");
	wb.println("      </WorksheetOptions>");
	wb.println("      </Worksheet>");
	wb.println("      </Workbook>");
	wb.println("      ");

        wb.flush();
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

    public static void main(String[] arg) {
        try {
            String str = "";

            System.out.println(URLEncoder.encode(str, "UTF-8"));
        } catch (Exception e) {
            System.out.println(e.toString());
        }
    }

}
