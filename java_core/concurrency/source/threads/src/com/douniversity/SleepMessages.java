package com.douniversity;

public class SleepMessages {

    public static void main(String[] args) throws InterruptedException {
        String[] importantInfo = {
            "alfa",
            "is",
            "the",
            "best"
        };

        for (String s : importantInfo) {

            Thread.sleep(4000);

            System.out.println(s);
        }
    }
}