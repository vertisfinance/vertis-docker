/* eventhandler.i */

%{
#include "blpapi_session.h"

void dispatchEventProxy(blpapi_Event_t *event, blpapi_Session_t *, void *userData)
{
    PyObject *eventDispatcherFunc = reinterpret_cast<PyObject *>(userData);
    
    SWIG_PYTHON_THREAD_BEGIN_BLOCK;

    PyObject *arglist = PyTuple_New(1);
    PyTuple_SET_ITEM(arglist, 0, 
        SWIG_NewPointerObj(SWIG_as_voidptr(event), SWIGTYPE_p_blpapi_Event, 0));
    
    PyObject *result = PyEval_CallObject(eventDispatcherFunc, arglist);
    
    Py_DECREF(arglist);
    Py_XDECREF(result);

    SWIG_PYTHON_THREAD_END_BLOCK;
}

blpapi_Session_t *Session_createHelper(blpapi_SessionOptions_t *parameters,
    PyObject *eventHandlerFunc,
    blpapi_EventDispatcher_t *dispatcher)
{
    SWIG_PYTHON_THREAD_BEGIN_ALLOW;
    const bool hasHandler = 
        eventHandlerFunc != 0 && eventHandlerFunc != Py_None;

    blpapi_Session_t *const res = blpapi_Session_create(
        parameters, 
        hasHandler ? &dispatchEventProxy : 0,
        dispatcher,
        hasHandler ? eventHandlerFunc : 0);

    if (!res) {
        return 0;
    } 
    SWIG_PYTHON_THREAD_END_ALLOW;
    
    Py_XINCREF(eventHandlerFunc);
    
    return res;
}

void Session_destroyHelper(blpapi_Session_t *sessionHandle, PyObject *eventHandlerFunc)
{
    SWIG_PYTHON_THREAD_BEGIN_ALLOW;
    blpapi_Session_destroy(sessionHandle);
    SWIG_PYTHON_THREAD_END_ALLOW;
    
    Py_XDECREF(eventHandlerFunc);
}

%}

%nothread Session_createHelper;
%nothread Session_destroyHelper;

blpapi_Session_t *Session_createHelper(blpapi_SessionOptions_t *parameters,
    PyObject *eventHandlerFunc,
    blpapi_EventDispatcher_t *dispatcher);

void Session_destroyHelper(blpapi_Session_t *sessionHandle, PyObject *eventHandlerFunc);

%ignore BloombergLP::blpapi::EventHandler;
%ignore BloombergLP::blpapi::EventDispatcher;
%ignore BloombergLP::blpapi::eventHandlerProxy;

%include "blpapi_eventdispatcher.h"

