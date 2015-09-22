/* internals.i */

%define DOCSTRING
"This module defines internals of BLPAPI-Py and the following classes:
- CorrelationId: a key to track requests and subscriptions

Copyright 2012. Bloomberg Finance L.P.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the \"Software\"), to
deal in the Software without restriction, including without limitation the
rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
sell copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:  The above
copyright notice and this permission notice shall be included in all copies
or substantial portions of the Software.

THE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
IN THE SOFTWARE."
%enddef

%module(docstring=DOCSTRING, threads="1") internals
# for NONNULL pointers
%include "constraints.i"

%apply Pointer NONNULL { const char* groupId };


#pragma SWIG nowarn=312,362

namespace BloombergLP { namespace blpapi {

// Ignore all C++ part of BLPAPI
%rename("$ignore", regextarget=1, fullname=1) ".+";
%ignore operator==;
%ignore operator!=;
%ignore operator>=;
%ignore operator>;
%ignore operator<=;
%ignore operator<;
%ignore operator<<;
%ignore operator>>;

}}

// Strip BLPAPI_ prefix from defines
// Shorter version (%rename("%(strip:[BLPAPI_])s") "";) appears to be case
// sensitive, use this one.
%rename("%(strip:[BLPAPI_])s", regextarget=1) "BLPAPI_.+";

// Enums which have no related defined constants

%constant int TOPICLIST_NOT_CREATED =
     BloombergLP::blpapi::TopicList::NOT_CREATED;
%constant int TOPICLIST_CREATED =
    BloombergLP::blpapi::TopicList::CREATED;
%constant int TOPICLIST_FAILURE =
     BloombergLP::blpapi::TopicList::FAILURE;

%constant int RESOLUTIONLIST_UNRESOLVED =
    BloombergLP::blpapi::ResolutionList::UNRESOLVED;
%constant int RESOLUTIONLIST_RESOLVED =
    BloombergLP::blpapi::ResolutionList::RESOLVED;
%constant int RESOLUTIONLIST_RESOLUTION_FAILURE_BAD_SERVICE =
    BloombergLP::blpapi::ResolutionList::RESOLUTION_FAILURE_BAD_SERVICE;
%constant int RESOLUTIONLIST_RESOLUTION_FAILURE_SERVICE_AUTHORIZATION_FAILED =
    BloombergLP::blpapi::ResolutionList::RESOLUTION_FAILURE_SERVICE_AUTHORIZATION_FAILED;
%constant int RESOLUTIONLIST_RESOLUTION_FAILURE_BAD_TOPIC =
    BloombergLP::blpapi::ResolutionList::RESOLUTION_FAILURE_BAD_TOPIC;
%constant int RESOLUTIONLIST_RESOLUTION_FAILURE_TOPIC_AUTHORIZATION_FAILED =
    BloombergLP::blpapi::ResolutionList::RESOLUTION_FAILURE_TOPIC_AUTHORIZATION_FAILED;



// Nonempty Windows-specific BLPAPI_EXPORT definition breaks the SWIG,
// so replace it with empty one.
#undef BLPAPI_EXPORT
#define BLPAPI_EXPORT

%{
#define SWIG_FILE_WITH_INIT
#include "blpapi_types.h"
%}

%include "std_string.i"

// UserHandle is deprecated so we skip it
%ignore blpapi_UserHandle_release;
%ignore blpapi_UserHandle_addRef;
%ignore blpapi_UserHandle_hasEntitlements;

// Ignore unused C functions
%ignore blpapi_Session_create;
%ignore blpapi_Session_destroy;
%ignore blpapi_Session_cancel;
%ignore blpapi_Session_sendAuthorizationRequest;
%ignore blpapi_Session_openService;
%ignore blpapi_Session_openServiceAsync;
%ignore blpapi_Session_generateToken;
%ignore blpapi_Session_getService;
%ignore blpapi_Session_createUserHandle;
%ignore blpapi_Session_createIdentity;
%ignore blpapi_SessionOptions_duplicate;
%ignore blpapi_SessionOptions_copy;
%ignore blpapi_Message_typeString;
%ignore blpapi_Event_addRef;
%ignore blpapi_EventDispatcher_dispatchEvents;
%ignore blpapi_Service_print;
%ignore blpapi_SubscriptionList_add;
%ignore blpapi_Name_duplicate;
%ignore blpapi_Datetime_compare;
%ignore blpapi_Datetime_print;
%ignore blpapi_SchemaElementDefinition_print;
%ignore blpapi_SchemaTypeDefinition_print;
%ignore blpapi_SchemaTypeDefinition_isComplex;
%ignore blpapi_SchemaTypeDefinition_isSimple;
%ignore blpapi_SchemaTypeDefinition_isEnumeration;
%ignore blpapi_Constant_getValueAsChar;
%ignore blpapi_Constant_getValueAsInt32;
%ignore blpapi_Constant_getValueAsFloat32;


