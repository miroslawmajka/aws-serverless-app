class Page {
    constructor(url) {
        this.targetUrl = url;
    }

    navigate() {
        browser.url(this.targetUrl || this.getPageUrl());

        return this;
    }

    getPageUrl() {}
    getPageSource() {
        return browser.getPageSource();
    }
}

module.exports = Page;
