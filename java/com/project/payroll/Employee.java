package com.project.payroll;

import java.util.Date;
import com.project.main.entity.*;

public class Employee extends Entity {

    private long departmentId;
    private long sectionId;
    private String name = "";
    private String address = "";
    private String city = "";
    private String state = "";
    private String countryName = "";
    private String empNum = "";
    private String phone = "";
    private String hp = "";
    private String maritalStatus = "";
    private Date dob;
    private Date commencingDate;
    private String jamsostek = "";
    private String empStatus = "";
    private String idNumber = "";
    private String idType = "";
    private String jamsostekId = "";
    private long countryId;
    private long nationalityId;
    private String nationalityName = "";
    /**
     * Holds value of property empType.
     */
    private String empType = "";
    /**
     * Holds value of property resignDate.
     */
    private Date resignDate = new Date();
    /**
     * Holds value of property resignReason.
     */
    private String resignReason = "";
    /**
     * Holds value of property resignNote.
     */
    private String resignNote = "";
    /**
     * Holds value of property contractEnd.
     */
    private Date contractEnd = new Date();
    /**
     * Holds value of property ignoreBirth.
     */
    private int ignoreBirth = 0;
    /**
     * Holds value of property locationId.
     */
    private long locationId;
    private String position = "";
    private int canTakeAdvance;
    private int isSales;

    public String getPosition() {
        return position;
    }

    public void setPosition(String position) {
        this.position = position;
    }

    public long getDepartmentId() {
        return departmentId;
    }

    public void setDepartmentId(long departmentId) {
        this.departmentId = departmentId;
    }

    public long getSectionId() {
        return sectionId;
    }

    public void setSectionId(long sectionId) {
        this.sectionId = sectionId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        if (name == null) {
            name = "";
        }
        this.name = name;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        if (address == null) {
            address = "";
        }
        this.address = address;
    }

    public String getCity() {
        return city;
    }

    public void setCity(String city) {
        if (city == null) {
            city = "";
        }
        this.city = city;
    }

    public String getState() {
        return state;
    }

    public void setState(String state) {
        if (state == null) {
            state = "";
        }
        this.state = state;
    }

    public String getCountryName() {
        return countryName;
    }

    public void setCountryName(String countryName) {
        if (countryName == null) {
            countryName = "";
        }
        this.countryName = countryName;
    }

    public String getEmpNum() {
        return empNum;
    }

    public void setEmpNum(String empNum) {
        if (empNum == null) {
            empNum = "";
        }
        this.empNum = empNum;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        if (phone == null) {
            phone = "";
        }
        this.phone = phone;
    }

    public String getHp() {
        return hp;
    }

    public void setHp(String hp) {
        if (hp == null) {
            hp = "";
        }
        this.hp = hp;
    }

    public String getMaritalStatus() {
        return maritalStatus;
    }

    public void setMaritalStatus(String maritalStatus) {
        if (maritalStatus == null) {
            maritalStatus = "";
        }
        this.maritalStatus = maritalStatus;
    }

    public Date getDob() {
        return dob;
    }

    public void setDob(Date dob) {
        this.dob = dob;
    }

    public Date getCommencingDate() {
        return commencingDate;
    }

    public void setCommencingDate(Date commencingDate) {
        this.commencingDate = commencingDate;
    }

    public String getJamsostek() {
        return jamsostek;
    }

    public void setJamsostek(String jamsostek) {
        if (jamsostek == null) {
            jamsostek = "";
        }
        this.jamsostek = jamsostek;
    }

    public String getEmpStatus() {
        return empStatus;
    }

    public void setEmpStatus(String empStatus) {
        if (empStatus == null) {
            empStatus = "";
        }
        this.empStatus = empStatus;
    }

    public String getIdNumber() {
        return idNumber;
    }

    public void setIdNumber(String idNumber) {
        if (idNumber == null) {
            idNumber = "";
        }
        this.idNumber = idNumber;
    }

    public String getIdType() {
        return idType;
    }

    public void setIdType(String idType) {
        if (idType == null) {
            idType = "";
        }
        this.idType = idType;
    }

    public String getJamsostekId() {
        return jamsostekId;
    }

    public void setJamsostekId(String jamsostekId) {
        if (jamsostekId == null) {
            jamsostekId = "";
        }
        this.jamsostekId = jamsostekId;
    }

    public long getCountryId() {
        return countryId;
    }

    public void setCountryId(long countryId) {
        this.countryId = countryId;
    }

    public long getNationalityId() {
        return nationalityId;
    }

    public void setNationalityId(long nationalityId) {
        this.nationalityId = nationalityId;
    }

    public String getNationalityName() {
        return nationalityName;
    }

    public void setNationalityName(String nationalityName) {
        if (nationalityName == null) {
            nationalityName = "";
        }
        this.nationalityName = nationalityName;
    }

    /**
     * Getter for property empType.
     * @return Value of property empType.
     */
    public String getEmpType() {
        return this.empType;
    }

    /**
     * Setter for property empType.
     * @param empType New value of property empType.
     */
    public void setEmpType(String empType) {
        this.empType = empType;
    }

    /**
     * Getter for property resignDate.
     * @return Value of property resignDate.
     */
    public Date getResignDate() {
        return this.resignDate;
    }

    /**
     * Setter for property resignDate.
     * @param resignDate New value of property resignDate.
     */
    public void setResignDate(Date resignDate) {
        this.resignDate = resignDate;
    }

    /**
     * Getter for property resignReason.
     * @return Value of property resignReason.
     */
    public String getResignReason() {
        return this.resignReason;
    }

    /**
     * Setter for property resignReason.
     * @param resignReason New value of property resignReason.
     */
    public void setResignReason(String resignReason) {
        this.resignReason = resignReason;
    }

    /**
     * Getter for property resignNote.
     * @return Value of property resignNote.
     */
    public String getResignNote() {
        return this.resignNote;
    }

    /**
     * Setter for property resignNote.
     * @param resignNote New value of property resignNote.
     */
    public void setResignNote(String resignNote) {
        this.resignNote = resignNote;
    }

    /**
     * Getter for property contractEnd.
     * @return Value of property contractEnd.
     */
    public Date getContractEnd() {
        return this.contractEnd;
    }

    /**
     * Setter for property contractEnd.
     * @param contractEnd New value of property contractEnd.
     */
    public void setContractEnd(Date contractEnd) {
        this.contractEnd = contractEnd;
    }

    /**
     * Getter for property ignoreBirth.
     * @return Value of property ignoreBirth.
     */
    public int getIgnoreBirth() {
        return this.ignoreBirth;
    }

    /**
     * Setter for property ignoreBirth.
     * @param ignoreBirth New value of property ignoreBirth.
     */
    public void setIgnoreBirth(int ignoreBirth) {
        this.ignoreBirth = ignoreBirth;
    }

    /**
     * Getter for property locationId.
     * @return Value of property locationId.
     */
    public long getLocationId() {
        return this.locationId;
    }

    /**
     * Setter for property locationId.
     * @param locationId New value of property locationId.
     */
    public void setLocationId(long locationId) {
        this.locationId = locationId;
    }

    public int getCanTakeAdvance() {
        return canTakeAdvance;
    }

    public void setCanTakeAdvance(int canTakeAdvance) {
        this.canTakeAdvance = canTakeAdvance;
    }

    public int getIsSales() {
        return isSales;
    }

    public void setIsSales(int isSales) {
        this.isSales = isSales;
    }
}
