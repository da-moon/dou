package com.techM.OpenHouseLandingRest.controller;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.doNothing;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultHandlers.print;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.techM.OpenHouseLandingRest.model.Candidate;
import com.techM.OpenHouseLandingRest.repository.CandidateRepository;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Optional;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;

@AutoConfigureMockMvc
@WebMvcTest(JoinUsController.class)
class JoinUsControllerTest {

  @MockBean private CandidateRepository candidateRepo;
  @Autowired private MockMvc mockMvc;
  @Autowired private ObjectMapper objectMapper;

  @BeforeEach
  void setUp() {}

  @Test
  void shouldSaveCandidate() throws Exception {
    Candidate candidate =
        new Candidate(
            1,
            "Jonathan Smith",
            "john.smith@mailserver.com",
            "333344455",
            "Java",
            "www.linkedin.com/profile");
    mockMvc
        .perform(
            post("/join-us/candidates")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(candidate)))
        .andExpect(status().isCreated())
        .andDo(print());
  }

  @Test
  void shouldUpdateCandidate() throws Exception {
    int id = 1;
    Candidate candidate =
        new Candidate(
            id,
            "Jonathan Smith",
            "john.smith@mailserver.com",
            "333344455",
            "Java",
            "www.linkedin.com/profile");
    Candidate updatedCandidate =
        new Candidate(
            id,
            "Jonathan Smith",
            "john.smith@mailserver.com",
            "6666677776",
            "Java",
            "www.linkedin.com/profile");
    when(candidateRepo.findById(id)).thenReturn(Optional.of(candidate));
    when(candidateRepo.save(any(Candidate.class))).thenReturn(updatedCandidate);
    mockMvc
        .perform(
            put("/join-us/candidates")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(updatedCandidate)))
        .andExpect(status().isOk())
        .andExpect(jsonPath("$.name").value(updatedCandidate.getName()))
        .andExpect(jsonPath("$.email").value(updatedCandidate.getEmail()))
        .andExpect(jsonPath("$.contactNumber").value(updatedCandidate.getContactNumber()))
        .andExpect(
            jsonPath("$.programmingLanguage").value(updatedCandidate.getProgrammingLanguage()))
        .andExpect(jsonPath("$.linkedIn").value(updatedCandidate.getLinkedIn()))
        .andDo(print());
  }

  @Test
  void shouldRetrieveAnCandidate() throws Exception {
    int id = 1;
    Optional<Candidate> candidate =
        Optional.of(
            new Candidate(
                id,
                "Jonathan Smith",
                "john.smith@mailserver.com",
                "333344455",
                "Java",
                "www.linkedin.com/profile"));
    when(candidateRepo.findById(id)).thenReturn(candidate);
    mockMvc
        .perform(
            get("/join-us/candidates/{id}", id)
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(candidate)))
        .andExpect(status().isOk())
        .andExpect(jsonPath("$.name").value(candidate.get().getName()))
        .andExpect(jsonPath("$.email").value(candidate.get().getEmail()))
        .andExpect(jsonPath("$.contactNumber").value(candidate.get().getContactNumber()))
        .andExpect(
            jsonPath("$.programmingLanguage").value(candidate.get().getProgrammingLanguage()))
        .andExpect(jsonPath("$.linkedIn").value(candidate.get().getLinkedIn()))
        .andDo(print());
  }

  @Test
  void shouldRetrieveAllCandidates() throws Exception {
    List<Candidate> candidates =
        new ArrayList<>(
            Arrays.asList(
                new Candidate(
                    1,
                    "Jonathan Smith",
                    "john.smith@mailserver.com",
                    "656452332",
                    "Java",
                    "www.linkedin.com/profile"),
                new Candidate(
                    2,
                    "Perter Parker",
                    "man.spider@mailserver.com",
                    "123223266",
                    "Java",
                    "www.linkedin.com/profile"),
                new Candidate(
                    3,
                    "Tony Stark",
                    "Tony@starkIndustries.com",
                    "12321545",
                    "Java",
                    "www.linkedin.com/profile")));
    when(candidateRepo.findAll()).thenReturn(candidates);
    mockMvc
        .perform(get("/join-us/candidates/"))
        .andExpect(status().isOk())
        .andExpect(jsonPath("$.size()").value(candidates.size()))
        .andDo(print());
  }

  @Test
  void shouldDeleteCandidate() throws Exception {
    int id = 1;
    Optional<Candidate> candidate =
        Optional.of(
            new Candidate(
                id,
                "Jonathan Smith",
                "john.smith@mailserver.com",
                "6666677776",
                "Java",
                "www.linkedin.com/profile"));
    doNothing().when(candidateRepo).deleteById(id);
    when(candidateRepo.findById(id)).thenReturn(candidate);
    mockMvc
        .perform(delete("/join-us/candidates/{id}", id))
        .andExpect(status().isOk())
        .andDo(print());
  }

  @Test
  void shouldReturnNotFoundCandidate() throws Exception {
    int id = 9999;
    mockMvc
        .perform(get("/join-us/candidates/{id}", id))
        .andExpect(status().isInternalServerError())
        .andDo(print());
  }

  @Test
  void shouldReturnNotFoundUpdateCandidate() throws Exception {
    int id = 99;
    Candidate updatedCandidate =
        new Candidate(
            id,
            "Jonathan Smith",
            "john.smith@mailserver.com",
            "6666677776",
            "Java",
            "www.linkedin.com/profile");
    when(candidateRepo.findById(id)).thenReturn(Optional.empty());
    when(candidateRepo.save(any(Candidate.class))).thenReturn(updatedCandidate);
    mockMvc
        .perform(
            put("/join-us/candidates")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(updatedCandidate)))
        .andExpect(status().isOk())
        .andDo(print());
  }

  @Test
  void shouldNotSaveCandidateMissingName() throws Exception {
    Candidate candidate =
        new Candidate(
            1, "", "john.smith@mailserver.com", "6666677776", "Java", "www.linkedin.com/profile");
    mockMvc
        .perform(
            post("/join-us/candidates")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(candidate)))
        .andExpect(status().isBadRequest())
        .andDo(print());
  }

  @Test
  void shouldNotSaveCandidateMissingMail() throws Exception {
    Candidate candidate =
        new Candidate(1, "Jonathan Smith", "", "6666677776", "Java", "www.linkedin.com/profile");
    mockMvc
        .perform(
            post("/join-us/candidates")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(candidate)))
        .andExpect(status().isBadRequest())
        .andDo(print());
  }

  @Test
  void shouldNotSaveCandidateIncorrectMail() throws Exception {
    Candidate candidate =
        new Candidate(
            1,
            "Jonathan Smith",
            "john.smithmailserver.com",
            "6666677776",
            "Java",
            "www.linkedin.com/profile");
    mockMvc
        .perform(
            post("/join-us/candidates")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(candidate)))
        .andExpect(status().isBadRequest())
        .andDo(print());
  }

  @Test
  void shouldNotSaveCandidateMissingContactNumber() throws Exception {
    Candidate candidate =
        new Candidate(
            1,
            "Jonathan Smith",
            "john.smith@mailserver.com",
            "",
            "Java",
            "www.linkedin.com/profile");
    mockMvc
        .perform(
            post("/join-us/candidates")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(candidate)))
        .andExpect(status().isBadRequest())
        .andDo(print());
  }

  @Test
  void shouldNotSaveCandidateMissingProgrammingLanguage() throws Exception {
    Candidate candidate =
        new Candidate(
            1,
            "Jonathan Smith",
            "john.smith@mailserver.com",
            "6666677776",
            "",
            "www.linkedin.com/profile");
    mockMvc
        .perform(
            post("/join-us/candidates")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(candidate)))
        .andExpect(status().isBadRequest())
        .andDo(print());
  }

  @Test
  void shouldNotSaveCandidateMissingLinkedIn() throws Exception {
    Candidate candidate =
        new Candidate(1, "Jonathan Smith", "john.smith@mailserver.com", "6666677776", "", "");
    mockMvc
        .perform(
            post("/join-us/candidates")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(candidate)))
        .andExpect(status().isBadRequest())
        .andDo(print());
  }
}
