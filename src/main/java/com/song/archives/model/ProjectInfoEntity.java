package com.song.archives.model;

import javax.persistence.*;
import java.io.Serializable;
import java.sql.Timestamp;

/**
 * Created by ghl on 2018/2/26.
 */
@Entity
@Table(name = "project_info", schema = "", catalog = "")
public class ProjectInfoEntity implements Serializable{
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String proNo;
    private String proName;
    private String proFrom;
    private String mainDepartment;
    private String proLeaders;
    private String proJoiners;
    private String proCompleteors;
    private String totalFee;
    private Integer proPhase;
    private String createPhasetime;
    private String openPhasetime;
    private String midcheckPhasetime;
    private String closePhasetime;
    private String endPhasetime;
    private Double receivedFee;
    private Double noreceivedFee;
    private Integer isreportReward;
    private Integer reportChannel;
    private String createphaseLxyjfid;
    private String createphaseJysfid;
    private String createphaseRwsfid;
    private String createphaseOtherfid;
    private String openphaseRwsfid;
    private String openphaseKtbgfid;
    private String openphaseOtherfid;
    private String midphaseYjbgfid;
    private String midphaseOtherfid;
    private String closephaseYjbgfid;
    private String closephaseOtherfid;
    private String closephaseGcfid;
    private String endphaseJdzsfid;
    private String endphaseSbsfid;
    private String endphasePsjg;
    private String proResearchcontent;
    private String proRemark;
    private Integer classificlevelId;
    private Timestamp createTime;
    private Integer cpAlertdays;
    private Integer opAlertdays;
    private Integer mpAlertdays;
    private Integer closepAlertdays;
    private Integer epAlertdays;

    private Integer creater;

    private Double yanjiuZhouQi;
    private String yanjiuFangXiang;


    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    @Basic
    @Column(name = "pro_no")
    public String getProNo() {
        return proNo;
    }

    public void setProNo(String proNo) {
        this.proNo = proNo;
    }

    @Basic
    @Column(name = "pro_name")
    public String getProName() {
        return proName;
    }

    public void setProName(String proName) {
        this.proName = proName;
    }

    @Basic
    @Column(name = "pro_from")
    public String getProFrom() {
        return proFrom;
    }

    public void setProFrom(String proFrom) {
        this.proFrom = proFrom;
    }

    @Basic
    @Column(name = "main_department")
    public String getMainDepartment() {
        return mainDepartment;
    }

    public void setMainDepartment(String mainDepartment) {
        this.mainDepartment = mainDepartment;
    }

    @Basic
    @Column(name = "pro_leaders")
    public String getProLeaders() {
        return proLeaders;
    }

    public void setProLeaders(String proLeaders) {
        this.proLeaders = proLeaders;
    }

    @Basic
    @Column(name = "pro_joiners")
    public String getProJoiners() {
        return proJoiners;
    }

    public void setProJoiners(String proJoiners) {
        this.proJoiners = proJoiners;
    }

    @Basic
    @Column(name = "total_fee")
    public String getTotalFee() {
        return totalFee;
    }

    public void setTotalFee(String totalFee) {
        this.totalFee = totalFee;
    }

    @Basic
    @Column(name = "pro_phase")
    public Integer getProPhase() {
        return proPhase;
    }

    public void setProPhase(Integer proPhase) {
        this.proPhase = proPhase;
    }

    @Basic
    @Column(name = "create_phasetime")
    public String getCreatePhasetime() {
        return createPhasetime;
    }

    public void setCreatePhasetime(String createPhasetime) {
        this.createPhasetime = createPhasetime;
    }

    @Basic
    @Column(name = "open_phasetime")
    public String getOpenPhasetime() {
        return openPhasetime;
    }

    public void setOpenPhasetime(String openPhasetime) {
        this.openPhasetime = openPhasetime;
    }

    @Basic
    @Column(name = "midcheck_phasetime")
    public String getMidcheckPhasetime() {
        return midcheckPhasetime;
    }

    public void setMidcheckPhasetime(String midcheckPhasetime) {
        this.midcheckPhasetime = midcheckPhasetime;
    }

    @Basic
    @Column(name = "close_phasetime")
    public String getClosePhasetime() {
        return closePhasetime;
    }

