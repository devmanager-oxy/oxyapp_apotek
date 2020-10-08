/*
 * TextDecriptor.java
 *
 * Created on April 9, 2007, 8:36 PM
 */

package com.project.util.encript;

/**
 *
 * @author  TOSHIBA
 */
public class TextDecriptor extends TextLibrary { 
    
    
    private static String decriptType_1(String s){ 
        for(int i=0; i<TXT_2.length; i++){ 
            if(s.equals(TXT_2[i])){ 
                return TXT_1[i]; 
            }
        }
        return "?";
    }
    
    private static String decriptType_2(String s){
        for(int i=0; i<TXT_3.length; i++){
            if(s.equals(TXT_3[i])){
                return TXT_1[i];
            }
        }
        return "?";
    }
    
    public static String decriptText(String exT, String str){
        String encripted = "";
        if(isType_1(exT)){
            for(int i=0; i< str.length(); i++){
                encripted = encripted + decriptType_1(""+(str.charAt(i)));
            }
        }
        else if(isType_2(exT)){
            for(int i=0; i< str.length(); i++){
                encripted = encripted + decriptType_2(""+(str.charAt(i)));
            }
        }
        return encripted;
    }
    
    public static void main(String[] arg){
        String str = "aku anak indonesia";
        System.out.println("str : "+str);
        //TextDecriptor tx = new TextEncriptor();
        System.out.println("decriptText 1 : "+TextDecriptor.decriptText("a", "[f> [i[f di/ji|;d[ ;>f[ h|i[]>ib /[i h|h]|:d h[f[i df[i"));
        System.out.println("decriptText 2 : "+TextDecriptor.decriptText("A", "[f> [i[f di/ji|;d[ ;>f[ h|i[]>ib /[i h|h]|:d h[f[i df[i"));
        try{
            System.out.println("19 - "+System.currentTimeMillis());
            System.out.println(""+(System.currentTimeMillis()%19));
            Thread.sleep(1200);
            System.out.println("19 - "+System.currentTimeMillis());
            System.out.println(""+(System.currentTimeMillis()%19));
            Thread.sleep(1200);
            System.out.println("19 - "+System.currentTimeMillis());
            System.out.println(""+(System.currentTimeMillis()%19));
            Thread.sleep(1200);
            System.out.println("19 - "+System.currentTimeMillis());
            System.out.println(""+(System.currentTimeMillis()%19));
            
            System.out.println("2 - "+System.currentTimeMillis());
            System.out.println(""+(System.currentTimeMillis()%2));
            Thread.sleep(1200);
            System.out.println("2 - "+System.currentTimeMillis());
            System.out.println(""+(System.currentTimeMillis()%2));
            Thread.sleep(1200);
            System.out.println("2 - "+System.currentTimeMillis());
            System.out.println(""+(System.currentTimeMillis()%2));
            Thread.sleep(1200);
            System.out.println("2 - "+System.currentTimeMillis());
            System.out.println(""+(System.currentTimeMillis()%2));
        }
        catch(Exception e){
            
        }
        
    }
    
}
