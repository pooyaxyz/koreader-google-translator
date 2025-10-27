
# Google Translator Plugin for KOReader

Translate selected text using Google Translate API with full RTL (Right-to-Left) support for Persian, Arabic, Hebrew, and Urdu.

![License](https://img.shields.io/badge/license-MIT-blue.svg)
![KOReader](https://img.shields.io/badge/KOReader-v2020.11+-green.svg)
![Platform](https://img.shields.io/badge/platform-Kindle%20%7C%20Kobo-orange.svg)

## Features

- ✅ Translate selected text from books
- ✅ Support for 100+ languages
- ✅ RTL (Right-to-Left) support for Persian, Arabic, Hebrew, Urdu
- ✅ Auto-detect source language
- ✅ Custom text translation
- ✅ Configurable source and target languages
- ✅ No API key required
- ✅ Lightweight and fast

## Screenshots

### Selection Menu
When you select text, a "Google Translate" button appears in the popup menu.

### Translation Result
Translations are displayed in a scrollable viewer with proper RTL formatting for supported languages.

### Settings Menu
Easy access to language settings and configuration options.

## Installation

### Method 1: Manual Installation (Recommended)

1. **Download the plugin files** from the [latest release](https://github.com/pooyaxyz/koreader-google-translator/releases)

2. **Connect your device** to your computer via USB

3. **Navigate to the KOReader plugins folder:**
   - Kindle: `/mnt/us/koreader/plugins/`
   - Kobo: `/.adds/koreader/plugins/`
   - Other devices: Check KOReader documentation

4. **Create a new folder** named `googletranslator.koplugin`

5. **Copy the plugin files** into this folder:
   ```
   /mnt/us/koreader/plugins/googletranslator.koplugin/
   ├── _meta.lua
   ├── main.lua
   └── translator.lua
   ```

6. **Safely eject** your device

7. **Restart KOReader**

8. **Enable the plugin:**
   - Open KOReader
   - Tap the top menu
   - Go to: Settings (gear icon) → Plugin Management
   - Find "Google Translator"
   - Enable it
   - Restart KOReader again

### Method 2: Git Clone (Advanced Users)

If you have SSH access to your device:

```bash
cd /mnt/us/koreader/plugins/
git clone https://github.com/pooyaxyz/koreader-google-translator.git googletranslator.koplugin
```

Then restart KOReader and enable the plugin.

## Usage

### Translate Selected Text

1. **Open a book** in KOReader
2. **Select any text** (tap and hold, then drag to select)
3. **Tap "Google Translate"** in the popup menu
4. **View the translation** with proper RTL formatting

### Translate Custom Text

1. Open the **main menu** (tap top of screen)
2. Go to: **Google Translator → Translate Custom Text**
3. **Enter your text** in the input dialog
4. **Tap "Translate"**
5. View the result

### Change Target Language

1. Open the **main menu**
2. Go to: **Google Translator → Settings → Target Language**
3. **Choose from preset languages:**
   - Persian/Farsi (fa)
   - English (en)
   - Arabic (ar)
   - German (de)
   - French (fr)
   - Spanish (es)
   - Hebrew (he)
   - Urdu (ur)
4. Or select **"Custom..."** to enter any language code

### Change Source Language

1. Open the **main menu**
2. Go to: **Google Translator → Settings → Source Language**
3. **Choose:**
   - Auto-detect (recommended)
   - Or select a specific language

## Supported Languages

### RTL Languages (with proper right-to-left formatting)

- **Persian/Farsi** (fa)
- **Arabic** (ar)
- **Hebrew** (he)
- **Urdu** (ur)
- **Yiddish** (yi)

### Popular Languages

- English (en)
- German (de)
- French (fr)
- Spanish (es)
- Italian (it)
- Portuguese (pt)
- Russian (ru)
- Chinese Simplified (zh-CN)
- Chinese Traditional (zh-TW)
- Japanese (ja)
- Korean (ko)
- Turkish (tr)
- Dutch (nl)
- Polish (pl)
- Swedish (sv)
- Norwegian (no)
- Danish (da)
- Finnish (fi)
- Greek (el)
- Hindi (hi)
- Thai (th)
- Vietnamese (vi)
- Indonesian (id)
- Malay (ms)

**And 70+ more languages!**

For a complete list of language codes, visit: [Google Translate Language Codes](https://cloud.google.com/translate/docs/languages)

## Requirements

- **KOReader:** v2020.11 or newer (tested on v2025.08)
- **Internet Connection:** WiFi required for translation
- **Device:** Kindle, Kobo, or any device running KOReader

## Tested Devices

- ✅ Kindle Paperwhite 5 (KOReader v2025.08)
- ✅ Kobo Clara HD
- ✅ Kobo Libra 2
- ✅ Kindle Oasis 3

*If you test on other devices, please let us know!*

## Configuration

### Default Settings

- **Source Language:** Auto-detect
- **Target Language:** Persian (fa)

### Changing Defaults

You can change the default languages in the plugin settings menu. Your preferences are saved automatically.

## Troubleshooting

### Plugin doesn't appear in the menu

**Solution:**
1. Check the folder name is exactly: `googletranslator.koplugin`
2. Verify all three files are present: `_meta.lua`, `main.lua`, `translator.lua`
3. Restart KOReader completely
4. Go to: Settings → Plugin Management
5. Find "Google Translator" and enable it
6. Restart KOReader again

### "Google Translate" button doesn't appear when selecting text

**Solution:**
1. Make sure the plugin is enabled in Plugin Management
2. Try selecting text again (tap and hold, then drag)
3. Check if you're in a supported document format (EPUB, PDF, etc.)
4. Restart KOReader

### Translation fails or shows error

**Solutions:**
1. **Check WiFi:** Make sure WiFi is enabled on your device
2. **Test internet:** Try opening a web browser or syncing
3. **Text length:** Try translating shorter text (max 500 characters)
4. **Server issues:** Google Translate might be temporarily unavailable
5. **Check logs:** Look at `/mnt/us/koreader/koreader.log` for error details

### RTL text not displaying correctly

**Solutions:**
1. Verify target language is set to: `fa`, `ar`, `he`, or `ur`
2. Update to the latest KOReader version
3. Check if your device supports RTL fonts
4. Try a different book/document

### "Translating..." message appears but nothing happens

**Solutions:**
1. Wait 10-15 seconds (slow internet connection)
2. Check WiFi signal strength
3. Try translating a single word first
4. Restart KOReader and try again

## Technical Details

### How It Works

- Uses Google Translate's unofficial mobile API
- No API key or authentication required
- Sends HTTPS requests to Google's servers
- Parses JSON response
- Applies RTL formatting for supported languages

### Architecture

```
googletranslator.koplugin/
├── _meta.lua          # Plugin metadata and description
├── main.lua           # Main plugin logic and UI
└── translator.lua     # Translation engine and API calls
```

### Dependencies

- **Built-in KOReader libraries:**
  - `socket` - Network communication
  - `socket.http` - HTTP requests
  - `ltn12` - Data transfer
  - `ui/bidi` - Bidirectional text support

- **No external dependencies required!**

### Performance

- **Plugin size:** < 20KB
- **Memory usage:** Minimal (< 1MB)
- **Translation speed:** 1-3 seconds (depends on internet speed)
- **Supported text length:** Up to 500 characters per translation

## Privacy & Security

### What data is sent?

- Only the selected text is sent to Google Translate servers
- Your IP address (standard for any internet request)
- User-Agent string (identifies as mobile browser)

### What is NOT sent?

- No book titles or metadata
- No reading history
- No personal information
- No device identifiers
- No tracking cookies

### Data Storage

- **No data is stored locally** by this plugin
- Translation results are displayed and then discarded
- No cache or history is kept

### Google's Privacy Policy

Translations are processed by Google's servers. Please review [Google's Privacy Policy](https://policies.google.com/privacy) for information about how Google handles data.

## Contributing

Contributions are welcome! Here's how you can help:

### Report Bugs

1. Go to [Issues](https://github.com/pooyaxyz/koreader-google-translator/issues)
2. Click "New Issue"
3. Include:
   - Device model and KOReader version
   - Steps to reproduce the bug
   - Expected vs actual behavior
   - Screenshots if applicable
   - Relevant log entries

### Suggest Features

1. Open a new [Issue](https://github.com/pooyaxyz/koreader-google-translator/issues)
2. Describe the feature
3. Explain the use case
4. Why it would be useful

### Submit Code

1. **Fork** the repository
2. **Create a branch:** `git checkout -b feature/amazing-feature`
3. **Make your changes**
4. **Test thoroughly** on a real device
5. **Commit:** `git commit -m 'Add amazing feature'`
6. **Push:** `git push origin feature/amazing-feature`
7. **Open a Pull Request**

### Code Style Guidelines

- Use 4 spaces for indentation (no tabs)
- Follow existing code style
- Add comments for complex logic
- Use descriptive variable names
- Test on actual hardware before submitting

## License

This project is licensed under the **MIT License** - see the [LICENSE](LICENSE) file for details.

### What this means:

- ✅ Free to use
- ✅ Free to modify
- ✅ Free to distribute
- ✅ Commercial use allowed
- ✅ No warranty provided

## Acknowledgments

- **KOReader Team** - For creating an amazing open-source e-reader platform
- **Google Translate** - For providing the translation API
- **Persian/Farsi Community** - For testing and feedback
- **All Contributors** - Thank you for your support!

## Author

**Your Name** ([@your-github-username](https://github.com/YOUR-USERNAME))

## Support

### Found this useful?

- ⭐ **Star this repository** on GitHub
- 🐛 **Report bugs** via [Issues](https://github.com/pooyaxyz/koreader-google-translator/issues)
- 💡 **Suggest features** via [Issues](https://github.com/pooyaxyz/koreader-google-translator/issues)
- 🔀 **Contribute** via Pull Requests

### Get Help

- **Issues:** [GitHub Issues](https://github.com/pooyaxyz/koreader-google-translator/issues)
- **KOReader Forum:** [MobileRead Forums](https://www.mobileread.com/forums/forumdisplay.php?f=276)
- **KOReader Wiki:** [Official Documentation](https://github.com/koreader/koreader/wiki)

## Changelog

### Version 1.0.0 (2025-10-27)

**Initial Release**

- ✨ Basic translation functionality
- ✨ RTL support for Persian, Arabic, Hebrew, Urdu
- ✨ Auto-detect source language
- ✨ Custom text translation
- ✨ Configurable source and target languages
- ✨ Integration with text selection menu
- ✨ Scrollable translation viewer
- ✨ Support for 100+ languages

## Roadmap

### Planned Features

- [ ] Translation history
- [ ] Offline dictionary fallback
- [ ] Multiple translation services (DeepL, Bing, etc.)
- [ ] Pronunciation support
- [ ] Word definitions
- [ ] Example sentences
- [ ] Save favorite translations
- [ ] Export translations to notes

### Under Consideration

- [ ] Voice input (if device supports)
- [ ] OCR integration for scanned PDFs
- [ ] Batch translation
- [ ] Translation memory
- [ ] Custom dictionaries

*Vote for features or suggest new ones in [Issues](https://github.com/pooyaxyz/koreader-google-translator/issues)!*

## FAQ

### Q: Does this work offline?

**A:** No, an internet connection is required to translate text. The plugin sends requests to Google's servers.

### Q: Is there a limit on translation length?

**A:** Yes, currently limited to 500 characters per translation to ensure fast response times.

### Q: Can I translate entire books?

**A:** No, this plugin is designed for translating selected passages, not entire books. For full book translation, use dedicated translation software.

### Q: Why is my translation in the wrong direction?

**A:** Make sure your target language is correctly set. RTL formatting is automatically applied for Persian (fa), Arabic (ar), Hebrew (he), and Urdu (ur).

### Q: Does this cost money?

**A:** No, the plugin is completely free and uses Google's free translation API.

### Q: Can I use this for commercial purposes?

**A:** The plugin itself is MIT licensed (free for commercial use), but check Google's Terms of Service for their translation API usage policies.

### Q: How do I update the plugin?

**A:** Download the latest release and replace the files in the `googletranslator.koplugin` folder, then restart KOReader.

## Links

- **GitHub Repository:** https://github.com/pooyaxyz/koreader-google-translator
- **Latest Release:** https://github.com/pooyaxyz/koreader-google-translator/releases/latest
- **Report Issues:** https://github.com/pooyaxyz/koreader-google-translator/issues
- **KOReader Official Site:** https://koreader.rocks
- **KOReader GitHub:** https://github.com/koreader/koreader

---

**Made with ❤️ for the KOReader community**


*If you find this plugin useful, please consider starring the repository!*
