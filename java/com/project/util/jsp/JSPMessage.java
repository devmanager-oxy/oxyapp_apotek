package com.project.util.jsp;

import java.util.*;

public class JSPMessage
{
    
    public static final int NONE                = 0;    
    
    
    // error form constanta
    public static final int ERR_NONE            = 0;
    public static final int ERR_UNKNOWN         = 1;
    public static final int ERR_REQUIRED        = 2;
    public static final int ERR_TYPE            = 3;
    public static final int ERR_FORMAT          = 4;    
    public static final int ERR_SAVED           = 5;
    public static final int ERR_UPDATED         = 6;
    public static final int ERR_DELETED         = 7;
    public static final int ERR_PWDSYNC         = 8;
    
    // message form constanta
    public static final int MSG_NONE            = 1000;
    public static final int MSG_SAVED           = 1001;
    public static final int MSG_UPDATED         = 1002;
    public static final int MSG_DELETED         = 1003;
    public static final int MSG_ASKDEL          = 1004;    
    public static final int MSG_INCOMPLATE      = 1005;
    public static final int MSG_IN_USED		= 1006;
    public static final int MSG_MORE_INVOICE	= 1007; //untuk transaksi pembayaran dimana pembayaran melebhi invoice nya
    public static final int MSG_DATA_EXIST      = 1008;
    public static final int MSG_PERIOD_EXIST    = 1009;
    
    

    public static String[] errString = {
        "",
        " Error tidak teridentifikasi", 
        " Data harus diisi",
        " Tipe data salah",        
        " Format data salah",
        "Data tidak bisa disimpan",
        "Data tidak bisa diupdate",
        "Data tidak bisa dihapus",
        "Password tidak valid"
    };
    

    public static String[] msgString = {
        "",
        "Data sudah tersimpan", 
        "Data sudah tersimpan",
        "Data sudah di hapus",
        "Anda yakin menghapus data ini ?",
        "Error, data belum lengkap",
        "Tidak boleh dihapus,<br>Data masih diperlukan dimodul lain",
        "Data tidak bisa disimpan,<br>Pembayaran melebihi total invoice",
        "Data sudah ada",
        "Tanggal periode ini sudah ada sebelumnya"
    };
    
    
    //supporting bilingual
    public static String[][] errStringMulty = {
        {
        	"",
	        " Error tidak teridentifikasi", 
	        " Data harus diisi",
	        " Tipe data salah",        
	        " Format data salah",
	        "Data tidak bisa disimpan",
	        "Data tidak bisa diupdate",
	        "Data tidak bisa dihapus",
	        "Password tidak valid"
	    },
        {
        	"",
	        " Unkown error", 
	        " Data required",
	        " Invalid data type",        
	        " Invalid data format",
	        "Data can not be saved",
	        "Data can not be updated",
	        "Data can not be deleted",
	        "Invalid password"
        }
    };
    
    
    public static String[][] msgStringMulty = {
        {
        	"",
	        "Data sudah tersimpan", 
	        "Data sudah tersimpan",
	        "Data sudah di hapus",
	        "Anda yakin menghapus data ini ?",
	        "Error, data belum lengkap",
	        "Tidak boleh dihapus,<br>Data masih diperlukan dimodul lain",
	        "Data tidak bisa disimpan,<br>Pembayaran melebihi total invoice",
	        "Data sudah ada",
	        "Tanggal periode ini sudah ada sebelumnya"
        },
        {
        	"",
	        "Data have been saved", 
	        "Data have been saved",
	        "data have been deleted",
	        "Are you sure you delete this data ?",
	        "Error, the data is incomplete",
	        "Data must not be deleted,<br>data is still needed in other modules",
	        "Data can not be stored,<br>payments exceed the total invoice",
	        "Data already exist",
	        "Date of this period of pre-existing"
        }
    };
    
    
    /**
     *  Get Error String.
     *  idx is range from 0..errString.length
     */
    public static String getErr(int idx)    
    {
        if(idx < 0 || idx >= errString.length) return "";
        return errString[idx];
    }
    
    public static String getErr(int lang, int idx)    
    {
        if(idx < 0 || idx >= errString.length) return "";
        return errStringMulty[lang][idx];
    }


    /**
     *  Get Message String.
     *  idx is 
     *  reange from 0..msgString.length 
     *  or
     *  reange from MSG_NONE..msgString.length + MSG_NONE
     *  so
     *  we can call it as getMsg(MSG_SAVED) or getMsg(1)
     *  both return the same value     
     */
    public static String getMsg(int idx)    
    {
        if(idx >= MSG_NONE) {
            if(idx >= msgString.length + MSG_NONE)
                return "";
            return msgString[idx - MSG_NONE];
        }else {
            if(idx < 0 || idx >= msgString.length) 
                return "";
            return msgString[idx];
        }                
    }
    
    public static String getMsg(int lang, int idx)    
    {
        if(idx >= MSG_NONE) {
            if(idx >= msgString.length + MSG_NONE)
                return "";
            return msgStringMulty[lang][idx - MSG_NONE];
        }else {
            if(idx < 0 || idx >= msgString.length) 
                return "";
            return msgStringMulty[lang][idx];
        }                
    }
    

    /**
     *  Get Message String or Error String.
     *  if idx is < MSG_NOTE it will return Error String from Error array
     *  if idx is >= MSG_NOTE it will return Message String from Message array     
     *
     *  Use this function to get kind of String that you never known before,
     *  whether it's Message String or Error String !
     */
    public static String getMessage(int idx)    
    {
        if(idx >= MSG_NONE) {
            if(idx >= msgString.length + MSG_NONE)
                return "";
            return msgString[idx - MSG_NONE];
        }else {
            if(idx < 0 || idx >= errString.length) 
                return "";
            return errString[idx];
        }        
    }
    
    public static String getMessage(int lang, int idx)    
    {
        if(idx >= MSG_NONE) {
            if(idx >= msgString.length + MSG_NONE)
                return "";
            return msgStringMulty[lang][idx - MSG_NONE];
        }else {
            if(idx < 0 || idx >= msgString.length) 
                return "";
            return msgStringMulty[lang][idx];
        }        
    }




} // end of FRMMessage
