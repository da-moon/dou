package com.douniversity;

public class Counter {
    private int c = 0;

    public void increment() {
        try {
            Thread.sleep(55);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }

        synchronized (this) {
            c++;
            System.out.println(c);
        }
    }

    public static void main(String[] args) {
        Counter counter = new Counter();

        for (int i = 0; i < 100; i++) {
            Thread thread = new Thread(counter::increment);
            thread.start();
        }
    }
}
