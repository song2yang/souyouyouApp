package com.song.archives.dao;

import com.song.archives.model.NotifyEntity;
import org.springframework.data.repository.CrudRepository;

import java.util.List;


/**
 * Created by souyouyou on 2018/3/12.
 */
public interface NotifyRepository extends CrudRepository<NotifyEntity,Long>{

    List<NotifyEntity> findByPersonal(String personal);


}
