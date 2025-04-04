const { root: siteRoot = "/" } = hexo.config;

hexo.extend.injector.register("body_begin", `<div id="web_bg"></div>`);

hexo.extend.injector.register("body_end", `<script src="${siteRoot}js/backgroundize.js"></script>`);

hexo.extend.injector.register("body_end", `<script src="${siteRoot}js/snow.js"></script>`);

hexo.extend.injector.register("body_end", `<script src="${siteRoot}js/title.js"></script>`);

hexo.extend.injector.register("body_end", `<script src="${siteRoot}js/sign.js"></script>`);

hexo.extend.injector.register("body_end", `<script src="${siteRoot}js/scrollAnimation.js"></script>`);

hexo.extend.injector.register("body_end", `<script src="${siteRoot}js/time-insert.js"></script>`);

hexo.extend.injector.register("body_end", `<script src="${siteRoot}js/time.js"></script>`);