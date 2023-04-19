package com.techm.resume.builder.mock.config;

import org.springframework.http.MediaType;
import org.springframework.util.StreamUtils;
import org.springframework.core.io.ClassPathResource;
import org.springframework.context.annotation.Configuration;

import com.github.tomakehurst.wiremock.WireMockServer;
import com.github.tomakehurst.wiremock.client.WireMock;

import static com.github.tomakehurst.wiremock.client.WireMock.aResponse;
import static com.github.tomakehurst.wiremock.client.WireMock.equalToJson;
import static com.github.tomakehurst.wiremock.client.WireMock.matching;
import static com.github.tomakehurst.wiremock.client.WireMock.urlPathMatching;

import java.io.IOException;
import java.net.URISyntaxException;
import java.nio.charset.Charset;

@Configuration
public class WireMockServerConfig {

    private final transient static WireMockServer wireMockServer = new WireMockServer( 9091 );

    public WireMockServerConfig() throws URISyntaxException, IOException {
        wireMockServer.start();
        corsStub();
        userManagementExampleStub();
        professionalExperience();
        skillStub();
        education();
        certification();
        profile();
    }

    public static String readFileDataFromResources(String filename) throws IOException{
        return StreamUtils.copyToString(
            new ClassPathResource(filename).getInputStream(),
            Charset.defaultCharset()
        );
    }

    private void corsStub() throws URISyntaxException, IOException {
        wireMockServer.stubFor(
                WireMock.options(urlPathMatching("/api/v1/([-a-zA-Z0-9()@:%_+.~#?&//=]*)"))
                        .willReturn(aResponse()
                                .withHeader("Access-Control-Allow-Origin", "http://localhost:3000")
                                .withHeader("Access-Control-Allow-Headers", "accept, content-type, x-requested-with")
                                .withHeader("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE"))
        );
    }

    private void userManagementExampleStub() throws URISyntaxException, IOException {
        String fileData = readFileDataFromResources("/user-management/Example.json");

        wireMockServer.stubFor(
                WireMock.get("/api/v1/user-management/example")
                        .willReturn(aResponse()
                                .withHeader("Content-Type", MediaType.APPLICATION_JSON_VALUE)
                                .withBody(fileData))
        );
    }

    private void professionalExperience() throws URISyntaxException, IOException {
        String fileDataPost = readFileDataFromResources("/professional-experience/add-professional-experience.json");
        String fileDataGet = readFileDataFromResources("/professional-experience/get-professional-experience.json");
        String fileDataPut = readFileDataFromResources("/professional-experience/put-professional-experience.json");
        String jsonRequestBody = readFileDataFromResources("/professional-experience/request-professional-experience.json");

        wireMockServer.stubFor(
                WireMock.post("/api/v1/professional-experience")
                        .withRequestBody(equalToJson(jsonRequestBody))
                        .willReturn(aResponse()
                                .withStatus(201)
                                .withHeader("Content-Type", MediaType.APPLICATION_JSON_VALUE)
                                .withHeader("Access-Control-Allow-Origin", "*")
                                .withBody(fileDataPost))
        );

        wireMockServer.stubFor(
                WireMock.get(urlPathMatching("/api/v1/professional-experience/findByUserId"))
                        .withQueryParam("userId", matching("^[0-9a-fA-F]{8}\\b-[0-9a-fA-F]{4}\\b-[0-9a-fA-F]{4}\\b-[0-9a-fA-F]{4}\\b-[0-9a-fA-F]{12}$"))
                        .willReturn(aResponse()
                                .withStatus(200)
                                .withHeader("Content-Type", MediaType.APPLICATION_JSON_VALUE)
                                .withHeader("Access-Control-Allow-Origin", "*")
                                .withBody(fileDataGet))
        );

        wireMockServer.stubFor(
                WireMock.put(urlPathMatching("/api/v1/professional-experience/[0-9a-fA-F]{8}\\b-[0-9a-fA-F]{4}\\b-[0-9a-fA-F]{4}\\b-[0-9a-fA-F]{4}\\b-[0-9a-fA-F]{12}"))
                        .withRequestBody(equalToJson(jsonRequestBody))
                        .willReturn(aResponse()
                                .withStatus(200)
                                .withHeader("Content-Type", MediaType.APPLICATION_JSON_VALUE)
                                .withHeader("Access-Control-Allow-Origin", "*")
                                .withBody(fileDataPut))
        );

        wireMockServer.stubFor(
                WireMock.delete(urlPathMatching("/api/v1/professional-experience/[0-9a-fA-F]{8}\\b-[0-9a-fA-F]{4}\\b-[0-9a-fA-F]{4}\\b-[0-9a-fA-F]{4}\\b-[0-9a-fA-F]{12}"))
                        .willReturn(aResponse()
                                .withStatus(204)
                                .withHeader("Content-Type", MediaType.APPLICATION_JSON_VALUE)
                                .withHeader("Access-Control-Allow-Origin", "*"))
        );
    }

