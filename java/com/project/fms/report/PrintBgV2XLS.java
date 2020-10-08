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
/**
 *
 * @author Roy
 */
public class PrintBgV2XLS extends HttpServlet {

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
    
    public static double getAmountMaterai(long bankId,long coaId){
        double result = 0;
        CONResultSet crs = null;
        try{
            String sql = "select sum(ri.qty * ri.amount)*-1 as total from bankpo_payment_detail bpd inner join pos_receive r on bpd.invoice_id = r.receive_id inner join pos_receive_item ri on r.receive_id = ri.receive_id where bpd.bankpo_payment_id = "+bankId+" and ri.ap_coa_id = "+coaId;
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            
            while(rs.next()){
                result = rs.getDouble("total");
            }         
                    
        }catch(Exception e){
            System.out.println("[exception] "+e.toString());
        }finally{
            CONResultSet.close(crs);
        }
        
        return result;
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
        long bankPoId = JSPRequestValue.requestLong(request, "bankpo_id");
        BankpoPayment bp = new BankpoPayment();
        try{
            bp = DbBankpoPayment.fetchExc(bankPoId);
        }catch(Exception e){}        
        
        long coaId = 0;
        try{
            coaId = Long.parseLong(DbSystemProperty.getValueByName("OID_COA_PENDAPATAN_MATERAI"));
        }catch(Exception e){}
        
        Vector list = DbBankpoPaymentDetail.list(0, 0, DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_BANKPO_PAYMENT_ID]+" = "+bp.getOID(), null);
        double total = 0;
        double totalMaterai = 0;
        if(list != null && list.size() > 0){
            for(int i = 0 ; i < list.size() ; i++){
                BankpoPaymentDetail bpd = (BankpoPaymentDetail)list.get(i);
                total = total + bpd.getPaymentAmount();
            }
        }
        