    public void setClosePhasetime(String closePhasetime) {
        this.closePhasetime = closePhasetime;
    }

    @Basic
    @Column(name = "end_phasetime")
    public String getEndPhasetime() {
        return endPhasetime;
    }

    public void setEndPhasetime(String endPhasetime) {
        this.endPhasetime = endPhasetime;
    }

    @Basic
    @Column(name = "received_fee")
    public Double getReceivedFee() {
        return receivedFee;
    }

    public void setReceivedFee(Double receivedFee) {
        this.receivedFee = receivedFee;
    }

    @Basic
    @Column(name = "noreceived_fee")
    public Double getNoreceivedFee() {
        return noreceivedFee;
    }

    public void setNoreceivedFee(Double noreceivedFee) {
        this.noreceivedFee = noreceivedFee;
    }

    @Basic
    @Column(name = "isreport_reward")
    public Integer getIsreportReward() {
        return isreportReward;
    }

    public void setIsreportReward(Integer isreportReward) {
        this.isreportReward = isreportReward;
    }

    @Basic
    @Column(name = "report_channel")
    public Integer getReportChannel() {
        return reportChannel;
    }

    public void setReportChannel(Integer reportChannel) {
        this.reportChannel = reportChannel;
    }

    @Basic
    @Column(name = "createphase_lxyjfid")
    public String getCreatephaseLxyjfid() {
        return createphaseLxyjfid;
    }

    public void setCreatephaseLxyjfid(String createphaseLxyjfid) {
        this.createphaseLxyjfid = createphaseLxyjfid;
    }

    @Basic
    @Column(name = "createphase_jysfid")
    public String getCreatephaseJysfid() {
        return createphaseJysfid;
    }

    public void setCreatephaseJysfid(String createphaseJysfid) {
        this.createphaseJysfid = createphaseJysfid;
    }

    @Basic
    @Column(name = "createphase_rwsfid")
    public String getCreatephaseRwsfid() {
        return createphaseRwsfid;
    }

    public void setCreatephaseRwsfid(String createphaseRwsfid) {
        this.createphaseRwsfid = createphaseRwsfid;
    }

    @Basic
    @Column(name = "createphase_otherfid")
    public String getCreatephaseOtherfid() {
        return createphaseOtherfid;
    }

    public void setCreatephaseOtherfid(String createphaseOtherfid) {
        this.createphaseOtherfid = createphaseOtherfid;
    }

    @Basic
    @Column(name = "openphase_rwsfid")
    public String getOpenphaseRwsfid() {
        return openphaseRwsfid;
    }

    public void setOpenphaseRwsfid(String openphaseRwsfid) {
        this.openphaseRwsfid = openphaseRwsfid;
    }

    @Basic
    @Column(name = "openphase_ktbgfid")
    public String getOpenphaseKtbgfid() {
        return openphaseKtbgfid;
    }

    public void setOpenphaseKtbgfid(String openphaseKtbgfid) {
        this.openphaseKtbgfid = openphaseKtbgfid;
    }

    @Basic
    @Column(name = "openphase_otherfid")
    public String getOpenphaseOtherfid() {
        return openphaseOtherfid;
    }

    public void setOpenphaseOtherfid(String openphaseOtherfid) {
        this.openphaseOtherfid = openphaseOtherfid;
    }

    @Basic
    @Column(name = "midphase_yjbgfid")
    public String getMidphaseYjbgfid() {
        return midphaseYjbgfid;
    }

    public void setMidphaseYjbgfid(String midphaseYjbgfid) {
        this.midphaseYjbgfid = midphaseYjbgfid;
    }

    @Basic
    @Column(name = "midphase_otherfid")
    public String getMidphaseOtherfid() {
        return midphaseOtherfid;
    }

    public void setMidphaseOtherfid(String midphaseOtherfid) {
        this.midphaseOtherfid = midphaseOtherfid;
    }

    @Basic
    @Column(name = "closephase_yjbgfid")
    public String getClosephaseYjbgfid() {
        return closephaseYjbgfid;
    }

    public void setClosephaseYjbgfid(String closephaseYjbgfid) {
        this.closephaseYjbgfid = closephaseYjbgfid;
    }

