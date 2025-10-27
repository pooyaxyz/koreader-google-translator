local logger = require("logger")

local Translator = {}

function Translator:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

-- Main translation function with comprehensive error handling
function Translator:translate(text, source_lang, target_lang)
    source_lang = source_lang or "auto"
    target_lang = target_lang or "fa"
    
    if not text or text == "" then
        return nil, "Empty text"
    end
    
    logger.info("Starting translation:", text:sub(1, 50))
    
    -- Check if we have network libraries
    local has_socket, socket = pcall(require, "socket")
    if not has_socket then
        logger.err("Socket library not available")
        return nil, "Network library not available"
    end
    
    local has_http, http = pcall(require, "socket.http")
    if not has_http then
        logger.err("HTTP library not available")
        return nil, "HTTP library not available"
    end
    
    local has_ltn12, ltn12 = pcall(require, "ltn12")
    if not has_ltn12 then
        logger.err("LTN12 library not available")
        return nil, "LTN12 library not available"
    end
    
    -- Limit text length
    if text:len() > 500 then
        text = text:sub(1, 500)
    end
    
    -- URL encode the text
    local encoded_text = self:urlEncode(text)
    
    -- Google Translate API endpoint (unofficial mobile API)
    local url = string.format(
        "https://translate.googleapis.com/translate_a/single?client=gtx&sl=%s&tl=%s&dt=t&q=%s",
        source_lang,
        target_lang,
        encoded_text
    )
    
    logger.info("Request URL:", url:sub(1, 100))
    
    local response_body = {}
    
    -- Wrap HTTP request in pcall for safety
    local success, res, code, response_headers = pcall(function()
        return http.request{
            url = url,
            method = "GET",
            sink = ltn12.sink.table(response_body),
            headers = {
                ["User-Agent"] = "Mozilla/5.0 (Linux; Android 10) AppleWebKit/537.36",
                ["Accept"] = "*/*",
            },
            timeout = 15,
        }
    end)
    
    if not success then
        logger.err("HTTP request failed:", tostring(res))
        return nil, "Network error: " .. tostring(res)
    end
    
    logger.info("HTTP response code:", code)
    
    if code ~= 200 then
        logger.warn("Server returned code:", code)
        return nil, "Server error: " .. tostring(code)
    end
    
    local response_text = table.concat(response_body)
    
    if not response_text or response_text == "" then
        logger.err("Empty response from server")
        return nil, "Empty response"
    end
    
    logger.info("Response length:", #response_text)
    
    -- Parse the response
    local parse_success, result = pcall(function()
        return self:parseResponse(response_text)
    end)
    
    if parse_success and result then
        logger.info("Translation successful")
        return result
    else
        logger.warn("Parse failed:", tostring(result))
        return nil, "Parse error"
    end
end

-- Parse Google Translate response
function Translator:parseResponse(response)
    -- Google returns: [[["translated text","original text",...]]]
    -- Simple pattern matching
    local translation = response:match('%[%[%[%s*"([^"]*)"')
    
    if translation then
        -- Unescape special characters
        translation = self:unescapeString(translation)
        return translation
    end
    
    -- Try alternative pattern
    translation = response:match('"([^"]+)",null,null,%d')
    if translation then
        translation = self:unescapeString(translation)
        return translation
    end
    
    return nil
end

-- Unescape string
function Translator:unescapeString(str)
    if not str then return nil end
    
    str = str:gsub("\\n", "\n")
    str = str:gsub("\\t", "\t")
    str = str:gsub("\\r", "\r")
    str = str:gsub('\\"', '"')
    str = str:gsub("\\\\", "\\")
    str = str:gsub("\\/", "/")
    
    return str
end

-- URL encode function
function Translator:urlEncode(str)
    if str then
        str = string.gsub(str, "\n", "\r\n")
        str = string.gsub(str, "([^%w %-%_%.%~])",
            function(c)
                return string.format("%%%02X", string.byte(c))
            end)
        str = string.gsub(str, " ", "+")
    end
    return str
end

return Translator
