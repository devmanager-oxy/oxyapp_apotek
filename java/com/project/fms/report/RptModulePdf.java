/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.fms.report;

import com.lowagie.text.*;
import com.lowagie.text.Image;
import com.lowagie.text.Rectangle;
import com.lowagie.text.pdf.PdfWriter;
import com.lowagie.text.FontFactory;
import com.lowagie.text.Document;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.awt.*;
import java.io.ByteArrayOutputStream;
import java.util.Vector;
import java.util.Date;
import java.net.MalformedURLException;
import java.net.URL;

import com.lowagie.text.Font;
import com.project.fms.activity.ActivityPeriod;
import com.project.fms.activity.DbActivityPeriod;
import com.project.fms.activity.DbModuleBudget;
import com.project.fms.activity.Module;
import com.project.fms.activity.ModuleBudget;
import com.project.util.jsp.*;
import com.project.fms.master.*;
import com.project.fms.journal.*;
import com.project.fms.transaction.*;
import com.project.payroll.*;
import com.project.util.*;
import com.project.system.*;

import com.project.general.Company;
import com.project.general.Customer;
import com.project.general.DbCompany;
import com.project.general.DbCurrency;
import com.project.general.Currency;
import com.project.general.DbCustomer;
import com.project.simprop.property.DbSalesData;
import com.project.simprop.session.RptAging;
import com.project.simprop.session.RptCustomer;
import com.project.simprop.session.RptPayment;
import java.util.StringTokenizer;

/**
 *
 * @author Roy Andika
 */
public class RptModulePdf extends HttpServlet {

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

        System.out.println("===| Rpt-MODULE-Pdf |===");
        int lang = 0;

        long activityPeriodId = JSPRequestValue.requestLong(request, "activity_period_id");        
        long jenisAct = JSPRequestValue.requestLong(request, "jenisAct");
        String strSegment = JSPRequestValue.requestStringExcTitikKoma(request, "segment");
        Vector vModule = new Vector();
        try {
            HttpSession session = request.getSession();
            vModule = (Vector) session.getValue("MODULE_GEREJA");
            lang = JSPRequestValue.requestInt(request, "lang");
        } catch (Exception e) {
            System.out.println(e.toString());
        }

        String[] langMD = {"Number", "Activity", "Target", "Days", "Date", "Time", "Memo", "Budget"};
        String[] langNav = {"Activity", "Activity List", "Period", "Data not found", "Please click search button to show activity datas"};

        if (lang == 0) {
            String[] langID = {"No", "Kegiatan", "Sasaran", "Hari", "Tanggal", "Waktu", "Keterangan", "Anggaran"};

            langMD = langID;
            String[] navID = {"Kegiatan", "Data Kerja", "Periode", "Data tidak ditemukan", "Click tombol search untuk menampilkan data kerja"};
            langNav = navID;
        }

        String header = "";
        try {
            header = DbSystemProperty.getValueByName("HEADER_DATA_KERJA");
        } catch (Exception e) {
        }

        String name_periode = "";
        try {
            ActivityPeriod periode = DbActivityPeriod.fetchExc(activityPeriodId);
            name_periode = periode.getName();
        } catch (Exception e) {
        }

        String title = "PROGRAM PELAYANAN";

        String[] condition;
        StringTokenizer strTokenizerCondition = new StringTokenizer(strSegment, ";");
        condition = new String[strTokenizerCondition.countTokens()];

        Color border = new Color(0x00, 0x00, 0x00);

        // setting some fonts in the color chosen by the user
        Font fontHeaderBig = new Font(Font.HELVETICA, 10, Font.BOLD, border);
        Font fontHeader = new Font(Font.HELVETICA, 8, Font.BOLD, border);
        Font fontContent = new Font(Font.HELVETICA, 8, Font.BOLD, border);
        Font fontTitle = new Font(Font.HELVETICA, 10, Font.BOLD, border);
        Font tableContent = new Font(Font.HELVETICA, 8, Font.NORMAL, border);
        Font fontSpellCharge = new Font(Font.HELVETICA, 8, Font.BOLDITALIC, border);
        Font fontItalic = new Font(Font.HELVETICA, 8, Font.BOLDITALIC, border);
        Font fontItalicBottom = new Font(Font.HELVETICA, 8, Font.ITALIC, border);
        Font fontUnderline = new Font(Font.HELVETICA, 8, Font.UNDERLINE, border);

        Color bgColor = new Color(240, 240, 240);

        Color blackColor = new Color(0, 0, 0);

        Color putih = new Color(250, 250, 250);

