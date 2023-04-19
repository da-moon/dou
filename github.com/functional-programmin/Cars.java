import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import java.util.Random;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

public class Cars {

    public static void main(String[] args) throws InterruptedException {
        State state = new State();
        new Cars().race(state);
    }

    private void race(State state) throws InterruptedException {
        draw(state);
        int maxSteps = state.carPositions.stream()
                .reduce(1, (max, item) -> item > max ? item : max);
        if (maxSteps < state.steps) {
            race(runStepOfRace(state));
        }
    }

    private void draw(State state) {
        System.out.println();
        IntStream.range(0, state.carNames.size())
                .mapToObj(i -> outputCar(state.carNames.get(i), state.carPositions.get(i)))
                .forEach(System.out::println);
        System.out.println();
    }

    private String outputCar(String carName, int carPosition) {
        String distance = String.join("", Collections.nCopies(carPosition, "-"));
        return String.format("%-12s %-7s|", carName, distance);
    }

    private State runStepOfRace(State state) throws InterruptedException {
        Thread.sleep(state.stepTime * 1000);
        State newState = new State();
        newState.steps = state.steps;
        newState.stepTime = state.stepTime;
        newState.carPositions = moveCars(state.carPositions);
        newState.carNames = state.carNames;
        return newState;
    }

    private List<Integer> moveCars(List<Integer> carPositions) {
        return carPositions.stream()
                .map(x -> new Random().nextInt(10) > 3 ? x + 1 : x)
                .collect(Collectors.toList());
    }


    private static class State {
        int steps = 7;
        int stepTime = 3;
        List<Integer> carPositions = Arrays.asList(1, 1, 1);
        List<String> carNames = Arrays.asList("batmobile", "meteor", "turtle van");
    }
}
