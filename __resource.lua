resource_manifest_version "44febabe-d386-4d18-afbe-5e627f4af937"


client_scripts {
    '@es_extended/locale.lua',
    'client/client.lua',
    'locales/es.lua',
    'config.lua'
}

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    '@es_extended/locale.lua',
    'server/server.lua',
    'locales/es.lua',
    'config.lua'
}

dependencies {
	'es_extended'
}