// WIP/TODO
%ignore blpapi_SubscriptionItr_create;
%ignore blpapi_SubscriptionItr_destroy;
%ignore blpapi_SubscriptionItr_next;
%ignore blpapi_SubscriptionItr_isValid;

%ignore blpapi_SchemaElementDefinition_setUserData;
%ignore blpapi_SchemaElementDefinition_userData;
%ignore blpapi_SchemaTypeDefinition_setUserData;
%ignore blpapi_SchemaTypeDefinition_userData;
%ignore blpapi_Constant_setUserData;
%ignore blpapi_Constant_userData;
%ignore blpapi_ConstantList_setUserData;
%ignore blpapi_ConstantList_userData;

%ignore blpapi_Message_privateData;

%ignore blpapi_SessionOptions_autoRestart;
%ignore blpapi_SessionOptions_setAutoRestart;
%ignore blpapi_SessionOptions_setMaxEventQueueSize;
%ignore blpapi_SessionOptions_setSlowConsumerWarningHiWaterMark;
%ignore blpapi_SessionOptions_setSlowConsumerWarningLoWaterMark;

// Bind the appropriate type to defines
%constant unsigned ELEMENTDEFINITION_UNBOUNDED = BLPAPI_ELEMENTDEFINITION_UNBOUNDED;
%ignore BLPAPI_ELEMENTDEFINITION_UNBOUNDED;

%constant size_t ELEMENT_INDEX_END = BLPAPI_ELEMENT_INDEX_END;
%ignore BLPAPI_ELEMENT_INDEX_END;

// SWIG fails to add those constants automatically. Do it manually.
%constant int SERVICEREGISTRATIONOPTIONS_PRIORITY_MEDIUM = INT_MAX/2;
%constant int SERVICEREGISTRATIONOPTIONS_PRIORITY_HIGH = INT_MAX;

%include "blpapi_defs.h"

%include "blpapi_types.h"

