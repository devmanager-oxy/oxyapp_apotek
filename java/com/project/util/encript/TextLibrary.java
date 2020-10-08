/*
 * TextLibrary.java
 *
 * Created on April 9, 2007, 8:36 PM
 */

package com.project.util.encript;

/**
 *
 * @author  TOSHIBA
 */
public abstract class TextLibrary {
    
    protected static String[] encript_1 = {
        "a", "b", "c", "d", "e", "f", "1", "2", "3", "4", "5", "6", "7", "%", "^", "&", "*", "(", ")"
    };
    
    protected static String[] encript_2 = {
        "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "A", "B", "C", "D", "E", "F", "G", "H"
    };
    
    protected static String[] TXT_1 = { 
        " ", "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z",
        "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z",
        "1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "-", "!", "@", "#", "$", "%", "^", "&", "*", "(", ")", ",", ".", "`", "~", "'", 
        "\"", "_", "+", "{", "}", "[", "]", ":", ";", "<", ">", "?", "/", "="      
    };
    
    
    protected static String[] TXT_2 = { 
        "T", "U", "V", "W", "X", "Y", "Z", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "-", "!", "@", "#", "$", "%", "^", "&", "*", " ", 
        "\"", "_", "+", "{", "}", "[", "]", ":", ";", "<", ">", "?", "/", "m", "(", ")", ",", ".", "`", "~", "'", "A", "B", "C", "D", "E", 
        "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "F", "G", "H", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z",       
        "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "=", "n"
    };
    
    protected static String[] TXT_3 = { 
        "[", " ", "]", "?", "/", "r", "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", ":", ";", "<", ">", "Q", "R", "S", "T", "U", 
        "1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "-", "!", "@", "#", "$", "%", "^", "&", "*", "(", ")", ",", ".", "`", "~", "'", 
        "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "V", "W", "X", "Y", "Z", "K", "L", "M", "N", "\"", "_", "+", "{", "}", "O", "P", 
        "m", "n", "o", "p", "q", "s", "t", "u", "v", "w", "x", "=", "y", "z"
    };
    
    public static String strNull = "null";
    
    public static boolean isType_1(String s){
        for(int i=0; i<encript_1.length; i++){
            if(s.equals(encript_1[i])){
                return true;
            }
        }
        return false;
    }
    
    public static boolean isType_2(String s){
        for(int i=0; i<encript_2.length; i++){
            if(s.equals(encript_2[i])){
                return true;
            }
        }
        return false;
    }
    
}
