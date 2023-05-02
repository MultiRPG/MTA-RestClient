--[[
    Resource: MultiRPG
    Type: Serverside
    Developers: Inder00 <admin@multirpg.pl>
    (©) 2023 <admin@multirpg.pl>. All rights reserved.
]]--

-- Content type parsers
local contentTypeParsers = {

    -- JSON Content-Type parser
    ["application/json"] = function( response )
        return fromJSON( response )
    end,

}

-- HTTP Request function 
local function httpRequest( url, endpoint, method )

    -- return request wrapper
    return {

        -- data
        baseUrl = url,
        path = endpoint,
        method = method,
        headerList = {},
        bodyData = nil,

        -- add header
        addHeader = function( self, name, value )
            assert( type( name ) == "string", "Bad argument 1 @ addHeader [string expected, got " .. type( name ) .. "]" )
            assert( type( value ) == "string", "Bad argument 2 @ addHeader [string expected, got " .. type( value ) .. "]" )
            self.headerList[ name ] = value
            return self
        end,

        -- set body data
        setBody = function( self, data )
            assert( type( data ) == "string" or type( data ) == "table", "Bad argument @ setBody [string/table expected, got " .. type( data ) .. "]" )
            if type( data ) == "table" then
                local jsonData = toJSON( data )
                self.bodyData = utf8.sub( jsonData, math.min( utf8.len( jsonData ), 3 ), math.max( 1, utf8.len( jsonData ) - 2 ) )
            else
                self.bodyData = data
            end
            return self
        end,

        -- execute
        execute = function( self, callbackFunction, ... )

            -- send request
            fetchRemote ( self.baseUrl .. self.path, {
                queueName = string.format("RestClient[%s]", self.path),
                postData = self.bodyData,
                method = self.method,
                headers = self.headerList
            }, function( response, responseData, ... )
                
                -- content type parser
                local contentType = (type(responseData) == "table" and type(responseData.headers) == "table" and responseData.headers["Content-Type"]) and responseData.headers["Content-Type"] or "text/plain"
                local responseParser = contentTypeParsers[ contentType ]

                -- execute callback
                callbackFunction( type(responseParser) == "function" and responseParser( response ) or response, responseData.statusCode, ... )
                
            end, {...} )

        end,

    }

end

-- Create rest client wrapper
function createRestClient( url )

    -- return rest client
    return {

        -- data
        baseUrl = url,

        -- HTTP GET Request
        get = function( self, endpoint )
            return httpRequest( self.baseUrl, endpoint, "GET" )
        end,

        -- HTTP POST Request
        post = function( self, endpoint )
            return httpRequest( self.baseUrl, endpoint, "POST" )
        end,

        -- HTTP PUT Request
        put = function( self, endpoint )
            return httpRequest( self.baseUrl, endpoint, "PUT" )
        end,

        -- HTTP DELETE Request
        delete = function( self, endpoint )
            return httpRequest( self.baseUrl, endpoint, "DELETE" )
        end,

        -- HTTP PATCH Request
        patch = function( self, endpoint )
            return httpRequest( self.baseUrl, endpoint, "PATCH" )
        end,


    }

end