%{
#include "blpapi_error.h"
#include "blpapi_sessionoptions.h"
#include "blpapi_session.h"
#include "blpapi_service.h"
#include "blpapi_eventdispatcher.h"
#include "blpapi_event.h"
#include "blpapi_message.h"
#include "blpapi_identity.h"
#include "blpapi_request.h"
#include "blpapi_subscriptionlist.h"
#include "blpapi_element.h"
#include "blpapi_schema.h"
#include "blpapi_constant.h"
#include "blpapi_name.h"
#include "blpapi_datetime.h"
#include "blpapi_streamproxy.h"

// publishing support
#include "blpapi_resolutionlist.h"
#include "blpapi_topic.h"
#include "blpapi_topiclist.h"
#include "blpapi_providersession.h"
#include "blpapi_eventformatter.h"

#ifndef MAX_GROUP_ID_SIZE
// MAX_GROUP_ID_SIZE is not defined in BLPAPI, but docs say its value is 64
#define MAX_GROUP_ID_SIZE 64
#endif

#include <sstream> // for std::ostringstream

std::string blpapi_Service_printHelper(
    blpapi_Service_t *service,
    int level,
    int spacesPerLevel)
{
    std::ostringstream stream;

    blpapi_Service_print(
        service,
        BloombergLP::blpapi::OstreamWriter,
        &stream,
        level,
        spacesPerLevel);

    return stream.str();
}

std::string blpapi_SchemaElementDefinition_printHelper(
    blpapi_SchemaElementDefinition_t *item,
    int level,
    int spacesPerLevel)
{
    std::ostringstream stream;

    blpapi_SchemaElementDefinition_print(
        item,
        BloombergLP::blpapi::OstreamWriter,
        &stream,
        level,
        spacesPerLevel);

    return stream.str();
}

std::string blpapi_SchemaTypeDefinition_printHelper(
    blpapi_SchemaTypeDefinition_t *item,
    int level,
    int spacesPerLevel)
{
    std::ostringstream stream;

    blpapi_SchemaTypeDefinition_print(
        item,
        BloombergLP::blpapi::OstreamWriter,
        &stream,
        level,
        spacesPerLevel);

    return stream.str();
}

bool blpapi_SchemaTypeDefinition_hasElementDefinition(
    const blpapi_SchemaTypeDefinition_t *type,
    const char *nameString,
    const blpapi_Name_t *name)
{
    return 0 != blpapi_SchemaTypeDefinition_getElementDefinition(
            type, nameString, name);
}

bool blpapi_ConstantList_hasConstant(
    const blpapi_ConstantList_t *list,
    const char *nameString,
    const blpapi_Name_t *name)
{
    return 0 != blpapi_ConstantList_getConstant(list, nameString, name);
}

bool blpapi_Service_hasEventDefinition(
    blpapi_Service_t *service,
    const char* nameString,
    const blpapi_Name_t *name)
{
    blpapi_SchemaElementDefinition_t *eventDefinition;

    return 0 == blpapi_Service_getEventDefinition(
            service, &eventDefinition, nameString, name);
}

bool blpapi_Service_hasOperation(
    blpapi_Service_t *service,
    const char* nameString,
    const blpapi_Name_t *name)
{
    blpapi_Operation_t *operation;

    return 0 == blpapi_Service_getOperation(
        service, &operation, nameString, name);
}

int blpapi_SubscriptionList_addHelper(
    blpapi_SubscriptionList_t *list,
    const char *topic,
    const blpapi_CorrelationId_t *correlationId,
    const char *fields,
    const char *options)
{
    return blpapi_SubscriptionList_add(
        list,
        topic,
        correlationId,
        &fields,
        &options,
        fields ? 1 : 0,
        options ? 1: 0);
}

bool blpapi_Name_hasName(const char *nameString)
{
    return blpapi_Name_findName(nameString) ? true : false;
}

blpapi_TopicList_t* blpapi_TopicList_createFromResolutionList(
    blpapi_ResolutionList_t* from)
{
    return blpapi_TopicList_create(reinterpret_cast<blpapi_TopicList_t*>(from));
}

%}

std::string blpapi_Service_printHelper(
    blpapi_Service_t *service,
    int level,
    int spacesPerLevel);

std::string blpapi_SchemaElementDefinition_printHelper(
    blpapi_SchemaElementDefinition_t *item,
    int level,
    int spacesPerLevel);

std::string blpapi_SchemaTypeDefinition_printHelper(
    blpapi_SchemaTypeDefinition_t *item,
    int level,
    int spacesPerLevel);

bool blpapi_SchemaTypeDefinition_hasElementDefinition(
    const blpapi_SchemaTypeDefinition_t *type,
    const char *nameString,
    const blpapi_Name_t *name);

bool blpapi_ConstantList_hasConstant(
    const blpapi_ConstantList_t *list,
    const char *nameString,
    const blpapi_Name_t *name);

bool blpapi_Service_hasEventDefinition(
    blpapi_Service_t *service,
    const char* nameString,
    const blpapi_Name_t *name);

bool blpapi_Service_hasOperation(
    blpapi_Service_t *service,
    const char* nameString,
    const blpapi_Name_t *name);

int blpapi_SubscriptionList_addHelper(
    blpapi_SubscriptionList_t *list,
    const char *topic,
    const blpapi_CorrelationId_t *correlationId,
    const char *fields,
    const char *options);

bool blpapi_Name_hasName(const char *nameString);

blpapi_TopicList_t* blpapi_TopicList_createFromResolutionList(
    blpapi_ResolutionList_t* from);

%typemap(in) PyObject * {
    $1 = $input;
}

%typemap(out) PyObject * {
    $result = $1;
}

%typemap(in, optimal="1", numinputs=0, noblock=1) blpapi_Element_t **OUTPUT (blpapi_Element_t *temp = 0) {
    $1 = &temp;
}
%typemap(argout, optimal="1", numinputs=0, noblock=1) blpapi_Element_t **OUTPUT {
    %append_output(SWIG_NewPointerObj((*$1), $*1_descriptor, 0));
}
%apply blpapi_Element_t **OUTPUT { blpapi_Element_t **result };
%apply blpapi_Element_t **OUTPUT { blpapi_Element_t **buffer };
%apply blpapi_Element_t **OUTPUT { blpapi_Element_t **appendedElement };
%apply blpapi_Element_t **OUTPUT { blpapi_Element_t **resultElement };


