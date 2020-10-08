package com.project.general;

import java.util.*;
import com.project.main.entity.*;

/**
 *
 * @author Roy Andika
 */
public class Customer extends Entity {

    private int type = 0;                               //1
    private String name = "";                           //2
    private String address1 = "";                       //3
    private String address2 = "";                       //4
    private String city = "";                           //5
    private long countryId = 0;                         //6
    private long indukCustomerId = 0;                   //7
    private String postalCode = "";                     //8
    private String contactPerson = "";                  //9
    private String posisiContactPerson = "";            //10    
    private String countryCode = "";                    //11
    private String areaCode = "";                       //12
    private String phone = "";                          //13
    private String website = "";                        //14
    private String email = "";                          //15
    private String status = "";                         //16
    private String fax = "";                                 //17
    private int defDueDateDay = 1;                      //18
        
    //add retail
    private long nationalityId = 0;             //19
    private String state = "";              //20
    private String countryName = "";        //21
    private String nationalityName = "";    //22
    private String hotelNote = "";          //23
    private String idType = "";             //24
    private String idNumber = "";           //25
    private String occupation = "";         //26
    private Date dob = new Date();          //27
    private String interest = "";           //28
    private String salutation = "";         //29
    private int dobIgnore = 1;              //30
    private String code = "";               //31
    private String phoneArea = "";          //32
    private String faxArea = "";            //33    
    private String lastName = "";           //34    
    private String contactMiddleName = "";  //35
    private String contactLastName = "";    //36
    private String middleName = "";         //37
    private String hp = "";                 //38
    private String zipCode = "";            //39
    private String contactPhoneArea = "";   //40
    private String contactPhone = "";       //41
    private String contactEmail = "";       //42
    private String contactPosition = "";    //43
    private long companyId = 0;             //44
    private String golPrice = "";          //45
    private double personalDiscount = 0;   //46
    private Date expiredDate = new Date(); //47
    private String animalName = "";        //48
    private double creditLimit = 0;        //49
    private Date regDate = new Date();      //50
    private String npwp = "";      //51
    
    private long propinsiId = 0;
    private long kabupatenId = 0;
    private long kecamatanId = 0;
    private int isPkp = 0;
    private String pkpCompany = "";
    private String pkpAddress = "";
    private String pkpNppkp = "";
    private int schSenin = 0;
    private int schSelasa = 0;
    private int schRabu = 0;
    private int schKamis = 0;
    private int schJumat = 0;
    private int schSabtu = 0;
    private int schMinggu = 0;
    private int ignoreLocCreditLimit = 0;
    private int dueDate = 0;
    private int maxPendingOrder = 0;
    private int jatuhTempo = 0;
    
    public int getMaxPendingOrder() {
        return maxPendingOrder;
    }

    public void setMaxPendingOrder(int maxPendingOrder) {
        this.maxPendingOrder = maxPendingOrder;
    }
    
    public int getDueDate() {
        return dueDate;
    }

    public void setDueDate(int dueDate) {
        this.dueDate = dueDate;
    }
    
    public int getIgnoreLocCreditLimit() {
        return ignoreLocCreditLimit;
    }

    public void setIgnoreLocCreditLimit(int ignoreLocCreditLimit) {
        this.ignoreLocCreditLimit = ignoreLocCreditLimit;
    }
    
    public int getSchMinggu() {
        return schMinggu;
    }

    public void setSchMinggu(int schMinggu) {
        this.schMinggu = schMinggu;
    }
    
    public int getSchSabtu() {
        return schSabtu;
    }

    public void setSchSabtu(int schSabtu) {
        this.schSabtu = schSabtu;
    }
    
    public int getSchRabu() {
        return schRabu;
    }

    public void setSchRabu(int schRabu) {
        this.schRabu = schRabu;
    }
    
    public int getSchJumat() {
        return schJumat;
    }

    public void setSchJumat(int schJumat) {
        this.schJumat = schJumat;
    }
    
    public String getPkpNppkp() {
        return pkpNppkp;
    }

    public void setPkpNppkp(String pkpNppkp) {
        this.pkpNppkp = pkpNppkp;
    }
    
