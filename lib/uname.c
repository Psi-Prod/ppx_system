#define CAML_NAME_SPACE
#include <caml/mlvalues.h>
#include <caml/alloc.h>
#include <caml/custom.h>
#include <caml/memory.h>
#include <caml/fail.h>
#include <caml/callback.h>

#ifdef _WIN32

CAMLprim value sysname(value unit) {};

#else

#include <sys/utsname.h>

CAMLprim value sysname(value unit) {
  CAMLparam1(unit);

  struct utsname uname_data;

  if (uname(&uname_data) == 0) {
    CAMLreturn(caml_copy_string(uname_data.sysname));
  } else {
    caml_raise_constant(*caml_named_value("uname_exn_error"));
  }
}

#endif
