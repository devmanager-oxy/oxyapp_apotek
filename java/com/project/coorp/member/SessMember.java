/*
 * SessMember.java
 *
 * Created on January 5, 2009, 12:55 AM
 */

package com.project.coorp.member;

import java.util.*;
import java.sql.*;
import java.util.Date;
import com.project.main.db.*;
import com.project.main.entity.*;
import com.project.util.jsp.*;
import com.project.coorp.member.*; 
import com.project.util.*;

import com.project.main.db.CONHandler;
import com.project.main.db.CONResultSet;
import com.project.util.JSPFormater;
import java.sql.ResultSet;
import java.util.Vector;

//import com.project.e_member.search.SrcMemberStatistic;


/**
 *
 * @author  Valued Member
 */
public class SessMember {
    
    /** Creates a new instance of SessMember */
    public SessMember() {
    }
    
    
    public static Vector getMember(int start, int recordToGet, String noMember, String nama, String alamat, int jenisKelamin, long oidKecamatan
                                    ,long oidDesa, String agama, Date tglLahir1, Date tglLahir2, int s1, int s2, int s3, int s4, int s5, int s6 
                                    ,int p1, int p2, int p3, int p4, int p5, int p6, int p7, int p8, int batas, long oidPekerjaan, int status
                                    ,long dinasId, long dinasUnitId){
        
        String sql = " select * from "+DbMember.DB_MEMBER;
              /*
                    if(judul.length()>0){
                        sql = sql + " inner join "+DbSirkulasi.TBL_DS_PERPUS_SIRKULASI+" s "+
                            " on "+DbMember.colNames[DbMember.COL_ANGGOTA_ID]+" = "+
                            " s."+DbSirkulasi.colNames[DbSirkulasi.COL_ANGGOTA_ID]+
                            " inner join "+DbMember.TBL_DS_PERPUS_KATALOG+" k "+
                            " on k."+DbMember.colNames[DbMember.COL_KATALOG_ID]+" = "+
                            " s."+DbSirkulasi.colNames[DbSirkulasi.COL_KATALOG_ID];
                    }
               */
                    
                    String where = "";
                    if(noMember.length()>0){
                        where = DbMember.colNames[DbMember.COL_NO_MEMBER]+" like '%"+noMember+"%'";
                    }

                    if(nama.length()>0){
                        if(where.length()>0){
                            where = where + " and "+DbMember.colNames[DbMember.COL_NAMA]+" like '%"+nama+"%'";
                        }
                        else{
                            where = DbMember.colNames[DbMember.COL_NAMA]+" like '%"+nama+"%'";
                        }
                    }

                    if(alamat.length()>0){
                        if(where.length()>0){
                            where = where + " and "+DbMember.colNames[DbMember.COL_ALAMAT]+" like '%"+alamat+"%'";
                        }
                        else{
                            where = DbMember.colNames[DbMember.COL_ALAMAT]+" like '%"+alamat+"%'";
                        }
                    }
                    
                    if(jenisKelamin == 1){
                        if(where.length()>0){
                            where = where + " and "+DbMember.colNames[DbMember.COL_JENIS_KELAMIN]+" = " + DbMember.STATUS_AKTIF;
                        }
                        else{
                            where = DbMember.colNames[DbMember.COL_JENIS_KELAMIN]+" = " + DbMember.STATUS_AKTIF;
                        }
                    }else if(jenisKelamin == 0){
                        if(where.length()>0){
                            where = where + " and "+DbMember.colNames[DbMember.COL_JENIS_KELAMIN]+" = " + DbMember.STATUS_TIDAK_AKTIF;
                        }
                        else{
                            where = ""+DbMember.colNames[DbMember.COL_JENIS_KELAMIN]+" = " + DbMember.STATUS_TIDAK_AKTIF;
                        }
                    }else{
                        //just to show all item
                    }
                    
                    //pekerjaan
                    if(oidPekerjaan != 0){
                        if(where.length()>0){
                            where = where + " and "+DbMember.colNames[DbMember.COL_PEKERJAAN_ID]+" = " + oidPekerjaan;
                        }
                        else{
                            where = ""+DbMember.colNames[DbMember.COL_PEKERJAAN_ID]+" = " + oidPekerjaan;
                        }
                    }
                    
                     //status
                    if(status == 1){
                        if(where.length()>0){
                            where = where + " and "+DbMember.colNames[DbMember.COL_STATUS]+" = " + DbMember.STATUS_AKTIF;
                        }
                        else{
                            where = DbMember.colNames[DbMember.COL_STATUS]+" = " + DbMember.STATUS_AKTIF;
                        }
                    }
                    
                    if(status == 0){
                        if(where.length()>0){
                            where = where + " and "+DbMember.colNames[DbMember.COL_STATUS]+" = " + DbMember.STATUS_TIDAK_AKTIF;
                        }
                        else{
                            where = DbMember.colNames[DbMember.COL_STATUS]+" = " + DbMember.STATUS_TIDAK_AKTIF;
                        }
                    }
                    
                    //tanggal lahir
                    if(batas == 0){
                       // if(tglLahir1 != null && tglLahir2 != null){
                            if(where!=null && where.length()>0){
                                  where = where + " and ("+DbMember.colNames[DbMember.COL_TGL_LAHIR] +
                                  " between '" + JSPFormater.formatDate(tglLahir1, "yyyy-MM-dd")  + 
                                  "' and '"+ JSPFormater.formatDate(tglLahir2, "yyyy-MM-dd")+"')";
                            }
                            else{
                                  where = where + " ("+DbMember.colNames[DbMember.COL_TGL_LAHIR] +
                                  " between '" + JSPFormater.formatDate(tglLahir1, "yyyy-MM-dd")  + 
                                  "' and '"+ JSPFormater.formatDate(tglLahir2, "yyyy-MM-dd")+"')";
                            }
                     //  }
                        
                    }
                    
                    //kecamatan
                    if(oidKecamatan != 0){
                        if(where.length()>0){
                            where = where + " and "+DbMember.colNames[DbMember.COL_KECAMATAN_ID]+" = " + oidKecamatan;
                        }
                        else{
                            where = DbMember.colNames[DbMember.COL_KECAMATAN_ID]+" = " + oidKecamatan;
                        }
                    }
                    
                    //desa
                    if(oidDesa != 0){
                        if(where.length()>0){
                            where = where + " and "+DbMember.colNames[DbMember.COL_DESA_ID]+" = " + oidDesa;
                        }
                        else{
                            where = DbMember.colNames[DbMember.COL_DESA_ID]+" = " + oidDesa;
                        }
                    }
                    
                    //agama
                    if(agama.length()>0){
                        if(where.length()>0){
                            where = where + " and "+DbMember.colNames[DbMember.COL_AGAMA]+" like '%"+agama+"%'";
                        }
                        else{
                            where = DbMember.colNames[DbMember.COL_AGAMA]+" like '%"+agama+"%'";
                        }
                    }
                    
                    //jenis simpanan
                    String srcSimpanan = "";
                    if(s1!=0){
                            srcSimpanan = DbMember.colNames[DbMember.COL_SIBUHAR]+" = " + DbMember.STATUS_AKTIF;
                    }
                                        
                    if(s2!=0){
                        if(srcSimpanan.length()>0){
                            srcSimpanan = srcSimpanan + " or "+DbMember.colNames[DbMember.COL_SIMPLE]+" = " + DbMember.STATUS_AKTIF;
                        }
                        else{
                            srcSimpanan = DbMember.colNames[DbMember.COL_SIMPLE]+" = " + DbMember.STATUS_AKTIF;
                        }
                    }
                    
                    if(s3!=0){
                        if(srcSimpanan.length()>0){
                            srcSimpanan = srcSimpanan + " or "+DbMember.colNames[DbMember.COL_SIRAYA]+" = " + DbMember.STATUS_AKTIF;
                        }
                        else{
                            srcSimpanan = DbMember.colNames[DbMember.COL_SIRAYA]+" = " + DbMember.STATUS_AKTIF;
                        }
                    }
                    
                    if(s4!=0){
                        if(srcSimpanan.length()>0){
                            srcSimpanan = srcSimpanan + " or "+DbMember.colNames[DbMember.COL_SIMAPAN]+" = " + DbMember.STATUS_AKTIF;
                        }
                        else{
                            srcSimpanan = DbMember.colNames[DbMember.COL_SIMAPAN]+" = " + DbMember.STATUS_AKTIF;
                        }
                    }
                    
                    if(s5!=0){
                        if(srcSimpanan.length()>0){
                            srcSimpanan = srcSimpanan + " or "+DbMember.colNames[DbMember.COL_SIMP_RENCANA]+" = " + DbMember.STATUS_AKTIF;
                        }
                        else{
                            where = ""+DbMember.colNames[DbMember.COL_SIMP_RENCANA]+" = " + DbMember.STATUS_AKTIF;
                        }
                    }
                    
                    if(s6!=0){
                        if(srcSimpanan.length()>0){
                            srcSimpanan = srcSimpanan + " or "+DbMember.colNames[DbMember.COL_SISUKA]+" = " + DbMember.STATUS_AKTIF;
                        }
                        else{
                            srcSimpanan = DbMember.colNames[DbMember.COL_SISUKA]+" = " + DbMember.STATUS_AKTIF;
                        }
                    }
                     
                    
                    //Jenis Pinjaman
                    if(p1!=0){
                        if(srcSimpanan.length()>0){
                            srcSimpanan = srcSimpanan + " or "+DbMember.colNames[DbMember.COL_KUK]+" = " + DbMember.STATUS_AKTIF;
                        }
                        else{
                            srcSimpanan = DbMember.colNames[DbMember.COL_KUK]+" = " + DbMember.STATUS_AKTIF;
                        }     
                    }
                    
                    if(p2!=0){
                        if(srcSimpanan.length()>0){
                            srcSimpanan = srcSimpanan + " or "+DbMember.colNames[DbMember.COL_KMP]+" = " + DbMember.STATUS_AKTIF;
                        }
                        else{
                            srcSimpanan = DbMember.colNames[DbMember.COL_KMP]+" = " + DbMember.STATUS_AKTIF;
                        }
                    }
                    
                    if(p3!=0){
                        if(srcSimpanan.length()>0){
                            srcSimpanan = srcSimpanan + " or "+DbMember.colNames[DbMember.COL_KIP]+" = " + DbMember.STATUS_AKTIF;
                        }
                        else{
                            srcSimpanan = DbMember.colNames[DbMember.COL_KIP]+" = " + DbMember.STATUS_AKTIF;
                        }
                    }
                    
                    if(p4!=0){
                        if(srcSimpanan.length()>0){
                            srcSimpanan = srcSimpanan + " or "+DbMember.colNames[DbMember.COL_KTM]+" = " + DbMember.STATUS_AKTIF;
                        }
                        else{
                            srcSimpanan = DbMember.colNames[DbMember.COL_KTM]+" = " + DbMember.STATUS_AKTIF;
                        }
                    }
                    
                    if(p5!=0){
                        if(srcSimpanan.length()>0){
                            srcSimpanan = srcSimpanan + " or "+DbMember.colNames[DbMember.COL_KPP]+" = " + DbMember.STATUS_AKTIF;
                        }
                        else{
                            srcSimpanan = DbMember.colNames[DbMember.COL_KPP]+" = " + DbMember.STATUS_AKTIF;
                        }
                    }
                    
                    if(p6!=0){
                        if(srcSimpanan.length()>0){
                            srcSimpanan = srcSimpanan + " or "+DbMember.colNames[DbMember.COL_KIPER]+" = " + DbMember.STATUS_AKTIF;
                        }
                        else{
                            srcSimpanan = DbMember.colNames[DbMember.COL_KIPER]+" = " + DbMember.STATUS_AKTIF;
                        }
                    }
                    
                    if(p7!=0){
                        if(srcSimpanan.length()>0){
                            srcSimpanan = srcSimpanan + " or "+DbMember.colNames[DbMember.COL_KIPERUM]+" = " + DbMember.STATUS_AKTIF;
                        }
                        else{
                            srcSimpanan = DbMember.colNames[DbMember.COL_KIPERUM]+" = " + DbMember.STATUS_AKTIF;
                        }
                    }
                    
                    if(p8!=0){
                        if(srcSimpanan.length()>0){
                            srcSimpanan = srcSimpanan + " or "+DbMember.colNames[DbMember.COL_KHUSUS]+" = " + DbMember.STATUS_AKTIF;
                        }
                        else{
                            srcSimpanan = DbMember.colNames[DbMember.COL_KHUSUS]+" = " + DbMember.STATUS_AKTIF;
                        }
                    }
                    
                    if(dinasUnitId!=0){
                        if(srcSimpanan.length()>0){
                            srcSimpanan = srcSimpanan + " and ("+DbMember.colNames[DbMember.COL_DINAS_UNIT_ID]+" = " + dinasUnitId+")";
                        }
                        else{
                            srcSimpanan = "("+DbMember.colNames[DbMember.COL_DINAS_UNIT_ID]+" = " + dinasUnitId+")";
                        }
                    }
                    
                    if(dinasId!=0){
                        if(srcSimpanan.length()>0){
                            srcSimpanan = srcSimpanan + " and ("+DbMember.colNames[DbMember.COL_DINAS_ID]+" = " +dinasId+")";
                        }
                        else{
                            srcSimpanan = "("+DbMember.colNames[DbMember.COL_DINAS_ID]+" = " +dinasId+")";
                        }
                    }
                    //end pinjaman
                    
                    //gabung simpanan dan pinjaman
                    if(srcSimpanan.length()>0){
                        if(where.length()>0){
                            where = where + " and ("+srcSimpanan+")";
                        }
                        else{
                            where = srcSimpanan;
                        }
                    }

                    if(where.length()>0){
                        sql = sql + " where "+where;
                    }
                    
                    /*
                    switch(order){
                        case 0 :
                            sql = sql + " order by "+DbMember.colNames[DbMember.COL_NAMA];
                            break;
                        case 1 :
                            sql = sql + " order by "+DbMember.colNames[DbMember.COL_NO_ANGGOTA];
                            break;
                        case 2 :
                            sql = sql + " order by "+DbMember.colNames[DbMember.COL_ALAMAT];
                            break;
                    }
                     */

                    if(recordToGet>0){
                        sql = sql + " limit "+start+", "+recordToGet;
                    }


        System.out.println(sql);

        Vector result = new Vector();

        CONResultSet dbrs = null;
        try{

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while(rs.next()){
                Member a = new Member();
                DbMember.resultToObject(rs, a); 
                result.add(a); 
            }

        }
        catch(Exception e){
        }
        finally{
            CONResultSet.close(dbrs);
        }

        return result;
        
    }
    
