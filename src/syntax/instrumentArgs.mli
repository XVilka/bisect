(*
 * This file is part of Bisect.
 * Copyright (C) 2008-2012 Xavier Clerc.
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


type mode =
  | Safe (** Original mode: calls to Bisect functions. *)
  | Fast (** Fast mode: storage/function local to module. *)
  | Faster (** Like fast mode, but thread-unsafe. *)
(** The type of instrumentation modes. *)

val mode : mode ref
(** Instrumentation mode. *)

val kinds : (Common.point_kind * (bool ref)) list
(* Association list mapping points kinds to whether they are activated. *)

val switches : (Arg.key * Arg.spec * Arg.doc) list
(** Command-line switches. *)

