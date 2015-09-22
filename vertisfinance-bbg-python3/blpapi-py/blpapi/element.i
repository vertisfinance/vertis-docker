/* element.i */

%include "std_string.i"

%{

#include "blpapi_element.h"
#include <sstream> // for std::ostringstream

int blpapi_Element_setElementFloat(
        blpapi_Element_t *element,
        const char* nameString,
        const blpapi_Name_t* name,
        blpapi_Float64_t value)
{
    // The C interface will not silently discard precision to store a 64-bit
    // float in a field whose schema type is 32-bit, however all Python floats
    // are 64-bit, so we explicitly allow narrowing to 32 bits if necessary.

    blpapi_Element_t *fldt;
    int ret = blpapi_Element_getElement(element, &fldt, nameString, name);
    if (ret == 0) {
        // Able to get field, consider its datatype
        if (blpapi_Element_datatype(fldt) == BLPAPI_DATATYPE_FLOAT32) {
            ret = blpapi_Element_setElementFloat32(element,
                                                   nameString, name, value);
        } else {
            ret = blpapi_Element_setElementFloat64(element,
                                                   nameString, name, value);
        }
        return ret;
    }

    // Unable to get field. Try to set element anyway
    ret = blpapi_Element_setElementFloat64(element,
                                           nameString, name, value);

    if (ret) {
        ret = blpapi_Element_setElementFloat32(element,
                                               nameString, name, value);
    }

    return ret;
}

int blpapi_Element_setValueFloat(
        blpapi_Element_t *element,
        blpapi_Float64_t value,
        size_t index)
{
    // The C interface will not silently discard precision to store a 64-bit
    // float in a field whose schema type is 32-bit, however all Python floats
    // are 64-bit, so we explicitly allow narrowing to 32 bits if necessary.

    int ret;

    // Consider field datatype
    if (blpapi_Element_datatype(element) == BLPAPI_DATATYPE_FLOAT32) {
        ret = blpapi_Element_setValueFloat32(element, value, index);
    } else {
        ret = blpapi_Element_setValueFloat64(element, value, index);
    }

    return ret;
}

std::string blpapi_Element_printHelper(
    blpapi_Element_t *element,
    int level,
    int spacesPerLevel)
{
    std::ostringstream stream;

    blpapi_Element_print(
        element,
        BloombergLP::blpapi::OstreamWriter,
        &stream,
        level,
        spacesPerLevel);

    return stream.str();
}

%}

%ignore blpapi_Element_setElementFloat32;
%ignore blpapi_Element_setElementFloat64;
%ignore blpapi_Element_setValueFloat32;
%ignore blpapi_Element_setValueFloat64;

int blpapi_Element_setElementFloat(
        blpapi_Element_t *element,
        const char* nameString,
        const blpapi_Name_t* name,
        blpapi_Float64_t value);

int blpapi_Element_setValueFloat(
        blpapi_Element_t *element,
        blpapi_Float64_t value,
        size_t index);

std::string blpapi_Element_printHelper(
    blpapi_Element_t *element,
    int level,
    int spacesPerLevel);

// Ignore unused C functions
%ignore blpapi_Element_hasElement;
%ignore blpapi_Element_print;
%ignore blpapi_Element_getValueAsFloat32;
%ignore blpapi_Element_setValueChar;
%ignore blpapi_Element_setValueUChar;
%ignore blpapi_Element_setValueUInt32;
%ignore blpapi_Element_setValueUInt64;
%ignore blpapi_Element_setValueFloat32;
%ignore blpapi_Element_setValueFromElement;
%ignore blpapi_Element_setElementChar;
%ignore blpapi_Element_setElementUChar;
%ignore blpapi_Element_setElementUInt32;
%ignore blpapi_Element_setElementUInt64;
%ignore blpapi_Element_setElementFloat32;
%ignore blpapi_Element_setElementFromField;

%include "blpapi_element.h"

