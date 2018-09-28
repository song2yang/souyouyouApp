package com.song.archives.controller;

import com.song.archives.aspect.ArchivesLog;
import com.song.archives.dao.MsgGroupRepository;
import com.song.archives.dao.MsgRepository;
import com.song.archives.dao.UserRepository;
import com.song.archives.model.*;
import com.song.archives.utils.DateUtil;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.json.JsonConfig;
import net.sf.json.util.CycleDetectionStrategy;
import org.apache.commons.lang.StringUtils;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.subject.Subject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
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
import java.util.ArrayList;
import java.util.Date;
import java.util.List;


/**
 * Created by souyouyou on 2018/8/31.
 */
@Controller
@RequestMapping(value = "/")
public class MsgController {

    private final Logger logger = LoggerFactory.getLogger(MsgController.class);

    private JSONObject result;

    private String msg = "failed";

    private String operationLogInfo = "";


    @Autowired
    private MsgRepository msgRepository;

    @Autowired
    private MsgGroupRepository msgGroupRepository;

    @Autowired
    private UserRepository userRepository;


    @ArchivesLog(operationType = "msgGroupList" , operationName = "发件页面")
    @RequestMapping("msgGroupList")
    public ModelAndView newMessage(){

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.setViewName("message/list");

        Specification<User> specification = (root, criteriaQuery, criteriaBuilder) -> {

            List<Predicate> predicates = new ArrayList<>();

            //屏蔽超级管理员
            predicates.add(criteriaBuilder.notEqual(root.get("username"), "superadmin"));
            predicates.add(criteriaBuilder.notEqual(root.get("username"), "administrator"));
            predicates.add(criteriaBuilder.notEqual(root.get("username"), "comptroller"));
            predicates.add(criteriaBuilder.notEqual(root.get("username"), "securitor"));
            predicates.add(criteriaBuilder.notEqual(root.get("username"), getUser().getUsername()));

            return criteriaBuilder.and(predicates.toArray(new Predicate[predicates.size()]));
        };


        List<User> users = userRepository.findAll(specification);


        modelAndView.addObject("users",users);

        return modelAndView;
    }


    @RequestMapping("msgDetail")
    public ModelAndView msgDetail(@RequestParam(value = "msgGroupId") Long msgGroupId){

        ModelAndView mav = new ModelAndView("message/msgDetail");
        MsgGroupEntity msgGroupEntity = msgGroupRepository.findOne(msgGroupId);

        mav.addObject("msgGroup",msgGroupEntity);

        return mav;

    }


    @RequestMapping("newMsg")
    @ResponseBody
    public String newMsg(@RequestParam(value = "msgGroupId") Long msgGroupId,
                         @RequestParam(value = "msgContent") String msgContent){

        result = new JSONObject();

        try {
            MsgInfoEntity entity = new MsgInfoEntity();
            entity.setContent(msgContent);
            entity.setSendTime(DateUtil.parseDateToStr(new Date(),DateUtil.DATE_TIME_FORMAT_YYYY_MM_DD_HH_MI_SS));
            entity.setUserId(getUser().getId());
            entity.setGroupId(msgGroupId);
            entity.setUserName(getUser().getRealName());


            msgRepository.save(entity);
            msg = "success";
        }catch (Exception e){
            msg = "Exception";
            logger.error(e.getMessage());
        }


        result.put("msg",msg);

        return result.toString();
    }


    @RequestMapping("getMessage")
    @ResponseBody
    public String getMsg(@RequestParam(value = "msgGroupId") Long msgGroupId){

        result = new JSONObject();

        try{
            List<MsgInfoEntity> msgInfoEntities = msgRepository.findByGroupId(msgGroupId);
            result.put("data",msgInfoEntities);
            msg = "success";
        }catch (Exception e){
            msg = "Exception";
            logger.error(e.getMessage());
        }

        result.put("msg",msg);
        result.put("userId",getUser().getId());
        return result.toString();
    }



