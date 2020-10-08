/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.fms.report;

import com.lowagie.text.*;
import com.lowagie.text.pdf.PdfWriter;
import com.lowagie.text.Document;
import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.awt.*;
import java.io.ByteArrayOutputStream;
import java.util.Vector;
import com.lowagie.text.Font;
import com.project.admin.DbUser;
import com.project.admin.User;
import com.project.util.jsp.*;
import com.project.fms.master.*;
import com.project.fms.journal.*;
import com.project.fms.transaction.*;
import com.project.payroll.*;
import com.project.util.*;
import com.project.system.*;
import com.project.general.Company;
import com.project.general.DbCompany;

/**
 *
 * @author Roy Andika
 */
public class RptCashReceivePDF extends HttpServlet {

    /** Initializes the servlet.
     */
    public void init(ServletConfig config) throws ServletException {
        super.init(config);

    }

    /** Destroys the servlet.
     */
    public void destroy() {

    }

    /** Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, java.io.IOException {

        System.out.println("===| RptCashReceive |===");        
        long cashReceiveId = 0;

        CashReceive cashReceive = new CashReceive();
        long userId = 0;        

        try {
            cashReceiveId = JSPRequestValue.requestLong(request, "cash_receive_id");
            cashReceive = DbCashReceive.fetchExc(cashReceiveId);
        } catch (Exception e) {
            System.out.println(e.toString());
        }

        String whereClause = DbCashReceiveDetail.colNames[DbCashReceiveDetail.COL_CASH_RECEIVE_ID] + "=" + cashReceive.getOID();
        Vector vCashReceiveDetail = DbCashReceiveDetail.list(0, 0, whereClause, null);

        Company cmp = new Company();
        try {
            Vector listCompany = DbCompany.list(0, 0, "", "");
            if (listCompany != null && listCompany.size() > 0) {
                cmp = (Company) listCompany.get(0);
            }
        } catch (Exception ext) {
            System.out.println(ext.toString());
        }

        String idr = DbSystemProperty.getValueByName("CURRENCY_CODE_IDR");
        Color border = new Color(0x00, 0x00, 0x00);

        // setting some fonts in the color chosen by the user
        Font fontHeaderBig = new Font(Font.HELVETICA, 14, Font.BOLD, border);
        Font fontHeader = new Font(Font.COURIER, 11, Font.NORMAL, border);
        Color blackColor = new Color(0, 0, 0);
        Color putih = new Color(250, 250, 250);

        Document document = new Document(PageSize.A4, 30, 30, 30, 30);
        ByteArrayOutputStream baos = new ByteArrayOutputStream();

        try {
            // step2.2: creating an instance of the writer
            PdfWriter.getInstance(document, baos);

            // step 3.1: adding some metadata to the document
            document.addSubject("This is a subject.");
            document.addSubject("This is a subject two.");

            document.open();

            //for header =========================================================== 
            int titleHeader[] = {60, 30};

            Table titleTable = new Table(2);

            titleTable.setWidth(100);
            titleTable.setWidths(titleHeader);
            titleTable.setPadding(2);
            titleTable.setBorderColor(new Color(255, 255, 255));
            titleTable.setBorderWidth(0);
            titleTable.setAlignment(1);
            titleTable.setCellpadding(0);
            titleTable.setCellspacing(1);

            Cell titleCellHeader = new Cell(new Chunk("" + cmp.getName(), fontHeader));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));
            titleTable.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk("BUKTI KAS/BANK", fontHeaderBig));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));
            titleTable.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk("" + cmp.getAddress(), fontHeader));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));
            titleTable.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk("P E N E R I M A A N", fontHeader));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));
            titleTable.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk("", fontHeader));
            titleCellHeader.setColspan(2);
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));
            titleTable.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk("", fontHeader));
            titleCellHeader.setColspan(2);
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));
            titleTable.addCell(titleCellHeader);

            document.add(titleTable);


            int titleHeader2[] = {22, 3, 25, 14, 3, 23};

            Table titleTable2 = new Table(6);

            titleTable2.setWidth(100);
            titleTable2.setWidths(titleHeader2);
            titleTable2.setPadding(2);
            titleTable2.setBorderColor(new Color(255, 255, 255));
            titleTable2.setBorderWidth(0);
            titleTable2.setAlignment(1);
            titleTable2.setCellpadding(0);
            titleTable2.setCellspacing(1);

            Cell titleCellHeader2 = new Cell(new Chunk("", fontHeader));
            titleCellHeader2.setColspan(3);
            titleCellHeader2.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHeader2.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader2.setBorderColor(new Color(255, 255, 255));
            titleTable2.addCell(titleCellHeader2);

            titleCellHeader2 = new Cell(new Chunk("No BKM", fontHeader));
            titleCellHeader2.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHeader2.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader2.setBorderColor(new Color(255, 255, 255));
            titleTable2.addCell(titleCellHeader2);

            titleCellHeader2 = new Cell(new Chunk(":", fontHeader));
            titleCellHeader2.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellHeader2.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader2.setBorderColor(new Color(255, 255, 255));
            titleTable2.addCell(titleCellHeader2);

            titleCellHeader2 = new Cell(new Chunk("" + cashReceive.getJournalNumber(), fontHeader));
            titleCellHeader2.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHeader2.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader2.setBorderColor(new Color(255, 255, 255));
            titleTable2.addCell(titleCellHeader2);

            titleCellHeader2 = new Cell(new Chunk("", fontHeader));
            titleCellHeader2.setColspan(3);
            titleCellHeader2.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHeader2.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader2.setBorderColor(new Color(255, 255, 255));
            titleTable2.addCell(titleCellHeader2);

            titleCellHeader2 = new Cell(new Chunk("Tanggal", fontHeader));
            titleCellHeader2.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHeader2.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader2.setBorderColor(new Color(255, 255, 255));
            titleTable2.addCell(titleCellHeader2);

            titleCellHeader2 = new Cell(new Chunk(":", fontHeader));
            titleCellHeader2.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellHeader2.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader2.setBorderColor(new Color(255, 255, 255));
            titleTable2.addCell(titleCellHeader2);

            titleCellHeader2 = new Cell(new Chunk("" + JSPFormater.formatDate(cashReceive.getTransDate(), "dd-MM-yyyy"), fontHeader));
            titleCellHeader2.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHeader2.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader2.setBorderColor(new Color(255, 255, 255));
            titleTable2.addCell(titleCellHeader2);

            titleCellHeader2 = new Cell(new Chunk("Diterima Dari", fontHeader));
            titleCellHeader2.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHeader2.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader2.setBorderColor(new Color(255, 255, 255));
            titleTable2.addCell(titleCellHeader2);

            titleCellHeader2 = new Cell(new Chunk(":", fontHeader));
            titleCellHeader2.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellHeader2.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader2.setBorderColor(new Color(255, 255, 255));
            titleTable2.addCell(titleCellHeader2);

            String cst = "";

            try {
                cst = cashReceive.getReceiveFromName();
            } catch (Exception e) {
                System.out.println("[exception] " + e.toString());
            }

            titleCellHeader2 = new Cell(new Chunk(" " + cst, fontHeader));
            titleCellHeader2.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHeader2.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader2.setBorderColor(new Color(255, 255, 255));
            titleTable2.addCell(titleCellHeader2);

            titleCellHeader2 = new Cell(new Chunk("Periode", fontHeader));
            titleCellHeader2.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHeader2.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader2.setBorderColor(new Color(255, 255, 255));
            titleTable2.addCell(titleCellHeader2);

            titleCellHeader2 = new Cell(new Chunk(":", fontHeader));
            titleCellHeader2.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellHeader2.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader2.setBorderColor(new Color(255, 255, 255));
            titleTable2.addCell(titleCellHeader2);

            int val_periode = cashReceive.getTransDate().getMonth() + 1;

            titleCellHeader2 = new Cell(new Chunk("" + val_periode, fontHeader));
            titleCellHeader2.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHeader2.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader2.setBorderColor(new Color(255, 255, 255));
            titleTable2.addCell(titleCellHeader2);

            titleCellHeader2 = new Cell(new Chunk("Jumlah dgn. angka", fontHeader));
            titleCellHeader2.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHeader2.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader2.setBorderColor(new Color(255, 255, 255));
            titleTable2.addCell(titleCellHeader2);

            titleCellHeader2 = new Cell(new Chunk(":", fontHeader));
            titleCellHeader2.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellHeader2.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader2.setBorderColor(new Color(255, 255, 255));
            titleTable2.addCell(titleCellHeader2);

            NumberSpeller numberSpeller = new NumberSpeller();
            String amount = JSPFormater.formatNumber(cashReceive.getAmount(), "#,###.##");

            titleCellHeader2 = new Cell(new Chunk(" " + idr + " " + JSPFormater.formatNumber(cashReceive.getAmount(), "#,###.##"), fontHeader));
            titleCellHeader2.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHeader2.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader2.setBorderColor(new Color(255, 255, 255));
            titleTable2.addCell(titleCellHeader2);

            titleCellHeader2 = new Cell(new Chunk("", fontHeader));
            titleCellHeader2.setColspan(3);
            titleCellHeader2.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHeader2.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader2.setBorderColor(new Color(255, 255, 255));
            titleTable2.addCell(titleCellHeader2);

            titleCellHeader2 = new Cell(new Chunk("       dgn. hurup", fontHeader));
            titleCellHeader2.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHeader2.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader2.setBorderColor(new Color(255, 255, 255));
            titleTable2.addCell(titleCellHeader2);

            titleCellHeader2 = new Cell(new Chunk(":", fontHeader));
            titleCellHeader2.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellHeader2.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader2.setBorderColor(new Color(255, 255, 255));
            titleTable2.addCell(titleCellHeader2);

            titleCellHeader2 = new Cell(new Chunk("" + numberSpeller.spellNumberToIna(Double.parseDouble(amount.replaceAll(",", ""))) + " Rupiah", fontHeader));
            titleCellHeader2.setColspan(4);
            titleCellHeader2.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHeader2.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader2.setBorderColor(new Color(255, 255, 255));
            titleTable2.addCell(titleCellHeader2);

            titleCellHeader2 = new Cell(new Chunk("Terima Berupa", fontHeader));
            titleCellHeader2.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHeader2.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader2.setBorderColor(new Color(255, 255, 255));
            titleTable2.addCell(titleCellHeader2);

            titleCellHeader2 = new Cell(new Chunk(":", fontHeader));
            titleCellHeader2.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellHeader2.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader2.setBorderColor(new Color(255, 255, 255));
            titleTable2.addCell(titleCellHeader2);

            titleCellHeader2 = new Cell(new Chunk(" No Cek", fontHeader));
            titleCellHeader2.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHeader2.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader2.setBorderColor(new Color(255, 255, 255));
            titleTable2.addCell(titleCellHeader2);

            titleCellHeader2 = new Cell(new Chunk("", fontHeader));
            titleCellHeader2.setColspan(3);
            titleCellHeader2.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHeader2.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader2.setBorderColor(new Color(255, 255, 255));
            titleTable2.addCell(titleCellHeader2);

            titleCellHeader2 = new Cell(new Chunk("", fontHeader));
            titleCellHeader2.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHeader2.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader2.setBorderColor(new Color(255, 255, 255));
            titleTable2.addCell(titleCellHeader2);

            titleCellHeader2 = new Cell(new Chunk("", fontHeader));
            titleCellHeader2.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellHeader2.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader2.setBorderColor(new Color(255, 255, 255));
            titleTable2.addCell(titleCellHeader2);

            titleCellHeader2 = new Cell(new Chunk(" Cash", fontHeader));
            titleCellHeader2.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHeader2.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader2.setBorderColor(new Color(255, 255, 255));
            titleTable2.addCell(titleCellHeader2);

            titleCellHeader2 = new Cell(new Chunk("", fontHeader));
            titleCellHeader2.setColspan(3);
            titleCellHeader2.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHeader2.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader2.setBorderColor(new Color(255, 255, 255));
            titleTable2.addCell(titleCellHeader2);
            
            titleCellHeader2 = new Cell(new Chunk("", fontHeader));
            titleCellHeader2.setColspan(6);
            titleCellHeader2.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHeader2.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader2.setBorderColor(new Color(255, 255, 255));
            titleTable2.addCell(titleCellHeader2);

            document.add(titleTable2);

            if (vCashReceiveDetail != null && vCashReceiveDetail.size() > 0) {

                int poHeaderTop[] = {5, 29, 33, 23, 30}; //8

                Table prTable = new Table(5);
                prTable.setWidth(100);
                prTable.setWidths(poHeaderTop);
                prTable.setBorderColor(blackColor);
                prTable.setBorderWidth(1);
                prTable.setAlignment(1);
                prTable.setCellpadding(0);
                prTable.setCellspacing(1);

                Cell titlePrCellTop = new Cell(new Chunk("NO", fontHeader));
                titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
                titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTop.setBorderColor(blackColor);
                titlePrCellTop.setBorderWidth(1);
                prTable.addCell(titlePrCellTop);

                titlePrCellTop = new Cell(new Chunk("SEGMEN", fontHeader));
                titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
                titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTop.setBorderColor(blackColor);
                titlePrCellTop.setBorderWidth(1);
                prTable.addCell(titlePrCellTop);

                titlePrCellTop = new Cell(new Chunk("PERINCIAN", fontHeader));
                titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
                titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTop.setBorderColor(blackColor);
                titlePrCellTop.setBorderWidth(1);
                prTable.addCell(titlePrCellTop);

                titlePrCellTop = new Cell(new Chunk("JUMLAH", fontHeader));
                titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
                titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTop.setBorderColor(blackColor);
                titlePrCellTop.setBorderWidth(1);
                prTable.addCell(titlePrCellTop);

                titlePrCellTop = new Cell(new Chunk("PENJELASAN", fontHeader));
                titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
                titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTop.setBorderColor(blackColor);
                titlePrCellTop.setBorderWidth(1);
                prTable.addCell(titlePrCellTop);

                double total = 0;

                for (int i = 0; i < vCashReceiveDetail.size(); i++) {

                    CashReceiveDetail cashReceiveDetail = (CashReceiveDetail) vCashReceiveDetail.get(i);
                    int page = i + 1;
                    
                    String nama = "-";
                    String penjelasan = "";

                    if (cashReceiveDetail.getMemo().length() > 0) {
                        penjelasan = cashReceiveDetail.getMemo();
                    }

                    Vector result = new Vector();
                    String strAmount = "";

                    if (cashReceiveDetail.getAmount() == 0) {
                        strAmount = "(" + JSPFormater.formatNumber(cashReceiveDetail.getCreditAmount(), "#,###.##") + ")";
                    } else {
                        strAmount = JSPFormater.formatNumber(cashReceiveDetail.getAmount(), "#,###.##");
                    }

                    total = total + cashReceiveDetail.getAmount();

                    try {
                        if (cashReceiveDetail.getCoaId() != 0) {
                            result = DbCashReceiveDetail.getCodeCoa(cashReceiveDetail.getCoaId());
                            nama = "" + result.get(0)+" - "+result.get(1);                            
                        }
                    } catch (Exception e) {
                        System.out.println("[exception] " + e.toString());
                    }
                    
                    String segment ="";
                    if(cashReceiveDetail.getSegment1Id() != 0){
                        SegmentDetail sd1 = new SegmentDetail();
                        try{
                            sd1 = DbSegmentDetail.fetchExc(cashReceiveDetail.getSegment1Id());
                        }catch(Exception e){}
                        
                        segment = segment + sd1.getName();
                    }
                    
                    if(cashReceiveDetail.getSegment2Id() != 0){
                        SegmentDetail sd2 = new SegmentDetail();
                        try{
                            sd2 = DbSegmentDetail.fetchExc(cashReceiveDetail.getSegment2Id());
                        }catch(Exception e){}
                        
                        segment = segment +" | "+ sd2.getName();
                    }
                    
                    if(cashReceiveDetail.getSegment3Id() != 0){
                        SegmentDetail sd3 = new SegmentDetail();
                        try{
                            sd3 = DbSegmentDetail.fetchExc(cashReceiveDetail.getSegment3Id());
                        }catch(Exception e){}
                        
                        segment = segment +" | "+ sd3.getName();
                    }
                    
                    if(cashReceiveDetail.getSegment4Id() != 0){
                        SegmentDetail sd4 = new SegmentDetail();
                        try{
                            sd4 = DbSegmentDetail.fetchExc(cashReceiveDetail.getSegment4Id());
                        }catch(Exception e){}
                        
                        segment = segment +" | "+ sd4.getName();
                    }
                    
                    if(cashReceiveDetail.getSegment5Id() != 0){
                        SegmentDetail sd5 = new SegmentDetail();
                        try{
                            sd5 = DbSegmentDetail.fetchExc(cashReceiveDetail.getSegment5Id());
                        }catch(Exception e){}
                        
                        segment = segment +" | "+ sd5.getName();
                    }
                    
                    if(cashReceiveDetail.getSegment6Id() != 0){
                        SegmentDetail sd6 = new SegmentDetail();
                        try{
                            sd6 = DbSegmentDetail.fetchExc(cashReceiveDetail.getSegment6Id());
                        }catch(Exception e){}
                        
                        segment = segment +" | "+ sd6.getName();
                    }

                    titlePrCellTop = new Cell(new Chunk("" + page, fontHeader));
                    titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
                    titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titlePrCellTop.setBorderColor(blackColor);
                    titlePrCellTop.setBorderWidth(1);
                    prTable.addCell(titlePrCellTop);

                    titlePrCellTop = new Cell(new Chunk("" + segment, fontHeader));
                    titlePrCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                    titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titlePrCellTop.setBorderColor(blackColor);
                    titlePrCellTop.setBorderWidth(1);
                    prTable.addCell(titlePrCellTop);

                    titlePrCellTop = new Cell(new Chunk("" + nama, fontHeader));
                    titlePrCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                    titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titlePrCellTop.setBorderColor(blackColor);
                    titlePrCellTop.setBorderWidth(1);
                    prTable.addCell(titlePrCellTop);

                    titlePrCellTop = new Cell(new Chunk("" + strAmount, fontHeader));
                    titlePrCellTop.setHorizontalAlignment(Element.ALIGN_RIGHT);
                    titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titlePrCellTop.setBorderColor(blackColor);
                    titlePrCellTop.setBorderWidth(1);
                    prTable.addCell(titlePrCellTop);

                    titlePrCellTop = new Cell(new Chunk("" + penjelasan, fontHeader));
                    titlePrCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                    titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titlePrCellTop.setBorderColor(blackColor);
                    titlePrCellTop.setBorderWidth(1);
                    prTable.addCell(titlePrCellTop);



                }

                titlePrCellTop = new Cell(new Chunk("TOTAL", fontHeader));
                titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
                titlePrCellTop.setColspan(3);
                titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTop.setBorderColor(blackColor);
                titlePrCellTop.setBorderWidth(1);
                prTable.addCell(titlePrCellTop);

                titlePrCellTop = new Cell(new Chunk("" + JSPFormater.formatNumber(total, "#,###.##"), fontHeader));
                titlePrCellTop.setHorizontalAlignment(Element.ALIGN_RIGHT);
                titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTop.setBorderColor(blackColor);
                titlePrCellTop.setBorderWidth(1);
                prTable.addCell(titlePrCellTop);
                
                titlePrCellTop = new Cell(new Chunk("", fontHeader));
                titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);                
                titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTop.setBorderColor(blackColor);
                titlePrCellTop.setBorderWidth(1);
                prTable.addCell(titlePrCellTop);

                document.add(prTable);                
                
                int poHeaderTops[] = {60, 60}; //8

                Table prTables = new Table(2);
                prTables.setWidth(100);
                prTables.setWidths(poHeaderTops);
                prTables.setBorderColor(putih);
                prTables.setBorderWidth(1);
                prTables.setAlignment(1);
                prTables.setCellpadding(0);
                prTables.setCellspacing(1);
                
                Cell titlePrCellTops = new Cell(new Chunk("", fontHeader));
                titlePrCellTops.setHorizontalAlignment(Element.ALIGN_CENTER);
                titlePrCellTops.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTops.setColspan(2);
                titlePrCellTops.setBorderColor(putih);                
                prTables.addCell(titlePrCellTops);

                titlePrCellTops = new Cell(new Chunk("Creator, Tgl     /    /20", fontHeader));
                titlePrCellTops.setHorizontalAlignment(Element.ALIGN_CENTER);
                titlePrCellTops.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTops.setBorderColor(putih);                
                prTables.addCell(titlePrCellTops);
                
                titlePrCellTops = new Cell(new Chunk(", Tgl     /    /20", fontHeader));
                titlePrCellTops.setHorizontalAlignment(Element.ALIGN_CENTER);
                titlePrCellTops.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTops.setBorderColor(putih);                
                prTables.addCell(titlePrCellTops);
                
                document.add(prTables);

            }

        } catch (Exception e) {
            System.out.println(e.toString());
        }

        document.close();
        response.setContentType("application/pdf");
        response.setContentLength(baos.size());
        ServletOutputStream out = response.getOutputStream();

        baos.writeTo(out);
        out.flush();
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
}
