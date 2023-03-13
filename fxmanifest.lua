fx_version "bodacious"

game "gta5"

description "Wapendealer job"

version "1.1.1"

client_scripts {"@es_extended/locale.lua", "locales/*.lua", "config.lua", "client.lua"}

server_scripts {
    "@mysql-async/lib/MySQL.lua",
    "server.lua"
}

ui_page "html/index.html"

files {
    "html/index.html",
    "html/assets/css/*.css",
    "html/assets/js/*.js",
    "html/assets/fonts/roboto/*.woff",
    "html/assets/fonts/roboto/*.woff2",
    "html/assets/fonts/justsignature/JustSignature.woff",
    "html/assets/images/*.png"
}
