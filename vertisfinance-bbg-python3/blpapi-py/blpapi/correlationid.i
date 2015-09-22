/* correlationid.i */

%{

#include "blpapi_correlationid.h"

int pyObjectManagerFunc(
    blpapi_ManagedPtr_t *managedPtr, 
    const blpapi_ManagedPtr_t *srcPtr, 
    int operation)
{
    SWIG_PYTHON_THREAD_BEGIN_BLOCK;
    if (operation == BLPAPI_MANAGEDPTR_COPY) {
        managedPtr->pointer = srcPtr->pointer;
        managedPtr->manager = srcPtr->manager;
        Py_INCREF(reinterpret_cast<PyObject *>(managedPtr->pointer));
    }
    else if (operation == BLPAPI_MANAGEDPTR_DESTROY) {
        Py_DECREF(reinterpret_cast<PyObject *>(managedPtr->pointer));
    }
    SWIG_PYTHON_THREAD_END_BLOCK;

    return 0;
}

blpapi_CorrelationId_t *CorrelationId_t_createEmpty()
{
    SWIG_PYTHON_THREAD_BEGIN_ALLOW;
    blpapi_CorrelationId_t *cid = new blpapi_CorrelationId_t;
    std::memset(cid, 0, sizeof(blpapi_CorrelationId_t));
    SWIG_PYTHON_THREAD_END_ALLOW;
    
    return cid;
}

blpapi_CorrelationId_t *CorrelationId_t_createFromInteger(long long value, unsigned short classId)
{
    SWIG_PYTHON_THREAD_BEGIN_ALLOW;
    blpapi_CorrelationId_t *cid = new blpapi_CorrelationId_t;
    std::memset(cid, 0, sizeof(blpapi_CorrelationId_t));

    cid->size = sizeof(blpapi_CorrelationId_t);
    cid->valueType = BLPAPI_CORRELATION_TYPE_INT;
    cid->classId = classId;
    cid->value.intValue = value;
    SWIG_PYTHON_THREAD_END_ALLOW;
    
    return cid;
}

blpapi_CorrelationId_t *CorrelationId_t_createFromObject(PyObject *value, unsigned short classId)
{
    if (!value) {
        value = Py_None;
    }
    
    SWIG_PYTHON_THREAD_BEGIN_ALLOW;
    blpapi_CorrelationId_t *cid = new blpapi_CorrelationId_t;
    std::memset(cid, 0, sizeof(blpapi_CorrelationId_t));
    
    cid->size = sizeof(blpapi_CorrelationId_t);
    cid->valueType = BLPAPI_CORRELATION_TYPE_POINTER;
    cid->classId = classId;
    
    cid->value.ptrValue.manager = &pyObjectManagerFunc;
    cid->value.ptrValue.pointer = value;
    SWIG_PYTHON_THREAD_END_ALLOW;
    
    Py_INCREF(value);
    
    return cid;
}

blpapi_CorrelationId_t *CorrelationId_t_clone(const blpapi_CorrelationId_t& original)
{
    SWIG_PYTHON_THREAD_BEGIN_ALLOW;
    blpapi_CorrelationId_t *cid = new blpapi_CorrelationId_t(original);
    SWIG_PYTHON_THREAD_END_ALLOW;

    if (BLPAPI_CORRELATION_TYPE_POINTER == cid->valueType) {
        blpapi_ManagedPtr_ManagerFunction_t& manager =
            cid->value.ptrValue.manager;
        if (manager) {
            manager(&cid->value.ptrValue, &original.value.ptrValue, 
                BLPAPI_MANAGEDPTR_COPY);
        }
    }

    return cid;
}

void CorrelationId_t_cleanup(blpapi_CorrelationId_t& cid)
{
    if (BLPAPI_CORRELATION_TYPE_POINTER == cid.valueType) {
        blpapi_ManagedPtr_ManagerFunction_t &manager = 
            cid.value.ptrValue.manager;
        if (manager) {
            manager(&cid.value.ptrValue, 0, BLPAPI_MANAGEDPTR_DESTROY);
        }
    }
}

void CorrelationId_t_delete(blpapi_CorrelationId_t *cid)
{
    if (!cid) {
        return;
    }

    CorrelationId_t_cleanup(*cid);
    
    SWIG_PYTHON_THREAD_BEGIN_ALLOW;
    delete cid;
    SWIG_PYTHON_THREAD_END_ALLOW;
}

bool CorrelationId_t_equals(
    const blpapi_CorrelationId_t& cid1, 
    const blpapi_CorrelationId_t& cid2)
{
    if (cid1.valueType != cid2.valueType) {
        return false;
    }

    if (cid1.classId != cid2.classId) {
        return false;
    }
    
    if (cid1.valueType == BLPAPI_CORRELATION_TYPE_POINTER) {
        return cid1.value.ptrValue.pointer == cid2.value.ptrValue.pointer;
    } else {
        return cid1.value.intValue == cid2.value.intValue;
    }
}

long long CorrelationId_t_toInteger(const blpapi_CorrelationId_t& cid)
{
    if (cid.valueType == BLPAPI_CORRELATION_TYPE_POINTER)
        return reinterpret_cast<long long>(cid.value.ptrValue.pointer);
    return cid.value.intValue;
}

PyObject *CorrelationId_t_getObject(const blpapi_CorrelationId_t& cid) {
    PyObject *res;

    if (BLPAPI_CORRELATION_TYPE_POINTER == cid.valueType
        && &pyObjectManagerFunc == cid.value.ptrValue.manager)
    {
        res = reinterpret_cast<PyObject *>(cid.value.ptrValue.pointer);
    }
    else {
        res = Py_None;
    }

    Py_INCREF(res); 
    return res;
}

%}

