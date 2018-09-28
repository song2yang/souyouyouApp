package com.song.archives.dao;

import com.song.archives.model.OperationLog;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.repository.CrudRepository;

import java.util.List;

/**
 * Created by souyouyou on 2018/2/2.
 */
public interface OperationRepository extends CrudRepository<OperationLog,Long>,JpaSpecificationExecutor<OperationLog> {

    Page<OperationLog> findAll(Specification<OperationLog> specification,Pageable pageable);

}