    @Basic
    @Column(name = "closephase_otherfid")
    public String getClosephaseOtherfid() {
        return closephaseOtherfid;
    }

    public void setClosephaseOtherfid(String closephaseOtherfid) {
        this.closephaseOtherfid = closephaseOtherfid;
    }

    @Basic
    @Column(name = "closephase_gcfid")
    public String getClosephaseGcfid() {
        return closephaseGcfid;
    }

    public void setClosephaseGcfid(String closephaseGcfid) {
        this.closephaseGcfid = closephaseGcfid;
    }

    @Basic
    @Column(name = "endphase_jdzsfid")
    public String getEndphaseJdzsfid() {
        return endphaseJdzsfid;
    }

    public void setEndphaseJdzsfid(String endphaseJdzsfid) {
        this.endphaseJdzsfid = endphaseJdzsfid;
    }

    @Basic
    @Column(name = "endphase_sbsfid")
    public String getEndphaseSbsfid() {
        return endphaseSbsfid;
    }

    public void setEndphaseSbsfid(String endphaseSbsfid) {
        this.endphaseSbsfid = endphaseSbsfid;
    }

    @Basic
    @Column(name = "endphase_psjg")
    public String getEndphasePsjg() {
        return endphasePsjg;
    }

    public void setEndphasePsjg(String endphasePsjg) {
        this.endphasePsjg = endphasePsjg;
    }

    @Basic
    @Column(name = "pro_researchcontent")
    public String getProResearchcontent() {
        return proResearchcontent;
    }

    public void setProResearchcontent(String proResearchcontent) {
        this.proResearchcontent = proResearchcontent;
    }

    @Basic
    @Column(name = "pro_remark")
    public String getProRemark() {
        return proRemark;
    }

    public void setProRemark(String proRemark) {
        this.proRemark = proRemark;
    }

    @Basic
    @Column(name = "classificlevel_id")
    public Integer getClassificlevelId() {
        return classificlevelId;
    }

    public void setClassificlevelId(Integer classificlevelId) {
        this.classificlevelId = classificlevelId;
    }

    @Basic
    @Column(name = "create_time")
    public Timestamp getCreateTime() {
        return createTime;
    }

    public void setCreateTime(Timestamp createTime) {
        this.createTime = createTime;
    }

    public Integer getCpAlertdays() {
        return cpAlertdays;
    }

    public void setCpAlertdays(Integer cpAlertdays) {
        this.cpAlertdays = cpAlertdays;
    }

    public Integer getMpAlertdays() {
        return mpAlertdays;
    }

    public void setMpAlertdays(Integer mpAlertdays) {
        this.mpAlertdays = mpAlertdays;
    }

    public Integer getClosepAlertdays() {
        return closepAlertdays;
    }

    public void setClosepAlertdays(Integer closepAlertdays) {
        this.closepAlertdays = closepAlertdays;
    }

    public Integer getEpAlertdays() {
        return epAlertdays;
    }

    public void setEpAlertdays(Integer epAlertdays) {
        this.epAlertdays = epAlertdays;
    }

    public Integer getOpAlertdays() {
        return opAlertdays;
    }

    public void setOpAlertdays(Integer opAlertdays) {
        this.opAlertdays = opAlertdays;
    }

    @Basic
    @Column(name = "creater")
    public Integer getCreater() {
        return creater;
    }

    public void setCreater(Integer creater) {
        this.creater = creater;
    }

    @Basic
    @Column(name = "pro_completeors")
    public String getProCompleteors() {
        return proCompleteors;
    }

    public void setProCompleteors(String proCompleteors) {
        this.proCompleteors = proCompleteors;
    }

    @Basic
    @Column(name = "yanjiu_zhou_qi")
    public Double getYanjiuZhouQi() {
        return yanjiuZhouQi;
    }

    public void setYanjiuZhouQi(Double yanjiuZhouQi) {
        this.yanjiuZhouQi = yanjiuZhouQi;
    }

    @Basic
    @Column(name = "yanjiu_fang_xiang")
    public String getYanjiuFangXiang() {
        return yanjiuFangXiang;
    }

    public void setYanjiuFangXiang(String yanjiuFangXiang) {
        this.yanjiuFangXiang = yanjiuFangXiang;
    }
}
