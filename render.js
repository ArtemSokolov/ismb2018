const puppeteer = require('puppeteer');

(async () => {
    const browser = await puppeteer.launch();
    const page = await browser.newPage();
    await page.goto('file:///home/sokolov/projects/ismb2018/docs/index.html', {"waitUntil" : "networkidle0"});
//    await page.setViewport({width: 1900, height: 1450});
//    await page.screenshot({path: 'test.png'});
    await page.pdf({path: 'ismb2018.pdf', scale:2, width: '40in', height: '33.4in', printBackground: true});

    await browser.close();
})();

