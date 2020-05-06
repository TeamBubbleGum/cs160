import unittest
import os
from random import randint
from appium import webdriver
from time import sleep
from selenium.webdriver.common.keys import Keys

class LoginTests(unittest.TestCase):

    def setUp(self):
            app = ('/Users/tonypark/Library/Developer/Xcode/DerivedData/myUnloadIOS-hjrqfdrqfcihqfdnhzkuixtxjpta/Build/Products/Debug-iphonesimulator/myUnloadIOS.app')
            self.driver = webdriver.Remote(
                command_executor='http://127.0.0.1:4723/wd/hub',
                desired_capabilities={
                    'app': app,
                    'platformName': 'iOS',
                    'platformVersion': '13.2',
                    'deviceName': 'iPhone 11 Pro Max'
                }
            )

    def tearDown(self):
        self.driver.quit()

    #test to see if username is being passed correctly
    def testUsernameField(self):
            usernameTF = self.driver.find_element_by_accessibility_id('usernameBox')
            usernameTF.send_keys("test@unload.com")
            usernameTF.send_keys(Keys.RETURN)
            sleep(1)
            self.assertEqual(usernameTF.get_attribute("value"), "test@unload.com")

    #test to see if the psasword is being masked
    def testPasswordField(self):
            passwordTF = self.driver.find_element_by_accessibility_id('passwordBox')
            passwordTF.send_keys("validPW")
            passwordTF.send_keys(Keys.RETURN)
            sleep(1)
            self.assertNotEqual(passwordTF.get_attribute("value"), "validPW")

    
    #test to see if filling out nothing in the username and password field then pressing login will give us an error message
    def testLoginNothing(self):
            self.driver.find_element_by_accessibility_id('Login').click()
            sleep(1)
            self.driver.find_element_by_accessibility_id('OK').click() 
            self.assertEqual(1, 1)
    
    #test to see if filling out just the username field then pressing login will give us an error message
    def testLoginUsernameOnly(self):
            usernameTF = self.driver.find_element_by_accessibility_id('usernameBox')
            usernameTF.send_keys("test@unload.com")
            usernameTF.send_keys(Keys.RETURN)
            self.driver.find_element_by_accessibility_id('Login').click()
            sleep(1)
            self.driver.find_element_by_accessibility_id('OK').click() 
            self.assertEqual(1, 1)

    #test to see if fillin gout just the password field then pressing login will give us an error mesesage
    def testLoginPasswordOnly(self):
            passwordTF = self.driver.find_element_by_accessibility_id('passwordBox')
            passwordTF.send_keys("validPW")
            passwordTF.send_keys(Keys.RETURN)
            self.driver.find_element_by_accessibility_id('Login').click()
            sleep(1)
            self.driver.find_element_by_accessibility_id('OK').click() 
            self.assertEqual(1, 1)

    #test to see if filling out nothing in the username and password field then pressing sign up will give us an error message
    def testLoginNothing(self):
            self.driver.find_element_by_accessibility_id('signUpButton').click()
            sleep(1)
            self.driver.find_element_by_accessibility_id('OK').click() 
            self.assertEqual(1, 1)
    
    #test to see if filling out just the username field then pressing sign up will give us an error message
    def testLoginUsernameOnly(self):
            usernameTF = self.driver.find_element_by_accessibility_id('usernameBox')
            usernameTF.send_keys("test@unload.com")
            usernameTF.send_keys(Keys.RETURN)
            self.driver.find_element_by_accessibility_id('signUpButton').click()
            sleep(1)
            self.driver.find_element_by_accessibility_id('OK').click() 
            self.assertEqual(1, 1)

    #test to see if fillin gout just the password field then pressing sign up will give us an error mesesage
    def testLoginPasswordOnly(self):
            passwordTF = self.driver.find_element_by_accessibility_id('passwordBox')
            passwordTF.send_keys("validPW")
            passwordTF.send_keys(Keys.RETURN)
            self.driver.find_element_by_accessibility_id('signUpButton').click()
            sleep(1)
            self.driver.find_element_by_accessibility_id('OK').click() 
            self.assertEqual(1, 1)

    
if __name__ == '__main__':
    suite = unittest.TestLoader().loadTestsFromTestCase(LoginTests)
    unittest.TextTestRunner(verbosity=2).run(suite)

