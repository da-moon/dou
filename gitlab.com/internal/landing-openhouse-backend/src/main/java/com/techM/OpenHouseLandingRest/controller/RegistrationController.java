package com.techM.OpenHouseLandingRest.controller;

import com.techM.OpenHouseLandingRest.exception.AttendantNotFoundException;
import com.techM.OpenHouseLandingRest.exception.EmailException;
import com.techM.OpenHouseLandingRest.model.Attendant;
import com.techM.OpenHouseLandingRest.repository.AttendantRepository;
import io.swagger.v3.oas.annotations.Operation;
import java.util.List;
import javax.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

@RestController()
@RequestMapping("/registration")
@CrossOrigin(origins = {"http://talentland.techmcne.com", "https://talentland.techmcne.com"})
public class RegistrationController {

  @Autowired AttendantRepository attendantRepo;

  @Operation(summary = "Returns the data of a user by Id")
  @GetMapping("/attendants/{id}")
  public ResponseEntity<Attendant> retrieveAttendant(@PathVariable int id) {
    return new ResponseEntity<>(
        attendantRepo
            .findById(id)
            .orElseThrow(() -> new AttendantNotFoundException("Attendant not Found")),
        HttpStatus.OK);
  }

  @Operation(summary = "Returns the entire registered users list")
  @GetMapping("/attendants")
  public ResponseEntity<List<Attendant>> retrieveAllAttendants() {
    List<Attendant> attendantList = attendantRepo.findAll();
    return new ResponseEntity<>(attendantList, HttpStatus.OK);
  }

  @Operation(summary = "Saves a new attendant")
  @PostMapping(
      value = "/attendants",
      produces = MediaType.APPLICATION_JSON_VALUE,
      consumes = MediaType.APPLICATION_JSON_VALUE)
  public ResponseEntity<?> saveAttendant(@Valid @RequestBody Attendant attendant) {
    try {
      attendant = attendantRepo.save(attendant);
      return new ResponseEntity<>(attendant, HttpStatus.CREATED);
    } catch (DataIntegrityViolationException ex) {
      throw new EmailException("Duplicated Email");
    }
  }

  @Operation(summary = "Delete the data of a user by Id")
  @DeleteMapping("/attendants/{id}")
  public ResponseEntity<?> deleteAttendant(@PathVariable int id) {
    Attendant attendant =
        attendantRepo
            .findById(id)
            .orElseThrow(() -> new AttendantNotFoundException("Attendant not Found"));
    attendantRepo.deleteById(attendant.getId());
    return new ResponseEntity<>("DELETED", HttpStatus.OK);
  }

  @Operation(summary = "Updates the data of a user by Id")
  @PutMapping("/attendants")
  public ResponseEntity<?> updateAttendant(@Valid @RequestBody Attendant attendant) {
    Attendant updatedAttendant = attendantRepo.save(attendant);
    return new ResponseEntity<>(updatedAttendant, HttpStatus.OK);
  }
}
