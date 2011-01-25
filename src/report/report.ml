(*
 * This file is part of Bisect.
 * Copyright (C) 2008-2011 Xavier Clerc.
 *
 * Bisect is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 3 of the License, or
 * (at your option) any later version.
 *
 * Bisect is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *)

open ReportUtils


let main () =
  ReportArgs.parse ();
  if !ReportArgs.files = [] then begin
    prerr_endline " *** warning: no input file";
    exit 0
  end;
  if !ReportArgs.outputs = [] then begin
    prerr_endline " *** warning: no output requested";
    exit 0
  end;
  let data =
    List.fold_right
      (fun s acc ->
        List.iter
          (fun (k, arr) ->
            let arr' = try (Hashtbl.find acc k) +| arr with Not_found -> arr in
            Hashtbl.replace acc k arr')
          (Common.read_runtime_data s);
        acc)
      !ReportArgs.files
      (Hashtbl.create 17) in
  let verbose = if !ReportArgs.verbose then print_endline else ignore in
  let search_file l f =
    let fail () = raise (Sys_error (f ^ ": No such file or directory")) in
    let rec search = function
      | hd :: tl ->
	  let f' = Filename.concat hd f in
	  if Sys.file_exists f' then f' else search tl
      | [] -> fail () in
    if Filename.is_implicit f then
      search l
    else if Sys.file_exists f then
      f
    else
      fail () in
  let search_in_path = search_file !ReportArgs.search_path in
  let generic_output file conv = ReportGeneric.output verbose file conv search_in_path data in
  let write_output = function
    | ReportArgs.Html_output dir ->
	mkdirs dir;
	ReportHTML.output verbose dir !ReportArgs.tab_size !ReportArgs.title !ReportArgs.no_navbar !ReportArgs.no_folding search_in_path data
    | ReportArgs.Xml_output file ->
	generic_output file (ReportXML.make ())
    | ReportArgs.Xml_emma_output file ->
	generic_output file (ReportXML.make_emma ())
    | ReportArgs.Csv_output file ->
	generic_output file (ReportCSV.make !ReportArgs.separator)
    | ReportArgs.Text_output file ->
	generic_output file (ReportText.make ()) in
  List.iter write_output (List.rev !ReportArgs.outputs)

let () =
  try
    main ();
    exit 0
  with
  | Sys_error s ->
      Printf.eprintf " *** system error: %s\n" s;
      exit 1
  | Unix.Unix_error (e, _, _) ->
      Printf.eprintf " *** system error: %s\n" (Unix.error_message e);
      exit 1
  | Common.Invalid_file s ->
      Printf.eprintf " *** invalid file: '%s'\n" s;
      exit 1
  | Common.Unsupported_version s ->
      Printf.eprintf " *** unsupported file version: '%s'\n" s;
      exit 1
  | Common.Modified_file s ->
      Printf.eprintf " *** source file modified since instrumentation: '%s'\n" s;
      exit 1
  | e ->
      Printf.eprintf " *** error: %s\n" (Printexc.to_string e);
      exit 1
