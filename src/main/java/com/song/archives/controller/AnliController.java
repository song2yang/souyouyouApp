package com.song.archives.controller;

import com.song.archives.aspect.ArchivesLog;
import com.song.archives.dao.AnliRepository;
import com.song.archives.dao.ModuleFileRespository;
import com.song.archives.model.AnliInfoEntity;
import com.song.archives.model.ModuleFileEntity;
import com.song.archives.model.User;
import com.song.archives.model.ZiliaoInfoEntity;
import com.song.archives.utils.DateUtil;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.json.JsonConfig;
import net.sf.json.util.CycleDetectionStrategy;
import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.subject.Subject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.persistence.criteria.Predicate;
import javax.transaction.Transactional;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 * Created by souyouyou on 2018/3/12.
 */

@Controller
@RequestMapping("/")
public class AnliController {

    Logger logger = Logger.getLogger(AnliController.class);

    public static String SUCCESS = "success";

    private String msg = "failed";

    private String operationLogInfo = "";

    private JSONObject result;

    @Autowired
    private AnliRepository anliRepository;

    @Autowired
    private ModuleFileRespository moduleFileRespository;

    /**
     * 创建案例信息
     *
     * @param entity
     * @param mids
     * @return
     */
    @ArchivesLog(operationType = "createAnli", operationName = "创建案例信息")
    @RequestMapping(value = "/createAnli")
    @ResponseBody
    @Transactional
    public String createAnli(AnliInfoEntity entity,
                             @RequestParam(value = "mids[]", required = false) List<Long> mids,
                             @RequestParam(value = "type", required = false) String type) {

        result = new JSONObject();

        try {

            if (null != entity.getId()) {
                moduleFileRespository.updateTidByIdAndType(entity.getId(), type);
            }

            AnliInfoEntity anliInfoEntity = anliRepository.save(entity);


            if (null != mids && mids.size() > 0) {
                for (Long mid : mids) {
                    ModuleFileEntity fileEntity = moduleFileRespository.findOne(mid);
                    fileEntity.setT_id(anliInfoEntity.getId());
                    moduleFileRespository.save(fileEntity);
                }

            }


            if (entity != null) {
                entity.setCreator(getUser().getRealName());
                entity.setCreateTime(DateUtil.parseDateToStr(new Date(), DateUtil.DATE_TIME_FORMAT_YYYY_MM_DD_HH_MI_SS));

                String content = entity.getContent();

                if (StringUtils.isNotEmpty(content) && StringUtils.isNotBlank(content)) {
                    entity.setContent(content.replace("\n", ""));
                }

            }

            operationLogInfo = "用户【" + getUser().getUsername() + "】执行创建案例操作,操作结果 【" + msg + "】";

            result.put("operationLog", operationLogInfo);

            anliRepository.save(entity);
            msg = SUCCESS;

        } catch (Exception e) {
            logger.error("创建资料信息:" + e.getMessage());
            msg = "Exception";
        }

        result.put("msg", msg);


        return result.toString();

    }

    /**
     * 新建案例页面
     *
     * @return
     */
    @ArchivesLog(operationType = "createAnliPage", operationName = "新建案例页面")
    @RequestMapping(value = "/createAnliPage")
    public ModelAndView createAnliPage(@RequestParam(value = "aid", required = false) Long aid) {

        AnliInfoEntity anliInfoEntity;

        if (null == aid) {
            anliInfoEntity = new AnliInfoEntity();

        } else {
            anliInfoEntity = anliRepository.findOne(aid);
        }

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.setViewName("anli/createAnli");
        modelAndView.addObject("info", anliInfoEntity);
        modelAndView.addObject("proentity", anliInfoEntity);
        modelAndView.addObject("mid", 3);
        return modelAndView;
    }

    /**
     * 资料列表
     *
     * @return
     */
    @ArchivesLog(operationType = "anliList", operationName = "案例列表")
    @RequestMapping(value = "/anliList")
    ModelAndView anliList(@RequestParam(value = "typeId", required = false) Integer typeId) {
        ModelAndView modelAndView = new ModelAndView();
        modelAndView.setViewName("anli/list");
        ZiliaoInfoEntity ziliaoInfoEntity = new ZiliaoInfoEntity();
        ziliaoInfoEntity.setTypeId(typeId);
        modelAndView.addObject(ziliaoInfoEntity);


        return modelAndView;
    }