    @RequestMapping("createGroup")
    @ResponseBody
    public String createGroup(@RequestParam(value = "uId") Long[] uids,
                                @RequestParam(value = "groupName") String groupName){

        result = new JSONObject();

        String groupUers = "";
        String groupIds = "";


        if (null != uids && uids.length > 0){
            for (Long uid:uids){
                User user = userRepository.findOne(uid);
                groupUers += user.getRealName()+",";
                groupIds += "["+user.getId()+"],";
            }
        }

        groupUers = groupUers.substring(0,groupUers.length()-1);
        groupIds = groupIds.substring(0,groupIds.length()-1);
        groupUers = groupUers+","+getUser().getRealName();
        groupIds = groupIds+",["+getUser().getId()+"]";

        MsgGroupEntity msgGroup = new MsgGroupEntity();
        msgGroup.setGroupName(groupName);
        msgGroup.setGroupUsers(groupUers);
        msgGroup.setGroupIds(groupIds);

        msgGroupRepository.save(msgGroup);

        result.put("msg","success");

        return result.toString();

    }


    @RequestMapping(value = "/msgGroups")
    @ResponseBody
    String msgGroups(@RequestParam(value = "pageIndex", defaultValue = "1") Integer page,
                 @RequestParam(value = "pageSize", defaultValue = "10") Integer size,
                 @RequestParam(value = "sortOrder", required = false, defaultValue = "asc") String sortOrder,
                 @RequestParam(value = "sortName", required = false, defaultValue = "id") String sortName) {

        result = new JSONObject();
        page = page - 1;
        Sort sort = new Sort(sortOrder.equals("asc") ? Sort.Direction.ASC : Sort.Direction.DESC, sortName);
        Pageable pageable = new PageRequest(page, size, sort);



        Page<MsgGroupEntity> msgGroups = null;
        try {

            Specification<MsgGroupEntity> specification = (root, criteriaQuery, criteriaBuilder) -> {

                List<Predicate> predicates = new ArrayList<>();

                String str = "%["+getUser().getId()+"]%";
                System.out.println(str);
                predicates.add(criteriaBuilder.like(root.get("groupIds"),str));

                return criteriaBuilder.and(predicates.toArray(new Predicate[predicates.size()]));
            };

            msgGroups = msgGroupRepository.findAll(specification,pageable);
            msg = "success";
        } catch (Exception e) {
            logger.error("资料列表数据:" + e.getMessage());
            msg = "Exception";
        }


        JsonConfig jsonConfig = new JsonConfig();

        jsonConfig.setCycleDetectionStrategy(CycleDetectionStrategy.LENIENT);

        JSONArray json = JSONArray.fromObject(msgGroups, jsonConfig);

//        operationLogInfo = "用户【" + getUser().getUsername() + "】执行查询资料列表操作";
        result.put("msg", msg);
//        result.put("operationLog", operationLogInfo);
        result.put("result", json);
        return result.toString();
    }




    @ArchivesLog(operationType = "delGroup", operationName = "删除聊天室")
    @RequestMapping(value = "/delGroup")
    @ResponseBody
    String delGroup(Long[] ids) {
        operationLogInfo = "用户【" + getUser().getUsername() + "】删除聊天室【";

        try{

            if (null != ids && ids.length >0){
                for (Long id:ids){
                    MsgGroupEntity entity = msgGroupRepository.findOne(id);
                    operationLogInfo += entity.getGroupName() + ",";
                    msgGroupRepository.delete(entity);

                }
            }
            msg = "success";

        }catch (Exception e){
            logger.error(e.getMessage());
            msg = "delete msgGroup failed";

        }


        operationLogInfo = operationLogInfo.substring(0, operationLogInfo.length() - 1) + "】,操作结果【" + msg + "】";
        result.put("msg", msg);
        result.put("operationLog", operationLogInfo);
        return result.toString();
    }


    protected User getUser() {
        Subject subject = SecurityUtils.getSubject();
        return (User) subject.getPrincipal();
    }


}
