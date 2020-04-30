public class LabelTranslator
{
    private static Map<String, String> valuesToApiNames;
    
    static
    {
        valuesToApiNames = new Map<String, String>();
        
        MetadataService.ReadCustomLabelsResult result = GetLabels();
        
        for (MetadataService.CustomLabels label : result.records)
        {
            for (MetadataService.CustomLabel lb : label.labels)
            {
                System.debug(lb.value);
                System.debug(lb.fullName);
                valuesToApiNames.put(lb.value, lb.fullName);
            }
        }

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
            MetadataService.MetadataPort proxy = new MetadataService.MetadataPort();
            MetadataService.SessionHeader_element header = new MetadataService.SessionHeader_element();
            header.sessionId = UserInfo.getSessionId();
            proxy.SessionHeader = header;
            MetadataService.ReadTranslationsResult props = (MetadataService.ReadTranslationsResult) proxy.readMetadata('Translations', new List<String>{ 'de' });
            
            for (MetadataService.Translations translatedLanguage : props.records)
            {
                if (translatedLanguage.fullName == languageCode)
                {
                    for (MetadataService.CustomLabelTranslation translation : translatedLanguage.customLabels)
                    {
                        System.debug(translation.name);
                        System.debug(translation.label);
                        
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
    
    private static MetadataService.ReadCustomLabelsResult GetLabels()
    {
        MetadataService.MetadataPort proxy = new MetadataService.MetadataPort();
        MetadataService.SessionHeader_element header = new MetadataService.SessionHeader_element();
        header.sessionId = UserInfo.getSessionId();
        proxy.SessionHeader = header;
        return (MetadataService.ReadCustomLabelsResult) proxy.readMetadata('CustomLabels', new List<String>{ 'CustomLabels' });
    }
}