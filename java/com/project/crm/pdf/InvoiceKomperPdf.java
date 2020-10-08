/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.crm.pdf;

import com.lowagie.text.BadElementException;
import com.lowagie.text.Cell;
import com.lowagie.text.Document;
import com.lowagie.text.DocumentException;
import com.lowagie.text.Font;
import com.lowagie.text.FontFactory;
import com.lowagie.text.Image;
import com.lowagie.text.PageSize;
import com.lowagie.text.Phrase;
import com.lowagie.text.Rectangle;
import com.lowagie.text.Table;
import com.lowagie.text.pdf.PdfWriter;
import com.project.system.DbSystemProperty;
import com.project.util.JSPFormater;
import java.awt.Color;
import java.io.ByteArrayOutputStream;
import java.util.Vector;
import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author gwawan
 */
public class InvoiceKomperPdf extends HttpServlet {

    public InvoiceKomperPdf() {
    }

    public void init(ServletConfig config) throws ServletException {
        super.init(config);
    }

    /** Destroys the servlet.
     */
    public void destroy() {

    }

    /** Handles the HTTP <code>GET</code> method.
     * @param request servle t request
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
    public static Color border = new Color(0x00, 0x00, 0x00);
    public static Color blackColor = new Color(0, 0, 0);
    public static Color whiteColor = new Color(255, 255, 255);
    public static Color titleColor = new Color(0, 0, 0);
    public static Color headerColor = new Color(232, 232, 238);
    public static Color contentColor = new Color(255, 255, 255);
    public static String formatDate = "dd MMMM yyyy";
    public static String formatNumber = "#,###";
    
    public static Font fontTitle = FontFactory.getFont(FontFactory.HELVETICA, 14, Font.BOLD|Font.UNDERLINE, blackColor);
    
    public static Font fontHeader = FontFactory.getFont(FontFactory.HELVETICA, 14, Font.NORMAL, blackColor);
    public static Font fontHeaderBU = FontFactory.getFont(FontFactory.HELVETICA, 14, Font.BOLD|Font.UNDERLINE, blackColor);
    public static Font fontHeaderBI = FontFactory.getFont(FontFactory.HELVETICA, 14, Font.BOLD|Font.ITALIC, blackColor);
    public static Font fontContent = FontFactory.getFont(FontFactory.HELVETICA, 11, Font.NORMAL, Color.BLACK);
    public static Font fontContentB = FontFactory.getFont(FontFactory.HELVETICA, 11, Font.BOLD, Color.BLACK);
    public static Font fontContentBI = FontFactory.getFont(FontFactory.HELVETICA, 11, Font.BOLDITALIC, Color.BLACK);
    public static Font fontContentStrike = FontFactory.getFont(FontFactory.HELVETICA, 11, Font.NORMAL|Font.STRIKETHRU, Color.BLACK);
    
    public static Font fontHeaderS = FontFactory.getFont(FontFactory.HELVETICA, 12, Font.NORMAL, blackColor);
    public static Font fontHeaderSB = FontFactory.getFont(FontFactory.HELVETICA, 12, Font.BOLD|Font.UNDERLINE, blackColor);
    public static Font fontContentS = FontFactory.getFont(FontFactory.HELVETICA, 9, Font.NORMAL, Color.BLACK);
    public static Font fontContentSB = FontFactory.getFont(FontFactory.HELVETICA, 9, Font.BOLD, Color.BLACK);
    public static Font fontContentSBI = FontFactory.getFont(FontFactory.HELVETICA, 9, Font.BOLDITALIC, Color.BLACK);

    private void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, java.io.IOException {

        Rectangle rectangle = new Rectangle(20, 20, 20, 20);
        rectangle.rotate();
        Document document = new Document(PageSize.A4, 20, 20, 30, 20);
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        
        try {
            PdfWriter writer = PdfWriter.getInstance(document, baos);
            HttpSession session = request.getSession(true);
            Vector temp = (Vector) session.getValue("SESS_INV_KOMPER");
            int komper = Integer.parseInt((String) temp.get(0));
            Vector vList = (Vector) temp.get(1);
            
            String IMAGE_PRINT_PATH_CRM = DbSystemProperty.getValueByName("IMAGE_PRINT_PATH_CRM");
            String pathLogo = IMAGE_PRINT_PATH_CRM + "btdc-logo-black-white.gif";
            Image logo = null;

            try {
                logo = Image.getInstance(pathLogo);
            } catch (Exception ex) {
                System.out.println(ex.toString());
            }
            
            document.open();
            if(komper == InvoiceKomper.KOMPER_PERHITUNGAN) document.add(getPerhitungan(document, vList, logo));
            else if(komper == InvoiceKomper.KOMPER_INVOICE) document.add(getInvoice(document, vList, logo));

        } catch (Exception e) {
            System.out.println("Exception Draw pdf : " + e.toString());
        }

        document.close();

        // we have written the pdfstream to a ByteArrayOutputStream,
        // now we are going to write this outputStream to the ServletOutputStream
        // after we have set the contentlength (see http://www.lowagie.com/iText/faq.html#msie)
        response.setContentType("application/pdf");
        response.setContentLength(baos.size());
        ServletOutputStream out = response.getOutputStream();
        baos.writeTo(out);
        out.flush();
    }
    
    private static Table getPerhitungan(Document document, Vector vList, Image logo)
            throws BadElementException, DocumentException {
        Table perhitungan = new Table(7);
        int[] colWidth = {5, 40, 3, 17, 15, 3, 17};
        perhitungan.setWidths(colWidth);
        perhitungan.setWidth(100);
        perhitungan.setCellpadding(1);
        perhitungan.setCellspacing(1);
        perhitungan.setBorderColor(whiteColor);
        
        if (logo != null) {
            logo.scalePercent(35);
            logo.setAbsolutePosition(20, 765);
            document.add(logo);
        }
        
        if(vList != null && vList.size() > 0) {
            double tPendapatan = 0;
            
            for(int i=0; i<vList.size(); i++) {
                InvoiceKomper invoiceKomper = (InvoiceKomper) vList.get(i);
                
                if(i == 0) {
                    perhitungan.setDefaultCellBorder(Table.NO_BORDER);
                    perhitungan.setDefaultHorizontalAlignment(Cell.ALIGN_CENTER);
                    perhitungan.setDefaultVerticalAlignment(Cell.ALIGN_MIDDLE);
                    perhitungan.setDefaultRowspan(1);
                    perhitungan.setDefaultColspan(7);
                    perhitungan.addCell(new Phrase(invoiceKomper.getNamaBadan(), fontHeaderBU));
                    perhitungan.addCell(new Phrase(invoiceKomper.getNamaKomersil(), fontHeader));
                    perhitungan.addCell(new Phrase("", fontHeader));
                    perhitungan.addCell(new Phrase(invoiceKomper.getInvoiceDesc().toUpperCase(), fontContentB));
                    perhitungan.addCell(new Phrase(invoiceKomper.getPNamaKomersil().toUpperCase(), fontContentB));
                    perhitungan.addCell(new Phrase("BULAN : "+invoiceKomper.getPeriode().toUpperCase(), fontContentB));
                    perhitungan.addCell(new Phrase("", fontHeader));
                    
                    perhitungan.setDefaultCellBorder(Table.LEFT|Table.TOP|Table.RIGHT|Table.BOTTOM);
                    perhitungan.setDefaultColspan(1);
                    perhitungan.setDefaultHorizontalAlignment(Cell.ALIGN_CENTER);
                    perhitungan.addCell(new Phrase("NO", fontContentSB));
                    perhitungan.addCell(new Phrase("URAIAN", fontContentSB));
                    perhitungan.setDefaultColspan(2);
                    perhitungan.addCell(new Phrase("TOTAL PENDAPATAN", fontContentSB));
                    perhitungan.setDefaultColspan(1);
                    perhitungan.addCell(new Phrase("CHARGE", fontContentSB));
                    perhitungan.setDefaultColspan(2);
                    perhitungan.addCell(new Phrase("KOMP. PERSENTASE", fontContentSB));
                }
                
                double netPendapatan = invoiceKomper.getPendapatan() * (invoiceKomper.getPersenPendapatan()/100);
                tPendapatan += netPendapatan;
                
                perhitungan.setDefaultCellBorder(Table.LEFT|Table.RIGHT);
                perhitungan.setDefaultColspan(1);
                perhitungan.setDefaultHorizontalAlignment(Cell.ALIGN_CENTER);
                perhitungan.addCell(new Phrase(String.valueOf(i+1), fontContentS));
                perhitungan.setDefaultHorizontalAlignment(Cell.ALIGN_LEFT);
                perhitungan.addCell(new Phrase(invoiceKomper.getJenisPendapatan(), fontContentS));
                perhitungan.setDefaultHorizontalAlignment(Cell.ALIGN_CENTER);
                perhitungan.setDefaultCellBorder(Table.LEFT);
                perhitungan.addCell(new Phrase(invoiceKomper.getMataUang(), fontContentS));
                perhitungan.setDefaultHorizontalAlignment(Cell.ALIGN_RIGHT);
                perhitungan.setDefaultCellBorder(Table.RIGHT);
                perhitungan.addCell(new Phrase(JSPFormater.formatNumber(invoiceKomper.getPendapatan(),"#,###.##"), fontContentS));
                perhitungan.setDefaultHorizontalAlignment(Cell.ALIGN_CENTER);
                perhitungan.addCell(new Phrase(String.valueOf(invoiceKomper.getPersenPendapatan())+" %", fontContentS));
                perhitungan.setDefaultCellBorder(Table.LEFT);
                perhitungan.addCell(new Phrase(invoiceKomper.getMataUang(), fontContentS));
                perhitungan.setDefaultHorizontalAlignment(Cell.ALIGN_RIGHT);
                perhitungan.setDefaultCellBorder(Table.RIGHT);
                perhitungan.addCell(new Phrase(JSPFormater.formatNumber(netPendapatan,"#,###.##"), fontContentS));
                
                
                if(i == (vList.size()-1)) {
                    double netKomper = tPendapatan % invoiceKomper.getTotalKomin(); //modulus, krn minimal tagihan komper 0 (nol)
                    
                    i++;
                    perhitungan.setDefaultCellBorder(Table.LEFT|Table.TOP|Table.RIGHT|Table.BOTTOM);
                    perhitungan.setDefaultHorizontalAlignment(Cell.ALIGN_CENTER);
                    perhitungan.addCell(new Phrase(String.valueOf(i), fontContentS));
                    perhitungan.setDefaultHorizontalAlignment(Cell.ALIGN_LEFT);
                    perhitungan.addCell(new Phrase("Total", fontContentS));
                    perhitungan.setDefaultHorizontalAlignment(Cell.ALIGN_CENTER);
                    perhitungan.setDefaultCellBorder(Table.LEFT|Table.TOP|Table.BOTTOM);
                    perhitungan.addCell(new Phrase("", fontContentS));
                    perhitungan.setDefaultHorizontalAlignment(Cell.ALIGN_RIGHT);
                    perhitungan.setDefaultCellBorder(Table.TOP|Table.RIGHT|Table.BOTTOM);
                    perhitungan.addCell(new Phrase("", fontContentS));
                    perhitungan.setDefaultHorizontalAlignment(Cell.ALIGN_CENTER);
                    perhitungan.addCell(new Phrase("", fontContentS));
                    perhitungan.setDefaultCellBorder(Table.LEFT|Table.TOP|Table.BOTTOM);
                    perhitungan.addCell(new Phrase(invoiceKomper.getMataUang(), fontContentS));
                    perhitungan.setDefaultHorizontalAlignment(Cell.ALIGN_RIGHT);
                    perhitungan.setDefaultCellBorder(Table.TOP|Table.RIGHT|Table.BOTTOM);
                    perhitungan.addCell(new Phrase(JSPFormater.formatNumber(tPendapatan,"#,###.##"), fontContentS));

                    i++;
                    perhitungan.setDefaultCellBorder(Table.LEFT|Table.RIGHT);
                    perhitungan.setDefaultColspan(1);
                    perhitungan.setDefaultHorizontalAlignment(Cell.ALIGN_CENTER);
                    perhitungan.addCell(new Phrase("\n"+String.valueOf(i), fontContentS));
                    perhitungan.setDefaultColspan(4);
                    perhitungan.setDefaultHorizontalAlignment(Cell.ALIGN_LEFT);
                    perhitungan.addCell(new Phrase("\nKewajiban Kompensasi Persentase Bulan "+invoiceKomper.getPeriode(), fontContentS));
                    perhitungan.setDefaultColspan(1);
                    perhitungan.setDefaultHorizontalAlignment(Cell.ALIGN_CENTER);
                    perhitungan.setDefaultCellBorder(Table.LEFT);
                    perhitungan.addCell(new Phrase("\n"+invoiceKomper.getMataUang(), fontContentS));
                    perhitungan.setDefaultHorizontalAlignment(Cell.ALIGN_RIGHT);
                    perhitungan.setDefaultCellBorder(Table.RIGHT);
                    perhitungan.addCell(new Phrase("\n"+JSPFormater.formatNumber(tPendapatan,"#,###.##"), fontContentS));
                    
                    i++;
                    perhitungan.setDefaultCellBorder(Table.LEFT|Table.RIGHT);
                    perhitungan.setDefaultColspan(1);
                    perhitungan.setDefaultHorizontalAlignment(Cell.ALIGN_CENTER);
                    perhitungan.addCell(new Phrase("\n"+String.valueOf(i), fontContentS));
                    perhitungan.setDefaultColspan(4);
                    perhitungan.setDefaultHorizontalAlignment(Cell.ALIGN_LEFT);
                    perhitungan.addCell(new Phrase("\nKompensasi Minimum Bulan "+invoiceKomper.getPeriode(), fontContentS));
                    perhitungan.setDefaultColspan(1);
                    perhitungan.setDefaultHorizontalAlignment(Cell.ALIGN_CENTER);
                    perhitungan.setDefaultCellBorder(Table.LEFT);
                    perhitungan.addCell(new Phrase("\n"+invoiceKomper.getMataUang(), fontContentS));
                    perhitungan.setDefaultHorizontalAlignment(Cell.ALIGN_RIGHT);
                    perhitungan.setDefaultCellBorder(Table.RIGHT);
                    perhitungan.addCell(new Phrase("\n"+JSPFormater.formatNumber(invoiceKomper.getTotalKomin(),"#,###.##"), fontContentS));
                    
                    i++;
                    perhitungan.setDefaultCellBorder(Table.LEFT|Table.RIGHT);
                    perhitungan.setDefaultColspan(1);
                    perhitungan.setDefaultHorizontalAlignment(Cell.ALIGN_CENTER);
                    perhitungan.addCell(new Phrase("\n"+String.valueOf(i), fontContentS));
                    perhitungan.setDefaultColspan(4);
                    perhitungan.setDefaultHorizontalAlignment(Cell.ALIGN_LEFT);
                    perhitungan.addCell(new Phrase("\nSisa Kompensasi Persentase Bulan "+invoiceKomper.getPeriode(), fontContentS));
                    perhitungan.setDefaultColspan(1);
                    perhitungan.setDefaultHorizontalAlignment(Cell.ALIGN_CENTER);
                    perhitungan.setDefaultCellBorder(Table.LEFT);
                    perhitungan.addCell(new Phrase("\n"+invoiceKomper.getMataUang(), fontContentS));
                    perhitungan.setDefaultHorizontalAlignment(Cell.ALIGN_RIGHT);
                    perhitungan.setDefaultCellBorder(Table.RIGHT);
                    perhitungan.addCell(new Phrase("\n"+JSPFormater.formatNumber(netKomper,"#,###.##"), fontContentS));
                    
                    i++;
                    perhitungan.setDefaultCellBorder(Table.LEFT|Table.RIGHT);
                    perhitungan.setDefaultColspan(1);
                    perhitungan.setDefaultHorizontalAlignment(Cell.ALIGN_CENTER);
                    perhitungan.addCell(new Phrase("\n"+String.valueOf(i), fontContentS));
                    perhitungan.setDefaultColspan(4);
                    perhitungan.setDefaultHorizontalAlignment(Cell.ALIGN_LEFT);
                    perhitungan.addCell(new Phrase("\nPPN (10%) butir 11", fontContentS));
                    perhitungan.setDefaultColspan(1);
                    perhitungan.setDefaultHorizontalAlignment(Cell.ALIGN_CENTER);
                    perhitungan.setDefaultCellBorder(Table.LEFT);
                    perhitungan.addCell(new Phrase("\n"+invoiceKomper.getMataUang(), fontContentS));
                    perhitungan.setDefaultHorizontalAlignment(Cell.ALIGN_RIGHT);
                    perhitungan.setDefaultCellBorder(Table.RIGHT);
                    perhitungan.addCell(new Phrase("\n"+JSPFormater.formatNumber(netKomper*0.1,"#,###.##"), fontContentS));
                    
                    i++;
                    perhitungan.setDefaultCellBorder(Table.LEFT|Table.RIGHT);
                    perhitungan.setDefaultColspan(1);
                    perhitungan.setDefaultHorizontalAlignment(Cell.ALIGN_CENTER);
                    perhitungan.addCell(new Phrase("\n"+String.valueOf(i)+"\n ", fontContentS));
                    perhitungan.setDefaultColspan(4);
                    perhitungan.setDefaultHorizontalAlignment(Cell.ALIGN_LEFT);
                    perhitungan.addCell(new Phrase("\nPPH Pasal 4 ayat 2 (10%) butir 11", fontContentS));
                    perhitungan.setDefaultColspan(1);
                    perhitungan.setDefaultHorizontalAlignment(Cell.ALIGN_CENTER);
                    perhitungan.setDefaultCellBorder(Table.LEFT);
                    perhitungan.addCell(new Phrase("\n"+invoiceKomper.getMataUang(), fontContentS));
                    perhitungan.setDefaultHorizontalAlignment(Cell.ALIGN_RIGHT);
                    perhitungan.setDefaultCellBorder(Table.RIGHT);
                    perhitungan.addCell(new Phrase("\n"+JSPFormater.formatNumber(netKomper*0.1*-1,"#,###.##"), fontContentS));
                    
                    i++;
                    perhitungan.setDefaultCellBorder(Table.LEFT|Table.TOP|Table.RIGHT|Table.BOTTOM);
                    perhitungan.setDefaultColspan(1);
                    perhitungan.setDefaultHorizontalAlignment(Cell.ALIGN_CENTER);
                    perhitungan.addCell(new Phrase(String.valueOf(i), fontContentSB));
                    perhitungan.setDefaultColspan(4);
                    perhitungan.setDefaultHorizontalAlignment(Cell.ALIGN_LEFT);
                    perhitungan.addCell(new Phrase("Total Kompensasi Persentase yang harus dibayar", fontContentSB));
                    perhitungan.setDefaultColspan(1);
                    perhitungan.setDefaultHorizontalAlignment(Cell.ALIGN_CENTER);
                    perhitungan.setDefaultCellBorder(Table.LEFT|Table.TOP|Table.BOTTOM);
                    perhitungan.addCell(new Phrase(invoiceKomper.getMataUang(), fontContentSB));
                    perhitungan.setDefaultHorizontalAlignment(Cell.ALIGN_RIGHT);
                    perhitungan.setDefaultCellBorder(Table.TOP|Table.RIGHT|Table.BOTTOM);
                    perhitungan.addCell(new Phrase(JSPFormater.formatNumber(netKomper,"#,###.##"), fontContentSB));
                }
            }
        }
        
        return perhitungan;
    }
    
    private static Table getInvoice(Document document, Vector vList, Image logo)
            throws BadElementException, DocumentException {
        Table invoice = new Table(5);
        int[] colWidth = {5, 35, 40, 3, 17};
        invoice.setWidths(colWidth);
        invoice.setWidth(100);
        invoice.setCellpadding(1);
        invoice.setCellspacing(1);
        invoice.setBorderColor(whiteColor);
        
        logo.scalePercent(35);
        logo.setAbsolutePosition(20, 765);
        document.add(logo);
        
        double tPendapatan = 0;
        for(int i=0; i<vList.size(); i++) {
            InvoiceKomper invoiceKomper = (InvoiceKomper) vList.get(i);
            double netPendapatan = invoiceKomper.getPendapatan() * (invoiceKomper.getPersenPendapatan()/100);
            tPendapatan += netPendapatan;
        }
        
        InvoiceKomper invoiceKomper = (InvoiceKomper) vList.get(0);
        
        double netKomper = tPendapatan % invoiceKomper.getTotalKomin(); //modulus, krn minimal tagihan komper 0 (nol)
        
        invoice.setDefaultCellBorder(Table.NO_BORDER);
        invoice.setDefaultHorizontalAlignment(Cell.ALIGN_CENTER);
        invoice.setDefaultVerticalAlignment(Cell.ALIGN_MIDDLE);
        invoice.setDefaultRowspan(1);
        invoice.setDefaultColspan(5);
        invoice.addCell(new Phrase(invoiceKomper.getNamaBadan(), fontHeaderBU));
        invoice.addCell(new Phrase(invoiceKomper.getNamaKomersil(), fontHeader));
        invoice.addCell(new Phrase("", fontHeader));
        
        invoice.setDefaultColspan(5);
        invoice.setDefaultHorizontalAlignment(Cell.ALIGN_CENTER);
        invoice.addCell(new Phrase("I N V O I C E", fontHeaderBI));
        
        invoice.addCell(new Phrase("", fontHeader));
        
        invoice.setDefaultHorizontalAlignment(Cell.ALIGN_LEFT);
        invoice.setDefaultColspan(5);
        invoice.addCell(new Phrase("Kepada :", fontContentB));
        
        invoice.setDefaultColspan(2);
        invoice.addCell(new Phrase(invoiceKomper.getPNamaBadan(), fontContent));
        invoice.setDefaultHorizontalAlignment(Cell.ALIGN_RIGHT);
        invoice.addCell(new Phrase("No. : ", fontContentB));
        invoice.setDefaultColspan(1);
        invoice.setDefaultHorizontalAlignment(Cell.ALIGN_LEFT);
        invoice.addCell(new Phrase(invoiceKomper.getNomor(), fontContent));
        
        invoice.setDefaultColspan(5);
        invoice.addCell(new Phrase("", fontContentB));
        
        invoice.setDefaultCellBorder(Table.TOP|Table.RIGHT|Table.BOTTOM|Table.LEFT);
        invoice.setDefaultColspan(1);
        invoice.setDefaultHorizontalAlignment(Cell.ALIGN_CENTER);
        invoice.addCell(new Phrase("NO", fontContentB));
        invoice.setDefaultColspan(2);
        invoice.addCell(new Phrase("URAIAN", fontContentB));
        invoice.addCell(new Phrase("JUMLAH", fontContentB));
        
        invoice.setDefaultCellBorder(Table.LEFT | Table.RIGHT);
        invoice.setDefaultColspan(1);
        invoice.setDefaultHorizontalAlignment(Cell.ALIGN_CENTER);
        invoice.addCell(new Phrase("\n1", fontContentS));
        invoice.setDefaultColspan(2);
        invoice.setDefaultHorizontalAlignment(Cell.ALIGN_LEFT);
        invoice.addCell(new Phrase("\nKewajiban Kompensasi Persentase Bulan " + invoiceKomper.getPeriode(), fontContentS));
        invoice.setDefaultColspan(1);
        invoice.setDefaultHorizontalAlignment(Cell.ALIGN_CENTER);
        invoice.setDefaultCellBorder(Table.LEFT);
        invoice.addCell(new Phrase("\n" + invoiceKomper.getMataUang(), fontContentS));
        invoice.setDefaultHorizontalAlignment(Cell.ALIGN_RIGHT);
        invoice.setDefaultCellBorder(Table.RIGHT);
        invoice.addCell(new Phrase("\n"+JSPFormater.formatNumber(tPendapatan,"#,###.##"), fontContentS));
        
        invoice.setDefaultCellBorder(Table.LEFT | Table.RIGHT);
        invoice.setDefaultColspan(1);
        invoice.setDefaultHorizontalAlignment(Cell.ALIGN_CENTER);
        invoice.addCell(new Phrase("\n2", fontContentS));
        invoice.setDefaultColspan(2);
        invoice.setDefaultHorizontalAlignment(Cell.ALIGN_LEFT);
        invoice.addCell(new Phrase("\nKompensasi Minimum Bulan "+invoiceKomper.getPeriode(), fontContentS));
        invoice.setDefaultColspan(1);
        invoice.setDefaultHorizontalAlignment(Cell.ALIGN_CENTER);
        invoice.setDefaultCellBorder(Table.LEFT);
        invoice.addCell(new Phrase("\n" + invoiceKomper.getMataUang(), fontContentS));
        invoice.setDefaultHorizontalAlignment(Cell.ALIGN_RIGHT);
        invoice.setDefaultCellBorder(Table.RIGHT);
        invoice.addCell(new Phrase("\n"+JSPFormater.formatNumber(invoiceKomper.getTotalKomin(),"#,###.##"), fontContentS));
        
        invoice.setDefaultCellBorder(Table.LEFT | Table.RIGHT);
        invoice.setDefaultColspan(1);
        invoice.setDefaultHorizontalAlignment(Cell.ALIGN_CENTER);
        invoice.addCell(new Phrase("\n3", fontContentS));
        invoice.setDefaultColspan(2);
        invoice.setDefaultHorizontalAlignment(Cell.ALIGN_LEFT);
        invoice.addCell(new Phrase("\nSisa Kompensasi Persentase Bulan "+invoiceKomper.getPeriode(), fontContentS));
        invoice.setDefaultColspan(1);
        invoice.setDefaultHorizontalAlignment(Cell.ALIGN_CENTER);
        invoice.setDefaultCellBorder(Table.LEFT);
        invoice.addCell(new Phrase("\n" + invoiceKomper.getMataUang(), fontContentS));
        invoice.setDefaultHorizontalAlignment(Cell.ALIGN_RIGHT);
        invoice.setDefaultCellBorder(Table.RIGHT);
        invoice.addCell(new Phrase("\n"+JSPFormater.formatNumber(netKomper,"#,###.##"), fontContentS));
        
        invoice.setDefaultCellBorder(Table.LEFT | Table.RIGHT);
        invoice.setDefaultColspan(1);
        invoice.setDefaultHorizontalAlignment(Cell.ALIGN_CENTER);
        invoice.addCell(new Phrase("\n4", fontContentS));
        invoice.setDefaultColspan(2);
        invoice.setDefaultHorizontalAlignment(Cell.ALIGN_LEFT);
        invoice.addCell(new Phrase("\nPPN (10%) butir 11", fontContentS));
        invoice.setDefaultColspan(1);
        invoice.setDefaultHorizontalAlignment(Cell.ALIGN_CENTER);
        invoice.setDefaultCellBorder(Table.LEFT);
        invoice.addCell(new Phrase("\n" + invoiceKomper.getMataUang(), fontContentS));
        invoice.setDefaultHorizontalAlignment(Cell.ALIGN_RIGHT);
        invoice.setDefaultCellBorder(Table.RIGHT);
        invoice.addCell(new Phrase("\n"+JSPFormater.formatNumber(netKomper*0.1,"#,###.##"), fontContentS));
        
        invoice.setDefaultCellBorder(Table.LEFT | Table.RIGHT);
        invoice.setDefaultColspan(1);
        invoice.setDefaultHorizontalAlignment(Cell.ALIGN_CENTER);
        invoice.addCell(new Phrase("\n5\n ", fontContentS));
        invoice.setDefaultColspan(2);
        invoice.setDefaultHorizontalAlignment(Cell.ALIGN_LEFT);
        invoice.addCell(new Phrase("\nPPH Pasal 4 ayat 2 (10%) butir 11", fontContentS));
        invoice.setDefaultColspan(1);
        invoice.setDefaultHorizontalAlignment(Cell.ALIGN_CENTER);
        invoice.setDefaultCellBorder(Table.LEFT);
        invoice.addCell(new Phrase("\n" + invoiceKomper.getMataUang(), fontContentS));
        invoice.setDefaultHorizontalAlignment(Cell.ALIGN_RIGHT);
        invoice.setDefaultCellBorder(Table.RIGHT);
        invoice.addCell(new Phrase("\n"+JSPFormater.formatNumber(netKomper*0.1*-1,"#,###.##"), fontContentS));
        
        invoice.setDefaultCellBorder(Table.LEFT | Table.TOP | Table.RIGHT | Table.BOTTOM);
        invoice.setDefaultColspan(3);
        invoice.setDefaultHorizontalAlignment(Cell.ALIGN_CENTER);
        invoice.addCell(new Phrase("T O T A L", fontContentSB));
        invoice.setDefaultColspan(1);
        invoice.setDefaultHorizontalAlignment(Cell.ALIGN_CENTER);
        invoice.setDefaultCellBorder(Table.LEFT | Table.TOP | Table.BOTTOM);
        invoice.addCell(new Phrase(invoiceKomper.getMataUang(), fontContentSB));
        invoice.setDefaultHorizontalAlignment(Cell.ALIGN_RIGHT);
        invoice.setDefaultCellBorder(Table.TOP | Table.RIGHT | Table.BOTTOM);
        invoice.addCell(new Phrase(JSPFormater.formatNumber(netKomper, "#,###.##"), fontContentSB));
        
        invoice.setDefaultCellBorder(Table.NO_BORDER);
        invoice.setDefaultHorizontalAlignment(Cell.ALIGN_LEFT);
        invoice.setDefaultColspan(1);
        invoice.addCell(new Phrase("Note:", fontContentS));
        invoice.setDefaultColspan(4);
        invoice.addCell(new Phrase("Jika pembayaran dilaksanakan setelah tanggal " + invoiceKomper.getInvoiceDueDate() + ", maka akan dikenakan denda keterlambatan sampai pada saat pelunasan.", fontContentS));
        
        invoice.setDefaultCellBorder(Table.NO_BORDER);
        invoice.setDefaultColspan(5);
        invoice.addCell(new Phrase("", fontContent));

        invoice.setDefaultColspan(5);
        invoice.addCell(new Phrase("", fontContent));

        invoice.setDefaultColspan(5);
        invoice.addCell(new Phrase("", fontContent));

        invoice.setDefaultColspan(2);
        invoice.addCell(new Phrase("", fontContent));
        invoice.setDefaultHorizontalAlignment(Cell.ALIGN_CENTER);
        invoice.setDefaultColspan(3);
        invoice.addCell(new Phrase(invoiceKomper.getInvoiceDate(), fontContent));

        invoice.setDefaultColspan(2);
        invoice.addCell(new Phrase("", fontContent));
        invoice.setDefaultHorizontalAlignment(Cell.ALIGN_CENTER);
        invoice.setDefaultColspan(3);
        invoice.addCell(new Phrase(invoiceKomper.getNamaBadan(), fontContent));

        invoice.setDefaultColspan(2);
        invoice.addCell(new Phrase("", fontContent));
        invoice.setDefaultHorizontalAlignment(Cell.ALIGN_CENTER);
        invoice.setDefaultColspan(3);
        invoice.addCell(new Phrase("D I R E K S I", fontContent));

        invoice.setDefaultColspan(5);
        invoice.addCell(new Phrase("", fontContent));

        invoice.setDefaultColspan(5);
        invoice.addCell(new Phrase("", fontContent));

        invoice.setDefaultColspan(2);
        invoice.addCell(new Phrase("", fontContent));
        invoice.setDefaultVerticalAlignment(Cell.ALIGN_BOTTOM);
        invoice.setDefaultHorizontalAlignment(Cell.ALIGN_CENTER);
        invoice.setDefaultColspan(3);
        invoice.addCell(new Phrase(invoiceKomper.getTtdNama(), fontContentB));

        invoice.setDefaultColspan(2);
        invoice.addCell(new Phrase("", fontContent));
        invoice.setDefaultVerticalAlignment(Cell.ALIGN_TOP);
        invoice.setDefaultHorizontalAlignment(Cell.ALIGN_CENTER);
        invoice.setDefaultColspan(3);
        invoice.addCell(new Phrase(invoiceKomper.getTtdJabatan(), fontContent));
        
        return invoice;
    }
}
