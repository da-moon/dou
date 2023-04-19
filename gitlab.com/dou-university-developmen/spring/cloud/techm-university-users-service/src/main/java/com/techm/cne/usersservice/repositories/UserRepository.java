package com.techm.cne.usersservice.repositories;

import com.techm.cne.usersservice.domain.User;
import org.springframework.data.repository.CrudRepository;

public interface UserRepository extends CrudRepository<User, Long> {

}
