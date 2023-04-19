package com.techM.OpenHouseLandingRest.controller;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.doNothing;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.delete;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.put;
import static org.springframework.test.web.servlet.result.MockMvcResultHandlers.print;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.techM.OpenHouseLandingRest.model.Attendant;
import com.techM.OpenHouseLandingRest.repository.AttendantRepository;
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
@WebMvcTest(RegistrationController.class)
class RegistrationControllerTest {

  @MockBean private AttendantRepository attendantRepo;
  @Autowired private MockMvc mockMvc;
  @Autowired private ObjectMapper objectMapper;

  @BeforeEach
  void setUp() {}

  @Test
  void shouldSaveAttendant() throws Exception {
    Attendant attendant =
        new Attendant(
            1,
            "John Smith",
            "John@mailserver.com",
            "3333-2222",
            "Fullstack",
            "New York",
            "Televis");
    mockMvc
        .perform(
            post("/registration/attendants")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(attendant)))
        .andExpect(status().isCreated())
        .andDo(print());
  }

  @Test
  void shouldUpdateAttendant() throws Exception {
    int id = 1;
    Attendant attendant =
        new Attendant(
            1,
            "John Smith",
            "John@mailserver.com",
            "3333-2222",
            "Fullstack",
            "New York",
            "Televis");
    Attendant updatedAttendant =
        new Attendant(
            1,
            "JonaThan Smith",
            "Johna@mailserver.com",
            "233-2222",
            "Fullstack",
            "Old York",
            "Televis");

    when(attendantRepo.findById(id)).thenReturn(Optional.of(attendant));
    when(attendantRepo.save(any(Attendant.class))).thenReturn(updatedAttendant);
    mockMvc
        .perform(
            put("/registration/attendants")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(updatedAttendant)))
        .andExpect(status().isOk())
        .andExpect(jsonPath("$.name").value(updatedAttendant.getName()))
        .andExpect(jsonPath("$.email").value(updatedAttendant.getEmail()))
        .andExpect(jsonPath("$.phoneNumber").value(updatedAttendant.getPhoneNumber()))
        .andExpect(jsonPath("$.role").value(updatedAttendant.getRole()))
        .andExpect(jsonPath("$.company").value(updatedAttendant.getCompany()))
        .andDo(print());
  }

  @Test
  void shouldRetrieveAnAttendant() throws Exception {
    int id = 1;
    Optional<Attendant> attendant =
        Optional.of(
            new Attendant(
                id,
                "John Smith",
                "John@mailserver.com",
                "3333-2222",
                "Fullstack",
                "New York",
                "Televis"));
    when(attendantRepo.findById(id)).thenReturn(attendant);
    mockMvc
        .perform(get("/registration/attendants/{id}", attendant.get().getId()))
        .andExpect(status().isOk())
        .andExpect(jsonPath("$.name").value(attendant.get().getName()))
        .andExpect(jsonPath("$.email").value(attendant.get().getEmail()))
        .andExpect(jsonPath("$.phoneNumber").value(attendant.get().getPhoneNumber()))
        .andExpect(jsonPath("$.role").value(attendant.get().getRole()))
        .andExpect(jsonPath("$.company").value(attendant.get().getCompany()))
        .andDo(print());
  }

  @Test
  void shouldRetrieveAllAttendants() throws Exception {
    List<Attendant> attendants =
        new ArrayList<>(
            Arrays.asList(
                new Attendant(
                    1,
                    "John Smith",
                    "John@mailserver.com",
                    "3333-2222",
                    "Fullstack",
                    "New York",
                    "Televis"),
                new Attendant(
                    2,
                    "Geno Malandin",
                    "MalFen@mailserver.com",
                    "4443-2344",
                    "FrontEnd",
                    "California",
                    "Att"),
                new Attendant(
                    3,
                    "Mallow House",
                    "HousOfM@mailserver.com",
                    "3333-1111",
                    "BackEnd",
                    "Chicago",
                    "Shork")));
    when(attendantRepo.findAll()).thenReturn(attendants);
    mockMvc
        .perform(get("/registration/attendants/"))
        .andExpect(status().isOk())
        .andExpect(jsonPath("$.size()").value(attendants.size()))
        .andDo(print());
  }

  @Test
  void shouldDeleteAttendant() throws Exception {
    int id = 1;
    Optional<Attendant> attendant =
        Optional.of(
            new Attendant(
                id,
                "John Smith",
                "John@mailserver.com",
                "3333-2222",
                "Fullstack",
                "New York",
                "Televis"));
    doNothing().when(attendantRepo).deleteById(id);
    when(attendantRepo.findById(id)).thenReturn(attendant);
    mockMvc
        .perform(delete("/registration/attendants/{id}", id))
        .andExpect(status().isOk())
        .andDo(print());
  }

  @Test
  void shouldReturnNotFoundAttendant() throws Exception {
    int id = 9999;
    mockMvc
        .perform(get("/registration/attendants/{id}", id))
        .andExpect(status().isNotFound())
        .andDo(print());
  }

  @Test
  void shouldReturnNotFoundUpdateAttendant() throws Exception {
    int id = 99;
    Attendant updateAttendant =
        new Attendant(
            id,
            "John Smith",
            "John@mailserver.com",
            "3333-2222",
            "Fullstack",
            "New York",
            "Televis");

    when(attendantRepo.findById(id)).thenReturn(Optional.empty());
    when(attendantRepo.save(any(Attendant.class))).thenReturn(updateAttendant);
    mockMvc
        .perform(
            put("/join-us/candidates")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(updateAttendant)))
        .andExpect(status().isNotFound())
        .andDo(print());
  }

  @Test
  void shouldNotSaveAttendantMissingName() throws Exception {
    Attendant attendant =
        new Attendant(
            1, "", "John@mailserver.com", "3333-2222", "Fullstack", "New York", "Televis");
    mockMvc
        .perform(
            post("/registration/attendants")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(attendant)))
        .andExpect(status().isBadRequest())
        .andDo(print());
  }

  @Test
  void shouldNotSaveAttendantMissingMail() throws Exception {
    Attendant attendant =
        new Attendant(1, "John Smith", "", "3333-2222", "Fullstack", "New York", "Televis");
    mockMvc
        .perform(
            post("/registration/attendants")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(attendant)))
        .andExpect(status().isBadRequest())
        .andDo(print());
  }

  @Test
  void shouldNotSaveAttendantBadMail() throws Exception {
    Attendant attendant =
        new Attendant(
            1, "John Smith", "Johnmailserver.com", "3333-2222", "Fullstack", "New York", "Televis");
    mockMvc
        .perform(
            post("/registration/attendants")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(attendant)))
        .andExpect(status().isBadRequest())
        .andDo(print());
  }

  @Test
  void shouldNotSaveAttendantMissingPhoneNumber() throws Exception {
    Attendant attendant =
        new Attendant(
            1, "John Smith", "John@mailserver.com", "", "Fullstack", "New York", "Televis");
    mockMvc
        .perform(
            post("/registration/attendants")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(attendant)))
        .andExpect(status().isBadRequest())
        .andDo(print());
  }

  @Test
  void shouldNotSaveAttendantMissingRole() throws Exception {
    Attendant attendant =
        new Attendant(
            1, "John Smith", "John@mailserver.com", "3333-2222", "", "New York", "Televis");
    mockMvc
        .perform(
            post("/registration/attendants")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(attendant)))
        .andExpect(status().isBadRequest())
        .andDo(print());
  }

  @Test
  void shouldNotSaveAttendantMissingLocation() throws Exception {
    Attendant attendant =
        new Attendant(
            1, "John Smith", "John@mailserver.com", "3333-2222", "Fullstack", "", "Televis");
    mockMvc
        .perform(
            post("/registration/attendants")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(attendant)))
        .andExpect(status().isBadRequest())
        .andDo(print());
  }

  @Test
  void shouldNotSaveAttendantMissingCompany() throws Exception {
    Attendant attendant =
        new Attendant(
            1, "John Smith", "John@mailserver.com", "3333-2222", "Fullstack", "New York", "");
    mockMvc
        .perform(
            post("/registration/attendants")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(attendant)))
        .andExpect(status().isBadRequest())
        .andDo(print());
  }
}
