package com.douniversity;

import org.codehaus.jackson.annotate.JsonProperty;

import java.util.List;

public class Page {
    private long currentPage;
    private long limit;
    private long nextPage;
    private long previousPage;
    private List<Result> results;
    private String searchTerm;
    private long status;
    private long totalJokes;
    private long totalPages;

    @JsonProperty("current_page")
    public long getCurrentPage() {
        return currentPage;
    }

    @JsonProperty("current_page")
    public void setCurrentPage(long value) {
        this.currentPage = value;
    }

    @JsonProperty("limit")
    public long getLimit() {
        return limit;
    }

    @JsonProperty("limit")
    public void setLimit(long value) {
        this.limit = value;
    }

    @JsonProperty("next_page")
    public long getNextPage() {
        return nextPage;
    }

    @JsonProperty("next_page")
    public void setNextPage(long value) {
        this.nextPage = value;
    }

    @JsonProperty("previous_page")
    public long getPreviousPage() {
        return previousPage;
    }

    @JsonProperty("previous_page")
    public void setPreviousPage(long value) {
        this.previousPage = value;
    }

    @JsonProperty("results")
    public List<Result> getResults() {
        return results;
    }

    @JsonProperty("results")
    public void setResults(List<Result> value) {
        this.results = value;
    }

    @JsonProperty("search_term")
    public String getSearchTerm() {
        return searchTerm;
    }

    @JsonProperty("search_term")
    public void setSearchTerm(String value) {
        this.searchTerm = value;
    }

    @JsonProperty("status")
    public long getStatus() {
        return status;
    }

    @JsonProperty("status")
    public void setStatus(long value) {
        this.status = value;
    }

    @JsonProperty("total_jokes")
    public long getTotalJokes() {
        return totalJokes;
    }

    @JsonProperty("total_jokes")
    public void setTotalJokes(long value) {
        this.totalJokes = value;
    }

    @JsonProperty("total_pages")
    public long getTotalPages() {
        return totalPages;
    }

    @JsonProperty("total_pages")
    public void setTotalPages(long value) {
        this.totalPages = value;
    }
}