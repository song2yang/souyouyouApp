package com.song.archives.dao;

import com.song.archives.model.PhaseFileTypeEntity;
import org.springframework.data.repository.CrudRepository;

import java.util.List;

public interface PhaseFileTypeRepository extends CrudRepository<PhaseFileTypeEntity,Long> {

    List<PhaseFileTypeEntity> findAllByPhaseId(long phaseid);
}