%typemap(in, optimal="1", numinputs=0, noblock=1) blpapi_Event_t **OUTPUT (blpapi_Event_t *temp = 0) {
    $1 = &temp;
}
%typemap(argout, optimal="1", numinputs=0, noblock=1) blpapi_Event_t **OUTPUT {
    %append_output(SWIG_NewPointerObj((*$1), $*1_descriptor, 0));
}
%apply blpapi_Event_t **OUTPUT { blpapi_Event_t **eventPointer };
%apply blpapi_Event_t **OUTPUT { blpapi_Event_t **event };


%typemap(in, optimal="1", numinputs=0, noblock=1) blpapi_Service_t **OUTPUT (blpapi_Service_t *temp = 0) {
    $1 = &temp;
}
%typemap(argout, optimal="1", numinputs=0, noblock=1) blpapi_Service_t **OUTPUT {
    %append_output(SWIG_NewPointerObj((*$1), $*1_descriptor, 0));
}
%apply blpapi_Service_t **OUTPUT { blpapi_Service_t **service };


%typemap(in, optimal="1", numinputs=0, noblock=1) blpapi_Message_t **OUTPUT (blpapi_Message_t *temp = 0) {
    $1 = &temp;
}
%typemap(argout, optimal="1", numinputs=0, noblock=1) blpapi_Message_t **OUTPUT {
    %append_output(SWIG_NewPointerObj((*$1), $*1_descriptor, 0));
}
%apply blpapi_Message_t **OUTPUT { blpapi_Message_t **result }


%typemap(in, optimal="1", numinputs=0, noblock=1) blpapi_Topic_t **OUTPUT (blpapi_Topic_t *temp = 0) {
    $1 = &temp;
}
%typemap(argout, optimal="1", numinputs=0, noblock=1) blpapi_Topic_t **OUTPUT {
    %append_output(SWIG_NewPointerObj((*$1), $*1_descriptor, 0));
}
%apply blpapi_Topic_t **OUTPUT { blpapi_Topic_t **result }


%typemap(in, optimal="1", numinputs=0, noblock=1) blpapi_Name_t **OUTPUT (blpapi_Name_t *temp = 0) {
    $1 = &temp;
}
%typemap(argout, optimal="1", numinputs=0, noblock=1) blpapi_Name_t **OUTPUT {
    %append_output(SWIG_NewPointerObj((*$1), $*1_descriptor, 0));
}
%apply blpapi_Name_t **OUTPUT { blpapi_Name_t **buffer }


%typemap(in, optimal="1", numinputs=0, noblock=1) blpapi_Request_t **OUTPUT (blpapi_Request_t *temp = 0) {
    $1 = &temp;
}
%typemap(argout, optimal="1", numinputs=0, noblock=1) blpapi_Request_t **OUTPUT {
    %append_output(SWIG_NewPointerObj((*$1), $*1_descriptor, 0));
}
%apply blpapi_Request_t **OUTPUT { blpapi_Request_t **result };
%apply blpapi_Request_t **OUTPUT { blpapi_Request_t **request };


%typemap(in, optimal="1", numinputs=0, noblock=1) blpapi_SchemaElementDefinition_t **OUTPUT (blpapi_SchemaElementDefinition_t *temp = 0) {
    $1 = &temp;
}
%typemap(argout, optimal="1", numinputs=0, noblock=1) blpapi_SchemaElementDefinition_t **OUTPUT {
    %append_output(SWIG_NewPointerObj((*$1), $*1_descriptor, 0));
}
%apply blpapi_SchemaElementDefinition_t **OUTPUT { blpapi_SchemaElementDefinition_t **result };
%apply blpapi_SchemaElementDefinition_t **OUTPUT { blpapi_SchemaElementDefinition_t **requestDefinition };
%apply blpapi_SchemaElementDefinition_t **OUTPUT { blpapi_SchemaElementDefinition_t **responseDefinition };


%typemap(in, optimal="1", numinputs=0, noblock=1) blpapi_Operation_t **OUTPUT (blpapi_Operation_t *temp = 0) {
    $1 = &temp;
}
%typemap(argout, optimal="1", numinputs=0, noblock=1) blpapi_Operation_t **OUTPUT {
    %append_output(SWIG_NewPointerObj((*$1), $*1_descriptor, 0));
}
%apply blpapi_Operation_t **OUTPUT { blpapi_Operation_t **operation };


