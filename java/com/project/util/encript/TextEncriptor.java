/*
 * TextEncriptor.java
 *
 * Created on April 9, 2007, 8:35 PM
 */

package com.project.util.encript;

/**
 *
 * @author  TOSHIBA
 */
public class TextEncriptor extends TextLibrary {
    
    public static String getEncriptType(){
        try{
            Thread.sleep(100);

            if((System.currentTimeMillis()%2)==0){
                return encript_1[Integer.parseInt(""+(System.currentTimeMillis()%19))];
            }
            else{
                return encript_2[Integer.parseInt(""+(System.currentTimeMillis()%19))];
            }
        }
        catch(Exception e){
            
        }
        
        return "a";
    }
    
    private static String encriptType_1(String s){
        for(int i=0; i<TXT_1.length; i++){
            if(s.equals(TXT_1[i])){
                return TXT_2[i];
            }
        }
        return "?";
    }
    
    private static String encriptType_2(String s){
        for(int i=0; i<TXT_1.length; i++){
            if(s.equals(TXT_1[i])){
                return TXT_3[i];
            }
        }
        return "?";
    }
    
    public static String encriptText(String exT, String str){
        String encripted = "";
        if(isType_1(exT)){
            for(int i=0; i< str.length(); i++){
                encripted = encripted + encriptType_1(""+(str.charAt(i)));
            }
        }
        else if(isType_2(exT)){
            for(int i=0; i< str.length(); i++){
                encripted = encripted + encriptType_2(""+(str.charAt(i)));
            }
        }
        return encripted;
    }
    
    public static void main(String[] arg){
        try{
        //String str = "aku anak indonesia suka menabung dan memberi makan ikan";
        String str="anak";
        System.out.println("str : "+str);
        //TextEncriptor tx = new TextEncriptor();
        String s = getEncriptType();
        System.out.println("encriptText 1 : type : "+s+", "+TextEncriptor.encriptText(s, str));
        Thread.sleep(1200);
        s = getEncriptType();
        System.out.println("encriptText 1 : type : "+s+", "+TextEncriptor.encriptText(s, str));
        }
        catch(Exception e){
            
        }
    }
    
}
