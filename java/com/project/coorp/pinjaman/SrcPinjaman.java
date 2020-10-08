/*
 * SrcPinjaman.java
 *
 * Created on May 19, 2009, 4:33 PM
 */

package com.project.coorp.pinjaman;

import java.util.*;
import java.sql.*;
import com.project.coorp.pinjaman.*;
import com.project.coorp.member.*;
import java.util.Date;
import com.project.util.*;
import com.project.main.db.*;

/**
 *
 * @author  Valued Customer
 */
public class SrcPinjaman {
    
    /**
     * Holds value of property noAnggota.
     */
    private String noAnggota;
    
    /**
     * Holds value of property namaAnggota.
     */
    private String namaAnggota;
    
    /**
     * Holds value of property startDate.
     */
    private Date startDate;
    
    /**
     * Holds value of property endDate.
     */
    private Date endDate;
    
    /**
     * Holds value of property status.
     */
    private int status;
    
    /**
     * Holds value of property ignoreDate.
     */
    private int ignoreDate;
    
    /**
     * Holds value of property noRekening.
     */
    private String noRekening;
    
    /**
     * Holds value of property startAmount.
     */
    private double startAmount;
    
    /**
     * Holds value of property amountTo.
     */
    private double amountTo;
    
    /**
     * Holds value of property ignoreAmount.
     */
    private int ignoreAmount;
    
    /**
     * Holds value of property jenisPinjaman.
     */
    private int jenisPinjaman;
    
    /**
     * Holds value of property bankId.
     */
    private long bankId;
    
    /**
     * Holds value of property type.
     */
    private int type;
    
    /** Creates a new instance of SrcPinjaman */
    public SrcPinjaman() {
    }
    
    /**
     * Getter for property noAnggota.
     * @return Value of property noAnggota.
     */
    public String getNoAnggota() {
        return this.noAnggota;
    }
    
    /**
     * Setter for property noAnggota.
     * @param noAnggota New value of property noAnggota.
     */
    public void setNoAnggota(String noAnggota) {
        this.noAnggota = noAnggota;
    }
    
    /**
     * Getter for property namaAnggota.
     * @return Value of property namaAnggota.
     */
    public String getNamaAnggota() {
        return this.namaAnggota;
    }
    
    /**
     * Setter for property namaAnggota.
     * @param namaAnggota New value of property namaAnggota.
     */
    public void setNamaAnggota(String namaAnggota) {
        this.namaAnggota = namaAnggota;
    }
    
    /**
     * Getter for property startDate.
     * @return Value of property startDate.
     */
    public Date getStartDate() {
        return this.startDate;
    }
    
    /**
     * Setter for property startDate.
     * @param startDate New value of property startDate.
     */
    public void setStartDate(Date startDate) {
        this.startDate = startDate;
    }
    
    /**
     * Getter for property endDate.
     * @return Value of property endDate.
     */
    public Date getEndDate() {
        return this.endDate;
    }
    
    /**
     * Setter for property endDate.
     * @param endDate New value of property endDate.
     */
    public void setEndDate(Date endDate) {
        this.endDate = endDate;
    }
    
    /**
     * Getter for property status.
     * @return Value of property status.
     */
    public int getStatus() {
        return this.status;
    }
    
    /**
     * Setter for property status.
     * @param status New value of property status.
     */
    public void setStatus(int status) {
        this.status = status;
    }
    
    /**
     * Getter for property ignoreDate.
     * @return Value of property ignoreDate.
     */
    public int getIgnoreDate() {
        return this.ignoreDate;
    }
    
    /**
     * Setter for property ignoreDate.
     * @param ignoreDate New value of property ignoreDate.
     */
    public void setIgnoreDate(int ignoreDate) {
        this.ignoreDate = ignoreDate;
    }
    
    /**
     * Getter for property noRekening.
     * @return Value of property noRekening.
     */
    public String getNoRekening() {
        return this.noRekening;
    }
    
    /**
     * Setter for property noRekening.
     * @param noRekening New value of property noRekening.
     */
    public void setNoRekening(String noRekening) {
        this.noRekening = noRekening;
    }
    
    /**
     * Getter for property startAmount.
     * @return Value of property startAmount.
     */
    public double getStartAmount() {
        return this.startAmount;
    }
    
    /**
     * Setter for property startAmount.
     * @param startAmount New value of property startAmount.
     */
    public void setStartAmount(double startAmount) {
        this.startAmount = startAmount;
    }
    
