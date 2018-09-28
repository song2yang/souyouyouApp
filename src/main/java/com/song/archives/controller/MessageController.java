package com.song.archives.controller;

import com.song.archives.aspect.ArchivesLog;
import com.song.archives.dao.MessageRepository;
import com.song.archives.dao.MsgAttachRepository;
import com.song.archives.dao.UserRepository;
import com.song.archives.model.*;
import com.song.archives.utils.DateUtil;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.apache.poi.ss.formula.functions.T;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.subject.Subject;
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
import sun.jvm.hotspot.debugger.posix.elf.ELFException;

import javax.persistence.criteria.Predicate;
import java.io.File;
import java.sql.Timestamp;
import java.util.*;

/**
 * Created by souyouyou on 2018/3/16.
 */

@Controller
@RequestMapping(value = "/")
public class MessageController {

    Logger logger = Logger.getLogger(MessageController.class);

    public static String SUCCESS = "success";

    private String msg = "failed";

    private String operationLogInfo = "";

    private JSONObject result;

    @Autowired
    private MsgAttachRepository msgAttachRepository;

    @Autowired
    private MessageRepository msgRepository;

    @Autowired
    private UserHasMsgRepository userHasMsgRepository;

    @Autowired
    private UserRepository userRepository;

    @Value("${filePath}")
    private String filePath;


    @ArchivesLog(operationType = "findMsgByMid",operationName = "查询消息")
    @RequestMapping("findMsgByMid")
    @ResponseBody
    public String findMsgByMid(@RequestParam(value = "mid")Long mid){

        Message message = msgRepository.findOne(mid);
        JSONObject json = JSONObject.fromObject(message);

        operationLogInfo = "用户【"+getUser().getUsername()+"】执行查询消息操作";
        json.put("operationLog",operationLogInfo);

        return json.toString();
    }

    @ArchivesLog(operationType = "",operationName = "发件箱")
    @RequestMapping("outBoxList")
    public ModelAndView outBoxList(){

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.setViewName("message/outBoxList");

        return modelAndView;
    }


    @ArchivesLog(operationType = "",operationName = "草稿箱")
    @RequestMapping("draftList")
    public ModelAndView draftList(){

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.setViewName("message/draftList");

        return modelAndView;
    }


    @ArchivesLog(operationType = "",operationName = "删除信息")
    @RequestMapping("deleteMsg")
    @ResponseBody
    public String deleteMsg(@RequestParam(value = "type") String type,
                            @RequestParam(value = "msgId") Long msgId){

        result = new JSONObject();
        UserHasMsg userHasMsg = userHasMsgRepository.findAllByMsgId(msgId);
        //删除收件人
        if (type.equals("from")){
            userHasMsg.setReceverIds(userHasMsg.getReceverIds().replace("["+getUser().getId()+"]",""));
        }else {
            userHasMsg.setSenderId(null);
        }
        try {
            userHasMsgRepository.save(userHasMsg);
            msg = SUCCESS;
        }catch (Exception e){
            logger.error("删除信息:"+e.getMessage());
            msg = "Exception";
        }

        operationLogInfo = "用户【"+getUser().getUsername()+"】执行删除信息["+msgId+"]";
        result.put("operationLog",operationLogInfo);
        result.put("msg",msg);


        return result.toString();
    }


