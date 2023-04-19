// Imperative code shows HOW to solve a problem
import java.util.Random;

public class CarsImperative {

    public static void main (String []args) {

        int time = 5;
        int[] car_positions = {1, 1, 1};

        Random rand = new Random();

        while (time > 0) {
            // decrease time
            time--;

            for (int i = 0; i < car_positions.length; i++) {

                int randomInt = rand.nextInt(5) + 1;

                // move car
                if (randomInt > 3) {
                    car_positions[i] += 1;
                }

                // draw car
                for (int j = 0; j < car_positions[i]; j++) {
                    System.out.print("-");
                }

                System.out.println("");
            }

            System.out.println("");
        }
    }
}