   /*count customer*/
    public static int getCountMember(String noMember, String nama, String alamat, int jenisKelamin, long oidKecamatan, long oidDesa, String agama
                                    ,Date tglLahir1, Date tglLahir2 ,int s1, int s2, int s3, int s4, int s5, int s6 
                                    ,int p1, int p2, int p3, int p4, int p5, int p6, int p7, int p8, int batas, long oidPekerjaan, int status
                                    ,long dinasId, long dinasUnitId){
        
        String sql = " select count("+DbMember.colNames[DbMember.COL_MEMBER_ID]+") from "+DbMember.DB_MEMBER;
                    
        /*
                    if(judul.length()>0){
                        sql = sql + " inner join "+DbSirkulasi.TBL_DS_PERPUS_SIRKULASI+" s "+
                            " on "+DbMember.colNames[DbMember.COL_ANGGOTA_ID]+" = "+
                            " s."+DbSirkulasi.colNames[DbSirkulasi.COL_ANGGOTA_ID]+
                            " inner join "+DbMember.TBL_DS_PERPUS_KATALOG+" k "+
                            " on k."+DbMember.colNames[DbMember.COL_KATALOG_ID]+" = "+
                            " s."+DbSirkulasi.colNames[DbSirkulasi.COL_KATALOG_ID];
                    }
         */
                    
                    String where = "";
                    if(noMember.length()>0){
                        where = DbMember.colNames[DbMember.COL_NO_MEMBER]+" like '%"+noMember+"%'";
                    }

                    if(nama.length()>0){
                        if(where.length()>0){
                            where = where + " and "+DbMember.colNames[DbMember.COL_NAMA]+" like '%"+nama+"%'";
                        }
                        else{
                            where = DbMember.colNames[DbMember.COL_NAMA]+" like '%"+nama+"%'";
                        }
                    }

                    if(alamat.length()>0){
                        if(where.length()>0){
                            where = where + " and "+DbMember.colNames[DbMember.COL_ALAMAT]+" like '%"+alamat+"%'";
                        }
                        else{
                            where = DbMember.colNames[DbMember.COL_ALAMAT]+" like '%"+alamat+"%'";
                        }
                    }

                    if(jenisKelamin == 1){
                        if(where.length()>0){
                            where = where + " and "+DbMember.colNames[DbMember.COL_JENIS_KELAMIN]+" = " + DbMember.STATUS_AKTIF;
                        }
                        else{
                            where = DbMember.colNames[DbMember.COL_JENIS_KELAMIN]+" = " + DbMember.STATUS_AKTIF;
                        }
                    }else if(jenisKelamin == 0){
                        if(where.length()>0){
                            where = where + " and "+DbMember.colNames[DbMember.COL_JENIS_KELAMIN]+" = " + DbMember.STATUS_TIDAK_AKTIF;
                        }
                        else{
                            where = ""+DbMember.colNames[DbMember.COL_JENIS_KELAMIN]+" = " + DbMember.STATUS_TIDAK_AKTIF;
                        }
                    }else{
                        //just to show all item
                    }
                    
                    //pekerjaan
                    if(oidPekerjaan != 0){
                        if(where.length()>0){
                            where = where + " and "+DbMember.colNames[DbMember.COL_PEKERJAAN_ID]+" = " + oidPekerjaan;
                        }
                        else{
                            where = ""+DbMember.colNames[DbMember.COL_PEKERJAAN_ID]+" = " + oidPekerjaan;
                        }
                    }
                    
                    //status
                    if(status == 1){
                        if(where.length()>0){
                            where = where + " and "+DbMember.colNames[DbMember.COL_STATUS]+" = " + DbMember.STATUS_AKTIF;
                        }
                        else{
                            where = DbMember.colNames[DbMember.COL_STATUS]+" = " + DbMember.STATUS_AKTIF;
                        }
                    }
                    
                    if(status == 0){
                        if(where.length()>0){
                            where = where + " and "+DbMember.colNames[DbMember.COL_STATUS]+" = " + DbMember.STATUS_TIDAK_AKTIF;
                        }
                        else{
                            where = DbMember.colNames[DbMember.COL_STATUS]+" = " + DbMember.STATUS_TIDAK_AKTIF;
                        }
                    }
                    
                    //tanggal lahir
                    if(batas == 0){
                       // if(tglLahir1 != null && tglLahir2 != null){
                            if(where!=null && where.length()>0){
                                  where = where + " and ("+DbMember.colNames[DbMember.COL_TGL_LAHIR] +
                                  " between '" + JSPFormater.formatDate(tglLahir1, "yyyy-MM-dd")  + 
                                  "' and '"+ JSPFormater.formatDate(tglLahir2, "yyyy-MM-dd")+"')";
                            }
                            else{
                                  where = where + " ("+DbMember.colNames[DbMember.COL_TGL_LAHIR] +
                                  " between '" + JSPFormater.formatDate(tglLahir1, "yyyy-MM-dd")  + 
                                  "' and '"+ JSPFormater.formatDate(tglLahir2, "yyyy-MM-dd")+"')";
                            }
                     //  }
                        
                    }
                    
                    //kecamatan
                    if(oidKecamatan != 0){
                        if(where.length()>0){
                            where = where + " and "+DbMember.colNames[DbMember.COL_KECAMATAN_ID]+" = " + oidKecamatan;
                        }
                        else{
                            where = DbMember.colNames[DbMember.COL_KECAMATAN_ID]+" = " + oidKecamatan;
                        }
                    }
                    
                    //desa
                    if(oidDesa != 0){
                        if(where.length()>0){
                            where = where + " and "+DbMember.colNames[DbMember.COL_DESA_ID]+" = " + oidDesa;
                        }
                        else{
                            where = DbMember.colNames[DbMember.COL_DESA_ID]+" = " + oidDesa;
                        }
                    }
                    
                    //agama
                    if(agama.length()>0){
                        if(where.length()>0){
                            where = where + " and "+DbMember.colNames[DbMember.COL_AGAMA]+" like '%"+agama+"%'";
                        }
                        else{
                            where = DbMember.colNames[DbMember.COL_AGAMA]+" like '%"+agama+"%'";
                        }
                    }
                     
                    //jenis simpanan
                    String srcSimpanan = "";
                    if(s1!=0){
                            srcSimpanan = DbMember.colNames[DbMember.COL_SIBUHAR]+" = " + DbMember.STATUS_AKTIF;
                    }
                                        
                    if(s2!=0){
                        if(srcSimpanan.length()>0){
                            srcSimpanan = srcSimpanan + " or "+DbMember.colNames[DbMember.COL_SIMPLE]+" = " + DbMember.STATUS_AKTIF;
                        }
                        else{
                            srcSimpanan = DbMember.colNames[DbMember.COL_SIMPLE]+" = " + DbMember.STATUS_AKTIF;
                        }
                    }
                    
                    if(s3!=0){
                        if(srcSimpanan.length()>0){
                            srcSimpanan = srcSimpanan + " or "+DbMember.colNames[DbMember.COL_SIRAYA]+" = " + DbMember.STATUS_AKTIF;
                        }
                        else{
                            srcSimpanan = DbMember.colNames[DbMember.COL_SIRAYA]+" = " + DbMember.STATUS_AKTIF;
                        }
                    }
                    
                    if(s4!=0){
                        if(srcSimpanan.length()>0){
                            srcSimpanan = srcSimpanan + " or "+DbMember.colNames[DbMember.COL_SIMAPAN]+" = " + DbMember.STATUS_AKTIF;
                        }
                        else{
                            srcSimpanan = DbMember.colNames[DbMember.COL_SIMAPAN]+" = " + DbMember.STATUS_AKTIF;
                        }
                    }
                    
                    if(s5!=0){
                        if(srcSimpanan.length()>0){
                            srcSimpanan = srcSimpanan + " or "+DbMember.colNames[DbMember.COL_SIMP_RENCANA]+" = " + DbMember.STATUS_AKTIF;
                        }
                        else{
                            where = ""+DbMember.colNames[DbMember.COL_SIMP_RENCANA]+" = " + DbMember.STATUS_AKTIF;
                        }
                    }
                    
                    if(s6!=0){
                        if(srcSimpanan.length()>0){
                            srcSimpanan = srcSimpanan + " or "+DbMember.colNames[DbMember.COL_SISUKA]+" = " + DbMember.STATUS_AKTIF;
                        }
                        else{
                            srcSimpanan = DbMember.colNames[DbMember.COL_SISUKA]+" = " + DbMember.STATUS_AKTIF;
                        }
                    }
                     
                    
                    //Jenis Pinjaman
                    if(p1!=0){
                        if(srcSimpanan.length()>0){
                            srcSimpanan = srcSimpanan + " or "+DbMember.colNames[DbMember.COL_KUK]+" = " + DbMember.STATUS_AKTIF;
                        }
                        else{
                            srcSimpanan = DbMember.colNames[DbMember.COL_KUK]+" = " + DbMember.STATUS_AKTIF;
                        }     
                    }
                    
                    if(p2!=0){
                        if(srcSimpanan.length()>0){
                            srcSimpanan = srcSimpanan + " or "+DbMember.colNames[DbMember.COL_KMP]+" = " + DbMember.STATUS_AKTIF;
                        }
                        else{
                            srcSimpanan = DbMember.colNames[DbMember.COL_KMP]+" = " + DbMember.STATUS_AKTIF;
                        }
                    }
                    
                    if(p3!=0){
                        if(srcSimpanan.length()>0){
                            srcSimpanan = srcSimpanan + " or "+DbMember.colNames[DbMember.COL_KIP]+" = " + DbMember.STATUS_AKTIF;
                        }
                        else{
                            srcSimpanan = DbMember.colNames[DbMember.COL_KIP]+" = " + DbMember.STATUS_AKTIF;
                        }
                    }
                    
                    if(p4!=0){
                        if(srcSimpanan.length()>0){
                            srcSimpanan = srcSimpanan + " or "+DbMember.colNames[DbMember.COL_KTM]+" = " + DbMember.STATUS_AKTIF;
                        }
                        else{
                            srcSimpanan = DbMember.colNames[DbMember.COL_KTM]+" = " + DbMember.STATUS_AKTIF;
                        }
                    }
                    
                    if(p5!=0){
                        if(srcSimpanan.length()>0){
                            srcSimpanan = srcSimpanan + " or "+DbMember.colNames[DbMember.COL_KPP]+" = " + DbMember.STATUS_AKTIF;
                        }
                        else{
                            srcSimpanan = DbMember.colNames[DbMember.COL_KPP]+" = " + DbMember.STATUS_AKTIF;
                        }
                    }
                    
                    if(p6!=0){
                        if(srcSimpanan.length()>0){
                            srcSimpanan = srcSimpanan + " or "+DbMember.colNames[DbMember.COL_KIPER]+" = " + DbMember.STATUS_AKTIF;
                        }
                        else{
                            srcSimpanan = DbMember.colNames[DbMember.COL_KIPER]+" = " + DbMember.STATUS_AKTIF;
                        }
                    }
                    
                    if(p7!=0){
                        if(srcSimpanan.length()>0){
                            srcSimpanan = srcSimpanan + " or "+DbMember.colNames[DbMember.COL_KIPERUM]+" = " + DbMember.STATUS_AKTIF;
                        }
                        else{
                            srcSimpanan = DbMember.colNames[DbMember.COL_KIPERUM]+" = " + DbMember.STATUS_AKTIF;
                        }
                    }
                    
                    if(p8!=0){
                        if(srcSimpanan.length()>0){
                            srcSimpanan = srcSimpanan + " or "+DbMember.colNames[DbMember.COL_KHUSUS]+" = " + DbMember.STATUS_AKTIF;
                        }
                        else{
                            srcSimpanan = DbMember.colNames[DbMember.COL_KHUSUS]+" = " + DbMember.STATUS_AKTIF;
                        }
                    }
                    
                    if(dinasUnitId!=0){
                        if(srcSimpanan.length()>0){
                            srcSimpanan = srcSimpanan + " and ("+DbMember.colNames[DbMember.COL_DINAS_UNIT_ID]+" = " + dinasUnitId+")";
                        }
                        else{
                            srcSimpanan = "("+DbMember.colNames[DbMember.COL_DINAS_UNIT_ID]+" = " + dinasUnitId+")";
                        }
                    }
                    
                    if(dinasId!=0){
                        if(srcSimpanan.length()>0){
                            srcSimpanan = srcSimpanan + " and ("+DbMember.colNames[DbMember.COL_DINAS_ID]+" = " +dinasId+")";
                        }
                        else{
                            srcSimpanan = "("+DbMember.colNames[DbMember.COL_DINAS_ID]+" = " +dinasId+")";
                        }
                    }
                    
                    //end pinjaman
                    
                    //gabung simpanan dan pinjaman
                    if(srcSimpanan.length()>0){
                        if(where.length()>0){
                            where = where + " and ("+srcSimpanan+")";
                        }
                        else{
                            where = srcSimpanan;
                        }
                    }

                    if(where.length()>0){
                        sql = sql + " where "+where;
                    }


        System.out.println(sql);

        int result = 0;

        CONResultSet dbrs = null;
        try{

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while(rs.next()){
                result = rs.getInt(1);
            }

        }
        catch(Exception e){
        }
        finally{
            CONResultSet.close(dbrs);
        }

        return result;
        
    }
    
    
}
