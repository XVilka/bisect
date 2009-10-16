(*
 * This file is part of Bisect.
 * Copyright (C) 2008-2009 Xavier Clerc.
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

(** This module defines the values related to command-line analysis. *)


type output_kind =
  | No_output
  | Html_output of string
  | Xml_output of string
  | Csv_output of string
  | Text_output of string
(** The type of output kinds. *)

val output : output_kind ref
(** Selected output kind. *)

val verbose : bool ref
(** Whether verbose mode is activated. *)

val tab_size : int ref
(** Tabulation size (HTML only). *)

val title : string ref
(** Page title (HTML only). *)

val separator : string ref
(** Separator (CSV only). *)

val no_navbar : bool ref
(** Whether navigation bar is disabled (HTML only). *)

val no_folding : bool ref
(** Whether folding is disabled (HTML only). *)

val files : string list ref
(** Files to gather (runtime data). *)

val parse : unit -> unit
(** Parses the command-line. *)