    /**
     * Getter for property amountTo.
     * @return Value of property amountTo.
     */
    public double getAmountTo() {
        return this.amountTo;
    }
    
    /**
     * Setter for property amountTo.
     * @param amountTo New value of property amountTo.
     */
    public void setAmountTo(double amountTo) {
        this.amountTo = amountTo;
    }
    
    /**
     * Getter for property ignoreAmount.
     * @return Value of property ignoreAmount.
     */
    public int getIgnoreAmount() {
        return this.ignoreAmount;
    }
    
    /**
     * Setter for property ignoreAmount.
     * @param ignoreAmount New value of property ignoreAmount.
     */
    public void setIgnoreAmount(int ignoreAmount) {
        this.ignoreAmount = ignoreAmount;
    }
    
    /**
     * Getter for property jenisPinjaman.
     * @return Value of property jenisPinjaman.
     */
    public int getJenisPinjaman() {
        return this.jenisPinjaman;
    }
    
    /**
     * Setter for property jenisPinjaman.
     * @param jenisPinjaman New value of property jenisPinjaman.
     */
    public void setJenisPinjaman(int jenisPinjaman) {
        this.jenisPinjaman = jenisPinjaman;
    }
    
    /**
     * Getter for property bankId.
     * @return Value of property bankId.
     */
    public long getBankId() {
        return this.bankId;
    }
    
    /**
     * Setter for property bankId.
     * @param bankId New value of property bankId.
     */
    public void setBankId(long bankId) {
        this.bankId = bankId;
    }
    
    
    public static Vector getList(int start, int recordToGet, SrcPinjaman sp){
            
        String sql = " SELECT p.* FROM "+DbPinjaman.DB_PINJAMAM+
                     " p inner join "+DbMember.DB_MEMBER+" m "+
                     " on m."+DbMember.colNames[DbMember.COL_MEMBER_ID]+" = p."+DbPinjaman.colNames[DbPinjaman.COL_MEMBER_ID];
        
        String where  = " where p."+DbPinjaman.colNames[DbPinjaman.COL_TYPE]+"="+sp.getType();
        
        if(sp.getJenisPinjaman()!=-1){
            where = where + " and p."+DbPinjaman.colNames[DbPinjaman.COL_JENIS_BARANG]+"="+sp.getJenisPinjaman();
        }
        
        if(sp.getNoAnggota().length()>0){
            where = where + " and m."+DbMember.colNames[DbMember.COL_NO_MEMBER]+" like '%"+sp.getNoAnggota()+"%' ";
        }
        
        if(sp.getNamaAnggota().length()>0){
            where = where + " and "+
                    " m."+DbMember.colNames[DbMember.COL_NAMA]+" like '%"+sp.getNamaAnggota()+"%' ";
        }
        
        if(sp.getBankId()!=0){
            where = where + " and "+
                    " p."+DbPinjaman.colNames[DbPinjaman.COL_BANK_ID]+"="+sp.getBankId();
        }
        
        if(sp.getIgnoreDate()==0){
            where = where + " and "+
                    " (p."+DbPinjaman.colNames[DbPinjaman.COL_DATE]+" between '"+JSPFormater.formatDate(sp.getStartDate(), "yyyy-MM-dd")+"'"+
                    " and '"+JSPFormater.formatDate(sp.getEndDate(), "yyyy-MM-dd")+"') ";
        }
        
        if(sp.getIgnoreAmount()==0){
            where = where + " and "+
                    " (p."+DbPinjaman.colNames[DbPinjaman.COL_TOTAL_PINJAMAN]+" between "+sp.getStartAmount()+" and "+sp.getAmountTo()+")";                    
        }
         
        if(sp.getNoRekening().length()>0){
            where = where + " and "+
                    " p."+DbPinjaman.colNames[DbPinjaman.COL_NUMBER]+" like '%"+sp.getNoRekening()+"%' ";
        }
        
        if(sp.getStatus()!=-1){
            where = where + " and "+
                    " p."+DbPinjaman.colNames[DbPinjaman.COL_STATUS]+"="+sp.getStatus();
        }
        
        sql = sql + where;
        
        if(recordToGet!=0){
            sql = sql + " limit "+start+","+recordToGet;
        }
        
        System.out.println(sql);
        
        Vector result = new Vector();
        
        CONResultSet crs = null;
        try{
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while(rs.next()){
                Pinjaman p = new Pinjaman();
                DbPinjaman.resultToObject(rs, p); 
                result.add(p);
            }
        }
        catch(Exception e){
        }
        finally{
            CONResultSet.close(crs);
        }        
            
        return result;
                     
    }
    