    public int getSchKamis() {
        return schKamis;
    }

    public void setSchKamis(int schKamis) {
        this.schKamis = schKamis;
    }
    
    public int getSchSelasa() {
        return schSelasa;
    }

    public void setSchSelasa(int schSelasa) {
        this.schSelasa = schSelasa;
    }
    
    public int getSchSenin() {
        return schSenin;
    }

    public void setSchSenin(int schSenin) {
        this.schSenin = schSenin;
    }
    
    public String getPkpAddress() {
        return pkpAddress;
    }

    public void setPkpAddress(String pkpAddress) {
        this.pkpAddress = pkpAddress;
    }
    
    public String getPkpCompany() {
        return pkpCompany;
    }

    public void setPkpCompany(String pkpCompany) {
        this.pkpCompany = pkpCompany;
    }
    
    public int getIsPkp() {
        return isPkp;
    }

    public void setIsPkp(int isPkp) {
        this.isPkp = isPkp;
    }
    
    public long getKabupatenId() {
        return kabupatenId;
    }

    public void setKabupatenId(long kabupatenId) {
        this.kabupatenId = kabupatenId;
    }
    
    public long getKecamatanId() {
        return kecamatanId;
    }

    public void setKecamatanId(long kecamatanId) {
        this.kecamatanId = kecamatanId;
    }
    
    public long getPropinsiId() {
        return propinsiId;
    }

    public void setPropinsiId(long propinsiId) {
        this.propinsiId = propinsiId;
    }
    
    public String getAddress1() {
        return address1;
    }

    public void setAddress1(String address1) {
        this.address1 = address1;
    }

    public String getAddress2() {
        return address2;
    }

    public void setAddress2(String address2) {
        this.address2 = address2;
    }

    public String getAreaCode() {
        return areaCode;
    }

    public void setAreaCode(String areaCode) {
        this.areaCode = areaCode;
    }

       

    public String getCity() {
        return city;
    }

    public void setCity(String city) {
        this.city = city;
    }

    public String getContactPerson() {
        return contactPerson;
    }

    public void setContactPerson(String contactPerson) {
        this.contactPerson = contactPerson;
    }

    public String getCountryCode() {
        return countryCode;
    }

    public void setCountryCode(String countryCode) {
        this.countryCode = countryCode;
    }

    public long getCountryId() {
        return countryId;
    }

    public void setCountryId(long countryId) {
        this.countryId = countryId;
    }

    public int getDefDueDateDay() {
        return defDueDateDay;
    }

