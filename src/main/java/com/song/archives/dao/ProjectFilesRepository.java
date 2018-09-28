package com.song.archives.dao;

import com.song.archives.model.ProjectFilesEntity;
import org.springframework.data.repository.CrudRepository;

import java.util.List;

public interface ProjectFilesRepository extends CrudRepository<ProjectFilesEntity,Long> {

    ProjectFilesEntity findFirstByProjectIdAndPhaseIdAndFileTypeIdAndFileId(long proid, long phaseid, long ftypeid,long fileid);

    List<ProjectFilesEntity> findAllByProjectIdAndPhaseIdAndFileTypeId(long proid,long phaseid,long ftypeid);

    List<ProjectFilesEntity> findAllByProjectId(long proid);

    List<ProjectFilesEntity> findAllByProjectIdAndPhaseId(long proid,long phaseid);

}
