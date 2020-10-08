

package com.project.admin;



import java.util.*;
import com.project.main.entity.*;

public class Priv extends Entity {
 private String PrivName="";
 private Date RegDate=new Date();
 private String Descr=""; 
 
 /** Creates new AppPriv */
 public Priv() {
     super();
 }

 public void setPrivName(String newName){
     this.PrivName = newName;
 }
 
 public String getPrivName(){
     return (this.PrivName==null) ? "" : this.PrivName;
 }

 public void setDescr(String newDescr){
     this.Descr = newDescr;
 }
 
 public String getDescr(){
     return (this.Descr==null) ? "" : this.Descr;
 }
 
 public void setRegDate(Date newDate){
     this.RegDate=newDate;
 }
 
 public Date getRegDate(){
     return (this.RegDate==null) ? new Date() : this.RegDate;
 }
 
 
}

