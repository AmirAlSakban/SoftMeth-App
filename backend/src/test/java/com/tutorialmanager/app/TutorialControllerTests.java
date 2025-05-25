package com.tutorialmanager.app;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyLong;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.doNothing;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultHandlers.print;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import java.util.Optional;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;

import com.tutorialmanager.app.controller.TutorialController;
import com.tutorialmanager.app.model.Tutorial;
import com.tutorialmanager.app.service.TutorialService;
import com.fasterxml.jackson.databind.ObjectMapper;

@WebMvcTest(TutorialController.class)
public class TutorialControllerTests {
  @MockBean
  private TutorialService tutorialService;

  @Autowired
  private MockMvc mockMvc;

  @Autowired
  private ObjectMapper objectMapper;
  @Test
  void shouldCreateTutorial() throws Exception {
    Tutorial tutorial = new Tutorial(1, "Spring Boot @WebMvcTest", "Description", true);
    Tutorial savedTutorial = new Tutorial(1, "Spring Boot @WebMvcTest", "Description", false);

    when(tutorialService.createTutorial(any(Tutorial.class))).thenReturn(savedTutorial);
    
    mockMvc.perform(post("/api/tutorials").contentType(MediaType.APPLICATION_JSON)
        .content(objectMapper.writeValueAsString(tutorial)))
        .andExpect(status().isCreated())
        .andDo(print());
  }

  @Test
  void shouldReturnTutorial() throws Exception {
    long id = 1L;
    Tutorial tutorial = new Tutorial(id, "Spring Boot @WebMvcTest", "Description", true);

    when(tutorialService.getTutorialById(id)).thenReturn(Optional.of(tutorial));
    mockMvc.perform(get("/api/tutorials/{id}", id)).andExpect(status().isOk())
        .andExpect(jsonPath("$.id").value(id))
        .andExpect(jsonPath("$.title").value(tutorial.getTitle()))
        .andExpect(jsonPath("$.description").value(tutorial.getDescription()))
        .andExpect(jsonPath("$.published").value(tutorial.isPublished()))
        .andDo(print());
  }

  @Test
  void shouldReturnNotFoundTutorial() throws Exception {
    long id = 1L;

    when(tutorialService.getTutorialById(id)).thenReturn(Optional.empty());
    mockMvc.perform(get("/api/tutorials/{id}", id))
         .andExpect(status().isNotFound())
         .andDo(print());
  }
  @Test
  void shouldReturnListOfTutorials() throws Exception {
    List<Tutorial> tutorials = new ArrayList<>(
        Arrays.asList(new Tutorial(1, "Spring Boot @WebMvcTest 1", "Description 1", true),
            new Tutorial(2, "Spring Boot @WebMvcTest 2", "Description 2", true),
            new Tutorial(3, "Spring Boot @WebMvcTest 3", "Description 3", true)));

    when(tutorialService.getAllTutorials()).thenReturn(tutorials);
    mockMvc.perform(get("/api/tutorials"))
        .andExpect(status().isOk())
        .andExpect(jsonPath("$.size()").value(tutorials.size()))
        .andDo(print());
  }

  @Test
  void shouldReturnListOfTutorialsWithFilter() throws Exception {
    List<Tutorial> tutorials = new ArrayList<>(
        Arrays.asList(new Tutorial(1, "Spring Boot @WebMvcTest", "Description 1", true),
            new Tutorial(3, "Spring Boot Web MVC", "Description 3", true)));

    String title = "Boot";
    MultiValueMap<String, String> paramsMap = new LinkedMultiValueMap<>();
    paramsMap.add("title", title);

    when(tutorialService.getTutorialsByTitle(anyString())).thenReturn(tutorials);
    mockMvc.perform(get("/api/tutorials").params(paramsMap))
        .andExpect(status().isOk())
        .andExpect(jsonPath("$.size()").value(tutorials.size()))
        .andDo(print());
  }
    @Test
  void shouldReturnNoContentWhenFilter() throws Exception {
    String title = "Tutorial";
    MultiValueMap<String, String> paramsMap = new LinkedMultiValueMap<>();
    paramsMap.add("title", title);
    
    List<Tutorial> tutorials = Collections.emptyList();

    when(tutorialService.getTutorialsByTitle(anyString())).thenReturn(tutorials);
    mockMvc.perform(get("/api/tutorials").params(paramsMap))
        .andExpect(status().isNoContent())
        .andDo(print());
  }
  @Test
  void shouldUpdateTutorial() throws Exception {
    long id = 1L;

    Tutorial tutorial = new Tutorial(id, "Spring Boot @WebMvcTest", "Description", false);
    Tutorial updatedTutorial = new Tutorial(id, "Updated", "Updated", true);

    when(tutorialService.updateTutorial(anyLong(), any(Tutorial.class))).thenReturn(Optional.of(updatedTutorial));

    mockMvc.perform(put("/api/tutorials/{id}", id).contentType(MediaType.APPLICATION_JSON)
        .content(objectMapper.writeValueAsString(updatedTutorial)))
        .andExpect(status().isOk())
        .andExpect(jsonPath("$.title").value(updatedTutorial.getTitle()))
        .andExpect(jsonPath("$.description").value(updatedTutorial.getDescription()))
        .andExpect(jsonPath("$.published").value(updatedTutorial.isPublished()))
        .andDo(print());
  }
  
  @Test
  void shouldReturnNotFoundUpdateTutorial() throws Exception {
    long id = 1L;

    Tutorial updatedTutorial = new Tutorial(id, "Updated", "Updated", true);

    when(tutorialService.updateTutorial(anyLong(), any(Tutorial.class))).thenReturn(Optional.empty());

    mockMvc.perform(put("/api/tutorials/{id}", id).contentType(MediaType.APPLICATION_JSON)
        .content(objectMapper.writeValueAsString(updatedTutorial)))
        .andExpect(status().isNotFound())
        .andDo(print());
  }
  
  @Test
  void shouldDeleteTutorial() throws Exception {
    long id = 1L;

    when(tutorialService.deleteTutorial(id)).thenReturn(true);
    mockMvc.perform(delete("/api/tutorials/{id}", id))
         .andExpect(status().isNoContent())
         .andDo(print());
  }
  
  @Test
  void shouldDeleteAllTutorials() throws Exception {
    mockMvc.perform(delete("/api/tutorials"))
         .andExpect(status().isNoContent())
         .andDo(print());
  }
}