    @ArchivesLog(operationType = "",operationName = "消息详情")
    @RequestMapping("msgDetail1")
    public ModelAndView msgDetail(@RequestParam(value = "mid")Long mid,
                                  @RequestParam(value = "id",required = false)Long id,
                                  @RequestParam(value = "type")String type){


        Message message = msgRepository.findOne(mid);
        List<User> users = new ArrayList<>();
        UserHasMsg userHasMsg = null;
        if (null != id){

            userHasMsg = userHasMsgRepository.findOne(id);
            //发件箱 查收件人
            if (type.equals("to")){
                String[] split = userHasMsg.getReceverIds().split("]");
                for (String string:split){
                    Long rid = Long.valueOf(string.replace("[",""));
                    User user = userRepository.findOne(rid);
                    users.add(user);
                }
            }else {
                User user = userRepository.findOne(userHasMsg.getSenderId());
                users.add(user);
            }
        }


        List<MessageAttach> messageAttaches = msgAttachRepository.findByMsgId(mid);


        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("msg",message);
        modelAndView.addObject("users",users);
        modelAndView.addObject("type",type);
        modelAndView.addObject("attaches",messageAttaches);
        modelAndView.addObject("userHasMsg",userHasMsg);


        modelAndView.addObject("createTime", DateUtil.parseDateToStr(message.getCreateTime(),DateUtil.DATE_TIME_FORMAT_YYYY_MM_DD_HH_MI));
        modelAndView.setViewName("message/msgDetail");

        return modelAndView;
    }

    @ArchivesLog(operationType = "",operationName = "发件列表")
    @RequestMapping("outBoxes")
    @ResponseBody
    public String outBoxes(@RequestParam(value = "pageIndex", defaultValue = "0") Integer page,
                           @RequestParam(value = "pageSize", defaultValue = "10") Integer size){


        result = new JSONObject();
        page = page - 1;
        Sort sort = new Sort(Sort.Direction.ASC, "id");
        Pageable pageable = new PageRequest(page, size, sort);

        Page<UserHasMsg> allBySenderId;

        try {

            allBySenderId = userHasMsgRepository.findBySenderId(pageable,getUser().getId());

            msg = SUCCESS;

            result.put("result", JSONArray.fromObject(allBySenderId));
        }catch (Exception e){
            logger.error("发件列表:"+e.getMessage());
            msg = "Exception";
        }

        operationLogInfo = "用户【"+getUser().getUsername()+"】执行查询发件列表操作";
        result.put("operationLog",operationLogInfo);
        result.put("msg",msg);
        return result.toString();
    }


    @ArchivesLog(operationType = "",operationName = "收件列表")
    @RequestMapping("inBoxes")
    @ResponseBody
    public String inBoxes(@RequestParam(value = "pageIndex", defaultValue = "0") Integer page,
                           @RequestParam(value = "pageSize", defaultValue = "10") Integer size){

        result = new JSONObject();
        page = page - 1;
        Sort sort = new Sort(Sort.Direction.ASC, "id");
        Pageable pageable = new PageRequest(page, size, sort);

        Page<UserHasMsg> allMsg;

        try {

            Specification<UserHasMsg> specification = (root, criteriaQuery, criteriaBuilder) -> {

                List<Predicate> predicates = new ArrayList<>();

                String str = "%["+getUser().getId()+"]%";
                predicates.add(criteriaBuilder.like(root.get("receverIds"),str));

                return criteriaBuilder.and(predicates.toArray(new Predicate[predicates.size()]));
            };

            allMsg = userHasMsgRepository.findAll(specification,pageable);

            msg = SUCCESS;
            result.put("result", JSONArray.fromObject(allMsg));
        }catch (Exception e){
            logger.error("收件列表:"+e.getMessage());
            msg = "Exception";
        }

        operationLogInfo = "用户【"+getUser().getUsername()+"】执行查询收件列表操作";
        result.put("operationLog",operationLogInfo);
        result.put("msg",msg);
        return result.toString();
    }


