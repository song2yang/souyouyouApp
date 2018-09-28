package com.song.archives.dao;

import com.song.archives.model.ReceivedLogEntity;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.data.repository.CrudRepository;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * Created by ghl on 2018/3/12.
 */
public interface ReceiveLogRepository extends CrudRepository<ReceivedLogEntity,Long> {

   List<ReceivedLogEntity> findAll(Pageable pageable);

   List<ReceivedLogEntity> findAll(Specification specification,Pageable pageable);

   @Transactional
   void deleteByProjectIdEquals(Integer proid);
}
