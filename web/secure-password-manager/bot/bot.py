import time
import tempfile
from pathlib import Path
from playwright.sync_api import sync_playwright

def visit(url):
    with open("flag.txt", "r") as f:
        flag = f.readline().rstrip("\n")

    with sync_playwright() as playwright:
        chromium = playwright.chromium
        with tempfile.TemporaryDirectory() as temp_dir:
            context = chromium.launch_persistent_context(user_data_dir=temp_dir, headless=False, args=[
                "--disable-extensions-except=../extension",
                "--load-extension=../extension",
            ])
            page = context.new_page()

            print("logging into my website to remind myself of cool...")
            page.goto("http://cool_site")
            page.wait_for_load_state("networkidle")
            page.fill("input[name=email]", "usc@ctf.com")
            page.fill("input[name=password]", flag)
            page.click("button[type=submit]")
            page.wait_for_load_state("networkidle")

            print("oh right... let me check out your url")
            page.goto(url)
            page.wait_for_load_state("networkidle")
            print("admiring it...")
            time.sleep(5)
            context.close()
        print("bye, muah")

def main():
    print("i am alvin and i demand a cool url:")
    url = input()
    try:
        visit(url)
    except Exception as e:
        print(e)

if __name__ == "__main__":
    main()

