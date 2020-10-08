package com.project.util;

import java.math.BigInteger;
import java.security.MessageDigest;

/**
 *
 * @author gwawan
 */
public class MD5 {
    public MD5() {}
    
    public static String getMD5Hash(String sInput) {
        String md5Hash = null;
        try {
            if(sInput == null) return null;
            
            //Create MessageDigest object for MD5
            MessageDigest digest = MessageDigest.getInstance("MD5");

            //Update input string in message digest
            digest.update(sInput.getBytes(), 0, sInput.length());

            //Converts message digest value in base 16 (hex) 
            md5Hash = new BigInteger(1, digest.digest()).toString(16);

        } catch(Exception e) {
            System.out.println(e.toString());
        }
        
        return md5Hash;
    }

}
