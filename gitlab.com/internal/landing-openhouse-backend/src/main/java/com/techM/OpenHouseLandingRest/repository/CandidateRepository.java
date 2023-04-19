package com.techM.OpenHouseLandingRest.repository;

import com.techM.OpenHouseLandingRest.model.Candidate;
import org.springframework.data.jpa.repository.JpaRepository;

public interface CandidateRepository extends JpaRepository<Candidate, Integer> {}
