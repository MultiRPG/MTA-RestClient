# MTA HTTP Restful Client 💡
🍎 This is a http restful client for [Multi Theft Auto: San Andreas](https://mtasa.com/) and is designed for easy interacting.

🎉The reason I released this http restful client is because I would like to save hours of working on scripting.
Finally, I am glad to provide the `MTA Restful Client`, and everyone is welcome to adjust the code and help make it better by editting the code, adding functions or events.

# Example of usage 🖌️
```lua
-- We create a http rest client wrapper in which we define the base URL
local restClient = createRestClient( "http://restapi.multirpg.internal:8080" )

-- Example of using the GET method
restClient:get( "/v1/player/Inder00" ):execute( function( responseData, statusCode )
    iprint( responseData, statusCode )
end)

-- Example of using the POST method with passing the player to the method
restClient:post( "/v1/player/Inder00" ):setBody({ key = "value" }):execute( function( responseData, statusCode, passedPlayer )
    iprint( responseData, statusCode, passedPlayer )
end, player)


```

# Contribution ❤️

The most powerful feature of open source projects is developers community❤️. Everyone is welcome and will be written
below 🔥.

# Thanks for your support.❤️