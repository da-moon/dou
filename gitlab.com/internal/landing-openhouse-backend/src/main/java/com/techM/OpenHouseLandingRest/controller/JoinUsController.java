package com.techM.OpenHouseLandingRest.controller;

import com.techM.OpenHouseLandingRest.exception.CandidateNotFoundException;
import com.techM.OpenHouseLandingRest.exception.EmailException;
import com.techM.OpenHouseLandingRest.model.Candidate;
import com.techM.OpenHouseLandingRest.repository.CandidateRepository;
import com.techM.OpenHouseLandingRest.utils.ExcelGenerator;
import io.swagger.v3.oas.annotations.Operation;
import java.io.IOException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import javax.servlet.http.HttpServletResponse;
import javax.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

@RestController()
@RequestMapping("/join-us")
@CrossOrigin(origins = {"http://talentland.techmcne.com", "https://talentland.techmcne.com"})
public class JoinUsController {

  @Autowired
  CandidateRepository CandidateRepo;

  @Operation(summary = "Returns the data of a user by Id")
  //@GetMapping("/candidates/{id}")
  public ResponseEntity<Candidate> retrieveCandidate(@PathVariable int id) {
    return new ResponseEntity<>(CandidateRepo.findById(id)
        .orElseThrow(() -> new CandidateNotFoundException("Candidate not Found")), HttpStatus.OK);
  }

  @Operation(summary = "Returns the entire registered users list")
  //@GetMapping("/candidates")
  public ResponseEntity<List<Candidate>> retrieveAllCandidates() {
    List<Candidate> CandidateList = CandidateRepo.findAll();
    return new ResponseEntity<>(CandidateList, HttpStatus.OK);
  }

  @Operation(summary = "Saves a new Candidate")
  @PostMapping(value = "/candidates", produces = MediaType.APPLICATION_JSON_VALUE, consumes = MediaType.APPLICATION_JSON_VALUE)
  public ResponseEntity<?> saveCandidate(@Valid @RequestBody Candidate Candidate) {
    try {
      Candidate = CandidateRepo.save(Candidate);
      return new ResponseEntity<>(Candidate, HttpStatus.CREATED);
    } catch (DataIntegrityViolationException ex) {
      throw new EmailException("Duplicated Email");
    }
  }

  @Operation(summary = "Delete the data of a user by Id")
  //@DeleteMapping("/candidates/{id}")
  public ResponseEntity<?> deleteCandidate(@PathVariable int id) {
    Candidate Candidate = CandidateRepo.findById(id)
        .orElseThrow(() -> new CandidateNotFoundException("Candidate not Found"));
    CandidateRepo.deleteById(Candidate.getId());
    return new ResponseEntity<>("DELETED", HttpStatus.OK);
  }

  @Operation(summary = "Updates the data of a user by Id")
  //@PutMapping("/candidates")
  public ResponseEntity<?> updateCandidate(@Valid @RequestBody Candidate Candidate) {
    Candidate updatedCandidate = CandidateRepo.save(Candidate);
    return new ResponseEntity<>(updatedCandidate, HttpStatus.OK);
  }

  //@GetMapping("/viewList")
  public ModelAndView registrationTable() {
    return new ModelAndView("joinUs_registrationTable.html")
        .addObject("candidates", CandidateRepo.findAll());
  }

  //@GetMapping("/export")
  public void exportIntoExcel(HttpServletResponse response) throws IOException {
    response.setContentType("application/octet-stream");
    DateFormat dateFormatter = new SimpleDateFormat("yyyy-MM-dd_HH:mm:ss");
    String currentDateTime = dateFormatter.format(new Date());
    String headerKey = "Content-Disposition";
    String headerValue = "attachment; filename=Candidates_" + currentDateTime + ".xlsx";
    response.setHeader(headerKey, headerValue);
    List<Candidate> listOfRecords = CandidateRepo.findAll();
    ExcelGenerator generator = new ExcelGenerator(listOfRecords);
    generator.generate(response);
  }

}
