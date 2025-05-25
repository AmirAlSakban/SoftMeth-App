package com.tutorialmanager.app.service;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyLong;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.doNothing;
import static org.mockito.Mockito.times;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import com.tutorialmanager.app.model.Tutorial;
import com.tutorialmanager.app.repository.TutorialRepository;

@ExtendWith(MockitoExtension.class)
public class TutorialServiceTests {

    @Mock
    private TutorialRepository tutorialRepository;
    
    @InjectMocks
    private TutorialServiceImpl tutorialService;
    
    private Tutorial tutorial;
    private List<Tutorial> tutorials;
    
    @BeforeEach
    void setUp() {
        tutorial = new Tutorial(1L, "Spring Boot Tutorial", "Spring Boot Description", true);
        
        tutorials = new ArrayList<>();
        tutorials.add(tutorial);
        tutorials.add(new Tutorial(2L, "Java Tutorial", "Java Description", false));
    }
    
    @Test
    void testGetAllTutorials() {
        // Given
        when(tutorialRepository.findAll()).thenReturn(tutorials);
        
        // When
        List<Tutorial> result = tutorialService.getAllTutorials();
        
        // Then
        assertThat(result).isNotNull();
        assertThat(result.size()).isEqualTo(2);
        verify(tutorialRepository, times(1)).findAll();
    }
    
    @Test
    void testGetTutorialsByTitle() {
        // Given
        String title = "Spring";
        List<Tutorial> filteredTutorials = new ArrayList<>();
        filteredTutorials.add(tutorial);
        
        when(tutorialRepository.findByTitleContaining(anyString())).thenReturn(filteredTutorials);
        
        // When
        List<Tutorial> result = tutorialService.getTutorialsByTitle(title);
        
        // Then
        assertThat(result).isNotNull();
        assertThat(result.size()).isEqualTo(1);
        assertThat(result.get(0).getTitle()).contains("Spring");
        verify(tutorialRepository, times(1)).findByTitleContaining(title);
    }
    
    @Test
    void testGetTutorialById_Found() {
        // Given
        when(tutorialRepository.findById(anyLong())).thenReturn(Optional.of(tutorial));
        
        // When
        Optional<Tutorial> result = tutorialService.getTutorialById(1L);
        
        // Then
        assertThat(result).isPresent();
        assertThat(result.get().getId()).isEqualTo(1L);
        verify(tutorialRepository, times(1)).findById(1L);
    }
    
    @Test
    void testGetTutorialById_NotFound() {
        // Given
        when(tutorialRepository.findById(anyLong())).thenReturn(Optional.empty());
        
        // When
        Optional<Tutorial> result = tutorialService.getTutorialById(999L);
        
        // Then
        assertThat(result).isEmpty();
        verify(tutorialRepository, times(1)).findById(999L);
    }
    
    @Test
    void testCreateTutorial() {
        // Given
        Tutorial newTutorial = new Tutorial("New Tutorial", "New Description", false);
        Tutorial savedTutorial = new Tutorial(3L, "New Tutorial", "New Description", false);
        
        when(tutorialRepository.save(any(Tutorial.class))).thenReturn(savedTutorial);
        
        // When
        Tutorial result = tutorialService.createTutorial(newTutorial);
        
        // Then
        assertThat(result).isNotNull();
        assertThat(result.getId()).isEqualTo(3L);
        assertThat(result.getTitle()).isEqualTo("New Tutorial");
        verify(tutorialRepository, times(1)).save(any(Tutorial.class));
    }
    
    @Test
    void testUpdateTutorial_Found() {
        // Given
        long id = 1L;
        Tutorial tutorialToUpdate = new Tutorial("Updated Title", "Updated Description", true);
        Tutorial updatedTutorial = new Tutorial(id, "Updated Title", "Updated Description", true);
        
        when(tutorialRepository.findById(anyLong())).thenReturn(Optional.of(tutorial));
        when(tutorialRepository.save(any(Tutorial.class))).thenReturn(updatedTutorial);
        
        // When
        Optional<Tutorial> result = tutorialService.updateTutorial(id, tutorialToUpdate);
        
        // Then
        assertThat(result).isPresent();
        assertThat(result.get().getTitle()).isEqualTo("Updated Title");
        assertThat(result.get().getDescription()).isEqualTo("Updated Description");
        verify(tutorialRepository, times(1)).findById(id);
        verify(tutorialRepository, times(1)).save(any(Tutorial.class));
    }
    
    @Test
    void testUpdateTutorial_NotFound() {
        // Given
        long id = 999L;
        Tutorial tutorialToUpdate = new Tutorial("Updated Title", "Updated Description", true);
        
        when(tutorialRepository.findById(anyLong())).thenReturn(Optional.empty());
        
        // When
        Optional<Tutorial> result = tutorialService.updateTutorial(id, tutorialToUpdate);
        
        // Then
        assertThat(result).isEmpty();
        verify(tutorialRepository, times(1)).findById(id);
        verify(tutorialRepository, times(0)).save(any(Tutorial.class));
    }
    
    @Test
    void testDeleteTutorial_Success() {
        // Given
        long id = 1L;
        doNothing().when(tutorialRepository).deleteById(anyLong());
        
        // When
        boolean result = tutorialService.deleteTutorial(id);
        
        // Then
        assertThat(result).isTrue();
        verify(tutorialRepository, times(1)).deleteById(id);
    }
    
    @Test
    void testDeleteAllTutorials() {
        // Given
        doNothing().when(tutorialRepository).deleteAll();
        
        // When
        tutorialService.deleteAllTutorials();
        
        // Then
        verify(tutorialRepository, times(1)).deleteAll();
    }
    
    @Test
    void testFindByPublished() {
        // Given
        List<Tutorial> publishedTutorials = new ArrayList<>();
        publishedTutorials.add(tutorial); // only the first tutorial is published
        
        when(tutorialRepository.findByPublished(true)).thenReturn(publishedTutorials);
        
        // When
        List<Tutorial> result = tutorialService.findByPublished(true);
        
        // Then
        assertThat(result).isNotNull();
        assertThat(result.size()).isEqualTo(1);
        assertThat(result.get(0).isPublished()).isTrue();
        verify(tutorialRepository, times(1)).findByPublished(true);
    }
}
