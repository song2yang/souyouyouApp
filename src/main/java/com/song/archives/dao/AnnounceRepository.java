package com.song.archives.dao;

import com.song.archives.model.AnliInfoEntity;
import com.song.archives.model.AnnounceInfoEntity;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.data.repository.CrudRepository;

import java.util.List;

/**
 * Created by souyouyou on 2018/3/12.
 */
public interface AnnounceRepository extends CrudRepository<AnnounceInfoEntity,Long>{

    Page<AnnounceInfoEntity> findAll(Specification<AnnounceInfoEntity> specification, Pageable pageable);

    long count();

    List<AnnounceInfoEntity> findAll(Specification<AnnounceInfoEntity> specification);

}
