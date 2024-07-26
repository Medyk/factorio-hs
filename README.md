# Factorio Headless Server

Creates minimal docker image for running Factorio server.

[write-data](https://wiki.factorio.com/Application_directory) folder is set to /factorio volume.

Default run parameters are  
```CMD [ "--start-server-load-latest", "--server-settings", "/factorio/server-settings.json" ]```

To start a server you need to create (or copy existing) save file to /factorio/saves  
```docker compose run --rm --workdir /factorio/saves factorio-hs --create map01.zip```

Volume structure
| File / folder |
| --- |
| /factorio/server-adminlist.json |
| /factorio/server-settings.json |
| /factorio/mods/ |
| /factorio/saves/ |
| /factorio/scenarios/ |
| /factorio/script-output/ |
