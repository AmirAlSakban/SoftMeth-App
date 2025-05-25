package com.tutorialmanager.app.service;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.tutorialmanager.app.model.Tutorial;
import com.tutorialmanager.app.repository.TutorialRepository;

@Service
public class TutorialServiceImpl implements TutorialService {
    
    @Autowired
    private TutorialRepository tutorialRepository;
    
    @Override
    public List<Tutorial> getAllTutorials() {
        return tutorialRepository.findAll();
    }
    
    @Override
    public List<Tutorial> getTutorialsByTitle(String title) {
        return tutorialRepository.findByTitleContaining(title);
    }
    
    @Override
    public Optional<Tutorial> getTutorialById(long id) {
        return tutorialRepository.findById(id);
    }
    
    @Override
    public Tutorial createTutorial(Tutorial tutorial) {
        Tutorial newTutorial = new Tutorial(tutorial.getTitle(), tutorial.getDescription(), false);
        return tutorialRepository.save(newTutorial);
    }
    
    @Override
    public Optional<Tutorial> updateTutorial(long id, Tutorial tutorial) {
        Optional<Tutorial> tutorialData = tutorialRepository.findById(id);
        
        if (tutorialData.isPresent()) {
            Tutorial _tutorial = tutorialData.get();
            _tutorial.setTitle(tutorial.getTitle());
            _tutorial.setDescription(tutorial.getDescription());
            _tutorial.setPublished(tutorial.isPublished());
            return Optional.of(tutorialRepository.save(_tutorial));
        } else {
            return Optional.empty();
        }
    }
    
    @Override
    public boolean deleteTutorial(long id) {
        try {
            tutorialRepository.deleteById(id);
            return true;
        } catch (Exception e) {
            return false;
        }
    }
    
    @Override
    public void deleteAllTutorials() {
        tutorialRepository.deleteAll();
    }
    
    @Override
    public List<Tutorial> findByPublished(boolean published) {
        return tutorialRepository.findByPublished(published);
    }
}
