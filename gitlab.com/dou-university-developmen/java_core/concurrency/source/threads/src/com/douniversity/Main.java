package com.douniversity;

public class Main {

    public static void main(String[] args) throws InterruptedException {
        System.out.println("hello "  + Thread.currentThread().getName());

        Thread t = new CustomThread();
        t.start();

        AnotherThread target = new AnotherThread();
        Thread t2 = new Thread(target);
        t2.start();
    }
}

class CustomThread extends Thread {
    @Override
    public void run() {
        try {
            Thread.sleep(5000);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        System.out.println("hello "  + Thread.currentThread().getName());
    }
}

class AnotherThread extends Parent implements Runnable {
    @Override
    public void run() {
        try {
            Thread.sleep(2000);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        System.out.println("hello "  + Thread.currentThread().getName());
    }
}

class Parent {
    public void anotherMethod(){

    }
}