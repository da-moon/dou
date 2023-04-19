package com.douniversity;

public class Wait {

    public static void main(String[] args) {
        Joy joy = new Joy();
        Thread t = new Thread(joy::guardedJoy);
        t.start();

        Thread t2 = new Thread(joy::notifyJoy);
        t2.start();
    }

}

class Joy {

    private boolean joy;

    public synchronized void guardedJoy() {
        // Simple loop guard. Wastes
        // processor time. Don't do this!
        while (!joy) {
            System.out.println("while");
            try {
                wait();
            } catch (InterruptedException e) {}
        }
        System.out.println("Joy has been achieved!");
    }

    public synchronized void notifyJoy() {
        joy = true;
        notifyAll();
    }
}
