package com.song.archives.controller;

import com.song.archives.aspect.ArchivesLog;
import com.song.archives.dao.*;
import com.song.archives.model.*;
import com.song.archives.utils.ExcelUtil;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.json.JsonConfig;
import net.sf.json.util.CycleDetectionStrategy;
import org.apache.commons.beanutils.ConvertUtils;
import org.apache.log4j.Logger;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.subject.ExecutionException;
import org.apache.shiro.subject.Subject;
import org.apache.tomcat.jni.FileInfo;
import org.hibernate.id.GUIDGenerator;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import javax.persistence.criteria.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.util.*;
import java.util.zip.ZipOutputStream;

import static com.song.archives.utils.FileUtils.zipFile;

/**
 * Created by ghl on 2018/2/26.
 */
@Controller
@RequestMapping("/")
public class ProjectController {

    Logger logger = Logger.getLogger(UserController.class);

    @Autowired
    private ProjectRepository projectRepository;
    @Autowired
    private FileInfoRepository fileInfoRepository;

    @Autowired
    private ReceiveLogRepository receiveLogRepository;

    @Autowired
    private CuishouLogRepository cuishouLogRepository;
    @Autowired
    private YantaoLogRepository yantaoLogRepository;
    @Autowired
    private UserRepository userRepository;
    @Autowired
    private ProjectPhaseRepository projectPhaseRepository;
    @Autowired
    private PhaseFileTypeRepository phaseFileTypeRepository;
    @Autowired
    private ProjectFilesRepository projectFilesRepository;
    @Autowired
    private ChengYanDanWeiRepository chengYanDanWeiRepository;
    @Autowired
    private JianDingRepository jianDingRepository;
    @Autowired
    private BaoJiangRepository baoJiangRepository;
    @Autowired
    private HuoJiangRepository huoJiangRepository;
    @Autowired
    private ModuleFileRespository moduleFileRespository;

    @Value("${projectFilePath}")
    private String projectFilePath;
    @Value("${project.search.fields}")
    private String projectSearchFields;

    private String msg = "error";
    private String operationLogInfo = "";

    private JSONObject result = new JSONObject();

    private static HashMap<String, String> fileIdToNameMap = new HashMap<>();

    static {
        fileIdToNameMap.put("1_1", "【立项】立项依据文件");
        fileIdToNameMap.put("1_2", "【立项】建议书");
        fileIdToNameMap.put("1_3", "【立项】任务书");
        fileIdToNameMap.put("1_4", "【立项】其他文件");
        fileIdToNameMap.put("2_1", "【开题】任务书");
        fileIdToNameMap.put("2_2", "【开题】开题报告");
        fileIdToNameMap.put("2_3", "【开题】其他文件");
        fileIdToNameMap.put("3_1", "【中期】研究报告");
        fileIdToNameMap.put("3_2", "【中期】其他文件");
        fileIdToNameMap.put("4_1", "【结题】研究报告");
        fileIdToNameMap.put("4_2", "【结题】过程文件");
        fileIdToNameMap.put("4_3", "【结题】其他文件");
        fileIdToNameMap.put("5_1", "【后期】鉴定证书");
        fileIdToNameMap.put("5_2", "【后期】申报书");
        fileIdToNameMap.put("5_3", "【后期】评审结果");
    }

    private final String deleteProjectByIds = "DeleteProjectByIds";

    private List<ProjectInfoEntity> GetRelatedProjectAccordingUsr() {
        result = new JSONObject();
        User user = getUser();
        Specification<ProjectInfoEntity> specification;
        if (user.getType() == 1) {

            specification = new Specification<ProjectInfoEntity>() {
                @Override
                public Predicate toPredicate(Root<ProjectInfoEntity> root, CriteriaQuery<?> criteriaQuery, CriteriaBuilder criteriaBuilder) {
                    List<Predicate> predicates = new ArrayList<Predicate>();


                    Path<Integer> proId = root.get("id");

                    return criteriaBuilder.greaterThan(proId, 0);


                }
            };

            //  return projectRepository.findAll(specification);
        } else {
            specification = new Specification<ProjectInfoEntity>() {
                @Override
                public Predicate toPredicate(Root<ProjectInfoEntity> root, CriteriaQuery<?> criteriaQuery, CriteriaBuilder criteriaBuilder) {
                    List<Predicate> predicates = new ArrayList<Predicate>();


                    Path<String> proLeaders = root.get("proLeaders");

                    Predicate predicate = criteriaBuilder.equal(proLeaders, user.getRealName().toString());

                    predicates.add(predicate);

                    Predicate predicate0 = criteriaBuilder.equal(root.get("proJoiners"), user.getRealName().toString());

                    predicates.add(predicate0);

                    Path<String> proJoiners = root.get("proJoiners");

                    Predicate predicate1 = criteriaBuilder.like(proJoiners.as(String.class), "%," + user.getRealName().toString() + ",%");

                    predicates.add(predicate1);

                    Predicate predicate2 = criteriaBuilder.like(proJoiners.as(String.class), user.getRealName().toString() + ",%");
                    predicates.add(predicate2);
                    Predicate predicate3 = criteriaBuilder.like(proJoiners.as(String.class), "%," + user.getRealName().toString());
                    predicates.add(predicate3);

                    return criteriaBuilder.or(predicates.toArray(new Predicate[predicates.size()]));
                }
            };

        }
        return projectRepository.findAll(specification);

    }

    @RequestMapping(value = "SaveCyDanwei")
    @ResponseBody
    public String SaveCyDanwei(@RequestParam(value = "type") Integer type,
                               @RequestParam(value = "danweiName") String danweiName,
                               @RequestParam(value = "proid") Long proid,
                               @RequestParam(value = "contractName") String contractName,
                               @RequestParam(value = "mobile") String mobile,
                               @RequestParam(value = "editDanweiId") Long editDanweiId,
                               @RequestParam(value = "fee") float fee,
                               @RequestParam(value = "contractTime") String contractTime,
                               @RequestParam(value = "yanshouTime") String yanshouTime,
                               @RequestParam(value = "content") String content) {
        result = new JSONObject();

        ChengYanDanWeiEntity chengYanDanWeiEntity = null;
        if (editDanweiId > 0) {

            chengYanDanWeiEntity = chengYanDanWeiRepository.findOne(editDanweiId);

        } else {
            chengYanDanWeiEntity = new ChengYanDanWeiEntity();

        }

        chengYanDanWeiEntity.setType(type);
        chengYanDanWeiEntity.setContractName(contractName);
        chengYanDanWeiEntity.setMobile(mobile);
        chengYanDanWeiEntity.setDanweiName(danweiName);
        chengYanDanWeiEntity.setProid(proid);
        chengYanDanWeiEntity.setFee(fee);
        chengYanDanWeiEntity.setContractTime(contractTime);
        chengYanDanWeiEntity.setYanshouTime(yanshouTime);
        chengYanDanWeiEntity.setContent(content);

        chengYanDanWeiRepository.save(chengYanDanWeiEntity);

        result.put("msg", "success");

        return result.toString();

    }

    @RequestMapping(value = "GetCyDanweiList")
    @ResponseBody
    public String GetCyDanweiList(@RequestParam(value = "proid") long proid, @RequestParam(value = "pageIndex", defaultValue = "0") Integer currentpage,
                                  @RequestParam(value = "pageSize", defaultValue = "10") Integer size) {

        result = new JSONObject();
        currentpage = currentpage - 1;
        Sort sort = new Sort(Sort.Direction.ASC, "id");
        Pageable pageable = new PageRequest(currentpage, size, sort);
        Specification<ChengYanDanWeiEntity> specification = new Specification<ChengYanDanWeiEntity>() {
            @Override
            public Predicate toPredicate(Root<ChengYanDanWeiEntity> root, CriteriaQuery<?> criteriaQuery, CriteriaBuilder criteriaBuilder) {


                Path<Long> cproid = root.get("proid");

                return criteriaBuilder.equal(cproid, proid);
                // return criteriaBuilder.and(predicate1);
            }
        };

        Page<ChengYanDanWeiEntity> chengYanDanWeiEntityPage = chengYanDanWeiRepository.findAll(specification, pageable);
        JsonConfig jsonConfig = new JsonConfig();

        jsonConfig.setCycleDetectionStrategy(CycleDetectionStrategy.LENIENT);

        JSONArray cydanweiJson = JSONArray.fromObject(chengYanDanWeiEntityPage, jsonConfig);

        result.put("result", cydanweiJson);

        return result.toString();
    }

    @RequestMapping(value = "DeleteCyDanweiList")
    @ResponseBody
    public String DeleteCyDanweiList(@RequestParam(value = "cids") long[] cids) {
        result = new JSONObject();

        try {

            for (long id : cids) {

                chengYanDanWeiRepository.delete(id);
            }

            result.put("msg", "success");
        } catch (Exception ex) {

            result.put("msg", "error");
        }

        return result.toString();

    }

    @RequestMapping(value = "ReviewProjectFiles")
    @ResponseBody
    public String ReviewProjectFiles(HttpServletResponse response,
                                     @RequestParam(value = "fid") Long fid) {

        FileInfoEntity fileInfoEntity = fileInfoRepository.findOne(fid);

        File file = new File(projectFilePath + "/" + fileInfoEntity.getFilePath());

        // 文件输出流
        try {

            // 以流的形式下载文件。
            BufferedInputStream fis = new BufferedInputStream(new FileInputStream(file.getPath()));
            byte[] buffer = new byte[fis.available()];
            fis.read(buffer);
            fis.close();
            // 清空response
            response.reset();
            OutputStream toClient = new BufferedOutputStream(response.getOutputStream());
            response.setContentType("application/octet-stream");
            response.setHeader("Content-Disposition", "filename=" + new String(file.getName().getBytes("UTF-8"), "ISO-8859-1"));
            toClient.write(buffer);
            toClient.flush();
            toClient.close();

        } catch (Exception e) {
            e.printStackTrace();
        }


        return "";
    }