    public void setDefDueDateDay(int defDueDateDay) {
        this.defDueDateDay = defDueDateDay;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getFax() {
        return fax;
    }

    public void setFax(String fax) {
        this.fax = fax;
    }

    public long getIndukCustomerId() {
        return indukCustomerId;
    }

    public void setIndukCustomerId(long indukCustomerId) {
        this.indukCustomerId = indukCustomerId;
    }

    
   
    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getPosisiContactPerson() {
        return posisiContactPerson;
    }

    public void setPosisiContactPerson(String posisiContactPerson) {
        this.posisiContactPerson = posisiContactPerson;
    }

    public String getPostalCode() {
        return postalCode;
    }

    public void setPostalCode(String postalCode) {
        this.postalCode = postalCode;
    }

    public int getType() {
        return type;
    }

    public void setType(int type) {
        this.type = type;
    }

    public String getWebsite() {
        return website;
    }

    public void setWebsite(String website) {
        this.website = website;
    }

    

    public long getNationalityId() {
        return nationalityId;
    }

    public void setNationalityId(long nationalityId) {
        this.nationalityId = nationalityId;
    }

    public String getState() {
        return state;
    }

    public void setState(String state) {
        this.state = state;
    }

    public String getCountryName() {
        return countryName;
    }

    public void setCountryName(String countryName) {
        this.countryName = countryName;
    }

    public String getNationalityName() {
        return nationalityName;
    }

    public void setNationalityName(String nationalityName) {
        this.nationalityName = nationalityName;
    }

    public String getHotelNote() {
        return hotelNote;
    }

    public void setHotelNote(String hotelNote) {
        this.hotelNote = hotelNote;
    }

    public String getIdType() {
        return idType;
    }

    public void setIdType(String idType) {
        this.idType = idType;
    }

    public String getIdNumber() {
        return idNumber;
    }

    public void setIdNumber(String idNumber) {
        this.idNumber = idNumber;
    }

    public String getOccupation() {
        return occupation;
    }

    public void setOccupation(String occupation) {
        this.occupation = occupation;
    }

    public Date getDob() {
        return dob;
    }

    public void setDob(Date dob) {
        this.dob = dob;
    }

    public String getInterest() {
        return interest;
    }

    public void setInterest(String interest) {
        this.interest = interest;
    }

    public String getSalutation() {
        return salutation;
    }

    public void setSalutation(String salutation) {
        this.salutation = salutation;
    }

    public int getDobIgnore() {
        return dobIgnore;
    }

    public void setDobIgnore(int dobIgnore) {
        this.dobIgnore = dobIgnore;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getPhoneArea() {
        return phoneArea;
    }

    public void setPhoneArea(String phoneArea) {
        this.phoneArea = phoneArea;
    }

    public String getFaxArea() {
        return faxArea;
    }

    public void setFaxArea(String faxArea) {
        this.faxArea = faxArea;
    }

    public String getLastName() {
        return lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    public String getContactMiddleName() {
        return contactMiddleName;
    }

    public void setContactMiddleName(String contactMiddleName) {
        this.contactMiddleName = contactMiddleName;
    }

    public String getContactLastName() {
        return contactLastName;
    }

    public void setContactLastName(String contactLastName) {        
        this.contactLastName = contactLastName;
    }

    public String getMiddleName() {
        return middleName;
    }

    public void setMiddleName(String middleName) {
        this.middleName = middleName;
    }

    public String getHp() {
        return hp;
    }

    public void setHp(String hp) {
        this.hp = hp;
    }

    public String getZipCode() {
        return zipCode;
    }

    public void setZipCode(String zipCode) {
        this.zipCode = zipCode;
    }

    public String getContactPhoneArea() {
        return contactPhoneArea;
    }

    public void setContactPhoneArea(String contactPhoneArea) {
        this.contactPhoneArea = contactPhoneArea;
    }

    public String getContactPhone() {
        return contactPhone;
    }

    public void setContactPhone(String contactPhone) {
        this.contactPhone = contactPhone;
    }

    public String getContactEmail() {
        return contactEmail;
    }

    public void setContactEmail(String contactEmail) {
        this.contactEmail = contactEmail;
    }

    public String getContactPosition() {
        return contactPosition;
    }

    public void setContactPosition(String contactPosition) {
        this.contactPosition = contactPosition;
    }

    public long getCompanyId() {
        return companyId;
    }

    public void setCompanyId(long companyId) {
        this.companyId = companyId;
    }

    public String getAnimalName() {
        return animalName;
    }

    public void setAnimalName(String animalName) {
        this.animalName = animalName;
    }

    public double getCreditLimit() {
        return creditLimit;
    }

    public void setCreditLimit(double creditLimit) {
        this.creditLimit = creditLimit;
    }

    public Date getExpiredDate() {
        return expiredDate;
    }

    public void setExpiredDate(Date expiredDate) {
        this.expiredDate = expiredDate;
    }

    public String getGolPrice() {
        return golPrice;
    }

    public void setGolPrice(String golPrice) {
        this.golPrice = golPrice;
    }

    public double getPersonalDiscount() {
        return personalDiscount;
    }

    public void setPersonalDiscount(double personalDiscount) {
        this.personalDiscount = personalDiscount;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Date getRegDate() {
        return regDate;
    }

    public void setRegDate(Date regDate) {
        this.regDate = regDate;
    }

    public String getNpwp() {
        return npwp;
    }

    public void setNpwp(String npwp) {
        this.npwp = npwp;
    }

    public int getJatuhTempo() {
        return jatuhTempo;
    }

    public void setJatuhTempo(int jatuhTempo) {
        this.jatuhTempo = jatuhTempo;
    }
}
