package tests;

import java.util.concurrent.TimeUnit;
import org.openqa.selenium.firefox.FirefoxOptions;
import org.openqa.selenium.remote.DesiredCapabilities;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.firefox.FirefoxDriver;
import org.openqa.selenium.firefox.FirefoxBinary;
import org.testng.annotations.BeforeSuite;
import org.testng.annotations.Test;

public class Test1 {
	public  WebDriver driver;
	@BeforeSuite
	public void setup(){
		System.setProperty("webdriver.chrome.driver", "C:\\Users\\Administrator\\Downloads\\chromedriver_win32\\chromedriver.exe");
		 driver = new ChromeDriver();
		
		/*System.setProperty("webdriver.gecko.driver", "/var/lib/geckodriver");
		System.setProperty("webdriver.firefox.bin", "/usr/bin/firefox");
		DesiredCapabilities capabilities = DesiredCapabilities.firefox();
		FirefoxOptions options = new FirefoxOptions();
			
		options.addPreference("log", "{level: trace}");
		
			capabilities.setCapability("marionette", true);
				capabilities.setCapability("moz:firefoxOptions", options);
		

			
		driver = new FirefoxDriver(capabilities);*/
		//driver=new FirefoxDriver();
		driver.manage().window().maximize();
		
		driver.manage().timeouts().implicitlyWait(100,TimeUnit.SECONDS);
		driver.get("http://ebsdevops03.compute-602842092.oraclecloud.internal:8000");
		
	}
	@Test
	public void login(){
		driver.findElement(By.xpath("//form[@id='login']//input[@name='usernameField']")).sendKeys("MBHARMAL");
		driver.findElement(By.xpath("//form[@id='login']//input[@name='passwordField']")).sendKeys("Nov@2017");
		driver.findElement(By.xpath("//*[@id='ButtonBox']/button")).click();
		
		try {
			Thread.sleep(10000);
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		String message=driver.getTitle();
		System.out.println("Page title "+message);
	}
	@Test
	public void searchProduct(){
		
		driver.findElement(By.xpath("//form[@name='DefaultFormName']//table[@class='xhq']//a[@class='OraUniversalNavigator']")).click();
		driver.findElement(By.xpath("//form[@name='DefaultFormName']//table[@class='xhq']//a[@class='OraUniversalNavigator']//input[@id='navSearch']")).sendKeys("Functional Administrator");
		try {
			Thread.sleep(10000);
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	      driver.findElement(By.xpath("//form[@name='DefaultFormName']//table//table[@class='xhq']//tr[@class='x8e']//div[@id='navContainer0']//div[@class='listContainer']//a[@title='Functional Administrator']")).click();
	      driver.findElement(By.xpath("//form[@name='DefaultFormName']//table//table[@class='xhq']//tr[@class='x8e']//div[@id='navContainer0']//div[@id='navContainer1']//div[@class='listContainer']//a[@title='Home']")).click();
	      driver.findElement(By.xpath("//form[@name='DefaultFormName']//table//table[@class='x1k']//a[@title='Core Services']")).click();
	      driver.findElement(By.xpath("//form[@name='DefaultFormName']//table//td[@class='x9y']//a[@title='Caching Framework']")).click();
	      driver.findElement(By.xpath("//form[@name='DefaultFormName']//table//table[@class='x83']//a[@title='Global Configuration']")).click();
	      driver.findElement(By.xpath("//form[@name='DefaultFormName']//table[@class='x6w']//table//a[@id='N49']")).click();
	      
	      driver.get("http://ebsdevops03.compute-602842092.oraclecloud.internal:8000");
			driver.findElement(By.xpath("//form[@id='login']//input[@name='usernameField']")).sendKeys("MBHARMAL");
			driver.findElement(By.xpath("//form[@id='login']//input[@name='passwordField']")).sendKeys("Nov@2017");
			driver.findElement(By.xpath("//*[@id='ButtonBox']/button")).click();
			
			driver.findElement(By.xpath("//form[@name='DefaultFormName']//table[@class='xhq']//a[@class='OraUniversalNavigator']")).click();
			driver.findElement(By.xpath("//form[@name='DefaultFormName']//table[@class='xhq']//a[@class='OraUniversalNavigator']//input[@id='navSearch']")).sendKeys("iprocurement");
			try {
				Thread.sleep(10000);
			} catch (InterruptedException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
	          driver.findElement(By.xpath("//form[@name='DefaultFormName']//table//table[@class='xhq']//tr[@class='x8e']//div[@id='navContainer0']//div[@class='listContainer']//a[@title='iProcurement']")).click();
			
			driver.findElement(By.xpath("//form[@name='DefaultFormName']//table//table[@class='xhq']//tr[@class='x8e']//div[@id='navContainer0']//div[@id='navContainer1']//div[@class='listContainer']//a[@title='iProcurement Home Page']")).click();
			
			driver.findElement(By.xpath("//form[@name='DefaultFormName']//table//table[@class='x18']//a[@title='Non-Catalog Request']")).click();
	}
	
}
