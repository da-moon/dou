/**
 * This file has all the mappers.
 *
 * <p>Methods: mapper
 *
 * @since 0.0.1
 * @author TechMahindra
 * @version 0.0.1
 */

package com.techm.resume.builder.usermanagement.config;

import org.modelmapper.ModelMapper;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

/**
 * We define the mappers.
 */
@Configuration
public class MappingConfig {

    @Bean
    public ModelMapper mapper() {
        return new ModelMapper();
    }

}
