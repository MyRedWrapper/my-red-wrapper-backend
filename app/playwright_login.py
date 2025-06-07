from playwright.sync_api import sync_playwright

import redis

redis_conn = redis.Redis(host="35.184.236.198", port=6379, db=0)


def send_status(job_id: str, message: str):
    redis_conn.publish(job_id, message)


def perform_login(job_id: str, username: str, password: str):
    send_status(job_id, "starting login")

    with sync_playwright() as p:
        browser = p.chromium.launch(headless=True, args=[
            "--no-sandbox", "--disable-setuid-sandbox", "--incognito"
        ])
        context = browser.new_context()
        page = context.new_page()

        def intercept(route, request):
            if request.resource_type in ["image", "stylesheet", "font", "media"]:
                route.abort()
            else:
                route.continue_()
        page.route("**/*", intercept)

        try:
            send_status(job_id, "navigating to login page")
            page.goto("https://myred.nebraska.edu/psp/myred/NBL/HRMS/?cmd=login", wait_until="networkidle")

            iframe = page.frame_locator("iframe#content")
            login_div = iframe.locator("#login-nuid")
            login_div.wait_for(state="visible", timeout=10000)
            login_div.click()

            send_status(job_id, "waiting for navigation")
            page.wait_for_load_state("networkidle")

            send_status(job_id, "entering credentials")
            page.fill("#username", username)
            page.fill("#password", password)
            page.click('button[type="submit"][name="_eventId_proceed"]')

            send_status(job_id, "waiting for 2FA")
            trust_button = page.wait_for_selector("#dont-trust-browser-button", timeout=60000)
            trust_button.click()

            send_status(job_id, "finalizing login")
            page.wait_for_load_state("networkidle")

            page.wait_for_url("**/myred/NBL/SA/s/**", timeout=60000)

            cookies = context.cookies()

            send_status(job_id, "login complete")
            return cookies

        except Exception as e:
            send_status(job_id, f"error: {str(e)}")
            raise
        finally:
            browser.close()
