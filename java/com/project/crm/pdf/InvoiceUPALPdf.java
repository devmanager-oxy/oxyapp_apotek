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
public class InvoiceUPALPdf extends HttpServlet {

    public InvoiceUPALPdf() {
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
    public static Font fontTitle = FontFactory.getFont(FontFactory.HELVETICA, 14, Font.BOLD | Font.UNDERLINE, blackColor);
    public static Font fontHeader = FontFactory.getFont(FontFactory.HELVETICA, 14, Font.NORMAL, blackColor);
    public static Font fontHeaderBold = FontFactory.getFont(FontFactory.HELVETICA, 14, Font.BOLD | Font.UNDERLINE, blackColor);
    public static Font fontContent = FontFactory.getFont(FontFactory.HELVETICA, 11, Font.NORMAL, Color.BLACK);
    public static Font fontContentBold = FontFactory.getFont(FontFactory.HELVETICA, 11, Font.BOLD, Color.BLACK);
    public static Font fontContentArt = FontFactory.getFont(FontFactory.HELVETICA, 11, Font.BOLDITALIC, Color.BLACK);
    public static Font fontContentStrike = FontFactory.getFont(FontFactory.HELVETICA, 11, Font.NORMAL | Font.STRIKETHRU, Color.BLACK);
    public static Font fontHeaderS = FontFactory.getFont(FontFactory.HELVETICA, 12, Font.NORMAL, blackColor);
    public static Font fontHeaderBoldS = FontFactory.getFont(FontFactory.HELVETICA, 12, Font.BOLD | Font.UNDERLINE, blackColor);
    public static Font fontContentS = FontFactory.getFont(FontFactory.HELVETICA, 9, Font.NORMAL, Color.BLACK);
    public static Font fontContentBoldS = FontFactory.getFont(FontFactory.HELVETICA, 9, Font.BOLD, Color.BLACK);
    public static Font fontContentArtS = FontFactory.getFont(FontFactory.HELVETICA, 9, Font.BOLDITALIC, Color.BLACK);

    private void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, java.io.IOException {

        Rectangle rectangle = new Rectangle(20, 20, 20, 20);
        rectangle.rotate();
        Document document = new Document(PageSize.A4, 20, 20, 40, 20);
        ByteArrayOutputStream baos = new ByteArrayOutputStream();

        try {
            PdfWriter writer = PdfWriter.getInstance(document, baos);
            HttpSession session = request.getSession(true);
            InvoiceUPAL invoiceUPAL = (InvoiceUPAL) session.getValue("SESS_INV_UPAL");

            String IMAGE_PRINT_PATH_CRM = DbSystemProperty.getValueByName("IMAGE_PRINT_PATH_CRM");
            String pathLogo = IMAGE_PRINT_PATH_CRM + "btdc-logo-black-white.gif";
            Image logo = null;

            try {
                logo = Image.getInstance(pathLogo);
            } catch (Exception ex) {
                System.out.println(ex.toString());
            }

            document.open();
            document.add(getSurat(document, invoiceUPAL, logo));
            document.add(getPerhitungan(document, invoiceUPAL, logo));
            document.add(getFaktur(document, invoiceUPAL, logo));

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

    private static Table getSurat(Document document, InvoiceUPAL invoiceUPAL, Image logo)
            throws BadElementException, DocumentException {
        Table surat = new Table(7);
        int[] colWidth = {10, 2, 8, 20, 20, 20, 20};
        surat.setWidths(colWidth);
        surat.setWidth(100);
        surat.setCellpadding(1);
        surat.setCellspacing(1);
        surat.setBorderColor(whiteColor);

        if (logo != null) {
            logo.scalePercent(35);
            logo.setAbsolutePosition(20, 760);
            document.add(logo);
        }

        surat.setDefaultCellBorder(Table.NO_BORDER);
        surat.setDefaultHorizontalAlignment(Cell.ALIGN_CENTER);
        surat.setDefaultVerticalAlignment(Cell.ALIGN_MIDDLE);
        surat.setDefaultRowspan(1);
        surat.setDefaultColspan(7);
        surat.addCell(new Phrase(invoiceUPAL.getNamaBadan(), fontHeaderBold));
        surat.addCell(new Phrase(invoiceUPAL.getNamaKomersil(), fontHeader));
        surat.addCell(new Phrase("", fontHeaderBold));

        surat.setDefaultColspan(7);
        surat.addCell(new Phrase("", fontHeaderBold));

        surat.setDefaultColspan(7);
        surat.addCell(new Phrase("", fontHeaderBold));

        surat.setDefaultHorizontalAlignment(Cell.ALIGN_LEFT);
        surat.setDefaultVerticalAlignment(Cell.ALIGN_BOTTOM);
        surat.setDefaultColspan(1);
        surat.addCell(new Phrase("Nomor", fontContent));
        surat.setDefaultColspan(4);
        surat.addCell(new Phrase(": " + invoiceUPAL.getNomor(), fontContent));
        surat.setDefaultColspan(2);
        surat.addCell(new Phrase("Nusa Dua, " + invoiceUPAL.getInvoiceDate(), fontContent));

        surat.setDefaultColspan(1);
        surat.addCell(new Phrase("Lampiran", fontContent));
        surat.setDefaultColspan(4);
        surat.addCell(new Phrase(": 2 (dua) lembar", fontContent));
        surat.setDefaultColspan(2);
        surat.addCell(new Phrase("", fontContent));

        surat.setDefaultColspan(1);
        surat.addCell(new Phrase("Hal", fontContent));
        surat.setDefaultRowspan(1);
        surat.setDefaultColspan(4);
        surat.addCell(new Phrase(": Tagihan Jasa Pengolahan", fontContent));
        surat.setDefaultColspan(2);
        surat.addCell(new Phrase("", fontContent));

        surat.setDefaultColspan(1);
        surat.addCell(new Phrase("", fontContent));
        surat.setDefaultColspan(4);
        surat.addCell(new Phrase("  " + invoiceUPAL.getInvoiceDesc() + " " + invoiceUPAL.getPeriode(), fontContent));
        surat.setDefaultColspan(2);
        surat.addCell(new Phrase("Kepada", fontContent));

        surat.setDefaultColspan(5);
        surat.addCell(new Phrase("", fontContent));
        surat.setDefaultColspan(2);
        surat.addCell(new Phrase("Yth. Accounting Manager", fontContent));

        surat.setDefaultColspan(5);
        surat.addCell(new Phrase("", fontContent));
        surat.setDefaultColspan(2);
        surat.addCell(new Phrase(invoiceUPAL.getPNamaKomersil(), fontContent));

        surat.setDefaultColspan(5);
        surat.addCell(new Phrase("", fontContent));
        surat.setDefaultColspan(2);
        surat.addCell(new Phrase(invoiceUPAL.getPAlamatBadan(), fontContent));

        surat.setDefaultColspan(7);
        surat.addCell(new Phrase("", fontContent));

        surat.setDefaultColspan(7);
        surat.addCell(new Phrase("", fontContent));

        surat.setDefaultColspan(2);
        surat.setDefaultHorizontalAlignment(Cell.ALIGN_RIGHT);
        surat.addCell(new Phrase("1.", fontContent));
        surat.setDefaultColspan(5);
        surat.setDefaultHorizontalAlignment(Cell.ALIGN_LEFT);
        surat.addCell(new Phrase("Terlampir kami sampaikan tagihan sejumlah Rp. " + JSPFormater.formatNumber(invoiceUPAL.getTagihan(), "#,###.-"), fontContent));

        surat.setDefaultColspan(2);
        surat.addCell(new Phrase("", fontContent));
        surat.setDefaultColspan(5);
        surat.addCell(new Phrase("(" + invoiceUPAL.getStrTagihan() + " Rupiah )", fontContentArt));

        surat.setDefaultColspan(2);
        surat.setDefaultHorizontalAlignment(Cell.ALIGN_RIGHT);
        surat.addCell(new Phrase("2.", fontContent));
        surat.setDefaultColspan(5);
        surat.setDefaultHorizontalAlignment(Cell.ALIGN_LEFT);
        surat.addCell(new Phrase("Kami harapkan jumlah tersebut dibayarkan langsung ke " + invoiceUPAL.getRekening(), fontContent));

        surat.setDefaultColspan(2);
        surat.setDefaultHorizontalAlignment(Cell.ALIGN_RIGHT);
        surat.addCell(new Phrase("3.", fontContent));
        surat.setDefaultColspan(5);
        surat.setDefaultHorizontalAlignment(Cell.ALIGN_LEFT);
        surat.addCell(new Phrase("Demikian atas perhatian dan kerjasama yang baik kami ucapkan terima kasih", fontContent));

        surat.setDefaultColspan(7);
        surat.addCell(new Phrase("", fontContent));

        surat.setDefaultColspan(7);
        surat.addCell(new Phrase("", fontContent));

        surat.setDefaultColspan(7);
        surat.addCell(new Phrase("", fontContent));

        surat.setDefaultColspan(4);
        surat.addCell(new Phrase("", fontContent));
        surat.setDefaultHorizontalAlignment(Cell.ALIGN_CENTER);
        surat.setDefaultColspan(3);
        surat.addCell(new Phrase(invoiceUPAL.getNamaBadan(), fontContent));

        surat.setDefaultColspan(4);
        surat.addCell(new Phrase("", fontContent));
        surat.setDefaultHorizontalAlignment(Cell.ALIGN_CENTER);
        surat.setDefaultColspan(3);
        surat.addCell(new Phrase("D I R E K S I", fontContent));

        surat.setDefaultColspan(7);
        surat.addCell(new Phrase("", fontContent));

        surat.setDefaultColspan(7);
        surat.addCell(new Phrase("", fontContent));

        surat.setDefaultColspan(4);
        surat.addCell(new Phrase("", fontContent));
        surat.setDefaultHorizontalAlignment(Cell.ALIGN_CENTER);
        surat.setDefaultColspan(3);
        surat.addCell(new Phrase(invoiceUPAL.getTtdNama(), fontContentBold));

        surat.setDefaultColspan(4);
        surat.addCell(new Phrase("", fontContent));
        surat.setDefaultHorizontalAlignment(Cell.ALIGN_CENTER);
        surat.setDefaultColspan(3);
        surat.addCell(new Phrase(invoiceUPAL.getTtdJabatan(), fontContent));

        return surat;
    }

    private static Table getPerhitungan(Document document, InvoiceUPAL invoiceUPAL, Image logo)
            throws BadElementException, DocumentException {
        double pemakaian = invoiceUPAL.getBulanIni() - invoiceUPAL.getBulanLalu();
        double netPemakaian = pemakaian * (invoiceUPAL.getPersenPemakaian() / 100);
        double jumlah = netPemakaian * invoiceUPAL.getHarga();
        double jumlahPpn = jumlah * (invoiceUPAL.getPpn() / 100);
        double total = jumlah + jumlahPpn;

        document.newPage();
        Table perhitungan = new Table(6);
        int[] colWidth = {15, 20, 15, 15, 15, 20};
        perhitungan.setWidths(colWidth);
        perhitungan.setWidth(100);
        perhitungan.setCellpadding(1);
        perhitungan.setCellspacing(1);
        perhitungan.setBorderColor(whiteColor);

        logo.scalePercent(25);
        logo.setAbsolutePosition(80, 765);
        document.add(logo);

        perhitungan.setDefaultCellBorder(Table.NO_BORDER);
        perhitungan.setDefaultHorizontalAlignment(Cell.ALIGN_CENTER);
        perhitungan.setDefaultVerticalAlignment(Cell.ALIGN_MIDDLE);
        perhitungan.setDefaultRowspan(1);
        perhitungan.setDefaultColspan(6);
        perhitungan.addCell(new Phrase(invoiceUPAL.getNamaBadan(), fontHeaderBoldS));
        perhitungan.addCell(new Phrase(invoiceUPAL.getNamaKomersil(), fontHeaderS));
        perhitungan.addCell(new Phrase("REKENING " + invoiceUPAL.getInvoiceDesc().toUpperCase(), fontContentBoldS));

        perhitungan.setDefaultRowspan(1);
        perhitungan.setDefaultColspan(6);
        perhitungan.addCell(new Phrase("", fontContentS));

        perhitungan.setDefaultHorizontalAlignment(Cell.ALIGN_LEFT);
        perhitungan.setDefaultRowspan(1);
        perhitungan.setDefaultColspan(1);
        perhitungan.addCell(new Phrase("Bulan", fontContentS));
        perhitungan.setDefaultRowspan(1);
        perhitungan.setDefaultColspan(5);
        perhitungan.addCell(new Phrase(": " + invoiceUPAL.getPeriode(), fontContentS));

        perhitungan.setDefaultHorizontalAlignment(Cell.ALIGN_LEFT);
        perhitungan.setDefaultRowspan(1);
        perhitungan.setDefaultColspan(1);
        perhitungan.addCell(new Phrase("Nama", fontContentS));
        perhitungan.setDefaultRowspan(1);
        perhitungan.setDefaultColspan(5);
        perhitungan.addCell(new Phrase(": " + invoiceUPAL.getPNamaKomersil(), fontContentS));

        perhitungan.setDefaultHorizontalAlignment(Cell.ALIGN_LEFT);
        perhitungan.setDefaultRowspan(1);
        perhitungan.setDefaultColspan(1);
        perhitungan.addCell(new Phrase("Alamat", fontContentS));
        perhitungan.setDefaultRowspan(1);
        perhitungan.setDefaultColspan(5);
        perhitungan.addCell(new Phrase(": " + invoiceUPAL.getPAlamatBadan(), fontContentS));

        perhitungan.setDefaultRowspan(1);
        perhitungan.setDefaultColspan(6);
        perhitungan.addCell(new Phrase("", fontContentS));

        perhitungan.setDefaultCellBorder(Cell.TOP | Cell.RIGHT | Cell.BOTTOM | Cell.LEFT);
        perhitungan.setDefaultHorizontalAlignment(Cell.ALIGN_CENTER);
        perhitungan.setDefaultVerticalAlignment(Cell.ALIGN_MIDDLE);
        perhitungan.setDefaultRowspan(2);
        perhitungan.setDefaultColspan(2);
        perhitungan.addCell(new Phrase("ANGKA METER", fontContentBoldS));
        perhitungan.setDefaultRowspan(1);
        perhitungan.setDefaultColspan(3);
        perhitungan.addCell(new Phrase("JENIS TARIF", fontContentBoldS));
        perhitungan.setDefaultRowspan(2);
        perhitungan.setDefaultColspan(1);
        perhitungan.addCell(new Phrase("Nomor Rekening", fontContentBoldS));

        perhitungan.setDefaultRowspan(1);
        perhitungan.setDefaultColspan(1);
        perhitungan.addCell(new Phrase("Pemakaian (m3)", fontContentBoldS));
        perhitungan.setDefaultRowspan(1);
        perhitungan.setDefaultColspan(1);
        perhitungan.addCell(new Phrase("Harga (m3)", fontContentBoldS));
        perhitungan.setDefaultRowspan(1);
        perhitungan.setDefaultColspan(1);
        perhitungan.addCell(new Phrase("Jumlah (Rp)", fontContentBoldS));

        perhitungan.setDefaultCellBorder(Cell.RIGHT | Cell.LEFT);
        perhitungan.setDefaultHorizontalAlignment(Cell.ALIGN_LEFT);
        perhitungan.setDefaultVerticalAlignment(Cell.ALIGN_BOTTOM);
        perhitungan.setDefaultRowspan(1);
        perhitungan.setDefaultColspan(2);
        perhitungan.addCell(new Phrase("a. Pemakaian Air", fontContentS));
        perhitungan.setDefaultColspan(1);
        perhitungan.setDefaultHorizontalAlignment(Cell.ALIGN_RIGHT);
        perhitungan.addCell(new Phrase(JSPFormater.formatNumber(netPemakaian, "#,###"), fontContentS));
        perhitungan.addCell(new Phrase(JSPFormater.formatNumber(invoiceUPAL.getHarga(), "#,###"), fontContentS));
        perhitungan.addCell(new Phrase(JSPFormater.formatNumber(jumlah, "#,###"), fontContentS));
        perhitungan.setDefaultHorizontalAlignment(Cell.ALIGN_CENTER);
        perhitungan.addCell(new Phrase("Jenis Langganan", fontContentS));

        perhitungan.setDefaultHorizontalAlignment(Cell.ALIGN_LEFT);
        perhitungan.setDefaultRowspan(1);
        perhitungan.setDefaultColspan(1);
        perhitungan.setDefaultCellBorder(Cell.LEFT);
        perhitungan.addCell(new Phrase("   Bulan Ini", fontContentS));
        perhitungan.setDefaultCellBorder(Cell.RIGHT);
        perhitungan.addCell(new Phrase(": " + invoiceUPAL.getBulanIni() + " m3", fontContentS));
        perhitungan.setDefaultCellBorder(Cell.RIGHT | Cell.LEFT);
        perhitungan.addCell(new Phrase("", fontContentS));
        perhitungan.addCell(new Phrase("", fontContentS));
        perhitungan.addCell(new Phrase("", fontContentS));
        perhitungan.addCell(new Phrase("", fontContentS));

        perhitungan.setDefaultRowspan(1);
        perhitungan.setDefaultColspan(1);
        perhitungan.setDefaultCellBorder(Cell.LEFT);
        perhitungan.addCell(new Phrase("   Bulan Lalu", fontContentS));
        perhitungan.setDefaultCellBorder(Cell.RIGHT);
        perhitungan.addCell(new Phrase(": " + invoiceUPAL.getBulanLalu() + " m3", fontContentS));
        perhitungan.setDefaultCellBorder(Cell.RIGHT | Cell.LEFT);
        perhitungan.addCell(new Phrase("", fontContentS));
        perhitungan.addCell(new Phrase("", fontContentS));
        perhitungan.addCell(new Phrase("", fontContentS));
        perhitungan.addCell(new Phrase("", fontContentS));

        perhitungan.setDefaultRowspan(1);
        perhitungan.setDefaultColspan(1);
        perhitungan.setDefaultCellBorder(Cell.LEFT);
        perhitungan.addCell(new Phrase("   Pemakaian", fontContentS));
        perhitungan.setDefaultCellBorder(Cell.RIGHT);
        perhitungan.addCell(new Phrase(": " + JSPFormater.formatNumber(pemakaian, "#,###") + " m3", fontContentS));
        perhitungan.setDefaultCellBorder(Cell.RIGHT | Cell.BOTTOM | Cell.LEFT);
        perhitungan.addCell(new Phrase((jumlahPpn > 0 ? "PPN 10 %" : ""), fontContentS));
        perhitungan.addCell(new Phrase("", fontContentS));
        perhitungan.setDefaultHorizontalAlignment(Cell.ALIGN_RIGHT);
        perhitungan.addCell(new Phrase((jumlahPpn > 0 ? JSPFormater.formatNumber(jumlahPpn, "#,###") : ""), fontContentS));
        perhitungan.setDefaultHorizontalAlignment(Cell.ALIGN_CENTER);
        perhitungan.addCell(new Phrase("No. SBG", fontContentS));

        perhitungan.setDefaultHorizontalAlignment(Cell.ALIGN_LEFT);
        perhitungan.setDefaultRowspan(1);
        perhitungan.setDefaultColspan(2);
        perhitungan.setDefaultCellBorder(Cell.RIGHT | Cell.LEFT);
        perhitungan.addCell(new Phrase("b. " + invoiceUPAL.getInvoiceDesc(), fontContentS));
        perhitungan.setDefaultColspan(2);
        perhitungan.addCell(new Phrase("Dana Meter", fontContentS));
        perhitungan.setDefaultColspan(1);
        perhitungan.addCell(new Phrase("", fontContentS));
        perhitungan.setDefaultHorizontalAlignment(Cell.ALIGN_CENTER);
        perhitungan.addCell(new Phrase("Areal", fontContentS));

        perhitungan.setDefaultRowspan(1);
        perhitungan.setDefaultColspan(2);
        perhitungan.setDefaultCellBorder(Cell.LEFT);
        perhitungan.addCell(new Phrase("   " + JSPFormater.formatNumber(invoiceUPAL.getPersenPemakaian(), "#,###") + "% x " + JSPFormater.formatNumber(pemakaian, "#,###") + " = " + JSPFormater.formatNumber(netPemakaian, "#,###") + " m3", fontContentS));
        perhitungan.setDefaultCellBorder(Cell.RIGHT);
        perhitungan.setDefaultColspan(2);
        perhitungan.setDefaultCellBorder(Cell.LEFT | Cell.RIGHT);
        perhitungan.addCell(new Phrase("Biaya Administrasi", fontContentS));
        perhitungan.setDefaultColspan(1);
        perhitungan.addCell(new Phrase("", fontContentS));
        perhitungan.addCell(new Phrase("", fontContentS));

        perhitungan.setDefaultRowspan(1);
        perhitungan.setDefaultColspan(1);
        perhitungan.setDefaultCellBorder(Cell.LEFT);
        perhitungan.addCell(new Phrase("", fontContentS));
        perhitungan.setDefaultCellBorder(Cell.RIGHT);
        perhitungan.addCell(new Phrase("", fontContentS));
        perhitungan.setDefaultColspan(2);
        perhitungan.setDefaultCellBorder(Cell.LEFT | Cell.BOTTOM | Cell.RIGHT);
        perhitungan.addCell(new Phrase("Biaya Materai", fontContentS));
        perhitungan.setDefaultColspan(1);
        perhitungan.addCell(new Phrase("", fontContentS));
        perhitungan.setDefaultCellBorder(Cell.LEFT | Cell.RIGHT);
        perhitungan.addCell(new Phrase("", fontContentS));

        perhitungan.setDefaultRowspan(1);
        perhitungan.setDefaultColspan(1);
        perhitungan.setDefaultCellBorder(Cell.LEFT | Cell.BOTTOM);
        perhitungan.addCell(new Phrase("", fontContentS));
        perhitungan.setDefaultCellBorder(Cell.RIGHT | Cell.BOTTOM);
        perhitungan.addCell(new Phrase("", fontContentS));
        perhitungan.setDefaultColspan(2);
        perhitungan.setDefaultCellBorder(Cell.LEFT | Cell.RIGHT | Cell.BOTTOM);
        perhitungan.setDefaultHorizontalAlignment(Cell.ALIGN_CENTER);
        perhitungan.addCell(new Phrase("T O T A L", fontContentBoldS));
        perhitungan.setDefaultColspan(1);
        perhitungan.setDefaultHorizontalAlignment(Cell.ALIGN_RIGHT);
        perhitungan.addCell(new Phrase(JSPFormater.formatNumber(total, "#,###"), fontContentS));
        perhitungan.addCell(new Phrase("", fontContentS));

        perhitungan.setDefaultHorizontalAlignment(Cell.ALIGN_LEFT);
        perhitungan.setDefaultRowspan(1);
        perhitungan.setDefaultColspan(4);
        perhitungan.setDefaultCellBorder(Cell.NO_BORDER);
        perhitungan.addCell(new Phrase("", fontContentS));
        perhitungan.setDefaultRowspan(1);
        perhitungan.setDefaultColspan(2);
        perhitungan.setDefaultHorizontalAlignment(Cell.ALIGN_CENTER);
        perhitungan.addCell(new Phrase("Nusa Dua, " + invoiceUPAL.getInvoiceDate(), fontContentS));

        /** Tanda Terima */
        perhitungan.setDefaultRowspan(1);
        perhitungan.setDefaultColspan(6);
        perhitungan.addCell(new Phrase("", fontContentS));

        perhitungan.setDefaultRowspan(1);
        perhitungan.setDefaultColspan(6);
        perhitungan.addCell(new Phrase("", fontContentS));

        perhitungan.setDefaultRowspan(1);
        perhitungan.setDefaultColspan(6);
        perhitungan.addCell(new Phrase("", fontContentS));

        perhitungan.setDefaultRowspan(1);
        perhitungan.setDefaultColspan(6);
        perhitungan.addCell(new Phrase("", fontContentS));

        perhitungan.setDefaultRowspan(1);
        perhitungan.setDefaultColspan(6);
        perhitungan.addCell(new Phrase("", fontContentS));

        perhitungan.setDefaultRowspan(1);
        perhitungan.setDefaultColspan(6);
        perhitungan.addCell(new Phrase("", fontContentS));

        logo.scalePercent(25);
        logo.setAbsolutePosition(80, 345);
        document.add(logo);

        perhitungan.setDefaultCellBorder(Table.NO_BORDER);
        perhitungan.setDefaultHorizontalAlignment(Cell.ALIGN_CENTER);
        perhitungan.setDefaultVerticalAlignment(Cell.ALIGN_MIDDLE);
        perhitungan.setDefaultRowspan(1);
        perhitungan.setDefaultColspan(6);
        perhitungan.addCell(new Phrase(invoiceUPAL.getNamaBadan(), fontHeaderBoldS));
        perhitungan.addCell(new Phrase(invoiceUPAL.getNamaKomersil(), fontHeaderS));
        perhitungan.addCell(new Phrase("", fontContentBoldS));

        perhitungan.setDefaultRowspan(1);
        perhitungan.setDefaultColspan(6);
        perhitungan.setDefaultHorizontalAlignment(Cell.ALIGN_CENTER);
        perhitungan.addCell(new Phrase("TANDA TERIMA", fontTitle));

        perhitungan.setDefaultRowspan(1);
        perhitungan.setDefaultColspan(6);
        perhitungan.addCell(new Phrase("", fontContentS));

        perhitungan.setDefaultRowspan(1);
        perhitungan.setDefaultColspan(6);
        perhitungan.addCell(new Phrase("", fontContentS));

        perhitungan.setDefaultHorizontalAlignment(Cell.ALIGN_LEFT);
        perhitungan.setDefaultRowspan(1);
        perhitungan.setDefaultColspan(1);
        perhitungan.addCell(new Phrase("KEPADA YTH.", fontContentBoldS));
        perhitungan.setDefaultColspan(5);
        perhitungan.addCell(new Phrase(": " + invoiceUPAL.getPNamaBadan(), fontContentS));

        perhitungan.setDefaultRowspan(1);
        perhitungan.setDefaultColspan(1);
        perhitungan.addCell(new Phrase("ALAMAT", fontContentBoldS));
        perhitungan.setDefaultColspan(5);
        perhitungan.addCell(new Phrase(": " + invoiceUPAL.getPAlamatBadan(), fontContentS));

        perhitungan.setDefaultRowspan(1);
        perhitungan.setDefaultColspan(1);
        perhitungan.addCell(new Phrase("NO. SURAT", fontContentBoldS));
        perhitungan.setDefaultColspan(5);
        perhitungan.addCell(new Phrase(": " + invoiceUPAL.getNomor(), fontContentS));

        perhitungan.setDefaultRowspan(1);
        perhitungan.setDefaultColspan(1);
        perhitungan.addCell(new Phrase("TGL. SURAT", fontContentBoldS));
        perhitungan.setDefaultColspan(5);
        perhitungan.addCell(new Phrase(": " + invoiceUPAL.getInvoiceDate(), fontContentS));

        perhitungan.setDefaultRowspan(1);
        perhitungan.setDefaultColspan(1);
        perhitungan.addCell(new Phrase("PERIHAL", fontContentBoldS));
        perhitungan.setDefaultColspan(5);
        perhitungan.addCell(new Phrase(": Tagihan Jasa Pengolahan " + invoiceUPAL.getInvoiceDesc() + " " + invoiceUPAL.getPeriode(), fontContentS));

        perhitungan.setDefaultRowspan(1);
        perhitungan.setDefaultColspan(1);
        perhitungan.addCell(new Phrase("DIKIRIM TGL.", fontContentBoldS));
        perhitungan.setDefaultColspan(5);
        perhitungan.addCell(new Phrase(": ", fontContentS));

        perhitungan.setDefaultRowspan(1);
        perhitungan.setDefaultColspan(6);
        perhitungan.setDefaultCellBorder(Table.BOTTOM);
        perhitungan.addCell(new Phrase("", fontContent));

        perhitungan.setDefaultCellBorder(Table.NO_BORDER);
        perhitungan.setDefaultRowspan(1);
        perhitungan.setDefaultColspan(6);
        perhitungan.addCell(new Phrase("", fontContentS));

        perhitungan.setDefaultHorizontalAlignment(Cell.ALIGN_CENTER);
        perhitungan.setDefaultRowspan(1);
        perhitungan.setDefaultColspan(2);
        perhitungan.addCell(new Phrase("YANG MENERIMA", fontContentS));
        perhitungan.addCell(new Phrase("", fontContentS));
        perhitungan.addCell(new Phrase("YANG MENYERAHKAN", fontContentS));

        perhitungan.setDefaultRowspan(1);
        perhitungan.setDefaultColspan(6);
        perhitungan.addCell(new Phrase("", fontContent));

        perhitungan.setDefaultRowspan(1);
        perhitungan.setDefaultColspan(6);
        perhitungan.addCell(new Phrase("", fontContent));

        perhitungan.setDefaultRowspan(1);
        perhitungan.setDefaultColspan(2);
        perhitungan.addCell(new Phrase("_______________________", fontContentS));
        perhitungan.addCell(new Phrase("", fontContentS));
        perhitungan.addCell(new Phrase("_______________________", fontContentS));

        perhitungan.setDefaultRowspan(1);
        perhitungan.setDefaultColspan(2);
        perhitungan.addCell(new Phrase("NAMA TERANG / NO. TELP.", fontContentS));
        perhitungan.addCell(new Phrase("", fontContentS));
        perhitungan.addCell(new Phrase("", fontContentS));

        return perhitungan;
    }

    private static Table getFaktur(Document document, InvoiceUPAL invoiceUPAL, Image logo)
            throws BadElementException, DocumentException {
        double pemakaian = invoiceUPAL.getBulanIni() - invoiceUPAL.getBulanLalu();
        double netPemakaian = pemakaian * (invoiceUPAL.getPersenPemakaian() / 100);
        double jumlah = netPemakaian * invoiceUPAL.getHarga();
        double jumlahPpn = jumlah * (invoiceUPAL.getPpn() / 100);

        if (jumlahPpn > 0) {
            document.newPage();
            Table faktur = new Table(7);
            int[] colWidth = {5, 10, 19, 19, 5, 21, 21};
            faktur.setWidths(colWidth);
            faktur.setWidth(100);
            faktur.setCellpadding(2);
            faktur.setCellspacing(2);
            faktur.setBorderColor(whiteColor);

            faktur.setDefaultCellBorder(Table.NO_BORDER);
            faktur.setDefaultRowspan(1);
            faktur.setDefaultColspan(7);
            faktur.addCell(new Phrase("", fontContentBold));

            faktur.setDefaultCellBorder(Table.LEFT | Table.TOP | Table.RIGHT | Table.BOTTOM);
            faktur.setDefaultVerticalAlignment(Table.ALIGN_MIDDLE);
            faktur.setDefaultHorizontalAlignment(Cell.ALIGN_LEFT);
            faktur.setDefaultRowspan(1);
            faktur.setDefaultColspan(7);
            faktur.addCell(new Phrase("Kode dan Nomor Seri Faktur Pajak : " + invoiceUPAL.getNoFaktur(), fontContentBold));

            faktur.setDefaultRowspan(1);
            faktur.setDefaultColspan(7);
            faktur.addCell(new Phrase("Pengusaha Kena Pajak", fontContentBold));

            faktur.setDefaultRowspan(1);
            faktur.setDefaultColspan(2);
            faktur.setDefaultCellBorder(Table.LEFT);
            faktur.addCell(new Phrase("Nama", fontContent));
            faktur.setDefaultColspan(5);
            faktur.setDefaultCellBorder(Table.RIGHT);
            faktur.addCell(new Phrase(": " + invoiceUPAL.getNamaBadan(), fontContent));

            faktur.setDefaultRowspan(1);
            faktur.setDefaultColspan(2);
            faktur.setDefaultCellBorder(Table.LEFT);
            faktur.addCell(new Phrase("Alamat", fontContent));
            faktur.setDefaultColspan(5);
            faktur.setDefaultCellBorder(Table.RIGHT);
            faktur.addCell(new Phrase(": " + invoiceUPAL.getAlamatBadan(), fontContent));

            faktur.setDefaultRowspan(1);
            faktur.setDefaultColspan(2);
            faktur.setDefaultCellBorder(Table.LEFT);
            faktur.addCell(new Phrase("NPWP", fontContent));
            faktur.setDefaultColspan(5);
            faktur.setDefaultCellBorder(Table.RIGHT);
            faktur.addCell(new Phrase(": " + invoiceUPAL.getNpwp(), fontContent));

            faktur.setDefaultCellBorder(Table.LEFT | Table.TOP | Table.RIGHT | Table.BOTTOM);
            faktur.setDefaultRowspan(1);
            faktur.setDefaultColspan(7);
            faktur.addCell(new Phrase("Pembeli Barang Kena Pajak/Penerima Jasa Kena Pajak", fontContent));

            faktur.setDefaultRowspan(1);
            faktur.setDefaultColspan(2);
            faktur.setDefaultCellBorder(Table.LEFT);
            faktur.addCell(new Phrase("Nama", fontContent));
            faktur.setDefaultColspan(5);
            faktur.setDefaultCellBorder(Table.RIGHT);
            faktur.addCell(new Phrase(": " + invoiceUPAL.getPNamaBadan(), fontContent));

            faktur.setDefaultRowspan(1);
            faktur.setDefaultColspan(2);
            faktur.setDefaultCellBorder(Table.LEFT);
            faktur.addCell(new Phrase("Alamat", fontContent));
            faktur.setDefaultColspan(5);
            faktur.setDefaultCellBorder(Table.RIGHT);
            faktur.addCell(new Phrase(": " + invoiceUPAL.getPAlamatBadan(), fontContent));

            faktur.setDefaultRowspan(1);
            faktur.setDefaultColspan(2);
            faktur.setDefaultCellBorder(Table.LEFT);
            faktur.addCell(new Phrase("NPWP", fontContent));
            faktur.setDefaultColspan(5);
            faktur.setDefaultCellBorder(Table.RIGHT);
            faktur.addCell(new Phrase(": " + invoiceUPAL.getPNPWP(), fontContent));

            faktur.setDefaultCellBorder(Table.LEFT | Table.TOP | Table.RIGHT | Table.BOTTOM);
            faktur.setDefaultHorizontalAlignment(Cell.ALIGN_CENTER);
            faktur.setDefaultRowspan(2);
            faktur.setDefaultColspan(1);
            faktur.addCell(new Phrase("No.", fontContent));
            faktur.setDefaultRowspan(2);
            faktur.setDefaultColspan(4);
            faktur.addCell(new Phrase("Nama Barang Kena Pajak/Jasa Kena Pajak", fontContent));
            faktur.setDefaultRowspan(1);
            faktur.setDefaultColspan(2);
            faktur.addCell(new Phrase("Harga Jual/Penggantian/Uang Muka/Termin", fontContent));

            faktur.setDefaultRowspan(1);
            faktur.setDefaultColspan(1);
            faktur.addCell(new Phrase("Valas *)", fontContent));
            faktur.addCell(new Phrase("Rp", fontContent));

            faktur.setDefaultCellBorder(Table.LEFT | Table.RIGHT);
            faktur.setDefaultHorizontalAlignment(Cell.ALIGN_LEFT);
            faktur.setDefaultRowspan(1);
            faktur.setDefaultColspan(1);
            faktur.addCell(new Phrase("", fontContent));
            faktur.setDefaultColspan(4);
            faktur.addCell(new Phrase("", fontContent));
            faktur.setDefaultColspan(1);
            faktur.addCell(new Phrase("", fontContent));
            faktur.addCell(new Phrase("", fontContent));

            faktur.setDefaultRowspan(1);
            faktur.setDefaultColspan(1);
            faktur.setDefaultHorizontalAlignment(Cell.ALIGN_CENTER);
            faktur.addCell(new Phrase("1.", fontContent));
            faktur.setDefaultColspan(4);
            faktur.setDefaultHorizontalAlignment(Cell.ALIGN_LEFT);
            faktur.addCell(new Phrase("Tagihan Jasa Pengolahan " + invoiceUPAL.getInvoiceDesc() + " " + invoiceUPAL.getPeriode(), fontContent));
            faktur.setDefaultColspan(1);
            faktur.addCell(new Phrase("", fontContent));
            faktur.setDefaultHorizontalAlignment(Cell.ALIGN_RIGHT);
            faktur.addCell(new Phrase(JSPFormater.formatNumber(jumlah, "#,###"), fontContent));

            faktur.setDefaultRowspan(1);
            faktur.setDefaultColspan(1);
            faktur.addCell(new Phrase("", fontContent));
            faktur.setDefaultColspan(4);
            faktur.addCell(new Phrase("", fontContent));
            faktur.setDefaultColspan(1);
            faktur.addCell(new Phrase("", fontContent));
            faktur.addCell(new Phrase("", fontContent));

            faktur.setDefaultRowspan(1);
            faktur.setDefaultColspan(1);
            faktur.addCell(new Phrase("", fontContent));
            faktur.setDefaultColspan(4);
            faktur.addCell(new Phrase("", fontContent));
            faktur.setDefaultColspan(1);
            faktur.addCell(new Phrase("", fontContent));
            faktur.addCell(new Phrase("", fontContent));

            faktur.setDefaultRowspan(1);
            faktur.setDefaultColspan(1);
            faktur.addCell(new Phrase("", fontContent));
            faktur.setDefaultColspan(4);
            faktur.addCell(new Phrase("", fontContent));
            faktur.setDefaultColspan(1);
            faktur.addCell(new Phrase("", fontContent));
            faktur.addCell(new Phrase("", fontContent));

            faktur.setDefaultRowspan(1);
            faktur.setDefaultColspan(1);
            faktur.addCell(new Phrase("", fontContent));
            faktur.setDefaultColspan(4);
            faktur.addCell(new Phrase("", fontContent));
            faktur.setDefaultColspan(1);
            faktur.addCell(new Phrase("", fontContent));
            faktur.addCell(new Phrase("", fontContent));

            faktur.setDefaultRowspan(1);
            faktur.setDefaultColspan(1);
            faktur.addCell(new Phrase("", fontContent));
            faktur.setDefaultColspan(4);
            faktur.addCell(new Phrase("", fontContent));
            faktur.setDefaultColspan(1);
            faktur.addCell(new Phrase("", fontContent));
            faktur.addCell(new Phrase("", fontContent));

            faktur.setDefaultRowspan(1);
            faktur.setDefaultColspan(1);
            faktur.addCell(new Phrase("", fontContent));
            faktur.setDefaultColspan(4);
            faktur.addCell(new Phrase("", fontContent));
            faktur.setDefaultColspan(1);
            faktur.addCell(new Phrase("", fontContent));
            faktur.addCell(new Phrase("", fontContent));

            faktur.setDefaultCellBorder(Table.LEFT | Table.TOP | Table.RIGHT | Table.BOTTOM);
            faktur.setDefaultHorizontalAlignment(Cell.ALIGN_LEFT);
            faktur.setDefaultRowspan(1);
            faktur.setDefaultColspan(5);
            faktur.addCell(new Phrase("Harga Jual/Penggantian/Uang Muka/Termin **)", fontContent));
            faktur.setDefaultColspan(1);
            faktur.addCell(new Phrase("", fontContent));
            faktur.setDefaultHorizontalAlignment(Cell.ALIGN_RIGHT);
            faktur.addCell(new Phrase(JSPFormater.formatNumber(jumlah, "#,###"), fontContent));

            faktur.setDefaultHorizontalAlignment(Cell.ALIGN_LEFT);
            faktur.setDefaultRowspan(1);
            faktur.setDefaultColspan(5);
            faktur.addCell(new Phrase("Dikurangi Potongan Harga", fontContent));
            faktur.setDefaultColspan(1);
            faktur.addCell(new Phrase("", fontContent));
            faktur.setDefaultHorizontalAlignment(Cell.ALIGN_RIGHT);
            faktur.addCell(new Phrase("-", fontContent));

            faktur.setDefaultHorizontalAlignment(Cell.ALIGN_LEFT);
            faktur.setDefaultRowspan(1);
            faktur.setDefaultColspan(5);
            faktur.addCell(new Phrase("Dikurangi Uang Muka yang telah diterima", fontContent));
            faktur.setDefaultColspan(1);
            faktur.addCell(new Phrase("", fontContent));
            faktur.setDefaultHorizontalAlignment(Cell.ALIGN_RIGHT);
            faktur.addCell(new Phrase("-", fontContent));

            faktur.setDefaultHorizontalAlignment(Cell.ALIGN_LEFT);
            faktur.setDefaultRowspan(1);
            faktur.setDefaultColspan(5);
            faktur.addCell(new Phrase("Dasar Pengenaan Pajak", fontContent));
            faktur.setDefaultColspan(1);
            faktur.addCell(new Phrase("", fontContent));
            faktur.setDefaultHorizontalAlignment(Cell.ALIGN_RIGHT);
            faktur.addCell(new Phrase(JSPFormater.formatNumber(jumlah, "#,###"), fontContent));

            faktur.setDefaultHorizontalAlignment(Cell.ALIGN_LEFT);
            faktur.setDefaultRowspan(1);
            faktur.setDefaultColspan(5);
            faktur.addCell(new Phrase("PPN = 10% x Dasar Pengenaan Pajak", fontContent));
            faktur.setDefaultColspan(1);
            faktur.addCell(new Phrase("", fontContent));
            faktur.setDefaultHorizontalAlignment(Cell.ALIGN_RIGHT);
            faktur.addCell(new Phrase(JSPFormater.formatNumber(jumlahPpn, "#,###"), fontContent));

            faktur.setDefaultHorizontalAlignment(Cell.ALIGN_LEFT);
            faktur.setDefaultRowspan(2);
            faktur.setDefaultColspan(4);
            faktur.setDefaultCellBorder(Table.LEFT | Table.TOP | Table.BOTTOM);
            faktur.addCell(new Phrase("Pajak Penjualan Atas Barang Mewah", fontContent));
            faktur.setDefaultCellBorder(Table.NO_BORDER);
            faktur.setDefaultRowspan(2);
            faktur.setDefaultColspan(1);
            faktur.addCell(new Phrase("", fontContent));
            faktur.setDefaultCellBorder(Table.RIGHT);
            faktur.setDefaultRowspan(1);
            faktur.setDefaultColspan(2);
            faktur.addCell(new Phrase("", fontContent));
            faktur.addCell(new Phrase("Nusa Dua, " + invoiceUPAL.getInvoiceDate(), fontContent));

            faktur.setDefaultCellBorder(Table.LEFT | Table.TOP | Table.RIGHT | Table.BOTTOM);
            faktur.setDefaultVerticalAlignment(Table.ALIGN_CENTER);
            faktur.setDefaultRowspan(1);
            faktur.setDefaultColspan(2);
            faktur.addCell(new Phrase("Tarif", fontContent));
            faktur.setDefaultColspan(1);
            faktur.addCell(new Phrase("DPP", fontContent));
            faktur.addCell(new Phrase("PPnM", fontContent));
            faktur.setDefaultCellBorder(Table.NO_BORDER);
            faktur.addCell(new Phrase("", fontContent));
            faktur.setDefaultColspan(2);
            faktur.setDefaultCellBorder(Table.RIGHT);
            faktur.addCell(new Phrase("", fontContent));

            faktur.setDefaultCellBorder(Table.LEFT | Table.TOP | Table.RIGHT | Table.BOTTOM);
            faktur.setDefaultHorizontalAlignment(Cell.ALIGN_LEFT);
            faktur.setDefaultRowspan(1);
            faktur.setDefaultColspan(2);
            faktur.addCell(new Phrase("................%", fontContent));
            faktur.setDefaultColspan(1);
            faktur.addCell(new Phrase("Rp......................", fontContent));
            faktur.addCell(new Phrase("Rp......................", fontContent));
            faktur.setDefaultCellBorder(Table.NO_BORDER);
            faktur.addCell(new Phrase("", fontContent));
            faktur.setDefaultColspan(2);
            faktur.setDefaultCellBorder(Table.RIGHT);
            faktur.addCell(new Phrase("", fontContent));

            faktur.setDefaultCellBorder(Table.LEFT | Table.TOP | Table.RIGHT | Table.BOTTOM);
            faktur.setDefaultRowspan(1);
            faktur.setDefaultColspan(2);
            faktur.addCell(new Phrase("................%", fontContent));
            faktur.setDefaultColspan(1);
            faktur.addCell(new Phrase("Rp......................", fontContent));
            faktur.addCell(new Phrase("Rp......................", fontContent));
            faktur.setDefaultCellBorder(Table.NO_BORDER);
            faktur.addCell(new Phrase("", fontContent));
            faktur.setDefaultColspan(2);
            faktur.setDefaultCellBorder(Table.RIGHT);
            faktur.addCell(new Phrase("............................................", fontContent));

            faktur.setDefaultCellBorder(Table.LEFT | Table.TOP | Table.RIGHT | Table.BOTTOM);
            faktur.setDefaultRowspan(1);
            faktur.setDefaultColspan(2);
            faktur.addCell(new Phrase("................%", fontContent));
            faktur.setDefaultColspan(1);
            faktur.addCell(new Phrase("Rp......................", fontContent));
            faktur.addCell(new Phrase("Rp......................", fontContent));
            faktur.setDefaultCellBorder(Table.NO_BORDER);
            faktur.addCell(new Phrase("", fontContent));
            faktur.setDefaultColspan(2);
            faktur.setDefaultCellBorder(Table.RIGHT);
            faktur.addCell(new Phrase("Nama       " + invoiceUPAL.getTtdNama(), fontContent));

            faktur.setDefaultCellBorder(Table.LEFT | Table.TOP | Table.RIGHT | Table.BOTTOM);
            faktur.setDefaultRowspan(1);
            faktur.setDefaultColspan(2);
            faktur.addCell(new Phrase("................%", fontContent));
            faktur.setDefaultColspan(1);
            faktur.addCell(new Phrase("Rp......................", fontContent));
            faktur.addCell(new Phrase("Rp......................", fontContent));
            faktur.setDefaultCellBorder(Table.NO_BORDER);
            faktur.addCell(new Phrase("", fontContent));
            faktur.setDefaultColspan(2);
            faktur.setDefaultCellBorder(Table.RIGHT);
            faktur.addCell(new Phrase("Jabatan    " + invoiceUPAL.getTtdJabatan(), fontContent));

            faktur.setDefaultCellBorder(Table.LEFT | Table.RIGHT | Table.BOTTOM);
            faktur.setDefaultColspan(7);
            faktur.addCell(new Phrase("", fontContent));

            faktur.setDefaultCellBorder(Table.NO_BORDER);
            faktur.setDefaultColspan(7);
            faktur.addCell(new Phrase("*) Diisi apabila penyerahan menggunakan mata uang asing", fontContent));

            faktur.setDefaultColspan(7);
            faktur.addCell(new Phrase("**) Coret yang tidak perlu", fontContent));

            return faktur;
        }

        return new Table(0);
    }
}
