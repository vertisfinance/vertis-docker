/* eventformatter.i */

%{

#include "blpapi_eventformatter.h"

int blpapi_EventFormatter_setValueFloat(
    blpapi_EventFormatter_t* formatter,
    char const* typeString,
    const blpapi_Name_t* typeName,
    blpapi_Float64_t value)
{
    // The C interface will not silently discard precision to store a 64-bit
    // float in a field whose schema type is 32-bit, however all Python floats
    // are 64-bit, so we explicitly allow narrowing to 32 bits if necessary.

    int ret = blpapi_EventFormatter_setValueFloat64(formatter, typeString,
                                                    typeName, value);
    if (ret) {
        ret = blpapi_EventFormatter_setValueFloat32(formatter, typeString,
                                                    typeName, value);
    }

    return ret;
}

int blpapi_EventFormatter_appendValueFloat(
    blpapi_EventFormatter_t* formatter,
    blpapi_Float64_t value)
{
    // The C interface will not silently discard precision to store a 64-bit
    // float in a field whose schema type is 32-bit, however all Python floats
    // are 64-bit, so we explicitly allow narrowing to 32 bits if necessary.

    int ret = blpapi_EventFormatter_appendValueFloat64(formatter, value);

    if (ret) {
        ret = blpapi_EventFormatter_appendValueFloat32(formatter, value);
    }

    return ret;
}

%}

%ignore blpapi_EventFormatter_setValueFloat32;
%ignore blpapi_EventFormatter_setValueFloat64;
%ignore blpapi_EventFormatter_appendValueFloat32;
%ignore blpapi_EventFormatter_appendValueFloat64;

int blpapi_EventFormatter_setValueFloat(
    blpapi_EventFormatter_t* formatter,
    char const* typeString,
    const blpapi_Name_t* typeName,
    blpapi_Float64_t value);

int blpapi_EventFormatter_appendValueFloat(
    blpapi_EventFormatter_t* formatter,
    blpapi_Float64_t value);

%include "blpapi_eventformatter.h"

