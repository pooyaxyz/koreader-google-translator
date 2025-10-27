local BD = require("ui/bidi")
local Device = require("device")
local InfoMessage = require("ui/widget/infomessage")
local InputDialog = require("ui/widget/inputdialog")
local TextViewer = require("ui/widget/textviewer")
local UIManager = require("ui/uimanager")
local WidgetContainer = require("ui/widget/container/widgetcontainer")
local _ = require("gettext")
local T = require("ffi/util").template
local logger = require("logger")

local Translator = require("translator")

local GoogleTranslator = WidgetContainer:extend{
    name = "googletranslator",
    is_doc_only = true,
}

function GoogleTranslator:init()
    logger.info("GoogleTranslator: Initializing plugin")
    
    self.ui.menu:registerToMainMenu(self)
    
    -- Default settings
    self.source_lang = "auto"
    self.target_lang = "fa"  -- Persian/Farsi
    
    -- Initialize translator
    self.translator = Translator:new()
    
    logger.info("GoogleTranslator: Plugin initialized")
end

function GoogleTranslator:onReaderReady()
    logger.info("GoogleTranslator: Reader ready, registering menus")
    self:registerHighlightMenu()
end

-- Register to text selection menu
function GoogleTranslator:registerHighlightMenu()
    logger.info("GoogleTranslator: Attempting to register highlight menu")
    
    -- Method: Using addToHighlightDialog (passes selected_text in callback)
    if self.ui.highlight and self.ui.highlight.addToHighlightDialog then
        logger.info("GoogleTranslator: Using addToHighlightDialog method")
        local success = pcall(function()
            self.ui.highlight:addToHighlightDialog("google_translate", function(this)
                return {
                    text = _("Google Translate"),
                    callback = function()
                        -- Get text from highlight object
                        local text = this.selected_text and this.selected_text.text or this.selected_word
                        logger.info("GoogleTranslator: Text from callback:", tostring(text))
                        self:translateText(text)
                    end,
                }
            end)
        end)
        if success then
            logger.info("GoogleTranslator: Successfully registered via addToHighlightDialog")
            return
        else
            logger.warn("GoogleTranslator: Failed to register via addToHighlightDialog")
        end
    end
    
    logger.warn("GoogleTranslator: Could not register highlight menu")
end

