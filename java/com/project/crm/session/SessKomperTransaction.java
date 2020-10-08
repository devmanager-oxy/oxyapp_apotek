package com.project.crm.session;

import com.project.crm.I_Crm;
import com.project.crm.report.RptKomperTransaction;
import com.project.crm.sewa.DbSewaTanahBenefit;
import com.project.crm.sewa.DbSewaTanahInvoice;
import com.project.crm.sewa.SewaTanahBenefit;
import com.project.crm.sewa.SewaTanahInvoice;
import com.project.fms.transaction.DbGl;
import com.project.fms.transaction.Gl;
import com.project.general.DbCurrency;
import com.project.general.DbCustomer;
import com.project.main.db.CONHandler;
import com.project.main.db.CONResultSet;
import java.sql.ResultSet;
import java.util.Vector;

/**
 *
 * @author gwawan
 */
public class SessKomperTransaction {
    
    public static Vector ListFPKomper(int month, int year, long oidSarana) {
        CONResultSet dbrs = null;
        Vector list = new Vector();
        
        try {
            String sql = "SELECT stb." + DbSewaTanahBenefit.colNames[DbSewaTanahBenefit.COL_SEWA_TANAH_BENEFIT_ID]
                    + ", stb." + DbSewaTanahBenefit.colNames[DbSewaTanahBenefit.COL_NUMBER]
                    + ", stb." + DbSewaTanahBenefit.colNames[DbSewaTanahBenefit.COL_NO_FP]
                    + ", stb." + DbSewaTanahBenefit.colNames[DbSewaTanahBenefit.COL_TOTAL_KOMPER]
                    + ", cus." + DbCustomer.colNames[DbCustomer.COL_NAME]
                    + " FROM " + DbSewaTanahBenefit.DB_CRM_SEWA_TANAH_BENEFIT + " stb"
                    + " INNER JOIN " + DbCustomer.DB_CUSTOMER + " cus"
                    + " ON stb." + DbSewaTanahBenefit.colNames[DbSewaTanahBenefit.COL_SARANA_ID]
                    + " = cus." + DbCustomer.colNames[DbCustomer.COL_CUSTOMER_ID]
                    + " INNER JOIN " + DbSewaTanahInvoice.DB_CRM_SEWA_TANAH_INVOICE +" sti"
                    + " ON stb." + DbSewaTanahBenefit.colNames[DbSewaTanahBenefit.COL_SEWA_TANAH_INVOICE_ID]
                    + " = sti." + DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_SEWA_TANAH_INVOICE_ID];
            
            String where = " WHERE stb." + DbSewaTanahBenefit.colNames[DbSewaTanahBenefit.COL_TOTAL_KOMPER] + " != 0 "
                    + " AND (MONTH(sti." + DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_TANGGAL] + ")=" + month
                    + " AND " + "YEAR(sti." + DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_TANGGAL] + ")=" + year +")";
            
            if(oidSarana != 0) where += " AND cus." + DbCustomer.colNames[DbCustomer.COL_CUSTOMER_ID] + " = " + oidSarana;
            
            sql += where;
            
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            
            while(rs.next()) {
                RptKomperTransaction objRptKomperTransaction = new RptKomperTransaction();
                
                objRptKomperTransaction.setSewaTanahInvoiceId(rs.getLong("stb."+DbSewaTanahBenefit.colNames[DbSewaTanahBenefit.COL_SEWA_TANAH_BENEFIT_ID]));
                objRptKomperTransaction.setInvoiceNumber(rs.getString("stb."+DbSewaTanahBenefit.colNames[DbSewaTanahBenefit.COL_NUMBER]));
                objRptKomperTransaction.setNoFp(rs.getString("stb."+DbSewaTanahBenefit.colNames[DbSewaTanahBenefit.COL_NO_FP]));
                objRptKomperTransaction.setJumlahKomper(rs.getDouble("stb."+DbSewaTanahBenefit.colNames[DbSewaTanahBenefit.COL_TOTAL_KOMPER]));
                objRptKomperTransaction.setCustomerName(rs.getString("cus."+DbCustomer.colNames[DbCustomer.COL_NAME]));
                
                list.add(objRptKomperTransaction);
            }
            
            return list;
        } catch(Exception e) {
            System.out.println("Error ListFPKomin : "+e.toString());
        } finally {
            CONResultSet.close(dbrs);
        }
        return null;
    }
    
    public static void UpdateFPKomper(long oidKomper, String noFp) {
        try {
            SewaTanahBenefit objSewaTanahBenefit = new SewaTanahBenefit();
            objSewaTanahBenefit = DbSewaTanahBenefit.fetchExc(oidKomper);
            objSewaTanahBenefit.setNoFp(noFp);
            DbSewaTanahBenefit.updateExc(objSewaTanahBenefit);
        } catch(Exception e) {
            System.out.println("Error UpdateFPKomin : "+e.toString());
        }
    }
    
    public static Vector listDenda(int month, int year, long oidSarana) {
        CONResultSet dbrs = null;
        Vector list = new Vector();
        
        try {
             String sql = "SELECT stb." + DbSewaTanahBenefit.colNames[DbSewaTanahBenefit.COL_SEWA_TANAH_BENEFIT_ID]
                    + ", stb." + DbSewaTanahBenefit.colNames[DbSewaTanahBenefit.COL_JATUH_TEMPO]
                    + ", stb." + DbSewaTanahBenefit.colNames[DbSewaTanahBenefit.COL_NUMBER]
                    + ", stb." + DbSewaTanahBenefit.colNames[DbSewaTanahBenefit.COL_TOTAL_KOMPER]
                    + ", stb." + DbSewaTanahBenefit.colNames[DbSewaTanahBenefit.COL_TOTAL_DENDA]
                    + ", stb." + DbSewaTanahBenefit.colNames[DbSewaTanahBenefit.COL_STATUS_PEMBAYARAN]
                    + ", cur." + DbCurrency.colNames[DbCurrency.COL_CURRENCY_CODE]
                    + ", cus." + DbCustomer.colNames[DbCustomer.COL_NAME]
                    + " FROM " + DbSewaTanahBenefit.DB_CRM_SEWA_TANAH_BENEFIT+" stb"
                    + " INNER JOIN " + DbCustomer.DB_CUSTOMER+" cus"
                    + " ON stb." + DbSewaTanahBenefit.colNames[DbSewaTanahBenefit.COL_SARANA_ID]
                    + " = cus." + DbCustomer.colNames[DbCustomer.COL_CUSTOMER_ID]
                    + " INNER JOIN " + DbCurrency.DB_CURRENCY + " cur"
                    + " ON stb." + DbSewaTanahBenefit.colNames[DbSewaTanahBenefit.COL_CURRENCY_ID]
                    +" = cur." + DbCurrency.colNames[DbCurrency.COL_CURRENCY_ID]
                    + " INNER JOIN " + DbSewaTanahInvoice.DB_CRM_SEWA_TANAH_INVOICE +" sti"
                    + " ON stb." + DbSewaTanahBenefit.colNames[DbSewaTanahBenefit.COL_SEWA_TANAH_INVOICE_ID]
                    + " = sti." + DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_SEWA_TANAH_INVOICE_ID];
                    
            String where = " WHERE stb." + DbSewaTanahBenefit.colNames[DbSewaTanahBenefit.COL_TOTAL_KOMPER] + " != 0 "
                    + " AND (MONTH(sti." + DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_TANGGAL] + ")=" + month
                    + " AND " + "YEAR(sti." + DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_TANGGAL] + ")=" + year +")";
            
            if(oidSarana != 0) where += " AND cus." + DbCustomer.colNames[DbCustomer.COL_CUSTOMER_ID] + " = " + oidSarana;
            
            sql += where;
            
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            
            while(rs.next()) {
                RptKomperTransaction objRptKomperTransaction = new RptKomperTransaction();
                
                objRptKomperTransaction.setSewaTanahInvoiceId(rs.getLong("stb."+DbSewaTanahBenefit.colNames[DbSewaTanahBenefit.COL_SEWA_TANAH_BENEFIT_ID]));
                objRptKomperTransaction.setJatuhTempo(rs.getDate("stb."+DbSewaTanahBenefit.colNames[DbSewaTanahBenefit.COL_JATUH_TEMPO]));
                objRptKomperTransaction.setInvoiceNumber(rs.getString("stb."+DbSewaTanahBenefit.colNames[DbSewaTanahBenefit.COL_NUMBER]));
                objRptKomperTransaction.setJumlahKomper(rs.getDouble("stb."+DbSewaTanahBenefit.colNames[DbSewaTanahBenefit.COL_TOTAL_KOMPER]));
                objRptKomperTransaction.setTotalDenda(rs.getDouble("stb."+DbSewaTanahBenefit.colNames[DbSewaTanahBenefit.COL_TOTAL_DENDA]));
                objRptKomperTransaction.setStatusPembayaran(I_Crm.strJurnalStatus[rs.getInt("stb."+DbSewaTanahBenefit.colNames[DbSewaTanahBenefit.COL_STATUS_PEMBAYARAN])]);
                objRptKomperTransaction.setCurrencyCode(rs.getString("cur."+DbCurrency.colNames[DbCurrency.COL_CURRENCY_CODE]));
                objRptKomperTransaction.setCustomerName(rs.getString("cus."+DbCustomer.colNames[DbCustomer.COL_NAME]));
                
                list.add(objRptKomperTransaction);
            }
            
            return list;
        } catch(Exception e) {
            System.out.println("Error when listDenda(#,#,#)" + e.toString());
        } finally {
            CONResultSet.close(dbrs);
        }
        return null;
    }
    
    public static boolean postKomperDenda(long transaksiOID, int status){
        
        try {
            
            SewaTanahInvoice sewaTanahInvoice = new SewaTanahInvoice();
         
            sewaTanahInvoice = DbSewaTanahInvoice.fetchExc(transaksiOID);

            System.out.println("Masuk >>>> status denda : " + status);

            sewaTanahInvoice.setDendaPostStatus(status);

            // update status transaksi
            boolean ok = DbSewaTanahInvoice.postJournalDendaKomper(sewaTanahInvoice);
            
            if(ok == false){
                return false;
            }
            
            if (ok) {
                
                DbSewaTanahInvoice.updateExc(sewaTanahInvoice);

                // proses pencarian journal
                String where = "(" //+ DbGl.colNames[DbGl.COL_REF_NUMBER] + " ='" + limbahTransaction.getInvoiceNumber() + "' or " +
                        + DbGl.colNames[DbGl.COL_JOURNAL_NUMBER] + " ='" + sewaTanahInvoice.getNumber() + "D')";
                
                Vector vect = DbGl.list(0, 0, where, "");
                Gl gl = new Gl();
                if (vect.size() > 0) {
                    gl = (Gl) vect.get(0);
                }

                //===== >>> : proses insert aging denda	
                SessReceivable.prosesInsertAgingDenda(sewaTanahInvoice, gl);
                
                return true;
            }

        } catch (Exception e) {
            System.out.println("ERR >> : " + e.toString());
        }
        
        return false;
    }
    
    

}
