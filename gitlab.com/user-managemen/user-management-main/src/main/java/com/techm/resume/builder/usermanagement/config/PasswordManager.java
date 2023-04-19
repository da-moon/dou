/**
 * This file has the Password related methods.
 *
 * <p>Methods: passwordEncoder, getMd5
 *
 * @since 0.0.1
 * @author TechMahindra
 * @version 0.0.1
 */

package com.techm.resume.builder.usermanagement.config;

import lombok.extern.slf4j.Slf4j;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.crypto.password.PasswordEncoder;

import java.math.BigInteger;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.Objects;

/**
 * We define the functions to encode the passwords.
 */
@Slf4j
@Configuration
public class PasswordManager {

    private static final int HASH_LENGTH = 32;
    private static final int NUMBER_LENGTH = 16;

    //In this function we tell spring security that we want to use MD5 encryption
    @Bean
    public PasswordEncoder passwordEncoder() {
        return new PasswordEncoder() {
            @Override
            public String encode(final CharSequence charSequence) {
                return getMd5(charSequence.toString());
            }

            @Override
            public boolean matches(final CharSequence charSequence, final String encodedPass) {
                return Objects.equals(getMd5(charSequence.toString()), encodedPass);
            }
        };
    }

    //Function to calculate the MD5
    public static String getMd5(final String input) {

        StringBuilder hashText = new StringBuilder();
        //String finalString = null;

        try {

            // Static getInstance method is called with hashing SHA
            final MessageDigest messageDigestInstance = MessageDigest.getInstance("MD5");

            // digest() method called to calculate message digest of an input and return array of byte
            final byte[] messageDigest = messageDigestInstance.digest(input.getBytes(StandardCharsets.UTF_8));

            // Convert byte array into signum representation
            final BigInteger number = new BigInteger(1, messageDigest);

            // Convert message digest into hex value
            hashText = hashText.append(number.toString(NUMBER_LENGTH));

            while (hashText.length() < HASH_LENGTH) {
                hashText.insert(0, "0");
            }
        }

        // For specifying wrong message digest algorithms
        catch (NoSuchAlgorithmException exception) {
            if (log.isDebugEnabled()) {
                log.debug("Exception thrown" + " for incorrect algorithm: " + exception);
            }
        }

        return hashText.toString();

    }
}