function GoogleTranslator:addToMainMenu(menu_items)
    menu_items.google_translator = {
        text = _("Google Translator"),
        sorting_hint = "tools",
        sub_item_table = {
            {
                text = _("Translate Custom Text"),
                callback = function()
                    self:translateCustomText()
                end,
            },
            {
                text = _("Settings"),
                sub_item_table = {
                    {
                        text = _("Target Language"),
                        keep_menu_open = true,
                        sub_item_table = {
                            {
                                text = _("Persian/Farsi (fa)"),
                                checked_func = function() return self.target_lang == "fa" end,
                                callback = function()
                                    self.target_lang = "fa"
                                    UIManager:show(InfoMessage:new{
                                        text = _("Target language: Persian"),
                                        timeout = 1,
                                    })
                                end,
                            },
                            {
                                text = _("English (en)"),
                                checked_func = function() return self.target_lang == "en" end,
                                callback = function()
                                    self.target_lang = "en"
                                    UIManager:show(InfoMessage:new{
                                        text = _("Target language: English"),
                                        timeout = 1,
                                    })
                                end,
                            },
                            {
                                text = _("Arabic (ar)"),
                                checked_func = function() return self.target_lang == "ar" end,
                                callback = function()
                                    self.target_lang = "ar"
                                    UIManager:show(InfoMessage:new{
                                        text = _("Target language: Arabic"),
                                        timeout = 1,
                                    })
                                end,
                            },
                            {
                                text = _("German (de)"),
                                checked_func = function() return self.target_lang == "de" end,
                                callback = function()
                                    self.target_lang = "de"
                                    UIManager:show(InfoMessage:new{
                                        text = _("Target language: German"),
                                        timeout = 1,
                                    })
                                end,
                            },
                            {
                                text = _("French (fr)"),
                                checked_func = function() return self.target_lang == "fr" end,
                                callback = function()
                                    self.target_lang = "fr"
                                    UIManager:show(InfoMessage:new{
                                        text = _("Target language: French"),
                                        timeout = 1,
                                    })
                                end,
                            },
                            {
                                text = _("Spanish (es)"),
                                checked_func = function() return self.target_lang == "es" end,
                                callback = function()
                                    self.target_lang = "es"
                                    UIManager:show(InfoMessage:new{
                                        text = _("Target language: Spanish"),
                                        timeout = 1,
                                    })
                                end,
                            },
                            {
                                text = _("Hebrew (he)"),
                                checked_func = function() return self.target_lang == "he" end,
                                callback = function()
                                    self.target_lang = "he"
                                    UIManager:show(InfoMessage:new{
                                        text = _("Target language: Hebrew"),
                                        timeout = 1,
                                    })
                                end,
                            },
                            {
                                text = _("Urdu (ur)"),
                                checked_func = function() return self.target_lang == "ur" end,
                                callback = function()
                                    self.target_lang = "ur"
                                    UIManager:show(InfoMessage:new{
                                        text = _("Target language: Urdu"),
                                        timeout = 1,
                                    })
                                end,
                            },
                            {
                                text = _("Custom..."),
                                keep_menu_open = true,
                                callback = function()
                                    self:changeTargetLanguage()
                                end,
                            },
                        },
                    },
                    {
                        text = _("Source Language"),
                        keep_menu_open = true,
                        sub_item_table = {
                            {
                                text = _("Auto-detect"),
                                checked_func = function() return self.source_lang == "auto" end,
                                callback = function()
                                    self.source_lang = "auto"
                                    UIManager:show(InfoMessage:new{
                                        text = _("Source: Auto-detect"),
                                        timeout = 1,
                                    })
                                end,
                            },
                            {
                                text = _("English (en)"),
                                checked_func = function() return self.source_lang == "en" end,
                                callback = function()
                                    self.source_lang = "en"
                                    UIManager:show(InfoMessage:new{
                                        text = _("Source language: English"),
                                        timeout = 1,
                                    })
                                end,
                            },
                            {
                                text = _("Persian/Farsi (fa)"),
                                checked_func = function() return self.source_lang == "fa" end,
                                callback = function()
                                    self.source_lang = "fa"
                                    UIManager:show(InfoMessage:new{
                                        text = _("Source language: Persian"),
                                        timeout = 1,
                                    })
                                end,
                            },
                            {
                                text = _("Arabic (ar)"),
                                checked_func = function() return self.source_lang == "ar" end,
                                callback = function()
                                    self.source_lang = "ar"
                                    UIManager:show(InfoMessage:new{
                                        text = _("Source language: Arabic"),
                                        timeout = 1,
                                    })
                                end,
                            },
                            {
                                text = _("Custom..."),
                                keep_menu_open = true,
                                callback = function()
                                    self:changeSourceLanguage()
                                end,
                            },
                        },
                    },
                },
            },
            {
                text = _("About"),
                callback = function()
                    UIManager:show(InfoMessage:new{
                        text = _("Google Translator Plugin\n\nSelect text and tap 'Google Translate' button.\n\nDefault: Auto → Persian (fa)\nSupports RTL languages (Persian, Arabic, Hebrew, Urdu)\n\nRequires internet connection."),
                        timeout = 5,
                    })
                end,
            },
        },
    }
end

-- Translate text directly (called from highlight menu)
function GoogleTranslator:translateText(text)
    logger.info("GoogleTranslator: translateText called")
    
    if not text or text == "" then
        UIManager:show(InfoMessage:new{
            text = _("No text to translate."),
            timeout = 2,
        })
        return
    end
    
    logger.info("GoogleTranslator: Text to translate:", tostring(text):sub(1, 50))
    
    -- Perform translation
    self:performTranslation(text)
end

-- Translate custom text via input dialog
function GoogleTranslator:translateCustomText()
    local input_dialog
    input_dialog = InputDialog:new{
        title = _("Enter text to translate"),
        input = "",
        input_type = "text",
        buttons = {
            {
                {
                    text = _("Cancel"),
                    id = "close",
                    callback = function()
                        UIManager:close(input_dialog)
                    end,
                },
                {
                    text = _("Translate"),
                    is_enter_default = true,
                    callback = function()
                        local text = input_dialog:getInputText()
                        UIManager:close(input_dialog)
                        if text and text ~= "" then
                            self:performTranslation(text)
                        end
                    end,
                },
            },
        },
    }
    UIManager:show(input_dialog)
    input_dialog:onShowKeyboard()
end

