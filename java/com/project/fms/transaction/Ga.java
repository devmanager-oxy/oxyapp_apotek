/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.fms.transaction;

import java.util.Date;
import com.project.main.entity.*;
/**
 *
 * @author Roy
 */
public class Ga extends Entity {

    private Date date;
    private int counter;
    private String journalNumber = "";
    private String note = "";
    private long approval1 = 0;
    private long approval2 = 0;
    private long approval3 = 0;
    private String status = "";
    private long locationId = 0;
    private long userId = 0;
    private String prefixNumber = "";    
    private int postedStatus = 0;
    private long postedById = 0;
    private Date postedDate;
    private Date effectiveDate;
    private long locationPostId = 0;
    
    
}
