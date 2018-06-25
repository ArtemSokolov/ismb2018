const puppeteer = require('puppeteer');

(async () => {
    const browser = await puppeteer.launch();
    const page = await browser.newPage();
    await page.goto('file:///home/sokolov/projects/ismb2018/output/ismb2018.html');
//    await page.setViewport({width: 1900, height: 1450});
//    await page.screenshot({path: 'test.png'});
    await page.pdf({path: 'test.pdf', scale:2, width: '40in', height: '31in', printBackground: true});

    await browser.close();
})();

