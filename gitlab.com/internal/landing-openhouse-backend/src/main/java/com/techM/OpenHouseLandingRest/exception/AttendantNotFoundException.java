package com.techM.OpenHouseLandingRest.exception;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ResponseStatus;

@ResponseStatus(HttpStatus.NOT_FOUND)
public class AttendantNotFoundException extends RuntimeException {

  /** */
  private static final long serialVersionUID = 1L;

  public AttendantNotFoundException(String message) {
    super(message);
  }
}