    public static Vector getListPinjamanKoperasi(int start, int recordToGet, SrcPinjaman sp){
            
        String sql = " SELECT p.* FROM "+DbPinjaman.DB_PINJAMAM +" p ";
                     //" p inner join "+DbMember.DB_MEMBER+" m "+
                     //" on m."+DbMember.colNames[DbMember.COL_MEMBER_ID]+" = p."+DbPinjaman.colNames[DbPinjaman.COL_MEMBER_ID];
        
        String where  = " where p."+DbPinjaman.colNames[DbPinjaman.COL_TYPE]+"="+sp.getType();
        
        //if(sp.getNoAnggota().length()>0){
        //    where = where + " and m."+DbMember.colNames[DbMember.COL_NO_MEMBER]+" like '%"+sp.getNoAnggota()+"%' ";
        //}
        
        //if(sp.getNamaAnggota().length()>0){
        //    where = where + " and "+
        //            " m."+DbMember.colNames[DbMember.COL_NAMA]+" like '%"+sp.getNamaAnggota()+"%' ";
        //}
        
        if(sp.getBankId()!=0){
            where = where + " and "+
                    " p."+DbPinjaman.colNames[DbPinjaman.COL_BANK_ID]+"="+sp.getBankId();
        }
        
        if(sp.getIgnoreDate()==0){
            where = where + " and "+
                    " (p."+DbPinjaman.colNames[DbPinjaman.COL_DATE]+" between '"+JSPFormater.formatDate(sp.getStartDate(), "yyyy-MM-dd")+"'"+
                    " and '"+JSPFormater.formatDate(sp.getEndDate(), "yyyy-MM-dd")+"') ";
        }
        
        if(sp.getIgnoreAmount()==0){
            where = where + " and "+
                    " (p."+DbPinjaman.colNames[DbPinjaman.COL_TOTAL_PINJAMAN]+" between "+sp.getStartAmount()+" and "+sp.getAmountTo()+")";                    
        }
         
        if(sp.getNoRekening().length()>0){
            where = where + " and "+
                    " p."+DbPinjaman.colNames[DbPinjaman.COL_NUMBER]+" like '%"+sp.getNoRekening()+"%' ";
        }
        
        if(sp.getStatus()!=-1){
            where = where + " and "+
                    " p."+DbPinjaman.colNames[DbPinjaman.COL_STATUS]+"="+sp.getStatus();
        }
        
        sql = sql + where;
        
        if(recordToGet!=0){
            sql = sql + " limit "+start+","+recordToGet;
        }
        
        System.out.println(sql);
        
        Vector result = new Vector();
        
        CONResultSet crs = null;
        try{
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while(rs.next()){
                Pinjaman p = new Pinjaman();
                DbPinjaman.resultToObject(rs, p); 
                result.add(p);
            }
        }
        catch(Exception e){
        }
        finally{
            CONResultSet.close(crs);
        }        
            
        return result;
                     
    }
    
    public static int getCount(SrcPinjaman sp){
            
        String sql = " SELECT count(p."+DbPinjaman.colNames[DbPinjaman.COL_PINJAMAN_ID]+") FROM "+DbPinjaman.DB_PINJAMAM+
                     " p inner join "+DbMember.DB_MEMBER+" m "+
                     " on m."+DbMember.colNames[DbMember.COL_MEMBER_ID]+" = p."+DbPinjaman.colNames[DbPinjaman.COL_MEMBER_ID];
        
        String where  = " where p."+DbPinjaman.colNames[DbPinjaman.COL_TYPE]+"="+sp.getType();
        
        if(sp.getJenisPinjaman()!=-1){
            where = where + " and p."+DbPinjaman.colNames[DbPinjaman.COL_JENIS_BARANG]+"="+sp.getJenisPinjaman();
        }
        
        if(sp.getNoAnggota().length()>0){
            where = where + " and m."+DbMember.colNames[DbMember.COL_NO_MEMBER]+" like '%"+sp.getNoAnggota()+"%' ";
        }
        
        if(sp.getNamaAnggota().length()>0){
            where = where + " and "+
                    " m."+DbMember.colNames[DbMember.COL_NAMA]+" like '%"+sp.getNamaAnggota()+"%' ";
        }
        
        if(sp.getBankId()!=0){
            where = where + " and "+
                    " p."+DbPinjaman.colNames[DbPinjaman.COL_BANK_ID]+"="+sp.getBankId();
        }
        
        if(sp.getIgnoreDate()==0){
            where = where + " and "+
                    " (p."+DbPinjaman.colNames[DbPinjaman.COL_DATE]+" between '"+JSPFormater.formatDate(sp.getStartDate(), "yyyy-MM-dd")+"'"+
                    " and '"+JSPFormater.formatDate(sp.getEndDate(), "yyyy-MM-dd")+"') ";
        }
        
        if(sp.getIgnoreAmount()==0){
            where = where + " and "+
                    " (p."+DbPinjaman.colNames[DbPinjaman.COL_TOTAL_PINJAMAN]+" between "+sp.getStartAmount()+" and "+sp.getAmountTo()+")";                    
        }
         
        if(sp.getNoRekening().length()>0){
            where = where + " and "+
                    " p."+DbPinjaman.colNames[DbPinjaman.COL_NUMBER]+" like '%"+sp.getNoRekening()+"%' ";
        }
        
        if(sp.getStatus()!=-1){
            where = where + " and "+
                    " p."+DbPinjaman.colNames[DbPinjaman.COL_STATUS]+"="+sp.getStatus();
        }
        
        sql = sql + where;
        
        System.out.println(sql);
        
        int result = 0;
        
        CONResultSet crs = null;
        try{
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while(rs.next()){
                result = rs.getInt(1);
            }
        }
        catch(Exception e){
        }
        finally{
            CONResultSet.close(crs);
        }        
            
        return result;
                     
    }
    
