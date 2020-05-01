@isTest
public with sharing class LabelTranslator_Test {
    private static final String TRAIN_LABEL = 'TRAIN_LABEL';
    private static final String PLANE_LABEL = 'PLANE_LABEL';
    private static final String TRAIN_LABEL_VALUE = 'Train';

    private class LabelsCalloutMock implements WebServiceMock
    {
		public void doInvoke(
			Object stub, Object request, Map<String, Object> response,
			String endpoint, String soapAction, String requestName,
			String responseNS, String responseName, String responseType) 
		{
            MetadataService.readCustomLabelsResponse_element retValue = new MetadataService.readCustomLabelsResponse_element();
            MetadataService.ReadCustomLabelsResult customLabelsRes = new MetadataService.ReadCustomLabelsResult();
            List<MetadataService.CustomLabels> labelsCollection = new List<MetadataService.CustomLabels>();
            List<MetadataService.CustomLabel> labelList = new List<MetadataService.CustomLabel>();

            MetadataService.CustomLabels labelsHeader = new MetadataService.CustomLabels();
            labelsHeader.fullName = 'CustomLabels';

            MetadataService.CustomLabel trainLabel = new MetadataService.CustomLabel();
            trainLabel.fullName = TRAIN_LABEL_VALUE;
            trainLabel.value = TRAIN_LABEL;

            labelList.add(trainLabel);

            MetadataService.CustomLabel planeLabel = new MetadataService.CustomLabel();
            planeLabel.fullName = 'Plane';
            planeLabel.value = PLANE_LABEL;

            labelsHeader.labels = labelList;
            labelsCollection.add(labelsHeader);
            customLabelsRes.records = labelsCollection;
            retValue.result = customLabelsRes;
            
			response.put('response_x', retValue);
		}
    }

    private class TranslationsCalloutMock implements WebServiceMock
    {
		public void doInvoke(
			Object stub, Object request, Map<String, Object> response,
			String endpoint, String soapAction, String requestName,
			String responseNS, String responseName, String responseType) 
		{
            MetadataService.readTranslationsResponse_element retValue = new MetadataService.readTranslationsResponse_element();
            MetadataService.ReadTranslationsResult translationsRes = new MetadataService.ReadTranslationsResult();
            List<MetadataService.Translations> translations = new List<MetadataService.Translations>();
            
            MetadataService.Translations trans = new MetadataService.Translations();
            trans.fullName = 'de';

            List<MetadataService.CustomLabelTranslation> labelTranslations = new List<MetadataService.CustomLabelTranslation>();

            MetadataService.CustomLabelTranslation labelTranslation = new MetadataService.CustomLabelTranslation();
            labelTranslation.label = 'Zug';
            labelTranslation.name = TRAIN_LABEL_VALUE;

            labelTranslations.add(labelTranslation);

            trans.customLabels = labelTranslations;
            translations.add(trans);

            translationsRes.records = translations;
            retValue.result = translationsRes;

			response.put('response_x', retValue);
        }
    }

	private class LabelTranslatorMock implements WebServiceMock 
	{
        private Map<String, WebServiceMock> mockCalloutDictionary;

        public LabelTranslatorMock(Map<String, WebServiceMock> mockDictionary)
        {
            mockCalloutDictionary = mockDictionary;
        }

		public void doInvoke(
			Object stub, Object request, Map<String, Object> response,
			String endpoint, String soapAction, String requestName,
			String responseNS, String responseName, String responseType) 
		{
            MetadataService.readMetadata_element req = (MetadataService.readMetadata_element)request;
            WebServiceMock mockToExecute = mockCalloutDictionary.get(req.type_x);
            mockToExecute.doInvoke(stub, request, response, endpoint, soapAction, requestName, responseNS, responseName, responseType);
		}
    }

    @isTest
    private static void correct_translation_retrieved_when_it_exists_using_language_code_enum()
    {
        LabelsCalloutMock labelsMock = new LabelsCalloutMock();
        TranslationsCalloutMock translationsMock = new TranslationsCalloutMock();        

        Map<String, WebServiceMock> mocks = new Map<String, WebServiceMock>();
        mocks.put('CustomLabels', labelsMock);
        mocks.put('Translations', translationsMock);

        Test.setMock(WebServiceMock.class, new LabelTranslatorMock(mocks));

        Test.startTest();
        String translation = LabelTranslator.GetTranslationFor(TRAIN_LABEL, Language.FullName.GERMAN);
        Test.stopTest();

        System.assertEquals('Zug', translation, 'The translation should have been retrieved correctly');
    }

    @isTest
    private static void correct_translation_retrieved_when_it_exists_using_language_code_string()
    {
        LabelsCalloutMock labelsMock = new LabelsCalloutMock();
        TranslationsCalloutMock translationsMock = new TranslationsCalloutMock();        

        Map<String, WebServiceMock> mocks = new Map<String, WebServiceMock>();
        mocks.put('CustomLabels', labelsMock);
        mocks.put('Translations', translationsMock);

        Test.setMock(WebServiceMock.class, new LabelTranslatorMock(mocks));

        Test.startTest();
        String translation = LabelTranslator.GetTranslationFor(TRAIN_LABEL, 'de');
        Test.stopTest();

        System.assertEquals('Zug', translation, 'The translation should have been retrieved correctly');
    }

    @isTest
    private static void no_exception_and_empty_string_returned_when_requested_language_is_not_set_up()
    {
        LabelsCalloutMock labelsMock = new LabelsCalloutMock();
        TranslationsCalloutMock translationsMock = new TranslationsCalloutMock();        

        Map<String, WebServiceMock> mocks = new Map<String, WebServiceMock>();
        mocks.put('CustomLabels', labelsMock);
        mocks.put('Translations', translationsMock);

        Test.setMock(WebServiceMock.class, new LabelTranslatorMock(mocks));

        Exception anyEx = null;
        String translation;

        Test.startTest();
        try {
            translation = LabelTranslator.GetTranslationFor(TRAIN_LABEL, 'sv');    
        } catch (Exception ex) {
            anyEx = ex;
        }        
        Test.stopTest();

        System.assertEquals(null, anyEx, 'No exception should have been thrown when asking for a non-existent lanugage');
        System.assertEquals(true, String.isEmpty(translation), 'An empty string should have been returned when asking for a non-existent language');
    }

    @isTest
    private static void no_exception_and_empty_string_returned_when_label_with_no_translation_is_requested()
    {
        LabelsCalloutMock labelsMock = new LabelsCalloutMock();
        TranslationsCalloutMock translationsMock = new TranslationsCalloutMock();        

        Map<String, WebServiceMock> mocks = new Map<String, WebServiceMock>();
        mocks.put('CustomLabels', labelsMock);
        mocks.put('Translations', translationsMock);

        Test.setMock(WebServiceMock.class, new LabelTranslatorMock(mocks));

        Exception anyEx = null;
        String translation;

        Test.startTest();
        try {
            translation = LabelTranslator.GetTranslationFor(PLANE_LABEL, 'de');    
        } catch (Exception ex) {
            anyEx = ex;
        }        
        Test.stopTest();

        System.assertEquals(null, anyEx, 'No exception should have been thrown when asking for a non-existent translation');
        System.assertEquals(true, String.isEmpty(translation), 'An empty string should have been returned when asking for a non-existent translation');
    }

    @isTest
    private static void no_exception_and_empty_string_returned_when_label_with_no_language_or_translation_is_requested()
    {
        LabelsCalloutMock labelsMock = new LabelsCalloutMock();
        TranslationsCalloutMock translationsMock = new TranslationsCalloutMock();        

        Map<String, WebServiceMock> mocks = new Map<String, WebServiceMock>();
        mocks.put('CustomLabels', labelsMock);
        mocks.put('Translations', translationsMock);

        Test.setMock(WebServiceMock.class, new LabelTranslatorMock(mocks));

        Exception anyEx = null;
        String translation;

        Test.startTest();
        try {
            translation = LabelTranslator.GetTranslationFor(PLANE_LABEL, 'sv');    
        } catch (Exception ex) {
            anyEx = ex;
        }        
        Test.stopTest();

        System.assertEquals(null, anyEx, 'No exception should have been thrown when asking for a non-existent label and translation');
        System.assertEquals(true, String.isEmpty(translation), 'An empty string should have been returned when asking for a non-existent label and translation');
    }

    @isTest
    private static void no_exception_and_empty_string_returned_when_reqested_language_is_not_set_up_using_enum()
    {
        LabelsCalloutMock labelsMock = new LabelsCalloutMock();
        TranslationsCalloutMock translationsMock = new TranslationsCalloutMock();        

        Map<String, WebServiceMock> mocks = new Map<String, WebServiceMock>();
        mocks.put('CustomLabels', labelsMock);
        mocks.put('Translations', translationsMock);

        Test.setMock(WebServiceMock.class, new LabelTranslatorMock(mocks));

        Exception anyEx = null;
        String translation;

        Test.startTest();
        try {
            translation = LabelTranslator.GetTranslationFor(TRAIN_LABEL, Language.FullName.FINNISH);
        } catch (Exception ex) {
            anyEx = ex;
        }        
        Test.stopTest();

        System.assertEquals(null, anyEx, 'No exception should have been thrown when asking for a non-existent language via the enum');
        System.assertEquals(true, String.isEmpty(translation), 'An empty string should have been returned when asking for a non-existent language via the enum');
    }
}