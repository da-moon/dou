package utils.reports;

import com.aventstack.extentreports.ExtentReports;
import com.aventstack.extentreports.reporter.ExtentSparkReporter;
import tests.BaseTest;
public class ExtentManager extends BaseTest {
    public static final ExtentReports extentReports = new ExtentReports();

    public synchronized static ExtentReports createExtentReports() {
        ExtentSparkReporter reporter = new ExtentSparkReporter(properties.getProperty("REPORTERPATH"));
        reporter.config().setReportName("Tech Mahindra Resume Builder Automation Framework");
        extentReports.attachReporter(reporter);

        return extentReports;
    }
}
