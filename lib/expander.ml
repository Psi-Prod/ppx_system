open Ppxlib

module SystemExp = struct
  type options = {
    darwin : string;
    free_bsd : string;
    net_bsd : string;
    open_bsd : string;
    unix : string;
    win32 : string;
  }

  let deriver = "system"

  let supported_system =
    [ "default"; "darwin"; "free_bsd"; "net_bsd"; "open_bsd"; "unix"; "win32" ]

  let legal_options = "{ sys_name = string_litteral; ... }"

  let find_field_value fields name ~default =
    let value = ref default in
    List.iter
      (function
        | ( { txt = Lident n; _ },
            { pexp_desc = Pexp_constant (Pconst_string (v, _, _)); _ } )
          when String.equal n name ->
            value := v
        | _ -> ())
      fields;
    !value

  let parse_options expr =
    match expr.pexp_desc with
    | Pexp_record (fields, _) ->
        List.iter
          (function
            | ( { txt = Lident field; loc },
                { pexp_desc = Pexp_constant (Pconst_string _); _ } ) ->
                if not (List.mem field supported_system) then
                  Location.raise_errorf ~loc "%s does not support option %s"
                    deriver field
            | _ ->
                Location.raise_errorf ~loc:expr.pexp_loc
                  "%s support only option of form %s" deriver legal_options)
          fields;
        let default = find_field_value fields "default" ~default:"" in
        let darwin = find_field_value fields "darwin" ~default in
        let free_bsd = find_field_value fields "free_bsd" ~default in
        let net_bsd = find_field_value fields "net_bsd" ~default in
        let open_bsd = find_field_value fields "open_bsd" ~default in
        let unix = find_field_value fields "unix" ~default in
        let win32 = find_field_value fields "win32" ~default in
        { darwin; free_bsd; net_bsd; open_bsd; unix; win32 }
    | _ ->
        Location.raise_errorf ~loc:expr.pexp_loc
          "A record of form %s is expected" legal_options

  let expand ~ctxt env_expr =
    let system = parse_options env_expr in
    let str =
      match System.get () with
      | Ok Darwin -> system.darwin
      | Ok FreeBSD -> system.free_bsd
      | Ok NetBSD -> system.net_bsd
      | Ok OpenBSD -> system.open_bsd
      | Ok Unix -> system.unix
      | Ok Win32 -> system.win32
      | Error sys_name ->
          Location.raise_errorf ~loc:env_expr.pexp_loc "Unsupported system : %S"
            sys_name
    in
    let loc = Expansion_context.Extension.extension_point_loc ctxt in
    Ast_builder.Default.estring ~loc str
end

module GetSystemExp = struct
  let expand ~loc ~path:_ =
    (* let loc = { loc with loc_ghost = true } in *)
    let (module Builder) = Ast_builder.make loc in
    match System.get () with
    | Ok system ->
        Builder.(
          pexp_construct
            (Located.lident ("Ppx_system_runtime." ^ System.to_string system)))
          None
    | Error sys_name ->
        Builder.(
          pexp_construct
            (Located.lident "Ppx_system_runtime.Unknown")
            (Some (estring sys_name)))
end
