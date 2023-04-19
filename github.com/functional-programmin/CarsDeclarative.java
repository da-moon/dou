// Declarative code shows WHAT to do
import java.util.Random;

public class CarsDeclarative {

    public static int time = 5;
    public static int[] car_positions = {1, 1, 1};

    public static void moveCars() {
        Random rand = new Random();
        for (int i = 0; i < car_positions.length; i++) {
            int randomInt = rand.nextInt(5) + 1;
            if (randomInt > 3) {
                car_positions[i] += 1;
            }
        }
    }

    public static void drawCar(int car_position) {
        for (int i = 0; i < car_positions[car_position]; i++) {
            System.out.print("-");
        }
        System.out.println("");
    }

    public static void runStepOfRace() {
        time--;
        moveCars();
    }

    public static void draw() {
        System.out.println("");
        for (int i = 0; i < car_positions.length; i++) {
            drawCar(i);
        }
    }

    public static void main (String []args) {

        while (time > 0) {
            runStepOfRace();
            draw();
        }
    }
}
