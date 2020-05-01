public class Language
{
    public enum FullName
    {
        CHINESE_SIMPLIFIED,
        CHINESE_TRADITIONAL,
        DANISH,
        DUTCH,
        ENGLISH_US,
        FINNISH,
        FRENCH,
        GERMAN,
        ITALIAN,
        JAPANESE,
        KOREAN,
        NORWEGIAN,
        PORTUGUESE_BRAZIL,
        RUSSIAN,
        SPANISH,
        SPANISH_MEXICO,
        SWEDISH,
        THAI
    }
    
    private static Map<FullName, String> languageToCodeDictionary;
    
    static
    {
        populateDictionary();
    }
    
    private static void populateDictionary()
    {
        languageToCodeDictionary = new Map<FullName, String>
        {
            FullName.CHINESE_SIMPLIFIED => 'zh_CN',
            FullName.CHINESE_TRADITIONAL => 'zh_TW',
            FullName.DANISH => 'da',
            FullName.DUTCH => 'nl_NL',
            FullName.ENGLISH_US => 'en_US',
            FullName.FINNISH => 'fi',
            FullName.FRENCH => 'fr',
            FullName.GERMAN => 'de',
            FullName.ITALIAN => 'it',
            FullName.JAPANESE => 'ja',
            FullName.KOREAN => 'ko',
            FullName.NORWEGIAN => 'no',
            FullName.PORTUGUESE_BRAZIL => 'pt_BR',
            FullName.RUSSIAN => 'ru',
            FullName.SPANISH => 'es',
            FullName.SPANISH_MEXICO => 'es_MX',
            FullName.SWEDISH => 'sv',
            FullName.THAI => 'th'
        };
    }
    
    public static String GetLanguageCode(FullName languageName)
    {
        if (languageToCodeDictionary.containsKey(languageName))
        {
            return languageToCodeDictionary.get(languageName);
        }
        
        return null;
    }
}