<cfcomponent extends="mxunit.framework.TestCase">
  
  <cffunction name="beforeTests">
    <cfhttp method="get" url="http://localhost/cfairbrake/tests/fw1_test_app/?reload=true" />
  </cffunction>

  <cffunction name="setUp">
    
  </cffunction>

  <cffunction name="tearDown">
    
  </cffunction>

  <cffunction name="test_bad_entity">
    <cfset run_it("bad_entity","Mapping for component users not found.") />
  </cffunction>

  <cffunction name="test_bad_include">
    <cfset run_it("bad_include","Could not find the included template bad_file.cfm.") /> 
  </cffunction>

  <cffunction name="test_bad_property">
    <cfset run_it("bad_property","The method getFoo was not found in component /vagrant/wwwroot/cfairbrake/tests/entities/user.cfc.") /> 
  </cffunction>

  <cffunction name="test_bad_sql">
    <cfset run_it("bad_sql","Error Executing Database Query.") /> 
  </cffunction>

  <cffunction name="test_bad_syntax">
    <cfset run_it("bad_syntax","Invalid CFML construct found on line 2 at column 12.") /> 
  </cffunction>

  <cffunction name="test_divide_by_zero">
    <cfset run_it("divide_by_zero","Division by zero.") /> 
  </cffunction>

  <cffunction name="test_null_pointer">
    <cfset run_it("null_pointer","Variable Y is undefined.") /> 
  </cffunction>

  <cffunction name="test_session_data">
    <cfset var http_result ="" />
    <cfset var raw_notice = "" />
    <cfset var xml_notice = "" />
    <cfhttp method="get" url="http://localhost/cfairbrake/tests/fw1_test_app/index.cfm?action=main.bad_sql" />
    <cffile action="read" file="/vagrant/wwwroot/cfairbrake/tests/output/output.xml" variable="raw_notice" />
    <cfset xml_notice = XmlParse(raw_notice,false,"/vagrant/wwwroot/cfairbrake/tests/airbrake_2_3.xsd") />
    <cfset AssertTrue( ArrayLen(xml_notice['notice']['request']['session'].xmlchildren) gt 0 ) /> 
  </cffunction>

  <cffunction name="test_user_data">
    <cfset var http_result ="" />
    <cfset var raw_notice = "" />
    <cfset var xml_notice = "" />
    <cfhttp method="get" url="http://localhost/cfairbrake/tests/fw1_test_app/index.cfm?action=main.bad_sql" />
    <cffile action="read" file="/vagrant/wwwroot/cfairbrake/tests/output/output.xml" variable="raw_notice" />
    <cfset xml_notice = XmlParse(raw_notice,false,"/vagrant/wwwroot/cfairbrake/tests/airbrake_2_3.xsd") />
    <cfset AssertEquals( "1", xml_notice['notice']['current-user']['id'].xmltext ) />
  </cffunction>

  <cffunction name="test_error_data">
    <cfset var http_result ="" />
    <cfset var raw_notice = "" />
    <cfset var xml_notice = "" />
    <cfset var error_element = "" />
    <cfhttp method="get" url="http://localhost/cfairbrake/tests/fw1_test_app/index.cfm?action=main.bad_sql" />
    <cffile action="read" file="/vagrant/wwwroot/cfairbrake/tests/output/output.xml" variable="raw_notice" />
    <cfset xml_notice = XmlParse(raw_notice,false,"/vagrant/wwwroot/cfairbrake/tests/airbrake_2_3.xsd") />
    <cfset error_element = XmlSearch(xml_notice,"/notice/request/cgi-data/var[@key='CF_ERROR_DATASOURCE']") />
    <cfset AssertEquals("cfairbrake",error_element[1].xmltext) />
  </cffunction>

  <cffunction access="private" name="run_it">
    <cfargument name="action"/>
    <cfargument name="message"/>
    <cfargument name="debug_it" default="false" />
    <cfset var http_result ="" />
    <cfset var raw_notice = "" />
    <cfset var xml_notice = "" />
    <cfhttp method="get" url="http://localhost/cfairbrake/tests/fw1_test_app/index.cfm?action=main.#arguments.action#" />
    <cffile action="read" file="/vagrant/wwwroot/cfairbrake/tests/output/output.xml" variable="raw_notice" />
    <cfset xml_notice = XmlParse(raw_notice,false,"/vagrant/wwwroot/cfairbrake/tests/airbrake_2_3.xsd") />
    <cfif debug_it>
      <cfset Debug(xml_notice) />
    </cfif>
    <cfset AssertEquals( arguments.message, xml_notice.notice.error.message.xmltext ) />     
  </cffunction>


</cfcomponent>