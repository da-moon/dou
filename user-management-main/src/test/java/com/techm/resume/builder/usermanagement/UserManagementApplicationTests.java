package com.techm.resume.builder.usermanagement;

import com.techm.resume.builder.usermanagement.api.UserApi;
import com.techm.resume.builder.usermanagement.api.request.LoginRequest;
import com.techm.resume.builder.usermanagement.api.request.NewUserRequest;
import com.techm.resume.builder.usermanagement.dto.UserDto;
import com.techm.resume.builder.usermanagement.entity.Role;
import com.techm.resume.builder.usermanagement.entity.UserEntity;

import org.junit.jupiter.api.Test;

import static org.junit.Assert.assertThrows;
import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertNotEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.boot.test.context.SpringBootTest;

import org.springframework.web.server.ResponseStatusException;

import java.util.UUID;

@SpringBootTest
public class UserManagementApplicationTests {

    @Autowired
    private UserApi userApi;

    private LoginRequest loginRequest;
    private NewUserRequest newUserRequest;
    private UserEntity user;
    private UserDto userDto;

    public UserManagementApplicationTests() {
        this.setLoginRequest();
        this.setNewUserRequest();
        this.setUserDto();
        this.setUser();
    }

    private void setLoginRequest() {
        this.loginRequest = new LoginRequest();
        this.loginRequest.setEmail("juan@digital.com");
        this.loginRequest.setPassword("Pas123");
    }

    private void setNewUserRequest() {
        this.newUserRequest = new NewUserRequest();
        this.newUserRequest.setEmail("juan@digital.com");
        this.newUserRequest.setFirstName("Juan Pablo");
        this.newUserRequest.setLastName("Guitron");
        this.newUserRequest.setPassword("Pas123");
        this.newUserRequest.setRole(Role.ADMIN);
    }

    private void setUserDto() {
        this.userDto = new UserDto();
        this.userDto.setEmail("juan@digital.com");
        this.userDto.setFirstName("Juan Pablo");
        this.userDto.setLastName("Guitron");
        this.userDto.setRole("ADMIN");
    }

    private void setUser() {
        this.user = new UserEntity();
        this.user.setUserId(UUID.randomUUID());
        this.user.setEmail("juan@digital.com");
        this.user.setFirstName("Juan Pablo");
        this.user.setLastName("Guitron");
        this.user.setPassword("Pas123");
        this.user.setRole(Role.ADMIN);
    }

    @Test
    public void contextLoads() {
        assertTrue(true);
    }

    @Test
    public void main() {
        UserManagementApplication.main(new String[] {});
    }

    public static String generateRandomEmail(String emailDomain) {
        return String.format("%s@%s", System.currentTimeMillis() / 1000, emailDomain);
    }

    @Test
    void createNewUserTest() {
        final ResponseEntity<UserDto> createdUser;
        final ResponseEntity<UserDto> loginUser;
        final ResponseEntity<UserDto> loginUserWithUuid;
        final UUID newUserUuid;
        final String generatedString = generateRandomEmail("techmahindra.com");

        this.newUserRequest.setEmail(generatedString);
        this.loginRequest.setEmail(generatedString);

        createdUser = this.userApi.createNewUser(this.newUserRequest);
        loginUser = this.userApi.login(this.loginRequest);
        newUserUuid = createdUser.getBody().getUserId();
        loginUserWithUuid = this.userApi.getUser(newUserUuid);

        final Throwable exception = assertThrows(ResponseStatusException.class,
            () -> this.userApi.getUser(UUID.randomUUID()));
        assertEquals("404 NOT_FOUND \"User not found\"", exception.getMessage());

        assertEquals(createdUser, loginUser);
        assertEquals(createdUser, loginUserWithUuid);
    }

    @Test
    public void newUserRequestTest() {
        final NewUserRequest requestMiguel = new NewUserRequest();
        requestMiguel.setEmail("Miguel@digital.com");
        requestMiguel.setFirstName("Miguel");
        requestMiguel.setLastName("Gonzalez");
        requestMiguel.setPassword("Pas456");
        requestMiguel.setRole(Role.USER);

        assertNotEquals(204050173, this.newUserRequest.hashCode());
        assertFalse(this.newUserRequest.equals(requestMiguel));
        assertTrue(this.newUserRequest.equals(this.newUserRequest));
        assertEquals("juan@digital.com", this.newUserRequest.getEmail());
        assertEquals("Juan Pablo", this.newUserRequest.getFirstName());
        assertEquals("Guitron", this.newUserRequest.getLastName());
        assertEquals("Pas123", this.newUserRequest.getPassword());
        assertEquals(Role.ADMIN, this.newUserRequest.getRole());
    }

    @Test
    public void loginRequestRequestTest() {
        final LoginRequest requestMiguel = new LoginRequest();
        requestMiguel.setEmail("Miguel@digital.com");
        requestMiguel.setPassword("Pas456");

        assertNotEquals(204050173, this.loginRequest.hashCode());
        assertFalse(this.loginRequest.equals(requestMiguel));
        assertTrue(this.loginRequest.equals(this.loginRequest));
        assertEquals("juan@digital.com", this.loginRequest.getEmail());
        assertEquals("Pas123", this.loginRequest.getPassword());
    }

    @Test
    public void userDtoTest() {
        final UserDto miguelDto = new UserDto();
        miguelDto.setEmail("Miguel@digital.com");
        miguelDto.setFirstName("Miguel");
        miguelDto.setLastName("Gonzalez");
        miguelDto.setRole("USER");

        assertFalse(this.userDto.equals(miguelDto));
        assertTrue(this.userDto.equals(this.userDto));

        assertEquals("UserDto(userId=null, email=juan@digital.com, firstName=Juan Pablo, "
            .concat("lastName=Guitron, role=ADMIN)"), this.userDto.toString());

        assertEquals(843118894, this.userDto.hashCode());
        assertNotEquals(204050444, this.userDto.hashCode());

        assertEquals("juan@digital.com", this.userDto.getEmail());
        assertEquals("Juan Pablo", this.userDto.getFirstName());
        assertEquals("Guitron", this.userDto.getLastName());
        assertEquals("ADMIN", this.userDto.getRole());
    }

    @Test
    public void userEntityTest() {
        final UserEntity miguelUser = new UserEntity();
        miguelUser.setUserId(UUID.randomUUID());
        miguelUser.setEmail("Miguel@digital.com");
        miguelUser.setFirstName("Miguel");
        miguelUser.setLastName("Gonzalez");
        miguelUser.setPassword("Pas456");
        miguelUser.setRole(Role.USER);

        assertFalse(this.user.equals(miguelUser));
        assertTrue(this.user.equals(this.user));
        assertNotEquals(204050173, this.user.hashCode());

        assertNotEquals("123e4567-e89b-12d3-a456-426614174000", this.user.getUserId());
        assertEquals("Pas123", this.user.getPassword());
        assertEquals("juan@digital.com", this.user.getEmail());
        assertEquals("Juan Pablo", this.user.getFirstName());
        assertEquals("Guitron", this.user.getLastName());
        assertEquals(Role.ADMIN, this.user.getRole());
    }
}