    private void certification() throws URISyntaxException, IOException {
        String fileDataPost = readFileDataFromResources("/professional-experience/add-certification.json");
        String fileDataGet = readFileDataFromResources("/professional-experience/get-certification.json");
        String fileDataPut = readFileDataFromResources("/professional-experience/put-certification.json");
        String jsonRequestBody = readFileDataFromResources("/professional-experience/request-certification.json");

        wireMockServer.stubFor(
                WireMock.post("/api/v1/certifications")
                        .withRequestBody(equalToJson(jsonRequestBody))
                        .willReturn(aResponse()
                                .withStatus(201)
                                .withHeader("Content-Type", MediaType.APPLICATION_JSON_VALUE)
                                .withHeader("Access-Control-Allow-Origin", "*")
                                .withBody(fileDataPost))
        );

        wireMockServer.stubFor(
                WireMock.get(urlPathMatching("/api/v1/certifications/findByUserId"))
                        .withQueryParam("userId", matching("^[0-9a-fA-F]{8}\\b-[0-9a-fA-F]{4}\\b-[0-9a-fA-F]{4}\\b-[0-9a-fA-F]{4}\\b-[0-9a-fA-F]{12}$"))
                        .willReturn(aResponse()
                                .withStatus(200)
                                .withHeader("Content-Type", MediaType.APPLICATION_JSON_VALUE,
                                        "Access-Control-Allow-Origin", "*")
                                .withBody(fileDataGet))
        );

        wireMockServer.stubFor(
                WireMock.put(urlPathMatching("/api/v1/certifications/[0-9a-fA-F]{8}\\b-[0-9a-fA-F]{4}\\b-[0-9a-fA-F]{4}\\b-[0-9a-fA-F]{4}\\b-[0-9a-fA-F]{12}"))
                        .withRequestBody(equalToJson(jsonRequestBody))
                        .willReturn(aResponse()
                                .withStatus(200)
                                .withHeader("Content-Type", MediaType.APPLICATION_JSON_VALUE)
                                .withHeader("Access-Control-Allow-Origin", "*")
                                .withBody(fileDataPut))
        );

        wireMockServer.stubFor(
                WireMock.delete(urlPathMatching("/api/v1/certifications/[0-9a-fA-F]{8}\\b-[0-9a-fA-F]{4}\\b-[0-9a-fA-F]{4}\\b-[0-9a-fA-F]{4}\\b-[0-9a-fA-F]{12}"))
                        .willReturn(aResponse()
                                .withStatus(204)
                                .withHeader("Content-Type", MediaType.APPLICATION_JSON_VALUE)
                                .withHeader("Access-Control-Allow-Origin", "*"))
        );
    }

    private void education() throws URISyntaxException, IOException {
        String fileDataPost = readFileDataFromResources("/education/add-education.json");
        String fileDataGet = readFileDataFromResources("/education/get-education.json");
        String fileDataPut = readFileDataFromResources("/education/put-education.json");
        String jsonRequestBody = readFileDataFromResources("/education/request-education.json");

        wireMockServer.stubFor(
                WireMock.post("/api/v1/education")
                        .withRequestBody(equalToJson(jsonRequestBody))
                        .willReturn(aResponse()
                                .withStatus(201)
                                .withHeader("Content-Type", MediaType.APPLICATION_JSON_VALUE)
                                .withHeader("Access-Control-Allow-Origin", "*")
                                .withBody(fileDataPost))
        );

        wireMockServer.stubFor(
                WireMock.get(urlPathMatching("/api/v1/education/findByUserId"))
                        .withQueryParam("userId", matching("^[0-9a-fA-F]{8}\\b-[0-9a-fA-F]{4}\\b-[0-9a-fA-F]{4}\\b-[0-9a-fA-F]{4}\\b-[0-9a-fA-F]{12}$"))
                        .willReturn(aResponse()
                                .withStatus(200)
                                .withHeader("Content-Type", MediaType.APPLICATION_JSON_VALUE)
                                .withHeader("Access-Control-Allow-Origin", "*")
                                .withBody(fileDataGet))
        );

        wireMockServer.stubFor(
                WireMock.put(urlPathMatching("/api/v1/education/[0-9a-fA-F]{8}\\b-[0-9a-fA-F]{4}\\b-[0-9a-fA-F]{4}\\b-[0-9a-fA-F]{4}\\b-[0-9a-fA-F]{12}"))
                        .withRequestBody(equalToJson(jsonRequestBody))
                        .willReturn(aResponse()
                                .withStatus(200)
                                .withHeader("Content-Type", MediaType.APPLICATION_JSON_VALUE)
                                .withHeader("Access-Control-Allow-Origin", "*")
                                .withBody(fileDataPut))
        );

        wireMockServer.stubFor(
                WireMock.delete(urlPathMatching("/api/v1/education/[0-9a-fA-F]{8}\\b-[0-9a-fA-F]{4}\\b-[0-9a-fA-F]{4}\\b-[0-9a-fA-F]{4}\\b-[0-9a-fA-F]{12}"))
                        .willReturn(aResponse()
                                .withStatus(204)
                                .withHeader("Content-Type", MediaType.APPLICATION_JSON_VALUE)
                                .withHeader("Access-Control-Allow-Origin", "*"))
        );
    }