        //==========Pengambilan data TT untuk mendapatkan apa ada materainya
        BankpoPayment bpTT = new BankpoPayment();
        String desc = "";
        String name = "";
        try{
            if(bp.getRefId() != 0){
                bpTT = DbBankpoPayment.fetchExc(bp.getRefId());   
                if(bpTT.getVendorId() != 0){
                    Vendor v = new Vendor();
                    try{
                        v = DbVendor.fetchExc(bpTT.getVendorId());
                        if(v.getIsPKP() == 1){
                            desc = "SUP. PKP";
                        }else{
                            desc = "SUP. NON PKP";
                        }
                        name = v.getName();
                    }catch(Exception e){}                    
                }
                
                if(bpTT.getOID() != 0 && coaId != 0){
                   totalMaterai = getAmountMaterai(bpTT.getOID(),coaId);
                }
            }
        }catch(Exception e){}

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
	wb.println("      <LastAuthor>Roy</LastAuthor>");
	wb.println("      <LastPrinted>2015-06-26T07:04:35Z</LastPrinted>");
	wb.println("      <Created>2015-06-22T01:15:56Z</Created>");
	wb.println("      <LastSaved>2015-07-03T02:51:40Z</LastSaved>");
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
	wb.println("      <NumberFormat ss:Format=\"_(* #,##0.00_);_(* \\(#,##0.00\\);_(* &quot;-&quot;??_);_(@_)\"/>");
	wb.println("      </Style>");
	wb.println("      <Style ss:ID=\"s58\">");
	wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Color=\"#000000\"/>");
	wb.println("      </Style>");
	wb.println("      <Style ss:ID=\"s59\">");
	wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Color=\"#FFFFFF\"/>");
	wb.println("      </Style>");
	wb.println("      <Style ss:ID=\"s60\">");
	wb.println("      <Font ss:FontName=\"Consolas\" x:Family=\"Modern\" ss:Size=\"12\" ss:Color=\"#000000\"");
	wb.println("      ss:Bold=\"1\"/>");
	wb.println("      </Style>");
	wb.println("      <Style ss:ID=\"s62\">");
	wb.println("      <Borders/>");
	wb.println("      </Style>");
	wb.println("      <Style ss:ID=\"s63\">");
	wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#FFFFFF\"/>");
	wb.println("      </Style>");
	wb.println("      <Style ss:ID=\"s65\">");
	wb.println("      <Alignment ss:Vertical=\"Bottom\"/>");
	wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Color=\"#FFFFFF\"/>");
	wb.println("      </Style>");
	wb.println("      <Style ss:ID=\"s66\">");
	wb.println("      <Borders/>");
	wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Color=\"#FFFFFF\"/>");
	wb.println("      </Style>");
	wb.println("      <Style ss:ID=\"s68\">");
	wb.println("      <Alignment ss:Vertical=\"Bottom\"/>");
	wb.println("      <Borders/>");
	wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\"/>");
	wb.println("      </Style>");
	wb.println("      <Style ss:ID=\"s69\">");
	wb.println("      <Alignment ss:Vertical=\"Bottom\"/>");
	wb.println("      <Borders/>");
	wb.println("      </Style>");
	wb.println("      <Style ss:ID=\"s70\">");
	wb.println("      <Borders/>");
	wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#FFFFFF\"/>");
	wb.println("      </Style>");
	wb.println("      <Style ss:ID=\"s71\">");
	wb.println("      <Alignment ss:Vertical=\"Bottom\"/>");
	wb.println("      <Borders/>");
	wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"12\" ss:Color=\"#000000\"/>");
	wb.println("      </Style>");
	wb.println("      <Style ss:ID=\"s73\">");
	wb.println("      <Borders/>");
	wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"/>");
	wb.println("      </Style>");
	wb.println("      <Style ss:ID=\"s74\">");
	wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"/>");
	wb.println("      </Style>");
	wb.println("      <Style ss:ID=\"s76\">");
	wb.println("      <Alignment ss:Vertical=\"Bottom\"/>");
	wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"/>");
	wb.println("      </Style>");
	wb.println("      <Style ss:ID=\"s81\" ss:Parent=\"s16\">");
	wb.println("      <Alignment ss:Horizontal=\"Right\" ss:Vertical=\"Bottom\"/>");
	wb.println("      <Borders/>");
	wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"/>");
	wb.println("      <NumberFormat ss:Format=\"_(* #,##0.00_);_(* \\(#,##0.00\\);_(* &quot;-&quot;??_);_(@_)\"/>");
	wb.println("      </Style>");
	wb.println("      <Style ss:ID=\"s82\">");
	wb.println("      <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Top\"/>");
	wb.println("      <Borders/>");
	wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"/>");
	wb.println("      </Style>");
	wb.println("      <Style ss:ID=\"s83\" ss:Parent=\"s16\">");
	wb.println("      <Alignment ss:Horizontal=\"Right\" ss:Vertical=\"Bottom\"/>");
	wb.println("      <Borders/>");
	wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"12\" ss:Color=\"#000000\"/>");
	wb.println("      <NumberFormat ss:Format=\"_(* #,##0.00_);_(* \\(#,##0.00\\);_(* &quot;-&quot;??_);_(@_)\"/>");
	wb.println("      </Style>");
	wb.println("      <Style ss:ID=\"s84\">");
	wb.println("      <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Center\"/>");
	wb.println("      <Borders/>");
	wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"12\" ss:Color=\"#000000\"/>");
	wb.println("      </Style>");
	wb.println("      <Style ss:ID=\"s85\">");
	wb.println("      <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Center\"/>");
	wb.println("      <Borders/>");
	wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"/>");
	wb.println("      </Style>");
	wb.println("      <Style ss:ID=\"s86\">");
	wb.println("      <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Center\"/>");
	wb.println("      <Borders/>");
	wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"/>");
	wb.println("      <NumberFormat ss:Format=\"Short Date\"/>");
	wb.println("      </Style>");
	wb.println("      <Style ss:ID=\"s87\" ss:Parent=\"s16\">");
	wb.println("      <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Top\"/>");
	wb.println("      <Borders/>");
	wb.println("      <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"/>");
	wb.println("      <NumberFormat ss:Format=\"_(* #,##0.00_);_(* \\(#,##0.00\\);_(* &quot;-&quot;??_);_(@_)\"/>");
	wb.println("      </Style>");
	wb.println("      </Styles>");
	wb.println("      <Worksheet ss:Name=\"Sheet1\">");
	wb.println("      <Table ss:ExpandedColumnCount=\"18\" ss:ExpandedRowCount=\"12\" x:FullColumns=\"1\"");
	wb.println("      x:FullRows=\"1\" ss:DefaultRowHeight=\"15\">");
	wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"43.5\"/>");
	wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"45\"/>");
	wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"60\"/>");
	wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"28.5\"/>");
	wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"22.5\"/>");
	wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"69.75\"/>");
	wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"12\"/>");
	wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"90\"/>");
	wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"11.25\"/>");
	wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"36\"/>");
	wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"24\"/>");
	wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"71.25\"/>");
	wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"6.75\"/>");
	wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"37.5\"/>");
	wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"71.25\"/>");
	wb.println("      <Column ss:AutoFitWidth=\"0\" ss:Width=\"11.25\"/>");
	wb.println("      <Column ss:Index=\"18\" ss:AutoFitWidth=\"0\" ss:Width=\"8.25\"/>");
	wb.println("      <Row ss:Index=\"2\" ss:Height=\"15.75\">");
	wb.println("      <Cell ss:StyleID=\"s58\"/>");
	wb.println("      <Cell ss:Index=\"12\" ss:StyleID=\"s59\"><Data ss:Type=\"String\"></Data></Cell>");
	wb.println("      <Cell ss:Index=\"14\" ss:StyleID=\"s60\"/>");
	wb.println("      </Row>");
	wb.println("      <Row>");
	wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s85\"><Data ss:Type=\"String\">"+desc+"</Data></Cell>");
	wb.println("      <Cell ss:StyleID=\"s73\"/>");
	wb.println("      <Cell ss:StyleID=\"s74\"/>");
	wb.println("      <Cell ss:StyleID=\"s74\"/>");
	wb.println("      <Cell ss:StyleID=\"s74\"/>");
	wb.println("      <Cell ss:StyleID=\"s63\"><Data ss:Type=\"String\"></Data></Cell>");
	wb.println("      <Cell ss:StyleID=\"s74\"/>");
	wb.println("      <Cell ss:StyleID=\"s74\"/>");
	wb.println("      <Cell ss:StyleID=\"s74\"/>");
	wb.println("      <Cell ss:StyleID=\"s74\"/>");
	wb.println("      <Cell ss:StyleID=\"s73\"/>");
	wb.println("      <Cell ss:StyleID=\"s63\"><Data ss:Type=\"String\" x:Ticked=\"1\">,</Data></Cell>");
	wb.println("      <Cell ss:StyleID=\"s62\"/>");
	wb.println("      <Cell ss:StyleID=\"s62\"/>");
	wb.println("      <Cell ss:StyleID=\"s62\"/>");
	wb.println("      <Cell ss:StyleID=\"s62\"/>");
	wb.println("      <Cell ss:StyleID=\"s62\"/>");
	wb.println("      </Row>");
	wb.println("      <Row>");
	wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s86\"><Data ss:Type=\"String\">"+JSPFormater.formatDate(bp.getTransDate(), "dd-MM-yyyy")+"</Data></Cell>");
	wb.println("      <Cell ss:StyleID=\"s73\"/>");
	wb.println("      <Cell ss:StyleID=\"s63\"/>");
	wb.println("      <Cell ss:StyleID=\"s74\"/>");
	wb.println("      <Cell ss:StyleID=\"s74\"/>");
	wb.println("      <Cell ss:StyleID=\"s74\"/>");
	wb.println("      <Cell ss:StyleID=\"s73\"/>");
	wb.println("      <Cell ss:StyleID=\"s73\"/>");
	wb.println("      <Cell ss:StyleID=\"s73\"/>");
	wb.println("      <Cell ss:StyleID=\"s73\"/>");
	wb.println("      <Cell ss:StyleID=\"s73\"/>");
	wb.println("      <Cell ss:StyleID=\"s62\"/>");
	wb.println("      <Cell ss:StyleID=\"s62\"/>");
	wb.println("      <Cell ss:StyleID=\"s65\"/>");
	wb.println("      <Cell ss:StyleID=\"s65\"/>");
	wb.println("      <Cell ss:StyleID=\"s65\"/>");
	wb.println("      </Row>");
	wb.println("      <Row ss:Height=\"15.75\">");
	wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s85\"><Data ss:Type=\"String\">"+name+"</Data></Cell>");
	wb.println("      <Cell ss:StyleID=\"s73\"/>");
	wb.println("      <Cell ss:StyleID=\"s74\"/>");
	wb.println("      <Cell ss:StyleID=\"s76\"><Data ss:Type=\"String\"> # "+JSPFormater.formatNumber(total, "###,###.##")+" #</Data></Cell>");
	wb.println("      <Cell ss:StyleID=\"s74\"/>");
	wb.println("      <Cell ss:StyleID=\"s74\"/>");
	wb.println("      <Cell ss:StyleID=\"s74\"/>");
	wb.println("      <Cell ss:StyleID=\"s76\"/>");
	wb.println("      <Cell ss:StyleID=\"s76\"/>");
	wb.println("      <Cell ss:StyleID=\"s63\"><Data ss:Type=\"String\">(</Data></Cell>");
	wb.println("      <Cell ss:StyleID=\"s74\"/>");
	wb.println("      <Cell ss:StyleID=\"s71\"/>");
	wb.println("      <Cell ss:StyleID=\"s71\"/>");
	wb.println("      <Cell ss:StyleID=\"s71\"/>");
	wb.println("      <Cell ss:StyleID=\"s71\"/>");
	wb.println("      <Cell ss:StyleID=\"s71\"/>");
	wb.println("      <Cell ss:StyleID=\"s62\"/>");
	wb.println("      </Row>");
        String speel = "";
        try{
            String a = JSPFormater.formatNumber((total), "#,###");
            NumberSpeller numberSpeller = new NumberSpeller();
            String u = a.replaceAll(",", "");
            speel = numberSpeller.spellNumberToIna(Double.parseDouble(u));
        }catch(Exception e){}
	wb.println("      <Row>");
	wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s87\"><Data ss:Type=\"Number\">"+JSPFormater.formatNumber(total, "###,###.##")+"</Data></Cell>");
	wb.println("      <Cell ss:StyleID=\"s74\"/>");
	wb.println("      <Cell ss:StyleID=\"s69\"><Data ss:Type=\"String\">"+speel+"</Data></Cell>");
	wb.println("      <Cell ss:StyleID=\"s68\"/>");
	wb.println("      <Cell ss:StyleID=\"s74\"/>");
	wb.println("      <Cell ss:StyleID=\"s68\"/>");
	wb.println("      <Cell ss:StyleID=\"s68\"/>");
	wb.println("      <Cell ss:StyleID=\"s68\"/>");
	wb.println("      <Cell ss:StyleID=\"s68\"/>");
	wb.println("      <Cell ss:StyleID=\"s68\"/>");
	wb.println("      <Cell ss:StyleID=\"s68\"/>");
	wb.println("      <Cell ss:StyleID=\"s68\"/>");
	wb.println("      <Cell ss:StyleID=\"s69\"><Data ss:Type=\"String\"></Data></Cell>");
	wb.println("      <Cell ss:StyleID=\"s69\"/>");
	wb.println("      <Cell ss:StyleID=\"s69\"/>");
	wb.println("      <Cell ss:StyleID=\"s69\"/>");
	wb.println("      <Cell ss:StyleID=\"s70\"><Data ss:Type=\"String\"></Data></Cell>");
	wb.println("      </Row>");
	wb.println("      <Row ss:AutoFitHeight=\"0\" ss:Height=\"15.75\">");
	wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s81\"><Data ss:Type=\"String\"></Data></Cell>");
	wb.println("      <Cell ss:StyleID=\"s73\"/>");
	wb.println("      <Cell ss:StyleID=\"s73\"/>");
	wb.println("      <Cell ss:StyleID=\"s73\"/>");
	wb.println("      <Cell ss:StyleID=\"s73\"/>");
	wb.println("      <Cell ss:StyleID=\"s73\"/>");
	wb.println("      <Cell ss:StyleID=\"s73\"/>");
	wb.println("      <Cell ss:StyleID=\"s73\"/>");
	wb.println("      <Cell ss:MergeAcross=\"2\" ss:StyleID=\"s82\"><Data ss:Type=\"String\">"+name+"</Data></Cell>");
	wb.println("      <Cell ss:StyleID=\"s62\"/>");
	wb.println("      <Cell ss:StyleID=\"s70\"/>");
	wb.println("      <Cell ss:StyleID=\"s70\"/>");
	wb.println("      <Cell ss:StyleID=\"s70\"/>");
	wb.println("      <Cell ss:StyleID=\"s70\"/>");
	wb.println("      <Cell ss:StyleID=\"s70\"/>");
	wb.println("      </Row>");
	wb.println("      <Row ss:Height=\"15.75\">");
	wb.println("      <Cell ss:MergeAcross=\"1\" ss:StyleID=\"s83\"><Data ss:Type=\"String\"></Data></Cell>");
	wb.println("      <Cell ss:StyleID=\"s62\"/>");
	wb.println("      <Cell ss:Index=\"10\" ss:MergeAcross=\"2\" ss:StyleID=\"s84\"><Data ss:Type=\"String\"></Data></Cell>");
	wb.println("      </Row>");
	wb.println("      <Row>");
	wb.println("      <Cell ss:StyleID=\"s59\"/>");
	wb.println("      <Cell ss:Index=\"3\" ss:StyleID=\"s62\"/>");
	wb.println("      </Row>");
	wb.println("      <Row>");
	wb.println("      <Cell ss:StyleID=\"s59\"/>");
	wb.println("      <Cell ss:Index=\"3\" ss:StyleID=\"s62\"/>");
	wb.println("      <Cell ss:Index=\"12\" ss:StyleID=\"s62\"/>");
	wb.println("      <Cell ss:StyleID=\"s62\"/>");
	wb.println("      <Cell ss:StyleID=\"s62\"/>");
	wb.println("      <Cell ss:StyleID=\"s62\"/>");
	wb.println("      <Cell ss:StyleID=\"s62\"/>");
	wb.println("      <Cell ss:StyleID=\"s62\"/>");
	wb.println("      <Cell ss:StyleID=\"s62\"/>");
	wb.println("      </Row>");
	wb.println("      <Row>");
	wb.println("      <Cell ss:StyleID=\"s59\"/>");
	wb.println("      <Cell ss:Index=\"3\" ss:StyleID=\"s62\"/>");
	wb.println("      <Cell ss:Index=\"12\" ss:StyleID=\"s66\"><Data ss:Type=\"String\"></Data></Cell>");
	wb.println("      <Cell ss:StyleID=\"s70\"/>");
	wb.println("      <Cell ss:StyleID=\"s70\"/>");
	wb.println("      <Cell ss:StyleID=\"s70\"/>");
	wb.println("      </Row>");
	wb.println("      <Row>");
	wb.println("      <Cell ss:StyleID=\"s66\"/>");
	wb.println("      <Cell ss:StyleID=\"s62\"/>");
	wb.println("      <Cell ss:StyleID=\"s62\"/>");
	wb.println("      </Row>");
	wb.println("      </Table>");
	wb.println("      <WorksheetOptions xmlns=\"urn:schemas-microsoft-com:office:excel\">");
	wb.println("      <PageSetup>");
	wb.println("      <Header x:Margin=\"0.19685039370078741\"/>");
	wb.println("      <Footer x:Margin=\"0.19685039370078741\"/>");
	wb.println("      <PageMargins x:Bottom=\"0.19685039370078741\" x:Left=\"0.19685039370078741\"");
	wb.println("      x:Right=\"0.19685039370078741\" x:Top=\"0.19685039370078741\"/>");
	wb.println("      </PageSetup>");
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
	wb.println("      <ActiveRow>4</ActiveRow>");
	wb.println("      <ActiveCol>9</ActiveCol>");
	wb.println("      </Pane>");
	wb.println("      </Panes>");
	wb.println("      <ProtectObjects>False</ProtectObjects>");
	wb.println("      <ProtectScenarios>False</ProtectScenarios>");
	wb.println("      </WorksheetOptions>");
	wb.println("      </Worksheet>");
	wb.println("      <Worksheet ss:Name=\"Sheet2\">");
	wb.println("      <Table ss:ExpandedColumnCount=\"1\" ss:ExpandedRowCount=\"1\" x:FullColumns=\"1\"");
	wb.println("      x:FullRows=\"1\" ss:DefaultRowHeight=\"15\">");
	wb.println("      <Row ss:AutoFitHeight=\"0\"/>");
	wb.println("      </Table>");
	wb.println("      <WorksheetOptions xmlns=\"urn:schemas-microsoft-com:office:excel\">");
	wb.println("      <PageSetup>");
	wb.println("      <Header x:Margin=\"0.3\"/>");
	wb.println("      <Footer x:Margin=\"0.3\"/>");
	wb.println("      <PageMargins x:Bottom=\"0.75\" x:Left=\"0.7\" x:Right=\"0.7\" x:Top=\"0.75\"/>");
	wb.println("      </PageSetup>");
	wb.println("      <Unsynced/>");
	wb.println("      <ProtectObjects>False</ProtectObjects>");
	wb.println("      <ProtectScenarios>False</ProtectScenarios>");
	wb.println("      </WorksheetOptions>");
	wb.println("      </Worksheet>");
	wb.println("      <Worksheet ss:Name=\"Sheet3\">");
	wb.println("      <Table ss:ExpandedColumnCount=\"1\" ss:ExpandedRowCount=\"1\" x:FullColumns=\"1\"");
	wb.println("      x:FullRows=\"1\" ss:DefaultRowHeight=\"15\">");
	wb.println("      <Row ss:AutoFitHeight=\"0\"/>");
	wb.println("      </Table>");
	wb.println("      <WorksheetOptions xmlns=\"urn:schemas-microsoft-com:office:excel\">");
	wb.println("      <PageSetup>");
	wb.println("      <Header x:Margin=\"0.3\"/>");
	wb.println("      <Footer x:Margin=\"0.3\"/>");
	wb.println("      <PageMargins x:Bottom=\"0.75\" x:Left=\"0.7\" x:Right=\"0.7\" x:Top=\"0.75\"/>");
	wb.println("      </PageSetup>");
	wb.println("      <Unsynced/>");
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