    public static int getCountPinjamanKoperasi(SrcPinjaman sp){
            
        String sql = " SELECT count(p."+DbPinjaman.colNames[DbPinjaman.COL_PINJAMAN_ID]+") FROM "+DbPinjaman.DB_PINJAMAM+" p ";
                     //" p inner join "+DbMember.DB_MEMBER+" m "+
                     //" on m."+DbMember.colNames[DbMember.COL_MEMBER_ID]+" = p."+DbPinjaman.colNames[DbPinjaman.COL_MEMBER_ID];
        
        String where  = " where p."+DbPinjaman.colNames[DbPinjaman.COL_TYPE]+"="+sp.getType();
        
        //if(sp.getNoAnggota().length()>0){
        //    where = where + " and m."+DbMember.colNames[DbMember.COL_NO_MEMBER]+" like '%"+sp.getNoAnggota()+"%' ";
        //}
        
        //if(sp.getNamaAnggota().length()>0){
        //    where = where + " and "+
        //            " m."+DbMember.colNames[DbMember.COL_NAMA]+" like '%"+sp.getNamaAnggota()+"%' ";
        //}
        
        if(sp.getBankId()!=0){
            where = where + " and "+
                    " p."+DbPinjaman.colNames[DbPinjaman.COL_BANK_ID]+"="+sp.getBankId();
        }
        
        if(sp.getIgnoreDate()==0){
            where = where + " and "+
                    " (p."+DbPinjaman.colNames[DbPinjaman.COL_DATE]+" between '"+JSPFormater.formatDate(sp.getStartDate(), "yyyy-MM-dd")+"'"+
                    " and '"+JSPFormater.formatDate(sp.getEndDate(), "yyyy-MM-dd")+"') ";
        }
        
        if(sp.getIgnoreAmount()==0){
            where = where + " and "+
                    " (p."+DbPinjaman.colNames[DbPinjaman.COL_TOTAL_PINJAMAN]+" between "+sp.getStartAmount()+" and "+sp.getAmountTo()+")";                    
        }
         
        if(sp.getNoRekening().length()>0){
            where = where + " and "+
                    " p."+DbPinjaman.colNames[DbPinjaman.COL_NUMBER]+" like '%"+sp.getNoRekening()+"%' ";
        }
        
        if(sp.getStatus()!=-1){
            where = where + " and "+
                    " p."+DbPinjaman.colNames[DbPinjaman.COL_STATUS]+"="+sp.getStatus();
        }
        
        sql = sql + where;
        
        System.out.println(sql);
        
        int result = 0;
        
        CONResultSet crs = null;
        try{
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while(rs.next()){
                result = rs.getInt(1);
            }
        }
        catch(Exception e){
        }
        finally{
            CONResultSet.close(crs);
        }        
            
        return result;
                     
    }
    
    /**
     * Getter for property type.
     * @return Value of property type.
     */
    public int getType() {
        return this.type;
    }
    
    /**
     * Setter for property type.
     * @param type New value of property type.
     */
    public void setType(int type) {
        this.type = type;
    }
    
}
