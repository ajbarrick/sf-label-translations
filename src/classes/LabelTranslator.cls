public with sharing class LabelTranslator
{
    private static Map<String, String> valuesToApiNames;
    private static MetadataService.ReadTranslationsResult translations;
    
    static
    {
        valuesToApiNames = new Map<String, String>();
        
        MetadataService.ReadCustomLabelsResult result = GetLabels();
        
        for (MetadataService.CustomLabels label : result.records)
        {
            for (MetadataService.CustomLabel lb : label.labels)
            {
                valuesToApiNames.put(lb.value, lb.fullName);
            }
        }
        
        translations = GetTranslations();
    }
    
    public static String GetTranslationFor(String label, Language.FullName languageName)
    {
        String lang = Language.GetLanguageCode(languageName);
        
        if (!String.IsBlank(lang))
        {
            return GetTranslationFor(label, lang);
        }
        
        return '';
    }
    
    public static String GetTranslationFor(String labelValue, String languageCode)
    {
        String labelApiName = valuesToApiNames.get(labelValue);
        
        if (!String.IsBlank(labelValue) && !String.IsBlank(languageCode))
        {
            for (MetadataService.Translations translatedLanguage : translations.records)
            {
                if (translatedLanguage.fullName == languageCode)
                {
                    for (MetadataService.CustomLabelTranslation translation : translatedLanguage.customLabels)
                    {
                        if (translation.name == labelApiName)
                        {
                            return translation.label;
                        }
                    }
                }
            }
        }
        
        return '';
    }

    private static MetadataService.MetadataPort GetProxyWithHeader()
    {
        MetadataService.MetadataPort proxy = new MetadataService.MetadataPort();
        MetadataService.SessionHeader_element header = new MetadataService.SessionHeader_element();
        header.sessionId = UserInfo.getSessionId();
        proxy.SessionHeader = header;

        return proxy;
    }
    
    private static MetadataService.ReadCustomLabelsResult GetLabels()
    {
        MetadataService.MetadataPort proxy = GetProxyWithHeader();
        return (MetadataService.ReadCustomLabelsResult) proxy.readMetadata('CustomLabels', new List<String>{ 'CustomLabels' });
    }

    private static MetadataService.ReadTranslationsResult GetTranslations()
    {
        MetadataService.MetadataPort proxy = GetProxyWithHeader();
        return (MetadataService.ReadTranslationsResult) proxy.readMetadata('Translations', new List<String>{ 'de' });
    }
}