        Document document = new Document(PageSize.A4, 30, 30, 50, 50);
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        int start = 0;

        try {
            // step2.2: creating an instance of the writer
            PdfWriter.getInstance(document, baos);

            // step 3.1: adding some metadata to the document
            document.addSubject("This is a subject.");
            document.addSubject("This is a subject two.");

            document.open();

            //for header =========================================================== 
            int titleHeader[] = {10, 10, 10, 7, 10, 10, 10};
            Table titleTable = new Table(7);
            titleTable.setWidth(100);
            titleTable.setWidths(titleHeader);
            titleTable.setBorderColor(new Color(255, 255, 255));
            titleTable.setBorderWidth(0);
            titleTable.setAlignment(1);
            titleTable.setCellpadding(0);
            titleTable.setCellspacing(1);

            Cell titleCellHeader = new Cell(new Chunk("" + header.toUpperCase() + " " + name_periode.toUpperCase() + "", fontTitle));
            titleCellHeader.setColspan(7);
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));
            titleTable.addCell(titleCellHeader);

            int count = 0;

            while (strTokenizerCondition.hasMoreTokens()) {

                condition[count] = strTokenizerCondition.nextToken();

                long segmentId = Long.parseLong(condition[count]);

                String nama = "";
                String value = "";

                try {
                    SegmentDetail segmentDetail = DbSegmentDetail.fetchExc(segmentId);
                    value = segmentDetail.getName();

                    if (segmentDetail.getSegmentId() != 0) {
                        Segment segment = DbSegment.fetchExc(segmentDetail.getSegmentId());
                        nama = segment.getName();
                    }

                } catch (Exception e) {
                }

                titleCellHeader = new Cell(new Chunk(nama.toUpperCase(), fontHeader));
                titleCellHeader.setHorizontalAlignment(Element.ALIGN_LEFT);
                titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titleCellHeader.setColspan(1);
                titleCellHeader.setBorderColor(new Color(255, 255, 255));
                titleTable.addCell(titleCellHeader);

                titleCellHeader = new Cell(new Chunk(" : " + value.toUpperCase(), fontHeader));
                titleCellHeader.setHorizontalAlignment(Element.ALIGN_LEFT);
                titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titleCellHeader.setColspan(6);
                titleCellHeader.setBorderColor(new Color(255, 255, 255));
                titleTable.addCell(titleCellHeader);

                count++;
            }

            titleCellHeader = new Cell(new Chunk("", fontTitle));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setColspan(7);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));
            titleTable.addCell(titleCellHeader);

            document.add(titleTable);

            if (vModule != null && vModule.size() > 0) {

                //membuat table 
                int poHeaderTop[] = {3, 15, 15, 15, 15, 15, 15, 15, 12}; //8

                Table prTable = new Table(9);
                prTable.setWidth(100);
                prTable.setWidths(poHeaderTop);
                prTable.setBorderColor(blackColor);
                prTable.setBorderWidth(1);
                prTable.setAlignment(1);
                prTable.setCellpadding(0);
                prTable.setCellspacing(1);

                //space antar table
                Cell titlePrCellTop = new Cell(new Chunk(" ", tableContent));

                titlePrCellTop = new Cell(new Chunk((lang == 0 ? "No" : "No"), fontHeader));
                titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
                titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTop.setBorderColor(blackColor);
                titlePrCellTop.setBackgroundColor(bgColor);
                prTable.addCell(titlePrCellTop);

                titlePrCellTop = new Cell(new Chunk((lang == 0 ? "Kode" : "Code"), fontHeader));
                titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
                titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTop.setBorderColor(blackColor);
                titlePrCellTop.setBackgroundColor(bgColor);
                prTable.addCell(titlePrCellTop);

                titlePrCellTop = new Cell(new Chunk((lang == 0 ? "Kegiatan" : "Activity"), fontHeader));
                titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
                titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTop.setBorderColor(blackColor);
                titlePrCellTop.setBackgroundColor(bgColor);
                prTable.addCell(titlePrCellTop);

                titlePrCellTop = new Cell(new Chunk((lang == 0 ? "Sasaran" : "Target"), fontHeader));
                titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
                titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTop.setBorderColor(blackColor);
                titlePrCellTop.setBackgroundColor(bgColor);
                prTable.addCell(titlePrCellTop);

                titlePrCellTop = new Cell(new Chunk((lang == 0 ? "Hari" : "Days"), fontHeader));
                titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
                titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTop.setBorderColor(blackColor);
                titlePrCellTop.setBackgroundColor(bgColor);
                prTable.addCell(titlePrCellTop);
                
                titlePrCellTop = new Cell(new Chunk((lang == 0 ? "Tanggal" : "Date"), fontHeader));
                titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
                titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTop.setBorderColor(blackColor);
                titlePrCellTop.setBackgroundColor(bgColor);
                prTable.addCell(titlePrCellTop);

                titlePrCellTop = new Cell(new Chunk((lang == 0 ? "Waktu" : "Time"), fontHeader));
                titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
                titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTop.setBorderColor(blackColor);
                titlePrCellTop.setBackgroundColor(bgColor);
                prTable.addCell(titlePrCellTop);

                titlePrCellTop = new Cell(new Chunk((lang == 0 ? "Keterangan" : "Description"), fontHeader));
                titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
                titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTop.setBorderColor(blackColor);
                titlePrCellTop.setBackgroundColor(bgColor);
                prTable.addCell(titlePrCellTop);

                titlePrCellTop = new Cell(new Chunk((lang == 0 ? "Anggaran" : "Budget"), fontHeader));
                titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
                titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTop.setBorderColor(blackColor);
                titlePrCellTop.setBackgroundColor(bgColor);
                prTable.addCell(titlePrCellTop);

                double totAllBudget = 0;

                String idr = "Rp.";
                try {
                    idr = DbSystemProperty.getValueByName("CURRENCY_CODE_IDR");
                } catch (Exception e) {
                }

                for (int i = 0; i < vModule.size(); i++) {

                    Module module = (Module) vModule.get(i);

                    String mdBudget = "";
                    double totalBud = 0;

                    Vector vMb = DbModuleBudget.list(0, 0, DbModuleBudget.colNames[DbModuleBudget.COL_MODULE_ID] + "=" + module.getOID(), null);

                    if (vMb != null && vMb.size() > 0) {

                        for (int x = 0; x < vMb.size(); x++) {

                            ModuleBudget mb = (ModuleBudget) vMb.get(x);

                            String currency = "";
                            try {
                                Currency objCur = DbCurrency.fetchExc(mb.getCurrencyId());
                                currency = objCur.getCurrencyCode();
                            } catch (Exception e) {
                            }

                            totalBud = totalBud + mb.getAmount();
                            if (x != 0) {
                                mdBudget = mdBudget + " ";
                            }
                            mdBudget = mdBudget + mb.getDescription() + " = " + currency + "" + JSPFormater.formatNumber(mb.getAmount(), "#,###.##");

                        }

                        mdBudget = mdBudget + " TOTAL = " + idr + "" + JSPFormater.formatNumber(totalBud, "#,###.##") + "";

                    }

                    totAllBudget = totAllBudget + totalBud;

                    //Tokenizer untuk Sasaran
                    String outputDeliver = "";
                    StringTokenizer strTokenizerOutputDeliver = new StringTokenizer(module.getOutputDeliver(), ";");

                    int countOut = 0;

                    while (strTokenizerOutputDeliver.hasMoreTokens()) {

                        if (countOut != 0) {
                            outputDeliver = outputDeliver + "";
                        }

                        outputDeliver = outputDeliver + strTokenizerOutputDeliver.nextToken();
                        countOut++;
                    }
                    //=== END Tokenizer untuk Sasaran ===

                    //Tokenizer untuk action Day
                    String actDays = "";
                    StringTokenizer strTokenizerDays = new StringTokenizer(module.getActDay(), ";");

                    int countDays = 0;

                    while (strTokenizerDays.hasMoreTokens()) {

                        if (countDays != 0) {
                            actDays = actDays + "";
                        }

                        actDays = actDays + strTokenizerDays.nextToken();
                        countDays++;
                    }
                    //=== END Tokenizer untuk act day ===

                    //Tokenizer untuk Date
                    String date = "";
                    StringTokenizer strTokenizerDate = new StringTokenizer(module.getActDate(), ";");

                    int countDate = 0;

                    while (strTokenizerDate.hasMoreTokens()){

                        if (countDate != 0) {
                            date = date + "";
                        }

                        date = date + strTokenizerDate.nextToken();
                        countDate++;
                    }
                    //=== END Tokenizer untuk date

                    //Tokenizer untuk Time
                    String time = "";
                    StringTokenizer strTokenizerTime = new StringTokenizer(module.getActTime(), ";");

                    int countTime = 0;

                    while (strTokenizerTime.hasMoreTokens()) {

                        if (countTime != 0) {
                            time = time + "";
                        }

                        time = time + strTokenizerTime.nextToken();
                        countTime++;
                    }
                    //=== END Tokenizer untuk time

                    //Tokenizer untuk Keterangan
                    String note = "";
                    StringTokenizer strTokenizerNote = new StringTokenizer(module.getNote(), ";");

                    int countNote = 0;

                    while (strTokenizerNote.hasMoreTokens()) {

                        if (countNote != 0) {
                            note = note + "";
                        }

                        note = note + strTokenizerNote.nextToken();
                        countNote++;
                    }
                    int number = i + 1;

                    titlePrCellTop = new Cell(new Chunk("" + number, tableContent));
                    titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
                    titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titlePrCellTop.setBorderColor(blackColor);
                    prTable.addCell(titlePrCellTop);
                    
                    titlePrCellTop = new Cell(new Chunk(module.getCode(), tableContent));
                    titlePrCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                    titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titlePrCellTop.setBorderColor(blackColor);
                    prTable.addCell(titlePrCellTop);

                    titlePrCellTop = new Cell(new Chunk(module.getCode().length() > 0 ? module.getCode() + " - " + module.getDescription() : module.getDescription(), tableContent));
                    titlePrCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                    titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titlePrCellTop.setBorderColor(blackColor);
                    prTable.addCell(titlePrCellTop);

                    titlePrCellTop = new Cell(new Chunk(outputDeliver.length() > 0 ? outputDeliver : " ", tableContent));
                    titlePrCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                    titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titlePrCellTop.setBorderColor(blackColor);
                    prTable.addCell(titlePrCellTop);

                    titlePrCellTop = new Cell(new Chunk(actDays.length() > 0 ? actDays : " ", tableContent));
                    titlePrCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                    titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titlePrCellTop.setBorderColor(blackColor);
                    prTable.addCell(titlePrCellTop);

                    titlePrCellTop = new Cell(new Chunk(date.length() > 0 ? date : " ", tableContent));
                    titlePrCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                    titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titlePrCellTop.setBorderColor(blackColor);
                    prTable.addCell(titlePrCellTop);

                    titlePrCellTop = new Cell(new Chunk(time.length() > 0 ? time : " ", tableContent));
                    titlePrCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                    titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titlePrCellTop.setBorderColor(blackColor);
                    prTable.addCell(titlePrCellTop);

                    titlePrCellTop = new Cell(new Chunk(note.length() > 0 ? note : " ", tableContent));
                    titlePrCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                    titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titlePrCellTop.setBorderColor(blackColor);
                    prTable.addCell(titlePrCellTop);

                    titlePrCellTop = new Cell(new Chunk(mdBudget.length() > 0 ? mdBudget : " ", tableContent));
                    titlePrCellTop.setHorizontalAlignment(Element.ALIGN_RIGHT);
                    titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titlePrCellTop.setBorderColor(blackColor);
                    prTable.addCell(titlePrCellTop);

                }

                titlePrCellTop = new Cell(new Chunk(""));
                titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
                titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTop.setBorderColor(blackColor);
                prTable.addCell(titlePrCellTop);
                
                titlePrCellTop = new Cell(new Chunk(""));
                titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
                titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTop.setBorderColor(blackColor);
                prTable.addCell(titlePrCellTop);

                titlePrCellTop = new Cell(new Chunk(""));
                titlePrCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTop.setBorderColor(blackColor);
                prTable.addCell(titlePrCellTop);

                titlePrCellTop = new Cell(new Chunk(""));
                titlePrCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTop.setBorderColor(blackColor);
                prTable.addCell(titlePrCellTop);

                titlePrCellTop = new Cell(new Chunk(""));
                titlePrCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTop.setBorderColor(blackColor);
                prTable.addCell(titlePrCellTop);

                titlePrCellTop = new Cell(new Chunk(""));
                titlePrCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTop.setBorderColor(blackColor);
                prTable.addCell(titlePrCellTop);

                titlePrCellTop = new Cell(new Chunk(""));
                titlePrCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTop.setBorderColor(blackColor);
                prTable.addCell(titlePrCellTop);

                titlePrCellTop = new Cell(new Chunk(""));
                titlePrCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTop.setBorderColor(blackColor);
                prTable.addCell(titlePrCellTop);

                titlePrCellTop = new Cell(new Chunk(""+idr+" "+JSPFormater.formatNumber(totAllBudget, "#,###.##")));
                titlePrCellTop.setHorizontalAlignment(Element.ALIGN_RIGHT);
                titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTop.setBorderColor(blackColor);
                prTable.addCell(titlePrCellTop);

                document.add(prTable);
            }


        } catch (Exception e) {

            System.out.println(e.toString());

        }

        document.close();

        System.out.println("print==============");
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