%typemap(in, optimal="1", numinputs=0, noblock=1) blpapi_CorrelationId_t *OUTPUT (blpapi_CorrelationId_t temp) {
    $1 = &temp;
}

%typemap(argout, optimal="1", numinputs=0, noblock=1) blpapi_CorrelationId_t *OUTPUT {
    %append_output(SWIG_NewPointerObj(CorrelationId_t_clone(*$1), $1_descriptor, SWIG_POINTER_OWN));
}

%typemap(out) blpapi_CorrelationId_t {
    %append_output(SWIG_NewPointerObj(CorrelationId_t_clone($1), $&1_descriptor, SWIG_POINTER_OWN));
}

%apply blpapi_CorrelationId_t *OUTPUT { blpapi_CorrelationId_t *result }

%nothread;
%novaluewrapper blpapi_CorrelationId_t_;
%rename("CorrelationId") blpapi_CorrelationId_t_;

bool CorrelationId_t_equals(
    const blpapi_CorrelationId_t& cid1, 
    const blpapi_CorrelationId_t& cid2);

%feature("docstring") blpapi_CorrelationId_t_
"A key used to identify individual subscriptions or requests.

CorrelationId([value[, classId=0]]) constructs a CorrelationId object.
If 'value' is integer (either int or long) then created CorrelationId will have
type() == CorrelationId.INT_TYPE. Otherwise it will have
type() == CorrelationId.OBJECT_TYPE. If no arguments are specified
then it will have type() == CorrelationId.UNSET_TYPE.

Two CorrelationIds are considered equal if they have the same
type() and:
- holds the same (not just equal!) objects in case of
    type() == CorrelationId.OBJECT_TYPE
- holds equal integers in case of
    type() == CorrelationId.INT_TYPE or
    type() == CorrelationId.AUTOGEN_TYPE
- True otherwise
    (i.e. in case of type() == CorrelationId.UNSET_TYPE)

It is possible that an user constructed CorrelationId and a
CorrelationId generated by the API could return the same
result for value(). However, they will not compare equal because
they have different type().

CorrelationId objects are passed to many of the Session object
methods which initiate an asynchronous operations and are
obtained from Message objects which are delivered as a result
of those asynchronous operations.

When subscribing or requesting information an application has
the choice of providing a CorrelationId they construct
themselves or allowing the session to construct one for
them. If the application supplies a CorrelationId it must not
re-use the value contained in it in another CorrelationId
whilst the original request or subscription is still active.

Class attributes:
    Possible return values for type() method:
        UNSET_TYPE      The CorrelationId is unset. That is, it was created by
                        the default CorrelationId constructor.
        INT_TYPE        The CorrelationId was created from an integer (or long)
                        supplied by the user.
        OBJECT_TYPE     The CorrelationId was created from an object supplied by
                        the user.
        AUTOGEN_TYPE    The CorrelationId was created internally by API.

    MAX_CLASS_ID    The maximum value allowed for classId.";

