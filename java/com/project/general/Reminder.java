/*
 * Reminder.java
 *
 * Created on October 19, 2008, 4:33 PM
 */

package com.project.general;

import java.util.*;

/**
 *
 * @author  Valued Customer
 */
public class Reminder {
    
    /**
     * Holds value of property date.
     */
    private Date date;
    
    /**
     * Holds value of property when.
     */
    private Date when;
    
    /**
     * Holds value of property message.
     */
    private String message;
    
    /**
     * Holds value of property url.
     */
    private String url;
    
    /**
     * Holds value of property status.
     */
    private String status;
    
    /**
     * Holds value of property type.
     */
    private int type;
    
    /** Creates a new instance of Reminder */
    public Reminder() {
    }
    
    /**
     * Getter for property date.
     * @return Value of property date.
     */
    public Date getDate() {
        return this.date;
    }
    
    /**
     * Setter for property date.
     * @param date New value of property date.
     */
    public void setDate(Date date) {
        this.date = date;
    }
    
    /**
     * Getter for property when.
     * @return Value of property when.
     */
    public Date getWhen() {
        return this.when;
    }
    
    /**
     * Setter for property when.
     * @param when New value of property when.
     */
    public void setWhen(Date when) {
        this.when = when;
    }
    
    /**
     * Getter for property message.
     * @return Value of property message.
     */
    public String getMessage() {
        return this.message;
    }
    
    /**
     * Setter for property message.
     * @param message New value of property message.
     */
    public void setMessage(String message) {
        this.message = message;
    }
    
    /**
     * Getter for property url.
     * @return Value of property url.
     */
    public String getUrl() {
        return this.url;
    }
    
    /**
     * Setter for property url.
     * @param url New value of property url.
     */
    public void setUrl(String url) {
        this.url = url;
    }
    
    /**
     * Getter for property status.
     * @return Value of property status.
     */
    public String getStatus() {
        return this.status;
    }
    
    /**
     * Setter for property status.
     * @param status New value of property status.
     */
    public void setStatus(String status) {
        this.status = status;
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
    
    
    public static Vector sortReminderByDate(Vector reminders){
        
        //System.out.println("\n\nin sortingng -- : "+reminders);
        
        Vector result = new Vector();
        
        while(reminders!=null && reminders.size()>0){
            //System.out.println("in while ---");    
            try{
                Reminder r = (Reminder)reminders.get(0);
                if(result==null || result.size()==0){
                    result.add(r);
                    reminders.remove(0);
                }
                else{
                    boolean found = false;
                    for(int i=0; i<result.size(); i++){
                        
                        //System.out.println("in for ---"); 
                        
                        Reminder rx = (Reminder)result.get(i);
                        if(r.getWhen().before(rx.getWhen())){
                            result.add(i,r);
                            found = true;
                            break;
                        }                    
                    }

                    if(!found){
                        result.add(r);
                    }

                    reminders.remove(0);
                }
            }
            catch(Exception e){
                System.out.println(e.toString());
            }
            
            //System.out.println("\n-------------\nin sortingng -- : "+reminders);
            //System.out.println("\nin result -- : "+result+"\n---------------");
            
        }
        
        //System.out.println("\nposting end result ----- result : "+result);
        
        return result;
    }
    
}
