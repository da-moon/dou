package com.techm.cne.usersservice.services;

import com.techm.cne.usersservice.domain.User;
import com.techm.cne.usersservice.exceptions.NotFoundException;
import com.techm.cne.usersservice.repositories.UserRepository;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.LinkedList;
import java.util.List;

@Service
@AllArgsConstructor
public class UserService {

  private UserRepository userRepository;

  public List<User> getAll() {
    List<User> users = new LinkedList<>();
    userRepository.findAll().forEach(users::add);
    return users;
  }

  public User create(User user) {
    return userRepository.save(user);
  }

  public User getById(Long id) {
    return userRepository.findById(id).orElseThrow(NotFoundException::new);
  }
}