    private void skillStub() throws URISyntaxException, IOException {
        String fileDataPost = readFileDataFromResources("/skill/add-skill.json");
        String fileDataGetCatalog = readFileDataFromResources("/skill/skill-catalog.json");
        String jsonRequestBody = readFileDataFromResources("/skill/request-skill.json");

        wireMockServer.stubFor(
                WireMock.get("/api/v1/skill")
                        .willReturn(aResponse()
                                .withStatus(200)
                                .withHeader("Content-Type", MediaType.APPLICATION_JSON_VALUE)
                                .withHeader("Access-Control-Allow-Origin", "*")
                                .withBody(fileDataGetCatalog))
        );

        wireMockServer.stubFor(
                WireMock.post("/api/v1/skill")
                        .withRequestBody(equalToJson(jsonRequestBody))
                        .willReturn(aResponse()
                                .withStatus(201)
                                .withHeader("Content-Type", MediaType.APPLICATION_JSON_VALUE)
                                .withHeader("Access-Control-Allow-Origin", "*")
                                .withBody(fileDataPost))
        );

        wireMockServer.stubFor(
                WireMock.delete(urlPathMatching("/api/v1/skill/[0-9a-fA-F]{8}\\b-[0-9a-fA-F]{4}\\b-[0-9a-fA-F]{4}\\b-[0-9a-fA-F]{4}\\b-[0-9a-fA-F]{12}"))
                        .willReturn(aResponse()
                                .withStatus(204)
                                .withHeader("Content-Type", MediaType.APPLICATION_JSON_VALUE)
                                .withHeader("Access-Control-Allow-Origin", "*"))
        );
    }

    private void profile() throws URISyntaxException, IOException {
        String fileDataGet = readFileDataFromResources("/profile/get-profile-summary.json");
        String fileDataPut = readFileDataFromResources("/profile/put-profile-summary.json");
        String jsonRequestBody = readFileDataFromResources("/profile/request-profile-summary.json");

        wireMockServer.stubFor(
                WireMock.get(urlPathMatching("/api/v1/profile/summary/findByUserId"))
                        .withQueryParam("userId", matching("^[0-9a-fA-F]{8}\\b-[0-9a-fA-F]{4}\\b-[0-9a-fA-F]{4}\\b-[0-9a-fA-F]{4}\\b-[0-9a-fA-F]{12}$"))
                        .willReturn(aResponse()
                                .withStatus(200)
                                .withHeader("Content-Type", MediaType.APPLICATION_JSON_VALUE)
                                .withHeader("Access-Control-Allow-Origin", "*")
                                .withBody(fileDataGet))
        );

        wireMockServer.stubFor(
                WireMock.put(urlPathMatching("/api/v1/profile/summaries/[0-9a-fA-F]{8}\\b-[0-9a-fA-F]{4}\\b-[0-9a-fA-F]{4}\\b-[0-9a-fA-F]{4}\\b-[0-9a-fA-F]{12}"))
                        .withRequestBody(equalToJson(jsonRequestBody))
                        .willReturn(aResponse()
                                .withStatus(200)
                                .withHeader("Content-Type", MediaType.APPLICATION_JSON_VALUE)
                                .withHeader("Access-Control-Allow-Origin", "*")
                                .withBody(fileDataPut))
        );
    }
}