    @RequestMapping(value = "BatchDownProjectFiles")
    @ResponseBody
    public String BatchDownProjectFiles(HttpServletResponse response,
                                        @RequestParam(value = "proid") Long proid,
                                        @RequestParam(value = "ids") Long[] ids) {

        String fileName = UUID.randomUUID().toString() + ".zip";
        // 在服务器端创建打包下载的临时文件
        File fileZip = new File(projectFilePath + "/downfiles/" + fileName);

        if (!fileZip.getParentFile().exists()) {
            fileZip.getParentFile().mkdirs();
        }

        if (!fileZip.exists()) {
            try {
                fileZip.createNewFile();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
        List<File> files = new ArrayList<>();

        for (int i = 0; i < ids.length; i++) {
            FileInfoEntity fileInfoEntity = fileInfoRepository.findOne(ids[i]);
            if (fileInfoEntity.getFileType().equals("1")) {
                File file = new File(projectFilePath + "/" + fileInfoEntity.getFilePath());
                // File file1=new File(projectFilePath+"/"+fileInfoEntity.getFileName());
                //  file.renameTo(file1);
                files.add(file);
            }

        }
        // 文件输出流
        try {
            FileOutputStream outStream = new FileOutputStream(fileZip);
            // 压缩流
            ZipOutputStream toClient = new ZipOutputStream(outStream);
            //  toClient.setEncoding("gbk");
            zipFile(files, toClient);
            toClient.close();
            outStream.close();

            this.downloadFile(fileZip, response, true);
        } catch (Exception e) {
            e.printStackTrace();
        }

        return "";
    }

    public void downloadFile(File file, HttpServletResponse response, boolean isDelete) {
        try {
            // 以流的形式下载文件。
            BufferedInputStream fis = new BufferedInputStream(new FileInputStream(file.getPath()));
            byte[] buffer = new byte[fis.available()];
            fis.read(buffer);
            fis.close();
            // 清空response
            response.reset();
            OutputStream toClient = new BufferedOutputStream(response.getOutputStream());
            response.setContentType("application/octet-stream");
            response.setHeader("Content-Disposition", "attachment;filename=" + new String(file.getName().getBytes("UTF-8"), "ISO-8859-1"));
            toClient.write(buffer);
            toClient.flush();
            toClient.close();

            if (isDelete) {
                file.delete();        //是否将生成的服务器端文件删除
            }
        } catch (IOException ex) {
            ex.printStackTrace();
        }
    }

    @RequestMapping(value = "LoadAlertList")
    @ResponseBody
    @ArchivesLog(operationType = "LoadAlertList", operationName = "加载提示信息")
    public String LoadAlertList() {
        result = new JSONObject();
        StringBuilder pAlertHtml = new StringBuilder();
        try {

            List<ProjectInfoEntity> projectInfoEntityList = GetRelatedProjectAccordingUsr();
            ProjectInfoEntity tempPro = new ProjectInfoEntity();
            CuishouLogEntity tempCui = new CuishouLogEntity();
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            Calendar calendar = Calendar.getInstance();
            //Calendar calendar1=Calendar.getInstance();
            for (int i = 0; i < projectInfoEntityList.size(); i++) {
                try {
                    tempPro = projectInfoEntityList.get(i);
                    if (!IsValidProject(tempPro))
                        continue;
                    //立项提醒
                    Date d1 = sdf.parse(tempPro.getCreatePhasetime());
                    calendar.add(Calendar.DAY_OF_MONTH, tempPro.getCpAlertdays());
                    if (Calendar.getInstance().getTime().before(d1) && calendar.getTime().after(d1)) {
                        pAlertHtml.append("<a href=\"javascript:void(0)\" class=\"list-group-item\">\n" +
                                "<i class=\"fa fa-comment fa-fw\"></i>");
                        pAlertHtml.append("项目【");
                        pAlertHtml.append(tempPro.getProName());
                        pAlertHtml.append("】距离<font style=\"font-size: large;color:red\">立项</font>还有");
                        calendar.setTime(d1);
                        pAlertHtml.append("<font style=\"font-size: large;color:red\">" + (calendar.get(Calendar.DAY_OF_YEAR) - Calendar.getInstance().get(Calendar.DAY_OF_YEAR)) + "</font>天<br>");
                        pAlertHtml.append("<span class=\"text-muted small\"><em>预定时间：" + tempPro.getCreatePhasetime() + "</em>\n</span>\n</a>");

                    }

                    //开题提醒
                    d1 = sdf.parse(tempPro.getOpenPhasetime());
                    calendar = Calendar.getInstance();
                    calendar.add(Calendar.DAY_OF_MONTH, tempPro.getOpAlertdays());
                    if (Calendar.getInstance().getTime().before(d1) && calendar.getTime().after(d1)) {
                        pAlertHtml.append("<a href=\"javascript:void(0)\" class=\"list-group-item\">\n" +
                                "<i class=\"fa fa-comment fa-life-bouy\"></i>");
                        pAlertHtml.append("项目【");
                        pAlertHtml.append(tempPro.getProName());
                        pAlertHtml.append("】距离<font style=\"font-size: large;color:red\">开题</font>还有");
                        calendar.setTime(d1);
                        pAlertHtml.append("<font style=\"font-size: large;color:red\">" + (calendar.get(Calendar.DAY_OF_YEAR) - Calendar.getInstance().get(Calendar.DAY_OF_YEAR)) + "</font>天<br>");
                        pAlertHtml.append("<span class=\"text-muted small\"><em>预定时间：" + tempPro.getOpenPhasetime() + "</em>\n</span>\n</a>");

                    }

                    //中期提醒
                    d1 = sdf.parse(tempPro.getMidcheckPhasetime());
                    calendar = Calendar.getInstance();
                    calendar.add(Calendar.DAY_OF_MONTH, tempPro.getMpAlertdays());
                    if (Calendar.getInstance().getTime().before(d1) && calendar.getTime().after(d1)) {
                        pAlertHtml.append("<a href=\"javascript:void(0)\" class=\"list-group-item\">\n" +
                                "<i class=\"fa fa-comment fa-tree\"></i>");
                        pAlertHtml.append("项目【");
                        pAlertHtml.append(tempPro.getProName());
                        pAlertHtml.append("】距离<font style=\"font-size: large;color:red\">中期</font>检查还有");
                        calendar.setTime(d1);
                        pAlertHtml.append("<font style=\"font-size: large;color:red\">" + (calendar.get(Calendar.DAY_OF_YEAR) - Calendar.getInstance().get(Calendar.DAY_OF_YEAR)) + "</font>天<br>");
                        pAlertHtml.append("<span class=\"text-muted small\"><em>预定时间：" + tempPro.getMidcheckPhasetime() + "</em>\n</span>\n</a>");

                    }

                    //结题提醒
                    d1 = sdf.parse(tempPro.getClosePhasetime());
                    calendar = Calendar.getInstance();
                    calendar.add(Calendar.DAY_OF_MONTH, tempPro.getCpAlertdays());
                    if (Calendar.getInstance().getTime().before(d1) && calendar.getTime().after(d1)) {
                        pAlertHtml.append("<a href=\"javascript:void(0)\" class=\"list-group-item\">\n" +
                                "<i class=\"fa fa-comment fa-table\"></i>");
                        pAlertHtml.append("项目【");
                        pAlertHtml.append(tempPro.getProName());
                        pAlertHtml.append("】距离<font style=\"font-size: large;color:red\">结题</font>还有");
                        calendar.setTime(d1);
                        pAlertHtml.append("<font style=\"font-size: large;color:red\">" + (calendar.get(Calendar.DAY_OF_YEAR) - Calendar.getInstance().get(Calendar.DAY_OF_YEAR)) + "</font>天<br>");
                        pAlertHtml.append("<span class=\"text-muted small\"><em>预定时间：" + tempPro.getClosePhasetime() + "</em>\n</span>\n</a>");

                    }

                    //结题提醒
                    d1 = sdf.parse(tempPro.getEndPhasetime());
                    calendar = Calendar.getInstance();
                    calendar.add(Calendar.DAY_OF_MONTH, tempPro.getEpAlertdays());
                    if (Calendar.getInstance().getTime().before(d1) && calendar.getTime().after(d1)) {
                        pAlertHtml.append("<a href=\"javascript:void(0)\" class=\"list-group-item\">\n" +
                                "<i class=\"fa fa-comment fa-bitbucket\"></i>");
                        pAlertHtml.append("项目【");
                        pAlertHtml.append(tempPro.getProName());
                        pAlertHtml.append("】距离<font style=\"font-size: large;color:red\">后期</font>管理还有");
                        calendar.setTime(d1);
                        pAlertHtml.append("<font style=\"font-size: large;color:red\">" + (calendar.get(Calendar.DAY_OF_YEAR) - Calendar.getInstance().get(Calendar.DAY_OF_YEAR)) + "</font>天<br>");
                        pAlertHtml.append("<span class=\"text-muted small\"><em>预定时间：" + tempPro.getEndPhasetime() + "</em>\n</span>\n</a>");

                    }

                } catch (Exception ex) {

                }
            }

            List<CuishouLogEntity> cuishouLogEntityList = cuishouLogRepository.findAllByJingbanrenIdEquals(getUser().getId().toString());
            calendar = Calendar.getInstance();

            for (int i = 0; i < cuishouLogEntityList.size(); i++) {

                try {
                    tempCui = cuishouLogEntityList.get(i);
                    //催收提醒
                    Date d1 = tempCui.getCuishouTime();
                    calendar.add(Calendar.DAY_OF_MONTH, tempCui.getAlertDays());
                    if (Calendar.getInstance().getTime().before(d1) && calendar.getTime().after(d1)) {
                        pAlertHtml.append("<a href=\"javascript:void(0)\" class=\"list-group-item\">\n" +
                                "<i class=\"fa fa-comment  fa-rmb\"></i>");
                        pAlertHtml.append("项目【");
                        tempPro = projectRepository.findOne(tempCui.getProid());
                        pAlertHtml.append(tempPro.getProName());
                        pAlertHtml.append("】距离<font style=\"font-size: large;color:red\">催收</font>");
                        pAlertHtml.append(tempCui.getCuishouAmount());
                        pAlertHtml.append("元款项还有");
                        calendar.setTime(d1);
                        pAlertHtml.append("<font style=\"font-size: large;color:red\">" + (calendar.get(Calendar.DAY_OF_YEAR) - Calendar.getInstance().get(Calendar.DAY_OF_YEAR)) + "</font>天<br>");
                        SimpleDateFormat myFmt2 = new SimpleDateFormat("yyyy-MM-dd");
                        pAlertHtml.append("<span class=\"text-muted small\"><em>预定时间：" + myFmt2.format(tempCui.getCuishouTime()) + "</em>\n</span>\n</a>");

                    }
                } catch (Exception ex) {

                }

            }
            msg = "success";
        } catch (Exception ex) {
            ex.printStackTrace();
            logger.error(ex.getMessage());
            msg = "error";
        }

        if (pAlertHtml.length() <= 0) {
            msg = "error";
        }

        operationLogInfo = "用户【" + getUser().getUsername() + "】加载提示信息";
        result.put("msg", msg);
        result.put("data", pAlertHtml.toString());
        result.put("operationLog", operationLogInfo);
        return result.toString();
    }

    private boolean IsValidProject(ProjectInfoEntity projectInfoEntity) {
        if (projectInfoEntity.getCreatePhasetime().isEmpty())
            return false;
        if (projectInfoEntity.getOpenPhasetime().isEmpty())
            return false;
        if (projectInfoEntity.getClosePhasetime().isEmpty())
            return false;
        if (projectInfoEntity.getEndPhasetime().isEmpty())
            return false;

        if (projectInfoEntity.getMidcheckPhasetime().isEmpty())
            return false;

        return true;

    }

    @RequestMapping(value = "LoadProjectProcess")
    @ResponseBody
    @ArchivesLog(operationType = "LoadProjectProcess", operationName = "加载项目进度")
    public String LoadProjectProcess() throws ParseException {

        result = new JSONObject();

        List<ProjectInfoEntity> projectInfoEntityList = GetRelatedProjectAccordingUsr();
        JSONArray allProObj = new JSONArray();
        JSONArray proNameObjs = new JSONArray();

        List<User> users = new ArrayList<>();
        try {
            for (int i = 0; i < projectInfoEntityList.size(); i++) {
                StringBuilder proLeaders = new StringBuilder();
                StringBuilder proJoiners = new StringBuilder();
//                proLeaders.append(userRepository.findOne(Long.parseLong(projectInfoEntityList.get(i).getProLeaders())).getUsername());
//                if (projectInfoEntityList.get(i).getProJoiners() != null) {
//                    users = userRepository.findByIdIsIn((Long[]) ConvertUtils.convert(projectInfoEntityList.get(i).getProJoiners().split(","), Long.class));
//                }
//                if (users != null && users.size() > 0) {
//
//                    for (int j = 0; j < users.size(); j++) {
//                        proJoiners.append(users.get(j).getUsername());
//                        proJoiners.append(",");
//                    }
//                }

                if (!IsValidProject(projectInfoEntityList.get(i)))
                    continue;

                JSONObject proName = new JSONObject();
                proName.put("proname", projectInfoEntityList.get(i).getProName());
                proName.put("proLeaders", projectInfoEntityList.get(i).getProLeaders());
                proName.put("proJoiners", projectInfoEntityList.get(i).getProJoiners());
                proNameObjs.add(proName);
                JSONObject proObj1 = new JSONObject();
                proObj1.put("name", "立项阶段");
                proObj1.put("desc", "");
                JSONArray cphaseObj = new JSONArray();
                JSONObject createPhaseObj = new JSONObject();
                SimpleDateFormat myFmt2 = new SimpleDateFormat("yyyy-MM-dd");
                createPhaseObj.put("from", "/Date(" + myFmt2.parse(projectInfoEntityList.get(i).getCreatePhasetime()).getTime() + ")/");
                createPhaseObj.put("to", "/Date(" + myFmt2.parse(projectInfoEntityList.get(i).getOpenPhasetime()).getTime() + ")/");
                createPhaseObj.put("label", "立项阶段");
                //createPhaseObj.put("desc", "立项阶段!!!");
                createPhaseObj.put("customClass", "ganttRed");
                cphaseObj.add(createPhaseObj);

                proObj1.put("values", cphaseObj);
                allProObj.add(proObj1);

                JSONObject proObj2 = new JSONObject();
                proObj2.put("name", "开题阶段");
                proObj2.put("desc", "");
                JSONArray ophaseObj = new JSONArray();
                JSONObject openPhaseObj = new JSONObject();
                openPhaseObj.put("from", myFmt2.parse(projectInfoEntityList.get(i).getOpenPhasetime()).getTime());
                openPhaseObj.put("to", myFmt2.parse(projectInfoEntityList.get(i).getMidcheckPhasetime()).getTime());
                openPhaseObj.put("label", "开题阶段");
                openPhaseObj.put("customClass", "ganttBlue");
                ophaseObj.add(openPhaseObj);
                proObj2.put("values", ophaseObj);
                allProObj.add(proObj2);


                JSONObject proObj3 = new JSONObject();
                proObj3.put("name", "中期阶段");
                proObj3.put("desc", "");
                JSONArray mphaseObj = new JSONArray();
                JSONObject midPhaseObj = new JSONObject();
                midPhaseObj.put("from", myFmt2.parse(projectInfoEntityList.get(i).getMidcheckPhasetime()).getTime());
                midPhaseObj.put("to", myFmt2.parse(projectInfoEntityList.get(i).getClosePhasetime()).getTime());
                midPhaseObj.put("label", "中期阶段");
                midPhaseObj.put("customClass", "ganttGreen");
                mphaseObj.add(midPhaseObj);
                proObj3.put("values", mphaseObj);
                allProObj.add(proObj3);


                JSONObject proObj4 = new JSONObject();
                proObj4.put("name", "结题阶段");
                proObj4.put("desc", "");
                JSONArray closephaseObjs = new JSONArray();
                JSONObject closePhaseObj = new JSONObject();
                closePhaseObj.put("from", myFmt2.parse(projectInfoEntityList.get(i).getClosePhasetime()).getTime());
                closePhaseObj.put("to", myFmt2.parse(projectInfoEntityList.get(i).getEndPhasetime()).getTime());
                closePhaseObj.put("label", "结题阶段");
                closePhaseObj.put("customClass", "ganttOrange");
                closephaseObjs.add(closePhaseObj);
                proObj4.put("values", closephaseObjs);
                allProObj.add(proObj4);

                JSONObject proObj5 = new JSONObject();
                proObj5.put("name", "后期阶段");
                proObj5.put("desc", "");
                JSONArray ephaseObjs = new JSONArray();
                JSONObject endPhaseObj = new JSONObject();
                endPhaseObj.put("from", myFmt2.parse(projectInfoEntityList.get(i).getEndPhasetime()).getTime());
                endPhaseObj.put("to", myFmt2.parse(projectInfoEntityList.get(i).getEndPhasetime()).getTime() + 3600);
                endPhaseObj.put("label", "后期阶段");
                endPhaseObj.put("customClass", "ganttRed");
                ephaseObjs.add(endPhaseObj);
                proObj5.put("values", ephaseObjs);
                allProObj.add(proObj5);

            }
        } catch (Exception ex) {

            logger.error(ex.getMessage());
            ex.printStackTrace();
        }

        operationLogInfo = "用户【" + getUser().getUsername() + "】加载项目进度";

        JSONObject resutObj = new JSONObject();
        resutObj.put("proData", allProObj);
        resutObj.put("proNames", proNameObjs);
        return resutObj.toString();
    }

    @RequestMapping(value = "CreateProject")
    public String CreateProject() {


        return "project/CreateProject";
    }

    @RequestMapping(value = "/ProjectList")
    public String ProjectList() {

        return "project/ProjectList";
    }

    @RequestMapping(value = "/ProjectDetail")
    public ModelAndView ProjectDetail(@RequestParam(value = "pid", required = false) Long pid, HttpServletRequest request) {
        ModelAndView model = new ModelAndView();
        model.setViewName("/project/ProjectDetail");
        model.addObject("proentity", projectRepository.findOne(pid));
        model.addObject("mid", 1);
        String path = request.getContextPath();
//      获得本项目的地址(例如: http://localhost:8080/MyApp/)赋值给basePath变量
        String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
        model.addObject("basePath", basePath);
        Specification<User> specification = (root, criteriaQuery, criteriaBuilder) -> {

            // List<Predicate> predicates = new ArrayList<>();

            Path<Integer> usertype = root.get("type");


            Predicate predicate = criteriaBuilder.equal(usertype.as(Integer.class), 0);


            //return criteriaBuilder.and(predicates.toArray(new Predicate[predicates.size()]));
            return predicate;
        };


        List<User> users = userRepository.findAll(specification);

        model.addObject("users", users);

        List<ProjectPhaseEntity> projectPhaseEntities = projectPhaseRepository.findAll();


        model.addObject("phases", projectPhaseEntities);

        List<PhaseFileTypeEntity> phaseFileTypeEntities = phaseFileTypeRepository.findAllByPhaseId(1);

        model.addObject("phasesfiletype", phaseFileTypeEntities);

        return model;
    }

    @RequestMapping(value = "LoadJianDingList")
    @ResponseBody
    public String LoadJianDingList(@RequestParam(value = "pageIndex", defaultValue = "0") Integer currentpage,
                                   @RequestParam(value = "pageSize", defaultValue = "10") Integer size,
                                   @RequestParam(value = "proid") Long proid) {
        result = new JSONObject();
        currentpage = currentpage - 1;
        Sort sort = new Sort(Sort.Direction.ASC, "id");
        Pageable pageable = new PageRequest(currentpage, size, sort);

        Specification<JianDingEntity> specification = new Specification<JianDingEntity>() {
            @Override
            public Predicate toPredicate(Root<JianDingEntity> root, CriteriaQuery<?> criteriaQuery, CriteriaBuilder criteriaBuilder) {


                Path<Integer> pproid = root.get("jdproid");

                return criteriaBuilder.equal(pproid, proid);
                // return criteriaBuilder.and(predicate1);
            }
        };

        List<JianDingEntity> jianDingEntityList = jianDingRepository.findAll(specification, pageable);

        result.put("msg", "ok");
        result.put("result", JSONArray.fromObject(jianDingEntityList));
        return result.toString();
    }

    @RequestMapping(value = "SaveBaojiang")
    @ResponseBody
    public String SaveBaojiang(@RequestParam(value = "bjproid") Long proid,
                               @RequestParam(value = "bjjltype") String bjjltype,
                               @RequestParam(value = "bjdjtype") String bjdjtype,
                               @RequestParam(value = "bjtime") String bjtime) throws ParseException {
        result = new JSONObject();
        msg = "success";
        if (proid > 0) {
            BaoJiangEntity baoJiangEntity = new BaoJiangEntity();
            baoJiangEntity.setProId(proid);
            baoJiangEntity.setJiangLiType(bjjltype);
            baoJiangEntity.setShenbaoDengji(bjdjtype);
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            baoJiangEntity.setBaojiangDate(sdf.parse(bjtime));
            baoJiangRepository.save(baoJiangEntity);
        } else {
            msg = "failed";
        }

        result.put("msg", msg);
        return result.toString();

    }

    @RequestMapping(value = "SaveHuojiang")
    @ResponseBody
    public String SaveHuojiang(@RequestParam(value = "hjproid") Long proid,
                               @RequestParam(value = "hjjltype") String hjjltype,
                               @RequestParam(value = "hjdjtype") String hjdjtype,
                               @RequestParam(value = "hjtime") String hjtime) throws ParseException {
        result = new JSONObject();
        msg = "success";
        if (proid > 0) {
            HuoJiangEntity huoJiangEntity = new HuoJiangEntity();
            huoJiangEntity.setProId(proid);
            huoJiangEntity.setJiangliType(hjjltype);
            huoJiangEntity.setHuojiangDengji(hjdjtype);
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            huoJiangEntity.setHuojiangDate(sdf.parse(hjtime));
            huoJiangRepository.save(huoJiangEntity);
        } else {
            msg = "failed";
        }
        result.put("msg", msg);
        return result.toString();
    }

    @RequestMapping(value = "LoadNiBaoJiangList")
    @ResponseBody
    public String LoadNiBaoJiangList(@RequestParam(value = "pageIndex", defaultValue = "0") Integer currentpage,
                                     @RequestParam(value = "pageSize", defaultValue = "10") Integer size,
                                     @RequestParam(value = "proid") Long proid) {
        result = new JSONObject();

        currentpage = currentpage - 1;
        Sort sort = new Sort(Sort.Direction.ASC, "id");
        Pageable pageable = new PageRequest(currentpage, size, sort);

        Specification<BaoJiangEntity> specification = new Specification<BaoJiangEntity>() {
            @Override
            public Predicate toPredicate(Root<BaoJiangEntity> root, CriteriaQuery<?> criteriaQuery, CriteriaBuilder criteriaBuilder) {


                Path<Integer> pproid = root.get("proId");

                return criteriaBuilder.equal(pproid, proid);
                // return criteriaBuilder.and(predicate1);
            }
        };

        List<BaoJiangEntity> baoJiangEntityList = baoJiangRepository.findAll(specification, pageable);

        result.put("msg", "ok");
        result.put("result", JSONArray.fromObject(baoJiangEntityList));
        return result.toString();
    }

    @RequestMapping(value = "LoadHuoJiangList")
    @ResponseBody
    public String LoadHuoJiangList(@RequestParam(value = "pageIndex", defaultValue = "0") Integer currentpage,
                                   @RequestParam(value = "pageSize", defaultValue = "10") Integer size,
                                   @RequestParam(value = "proid") Long proid) {
        result = new JSONObject();

        currentpage = currentpage - 1;
        Sort sort = new Sort(Sort.Direction.ASC, "id");
        Pageable pageable = new PageRequest(currentpage, size, sort);

        Specification<HuoJiangEntity> specification = new Specification<HuoJiangEntity>() {
            @Override
            public Predicate toPredicate(Root<HuoJiangEntity> root, CriteriaQuery<?> criteriaQuery, CriteriaBuilder criteriaBuilder) {


                Path<Integer> pproid = root.get("proId");

                return criteriaBuilder.equal(pproid, proid);
                // return criteriaBuilder.and(predicate1);
            }
        };

        List<HuoJiangEntity> huoJiangEntityList = huoJiangRepository.findAll(specification, pageable);

        result.put("msg", "ok");
        result.put("result", JSONArray.fromObject(huoJiangEntityList));
        return result.toString();
    }

    @RequestMapping(value = "/LoadReceiveLogList")
    @ResponseBody
    public String LoadReceiveLogList(@RequestParam(value = "pageIndex", defaultValue = "0") Integer currentpage,
                                     @RequestParam(value = "pageSize", defaultValue = "10") Integer size,
                                     @RequestParam(value = "proid") Long proid) {


        result = new JSONObject();
        currentpage = currentpage - 1;
        Sort sort = new Sort(Sort.Direction.ASC, "id");
        Pageable pageable = new PageRequest(currentpage, size, sort);

        Specification<ReceivedLogEntity> specification = new Specification<ReceivedLogEntity>() {
            @Override
            public Predicate toPredicate(Root<ReceivedLogEntity> root, CriteriaQuery<?> criteriaQuery, CriteriaBuilder criteriaBuilder) {


                Path<Integer> pproid = root.get("projectId");

                return criteriaBuilder.equal(pproid, proid);
                // return criteriaBuilder.and(predicate1);
            }
        };

        List<ReceivedLogEntity> receivedLogEntityList = receiveLogRepository.findAll(specification, pageable);
        ProjectInfoEntity projectInfoEntity = projectRepository.findOne(proid);

        operationLogInfo = "用户【" + getUser().getUsername() + "】进行查询项目[" + projectInfoEntity.getProName() + "]已收账款列表操作";
        result.put("msg", "ok");
        result.put("operationLog", operationLogInfo);
        result.put("result", JSONArray.fromObject(receivedLogEntityList));
        return result.toString();
    }

    @RequestMapping(value = "/LoadYantaoLogList")
    @ResponseBody
    public String LoadYantaoLogList(@RequestParam(value = "pageIndex", defaultValue = "0") Integer currentpage,
                                    @RequestParam(value = "pageSize", defaultValue = "10") Integer size,
                                    @RequestParam(value = "proid") Long proid) {

        result = new JSONObject();
        currentpage = currentpage - 1;
        Sort sort = new Sort(Sort.Direction.ASC, "yid");
        Pageable pageable = new PageRequest(currentpage, size, sort);

        Specification<YantaoLogEntity> specification = new Specification<YantaoLogEntity>() {
            @Override
            public Predicate toPredicate(Root<YantaoLogEntity> root, CriteriaQuery<?> criteriaQuery, CriteriaBuilder criteriaBuilder) {


                Path<Integer> pproid = root.get("proId");

                return criteriaBuilder.equal(pproid, proid);
                // return criteriaBuilder.and(predicate1);
            }
        };

        List<YantaoLogEntity> yantaoLogEntityList = yantaoLogRepository.findAll(specification, pageable);
        ProjectInfoEntity projectInfoEntity = projectRepository.findOne(proid);

        operationLogInfo = "用户【" + getUser().getUsername() + "】进行查询项目[" + projectInfoEntity.getProName() + "]研讨记录列表操作";
        result.put("msg", "ok");
        result.put("operationLog", operationLogInfo);
        result.put("result", JSONArray.fromObject(yantaoLogEntityList));
        return result.toString();
    }


    @RequestMapping(value = "/LoadCuishouLogList")
    @ResponseBody
    public String LoadCuishouLogList(@RequestParam(value = "pageIndex", defaultValue = "0") Integer currentpage,
                                     @RequestParam(value = "pageSize", defaultValue = "10") Integer size,
                                     @RequestParam(value = "proid") Long proid) {

        result = new JSONObject();
        currentpage = currentpage - 1;
        Sort sort = new Sort(Sort.Direction.ASC, "id");
        Pageable pageable = new PageRequest(currentpage, size, sort);
        Specification<CuishouLogEntity> specification = new Specification<CuishouLogEntity>() {
            @Override
            public Predicate toPredicate(Root<CuishouLogEntity> root, CriteriaQuery<?> criteriaQuery, CriteriaBuilder criteriaBuilder) {


                Path<Integer> pproid = root.get("proid");

                return criteriaBuilder.equal(pproid, proid);
                // return criteriaBuilder.and(predicate1);
            }
        };
        List<CuishouLogEntity> cuishouLogEntityList = cuishouLogRepository.findAll(specification, pageable);

        ProjectInfoEntity projectInfoEntity = projectRepository.findOne(proid);

        operationLogInfo = "用户【" + getUser().getUsername() + "】进行查询项目[" + projectInfoEntity.getProName() + "]催收列表操作";
        result.put("msg", "ok");
        result.put("operationLog", operationLogInfo);
        result.put("result", JSONArray.fromObject(cuishouLogEntityList));
        return result.toString();
    }

    @RequestMapping(value = "/GetProjectCount")
    @ResponseBody
    @ArchivesLog(operationType = "GetProjectCount", operationName = "查询項目數量")
    public String GetProjectCount() {
        result = new JSONObject();
        User user = getUser();

        if (user.getType() == 1) {
            Specification<ProjectInfoEntity> specification1 = new Specification<ProjectInfoEntity>() {
                @Override
                public Predicate toPredicate(Root<ProjectInfoEntity> root, CriteriaQuery<?> criteriaQuery, CriteriaBuilder criteriaBuilder) {
                    List<Predicate> predicates = new ArrayList<Predicate>();


                    Path<String> pid = root.get("id");

                    Predicate predicate = criteriaBuilder.notEqual(pid, 0);

                    return predicate;
                }
            };

            List<ProjectInfoEntity> projectInfoEntities = projectRepository.findAll(specification1);
            result.put("msg", "success");
            result.put("data", projectInfoEntities.size());
        } else {
            Specification<ProjectInfoEntity> specification1 = new Specification<ProjectInfoEntity>() {
                @Override
                public Predicate toPredicate(Root<ProjectInfoEntity> root, CriteriaQuery<?> criteriaQuery, CriteriaBuilder criteriaBuilder) {
                    List<Predicate> predicates = new ArrayList<Predicate>();


                    Path<String> proLeaders = root.get("proLeaders");

                    Predicate predicate = criteriaBuilder.equal(proLeaders, user.getRealName().toString());

                    predicates.add(predicate);

                    Predicate predicate0 = criteriaBuilder.equal(root.get("creater"), user.getId().toString());

                    predicates.add(predicate0);

                    Path<String> proJoiners = root.get("proJoiners");

                    Predicate predicate1 = criteriaBuilder.like(proJoiners.as(String.class), "%," + user.getRealName().toString() + ",%");

                    predicates.add(predicate1);

                    Predicate predicate2 = criteriaBuilder.like(proJoiners.as(String.class), user.getRealName().toString() + ",%");
                    predicates.add(predicate2);
                    Predicate predicate3 = criteriaBuilder.like(proJoiners.as(String.class), "%," + user.getRealName().toString());
                    predicates.add(predicate3);

                    return criteriaBuilder.or(predicates.toArray(new Predicate[predicates.size()]));
                }
            };

            List<ProjectInfoEntity> projectInfoEntities = projectRepository.findAll(specification1);
            result.put("msg", "success");
            result.put("data", projectInfoEntities.size());
        }
        return result.toString();

    }

    @RequestMapping(value = "/LoadProjectList")
    @ResponseBody
    @ArchivesLog(operationType = "LoadProjectList", operationName = "加载项目列表")
    public String LoadProjectList(@RequestParam(value = "pageIndex", defaultValue = "0") Integer currentpage,
                                  @RequestParam(value = "pageSize", defaultValue = "10") Integer size,
                                  @RequestParam(value = "keywords", required = false) String keywords,
                                  @RequestParam(value = "conditionText", required = false) String conditionText,
                                  @RequestParam(value = "beginConditionValue", required = false) String beginConditionValue,
                                  @RequestParam(value = "endConditionValue", required = false) String endConditionValue,
                                  @RequestParam(value = "sortOrder", required = false, defaultValue = "asc") String sortOrder,
                                  @RequestParam(value = "sortName", required = false, defaultValue = "id") String sortName) {

        result = new JSONObject();
        currentpage = currentpage - 1;
        Sort sort = new Sort(sortOrder.equals("asc") ? Sort.Direction.ASC : Sort.Direction.DESC, sortName);

        Pageable pageable = new PageRequest(currentpage, size, sort);
        User user = getUser();
        try {
            if ((keywords == null || keywords.equals("")) && (conditionText == null || conditionText.equals("-1"))) {

                //if (user.getType() == 1) {
                Page projectlist = projectRepository.findAll(pageable);
                result.put("result", JSONArray.fromObject(projectlist));

            } else {

                String[] fields = projectSearchFields.split(",");
                if (!conditionText.equals("-1")) {
                    beginConditionValue = beginConditionValue.replaceAll("/", "-");
                    endConditionValue = endConditionValue.replaceAll("/", "-");
                }

                //String finalConditionValue = conditionValue;
                String finalBeginConditionValue = beginConditionValue;
                String finalEndConditionValue = endConditionValue;
                Specification<ProjectInfoEntity> specification = new Specification<ProjectInfoEntity>() {
                    @Override
                    public Predicate toPredicate(Root<ProjectInfoEntity> root, CriteriaQuery<?> criteriaQuery, CriteriaBuilder criteriaBuilder) {
                        Predicate predicateOne = null;

                        if (keywords != null && !keywords.equals("")) {
                            List<Predicate> predicates = new ArrayList<Predicate>();

                            for (int i = 0; i < fields.length; i++) {

                                Path<String> path = root.get(fields[i]);

                                Predicate predicateInner = criteriaBuilder.like(path.as(String.class), "%" + keywords + "%");

                                predicates.add(predicateInner);
                            }

                            predicateOne = criteriaBuilder.or(predicates.toArray(new Predicate[predicates.size()]));
                        }

                        //Predicate condiPredicate = null;
                        Predicate beginCondiPredicate = null;
                        Predicate endCondiPredicate = null;
                        Path<String> path = null;

                        if (conditionText.equals("createtime")) {

                            path = root.get("createPhasetime");
                            //condiPredicate = criteriaBuilder.like(path.as(String.class), "%" + finalConditionValue + "%");

                        } else if (conditionText.equals("opentime")) {
                            path = root.get("openPhasetime");

                        } else if (conditionText.equals("midtime")) {

                            path = root.get("midcheckPhasetime");

                        } else if (conditionText.equals("closetime")) {

                            path = root.get("closePhasetime");

                        } else if (conditionText.equals("endtime")) {
                            path = root.get("endPhasetime");

                        } else {
                            beginCondiPredicate = null;
                            endCondiPredicate = null;
                        }

                        if (path != null) {
                            beginCondiPredicate = criteriaBuilder.greaterThanOrEqualTo(path.as(String.class), finalBeginConditionValue);
                            endCondiPredicate = criteriaBuilder.lessThanOrEqualTo(path.as(String.class), finalEndConditionValue);
                        }
                        //if (user.getType() == 1) {

                        if (predicateOne == null) {
                            List<Predicate> p1 = new ArrayList<>();
                            p1.add(beginCondiPredicate);
                            p1.add(endCondiPredicate);

                            return criteriaBuilder.and(p1.toArray(new Predicate[p1.size()]));
                        } else {

                            if (beginCondiPredicate != null && endCondiPredicate != null) {
                                List<Predicate> p1 = new ArrayList<>();
                                p1.add(beginCondiPredicate);
                                p1.add(endCondiPredicate);
                                p1.add(predicateOne);
                                return criteriaBuilder.and(p1.toArray(new Predicate[p1.size()]));
                            } else {
                                return predicateOne;
                            }
                        }


                    }
                };

                Page<ProjectInfoEntity> projectInfoEntityList = projectRepository.findAll(specification, pageable);
                JsonConfig jsonConfig = new JsonConfig();

                jsonConfig.setCycleDetectionStrategy(CycleDetectionStrategy.LENIENT);

                JSONArray projectJson = JSONArray.fromObject(projectInfoEntityList, jsonConfig);
//                JSONArray resultArr=new JSONArray();
//                JSONObject itemObj=new JSONObject();
//                itemObj.put("number",0);
//                itemObj.put("last",true);
//                itemObj.put("numberOfElements",projectInfoEntityList.size());
//                itemObj.put("size",projectInfoEntityList.size());
//                itemObj.put("totalPages",1);
//                itemObj.put("sort",new JSONObject());
//                itemObj.put("first",true);
//                itemObj.put("totalElements",projectInfoEntityList.size());
//                JSONArray contentArr=new JSONArray();
//                itemObj.put("content",JSONArray.fromObject(projectInfoEntityList));
//                resultArr.add(itemObj);
                result.put("result", projectJson);

            }


        } catch (Exception ex) {
            ex.printStackTrace();
        }

        operationLogInfo = "用户【" + getUser().getUsername() + "】进行查询项目列表操作";
        result.put("msg", "ok");
        result.put("operationLog", operationLogInfo);

        return result.toString();
    }

    @RequestMapping(value = "DeleteMoneyByIdsAndType")
    @ResponseBody
    public String DeleteMoneyByIdsAndType(@RequestParam(value = "yids") long[] yids, @RequestParam(value = "ytype") Integer ytype, @RequestParam(value = "proid") Long proid) {
        result = new JSONObject();
        ProjectInfoEntity projectInfoEntity = projectRepository.findOne(proid);
        msg = "success";
        try {
            if (yids != null && yids.length > 0) {

                for (Long yid : yids) {

                    if (ytype == 1) {
                        receiveLogRepository.delete(yid);

                    } else {
                        cuishouLogRepository.delete(yid);
                    }
                }
                operationLogInfo = "用户删除项目【" + projectInfoEntity.getProName() + "】的已收账款记录成功";
            }
            msg = "success";

        } catch (Exception e) {
            logger.error(e.getMessage());
            msg = "error";
            operationLogInfo = "用户删除项目【" + projectInfoEntity.getProName() + "】的已收账款记录失败";
        }

        result.put("msg", msg);
        result.put("operationLog", operationLogInfo);
        return result.toString();
    }

    @RequestMapping(value = "DeleteJdByIds")
    @ResponseBody
    public String DeleteJdByIds(@RequestParam(value = "jdids") long[] jdids) {
        result = new JSONObject();
        msg = "success";
        for (Long jdid : jdids) {

//            JianDingEntity jianDingEntity=jianDingRepository.findOne(jdid);
//            if(jianDingEntity!=null){
            jianDingRepository.delete(jdid);
//            }
        }

        result.put("msg", msg);
        return result.toString();
    }

    @RequestMapping(value = "DeleteBjByIds")
    @ResponseBody
    public String DeleteBjByIds(@RequestParam(value = "bjids") long[] bjids) {
        result = new JSONObject();
        msg = "success";
        for (Long bjid : bjids) {

            baoJiangRepository.delete(bjid);

        }

        result.put("msg", msg);
        return result.toString();
    }

    @RequestMapping(value = "DeleteHjByIds")
    @ResponseBody
    public String DeleteHjByIds(@RequestParam(value = "hjids") long[] hjids) {
        result = new JSONObject();
        msg = "success";
        for (Long hjid : hjids) {

            huoJiangRepository.delete(hjid);
        }

        result.put("msg", msg);
        return result.toString();
    }
    @RequestMapping(value = "DeleteYantaoByIds")
    @ResponseBody
    public String DeleteYantaoByd(@RequestParam(value = "ytids") long[] ytids, @RequestParam(value = "proid") Long proid) {
        result = new JSONObject();
        ProjectInfoEntity projectInfoEntity = projectRepository.findOne(proid);
        msg = "success";
        try {
            if (ytids != null && ytids.length > 0) {

                for (Long yid : ytids) {

                    YantaoLogEntity yantaoLogEntity = yantaoLogRepository.findOne(yid);
                    if (yantaoLogEntity != null) {
                        if (yantaoLogEntity.getYantaoFid() != null && !yantaoLogEntity.getYantaoFid().equals("")) {

                            String[] fids = yantaoLogEntity.getYantaoFid().split(",");
                            for (String fid : fids) {

                                FileInfoEntity fileInfoEntity = fileInfoRepository.findOne(Long.parseLong(fid));
                                if (fileInfoEntity != null) {
                                    File file = new File(fileInfoEntity.getFilePath());
                                    if (file.exists()) {
                                        file.delete();
                                    }
                                    fileInfoRepository.delete(Long.parseLong(fid));

                                }
                            }
                        }

                        yantaoLogRepository.delete(yid);
                    }


                }
                operationLogInfo = "用户删除项目【" + projectInfoEntity.getProName() + "】的研讨记录成功";
            }
            msg = "success";

        } catch (Exception e) {
            logger.error(e.getMessage());
            msg = "error";
            operationLogInfo = "用户删除项目【" + projectInfoEntity.getProName() + "】的研讨记录失败";
        }

        result.put("msg", msg);
        result.put("operationLog", operationLogInfo);
        return result.toString();
    }

    @RequestMapping(value = "DeleteFilesByIds")
    @ResponseBody
    public String DeleteFilesByIds(@RequestParam(value = "fids") long[] fids, @RequestParam(value = "pid") Long pid, @RequestParam(value = "attachfid") long attachfid, @RequestParam(value = "phaseid") long phaseid) {
        result = new JSONObject();
        operationLogInfo = "用户【" + getUser().getUsername() + "】删除文件【";
        try {
            if (fids != null && fids.length > 0) {
                StringBuilder sb = new StringBuilder();
                ProjectInfoEntity projectInfoEntity = projectRepository.findOne(pid);
                for (Long fid : fids) {
                    FileInfoEntity fileInfoEntity = fileInfoRepository.findOne(fid);
                    operationLogInfo += fileInfoEntity.getFileName() + ",";
                    if (fileInfoEntity.getFileType().equals("1")) {
                        File file = new File(fileInfoEntity.getFilePath());
                        if (file.exists()) {
                            file.delete();
                        }
                    }
                    sb.append(fid);
                    sb.append(",");

                    fileInfoRepository.delete(fileInfoEntity);

                    ProjectFilesEntity projectFilesEntity = projectFilesRepository.findFirstByProjectIdAndPhaseIdAndFileTypeIdAndFileId(pid, phaseid, attachfid, fid);

                    if (projectFilesEntity != null) {
                        projectFilesRepository.delete(projectFilesEntity);
                    }
                }
                if (attachfid > 0) {
                    //SetProjectFileId(projectInfoEntity, attachfid, sb.toString().substring(0, sb.toString().length() - 1), true);

                }
            }

            msg = "success";
        } catch (Exception e) {
            logger.error(e.getMessage());
            msg = "error";
        }

        operationLogInfo = operationLogInfo.substring(0, operationLogInfo.length() - 1) + "】,操作结果【" + msg + "】";
        result.put("msg", msg);
        result.put("operationLog", operationLogInfo);
        return result.toString();
    }

    @RequestMapping(value = "DeleteProjectByIds")
    @ResponseBody
    public String DeleteProjectByIds(@RequestParam(value = "pids") long[] prids) {

        result = new JSONObject();
        operationLogInfo = "用户【" + getUser().getUsername() + "】删除项目【";
        try {
            if (prids != null && prids.length > 0) {

                for (Long pid : prids) {
                    ProjectInfoEntity projectInfoEntity = projectRepository.findOne(pid);
                    operationLogInfo += projectInfoEntity.getProName() + ",";
                    StringBuilder needToDelFids = new StringBuilder();
                    if (projectInfoEntity.getCreatephaseLxyjfid() != null && projectInfoEntity.getCreatephaseLxyjfid().length() > 0) {
                        needToDelFids.append(projectInfoEntity.getCreatephaseLxyjfid().split(","));
                        needToDelFids.append(",");
                    }

                    if (projectInfoEntity.getCreatephaseJysfid() != null && projectInfoEntity.getCreatephaseJysfid().length() > 0) {
                        needToDelFids.append(projectInfoEntity.getCreatephaseJysfid().split(","));
                        needToDelFids.append(",");
                    }

                    if (projectInfoEntity.getCreatephaseOtherfid() != null && projectInfoEntity.getCreatephaseOtherfid().length() > 0) {
                        needToDelFids.append(projectInfoEntity.getCreatephaseOtherfid().split(","));
                        needToDelFids.append(",");
                    }

                    if (projectInfoEntity.getCreatephaseRwsfid() != null && projectInfoEntity.getCreatephaseRwsfid().length() > 0) {
                        needToDelFids.append(projectInfoEntity.getCreatephaseRwsfid().split(","));
                        needToDelFids.append(",");
                    }

                    if (projectInfoEntity.getOpenphaseKtbgfid() != null && projectInfoEntity.getOpenphaseKtbgfid().length() > 0) {
                        needToDelFids.append(projectInfoEntity.getOpenphaseKtbgfid().split(","));
                        needToDelFids.append(",");
                    }

                    if (projectInfoEntity.getOpenphaseOtherfid() != null && projectInfoEntity.getOpenphaseOtherfid().length() > 0) {
                        needToDelFids.append(projectInfoEntity.getOpenphaseOtherfid().split(","));
                        needToDelFids.append(",");
                    }

                    if (projectInfoEntity.getOpenphaseRwsfid() != null && projectInfoEntity.getOpenphaseRwsfid().length() > 0) {
                        needToDelFids.append(projectInfoEntity.getOpenphaseRwsfid().split(","));
                        needToDelFids.append(",");
                    }

                    if (projectInfoEntity.getClosephaseGcfid() != null && projectInfoEntity.getClosephaseGcfid().length() > 0) {
                        needToDelFids.append(projectInfoEntity.getClosephaseGcfid().split(","));
                        needToDelFids.append(",");
                    }

                    if (projectInfoEntity.getClosephaseYjbgfid() != null && projectInfoEntity.getClosephaseYjbgfid().length() > 0) {
                        needToDelFids.append(projectInfoEntity.getClosephaseYjbgfid().split(","));
                        needToDelFids.append(",");
                    }

                    if (projectInfoEntity.getClosephaseOtherfid() != null && projectInfoEntity.getClosephaseOtherfid().length() > 0) {
                        needToDelFids.append(projectInfoEntity.getClosephaseOtherfid().split(","));
                        needToDelFids.append(",");
                    }

                    if (projectInfoEntity.getEndphaseJdzsfid() != null && projectInfoEntity.getEndphaseJdzsfid().length() > 0) {
                        needToDelFids.append(projectInfoEntity.getEndphaseJdzsfid().split(","));
                        needToDelFids.append(",");
                    }

                    if (projectInfoEntity.getEndphasePsjg() != null && projectInfoEntity.getEndphasePsjg().length() > 0) {
                        needToDelFids.append(projectInfoEntity.getEndphasePsjg().split(","));
                        needToDelFids.append(",");
                    }

                    if (projectInfoEntity.getEndphaseSbsfid() != null && projectInfoEntity.getEndphaseSbsfid().length() > 0) {
                        needToDelFids.append(projectInfoEntity.getEndphaseSbsfid().split(","));
                        needToDelFids.append(",");
                    }

                    if (projectInfoEntity.getMidphaseOtherfid() != null && projectInfoEntity.getMidphaseOtherfid().length() > 0) {
                        needToDelFids.append(projectInfoEntity.getMidphaseOtherfid().split(","));
                        needToDelFids.append(",");
                    }

                    if (projectInfoEntity.getMidphaseYjbgfid() != null && projectInfoEntity.getMidphaseYjbgfid().length() > 0) {
                        needToDelFids.append(projectInfoEntity.getMidphaseYjbgfid().split(","));
                        needToDelFids.append(",");
                    }

                    if (needToDelFids.length() > 0) {
                        fileInfoRepository.deleteByIdIsIn(needToDelFids.toString().substring(0, needToDelFids.length() - 1).split(","));
                    }

                    receiveLogRepository.deleteByProjectIdEquals(projectInfoEntity.getId().intValue());

                    cuishouLogRepository.deleteByProidEquals(projectInfoEntity.getId());

                    yantaoLogRepository.deleteByProIdEquals(projectInfoEntity.getId());

                    projectRepository.delete(projectInfoEntity);
                }
            }

            msg = "success";
        } catch (Exception e) {
            logger.error(e.getMessage());
            msg = "error";
        }

        operationLogInfo = operationLogInfo.substring(0, operationLogInfo.length() - 1) + "】,操作结果【" + msg + "】";
        result.put("msg", msg);
        result.put("operationLog", operationLogInfo);
        return result.toString();
    }

    @RequestMapping(value = "SaveProject")
    @ResponseBody
    public String SaveProject(ProjectInfoEntity projectInfoEntity) {

        result = new JSONObject();
        try {
            projectInfoEntity.setCreater(Integer.parseInt(getUser().getId().toString()));
            projectRepository.save(projectInfoEntity);
            operationLogInfo = "用户[" + getUser().getUsername() + "]新建项目成功（项目名称：" + projectInfoEntity.getProName() + ")";
            msg = "success";
        } catch (Exception ex) {
            logger.error(ex.getMessage());
            msg = "error";
        }

        result.put("operationLog", operationLogInfo);
        result.put("msg", msg);
        return JSONObject.fromObject(result).toString();
    }

    @RequestMapping(value = "LoadProjectPhases")
    @ResponseBody
    public String LoadProjectPhases() {
        result = new JSONObject();

        List<ProjectPhaseEntity> projectPhaseEntities = projectPhaseRepository.findAll();

        result.put("msg", "success");
        result.put("data", projectPhaseEntities);
        return JSONObject.fromObject(result).toString();
    }

    @RequestMapping(value = "GetFileTypeByPhaseId")
    @ResponseBody
    public String GetFileTypeByPhaseId(@RequestParam(value = "phaseId") long phaseid) {
        result = new JSONObject();

        List<PhaseFileTypeEntity> phaseFileTypeEntities = phaseFileTypeRepository.findAllByPhaseId(phaseid);

        result.put("msg", "success");
        result.put("data", phaseFileTypeEntities);
        return JSONObject.fromObject(result).toString();
    }

    @RequestMapping(value = "UpdateProject")
    @ResponseBody
    public String UpdateProject(ProjectInfoEntity projectInfoEntity) {
        result = new JSONObject();
        try {
            if (projectInfoEntity != null && projectInfoEntity.getId() > 0) {
//                if (projectInfoEntity.getProResearchcontent() != null) {
//                    projectInfoEntity.setProResearchcontent(projectInfoEntity.getProResearchcontent().trim());
//                }
//                if (projectInfoEntity.getProRemark() != null) {
//                    projectInfoEntity.setProRemark(projectInfoEntity.getProRemark().trim());
//                }
                projectInfoEntity.setCreater(Integer.parseInt(getUser().getId().toString()));
                projectRepository.save(projectInfoEntity);
                operationLogInfo = "用户[" + getUser().getUsername() + "]修改项目基本信息（项目名称：" + projectInfoEntity.getProName() + ")";
            }

            msg = "success";
        } catch (Exception ex) {
            logger.error(ex.getMessage());
            msg = "error";
        }

        result.put("operationLog", operationLogInfo);
        result.put("msg", msg);
        return JSONObject.fromObject(result).toString();
    }

    @RequestMapping(value = "GetFilesById")
    @ResponseBody
    public String GetFilesById(@RequestParam(value = "fids") Long[] fids) {
        result = new JSONObject();
        msg = "success";
        List<FileInfoEntity> fileInfoEntities = new ArrayList<>();
        try {

            fileInfoEntities = fileInfoRepository.findByIdIsIn(fids);

        } catch (Exception ex) {
            logger.error(ex.getMessage());
            msg = "error";
        }
        result.put("operationLog", operationLogInfo);
        result.put("msg", msg);
        result.put("data", JSONArray.fromObject(fileInfoEntities));
        return JSONObject.fromObject(result).toString();
    }

    @RequestMapping(value = "LoadProjectFiles")
    @ResponseBody
    public String LoadProjectFiles(@RequestParam(value = "pageIndex", defaultValue = "0") Integer currentpage,
                                   @RequestParam(value = "pageSize", defaultValue = "10") Integer size,
                                   @RequestParam(value = "proId") long proid,
                                   @RequestParam(value = "phaseId", defaultValue = "-1") long phaseId,
                                   @RequestParam(value = "attachFileId", defaultValue = "-1") long attachFileId) {
        result = new JSONObject();
        ProjectInfoEntity projectInfoEntity = projectRepository.findOne((long) proid);
        operationLogInfo = "用户【" + getUser().getUsername() + "】进行查询项目附件列表操作";
        List<FileInfoEntity> filelist = new ArrayList<>();
        int classiclevel = getUser().getPermissionLevel() == null ? 1 : getUser().getPermissionLevel();

        String targetFids = "";
        if (projectInfoEntity != null) {
            currentpage = currentpage - 1;
            Sort sort = new Sort(Sort.Direction.ASC, "id");
            Pageable pageable = new PageRequest(currentpage, size, sort);

            //projectlist = projectRepository.findAll(pageable);
            List<Long> fidList = new ArrayList();
//


            List<ProjectFilesEntity> projectFilesEntities = new ArrayList<>();
            if (phaseId != -1 && attachFileId != -1) {
                projectFilesEntities = projectFilesRepository.findAllByProjectIdAndPhaseIdAndFileTypeId(proid, phaseId, attachFileId);
            } else if (phaseId == -1) {
                projectFilesEntities = projectFilesRepository.findAllByProjectId(proid);
            } else if (attachFileId == -1) {
                projectFilesEntities = projectFilesRepository.findAllByProjectIdAndPhaseId(proid, phaseId);
            } else {

            }


            for (ProjectFilesEntity projectFilesEntity : projectFilesEntities) {
                fidList.add(projectFilesEntity.getFileId());
            }
            if (fidList == null || fidList.size() <= 0) {
                fidList.add(-1L);
            }

            Specification<FileInfoEntity> specification = new Specification<FileInfoEntity>() {
                @Override
                public Predicate toPredicate(Root<FileInfoEntity> root, CriteriaQuery<?> criteriaQuery, CriteriaBuilder criteriaBuilder) {

                    List<Predicate> predicates = new ArrayList<Predicate>();

                    Predicate predicate = criteriaBuilder.in(root.get("id")).value(fidList);


                    predicates.add(predicate);

                    Path<Integer> classicfic = root.get("classificlevelId");

                    Predicate predicate1 = criteriaBuilder.lessThanOrEqualTo(classicfic, classiclevel);

                    predicates.add(predicate1);

                    return criteriaBuilder.and(predicates.toArray(new Predicate[predicates.size()]));
                    // return criteriaBuilder.and(predicate1);
                }
            };

            filelist = fileInfoRepository.findAll(specification, pageable);

            result.put("result", JSONArray.fromObject(filelist));

        } else {
            result.put("result", JSONArray.fromObject(filelist));
        }
        result.put("msg", "ok");
        result.put("operationLog", operationLogInfo);
        return result.toString();

    }

    @RequestMapping(value = "SaveJianDing")
    @ResponseBody
    public String SaveJianDing(@RequestParam(value = "jdProid") Long proid,
                               @RequestParam(value = "jiandingTime") String jianDingTime,
                               @RequestParam(value = "zhuchiBumen") String zhuchiBumen) throws ParseException {
        result = new JSONObject();
        msg = "success";

        if (proid > 0) {
            JianDingEntity jianDingEntity = new JianDingEntity();
            jianDingEntity.setJdproid(proid);
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            jianDingEntity.setJianDingTime(sdf.parse(jianDingTime));
            jianDingEntity.setZhuchiBumen(zhuchiBumen);
            jianDingRepository.save(jianDingEntity);
        } else {
            msg = "failed";
        }
        result.put("msg", msg);

        return result.toString();
    }

    @RequestMapping(value = "SaveYiShou")
    @ResponseBody
    public String SaveYiShou(@RequestParam(value = "receiveNum") Double receiveNum,
                             @RequestParam(value = "receiveTime") String receiveTime,
                             @RequestParam(value = "proid") Integer proid,
                             @RequestParam(value = "editYishouId") Long editYishouId) {
        result = new JSONObject();
        msg = "success";
        ProjectInfoEntity projectInfoEntity = projectRepository.findOne(Long.parseLong(proid.toString()));
        try {

            if (projectInfoEntity != null) {
                SimpleDateFormat myFmt2 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                ReceivedLogEntity receivedLogEntity = new ReceivedLogEntity();

                if (editYishouId > 0) {
                    receivedLogEntity = receiveLogRepository.findOne(editYishouId);
                }
                receivedLogEntity.setCreateTime(Timestamp.valueOf(myFmt2.format(new Date())));
                receivedLogEntity.setProjectId(proid);
                receivedLogEntity.setReceivedNum(receiveNum);
                receivedLogEntity.setReceivedTime(Timestamp.valueOf(receiveTime + " 00:00:00"));
                receivedLogEntity.setUserName(getUser().getUsername());
                receiveLogRepository.save(receivedLogEntity);
                if (projectInfoEntity.getReceivedFee() != null) {
                    receiveNum = projectInfoEntity.getReceivedFee() + receiveNum;
                }

                projectInfoEntity.setReceivedFee(receiveNum);
                projectInfoEntity.setNoreceivedFee(Double.parseDouble(projectInfoEntity.getTotalFee()) - projectInfoEntity.getReceivedFee());
                projectRepository.save(projectInfoEntity);
                operationLogInfo = "用户【" + getUser().getUsername() + "】进行添加项目[" + projectInfoEntity.getProName() + "]已收账款" + receiveNum.toString() + "成功";
            }

        } catch (Exception ex) {
            operationLogInfo = "用户【" + getUser().getUsername() + "】进行添加项目[" + projectInfoEntity.getProName() + "]已收账款" + receiveNum.toString() + "失败";
            logger.error(ex.getMessage());
            msg = "failed";
        }
        result.put("msg", msg);
        result.put("operationLog", operationLogInfo);
        return result.toString();
    }

    @RequestMapping(value = "SaveYtRecored")
    @ResponseBody
    public String SaveYtRecored(YantaoLogEntity yantaoLogEntity) {
        result = new JSONObject();
        msg = "success";
        ProjectInfoEntity projectInfoEntity = projectRepository.findOne(yantaoLogEntity.getProId());
        try {

            SimpleDateFormat myFmt2 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            yantaoLogEntity.setCreateTime(Timestamp.valueOf(myFmt2.format(new Date())));
            yantaoLogRepository.save(yantaoLogEntity);

            operationLogInfo = "用户【" + getUser().getUsername() + "】进行添加项目[" + projectInfoEntity.getProName() + "]研讨记录成功";
        } catch (Exception ex) {
            msg = "failed";
            logger.error(ex.getMessage());
            operationLogInfo = "用户【" + getUser().getUsername() + "】进行添加项目[" + projectInfoEntity.getProName() + "]研讨记录失败";
        }


        result.put("msg", msg);
        result.put("operationLog", operationLogInfo);
        return result.toString();
    }

    @RequestMapping(value = "SaveCuiShou")
    @ResponseBody
    public String SaveCuiShou(@RequestParam(value = "cuishouAmount") Double cuishouAmount,
                              @RequestParam(value = "cuishouTime") String cuishouTime,
                              @RequestParam(value = "cuishouAlertDays") Integer cuishouAlertDays,
                              @RequestParam(value = "dafu") String dafu,
                              @RequestParam(value = "duijierenName") String duijierenName,
                              @RequestParam(value = "jingbanName") String jingbanName,
                              @RequestParam(value = "proid") Long proid,
                              @RequestParam(value = "editCuishouId") Long editCuishouId) {
        result = new JSONObject();
        msg = "success";
        ProjectInfoEntity projectInfoEntity = projectRepository.findOne(proid);
        try {

            if (projectInfoEntity != null) {
                SimpleDateFormat myFmt1 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                SimpleDateFormat myFmt2 = new SimpleDateFormat("yyyy-MM-dd");
                CuishouLogEntity cuishouLogEntity = new CuishouLogEntity();
                if (editCuishouId != null && editCuishouId > 0) {
                    cuishouLogEntity = cuishouLogRepository.findOne(editCuishouId);
                }
                cuishouLogEntity.setCreateTime(Timestamp.valueOf(myFmt1.format(new Date())));
                cuishouLogEntity.setProid(proid);
                cuishouLogEntity.setCuishouAmount(cuishouAmount);

                cuishouLogEntity.setCuishouTime(myFmt2.parse(cuishouTime));
                cuishouLogEntity.setCreator(getUser().getUsername());
                cuishouLogEntity.setDafu(dafu);
                cuishouLogEntity.setAlertDays(cuishouAlertDays);
                cuishouLogEntity.setDuijierenName(duijierenName);
                cuishouLogEntity.setJingbanrenId(jingbanName);
                cuishouLogEntity.setJingbanrenName(userRepository.findOne(Long.parseLong(jingbanName)).getUsername());
                cuishouLogRepository.save(cuishouLogEntity);
                operationLogInfo = "用户【" + getUser().getUsername() + "】进行添加项目[" + projectInfoEntity.getProName() + "]催收账款" + cuishouAmount.toString() + "成功";
            }

        } catch (Exception ex) {
            operationLogInfo = "用户【" + getUser().getUsername() + "】进行添加项目[" + projectInfoEntity.getProName() + "]催收账款" + cuishouAmount.toString() + "失败";
            logger.error(ex.getMessage());
            msg = "failed";
        }
        result.put("msg", msg);
        result.put("operationLog", operationLogInfo);
        return result.toString();
    }

    @RequestMapping(value = "UpdateFilesClassId")
    @ResponseBody
    public String UpdateFilesClassId(@RequestParam(value = "fids") String fids, @RequestParam(value = "classid") Integer classid) {
        result = new JSONObject();

        String[] fidArr = fids.split(",");

        for (int i = 0; i < fidArr.length; i++) {

            FileInfoEntity fileInfoEntity = fileInfoRepository.findOne(Long.parseLong(fidArr[i]));
            if (fileInfoEntity != null) {
                fileInfoEntity.setClassificlevelId(classid);
                fileInfoRepository.save(fileInfoEntity);
            }
        }

        result.put("msg", "success");

        return result.toString();

    }

    @RequestMapping(value = "UploadPaper")
    @ResponseBody
    public String UploadPaper(@RequestParam(value = "paperFileName") String paperFileName,
                              @RequestParam(value = "zrr") String zrrName,
                              @RequestParam(value = "paperClassicId") Integer cid,
                              @RequestParam(value = "paperproid") Long proid,
                              @RequestParam(value = "attachid") Long attachid,
                              @RequestParam(value = "phaseid") Long phaseid,
                              @RequestParam(value = "editFileId", required = false) Long editFileId) {
        result = new JSONObject();
        operationLogInfo = "用户【" + getUser().getUsername() + "】进行添加纸质文件操作";
        ProjectInfoEntity projectInfoEntity = projectRepository.findOne(proid);
        msg = "success";
        try {
            if (projectInfoEntity != null) {
                SimpleDateFormat myFmt2 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                FileInfoEntity fileInfoEntity = new FileInfoEntity();
                if (editFileId > 0) {
                    fileInfoEntity = fileInfoRepository.findOne(editFileId);

                } else {
                    fileInfoEntity.setCreator(getUser().getUsername());
                    fileInfoEntity.setFileType("2");

                }
                fileInfoEntity.setCreateTime(myFmt2.format(new Date()));
                fileInfoEntity.setClassificlevelId(cid);
                fileInfoEntity.setZrr(zrrName);
                fileInfoEntity.setFileName(paperFileName);
                FileInfoEntity addedFile = fileInfoRepository.save(fileInfoEntity);
                if (editFileId <= 0) {
                    //SetProjectFileId(projectInfoEntity, attachid, ((Long) addedFile.getId()).toString(), false);
                    //projectRepository.save(projectInfoEntity);
                    ProjectFilesEntity projectFilesEntity = new ProjectFilesEntity();
                    projectFilesEntity.setProjectId(proid);
                    projectFilesEntity.setPhaseId(phaseid);
                    projectFilesEntity.setFileTypeId(attachid);
                    projectFilesEntity.setFileId(addedFile.getId());
                    projectFilesRepository.save(projectFilesEntity);
                } else {
                    // ProjectFilesEntity projectFilesEntity=projectFilesRepository.findFirstByProjectIdAndPhaseIdAndFileTypeId(proid,phaseid,attachid);


                }
            }
        } catch (Exception ex) {
            msg = "failed";
            operationLogInfo = "用户【" + getUser().getUsername() + "】进行添加纸质文件操作发生异常";
        }


        result.put("msg", msg);
        result.put("operationLog", operationLogInfo);
        return result.toString();
    }

    @RequestMapping(value = "UpLoadYtFiles")
    @ResponseBody
    public synchronized String UpLoadYtFiles(@RequestParam(value = "ytfile") MultipartFile[] ytfile, @RequestParam(value = "pid") long pid) throws IOException {

        result = new JSONObject();
        ProjectInfoEntity projectInfoEntity = projectRepository.findOne(pid);
        String savFilePath = "";
        String fileExt;
        String filename = "";
        StringBuilder addedFids = new StringBuilder();
        long filesize = 0;
        try {
            for (int i = 0; i < ytfile.length; i++) {
                savFilePath = "/static/yt/" + pid + "/";
                filename = ytfile[i].getOriginalFilename();
                filesize = ytfile[i].getSize();
                fileExt = filename.substring(filename.lastIndexOf('.'), filename.length());

                FileInfoEntity fileInfoEntity = new FileInfoEntity();
                fileInfoEntity.setFileCode(CreateUUID());
                fileInfoEntity.setFileName(filename);
                fileInfoEntity.setClassificlevelId(ExtractClassificLevel(filename));
                savFilePath += fileInfoEntity.getFileCode() + fileExt;
                fileInfoEntity.setFilePath(savFilePath);
                fileInfoEntity.setFileSize(filesize);
                fileInfoEntity.setFileType("1");
                fileInfoEntity.setCreator(getUser().getUsername());

                File file = new File(projectFilePath + savFilePath);
                if (!file.getParentFile().exists()) {
                    file.getParentFile().mkdirs();

                }
                if (!file.exists()) {
                    file.createNewFile();
                }

                ytfile[i].transferTo(file);

                FileInfoEntity addedFile = fileInfoRepository.save(fileInfoEntity);
                addedFids.append(addedFile.getId());

                operationLogInfo = "用户[" + getUser().getUsername() + "]上传项目【" + projectInfoEntity.getProName() + "】研讨记录附件成功";

            }
        } catch (Exception e) {
            operationLogInfo = "用户[" + getUser().getUsername() + "]上传项目【" + projectInfoEntity.getProName() + "】研讨记录附件失败";
            e.printStackTrace();
            msg = "failed";

        }

        msg = "success";
        result.put("success", msg);
        result.put("ytfileid", addedFids.toString());
        result.put("ytfilename", filename);
        result.put("ytfilepath", savFilePath);
        return result.toString();
    }

    @RequestMapping(value = "ImportProjectFiles")
    @ResponseBody
    public synchronized String ImportProjectFiles(@RequestParam(value = "importProjFile") MultipartFile[] projectFile) {
        result = new JSONObject();
        StringBuilder resultBuilder = new StringBuilder();
        try {
            List<String[]> projectDatas = ExcelUtil.excel2List(projectFile[0]);

            //0序号//1研究方向//2项目编号//3项目名称//4项目承研单位//5主管部门//6参研单位//7项目负责人//8研究内容//9项目渠道//10总经费//11研究周期//12备注

            Iterable<User> users = userRepository.findAll();

            String successImport = "导入成功%d条;";

            String failImport = "导入失败%d条;";

            StringBuilder failMsgBuilder = new StringBuilder();

            int successCount = 0, failCount = 0;


            for (int i = 0; i < projectDatas.size(); i++) {
                if (projectDatas.get(i)[0] != null && projectDatas.get(i)[2] != null && !projectDatas.get(i)[2].equals("") && !projectDatas.get(i)[3].equals("")) {
                    int finalI = i;
                    Specification<ProjectInfoEntity> specification = new Specification<ProjectInfoEntity>() {
                        @Override
                        public Predicate toPredicate(Root<ProjectInfoEntity> root, CriteriaQuery<?> criteriaQuery, CriteriaBuilder criteriaBuilder) {

                            List<Predicate> predicates = new ArrayList<Predicate>();


                            Path<String> proNo = root.get("proNo");

                            Predicate predicate1 = criteriaBuilder.equal(proNo, projectDatas.get(finalI)[2]);

                            predicates.add(predicate1);

                            Path<String> proName = root.get("proName");
                            Predicate predicate2 = criteriaBuilder.equal(proName, projectDatas.get(finalI)[3]);
                            predicates.add(predicate2);

                            return criteriaBuilder.or(predicates.toArray(new Predicate[predicates.size()]));
                        }
                    };

                    List<ProjectInfoEntity> projectInfoEntities = projectRepository.findAll(specification);
                    if (projectInfoEntities != null && projectInfoEntities.size() > 0) {
                        failCount++;
                        failMsgBuilder.append("序号" + projectDatas.get(i)[0] + " 项目编号：[" + projectDatas.get(i)[2] + "] 或 项目名称：[" + projectDatas.get(i)[3] + "] 已存在;");
                        failMsgBuilder.append("<br>");

                    } else {
                        ProjectInfoEntity projectInfoEntity = new ProjectInfoEntity();
                        projectInfoEntity.setYanjiuFangXiang(projectDatas.get(i)[1]);
                        projectInfoEntity.setProNo(projectDatas.get(i)[2]);
                        projectInfoEntity.setProName(projectDatas.get(i)[3]);
                        String zhuYanDanwei = projectDatas.get(i)[4];
                        projectInfoEntity.setMainDepartment(projectDatas.get(i)[5]);
                        String canYanDanwei = projectDatas.get(i)[6];

                        for (User user : users) {
                            if (user.getRealName().equals(projectDatas.get(i)[7])) {
                                projectInfoEntity.setProLeaders(projectDatas.get(i)[7]);
                                break;
                            }
                        }
                        projectInfoEntity.setProResearchcontent(projectDatas.get(i)[8]);
                        projectInfoEntity.setProFrom(projectDatas.get(i)[9]);
                        //projectInfoEntity.setTotalFee(Double.parseDouble(projectDatas.get(i)[10]));
                        projectInfoEntity.setTotalFee(projectDatas.get(i)[10]);
                        projectInfoEntity.setYanjiuZhouQi(Double.parseDouble(projectDatas.get(i)[11]));
                        projectInfoEntity.setProRemark(projectDatas.get(i)[12]);

                        ProjectInfoEntity addProject = projectRepository.save(projectInfoEntity);
                        ChengYanDanWeiEntity chengYanDanWeiEntity = new ChengYanDanWeiEntity();
                        chengYanDanWeiEntity.setDanweiName(zhuYanDanwei);
                        //1 主//2联合 //3外协
                        chengYanDanWeiEntity.setType(1);
                        chengYanDanWeiEntity.setProid(addProject.getId());
                        chengYanDanWeiRepository.save(chengYanDanWeiEntity);

                        if (canYanDanwei != null && !canYanDanwei.equals("")) {
                            String[] danweis = canYanDanwei.split("，");

                            for (int m = 0; m < danweis.length; m++) {
                                ChengYanDanWeiEntity chengYanDanWeiEntity1 = new ChengYanDanWeiEntity();
                                chengYanDanWeiEntity1.setDanweiName(danweis[m]);
                                chengYanDanWeiEntity1.setType(2);
                                chengYanDanWeiEntity1.setProid(addProject.getId());
                                chengYanDanWeiRepository.save(chengYanDanWeiEntity1);
                            }
                        }

                        successCount++;
                    }

                } else {
                    if (projectDatas.get(i)[0] != null && Integer.parseInt(projectDatas.get(i)[0]) > 0) {
                        failCount++;
                        failMsgBuilder.append("序号" + projectDatas.get(i)[0] + " 项目编号或项目名称为空;");
                        failMsgBuilder.append("<br>");
                    }
                }
            }


            resultBuilder.append(String.format(successImport, successCount));
            resultBuilder.append("<br>");
            resultBuilder.append(String.format(failImport, failCount));
            resultBuilder.append("<br>");
            if (failCount > 0) {
                resultBuilder.append("错误信息如下：");
                resultBuilder.append("<br>");
                resultBuilder.append(failMsgBuilder.toString());

            }

        } catch (Exception ex) {

            String errorMsg = ex.getMessage();
            ex.printStackTrace();
        }

        result.put("msg", resultBuilder.toString());
        result.put("success", "success");
        return result.toString();
    }

    @RequestMapping(value = "UpLoadProjectFiles")
    @ResponseBody
    public synchronized String UpLoadProjectFiles(@RequestParam(value = "projectfile") MultipartFile[] projectfiles,
                                                  @RequestParam(value = "attachid") String attachid,
                                                  @RequestParam(value = "phaseid") String phaseid,
                                                  @RequestParam(value = "pid") long pid) throws IOException {

        result = new JSONObject();
        ProjectInfoEntity projectInfoEntity = projectRepository.findOne(pid);
        StringBuilder addedFids = new StringBuilder();
        if (projectfiles != null && projectfiles.length > 0) {
            String savFilePath;
            String fileExt;
            String filename;
            SimpleDateFormat myFmt2 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            long filesize = 0;
            try {
                for (int i = 0; i < projectfiles.length; i++) {
                    savFilePath = "/" + pid + "/1/";
                    filename = projectfiles[i].getOriginalFilename();
                    filesize = projectfiles[i].getSize();
                    fileExt = filename.substring(filename.lastIndexOf('.'), filename.length());

                    FileInfoEntity fileInfoEntity = new FileInfoEntity();
                    fileInfoEntity.setFileCode(CreateUUID());
                    fileInfoEntity.setFileName(filename);
                    fileInfoEntity.setClassificlevelId(ExtractClassificLevel(filename));
                    savFilePath += fileInfoEntity.getFileCode() + fileExt;
                    fileInfoEntity.setFilePath(savFilePath);
                    fileInfoEntity.setFileSize(filesize);
                    fileInfoEntity.setFileType("1");
                    fileInfoEntity.setCreator(getUser().getUsername());
                    fileInfoEntity.setCreateTime(myFmt2.format(new Date()));
                    fileInfoEntity.setAudit(0);
                    fileInfoEntity.setFileClassify(1);

                    File file = new File(projectFilePath + savFilePath);
                    if (!file.getParentFile().exists()) {
                        file.getParentFile().mkdirs();

                    }
                    if (!file.exists()) {
                        file.createNewFile();
                    }

                    projectfiles[i].transferTo(file);

                    FileInfoEntity addedFile = fileInfoRepository.save(fileInfoEntity);

                    ModuleFileEntity moduleFileEntity=new ModuleFileEntity();
                    moduleFileEntity.setCreateTime(new Timestamp(System.currentTimeMillis()));
                    moduleFileEntity.setCreator(getUser().getUsername());
                    moduleFileEntity.setFileCode(addedFile.getFileCode());
                    moduleFileEntity.setT_id(pid);
                    moduleFileEntity.setType("PJ");
                    moduleFileEntity.setUserId(getUser().getId());
                    moduleFileRespository.save(moduleFileEntity);

                    addedFids.append(addedFile.getId());
                    addedFids.append(",");
                    ProjectFilesEntity projectFilesEntity = new ProjectFilesEntity();
                    projectFilesEntity.setFileId(addedFile.getId());
                    projectFilesEntity.setPhaseId(Long.parseLong(phaseid));
                    projectFilesEntity.setFileTypeId(Long.parseLong(attachid));
                    projectFilesEntity.setProjectId(pid);
                    projectFilesRepository.save(projectFilesEntity);
                }
                //SetProjectFileId(projectInfoEntity, attachid, addedFids.toString(), false);

                projectRepository.save(projectInfoEntity);

                operationLogInfo = "用户[" + getUser().getUsername() + "]上传项目【" + projectInfoEntity.getProName() + "】" + fileIdToNameMap.get(attachid) + "成功";

            } catch (Exception e) {
                operationLogInfo = "用户[" + getUser().getUsername() + "]上传项目【" + projectInfoEntity.getProName() + "】" + fileIdToNameMap.get(attachid) + "失败";
                e.printStackTrace();
                msg = "failed";
            }
        }

        msg = "success";
        result.put("success", msg);
        if (addedFids.length() > 0) {
            result.put("fid", addedFids.substring(0, addedFids.length() - 1));
        } else {
            result.put("fid", "0");
        }

        return result.toString();
    }

    private synchronized String CreateUUID() {
        return UUID.randomUUID().toString();
    }

    private int ExtractClassificLevel(String filename) {
        if (filename.contains("公开")) {
            return 1;
        } else if (filename.contains("内部")) {
            return 2;
        } else if (filename.contains("秘密")) {
            return 3;
        } else if (filename.contains("机密")) {
            return 4;
        } else {
            return 1;
        }
    }

    private String FilterFids(String str1, String fids) {
        List<String> lst1 = Arrays.asList(str1.split(","));
        List<String> lst2 = Arrays.asList(fids.split(","));

        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < lst1.size(); i++) {
            if (!lst2.contains(lst1.get(i)) && lst1.get(i) != null && !lst1.get(i).equals("null") && lst1.get(i).length() > 0) {
                sb.append(lst1.get(i));
                sb.append(",");
            }
        }
        if (sb.length() > 0) {
            return sb.toString().substring(0, sb.toString().length() - 1);
        } else {
            return "";
        }
    }

    private void SetProjectFileId(ProjectInfoEntity projectInfoEntity, String attachid, String fids, boolean isdelete) {
        switch (attachid) {
            case "1_1":
                if (isdelete) {
                    projectInfoEntity.setCreatephaseLxyjfid(FilterFids(projectInfoEntity.getCreatephaseLxyjfid(), fids));
                } else {
                    fids = projectInfoEntity.getCreatephaseLxyjfid() != null ? projectInfoEntity.getCreatephaseLxyjfid() + "," + fids : fids;

                    projectInfoEntity.setCreatephaseLxyjfid(fids);
                }
                break;
            case "1_2":
                if (isdelete) {
                    projectInfoEntity.setCreatephaseJysfid(FilterFids(projectInfoEntity.getCreatephaseJysfid(), fids));

                } else {
                    projectInfoEntity.setCreatephaseJysfid(projectInfoEntity.getCreatephaseJysfid() != null ? projectInfoEntity.getCreatephaseJysfid() + "," + fids : fids);
                }
                break;
            case "1_3":
                if (isdelete) {
                    projectInfoEntity.setCreatephaseRwsfid(FilterFids(projectInfoEntity.getCreatephaseRwsfid(), fids));
                } else {
                    projectInfoEntity.setCreatephaseRwsfid(projectInfoEntity.getCreatephaseRwsfid() != null ? projectInfoEntity.getCreatephaseRwsfid() + "," + fids : fids);
                }
                break;
            case "1_4":
                if (isdelete) {
                    projectInfoEntity.setCreatephaseOtherfid(FilterFids(projectInfoEntity.getCreatephaseOtherfid(), fids));

                } else {
                    projectInfoEntity.setCreatephaseOtherfid(projectInfoEntity.getCreatephaseOtherfid() != null ? projectInfoEntity.getCreatephaseOtherfid() + "," + fids : fids);
                }
                break;
            case "2_1":
                if (isdelete) {
                    projectInfoEntity.setOpenphaseRwsfid(FilterFids(projectInfoEntity.getOpenphaseRwsfid(), fids));
                } else {
                    projectInfoEntity.setOpenphaseRwsfid(projectInfoEntity.getOpenphaseRwsfid() != null ? projectInfoEntity.getOpenphaseRwsfid() + "," + fids : fids);
                }
                break;
            case "2_2":
                if (isdelete) {
                    projectInfoEntity.setOpenphaseKtbgfid(FilterFids(projectInfoEntity.getOpenphaseKtbgfid(), fids));
                } else {
                    projectInfoEntity.setOpenphaseKtbgfid(projectInfoEntity.getOpenphaseKtbgfid() != null ? projectInfoEntity.getOpenphaseKtbgfid() + "," + fids : fids);
                }
                break;
            case "2_3":
                if (isdelete) {
                    projectInfoEntity.setOpenphaseOtherfid(FilterFids(projectInfoEntity.getOpenphaseOtherfid(), fids));

                } else {
                    projectInfoEntity.setOpenphaseOtherfid(projectInfoEntity.getOpenphaseOtherfid() != null ? projectInfoEntity.getOpenphaseOtherfid() + "," + fids : fids);
                }
                break;
            case "3_1":
                if (isdelete) {
                    projectInfoEntity.setMidphaseYjbgfid(FilterFids(projectInfoEntity.getMidphaseYjbgfid(), fids));
                } else {
                    projectInfoEntity.setMidphaseYjbgfid(projectInfoEntity.getMidphaseYjbgfid() != null ? projectInfoEntity.getMidphaseYjbgfid() + "," + fids : fids);
                }
                break;
            case "3_2":
                if (isdelete) {
                    projectInfoEntity.setMidphaseOtherfid(FilterFids(projectInfoEntity.getMidphaseOtherfid(), fids));
                } else {
                    projectInfoEntity.setMidphaseOtherfid(projectInfoEntity.getMidphaseOtherfid() != null ? projectInfoEntity.getMidphaseOtherfid() + "," + fids : fids);
                }
                break;
            case "4_1":
                if (isdelete) {
                    projectInfoEntity.setClosephaseYjbgfid(FilterFids(projectInfoEntity.getClosephaseYjbgfid(), fids));

                } else {
                    projectInfoEntity.setClosephaseYjbgfid(projectInfoEntity.getClosephaseYjbgfid() != null ? projectInfoEntity.getClosephaseYjbgfid() + "," + fids : fids);
                }
                break;
            case "4_2":
                if (isdelete) {
                    projectInfoEntity.setClosephaseGcfid(FilterFids(projectInfoEntity.getClosephaseGcfid(), fids));

                } else {
                    projectInfoEntity.setClosephaseGcfid(projectInfoEntity.getClosephaseGcfid() != null ? projectInfoEntity.getClosephaseGcfid() + "," + fids : fids);
                }
                break;
            case "4_3":
                if (isdelete) {
                    projectInfoEntity.setClosephaseOtherfid(FilterFids(projectInfoEntity.getClosephaseOtherfid(), fids));

                } else {
                    projectInfoEntity.setClosephaseOtherfid(projectInfoEntity.getClosephaseOtherfid() != null ? projectInfoEntity.getClosephaseOtherfid() + "," + fids : fids);
                }
                break;
            case "5_1":
                if (isdelete) {
                    projectInfoEntity.setEndphaseJdzsfid(FilterFids(projectInfoEntity.getEndphaseJdzsfid(), fids));

                } else {
                    projectInfoEntity.setEndphaseJdzsfid(projectInfoEntity.getEndphaseJdzsfid() != null ? projectInfoEntity.getEndphaseJdzsfid() + "," + fids : fids);
                }
                break;
            case "5_2":
                if (isdelete) {
                    projectInfoEntity.setEndphaseSbsfid(FilterFids(projectInfoEntity.getEndphaseSbsfid(), fids));

                } else {
                    projectInfoEntity.setEndphaseSbsfid(projectInfoEntity.getEndphaseSbsfid() != null ? projectInfoEntity.getEndphaseSbsfid() + "," + fids : fids);
                }
                break;
            case "5_3":
                if (isdelete) {
                    projectInfoEntity.setEndphasePsjg(FilterFids(projectInfoEntity.getEndphasePsjg(), fids));

                } else {
                    projectInfoEntity.setEndphasePsjg(projectInfoEntity.getEndphasePsjg() != null ? projectInfoEntity.getEndphasePsjg() + "," + fids : fids);
                }
                break;
            default:
                break;

        }
    }

    protected User getUser() {
        Subject subject = SecurityUtils.getSubject();
        return (User) subject.getPrincipal();
    }
}