%typemap(in, optimal="1", numinputs=0, noblock=1) blpapi_Datetime_t *OUTPUT {
    $1 = new blpapi_Datetime_t;
}
// We set $1 to zero to avoid from deleting it in related 'freearg' typemap
%typemap(argout, optimal="1", numinputs=0, noblock=1) blpapi_Datetime_t *OUTPUT {
    %append_output(SWIG_NewPointerObj(($1), $1_descriptor, SWIG_POINTER_OWN));
    $1 = 0;
}
%typemap(freearg, optimal="1", numinputs=0, noblock=1) blpapi_Datetime_t *OUTPUT {
    if($1) delete $1;
}
%apply blpapi_Datetime_t *OUTPUT { blpapi_Datetime_t *buffer }


%typemap(in, optimal="1", numinputs=0, noblock=1) char **OUTPUT (char *temp = 0) {
    $1 = &temp;
}
%typemap(argout, optimal="1", numinputs=0, noblock=1) char **OUTPUT {
    %append_output(SWIG_FromCharPtr(*$1));
}
%apply char **OUTPUT { const char **buffer }
%apply char **OUTPUT { const char **result }
# for blpapi_TopicList_topicStringAt
%apply char **OUTPUT { const char **topic }

# for blpapi_ServiceRegistrationOptions_setGroupId
%typemap(in) (const char* groupId, unsigned int groupIdLength) {
    $1 = PyString_AsString($input);
    $2 = PyString_Size($input);
}

# for blpapi_ServiceRegistrationOptions_getGroupId
%typemap(in, optimal="1", numinputs=0, noblock=1)
    (char* groupdIdBuffer, int *groupIdLength)
    (char temp[MAX_GROUP_ID_SIZE], int len = MAX_GROUP_ID_SIZE)
{
    $1 = temp;
    $2 = &len;
}
%typemap(argout) (const char* groupdIdBuffer, int *groupIdLength)
{
    %append_output(SWIG_FromCharPtrAndSize($1, *$2));
}

# for blpapi_SessionOptions_getServerAddress
%typemap(in, optimal="1", numinputs=0, noblock=1)
    (const char** serverHost, unsigned short *serverPort)
    (char* tempServerHost = 0, unsigned short tempServerPort = 0)
{
    $1 = &tempServerHost;
    $2 = &tempServerPort;
}
%typemap(argout) (const char** serverHost, unsigned short *serverPort)
{
    %append_output(SWIG_FromCharPtr(*$1));
    %append_output(SWIG_From_int(*$2));
}

%apply blpapi_Bool_t *OUTPUT { blpapi_Bool_t *buffer }

%apply blpapi_Int64_t *OUTPUT { blpapi_Int64_t *buffer }

%apply blpapi_Float64_t *OUTPUT { blpapi_Float64_t *buffer }

%apply int *OUTPUT { int *seatType }
# for blpapi_TopicList_status[At]
%apply int *OUTPUT { int *status }
# for blpapi_TopicList_message[At]
%apply blpapi_Message_t **OUTPUT { blpapi_Message_t** element }
# for blpapi_ResolutionList_attribute[At]
%apply blpapi_Element_t **OUTPUT { blpapi_Element_t** element }
%apply blpapi_Topic_t** OUTPUT { blpapi_Topic_t** topic }

# for hasEntitlements
%include "carrays.i"
%array_class(int, intArray)

%include "correlationid.i"
%include "element.i"
%include "eventformatter.i"
%include "eventhandler.i"
%include "providersession.i"

%include "blpapi_error.h"
%include "blpapi_sessionoptions.h"
%include "blpapi_name.h"
%include "blpapi_subscriptionlist.h"
%include "blpapi_datetime.h"
%include "blpapi_constant.h"
%include "blpapi_schema.h"
%include "blpapi_request.h"
%include "blpapi_service.h"
%include "blpapi_message.h"
%include "blpapi_event.h"
%include "blpapi_identity.h"
%include "blpapi_abstractsession.h"
%include "blpapi_session.h"

# publishing support
%include "blpapi_resolutionlist.h"
%include "blpapi_topic.h"
%include "blpapi_topiclist.h"
%include "blpapi_providersession.h"