//%feature("docstring") blpapi_CorrelationId_t_::blpapi_CorrelationId_t
//"Constructor";

%feature("docstring") blpapi_CorrelationId_t_::type
"Return the type of this CorrelationId object (see xxx_TYPE class attributes)";

%feature("docstring") blpapi_CorrelationId_t_::classId
"Return the user defined classification of this CorrelationId object";


%extend blpapi_CorrelationId_t_ {
    %pythoncode {
        UNSET_TYPE = _internals.CORRELATION_TYPE_UNSET

        INT_TYPE = _internals.CORRELATION_TYPE_INT

        OBJECT_TYPE = _internals.CORRELATION_TYPE_POINTER
        
        AUTOGEN_TYPE = _internals.CORRELATION_TYPE_AUTOGEN

        MAX_CLASS_ID = _internals.CORRELATION_MAX_CLASS_ID
        
        __TYPE_NAMES = {
            _internals.CORRELATION_TYPE_UNSET: "UNSET",
            _internals.CORRELATION_TYPE_INT: "INTEGER",
            _internals.CORRELATION_TYPE_POINTER: "OBJECT",
            _internals.CORRELATION_TYPE_AUTOGEN: "AUTOGEN"
        }
        
        def __str__(self):
            """x.__str__() <==> str(x)"""
            valueType = self.type()
            valueTypeName = CorrelationId.__TYPE_NAMES[valueType] 
            
            if valueType == CorrelationId.UNSET_TYPE:
                return valueTypeName
            else:
                return "({0}: {1!r}, ClassId: {2})".format(
                    valueTypeName, self.value(), self.classId())

        def __hash__(self):
            return hash((self.type(), self.classId(), self.__toInteger()))

        def __eq__(self, other):
            """x.__eq__(y) <==> x==y"""
            try:
                return CorrelationId_t_equals(self, other)
            except Exception:
                return NotImplemented

        def __ne__(self, other):
            """x.__ne__(y) <==> x!=y"""
            equal = self.__eq__(other)
            return NotImplemented if equal is NotImplemented else not equal
        
        def value(self):
            """Return the value of this CorrelationId object. The return value
            depends on this CorrelationId's value type and could be:
                - integer (type() == CorrelationId.INT_TYPE
                    or type() == CorrelationId.AUTOGEN_TYPE)
                - object (type() == CorrelationId.OBJECT_TYPE)
                - None (type() == CorrelationId.UNSET_TYPE)
            """
            valueType = self.type()
            if valueType == CorrelationId.INT_TYPE \
                    or valueType == CorrelationId.AUTOGEN_TYPE:
                return self.__asInteger()
            elif valueType == CorrelationId.OBJECT_TYPE:
                return self.__asObject()
            else:
                return None
        
        # Just for compatibility with other wrappers
        def _handle(self):
            return self
    }
    
    blpapi_CorrelationId_t()
    {
        return CorrelationId_t_createEmpty();
    }

    blpapi_CorrelationId_t(long long value, unsigned short classId = 0)
    {
        return CorrelationId_t_createFromInteger(value, classId);
    }

    blpapi_CorrelationId_t(PyObject *value, unsigned short classId = 0)
    {
        return CorrelationId_t_createFromObject(value, classId);
    }

    ~blpapi_CorrelationId_t() 
    {
        CorrelationId_t_delete(($self));
    }
    
    unsigned short type() const
    {
        return $self->valueType;
    }

    unsigned short classId() const
    {
        return $self->classId;
    }
    
    PyObject *__asObject() const
    {
        return CorrelationId_t_getObject(*$self);
    }

    long long __asInteger() const
    {
        return $self->value.intValue;
    }

    long long __toInteger() const
    {
        return CorrelationId_t_toInteger(*$self);
    }
}

// Ignore all "built-in" members of CorrelationId_t
%rename("$ignore", regextarget=1, fullname=1) "blpapi_CorrelationId_t_::.*$";

%ignore BloombergLP::blpapi::CorrelationId;
%ignore blpapi_ManagedPtr_t_data_;
%ignore blpapi_ManagedPtr_t_;

%include "blpapi_correlationid.h"

%clearnothread;

