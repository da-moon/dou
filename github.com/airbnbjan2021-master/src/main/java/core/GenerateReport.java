package core;

import org.testng.ITestContext;
import org.testng.ITestListener;
import org.testng.ITestResult;

public class GenerateReport implements ITestListener {

    @Override
    public void onStart(ITestContext arg0) {
        System.out.println("===========================");
        System.out.println("Begin test: " + arg0.getName());
        System.out.println("===========================");
    }

    @Override
    public void onTestStart(ITestResult arg0) {
        System.out.println("-----------------------------");
        System.out.println(" Starting test: " + arg0.getName());
        System.out.println("-----------------------------");
    }

    @Override
    public void onTestSuccess(ITestResult arg0) {
        System.out.println("-----------------------------");
        System.out.println(" Test passed: " + arg0.getName());
        System.out.println("-----------------------------");
    }

    @Override
    public void onTestFailure(ITestResult arg0) {
        System.out.println("-----------------------------");
        System.out.println(" Test failed: " + arg0.getName());
        System.out.println("-----------------------------");
    }

    @Override
    public void onTestSkipped(ITestResult arg0) {

        System.out.println(" Test ignored: " + arg0.getName());

    }

    @Override
    public void onFinish(ITestContext arg0) {
        System.out.println("===========================");
        System.out.println("End test: " + arg0.getName());
        System.out.println("===========================");
    }

    @Override
    public void onTestFailedButWithinSuccessPercentage(ITestResult arg0) {

        // TODO Auto-generated method stub

    }

}