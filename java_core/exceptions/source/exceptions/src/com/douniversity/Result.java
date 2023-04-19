package com.douniversity;

import org.codehaus.jackson.annotate.JsonProperty;

public class Result {
    private String id;
    private String joke;

    @JsonProperty("id")
    public String getID() {
        return id;
    }

    @JsonProperty("id")
    public void setID(String value) {
        this.id = value;
    }

    @JsonProperty("joke")
    public String getJoke() {
        return joke;
    }

    @JsonProperty("joke")
    public void setJoke(String value) {
        this.joke = value;
    }
}