-- Show translation result with proper RTL support
function GoogleTranslator:showTranslationResult(original_text, translation, is_rtl)
    -- Prepare the display text
    local display_text
    local original_preview = original_text
    if original_text:len() > 200 then
        original_preview = original_text:sub(1, 200) .. "..."
    end
    
    if is_rtl then
        -- Apply RTL formatting
        translation = BD.rtl(translation)
        display_text = string.format(
            "%s\n\n━━━━━━━━━━━━━━━━━━━━\n\n%s:\n%s",
            translation,
            _("Original"),
            original_preview
        )
    else
        display_text = string.format(
            "%s (%s → %s):\n\n%s\n\n━━━━━━━━━━━━━━━━━━━━\n\n%s:\n%s",
            _("Translation"),
            self.source_lang,
            self.target_lang,
            translation,
            _("Original"),
            original_preview
        )
    end
    
    -- Show in TextViewer for better display
    local viewer = TextViewer:new{
        title = T(_("Translation (%1 → %2)"), self.source_lang, self.target_lang),
        text = display_text,
        justified = false,
        para_direction_rtl = is_rtl,
    }
    UIManager:show(viewer)
end

-- Perform translation with error handling
function GoogleTranslator:performTranslation(text)
    logger.info("GoogleTranslator: Starting translation")
    
    -- Show loading message
    local loading_msg = InfoMessage:new{
        text = _("Translating..."),
    }
    UIManager:show(loading_msg)
    UIManager:forceRePaint()
    
    -- Small delay to ensure loading message is shown
    UIManager:scheduleIn(0.1, function()
        -- Wrap in pcall to catch errors
        local success, translation, err = pcall(function()
            return self.translator:translate(text, self.source_lang, self.target_lang)
        end)
        
        UIManager:close(loading_msg)
        
        if not success then
            logger.err("GoogleTranslator: Translation crashed:", translation)
            UIManager:show(InfoMessage:new{
                text = T(_("Error: %1\n\nPlease check:\n- WiFi is enabled\n- Internet connection"), tostring(translation)),
                timeout = 5,
            })
            return
        end
        
        if translation then
            logger.info("GoogleTranslator: Translation successful")
            
            -- Check if target language is RTL
            local rtl_languages = {
                fa = true,  -- Persian/Farsi
                ar = true,  -- Arabic
                he = true,  -- Hebrew
                ur = true,  -- Urdu
                yi = true,  -- Yiddish
            }
            
            local is_rtl = rtl_languages[self.target_lang]
            
            -- Show result with proper RTL support
            self:showTranslationResult(text, translation, is_rtl)
        else
            logger.warn("GoogleTranslator: Translation failed:", err)
            UIManager:show(InfoMessage:new{
                text = T(_("Translation failed: %1\n\nMake sure:\n- WiFi is ON\n- Internet works\n- Text is not too long"), 
                    err or "Unknown error"
                ),
                timeout = 5,
            })
        end
    end)
end

-- Change target language
function GoogleTranslator:changeTargetLanguage()
    local input_dialog
    input_dialog = InputDialog:new{
        title = _("Enter target language code\n\nExamples:\nfa = Persian/Farsi\nen = English\nar = Arabic\nde = German\nfr = French\nes = Spanish\nit = Italian\nru = Russian\nzh = Chinese\nja = Japanese\nko = Korean"),
        input = self.target_lang,
        input_type = "text",
        buttons = {
            {
                {
                    text = _("Cancel"),
                    callback = function()
                        UIManager:close(input_dialog)
                    end,
                },
                {
                    text = _("OK"),
                    is_enter_default = true,
                    callback = function()
                        local lang = input_dialog:getInputText()
                        if lang and lang ~= "" then
                            self.target_lang = lang
                            UIManager:close(input_dialog)
                            UIManager:show(InfoMessage:new{
                                text = T(_("Target language: %1"), lang),
                                timeout = 2,
                            })
                        end
                    end,
                },
            },
        },
    }
    UIManager:show(input_dialog)
    input_dialog:onShowKeyboard()
end

-- Change source language
function GoogleTranslator:changeSourceLanguage()
    local input_dialog
    input_dialog = InputDialog:new{
        title = _("Enter source language code\n\nExamples:\nauto = Auto-detect\nen = English\nfa = Persian/Farsi\nar = Arabic"),
        input = self.source_lang,
        input_type = "text",
        buttons = {
            {
                {
                    text = _("Cancel"),
                    callback = function()
                        UIManager:close(input_dialog)
                    end,
                },
                {
                    text = _("OK"),
                    is_enter_default = true,
                    callback = function()
                        local lang = input_dialog:getInputText()
                        if lang and lang ~= "" then
                            self.source_lang = lang
                            UIManager:close(input_dialog)
                            UIManager:show(InfoMessage:new{
                                text = T(_("Source language: %1"), lang),
                                timeout = 2,
                            })
                        end
                    end,
                },
            },
        },
    }
    UIManager:show(input_dialog)
    input_dialog:onShowKeyboard()
end

return GoogleTranslator
