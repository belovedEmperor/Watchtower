import { Browser, chromium, Page } from "playwright";

async function main() {
  const browser = await chromium.launch({
    args: ["--no-sandbox", "--disable-setuid-sandbox"],
    headless: false,
  });
  const page = await browser.newPage();
  await new Promise((resolve) => setTimeout(resolve, 10000));

  await page.close();
  await browser.close();
}

main();