    @ArchivesLog(operationType = "",operationName = "草稿列表")
    @RequestMapping("drafts")
    @ResponseBody
    public String drafts(@RequestParam(value = "pageIndex", defaultValue = "0") Integer page,
                          @RequestParam(value = "pageSize", defaultValue = "10") Integer size){

        result = new JSONObject();
        page = page - 1;
        Sort sort = new Sort(Sort.Direction.ASC, "id");
        Pageable pageable = new PageRequest(page, size, sort);

        Page<UserHasMsg> allMsg;

        try {

            Specification<UserHasMsg> specification = (root, criteriaQuery, criteriaBuilder) -> {

                List<Predicate> predicates = new ArrayList<>();

                predicates.add(criteriaBuilder.equal(root.get("senderId"),getUser().getId()));
                predicates.add(criteriaBuilder.equal(root.get("sendStatus"),0));

                return criteriaBuilder.and(predicates.toArray(new Predicate[predicates.size()]));
            };

            allMsg = userHasMsgRepository.findAll(specification,pageable);

            msg = SUCCESS;
            result.put("result", JSONArray.fromObject(allMsg));
        }catch (Exception e){
            logger.error(" 草稿列表:"+e.getMessage());
            msg = "Exception";
        }

        operationLogInfo = "用户【"+getUser().getUsername()+"】执行查询草稿列表操作";
        result.put("operationLog",operationLogInfo);
        result.put("msg",msg);
        return result.toString();
    }


    @ArchivesLog(operationType = "sendMessage" , operationName = "发送信息")
    @RequestMapping("sendMessage")
    @ResponseBody
    public String sendMessage(Message message,
                              @RequestParam(value = "attachment") MultipartFile[] files,
                              @RequestParam(value = "receverId") Long[] rids,
                              @RequestParam(value = "senderStatus",required = false) Integer senderStatus){

        result = new JSONObject();
        Message saveMsg = null;
        try{
            message.setCreateTime(new Date());

            if (StringUtils.isNotEmpty(message.getContent()) && StringUtils.isNotBlank(message.getContent())){
                message.setContent(message.getContent().replace("\n",""));
            }
            saveMsg = msgRepository.save(message);

            if (null != files && files.length > 0){
                for (MultipartFile file:files) {
                    File localFile = new File(filePath+"/"+file.getOriginalFilename());
                    file.transferTo(localFile);

                    MessageAttach messageAttach = new MessageAttach();
                    messageAttach.setCreateTime(new Timestamp(System.currentTimeMillis()));
                    messageAttach.setFileName(file.getOriginalFilename());
                    messageAttach.setFilePath(filePath+"/"+file.getOriginalFilename());
                    messageAttach.setMsgId(saveMsg.getId());

                    msgAttachRepository.save(messageAttach);
                }
            }

            String ridStr = "";
            for (Long rid:rids){
                ridStr += "["+rid+"]";
            }

            UserHasMsg userHasMsg = new UserHasMsg();

            userHasMsg.setMsgId(saveMsg.getId());
            userHasMsg.setReceverIds(ridStr);
            userHasMsg.setSenderId(getUser().getId());
            userHasMsg.setReadStatus(0);
            userHasMsg.setReceveStatus(1);
            userHasMsg.setSendStatus(senderStatus);

            userHasMsgRepository.save(userHasMsg);



            msg = SUCCESS;
        }catch (Exception e){
            logger.error("发送信息:"+e.getMessage());
            msg = "Exception";
        }

        operationLogInfo = "用户【"+getUser().getUsername()+"】执行发送信息操作,消息标题【"+saveMsg.getTitle()+"】";
        result.put("operationLog",operationLogInfo);
        result.put("msg",msg);

        return result.toString();
    }


    @ArchivesLog(operationType = "getContacts" , operationName = "获取联系人")
    @RequestMapping("getContacts")
    @ResponseBody
    public String getContacts(@RequestParam(value = "uid")Long uid){

        User user = userRepository.findOne(uid);

        JSONObject result = JSONObject.fromObject(user);
        operationLogInfo = "用户【"+getUser().getUsername()+"】执行获取联系人操作";
        result.put("operationLog",operationLogInfo);
        return result.toString();
    }


    protected User getUser(){
        Subject subject = SecurityUtils.getSubject();
        return (User) subject.getPrincipal();
    }



}
