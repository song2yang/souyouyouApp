package com.song.archives.dao;

import com.song.archives.model.ChengYanDanWeiEntity;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.data.repository.CrudRepository;

public interface ChengYanDanWeiRepository extends CrudRepository<ChengYanDanWeiEntity,Long> {

    Page<ChengYanDanWeiEntity> findAll(Specification specification, Pageable pageable);

}
