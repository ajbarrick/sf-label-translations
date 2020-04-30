/**
 * Copyright (c) 2012, FinancialForce.com, inc
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without modification, 
 *   are permitted provided that the following conditions are met:
 *
 * - Redistributions of source code must retain the above copyright notice, 
 *      this list of conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright notice, 
 *      this list of conditions and the following disclaimer in the documentation 
 *      and/or other materials provided with the distribution.
 * - Neither the name of the FinancialForce.com, inc nor the names of its contributors 
 *      may be used to endorse or promote products derived from this software without 
 *      specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND 
 *  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES 
 *  OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL 
 *  THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, 
 *  EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 *  OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY
 *  OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 *  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
**/

/**
 * This is a dummy test class to obtain 100% coverage for the generated WSDL2Apex code, it is not a funcitonal test class
 **/ 
@isTest  
private class MetadataServiceTest
{    
    /**
     * Dummy Metadata API web service mock class (see MetadataCreateJobTest.cls for a better example)
     **/
	private class WebServiceMockImpl implements WebServiceMock 
	{
		public void doInvoke(
			Object stub, Object request, Map<String, Object> response,
			String endpoint, String soapAction, String requestName,
			String responseNS, String responseName, String responseType) 
		{
			return;
		}
	}    
		
	@IsTest
	private static void coverGeneratedCodeCRUDOperations()
	{	
    	// Null Web Service mock implementation
        System.Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        // Only required to workaround a current code coverage bug in the platform
        MetadataService metaDataService = new MetadataService();
        // Invoke operations     
        Test.startTest();    
        MetadataService.MetadataPort metaDataPort = new MetadataService.MetadataPort();
        Test.stopTest();
	}

	@IsTest
    private static void coverGeneratedCodeTypes()
    {    	       
        // Reference types
        Test.startTest();
        new MetadataService();
        new MetadataService.LogInfo();
        new MetadataService.CustomDataTypeTranslation();
        new MetadataService.CallOptions_element();
        new MetadataService.ScontrolTranslation();
        new MetadataService.CustomTabTranslation();
        new MetadataService.DebuggingHeader_element();
        new MetadataService.CustomDataTypeComponentTranslation();
        new MetadataService.ReportTypeSectionTranslation();
        new MetadataService.CustomLabel();
        new MetadataService.Metadata();
        new MetadataService.SessionHeader_element();
        new MetadataService.Translations();
        new MetadataService.ReportTypeTranslation();
        new MetadataService.CustomApplicationTranslation();
        new MetadataService.CustomLabels();
        new MetadataService.ReportTypeColumnTranslation();
        new MetadataService.CustomPageWebLinkTranslation();
        new MetadataService.CustomLabelTranslation();
        new MetadataService.DebuggingInfo_element();
		new MetadataService.GlobalQuickActionTranslation();      
        new MetadataService.readMetadata_element();
        new MetadataService.ReadCustomLabelResult();
        new MetadataService.ReadTranslationsResult();
        new MetadataService.readCustomLabelResponse_element();
        new MetadataService.ReadCustomLabelsResult();
        new MetadataService.readCustomLabelsResponse_element();
        new MetaDataService.AllOrNoneHeader_element();
        new MetadataService.readTranslationsResponse_element();
        Test.stopTest();
    }

    @IsTest
    private static void elfMissingGetRecordsTest() { // elf patch
        Test.startTest();
        new MetadataService.ReadCustomLabelsResult().getRecords();
        new MetadataService.ReadCustomLabelResult().getRecords();
        new MetadataService.ReadTranslationsResult().getRecords();
        Test.stopTest();
    }

    @IsTest
    private static void elfMissingGetResultTest() { // elf patch
        Test.startTest();
        new MetadataService.readCustomLabelResponse_element().getResult();
        new MetadataService.readCustomLabelsResponse_element().getResult();
        new MetadataService.readTranslationsResponse_element().getResult();
        Test.stopTest();
    }    
}