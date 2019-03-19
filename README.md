# selenium
Docker container for python selenium scripts with Firefox

To use, create your Selenium script, such as this example using Nextcloud:

```
import time
from selenium.webdriver import Firefox
from selenium.webdriver.firefox.options import Options
from selenium.webdriver.common.keys import Keys

class wait(object):

	def __init__(self, browser):
		self.browser = browser

	def __enter__(self):
		self.old_page = self.browser.find_element_by_tag_name('html')

	def page_has_loaded(self):
		new_page = self.browser.find_element_by_tag_name('html')
		return new_page.id != self.old_page.id

	def __exit__(self, *_):
		start_time = time.time()
		while time.time() < start_time + 5:
			if self.page_has_loaded():
				return True
			else:
				time.sleep(0.1)
		raise Exception('Timeout waiting for page load.')

def test():
	try:
		opts = Options()
		opts.set_headless()
		assert opts.headless  # Operating in headless mode
		browser = Firefox(options=opts)
	except Exception as e:
		print("  -=- FAIL -=-: Initial load - ", e)
		return

	# Test title
	try:
		with wait(browser):
			browser.get('https://nextcloud.mydomain.com/index.php/login')
		assert 'Nextcloud' in browser.title
	except Exception as e:
		print("  -=- FAIL -=-: Initial load - ", e)
		return
	else:
		print("  Success: Initial load")

	try:
		# Enter user
		elem = browser.find_element_by_id('user')
		elem.send_keys("MYUSER")

		# Enter password
		elem = browser.find_element_by_id('password')
		elem.send_keys("MYPASSWORD")

		# Submit form
		elem = browser.find_element_by_id('submit')
		with wait(browser):
			elem.click()

		# Check title for success
		assert 'Files' in browser.title
	except Exception as e:
		print("  -=- FAIL -=-: Login - ", e)
		return
	else:
		print("  Success: Login")

	print("  Finished.")

print("Testing nextcloud...")
test()
```

And then run it:

```
docker run --rm -ti -v /path/to/script:/data nowsci/selenium /data/script.py
```
