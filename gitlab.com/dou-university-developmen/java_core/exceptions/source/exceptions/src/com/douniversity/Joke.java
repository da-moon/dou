package com.douniversity;


import org.codehaus.jackson.map.ObjectMapper;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;

public class Joke {

    public String search(String term) throws Exception {
        HttpClient client = HttpClient.newHttpClient();
        HttpRequest request = HttpRequest.newBuilder()
            .uri(URI.create("https://icanhazdadjoke.com/search?term=" + term))
            .header("Accept", "application/json")
            .build();
        HttpResponse<String> resp = client.send(request, HttpResponse.BodyHandlers.ofString());

        ObjectMapper objectMapper = new ObjectMapper();
        Page page = objectMapper.readValue(resp.body(), Page.class);

        return page.getResults().get(0).getJoke();
    }

}