    /**
     * 删除案例
     * @param ids
     * @return
     */
    @ArchivesLog(operationType = "delAnli", operationName = "删除案例")
    @RequestMapping(value = "/delAnli")
    @ResponseBody
    String delAnli(Long[] ids) {
        operationLogInfo = "用户【" + getUser().getUsername() + "】删除案例【";

        try{

            if (null != ids && ids.length >0){
                for (Long id:ids){
                    AnliInfoEntity entity = anliRepository.findOne(id);
                    operationLogInfo += entity.getTitle() + ",";
                    anliRepository.delete(entity);

                }
            }
            msg = SUCCESS;

        }catch (Exception e){
            logger.error(e.getMessage());
            msg = "delete anli failed";

        }


        operationLogInfo = operationLogInfo.substring(0, operationLogInfo.length() - 1) + "】,操作结果【" + msg + "】";
        result.put("msg", msg);
        result.put("operationLog", operationLogInfo);
        return result.toString();
    }


    /**
     * 查询资料列表数据
     *
     * @param page
     * @param size
     * @param searchValue
     * @return
     */
    @ArchivesLog(operationType = "anlis", operationName = "查询案例列表")
    @RequestMapping(value = "/anlis")
    @ResponseBody
    String anlis(@RequestParam(value = "pageIndex", defaultValue = "0") Integer page,
                 @RequestParam(value = "pageSize", defaultValue = "10") Integer size,
                 @RequestParam(value = "searchValue", required = false) String searchValue,
                 @RequestParam(value = "typeId", required = false) Long typeId,
                 @RequestParam(value = "sortOrder", required = false, defaultValue = "asc") String sortOrder,
                 @RequestParam(value = "sortName", required = false, defaultValue = "id") String sortName) {


        result = new JSONObject();
        page = page - 1;
        Sort sort = new Sort(sortOrder.equals("asc") ? Sort.Direction.ASC : Sort.Direction.DESC, sortName);
        Pageable pageable = new PageRequest(page, size, sort);

        Specification<AnliInfoEntity> specification = (root, criteriaQuery, criteriaBuilder) -> {

            List<Predicate> predicates = new ArrayList<>();

            if (null == typeId && StringUtils.isEmpty(searchValue)) {
                return criteriaBuilder.and(predicates.toArray(new Predicate[predicates.size()]));
            }

            List<Predicate> predicatesWhereArr = new ArrayList<>();

            if (null != typeId) {
                predicatesWhereArr.add(criteriaBuilder.equal(root.get("typeId"), typeId));
            }

            Predicate whereEquals = criteriaBuilder.or(predicatesWhereArr.toArray(new Predicate[predicatesWhereArr.size()]));


            if (StringUtils.isNotEmpty(searchValue)) {
                predicates.add(criteriaBuilder.like(root.get("title"), "%" + searchValue + "%"));
                predicates.add(criteriaBuilder.like(root.get("content"), "%" + searchValue + "%"));
                predicates.add(criteriaBuilder.like(root.get("creator"), "%" + searchValue + "%"));
                predicates.add(criteriaBuilder.like(root.get("createTime"), "%" + searchValue + "%"));
            }

            Predicate whereLike = criteriaBuilder.or(predicates.toArray(new Predicate[predicates.size()]));

            List<Predicate> predicateArr = new ArrayList<>();
            if (predicatesWhereArr.size() > 0){
                predicateArr.add(whereEquals);
            }
            if (predicates.size() > 0){
                predicateArr.add(whereLike);
            }


            return criteriaQuery.where(predicateArr.toArray(new Predicate[predicateArr.size()])).getRestriction();
        };

        Page<AnliInfoEntity> datas = null;
        try {
            datas = anliRepository.findAll(specification, pageable);
            msg = SUCCESS;
        } catch (Exception e) {
            logger.error("案例列表数据:" + e.getMessage());
            msg = "Exception";
        }


        JsonConfig jsonConfig = new JsonConfig();

        jsonConfig.setCycleDetectionStrategy(CycleDetectionStrategy.LENIENT);

        JSONArray json = JSONArray.fromObject(datas, jsonConfig);

        operationLogInfo = "用户【" + getUser().getUsername() + "】执行查询案例列表操作";
        result.put("msg", msg);
        result.put("operationLog", operationLogInfo);
        result.put("result", json);
        return result.toString();
    }


    protected User getUser() {
        Subject subject = SecurityUtils.getSubject();
        return (User) subject.getPrincipal();
    }
}
