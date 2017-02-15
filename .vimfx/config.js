vimfx.set('hints.chars', 'abcdefghijklmnopqrstuvw xyz')
vimfx.set('mode.normal.scroll_half_page_down', '<c-d>')
vimfx.set("mode.normal.scroll_half_page_up",   "<c-u>")
vimfx.set("mode.normal.tab_select_previous", "h gT")
vimfx.set("mode.normal.tab_select_next",     "l gt")
vimfx.set("mode.normal.scroll_left",         "")
vimfx.set("mode.normal.scroll_right",        "")
vimfx.set("mode.normal.find",                       "")
vimfx.set("mode.normal.find_highlight_all",        "/")
vimfx.set("mode.normal.tab_close",                "d x")
vimfx.set("mode.normal.tab_restore",              "u X")
vimfx.set("mode.normal.follow_in_tab",            "F")
vimfx.set("mode.normal.follow",                   "f")
vimfx.set("prevent_autofocus",                    true)

vimfx.addCommand({
    name: "open_with_ezproxy",
    description: "Open current website with EZProxy",
}, ({vim}) => {
    let ezproxy_prefix = "http://kuleuven.ezproxy.kuleuven.be/login?url=";
    let url = vim.browser.currentURI.spec;
    let ezproxyurl = ezproxy_prefix + url;
    vim.window.gBrowser.loadURI(ezproxyurl);
    console.log("Opened with EZproxy:");
    console.log("Changed")
    console.log(url);
    console.log("to")
    console.log(ezproxyurl);
    vim.notify("Geopend met EZProxy");
})

vimfx.set("custom.mode.normal.open_with_ezproxy", "z")

