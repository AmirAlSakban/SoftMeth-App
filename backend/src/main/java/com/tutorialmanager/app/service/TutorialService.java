package com.tutorialmanager.app.service;

import java.util.List;
import java.util.Optional;

import com.tutorialmanager.app.model.Tutorial;

public interface TutorialService {
    List<Tutorial> getAllTutorials();
    
    List<Tutorial> getTutorialsByTitle(String title);
    
    Optional<Tutorial> getTutorialById(long id);
    
    Tutorial createTutorial(Tutorial tutorial);
    
    Optional<Tutorial> updateTutorial(long id, Tutorial tutorial);
    
    boolean deleteTutorial(long id);
    
    void deleteAllTutorials();
    
    List<Tutorial> findByPublished(boolean published);
}
