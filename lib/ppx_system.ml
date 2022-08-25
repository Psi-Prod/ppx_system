open Ppxlib

let system_ext =
  Extension.V3.declare Expander.SystemExp.deriver Extension.Context.expression
    Ast_pattern.(single_expr_payload __)
    Expander.SystemExp.expand

let get_system_ext =
  Extension.declare "get_system" Extension.Context.expression
    Ast_pattern.(pstr nil)
    Expander.GetSystemExp.expand

let () =
  Driver.register_transformation
    ~extensions:[ system_ext; get_system_ext ]
    "ppx_system"
