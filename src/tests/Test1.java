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
		//System.setProperty("webdriver.chrome.driver", "C:\\Users\\Administrator\\Downloads\\chromedriver_win32\\chromedriver.exe");
		 //driver = new ChromeDriver();
		
		System.setProperty("webdriver.gecko.driver", "/var/lib/geckodriver");
		System.setProperty("webdriver.firefox.bin", "/usr/bin/firefox");
		/*DesiredCapabilities capabilities = DesiredCapabilities.firefox();
		FirefoxOptions options = new FirefoxOptions();
			
		options.addPreference("log", "{level: trace}");
		
			capabilities.setCapability("marionette", true);
				capabilities.setCapability("moz:firefoxOptions", options);
		

			
		driver = new FirefoxDriver(capabilities);*/
		driver=new FirefoxDriver();
		//driver.manage().window().maximize();
		
		driver.manage().timeouts().implicitlyWait(240,TimeUnit.SECONDS);
		driver.get("http://ebsdevops03.compute-a436090.oraclecloud.internal:8000/OA_HTML/AppsLogin");
		
	}
	@Test
	public void login(){
		driver.findElement(By.xpath("//form[@id='login']//input[@name='usernameField']")).sendKeys("MBHARMAL");
		driver.findElement(By.xpath("//form[@id='login']//input[@name='passwordField']")).sendKeys("Nov@2017");
		driver.findElement(By.xpath("//*[@id='ButtonBox']/button")).click();
		
		/*try {
			Thread.sleep(60000);
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}*/
		
		String message=driver.getTitle();
		System.out.println("Page title "+message);
	}
	@Test
	public void searchProduct(){
		
		driver.findElement(By.xpath("//form[@name='DefaultFormName']//table[@class='xhq']//a[@class='OraUniversalNavigator']")).click();
		driver.findElement(By.xpath("//form[@name='DefaultFormName']//table[@class='xhq']//a[@class='OraUniversalNavigator']//input[@id='navSearch']")).sendKeys("iprocurement");
		/*try {
			Thread.sleep(60000);
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}*/
          //driver.findElement(By.xpath("//form[@name='DefaultFormName']//table//table[@class='xhq']//tr[@class='x8e']//div[@id='navContainer0']//div[@class='listContainer']//a[@title='iProcurement']")).click();
		
		driver.findElement(By.xpath("//form[@name='DefaultFormName']//table//table[@class='xhq']//tr[@class='x8e']//div[@id='navContainer0']//div[@id='navContainer1']//div[@class='listContainer']//a[@title='iProcurement Home Page (iProcurement)']")).click();
		/*try {
			Thread.sleep(60000);
			System.out.println("clicked on procurement ");
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}*/
		
		driver.findElement(By.xpath("//form[@name='DefaultFormName']//table[@id='SearchTextInput__xc_']//input[@id='SearchTextInput']")).sendKeys("CM45329");
		
		driver.findElement(By.xpath("//form[@name='DefaultFormName']//button[@id='SearchBoxGo']")).click();
		//WebElement price=driver.findElement(By.xpath("//form[@name='DefaultFormName']//table[@id='ControlsTableLayout']//tr[@id='SearchResultsRow']//table[@id='SearchResultsTableRN1:Price:0__xc_']//span[@class='OraDataText MessageComponentLayoutText']"));
		
		
		
			WebElement price=driver.findElement(By.xpath("//form[@name='DefaultFormName']//table[@id='ControlsTableLayout']//tr[@id='SearchResultsRow']//table[@id='SearchResultsTableRN1:Price:0__xc_']//span[@class='OraDataText MessageComponentLayoutText']"));
			if(price.isDisplayed()){
				
				System.out.println("Price of item is "+ price.getText());
				}
				else{
					System.out.println("Issue with price element");
				}
		
		
	}
	
}
