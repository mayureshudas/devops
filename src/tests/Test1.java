package tests;

import java.util.concurrent.TimeUnit;

import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.firefox.FirefoxBinary;
import org.openqa.selenium.firefox.FirefoxDriver;
import org.testng.annotations.BeforeSuite;
import org.testng.annotations.Test;

public class Test1 {
	public static WebDriver driver;
	@BeforeSuite
	public static void setup(){
		System.setProperty("webdriver.gecko.driver", "/var/lib/geckodriver");
		System.setProperty("webdriver.firefox.bin", "/usr/bin/firefox");
		driver=new FirefoxDriver();
		//driver.manage().window().maximize();
		driver.manage().timeouts().implicitlyWait(40,TimeUnit.SECONDS);
		driver.get("http://ebsdevops03.compute-a436090.oraclecloud.internal:8000/OA_HTML/AppsLogin");
		
	}
	@Test
	public static void login(){
		driver.findElement(By.xpath("//form[@id='login']//input[@name='usernameField']")).sendKeys("MBHARMAL");
		driver.findElement(By.xpath("//form[@id='login']//input[@name='passwordField']")).sendKeys("Nov@2017");
		driver.findElement(By.xpath("//div[@class='control_box center']/button[@class='OraButton left']")).click();
		driver.manage().timeouts().implicitlyWait(40,TimeUnit.SECONDS);
		try {
			Thread.sleep(60000);
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		String message=driver.getTitle();
		System.out.println("Page title "+message);
	}
	}
	
	

